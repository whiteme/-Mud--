
tiandi={
  new=function()
    local td={}
	 setmetatable(td,{__index=tiandi})
	 return td
  end,
  co=nil,
  fighting=false,
  is_combat=false,
  is_end=false,
  name="",
  hero_name="",
  neili_upper=1.9,
  shiwei_list={},
  npc="",
  is_move=false,
  is_wander=false,
  reward_count=0,
}

local check_fight=false
local count=1
--[[
李式开在你的耳边悄声说道：你马上去嵩山少林练武场联络一个会里的兄弟。
李式开在你的耳边悄声说道：他的名字叫南宫沛，你路上小心。
糟了！霍封死亡，任务失败！
]]
function tiandi:join()
 local w=walk.new()
  w.walkover=function()
	 marco("ask shikai about 万云龙|#wa 2000|ask shikai about 天地会|#wa 2000|ask shikai about 反清复明")
	 local f=function()
		self:Status_Check()
	 end
	 f_wait(f,6)
  end
  w:go(104)
end

function tiandi:failure()
  --由于你动作太慢，益坚为躲避清廷追击，已先行藏匿了，你任务失败！
  wait.make(function()
     local l,w=wait.regexp("^(> |)由于你动作太慢，.*为躲避清廷追击，已先行藏匿了，你任务失败！$",20)
	 if l==nil then
	   self:failure()
	   return
	 end
	 if string.find(l,"由于你动作太慢") then
	   self:Status_Check()
	   return
	 end
	 wait.time(20)
  end)
end

function tiandi:NextPoint()
   print("进程恢复")
   coroutine.resume(tiandi.co)
end
--[[
甘添拱手道：“公冶勤兄、叶知秋兄，请借一步说话。”
只听甘添向远处大喝一声：“狗贼，鬼鬼祟祟跟到这里，还不出来受死！”喊声中气十足。
]]
function tiandi:checkNPC(npc,callback)



   wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,callback)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      --没有找到
		  --self:NextPoint()
		  callback()
		  return
	  end
	  if string.find(l,npc) then
	     --找到
		  local id=Trim(w[2])
		  jiekou_count=0
		  self:qiekou(npc,id)
		  return
	  end
	  wait.time(6)
   end)
end

function tiandi:find_man(location,npc)
	  local ts={
	           task_name="天地会",
	           task_stepname="寻找"..npc,
	           task_step=2,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	}
	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."天地会任务:寻找:"..npc.." 地点:"..location, "white", "black") -- yellow on whit
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   if zone_entry(location)==true or string.find(location,"弟子居") or string.find(location,"摩天崖") or string.find(location,"紫杉林") or string.find(location,"竹林") or string.find(location,"冷杉林") or string.find(location,"清池") then
      self:giveup()
      return
   end
 local n,rooms=Where(location)
 rooms=depth_search(rooms,1)  --范围查询
 print(n," 房间数目")
   for _,r in ipairs(rooms) do
      print(r)
   end
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   local al
		al=alias.new()
		al:SetSearchRooms(rooms)
		al.do_jobing=true
	   tiandi.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  w.noway=function()
		    self:NextPoint()
		  end


		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  --print("进程恢复2")
				  coroutine.resume(tiandi.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
			  --print("al 松林check")
			  local f=function()
	             al:NextPoint()
			  end
			  self:checkNPC(npc,f)
		  end

		  al.zishanlin_check=function()
			 self.NextPoint=function() al:NextPoint() end
			   local f1=function()
			      self:NextPoint()
			   end
             self:checkNPC(npc,f1)
		  end
         	al.maze_done=function()
              --print("遍历",npc)
	          self:checkNPC(npc,al.maze_step)
	       end


		  w.user_alias=al
		  w.walkover=function()
		     local f=function()
			    self:NextPoint()
			 end
		    self:checkNPC(npc,f)
		  end
		  print("下一个房间号:",r)
		  self.target_roomno=r
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

function tiandi:auto_pfm()

end

--百里九正盯着你看，不知道打些什么主意。
function tiandi:get_name(place)
   wait.make(function()
     local l,w=wait.regexp("^(> |)李式开在你的耳边悄声说道：他的名字叫(.*)，你路上小心。$",5)
	 if string.find(l,"你路上小心") then
	   local npc_name=Trim(w[2])
	   print("名字:",npc_name)
	   self.npc=npc_name
	   self:find_man(place,npc_name)
	   return
	 end
     wait.time(5)
   end)
end
--李式开在你的耳边悄声说道：速去莆田少林广场。
--李式开在你的耳边悄声说道：速去华山苍龙岭。
local is_error=false
function tiandi:catch_place()
   wait.make(function()
      local l,w=wait.regexp("^(> |)李式开在你的耳边悄声说道：你马上去(.*)联络一个会里的兄弟。$|^(> |)李式开在你的耳边悄声说道：速去(.*)。$|^(> |)李式开说道：「你还在做任务呢！」$|^(> |)李式开说道：「你刚完成任务，还是去休息会吧。」$|^(> |)李式开说道：「你又没领过任务，放弃什么啊？」|^(> |)李式开说道：「听说陈总舵主有事找你，你还是先去找总舵主询问吧。」$",5)
	  if l==nil then
	     self:ask_job()
	     return
	  end
	  if string.find(l,"你还在做任务呢") then
	    self.fail(102)
	    return
	  end
	  if string.find(l,"你刚完成任务，还是去休息会吧") then
	     self.fail(101)
	     return
	  end
	  if string.find(l,"联络一个会里的兄弟") then

	   local place=Trim(w[2])
	   if  place=="归云庄九宫桃花阵" or place=='大草原沼泽' then --or place=="嵩山少林松树林"
	     self:giveup()
		 return
	   end
	    self.backplace=place
	    print("地点:",place)
	   self:get_name(place)
	   return
	  end
	  if string.find(l,"你又没领过任务，放弃什么啊") then
	    self:jobDone()
	    return
	  end
	  if string.find(l,"李式开说道：「听说陈总舵主有事找你，你还是先去找总舵主询问吧。」") then
	    --local quest=quest.new()
		--quest:tiandihui()
	    return
	  end
	  if string.find(l,"速去") then
	     self:giveup()
	     --[[local place=w[4]
		 print("速去"..place)
		 self.link_man_room=Where(place)
		 self:back()]]
	    return
	  end
	  wait.time(5)
   end)
end

function tiandi:ask_job()


	 local ts={
	           task_name="天地会",
	           task_stepname="询问工作",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
    wait.make(function()
	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."天地会任务:工作开始","yellow", "black") -- yellow on whit
     world.Send("ask shikai about job")
	 local l,w=wait.regexp("^(> |)你向李式开打听有关『job』的消息。$",5)
	 if l==nil then
	    self:ask_job()
		return
	 end
	 if string.find(l,"你向李式开打听有关") then
	    self:catch_place()
	    return
	 end
	 wait.time(5)
	 end)
  end
  w:go(104)
end
--[[
南宫沛冲上前去，激动地紧紧握住你的双手，哽咽着说不出话来。
南宫沛说道：「原来大家是自己人，在下宏化堂弟子南宫沛。」
南宫沛说道：「在明教小沙丘有一位叫做郑遂的兄弟，他想加入我们天地会。」
南宫沛在你的耳边悄声说道：他的相貌是…这个…样子的，凭你的眼力一眼就认得出来。
南宫沛说道：「朝廷已经派人在缉拿他，请尽快赶到，兄弟还有要事在身，就请你走一趟了。」
]]
--[[
你老远看见一人，样子恍惚和南宫沛说的那人很像。
你走上前去，作揖道：“请问阁下可是郑遂？” 那人答道：“正是。”

]]

function tiandi:checkHero(npc,callback)
--  草莽英雄 吕沛(Lv pei)
--  天地会参太堂弟子 闻宇良(Wen yuliang)
   wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*(草莽英雄|反清志士|绿林好汉).*"..npc.."\\\((.*)\\\)$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:checkHero(npc,callback)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      --没有找到
		  if callback~=nil then
		     callback()
		  else
		     self:NextPoint()
		  end

		  return
	  end
	  if string.find(l,npc) then
	     --找到
		  local id=Trim(w[3])
		  self:guard(npc,id)
		  return
	  end
	  wait.time(6)
   end)
