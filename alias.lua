require "wait"
alias={
   new=function()
     local al={}
	 setmetatable(al,alias)
	--[[ for i,v in pairs(self.alias_table) do
      local thread=self.alias_table[i]
	  if thread then
		--print("alias ����")
        self.alias_table[i]=nil
      end
    end]]

	 --setmetatable(al.self.alias_table, {__mode = "k"}) --weak table
	 al.id=string.sub(CreateGUID(),25,30)
	 al.alias_table={}
	 al:register()
	 --print("why2")
	 return al
   end,
   owner=nil,--���߶��� walk ��
  -- co=nil,
   weapon_exist=false,
   do_jobing=false,
   circle_co=nil,
   zishanlin_co=nil,
   id="",
   alias_table={},
   maze_step=nil,-- �Թ������ص�����
  break_in_count=0,
  version=1.8,
}
alias.__index=alias

function alias:SetSearchRooms(Rooms)
       --print("set")
    local dx=Get_Special(Rooms)
	for _,d in ipairs(dx) do
	   if self.alias_table[d]~=nil then
	      --print(d,"����")
	      self.alias_table[d].is_search=true
	   end
	end
end

function alias:redo(CallBack)
    print("·������Ĭ�Ϻ���")
	CallBack()
end

function alias:ATM_carry_silver(bank_roomno,CallBack,roomno)
  wait.make(function()
  world.Execute("i;set look")
   local l,w=wait.regexp("^(> |)(.*)������\\(Silver\\)|^(> |)�趨����������look \\= \\\"YES\\\"$",5)
   if l==nil then
	 self:ATM_carry_silver(bank_roomno,CallBack,roomno)
     return
   end
   if string.find(l,"������") then
      print(w[2])
	  local silver=ChineseNum(w[2])
	  if silver<99 then
	     local qu_silver=99-silver
	    local w=walk.new()
		w.walkover=function()
		   world.Send("qu "..qu_silver.." silver")
		   self:ATM_carry_silver(bank_roomno,CallBack,roomno)
		end
	    w:go(bank_roomno)
	  else
	    local w=walk.new()
		w.walkover=function()
	      CallBack()
		end
		w:go(roomno)
	  end
   end
   if string.find(l,"�趨����������look") then
        local w=walk.new()
		w.walkover=function()
		   world.Send("qu 99 silver")
		   self:ATM_carry_silver(bank_roomno,CallBack,roomno)
		end
	    w:go(bank_roomno)
      return
   end
   wait.time(5)
  end)
end

function alias:ATM(CallBack)
   print("ûǮ��,ȡ���������?")
--ȷ����ǰλ��
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --���ݵ�ǰλ�� ǰ�������Ǯׯ
--{���� 410} {���� 1474} {���� 50} {�ɶ� 546} {���� 1973} {���� 1069} {���� 1119} {���� 1331} {���� 926} {���ݳ�}
      local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	  local bank_roomno
	  local index=zone(_R.zone)
	  if index==1 then
	     bank_roomno=1331
	  elseif index==2 then
	     bank_roomno=1331
	  elseif index==3 or roomno[1]==767 then
	     bank_roomno=50
	  elseif index==4 then
	     bank_roomno=410
	  elseif index==5 or roomno[1]==1479 then
	     bank_roomno=1474
	  elseif index==6 then
	     bank_roomno=1973
	  else
	     bank_roomno=926
	  end
	  if roomno[1]==1573 then
	     bank_roomno=926
	  elseif roomno[1]==1574 then
	     bank_roomno=1973
	  end
	  print(bank_roomno," ����")
	  local b=busy.new()
	  b.interval=0.3
	  b.Next=function()
          self:ATM_carry_silver(bank_roomno,CallBack,roomno[1])
	  end
	  b:check()
   end
  _R:CatchStart()
--���� pay again
end

--��ȡ�������λ��

function alias:draw_special_direction(alias_name)
   --self:register()
   --print("alias_name:",alias_name)
   for _,a in ipairs(self.alias_table) do
	  if a.name==alias_name then
		return a.dir --���ػ���λ��
	  end
   end
   return nil
end

function alias:exec(alias_name)
   	--print("alias id3:",self.id,"  ",alias_name)
    --self:register()
	--print("ִ��")
	--	print("alias id4:",self.id,"  ",alias_name)
	--for _,a in ipairs(self.alias_table) do
	  --if a.name==alias_name then
	  --print("alias_name:",alias_name)
		local f=self.alias_table[alias_name].alias or nil--a.alias
		if f==nil then
		  print("δע��"..alias_name.." alias ����")
		  return
		end
		--print("alias id5:",self.id,"  ",alias_name)
		f()
		--print("alias id6:",self.id,"  ",alias_name)
		--break
	  --end
   --end
   --print("")
end

function alias:outboat(flag)
--�ɴ��͵�һ���Ѿ�����������˵������������´��ɣ���
--˵�Ž�һ��̤�Ű���ϵ̰����γ�һ����ȥ(out)�Ľ��ݡ�
  wait.make(function()
	local l,w=wait.regexp("^(> |)�ɴ��͵�һ���Ѿ�����������˵������������´��ɣ���$|^(> |)����˵���������ϰ��ɡ����漴��һ��̤�Ű���ϵ̰���$|^(> |)��������˵���������´��ɣ���ҲҪ��ȥ�ˡ���$",5)
	 if l==nil then
	    self:outboat(flag)
	    return
	 end
	 if string.find(l,"�ɴ��͵�һ���Ѿ�����") or string.find(l,"�������ϰ���") or string.find(l,"���´��ɣ���ҲҪ��ȥ��") then

	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()

		 world.Send("out")
        if flag==true then
		  world.Execute("east;east;west")
		end

		 self:finish()
	   end
	   b:check()
	    return
	 end

    wait.time(5)
  end)
end
--�������Ѿ���������������ָ�������Բ��ö��룬�Ų����߳����ֺ���

--һ�Ҷɴ�������ʻ�˹�����������һ��̤�Ű���ϵ̰����Ա�˿�����(enter)��
function alias:yellboat_wait(flag)
  if world.IsTrigger("beauty_place")==0 or world.IsTrigger("player_place")==0 or world.IsTrigger("robber_place")==0 or self.do_jobing==true then
     print("job ��")
	 world.Send("set ����")
  else
     print("��job ��")
     world.Send("unset ����")
  end
     world.Send("yun qi")
    local h=hp.new()
	h.checkover=function()
		if  h.neili<h.max_neili*1.9 and h.max_qi>=200 then
		 print("��ʼ������������")
		 if h.max_neili>=h.neili_limit then
		   world.Send("set ����")
		 end
		 local x=xiulian.new()
		 x.halt=false
		 x.safe_qi=100
		 x.min_amount=100
         x.fail=function(id)
	     if id==1 then
	     --��ѭ������
		  print("��ѭ������")
		  Send("yun recover")
		  x:dazuo()
	     end
	     if id==201 then
		  Send("yun recover")
	      world.Send("yun regenerate")
		  x:dazuo()
	     end
	     if id==202 then
		   print("�Ѿ��ڴ���")
		   return
		 end
         end
           x.success=function(h)
	          --if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then --����̫����
		        --print("��ѭ������ yellboat")
		        Send("yun recover")
		        x:dazuo()
	          --else
	          --  print("��������")
		      --  x:dazuo()
	         -- end
		   end
		   --print("�ȴ�����")
           x:dazuo()
		  local f=function()
	        print("���Խд�")
	        x.halt=true
	        local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:yellboat(flag)
			end
			b:check()
	      end
	      f_wait(f,5)
	   else
	      print("�������������")
		  local f=function()
		    self:yellboat(flag)
		  end
		  f_wait(f,2)
	   end
	end
	h:check()
end

function alias:boat_busy(flag)
   wait.make(function()
     local l,w=wait.regexp("^(> |).*�ɴ�\\\s*-\\\s*(out|)$|.*�ɴ�\\\s*-.*|^(> |)�趨����������look \\= \"YES\"$|^(> |)��������������ȴ�������ϴ���Ǯ�����ˡ�$",5)

	  if l==nil then
	     self:yellboat(flag)
		 return
	  end
	  if string.find(l,"�ɴ�") then
	     self:outboat(flag)
		 return
	  end
	  if string.find(l,"�趨����������look") then
		 self:yellboat_wait()
		 return
	  end
	  if string.find(l,"��������������ȴ�������ϴ���Ǯ������") then
	    local f=function()
		   self:yellboat(flag)
		end
        self:ATM(f)
		return
	  end
	  wait.time(5)
   end)
end

function alias:yellboat(flag)
   wait.make(function()

	  world.Send("yell boat")
	  world.Send("enter")
	  world.Send("look")
	  world.Send("set action �ϴ�")
	  --�ƺӶɴ� - out --
      local l,w=wait.regexp("^(> |).*�ɴ�\\\s*-\\\s*(out|)$|.*�ɴ�\\\s*-.*|^(> |)(��|��)����ԶԶ����һ�������ȵȰ���������ˡ�������$|^(> |)ֻ���ú��治Զ����������������������æ���š�����$|^(> |)�趨����������action \\= \\\"�ϴ�\\\"$",5)
	  if l==nil then
	    self:yellboat(flag)
	    return
	  end
	  if string.find(l,"�ɴ�") then
	     --BigData:Auto_catchData()
	     self:outboat(flag)
		 return
	  end
	  if string.find(l,"�ȵȰ�") or string.find(l,"ֻ���ú��治Զ����������") then
	     if flag==true then
	          local _R
               _R=Room.new()
               _R.CatchEnd=function()
                  if _R.roomname=="�����ϰ�" or _R.roomname=="��������" then
				      if _R.exits=="east;south;west;" or _R.exits=="east;north;west;" then
					      local dx="west"
					      world.Execute(dx)
						  self:yellboat(flag)
					  elseif _R.exits=="east;" then
						  local dx="east;east"
						  world.Execute(dx)
						  self:yellboat(flag)
                      elseif _R.exits=="west;" then
					      local dx="west"
						   world.Execute(dx)
						  self:yellboat_wait(flag)
					  else
						  self:yellboat(flag)
					  end
				  else
				      self:yellboat_wait()
				  end
			   end
               _R:CatchStart()
		 else
	        self:boat_busy()
		 end
	     return
	  end
	  if string.find(l,"�趨����������action") then --�����쳣
	    self:finish()
	    return
	  end

	  wait.time(2)
   end)
end

function alias:dujiang_wait()
  if world.IsTrigger("beauty_place")==0 or world.IsTrigger("player_place")==0 or world.IsTrigger("robber_place")==0 or self.do_jobing==true then
     print("job ��")
	 world.Send("set ����")
  else
     print("�� job")
	 world.Send("unset ����")
  end
    world.Send("yun qi")
    local h=hp.new()
	h.checkover=function()
	  if  h.neili<h.max_neili*1.9 and h.max_qi>=200 then
		 print("��ʼ������������")
		 if h.max_neili>=h.neili_limit then
		   world.Send("set ����")
		 end
		 local x=xiulian.new()
		 x.halt=false
		 x.safe_qi=10
		 x.min_amount=100
         x.fail=function(id)
	      if id==1 then
	     --��ѭ������
		  print("��ѭ������")
		  Send("yun recover")
		  x:dazuo()
	      end
	      if id==201 then
		    if h.jingxue_percent>=80 then
		      world.Send("yun recover")
	          world.Send("yun regenerate")
		       x:dazuo()
		   --self:dujiang_now(x)
		     else
		       print("����̫���޷�����")
		       local f=function()
		           self:dujiang()
			   end
		      local _R
               _R=Room.new()
               _R.CatchEnd=function()
                  if _R.roomname=="�����ϰ�" or _R.roomname=="��������" then
				      if _R.exits=="east;south;west;" or _R.exits=="east;north;west;" then
					      local dx="west"
					      world.Execute(dx)
					  elseif _R.exits=="east;" or _R.exits=="east;enter;" then
						  local dx="e;e"
						  world.Execute(dx)
                      elseif _R.exits=="west;" or _R.exits=="enter;west;" then
					      local dx="w"
						   world.Execute(dx)
					  else
						  local dx="e;e"
						  world.Execute(dx)
					  end

					  f_wait(f,1)

				  else
				      f_wait(f,1)
				  end
			   end
               _R:CatchStart()
			 end
	      end
	      if id==202 then
           print("�ϴ���")
		   return
          end
		 end
           x.success=function(h)
	          --if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then --����̫����
			    if x.halt==false then
		          print("��ѭ������ dujiang")
		          Send("yun recover")
		          x:dazuo()
				else
				  print("dujiang ����")
				end
	          --else
	          --  print("��������")
		      --  x:dazuo()
	         -- end
		   end
           x:dazuo()
		   self:dujiang_now(x)
	   else
	      print("�������������")
		  local f=function()
		    self:dujiang()
		  end
		   local _R
               _R=Room.new()
               _R.CatchEnd=function()
                  if _R.roomname=="�����ϰ�" or _R.roomname=="��������" then
				      if _R.exits=="east;south;west;" or _R.exits=="east;north;west;" then
					      local dx="west"
					      world.Execute(dx)
					  elseif _R.exits=="east;" or _R.exits=="east;enter;" then
						  local dx="e;e"
						  world.Execute(dx)
                      elseif _R.exits=="west;" or _R.exits=="enter;west;" then
					      local dx="w"
						   world.Execute(dx)
					  else
						  local dx="e;e"
						  world.Execute(dx)
					  end

					  f_wait(f,1)

				  else
				      f_wait(f,1)
				  end
			   end
               _R:CatchStart()

	   end
	end
	h:check()
end

function alias:duhe_now(x)

	print("����ɽ���⣡")
   wait.make(function()
     local l,w=wait.regexp("���˽�������Ʒ|����ƮƮ",7)
	 if l==nil then
	 	 	print("ʱ�䵽�����Զɽ���")
			x.halt=true
			x:clear()
		 	local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:duhe()
			end
			b:check()
	    return
	 end
	 if string.find(l,"���˽�������Ʒ") or string.find(l,"����ƮƮ") then
	        x.halt=true
			x:clear()
	 	 	print("���˶ɽ����Ͽ���ϣ�")
		 	local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:duhe()
			end
			b:check()
	    return
	 end
	 wait.time(10)
   end)
end


function alias:dujiang_now(x)

	print("����ɽ���⣡")
   wait.make(function()
     local l,w=wait.regexp("���˽�������Ʒ|����ƮƮ",7)
	 if l==nil then
	        x:clear()
			x.halt=true
	 	 	print("ʱ�䵽�����Զɽ���")
		 	local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:dujiang()
			end
			b:check()
	    return
	 end
	 if string.find(l,"���˽�������Ʒ") or string.find(l,"����ƮƮ") then
	 	 	print("���˶ɽ����Ͽ���ϣ�")
			x:clear()
			 x.halt=true
		 	local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:dujiang()
			end
			b:check()
	    return
	 end
	 wait.time(10)
   end)
end
--> ��ʹ����һέ�ɽ����ɹ��˺�ˮ��
--> ��һ����Ϣ����׼�˽��жɴ�λ�ã�ʹ����һέ�ɽ����Ṧ��Ҫ��Խ������
function alias:dujiang()
   wait.make(function()
	  world.Send("dujiang")
      local l,w=wait.regexp("^(> |)���ڽ��жɴ�������һ�㣬������������.*��$|^(> |)��ʹ����һέ�ɽ����ɹ���.*��$|^(> |)�����Ϊ������$|(> |)�����ˮ̫��̫������ɲ���ȥ��$|^(> |)���������Ϊ����������֧�֣���|^(> |)�㻹��������ȴ�������������ˡ�$|^(> |)������������ˣ�$|^(> |)��ľ��������ˣ�$|^(> |)����̫���ˣ����û����;�����ĵط�����û����Խ��ȥ��$|^(> |)�д������������Cool����$|^(> |)��һ����Ϣ����׼�˽��жɴ�λ�ã�ʹ����һέ�ɽ����Ṧ��Ҫ��Խ������$|^(> |)������һ��������ͷ�������������������԰���Զ��ֻ���������ˣ�$|^(> |)����Ҫ����Ծ����ͻȻС��һ�ۣ�����ͨ��һ��������ˮ֮�У�̧��ͷ�ŷ����Ǵ��ϴ��ø��ӽ���ɨ�´���.*$",5)
	  if l==nil then
	    print("�ɽ���ʱ����")
	    self:finish()
	    return
	  end

	  if string.find(l,"ʹ����һέ�ɽ���") or string.find(l,"���ڽ��жɴ�������һ�㣬������������") then
	     --BigData:Auto_catchData()
	     local b
		 b=busy.new()
		 b.interval=0.9
		 b.Next=function()
		   if string.find(l,"����") then
		     world.Execute("e;e;w")
		   end
	       self:finish()
		 end
		 b:check()
		 return
	  end
	  if string.find(l,"��ľ���������") then
		 world.Send("yun refresh")
		 local h=hp.new()
		 h.checkover=function()
		    if h.max_jingli>=1800 then
		      local f=function() self:dujiang() end
		      f_wait(f,0.8)
			else
 			  self:yellboat(true)
			end
		 end
		 h:check()
		 return
	  end
	  if string.find(l,"������һ��������ͷ����") or string.find(l,"����Ҫ����Ծ����ͻȻС��һ��") then
		 local b
		 b=busy.new()
		 b.interval=0.9
		 b.Next=function()
	       self:dujiang()
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"�������������") or string.find(l,"�����Ϊ����") or string.find(l,"�����ˮ̫��̫������ɲ���ȥ") or string.find(l,"���������Ϊ����������֧��") then
         self:yellboat(true)
		 return
	  end
	  if string.find(l,"����̫����") or string.find(l,"�д�����") then
	     self:dujiang_wait()
	     return
	  end
	  if string.find(l,"�㻹��������ȴ��������������") or string.find(l,"̧��ͷ�ŷ����Ǵ��ϴ��ø��ӽ���ɨ�´���") then
	     self:outboat()
	     return
	  end
	  --[[if string.find(l,"ʲô") then
	    print("�����쳣")
		self:finish()
		return
	  end
	  wait.time(2)]]
   end)
end

function alias:finish() --�ص�����
   print("Ĭ�ϻص�����")
end


function alias:xzl_gb() --ؤ��������
--n;e;n;w;n;e;n;w;n 996
   print("ؤ��������")
   --world.Execute("north;east;north;west;north;east;north;west;north")
   --self:finish()

      local p={"north","east","north","west","north","east","north","west","north"}
   alias.circle_co=coroutine.create(function()
      --print("����3")
      for _,i in ipairs(p) do
	     world.Send(i)
         self:circle_done("xzl_gb")
	     coroutine.yield()
	  end
	  self:finish()
   end)
  --print("����2")
   coroutine.resume(alias.circle_co)
end

function alias:opendoornorthup()
   world.Send("open door")
   world.Send("northup")
   self:finish()
end

function alias:opendoorsouthdown()
   world.Send("open door")
   world.Send("southdown")
   self:finish()
end

function alias:opendoornorth()
   world.Send("open door")
   world.Send("north")
   self:finish()
end

function alias:opendoorout()
   world.Send("open door")
   world.Send("out")
   self:finish()
end

function alias:opendoorsouth()
   world.Send("open door")
   world.Send("south")
   self:finish()
end

function alias:opendoorwest()
   world.Send("open door")
   world.Send("west")
   self:finish()
end

function alias:opendooreast()
   world.Send("open door")
   world.Send("east")
   self:finish()
end

function alias:get_range(alias_name)
   --self:register()
   --print(alias_name)
   for _,i in ipairs(self.alias_table) do
       if i.name==alias_name then
	      --print(i.name)
	      if i.range==nil then
		    return 1
		  else
	        return i.range
		  end
	   end
   end
   return 1
end

function alias:fengyun()
   world.Send("fengyun")
   self:finish()
end

function alias:longhu()
   world.Send("longhu")
   self:finish()
end

function alias:tiandi()
   world.Send("tiandi")
   self:finish()
end

function alias:qingyunpin_fumoquan()
   world.Send("enter")
   self:finish()
end

function alias:nanjiangshamo_tuyuhun()

    world.Execute("east;east;east;east;east;east;")
	wait.make(function()
	   local l,w=wait.regexp("^(> |)���Ѿ��е������ˣ�ڤڤ����������˽���̧�˳�����$",2)
	   if l==nil then
		  self:nanjiangshamo_tuyuhun()
		  return
	   end
	   if string.find(l,"ڤڤ����������˽���̧�˳���") then
	      wait.time(8)
	      self:finish()
	      return
	   end

	end)
end

function alias:female_south()
   local gender=world.GetVariable("gender") or ""
   if gender=="����" then
      self:noway()
	else
	  world.Send("south")
	  self:finish()
   end
end

function alias:d_west()

	local b=busy.new()
	 b.interval=0.9
	b.Next=function()
	   world.Send("west")
      self:finish()
	end
	b:check()
end

function alias:baizhangjian_south()--���ɽ�
    world.Send("drop tielian")
	world.Send("south")
	self:finish()
end

function alias:noway()
  print("Ĭ��alias noway����")
  self:finish()
end

local function dx_serial(dx)
   local index=1
   return function()
      if index>table.getn(dx) then
		index=1
	  end
	  local d=dx[index]
	  index=index+1
	  return d
   end
end

function alias:tou_conglin()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2665 then
	   self:finish()
	 elseif roomno[1]==2664 then
	    world.Send("tou conglin")
		self:tou_conglin()
	 else
	    local f=function()
           local w
		   w=walk.new()
		   w.walkover=function()
		      self:tou_conglin()
		   end
		   w:go(2664)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:ll_sl(d)  --����ɽ·
--��������
--һֱn;w;s;e�Ϳɳ���
--1124
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1124 then
	   self:finish()
	 elseif roomno[1]==1123 then
	   if d==nil then
	    local dx={"north","west","south","east"}
	    d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         self:ll_sl(d)
	   end
	   f_wait(f,0.2)
	 else
        local f=function()
		  local w
	   	  w=walk.new()
	 	  w.walkover=function()
		   self:ll_sl()
		  end
		  w:go(1123)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:duhe_wait()

  if world.IsTrigger("beauty_place")==0 or world.IsTrigger("player_place")==0 or world.IsTrigger("robber_place")==0 or self.do_jobing==true then
     print("job �� ")
	 world.Send("set ����")
  else
     print("��job")
     world.Send("unset ����")
  end
 local h=hp.new()
	h.checkover=function()
	   if  h.neili<h.max_neili*1.9 and h.max_qi>=200 then
		 print("�ɺ� ��ʼ������������")
		 if h.max_neili>=h.neili_limit then
		   world.Send("set ����")
		 end
		 local x=xiulian.new()
		 x.safe_qi=100
		 x.min_amount=10
		 x.halt=false
         x.fail=function(id)
	     if id==1 then
	     --��ѭ������
		  print("��ѭ������")
		  Send("yun recover")
		  x:dazuo()
		  return
	     end
	     if id==201  then
		  if h.jingxue_percent>=80 then
		    world.Send("yun recover")
	        world.Send("yun regenerate")
		    x:dazuo()
		  --self:duhe_now(x)
		  else
		    print("����̫��!")
		    local f=function()
		       self:duhe()
		    end
		    f_wait(f,2)
		  end
	     end
	     if id==202 then
	        print("�ϴ���")
			return
         end
		 end
           x.success=function(h)
	          --if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then --����̫���� sleep �ָ�
			  if x.halt==false then
		        print("��ѭ������ duhe")
		        Send("yun recover")
		        x:dazuo()
			  else
				print("duhe ����")
			  end
	          --else
	          --  print("��������")
		      --  x:dazuo()
	          --end
		   end
           x:dazuo()
		   self:duhe_now(x)
	   else
	      print("�������������")
		  local f=function()
		    self:duhe()
		  end
		  f_wait(f,2)
	   end
	end
	h:check()
end

function alias:duhe()
  wait.make(function()
	  world.Send("duhe")--���ں��жɴ�������һ�㣬������������������
      local l,w=wait.regexp("(> |)��ʹ����һέ�ɽ����ɹ���.*��$|^(> |)����.*�жɴ�������һ�㣬������������.*��|^(> |)�����Ϊ������$|(> |)�����ˮ̫��̫������ɲ���ȥ��$|^(> |)���������Ϊ����������֧�֣���|^(> |)�㻹��������ȴ�������������ˡ�$|^(> |)������������ˣ�$|^(> |)��ľ��������ˣ�$|^(> |)����̫���ˣ����û����;�����ĵط�����û����Խ��ȥ��$|^(> |)����̫���ˣ����û����;�����ĵط�����û����Խ��ȥ��$|^(> |)�д������������Cool����$",5)
	  if l==nil then
	    self:finish()
	    return
	  end

	  if string.find(l,"��ʹ����һέ�ɽ���") or string.find(l,"�ɴ�������һ��") then
	     --BigData:Auto_catchData()
	     local b
		 b=busy.new()
		 b.interval=0.9
		 b.Next=function()
	       self:finish()
		 end
		 b:check()
		 return
	  end --����̫���ˣ����û����;�����ĵط�����û����Խ��ȥ��
	  if string.find(l,"�����Ϊ����") or string.find(l,"�����ˮ̫��̫������ɲ���ȥ") or string.find(l,"���������Ϊ����������֧��") or string.find(l,"�������������") then
         self:yellboat()
		 return
	  end
	  if string.find(l,"�㻹��������ȴ��������������") then
	     print("��������")
	     self:outboat()
		 return
	  end
	  if string.find(l,"��ľ���������") then
	     world.Send("yun refresh")
		 local h=hp.new()
		 h.checkover=function()
		    if h.max_jingli>=1400 then
		      local f=function() self:duhe() end
		      f_wait(f,0.8)
			else
 			  self:yellboat()
			end
		 end
		 h:check()
		 return
	  end
	  if string.find(l,"��;�����ĵط�����û����Խ��ȥ") or string.find(l,"�д�����") then
	     self:duhe_wait()
	     return
	  end
	 --[[if string.find(l,"ʲô") then
	    print("�����쳣")
		self:finish()
		return
	  end
	  wait.time(5)]]
   end)
end

function alias:dutan()
  wait.make(function()
	  world.Send("dutan")
      local l,w=wait.regexp("(> |)��ʹ����һέ�ɽ����ɹ���.*��$|^(> |)�����Ϊ������$|(> |)�����ˮ̫��̫������ɲ���ȥ��$|^(> |)ʲô.*$|^(> |)���������Ϊ����������֧�֣���",5)
	  if l==nil then
	    self:dutan()
	    return
	  end

	   if string.find(l,"��ʹ����һέ�ɽ���") then
	     local b
		 b=busy.new()
		 b.interval=0.3
		 b.Next=function()
	       self:finish()
		 end
		 b:check()
		 return
	  end
	  if string.find(l,"�����Ϊ����") or string.find(l,"�����ˮ̫��̫������ɲ���ȥ") or string.find(l,"���������Ϊ����������֧��") then
         self:yellboat()
		 return
	  end
	  if string.find(l,"ʲô") then
	    print("�����쳣")
		self:finish()
		return
	  end
	  wait.time(5)
   end)
end

--shulin_shendiao �������� ����� n;s;n;n  1496- 1601
-- 1495- 1497 ֱ�Ӵ�Խ
function alias:shanlu1_shanlu2()
   world.Send("north")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1497 then
	   self:finish()
	 elseif roomno[1]==1496 or roomno[1]==1602 then
	    self.maze_step=function()
		    local _al=alias.new()
	        _al.finish=function()
	           world.Send("north")
		       self:finish()
			end
	        _al:shulin_shendiao()
		end
		if self.alias_table["shanlu_shanlu2"].is_search==true then

	       self:maze_done()
		else
		   self.maze_step()
		end

     else
	      local f=function()
		    local w
	    	w=walk.new()
		    w.walkover=function()
		      self:finish()
		    end
		    w:go(1497)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--1497 -1495
----
-- �������� n;s;n;n��������n;s;n;s;s;n;w;n;s;s
--
function alias:shanlu2_shanlu1()
   world.Send("south")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1495 or roomno[1]==1497 then
	   self:finish()
	 elseif roomno[1]==1496 or roomno[1]==1601 then
	   self.maze_step=function()
	        local _al=alias.new()
	        _al.finish=function()
	         world.Send("south")
		     self:finish()
	       end
	       _al:shulin_kongdi()
	   end
	   if self.alias_table["shanlu2_shanlu1"].is_search==true then
	     self:maze_done()
	   else
		  self.maze_step()
	   end

	 else
	      local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:finish()
		end
		w:go(1495)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--�����ֳ���

function alias:xiangyangshulin_circle()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1601 then
	    local p={"south","south","north","north","east","north","east","west","south","north"}

        alias.circle_co=coroutine.create(function()

          for _,i in ipairs(p) do
	         world.Send(i)
              self:circle_done("xiangyangshulin_circle")
	         coroutine.yield()
	      end
	      self:finish()
       end)
	   coroutine.resume(alias.circle_co)
	 elseif roomno[1]==1496  then

		local dx={"north","east","south","west"}
	   local i=math.random(4)
	   local d=dx[i]
	   world.Send(d)
	   --print("ִ��2")
	   self.maze_step=function()
	     --print("ִ��")
	      local f=function()
            self:xiangyangshulin_circle()
	      end
	      f_wait(f,0.2)
	   end
	    --print("ִ��2222")
	   --print(self.alias_table["xiangyangshulin_circle"].is_search)

	   if self.alias_table["xiangyangshulin_circle"].is_search==true then
        --print("ִ��4")
		self:maze_done()
	   else
	      -- print("ִ��3")
	      self.maze_step()
	   end
	 elseif roomno[1]==1602 then
	   --1602 shulin1 s
	   --1601 shulin8 n
--world.Execute("n;e;n;e;w;s;n")
		local p={"north","east","north","east","west","south","north","south","south","north"}
		 alias.circle_co=coroutine.create(function()
          for _,i in ipairs(p) do
	         world.Send(i)
              self:circle_done("xiangyangshulin_circle")
	         coroutine.yield()
	      end
	      self:finish()
       end)
	    coroutine.resume(alias.circle_co)
	 else
        local f=function() local w
		w=walk.new()
		w.walkover=function()
		   self:xiangyangshulin_circle()
		end
		w:go(1496)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()

end

function alias:shulin_shendiao()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1601 then
	   self:finish()
	 elseif roomno[1]==1496  then

		local dx={"north","south","north","north"}
	   local i=math.random(4)
	   local d=dx[i]
	   world.Send(d)
	   self.maze_step=function()
	      local f=function()
            self:shulin_shendiao(d)
	      end
	      f_wait(f,0.2)
	   end
	   if self.alias_table["shulin_shendiao"].is_search==true then
	     self:maze_done()
	   else
	      self.maze_step()
	   end
	 elseif roomno[1]==1602 then
	   --1602 shulin1 s
	   --1601 shulin8 n
	    world.Execute("n;e;n;e;w;s;n")

		self:shulin_shendiao()
	 else
        local f=function() local w
		w=walk.new()
		w.walkover=function()
		   self:shulin_shendiao()
		end
		w:go(1496)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--shulin_kongdi ��񴦵��յ� n;s;n;s;s;n;w;n;s;s  1496 - 1602
function alias:shulin_kongdi()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1602 then
	   self:finish()
	 elseif roomno[1]==1496 then
       local dx={"north","south","north","north"}
	   local i=math.random(4)
	   local d=dx[i]
	   world.Send(d)
	   self.maze_step=function()
	     local f=function()

           self:shulin_kongdi()
	     end
	     f_wait(f,0.2)
	   end
	   if self.alias_table["shulin_kongdi"].is_search==true then
	     self:maze_done()
	   else
	     self.maze_step()
	   end
	 elseif roomno[1]==1601 then
		world.Execute("s;s;n") --shulin8
		--world.Send("south") --shulin9
	    --world.Send("north") --shulin10
		--world.Send("south")
		self:shulin_kongdi()
	 else
        local f=function()
		 local w
		 w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:shulin_kongdi()
		 end
		 w:go(1496)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--caidi_cunzhongxin ��ɽ�˵� �� ������
function alias:caidi_cunzhongxin()
--��������һͨ����Ȼ�����Լ��߻���ԭ�ء�
--�������û�г�·��
--��Ķ�����û����ɣ������ƶ���
--print("����")
 world.Send("n")
  wait.make(function()


	 local l,w=wait.regexp("^(> |)�˵� \\- .*$|^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)��������һͨ����Ȼ�����Լ��߻���ԭ�ء�$|^(> |)�������û�г�·��$",5)
	 if l==nil then
        --print("test3")
	    self:caidi_cunzhongxin()
	    return
	 end
	 if string.find(l,"��Ķ�����û�����") then
	   --print("test")
	    wait.time(0.3)
		self:caidi_cunzhongxin()
		return
	 end
     if string.find(l,"��Ȼ�����Լ��߻���ԭ��") then
	    self:finish()
	    return
	 end
     if string.find(l,"�������û�г�·") then
        local f=function()
	      local w
		 w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:finish()
		 end
		 w:go(651) end
		 self:redo(f)
		return
	 end
     if string.find(l,"�˵�") then
	    --print("test2")
		wait.time(0.3)
		self:caidi_cunzhongxin()

        return

	 end

 end)
end

--songlin_shanjiao
--���������ֺ�s;e;s;Ȼ����n;#4 e�ҵ������壬��Ϊ�µ����ڵ�������䶯�ģ��������һ�β��о���#4 n;e��һ�Σ���಻�ᳬ��6�Ρ��ҵ����������w;s�͵���ɽ�����ˡ�
function alias:songlin_shanjiao()
--print("why")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3095 then
	   self:finish()
	 elseif roomno[1]==956 then
	   --[[local f=function()
	     world.Execute("north;east;east;east;east;east")
		 wait.time(0.3)
		 world.Execute("north;north;north;north;east")
		 wait.time(0.3)
		 world.Execute("north;north;north;north;east")
         self:songlin_shanjiao()
	   end
	   f_wait(f,0.2)]]
		local p={"north","east","east","east","east","north","north","north","north","east"}
         alias.circle_co=coroutine.create(function()
        --print("����3")
        for _,i in ipairs(p) do
	       world.Send(i)
		   print("�����ֱ���:",i)
           self:circle_done("songlin_shanjiao")
	       coroutine.yield()
	    end
	     self:songlin_shanjiao()
       end)
       coroutine.resume(alias.circle_co)



	 elseif roomno[1]==1508 then
		world.Send("west")
		self:finish()
	 else
	      local f=function()
          local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:songlin_shanjiao()
		end
		w:go(956)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:tiao()
   world.Send("tiao gou")
   self:finish()
end

function alias:tiaodown()
   world.Send("tiao down")
   self:finish()
end

function alias:pullgatesouthdown()

   --�������İ�����һ�۵��������Ѿ������㻹�ã�
   --[[���ߵ���ǰ������ؿ��������Ż���
> ֨��һ���������￪�ˡ�

��ɣ�����˳�����
��ɣ��˵������λС�ֵܹ��ٴ�����,���������]]
   wait.make(function()
      world.Send("pull gate")
	  local l,w=wait.regexp("^(> |)���Ѿ��ǿ��ŵģ�$|^(> |)�㽫����������$|^(> |)ʲô.*",5)
      if l==nil then
	     self:pullgatesouthdown()
	     return
	  end
	  if string.find(l,"�㽫��������") or string.find(l,"���Ѿ��ǿ��ŵ�") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("southdown")
		  self:finish()
		end
		b:check()
		return
	  end
	  if string.find(l,"ʲô") then
	    self:finish()
	    return
	  end
	  wait.time(5)
   end)
end

function alias:opengateenter()
  world.Send("knock gate")
  local f=function()
   world.Execute("open gate;enter")
   self:finish()
  end
  f_wait(f,1)
end

function alias:opengateout()
   world.Execute("open gate;out")
   self:finish()
end

function alias:opengatesouth()

   --�������İ�����һ�۵��������Ѿ������㻹�ã�
   --[[���ߵ���ǰ������ؿ��������Ż���
> ֨��һ���������￪�ˡ�

��ɣ�����˳�����
��ɣ��˵������λС�ֵܹ��ٴ�����,���������]]
   wait.make(function()
      world.Send("open gate")
	  local l,w=wait.regexp("^(> |)�����Ѿ��ǿ����ˡ�$|^(> |)��ʹ���Ѵ��Ŵ��˿�����$|^(> |)ʲô.*",5)
      if l==nil then
	     self:opengatesouth()
	     return
	  end
	  if string.find(l,"���Ŵ��˿���") or string.find(l,"�����Ѿ��ǿ�����") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("south")
		  self:finish()
		end
		b:check()
		return
	  end
	  if string.find(l,"ʲô") then
	    self:finish()
	    return
	  end
	  wait.time(5)

   end)
end

function alias:opengatenorth()

   --�������İ�����һ�۵��������Ѿ������㻹�ã�
   --[[���ߵ���ǰ������ؿ��������Ż���
> ֨��һ���������￪�ˡ�

��ɣ�����˳�����
��ɣ��˵������λС�ֵܹ��ٴ�����,���������]]
   wait.make(function()
      world.Send("open gate")
	  local l,w=wait.regexp("^(> |)�����Ѿ��ǿ����ˡ�$|^(> |)��ʹ���Ѵ��Ŵ��˿�����$|^(> |)ʲô.*",5)
      if l==nil then
	     self:opengatenorth()
	     return
	  end
	  if string.find(l,"���Ŵ��˿���") or string.find(l,"�����Ѿ��ǿ�����") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("north")
		  self:finish()
		end
		b:check()
		return
	  end
	  if string.find(l,"ʲô") then
	    self:finish()
	    return
	  end
	  wait.time(5)
   end)
end

function alias:dalunsishanmen_dianqianguangchang()
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1669  then
	    self:knockgatenorthup()
	 else

        local f=function()
		local w
		w=walk.new()
		w.walkover=function()
		   self:dalunsishanmen_dianqianguangchang()
		end
		w:go(1669)
		end
		 self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:knockgatenorthup()

   wait.make(function()
      world.Send("knock gate")
	  local l,w=wait.regexp("^(> |)֨��һ���������￪�ˡ�$|^(> |).*������һ�۵��������Ѿ������㻹�ã�$|(> |)��ͻȻ����ԭ�����ǿ��ŵģ�ֱ�ӽ�ȥ�����ˡ�$",5)
      if l==nil then
	     self:knockgatenorthup()
	     return
	  end
	  if string.find(l,"֨��һ���������￪��") or string.find(l,"���Ѿ������㻹��") or string.find(l,"��ͻȻ����ԭ�����ǿ��ŵģ�ֱ�ӽ�ȥ������") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("northup")
		  self:finish()
		end
		b:check()
		return
	  end
	  wait.time(5)

   end)
end

function alias:knockgatenorth()
	world.Send("knock gate")
	world.Send("north")
	local _R
	 _R=Room.new()
	_R.CatchEnd=function()
		local count,roomno=Locate(_R)
	      print("��ǰ�����",roomno[1])
	        if roomno[1]==780 then
	          self:finish()
	        elseif roomno[1]==781 then
	          self:knockgatenorth()
			else
			  local f=function()
			  local w
			  w=walk.new()
			  w.walkover=function()
			     self:knockgatenorth()
			  end
			  w:go(781)
			  end
			  self:redo(f)
	        end
	end
	_R:CatchStart()
end

function alias:knockgatesouth()
   wait.make(function()
      world.Send("knock gate")
	  local l,w=wait.regexp("^(> |)�������Ż�����������ߵ��ߵ��֨��һ����һλɮ�˴򿪴�����������Ŀ�����´������㡣$|^(> |)��Ҫ��˭�����������$|^(> |)֨��һ���������￪�ˡ�$|^(> |).*������һ�۵��������Ѿ������㻹�ã�$",10)
      if l==nil then
	     self:knockgatesouth()
	     return
	  end
	  if string.find(l,"֨��һ��") or string.find(l,"���Ѿ������㻹��") or string.find(l,"һλɮ�˴򿪴�����������Ŀ�����´�������") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("south")
		  self:finish()
		end
		b:check()
		return
	  end

	  if string.find(l,"��Ҫ��˭���������") then
		  world.Send("south")
	      local _R
          _R=Room.new()
          _R.CatchEnd=function()
          local count,roomno=Locate(_R)
	      print("��ǰ�����",roomno[1])
	        if roomno[1]==1894 then
	          self:finish()
	        elseif roomno[1]==1887 then
	          self:knockgatesouth()
			else

			  local f=function()
			  local w
			  w=walk.new()
			  w.walkover=function()
			     self:knockgatesouth()
			  end
			  w:go(1887)
			  end
			  self:redo(f)
	        end
         end
        _R:CatchStart()
	     return
	  end
	  wait.time(10)

   end)
end
--[[���ɳĮ
#10 w s�����о� quit and relogin��Ȼ����#10 s��һֱ������Ϊֹ��ע�����enter�ĵط���Ҫ��ȥ��������autokill��÷����������硣]]
--631 1705
function alias:shamo_quick_qingcheng()
  world.Execute("w;#10 s;")
  local f2=function()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==630 then
	   self:finish()
	 elseif roomno[1]==1705 or roomno[1]==631 then

	   local f=function()
	     --world.Send(d())
         self:shamo_quick_qingcheng()
	   end
	   f_wait(f,0.1)
	 else
	    local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:shamo_quick_qingcheng()
		end
		w:go(630)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
  end
  f_wait(f2,0.3)
end

function alias:shamo_qingcheng(d)
   self:shamo_quick_qingcheng()
 --[[
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==630 then
	   self:finish()
	 elseif roomno[1]==1705 or roomno[1]==631 then
	   if d==nil then
	     local dx={"north","north","north","north","north","south","south","south","south","south","west","west","west","west","west","west","west","west","west","west","south"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         self:shamo_qingcheng(d)
	   end
	   f_wait(f,0.3)
	 else
	    local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:shamo_qingcheng()
		end
		w:go(630)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]
end
--649 - 1706
function alias:heilin_gumu(d)
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1706  then
	   self:finish()
	 elseif roomno[1]==649 then
	   if d==nil then
	     local dx={"east"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         self:heilin_gumu(d)
	   end
	   f_wait(f,0.3)
	 else
	  local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:heilin_gumu()
		end
		w:go(649)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--649 - 648
function alias:heilin_shulin(d)
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==648  then
	   self:finish()
	 elseif roomno[1]==649 then
	   if d==nil then
	     local dx={"west"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         self:heilin_shulin(d)
	   end
	   f_wait(f,0.3)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:heilin_shulin()
		end
		w:go(649)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:gudelin_bailongdong(d)
--[[ 1708
jump zhuang
��������÷��׮��
÷��׮ - down
������������]]
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1709  then
	   self:finish()
	 elseif roomno[1]==1710 then

		world.Send("down")
		self:gudelin_bailongdong()
	 elseif roomno[1]==1708 then
	   if d==nil then
	     local dx={"west","south","east","north"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
		 world.Send("jump zhuang")
         self:gudelin_bailongdong(d)
	   end
	   f_wait(f,0.3)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:gudelin_bailongdong()
		end
		w:go(1708)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

--use fire;e;w;n;s;nw;se;ne;sw;out
function alias:jiulaodong_zhouzhiruo()
	world.Execute("use fire;e;w;n;s;nw;se;ne;sw;out")
	self:finish()
end

function alias:leave()
   world.Execute("use fire;leave;leave;leave")
   self:finish()
end

function alias:t_leave()
    world.Send("leave")
	local b=busy.new()
	b.Next=function()
      self:finish()
	end
	b:check()
end

function alias:push_huan()
    world.Send("knock huan")
    world.Send("push huan")
	world.Send("enter")
	local b=busy.new()
	b.Next=function()
      self:finish()
	end
	b:check()
end


--[[���������ɼ���Ժ�ǧ��Ҫ��ne��nw ����ֻҪ��se����������������Σ����߲�������������һ��sw,Ȼ��se...�Ϳ��Գ����ˡ�
������ߵ�С���֣����������Ļ�����赹�ġ�����û��Σ�գ�����С�����Ժ�ֻҪһֱ�����ߣ��ͻ���ʾ:"ͻȻһ������������˱Ƕ�������ֻ����һ��ͷ��Ŀѣ......������Լ��Ѿ�����������֮�У��������ֽ��Ѿ�����ʹ���ˡ�����ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪����...."�����ѹ�����ֻҪ�ظ�����Ĳ���Ϳ����ˡ�



������������
ȥ--e;w;e;s;e;n;n;e;w;s ��--w;e;n;e;s;n;e;w;s  ]]

function alias:unwield_northup()
   local sp=special_item.new()
	sp.cooldown=function()
     world.Send("northup")
	 local shield=world.GetVariable("shield") or ""
	 if shield~="" then
	   world.Execute(shield)
	 end
     self:finish()
   end
   sp:unwield_all()
end

function alias:NextPoint()
   coroutine.resume(alias.co)
end

function alias:songlin_check()  --�������
   --print("���ָ̻� alias")
   self.maze_step=function()
     local f=function()
       self:NextPoint()  --Ĭ�ϻص�����
     end
     f_wait(f,0.1)
   end
   if self.alias_table["songlin_check"].is_search==true then
     self:maze_done()
   else
      self.maze_step()
   end
end

function alias:songlin_shanlu()
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])

	 if roomno[1]==1766 then
		 world.Send("southdown")
		 local dx={"west","east","north","east","south","north","east","west"} --,"south"
	      --[[ alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do
		    --local b=busy.new()
		    --b.interval=0.3
		    --b.Next=function()
			  print(j.."/9 ����:",d)
		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("�ߵ��׽���")
			alias.co=nil
		    self:songlin_shanlu()
		 end)
		self:songlin_check()]]
		alias.circle_co=coroutine.create(function()
         --print("����3")
           for _,i in ipairs(dx) do
	        world.Send(i)
		    print("�������ֱ���:",i)
            self:circle_done("songlin_shanlu")
	        coroutine.yield()
	       end
	       self:finish()
        end)
        --print("����2")
		coroutine.resume(alias.circle_co)


	 elseif roomno[1]==1764 then
	    if _R.relation=="�����֣������֩������֩������֣�����ƺ" then
		   world.Send("south")
		   self:songlin_shanlu()
		   return
		end
		if _R.relation=="�����֣������֩������֩������֣�ɽ·" then
		   world.Send("south")
		   self:out_songlin()
		   return
		end
	    print("�����м俪ʼ")
	   if alias.circle_co==nil then
	      local dx={"west","east","south","east","north","north","east","west"} --,"south"

		    alias.circle_co=coroutine.create(function()
            --print("����3")
             for _,i in ipairs(dx) do
	          world.Send(i)
		      print("�������ֱ���:",i)
              self:circle_done("songlin_shanlu")
	          coroutine.yield()
	         end
			 alias.circle_co=nil
	         self:finish()
           end)
        --print("����2")
		   coroutine.resume(alias.circle_co)
		else
		  --�ߵ�һ���·�� ����
		   print("û�ߵ���")
		   coroutine.resume(alias.circle_co)
		end
	 else
	    local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:songlin_shanlu()
		end
		w:go(1751)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:out_songlin()
   self:finish()
end

function alias:songlin_fumoquan()
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])

	 if roomno[1]==1751 then
	    world.Send("east")
		 local dx={"west","east","south","east","north","north","east","west"} --,"south"
	      --[[ alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do
		    --local b=busy.new()
		    --b.interval=0.3
		    --b.Next=function()
			  print(j.."/9 ����:",d)
		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("�ߵ��׽���")
			alias.co=nil
		    self:songlin_fumoquan()
		 end)
		self:songlin_check()]]
        alias.circle_co=coroutine.create(function()
          --print("����3")
         for _,i in ipairs(dx) do
	        world.Send(i)
		    print("�������ֱ���:",i)
            self:circle_done("songlin_fumoquan")
	        coroutine.yield()
	     end
	     alias.circle_co=nil
	     self:finish()
        end)
        --print("����2")
        coroutine.resume(alias.circle_co)
	 elseif roomno[1]==1764 then
	    if _R.relation=="�����֣������֩������֩������֣�����ƺ" then
		   world.Send("south")
		   --self:finish()
		   self:out_songlin()
		   return
		end
		if _R.relation=="�����֣������֩������֩������֣�ɽ·" then
		   world.Send("south")
		   self:songlin_fumoquan()
		   return
		end
	    print("�����м俪ʼ")
	   if alias.circle_co==nil then
	      local dx={"west","east","south","east","north","north","east","west"} --,"south"
	      --[[ alias.co=coroutine.create(function()
		   local d
	       for j,d in ipairs(dx) do
		    --local b=busy.new()
		    --b.interval=0.3
		    --b.Next=function()
			 print(j.."/9 ����:",d)
		     world.Send(d)
             self:songlin_check()
		    --end
			--b:check()
			 coroutine.yield()
	        end
			print("�ߵ��׽���")
			alias.co=nil
		    self:songlin_fumoquan()
	       end)
	      self:NextPoint() --��������]]

		alias.circle_co=coroutine.create(function()
            --print("����3")
          for _,i in ipairs(dx) do
	         world.Send(i)
		     print("�������ֱ���:",i)
             self:circle_done("songlin_fumoquan")
	         coroutine.yield()
		  end
		  alias.circle_co=nil
	       self:finish()
        end)
         --print("����2")
         coroutine.resume(alias.circle_co)
		else
		  --�ߵ�һ���·�� ����
		   print("û�ߵ���")
		   coroutine.resume(alias.circle_co)
		end
	 else
	     local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:songlin_fumoquan()
		end
		w:go(1751)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:push_flag()
  world.Send("push flag")
  world.Send("out")
  world.Send("get sheyao")
  world.Send("fu sheyao")
  local b=busy.new()
  b.Next=function()
     self:finish()
  end
  b:check()
end

function alias:shanlu_songlin()
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1751 then
	    world.Send("east")
		 local dx={"west","east","south","east","north","north","east","west"} --,"south"
		--[[alias.co=coroutine.create(function()
		 local d
	     for j,d in ipairs(dx) do
		   --local b=busy.new()
		   --b.interval=0.3
		   --b.Next=function()
			print(j.."/9 ����:",d)
		    world.Send(d)
            self:songlin_check()
		   --end
		   --b:check()
		   coroutine.yield()
	     end
		 print("�ߵ��׽���")
		 alias.co=nil
		 self:shanlu_songlin()
	    end)
		 self:songlin_check()]]
		   alias.circle_co=coroutine.create(function()
            --print("����3")
          for _,i in ipairs(dx) do
	         world.Send(i)
		     print("�������ֱ���:",i)
             self:circle_done("shanlu_songlin")
	         coroutine.yield()
		  end
		  alias.circle_co=nil
	       self:finish()
        end)
         --print("����2")

         coroutine.resume(alias.circle_co)
	 elseif roomno[1]==1764 then
	     if _R.relation=="�����֣������֩������֩������֣�����ƺ" then
		   --world.Send("south")
		   --self:finish()
		   self:out_songlin()
		   return
		end
	    if _R.relation=="�����֣������֩������֩������֣�ɽ·" then
		    world.Send("south")
		   --self:finish()
		    self:shanlu_songlin()
		   return
		end
	   print("�����м俪ʼ")
	   if alias.circle_co==nil then
		 local dx={"west","east","south","east","north","north","east","west"} --,"south"
	     --[[alias.co=coroutine.create(function()
		 local d
	     for j,d in ipairs(dx) do
		   --local b=busy.new()
		   --b.interval=0.3
		   --b.Next=function()
			print(j.."/9 ����:",d)
		    world.Send(d)
            self:songlin_check()
		   --end
		   --b:check()
		   coroutine.yield()
	     end]]
		  alias.circle_co=coroutine.create(function()
            --print("����3")
            for _,i in ipairs(dx) do
	           world.Send(i)
		       print("�������ֱ���:",i)
               self:circle_done("shanlu_songlin")
	           coroutine.yield()
		    end
		    alias.circle_co=nil
	        self:finish()
          end)
          --print("����2")
          coroutine.resume(alias.circle_co)
		  print("�ߵ��׽���")
		  --self:shanlu_songlin()

	   else
		  --�ߵ�һ���·�� ����
		  print("û�ߵ���")
		  --[[self.out_songlin=function()
		     print("�ϴε�û�����·������")
			 world.Send("south")
			 local w
		     w=walk.new()
		     w.walkover=function()
		       self:finish()
		     end
		     w:go(1751)
		  end]]
		  --[[self.songlin_check=function()
		     self:NextPoint()
		  end
		  self:NextPoint()]]
		  coroutine.resume(alias.circle_co)
		end
	 else
	    local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:shanlu_songlin()
		end
		w:go(1754)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:fumoquan_songlin()
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1766 then
	     world.Send("southdown")
		local dx={"west","east","north","east","south","north","east","west"} --,"south"
		--[[alias.co=coroutine.create(function()
		 local d
	     for j,d in ipairs(dx) do
		   --local b=busy.new()
		   --b.interval=0.3
		   --b.Next=function()
			print(j.."/9 ����:",d)
		    world.Send(d)
            self:songlin_check()
		   --end
		   --b:check()
		   coroutine.yield()
	     end
		 print("�ߵ��׽���")
		 alias.co=nil
		 self:fumoquan_songlin()
	    end)
		 self:songlin_check()]]
		alias.circle_co=coroutine.create(function()
            --print("����3")
          for _,i in ipairs(dx) do
	         world.Send(i)
		     print("�������ֱ���:",i)
             self:circle_done("fumoquan_songlin")
	         coroutine.yield()
		  end
	       self:finish()
        end)
         --print("����2")
         coroutine.resume(alias.circle_co)
	 elseif roomno[1]==1764 then
	     if _R.relation=="�����֣������֩������֩������֣�����ƺ" then
		   world.Send("south")
		   self:fumoquan_songlin()
		   return
		end
	    if _R.relation=="�����֣������֩������֩������֣�ɽ·" then
		   --world.Send("south")
		   --self:finish()
		   self:out_songlin()
		   return
		end
	   print("�����м俪ʼ")
	   if alias.circle_co==nil then
		 local dx={"west","east","north","east","south","north","east","west"} --,"south"
	     --[[alias.co=coroutine.create(function()
		 local d
	     for j,d in ipairs(dx) do
		   --local b=busy.new()
		   --b.interval=0.3
		   --b.Next=function()
			print(j.."/9 ����:",d)
		    world.Send(d)
            self:songlin_check()
		   --end
		   --b:check()
		   coroutine.yield()
	     end]]
		 alias.circle_co=coroutine.create(function()
            --print("����3")
          for _,i in ipairs(dx) do
	         world.Send(i)
		     print("�������ֱ���:",i)
             self:circle_done("fumoquan_songlin")
	         coroutine.yield()
		  end
		   alias.circle_co=nil
	       self:finish()
        end)
         --print("����2")
         coroutine.resume(alias.circle_co)
		 print("�ߵ��׽���")

		 --self:fumoquan_songlin()

	   else
		  --�ߵ�һ���·�� ����
		  print("û�ߵ���")
		  --[[self.out_songlin=function()
		     print("�ϴε�û�����·������")
			 world.Send("south")
			 local w
		     w=walk.new()
		     w.walkover=function()
		       self:finish()
		     end
		     w:go(1751)
		  end]]
		  --[[self.songlin_check=function()
		     self:NextPoint()
		  end
		  self:NextPoint()]]
		  coroutine.resume(alias.circle_co)
		end
	 else
	   local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:fumoquan_songlin()
		end
		w:go(1754)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end



function alias:duxiaohe()
   world.Send("ask lao zhe about ��ǧ��")
   local b
   b=busy.new()
   b.interval=0.3
   b.Next=function()
 --> �������ԣ���������ܿ������������ȥ��
   --�������ߴ����йء���ǧ�ɡ�����Ϣ��
     wait.make(function()
      world.Send("jump river")
	  local l,w=wait.regexp("^(> |)�������ԣ���������ܿ������������ȥ��$|^(> |)��Ҫ��˭�����������$|^(> |)�����ˮ�׵İ�׮���������߹���С�ӡ�$",5)
	  if l==nil then
		self:duxiaohe()
		return
	  end
	  if string.find(l,"�����ˮ�׵İ�׮���������߹���С��") then
	   local b2
	   b2=busy.new()
       b2.interval=0.3
	   b2.Next=function()
	    self:finish()
	   end
	   b2:check()
	   return
	  end
	  if string.find(l,"�������ԣ���������ܿ������������ȥ") then
        local _R
		_R=Room.new()
        _R.CatchEnd=function()
          local count,roomno=Locate(_R)
	      print("��ǰ�����",roomno[1])
	      if roomno[1]==1064  then
		    world.Send("west")
			world.Send("east")
            self:duxiaohe()
	      elseif roomno[1]==1063 then
		    world.Send("east")
			world.Send("west")
	        self:duxiaohe()
		  end
        end
        _R:CatchStart()
	    return
	  end
	  if string.find(l,"��Ҫ��˭���������") then
	    self:finish()
		return
	  end
	  wait.time(5)
	 end)
   end
   b:check()
end
--[[����������
ȥ--nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n ��--s

�����»���
ȥ--w;n;w;w;n ��--s;e;e;s;e]]
--[[�㲻����ɫ�ؿ���½������͵͵�ذ�����½��������ȥ...
��ɹ���͵���˿�ͨ������!]]
--1457_1767
--> Сľ��˳�ź��磬һֱ��Ʈȥ��
--ֻ��������һԾ��������ľ���ϡ�

function alias:error_mufa()
   world.Send("hua mufa")
   self:shangan()
end

function alias:shangan()
  wait.make(function()
    local l,w=wait.regexp("^(> |)ֻ�����䡱��һ����Сľ������ײ����ʲô��������һ�����ӱ����˳�����$|^(> |)���ͷһ����Сľ��ײ��ɢ�ܣ����������ˡ�$|^(> |)Сľ��˳�ź��磬һֱ��Ʈȥ��$",5)
	if l==nil then
	   self:shangan()
	   return
	end
	if string.find(l,"ֻ�����䡱��һ����Сľ������ײ����ʲô��������һ�����ӱ����˳���") or string.find(l,"���ͷһ����Сľ��ײ��ɢ�ܣ�����������") then
	 	local b=busy.new()
		b.Next=function()
		  local shield=world.GetVariable("shield") or ""
	      if shield~="" then
	        world.Execute(shield)
	      end
  	      self:finish()
		end
		b:check()
	   return
	end
	if string.find(l,"Сľ��˳�ź��磬һֱ��Ʈȥ") then
	  world.Send("hua mufa")
	  self:shangan()
	  return
	end
    wait.time(5)
  end)
end

function alias:mufa()
  -- world.Send("unwield jian")
  local sp=special_item.new()
  sp.cooldown=function()
    world.Send("zuo mufa")
    wait.make(function()
     local l,w=wait.regexp("^(> |)ֻ��������һԾ��������ľ���ϡ�$",3)
	 if l==nil then
	   self:shatan_shenlongdao()
	   return
	 end
	 if string.find(l,"ֻ��������һԾ��������ľ����") then
	   world.Send("hua mufa")
	   self:shangan()
	   return
	 end
	 wait.time(3)
   end)
 end
 sp:unwield_all()
end

function alias:shatan_shenlongdao()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1457  then
        self:zuomufa()
	 elseif roomno[1]==1767 then
		local shield=world.GetVariable("shield") or ""
	    if shield~="" then
	      world.Execute(shield)
	    end
	    self:finish()
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shatan_shenlongdao()
		end
		w:go(1457)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:auto_wield_weapon(success_deal,error_deal)
--�㽫�����������������С��㡸ৡ���һ�����һ�������������С�

   wait.make(function()
	 local l,w=wait.regexp("(.*)\\((.*)\\)$|^(> |)�趨����������look \\= 1$",5)
    if l==nil then
	   self:auto_wield_weapon(success_deal,error_deal)
	   return
	end
	if string.find(l,")") then
	   --print(w[1],w[2])
	   local item_name=w[1]
	   item_name=string.gsub(item_name,"��.*��$","")
	   local item_id=string.lower(w[2])

      if string.find(item_id,"sword") or string.find(item_id,"jian") then
	     local s,e=string.find(item_name,"��")
		 if string.len(item_name)==e then
           world.Send("wield "..item_id)
		   self.weapon_exist=true
		 end
      elseif string.find(item_id,"axe") or string.find(item_id,"fu") then
	    local s,e=string.find(item_name,"��")
		 if string.len(item_name)==e then
           world.Send("wield "..item_id)
		   self.weapon_exist=true
		 end
      elseif string.find(item_id,"blade") or string.find(item_id,"dao") or string.find(item_id,"xue sui") then
	    local s,e=string.find(item_name,"��")
		 if string.len(item_name)==e then
           world.Send("wield "..item_id)
		   self.weapon_exist=true
		 end
      elseif string.find(item_id,"dagger") or string.find(item_id,"bishou") then
	     local s,e=string.find(item_name,"ذ��")
		 if string.len(item_name)==e then
           world.Send("wield "..item_id)
		   self.weapon_exist=true
		 end
	  --[[elseif string.find(item_id,"club") or string.find(l,"gun") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"fork") or string.find(l,"cha") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"hammer") or string.find(l,"falun") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"hook") or string.find(l,"gou") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"spear") or string.find(l,"qiang") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"staff") or string.find(l,"zhang") then
         world.Send("wield "..item_id)
	  elseif string.find(item_id,"brush") or string.find(l,"bi") then
          world.Send("wield "..item_id)
	  elseif string.find(item_id,"stick") or string.find(l,"bang") then
	     world.Send("wield "..item_id)
	  elseif string.find(item_id,"xiao") then
	     world.Send("wield "..item_id)
	  elseif string.find(item_id,"whip") or string.find(item_id,"bian") then
	     world.Send("wield "..item_id)]]
	  end
	  self:auto_wield_weapon(success_deal,error_deal)
	  return
	end
	--print(success_deal," why222")
    if string.find(l,"�趨����������look") then
	   --print(self.weapon_exits,"ֵ")
	   if self.weapon_exist==true then
	     success_deal()
	   else
	     print("û�к�������!!�����鹺������!")
         error_deal()
	   end
	   return
	end
	wait.time(5)
   end)
end

function alias:zuomufa()
    world.Send("wield changjian")
	world.Send("chop tree")
	world.Send("bang mu tou")
	wait.make(function()
	  local l,w=wait.regexp("(> |)ֻ�����ô����ӽ�������ľͷ����һ��...|^(> |)�������ô����ӽ�������ľͷ����һ��...$|^(> |)�����û�����������ֿ���$|^(> |)��������������޷����У�����ܿ�������$",3)
	  if l==nil then
	     world.Send("buy cu shengzi")
		 self:shatan_shenlongdao()
		 return
	  end
	  if string.find(l,"��������������޷����У�����ܿ�����") then
	      --print("why")
		  local success_deal=function() self:shatan_shenlongdao() end
		  local error_deal=function()
		     self:buy_weapon(success_deal,1466,"blade")
		  end
	     local sp=special_item.new()
		 sp.cooldown=function()
		    self.weapon_exist=false
		    world.Send("i")
		    self:auto_wield_weapon(success_deal,error_deal)
	        world.Send("set look 1")
		 end
		 sp:unwield_all()
		 return
	  end
	  if string.find(l,"�����û�����������ֿ�") then
	   local success_deal=function() self:shatan_shenlongdao() end
		  local error_deal=function()
		     self:buy_weapon(success_deal,1466,"blade")
		  end
	     local sp=special_item.new()
		 sp.cooldown=function()
		    self.weapon_exist=false
		    world.Send("i")
		    self:auto_wield_weapon(success_deal,error_deal)
	        world.Send("set look 1")
		 end
		 sp:unwield_all()
		 return
	  end
	  if string.find(l,"ֻ�����ô����ӽ�������ľͷ����һ��") or string.find(l,"�������ô����ӽ�������ľͷ����һ��") then
	    print("ľ������")
		self:mufa()
		return
	  end
	  wait.time(3)
	end)
end

function alias:order_chuan()
  wait.make(function()
   local l,w=wait.regexp("(> |)������һԾ�����˴���",5)
   if l==nil then
     self:order_chuan()
     return
   end
   if string.find(l,"������һԾ�����˴�") then
	 self:finish()
	 return
   end
   wait.time(5)
  end)
end

function alias:wait_chuan()
   wait.make(function()
     local l,w=wait.regexp("������һԾ������С��",20) --�ȴ�20��
	 if l==nil then
	    print("�ȴ�20��û����Ӧ!")
	    self:give_lingpai()
	    return
	 end
	if string.find(l,"������һԾ������С��") then
		  world.Send("order ����")
		  self:order_chuan()
		  return
	end
     wait.time(20)
   end)
end

function alias:give_lingpai()
   local w
   w=walk.new()
   w.walkover=function()
       wait.make(function()
        world.Send("give ling pai to chuan fu")

		local l,w=wait.regexp("������һԾ������С����|������û������������|^(> |)�Է�����������������$|^(> |)����˵����������û�������һ��ɡ���$",5)
		if l==nil then
		  self:give_lingpai()
		  return
		end
		if string.find(l,"������û����������") or string.find(l,"�Է���������������") then
		   self:steal_lingpai()
		   return
		end
		if string.find(l,"������һԾ������С��") then
		  world.Send("order ����")
		  self:order_chuan()
		  return
		end
		if string.find(l,"����û�������һ���") then
		  self:wait_chuan()
		  return
		end
		wait.time(5)
	   end)
   end
   w:go(1767)
end

function alias:steal_lingpai()
	local w
	w=walk.new()
	w.walkover=function()
	  wait.make(function()
	    world.Send("steal lingpai")
		local l,w=wait.regexp("��ɹ���͵���˿�ͨ������!|^(> |)���Ѿ��������ƣ���͵��������$",5)
		if l==nil then
		   self:steal_lingpai()
		   return
		end
		if string.find(l,"��ɹ���͵���˿�ͨ������") or string.find(l,"���Ѿ��������ƣ���͵������") then
		   self:give_lingpai()
		   return
		end
		wait.time(5)
	  end)

	end
	w:go(1772)
end

function alias:shenlongdao_shatan()
    self:steal_lingpai()
end
--1772 _ 1767 �ϴ�
--steal lingpai
--[[�㲻����ɫ�ؿ���½������͵͵�ذ�����½��������ȥ...
��ɹ���͵���˿�ͨ������!]]
--give ling pai to chuan fu
--[[�������һ��ͨ�����ơ�
> ����˵��������Ȼ��������ͨ�����ƣ�����ʹ����ϴ�����

ֻ���������ϴ��˸����ƣ��ƺ���ʲô���š�
��һ�����һ��С�����Ӻ��ϻ���ʻ����

�������˵���������Ϸ��һ��С�ģ���
������һԾ������С����]]
--order ����
--ֻ��С���������ļ��٣������򰶱�ʻȥ�����������һԾ�����˴���
--�����ˣ���ˮ�ֶ���ߺ��һ����
--������һԾ�����˴���

--÷ׯ 1180 ����
--[[s ���� ÷ׯ n �� ÷ׯ
xixi;#if @step=s {next_step=w};#if @step=w {next_step=n};#if @step=n {next_step=e};#if @step=e {next_step=s};step=@next_step;@step

#if @step=n {next_step=w};#if @step=w {next_step=s};#if @step=s {next_step=e};#if @step=e {next_step=n};step=@next_step;@step
--]]
local function way_meizhuang(dx)
  if dx=="south" then
     dx="west"
  elseif dx=="west" then
     dx="north"
  elseif dx=="north" then
     dx="east"
  else
     dx="south"
  end
  return dx
end

local function noway_meizhuang(dx)
   if dx=="north" then
     dx="west"
  elseif dx=="west" then
     dx="south"
  elseif dx=="south" then
     dx="east"
  else
     dx="north"
  end
  return dx
end

function alias:out_meizhuang(dx)
      if dx==nil then
           dx="north"
      end

		world.Send(dx)
		wait.make(function()
		   local l,w=wait.regexp("^(> |)�������û�г�·��$|^(> |)÷�� - .*$|^(> |)С· - .*$|^(> |)��ʯ���· - .*$",5)
		   if l==nil then
			  self:out_meizhuang()
			  return
		   end
		   if string.find(l,"�������û�г�·") then
		      print("ʧ��")

		      local dx1=noway_meizhuang(dx)
			   print(dx1)
		       local f=function()
			    self:out_meizhuang(dx1)
			  end
			  f_wait(f,0.3)
		      return
		   end
		   if string.find(l,"÷��") then
		      print("�ɹ�")
			  local dx2=way_meizhuang(dx)
			  print(dx2)
			  local f=function()
			    self:out_meizhuang(dx2)
			  end
			  f_wait(f,0.3)
			  return
		   end
		   if string.find(l,"С·") then
		       self:finish()
			   return
		   end
		   if string.find(l,"��ʯ���·") then
		       self:out_meizhuang()
			  --self:finish()
		      return
		   end
		end)

end

function alias:enter_meizhuang(dx)

     if dx==nil then
           dx="south"
      end

		world.Send(dx)
		wait.make(function()
		   local l,w=wait.regexp("^(> |)�������û�г�·��$|^(> |)÷�� - .*$|^(> |)С· - .*$|^(> |)��ʯ���· - .*$",5)
		   if l==nil then
			  self:enter_meizhuang()
			  return
		   end
		   if string.find(l,"�������û�г�·") then
		      print("ʧ��")

		      local dx1=noway_meizhuang(dx)
			   print(dx1)
		       local f=function()
			    self:enter_meizhuang(dx1)
			  end
			  f_wait(f,0.3)
		      return
		   end
		   if string.find(l,"÷��") then
		      print("�ɹ�")
			  local dx2=way_meizhuang(dx)
			  print(dx2)
			  local f=function()
			    self:enter_meizhuang(dx2)
			  end
			  f_wait(f,0.3)
			  return
		   end
		   if string.find(l,"С·") then
		       self:enter_meizhuang()
			   return
		   end
		   if string.find(l,"��ʯ���·") then

			  self:finish()
		      return
		   end
		end)
end

-- 1066_1848 north
function alias:hubinxiaolu_guiyunzhuang()
   world.Execute("#4 n")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
	 if _R.roomname=="����ׯǰ"  then
	   self:finish()
	 elseif _R.roomname=="����"  then
	   world.Execute("s;s")
	   self:finish()
	 elseif _R.roomname=="�ݵ�"  then
	   world.Send("s")
	   self:finish()
	 elseif _R.roomname=="����С·" then
	   local f=function()
         self:hubinxiaolu_guiyunzhuang()
	   end
	   f_wait(f,0.1)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:hubinxiaolu_guiyunzhuang()
		end
		w:go(1066)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
-- 1066_1065 south
function alias:hubinxiaolu_hubinxiaolu()
  world.Execute("#3 s")
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     --local count,roomno=Locate(_R)
	  --print("��ǰ�����",roomno[1])
	 if string.find(_R.relation,"����С·������С·��С������")  then
	   self:finish()
	 elseif string.find(_R.relation,"����ׯǰ������С·������С·") then
	   local f=function()
	      self:hubinxiaolu_hubinxiaolu()
	   end
	   f_wait(f,0.1)
	 elseif _R.roomname=="С�ƹ�" then
	    world.Send("n")
		self:finish()
	 else

	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:hubinxiaolu_hubinxiaolu()
		end
		w:go(1066)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:qusuzhou()
   --self:error_boat()
   self:yellboat()
end

function alias:error_boat()  --��ֹ�����
   world.AddTriggerEx ("error_boat", "^.*�����С�ۿ��ڰ��ߣ����´��ɡ�$", "Send('out')", trigger_flag.OneShot+trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 300);
   world.SetTriggerOption ("error_boat", "group", "alias")
   world.EnableTrigger("error_boat",true)
end

function alias:shangdao()
   wait.make(function()
      local l,w=wait.regexp("�����С�ۿ��ڰ��ߣ����´��ɡ�$",6)
	  if l==nil then
	     self:shangdao()
		 return
	  end
	  if string.find(l,"�����С�ۿ��ڰ��ߣ����´���") then
	     world.DeleteTrigger("error_boat")
	     world.Send("out")
		 self:finish()
	     return
	  end
	  wait.time(6)
   end)
end

function alias:qumr()
     world.Send("qu mr")
	 self:error_boat()
 --[[  ���ڿڴ��﷭����ȥ���Ҵ�Ǯ��
>
���Ǯ�������ң�������������һ��С�ۡ�
�����С�ۿ��ڰ��ߣ����´��ɡ�]]
--���ڵ���С���ߣ������С�ۿ��ڰ��ߣ����´��ɡ�
--��⵰��һ�ߴ���ȥ��
   wait.make(function()
      local l,w=wait.regexp("�ɴ�|С��|^(> |)ʲô.*|^(> |)��⵰��һ�ߴ���ȥ��$",6)
	  if l==nil then
	     self:qumr()
		 return
	  end
	  if string.find(l,"�ɴ�") or string.find(l,"С��") then
	     --world.Send("out")
		 --self:finish()
		 self:shangdao()
		 return
	  end
	  if string.find(l,"��⵰��һ�ߴ���ȥ") then
			local f=function()
		      local w=walk.new()
			   w.user_alias=self
		       w.walkover=function()
		        self:finish()
			   end
		       w:go(2700)
			 end
		    self:ATM(f)
	    return
	  end
	  if string.find(l,"ʲô") then
	     --local w=walk.new()
		 --w.walkover=function()
		 --  self:qumr()
		    self:finish()
		 --end
		 --w:go(2700)
	     return
	  end
	  wait.time(6)
   end)
end

function alias:tanqin()
  world.Send("tan qin")
   wait.make(function()
      local l,w=wait.regexp("�ɴ�|С��|^(> |)ʲô.*$|^(> |)��Ҫ��ʲô������$",6)
	  if l==nil then
	     self:qumr()
		 return
	  end
	  if string.find(l,"�ɴ�")  or string.find(l,"С��") then
	     --world.Send("out")
		 --self:finish()
		 self:shangdao()
		 return
	  end
	   if string.find(l,"ʲô") or string.find(l,"��Ҫ��ʲô����") then
	     self:finish()
	     return
	  end
	  wait.time(6)
   end)
end
--ֻ��������һԾ��������ľ���ϡ�
function alias:quyanziwu()
   world.Send("qu yanziwu")
   self:error_boat()
 --[[  ���ڿڴ��﷭����ȥ���Ҵ�Ǯ��
>
���Ǯ�������ң�������������һ��С�ۡ�
�����С�ۿ��ڰ��ߣ����´��ɡ�]]
   wait.make(function()
      local l,w=wait.regexp("�ɴ�|С��|^(> |)ʲô.*$|^(> |)��⵰��һ�ߴ���ȥ��$",6)
	  if l==nil then
	     self:quyanziwu()
		 return
	  end
	  if string.find(l,"�ɴ�") or string.find(l,"С��") then
	    -- world.Send("out")
		-- self:finish()
		self:shangdao()
		return
	  end
	  if string.find(l,"��⵰��һ�ߴ���ȥ") then
	    local f=function()
		  self:quyanziwu()
		end
		self:ATM(f)
	    return
	  end
	  if string.find(l,"ʲô") then
	     self:finish()
	     return
	  end
	  wait.time(6)
   end)
end

--;ge tielian;#wa 4000;tiao duimian
--2060 baizhangjian  2297 xianchoumen
--������С�� 2071 buy wan dao
function alias:buy_weapon(f,roomno,weapon_id)
   local w=walk.new()
   w.walkover=function()
      world.Send("buy "..weapon_id)
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)����.*������һ.*��$|^.*˵��������⵰��һ�ߴ���ȥ����",5)
	    if l==nil then
		   self:buy_weapon(f,roomno,weapon_id)
		   return
		end
		if string.find(l,"����") then
		    f()
		   return
		end
		if string.find(l,"��⵰��һ�ߴ���ȥ") then
		   local c=function()
			  self:buy_weapon(f,roomno,weapon_id)
		   end
		   self:qu_gold(c)
		   return
		end
	  end)
   end
   w:go(roomno)
end

function alias:qu_gold(CallBack)
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
          world.Send("qu 5 gold")
		local l,w=wait.regexp("^(> |)���������ȡ���嶧�ƽ�$",5)
		print("����")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold()
		   return
		end
		if string.find(l,"���������") then
		   CallBack()
		   return
		end
		wait.time(5)
	  end)
   end
   w:go(410)
end

function alias:tiaoduimian()
   	wait.make(function()
	  local l,w=wait.regexp("(> |)���������Ѿ�ն������$|^(> |)������Լ����Ṧ̫�����ȥ����������$|(> |)����ü����������߲��ܿ���������$|^(> |)���ս�����.*�������������ѽ������ͱ�ʯ���еİ������ն����������������!$|^(> |)��������������޷����У�����ܿ������������$",5)
	  if l==nil then
	     self:tiaoduimian()
		 return
	  end
	  if string.find(l,"����ü����������߲��ܿ�������") then
		local sp=special_item.new()
		 sp.cooldown=function()
		    local f=function()
			    local f2=function()
				   --print("test2:",self.id)
			       self:baizhangjian_xianchoumen()
				end
				--print("test:",self.id)
				self:redo(f2) --���Զ���walk.redo�������� w:go(targetRoomNo)
			end
		    world.Send("i")
	        world.Send("set look 1")
			 self.weapon_exist=false
		  local error_deal=function()
		     self:buy_weapon(f,2071,"wandao")
		  end
	      self:auto_wield_weapon(f,error_deal)
		end
		sp:unwield_all()
		 return
	  end
	  if string.find(l,"�ѽ������ͱ�ʯ���еİ������ն����������������") or string.find(l,"���������Ѿ�ն��") then
		local b
         b=busy.new()
		 b.interval=0.3
         b.Next=function()
          world.Send("tiao duimian")
          local b1
	       b1=busy.new()
	       b1.interval=0.5
	       b1.Next=function()
	         local sp=special_item.new()
			 sp.cooldown=function()
			   	 local shield=world.GetVariable("shield") or ""
				 if shield~="" then
	               world.Execute(shield)
	             end
			   self:finish()
			 end
	         sp:unwield_all()
	       end
	       b1:check()
         end
         b:check()
		return
	  end
	  if string.find(l,"������Լ����Ṧ̫�����ȥ��������") then
	      self.break_in_failure()
	     return
	  end
	  if string.find(l,"��������������޷����У�����ܿ����������") then
	    local sp=special_item.new()
		sp.cooldown=function()
		    local f=function()
			    local f2=function()
				   --print("test2:",self.id)
			       self:baizhangjian_xianchoumen()
				end
				--print("test:",self.id)
				self:redo(f2) --���Զ���walk.redo�������� w:go(targetRoomNo)
			end
		    world.Send("i")
	        world.Send("set look 1")
			 self.weapon_exist=false
		  local error_deal=function()
		     self:buy_weapon(f,2071,"wandao")
		  end
	      self:auto_wield_weapon(f,error_deal)
		end
		sp:unwield_all()
		return
	  end
	  wait.time(5)
	end)
end

function alias:baizhangjian_xianchoumen()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2060  then
		world.Send("wield sword")
		world.Send("wield blade")
		world.Send("wield jian")
		world.Send("wield dagger")
        world.Send("ge tielian")
        self:tiaoduimian()
	 elseif roomno[1]==2297 then
	    self:finish()
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:baizhangjian_xianchoumen()
		end
		w:go(2060)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:xianchoumen_baizhangjian()
    local sp=special_item.new()
	sp.cooldown=function()
	     world.Send("tiao duimian")
        local b
        b=busy.new()
        b.interval=0.5
        b.Next=function()
		   local shield=world.GetVariable("shield") or ""
			if shield~="" then
	               world.Execute(shield)
			end
            self:finish()
        end
        b:check()
	end
	sp:unwield_all()

end


function alias:zhenyelin_circle()
   local p={"north","east","south","west","south","east","west","north","east","west","south"}
   alias.circle_co=coroutine.create(function()
      --print("����3")
      for _,i in ipairs(p) do
	     world.Send(i)
		 print("��Ҷ�ֱ���:",i)
         self:circle_done("zhenyelin_circle")
	     coroutine.yield()
	  end
	  self:finish()
   end)
  --print("����2")
   coroutine.resume(alias.circle_co)
end

--����  2050  �Թ�2049 ��Ҷ��
function alias:zhenyelin(d)
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3875  then
	   self:finish()
	 elseif roomno[1]==2049  then
	   if d==nil then
	     local dx={"west;west;west;west;west;west;west;west","south;south;south;south;south;south;south;south","east;east;east;east;east;east;east;east","north;north;north;north;north;north;north;north"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     local dx=""
		 dx="halt;".. d()
		 print("����:",dx)
	     world.Execute(dx)
         self:zhenyelin(d)
	   end
	   f_wait(f,0.8)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zhenyelin()
		end
		w:go(2049)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--#al �½��ƺӺ�ľ�¶�ȥ {#2 n;e;ne;eu;#2 e;#wa 1000;e;ne;#3 n;#2 nw;n;wd;dutan;e;#5 wu;whisper jia �����ĳ���£�һͳ����;whisper jia ����ǧ�����أ�һͳ����;whisper jia ��������Ϊ������������;whisper jia ������ּӢ���������Ų�;whisper jia �����������£��츣����;whisper jia ����ս�޲�ʤ�����޲���;whisper jia ��������ĳ���¡�����Ӣ��;whisper jia ��������ʥ�̣��󱻲���;wu;zong}
--#al ��������С��Ůȥ {halt;#10 jian shi;tiao tan;#wa 3000;qian down;#wa 3000;qian down;#wa 3000;qian down;#wa 3000;#10 drop stone;#wa 5000;qian zuoshang;#wa 3000;qian up;#wa 3000;pa up;n;enter;e;e}
--[[function alias:caoyuanbianyuan_sichouzhilu()

  print("alias id step2:",self.id)
 world.Execute("east;east;east;east;east;east")
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1962  then
	   self:finish()
	 elseif roomno[1]==2064 or roomno[1]==2063 then
	   self:caoyuanbianyuan_sichouzhilu()
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(1962)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:sichouzhilu_caoyuanbianyuan()
 world.Execute("west;west;west;west;west;west")
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2063 then
	   self:finish()
	 elseif roomno[1]==1962 or roomno[1]==2064 then
	   self:sichouzhilu_caoyuanbianyuan()
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2063)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end]]

function alias:shamo_caoyuanbianyuan() --ɳĮ�� ��ԭ��Ե
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2063  then
	   self:finish()
	 elseif roomno[1]==2064 then

	  local p={"north","west","west","west","west"}
      alias.circle_co=coroutine.create(function()
      --print("����3")
        for _,i in ipairs(p) do
	     world.Send(i)
		 print("��ɳĮ����:",i)
         self:circle_done("shamo_caoyuanbianyuan")
	     coroutine.yield()
	    end
	      self:shamo_caoyuanbianyuan()
      end)

       coroutine.resume(alias.circle_co)

	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shamo_caoyuanbianyuan()
		end
		w:go(2064)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:shamo_sichouzhilu()  --ɳĮ ˿��֮·
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1962 then
	   self:finish()
	 elseif roomno[1]==2064 then

	  local p={"north","east","east","east","east"}
      alias.circle_co=coroutine.create(function()
      --print("����3")
        for _,i in ipairs(p) do
	     world.Send(i)
		 print("��ɳĮ����:",i)
         self:circle_done("shamo_sichouzhilu")
	     coroutine.yield()
	    end
	      self:shamo_sichouzhilu()
        end)
	     coroutine.resume(alias.circle_co)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shamo_sichouzhilu()
		end
		w:go(2064)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--373 ҩ��
--366   ɽ��

-- ��������
--[[�������ֽ���
�����һ�����崦

1 ����� - north��northeast��southeast��west
  һ��ҩ��(Yao cao)
  ������(Da shugan)
  ȥ (e;s;s)
  �� (se;nw;e;e;w)

2 ����� - north��northwest(n;w)
  �ϻ�(Lao hu)
  ȥ (e;s;s;se;w)
  �� (n;w)

3 ����� - northwest��west(nw;e;e;w)
  Ұ��(Ye tu)
  Ұ��(Ye tu)
  С��֦(Xiao shuzhi)
  ȥ (e;e;s)
  �� (nw;e;e;w)

4 ����� - north��south
  ����(Snake)
  ����(Snake)
  ȥ (e;s)
  �� (s;se;nw;e;e;w)

5 ����� - east��northwest��south��southwest
  ����(Snake)
  ����ʬ��(Corpse)
  ȥ(e;e;s;w)
  ��(e;nw;e;e;w)

  ������һ��������
1 ���� - east��north��south��west 2249
  ������
  ȥ (e)
  �� (w)

2 ���� - east��north��south��west 2250 _2251
  ������
  ȥ (e;e;w) -- e e ����
  �� (e;e;w) ok

3 ���� - east��north��south��west 2250 _2252
  ��Ԫ�
  ȥ (e;e)  -- ���� ��Ҫ���� 2251 e e w e
  �� (e;w)  ok

4 ���� - east��north��south��west 2250 _2253
  ȥ (w;w;e;w) -- ���� ��Ҫ���� 2254
  �� (e;e) ok

5 ���� - east��north��south��west 2250 _2254
  С��֦(Xiao shuzhi)
  ���̺�ˮ����� ���(Xu da)
  ȥ (w;w) ok
  �� (e;w;e;e) ? ���� �ض���һ������ 2253

6 ���� - east��north��south��west 2169
  ��ʯͷ
  Сʯͷ
  ȥ(w)
  ��(e)]]
--2250 �����Թ� ��������npc��ȷ������λ��
--2168 ��ľ��
--2169 ��ľ
--2249 ��ľ
--2168 ��ľ�� ����
--[[�����������, ���Ｐ��Ʒ��(Ӣ��)�������£�
��ľ����� = jiao zhong, zhong
��ľ����� = jiao zhong, zhong
��ľ����� = jiao zhong, zhong
Ҷ֪�� = outstand
�Ų��� = wen cangsong, wen, cangsong]]

local function dx_mingjiaoshulin(index)

	local dx={"east","north","west","south"}
	if index==nil then
	  index=0
	end
	local new_index=index+1
	if new_index>4 then
	   new_index=1
	end
	return dx[new_index],new_index
end

function alias:mingjiaoshulin_noman()
	 wait.make(function()
		 --local d,new_index=dx_mingjiaoshulin(index)
		 --print("����",d," new_index:",new_index)
		 --world.Send("look " ..d)
		 world.Send("look")
        local l,w=wait.regexp("^(> |).*����� -.*$|^.*������.*$|^.*��Ԫ�.*$|^.*���.*$",4)
        if l==nil then
		  --̽���Ƿ����
		  print("̽���Ƿ����")
		  wait.make(function()
		    world.Send("set look 1")
			local l,w=wait.regexp("^(> |)�趨����������look \\= 1$",3)
			if l==nil then
			--��ʱ
			  print("��ʱ��δԤ�ڵĴ���!")
			  self:mingjiaoshulin_noman()
			  return
			end
			if string.find(l,"�趨����������look") then
	           --��ȷ
				print("��ȷ����:",d)
	            world.Send(d)
			    self:mingjiaoshulin_houtuqi()
			   return
			end
		    wait.time(3)
		  end)
		  return
		end
		if string.find(l,"�����") then
		   world.Send("north")
		   world.Send("northwest")
		   self:mingjiaoshulin_noman()
		   return
		end
		if string.find(l,"������") or string.find(l,"��Ԫ�") or string.find(l,"���") then
		   print("������ȷ����")
		   world.Send("west")
		   self:mingjiaoshulin_noman()
		   return
		end
		--2169

	    wait.time(4)
	 end)
end

function alias:mingjiaoshulin_zhuyuanzhang(index)
	 wait.make(function()
	     local d,new_index=dx_mingjiaoshulin(index)
		 world.Send("look " ..d)
		 print("����",d," new_index:",new_index)
        local l,w=wait.regexp("^����� -$|^.*������.*$|^.*��Ԫ�.*$|^.*���.*$",5)
		if l==nil then
		  self:mingjiaoshulin_zhuyuanzhang(index)
		  return
		end
        if string.find(l,"��Ԫ�") then
		  print("��ȷ����:",d)
	      world.Send(d)
  	      self:mingjiaoshulin_houtuqi()
	      return
	    end
	    if string.find(l,"���") or string.find(l,"������")  then
		  print("������ȷ����")
		  self:mingjiaoshulin_zhuyuanzhang(new_index)
		  return
	    end
		if string.find(l,"�����") then
		  world.Send("north")
		  world.Send("northwest")
		  self:mingjiaoshulin_zhuyuanzhang(new_index)
		end
	    wait.time(5)
	 end)
end

function alias:mingjiaoshulin_houtuqi()
  wait.make(function()
   world.Send("look")
   world.Send("set look 1")
   local l,w=wait.regexp("^.*������.*$|^.*��Ԫ�.*$|^.*���.*$|^(> |)�趨����������look \\= 1$",5)
   if l==nil then
      self:mingjiaoshulin_houtuqi()
      return
   end
   if string.find(l,"������") then
   -- ����(������)��e;n ����·����#2 e;w

      -- ���ܵ� ��Ԫ� 2252
      world.Execute("east;east;west")
	  self:finish()
	  return
   end

   if string.find(l,"��Ԫ�") then
      world.Execute("east;west")
	  self:finish()
	  return
   end

   if string.find(l,"���") then
   -- ����(���)��#2 w ����·������#6 w;#2 nw;se;nw;#2 e;w
      --���ܵ� 2253
      world.Execute("west;west;west;west;west;west;northwest;northwest;southeast;northwest;east;east;west")
	  self:finish()
	  return
   end

   if string.find(l,"�趨����������look") then
       world.Execute("east;east")
	   self:finish()
       return
   end
   wait.time(5)
  end)

end
--2249 west shuling1
--"south" : __DIR__"shuling3",
--"west" : __DIR__"shuling4",

--2169 east shuling2
--"north" : __DIR__"shuling6",

--shuling6 ������ chang
--"east" : __DIR__"shuling5",
--"north" : __DIR__"shuling4",
--shuling5 zhu
--"east" : __DIR__"shuling2",
--"north" : __DIR__"shuling6",
--shuling4 xu
--"south" : __DIR__"shuling3",
--"north" shenchu

--shuling3
--"east" : __DIR__"shuling1",
--"north" : __DIR__"shuling4",
local shenchu_dx=""
function alias:shuling_shenchu(CallBack)
   shenchu_dx=""
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      print(_R.relation)
       if _R.relation=="����������֩����֩����֣�����" then
	       shenchu_dx="north"
	   elseif _R.relation=="���֣����֩����֩����֣������" then
	       shenchu_dx="south"
	   elseif _R.relation=="���֣�����������֩����֣�����" then
	       shenchu_dx="west"
 	   end
	   print("����",shenchu_dx)
	   CallBack()
   end
   _R:CatchStart()
end

function alias:houtuqi_mingjiaoshulin1() --4���ӷ��� shuling6



 --2251  ������
   wait.make(function()
   world.Send("look")
   world.Send("set look 1")
   local l,w=wait.regexp("^.*������.*$|^.*��Ԫ�.*$|^.*���.*$|^(> |)�趨����������look \\= 1$",5)
   if l==nil then
      self:houtuqi_mingjiaoshulin1()
      return
   end
   if string.find(l,"������") then
      self:finish()
	  return
   end

   if string.find(l,"��Ԫ�") then
     --5 -> 6 west
	 local f=function()
	   if shenchu_dx=="west" then
         world.Send("north")
	   elseif shenchu_dx=="north" then
	     world.Send("south")
	   elseif shenchu_dx=="south" then
	     world.Send("west")
	   end
       self:finish()
	 end
	 self:shuling_shenchu(f)

	  return
   end

   if string.find(l,"���") then
   -- ����(���)��#2 w ����·������#6 w;#2 nw;se;nw;#2 e;w
      --���ܵ� 2253
       --4->6 north
	  local f=function()
		if shenchu_dx=="north" then
           world.Send("south")
	    elseif shenchu_dx=="south" then
	      world.Send("west")
	    elseif shenchu_dx=="west" then
	      world.Send("north")
	    end
	    world.Execute("east;east;east;north")
        self:finish()
      end
	  self:shuling_shenchu(f)
	  return
   end

   if string.find(l,"�趨����������look") then
       world.Execute("east;east;east;north")

       self:finish()
       return
   end
   wait.time(5)
  end)

end

--2249 west shuling1
--"south" : __DIR__"shuling3",
--"west" : __DIR__"shuling4",

--2169 east shuling2
--"north" : __DIR__"shuling6",

--shuling6 ������ chang
--"east" : __DIR__"shuling5",
--"north" : __DIR__"shuling4",
--"west" : __DIR__"shenchu4",
--w n |n s| s w |e e

--shuling5 zhu ��Ԫ�
--"east" : __DIR__"shuling2",
--"north" : __DIR__"shuling6",
--"west" : __DIR__"shenchu4",
--"south" : __DIR__"shuling5",
--w n |n s| s w |e e


--shuling4 xu ���
--"south" : __DIR__"shuling3",
--"north" : __DIR__"shenchu1",
--w n |n s| s w |e e

--shuling3
--"east" : __DIR__"shuling1",
--"north" : __DIR__"shuling4",
--"west" : __DIR__"shenchu1",
--w n |n s| s w |e e

function alias:houtuqi_mingjiaoshulin2() --shuling5
 --2252 ��Ԫ�
  wait.make(function()
   world.Send("look")
   world.Send("set look 1")
   local l,w=wait.regexp("^.*������.*$|^.*��Ԫ�.*$|^.*���.*$|^(> |)�趨����������look \\= 1$",5)
   if l==nil then
      self:houtuqi_mingjiaoshulin2()
      return
   end
   if string.find(l,"������") then
      --6 ->5
      world.Send("east")
      self:finish()
	  return
   end

   if string.find(l,"��Ԫ�") then
      self:finish()
	  return
   end

   if string.find(l,"���") then
   -- ����(���)��#2 w ����·������#6 w;#2 nw;se;nw;#2 e;w
      --���ܵ� 2253
      --4 >5
	  local f=function()
	    if shenchu_dx=="north" then
           world.Send("south")
	    elseif shenchu_dx=="south" then
	      world.Send("west")
	    elseif shenchu_dx=="west" then
	      world.Send("north")
	   end
	   world.Execute("east;east;east;east;east")
       self:finish()
	  end
	  self:shuling_shenchu(f)
	  return
   end

   if string.find(l,"�趨����������look") then
       world.Execute("east;east;east;east;east")
       self:finish()
       return
   end
   wait.time(5)
  end)

end
--2249 west shuling1
--"south" : __DIR__"shuling3",
--"west" : __DIR__"shuling4",

--2169 east shuling2
--"north" : __DIR__"shuling6",

--shuling6 ������ chang
--"east" : __DIR__"shuling5",
--"north" : __DIR__"shuling4",
--shuling5 zhu
--"east" : __DIR__"shuling2",
--"north" : __DIR__"shuling6",
--shuling4 xu
--"south" : __DIR__"shuling3",
--shuling3
--"east" : __DIR__"shuling1",
--"north" : __DIR__"shuling4",

function alias:houtuqi_mingjiaoshulin3() --shuling3
 --2253 ������ ���һ������
 wait.make(function()
    self:shuling_shenchu()
   world.Send("set look 1")
   local l,w=wait.regexp("^.*������.*$|^.*��Ԫ�.*$|^.*���.*$|^(> |)�趨����������look \\= 1$",5)
   if l==nil then
      self:houtuqi_mingjiaoshulin3()
      return
   end
   if string.find(l,"������") then
   -- ����(������)��e;n ����·����#2 e;w

      --6->3

	  world.Execute("east;east;west;west;south")
      self:finish()

	  return
   end

   if string.find(l,"��Ԫ�") then
	--5-3
	  --world.Execute("north;north;south")
      --self:finish()
	  world.Execute("east;west;west;south")

	  self:finish()

	  return
   end

   if string.find(l,"���") then
   -- ����(���)��#2 w ����·������#6 w;#2 nw;se;nw;#2 e;w
      --���ܵ� 2253
	  -- 4 3
	  --world.Send("south")
	  local f=function()
	    if shenchu_dx=="north" then
           world.Send("south")
	    elseif shenchu_dx=="south" then
	      world.Send("west")
	    elseif shenchu_dx=="west" then
	      world.Send("north")
	    end
        self:finish()
	  end
	  self:shuling_shenchu(f)
	  return
   end

   if string.find(l,"�趨����������look") then
       self:finish()
       return
   end
   wait.time(5)
  end)
end

--2249 west shuling1
--"south" : __DIR__"shuling3",
--"west" : __DIR__"shuling4",

--2169 east shuling2
--"north" : __DIR__"shuling6",

--shuling6 ������ chang
--"east" : __DIR__"shuling5",
--"north" : __DIR__"shuling4",
--shuling5 zhu
--"east" : __DIR__"shuling2",
--"north" : __DIR__"shuling6",
--shuling4 xu
--"south" : __DIR__"shuling3",
--shuling3
--"east" : __DIR__"shuling1",
--"north" : __DIR__"shuling4",

function alias:houtuqi_mingjiaoshulin4() --shuling4
 --2254 ���
   wait.make(function()
    self:shuling_shenchu()
   world.Send("set look 1")
   local l,w=wait.regexp("^.*������.*$|^.*��Ԫ�.*$|^.*���.*$|^(> |)�趨����������look \\= 1$",5)
   if l==nil then
      self:houtuqi_mingjiaoshulin4()
      return
   end
   if string.find(l,"������") then
   -- ����(������)��e;n ����·����#2 e;w
   --"north" : __DIR__"shenchu1",
     local f=function()
	  if shenchu_dx=="west" then
       world.Send("north")
	  elseif shenchu_dx=="north" then
	   world.Send("south")
	  elseif shenchu_dx=="south" then
	   world.Send("west")
	  end
      --6 -4
       self:finish()

	   end
	  self:shuling_shenchu(f)
	  return
   end

   if string.find(l,"��Ԫ�") then
     --5 4
	  world.Execute("east;west;west;east")
	  self:finish()
	  return
   end

   if string.find(l,"���") then
   -- ����(���)��#2 w ����·������#6 w;#2 nw;se;nw;#2 e;w
      --���ܵ� 2253

      self:finish()
	  return
   end

   if string.find(l,"�趨����������look") then
	  --3 4
	 local f=function()
	   	if shenchu_dx=="west" then
          world.Send("north")
	    elseif shenchu_dx=="north" then
	      world.Send("south")
		elseif shenchu_dx=="south" then
	      world.Send("west")
	    end
        self:finish()
	 end
	 self:shuling_shenchu(f)
       return
   end
   wait.time(5)
  end)

end

--�ص�����

function alias:break_in_failure(f)
 --����ʧ�� Ĭ��
   print("Ĭ��break fail������")
   print("�ӳ�3s ��������",self.break_in_count)
   self.break_in_count=self.break_in_count+1
   if self.break_in_count>5 then
      print("ʧ�ܳ���5��")
        self:finish()
	  return
   end
   if f==nil then
      print("�պ���")
   else
      f_wait(f,3)
   end
  --[[ if type (self.finish) == "function" then
    -- print("jieshu")
     self:finish()
	else
	  print("�պ���")
   end]]
end

local function defeat_guard(id,exps)
   if (id=="ya yi" or id=="guan bing" or id=="bing" or id=="ya huan" or id=="guan jia" or id=="dali guanbing|dali guanbing|dali wujiang" or id=="a bi" or id=="jia ding") and tonumber(exps)>=80000 then
      return true
   end
   if (id=="ren feiyan") and tonumber(exps)>=500000 then
      return true
   end
   if (id=="hou zi") and tonumber(exps)>=20000 then
      return true
   end
   if (id=="hufa lama" or id=="da yayi" or id=="caihua zi") and tonumber(exps)>=100000 then
      return true
   end
   if (id=="chanshi|wu seng|wu seng" or id=="zayi lama") and tonumber(exps)>=300000 then
      return true
   end
   if (id=="bangzhong") and tonumber(exps)>=80000 then
      return true
   end
   if (id=="yin wushou" or id=="chanshi" or id=="zhuang ding" or id=="wu seng" or id=="dizi") and tonumber(exps)>=400000 then
      return true
   end
   if (id=="ge guangpei|gan guanghao")  and tonumber(exps)>=200000 then
      return true
   end
   if (id=="hong xiaotian" or id=="xi huazi" or id=="yin liting") and tonumber(exps)>=350000 then
     return true
   end
   if (id=="wu guangsheng|yu guangbiao" or id=="rong ziju" or id=="zhao liangdong") and tonumber(exps)>=300000 then
     return true
   end
   if (id=="gong guangjie|xin shuangqing|zuo zimu") and tonumber(exps)>=300000 then
     return true
   end
   if (id=="guan bing|guan bing|wu jiang") and tonumber(exps)>=200000 then
     return true
   end
   if id=="yang xiao" and tonumber(exps)>=5000000 then
     return true
   end
    if (id=="fan yao" or id=="ding mian") and tonumber(exps)>=1200000 then
     return true
   end
   if (id=="fan yiweng")  and tonumber(exps)>=800000 then
     return true
   end
   if (id=="yu lianzhou" or id=="zhang songxi" or id=="xuansheng dashi") and tonumber(exps)>1300000 then
      return true
   end
   if (id=="dadian dashi" or id=="he taichong" or id=="benyin dashi") and tonumber(exps)>2000000 then
      return true
   end
   if (id=="murong bo") and tonumber(exps)>20000000 then
	  return true
   end
   if (id=="zhong wanchou") and tonumber(exps)>=800000 then
      return true
   end
   if (id=="huang lingtian|ling zhentian" or id=="shitai") and tonumber(exps)>=500000 then
      return true
   end
   --print("false")
   return false
end

local break_npc=nil
function break_npc_id(ids)
   local id={}
   id=Split(ids,"|")
   local index=0
   return function()
     index=index+1
	 if index>table.getn(id) then
	    index=1
	 end
	 --print(id[index])
	 local is_end=true
	 if index<table.getn(id) then
	   is_end=false
	 end
	 return id[index],is_end
   end
end

function convert_pfm(pfm)
    pfm=string.gsub(pfm,"perform dazhuan","perform wushuai")
	pfm=string.gsub(pfm,"perform hammer.dazhuan","perform hammer.wushuai")
	pfm=string.gsub(pfm,"perform parry.dazhuan","perform parry.wushuai")

	--[[

	wield jian;wield sword;jifa blade jindao-heijian;jifa sword jindao-heijian;jifa parry jindao-heijian;perform sword.nizhuan;perform sword.jianquan;perform sword.daoluanren;jifa sword huashan-jianfa;jifa parry huashan-jianfa;jiali max;perform sword.luomu;perform sword.cangsong;yun yujianshi;yun refresh;jiali 1
	]]
	pfm=string.gsub(pfm,"perform sword.nizhuan;","")
	pfm=string.gsub(pfm,"perform sword.jianquan;","")
	pfm=string.gsub(pfm,"perform sword.daoluanren;","")

	return pfm
end

function alias:block_kill(id,f,is_end)
    --local pfm=world.GetVariable("pfm") or ""
    --world.Send("alias pfm "..pfm)
	    local pfm=world.GetVariable("pfm") or ""
		pfm=convert_pfm(pfm)
	    world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
		world.Send("set wimpy 100")
     world.Send("kill "..id)

      wait.make(function()
       local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾�����.*|^(> |)����û������ˡ�$",15)
	   if l==nil then
	      self:block_kill(id,f,is_end)
		  return
	   end
	   if string.find(l,"�����ų鶯�˼��¾�����") or (string.find(l,"����û�������") and is_end==true) then
	     world.Send("unset wimpy")
         local b=busy.new()
         b.interval=0.3
         b.Next=function()
		   f()
		 end
		 b:check()
		 return
	   end
	   if string.find(l,"����û�������") and is_end==false then
		  world.Send("unset wimpy")
	      self:compare(f)
		  return
	   end
	   wait.time(15)
	  end)
end

function alias:get_break_npc()
   local npc,is_end=break_npc()
   return npc
end

function alias:compare(CallBack)
   local npc,is_end=break_npc()
   wait.make(function()
     world.Send("compare "..npc)
	 --world.AppendToNotepad (WorldName().."_��·NPC:",os.date()..": NPC:"..npc.."\r\n")
	 local l,w=wait.regexp("^(> |)"..npc.." ��������$|^(> |)��о�.*�����Ǹ������, ������мһ�ˡ�$|^(> |)�۹�������, .*����������������Ķ���!$|^(> |)��Ҫɱ��.*����Ҫ�������ϰ����ס�$|^(> |)��Ȼ�Ӹ����濴���㶼��.*��ʤһ��, ����Ҳ������С�$|���Ա�����Ϊ�ж�.*�ļ�����",5)
	  if l==nil then
	     self:compare(CallBack)
	     return
	  end
	  if string.find(l,"��������") or string.find(l,"������мһ��") or string.find(l,"������Ķ���") or string.find(l,"�������ϰ�����") or string.find(l,"����Ҳ�������") then
	      self:block_kill(npc,CallBack,is_end)
	      return
	  end
	  if string.find(l,"���Ա�����Ϊ�ж�") then
	      world.Send("unset wimpy")
	      print("�򲻹� ����!!")
	     self.break_in_failure(CallBack)
	     return
	  end

   end)
end

function alias:PreCompare(success,failure)
   print("PreCompare!!!!")
   local npc,is_end=break_npc()
   wait.make(function()
     world.Send("compare "..npc)
	 --world.AppendToNotepad (WorldName().."_��·NPC:",os.date()..": NPC:"..npc.."\r\n")
	 local l,w=wait.regexp("^(> |)"..npc.." ��������$|^(> |)��о�.*�����Ǹ������, ������мһ�ˡ�$|^(> |)�۹�������, .*����������������Ķ���!$|^(> |)��Ҫɱ��.*����Ҫ�������ϰ����ס�$|^(> |)��Ȼ�Ӹ����濴���㶼��.*��ʤһ��, ����Ҳ������С�$|���Ա�����Ϊ�ж�.*�ļ�����",5)
	  if l==nil then
	     self:PreCompare(success,failure)
	     return
	  end
	  if string.find(l,"��������") or string.find(l,"������мһ��") or string.find(l,"������Ķ���") or string.find(l,"�������ϰ�����") or string.find(l,"����Ҳ�������") then
	      success()
	      return
	  end
	  if string.find(l,"���Ա�����Ϊ�ж�") then
	      world.Send("unset wimpy")
	      print("�򲻹� ����!!")
	     failure()
	     return
	  end

   end)
end

function alias:break_in(id,CallBack)
   print("break in")
   world.Send("yun recover")
   world.Send("yun refresh")
   self:compare(CallBack)
end


function alias:yamen_cucangshi()
-- 247
   world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2285 then
	   self:finish()
	 elseif roomno[1]==247 then
        --npc block
		local f
		f=function()
		  self:yamen_cucangshi()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamen_cucangshi()
		end
		w:go(247)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
   --2285
end

function alias:yamen_zhengting()
--247
   world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2286 then
	   self:finish()
	 elseif roomno[1]==247 then
        print("npc block")
		local f
		f=function()
		  self:yamen_zhengting()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamen_zhengting()
		end
		w:go(247)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
   --2286
end

function alias:changan_bingyingdamen_bingying()
   --1082  -  2275
    world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==936 then
	   self:finish()
	 elseif roomno[1]==935 then
        --npc block
		local f
		f=function()
		  self:changan_bingyingdamen_bingying()
		end
		break_npc=break_npc_id("guan bing")
        self:break_in("guan bing",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changan_bingyingdamen_bingying()
		end
		w:go(935)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:bingyingdamen_bingying()
   --1082  -  2275
    world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2275 then
	   self:finish()
	 elseif roomno[1]==1082 then
        --npc block
		local f
		f=function()
		  self:bingyingdamen_bingying()
		end
		break_npc=break_npc_id("guan bing")
        self:break_in("guan bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:bingyingdamen_bingying()
		end
		w:go(1082)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:outwuguan()
     world.Send("ask sun about ���")
	 local b=busy.new()
	 b.Next=function()
	   world.Send("out")
	   self:finish()
	 end
	 b:check()
end

function alias:jumpwell()
   world.Send("jump well")
   self:finish()
end

function alias:pullhuan()
   world.Send("pull huan")
   world.Send("down")
   self:finish()
end

function alias:xieketing_rimulundian()
--1691 enter 2271
   --print("���bug")
   world.Send("open door")
   world.Send("enter")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2271 then
	   self:finish()
	 elseif roomno[1]==1691 then
        --npc block
		local f
		f=function()
		  self:xieketing_rimulundian()
		end
		break_npc=break_npc_id("hufa lama")
        self:break_in("hufa lama",f)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xieketing_rimulundian()
		end
		w:go(1691)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:rimulundian_yueliangmen()
--1691 enter 2271
   world.Send("west")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2711 then
	   self:finish()
	 elseif roomno[1]==2271 then
        --npc block
		local f
		f=function()
		  self:rimulundian_yueliangmen()
		end
		break_npc=break_npc_id("hufa lama")
        self:break_in("hufa lama",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:rimulundian_yueliangmen()
		end
		w:go(2271)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:rimulundian_zhaitang()
--1691 enter 2271
   world.Send("southeast")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2885 then
	   self:finish()
	 elseif roomno[1]==2271 then
        --npc block
		local f
		f=function()
		  self:rimulundian_zhaitang()
		end
		break_npc=break_npc_id("hufa lama")
        self:break_in("hufa lama",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:rimulundian_zhaitang()
		end
		w:go(2271)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:nanmen_chengzhongxin()
--1972 _ 2349

   world.Send("north")
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2349 then
	     self:finish()
	   elseif roomno[1]==1972 then
		  local f=function()
		    self:nanmen_chengzhongxin()
		  end
		  f_wait(f,10)
	   else
	     local f=function()
            local w
		    w=walk.new()
		    w.user_alias=self
		    w.walkover=function()
		     self:nanmen_chengzhongxin()
		    end
		    w:go(1972)
	      end
		  self:redo(f)
        end --if
	  end   --function
	 _R:CatchStart()
end

function alias:chengzhongxin_nanmen()
--2349 _ 1972
   world.Send("south")
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1972 then
	     self:finish()
	   elseif roomno[1]==2349 then
		  local f=function()
		    self:chengzhongxin_nanmen()
		  end
		  f_wait(f,10)
	   else
	     local f=function()
            local w
		    w=walk.new()
	  	    w.user_alias=self
		    w.walkover=function()
		      self:finish()
		    end
	  	    w:go(1972)
	      end
		  self:redo(f)
       end
	  end
       _R:CatchStart()
end
--��ʥ�¡�����ʯ· 1604
function alias:baishilu_tianwangdian() --1611_2276 northup
    world.Send("northup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1699 then
	   self:finish()
	 elseif roomno[1]==1604 then
        --npc block
		local f
		f=function()
		  self:baishilu_tianwangdian()
		end
		-- �����µ�ʮ�Ĵ����ӡ�©�����ߡ��˻���ʦ(Liaohuo chanshi)
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
		local f=function()
         local w
		 w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:baishilu_tianwangdian()
		 end
		 w:go(1604)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--��ʯ·--����Ժ  1604--1605
function alias:baishilu_banzuyuan()
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1605 then
	   self:finish()
	 elseif roomno[1]==1604 then
        --npc block
		local f
		f=function()
		  self:baishilu_banzuyuan()
		end
		-- �����µ�ʮ�Ĵ����ӡ�©�����ߡ��˻���ʦ(Liaohuo chanshi)
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:baishilu_banzuyuan()
		end
		w:go(1604)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--��ʯ·--����Ժ  1604--1692
function alias:baishilu_songshuyuan()
  world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1692 then
	   self:finish()
	 elseif roomno[1]==1604 then
        --npc block
		local f
		f=function()
		  self:baishilu_songshuyuan()
		end
		-- �����µ�ʮ�Ĵ����ӡ�©�����ߡ��˻���ʦ(Liaohuo chanshi)
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:baishilu_songshuyuan()
		end
		w:go(1604)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--1611 �嶼��̨ -
-- �����µ�ʮ�Ĵ����ӡ���Ϊ���ߡ�������ʦ(Liaoqing chanshi)
function alias:qingduyaotai_baishilu() --1611_2276 northup
   --print("qingduyaotai_baishilu() --1611_2276 northup")
    world.Send("northup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2276 then
	   self:finish()
	 elseif roomno[1]==1611 then
        --npc block
		local f
		f=function()
		  self:qingduyaotai_baishilu()
		end
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:qingduyaotai_baishilu()
		end
		w:go(1611)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--1611_2283
function alias:qingduyaotai_banruotai() --1611_2276 northup
    world.Send("eastup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2283 then
	   self:finish()
	 elseif roomno[1]==1611 then
        --npc block
		local f
		f=function()
		  self:qingduyaotai_banruotai()
		end
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:qingduyaotai_banruotai()
		end
		w:go(1611)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:circle_done(alias_name) --�ص�����
  -- print("����4",alias_name," ",self.alias_table[alias_name].is_search)
    self.maze_step=function()
      local f=function()
        coroutine.resume(alias.circle_co,true)
      end
      f_wait(f,0.1)
   end
   if self.alias_table[alias_name].is_search==true then
      self:maze_done()
   else
      self.maze_step()
   end
end
--[[
function alias:xingxiuhai_circle()
   --���޺�ѭ������
--   roomno	linkroomno	direction
--1965	2369	east
--1965	2370	north
--1965	2371	west
--1965	2372	south
--1965	2373	east
--1965	2374	north
--1965	2375	west
--1965	2376	south
--1965	2377	east
--1965	2378	west
--1965	2379	north
--1965	2380	north
--1965	2381	north
--1965	2382	south
--1965	2383	south
--e;n;w;s;e;n;w;s;e;w;n;n;n;s;s
   --print("����")
   local p={"n","w","n","e","n","s","n","n","w","e","s"}
   alias.circle_co=coroutine.create(function()
      --print("����3")
      for _,i in ipairs(p) do

	     world.Send(i)
		 print("ͣ��������")
         self:circle_done()
	     coroutine.yield()
	  end
	  self:finish()
   end)
  --print("����2")
   coroutine.resume(alias.circle_co)
end]]
local dx="n"
function alias:xingxiuhai_search()
    self.maze_step=function()
       world.Send(dx)
       if dx=="n" then
	    dx="e"
	   else
	    dx="n"
	   end
	   self:finish()
   end
   if self.alias_table["xingxiuhai_search"].is_search==true then
     self:maze_done()
   else
      self.maze_step()
   end
end

function alias:xingxiuhai_south(c)
--1965_1964
--[[local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1964 then
	   self:finish()
	 elseif roomno[1]==1965 then
	   if d==nil then
	     local dx={"south"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
		 local f2=function()
		     self:xingxiuhai_south(d)
		 end
         self.maze_done(f2)
	   end
	   f_wait(f,0.2)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xingxiuhai_south()
		end
		w:go(1965)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]
   if c==nil then c=1 end
   if c>10 then
      self:finish()
	  return
   end
     world.Send("south")
	 world.Send("set action ���޺�")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)���۵ð���������߳������޺���$|^(> |)�趨����������action \\= \\\"���޺�\\\"",5)
	    if l==nil then
		  self:xingxiuhai_south(c)
		  return
		end
		if string.find(l,"���۵ð���������߳������޺�") then
		   self:finish()
		   return
		end
		if string.find(l,"���޺�") then
		  self.maze_step=function()
		    c=c+1
		    self:xingxiuhai_south(c)
		  end
		  --print("xingxiuhai_south:", self.alias_table["xingxiuhai_south"].is_search)
		  if self.alias_table["xingxiuhai_south"].is_search==true then
		      self:maze_done()
		  else
		      self.maze_step()
		  end
		  return
		end

	 end)

end

function alias:xingxiuhai_north(c)
--1965_1967
--[[local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1967 then
	   self:finish()
	 elseif roomno[1]==1965 then
	   if d==nil then
	     local dx={"north"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
		  local f2=function()
		     self:xingxiuhai_north(d)
		 end
         self.maze_done(f2)
	   end
	   f_wait(f,0.2)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xingxiuhai_north()
		end
		w:go(1965)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]

     if c==nil then c=1 end
   if c>10 then
      self:finish()
	  return
   end
     world.Send("north")
	 world.Send("set action ���޺�")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)���۵ð���������߳������޺���$|^(> |)�趨����������action \\= \\\"���޺�\\\"",5)
	    if l==nil then
		  self:xingxiuhai_north(c)
		  return
		end
		if string.find(l,"���۵ð���������߳������޺�") then
		   self:finish()
		   return
		end
		if string.find(l,"���޺�") then
		  self.maze_step=function()
		    c=c+1
		    self:xingxiuhai_north(c)
		  end
		  --print("xingxiuhai_north:",self.alias_table["xingxiuhai_north"].is_search)
		  if self.alias_table["xingxiuhai_north"].is_search==true then
		    self:maze_done()
		  else
		    self.maze_step()
		  end
		  return
		end

	 end)

end

function alias:xingxiuhai_east(c)
--1965_2235
--[[local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2235 then
	   self:finish()
	 elseif roomno[1]==1965 then
	   if d==nil then
	     local dx={"east"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         local f2=function()
		     self:xingxiuhai_east(d)
		 end
         self.maze_done(f2)
	   end
	   f_wait(f,0.2)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xingxiuhai_east()
		end
		w:go(1965)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]
     if c==nil then c=1 end
   if c>10 then
      self:finish()
	  return
   end
     world.Send("east")
	 world.Send("set action ���޺�")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)���۵ð���������߳������޺���$|^(> |)�趨����������action \\= \\\"���޺�\\\"",5)
	    if l==nil then
		  self:xingxiuhai_east(c)
		  return
		end
		if string.find(l,"���۵ð���������߳������޺�") then
		   self:finish()
		   return
		end
		if string.find(l,"���޺�") then
		  --print("����1")
		  self.maze_step=function()

		      --print("�ص�hansh east")
		      c=c+1
		       self:xingxiuhai_east(c)
		  end
		  if self.alias_table["xingxiuhai_east"].is_search==true then
		    --print(self.alias_table["xingxiuhai_east"].is_search," true")
		    self:maze_done()
		  else
		    --print("ֱ��ִ��")
		    self.maze_step()
		  end
		  return
		end

	 end)

end

function alias:xingxiuhai_west(c)
--1965,2233
--[[local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2233 then
	   self:finish()
	 elseif roomno[1]==1965 then
	   if d==nil then
	     local dx={"west"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
          local f2=function()
		     self:xingxiuhai_west(d)
		 end
         self.maze_done(f2)
	   end
	   f_wait(f,0.2)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xingxiuhai_west()
		end
		w:go(1965)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]
     if c==nil then c=1 end
   if c>10 then
      self:finish()
	  return
   end
     world.Send("west")
	 world.Send("set action ���޺�")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)���۵ð���������߳������޺���$|^(> |)�趨����������action \\= \\\"���޺�\\\"",5)
	    if l==nil then
		  self:xingxiuhai_west(c)
		  return
		end
		if string.find(l,"���۵ð���������߳������޺�") then
		   self:finish()
		   return
		end
		if string.find(l,"���޺�") then
		  self.maze_step=function()
		    c=c+1
		    self:xingxiuhai_west(c)
		  end
		  if self.alias_table["xingxiuhai_west"].is_search==true then
		    self:maze_done()
		  else
		    self.maze_step()
		  end
		  return
		end

	 end)

end

function alias:shanmen_shanlu()
--240_243
  world.Send("northup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==243 then
	   self:finish()
	 elseif roomno[1]==240 then
        --npc block
		local f
		f=function()
		  self:shanmen_shanlu()
		end
		break_npc=break_npc_id("bangzhong")
        self:break_in("bangzhong",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanmen_shanlu()
		end
		w:go(240)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:jiayuguanximen_yanmenguan()
--1861
 local f2=function()
   world.Send("say �ù�����·")
 world.Send("get gold from corpse")
 world.Send("get silver from corpse")
 world.Send("eastup")
 --�����ɵ�self.break_in_failure
 --local old_function=self.break_in_failure
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1860 then
	   --self.break_in_failure=old_function
	   self:finish()
	 elseif roomno[1]==1861 then
        --npc block
		local f
		f=function()
		  self:jiayuguanximen_yanmenguan()
		end
		break_npc=break_npc_id("guan bing")
		--[[self.break_in_failure=function(f)
		  local f=function()
		    self:jiayuguanximen_yanmenguan()
		   end
		   print("2s �ٱ����¼��")
		   f_wait(f,2)
		end]]
        self:break_in("guan bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jiayuguanximen_yanmenguan()
		end
		w:go(1861)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
  end
  break_npc=break_npc_id("guan bing")
  --self.break_in_failure=function()
  --	  f2()
  --end
  self:break_in("guan bing",f2)
end

function alias:jiayuguanximen_sichouzhilu()
  local f2=function()
    world.Send("say �ù�����·")
  world.Send("get gold from corpse")
  world.Send("get silver from corpse")
  world.Send("west")
  --�����ɵ�self.break_in_failure
  --local old_function=self.break_in_failure
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1862 then
	   --self.break_in_failure=old_function
	   self:finish()
	 elseif roomno[1]==1861 then
        --npc block
		local f
		f=function()
		  self:jiayuguanximen_sichouzhilu()
		end
		break_npc=break_npc_id("guan bing")

		--�µ�ֵ
		--[[self.break_in_failure=function()
		   print("2s �ٱ����¼��")
		   local f=function()
		     self:jiayuguanximen_sichouzhilu()
		   end
		   f_wait(f,2)
		end]]
        self:break_in("guan bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jiayuguanximen_sichouzhilu()
		end
		w:go(1861)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
   end
    break_npc=break_npc_id("guan bing")
	--self.break_in_failure=function()
	--	f2()
	--end
    self:break_in("guan bing",f2)
end

function alias:wangfudating_changlang()
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==480 then
	   self:finish()
	 elseif roomno[1]==445 then
        --npc block
		local f
		f=function()
		  self:wangfudating_changlang()
		end
		break_npc=break_npc_id("bing")
        self:break_in("bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wangfudating_changlang()
		end
		w:go(445)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wangfudating_changlang2()
  world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==468 then
	   self:finish()
	 elseif roomno[1]==445 then
        --npc block
		local f
		f=function()
		  self:wangfudating_changlang2()
		end
		break_npc=break_npc_id("bing")
        self:break_in("bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wangfudating_changlang2()
		end
		w:go(445)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:lianwuchang_guangchang()
--������ 2171_2240
  world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2240 then
	   self:finish()
	 elseif roomno[1]==2171 then
        --npc block
		local f
		f=function()
		  self:lianwuchang_guangchang()
		end
		break_npc=break_npc_id("yin wushou")
        self:break_in("yin wushou",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:lianwuchang_guangchang()
		end
		w:go(2171)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:lianwuchang_zoulang1()
--������ 2171_2240
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2172 then
	   self:finish()
	 elseif roomno[1]==2171 then
        --npc block
		local f
		f=function()
		  self:lianwuchang_zoulang1()
		end
		break_npc=break_npc_id("yin wushou")
        self:break_in("yin wushou",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:lianwuchang_zoulang1()
		end
		w:go(2171)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:lianwuchang_zoulang2()
--������ 2171_2240
  world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2180 then
	   self:finish()
	 elseif roomno[1]==2171 then
        --npc block
		local f
		f=function()
		  self:lianwuchang_zoulang2()
		end
		break_npc=break_npc_id("yin wushou")
        self:break_in("yin wushou",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:lianwuchang_zoulang2()
		end
		w:go(2171)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:yamenzhenting_fuyahouyuan()
 world.Send("northwest")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2750 then
	   self:finish()
	 elseif roomno[1]==1005 then
        --npc block
		local f
		f=function()
		  self:yamenzhenting_fuyahouyuan()
		end
		break_npc=break_npc_id("da yayi")
        self:break_in("da yayi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamenzhenting_fuyahouyuan()
		end
		w:go(1005)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--���Ŵ��� ��������
function alias:yamendamen_yamenzhengting()
  world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1546 then
	   self:finish()
	 elseif roomno[1]==1545 then
        --npc block
		local f
		f=function()
		  self:yamendamen_yamenzhengting()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamendamen_yamenzhengting()
		end
		w:go(1545)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:yamendamen_menlang()
  world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1008 then
	   self:finish()
	 elseif roomno[1]==61 then
        --npc block
		local f
		f=function()
		  self:yamendamen_menlang()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamendamen_menlang()
		end
		w:go(61)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:qianting_shilu()
--�����: 2219_2220
   world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2220 then
	   self:finish()
	 elseif roomno[1]==2219 then
        --npc block
		local f
		f=function()
		  self:qianting_shilu()
		end
		break_npc=break_npc_id("xi huazi")
        self:break_in("xi huazi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:qianting_shilu()
		end
		w:go(2219)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wuzhitang_houxiangfang()
 --[[2390
                     ���᷿
                             ��
                   ����--  ��ָ��--����
                             ��
                            �㳡
��ָ�� -
  ���³��ϡ�������ӥ��������(Hong xiaotian)

roomno	linkroomno	direction
2390	2389	north
2390	2416	east
2390	2421	west
  ]]
    world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2389 then
	   self:finish()
	 elseif roomno[1]==2390 then
        --npc block
		local f
		f=function()
		  self:wuzhitang_houxiangfang()
		end
		break_npc=break_npc_id("hong xiaotian")
        self:break_in("hong xiaotian",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wuzhitang_houxiangfang()
		end
		w:go(2390)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wuzhitang_east_zoulang()
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2416 then
	   self:finish()
	 elseif roomno[1]==2390 then
        --npc block
		local f
		f=function()
		  self:wuzhitang_east_zoulang()
		end
		break_npc=break_npc_id("hong xiaotian")
        self:break_in("hong xiaotian",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wuzhitang_east_zoulang()
		end
		w:go(2390)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wuzhitang_west_zoulang()
  world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2421 then
	   self:finish()
	 elseif roomno[1]==2390 then
        --npc block
		local f
		f=function()
		  self:wuzhitang_west_zoulang()
		end
		break_npc=break_npc_id("hong xiaotian")
        self:break_in("hong xiaotian",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wuzhitang_west_zoulang()
		end
		w:go(2390)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wuliangjianzong_shibanlu()
  world.Send("enter")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1928 then
	   self:finish()
	 elseif roomno[1]==604 then
        --npc block
		local f
		f=function()
		  self:wuliangjianzong_shibanlu()
		end
		break_npc=break_npc_id("wu guangsheng|yu guangbiao")
        self:break_in("wu guangsheng|yu guangbiao",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wuliangjianzong_shibanlu()
		end
		w:go(604)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--604
--  ���������ڵ��� ���ʤ(Wu guangsheng)
--  ���������ڵ��� �����(Yu guangbiao)
function alias:shibanlu_jianhugong()
--1928_2411
 world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2411 then
	   self:finish()
	 elseif roomno[1]==1928 then
        --npc block
		local f
		f=function()
		  self:shibanlu_jianhugong()
		end--���Ӿ�
		break_npc=break_npc_id("rong ziju")
        self:break_in("rong ziju",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shibanlu_jianhugong()
		end
		w:go(1928)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:dacaoyuan_yingmen()
    local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2435  then
	   self:finish()
	 elseif roomno[1]==2434 then
	     if _R.relation=="�ݺ����ݺ����ݺ����ݺ�����ԭ" then
           local p={"west","east","north","north","west","east"}
      alias.circle_co=coroutine.create(function()
      for _,i in ipairs(p) do
	     world.Send(i)
         self:circle_done("dacaoyuan_yingmen")
	     coroutine.yield()
	  end
	  self:finish()
   end)
   coroutine.resume(alias.circle_co)
		   return
		end
	 elseif roomno[1]==2630 then
	   if _R.relation=="�ݺ����������󩤲ݺ�������" then
		   world.Send("east")
           self:dacaoyuan_yingmen()
		   return
		end
	elseif roomno[1]==2617 then
		if _R.relation=="�ݺ��������������������" then
		   world.Send("north")
           self:dacaoyuan_yingmen()
		   return
		end
	elseif roomno[1]==2641 then
		if _R.relation=="������������󩤲ݺ����ݺ�" then
		   world.Send("east")
           self:dacaoyuan_yingmen()
		   return
		end
	 elseif roomno[1]==2439 then
        local dx={} --,"north"
		if _R.relation=="�ݺ������󩤲ݺ����ݺ����ݺ�" then--caihai2 or caihao3
		   dx={"east","north","north","west","east"}
		end
		if _R.relation=="�ݺ������󩤲ݺ����ݺ�������" then  --caihao4
		   dx={"north","west","east"}
		end
		if _R.relation=="�ݺ����ݺ����ݺ����ݺ�������" then  --caihao5
		  dx={"west","east"}
		end
		if _R.relation=="�ݺ������󩤲ݺ���Ӫ�ţ��ݺ�" then --caihao6
		  dx={"east"}
		end

		alias.circle_co=coroutine.create(function()
          --print("����3")
          for j,i in ipairs(dx) do
			--print(j.."/13 ����:",i)
	       world.Send(i)
           self:circle_done("dacaoyuan_yingmen")
	       coroutine.yield()
	      end
	      self:dacaoyuan_yingmen()
        end)
		coroutine.resume(alias.circle_co)

	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dacaoyuan_yingmen()
		end
		w:go(2439)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end


function alias:ruhuanggong()
    local w
	w=walk.new()
	w.walkover=function()
		world.Send("ask gao about ��ʹ�")
		wait.make(function()
		  local l,w=wait.regexp("^(> |)����̩˵������.*���㲻�Ǳ�������ӣ��˻��Ӻ�˵�𣿡�|^(> |)����̩˵������.*ֻҪ˵�����������ģ��Ϳ����빬�ˡ���$|^(> |)����̩˵�������ҿ���Ϊ���������������Ļ���������Ŭ�����ɣ���$",5)
		  if l==nil then
		    self:ruhuanggong()
			return
		  end
		  if  string.find(l,"�ҿ���Ϊ���������������Ļ�������") then
		     self:finish()
	         return
	      end
		  if string.find(l,"�㲻�Ǳ��������") then

		   local w1
           w1=walk.new()
           w1.walkover=function ()
	           wait.make(function()
	           world.Send("ask fu about join")
		        local l,w=wait.regexp("^(> |)��˼��˵�������ã�������λ.*����Ϊ�����������ˡ���$|^(> |)��˼��˵������.*�Ѿ��Ǳ���������ˣ��ιʻ�Ҫ��������Ц����$",5)
		       if l==nil then
                print("����̫�����Ƿ�����һ����Ԥ�ڵĴ���")
		        self:ruhuanggong()
		        return
			   end
		       if string.find(l,"����Ϊ�����������ˡ�") or string.find(l,"�Ѿ��Ǳ����������") then
		          local b
		      	   b=busy.new()
			       b.interval=0.3
				   b.Next=function()
			         self:ruhuanggong()
			       end
			       b:check()
		          return
			   end
		     wait.time(5)
	       end)
         end
		   local b=busy.new()
		   b.Next=function()
              w1:go(445)
		   end
           b:check()
		    return
		  end
		  if string.find(l,"������������") then
			local b
		     b=busy.new()
		    b.interval=0.3
		    b.Next=function()
		    local w1=walk.new()
		     w1.walkover=function()
		       self:huanggongzhengting_zoulang()
		    end
		    w1:go(507)
		    end
		    b:check()
		    return
		  end
		  wait.time(5)
		end)
	end
	w:go(466)
end

function alias:halt_northwest()
  local b=busy.new()
  b.interval=0.4
  b.Next=function()
     world.Send("northwest")
	 self:finish()
  end
  b:check()
end

function alias:huanggongzhengting_zoulang()
   world.Send("north")
   _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1083  then
	   self:finish()
	 elseif roomno[1]==507 then
	   self:ruhuanggong()
	 else
		local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:huanggongzhengting_zoulang()
		end
		w:go(507)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

local jiugong={}
function alias:kick_out(current_roomno,is_ok)
   print("�����ж���������ǰ")
   for j,e in ipairs(jiugong) do
      print("�����:",e)
   end
   print("----------------")
   local room_index
   for i,c in ipairs(jiugong) do
       room_index=i
       if c==current_roomno then
	     if is_ok==true then
	      table.remove(jiugong,i)
		 else
		  room_index=i+1
		 end
		 break
	   end
	end
	--print("why",table.getn(jiugong)," ",room_index)
	--��һ��
	if table.getn(jiugong)>=room_index then
		     print("��һ��")
			 return jiugong[room_index]
	    elseif table.getn(jiugong)==0 then
			 jiugong={}
			 jiugong={2490,2491,2492,2493,2494,2495,2496,2497,2498}
			 print("���һ���Ŀ���в²�:",self.carry_taohua)
			 if self.carry_taohua==4 then
			    return(2492)
			 elseif self.carry_taohua==9 then
			    return(2493)
			 elseif self.carry_taohua==2 then
			    return(2494)
			 elseif self.carry_taohua==3 then
			    return(2491)
             elseif	self.carry_taohua==5 then
			    return(2498)
			 elseif	self.carry_taohua==7 then
			     return(2495)
			 elseif	self.carry_taohua==8 then
			    return(2490)
		elseif	self.carry_taohua==1 then
			    return(2497)
		elseif	self.carry_taohua==6 then
			    return(2496)
		elseif self.carry_taohua==0 then
			    print("�ߵ��ף�������")
			    return 2490
		end
	else
		print("error")
		return jiugong[1]
	end
end

function alias:out_taohuazhen(current_roomno,targetRoomNo)
      local mp=map.new()
		mp.Search_end=function(path,room_type)
		  world.Execute(path)
		  print("�鿴����!")
		  local f1=function()
		     self:taohuazhen()
		  end
		  f_wait(f1,1)
		end
		print("��ѯ��·:",current_roomno,"->",targetRoomNo)
	    mp:Search(current_roomno,targetRoomNo,nil)
end

function alias:is_out_taohuazhen(current_roomno,targetRoomNo)
    wait.make(function()
	   local l,w=wait.regexp("�һ����к�Ȼ����һ��������������������ֳ�һ����·�����æ���˳�ȥ��|^(> |)�趨����������taohua \\= \\\"YES\\\"$",3)
	   if l==nil then
	      world.Send("set taohua")
		  world.Send("unset taohua")
		  self:is_out_taohuazhen(current_roomno,targetRoomNo)
		  return
	   end
	   if string.find(l,"�趨����������taohua") then
	      self:out_taohuazhen(current_roomno,targetRoomNo)
		  return
	   end
	   if string.find(l,"���æ���˳�ȥ") then
		  print("�߳��һ��֣���������"," �ص�")
	      self:finish()
	      return
	   end

	   wait.time(3)
	end)
end
function alias:taohuazhen()
--   4 9 2������������������5 5 5
--   3 5 7���������򡡡�����5 5 5��
--   8 1 6������������������5 5 5
--�һ����к�Ȼ����һ��������������������ֳ�һ����·�����æ���˳�ȥ��
--�㶪��һ���һ���
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     print("������:",_R.roomname)
     local num=0
	 if _R.roomname=="�Ź��һ���"  then
		local taohua
		local current_roomno
		local targetRoomNo
	    if _R.exits=="east;south;" then
		--4
		   current_roomno=2492
		   taohua=4
		elseif _R.exits=="east;south;west;" then
		--9
		   current_roomno=2493
           taohua=9
		elseif _R.exits=="south;west;" then
		--2
		   current_roomno=2494
           taohua=2
		elseif _R.exits=="east;north;south;" then
		--3
		   current_roomno=2491
           taohua=3
		elseif _R.exits=="north;west;" then
		--6
		   current_roomno=2496
           taohua=6
		elseif _R.exits=="east;north;" then
		--8
		   current_roomno=2490
           taohua=8
		elseif _R.exits=="east;north;west;" then
		--1
		   current_roomno=2497
           taohua=1
	    elseif _R.exits=="east;north;south;west;" then
		--5
		   current_roomno=2498
           taohua=5
		elseif _R.exits=="north;south;west;" then
		--7
		   current_roomno=2495
           taohua=7
		end
		 if string.find(_R.description,"Ҳû��") then
		    num=0
		 else
		    local _,_,chinese_num=string.find(_R.description,"����һƬï�ܵ��һ��ԣ���һ�߽�������ʧ�˷��򡣵�����(.*)���һ�.*")
			 print(chinese_num)
			num= ChineseNum(chinese_num)
		 end
		 print("��ǰ�����:",current_roomno," �˶��һ���Ŀ:",taohua," Ŀǰ�һ���Ŀ:",num)
		 local target_roomno
		 if self.carry_taohua==nil then
		    self.carry_taohua=0
		 end
		 if  table.getn(jiugong)==0 then
		    jiugong={2490,2491,2492,2493,2494,2495,2496,2497,2498}
		 end
		  print("Я���һ���ǰ:",self.carry_taohua)
		if num>taohua then
		 print("����")
		 world.Send("get "..num-taohua.." taohua")
		 self.carry_taohua=self.carry_taohua+num-taohua
		 targetRoomNo=self:kick_out(current_roomno,true)
		 print("Я���һ�����:",self.carry_taohua)
		 self:out_taohuazhen(current_roomno,targetRoomNo)
			--�Ƴ� targetRooms
	    elseif num<taohua then
		 print("����")
		 if self.carry_taohua>=taohua-num then
		    print("Я���㹻",self.carry_taohua," ",taohua-num)
		     self.carry_taohua=self.carry_taohua-taohua+num
			 targetRoomNo=self:kick_out(current_roomno,true)
			 world.Send("drop "..taohua-num.." taohua")
			 if self.carry_taohua==0 then
			    print("����Ƿ����")
				--�һ����к�Ȼ����һ��������������������ֳ�һ����·�����æ���˳�ȥ��
				self:is_out_taohuazhen(current_roomno,targetRoomNo)
			 else
                 self:out_taohuazhen(current_roomno,targetRoomNo)
			 end
		 else
			print("����")
	         world.Send("get "..num.." taohua")
		     self.carry_taohua=self.carry_taohua+num
			 targetRoomNo=self:kick_out(current_roomno,false)
			 print("Я���һ�����:",self.carry_taohua)
		     self:out_taohuazhen(current_roomno,targetRoomNo)
		 end
	    else
	      print("����")
		  targetRoomNo=self:kick_out(current_roomno,true)
		  print("Я���һ�����:",self.carry_taohua)
		  self:out_taohuazhen(current_roomno,targetRoomNo)
		end
	 else
	   local count,roomno=Locate(_R)
	   print("��ǰ�����",roomno[1])
	   if roomno[1]==self.out_exit  then
	      self:finish()
	   else
	      local f=function()
		  local w2
		  w2=walk.new()
		  w2.user_alias=self
		  w2.walkover=function()
		   self:finish()
		  end
		   print(self.out_exit," ����")
		  w2:go(self.out_exit)
		  end
		  self:redo(f)
		end
	 end
   end
  _R:CatchStart()
end

function alias:east_taohuazhen()
   world.Send("east")
   jiugong={2490,2491,2492,2493,2494,2495,2496,2497,2498}
   self.carry_taohua=0
   self.out_exit=1848
   self:taohuazhen()
end

function alias:west_taohuazhen()
   world.Send("west")
   jiugong={2490,2491,2492,2493,2494,2495,2496,2497,2498}
   self.carry_taohua=0
   self.out_exit=2476
   self:taohuazhen()
end

function alias:reset_taohuazhen()
   self.carry_taohua=0
   wait.make(function()
	 world.Send("drop 1 taohua")
     local l,w=wait.regexp("^(> |)������û������������$|^(> |)�㶪��һ���һ���$|^(> |)�һ����к�Ȼ����һ��������������������ֳ�һ����·�����æ���˳�ȥ��$",5)
	 if l==nil then
	    self:reset_taohuazhen()
	    return
	 end
	 if string.find(l,"�㶪��һ���һ�") then
	    self:reset_taohuazhen()
	    return
	 end
	 if string.find(l,"������û����������") then
	    self:taohuazhen()
		return
	 end
	 if string.find(l,"���æ���˳�ȥ") then
	    self:finish()
	    return
	 end
	 wait.time(5)
   end)
end
---�Ź��һ���
function alias:waitday_south()
      world.Send("south")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1068 then
	     self:finish()
	   elseif roomno[1]==1065 then
		  local f=function()
		    self:waitday_south()
		  end
		  f_wait(f,10)
	   else
	        local f=function()
            local w
	  	     w=walk.new()
		     w.user_alias=self
		     w.walkover=function()
		       self:waitday_south()
		     end
		     w:go(1065)
		    end
		    self:redo(f)
	    end
       end
       _R:CatchStart()
end



function alias:changjie_changjie()
     world.Send("east")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2509 then
	     self:finish()
	   elseif roomno[1]==217 then
	      self.maze_step=function()
		     self:changjie_changjie()
		  end
	      if self.alias_table["changjie_changjie"].is_search==true then
			  self:maze_done()
		 else
			 self.maze_step()
		  end

	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changjie_changjie()
		end
		w:go(217)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:changjie_nandajie()
      world.Send("west")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==216 then
	     self:finish()
	   elseif roomno[1]==217 then
		  local f=function()
		    self:changjie_nandajie()
		  end
		  f_wait(f,0.5)
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changjie_nandajie()
		end
		w:go(217)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:out_zishanlin()
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
	   --local count,roomno=Locate(_R,10000)
	   --print(roomno[1])
	   if string.find(_R.relation,"��") then
	       world.Send("west")
	       world.Send("southeast")
		   --world.Send("east")
		   self:out_zishanlin()
		elseif string.find(_R.relation,"������") or string.find(_R.relation,"�һ���") then

			local dx={"west","east","west"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("����3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_zishanlin2_quick")
	          coroutine.yield()
		   end
	        self:out_zishanlin()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"�����") or string.find(_R.relation,"��ˮ��") then

		   	local dx={"east","west","east"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("����3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_zishanlin2_quick")
	          coroutine.yield()
		   end
	        self:out_zishanlin()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"��ɼ��")  then
		   world.Send("west")
		   self:finish()
		else
		     local f=function()
		     local w
		     w=walk.new()
			 w.user_alias=self
		     w.walkover=function()
		       self:out_zishanlin()
		     end
		     w:go(2175)
			 end
			 self:redo(f)
	   end
	end
	_R:CatchStart("west")
end

function alias:zishanlin_check()
   local f=function()
     coroutine.resume(alias.zishanlin_co)
   end
   f_wait(f,0.1)
end

function alias:zishanlin_search()--2519 �����

	local dx={"south","south","south","south","south","south","south","south","south"} --,"south"
	alias.zishanlin_co=coroutine.create(function()
		local d
		for j,d in ipairs(dx) do
			 print(j.."/9 ����:",d)
		     world.Send(d)
			 self:zishanlin_check()
			 coroutine.yield()
		end
		print("�ߵ��׽���")
		alias.zishanlin_co=nil
		self:out_zishanlin()

	end)
	coroutine.resume(alias.zishanlin_co)
end


--[[function alias:zishanlin2_check()
    --print("������:",n)
    local f2=function()
	  local f=function()
	  	self:zishanlin_tiandifenglei()
	  end
	  f_wait(f,0.5)
	end
	self.maze_done(f2)
end]]
function alias:zishanlin_zishanlin2_quick()
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
	   --local count,roomno=Locate(_R,10000)
	   --print(roomno[1])
	   if string.find(_R.relation,"��") then
	       world.Send("west")
	       world.Send("southeast")
		   --world.Send("east")
		   self:zishanlin_zishanlin2_quick()
		elseif string.find(_R.relation,"������") or string.find(_R.relation,"�һ���") then

			local dx={"west","east","west"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("����3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_zishanlin2_quick")
	          coroutine.yield()
		   end
	        self:zishanlin_zishanlin2_quick()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"�����") or string.find(_R.relation,"��ˮ��") then

		   	local dx={"east","west","east"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("����3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_zishanlin2_quick")
	          coroutine.yield()
		   end
	        self:zishanlin_zishanlin2_quick()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"��ɼ��")  then
		   world.Send("west")
		   self:finish()
		else
		     local f=function()
		     local w
		     w=walk.new()
			 w.user_alias=self
		     w.walkover=function()
		       self:zishanlin_zishanlin2_quick()
		     end
		     w:go(2175)
			 end
			 self:redo(f)
	   end
	end
	_R:CatchStart("west")
end

function alias:zishanlin_tiandifenglei_quick()
--2175 ������ w
--2455 ����� e
--2173 ��ˮ�� e
--2178 �һ��� w
--3041
   -- world.Send("west")
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
	   --local count,roomno=Locate(_R,10000)
	   --print(roomno[1])
	   if string.find(_R.relation,"��") then
	       world.Send("west")
		   self:finish()
		elseif string.find(_R.relation,"������") or string.find(_R.relation,"�һ���") then
		 	local dx={"west","east","west"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("����3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_tiandifenglei_quick")
	          coroutine.yield()
		   end
	        self:zishanlin_tiandifenglei_quick()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"�����") or string.find(_R.relation,"��ˮ��") then
		 	local dx={"east","west","east"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("����3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_tiandifenglei_quick")
	          coroutine.yield()
		   end
	        self:zishanlin_tiandifenglei_quick()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"��ɼ��")  then
		   world.Send("east")
		   self:zishanlin_tiandifenglei_quick()
		else
		     local f=function()
		     local w
		     w=walk.new()
			 w.user_alias=self
		     w.walkover=function()
		       self:zishanlin_tiandifenglei_quick()
		     end
		     w:go(2175)
			 end
			 self:redo(f)
	   end
	end
	_R:CatchStart("west")
end


--local zishanlin_tiandifenglei_count=0
--[[
function alias:zishanlin_tiandifenglei()
--2464_3041
     local _R
      _R=Room.new()

	   zishanlin_tiandifenglei_count=zishanlin_tiandifenglei_count+1
	   local n=zishanlin_tiandifenglei_count
	  --print(n,"n")
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==3041 then
	     zishanlin_tiandifenglei_count=0
	     self:finish()
	   elseif roomno[1]==2464 then
	     if n>20 then
		   world.Send("north")
		   n=0
		 else
	       world.Send("south")
		 end
		 self:zishanlin2_check()

	   elseif _R.relation=="��ɼ�֣���ˮ�쩤��ɼ�֩���ɼ�֣���ɼ��" or _R.relation=="��ɼ�֣�����쩤��ɼ�֩���ɼ�֣���ɼ��" then
	     if n>20 then
	      world.Send("east")
		  n=0
		 else
		  world.Send("south")
		 end
		 self:zishanlin2_check()

	   elseif _R.relation=="��ɼ�֣���ɼ�֩���ɼ�֩����������ɼ��" or _R.relation=="��ɼ�֣���ɼ�֩���ɼ�֩��һ������ɼ��" then
		 if n>20 then
	      world.Send("west")
		  n=0
		 else
		  world.Send("south")
		 end
		 self:zishanlin2_check()
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zishanlin_tiandifenglei()
		end
		w:go(2464)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end]]

function alias:zishanlin_houtu()
     local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	     if roomno[1]==2464 then
              world.Send("south")
			 self.maze_step=function()
			   self:zishanlin_houtu()
			 end
			 if self.alias_table["zishanlin_houtu"].is_search==true then
			  self:maze_done()
			  else
			   self.maze_step()
			  end
	   elseif roomno[1]==2466 then
			  world.Execute("w;w;w;w;w;w")

		     self:finish()
	   elseif  roomno[1]==2462 then
			 world.Send("east")
		     self:finish()

	   else
		local f=function()
         local w
	 	 w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:finish()
		 end
		 w:go(2462)
		 end
		 self:redo(f)
        end
       end
       _R:CatchStart()
end

function alias:zishanlin_ruijin()
     local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
       if roomno[1]==2464 then
		     world.Send("south")
			 self.maze_step=function()
			   self:zishanlin_ruijin()
			 end
			 if self.alias_table["zishanlin_ruijin"].is_search==true then
			  self:maze_done()
			 else
               self.maze_step()
			 end
	   elseif roomno[1]==2466 then

		     --������쵽��ˮ
			 world.Send("west")
		     self:finish()
	   elseif  roomno[1]==2462 then
			 world.Execute("e;e;e;e;e;e")
		     self:finish()

	   else
	      local f=function()
          local w
		  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		    self:zishanlin_ruijin()
	  	  end
		  w:go(2464)
		  end
		  self:redo(f)
       end
	 end
       _R:CatchStart()
end

function alias:tiandifenglei_out()
--2887 �� 2888 �� 2889 �� 2890 ��
   world.Send("east")
   world.Send("southeast")
    local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
		--���9������
	   if roomno[1]==2466  then
	      self:finish()
	   elseif roomno[1]==2461 or roomno[1]==2462 or roomno[1]==2465 or roomno[1]==2466 then
	      --���¼���·��
		    print("���¼���·��")
	        self:redo()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:tiandifenglei_out()
		end
		w:go(2466)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

local function tiandifenglei(relation,men)
local tian
local di
local feng
local lei
 if relation=="�����ţ������ũ���ɼ�֩������ţ�������" then
   tian="west"
   di="north"
   feng="east"
   lei="south"
 elseif relation=="�����ţ������ũ���ɼ�֩������ţ�������" then
   tian="south"
   di="west"
   feng="north"
   lei="east"
 elseif relation=="�����ţ������ũ���ɼ�֩������ţ�������" then
   tian="east"
   di="south"
   feng="west"
   lei="north"
 elseif relation=="�����ţ������ũ���ɼ�֩������ţ�������" then
   tian="north"
   di="east"
   feng="south"
   lei="west"
 end
 if men=="������" then
    return tian
 elseif men=="������" then
    return di
 elseif men=="������" then
    return feng
 elseif men=="������" then
    return lei
 end
end

function alias:tiandifenglei_tian()
   local _R
	_R=Room.new()
	_R.CatchEnd=function()
		local dx=tiandifenglei(_R.relation,"������")
		world.Send(dx)
		  local _R1
        _R1=Room.new()
        _R1.CatchEnd=function()
         local count,roomno=Locate(_R1)
	     print("��ǰ�����",roomno[1])
	     if roomno[1]==2888 then
	       self:finish()
	     else
		    local f=function()
		  local w
		  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		     self:finish()
		  end
		  w:go(2888)
		  end
		  self:redo(f)
	     end
       end
       _R1:CatchStart()
	end
	_R:CatchStart()
end

function alias:tiandifenglei_di()
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
		  local dx=tiandifenglei(_R.relation,"������")
		  world.Send(dx)
		local _R1
        _R1=Room.new()
        _R1.CatchEnd=function()
         local count,roomno=Locate(_R1)
	     print("��ǰ�����",roomno[1])
	     if roomno[1]==2887 then
	       self:finish()
	     else
		    local f=function()
		  local w
		  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		    self:finish()
		  end
		  w:go(2887)
		  end
		  self:redo(f)
	     end
       end
       _R1:CatchStart()
       end
       _R:CatchStart()
end

function alias:tiandifenglei_feng()
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
		  local dx=tiandifenglei(_R.relation,"������")
		  world.Send(dx)
		    local _R1
        _R1=Room.new()
        _R1.CatchEnd=function()
         local count,roomno=Locate(_R1)
	     print("��ǰ�����",roomno[1])
	     if roomno[1]==2890 then
	       self:finish()
	     else
		    local f=function()
		  local w
		  w=walk.new()
		  w.user_alias=self
		 --[[ self.zishanlin_tiandifenglei=function()
		     self:zishanlin_tiandifenglei_quick() --
		  end]]
		  w.walkover=function()
		    self:finish()
		  end
		  w:go(2890)
		  end
		  self:redo(f)
	     end
       end
       _R1:CatchStart()
       end
       _R:CatchStart()
end

function alias:tiandifenglei_lei()
     local _R
      _R=Room.new()
      _R.CatchEnd=function()
		  local dx=tiandifenglei(_R.relation,"������")
		  world.Send(dx)
		    local _R1
        _R1=Room.new()
        _R1.CatchEnd=function()
         local count,roomno=Locate(_R1)
	     print("��ǰ�����",roomno[1])
	      if roomno[1]==2889 then
	        self:finish()
	      else
		     local f=function()
		  local w
		   w=walk.new()
		   w.user_alias=self
		   w.walkover=function()
		     self:finish()
		   end
		   w:go(2889)
		   end
		   self:redo(f)
	      end
        end
         _R1:CatchStart()
       end
       _R:CatchStart()
end
--С���Ѳ�Ҫ�����ֵط�ȥ����
function alias:xidajie_mingyufang()
   world.Send("north")
   wait.make(function()
      local l,w=wait.regexp("^(> |)����.*|С���Ѳ�Ҫ�����ֵط�ȥ����",5)
	  if l==nil then
	     self:finish()
	     return
	  end
	  if string.find(l,"С���Ѳ�Ҫ�����ֵط�") then
	     self.break_in_failure()
	     return
	  end
   	  if string.find(l,"����") then
	     self:finish()
	     return
	  end
   end)
end



function alias:huilang1_huilang2()
   world.Execute("s;e;e;s")
   self:finish()
end

function alias:huilang2_huilang1()
  world.Execute("n;w;w;n")
  self:finish()
end

function alias:huilang_huilang2(d)
--1755 1754
 local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1755 then
	   if d==nil then
	     local dx={"south","east"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:huilang_huilang2(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==1754 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:huilang_huilang2()
		end
		w:go(1755)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:huilang_huilang1(d)
--1755 2542
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1755 then
	   if d==nil then
	     local dx={"north","west"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:huilang_huilang1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2542 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:huilang_huilang1()
		end
		w:go(1755)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:tiaochuang()
   world.Send("push chuang")
   world.Send("tiao chuang")

      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2556 then
          local b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		     self:tiaochuang()
		  end
		  b:check()
	   elseif roomno[1]==2557 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:tiaochuang()
		end
		w:go(2556)
		end
		self:redo(f)
	    end
	 end
	 _R:CatchStart()
end

function alias:changjinggeyilou_changjinggeerlou()
--2555
--2556
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2555 then
	    local party=world.GetVariable("party")
		if party=="������" then
		   world.Send("up")
		   self:finish()
		else
          local f
		  f=function()
		   world.Send("up")
		   self:finish()
		  --self:changjinggeyilou_changjinggeerlou()
		  end
		  local exps=world.GetVariable("exps") or 0
		if tonumber(exps)>=5500000 then
		   break_npc=break_npc_id("chanshi")
           self:break_in("chanshi",f)
		else
		  self.break_in_failure()
		end


	    --elseif roomno[1]==2556 then
        end
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changjinggeyilou_changjinggeerlou()
		end
		w:go(2555)
		end
		self:redo(f)
	    end
	 end
	 _R:CatchStart()
end

function alias:yuchuan2_yuchuan1(d)
--1343-1342
	  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1343 then
	   if d==nil then
	     local dx={"south","west"}
	     d=dx_serial(dx)
	   end
	    --[[ local f=function()
	       world.Send(d())
           self:yuchuan2_yuchuan1(d)
	     end
	     f_wait(f,0.3)]]


		self.maze_step=function()
	       world.Send(d())
           self:yuchuan2_yuchuan1(d)
	    end
	     if self.alias_table["yuchuan2_yuchuan1"].is_search==true then
	        self:maze_done()
	     else
		   self.maze_step()
		 end
	   elseif roomno[1]==1342 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yuchuan2_yuchuan1()
		end
		w:go(1343)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end
--ysl2 ysl6
function alias:clg_ysl()
 --ysl6 3181 east;out;southeast;east;south
 --ysl5 2769*
 --ysl4 3185
 --ysl3 2767
 --ysl2 2760

 --ysl2 e ysl1 se ysl3
 --ysl3 e ysl4
 --ysl4 s ysl5
   world.Send("out")
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
             --local count,roomno=Locate(_R)
	    --print("��ǰ�����",roomno[1])
	   if _R.relation=="��Ժ����ɼ�֩���ɼ�֩���ɼ�֣���ɼ��" then
	      world.Execute("e;se;e;s")
	      self:finish()
	   elseif _R.relation=="��ɼ�֣���ɼ�֩���ɼ�֩��ຮ¥һ�����ɼ��" then
	      world.Execute("east;out;southeast;east;south")
		  self:finish()
		elseif  _R.relation=="��ɼ�֣���ɼ�֩���ɼ�֩���ɼ�֣������" then
		   self:finish()
		elseif _R.relation=="��ɼ�֣���ɼ�֩���ɼ�֩���ɼ�֣���ɼ��" then
		     local _R2=Room.new()
             _R2.CatchEnd=function()

			  if _R2.relation=="��ɼ�֣���ɼ�֩���ɼ�֩���ɼ�֣������" then
			     world.Send("s")
			  else
			     world.Execute("e;s")
			  end
			    self:finish()
			 end
			 _R2:CatchStart("south")

	   else
          local f=function()
           local w
		   w=walk.new()
		   w.user_alias=self
		   w.walkover=function()
		     self:clg_ysl()
		   end
		   w:go(2769)
		 end
		 self:redo(f)
       end
	  end
       _R:CatchStart()
end

function alias:yugangmatou_chuancang()
 --1244 1345
      world.Execute("enter;north;enter;east;enter;norht;enter;east;enter;north;enter;east;enter;north;enter;east;enter;north;enter;east;enter")
	  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        --local count,roomno=Locate(_R)
	    --print("��ǰ�����",roomno[1])
	   if _R.RoomName=="����" then
	      self:finish()
	   elseif _R.RoomName=="�洬" then
	      self:yugangmatou_chuancang()
	   else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yugangmatou_chuancang()
		end
		w:go(1244)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:chuancang_yugangmatou()
 --1345 1244
    world.Execute("out;south;out;west;out;south;out;west;out;south;out;west;out;south;out;south;out;west;out")
	local _R
      _R=Room.new()
      _R.CatchEnd=function()
        --local count,roomno=Locate(_R)
	    --print("��ǰ�����",roomno[1])
	   if _R.RoomName=="�����ͷ" then
	      self:finish()
	   elseif _R.RoomName=="�洬" then
	      self:chuancang_yugangmatou()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(1244)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:yuchuan2_yuchuan3(d)
--1343-1344
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
	    --print(_R.zone)
		--print("error")
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1343 then
	   if d==nil then
	     local dx={"north","east"}
	     d=dx_serial(dx)
	   end
		 --[[
	     local f=function()
	       world.Send(d())
           self:yuchuan2_yuchuan3(d)
	     end
	     f_wait(f,0.3)]]
		 self.maze_step=function()
	       world.Send(d())
           self:yuchuan2_yuchuan3(d)
	    end
	     if self.alias_table["yuchuan2_yuchuan3"].is_search==true then
	        self:maze_done()
	     else
		   self.maze_step()
		 end
	   elseif roomno[1]==1344 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yuchuan2_yuchuan3()
		end
		w:go(1343)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:changlang_huanglongdong(d)
--1170 2542
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1170 then
	   if d==nil then
	     local dx={"west","east","north","south"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:changlang_huanglongdong(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2631 then
	      print("jieshu")
	      self:finish()
		  print("jieshu")
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changlang_huanglongdong()
		end
		w:go(1170)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:xiaodaobian_matou()
--1975-1058
    local _R
	_R=Room.new()
	_R.CatchEnd=function()
	    local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1975 then
	      self:yellboat()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaodaobian_matou()
		end
		w:go(1975)
		end
		self:redo(f)
	    end
	end
	_R:CatchStart()
end

function alias:beimenbingying_jianyu()
--972_973
   world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==973 then
	   self:finish()
	 elseif roomno[1]==972 then
        --npc block
		local f
		f=function()
		  self:beimenbingying_jianyu()
		end
		break_npc=break_npc_id("zhao liangdong")
        self:break_in("zhao liangdong",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:beimenbingying_jianyu()
		end
		w:go(972)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--2418 2422
function alias:zoulang_shufang()
--
     local party=world.GetVariable("party") or ""
	 if party=="���ư�" then
       world.Send("north")
	   self:finish()
	 else
	   self:noway()
	 end
	--[[ wait.make(function()
	   local l,w=wait.regexp("^(> |)ͻȻ�и����������������׳ʿ�������ư���ˣ����ý�����ء�$",5)
	   if l==nil then
          self:zoulang_shufang()
	      return
	   end
	   if string.find(l,"ͻȻ�и����������������") then
		  self:noway()
		  return
	   end

	 end)]]

end

local whisper_count=0
function alias:shimen_riyuepin()
  world.Send("whisper jia �����ĳ���£�һͳ����")
  world.Send("whisper jia ����ǧ�����أ�һͳ����")
  world.Send("whisper jia ��������Ϊ������������")
  world.Send("whisper jia ������ּӢ���������Ų�")
  world.Send("whisper jia �����������£��츣����")
  world.Send("whisper jia ����ս�޲�ʤ�����޲���")
  world.Send("whisper jia ��������ĳ���¡�����Ӣ��")
  world.Send("whisper jia ��������ʥ�̣��󱻲���")
  world.Send("westup")
  world.Send("whisper jia �����ĳ���£�һͳ����")
  world.Send("whisper jia ����ǧ�����أ�һͳ����")
  world.Send("whisper jia ��������Ϊ������������")
  world.Send("whisper jia ������ּӢ���������Ų�")
  world.Send("whisper jia �����������£��츣����")
  world.Send("whisper jia ����ս�޲�ʤ�����޲���")
  world.Send("whisper jia ��������ĳ���¡�����Ӣ��")
  world.Send("whisper jia ��������ʥ�̣��󱻲���")
  world.Send("westup")
  --2111
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2854 then
	   self:finish()
	 elseif roomno[1]==2111 then
	   whisper_count=whisper_count+1
	   if whisper_count>=5 then
	      self:noway()
	      return
	   end
	   local f=function()
        self:shimen_riyuepin()
	   end
       f_wait(f,1.5)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shimen_riyuepin()
		end
		w:go(2111)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:holdteng()
   world.Execute("hold teng;jump down")
   self:finish()
end


function alias:jump_river()
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1930 then
	   self:finish()
	 elseif roomno[1]==2674 then
	    wait.make(function()
          world.Send("jump river")
          --���沨���������ڷ����˰��ߣ�����ʪ�����������˺�ˮ���������沨���������ڷ����˰��ߣ�����ʪ�����������˺�ˮ������
          local l,w=wait.regexp("^(> |)���沨���������ڷ����˰��ߣ�����ʪ�����������˺�ˮ������$",15)
          if l==nil then
            self:jump_river()
	        return
          end
          if string.find(l,"���沨���������ڷ����˰��ߣ�����ʪ�����������˺�ˮ����") then
            self:finish()
	        return
          end
        end)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jump_river()
		end
		w:go(2674)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--[[function alias:liehuo_liehuo(d,pre_direction_index)
  if pre_direction_index==nil then
     pre_direction_index=1
  end
  local dx=nil
  for i=pre_direction_index,9 do
    if d[i]=="�һ����" and i~=5  then
		if i==1 then
		      dx="northwest"
			   pre_direction_index=i+1
		elseif i==2 then
		      dx="north"
			   pre_direction_index=i+1
		elseif i==3 then
		      dx="northeast"
			   pre_direction_index=i+1
		elseif i==4 then
		      dx="east"
              pre_direction_index=i+1
		elseif i==6 then
		      dx="southeast"
			   pre_direction_index=i+1
		elseif i==7 then
		      dx="south"
			   pre_direction_index=i+1
		elseif i==8 then
			  dx="southwest"
			   pre_direction_index=i+1
		elseif i==9 then
			  dx="west"
			   pre_direction_index=1
		end

		break
	end
  end
  --��ѭ��
  if dx==nil then
    --û���ҵ����ʵ���Ҷ
	pre_direction_index=1
	self:liehuo_liehuo(d,pre_direction_index)
    return
  end
 print(pre_direction_index)
  world.Send(dx)
  local f=function() self:liehuo_luoye(pre_direction_index) end
  f_wait(f,0.8)
end]]

function alias:liehuo_luoye(pre_direction_index)
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")  --���ָ�
	    --˳ʱ�뻯
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
	  --�ж��ļ�����������Ҷ����
	  local dx=nil
	  for i=1,9 do
	    if direction[i]=="��Ҷ����"  then
           if i==1 then
		      world.Send("northwest")
		   elseif i==2 then
		      world.Send("north")
		   elseif i==3 then
		      world.Send("northeast")
		   elseif i==4 then
		      world.Send("east")
		   elseif i==6 then
		      world.Send("southeast")
		   elseif i==7 then
		      world.Send("south")
		   elseif i==8 then
			  world.Send("southwest")
		   elseif i==9 then
			  world.Send("west")
		   end
		   self:finish()
		   return
		end
      end
	  local j=math.random(9)

	      if j==1 then
		      world.Send("northwest")
		   elseif j==2 then
		      world.Send("north")
		   elseif j==3 then
		      world.Send("northeast")
		   elseif j==4 then
		      world.Send("east")
		   elseif j==6 then
		      world.Send("southeast")
		   elseif j==7 then
		      world.Send("south")
		   elseif j==8 then
			  world.Send("southwest")
		   elseif j==9 then
			  world.Send("west")
		   end
		   self:liehuo_luoye(pre_direction_index)

	 --[[if dx==nil then
      --û���ҵ����ʵ���Ҷ

	  if pre_direction_index==nil then
	    pre_direction_index=1
	  end
	  self:liehuo_liehuo(direction,pre_direction_index)
      return
     end]]

   end
   _R:CatchStart()
end

function alias:luoye_liehuo(pre_direction_index)
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     if _R.roomname=="��Ҷ����" then
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")  --���ָ�
	    --˳ʱ�뻯
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
	  --�ж��ļ�����������Ҷ����
	  for i=1,9 do
	    if direction[i]=="�һ����"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="east"
		   elseif i==6 then
		      dx="southeast"
		   elseif i==7 then
		      dx="south"
		   elseif i==8 then
			  dx="southwest"
		   elseif i==9 then
			  dx="west"
		   end
           local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
			  world.Send(dx)
			  self:finish()
		   end
		   b:check()
		   return
		end
      end
      --û���ҵ����ʵ���Ҷ
	  if pre_direction_index==nil then
	    pre_direction_index=1
	  end
	  self:luoye_luoye(direction,pre_direction_index)
     else
	     local f=function()
	    local w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:luoye_liehuo()
		end
		w:go(2666)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:luoye_luoye(d,pre_direction_index)
  if pre_direction_index==nil then
     pre_direction_index=1
  end
  local dx=nil
  for i=pre_direction_index,9 do
    if d[i]=="��Ҷ����" and i~=5  then
		if i==1 then
		      dx="northwest"
			   pre_direction_index=i+1
		elseif i==2 then
		      dx="north"
			   pre_direction_index=i+1
		elseif i==3 then
		      dx="northeast"
			   pre_direction_index=i+1
		elseif i==4 then
		      dx="east"
              pre_direction_index=i+1
		elseif i==6 then
		      dx="southeast"
			   pre_direction_index=i+1
		elseif i==7 then
		      dx="south"
			   pre_direction_index=i+1
		elseif i==8 then
			  dx="southwest"
			   pre_direction_index=i+1
		elseif i==9 then
			  dx="west"
			   pre_direction_index=1
		end
		break
	end
  end
  --��ѭ��
  if dx==nil then
    --û���ҵ����ʵ���Ҷ
	pre_direction_index=1
	self:luoye_luoye(d,pre_direction_index)
    return
  end
  world.Send(dx)
  local f=function() self:luoye_jixue(pre_direction_index) end
  f_wait(f,0.8)

end

function alias:jixue_luoye(pre_direction_index)
	local _R
   _R=Room.new()
   _R.CatchEnd=function()
      if _R.roomname=="��ѩ����" then

      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	    --˳ʱ�뻯
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
  --�ж��ļ��������ǻ�ѩ����
	  for i=1,9 do
	    if direction[i]=="��Ҷ����"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="east"
		   elseif i==6 then
		      dx="southeast"
		   elseif i==7 then
		      dx="south"
		   elseif i==8 then
			  dx="southwest"
		   elseif i==9 then
			  dx="west"
		   end
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     world.Send(dx)
		     self:finish()
		   end
		   b:check()
		   return
		end
      end
	  --û�л�ѩ���� ����һ����Ҷ����
      self:jixue_jixue(direction,pre_direction_index)
	  else  --���ǻ�ѩ����
	      local f=function()
	     local w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:jixue_luoye()
		 end
		 w.go(2667)
		 end
		 self:redo(f)
	  end
   end
   _R:CatchStart()
end

function alias:luoye_jixue(pre_direction_index)
	local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	    --˳ʱ�뻯
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
  --�ж��ļ��������ǻ�ѩ����
	  for i=1,9 do
	    if direction[i]=="��ѩ����"  then
           if i==1 then
		      world.Send("northwest")
		   elseif i==2 then
		      world.Send("north")
		   elseif i==3 then
		      world.Send("northeast")
		   elseif i==4 then
		      world.Send("east")
		   elseif i==6 then
		      world.Send("southeast")
		   elseif i==7 then
		      world.Send("south")
		   elseif i==8 then
			  world.Send("southwest")
		   elseif i==9 then
			  world.Send("west")
		   end
		   self:finish()
		   return
		end
      end
	  --û�л�ѩ���� ����һ����Ҷ����
      self:luoye_luoye(direction,pre_direction_index)
   end
   _R:CatchStart()
end

local jixue_count=0
function alias:jixue_jixue(d,pre_direction_index)
   jixue_count=jixue_count+1
  if pre_direction_index==nil then
     pre_direction_index=1
  end
  local dx=nil
  for i=pre_direction_index,9 do
    if d[i]=="��ѩ����" and i~=5  then
		if i==1 then
		      dx="northwest"
			   pre_direction_index=i+1
		elseif i==2 then
		      dx="north"
			   pre_direction_index=i+1
		elseif i==3 then
		      dx="northeast"
			   pre_direction_index=i+1
		elseif i==4 then
		      dx="east"
              pre_direction_index=i+1
		elseif i==6 then
		      dx="southeast"
			   pre_direction_index=i+1
		elseif i==7 then
		      dx="south"
			   pre_direction_index=i+1
		elseif i==8 then
			  dx="southwest"
			   pre_direction_index=i+1
		elseif i==9 then
			  dx="west"
			   pre_direction_index=1
		end
		break
	end
  end
  --��ѭ��
  if dx==nil then
    --û���ҵ����ʵ���Ҷ
	pre_direction_index=1
	self:jixue_jixue(d,pre_direction_index)
    return
  end
  if jixue_count>3 then --��������û���߳��� �������
     print("��· ��ѭ���ˣ���")
	 pre_direction_index=1
	 jixue_count=0
     local n=math.random(1,8)
	 local dir={"east","north","west","south","northeast","northwest","southwest","southeast"}
	 dx=dir[n]
  end
  world.Send(dx)
  local f=function() self:jixue_kuoye(pre_direction_index) end
  local b=busy.new()
   b.interval=0.8
	 b.Next=function()
	     f()
	 end
  b:check()
  --f_wait(f,1)
end

function alias:kuoye_jixue(pre_direction_index)
     local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����	�һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	    --˳ʱ�뻯
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
  --�ж��ļ�����������Ҷ����
	  for i=1,9 do
	     local dx
	    if direction[i]=="��ѩ����"  then
           if i==1 then
		     dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="east"
		   elseif i==6 then
		     dx="southeast"
		   elseif i==7 then
		      dx="south"
		   elseif i==8 then
			 dx="southwest"
		   elseif i==9 then
			 dx="west"
		   end
           local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		      world.Send(dx)
		      self:finish()
		   end
		   b:check()
		   return
		end
      end
    --û����Ҷ���� ����һ����ѩ����
      self:kuoye_kuoye(direction,pre_direction_index)
   end
   _R:CatchStart()
end

local jixue_kuoye_count=0
function alias:jixue_kuoye(pre_direction_index)
     local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����	�һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	    --˳ʱ�뻯
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
  --�ж��ļ�����������Ҷ����
	  for i=1,9 do
	    if direction[i]=="��Ҷ����"  then
           if i==1 then
		      world.Send("northwest")
		   elseif i==2 then
		      world.Send("north")
		   elseif i==3 then
		      world.Send("northeast")
		   elseif i==4 then
		      world.Send("east")
		   elseif i==6 then
		      world.Send("southeast")
		   elseif i==7 then
		      world.Send("south")
		   elseif i==8 then
			  world.Send("southwest")
		   elseif i==9 then
			  world.Send("west")
		   end

		   self:finish()
		   return
		end
      end
    --û����Ҷ���� ����һ����ѩ����
      self:jixue_jixue(direction,pre_direction_index)
   end
   _R:CatchStart()
end

local step_count=0
function alias:kuoye_kuoye(d,pre_direction_index)
	step_count=step_count+1
	local _R
	_R=Room.new()
    _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����	�һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="��Ҷ����"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  if step_count>=10 then
		 print("��·�ˣ���")
	    for i=1,9 do
	     if direction[i]=="��ѩ����"  then
           if i==1 then
		      world.Send("northwest")
		   elseif i==2 then
		      world.Send("north")
		   elseif i==3 then
		      world.Send("northeast")
		   elseif i==4 then
		      world.Send("east")
		   elseif i==6 then
		      world.Send("southeast")
		   elseif i==7 then
		      world.Send("south")
		   elseif i==8 then
			  world.Send("southwest")
		   elseif i==9 then
			  world.Send("west")
		   end
		    local f=self.finish
		    self.finish=function()
			    self.finish=f
                self:kuoye_conglin(pre_direction_index)
		    end
		    self:jixue_kuoye(pre_direction_index)
		   return
		 end
        end
	  end
	  --�����
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("��Χ:",n," �������",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	       local f=function() self:kuoye_conglin(pre_direction_index) end
          f_wait(f,0.8)
	  end
	  b:check()
   end
   _R:CatchStart()
end

function alias:kuoye_conglin(pre_direction_index)
	step_count=0
	local _R
   _R=Room.new()
   print("Ѱ�Ҵ��ֱ�Ե")--��Ҷ����
   _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����	�һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	  --˳ʱ�뻯
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
	  local dx
      for i=1,9 do
	    if direction[i]=="���ֱ�Ե"  then
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="east"
		   elseif i==6 then
		      dx="southeast"
		   elseif i==7 then
		      dx="south"
		   elseif i==8 then
			  dx="southwest"
		   elseif i==9 then
			  dx="west"
		   end
		   local b=busy.new()
		   b.Next=function()
		     world.Send(dx)
		     self:finish()
		   end
		   b:check()
		   return
		end
      end
       self:kuoye_kuoye(direction,pre_direction_index)
   end
   _R:CatchStart()
end

--1257 ��ڹ��� west �ر�
function alias:opening(c,hour,minutes)
   local h
   local m
   if hour=="��" then
       h=1
   elseif hour=="��" then
       h=2
   elseif hour=="��" then
       h=3
   elseif hour=="î" then
       h=4
   elseif hour=="��" then
       h=5
   elseif hour=="��" then
       h=6
   elseif hour=="��" then
       h=7
   elseif hour=="δ" then
       h=8
   elseif hour=="��" then
       h=9
   elseif hour=="��" then  --��ʱ���̡�
       h=10
   elseif hour=="��" then
       h=11
   elseif hour=="��" then
       h=12
   end
   if minutes=="��" then
      m=0
   elseif minutes=="һ��" then
      m=15
   elseif minutes=="����" then
      m=30
   elseif minutes=="����" then
      m=45
   end
   --print(c)
   local result=true
    print(c," ʱ��:",h)
   if c=="fuzhouchengximen" or c=="fuzhouchengnanmen"  then
     if h>=3 and h<10 then
	   print("opening",true)
       result= true
	 elseif h==2 and m>=45 then
	   result=true
	 else
	   print("opening",false)
	   result= false
	 end
   end
   self.finish(result)
end

function alias:jy()
   return false
end

function alias:virtual_rooms(c)
   if c=="fuzhouchengximen" or c=="fuzhouchengnanmen" then
      return true
   elseif c=="jump_river" or c=="goboat" or c=="guanmucong" then
      return false
   else
      return false
   end
end

function alias:opentime(c)  -- ȷ������ʱ��
  wait.make(function()
     --world.Send("time")
      world.Send("time -s")
	  local l,w=wait.regexp("^(> |)�������齣(.*)��(.*)��(.*)��(.*)ʱ(.*)��$",15)
	  if l==nil then
	    print("��ʱ:")--��
	    self:opentime(c)
		return
	  end
	  if string.find(l,"�������齣") then
	    print(w[2],w[3],w[4],w[5],w[6])
	    self:opening(c,w[5],w[6])
		return
	  end
   end)
end

function alias:push_grass()
   world.Execute("push grass;northwest")
   self:finish()
end

function alias:liehuo()
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����	�һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="�һ����"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  --�����
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("��Χ:",n," �������",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	      self:finish()
	  end
	  b:check()
   end
   _R:CatchStart()
end

function alias:luoye()
    local _R
	_R=Room.new()
   _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����	�һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="��Ҷ����"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  --�����
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("��Χ:",n," �������",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	      self:finish()
	  end
	  b:check()
   end
   _R:CatchStart()
end

function alias:jixue()

   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����	�һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="��ѩ����"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  --�����
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("��Χ:",n," �������",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	      self:finish()
	  end
	  b:check()
   end
   _R:CatchStart()
end

function alias:kuoye()
    local _R
	_R=Room.new()
    _R.CatchEnd=function()
      --�һ���� �һ���� �һ���֨I �� �J��Ҷ���֩��һ���֩��һ���֨L �� �K�һ���� �һ���� �һ����	�һ����
	  local matrix=string.gsub(_R.relation, "�I �� �J", " ")
	   matrix=string.gsub(matrix,"�L �� �K"," ")
	   matrix=string.gsub(matrix,"��"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="��Ҷ����"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  --�����
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("��Χ:",n," �������",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	      self:finish()
	  end
	  b:check()

   end
   _R:CatchStart()
end


function alias:opendoorenter()
   world.Send("open door")
   world.Send("enter")
   self:finish()
end

function alias:push_qiaolan()
   world.Send("push ����")
   world.Send("down")
   self:finish()
end

function alias:zuan_didao()
  world.Send("zuan didao")
  self:finish()
end

function alias:shanlu_shanzhongxiaoxi(d)
    local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==1704 then
	   if d==nil then
	     local dx={"south","east"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:shanlu_shanzhongxiaoxi(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==531 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanlu_shanzhongxiaoxi()
		end
		w:go(531)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:chanyan_shidao()
	world.Send("north")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==294 then
		 print("npc block")
		 local f
		 f=function()
		   self:chanyan_shidao()
		 end
		 break_npc=break_npc_id("ding mian")
         self:break_in("ding mian",f)
	   elseif roomno[1]==295 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:chanyan_shidao()
		end
		w:go(294)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

local mark_x=0
local mark_y=0
local axis=1
local index=0
local dx="e"
function alias:maze_shandao()
-- ����˳ʱ����ת
  print(mark_x,":",mark_y)
  if index<axis then
      index=index+1
  else
      if dx=="e" then
	     dx="s"
		 index=0
	  elseif dx=="s" then
         dx="w"
		  axis=axis+1 --�᳤+1
		 index=0
	  elseif dx=="w" then
		 dx="n"
		 index=0
	  elseif dx=="n" then
	     dx="e"
		 axis=axis+1 --�᳤+1
	     index=0
	  end

  end
  if dx=="e" then
       mark_x=mark_x+1
  elseif dx=="w" then
       mark_x=mark_x-1
  elseif dx=="n" then
       mark_y=mark_y-1
  elseif dx=="s" then
      mark_y=mark_y+1
  end

  world.Send(dx)
  wait.make(function()
	 local l,w=wait.regexp("^(> |)ɽ�� \\- .*$|^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)�������û�г�·��$|^(> |)��������һͨ����Ȼ�����Լ��߻���ԭ�ء�$|^(> |)�������������ƿ��е��а�š���$|^(> |)����Ŀ��ɽ����ȥ��ֻ���ǵƻ𷢳������͵Ĺ�â���Ĳ�ͬѰ���ƻ��ɫ��$",5)
	 if l==nil then
        --print("test3")
	    self:maze_shandao()
	    return
	 end
	 if string.find(l,"��Ķ�����û�����") then
	   --print("test")
	    wait.time(0.1)
		self:maze_shandao()
		return
	 end
     if string.find(l,"�������") or string.find(l,"�������û�г�·") then
	    mark_x=-16
		mark_y=-16
	    self:finish()
	    return
	 end
     if string.find(l,"����Ŀ��ɽ����ȥ��ֻ���ǵƻ𷢳������͵Ĺ�â���Ĳ�ͬѰ���ƻ��ɫ��") then
	    local q=quest.new()
		q.Execute=function()
		   self:finish()
		end
		q:tianshan()
	    return
	 end
     if string.find(l,"ɽ��") then
	    --print("test2")
		wait.time(0.1)
		self:maze_shandao()

        return

	 end

 end)
end

function alias:shandao_shanjin()
--��ɽɽ�� - �Թ� -8*+8
    -- print("��ʼ��ͯ��")
	--[[
	        i=random(5)+2;
	j=random(4)+3;
			me->set_temp("tonglao/steps",j); 3~7   w -1 e 1
		me->set_temp("tonglao/step",-i); -2~-7     s 1 n -1
			if (dir == "west") me->add_temp("mark/steps",-1);
	if (dir == "south") me->add_temp("mark/step",1);
	if (dir == "east") me->add_temp("mark/steps",1);
        if (dir == "north") me->add_temp("mark/step",-1);
		]]
    -- world.Execute("n;n;n;n;n;n;n;n;w;w;w;w;w;w;w;w")  --�����Ͻǿ�ʼ
	 mark_x=0
	 mark_y=0
	 axis=1
	 index=0
	 dx="e"
	 local b=busy.new()
	 b.Next=function()
	   --world.Execute("#16w")
	   --world.Execute("#16s")
	   world.AppendToNotepad (WorldName(),os.date()..": ��ɽɽ��".."\r\n")

       local _R
       _R=Room.new()
       _R.CatchEnd=function()
         local count,roomno=Locate(_R)
	     print("��ǰ�����",roomno[1])
	     if roomno[1]==2743 then
	        self:maze_shandao()

		 elseif roomno[1]==2299 then
		    world.AppendToNotepad (WorldName(),os.date().."����: ��ɽɽ��"..dx.." ".. c.." range:"..range.."\r\n")
	        self:finish()
	      end
        end
	    _R:CatchStart()
	  end
	  b:check()
end

function alias:juyiting_shenhuotang()
--2457_2745
 world.Send("northup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2745 then
	   self:finish()
	 elseif roomno[1]==2457 then
        --npc block
		local f
		f=function()
		  self:juyiting_shenhuotang()
		end
		break_npc=break_npc_id("fan yao")
        self:break_in("fan yao",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:juyiting_shenhuotang()
		end
		w:go(2457)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:juyiting_longwangdian()
--2457_2748
   local party=world.GetVariable("party")
   if party=="����" then
      world.Send("west")
	  self:finish()
      return
   end
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2748 then
	   self:finish()
	 elseif roomno[1]==2457 then
        --npc block
		local f
		f=function()
		  self:juyiting_longwangdian()
		end
		local exps=world.GetVariable("exps") or 0
		if tonumber(exps)>=5000000 then
		  world.Send("west")
		  break_npc=break_npc_id("yang xiao")
          self:break_in("yang xiao",f)
		else
		  self.break_in_failure()
		end

	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:juyiting_longwangdian()
		end
		w:go(2457)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--��һ�֣�ne;ne;se;e;s;w;e;up;up;out
--�Ӱ���浵��ຮ¥һ��{sw;sw;se;e;s;w;e} 2225 se e s w e
--�ڶ���  ne;ne;se;w;e;up;up;out
function alias:yunshanlin2_yunshanlin1(d)
    local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2769 then
	   if d==nil then
	     local dx={"east","north","west","east","west","north","south","east","north","south"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:yunshanlin2_yunshanlin1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2767 then
	      world.Send("south")
	   elseif roomno[1]==2760 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2760)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:xiaojing2_xiaojing1(d)
---2771 2755 2754
  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2755 then
	   if d==nil then
	     local dx={"north","east","west"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:xiaojing2_xiaojing1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2754 then
	      self:finish()
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing2_xiaojing1()
		end
		w:go(2755)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:light()
   wait.make(function()
      local l,w=wait.regexp("^(> |)��վ��С���ϣ����ܴ������·𿴼�(.*)����Щ���⡣$",8)
	  if l==nil then
	     world.Send("south")
	     self:xiaojing2_yuanmen()
	     return
	  end
	  if string.find(l,"��վ��С����") then
	    local dx=w[2]
		if dx=="��" then
		   world.Send("east")
		elseif dx=="��" then
		    world.Send("south")
		elseif dx=="��" then
		   world.Send("north")
		elseif dx=="��" then
		   world.Send("west")
		end
		self:xiaojing2_yuanmen()
		return
	  end
	  wait.time(5)
   end)
end

function alias:xiaojing2_yuanmen()
---2771 2755 2754
  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2755 then
          self:light()
	   elseif roomno[1]==2771 then
	      self:finish()
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing2_yuanmen()
		end
		w:go(2755)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:yuanmen_houshanxiaoyuan()
 world.Send("open door")
 world.Send("south")
 local _R
	_R=Room.new()
	_R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	 if roomno[1]==2771 then
		local f
		 f=function()
		   self:yuanmen_houshanxiaoyuan()
		 end
		 break_npc=break_npc_id("yin liting")
         self:break_in("yin liting",f,true)
	 elseif roomno[1]==2772 then
	      self:finish()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yuanmen_houshanxiaoyuan()
		end
		w:go(2772)
		end
		self:redo(f)
	  end
	end
  _R:CatchStart()
end

--С�� 2045 �������� 2046
function alias:xiaojing_dongxiangzoulang()
   world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2046 then
	   self:finish()
	 elseif roomno[1]==2045 then
        --npc block
		local f
		f=function()
		  self:xiaojing_dongxiangzoulang()
		end
		break_npc=break_npc_id("yu lianzhou")
        self:break_in("yu lianzhou",f,true)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing_dongxiangzoulang()
		end
		w:go(2045)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--�������� 2752
function alias:xiaojing_xixiangzoulang()
   world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2752 then
	   self:finish()
	 elseif roomno[1]==2045 then
        --npc block
		local f
		f=function()
		  self:xiaojing_xixiangzoulang()
		end
		break_npc=break_npc_id("yu lianzhou")
        self:break_in("yu lianzhou",f,true)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing_xixiangzoulang()
		end
		w:go(2045)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--С�� 2754
function alias:xiaojing_xiaojing1()
   world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2754 then
	   self:finish()
	 elseif roomno[1]==2045 then
        --npc block
		local f
		f=function()
		  self:xiaojing_xiaojing1()
		end
		break_npc=break_npc_id("yu lianzhou")
        self:break_in("yu lianzhou",f,true)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing_xiaojing1()
		end
		w:go(2045)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:songshulin2_songshulin1(d)
--2779 2698
 local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2779 then
	   if d==nil then
	     --s;s;e;s;w;s
	     local dx={"south","south","east","south","west","south"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:songshulin2_songshulin1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2698 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:songshulin2_songshulin1()
		end
		w:go(2779)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:songshulin2_songshulin3(d)
--2779 2774
 local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2779 then
	   if d==nil then

	     local dx={"north","east","north","west","north","north"}
	     d=dx_serial(dx)
	   end

	    self.maze_step=function()
	     local f=function()
	       world.Send(d())
           self:songshulin2_songshulin3(d)
	     end
	     f_wait(f,0.3)
	    end
	   if self.alias_table["songshulin2_songshulin3"].is_search==true then
	     self:maze_done()
	   else
	      self.maze_step()
	   end


	   elseif roomno[1]==2774 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:songshulin2_songshulin3()
		end
		w:go(2779)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:zoulang_lianwuchang()
--2489 2786
  world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2786 then
	   self:finish()
	 elseif roomno[1]==2489 then
        --npc block
		local f
		f=function()
		  self:zoulang_lianwuchang()
		end
		break_npc=break_npc_id("zhuang ding")--ׯ��(Zhuang ding)
        self:break_in("zhuang ding",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zoulang_lianwuchang()
		end
		w:go(2489)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()

end
--ȥ�һ��� 1842_2794 2803 ���� 2814 ��ҩʦ
--2794
function alias:haibing_taohuadao()
 wait.make(function()
 --�����ۡ���һ��ײ���˰��ߣ��㼱æ���������˰���
  world.Send("look rock")
  world.Send("jump boat")
    local l,w=wait.regexp("^(> |)�����ۡ���һ��ײ���˰��ߣ��㼱æ���������˰���$|^(> )��Ҫ��˭�����������$",5)
	if l==nil then
	   self:haibing_taohuadao()
	   return

	end
	if string.find(l,"��Ҫ��˭���������") then
	   local w=walk.new()
	   w.walkover=function()
	      self:haibing_taohuadao()
	   end
	   w:go(1842)
	   return
	end
	if string.find(l,"�����ۡ���һ��ײ���˰��ߣ��㼱æ���������˰�") then
	    wait.time(2)
	    --local b=busy.new()
		--b.interval=0.3
		--b.Next=function()
	      self:finish()
		--end
		--b:check()
	   return
	end

  end)
end

function alias:leave_taohuadao()
   --2814 --1842
   wait.make(function()
      world.Send("ask huang yaoshi about leave")
	  local l,w=wait.regexp("^(> |)��������˳�磬������ƣ������ڱ㵽���ˡ�$|^(> |)����û������ˡ�$|^(> |)��ҩʦһ���֣�����һ��������������λ.*��½�ء�$",5)
	  if l==nil then
	      self:leave_taohuadao()
	     return
	  end
	  if string.find(l,"����û�������") then
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:leave_taohuadao()
		end
		w:go(2814)
		end
		self:redo(f)
	     return
	  end
      if string.find(l,"��������˳�磬������ƣ������ڱ㵽����") or string.find(l,"����һ��������") then
	    local b=busy.new()
		b.interval=0.3
		b.Next=function()
	      self:finish()
		end
		b:check()
	     return
	  end
	  wait.time(5)
   end)


end

function alias:out_graveyard()
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      local count,roomno=Locate(_R)
	  if roomno[1]==2834 then
	   self:finish()
	 elseif roomno[1]==2836 then
        --npc block
		local exits=Split(_R.exits,";")
	    for _,e in ipairs(exits) do
	       if e~="down" then
		    world.Send(e)
			world.Execute("up;out")
			print("��Ĺ�أ����")
			self:out_graveyard()
			break
		   end
	    end
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:out_graveyard()
		end
		w:go(2836)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shufang_jiabi()
  world.Execute("sit chair;zhuan")
  self:finish()
end

function alias:jiabi_shufang()
  world.Execute("push shujia")
  self:finish()
end

--2850 n w e 3�����䶼��2850 ���� �Թ�û�г�·
function alias:dasonglin_findway(d,test_dir)
   if test_dir==nil then
      test_dir="west"
      world.Send("west")
   elseif test_dir=="west" then
      test_dir="north"
      world.Send("north")
   elseif test_dir=="north" then
       test_dir="east"
      world.Send("east")
   elseif test_dir=="east" then
      self:noway() --û�г�·
	  return
   end
   local _R
	_R=Room.new()
	_R.CatchEnd=function()
	    if _R.relation=="�����֣������֩������֩������֣���Ժ" then
		    self:dasonglin_findway(d,test_dir)
		else
		    self:songlin1_songlin2(d)
		end
	end
    _R:CatchStart()

end

function alias:songlin_mark(dir)
  world.Send("get coin")
   world.Send("drop 1 coin")
  wait.make(function()
    local l,w=wait.regexp("^(> |)�����һЩͭǮ��$|^(> |)�㸽��û������������$",5)
	if l==nil then
	  self:songlin_mark(dir)
	  return
	end
	if string.find(l,"�����һЩͭǮ") then
	  if dir=="e" then
	     dir="w"
	  elseif dir=="w" then
	     dir="s"
	  elseif dir=="s" then
	     dir="e"
	  end
	  --wait.time(0.5)
	  world.Send(dir)
	  self:songlin1_songlin2(dir)
	  return
	end
	if string.find(l,"�㸽��û����������") then
	   dir="e"
	   world.Send(dir)
	   self:songlin1_songlin2(dir)
	   return
	end
 end)
end


local songlin_count=0
function alias:songlin1_songlin2(d)
      if d==nil then
	     songlin_count=0
	  end
--w;e;s;e
--���ϲ��ܽ�ȥ
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
		songlin_count=songlin_count+1
	   if roomno[1]==2850 then

         print("������:",80-songlin_count)
		 if songlin_count>80 then
		   songlin_count=0
		   self:noway()
		   --self:finish()
		   print("�������Ҳ�����·!!!!")
		   return
		 end
	     self:dasonglin_findway(d)
	   elseif roomno[1]==2891 then
	     if d==nil then
	     --local dx={"west","east","south","east"}
		   --songlin_count=0
		   -- d=dx_serial(dx)
		   d="e"
	     end
	     print("������:",80-songlin_count)
	     if songlin_count>80 then
		   songlin_count=0
		   self:noway()

		   --self:finish()
		   print("�������Ҳ�����·!!!!")
		   return
		 end
		 self:songlin_mark(d)
		 --[[
	     local f=function()
		   world.Send(d)
           self:songlin1_songlin2(d)
	     end
	     f_wait(f,0.3)]]
	   elseif roomno[1]==2853 then
	      self:finish()
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:songlin1_songlin2(d)
		end
		w:go(2850)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:songlin2_songlin1(d)
--w;e;s;e
--���ϲ��ܽ�ȥ
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==2853 then
	      world.Send("east")
          world.Send("west")
		  self:songlin2_songlin1()
	   elseif roomno[1]==2891 then
	    if d==nil then
	     local dx={"west","east","south","east"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:songlin2_songlin1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2850 then
	      self:finish()
	   else
	       local f=function()
		  local w
		  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		   self:finish()
		  end
		  w:go(2850)
		  end
		  self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:jianhugong_houyuan()
 world.Send("north") --2411
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2849 then
	   self:finish()
	 elseif roomno[1]==2411 then
        --npc block
		local f
		f=function()
		  self:jianhugong_houyuan()
		end
		break_npc=break_npc_id("gong guangjie|xin shuangqing|zuo zimu")
        self:break_in("gong guangjie|xin shuangqing|zuo zimu",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jianhugong_houyuan()
		end
		w:go(2411)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:jianhugong_donglianwuchang()
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2847 then
	   self:finish()
	 elseif roomno[1]==2411 then
        --npc block
		local f
		f=function()
		  self:jianhugong_donglianwuchang()
		end
		break_npc=break_npc_id("gong guangjie|xin shuangqing|zuo zimu")
        self:break_in("gong guangjie|xin shuangqing|zuo zimu",f)
	 else
	    local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jianhugong_donglianwuchang()
		end
		w:go(2411)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:jianhugong_xilianwuchang()
  world.Send("west")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2848 then
	   self:finish()
	 elseif roomno[1]==2411 then
        --npc block
		local f
		f=function()
		  self:jianhugong_xilianwuchang()
		end
		break_npc=break_npc_id("gong guangjie|xin shuangqing|zuo zimu")
        self:break_in("gong guangjie|xin shuangqing|zuo zimu",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jianhugong_xilianwuchang()
		end
		w:go(2411)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:dapubu_bailongfeng()--2851_2852
  world.Send("southeast")

 --���������ڵ��� �����(ge guangpei)
  --���������ڵ��� �ɹ��(gan guanghao)
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2852 then
	   self:finish()
	 elseif roomno[1]==2851 then
        --npc block
		local f
		f=function()
		  self:dapubu_bailongfeng()
		end
		break_npc=break_npc_id("ge guangpei|gan guanghao")
        self:break_in("ge guangpei|gan guanghao",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dapubu_bailongfeng()
		end
		w:go(2851)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--��ľ��
function alias:outlou()
--��¨���˼��£���һ��ʯ��֮��ͣ��������
  wait.make(function()
     local l,w=wait.regexp("^(> |)��¨���˼��£���һ��ʯ��֮��ͣ��������$",5)
     if l==nil then
	    self:outlou()
	    return
	 end
	 if string.find(l,"��¨���˼��£���һ��ʯ��֮��ͣ������") then
	    world.Send("out")
	    self:finish()
	    return
	 end
	 wait.time(5)
  end)
end

function alias:xiaya()
	wait.make(function()
	       world.Send("yell xiaya")
	       world.Send("enter")

           local l,w=wait.regexp("^(> |).*��¨\\\s*-\\\s*(out|)$",2)
	       if l==nil then
	          self:xiaya()
	         return
	       end
	      if string.find(l,"��¨") then
	        self:outlou()
		    return
		  end
	     wait.time(2)
	end)
end

function alias:shangya()
	wait.make(function()
	       world.Send("yell shangya")
	       world.Send("enter")
           local l,w=wait.regexp("^(> |).*��¨\\\s*-\\\s*(out|)$",2)
	       if l==nil then
	          self:shangya()
	         return
	       end
	      if string.find(l,"��¨") then
	        self:outlou()
		    return
		  end
	     wait.time(2)
	end)
end

function alias:yading_riyuepin()
--2856_2854 --2856
  wait.make(function()
    world.Send("zong")
	  local l,w=wait.regexp("^(> |)��һ����Ϣ����׼���¼���¨λ�ã�ʹ�������־�������Ҫ����.*�¡�$|^(> |)�����Ϊ������$|^(> |)���������Ϊ����������֧�֣���$|^(> |)ʲô.*$",5)
	  if l==nil then
	    self:yading_riyuepin()
	    return
	  end
	  if string.find(l,"��һ����Ϣ����׼���¼���¨λ��") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
	     self:finish()
		end
		b:check()
	     return
	  end
	  if string.find(l,"�����Ϊ����") or string.find(l,"���������Ϊ����") then
         self:xiaya()
	     return
	  end
	  if string.find(l,"ʲô") then
	    self:finish()
		return
	  end
	  wait.time(5)
 end)
end

function alias:riyuepin_yading()
--2854_2856
 wait.make(function()
    world.Send("zong")
	  local l,w=wait.regexp("^(> |)��һ����Ϣ����׼���¼���¨λ�ã�ʹ�������־�������Ҫ����.*�¡�$|^(> |)�����Ϊ������$|^(> |)���������Ϊ����������֧�֣���$|^(> |)ʲô.*$",5)
	  if l==nil then
	    self:yading_riyuepin()
	    return
	  end
	  if string.find(l,"��һ����Ϣ����׼���¼���¨λ��") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
	     self:finish()
		end
		b:check()
	     return
	  end
	  if string.find(l,"�����Ϊ����") or string.find(l,"���������Ϊ����") then
         self:shangya()
	     return
	  end
	  if string.find(l,"ʲô") then
	     self:finish()
		 return
	  end
	  wait.time(5)
 end)
end

function alias:unwield_west()
 local sp=special_item.new()
	sp.cooldown=function()
     world.Send("west")
	 local shield=world.GetVariable("shield") or ""
	 if shield~="" then
	   world.Execute(shield)
	 end
     self:finish()
   end
   sp:unwield_all()
end

function alias:unwield_east()
 local sp=special_item.new()
	sp.cooldown=function()
     world.Send("east")
	local shield=world.GetVariable("shield") or ""
	 if shield~="" then
	   world.Execute(shield)
	 end
     self:finish()
   end
   sp:unwield_all()
end

function alias:unwield_north()
 local sp=special_item.new()
	sp.cooldown=function()
     world.Send("north")
	 local shield=world.GetVariable("shield") or ""
	 if shield~="" then
	   world.Execute(shield)
	 end
     self:finish()
   end
   sp:unwield_all()
end

function alias:out_boat1()
   wait.make(function()
      local l,w=wait.regexp("^(> |)�ֻ��������Ϫ�ĺ��оſ��ʯӭ����������������һ�㣬��ס������ȥ·��$",5)
	  if l==nil then

	     self:out_boat1()
		 return
	  end
	  if string.find(l,"�ֻ��������Ϫ�ĺ��оſ��ʯӭ����������������һ�㣬��ס������ȥ·") then
	     world.Send("out")
		 self:finish()
	     return
	  end
	 wait.time(5)
   end)
end
function alias:out_boat2()
   wait.make(function()
	  local l,w=wait.regexp("^(> |)�ֻ��������Ϫ�����ۣ�С�۾������˼�������ֻص�Ϫ�ߡ�$",5)
	  if l==nil then

	     self:out_boat2()
		 return
	  end
	  if string.find(l,"�ֻ��������Ϫ�����ۣ�С�۾������˼�������ֻص�Ϫ��") then
	     world.Send("out")
		 self:finish()
	     return
	  end
	 wait.time(5)
   end)
end
function alias:xiaoxi_dufengling()
--610_2897
--�ֻ��������Ϫ�ĺ��оſ��ʯӭ����������������һ�㣬��ס������ȥ·��
  world.Send("look boat")
  world.Send("yue zhou")
  --�������������ȵ�վ����С��֮�ϡ�
  wait.make(function()
     local l,w=wait.regexp("^(> |)��Ҫ��˭�����������$|^(> |)�������������ȵ�վ����С��֮�ϡ�$|^(> |)��Ҫ��ʲô��$",5)
	 if l==nil then
	     self:xiaoxi_dufengling()
	     return
	 end
	 if string.find(l,"��Ҫ��˭���������") or string.find(l,"��Ҫ��ʲô") then
	    self:finish()
		return
	 end
	 if string.find(l,"����������") then
	    self:out_boat1()
		return
	 end
	 wait.time(5)
  end)
end

function alias:dufengling_xiaoxi()
--2897 610_
--�ֻ��������Ϫ�����ۣ�С�۾������˼�������ֻص�Ϫ�ߡ�
 local sp=special_item.new()
 sp.cooldown=function()
  world.Send("tui boat")
  world.Send("jump boat")
  --�����˿�����������С����������ȥ��
  --> ��Ҫ��˭�����������
    wait.make(function()
     local l,w=wait.regexp("^(> |)��Ҫ��˭�����������$|^(> |)�����˿�����������С����������ȥ��$",5)
	 if l==nil then
	     self:xiaoxi_dufengling()
	     return
	 end
	 if string.find(l,"��Ҫ��˭���������") then
	    self:finish()
		return
	 end
	 if string.find(l,"������С����������ȥ") then
	    self:out_boat2()
		return
	 end
	 wait.time(5)
  end)
  end
  sp:unwield_all()
end

function alias:shuitang_shanjianpingdi()
   world.Send("eastup")
	 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2903 then
	   self:finish()
	 elseif roomno[1]==2910 then

		  local seed=math.random(4)
	      local dx={"west","north","east","south"}
		  local d=dx[seed]
	      world.Send(d)
	     local f=function()
           self:shuitang_shanjianpingdi()
	     end
	     f_wait(f,0.3)
	 elseif roomno[1]==2911 then
	     world.Send("westdown")
	     self:finish()
	 elseif roomno[1]==2915 then
	     world.Send("southup")
		 self:finish()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shuitang_shanjianpingdi()
		end
		w:go(2903)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shanjianpingdi_shuitang()
   world.Send("northdown")
	 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2912 then
	   self:finish()
	 elseif roomno[1]==2910 then
	      local seed=math.random(4)
	      local dx={"west","north","east","south"}
		  local d=dx[seed]
	      world.Send(d)

	     local f=function()
           self:shanjianpingdi_shuitang()
	     end
	     f_wait(f,0.3)
	elseif roomno[1]==2911 then
	     world.Send("westdown")
	     self:finish()
	elseif roomno[1]==2915 then
	     world.Send("southup")
	     self:finish()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanjianpingdi_shuitang()
		end
		w:go(2903)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:out_zhulin_shuitang()
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])

	 if roomno[1]==2910 then
          local seed=math.random(4)
	      local dx={"west","north","east","south"}
		  local d=dx[seed]
	      world.Send(d)
	     local f=function()
           self:out_zhulin_shuitang()
	     end
	     f_wait(f,0.3)
	 elseif roomno[1]==2911 then
	     world.Send("westdown")
	     self:finish()
	 elseif roomno[1]==2912 then
	     self:finish()
	 elseif roomno[1]==2915 then
	     world.Send("southup")
	     self:finish()
	 else
	     local f=function()
		local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2912)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:out_zhulin_shanjianpingdi()
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])

	  if roomno[1]==2903 then
	    self:finish()
	  elseif roomno[1]==2910 then

		  local seed=math.random(4)
	      local dx={"west","north","east","south"}
		  local d=dx[seed]
	      world.Send(d)
	     local f=function()
           self:out_zhulin_shanjianpingdi()
	     end
	     f_wait(f,0.3)
	  elseif roomno[1]==2911 then
	     world.Send("westdown")
	     self:finish()
	  elseif roomno[1]==2915 then
	     world.Send("southup")
		 self:finish()
	  else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shuitang_shanjianpingdi()
		end
		w:go(2903)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:enter_zhulin()
  world.Send("northdown")
  world.Send("eastup")
	 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2910 or roomno[1]==2915 or roomno[1]==2911 then
	   self:finish()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2910)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end


function alias:fuyaqianting_situtang()
  world.Send("east")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])

	 if roomno[1]==2917 then
        self:finish()
	 elseif roomno[1]==436 then
			local f
		f=function()
		  self:fuyaqianting_situtang()
		end
		break_npc=break_npc_id("dali guanbing|dali guanbing|dali wujiang")
        self:break_in("dali guanbing|dali guanbing|dali wujiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:fuyaqianting_situtang()
		end
		w:go(436)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:fuyaqianting_sikongtang()
  world.Send("north")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])

	 if roomno[1]==2918 then
        self:finish()
	 elseif roomno[1]==436 then
			local f
		f=function()
		  self:fuyaqianting_sikongtang()
		end
		break_npc=break_npc_id("dali guanbing|dali guanbing|dali wujiang")
        self:break_in("dali guanbing|dali guanbing|dali wujiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:fuyaqianting_sikongtang()
		end
		w:go(436)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:fuyaqianting_simatang()
  world.Send("west")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])

	 if roomno[1]==2919 then
        self:finish()
	 elseif roomno[1]==436 then
			local f
		f=function()
		  self:fuyaqianting_simatang()
		end
		break_npc=break_npc_id("dali guanbing|dali guanbing|dali wujiang")
        self:break_in("dali guanbing|dali guanbing|dali wujiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:fuyaqianting_simatang()
		end
		w:go(436)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:changlemen_dongmenchenglou()
--934 2920
  world.Send("up")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2920 then
        self:finish()
	 elseif roomno[1]==934 then
			local f
		f=function()
		  self:changlemen_dongmenchenglou()
		end
		break_npc=break_npc_id("guan bing|guan bing|wu jiang")
        self:break_in("guan bing|guan bing|wu jiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changlemen_dongmenchenglou()
		end
		w:go(934)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:anyuanmen_beimenchenglou()
--1087 2951
  world.Send("up")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2951 then
        self:finish()
	 elseif roomno[1]==1087 then
		local f
		f=function()
		  self:anyuanmen_beimenchenglou()
		end
		break_npc=break_npc_id("guan bing|guan bing|wu jiang")
        self:break_in("guan bing|guan bing|wu jiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:anyuanmen_beimenchenglou()
		end
		w:go(1087)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:yongningmen_nanmenchenglou()
--215_2934
  world.Send("up")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2934 then
        self:finish()
	 elseif roomno[1]==215 then
		local f
		f=function()
		  self:yongningmen_nanmenchenglou()
		end
		break_npc=break_npc_id("guan bing|guan bing|wu jiang")
        self:break_in("guan bing|guan bing|wu jiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yongningmen_nanmenchenglou()
		end
		w:go(215)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:andingmen_ximenchenglou()
--896 2942
 world.Send("up")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2942 then
        self:finish()
	 elseif roomno[1]==896 then
		local f
		f=function()
		  self:andingmen_ximenchenglou()
		end
		break_npc=break_npc_id("guan bing|guan bing|wu jiang")
        self:break_in("guan bing|guan bing|wu jiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:andingmen_ximenchenglou()
		end
		w:go(896)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end


function alias:xixiangchibian_xixiangchibian()
--
 world.Send("north")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2965 then
        self:finish()
	 elseif roomno[1]==685 then
		local f
		f=function()
		  self:xixiangchibian_xixiangchibian()
		end
		break_npc=break_npc_id("hou zi")
        self:break_in("hou zi",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xixiangchibian_xixiangchibian()
		end
		w:go(685)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:changlang_guifang()
 world.Send("east")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2977 then
        self:finish()
	 elseif roomno[1]==2195 then
		local f
		f=function()
		  self:changlang_guifang()
		end
		break_npc=break_npc_id("ya huan")
        self:break_in("ya huan",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changlang_guifang()
		end
		w:go(2195)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:zoulang_xixiangzoulang()
 world.Send("west")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2983 then
        self:finish()
	 elseif roomno[1]==1958 then
		local f
		f=function()
		  self:zoulang_xixiangzoulang()
		end
		break_npc=break_npc_id("zhang songxi")
        self:break_in("zhang songxi",f,true)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zoulang_xixiangzoulang()
		end
		w:go(1958)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:zoulang_dongxiangzoulang()
 world.Send("east")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2985 then
        self:finish()
	 elseif roomno[1]==1958 then
		local f
		f=function()
		  self:zoulang_dongxiangzoulang()
		end
		break_npc=break_npc_id("zhang songxi")
        self:break_in("zhang songxi",f,true)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zoulang_dongxiangzoulang()
		end
		w:go(1958)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:zoulang_liangongfang()
 world.Send("north")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2986 then
        self:finish()
	 elseif roomno[1]==1958 then
		local f
		f=function()
		  self:zoulang_liangongfang()
		end
		break_npc=break_npc_id("zhang songxi")
        self:break_in("zhang songxi",f,true)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zoulang_liangongfang()
		end
		w:go(1958)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:xiaowu_liwu()
 world.Send("enter")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2991 then
        self:finish()
	 elseif roomno[1]==2558 then
		local f
		f=function()
		  self:xiaowu_liwu()
		end
		break_npc=break_npc_id("murong bo")
        self:break_in("murong bo",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaowu_liwu()
		end
		w:go(2558)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end


function alias:dashiwu_dating()
 world.Send("enter")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2998 then
        self:finish()
	 elseif roomno[1]==2914 then
		local f
		f=function()
		  self:dashiwu_dating()
		end
		break_npc=break_npc_id("fan yiweng")
        self:break_in("fan yiweng",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dashiwu_dating()
		end
		w:go(2914)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:dating_houtang()
  world.Send("ask zhi about �����")
 local b=busy.new()
 b.Next=function()
  world.Send("xian hua")
  world.Send("zuan dao")
  self:finish()
 end
 b:check()
end

function alias:jump_back()
  world.Send("jump back")
  self:finish()
end

function alias:jump_qiaobi()
  world.Send("look ya")
  world.Send("jump qiaobi")
  self:finish()
end

function alias:xiao()
  world.Send("xiao")
  self:finish()
end

function alias:hubian()
   local _R
    _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1648 then
        self:yell_tengkuang()
	 elseif string.find(_R.roomname,"�ٿ�") then
		local f
		f=function()
		  self:out_tengkuang()
		end
        f_wait(f,5)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yell_tengkuang()
		end
		w:go(1648)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:out_tengkuang()
  wait.make(function()
    local l,w=wait.regexp("һ����ɮ��ɳ�Ƶ����������������µ����������ɡ���������δ�䣬�ٿ��Ѿ������ȵ�ͣס�ˡ�$|^(> |)�ٿ�һ�ᣬ�ƺ�Ҫ�����������æ���ٿ��д��˳�����$",10)
	if l==nil then
	   self:hubian()
	   return
	end
	if string.find(l,"�ƺ�Ҫ�����������æ���ٿ��д��˳���") then
	   self:yell_tengkuang()
	   return
	end
    if string.find(l,"�ٿ��Ѿ������ȵ�ͣס��") then
	   world.Send("out")
	   self:finish()
	   return
	end
	wait.time(10)
  end)
end

function alias:yell_tengkuang()
  wait.make(function()
    world.Send("yell tengkuang")
	world.Send("enter")
	local l,w=wait.regexp("^(> |)�ٿ� -.*$|^(> |)ʲô.*",5)
	if l==nil then
	   self:yell_tengkuang()
	   return
	end
	if string.find(l,"ʲô") then
	   local w=walk.new()
	   w.walkover=function()
	      self:finish()
	   end
	   w:go(1648)
	   return
	end
	if string.find(l,"�ٿ�") then
	   self:out_tengkuang()
	   return
	end
 	wait.time(5)
  end)
end


function alias:miaofadian_cangjingge()
  world.Send("southup")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3031 then
        self:finish()
	 elseif roomno[1]==1910 then
		local f
		f=function()
		  self:miaofadian_cangjingge()
		end
		break_npc=break_npc_id("wu seng")
        self:break_in("wu seng",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:miaofadian_cangjingge()
		end
		w:go(1910)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--local p={"ne","se","n","e","sw","e","ne","se","s","se"}
--local p={"n","nw","sw","w","ne","w","s","nw","sw"}
--С���Ѳ�Ҫ�����ֵط�ȥ����
--����_�ŷ�������
function alias:talin_gufoshelita(again)
--ne;n;nw;sw;w;ne;w;s;nw;sw;n
--open door;w;ne;n;nw;sw;w;ne;w;s;nw;sw;n;enter;u
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3039 then
	   self:finish()
	 elseif roomno[1]==3034  then
          --print("ִ��1")

		local p={"ne","n","nw","sw","w","ne","w","s","nw","sw"}

        alias.circle_co=coroutine.create(function()

          for _,i in ipairs(p) do
	         world.Send(i)
              self:circle_done("talin_gufoshelita")
	         coroutine.yield()
	      end
	      self:talin_gufoshelita(true)
        end)
		self.maze_step=function()
		  --print("444")
	     local f=function()
	       if again==true then
		    local seed=math.random(8)
		    local dx={"south","north","west","east","northeast","northwest","southeast","southwest"}
		     world.Send(dx[seed])
			 world.Send("east")
			 self:talin_gufoshelita(false)
		   else
			 coroutine.resume(alias.circle_co)
		   end
	     end
		  f_wait(f,0.2)
	   end
	     --print("ִ��3")
		-- print(self.alias_table["talin_gufoshelita"].is_search)
		  --print("ִ��5")
	    if self.alias_table["talin_gufoshelita"].is_search==true then

	      self:maze_done()
	   else
	     --print("ִ��4")
		  self.maze_step()
	   end
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(3039)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--3039

--3034 3040

function alias:gufoshelita_talin(again,index,last)
--ne;se;n;e;sw;e;ne;se;s;se;e
--out;d;out;s;ne;se;n;e;sw;e;ne;se;s;se;e
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3034 then
	   self:finish()
	 elseif roomno[1]==3039  then

		local p={"ne","se","n","e","sw","e","ne","se","s","se"}

        alias.circle_co=coroutine.create(function()

          for _,i in ipairs(p) do
	         world.Send(i)
              self:circle_done("gufoshelita_talin")
	         coroutine.yield()
	      end
	      self:gufoshelita_talin(true)
        end)

	    self.maze_step=function()
		    local f=function()
	          if again==true then
		        local seed=math.random(8)
		        local dx={"south","north","west","east","northeast","northwest","southeast","southwest"}
			     world.Send(dx[seed])
			     world.Send("east")
			     self:gufoshelita_talin(false)
		      else
				 coroutine.resume(alias.circle_co)
		      end

	        end
	        f_wait(f,0.2)
		end
		--print("why",self.alias_table["gufoshelita_talin"].is_search)
	   if self.alias_table["gufoshelita_talin"].is_search==true then
	      --print("why1")
	      self:maze_done()
	   else
	      --print("why2")
		  self.maze_step()
	   end
	 elseif roomno[1]==3040 then

		   if again==false then
		      index=1

		   elseif index==nil then
		       index=1
			--else
			   --[[if index>9 then
			      index=1
				  --����8���
				  local _r=math.random(9)

				  --local dx={"south","north","west","east","northeast","northwest","southeast","southwest"}
				  local dx={"ne","se","n","e","sw","e","ne","se","s","se"}
				  world.Send(dx[_r])
				  print("�������","->",dx[_r])
				  self:gufoshelita_talin(true,index)
				  return
			   end]]
		   end
		  -- local p={"ne","se","n","e","sw","e","ne","se","s","se"}
		   --local p={"south","north","west","east","northeast","northwest","southeast","southwest"}
		   local p={"ne","se","n","e","sw","e","ne","se","s","se"}
		       if last==nil then
			      last=1
			   end
			   if index>last then
			       last=last+1
				   index=1
			   end
			   if last>9 then
			      world.Execute("s;s;e;s;se;se;;w;n")
			       last=1
			   end
		   print(index,"->",p[index]," last:",last)
		   index=index+1
			world.Send(p[index])
			self:gufoshelita_talin(true,index,last)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(3034)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:majiu_houshanxiaojing()
  world.Send("move gancao")
  world.Send("zuan dong")
  self:finish()
end

function alias:kantree()
    world.Send("wield jian")
	world.Send("wield sword")
	world.Send("kan tree")
	wait.make(function()
	  local l,w=wait.regexp("(> |)������.*���Ź�ľ�Կ���������һת�۾����˽�ȥ��$|^(> |)����ʲô����$|^(> |)��������������޷����У�����ܿ�������$",3)
	  if l==nil then
		 self:kantree()
		 return
	  end
	  if string.find(l,"��������������޷����У�����ܿ�����") then
	     local sp=special_item.new()
		 sp.cooldown=function()
		   local f=function()
		      print("convert weapon")
		      self:houshanxiaolu_guanmucong()
		   end
		  self.weapon_exist=false
		  local error_deal=function()
		     self:buy_weapon(f,462,"blade")
		  end
		   world.Send("i")
		    self:auto_wield_weapon(f,error_deal)
	       world.Send("set look 1")
		 end
		 sp:unwield_all()
		 return
	  end
	  if string.find(l,"����ʲô��") then
	     local f=function() self:houshanxiaolu_guanmucong() end
		  local error_deal=function()
		     self:buy_weapon(f,462,"blade")
		  end
		local sp=special_item.new()
		 sp.cooldown=function()
		    self.weapon_exist=false
		    world.Send("i")
		    self:auto_wield_weapon(f,error_deal)
	        world.Send("set look 1")
		 end
		 sp:unwield_all()
		 return
	  end
	  if string.find(l,"һת�۾����˽�ȥ") then
	     self:houshanxiaolu_guanmucong()
		return
	  end
	  wait.time(3)
	end)
end

function alias:houshanxiaolu_guanmucong()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3049 then
	   self:finish()
	 elseif roomno[1]==3047 then
	     self:kantree()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:houshanxiaolu_guanmucong()
		end
		w:go(3047)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:guamucong_dongkou()
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3051 then
	   self:finish()
	 elseif roomno[1]==3050 then
	   local f=function()
	     world.Send("yue dongkou")
	     world.Send("yue tan")
         self:guamucong_dongkou()
	   end
	   f_wait(f,0.2)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:guamucong_dongkou()
		end
		w:go(3050)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

local guamucong_step_count=0
function alias:guanmucong_out()
    local mastername=world.GetVariable("mastername") or ""
	if mastername=="�º���" then
	    world.Send("ed")
		self:finish()
	end
    if guamucong_step_count>=15 then
      sj.World_Init=function()
	     guamucong_step_count=0
         self:guanmucong_out()
      end
	  sj.quit()
	end
    local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3050 then
	   self:finish()
	 elseif roomno[1]==3049 then
	  local f=function()
	    world.Send("northeast")
		world.Send("yun qi")
	    world.Send("yun refresh")
        self:guanmucong_out()
	   end
	   f_wait(f,0.2)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:guanmucong_out()
		end
		w:go(3049)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:movestone()
  world.Send("move stone")
  world.Send("northdown")
  self:finish()
end

function alias:laofang_dilao()


  local b=busy.new()
  b.Next=function()
	world.Send("give 5 silver to yu zu")
    world.Send("wear all")
	world.Send("south")
	 local _R
    _R=Room.new()
    _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2749 then
	    self:finish()
	 elseif roomno[1]==3057 then
	   local f=function()
           self:laofang_dilao()
	   end
	   f_wait(f,0.2)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2749)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
  end
  b:check()
end

function alias:changlang_chufang()
   world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3059 then
        self:finish()
	 elseif roomno[1]==2196 then
		local f
		f=function()
		  self:changlang_chufang()
		end
		break_npc=break_npc_id("jia ding")
        self:break_in("jia ding",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changlang_chufang()
		end
		w:go(2196)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:xiaoting_chufang()
   world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3058 then
        self:finish()
	 elseif roomno[1]==1979 then
		local f
		f=function()
		  self:xiaoting_chufang()
		end
		break_npc=break_npc_id("a bi")
        self:break_in("a bi",f)
	 else
		local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaoting_chufang()
		end
		w:go(1979)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:sajiafatang_fatangerlou()
   world.Send("up")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3060 then
        self:finish()
	 elseif roomno[1]==2270 then
		local f
		f=function()
		  self:sajiafatang_fatangerlou()
		end
		break_npc=break_npc_id("zayi lama")
        self:break_in("zayi lama",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:sajiafatang_fatangerlou()
		end
		w:go(2270)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:jiechiyuan_jingshi()
   world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3065 then
        self:finish()
	 elseif roomno[1]==1919 then
		local f
		f=function()
		  self:jiechiyuan_jingshi()
		end
		break_npc=break_npc_id("dadian dashi")
        self:break_in("dadian dashi",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jiechiyuan_jingshi()
		end
		w:go(1919)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--���پ� _����
--He taichong
function alias:tieqingju_woshi()
   world.Execute("open door;west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3074 then
        self:finish()
	 elseif roomno[1]==2830 then
		local f
		f=function()
		  self:tieqingju_woshi()
		end
		break_npc=break_npc_id("he taichong")
        self:break_in("he taichong",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:tieqingju_woshi()
		end
		w:go(2830)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:block_eastup()
   local gender=world.GetVariable("gender")
   if gender=="Ů��" then
     local b=busy.new()
	 b.interval=0.3
	 b.Next=function()
	  world.Send("eastup")
      self:finish()
	 end
	 b:check()
   else
      world.Send("eastup")
	  self:finish()
   end
end

function alias:block_westup()
   local gender=world.GetVariable("gender")
   if gender=="Ů��" then
     local b=busy.new()
	 b.interval=0.3
	 b.Next=function()
	  world.Send("westup")
      self:finish()
	 end
	 b:check()
   else
      world.Send("westup")
	  self:finish()
   end
end

function alias:shushang()
     local pfm=world.GetVariable("pfm") or ""
	 pfm=convert_pfm(pfm)
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
    world.Send("kill ju mang")
	local f=function()
	  world.Send("down")
	  self:finish()
	end
    f_wait(f,0.8)
end
--ȥ������
function alias:wait_shangan()
--> ����������ꑵأ������������¹ڱ㻺��������ȥ��
  wait.make(function()
     local l,w=wait.regexp("^(> |)����������ꑵأ������������¹ڱ㻺��������ȥ��$",5)
	 if l==nil then
	    self:wait_shangan()
	    return
	 end
	 if string.find(l,"����������ꑵ�") then
	    self:finish()
	    return
	 end
  end)
end

function alias:dadukou_shenlongdao()
   local w=walk.new()
   w.walkover=function()
     world.Send("yell ������鸣����")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)ֻ��һ�Ҵ��Ѿ�ʻ�����ڣ����������˽�ȥ��$",5)
		if l==nil then
		   self:dadukou_shenlongdao()
		   return
		end
		if string.find(l,"ֻ��һ�Ҵ��Ѿ�ʻ������") then
		    self:wait_shangan()
		   return
		end
	 end)
   end
   w:go(767) --1767
end

--�뿪������
function alias:shenlongdao_dadukou()
	local w
	w=walk.new()
	w.walkover=function()
	  wait.make(function()
	    world.Send("ask lu gaoxuan about ����")
		local player_name=world.GetVariable("player_name")
		local l,w=wait.regexp("^(> |)½������"..player_name.."һ�����ơ�$|^(> |)�㲻���Ѿ���������ô��$",5)
		if l==nil then
		   self:shenlongdao_dadukou()
		   return
		end
		if string.find(l,"һ������") or string.find(l,"�㲻���Ѿ���������") then
		  local b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		    self:give_lingpai2()
		  end
		  b:check()
		  return
		end
		wait.time(5)
	  end)
	end
	w:go(1772)
end

function alias:wait_chuan2()
   wait.make(function()
     local l,w=wait.regexp("������һԾ������С��",20) --�ȴ�20��
	 if l==nil then
	    print("�ȴ�20��û����Ӧ!")
	    self:give_lingpai2()
	    return
	 end
	if string.find(l,"������һԾ������С��") then
		  world.Send("order ȥ�뺣��")
		  self:order_chuan()
		  return
	end
     wait.time(20)
   end)
end

function alias:give_lingpai2()
   local w
   w=walk.new()
   w.walkover=function()
       wait.make(function()
        world.Send("give ling pai to chuan fu")
		local l,w=wait.regexp("^(> |)������һԾ������С����$|^(> |)������û������������$|^(> |)�Է�����������������$|^(> |)����˵����������û�������һ��ɡ���$",5)
		if l==nil then
		  self:give_lingpai2()
		  return
		end
		if string.find(l,"������û����������") or string.find(l,"�Է���������������") then
		   self:shenlongdao_dadukou()
		   return
		end
		if string.find(l,"������һԾ������С��") then
		  world.Send("order ȥ�뺣��")
		  self:order_chuan()
		  return
		end
		if string.find(l,"����û�������һ���") then
		  self:wait_chuan2()
		  return
		end
		wait.time(5)
	   end)
   end
   w:go(1767)
end

--[[function alias:longshuyuan_shibanlu()

   local p={"out","south","south","south","south","south","east","south","south","west","south","south","north","south","south","south"}
      alias.circle_co=coroutine.create(function()
      --print("����3")
        for _,i in ipairs(p) do
	      world.Send(i)

          self:circle_done("longshuyuan_shibanlu")
	      coroutine.yield()
	    end
	    local _R
        _R=Room.new()
        _R.CatchEnd=function()
           local count,roomno=Locate(_R)
	       print("��ǰ�����",roomno[1])
	       if roomno[1]==2280 then
	         self:finish()
	       elseif roomno[1]==3055 or roomno[1]==3056 then
	         self:longshuyuan_shibanlu()
	       else
	         local f=function()
               local w
		       w=walk.new()
		       w.user_alias=self
		       w.walkover=function()
		        self:finish()
		       end
		       w:go(2280)
		     end
		    self:redo(f)
		 end
	    end
        _R:CatchStart()
	 end)
  --print("����2")
   coroutine.resume(alias.circle_co)
end

function alias:shibanlu_longshuyuan()
  -- world.Execute()
   local p={"north","north","north","west","west","north","north","north","west","west","west","enter"}
   alias.circle_co=coroutine.create(function()
      --print("����3")
      for _,i in ipairs(p) do
	     world.Send(i)
         self:circle_done("shibanlu_longshuyuan")
	     coroutine.yield()
	  end
	  local _R
       _R=Room.new()
       _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	     print("��ǰ�����",roomno[1])
	    if roomno[1]==3082 then
	      self:finish()
	    elseif roomno[1]==3055 or roomno[1]==3056 then
		  self:shibanlu_longshuyuan()
	    else
	      local f=function()
          local w
	  	   w=walk.new()
		   w.user_alias=self
		   w.walkover=function()
		    self:shibanlu_longshuyuan()
		   end
		   w:go(3056)
		 end
		 self:redo(f)
	    end
       end
       _R:CatchStart()
   end)
  --print("����2")
   coroutine.resume(alias.circle_co)

end]]

function alias:songlin_longshuyuan()
  -- world.Execute()
   local p={"north","north","north","west","west","north","north","north","west","west","west"}
   alias.circle_co=coroutine.create(function()
      --print("����3")
      for _,i in ipairs(p) do
	     world.Send(i)
		 world.Send("set action ������")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)�������ţ�ͻȻ����ǰ����һ��Сľ��,�㲻�ɵ����˹�ȥ��$|^(> )�������ţ�͸����֦����Լ����ǰ����Ƭ�յأ��㲦����֦���˹�ȥ��$|^(> |)�趨����������action \\= \\\"������\\\"",5)
		    if l==nil then
			     self:circle_done("songlin_longshuyuan")
				 return
            end
            if string.find(l,"һ��Сľ��") then
			   self:finish()
			   return
			end
			if string.find(l,"�趨��������") then
			   self:circle_done("songlin_longshuyuan")
			   return
			end
			if string.find(l,"�������ţ�͸����֦����Լ����ǰ����") then
               world.Send("w")
			   self:circle_done("songlin_longshuyuan")
		       return
			end
		 end)

	     coroutine.yield()
	  end
	  local _R
       _R=Room.new()
       _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	     print("��ǰ�����",roomno[1])
	    if roomno[1]==3082 then
	      self:finish()
	    elseif roomno[1]==3055 or roomno[1]==3056 then
		  self:songlin_longshuyuan()
	    else
	      local f=function()
          local w
	  	   w=walk.new()
		   w.user_alias=self
		   w.walkover=function()
		    self:songlin_longshuyuan()
		   end
		   w:go(3056)
		 end
		 self:redo(f)
	    end
       end
       _R:CatchStart()
   end)
  --print("����2")
   coroutine.resume(alias.circle_co)

end

function alias:songlin_shibanlu()
     local p={"south","west","south","west","south","west","south","south","south","south","south","south","south"}
      alias.circle_co=coroutine.create(function()
      --print("����3")
        for _,i in ipairs(p) do
	      world.Send(i)
		  world.Send("set action ������")
          wait.make(function()
		    local l,w=wait.regexp("^(> |)���ƣ����,�����߳������֡�$|^(> )�������ţ�͸����֦����Լ����ǰ����Ƭ�յأ��㲦����֦���˹�ȥ��$|^(> |)�趨����������action \\= \\\"������\\\"",5)
		    if l==nil then
			     self:circle_done("songlin_shibanlu")
				 return
            end
            if string.find(l,"���ƣ����") then
			   self:finish()
			   return
			end
			if string.find(l,"�趨��������") then
			   self:circle_done("songlin_shibanlu")
			   return
			end
			if string.find(l,"�������ţ�͸����֦����Լ����ǰ����") then
               world.Send("w")
			   self:circle_done("songlin_shibanlu")
		       return
			end
		  end)

	      coroutine.yield()
	    end
	    local _R
        _R=Room.new()
        _R.CatchEnd=function()
           local count,roomno=Locate(_R)
	       print("��ǰ�����",roomno[1])
	       if roomno[1]==2280 then
	         self:finish()
	       elseif roomno[1]==3055 or roomno[1]==3056 then
	         self:songlin_shibanlu()
	       else
	         local f=function()
               local w
		       w=walk.new()
		       w.user_alias=self
		       w.walkover=function()
		        self:finish()
		       end
		       w:go(2280)
		     end
		    self:redo(f)
		 end
	    end
        _R:CatchStart()
	 end)
  --print("����2")
   coroutine.resume(alias.circle_co)
end

function alias:zuanshulin()
  world.Send("zuan shulin")
  wait.make(function()
    local l,w=wait.regexp("^(> |)������������ɣ�$|^(> |)ʲô.*$|^(> |)�㲦����֦��һ���������˽�ȥ��$",5)
	if l==nil then
	   self:zuanshulin()
	   return
	end
	if string.find(l,"ʲô") then
	   self:finish()
	   return
	end
	if string.find(l,"�㲦����֦��һ���������˽�ȥ") then
	   self:finish()
	   return
	end
	if string.find(l,"�������������") then
	   local w2=walk.new()
	   w2.walkover=function()
	       world.Send("ask caiyao daozhang about ֻ��")
	       local b=busy.new()
		   b.interval=0.5
		   b.Next=function()

			 w2.walkover=function()
			    world.Send("ask tao hua about rumor")
				b.Next=function()
				   w2.walkover=function()
				     self:zuanshulin()
				   end
				   w2:go(2638)
				end
			    b:check()
			 end
			 w2:go(1960)
		   end
		   b:check()
	   end
	   w2:go(2028)

	   return
	end
  end)
end

--�Ǵ�ǿ����û���Ƚ�Σ�գ������ߴ���ɡ�
function alias:special_east()
   print("����")
   world.Send("east")
   wait.make(function()
      local l,w=wait.regexp("^(> |)�Ǵ�ǿ����û���Ƚ�Σ�գ������ߴ���ɡ�$",0.5)
      if l==nil then
	       self:finish()
	     return
	  end
	  if string.find(l,"�Ǵ�ǿ����û") then
--338-211
        world.Execute("south;south;south;south;south;southwest;southwest;northwest;northwest;northwest")
        wait.time(0.8)
--��Զ�� 211 1087
        world.Execute("north;north;north;north;north;north;north;north;north;north;north;north")
        wait.time(0.8)
--1087 1347
        world.Execute("north;north;north;northeast;northup;northeast;northdown;northeast;north;southeast;southeast;southeast;south;southwest")
		self:finish()
		return
	  end
   end)
end


function alias:guangchang_shanmendian()
 --׳��ɮ�˳���������˵��������Ժ�������Ŵ�ʦ��ʦ�ֻ���ȥ����Ժ�������й�����
 --ִ��ɮ˵��������ҹ������Ժ���Ŵ�ʦ����ȥ�����˴���ɽ���� ����
  local party=world.GetVariable("party")
  if party~="������" then
    self:knockgatenorth()
  else
	world.Send("knock gate")
	world.Send("north")
	world.Send("set action ����")
	world.Send("unset action")
    wait.make(function()
       local l,w=wait.regexp("^(> |)׳��ɮ�˳���������˵��������Ժ�������Ŵ�ʦ��ʦ�ֻ���ȥ����Ժ�������й�����$|^(> |)�趨����������action \\= \\\"����\\\"",5)
	   if l==nil then
	      self:guangchang_shanmendian()
	      return
	   end
	   if string.find(l,"����Ժ�������Ŵ�ʦ��ʦ�ֻ���ȥ����Ժ�������й���") then
	      self:jielvyuan()
	      return
	   end
	   if string.find(l,"�趨����������action") then
	    local _R
	    _R=Room.new()
	    _R.CatchEnd=function()
		 local count,roomno=Locate(_R)
	      print("��ǰ�����",roomno[1])
	        if roomno[1]==780 then
	          self:finish()
	        elseif roomno[1]==781 then
	          self:guangchang_shanmendian()
			else
			   local f=function()
			  local w
			  w=walk.new()
			  w.user_alias=self
			  w.walkover=function()
			     self:guangchang_shanmendian()
			  end
			  w:go(781)
			  end
			  self:redo(f)
	        end
		 end
	     _R:CatchStart()
	   end
	end)
  end
end

--����Ժ
function alias:jielvyuan()
  --print("���ֽ���Ժ")
  world.Send("say ɫ���ǿ�,�ռ���ɫ.")
  --world.Send("say ���⴩��������")
  local w=walk.new()
  w.walkover=function()
    wait.make(function()
	 local player_name=world.GetVariable("player_name")
     local l,w=wait.regexp("^(> |)���Ŷ����㿴�˰��ã�˵����"..player_name.."����Ͷ����ƣ��������������ñ��ã�$",5)
	 if l==nil then
	    local _R=Room.new()
		  _R.CatchEnd=function()
		 local count,roomno=Locate(_R)
	        print("��ǰ�����",roomno[1])
	        if roomno[1]==3078 then
	           local w
		        w=walk.new()
		        w.walkover=function()
			       self:finish()
		        end
		        w:go(780)
			else
				self:jielvyuan()
	        end
		 end
	     _R:CatchStart()
	    return
	 end
	 if string.find(l,"��Ͷ����ƣ��������������ñ���") then
	     local w
		  w=walk.new()
		  w.walkover=function()
			 self:finish()
		  end
		  w:go(780)
	    return
	 end
	 wait.time(5)
	 end)
  end
  w:go(3078)
end

function alias:fanyinge_fotang()
  world.Send("open door")
  world.Send("northwest")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3105 then
        self:finish()
	 elseif roomno[1]==2265 then
		local f
		f=function()
		  self:fanyinge_fotang()
		end
		break_npc=break_npc_id("hufa lama")
        self:break_in("hufa lama",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:fanyinge_fotang()
		end
		w:go(2265)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shanjian_longtan()
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3109 then
        self:finish()
	 elseif roomno[1]==3108 then
	    local dx
	    if string.find(_R.description,"���·�") then
		   dx="northdown"
		elseif string.find(_R.description,"���Ϸ�") then
		   dx="northup"
		elseif string.find(_R.description,"������") then
		   dx="northeast"
		elseif string.find(_R.description,"������") then
		   dx="northwest"
	    elseif string.find(_R.description,"����") then
		   dx="north"

        elseif string.find(_R.description,"���Ϸ�") then
		   dx="southup"
		elseif string.find(_R.description,"���·�") then
		   dx="southdown"
        elseif string.find(_R.description,"���Ϸ�") then
		   dx="southeast"
		elseif string.find(_R.description,"���Ϸ�") then
		   dx="southwest"
		elseif string.find(_R.description,"�Ϸ�") then
		   dx="south"

		elseif string.find(_R.description,"����") then
		   dx="east"
		elseif string.find(_R.description,"���Ϸ�") then
		   dx="eastup"
		elseif string.find(_R.description,"���·�") then
		   dx="eastdown"
		elseif string.find(_R.description,"����") then
		   dx="west"
		elseif string.find(_R.description,"���Ϸ�") then
		   dx="westup"
		elseif string.find(_R.description,"���·�") then
		   dx="westdown"
		end
		world.Send(dx)
		self:shanjian_longtan()
        --"������ɽ���һ��ɽ�����Ա������������ɽȪ�������³���γɵ�һ�������ˮ̶��������Χ�����˹�ľ�����·��ƺ����߹�ȥ���㲻�ɵļӿ��˲�����"
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanjian_longtan()
		end
		w:go(3108)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shidao_xiaoyaodong()
 world.Send("kill chuchen zi")
  world.Send("give 1 coin to caihua zi")
  world.Send("enter")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3110 then
        self:finish()
	 elseif roomno[1]==2366 then
		local f
		f=function()
		  self:shidao_xiaoyaodong()
		end
		break_npc=break_npc_id("caihua zi")
        self:break_in("caihua zi",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shidao_xiaoyaodong()
		end
		w:go(2366)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:keting_xiangfang()
  world.Send("east")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3113 then
        self:finish()
	 elseif roomno[1]==2661 then
		local f
		f=function()
		  self:keting_xiangfang()
		end
		break_npc=break_npc_id("zhong wanchou")
        self:break_in("zhong wanchou",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:keting_xiangfang()
		end
		w:go(2661)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:yamendating_yamenzhengting()
 world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1078 then
	   self:finish()
	 elseif roomno[1]==1077 then
        --npc block
		local f
		f=function()
		  self:yamendating_yamenzhengting()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	     local f=function()
        local w
		w.user_alias=self
		w=walk.new()
		w.walkover=function()
		   self:yamendating_yamenzhengting()
		end
		w:go(1077)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shanbi_huacong()
   world.Send("bo huacong")
   world.Send("right")
   self:finish()
end

function alias:qianting_miaojiazhuang()
   world.Send("east")
   local b=busy.new()
   b.Next=function()
      self:finish()
   end
   b:check()
end

function alias:miaojiazhuang_qianting()
   world.Send("west")
   local b=busy.new()
   b.Next=function()
      self:finish()
   end
   b:check()
end


function alias:maowu_hetang()
   world.Send("enter tongdao")
   self:finish()
end

function alias:hetang_maowu()
   world.Send("enter tongdao")
   self:finish()
end

function alias:dierzhijie_shandong()
  world.Send("enter")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3148 then
        self:finish()
	 elseif roomno[1]==2775 then
		local f
		f=function()
		  self:dierzhijie_shandong()
		end
		break_npc=break_npc_id("huang lingtian|ling zhentian")--������*|������
        self:break_in("huang lingtian|ling zhentian",f)
	 else
	     local f=function()
	    local w
		w.user_alias=self
		w=walk.new()
		w.walkover=function()
		   self:dierzhijie_shandong()
		end
		w:go(2775)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--1425 3152
function alias:changzhouyayi_fuyazhenting()
   world.Send("west")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3152 then
        self:finish()
	 elseif roomno[1]==1425 then
		local f
		f=function()
		  self:changzhouyayi_fuyazhenting()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changzhouyayi_fuyazhenting()
		end
		w:go(1425)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--ne;n;nw;sw;w;ne;w;s;nw;sw;n;enter;u ��ȥ
--ne;se;n;e;sw;e;ne;se;s;se;e;e;e;s;s ����

--nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n ����-��Ħ��
--[[function alias:zhulin_damodong()

  --world.Execute("sw;se;n;s;w;e;w;e;e;s;w;n;nw;n")
                 --nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==4058 then --3171
        self:finish()
	 elseif roomno[1]==3172 or roomno[1]==1753 then

	     local dx={"southwest","southeast","north","south","west","east","west","east","east","south","west","north","northwest"} --,"north"
	       alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do
			  print(j.."/14 ����:",d)
		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("�ߵ��׽���")
			alias.co=nil
		    self:zhulin_damodong()
		 end)
		self:songlin_check()
		--self:zhulin_damodong()
	 else
	    local w
		w=walk.new()
		w.walkover=function()
		   self:zhulin_damodong()
		end
		w:go(1753)
	 end
   end
   _R:CatchStart()

end]]


local zhulin_count=0
function alias:zhulin_damodong()

  --world.Execute("sw;se;n;s;w;e;w;e;e;s;w;n;nw;n")
                 --nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n
   local _R
   _R=Room.new()
    zhulin_count=zhulin_count+1
	   local n=zhulin_count
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==4077 then --3171
	      world.Send("north")
	      zhulin_count = 0
        self:finish()
	 elseif roomno[1]==4058 then
	    self:finish()
   elseif roomno[1]==3171  then
        zhulin_count = 0
        self:finish()
   elseif roomno[1]==3172  then
        world.Execute("nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n;out")
        self:zhulin_damodong()
   elseif roomno[1]==4076  then
        zhulin_count = 0
        local dx={"southeast","north","south","west","east","west","east","east","south","west","north","northwest"} --,"north"

		alias.circle_co=coroutine.create(function()
          --print("����3")
          for j,i in ipairs(dx) do
			print(j.."/13 ����:",i)
	       world.Send(i)
           self:circle_done("zhulin_damodong")
	       coroutine.yield()
	      end
	      self:zhulin_damodong()
        end)
		coroutine.resume(alias.circle_co)
	     --[[  alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do

		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("�ߵ��׽���")
			alias.co=nil
		    self:zhulin_damodong()
		 end)
		self:songlin_check()]]
	 elseif roomno[1]==1753 then
       zhulin_count = 0
	     local dx={"southwest","southeast","north","south","west","east","west","east","east","south","west","north","northwest"} --,"north"

		 alias.circle_co=coroutine.create(function()
          --print("����3")
          for j,i in ipairs(dx) do
			print(j.."/14 ����:",i)
	       world.Send(i)
           self:circle_done("zhulin_damodong")
	       coroutine.yield()
	      end
	      self:zhulin_damodong()
        end)
		coroutine.resume(alias.circle_co)

	   --[[    alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do
			  print(j.."/14 ����:",d)
		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("�ߵ��׽���")
			alias.co=nil
		    self:zhulin_damodong()
		 end)
		self:songlin_check()]]
		--self:zhulin_damodong()
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zhulin_damodong()
		end
		w:go(1753)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

local ruxiaofu_count=0
function alias:ruxiaofu()
	local w=walk.new()
	w.walkover=function()
	      local pfm=world.GetVariable("pfm") or ""
		  pfm=convert_pfm(pfm)
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
		world.Send("kill ren feiyan")
		wait.make(function()
		   local l,w=wait.regexp("^(> |)�η��ࡸž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",30)
		   if l==nil then
			  self:ruxiaofu()
			  return
		   end
		   if string.find(l,"�����ų鶯�˼��¾�����") then
		      local b=busy.new()
			  b.interval=0.5
			  b.Next=function()
		        world.Send("get silver from corpse")
				world.Send("get jin chai from corpse")
			    self:xiaofudamen_xiaofudating()
			  end
			  b:check()
		      return
		   end
		   if string.find(l,"����û�������") then
		      ruxiaofu_count=ruxiaofu_count+1
			  if ruxiaofu_count>5 then
			     print("���Գ���5�η���")
				 self:break_in_failure()
				 return
			  end
		      local f=function()
			     self:ruxiaofu()
			  end
		      f_wait(f,5)
		   end
        end)
	end
	w:go(764)
end

function alias:xiaofudamen_xiaofudating()
  world.Send("give jin chai to zhang ma")
  world.Send("north")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3177 then
        self:finish()
	 elseif roomno[1]==769 then

	  exps=tonumber(world.GetVariable("exps")) or 0 --����

        if defeat_guard("ren feiyan",exps) then
		 --��
		    ruxiaofu_count=0
		    self:ruxiaofu()
		else
		  --��
		   self.break_in_failure()
		end

	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaofudamen_xiaofudating()
		end
		w:go(769)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--126 2766
function alias:bingying_wuqiku()
   world.Send("south")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==2766 then
        self:finish()
	 elseif roomno[1]==126 then
		local f
		f=function()
		  self:bingying_wuqiku()
		end
		break_npc=break_npc_id("guan bing")
        self:break_in("guan bing",f)
	 else
	    local w
		w=walk.new()
		w.walkover=function()
		   self:bingying_wuqiku()
		end
		w:go(126)
	 end
   end
   _R:CatchStart()
end

-- �����置 ���Ѿ�����������Сʱ��ʮ����ʮ���롣
--
--[[dian fire

���ȼ�˻��ۣ����Ź����㿴�������ı�ȫ�����٣�
���ٵĿ�϶�в�����ѩ�׵�֩������
>
yao shuteng
������ҡ�����٣���Ȼ����һֻѩ�롣
>
l
ɽ�� -
    ���ɽ���������ģ����������ֲ�����ָ����ϸ��ȥ������ԼԼ���Կ�
���ı������������٣�shuteng���� ���ټ�·���ʲô���������������㲻��
�������⡣
    ����Ψһ�ĳ����� out��
  ѩ��(Xue zhu)
>
hp

����Ѫ�� 3520 /  3520 (100%)  �������� 5133 /  5133(5236)
����Ѫ�� 9075 /  9075 (100%)  ��������23906 / 12487(+1)
�������� 17,640           ���������ޡ�13395 / 15609
��ʳ�  70.00%              ��Ǳ�ܡ�  458 /  539
����ˮ��  66.25%              �����顤 8,459,185 (97.80%)
>
fight zhu

����һ������ʼ��ѩ�뷢��������

������ѩ����ɱ���㣡
ѩ��
����Σ��������: ѩ��
>
��Ծ���ڰ�գ�˫�ּ��ӣ���ָ����������ָ���ס�����ǵذ���ѩ��ӿȥ��
ѩ�뱻������ˡ��ڹ�Ѩ������Ϣ���ң�
����ָ΢�����ֵ�����ѩ��ġ����Ѩ����
ѩ��ֻ����ͷ΢΢��ѣ�������ܼ��У�
���ֻ����ѩ��һ���Һ�����ָ��������ͷ���Դ���������Ѫ�������أ���
( ѩ���Ѿ���������״̬����ʱ������ˤ����ȥ�� )

ѩ�������˼��£�һ�������ε���ȥ��


ѩ����־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��

get zhu
�㽫ѩ������������ڱ��ϡ�
>
l]]
--2351 fire

--3201 ɽ��

function alias:shanjiao_shanlu()
--����·��

   -- ɱ�置Ů����
   world.Send("northup")

   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3157 then
	    self:finish()
	 elseif roomno[1]==366 then
        --npc block
		local f
		f=function()
		  self:shanjiao_shanlu()
		end
		break_npc=break_npc_id("dizi")
        self:break_in("dizi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanjiao_shanlu()
		end
		w:go(366)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()

end



--716	3880	chuwujian_cangjinglou
function alias:chuwujian_cangjinglou()
   world.Send("up")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3880 then
	    self:finish()
	 elseif roomno[1]==716 then
        --npc block
		local f
		f=function()
		  self:chuwujian_cangjinglou()
		end
		break_npc=break_npc_id("shitai")
        self:break_in("shitai",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:chuwujian_cangjinglou()
		end
		w:go(716)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()

end


--��𱦵� ����Ժ    nd 1616 3881
--�����ʦ(Benyin dashi)
function alias:guangfobaodian_songshuyuan()
   world.Send("northdown")

   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3881 then
	    self:finish()
	 elseif roomno[1]==1616 then
        --npc block
		local f
		f=function()
		  self:guangfobaodian_songshuyuan()
		end
		break_npc=break_npc_id("benyin dashi")
        self:break_in("benyin dashi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:guangfobaodian_songshuyuan()
		end
		w:go(1616)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()

end

--������-��Ϣ��
function alias:dangtianmen_xiuxishi()
    world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==4050 then
	   self:finish()
	 elseif roomno[1]==1619 then
        --npc block
		local f
		f=function()
		  self:dangtianmen_xiuxishi()
		end
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dangtianmen_xiuxishi()
		end
		w:go(1619)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--
function alias:yitiantulong()
   local q=quest.new()
   q.quest_over=function()
      self:finish()
   end
   q:yitiantulong()
end

function alias:zuan()
   world.Send("use fire")
   local f=function()
     world.Send("zuan")
     self:finish()
   end
   f_wait(f,5)
end

function alias:zhenting_houmen()
  --1549 south 1552
    world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1552 then
	   self:finish()
	 elseif roomno[1]==1549 then
        --npc block
		local f
		f=function()
		  self:zhenting_houmen()
		end
		break_npc=break_npc_id("guan jia")
        self:break_in("guan jia",f)
	 else
	    local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zhenting_houmen()
		end
		w:go(1549)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--֤��Ժ
function alias:zhendaoyuan_chanfang()
  --1549 south 1552
    world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==840 then
	   self:finish()
	 elseif roomno[1]==839 then
        --npc block
		local f
		f=function()
		  self:zhendaoyuan_chanfang()
		end
		break_npc=break_npc_id("xuansheng dashi")
        self:break_in("xuansheng dashi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zhendaoyuan_chanfang()
		end
		w:go(839) end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--֤��Ժ
function alias:xilianwuchang_shibanlu()
  --1549 south 1552
    world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==3985 then
	   self:finish()
	 elseif roomno[1]==1627 then
        --npc block
		local f
		f=function()
		  self:xilianwuchang_shibanlu()
		end
		break_npc=break_npc_id("chanshi")
        self:break_in("chanshi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xilianwuchang_shibanlu()
		end
		w:go(1627) end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:xidajie_shouxihujiulou()

      world.Send("north")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==109 then
	     self:finish()
	   elseif roomno[1]==108 then
		  local f=function()
		    self:xidajie_shouxihujiulou()
		  end
		  f_wait(f,10)
	   else

		local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xidajie_shouxihujiulou()
		end
		w:go(108)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:xidajie_shoushidian()

      world.Send("south")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==111 then
	     self:finish()
	   elseif roomno[1]==108 then
		  local f=function()
		    self:xidajie_shoushidian()
		  end
		  f_wait(f,10)
	   else

		local f=function()
          local w
	  	  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		   self:xidajie_shoushidian()
		  end
		  w:go(108)
		end
		 self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:duanyaping_yading()
	self:noway()
    --self:finish()
end

--Ĭ���Թ�������
--job�Թ�����ӿں���
function alias:maze_done()
     print("Ĭ���Թ�����")
    self.maze_step()
end

function alias:huigong()
	world.Send("huigong")

	local b=busy.new()
	 b.interval=0.9
	b.Next=function()
      self:finish()
	end
	b:check()
end

function alias:push_door()
   --print("why")
   world.Send("push door")
   local b=busy.new()
   b.interval=0.9
		 b.Next=function()
	       self:finish()
	end
   b:check()
end
function alias:climb_shanlu()
   --print("why")
   world.Send("climb ɽ·")
   local b=busy.new()
   b.interval=0.9
		 b.Next=function()
	       self:finish()
	end
   b:check()
end

function alias:siguoya_jiashanbi()
    world.Send("enter")
    local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==4986 then
	     self:finish()
	   elseif roomno[1]==1537 then
		  local f=function()
		    self:siguoya_jiashanbi()
		  end
		  f_wait(f,5)
	   else

		local f=function()
          local w
	  	  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		   self:siguoya_jiashanbi()
		  end
		  w:go(1537)
		end
		 self:redo(f)
	    end
       end
       _R:CatchStart()

end
--4244
--211 ������ huigong ��ɽ 2304
--��ɽ 2304 leave 633 ����ɽ
function alias:huapu_caojing(dx)
  if dx==nil then
     dx="e"
  end
  world.Send(dx)
  wait.make(function()

	 local l,w=wait.regexp("^(> |)���� \\-.*$|^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)���۵ð�����ȴ��Ȼ�������߻���ţ�$|^(> |)������һ������Ȼ��ǰһ��������һ���ݾ���$|^(> |)�������û�г�·��$",5)
	 if l==nil then
        --print("test3")
	    self:huapu_caojing()
	    return
	 end
	 if string.find(l,"��Ķ�����û�����") then
	   --print("test")
	    wait.time(0.3)
		self:huapu_caojing()
		return
	 end
	 if string.find(l,"ȴ��Ȼ�������߻���ţ��") then
	    world.Send("yun jing")
	    world.Send("northdown")

		wait.time(0.3)
	    self:huapu_caojing(dx)
	    return
	 end
     if string.find(l,"��Ȼ��ǰһ��") then
	    self:finish()
	    return
	 end
     if string.find(l,"�������û�г�·") then
        self:finish()
		return
	 end
     if string.find(l,"����") then
	    --print("test2")
		world.Send("yun jing")
		wait.time(0.8)
		self:huapu_caojing()

        return

	 end

 end)
end

function alias:niupeng_caojing()
   world.Send("northdown")
   wait.make(function()
      local l,w=wait.regexp("^(> |)�ݾ� \\-.*$|^(> |)���� \\-.*$",1.2)
	  if l==nil then
	     self:finish()
	     return
	  end
	  if string.find(l,"�ݾ�") then
	     self:finish()
	     return
	  end
	  if string.find(l,"����") then
	     self:huapu_caojing()
	     return
	  end
   end)
end

function alias:huapu_niupeng()
 world.Send("s")
  wait.make(function()


	 local l,w=wait.regexp("^(> |)���� \\-.*$|^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)���۵ð�����ȴ��Ȼ�������߻���ţ�$|^(> |)�������û�г�·��$",5)
	 if l==nil then
        --print("test3")
	    self:huapu_niupeng()
	    return
	 end
	 if string.find(l,"��Ķ�����û�����") then
	   --print("test")
	    wait.time(0.3)
		self:huapu_niupeng()
		return
	 end
     if string.find(l,"ȴ��Ȼ�������߻���ţ��") then
	    self:finish()
	    return
	 end
     if string.find(l,"�������û�г�·") then
        self:finish()
		return
	 end
     if string.find(l,"����") then
	    --print("test2")
		wait.time(0.3)
		self:huapu_niupeng()

        return

	 end

 end)
end


function alias:caojing_niupeng()
   world.Send("south")
    wait.make(function()
      local l,w=wait.regexp("^(> |)�ݾ� \\-.*$|^(> |)���� \\-.*$",1.2)
	  if l==nil then
		 self:finish()
	     return
	  end
	  if string.find(l,"�ݾ�") then
	     self:finish()
	     return
	  end
	  if string.find(l,"����") then
	     self:huapu_niupeng()
	     return
	  end
   end)
end

function alias:ask_qiuqianzhang(roomno)
    if roomno==nil then
      roomno=2427
    end
    local w
	w=walk.new()
	w.walkover=function()
		world.Send("ask qiu qianzhang about �ֹ�")
		wait.make(function()
		  local l,w=wait.regexp("^(> |)������ǧ�ɴ����йء��ֹ�����Ϣ��$|^(> |)����û������ˡ�$",5)
		  if l==nil then
		    self:ask_qiuqianzhang(roomno)
			return
		  end
		   if string.find(l,"����û�������")  then
			print("���߿���")
			   local _R
             _R=Room.new()
              _R.CatchEnd=function()
              local count,roomno=Locate(_R)

                   print("��ǰ�����:",roomno[1])
	                     if roomno[1]==2424 then
	                          self:ask_qiuqianzhang(245)
	                      elseif roomno[1]==245 then
	                          self:ask_qiuqianzhang(244)
			       elseif roomno[1]==244 then
			          self:ask_qiuqianzhang(1929)
					elseif roomno[1]==1929 then
					   self:ask_qiuqianzhang(2417)
    			      elseif roomno[1]==2417 then
			           self:ask_qiuqianzhang(2427)
					  elseif roomno[1]==2427 then
					     self:ask_qiuqianzhang(2416)
					  else
			           self:ask_qiuqianzhang(2424)
					  end
                           end
                           _R:CatchStart()
			  end
		  if string.find(l,"������ǧ�ɴ����йء��ֹ�����Ϣ") then
		   local b
		      	   b=busy.new()
			       b.interval=0.3
				   b.Next=function()
				   local w1
               w1=walk.new()
               w1.walkover=function ()
	              self:movebei()
				       end
               w1:go(4009)
			       end
			       b:check()
		          return
			   end
		  wait.time(5)
		end)
	end
	w:go(roomno)
end

function alias:tzmovebei()
  local w=walk.new()
  w.walkover=function()
     self:movebei()
  end
  w:go(4009)

end

function alias:movebei()
   wait.make(function()
   --���в�ѽ��û����Ĺ����ʲô����
   world.Send("move bei")
   local l,w=wait.regexp("^(> |)������������������˿�������Ĺ�������������ƿ���$|^(> )���в�ѽ��û����Ĺ����ʲô.*$|^(> )ʲô��$",5)
   if l==nil then
	   self:movebei()
	   return
	end
	if string.find(l,"���в�ѽ��û����Ĺ����ʲô") or string.find(l,"ʲô��") then
	  local w1
           w1=walk.new()
           w1.walkover=function ()
	           wait.make(function()
	           world.Send("ask qiu qianzhang about �ֹ�")
		        local l,w=wait.regexp("^(> |)��һЩ����˵�����������������ϵķ�Ĺ�У������������ٺ٣�һ����ʲô���������棡$|^(> |)����û������ˡ�$",5)
		       if l==nil then
                print("����̫�����Ƿ�����һ����Ԥ�ڵĴ���")
		        self:movebei()
		        return
			   end
			     if string.find(l,"����û�������") then
			       self:ask_qiuqianzhang(roomno)
              return
			   end
		       if string.find(l,"���������������ϵķ�Ĺ��")  then
		          local b
		      	   b=busy.new()
			       b.interval=0.3
				   b.Next=function()
			         self:tzmovebei()
			       end
			       b:check()
		          return
			   end
	       end)
         end
		   local b=busy.new()
		   b.Next=function()
              w1:go(1929)
		   end
           b:check()
		    return
		  end
   if string.find(l,"������������������˿�������Ĺ�������������ƿ�") then
	    local b=busy.new()
		b.interval=0.3
		b.Next=function()
		    world.Send("enter")
	      self:finish()
		end
		b:check()
	   return
	end
  end)
end

function alias:caoyuanbianyuan_heishiweizi()
   world.Execute("n;n;n;n")
   self:finish()
end

function alias:danfang_eyutan()
   world.Execute("tui zhonglu;tui donglu middle;tui xilu east;tui zhonglu west")
   self:finish()
end

function alias:ta_corpse()

     local pfm=world.GetVariable("pfm") or ""
	    pfm=convert_pfm(pfm)
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
   world.Send("kill e yu")
   world.Send("ta corpse")
   wait.make(function()
     local l,w=wait.regexp("^(> |)������̤���������ϣ��辢Ծ�𣬽�������������ı���һ�㡣����Ծ���԰���$",5)
	 if l==nil then
	    local _R=Room.new()
		_R.CatchEnd=function()
		   if _R.roomname=="����̶" then
	         self:ta_corpse()
		   else
		      local w=walk.new()
			  w.walkover=function()
			     self:ta_corpse()
			  end
			  w:go(4996)
		   end
		end
		_R:CatchStart()
	    return
	 end
	 if string.find(l,"����Ծ���԰�") then
	    self:finish()
	    return
	 end
   end)
end

function alias:enter_dong()
   world.Send("enter dong")
   self:finish()
end

function alias:climb_down()
   world.Send("climb down")
   wait.make(function()
     local l,w=wait.regexp("^(> |)����ǰ��Ȼһ����ɽ��Խ��Խ�󣬵���Խ��Խƽ����$",5)
	 if l==nil then
	    self:climb_down()
	    return
	 end
	 if string.find(l,"����ǰ��Ȼһ��") then
	    local b=busy.new()
		b.interval=8
		b.Next=function()
		  self:finish()
		end
		b:check()
	    return
	 end
   end)
end

function alias:shiku_shibi()
   world.Send("l tree")
--����һ������������֦Ҷïʢ�����������ӡ�
   world.Send("zhe shugan")
   --������һ��������֦�ɣ���Լһ����ߡ�
  --��Ѿ��ش������ϰ�����Ƥ��
  --bo shupi
  --ʲô��
  local b=busy.new()
  b.Next=function()
   world.Execute("#7 bo shupi")

   --��Ѿ��ش������ϰ�����Ƥ��
   world.Send("cuo shupi")
   --�����Ƥ��ʳ������Ѿ����������Ű���Ƥ���һ�����������ӡ�
   --����ס����������ʯ�ڣ�һ·������Ԯ��
     local b2=busy.new()
     b2.Next=function()
		world.Send("drop corpse")
        world.Send("climb shibi")
        self:finish()
	 end
     b2:check()

  end
  b:check()
end

function alias:shibi_liguifeng()
    world.Send("west")
	world.Send("drop corpse")
    world.Send("climb shibi")
	world.Send("fu shugan")
     --�㽫����һ�˸��������м䡣
   world.Send("shuai shugan")
 wait.make(function()
    local l,w=wait.regexp("^(> |)����ʲô����ˤ����$|^(> |)��һ�¾���ʹ��ǡ���ô�����������ʱ���ú���ڶ�Ѩ���ϡ�$|^(> |)�������������ˤ��ȥ�к��ã�$|^(> |)���Ѿ�������ˤ����Ѩ�ˡ�$",6)

	if l==nil then
		self:shibi_liguifeng()
	    return
	end
	if string.find(l,"����ʲô����ˤ��") or string.find(l,"�������������ˤ��ȥ�к���") then
        world.Send("climb down")
       self:shiku_shibi()
	   return
	end
	if string.find(l,"��һ�¾���ʹ��ǡ���ô�") or string.find(l,"���Ѿ�������ˤ����Ѩ��") then
      local b=busy.new()
	  b.Next=function()
        world.Send("climb up")
        self:finish()
      end
      b:check()
	  return
	end
 end)
end

function alias:shiguoya_shiguoyadongkou()
   world.Send("enter")
   self:finish()
end

function alias:dagebi_caoyuan()
  --dagebi_caoyuan
   --world.Send("ado s|s|s|s|s|s|s|s|s|s|s|s|s|s")
   world.Execute("#14s")
   --��ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪���ˡ���
   self:finish()
end

--��һ�ƴ�ʦ
--ɽ���ٲ� 521 ��ʼ
function alias:yuren()
  wait.make(function()
    world.Send("ask yu about һ�ƴ�ʦ")
    world.Send("l pubu")
    wait.time(2)
    world.Send("tiao pubu")
	local l,w=wait.regexp("^(> |)�㵱��һ�ﲻ����Ҳ�����¿�Ь�࣬ӿ������ٲ������䡣$",5)
    if l==nil then
	   self:yuren()
	   return
	end
	if string.find(l,"ӿ������ٲ�������") then

	   	local sp=special_item.new()
	    sp.cooldown=function()
           self:zhuawawayu()
        end
        sp:unwield_all()

	   return
	end

  end)
end

function alias:zhuawawayu()

  wait.make(function()
	world.Send("yun qi")
	wait.time(1.5)
	world.Send("zhua yu")

    local l,w=wait.regexp("^(> |)���������������գ��Ⱥ����ʯ�ס�$|^(> |)������ɽ�ȼ伤���������������Ȼ���ò����������ץס����Խ����ޡ�$",5)
	if l==nil then
	   self:zhuawawayu()
	   return
	end
	if string.find(l,"���������������գ��Ⱥ����ʯ��") then
	   wait.time(3)
	   self:zhuawawayu()
	   return
	end
	if string.find(l,"�����ץס����Խ�����") then
	   wait.time(5)
	   world.Send("tiao anbian")
	   world.Send("give yu yu")
	   wait.time(5)
	   world.Send("zhi tie zhou")
	   self:tiezhou()
	   return
	end
  end)
end

function alias:tiezhou()
	local sp=special_item.new()
	sp.cooldown=function()
      world.Send("wield jiang")
      self:huaboat()
   end
   sp:unwield_all()
end

function alias:huaboat()
  world.Send("hua boat")
  wait.make(function()
     local l,w=wait.regexp("^(> |)���Ѿ��������ˣ���취�ϰ��ɣ�$",3)
	 if l==nil then
		self:huaboat()
	    return
	 end
	 if string.find(l,"��취�ϰ���") then
	    world.Send("tiao shandong")
		world.Send("out")
		wait.time(10)

		self:qiaofu()
	    return
	 end
  end)
end

function alias:qiaofu()
  world.Send("answer ��ɽ����������మ���β��������۹��ƽ����һéի��Ұ����������˭���˷�˭�ɰܣ�ª�ﵥư�����ա�ƶ�������ģ��־���ģ�")
  world.Send("pa teng")
  world.Send("eu")
  wait.make(function()
     local l,w=wait.regexp("^(> |)�������ڲ࣬��ס�����·�ߡ�$|^(> |)�����������д��ã��Ŀ�����֮�ʣ���ɽ��һָ��������ȥ�գ�$|^(> |)����ʮ���ɣ������������������ڳ�����$",5)
	 if l==nil then
	    self:qiaofu()
	    return
	 end
	 if string.find(l,"�������ڲ࣬��ס�����·��") then
	    wait.time(1)
		self:qiaofu()
	    return
	 end
	 if string.find(l,"��ɽ��һָ") or string.find(l,"����ʮ���ɣ������������������ڳ���") then
	     wait.time(2)
        self:nongfu()
		return
	 end
  end)
end

function alias:nongfu()
-- ��Ҫ2500 ����
  local x
   x=xiulian.new()
   x.halt=false
   x.min_amount=100
   x.safe_qi=500
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

   end
	x.success=function(h)
       self:nongfu()
	end
  local h=hp.new()
  h.checkover=function()
   if h.neili>2500 then

   world.Send("tuo shi")
   world.Send("e")
   wait.make(function()
     local l,w=wait.regexp("^(> |)ũ��˫����ס��ʯ�������˾���ͦ���ʯ������˵��������л���������ȥ�ɡ���$|^(> |)ʯ�� -$",8)
	  if l==nil then
	     self:nongfu()
	     return
	  end
	  if string.find(l,"��л���������ȥ��") then
	     wait.time(2)
	     world.Send("e")
		 self:shiliang()
	     return
	  end
	  if string.find(l,"ʯ��") then
	     self:shiliang()
	     return
	  end
   end)
   else
      print("����������2500")
	  x:dazuo()

   end
 end
 h:check()
end

function alias:tui_westwall()
   world.Send("tui westwall")
   world.Send("out")
   self:finish()
end

function alias:tui_eastwall()
   world.Send("tui eastwall")
   world.Send("enter")
   self:finish()
end

--6154 6155 ����ɳĮ �������
function alias:shamo_lvzhou()
   world.Execute("#10n")
   wait.make(function()
     local l,w=wait.regexp("^(> |).*�������.*",2)
	 if l==nil then
	     self:shamo_lvzhou()
	    return
	 end
	  if string.find(l,"�������") then

	     world.Send("yun heal")
		 wait.time(3)
		  local b=busy.new()
		  b=busy.new()
		  b.Next=function()
	        self:finish()
		  end
		  b:check()
	    return
	 end
   end)
end

function alias:shiliang()

   local x
   x=xiulian.new()
   x.halt=false
   x.min_amount=100
   x.safe_qi=500
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

   end
	x.success=function(h)
       self:shiliang()

	end

   	local h
	h=hp.new()
	h.checkover=function()
	    if h.neili>1000 then
		   world.Send("jump front")  --ÿ�ε�1000����
		  wait.make(function()
            local l,w=wait.regexp("^(> |)��Ҫ��˭�����������$|^(> |)ʯ�� -$",3)
	          if l==nil then
			     self:shiliang()
		        return
		      end

		      if string.find(l,"��Ҫ��˭���������") then
		        self:shusheng()
		        return
		      end
			  if string.find(l,"ʯ��") then
			    self:shiliang()
                return
			  end
          end)
		else
		   x:dazuo()
		end

	end
	h:check()
end

function alias:shusheng()
     world.Send("ask shu about һ�ƴ�ʦ")

     local f=function()
	   world.Send("ask shu about ��Ŀ")
	   local f2=function()
	     world.Send("answer ��δ״Ԫ")
		 local f3=function()
	       world.Send("answer ˪���Ҷ�����Ź����ң��")
		   local f4=function()
	         world.Send("answer �������ˣ���С����Զǳ�")
	        local b=busy.new()
	         b.Next=function()
	           world.Send("n")
		       self:finish()
	         end
	         b:check()
		   end
		   f_wait(f4,2)
		 end
		 f_wait(f3,2)
	   end
	   f_wait(f2,2)

	 end
	 f_wait(f,2)

end

function alias:jingxiushi_houshan()
    world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==5010 then
	   self:finish()
	 elseif roomno[1]==4156 then
        --npc block
		local f
		f=function()
		  self:jingxiushi_houshan()
		end
		break_npc=break_npc_id("liu chuxuan")
        self:break_in("liu chuxuan",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jingxiushi_houshan()
		end
		w:go(4156)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shibixia_dongkou()
  world.Execute("si teng;tui dashi right;tui dashi right;tui dashi right;huang dashi left;huang dashi left;enter")
  self:finish()
end

function alias:shatan2(count)
 wait.make(function()
      local l,w,styles=wait.regexp(".*ɳ̲.*|^(> |)�趨����������action \\= \\\"ɳ̲��\\\"$",5)
	  if l==nil then

	      return
	  end
	  if string.find(l,"�趨����������action") then
	     self:xiaodao_shatan2()
	     return
	  end
	  if string.find(l,"ɳ̲") then

	   for _, v in ipairs (styles) do
          print (RGBColourToName (v.textcolour), RGBColourToName (v.backcolour), v.text)
		  if Trim(v.text)=="ɳ̲" then
		     count=count+1
			 print(count," count")
			 if RGBColourToName(v.textcolour)=="magenta" then
		       if count==1 then
			    world.Send("n")
				self:finish()
				return
			   elseif count==2 then
			     world.Send("w")
				 self:finish()
				 return
			   elseif count==3 then
			      world.Send("e")
				  self:finish()
				  return
			   elseif count==4 then
			      world.Send("s")
				  self:finish()
				  return
			   end

			 end

		  end
	   end -- for each style run
	     self:noway()

		 --self:finish()
       --if count<4 then
		--self:shatan2(count)
	   --end
	     return
	  end
   end)
end

function alias:xiaodao_shatan2()
   world.Send("look")
   world.Send("set action ɳ̲��")
   self:shatan2(0)
      --[[                      ɳ̲
silver black
blue black ɳ̲
silver black
                             ��
                   ɳ̲--    С��--ɳ̲
silver black
blue black ɳ̲
silver black --
olive black С��
silver black --
blue black ɳ̲
silver black
                             ��
                            ɳ̲
silver black
magenta black ɳ̲
silver black   ]]

end

function alias:si_teng()
  world.Send("si teng")
  self:finish()
end

function alias:banshan_shangugudi()
  world.Send("down")
  world.Send("down")
  world.Send("down")
  self:finish()
end

--����� > ʲô?
function alias:duanchang_gudi()
--ʲô��
    world.Execute("#9 cuo shupi")
  wait.make(function()
     local l,w=wait.regexp("^(> |)��Ƥ����������ˣ��㻹��ʲô����$|^(> |)ʲô.*$",5)
	 if l==nil then
	    self:duanchang_gudi()
	    return
	 end
	  if string.find(l,"��Ƥ���������") then
	   world.Send("bang song")
	    self:yabi_gudi()
	   return
	 end
	 if string.find(l,"ʲô") then
	    local w=walk.new()
		w.walkover=function()
		   self:duanchang_gudi()
		end
		w:go(3012)
	    return
	 end

  end)
end

function alias:gudi_duanchang()
   world.Send("pa yabi")
   local f=function()
     self:yabi_duanchang()
   end
   f_wait(f,1.5)
end

function alias:yabi_gudi()
   world.Send("pa down")
   wait.make(function()
      local l,w=wait.regexp("^(> |)�ȵ� -.*$|^(> |)�±� -.*$|^(> |)�����Ѿ��ž������޷������������ˣ�$|^(> |)��Ҫ��������$",2)
	  if l==nil then
	      self:yabi_gudi()
	      return
	  end
	  if string.find(l,"�±�") then
	     wait.time(1.5)
		 self:yabi_gudi()
	     return
	  end
	  if string.find(l,"�ȵ�") or string.find(l,"��Ҫ������") then
         wait.time(1.5)
		self:finish()
	    return
	  end
   end)
end

function alias:yabi_duanchang() --ˮ̶������ �ص�3012
 world.Send("pa up")
   wait.make(function()
      local l,w=wait.regexp("^(> |)�ͱ� -.*$|^(> |)�±� -.*$|^(> |)��Ҫ��������$",2)
	  if l==nil then
	      self:yabi_duanchang()
	      return
	  end
	  if string.find(l,"�±�") then
	     wait.time(1.5)
		 self:yabi_duanchang()
	     return
	  end
	  if string.find(l,"�ͱ�") or string.find(l,"��Ҫ������") then
         wait.time(1.5)
		self:finish()
	    return
	  end
   end)
end

function alias:gudi_gudishuitan()  --��Ҫ������ϸ��� ��Ҫ50%����
  --��Ҫ����³�ʼ�ĸ��� �������50% ���ڽ���ˮ̶
  local sp=special_item.new()
  sp.cooldown=function()  --������
	 if sp.weight<50 then
	  world.Execute("#10 jian shi")  --�ȵ�ˮ̶
      world.Send("tiao tan")
      self:qian_down()
	 else
	   self:noway()
	 end

  end
  local tb={}
  sp:check_items(tb,false)
end

function alias:tanan_tongdao() --ͨ��
   world.Execute("#10 jian shi")
   world.Send("tiao tan")
   self:qian_down()
end

function alias:tongdao_gudi()  --qian zuoshang ���  qian up ����
   world.Send("qian up")
   local f=function()
      self:qian_up()
   end
   f_wait(f,1.5)
end

function alias:guditan_tanan()   --qian zuoshang ���  qian up ����
   world.Send("qian zuoshang")
   local f=function()
      self:qian_up()
   end
   f_wait(f,1.5)
end

local try_qian_up=0
function alias:qian_down()
   world.Send("qian down")
   wait.make(function()
     local l,w=wait.regexp("^(> |)һ�����ԣ�Ǳ����ȥ��$|^(> |)��Ҫ������Ǳ��$|^(> |)�����������������޷�������Ǳ!$|^(> |)ʲô��$",5)
	 if l==nil then
	    self:qian_down()
	    return
	 end
	 if string.find(l,"ʲô") then
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
       local count,roomno=Locate(_R)
	    print("��ǰ�����",roomno[1])
	   if roomno[1]==5081 then
	      self:finish()
	   else
	      local f=function()
            local w
		    w=walk.new()
	     	w.user_alias=self
		    w.walkover=function()
		     self:qian_down()
		    end
		    w:go(5082)
		   end
		   self:redo(f)
	    end
      end
       _R:CatchStart()
	    return
	 end
	 if string.find(l,"������������") then
	    world.Send("pa up")
		local f=function()
		   world.Execute("#10 jian shi")
           world.Send("tiao tan")
		   self:qian_down()
		end
        f_wait(f,1)
	    return
	 end
	 if string.find(l,"��Ҫ������Ǳ") then
		wait.time(1.5)
		world.Execute("#10 drop stone")
		try_qian_up=0
		self:finish()
	    return
	 end
	 if string.find(l,"Ǳ����ȥ") then
	    wait.time(1.5)
		self:qian_down()
	    return
	 end
   end)
end

function alias:pa_up()
   world.Send("pa up")
   self:finish()
end

function alias:nanjie_changjie()
   world.Send("east")
   self:finish()
end

function alias:shamo1_shamo2()
   world.Send("north")
   world.Send("south")
   self:finish()
end


function alias:qian_up()
   world.Send("qian up")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�ֽ��뻮��˳��ˮ�������渡ȥ��$|^(> |)�����ӳ��أ��þ�ȫ��Ҳ�޷�Ǳ������!$|^(> |)��Ҫ������Ǳ��$|^(> |)ʲô��$",5)
	 if l==nil then
		try_qian_up=try_qian_up+1
		if  try_qian_up>10 then
	        self:finish()
		    return
		end
		self:qian_up()
	    return
	 end
	 if string.find(l,"ʲô") then

	       self:finish()
		 --end
	    return
	 end
	 if string.find(l,"�����ӳ���") then
	   if try_qian_up==0 then
	    world.Execute("#10 drop stone;drop coin")
	   elseif try_qian_up==1 then
	     world.Execute("#10 drop stone;drop silver")
	   elseif try_qian_up==2 then
	        world.Execute("#10 drop stone;drop gold")
	   else
	      world.Execute("drop tuichui;drop hammer;drop zhang;drop armor;drop dao")
	   end
	    try_qian_up=try_qian_up+1

		local f=function()
		  self:qian_up()
		end
		f_wait(f,1.5)
	    return
	 end
	 if string.find(l,"��Ҫ������Ǳ") then
	    wait.time(1.5)
		world.Send("pa up")
		wait.time(1.5)
		self:finish()
	    return
	 end
	 if string.find(l,"�ֽ��뻮��˳��ˮ�������渡ȥ") then
	    wait.time(1.5)
		self:qian_up()
	    return
	 end
   end)
end

--�뿪������Ĺ  --��������Ƿ���fire
function alias:search_fire()
  local w=walk.new()
   w.walkover=function()
     world.Execute("#5 search qiangjiao")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)����ǽ�ŵ���Ʒ���﷭����ȥ�ҳ�һ�ѻ��ۡ�$|^(> |)���Ѿ����˻����ˣ���ô��ô̰�ģ�$",5)
	   if l==nil then
	      self:search_fire()
	      return
	   end
	   if string.find(l,"����ǽ�ŵ���Ʒ���﷭����ȥ�ҳ�һ�ѻ���") or string.find(l,"���Ѿ����˻�����") then
	      world.Execute("n;n;w;n")
	      self:ws_ss()
	      return
	   end
	 end)
   end
   w:go(5056)
end

function alias:ws_ss()
   world.Execute("tang bed;ban shiban")
   wait.make(function()
      local l,w=wait.regexp("^(> |)��ʹ�����̵ľ�������ʯ��ȴ��˿������$|^(> |)�㷢��ʲô�ط�����ס�ˣ���ôҲ�ⲻ��ʯ�塣$|^(> |)�������⶯ͻ���ʯ�壬ֻ�����������죬ʯ���������²�ʯ�ҡ�$|^(> |)ʲô��$",5)
	   if l==nil then
	      self:ws_ss()
	      return
	   end
	  if string.find(l,"ʯ��ȴ��˿����") or string.find(l,"��ôҲ�ⲻ��ʯ��") then
	     print("exp����100000 �� ��������500")
	     return
	  end
	  if string.find(l,"�����⶯ͻ���ʯ��") then
	     self:finish()
	     return
	  end
	  if string.find(l,"ʲô") then
		 local w=walk.new()
		 w.walkover=function()
		    self:ws_ss()
		 end
		 w:go(5050)
	     return
	  end
   end)

end

function alias:ss_ws()
  world.Execute("tui shibi;up")
  self:finish()
end

function alias:chy0_chy1()
  world.Execute("give xiaohuo 5 silver;nu")
  self:finish()
end

--5084---5083
function alias:shishi4_shishi0(dir)
--�����������Լ�������֧.....
--5084
  if dir==nil or dir=="s" then
     dir="e"
  elseif dir=="e" then
     dir="w"
  elseif dir=="w" then
     dir="n"
  elseif dir=="n" then
     dir="s"
  end
  world.Execute("#10 "..dir)
 wait.make(function()
    local l,w=wait.regexp("^(> |)�����������Լ�������֧.*$",1.5)
	if l==nil then
	   self:shishi4_shishi0(dir)
	   return
	end
	if string.find(l,"�����������Լ�������֧") then
	   local f=function()
	     local b=busy.new()
		 b.Next=function()
	       self:finish()
		 end
		 b:check()
	   end
	   f_wait(f,8)
	   return
	end
  end)
end
--5084--5085
function alias:shishi1_shishi5(dir)
--���۵ð�������춷���ǰ����һ��������
  if dir==nil or dir=="s" then
     dir="e"
  elseif dir=="e" then
     dir="w"
  elseif dir=="w" then
     dir="n"
  elseif dir=="n" then
     dir="s"
  end
  world.Execute("#6 "..dir..";yun jingli")
 wait.make(function()
    local l,w=wait.regexp("^(> |)���۵ð�������춷���ǰ����һ��������$",1.5)
	if l==nil then
	   self:shishi1_shishi5(dir)
	   return
	end
	if string.find(l,"��춷���ǰ����һ������") then
	   local b=busy.new()
	   b.Next=function()
	     self:finish()
	   end
	   b:check()
	   return
	end

 end)
end

function alias:shiguan_sshi()
--�����Ĺ�����ĵط� 5088
--> ��û�л��ۣ���ʲô��
   world.Execute("use fire;search;search;search;search;search;search;search;search;search;turn ao left")  --ʲô��
   wait.make(function()
      local l,w=wait.regexp("^(> |)�㽫��������ת�����£���Ȼ��Щ�ɶ���$|^(> |)��û�л��ۣ���ʲô.*$|^(> |)ʲô��$",5)
	  if l==nil then
	     self:shiguan_sshi()
	     return
	  end
	  if string.find(l,"��û�л���") then
	    local b=busy.new()
		b.Next=function()
	     world.Execute("out;get fire;tui guangai;tang guan")
		 self:shiguan_sshi()
		end
		b:check()
	     return
	  end
	  if string.find(l,"ʲô") then
	     local w=walk.new()
		 w.walkover=function()
		    self:shiguan_sshi()
		 end
		 w:go(5087)
	     return
	  end
	  if string.find(l,"�㽫��������ת������") then
	    --print("deng dai")
        local f=function()
          local b=busy.new()
	      b.Next=function()
            world.Send("ti up")
            self:finish()
	      end
	      b:check()
		end
		f_wait(f,3)
		return
      end

   end)
end

function alias:lingshi_shiguan()
  world.Execute("tui guangai;tang guan")
  self:finish()
end

function alias:walkdown()
 --��Ҫ115 force
  world.Send("look map")
 local f=function()
       world.Send("walk down")
	   local b2=busy.new()
	   b2.Next=function()
         self:finish()
	   end
	   b2:check()
 end
 f_wait(f,3)

end

function alias:gumu_shulin()
   world.Execute("#7 w")
   self:finish()
end

function alias:shulin_gumu()
    world.Execute("#7 e")
   self:finish()
end

function alias:gml_lcd()
 world.Execute("#10 e")
   self:finish()
end

function alias:tiao_anbian()
    world.Send("tiao anbian")
    self:finish()
end

function alias:hjxl_bhg()
  world.Send("find �۷�")
  wait.make(function()
    local l,w=wait.regexp("^(> |)�����������������֣��ս�һ��������ֻС������ƺ��������֣�$",2)
	if l==nil then
	   self:hjxl_bhg()
	   return
	end
	if string.find(l,"����ֻС������ƺ���������") then
	   world.Send("gensui ���")
	   wait.time(2)
	   self:finish()
	   return
	end
  end)
 -- 7066 7067

end

function alias:dxssk_dxssg()
  local f=function()
   world.Send("southup")
   self:finish()
  end
  f_wait(f,1.2)
end
function alias:tiao_up()
   world.Send("tiao up")
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
     self:finish()
   end
   b:check()
end

function alias:daxueshan_daxueshankou()
  local f=function()
   world.Send("southup")
   self:finish()
  end
  f_wait(f,1.2)
end

function alias:dongkou_shandong()
   world.Send("enter")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==5224 then
	   self:finish()
	 elseif roomno[1]==5227 then
        --npc block
		local f
		f=function()
		  self:dongkou_shandong()
		end
		break_npc=break_npc_id("sheng xiong")
        self:break_in("sheng xiong",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dongkou_shandong()
		end
		w:go(5227)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--2166
function alias:d_east()
  local b=busy.new()
  b.interval=0.5
  b.Next=function()
      world.Send("east")
	  self:finish()
  end
  b:check()
end

function alias:bydm_dlzws()  --��Ӫ����-����ָ����
 world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==7040 then
	   self:finish()
	 elseif roomno[1]==7041 then
        --npc block
		local f
		f=function()
		  self:bydm_dlzws()
		end
		break_npc=break_npc_id("guan bing")
        self:break_in("guan bing",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:bydm_dlzws()
		end
		w:go(7041)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--2816 �� 2814
function alias:zhulin_jicui()
  world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()

	 if _R.roomname=="������" then
	   self:zhulin_jicui()
	 elseif _R.roomname=="����ͤ" then
        --npc block
		self:finish()
	 else
	      self:noway()
	 end
   end
   _R:CatchStart()
end
--����ע��
function alias:register()
   --print("ע�� alias")
   local alias_item={}
	alias_item.name="xzl_gb"
	alias_item.dir="n"
	alias_item.alias=function() self:xzl_gb() end
    self.alias_table["xzl_gb"]=alias_item

    alias_item={}
	alias_item.name="d_east"
	alias_item.dir="e"
	alias_item.alias=function() self:d_east() end
	self.alias_table["d_east"]=alias_item


	alias_item={}
	alias_item.name="zhulin_jicui"
	alias_item.dir="n"
	alias_item.alias=function() self:zhulin_jicui() end
	self.alias_table["zhulin_jicui"]=alias_item

	alias_item={}
	alias_item.name="tiao_anbian"
	alias_item.dir="w"
	alias_item.alias=function() self:tiao_anbian() end
	self.alias_table["tiao_anbian"]=alias_item

	alias_item={}
	alias_item.name="tiao_up"
	alias_item.dir="e"
	alias_item.alias=function() self:tiao_up() end
	self.alias_table["tiao_up"]=alias_item

	alias_item={}
	alias_item.name="nanjie_changjie"
	alias_item.dir="e"
	alias_item.alias=function() self:nanjie_changjie() end
	self.alias_table["nanjie_changjie"]=alias_item

	alias_item={}
	alias_item.name="fengyun"
	alias_item.dir="e"
	alias_item.alias=function() self:fengyun() end
	self.alias_table["fengyun"]=alias_item

	alias_item={}
	alias_item.name="longhu"
	alias_item.dir="s"
	alias_item.alias=function() self:longhu() end
	self.alias_table["longhu"]=alias_item

	alias_item={}
	alias_item.name="bydm_dlzws"
	alias_item.dir="s"
	alias_item.alias=function() self:bydm_dlzws() end
	self.alias_table["bydm_dlzws"]=alias_item

	alias_item={}
	alias_item.name="tiandi"
	alias_item.dir="w"
	alias_item.alias=function() self:tiandi() end
	self.alias_table["tiandi"]=alias_item

	alias_item={}
	alias_item.name="dujiang"
	alias_item.dir="n"
	alias_item.alias=function() self:dujiang() end
	self.alias_table["dujiang"]=alias_item

    alias_item={}
	alias_item.name="duhe"
	alias_item.dir="nw"
	alias_item.alias=function() self:duhe() end
	self.alias_table["duhe"]=alias_item

	alias_item={}
	alias_item.name="dutan"
	alias_item.dir="w"
	alias_item.alias=function() self:dutan() end
	self.alias_table["dutan"]=alias_item

	alias_item={}
	alias_item.name="opendoornorthup"
	alias_item.dir="n"
	alias_item.alias=function() self:opendoornorthup() end
	self.alias_table["opendoornorthup"]=alias_item

	alias_item={}
	alias_item.name="opendoorsouthdown"
	alias_item.dir="s"
	alias_item.alias=function() self:opendoorsouthdown() end
	self.alias_table["opendoorsouthdown"]=alias_item

    alias_item={}
	alias_item.name="opendoornorth"
	alias_item.dir="n"
	alias_item.alias=function() self:opendoornorth() end
	self.alias_table["opendoornorth"]=alias_item

	alias_item={}
	alias_item.name="opendoorout"
	alias_item.dir="sw"
	alias_item.alias=function() self:opendoorout() end
	self.alias_table["opendoorout"]=alias_item

	alias_item={}
	alias_item.name="opendoorsouth"
	alias_item.dir="s"
	alias_item.alias=function() self:opendoorsouth() end
	self.alias_table["opendoorsouth"]=alias_item

	alias_item={}
	alias_item.name="opendooreast"
	alias_item.dir="e"
	alias_item.alias=function() self:opendooreast() end
	self.alias_table["opendooreast"]=alias_item

	alias_item={}
	alias_item.name="opendoorwest"
	alias_item.dir="w"
	alias_item.alias=function() self:opendoorwest() end
	self.alias_table["opendoorwest"]=alias_item

	alias_item={}
	alias_item.name="shulin_shendiao"
	alias_item.dir="n"
	alias_item.alias=function() self:shulin_shendiao() end
	self.alias_table["shulin_shendiao"]=alias_item

	alias_item={}
	alias_item.name="daxueshan_daxueshankou"
	alias_item.dir="s"
	alias_item.alias=function() self:daxueshan_daxueshankou() end
	self.alias_table["daxueshan_daxueshankou"]=alias_item


	alias_item={}
	alias_item.name="shulin_kongdi"
	alias_item.dir="s"
	alias_item.alias=function() self:shulin_kongdi() end
	self.alias_table["shulin_kongdi"]=alias_item

	alias_item={}
	alias_item.name="movebei"
	alias_item.dir="n"
	alias_item.alias=function() self:movebei() end
	self.alias_table["movebei"]=alias_item

	alias_item={}
	alias_item.name="songlin_shanjiao"
	alias_item.dir="e"
	alias_item.alias=function() self:songlin_shanjiao() end
	self.alias_table["songlin_shanjiao"]=alias_item

	alias_item={}
	alias_item.name="caidi_cunzhongxin"
	alias_item.dir="s"
	alias_item.alias=function() self:caidi_cunzhongxin() end
	self.alias_table["caidi_cunzhongxin"]=alias_item

	alias_item={}
	alias_item.name="tiaodown"
	alias_item.dir="sw"
	alias_item.alias=function() self:tiaodown() end
	self.alias_table["tiaodown"]=alias_item

	alias_item={}
	alias_item.name="dalunsishanmen_dianqianguangchang"
	alias_item.dir="n"
	alias_item.alias=function() self:dalunsishanmen_dianqianguangchang() end
	self.alias_table["dalunsishanmen_dianqianguangchang"]=alias_item

	alias_item={}
	alias_item.name="guangchang_shanmendian"
	alias_item.dir="n"
	alias_item.alias=function() self:guangchang_shanmendian() end
	self.alias_table["guangchang_shanmendian"]=alias_item

	alias_item={}
	alias_item.name="caoyuanbianyuan_heishiweizi"
	alias_item.dir="n"
	alias_item.alias=function() self:caoyuanbianyuan_heishiweizi() end
	self.alias_table["caoyuanbianyuan_heishiweizi"]=alias_item

	alias_item={}
	alias_item.name="knockgatesouth"
	alias_item.dir="s"
	alias_item.alias=function() self:knockgatesouth() end
	self.alias_table["knockgatesouth"]=alias_item

	alias_item={}
	alias_item.name="pullgatesouthdown"
	alias_item.dir="s"
	alias_item.alias=function() self:pullgatesouthdown() end
	self.alias_table["pullgatesouthdown"]=alias_item

	alias_item={}
	alias_item.name="opengatesouth"
	alias_item.dir="s"
	alias_item.alias=function() self:opengatesouth() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="opengateout"
	alias_item.dir="s"
	alias_item.alias=function() self:opengateout() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="opengatenorth"
	alias_item.dir="n"
	alias_item.alias=function() self:opengatenorth() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="opengateenter"
	alias_item.dir="n"
	alias_item.alias=function() self:opengateenter() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="shamo_qingcheng"
	alias_item.dir="ne"
	alias_item.alias=function() self:shamo_qingcheng() end
	self.alias_table["shamo_qingcheng"]=alias_item

	alias_item={}
	alias_item.name="heilin_gumu"
	alias_item.dir="e"
	alias_item.alias=function() self:heilin_gumu() end
	self.alias_table["heilin_gumu"]=alias_item

	alias_item={}
	alias_item.name="heilin_shulin"
	alias_item.dir="w"
	alias_item.alias=function() self:heilin_shulin() end
	self.alias_table["heilin_shulin"]=alias_item

	alias_item={}
	alias_item.name="gudelin_bailongdong"
	alias_item.dir="ne"
	alias_item.alias=function() self:gudelin_bailongdong() end
	self.alias_table["gudelin_bailongdong"]=alias_item

	alias_item={}
	alias_item.name="leave"
	alias_item.dir="se"
	alias_item.alias=function() self:leave() end
	self.alias_table["leave"]=alias_item

	alias_item={}
	alias_item.name="unwield_northup"
	alias_item.dir="n"
	alias_item.alias=function() self:unwield_northup() end
	self.alias_table["unwield_northup"]=alias_item

	alias_item={}
	alias_item.name="fumoquan_songlin"
	alias_item.dir="n"
	alias_item.alias=function() self:fumoquan_songlin() end
	self.alias_table["fumoquan_songlin"]=alias_item

	alias_item={}
	alias_item.name="songlin_fumoquan"
	alias_item.dir="e"
	alias_item.alias=function() self:songlin_fumoquan() end
	self.alias_table["songlin_fumoquan"]=alias_item

    alias_item={}
	alias_item.name="shanlu_songlin"
	alias_item.dir="n"
	alias_item.alias=function() self:shanlu_songlin() end
	self.alias_table["shanlu_songlin"]=alias_item

	alias_item={}
	alias_item.name="songlin_shanlu"
	alias_item.dir="s"
	alias_item.alias=function() self:songlin_shanlu() end
	self.alias_table["songlin_shanlu"]=alias_item

	alias_item={}
	alias_item.name="duxiaohe"
	alias_item.dir="s"
	alias_item.alias=function() self:duxiaohe() end
	self.alias_table["duxiaohe"]=alias_item

	alias_item={}
	alias_item.name="hubinxiaolu_hubinxiaolu"
	alias_item.dir="n"
	alias_item.alias=function() self:hubinxiaolu_hubinxiaolu() end
	self.alias_table["hubinxiaolu_hubinxiaolu"]=alias_item

	alias_item={}
	alias_item.name="hubinxiaolu_guiyunzhuang"
	alias_item.dir="w"
	alias_item.alias=function() self:hubinxiaolu_guiyunzhuang() end
	self.alias_table["hubinxiaolu_guiyunzhuang"]=alias_item

	alias_item={}
	alias_item.name="qusuzhou"
	alias_item.dir="nw"
	alias_item.range=10
	alias_item.alias=function() self:qusuzhou() end
	self.alias_table["qusuzhou"]=alias_item

	alias_item={}
	alias_item.name="quyanziwu"
	alias_item.dir="n"
	alias_item.range=99
	alias_item.alias=function() self:quyanziwu() end
	self.alias_table["quyanziwu"]=alias_item

	alias_item={}
	alias_item.name="shamo_sichouzhilu"
	alias_item.dir="e"
	alias_item.range=4
	alias_item.alias=function() self:shamo_sichouzhilu() end
	self.alias_table["shamo_sichouzhilu"]=alias_item

	alias_item={}
	alias_item.name="shamo_caoyuanbianyuan"
	alias_item.dir="w"
	alias_item.range=4
	alias_item.alias=function() self:shamo_caoyuanbianyuan() end
	self.alias_table["shamo_caoyuanbianyuan"]=alias_item

	alias_item={}
	alias_item.name="zhenyelin"
	alias_item.dir="n"
	alias_item.range=10
	alias_item.alias=function() self:zhenyelin() end
	self.alias_table["zhenyelin"]=alias_item

	alias_item={}
	alias_item.name="zhenyelin_circle"
	alias_item.dir="nw"
	alias_item.range=10
	alias_item.alias=function() self:zhenyelin_circle() end
	self.alias_table["zhenyelin_circle"]=alias_item

	alias_item={}
	alias_item.name="houtuqi_mingjiaoshulin1"
	alias_item.dir="w"
	alias_item.alias=function() self:houtuqi_mingjiaoshulin1() end
	self.alias_table["houtuqi_mingjiaoshulin1"]=alias_item

	alias_item={}
	alias_item.name="houtuqi_mingjiaoshulin2"
	alias_item.dir="nw"
	alias_item.alias=function() self:houtuqi_mingjiaoshulin2() end
	self.alias_table["houtuqi_mingjiaoshulin2"]=alias_item

	alias_item={}
	alias_item.name="houtuqi_mingjiaoshulin3"
	alias_item.dir="ne"
	alias_item.alias=function() self:houtuqi_mingjiaoshulin3() end
	self.alias_table["houtuqi_mingjiaoshulin3"]=alias_item

	alias_item={}
	alias_item.name="houtuqi_mingjiaoshulin4"
	alias_item.dir="sw"
	alias_item.alias=function() self:houtuqi_mingjiaoshulin4() end
	self.alias_table["houtuqi_mingjiaoshulin4"]=alias_item

	alias_item={}
	alias_item.name="bingyingdamen_bingying"
	alias_item.dir="n"
	alias_item.alias=function() self:bingyingdamen_bingying() end
	self.alias_table["bingyingdamen_bingying"]=alias_item

	alias_item={}
	alias_item.name="yamen_zhengting"
	alias_item.dir="n"
	alias_item.alias=function() self:yamen_zhengting() end
	self.alias_table["yamen_zhengting"]=alias_item

	alias_item={}
	alias_item.name="yamen_cucangshi"
	alias_item.dir="nw"
	alias_item.alias=function() self:yamen_cucangshi() end
	self.alias_table["yamen_cucangshi"]=alias_item

	alias_item={}
	alias_item.name="jumpwell"
	alias_item.dir="se"
	alias_item.alias=function() self:jumpwell() end
	self.alias_table["jumpwell"]=alias_item

    alias_item={}
	alias_item.name="pullhuan"
	alias_item.dir="w"
	alias_item.alias=function() self:pullhuan() end
	self.alias_table["pullhuan"]=alias_item

	alias_item={}
	alias_item.name="xieketing_rimulundian"
	alias_item.dir="n"
	alias_item.alias=function() self:xieketing_rimulundian() end
	self.alias_table["xieketing_rimulundian"]=alias_item

	alias_item={}
	alias_item.name="baizhangjian_xianchoumen"
	alias_item.dir="w"
	alias_item.alias=function() self:baizhangjian_xianchoumen() end
	self.alias_table["baizhangjian_xianchoumen"]=alias_item

	alias_item={}
	alias_item.name="xianchoumen_baizhangjian"
	alias_item.dir="e"
	alias_item.alias=function() self:xianchoumen_baizhangjian() end
	self.alias_table["xianchoumen_baizhangjian"]=alias_item

	alias_item={}
	alias_item.name="chengzhongxin_nanmen"
	alias_item.dir="s"
	alias_item.alias=function() self:chengzhongxin_nanmen() end
	self.alias_table["chengzhongxin_nanmen"]=alias_item

	alias_item={}
	alias_item.name="nanmen_chengzhongxin"
	alias_item.dir="n"
	alias_item.range=1
	alias_item.alias=function() self:nanmen_chengzhongxin() end
	self.alias_table["nanmen_chengzhongxin"]=alias_item

	alias_item={}
	alias_item.name="mingjiaoshulin_houtuqi"
	alias_item.dir="e"
	alias_item.alias=function() self:mingjiaoshulin_houtuqi() end
	self.alias_table["mingjiaoshulin_houtuqi"]=alias_item

	alias_item={}
	alias_item.name="shatan_shenlongdao"
	alias_item.dir="ne"
	alias.range=50
	alias_item.alias=function() self:shatan_shenlongdao() end
	self.alias_table["shatan_shenlongdao"]=alias_item

	alias_item={}
	alias_item.name="shenlongdao_shatan"
	alias_item.dir="sw"
	alias.range=50
	alias_item.alias=function() self:shenlongdao_shatan() end
	self.alias_table["shenlongdao_shatan"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_east"
	alias_item.dir="e"
	alias_item.alias=function() self:xingxiuhai_east() end
	self.alias_table["xingxiuhai_east"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_north"
	alias_item.dir="n"
	alias_item.alias=function() self:xingxiuhai_north() end
	self.alias_table["xingxiuhai_north"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_west"
	alias_item.dir="w"
	alias_item.alias=function() self:xingxiuhai_west() end
	self.alias_table["xingxiuhai_west"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_south"
	alias_item.dir="s"
	alias_item.alias=function() self:xingxiuhai_south() end
	self.alias_table["xingxiuhai_south"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_search"
	alias_item.dir="n"
	alias_item.alias=function() self:xingxiuhai_search() end
	self.alias_table["xingxiuhai_search"]=alias_item

	alias_item={}
	alias_item.name="shanmen_shanlu"
	alias_item.dir="n"
	alias_item.alias=function() self:shanmen_shanlu() end
	self.alias_table["shanmen_shanlu"]=alias_item

	alias_item={}
	alias_item.name="baishilu_tianwangdian"
	alias_item.dir="n"
	alias_item.alias=function() self:baishilu_tianwangdian() end
	self.alias_table["baishilu_tianwangdian"]=alias_item

	alias_item={}
	alias_item.name="tanqin"
	alias_item.dir="n"
	alias_item.alias=function() self:tanqin() end
	self.alias_table["tanqin"]=alias_item

	alias_item={}
	alias_item.name="qumr"
	alias_item.dir="s"
    alias_item.range=10
	alias_item.alias=function() self:qumr() end
	self.alias_table["qumr"]=alias_item

	alias_item={}
	alias_item.name="changan_bingyingdamen_bingying"
	alias_item.dir="n"
	alias_item.alias=function() self:changan_bingyingdamen_bingying() end
	self.alias_table["changan_bingyingdamen_bingying"]=alias_item

	alias_item={}
	alias_item.name="jiayuguanximen_yanmenguan"
	alias_item.dir="w"
	alias_item.alias=function() self:jiayuguanximen_yanmenguan() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="jiayuguanximen_sichouzhilu"
	alias_item.dir="e"
	alias_item.alias=function() self:jiayuguanximen_sichouzhilu() end
	self.alias_table["jiayuguanximen_sichouzhilu"]=alias_item

	alias_item={}
	alias_item.name="wangfudating_changlang"
	alias_item.dir="e"
	alias_item.alias=function() self:wangfudating_changlang() end
	self.alias_table["wangfudating_changlang"]=alias_item

	alias_item={}
	alias_item.name="wangfudating_changlang2"
	alias_item.dir="w"
	alias_item.alias=function() self:wangfudating_changlang2() end
	self.alias_table["wangfudating_changlang2"]=alias_item

	alias_item={}
	alias_item.name="lianwuchang_guangchang"
	alias_item.dir="n"
	alias_item.alias=function() self:lianwuchang_guangchang() end
	self.alias_table["lianwuchang_guangchang"]=alias_item

	alias_item={}
	alias_item.name="yamendamen_menlang"
		alias_item.dir="n"
	alias_item.alias=function() self:yamendamen_menlang() end
	self.alias_table["yamendamen_menlang"]=alias_item

	alias_item={}
	alias_item.name="wuzhitang_houxiangfang"
	alias_item.dir="n"
	alias_item.alias=function() self:wuzhitang_houxiangfang() end
	self.alias_table["wuzhitang_houxiangfang"]=alias_item

	alias_item={}
	alias_item.name="wuzhitang_west_zoulang"
	alias_item.dir="w"
	alias_item.alias=function() self:wuzhitang_west_zoulang() end
	self.alias_table["wuzhitang_west_zoulang"]=alias_item

	alias_item={}
	alias_item.name="wuzhitang_east_zoulang"
	alias_item.dir="e"
	alias_item.alias=function() self:wuzhitang_east_zoulang() end
	self.alias_table["wuzhitang_east_zoulang"]=alias_item

	alias_item={}
	alias_item.name="wuliangjianzong_shibanlu"
	alias_item.dir="se"
	alias_item.alias=function() self:wuliangjianzong_shibanlu() end
	self.alias_table["wuliangjianzong_shibanlu"]=alias_item

	alias_item={}
	alias_item.name="shibanlu_jianhugong"
	alias_item.dir="n"
	alias_item.alias=function() self:shibanlu_jianhugong() end
	self.alias_table["shibanlu_jianhugong"]=alias_item

	alias_item={}
	alias_item.name="qingduyaotai_baishilu"
	alias_item.dir="n"
	alias_item.alias=function() self:qingduyaotai_baishilu() end
	self.alias_table["qingduyaotai_baishilu"]=alias_item

	alias_item={}
	alias_item.name="qingduyaotai_banruotai"
	alias_item.dir="e"
	alias_item.alias=function() self:qingduyaotai_banruotai() end
	self.alias_table["qingduyaotai_banruotai"]=alias_item

	alias_item={}
	alias_item.name="dacaoyuan_yingmen"
	alias_item.dir="n"
	alias_item.alias=function() self:dacaoyuan_yingmen() end
	self.alias_table["dacaoyuan_yingmen"]=alias_item

	alias_item={}
	alias_item.name="huanggongzhengting_zoulang"
	alias_item.dir="n"
	alias_item.alias=function() self:huanggongzhengting_zoulang() end
	self.alias_table["huanggongzhengting_zoulang"]=alias_item

	alias_item={}
	alias_item.name="ll_sl"
	alias_item.dir="n"
	alias_item.alias=function() self:ll_sl() end
	self.alias_table["ll_sl"]=alias_item

	alias_item={}
	alias_item.name="error_mufa"
	alias_item.dir=nil
	alias_item.alias=function() self:error_mufa() end
	self.alias_table["error_mufa"]=alias_item

	alias_item={}
	alias_item.name="west_taohuazhen"
	alias_item.dir="w"
	alias_item.alias=function() self:west_taohuazhen() end
	self.alias_table["west_taohuazhen"]=alias_item

	alias_item={}
	alias_item.name="east_taohuazhen"
	alias_item.dir="e"
	alias_item.alias=function() self:east_taohuazhen() end
	self.alias_table["east_taohuazhen"]=alias_item

	alias_item={}
	alias_item.name="yellboat"
	alias_item.dir="s"
	alias_item.alias=function() self:yellboat() end
	self.alias_table["yellboat"]=alias_item

	alias_item={}
	alias_item.name="waitday_south"
	alias_item.dir="s"
	alias_item.alias=function() self:waitday_south() end
	self.alias_table["waitday_south"]=alias_item

	alias_item={}
	alias_item.name="baishilu_banzuyuan"
	alias_item.dir="e"
	alias_item.alias=function() self:baishilu_banzuyuan() end
	self.alias_table["baishilu_banzuyuan"]=alias_item

	alias_item={}
	alias_item.name="changjie_changjie"
	alias_item.dir="e"
	alias_item.alias=function() self:changjie_changjie() end
	self.alias_table["changjie_changjie"]=alias_item

	alias_item={}
	alias_item.name="changjie_nandajie"
	alias_item.dir="w"
	alias_item.alias=function() self:changjie_nandajie() end
	self.alias_table["changjie_nandajie"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_zishanlin2_quick"
	alias_item.range=5
	alias_item.alias=function() self:zishanlin_zishanlin2_quick() end
	self.alias_table["zishanlin_zishanlin2_quick"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_ruijin"
	alias_item.dir="se"
	alias_item.alias=function() self:zishanlin_ruijin() end
	self.alias_table["zishanlin_ruijin"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_houtu"
	alias_item.dir="nw"
	alias_item.alias=function() self:zishanlin_houtu() end
	self.alias_table["zishanlin_houtu"]=alias_item

	--[[alias_item={}
	alias_item.name="zishanlin_hongshui"
	alias_item.dir="ne"
	alias_item.alias=function() self:zishanlin_hongshui() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="zishanlin_liehuo"
	alias_item.dir="sw"
	alias_item.alias=function() self:zishanlin_liehuo() end
	self.alias_table[alias_item.name]=alias_item]]

	alias_item={}
	alias_item.name="huilang_huilang1"
	alias_item.dir="w"
	alias_item.alias=function() self:huilang_huilang1() end
	self.alias_table["huilang_huilang1"]=alias_item

	alias_item={}
	alias_item.name="huilang_huilang2"
	alias_item.dir="s"
	alias_item.alias=function() self:huilang_huilang2() end
	self.alias_table["huilang_huilang2"]=alias_item

	alias_item={}
	alias_item.name="tiaochuang"
	alias_item.dir="w"
	alias_item.alias=function() self:tiaochuang() end
	self.alias_table["tiaochuang"]=alias_item

	alias_item={}
	alias_item.name="jingxiushi_houshan"
	alias_item.dir="e"
	alias_item.alias=function() self:jingxiushi_houshan() end
	self.alias_table["jingxiushi_houshan"]=alias_item

	alias_item={}
	alias_item.name="lianwuchang_zoulang2"
	alias_item.dir="w"
	alias_item.alias=function() self:lianwuchang_zoulang2() end
	self.alias_table["lianwuchang_zoulang2"]=alias_item

	alias_item={}
	alias_item.name="lianwuchang_zoulang1"
	alias_item.dir="e"
	alias_item.alias=function() self:lianwuchang_zoulang1() end
	self.alias_table["lianwuchang_zoulang1"]=alias_item

	alias_item={}
	alias_item.name="yuchuan2_yuchuan1"
	alias_item.dir="s"
	alias_item.alias=function() self:yuchuan2_yuchuan1() end
	self.alias_table["yuchuan2_yuchuan1"]=alias_item

	alias_item={}
	alias_item.name="yuchuan2_yuchuan3"
	alias_item.dir="n"
	alias_item.alias=function() self:yuchuan2_yuchuan3() end
	self.alias_table["yuchuan2_yuchuan3"]=alias_item

	alias_item={}
	alias_item.name="zishanlin"
	alias_item.dir="n"
	alias_item.range=1
	alias_item.alias=function() self:zishanlin() end
	self.alias_table["zishanlin"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_tiandifenglei"
	alias_item.dir="n"
	alias_item.range=10
	alias_item.alias=function() self:zishanlin_tiandifenglei() end
	self.alias_table["zishanlin_tiandifenglei"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_out"
	alias_item.dir="se"
	alias_item.alias=function() self:tiandifenglei_out() end
	self.alias_table["tiandifenglei_out"]=alias_item

	alias_item={}
	alias_item.name="changlang_huanglongdong"
	alias_item.dir="e"
	alias_item.alias=function() self:changlang_huanglongdong() end
	self.alias_table["changlang_huanglongdong"]=alias_item

	alias_item={}
	alias_item.name="baishilu_songshuyuan"
	alias_item.alias=function() self:baishilu_songshuyuan() end
	self.alias_table["baishilu_songshuyuan"]=alias_item

	alias_item={}
	alias_item.name="xiaodaobian_matou"
	alias_item.dir="w"
	alias_item.alias=function() self:xiaodaobian_matou() end
	self.alias_table["xiaodaobian_matou"]=alias_item


	alias_item={}
	alias_item.name="beimenbingying_jianyu"
	alias_item.dir="w"
	alias_item.alias=function() self:beimenbingying_jianyu() end
	self.alias_table["beimenbingying_jianyu"]=alias_item

	alias_item={}
	alias_item.name="holdteng"
	alias_item.dir="ne"
	alias_item.alias=function() self:holdteng() end
	self.alias_table["holdteng"]=alias_item

	alias_item={}
	alias_item.name="liehuo_luoye"
	alias_item.dir="se"
	alias_item.alias=function() self:liehuo_luoye() end
	self.alias_table["liehuo_luoye"]=alias_item

	alias_item={}
	alias_item.name="luoye_jixue"
	alias_item.dir="se"
	alias_item.alias=function() self:luoye_jixue() end
	self.alias_table["luoye_jixue"]=alias_item

	alias_item={}
	alias_item.name="jixue_kuoye"
	alias_item.dir="se"
	alias_item.alias=function() self:jixue_kuoye() end
	self.alias_table["jixue_kuoye"]=alias_item

	alias_item={}
	alias_item.name="kuoye_conglin"
	alias_item.dir="se"
	alias_item.alias=function() self:kuoye_conglin() end
	self.alias_table["kuoye_conglin"]=alias_item

	alias_item={}
	alias_item.name="luoye_liehuo"
	alias_item.dir="nw"
	alias_item.alias=function() self:luoye_liehuo() end
	self.alias_table["luoye_liehuo"]=alias_item

	alias_item={}
	alias_item.name="jixue_luoye"
	alias_item.dir="nw"
	alias_item.alias=function() self:jixue_luoye() end
	self.alias_table["jixue_luoye"]=alias_item

	alias_item={}
	alias_item.name="kuoye_jixue"
	alias_item.dir="nw"
	alias_item.alias=function() self:kuoye_jixue() end
	self.alias_table["kuoye_jixue"]=alias_item

	alias_item={}
	alias_item.name="jump_river"
	alias_item.dir="sw"
	alias_item.alias=function() self:jump_river() end
	self.alias_table["jump_river"]=alias_item

	alias_item={}
	alias_item.name="push_grass"
	alias_item.dir="e"
	alias_item.alias=function() self:push_grass() end
	self.alias_table["push_grass"]=alias_item

	alias_item={}
	alias_item.name="liehuo_liehuo"
	alias_item.dir="e"
	alias_item.alias=function() self:liehuo() end
	self.alias_table["liehuo_liehuo"]=alias_item

	alias_item={}
	alias_item.name="luoye_luoye"
	alias_item.dir="e"
	alias_item.alias=function() self:luoye() end
	self.alias_table["luoye_luoye"]=alias_item

	alias_item={}
	alias_item.name="jixue_jixue"
	alias_item.dir="e"
	alias_item.alias=function() self:jixue() end
	self.alias_table["jixue_jixue"]=alias_item

	alias_item={}
	alias_item.name="kuoye_kuoye"
	alias_item.dir="e"
	alias_item.alias=function() self:kuoye() end
	self.alias_table["kuoye_kuoye"]=alias_item

	alias_item={}
	alias_item.name="qianting_shilu"
	alias_item.dir="s"
	alias_item.alias=function() self:qianting_shilu() end
	self.alias_table["qianting_shilu"]=alias_item

	alias_item={}
	alias_item.name="zuan_didao"
	alias_item.dir="nw"
	alias_item.alias=function() self:zuan_didao() end
	self.alias_table["zuan_didao"]=alias_item

	alias_item={}
	alias_item.name="push_qiaolan"
	alias_item.dir="se"
	alias_item.alias=function() self:push_qiaolan() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="shanlu_shanzhongxiaoxi"
	alias_item.alias=function() self:shanlu_shanzhongxiaoxi() end
	self.alias_table["shanlu_shanzhongxiaoxi"]=alias_item

	alias_item={}
	alias_item.name="noway"
	alias_item.dir=nil
	alias_item.alias=function() self:noway() end
	self.alias_table["noway"]=alias_item

	alias_item={}
	alias_item.name="chanyan_shidao"
	alias_item.dir="n"
	alias_item.alias=function() self:chanyan_shidao() end
	self.alias_table["chanyan_shidao"]=alias_item

	alias_item={}
	alias_item.name="shandao_shanjin"
	alias_item.dir="ne"
	alias_item.alias=function() self:shandao_shanjin() end
	self.alias_table["shandao_shanjin"]=alias_item

	alias_item={}
	alias_item.name="tou_conglin"
	alias_item.dir="se"
	alias_item.alias=function() self:tou_conglin() end
	self.alias_table["tou_conglin"]=alias_item

	alias_item={}
	alias_item.name="juyiting_shenhuotang"
	alias_item.dir="n"
	alias_item.alias=function() self:juyiting_shenhuotang() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="juyiting_longwangdian"
	alias_item.dir="w"
	alias_item.alias=function() self:juyiting_longwangdian() end
	self.alias_table["juyiting_longwangdian"]=alias_item

	alias_item={}
	alias_item.name="yamenzhenting_fuyahouyuan"
	alias_item.dir="nw"
	alias_item.alias=function() self:yamenzhenting_fuyahouyuan() end
	self.alias_table["yamenzhenting_fuyahouyuan"]=alias_item

	alias_item={}
	alias_item.name="opendoorenter"
	alias_item.dir="ne"
	alias_item.alias=function() self:opendoorenter() end
	self.alias_table["opendoorenter"]=alias_item

	alias_item={}
	alias_item.name="changjinggeyilou_changjinggeerlou"
	alias_item.dir="n"
	alias_item.alias=function() self:changjinggeyilou_changjinggeerlou() end
	self.alias_table["changjinggeyilou_changjinggeerlou"]=alias_item

	alias_item={}
	alias_item.name="yunshanlin2_yunshanlin1"
	alias_item.dir="sw"
	alias_item.alias=function() self:yunshanlin2_yunshanlin1() end
	self.alias_table["yunshanlin2_yunshanlin1"]=alias_item

	alias_item={}
	alias_item.name="xiaojing2_xiaojing1"
	alias_item.dir="n"
	alias_item.range=5
	alias_item.alias=function() self:xiaojing2_xiaojing1() end
	self.alias_table["xiaojing2_xiaojing1"]=alias_item

	alias_item={}
	alias_item.name="xiaojing2_yuanmen"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:xiaojing2_yuanmen() end
	self.alias_table["xiaojing2_yuanmen"]=alias_item

	alias_item={}
	alias_item.name="xiaojing_dongxiangzoulang"
	alias_item.dir="e"
	alias_item.alias=function() self:xiaojing_dongxiangzoulang() end
	self.alias_table["xiaojing_dongxiangzoulang"]=alias_item

	alias_item={}
	alias_item.name="xiaojing_xixiangzoulang"
	alias_item.dir="w"
	alias_item.alias=function() self:xiaojing_xixiangzoulang() end
	self.alias_table["xiaojing_xixiangzoulang"]=alias_item

	alias_item={}
	alias_item.name="xiaojing_xiaojing1"
	alias_item.dir="n"
	alias_item.alias=function() self:xiaojing_xiaojing1() end
	self.alias_table["xiaojing_xiaojing1"]=alias_item

	alias_item={}
	alias_item.name="songshulin2_songshulin1"
	alias_item.dir="s"
	alias_item.alias=function() self:songshulin2_songshulin1() end
	self.alias_table["songshulin2_songshulin1"]=alias_item


	alias_item={}
	alias_item.name="songshulin2_songshulin3"
	alias_item.dir="n"
	alias_item.alias=function() self:songshulin2_songshulin3() end
	self.alias_table["songshulin2_songshulin3"]=alias_item

	alias_item={}
	alias_item.name="zoulang_lianwuchang"
	alias_item.dir="s"
	alias_item.alias=function() self:zoulang_lianwuchang() end
	self.alias_table["zoulang_lianwuchang"]=alias_item

	alias_item={}
	alias_item.name="haibing_taohuadao"
	alias_item.dir="ne"
	alias_item.alias=function() self:haibing_taohuadao() end
	self.alias_table["haibing_taohuadao"]=alias_item

	alias_item={}
	alias_item.name="leave_taohuadao"
	alias_item.dir="sw"
	alias_item.alias=function() self:leave_taohuadao() end
	self.alias_table["leave_taohuadao"]=alias_item

	alias_item={}
	alias_item.name="out_graveyard"
	alias_item.dir="s"
	alias_item.alias=function() self:out_graveyard() end
	self.alias_table["out_graveyard"]=alias_item

	alias_item={}
	alias_item.name="shufang_jiabi"
	alias_item.dir="n"
	alias_item.alias=function() self:shufang_jiabi() end
	self.alias_table["shufang_jiabi"]=alias_item

	alias_item={}
	alias_item.name="jiabi_shufang"
	alias_item.dir="s"
	alias_item.alias=function() self:jiabi_shufang() end
	self.alias_table["jiabi_shufang"]=alias_item

	alias_item={}
	alias_item.name="dapubu_bailongfeng"
	alias_item.dir="se"
	alias_item.alias=function() self:dapubu_bailongfeng() end
	self.alias_table["dapubu_bailongfeng"]=alias_item

	alias_item={}
	alias_item.name="jianhugong_xilianwuchang"
	alias_item.dir="w"
	alias_item.alias=function() self:jianhugong_xilianwuchang() end
	self.alias_table["jianhugong_xilianwuchang"]=alias_item

	alias_item={}
	alias_item.name="jianhugong_donglianwuchang"
	alias_item.dir="e"
	alias_item.alias=function() self:jianhugong_donglianwuchang() end
	self.alias_table["jianhugong_donglianwuchang"]=alias_item

	alias_item={}
	alias_item.name="jianhugong_houyuan"
	alias_item.dir="n"
	alias_item.alias=function() self:jianhugong_houyuan() end
	self.alias_table["jianhugong_houyuan"]=alias_item

	alias_item={}
	alias_item.name="shimen_riyuepin"
	alias_item.dir="w"
	alias_item.alias=function() self:shimen_riyuepin() end
	self.alias_table["shimen_riyuepin"]=alias_item

	alias_item={}
	alias_item.name="riyuepin_yading"
	alias_item.dir="n"
	alias_item.alias=function() self:riyuepin_yading() end
	self.alias_table["riyuepin_yading"]=alias_item

	alias_item={}
	alias_item.name="yading_riyuepin"
	alias_item.dir="s"
	alias_item.alias=function() self:yading_riyuepin() end
	self.alias_table["yading_riyuepin"]=alias_item

	alias_item={}
	alias_item.name="unwield_east"
	alias_item.dir="e"
	alias_item.alias=function() self:unwield_east() end
	self.alias_table["unwield_east"]=alias_item

	alias_item={}
	alias_item.name="unwield_west"
	alias_item.dir="w"
	alias_item.alias=function() self:unwield_west() end
	self.alias_table["unwield_west"]=alias_item

	alias_item={}
	alias_item.name="unwield_north"
	alias_item.dir="n"
	alias_item.alias=function() self:unwield_north() end
	self.alias_table["unwield_north"]=alias_item

    alias_item={}
	alias_item.name="rimulundian_yueliangmen"
	alias_item.alias=function() self:rimulundian_yueliangmen() end
	self.alias_table["rimulundian_yueliangmen"]=alias_item

	alias_item={}
	alias_item.name="rimulundian_zhaitang"
	alias_item.dir="se"
	alias_item.alias=function() self:rimulundian_zhaitang() end
	self.alias_table["rimulundian_zhaitang"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_feng"
	alias_item.dir="se"
	alias_item.alias=function() self:tiandifenglei_feng() end
	self.alias_table["tiandifenglei_feng"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_lei"
	alias_item.dir="sw"
	alias_item.alias=function() self:tiandifenglei_lei() end
	self.alias_table["tiandifenglei_lei"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_tian"
	alias_item.dir="nw"
	alias_item.alias=function() self:tiandifenglei_tian() end
	self.alias_table["tiandifenglei_tian"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_di"
	alias_item.dir="ne"
	alias_item.alias=function() self:tiandifenglei_di() end
	self.alias_table["tiandifenglei_di"]=alias_item

	alias_item={}
	alias_item.name="songlin1_songlin2"
	alias_item.dir="w"
	alias_item.alias=function() self:songlin1_songlin2() end
	self.alias_table["songlin1_songlin2"]=alias_item

	alias_item={}
	alias_item.name="songlin2_songlin1"
	alias_item.dir="e"
	alias_item.alias=function() self:songlin2_songlin1() end
	self.alias_table["songlin2_songlin1"]=alias_item

	alias_item={}
	alias_item.name="halt_northwest"
	alias_item.dir="nw"
	alias_item.alias=function() self:halt_northwest() end
	self.alias_table["halt_northwest"]=alias_item

	alias_item={}
	alias_item.name="out_zhulin_shuitang"
	alias_item.dir="nw"
	alias_item.alias=function() self:out_zhulin_shuitang() end
	self.alias_table["out_zhulin_shuitang"]=alias_item

	alias_item={}
	alias_item.name="out_zhulin_shanjianpingdi"
	alias_item.dir="se"
	alias_item.alias=function() self:out_zhulin_shanjianpingdi() end
	self.alias_table["out_zhulin_shanjianpingdi"]=alias_item

	alias_item={}
	alias_item.name="shanjianpingdi_shuitang"
	alias_item.dir="n"
	alias_item.alias=function() self:shanjianpingdi_shuitang() end
	self.alias_table["shanjianpingdi_shuitang"]=alias_item

	alias_item={}
	alias_item.name="clg_ysl"
	alias_item.dir="n"
	alias_item.alias=function() self:clg_ysl() end
	self.alias_table["clg_ysl"]=alias_item


	alias_item={}
	alias_item.name="shuitang_shanjianpingdi"
	alias_item.dir="s"
	alias_item.alias=function() self:shuitang_shanjianpingdi() end
	self.alias_table["shuitang_shanjianpingdi"]=alias_item

	alias_item={}
	alias_item.name="xiaoxi_dufengling"
	alias_item.dir="ne"
	alias_item.alias=function() self:xiaoxi_dufengling() end
	self.alias_table["xiaoxi_dufengling"]=alias_item

	alias_item={}
	alias_item.name="dufengling_xiaoxi"
	alias_item.dir="sw"
	alias_item.alias=function() self:dufengling_xiaoxi() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="fuyaqianting_situtang"
	alias_item.dir="e"
	alias_item.alias=function() self:fuyaqianting_situtang() end
	self.alias_table["fuyaqianting_situtang"]=alias_item

	alias_item={}
	alias_item.name="fuyaqianting_sikongtang"
	alias_item.dir="n"
	alias_item.alias=function() self:fuyaqianting_sikongtang() end
	self.alias_table["fuyaqianting_sikongtang"]=alias_item

	alias_item={}
	alias_item.name="fuyaqianting_simatang"
	alias_item.dir="w"
	alias_item.alias=function() self:fuyaqianting_simatang() end
	self.alias_table["fuyaqianting_simatang"]=alias_item

	alias_item={}
	alias_item.name="changlemen_dongmenchenglou"
	alias_item.dir="e"
	alias_item.alias=function() self:changlemen_dongmenchenglou() end
	self.alias_table["changlemen_dongmenchenglou"]=alias_item

	alias_item={}
	alias_item.name="anyuanmen_beimenchenglou"
	alias_item.dir="n"
	alias_item.alias=function() self:anyuanmen_beimenchenglou() end
	self.alias_table["anyuanmen_beimenchenglou"]=alias_item

	alias_item={}
	alias_item.name="yongningmen_nanmenchenglou"
	alias_item.dir="s"
	alias_item.alias=function() self:yongningmen_nanmenchenglou() end
	self.alias_table["yongningmen_nanmenchenglou"]=alias_item

	alias_item={}
	alias_item.name="andingmen_ximenchenglou"
	alias_item.dir="w"
	alias_item.alias=function() self:andingmen_ximenchenglou() end
	self.alias_table["andingmen_ximenchenglou"]=alias_item

	alias_item={}
	alias_item.name="enter_zhulin"
	alias_item.dir="n"
	alias_item.alias=function() self:enter_zhulin() end
	self.alias_table["enter_zhulin"]=alias_item

	alias_item={}
	alias_item.name="xixiangchibian_xixiangchibian"
	alias_item.dir="n"
	alias_item.alias=function() self:xixiangchibian_xixiangchibian() end
	self.alias_table["xixiangchibian_xixiangchibian"]=alias_item

	alias_item={}
	alias_item.name="changlang_guifang"
	alias_item.dir="e"
	alias_item.alias=function() self:changlang_guifang() end
	self.alias_table["changlang_guifang"]=alias_item

	alias_item={}
	alias_item.name="xiaodao_shatan2"
	alias_item.dir="sw"
	alias_item.alias=function() self:xiaodao_shatan2() end
	self.alias_table["xiaodao_shatan2"]=alias_item

	alias_item={}
	alias_item.name="zoulang_xixiangzoulang"
	alias_item.dir="w"
	alias_item.alias=function() self:zoulang_xixiangzoulang() end
	self.alias_table["zoulang_xixiangzoulang"]=alias_item

    alias_item={}
	alias_item.name="hjxl_bhg"
	alias_item.dir="n"
	alias_item.alias=function() self:hjxl_bhg() end
	self.alias_table["hjxl_bhg"]=alias_item

	alias_item={}
	alias_item.name="zoulang_liangongfang"
	alias_item.dir="n"
	alias_item.alias=function() self:zoulang_liangongfang() end
	self.alias_table["zoulang_liangongfang"]=alias_item

	alias_item={}
	alias_item.name="zoulang_dongxiangzoulang"
	    alias_item.dir="e"
	alias_item.alias=function() self:zoulang_dongxiangzoulang() end
	self.alias_table["zoulang_dongxiangzoulang"]=alias_item

	alias_item={}
	alias_item.name="xiaowu_liwu"
	alias_item.dir="ne"
	alias_item.alias=function() self:xiaowu_liwu() end
	self.alias_table["xiaowu_liwu"]=alias_item

	alias_item={}
	alias_item.name="dating_houtang"
	 alias_item.dir="n"
	alias_item.alias=function() self:dating_houtang() end
	self.alias_table["dating_houtang"]=alias_item

	alias_item={}
	alias_item.name="dashiwu_dating"
	 alias_item.dir="ne"
	alias_item.alias=function() self:dashiwu_dating() end
	self.alias_table["dashiwu_dating"]=alias_item

	alias_item={}
	alias_item.name="jump_back"
	alias_item.dir="sw"
	alias_item.alias=function() self:jump_back() end
	self.alias_table["jump_back"]=alias_item

	alias_item={}
	alias_item.name="jump_qiaobi"
	alias_item.dir="ne"
	alias_item.alias=function() self:jump_qiaobi() end
	self.alias_table["jump_qiaobi"]=alias_item

	alias_item={}
	alias_item.name="xiao"
	alias_item.dir=nil
	alias_item.range=20
	alias_item.alias=function() self:xiao() end
	self.alias_table["xiao"]=alias_item

	alias_item={}
	alias_item.name="yell_tengkuang"
	alias_item.dir="n"
	alias_item.alias=function() self:yell_tengkuang() end
	self.alias_table["yell_tengkuang"]=alias_item

	alias_item={}
	alias_item.name="miaofadian_cangjingge"
	alias_item.dir="s"
	alias_item.alias=function() self:miaofadian_cangjingge() end
	self.alias_table["miaofadian_cangjingge"]=alias_item

	alias_item={}
	alias_item.name="gufoshelita_talin"
	alias_item.dir="se"
	alias_item.alias=function() self:gufoshelita_talin() end
	self.alias_table["gufoshelita_talin"]=alias_item

	alias_item={}
	alias_item.name="talin_gufoshelita"
	alias_item.dir="nw"
	alias_item.alias=function() self:talin_gufoshelita() end
	self.alias_table["talin_gufoshelita"]=alias_item

	alias_item={}
	alias_item.name="majiu_houshanxiaojing"
	alias_item.dir="n"
	alias_item.alias=function() self:majiu_houshanxiaojing() end
	self.alias_table["majiu_houshanxiaojing"]=alias_item

	alias_item={}
	alias_item.name="houshanxiaolu_guanmucong"
	alias_item.dir="nw"
	alias_item.alias=function() self:houshanxiaolu_guanmucong() end
	self.alias_table["houshanxiaolu_guanmucong"]=alias_item

	alias_item={}
	alias_item.name="guamucong_dongkou"
	alias_item.dir="e"
	alias_item.alias=function() self:guamucong_dongkou() end
	self.alias_table["guamucong_dongkou"]=alias_item

	alias_item={}
	alias_item.name="huilang2_huilang1"
	alias_item.dir="w"
	alias_item.alias=function() self:huilang2_huilang1() end
	self.alias_table["huilang2_huilang1"]=alias_item

	alias_item={}
	alias_item.name="huilang1_huilang2"
	alias_item.dir="e"
	alias_item.alias=function() self:huilang1_huilang2() end
	self.alias_table["huilang1_huilang2"]=alias_item

	alias_item={}
	alias_item.name="guanmucong_out"
	alias_item.dir="se"
	alias_item.alias=function() self:guanmucong_out() end
	self.alias_table["guanmucong_out"]=alias_item

    alias_item={}
	alias_item.name="yuanmen_xiaoyuan"
	alias_item.dir="s"
	alias_item.alias=function() self:yuanmen_houshanxiaoyuan() end
	self.alias_table["yuanmen_xiaoyuan"]=alias_item

	alias_item={}
	alias_item.name="movestone"
		alias_item.dir="n"
	alias_item.alias=function() self:movestone() end
	self.alias_table["movestone"]=alias_item

	alias_item={}
	alias_item.name="laofang_dilao"
	alias_item.dir="s"
	alias_item.alias=function() self:laofang_dilao() end
	self.alias_table["laofang_dilao"]=alias_item

	alias_item={}
	alias_item.name="changlang_chufang"
	alias_item.dir="e"
	alias_item.alias=function() self:changlang_chufang() end
	self.alias_table["changlang_chufang"]=alias_item

	alias_item={}
	alias_item.name="xiaoting_chufang"
	alias_item.dir="n"
	alias_item.alias=function() self:xiaoting_chufang() end
	self.alias_table["xiaoting_chufang"]=alias_item

	alias_item={}
	alias_item.name="sajiafatang_fatangerlou"
	alias_item.dir="n"
	alias_item.alias=function() self:sajiafatang_fatangerlou() end
	self.alias_table["sajiafatang_fatangerlou"]=alias_item

	alias_item={}
	alias_item.name="shanlu2_shanlu1"
	alias_item.dir="s"
	alias_item.alias=function() self:shanlu2_shanlu1() end
	self.alias_table["shanlu2_shanlu1"]=alias_item

	alias_item={}
	alias_item.name="shanlu1_shanlu2"
		alias_item.dir="n"
	alias_item.alias=function() self:shanlu1_shanlu2() end
	self.alias_table["shanlu1_shanlu2"]=alias_item

	alias_item={}
	alias_item.name="jiechiyuan_jingshi"
			alias_item.dir="s"
	alias_item.alias=function() self:jiechiyuan_jingshi() end
	self.alias_table["jiechiyuan_jingshi"]=alias_item

	alias_item={}
	alias_item.name="tieqingju_woshi"
		alias_item.dir="w"
	alias_item.alias=function() self:tieqingju_woshi() end
	self.alias_table["tieqingju_woshi"]=alias_item

	alias_item={}
	alias_item.name="block_eastup"
		alias_item.dir="e"
	alias_item.alias=function() self:block_eastup() end
	self.alias_table["block_eastup"]=alias_item

	alias_item={}
	alias_item.name="block_westup"
		alias_item.dir="w"
	alias_item.alias=function() self:block_westup() end
	self.alias_table["block_westup"]=alias_item

	alias_item={}
	alias_item.name="shushang"
		alias_item.dir="s"
	alias_item.alias=function() self:shushang() end
	self.alias_table["shushang"]=alias_item

	alias_item={}
	alias_item.name="dadukou_shenlongdao"
	alias_item.dir="ne"
	alias_item.alias=function() self:dadukou_shenlongdao() end
	self.alias_table["dadukou_shenlongdao"]=alias_item

	alias_item={}
	alias_item.name="shenlongdao_dadukou"
	alias_item.dir="sw"
	alias_item.alias=function() self:shenlongdao_dadukou() end
	self.alias_table["shenlongdao_dadukou"]=alias_item

	alias_item={}
	alias_item.name="songlin_longshuyuan"
	alias_item.dir="n"
	alias_item.range=6
	alias_item.alias=function() self:songlin_longshuyuan() end
	self.alias_table["songlin_longshuyuan"]=alias_item

	alias_item={}
	alias_item.name="songlin_shibanlu"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:songlin_shibanlu() end
	self.alias_table["songlin_shibanlu"]=alias_item

	alias_item={}
	alias_item.name="zuanshulin"
	alias_item.dir="ne"
	alias_item.alias=function() self:zuanshulin() end
	self.alias_table["zuanshulin"]=alias_item

	alias_item={}
	alias_item.name="fanyinge_fotang"
	alias_item.dir="nw"
	alias_item.alias=function() self:fanyinge_fotang() end
	self.alias_table["fanyinge_fotang"]=alias_item

	alias_item={}
	alias_item.name="shanjian_longtan"
	alias_item.dir="w"
	alias_item.alias=function() self:shanjian_longtan() end
	self.alias_table["shanjian_longtan"]=alias_item

	alias_item={}
	alias_item.name="shidao_xiaoyaodong"
	alias_item.dir="nw"
	alias_item.alias=function() self:shidao_xiaoyaodong() end
	self.alias_table["shidao_xiaoyaodong"]=alias_item

	alias_item={}
	alias_item.name="keting_xiangfang"
	alias_item.dir="e"
	alias_item.alias=function() self:keting_xiangfang() end
	self.alias_table["keting_xiangfang"]=alias_item

	alias_item={}
	alias_item.name="yamendating_yamenzhengting"
	alias_item.dir="n"
	alias_item.alias=function() self:yamendating_yamenzhengting() end
	self.alias_table["yamendating_yamenzhengting"]=alias_item

	alias_item={}
	alias_item.name="shanbi_huacong"
	alias_item.dir="n"
	alias_item.alias=function() self:shanbi_huacong() end
	self.alias_table["shanbi_huacong"]=alias_item

	alias_item={}
	alias_item.name="maowu_hetang"
	alias_item.dir="w"
	alias_item.alias=function() self:maowu_hetang() end
	self.alias_table["maowu_hetang"]=alias_item

	alias_item={}
	alias_item.name="hetang_maowu"
	alias_item.dir="e"
	alias_item.alias=function() self:hetang_maowu() end
	self.alias_table["hetang_maowu"]=alias_item

	alias_item={}
	alias_item.name="dierzhijie_shandong"
	alias_item.dir="ne"
	alias_item.alias=function() self:dierzhijie_shandong() end
	self.alias_table["dierzhijie_shandong"]=alias_item

	alias_item={}
	alias_item.name="changzhouyayi_fuyazhenting"
	alias_item.dir="w"
	alias_item.alias=function() self:changzhouyayi_fuyazhenting() end
	self.alias_table["changzhouyayi_fuyazhenting"]=alias_item

	alias_item={}
	alias_item.name="xidajie_mingyufang"
	alias_item.dir="n"
	alias_item.alias=function() self:xidajie_mingyufang() end
	self.alias_table["xidajie_mingyufang"]=alias_item

	alias_item={}
	alias_item.name="zhulin_damodong"
	alias_item.dir="n"
	alias_item.alias=function() self:zhulin_damodong() end
	self.alias_table["zhulin_damodong"]=alias_item

	alias_item={}
	alias_item.name="xiaofudamen_xiaofudating"
	alias_item.dir="n"
	alias_item.alias=function() self:xiaofudamen_xiaofudating() end
	self.alias_table["xiaofudamen_xiaofudating"]=alias_item

	alias_item={}
	alias_item.name="yugangmatou_chuancang"
	alias_item.dir=nil
	alias_item.alias=function() self:yugangmatou_chuancang() end
	self.alias_table["yugangmatou_chuancang"]=alias_item

	alias_item={}
	alias_item.name="chuancang_yugangmatou"
	alias_item.dir=nil
	alias_item.alias=function() self:chuancang_yugangmatou() end
	self.alias_table["chuancang_yugangmatou"]=alias_item

	alias_item={}
	alias_item.name="bingying_wuqiku"
	alias_item.dir="s"
	alias_item.alias=function() self:bingying_wuqiku() end
	self.alias_table["bingying_wuqiku"]=alias_item

	--[[alias_item={}
	alias_item.name="sichouzhilu_caoyuanbianyuan"
	alias_item.dir=nil
	alias_item.alias=function() self:sichouzhilu_caoyuanbianyuan() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="caoyuanbianyuan_sichouzhilu"
	alias_item.dir=nil
	alias_item.alias=function()
	   --print("register why:",this.id)
	   self:caoyuanbianyuan_sichouzhilu()
	end
	self.alias_table[alias_item.name]=alias_item]]

	--[[alias_item={}
	alias_item.name="longshuyuan_shibanlu"
	alias_item.dir=nil
	alias_item.alias=function() self:longshuyuan_shibanlu() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="shibanlu_longshuyuan"
		alias_item.dir=nil
	alias_item.alias=function() self:shibanlu_longshuyuan() end
	self.alias_table[alias_item.name]=alias_item]]

	alias_item={}
	alias_item.name="xiangyangshulin_circle"
	alias_item.dir=nil
	alias_item.alias=function() self:xiangyangshulin_circle() end
	self.alias_table["xiangyangshulin_circle"]=alias_item

	--���ɽ�

	alias_item={}
	alias_item.name="baizhangjian_south"
	alias_item.dir="s"
	alias_item.alias=function() self:baizhangjian_south() end
	self.alias_table["baizhangjian_south"]=alias_item

	alias_item={}
	alias_item.name="shanjiao_shanlu"
	alias_item.dir="n"
	alias_item.alias=function() self:shanjiao_shanlu() end
	self.alias_table["shanjiao_shanlu"]=alias_item

	alias_item={}
	alias_item.name="chuwujian_cangjinglou"
	alias_item.dir="n"
	alias_item.alias=function() self:chuwujian_cangjinglou() end
	self.alias_table["chuwujian_cangjinglou"]=alias_item

	alias_item={}
	alias_item.name="guangfobaodian_songshuyuan"
	alias_item.dir="n"
	alias_item.alias=function() self:guangfobaodian_songshuyuan() end
	self.alias_table["guangfobaodian_songshuyuan"]=alias_item

	alias_item={}
	alias_item.name="dangtianmen_xiuxishi"
	alias_item.dir="s"
	alias_item.alias=function() self:dangtianmen_xiuxishi() end
	self.alias_table["dangtianmen_xiuxishi"]=alias_item

	alias_item={}
	alias_item.name="zoulang_shufang"
	alias_item.dir="n"
	alias_item.alias=function() self:zoulang_shufang() end
	self.alias_table["zoulang_shufang"]=alias_item

	alias_item={}
	alias_item.name="yitiantulong"
	alias_item.dir="s"
	alias_item.alias=function() self:yitiantulong() end
	self.alias_table["yitiantulong"]=alias_item

	alias_item={}
	alias_item.name="zuan"
	alias_item.dir="s"
	alias_item.alias=function() self:zuan() end
	self.alias_table["zuan"]=alias_item

	alias_item={}
	alias_item.name="zhenting_houmen"
	alias_item.dir="s"
	alias_item.alias=function() self:zhenting_houmen() end
	self.alias_table["zhenting_houmen"]=alias_item

	alias_item={}
	alias_item.name="special_east"
	alias_item.dir="e"
	alias_item.alias=function() self:special_east() end
	self.alias_table["special_east"]=alias_item

	alias_item={}
	alias_item.name="yamendamen_yamenzhengting"
	alias_item.dir="n"
	alias_item.alias=function() self:yamendamen_yamenzhengting() end
	self.alias_table["yamendamen_yamenzhengting"]=alias_item

	alias_item={}
	alias_item.name="zhendaoyuan_chanfang"
	alias_item.dir="w"
	alias_item.alias=function() self:zhendaoyuan_chanfang() end
	self.alias_table["zhendaoyuan_chanfang"]=alias_item

	alias_item={}
	alias_item.name="xilianwuchang_shibanlu"
	alias_item.dir="w"
	alias_item.alias=function() self:xilianwuchang_shibanlu() end
	self.alias_table["xilianwuchang_shibanlu"]=alias_item

	alias_item={}
	alias_item.name="xidajie_shouxihujiulou"
	alias_item.dir="n"
	alias_item.alias=function() self:xidajie_shouxihujiulou() end
	self.alias_table["xidajie_shouxihujiulou"]=alias_item

	alias_item={}
	alias_item.name="xidajie_shoushidian"
	alias_item.dir="s"
	alias_item.alias=function() self:xidajie_shoushidian() end
	self.alias_table["xidajie_shoushidian"]=alias_item

	alias_item={}
	alias_item.name="duanyaping_yading"
	alias_item.dir="n"
	alias_item.alias=function() self:duanyaping_yading() end
	self.alias_table["duanyaping_yading"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_tiandifenglei_quick"
	alias_item.dir="n"
	alias_item.range=10
	alias_item.alias=function() self:zishanlin_tiandifenglei_quick() end
	self.alias_table["zishanlin_tiandifenglei_quick"]=alias_item

	alias_item={}
	alias_item.name="t_leave"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:t_leave() end
	self.alias_table["t_leave"]=alias_item

	alias_item={}
	alias_item.name="huigong"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:huigong() end
	self.alias_table["huigong"]=alias_item

	alias_item={}
	alias_item.name="push_door"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:push_door() end
	self.alias_table["push_door"]=alias_item

	alias_item={}
	alias_item.name="climb_shanlu"
	alias_item.dir="n"
	alias_item.range=10
	alias_item.alias=function() self:climb_shanlu() end
	self.alias_table["climb_shanlu"]=alias_item

	alias_item={}
	alias_item.name="female_south"
	alias_item.dir="s"
	alias_item.alias=function() self:female_south() end
	self.alias_table["female_south"]=alias_item


	alias_item={}
	alias_item.name="d_west"
	alias_item.dir="w"
	alias_item.alias=function() self:d_west() end
	self.alias_table["d_west"]=alias_item

	alias_item={}
	alias_item.name="east_zishanlin_tiandifenglei_quick"
	alias_item.dir="e"
	alias_item.alias=function()
     	 world.Send("east")
	    self:zishanlin_tiandifenglei_quick()
	end
	self.alias_table["east_zishanlin_tiandifenglei_quick"]=alias_item

	alias_item={}
	alias_item.name="west_zishanlin_tiandifenglei_quick"
	alias_item.dir="w"
	alias_item.alias=function()
	   world.Send("west")
	   self:zishanlin_tiandifenglei_quick()
	end
	self.alias_table["west_zishanlin_tiandifenglei_quick"]=alias_item

	alias_item={}
	alias_item.name="siguoya_jiashanbi"
	alias_item.dir="w"
	alias_item.alias=function()
	   self:siguoya_jiashanbi()
	end
	self.alias_table["siguoya_jiashanbi"]=alias_item

	alias_item={}
	alias_item.name="huapu_caojing"
	alias_item.dir="n"
	alias_item.alias=function()
	   self:huapu_caojing()
	end
	self.alias_table["huapu_caojing"]=alias_item

	alias_item={}
	alias_item.name="huapu_niupeng"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:huapu_niupeng()
	end
	self.alias_table["huapu_niupeng"]=alias_item

	alias_item={}
	alias_item.name="caojing_niupeng"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:caojing_niupeng()
	end
	self.alias_table["caojing_niupeng"]=alias_item

	alias_item={}
	alias_item.name="niupeng_caojing"
	alias_item.dir="n"
	alias_item.alias=function()
	   self:niupeng_caojing()
	end
	self.alias_table["niupeng_caojing"]=alias_item

	alias_item={}
	alias_item.name="push_flag"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:push_flag()
	end
	self.alias_table["push_flag"]=alias_item

    alias_item={}
	alias_item.name="nanjiangshamo_tuyuhun"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:nanjiangshamo_tuyuhun()
	end
	alias_item.range=5
	self.alias_table["nanjiangshamo_tuyuhun"]=alias_item

	alias_item={}
	alias_item.name="danfang_eyutan"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:danfang_eyutan()
	end
	alias_item.range=1
	self.alias_table["danfang_eyutan"]=alias_item

	alias_item={}
	alias_item.name="ta_corpse"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:ta_corpse()
	end
	alias_item.range=1
	self.alias_table["ta_corpse"]=alias_item

   	alias_item={}
	alias_item.name="enter_dong"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:enter_dong()
	end
	alias_item.range=1
	self.alias_table["enter_dong"]=alias_item

	alias_item={}
	alias_item.name="climb_down"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:climb_down()
	end
	alias_item.range=1
	self.alias_table["climb_down"]=alias_item

	alias_item={}
	alias_item.name="shiku_shibi"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:shiku_shibi()
	end
	alias_item.range=1
	self.alias_table["shiku_shibi"]=alias_item

	alias_item={}
	alias_item.name="enter_meizhuang"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:enter_meizhuang()
	end
	alias_item.range=30
	self.alias_table["enter_meizhuang"]=alias_item

	alias_item={}
	alias_item.name="out_meizhuang"
	alias_item.dir="n"
	alias_item.alias=function()
	   self:out_meizhuang()
	end
	alias_item.range=30
	self.alias_table["out_meizhuang"]=alias_item

	alias_item={}
	alias_item.name="shibi_liguifeng"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:shibi_liguifeng()
	end
	alias_item.range=1
	self.alias_table["shibi_liguifeng"]=alias_item

	alias_item={}
	alias_item.name="shiguoya_shiguoyadongkou"
	alias_item.dir="w"
	alias_item.alias=function()
	   self:shiguoya_shiguoyadongkou()
	end
	alias_item.range=1
	self.alias_table["shiguoya_shiguoyadongkou"]=alias_item


	alias_item={}
	alias_item.name="qingyunpin_fumoquan"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:qingyunpin_fumoquan()
	end
	alias_item.range=1
	self.alias_table["qingyunpin_fumoquan"]=alias_item

	alias_item={}
	alias_item.name="dagebi_caoyuan"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:dagebi_caoyuan()
	end
	alias_item.range=1
	self.alias_table["dagebi_caoyuan"]=alias_item

	alias_item={}
	alias_item.name="yuren"
	alias_item.dir="n"
	alias_item.alias=function() self:yuren() end
	self.alias_table["yuren"]=alias_item

	alias_item={}
	alias_item.name="nongfu"
	alias_item.dir="n"
	alias_item.alias=function() self:nongfu() end
	self.alias_table["nongfu"]=alias_item

	alias_item={}
	alias_item.name="qiaofu"
	alias_item.dir="n"
	alias_item.alias=function() self:qiaofu() end
	self.alias_table["qiaofu"]=alias_item

	alias_item={}
	alias_item.name="shiliang"
	alias_item.dir="e"
	alias_item.alias=function() self:shiliang() end
	self.alias_table["shiliang"]=alias_item

	alias_item={}
	alias_item.name="shibixia_dongkou"
	alias_item.dir="n"
	alias_item.alias=function() self:shibixia_dongkou() end
	self.alias_table["shibixia_dongkou"]=alias_item

	alias_item={}
	alias_item.name="si_teng"
	alias_item.dir="n"
	alias_item.alias=function() self:si_teng() end
	self.alias_table["si_teng"]=alias_item

	alias_item={}
	alias_item.name="banshan_shangugudi"
	alias_item.dir="n"
	alias_item.alias=function() self:banshan_shangugudi() end
	self.alias_table["banshan_shangugudi"]=alias_item

	alias_item={}
	alias_item.name="push_huan"
	alias_item.dir="n"
	alias_item.alias=function() self:push_huan() end
	self.alias_table["push_huan"]=alias_item

	alias_item={}
	alias_item.name="qianting_miaojiazhuang"
	alias_item.dir="e"
	alias_item.alias=function() self:qianting_miaojiazhuang() end
	self.alias_table["qianting_miaojiazhuang"]=alias_item

	alias_item={}
	alias_item.name="miaojiazhuang_qianting"
	alias_item.dir="w"
	alias_item.alias=function() self:miaojiazhuang_qianting() end
	self.alias_table["miaojiazhuang_qianting"]=alias_item

	alias_item={}
	alias_item.name="shusheng"
	alias_item.dir="n"
	alias_item.alias=function() self:shusheng() end
	self.alias_table["shusheng"]=alias_item
    --ȫ�� ��Ĺ��ͼ
	alias_item={}
	alias_item.name="tiao"
	alias_item.dir="e"
	alias_item.alias=function() self:tiao() end
	self.alias_table["tiao"]=alias_item

	alias_item={}
	alias_item.name="tui_eastwall"
	alias_item.dir="e"
	alias_item.alias=function() self:tui_eastwall() end
	self.alias_table["tui_eastwall"]=alias_item

	alias_item={}
	alias_item.name="tui_westwall"
	alias_item.dir="w"
	alias_item.alias=function() self:tui_westwall() end
	self.alias_table["tui_westwall"]=alias_item

	alias_item={}
	alias_item.name="pa_up"
	alias_item.dir="e"
	alias_item.alias=function() self:pa_up() end
	self.alias_table["pa_up"]=alias_item

	alias_item={}
	alias_item.name="qian_up"
	alias_item.dir="e"
	alias_item.alias=function() self:qian_up() end
	self.alias_table["qian_up"]=alias_item

	alias_item={}
	alias_item.name="qian_down"
	alias_item.dir="w"
	alias_item.alias=function() self:qian_down() end
	self.alias_table["qian_down"]=alias_item


	alias_item={}
	alias_item.name="duanchang_gudi"
	alias_item.dir="s"
	alias_item.alias=function() self:duanchang_gudi() end
	self.alias_table["duanchang_gudi"]=alias_item

	alias_item={}
	alias_item.name="gudi_duanchang"
	alias_item.dir="n"
	alias_item.alias=function() self:gudi_duanchang() end
	self.alias_table["gudi_duanchang"]=alias_item

	alias_item={}
	alias_item.name="gudi_gudishuitan"
	alias_item.dir="s"
	alias_item.alias=function() self:gudi_gudishuitan() end
	self.alias_table["gudi_gudishuitan"]=alias_item

	alias_item={}
	alias_item.name="yabi_gudi"
	alias_item.dir="s"
	alias_item.alias=function() self:yabi_gudi() end
	self.alias_table["yabi_gudi"]=alias_item

	alias_item={}
	alias_item.name="yabi_duanchang"
	alias_item.dir="n"
	alias_item.alias=function() self:yabi_duanchang() end
	self.alias_table["yabi_duanchang"]=alias_item

	alias_item={}
	alias_item.name="guditan_tanan"
	alias_item.dir="n"
	alias_item.alias=function() self:guditan_tanan() end
	self.alias_table["guditan_tanan"]=alias_item

    alias_item={}
	alias_item.name="tanan_tongdao"
	alias_item.range=20
	alias_item.dir="s"
	alias_item.alias=function() self:tanan_tongdao() end
	self.alias_table["tanan_tongdao"]=alias_item

	alias_item={}
	alias_item.name="tongdao_gudi"
	alias_item.dir="n"
	alias_item.alias=function() self:tongdao_gudi() end
	self.alias_table["tongdao_gudi"]=alias_item

	alias_item={}
	alias_item.name="ss_ws"
	alias_item.dir="w"
	alias_item.alias=function() self:ss_ws() end
	self.alias_table["ss_ws"]=alias_item

	alias_item={}
	alias_item.name="ws_ss"
	alias_item.dir="e"
	alias_item.alias=function() self:search_fire() end
	self.alias_table["ws_ss"]=alias_item

	alias_item={}
	alias_item.name="shishi4_shishi0"
	alias_item.dir="e"
	alias_item.alias=function() self:shishi4_shishi0() end
	self.alias_table["shishi4_shishi0"]=alias_item

	alias_item={}
	alias_item.name="shishi1_shishi5"
	alias_item.dir="w"
	alias_item.alias=function() self:shishi1_shishi5() end
	self.alias_table["shishi1_shishi5"]=alias_item

	alias_item={}
	alias_item.name="lingshi_shiguan"
	alias_item.dir="n"
	alias_item.alias=function() self:lingshi_shiguan() end
	self.alias_table["lingshi_shiguan"]=alias_item

	alias_item={}
	alias_item.name="shiguan_sshi"
	alias_item.dir="n"
	alias_item.alias=function() self:shiguan_sshi() end
	self.alias_table["shiguan_sshi"]=alias_item

	alias_item={}
	alias_item.name="walkdown"
	alias_item.dir="s"
	alias_item.alias=function() self:walkdown() end
	self.alias_table["walkdown"]=alias_item

	alias_item={}
	alias_item.name="gumu_shulin"
	alias_item.dir="w"
	alias_item.alias=function() self:gumu_shulin() end
	self.alias_table["gumu_shulin"]=alias_item

	alias_item={}
	alias_item.name="shulin_gumu"
	alias_item.dir="e"
	alias_item.alias=function() self:shulin_gumu() end
	self.alias_table["shulin_gumu"]=alias_item

	alias_item={}
	alias_item.name="gml_lcd"
	alias_item.dir="e"
	alias_item.alias=function() self:gml_lcd() end
	self.alias_table["gml_lcd"]=alias_item

	alias_item={}
	alias_item.name="dxssk_dxssg"
	alias_item.dir="s"
	alias_item.alias=function() self:dxssk_dxssg() end
	self.alias_table["dxssk_dxssg"]=alias_item

	alias_item={}
	alias_item.name="chy0_chy1"
	alias_item.dir="n"
	alias_item.alias=function() self:chy0_chy1() end
	self.alias_table["chy0_chy1"]=alias_item

	alias_item={}
	alias_item.name="dongkou_shandong"
	alias_item.dir="ne"
	alias_item.alias=function() self:dongkou_shandong() end
	self.alias_table["dongkou_shandong"]=alias_item

	alias_item={}
	alias_item.name="shamo_lvzhou"
	alias_item.dir="n"
	alias_item.alias=function() self:shamo_lvzhou() end
	self.alias_table["shamo_lvzhou"]=alias_item

	alias_item={}
	alias_item.name="shamo1_shamo2"
	alias_item.dir="n"
	alias_item.alias=function() self:shamo1_shamo2() end
	self.alias_table["shamo1_shamo2"]=alias_item


	alias_item={}
	alias_item.name="outwuguan"
	alias_item.dir="s"
	alias_item.alias=function() self:outwuguan() end
	self.alias_table["outwuguan"]=alias_item
	--print("ע�� ����")
end
--����ͷ
--������ȥ���Ҿ��϶�(enter;enter;use fire;w;nw;n;ne;e;se;s;sw;out;get tou)
