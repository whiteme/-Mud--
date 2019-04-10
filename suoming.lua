--你向洪安通打听有关『job』的消息。
--洪安通说道：「马五德常与本教做对，你速去大理城大富之家把他杀了！」
--洪安通拿出一块索命牌，在上面刻下了大理城大富之家马五德几个字，交给了你。

suoming={
  new=function()
     local sm={}
	 setmetatable(sm,{__index=suoming})
	 return sm
  end,
  co=nil,
  name="",
  id="",
  place="",
  danger=false,
  neili_upper=1.9,
  is_zhaohun=false,
}

local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    if v==r then
		   return true
		end
	end
	return false
end

local cb={}
--[[洪安通说道：「现在令你速去明教风字门设法让门主归顺本教！」
洪安通拿出一块招魂牌，在上面刻下了明教风字门门主几个字，交给了你。]]
function suoming:catch_place()
  wait.make(function()
    local l,w=wait.regexp("^(> |)洪安通说道：「(.*)常与本教做对，你速去(.*)把.*杀了！」$|^(> |)洪安通说道：「现在令你速去(.*)设法让(.*)归顺本教！」$|^(> |)洪安通说道：「你先把前一个任务完成再说。」$|^(> |)洪安通说道：「你刚做完任务，先休息一下吧。」$|^(> |)洪安通说道：「你小子竟敢偷偷做其他门派的任务，还想在神龙教里呆下去么？」$|^(> |)洪安通在你的耳边悄声说道：此人名叫韦小宝，为祸本教不小。$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"常与本教做对") then
	  self.is_zhaohun=false
	  self.place=w[3]
	  self.name=w[2]
	  world.AppendToNotepad (WorldName(),os.date().." 目标:"..w[2].." 所在地:".. w[3].."\r\n")
	  self:find()
	  return
	end
	if string.find(l,"你小子竟敢偷偷做其他门派的任务，还想在神龙教里呆下去么") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  self.fail(102)
		end
		b:check()
	   return
	end
	if string.find(l,"归顺本教") then
	  self.is_zhaohun=true
	  self.place=w[5]
	  self.name=w[6]
	  world.AppendToNotepad (WorldName(),os.date().." 目标:"..w[6].." 所在地:".. w[5].."\r\n")
	  self:find()
	  return
	end
	if string.find(l,"名叫韦小宝，为祸本教不小") then
	   world.AppendToNotepad (WorldName(),os.date().." 目标:韦小宝韦小宝韦小宝小宝\r\n")
	   local q=quest.new()
	   q:weichunhua()
	  return
	end
    if string.find(l,"你刚做完任务，先休息一下吧") then
	   self.fail(101)
	   return
	end
	if string.find(l,"你先把前一个任务完成再说") then
	  self:cancel()
	  return
	end
	wait.time(5)
  end)
end

function suoming:ask_job()
  self.danger=false
  local w=walk.new()
  local al=alias.new()
  al.do_jobing=true
  w.user_alias=al
  w.walkover=function()
   wait.make(function()
    world.Send("ask hong antong about job")
    local l,w=wait.regexp("^(> |)你向洪安通打听有关『job』的消息。$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"你向洪安通打听有关") then
	  --print("why1")
	  self:catch_place()
	  return
	end
	wait.time(5)
   end)
  end
  w:go(1795)
end

function suoming:combat()

end

function suoming:wait_zhaohun()
	  cb=fight.new()
	  cb.check_pfm=false
	  cb.damage=function(per)
         if tonumber(per)<=50 then
	      print("低于安全设置开始脱离战斗")
		  self:flee()
	     end
      end
	  cb.finish=function()
          print("战斗结束")
		  --world.Send("unset wimpy")
		  --shutdown()
		  --self:jobDone()
		  self:flee()
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		 self:flee()
	  end
	  cb.cond=function()
	  end
	  cb.recover=function(flag)
	    wait.make(function()
           print("尝试吸气")
			world.Send("yun recover")
           local l,w=wait.regexp("你深深吸了几口气，脸色看起来好多了。|你现在气力充沛。",2)
	        if l==nil then
	           -- print("吸气")
	          cb:recover(flag)
	          return
            end
	        if string.find(l,"你深深吸了几口气，脸色看起来好多了") or string.find(l,"你现在气力充沛") then
	         -- world.Send("alias pfm")
	          --self:injure()
	          --self:check()
	            print("recover resume check")
	            cb:check_resume()
	          return
	        end
            wait.time(2)
	    end)
	  end
	  cb.refresh=function()
	   wait.make(function()
		  world.Send("yun refresh")
          print("尝试吸气")
          local l,w=wait.regexp("^(> |)你长长地舒了一口气。$|^(> |)你现在精力充沛。$",2)
	      if l==nil then
	        cb:refresh()
	        return
          end
	      if string.find(l,"你长长地舒了一口气") or string.find(l,"你现在精力充沛") then
	        --world.Send("alias pfm")
            --self:check()
	        print("refresh resume check")
	        cb:check_resume()
	        return
	      end
          wait.time(2)
        end)
	  end
	  cb:start()
end

--你被奖励了一百零二点经验，二十八点潜能，二百零四点负神！
--这个人现在处于昏迷中，听不到你说的话!
function suoming:exps()
  wait.make(function()
   local l,w=wait.regexp("^(> |)你被奖励了(.*)点经验，(.*)点潜能，.*负神！$",5)
   if l==nil then
      self:exps()
      return
   end
  if string.find(l,"你被奖励") then
	   --world.Send("yield no")
	   shutdown()
       world.AppendToNotepad (WorldName(),os.date()..": 索命job 经验:".. ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]).."\r\n")
	   local exps=world.GetVariable("get_exp")
	   exps=tonumber(exps)+ChineseNum(w[2])
	   world.SetVariable("get_exp",exps)
	   world.AppendToNotepad (WorldName(),os.date().."目前获得总经验值"..exps.."\r\n")
	   local b
	   b=busy.new()
	   b.interval=0.5
	   b.Next=function()
		 self:jobDone()
	   end
	   b:check()
	   return
   end
   wait.time(3)
  end)
