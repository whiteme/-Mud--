--���߹����Խл���
require "map"
require "wait"
require "status_win"
hqg={
  new=function()
    local qg={}
	qg.caipulist={}
    setmetatable(qg,{__index=hqg})
	return qg
  end,
  caipulist={},
  co=nil,
  co2=nil,
  test_co=nil,
  get_cailiao=false,
  neili_upper=1.9,
}

--û��npcʱ�� ȷ�����Ƿ񵽴�׼ȷ�ص�
local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    if v==r then
		   return true
		end
	end
	return false
end

function hqg:_caipu()
-- �������� С����
   for j=1,table.getn(self.caipulist)-1 do
    for i=1,table.getn(self.caipulist)-1 do
      local current_item=self.caipulist[i]
	  local P=current_item[2]
	  local next_item=self.caipulist[i+1]
	  local B=next_item[2]
	  --print(P,B)
	  local C=zone(P)
	  local D=zone(B)
	   --print(C,D)
	  if C>D then
	   self.caipulist[i],self.caipulist[i+1]=self.caipulist[i+1],self.caipulist[i]  --����
	  end
    end
   end
   print("������")
   for _,i in ipairs(self.caipulist) do
      print(i[1],i[2],i[3])
   end
   self:test()
end

function hqg:NextPoint()
   print("���ָ̻�")
   coroutine.resume(hqg.co)
end

function hqg:NextPoint2()
   print("���ָ̻�")
   coroutine.resume(hqg.co2)
end

function hqg:checkPot(npc,roomno,id,silver,here)
      if is_contain(roomno,here) then
  	     print("�ȴ�0.1s,��һ������")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint2()
		   end
		   b:check()
		 end
		 f_wait(f,0.1)
	   else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
	      w=walk.new()
		  local al
		  al=alias.new()
		  al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		 al.circle_done=function()
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkPot(npc,roomno,id,silver,f2)
			 --self:checkBeauty(f2)
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:PayAgain(npc,id,silver,roomno)
		  end
		  w:go(roomno)
	   end
end

function hqg:PayAgain(npc,id,silver,roomno)
    wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:PayAgain(npc,id,silver)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      local f=function(r)
		     self:checkPot(npc,roomno,id,silver,r)
		  end
		  WhereAmI(f)
		  return
	  end
	  if string.find(l,npc) then
	     print("�ҵ�Ŀ��")
	     --�ҵ�
		  self:pay(id,npc,silver)
		  return
	  end
	  wait.time(6)
   end)
end

function hqg:return_hotPot(location,id,npc,silver)
  local n,rooms=Where(location)
      hqg.co2=coroutine.create(function()
	    for _,r in ipairs(rooms) do
		  print("Ŀ�귿��:",r)
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end

		  if location=="������������" then
		     self:giveup()
	           --[[ al.continue=function()
			    wait.make(function()
                    world.Execute("look;set look 1")
                    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)�趨����������look \\= 1",6)
	                if l==nil then
					   --al:NextPoint()
					   --world.Execute("look;set look 1")
					   return
	                end
	                if string.find(l,"�趨����������look") then
					   al:NextPoint()
					   return
	                end
					if string.find(l,npc) then
	                  print("�ҵ�Ŀ��")
	                 --�ҵ�
					  local id=w[2]
					  id=string.lower(id)
					  self:songlin(npc,id,cailiao,al)
		              return
	                end
	                wait.time(6)
                end)
			 end]]
			 return
	      end
		  w.user_alias=al
		  w.noway=function()
		    shutdown()
		    self:giveup()
		  end
		  --[[w.locate_fail_deal=function()
         --��λʧ�ܴ�����  ��ֹ�Ź��һ���
	      local _R
          _R=Room.new()
          _R.CatchEnd=function()
		    local error_alias=alias.new()
		    print("������:",_R.roomname)
            if _R.roomname=="�Ź��һ���" then
			  print("��λʧ�ܣ� �һ����У�")
			  error_alias.finish=function()
			   print("���һ���")
			   print("Ŀ�귿���:",targetRoomNo)
			   w:go(targetRoomNo)
			 end
		     error_alias:reset_taohuazhen()
			elseif _R.roomname=="С����" then
			  world.Send("order ����")
			  error_alias.finish=function()
			    w:go(targetRoomNo)
			  end
			  error_alias:order_chuan()
		    end
          end
			_R:CatchStart()
          end]]
		  w.walkover=function()
		    self:PayAgain(npc,id,silver,r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("û���ҵ�npc!!")
		self:giveup()
	   end)
	  self:NextPoint2()
