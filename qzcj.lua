require "wait"
require "map"
require "cond"
require "status_win"
chujian={
  new=function()
     local cj={}
	 setmetatable(cj,chujian)
	 return cj
  end,
  co=nil,
  name="",
  id="",
  place="",
  neili_upper=1.9,
  --blacklist="天狼子|干光豪|出尘子|五毒教女弟子|浪荡公子|富家公子|茅十八|洪哮天|岭南大盗|梁子翁|劳德诺|周孤桐|吴柏英|摘星子|狮吼子|黯然子|蒙古卫士|史镖头|王夫人|赵敏|吕文德|侯君集|忽必烈|达尔巴|龙卷风|马掌柜|张浩天|黄令天|贾布|薛慕华",
}
chujian.__index=chujian
--[[
你向吴长老打听有关『job』的消息。
吴长老说道：「好吧，最近「江北大盗」一直和我丐帮作对，你前去设法将此人除掉！」
吴长老说道：「此人现在在沧州城大驿道一带，务必在辛卯年六月二十二日寅时三刻之前赶回来。」


你给吴长老一颗江北大盗的首级。
>
yun refresh
( 你上一个动作还没有完成，不能施用内功。)
> 吴长老对着你竖起了右手大拇指，好样的。
吴长老说道：「你为丐帮立下了功劳，我们绝不会亏待你的。」
吴长老伏身在你耳边悄声指点了你一些武功要领...
你觉得脑中豁然开朗，增加了四十五点潜能和一百一十二点经验！

]]

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

function chujian:shield()
end

function chujian:catch_place()
  wait.make(function()
    local l,w=wait.regexp("^(> |)丘处机对你说道，“据门中飞鸽传书得知，金国奸细应该在(.*)一带活动，你速去将他除去！$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"金国奸细应该在") then
	  self.place=w[2]
	  --world.AppendToNotepad (WorldName(),os.date().." 所在地:".. w[2].."\r\n")
	    --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."丐帮任务:工作地点"..self.place, "red", "black") -- black on white
	  self:find()
	  return
	end

  end)
end

function chujian:catch_badman()
  local playername=world.GetVariable("playername") or ""
  wait.make(function()
    local l,w=wait.regexp("^(> |)丘处机对你说道，“光王，此人乃是金国完颜洪烈的贴身护卫，乔装打扮入我大宋！”$|^(> |)吴长老说道：「现在我这里没有给你的任务，你去其他地方看看吧？」$|^(> |)吴长老说道：「现在我可没有给你的任务，等会再来吧！」$|吴长老说道：「你连上个任务去都不想去，是想找近的吧？等会再来！」",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"一直和我丐帮作对，你前去设法将此人除掉") then
	  self:catch_place()
	  --world.AppendToNotepad (WorldName(),os.date()..": 把他做掉:".. w[2].."\r\n")
      --self.name=w[2]
	  --print(self.name)
	  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."丐帮任务:杀掉"..self.name, "red", "black") -- black on white
	  return
	end
	if string.find(l,"现在我这里没有给你的任务，你去其他地方看看吧") then
	  self.fail(101)
	  return
	end
	if string.find(l,"现在我可没有给你的任务，等会再来吧") then
	  self.fail(102)
	  return
	end
	if string.find(l,"你连上个任务去都不想去，是想找近的吧？等会再来") then
	  self:giveup()
	  return
	end
	wait.time(5)
  end)
end

function chujian:ask_job()
  local w=walk.new()
  local al=alias.new()
  al.do_jobing=true
  w.user_alias=al
  w.walkover=function()
   wait.make(function()
	--CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."丐帮任务:工作开始!", "yellow", "black") -- black on white
    world.Send("ask qiu about 全真锄奸")
    local l,w=wait.regexp("^(> |)你向丘处机打听有关『全真锄奸』的消息。$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"你向丘处机打听有关") then
	  self:catch_badman()
	  --BigData:catchData(1345,"丐帮")
	  return
	end
	wait.time(5)
   end)
  end
  w:go(4152)
end
--[[
function chujian:exps()
  wait.make(function()
    local l,w=wait.regexp("^(> |)你觉得脑中豁然开朗，增加了(.*)点潜能和(.*)点经验！",5)
    if l==nil then
	  self:exps()
	  return
	end
	if string.find(l,"你觉得脑中豁然开朗") then
       --world.AppendToNotepad (WorldName(),os.date()..": 丐帮job 经验:".. ChineseNum(w[3]).." 潜能:"..ChineseNum(w[2]).."\r\n")
	   local exps=world.GetVariable("get_exp")
	   exps=tonumber(exps)+ChineseNum(w[3])
	   world.SetVariable("get_exp",exps)
	   world.AppendToNotepad (WorldName(),os.date().."目前获得总经验值"..exps.."\r\n")
	   return
	end
	wait.time(5)
  end)

end]]

