--[[
������˫��������ȥ���ƺ�����ʲô����ͷ��
��������Ķ�������˵������˵������������Ÿ������˸�Ư����С椣���ȥ����Ū����
����˵������������үү�ɻ��ȥ�ٻء���

��С��(Beauty)
����λ�б����߻�֮ò�ľ�ɫ��Ů���ڱ��ڵı��������е���ɽ��ˮ��
��������Ѫ������Ҫ��Ҷ֪��(Outstand)ǿ������Ů��
��������Լ��ʮ���ꡣ
�������տ���ȥ��ѧէ���������ƺ����ᡣ
����������Ѫ��ӯ����û�����ˡ�
�������ţ�
  ���廨СЬ(Xiuhua xie)
  ����ɼ��ȹ(Chang qun)

]]
local heal_ok=false
xueshan={
  new=function()
     local xs={}
	 setmetatable(xs,xueshan)
	 xs.beauty_list={}
	 xs.rooms={}
	 return xs
  end,
  xs_co=nil,
  xs_co2=nil,--��֧����
  id="Outstand",
  auto_kill=false,
  auto_kill_npc="",
  look_beauty=false,
  look_beauty_name="",
  look_beauty_place=nil,
  guard_name="",
  guard_id="",
  guard_real_id="",
  guard_party="",
  gurad_weapon="",
  beauty_name="",
  beauty_list={},
  rooms={},
  neili_upper=1.9,
  super_guard=false,
  win=false,
  location='',
  blacklist="",
  is_idle=false,
  run_kill=true,
  gender="����",
  try_fight=false,
}
xueshan.__index=xueshan

local ask_fight=0

function xueshan:NextPoint()
   print("���ָ̻�")
   coroutine.resume(xueshan.xs_co)
end

function xueshan:Search(rooms)
   local al
	al=alias.new()
	al:SetSearchRooms(rooms)
	local w
	w=walk.new()
	w.noway=function()
		     print("noway �¼�")
          local f=function()
		     self:NextPoint()
			 -- print("noway �¼�2")
		  end
		  f_wait(f,1)

	end
   for index,r in ipairs(rooms) do


		  --[[al.out_zishanlin=function()
			   self.NextPoint=function()
				  print("�ָ�����")
                  coroutine.resume(xueshan.co)
			   end
			   al:finish()
		  end
		  al.zishanlin_check=function()
			 self.NextPoint=function() al:NextPoint() end
			   local f1=function()
			      self:NextPoint()
			   end
             self:checkBeauty(f1)
		  end]]
		  if string.find(self.location,"����")==nil then
		     al.maze_done=function()
		       self:checkBeauty(al.maze_step)
		     end
		  end
		  al.break_in_failure=function()
		      self:giveup()
			  --self:beauty_exist()
			  --self:NextPoint()
		  end
		 --[[ al.circle_done=function()
		     print("����")
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkBeauty(f2)
		  end]]
		  al.nanmen_chengzhongxin=function()
       --1972 _ 2349
             world.Send("north")
             local _R
             _R=Room.new()
			_R.CatchEnd=function()
               local count,roomno=Locate(_R)
	           print("��ǰ�����",roomno[1])
	           if roomno[1]==2349 then
				  al:finish()
			   elseif roomno[1]==1972 then
			      print("�޷����������")
				  self:NextPoint()
	           else
                 local w
		         w=walk.new()
	          	 w.walkover=function()
		           al:nanmen_chengzhongxin()
		         end
	 	        w:go(1972)
			   end
            end
            _R:CatchStart()
          end
          al.noway=function()
		    self:NextPoint()
		  end
		  al.xiaojing2_yuanmen=function()
		     self:NextPoint()
		  end
		  w.user_alias=al

		  w.walkover=function()
		    if self.look_beauty==true then
			   print("����ŮҮ��")
			   --self.look_beauty=false
			   local f1=function()
			      print("ѩɽ�ص�����")
			      self:NextPoint()
			   end
		       self:checkBeauty(f1)
			else
			   print("��һ��")
			   self:NextPoint()
			end
		  end
		  --
		 -- print(index," index")

		  if index==1 then
		    w.current_roomno=1657
		  end
		  --print("Ŀ��:",r)
		  w:go(r)
		  coroutine.yield()
   end
end

function xueshan:Child_NextPoint()
   print("�ָ��ӽ���")
   coroutine.resume(xueshan.xs_co2)
end

function xueshan:Child_Search(rooms)
   local al
   al=alias.new()
   al:SetSearchRooms(rooms)
   for _,r in ipairs(rooms) do
          local w
		  w=walk.new()

		  --al.break_pfm=self.break_pfm
		  --[[al.out_zishanlin=function()
			   self.Child_NextPoint=function()
				  print("�ָ��ӽ���")
                  coroutine.resume(xueshan.co2)
			   end
			   al:finish()
		  end
		  al.zishanlin_check=function()
			 self.Child_NextPoint=function() al:NextPoint() end
             self:Child_checkBeauty()
		  end]]
		  al.maze_done=function()
			  self:Child_checkBeauty(al.maze_step)
		  end
		  al.break_in_failure=function()
		      --self:giveup()
			  self:Child_NextPoint()
		  end
		   al.xiaojing2_yuanmen=function()
		     self:Child_NextPoint()
		  end
		  w.user_alias=al
		  w.walkover=function()
			self:Child_checkBeauty()
		  end
		  w:go(r)
		  coroutine.yield()
   end
end