end

function tiandi:hero(place,npc)
	  local ts={
	           task_name="天地会",
	           task_stepname="寻找"..npc,
	           task_step=4,
	           task_maxsteps=5,
	           task_location=place,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."天地会任务:接头:"..npc.." 地点:"..place, "white", "black")
   if zone_entry(place)==true or string.find(place,"紫杉林") or string.find(place,"竹林") or string.find(place,"摩天崖")  then
      self:giveup()
      return
   end
	if  place=="归云庄九宫桃花阵" or place=="嵩山少林松树林" or place=="长安城清池" then
	     self:giveup()
		 return
	end
  local n,rooms=Where(place)
   if n>0 then

	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   tiandi.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  w.noway=function()
		    self:NextPoint()
		  end
		  local al
		  al=alias.new()
		  al.do_jobing=true
		  al.break_in_failure=function()
		      self:giveup()
		  end

		   al:SetSearchRooms(rooms)

         	al.maze_done=function()

	          self:checkHero(npc,al.maze_step)
	       end


		  w.user_alias=al
		  w.walkover=function()
		    self:checkHero(npc)
		  end
		  print("下一个房间号:",r)
		  self.target_roomno=r
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

function tiandi:test()
  local f=function(c)
     print("test",c[1])
		  self:hero(hero_place,hero_name)

		  --local c=is_crowd(self.target_roomno)
           self.link_man_room=c
		end
		WhereAmI(f,10000) --排除出口变化
end

local jiekou_count=0
function tiandi:jie(npc)
   jiekou_count=jiekou_count+1
   if jiekou_count>5 then
      self:giveup()
      return
   end
   self.link_man=npc
   --print("联络人地点:",self.link_man_room[1])
   --print("联络人名字:",self.link_man)
   wait.make(function()
     world.Send("qiekou")
	 local l,w=wait.regexp("^(> |)"..npc.."说道：「在(.*)有一位叫做(.*)的兄弟，他想加入我们天地会。」$|^(> |)你觉得有点什么不对劲.*$",3)
     if l==nil then
	    self:jie(npc)
		return
	 end
	 if string.find(l,"你觉得有点什么不对劲") then
	    self:giveup()
	    return
	 end
	 if string.find(l,"加入我们天地会") then
		local hero_place=Trim(w[2])
		local hero_name=Trim(w[3])
		self.hero_name=hero_name
		print("地点:",hero_place," 名字:",hero_name)
	    local f=function(c)
		  print("当前房间:",c[1])
		  self:hero(hero_place,hero_name)

		  --local c=is_crowd(self.target_roomno)
           self.link_man_room=c
		end
		WhereAmI(f,10000) --排除出口变化
		 return
	 end
	 wait.time(3)
   end)
