 --[[��Ľ�ݸ�ask fu about ��ѧ(ע�⣺Ҫ�����ʱ���Ա߲�������
 �����˵Ļ���Ľ�ݸ���˵������������ʲô�ġ�������ʬ��Ҳ������
 ����ʬ��Ҫ�Ȱ���У��������ˣ�fu������������ѧʲô������
 ʱ����һ��dizi�����������ߣ�����������������书��NPC�������
 fight��һ��fightһ�ߴ�touxue ĳ�� ���� һֱ�����dizi˵������
 �ˣ���Ϳ��Ի������뽻���ˡ�
 Ľ�ݸ�����Ķ�������˵�����ҹ���Ľ�ݰ������������书����Ҳ����Ϊ֮��Ľ�ġ�
Ľ�ݸ�����Ķ�������˵�����ðɣ����򹷰�������dagou-bang���Ҵ����Ѿã����ǰ���ѧ�������Ҵ������͡�
Ľ�ݸ�˵�����������������Ǻã����Ǻá���]]

--1345
--ɢ���� ���ȴ�ʦ
local touxue_skills_target={
{"�򹷰���","ʷ��ɽ",{126}},
{"�򹷰���","�γ���",{998}},
{"����������","������",{998}},
{"�������ϵ�","��������",{2287}},
{"ɢ����","Ԫ������",{1899}},
{"ȼľ����","Ԫŭ����",{1907}},
{"������","����",{870}},
{"������","�ι�",{872}},
{"����ȭ","��֪",{871}},
{"��Ħ��","����",{804}},
{"��ħ��","�κ�",{867}},
{"����צ","��ʶ",{805}},
{"��צ��","�ξ�",{868}},
{"�޺�ȭ","����",{807}},
{"Ħڭָ","�μ�",{860}},
{"Τ�Թ�","�μ�",{865}},
{"Τ����","��˼",{806}},
{"Τ����","�����ʦ",{1904}},
{"�ն��ȷ�","����",{803}},
{"����ǧҶ��","����",{808}},
{"���ֵ���","����",{802}},
{"�������","���Ѵ�ʦ",{796}},
{"��Ӱ������","������ʦ",{839}},
{"�޳��ȷ�","����",{866}},
{"�ȱ���","����",{864}},
{"���޵�","����",{801}},
{"һָ��","��־",{800}},
{"ӥצ��","���ֱ���",{2552}},
{"�黨ָ","��ü����",{492}},
{"������","�嶾��Ů����",{366}},
{"����������","����̩",{466}},
{"�μҽ���","����̩",{466}},
{"һ��ָ","����ͨ",{4021}},
{"һ��ָ","������",{481}},
{"�ط������","����ʦ̫",{667}},
{"������","����ʦ̫",{667}},
{"���е���","����ʦ̫",{696}},
{"���浶","�ܵ�",{2246}},
{"ӥצ������","�н���",{2246,2243,2242}},
{"��������","Ů����",{2246,2243,2242}},
{"��ʯ����ȭ","����",{1517}},
{"��ɽ����","����",{1517}},
{"��Ԫ��","����",{1517}},
{"���｣��","½��Ӣ",{2477}},
{"����ɨҶ��","½��Ӣ",{2477}},
{"��Ӣ����","½��Ӣ",{2477}},
{"��ħ�ȷ�","������",{613}},
{"���־�ʽ","��ܽ",{162}},
{"��צ������","������",{1952}},
{"���鵶��","�������",{1947}},
{"�䵱��ȭ","�������",{1947}},
--{"̫������","����Ϫ",{1958}},
{"̫������","������",{1953}},
{"̫��ȭ","����Ϫ",{1958}},
{"��ɽ�ȷ�","��Ȼ��",{1968}},
{"��ɽ�ȷ�","�����ɵ���",{1963,2235}},
{"�¼ҵ���","������",{173}},
{"����ʮ����","Ү����",{190}},
{"�¼�ȭ","������",{173}}}


--�����ȵ���֤��Ժ�˱��µ�������֮������Ǳ��µ��ӣ��������ڡ�
--ǧ������
--������Ѩ��
--��ָ��ͨ
--�����ǵ���
--�ط�޷�
--����ʮ���� Ү���� 190
--���±�
--��Ҫ��˭͵ѧ��
--����ս������ô��͵ѧ�أ�
--[[����Ľ�ݸ������йء�����������Ϣ��
Ľ�ݸ���ϸ�о��������ֽ���ϵ��书��Ҫ���鲻�Խ���˵������һ�����浶��
Ľ�ݸ����������ͷ������˵�����������ˣ���ȥ��Ϣ�ɡ�
�����˶������ߵ㾭�����ʮһ��Ǳ�ܵĽ�����
���Ѿ�ΪĽ����������2������!]]
touxue={
  new=function()
     local tx={}
	 setmetatable(tx,{__index=touxue})
	 return tx
  end,
  skill_id="",
  skill_name="",
  co=nil,
  success=false,
}

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

function touxue:fail(id)
end

function touxue:ask_job()
  local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask murong fu about ��ѧ")
    local l,w=wait.regexp("^(> |)Ľ�ݸ�����Ķ�������˵�����ðɣ���(.*)����(.*)���Ҵ����Ѿã����ǰ���ѧ�������Ҵ������͡�|Ľ�ݸ�˵������.*�ȵȵȰɣ�������û��ʲô����Ȥ���书��ѧ����$|^(> |)Ľ�ݸ�˵������.*��û����ҽ�����������ء���$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"Ľ�ݸ�����Ķ�������˵��") then
	  world.AppendToNotepad (WorldName(),os.date()..": ͵ѧskill:".. w[2].." "..w[3].."\r\n")
	  local name=w[2]
	  local id=w[3]
	  self.skill_id=w[3]
	  self.skill_name=w[2]
	  self:touxue(name,id)
	  return
	end
	if string.find(l,"�ȵȵȰɣ�������û��ʲô����Ȥ���书��ѧ") then
	  	local cd=cond.new()
	    cd.over=function()
	     print("���״̬")
		 if table.getn(cd.lists)>0 then
		    local sec=0
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="����æ״̬" then
			   self.fail(102)
			   return
			  end
			end
		 end
		 self.fail(101)

	   end
	   cd:start()
	   return
	end
	if string.find(l,"��û����ҽ������������") then
	   self:giveup()
	   return
	end
	wait.time(5)
   end)
  end
  w:go(1989)
end

function touxue:reward()
 --[[local win=window.new() --��ش���
 win.name="status_window"
 win:addText("label1","Ŀǰ����:͵ѧ����")
 win:addText("label2","Ŀǰ����:����")
 win:refresh()]]

   	local ts={
	           task_name="Ľ��͵ѧ",
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
    world.Send("ask murong fu about ����")
    local l,w=wait.regexp("^(> |)Ľ�ݸ����������ͷ������˵�����������ˣ���ȥ��Ϣ�ɡ�$|^(> |)Ľ�ݸ�˵��������ѧ��ʲô�����ˣ��������һ�������$|^(> |)Ľ�ݸ�˵������������û������ɣ���$",5)
	if l==nil then
	  self:reward()
	  return
	end
	if string.find(l,"Ľ�ݸ����������ͷ") then
	  self:exps()
      local b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	     self:jobDone()
	  end
	  b:check()
	  return
	end
	if string.find(l,"������û�������") then
	   self:giveup()
	   return
	end
	if string.find(l,"��ѧ��ʲô�����ˣ��������һ���") then
	   self:giveup()
	   return
	end
	wait.time(5)
   end)
  end
  w:go(1989)
end

function touxue:NextPoint()
   print("���ָ̻�")
   coroutine.resume(touxue.co)
end

function touxue:giveup()
   local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask murong fu about ����")
    local l,w=wait.regexp("^(> |)����Ľ�ݸ������йء�����������Ϣ��$",5)
	if l==nil then
	  self:giveup()
	  return
	end
	if string.find(l,"����Ľ�ݸ������й�") then
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	    self:Status_Check()
	  end
	  b:check()
	  return
	end
	wait.time(5)
   end)
  end
  w:go(1989)
