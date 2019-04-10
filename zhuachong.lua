
zhuachong={
  new=function()
     local zc={}
	 setmetatable(zc,{__index=zhuachong})
	 return zc
  end,
  co=nil,
  zhizhu_num=0,
  shachong_num=0,
  wugong_num=0,
  xiezi_num=0,
  neili_upper=1.5,
  liandu="",

}
--[[
1.捉虫

先去找老仙，ask ding about 毒虫谷，就可以开始做抓虫子的任务了。
接着(s;sd;ne;order remove)等门打开，进入虫谷，开始抓虫子。 别忘了带liu huang和tan zi，fire， 这两样东西在伊犁城买买提处可以买到 。
进去后先burn liuhuang，有虫子的提示后dai chongzi，要是 出现了虫子，就kill du chong打到它不动了。get(zhizhu,xiezi,shachong,wugong),zhuang xxx in tanzi 在里面会有类似killer的敌人来杀你，要小心，不过不算太厉害。
每进去一次可以抓几个虫子。看各人的本事了！ 一个虫子算一次 bai ding次数
抓完虫子出来yell open,给看守你抓的虫子(xian xxx)

2.熬药

在毒虫谷中捉虫时，要(zhizhu,xiezi,shachong,wugong)四样毒虫都捉一个，然后到星宿药房，
fang water in guo; fang (zhizhu,xiezi,shachong,wugong) in guo;ao yao

一包花花绿绿的四虫膏，来尝尝(chang)味道？ 好象是星宿派的浩然子从药庐熬出来的！

chang gao;要加基本内功，exp，pot。（不过都cut了），有兴趣的可以去试。

找了好久，终于看见了一个介绍捉虫job的，不知道的都来看看吧

]]