end

function tiandi:duilian(npc,id)
  wait.make(function()
    world.Send("ask "..id.." about 切口")
    local l,w=wait.regexp("^(> |)"..npc.."说道：「切口？哈哈，有点意思，你先说说\\\(qiekou\\\)。」|^(> |)这里没有这个人。$",5)
	if l==nil then
	   self:duilian(npc,id)
	   return
	end
	if string.find(l,"这里没有这个人") then
	   self:giveup()
	   return
	end
	if string.find(l,"你先说说") then
	   local b
	   b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	      self:jie(npc)
	   end
	   b:check()
	   return
	end
	wait.time(5)
  end)
end

function tiandi:fanqingfumu(npc,id)
  wait.make(function()
	world.Send("ask "..id.." about 反清复明")
    local l,w=wait.regexp("^(> |)"..npc.."似乎不懂你的意思。|^(> |)这里没有这个人。$",5)
	if l==nil then
	  self:fanqingfumu(npc,id)
	  return
	end
	if string.find(l,"这里没有这个人") then
	   self:giveup()
	   return
	end
	if string.find(l,"不懂你的意思") then
	   local b
	   b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	     self:duilian(npc,id)
	   end
	   b:check()
	   return
	end
	wait.time(5)
  end)
end

function tiandi:qiekou(npc,id)
  id=string.lower(id)
  wait.make(function()
    world.Send("ask "..id.." about 天地会")
    local l,w=wait.regexp("^(> |)"..npc.."说道：「你可知他们做的是什么事？」|^(> |)这里没有这个人。$",5)
	if l==nil then
	   self:qiekou(npc,id)
	   return
	end
	if string.find(l,"你可知他们做的是什么事") then
	   local b=busy.new()
		b.interval=0.3
        b.Next=function()
		   self:fanqingfumu(npc,id)
        end
	    b:check()
	   return
	end
	if string.find(l,"这里没有这个人") then
	   self:NextPoint()
	   return
	end
   wait.time(5)
  end)
end

--[[function tiandi:dog_claw()
  -- print("dog_claw")
   wait.make(function()--郝河叫道：“缉拿钦犯，闲杂人等闪开！”说罢便与叶知秋等战在了一起。
     local l,w=wait.regexp("^(> |).*叫道：“缉拿钦犯，闲杂人等闪开！”说罢便与(你|"..self.name.."等)战在了一起。$|^(> |)"..self.hero_name.."一边跑，一边对着你大声喊道.*$",30)
	 if l==nil then
	   self:dog_claw()
	   return
	 end
	 if string.find(l,"缉拿钦犯") or string.find(l,self.hero_name) then
       shutdown()
	   self:combat()
	   return
	 end
	 wait.time(30)
   end)
end]]

function tiandi:fail(id) --回调函数

end

function tiandi:run(i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)你逃跑失败。$|^(> |)你的修为不够！$|^(> |)设定环境变量：action \\= \\\"逃跑\\\"$",1.5)
	   if l==nil then
	      self:run(i)
	      return
	   end
	   if string.find(l,"你的修为不够") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"你的动作还没有完成，不能移动") or string.find(l,"你逃跑失败") then
		  self:run(i)
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
		 world.DoAfter(1.5,"set action 结束")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"逃跑\\\"$|^(> |)设定环境变量：action \\= \\\"结束\\\"$",5)
			if l==nil then
			   self:run(i)
			  return
			end
			if string.find(l,"逃跑") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"结束") then
			   world.Send("unset wimpy")
			   shutdown()
			   self:giveup()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function tiandi:flee(i)
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

local function belong(h,t)
   for _,r in ipairs(h) do
      print(r," ?= ",t)
      if r==t then
	     return true
	  end
   end
   return false
end


