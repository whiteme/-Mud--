--���ַ���
-- 2:                       �����־�Ԯ���ܡ�
-- 3: ������������������������������������������������������������
-- 4:
-- 5:     ħ�̽�������������Σ������������ʴ��ǰ����ɽ���������
-- 6: ɽ�ɣ�������Ϊ�׵��������ȷ��������ֳ��Ϸ�����ʦ�����ֵ���
-- 7: ��ǰ����ɽ��Ԯ��
-- 8:
-- 9: ������������������������������������������������������������
--10:                         ������Ҫ��
--11: ������������������������������������������������������������
--12:
--13:     �Ŷӣ�����������ӣ���Ա����ֵ������1m����Ա��������
--14:           1m�����������ֵ������������죬��Ա�������ɡ�
--15:     ���ˣ�����ֵ����3m��ֻ�������ֵ��ӡ�
--16:
--17: ������������������������������������������������������������
--18:                         ��������̡�
--19: ������������������������������������������������������������
--20:
--21:     �ڷ������ɶ������������ȴ�ʦҪ���� ask dashi about job��
--22: ��ʦ������㷽����ʦ���ںδ�����ָ���ص��ҵ�������ʦ���ɶ���
--23: ����������ʦѯ�ʾ�Ԯask dashi about ��Ԯ��������ʦ��follow
--24: �ö������죬ɱ����·��ħ�̽�ͽ�����Ѵ�ʦ������ɽ�����������
--25: ��������ɣ������ʦ�����������ʧ�ܡ�
--2553

--�������ȴ�ʦ�����йء�job������Ϣ��
--���ȴ�ʦ˵�������ҽӵ����ɵ���ͨ����ħ�̽�������������������ڣ�
--��Ѫϴ��ɽ�ɡ��䶨��ʦ̫��δ����������Ԯ�������ֲ������Ӻ�ɽ
--���������뷽����ʦ�����޺��úͰ����õ���ǰȥ��Ԯ����
--���ȴ�ʦ˵�����������λ��ͬ������ʦǰȥ��ɽ��һ·С�ġ���
--���ȴ�ʦ˵������������ʦ������ѩͤ����
--1381
--�½��ɿ� 1356 1351
--�ؼ���
--���� 211
--��Զ��  1087
--�½��ɿ� 1351
--�յ� 1381
--������ʦ�ߺ�һ��������������ҳ��ˣ����ڻ���
require "map"
require "wait"
require "heal"
require "xiulian"
require "sj_mini_win"
require "fight"

jiuyuan={
  new=function()
    local jy={}
	 setmetatable(jy,{__index=jiuyuan})
	 return jy
  end,
  co=nil,
  player_id='',
  dashi_name='',
  target_roomno=nil,
  neili_upper=1.9,
  failure=false,
}
--���Ǵ�ʦ�ߺ�һ��������������ҳ��ˣ����ڻ���
--�ؼ���
--���� 211
--��Զ��  1087
--�½��ɿ� 1351
--�յ� 1381
--���Դ�ʦ�ߺ�һ��������������ҳ��ˣ����ڻ���
function jiuyuan:jiaotu_die()
   if self.dashi_name==nil or self.dashi_name=="" then
	     self.dashi_name=world.GetVariable("dashi_name")
   end
  wait.make(function()
    local l,w=wait.regexp("^(> |)ħ�̽�ͽ��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)"..self.dashi_name.."�ߺ�һ��������������ҳ��ˣ����ڻ���$|^(> |)����û������ˡ�$",5)
	if l==nil then
	   self:jiaotu_die()
	   return
	end
   if string.find(l,"����û�������") or string.find(l,"�ߺ�һ��������������ҳ���")  then
      self:search_dashi()
      return
   end
	if string.find(l,"�����ų鶯�˼��¾�����") then
	    print("ս������2")
		shutdown()
		local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  world.Send("get silver from corpse")
		  if self.failure==true then
		    self:jobDone()
		  else
  		    self:recover()
		  end
		end
		b:check()
	   return
	end
	wait.time(5)
  end)
end
--> ��о����г�����Ȼ����������Ϊ֮һ��
function jiuyuan:zhengqi()
end

