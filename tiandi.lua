
tiandi={
  new=function()
    local td={}
	 setmetatable(td,{__index=tiandi})
	 return td
  end,
  co=nil,
  fighting=false,
  is_combat=false,
  is_end=false,
  name="",
  hero_name="",
  neili_upper=1.9,
  shiwei_list={},
  npc="",
  is_move=false,
  is_wander=false,
  reward_count=0,
}

local check_fight=false
local count=1
--[[
��ʽ������Ķ�������˵����������ȥ��ɽ�������䳡����һ��������ֵܡ�
��ʽ������Ķ�������˵�����������ֽ��Ϲ��棬��·��С�ġ�
���ˣ���������������ʧ�ܣ�
]]
function tiandi:join()
 local w=walk.new()
  w.walkover=function()
	 marco("ask shikai about ������|#wa 2000|ask shikai about ��ػ�|#wa 2000|ask shikai about ���帴��")
	 local f=function()
		self:Status_Check()
	 end
	 f_wait(f,6)
  end
  w:go(104)
end

function tiandi:failure()
  --�����㶯��̫�������Ϊ�����͢׷���������в����ˣ�������ʧ�ܣ�
  wait.make(function()
     local l,w=wait.regexp("^(> |)�����㶯��̫����.*Ϊ�����͢׷���������в����ˣ�������ʧ�ܣ�$",20)
	 if l==nil then
	   self:failure()
	   return
	 end
	 if string.find(l,"�����㶯��̫��") then
	   self:Status_Check()
	   return
	 end
	 wait.time(20)
  end)
end

function tiandi:NextPoint()
   print("���ָ̻�")
   coroutine.resume(tiandi.co)
end
--[[
�����ֵ�������ұ���֡�Ҷ֪���֣����һ��˵������
ֻ��������Զ�����һ�������������������������������������������������ʮ�㡣
]]
function tiandi:checkNPC(npc,callback)



   wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,callback)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      --û���ҵ�
		  --self:NextPoint()
		  callback()
		  return
	  end
	  if string.find(l,npc) then
	     --�ҵ�
		  local id=Trim(w[2])
		  jiekou_count=0
		  self:qiekou(npc,id)
		  return
	  end
	  wait.time(6)
   end)
end