function tiandi:checkPlace(here,targetRoomNo)
	if belong(here,targetRoomNo)==true then
  	     print("等待1s,检查！")
		 local f=function()
		   wait.make(function()
            world.Execute("look;set look 1")
            local l,w=wait.regexp("^(> |).*"..self.link_man.."\\\((.*)\\\).*$|^(> |)设定环境变量：look \\= 1",5)
	       if l==nil then
		    self:checkPlace(here,targetRoomNo)
		    return
	       end
	       if string.find(l,"设定环境变量：look") then
	         --没有找到
		     self:NextPoint()
		     return
	       end
	      if string.find(l,self.link_man) then
	       --找到
		     print("找到了!!"," 15s ")
			 --self:auto_pfm()
			 self.reward_count=self.reward_count+1
			 if self.reward_count>10 then
			   shutdown()
			   print("尝试10次放弃")
			   self:giveup()
			   return
			 end
			 self:task_failure()
			 self:shiwei()
             self:reward()
			 local f=function()
			    self:recover()
			 end
			 f_wait(f,15)
		    return
		   end
	       wait.time(5)
          end)
		 end
		 f_wait(f,1)
	else
	   --没有走到指定房间
	    print("没有走到指定房间")
		local w=walk.new()
	    local al
        al=alias.new()
		al.do_jobing=true
        al.break_in_failure=function()
		  self:giveup()
	    end
	    w.user_alias=al
        --self:dog_claw()
		self:shiwei()
        self:reward()
		--[[w.locate_fail_deal=function()
         --定位失败处理函数  防止九宫桃花阵
	      local _R
          _R=Room.new()
          _R.CatchEnd=function()
		    local error_alias=alias.new()
		    print("房间名:",_R.roomname)
            if _R.roomname=="九宫桃花阵" then
			  print("定位失败！ 桃花阵中！")
			  error_alias.finish=function()
			   print("出桃花瘴")
			   print("目标房间号:",targetRoomNo)
			   w:go(targetRoomNo)
			 end
		     error_alias:reset_taohuazhen()
			elseif _R.roomname=="小帆船" then
			  world.Send("order 开船")
			  error_alias.finish=function()
			    w:go(targetRoomNo)
			  end
			  error_alias:order_chuan()
		    end
          end
          _R:CatchStart()
        end]]
        w.walkover=function()
         local f=function(e)
           self:checkPlace(e,targetRoomNo)
	     end
	     WhereAmI(f,10000)
        end
      w:go(targetRoomNo)
	end
end

function tiandi:jobDone()
end

function tiandi:test_combat()
end

function tiandi:wait_reward()
     wait.make(function()
	--恭喜你任务顺利完成，你获得了三百六十九点经验，八十点潜能的奖励。
	  local l,w=wait.regexp("^(> |)"..self.npc.."抱拳道：“青山不改，绿水常流，咱们后会有期！.*|^(> |)恭喜你任务顺利完成，你获得了(.*)经验，(.*)点潜能的奖励。$|^(> |)恭喜你！你成功的完成了天地会任务！你被奖励了：$",5)
	  if l==nil then
		self:wait_reward()
	    return
	  end
	  if  string.find(l,"青山不改") or string.find(l,"恭喜你任务顺利完成") or string.find(l,"你被奖励了")  then
	     print("tdh ok2")
		 --world.AppendToNotepad (WorldName(),os.date()..": 天地会job 经验".. w[2].." 潜能:"..w[3].."\r\n")
		 self.is_end=true
		  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on whit
		  --local exps=world.GetVariable("get_exp")
		 --exps=tonumber(exps)+ChineseNum(w[2])
		 --world.SetVariable("get_exp",exps)
		    local rc=reward.new()
			rc.finish=function()
			   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."天地会任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on white
			end
			 rc:get_reward()

		     self:test_combat()
	     return
	  end
	  wait.time(5)
	end)
end

--只听奚朝伟向远处大喝一声：“狗贼，鬼鬼祟祟跟到这里，还不出来受死！”喊声中气十足。
function tiandi:reward()
    --print("联络人",self.link_man)
    wait.make(function()
	--恭喜你任务顺利完成，你获得了三百六十九点经验，八十点潜能的奖励。
	  local l,w=wait.regexp("(> |)"..self.npc.."抱拳道：“青山不改，绿水常流，咱们后会有期！.*|^(> |)恭喜你任务顺利完成，你获得了(.*)经验，(.*)点潜能的奖励。$|^(> |)恭喜你！你成功的完成了天地会任务！你被奖励了：$|^(> |)只听"..self.link_man.."向远处大喝一声：“狗贼，鬼鬼祟祟跟到这里，还不出来受死！”喊声中气十足。$",5)
	  if l==nil then
		self:reward()
	    return
	  end
	  if string.find(l,"青山不改") or string.find(l,"恭喜你任务顺利完成") or string.find(l,"你被奖励了") then
		 shutdown()
		 print("tdh ok1")
           local rc=reward.new()
			rc.finish=function()
			   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."天地会任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on white
			end
			 rc:get_reward()

		  --f_wait(f,0.8)
		  local b=busy.new()
		  b.Next=function()
		    self:jobDone()
		  end
		  b:jifa()
	     return
	  end
	  if string.find(l,"鬼鬼祟祟跟到这里") then
	     print("鬼鬼祟祟!!!")
		 shutdown()
		if self.fighting==false then
		  self:reset()
		end
		 self:shiwei()
		 self.is_combat=true
		 self:combat()
		 self:wait_reward()
	     return
	  end
	  wait.time(5)
	end)
end


local function short_dir(dir)
   local d=dir
   d=string.gsub(d,"eastdown","ed")
   d=string.gsub(d,"westdown","wd")
   d=string.gsub(d,"northdown","nd")
   d=string.gsub(d,"southdown","sd")
   d=string.gsub(d,"eastup","eu")
   d=string.gsub(d,"westup","wu")
   d=string.gsub(d,"northup","nu")
   d=string.gsub(d,"southup","su")
   d=string.gsub(d,"northwest","nw")
   d=string.gsub(d,"northeast","ne")
   d=string.gsub(d,"southwest","sw")
   d=string.gsub(d,"southeast","se")
   d=string.gsub(d,"east","e")
   d=string.gsub(d,"west","w")
   d=string.gsub(d,"south","s")
   d=string.gsub(d,"north","n")
   d=string.gsub(d,"up","u")
   d=string.gsub(d,"down","d")
   return d
end

