
local heal_ok=false
huashan={
  new=function()
      heal_ok=false
    local hs={}
	 setmetatable(hs,huashan)
	 return hs
  end,
  co=nil,
  co2=nil,
  robbername="",
  robberid="",
  hs2=true,
  appear=false,
  run_hs2=false,
  dayun=false,
  weapon="",
  neili_upper=1.9,
  look_NPC=false,
  look_NPC_place="",
  rooms={},
  round=1,
  check_place_count=0,
  version=1.8,
}
huashan.__index=huashan

local combat_starttime=nil
function huashan:fail(id)
end

function huashan:catch_place()
   wait.make(function()
	   local l,w=wait.regexp("岳不群给了你一块令牌。|^(> |)岳不群说道：「现在没有听说有恶人为害百姓，你自己去修习武功去吧！」$|^(> |)岳不群说道：「你现在正忙着做其他任务呢！」$|^(> |)岳不群说道：「你不能光说呀，倒是做出点成绩给我看看！」$|^(> |)岳不群说道：「你眼露凶光, 还想去惩恶扬善.*$|^(> |)岳不群说道：你还没完成师傅的任务呢。$|^(> |)岳不群说道：「你还是先去思过崖面壁思过去吧。」$",5)
		if l==nil then
		   self:catch_place()
		   return
		end
		if string.find(l,"岳不群给了你一块令牌") then
		    local b=busy.new()
			b.interval=0.5
			b.Next=function()
			   self:songlin()
			end
			b:check()
			return
		 end
		 if string.find(l,"你自己去修习武功去吧") then
		    self.fail(101)
		    return
		 end
		 if string.find(l,"你现在正忙着做其他任务呢") then
		    self.fail(102)
		    return
		 end
		 if string.find(l,"你眼露凶光") then
		    self:look_zhengqidan()
		    return
		 end
		 if string.find(l,"你还没完成师傅的任务呢") or string.find(l,"你不能光说呀，倒是做出点成绩给我看看") then
		    local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:giveup()
			end
			b:check()
		    return
		 end
		 if string.find(l,"你还是先去思过崖面壁思过去吧") then
		    print (utils.msgbox ("开始解九剑！！！！", "Warning!", "ok", "!", 1)) --> ok
			world.Send("nick 开始解九剑！！！！")
		    local q=quest.new()
			q:jiujian()
		   return
		 end
        wait.time(5)
   end)
end

function huashan:ask_job()
  	local ts={
	           task_name="华山",
	           task_stepname="询问岳不群",
	           task_step=2,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --world.AppendToNotepad (WorldName().."_华山任务:",os.date()..": 华山job开始\r\n")
    CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."华山任务:工作开始!", "yellow", "black") -- black on white
   local w
   w=walk.new()
   local al=alias.new()
   al.do_jobing=true
   w.user_alias=al
   w.walkover=function()
     wait.make(function()
        world.Send("ask yue buqun about 惩恶扬善")

	     local l,w=wait.regexp("^(> |)你向岳不群打听有关『惩恶扬善』的消息。$",5)--你向岳不群打听有关『惩恶扬善』的消息。

		 if l==nil then
		    self:ask_job()
			return
		 end
		 if string.find(l,"你向岳不群打听有关") then
		    --print("抓取")
			--BigData:catchData(1532,"正气堂")
		    self:catch_place()
		    return
		 end


		 wait.time(5)
     end)
   end
   w:go(1532)
end

function huashan:giveup()
   --world.AppendToNotepad (WorldName().."_华山任务:",os.date()..": 任务失败,准备放弃!\r\n")
   dangerous_man_list_add(self.robbername)
   danerous_man_list_push()
   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."华山任务:放弃!", "red", "black") -- black on white
   local w
   w=walk.new()
   w.walkover=function()
   wait.make(function()
     world.Send("ask yue buqun about 失败")
      wait.make(function()
	     local l,w=wait.regexp("你向岳不群打听有关『失败』的消息。",5)
		 if l==nil then
		    self:giveup()
			return
		 end
		 if string.find(l,"失败") then
		    --BigData:catchData(1532,"正气堂")
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
		 wait.time(5)
	  end)
   end)
   end
   w:go(1532)

end

function huashan:exps()
   wait.make(function()
      local l,w=wait.regexp("^(> |)你获得了(.*)点经验，(.*)点潜能，.*点正神。$",5)
	  if l==nil then
	     self:exps()
		 return
	  end
	  if string.find(l,"你获得") then
       world.AppendToNotepad (WorldName(),os.date()..": 华山任务 获得经验:".. ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]).."\r\n")
	   local exps=world.GetVariable("get_exp")
	   exps=tonumber(exps)+ChineseNum(w[2])
	   world.SetVariable("get_exp",exps)
	   world.AppendToNotepad (WorldName(),os.date()..": 目前获得总经验值"..exps.."\r\n")
	   return
	  end
	  wait.time(5)
  end)
end

function huashan:xxdf()
    local player_name=world.GetVariable("player_name") or ""
	--^(> |)岳不群.*说道：「"..player_name.."，听说魔教教主被关在杭州西湖湖底，你去把他杀了，我就让你入五岳剑派。」$
    wait.make(function()
	   local l,w=wait.regexp("^(> |)岳不群说道：「"..player_name..".*听说魔教教主被关在杭州西湖湖底，你去把他杀了，我就让你入五岳剑派。」$",10)
	   if l==nil then

	      return
	   end
	   if string.find(l,"五岳剑派") then
	      world.Send("nick 吸星大法")
		  -- print (utils.msgbox ("开始解化功大法！！！！", "Warning!", "ok", "!", 1)) --> ok
	      return
	   end
	end)
end

function huashan:reward()
  dangerous_man_list_clear()
  	local ts={
	           task_name="华山",
	           task_stepname="奖励",
	           task_step=7,
	           task_maxsteps=7,
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
	 --self:exps()
	 local rc=reward.new()
	 world.Send("give ling to yue buqun")
	 rc:get_reward()
	--[[ 岳不群对着你竖起了右手大拇指，好样的。
岳不群说道：「还望小兄弟日后多行善事，必有好报。」
你获得了五十四点经验，十三点潜能，一百一十四点正神。
你给岳不群一块令牌。]]
      wait.make(function()
	     local l,w=wait.regexp("你给岳不群一块令牌。|^(> |)你身上没有这样东西。$|^(> |)岳不群说道：惭愧呀，华山派居然出了你这样的骗子！$",5)
		 if l==nil then
		    self:reward()
			return
		 end
		 if string.find(l,"你给岳不群一块令牌") then
            self:xxdf()
			--BigData:catchData(1532,"正气堂")
		    local b=busy.new()
			b.interval=0.5
			b.Next=function()
				CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."华山任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- black on white
			    self:jobDone()
			end
			b:check()
			return
		 end
		 if string.find(l,"你身上没有这样东西") or string.find(l,"华山派居然出了你这样的骗子") then
		   --print("bug!!!!")
		   self:giveup()
		   return
		 end
		 wait.time(5)
	  end)
   end)
   end
   w:go(1532)