function tiandi:find_man(location,npc)
	  local ts={
	           task_name="��ػ�",
	           task_stepname="Ѱ��"..npc,
	           task_step=2,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	}
	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ػ�����:Ѱ��:"..npc.." �ص�:"..location, "white", "black") -- yellow on whit
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   if zone_entry(location)==true or string.find(location,"���Ӿ�") or string.find(location,"Ħ����") or string.find(location,"��ɼ��") or string.find(location,"����") or string.find(location,"��ɼ��") or string.find(location,"���") then
      self:giveup()
      return
   end
 local n,rooms=Where(location)
 rooms=depth_search(rooms,1)  --��Χ��ѯ
 print(n," ������Ŀ")
   for _,r in ipairs(rooms) do
      print(r)
   end
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   local al
		al=alias.new()
		al:SetSearchRooms(rooms)
		al.do_jobing=true
	   tiandi.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  w.noway=function()
		    self:NextPoint()
		  end


		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  --print("���ָ̻�2")
				  coroutine.resume(tiandi.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
			  --print("al ����check")
			  local f=function()
	             al:NextPoint()
			  end
			  self:checkNPC(npc,f)
		  end

		  al.zishanlin_check=function()
			 self.NextPoint=function() al:NextPoint() end
			   local f1=function()
			      self:NextPoint()
			   end
             self:checkNPC(npc,f1)
		  end
         	al.maze_done=function()
              --print("����",npc)
	          self:checkNPC(npc,al.maze_step)
	       end


		  w.user_alias=al
		  w.walkover=function()
		     local f=function()
			    self:NextPoint()
			 end
		    self:checkNPC(npc,f)
		  end
		  print("��һ�������:",r)
		  self.target_roomno=r
		  w:go(r)
		  coroutine.yield()
	    end
		print("û���ҵ�npc!!")
		self:giveup()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��,����")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:giveup()
	  end
	  b:check()
	end
end

function tiandi:auto_pfm()

end

--������������㿴����֪����Щʲô���⡣
function tiandi:get_name(place)
   wait.make(function()
     local l,w=wait.regexp("^(> |)��ʽ������Ķ�������˵�����������ֽ�(.*)����·��С�ġ�$",5)
	 if string.find(l,"��·��С��") then
	   local npc_name=Trim(w[2])
	   print("����:",npc_name)
	   self.npc=npc_name
	   self:find_man(place,npc_name)
	   return
	 end
     wait.time(5)
   end)
end
--��ʽ������Ķ�������˵������ȥ�������ֹ㳡��
--��ʽ������Ķ�������˵������ȥ��ɽ�����롣
local is_error=false
function tiandi:catch_place()
   wait.make(function()
      local l,w=wait.regexp("^(> |)��ʽ������Ķ�������˵����������ȥ(.*)����һ��������ֵܡ�$|^(> |)��ʽ������Ķ�������˵������ȥ(.*)��$|^(> |)��ʽ��˵�������㻹���������أ���$|^(> |)��ʽ��˵���������������񣬻���ȥ��Ϣ��ɡ���$|^(> |)��ʽ��˵����������û������񣬷���ʲô������|^(> |)��ʽ��˵��������˵���ܶ����������㣬�㻹����ȥ���ܶ���ѯ�ʰɡ���$",5)
	  if l==nil then
	     self:ask_job()
	     return
	  end
	  if string.find(l,"�㻹����������") then
	    self.fail(102)
	    return
	  end
	  if string.find(l,"���������񣬻���ȥ��Ϣ���") then
	     self.fail(101)
	     return
	  end
	  if string.find(l,"����һ��������ֵ�") then

	   local place=Trim(w[2])
	   if  place=="����ׯ�Ź��һ���" or place=='���ԭ����' then --or place=="��ɽ����������"
	     self:giveup()
		 return
	   end
	    self.backplace=place
	    print("�ص�:",place)
	   self:get_name(place)
	   return
	  end
	  if string.find(l,"����û������񣬷���ʲô��") then
	    self:jobDone()
	    return
	  end
	  if string.find(l,"��ʽ��˵��������˵���ܶ����������㣬�㻹����ȥ���ܶ���ѯ�ʰɡ���") then
	    --local quest=quest.new()
		--quest:tiandihui()
	    return
	  end
	  if string.find(l,"��ȥ") then
	     self:giveup()
	     --[[local place=w[4]
		 print("��ȥ"..place)
		 self.link_man_room=Where(place)
		 self:back()]]
	    return
	  end
	  wait.time(5)
   end)
end

function tiandi:ask_job()


	 local ts={
	           task_name="��ػ�",
	           task_stepname="ѯ�ʹ���",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
    wait.make(function()
	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ػ�����:������ʼ","yellow", "black") -- yellow on whit
     world.Send("ask shikai about job")
	 local l,w=wait.regexp("^(> |)������ʽ�������йء�job������Ϣ��$",5)
	 if l==nil then
	    self:ask_job()
		return
	 end
	 if string.find(l,"������ʽ�������й�") then
	    self:catch_place()
	    return
	 end
	 wait.time(5)
	 end)
  end
  w:go(104)
end
--[[
�Ϲ������ǰȥ�������ؽ�����ס���˫�֣�������˵����������
�Ϲ���˵������ԭ��������Լ��ˣ����º껯�õ����Ϲ��档��
�Ϲ���˵������������Сɳ����һλ����֣����ֵܣ��������������ػᡣ��
�Ϲ�������Ķ�������˵����������ò�ǡ���������ӵģ�ƾ�������һ�۾��ϵó�����
�Ϲ���˵��������͢�Ѿ������ڼ��������뾡��ϵ����ֵܻ���Ҫ��������������һ���ˡ���
]]
--[[
����Զ����һ�ˣ����ӻ�㱺��Ϲ���˵�����˺���
������ǰȥ����Ҿ���������ʸ��¿���֣�죿�� ���˴���������ǡ���

]]

function tiandi:checkHero(npc,callback)
--  ��çӢ�� ����(Lv pei)
--  ��ػ��̫�õ��� ������(Wen yuliang)
   wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*(��çӢ��|����־ʿ|���ֺú�).*"..npc.."\\\((.*)\\\)$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:checkHero(npc,callback)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      --û���ҵ�
		  if callback~=nil then
		     callback()
		  else
		     self:NextPoint()
		  end

		  return
	  end
	  if string.find(l,npc) then
	     --�ҵ�
		  local id=Trim(w[3])
		  self:guard(npc,id)
		  return
	  end
	  wait.time(6)
   end)
end

function tiandi:hero(place,npc)
	  local ts={
	           task_name="��ػ�",
	           task_stepname="Ѱ��"..npc,
	           task_step=4,
	           task_maxsteps=5,
	           task_location=place,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ػ�����:��ͷ:"..npc.." �ص�:"..place, "white", "black")
   if zone_entry(place)==true or string.find(place,"��ɼ��") or string.find(place,"����") or string.find(place,"Ħ����")  then
      self:giveup()
      return
   end
	if  place=="����ׯ�Ź��һ���" or place=="��ɽ����������" or place=="���������" then
	     self:giveup()
		 return
	end
  local n,rooms=Where(place)
   if n>0 then

	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   tiandi.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  w.noway=function()
		    self:NextPoint()
		  end
		  local al
		  al=alias.new()
		  al.do_jobing=true
		  al.break_in_failure=function()
		      self:giveup()
		  end

		   al:SetSearchRooms(rooms)

         	al.maze_done=function()

	          self:checkHero(npc,al.maze_step)
	       end


		  w.user_alias=al
		  w.walkover=function()
		    self:checkHero(npc)
		  end
		  print("��һ�������:",r)
		  self.target_roomno=r
		  w:go(r)
		  coroutine.yield()
	    end
		print("û���ҵ�npc!!")
		self:giveup()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��,����")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:giveup()
	  end
	  b:check()
	end
end

function tiandi:test()
  local f=function(c)
     print("test",c[1])
		  self:hero(hero_place,hero_name)

		  --local c=is_crowd(self.target_roomno)
           self.link_man_room=c
		end
		WhereAmI(f,10000) --�ų����ڱ仯
end

local jiekou_count=0
function tiandi:jie(npc)
   jiekou_count=jiekou_count+1
   if jiekou_count>5 then
      self:giveup()
      return
   end
   self.link_man=npc
   --print("�����˵ص�:",self.link_man_room[1])
   --print("����������:",self.link_man)
   wait.make(function()
     world.Send("qiekou")
	 local l,w=wait.regexp("^(> |)"..npc.."˵��������(.*)��һλ����(.*)���ֵܣ��������������ػᡣ��$|^(> |)������е�ʲô���Ծ�.*$",3)
     if l==nil then
	    self:jie(npc)
		return
	 end
	 if string.find(l,"������е�ʲô���Ծ�") then
	    self:giveup()
	    return
	 end
	 if string.find(l,"����������ػ�") then
		local hero_place=Trim(w[2])
		local hero_name=Trim(w[3])
		self.hero_name=hero_name
		print("�ص�:",hero_place," ����:",hero_name)
	    local f=function(c)
		  print("��ǰ����:",c[1])
		  self:hero(hero_place,hero_name)

		  --local c=is_crowd(self.target_roomno)
           self.link_man_room=c
		end
		WhereAmI(f,10000) --�ų����ڱ仯
		 return
	 end
	 wait.time(3)
   end)
end

function tiandi:duilian(npc,id)
  wait.make(function()
    world.Send("ask "..id.." about �п�")
    local l,w=wait.regexp("^(> |)"..npc.."˵�������пڣ��������е���˼������˵˵\\\(qiekou\\\)����|^(> |)����û������ˡ�$",5)
	if l==nil then
	   self:duilian(npc,id)
	   return
	end
	if string.find(l,"����û�������") then
	   self:giveup()
	   return
	end
	if string.find(l,"����˵˵") then
	   local b
	   b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	      self:jie(npc)
	   end
	   b:check()
	   return
	end
	wait.time(5)
  end)
end

function tiandi:fanqingfumu(npc,id)
  wait.make(function()
	world.Send("ask "..id.." about ���帴��")
    local l,w=wait.regexp("^(> |)"..npc.."�ƺ����������˼��|^(> |)����û������ˡ�$",5)
	if l==nil then
	  self:fanqingfumu(npc,id)
	  return
	end
	if string.find(l,"����û�������") then
	   self:giveup()
	   return
	end
	if string.find(l,"���������˼") then
	   local b
	   b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	     self:duilian(npc,id)
	   end
	   b:check()
	   return
	end
	wait.time(5)
  end)
end

function tiandi:qiekou(npc,id)
  id=string.lower(id)
  wait.make(function()
    world.Send("ask "..id.." about ��ػ�")
    local l,w=wait.regexp("^(> |)"..npc.."˵���������֪����������ʲô�£���|^(> |)����û������ˡ�$",5)
	if l==nil then
	   self:qiekou(npc,id)
	   return
	end
	if string.find(l,"���֪����������ʲô��") then
	   local b=busy.new()
		b.interval=0.3
        b.Next=function()
		   self:fanqingfumu(npc,id)
        end
	    b:check()
	   return
	end
	if string.find(l,"����û�������") then
	   self:NextPoint()
	   return
	end
   wait.time(5)
  end)
end

--[[function tiandi:dog_claw()
  -- print("dog_claw")
   wait.make(function()--�ºӽе����������շ��������˵���������˵�ձ���Ҷ֪���ս����һ��
     local l,w=wait.regexp("^(> |).*�е����������շ��������˵���������˵�ձ���(��|"..self.name.."��)ս����һ��$|^(> |)"..self.hero_name.."һ���ܣ�һ�߶������������.*$",30)
	 if l==nil then
	   self:dog_claw()
	   return
	 end
	 if string.find(l,"�����շ�") or string.find(l,self.hero_name) then
       shutdown()
	   self:combat()
	   return
	 end
	 wait.time(30)
   end)
end]]

function tiandi:fail(id) --�ص�����

end

function tiandi:run(i)
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

function tiandi:flee(i)
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("Ѱ�ҳ���")
     local dx=_R.get_all_exits()
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

local function belong(h,t)
   for _,r in ipairs(h) do
      print(r," ?= ",t)
      if r==t then
	     return true
	  end
   end
   return false
end


function tiandi:checkPlace(here,targetRoomNo)
	if belong(here,targetRoomNo)==true then
  	     print("�ȴ�1s,��飡")
		 local f=function()
		   wait.make(function()
            world.Execute("look;set look 1")
            local l,w=wait.regexp("^(> |).*"..self.link_man.."\\\((.*)\\\).*$|^(> |)�趨����������look \\= 1",5)
	       if l==nil then
		    self:checkPlace(here,targetRoomNo)
		    return
	       end
	       if string.find(l,"�趨����������look") then
	         --û���ҵ�
		     self:NextPoint()
		     return
	       end
	      if string.find(l,self.link_man) then
	       --�ҵ�
		     print("�ҵ���!!"," 15s ")
			 --self:auto_pfm()
			 self.reward_count=self.reward_count+1
			 if self.reward_count>10 then
			   shutdown()
			   print("����10�η���")
			   self:giveup()
			   return
			 end
			 self:task_failure()
			 self:shiwei()
             self:reward()
			 local f=function()
			    self:recover()
			 end
			 f_wait(f,15)
		    return
		   end
	       wait.time(5)
          end)
		 end
		 f_wait(f,1)
	else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
		local w=walk.new()
	    local al
        al=alias.new()
		al.do_jobing=true
        al.break_in_failure=function()
		  self:giveup()
	    end
	    w.user_alias=al
        --self:dog_claw()
		self:shiwei()
        self:reward()
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
         local f=function(e)
           self:checkPlace(e,targetRoomNo)
	     end
	     WhereAmI(f,10000)
        end
      w:go(targetRoomNo)
	end
end

function tiandi:jobDone()
end

function tiandi:test_combat()
end

function tiandi:wait_reward()
     wait.make(function()
	--��ϲ������˳����ɣ�������������ʮ�ŵ㾭�飬��ʮ��Ǳ�ܵĽ�����
	  local l,w=wait.regexp("^(> |)"..self.npc.."��ȭ��������ɽ���ģ���ˮ���������Ǻ�����ڣ�.*|^(> |)��ϲ������˳����ɣ�������(.*)���飬(.*)��Ǳ�ܵĽ�����$|^(> |)��ϲ�㣡��ɹ����������ػ������㱻�����ˣ�$",5)
	  if l==nil then
		self:wait_reward()
	    return
	  end
	  if  string.find(l,"��ɽ����") or string.find(l,"��ϲ������˳�����") or string.find(l,"�㱻������")  then
	     print("tdh ok2")
		 --world.AppendToNotepad (WorldName(),os.date()..": ��ػ�job ����".. w[2].." Ǳ��:"..w[3].."\r\n")
		 self.is_end=true
		  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- yellow on whit
		  --local exps=world.GetVariable("get_exp")
		 --exps=tonumber(exps)+ChineseNum(w[2])
		 --world.SetVariable("get_exp",exps)
		    local rc=reward.new()
			rc.finish=function()
			   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ػ�����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- yellow on white
			end
			 rc:get_reward()

		     self:test_combat()
	     return
	  end
	  wait.time(5)
	end)
end

--ֻ���ɳ�ΰ��Զ�����һ�������������������������������������������������ʮ�㡣
function tiandi:reward()
    --print("������",self.link_man)
    wait.make(function()
	--��ϲ������˳����ɣ�������������ʮ�ŵ㾭�飬��ʮ��Ǳ�ܵĽ�����
	  local l,w=wait.regexp("(> |)"..self.npc.."��ȭ��������ɽ���ģ���ˮ���������Ǻ�����ڣ�.*|^(> |)��ϲ������˳����ɣ�������(.*)���飬(.*)��Ǳ�ܵĽ�����$|^(> |)��ϲ�㣡��ɹ����������ػ������㱻�����ˣ�$|^(> |)ֻ��"..self.link_man.."��Զ�����һ�������������������������������������������������ʮ�㡣$",5)
	  if l==nil then
		self:reward()
	    return
	  end
	  if string.find(l,"��ɽ����") or string.find(l,"��ϲ������˳�����") or string.find(l,"�㱻������") then
		 shutdown()
		 print("tdh ok1")
           local rc=reward.new()
			rc.finish=function()
			   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ػ�����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- yellow on white
			end
			 rc:get_reward()

		  --f_wait(f,0.8)
		  local b=busy.new()
		  b.Next=function()
		    self:jobDone()
		  end
		  b:jifa()
	     return
	  end
	  if string.find(l,"��������������") then
	     print("�������!!!")
		 shutdown()
		if self.fighting==false then
		  self:reset()
		end
		 self:shiwei()
		 self.is_combat=true
		 self:combat()
		 self:wait_reward()
	     return
	  end
	  wait.time(5)
	end)
end


local function short_dir(dir)
   local d=dir
   d=string.gsub(d,"eastdown","ed")
   d=string.gsub(d,"westdown","wd")
   d=string.gsub(d,"northdown","nd")
   d=string.gsub(d,"southdown","sd")
   d=string.gsub(d,"eastup","eu")
   d=string.gsub(d,"westup","wu")
   d=string.gsub(d,"northup","nu")
   d=string.gsub(d,"southup","su")
   d=string.gsub(d,"northwest","nw")
   d=string.gsub(d,"northeast","ne")
   d=string.gsub(d,"southwest","sw")
   d=string.gsub(d,"southeast","se")
   d=string.gsub(d,"east","e")
   d=string.gsub(d,"west","w")
   d=string.gsub(d,"south","s")
   d=string.gsub(d,"north","n")
   d=string.gsub(d,"up","u")
   d=string.gsub(d,"down","d")
   return d
end

local steps=0
function tiandi:go(dir)

	 world.Execute(dir)
	 local f=function()
	    steps=steps+1
		print("����:",steps)
		if steps>20 then
           self.is_wander=false
		   self:back()
		else
		  self:go(dir)
		end
	 end
	 f_wait(f,0.5)

end

local function get_dir(dx)
   print(dx," in ")
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

function tiandi:wander()
   local _R=Room.new()
    local _R
	_R=Room.new()
	_R.CatchEnd=function()
	    print(_R.roomname,"��������")
        print(_R.exits)
		local dx=Split(_R.exits,";")
		local _dir=""
		for _,d in ipairs(dx) do
		   if d~="enter" and d~="out" then
		      _dir=d
			  break
		   end
		end
		if _dir=="" then
			_dir=string.gsub(_R.exits,";","")
		end
		--print(_dir)
		local rev_dir=get_dir(_dir)
		--print(rev_dir," rev")
		local path=_dir..";"..rev_dir
		path=short_dir(path)
		--print(path)
		if _R.roomname=="����ƺ" or _R.roomname=="��ʯ��" then
		   path="w;e"
		elseif _R.roomname=="��̳" and _R.zone=="��ɽ" then
		   world.Send("out")
		   path="w;e"
		elseif _R.roomname=="����С·" or _R.roomname=="���" then
		   path="n;s"
		elseif _R.roomname=="ɽ��С·" then  --��̶��busy
		   path="wu;ed"
		elseif _R.roomname=="��ɼ��" then
		   path="se;nw"
		elseif _R.roomname=="����" and _R.zone=="�ؽ�" then
		   path="s;n"
		elseif _R.roomname=="��̨ǰ�㳡" then
		   path="n;s"
		elseif _R.roomname=="����������" then
		   world.Send("e")
		   path="s;n"
		end
		self:shiwei()
		self:go(path)
	end
	_R:CatchStart()
end

function tiandi:reset()
end

local wave=1
function tiandi:back()
	 if self.is_end==true then
	    self:jobDone()
	    return
	 end

	 print("�رվ��䴥����,�ص������˴�����")
	 shutdown()
	 self:shield()
	 if self.fighting==false then
		  self:reset()
		end
	 if self.is_wander==true then
	    steps=0
		self:task_failure()
		self:wander()
	    return
	 end

	 print("�Ƿ񵽴�Ŀ�ĵ�:",self.is_combat)
	 if self.is_combat==true and wave<=8 then
	    print(wave,"����")
	     --shutdown()
		 wave=wave+1
	     self:shiwei()
		 self:reward()
		 check_fight=true
		 self:combat()
	     --self:test_combat()  --���ս����
		 return
	 elseif self.is_combat==true and wave>8 then
	   local b=busy.new()
	   b.Next=function()
	    self:giveup() --�쳣
	   end
	   b:jifa()
		return
	 end
	--[[ if self.is_combat==true and check_fight==false then
	     print("�Ƿ�ս������:",self.is_fight)
		 self:shiwei()
		 self:reward()
		 check_fight=true
		 self:combat()
	     self:test_combat()  --���ս����
		 return
	 end
	 check_fight=false
	 wave=1
	 if self.is_combat==true and self.is_move==false then
	    print("����ƶ�")

		local _R={}
        _R=Room.new()
        _R.CatchEnd=function()
			local ex={}
			ex=Split(_R.exits,";")
			local n=math.random(table.getn(ex))
			print(n)
			local f=function()
			    self:back()
			end
			local dx=ex[n]
			print("���ͷ���:",dx)
			--self.is_combat=false
			self.is_move=true
			world.Send(dx)
			--self:shiwei()
			self:combat()
			self:reward()
			f_wait(f,5)

		end
	     _R:CatchStart()
		 return
	 end]]
	self.is_move=false
   local rooms=self.link_man_room
   if self.link_man_room[1]~="1965" then
	   rooms=depth_search(rooms,1)
   else
      print("�����޺�")
   end

   local npc=self.link_man
   self:task_failure()
   tiandi.co=coroutine.create(function()
     for _,r in ipairs(rooms) do
        local w=walk.new()
	    local al
        al=alias.new()
		al.do_jobing=true
		al:SetSearchRooms(rooms)
        al.break_in_failure=function()
		  self:giveup()
	    end

		  al.maze_done=function()
		      print("���")
	          self:checkNPC(self.npc,al.maze_step)
		  end
		  al.zoulang_shufang=function()
			  self:NextPoint()
		  end

		  if self.link_man_room[1]=="1965" then
		    al.alias_table["xingxiuhai_north"].is_search=true
		  end

		  al.shangan=function()
                wait.make(function()
               local l,w=wait.regexp("^(> |)ֻ�����䡱��һ����Сľ������ײ����ʲô��������һ�����ӱ����˳�����$|^(> |)���ͷһ����Сľ��ײ��ɢ�ܣ����������ˡ�$|^(> |)Сľ��˳�ź��磬һֱ��Ʈȥ��$",5)
	          if l==nil then
	              al:shangan()
	             return
			  end
	         if string.find(l,"ֻ�����䡱��һ����Сľ������ײ����ʲô��������һ�����ӱ����˳���") or string.find(l,"���ͷһ����Сľ��ײ��ɢ�ܣ�����������") then
	 	        local b=busy.new()
	 	        b.Next=function()
		         local shield=world.GetVariable("shield") or ""
	             if shield~="" then
	               world.Execute(shield)
				 end
				 print("��ֹ����!")
				 wait.time(3)
  	             al:finish()
		        end
		        b:check()
	            return
	         end
	        if string.find(l,"Сľ��˳�ź��磬һֱ��Ʈȥ") then
	          world.Send("hua mufa")
	          al:shangan()
			  return
	        end
			wait.time(5)
         end)
        end

		w.noway=function()
		    self:NextPoint()
		end
		w.delay=0.8
		w.Max_Step=5
		w.user_delay=1
	    w.user_alias=al
        --self:dog_claw()
		self:shiwei()
        self:reward()

        w.walkover=function()
         local f=function(e)
          self:checkPlace(e,r)
	     end
	     WhereAmI(f,10000)
        end
      w:go(r)
	  coroutine.yield()
    end
	print("û���ҵ�������!!!")
	if count<3 then
	  self:back()
	  count=count+1
	else
	  local b=busy.new()
	  b.Next=function()
	     self:giveup()
	  end
	  b:jifa()
	end
   end)
   self:NextPoint()
end

function tiandi:giveup()
      local select_pfm=world.GetVariable("tdh_pfm")
   local pfm=world.GetVariable(select_pfm)
     --local pfm=world.GetVariable("pfm") or ""
    world.Send("alias pfm "..pfm)
	--world.SetVariable("pfm",pfm)
	print("reset pfm")
	self:reset()
  local w=walk.new()
  w.walkover=function()
     world.Send("ask shikai about ����")
	 local l,w=wait.regexp("^(> |)��ʽ��˵��������Ȼ�������ˣ�Ҳ�����ˡ���$|^(> |)��ʽ��˵����������û������񣬷���ʲô������$|^(> |)��ʽ��˵����������û������񣬷���ʲô(��|ѽ)����$|^(> |)��ʽ��˵���������Ѿ���.*��ϵ���ˣ����ǿ��ȥ��.*��ϰɣ���",5)
	 if l==nil then
	   --print("��ʱ")
	   self:giveup()
	   return
	 end
	 if string.find(l,"��Ȼ�������ˣ�Ҳ������") or string.find(l,"��û�������񣬺�������ʲô") or string.find(l,"����û�������") then
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
			local f=function()
			      self:Status_Check()
			end
			Weapon_Check(f)
	   end
	   b:check()
	   return
	 end
	 if string.find(l,"��ϵ����") then
	   self:jobDone()
	   return
	 end
     wait.time(5)
  end
  w:go(104)
end
--[[
Զ���ɱ���������Ӱ�����ܱ߽У�����ǰ��������ڴˣ���ػᷴ�����ߣ�����
��躽е����������շ��������˵���������˵�ձ�����ս����һ��
���ֱ����ά���˹�ȥ������󺰵�����������������־��ܰɣ���
�����������ɱ���㣡
]]
--��ά����������һ���ж���
--[[
һ���ٲ�ģ����������ά������������ά�����ӷ��������㣬��һ�˰ɣ���
��ά�ߵ���������������ȥ���ɣ�����
������ŭ�������ٸ������շ��������˵���������˵�ձ�����άս����һ��]]
--��ϲ������˳����ɣ�������������ʮ�㾭�飬��ʮ�˵�Ǳ�ܵĽ�����
--���ˣ���������������ʧ�ܣ�
function tiandi:recover()
  if self.is_end==true then  --
     print("�Ѿ���ý���")
	 self:jobDone()
	 return
  end
  print("������")
  self:shiwei()
  if self.fighting==true then
	    print("����ս���У�ֹͣ����")
	    return
  end
  world.Send("yun recover")
  world.Send("yun refresh")
  check_fight=false
    local h
	h=hp.new()
	h.checkover=function()
	    if h.jingxue_percent<95 then --�����ж�һֱliao jing
		    local rc=heal.new()
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then --������
		    print("��ͨ����")
            local rc=heal.new()
			 rc.buy_drug=function()
			    --��ҩ�����Զ�quit
			   sj.world_init=function()
				 self:relogin()
			   end
			   local b=busy.new()
		       b.Next=function()
			     relogin(180,true)
			   end
			   b:check()
			 end
			rc.auto_drug=function()
			  print("�Դ󻹵�")
			  --world.Send("fu dahuan dan")

			  local f=function()
			    rc:heal(false)
			  end

			  rc:eat_drug("�󻹵�","dahuan dan",f)
			end
			rc.hudiegu=function()
			  rc:heal(false)
			end
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
			    if self.fighting==true then
	                print("����ս���У�ֹͣ����")
					return
                end
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun jing")
				  world.Send("yun recover")
				  local f=function()
				     self:recover()
				  end
				  f_wait(f,2)
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
			          self:recover()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
			    if self.fighting==true then
                   print("����ս���У�ֹͣ����")
	               return
               end
			   world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			      print("״̬�ָ�")
				  self:back()
			   else
	             print("��������")
		         self:recover()
			   end
			end
			x:dazuo()
		else
		     print("״̬����")
		     self:back()
		end
	end
	h:check()
end

function tiandi:combat()

end

--��ǰ���� ������(Ding jianji)
function tiandi:shiwei_escape()
  --��������
  --��- ��
  --��ʱת�ۼ��ߵ���Ӱ���١�֧��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�������ת�ۼ��ߵ���Ӱ���١�
  --print("�������ܴ���")
  wait.make(function()
    local l,w=wait.regexp("^(> |)(.*)ת�ۼ��ߵ���Ӱ���١�$|^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",5)
	if l==nil then
	   self:shiwei_escape()
	   return
	end
	if string.find(l,"ת�ۼ��ߵ���Ӱ����") then
	   print("escape")
       for index,item in ipairs(self.shiwei_list) do
	      if string.find(item.name,w[2]) then
		     print("�Ƴ�",item.name)
		     table.remove(self.shiwei_list,index)
			 break
		  end
	   end
	   print("����:",table.getn(self.shiwei_list))
	   if table.getn(self.shiwei_list)>0 then
	     self:shiwei_escape()
		else
		 self:sure_shiwei()
	   end
	   return
	end
	if string.find(l,"�����ų鶯�˼��¾�����") then
	   for index,item in ipairs(self.shiwei_list) do
	      if string.find(item.name,w[4]) then
		     print("�Ƴ�",item.name)
		     table.remove(self.shiwei_list,index)
			 break
		  end
	   end
	   if table.getn(self.shiwei_list)>0 then
	     self:shiwei_escape()
		else
		  self:sure_shiwei()
	   end
	   return
	end
	wait.time(5)
  end)
end

function tiandi:sure_shiwei() --ȷ��shiwei name id�¼�
   print("��������:",table.getn(self.shiwei_list))
end

function tiandi:kill_shiwei()
  wait.make(function()
     local l,w=wait.regexp("^(> |)�����ֹս����$|^(> |)���ﲻ׼ս����$",10)
	 if l==nil then
	    self:kill_shiwei()
	    return
	 end
	 if string.find(l,"�����ֹս��") or string.find(l,"���ﲻ׼ս��") then
	    print("��ֹս��")
	    shutdown()
		local f=function()
	     self:back()
		end
		f_wait(f,0.8)
	    return
	 end

  end)
end

function tiandi:shield()

end

function tiandi:look_shiwei(shiwei_name)
   world.Send("look")
   world.Send("set action ���")
  wait.make(function()
   print("�鿴����id:",shiwei_name)
   local l,w=wait.regexp("^(> |)\\s+��ǰ����\\s*"..shiwei_name.."\\\((.*)\\\).*$|^(> |)�趨����������action \\= \\\"���\\\"",5)
   if l==nil then
     self:look_shiwei(shiwei_name)
     return
   end
   if string.find(l,"��ǰ����") then
      --if shiwei_name==nil or string.find(w[2],shiwei_name) then
        print("��͢ӥצ:",shiwei_name)
        local shiwei_id=string.lower(Trim(w[2]))
		local _item={}
		_item.name=Trim(shiwei_name)
		_item.id=shiwei_id
		table.insert(self.shiwei_list,_item)
		--��+ ��
		world.Send("kill "..shiwei_id)
		if self.fighting==false then
		  self:reset()
		end
		self:sure_shiwei()
        self:kill_shiwei()
	    self:combat()
        return
	  --end
   end
   if string.find(l,"�趨����������action") then
      self.fighting=false
      self:recover()
      return
   end
   wait.time(5)
  end)
end
--[[
> ��������������ɱ���㣡
��������������ɱ���㣡
������������ɱ���㣡
����ǫ��˻���ߵؽе�������ﲢ�����ϰ�������
Χ�۵���Ⱥ��ͻȻ���˺���������ǰ�������ɵ��ڴˣ��������ߣ�����
���ɽе����������շ��������˵���������˵�ձ����г���ս����һ��
--]]
function tiandi:shiwei()
  wait.make(function()
    --local l,w=wait.regexp("^(> |)һ���ٲ�ģ��������"..npc.."����������"..npc.."�����ӷ��������㣬��һ�˰ɣ���",5)
	--�����սе����������շ��������˵���������˵�ձ�����ս����һ��
	--������ֱ���Ϸ����˹�ȥ������󺰵�����������������־��ܰɣ���
--[[
	get gold from corpse
������
yun recover
yun refresh
hp
> ���Ҳ��� corpse ����������
> ŷ������Ҿ������ �����֡���è�֣�·�������ˣ���л��è����������
ŷ����������������������������ڣ����ǻ��Ƿֱ��˰ɡ���
ŷ������ȭ��������ɽ���ģ���ˮ���������Ǻ�����ڣ���
��ϲ�㣡��ɹ����������ػ������㱻�����ˣ�
һǧ���ٰ�ʮ���㾭��!
�İ���ʮ����Ǳ��!
�˰پ�ʮ�ߵ�����
�㾲����������������ղŵ�������̣�������Ȼ���ʡ��������صõ���һǧ����ʮ�ŵ㾭�飡
]]
	 local player_name=world.GetVariable("player_name")
	 local l,w=wait.regexp("^(> |)(.*)(��|ŭ)������.*�����˵���������˵�ձ���("..self.hero_name.."|��)ս����һ��$|^(> |)(.*)(��|ŭ)������.*�����˵���������˵�ձ���"..player_name.."��ս����һ��$|^(> |)���ˣ�.*����������ʧ�ܣ�$|^(> |)"..self.npc.."��ȭ��������ɽ���ģ���ˮ���������Ǻ�����ڣ���$",5)
     if l==nil then
	    self:shiwei()
		return
	 end
	 if string.find(l,player_name) then
	     print("�������2!!!")
		 shutdown()
		 if self.fighting==false then
		  self:reset()
		end
		 self:shiwei()
		 self.is_combat=true
		 self:combat()
		 self:wait_reward()
		return
	 end
	 if string.find(l,"���Ǻ������") then
	    shutdown()
		 print("tdh ok1")
           local rc=reward.new()
			rc.finish=function()
			   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ػ�����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- yellow on white
			end
			 rc:get_reward()

		  --f_wait(f,0.8)
		 self:jobDone()
	    return
	 end
	 if string.find(l,"ս����һ��") then
	    print("��ǰ����"..w[2])
	    shutdown()
		if self.fighting==false then
		  self:reset()
		end
	    self.fighting=true
		self:look_shiwei(w[2])
		self:shiwei_escape()
        self:shiwei()
		return
	 end
	 if string.find(l,"����ʧ��") then
	    shutdown()
		local f=function()
		  print("����ʧ��,�ӳ�3s")
	      self:giveup()
		end
		f_wait(f,3)
	    return
	 end
   end)
end

function tiandi:guard(npc,id)

     id=string.lower(id)
	   wait.make(function()
		  self:shield()
	  	   wait.time(1.5)
	       world.Send("ask "..id.." about ��ػ�")
	       wait.time(2)

           world.Send("ask "..id.." about ���帴��")
	   local l,w=wait.regexp("^(> |)"..npc.."����������һ���ж���|^(> |)"..npc.."ͦ��ͦ�أ������ض���˵���ǵ�Ȼ����$|^(> |)����û������ˡ�$",5)
	   if l==nil then
	    self:guard(npc,id)
	    return
	   end
	   if string.find(l,"����û�������") then
	      shutdown()
		  self:NextPoint()
	      return
	   end
	   --��ǰ���� ����(Liao po)
	   if string.find(l,"����������һ���ж�") then
	   	  local ts={
	           task_name="��ػ�",
	           task_stepname="����",
	           task_step=5,
	           task_maxsteps=5,
	           task_location=self.link_man_room[1],
	           task_description="",
	       }
	      local st=status_win.new()
	      st:init(nil,nil,ts)
	      st:task_draw_win()
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ػ�����:���صص�:"..self.link_man_room[1], "white", "black")
		print("�ȴ���ǰ����")
		self:auto_pfm()
		self.shiwei_list={}
		self:shiwei(npc)
		wait.time(8)
		print("���������ȥ������?")
		count=1
		self:back()
	    return
	   end
	   if string.find(l,"ͦ��ͦ�أ������ض���˵") then
		self:look_shiwei()
	    return
	   end
       wait.time(5)
	   end)
end

function tiandi:Status_Check()

	 	 	 	 local ts={
	           task_name="��ػ�",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 self.is_end=false
	 self.is_combat=false
	 self.fighting=false
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
		     if h.food<50 then
		       world.Send("ask xiao tong about ʳ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get fan")
			  	 world.Execute("eat fan;eat fan;eat fan;eat fan;drop fan")
				 local f
				 f=function()
				   self:Status_Check()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 elseif h.drink<50 then
			   world.Send("ask xiao tong about ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get cha")
			  	 world.Execute("drink cha;drink cha;drink cha;drop cha")
				 local f
				 f=function()
				    self:Status_Check()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 end
		   end
		   w:go(133) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
		    print("����")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=300
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
		         w:go(103)
			   end
			end
			x.success=function(h)

			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
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
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end

function tiandi:task_failure()
   wait.make(function()
     local l,w=wait.regexp("���ˣ�.*����������ʧ�ܣ�",20)
	 if l==nil then
	   self:task_failure()
	   return
	 end
	 if string.find(l,"����ʧ��") then
	    shutdown()
		self:jobDone()
	    return
	 end
     wait.time(20)
   end)
end
--���ˣ�ˮ������������ʧ�ܣ�
