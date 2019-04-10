
--[[2:                       【嵩山任务介绍】
 3: ──────────────────────────────
 4:
 5: 　　嵩山位于洛阳东南登封县境内，是五岳中的中岳，分太室、少室
 6: 二山，山势挺拔，层峦叠嶂，有很多名胜古迹。五岳剑派共由江湖中
 7: 的五大门派组成，包括华山派，恒山派，嵩山派，衡山派及泰山派。
 8: 嵩山派便是立于嵩山之巅，其势力之庞大，隐然可与少林武当等武林
 9: 泰斗分庭抗礼。其门派掌门左冷禅一生致力的目标就是建立嵩山一派
10: 的江湖地位和统治，千方百计招纳江湖人士为他效力。
11:
12: ──────────────────────────────
13:                         【任务要求】
14: ──────────────────────────────
15:
16: 经验值大于50k，无正神。
17:
18: ──────────────────────────────
19:                         【任务过程】
20: ──────────────────────────────
21:
22:     到嵩山封禅台向左冷禅请求任务ask zuo about job，随机性的
23: ，他会要你去杀或是请一个人，先到到该npc所在地，
== 还剩 19 行 == (ENTER 继续下一页，q 离开，b 前一页)24:     请人：qing xxx，该npc会说一些话，意思是要跟你过招，然后
25: 就自动过招，类似于 fight，如果他输了，他会决定跟随你一起行动
26: ，然后你带他回到左冷禅处即可，就算完成一次任务。
27:     杀人：找到NPC然后 kill xxx就行了，杀了之后 get corpse
28: (or qie corpse;get head)回到左冷禅处 give zuo corpse(head)
29: ，就算完成一次任务。
30:     如果不能完成，需要放弃任务：ask zuo about 放弃，才能再领
31: 新的任务。
32:
33: ──────────────────────────────
34:                         【经验之谈】
35: ──────────────────────────────
36:
37:     一般来说，请人比杀人要困难一些，因为耗费比较大的精力和时
38: 间，而且请人的时候切记不要用毒，否则毒处敌意或者毒死，都不会
39: 有好果子给你的吃的。当然，请人的奖励有时候也比杀人要相应高一
40: 些。]]
songshan={
  new=function()
     local ss={}
	 setmetatable(ss,songshan)
	 return ss
   end,
   ss_co=nil,
   npc="",
   id="",
   target_roomno="",
   get_reward_count=0,
   neili_upper=1.8,
   fight=false,
   qing_count=0,
   jobtype="",
   g_blacklist="",
}
songshan.__index=songshan

function songshan:prepare()

end

function songshan:catch_place()

--你向左冷禅打听有关『job』的消息。
     wait.make(function()

	 local l,w=wait.regexp("^(> |)左冷禅说道：「对了，(.*)和我交情不错，如得他相助，五岳并派之事简直易如反掌。」$|^(> |)左冷禅说道：「你听好了，有弟子回报(.*)这人对我五岳并派之举深表不满，那么……」$|^(> |)设定环境变量：action \\= \\\"ask\\\"|^(> |)左冷禅说道：「嗯，我现在正在思考并派大计，你别打扰。」$|^(> |)左冷禅说道：「嗯，我现在忙，你别打扰。」$|^(> |)左冷禅说道：「不是让你去(.*)请(.*)了吗，怎么还在这里？」$|^(> |)左冷禅说道：「不是让你去(.*)杀(.*)了吗，怎么还在这里？」",5)
	 if l==nil then
	   print("超时")
	   self:ask_job()
	   return
	 end

	 if string.find(l,"和我交情不错，如得他相助，五岳并派之事简直易如反掌") then
	    self.jobtype="请人"
		 -- print("fight")
		 self.fight=true
	    --print("测试1",w[2])
		local exps=tonumber(world.GetVariable("exps"))
		--内置的
	    if self:blacklist(w[2],exps)==true then
	      self:giveup()
	      return
	    end
		if self.g_blacklist~="" then
	     local blacklist=Split(self.g_blacklist,"|")
	      for _,b in ipairs(blacklist) do
	        --print("b",b)
		   if string.find(w[2],b) then
		     print("放弃")
		     self:giveup()
		     return
		   end
	      end
	    end
        self:qing(w[2])
	   return
	 end

	 if string.find(l,"这人对我五岳并派之举深表不满") then
	  self.jobtype="刺杀"
	  local exps=tonumber(world.GetVariable("exps"))
	  if self:blacklist(w[4],exps)==true then
	      self:giveup()
	      return
	  end
	  if self.g_blacklist~="" then
	     local blacklist=Split(self.g_blacklist,"|")
	      for _,b in ipairs(blacklist) do
	        --print("b",b)
		   if string.find(w[2],b) then
		     print("放弃")
		     self:giveup()
		     return
		   end
	      end
	  end
		self:shashou(w[4])
	   return
	 end
	 if string.find(l,"请") then
	    local place= w[9]
		 id=w[10]
		local ts={
	           task_name="嵩山",
	           task_stepname="请人",
	           task_step=3,
	           task_maxsteps=4,
	           task_location=w[9],
	           task_description="请人"..id,
	}
	   local st=status_win.new()
	   st:init(nil,nil,ts)
	   st:task_draw_win()
	   self.qing_count=0
	  print("qing:",id)
	    CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."嵩山任务:位置"..place.." 请人:"..id, "yellow", "black") -- yellow on white
	  if self:is_invite(id)==false then
		 self:giveup()
         return
	  end
	  self.job_select=self.qing_NPC
	  self:appear(id,place)
	    return
	 end

	 if string.find(l,"杀") then
	  self.jobtype="刺杀"
	    local place=w[12]
		id=w[13]
		local ts={
	           task_name="嵩山",
	           task_stepname="杀人",
	           task_step=3,
	           task_maxsteps=4,
	           task_location=place,
	           task_description="刺杀"..id,
	}
	   local st=status_win.new()
	   st:init(nil,nil,ts)
	   st:task_draw_win()
        CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."嵩山任务:位置"..place.." 刺杀:"..id, "yellow", "black") -- yellow on white

	    print("shashou:",id)
		self:prepare()
		--self.job_select=self.kill_NPC
		self.job_select=self.hit
		self:appear(id,place)
		return

	 end
	 if string.find(l,"设定环境变量：action") then
	   wait.time(2)
	   self:ask_job()
	   return
	 end
	  if string.find(l,"嗯，我现在正在思考并派大计") then
        self.fail(101)
	   return
	 end
	 if string.find(l,"嗯，我现在忙，你别打扰") then
	    self.fail(102)
	    return
	 end
	 if string.find(l,"怎么还在这里") then
	    self:giveup()
	    return
	 end
	end)