end

function hqg:ATM_carry_silver(bank_roomno,CallBack)
  wait.make(function()
  world.Send("look silver")
   local l,w=wait.regexp("^(> |)(.*)������\\(Silver\\)|^(> |)��Ҫ��ʲô��$",5)
   if l==nil then
	 self:ATM_carry_silver(bank_roomno,CallBack)
     return
   end
   if string.find(l,"������") then
      --print(w[2])
	  local silver=ChineseNum(w[2])
	  if silver<99 then
	     local qu_silver=99-silver
	    local w=walk.new()
		w.walkover=function()
		   world.Send("qu "..qu_silver.." silver")
		   self:ATM_carry_silver(bank_roomno,CallBack)
		end
	    w:go(bank_roomno)
	  else
	    CallBack()
	  end
   end
   if string.find(l,"��Ҫ��ʲô") then
        local w=walk.new()
		w.walkover=function()
		   world.Send("qu 99 silver")
		   self:ATM_carry_silver(bank_roomno,CallBack)
		end
	    w:go(bank_roomno)
      return
   end
   wait.time(5)
  end)
end

function hqg:ATM(id,npc,silver)
   print("ûǮ��,ȡ���������?")
--ȷ����ǰλ��
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --���ݵ�ǰλ�� ǰ�������Ǯׯ
--{���� 410} {���� 1474} {���� 50} {�ɶ� 546} {���� 1973} {���� 1069} {���� 1119} {���� 1331} {���� 926}

	  --print("��ǰ�����",roomno[1])
	  local bank_roomno
	  local index=zone(_R.zone)
	  if index==1 then
	     bank_roomno=1331
	  elseif index==2 then
	     bank_roomno=1331
	  elseif index==3 then
	     bank_roomno=50
	  elseif index==4 then
	     bank_roomno=410
	  elseif index==5 then
	     bank_roomno=1474
	  elseif index==6 then
	     bank_roomno=1973
	  else
	     bank_roomno=926
	  end
	  local b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	      local f=function()
		     self:return_hotPot(_R.zone,_R.roomname,id,npc,silver)
		  end
          self:ATM_carry_silver(bank_roomno,f)
	  end
	  b:check()
   end
  _R:CatchStart()
--���� pay again
end

function hqg:pay(id,npc,silver)
  wait.make(function()
   world.Send("give "..silver.." silver to "..id)
   local l,w=wait.regexp("^(> |)"..npc.."����ͻȻ����ʲô�£�����ææ���߿��ˡ�$|^(> |)������û������������$|^(> |)��û����ô��İ�����$|^(> |)����û������ˡ�$",5)
   if l==nil then
       self:pay(id,npc,silver)
       return
   end
   if string.find(l,"����ͻȻ����ʲô��") then
      self.get_cailiao=true
      self:look_caipu()
	  return
	end
	if string.find(l,"������û����������") or string.find(l,"��û����ô��İ���") then
	   self:ATM(id,npc,silver)
	   return
	end
	if string.find(l,"����û�������") then
	   local f=function()
	     self:pay(id,npc,silver)
	   end
	   self:look_around(f)
	   return
	end
   wait.time(5)
  end)
end

local dx=nil

function hqg:follow_again(exits,f,npc,roomname,zone)
    wait.make(function()
     print("Ѱ��:",npc)
     local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)�趨����������look \\= \\\"YES\\\"",5)
	  if l==nil then  --�쳣
	     self:follow_again(exits,f,npc,roomname,zone)
         return
	  end
	  if string.find(l,npc) then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		 --Σ�յص�
		 --�����Ͻ�ɳĮ ���������� ������������
		 if (roomname=="�Ͻ�ɳĮ" and zone=="����") or (roomname=="������" and zone=="����") or (roomname=="������" and zone=="������") then
		   self:giveup()
		 else
	       world.Send(exits)
		   f()
		 end
		end
        b:check()
		return
	  end
	  if string.find(l,"�趨����������look") then
		 coroutine.resume(dx)
		 return
	  end
	  wait.time(5)
	end)
end

function hqg:look_dx(exits,f,npc)
     --print("look_dx:",exits)
     local _R=Room.new()
	 _R.CatchEnd=function()
	    world.Send("set look")
	 end
	 self:follow_again(exits,f,npc,_R.roomname,_R.zone)
	  _R:CatchStart(exits)
