
teachmonk={
    new=function()
     local tm={}
	 setmetatable(tm,{__index=teachmonk})
	 return tm
  end,
  co=nil,
  neili_upper=1.5,
  usedroom={},
  place="",
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

function teachmonk:fail(id)
end

function teachmonk:recover()
    world.Send("yun recover")
	world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()
	    if h.qi_percent<100 then --������
		    print("��ͨ����")
            local rc=heal.new()
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
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun recover")
				  local f=function()
				     self:recover()
				  end
				  f_wait(f,2)
			    end
				if id==777 then
				  self:recover()
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
			   world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
				  self:NextPoint()
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
		    self:NextPoint()
		end
	end
	h:check()
end

local path1="ask xuancan dashi about �޺���ֵ��;w;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��"
local path2="ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;n;ask xuancan dashi about �޺���ֵ��;n;ask xuancan dashi about �޺���ֵ��;n;ask xuancan dashi about �޺���ֵ��;n;ask xuancan dashi about �޺���ֵ��"
local path3="ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��"
local path4="ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;n;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;s;ask xuancan dashi about �޺���ֵ��;w;ask xuancan dashi about �޺���ֵ��;w;ask xuancan dashi about �޺���ֵ��;n;ask xuancan dashi about �޺���ֵ��"
local path5="ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��;e;ask xuancan dashi about �޺���ֵ��"
local paths={
 path1,path2,path3,path4,path5
}
function teachmonk:ask_job(index)
--����ƶ�
  	local ts={
	           task_name="���ֽ�ѧ",
	           task_stepname="��ʼ��ѧ",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  if index==nil or index>5 then
     index=1
  end
  local w=walk.new()
  w.walkover=function()
    world.Execute(paths[index])
	world.Send("set action ֵ��")
	local l,w=wait.regexp("^(> |)����˵�����ðɣ�������޺�����ѵ����ɮ�ɣ�����������֣����Ǹ����Ż������Ρ�$|^(> |)�趨����������action \\= \\\"ֵ��\\\"$|^(> |)���Ѵ�ʦ˵������������æ�������������ء���$|^(> |)���Ѵ�ʦ˵��������ղŲ����Ѿ��ʹ����𣿡�$|^(> |)���Ѵ�ʦ˵���������ѵ����ɮ��������������Ϣһ��ɡ���",5)
	if l==nil then
	   self:ask_job(index)
	   return
	end
	if string.find(l,"������޺�����ѵ����ɮ") then
	  self.usedroom={}
	  table.insert(self.usedroom,3164)
	  table.insert(self.usedroom,3165)
	  table.insert(self.usedroom,3166)
	  table.insert(self.usedroom,3167)
	  table.insert(self.usedroom,3168)
      table.insert(self.usedroom,3169)
	   self:motou()
	   local b=busy.new()
	   b.Next=function()
	     self:go_monk()
	   end
	   b:check()
	   return
	end
	if string.find(l,"��ղŲ����Ѿ��ʹ�����") then
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
	     self:go_monk()
	   end
	   b:check()
	   return
	end
	if string.find(l,"������æ��������������") then
        self.fail(102)
	   return
	end
	if string.find(l,"����Ϣһ��") then
	   self.fail(101)
	   return
	end
	if string.find(l,"�趨����������action") then
	   index=index+1
	   local f=function()
	     self:ask_job(index)
	   end
	   f_wait(f,0.5)
	   return
	end
  end--
  w:go(869)
end

function teachmonk:kill_monk(index)
    --for _,r in ipairs(self.usedroom) do

	--end
	if index==nil then
	   index=1
	end
	print("ʣ�෿����Ŀ:",table.getn(self.usedroom))
	if table.getn(self.usedroom)>=index then
	   local w=walk.new()
	   w.walkover=function()
	      world.Send("kill monk")
		  local l,w=wait.regexp("^(> |)Բ.*��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",20)
		  if l==nil then
		    self:kill_monk(index)
			return
		  end
		  if string.find(l,"����") or string.find(l,"û�������") then
			index=index+1
			self:kill_monk(index)
		    return
		  end
	   end
	   print("�����:",self.usedroom[index])
	   w:go(self.usedroom[index])
	   return
	end
	self:giveup()
end

function teachmonk:go_monk(targetRoomNo)
  if targetRoomNo==nil then
    roomno=3165
  elseif targetRoomNo==3165 then
   roomno=3164
  elseif targetRoomNo==3164 then
   roomno=3166
  elseif targetRoomNo==3166 then
   roomno=3167
  elseif targetRoomNo==3167 then
   roomno=3168
  elseif targetRoomNo==3168 then
   roomno=3169
  elseif roomno==3169 then
    print("���ڸ������,Ī�����ĺڣ���")
    self:kill_monk(1)
	return
  end
   local w=walk.new()
   w.walkover=function()
      --world.Send("ask monk about �似")
	    	local ts={
	           task_name="���ֽ�ѧ",
	           task_stepname="����ɮ",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  BigData:Auto_catchData()
      self:teach(roomno)
   end
   w:go(roomno)
end

function teachmonk:motou()

  wait.make(function()
    local l,w=wait.regexp("^(> |)Բ.*����������ܣ�һ�������(.*)��ȥ��$|^(> |)һ����������ֱ͸��Ķ��ǣ����ֵ��ʱ���Ѿ����ˡ�$",5)
	if l==nil then
	   self:motou()
	   return
	end
	if string.find(l,"һ����������ֱ͸��Ķ��ǣ����ֵ��ʱ���Ѿ�����") then
	      	local ts={
	           task_name="���ֽ�ѧ",
	           task_stepname="�¿���",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	    shutdown()
		self:jobDone()
	   return
	end
	if string.find(l,"һ�������") then
	    shutdown()

	    local place=w[2]
		local location="��ɽ����"..place

		  	local ts={
	           task_name="���ֽ�ѧ",
	           task_stepname="ħ����Ϯ",
	           task_step=4,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
		local n,rooms=Where(location)
	  if n>0 then
	    teachmonk.co=coroutine.create(function()
	        for _,r in ipairs(rooms) do
               local w
		       w=walk.new()
		       local al
		       al=alias.new()
		       al.do_jobing=true
		  --al.break_pfm=self.break_pfm
		       al.break_in_failure=function()
		          self:giveup()
		       end
		       al.out_songlin=function()
			      self.NextPoint=function()
				    print("���ָ̻�")
				     coroutine.resume(teachmonk.co)
			      end
			      al:finish()
		      end
		      al.songlin_check=function()
	             self.NextPoint=function() al:NextPoint() end
			     self:checkNPC("а��ħͷ",1764)
	     	  end
		      w.user_alias=al
		      w.noway=function()
		        self:NextPoint()
		      end
		      w.walkover=function()
		        self:checkNPC("а��ħͷ",r)
		      end
		      w:go(r)
		      coroutine.yield()
	       end
		     print("û���ҵ�npc!!")
		     self:giveup()
		 end)
	   else
	       print("û���ҵ�npc!!")
		   self:giveup()
	   end
	   self:recover()
	   return
    end
  end)
end

function teachmonk:giveup()
   print("����job����")
end

function teachmonk:run(i)
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

function teachmonk:flee(i)
  world.Send("go away")
  dangerous_man_list_add("а��ħͷ")
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

function teachmonk:combat_end()
end

function teachmonk:combat()
end

function teachmonk:checkPlace(npc,roomno,here)
   if is_contain(roomno,here) then
  	     print("�ȴ�0.8s,��һ������")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
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
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�")
				  coroutine.resume(songxin.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno)
		  end
		  w:go(roomno)
	   end
end

function teachmonk:checkNPC(npc,roomno)
   wait.make(function()
      world.Execute("look;set action ���")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������action \\= \\\"���\\\"$",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"�趨����������action") then
	      --û���ҵ�
		  print("Next �ص�")
		  local f=function(r)
		     self:checkPlace(npc,roomno,r)
		  end
		  WhereAmI(f,10000) --�ų����ڱ仯
		  return
	  end
	  if string.find(l,npc) then
	    	local ts={
	           task_name="���ֽ�ѧ",
	           task_stepname="����ħͷ",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	     print("�ҵ�Ŀ��")
		 self:wait_motou_die()
		 world.Send("kill mo tou")
	     --�ҵ�
          self:combat()
		  return
	  end
	  wait.time(6)
   end)
end

function teachmonk:wait_motou_die()
wait.make(function()
   local l,w=wait.regexp("^(> |)а��ħͷ��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)���ﲻ׼ս����$",5)
	 if l==nil then
	    self:wait_motou_die()
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
		self:motou_die()
	    return
	 end
	 if string.find(l,"���ﲻ׼ս��") then
	    self:jobDone()
		return
	 end
	 wait.time(5)
  end)
end

function teachmonk:NextPoint()
   --print("���ָ̻�:",coroutine.status(songxin.co))
   if teachmonk.co==nil or coroutine.status(teachmonk.co)=="dead" then
      self:giveup()
   else
      coroutine.resume(teachmonk.co)
   end
end

function teachmonk:cun(roomno)
   print("ɾ�������:",roomno)
   for i,r in ipairs(self.usedroom) do
      if r==roomno then
		 table.remove(self.usedroom,i)
	     break
	  end
   end
end

function teachmonk:teach(roomno)
 wait.make(function()
  world.Send("teach monk")

  local l=wait.regexp("^(> |)��������ѧʲô����.*$|^(> |)�����Ϊ���������أ�������ң���$|^(> |)�㻹����ȥ�����Ѵ�ʦ�����к��ɡ�$|^(> |)�㾡�Ľ�������Բ�ĺ���ָ���黨ָ�ĵ���$|^(> |)Բ.*����˵������������.*�����أ���$|^(> |)ʲô��$",3)
	if l==nil then
	   self:teach(roomno)
	   return
	end
	if string.find(l,"�㾡�Ľ�������Բ�ĺ���ָ���黨ָ�ĵ���") then
	   local f=function()
	     self:teach(roomno)
	   end
	   f_wait(f,0.8)
	   return
	end
	if string.find(l,"�����Ϊ����������") then
	   self:go_monk(roomno)
	   return
	end
	if string.find(l,"��������ѧʲô����") then
	   world.Send("ask monk about �似")
	   local f=function()
	     self:teach(roomno)
	   end
	   f_wait(f,0.5)
	   return
	end
	if string.find(l,"�㻹����ȥ�����Ѵ�ʦ�����к���") then
       self:Status_Check()
       return
	end
	if string.find(l,"������") then
	   print("���淿���!")
	   self:cun(roomno)
	   self:go_monk(roomno)
	   return
	end
	if string.find(l,"ʲô") then
	   self:go_monk(roomno)
	   return
	end
  end)
  --Բ������������ܣ�һ�����������ƺ��ȥ��      self:motou()
end

function teachmonk:jobDone()

end

function teachmonk:Status_Check()

	   	local ts={
	           task_name="���ֽ�ѧ",
	           task_stepname="�ָ�����",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

	 dangerous_man_list_clear("а��ħͷ")

     world.Send("yun refresh")
	 world.Send("yun recover")
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
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
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc.liaoshang_fail=function()
			   print("hs ����fail")
			   self:liaoshang_fail()
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
		    local x
			x=xiulian.new()
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
		         w:go(869)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
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
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end