end

function songshan:auto_pfm(flag)
end

function songshan:ask_job()
   local w
   w=walk.new()
   w.walkover=function()
     world.Send("ask zuo about job")
	 world.Send("set action ask")
	 wait.make(function()

	 local l,w=wait.regexp("^(> |)你向左冷禅打听有关『job』的消息。",5)
	 if l==nil then
	   print("超时")
	   self:ask_job()
	   return
	 end

	 if string.find(l,"你向左冷禅打听有关") then
	   self:catch_place()
	   --BigData:catchData(311,"封禅台")
	   return
	 end

   end)
  end
  w:go(311)
end

function songshan:is_invite(id)
   if id=="凌震天" or id=="黄令天" or id=="出尘子" or id=="薛慕华"  or id=="阿紫" then
      return false
   end
   return true
end

function songshan:qing(id)
   print(id)
   wait.make(function()
    local l,w=wait.regexp("^(> |)左冷禅说道：「你就代表我去(.*)邀请他，务必在.*之前赶回来。」$",3)
	if string.find(l,"你就代表我去") then
	   	local ts={
	           task_name="嵩山",
	           task_stepname="请人",
	           task_step=3,
	           task_maxsteps=4,
	           task_location=w[2],
	           task_description="请人"..id,
	}
	   local st=status_win.new()
	   st:init(nil,nil,ts)
	   st:task_draw_win()
	   self.qing_count=0
	  print("qing:",w[2])
	  if self:is_invite(id)==false then
		 self:giveup()
         return
	  end
	    CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."嵩山任务:位置"..w[2].." 请人:"..id, "yellow", "black") -- yellow on white
	  self.job_select=self.qing_NPC
	  self:prepare()
	  self:appear(id,w[2])
	  return
	end
	 wait.time(3)
   end)

end

function songshan:combat_end()

end

function songshan:combat()

end
--

function songshan:dazuo()

   world.Send("set 积蓄")
	local h
	h=hp.new()
	h.checkover=function()
	  if h.neili<math.floor(h.max_neili*self.neili_upper) then
		   --print(h.neili,h.max_neili*self.neili_upper," +++ ",self.neili_upper)
		    local x
			x=xiulian.new()
			x.halt=false
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
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
		         w:go(310)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			      self:qing_again()
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
			   self:qing_again()
			end
			b:check()
		end
	end
	h:check()
end

function songshan:yun_neigong_again()
   wait.make(function()
	  world.Send("yun refresh")
	  world.Send("yun regenerate")
      local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你现在精力充沛。$|^(> |)你长长地舒了一口气。$",5)
	   if l==nil then
	      self:yun_neigong_again()
	      return
	   end
       if string.find(l,"你的内力不够") then
	     print("内力不够!")
	     --self:giveup()
		 self:dazuo()
	     return
	  end
      if string.find(l,"你现在精力充沛")  or string.find(l,"你长长地舒了一口气") then
		 local f=function()
		   self:qing_again()
		 end
		 f_wait(f,0.8)
		return
      end
	  wait.time(5)
	end)
end

