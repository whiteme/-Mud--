
changle={
   new=function()
     local cl={}
	 setmetatable(cl,changle)
	 return cl
   end,
   cl_co=nil,
   party=nil,
   party_weapon=nil,
   murder_id="",
   player_id="",
   player_name="",
   look_player_place="",
   look_player=false,
   find_player=true,
   neili_upper=1.9,
   blacklist="����",
   version=1.8,
}
changle.__index=changle
local xunwen_count=0
--����ϸ�ز鿴�������ʬ�壬�����ƺ��Ǳ������ڹ����ˣ����˿ڿ�����Ӧ���Ǵ�������Ϊ��
--�㰵��Ѱ˼ѯ�������̵Ļ������(Lbxa)�����ܵõ���ʾ�����������ڻ�ɽ�ٳ�Ͽ�������֡�

function changle:jobDone()
end

function changle:catch()
    wait.make(function()
	   --���򱴺�ʯ�����йء�job������Ϣ��
	   --����ʯ����Ķ�������˵�����ҽӵ��ɸ봫�飬ʨ�������°��ں�������������̴�����Ϯ������Ͽ�ǰȥ��Ԯ��
       --����ʯ˵��������λС�ֵܿ�Ϊ�Ұ�������������ʹ�����������͡���
       --����ʯ˵������������곤�ְ����񣬻�����ȥ��Ϣһ��ɡ�
	   --��
	     local l,w=wait.regexp("^(> |)����ʯ����Ķ�������˵�����ҽӵ��ɸ봫�飬.*���°���(.*)��(.*)������Ϯ������Ͽ�ǰȥ��Ԯ��$|^(> |)����ʯ˵������������곤�ְ����񣬻�����ȥ��Ϣһ��ɡ���$|^(> |)����ʯ˵�������Ұ����ڱȽϿ��У���ʱ��û����������ȥ������$|^(> |)����ʯ˵�������Ҳ��Ǹ����������Ұ�������.*����Ϯ�����㻹���Ͽ�ǰȥ��Ԯ����$|^(> |)����ʯ˵�������㲻���Ѿ���չ��һ���ز��ˣ����Ǽ���Ŭ���ɣ���$|^(> |)����ʯ˵�������㲻���Ѿ�֪���ˣ�ɱ���Ұ���ڵĳ�����(.*)һ�����ֹ�����$",5)
		 if l==nil then
            print("����̫�����Ƿ�����һ����Ԥ�ڵĴ���")
		    self:ask_job()
		    return
         end
		 if string.find(l,"�ҽӵ��ɸ봫��") then
		    print(w[2],w[3])
			self:appear(w[2],w[3])
		    return
		 end
		 if string.find(l,"������곤�ְ����񣬻�����ȥ��Ϣһ���") then
		    local b=busy.new()
		    b.Next=function()
			  self.fail(101)
			end
			b:check()
		    return
		 end
		 if string.find(l,"�Ұ����ڱȽϿ��У���ʱ��û����������ȥ��") then
		    local b=busy.new()
			b.Next=function()
		      self.fail(102)
			end
			b:check()
		    return
		 end
		 if string.find(l,"�Ҳ��Ǹ���������") then
		    shutdown()
		    self:giveup()
			return
		 end
		 if string.find(l,"�㲻���Ѿ���չ��һ���ز���") or string.find(l,"�㲻���Ѿ�֪����") then
		    self:reward()
		    return
		 end
		 wait.time(5)
	 end)
end

function changle:ask_job()
  	local ts={
	           task_name="���ְ�",
	           task_stepname="ѯ�ʱ���ʯ",
	           task_step=2,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."���ְ�����:ѯ�ʱ���ʯ", "yellow", "black") -- yellow on white
  local w
  w=walk.new()
  w.walkover=function()
	 world.Send("ask bei haishi about job")
     local l,w=wait.regexp("^(> |)���򱴺�ʯ�����йء�job������Ϣ��",5)
	 if l==nil then
	    self:ask_job()
	    return
	 end
	 if string.find(l,"���򱴺�ʯ�����й�") then
	    self:catch()
		 --BigData:catchData(135,"С��")
	    return
	 end
	 wait.time(5)
  end
  w:go(135)
end

function changle:fail()

end

