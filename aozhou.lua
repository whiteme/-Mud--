--2187
require "wait"
require "map"
aozhou={
    new=function()
     local az={}
	 setmetatable(az,{__index=aozhou})
	 return az
   end,
   version=1.8,
}

function aozhou:ask_job()
  local w=walk.new()
  w.walkover=function()
     world.Send("ask seng about ����")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)����ɮ˵��������ɮ�¾�Ҫ�ܳԿ����ͣ���Ͱ��Ұ���.*$|^(> |)����ɮ˵�������㲻���Ѿ����˹����𣿻�����ȥ������$",5)
	   if l==nil then
	     self:ask_job()
	     return
	   end
	   if string.find(l,"��Ͱ��Ұ���") or string.find(l,"�㲻���Ѿ����˹����𣿻�����ȥ��") then
	     self:done()
	     return
	   end
	   wait.time(5)
	 end)
  end
  w:go(829)
end

function aozhou:done()
   	local ts={
	           task_name="���ְ���",
	           task_stepname="����",
	           task_step=2,
	           task_maxsteps=2,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local _hp=hp.new()
	_hp.checkover=function()
	   if _hp.qi<50 then
	       world.Send("yun qi")
		   local f=function() self:done() end
		   f_wait(f,0.5)
	   else
	       world.Send("ao ��")
		   self:ao()
	   end
	end
	_hp:check()
end

function aozhou:ao()
  wait.make(function()
	local l,w=wait.regexp("^(> |)������һ����˫�Ź�ס�����������ڿ��У��ӹ������������������|^(> |)��������æ����!$|^(> |)�����ɲ���������ĵط����㻹���߿���! $",1)
	if l==nil then
	  self:done()
	  return
	end
	if string.find(l,"������һ����˫�Ź�ס����") or string.find(l,"��������æ����") then
	   local f=function()
	     self:done()
	   end
	   f_wait(f,0.5)
	   return
	end
	if string.find(l,"�����ɲ���������ĵط����㻹���߿���") then
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
		self:jobDone()
	  end
	  b:check()
	  return
	end
	wait.time(1)
  end)
end

function aozhou:Status_Check()
	local ts={
	           task_name="���ְ���",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=2,
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
		elseif h.qi<h.max_qi*0.8  then
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
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end

function aozhou:jobDone()
end