function xueshan:Child_checkBeauty(CallBack)
   wait.make(function()
	 world.AddTriggerEx ("beauty_name", "^(> |)(.*)\\(Beauty\\)$", "print(\"%2\")\nSetVariable(\"beauty_name\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 50)

      world.Execute("look beauty;set look 1")
      local l,w=wait.regexp("^(> |)��������Ѫ������Ҫ��.*\\\((.*)\\\)ǿ������Ů��$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		world.EnableTrigger("beauty_name",false)
		world.DeleteTrigger("beauty_name")
		self:Child_checkBeauty(CallBack)
		return
	  end
	  if string.find(l,"�趨����������look") then
		  world.EnableTrigger("beauty_name",false)
		  world.DeleteTrigger("beauty_name")
		  local b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		    if CallBack==nil then
			  self:Child_NextPoint()
			else
			  CallBack()
			end
		  end
		  b:check()
		  return
	  end
	  if string.find(l,"��������Ѫ������Ҫ��") then
		   world.EnableTrigger("beauty_name",false)
		   world.DeleteTrigger("beauty_name")
		   self.beauty_name=Trim(world.GetVariable("beauty_name"))
		   world.DeleteVariable("beauty_name")
		   print(self.beauty_name," ����")
	    if string.lower(self.id)==string.lower(w[2]) then
	       --�ҵ�
		   world.Send("yun recover")
		   self:follow()
		 else
            print("�����Լ���beauty")
			self:beauty_exist()
			table.insert(self.beauty_list,self.beauty_name)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   if CallBack==nil then
			     self:NextPoint()
			   else
			     CallBack()
			   end
			end
			b:check()
		 end
		  return
	  end
	  wait.time(6)
   end)
end

local round=1
function xueshan:beauty(location)
	local ts={
	           task_name="ѩɽ",
	           task_stepname="����",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  --world.AppendToNotepad (WorldName(),os.date()..": ѩɽ:".. location.."\r\n")
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ѩɽ����:����λ�� "..location, "white", "black") -- yellow on white
   if zone_entry(location)==true then
      self:giveup()
      return
   end
   self.location=location
   local exps=world.GetVariable("exps")
    if location=="�䵱ɽ��ɽСԺ" or location=="�������߿�" or location=="�ؽ���Ҷ��" or location=="��ɽ˼���¶���" or location=="����ׯ�Ź��һ���" or location=="�䵱ɽԺ��" or location=="��ɽ����������" or ((location=="���̷�����" or location=="���̵�����" or location=="����������" or location=="����������") and self.run_kill==true)  or (location=="��ɽ���ֲؾ����¥" and tonumber(exps)<=800000) then
	     self:giveup()
		 return
	end
	--print(location)
   local n,e=Where(location)
   local range
   if string.find(location,"�䵱��ɽ") then
      range=3
   else
      range=6
   end
	local rooms=depth_search(e,1)  --��Χ��ѯ

    self.rooms=rooms

     self:beauty_exist()
	self:auto_kill_check()
    if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	   print("ץȡ")
	   xueshan.xs_co=coroutine.create(function()
	    self:Search(rooms)
		print("û���ҵ�npc!!")
		if  table.getn(rooms)<=80 and round==1 then
		   print("���³���һ��")
		   self:Search(rooms)
		   self:giveup()
		else
		  self:giveup()
		end
	   end)
       --ColourNote("red","yellow","���ڸ���? ")
	   --print(self.super_guard)
	   local is_giveup=false
	    local blacklist=Split(self.blacklist,"|")
	    for _,b in ipairs(blacklist) do
	       local i=Split(b,"&")
		   local party_id=i[1]
		   local carry_weapon=i[2] or nil
		   local gender=i[4] or nil
		   local super=i[3] or nil
		   if party_id=="���ڸ���" and self.super_guard==true then
		      is_giveup=true
		      break
		   end

	    end
	   if is_giveup then
		  shutdown()
		  self:giveup()
	      return
	   end

		self:NextPoint()

	 end
	 b:check()
	else
	  print("û��Ŀ��")
	  self:giveup()
	end
end

function xueshan:jobDone() --�ص�����
end

function xueshan:after_giveup() --�ص�����
end

function xueshan:giveup()
    xueshan.xs_co=nil
	xueshan.xs_co2=nil
	world.Send("unset wimpy")
	world.Send("set wimpycmd hp")
	local pfm=world.GetVariable("pfm") or ""
    world.Send("alias pfm "..pfm)
	 world.EnableTrigger("beauty_place",false)
     world.DeleteTrigger("beauty_place")
	--  world.AppendToNotepad (WorldName(),os.date()..": ѩɽ���� \r\n")
	--CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ѩɽ����:����", "red", "black") -- yellow on white
 local w
   w=walk.new()
   w.walkover=function()
      world.Send("ask bao xiang about ʧ��")
	   wait.make(function()
	   local l,w=wait.regexp("^(> |)����������йء�ʧ�ܡ�����Ϣ��$",8)
	   if l==nil then
		 self:giveup()
	     return
	   end
	   if string.find(l,"����������йء�ʧ�ܡ�����Ϣ") then
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		       local f1=function()
	             self:Status_Check()
	           end
               Weapon_Check(f1)
		 end
		 b:check()
	     return
	   end
	   wait.time(8)
	 end)
   end
   w:go(1657)
end

function xueshan:auto_kill_check()
  wait.make(function()
    local l,w=wait.regexp("^(> |)������(.*)��ɱ���㣡$",5)
	if l==nil then
	  self:auto_kill_check()
	  return
	end
	if string.find(l,"��ɱ����") then
	  self.auto_kill=true
	  self.auto_kill_npc=w[2]
	  self:auto_kill_check()
	  return
    end
	wait.time(5)
  end)
end
-- �ƿ���(Beauty)

function xueshan:beauty_exist()
  --��������Ĺ����ɱ���㣡
  --print("auto kill ���")
   world.AddTriggerEx ("beauty_place", "^(> |)(.*) - .*$", "print(\"%2\")\nSetVariable(\"beauty_place\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 150)

  wait.make(function()
    local l,w=wait.regexp("^(> |)(.*)\\(Beauty\\)$",5)
	if l==nil then
	  self:beauty_exist()
	  return
	end
	if string.find(l,"Beauty") then
	--
	  if self:is_check_already(w[2])==true then
	     print("�Ѿ�����")
	     self:beauty_exist()
	     return
	  end
	  print("������Ů")
	  self.look_beauty=true
	  self.look_beauty_name=Trim(w[2])
	  local location=world.GetVariable("beauty_place")
	  location=Trim(location)
	  self.look_beauty_place=location
	  print("����:",self.look_beauty_name)
	  print("���ֵص�:",location)
	  world.EnableTrigger("beauty_place",false)
	  world.DeleteTrigger("beauty_place")
	  --world.DeleteVariable("beauty_place")
	  return
    end
	wait.time(5)
  end)
end

function xueshan:run(i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)������ʧ�ܡ�$|^(> |)������ʹ��.*��ʱ�޷�ֹͣս����$|^(> |)�����Ϊ������$|^(> |)�趨����������action \\= \\\"����\\\"$",1.5)
	   if l==nil then
	      self:run(i)
	      return
	   end
	   if string.find(l,"�����Ϊ����") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"��Ķ�����û����ɣ������ƶ�") or string.find(l,"������ʧ��") or string.find(l,"��ʱ�޷�ֹͣս��") then
		  self:run(i)
	      return
	   end
	   if string.find(l,"�趨����������action") then
		 world.DoAfter(1.5,"set action ����")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"����\\\"$|^(> |)�趨����������action \\= \\\"����\\\"$",5)
			if l==nil then
			   self:run(i)
			  return
			end
			if string.find(l,"����") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"����") then
			   shutdown()
			   world.Send("unset wimpy")
			   self:giveup()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function xueshan:flee(i)
  world.Send("go away")
  dangerous_man_list_add(self.guard_name) --����Σ������
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("Ѱ�ҳ���")
     local dx=_R:get_all_exits(_R)
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil then
	    --����������
	     local n=table.getn(dx)
	     i=math.random(n)
	 elseif i>table.getn(dx) then
	     i=1
	 end
	 print("���:",i)
	 local run_dx=dx[i]
	 print(run_dx, " ����")
	 local halt
	 if _R.roomname=="ϴ��ر�" then
	    world.Send("alias pfm "..run_dx..";set action ����")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set action ����")
	 end
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
	 self:run(i)
   end
   _R:CatchStart()
end
--[[
���ϲ�ͷ ��ʿ(Guo shi)
����λ�������ݵı��ڣ�����׳ʵ��һ�������书���֣�
��λ�����ƺ��������ݡ�
��������Լ��ʮ���ꡣ
�������տ���ȥ�ڻ��ͨ�������ƺ����ᡣ
���������꣬������״������̫�á�
�������ţ�
  ������(Cloth)
��װ���ţ�
  ������(Changjian)
]]

function xueshan:party(id,weapon,super_guard,gender)
   --party=id

	 local blacklist=Split(self.blacklist,"|")
	 for _,b in ipairs(blacklist) do
	     local i=Split(b,"&")
		 local party_id=i[1]
		 local carry_weapon=i[2] or nil
		 local super=i[3] or nil
		 local guard_gender=i[4] or nil
		 --print(party_id,"?",id," ",weapon)
		 if party_id=="���ڸ���" and super_guard==true then
			return false
		 end

		 if id==party_id then
		    if carry_weapon==nil or carry_weapon=="" then
			  if guard_gender==nil or guard_gender=="" then
			   if super==nil or super=="" then
			    return false
			   elseif super=="���ڸ���" and  super_guard==true then
			    return false
			   end
			  elseif guard_gender==gender then
               if super==nil or super=="" then
			    return false
			   elseif super=="���ڸ���" and  super_guard==true then
			    return false
			   end
	          end

			elseif carry_weapon==weapon then
			  if guard_gender==nil or guard_gender=="" then
			    if super==nil or super=="" then
			    return false
			   elseif super=="���ڸ���" and  super_guard==true then
			    return false
			   end
			 elseif guard_gender==gender then
			  if super==nil or super=="" then
			    return false
			   elseif super=="���ڸ���" and  super_guard==true then
			    return false
			   end
			  end
			end
		 end
	 end
	  return true