function changle:giveup()
    self.find_player=false
	world.EnableTrigger("player_place",false)
	world.DeleteTrigger("player_place")
  changle.cl_co=nil
  local w
  w=walk.new()
  w.walkover=function()
    wait.make(function()
      world.Send("ask bei haishi about fangqi")
	  local l2,w2=wait.regexp("^(> |)����ʯ����ʧ�����ˣ�����û���ˡ���$|^(> |)����ʯ˵�������������û�����������ʲô������$",10)
	  if l2==nil then
	    self:giveup()
		return
	  end
	  if string.find(l2,"����ʯ����ʧ������") or string.find(l2,"�������û��������") then
	   print("����")
	   --BigData:catchData(135,"С��")
	   local b
	   b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	     self:Status_Check()
	   end
	   b:check()
	   return
	  end
	  wait.time(10)
	 end)
  end
  w:go(135)

end

function changle:run(i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)������ʧ�ܡ�$|^(> |)�����Ϊ������$|^(> |)�趨����������action \\= \\\"����\\\"$",1.5)
	   if l==nil then
	      self:run(i)
	      return
	   end
	   if string.find(l,"�����Ϊ����") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"��Ķ�����û����ɣ������ƶ�") or string.find(l,"������ʧ��") then
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
			   world.Send("unset wimpy")
			   shutdown()
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

function changle:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("Ѱ�ҳ���")
     local dx=_R:get_all_exits(_R)
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil or i>table.getn(dx) then
	    --����������
	     local n=table.getn(dx)
	     i=math.random(n)
		 print("���:",i)
	 end
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
	 self:run(run_dx,i)
   end
   _R:CatchStart()
end

function changle:look_corpse(npc,seq)
  wait.make(function()
    --print(npc.."ʬ��")
	world.Execute("look;set look 1")
	if seq~=nil then
		seq=seq+1
	else
		seq=1
	end
	local l,w=wait.regexp("^(> |).*"..npc.."��ʬ��\\\(Corpse\\\)|^(> |)�趨����������look \\= 1$",5)
	if l==nil then
	   self:look_corpse(npc,seq)
	   return
	end
	if string.find(l,npc.."��ʬ��") then
	   self:hint(npc,seq)
       return
	end
	if string.find(l,"�趨����������look") then
	   --û�п���corpse
		 print("��һ������")
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
	   return
	end
	--wait.time(5)

  end)
end

function changle:reward()
  	local ts={
	           task_name="���ְ�",
	           task_stepname="����",
	           task_step=7,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 danerous_man_list_push()
	changle.cl_co=nil

  local w
  w=walk.new()
  w.walkover=function()
     self.find_player=false
	 world.EnableTrigger("player_place",false)
	 world.DeleteTrigger("player_place")
	 --world.DeleteVariable("player_place")
     world.Send("ask bei haishi about finish")
	 wait.make(function()
	   local l,w=wait.regexp("���򱴺�ʯ�����йء�finish������Ϣ��",10)
	   if l==nil then
	      self:reward()
		  return
	   end
	   if string.find(l,"���򱴺�ʯ�����йء�finish������Ϣ") then
	       local rc=reward.new()
	       rc:get_reward()
		   --BigData:catchData(135,"С��")
	       local b
	       b=busy.new()
	       b.interval=0.3
	       b.Next=function()
			 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."���ְ�����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black")
	         self:jobDone()
	       end
	       b:check()
	      return
	   end
	    wait.time(10)
	 end)
  end
  w:go(135)
end


