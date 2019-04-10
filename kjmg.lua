--  波斯商人(Bosi shangren)
--> 你速度太慢，蒙古武士已过遇真宫-副本，任务失败。
--你一看西边有一座高山，山势险峻，正是鲁长老所说的遇真宫-副本，便不再犹豫，毅然提气飞纵而上！

local look_count=0

kjmg={
  new=function()
    local _kjmg={}
	 setmetatable(_kjmg,{__index=kjmg})
	 return _kjmg
  end,
  robber_name="蒙古武士",
  robber_id="wushi",
  wave_set=2, --默认是12波
  wave=0,
  smy_safety_percent=0.6,
  neili_upper=1.9,

}


function kjmg:combat()

end
--[[
function kjmg:run(i)


   wait.make(function()
	   local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)你逃跑失败。$|^(> |)你正在使用.*暂时无法停止战斗。$|^(> |)你的修为不够！$|^(> |)设定环境变量：action \\= \\\"逃跑\\\"$",1.5)
	   if l==nil then
	      self:run(i)
	      return
	   end
	   if string.find(l,"你的修为不够") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"你的动作还没有完成，不能移动") or string.find(l,"你逃跑失败") or string.find(l,"暂时无法停止战斗") then
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
			   shutdown()
			   world.Send("unset wimpy")
			   --self:giveup()
			   self:job_failure()
         self:jobDone()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end]]

function kjmg:shield()
end

function kjmg:job_failure() --回调函数
end

function kjmg:jobDone()

end

function kjmg:jobDone()--回调
end

function kjmg:is_reward()

       wait.make(function()
	      local l,w=wait.regexp("^(> |)一阵天旋地转，你一阵恍惚，才发现自己退出了副本空间。$",30)
		  if l==nil then
		     self:is_reward()
		     return
		  end
		  if string.find(l,"一阵天旋地转，你一阵恍惚，才发现自己退出了副本空间") then

		     self:jobDone()

		     return
		  end

	   end)
end


function kjmg:liaoshang_fail()
end

function kjmg:full_food()

	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
   local h
	h=hp.new()
	h.checkover=function()
       if  h.qi_percent<=liao_percent or h.jingxue_percent<=80 then
		    print("疗伤")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc.liaoshang_fail=function()
			   print("kjmg 疗伤fail")
			   self:liaoshang_fail()
			end
			rc:liaoshang()

		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
--- yrs 关闭
		elseif 1==1 then
                  self:ask_job()
               end
    	end
  	h:check()
end

function kjmg:full_neili()

    local qi_percent=tonumber(world.GetVariable("qi_percent")) or 100

	local h
	h=hp.new()
	h.checkover=function()
		if h.jingxue_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			--rc.saferoom=505
			rc.heal_ok=function()
			    self:full_neili()
			end
			rc:heal(false,true)
		elseif h.qi_percent<qi_percent then
			print("打通经脉")
            local rc=heal.new()
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:full_neili()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper)  then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self:full_neili()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,10)
			    end
				if id==777 then
				  self:full_neili()
				end
				if id==101 then
				   world.Send("yun qi")
				   world.Send("yun jing")
				   self:full_neili()
				end
	           if id==202 then
	              local b
			       b=busy.new()
			       b.Next=function()
				     self:auto_pfm()
					 look_count=0
			         self:wait_wushi()
			       end
			       b:check()
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*1.2)
			   world.Send("yun recover")
			   if h.neili>h.max_neili*1.2 then
			       self:auto_pfm()
				   look_count=0
			       --self:wait_wushi()
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
			   self:auto_pfm()
			  --self:wait_wushi()
			end
			b:check()
		end
	end
	h:check()
end


