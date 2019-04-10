
local function get_tools_trigger()
   world.AddTriggerEx ("get_tools", "^(> |)�⿲������һ(��|��|ֻ)(.*)��$", "wuguan.Job(\"%3\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   world.SetTriggerOption ("get_tools", "group", "wuguan")
   world.EnableTrigger("get_tools",true)
end

local function get_tools()
  local b
  b=busy.new()
  b.interval=0.3
  b.Next=function()
     local w
     w=walk.new()
     w.walkover=function()
	 get_tools_trigger()
	 world.Send("ask wu about tools")
    end
    w:go(17)
  end
  b:check()
end

local function taskok_trigger()
   world.AddTriggerEx ("taskok", "^(> |).*����˵�������ɵĲ������ˣ������.*��ʦ��³��.*����\\(task ok\\)�ˣ���$", "wuguan.TaskOk()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   world.SetTriggerOption ("taskok", "group", "wuguan")
   world.EnableTrigger("taskok",true)
end

local function taskok()
   world.EnableTimer("repeat",false)
   world.EnableTrigger("taskok",false)
   local b
   b=busy.new()
   b.interval=0.1
   b.Next=function()
     local w
	  w=walk.new()
	  w.walkover=function()
	    wuguan.ReturnTool()
		wuguan.Reward()
	    world.Send("northwest")
		world.Send("task ok")
	  end
	  w:go(17)
   end
   b:check()
end

local function reward_trigger()
   world.AddTriggerEx ("reward", "^(> |)�㱻�����ˣ�(.*)�㾭���(.*)��Ǳ�ܡ�$", "wuguan:JobDone()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   world.SetTriggerOption ("reward", "group", "wuguan")
   world.EnableTrigger("reward",true)
end

local function reward()
  --
  reward_trigger()
end

local function do_job_trigger()
  --��ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪���ˡ���
  --һ��ů�����Ե�������ȫ�����������ָֻ���֪������

   world.AddTriggerEx ("idle", "^(> |)��ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪���ˡ���$", "EnableTimer(\"repeat\",false)", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   world.SetTriggerOption ("idle", "group", "wuguan")
   world.EnableTrigger("idle",true)
end

local function do_job(method)
  taskok_trigger()
  world.AddTimer ("repeat", 0, 0, 0.8, "wuguan.Repeat()", timer_flag.Replace , "")
  world.SetTimerOption ("repeat", "send_to", "12")
  world.SetTimerOption ("repeat", "group", "wuguan")
  world.EnableTimer("repeat",true)
  return function()
    world.SetTimerOption ("repeat", "second", "0.5")
    world.Send(method)
  end
end

local function job(tools)
--���� 32 ju ľͷ
--ư 24 jiao ˮ
--�� 26 pi ��
--��ͷ 25  chu ��
--ɨ�� 31 sao ��
--ˮͰ
--�黹 17
  local b=busy.new()
  b.interval=0.3
  b.Next=function()
   local tool_id,method,room
   if tools=="����" then
      tool_id="ju zi"
	  room=32
	  method="ju ľͷ"
   elseif tools=="ư" then
      tool_id="piao"
	  room=24
	 method="jiao ˮ"
   elseif tools=="��" then
      tool_id="chai dao"
	  room=26
	  method="pi ��"
   elseif tools=="��ͷ" then
      tool_id="chu tou"
	  room=25
	  method="chu ��"
   elseif tools=="ɨ��" then
      tool_id="sao zhou"
	  room=31
	  method="sao ��"
   elseif tools=="ˮͰ" then
      tool_id="shui tong"
	  room=30
	  method="tiao ˮ"
   end
   wuguan.ReturnTool=function()
     local cmd
     cmd="give wu "..tool_id
	 world.Send(cmd)
   end
   local w
   w=walk.new()
   w.walkover=function()
     world.Send("wield "..tool_id)
     wuguan.Repeat=wuguan.Do_Job(method)
   end
   w:go(room)
  end
  b:check()
end

local function Go_eat()
  walk:go(20)
end

local function Go_sleep()
  local w
  w=walk.new()
  w.walkover=function()
    world.Send("sleep")
  end
  w:go(34)
end

local function dispose()
  world.EnableGroup("wuguan",false)
  world.DeleteGroup ("wuguan")
end

wuguan={
 new=function()
     local wg={}
	 setmetatable(wg,{__index=wuguan})
	 return wg
 end,
 this=nil, --this ָ�� ָ��ǰʵ��
  status="", --����״̬��
  Get_Tools=get_tools,
  Job=job,
  Do_Job=do_job,
  Repeat=nil,
  ReturnTool=nil,
  Dispose=dispose,
  TaskOk=taskok,
  Reward=reward,
}

local function start_job_trigger()
   --world.AddTriggerEx ("ask_lu", "^(> |)����³�������йء�job������Ϣ��$", "wuguan.Get_Tools()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   --world.SetTriggerOption ("ask_lu", "group", "wuguan")
   --world.EnableTrigger("ask_lu",true)
end
--³��˵�����������ݺ�æ����������Ʒ����ù��ߣ�Ȼ��ȥ������ɡ���
--³��˵�����������ݺ�æ����������Ʒ����ù��ߣ�Ȼ��ȥ��Ǵ�ɨ���ɡ�
function wuguan:ask_lu()
    wait.make(function()
	  local l,w=wait.regexp("^(> |)³��˵�����������ݺ�æ����������Ʒ����ù��ߣ�Ȼ��ȥ.*�ɡ�.*$|^(> |)³��˵�������㲻���Ѿ����˹����𣿻�����ȥ������$|^(> |)³��˵�����������ֵ��������㣬�㻹����ȥ�����ɡ���$|^(> |)�趨����������action = \"ask\"$",5)
	  if l==nil then
	      self:start_job()
	      return
	  end
	  if string.find(l,"��������Ʒ����ù���") or string.find(l,"�㲻���Ѿ����˹���") then
	     self:Get_Tools()
	     return
	  end
	  if string.find(l,"�����ֵ���������") then
	      local b=busy.new()
		  b.Next=function()
	       world.Send("sd")
		   self:answer()
		  end
		  b:check()
	     return
	  end
	  if string.find(l,"�趨����������action") then
	     self:ask_lu()
	     return
	  end
	end)
end

function wuguan:start_job()
  wuguan.this=self
  local w
  w=walk.new()
  w.walkover=function()
    --start_job_trigger()
	world.Send("ask lu about job")
	world.Send("set action ask")
	self:ask_lu()
  end
  w:go(5)
end

function wuguan:learn()
package.loaded["learn"] = nil
   require "learn"
   local newbie_learn_literate
	  newbie_learn_literate=learn.new()
	  newbie_learn_literate:addskill("literate")
	  newbie_learn_literate.masterid="bo"
	  newbie_learn_literate.master_place=10
	  newbie_learn_literate.rest=function()
	      local w
		  w=walk.new()
		  w.walkover=function()
		     local newbie_rest=rest.new()
			 newbie_rest.wake=function(flag)
			    if flag==0 then
				  print("˯��̫Ƶ����!")
				  local ch=hp.new()
	              ch.checkover=function()
                     if ch.pot<100  then
						 process.start()
					 elseif  ch.jingxue<=30 then
						--�ӳ�
						local f
						f=function() ch:check() end
                        f_wait(f,10)
					 else
					    newbie_learn_literate:go()
					 end
	              end
	              ch:check()
				else
    			  newbie_learn_literate:go()
				end
			end
			 newbie_rest:sleep()
		  end
		  --3080
		  local gender=world.GetVariable("gender")
		  if gender=="Ů��" then
		     w:go(3080)
		  else
		      w:go(34)
		  end
	  end
	  newbie_learn_literate.start_failure=function(error_id)
	      --
		  --print("ִ��failure",error_id)
		  if error_id==401 then  --��������
		      --print("rest")
              newbie_learn_literate:rest()
		  else
			  local newbie_learn={}
			  newbie_learn=learn.new()
			  --print(newbie_learn,newbie_learn_literate)
			  --print(table.getn(newbie_learn.skills)," M!")
			  --print(newbie_learn.skills,newbie_learn_literate.skills)
			  print("ѧϰ��ͷ")
			  newbie_learn:addskill("force")
			  newbie_learn:addskill("parry")
			  newbie_learn:addskill("dodge")
			  --newbie_learn:addskill("cuff")
			  newbie_learn:addskill("sword")
			  newbie_learn:addskill("strike")
			  newbie_learn:addskill("hand")




	          newbie_learn.masterid="jiaotou"
	          newbie_learn.master_place=2
			  newbie_learn.rest=function()
	           local w
			   w=walk.new()
		       w.walkover=function()
			   local newbie_rest=rest.new()
				 newbie_rest.wake=function(flag)
				    if flag==0 then
				     print("˯��̫Ƶ����!")
					  local ch=hp.new()
	                  ch.checkover=function()
                      if ch.pot<100 then
						process.start()
					  elseif  ch.jingxue<=30 then
						--�ӳ�
						local f
						f=function() ch:check() end
						f_wait(f,30)
					  else
						newbie_learn:go()
					  end
	                 end
	                 ch:check()
			   	   else
    			     newbie_learn:go()
				   end
			     end
			     newbie_rest:sleep()
		        end
				local gender=world.GetVariable("gender")
		         if gender=="Ů��" then
		           w:go(3080)
		         else
		           w:go(34)
		         end
	          end
			  newbie_learn.start_failure=function(error_id)
			       print("error_id:",error_id)
                   if error_id==2 then  --û���ҵ�ʦ��
				     print("û���ҵ�ʦ��"," �ص�:",newbie_learn.master_place)
				      if newbie_learn.master_place==2 then
					      newbie_learn.master_place=3
					  elseif newbie_learn.master_place==3 then
					      newbie_learn.master_place=4
					  elseif newbie_learn.master_place==4 then
					      newbie_learn.master_place=36
					  elseif newbie_learn.master_place==36 then
						  newbie_learn.master_place=37
					  elseif newbie_learn.master_place==37 then
 					       newbie_learn.master_place=1
					  elseif newbie_learn.master_place==1 then
 					       newbie_learn.master_place=2
					  elseif newbie_learn.master_place==2 then
					      newbie_learn.master_place=1
					  elseif newbie_learn.master_place==1 then
					      newbie_learn.master_place=21
					 elseif newbie_learn.master_place==21 then
					      newbie_learn.master_place=7
					  else
					      newbie_learn.master_place=6
					  end
					  print("û���ҵ�ʦ��"," �¸��ص�:",newbie_learn.master_place)
				      newbie_learn:go()
				   end
				   if error_id==102 then
				      --���¿�ʼ
				      self:status_check()
				   end
				   if error_id==1 or error==201 then  --�������� �� ��Խʦ��
				       local is_ok=newbie_learn:Next()
					   if is_ok==true then  --���к�ѡ��
					       newbie_learn:start()
					   else
					       self:status_check()
					       --newbie_robot:status_check()
					       --newbie_robot:start_job()
					   end
				   end
				   if error_id==401 then
                      newbie_learn:rest()
				   end
			  end
              newbie_learn:go()
		  end
      end
	  newbie_learn_literate:go()
end

function wuguan:JobDone()  --�ص�����
    self:start_job()
--[[

	]]
end

function wuguan:status_check()

	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
		if h.exps>=2930 then
		   --world.Send("quit")
           return
		end
	    if h.food<50 or h.drink<50 then
           print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get cha;drink cha;drink cha;drink cha;drop cha;get fan;eat fan;eat fan;drop fan")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:start_job()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(20) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:start_job()
			end
			b:check()
		end
	end
	h:check()
end

function wuguan:step1()
  local w=walk.new()
  w.walkover=function()
     world.Execute("s;s;ask sun about ѧϰ")
	   local b=busy.new()
	  b.Next=function()
	     self:step2()
	  end
	  b:check()

  end
  w:go(1)
end

function wuguan:step2()
  local w=walk.new()
  w.walkover=function()
     local f=function()
	   print("�ڶ���")
     world.Execute("nu;ed;n;ask zhou about ѧϰ")
	   local b=busy.new()
	  b.Next=function()
	     self:step3()
	  end
	  b:check()
	 end
	 f_wait(f,6)
  end
  w:go(1)
end

function wuguan:step3()
  local w=walk.new()
  w.walkover=function()
    local f=function()
	   print("������")
     world.Execute("e;s;ask shen about ѧϰ")
	   local b=busy.new()
	  b.Next=function()
	     self:step4()
	  end
	  b:check()
	 end
	 f_wait(f,6)
  end
  w:go(1)
end

function wuguan:step4()
  local w=walk.new()
  w.walkover=function()
    local f=function()
	   print("���Ĳ�")
    world.Execute("nu;enter;n;e;e;ask qi about ѧϰ")

	  local b=busy.new()
	  b.Next=function()
	     self:step5()
	  end
	  b:check()
	 end
	 f_wait(f,6)
  end
  w:go(1)
end

function wuguan:step5()
--��ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪���ˡ���
--һ��ů�����Ե�������ȫ�����������ָֻ���֪������
  world.Send("ask qi about ����")
   local f=function()
   local w=walk.new()
   w.walkover=function()
     world.Send("ask huoji about ����")
	  local b=busy.new()
	  b.Next=function()
	     self:step6()
	  end
	  b:check()
   end
   w:go(95)
   end
   f_wait(f,8)
end

function wuguan:step6()
  local w=walk.new()
   w.walkover=function()
      world.Send("enter")
	  self:learn()
   end
   w:go(155)
end
--[[
> ������������������ͷ��
����˵��������λС�ֵܣ��ҳ��������⿼���㣬�������˿��н�Ŷ����

���ȷ�ϻش����⣬������ answer y ����Ը��ش�Ļ������Լ���ȥ³��ʦ
��������������������� answer n ��

����˵�����������ǵ�һ�⣬һ�����ĸ�ѡ����� answer ��ĸ �ش𡣡�
���ʣ�����Ϸ�н��������ҵ������ǣ�
A��irc /join                      B��irc /create
C��irc /setroom                   D��irc /invite


���ʣ������������Խ���ĺ��ѡ�friend��������ĺ����б��У�
A��finger -d friend               B��finger friend
C��finger -a friend
>

���ʣ��������������ڻָ��������ָ���(yun regenerate)����(yun recover)��
����(yun refresh)�����֣�
A����                             B����   ]]

local quest=""
local answer_a=""
local answer_b=""
local answer_c=""
local answer_d=""

function wuguan:catch_choose_line2()
   wait.make(function()
      local l,w=wait.regexp("^(> |)C��(.*)D��(.*)$|^(> |)C��(.*)$")
      if string.find(l,"D") then
	     answer_d=Trim(w[3])
		 answer_c=Trim(w[2])
	     return
	  end
	  if string.find(l,"C") then
	     answer_c=Trim(w[5])
	     return
	  end
   end)
end

function wuguan:catch_choose_line1()
   wait.make(function()
      local l,w=wait.regexp("^(> |)A��(.*)B��(.*)$")
       if string.find(l,"B") then
	     answer_a=Trim(w[2])
		 answer_b=Trim(w[3])
	     return
	  end

   end)
end

function wuguan:out_wuguan()
   local b=busy.new()
   b.Next=function()
    world.SetVariable("up","cun_pot")
	world.Send("unset ����")
	world.Send("jifa all")
    world.Send("say �������")
	world.Send("south")
	world.AddTimer("dazuo", 0, 0, 2, "dazuo 10", timer_flag.Enabled+timer_flag.Temporary + timer_flag.Replace+timer_flag.ActiveWhenClosed, "")

    --process.xc()
   end
   b:check()
end

function wuguan:catch_quest()
   wait.make(function()
      local l,w=wait.regexp("^(> |)���ʣ�(.*)$|^(> |)����˵�����������ȥ����ʦ������ɽѯ����ݵ������� ask wan about ��� ����$|(> |)���ȷ�ϻش����⣬������ answer y ����Ը��ش�Ļ������Լ���ȥ³��ʦ$",5)
	  if l==nil then
	     self:catch_quest()
		 return
	  end
	  if string.find(l,"���ȷ�ϻش�����") then
	     world.Send("answer y")
		 self:catch_quest()
		 return
	  end
	  if string.find(l,"����") then
	      quest=Trim(w[2])
		  wait.time(1) --�ӳ�1s
		  self:auto_answer(quest,answer_a,answer_b,answer_c,answer_d)
	     return
	  end
      if string.find(l,"�����ȥ����ʦ������ɽѯ����ݵ�������") then
	     wait.time(1)
		 --world.Execute("s;s;ask sun about ���;credit vip")
		 local b=busy.new()
		 b.Next=function()
		    --world.Send("out")
			--world.Send("ask wei about ��")
			--self:out_wuguan()
			print("ȥѧ ���վ�")
			self:shenzhaojing()
		 end
		 b:check()
	     return
	  end
   end)
end

function wuguan:answer_test(answer)
   world.Send("answer "..answer)
   self:catch_quest()
   self:catch_choose_line1()
   self:catch_choose_line2()
end

function wuguan:answer()

   self:catch_quest()
   self:catch_choose_line1()
   self:catch_choose_line2()

end


-- Modify By River@SJ 2003.8.26

--���ֽڲ��ô��� 30 �������� 15 ����
-- �𰸸��������� 6 ��������ȷ�����ڣ���
-- ȫ��Ϊѡ���⣬��������Ҫ 2 ����
--/wuguan:auto_answer("�������������ڻָ��������ָ���(yun regenerate)����(yun recover)��","��","��","1","1")
local question_list = {}


local q={}

q={}
q.question="����ϵͳ�а��������ý�ɢ(gdismiss)��������ɢ���ɣ�Ҳ����ʹ����\\n�ðѰ���λ�ô��������з�����������ң�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="���졢���ϡ�����ѪԵ�Ͻ��ǽ��ã�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�������澭���͡������澭��������ͬһ���ˣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="��а����Դ�ԡ��������䡻��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="С�����彣�����丸Ψһ�ĺ��ӣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="ALIAS��ָMUD��ı������ü򵥵ļ�����ĸ�����Ϊ���ӵ�һЩָ�\\n�Ӷ�ʹ����Ѹ�٣�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="���������ԡ����ǡ�����������������츳��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�����и�Ե�����ӡ���ò���������������츳��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�����������Ը��������ʧ���е�Ǯ�ƣ����ּ��ܽ��뼶�������\\n�� 0.5\% ��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����һ���˵�������С�ı�׼��Ҳ��Ϊ���ֵ����Чֵ�͵�ǰֵ��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����һ���˵ľ���״���ı�׼����Ϊ���ֵ����Чֵ�͵�ǰֵ�����ֵ��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="��ҿ���ͨ����������ڹ��ĵȼ�����ߺ�����ǣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="��ҿ���ͨ����߻����ڹ��ĵȼ�����ߺ�����ǣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="��ҿ���ͨ����߶���д�ֵĵȼ�����ߺ������ԣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="��ҿ���ͨ����߻����Ṧ�ĵȼ�����ߺ�������"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="��ҿ���ͨ����������Ṧ�ĵȼ�����ߺ�������"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�����������Ǻ���һ��������ֱ����а��ı�ߣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�����������������������κ�һ��С�����ʱ���˶�����ԣ��ڻ���ʱ\\n���ܵ�������������"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="���һ����Ϸ�ߵ���߹������ܼ������������������ѧ���ܣ��ҹ�\\n�����ܴ���һ�ټ��������Ϸ�߽�����Ϊ�ǹ�����"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="������ӵ�е�������ѧ���ܶ����ܳ������ټ���"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�����������İټ�Ϊ���ޣ������ܾ������ƣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����������ͼɱ��һ���������Ҵ˹�������ͨ�������˹���������ʱ\\n��غ���Ѳ����yell guard������Ѱ��Ѳ���ı�����"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="������Ǯׯ�п��Ա���ʿ������Ǯ������Զ���ȡǮ�������ѱ���ʿ\\nҪ�ߣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="������� 5,000,000 ����Ҿ��ܽ����Լ��İ��ɣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����ϵͳ�а��ɵ�����������Լ��İ���������ȼ����Լ��͵İ��ɳ�\\nԱִ��ĳЩ����������Ϊ gforce"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����ϵͳ��ÿ�����ɶ����Լ���ʵ��ֵ������ֵ��ʵ��ֵ�ɰ��ɵĳ�Ա\n��ʵ���ܺͶ��ã�����ֵ���������ɰ��ɼ������ý��������"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="������ϵͳ�У��� say  ����˵�����Ļ���ֻ�ܱ�ͬһ�������ڵ����\\n������"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����ڶ�ʱ���ڷ�������Ϣ������Ƶ������ң����ᱻϵͳǿ�ƹر���\\n������Ƶ����"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="������֪�������������Ųλ��ӡ�÷���������������֪����òС�� 15 ��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="������֪����������������ǰ��һ���������£�һ���󸻴�������\\n�ࡣ����֪�丣ԵС�� 20 ��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����(jiali) �Ķ���ֱ��Ӱ�칥��������Ӧע������Ĵ�С����������\\n��ɱ������ͬʱ���Ĵ���������"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����ʱ��ÿһ�ζ��鶼Ҫ����һЩ��Ѫ�����Ըߵ������ĵľ�Ѫ���٣�\\n���Ե͵������ĵľ�Ѫ�϶ࣿ"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����ʮ��ǰ�������ֵ��������������ʮ������������٣���ʮ���\\n���ٱ仯��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�������������ڻָ��������ָ���(yun regenerate)����(yun recover)��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="Ǳ�ܵ��������ܾ������Ƶ��书�����йأ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�书����Ч�ȼ����ڻ����书�������书֮�ͣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="���������й����Է�����Ʒ�򷿼�ʱ��ͬһ��������к͹�����ͬһ��\\n�ɻ�ͬһ���˵���ҵĹ������ͷ���������һ�����½���"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="�ڰ��������ڼ䣬����˫��������Խ��˰��ɵĳ�Ա������˫���İ���\\n�������ɱû��BUSY����ɱ���Է���ᱻͨ����"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)

q={}
q.question="����ϵͳ�а��ɳ�Ա��Ϊ�������������������������ĸ��ȼ���"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)
q={}
q.question="��������ȥ���ݶ��Ÿ����������ھֹ�Ӷ�����������Լ���һ��������\\n�ܹ�Ӷ�ı�����ߵȼ�ȡ���ڸù�����ս������ĸߵͣ�"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)
q={}
q.question="���κεط������Զ�ͨ������ɱ(kill)������û��æµ״̬��"
q.answer="��"
q.choose={"��"}
table.insert(question_list,q)
q={}
q.question="��ϰ����һ�εõ��ĵ���Լ���ڸ�������书�ļ���ģ�"
q.answer="1/5"
q.choose={ "1/2", "1/3", "1/4" }
table.insert(question_list,q)
q={}
q.question="����һ�εõ��ĵ���ȡ���ڣ�"
q.answer="����д��"
q.choose={ "��������", "��������", "��" }
table.insert(question_list,q)
q={}
q.question="������Ҫ������ĵ�ǰֵ����������ģ�"
q.answer="70\%"
q.choose=	{ "50\%", "60\%", "80\%" }
table.insert(question_list,q)
q={}
q.question="������Ҫ��ľ��ĵ�ǰֵ������󾫵ģ�"
q.answer="80\%"
q.choose=	{ "50\%", "60\%", "70\%" }
table.insert(question_list,q)
q={}
q.question="�á�һέ�ɽ����ɹ���ˮ,��Ҫ�Ṧ��Ч�ȼ����ڵ��ڣ�"
q.answer="80"
q.choose=	{ "60", "100", "120" }
table.insert(question_list,q)
q={}
q.question="����ɻƺ���Ҫ�Ṧ��Ч�ȼ����ڵ��ڣ�"
q.answer="250"
q.choose=	{ "200", "300", "350" }
table.insert(question_list,q)
q={}
q.question="����ɳ�����Ҫ����������ڵ��ڣ�"
q.answer="3500"
q.choose=	{ "2000", "2500", "3000" }
table.insert(question_list,q)
q={}
q.question="�¼������У�Ը����������ڸ����˵��ǣ�"
q.answer="�·�ɽ"
q.choose=	{ "�·���", "�·���", "�·���", "�·�ʩ"}
table.insert(question_list,q)
q={}
q.question="������Ϊ�У����ᱻͨ�����ǣ�"
q.answer="ɱ�ٱ�"
q.choose=	{ "ɱ�����", "ɱʷ��ɽ", "ɱ������" }
table.insert(question_list,q)
q={}
q.question="������һ���������ʥ������Ĵºţ�"
q.answer="��ʥ"
q.choose=	{ "��ʥ", "��ʥ", "��ʥ" }
table.insert(question_list,q)
q={}
q.question="�������вص��ǣ�"
q.answer="��������"
q.choose=	{ "�����澭", "�����澭", "��������" }
table.insert(question_list,q)
q={}
q.question="�����ĸ����ǿ���лѷ��������ɮ��"
q.answer="�ռ�"
q.choose=	{ "�ɶ�", "�ɽ�", "����" }
table.insert(question_list,q)
q={}
q.question="��������ԼĪʮ��������ͣ�ͷ�������һ�����������ʯñ��.....\\n¶�����ž���������ѩ��ϸ��...������ڣ������鶯��˵���ǣ�"
q.answer="����"
q.choose=	{ "ΤС��", "ľ����", "���" }
table.insert(question_list,q)
q={}
q.question="������Щ�˲�����ָ���ǣ�"
q.answer="��־��"
q.choose={ "��־ƽ", "��ң", "֣��ˬ" }
table.insert(question_list,q)
q={}
q.question="�ָ���Ѫ��ָ���ǣ�"
q.answer="yun jing"
q.choose=	{ "yun jingli", "yun qi", "yun heal" }
table.insert(question_list,q)
q={}
q.question="�ָ�������ָ���ǣ�"
q.answer="yun jingli"
q.choose={ "yun jing", "yun qi", "yun heal" }
table.insert(question_list,q)
q={}
q.question="�ָ���Ѫ��ָ���ǣ�"
q.answer="yun qi"
q.choose={ "yun jing", "yun jingli", "dazuo" }
table.insert(question_list,q)
q={}
q.question="ʹ�������ӵ����;���ǣ�"
q.answer="dazuo"
q.choose={ "yun jing", "yun jingli", "yun qi" }
table.insert(question_list,q)
q={}
q.question="ѧϰ���ܽ������ĵ��ǣ�"
q.answer="��Ѫ"
q.choose={ "����", "����", "��Ѫ" }
table.insert(question_list,q)
q={}
q.question="�ںӱ߻��߽��߽д���ָ���ǣ�"
q.answer="yell boat"
q.choose={ "look boat", "yell", "find boat" }
table.insert(question_list,q)
q={}
q.question="��������Ƶ�������Ǵ���ģ�"
q.answer="party ����Ƶ��"
q.choose={ "chat ����Ƶ��", "rumor ҥ��Ƶ��", "tell ˽��Ƶ��" }
table.insert(question_list,q)
q={}
q.question="����㵽��һ��������Ʒ��NPC��ǰ������ƷĿ¼��ָ���ǣ�"
q.answer="list"
q.choose={ "look", "place", "help" }
table.insert(question_list,q)
q={}
q.question="���������Ϸ�������ĳ����һ���NPCһ���ж�,��Ӧ����ָ�"
q.answer="follow"
q.choose=	{ "gen", "follow none", "lead" }
table.insert(question_list,q)
q={}
q.question="�������������ĳ����һ�NPC��ָ���Ӧ���룺"
q.answer="follow none"
q.choose={ "follow", "no follow", "follow me" }
table.insert(question_list,q)
q={}
q.question="����Ϸ�У��鿴�Լ��к��书��ָ���ǣ�"
q.answer="skills(cha)"
q.choose={ "score", "inventory(i)", "hp" }
table.insert(question_list,q)
q={}
q.question="����Ϸ�У��鿴�Լ������к���Ʒ��ָ���ǣ�"
q.answer="inventory(i)"
q.choose={ "look", "skills", "hp" }
table.insert(question_list,q)
q={}
q.question="�뿪��Ϸ����ȷָ���ǣ�"
q.answer="quit"
q.choose={ "����", "�ر�zMUD����", "�ػ�" }
table.insert(question_list,q)
q={}
q.question="���治����˽�������ָ���ǣ�"
q.answer="rumor"
q.choose={ "tell", "reply", "whisper" }
table.insert(question_list,q)
q={}
q.question="���ܸ���Ӱ����ǣ�"
q.answer="�����Ĵ�С"
q.choose=	{ "���Ļָ��ٶ�", "�ܹ���ʱ���ܵ��˺�", "ÿ�꾫����������" }
table.insert(question_list,q)
q={}
q.question="��Ӱ��������С���ǣ�"
q.answer="�����м�"
q.choose={ "����ȭ��", "����ָ��", "�����ȷ�" }
table.insert(question_list,q)
q={}
q.question="������������������������ǣ�"
q.answer="����ʱ��"
q.choose={ "�����ĵȼ�", "���������ԭ����", "�����ߵĶ��켼��" }
table.insert(question_list,q)
q={}
q.question="������ҩʦӦ��ӵ�еļ����ǣ�"
q.answer="��ֲ��"
q.choose={ "��ҩ��", "������", "������" }
table.insert(question_list,q)
q={}
q.question="����������ʦӦ��ӵ�еļ����ǣ�"
q.answer="������"
q.choose={ "�ɿ���", "������", "������" }
table.insert(question_list,q)
q={}
q.question="������֯��ʦӦ��ӵ�еļ����ǣ�"
q.answer="�޲���"
q.choose={ "�ɼ���", "��֯��", "�ü���" }
table.insert(question_list,q)
q={}
q.question="������Ҫ�˽�ĳһ���򣨱�������ĵ�ͼ��ʱ��ָ���ǣ�"
q.answer="help map dali"
q.choose={ "help", "help map here", "look dali" }
table.insert(question_list,q)
q={}
q.question="������Ҫ�˽�ĳһ���ɣ��������̣���˵��ʱ��ָ���ǣ�"
q.answer="help party mingjiao"
q.choose={ "help", "help party", "party help" }
table.insert(question_list,q)
q={}
q.question="�ڰ���ϵͳ��,���Ҫ��һ�����ɿ�ս����ô��ս��ָ���ǣ�"
q.answer="declare"
q.choose={ "delate", "grant", "destory" }
table.insert(question_list,q)
q={}
q.question="�ڰ���ϵͳ�У����˵�ָ���ǣ�"
q.answer="ally"
q.choose={ "attack", "gwar", "abdicate" }
table.insert(question_list,q)
q={}
q.question="���Ҫ�����Լ����������Ʒ�򷿼䣬ʹ�õ������ǣ�"
q.answer="destory"
q.choose={ "attack", "gwar", "build" }
table.insert(question_list,q)
q={}
q.question="�����������Խ���ĺ��ѡ�friend��������ĺ����б��У�"
q.answer="finger -a friend"
q.choose={ "finger friend", "finger -d friend" }
table.insert(question_list,q)
q={}
q.question="������θ��Լ���һ����nickname������ţ�"
q.answer="nick nickname"
q.choose={ "nick none", "nick add nickname"}
table.insert(question_list,q)
q={}
q.question="Ϊ�˽�ɫ��ȫ��Ҫʱ���޸ĵ�½���룬����ͨ��ʲôָ���޸ģ�"
q.answer="passwd"
q.choose={ "password", "passwd -c", "passwd -send" }
table.insert(question_list,q)
q={}
q.question="������β鿴��ɫ�ı�������ʱ�䣿"
q.answer="time"
q.choose={ "uptime", "onlinetime"}
table.insert(question_list,q)
q={}
q.question="��ҡ�char���ڹ���Ƶ���з������ʵ����ۣ���ϣ������һ��ͶƱ�ر�\n����Ƶ������ν��У�"
q.answer="vote chblk char"
q.choose={ "vote unchblk char", "chblk char", "unchblk char"}
table.insert(question_list,q)
q={}
q.question="��ϣ�����Լ��Ľ�ɫ������һЩ���Ե�����˵������ͨ���ĸ�ָ����ӣ�"
q.answer="describe"
q.choose={ "nick", "color", "score" }
table.insert(question_list,q)
q={}
q.question="��ΰ���������(xuantie-jianfa)ָ��Ϊ��ʹ�õĻ����������ࣿ"
q.answer="jifa sword xuantie-jianfa"
q.choose={ "jifa xuantie-jianfa", "bei xuantie-jianfa", "bei sword xuantie-jianfa" }
table.insert(question_list,q)
q={}
q.question="��β鿴�齣��Ԥ����鶯���б�"
q.answer="semote"
q.choose={ "emote", "help emote" }
table.insert(question_list,q)
q={}
q.question="����㲻ϣ����������Ƶ����˵����ͨ��ʲôָ��رգ�"
q.answer="tune chat"
q.choose={ "tune party", "tune rumor", "tune sj" }
table.insert(question_list,q)
q={}
q.question="ʹ��ʲôָ����������ս���а�ȫ���������"
q.answer="halt"
q.choose={ "go", "leave" }
table.insert(question_list,q)
q={}
q.question="ʹ��ʲôָ�����������Ϸ�е������˿϶����Կ�������˵�Ļ���"
q.answer="shout"
q.choose={ "chat", "rumor", "sj" }
table.insert(question_list,q)
q={}
q.question="ʹ��ʲôָ����Խ�ɢһ�����Ѿ������Ķ��飿"
q.answer="team dismiss"
q.choose={ "team with", "team", "team talk" }
table.insert(question_list,q)
q={}
q.question="����㲻������ҡ�char��˽�ģ�Ӧ����ν��У�"
q.answer="set block char"
q.choose={ "set tell char", "finger -a char", "finger -d char" }
table.insert(question_list,q)
q={}
q.question="�������лƽ�gold���������������Ӧ�����ָ����"
q.answer="get gold"
q.choose={ "drop gold", "give gold", "steal gold" }
table.insert(question_list,q)
q={}
q.question="�������װ������sword������Ӧ���룿"
q.answer="wield sword"
q.choose={ "unwield sword", "wear sword", "remove sword" }
table.insert(question_list,q)
q={}
q.question="���������ҡ�char������͵ȡ�ƽ�gold��ʱ����ȷ��ָ���ǣ�"
q.answer="steal gold from char"
q.choose={ "give char gold", "give gold to char", "get gold from char" }
table.insert(question_list,q)
q={}
q.question="����������ϵ��·���cloth������ʱ��Ӧ�������ָ���ǣ�"
q.answer="wear cloth"
q.choose={ "remove cloth", "wield cloth", "unwield cloth" }
table.insert(question_list,q)
q={}
q.question="�������ѵ����ϵ��·�(cloth)ʱ��Ӧ�������ָ���ǣ�"
q.answer="remove cloth"
q.choose={ "wear cloth", "wield cloth", "unwield cloth" }
table.insert(question_list,q)
q={}
q.question="����������ϵ��·���cloth��������ʱ��Ӧ�����ָ���ǣ�"
q.answer="drop cloth"
q.choose={ "get cloth", "give cloth", "put cloth" }
table.insert(question_list,q)
q={}
q.question="����������еĽ���sword������ʱ��Ӧ�������ָ���ǣ�"
q.answer="unwield sword"
q.choose={ "wield sword", "wear sword", "remove sword" }
table.insert(question_list,q)
q={}
q.question="���������Լ����˵�ָ���ǣ�"
q.answer="yun heal"
q.choose={ "yun jingli", "yun qi", "yun jing" }
table.insert(question_list,q)
q={}
q.question="����������ҡ�char�����ˣ�Ӧ�������ָ���ǣ�"
q.answer="yun lifeheal char"
q.choose={ "yun heal char", "yun lifesave char", "yun qi char" }
table.insert(question_list,q)
q={}
q.question="���������С��Ů�������ץ��ȸ���ַ���ʲô��"
q.answer="tianluo-diwang"
q.choose={ "yunu-shenfa", "yunu-xinjing", "yinsuo-jinling" }
table.insert(question_list,q)
q={}
q.question="¹������ΤС��ʹ�õ��Ṧ��ʲô��"
q.answer="shenxing-baibian"
q.choose={ "hansha-sheying", "lingbo-weibu", "tianlong-xiang" }
table.insert(question_list,q)
q={}
q.question="Ц�������з��������������Ľ�����ʲô��"
q.answer="dugu-jiujian"
q.choose={ "huashan-jianfa", "taiji-jian", "xuantie-jianfa" }
table.insert(question_list,q)
q={}
q.question="���Ӣ�۴���÷���紫�����צ����ʲô��"
q.answer="jiuyin-baiguzhua"
q.choose={ "jiuyin-shenzhua", "ningxue-shenzhua", "youming-shenzhua" }
table.insert(question_list,q)
q={}
q.question="��������ݣ���Ҫ������huasheng����ָ���ǣ�"
q.answer="buy huasheng"
q.choose={ "sell huasheng", "get huasheng", "qu huasheng" }
table.insert(question_list,q)
q={}
q.question="�Լ��������ɵ������ǣ�"
q.answer="gcreate"
q.choose={ "glist", "build", "grant" }
table.insert(question_list,q)
q={}
q.question="������벼������wuxing-zhen��,��ʹ�õ������ǣ�"
q.answer="lineup form wuxing-zhen"
q.choose={ "lineup", "lineup wuxing-zhen", "lineup with wuxing-zhen" }
table.insert(question_list,q)
q={}
q.question="����Ϸ�н��������ҵ������ǣ�"
q.answer="irc /create"
q.choose={ "irc /join", "irc /setroom", "irc /invite" }
table.insert(question_list,q)
q={}
q.question="����������ҡ�char����ӣ�Ӧ��ʹ�õ������ǣ�"
q.answer="team with char"
q.choose={ "team dismiss", "team talk", "team kill" }
table.insert(question_list,q)
q={}
q.question="ѧϰһ�εõ��ĵ���Լ���ں������Եģ�"
q.answer="1/2"
q.choose={"1/3", "1/4", "1/5"}
table.insert(question_list,q)
q={}
q.question="����һ�εõ��ĵ���Լ���ڶ���д�ּ���ģ�"
q.answer="1/5"
q.choose={"1/2", "1/3", "1/4"}
table.insert(question_list,q)
q={}
q.question="�������Ѫ���޲��� 100% ʱ������ԭ���Ǵ���ģ�"
q.answer="ʳ��Ե�̫��"
q.choose={ "�����Ѫ���Ӻ��ٴ����߽�����Ϸ", "ս������", "�ж�" }
table.insert(question_list,q)

q={}
q.question="�ּۻ���(trade) �������������۵�ˮƽ������Խ�����������еĿ���\\nԽ�٣�"
q.answer="��"
q.choose={ "��" }
table.insert(question_list,q)

q={}
q.question="�������Ѫ���޲��� 100% ʱ������ԭ���Ǵ���ģ�"
q.answer="ʳ��Ե�̫��"
q.choose={ "ʳ��Ե�̫��","�����Ѫ���Ӻ��ٴ����߽�����Ϸ","ս������","�ж�" }
table.insert(question_list,q)
--���ʣ���������趨���Լ���Ѫ���� 30% ��ʱ���Զ�����ս����
q={}
q.question="��������趨���Լ���Ѫ���� 30% ��ʱ���Զ�����ս����"
q.answer="set wimpy 30"
q.choose={ "set wimpy 30","set brief 30","set no_accept 30","set block 30" }
table.insert(question_list,q)

q={}
q.question="������ΰ���������(xuantie-jianfa)ָ��Ϊ��ʹ�õĻ����������ࣿ"
q.answer="jifa sword xuantie-jianfa"
q.choose={ "bei xuantie-jianfa","jifa xuantie-jianfa","jifa sword xuantie-jianfa","bei sword xuantie-jianfa" }
table.insert(question_list,q)
--���ʣ�����ϵͳ�а��������ý�ɢ(gdismiss)��������ɢ���ɣ�Ҳ����ʹ����
--�ðѰ���λ�ô��������з�����������ң�
--A����                             B����

--���ʣ����κεط������Զ�ͨ������ɱ(kill)������û��æµ״̬��
function test_answer()
  local q="����ϵͳ�а��������ý�ɢ(gdismiss)��������ɢ���ɣ�Ҳ����ʹ����"
  wuguan:auto_answer(q,"��","��","","")
end
--/wuguan:auto_answer("���ʣ���������趨���Լ���Ѫ���� 30% ��ʱ���Զ�����ս����","set wimpy 30","set brief 30","set no_accept 30","set block 30")
function wuguan:auto_answer(_quest,_a,_b,_c,_d)
  --print("����:",_quest)
	local s,e=string.find(_quest,"%%")
	if s~=nil then
      _quest=string.sub(_quest,1,s-1).."%%"..string.sub(_quest,e+1,string.len(_quest))
   end

   local s,e=string.find(_quest,"-")
	if s~=nil then
      _quest=string.sub(_quest,1,s-1).."%-"..string.sub(_quest,e+1,string.len(_quest))
   end

   local s,e=string.find(_quest,"%(")
   if s~=nil then
      _quest=string.sub(_quest,1,s-1).."%("..string.sub(_quest,e+1,string.len(_quest))
	  s,e=string.find(_quest,"%(",e+2)
      if s~=nil then
        _quest=string.sub(_quest,1,s-1).."%("..string.sub(_quest,e+1,string.len(_quest))
	    --s,e=string.find(_quest,"%(",e)
      end
   end

   local s,e=string.find(_quest,"%)")
   if s~=nil then
      _quest=string.sub(_quest,1,s-1).."%)"..string.sub(_quest,e+1,string.len(_quest))
	   s,e=string.find(_quest,"%)",e+2)
      if s~=nil then
        _quest=string.sub(_quest,1,s-1).."%)"..string.sub(_quest,e+1,string.len(_quest))
      end
   end

  print("����:",_quest)
  print("a:",_a,"b:",_b,"c:",_c,"d:",_d)
  for _,q in ipairs(question_list) do
      --print("wenti: ",q.question)
	  --print("result:",_quest)
       if string.find(q.question,_quest) then
	       print("�ҵ�����")
	       local choose=""
	      if Trim(q.answer)==_a then
		    choose="answer a"
		  elseif q.answer==_b then
		    choose="answer b"
		  elseif q.answer==_c then
		    choose="answer c"
		  elseif q.answer==_d then
		    choose="answer d"
		  else
		     choose="answer e"
		  end
		 world.Send(choose)
		 self:answer()
         return

	   end

  end
   print("û���ҵ�ƥ�����⣡���� �ֶ�����!!")
end

function wuguan:leave()
  local b=busy.new()
  b.Next=function()
    world.Execute("n;w;w;w;w;w;wu;sd;s;s")
   local w=walk.new()
   w.walkover=function()
      world.Execute("ask sun about ���;credit vip")
	  local b=busy.new()
	  b.Next=function()
        world.Send("out")
	    world.Send("ask wei about ��")
        self:out_wuguan()
	  end
	  b:check()
	end
	w:go(21)
  end
  b:check()
end

function wuguan:moveshi()
	local h=hp.new()
	h.checkover=function()
	     if h.jingxue>=90 then
		     world.Send("move shi")

			 local b=busy.new()
		    b.Next=function()
		      world.Send("enter")
	          world.Send("l wall")
	          world.Send("l fuhao")
	          world.Execute("#5 lingwu fuhao")
		      world.Send("jifa all")
		      local f2=function()
		         world.Send("out")
			     world.Execute("out;zuan feng")
                 local f=function()
			       self:leave()
				 end
				 f_wait(f,4)
		      end
		     f_wait(f2,5)
	        end
	        b:check()
		 else
		   local f=function()
		    self:moveshi()
		   end
		   f_wait(f,3)
		 end

	  end
	  h:check()
end

--���ѧ���վ�
function wuguan:shenzhaojing()
   local w=walk.new()
   w.walkover=function()
      world.Send("zuan feng")
	  self:moveshi()

   end
   w:go(44)
end
--[[
>
����: ������ΰ���������(xuantie-jianfa)ָ��Ϊ��ʹ�õĻ����������ࣿ
a: bei xuantie-jianfa b: jifa xuantie-jianfa c: jifa sword xuantie-jianfa d: bei sword xuantie-jianfa]]