end

function hqg:look_around(f,npc)
    print("�����ܵ���")
    local _R
	_R=Room.new()
   _R.CatchEnd=function()
   --�鿴�������
	dx=coroutine.create(function()
	  local exits=Split(_R.exits,";")
	  --print("why")
      for _,e in ipairs(exits) do
	       --print(e)
		   self:look_dx(e,f,npc)
		   coroutine.yield()
	  end
	  self:giveup() --û�ҵ�
	 end)
	 coroutine.resume(dx)
   end
   _R:CatchStart()
end

function hqg:ask_cailiao(npc,id,cailiao)  --����û������ˡ�
  wait.make(function()
    --print(id,cailiao)
    world.Send("ask "..id.." about "..cailiao)
	local l,w=wait.regexp("^(> |)"..npc.."˵�������ٺ٣�����Ҫ��ʾ��ʾ�ɣ���(.*)�����Ӱɡ���|^(> |)"..npc.."�������ĵġ��š���һ�����ƺ�����û������˵ʲô��$|^(> |)"..npc.."����ͻȻ����ʲô�£�����ææ���߿��ˡ�$|^(> |)����û������ˡ�$|^(> |)"..npc.."˵����������ʲô����һ�ڼۣ��Ҷ�˵�ˣ���Ҫ�����ˡ���$",3)
--����˵�������ţ���Ҫ����ȥ�ɡ���
--�����������ĵġ��š���һ�����ƺ�����û������˵ʲô������˵�������ţ���Ҫ�Ļ�������ȥ�ɡ���
     if l==nil then
	    self:ask_cailiao(npc,id,cailiao)
	    return
	 end
    if string.find(l,"����Ҫ��ʾ��ʾ") then
	   --print(w[2])
	   local silver=w[2]
	   silver=ChineseNum(silver)
       self:pay(id,npc,silver)
	   return
	end
	if string.find(l,"�������ĵġ��š���һ�����ƺ�����û������˵ʲô") then
      self:ask_cailiao(npc,id,cailiao)
	  return
	end
    if string.find(l,"����û�������") then
	  local f=function()
	     self:ask_cailiao(npc,id,cailiao)
	  end
	   self:look_around(f,npc)
	   return
	end
	if string.find(l,"��Ҫ������") then
	   self:pay(id,npc,20)
	   return
	end
	if string.find(l,"����ͻȻ����ʲô��") then
	  self.get_cailiao=true
      self:look_caipu()
	  return
	end
	wait.time(3)
  end)
end

function hqg:follow(npc,id,cailiao,roomno)
  wait.make(function()
      id=string.lower(Trim(id))
      world.Send("follow " ..id)
	  local l,w=wait.regexp("^(> |)���������"..npc.."һ���ж���$|^(> |)���Ѿ��������ˡ�$|^(> |)����û�� "..id.."��$",5)
	  if l==nil then
	    self:follow(npc,id,cailiao,roomno)
	    return
	  end
	  if string.find(l,npc) or string.find(l,"���Ѿ���������") then
	    self:ask_cailiao(npc,id,cailiao)
	    return
	  end
	  if string.find(l,"����û��") then
		 self:checkNPC(npc,roomno,cailiao)
	     return
	  end
	  wait.time(5)
  end)
end

function hqg:checkPlace(npc,roomno,cailiao,here)
      if is_contain(roomno,here) then
  	     print("�ȴ�0.1,��һ������")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
		 end
		 f_wait(f,0.1)
	   else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
	      w=walk.new()
		  local al
		  al=alias.new()
		  al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.maze_done=function()
			 self:checkNPC(npc,roomno,cailiao,al.maze_step)
			 --self:checkBeauty(f2)
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno,cailiao)
		  end
		  w:go(roomno)
	   end
end


function hqg:checkNPC(npc,roomno,cailiao,CallBack)
   if self.get_cailiao==true then
      print("�Ѿ��ҵ��˲���")
	  self:look_caipu()
      return
   else
      print("Ѱ��NPC")
   end
   wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno,cailiao)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      local f=function(r)
		     self:checkPlace(npc,roomno,cailiao,r)
		  end
		  if CallBack~=nil then
		    WhereAmI(CallBack)
		  else
		    WhereAmI(f)
		  end
		  return
	  end
	  if string.find(l,npc) then
	     print("�ҵ�Ŀ��")
	     --�ҵ�
		  self:follow(npc,w[2],cailiao,roomno)
		  return
	  end
	  wait.time(6)
   end)