end

function huashan:jobDone() --回调函数
end

function huashan:get_npc()
     world.Send("get ling from "..self.robberid)
	 world.Send("kill "..self.robberid)
	 self:wait_robber_die()
    --[[wait.make(function()


	    --world.Send("get "..self.robberid)
		local l,w=wait.regexp("^(> |)你将"..self.robbername.."扶了起来背在背上。$|^(> |)"..self.robbername.."对你而言太重了。$|^(> |)你的巫师等级必须比对方高，才能搜身。$|^(> |)你找不到 "..self.robberid.." 这样东西。$",5)
		if l==nil then
		   self:get_npc()
		   return
		end
		if string.find(l,"背在背上") then
		   shutdown()
		   self:jitan(self.robberid)
		   return
		end
        if string.find(l,"对你而言太重了") then
		   world.Send("kill "..self.robberid)
		   self:wait_robber_die()
		   return
		end
		if string.find(l,"才能搜身") then
		    world.Send("kill "..self.robberid)
			self:combat()
		    self:wait_robber_die()
		   return
		end
		if string.find(l,"你找不到") then
			self:giveup()
		    return
		end
	end)]]
end


function huashan:auto_wield_weapon(f,error_deal)
--你将凝晶雁翎箫握在手中。你「唰」的一声抽出一柄长剑握在手中。

   wait.make(function()
	 local l,w=wait.regexp("(.*)\\((.*)\\)$|^(> |)设定环境变量：action \\= \\\"砍头\\\"$",5)
    if l==nil then
	   --self:auto_wield_weapon(f,error_deal)
	   self:qie_corpse()
	   return
	end
	if string.find(l,")") then
	   --print("auto_wield_weapon",w[1],w[2])
	   local item_name=w[1]
	   local item_id=string.lower(w[2])
      if (string.find(item_id,"sword") or string.find(item_id,"jian")) and string.find(item_name,"剑") then
         world.Send("wield "..item_id)
		  self.weapon_exist=true
      elseif (string.find(item_id,"axe") or string.find(item_id,"fu")) and string.find(item_name,"斧") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"blade") or string.find(item_id,"dao")) and string.find(item_name,"刀") or string.find(item_id,"xue sui") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"dagger") or string.find(item_id,"bishou")) and string.find(item_name,"匕") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
	  end
	  self:auto_wield_weapon(f,error_deal)
	  return
	end
    if string.find(l,"设定环境变量：action") then
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

function huashan:get_corpse(index)
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
--   你将司徒同的尸体扶了起来背在背上。
--   你附近没有这样东西。
      if index==nil then
	     index=1
		  world.Send("get corpse")
	  else
		  world.Send("get corpse "..index)
	  end

	   local l,w=wait.regexp("^(> |)你将(.*)的尸体扶了起来背在背上。$|^(> |)你附近没有这样东西。$|^(> |)光天化日的想抢劫啊？$",3)
	   if l==nil then
	      self:get_corpse(index)
	      return
	   end
	   if string.find(l,"想抢劫") then
	       wait.time(0.5)
		   index=index+1
	       self:get_corpse(index)
	       return
	   end
	   if string.find(l,"的尸体扶了起来背在背上。") then
	      if w[2]==self.robbername then
            self:jitan()
		  else
		   index=index+1
		   world.Send("drop corpse")
           self:get_corpse(index)
		  end
		  return
	   end
	   if string.find(l,"你附近没有这样东西") then
	      self:giveup()
	      return
	   end
   end
   b:check()
end

function huashan:qie_corpse(index)
   --local f=function(arg)
    --  self:qie_corpse(arg)
   --end
   --thread_monitor("huashan:qie_corpse",f,{index})
  wait.make(function()
    world.Send("wield jian")
	if self.weapon~="" then
	   world.Send("wield "..self.weapon)
	end
   if index==nil then
      world.Send("get gold from corpse")
	  world.Send("get ling from corpse")
      world.Send("qie corpse")
	else
	   world.Send("get gold from corpse "..index)
	  world.Send("get ling from corpse "..index)
	  world.Send("qie corpse ".. index)
   end


   local l,w=wait.regexp("只听“咔”的一声，你将"..self.robbername.."的首级斩了下来，提在手中。|^(> |)乱切别人杀的人干嘛啊？$|^(> |)那具尸体已经没有首级了。$|^(> |)你找不到 corpse 这样东西。$|^(> |)找不到这个东西。$|(> |)你手上这件兵器无锋无刃，如何能切下这尸体的头来？$|^(> |)你得用件锋利的器具才能切下这尸体的头来。$|^(> |)不会吧，你对动物的尸体也感兴趣？$",5)
   if l==nil then
      self:qie_corpse()
	  return
   end
   if string.find(l,"乱切别人杀的人干嘛啊") or string.find(l,"那具尸体已经没有首级了") or string.find(l,"你对动物的尸体也感兴趣") then
      if index==nil then
	     index=2
	  else
	     index=index+1
	  end
      self:qie_corpse(index)
      return
   end
   if string.find(l,"首级斩了下来，提在手中") then
      local b=busy.new()
	  b.Next=function()
	    local sp=special_item.new()
   	     sp.cooldown=function()
           self:jitan()
         end
        sp:unwield_all()
	  end
	  b:check()
      return
   end
   if string.find(l,"找不到") then
       local sp=special_item.new()
	   sp.cooldown=function()
         self:giveup()
	   end
	   sp:unwield_all()
      return
   end
    if string.find(l,"你手上这件兵器无锋无刃，如何能切下这尸体的头来") or string.find(l,"你得用件锋利的器具才能切下这尸体的头来") then
      local sp=special_item.new()
   	  sp.cooldown=function()
	    local f=function()
          self:qie_corpse()
		end
		local error_deal=function()
		     self:get_corpse()
		end
		local do_again=function()
		  world.Send("i")
	  	  self:auto_wield_weapon(f,error_deal)
		  world.Send("set action 砍头")
		end
		f_wait(do_again,0.5)
      end
      sp:unwield_all()
      return
   end
   wait.time(5)
  end)