end

function xueshan:check_auto_kill_npc()
   wait.make(function()
     world.Send("look")
	 world.Send("set look 1")
	 world.Send("unset wimpy")
	 --�ϻ� �� �� �� Ұ�� ����
	 local regexp
	 if self.auto_kill_npc~="" and self.auto_kill_npc~=nil then
	    regexp=".*"..self.auto_kill_npc.."\\((.*)\\) <ս����>$|.*(����|����|�ϻ�|��|����|Ұ��|����|Ұ��|����|����|ֵ�ڱ�|����|����|����|����|�蹷|��������)\\((.*)\\).*|^(> |)�趨����������look \\= 1$"
	else
 	    regexp=".*(����|����|�ϻ�|��|����|Ұ��|Ұ��|����|����|����|ֵ�ڱ�|����|����|����|����|�蹷|��������)\\((.*)\\).*|^(> |)�趨����������look \\= 1$"
	end
	 local l,w=wait.regexp(regexp,10)
	 if l==nil then
	    self:check_auto_kill_npc()
	    return
	 end
	 if string.find(l,"ս����") then
	     local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"ֵ�ڱ�") then
		world.Send("kill zhiqin bing")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"����") then
	     world.Send("kill bangzhong")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
		 return
	 end

	 if string.find(l,"����") then
	    world.Send("kill ma zei")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"��") then
	    world.Send("kill bear")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"����") then
	    world.Send("kill bao")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	    return
	 end
	if string.find(l,"��") then

		if string.find(l,"����") then
		   self:check_auto_kill_npc()
		   return
		end
	    local id1=w[2]
		local id2=w[4]
		print(w[1],w[2],w[3],w[4])
		local id=""
		if id1~=nil then
		   id=id1
		end
		if id2~=nil then
		   id=id2
		end
		id=string.lower(id)
	    world.Send("kill snake")
		world.Send("kill "..id)
		world.Send("kill dushe")
		--world.Send("kill she")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"����") then
	    world.Send("kill jiao zhong")
		--world.Send("kill she")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"�ϻ�") then
	    world.Send("kill lao hu")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"Ұ��") then
	    world.Send("kill ye zhu")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end

	 if string.find(l,"����") or string.find(l,"����")  then
		 world.Send("kill mang")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"����") then
	    world.Send("kill e yu")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"��") or string.find(l,"��") then
		 world.Send("kill wolf")
		 world.Send("kill dog")
		 world.Send("kill lang")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"��������") then

		 world.Send("kill zunzhe")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"�趨����������look") then
	   self.auto_kill_npc=""
	   self.auto_kill=false
	   self:kill_guard(true)
	   return
	 end
     wait.time(10)
   end)
end

function xueshan:shield()

end
--�ܴ�������˼�����˵�����ⳡ�����������ˣ�����������
--���������Ц��˵���������ˣ�

function xueshan:loseFight()
    self.win=false
	shutdown()
	self:giveup()
end

function xueshan:knockdownNPC()
 local b=busy.new()
	 b.Next=function()
		print("��ͨ����")
		local rc=heal.new()
		--rc.saferoom=505
		--rc.teach_skill=teach_skill --config ȫ�ֱ���
		rc.heal_ok=function()
		   local kill_again=function()
		       print("����fight")
			   self:kill_success(self.guard_id,false)
			   self:combat()
			   self:wait_guard_idle()
			   self:wait_guard_die()
		   end

			local x
			x=xiulian.new()
			x.min_amount=10
			x.safe_qi=1000
			x.limit=true
			x.is_jobing=true
			x.danger=function()
			   world.Send("yun qi")
			   world.Send("yun jingli")
			   local w=walk.new()
			   w.walkover=function()
			      x:dazuo()
			   end
			   w:go(53)
			end
			x.fail=function(id)
             --print(id)
			    if id==201 and x.hp.jingxue_percent<100 then
				   rc:heal(false,true)
				   return
				end
				if id==201 or id==1 then
				  world.Send("yun recover")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
			    end
				if id==777 then
				   f=function()
				     --heal_ok=false
   				     kill_again()
				   end  --���
				   f_wait(f,0.5)
				end

			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
				  world.Send("yun recover")
			      kill_again()
			   else
	             print("��������")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()

		end
		rc:heal(true,false)

	 end
	 b:check()
end

function xueshan:status()
  local cd=cond.new()
	cd.over=function()
	          print("���״̬")
		     if table.getn(cd.lists)>0 then
		       local sec=0
		       for _,i in ipairs(cd.lists) do
                 local s,e=string.find(i[1],"��")
				 if s~=nil then
                    s=s%2
				 else
				    s=0
				 end
			     if i[1]=="�����ƶ�" or s==1 then
				   print("�ж���")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
			          self:status()
			        end
			        rc:qudu(sec,i[1],false)
				    return
			     end
				 if i[1]=="һָ���ھ�" or i[1]=="��Ϣ����" or i[i]=="����" or i[i]=="����" or i[i]=="����" or i[i]=="����" or i[i]=="һָ���ھ�" or i[i]=="��ָ��ͨ����" then
				    print("�ȴ�״̬��ʧ")
				    sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			            self:status()
					  end
					  f_wait(f,5)
			        end
			        rc:heal(true,false)
				    return
				 end
			   end
		     end
			self:knockdownNPC()
	end
	cd:start()
end

function xueshan:winFight()
     self.win=true
	 print("��Ӯ�ˣ���")
	 shutdown()
	 self:check_superguard_status(self.guard_id)
	 self:status()

end

function xueshan:fight_end(id)
    wait.make(function()
	      local regexp="^(> |)(.*)������Ц��˵���������ˣ�$|^(> |)(.*)˫��һ����Ц��˵�������ã�$|"
		  regexp=regexp.."^(> |)(.*)���һ�ݣ�˵�����������չ�Ȼ�������ⳡ�����������ˣ�$|^(> |)(.*)ʤ�����У����Ծ�����ߣ�Ц�������ã�$|"
		   regexp=regexp.."^(> |)(.*)��ɫ΢�䣬˵��������������$|^(> |)(.*)������˼�����˵�����ⳡ�����������ˣ�����������$|^(> |)(.*)���һ�ݣ�������Ҿ˵�����������ղ�������Ȼ������$"
		--[[	CYN "\n$N������Ц��˵���������ˣ�\n\n" NOR,
	CYN "\n$N˫��һ����Ц��˵�������ã�\n\n" NOR,
        CYN "\n$n���һ�ݣ�˵�����������չ�Ȼ�������ⳡ�����������ˣ�\n\n" NOR,
	CYN "\n$Nʤ�����У����Ծ�����ߣ�Ц�������ã�\n\n" NOR,
	CYN "\n$n��ɫ΢�䣬˵��������������\n\n" NOR,
	CYN "\n$n������˼�����˵�����ⳡ�����������ˣ�����������\n\n" NOR,
	CYN "\n$n���һ�ݣ�������Ҿ˵�����������ղ�������Ȼ������\n\n" NOR�ݵ»�������˼�����˵�����ⳡ�����������ˣ�����������,]]

	    local l,w=wait.regexp(regexp,10)
		if l==nil then
		    self:fight_end(id)
		   return
		end
		if string.find(l,"������Ц") or string.find(l,"˫��һ��") or string.find(l,"���չ�Ȼ����") or string.find(l,"Ծ������") or string.find(l,"���") or string.find(l,"��Ȼ����") then
		    local name=nil
			name=w[2]
			if name==nil or name=="" then
			   name=w[4]
			end
		   	if name==nil or name=="" then
			   name=w[6]
			end
			if name==nil or name=="" then
			   name=w[8]
			end
			if name==nil or name=="" then
			   name=w[10]
			end
			if name==nil or name=="" then
			   name=w[12]
			end
			if name==nil or name=="" then
			   name=w[14]
			end
			--print("1",w[1],"2",w[2],"3",w[3],"4",w[4],"5",w[5],"6",w[6],"7",w[7],"8",w[8])
			print(name," ս������")
			if name=="��" then
			   if w[2]=="��" or w[4]=="��" or w[8]=="��" then
			        self:winFight()
			   else

				   self:loseFight()
			   end
			elseif name==self.guard_name then
				if w[2]==self.guard_name or w[4]==self.guard_name or w[8]==self.guard_name then
			        self:loseFight()
			   else

				    self:winFight()
			   end
			else
			    self:fight_end(id)
			end
			return
		end

	end)
