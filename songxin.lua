
songxin={
   new=function()
     local sx={}
	 setmetatable(sx,songxin)
	 sx.shashou_all_die=false
	 return sx
   end,
   co=nil,
   --shashou_id="",
   --shashou_name="",
   --sec_shashou_id="",
   --sec_shashou_name="",
   shashou_list={},
   _id="",
   target_roomno="",
   target_npc="",
   breakPoint=nil,
   danger=false,
   is_giveup=false,
   is_end=false,
   on_attack=false,
   neili_upper=1.9,
   immediate_sx1=false,  --立刻投递
   shashou_level=-1,
   blacklist="",
   shashou_all_die=false,
   neili_upper=1.9,
   robber_skill="",
   shashou_name="",
   status="送信1",
   check_idle=false,
}
songxin.__index=songxin
--保存变量值
--[[function songxin:begin_transaction(procedure)
   --保存当前变量
    local _sx={}
	_sx.shashou_id=self.shashou_id
	_sx.shashou_name=self.shashou_name
	_sx._id=self._id
	_sx.target_roomno=self.target_roomno
	_sx.target_npc=self.target_npc
	local item={}
	item.source=self
	item.variable=_sx
	item.method=procedure
	if self.breakPoint~=nil then
	   table.insert(self.breakPoint,item)
	end
end

function songxin:rollback(variable,procedure)
    self.shashou_id=variable.shashou_id
	self.shashou_name=variable.shashou_name
	self._id=variable._id
	self.target_roomno=variable.target_roomno
	self.target_npc=variable.target_npc
    procedure()
end--]]

function songxin:join()
   local w
   w=walk.new()
   w.walkover=function ()
	  wait.make(function()
	     world.Send("ask fu about join")
		 local l,w=wait.regexp("^(> |)傅思归说道：「好，不错，这位.*可以为本王府工作了。」$|^(> |)傅思归说道：「.*已经是本王府随从了，何故还要开这种玩笑？」$",5)
		 if l==nil then
            print("网络太慢或是发生了一个非预期的错误")
		    self:join()
		    return
         end
		 if string.find(l,"可以为本王府工作了。") or string.find(l,"已经是本王府随从了") then
		    local b
			b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:ask_job()
			end
			b:check()
		    return
		 end
		 wait.time(5)
	  end)
   end
   w:go(445)
end

function songxin:fail(id) --回调函数

end

function songxin:combat_check()
end

function songxin:run(i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)你逃跑失败。$|^(> |)你的修为不够！$|^(> |)设定环境变量：action \\= \\\"逃跑\\\"$",1.5)
	   if l==nil then
		  --world.DoAfter(1.5,"set action 结束")
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
			   --self:giveup()
			   self:check_poison()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function songxin:check_poison()  --检查是否中毒
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
			          self:giveup()
			        end
			        rc:qudu(sec,i[1],false)
				    return
			     end

			   end
		     end
            self:giveup()
	end
	cd:start()
end

function songxin:flee(i)
  world.Send("go away")

  self.combat_end=function()
      print("flee combat_end")
       world.Send("unset wimpy")
	    shutdown()
		--检查是否中毒
	   self:check_poison()

  end
  self:combat_check() --战斗检查
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
	 self:run(i)
   end
   _R:CatchStart()
end

function songxin:zonefilter(P)
 local party=world.GetVariable("party")
 local go=true
 if string.find(P,"藏经阁二楼") or string.find(P,"龙王殿") then --不去
    return false
 end
 --[[if string.find(P,"泰山") or string.find(P,"中原") or string.find(P,"长安城") or string.find(P,"长乐帮") or string.find(P,"嵩山") or string.find(P,"嵩山少林") or string.find(P,"扬州城") or string.find(P,"大雪山") or string.find(P,"峨嵋山") then
     go=true
 elseif string.find(P,"绝情谷") or string.find(P,"武当山") or string.find(P,"武当后山") or string.find(P,"极乐世界") or string.find(P,"终南山") or string.find(P,"武馆") or string.find(P,"丐帮") or string.find(P,"萧府") or string.find(P,"襄阳郊外") or string.find(P,"襄阳城") or string.find(P,"华山") or string.find(P,"华山村") or string.find(P,"黄河流域") or string.find(P,"蝴蝶谷") or string.find(P,"南阳城") then
	 go=true
 elseif string.find(P,"无量山") or string.find(P,"天龙寺") or string.find(P,"苗疆") or string.find(P,"玉虚观") or string.find(P,"大理城") or string.find(P,"成都城") or string.find(P,"大理城东") or string.find(P,"大理城南") or string.find(P,"大理城西") or string.find(P,"大理皇宫") or string.find(P,"大理王府") then
     go=true
 elseif string.find(P,"柳宗镇") or string.find(P,"梅庄") then
	 go=true
 elseif (string.find(P,"曼佗罗山庄") or string.find(P,"姑苏慕容") or string.find(P,"燕子坞")) and party=="姑苏慕容" then
     go=true
 elseif string.find(P,"铁掌山") or string.find(P,"苏州城") or string.find(P,"佛山镇") or string.find(P,"福州城") or string.find(P,"杭州城") or string.find(P,"归云庄") or string.find(P,"嘉兴城") or string.find(P,"宁波城") or string.find(P,"牛家村") or string.find(P,"莆田少林") or string.find(P,"桃花岛") then
     go=true
 end]]
 --print("go flag:",go)
 return go
end

function songxin:catch_place()
   wait.make(function()
      local l,w=wait.regexp("^(> |)褚万里\\(Zhu wanli\\)告诉你：.*送到「(.*)」的「(.*)」手上。$|^(> |)褚万里说道：「.*，你不是本王府随从，此话从何说起？」$|^(> |)褚万里说道：「你刚做完大理送信任务，还是去休息一会吧。」$|^(> |)褚万里说道：「你不是已经领了送信的任务吗？还不快去做。」$|^(> |)褚万里说道：「你先去休息一会吧！」$",5)
	  if l==nil then
		print("网络太慢或是发生了一个非预期的错误")
		self:ask_job()
		return
	  end
	  if string.find(l,"你不是本王府随从，此话从何说起") then
	     local b
		 b=busy.new()
		 b.interval=0.3
		 b.Next=function()
	       self:join()
		 end
		 b:check()
	     return
	  end
	  --褚万里(Zhu wanli)告诉你：你赶紧把它送到「星宿海雁门关」的「边防武将」手上。
	  --print("l:",l)
	  if string.find(l,"褚万里%(Zhu wanli%)告诉你") then
	    --print("w2:",w[2]," w3:",w[3])
		if string.find(w[3],"灰衣帮众") or string.find(w[3],"老者") or string.find(w[3],"出尘子") or string.find(w[3],"乞丐") or string.find(w[3],"采药人") or string.find(w[3],"教众") or string.find(l,"神秘镖师") or string.find(w[3],"巡捕") or string.find(w[3],"马贼") or string.find(w[3],"慧真尊者") or string.find(w[2],"回疆大草原") or string.find(w[2],"绝情谷石窟") or string.find(w[3],"值勤兵") then
		   self:giveup()
		else
		   --优化
		   if self:zonefilter(w[2])==true then
		     self:delivery(w[2],w[3])
			 world.AddTriggerEx ("sx", "^(> |)你时间已过，任务失效！$", "shutdown();process.sx()", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
		   else
             self:giveup()
		   end
		end
	    return
	  end
	  if string.find(l,"你刚做完大理送信任务，还是去休息一会吧") then
	     local b=busy.new()
		 b.Next=function()
	        self.jobDone()
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"你先去休息一会吧")  then
		 self.fail(102)
	     return
	  end
	  if string.find(l,"你不是已经领了送信的任务吗？还不快去做") then
	     self:giveup()
	     return
	  end
	  --print("error")
	  wait.time(5)
   end)
