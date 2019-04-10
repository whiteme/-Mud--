--����鰲ͨ�����йء�job������Ϣ��
--�鰲ͨ˵����������³��뱾�����ԣ�����ȥ����Ǵ�֮�Ұ���ɱ�ˣ���
--�鰲ͨ�ó�һ�������ƣ�����������˴���Ǵ�֮������¼����֣��������㡣

suoming={
  new=function()
     local sm={}
	 setmetatable(sm,{__index=suoming})
	 return sm
  end,
  co=nil,
  name="",
  id="",
  place="",
  danger=false,
  neili_upper=1.9,
  is_zhaohun=false,
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

local cb={}
--[[�鰲ͨ˵����������������ȥ���̷������跨��������˳���̣���
�鰲ͨ�ó�һ���л��ƣ���������������̷��������������֣��������㡣]]
function suoming:catch_place()
  wait.make(function()
    local l,w=wait.regexp("^(> |)�鰲ͨ˵������(.*)���뱾�����ԣ�����ȥ(.*)��.*ɱ�ˣ���$|^(> |)�鰲ͨ˵����������������ȥ(.*)�跨��(.*)��˳���̣���$|^(> |)�鰲ͨ˵���������Ȱ�ǰһ�����������˵����$|^(> |)�鰲ͨ˵���������������������Ϣһ�°ɡ���$|^(> |)�鰲ͨ˵��������С�Ӿ���͵͵���������ɵ����񣬻����������������ȥô����$|^(> |)�鰲ͨ����Ķ�������˵������������ΤС����Ϊ�����̲�С��$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"���뱾������") then
	  self.is_zhaohun=false
	  self.place=w[3]
	  self.name=w[2]
	  world.AppendToNotepad (WorldName(),os.date().." Ŀ��:"..w[2].." ���ڵ�:".. w[3].."\r\n")
	  self:find()
	  return
	end
	if string.find(l,"��С�Ӿ���͵͵���������ɵ����񣬻����������������ȥô") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  self.fail(102)
		end
		b:check()
	   return
	end
	if string.find(l,"��˳����") then
	  self.is_zhaohun=true
	  self.place=w[5]
	  self.name=w[6]
	  world.AppendToNotepad (WorldName(),os.date().." Ŀ��:"..w[6].." ���ڵ�:".. w[5].."\r\n")
	  self:find()
	  return
	end
	if string.find(l,"����ΤС����Ϊ�����̲�С") then
	   world.AppendToNotepad (WorldName(),os.date().." Ŀ��:ΤС��ΤС��ΤС��С��\r\n")
	   local q=quest.new()
	   q:weichunhua()
	  return
	end
    if string.find(l,"���������������Ϣһ�°�") then
	   self.fail(101)
	   return
	end
	if string.find(l,"���Ȱ�ǰһ�����������˵") then
	  self:cancel()
	  return
	end
	wait.time(5)
  end)
end

function suoming:ask_job()
  self.danger=false
  local w=walk.new()
  local al=alias.new()
  al.do_jobing=true
  w.user_alias=al
  w.walkover=function()
   wait.make(function()
    world.Send("ask hong antong about job")
    local l,w=wait.regexp("^(> |)����鰲ͨ�����йء�job������Ϣ��$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"����鰲ͨ�����й�") then
	  --print("why1")
	  self:catch_place()
	  return
	end
	wait.time(5)
   end)
  end
  w:go(1795)
end

function suoming:combat()

end

function suoming:wait_zhaohun()
	  cb=fight.new()
	  cb.check_pfm=false
	  cb.damage=function(per)
         if tonumber(per)<=50 then
	      print("���ڰ�ȫ���ÿ�ʼ����ս��")
		  self:flee()
	     end
      end
	  cb.finish=function()
          print("ս������")
		  --world.Send("unset wimpy")
		  --shutdown()
		  --self:jobDone()
		  self:flee()
	  end
	  cb.neili_lack=function()
	     print("��������")
		 self:flee()
	  end
	  cb.cond=function()
	  end
	  cb.recover=function(flag)
	    wait.make(function()
           print("��������")
			world.Send("yun recover")
           local l,w=wait.regexp("���������˼���������ɫ�������ö��ˡ�|�������������档",2)
	        if l==nil then
	           -- print("����")
	          cb:recover(flag)
	          return
            end
	        if string.find(l,"���������˼���������ɫ�������ö���") or string.find(l,"��������������") then
	         -- world.Send("alias pfm")
	          --self:injure()
	          --self:check()
	            print("recover resume check")
	            cb:check_resume()
	          return
	        end
            wait.time(2)
	    end)
	  end
	  cb.refresh=function()
	   wait.make(function()
		  world.Send("yun refresh")
          print("��������")
          local l,w=wait.regexp("^(> |)�㳤��������һ������$|^(> |)�����ھ������档$",2)
	      if l==nil then
	        cb:refresh()
	        return
          end
	      if string.find(l,"�㳤��������һ����") or string.find(l,"�����ھ�������") then
	        --world.Send("alias pfm")
            --self:check()
	        print("refresh resume check")
	        cb:check_resume()
	        return
	      end
          wait.time(2)
        end)
	  end
	  cb:start()
end

--�㱻������һ������㾭�飬��ʮ�˵�Ǳ�ܣ��������ĵ㸺��
--��������ڴ��ڻ����У���������˵�Ļ�!
function suoming:exps()
  wait.make(function()
   local l,w=wait.regexp("^(> |)�㱻������(.*)�㾭�飬(.*)��Ǳ�ܣ�.*����$",5)
   if l==nil then
      self:exps()
      return
   end
  if string.find(l,"�㱻����") then
	   --world.Send("yield no")
	   shutdown()
       world.AppendToNotepad (WorldName(),os.date()..": ����job ����:".. ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]).."\r\n")
	   local exps=world.GetVariable("get_exp")
	   exps=tonumber(exps)+ChineseNum(w[2])
	   world.SetVariable("get_exp",exps)
	   world.AppendToNotepad (WorldName(),os.date().."Ŀǰ����ܾ���ֵ"..exps.."\r\n")
	   local b
	   b=busy.new()
	   b.interval=0.5
	   b.Next=function()
		 self:jobDone()
	   end
	   b:check()
	   return
   end
   wait.time(3)
  end)
end

function suoming:zhaohun(npc,id)
   wait.make(function()
    if self.danger==true then
	   print("����ֹͣ�л꣡��")
	   return
	end
    print("zhaohun "..id)
	world.Send("hp")
	world.Send("yun refresh")

    --world.Send("zhaohun "..id)--^(> |)���ó��л��ƶ���.*һ�Σ�Ȼ��������$|
	local l,w=wait.regexp("^(> |)�㳤��������һ������$|^(> |)�����ھ������档$",2)
	if l==nil then
      self:zhaohun(npc,id)
	  return
	end
	--[[if string.find(l,"���ó��л��ƶ���") then
	  local f=function() self:zhaohun(npc,id) end
	  f_wait(f,1.2)
	  return
	end]]

	if string.find(l,"�㳤��������һ����") or string.find(l,"�����ھ�������") then
	   local pfm=world.GetVariable("zhaohun_pfm") or ""
	   --print(pfm)
	   if pfm~="" then
	    local value=world.GetVariable(pfm) or ""
		if value~="" then
	      world.Execute(value)
		end
	  end
	   world.Send("yield no")
	   world.Send("zhaohun "..id)
	   wait.make(function()
	      local l,w=wait.regexp("^(> |)��������ڴ��ڻ����У���������˵�Ļ�.*$|^(> |).*���㰧���������ǵ�С��˼�����ʹ��˴����Ź��Ұɣ�.*$",0.8)
		  if l==nil then
	        self:zhaohun(npc,id)
			return
		  end
		  if string.find(l,"���ʹ��˴����Ź���") then
		     world.Send("no")
			self:zhaohun(npc,id)
			return
		  end
		 if string.find(l,"������") then
	       world.Send("yield yes")
	       shutdown()
	    --cb:close_combat_check()
	      print("�ر�ս�����")
	     local f=function()
	       self:wait_zhaohun()
		    self:exps()
	        self:zhaohun(npc,id)
	      end
	      f_wait(f,2)
	      return
  	    end

	   end)
	   return
	end

    wait.time(5)
  end)
end

function suoming:suoming(index)
local b=busy.new()
b.interval=0.5
b.Next=function()
  wait.make(function()
   if index==nil then
       world.Send("get gold from corpse")
	   world.Send("get silver from corpse")
       world.Send("suoming corpse")
	else
	   world.Send("get gold from corpse "..index)
	   world.Send("get silver from corpse "..index)
	   world.Send("suoming corpse ".. index)
   end
   local l,w=wait.regexp("^(> |)�㱻������(.*)�㾭�飬(.*)��Ǳ�ܣ�.*����|^(> |)�Ҳ������������$|^(> |)���Ҳ��� corpse.* ����������$|^(> |)����˲�����ɱ�ģ�$",5)
   if l==nil then
      self:suoming(index)
	  return
   end
   if string.find(l,"�㱻����") then
       world.AppendToNotepad (WorldName(),os.date()..": ����job ����:".. ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]).."\r\n")
	   local exps=world.GetVariable("get_exp")
	   exps=tonumber(exps)+ChineseNum(w[2])
	   world.SetVariable("get_exp",exps)
	   world.AppendToNotepad (WorldName(),os.date().."Ŀǰ����ܾ���ֵ"..exps.."\r\n")
		local b
		b=busy.new()
		b.interval=0.5
		b.Next=function()
		  self:jobDone()
		end
		b:check()
	   return
   end
   if string.find(l,"����˲�����ɱ��") then
      if index==nil then
	     index=2
	  else
	     index=index+1
	  end
      self:suoming(index)
      return
   end
   if string.find(l,"�Ҳ���") then
      self:giveup()
      return
   end
   wait.time(5)
  end)
 end
 b:check()
