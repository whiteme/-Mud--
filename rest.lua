rest={
  new=function()
     local r={}
	 setmetatable(r,{__index=rest})
	 return r
 end,
}

function rest:wake(status) --回调函数

end

function rest:failure(id) -- 回调函数

end

function rest:sleeping()
   wait.make(function()
    local l,w=wait.regexp("^(> |)你一觉醒来，由于睡得太频繁，精神不是很好。$|^(> |)你一觉醒来，觉得精力充沛，该活动一下了。$|^(> |)这里不是你能睡的地方！$",5)
	if l==nil then
	   self:sleeping()
	   return
	end
	if string.find(l,"由于睡得太频繁，精神不是很好") then
	   self:wake(0)
	   return
	end
	if string.find(l,"觉得精力充沛，该活动一下了") then
	   self:wake(1)
	   return
	end
	wait.time(5)
  end)
end

function rest:sleep()
   wait.make(function()
    world.Send("sleep")
	--不一会儿，你就进入了梦乡。
	local l,w=wait.regexp("^(> |)不一会儿，你就进入了梦乡。$|^(> |)这里不是你能睡的地方！$",5)
	if l==nil then
	   self:sleep()
	   return
	end
	if string.find(l,"不一会儿，你就进入了梦乡") then
	   self:sleeping()
	   return
	end
	if string.find(l,"这里不是你能睡的地方") then
	  self.failure(101)
	  return
	end
	wait.time(5)
   end)
end

function rest:wash_over() --回调函数

end

function rest:wait_wash()
  wait.make(function()
     local l,w=wait.regexp("^(> |)你精神抖擞的从浴池中走了出来！$",20)

	 if l==nil then
	    print("超时!1")
		local gender=world.GetVariable("gender")
	   world.Send("wear all")
	   if gender=="男性" then
	      world.Send("e")
	   else
	      world.Send("w")
	   end
	     self:wash_over()
	     return
	 end
	 if string.find(l,"你精神抖擞的从浴池中走了出来") then
	   local b=busy.new()
	   b.Next=function()
	   local gender=world.GetVariable("gender")
	   world.Send("wear all")
	   if gender=="男性" then
	      world.Send("e")
	   else
	      world.Send("w")
	   end
	     self:wash_over()
	  end
	  b:check()
	    return
	 end
  end)
end

function rest:wash()
   local w=walk.new()
   w.walkover=function()
       local gender=world.GetVariable("gender")
	  -- world.Send("show card")
	   world.Send("give 1 gold to yahuan")
	   wait.make(function()
	      local l,w=wait.regexp("^(> |)你拿出一锭黄金\\(Gold\\)给小丫环。$|^(> |)你身上没有这样东西。$",5)
		  if l==nil then
		     self:wash()
		     return
		  end
		  if string.find(l,"你身上没有这样东西") then
			local f=function()
			 self:wash()
		    end
		    qu_gold(f,10,50)
		     return
		  end
		  if string.find(l,"给小丫环") then
		     if gender=="男性" then
	             world.Send("w")
	          else
	             world.Send("e")
	         end
			local sp=special_item.new()
		    sp.cooldown=function()
		      world.Send("remove all")
	          world.Send("wash")
	          self:wait_wash()
		    end
		    sp:unwield_all()


		     return
		  end

	   end)

   end
   w:go(939)
end