function songshan:qing_again()
   print("qing_again")
   print("npc:",self.npc," id:",self.id)
   world.Send("yun liaodu "..self.id)
   wait.make(function()
      world.Send("qing "..self.id)
	  local l,w=wait.regexp("^(> |)你精神不振，先休息一下吧！$|^(> |)太可惜了，你要邀请的人已经走了。|^(> |)"..self.npc.."决定跟随你一起行动。$|^(> |)这里没有这个人耶。$|^(> |)"..self.npc.."已经接受了邀请，你不用再费劲啦。$|^(> |)"..self.npc.."脸色苍白，只看了你一眼。看来是身体不适。$|^(> |)你要先等他醒过来再说。$",5)
      if l==nil then
         self:qing_again()
		 return
	  end
	  if string.find(l,"你精神不振，先休息一下吧") then
	     self:yun_neigong_again()
		 return
	  end
	  if string.find(l,"太可惜了，你要邀请的人已经走了") or string.find(l,"这里没有这个人耶") then
	     self:giveup()
		 return
	  end
	  if string.find(l,"只看了你一眼。看来是身体不适") then
	     self.qing_count=self.qing_count+1
		 print(self.qing_count," 计数")
		 if self.qing_count>10 then
		    self:giveup()
		 else
		     self:qing_again()
		 end
	     return
	  end
	  if string.find(l,"你要先等他醒过来再说") then
	      world.Send("yun guiyuan "..self.id)
		  wait.time(2)
		  self:qing_again()
	      return
	  end
	  if string.find(l,"决定跟随你一起行动") or string.find(l,"你不用再费劲啦") then
	     print("success!!")
		 local b
		 b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		   local sp=special_item.new()
   	       sp.cooldown=function()
             self:reward()
           end
           sp:unwield_all()
		 end
		 b:check()
		 return
	  end
	 wait.time(5)
   end)

end

function songshan:fight_end(callback)

end

function songshan:win_lose(npc,id)
   wait.make(function()--仪琳向后一纵，说道：阁下武艺果然高明，这场算是在下输了！ 你双手一拱，笑着说道：承让！
   --秦绢向后退了几步，说道：这场比试算我输了，佩服，佩服！
   --你哈哈大笑，说道：承让了！
      local l,w=wait.regexp("^(> |)"..npc.."哈哈大笑，说道：承让了！$|^(> |)"..npc.."双手一拱，笑着说道：承让！$|^(> |)你向后退了几步，说道：这场比试算我输了，佩服，佩服！|^(> |)你向后一纵，说道：阁下武艺果然高明，这场算是在下输了！$|^(> |)你向后一纵，躬身做揖说道：阁下武艺不凡，果然高明！|^(> |)你脸色微变，说道：佩服，佩服！$|^(> |)你神志迷糊，脚下一个不稳，倒在地上昏了过去。$|^(> |)"..npc.."胜了这招，向后跃开三尺，笑道：承让！$|^(> |)你哈哈大笑，说道：承让了！$|^(> |)你双手一拱，笑着说道：承让！$|^(> |)"..npc.."向后退了几步，说道：这场比试算我输了，佩服，佩服！|^(> |)"..npc.."向后一纵，说道：阁下武艺果然高明，这场算是在下输了！$|^(> |)"..npc.."向后一纵，躬身做揖说道：阁下武艺不凡，果然高明！|^(> |)"..npc.."脸色微变，说道：佩服，佩服！$|^(> |)"..npc.."神志迷糊，脚下一个不稳，倒在地上昏了过去。$|^(> |)你胜了这招，向后跃开三尺，笑道：承让！$|^(> |)"..npc.."「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)你只觉得头昏脑胀，眼前一黑，接着什么也不知道了……$",5)

	  if l==nil then
	    self:win_lose(npc,id)
	    return
	  end
	  if string.find(l,"你哈哈大笑，说道：承让了") or string.find(l,npc.."向后退了几步，说道：这场比试算我输了，佩服，佩服") or string.find(l,"你双手一拱，笑着说道：承让") or string.find(l,npc.."向后一纵，说道：阁下武艺果然高明，这场算是在下输了") or string.find(l,npc.."向后一纵，躬身做揖说道：阁下武艺不凡，果然高明") or string.find(l,npc.."脸色微变，说道：佩服，佩服") or string.find(l,npc.."神志迷糊，脚下一个不稳，倒在地上昏了过去") or string.find(l,"你胜了这招，向后跃开三尺，笑道：承让") then
		print("赢了!!")
		print("战斗结束")
		shutdown()
		--world.Send("unset wimpy")
		self.qing_count=0
		local f=function()
		  --self:qing_again()
		   self:qing_NPC(npc,id)
		end
		self.fight_end(f)
	    return
	  end
	  if string.find(l,"挣扎着抽动了几下就死了") then
	     shutdown()
		 world.Send("unset wimpy")
		 local f=function()
		    self:giveup()
		 end
		 self.fight_end(f)
	     return
	  end
	  if string.find(l,"你只觉得头昏脑胀") or string.find(l,npc.."哈哈大笑，说道：承让了") or string.find(l,"你向后退了几步，说道：这场比试算我输了，佩服，佩服") or string.find(l,npc.."双手一拱，笑着说道：承让") or string.find(l,"你向后一纵，说道：阁下武艺果然高明，这场算是在下输了") or string.find(l,"你向后一纵，躬身做揖说道：阁下武艺不凡，果然高明") or string.find(l,"你脸色微变，说道：佩服，佩服") or string.find(l,"你神志迷糊，脚下一个不稳，倒在地上昏了过去") or string.find(l,npc.."胜了这招，向后跃开三尺，笑道：承让") then
	    print("输了!!")
		world.Send("yun recover")
		print("战斗结束")
		shutdown()
		world.Send("unset wimpy")
		local h
	    h=hp.new()
	    h.checkover=function()
		  local f=nil
          if h.qi_percent<=80 or h.neili<=h.max_neili then
		      f=function()
		        self:giveup()
			  end
		  else
			 self.qing_count=0
			 f=function()
		        self:qing_NPC(npc,id)
			 end
		   end
		  self.fight_end(f)
	    end
	    h:check()
	    return
	  end
	  wait.time(5)
   end)