local steps=0
function tiandi:go(dir)

	 world.Execute(dir)
	 local f=function()
	    steps=steps+1
		print("次数:",steps)
		if steps>20 then
           self.is_wander=false
		   self:back()
		else
		  self:go(dir)
		end
	 end
	 f_wait(f,0.5)

end

local function get_dir(dx)
   print(dx," in ")
   if dx=="up" then
      return "down"
	elseif dx=="down" then
	   return "up"
   elseif dx=="east" then
      return "west"
	elseif dx=="west" then
	  return "east"
	elseif dx=="north" then
	  return "south"
	elseif dx=="south" then
	  return "north"
	elseif dx=="northwest" then
	  return "southeast"
	elseif dx=="northeast" then
	  return "southwest"
	elseif dx=="southwest" then
	   return "northeast"
	elseif dx=="southeast" then
	   return "northwest"
	elseif dx=="enter" then
	  return "out"
	elseif dx=="out" then
	  return "enter"
	elseif dx=="southdown" then
	  return "northup"
	elseif dx=="northup" then
	  return "southdown"
	elseif dx=="eastup" then
	  return "westdown"
	elseif dx=="westdown" then
	   return "eastup"
	elseif dx=="northdown" then
	   return "southup"
	elseif dx=="southup" then
	   return "northdown"
	elseif dx=="eastdown" then
	    return "westup"
	elseif dx=="westup" then
	    return "eastdown"
   end
end

function tiandi:wander()
   local _R=Room.new()
    local _R
	_R=Room.new()
	_R.CatchEnd=function()
	    print(_R.roomname,"房间名称")
        print(_R.exits)
		local dx=Split(_R.exits,";")
		local _dir=""
		for _,d in ipairs(dx) do
		   if d~="enter" and d~="out" then
		      _dir=d
			  break
		   end
		end
		if _dir=="" then
			_dir=string.gsub(_R.exits,";","")
		end
		--print(_dir)
		local rev_dir=get_dir(_dir)
		--print(rev_dir," rev")
		local path=_dir..";"..rev_dir
		path=short_dir(path)
		--print(path)
		if _R.roomname=="黄土坪" or _R.roomname=="大石桥" then
		   path="w;e"
		elseif _R.roomname=="祭坛" and _R.zone=="华山" then
		   world.Send("out")
		   path="w;e"
		elseif _R.roomname=="谷中小路" or _R.roomname=="清池" then
		   path="n;s"
		elseif _R.roomname=="山间小路" then  --寒潭有busy
		   path="wu;ed"
		elseif _R.roomname=="冷杉林" then
		   path="se;nw"
		elseif _R.roomname=="草棚" and _R.zone=="回疆" then
		   path="s;n"
		elseif _R.roomname=="擂台前广场" then
		   path="n;s"
		elseif _R.roomname=="报国寺禅房" then
		   world.Send("e")
		   path="s;n"
		end
		self:shiwei()
		self:go(path)
	end
	_R:CatchStart()
end

function tiandi:reset()
end

local wave=1
function tiandi:back()
	 if self.is_end==true then
	    self:jobDone()
	    return
	 end

	 print("关闭警戒触发器,回到联络人处！！")
	 shutdown()
	 self:shield()
	 if self.fighting==false then
		  self:reset()
		end
	 if self.is_wander==true then
	    steps=0
		self:task_failure()
		self:wander()
	    return
	 end

	 print("是否到达目的地:",self.is_combat)
	 if self.is_combat==true and wave<=8 then
	    print(wave,"波次")
	     --shutdown()
		 wave=wave+1
	     self:shiwei()
		 self:reward()
		 check_fight=true
		 self:combat()
	     --self:test_combat()  --检测战斗中
		 return
	 elseif self.is_combat==true and wave>8 then
	   local b=busy.new()
	   b.Next=function()
	    self:giveup() --异常
	   end
	   b:jifa()
		return
	 end
	--[[ if self.is_combat==true and check_fight==false then
	     print("是否战斗结束:",self.is_fight)
		 self:shiwei()
		 self:reward()
		 check_fight=true
		 self:combat()
	     self:test_combat()  --检测战斗中
		 return
	 end
	 check_fight=false
	 wave=1
	 if self.is_combat==true and self.is_move==false then
	    print("随机移动")

		local _R={}
        _R=Room.new()
        _R.CatchEnd=function()
			local ex={}
			ex=Split(_R.exits,";")
			local n=math.random(table.getn(ex))
			print(n)
			local f=function()
			    self:back()
			end
			local dx=ex[n]
			print("发送方向:",dx)
			--self.is_combat=false
			self.is_move=true
			world.Send(dx)
			--self:shiwei()
			self:combat()
			self:reward()
			f_wait(f,5)

		end
	     _R:CatchStart()
		 return
	 end]]
	self.is_move=false
   local rooms=self.link_man_room
   if self.link_man_room[1]~="1965" then
	   rooms=depth_search(rooms,1)
   else
      print("回星宿海")
   end

   local npc=self.link_man
   self:task_failure()
   tiandi.co=coroutine.create(function()
     for _,r in ipairs(rooms) do
        local w=walk.new()
	    local al
        al=alias.new()
		al.do_jobing=true
		al:SetSearchRooms(rooms)
        al.break_in_failure=function()
		  self:giveup()
	    end

		  al.maze_done=function()
		      print("检查")
	          self:checkNPC(self.npc,al.maze_step)
		  end
		  al.zoulang_shufang=function()
			  self:NextPoint()
		  end

		  if self.link_man_room[1]=="1965" then
		    al.alias_table["xingxiuhai_north"].is_search=true
		  end

		  al.shangan=function()
                wait.make(function()
               local l,w=wait.regexp("^(> |)只听“轰”的一声，小木筏好象撞到了什么东西，你一下在子被抛了出来。$|^(> |)你回头一看，小木筏撞得散架，沉到海里了。$|^(> |)小木筏顺着海风，一直向东飘去。$",5)
	          if l==nil then
	              al:shangan()
	             return
			  end
	         if string.find(l,"只听“轰”的一声，小木筏好象撞到了什么东西，你一下在子被抛了出来") or string.find(l,"你回头一看，小木筏撞得散架，沉到海里了") then
	 	        local b=busy.new()
	 	        b.Next=function()
		         local shield=world.GetVariable("shield") or ""
	             if shield~="" then
	               world.Execute(shield)
				 end
				 print("防止出错!")
				 wait.time(3)
  	             al:finish()
		        end
		        b:check()
	            return
	         end
	        if string.find(l,"小木筏顺着海风，一直向东飘去") then
	          world.Send("hua mufa")
	          al:shangan()
			  return
	        end
			wait.time(5)
         end)
        end

		w.noway=function()
		    self:NextPoint()
		end
		w.delay=0.8
		w.Max_Step=5
		w.user_delay=1
	    w.user_alias=al
        --self:dog_claw()
		self:shiwei()
        self:reward()

        w.walkover=function()
         local f=function(e)
          self:checkPlace(e,r)
	     end
	     WhereAmI(f,10000)
        end
      w:go(r)
	  coroutine.yield()
    end
	print("没有找到联络人!!!")
	if count<3 then
	  self:back()
	  count=count+1
	else
	  local b=busy.new()
	  b.Next=function()
	     self:giveup()
	  end
	  b:jifa()
	end
   end)
   self:NextPoint()