function kjmg:Status_Check()
	local ts={
	           task_name="遇真宫-副本",
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
            self:full_food()
	end
	cd:start()
end

function kjmg:qu_gold()
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
--[[

function kjmg:buy_zhengqidan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy zhengqi dan")
	 local l,w=wait.regexp("你以.*的价格从药店掌柜那里买下了一颗正气丹。|^(> |)你想买的东西我这里没有。$|^(> |)穷光蛋，一边呆着去！",5)
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
	 if string.find(l,"穷光蛋，一边呆着去") then
	    self:qu_gold()
	    return
	 end
	 wait.time(5)
	end)
 end
 w:go(413)
end

function kjmg:eat_zhengqidan()
    wait.make(function()
      world.Send("fu zhengqi dan")
	  world.Send("fu dan")
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

function kjmg:look_zhengqidan()
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
]]

function kjmg:catch()
  wait.make(function()
    local l,w=wait.regexp("^(> |)你按下暗道机关，人影一闪，已不在原处。$|^(> |)郝大通说道：「您上次任务辛苦了，还是先休息一下再说吧。」$",5)

	if l==nil then
	   self:ask_job()
	   return
	end
	if string.find(l,"你按下暗道机关") then
      print ("开始做遇真宫了")
	  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."遇真宫-副本任务:工作开始！", "yellow", "black") -- yellow on white

	  local ts={
	           task_name="遇真宫",
	           task_stepname="前往遇真宫",
	           task_step=2,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  self.wave=0
	   local b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	    self:shield()
	    self:gowushi()
           -- self:jobDone()
	   end
	   b:check()
	   return
	end
	if string.find(l,"我这里现在没有什么任务") then
	    print ("kjmg busy wait")
	    shutdown()
		self.fail(201)
	   return
	end

	if string.find(l,"您上次任务辛苦了") then
	    print ("kjmg busy 换job")
	    shutdown()
	    self.fail(101)
	   return
	end

	wait.time(5)
  end)
end

function kjmg:fail(id)

end

function kjmg:ask_job()
  local w=walk.new()
  w.walkover=function()

     world.Send("ask hao about 抵抗蒙古入侵")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)你向郝大通打听有关『抵抗蒙古入侵』的消息。$",5)
	--   print ("smy catch 1")
	   if l==nil then
	--     print ("smy no catch ")
	     self:ask_job()
	     return
	   end
	   if string.find(l,"你向郝大通打听有关") then
	--     print ("smy catch 2")
	     self:catch()
       --  self:jobDone()
	     return
	   end
	   wait.time(5)
	 end)
  end
  w:go(4173)
end

function kjmg:auto_pfm()

end

--你一阵恍惚，仔细一看却是已到了遇真宫-副本。

function kjmg:gowushi()
  self:wait_wushi()
 self:full_neili()
--[[
   cllimbya=false
  self:climb()
--你一看西边有一座高山，山势险峻，正是鲁长老所说的遇真宫-副本，便不再犹豫，毅然提气飞纵而上！
  local w=walk.new()
  w.walkover=function()
   world.Send("set 积蓄")
   --self:auto_pfm()
     if climbya==true then
      self:kill_finish()
	  self:full_neili()
	else
	   local _R
        _R=Room.new()
        _R.CatchEnd=function()
		  if _R.roomname=="遇真宫-副本" then
		      self:jobDone()
		  else
	          self:gowushi()
		  end
	    end
	    _R:CatchStart()
	end
  end
  w:go(1870)]]
end

function kjmg:skills_index(ski)
   local skills={}
   skills["银龙鞭法"]=0
   skills["玄阴剑法"]=1
   skills["灵蛇杖法"]=2
   skills["天山杖法"]=3
   skills["打狗棒法"]=4
   skills["七伤拳"]=5
   skills["雁行刀法"]=6
   skills["金刚降伏轮"]=7
   skills["腾龙匕法"]=8
   skills["辟邪剑法"]=9
   skills["慕容剑法"]=10
   skills["雁行刀法"]=11
   skills["燃木刀"]=12
   if skills[ski]==nil then
      return 10000
	else
	  return skills[ski]
   end
end

function kjmg:kill_first(ski1,ski2)
  local index1=self:skills_index(ski1)
  local index2=self:skills_index(ski2)
  local id="wushi"
  if index1>index2 then
      id="wushi 2"
  end
  if index2>index1 then
      id="wushi"
  end
  return id
end

function kjmg:leavefb()
   world.Execute("halt;leavefb")
   wait.make(function()
      local l,w=wait.regexp("^(> |)一阵天旋地转，你一阵恍惚，才发现自己退出了副本空间。$",1)
	  if l==nil then
	    self:leavefb()
		return
	  end
	  if string.find(l,"才发现自己退出了副本空间") then
	     world.AppendToNotepad (WorldName().."_抗击蒙古任务:",os.date().." 危险技能逃离副本\r\n")
	     self:finish()
	    return
	  end
   end)
end