end

function songshan:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("寻找出口")
     local dx=_R:get_all_exits(_R)
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil then
	    --获得随机方向
	     local n=table.getn(dx)
	     i=math.random(n)
	 elseif i>table.getn(dx) then
	     i=1
	 end
	 print("随机:",i)
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

function songshan:yun_neigong(npc,id)
   wait.make(function()
	  world.Send("yun refresh")
	  world.Send("yun regenerate")
      local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你现在精力充沛。$|^(> |)你长长地舒了一口气。$",5)
	   if l==nil then
	      self:yun_neigong(npc,id)
	      return
	   end
       if string.find(l,"你的内力不够") then
	     print("内力不够!")
	     self:giveup()
	     return
	  end
      if string.find(l,"你现在精力充沛")  or string.find(l,"你长长地舒了一口气") then
		 local f=function()
		   self:qing_NPC(npc,id)
		 end
		 f_wait(f,0.8)
		return
      end
	end)
end

function songshan:fight_reset()
end

function songshan:compare(npc,id)
    world.Send("compare "..id)
	wait.make(function()
	   local l,w=wait.regexp("^(> |)小心点，.*比你略胜一筹, 你的胜算不大。$",5)
	   if l==nil then
	      return
	   end
	   if string.find(l,"你的胜算不大") then
		  self:fight_reset()
	      return
	   end

	end)
end

function songshan:qing_NPC(npc,id) --具体实现
   --获得id
   --print("qing")
   --print("npc:",npc," id:",id)
   wait.make(function()--,5)
      world.Send("qing "..string.lower(id))
	  local l,w=wait.regexp("^(> |)这里没有这个人耶。$|^(> |)太可惜了，你要邀请的人已经走了。|^(> |)你精神不振，先休息一下吧！$|^(> |)"..npc.."扫了你一眼道：“.*既然派你来，想必有几分真才实学，就让.*来掂量掂量你吧！”|^(> |)"..npc.."决定跟随你一起行动。$|^(> |)这里没有这个人耶。$|^(> |).*已经接受了邀请，你不用再费劲啦。$|^(> |)"..npc.."脸色苍白，只看了你一眼。看来是身体不适。$",5)
      if l==nil then
         self:qing_NPC(npc,id)
		 return
	  end

	  if string.find(l,"你精神不振，先休息一下吧") then
		 self:yun_neigong(npc,id)
		 return
	  end
	  if string.find(l,"太可惜了，你要邀请的人已经走了") or string.find(l,"这里没有这个人耶") then
	     self:giveup()
	     return
	  end
      if string.find(l,"看来是身体不适") then
	     self.qing_count=self.qing_count+1
		 print(self.qing_count," 计数")
		 if self.qing_count>10 then
		    self:giveup()
		 else
		     self:qing_NPC(npc,id)
		 end
		 return
	  end
	  --茅十八扫了你一眼道：“小王八蛋，既然派你来，想必有几分真才实学，就让大爷我来掂量掂量你吧！”
	  if string.find(l,"来掂量掂量你吧") then
         self:compare(npc,id)
		 world.Send("follow "..id)
		 self:combat()
		 self:win_lose(npc,id)
		 return
	  end
	 if string.find(l,"决定跟随你一起行动") or string.find(l,"你不用再费劲啦") then
	     print("success!!")
		 local b
		 b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		   self:reward()
		 end
		 b:check()
		 return
	  end
   end)
   --你精神不振，先休息一下吧！
   --浪荡公子扫了你一眼道：“臭贼，左兄既然派你来，想必有几分真才实学，就让大爷我来掂量掂量你吧！”
   --浪荡公子向后一纵，躬身做揖说道：阁下武艺不凡，果然高明！
   --浪荡公子决定跟随你一起行动。
   --五毒教女弟子扫了你一眼道：“臭贼，左兄既然派你来，想必有几分真才实学，就让本姑娘来掂量掂量你吧！”
end

function songshan:fail(id)
end

