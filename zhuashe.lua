--С����");break;
--		case 1: me->set("name","�˻���");break;
--		case 2: me->set("name","�۾���");break;
--		case 3: me->set("name","����");break;
--		case 4: me->set("name","�岽��");break;
--		case 5: me->set("name","������");break;
--		case 6: me->set("name","��β��");break;
--		case 7: me->set("name","�Ľ���");break;
--		case 8: me->set("name","����");break;
--		case 9: me->set("name","������");break;
--		case 10: me->set("name","Ұ������");break;
--��ͻȻ���ֲݴ�����һ���ߡ�
--������������ɱ���㣡

zhuashe={
  new=function()
     local zs={}
	 setmetatable(zs,{__index=zhuashe})
	 zs.room={}
	 return zs
  end,
  co=nil,
  neili_upper=1.9,
  rooms={},
  version="1.55",
}

function zhuashe:NextPoint()
   print("���ָ̻�")
   coroutine.resume(zhuashe.co)
end

function zhuashe:Search(rooms)
   for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      --self:giveup()
			  --self:beauty_exist()
			  self:NextPoint()
		  end
		  w.user_alias=al
		  w.noway=function()
		     self:NextPoint()
		  end
		  w.walkover=function()
             local f=function()
			   self:NextPoint()
			 end
			 f_wait(f,1.5)
		  end
		  --
		  w:go(r)
		  coroutine.yield()
   end
end

function zhuashe:wait_she_idle(snake)
   wait.make(function()  --������Ȫ��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
     --print(npc.."��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��")
     local l,w=wait.regexp("^(> |).*����һ�ţ������ˡ�������ץ��������$",5)
     if l==nil then
	   self:wait_she_idle(snake)
	   return
	 end
	 if string.find(l,"����һ�ţ������ˡ�������ץ������") then
	    shutdown()
        --self:reward()
		local b=busy.new()
		b.Next=function()
		  local f=function() self:reward() end
		  self:poison(f)
		end
		b:check()
	    return
	 end
	 wait.time(5)
   end)
end

function zhuashe:auto_kill_check()
  --��������Ĺ����ɱ���㣡
  --print("auto kill ���")
  wait.make(function()
    local l,w=wait.regexp("^(> |)������(.*)��ɱ���㣡$",5)
	if l==nil then
	  self:auto_kill_check()
	  return
	end
	if string.find(l,"��ɱ����") then
	  local snake=w[2]
	  if snake=="Ұ������" or snake=="С����" or snake=="�˻���" or snake=="�۾���" or snake=="����" or snake=="�岽��" or snake=="������" or snake=="��β��" or snake=="�Ľ���" or snake=="����" or snake=="������" then
          world.Send("say "..snake.."�����������������������ϵ�������ҪԲ��Ҫ�ף�")
		  shutdown()
		  local ts={
	           task_name="ץ��",
	           task_stepname="ս��",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	       }
	       local st=status_win.new()
	       st:init(nil,nil,ts)
	       st:task_draw_win()
		  self:wait_she_idle(snake)
		  self:combat()
	     return
	  end
    end
	wait.time(5)
  end)
end

