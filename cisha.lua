--kill shiwei
--报效国家
-- ask lu about 报效国家
--[[
 9:
10:  ──────────────────────────────
11:                          【任务要求】
12:  ──────────────────────────────
13:
14:      经验值80K到500K
15:
16:  ──────────────────────────────
17:                          【任务过程】
18:  ──────────────────────────────
19:
20:      事先要准备一根火折（Fire）。
21:      到丐帮土地庙处，向鲁有脚要任务： ask lu about 报效国家；
22:  鲁有脚说道：「蒙古大军侵我大宋襄阳城，每次都以南阳为囤粮之所
23:  ，郭靖郭大侠多次派人偷袭，均因守将防守严密而失败。」
24:      鲁有脚说道：前几天本帮弟子打探到南阳城北有一处断崖，地势
25:  险峻，蒙古兵防守空虚。你从该处爬上去，伺机烧掉蒙古粮仓，以解
26:  我襄阳之围。
27:      襄阳以北向少林、嵩山处方向向西一步有一处密林，再向北一步
28:  可到断崖；前面是一处十分陡峭的断崖，险峻异常，难以爬越(pa)。
29:      在一定的负重情况下用pa up的命令爬上断崖。上断崖两个sd就到
30:  敌军后仓，守在那里的元兵会auto kill你，一共有五堆草料，杀死元
31:  兵后点火烧草料堆(Caoliao dui)即可，任务完成。回到鲁有脚处领赏。

你向鲁有脚打听有关『报效国家』的消息。
鲁有脚说道：「蒙古大军侵我大宋襄阳城，每次都以南阳为囤粮之所。」
鲁有脚说道：「郭靖郭大侠多次派人偷袭，均因守将防守严密而失败。」
鲁有脚说道：「前几天本帮弟子打探到南阳城北有一处断崖，地势险峻，蒙古兵防守空虚。」
鲁有脚对你说道：你从该处爬上去，伺机烧掉蒙古粮仓，以解我襄阳之围。
>
好，任务已经完成，可以回去复命了。

好，任务完成了，你得到了六百五十四点实战经验，一百五十五点潜能和一千九百六十二点正神。
]]
--gt襄阳城玄武门
--1348 南阳断崖
cisha={
  new=function()
    local cs={}
	  setmetatable(cs,cisha)
	 return cs
  end,
  neili_upper=1.8,
  zhongjun=false,
  npc_count=1,
  kill_count=0,
  version=1.8,
}
cisha.__index=cisha
--你还是先杀了面前的守卫再点火吧。
--元兵「啪」的一声倒在地上，挣扎着抽动了几下就死了。
--好，任务已经完成，可以回去复命了。
function cisha:huoshao_NextPoint()
 local ts={
	           task_name="报效国家",
	           task_stepname="刺杀守卫",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   world.Send("look")
   world.Send("set action 火烧")
   wait.make(function()
   --这个方向没有出路。
      local l,w=wait.regexp("^(> |)断崖 -.*$|^(> |)崖顶 -.*$|^(> |)小路 -.*$|^(> |)后仓 -.*$|^(> |)中仓 -.*$|^(> |)左仓 -.*$|^(> |)右仓 -.*$|^(> |)前仓 -.*$|^(> |)玄武门 -.*$|^(> |)设定环境变量：action = \\\"火烧\\\"$|^(> |)你气喘嘘嘘，感到无法爬上去，摔了下来！$",5)
	  if l==nil then
        self:huoshao_NextPoint()
	    return
	  end
	  if string.find(l,"你气喘嘘嘘，感到无法爬上去，摔了下来") then
	     self:Status_Check()
	     return
	  end
	  if string.find(l,"断崖") then
	     world.Send("pa up")
	     self:huoshao_NextPoint()
	    return
	  end
	  if string.find(l,"崖顶") then
		 world.Execute("sd;sd;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	  if string.find(l,"小路") then
	       world.Execute("sd;kill yuan bing")
		   self:die()
		 self:combat()
	     return

	  end
	  if string.find(l,"后仓") then
		 world.Execute("s;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	   if string.find(l,"中仓") then
		 world.Execute("w;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	    if string.find(l,"右仓") then
		 world.Execute("e;e;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	  if string.find(l,"左仓") then
		 world.Execute("w;s;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	   if string.find(l,"前仓") then
	     self.kill_count=self.kill_count+1
		 if self.kill_count>5 then
		    world.Execute("n;n;nu;nu;d")
			     shutdown()

		local cisha_jobslist=world.GetVariable("cisha_jobslist") or ""
		local nocisha_jobslist=world.GetVariable("nocisha_jobslist")
		if cisha_jobslist~="" then
			   world.SetVariable("jobslist",nocisha_jobslist)
			   world.AddTimer("huoshao_reset", 0, 15, 0, "SetVariable('jobslist','"..cisha_jobslist.."')", timer_flag.Enabled +timer_flag.OneShot+timer_flag.Replace, "")
	           world.SetTimerOption ("huoshao_reset", "send_to", 12)
		end
		    self:jobDone()
		    return
		 end
		 world.Execute("n;n;kill yuan bing")
		 self:die()
		 self:combat()

	     return
	  end
	  if string.find(l,"设定环境变量：action") then
	     self:huoshao()
	     return
	  end
	   if string.find(l,"玄武门") then
	     self:get_reward()
	     return
	  end
   end)
end

function cisha:get_reward()
   self:reward()
   local ts={
	           task_name="报效国家",
	           task_stepname="回到鲁长老",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
   w.walkover=function()

	   local _R=Room.new()
	   _R.CatchEnd=function()
		  if _R.RoomName=="土地庙"then
		       shutdown()

		local cisha_jobslist=world.GetVariable("cisha_jobslist") or ""
		local nocisha_jobslist=world.GetVariable("nocisha_jobslist")
		if cisha_jobslist~="" then
			   world.SetVariable("jobslist",nocisha_jobslist)
			   world.AddTimer("huoshao_reset", 0, 15, 0, "SetVariable('jobslist','"..cisha_jobslist.."')", timer_flag.Enabled +timer_flag.OneShot+timer_flag.Replace, "")
	           world.SetTimerOption ("huoshao_reset", "send_to", 12)
		end
			self:jobDone()
		  else
		    self:get_reward()
		  end
		end
		_R:CatchStart()

   end
   w:go(1000)
end

function cisha:NextPoint()
  if self.zhongjun==false then
  local ts={
	           task_name="报效国家",
	           task_stepname="刺杀侍卫",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   world.Send("n")
   wait.make(function()
   --这个方向没有出路。
      local l,w=wait.regexp("^(> |)中军大帐 -.*$|^(> |)中军 -.*$|^(> |)中军辕门 -.*$|^(> |)这个方向没有出路。$",5)
	  if l==nil then
        self:NextPoint()
	    return
	  end

	  if string.find(l,"中军大帐") then
	     self.npc_count=1
	     self.zhongjun=true
		  world.Send("kill shiwei")
		   world.Send("kill shiwei 2")
		   self:die()
	     self:kill_shiwei()
	    return
	  end
	  if string.find(l,"这个方向没有出路") then
	      shutdown()
	      self:jobDone()
	     return
	  end
	   if string.find(l,"中军") or string.find(l,"中军辕门") then
	     self.zhongjun=false
		  world.Send("kill shiwei")
		  self:die()
		 self:kill_shiwei()
	     return
	  end
   end)
   else
   local ts={
	           task_name="报效国家",
	           task_stepname="刺杀元帅",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    print("刺杀元帅")
	world.Send("n")
	self:reward()
	world.Send("kill zhan")
    self:combat()
   wait.make(function()
      local l,w=wait.regexp("^(> |)青石大道 -*$|^(> |)你对着粘而帖喝道：「.*」$|^(> |)这里没有这个人。$",5) --看起来粘而帖想杀死你！
	  if l==nil then
        self:NextPoint()
	    return
	  end

	  if string.find(l,"青石大道") or string.find(l,"这里没有这个人") then
	    shutdown()
	    self:jobDone()
	    return
	  end
	   if string.find(l,"粘而帖") then

	     return
	  end
   end)


  end
end

function cisha:baicaodan()

	local w
	w=walk.new()
	w.walkover=function()
	   world.Send("ask chen about 百草丹")
	   local b=busy.new()
	   b.interval=0.3
		b.Next=function()
           self:xiangyang()
		end
		b:check()
	end
     w:go(1002)
end

function cisha:buy_fire()
    local sp=special_item.new()
       sp.cooldown=function()
           self:huoshao()
       end
       local equip={}
	   equip=Split("<获取>火折","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end



function cisha:huoshao()
	   local ts={
	           task_name="报效国家",
	           task_stepname="火烧粮草",
	           task_step=2,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w
	w=walk.new()
	w.walkover=function()

	   --你气喘嘘嘘，感到无法爬上去，摔了下来！
	   self.NextPoint=function()
	      world.Send("dian gancao")
	      self:huoshao_NextPoint()
	   end
	   world.Execute("pa up;sd;sd;kill yuan bing")
	   self:die()
	   self:combat()

	end
     w:go(1348)

end

function cisha:recover()
    -- self:begin_transaction(function() self:recover() end)  --断点
	world.Send("yun recover")
	world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()


		if h.jingxue_percent<100 then
		    print("打通经脉")
			world.Send("fu bai caodan")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
			rc.halt=function()
			   world.Send("sleep")
			   local f=function()
			      rc:heal(false,true)
			   end
			   f_wait(f,2)
			end
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 and h.qi_percent>=80 and h.neili>=h.max_neili*0.9 then --受伤了
		    print("打通经脉")
            local rc=heal.new()
			rc.halt=function()
			   world.Send("sleep")
			   local f=function()
			      rc:heal(true,false)
			   end
			   f_wait(f,2)
			end
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal(true,false)
		elseif h.neili<h.max_neili*self.neili_upper then
		    local x
			x=xiulian.new()
			x.min_amount=100
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
			   if h.neili>=h.max_neili*self.neili_upper then
				  self:shield()
				  self:NextPoint()
				  --self:NextPoint()
			   else
	             print("继续修炼")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			self:shield()
		    self:NextPoint()
		end
	end
	h:check()
end

function cisha:jobDone()

end

function cisha:combat()

end

function cisha:fail(id)
end

function cisha:reward()
  wait.make(function()
    local l,w=wait.regexp("^(> |)好，任务完成了，你得到了.*。",10)
	if l==nil then
		self:reward()
	  return
	end
	if string.find(l,"好，任务完成了") then
	local ts={
	           task_name="报效国家",
	           task_stepname="奖励",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  local b=busy.new()
	  b.Next=function()
	    shutdown()

		local cisha_jobslist=world.GetVariable("cisha_jobslist") or ""
		local nocisha_jobslist=world.GetVariable("nocisha_jobslist")
		if cisha_jobslist~="" then
			   world.SetVariable("jobslist",nocisha_jobslist)
			   world.AddTimer("huoshao_reset", 0, 15, 0, "SetVariable('jobslist','"..cisha_jobslist.."')", timer_flag.Enabled +timer_flag.OneShot+timer_flag.Replace, "")
	           world.SetTimerOption ("huoshao_reset", "send_to", 12)
		end


	    self:jobDone()
	  end
	  b:check()
	   return
	end
  end)
end
--[[
你向鲁有脚打听有关『报效国家』的消息。
鲁有脚说道：「蒙古大汗蒙哥令大将粘而帖率精兵数十万，兵分两路，企图犯我襄阳。」
鲁有脚说道：「为今之计，只有寻机刺杀蒙古大将，才能迫使蒙古大军撤围襄阳。」
鲁有脚说道：「我丐帮弟子易大彪已经潜入蒙古军中，你可去襄阳北门等他。」
鲁有脚说道：「由他带你混进蒙古大营，伺机刺杀蒙古大汗。」

198

> 易大彪走了过来对你说道：请随我来。

易大彪带着你混过了蒙古大军的几道岗哨，来到中军营前。
易大彪对你悄声说到：我非中军士兵，无法入内，以后就看你的了。说完转身走开了。
中军侍卫说道：「大胆！！！」
看起来中军侍卫想杀死你！
is_dangerous_man: 中军侍卫
不在危险名单中: 中军侍卫
fpk中军侍卫
set wimpy 100
【你现在正处于丐帮】

【你现在正处于丐帮】


                          中军大帐
                             ｜
                            中军
中军大帐 -
    这是蒙古大军的中军大帐，远处隐隐传来号角和战马的嘶鸣之声。这里灯
火通明，几明虎背熊腰的大汉伺立在下首。
    这里唯一的出口是 south。
  蒙古 中军元帅 粘而帖(Zhan ertie)
  二具中军侍卫的尸体(Corpse)

【你现在正处于丐帮】
                            中军
                             ｜
                            中军
                             ｜
                          中军辕门
中军 -
    这是蒙古大军的中军，远处隐隐传来号角和战马的嘶鸣之声。不少士兵在
周围走来走去，看来战争一触即发。
    这里明显的出口是 north 和 south。
  中军侍卫的尸体(Corpse)



好，任务完成了，你得到了一千五百零四点实战经验，四百二十二点潜能和九百六十三点正神。

你趁着混乱冲出了元军大营。
【你现在正处于襄阳城】

【你现在正处于丐帮】
                            中军
                             ｜
                          中军辕门


中军辕门 -
    这是蒙古大军的中军辕门，远处隐隐传来号角和战马的嘶鸣之声。不少士
兵在周围走来走去，看来战争一触即发。
    这里唯一的出口是 north。
  中军侍卫的尸体(Corpse)]]

function cisha:shield()

end

function cisha:die()
--中军侍卫「啪」的一声倒在地上，挣扎着抽动了几下就死了。
  wait.make(function()
    local l,w=wait.regexp("^(> |)中军侍卫「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$|^(> |)元兵「啪」的一声倒在地上，挣扎着抽动了几下就死了。$",10)
	if l==nil then
	  self:die()
	  return
	end
	if string.find(l,"这里没有这个人") then
	     shutdown()
		  local b=busy.new()
		  b.Next=function()
		    self:recover()
		  end
		  b:check()
	   return
	end
	if string.find(l,"元兵") then
	     shutdown()
		  local b=busy.new()
		  b.Next=function()
		    world.Send("dian gancao")
		    self:recover()
		  end
		  b:check()
	   return
	end
	if string.find(l,"挣扎着抽动了几下就死了") then
	   if self.zhongjun==true and self.npc_count==1 then
	      world.Send("kill shiwei")
	      self.npc_count=2
		  self:die()
		else
		  shutdown()
		  local b=busy.new()
		  b.Next=function()
		    self:recover()
		  end
		  b:check()
	   end
	   return
	end
  end)
end

function cisha:kill_shiwei()

  self:combat()
end


function cisha:enter()
--易大彪走了过来对你说道：请随我来。
   wait.make(function()
      local l,w=wait.regexp("^(> |)易大彪走了过来对你说道：请随我来。$",15)
	  if l==nil then
         self:enter()
		 return
	  end

	  if string.find(l,"请随我来") then
        print("开始刺杀")
		shutdown()
		 world.Send("kill shiwei")
		 self:before_kill()
		 self:die()
	     self:kill_shiwei()
	     return
	  end
   end)
end

--^(> |)中军大帐 -.*$|^(> |)中军 -.*$|^(> |)中军辕门 -.*$|^(> |)这个方向没有出路。

function cisha:xiangyang()
   local ts={
	           task_name="报效国家",
	           task_stepname="前往襄阳",
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
      self:enter()
      world.Send("look")
      world.Send("set action 玄武门")

	 wait.make(function()
        local l,w=wait.regexp("^(> |)玄武门 -.*$|^(> |)设定环境变量：action = \\\"玄武门\\\"$|^(> |)中军辕门 -.*$",3)
	    if l==nil then
         self:xiangyang()
		 return
	    end
        if string.find(l,"中军辕门") then
		   shutdown()
		    world.Send("kill shiwei")
		   self:before_kill()
		   self:die()
	       self:kill_shiwei()
		   return
		end
	    if string.find(l,"设定环境变量：action") then
	     self:xiangyang()
	     return
	    end
	    if string.find(l,"玄武门") then

	      return
	    end
	 end)
   end

   w:go(198)
end

function cisha:select_job()
   wait.make(function()
      local l,w=wait.regexp("^(> |)鲁有脚说道：「蒙古大汗暂时没找到踪迹，等会再来吧。」$|^(> |)鲁有脚说道：「由他带你混进蒙古大营，伺机刺杀蒙古大汗。」$|^(> |)鲁有脚说道：「你不是已经接过任务了吗？」$|^(> |)鲁有脚说道：「您上次任务辛苦了，还是先休息一下再说吧。」$|^(> |)鲁有脚说道：「我这里现在没有什么任务可以给你。」$|^(> |)鲁有脚说道：「你从该处爬上去，伺机烧掉蒙古粮仓，以解我襄阳之围。」$",5)
	  if l==nil then
        self:ask_job()
	    return
	  end
	  if string.find(l,"刺杀蒙古大汗")  then
	    local b=busy.new()
		b.Next=function()
	     self:baicaodan()
		end
		b:check()

	     return
	  end
	  if string.find(l,"伺机烧掉蒙古粮仓") then
	      local b=busy.new()
		b.Next=function()
	     self:buy_fire()
		end
		b:check()

		 return
	  end
	  if string.find(l,"你不是已经接过任务了吗") then
		sj.World_Init=function()
		--重新连接
          Weapon_Check(process.cisha)
        end
	     local b=busy.new()
		 b.Next=function()
			relogin(5)
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"蒙古大汗暂时没找到踪迹") or string.find(l,"上次任务辛苦了") or string.find(l,"我这里现在没有什么任务可以给你") then
        self.fail(101)
	    return
	  end

   end)
end

function cisha:ask_job()
   local w=walk.new()
   w.walkover=function()
      world.Send("ask lu about 报效国家")
	  self:select_job()
	  --鲁有脚说道：「蒙古大汗暂时没找到踪迹，等会再来吧。」
   end
   w:go(1000)
end

function cisha:full()
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
			rc.saferoom=1000
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
		         w:go(1000)
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

function cisha:before_kill()

end
--
function cisha:Status_Check()
  	local ts={
	           task_name="报效国家",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --初始化

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