function songshan:give_head()
  	local ts={
	           task_name="嵩山",
	           task_stepname="奖励",
	           task_step=4,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  songshan.ss_co=nil
  local w
  w=walk.new()
  w.walkover=function()
     world.Send("give zuo head")
	 world.Send("give zuo corpse")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)左冷禅给你讲解一些武学上的疑难，你若有所思地点着头。$|^(> |)你身上没有这样东西。$",5)
	   if l==nil then
	     self:give_head()
		 return
	   end
	   if string.find(l,"你若有所思地点着头") or string.find(l,"你身上没有这样东西") then
	      local rc=reward.new()
		  rc.finish=function()
		     CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."嵩山任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on white
 		  end
		  rc:get_reward()

         self:jobDone()
	     return
	   end
	 end)
  end
  w:go(311)
end

function songshan:qie_corpse(index)
	print("战斗结束")
	shutdown()
    world.Send("wield jian")
   if index==nil then
      --world.Send("get all from corpse")
	  --world.Send("get ling from corpse")
	  world.Send("get silver from corpse")
	  world.Send("get gold from corpse")
      world.Send("qie corpse")
	else
      world.Send("get silver from corpse "..index)
	  --world.Send("get ling from corpse "..index)
	  world.Send("get gold from corpse "..index)

	  world.Send("qie corpse ".. index)
   end

	--只听“咔”的一声，你将霍先生的首级斩了下来，提在手中。> 乱切别人杀的人干嘛啊？
    wait.make(function()
	  local l,w=wait.regexp("^(> |)只听“咔”的一声，你将"..self.npc.."的首级斩了下来，提在手中。$|^(> |)乱切别人杀的人干嘛啊？$|^(> |)那具尸体已经没有首级了。$|^(> |)你找不到 corpse 这样东西。$|^(> |)找不到这个东西。$|(> |)你手上这件兵器无锋无刃，如何能切下这尸体的头来？$|^(> |)你得用件锋利的器具才能切下这尸体的头来。$",5)
	  if l==nil then
	    self:qie_corpse(index)
		return
	  end
	  if string.find(l,"乱切别人杀的人干嘛啊") or string.find(l,"那具尸体已经没有首级了") then
       if index==nil then
	     index=2
	   else
	     index=index+1
	   end
       self:qie_corpse(index)
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
	  if string.find(l,"首级斩了下来，提在手中") then
	    print("回报")
		shutdown()
		local b
		b=busy.new()
		b.interval=0.5
		b.Next=function()
		  world.Send("unwield jian")
		  local sp=special_item.new()
   	       sp.cooldown=function()
             self:give_head()
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
		     world.Send("get corpse") --直接获取尸体
			 self:give_head()
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
	end)
end

function songshan:look_corpse(npc)
   print("look "..npc.." 尸体")
   wait.make(function()
      world.Send("look")
	  world.Send("set look 1")
     local l,w=wait.regexp("^(> |).*"..npc.."的尸体\\(Corpse\\)$|^(> |)设定环境变量：look \\= 1$",5)
	 if l==nil then
	    self:look_corpse()
	    return
	 end
	 if string.find(l,"的尸体") then
	    print(npc,"的尸体")
	    self:qie_corpse()
		return
	 end
	 if string.find(l,"设定环境变量：look") then
	    shutdown()
		self:giveup()
	    return
	 end
   end)
end

function songshan:npc_idle(npc,id)
  print("晕倒",npc,id)
  npc=Trim(npc)
  wait.make(function()
  local l,w=wait.regexp("^(> |)"..npc.."「啪」的一声倒在地上，挣扎着抽动了几下就死了.*|^(> |)你哈哈大笑，说道：承让了！$|^(> |)你双手一拱，笑着说道：承让！$|^(> |)"..npc.."向后退了几步，说道：这场比试算我输了，佩服，佩服！|^(> |)"..npc.."向后一纵，说道：阁下武艺果然高明，这场算是在下输了！$|^(> |)"..npc.."向后一纵，躬身做揖说道：阁下武艺不凡，果然高明！|^(> |)"..npc.."脸色微变，说道：佩服，佩服！$|^(> |)"..npc.."神志迷糊，脚下一个不稳，倒在地上昏了过去。$|^(> |)你胜了这招，向后跃开三尺，笑道：承让！$|^(> |)"..npc.."往(.*)的.*落荒而逃了。$",5)

    --吕文德神志迷糊，脚下一个不稳，倒在地上昏了过去。
	   if l==nil then
	      self:npc_idle(npc,id)
		  return
	   end
	   if string.find(l,"你哈哈大笑，说道：承让了") or string.find(l,"向后退了几步，说道：这场比试算我输了，佩服，佩服") or string.find(l,"你双手一拱，笑着说道：承让") or string.find(l,"向后一纵，说道：阁下武艺果然高明，这场算是在下输了") or string.find(l,"向后一纵，躬身做揖说道：阁下武艺不凡，果然高明") or string.find(l,"脸色微变，说道：佩服，佩服") or string.find(l,"你胜了这招，向后跃开三尺，笑道：承让") then
	    print("再次fight!")
  	    self:kill_NPC(npc,id)
	    return
	   end
	   if string.find(l,"落荒而逃") then
	       local dx=w[11]
		   print(dx,"落荒而逃!")
		   local escape=""
		   if dx=="东面" then
		       escape="east"
		   elseif dx=="西面" then
		      escape="west"
		   elseif dx=="北面" then
		      escape="north"
		   elseif dx=="南面" then
		      escape="south"
		   end
		   shutdown()
		   print(escape,"追击")
		   local b=busy.new()
		   b.Next=function()
		      world.Send(escape)
		      print("再次fight!")
  	          self:kill_NPC(npc,id)
		   end
		   b:check()
	      return
	   end
	   if string.find(l,"挣扎着抽动了几下就死了") then
	     print("直接挂掉")
	     self:qie_corpse()
	     return
	   end
	   if string.find(l,"神志迷糊，脚下一个不稳，倒在地上昏了过去") then
	     print("晕倒")
	     self:hit(npc,id)
		 return
	   end
	end)