end

function suoming:zhaohun(npc,id)
   wait.make(function()
    if self.danger==true then
	   print("逃跑停止招魂！！")
	   return
	end
    print("zhaohun "..id)
	world.Send("hp")
	world.Send("yun refresh")

    --world.Send("zhaohun "..id)--^(> |)你拿出招魂牌对着.*一晃，然后口念咒语。$|
	local l,w=wait.regexp("^(> |)你长长地舒了一口气。$|^(> |)你现在精力充沛。$",2)
	if l==nil then
      self:zhaohun(npc,id)
	  return
	end
	--[[if string.find(l,"你拿出招魂牌对着") then
	  local f=function() self:zhaohun(npc,id) end
	  f_wait(f,1.2)
	  return
	end]]

	if string.find(l,"你长长地舒了一口气") or string.find(l,"你现在精力充沛") then
	   local pfm=world.GetVariable("zhaohun_pfm") or ""
	   --print(pfm)
	   if pfm~="" then
	    local value=world.GetVariable(pfm) or ""
		if value~="" then
	      world.Execute(value)
		end
	  end
	   world.Send("yield no")
	   world.Send("zhaohun "..id)
	   wait.make(function()
	      local l,w=wait.regexp("^(> |)这个人现在处于昏迷中，听不到你说的话.*$|^(> |).*对你哀求道：这儿是点小意思，您就大人大量放过我吧！.*$",0.8)
		  if l==nil then
	        self:zhaohun(npc,id)
			return
		  end
		  if string.find(l,"您就大人大量放过我") then
		     world.Send("no")
			self:zhaohun(npc,id)
			return
		  end
		 if string.find(l,"昏迷中") then
	       world.Send("yield yes")
	       shutdown()
	    --cb:close_combat_check()
	      print("关闭战斗检查")
	     local f=function()
	       self:wait_zhaohun()
		    self:exps()
	        self:zhaohun(npc,id)
	      end
	      f_wait(f,2)
	      return
  	    end

	   end)
	   return
	end

    wait.time(5)
  end)
end