function zhuashe:she(location)
	 	local ts={
	           task_name="ץ��",
	           task_stepname="����",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   if zone_entry(location)==true then
      self:giveup()
      return
   end
    if location=="����ׯ�Ź��һ���" or location=="��ɽ����������" then
	     self:giveup()
		 return
	end
	print(location)
   local n,e=Where(location)
   local range
   if string.find(location,"�䵱��ɽ") then
      range=3
   else
      range=6
   end
	local rooms=depth_search(e,3)  --��Χ��ѯ

    self.rooms=rooms
	self:auto_kill_check()
    if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	   print("ץȡ")
	   zhuashe.co=coroutine.create(function()
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
	   local b2
	   b2=busy.new()
	   b2.interval=0.5
	   b2.Next=function()
	     self:NextPoint()
	   end
	   b2:check()
	 end
	 b:check()
	else
	  print("û��Ŀ��")
	  self:giveup()
	end
end

function zhuashe:jobDone() --�ص�����
end

function zhuashe:run(i)
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

function zhuashe:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("Ѱ�ҳ���")
     local dx=_R.get_all_exits()
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
	 self:run(run_dx,i)
   end
   _R:CatchStart()
end

function zhuashe:shield()

end

function zhuashe:exps()
  wait.make(function()
    local l,w=wait.regexp("^(> |)������(.*)�����(.*)��Ǳ�ܡ�$",5)
		if l==nil then
		   self:exps()
		   return
		end
		if string.find(l,"������") then
		    --world.AppendToNotepad (WorldName(),os.date()..": ץ�߾���".. ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]).."\r\n")
		  --[[local exps=nil
		  exps=world.GetVariable("get_exp")
		  if exps==nil then
		    exps=0
		  end]]
		 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ؤ��ץ������:����! ����:"..ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]), "green", "black") -- yellow
		  --exps=tonumber(exps)+ChineseNum(w[2])
		  --world.SetVariable("get_exp",exps)
		  --world.AppendToNotepad (WorldName(),os.date().."Ŀǰ����ܾ���ֵ"..exps.."\r\n")

		   return
		end

  end)
end

function zhuashe:getdan(count)
    if count==nil then
	  count=0
	end
	print(count,"�ж����")
	if count>5 then
	   self:jobDone()
       return
	end
	local f=function()
		self:getdan(count)
	end

	local h=hp.new()
	h.checkover=function()
		if h.jingxue_percent<100 then --������
			world.Send("ask chen about �ٲݵ�")
			world.Send("fu dan")
			count=0
			f_wait(f,1)

		else
		    count=count+1
		    f_wait(f,1)
		end
   end
   h:check()
end

function zhuashe:qudu()

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
			         self:getdan()

					return
			     end

			   end
		     end
			local h=hp.new()
 	        h.checkover=function()
	        	if h.jingxue_percent<100 then --������
			       world.Send("ask chen about �ٲݵ�")
			       world.Send("fu dan")

		        end
			self:jobDone()
           end
           h:check()
		end
	cd:start()
end

function zhuashe:reward()
	 	local ts={
	           task_name="ץ��",
	           task_stepname="����",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
        --world.Send("ask chen about �ٲݵ�")
		self:exps()
		local l,w=wait.regexp("^(> |)������(.*)�����(.*)��Ǳ�ܡ�$|^(> |)�³��ϴ�������ӹ��ߣ�ת��װ��һ���ڴ��$",5)
		if l==nil then
		   world.Send("e")
		   self:reward()
		   return
		end

		if string.find(l,"�³��ϴ�������ӹ��ߣ�ת��װ��һ���ڴ���") then

		      local b
		      b=busy.new()
		      b.interval=0.5
		      b.Next=function()
		         self:qudu()
			  end
		      b:check()

		   return
		end
	  end)
   end
   w:go(1002)
end

function zhuashe:liaoshang_fail()
end