end

function touxue:exps()
 wait.make(function()
   local l,w=wait.regexp("^(> |)������.*$",5)
    if l==nil then
       self:exps()
	   return
    end
    if string.find(l,"������") then
	   --world.AppendToNotepad (WorldName(),os.date()..": ͵ѧjob ����:".. ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]).."\r\n")
	   --local exps=world.GetVariable("get_exp")
	   --exps=tonumber(exps)+ChineseNum(w[2])
	   --world.SetVariable("get_exp",exps)
	   --world.AppendToNotepad (WorldName(),os.date().."Ŀǰ����ܾ���ֵ"..exps.."\r\n")
	  return
	end
	wait.time(5)
 end)
end

function touxue:checkPlace(npc,roomno,here)
      if is_contain(roomno,here) then
	       print("ȷ�����������->Next Room")
		   local b
		   b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
	   else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
	      w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno)
		  end
		  w:go(roomno)
	   end
end


function touxue:run(i)
   if i==nil then
      i=1
   end
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
			   if self.success==true then
                  self:reward()
               else
                  self:giveup()
               end
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function touxue:combat_check()
end

function touxue:flee(i)
  world.Send("yield no")
  --world.Send("go away")
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
	 self:combat_check()
	 self:run(i)
   end
   _R:CatchStart()