end

function hqg:songlin(npc,id,cailiao,alias)
	wait.make(function()
	  world.Send("ask "..id.." about "..cailiao)
	 local l,w=wait.regexp("^(> |)"..npc.."˵�������ٺ٣�����Ҫ��ʾ��ʾ�ɣ���(.*)�����Ӱɡ���|^(> |)"..npc.."�������ĵġ��š���һ�����ƺ�����û������˵ʲô��$|^(> |)"..npc.."����ͻȻ����ʲô�£�����ææ���߿��ˡ�$|^(> |)����û������ˡ�$",3)
     if l==nil then
	    self:songlin(npc,id,cailiao,alias)
	    return
	 end
    if string.find(l,"����Ҫ��ʾ��ʾ") then
	   --print(w[2])
	   local silver=w[2]
	   silver=ChineseNum(silver)
       world.Send("give "..id.." "..silver.." silver")
	   self.get_cailiao=true
	   alias:NextPoint()
	   return
	end
	if string.find(l,"�������ĵġ��š���һ�����ƺ�����û������˵ʲô") then
      self:songlin(npc,id,cailiao,alias)
	  return
	end
    if string.find(l,"����û�������") then
       alias:NextPoint()
	   return
	end
	if string.find(l,"����ͻȻ����ʲô��") then
	  self.get_cailiao=true
      alias:NextPoint()
	  return
	end
	wait.time(3)
	end)
end

function hqg:go(npc,location,cailiao)
	local ts={
	           task_name="���߹�����",
	           task_stepname="Ѱ�Ҳ���",
	           task_step=3,
	           task_maxsteps=4,
	           task_location=location,
	           task_description="Ѱ��"..npc.." ����:"..cailiao,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  local n,rooms=Where(location)
      hqg.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
		  print("Ŀ�귿��:",r)
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.maze_done=function()

			 self:checkNPC(npc,r,cailiao,al.maze_step)

		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  --print("���ָ̻�")
				  coroutine.resume(hqg.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764,cailiao)
		  end
		  al.out_zishanlin=function()
			   self.NextPoint=function()
				  --print("���ָ̻�")
				  coroutine.resume(hqg.co)
			   end
			   al:finish()
		  end
		  al.zishanlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,2464,cailiao)
		  end
		  w.user_alias=al
		  w.noway=function()
		    shutdown()
		    self:giveup()
		  end
		  w.walkover=function()
		    self:checkNPC(npc,r,cailiao)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("û���ҵ�npc!!")
		self:giveup()
	   end)
	  self:NextPoint()
end

function hqg:break_pfm()
end


--�����нڵ�ɴ���м���
function hqg:test()
   local exps=world.GetVariable("exps") or 0
   exps=tonumber(exps)
   --print(165073)
   for _,i in ipairs(self.caipulist) do
       local location=i[2]
       local n,rooms=Where(location)
	   --print("n:",n)

	   if n<=0 or zone_entry(location) or location=="���ԭ����" or location=="��ɽ����������" or (location=="����������" and exps<=1500000) then
	     print(location," �޷�����")
	     self:giveup()
		 return
	   end
	    --���� 1001 ���� Ŀ�귿���·��
		--2012-8-11 �޸��㷨
      hqg.test_co=coroutine.create(function()
		for _,r in ipairs(rooms) do
		    local mp=map.new()
			mp.Search_end=function(path,room_type)
			    if (path=="noway;" or path=="") then
					print(location," �޷�����")
	                self:giveup()
				    return
				end
				coroutine.resume(hqg.test_co)
			end
		    mp:Zone_Search(1001,r,true)
			coroutine.yield()
		end
	  end)
   end
   -- ·������

   --ȫ�����Ե���
   print("���Ե���")
   local b=busy.new()
	b.interval=0.5
	b.Next=function()
	  local item=self.caipulist[1]
	  self:go(item[1],item[2],item[3])
   end
   b:check()
end

