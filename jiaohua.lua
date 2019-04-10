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
    local l,w=wait.regexp("王夫人说道：「庄门口的茶花最近开的不盛，该好好照料一下了，你去找严婆婆，听她安排吧。」$|^(> |)王夫人说道：「我正在美容，你过一会再来吧。」$",5)
	if l==nil then
	   self:ask_job()
	   return
	end
	if string.find(l,"庄门口的茶花最近开的不盛") then
	   local b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	     self:tools()
	   end
	   b:check()
	   return
	end
	if string.find(l,"我正在美容，你过一会再来吧") then
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
	   local l,w=wait.regexp("你向王夫人打听有关『job』的消息。",5)
	   if l==nil then
	     self:ask_job()
	     return
	   end
	   if string.find(l,"你向王夫人打听有关『job』的消息") then
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
     world.Send("ask yan about 工具")
	 wait.make(function()
	   local l,w=wait.regexp("严妈妈交给你一件工具。",5)
	   if l==nil then
	     self:tools()
	     return
	   end
	   if string.find(l,"严妈妈交给你一件工具") then
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
	    local l,w=wait.regexp("^(> |)你被奖励了：$",5)
		if l==nil then
		   self:reward()
		   return
		end
        if string.find(l,"你被奖励") then
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
	 local l,w=wait.regexp("你给严妈妈一把瓢。",5)
	 if l==nil then
	   self:return_tools()
	   return
	 end
	 if string.find(l,"你给严妈妈一把瓢") then
        self:reward()
	    return
	 end
	 wait.time(5)
  end
  w:go(2191)
end

function jiaohua:jiao()
  wait.make(function()
	local l,w=wait.regexp("^(> |)你觉得水已经浇的差不多了，可以回去复命了。|^(> |)你已经干完了，还在这里干吗？想把花浇死呀？",0.8)
	world.Send("jiaoshui")
	if l==nil then
	  self:jiao()
	  return
	end
	if string.find(l,"可以回去复命了") or string.find(l,"你已经干完了，还在这里干吗？想把花浇死呀") then
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