function chujian:reward()
	local ts={
	           task_name="锄奸任务",
	           task_stepname="奖励",
	           task_step=4,
	           task_maxsteps=4,
	           task_location=self.place,
	           task_description=self.name,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	chujian.co=nil
  local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("give ling to qiu chuji")
    local playername=world.GetVariable("playername") or ""
    local l,w=wait.regexp("^(> |)丘处机说道：「很好，"..playername.."，既然你把这这奸细给杀了，为国为民，侠之大者！」$|^(> |)你身上没有这样东西。$|^(> |)吴长老说道：「我好象没有给过你任务啊？」$",5)
	if l==nil then
	  self:reward()
	  return
	end
	if string.find(l,"既然你把这这奸细给杀") then
	  --self:exps()
	  --[[local rc=reward.new()
	  rc.finish=function()
	       --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."丐帮任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- black on white
		  local b=busy.new()
	       b.interval=0.3
	       b.Next=function()
	         self:jobDone()
	       end
	       b:check()
	  end
	  rc:get_reward()]]

	  --BigData:catchData(1345,"丐帮")
      local b=busy.new()
	       b.interval=0.3
	       b.Next=function()
	         self:jobDone()
	       end
	       b:check()
	  return
	end
	if string.find(l,"过你任务啊") then
	   local b=busy.new()
	   b.check=function()
	     world.Send("drop shouji")
	     self:giveup()
	   end
	   b:check()
	   return
	end
	if string.find(l,"你身上没有这样东西")  then
	   self:giveup()
	   return
	end
	wait.time(5)
   end)
  end
  w:go(4152)
end

function chujian:combat()

end
--[[
function chujian:qie_corpse(index)
local b=busy.new()
b.interval=0.5
b.Next=function()
  wait.make(function()
    --world.Send("get all from corpse")
   world.Send("wield jian")
   if index==nil then
       world.Send("get gold from corpse")
	   world.Send("get silver from corpse")
       world.Send("qie corpse")
	else
	   world.Send("get gold from corpse "..index)
	   world.Send("get silver from corpse "..index)
	   world.Send("qie corpse ".. index)
   end
   local l,w=wait.regexp("^(> |)只听“咔”的一声，你将"..self.name.."的首级斩了下来，提在手中。$|^(> |)乱切别人杀的人干嘛啊？$|^(> |)那具尸体已经没有首级了。$|^(> |)找不到这个东西。$|^(> |)那具尸体已经腐烂了。$|(> |)你手上这件兵器无锋无刃，如何能切下这尸体的头来？$|^(> |)你得用件锋利的器具才能切下这尸体的头来。$",5)
   if l==nil then
      self:qie_corpse(index)
	  return
   end
   if string.find(l,"乱切别人杀的人干嘛啊") or string.find(l,"那具尸体已经没有首级了") or string.find(l,"那具尸体已经腐烂了") then
      if index==nil then
	     index=2
	  else
	     index=index+1
	  end
      self:qie_corpse(index)
      return
   end
   if string.find(l,"找不到这个东西") then
      self:giveup()
      return
   end
   if string.find(l,"首级斩了下来，提在手中") then
      local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	    local sp=special_item.new()
   	     sp.cooldown=function()
		     if self.name=='吕文德' then
			     self:wait_wanted()
		     else
                 self:reward()
		     end
         end
        sp:unwield_all()
	  end
	  b:check()
      return
   end
    if string.find(l,"你手上这件兵器无锋无刃，如何能切下这尸体的头来") or string.find(l,"你得用件锋利的器具才能切下这尸体的头来") then
      local sp=special_item.new()
   	  sp.cooldown=function()
	    local f=function()
          self:qie_corpse(index)
		end
		local error_deal=function()
		     self:get_weapon()
		end
		local do_again=function()
		  world.Send("i")
	  	  self:auto_wield_weapon(f,error_deal)
		  world.Send("set look 1")
		end
		f_wait(do_again,0.5)
      end
      sp:unwield_all()
      return
   end
   wait.time(5)
  end)
 end
 b:check()
end
function chujian:get_weapon()
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
      local w=walk.new()
	  w.walkover=function()
	     world.Send("get changjian")
		 world.Send("get dao")
		 --
		 print("没有合适武器砍头,任务失败!!")
		 self:giveup()

	  end
	  w:go(roomno)
   end
   b:check()
end

function chujian:auto_wield_weapon(f,error_deal)
--你将凝晶雁翎箫握在手中。你「唰」的一声抽出一柄长剑握在手中。

   wait.make(function()
	 local l,w=wait.regexp("(.*)\\((.*)\\)$|^(> |)设定环境变量：look \\= 1$",5)
    if l==nil then
	   self:auto_wield_weapon(f,error_deal)
	   return
	end
	if string.find(l,")") then
	   --print(w[1],w[2])
	   local item_name=w[1]
	   local item_id=string.lower(w[2])
      if (string.find(item_id,"sword") or string.find(item_id,"jian") or string.find(item_id,"lanyu duzhen")) and (string.find(item_name,"剑") or string.find(item_name,"蓝玉毒针")) then
         world.Send("wield "..item_id)
		  self.weapon_exist=true
      elseif (string.find(item_id,"axe") or string.find(item_id,"fu")) and string.find(item_name,"斧") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"blade") or string.find(item_id,"dao") or string.find(item_id,"xue sui")) and string.find(item_name,"刀") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"dagger") or string.find(item_id,"bishou")) and string.find(item_name,"匕") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
	  end
	  self:auto_wield_weapon(f,error_deal)
	  return
	end
    if string.find(l,"设定环境变量：look") then
	   --print(self.weapon_exits,"值")
	   if self.weapon_exist==true then
	      f()
	   else
	     print("没有合适武器!!，建议购买武器!")
         error_deal()
	   end
	   return
	end
	wait.time(5)
   end)