function zhuachong:equipments()
	   local sp=special_item.new()
       sp.cooldown=function()
           self:ask_job()
       end
       local equip={}
	   equip=Split("<获取>火折|<获取>硫磺|<获取>坛子&4","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

function zhuachong:xian_bugs()
   wait.make(function()
     --你毕恭毕敬地将深蓝色短蜘蛛拿出，双手捧上，想要献给看守。
	 local l,w=wait.regexp("^(> |)你毕恭毕敬地将.*拿出，双手捧上，想要献给看守。$|^(> |)设定环境变量：action \\= \\\"贡献\\\"$|^(> |)什么？$",10)
	 if l==nil then
	    self:xian()
		return
	 end
	 if string.find(l,"你毕恭毕敬地将") then
	     wait.time(2)
		 local b=busy.new()
		 b.Next=function()

		   world.Execute("xian wugong;xian xiezi;xian shachong;xian zhizhu;set action 贡献")
		   self:xian_bugs()
		 end
		 b:check()

	    return
	 end
	 if string.find(l,"设定环境变量") then
	    print("job 结束!!")
	    self:jobDone()
		return
	 end
	 if string.find(l,"什么") then
	    self:xian()
	    return
	 end
   end)
end

function zhuachong:xian()
  local w=walk.new()
  w.walkover=function()
     world.Execute("zhuang wugong in tanzi 4;zhuang xiezi in tanzi 3;zhuang shachong in tanzi 2;zhuang zhizhu in tanzi")
	 world.Execute("xian wugong;xian xiezi;xian shachong;xian zhizhu;set action 贡献")
     self:xian_bugs()
  end
  w:go(2368)
end

function zhuachong:flee()
   world.Send("fu wan")
end

function zhuachong:changgao()
   world.Send("chang gao")
   wait.make(function()
      local l,w=wait.regexp("^(> |)你端起四虫膏啊呜一口的吃了下去。$",5)
	  if l==nil then
		  self:checkbugs()
		  return
	  end
	  if string.find(l,"你端起四虫膏啊呜一口的吃了下去") then
	          local b=busy.new()
			  b.interval=0.8
			  b.Next=function()
	             self:checkbugs()
			  end
			  b:check()
	     return
	  end
   end)

end

function zhuachong:aoyao()
         local w=walk.new()
          w.walkover=function()
		      world.Send("")
              world.Send("fang water in guo")
	          world.Execute("fang zhizhu in guo")
			  world.Execute("fang xiezi in guo")
	          world.Execute("fang shachong in guo")
	          world.Execute("fang wugong in guo")
	          world.Send("ao yao")
			  local b=busy.new()
			  b.interval=0.8
			  b.Next=function()
			     self:changgao()
			  end
			  b:check()
			  --self:aoyao()
          end
          w:go(4035)
end

function zhuachong:bugs()
   wait.make(function()
   --你要看什么？
      local l,w=wait.regexp("^(> |)你要看什么？$|^(> |)设定环境变量：action \\= \\\"检查\\\"$",5)
	  if l==nil then
	     self:bugs()
	     return
	  end
	  if string.find(l,"你要看什么") then
	      print("缺配方")
		  self:xian()
		  --self:jobDone()
	     return
	  end
	  if string.find(l,"设定环境变量：action") then
	     self:aoyao()
		 return
	  end
   end)
end

function zhuachong:checkbugs()
	local ts={
	           task_name="星宿抓虫",
	           task_stepname="熬药",
	           task_step=4,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	print("蜘蛛",self.zhizhu_num)
	world.Send("l tanzi")
	print("蝎子",self.xiezi_num)
	world.Send("l tanzi 2")
	print("沙虫",self.shachong_num)
	world.Send("l tanzi 3")
	print("蜈蚣",self.wugong_num)
	world.Send("l tanzi 4")
 --[[if bugid=="zhizhu" then
      seq=""
   elseif bugid=="shachong" then
      seq=" 2"
   elseif bugid=="xiezi" then
      seq=" 3"
   elseif bugid=="wugong" then
      seq=" 4"
   end]]
	world.Execute("get wugong from tanzi 4;get xiezi from tanzi 3;get shachong from tanzi 2;get zhizhu from tanzi")

	world.Execute("l xiezi;l wugong;l shachong;l zhizhu;set action 检查")
	self:bugs()

	--else
	--   self:xian()
	--end
end
--你的眼前一亮，原来是一只黄色长蜈蚣全身闪光，头上凸起，与寻常毒虫大大不同。
--乐徐「啪」的一声倒在地上，挣扎着抽动了几下就死了。
--这里的虫子似乎已经被其他人抓光了，你只好去其他地方试一试了。
--你还没有把虫子引出来。
function zhuachong:ask_job()
	local ts={
	           task_name="星宿抓虫",
	           task_stepname="询问老仙",
	           task_step=2,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask ding about 毒虫谷")
    local l,w=wait.regexp("^(> |)丁春秋痛快地对你说道：好吧！$|^(> |)丁春秋说道：「你刚抓完虫子，还是去休息会吧。」$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"你刚抓完虫子，还是去休息会吧") then
	  local b=busy.new()
	  b.Next=function()
		 self:chonggu()
	  end
	  b:check()

	   return
	end
	if string.find(l,"丁春秋痛快地对你说道") then
	  local b=busy.new()
	  b.Next=function()
		 self:chonggu()
	  end
	  b:check()

	  return
	end
	wait.time(5)
   end)
  end
  w:go(1969)
end
--粉红色小蜈蚣从坛子里钻了出来，爬到地上，你想抓的时候已经不见了。
function zhuachong:get_chongzi(bugid,bugname)
   bugid=string.lower(bugid)
   world.Send("yun refresh")
   world.Send("get "..bugid)
   local seq=""
   if bugid=="zhizhu" then
      seq=""
   elseif bugid=="shachong" then
      seq=" 2"
   elseif bugid=="xiezi" then
      seq=" 3"
   elseif bugid=="wugong" then
      seq=" 4"
   end
   world.Send("zhuang "..bugid.." in tanzi"..seq)

   if bugid=="zhizhu" then
      self.zhizhu_num=self.zhizhu_num+1
   end
	if bugid=="xiezi" then
      self.xiezi_num=self.xiezi_num+1
   end
   	if bugid=="shachong" then
      self.shachong_num=self.shachong_num+1
   end
   	if bugid=="wugong" then
      self.wugong_num=self.wugong_num+1
   end
   local b=busy.new()
   b.Next=function()
      self:dai()
   end
   b:check()
end
--绿色沙虫缩成一团，不再动了。

function zhuachong:chongzi_die(bugname,bugid)
  print(bugname,bugid)
  wait.make(function()
    local l,w=wait.regexp("^(> |)"..bugname.."缩成一团，不再动了。$|^(> |)看清楚一点，那并不是活物。$|^(> |)这里没有这个人。$",10)
	if l==nil then
	   world.Send("kill "..bugid)
	   self:chongzi_die(bugname,bugid)
	   return
	end
	if string.find(l,"缩成一团，不再动了") or string.find(l,"看清楚一点，那并不是活物") or string.find(l,"这里没有这个人") then
	  self:get_chongzi(bugid,bugname)
      return
	end
  end)
end

function zhuachong:chongzi(bugid,bugname)
  --print(bugname,bugid)
  bugid=string.lower(bugid)
  wait.make(function()
    world.Send("kill "..bugid)
    local l,w=wait.regexp("^(> |)看起来"..bugname.."想杀死你！|^(> |)看清楚一点，那并不是活物。$|^(> |)这里没有这个人。$",10)
	if l==nil then
	   self:chongzi(bugid,bugname)
	   return
	end
	if string.find(l,"这里没有这个人") then
	   self:cbug()
	   return
	end
	if string.find(l,bugname) then
	   self:chongzi_die(bugname,bugid)
	   return
	end
	if string.find(l,"看清楚一点，那并不是活物") then
	    self:get_chongzi(bugid,bugname)
        return
	end
  end)
end

function zhuachong:dai()
   world.Send("dai chongzi")
   wait.make(function()
       local l,w=wait.regexp("^(> |)你的眼前一亮，原来是一只(.*)全身闪光，头上凸起，与寻常毒虫大大不同。$|^(> |)你现在正忙着呢！没法静下心来抓虫子！$|^(> |)虫子被你一吓，钻入草丛不见了。$|^(> |)你还没有把虫子引出来。$|^(> |)这里的虫子似乎已经被其他人抓光了，你只好去其他地方试一试了。$|^(> |)你现在不能抓虫子，好象老仙没允许你进来吧！$",5)
       if l==nil then
	      self:dai()
	     return
	   end
	   if string.find(l,"你还没有把虫子引出来") then
	      self:burn()
	      return
	   end
	   if string.find(l,"你现在正忙着呢") then
	      local f=function()
	        self:dai()
		  end
		  f_wait(f,0.8)
	      return
	   end
	   if string.find(l,"虫子被你一吓，钻入草丛不见了") then
	      local f=function()
	         self:dai()
		  end
		  f_wait(f,1)
	      return
	   end
      if string.find(l,"这里的虫子似乎已经被其他人抓光了") then
	    self:move()
		return
	   end
	   if string.find(l,"与寻常毒虫大大不同") then
	      local bugname=w[2]

		  local bugid
		  if string.find(bugname,"蜘蛛") then
		     bugid="zhizhu"
		  elseif string.find(bugname,"蜈蚣") then
		     bugid="wugong"
		  elseif string.find(bugname,"沙虫") then
		     bugid="shachong"
		  elseif string.find(bugname,"蝎子") then
		     bugid="xiezi"
		  end

		  self:chongzi(bugid,bugname)
	      return
	   end
	   if string.find(l,"你现在不能抓虫子") then
	      self:leave()
	      return
	   end
   end)

end

function zhuachong:combat()
   world.Send("yun qi")
   world.Send("yun jingli")
end

function zhuachong:kill(name,id)
     id=Trim(id)
	 id=string.lower(id)
	 print("杀手:",name,id)
	 self.shashou_name=name
	 self.shashou_id=id
	 world.Send("kill "..id)
	 self:combat()
	 self:shashou_die()
end

function zhuachong:cbug()
  world.Execute("look;set look 1")
  wait.make(function()
	    local l,w=wait.regexp("^(> |)(.*)\\\((.*)\\\).*$|^(> |)设定环境变量：look \\= 1",10)
		if l==nil then
		   self:cbug()
		   return
		end
		--print(l)
		if string.find(l,")") then
		   --print(w[2]," " ,w[3])
		   local name=w[2]
		   local id=string.lower(w[3])
		   print(name,id)
		   if string.find(name,"蜘蛛") or string.find(name,"沙虫") or string.find(name,"蝎子") or string.find(name,"蜈蚣") then
		       self:chongzi(id,name)
		   else
              self:cbug()
		   end
		   return
		end
		if string.find(l,"设定环境变量") then
		   self:dai()
		   return
		end
	end)
end

function zhuachong:cjob()
   self:time_end()
   local b=busy.new()
   b.Next=function()
      self:cbug()
   end
   b:check()
end
--糟糕，又冲上来了个人....!!!
function zhuachong:shashou_die()
   wait.make(function()
      local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动.*|^(> |)糟糕，又冲上来了个人\.\.\.\.\!\!\! $",10)
	  if l==nil then
	     self:shashou_die()
		 return
	  end
	  if string.find(l,"糟糕") then
	     self:wanted()
	     return
	  end

	  if string.find(l,"一声倒在地上") then
	     local name=w[2]
		 print(name)
		 if string.find(self.shashou_name,name) then
		     world.Send("unset wimpy")
		     shutdown()
			 if self.liandu=="自动" then
			    local b=busy.new()
				b.Next=function()
			     world.Send("get silver from corpse")
				 world.Send("get silver from corpse 2")
				 world.Send("get corpse")
				 self:leave()
				end
				b:check()
			 else
				 local b=busy.new()
				b.Next=function()
			     world.Send("get silver from corpse")
				 world.Send("get silver from corpse 2")
				 --world.Send("get corpse")
				 self:cbug()
				end
				b:check()
			 end
		 else
		     self:shashou_die()
		 end
		 return
	  end
      wait.time(10)
   end)
end

function zhuachong:get_id(npc)
	wait.make(function()
		 world.Send("look")
	    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$",5)
		if l==nil then
		   self:get_id(npc)
		   return
		end
		if string.find(l,npc) then

		   self:kill(npc,w[2])
		   return
		end
		wait.time(5)
	end)
end

function zhuachong:wanted()
   world.Send("say 天堂有路你不走，地狱无门闯进来！")
   --看起来管朗想杀死你！
   wait.make(function()
      local l,w=wait.regexp("^(> |)看起来(.*)想杀死你！$",10)
	  if l==nil then
	     self:wanted()
	     return
	  end
	  if string.find(l,"想杀死你") then
	     local npc=w[2]
		 if string.find(npc,"蜘蛛") or string.find(npc,"沙虫") or string.find(npc,"蜈蚣") or string.find(npc,"蝎子") then
		     self:wanted()
		  else
		     self:get_id(npc)
		  end
		 return
	  end
   end)

end

function zhuachong:out()

 world.Send("yell open")
  wait.make(function()
    local l,w=wait.regexp("^.*大门发出轧轧的声音，慢慢打开，你现在可以出去了。$|^(> |)什么?$",5)
	if l==nil then
	   self:out()
	   return
	end
	if string.find(l,"什么") then
	   self:leave()
	   return
	end
	if string.find(l,"大门发出轧轧的声音") then
	   world.Send("south")
	   world.Send("southwest")
	   self:checkbugs()
	   return
	end
  end)
end



function zhuachong:leave()
	local _R
   _R=Room.new()
   _R.CatchEnd=function()
     print("随机移动")
     local dx=Split(_R.exits,";")
	 for _,d in ipairs(dx) do
	    if d=="southeast" then
		    local b=busy.new()
	        b.Next=function()
		       world.Send("southeast")
		       self:out()
			end
	        b:check()
		   return
		end
	 end
	 local b=busy.new()
	 b.Next=function()
		 world.Send("east")
		 world.Send("south")
		 self:leave()
	 end
	 b:check()
   end
   _R:CatchStart()
end

function zhuachong:time_end()
  wait.make(function()
    local l,w=wait.regexp("^(> |)你觉的有些不妙，似乎周围还有什么人在，被人盯上了！$",10)
	   if l==nil then
		  self:time_end()
	      return
	   end
	   if string.find(l,"你觉的有些不妙") then
	      shutdown()
	      self:wanted()
	      return
	   end
  end)
end
--[[> 毒虫谷 -
    一片平坦谷地，四周是大山环绕。四周阴沉沉的，气氛十分恐怖。谷内
瘴气四起，各种毒物，不计其数，地下都是陈年腐草败叶烂成的软泥。寒风
从山谷通道中刮进来，吹得你肌肤隐隐生疼。
　　这是一个初冬的下午，太阳正高挂在西方的天空中。
    这里明显的出口是 east、north、south、southeast 和 west。]]

function zhuachong:move()
     print("随机移动")
	 world.Send("northwest")
     local dx={"west","east","south","north"}
	 i=math.random(4)
	 print("随机:",i)
	 local run_dx=dx[i]
	 print(run_dx, " 方向")
	 local b=busy.new()
	 b.interval=0.5
	 b.Next=function()
		 world.Send(run_dx)
		 self:dai()
	 end
	 b:check()
end

--[[> 你的眼前一亮，原来是一只黑色蜘蛛全身闪光，头上凸起，与寻常毒虫大大不同。
你觉的有些不妙，似乎周围还有什么人在，被人盯上了！
看起来孙璞豫想杀死你！
孙璞豫神志迷糊，脚下一个不稳，倒在地上昏了过去。
虫子被你一吓，钻入草丛不见了。
你现在正忙着呢！没法静下心来抓虫子！
> 你抓虫的时间快到了，赶紧回去把虫子给守卫吧！
> 大门发出轧轧的声音，慢慢打开，你现在可以出去了。
你时间已到，本次抓虫子结束！]]
function zhuachong:burn()
--你从硫磺上捏了一小块，放在地上，用火折点燃，烧了起来。
  wait.make(function()
     world.Send("burn liuhuang")
	 local l,w=wait.regexp("^(> |)忽听得草丛中瑟瑟声响，绿草中一物晃动，你不禁停了下来，想看个究竟。$|^(> |)这里的虫子似乎已经被其他人抓光了，你只好去其他地方试一试了。$",5)
	 if l==nil then
		self:burn()
	    return
	 end
     if string.find(l,"这里的虫子似乎已经被其他人抓光了") then
	    wait.time(1)
	    self:move()
	    return
     end
	 if string.find(l,"忽听得草丛中瑟瑟声响") then
	    wait.time(1)
	    self:dai()
		return
	 end
  end)
end

function zhuachong:chonggu()
	local ts={
	           task_name="星宿抓虫",
	           task_stepname="抓虫",
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
    world.Send("order remove")
	wait.make(function()
	--大门发出轧轧的声音，慢慢打开，你现在可以进去了。
	  local l,w=wait.regexp("^(> |)大门发出轧轧的声音，慢慢打开，你现在可以进去了。$|^(> |)什么？$|^(> |)什么?$",5)
	  if l==nil then
	     self:chonggu()
	     return
	  end
	  if string.find(l,"什么") then
	      local _R
		  _R=Room.new()
		  _R.CatchEnd=function()

			 local count,roomno=Locate(_R)
			 if roomno[1]==2368 then
			     self.fail(101)
			 elseif _R.roomname=="虫谷入口" and _R.exits=="north;southwest;" then
			       world.Send("north")
	              world.Send("northwest")
		           self:time_end()
		          wait.time(2)
		         self:burn()
			 else
                 self:chonggu()
			 end
		  end
		 _R:CatchStart()

	     return
	  end
	  if string.find(l,"大门发出轧轧的声音") then
	     world.Send("north")
	     world.Send("northwest")
		 self:time_end()
		 wait.time(2)
		 self:burn()
		 return
	   end
	end)
  end
  w:go(2368)
end

function zhuachong:jobDone()
end

function zhuachong:eat()
    local w=walk.new()
	w.walkover=function()
		  world.Send("ask chuzi about 食物")
		  wait.time(1.5)
	      world.Execute("get cai yao")
		  world.Execute("eat cai yao;eat cai yao;eat cai yao;drop cai yao")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
	end
	w:go(2367)
end

function zhuachong:drink()
     local w=walk.new()
	   w.walkover=function()
	      world.Send("ask chuzi about 水")
		  wait.time(1.5)
	      world.Execute("get hulu;get hulu")
		  world.Execute("drink hulu;drink hulu;drink hulu;e;drop hulu 2;drop hulu;w")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
		end
		w:go(2367) --春在楼 976
end

function zhuachong:full()
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<70 or h.drink<70 then
		     if h.food<70 then
			    self:eat()
			 elseif h.drink<70 then
			    self:drink()
			 end
		elseif h.qi_percent<=30 or h.jingxue_percent<=80 then
		    print("疗伤")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:liaoshang()

		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
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
				if id==777 then
				  self:full()
				end
			   if id==202 then
			   --最近房间
				  local _R
                  _R=Room.new()
                  _R.CatchEnd=function()
                    local count,roomno=Locate(_R)
					local target_roomno=nearest_room(roomno)
                    local w
		            w=walk.new()
		            w.walkover=function()
			          self:full()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
               print("内力:",h.max_neili*self.neili_upper)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     world.Send("yun recover")
			     self:equipments()
			   else
	             print("继续修炼")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:equipments()
			end
			b:check()
		end
	end
	h:check()
end

function zhuachong:Status_Check()
	local ts={
	           task_name="星宿抓虫",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
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