end

function huashan:run(i)
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

function huashan:flee(i)
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

function huashan:escape_place(place)
  --world.AppendToNotepad (WorldName().."_华山任务:",os.date()..": 蒙面人往"..place.."逃窜!\r\n")
  --你一把抓向蒙面人试图抢回令牌，但被蒙面人敏捷得躲了过去，你顺手扯下蒙面人的面罩，发现原来是曾经名震江湖的郝世。
  wait.make(function()
     local l,w=wait.regexp("^(> |)你一把抓向蒙面人试图抢回令牌，但被蒙面人敏捷得躲了过去，你顺手扯下蒙面人的面罩，发现原来是曾经名震江湖的(.*)。$",5)
    if l==nil then
       self:escape_place(place)
	   return
	end
    if string.find(l,"你一把抓向蒙面人试图抢回令牌") then
	   --print(w[2])
	   self.robbername=w[2]
	    -- 加入危险人物列表
	   --dangerous_man_list_add(self.robbername)
	   self:escape(place,self.robbername)
	   return
	end
	wait.time(5)
  end)
end
--[[
猛地从树林里窜出一个蒙面人夺下你的令牌，向小山路方向夺路逃去。
你一把抓向蒙面人试图抢回令牌，但被蒙面人敏捷得躲了过去，你顺手扯下蒙面人的面罩，发现原来是曾经名震江湖的邝年。

]]

--[[

猛地从树林里窜出一个蒙面人夺下你的令牌，向
   *    *           *         *     *       *                        *    *      *           *
   *     *          *    *    *     *       * *                 *     **  *   *****    *     *
   *     *  *       *    *    *     *       *  *   ***************     *  *   *  *      *    *
   *  ********      *    *    *     *  **********       *   *             *   *  *      *    *   *
******            * * *  * *  *   ******    *           *   *       *  ********  *        *********
   *       *      * *  * *  * *     *  *    *           *   *   *    **   *   ****           *   *
  **   ******     * *  * *  * *     *  *    *  *    **************    *   * * *  *   ****    *   *
  ***  *   *     *  *    *    *     *  **** *  *    *   *   *   *       *******  *      *    *   *
 * * * *   *        *    *    *     *  *  * * *     *   *   *   *      **   * *  *      *   *    *
 * *   *   *        *    *    *     *  *  * * *     *   *   *   *     * *   * ****      *   *    *
*  *   *   *        *    *    *     ****  *  *      *   *   *   *   **  *   * *  *      *   *    *
   *   *   *        *    *    *   ***  ** *  *      *  *     ** *    *  *   * *  *      *  *  * *
   *   *   *  *    *     *    *    *   * *  **      * *         *    *  *   * *  *      * *    *
   *  *    *  *    *     *    *        *   *  * *   *           *    *  ***** *  *     * *        **
   * *      ***   *           *       *   *   * *   *************    *  *    * * *    *   *********
   **                         *      *         **   *           *    *      *   *
方向逃去。
你一把抓向蒙面人试图抢回令牌，但被蒙面人敏捷得躲了过去，你顺手扯下蒙面人的面罩，发现原来是曾经名震江湖的楚晋旭魄。

]]