end

function xueshan:auto_pfm(cmd)
   print("��ǰpfm")
   world.Execute(cmd)
end

function xueshan:check_superguard_status(id)
   if self.super_guard==true and self.try_fight==true then
      wait.make(function()
	     local l,w=wait.regexp("^(> |)"..self.guard_name.."��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)"..self.guard_name.."��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��$",10)
		 if l==nil then
		    self:check_superguard_status(id)
		    return
		 end
		 if string.find(l,"����") then
			shutdown()
			print("guard ����")
            local b=busy.new()
			b.Next=function()
 			   self:guard_die()
			end
			b:check()
		    return
		 end
		 if string.find(l,"���˹�ȥ") then
            shutdown()
			print("guard ����")
            local b=busy.new()
			b.Next=function()
			   self:kill_success(id,false)
			end
			b:check()
		 end
	  end)

   end
end


local kill_count=0
function xueshan:kill_success(id,flag)
   if kill_count>10 then
      kill_count=0
	  --����10��ʧ�ܷ���
	  self:giveup()
	  return
   end
   self:shield()
   self:auto_pfm()
   wait.make(function()
     print("kill_success !!!!!!!!!! ","kill "..id," ���ڸ���:",self.super_guard)
	 --self:shield()
	 if self.super_guard==false or flag==true then
		--world.Send()
		--ֱ�ӷ���pfm
		world.Send("kill "..id)
		self.try_fight=false
		--print("kill:",flag)
		--self.super_guard=false
		--world.Send("sa beauty")
	 else
	    self.try_fight=true
	    self:fight_end(id)
		self:check_superguard_status(id)
	    world.Send("fight "..id)
		world.Send("set action ս��")
		--self.super_guard=false
	 end
	 --print(self.guard_name," guard")

	 local l,w=wait.regexp("^(> |)"..self.guard_name.."˵�����������й�������ˡ�����㡣��$|^(> |)���ͣ����ͣ����ͣ�$|^(> |)���ͣ����ͣ�$|^(> |)����Ҫ����������ͻȻ�������˽���һ�ģ��úÿ����䣬���Ҷ���$|^(> |)����û������ˡ�$|^(> |)��ٺ���Ц�˼�������ָ����.*���ᵯ�˵��ĭ��.*$|^(> |)������"..self.guard_name.."��������������$|^(> |)"..self.guard_name.."�Ѿ��޷�ս���ˡ�$",2)
--> ���ﲻ׼ս����
--�����һ�ݣ�˵�����������չ�Ȼ�������ⳡ�����������ˣ�
--������޸��Ǵ��һ������������һ���γ�������֪���q(�s3�t)�r��������Ŷ���ٺ�һЦ�������������ô�ү����������׳ʿ�ĸ��аɣ�
     if l==nil then
	    self:kill_success(id,flag)
	    return
	 end
	 if string.find(l,"����") then
	     --self:checkfight()
	     return
	 end
	 if string.find(l,"�����й�������") then
	     if self.super_guard==true then
		    self:giveup()
		 else
		     self:kill_success(id,true)
		 end
	 end
	 if string.find(l,"������������") then
	    if self.super_guard==true then
		   print("����guard ������fight")
		   print("�Ƿ��Ӯ����>",self.win)
		   if self.win==false then
		      self:giveup()
		   else
		     local f=function()
			   if ask_fight>=3 then
			     self:kill_success(id,true)
			   else
			     self:kill_success(id,false)
			   end
			 end
			 ask_fight=ask_fight+1
			 --world.Send("ask "..self.guard_id.." about ����")
			 print("�ȴ�1��")
			 f_wait(f,1)
		   end
		   --print("����Ƿ�������")
		else
		   self:kill_success(id,true)
	    end
		 return
	 end
	 if string.find(l,"�Ѿ��޷�ս����") then
	   print("����")
	   self:kill_success(id,true)
	   return
	 end
	 if string.find(l,"����û�������") then
	    world.Send("sa beauty")
		kill_count=kill_count+1
		self:kill_success(id,flag)
	    return
	 end
	 if string.find(l,"��ٺ���Ц�˼���") then
	      local b
		  b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		     self:reward()
		  end
		  b:check()
	    return
	 end
	 if string.find(l,"����Ҫ��������") then
	    shutdown()
		local f=function()
		  local b=busy.new()
		  b.interval=0.5
		  b.Next=function()
		    self:follow()
		  end

		  b:check()
		end
		f_wait(f,3)
	    return
	 end
     wait.time(2)
   end)
end
--
--[[
��װ���ţ�
  ������(Tie bi)
]]
function xueshan:check_guard()
   wait.make(function()
     local l,w=wait.regexp("^(> |)��λ�����ƺ�����(.*)��$|^(> |)  ��(.*)\\((.*)\\)|^(> |)����ΰ���̫�ã�����������ر�Ӿ��������ģ���˵�������Ǵ��ڸ����أ�$|^(> |)(.*)�����ţ�$",5)
	 if l==nil then
	   self:check_guard()
	   return
	 end

	 if string.find(l,"���ڸ���") then
	    print("���ڸ���")
		CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ѩɽ����:���ڸ���", "red", "black") -- yellow on white
				--[[������ϥ���£���ʼ�˹����ˡ�
����������һ�����ָֻ��糣��

����Ź��󷢺ٺ�һЦ�������������ô�ү����������׳ʿ�ĸ��аɣ�]]
	    self.super_guard=true
		self:check_guard()
	    return
	 end
	 if string.find(l,"������") then
	     local gender=w[7]
		 if Trim(gender)=="��" then
		    self.gender="����"
		 else
		    self.gender="Ů��"
		 end
	     self:check_guard()
		 return
	 end
	 if string.find(l,"��λ�����ƺ�����") then
	    self.guard_party=w[2]
		self:check_guard()
	    return
	 end
	 if string.find(l,"��") then
	    self.guard_weapon=w[4]
		self:check_guard()
		return
	 end
	 wait.time(5)
   end)
end

function xueshan:sure_enemy_party()
end


function xueshan:look()
     _R=Room.new()
        _R.CatchEnd=function()
          local count,roomno=Locate(_R)
		  print("����ս�������:",roomno[1])
		   _G["fight_Roomno"]=roomno[1]

	    end
	_R:CatchStart()
end