function hqg:caipu_item()
   wait.make(function()
      local l,w=wait.regexp("^(> |)���Ѿ��ҵ���ԭ���У�.*$|^(\\S*)\\s+(\\S*)\\s+(\\S*)\\s*$",5)
	  if l==nil then
	     self:caipu_item()
	     return
	  end
	  if string.find(l,"���Ѿ��ҵ���ԭ��") then
		--self:_caipu()
		--print("end")
		self:_caipu()
	     return
	  end
      if string.find(l,"") then
	    --print("name:",w[2])
	    _item={w[2],w[3],w[4]}
		--print("error")
		table.insert(self.caipulist,_item)
		--print("error2")
		self:caipu_item()
	    return
	  end
	  wait.time(5)
   end)
end

function hqg:jobDone()
end

function hqg:reward()
local w
   w=walk.new()
   w.walkover=function()
       world.Send("ask hong about finish")
       wait.make(function()

	      local l,w=wait.regexp("^(> |)���߹��ӹ������ġ����˭������÷�����������������ϣ���Ц�������տɴ󱥿ڸ��ˡ�$|^(> |)���߹�˵���������������ˣ�����$|^(> |)���߹�˵���������н���ȥ��ʲô�������ʲô������$",5)
		  if l==nil then
		     self:reward()
		     return
		  end
		  if string.find(l,"���߹��ӹ������ġ����˭������÷��") then
		    self:jobDone()
			return
		  end
		  if string.find(l,"����������") or string.find(l,"���н���ȥ��ʲô�������ʲô��") then
		    self:jobDone()
			return
		  end
		  wait.time(5)
	   end)
   end
   w:go(1001)
end

