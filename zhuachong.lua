
zhuachong={
  new=function()
     local zc={}
	 setmetatable(zc,{__index=zhuachong})
	 return zc
  end,
  co=nil,
  zhizhu_num=0,
  shachong_num=0,
  wugong_num=0,
  xiezi_num=0,
  neili_upper=1.5,
  liandu="",

}
--[[
1.׽��

��ȥ�����ɣ�ask ding about ����ȣ��Ϳ��Կ�ʼ��ץ���ӵ������ˡ�
����(s;sd;ne;order remove)���Ŵ򿪣������ȣ���ʼץ���ӡ� �����˴�liu huang��tan zi��fire�� ����������������������ᴦ������ ��
��ȥ����burn liuhuang���г��ӵ���ʾ��dai chongzi��Ҫ�� �����˳��ӣ���kill du chong���������ˡ�get(zhizhu,xiezi,shachong,wugong),zhuang xxx in tanzi �������������killer�ĵ�����ɱ�㣬ҪС�ģ���������̫������
ÿ��ȥһ�ο���ץ�������ӡ������˵ı����ˣ� һ��������һ�� bai ding����
ץ����ӳ���yell open,��������ץ�ĳ���(xian xxx)

2.��ҩ

�ڶ������׽��ʱ��Ҫ(zhizhu,xiezi,shachong,wugong)�������涼׽һ����Ȼ������ҩ����
fang water in guo; fang (zhizhu,xiezi,shachong,wugong) in guo;ao yao

һ���������̵��ĳ�࣬������(chang)ζ���� �����������ɵĺ�Ȼ�Ӵ�ҩ®�������ģ�

chang gao;Ҫ�ӻ����ڹ���exp��pot����������cut�ˣ�������Ȥ�Ŀ���ȥ�ԡ�

���˺þã����ڿ�����һ������׽��job�ģ���֪���Ķ���������

]]

