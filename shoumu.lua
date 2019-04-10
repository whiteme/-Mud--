require "map"
require "wait"
require "cond"
require "hp"
require "heal"
require "sj_mini_win"
shoumu={
  new=function()
     local sm={}
	 setmetatable(sm,{__index=shoumu})
	 return sm
  end,
}
--u;out;e;smok  n;n;n;n;n;w;w;n;n;give rong all
function shoumu:get_time()
  wait.make(function()
      world.Send("time")
	  local l,w=wait.regexp("^(> |)现在是书剑(.*)年(.*)月(.*)日(.*)时(.*)。$",15)
	  if l==nil then
	    print("超时:")--酉
	    self:get_time()
		return
	  end
	  if string.find(l,"现在是书剑") then
	    print(w[2],w[3],w[4],w[5],w[6])
	    local hour=w[5]
	    print(hour)
	    local mins=w[6]
	     print(mins)
	    if hour=="子" or hour=="酉" or hour=="戌" or hour=="亥" or hour=="申" or hour=="丑" or hour=="寅" or hour=="卯" or hour=="辰" then
	      print("晚上")
	      self:Status_Check()
	    else
	      print("白天")
	      self.fail(201)
	    end
        return
	  end
	  wait.time(15)
   end)
end

function shoumu:out_mudi()
   world.Execute("up;out;east")
end

function shoumu:combat()
end

function shoumu:entry_mudi()
 wait.make(function()
	world.Send("guibai mubei")
	world.Send("push mubei left")
	world.Send("push mubei left")
	world.Send("push mubei left")
	world.Send("push mubei right")
	world.Send("push mubei right")
	world.Send("push mubei right")

   local l,w=wait.regexp("^(> |)墓碑缓缓移开，露出一条石砌的地道。你赶忙走了进去。$",5)
   if l==nil then
      self:entry_mudi()
	  return

   end
   if string.find(l,"墓碑缓缓移开，露出一条石砌的地道") then
     world.Send("down")
	 self:mudi()
     return
   end
   wait.time(5)
 end)
end


function shoumu:graveyard()
  wait.make(function()
    local l,w=wait.regexp("^(> |)突然，从.*的桃花阵中闯出一个盗墓贼，钻进石坟就不见了。$",5)
	if l==nil then
	   self:graveyard()
	   return
	end
	if string.find(l,"钻进石坟就不见了") then
	   self:entry_mudi()
	   return
	end
	wait.time(5)
  end)
end

function shoumu:shimu()
  local b=busy.new()
   b.interval=0.5
   b.Next=function()
     wait.make(function()
	  world.Send("ask huang rong about 师母")
	   local l,w=wait.regexp("^(> |)你向黄蓉打听有关『师母』的消息。$",10)
	  if l==nil then
	     self:ask_job()
		 return
	  end
	   if string.find(l,"你向黄蓉打听有关") then
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
	       self:ask_job()
		 end
		 b:check()
		 return
	   end
	    wait.time(10)
	  end)
   end
  b:check()
end

function shoumu:fail(id)
end
--[[
你长长地舒了一口气。
> 你向黄蓉打听有关『守墓』的消息。
halt
set busy
黄蓉说道：「难得你有这份心意，但是我母亲的墓不是随便就能进去的。」
> 你现在很忙，停不下来。
> 设定环境变量：busy = "YES"
>
halt
set busy
你现在不忙。
ask huang rong about 师母
> 设定环境变量：busy = "YES"
> 你向黄蓉打听有关『师母』的消息。
halt
set busy
黄蓉叹了口气，说道: 我母亲绝顶聪明，可惜她英年早逝，我爹爹将她葬在桃花岛上的一座墓里。
> 你现在很忙，停不下来。
> 设定环境变量：busy = "YES"
>
halt
set busy
你现在很忙，停不下来。
> 设定环境变量：busy = "YES"
>
halt
set busy
你现在不忙。
ask huang rong about 守墓
> 设定环境变量：busy = "YES"
> 你向黄蓉打听有关『守墓』的消息。
黄蓉说道：「你要小心点，我母亲的墓可不是一般人都能进去的。」
黄蓉想了想，说道: 这样吧,我带你去!
你紧跟着黄蓉，左一转，右一转，不一会就到了墓前。]]
function shoumu:catch_place()
  wait.make(function()
   local l,w=wait.regexp("^(> |)黄蓉疑惑的看着你,说道: 现在大白天的，守什么墓呀\\?$|^(> |)你紧跟着黄蓉，左一转，右一转，不一会就到了墓前。$|^(> |)黄蓉说道：「你刚刚做好守墓任务，还是先休息一会吧。」$|^(> |)黄蓉说道：「已经有人去守墓了，你下次再去吧！」$|^(> |)设定环境变量：ask \\= \\\"YES\\\"$|^(> |)黄蓉说道：「对不起，现在这里没有什么可以给你做的。」$",5)
       if l==nil then
	     self:catch_place()
	     return
      end
      if string.find(l,"你紧跟着黄蓉，左一转，右一转，不一会就到了墓前") then
	     self:graveyard()
	     --self:shimu()
		 return
	  end
	  if string.find(l,"黄蓉疑惑的看着你") then
	     print("bai tian")
	     self.fail(201)
		 return
	  end
	  if string.find(l,"你刚刚做好守墓任务，还是先休息一会吧") then
	     self.fail(101)
	     return
	  end
	  if string.find(l,"已经有人去守墓了，你下次再去吧") then
	     self.fail(103)
		 return
	  end
	  if string.find(l,"现在这里没有什么可以给你做的") then
	     self.fail(102)
	     return
	  end
	  if string.find(l,"设定环境变量：ask") then
	    self:shimu()
		return
	  end
	  wait.time(5)
  end)
