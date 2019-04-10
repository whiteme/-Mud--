require "map"
require "wait"
fish={
 new=function()
    local fishing={}
    setmetatable(hl,{__index=fish})
	return fishing
  end,
}


local starttime=nil
local fish_count=0

function fish:diaoyu()
   wait.make(function()
      world.Send("diaoyu")
      local l,w=wait.regexp("^(> |)钓鱼是休闲运动，把潜能发掘完再来吧。$|^(> |)只见鱼漂一动，一不小心鱼饵被吃掉了。你将空钩拽了上来。$|^(> |)你突然觉得手中鱼竿一颤，有鱼上钩了！快收线\\\(shouxian\\\)！！$|^(> |)临渊羡鱼，不如退而结网。没有鱼竿，你想怎么个钓法？$|^(> |)地上已经那么多鱼了，不要暴敛天物啊。$",3)
	 if l==nil then
	    self:diaoyu()
		return
	 end
	 if string.find(l,"钓鱼是休闲运动") then
	    world.Send("lian force")
		wait.time(2)
		self:diaoyu()
	    return
	 end
	 if string.find(l,"你将空钩拽了上来") then
	   wait.time(1.6)
	   self:diaoyu()
	   return
	 end
	 if string.find(l,"没有鱼竿") then
	   self:get_yugan()
	   return
	 end
	  if string.find(l,"你突然觉得手中鱼竿一颤，有鱼上钩了") then
	     wait.time(2)
	     self:shouxian()
         return
	  end
	  if string.find(l,"地上已经那么多鱼了，不要暴敛天物啊") then
	     world.Execute("#10 get yu")
		 world.Send("wd")
		 world.Execute("#10 drop yu")
		 world.Send("eu")
		 self:diaoyu()
	     return
	  end
   end)

end

local function convert_seconds(seconds)
    local hours = math.floor(seconds / 3600)
    seconds = seconds - (hours * 3600)
    local minutes = math.floor(seconds / 60)
    seconds = seconds - (minutes * 60)
    return hours, minutes, seconds
end

function fish:sell_gui()
 	   local sp=special_item.new()
       sp.cooldown=function()
           print("cooldown")
		   for _,i in ipairs(sp.equipment_items) do
		      print(i.name,i.id,i.num)
		      if string.find(i.name,"海龟") or string.find(i.name,"熊皮") then
				 local w=walk.new()
                 w.walkover=function()
				   local t=os.time()
				   local interval=os.difftime(t,starttime)
				    local hours,minutes,seconds=convert_seconds(interval)
					print(hours,minutes,seconds)
	                print(interval,":秒")
                   --world.Execute("#10 drop yu")
				  fish_count=fish_count+1
				local ts={
	             task_name="钓鱼",
	             task_stepname="钓鱼",
	             task_step=1,
	             task_maxsteps=1,
	             task_location=" 时间:"..hours..":"..minutes..":"..seconds,
	             task_description="钓乌龟数:"..fish_count,
             	}
	            local st=status_win.new()
	            st:init(nil,nil,ts)
	            st:task_draw_win()

	               world.Execute("sell gui")
				   world.Execute("sell xiong pi")
				   local f=function()
				      self:sell_gui()
				   end
				   f_wait(f,2)
                 end
                 w:go(1332)
		        return
		       end
		   end
		    self:go_fish()
       end
       local equip={}
	   equip=Split("<丢弃>鱼|<丢弃>断掉的鱼竿|<获取>熊皮&10|<保存>黄金&50|<保存>白银&300","|")
       sp:check_items(equip)
end

function fish:find()
      world.Execute("#5 find")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)你找了半天，没发现什么对你有用的东西。$|^(> |)你找到了一把不知道谁放在这里的旧鱼竿。$|^(> |)你身上不是有了鱼竿么！$$|^(> |)什么？$",2)
		if l==nil then
		   self:find()
		   return
		end
		if string.find(l,"没发现什么对你有用的东西") then
		   self:get_yugan()
		   return
		end
		if string.find(l,"旧鱼竿") or string.find(l,"你身上不是有了鱼竿") then
		  wait.time(2)
		  self:go_fish()
		  return
		end
		if string.find(l,"什么") then
		   self:find_yugan()
		   return
		end
	  end)