end

function suoming:run(dx,i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)������ʧ�ܡ�$|^(> |)�����Ϊ������$|^(> |)�趨����������action \\= \\\"����\\\"$|^(> |)���ֲ���ս������ʲô�ܣ�$|^(> |)�����аٱ䡹ֻ����ս��ʱ�ã�$",1.5)
	   if l==nil then
	      self:run(dx,i)
	      return
	   end
	   if string.find(l,"�����Ϊ����") then
	     if i==nil then
		    i=1
		 else
		    i=i+1
		 end
		 self:flee(i)
	     return
	   end
	   if string.find(l,"��Ķ�����û����ɣ������ƶ�") or string.find(l,"������ʧ��") then
		  self:run(dx,i)
	      return
	   end
	   if string.find(l,"�趨����������action") then
		 world.DoAfter(1.5,"set action ����")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"����\\\"$|^(> |)�趨����������action \\= \\\"����\\\"$",5)
			if l==nil then
			   self:run(dx,i)
			  return
			end
			if string.find(l,"����") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"����") then
			   world.Send("unset wimpy")
			   self:giveup()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   if string.find(l,"���ֲ���ս������ʲô��") or string.find(l,"ֻ����ս��ʱ��") then
		  world.Send("unset wimpy")
		  self:giveup()
	      return
	   end
	   wait.time(1.5)
  end)