local function get_dir(dx)
   if dx=="up" then
      return "down"
	elseif dx=="down" then
	   return "up"
   elseif dx=="east" then
      return "west"
	elseif dx=="west" then
	  return "east"
	elseif dx=="north" then
	  return "south"
	elseif dx=="south" then
	  return "north"
	elseif dx=="northwest" then
	  return "southeast"
	elseif dx=="northeast" then
	  return "southwest"
	elseif dx=="southwest" then
	   return "northeast"
	elseif dx=="southeast" then
	   return "northwest"
	elseif dx=="enter" then
	  return "out"
	elseif dx=="out" then
	  return "enter"
	elseif dx=="southdown" then
	  return "northup"
	elseif dx=="northup" then
	  return "southdown"
	elseif dx=="eastup" then
	  return "westdown"
	elseif dx=="westdown" then
	   return "eastup"
	elseif dx=="northdown" then
	   return "southup"
	elseif dx=="southup" then
	   return "northdown"
	elseif dx=="eastdown" then
	    return "westup"
	elseif dx=="westup" then
	    return "eastdown"
   end
end

local test_count=0
local escape_test_count=0
function xueshan:wait_back(id,dir,select_pfm)


	 --world.Send("set action ����")
	 wait.make(function()
	     local l,w=wait.regexp("^(> |)����û������ˡ�$|^(> |)��ٺ���Ц�˼�������ָ����.*���ᵯ�˵��ĭ��.*$",1)
		 if l==nil then
		     escape_test_count=escape_test_count+1
			 print("�������ܴ���:",escape_test_count)
			 if escape_test_count<8 then
			    world.Send("sa beauty")
		        world.Send("kill "..id)
				world.Send("yun qi")
			    world.Execute(select_pfm)
		        self:wait_back(id,dir,select_pfm)
			 else
                self:escape_kill(id,dir,true)
			 end
		     return
		 end
		 if string.find(l,"���ᵯ�˵��ĭ") then
		    shutdown()
			 local b=busy.new()
			 b.Next=function()
		       self:reward()
			end
			b:check()
		    return
		 end
	     if string.find(l,"����û�������") then

		     local b=busy.new()
			 b.Next=function()
                 local reversal_dir=get_dir(dir)
				 world.Send("yun qi")
				 world.Send("yun jingli")
				 print(test_count)

				 if test_count>5 then
				    shutdown()
				    self:giveup()
                    return
				 else
				     test_count=test_count+1
				 end
				 self:damage(id,reversal_dir,dir)
				 --world.Send(reversal_dir)
				 --self:escape_kill(id,dir)
			 end
			 b:check()
		 end
	 end)

end

function xueshan:escape_success()
   wait.make(function()
     local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"����\\\"$",5)
	 if l==nil then
	     self:escape_success()
	     return
	 end
	 if string.find(l,"�趨��������") then
	    test_count=0
	    return
	 end

   end)
end
--  ���Ǵ��� ��ǿ(Zhu qiang) <���Բ���>
--�������־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
--  �ܾ�ᰵ�ʬ��(Corpse)
function xueshan:escape_guard_idle()
   print("escape guard idle ")
    wait.make(function()  --������Ȫ��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
     --print(npc.."��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��")
	 --ŷ������־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
	 print(self.guard_name," ����û�")
	 local id=self.guard_real_id
	 local name=self.guard_name
      print("real id "..id)
     local l,w=wait.regexp("^(> |)(.*)��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��$|^(.*)\\\("..id.."\\\) \\\<���Բ���\\\>$|^.*"..name.."��ʬ��\\\(Corpse\\\)$",5)
     if l==nil then
	   self:escape_guard_idle()
	   return
	 end
	 if string.find(l,"��־�Ժ�������һ������") then
	    print(self.guard_name,w[2])
	    if string.find(self.guard_name,w[2]) then
		   self.is_idle=true
		else
           self:escape_guard_idle()
		end
	 end
	 if string.find(l,"���Բ���") then
	     self.is_idle=true
	    return
	 end
	 if string.find(l,"ʬ��") then
	    self.is_idle="dead"
		return
	 end

	end)
end

function xueshan:damage(id,reversal_dir,dir) --��ɱ ��Ѫ
   local h=hp.new()
	h.checkover=function()
	   print("���˳̶�",h.qi_percent)
	   local g=h.max_jingli/2
	   print(h.jingli,"/",h.max_jingli," ",g)
        if h.qi_percent<100 and h.qi_percent>=70 then
		    local b=busy.new()
			b.Next=function()
				print("��ͨ����")
                local rc=heal.new()
			    rc.heal_ok=function()
			        world.Send("yun qi")
					self:damage(id,reversal_dir,dir)
			    end
			    rc:heal(true,false)
			end
			b:check()
		elseif h.qi_percent<70 then
	      --self:recover(true)
		   self:giveup()
	    elseif h.jingxue_percent<=80 then
	       self:giveup()
 	   elseif h.neili<=h.max_neili*1.2 then
	        local x
			x=xiulian.new()
			x.min_amount=10
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.danger=function()
			   world.Send("yun qi")
			   world.Send("yun jingli")
			   local w=walk.new()
			   w.walkover=function()
			      x:dazuo()
			   end
			   w:go(53)
			end
			x.fail=function(id)

				  world.Send("yun recover")
				  world.Send("yun jing")
				  if id==202 then
				     print("�޷������ķ��䣡��")
				      --world.Send(reversal_dir)
		              --self:escape_kill(id,dir)
					 self:giveup()
				  else
	                local f
		            f=function() x:dazuo() end  --���
				    f_wait(f,0.5)
				  end
			end
			x.success=function(h)
               world.Send("yun qi")
			   self:damage(id,reversal_dir,dir)
			end
			x:dazuo()
		elseif h.neili<500 then
		    self:giveup()
	   else
	      world.Send(reversal_dir)
		  self:escape_kill(id,dir)
	   end
	end
	h:check()
end

local function special_room(relation)
  if relation=="�������᷿���������᷿������" or relation=="���ȣ����ȩ����ȩ��᷿������" then
    return 2
  else
    return 1
  end
end

function xueshan:escape_kill(id,g_dir,reset)
    local f=function(x_dir)
            local select_pfm
			local xs_pfm=world.GetVariable("xs_pfm") or ""
			select_pfm=world.GetVariable(xs_pfm) or ""
             if select_pfm  == "" then
		        select_pfm=world.GetVariable("pfm") or ""
		     end
			 print("npc ���:",self.is_idle)
			 escape_test_count=0
			 if self.is_idle==false then
		       world.Send("alias pfm "..x_dir.."")
		       world.Send("set wimpy 100")
	           world.Send("set wimpycmd halt\\pfm\\hp\\set action ����")
			   self:wait_back(id,x_dir,select_pfm)
			   self:escape_success()
			 elseif self.is_idle=="dead" then  -- guard ֱ�Ӵ���
			    print("guard ����")
				self:guard_die()
				return
			 else
			   world.Send("alias pfm")
			   world.Send("unset wimpy")
			   world.Send("set wimpycmd hp")
			   self:wait_back(id,x_dir,select_pfm)
	         end

             world.Send("kill "..id)
             world.Execute(select_pfm)

	end
	if g_dir==nil or reset==true then
        _R=Room.new()
        _R.CatchEnd=function()
		     self.is_idle=false
			 self:escape_guard_idle()
             local count,roomno=Locate(_R)
			   print("����ս�������:",roomno[1])
		     _G["fight_Roomno"]=roomno[1]
			 --print(_R.Exits)
			 --local dir = Split(_R.Exits,";")
			 print("Ѱ�ҳ���")
             local dx=_R:get_all_exits(_R)
	          --for _,d in ipairs(dx) do
	            --print("exit:",d)
			 --end
			 local r=special_room(_R.relation)
			 local _dx=dx[r]
			 if g_dir==nil then
			     --print(_dx)
			     f(_dx)
			 else
			    for index,dir in ipairs(dx) do
				    if dir==g_dir then
					    local i=index+1
						if dx[i]==nil then
						    _dx=dx[1]
							print(_dx)
			                f(_dx)
						else
						    _dx=dx[i]
                            print(_dx)
			                f(_dx)
						end
						return
					end

				end
			 end

	    end
	   _R:CatchStart()
   else
        f(g_dir)
   end