end
]]
function chujian:wait_wanted()
  local w=walk.new()
  w.walkover=function()
      world.Send("enter")
      wait.make(function()
      local l,w=wait.regexp("^(> |)门卫上前把手一伸：你的武功够高了，在武馆学不到什么了。$",5)
      if l==nil then
	     self:wait_wanted()
	     return
	  end
	  if string.find(l,"在武馆学不到什么了") then
         self:reward()
	     return
	  end
	  wait.time(5)
      end)
   end
   w:go(155)
end

function chujian:run(dx,i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)你逃跑失败。$|^(> |)你的修为不够！$|^(> |)设定环境变量：action \\= \\\"逃跑\\\"$",1.5)
	   if l==nil then
	      self:run(dx,i)
	      return
	   end
	   if string.find(l,"你的修为不够") then
	     i=i+1
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
	   wait.time(1.5)
  end)
end

function chujian:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("寻找出口")
     local dx=_R:get_all_exits(_R)
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
--此人看上去师承日月神教，擅长使用七弦无形剑伤敌！
--[[
function chujian:kill(npc,id)
  	local ts={
	           task_name="锄奸任务",
	           task_stepname="战斗",
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  self:combat()
  self:wait_badman_die()

  wait.make(function()
    --print("kill"..id)

	world.Send("follow "..id)
    world.Send("kill "..id)
	local l,w=wait.regexp("^(> |)你正打不还手呢，怎么杀？$",5)
	if l==nil then

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

function chujian:is_ok(name)
   --print(name)
   local lists=self.blacklist
   --print(lists)
   if lists==nil then
       --print("ok")
      lists="干光豪|出尘子|五毒教女弟子|茅十八|洪哮天|梁子翁|劳德诺|周孤桐|吴柏英|摘星子|狮吼子|黯然子|蒙古卫士|史镖头|王夫人|赵敏|吕文德|侯君集|忽必烈|达尔巴|龙卷风|马掌柜|张浩天|黄令天"
   end
   if lists~="" then

    local items=Split(lists,"|")
	 for _,i in ipairs(items) do
	     if i==name then
		    return false
		 end
	 end
   end
   return true
end

function chujian:test(place,name)

  local ts={
	           task_name="丐帮任务",
	           task_stepname="寻找NPC",
	           task_step=2,
	           task_maxsteps=4,
	           task_location=place,
	           task_description=name,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	--
	local name=Trim(name)
	local result=self:is_ok(name)
	 if result==false then
	   self:giveup()
	   print("运气不好不能怪政府！！")
	   return
	 end
	if zone_entry(place)==true then
      self:giveup()
      return
    end

   local n,rooms=Where(place)
   if name=="江北大盗" then
      n=1
	  rooms={1445}
   end
	if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	   chujian.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		      self:giveup()
		  end

		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
		    self:giveup()
		  end
		  al.do_jobing=true
		  w.user_alias=al
		  w.walkover=function()
		    print("寻找"..name)
		    self:checkNPC(name,r)
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
end]]

function chujian:find()

	local ts={
	           task_name="锄奸任务",
	           task_stepname="寻找NPC",
	           task_step=2,
	           task_maxsteps=4,
	           task_location=self.place,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	--
	--local name=Trim(self.name)
	--local result=self:is_ok(name)
	 --if result==false then
	  -- self:giveup()
	  -- print("运气不好不能怪政府！！")
	  -- return
	 --end
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
	   self:shield()
	   chujian.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
		    self:giveup()
		  end
		  al.do_jobing=true
		  w.user_alias=al
		  w.walkover=function()
		    --print("寻找"..self.name)
		    --self:checkNPC("",r)
			self:checkSpy(r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("没有找到npc!!")
		self:giveup()
	   end)
	   self:findSpy()
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

function chujian:jobDone()
end

function chujian:giveup()
 chujian.co=nil
 local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask qiu about 放弃")
    local l,w=wait.regexp("^(> |)你向丘处机打听有关『放弃』的消息。$",5)
	if l==nil then
	  self:giveup()
	  return
	end
	if string.find(l,"你向丘处机打听有关") then
	   --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."丐帮任务:放弃", "pink", "black") -- black on white
	    --BigData:catchData(1345,"丐帮")
	  local b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	     self:Status_Check()
	  end
	  b:check()
	  return
	end
	--wait.time(5)
   end)
  end
  w:go(4152)
end

function chujian:NextPoint()
   print("进程恢复")
   coroutine.resume(chujian.co)
end

function chujian:checkPlace(r,here)
      if is_contain(r,here) then
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
	     local w=walk.new()
		  local al
		  al=alias.new()
		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
		     self:giveup()
		  end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    --self:checkNPC("",r)
			self:checkSpy(r)
		  end
		  w:go(r)
	   end
end

function chujian:badman_die()
end

function chujian:wait_badman_die()
wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了。$",5)
	 if l==nil then
	    self:wait_badman_die()
	    return
	 end
	 if string.find(l,"挣扎着抽动了几下就死了") then
	    --print(self.name,w[2])
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

function chujian:look_id(npc,id)
  world.Send("look "..id)
  world.Send("set action 门派")
  wait.make(function()
     local l,w=wait.regexp("^(> |)此人看上去师承(.*)，擅长使用(.*)伤敌！$|^(> |)你要看什么？$|^(> |)设定环境变量：action \\= \\\"门派\\\"$",5)
	 if l==nil then
       self:look_id(npc,id)
	   return
	 end
	 if string.find(l,"你要看什么") then
	    self:giveup()
	    return
	 end
	 if string.find(l,"设定环境变量：action") then
	    self:check_auto_kill_npc(npc,id)
	    return
	 end
	 if string.find(l,"此人看上去师承") then
		local party=w[2]
		local skill=w[3]
		CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."丐帮任务:门派 ".. party.." skill "..skill, "white", "black")
		local lists=self.blacklist

        local items=Split(lists,"|")
	    for _,b in ipairs(items) do
	      if b==party or b==skill then
			 self:giveup()
		     return
		   end
	    end
		self:check_auto_kill_npc(npc,id)
	    --self:kill(npc,id)
	    return
	 end

  end)
end

function chujian:check_auto_kill_npc(npc,id)
   wait.make(function()
     world.Send("look")
	 world.Send("set look 1")
	 world.Send("unset wimpy")
	 --老虎 熊 豹 蛇 野猪 巨蟒
	 local regexp
	 --if self.auto_kill_npc~="" and self.auto_kill_npc~=nil then
	    regexp=".*(白熊|黑熊|老虎|蛇|豹子|野猪|巨蟒|野狼|灰狼|马贼|值勤兵|大狼狗|帮众|毒蟒|教众|鳄鱼)\\(.*\\).*|^(> |)设定环境变量：look \\= 1$"
	--else
 	--    regexp=".*(白熊|黑熊|老虎|蛇|豹子|野猪|野狼|灰狼|巨蟒|马贼|值勤兵|大狼狗|帮众|毒蟒|教众|鳄鱼)\\(.*\\).*|^(> |)设定环境变量：look \\= 1$"
	--end
	 local l,w=wait.regexp(regexp,10)
	 if l==nil then
	    self:check_auto_kill_npc(npc,id)
	    return
	 end

	 if string.find(l,"值勤兵") then
		world.Send("kill zhiqin bing")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"帮众") then
	     world.Send("kill bangzhong")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
		 return
	 end

	 if string.find(l,"马贼") then
	    world.Send("kill ma zei")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"熊") then
	    world.Send("kill bear")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"豹子") then
	    world.Send("kill bao")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	    return
	 end
	if string.find(l,"蛇") then
	    world.Send("kill snake")
		world.Send("kill she")
		world.Send("kill dushe")
		--world.Send("kill she")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"教众") then
	    world.Send("kill jiao zhong")
		--world.Send("kill she")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"老虎") then
	    world.Send("kill lao hu")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"野猪") then
	    world.Send("kill ye zhu")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end

	 if string.find(l,"巨蟒") or string.find(l,"毒蟒")  then
		 world.Send("kill mang")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"鳄鱼") then
	    world.Send("kill e yu")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"狼") then
		 world.Send("kill wolf")
		 world.Send("kill dog")
		 world.Send("kill lang")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"设定环境变量：look") then
	   self:kill(npc,id)
	   return
	 end

   end)