function changle:xunwen_man(id,roomno,rooms)
  wait.make(function()
    world.Send("xunwen "..string.lower(id))
	self.find_player=false
	world.EnableTrigger("player_place",false)
	world.DeleteTrigger("player_place")
	local l,w=wait.regexp("^(> |)��Ҫѯ��˭��$|^(> |)�������������ô��$|^.*����Ķ�������˵�����ʲ�(.*)������߾���������ǰ����(.*)��$|^(> |)ʲô��$|^(> |)�㲻���Ѿ�ѯ�ʹ���.*$|^(> |)������.*��ʱ�޷��ش�������⡣$",5)
	if l==nil then
	   self:xunwen_man(id,roomno,rooms)
	   return
	end
	if string.find(l,"��Ҫѯ��˭") or string.find(l,"�������������ô") or string.find(l,"ʲô") then
	  if self.look_player==true then
	     self.look_player=false
		 print("���¶�λ:",self.look_player_place)
		 self:xunwen_place(id,self.player_name,self.look_player_place,rooms)
	  else
	     self:NextPoint()
	  end
	 return
	end
	if string.find(l,"�㲻���Ѿ�ѯ�ʹ���")  then
	  self:reward()
	  return
	end
	if string.find(l,"��ʱ�޷��ش��������") then
	  xunwen_count=xunwen_count+1
	  print("ѯ��ʣ�����:",10-xunwen_count)
	  if xunwen_count>10 then
	     self:reward()
      else
	     self:xunwen_man(id,roomno,rooms)
	  end
	  return
	end
	if string.find(l,"����Ķ�������˵��") then
	   world.Send("say ����Ѱ��ǧ�ٶȣ���Ȼ���׵ƻ���ɺ������")
	   world.Send("say "..self.player_name.."�������ҵĺÿ࣡��")
	   --[[local exps=world.GetVariable("exps")
	   if tonumber(exps)<=1000000 then
		  self:reward()
	      return
	   end]]
	   print(w[3],w[4])
	   local murder=w[3]
	   local place=w[4]
	   -- world.AppendToNotepad (WorldName(),os.date().." ��������: "..murder.." ��صص�: "..place.."\r\n")
		--[[
		"�����ɵ���"
		"�䵱�ɵ���"
		"��ü�ɵ���"
		"��ɽ�ɵ���"
		"�����ɵ���"
		"��ɽ�ɵ���"
		"�һ�������"
		"����������"
		"�����ɵ���"
		"ؤ�����"
        "���ư����"
		"���̵���"
		"�����µ���"
		"�����µ���"
		"����Ľ��"
		"��Ĺ��"
		]]
		local _blacklist
		 if not (self.blacklist=="" or self.blacklist==nil) then
            _blacklist=Split(self.blacklist,"|")
			for _,b in ipairs(_blacklist) do
	           if string.find(Trim(murder),b) then
	             self:reward()
		         return
		       end
		    end
		 end
		  local name
		  name=string.gsub(murder,self.party.."����","")
		  print(murder,"->",name)
		   -- ����Σ�������б�
	      dangerous_man_list_add(name)
		  self:catch_murder(name,place)
	   return
	end
	wait.time(5)
  end)
end

function changle:combat()
end

function changle:shield()
end

function changle:wait_murder_die(murder_name)
  wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾�����.*$",5)--������ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
	 if l==nil then
	    self:wait_murder_die(murder_name)
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
	    print(murder_name,w[2])
	    if string.find(murder_name,w[2]) then
		   self:murder_die()
		else
           self:wait_murder_die(murder_name)
		end
	    return
	 end
	 wait.time(5)
  end)
end

function changle:murder_die()
end

function changle:kill_murder(id,name,roomno)
  	local ts={
	           task_name="���ְ�",
	           task_stepname="ս��",
	           task_step=6,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  wait.make(function()
   world.Send("kill "..id)--����ų����ͺ�һ��������ƥ������Ľ��������ļ��գ��ô�ү��������·�ɣ�����������̨��ȵ������������������ѵ���������ô�ү������������ɣ���
   self.murder_id=id
   local l,w=wait.regexp("^(> |)���ﲻ׼ս����$|^(> |)�����.*���һ����.*$|^(> |)�����.*�ͺ�һ��.*$|^(> |)���ͣ����ͣ�$|^(> |)����Ҫ����������ͻȻ�������˽���һ�ģ��úÿ����䣬���Ҷ���$|^(> |)�����.*�ȵ���.*|^(> |)����û������ˡ�$",5)
   if l==nil then
      self:kill_murder(id,name,roomno)
	  return
   end
   if string.find(l,"���һ��") or string.find(l,"�ȵ�") or string.find(l,"����") or string.find(l,"�ͺ�һ��") then
        self:wait_murder_die(name)
        self:combat()
		return
	end
   if string.find(l,"���ﲻ׼ս��") or string.find(l,"����Ҫ��������") or string.find(l,"û�������") then
     local _R
	 _R=Room.new()
	 _R.CatchEnd=function()
		local count,roomno=Locate(_R)
		print(roomno[1])
		local r=nearest_room(roomno)
		local w=walk.new()
		w.walkover=function()
		  self:check_murder(name,roomno)
		end
		w:go(r)
	  end
	  _R:CatchStart()
      return
   end
   wait.time(5)
  end)
end

function changle:check_murder(name,roomno)
   wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*"..name.."\\((.*)\\).*$|^(> |)�趨����������look \\= 1$|^(> |).*"..name.."��ʬ��\\((.*)\\).*$",15)
	  if l==nil then
	     self:check_murder(name,roomno)
		 return
	  end
	  if string.find(l,"�趨����������look") then
		 self:NextPoint()
	     return
	  end
	  if string.find(l,"ʬ��") then
	     self:reward()
	     return
	  end
	  if string.find(l,name) then
		 local murder_id=w[2]
		 murder_id=string.lower(murder_id)
         self:kill_murder(murder_id,name,roomno)
	     return
	  end
	  wait.time(15)
   end)
