--  ��˹����(Bosi shangren)
--> ���ٶ�̫�����ɹ���ʿ�ѹ����湬-����������ʧ�ܡ�
--��һ��������һ����ɽ��ɽ���վ�������³������˵�����湬-�������㲻����ԥ����Ȼ�������ݶ��ϣ�

local look_count=0

kjmg={
  new=function()
    local _kjmg={}
	 setmetatable(_kjmg,{__index=kjmg})
	 return _kjmg
  end,
  robber_name="�ɹ���ʿ",
  robber_id="wushi",
  wave_set=2, --Ĭ����12��
  wave=0,
  smy_safety_percent=0.6,
  neili_upper=1.9,

}


function kjmg:combat()

end
--[[
function kjmg:run(i)


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
			   --self:giveup()
			   self:job_failure()
         self:jobDone()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end]]

function kjmg:shield()
end

function kjmg:job_failure() --�ص�����
end

function kjmg:jobDone()

end

function kjmg:jobDone()--�ص�
end

function kjmg:is_reward()

       wait.make(function()
	      local l,w=wait.regexp("^(> |)һ��������ת����һ���㱣��ŷ����Լ��˳��˸����ռ䡣$",30)
		  if l==nil then
		     self:is_reward()
		     return
		  end
		  if string.find(l,"һ��������ת����һ���㱣��ŷ����Լ��˳��˸����ռ�") then

		     self:jobDone()

		     return
		  end

	   end)
end


function kjmg:liaoshang_fail()
end

function kjmg:full_food()

	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
   local h
	h=hp.new()
	h.checkover=function()
       if  h.qi_percent<=liao_percent or h.jingxue_percent<=80 then
		    print("����")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc.liaoshang_fail=function()
			   print("kjmg ����fail")
			   self:liaoshang_fail()
			end
			rc:liaoshang()

		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
--- yrs �ر�
		elseif 1==1 then
                  self:ask_job()
               end
    	end
  	h:check()
end

function kjmg:full_neili()

    local qi_percent=tonumber(world.GetVariable("qi_percent")) or 100

	local h
	h=hp.new()
	h.checkover=function()
		if h.jingxue_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			--rc.saferoom=505
			rc.heal_ok=function()
			    self:full_neili()
			end
			rc:heal(false,true)
		elseif h.qi_percent<qi_percent then
			print("��ͨ����")
            local rc=heal.new()
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:full_neili()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper)  then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self:full_neili()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,10)
			    end
				if id==777 then
				  self:full_neili()
				end
				if id==101 then
				   world.Send("yun qi")
				   world.Send("yun jing")
				   self:full_neili()
				end
	           if id==202 then
	              local b
			       b=busy.new()
			       b.Next=function()
				     self:auto_pfm()
					 look_count=0
			         self:wait_wushi()
			       end
			       b:check()
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*1.2)
			   world.Send("yun recover")
			   if h.neili>h.max_neili*1.2 then
			       self:auto_pfm()
				   look_count=0
			       --self:wait_wushi()
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			   self:auto_pfm()
			  --self:wait_wushi()
			end
			b:check()
		end
	end
	h:check()
end


function kjmg:Status_Check()
	local ts={
	           task_name="���湬-����",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=4,
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
			     if i[1]=="�����ƶ�" then
				   print("�ж���")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
			          self:Status_Check()
			        end
			        rc:qudu()
				    return
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
			        rc:heal()
				    return
				 end
			   end
		     end
            self:full_food()
	end
	cd:start()
end

function kjmg:qu_gold()
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
		   self:buy_zhengqidan()
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
--[[

function kjmg:buy_zhengqidan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy zhengqi dan")
	 local l,w=wait.regexp("����.*�ļ۸��ҩ���ƹ�����������һ����������|^(> |)������Ķ���������û�С�$|^(> |)��⵰��һ�ߴ���ȥ��",5)
	 if l==nil then
	   self:buy_zhengqidan()
	   return
	 end
	 if string.find(l,"������Ķ���������û��") then
	   local f=function()
	     self:buy_zhengqidan()
	   end
	   print("5s �Ժ����")
	   f_wait(f,5)
	   return
	 end
	 if string.find(l,"һ��������") then
	    self:eat_zhengqidan()
	    return
	 end
	 if string.find(l,"��⵰��һ�ߴ���ȥ") then
	    self:qu_gold()
	    return
	 end
	 wait.time(5)
	end)
 end
 w:go(413)
end

function kjmg:eat_zhengqidan()
    wait.make(function()
      world.Send("fu zhengqi dan")
	  world.Send("fu dan")
	  local l,w=wait.regexp("^(> |)�����һ������������ʱ�о��������������$",5)
	  if l==nil then
	    self:eat_zhengqidan()
	    return
	  end
	  if string.find(l,"�����һ��������") then
	    self:ask_job()
		return
	  end
	  wait.time(5)
	end)
end

function kjmg:look_zhengqidan()
--  ��ʮ�����Ϣ��(Neixi wan)
 wait.make(function()
   world.Send("i")
   world.Send("set look")
   local l,w=wait.regexp("^(> |)(.*)��������\\(Zhengqi dan\\)$|^(> |)�趨����������look \\= \\\"YES\\\"",5)
   if l==nil then
      self:look_zhengqidan()
      return
   end
   if string.find(l,"������") then
	  self:eat_zhengqidan()
	  return
   end
   if string.find(l,"�趨����������look ") then
	  self:buy_zhengqidan()
	  return
   end
   wait.time(5)
  end)
end
]]