function jiuyuan:search_dashi()
-- ��λ��ǰ�����
-- ��Χ3���������
    print("Ѱ�Ҵ�ʦ!!!")
   local f=function()
      print("��λ")
	  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
		print(roomno[1]," �����")
	     --if count==1 then
	       --roomno[1]
            local rooms={}
			rooms=depth_search(roomno,3)
			--print("why")
			for _,r in ipairs(rooms) do
			  print("��Ҫ�����ķ���->",r)
			end
			jiuyuan.co=coroutine.create(function()
		      for _,r in ipairs(rooms) do
                local w
		        w=walk.new()
		        w.walkover=function()
			      --self:NextPoint()
				  local f2=function() self:NextPoint() end
				  self:check_dashi_status(f2)
		        end
		        w:go(r)
		        coroutine.yield()
              end
			  --print("û�ҵ���ʪ")
			  print("û�ҵ�")
			  self:giveup()
			end)
			self:NextPoint()
		 --end
      end
      _R:CatchStart()
   end
   self:check_dashi_status(f)
end

function jiuyuan:dashi_escape()
   if self.dashi_name==nil or self.dashi_name=="" then
	     self.dashi_name=world.GetVariable("dashi_name")
   end
  wait.make(function()
    local l,w=wait.regexp("^(> |)"..self.dashi_name.."�ߺ�һ��������������ҳ��ˣ����ڻ���$",5)
	if l==nil then
	   self:dashi_escape()
	   return
	end
   if string.find(l,"�ߺ�һ��������������ҳ���") then

      print("��ʦ����!!")
	  shutdown()
	  local f=function()
	     self:search_dashi()
	  end
	  f_wait(f,0.3)
	  return
   end
  end)

end

function jiuyuan:giveup()
   self:jobDone()
end

function jiuyuan:combat()

     local pfm=world.GetVariable("pfm1")
	 self:jiaotu_die()
	 local cb=fight.new()
	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
       pfm=string.gsub(pfm,"@id",string.lower(self.player_id).."'s jiaotu")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id",string.lower(self.player_id).."'s jiaotu")
	   cb.unarmed_alias=unarmed_pfm
	   cb.pfm_list=string.gsub(cb.pfm_list,"@id",string.lower(self.player_id).."'s jiaotu")


	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("ж������")
			cb:run()
		 end
		 sp:unwield_all()
	  end
      cb.finish=function()
	     print("ս������1")
		 local b=busy.new()
		 b.interval=0.5
		 b.Next=function()
		   world.Send("get silver from corpse")
		   if self.failure==true then
		     self:jobDone()
		   else
		     self:recover()
		   end
		 end
		 b:check()
	  end
      cb:start()
end

function jiuyuan:redo() --�ӿڻص�����
end

--���Դ�ʦ����������������ʧ�ܡ�
function jiuyuan:dashi_die()

   wait.make(function()
      if self.dashi_name==nil or self.dashi_name=="" then
	     self.dashi_name=world.GetVariable("dashi_name")
	  end
      local l,w=wait.regexp("^(> |)"..self.dashi_name.."����������������ʧ�ܡ�$",5)
	 if l==nil then
	    self:dashi_die()
	    return
	 end
	 if string.find(l,"����������������ʧ��") then
	    print("����ʧ��!!")
	   self.failure=true
	   return
	 end
   end)

end


function jiuyuan:check()
--( ����һ��������û����ɣ�����ʩ���ڹ���)
	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
   wait.make(function()
      if self.dashi_name==nil or self.dashi_name=="" then
	     self.dashi_name=world.GetVariable("dashi_name")
	  end
      local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)ͻȻ��·�߳��һ��ħ�̽�ͽ��һ�����Ե���"..self.dashi_name.."��ȥ��$",5)
	 if l==nil then
	    self:check()
	    return
	 end
	 if string.find(l,"ͻȻ��·�߳��һ��ħ�̽�ͽ��һ�����Ե���") then
	   shutdown()
	   self:dashi_escape()
       world.Send("kill "..string.lower(self.player_id).."'s jiaotu")
	   local f=function()
	      world.Send("yun qi")
	      world.Send("kill "..string.lower(self.player_id).."'s jiaotu")
		  self:dashi_die()
	      self:combat()
	   end
	   f_wait(f,0.1)
	   return
	 end
	 if string.find(l,"��Ķ�����û����ɣ������ƶ�") then
	    shutdown()
		self:shield()
		self:redo()
	   return
	 end

   end)

end

local _dashi_follow_ok=false
function jiuyuan:dashi_follow()
--�ռ���ʦ�Ӵ���ɽ�����˹�����
   wait.make(function()

	 local dashi_name=world.GetVariable("dashi_name") or self.dashi_name
     local l,w=wait.regexp("^(> |)"..dashi_name.."��.*���˹�����$",8)
	 if l==nil then
	    print("dashi follow ��ʱ")
		self:dashi_follow()
	    return
	 end
	 if string.find(l,dashi_name) then
		_dashi_follow_ok=true
	    return
	 end
	 wait.time(8)
   end)