end


function songxin:ask_job()
  	local ts={
	           task_name="送信",
	           task_stepname="询问褚万里",
	           task_step=2,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
 -- self:begin_transaction(function() self:ask_job() end)  --断点
  self.shashou_all_die=false
  local w
  w=walk.new()
   local al=alias.new()
   al.do_jobing=true
   w.user_alias=al
  w.walkover=function()
	wait.make(function()
	  world.Send("ask zhu about job")
      local l,w=wait.regexp("^(> |)你向褚万里打听有关『job』的消息。$",5)
	  if l==nil then
	     self:ask_job()
		 return
	  end
	  if string.find(l,"你向褚万里打听有关") then
	     --world.AppendToNotepad (WorldName(),os.date().." 武功:"..w[5].." 技能:"..w[6].."\r\n")
		  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."送信任务:工作开始", "yellow", "black")

	     self:catch_place()
		 --BigData:catchData(506,"驿站")
		 return
	  end
	  wait.time(5)
	end)
  end
  w:go(506)
end

function songxin:giveup()
   world.DeleteTrigger("sx")
   danerous_man_list_push()
   local pfm=world.GetVariable("pfm") or ""
    world.Send("alias pfm "..pfm)
  --self:begin_transaction(function() self:giveup() end)  --断点
  --防止
  --[[if self.shashou_name=="" and self.shashou_id=="" then --杀手没有出现过
    print("信还在身上!!!危险")
    shutdown()
    self:wait_shashou()
	self.is_giveup=true
  else
    print("没有信!!!")
  end]]

  local w
  w=walk.new()
  w.locate_fail_deal=function()
    local f=function()
     self:giveup()
	end
	--
	print("等待4秒")
	f_wait(f,4)
  end
  w.walkover=function()
     world.Send("ask zhu about fangqi")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)你向褚万里打听有关『fangqi』的消息。$",8)
	   if l==nil then
		 self:giveup()
	     return
	   end
	   if string.find(l,"你向褚万里打听有关") then
	      --world.AppendToNotepad (WorldName(),os.date().." 武功:"..w[5].." 技能:"..w[6].."\r\n")
		  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."送信任务:放弃！！", "red", "black")
		  --BigData:catchData(506,"驿站")
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		   self:Status_Check()
		 end
		 b:check()
	     return
	   end
	   wait.time(8)
	 end)
  end
  w:go(506)
end

function songxin:NextPoint()
   print("进程恢复:",coroutine.status(songxin.co))
   if songxin.co==nil or coroutine.status(songxin.co)=="dead" then
      self:giveup()
   else
      coroutine.resume(songxin.co)
   end
end

--[[
> 你擦了一把额头的汗，从怀中掏出信交给官兵说道，这是段王爷让在下送给您的信，请您收好。
官兵接过信看了看，点了点头说道：这位壮士辛苦你了。
好！任务完成，你被奖励了：一百一十一点实战经验，二十五点潜能。你为镇南王府成功送信一百一十二次。
官兵顺手在信上勾画了几下，然后合上信封，又交还给了你。
官兵在你的耳边悄声说道：你赶紧把它送到「峨嵋山纯阳殿」的「贾贯」手上。
官兵在你的耳边悄声说道：可能有个武功和你相比融会贯通的家伙要来抢你的信，你可得小心对付哦。]]

--[[
文方小师太在你的耳边悄声说道：你赶紧把它送到「
.............:.      : .  .....          :           ..........         :     :
       :   .     ````:``` : .`    .......:.....:.            .`         :     :  .
  :    :`````     ```:``  : ``.        .`:`.              ..`       ````:`` ``:````
  :    :     .   ````:``` :`..`     ..`  :  ``...  .......:.....:.     ::.   ::.
  ```````````:`    .:...:.:.:     `` ....:.... `          :           : : ` : : :..
             :   `` :   :   :        :       :            :         .`  : .`  :  `
         .   :      :   : . :        :       :            :             :     :
          `.`       `   :  `         :```````:          `.`             :     :

」的「邵红」手上。
]]