end

function tiandi:giveup()
      local select_pfm=world.GetVariable("tdh_pfm")
   local pfm=world.GetVariable(select_pfm)
     --local pfm=world.GetVariable("pfm") or ""
    world.Send("alias pfm "..pfm)
	--world.SetVariable("pfm",pfm)
	print("reset pfm")
	self:reset()
  local w=walk.new()
  w.walkover=function()
     world.Send("ask shikai about 放弃")
	 local l,w=wait.regexp("^(> |)李式开说道：「既然你做不了，也就算了。」$|^(> |)李式开说道：「你又没领过任务，放弃什么啊？」$|^(> |)李式开说道：「你又没领过任务，放弃什么(啊|呀)？」$|^(> |)李式开说道：「你已经与.*联系上了，还是快点去和.*会合吧！」",5)
	 if l==nil then
	   --print("超时")
	   self:giveup()
	   return
	 end
	 if string.find(l,"既然你做不了，也就算了") or string.find(l,"你没有领任务，和我嚷嚷什么") or string.find(l,"你又没领过任务") then
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
			local f=function()
			      self:Status_Check()
			end
			Weapon_Check(f)
	   end
	   b:check()
	   return
	 end
	 if string.find(l,"联系上了") then
	   self:jobDone()
	   return
	 end
     wait.time(5)
  end
  w:go(104)
end
--[[
远处飞奔过来个人影，边跑边叫：“御前侍卫第韬在此！天地会反贼休走！”。
第韬叫道：“缉拿钦犯，闲杂人等闪开！”说罢便与你战在了一起。
第韬直向周维扑了过去，嘴里大喊道：“反贼！快快束手就擒吧！”
看起来第韬想杀死你！
]]
--周维决定跟随你一起行动。
--[[
一个官差模样的人向周维道：‘反贼周维，老子奉命来拿你，走一趟吧！’
周维哼道：“安益坤，你去死吧！”。
安益坤怒道：“官府缉拿钦犯，闲杂人等闪开！”说罢便与周维战在了一起。]]
--恭喜你任务顺利完成，你获得了三百五十点经验，九十八点潜能的奖励。
--糟了！舒武死亡，任务失败！
function tiandi:recover()
  if self.is_end==true then  --
     print("已经获得奖励")
	 self:jobDone()
	 return
  end
  print("警戒中")
  self:shiwei()
  if self.fighting==true then
	    print("正在战斗中，停止打坐")
	    return
  end
  world.Send("yun recover")
  world.Send("yun refresh")
  check_fight=false
    local h
	h=hp.new()
	h.checkover=function()
	    if h.jingxue_percent<95 then --避免中毒一直liao jing
		    local rc=heal.new()
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then --受伤了
		    print("打通经脉")
            local rc=heal.new()
			 rc.buy_drug=function()
			    --丹药用完自动quit
			   sj.world_init=function()
				 self:relogin()
			   end
			   local b=busy.new()
		       b.Next=function()
			     relogin(180,true)
			   end
			   b:check()
			 end
			rc.auto_drug=function()
			  print("吃大还丹")
			  --world.Send("fu dahuan dan")

			  local f=function()
			    rc:heal(false)
			  end

			  rc:eat_drug("大还丹","dahuan dan",f)
			end
			rc.hudiegu=function()
			  rc:heal(false)
			end
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
			    if self.fighting==true then
	                print("正在战斗中，停止打坐")
					return
                end
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun jing")
				  world.Send("yun recover")
				  local f=function()
				     self:recover()
				  end
				  f_wait(f,2)
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
			          self:recover()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
			    if self.fighting==true then
                   print("正在战斗中，停止打坐")
	               return
               end
			   world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			      print("状态恢复")
				  self:back()
			   else
	             print("继续修炼")
		         self:recover()
			   end
			end
			x:dazuo()
		else
		     print("状态良好")
		     self:back()
		end
	end
	h:check()