end

function shoumu:ask_job()
	 	local ts={
	           task_name="桃花岛守墓",
	           task_stepname="询问黄蓉",
	           task_step=2,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

  local w
  w=walk.new()
  w.walkover=function()

	wait.make(function()
	  world.Send("ask huang rong about 守墓")--黄蓉疑惑的看着你,说道: 现在大白天的，守什么墓呀?
	  world.Send("set ask")
      local l,w=wait.regexp("^(> |)你向黄蓉打听有关『守墓』的消息。$",5)
	  if l==nil then
	     self:ask_job()
		 return
	  end
	  if string.find(l,"你向黄蓉打听有关") then
	    self:catch_place()
	    return
	  end
	  wait.time(5)
	end)
  end
  w:go(2803)

end

function shoumu:zei_die()
end

function shoumu:wait_zei_die()
   wait.make(function()
     local l,w=wait.regexp("^(> |)盗墓贼「啪」的一声倒在地上，挣扎着抽动了几下就死了。$",5)
	 if l==nil then
	    self:wait_zei_die()
	    return
	 end
	 if string.find(l,"挣扎着抽动了几下就死了") then
        self:zei_die()
	    return
	 end
	 wait.time(5)
   end)
end

function shoumu:killzei()
  wait.make(function()
     world.Send("look zei")
	 local l,w=wait.regexp("^(> |)盗墓贼\\(Daomu zei\\)$|^(> |)你要看什么？$",5)
	 if l==nil then
	   self:killzei()
	   return
	 end
     if string.find(l,"盗墓贼") then
	   world.Send("kill zei")
	   self:wait_zei_die()
	   self:combat()
	   return
	 end
	 if string.find(l,"你要看什么") then
	   local f=function()
	     print("没有成功！")
	     self:mudi()
	   end
	   f_wait(f,0.8)
	   return
	 end
	 wait.time(5)
  end)
end

function shoumu:mudi()
--[[^{> 现|现}在是*年*月*日辰时
(su;se;down;s;su;d;kill zei)
^{> 现|现}在是*年*月*日丑时
(nu;nw;down;n;nu;down;kill zei)
^{> 现|现}在是*年*月*日亥时
(sd;s;down;sw;sd;down;kill zei)
^{> 现|现}在是*年*月*日卯时
(e;ne;down;se;e;down;kill zei)
^{> 现|现}在是*年*月*日申时
(nd;n;down;ne;nd;down;kill zei)
^{> 现|现}在是*年*月*日巳时
(sd;s;down;sw;sd;down;kill zei)
^{> 现|现}在是*年*月*日未时
(nu;nw;down;n;nu;down;kill zei)
^{> 现|现}在是*年*月*日午时
(w;sw;down;nw;w;down;kill zei)
^{> 现|现}在是*年*月*日戌时
(su;se;down;s;su;down;kill zei)
^{> 现|现}在是*年*月*日寅时
(nd;n;down;ne;nd;down;kill zei)
^{> 现|现}在是*年*月*日酉时
(e;ne;down;se;e;down;kill zei)
^{> 现|现}在是*年*月*日子时
(w;sw;down;nw;w;down;kill zei)]]
wait.make(function()
  world.Send("time")
	  local l,w=wait.regexp("^(> |)现在是书剑(.*)年(.*)月(.*)日(.*)时(.*)。$",15)
	  if l==nil then
	    print("超时:")--酉
	    self:mudi()
		return
	  end
	  if string.find(l,"现在是书剑") then
	  local path
	  print(w[2],w[3],w[4],w[5],w[6])
	  local hour=w[5]
	  print(hour)
	  local mins=w[6]
	  print(mins)
	if hour=="辰" then
	  path="su;se;d;s;su;d"
	elseif hour=="丑" then
	   path="nu;nw;d;n;nu;d"
	elseif hour=="亥" then
	  path="sd;s;down;sw;sd;down"
	elseif hour=="卯" then
	  path="e;ne;down;se;e;down"
	elseif hour=="申" then
	  path="nd;n;down;ne;nd;down"
	elseif hour=="巳" then
	  path="sd;s;down;sw;sd;down"
	elseif hour=="未" then
	  path="nu;nw;down;n;nu;down"
	elseif hour=="午" then
	  path="w;sw;down;nw;w;down"
	elseif hour=="戌" then
	  path="su;se;down;s;su;down"
	elseif hour=="寅" then
	  path="nd;n;down;ne;nd;down"
	elseif hour=="酉" then
	  path="e;ne;down;se;e;down"
	elseif hour=="子" then
	  path="w;sw;down;nw;w;down"
	end
	   print(path)
	   world.Execute(path)
	   self:killzei()
	   return
	end
	  wait.time(15)
   end)
end

function shoumu:mudi1()
  wait.make(function()
      world.Send("time")
	  local l,w=wait.regexp("^(> |)现在是书剑(.*)年(.*)月(.*)日(.*)时(.*)。$",15)
	  if l==nil then
	    print("超时:")--酉
	    self:mudi1()
		return
	  end
	  if string.find(l,"现在是书剑") then
	  local path
	  print(w[2],w[3],w[4],w[5],w[6])
	  local hour=w[5]
	  print(hour)
	  local mins=w[6]
	  print(mins)
	  if (hour=="巳" or hour=="亥") and (mins=="二刻" or mins=="三刻") then
	  --^??现在是*年*月*日{巳|亥}时{二刻|三刻}。
      --sm12;kick daomu zei
        path="sw;d;sw;d;sd;d"
      elseif (hour=="巳" or hour=="亥") and (mins=="正" or mins=="一刻") then
      --^??现在是*年*月*日{巳|亥}时{正|一刻}。
      --sm11;kick daomu zei
		path="sd;d;sd;d;s;d"
      elseif (hour=="辰" or hour=="戌") and (mins=="二刻" or mins=="三刻") then
      --^??现在是*年*月*日{辰|戌}时{二刻|三刻}。
      --sm10;kick daomu zei
        path= "s;su;d;s;su;d"--{} "s;d;s;d;su;d"
      elseif (hour=="辰" or hour=="戌") and (mins=="正" or mins=="一刻") then
       --^??现在是*年*月*日{辰|戌}时{正|一刻}。
       --sm09;kick daomu zei
        path="su;se;d;su;se;d" --{"su;d;su;d;se;d"}
	  elseif (hour=="卯" or hour=="酉") and (mins=="二刻" or mins=="三刻") then
        --^??现在是*年*月*日{卯|酉}时{二刻|三刻}。
        --sm08;kick daomu zei
       path="se;e;d;se;e;d" --{"se;d;se;d;e;d"}
      elseif (hour=="卯" or hour=="酉") and (mins=="正" or mins=="一刻") then
	    --^??现在是*年*月*日{卯|酉}时{正|一刻}。
        --sm07;kick daomu zei
       path="e;ne;d;e;ne;d" --{"e;d;e;d;ne;d"}
	  elseif (hour=="寅" or hour=="申") and (mins=="二刻" or mins=="三刻") then
        --^??现在是*年*月*日{寅|申}时{二刻|三刻}。
        --sm06;kick daomu zei
       path="ne;d;ne;d;nd;d"
      elseif (hour=="寅" or hour=="申") and (mins=="正" or mins=="一刻") then
        --^??现在是*年*月*日{寅|申}时{正|一刻}。
        --sm05;kick daomu zei
       path="nd;n;d;nd;n;d" --{"nd;d;nd;d;n;d"}
	  elseif (hour=="丑" or hour=="未") and (mins=="二刻" or mins=="三刻") then
        --^??现在是*年*月*日{丑|未}时{二刻|三刻}。
        --sm04;kick daomu zei
       path="n;d;n;d;nu;d"
	  elseif (hour=="丑" or hour=="未") and (mins=="正" or mins=="一刻") then
        --^??现在是*年*月*日{丑|未}时{正|一刻}。
        --sm03;kick daomu zei
       path="nu;nw;d;nu;nw;d" --{"nu;d;nu;d;nw;d"}
      elseif (hour=="子" or hour=="午") and (mins=="二刻" or mins=="三刻") then
        --^??现在是*年*月*日{子|午}时{二刻|三刻}。
        --sm02;kick daomu zei w;sw;down;nw;w;down;kill zei)  {nw;d;nw;d;w;d}?
         path="nw;d;nw;d;w;d"
       elseif (hour=="子" or hour=="午") and (mins=="正" or mins=="一刻") then
	    --^??现在是*年*月*日{子|午}时{正|一刻}。
        --sm01;kick daomu zei
       path="w;d;w;d;sw;d"
	  end
	   print(path)
	   world.Execute(path)
	   self:killzei()
	   return
	  end
	  wait.time(15)
   end)