function kjmg:catch()
  wait.make(function()
    local l,w=wait.regexp("^(> |)�㰴�°������أ���Ӱһ�����Ѳ���ԭ����$|^(> |)�´�ͨ˵���������ϴ����������ˣ���������Ϣһ����˵�ɡ���$",5)

	if l==nil then
	   self:ask_job()
	   return
	end
	if string.find(l,"�㰴�°�������") then
      print ("��ʼ�����湬��")
	  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."���湬-��������:������ʼ��", "yellow", "black") -- yellow on white

	  local ts={
	           task_name="���湬",
	           task_stepname="ǰ�����湬",
	           task_step=2,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  self.wave=0
	   local b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	    self:shield()
	    self:gowushi()
           -- self:jobDone()
	   end
	   b:check()
	   return
	end
	if string.find(l,"����������û��ʲô����") then
	    print ("kjmg busy wait")
	    shutdown()
		self.fail(201)
	   return
	end

	if string.find(l,"���ϴ�����������") then
	    print ("kjmg busy ��job")
	    shutdown()
	    self.fail(101)
	   return
	end

	wait.time(5)
  end)
end

function kjmg:fail(id)

end

function kjmg:ask_job()
  local w=walk.new()
  w.walkover=function()

     world.Send("ask hao about �ֿ��ɹ�����")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)����´�ͨ�����йء��ֿ��ɹ����֡�����Ϣ��$",5)
	--   print ("smy catch 1")
	   if l==nil then
	--     print ("smy no catch ")
	     self:ask_job()
	     return
	   end
	   if string.find(l,"����´�ͨ�����й�") then
	--     print ("smy catch 2")
	     self:catch()
       --  self:jobDone()
	     return
	   end
	   wait.time(5)
	 end)
  end
  w:go(4173)
end

function kjmg:auto_pfm()

end

--��һ���㱣���ϸһ��ȴ���ѵ������湬-������

function kjmg:gowushi()
  self:wait_wushi()
 self:full_neili()
--[[
   cllimbya=false
  self:climb()
--��һ��������һ����ɽ��ɽ���վ�������³������˵�����湬-�������㲻����ԥ����Ȼ�������ݶ��ϣ�
  local w=walk.new()
  w.walkover=function()
   world.Send("set ����")
   --self:auto_pfm()
     if climbya==true then
      self:kill_finish()
	  self:full_neili()
	else
	   local _R
        _R=Room.new()
        _R.CatchEnd=function()
		  if _R.roomname=="���湬-����" then
		      self:jobDone()
		  else
	          self:gowushi()
		  end
	    end
	    _R:CatchStart()
	end
  end
  w:go(1870)]]
end

function kjmg:skills_index(ski)
   local skills={}
   skills["�����޷�"]=0
   skills["��������"]=1
   skills["�����ȷ�"]=2
   skills["��ɽ�ȷ�"]=3
   skills["�򹷰���"]=4
   skills["����ȭ"]=5
   skills["���е���"]=6
   skills["��ս�����"]=7
   skills["����ذ��"]=8
   skills["��а����"]=9
   skills["Ľ�ݽ���"]=10
   skills["���е���"]=11
   skills["ȼľ��"]=12
   if skills[ski]==nil then
      return 10000
	else
	  return skills[ski]
   end
end

function kjmg:kill_first(ski1,ski2)
  local index1=self:skills_index(ski1)
  local index2=self:skills_index(ski2)
  local id="wushi"
  if index1>index2 then
      id="wushi 2"
  end
  if index2>index1 then
      id="wushi"
  end
  return id
end

function kjmg:leavefb()
   world.Execute("halt;leavefb")
   wait.make(function()
      local l,w=wait.regexp("^(> |)һ��������ת����һ���㱣��ŷ����Լ��˳��˸����ռ䡣$",1)
	  if l==nil then
	    self:leavefb()
		return
	  end
	  if string.find(l,"�ŷ����Լ��˳��˸����ռ�") then
	     world.AppendToNotepad (WorldName().."_�����ɹ�����:",os.date().." Σ�ռ������븱��\r\n")
	     self:finish()
	    return
	  end
   end)