function huashan:bigword()
    new_bigword()
	world.AddTriggerEx ("bigword1", "^(.*)$", "get_bigword2(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1001)
	world.SetTriggerOption ("bigword1", "group", "bigword")

	wait.make(function()
	   local l,w=wait.regexp("^(方向|处).*逃去。$",10)
	   if string.find(l,"逃去") then
	      world.EnableTriggerGroup("bigword",false)
		  world.DeleteTriggerGroup("bigword")
		   local locate=deal_bigword2()
		    print(locate)
	       self:escape_place(locate)
		  return
	   end
	   wait.time(10)
	end)
    --world.AddTriggerEx ("bigword2", "^」的「(.*)」手上。$", "print(\"%1\")\EnableTriggerGroup(\"bigword\",false)\nDeleteTriggerGroup(\"bigword\")\nsongxin.deal_bigword(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	--world.SetTriggerOption ("bigword2", "group", "bigword")

end
--"忽然","突然","猛地","冷不防","冷不丁",
--冷不丁从树林深处杀出一个蒙面人夺下你的令牌，向玉泉院处夺路逃去。
function huashan:menmian_ren()
   wait.make(function()
      local l,w=wait.regexp("^(> |)(忽然|突然|猛地|冷不防|冷不丁)从树林.*出一个蒙面人.*你的令牌，向(.*)(处|方向).*逃去。$|^(> |)(忽然|突然|猛地|冷不防|冷不丁)从树林.*出一个蒙面人.*你的令牌，向$",10)
      if l==nil then
	     self:menmian_ren()
	     return
      end
      if string.find(l,"逃去") then
	     self.appear=true
		 self:shield()
	     shutdown()
	     print("逃去",w[3])
		 local location=Trim(w[3])
	     self:escape_place(location)
	     return
	  end
	  if string.find(l,"你的令牌") then
	     self.appear=true
		 self:shield()
	     shutdown()
	    self:bigword()
	    return
 	  end
      wait.time(10)
   end)
end

function huashan:NextPoint()
   print("进程恢复")
   coroutine.resume(huashan.co)
end

function huashan:combat()
end

function huashan:pickup()
     world.Send("get ling from "..self.robberid)
	 world.Send("get "..self.robberid)
	 self:jitan(self.robberid)
end

function huashan:robber_idle()

end

function huashan:combat_end()
   local combat_endtime=os.time()
   local combat_usedtime=0
   if combat_starttime==nil then
     combat_usedtime=0
   else
     combat_usedtime=os.difftime (combat_endtime, combat_starttime)
   end
   --world.AppendToNotepad (WorldName().."_华山任务:",os.date()..": 华山战斗结束(耗时:"..combat_usedtime..")\n")
end

function huashan:kill(npc,id)
     local ts2=""
     if self.run_hs2==true then
	     ts2="华山2"
	 else
        ts2="华山"
	 end
	local ts={
	           task_name=ts2,
	           task_stepname="战斗",
	           task_step=5,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	world.Send("kill "..id)
    if self.dayun==false then
	  --world.Send("kill "..id)
	  self:wait_robber_die()
	else
	  self:wait_robber_idle()
	  self:wait_robber_die()
	end
	--world.Send("follow "..id)
	--world.AppendToNotepad (WorldName().."_华山任务:",os.date()..": 华山战斗开始\r\n")
	combat_starttime=os.time()
    self:combat()

end

function huashan:shield()
end

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

function huashan:wait_robber_idle()
   wait.make(function()  --淳于纳泉神志迷糊，脚下一个不稳，倒在地上昏了过去。
     --print(npc.."神志迷糊，脚下一个不稳，倒在地上昏了过去。")
     local l,w=wait.regexp("^(> |)"..self.robbername.."神志迷糊，脚下一个不稳，倒在地上昏了过去。",5)
     if l==nil then
	   self:wait_robber_idle()
	   return
	 end
	 if string.find(l,"神志迷糊，脚下一个不稳") then
	    self:robber_idle()
	    return
	 end
	 wait.time(5)
   end)
end

function huashan:wait_robber_die()
   wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",5)
	 if l==nil then
	    self:wait_robber_die()
	    return
	 end
	 if string.find(l,"挣扎着抽动了几下就死了") then
	    --print(self.robbername,w[2])
	    if string.find(w[2],self.robbername) then
		   self:robber_die()
		else
           self:wait_robber_die()
		end
	    return
	 end
	 if string.find(l,"这里没有这个人")  then
	    self:robber_die()
		return
	 end
	 wait.time(5)
  end)
end

function huashan:robber_die()
end

function huashan:checkPlace(npc,roomno,here,CallBack,is_omit)
      if is_contain(roomno,here) or is_omit==true then
	     if self.look_NPC==true then --路上经过
			   self.look_NPC=false --只有在华山2 时候开启这个标志
			   self:Check_Point_NPC()--点检
		 else
  	       print("等待0.3s,下一个房间")
		   local f=function()
		     local b
		     b=busy.new()
		     b.interval=0.5
		     b.Next=function()
		        CallBack()
		     end
		     b:check()
		   end
		   f_wait(f,0.3)
		 end
	   else
	   --没有走到指定房间
	    print("没有走到指定房间")
        self.check_place_count=self.check_place_count+1
		 if self.check_place_count>3 then
		    --self.check_place_count=0
			print("连续3次失败 放弃！")
			self:checkPlace(npc,roomno,here,CallBack,true)
		    return
		 end
	      local w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		 --[[ al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复")
				  coroutine.resume(huashan.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end]]
		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
			 self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno,CallBack)
		  end
		  w:go(roomno)
	   end
end

function huashan:checkNPC(npc,roomno,CallBack)

      --thread_monitor("huashan:checkNPC",f,{npc,roomno})
    wait.make(function()
      world.Execute("look;set action 核对身份")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |).*"..npc.."的尸体\\\((.*)\\\).*$|^(> |)设定环境变量：action \\= \\\"核对身份\\\"",2)
	  if l==nil then
		self:checkNPC(npc,roomno,CallBack)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
	      --没有找到
		  --
		  if roomno==nil then
		    CallBack()
		  else
		    local f=function(r)
		       self:checkPlace(npc,roomno,r,CallBack)
		    end
		    WhereAmI(f,10000) --排除出口变化
          end
		  return
	  end
	  if string.find(l,"的尸体") then
	     self:robber_die()
	     return
	  end
	  if string.find(l,npc) then
	     --找到
		  local id=string.lower(Trim(w[2]))
		  self.robberid=id
		  --print(id)
		  world.Send("follow "..id)
		  shutdown()
		  self:kill(npc,id)
		  return
	  end
	  wait.time(6)
   end)
end