function suoming:suoming(index)
local b=busy.new()
b.interval=0.5
b.Next=function()
  wait.make(function()
   if index==nil then
       world.Send("get gold from corpse")
	   world.Send("get silver from corpse")
       world.Send("suoming corpse")
	else
	   world.Send("get gold from corpse "..index)
	   world.Send("get silver from corpse "..index)
	   world.Send("suoming corpse ".. index)
   end
   local l,w=wait.regexp("^(> |)你被奖励了(.*)点经验，(.*)点潜能，.*负神！|^(> |)找不到这个东西。$|^(> |)你找不到 corpse.* 这样东西。$|^(> |)这个人不是你杀的！$",5)
   if l==nil then
      self:suoming(index)
	  return
   end
   if string.find(l,"你被奖励") then
       world.AppendToNotepad (WorldName(),os.date()..": 索命job 经验:".. ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]).."\r\n")
	   local exps=world.GetVariable("get_exp")
	   exps=tonumber(exps)+ChineseNum(w[2])
	   world.SetVariable("get_exp",exps)
	   world.AppendToNotepad (WorldName(),os.date().."目前获得总经验值"..exps.."\r\n")
		local b
		b=busy.new()
		b.interval=0.5
		b.Next=function()
		  self:jobDone()
		end
		b:check()
	   return
   end
   if string.find(l,"这个人不是你杀的") then
      if index==nil then
	     index=2
	  else
	     index=index+1
	  end
      self:suoming(index)
      return
   end
   if string.find(l,"找不到") then
      self:giveup()
      return
   end
   wait.time(5)
  end)
 end
 b:check()
end

function suoming:run(dx,i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)你逃跑失败。$|^(> |)你的修为不够！$|^(> |)设定环境变量：action \\= \\\"逃跑\\\"$|^(> |)你又不在战斗中跑什么跑？$|^(> |)「神行百变」只能在战斗时用！$",1.5)
	   if l==nil then
	      self:run(dx,i)
	      return
	   end
	   if string.find(l,"你的修为不够") then
	     if i==nil then
		    i=1
		 else
		    i=i+1
		 end
		 self:flee(i)
	     return
	   end
	   if string.find(l,"你的动作还没有完成，不能移动") or string.find(l,"你逃跑失败") then
		  self:run(dx,i)
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
		 world.DoAfter(1.5,"set action 结束")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"逃跑\\\"$|^(> |)设定环境变量：action \\= \\\"结束\\\"$",5)
			if l==nil then
			   self:run(dx,i)
			  return
			end
			if string.find(l,"逃跑") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"结束") then
			   world.Send("unset wimpy")
			   self:giveup()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   if string.find(l,"你又不在战斗中跑什么跑") or string.find(l,"只能在战斗时用") then
		  world.Send("unset wimpy")
		  self:giveup()
	      return
	   end
	   wait.time(1.5)
  end)
end

function suoming:flee(i)
  self.danger=true
  world.Send("jifa dodge youlong-shenfa")
  world.Send("perform dodge.baibian")
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("寻找出口")
     local dx=_R.get_all_exits()
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil or i>table.getn(dx) then
	    --获得随机方向
	     local n=table.getn(dx)
	     i=math.random(n)
		 print("随机:",i)
	 end
	 local run_dx=dx[i]
	 print(run_dx, " 方向")
	 local halt
	 if _R.roomname=="洗象池边" then
	    world.Send("alias pfm "..run_dx..";set action 逃跑")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set action 逃跑")
	 end
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
	 self:run(run_dx,i)
   end
   _R:CatchStart()
end

function suoming:kill(npc,id)
  self:combat()
  self:wait_badman_die()
  wait.make(function()
    print("kill"..id)
    world.Send("kill "..id)
	local l,w=wait.regexp("^(> |)你正打不还手呢，怎么杀？$",5)
	if l==nil then
	  self:kill(npc,id)
	  return
	end
	if string.find(l,"你正打不还手呢") then
	  world.Send("yield no")
	  self:kill(npc,id)
	  return
	end
    wait.time(5)
  end)
end