end

function kjmg:check_skills(ski1,ski2)
    world.Execute("look wushi;look wushi 2;set action ����")
	wait.make(function()
	--���˿���ȥʦ���䵱�ɣ��ó�ʹ�����鵶���˵У�
	  local l,w=wait.regexp("^(> |)���˿���ȥʦ��.*���ó�ʹ��(.*)�˵�.*$|^(> |)�趨����������action \\= \\\"����\\\"$",5)

	  if l==nil then
        self:check_skills(ski1,ski2)
	    return
	  end
	  if string.find(l,"���˿���ȥʦ��") then
		  local skill=w[2]
		  print(skill," ����")
		  if ski1==nil then
		     ski1=skill
		  else
		     ski2=skill
		  end
		  self:check_skills(ski1,ski2)
	     return
	  end
	  if string.find(l,"����") then
	    print(ski1," 1 ",ski2," 2 skills")
		--[[if string.find(ski1,"���⵶��") or string.find(ski2,"���⵶��") then
		   self:leavefb()
		   return
		end]]
		if ski1==nil then
		   ski1=""
		end
		if ski2==nil then
		   ski2=""
		end

		 local id=self:kill_first(ski1,ski2)
		 self.robber_id=id
		 self.target(id)
		 		local ts={
	           task_name="���湬-����",
	           task_stepname="ս��,����kill "..id,
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="��ʿ1:"..ski1.." ��ʿ2:"..ski2,
	    }
	     local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
	     return
	  end
	end)
end

function kjmg:target(id) --ָ��id
end
--���ɹ���ʿ �ɹ���ʿ(Menggu wushi) <���Բ���>
function kjmg:wait_wushi()
  print("wait_wushi")
   world.Send("look")
  self.robber_id="wushi"
--shutdown()
  wait.make(function()
   --�㶨��һ����ԭ�����������������Ҵ����书���ߣ��ƺ��õ��������ɵ�Ѹ��ʮ������
   --  ����һƷ����ʿ ��ܽ(Ha fu) <ս����>
      local l,w=wait.regexp("^(> |)ɽ�±����С·������������Ӱ�������������������Ӱս����һ��$|^(> |).*����������������Х�����������󡱣����������ش��˳�ȥ��$|.*���ɹ���ʿ �ɹ���ʿ.*\\(.*\\) \\<ս����\\>$|.*���ɹ���ʿ �ɹ���ʿ.*\\(.*\\) \\<���Բ���\\>$",5)
	  if l==nil then
            -- world.Send("look")
             --shutdown()
		 look_count=look_count+1
		 print(look_count,"~lookcount")
         if look_count>300 then
			shutdown()
			world.Send("leavefb")
			self:jobDone()
		    return
		 end
	     self:wait_wushi()
		 return
	  end
	    if string.find(l,"��������") or string.find(l,"ս����") or string.find(l,"�����������������Ӱս����һ��") then
	     print("�ɹ���ʿ����")
         look_count=0
             shutdown()
			-- world.Execute("kill wushi;kill wushi 2")
			 self:check_skills()
             self:combat()
	    self:wait_wushi_die()
		 return
	  end
	  if string.find(l,"���Բ���") then
	     self:wait_wushi_die()
	     return
	  end


--	  wait.time(3)
   end)
end

function kjmg:reset(id)
end