end

function touxue:combat()
end

function touxue:start(npc,id)
  wait.make(function()
   world.Send("yun qi")
   world.Send("yun jing")
   world.Send("yun refresh")
   world.Send("hp")
   --world.Send("yun shenyuan")
   world.Send("touxue "..self.skill_id.." from "..id)
   local l,w=wait.regexp("^(> |)��о��Ѿ�����������"..self.skill_name.."�ľ��裬���Ի�ȥ�����ˡ�|^(> |)����ս������ô��͵ѧ�أ�$|^(> |)��Ҫ��˭͵ѧ��$|^(> |)������û���ö�ת���ƣ���ô��͵ѧ�����˵��书��$",3)
   if l==nil then
      self:start(npc,id)
      return
   end
   if string.find(l,"����ս������ô��͵ѧ��") then
      world.Send("hit "..id)
      self:start(npc,id)
	  return
   end
   if string.find(l,"��о��Ѿ�����������") then
      shutdown()
      self.success=true
      self:flee()
      return
   end
   if string.find(l,"������û���ö�ת���ƣ���ô��͵ѧ�����˵��书") then
      world.Send("jifa parry douzhuan-xingyi")
	  self:start(npc,id)
      return
   end
   if string.find(l,"��Ҫ��˭͵ѧ") then
     print("ս������")
     shutdown()
     self:recover()
     return
   end
   wait.time(3)
  end)
end

function touxue:yield()
  wait.make(function()
    world.Send("yield yes")
    local l,w=wait.regexp("^(> |)��������ʱ�򲻻��֡�$",2)
	if l==nil then
	  self:yield()
	  return
	end
	if string.find(l,"��������ʱ�򲻻���") then
	  print("��ʼ���е���!!!")
	  return
	end
	wait.time(2)
  end)
end

function touxue:fight(npc,id)
    	local ts={
	           task_name="Ľ��͵ѧ",
	           task_stepname="ս��",
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="͵ѧ"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --[[local win=window.new() --��ش���
   win.name="status_window"
   win:addText("label1","Ŀǰ����:͵ѧ����")
   win:addText("label2","Ŀǰ����:fight")
   win:addText("label3","͵ѧnpc:"..npc)
   win:refresh()]]
   world.Send("jifa parry douzhuan-xingyi")
   --world.Send("yun shenyuan")
   world.Send("yield yes")
   world.Send("hit "..id)
   self:yield()
   self:combat()
   self:start(npc,id)
end

function touxue:checkNPC(npc,roomno)
  print(npc)
  wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc..".*\\\((.*)\\\).*$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      --û���ҵ�
		  if roomno~=nil then
		     local f=function(r)
		        self:checkPlace(npc,roomno,r)
		     end
		     WhereAmI(f,10000) --�ų����ڱ仯
		  else
		     self:NextPoint()
		  end
		  return
	  end
	  if string.find(l,npc) then
	     --�ҵ�
		  local id=string.lower(w[2])
		  if id=="corpse" then
			if roomno~=nil then
		      local f=function(r)
		        self:checkPlace(npc,roomno,r)
		      end
		      WhereAmI(f,10000) --�ų����ڱ仯
		    else
		      self:NextPoint()
			end
		  else
			 self:fight(npc,id)
		  end
		  return
	  end
	  wait.time(6)
   end)
end

function touxue:look_paper()
   wait.make(function()
      world.Send("look paper")
	  local l,w=wait.regexp("^(> |)����һ�ŷ��Ƶľ�������д�ţ�͵ѧ.*�� (.*) \\((.*)\\)��$",5)
	  if l==nil then
	     self:look_paper()
	     return
	  end
	  if string.find(l,"����һ�ŷ��Ƶľ�") then
	     --print(w[2],w[3])
	     local name=w[2]
	     local id=w[3]

	     self.skill_name=Trim(w[2])
		 self.skill_id=Trim(w[3])
	     self:touxue(name,id)
	     return
	  end
	  wait.time(5)
   end)
end

function touxue:shield()
end