function huashan:Search(rooms,npc)
	for _,r in ipairs(rooms) do

          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		   al.break_in_failure=function()
		      self:giveup()
		  end
		   al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复")
				  coroutine.resume(huashan.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  local f=function()
			     self:NextPoint()
			  end
			  self:checkNPC(npc,1764,f)
		  end
		  al.maze_done=function()
		    local f=function()
			    al:maze_step()
			end
		    self:checkNPC(npc,nil,f)
		  end
		  w.user_alias=al
		  w.noway=function()
		    self:NextPoint()
		  end

		  w.walkover=function()
		    print("寻找"..npc)
			local f=function()
			   self:NextPoint()
			end
		    self:checkNPC(npc,r,f)
		  end
		  print("下一个房间号:",r)
		  self.target_roomno=r
		  w:go(r)
		  coroutine.yield()
	end
end
--[[unwield xiao
yun qimen
逃去 松树林
你一把抓向蒙面人试图抢回令牌，但被蒙面人敏捷得躲了过去，你顺手扯下蒙面人的面罩，发现原来是曾经名震江湖的庞统。
庞统
松树林
华山    村松树林
华山村    松树林
华山    松树林
房间号: 953
房间号: 956
房间号: 1509
房间号: 3066
房间号: 3067
房间号: 3068
房间号: 3069
房间号: 3070
房间号: 3071
房间号: 3072
房间号: 3073]]
function huashan:auto_kill()

   wait.make(function()
     local l,w=wait.regexp("^(> |)看起来"..self.robbername.."想杀死你！$",5)
	  if l==nil then
	     self:auto_kill()
	     return
 	  end
	  if string.find(l,"想杀死你") then
	     print("出现！！")
	     shutdown()
		 local f
		 if self.run_hs2==true and self.sections~=nil then  --不在华山松树林
			 f=function()
	           self:check_section()
	         end
		 else
		    f=function()
			   self:NextPoint()
			end
		 end
		  self:checkNPC(self.robbername,self.target_roomno,f)
		 return
	  end
   end)
end

function huashan:NPC_exist()

   world.AddTriggerEx ("npc_place", "^(> |)(.*) - .*$", "print(\"%2\")\nSetVariable(\"NPC_place\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 350)
  wait.make(function()
    local l,w=wait.regexp("^(> |).*\\\s"..self.robbername.."\\\(.*\\\).*$",5)
	if l==nil then
	  self:NPC_exist()
	  return
	end
	if string.find(l,self.robbername) then
	  world.EnableTrigger("NPC_place",false)
	  world.DeleteTrigger("NPC_place")
	  self.look_NPC=true
	  local location=world.GetVariable("NPC_place")
	  location=Trim(location)
	  self.look_NPC_place=location
	  print("发现地点:",location)

	  --world.DeleteVariable("beauty_place")
	  return
    end
  end)
end

function huashan:Child_NextPoint()
  print("恢复子进程")
   coroutine.resume(huashan.co2)
end

function huashan:Child_Search(rooms)
  local al
   al=alias.new()
   al:SetSearchRooms(rooms)
   for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  al.maze_done=function()
			  self:checkNPC(self.robbername,nil,al.maze_step)
		  end
		  al.break_in_failure=function()
		      --self:giveup()
			  self:Child_NextPoint()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    local f=function()
			   self:Child_NextPoint()
			end
			self:checkNPC(self.robbername,r,f)
		  end
		  w:go(r)
		  coroutine.yield()
   end
end

function huashan:Check_Point_NPC()
	 local n,e=Where(self.look_NPC_place) --检测房间名
			   --和搜索范围求交集
	 local target_room={}
	  for _,r in ipairs(self.rooms) do
			      for _,t in ipairs(e) do
				    if t==r then
					  print("roomno:",t)
					  table.insert(target_room,t)
					end
				  end
	  end
       print("子进程")
	   huashan.co2=coroutine.create(function()
            self:Child_Search(target_room)
		 --回到主进程上去
		   print("回到主进程上去!")
		   self:NPC_exist()
		   self:NextPoint()
	   end)
	   self:Child_NextPoint()
end

function huashan:goPlace(roomno,here,is_omit)
       print("起始房间:",roomno)
		local f=function()
	     self:check_section()
	   end
      if is_contain(roomno,here) or is_omit==true then
	       print("确定到达出发点->Next Room")
		   --self.is_checkPlace=false
		   self.check_place_count=0
		   local b
		   b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      --print("执行")
		      local i=self.section
			  local s=self.sections[i]
		      local tr=traversal.new()

			 self.rooms={}
			  local ex_rooms={}
               ex_rooms=Split(self.sections[i].alias_rooms,";")
             for _,g in ipairs(ex_rooms) do
		       if g~=nil then
			     --print("插入房间号:",g)
                 table.insert(self.rooms,g)
	           end
             end

			  local al=alias.new()
			  al:SetSearchRooms(self.rooms)
			  al.break_in_failure=function()
			      print("无法进入,跳过路径")
			      self.section=self.section+1 --步进
				  self:checkNPC(self.robbername,nil,f)
			  end
			   al.xidajie_mingyufang=function()
                  world.Send("north")
                  wait.make(function()
                  local l,w=wait.regexp("^(> |)鸣玉坊.*|小朋友不要到那种地方去！！",5)
	              if l==nil then
	                al:finish()
	                return
				  end
	              if string.find(l,"小朋友不要到那种地方") then
				     print("无法进入妓院，重新生成遍历路径！")
				     local n,e=Where(self.location)
	                 self:c_paths(e,self.depth,"xidajie_mingyufang",true)
	                 return
	              end
				  if string.find(l,"鸣玉坊") then
	                 al:finish()
					 return
	              end
                  end)
               end
			  --  晚上无法进入的房间 伊犁  扬州酒店 湖滨小酒店
			  al.waitday_south=function() --湖滨小酒馆
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==1068 then
	                   al:finish()
	               elseif roomno[1]==1065 then
						print("无法进入,跳过路径")
						self.section=self.section+1 --步进
						self:checkNPC(self.robbername,nil,f)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:waitday_south()
					   end
		               w:go(1065)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.xidajie_shouxihujiulou=function()
			      world.Send("north")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==109 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("无法进入,跳过路径")
						self.section=self.section+1 --步进
						self:checkNPC(self.robbername,nil,f)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:xidajie_shouxihujiulou()
					   end
		               w:go(108)
	               end
                 end
                 _R:CatchStart()
			  end

			  al.xidajie_shoushidian=function()
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==111 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("无法进入,跳过路径")
						self.section=self.section+1 --步进
						self:checkNPC(self.robbername,nil,f)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:xidajie_shoushidian()
					   end
		               w:go(108)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.nanmen_chengzhongxin=function()
			      world.Send("north")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==2349 then
					   table.insert(self.rooms,2349)
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("无法进入,跳过路径")
						self.section=self.section+1 --步进
						self:checkNPC(self.robbername,nil,f)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:nanmen_chengzhongxin()
					   end
		               w:go(1972)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.noway=function()
			      print("跳过路径")
			      self.section=self.section+1 --步进
				  self:checkNPC(self.robbername,nil,f)
			  end

		    al.songlin_check=function()
			  print("迷宫check npc")
	          local f2=function() al:NextPoint() end
			  self:checkNPC(self.robbername,nil,f2)
			end
			al.maze_done=function()
			   print("迷宫check npc")
			   local f2=function() al.maze_step() end
			   self:checkNPC(self.robbername,nil,f2)
			end

			  tr.user_alias=al
			  tr.step_over=function()
			     --检查强盗
				 print("检查强盗")
			     self:checkNPC(self.robbername,nil,f)
			  end
			  self.section=self.section+1 --步进
	          tr:exec(s) --队列
		   end
		   b:check()
	   else
	   --没有走到指定房间
	     print("没有走到指定房间")
         self.check_place_count=self.check_place_count+1
		 if self.check_place_count>3 then
		    --self.check_place_count=0
			print("连续3次失败 放弃！")
			self:goPlace(roomno,here,true)
		    return
		 end
	      local w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		    --  晚上无法进入的房间 伊犁  扬州酒店 湖滨小酒店
			  al.waitday_south=function() --湖滨小酒馆
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==1068 then
	                   al:finish()
	               elseif roomno[1]==1065 then
						print("无法进入,跳过路径")
						--self.section=self.section+1 --步进
						self:goPlace(roomno,here,true)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:waitday_south()
					   end
		               w:go(1065)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.xidajie_shouxihujiulou=function()
			      world.Send("north")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==109 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("无法进入,跳过路径")
						--self.section=self.section+1 --步进
						--self:checkNPC(self.robbername,f)
						self:goPlace(roomno,here,true)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:xidajie_shouxihujiulou()
					   end
		               w:go(108)
	               end
                 end
                 _R:CatchStart()
			  end

			  al.xidajie_shoushidian=function()
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==111 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("无法进入,跳过路径")
						--self.section=self.section+1 --步进
						--self:checkNPC(self.robbername,f)
						self:goPlace(roomno,here,true)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:xidajie_shoushidian()
					   end
		               w:go(108)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.nanmen_chengzhongxin=function()
			      world.Send("north")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==2349 then
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("无法进入,跳过路径")
						--self.section=self.section+1 --步进
						--self:checkNPC(self.robbername,f)
						self:goPlace(roomno,here,true)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:nanmen_chengzhongxin()
					   end
		               w:go(1972)
	               end
                 end
                 _R:CatchStart()
			  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(self.robbername,roomno,f)
		  end
		  w:go(roomno)
	   end
end

function huashan:check_section()

    local sections=self.sections
	local i=self.section
	if i>table.getn(sections) then
       print("巡逻完成一次")
	   if self.round>2 then
	       self:giveup()
		   return
	   else

	       self.round=self.round+1
		   self.section=1
	       i=1
	   end
	else
	   print("继续巡逻")
	   print(i)
	end
	local aim_roomno=sections[i].startroomno
	local f=function(r)
		 self:goPlace(aim_roomno,r)
	end
	WhereAmI(f,10000) --排除出口变化
end

function huashan:hs2_Search(paths,rooms,npc)
    self.is_checkPlace=true
	self:auto_kill()
	self:NPC_exist()
	--print("paths",paths)
	local tr=traversal.new()
	self.sections=tr:fast_walk(paths,rooms) --队列
	print("-------------")
    for i,v in ipairs(self.sections) do
      print(i)
	  print(v.startroomno)
	  print(v.alias_paths)
	  print(v.endroomno)
	  print(v.alias_rooms)
	  print("-------------")
    end
	local al=alias.new()
	al.do_jobing=true
	local r=Split(rooms,";")
	-- print("-------start------")
	 local _r1={}
	 local _r2={}
	for _,e in ipairs(r) do

	   if _r1[e]==nil then
	       _r1[e]=e
		   table.insert(_r2,e)
		    --print("显示相关的房间号:",e)
	   end
	end
	 --print("------end-------")
	al:SetSearchRooms(_r2)
	al.noway=function()
	   al:NextPoint()
	end
	al.maze_done=function()
	   --print("wudang 执行搜索迷宫")
	   self:checkNPC(self.robbername,nil,al.maze_step)
	end
	al.nanmen_chengzhongxin=function()
		if self.look_NPC==true then --路上经过
		     self.section=1 --路段
		     self.look_robber=false--只检查一次
			 print("路上经过")
			 self:Check_Point_NPC()--点检 点检完毕 回到section起始房间
		else
			world.Send("north")
            local _R
            _R=Room.new()
            _R.CatchEnd=function()
               local count,roomno=Locate(_R)
	           print("当前房间号",roomno[1])
	           if roomno[1]==2349 then
	              al:finish()
	           elseif roomno[1]==1972 then
				 local f=function()
		           al:nanmen_chengzhongxin()
			     end
		        f_wait(f,10)
			  else
                local w
		         w=walk.new()
		         w.walkover=function()
		            al:nanmen_chengzhongxin()
		         end
		         w:go(1972)
	          end
            end
            _R:CatchStart()
		end
	end
	al.break_in_failure=function()
	   self:giveup()
	end
	local w=walk.new()
	w.user_alias=al
	w.noway=function()
	   self:giveup()
	end
	w.walkover=function()
	    ---执行前 先 check roomno
	    self.section=1 --路段
		self.rooms={}
		local ex_rooms={}
        ex_rooms=Split(self.sections[1].alias_rooms,";")
       for _,g in ipairs(ex_rooms) do
		   if g~=nil then
		      print("插入房间号:",g)
              table.insert(self.rooms,g)
	       end
       end
	   local f=function()
	     self:check_section()
	   end
	    self:checkNPC(npc,tr.startroomno,f)
	end
	w:go(tr.startroomno)	--走到起始房间
end

function huashan:c_paths(e,depth,omit,opentime)
  local paths,rooms=depth_path_search(e,depth,omit,opentime)  --搜索路径 房间号
  --print(paths)
  --print(rooms)
   print("需要遍历房间")
   local ex_rooms={}
   local ex_list={}
   ex_rooms=Split(rooms,";")
   for _,g in ipairs(ex_rooms) do
      if ex_list[g]==nil then
	    ex_list[g]=g
        table.insert(self.rooms,g)
	  end
   end

   if paths~="" then
      --self:auto_kill(self.robbername)
	  --self:beast_kill_check()
	  local b
	  b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	     world.Send("yun recover")
	     self:shield()
	     self:hs2_Search(paths,rooms,self.robbername)
	  end
	  b:check()
	else
	  self:giveup()
    end
end

function huashan:test(location,depth,npc)
      print("范围查询")
	  self.robbername=npc
		self.sections={}
		self:hs2_robber(location,6,npc)
end

function huashan:hs2_robber(location,depth,npc)
    local n,e=Where(location)
   if n==0 then
       print("不存在该房间！！")
       self:giveup()
       return
   end
    local party=world.GetVariable("party") or ""
	local mastername=world.GetVariable("mastername") or ""
   local omit=""
    if string.find(location,"襄阳城") or string.find(location,"华山村") then
        --fengyun、longhu、north 和 tiandi
      omit="fengyun|longhu|tiandi|xiaoxi_dufengling|huigong"
   end
   if string.find(location,"绝情谷") then
      omit="dufengling_xiaoxi"
   end
   if string.find(location,"嵩山少林") then
      omit="duanyaping_yading|qingyunpin_fumoquan"
   end
   if string.find(location,"天山") then
      omit="baizhangjian_xianchoumen|xianchoumen_baizhangjian|t_leave"
   end
   if string.find(location,"塘沽城") then
      omit="shatan_shenlongdao"
   end
   if string.find(location,"神龙岛") then
      omit="shenlongdao_shatan"
   end
   if string.find(location,"峨嵋山") then
      omit="houshanxiaolu_guanmucong"
   end
   if string.find(location,"兰州城") then
      omit="duhe|shamo_qingcheng|climb_shanlu"
   end
  if string.find(location,"苏州城") then
      omit="dujiang"
   end
   if string.find(location,"宁波城") then
      omit="haibing_taohuadao"
   end
   if string.find(location,"武当山") then
     if party=="武当派" and mastername=="张三丰" then
       omit="xiaojing2_xiaojing1|xiaojing2_yuanmen|yitiantulong|dujiang|holdteng"
	 else
       omit="yitiantulong|dujiang|holdteng"
     end
   end

	if string.find(location,"黄河流域") then
      omit="xiaofudamen_xiaofudating"
   end
   if string.find(location,"恒山") then
      omit="duhe"
   end
   if string.find(location,"铁掌山") then
     omit="zoulang_shufang|movebei"
   end
   if string.find(location,"星宿海") then
     omit="zuan|push_door"
   end
   if string.find(location,"福州城") then
      omit="swim"
   end
   if string.find(location,"天龙寺") then
      omit="dangtianmen_xiuxishi"
   end
   if string.find(location,"成都城") then
      omit="shamo_qingcheng"
   end
   if string.find(location,"宁波城") or string.find(location,"牛家村") then
      omit="haibing_taohuadao"
   end
--push_qiaolan' or direction='shanzhuang' or direction='xiaodao' or direction='yanziwu
   if string.find(location,"曼佗罗山庄") or string.find(location,"姑苏慕容") or string.find(location,"燕子坞") then
      omit="xiaodaobian_matou|quyanziwu|tanqin|qumr|yellboat|zuan_didao|didao|jump liang|yanziwu|push_qiaolan|shanzhuang|xiaodao"
   end
   if string.find(location,"明教") then
     omit="tiandifenglei_feng|tiandifenglei_di|tiandifenglei_tian|tiandifenglei_lei|west_zishanlin_tiandifenglei_quick|east_zishanlin_tiandifenglei_quick" --zishanlin_search|
     if Trim(location)=="明教树林" then
        table.sort(e,function(a,b) return a>b end) --重新排序
		depth=5
     end
  end


   if string.find(location,"武当后山") then
      omit="jump_river|pa ya"
   end
   if string.find(location,"扬州城") then
      omit="dujiang"
   end
    if string.find(location,"杭州城") then
      omit="enter_meizhuang"
   end
   if string.find(location,"苗疆") then
      if wdj.wdj2_ok==false or wdj.wdj2_ok==nil then
	     if string.find(location,"苗疆山路") then
	      n=2
		  e={234,367}
		 end
	      omit="shanjiao_shanlu"
	  end
   end
   if string.find(location,"福州城") then
      local al=alias.new()
	  al.finish=function(result)
	     --print(result," 结果")
	     self:c_paths(e,depth,omit,result)
	  end
	  al:opentime("fuzhouchengnanmen")
	  return
   end
	if string.find(location,"华山石屋") then

		e={1508}

   end
   if string.find(location,"华山") then

      omit="shiguoya_shiguoyadongkou|siguoya_jiashanbi|huigong"
   end
   --print("omit:",omit)
  -- self:c_paths(e,depth,omit,true)
   --omit=omit.."|huigong|t_leave"
   self:c_paths(e,depth,omit,true) --固定范围
end

function huashan:escape(location,npc)
     local ts=""
     if self.run_hs2==true then
	     ts="华山2"
	 else
        ts="华山"
	 end
	local ts={
	           task_name=ts,
	           task_stepname="搜索蒙面人",
	           task_step=4,
	           task_maxsteps=7,
	           task_location=location,
	           task_description="寻找蒙面人 "..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."华山任务:搜索"..location.." "..npc, "blue", "black") -- black on white
    local Max_round=2
	local z1="华山村"
	local z2="华山"
    if zone_entry(location)==true then
      self:giveup()
      return
   end
   location=string.gsub(location,"中原神州","")
    local n,rooms=Where(z1..location)
    if n==0 then
	  n,rooms=Where(z2..location)
	  if n==0 then
	    n,rooms=Where(location)
	  else
	    self.dayun=false
		location=z2..location
	  end
	else
	   self.dayun=false
	   location=z1..location
	end
    if n>0 and location=="华山后堂" then
	   rooms=depth_search(rooms,2)
	end

	if location=="华山松树林" then
	   Max_round=5
	   rooms=depth_search(rooms,2)
	end
	if location=="华山村菜地" then
	   self.dayun=false
	end

	if n>0 then
	  if self.run_hs2==true then
	    if string.find(location,"华山松树林") then
		  print("华山村树林搜索")
	      rooms=depth_search(rooms,6)
	    else
	      print("范围查询")
	      self.sections={}
	      self:hs2_robber(location,6,npc)
	     return
	    end
	  end
	 self:auto_kill()
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   huashan.co=coroutine.create(function()
		print(table.getn(rooms),"房间数")
        self:Search(rooms,npc)
		print("没有找到npc!!")
		if self.round<=Max_round then
		   self.round=self.round+1
		   print("重新尝试一次:",self.round)
		   self:Search(rooms,npc)
		   self:giveup()
		else
		  self:giveup()
		end
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
--[[冷不丁从树林深处杀出一个蒙面人抢去你的令牌，向菜地处夺路逃去。
你一把抓向蒙面人试图抢回令牌，但被蒙面人敏捷得躲了过去，你顺手扯下蒙面人的面罩，发现原来是曾经名震江湖的张茂乾。
]]
function huashan:songlin()
     local ts2=""
     if self.run_hs2==true then
	     ts2="华山2"
	 else
        ts2="华山"
	 end
  	local ts={
	           task_name=ts2,
	           task_stepname="树林巡逻",
	           task_step=3,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  self:menmian_ren()
  world.Send("south")
  world.Send("east")

  --local w
  --w=walk.new()
  --w.walkover=function()
  local f=function()  self:patrol() end
  f_wait(f,1)
  --end
  --w:go(953)
end

function huashan:patrol()
  --山脚下 950
  if self.appear==true then
    print("强盗出现")
  else
    local w
     w=walk.new()
     w.walkover=function()
      self:songlin()
    end
    w:go(950)
  end
end

local jitan_count=1
function huashan:jitan(id)
  	local ts={
	           task_name="华山",
	           task_stepname="返回祭坛",
	           task_step=6,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
local w
  w=walk.new()
  w.walkover=function()
  --岳灵珊在你的令牌上写下了一个 一 字。
    if id==nil then
       world.Send("give shouji to yue lingshan")
	   world.Send("give corpse to yue lingshan")
	else
	   world.Send("give "..id.." to yue lingshan")
	end
	 world.Send("set action 令牌检查")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)岳灵珊在你的令牌上写下了一个 一 字。$|^(> |)岳灵珊在你的令牌上写下了一个 二 字。$|^(> |)设定环境变量：action \\= \\\"令牌检查\\\"|^(> )你的令牌呢？$",5)
	   if l==nil then
	     self:jitan(id)
	     return
	   end
	   if string.find(l,"一 字") then
	     if self.hs2==true then
		    self.dayun=false
		    local b=busy.new()
			b.interval=0.3
			b.Next=function()
              world.Send("jitan force")
			  local b2=busy.new()
			  b2.interval=0.5
			  b2.Next=function()
				self:recover()
			  end
	          b2:check()
			end
			b:check()
		 else
		   local b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      world.Send("jitan force")
			  local b2=busy.new()
			  b2.interval=0.5
			  b2.Next=function()
		        world.Send("ask yue lingshan about 力不从心")
			    local b1=busy.new()
			    b1.interval=0.3
			    b1.Next=function()
			       self:reward()
			    end
			    b1:check()
			  end
	          b2:check()
		   end
		   b:check()
		 end
		    jitan_count=1
		 return
	   end
	   if string.find(l,"二 字") then
	     local b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      world.Send("jitan force")
			  local b2=busy.new()
			  b2.interval=0.5
			  b2.Next=function()
				self:reward()
			  end
	          b2:check()
		   end
		   b:check()
		    jitan_count=1
	     return
	   end
	   if string.find(l,"你的令牌呢") then
		  if id==nil then
		     world.Send("drop shouji")
		  else
		     world.Send("drop "..id)
		  end
		  self:giveup()
	      return
	   end
	   if string.find(l,"设定环境变量：action") then


		  if jitan_count<=5 then
		    print("超过5次")
		     self:jitan(id)
		  else
		     self:giveup()
		  end
		   jitan_count=jitan_count+1
	      return
	   end
	   wait.time(5)
	 end)
  end
  w:go(1514)
end

function huashan:liaoshang_fail()
end

function huashan:recover()

	local ts={
	           task_name="华山2",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

    self.robbername=""
	self.appear=false
	self.run_hs2=true
	local vip=world.GetVariable("vip") or "普通玩家"
	local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)
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
				    self:recover()
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
				    self:recover()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 end
		   end
		   w:go(133) --299 ask xiao tong about 食物 ask xiao tong about 茶
		elseif  h.qi_percent<=70 or h.jingxue_percent<=80  then
		    print("疗伤")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper)  then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.danger=function()
			   world.Send("yun qi")
			   world.Send("yun jingli")
			   local w=walk.new()
			   w.walkover=function()
			      x:dazuo()
			   end
			   w:go(53)
			end
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self:recover()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,10)
			    end
				if id==777 then
				   self:recover()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(1512)
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   world.Send("yun recover")
			   if h.neili>h.max_neili*2-200 then
			     self:songlin()
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
			  self:songlin()
			end
			b:check()
		end
	end
	h:check()