end
-->

function chujian:checkSpy(roomno)
    local NextPoint=function()
      local f=function(r)
		     self:checkPlace(roomno,r)
	  end
	  WhereAmI(f,10000) --排除出口变化
	end
	f_wait(NextPoint,1)
end

function chujian:findSpy()
   wait.make(function()

     local l,w=wait.regexp("^(> |)(.*)喋喋怪笑不断，既然发现了，那就纳命来吧！$",5)
	 if l==nil then
	    self:findSpy()
	    return
	 end
	 if string.find(l,"既然发现了") then
	     shutdown()
		local name=w[2]
		self.name=name
		self:combat()
	    return
	 end
   end)
end

--[[
function chujian:checkNPC(npc,roomno)
    wait.make(function()
      world.Execute("look;set action 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)设定环境变量：action \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
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
		  local id=string.lower(Trim(w[2]))
		  self.id=id
		  --print(id)
		  self:look_id(npc,id)
		  --self:kill(npc,id)
		  return
	  end
	  wait.time(6)
   end)
end]]

function chujian:eat()
    --[[local w=walk.new()
	w.walkover=function()
	      world.Execute("buy baozi")
		  world.Execute("eat baozi;eat baozi;eat baozi;drop baozi")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
	end
	w:go(976) --春在楼 976]]
	  print("eat")
		        w=walk.new()
		        w.walkover=function()
			      local b
			       b=busy.new()
			       b.interval=0.3
			       b.Next=function()
			          world.Execute("ask xiao tong about 食物")
				      local f
				      f=function()
				        local b1=busy.new()
				         b1.Next=function()
				           world.Execute("get fan;eat fan;eat fan;eat fan;drop fan")
					       self:full()
				         end
				         b1:check()
				       end
				      f_wait(f,1.5)
				   end
			       b:check()
		       end
			   w:go(133) --299 ask xiao tong about 食物 ask xiao tong about 茶
end

function chujian:drink()
     print("drink")
			    local w
		         w=walk.new()
		         w.walkover=function()
			      local b
			      b=busy.new()
			      b.interval=0.3
			      b.Next=function()
			         world.Send("ask xiao tong about 茶")
				     local f
				     f=function()
				      local b1=busy.new()
				       b1.Next=function()
				          world.Execute("get cha;drink cha;drink cha;drink cha;drop cha")
					      self:full()
				       end
				       b1:check()
				     end
				     f_wait(f,1.5)
			       end
			       b:check()
		          end
				 w:go(133) --299 ask xiao tong about 食物 ask xiao tong about 茶
end

function chujian:full()
   local vip=world.GetVariable("vip") or "普通玩家"
   local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="荣誉终身贵宾" then
		     if h.food<50 then
			    self:eat()
			 elseif h.drink<50 then
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
		elseif h.jingxue_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal(true,false)
		elseif h.neili<h.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                self:Status_Check()
            end
			r:wash()
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
				  --local _R
                  --_R=Room.new()
                  --_R.CatchEnd=function()
                    --local count,roomno=Locate(_R)
					--local target_roomno=nearest_room(roomno)
                    local w
		            w=walk.new()
		            w.walkover=function()
			          self:full()
		            end
		            w:go(1345)
                  --end
                 --_R:CatchStart()
			   end
			end
			x.success=function(h)
               world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
			   else
	             print("继续修炼")
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

function chujian:Status_Check()
	local ts={
	           task_name="锄奸任务",
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
				local s,e=string.find(i[1],"毒")
				 if s~=nil then
                    s=s%2
				 else
				    s=0
				 end
			     if i[1]=="星宿掌毒" or s==1 then
				   print("中毒了")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
			          self:Status_Check()
			        end
				    if rc.omit_snake_poison==true and i[1]=="蛇毒" then --忽略蛇毒

					else
			          rc:qudu(sec,i[1],false)
					  return
					end
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
			        rc:heal(true,true)
				    return
				 end
			   end
		     end
            self:full()
	end
	cd:start()
end