--Զ����ɽ·����һ����Х����Լ��������ʩչ�Ṧ�ɳ۶�����
function kjmg:wait_wushi_die()
  print("wait wushi die")
  world.Send("kill wushi")
  wait.make(function()
   --�㶨��һ����ԭ�����������������Ҵ����书���ߣ��ƺ��õ��������ɵ�Ѹ��ʮ������
   --��ˡ�ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
      local l,w=wait.regexp("^(> |).*��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$|^(> |).*������������׼�����쳷��˵��ת����ȥ��$",10)
	  if l==nil then
	     self:wait_wushi_die()
		 return
	  end

	--  if string.find(l,"�ɹ���ʿ��������") then
--	     print("�ɹ���ʿ����")
	   --  world.Send("ppi")
	     --world.Send("set wimpycmd wield zhubang\\perform chuo wushi\\perform pi wushi\\yun jingli\\hp")
	  --   world.Send("set wimpy 100")
--	    self:wait_wushi_die()
--		   --self:get_id(w[2])
--		 return
--	  end

--[[
	  if string.find(l,"�ɹ���ʿ��־�Ժ�������һ������") then
	     print("�ɹ���ʿ�ε���")
	    world.Send("kill wushi")
	    self:wait_wushi_die()
		   --self:get_id(w[2])
		 return
	  end]]
	  if string.find(l,"�����ų鶯�˼��¾�����") then
	     print("�ɹ���ʿ����һ��")
        if self.robber_id=="wushi 2" then
		   self.robber_id="wushi"
		   self.reset("wushi")
		end
	    self:wait_wushi_die()
		   --self:get_id(w[2])
		 return
	  end
	  if string.find(l,"��������׼�����쳷") then
	     print("ʧ��")
		 shutdown()
		 self.fail(102)
	     return
	  end
	  if string.find(l,"����û�������") then
	     --print("���Գ�����")
       --self.win=true
	 --  local b=busy.new()
	 --  b.interval=0.3
	 --  b.Next=function()

	    shutdown()
	    self.wave=self.wave+1
		local ts={
	           task_name="���湬-����",
	           task_stepname="�ָ�",
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="����:"..self.wave,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	if self.wave>12 then
	  self:is_reward()
	    local b=busy.new()
		b.Next=function()
	      world.Execute("get silver from corpse;get silver from corpse 2")
		   world.Execute("get gold from corpse;get gold from corpse 2")
		   world.Send("get zhuanji")
		end
		b:jifa()
	  return
	end
	    local b=busy.new()
		b.Next=function()
	      world.Execute("get silver from corpse;get silver from corpse 2")
		   world.Execute("get gold from corpse;get gold from corpse 2")
		   world.Send("get zhuanji")
		   --self:auto_pfm()
		if self.wave_set<=self.wave  then


		   local ts={
	           task_name="���湬-����",
	           task_stepname="����",
	           task_step=4,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	       }
	      local st=status_win.new()
	       st:init(nil,nil,ts)
	       st:task_draw_win()
		   self:is_reward()
			world.Execute("leavefb")

		else
		   self:is_giveup()
	    end
        end
		b:jifa()

	 --  b:check()
	   return
	  end
	--  wait.time(10)
   end)
end

function kjmg:is_giveup()
   local h=hp.new()
   h.checkover=function()
     print(h.qi_percent,">=",self.smy_safety_percent*100,":��Ѫ")
	 print(h.neili,">=",h.max_neili*0.8,":����")
     if h.neili>=h.max_neili*0.8 and h.qi_percent>=self.smy_safety_percent*100 then
      local b=busy.new()
	   b.Next=function()
	       self:auto_pfm()
	       self:full_neili()
 	       self:wait_wushi()
	   end
	   b:check()
	 else
	   print("������������!")
	   world.Execute("leavefb")
	   self:jobDone()
	 end
  end
  h:check()
end

function kjmg:get_weapon()

end
--[[
function kjmg:kill_finish()
  --Զ����ɽ·����һ����Х����Լ��������ʩչ�Ṧ�ɳ۶�����
  wait.make(function()
    local l,w=wait.regexp("^(> |)�·���С·������������Ӱ�������������������Ӱս����һ��$|^(> |)�ã���������ˣ���õ���(.*)��ʵս���飬��ʮ���Ǳ�ܺ�(.*)������$",6)
	if l==nil then
	  world.Send("look")
	  print("kill finish")
	  self:kill_finish()
	  return
	end
	if string.find(l,"��Լ��������ʩչ�Ṧ�ɳ۶���") then
	  --shutdown()
	  look_count=0
	  self:wait_wushi()

	  local b=busy.new()
	  b.Next=function()
	    --�Զ�get weapon
		self:get_weapon()
		self:shield()
	    self:auto_pfm()

	  end
	  b:check()
	  return
	end
	 if string.find(l,"���������") then
       --   shutdown()
       print("���� jobDone")
       shutdown()
	   self:get_weapon()
	        self:jobDone()
	     return
	   end
  end)
 print("kill finish")
  local w=walk.new()
  w.walkover=function()
   world.Send("set ����")
	     self:job_finish()
	     return
  end
  w:go(1869)
end]]

function kjmg:job_finish()
 print("kjmg finish")
 shutdown()
      wait.make(function()
--     local l,w=wait.regexp("������(.*)�㾭�飬(.*)��Ǳ�ܣ�����������������ˣ�$",30)
	   local l,w=wait.regexp("^(> |)�ã���������ˣ���õ���(.*)��ʵս���飬��ʮ���Ǳ�ܺ�(.*)������$",10)
	   if l==nil then
      -- shutdown()
       print("��û���� jobDone")
	     self:jobDone()
	     return
	   end
	   if string.find(l,"���������") then
       --   shutdown()
       print("���� jobDone")
          world.Send("wu;get silver from corpse;get silver from corpse 2")
	        self:jobDone()
	     return
	   end
	   wait.time(10)
	 end)
end