function zhuashe:giveup()
	 	local ts={
	           task_name="ץ��",
	           task_stepname="����",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
 local w
   w=walk.new()
   w.walkover=function()
      world.Send("ask chen about ����")
	   wait.make(function()
	   local l,w=wait.regexp("^(> |)����³��ϴ����йء�����������Ϣ��$",8)
	   if l==nil then
		 self:giveup()
	     return
	   end
	   if string.find(l,"����³��ϴ����йء�����������Ϣ") then
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		  self:Status_Check()
		 end
		 b:check()
	     return
	   end
	   wait.time(8)
	 end)
   end
   w:go(1002)
end
--�³���˵������ȥ��ɽ�������ݳǸ�������׽���߻����ɣ�
function zhuashe:xunwen()
    wait.make(function()
		local l,w=wait.regexp("^(> |)�³���˵������ȥ(.*)��������׽���߻����ɣ�$|^(> |)�³���˵���������ץ���ߣ�������ȥ��Ϣһ��ɡ���$|^(> |)�³���˵�������ղŲ����������ץ��ȥ��������ô����ȥ����$|^(> |)�³���˵����������ͷ�����������°ɣ���һ�������ɣ���$",5)
		if l==nil then
		   self:xunwen()
		   return
		end
		if string.find(l,"����ͷ�����������°�") then
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self.fail(102)
		   end
		   b:check()
		   return
		end
		if string.find(l,"���ץ���ߣ�������ȥ��Ϣһ���") then
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self.fail(101)
		   end
		   b:check()
		   return
		end
		if string.find(l,"��������׽���߻�����") then
		   --print(w[2])
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ؤ��ץ������:�ص�"..w[2], "green", "yellow") -- yellow
		   self:she(w[2])
		   return
		end
		if string.find(l,"����ô����ȥ") then
		   self:giveup()
		   return
		end
		if string.find(l,"�㷢�����鲻����ˣ�������˵������") then
		   self:ask_job()
		   return
		end
	    wait.time(5)
    end)
end

function zhuashe:ask_job()
	 	local ts={
	           task_name="ץ��",
	           task_stepname="ѯ��",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 self.beauty_list={}
	 self.rooms={}
       local w
        w=walk.new()
		local al=alias.new()
        al.do_jobing=true
        w.user_alias=al
	    w.walkover=function()
        wait.make(function()
		world.Send("ask chen about �ٲݵ�")
		local b=busy.new()
		b.interval=0.3
		b.Next=function()
          world.Send("ask chen about job")
		end
		b:check()
		local l,w=wait.regexp("^(> |)����³��ϴ����йء�job������Ϣ��$",5)
		if l==nil then
		   self:ask_job()
		   return
		end
		if string.find(l,"����³��ϴ����йء�job������Ϣ") then
		   self:xunwen()
 		   return
		end
		wait.time(5)
	  end)
     end
     w:go(1002)
end

function zhuashe:eat()
    local w=walk.new()
	w.walkover=function()
	      world.Execute("buy baozi")
		  world.Execute("eat baozi;eat baozi;eat baozi;drop baozi")
		 local f
		  f=function()
			self:Status_Check()
		  end
		  f_wait(f,1.5)
	end
	w:go(976) --����¥ 976
end

function zhuashe:drink()
     local w=walk.new()
	   w.walkover=function()
	      world.Execute("buy jiudai")
		  world.Execute("drink jiudai;drink jiudai;drink jiudai;drink jiudai;drink jiudai;drop jiudai")
		 local f
		  f=function()
			self:Status_Check()
		  end
		  f_wait(f,1.5)
		end
		w:go(976) --����¥ 976
end

function zhuashe:Status_Check()
   	 	local ts={
	           task_name="ץ��",
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
     --��ʼ��
	local h
	h=hp.new()
	h.checkover=function()
	   --[[ print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
			 if h.food<50 then
			    self:eat()
			 elseif h.drink<50 then
			    self:drink()
			 end

		else]]
		if h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
			local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=999
			rc.liaoshang_fail=function()
			   print("xs ����fail")
			   self:liaoshang_fail()
			end
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 and h.qi_percent>=80 then
			print("��ͨ����")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.liaoshang_fail=self.liaoshang_fail
			rc.saferoom=999
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
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(999)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
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

function zhuashe:poison(callback)
     local sp=special_item.new()
       sp.cooldown=function()
           callback()
       end
       local equip={}
	   equip=Split("<��ȡ>�ۻ�","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
	   --[[ ���ۻƽ�ٶ�
   	 local cd=cond.new()
	 cd.over=function()
	     print("���״̬")
		 if table.getn(cd.lists)>0 then
		    local sec=0
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="�߶�" then
			   sec=i[2]
			   local b=busy.new()
			   b.Next=function()
			     world.Send("fu dan")
				 callback()
			   end
			   b:check()
			   return
			  end
			end
			callback()
		else
		   callback()
		end
	 end
	 cd:start()]]
end

function zhuashe:combat()  --�ص�����
end

function zhuashe:combat_end()
end

function zhuashe:fail(id)
end

--[[��ٺ���Ц�˼�������ָ����Ƹ�����ᵯ�˵��ĭ��
��һ������Ƹ�������ͨ������˹�ȥ��

ֻ���߳�����׳�����ӽ��Ƹ��������ѩɽ�ķ��򼲱���ȥ��]]