function zhuachong:equipments()
	   local sp=special_item.new()
       sp.cooldown=function()
           self:ask_job()
       end
       local equip={}
	   equip=Split("<��ȡ>����|<��ȡ>���|<��ȡ>̳��&4","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

function zhuachong:xian_bugs()
   wait.make(function()
     --��Ϲ��Ͼ��ؽ�����ɫ��֩���ó���˫�����ϣ���Ҫ�׸����ء�
	 local l,w=wait.regexp("^(> |)��Ϲ��Ͼ��ؽ�.*�ó���˫�����ϣ���Ҫ�׸����ء�$|^(> |)�趨����������action \\= \\\"����\\\"$|^(> |)ʲô��$",10)
	 if l==nil then
	    self:xian()
		return
	 end
	 if string.find(l,"��Ϲ��Ͼ��ؽ�") then
	     wait.time(2)
		 local b=busy.new()
		 b.Next=function()

		   world.Execute("xian wugong;xian xiezi;xian shachong;xian zhizhu;set action ����")
		   self:xian_bugs()
		 end
		 b:check()

	    return
	 end
	 if string.find(l,"�趨��������") then
	    print("job ����!!")
	    self:jobDone()
		return
	 end
	 if string.find(l,"ʲô") then
	    self:xian()
	    return
	 end
   end)
end

function zhuachong:xian()
  local w=walk.new()
  w.walkover=function()
     world.Execute("zhuang wugong in tanzi 4;zhuang xiezi in tanzi 3;zhuang shachong in tanzi 2;zhuang zhizhu in tanzi")
	 world.Execute("xian wugong;xian xiezi;xian shachong;xian zhizhu;set action ����")
     self:xian_bugs()
  end
  w:go(2368)
end

function zhuachong:flee()
   world.Send("fu wan")
end

function zhuachong:changgao()
   world.Send("chang gao")
   wait.make(function()
      local l,w=wait.regexp("^(> |)������ĳ�డ��һ�ڵĳ�����ȥ��$",5)
	  if l==nil then
		  self:checkbugs()
		  return
	  end
	  if string.find(l,"������ĳ�డ��һ�ڵĳ�����ȥ") then
	          local b=busy.new()
			  b.interval=0.8
			  b.Next=function()
	             self:checkbugs()
			  end
			  b:check()
	     return
	  end
   end)

end

function zhuachong:aoyao()
         local w=walk.new()
          w.walkover=function()
		      world.Send("")
              world.Send("fang water in guo")
	          world.Execute("fang zhizhu in guo")
			  world.Execute("fang xiezi in guo")
	          world.Execute("fang shachong in guo")
	          world.Execute("fang wugong in guo")
	          world.Send("ao yao")
			  local b=busy.new()
			  b.interval=0.8
			  b.Next=function()
			     self:changgao()
			  end
			  b:check()
			  --self:aoyao()
          end
          w:go(4035)
end

function zhuachong:bugs()
   wait.make(function()
   --��Ҫ��ʲô��
      local l,w=wait.regexp("^(> |)��Ҫ��ʲô��$|^(> |)�趨����������action \\= \\\"���\\\"$",5)
	  if l==nil then
	     self:bugs()
	     return
	  end
	  if string.find(l,"��Ҫ��ʲô") then
	      print("ȱ�䷽")
		  self:xian()
		  --self:jobDone()
	     return
	  end
	  if string.find(l,"�趨����������action") then
	     self:aoyao()
		 return
	  end
   end)
end

function zhuachong:checkbugs()
	local ts={
	           task_name="����ץ��",
	           task_stepname="��ҩ",
	           task_step=4,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	print("֩��",self.zhizhu_num)
	world.Send("l tanzi")
	print("Ы��",self.xiezi_num)
	world.Send("l tanzi 2")
	print("ɳ��",self.shachong_num)
	world.Send("l tanzi 3")
	print("���",self.wugong_num)
	world.Send("l tanzi 4")
 --[[if bugid=="zhizhu" then
      seq=""
   elseif bugid=="shachong" then
      seq=" 2"
   elseif bugid=="xiezi" then
      seq=" 3"
   elseif bugid=="wugong" then
      seq=" 4"
   end]]
	world.Execute("get wugong from tanzi 4;get xiezi from tanzi 3;get shachong from tanzi 2;get zhizhu from tanzi")

	world.Execute("l xiezi;l wugong;l shachong;l zhizhu;set action ���")
	self:bugs()

	--else
	--   self:xian()
	--end
end
--�����ǰһ����ԭ����һֻ��ɫ�����ȫ�����⣬ͷ��͹����Ѱ��������ͬ��
--���졸ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
--����ĳ����ƺ��Ѿ���������ץ���ˣ���ֻ��ȥ�����ط���һ���ˡ�
--�㻹û�аѳ�����������
function zhuachong:ask_job()
	local ts={
	           task_name="����ץ��",
	           task_stepname="ѯ������",
	           task_step=2,
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
    world.Send("ask ding about �����")
    local l,w=wait.regexp("^(> |)������ʹ��ض���˵�����ðɣ�$|^(> |)������˵���������ץ����ӣ�����ȥ��Ϣ��ɡ���$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"���ץ����ӣ�����ȥ��Ϣ���") then
	  local b=busy.new()
	  b.Next=function()
		 self:chonggu()
	  end
	  b:check()

	   return
	end
	if string.find(l,"������ʹ��ض���˵��") then
	  local b=busy.new()
	  b.Next=function()
		 self:chonggu()
	  end
	  b:check()

	  return
	end
	wait.time(5)
   end)
  end
  w:go(1969)
end
--�ۺ�ɫС����̳�������˳������������ϣ�����ץ��ʱ���Ѿ������ˡ�
function zhuachong:get_chongzi(bugid,bugname)
   bugid=string.lower(bugid)
   world.Send("yun refresh")
   world.Send("get "..bugid)
   local seq=""
   if bugid=="zhizhu" then
      seq=""
   elseif bugid=="shachong" then
      seq=" 2"
   elseif bugid=="xiezi" then
      seq=" 3"
   elseif bugid=="wugong" then
      seq=" 4"
   end
   world.Send("zhuang "..bugid.." in tanzi"..seq)

   if bugid=="zhizhu" then
      self.zhizhu_num=self.zhizhu_num+1
   end
	if bugid=="xiezi" then
      self.xiezi_num=self.xiezi_num+1
   end
   	if bugid=="shachong" then
      self.shachong_num=self.shachong_num+1
   end
   	if bugid=="wugong" then
      self.wugong_num=self.wugong_num+1
   end
   local b=busy.new()
   b.Next=function()
      self:dai()
   end
   b:check()
end
--��ɫɳ������һ�ţ����ٶ��ˡ�

function zhuachong:chongzi_die(bugname,bugid)
  print(bugname,bugid)
  wait.make(function()
    local l,w=wait.regexp("^(> |)"..bugname.."����һ�ţ����ٶ��ˡ�$|^(> |)�����һ�㣬�ǲ����ǻ��$|^(> |)����û������ˡ�$",10)
	if l==nil then
	   world.Send("kill "..bugid)
	   self:chongzi_die(bugname,bugid)
	   return
	end
	if string.find(l,"����һ�ţ����ٶ���") or string.find(l,"�����һ�㣬�ǲ����ǻ���") or string.find(l,"����û�������") then
	  self:get_chongzi(bugid,bugname)
      return
	end
  end)
end

function zhuachong:chongzi(bugid,bugname)
  --print(bugname,bugid)
  bugid=string.lower(bugid)
  wait.make(function()
    world.Send("kill "..bugid)
    local l,w=wait.regexp("^(> |)������"..bugname.."��ɱ���㣡|^(> |)�����һ�㣬�ǲ����ǻ��$|^(> |)����û������ˡ�$",10)
	if l==nil then
	   self:chongzi(bugid,bugname)
	   return
	end
	if string.find(l,"����û�������") then
	   self:cbug()
	   return
	end
	if string.find(l,bugname) then
	   self:chongzi_die(bugname,bugid)
	   return
	end
	if string.find(l,"�����һ�㣬�ǲ����ǻ���") then
	    self:get_chongzi(bugid,bugname)
        return
	end
  end)
end

function zhuachong:dai()
   world.Send("dai chongzi")
   wait.make(function()
       local l,w=wait.regexp("^(> |)�����ǰһ����ԭ����һֻ(.*)ȫ�����⣬ͷ��͹����Ѱ��������ͬ��$|^(> |)��������æ���أ�û����������ץ���ӣ�$|^(> |)���ӱ���һ�ţ�����ݴԲ����ˡ�$|^(> |)�㻹û�аѳ�����������$|^(> |)����ĳ����ƺ��Ѿ���������ץ���ˣ���ֻ��ȥ�����ط���һ���ˡ�$|^(> |)�����ڲ���ץ���ӣ���������û����������ɣ�$",5)
       if l==nil then
	      self:dai()
	     return
	   end
	   if string.find(l,"�㻹û�аѳ���������") then
	      self:burn()
	      return
	   end
	   if string.find(l,"��������æ����") then
	      local f=function()
	        self:dai()
		  end
		  f_wait(f,0.8)
	      return
	   end
	   if string.find(l,"���ӱ���һ�ţ�����ݴԲ�����") then
	      local f=function()
	         self:dai()
		  end
		  f_wait(f,1)
	      return
	   end
      if string.find(l,"����ĳ����ƺ��Ѿ���������ץ����") then
	    self:move()
		return
	   end
	   if string.find(l,"��Ѱ��������ͬ") then
	      local bugname=w[2]

		  local bugid
		  if string.find(bugname,"֩��") then
		     bugid="zhizhu"
		  elseif string.find(bugname,"���") then
		     bugid="wugong"
		  elseif string.find(bugname,"ɳ��") then
		     bugid="shachong"
		  elseif string.find(bugname,"Ы��") then
		     bugid="xiezi"
		  end

		  self:chongzi(bugid,bugname)
	      return
	   end
	   if string.find(l,"�����ڲ���ץ����") then
	      self:leave()
	      return
	   end
   end)

end

function zhuachong:combat()
   world.Send("yun qi")
   world.Send("yun jingli")
end

function zhuachong:kill(name,id)
     id=Trim(id)
	 id=string.lower(id)
	 print("ɱ��:",name,id)
	 self.shashou_name=name
	 self.shashou_id=id
	 world.Send("kill "..id)
	 self:combat()
	 self:shashou_die()
end

function zhuachong:cbug()
  world.Execute("look;set look 1")
  wait.make(function()
	    local l,w=wait.regexp("^(> |)(.*)\\\((.*)\\\).*$|^(> |)�趨����������look \\= 1",10)
		if l==nil then
		   self:cbug()
		   return
		end
		--print(l)
		if string.find(l,")") then
		   --print(w[2]," " ,w[3])
		   local name=w[2]
		   local id=string.lower(w[3])
		   print(name,id)
		   if string.find(name,"֩��") or string.find(name,"ɳ��") or string.find(name,"Ы��") or string.find(name,"���") then
		       self:chongzi(id,name)
		   else
              self:cbug()
		   end
		   return
		end
		if string.find(l,"�趨��������") then
		   self:dai()
		   return
		end
	end)
end

function zhuachong:cjob()
   self:time_end()
   local b=busy.new()
   b.Next=function()
      self:cbug()
   end
   b:check()
end
--��⣬�ֳ������˸���....!!!
function zhuachong:shashou_die()
   wait.make(function()
      local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯.*|^(> |)��⣬�ֳ������˸���\.\.\.\.\!\!\! $",10)
	  if l==nil then
	     self:shashou_die()
		 return
	  end
	  if string.find(l,"���") then
	     self:wanted()
	     return
	  end

	  if string.find(l,"һ�����ڵ���") then
	     local name=w[2]
		 print(name)
		 if string.find(self.shashou_name,name) then
		     world.Send("unset wimpy")
		     shutdown()
			 if self.liandu=="�Զ�" then
			    local b=busy.new()
				b.Next=function()
			     world.Send("get silver from corpse")
				 world.Send("get silver from corpse 2")
				 world.Send("get corpse")
				 self:leave()
				end
				b:check()
			 else
				 local b=busy.new()
				b.Next=function()
			     world.Send("get silver from corpse")
				 world.Send("get silver from corpse 2")
				 --world.Send("get corpse")
				 self:cbug()
				end
				b:check()
			 end
		 else
		     self:shashou_die()
		 end
		 return
	  end
      wait.time(10)
   end)
end

function zhuachong:get_id(npc)
	wait.make(function()
		 world.Send("look")
	    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$",5)
		if l==nil then
		   self:get_id(npc)
		   return
		end
		if string.find(l,npc) then

		   self:kill(npc,w[2])
		   return
		end
		wait.time(5)
	end)
end

function zhuachong:wanted()
   world.Send("say ������·�㲻�ߣ��������Ŵ�������")
   --������������ɱ���㣡
   wait.make(function()
      local l,w=wait.regexp("^(> |)������(.*)��ɱ���㣡$",10)
	  if l==nil then
	     self:wanted()
	     return
	  end
	  if string.find(l,"��ɱ����") then
	     local npc=w[2]
		 if string.find(npc,"֩��") or string.find(npc,"ɳ��") or string.find(npc,"���") or string.find(npc,"Ы��") then
		     self:wanted()
		  else
		     self:get_id(npc)
		  end
		 return
	  end
   end)

end

function zhuachong:out()

 world.Send("yell open")
  wait.make(function()
    local l,w=wait.regexp("^.*���ŷ��������������������򿪣������ڿ��Գ�ȥ�ˡ�$|^(> |)ʲô?$",5)
	if l==nil then
	   self:out()
	   return
	end
	if string.find(l,"ʲô") then
	   self:leave()
	   return
	end
	if string.find(l,"���ŷ�������������") then
	   world.Send("south")
	   world.Send("southwest")
	   self:checkbugs()
	   return
	end
  end)
end



function zhuachong:leave()
	local _R
   _R=Room.new()
   _R.CatchEnd=function()
     print("����ƶ�")
     local dx=Split(_R.exits,";")
	 for _,d in ipairs(dx) do
	    if d=="southeast" then
		    local b=busy.new()
	        b.Next=function()
		       world.Send("southeast")
		       self:out()
			end
	        b:check()
		   return
		end
	 end
	 local b=busy.new()
	 b.Next=function()
		 world.Send("east")
		 world.Send("south")
		 self:leave()
	 end
	 b:check()
   end
   _R:CatchStart()
end

function zhuachong:time_end()
  wait.make(function()
    local l,w=wait.regexp("^(> |)�������Щ����ƺ���Χ����ʲô���ڣ����˶����ˣ�$",10)
	   if l==nil then
		  self:time_end()
	      return
	   end
	   if string.find(l,"�������Щ����") then
	      shutdown()
	      self:wanted()
	      return
	   end
  end)
end
--[[> ����� -
    һƬƽ̹�ȵأ������Ǵ�ɽ���ơ������������ģ�����ʮ�ֲֿ�������
�������𣬸��ֶ���������������¶��ǳ��긯�ݰ�Ҷ�óɵ����ࡣ����
��ɽ��ͨ���йν����������㼡���������ۡ�
��������һ�����������磬̫�����߹�������������С�
    �������Եĳ����� east��north��south��southeast �� west��]]

function zhuachong:move()
     print("����ƶ�")
	 world.Send("northwest")
     local dx={"west","east","south","north"}
	 i=math.random(4)
	 print("���:",i)
	 local run_dx=dx[i]
	 print(run_dx, " ����")
	 local b=busy.new()
	 b.interval=0.5
	 b.Next=function()
		 world.Send(run_dx)
		 self:dai()
	 end
	 b:check()
end

--[[> �����ǰһ����ԭ����һֻ��ɫ֩��ȫ�����⣬ͷ��͹����Ѱ��������ͬ��
�������Щ����ƺ���Χ����ʲô���ڣ����˶����ˣ�
���������ԥ��ɱ���㣡
���ԥ��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
���ӱ���һ�ţ�����ݴԲ����ˡ�
��������æ���أ�û����������ץ���ӣ�
> ��ץ���ʱ��쵽�ˣ��Ͻ���ȥ�ѳ��Ӹ������ɣ�
> ���ŷ��������������������򿪣������ڿ��Գ�ȥ�ˡ�
��ʱ���ѵ�������ץ���ӽ�����]]
function zhuachong:burn()
--������������һС�飬���ڵ��ϣ��û��۵�ȼ������������
  wait.make(function()
     world.Send("burn liuhuang")
	 local l,w=wait.regexp("^(> |)�����òݴ���ɪɪ���죬�̲���һ��ζ����㲻��ͣ���������뿴��������$|^(> |)����ĳ����ƺ��Ѿ���������ץ���ˣ���ֻ��ȥ�����ط���һ���ˡ�$",5)
	 if l==nil then
		self:burn()
	    return
	 end
     if string.find(l,"����ĳ����ƺ��Ѿ���������ץ����") then
	    wait.time(1)
	    self:move()
	    return
     end
	 if string.find(l,"�����òݴ���ɪɪ����") then
	    wait.time(1)
	    self:dai()
		return
	 end
  end)
end

function zhuachong:chonggu()
	local ts={
	           task_name="����ץ��",
	           task_stepname="ץ��",
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
    world.Send("order remove")
	wait.make(function()
	--���ŷ��������������������򿪣������ڿ��Խ�ȥ�ˡ�
	  local l,w=wait.regexp("^(> |)���ŷ��������������������򿪣������ڿ��Խ�ȥ�ˡ�$|^(> |)ʲô��$|^(> |)ʲô?$",5)
	  if l==nil then
	     self:chonggu()
	     return
	  end
	  if string.find(l,"ʲô") then
	      local _R
		  _R=Room.new()
		  _R.CatchEnd=function()

			 local count,roomno=Locate(_R)
			 if roomno[1]==2368 then
			     self.fail(101)
			 elseif _R.roomname=="������" and _R.exits=="north;southwest;" then
			       world.Send("north")
	              world.Send("northwest")
		           self:time_end()
		          wait.time(2)
		         self:burn()
			 else
                 self:chonggu()
			 end
		  end
		 _R:CatchStart()

	     return
	  end
	  if string.find(l,"���ŷ�������������") then
	     world.Send("north")
	     world.Send("northwest")
		 self:time_end()
		 wait.time(2)
		 self:burn()
		 return
	   end
	end)
  end
  w:go(2368)
end

function zhuachong:jobDone()
end

function zhuachong:eat()
    local w=walk.new()
	w.walkover=function()
		  world.Send("ask chuzi about ʳ��")
		  wait.time(1.5)
	      world.Execute("get cai yao")
		  world.Execute("eat cai yao;eat cai yao;eat cai yao;drop cai yao")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
	end
	w:go(2367)
end

function zhuachong:drink()
     local w=walk.new()
	   w.walkover=function()
	      world.Send("ask chuzi about ˮ")
		  wait.time(1.5)
	      world.Execute("get hulu;get hulu")
		  world.Execute("drink hulu;drink hulu;drink hulu;e;drop hulu 2;drop hulu;w")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
		end
		w:go(2367) --����¥ 976
end

function zhuachong:full()
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<70 or h.drink<70 then
		     if h.food<70 then
			    self:eat()
			 elseif h.drink<70 then
			    self:drink()
			 end
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
				if id==777 then
				  self:full()
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
			     self:equipments()
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
			  self:equipments()
			end
			b:check()
		end
	end
	h:check()
end

function zhuachong:Status_Check()
	local ts={
	           task_name="����ץ��",
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