end

function suoming:flee(i)
  self.danger=true
  world.Send("jifa dodge youlong-shenfa")
  world.Send("perform dodge.baibian")
  world.Send("go away")
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

function suoming:kill(npc,id)
  self:combat()
  self:wait_badman_die()
  wait.make(function()
    print("kill"..id)
    world.Send("kill "..id)
	local l,w=wait.regexp("^(> |)�����򲻻����أ���ôɱ��$",5)
	if l==nil then
	  self:kill(npc,id)
	  return
	end
	if string.find(l,"�����򲻻�����") then
	  world.Send("yield no")
	  self:kill(npc,id)
	  return
	end
    wait.time(5)
  end)
end

function suoming:find()
	--[[ local win=window.new() --��ش���
     win.name="status_window"
	 win:addText("label1","Ŀǰ����:����������")
	 win:addText("label2","Ŀǰ����:Ѱ��NPC")
	 win:addText("label3","�ص�:"..self.place)
	 win:addText("label4","����:"..self.name)
     win:refresh()]]
	 local ts={
	           task_name="����������",
	           task_stepname="Ѱ��npc",
	           task_step=2,
	           task_maxsteps=4,
	           task_location=self.place,
	           task_description=self.name,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	if self.name=="������" or self.name=="�����" or self.name=="������" or self.name=="�ɹ��" or self.name=="�����" then
	   self:giveup()
	   print("�������ò��ܹ���������")
	   return
	 end
	if zone_entry(self.place)==true then
      self:giveup()
      return
    end
   local n,rooms=Where(self.place)
	if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   suoming.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    print("Ѱ��"..self.name)
		    self:checkNPC(self.name,r)
		  end
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

function suoming:jobDone()
end
--�鰲ͨһ�ư����÷��˳�ȥ��
function suoming:fear()
   wait.make(function()
      local l,w=wait.regexp("^(> |)�鰲ͨһ�ư����÷��˳�ȥ��$|^(> |)�鰲ͨ˵��������ô�������뿹�����ɣ�����$",5)
	  if l==nil then
		 self:cancel()
		 return
	  end
	  if string.find(l,"����") then
	     self:job_failure()
	     self:jobDone()
		 return
	  end
	  if string.find(l,"�鰲ͨһ�ư����÷��˳�ȥ") then
	       local b=busy.new()
	       b.interval=0.3
	       b.Next=function()
	         self:Status_Check()
	       end
	       b:check()
	     return
	  end
	  wait.time(5)
   end)
end

function suoming:job_failure()
end

function suoming:giveup()
   world.AppendToNotepad (WorldName(),os.date()..": ����:giveup \r\n")
   self:job_failure()
   self:jobDone()
end

function suoming:cancel()
 local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask hong antong about cancel")
    local l,w=wait.regexp("^(> |)����鰲ͨ�����йء�cancel������Ϣ��$",5)
	if l==nil then
	  self:giveup()
	  return
	end
	if string.find(l,"����鰲ͨ�����й�") then
	  self:fear()
	  return
	end
	wait.time(5)
   end)
  end
  w:go(1795)