end

function shoumu:eat()
    local w=walk.new()
	w.walkover=function()
	      world.Execute("buy baozi")
		  world.Execute("eat baozi;eat baozi;eat baozi;drop baozi")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
	end
	w:go(976) --春在楼 976
end

function shoumu:drink()
     local w=walk.new()
	   w.walkover=function()
	      world.Execute("buy jiudai")
		  world.Execute("drink jiudai;drink jiudai;drink jiudai;drink jiudai;drink jiudai;drop jiudai")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
		end
		w:go(976) --春在楼 976
end
function shoumu:full()
  	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
		   if h.food<50 then
			    self:eat()
			 elseif h.drink<50 then
			    self:drink()
			 end

		elseif h.jingxue_percent<=80 then
		   --│星宿掌毒        五分                     毒 │
		   --可能中毒了
			  print("疗伤")
              local rc=heal.new()
			  rc.saferoom=505
			  rc.heal_ok=function()
			     self:Status_Check()
			  end
			  rc:liaoshang()
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()

		elseif h.neili<(h.max_neili*2-200) then
		    local x
			x=xiulian.new()
			x.safe_qi=300
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun regenerate")
				  world.Send("yun recover")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
			    end
	           if id==202 then
			   --最近房间
				   local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(2801)
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   if h.neili>h.max_neili*2-200 then
			     world.Send("yun recover")
			     self:ask_job()
			   else
	             print("继续修炼")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()
		elseif h.pot>h.max_pot-20 then
			self:jobDone()
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