end

function xueshan:kill_guard(flag)
    world.Send("yun recover")
    world.AddTriggerEx ("guard_id", "^(> |)(.*)\\((.*)\\)$", "print(\"%2\")\nSetVariable(\"guard_name\",\"%2\")\nprint(\"%3\")\nSetVariable(\"guard_id\",\"%3\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 150)
    world.Send("sa beauty")
	world.Send("look guard")
	self:check_guard()
	world.Send("set look")

	wait.make(function()
	  local l,w=wait.regexp("^(> |)��Ҫ��ʲô��$|^(> |)�趨����������look \\= \"YES\"$",5)

	   if l==nil then
	       world.EnableTrigger("guard_id",false)
		   world.DeleteTrigger("guard_id")
		   world.DeleteTrigger("guard_name")
	      self:kill_guard(flag)
		  return
	   end
	   --> ���ϲ�ͷ ��Т(Xiao xiao)
	   if string.find(l,"�趨����������look") then
	     shutdown()
	   --if string.find(l,"��λ�����ƺ�����") then
	     world.EnableTrigger("guard_id",false)
		 world.DeleteTrigger("guard_id")
		 local id=world.GetVariable("guard_id")
		 world.DeleteVariable("guard_id")
		 local name=world.GetVariable("guard_name")
		 world.DeleteTrigger("guard_name")
         self.guard_real_id=id
		 id=string.lower(id)
	      print(w[2])
	      local family=self.guard_party--Trim(w[2])
		  local weapon=self.guard_weapon
		  local super_guard=self.super_guard
		  local run_kill=self.run_kill --��ɱ
		  local gender=self.gender
		  -- world.AppendToNotepad (WorldName().."_ѩɽ����:",os.date()..": ѩɽ:guard ���� ".. family.." weapon "..self.guard_weapon.."\r\n")
		   	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ѩɽ����:���� ".. family.." weapon "..self.guard_weapon, "white", "black") -- yellow on white
			local ts={
	           task_name="ѩɽ",
	           task_stepname="ս��",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description=Split(name," ")[2] .." ����:"..family.." ����:"..weapon,
	        }
	        local st=status_win.new()
	         st:init(nil,nil,ts)
	         st:task_draw_win()

			 print(gender)
			 print(family)
			 print(weapon)

          local result=self:party(family,weapon,super_guard,gender)
		  print("result",result)
		  if result==true then
		      self:auto_pfm()
		     print("�������Σ�ն���")
			    self:sure_enemy_party()
                self.guard_id=id
				self.guard_name=Split(name," ")[2]
			 --if super_guard==true then
			   --�ر���ɱ
			  if run_kill==true then
			    self:escape_kill(id)  --��ɱ
                self:wait_guard_die()
			  else
			    self:kill_success(id,false)
	            self:combat()
				self:wait_guard_idle()
				self:wait_guard_die()
			  end
				--return
			 --end
			 --[[self:look()
		     if flag==true and self.auto_kill==false then  --���
				self:sure_enemy_party() --����npc ������ʹ�ò�ͬӦ��skill
				self:kill_success(id,true)
				self.guard_id=id
				self.guard_name=Split(name," ")[2]
	            self:combat()
				self:wait_guard_idle()
				self:wait_guard_die()
		     else
			    self:check_auto_kill_npc()
             end]]

		  elseif result==false then
		    --self.super_guard=true
			--print("�����б�����ݣ����ԣ���")
			 --print("�������Σ�ն���")
			 --print("ʹ����ɱ")
             --self:look()
		     --[[if flag==true and self.auto_kill==false then  --���
				self:sure_enemy_party() --����npc ������ʹ�ò�ͬӦ��skill
	            --self:kill_success(id,false)
				self:kill_success(id,true)
				self.guard_id=id
				self.guard_name=Split(name," ")[2]
	            self:combat()
				self:wait_guard_idle()
				self:wait_guard_die()
		     else
			    self:check_auto_kill_npc()
             end]]
		  --else
		     print("fangqi")
		     self:giveup()
		  end
		  --end
	      return
	   end
	   if string.find(l,"��Ҫ��ʲô") then
	      world.EnableTrigger("guard_id",false)
		  world.DeleteTrigger("guard_id")
		  world.DeleteTrigger("guard_name")
	      --print
		  self:beauty_exist()
		  self:NextPoint()
	      return
	   end
	   wait.time(5)
	end)
end


function xueshan:guard_idle()

end

function xueshan:wait_guard_idle()
   wait.make(function()  --������Ȫ��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
     --print(npc.."��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��")
	 --ŷ������־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
	 --print(self.guard_name," ����û�")
     local l,w=wait.regexp("^(> |)(.*)��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��$",5)
     if l==nil then
	   self:wait_guard_idle()
	   return
	 end
	 if string.find(l,"��־�Ժ�������һ������") then
		print(self.guard_name,w[2])
	    if string.find(self.guard_name,w[2]) then
		   self:guard_idle()
		else
           self:wait_guard_idle()
		end
	    return
	 end
	 --wait.time(5)
   end)
end

function xueshan:follow()
   wait.make(function()
     world.Send("follow beauty")
	 local l,w=wait.regexp("^(> |)���������(.*)һ���ж���$|^(> |)����û�� beauty��$|^(> |)���Ѿ��������ˡ�$",5)
	  if l==nil then
	    self:follow()
	    return
	  end
	  if string.find(l,"����û�� beauty") then
	    self:beauty_exist()
	    self:NextPoint()
	    return
	  end
	  if string.find(l,"���������") then
	    if w[2]==self.beauty_name then
		   --self:kill_guard()
		   self:check_auto_kill_npc()
		 else
		  print("����Ŀ��!!!")
		  world.Send("follow none")
		  local f1=function()
			 self:NextPoint()
		  end
		  self:checkBeauty(f1)
		end
		 return
	  end
	  if string.find(l,"���Ѿ���������") then
	      world.Send("follow none")
		  self:follow()
		  return
	  end
	  wait.time(5)
   end)
end

function xueshan:is_check_already(beauty_name)
  print("target:",beauty_name)
  for _,g in ipairs(self.beauty_list) do
     print(g)
     if g==beauty_name then
	     print("--------------")
	    return true
	 end
  end
  print("--------------")
  return false
end

function xueshan:Check_Point_Beauty()

	 local n,e=Where(self.look_beauty_place) --��ⷿ����
			   --��������Χ�󽻼�
	 local target_room={}
	  for _,r in ipairs(self.rooms) do
			      for _,t in ipairs(e) do
				    if t==r then
					  print("roomno:",t)
					  table.insert(target_room,t)
					end
				  end
	  end
       print("�ӽ���")
	   xueshan.xs_co2=coroutine.create(function()
            self:Child_Search(target_room)
		 --�ص���������ȥ
		   print("�ص���������ȥ!")
		   self:beauty_exist()
		   self:NextPoint()
	   end)
	   self:Child_NextPoint()
end

function xueshan:checkBeauty(CallBack)

   wait.make(function()
   --[[��С��(Beauty)
����λ�б����߻�֮ò�ľ�ɫ��Ů���ڱ��ڵı��������е���ɽ��ˮ��
��������Ѫ������Ҫ��Ҷ֪��(Outstand)ǿ������Ů��]]
      world.AddTriggerEx ("beauty_name", "^(> |)(.*)\\(Beauty\\)$", "print(\"%2\")\nSetVariable(\"beauty_name\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 50)

      world.Execute("look beauty;set look 1")
      local l,w=wait.regexp("^(> |)��������Ѫ������Ҫ��.*\\\((.*)\\\)ǿ������Ů��$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		world.EnableTrigger("beauty_name",false)
		world.DeleteTrigger("beauty_name")
		self:checkBeauty(CallBack)
		return
	  end
	  if string.find(l,"�趨����������look") then
		world.EnableTrigger("beauty_name",false)
		world.DeleteTrigger("beauty_name")
	      --û���ҵ�
		   print(self.look_beauty)
		   print(self.look_beauty_name)
		   print(self:is_check_already(self.look_beauty_name),"->���")
		   if self.look_beauty==true then --·�Ͼ���
			   self.look_beauty=false

			   if self:is_check_already(self.look_beauty_name)==false and not (self.look_beauty_place=="ɽ·" and self.location=="���ݳ�ɽ·") then
		         --print("�ص�")
                 self:Check_Point_Beauty()--���
			   else
				 print("������Ů��� ������")
				 self:beauty_exist()
                 local b=busy.new()
                 b.interval=0.3
                 b.Next=function()
		           CallBack()
                 end
                 b:check()
			   end
		   else
			   print("������Ů��� ������")
		       self:beauty_exist()
               local b=busy.new()
               b.interval=0.3
               b.Next=function()
		         CallBack()
               end
               b:check()
		   end
		  return
	  end
	  if string.find(l,"��������Ѫ������Ҫ��") then
		   world.EnableTrigger("beauty_name",false)
		   world.DeleteTrigger("beauty_name")
		   self.beauty_name=Trim(world.GetVariable("beauty_name"))
		   world.DeleteVariable("beauty_name")
		   print(self.beauty_name," ����")
	    if string.lower(self.id)==string.lower(w[2]) then
	       --�ҵ�
		   world.Send("yun recover")
		   self:follow()
		 else
            print("�����Լ���beauty,�����ų��б���!")
			table.insert(self.beauty_list,self.beauty_name)
			 print("������Ů��� ������")
			 self:beauty_exist()
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   CallBack()
			end
			b:check()
		 end
		  return
	  end
	  wait.time(6)
   end)
end

function xueshan:eat_xieqiwan()
    wait.make(function()
      world.Send("fu xieqi wan")
	  local l,w=wait.regexp("^(> |)�����һ��а���裬��ʱ�о��������а����$",5)
	  if l==nil then
	    self:eat_xieqiwan()
	    return
	  end
	  if string.find(l,"�����һ��а����") then
	    self:ask_job()
		return
	  end
	  wait.time(5)
	end)
end

function xueshan:look_xieqiwan()
--  ��ʮ�����Ϣ��(Neixi wan)
 wait.make(function()
   world.Send("i")
   world.Send("set look")
   local l,w=wait.regexp("^(> |)(.*)��а����\\(Xieqi wan\\)$|^(> |)�趨����������look \\= \\\"YES\\\"",5)
   if l==nil then
      self:look_xieqiwan()
      return
   end
   if string.find(l,"а����") then
	  self:eat_xieqiwan()
	  return
   end
   if string.find(l,"�趨����������look ") then
	  self:buy_xieqiwan()
	  return
   end
   wait.time(5)
  end)
end

function xueshan:guard_die()  --���������¼�
end

function xueshan:wait_guard_die()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",5)
	 if l==nil then
	    self:wait_guard_die()
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
	    print(self.guard_name,w[2])
	    if string.find(self.guard_name,w[2]) then
		   self:guard_die()
		else
           self:wait_guard_die()
		end
	    return
	 end
	 --|^(> |)��ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪���ˡ���$
	 --[[if string.find(l,"��ֻ����ͷ������") then
	    print("�ε�")
		local f=function()
		   self:is_combat()
		end
		f_wait(f,5)
		return
	 end]]
	 wait.time(5)
   end)
end

function xueshan:qu_gold()
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
        world.Send("qu 2 gold")
		local l,w=wait.regexp("^(> |)���������ȡ�������ƽ�$|^(> |)��û�д���ô���Ǯ��$",5)
		print("����")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold()
		   return
		end
		if string.find(l,"���������") then
		   --�ص�
		   self:buy_xieqiwan()
		   return
		end
		if string.find(l,"��û�д���ô���Ǯ") then
		  world.Send("quit")
		  return
		end
		wait.time(5)
	  end)
   end
   w:go(410)
end

function xueshan:buy_xieqiwan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy xieqi wan")
	 local l,w=wait.regexp("����.*�ļ۸��ҩ���ƹ�����������һ��а���衣|^(> |)������Ķ���������û�С�$|^(> |)��⵰��һ�ߴ���ȥ��$|^(> |)������Ǯ�����ˣ���Ʊ��û���ҵÿ���$",5)
	 if l==nil then
	   self:buy_xieqiwan()
	   return
	 end
	 if string.find(l,"������Ķ���������û��") then
	   local f=function()
	     self:buy_xieqiwan()
	   end
	   print("5s �Ժ����")
	   f_wait(f,5)
	   return
	 end
	 if string.find(l,"һ��а����") then
	    self:eat_xieqiwan()
	    return
	 end
	 if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
	    self:qu_gold()
	    return
	 end
	 wait.time(5)
	end)
 end
 w:go(413)