end

function suoming:NextPoint()
   print("���ָ̻�")
   coroutine.resume(suoming.co)
end

function suoming:checkPlace(npc,roomno,here)
      if is_contain(roomno,here) then
  	     print("�ȴ�0.5s,��һ������")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
		 end
		 f_wait(f,0.5)
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

function suoming:badman_die()
end

function suoming:wait_badman_die()
wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",5)
	 if l==nil then
	    self:wait_badman_die()
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
	    print(self.name,w[2])
	    if string.find(self.name,w[2]) then
		   self:badman_die()
		else
           self:wait_badman_die()
		end
	    return
	 end
	 wait.time(5)
  end)
end

function suoming:checkNPC(npc,roomno)
    wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      --û���ҵ�
		  --
		  local f=function(r)
		     self:checkPlace(npc,roomno,r)
		  end
		  WhereAmI(f,10000) --�ų����ڱ仯

		  return
	  end
	  if string.find(l,npc) then
	     --�ҵ�
		  local id=string.lower(trim(w[2]))
		  self.id=id
		  print(id)
		  if self.is_zhaohun==true then
		    --world.Send("yield yes")
			world.Send("unset wimpycmd")
			self:wait_zhaohun()
	        self:exps()
		    self:zhaohun(npc,id)
		  else
		    self:kill(npc,id)
		  end
		  return
	  end
	  wait.time(6)
   end)
end

function suoming:full()
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
			print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("sit chair;knock table;get mi tao;get cha;drink cha;drink cha;drink cha;eat mi tao;eat mi tao;eat mi tao;drop wan;drop mi tao;drop tea")
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
		elseif h.qi_percent<=30 or h.jingxue_percent<=80 then
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

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
			x.min_amount=100
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun regenerate")
				  world.Send("yun recover")
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
               print("����:",h.max_neili*self.neili_upper)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
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
			  world.Send("yun recover")
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end

function suoming:Status_Check()
    --[[local win=window.new() --��ش���
     win.name="status_window"
	 win:addText("label1","Ŀǰ����:������")
	 win:addText("label2","Ŀǰ����:����")
     win:refresh()
    self.win=false]]
		 local ts={
	           task_name="����������",
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
            self:full()
	end
	cd:start()
end