end

function jiuyuan:check_dashi_status(callback)
--ͻȻ��·�߳��һ��ħ�̽�ͽ��һ�����Ե���ռ���ʦ��ȥ��
--  �����ɵ���ʮ������ӡ����ֳ��ϡ��ռ���ʦ(Mission's dashi) <ս����>
--  �����ɵ���ʮ������ӡ����ֳ��ϡ����Ŵ�ʦ(Qsmya's dashi) <���Բ���>
  	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
	 local dashi_name=world.GetVariable("dashi_name") or self.dashi_name
   wait.make(function()
      world.Execute("look;set look 1") --  �ռ���ʦ�����˹�����
	  local player_id=string.upper(string.sub(self.player_id,1,1))..string.lower(string.sub(self.player_id,2,-1))
      local l,w=wait.regexp("^(> |).*"..dashi_name.."\\\("..player_id.."'s dashi\\\) <���Բ���>$|^(> |).*"..dashi_name.."\\\("..player_id.."'s dashi\\\) <ս����>$|^(> |).*"..dashi_name.."�����˹�����.*$|^(> |).*"..dashi_name.."\\\("..player_id.."'s dashi\\\)$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:check_dashi_status(callback)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      --û���ҵ�
		  callback()
		  return
	  end
	  if string.find(l,"ս����") then
		 world.Send("kill "..self.player_id.."'s jiaotu")
	     local f=function()
	       world.Send("yun qi")
	       world.Send("kill "..string.lower(self.player_id).."'s jiaotu")
		   self:dashi_die()
	       self:combat()
	      end
	      f_wait(f,0.1)
	      return
	  end
	  if string.find(l,"���Բ���") then
	     f_wait(callback,3)
		 return
	  end
	  if string.find(l,player_id) or string.find(l,"�����˹�����") then
	      self:shield()
	      self:redo()
		  return
	  end
	  wait.time(6)
   end)
end

function jiuyuan:step_back()
end

function jiuyuan:step1()
	local ts={
	           task_name="���ֻ���",
	           task_stepname="��һ��·��",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="ǰ������",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	self:check()
    self.redo=function()
	    self:step1()
		--��֧
		self.step_back=function()
		   print("���¼������:",w.start_roomno)
		   self:reverse(w.start_roomno)
		end
	end
	self.step_back=function()
	  self:reverse(self.target_roomno)
	end
	self:dashi_follow()
	w.Max_Step=0
    w.user_delay=5
	w.walkoff=function()
	  --1 ȷ����ʦ�Ƿ����
	  if _dashi_follow_ok==true then --follow �ɹ�
	    print("follow �ɹ�")
        local f=function()
	      _dashi_follow_ok=false
		  self:dashi_follow()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
	    end
        f_wait(f,4)
	  else
	    print("follow ʧ��")
		if self.target_roomno==nil then
		   self.target_roomno=world.GetVariable("target_roomno")
		end
		self:step_back()
	  end
	end
	w.walkover=function()
	  -- BigData:Auto_catchData()
	   self:step2()
	end
	w:go(211)
end

function jiuyuan:back(roomno)

		--�ص�������
        local w=walk.new()
		  local al
		  al=alias.new()
		  al.guangchang_shanmendian=function()
		     al:knockgatenorth()
		  end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�2")
				  coroutine.resume(jiuyuan.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
			  print("al ����check")
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end
		  w.user_alias=al
         w.Max_Step=0
		 local fail=function()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
        end
         w.walkoff=function()
            self:check_dashi_status(fail)
         end
         w.walkover=function()

		    local f=function()
			     print("û�ҵ�����")
                 self:giveup()
			end
		    self:check_dashi_status(f)
         end
         w:go(roomno)
end



function jiuyuan:reverse(roomno)
   local fail=function()
	  self:back(roomno)
   end

   self:check_dashi_status(fail)
end


function jiuyuan:step2()
	local ts={
	           task_name="���ֻ���",
	           task_stepname="�ڶ���·��",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="ǰ����Զ��",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	self:check()
    self.redo=function()
	    self:step2()
		self.step_back=function()
		   print("���¼������:",w.start_roomno)
		   self:reverse(w.start_roomno)
		end
	end
	self.step_back=function()
	   self:reverse(211)
	end
	self:dashi_follow()
	w.Max_Step=0
	w.user_delay=5
	w.walkoff=function()
	  --1 ȷ����ʦ�Ƿ����
	  if _dashi_follow_ok==true then --follow �ɹ�
	    print("follow �ɹ�")
        local f=function()
	      _dashi_follow_ok=false
		  self:dashi_follow()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
	    end
        f_wait(f,4)
	  else
	    print("follow ʧ��")
		self:step_back()
	  end
	end
	w.walkover=function()
	  -- BigData:Auto_catchData()
	   self:step3()
	end
	w:go(1087)
end

function jiuyuan:step3()
	local ts={
	           task_name="���ֻ���",
	           task_stepname="������·��",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="ǰ���ƺӶɿ�",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	self:check()
    self.redo=function()
	    self:step3()
		self.step_back=function()
		   print("���¼������:",w.start_roomno)
		   self:reverse(w.start_roomno)
		end
	end
	self.step_back=function()
	   self:reverse(1087)
	end
	self:dashi_follow()
	w.Max_Step=0
	w.user_delay=5
	w.walkoff=function()
	  --1 ȷ����ʦ�Ƿ����
	  if _dashi_follow_ok==true then --follow �ɹ�
	    print("follow �ɹ�")
        local f=function()
	      _dashi_follow_ok=false
		  self:dashi_follow()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
	    end
        f_wait(f,4)
	  else
	    print("follow ʧ��")
		self:step_back()
		--self:reverse(1087)
	  end
	end
	w.walkover=function()
	  --  BigData:Auto_catchData()
	    self:step4()
	end
	w:go(1351)
end


function jiuyuan:step4()
	local ts={
	           task_name="���ֻ���",
	           task_stepname="���Ķ�·��",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="ǰ����ɽ",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	self:check()
	self:exps()
    self.redo=function()
	    self:step4()
		self.step_back=function()
		   print("���¼������:",w.start_roomno)
		   self:reverse(w.start_roomno)
		end
	end
	self.step_back=function()
	    self:reverse(1351)
	end
    local al=alias.new()
	al.dujiang=function()
	   al:yellboat()
	end
	al.duhe=function()
	   al:yellboat()
	end
	w.user_alias=al
	self:dashi_follow()
	w.Max_Step=0
	w.user_delay=5
	w.walkoff=function()
	  --1 ȷ����ʦ�Ƿ����
	  if _dashi_follow_ok==true then --follow �ɹ�
	    print("follow �ɹ�")
        local f=function()
	      _dashi_follow_ok=false
		  self:dashi_follow()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
	    end
        f_wait(f,4)
	  else
	    print("follow ʧ��")
		self:step_back()
	  end
	end
	w.walkover=function()
	   wait.time(5)
	   print("��ʱ��")
	        local b
			 b=busy.new()
			 b.Next=function()
		       self:jobDone()
			 end
			 b:check()
	end
	w:go(1381)
end

function jiuyuan:checkNPC()
	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
   wait.make(function()
      world.Execute("look;set look 1")
	  local player_id=string.upper(string.sub(self.player_id,1,1))..string.lower(string.sub(self.player_id,2,-1))
      local l,w=wait.regexp("^(> |).*\\\("..player_id.."'s dashi\\\)$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:checkNPC()
		return
	  end
	  if string.find(l,"�趨����������look") then
	      --û���ҵ�
		  self:NextPoint()
		  return
	  end
	  if string.find(l,player_id) then
	      world.SetVariable("target_roomno",self.target_roomno)
	      self:follow()
		  return
	  end
	  wait.time(6)
   end)
end

function jiuyuan:follow()
	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
   world.Send("follow "..string.lower(self.player_id).."'s dashi")
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
     world.Send("ask "..string.lower(self.player_id).."'s dashi about ��Ԯ")
	 self:step1()
   end
   b:check()
end

function jiuyuan:jobDone()
end
--��ϲ�㣡��ɹ�������˺�ɽ��Ԯ�����㱻�����ˣ�
--�Ű���ʮһ�㾭��!
--������ʮ�ŵ�Ǳ��!
function jiuyuan:exps()
   wait.make(function()
      local l,w=wait.regexp("^(> |).*˵���������ˣ��������գ����ڵ��˺�ɽ����$",5)
	  if l==nil then
	     self:exps()
	     return
	  end
	  if string.find(l,"���ˣ��������գ����ڵ��˺�ɽ") then
		  local rc=reward.new()
		  rc:get_reward()
		  print("������")
		  wait.time(2)
		  shutdown()
	         local b
			 b=busy.new()
			 b.Next=function()
		       self:jobDone()
			 end
			 b:check()
	     return
	  end

   end)
--�ã�������ɣ���õ���һǧ�İ���ʮ����ʵս�����������ʮ��Ǳ�ܡ�
end

function jiuyuan:NextPoint()
   print("���ָ̻�")
   coroutine.resume(jiuyuan.co)
end

function jiuyuan:find_dashi(location)

 local n,rooms=Where(location)
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	    self:shield()
	   jiuyuan.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  w.noway=function()
		    self:giveup()
		  end
		  local al
		  al=alias.new()
		  al.guangchang_shanmendian=function()
		     al:knockgatenorth()
		  end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�2")
				  coroutine.resume(jiuyuan.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
			  print("al ����check")
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC()
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

function jiuyuan:catch_place()
--���ȴ�ʦ˵������������ʦ������ѩͤ����
 wait.make(function()
      local l,w=wait.regexp("^(> |)���ȴ�ʦ˵������(.*)����(.*)����$|^(> |)���ȴ�ʦ˵����������������û��ʲô������㡣��$|^(> |)���ȴ�ʦ˵���������书����Ҳ̫���ˣ�������ô��������ȥ�ɰ�����$|^(> |)���ȴ�ʦ˵��������ղŲ����Ѿ��ʹ����𣿡�$|^(> |)���ȴ�ʦ˵�������ţ��Ѿ������ڰ����ˣ��㻹��ȥæ����ʲô�ɡ���$",5)
	  if l==nil then
	     self:ask_job()
	     return
	  end
	 if string.find(l,"����������û��ʲô�������") or string.find(l,"���书����Ҳ̫����") or string.find(l,"�Ѿ������ڰ�����") then
		world.AppendToNotepad (WorldName().."_���ֻ�������:",os.date()..": ������ʱû���ʺϵĹ�����\r\n")
	    self.fail(101)
	    return
	 end
	 if string.find(l,"��ղŲ����Ѿ��ʹ�����") then
        world.AppendToNotepad (WorldName().."_���ֻ�������:",os.date()..": ��������\r\n")
		sj.world_init=function()
			print("��������!!")
			Weapon_Check(process.jy)
		end
		local b=busy.new()
		b.Next=function()
			relogin(60)
		end
		b:check()
	   return
	end
	  if string.find(l,"����") then
       -- BigData:Auto_catchData()
		self.dashi_name=Trim(w[2])
		world.SetVariable("dashi_name",self.dashi_name)
	    local place=Trim(w[3])
		world.AppendToNotepad (WorldName().."_���ֻ�������:",os.date()..": �ص�->"..place.."\r\n")
	     print("�ص�:",place)
		 if place=="��¥" then
	       place="��¥�߲�"
	     end
		 if place=="��¥" then
		   place="��¥�߲�"
		 end
	     place="��ɽ����"..place
	     self:find_dashi(place)
	    return
	  end

	  wait.time(5)
 end)
end

function jiuyuan:fail(id)
end

function jiuyuan:ask_job()
  local w=walk.new()
  w.walkover=function()
   wait.make(function()
     world.Send("ask xuanci about job")
	 local l,w=wait.regexp("^(> |)�������ȴ�ʦ�����йء�job������Ϣ��$",5)
	 if l==nil then
	    self:ask_job()
		return
	 end
	 if string.find(l,"�������ȴ�ʦ�����й�") then
	    self:catch_place()
	    return
	 end

	 wait.time(5)
	 end)
  end
  w:go(2553)
end

function jiuyuan:recover()

    world.Send("yun recover")
    world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()
	    if h.qi_percent<100 then --������
		    print("��ͨ����")
            local rc=heal.new()
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
				  self:shield()
				  self:redo()
			   else
	             print("��������")
		         self:recover()
			   end
			end
			x:dazuo()
		else
		     print("״̬����")
			 self:shield()
		     self:redo()
		end
	end
	h:check()
end

function jiuyuan:Status_Check()
	local ts={
	           task_name="���ֻ���",
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
			          self:Status_Check()
			        end
			        rc:qudu(sec,i[1],false)
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
		    print("full")
            self:full()
	end
	cd:start()
end

function jiuyuan:shield()

end

function jiuyuan:full()

	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<80 or h.drink<80 then
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
		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80 then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc.liaoshang_fail=function()
			   print("shaolin ����fail")
			   self:liaoshang_fail()
			end
			rc:liaoshang()

		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    print("full")
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
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
				  self:full()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(2552)
			   end
			end
			x.success=function(h)
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