function songxin:bigword()
    new_bigword()
	world.AddTriggerEx ("bigword1", "^(.*)$", "print(\"%1\")\get_bigword(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1001)
	world.SetTriggerOption ("bigword1", "group", "bigword")

	wait.make(function()
	   local l,w=wait.regexp("^」的「(.*)」手上。$",10)
	   if string.find(l,"手上") then
	      world.EnableTriggerGroup("bigword",false)
		  world.DeleteTriggerGroup("bigword")
		  self:deal_bigword(w[1])
		  return
	   end
	   wait.time(10)
	end)
    --world.AddTriggerEx ("bigword2", "^」的「(.*)」手上。$", "print(\"%1\")\EnableTriggerGroup(\"bigword\",false)\nDeleteTriggerGroup(\"bigword\")\nsongxin.deal_bigword(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	--world.SetTriggerOption ("bigword2", "group", "bigword")

end

function songxin:deal_bigword(npc)
    print("npc:",npc)
    local locate=deal_bigword()
    --Where(locate)
	self:deliveryAgain(locate,npc)
	--第二次送信
end

local function look_bigword()
    new_bigword()--新的大字
	world.AddTriggerEx ("bigword0", "^(> |).*这是一封由大理国镇南王发出的信件，上面写着$", "EnableTriggerGroup(\"bigword\",true)\nEnableTrigger(\"bigword0\",false)", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	world.SetTriggerOption ("bigword0", "group", "bigword")
	world.AddTriggerEx ("bigword01", "^.*「$", "print(\"right\")\nEnableTriggerGroup(\"bigword\",true)", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	world.SetTriggerOption ("bigword01", "group", "bigword")
    world.AddTriggerEx ("bigword1", "^(.*)$", "print(\"%1\")\nget_bigword(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1001)
	world.SetTriggerOption ("bigword1", "group", "bigword")
    world.AddTriggerEx ("bigword2", "(.*)」 亲启。$", "print(\"%1\")\EnableTriggerGroup(\"bigword\",false)\ndeal_bigword()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	world.SetTriggerOption ("bigword2", "group", "bigword")
	world.Send("look letter")
end
--王三力在你的耳边悄声说道：可能有个武功和你相比颇为了得的家伙要来抢你的信，你要小心点哦。
--青龙门弟子在你的耳边悄声说道：可能有个武功和你相比微不足道的家伙要来抢你的信，你应该随便对付几下就可以了吧。
function songxin:strong()
    wait.make(function()
	  print("探测强度:")
	  --官兵在你的耳边悄声说道：可能有个武功和你相比已入化境的家伙要来抢你的信，打不过可不要逞能。
	  local l,w=wait.regexp("^(> |).*在你的耳边悄声说道：可能有个武功和你相比(.*)的家伙要来抢你的信.*$",3)
	  if self.is_end==true then
	    print("探测结束")
	    return
	  end
	  if l==nil then
	    --print("strong")
		self:strong()
		return
	  end
	  if string.find(l,"在你的耳边悄声说道：") then
        print("强度：",w[2])
		local str=w[2]
		local value
		if str=="微不足道" then
		  value=1
		elseif str=="马马虎虎" then
		  value=2
		elseif str=="小有所成" then
		  value=3
		elseif str=="融会贯通" then
		   value=4
		elseif str=="颇为了得" then
		   value=5
		elseif str=="极其厉害" then
		   value=6
		elseif str=="已入化境" then
		   value=7
		else
		   value=8
		end
		if value<=self.shashou_level then
		  	 local b
	         b=busy.new()
	         b.interval=0.3
	         b.Next=function()
			  print("恢复内力")
	          self:shield()
		      self:recover()
			 end
			 b:check()
		else
		   print("杀手太危险,放弃")
	       world.Send("no")
		   world.DeleteTrigger("sx")
		   shutdown()
	       local b
	       b=busy.new()
	       b.interval=0.3
	       b.Next=function()
	         self:jobDone()
	       end
	       b:check()
		end
        return
	  end
	  wait.time(3)
	end)
end

function songxin:reward()
   dangerous_man_list_clear()
   --[[ wait.make(function()
      local l,w=wait.regexp("^(> |)好！任务完成，你被奖励了：(.*)点实战经验，(.*)点潜能。.*|^(> |)恭喜你！你成功的完成了送信任务！你被奖励了：",5)
	  if l==nil then
	     self:reward()
	     return
	  end

	  恭喜你！你成功的完成了送信任务！你被奖励了：
四十点经验!
十三点潜能!
书生顺手在信
清理后: 10188.86328125
set action 送信
看守接过信看了看，点了点头说道：这位小兄弟辛苦你了。
恭喜你！你成功的完成了送信任务！你被奖励了：
一百三十四点经验!
四十四点潜能!
看守顺手在信上勾画了几下，然后合上信封，又交还给了你。
看守在你的耳边悄声说道：你赶紧把它送到「明教雷字门」的「宝忠」手上。
第二次投递 明教雷字门 宝忠
]]
	  --if string.find(l,"任务完成") or string.find(l,"你被奖励了") then

		local rd=reward.new()
		rd.finish=function()
         local ts={
	           task_name="送信",
	           task_stepname="奖励",
	           task_step=8,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	       }
	     local st=status_win.new()
	     st:init(nil,nil,ts)
     	 st:task_draw_win()
		 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."送信任务:奖励! 经验:"..rd.exps_num.." 潜能:"..rd.pots_num, "red", "black") -- yellow
		  --exps=tonumber(exps)+ChineseNum(w[2])
		end
		rd:get_reward()
	--	return
    -- end
   --end)
end


function songxin:is_jobOver()
   wait.make(function()
       world.Send("set action 送信")
       local l,w=wait.regexp("^(> |).*在你的耳边悄声说道：.*送到「(.*)」的「(.*)」手上。$|^(> |).*在你的耳边悄声说道：你赶紧把它送到「$|^(> |)设定环境变量：action \\= \\\"送信\\\"$",5)
	   if l==nil then
		 self:is_jobOver()
		 return
	   end
	   if string.find(l,"」手上。") then
		 self.status="送信2"
		 print("第二次投递",w[2],w[3])
		 self:strong()  --探测强度
	     self:deliveryAgain(w[2],w[3])

		return
	   end
	   if string.find(l,"在你的耳边悄声说道：你赶紧把它送到「") then
		 self.status="送信2"
		 self:bigword()
		 return
	   end
	   if string.find(l,"设定环境变量：action") then
	     print("任务结束")
		 world.DeleteTrigger("sx")
		 self.is_end=true
		 local b
	     b=busy.new()
	     b.interval=0.5
	     b.Next=function()
	       self:jobDone()
	     end
	     b:check()
		 return
	   end
	   wait.time(5)
   end)
end

function songxin:recover2(npc_id)

	world.Send("yun recover")
	world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()
	    if h.qi_percent<100 and h.qi_percent>=80 then --受伤了
		    print("打通经脉")
            local rc=heal.new()
			--rc.saferoom=505
			rc.hudiegu=function()
			  rc:heal(false,false)
			end
			rc.heal_ok=function()
			   self:recover2(npc_id)
			end
			rc:heal(true,false)
		elseif h.qi_percent<80 then
		     self:songxin(npc_id,1,true)

		elseif h.neili<=math.floor(h.max_neili*1.2) then
		    local x
			x=xiulian.new()
			x.safe_qi=200
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
				  world.Send("yun jing")
				  world.Send("yun recover")
				  local f=function()
				     self:recover2(npc_id)
				  end
				  f_wait(f,2)
			    end
				if id==777 then
				  self:recover2(npc_id)
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

			          self:recover2(npc_id)
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
			   world.Send("yun recover")
			   --print(h.neili,math.floor(h.max_neili*self.neili_upper))
			   if h.neili>math.floor(h.max_neili*self.neili_upper) then
			       self:songxin(npc_id,1,true)
			   else
	             print("继续修炼")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
            self:songxin(npc_id,1,true)
		end
	end
	h:check()
end

function songxin:look_letter(id,index,recover)
--    「燕子坞长廊 邝礼」 亲启。
   world.Send("look letter")
   wait.make(function()
       local l,w=wait.regexp("^(> |)\\s*「(.*) (.*)」 亲启。$|^(> |)你要看什么？$",5)
	   if l==nil then
	      self:look_letter(id,index,recover)
	      return
	   end
	   if string.find(l,"你要看什么") then
	      self:giveup()
	      return
	   end
	   if string.find(l,"亲启") then
	      print("确定")
	      print("地点",w[2]," 人名 ",w[3])
		  if self.target_npc~=w[3] then
		     self:delivery(w[2],w[3])
		  else
		      if index==nil or index==1 then
	     	      index=2
			  else
		          index=index+1
		      end
	          self:songxin(id,index,recover)
		  end
	      return
	   end
   end)
end

function songxin:songxin(id,index,recover)
--判断下是否做送信2
  if self.shashou_level>0 and recover~=true and self.status~="送信2" then
     print("做送信2,先恢复下！！")
  	local ts={
	           task_name="送信",
	           task_stepname="做送信2恢复",
	           task_step=5,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 self:recover2(id)
     return
  end
--判断结束
  --self:begin_transaction(function() self:songxin(id,index) end)  --断点
  print("投递信件")
  wait.make(function()
    if index==1 or index==nil then
      world.Send("songxin "..id)
	else
	  world.Send("songxin "..id.." "..index)
	end
	--游客奇怪道：你看清楚，是否送错人了，和我同名的人可不少哦。
	--昌旺业鲁道：这封信不是给我的，你是不是送错了？> 芒卓巴康道：这封信不是给我的，你是不是送错了？
    --你擦了一把额头的汗，从怀中掏出信交给凌黛说道，这是长乐帮赵振辉让在下送给您的信，请您收好。
     local l,w=wait.regexp("(> |)你要送给谁？$|^(> |).*道：这封信不是给我的，你是不是送错了？$|^(> |).*奇怪道：你看清楚，是否送错人了，和我同名的人可不少哦。|(> |)看清楚点，那是活人吗？！$|^(> |)你擦了一把额头的汗，从怀中掏出信交给.*说道，这是.*让在下送给您的信，请您收好。$|^(> |)什么.*$",10)
	 --教书先生在你的耳边悄声说道：你赶紧把它送到「莆田少林六祖殿」的「尹高定」手上。
	 if l==nil then
	   self:songxin(id,index,recover)
	   return
	 end
	 if string.find(l,"这封信不是给我的") then
	    self:look_letter(id,index,recover)

    	 return
	 end
	 if string.find(l,"和我同名的人可不少哦") then
	    self:NextPoint()
	    return
	 end
	 if  string.find(l,"你要送给谁") then
	    self:continue()
	    return
	 end
	 if string.find(l,"看清楚点，那是活人吗") then
	   -- wait npc auto 晕了
	    local f=function()
		self:songxin(id,index,recover)
		end
		print("等待1.5秒")
		f_wait(f,1.5)
	    return
	 end

	 if string.find(l,"你擦了一把额头的汗，从怀中掏出信交给") then
	    shutdown()
	    --没有后续任务
		self:reward()
		self:is_jobOver()
	    return
	 end
	 if string.find(l,"什么") then
	    print("是否信件丢失")
		self:check_letter()
	    return
	 end
	 wait.time(10)
  end)
end

function songxin:send(npc,id)
   id=string.lower(Trim(id))
   self._id=id
   print(npc," id:=",self._id)
   if self.shashou_all_die==false then
     if self.immediate_sx1==true or self.target_roomno==4141 then  --全真药剂室是安全房间 无法fight
	     self:strong()--强度探测
         self:songxin(id)
	 else
		 self.check_idle=true
	     self:auto_pfm()
         world.Send("follow "..id)
	  end
   else
     self:strong()--强度探测
     self:songxin(id)
   end

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

function songxin:checkPlace(npc,roomno,here,Callback)
   if is_contain(roomno,here) then
  	     print("等待0.3s,下一个房间")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     Callback()
		   end
		   b:check()
		 end
		 f_wait(f,0.3)
	   else
	   --没有走到指定房间
	    print("没有走到指定房间")
		  local f1=function()
		     self:NextPoint()
		  end
	      local w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		     print("checkplace giveup")
		      self:giveup()
		  end
		  --[[al.circle_done=function()
		     print("遍历")
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkNPC(npc,nil,f2)
		  end]]
		  al.maze_done=function()
		       print("送信迷宫遍历")

			 self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.noway=function()
		     self:NextPoint()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复")
				  coroutine.resume(songxin.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764,f1)
		  end
		  w.noway=function()
		     self:NextPoint()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno,f1)
		  end
		  if roomno>0 then
		     w:go(roomno)
		  else
		    self:NextPoint()
		  end
	   end
end

function songxin:checkNPC(npc,roomno,Callback)
  --print(roomno," room")
  --print(npc," npc")
  --print(Callback," callback")
   --self:begin_transaction(function() self:checkNPC(npc,roomno) end)  --断点
   wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno,Callback)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      if roomno==nil then  --迷宫
			local b
		    b=busy.new()
		    b.interval=0.5
		    b.Next=function()
		      Callback()
		    end
		    b:check()
		     return
		  end
	      --没有找到
		  --print("Next 地点")
		  local f=function(r)
		     self:checkPlace(npc,roomno,r,Callback)
		  end
		  WhereAmI(f,10000) --排除出口变化
		  return
	  end
	  if string.find(l,npc) then
	     print("找到目标")
	     --找到

		  self:send(npc,w[2])
		  return
	  end
	  wait.time(6)
   end)
end

   --晶琴宝钗神志迷糊，脚下一个不稳，倒在地上昏了过去。

function songxin:combat_end(cb)

end

function songxin:combat()
end

function songxin:sure_shashou()
end

function songxin:shashou(name,id)
     id=Trim(id)
	 id=string.lower(id)
	 print("杀手:",name,id)
	 self.shashou_name=name
	 local _item={}
	 _item.shashou_id=id
	 _item.shashou_name=name
	 table.insert(self.shashou_list,_item)
	 self.get_shashou_id(id) --回调函数 给combat 对象赋值
	 self:sure_shashou()
	 -- 加入危险人物列表
	 dangerous_man_list_add(name)
end
--[[function songxin:sec_shashou(name,id)
     id=Trim(id)
	 id=string.lower(id)
	 print("sec ","杀手:",name,id)
	 self.sec_shashou_id=id
	 self.sec_shashou_name=name
	 self:sure_sec_shashou()
end]]

function songxin:get_id(npc)
	wait.make(function()
		 world.Execute("look")
	    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$",5)
		if l==nil then
		   self:get_id(npc)
		   return
		end
		if string.find(l,npc) then
		   self:shashou(npc,w[2])
		   return
		end
		wait.time(5)
	end)
end
--获得第二个id
--[[function songxin:get_sec_id(npc)
	wait.make(function()
		 world.Execute("look")
	    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$",5)
		if l==nil then
		   self:get_sec_id(npc)
		   return
		end
		if string.find(l,npc) then
		   self:sec_shashou(npc,w[2])
		   return
		end
		wait.time(5)
	end)
end]]

function songxin:continue()
    local w
	w=walk.new()
	local al
	al=alias.new()
	--al.break_pfm=self.break_pfm
	al.break_in_failure=function()
	   print("continue 放弃")
	  self:giveup()
	end
	al.noway=function()
	  self:NextPoint()
	end
	w.noway=function()
	  self:giveup()
	end
	local f1=function()
	    self:NextPoint()
	end
	w.user_alias=al
	w.walkover=function()
		self:checkNPC(self.target_npc,self.target_roomno,f1)
	end
	--w:go(2745)
	w:go(self.target_roomno)
end

function songxin:loot_corpse()
end

function songxin:loot(index)
  --print("loot corpse")
  self.shashou_all_die=true
   wait.make(function()
    if index==nil or index==1 then
     world.Send("get silver from corpse")
	  world.Send("get gold from corpse")
	 world.Send("get letter from corpse")
	 world.Send("get silver from corpse 2")
	else
	 world.Send("get gold from corpse "..index)
	 world.Send("get silver from corpse "..index)
	 world.Send("get letter from corpse "..index)
	 world.Send("get silver from corpse "..index+1)
	end
	world.Send("set look 1")
	 --你找不到 corpse 2 这样东西。
	 --你从令狐拓哉的尸体身上搜出一封信件。
	 local l,w=wait.regexp("你从.*尸体身上搜出一封信件。|你找不到 corpse.*这样东西。|^(> |)设定环境变量：look \\= 1",3)
	 if l==nil then
	    self:loot(index)
		return
	 end

	 if string.find(l,"尸体身上搜出一封信件") then
	    self:loot_corpse()
	    if self._id~="" then
		   self:strong()--强度探测
		   self:songxin(self._id)
	    else
		   if self.target_roomno==-99 then
		     self:NextPoint()  --遍历进程还未启动
		   else
		     self:continue()
		   end
	    end
	    return
	 end
	 if string.find(l,"你找不到") then
	    self:check_letter()
	    return
	 end
	if string.find(l,"设定环境变量：look") then
	   local new_index
	   if index==nil then
	      new_index=1
		else
		  new_index=index+1
	   end
	    self:loot(new_index)
	    return
	 end
	 wait.time(3)
	end)

end

function songxin:check_letter()
    --print("检查信件")

	wait.make(function()
	   world.Execute("i;set action 检查")

	   local l,w=wait.regexp("^(> |)  一封信件\\\(Letter\\\)$|^(> |)设定环境变量：action \\= \\\"检查\\\"$",3)
	   if l==nil then
	     self:no_live()
		 return
	   end
        if string.find(l,"信件") then
		   print("有letter")
		   if self._id~="" then
		     self:strong()--强度探测
		     self:songxin(self._id)
	       else
		     self:continue()
	       end
		   return
		end
		if string.find(l,"设定环境变量：action") then
			print("no letter")
	        self:giveup()
		   return
		end
	end)
end

function songxin:no_live()
   --self:giveup()
   local b=busy.new()
   b.Next=function()
     self:loot()
   end
   b:check()
end

function songxin:lookCorpse()

	--self:begin_transaction(function() self:lookCorpse() end)  --断点
    wait.make(function()
	    print("查看尸体")
		local regexp="^(> |)设定环境变量：look \\= 1$"
		for _,i in ipairs(self.shashou_list) do
		    local name
			local id
			name=i.shashou_name
			id=i.shashou_id
		    regexp=regexp.."|^(> |).*"..name.."\\\(.*\\\) <战斗中>$|^(> |).*"..name.."\\\(.*\\\) <昏迷不醒>$"
		end
	     world.Execute("look;set look 1")
		 local l,w=wait.regexp(regexp,3)
		   --  地煞门女杀手 钱菊燕(Qian juyan) <战斗中>
		   --  地煞门女杀手 钱菊燕(Qian juyan) <昏迷不醒>
		if l==nil then
		   self:lookCorpse()
		   --self:giveup() --没有尸体
		   return
		end
--你附近没有这样东西。
--你紧张起来，不由一摸衣袋，不好！信被偷了!
--你从令狐拓哉的尸体身上搜出一封信件。

		if string.find(l,"昏迷不醒") then
		   print("还没有死绝")
		   local f=function()
		      for _,i in ipairs(self.shashou_list) do
				 local name
			     local id
				 name=i.shashou_name
			     id=i.shashou_id
				 world.Send("kill "..id)
			  end
		      self:lookCorpse()
		   end
		   f_wait(f,1.5)
		   return
		end
		if string.find(l,"战斗中") then
		   --print("死而复生！！！")
		   print("还在战斗中")
		   local f=function()
		      for _,i in ipairs(self.shashou_list) do
				 local name
			     local id
				 name=i.shashou_name
			     id=i.shashou_id
				 world.Send("kill "..id)
			  end
		      self:combat()
		   end
		   f_wait(f,0.5)
		   return
		end
		if string.find(l,"设定环境变量：look") then
		   shutdown()
		   self:no_live()
		   return
		end
		wait.time(3)
	end)
end
--青龙门弟子在你的耳边悄声说道：可能有个武功和你相比微不足道的家伙要来抢你的信，你应该随便对付几下就可以了吧。
--两个强盗
--[[
糟糕，又冲上来了个人！
皇甫玲说道：「师兄，点子硬得很，我来帮你！！！」
看起来皇甫玲想杀死你！
]]
function songxin:secondCome()
   wait.make(function()
   --你定睛一看，原来是伍宗政康，而且此人武功极高，似乎用的是昆仑派的迅雷十六剑！
      local l,w=wait.regexp("^(> |)糟糕，又冲上来了个人！$",10)
	  if l==nil then
	     self:secondCome()
		 return
	  end
	  if string.find(l,"又冲上来了个人") then
	     self:secondAttack()
		 return
	  end
	  wait.time(10)
   end)
end

function songxin:secondAttack()
  --print("sec killer")
  wait.make(function()
   --你定睛一看，原来是伍宗政康，而且此人武功极高，似乎用的是昆仑派的迅雷十六剑！
      local l,w=wait.regexp("^(> |)(.*)说道：「师兄，点子硬得很，我来帮你！！！」$",10)
	  if l==nil then
	     self:secondAttack()
		 return
	  end
	  if string.find(l,"师兄，点子硬得很，我来帮你") then
	     print("sec ","who:",w[2])
		 if self.on_attack==false then
		   self.on_attack=true
		   shutdown()
		   self:get_id(w[2])
		   self:wait_shashou_die()
		   self:wait_shashou_idle()
		   self.combat()
		 else
		    self:get_id(w[2])
		 end
		 return
	  end
	  wait.time(10)
   end)
end

function songxin:deal_blacklist(skill)
   if self.blacklist=="" or self.blacklist==nil then
      return false
   end
   local blacklist=Split(self.blacklist,"|")
	for _,b in ipairs(blacklist) do
	       local i=Split(b,"&")
		   local party_name=i[1]
		   local party_skill=i[2]

		   if string.find(skill,party_name) then
		     if party_skill==nil then
			    return true
			 elseif string.find(skill,party_skill) then
			    return true
		 	 end
		   end
	end
	return false
end

function songxin:UnderAttack()
   --shutdown()
 --  你紧张起来，不由一摸衣袋，不好！信被偷了!
 --舒杨举说道：「小子，乖乖把密函交出来吧！！！」
   print("wait attack")
   world.Execute("halt;halt;halt;halt")
   self:secondCome()
   wait.make(function()
   --你定睛一看，原来是伍宗政康，而且此人武功极高，似乎用的是昆仑派的迅雷十六剑！
      local l,w=wait.regexp("^(> |)(.*)说道：「.*，乖乖把密函交出来吧！！！」$|^(> |)你定睛一看，原来是(.*)，而且此人武功(.*)，似乎用的是(.*)！",10)
	  if l==nil then
	     self:UnderAttack()
		 return
	  end
	  if string.find(l,"乖乖把密函交出来吧") then
	     --print("who:",w[2])
		   	local ts={
	           task_name="送信",
	           task_stepname="送信1战斗",
	           task_step=4,
	           task_maxsteps=8,
	           task_location="",
	           task_description=w[2],
	        }
	       local st=status_win.new()
         	st:init(nil,nil,ts)
         	st:task_draw_win()
		  self.shashou_name=w[2]
		  self:wait_shashou_die()
		  self:wait_shashou_idle()
		print("是否放弃? ",self.is_giveup)
		if self.is_giveup==true then
		  self.danger=true
		  self:flee()
		else
		  self.on_attack=true
		  self:combat()
		  self:get_id(w[2])
		end
		 return
	  end
	  if string.find(l,"你定睛一看") then
	    --print("who:"," name:",w[4]," 武功:",w[5]," 技能:",w[6])
		 --world.AppendToNotepad (WorldName(),os.date().." 武功:"..w[5].." 技能:"..w[6].."\r\n")
		  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."送信任务:"..w[4].."武功:"..w[5].." 技能:"..w[6], "red", "black") -- gray on white
		   	local ts={
	           task_name="送信",
	           task_stepname="送信2战斗",
	           task_step=6,
	           task_maxsteps=8,
	           task_location="",
	           task_description=w[4].." 武功:"..w[5].." 技能:"..w[6],
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
		--who:  name: 卞茅康严  武功: 极高  技能: 星宿派的天山杖法
		local skill= Trim(w[6])
		self.shashou_name=w[4]
		self.robber_skill=skill
		print("是否放弃? ",self.is_giveup)

		if self:deal_blacklist(skill) or self.is_giveup==true then
		   shutdown()
		   print("危险技能逃跑!!!")
		   self.danger=true
		   self:flee()
		   return
		end
		self:wait_shashou_die()
		self:wait_shashou_idle()
		self.on_attack=true
		self:get_id(w[4])
		self:combat()
		return
	  end
	  wait.time(10)
   end)
end

function songxin:shield() --护体内功 回调函数

end

function songxin:wait_shashou()
--[[你觉得有些不妙，似乎被人跟踪上了！
你隐约感觉到有人围了过来。。!!!
你紧张起来，不由一摸衣袋，不好！信被偷了!
巫马睿说道：「小子，乖乖把密函交出来吧！！！」
看起来巫马睿想杀死你！
你聚精会神地盯着巫马睿，寻找最佳出招机会。]]
   wait.make(function()
      local l,w=wait.regexp("^(> |)你觉得有些不妙，似乎被人跟踪上了！$|^(> |)你紧张起来，不由一摸衣袋，不好！信被偷了!$",10)
	  if l==nil then
	     if self.check_idle==true then
		     world.Send("look")
		 end
	     self:wait_shashou()
		 return
	  end
	  --
	  if string.find(l,"你觉得有些不妙，似乎被人跟踪上了") or string.find(l,"你紧张起来，不由一摸衣袋，不好！信被偷了") then
	      shutdown()
	      self:UnderAttack()
		  return
	  end
	  wait.time(10)
   end)
end

local function giveup_Location(location)
   local pos=world.GetVariable("sx_giveup_pos") or ""
    local P={}
	if pos=="" then
	   return false
	end
	P=Split(pos,"|")
	for _,loc in ipairs(P) do
	  if string.find(location,loc) then
	     return true
	  end
	end
   return false
end

function songxin:delivery(location,npc)
   if zone_entry(location)==true or giveup_Location(location)==true then
      self:giveup()
      return
   end
  	local ts={
	           task_name="送信",
	           task_stepname="第一次投递",
	           task_step=2,
	           task_maxsteps=8,
	           task_location=location,
	           task_description="送信给"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
 --self:begin_transaction(function() self:delivery(location,npc) end)  --断点
 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."送信任务:第一次投递"..npc.." "..location, "white", "black") -- gray on white
 local n,rooms=Where(location)
 if npc~="教众" then  --容易给杀npc
   rooms=depth_search(rooms,1)  --范围查询
 end
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	     local al
		  al=alias.new()
		  al:SetSearchRooms(rooms)
	   songxin.co=coroutine.create(function()
	    for index,r in ipairs(rooms) do
		  print("送信1 ","目标房间:",r)
          local w
		  w=walk.new()
		  local f1=function()
		     self:NextPoint()
		  end

		  al.do_jobing=true
		   ---杀手没出现以前
		  if self.shashou_all_die==false then
		      local exps=tonumber(world.GetVariable("exps")) or 0 --获取任务的exp值
		      if exps<=800000 then

			   al.compare=function(f)
			      print("经验值低于800k,等待杀手出现!,不直接闯入!")
			      local s1=function()
				    print("原地等待")
				    self:look()
				  end
				  local f1=function()
				     print("放弃")
				     self.is_giveup=true
				     self:giveup()
				   end
			     al:PreCompare(s1,f1)
			   end
		      end
		  al.yellboat_wait=function()
		     print("不再打坐!")
             --print("不坐渡船")
			 local f=function()
			   al:yellboat()
			 end
			 f_wait(f,1.2)
		  end

		  al.quyanziwu=function()
		      print("等待杀手出现!")
              print("不坐渡船")
		  end
		  al.qumr=function()
		      print("等待杀手出现!")
              print("不坐渡船")
		  end
		  al.zuomufa=function()
		       print("等待杀手出现!")
			   print("不坐渡船")
		  end
		  al.gudi_gudishuitan=function()
		     print("等待杀手出现!")
			  -- print("不坐渡船")
		  end
		 end
         ---杀手没出现以前 结束
		  al.maze_done=function()
			 print("送信迷宫遍历 ")
			 self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.huigong=function()
		     self:NextPoint()
		  end
          al.noway=function()
		     self:NextPoint()
		  end
		  w.user_alias=al
		  w.noway=function()
		    self:NextPoint()
		  end
		  w.walkover=function()
		     --local f1=function() self:NextPoint() end
		     self:checkNPC(npc,r,f1)
		  end
		  self:auto_pfm()
		  self:wait_shashou()
		  self.check_idle=false
		  self.target_npc=npc
		  self.target_roomno=r
		  if index==1 then
		    w.current_roomno=506
		  end
		  if r>0 then
		     w:go(r)
		     coroutine.yield()
		  end
	    end
		print("没有找到npc!!")
		self:giveup()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("没有目标")
	  self:giveup()
	end
end

function songxin:auto_escape()
  wait.make(function()
	   local l,w=wait.regexp("^(> |)设定环境变量：lookway \\= \\\"YES\\\"",5)
	   if l==nil then
	      self:auto_escape()
		  return
	   end
	   if string.find(l,"设定环境变量：lookway") then
	       self:lookway()
		  return
	   end
  end)
end

function songxin:lookway()
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
	 if _R.roomname=="洗象池边" then
	    world.Send("alias pfm "..run_dx..";set lookway")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set lookway")
	 end
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
	 self:auto_escape()
   end
   _R:CatchStart()
end

function songxin:look()
     _R=Room.new()
        _R.CatchEnd=function()
          local count,roomno=Locate(_R)
		  print("保存战斗房间号:",roomno[1])
		   _G["fight_Roomno"]=roomno[1]
		  if roomno[1]==46 then
		     world.Send("west")
			 world.Send("west")
			  _G["fight_Roomno"]=47
		  end
		  f=function()
	         self:look()
	      end
		  f_wait(f,10)
	    end
	_R:CatchStart()
end

function songxin:recover()
     --战斗模块 开始的话 不执行
	 if table.getn(self.shashou_list)>0 or self.on_attack==true then
	    print("正在战斗中，停止打坐")
	    return
	 end

    -- self:begin_transaction(function() self:recover() end)  --断点
	world.Send("yun recover")
	world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()
	    if h.qi_percent<100 and h.qi_percent>=80 and h.neili>=h.max_neili*0.9 then --受伤了
		    print("打通经脉")
            local rc=heal.new()
			rc.hudiegu=function()
			  rc:heal(false,true)
			end
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal(true,false)
		elseif h.qi_percent<80 or h.neili<=h.max_neili*0.5 then
		    print("内力太少，或受伤太严重，放弃job")
		    world.Send("no")
			world.DeleteTrigger("sx")
			shutdown()
		    local b
	         b=busy.new()
	         b.interval=0.3
	         b.Next=function()
	           self:jobDone()
	         end
	         b:check()
		elseif h.neili>h.max_neili*0.5 then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun recover")
				  local f=function()
				     self:recover()
				  end
				  f_wait(f,2)
			    end
				if id==777 then
				  self:recover()
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
					   --BigData:catchData(505,"青石街")
			          self:recover()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
			   world.Send("yun recover")
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			      if table.getn(self.shashou_list)>0 or self.on_attack==true then
	                print("正在战斗中")
	                return
	              end

			      print("开始发呆等待杀手！！")
				  self:shield()
				  self:look()
				  --self:NextPoint()
			   else
	             print("继续修炼")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
		     if table.getn(self.shashou_list)>0 or self.on_attack==true then
				print("正在战斗中")
				return
			 end
		     print("状态良好")
		     self:NextPoint()
		end
	end
	h:check()
end

function songxin:deliveryAgain(location,npc)
	local ts={
		task_name="送信",
		task_stepname="做送信2恢复",
		task_step=5,
		task_maxsteps=8,
		task_location=location,
		task_description="送信给"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   if zone_entry(location)==true then
	  print("无法前往该区域")
	  shutdown()
	  world.DeleteTrigger("sx")
	  world.Send("no")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:jobDone()
	  end
	  b:check()
      return
   end

  self._id="" --初始化
  self.shashou_list={}
  self.is_giveup=false
  self.on_attack=false
  self.check_idle=false
  print("location:",location)
 local n,rooms=Where(location)
 --if location=="扬州城北大街" or location=="嵩山少林戒律院" then
  -- if range~=nil then
	 rooms=depth_search(rooms,6)  --范围查询
  -- end
 --end
   if n>0 then

	   --print("抓取")
	   --气血恢复 内力恢复
	    --self:shield()--护体神功
		self:auto_pfm()
		self:wait_shashou()
		self:lookway()
		self.target_npc=npc
		self.target_roomno=-99
		local f1=function()
		    self:NextPoint()
		end
	   songxin.co=coroutine.create(function()
	       	local ts={
	           task_name="送信",
	           task_stepname="第二次投递",
	           task_step=7,
	           task_maxsteps=8,
	           task_location=location,
	           task_description="送信给"..npc,
	        }
	       local st=status_win.new()
		   st:init(nil,nil,ts)
	       st:task_draw_win()
           self.status="送信2"
		  local al
		  al=alias.new()
		  al:SetSearchRooms(rooms)
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  al.do_jobing=true
		  print("送信2 ","房间号:",r)
		   --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		 --[[ al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复")
				  coroutine.resume(songxin.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	         -- self.NextPoint=function() al:NextPoint() end
			  local f1=function()
			     al:NextPoint()
			  end
			  self:checkNPC(npc,1764,f1)
		  end]]
          al.fengyun=function()
             self:NextPoint()
          end
          al.tiandi=function()
            self:NextPoint()
		  end
          al.longhu=function()
             self:NextPoint()
          end
		  al.maze_done=function()
		       print("送信迷宫遍历")

		     --[[local f2=function()
				coroutine.resume(alias.circle_co)
			 end]]
			 self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.noway=function()
		     self:NextPoint()
		  end
		  w.user_alias=al
		  w.noway=function()
		     self:NextPoint()
			 --self:giveup()
		  end
		  w.walkover=function()
		    local f1=function()
			  self:NextPoint()
			end
		    self:checkNPC(npc,r,f1)
		  end
		  print("下一个房间号:",r)
		  self.target_roomno=r
		  if r~=-1 and r~=0 then
		    w:go(r)
		    coroutine.yield()
		  end
	    end
		print("没有找到npc!!")
		self:giveup()
	   end)
	else
	  print("没有目标,放弃")
	  shutdown()
	  world.Send("no")
	  world.DeleteTrigger("sx")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:jobDone()
	  end
	  b:check()
	end
end

function songxin:liaoshang_fail()
end
local heal_ok=false
-- 继续送信
function songxin:full()
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 	local qi_percent=world.GetVariable("qi_percent") or 100
		qi_percent=assert(tonumber(qi_percent),"qi_percent变量必须输入数字！") or 100
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

		elseif h.jingxue_percent<=liao_percent or h.qi_percent<=80 then
		    print(h.jingxue_percent," jingxue_percent",h.qi_percent," qi_percent")
		   --│星宿掌毒        五分                     毒 │
		   --可能中毒了
			  print("疗伤")
              local rc=heal.new()
			  rc.saferoom=505
			  --rc.teach_skill=teach_skill --config 全局变量
			  rc.heal_ok=function()
			     heal_ok=true
			     self:Status_Check()
			  end
			  rc.liaoshang_fail=function()
			   print("sx 疗伤fail")
			    self:liaoshang_fail()
			    local f=function()
					rc:heal(false,true)
				end
				local drugname
				local drugid
				if h.jingxue_percent<=80 then
				    drugname="活血疗精丹"
				    drugid="huoxue dan"
				else
				    drugname="蝉蜕金疮药"
				    drugid="chantui yao"
				end
			    rc:buy_drug(drugname,drugid,f)
			end
			  rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("打通经脉")
            local rc=heal.new()
			world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			    world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   --heal_ok=true
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
				if id==777 then
				  self:full()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(505)
			   end
			end
			x.success=function(h)
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
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end
--
function songxin:Status_Check()
  	local ts={
	           task_name="送信",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --初始化
	  self.shashou_list={}
	  self._id=""
	  self.target_roomno=""
	  self.target_npc=""
	  self.is_end=false
	  self.is_giveup=false
	  self.danger=false
	  self.on_attack=false
     --self:begin_transaction(function() self:Status_Check() end)  --断点

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
					  local f=function()
			             self:Status_Check()
					  end
					  f_wait(f,3)
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
			        rc:heal(true,false)
				    return
				 end
			   end
		     end
            self:full()
		end
		cd:start()
end

function songxin:jobDone()  --回调函数
end

function songxin:test_combat()
end

function songxin:wait_shashou_die()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了。$",5)
	 if l==nil then
	    self:wait_shashou_die()
	    return
	 end
	 if string.find(l,"挣扎着抽动了几下就死了") then
	    print(self.guard_name,w[2])
		for pos,item in ipairs(self.shashou_list) do
		   local name=item.shashou_name
		   if string.find(w[2],name) then
		      table.remove(self.shashou_list,pos)
			  print(table.getn(self.shashou_list))
			  -- 减法
			  if table.getn(self.shashou_list)>0 then
			    self:sure_shashou()
			  else
			    self.on_attack=false
			    print("等待,测试战斗是否结束！")
				self:test_combat()
			    --self:combat_end()
              end
			  break
		   end
		end
		self:wait_shashou_die()
	    return
	 end
	 wait.time(5)
   end)
end
--华睿岳神志迷糊，脚下一个不稳，倒在地上昏了过去。

function songxin:auto_pfm()

end

function songxin:kill_shashou(name,id)
  self:auto_pfm()
  world.Send("kill "..id)

  wait.make(function()
    --看起来皇甫玲想杀死你！

    local l,w=wait.regexp("^(> |)看起来"..name.."想杀死你！$|^(> |)加油！加油！$|^(> |)这里没有这个人。$|^(> |)你对着"..name.."大喝一声.*",5)
	if l==nil then
	   self:kill_shashou(name,id)
	   return
	end
	if string.find(l,"这里没有这个人") then
	   self:lookCorpse()
	   return
	end
	if string.find(l,name) or string.find(l,"加油！加油") then
	   print(name," kill ok")
	   return
	end
    wait.time(5)
  end)
end

function songxin:get_shashou_id(id) --回调函数

end

function songxin:wait_shashou_idle()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)神志迷糊，脚下一个不稳，倒在地上昏了过去。$",5)
	 if l==nil then
	    self:wait_shashou_idle()
	    return
	 end
	 if string.find(l,"倒在地上昏了过去") then
	    --print(self.guard_name,w[2])
	    for pos,item in ipairs(self.shashou_list) do
		   local id=item.shashou_id
		   local name=item.shashou_name
		   if string.find(w[2],name) then
		      self:kill_shashou(name,id)
			  break
		   end
		end
		self:wait_shashou_idle()
	    return
	 end
	 wait.time(5)
   end)
end


function songxin:liuhe()
--[[(*){姑苏慕容|华山派|明教}的高手，尤为擅长(*)的功夫。
set 六合劲 开合

^宋远桥在你的耳边悄声说道：据门派弟子来报，此人是来自(*){天龙寺|少林派}的高手，尤为擅长(*)的功夫。
set 六合劲 软手
^宋远桥在你的耳边悄声说道：据门派弟子来报，此人是来自(*){铁掌帮|神龙教|星宿派}的高手，尤为擅长(*)的功夫。
set 六合劲 螺旋
^宋远桥在你的耳边悄声说道：据门派弟子来报，此人是来自(*){大轮寺|丐帮|武当派}的高手，尤为擅长(*)的功夫。
set 六合劲 钻翻
^宋远桥在你的耳边悄声说道：据门派弟子来报，此人是来自(*){峨嵋派|嵩山派|昆仑派|桃花岛}的高手，尤为擅长(*)的功夫。
set 六合劲 虚灵
^宋远桥在你的耳边悄声说道：据门派弟子来报，此人是来自(*){古墓派|古墓派}的高手，尤为擅长(*)的功夫。
set 六合劲 静恒]]
 if string.find(self.robber_skill,"姑苏慕容") or string.find(self.robber_skill,"华山派") or string.find(self.robber_skill,"明教") then
    world.Send("set 六合劲 开合")
 elseif string.find(self.robber_skill,"天龙寺") or string.find(self.robber_skill,"少林派") then
    world.Send("set 六合劲 软手")
 elseif string.find(self.robber_skill,"铁掌帮") or string.find(self.robber_skill,"神龙教") or string.find(self.robber_skill,"星宿派") then
    world.Send("set 六合劲 螺旋")
 elseif string.find(self.robber_skill,"大轮寺") or string.find(self.robber_skill,"丐帮") or string.find(self.robber_skill,"武当派") then
   world.Send("set 六合劲 钻翻")
 elseif string.find(self.robber_skill,"峨嵋派") or string.find(self.robber_skill,"嵩山派") or string.find(self.robber_skill,"昆仑派") or string.find(self.robber_skill,"桃花岛") then
   world.Send("set 六合劲 虚灵")
 elseif string.find(self.robber_skill,"古墓派") then
   world.Send("set 六合劲 静恒")
 else
    world.Send("set 六合劲 虚灵")
 end
end