end

function huashan:full()


     world.Send("yun refresh")
	 world.Send("yun recover")
	 self.robbername=""
	 self.appear=false
	 self.run_hs2=false
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 local qi_percent=world.GetVariable("qi_percent") or 100
	 qi_percent=assert(tonumber(qi_percent),"qi_percent变量必须输入数字！") or 100
	 local vip=world.GetVariable("vip") or "普通玩家"

	local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)
	    --[[if (h.food<50 or h.drink<50) and vip~="贵宾玩家" then
		   print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("sit chair;knock table;get mi tao;get cha;drink cha;drink cha;drink cha;eat mi tao;eat mi tao;eat mi tao;drop mi tao;drop tea")
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
		else]]
		if  h.jingxue_percent<=80 or (h.qi_percent<=liao_percent) then
		    print("疗伤")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("打通经脉")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			-- rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
			end
			rc:heal(true,false)
       elseif h.neili<h.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                self:Status_Check()
            end
			r:wash()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
	    	 if h.neili<=h.max_neili then
			  world.Send("fu chuanbei wan")
			end
		     heal_ok=false --复位
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self:Status_Check()
				     return
				  end
				  world.Send("yun qi")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,10)
			    end
				if id==777 then
				   self:Status_Check()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(1512)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
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

function huashan:Status_Check()
	local ts={
	           task_name="华山",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=7,
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

function huashan:qu_gold()
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
        world.Send("qu 2 gold")
		local l,w=wait.regexp("^(> |)你从银号里取出二锭黄金。$|^(> |)你没有存那么多的钱。$",5)
		print("金子")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold()
		   return
		end
		if string.find(l,"你从银号里") then
		   --回调
		   self:buy_zhengqidan()
		   return
		end
		if string.find(l,"你没有存那么多的钱") then
		  world.Send("quit")
		  return
		end
		wait.time(5)
	  end)
   end
   w:go(410)