function kjmg:check_skills(ski1,ski2)
    world.Execute("look wushi;look wushi 2;set action 技能")
	wait.make(function()
	--此人看上去师承武当派，擅长使用玄虚刀法伤敌！
	  local l,w=wait.regexp("^(> |)此人看上去师承.*，擅长使用(.*)伤敌.*$|^(> |)设定环境变量：action \\= \\\"技能\\\"$",5)

	  if l==nil then
        self:check_skills(ski1,ski2)
	    return
	  end
	  if string.find(l,"此人看上去师承") then
		  local skill=w[2]
		  print(skill," 技能")
		  if ski1==nil then
		     ski1=skill
		  else
		     ski2=skill
		  end
		  self:check_skills(ski1,ski2)
	     return
	  end
	  if string.find(l,"技能") then
	    print(ski1," 1 ",ski2," 2 skills")
		--[[if string.find(ski1,"如意刀法") or string.find(ski2,"如意刀法") then
		   self:leavefb()
		   return
		end]]
		if ski1==nil then
		   ski1=""
		end
		if ski2==nil then
		   ski2=""
		end

		 local id=self:kill_first(ski1,ski2)
		 self.robber_id=id
		 self.target(id)
		 		local ts={
	           task_name="遇真宫-副本",
	           task_stepname="战斗,优先kill "..id,
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="武士1:"..ski1.." 武士2:"..ski2,
	    }
	     local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
	     return
	  end
	end)
end

function kjmg:target(id) --指定id
end
--大蒙古勇士 蒙古武士(Menggu wushi) <昏迷不醒>
function kjmg:wait_wushi()
  print("wait_wushi")
   world.Send("look")
  self.robber_id="wushi"
--shutdown()
  wait.make(function()
   --你定睛一看，原来是伍宗政康，而且此人武功极高，似乎用的是昆仑派的迅雷十六剑！
   --  西夏一品堂武士 哈芙(Ha fu) <战斗中>
      local l,w=wait.regexp("^(> |)山崖北面的小路上闪出两条人影，你纵身而起，立即和人影战在了一起。$|^(> |).*鼓足真气，纵声长啸：“布五行阵”，声音滚滚地传了出去。$|.*大蒙古勇士 蒙古武士.*\\(.*\\) \\<战斗中\\>$|.*大蒙古勇士 蒙古武士.*\\(.*\\) \\<昏迷不醒\\>$",5)
	  if l==nil then
            -- world.Send("look")
             --shutdown()
		 look_count=look_count+1
		 print(look_count,"~lookcount")
         if look_count>300 then
			shutdown()
			world.Send("leavefb")
			self:jobDone()
		    return
		 end
	     self:wait_wushi()
		 return
	  end
	    if string.find(l,"布五行阵") or string.find(l,"战斗中") or string.find(l,"你纵身而起，立即和人影战在了一起") then
	     print("蒙古武士到了")
         look_count=0
             shutdown()
			-- world.Execute("kill wushi;kill wushi 2")
			 self:check_skills()
             self:combat()
	    self:wait_wushi_die()
		 return
	  end
	  if string.find(l,"昏迷不醒") then
	     self:wait_wushi_die()
	     return
	  end


--	  wait.time(3)
   end)
end

function kjmg:reset(id)
end