end

function songshan:npc_die(npc,id)
    print("npc die",npc)
    wait.make(function()
	  local l,w=wait.regexp("^(> |)"..npc.."「啪」的一声倒在地上，挣扎着抽动了几下就死了.*$|^(> |)"..npc.."往(.*)的.*落荒而逃了。$",10)
	   if l==nil then
	      self:npc_die(npc,id)
		  return
	   end
	  if string.find(l,"落荒而逃") then
	       local dx=w[11]
		   print(dx,"落荒而逃!")
		   local escape=""
		   if dx=="东面" then
		       escape="east"
		   elseif dx=="西面" then
		      escape="west"
		   elseif dx=="北面" then
		      escape="north"
		   elseif dx=="南面" then
		      escape="south"
		   end
		   print(escape,"追击")
		   shutdown()
		   local b=busy.new()
		   b.Next=function()
		      world.Send(escape)
		      print("再次fight!")
  	          self:kill_NPC(npc,id)
		   end
		   b:check()
	      return
	   end
	   if string.find(l,"挣扎着抽动了几下就死了") then
	     shutdown()
	     self:qie_corpse()
	     return
	   end
	end)
end

function songshan:hit(npc,id)
  local b=busy.new()
  b.Next=function()
   wait.make(function()
       world.Send("follow "..id)
       world.Send("kill "..id)
	   --self:auto_pfm()
	   self:combat()
	   self:npc_die(npc,id)
	   local l,w=wait.regexp("^(> |)这里没有这个人。$",10)
	   if l==nil then
         self:hit(npc,id)
	     return
	   end
	   --if string.find(l,"看起来"..npc.."想杀死你") or string.find(l,"加油！加油！") then
	   --self:npc_die(npc,id)
	   --   return
	   --end
	   if string.find(l,"这里没有这个人") then
	     shutdown()
	     self:look_corpse(npc) --1 已经死了
	     return
	   end
   end)
  end
  b:jifa()
end

function songshan:check_auto_kill_npc(npc,id)
   wait.make(function()
     world.Send("look")
	 world.Send("set look 1")
	 --world.Send("unset wimpy")
	 --老虎 熊 豹 蛇 野猪 巨蟒
	 local regexp
	--[[ if self.auto_kill_npc~="" and self.auto_kill_npc~=nil then
	    regexp=".*"..self.auto_kill_npc.."\\(.*\\) <战斗中>$|.*(熊|老虎|蛇|豹子|野猪|巨蟒|野狼|灰狼|马贼|值勤兵|大狼狗|帮众|毒蟒|教众)\\(.*\\).*|^(> |)设定环境变量：look \\= 1$"
	else]]
 	    regexp=".*(白熊|老虎|蛇|豹子|野猪|野狼|灰狼|巨蟒|马贼|值勤兵|大狼狗|帮众|毒蟒|教众|鳄鱼)\\(.*\\).*|^(> |)设定环境变量：look \\= 1$"
	--end
	 local l,w=wait.regexp(regexp,10)
	 if l==nil then
	    self:check_auto_kill_npc(npc,id)
	    return
	 end
	 if string.find(l,"战斗中") then
	     local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
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
	 if string.find(l,"白熊") then
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
	 if string.find(l,"鳄鱼") then
	    world.Send("kill e yu")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"巨蟒") or string.find(l,"毒蟒")  then
		 world.Send("kill mang")
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
	   self:kill_NPC(npc,id)
	   return
	 end
   end)
end

function songshan:kill_NPC(npc,id) --具体实现