end

function huashan:buy_zhengqidan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy zhengqi dan")
	 local l,w=wait.regexp("你以.*的价格从药店掌柜那里买下了一颗正气丹。|^(> |)你想买的东西我这里没有。$|^(> |)穷光蛋，一边呆着去！|^(> |)您的零钱不够了，银票又没人找得开。$",5)
	 if l==nil then
	   self:buy_zhengqidan()
	   return
	 end
	 if string.find(l,"你想买的东西我这里没有") then
	   local f=function()
	     self:buy_zhengqidan()
	   end
	   print("5s 以后继续")
	   f_wait(f,5)
	   return
	 end
	 if string.find(l,"一颗正气丹") then
	    self:eat_zhengqidan()
	    return
	 end
	 if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
	    self:qu_gold()
	    return
	 end
	 wait.time(5)
	end)
 end
 w:go(413)
end

function huashan:eat_zhengqidan()
    wait.make(function()
      world.Send("fu zhengqi dan")
	  local l,w=wait.regexp("^(> |)你服下一颗正气丹，顿时感觉浑身充满正气。$",5)
	  if l==nil then
	    self:eat_zhengqidan()
	    return
	  end
	  if string.find(l,"你服下一颗正气丹") then
	    self:ask_job()
		return
	  end
	  wait.time(5)
	end)
end

function huashan:look_zhengqidan()
--  二十五颗内息丸(Neixi wan)
 wait.make(function()
   world.Send("i")
   world.Send("set look")
   local l,w=wait.regexp("^(> |)(.*)颗正气丹\\(Zhengqi dan\\)$|^(> |)设定环境变量：look \\= \\\"YES\\\"",5)
   if l==nil then
      self:look_zhengqidan()
      return
   end
   if string.find(l,"正气丹") then
	  self:eat_zhengqidan()
	  return
   end
   if string.find(l,"设定环境变量：look ") then
	  self:buy_zhengqidan()
	  return
   end
   wait.time(5)
  end)
end
--你向岳不群打听有关『惩恶扬善』的消息。
--岳不群说道：「你还是先去思过崖面壁思过去吧。」