end

function tiandi:combat()

end

--御前侍卫 丁健吉(Ding jianji)
function tiandi:shiwei_escape()
  --侍卫逃跑
  --做- 法
  --贝时转眼间走的无影无踪。支礼「啪」的一声倒在地上，挣扎着抽动了几下就死了。公羊亿转眼间走的无影无踪。
  --print("侍卫逃跑触发")
  wait.make(function()
    local l,w=wait.regexp("^(> |)(.*)转眼间走的无影无踪。$|^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了。$",5)
	if l==nil then
	   self:shiwei_escape()
	   return
	end
	if string.find(l,"转眼间走的无影无踪") then
	   print("escape")
       for index,item in ipairs(self.shiwei_list) do
	      if string.find(item.name,w[2]) then
		     print("移除",item.name)
		     table.remove(self.shiwei_list,index)
			 break
		  end
	   end
	   print("数量:",table.getn(self.shiwei_list))
	   if table.getn(self.shiwei_list)>0 then
	     self:shiwei_escape()
		else
		 self:sure_shiwei()
	   end
	   return
	end
	if string.find(l,"挣扎着抽动了几下就死了") then
	   for index,item in ipairs(self.shiwei_list) do
	      if string.find(item.name,w[4]) then
		     print("移除",item.name)
		     table.remove(self.shiwei_list,index)
			 break
		  end
	   end
	   if table.getn(self.shiwei_list)>0 then
	     self:shiwei_escape()
		else
		  self:sure_shiwei()
	   end
	   return
	end
	wait.time(5)
  end)
end

function tiandi:sure_shiwei() --确认shiwei name id事件
   print("侍卫人数:",table.getn(self.shiwei_list))
end

function tiandi:kill_shiwei()
  wait.make(function()
     local l,w=wait.regexp("^(> |)这里禁止战斗。$|^(> |)这里不准战斗。$",10)
	 if l==nil then
	    self:kill_shiwei()
	    return
	 end
	 if string.find(l,"这里禁止战斗") or string.find(l,"这里不准战斗") then
	    print("禁止战斗")
	    shutdown()
		local f=function()
	     self:back()
		end
		f_wait(f,0.8)
	    return
	 end

  end)
end

function tiandi:shield()

end

function tiandi:look_shiwei(shiwei_name)
   world.Send("look")
   world.Send("set action 检查")
  wait.make(function()
   print("查看侍卫id:",shiwei_name)
   local l,w=wait.regexp("^(> |)\\s+御前侍卫\\s*"..shiwei_name.."\\\((.*)\\\).*$|^(> |)设定环境变量：action \\= \\\"检查\\\"",5)
   if l==nil then
     self:look_shiwei(shiwei_name)
     return
   end
   if string.find(l,"御前侍卫") then
      --if shiwei_name==nil or string.find(w[2],shiwei_name) then
        print("朝廷鹰爪:",shiwei_name)
        local shiwei_id=string.lower(Trim(w[2]))
		local _item={}
		_item.name=Trim(shiwei_name)
		_item.id=shiwei_id
		table.insert(self.shiwei_list,_item)
		--做+ 法
		world.Send("kill "..shiwei_id)
		if self.fighting==false then
		  self:reset()
		end
		self:sure_shiwei()
        self:kill_shiwei()
	    self:combat()
        return
	  --end
   end
   if string.find(l,"设定环境变量：action") then
      self.fighting=false
      self:recover()
      return
   end
   wait.time(5)
  end)