end

function fish:find_yugan()
   local w=walk.new()
   w.walkover=function()
      world.Execute("#5 find")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)你找了半天，没发现什么对你有用的东西。$|^(> |)你找到了一把不知道谁放在这里的旧鱼竿。$|^(> |)你身上不是有了鱼竿么！$$",2)
		if l==nil then
		   self:find()
		   return
		end
		if string.find(l,"没发现什么对你有用的东西") then
		   self:get_yugan()
		   return
		end
		if string.find(l,"旧鱼竿") or string.find(l,"你身上不是有了鱼竿") then
		  wait.time(2)
		  self:go_fish()
		  return
		end
	  end)
   end
   w:go(2656)
end

  local co=nil
function fish:get_yugan()
   local dx={"wd","wd","wd","n","e","n","enter","out","s","e","s","e","s","w","s","eu";"eu";"eu"}
--老者冲上前去，激动地紧紧握住你的双手，哽咽着说不出话来。
--你身上不是有了鱼竿么！
--你找了半天，没发现什么对你有用的东西。
--你在角落的杂物堆里翻来翻去。
--你找到了一把不知道谁放在这里的旧鱼竿。
   co=coroutine.create(function()
    for _,d in ipairs(dx) do

	 world.Send("ask lao zhe about 鱼竿")
	 world.Send(d)
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)老者冲上前去，激动地紧紧握住你的双手，哽咽着说不出话来。$|^(> |)老者说道：「不是告诉你了吗？自己去找找。」$",0.5)
	   if l==nil then
	      coroutine.resume(co)
	      return
	   end
	   if string.find(l,"老者冲上前去") or string.find(l,"自己去找找") then
	      wait.time(2)
	      self:find_yugan()
	      return
	   end
	 end)
	 coroutine.yield()
    end
	self:get_yugan()
  end)
  coroutine.resume(co)
end

function fish:go_fish()
   local w=walk.new()
   w.walkover=function()
      fish:diaoyu()
   end
  -- w:go(2654)
  w:go(5205)
end

function fish:shouxian()
   wait.make(function()
      world.Send("shouxian")
      local l,w=wait.regexp("^(> |)别急，慢慢来。$|^(> |)你用力过猛，鱼竿啪的一声断了。$|^(> |)趁你提鱼竿的工夫，一条鱼从你手边又蹦进了水里。$|^(> |)不甩竿就想收线？有个性！$|^(> |)你的鱼竿呢？$|^(> |)你熟练地将一条鱼慢慢拽了上来。$",3)
	  if l==nil then
	     self:shouxian()
	     return
	  end
      if string.find(l,"别急，慢慢来") then
	    wait.time(1)
	    self:shouxian()
	    return
	  end
	  if string.find(l,"不甩竿就想收线") then
	     self:diaoyu()
	     return
	  end
	  if string.find(l,"断了") or string.find(l,"你的鱼竿呢") then
	     wait.time(1.5)
	     world.Send("drop duan yugan")
		 self:get_yugan()
	     return
	  end
	  if string.find(l,"趁你提鱼竿的工夫，一条鱼从你手边又蹦进了水里") then
	     self:diaoyu()
	     return
	  end
	  if string.find(l,"你熟练地将一条鱼慢慢拽了上来") then
		wait.time(1)
	    self:sell_gui()
	    return
	  end
   end)
end

--find 不甩竿就想收线？有个性！
function fish:go()
   starttime=os.time()
   fish_count=0
  local w=walk.new()
   w.walkover=function()
    self:get_yugan()
  end
 -- w:go(2654)
  w:go(5205)
end
--[[
你将鱼饵穿在钩上，一抖手中的鱼竿，将线甩了出去。
你突然觉得手中鱼竿一颤，有鱼上钩了！快收线(shouxian)！！
> 正气将鱼饵穿在钩上，一抖手中的鱼竿，将线甩了出去。
shouxian
别急，慢慢来。
>
shouxian
你用力过猛，鱼竿啪的一声断了。--]]
--2656
