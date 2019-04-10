--[[#al xc1 {wu;eu;wu;nu;n;nu;nd;n;n;s;s;su;sd;s;sd;ed;sd;eu;sd;wu;sd;sw;su};
#al xc2 {nd;w;nw;sw;u;d;ne;se;sw;su;nd;ne;e;ne;ed;e};
#al xc3 {n;w;e;n;w;e;n;w;e;n;w;e;n;s;e;s;e;n;n;s;s;s;s;n;e;n;n;n;s};
#al xc4 {e;n;s;e;w;s;e;w;s;e;w;s;e;w;s;e;e;se;n;s;s;e;w;s;e;w;su;enter};
#al xc5 {d;d;d;e;e;up;e;w;d;w;w;up;up;up;out;nd;n;n;nw;ne;eu;eu;se;se;enter;n;n;n};
#al xc6 {s;s;s;out;nw;nw;wd;wd;sw;w;w;s;e;w;s;e;w;s;e;w;s;e;w;s;n;w;s;n;w;n;e;w;w};
#al xc7 {e;n;s;s;s;s;su;e;w;se;w;w;e;e;s;su;sw;ne;nd;n;su;n;s;s;n;nd;nw;nd;n;n;w};
#al xc8 {s;n;w;s;n;w;e;n;w;e;n;w;e;n;w;e;n;w};]]

local path={
   "wu;eu;wu;nu;n;nu;nd;n;n;s;s;su;sd;s;sd;ed;sd;eu;sd;wu;sd;sw;su",
   "nd;w;nw;sw;u;d;ne;se;sw;su;nd;ne;e;ne;ed;e",
   "n;w;e;n;w;e;n;w;e;n;w;e;n;s;e;s;e;n;n;s;s;s;s;n;e;n;n;n;s",
   "e;n;s;e;w;s;e;w;s;e;w;s;e;w;s;e;e;se;n;s;s;e;w;s;e;w;su;enter",
   "d;d;d;e;e;up;e;w;d;w;w;up;up;up;out;nd;n;n;nw;ne;eu;eu;se;se;enter;n;n;n",
   "s;s;s;out;nw;nw;wd;wd;sw;w;w;s;e;w;s;e;w;s;e;w;s;e;w;s;n;w;s;n;w;n;e;w;w",
   "e;n;s;s;s;s;su;e;w;se;w;w;e;e;s;su;sw;ne;nd;n;su;n;s;s;n;nd;nw;nd;n;n;w",
   "s;n;w;s;n;w;e;n;w;e;n;w;e;n;w;e;n;w"
   }
--> ��Ѳ��ʱ���ѹ�������Ĵ��鿴��ϣ����Ի�ȥ������task ok)�ˣ�

xuncheng={
   new=function()
     local xc={}
	 setmetatable(xc,{__index=xuncheng})
	 return xc
   end,
  co=nil,
  neixi_wan=0,
  xujing_dan=0,
  cycle=false,
  eat_neixiwan=false,
  eat_xujingdan=false,
}

function xuncheng:rollback(index)
  	local ts={
	           task_name="Ѳ��",
	           task_stepname="Ѳ��",
	           task_step=tonumber(index),
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local lastroomno
  if index==1 then
   lastroomno=433
  elseif index==2 then
   lastroomno=490
  elseif index==3 then
   lastroomno=432
  elseif index==4 then
   lastroomno=404
  elseif index==5 then
   lastroomno=491
  elseif index==6 then
   lastroomno=492
  elseif index==7 then
   lastroomno=493
  elseif index==8 then
   lastroomno=457
  end
  print("�˻�:",lastroomno)
  local w
  w=walk.new()
  w.walkover=function()
     local p
	 p=path[index]
	 local f=function()
	   world.Execute(p)
	   self:check_point(index)
	 end
	 print("�ȴ�1.5��")
	 f_wait(f,1.5)
  end
  world.Send("yun refresh")
  w:go(lastroomno)
end

function xuncheng:gaibang_sleep(index)-- ؤ��sleep �ָ�
   local r=rest.new()
   r.wake=function()
       self:check_point(index)
   end
   r:sleep()
end

function xuncheng:neigong(h,i)
   print("xc neigong:",i)
   local party=world.GetVariable("party") or ""
   if (h.neili<=100 or h.qi<h.max_qi*0.5) and party=="ؤ��" then
	   self:gaibang_sleep(i)
       return
   end
   local x
   x=xiulian.new()
   x.limit=true
   x.fail=function(id)
      --print("err_id",id)
      if id==202 then --safe room û�а취����
	     world.Send("yun refresh")
		 local f=function() self:check_point(i) end
		 f_wait(f,5)
	  else
		 local f
		 f=function() x:dazuo() end
	     f_wait(f,30)
	  end
   end
   x.success=function(h)
	 --xuncheng.check_point(i)
	 print("����Ѳ��",i)
	 self:check_point(i)
   end
   x:dazuo()
end

function xuncheng:check_point(index)
    --print("index:",index)
	local h
	h=hp.new()
	h.checkover=function()
		if h.jingli>=120 or index==8 then
		   local _R
	       _R=Room.new()
	       _R.CatchEnd=function()
		     local count,target_roomno=Locate(_R)
	         --print(count," ",target_roomno[1])
	         if index==1 and target_roomno[1]~=490 then
	           self:rollback(index)
	         elseif index==2 and target_roomno[1]~=432 then
	           self:rollback(index)
	         elseif index==3 and target_roomno[1]~=404 then
	           self:rollback(index)
	         elseif index==4 and target_roomno[1]~=491 then
	           self:rollback(index)
	         elseif index==5 and target_roomno[1]~=492 then
	           self:rollback(index)
	         elseif index==6 and target_roomno[1]~=493 then
	           self:rollback(index)
	         elseif index==7 and target_roomno[1]~=457 then
	           self:rollback(index)
	         elseif index==8 and target_roomno[1]~=433 then
	           self:rollback(index)
	         else
		       print("��ȷ�ߵ�ָ��λ��,����")
			  local ts={
	           task_name="Ѳ��",
	           task_stepname="Ѳ��",
	           task_step=tonumber(index),
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	          }
	          local st=status_win.new()
  	          st:init(nil,nil,ts)
	          st:task_draw_win()
		       coroutine.resume(xuncheng.co)
	         end
		   end
		    _R:CatchStart()
		elseif self.eat_xujingdan==true then
		   print("xujing dan")
		   world.Send("fu xujing dan")
		   local f=function()
		     self:check_point(index)
		   end
           f_wait(f,3)
		else --��������100
			print("neili:",h.neili)
			if h.neili>=50 then
				world.Send("yun refresh")
				self:check_point(index)
			else
			    print("����")
				self:neigong(h,index)
			end
		end
	end
	 h:check()
end

--484 sleep room
function xuncheng:join()
   local w
   w=walk.new()
   w.walkover=function ()
	  wait.make(function()
	     world.Send("ask fu about join")
		 local l,w=wait.regexp("^(> |)��˼��˵�������ã�������λ.*����Ϊ�����������ˡ���$|^(> |)��˼��˵������.*�Ѿ��Ǳ���������ˣ��ιʻ�Ҫ��������Ц����$",5)
		 if l==nil then
            print("����̫�����Ƿ�����һ����Ԥ�ڵĴ���")
		    self:join()
		    return
         end
		 if string.find(l,"����Ϊ�����������ˡ�") or string.find(l,"�Ѿ��Ǳ����������") then
		    local b
			b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:xc()
			end
			b:check()
		    return
		 end
		 wait.time(5)
	  end)
   end
   w:go(445)
end

function xuncheng:fail(id)
end
function xuncheng:job_start()
   wait.make(function()
  	     --��ʼѲ���쵤��˵������Сʦ������������񣬻�����ȥ��Ϣһ��ɡ���
			local l,w=wait.regexp("�쵤��˵������.*���㲻�Ǳ�������ӣ��˻��Ӻ�˵�𣿡�|^(> |)�쵤��˵������.*����������񣬻�����ȥ��Ϣһ��ɡ���$|^(> |)�쵤��˵�������ðɣ�����ڴ������Χ�Ĵ��鿴һ�£�Ѳ��ʱӦ��С�ķ�������ֹ��С���$|^()> |�쵤��˵�������㲻���Ѿ�����Ѳ�ǵ������𣿻�����ȥ������$",5)
		    if l==nil then
		      self:xc()
		      return
		    end
		   if string.find(l,"�㲻�Ǳ��������") then
		      local b
		  	  b=busy.new()
			  b.Next=function()
		      self:join()
			  end
			  b:check()
		      return
		   end
		    if string.find(l,"������ȥ��Ϣһ���") then
		     local f=function()

			    self:xc()
			 end
			   print("3s���������")
			 f_wait(f,3)
		     return
		   end
		   if string.find(l,"����ڴ������Χ�Ĵ��鿴һ��") or string.find(l,"�㲻���Ѿ�����Ѳ�ǵ������𣿻�����ȥ��") then
		    local b
		    b=busy.new()
		    b.interval=0.3
		    b.Next=function()
		     self:patrol()
		    end
			b:check()
			return
		   end
		   wait.time(5)
    end)
end

function xuncheng:xc()
   local w
   w=walk.new()
   w.walkover=function()
	  wait.make(function()
	     world.Send("ask zhu about Ѳ��")
		 local l,w=wait.regexp("^(> |)�����쵤�������йء�Ѳ�ǡ�����Ϣ��$",5)
		 if l==nil then
		   self:xc()
		   return
		 end
		 if string.find(l,"�����쵤�������йء�Ѳ�ǡ�����Ϣ") then
           self:job_start()
		   return
		 end
		 wait.time(5)
     end)
   end
   w:go(433)
end

function xuncheng:Status_Check()
  	local ts={
	           task_name="Ѳ��",
	           task_stepname="״̬���",
	           task_step=0,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

     --��ʼ��
	local h
	h=hp.new()
	h.checkover=function()
	    --[[print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
		   print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
			   world.Send("ask xiao tong about ʳ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get fan")
			  	 world.Execute("eat fan;eat fan;eat fan;eat fan;drop fan")
				 local f
				 f=function()
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
				 f_wait(f,1.5)
			   end
			   b:check()
		   end
		    w:go(133) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		else]]
		    self:start()
		--end
	end
	h:check()
end

function xuncheng:start()
  if self.eat_neixiwan==true then
     self:look_neixiwan()
  elseif self.eat_xujingdan==true then
     self:look_xujingdan()
  else
     self:xc()
  end
end

function xuncheng:wait_taskok()
   if self.eat_xujingdan==true then
      local f
	   f=function()
	      print("�ر�")
		  shutdown()
	      local b
		  b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		     self:taskok()
		  end
		  b:check()
	   end
	    f_wait(f,8)
      return
   end
   local w
   w=walk.new()
   w.walkover=function()
       local f
	   f=function()
	      print("�ر�")
		  shutdown()
	      local b
		  b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		     self:taskok()
		  end
		  b:check()
	   end
	   local x
	   x=xiulian.new()
	   x.success=function()
	     print("��������")
	     x:dazuo()
	   end
	   local h
	   h=hp.new()
	   h.checkover=function()
	     if h.qi<100 and h.neili>100 then
		    --world.Send("yun recover")
			print("��ѭ����")
			if self.cycle==true then
			   world.Send("yun recover")
			end
			local f2=function()
			  h:check()
			end
			f_wait(f2,2)
			f_wait(f,8)
		 elseif h.neili<h.max_neili/2 then
		    world.Send("yun recover")
			world.Send("yun refresh")
		    world.Send("fu wan")
			f_wait(f,8)
	        x:dazuo()
		 else
		   f_wait(f,8)
	       x:dazuo()
		 end
	   end
	   h:check()
   end
   w:go(466)
end

function xuncheng:qu_gold(f)
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
        world.Send("qu 10 gold")
		local l,w=wait.regexp("^(> |)���������ȡ��ʮ���ƽ�$|^(> |)��û�д���ô���Ǯ��$",5)
		print("����")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold(f)
		   return
		end
		if string.find(l,"���������") then
		   --�ص�
		   f()
		   return
		end
		if string.find(l,"��û�д���ô���Ǯ") then
		  self.eat_neixiwan=false
		  self.eat_xujingdan=false
          self:xc()
		  return
		end
		wait.time(5)
	  end)
   end
   w:go(410)
end

function xuncheng:taskok()
--��ϲ�㣡��ɹ��������Ѳ�������㱻�����ˣ�
     local w
	 w=walk.new()
	 w.walkover=function()
	   wait.make(function()
	   world.Send("task ok")
	   local l,w=wait.regexp("^(> |)�㱻�����ˣ�.*��$|^(> |)����ô������ˣ��ǲ�����Щ�ط�ֻ��������������$|^(> |)���ǲ���͵��������©��Щ�ط�ûѲ? $|^(> |)���ǲ���͵��������©��Щ�ط�ûѲ? $|^(> |)��ûѲ��������ʲô����$|^(> |)��ϲ�㣡��ɹ��������Ѳ�������㱻�����ˣ�$|^(> |)���ǲ���͵��������©��Щ�ط�ûѲ.*$",5)
	   if l==nil then
         self:taskok()
		 return
	   end
	   if string.find(l,"�㱻������") or string.find(l,"��ϲ��") then
	     self:jobDone()
	     return
	   end
	   if string.find(l,"�ǲ�����Щ�ط�ֻ������������") then
	    print("error_101:","wait")
		world.Send("unset ����")
	    self:wait_taskok()
	    return
	   end
	   if string.find(l,"���ǲ���͵��") then
	    print("error_103:","�еط�©��")
	    self:patrol()
	    return
	   end
	   if string.find(l,"��ûѲ��������ʲô��") then
	    local b=busy.new()
		b.interval=0.3
		b.Next=function()
	     self:xc()
		end
		b:check()
	    return
	   end
	  wait.time(5)
	  end)
	 end
	 w:go(433)
end

function xuncheng:patrol()
    xuncheng.co=coroutine.create(function()
	   for i,p in ipairs(path) do
	     world.Execute(p)
		  local f=function()
		    print("�ָ�ִ��","check_point_",i)
   		    self:check_point(i)
		  end
		  f_wait(f,2)
	      coroutine.yield()
	   end
	   self:taskok()
	end)
	coroutine.resume(xuncheng.co)
end

function xuncheng:drug_ok()  --�ص�����
end

function xuncheng:look_xujingdan()
--  ��ʮ�����Ϣ��(Neixi wan)
 wait.make(function()
   world.Send("i")
   world.Send("set look")
   local l,w=wait.regexp("^(> |)(.*)��������\\(Xujing dan\\)$|^(> |)�趨����������look \\= \\\"YES\\\"",5)
   if l==nil then
      self:look_xujingdan()
      return
   end
   if string.find(l,"������") then
     print(w[2])

      local dan=ChineseNum(trim(w[2]))

	  self.xujing_dan=dan
	  if self.xujing_dan<=10 then
	    self:buy_xujingdan()
	  else
	    self:xc()
	  end
	  return
   end
   if string.find(l,"�趨����������look ") then
      self.xujing_dan=0
	  self:buy_xujingdan()
	  return
   end
   wait.time(5)
  end)
end

function xuncheng:buy_xujingdan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy xujing dan")
	 local l,w=wait.regexp("����.*�ļ۸��ҩ���ƹ�����������һ����������|^(> |)������Ķ���������û�С�$|^(> |)��⵰��һ�ߴ���ȥ��",5)
	 if l==nil then
	   self:buy_xujingdan()
	   return
	 end
	 if string.find(l,"������Ķ���������û��") then
	   self:drug_ok()
	   return
	 end
	 if string.find(l,"һ��������") then
	    self.xujing_dan=self.xujing_dan+1
		if self.xujing_dan>=10 then
            self:drug_ok()
        else
            self:buy_xujingdan()
		end
	    return
	 end
	 if string.find(l,"��⵰��һ�ߴ���ȥ") then
	    local f=function()
		   self:look_xujingdan()
		end
	    self:qu_gold(f)
	    return
	 end
	 wait.time(5)
	end)
 end
 w:go(413)
end

function xuncheng:look_neixiwan()
--  ��ʮ�����Ϣ��(Neixi wan)
 wait.make(function()
   world.Send("i")
   world.Send("set look")
   local l,w=wait.regexp("^(> |)(.*)����Ϣ��\\(Neixi wan\\)$|^(> |)�趨����������look \\= \\\"YES\\\"",5)
   if l==nil then
      self:look_neixiwan()
      return
   end
   if string.find(l,"��Ϣ��") then
     print(w[2])

      local wan=ChineseNum(trim(w[2]))

	  self.neixi_wan=wan
	  if self.neixi_wan<=10 then
	    self:buy_neixiwan()
	  else

	    self:xc()
	  end
	  return
   end
   if string.find(l,"�趨����������look ") then
      self.neixi_wan=0
	  self:buy_neixiwan()
	  return
   end
   wait.time(5)
  end)
end

function xuncheng:buy_neixiwan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy neixi wan")
	 local l,w=wait.regexp("����.*�ļ۸��ҩ���ƹ�����������һ����Ϣ�衣|^(> |)������Ķ���������û�С�$|^(> |)��⵰��һ�ߴ���ȥ��",5)
	 if l==nil then
	   self:buy_neixiwan()
	   return
	 end
	 if string.find(l,"������Ķ���������û��") then
	   self:drug_ok()
	   return
	 end
	 if string.find(l,"һ����Ϣ��") then
	    self.neixi_wan=self.neixi_wan+1
		if self.neixi_wan>=10 then
            self:drug_ok()
        else
            self:buy_neixiwan()
		end
	    return
	 end
	 if string.find(l,"��⵰��һ�ߴ���ȥ") then
	    local f=function()
		  self:look_neixiwan()
		end
	    self:qu_gold(f)
	    return
	 end
	 wait.time(5)
	end)
 end
 w:go(413)
end

function xuncheng:join_fail() --�ص�����
end

function xuncheng:jobDone() --�ص�����
end