end

function xueshan:is_super_guard()
  wait.make(function()
    local l,w=wait.regexp("^(> |)��������Ķ�������˵�����������Ƚ����ѣ����в�Ҫ��ǿ��$|^(> |)����˵������������үү�ɻ��ȥ�ٻء���$",5)
	if l==nil then
	   return
	end
	if string.find(l,"��ȥ�ٻ�") then
	    self.super_guard=false
	   return
	end
	if string.find(l,"�������Ƚ�����") then
	    world.ColourNote("red","yellow","���ڸ���")
		self.super_guard=true
	   return
	end
  end)
end

function xueshan:xunwen()
    wait.make(function()
	--����˵�������ҿ��㲻���ĺ�������үү�Ҳ�ϲ������  ��������Ķ�������˵������˵�������ʨ��������˸�Ư����С椣���ȥ����Ū����
		local l,w=wait.regexp("^(> |)��������Ķ�������˵������˵���(.*)�������˸�Ư����С椣���ȥ����Ū����$|^(> |)����˵��������Ҫ����������үү����һ�ߴ���ȥ����$|^(> |)����˵�����������Ǹ����ı�Ǯ����ͬ־���㻹����ЪϢһ����ɡ���|^(> |)����˵�������Ҳ��ǽ��㵽.*ȥ������үү����Ů�����$|^(> |)����˵�������ҿ��㲻���ĺ�������үү�Ҳ�ϲ������$|^(> |)�㷢�����鲻����ˣ�������˵��������$",5)
		if l==nil then
		   self:xunwen()
		   return
		end

		if string.find(l,"�����Ǹ����ı�Ǯ��") then
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self.fail(102)
		   end
		   b:check()
		   return
		end
		if string.find(l,"��Ҫ����������үү��") then
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self.fail(101)
		   end
		   b:check()
		   return
		end
		if string.find(l,"��������Ķ�������˵����") then
		   print(w[2])
		   self:is_super_guard()
		   self:beauty(w[2])
		   return
		end
		if string.find(l,"ȥ������үү����Ů��") then
		   self:giveup()
		   return
		end
		if string.find(l,"�ҿ��㲻���ĺ�����") then
		   self:look_xieqiwan()
		  return
		end
		if string.find(l,"�㷢�����鲻����ˣ�������˵������") then
		   self:ask_job()
		   return
		end
	    wait.time(5)
    end)
end

