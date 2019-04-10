kanchai={
  new=function()

    local kc={}
	 setmetatable(kc,kanchai)
	 return kc
  end,

}
kanchai.__index=kanchai

function kanchai:ask_lu()
  local w=walk.new()
  w.walkover=function()
    world.Send("ask lu about 砍柴")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)陆大有说道：「伙房的仆人来说，他那里现在缺柴禾做饭，你去朝阳峰砍些吧。」$|^(> |)陆大有说道：「我现在很忙，你一会再来吧。」$",2)
	  if l==nil then
	     self:ask_lu()
	     return
	  end
	  if string.find(l,"我现在很忙") then
	     local b=busy.new()
		 b.Next=function()
	       self.fail(102)
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"你去朝阳峰砍些吧") then
	    local b=busy.new()
		b.Next=function()
	    self:chaoyangfeng()
		end
		b:check()
	    return
	  end
	end)

  end
  w:go(1525)
end

function kanchai:chaoyangfeng()
 	 local sp=special_item.new()
		 sp.cooldown=function()
		     world.Send("wield chai dao")
			   local w=walk.new()
				w.walkover=function()
                   self:kan()
                end
                w:go(1511)
		 end
		 sp:unwield_all()

end

function kanchai:fail(id)

end

function kanchai:kan()
  world.Send("kan 柴")
 wait.make(function()
   local l,w=wait.regexp("^(> |)你把地上的柴禾捆成一捆，看来该回去了。$|^(> |)回去通知仆人来取柴禾吧。$",1)
   if l==nil then
      self:kan()
      return
   end
   if string.find(l,"看来该回去了") or string.find(l,"通知仆人来取柴禾吧") then
      self:reward()
      return
   end

 end)

end

function kanchai:jobDone()
end

function kanchai:reward()
  local w=walk.new()
  w.walkover=function()
     world.Send("unwield chai dao")
     world.Send("askk pu ren about 柴禾")
    local b=busy.new()
	b.Next=function()
	   self:jobDone()
	end
	b:check()
  end
  w:go(1528)
end