end


function changle:catch_murder(name,place)
  	local ts={
	           task_name="���ְ�",
	           task_stepname="ץ������",
	           task_step=5,
	           task_maxsteps=7,
	           task_location=place,
	           task_description="ץ��"..name,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --print("ץ������")
   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."���ְ�����:".."ץ������:"..name.." λ��:"..place, "white", "black")
   if zone_entry(place)==true or Trim(place)=="������ɼ��" or Trim(place)=="��ɽ����������" or Trim(place)=="���ԭ����" or Trim(place)=="���ݳ�����" then
      self:reward()
	  return
   end
   local n,rooms=Where(place)
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	    local al
		al=alias.new()
		al:SetSearchRooms(rooms)
	   print("ץȡ")
	   world.Send("yun recover")

	   changle.cl_co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()

		  al.do_jobing=true
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:reward()
		  end
		  al.noway=function()
		    --print("ceshi")
		    self:reward()
		  end
		  al.maze_done=function()
		    self:check_murder(name,self.maze_step)
		  end
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
				  self:reward()
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
		  w.noway=function()
		    self:reward()
		  end

		  w.user_alias=al
		  w.walkover=function()
		    self:check_murder(name,r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("û���ҵ�ѯ�ʶ���")
		self:reward()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��")
	  self:reward()
	end
end

function changle:player_exist()
  if self.find_player==true then
  --��������Ĺ����ɱ���㣡
  --print("auto kill ���")
   world.AddTriggerEx ("player_place", "^(> |)(.*) - .*$", "print(\"%2\")\nSetVariable(\"player_place\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 150)

  wait.make(function()
    local l,w=wait.regexp("^(> |).*"..self.player_id..".*$",5)
	if l==nil then
	  self:player_exist()
	  return
	end
	if string.find(l,self.player_name) then
	  print("�������",self.player_name)
	  local location=world.GetVariable("player_place")
	  location=Trim(location)
	  self.look_player=true
	  self.look_player_place=location
	  print("���ֵص�:",location)
	  self.find_player=false
	  world.EnableTrigger("player_place",false)
	  world.DeleteTrigger("player_place")
	  --world.DeleteVariable("player_place")
	  return
    end
	wait.time(5)
  end)
 end
end

function changle:xunwen_place(id,name,location,pass_rooms)
  	local ts={
	           task_name="���ְ�",
	           task_stepname="ѯ�����",
	           task_step=4,
	           task_maxsteps=7,
	           task_location=location,
	           task_description="Ѱ�����"..name.."("..id..")",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."���ְ�����:".."Ѱ�����:"..name.."("..id..") λ��:"..location, "white", "black") -- yellow on white
	if zone_entry(location)==true then
	    self:reward()
	    return
	end
	shutdown()
	 print("ѯ�����")
  self.find_player=true
  --self:player_exist()
  local n,rooms=Where(location)
  if pass_rooms~=nil then  --����
     print("����")
     local filter_rooms={}
	 --print("pass_rooms:")

     for _,j in ipairs(rooms) do

	    for _,k in ipairs(pass_rooms) do
		  --print("pass_rooms:",k)
		   if j==k then
		      --print("���뷿���:",k)
		      table.insert(filter_rooms,k)
		      break
		   end
		end
	 end
	 n=table.getn(filter_rooms)
	 rooms=filter_rooms
  end
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   print("ץȡ")
	   changle.cl_co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:reward()
		  end
		  w.user_alias=al
		  w.noway=function()
		     self:reward()
		  end

		  w.walkover=function()
		    self.xunwen_count=0
		    self:xunwen_man(id,r,w.pass_rooms)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("û���ҵ�ѯ�ʶ���")
		self:reward()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��")
	  self:reward()
	end
end

function changle:check_place(name,id,place)

   if string.find(place,"��ѩɽ") or string.find(place,"���ְ�") or string.find(place,"������") or string.find(place,"���ݳ�") or string.find(place,"��ɽ") or place=="��ɽ���ִ�ĦԺ" or (string.find(place,"�䵱ɽ") and not string.find(place,"Ժ��") and not string.find(place,"��ɽСԺ")) or string.find(place,"�����") then
       if string.find(place,"�����ϰ�") or string.find(place,"��ɽʯ��") then
	       self:reward()
	   else
	       self:xunwen_place(id,name,place)
	   end
   else
      self:reward()
   end
end

function changle:xunwen()
--�㰵��Ѱ˼ѯ�������̵�ȹ�·���(Kicksld)�����ܵõ���ʾ�����������ڻƺ����򺣴��������֡�
--����ֻ�ܲ鿴���ⲽ�ˣ������Ȼ�ȥ����ɡ�
   wait.make(function()
     local l,w=wait.regexp("^(> |)�㰵��Ѱ˼ѯ��(.*)\\((.*)\\)�����ܵõ���ʾ������.*����(.*)�������֡�$|^(> |)����ֻ�ܲ鿴���ⲽ�ˣ������Ȼ�ȥ����ɡ�$",5)
      if l==nil then
	     self:reward()
	     return
	  end
	  if string.find(l,"����ֻ�ܲ鿴���ⲽ��") then
	      self:reward()
	     return
	  end
	  if string.find(l,"�㰵��Ѱ˼ѯ��") then
	     print(w[2],w[3],w[4])
		 --world.AppendToNotepad (WorldName(),os.date()..": �������� ѯ��".. w[2].." "..w[3].." "..w[4] .."\r\n")
		 self.player_name=w[2]
	     self.player_name=string.gsub(self.player_name,"�����ɵ�","")
		 self.player_name=string.gsub(self.player_name,"�䵱�ɵ�","")
		 self.player_name=string.gsub(self.player_name,"��ü�ɵ�","")
		 self.player_name=string.gsub(self.player_name,"��ɽ�ɵ�","")
		  self.player_name=string.gsub(self.player_name,"�����ɵ�","")
		  self.player_name=string.gsub(self.player_name,"��ɽ�ɵ�","")
		self.player_name=string.gsub(self.player_name,"�һ�����","")
		self.player_name=string.gsub(self.player_name,"�����̵�","")
		self.player_name=string.gsub(self.player_name,"�����ɵ�","")
		self.player_name=string.gsub(self.player_name,"ؤ���","")
		self.player_name=string.gsub(self.player_name,"���ư��","")
		self.player_name=string.gsub(self.player_name,"���̵�","")
		self.player_name=string.gsub(self.player_name,"�����µ�","")
		self.player_name=string.gsub(self.player_name,"�����µ�","")
        self.player_name=string.gsub(self.player_name,"����Ľ�ݵ�","")
		 self.player_name=string.gsub(self.player_name,"��Ĺ�ɵ�","")


		 self.player_id=w[3]
		 --self:reward()
		 print(self.player_name,self.player_id)
		 self:check_place(self.player_name,self.player_id,w[4])
	     return
	  end
	  wait.time(5)
   end)
end

function changle:chakan_corpse(seq)
--����ϸ�ز鿴ʯ���ʬ�壬�����ƺ��Ǳ������ڹ����ˣ����˿ڿ�����Ӧ������������Ϊ��

  wait.make(function()
     if seq~=nil then
       world.Send("get corpse "..seq)
	   world.Send("drop corpse")
	 end
	   world.Execute("chakan corpse;get corpse;chakan corpse;drop corpse;get corpse 2;chakan corpse;drop corpse;get corpse 3;chakan corpse;drop corpse")
--����ϸ�ز鿴���ݵ�ʬ�壬�����ƺ��Ǳ��ֵ����ˣ����˿ڿ�����Ӧ���ǹ���Ľ����Ϊ��
	  local l,w=wait.regexp("^(> |)����ϸ�ز鿴.*��ʬ�壬�����ƺ��Ǳ�(.*)�����˿ڿ�����Ӧ����(.*)��Ϊ��$|^(> |)�㸽��û������������$",5)
	  if l==nil then
	    if seq==nil then
		   seq=1
		else
		   seq=seq+1
		end
	    self:chakan_corpse(seq)
	    return
	  end
	  if string.find(l,"����ϸ�ز鿴") then
	  --�㰵��Ѱ˼ѯ�������̵�ȹ�·���(Kicksld)�����ܵõ���ʾ�����������ڻƺ����򺣴��������֡�
	    --world.AppendToNotepad (WorldName(),os.date()..": �������� �������� �书".. w[3] .." ".. w[2].."\r\n")
		self.party=w[3]
		self.party_weapon=w[2]
	    self:xunwen()
	    return
	  end
	  if string.find(l,"�㸽��û����������") then
	    self:giveup()
		return
	  end
	  wait.time(5)
  end)
end

function changle:hint(npc,seq)
	wait.make(function()
	  if seq~=nil then
	     world.Send("get cu bu from corpse "..seq)
	  else
	     world.Send("get cu bu from corpse")
	  end

	   local l,w=wait.regexp("^(> |)�㸽��û������������$|(> |)���.*��ʬ�������ѳ�һ��ֲ���Ƭ��$|^(> |)�����Ц�ˡ�$|^(> |)���Ҳ��� corpse .*����������$",6)
	   if l==nil then
         self:hint(npc,seq)
		 return
	   end
	   if string.find(l,"���Ҳ���") then
	      print("�ֲ�Ҳ����Ҫ?")
	      self:giveup()
	      return
	   end
	   if string.find(l,"�����Ц��") or string.find(l,"�㸽��û����������") then
	     local f=function()
	       self:look_corpse(npc,seq)
		 end
		 f_wait(f,2)
		 return
	   end
	   if string.find(l,"�ѳ�һ��ֲ���Ƭ") then
	     world.Send("chakan cu bu")
		 self:chakan_corpse(seq)
	     return
	   end
	   wait.time(6)
	end)
end

function changle:NextPoint()
-- �ָ�
   print("���ָ̻�1")
   coroutine.resume(changle.cl_co)
end
--[[
����ϸ�ز鿴�����ǳ۵�ʬ�壬�����ƺ��Ǳ������ڹ����ˣ����˿ڿ�����Ӧ���Ǵ�������Ϊ��
�㰵��Ѱ˼ѯ�ʹ���Ľ�ݵ�Ľ������(Kunlun)�����ܵõ���ʾ�����������ڴ�ѩɽǧ���븽�����֡�]]
--û��npcʱ�� ȷ�����Ƿ񵽴�׼ȷ�ص�
local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    if tonumber(v)==tonumber(r) then
		   return true
		end
	end
	return false
end

function changle:checkPlace(npc,roomno,here,f2)
      if is_contain(roomno,here) then
  	     print("�ȴ�0.8,��һ������")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     if f2==nil then
				self:NextPoint()
			 else
				f2()
			 end
		   end
		   b:check()
		 end
		 f_wait(f,0.8)
	   else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
	      w=walk.new()
		  local al
		  al=alias.new()
		  al:SetSearchRooms(roomno)
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�2")
				  coroutine.resume(changle.cl_co)
			   end
			   al:finish()
		  end
		  al.out_zishanlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�2")
				  coroutine.resume(changle.cl_co)
			   end
			   al:finish()
		  end
		  al.maze_done=function()
			 self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.songlin_check=function()
			  print("al ����check")
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end
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
				  self:giveup()
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
		  al.zishanlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,2464)
		  end
		  --�����: 2464
          --�����: 3041
          al.zishanlin2_check=function()
			  self.NextPoint=function() al:zishanlin_tiandifenglei() end
			  self:checkNPC(npc,2464)
		  end
		  --[[al.circle_done=function()
		     print("����")
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkNPC(npc,roomno,f2)
			 --self:checkBeauty(f2)
		  end]]
		 al.noway=function()
		     print("noway!!!")
		     self:giveup()
		  end
		  w.user_alias=al
		  w.noway=function()
		     shutdown()
			 self:giveup()
		  end
		  w.walkover=function()
			print("walk �¼�")
		    self:checkNPC(npc,roomno)
		  end
		  print("Ŀ�귿��:",roomno)
		  w:go(roomno)
	   end
end

function changle:checkNPC(npc,roomno,f2)
   wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*"..npc..".*$|^(> |)�趨����������look \\= 1$",15)
	  if l==nil then
	     self:checkNPC(npc,roomno,f2)
		 return
	  end
	  if string.find(l,"�趨����������look") then
	     if r==nil then
		  local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     if f2==nil then
				self:NextPoint()
			 else
				f2()
			 end
		   end
		   b:check()
		    return
		 end
		  local f=function(r)
		     self:checkPlace(npc,roomno,r,f2)
		  end
		  WhereAmI(f,10000)
	     return
	  end
	  if string.find(l,npc) then
	     local f=function()
           self:hint(npc)
		 end
		 print("�ȴ�3��")
		 f_wait(f,3)
	     return
	  end
	  wait.time(15)
   end)