function xueshan:ask_job()
	local ts={
	           task_name="ѩɽ",
	           task_stepname="ѯ�ʱ���",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	ask_fight=0
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ѩɽ����:������ʼ!", "yellow", "black") -- yellow on white
	 self.beauty_list={}
	 self.rooms={}
       local w
        w=walk.new()
		local al=alias.new()
        al.do_jobing=true
        w.user_alias=al
	    w.walkover=function()
        wait.make(function()
		 wait.time(1.5)
        world.Send("ask bao xiang about job")
		local l,w=wait.regexp("^(> |)����������йء�job������Ϣ��$",5)
		if l==nil then
		   self:ask_job()
		   return
		end
		if string.find(l,"����������йء�job������Ϣ") then
		   self:xunwen()
 		   return
		end
		wait.time(5)
	  end)
     end
     w:go(1657)
end

function xueshan:reward()
	local ts={
	           task_name="ѩɽ",
	           task_stepname="����",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	xueshan.xs_co=nil
	xueshan.xs_co2=nil
	 world.Send("alias pfm")
	 world.Send("unset wimpy")
	 world.Send("set wimpycmd hp")
	world.EnableTrigger("beauty_place",false)
    world.DeleteTrigger("beauty_place")
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
        world.Send("ask bao xiang about ���")
		local l,w=wait.regexp("^(> |)�㱻������(.*)�㾭�飬(.*)Ǳ�ܣ���о�а��֮����ʤ��ǰ��$|^(> |)�����ƺ����������˼��$|^(> |)��ϲ�㣡��ɹ��������ѩɽ�����㱻�����ˣ�$|^(> |)����һ�������������ƨ�ɣ�$",5)
		if l==nil then
		   self:reward()
		   return
		end
		if string.find(l,"��о�а��֮����ʤ��ǰ") then
		   local rc=reward.new()
	       rc:get_reward()
           local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
			  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ѩɽ����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- yellow on white
		      self:jobDone()
		   end
		   b:check()
		   return
		end
		if string.find(l,"��ϲ�㣡��ɹ��������ѩɽ����") then
		   local rc=reward.new()
	       rc:exps()
           local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
			  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ѩɽ����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- yellow on white
		      self:jobDone()
		   end
		   b:check()
		   return
		end
		if string.find(l,"����һ�������������ƨ��") then
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		      self:giveup()
		   end
		   b:check()
		    return
		end
		if string.find(l,"�����ƺ����������˼") then
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		      self:jobDone()
		   end
		   b:check()
		   return
		end
		wait.time(5)
	  end)
   end
   w:go(1657)
end

function xueshan:liaoshang_fail()
end

function xueshan:full()
	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 local qi_percent=world.GetVariable("qi_percent") or 100
	 qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100
	 local vip=world.GetVariable("vip") or "��ͨ���"
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="����������" then
		    print("eat")
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
		elseif (h.qi_percent<=liao_percent or h.jingxue_percent<=80) and heal_ok==false then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
			end

			rc:liaoshang()

		elseif h.jingxue_percent<100 then
		    print("��ͨ����")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			    world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
			end
			rc:heal(true,false)
		elseif h.neili<h.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                self:Status_Check()
            end
			r:wash()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    if h.neili<=h.max_neili then
			  world.Send("fu chuanbei wan")
			end
		    heal_ok=false --��λ
		    local x
			x=xiulian.new()
			x.min_amount=10
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.danger=function()
			   world.Send("yun qi")
			   world.Send("yun jingli")
			   local w=walk.new()
			   w.walkover=function()
			      x:dazuo()
			   end
			   w:go(53)
			end
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun recover")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
			    end
				if id==777 then
				   f=function()
				     heal_ok=false
   				     self:Status_Check()
				   end  --���
				   f_wait(f,0.5)
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
				   --BigData:Auto_catchData()
			       x:dazuo()
		         end
		         w:go(1656)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
			   else
	             print("��������")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()

		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end


function xueshan:Status_Check(flag)
	local ts={
	           task_name="ѩɽ",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

	local cd=cond.new()
	cd.over=function()
	          print("���״̬")
		     if table.getn(cd.lists)>0 then
		       local sec=0
		       for _,i in ipairs(cd.lists) do
				local s,e=string.find(i[1],"��")
				 if s~=nil then
                    s=s%2
				 else
				    s=0
				 end
			     if i[1]=="�����ƶ�" or s==1 then
				   print("�ж���")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			             self:Status_Check()
					  end
					  f_wait(f,3)
			        end
			        if rc.omit_snake_poison==true and i[1]=="�߶�" then --�����߶�

					else
			          rc:qudu(sec,i[1],false)
					  return
					end
			     end
				 if i[1]=="����" or i[1]=="����ȭ����" then
				    print("����")
				    sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			            self:Status_Check()
					  end
					  f_wait(f,5)
			        end
			        rc:heal(true,true)
				    return
				 end
				  if Trim(i[1])=="ѩɽǿ����Ů" then
				    --print("?")
				    self.fail(102)
				    return
				 end
			   end
		     end
			--self:xuli()
            self:full()
	end
	cd:start()
end

function xueshan:combat()  --�ص�����
end

function xueshan:combat_end()
end

function xueshan:is_ok()
    world.Send("yun recover")
    world.Send("yun refresh")
	local h
	h=hp.new()
	h.checkover=function()
	  if h.qi_percent>=80 and h.qi_percent<=100 then
	    self:kill_guard()
	  else
        self:giveup()
	  end
	end
	h:check()
end

function xueshan:sa(count)
    wait.make(function()
	   if count==nil then
	      count=1
	   else
	      count=count+1
	   end

	    world.Send("sa beauty")
		if count>1 then
		  world.Send("sa beauty 2")
		end
		world.Send("set action sa")

	   local l,w=wait.regexp("^(> |)hmm�����ƺ�������BUG��$|^(> |)��ٺ���Ц�˼�������ָ����.*���ᵯ�˵��ĭ��.*$|^(> |)��Ҫ��˭��$|^(> |)�趨����������action \\= \"sa\"$|^(> |)�˼��б������أ�����ô��̫ð���˰ɣ�$|^(> |)���Ů�˺���������Ҫ���Ǹ�����$",5)
	   if l==nil then
	      self:sa()
		  return
	   end
	   if string.find(l,"�˼��б������أ�����ô��̫ð���˰�") then
	       --world.AppendToNotepad (WorldName().."_ѩɽ����:",os.date()..": super-guard\r\n")

	      --self.super_guard=true
	      self:is_ok()
		  return
	   end
	   if string.find(l,"���ƺ�������BUG")  then
	      --self.super_guard=false
	      self:is_ok()
	      return
	   end
	   if string.find(l,"��ٺ���Ц�˼���") then
	      local b
		  b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		     self:reward()
		  end
		  b:check()
	      return
	   end
	   if string.find(l,"��Ҫ��˭") then
	      self:reward()
	      return
	   end
	   if string.find(l,"���Ů�˺���������Ҫ���Ǹ���") then
	      if count>5 then
			 print("���Գ���5��")
		     self:giveup()
		     return
		  end

	      local f=function()
		     self:sa(count)
		  end
          f_wait(f,0.8)
	      return
	   end
	   if string.find(l,"�趨����������action") then
	     print("ҩ�۶�ʧ!!!!")
	     self:giveup()
	     return
	   end
	   wait.time(5)
	end)
end

function xueshan:fail(id)
end

--[[��ٺ���Ц�˼�������ָ����Ƹ�����ᵯ�˵��ĭ��
��һ������Ƹ�������ͨ������˹�ȥ��

ֻ���߳�����׳�����ӽ��Ƹ��������ѩɽ�ķ��򼲱���ȥ��]]