function hqg:zuocai()
	local ts={
	           task_name="���߹�����",
	           task_stepname="����",
	           task_step=4,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
   wait.make(function()
   world.Send("zuo cai")
   local l,w=wait.regexp("�㽫ԭ�Ϸ���һ��һ���������һ�������ζ�ġ����˭������÷����|^(> |)��һʱ���񣬷Ŵ������ϣ��˷����Ƴɡ����˭������÷���Ĵ�û��ᡣ$",5)
   if l==nil then
      self:zuocai()
      return
   end
   if string.find(l,"�㽫ԭ�Ϸ���һ��") then
      self:reward()
      return
   end
   if string.find(l,"��һʱ���񣬷Ŵ�������") then
      world.Send("xbc")
      self:ask_job()
	  return
   end
   wait.time(5)
  end)
  end
  w:go(999)
end

function hqg:look_caipu()
  self.get_cailiao=false --��־λ��ֵ
  wait.make(function()
    self.caipulist={}
    world.Send("look cai pu")
	local l,w=wait.regexp("^(> |)�㻹������ԭ����δ�ҵ���$|^(> |)���Ѿ�������ԭ�ϣ��Ͽ��������˭������÷��\\\(zuo cai\\\)�ɡ�$",5)
	if l==nil then
	   self:look_caipu()
	   return
	end
	if string.find(l,"���Ѿ�������ԭ��") then
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
	    self:zuocai()
	   end
	   b:check()
	   return
	end
	if string.find(l,"�㻹������ԭ����δ�ҵ�") then
	   self:caipu_item()
	   return
	end
	wait.time(5)
  end)
end

function hqg:fail(id)
end
--���߹�˵��������λ��̨��Ǳ���Ѿ���ô���ˣ�������ȥ���������ɣ���
function hqg:catch_place()

   wait.make(function()
     local l,w=wait.regexp("^(> |)���߹�������һ������������������˭������÷���Ĳ��ס�$|^(> |)���߹�˵����������������ʲôԭ�϶�û�У������ٰ��������ɡ���$|^(> |)���߹�˵�������������Ѿ���Щԭ�ϣ��ȸ��㣬�������ȥ�Ұɣ���$|^(> |)���߹�˵�����������ڲ������㻹����ȥ��Ϣһ��ɡ���$|^(> |)���߹�˵��������Ķ���д�ֵȼ������ˣ��޷�������������ˡ���$|^(> |)���߹�˵�������ţ��Ҳ��Ǹ��������𣬿�ȥȡԭ�ϰ��������������ˣ���$|^(> |)���߹�˵��������λ.*��Ǳ���Ѿ���ô���ˣ�������ȥ���������ɣ���$",5)
	 if l==nil then
	   self:ask_job()
	   return
	 end

	 if string.find(l,"���߹�������һ�������������") or string.find(l,"�������Ѿ���Щԭ�ϣ��ȸ��㣬�������ȥ�Ұ�") or string.find(l,"������ʲôԭ�϶�û��") then
	   self:look_caipu()
	   return
	 end
	 if string.find(l,"�����ڲ������㻹����ȥ��Ϣһ���") then
	   self.fail(102)
	   return
	 end
	 if string.find(l,"��Ķ���д�ֵȼ������ˣ��޷��������������") then
	   self.fail(301)
	   return
	end
	if string.find(l,"�ţ��Ҳ��Ǹ��������𣬿�ȥȡԭ�ϰ���������������") then
	   self:giveup()
	   return
	end
	if string.find(l,"������ȥ����������") then
	   local b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	     self:jobDone()
	   end
	   b:check()
	   return
	end
     wait.time(5)
   end)
end

function hqg:ask_job()
	local ts={
	           task_name="���߹�����",
	           task_stepname="ѯ�ʺ��߹�",
	           task_step=2,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w
  w=walk.new()
  w.walkover=function()
    world.Send("ask hong about job")
	local l,w=wait.regexp("^(> |)������߹������йء�job������Ϣ��$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"������߹������й�") then
	  self:catch_place()
	  return
	end
	wait.time(5)
  end
  w:go(1001)
end

function hqg:giveup()
 local w
   w=walk.new()
   w.walkover=function()
       world.Send("ask hong about ����")
       wait.make(function()
	   --��Զ��˵������Ҷ֪�����û��������������Ϲ����ʲôѽ����
	   --��Զ��˵������Ҷ֪�����û��������������Ϲ����ʲôѽ����
	      local l,w=wait.regexp("^(> |)���߹�˵��������Ȼ�����ˣ�Ҳ�Ͳ���ǿ���ˡ���$|^(> |)���߹�˵���������н���ȥ��ʲô�������ʲô������$",5)
		  if l==nil then
		     self:giveup()
		     return
		  end
		  if string.find(l,"��Ȼ�����ˣ�Ҳ�Ͳ���ǿ����") or string.find(l,"���н���ȥ��ʲô�������ʲô��") then
		    --self:ask_job()
			self.fail(102)
			return
		  end
		  wait.time(5)
	   end)
   end
   w:go(1001)
end

function hqg:carry_silver()
  local  bank_roomno=1331
  wait.make(function()
  world.Send("i")
  world.Send("set look 1")
   local l,w=wait.regexp("^(> |)(.*)������\\(Silver\\)$|^(> |)�趨����������look \\= 1$",5)
   if l==nil then
	 self:carry_silver()
     return
   end
   if string.find(l,"������") then
      --print(w[2])
	  local silver=ChineseNum(w[2])
	  if silver<99 then
	     local qu_silver=99-silver
	    local w=walk.new()
		w.walkover=function()
		   world.Send("qu "..qu_silver.." silver")
		   self:carry_silver()
		end
	    w:go(bank_roomno)
	  else
	    self:ask_job()
	  end
	  return
   end
   if string.find(l,"�趨����������look") then
        local w=walk.new()
		w.walkover=function()
		   world.Send("qu 99 silver")
		   self:carry_silver()
		end
	    w:go(bank_roomno)
      return
   end
   wait.time(5)
  end)
end

function hqg:Status_Check()
	local ts={
	           task_name="���߹�����",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --��ʼ��
	  local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)
	    --[[if h.food<50 or h.drink<50 then
		   -- print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("sit chair;knock table;get mi tao;get cha;drink cha;drink cha;drink cha;eat mi tao;eat mi tao;eat mi tao;drop mi tao;drop tea")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:Status_Check()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(1960) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		else]]
		if  h.qi_percent<=70 or h.jingxue_percent<=80 then
		    print("����")
            local rc=heal.new()
			rc.saferoom=505
			rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			 rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		   --print(h.neili,h.max_neili*self.neili_upper," +++ ",self.neili_upper)
		    local x
			x=xiulian.new()
			x.halt=false
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun qi")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,10)
			    end
				if id==777 then
				   self:Status_Check()
				end
	           if id==202 then
			    --�������
				  local _R
                  _R=Room.new()
                  _R.CatchEnd=function()
                    local count,roomno=Locate(_R)
					local target_roomno=nearest_room(roomno)
                    local w
		            w=walk.new()
		            w.walkover=function()
			          x:dazuo()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:carry_silver()
			   else
	             print("��������")
				 world.Send("yun qi")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:carry_silver()
			end
			b:check()
		end
	end
	h:check()
end