function shoumu:Status_Check()


	 	local ts={
	           task_name="桃花岛守墓",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --初始化
	 	local cd=cond.new()
		cd.over=function()
	          print("检查状态")
		     if table.getn(cd.lists)>0 then
		       local sec=0
		       for _,i in ipairs(cd.lists) do
			     if i[1]=="星宿掌毒" then
				   print("中毒了")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
			          self:Status_Check()
			        end
			        rc:qudu()
				    return
			     end
				 if i[1]=="内伤" or i[1]=="七伤拳内伤" then
				    print("内伤")
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

function shoumu:gem()
  world.Send("get all from corpse")

  wait.make(function()
      local l,w=wait.regexp("^(> |)你从盗墓贼的尸体身上搜出一.*。$",5)
	 if l==nil then
	    self:gem()
		return
	 end
	 if string.find(l,"你从盗墓贼的尸体身上搜出") then
	    world.Send("drop cloth")
       self:reward()
	   return
     end
    wait.time(5)
  end)
end


function shoumu:reward()
	 	local ts={
	           task_name="桃花岛守墓",
	           task_stepname="奖励",
	           task_step=3,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
 local w
  w=walk.new()
  w.walkover=function()
	wait.make(function()
	  world.Send("give all to huang rong")
      local l,w=wait.regexp("^(> |)你给黄蓉一.*。$",5)--你给黄蓉一块美玉。
	  if l==nil then
	     self:reward()
		 return
	  end
	  if string.find(l,"你给黄蓉") then
	     self:jobDone()
		 return
	  end

	end)
  end
  w:go(2803)

end

function shoumu:jobDone()  --回调函数
end