function suoming:find()
	--[[ local win=window.new() --监控窗体
     win.name="status_window"
	 win:addText("label1","目前工作:神龙岛任务")
	 win:addText("label2","目前过程:寻找NPC")
	 win:addText("label3","地点:"..self.place)
	 win:addText("label4","名字:"..self.name)
     win:refresh()]]
	 local ts={
	           task_name="神龙岛索命",
	           task_stepname="寻找npc",
	           task_step=2,
	           task_maxsteps=4,
	           task_location=self.place,
	           task_description=self.name,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	if self.name=="忽必烈" or self.name=="葛光佩" or self.name=="天狼子" or self.name=="干光豪" or self.name=="达尔巴" then
	   self:giveup()
	   print("运气不好不能怪政府！！")
	   return
	 end
	if zone_entry(self.place)==true then
      self:giveup()
      return
    end
   local n,rooms=Where(self.place)
	if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   suoming.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    print("寻找"..self.name)
		    self:checkNPC(self.name,r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("没有找到npc!!")
		self:giveup()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("没有目标,放弃")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:giveup()
	  end
	  b:check()
	end
end

function suoming:jobDone()
end
--洪安通一掌把你打得飞了出去！
function suoming:fear()
   wait.make(function()
      local l,w=wait.regexp("^(> |)洪安通一掌把你打得飞了出去！$|^(> |)洪安通说道：「怎么？！你想抗命不成？！」$",5)
	  if l==nil then
		 self:cancel()
		 return
	  end
	  if string.find(l,"抗命") then
	     self:job_failure()
	     self:jobDone()
		 return
	  end
	  if string.find(l,"洪安通一掌把你打得飞了出去") then
	       local b=busy.new()
	       b.interval=0.3
	       b.Next=function()
	         self:Status_Check()
	       end
	       b:check()
	     return
	  end
	  wait.time(5)
   end)
end

function suoming:job_failure()
end

function suoming:giveup()
   world.AppendToNotepad (WorldName(),os.date()..": 索命:giveup \r\n")
   self:job_failure()
   self:jobDone()
end

function suoming:cancel()
 local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask hong antong about cancel")
    local l,w=wait.regexp("^(> |)你向洪安通打听有关『cancel』的消息。$",5)
	if l==nil then
	  self:giveup()
	  return
	end
	if string.find(l,"你向洪安通打听有关") then
	  self:fear()
	  return
	end
	wait.time(5)
   end)
  end
  w:go(1795)
end

function suoming:NextPoint()
   print("进程恢复")
   coroutine.resume(suoming.co)
end

function suoming:checkPlace(npc,roomno,here)
      if is_contain(roomno,here) then
  	     print("等待0.5s,下一个房间")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
		 end
		 f_wait(f,0.5)
	   else
	   --没有走到指定房间
	    print("没有走到指定房间")
	      w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno)
		  end
		  w:go(roomno)
	   end
end

function suoming:badman_die()
end

function suoming:wait_badman_die()
wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了。$",5)
	 if l==nil then
	    self:wait_badman_die()
	    return
	 end
	 if string.find(l,"挣扎着抽动了几下就死了") then
	    print(self.name,w[2])
	    if string.find(self.name,w[2]) then
		   self:badman_die()
		else
           self:wait_badman_die()
		end
	    return
	 end
	 wait.time(5)
  end)
end

function suoming:checkNPC(npc,roomno)
    wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      --没有找到
		  --
		  local f=function(r)
		     self:checkPlace(npc,roomno,r)
		  end
		  WhereAmI(f,10000) --排除出口变化

		  return
	  end
	  if string.find(l,npc) then
	     --找到
		  local id=string.lower(trim(w[2]))
		  self.id=id
		  print(id)
		  if self.is_zhaohun==true then
		    --world.Send("yield yes")
			world.Send("unset wimpycmd")
			self:wait_zhaohun()
	        self:exps()
		    self:zhaohun(npc,id)
		  else
		    self:kill(npc,id)
		  end
		  return
	  end
	  wait.time(6)
   end)
end

function suoming:full()
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
			print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("sit chair;knock table;get mi tao;get cha;drink cha;drink cha;drink cha;eat mi tao;eat mi tao;eat mi tao;drop wan;drop mi tao;drop tea")
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
		   w:go(1960) --299 ask xiao tong about 食物 ask xiao tong about 茶
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
			x.min_amount=100
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
			     self:ask_job()
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
			  world.Send("yun recover")
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end

function suoming:Status_Check()
    --[[local win=window.new() --监控窗体
     win.name="status_window"
	 win:addText("label1","目前工作:神龙岛")
	 win:addText("label2","目前过程:打坐")
     win:refresh()
    self.win=false]]
		 local ts={
	           task_name="神龙岛索命",
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