end

--/changle:appear("������","������������")

function changle:appear(npc,location)
  	local ts={
	           task_name="���ְ�",
	           task_stepname="����",
	           task_step=3,
	           task_maxsteps=7,
	           task_location=location,
	           task_description="Ѱ��"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."���ְ�����:����"..location.." Ѱ��"..npc, "blue", "black") -- yellow on white
	local party=world.GetVariable("party")
    --world.AppendToNotepad (WorldName(),os.date()..": �������� �ص�".. location .."\r\n")  --or location=="����������"
 --  if zone_entry(location)==true or location=="���ԭ����" or location=="������������" or (location=="�䵱ɽС��" and party=="�䵱��") then
      --self:giveup()
     -- return
   --end
   if zone_entry(location)==true then
      --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �޷�����"..location.."ֱ�ӷ���\r\n")
      self:giveup()
      return
   end
   local n,rooms=Where(location)
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   print("ץȡ")
	   changle.cl_co=coroutine.create(function()
	      local al
		  al=alias.new()
		  al:SetSearchRooms(rooms)
		  --[[for _,r in ipairs(rooms) do
		     print("��ʾ��",r)
		  end]]
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()

		  --al.break_pfm=self.break_pfm

		    --print("����")
			--[[al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�2")
				  coroutine.resume(changle.co)
			   end
			   al:finish()
			end
			al.out_zishanlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�2")
				  coroutine.resume(changle.co)
			   end
			   al:finish()
		    end
		    al.songlin_check=function()
			  print("al ����check")
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
			end]]
		--[[	if location=="������ɼ��" then
		    	al.zishanlin_check=function()
	             self.NextPoint=function() al:NextPoint() end
			     self:checkNPC(npc,2464)
				end

			  al.zishanlin2_check=function()
			    self.NextPoint=function() al:zishanlin_tiandifenglei() end
			    self:checkNPC(npc,2464)
		      end
			end]]
		  al.maze_done=function()
		      print("�Թ�check")
		      self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.noway=function()
            self:giveup()
		 end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		 --[[ al.circle_done=function()
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkNPC(npc,r,f2)
		  end]]
		  w.user_alias=al
		  w.noway=function()
		     shutdown()
		     self:giveup()
		  end
		  w.walkover=function()
		    self:checkNPC(npc,r)
		  end
		  print("�����:",r)
		  w:go(r)
		  coroutine.yield()
	    end
		print("�ߵ���û���ҵ�npc,����job!!!")
		self:giveup()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��")
	  self:giveup()
	end
end

function changle:Status_Check()
  	local ts={
	           task_name="���ְ�",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --��ʼ��
     local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
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
		elseif  h.qi_percent<=liao_percent or h.jingxue_percent<=80 then
		    print("����")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("��ͨ����")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			 rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
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
		    local x
			x=xiulian.new()
			x.halt=false
			x.safe_qi=h.max_qi*0.5
			x.min_amount=100
			x.limit=true
			x.fail=function(id)
             --print(id)
			    if id==1 then
				  world.Send("yun recover")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
				end
				if id==777 then
				  self:Status_Check()
				end
				if id==201 then
				  world.Send("yun regenerate")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
			    end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(139)
			   end
			end
			x.success=function(h)
              -- print(h.qi,h.max_qi*0.9)
			  -- print(h.neili,h.max_neili*2-200)
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

--��������ľ�����ʱ�޷��ش�������⡣
