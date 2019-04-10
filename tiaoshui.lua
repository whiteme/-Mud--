
tiaoshui={
    new=function()
     local ts={}
	 setmetatable(ts,{__index=tiaoshui})
	 return ts
   end,
   count=0,
}

function tiaoshui:ask_job()
  local w=walk.new()
  w.walkover=function()
     world.Send("ask huikong about ��ˮ")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)�ۿ����ߴ�����ó�һ�Դ���Ͱ���ڵ��ϡ�$|^(> |)�ۿ�����˵�������㲻��������Ͱ�𣿿�ȥ�ɻ�ɡ���$|^(> |)�ۿ�����˵��������Ͱ�����ڵ��Ϸ�������ȥ�ɻ�ɡ���$",5)
	   if l==nil then
	     self:ask_job()
	     return
	   end
	   if string.find(l,"��Ͱ�����ڵ��Ϸ�������ȥ�ɻ��") or string.find(l,"����Ͱ���ڵ���")  then
	       local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
	         world.Send("get tie tong")
	         self:done()
		   end
		   b:check()
		  return
	   end
	   if string.find(l,"�㲻��������Ͱ��") then
	     --world.Send("get tie tong")
	     self:done()
	     return
	   end
	   wait.time(5)
	 end)
  end
  w:go(1730)
end

function tiaoshui:done()
   local w=walk.new()
   w.walkover=function()
	  self:tiaoshui()
   end
   w:go(776)
end

function tiaoshui:tiaoshui()
  world.Send("fill tong")
  wait.make(function()
	local l,w=wait.regexp("^(> |)�㽫����Ͱװ����ˮ��$|^(> |)������û������������$",1)
	if l==nil then
	  self:done()
	  return
	end
	if string.find(l,"�㽫����Ͱװ����ˮ") then
	   self:back()
	   return
	end
	if string.find(l,"������û����������") then
	   self:jobDone()
	   return
	end
	wait.time(1)
  end)
end

function tiaoshui:back()
  local w=walk.new()
  w.walkover=function()
     world.Send("dao gang")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)�㽫��ˮ�����ˮ���С�$|^(> |)��������ֻ����Ͱ���Ŵ�ˮ�ױȻ��š�$",5)
	   if l==nil then
	     self:back()
	     return
	   end
	   if string.find(l,"�㽫��ˮ�����ˮ����") then
          self.count=self.count+1
		  print("����:",self.count)
	      self:Status_Check()
	      return
	   end
	   if string.find(l,"��������ֻ����Ͱ���Ŵ�ˮ�ױȻ���") then
	      self:Status_Check()
	      return
	   end
	   wait.time(5)
	 end)
  end
  w:go(1730)
end

function tiaoshui:Status_Check()

     --��ʼ��
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
			      world.Execute("sit chair;qiao luo;get hulu;drink hulu;drink hulu;drink hulu;drop hulu;get doufu;eat doufu;eat doufu;eat doufu;drop doufu")
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
		   w:go(817) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif h.neili<h.max_neili*0.5  then
           local w=walk.new()
		   w.walkover=function()
		      local _rest=rest.new()
			  _rest.failure=function(id)
			    local f=function()
				  w:go(878)
				end
				f_wait(f,10)
 			 end
			 _rest.wake=function(flag)
				self:Status_Check()
			 end
			 _rest:sleep()
		   end
            w:go(878)
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:done()
			end
			b:check()
		end
	end
	h:check()
end

function tiaoshui:jobDone()
end