function touxue:touxue(name,id)
  --[[ local win=window.new() --��ش���
   win.name="status_window"
   win:addText("label1","Ŀǰ����:͵ѧ����")
   win:addText("label2","Ŀǰ����:͵ѧ")
   win:addText("label3","͵ѧskills:"..name)
   win:refresh()]]


  print(name,id)
  local npc=""
  local rooms=nil
  print(table.getn(touxue_skills_target))
  for _,i in ipairs(touxue_skills_target) do
    -- print(i[1]," �ȶ� ",name)
     if i[1]==name then
	   print("�ҵ�")
	   npc=i[2]
	   rooms=i[3]
	   break
	 end
  end



  local exps=world.GetVariable("exps")
  print(name,exps)
  if (name=="ɢ����" or name=="��Ӱ������" or name=="����ʮ����") and tonumber(exps)<=800000 then
    local b=busy.new()
	b.interval=0.3
	b.Next=function()
     self:giveup()
	end
    b:check()
     return
  end
  if rooms==nil then
	local b=busy.new()
	b.interval=0.3
	b.Next=function()
     self:giveup()
	end
    b:check()
     return
  end
  local n=table.getn(rooms)
  if n>0 then

	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   print("ץȡ")
	   self:shield()
	   touxue.co=coroutine.create(function()
          for _,r in ipairs(rooms) do
		       	local ts={
	           task_name="Ľ��͵ѧ",
	           task_stepname="͵ѧ"..npc,
	           task_step=2,
	           task_maxsteps=4,
	           task_location=r,
	           task_description="͵ѧ "..name.."("..id..")",
	      }
	       local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
		    local w=walk.new()
			w.walkover=function()
			   self:checkNPC(npc,r)
			end
			w:go(r)
			coroutine.yield()
		  end
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

function touxue:auto_kill()
  wait.make(function()
    print("��auto kill")
     local l,w=wait.regexp("^(> |)������.*��ɱ���㣡$",10)
	 if l==nil then
	    self:auto_kill()
	   return
	 end
	 if string.find(l,"��ɱ����") then
	   shutdown()
	   self:flee()
	   return
	 end
     wait.time(10)
  end)
end

function touxue:recover()
    self:auto_kill()
	local h
	h=hp.new()
	h.checkover=function()
		if h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal()
		elseif h.neili<(h.max_neili*2-200) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.8
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
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
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   if h.neili>h.max_neili*2-200 then
			      world.Send("yun recover")
			      self:look_paper()
			   else
	             print("��������")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)
			shutdown()
			local b
			b=busy.new()
			b.Next=function()
			  self:look_paper()
			end
			b:check()
		end
	end
	h:check()
end

local chufang=1997

function touxue:full()
   local h
	h=hp.new()
	h.checkover=function()
	    --[[print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
		     local w
		     if h.food<50 then
			    print("eat")
			    w=walk.new()
		        w.walkover=function()
		         --world.Send("ask xiao tong about ʳ��")
			     world.Execute("get ji;get ya;get yuyuan")
			  	 world.Execute("eat ji;eat ji;eat ji;eat ya;eat ya;eat yuyuan;eat yuyuan;drop ji;drop ya;drop yuyuan")
				 local f
				 f=function()
				   self:full()
				 end
				 f_wait(f,1.5)
			   end
			   w:go(chufang) --2707
			    if chufang==1997 then
			      chufang=2707
				else
				  chufang=1997
			    end
			 elseif h.drink<50 then
			   --world.Send("ask xiao tong about ��")
			    print("drink")
			    w=walk.new()
		        w.walkover=function()
			     world.Execute("get cha")
			  	 world.Execute("drink cha;drink cha;drink cha;drop cha")
				 local f
				 f=function()
				   self:full()
				 end
				 f_wait(f,1.5)
			   end
			    w:go(1992) --299 ask xiao tong about ʳ�� ask xiao tong about ��
			 end]]
		if h.qi_percent<=30 or h.jingxue_percent<=80 then
		    print("����")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:liaoshang()

		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal()

		elseif h.neili<(h.max_neili*2-200) then
		    local x
			x=xiulian.new()
			x.safe_qi=300
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun qi")
				  world.Send("yun regenerate")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
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
			          self:full()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   if h.neili>h.max_neili*2-200 then
			     world.Send("yun recover")
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

function touxue:jobDone()
end

function touxue:Status_Check()
   --[[ local win=window.new() --��ش���
     win.name="status_window"
	 win:addText("label1","Ŀǰ����:Ľ��͵ѧ")
	 win:addText("label2","Ŀǰ����:����")
     win:refresh()]]
	   	local ts={
	           task_name="Ľ��͵ѧ",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    self.win=false
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
            self:full()
	end
	cd:start()
end


