require "hp"
huxi={
   new=function()
     local hx={}
	 setmetatable(hx,{__index=huxi})
	 return hx
   end,
   wuxing="",
   cycle=false,
}

function huxi:sleep()
  local _rest=rest.new()
   _rest.failure=function(id)
	    w:go(2248)
   end
	 _rest.wake=function(flag)
		self:start()
	 end
  local w=walk.new()
  local al=alias.new()
  al.lianwuchang_guangchang=function()
   world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate()
	  print("当前房间号",roomno[1])
	 if roomno[1]==2240 then
	    al:finish()
	 elseif roomno[1]==2171 then
        --npc block
		local f
		f=function()
		  al:lianwuchang_guangchang()
		end
		f_wait(f,3)
	 else
        local w
		w=walk.new()
		w.walkover=function()
		   al:lianwuchang_guangchang()
		end
		w:go(2171)
	 end
   end
   _R:CatchStart()
  end
  w.user_alias=al
  w.walkover=function()
	 _rest:sleep()
  end
  w:go(2248)
end

function huxi:start()
  local w=walk.new()
  --[[local al=alias.new()
  al.qianting_shilu=function()
    world.Send("south")
    local _R
    _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate()
	  print("当前房间号",roomno[1])
	 if roomno[1]==2220 then
	    al:finish()
	 elseif roomno[1]==2219 then
	    local f=function()
          al:qianting_shilu()
		end
		f_wait(f,3)
	 else
        local w
		w=walk.new()
		w.walkover=function()
		  al:qianting_shilu()
		end
		w:go(2219)
	 end
   end
   _R:CatchStart()
  end
  w.user_alias=al]]
  w.walkover=function()
     world.Send("wo stone")
     self:huxi()
  end
  w:go(2761)
end

function huxi:eat_drink()
   local w=walk.new()
   w.walkover=function()
       local b1=busy.new()
	   b1.Next=function()
         world.Send("ask xiao about 茶")
		 local b2=busy.new()
		 b2.Next=function()
			world.Execute("get tang;drink tang;drink tang;drink tang;drop tang")
			world.Send("ask xiao about 食物")
			local b=busy.new()
	        b.Next=function()
			  world.Execute("get zong zi;eat zong zi;eat zong zi;eat zong zi;drop zong zi")
	          self:start()
	        end
	        b:check()
		 end
		 b2:check()
	   end
	   b1:check()
   end
   w:go(2247)
end

function huxi:yunqi()
  world.Send("yun qi")
  wait.make(function()
    local l,w=wait.regexp("^(> |)你现在气力充沛。$|^(> |)你深深吸了几口气，脸色看起来好多了。$",5)

	if l==nil then
	   self:yunqi()
	   return
	end
	if string.find(l,"气力充沛") or string.find(l,"脸色看起来好多了")  then
	    wait.time(1)
	   self:huxi(false)
	   return
	end
  end)
end

function huxi:yunjing()
  world.Send("yun jing")
  wait.make(function()
    local l,w=wait.regexp("^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你现在精神饱满。$",5)
	if l==nil then
	   self:yunjing()
	  return
	end
	if string.find(l,"精神看起来好多了") or string.find(l,"你现在精神饱满") then
       wait.time(1)
	   self:huxi(false)
	   return
	end
  end)
end

function huxi:huxi(flag)
  if self.wuxing~="" then
     world.Execute(self.wuxing)
  end
  if flag~=false then
    world.Send("huxi")
  end
  local h=hp.new()
  h.checkover=function()
     if tonumber(h.food)<40 or tonumber(h.drink)<40 then
	    self:eat_drink()
     elseif tonumber(h.jingxue)>30 and tonumber(h.qi)>30 then
	   local f=function()
	    self:huxi()
	   end
	   f_wait(f,1)
	 elseif tonumber(h.neili)<50 then
	   self:sleep()
	 elseif tonumber(h.jingxue)<=30 then
	   self:yunjing()
	 elseif tonumber(h.qi)<=30 then
	    self:yunqi()
	 else
	   local b=busy.new()
	   b.Next=function()
	     self:sleep()
	   end
	   b:check()
	 end
  end
  h:check()
end