--远处的山路传来一阵轻啸，隐约听得有人施展轻功飞驰而来。
function kjmg:wait_wushi_die()
  print("wait wushi die")
  world.Send("kill wushi")
  wait.make(function()
   --你定睛一看，原来是伍宗政康，而且此人武功极高，似乎用的是昆仑派的迅雷十六剑！
   --俞端「啪」的一声倒在地上，挣扎着抽动了几下就死了。
      local l,w=wait.regexp("^(> |).*「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$|^(> |).*道：蛮子已有准备，快撤。说完转身逃去了$",10)
	  if l==nil then
	     self:wait_wushi_die()
		 return
	  end

	--  if string.find(l,"蒙古武士鼓足真气") then
--	     print("蒙古武士到了")
	   --  world.Send("ppi")
	     --world.Send("set wimpycmd wield zhubang\\perform chuo wushi\\perform pi wushi\\yun jingli\\hp")
	  --   world.Send("set wimpy 100")
--	    self:wait_wushi_die()
--		   --self:get_id(w[2])
--		 return
--	  end

--[[
	  if string.find(l,"蒙古武士神志迷糊，脚下一个不稳") then
	     print("蒙古武士晕倒了")
	    world.Send("kill wushi")
	    self:wait_wushi_die()
		   --self:get_id(w[2])
		 return
	  end]]
	  if string.find(l,"挣扎着抽动了几下就死了") then
	     print("蒙古武士死了一个")
        if self.robber_id=="wushi 2" then
		   self.robber_id="wushi"
		   self.reset("wushi")
		end
	    self:wait_wushi_die()
		   --self:get_id(w[2])
		 return
	  end
	  if string.find(l,"蛮子已有准备，快撤") then
	     print("失败")
		 shutdown()
		 self.fail(102)
	     return
	  end
	  if string.find(l,"这里没有这个人") then
	     --print("可以撤退了")
       --self.win=true
	 --  local b=busy.new()
	 --  b.interval=0.3
	 --  b.Next=function()

	    shutdown()
	    self.wave=self.wave+1
		local ts={
	           task_name="遇真宫-副本",
	           task_stepname="恢复",
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="波次:"..self.wave,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	if self.wave>12 then
	  self:is_reward()
	    local b=busy.new()
		b.Next=function()
	      world.Execute("get silver from corpse;get silver from corpse 2")
		   world.Execute("get gold from corpse;get gold from corpse 2")
		   world.Send("get zhuanji")
		end
		b:jifa()
	  return
	end
	    local b=busy.new()
		b.Next=function()
	      world.Execute("get silver from corpse;get silver from corpse 2")
		   world.Execute("get gold from corpse;get gold from corpse 2")
		   world.Send("get zhuanji")
		   --self:auto_pfm()
		if self.wave_set<=self.wave  then


		   local ts={
	           task_name="遇真宫-副本",
	           task_stepname="结束",
	           task_step=4,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	       }
	      local st=status_win.new()
	       st:init(nil,nil,ts)
	       st:task_draw_win()
		   self:is_reward()
			world.Execute("leavefb")

		else
		   self:is_giveup()
	    end
        end
		b:jifa()

	 --  b:check()
	   return
	  end
	--  wait.time(10)
   end)
end

function kjmg:is_giveup()
   local h=hp.new()
   h.checkover=function()
     print(h.qi_percent,">=",self.smy_safety_percent*100,":气血")
	 print(h.neili,">=",h.max_neili*0.8,":内力")
     if h.neili>=h.max_neili*0.8 and h.qi_percent>=self.smy_safety_percent*100 then
      local b=busy.new()
	   b.Next=function()
	       self:auto_pfm()
	       self:full_neili()
 	       self:wait_wushi()
	   end
	   b:check()
	 else
	   print("内力不够放弃!")
	   world.Execute("leavefb")
	   self:jobDone()
	 end
  end
  h:check()
end

function kjmg:get_weapon()

end
--[[
function kjmg:kill_finish()
  --远处的山路传来一阵轻啸，隐约听得有人施展轻功飞驰而来。
  wait.make(function()
    local l,w=wait.regexp("^(> |)下方的小路上闪出两条人影，你纵身而起，立即和人影战在了一起。$|^(> |)好，任务完成了，你得到了(.*)点实战经验，五十五点潜能和(.*)点正神。$",6)
	if l==nil then
	  world.Send("look")
	  print("kill finish")
	  self:kill_finish()
	  return
	end
	if string.find(l,"隐约听得有人施展轻功飞驰而来") then
	  --shutdown()
	  look_count=0
	  self:wait_wushi()

	  local b=busy.new()
	  b.Next=function()
	    --自动get weapon
		self:get_weapon()
		self:shield()
	    self:auto_pfm()

	  end
	  b:check()
	  return
	end
	 if string.find(l,"任务完成了") then
       --   shutdown()
       print("触发 jobDone")
       shutdown()
	   self:get_weapon()
	        self:jobDone()
	     return
	   end
  end)
 print("kill finish")
  local w=walk.new()
  w.walkover=function()
   world.Send("set 积蓄")
	     self:job_finish()
	     return
  end
  w:go(1869)
end]]

function kjmg:job_finish()
 print("kjmg finish")
 shutdown()
      wait.make(function()
--     local l,w=wait.regexp("你获得了(.*)点经验，(.*)点潜能！你的侠义正气增加了！$",30)
	   local l,w=wait.regexp("^(> |)好，任务完成了，你得到了(.*)点实战经验，五十五点潜能和(.*)点正神。$",10)
	   if l==nil then
      -- shutdown()
       print("还没触发 jobDone")
	     self:jobDone()
	     return
	   end
	   if string.find(l,"任务完成了") then
       --   shutdown()
       print("触发 jobDone")
          world.Send("wu;get silver from corpse;get silver from corpse 2")
	        self:jobDone()
	     return
	   end
	   wait.time(10)
	 end)
end