end
--[[
> 看起来东方封想杀死你！
看起来曹武作想杀死你！
看起来汤蒙想杀死你！
淳于谦声嘶力竭地叫道，“大伙并肩子上啊！”。
围观的人群中突然有人喊道：‘御前侍卫汤蒙等在此！反贼休走！’。
汤蒙叫道：“缉拿钦犯，闲杂人等闪开！”说罢便与和谐风等战在了一起。
--]]
function tiandi:shiwei()
  wait.make(function()
    --local l,w=wait.regexp("^(> |)一个官差模样的人向"..npc.."道：‘反贼"..npc.."，老子奉命来拿你，走一趟吧！’",5)
	--周拓哉叫道：“缉拿钦犯，闲杂人等闪开！”说罢便与你战在了一起。
	--周拓哉直向南夫扑了过去，嘴里大喊道：“反贼！快快束手就擒吧！”
--[[
	get gold from corpse
警戒中
yun recover
yun refresh
hp
> 你找不到 corpse 这样东西。
> 欧阳江作揖道：“ 亢威兄、秋猫兄，路上辛苦了，多谢秋猫兄相助！”
欧阳江对你道：“看来靼子来势汹汹，我们还是分别撤退吧。”
欧阳江抱拳道：“青山不改，绿水常流，咱们后会有期！”
恭喜你！你成功的完成了天地会任务！你被奖励了：
一千三百八十六点经验!
四百六十二点潜能!
八百九十七点正神！
你静下心来，反复回想刚才的任务过程，不禁豁然开朗。。你额外地得到了一千零三十九点经验！
]]
	 local player_name=world.GetVariable("player_name")
	 local l,w=wait.regexp("^(> |)(.*)(叫|怒)道：“.*闲杂人等闪开！”说罢便与("..self.hero_name.."|你)战在了一起。$|^(> |)(.*)(叫|怒)道：“.*闲杂人等闪开！”说罢便与"..player_name.."等战在了一起。$|^(> |)糟了！.*死亡，任务失败！$|^(> |)"..self.npc.."抱拳道：“青山不改，绿水常流，咱们后会有期！”$",5)
     if l==nil then
	    self:shiwei()
		return
	 end
	 if string.find(l,player_name) then
	     print("鬼鬼祟祟2!!!")
		 shutdown()
		 if self.fighting==false then
		  self:reset()
		end
		 self:shiwei()
		 self.is_combat=true
		 self:combat()
		 self:wait_reward()
		return
	 end
	 if string.find(l,"咱们后会有期") then
	    shutdown()
		 print("tdh ok1")
           local rc=reward.new()
			rc.finish=function()
			   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."天地会任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on white
			end
			 rc:get_reward()

		  --f_wait(f,0.8)
		 self:jobDone()
	    return
	 end
	 if string.find(l,"战在了一起") then
	    print("御前侍卫"..w[2])
	    shutdown()
		if self.fighting==false then
		  self:reset()
		end
	    self.fighting=true
		self:look_shiwei(w[2])
		self:shiwei_escape()
        self:shiwei()
		return
	 end
	 if string.find(l,"任务失败") then
	    shutdown()
		local f=function()
		  print("任务失败,延迟3s")
	      self:giveup()
		end
		f_wait(f,3)
	    return
	 end
   end)
end

function tiandi:guard(npc,id)

     id=string.lower(id)
	   wait.make(function()
		  self:shield()
	  	   wait.time(1.5)
	       world.Send("ask "..id.." about 天地会")
	       wait.time(2)

           world.Send("ask "..id.." about 反清复明")
	   local l,w=wait.regexp("^(> |)"..npc.."决定跟随你一起行动。|^(> |)"..npc.."挺了挺胸，神气地对你说：那当然啦。$|^(> |)这里没有这个人。$",5)
	   if l==nil then
	    self:guard(npc,id)
	    return
	   end
	   if string.find(l,"这里没有这个人") then
	      shutdown()
		  self:NextPoint()
	      return
	   end
	   --御前侍卫 廖破(Liao po)
	   if string.find(l,"决定跟随你一起行动") then
	   	  local ts={
	           task_name="天地会",
	           task_stepname="返回",
	           task_step=5,
	           task_maxsteps=5,
	           task_location=self.link_man_room[1],
	           task_description="",
	       }
	      local st=status_win.new()
	      st:init(nil,nil,ts)
	      st:task_draw_win()
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."天地会任务:返回地点:"..self.link_man_room[1], "white", "black")
		print("等待御前侍卫")
		self:auto_pfm()
		self.shiwei_list={}
		self:shiwei(npc)
		wait.time(8)
		print("侍卫哥哥你去哪里了?")
		count=1
		self:back()
	    return
	   end
	   if string.find(l,"挺了挺胸，神气地对你说") then
		self:look_shiwei()
	    return
	   end
       wait.time(5)
	   end)
end

function tiandi:Status_Check()

	 	 	 	 local ts={
	           task_name="天地会",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 self.is_end=false
	 self.is_combat=false
	 self.fighting=false
	local vip=world.GetVariable("vip") or "普通玩家"
	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="荣誉终身贵宾" then
		   print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
		     if h.food<50 then
		       world.Send("ask xiao tong about 食物")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get fan")
			  	 world.Execute("eat fan;eat fan;eat fan;eat fan;drop fan")
				 local f
				 f=function()
				   self:Status_Check()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 elseif h.drink<50 then
			   world.Send("ask xiao tong about 茶")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get cha")
			  	 world.Execute("drink cha;drink cha;drink cha;drop cha")
				 local f
				 f=function()
				    self:Status_Check()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 end
		   end
		   w:go(133) --299 ask xiao tong about 食物 ask xiao tong about 茶
		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
		    print("疗伤")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill
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

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=300
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==1 then
				  world.Send("yun recover")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
				end
				if id==777 then
				  self:Status_Check()
				end
				if id==201 then
				  world.Send("yun regenerate")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
			    end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(103)
			   end
			end
			x.success=function(h)

			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
			   else
	             print("继续修炼")
				 world.Send("yun qi")
		         x:dazuo()
			   end
			end
			x:dazuo()
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

function tiandi:task_failure()
   wait.make(function()
     local l,w=wait.regexp("糟了！.*死亡，任务失败！",20)
	 if l==nil then
	   self:task_failure()
	   return
	 end
	 if string.find(l,"任务失败") then
	    shutdown()
		self:jobDone()
	    return
	 end
     wait.time(20)
   end)
end
--糟了！水本死亡，任务失败！
