--2187
require "wait"
require "map"
jiaohua={
    new=function()
     local jh={}
	 setmetatable(jh,{__index=jiaohua})
	 return jh
   end,
}

function jiaohua:fail(id)
end

function jiaohua:catch()
  wait.make(function()
    local l,w=wait.regexp("������˵������ׯ�ſڵĲ軨������Ĳ�ʢ���úú�����һ���ˣ���ȥ�������ţ��������Űɡ���$|^(> |)������˵���������������ݣ����һ�������ɡ���$",5)
	if l==nil then
	   self:ask_job()
	   return
	end
	if string.find(l,"ׯ�ſڵĲ軨������Ĳ�ʢ") then
	   local b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	     self:tools()
	   end
	   b:check()
	   return
	end
	if string.find(l,"���������ݣ����һ��������") then
	    self.fail(102)
	   return
	end
	wait.time(5)
  end)
end

function jiaohua:ask_job()
  local w=walk.new()
  w.walkover=function()
     world.Send("ask wang about job")
	 wait.make(function()
	   local l,w=wait.regexp("���������˴����йء�job������Ϣ��",5)
	   if l==nil then
	     self:ask_job()
	     return
	   end
	   if string.find(l,"���������˴����йء�job������Ϣ") then
	     self:catch()
	     return
	   end
	   wait.time(5)
	 end)
  end
  w:go(2187)
end

function jiaohua:tools()
  local w=walk.new()
  w.walkover=function()
     world.Send("ask yan about ����")
	 wait.make(function()
	   local l,w=wait.regexp("�����轻����һ�����ߡ�",5)
	   if l==nil then
	     self:tools()
	     return
	   end
	   if string.find(l,"�����轻����һ������") then
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
	       self:jiaoshui()
		 end
		 b:check()
	     return
	   end
	   wait.time(5)
	 end)
  end
  w:go(2191)
end

function jiaohua:reward()
   local w=walk.new()
   w.walkover=function()
      wait.make(function()
	    world.Send("ask wang about ok")
	    local l,w=wait.regexp("^(> |)�㱻�����ˣ�$",5)
		if l==nil then
		   self:reward()
		   return
		end
        if string.find(l,"�㱻����") then
		   self:jobDone()
		   return
		end
	  end)
   end
   w:go(2187)
end

function jiaohua:return_tools()
  local w=walk.new()
  w.walkover=function()
     world.Send("give yan piao")
	 local l,w=wait.regexp("���������һ��ư��",5)
	 if l==nil then
	   self:return_tools()
	   return
	 end
	 if string.find(l,"���������һ��ư") then
        self:reward()
	    return
	 end
	 wait.time(5)
  end
  w:go(2191)
end

function jiaohua:jiao()
  wait.make(function()
	local l,w=wait.regexp("^(> |)�����ˮ�Ѿ����Ĳ���ˣ����Ի�ȥ�����ˡ�|^(> |)���Ѿ������ˣ��������������ѻ�����ѽ��",0.8)
	world.Send("jiaoshui")
	if l==nil then
	  self:jiao()
	  return
	end
	if string.find(l,"���Ի�ȥ������") or string.find(l,"���Ѿ������ˣ��������������ѻ�����ѽ") then
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
		self:return_tools()
	  end
	  b:check()
	  return
	end
	wait.time(0.8)
  end)
end

function jiaohua:jiaoshui()
  local w=walk.new()
  w.walkover=function()
     world.Send("wield piao")
     self:jiao()
  end
  w:go(2017)
end

function jiaohua:jobDone()
end