--[[
你对着吕文德嘿嘿一笑：来来来！就让大爷我来领教领教壮士的高招吧！
钱青健说道：「既然壮士赐教，在下只好奉陪，我们点到为止。」
吕文德说道：「既然壮士赐教，在下只好奉陪，我们点到为止。」
> 你缓缓地移动着，想要找出吕文德的破绽。
吕文德注视着你的行动，企图寻找机会出手。

你对着吴光胜嘿嘿一笑：来来来！就让大爷我来领教领教壮士的高招吧！
亲兵队长「啪」的一声倒在地上，挣扎着抽动了几下就死了。
亲兵队长说道：「既然姑娘赐教，在下只好奉陪，我们点到为止。」
吴光胜说道：「在下怎么可能是壮士的对手？您就别开玩笑了！」
]]
   print("战斗")
   print("npc:",npc," id:",id)
   wait.make(function()
       world.Send("follow "..id)
       world.Send("fight "..id)
	   --self:auto_pfm()

	   local l,w=wait.regexp("^(> |)看起来"..npc.."并不想跟你较量。$|^(> |)"..npc.."说道：「既然.*赐教，.*只好奉陪，我们点到为止。」$|^(> |)加油！加油！加油！$|^(> |)"..npc.."已经无法战斗了。$|^.*这里没有 "..id.."。$|^(> |)这里禁止战斗。$",5)
	   if l==nil then
         self:kill_NPC(npc,id)
	     return
	   end
	   if string.find(l,"并不想跟你较量") or string.find(l,"已经无法战斗了") then
	      self:hit(npc,id)
	      return
	   end
	   if string.find(l,"我们点到为止")  or string.find(l,"加油！加油！加油") then
	     --print("kill npc fight hit")
		 self:npc_idle(npc,id)
	     self:combat()

	     return
	   end
	   if string.find(l,"这里禁止战斗") then
	      self:giveup()
	      return
	   end
	   if string.find(l,"这里没有") then
	      self:look_corpse(npc)
	      return
	   end

   end)
end

function songshan:job_select(npc,id) --回调函数
end

function songshan:check_menpai(id,npc)
  local exps=world.GetVariable("exps") or 0
  if tonumber(exps)>2000000 then
     world.Send("look "..id)
  end
   world.Send("set action 门派检查")
   wait.make(function()
      local l,w=wait.regexp("^(> |)此人看上去师承(.*)，擅长使用(.*)伤敌！$|^(> |)设定环境变量：action = \"门派检查\"$",5)
   if string.find(l,"此人看上去师承") then
      local party=w[2]
	  local skill=w[3]
	  if self.g_blacklist~="" then
	   local blacklist=Split(self.g_blacklist,"|")
	   for _,b in ipairs(blacklist) do
	     --print("b",b)
		if skill==b or party==b then
		   print("放弃")
		   self:giveup()
		   return
		end
	   end
	  end
	  self:auto_pfm()
	  self:job_select(npc,id)
      return
   end
   if string.find(l,"设定环境变量：action") then
       self:auto_pfm()
       self:job_select(npc,id)
       return
   end
   end)
end

function songshan:get_id(npc)
	wait.make(function()
		 world.Send("look")
	    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$",5)
		if l==nil then
		   self:get_id(npc)
		   return
		end
		if string.find(l,npc) then
		   --加入检查门派 放弃 xx 派
		   self.npc=npc
		   local id=string.lower(w[2])
		   self.id=id
		   self:check_menpai(id,npc)
		   return
		end
		wait.time(5)
	end)
end
--没有npc时候 确认下是否到达准确地点
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

function songshan:checkPlace(npc,roomno,here)
      if is_contain(roomno,here) then
  	     print("等待1s,下一个房间")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
		 end
		 f_wait(f,1)
	   else
	   --没有走到指定房间
	    print("没有走到指定房间")
	      w=walk.new()

		  local al
		  al=alias.new()
		  al.do_jobing=true
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

function songshan:checkNPC(npc,roomno)
    --print("checkNPC",npc)
    wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)设定环境变量：look \\= 1$",15)
	  if l==nil then
	     self:checkNPC(npc,roomno)
		 return
	  end
	  if string.find(l,"设定环境变量：look") then
	      local f=function(r)
		     self:checkPlace(npc,roomno,r)
		  end
		  WhereAmI(f)
	     return
	  end
	  if string.find(l,npc) then
         --self:get_id(npc)
		  self.npc=npc
		   local id=string.lower(w[2])
		   self.id=id
		   self:check_menpai(id,npc)
	     return
	  end
	  wait.time(15)
   end)
end

function songshan:NextPoint()
   print("进程恢复")
   coroutine.resume(songshan.ss_co)
end

function songshan:appear(npc,location)
   if zone_entry(location)==true then
      --world.AppendToNotepad (WorldName().."_嵩山任务:",os.date()..": 无法进入"..location.."直接放弃\r\n")
      self:giveup()
      return
   end

  local n,rooms=Where(location)
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   world.Send("yun recover")
	   self:shield()
	   print("抓取")
	   songshan.ss_co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.do_jobing=true
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()

		    self:checkNPC(npc,r)
		  end
		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
		    self:giveup()
		  end
		  self.target_roomno=r
		  w:go(r)
		  coroutine.yield()
	    end
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

function songshan:blacklist(name,exps)
 -- 忽必烈|赵敏|吕文德|黯然子|摘星子|贾布
 --史镖头|王夫人|赵敏|出尘子|吕文德|侯君集|忽必烈|摘星子|飘然子|天狼子|完颜萍
  if string.find(name,"柯镇恶") or string.find(name,"韩小莹") or string.find(name,"丘处机") or string.find(name,"护院弟子") or string.find(name,"丁春秋") or string.find(name,"薛慕华") or string.find(name,"吕文德") or string.find(name,"侯君集") or string.find(name,"赵敏") or string.find(name,"忽必烈") or string.find(name,"摘星子") or string.find(name,"飘然子") or string.find(name,"葛光佩") or string.find(name,"干光豪") or string.find(name,"天狼子") then

     return true
  end
  if (string.find(name,"蒙古卫士") or string.find(name,"完颜萍")) and exps<990000 then

     return true
  end
  return false
end

function songshan:shashou(id)
   print(id)
   wait.make(function()
    local l,w=wait.regexp("^(> |)左冷禅说道：「嘿嘿，他在(.*)一带，你去将他杀了，务必.*之前带着他的尸体赶回来。.*$",3)
	 if string.find(l,"你去将他杀了") then
	   	local ts={
	           task_name="嵩山",
	           task_stepname="杀人",
	           task_step=3,
	           task_maxsteps=4,
	           task_location=w[2],
	           task_description="刺杀"..id,
	}
	   local st=status_win.new()
	   st:init(nil,nil,ts)
	   st:task_draw_win()

       CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."嵩山任务:位置"..w[2].." 刺杀:"..id, "yellow", "black") -- yellow on white
	    print("shashou:",w[2])
		--self.job_select=self.kill_NPC
		self.job_select=self.check_auto_kill_npc
		self:appear(id,w[2])
		return
	 end
    wait.time(3)
   end)
end

function songshan:giveup()
   songshan.ss_co=nil
   local w
   w=walk.new()
   w.walkover=function()
     wait.make(function()
	 world.Send("ask zuo about 放弃")
	 local l,w=wait.regexp("左冷禅说道：「既然你干不了也没关系，再去刻苦练功吧，以后再来为我们的并派大计出力！」$|^(> |)左冷禅说道：「你没有领任务，和我嚷嚷什么？」",5)
	 if l==nil then
	   print("超时")
	   self:giveup()
	   return
	 end
	 if string.find(l,"既然你干不了也没关系，再去刻苦练功吧") or string.find(l,"你没有领任务，和我嚷嚷什么") then
	    --BigData:catchData(311,"封禅台")
       wait.time(2)
	   local f=function()
	     self:Status_Check()
	   end
	   Weapon_Check(f)

	   return
	 end

   end)
  end
  w:go(311)
end

function songshan:reward()
  	local ts={
	           task_name="嵩山",
	           task_stepname="奖励",
	           task_step=4,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	songshan.ss_co=nil

  local w
  w=walk.new()
  w.walkover=function()
     wait.make(function()
	   local l,w=wait.regexp("^(> |)恭喜你！你成功的完成了嵩山任务！你被奖励了：$|^(> |)"..self.npc.."「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)你觉得脑中豁然开朗.*$",8)
	   if l==nil then
		   if self.get_reward_count>=8 then
		      self.get_reward_count=0
		      self:giveup()
			  return
		   end
		   world.Execute("southdown;northup")
	       self.get_reward_count=self.get_reward_count+1
	       self:reward()
	       return
	   end
	   if string.find(l,"挣扎着抽动了几下就死了") then
	      print("超过保险时间！")
	      self:giveup()
	      return
	   end
	   if string.find(l,"恭喜你") or string.find(l,"你觉得脑中豁然开朗") then

		 local rc=reward.new()
		  rc.finish=function()
		     CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."嵩山任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on white
 		  end
		  rc:exps()

		  -- BigData:catchData(311,"封禅台")
	      print("job 结束")
	      self:jobDone()
		  return
	   end
	   --wait.time(8)
	 end)
  end
  --self:get_reward()
  w:go(311)
end

-- 继续送信
function songshan:Status_Check()
	local ts={
	           task_name="嵩山",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
     --初始化
	 self.fight=false
	 local vip=world.GetVariable("vip") or "普通玩家"
	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<50 or h.drink<50 and vip~="荣誉终身贵宾" then
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

		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
			local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=310
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 and h.qi_percent>=80 then
			print("打通经脉")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			rc.liaoshang_fail=self.liaoshang_fail
			rc.saferoom=310
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
		elseif h.neili<h.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                self:Status_Check()
            end
			r:wash()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		   --print(h.neili,h.max_neili*self.neili_upper," +++ ",self.neili_upper)
		     if h.neili<=h.max_neili then
			  world.Send("fu chuanbei wan")
			end
		    local x
			x=xiulian.new()
			x.halt=false
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
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
		         w:go(310)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
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

function songshan:auto_wield_weapon(f,error_deal)
--你将凝晶雁翎箫握在手中。你「唰」的一声抽出一柄长剑握在手中。

   wait.make(function()
	 local l,w=wait.regexp("(.*)\\((.*)\\)$|^(> |)设定环境变量：look \\= 1$",5)
    if l==nil then
	   self:auto_wield_weapon(f,error_deal)
	   return
	end
	if string.find(l,")") then
	   print(w[1],w[2])
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
      elseif (string.find(item_id,"dagger") or string.find(item_id,"bishou")) and string.find(item_name,"匕首") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
	  end
	  self:auto_wield_weapon(f,error_deal)
	  return
	end
    if string.find(l,"设定环境变量：look") then
	   print(self.weapon_exits,"值")
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

function songshan:shield()
end
function songshan:jobDone()  --回调函数
end
