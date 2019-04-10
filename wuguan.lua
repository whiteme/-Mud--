
local function get_tools_trigger()
   world.AddTriggerEx ("get_tools", "^(> |)吴坎交给你一(把|柄|只)(.*)。$", "wuguan.Job(\"%3\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   world.SetTriggerOption ("get_tools", "group", "wuguan")
   world.EnableTrigger("get_tools",true)
end

local function get_tools()
  local b
  b=busy.new()
  b.interval=0.3
  b.Next=function()
     local w
     w=walk.new()
     w.walkover=function()
	 get_tools_trigger()
	 world.Send("ask wu about tools")
    end
    w:go(17)
  end
  b:check()
end

local function taskok_trigger()
   world.AddTriggerEx ("taskok", "^(> |).*管事说道：「干的不错，好了，你可以.*大师兄鲁坤.*覆命\\(task ok\\)了！」$", "wuguan.TaskOk()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   world.SetTriggerOption ("taskok", "group", "wuguan")
   world.EnableTrigger("taskok",true)
end

local function taskok()
   world.EnableTimer("repeat",false)
   world.EnableTrigger("taskok",false)
   local b
   b=busy.new()
   b.interval=0.1
   b.Next=function()
     local w
	  w=walk.new()
	  w.walkover=function()
	    wuguan.ReturnTool()
		wuguan.Reward()
	    world.Send("northwest")
		world.Send("task ok")
	  end
	  w:go(17)
   end
   b:check()
end

local function reward_trigger()
   world.AddTriggerEx ("reward", "^(> |)你被奖励了：(.*)点经验和(.*)点潜能。$", "wuguan:JobDone()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   world.SetTriggerOption ("reward", "group", "wuguan")
   world.EnableTrigger("reward",true)
end

local function reward()
  --
  reward_trigger()
end

local function do_job_trigger()
  --你只觉得头昏脑胀，眼前一黑，接着什么也不知道了……
  --一股暖流发自丹田流向全身，慢慢地你又恢复了知觉……

   world.AddTriggerEx ("idle", "^(> |)你只觉得头昏脑胀，眼前一黑，接着什么也不知道了……$", "EnableTimer(\"repeat\",false)", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   world.SetTriggerOption ("idle", "group", "wuguan")
   world.EnableTrigger("idle",true)
end

local function do_job(method)
  taskok_trigger()
  world.AddTimer ("repeat", 0, 0, 0.8, "wuguan.Repeat()", timer_flag.Replace , "")
  world.SetTimerOption ("repeat", "send_to", "12")
  world.SetTimerOption ("repeat", "group", "wuguan")
  world.EnableTimer("repeat",true)
  return function()
    world.SetTimerOption ("repeat", "second", "0.5")
    world.Send(method)
  end
end

local function job(tools)
--锯子 32 ju 木头
--瓢 24 jiao 水
--柴刀 26 pi 柴
--锄头 25  chu 草
--扫帚 31 sao 马房
--水桶
--归还 17
  local b=busy.new()
  b.interval=0.3
  b.Next=function()
   local tool_id,method,room
   if tools=="锯子" then
      tool_id="ju zi"
	  room=32
	  method="ju 木头"
   elseif tools=="瓢" then
      tool_id="piao"
	  room=24
	 method="jiao 水"
   elseif tools=="柴刀" then
      tool_id="chai dao"
	  room=26
	  method="pi 柴"
   elseif tools=="锄头" then
      tool_id="chu tou"
	  room=25
	  method="chu 草"
   elseif tools=="扫帚" then
      tool_id="sao zhou"
	  room=31
	  method="sao 马房"
   elseif tools=="水桶" then
      tool_id="shui tong"
	  room=30
	  method="tiao 水"
   end
   wuguan.ReturnTool=function()
     local cmd
     cmd="give wu "..tool_id
	 world.Send(cmd)
   end
   local w
   w=walk.new()
   w.walkover=function()
     world.Send("wield "..tool_id)
     wuguan.Repeat=wuguan.Do_Job(method)
   end
   w:go(room)
  end
  b:check()
end

local function Go_eat()
  walk:go(20)
end

local function Go_sleep()
  local w
  w=walk.new()
  w.walkover=function()
    world.Send("sleep")
  end
  w:go(34)
end

local function dispose()
  world.EnableGroup("wuguan",false)
  world.DeleteGroup ("wuguan")
end

wuguan={
 new=function()
     local wg={}
	 setmetatable(wg,{__index=wuguan})
	 return wg
 end,
 this=nil, --this 指针 指向当前实例
  status="", --工作状态表
  Get_Tools=get_tools,
  Job=job,
  Do_Job=do_job,
  Repeat=nil,
  ReturnTool=nil,
  Dispose=dispose,
  TaskOk=taskok,
  Reward=reward,
}

local function start_job_trigger()
   --world.AddTriggerEx ("ask_lu", "^(> |)你向鲁坤打听有关『job』的消息。$", "wuguan.Get_Tools()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 120);
   --world.SetTriggerOption ("ask_lu", "group", "wuguan")
   --world.EnableTrigger("ask_lu",true)
end
--鲁坤说道：「最近武馆很忙，你先在物品房领好工具，然后去柴房劈柴吧。」
--鲁坤说道：「最近武馆很忙，你先在物品房领好工具，然后去马厩打扫马房吧。
function wuguan:ask_lu()
    wait.make(function()
	  local l,w=wait.regexp("^(> |)鲁坤说道：「最近武馆很忙，你先在物品房领好工具，然后去.*吧。.*$|^(> |)鲁坤说道：「你不是已经领了工作吗？还不快去做。」$|^(> |)鲁坤说道：「狄云兄弟有事找你，你还是先去找他吧。」$|^(> |)设定环境变量：action = \"ask\"$",5)
	  if l==nil then
	      self:start_job()
	      return
	  end
	  if string.find(l,"你先在物品房领好工具") or string.find(l,"你不是已经领了工作") then
	     self:Get_Tools()
	     return
	  end
	  if string.find(l,"狄云兄弟有事找你") then
	      local b=busy.new()
		  b.Next=function()
	       world.Send("sd")
		   self:answer()
		  end
		  b:check()
	     return
	  end
	  if string.find(l,"设定环境变量：action") then
	     self:ask_lu()
	     return
	  end
	end)
end

function wuguan:start_job()
  wuguan.this=self
  local w
  w=walk.new()
  w.walkover=function()
    --start_job_trigger()
	world.Send("ask lu about job")
	world.Send("set action ask")
	self:ask_lu()
  end
  w:go(5)
end

function wuguan:learn()
package.loaded["learn"] = nil
   require "learn"
   local newbie_learn_literate
	  newbie_learn_literate=learn.new()
	  newbie_learn_literate:addskill("literate")
	  newbie_learn_literate.masterid="bo"
	  newbie_learn_literate.master_place=10
	  newbie_learn_literate.rest=function()
	      local w
		  w=walk.new()
		  w.walkover=function()
		     local newbie_rest=rest.new()
			 newbie_rest.wake=function(flag)
			    if flag==0 then
				  print("睡觉太频繁了!")
				  local ch=hp.new()
	              ch.checkover=function()
                     if ch.pot<100  then
						 process.start()
					 elseif  ch.jingxue<=30 then
						--延迟
						local f
						f=function() ch:check() end
                        f_wait(f,10)
					 else
					    newbie_learn_literate:go()
					 end
	              end
	              ch:check()
				else
    			  newbie_learn_literate:go()
				end
			end
			 newbie_rest:sleep()
		  end
		  --3080
		  local gender=world.GetVariable("gender")
		  if gender=="女性" then
		     w:go(3080)
		  else
		      w:go(34)
		  end
	  end
	  newbie_learn_literate.start_failure=function(error_id)
	      --
		  --print("执行failure",error_id)
		  if error_id==401 then  --精力不够
		      --print("rest")
              newbie_learn_literate:rest()
		  else
			  local newbie_learn={}
			  newbie_learn=learn.new()
			  --print(newbie_learn,newbie_learn_literate)
			  --print(table.getn(newbie_learn.skills)," M!")
			  --print(newbie_learn.skills,newbie_learn_literate.skills)
			  print("学习教头")
			  newbie_learn:addskill("force")
			  newbie_learn:addskill("parry")
			  newbie_learn:addskill("dodge")
			  --newbie_learn:addskill("cuff")
			  newbie_learn:addskill("sword")
			  newbie_learn:addskill("strike")
			  newbie_learn:addskill("hand")




	          newbie_learn.masterid="jiaotou"
	          newbie_learn.master_place=2
			  newbie_learn.rest=function()
	           local w
			   w=walk.new()
		       w.walkover=function()
			   local newbie_rest=rest.new()
				 newbie_rest.wake=function(flag)
				    if flag==0 then
				     print("睡觉太频繁了!")
					  local ch=hp.new()
	                  ch.checkover=function()
                      if ch.pot<100 then
						process.start()
					  elseif  ch.jingxue<=30 then
						--延迟
						local f
						f=function() ch:check() end
						f_wait(f,30)
					  else
						newbie_learn:go()
					  end
	                 end
	                 ch:check()
			   	   else
    			     newbie_learn:go()
				   end
			     end
			     newbie_rest:sleep()
		        end
				local gender=world.GetVariable("gender")
		         if gender=="女性" then
		           w:go(3080)
		         else
		           w:go(34)
		         end
	          end
			  newbie_learn.start_failure=function(error_id)
			       print("error_id:",error_id)
                   if error_id==2 then  --没有找到师傅
				     print("没有找到师傅"," 地点:",newbie_learn.master_place)
				      if newbie_learn.master_place==2 then
					      newbie_learn.master_place=3
					  elseif newbie_learn.master_place==3 then
					      newbie_learn.master_place=4
					  elseif newbie_learn.master_place==4 then
					      newbie_learn.master_place=36
					  elseif newbie_learn.master_place==36 then
						  newbie_learn.master_place=37
					  elseif newbie_learn.master_place==37 then
 					       newbie_learn.master_place=1
					  elseif newbie_learn.master_place==1 then
 					       newbie_learn.master_place=2
					  elseif newbie_learn.master_place==2 then
					      newbie_learn.master_place=1
					  elseif newbie_learn.master_place==1 then
					      newbie_learn.master_place=21
					 elseif newbie_learn.master_place==21 then
					      newbie_learn.master_place=7
					  else
					      newbie_learn.master_place=6
					  end
					  print("没有找到师傅"," 下个地点:",newbie_learn.master_place)
				      newbie_learn:go()
				   end
				   if error_id==102 then
				      --重新开始
				      self:status_check()
				   end
				   if error_id==1 or error==201 then  --经验限制 或 超越师傅
				       local is_ok=newbie_learn:Next()
					   if is_ok==true then  --还有候选项
					       newbie_learn:start()
					   else
					       self:status_check()
					       --newbie_robot:status_check()
					       --newbie_robot:start_job()
					   end
				   end
				   if error_id==401 then
                      newbie_learn:rest()
				   end
			  end
              newbie_learn:go()
		  end
      end
	  newbie_learn_literate:go()
end

function wuguan:JobDone()  --回调函数
    self:start_job()
--[[

	]]
end

function wuguan:status_check()

	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
		if h.exps>=2930 then
		   --world.Send("quit")
           return
		end
	    if h.food<50 or h.drink<50 then
           print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get cha;drink cha;drink cha;drink cha;drop cha;get fan;eat fan;eat fan;drop fan")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:start_job()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(20) --299 ask xiao tong about 食物 ask xiao tong about 茶
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:start_job()
			end
			b:check()
		end
	end
	h:check()
end

function wuguan:step1()
  local w=walk.new()
  w.walkover=function()
     world.Execute("s;s;ask sun about 学习")
	   local b=busy.new()
	  b.Next=function()
	     self:step2()
	  end
	  b:check()

  end
  w:go(1)
end

function wuguan:step2()
  local w=walk.new()
  w.walkover=function()
     local f=function()
	   print("第二步")
     world.Execute("nu;ed;n;ask zhou about 学习")
	   local b=busy.new()
	  b.Next=function()
	     self:step3()
	  end
	  b:check()
	 end
	 f_wait(f,6)
  end
  w:go(1)
end

function wuguan:step3()
  local w=walk.new()
  w.walkover=function()
    local f=function()
	   print("第三步")
     world.Execute("e;s;ask shen about 学习")
	   local b=busy.new()
	  b.Next=function()
	     self:step4()
	  end
	  b:check()
	 end
	 f_wait(f,6)
  end
  w:go(1)
end

function wuguan:step4()
  local w=walk.new()
  w.walkover=function()
    local f=function()
	   print("第四步")
    world.Execute("nu;enter;n;e;e;ask qi about 学习")

	  local b=busy.new()
	  b.Next=function()
	     self:step5()
	  end
	  b:check()
	 end
	 f_wait(f,6)
  end
  w:go(1)
end

function wuguan:step5()
--你只觉得头昏脑胀，眼前一黑，接着什么也不知道了……
--一股暖流发自丹田流向全身，慢慢地你又恢复了知觉……
  world.Send("ask qi about 狄云")
   local f=function()
   local w=walk.new()
   w.walkover=function()
     world.Send("ask huoji about 玉肌丸")
	  local b=busy.new()
	  b.Next=function()
	     self:step6()
	  end
	  b:check()
   end
   w:go(95)
   end
   f_wait(f,8)
end

function wuguan:step6()
  local w=walk.new()
   w.walkover=function()
      world.Send("enter")
	  self:learn()
   end
   w:go(155)
end
--[[
> 狄云轻轻地拍了拍你的头。
狄云说道：「这位小兄弟，我出几个问题考考你，如果答对了可有奖哦。」

如果确认回答问题，请输入 answer y ，不愿意回答的话，可以继续去鲁坤师
兄那里继续工作，请输入 answer n 。

狄云说道：「现在是第一题，一共有四个选项，请用 answer 字母 回答。」
请问：在游戏中建立聊天室的命令是？
A、irc /join                      B、irc /create
C、irc /setroom                   D、irc /invite


请问：请问怎样可以将你的好友「friend」加入你的好友列表中？
A、finger -d friend               B、finger friend
C、finger -a friend
>

请问：内力可以运用于恢复，包括恢复精(yun regenerate)、气(yun recover)、
精力(yun refresh)这三种？
A、是                             B、否   ]]

local quest=""
local answer_a=""
local answer_b=""
local answer_c=""
local answer_d=""

function wuguan:catch_choose_line2()
   wait.make(function()
      local l,w=wait.regexp("^(> |)C、(.*)D、(.*)$|^(> |)C、(.*)$")
      if string.find(l,"D") then
	     answer_d=Trim(w[3])
		 answer_c=Trim(w[2])
	     return
	  end
	  if string.find(l,"C") then
	     answer_c=Trim(w[5])
	     return
	  end
   end)
end

function wuguan:catch_choose_line1()
   wait.make(function()
      local l,w=wait.regexp("^(> |)A、(.*)B、(.*)$")
       if string.find(l,"B") then
	     answer_a=Trim(w[2])
		 answer_b=Trim(w[3])
	     return
	  end

   end)
end

function wuguan:out_wuguan()
   local b=busy.new()
   b.Next=function()
    world.SetVariable("up","cun_pot")
	world.Send("unset 积蓄")
	world.Send("jifa all")
    world.Send("say 天地无用")
	world.Send("south")
	world.AddTimer("dazuo", 0, 0, 2, "dazuo 10", timer_flag.Enabled+timer_flag.Temporary + timer_flag.Replace+timer_flag.ActiveWhenClosed, "")

    --process.xc()
   end
   b:check()
end

function wuguan:catch_quest()
   wait.make(function()
      local l,w=wait.regexp("^(> |)请问：(.*)$|^(> |)狄云说道：「你可以去找我师伯万震山询问离馆的事情了 ask wan about 离馆 。」$|(> |)如果确认回答问题，请输入 answer y ，不愿意回答的话，可以继续去鲁坤师$",5)
	  if l==nil then
	     self:catch_quest()
		 return
	  end
	  if string.find(l,"如果确认回答问题") then
	     world.Send("answer y")
		 self:catch_quest()
		 return
	  end
	  if string.find(l,"请问") then
	      quest=Trim(w[2])
		  wait.time(1) --延迟1s
		  self:auto_answer(quest,answer_a,answer_b,answer_c,answer_d)
	     return
	  end
      if string.find(l,"你可以去找我师伯万震山询问离馆的事情了") then
	     wait.time(1)
		 --world.Execute("s;s;ask sun about 离馆;credit vip")
		 local b=busy.new()
		 b.Next=function()
		    --world.Send("out")
			--world.Send("ask wei about 信")
			--self:out_wuguan()
			print("去学 神照经")
			self:shenzhaojing()
		 end
		 b:check()
	     return
	  end
   end)
end

function wuguan:answer_test(answer)
   world.Send("answer "..answer)
   self:catch_quest()
   self:catch_choose_line1()
   self:catch_choose_line2()
end

function wuguan:answer()

   self:catch_quest()
   self:catch_choose_line1()
   self:catch_choose_line2()

end


-- Modify By River@SJ 2003.8.26

--答案字节不得大于 30 个，汉字 15 个。
-- 答案个数不超过 6 个（含正确答案在内）。
-- 全部为选择题，答案最少需要 2 个。
--/wuguan:auto_answer("内力可以运用于恢复，包括恢复精(yun regenerate)、气(yun recover)、","否","是","1","1")
local question_list = {}


local q={}

q={}
q.question="帮派系统中帮主可以用解散(gdismiss)命令来解散帮派，也可以使用禅\\n让把帮主位置传给帮派中符合条件的玩家？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="阿朱、阿紫、阿碧血缘上讲是姐妹？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="『九阴真经』和『九阳真经』作者是同一个人？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="辟邪剑法源自『葵花宝典』？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="小郡主沐剑屏是其父唯一的孩子？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="ALIAS是指MUD里的别名，用简单的几个字母代替较为复杂的一些指令，\\n从而使输入迅速？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="人物有悟性、根骨、身法、膂力四项基本天赋？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="人物有福缘、纯朴、容貌、精神四项隐藏天赋？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="玩家死亡后可以复活，但是损失所有的钱财，各种技能降半级，经验减\\n少 0.5\% ？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="气是一个人的力气大小的标准，也分为最大值，有效值和当前值？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="精是一个人的精神状况的标准，分为最大值，有效值和当前值。最大值？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="玩家可以通过提高特殊内功的等级来提高后天根骨？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="玩家可以通过提高基本内功的等级来提高后天根骨？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="玩家可以通过提高读书写字的等级来提高后天悟性？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="玩家可以通过提高基本轻功的等级来提高后天身法？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="玩家可以通过提高特殊轻功的等级来提高后天身法？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="正气或戾气是衡量一个人物正直或是邪恶的标尺？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="当精、气、精力、内力的任何一种小于零的时候人都会昏迷，在昏迷时\\n又受到攻击则死亡？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="如果一个游戏者的最高工匠技能级别高于他本身的最高武学技能，且工\\n匠技能大于一百级，则此游戏者将被认为是工匠？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="工匠所拥有的所有武学技能都不能超过二百级？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="工匠技能以四百级为极限，并且受经验限制？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="如果有玩家企图杀害一个工匠，且此工匠不是通缉犯，此工匠可以随时\\n随地呼唤巡捕（yell guard），来寻求巡捕的保护？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="工匠在钱庄中可以比武士存更多的钱，但相对而言取钱的手续费比武士\\n要高？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="经验大于 5,000,000 的玩家就能建立自己的帮派？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="帮派系统中帮派的首领可以在自己的帮派里命令等级比自己低的帮派成\\n员执行某些动作，命令为 gforce"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="帮派系统中每个帮派都有自己的实力值和名望值，实力值由帮派的成员\n的实力总和而得，名望值的增减则由帮派间争斗得结果决定？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="在聊天系统中，用 say  命令说出来的话，只能被同一个场景内的玩家\\n听到？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="如果在短时间内发大量信息到公聊频道的玩家，将会被系统强制关闭他\\n的聊天频道？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="算命得知：「看……五官挪位，印堂发暗，……。」可知其容貌小于 15 ？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="算命得知：「……，不过你前生一定行了善事，一生大富大贵，子孙多\\n多。」可知其福缘小于 20 ？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="加力(jiali) 的多少直接影响攻击力。但应注意加力的大小，加力后增\\n加杀伤力但同时消耗大量内力？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="读书时，每一次读书都要消耗一些精血，悟性高的人消耗的精血较少，\\n悟性低的人消耗的精血较多？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="在三十岁前精的最大值会逐年增长，四十岁后则会逐年减少，七十岁后\\n不再变化？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="内力可以运用于恢复，包括恢复精(yun regenerate)、气(yun recover)、"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="潜能的上限与受经验限制的武功级别有关？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="武功的有效等级等于基本武功跟特殊武功之和？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="帮派争斗中攻击对方的物品或房间时，同一房间的所有和攻击者同一帮\\n派或同一联盟的玩家的攻击力和防御力会有一定的下降？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)

q={}
q.question="在帮派争斗期间，争斗双方及其各自结盟帮派的成员在争斗双方的帮派\\n区域里叫杀没有BUSY，但杀死对方后会被通缉？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)

q={}
q.question="帮派系统中帮派成员分为帮主、副帮主、堂主、帮众四个等级？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)
q={}
q.question="工匠可以去扬州东门附近的龙门镖局雇佣保镖来保护自己，一个工匠所\\n能雇佣的保镖最高等级取决于该工匠的战斗经验的高低？"
q.answer="否"
q.choose={"是"}
table.insert(question_list,q)
q={}
q.question="在任何地方都可以对通缉犯叫杀(kill)，而且没有忙碌状态？"
q.answer="是"
q.choose={"否"}
table.insert(question_list,q)
q={}
q.question="练习技能一次得到的点数约等于该项基本武功的级别的："
q.answer="1/5"
q.choose={ "1/2", "1/3", "1/4" }
table.insert(question_list,q)
q={}
q.question="领悟一次得到的点数取决于："
q.answer="读书写字"
q.choose={ "先天悟性", "后天悟性", "精" }
table.insert(question_list,q)
q={}
q.question="吐呐需要你的气的当前值大于最大气的："
q.answer="70\%"
q.choose=	{ "50\%", "60\%", "80\%" }
table.insert(question_list,q)
q={}
q.question="打坐需要你的精的当前值大于最大精的："
q.answer="80\%"
q.choose=	{ "50\%", "60\%", "70\%" }
table.insert(question_list,q)
q={}
q.question="用「一苇渡江」渡过汉水,需要轻功有效等级大于等于："
q.answer="80"
q.choose=	{ "60", "100", "120" }
table.insert(question_list,q)
q={}
q.question="飞身渡黄河需要轻功有效等级大于等于："
q.answer="250"
q.choose=	{ "200", "300", "350" }
table.insert(question_list,q)
q={}
q.question="飞身渡长江需要最大内力大于等于："
q.answer="3500"
q.choose=	{ "2000", "2500", "3000" }
table.insert(question_list,q)
q={}
q.question="温家五老中，愿意把五行阵传授给外人的是："
q.answer="温方山"
q.choose=	{ "温方达", "温方义", "温方悟", "温方施"}
table.insert(question_list,q)
q={}
q.question="下列行为中，不会被通缉的是："
q.answer="杀官兵"
q.choose=	{ "杀侯君集", "杀史青山", "杀顾炎武" }
table.insert(question_list,q)
q={}
q.question="下面那一项不是昆仑三圣何足道的绰号？"
q.answer="赌圣"
q.choose=	{ "棋圣", "剑圣", "琴圣" }
table.insert(question_list,q)
q={}
q.question="屠龙刀中藏的是："
q.answer="武穆遗书"
q.choose=	{ "九阴真经", "九阳真经", "葵花宝典" }
table.insert(question_list,q)
q={}
q.question="下面哪个不是看守谢逊的三大神僧？"
q.answer="空见"
q.choose=	{ "渡厄", "渡劫", "渡难" }
table.insert(question_list,q)
q={}
q.question="「那少年约莫十五六岁年纪，头上歪戴著一顶黑黝黝的破石帽，.....\\n露出两排晶晶发亮的雪白细牙...眼珠漆黑，甚是灵动」说的是："
q.answer="黄蓉"
q.choose=	{ "韦小宝", "木婉清", "杨过" }
table.insert(question_list,q)
q={}
q.question="下面这些人不曾断指的是："
q.answer="赵志敬"
q.choose={ "尹志平", "范遥", "郑克爽" }
table.insert(question_list,q)
q={}
q.question="恢复精血的指令是："
q.answer="yun jing"
q.choose=	{ "yun jingli", "yun qi", "yun heal" }
table.insert(question_list,q)
q={}
q.question="恢复精力的指令是："
q.answer="yun jingli"
q.choose={ "yun jing", "yun qi", "yun heal" }
table.insert(question_list,q)
q={}
q.question="恢复气血的指令是："
q.answer="yun qi"
q.choose={ "yun jing", "yun jingli", "dazuo" }
table.insert(question_list,q)
q={}
q.question="使内力增加的最常用途径是："
q.answer="dazuo"
q.choose={ "yun jing", "yun jingli", "yun qi" }
table.insert(question_list,q)
q={}
q.question="学习技能将会消耗的是："
q.answer="精血"
q.choose={ "精力", "内力", "气血" }
table.insert(question_list,q)
q={}
q.question="在河边或者江边叫船的指令是："
q.answer="yell boat"
q.choose={ "look boat", "yell", "find boat" }
table.insert(question_list,q)
q={}
q.question="下面哪种频道解释是错误的？"
q.answer="party 帮派频道"
q.choose={ "chat 闲聊频道", "rumor 谣言频道", "tell 私聊频道" }
table.insert(question_list,q)
q={}
q.question="如果你到了一个出售商品的NPC面前，看商品目录的指令是？"
q.answer="list"
q.choose={ "look", "place", "help" }
table.insert(question_list,q)
q={}
q.question="如果你在游戏中想跟随某个玩家或者NPC一起行动,则应输入指令："
q.answer="follow"
q.choose=	{ "gen", "follow none", "lead" }
table.insert(question_list,q)
q={}
q.question="如果你想解除跟随某个玩家或NPC的指令，则应输入："
q.answer="follow none"
q.choose={ "follow", "no follow", "follow me" }
table.insert(question_list,q)
q={}
q.question="在游戏中，查看自己有何武功的指令是？"
q.answer="skills(cha)"
q.choose={ "score", "inventory(i)", "hp" }
table.insert(question_list,q)
q={}
q.question="在游戏中，查看自己身上有何物品的指令是？"
q.answer="inventory(i)"
q.choose={ "look", "skills", "hp" }
table.insert(question_list,q)
q={}
q.question="离开游戏的正确指令是？"
q.answer="quit"
q.choose={ "断线", "关闭zMUD窗口", "关机" }
table.insert(question_list,q)
q={}
q.question="下面不属于私人聊天的指令是："
q.answer="rumor"
q.choose={ "tell", "reply", "whisper" }
table.insert(question_list,q)
q={}
q.question="不受根骨影响的是："
q.answer="饭量的大小"
q.choose=	{ "气的恢复速度", "受攻击时所受的伤害", "每岁精、气的增长" }
table.insert(question_list,q)
q={}
q.question="不影响膂力大小的是："
q.answer="基本招架"
q.choose={ "基本拳脚", "基本指法", "基本腿法" }
table.insert(question_list,q)
q={}
q.question="不决定铸造兵器基本威力的是："
q.answer="铸造时间"
q.choose={ "兵器的等级", "制造兵器的原材料", "制造者的锻造技能" }
table.insert(question_list,q)
q={}
q.question="不属于药师应该拥有的技能是："
q.answer="种植术"
q.choose={ "采药术", "提炼术", "炼丹术" }
table.insert(question_list,q)
q={}
q.question="不属于铸剑师应该拥有的技能是："
q.answer="修理术"
q.choose={ "采矿术", "打铁术", "锻造术" }
table.insert(question_list,q)
q={}
q.question="不属于织造师应该拥有的技能是："
q.answer="修补术"
q.choose={ "采集术", "编织术", "裁剪术" }
table.insert(question_list,q)
q={}
q.question="当你想要了解某一区域（比如大理）的地图的时候，指令是："
q.answer="help map dali"
q.choose={ "help", "help map here", "look dali" }
table.insert(question_list,q)
q={}
q.question="当你想要了解某一门派（比如明教）的说明时，指令是："
q.answer="help party mingjiao"
q.choose={ "help", "help party", "party help" }
table.insert(question_list,q)
q={}
q.question="在帮派系统中,如果要对一个帮派开战，那么宣战的指令是？"
q.answer="declare"
q.choose={ "delate", "grant", "destory" }
table.insert(question_list,q)
q={}
q.question="在帮派系统中，结盟的指令是？"
q.answer="ally"
q.choose={ "attack", "gwar", "abdicate" }
table.insert(question_list,q)
q={}
q.question="如果要销毁自己帮派里的物品或房间，使用的命令是："
q.answer="destory"
q.choose={ "attack", "gwar", "build" }
table.insert(question_list,q)
q={}
q.question="请问怎样可以将你的好友「friend」加入你的好友列表中？"
q.answer="finger -a friend"
q.choose={ "finger friend", "finger -d friend" }
table.insert(question_list,q)
q={}
q.question="请问如何给自己起一个「nickname」的外号？"
q.answer="nick nickname"
q.choose={ "nick none", "nick add nickname"}
table.insert(question_list,q)
q={}
q.question="为了角色安全需要时常修改登陆密码，请问通过什么指令修改？"
q.answer="passwd"
q.choose={ "password", "passwd -c", "passwd -send" }
table.insert(question_list,q)
q={}
q.question="请问如何查看角色的本次连线时间？"
q.answer="time"
q.choose={ "uptime", "onlinetime"}
table.insert(question_list,q)
q={}
q.question="玩家「char」在公开频道中发布不适当言论，你希望发布一个投票关闭\n他的频道该如何进行？"
q.answer="vote chblk char"
q.choose={ "vote unchblk char", "chblk char", "unchblk char"}
table.insert(question_list,q)
q={}
q.question="你希望在自己的角色上增加一些个性的描述说明，该通过哪个指令添加？"
q.answer="describe"
q.choose={ "nick", "color", "score" }
table.insert(question_list,q)
q={}
q.question="如何把玄铁剑法(xuantie-jianfa)指定为你使用的基本剑法种类？"
q.answer="jifa sword xuantie-jianfa"
q.choose={ "jifa xuantie-jianfa", "bei xuantie-jianfa", "bei sword xuantie-jianfa" }
table.insert(question_list,q)
q={}
q.question="如何查看书剑的预设表情动作列表？"
q.answer="semote"
q.choose={ "emote", "help emote" }
table.insert(question_list,q)
q={}
q.question="如果你不希望看到闲聊频道的说话，通过什么指令关闭？"
q.answer="tune chat"
q.choose={ "tune party", "tune rumor", "tune sj" }
table.insert(question_list,q)
q={}
q.question="使用什么指令可以让你从战斗中安全脱离出来？"
q.answer="halt"
q.choose={ "go", "leave" }
table.insert(question_list,q)
q={}
q.question="使用什么指令可以让在游戏中的所有人肯定可以看到你所说的话？"
q.answer="shout"
q.choose={ "chat", "rumor", "sj" }
table.insert(question_list,q)
q={}
q.question="使用什么指令可以解散一个你已经建立的队伍？"
q.answer="team dismiss"
q.choose={ "team with", "team", "team talk" }
table.insert(question_list,q)
q={}
q.question="如果你不想与玩家「char」私聊，应当如何进行？"
q.answer="set block char"
q.choose={ "set tell char", "finger -a char", "finger -d char" }
table.insert(question_list,q)
q={}
q.question="当地上有黄金「gold」，你想捡起来，应输入的指令是"
q.answer="get gold"
q.choose={ "drop gold", "give gold", "steal gold" }
table.insert(question_list,q)
q={}
q.question="如果你想装备剑「sword」，则应输入？"
q.answer="wield sword"
q.choose={ "unwield sword", "wear sword", "remove sword" }
table.insert(question_list,q)
q={}
q.question="当你想从玩家「char」身上偷取黄金「gold」时，正确的指令是？"
q.answer="steal gold from char"
q.choose={ "give char gold", "give gold to char", "get gold from char" }
table.insert(question_list,q)
q={}
q.question="当你想把身上的衣服「cloth」穿上时，应该输入的指令是？"
q.answer="wear cloth"
q.choose={ "remove cloth", "wield cloth", "unwield cloth" }
table.insert(question_list,q)
q={}
q.question="当你想脱掉身上的衣服(cloth)时，应该输入的指令是？"
q.answer="remove cloth"
q.choose={ "wear cloth", "wield cloth", "unwield cloth" }
table.insert(question_list,q)
q={}
q.question="当你想把身上的衣服「cloth」丢弃的时候，应输入的指令是？"
q.answer="drop cloth"
q.choose={ "get cloth", "give cloth", "put cloth" }
table.insert(question_list,q)
q={}
q.question="当你想把手中的剑「sword」放下时，应该输入的指令是？"
q.answer="unwield sword"
q.choose={ "wield sword", "wear sword", "remove sword" }
table.insert(question_list,q)
q={}
q.question="用内力给自己疗伤的指令是？"
q.answer="yun heal"
q.choose={ "yun jingli", "yun qi", "yun jing" }
table.insert(question_list,q)
q={}
q.question="如果你想给玩家「char」疗伤，应该输入的指令是？"
q.answer="yun lifeheal char"
q.choose={ "yun heal char", "yun lifesave char", "yun qi char" }
table.insert(question_list,q)
q={}
q.question="神雕侠侣中小龙女传给杨过抓麻雀的手法是什么？"
q.answer="tianluo-diwang"
q.choose={ "yunu-shenfa", "yunu-xinjing", "yinsuo-jinling" }
table.insert(question_list,q)
q={}
q.question="鹿鼎记中韦小宝使用的轻功是什么？"
q.answer="shenxing-baibian"
q.choose={ "hansha-sheying", "lingbo-weibu", "tianlong-xiang" }
table.insert(question_list,q)
q={}
q.question="笑傲江湖中风清阳传给令狐冲的剑法是什么？"
q.answer="dugu-jiujian"
q.choose={ "huashan-jianfa", "taiji-jian", "xuantie-jianfa" }
table.insert(question_list,q)
q={}
q.question="射雕英雄传里梅超风传给杨康的爪法是什么？"
q.answer="jiuyin-baiguzhua"
q.choose={ "jiuyin-shenzhua", "ningxue-shenzhua", "youming-shenzhua" }
table.insert(question_list,q)
q={}
q.question="当你身处茶馆，想要买花生「huasheng」，指令是？"
q.answer="buy huasheng"
q.choose={ "sell huasheng", "get huasheng", "qu huasheng" }
table.insert(question_list,q)
q={}
q.question="自己建立帮派的命令是？"
q.answer="gcreate"
q.choose={ "glist", "build", "grant" }
table.insert(question_list,q)
q={}
q.question="如果你想布五行阵「wuxing-zhen」,该使用的命令是？"
q.answer="lineup form wuxing-zhen"
q.choose={ "lineup", "lineup wuxing-zhen", "lineup with wuxing-zhen" }
table.insert(question_list,q)
q={}
q.question="在游戏中建立聊天室的命令是？"
q.answer="irc /create"
q.choose={ "irc /join", "irc /setroom", "irc /invite" }
table.insert(question_list,q)
q={}
q.question="如果你想跟玩家「char」组队，应该使用的命令是？"
q.answer="team with char"
q.choose={ "team dismiss", "team talk", "team kill" }
table.insert(question_list,q)
q={}
q.question="学习一次得到的点数约等于后天悟性的："
q.answer="1/2"
q.choose={"1/3", "1/4", "1/5"}
table.insert(question_list,q)
q={}
q.question="读书一次得到的点数约等于读书写字级别的："
q.answer="1/5"
q.choose={"1/2", "1/3", "1/4"}
table.insert(question_list,q)
q={}
q.question="当你的气血上限不是 100% 时，哪种原因是错误的？"
q.answer="食物吃得太多"
q.choose={ "最大气血增加后再次连线进入游戏", "战斗受伤", "中毒" }
table.insert(question_list,q)

q={}
q.question="讨价还价(trade) 是你做买卖讲价的水平，级别越高则在买卖中的亏损\\n越少？"
q.answer="是"
q.choose={ "否" }
table.insert(question_list,q)

q={}
q.question="当你的气血上限不是 100% 时，哪种原因是错误的？"
q.answer="食物吃得太多"
q.choose={ "食物吃得太多","最大气血增加后再次连线进入游戏","战斗受伤","中毒" }
table.insert(question_list,q)
--请问：请问如何设定当自己气血不足 30% 的时候自动逃离战场？
q={}
q.question="请问如何设定当自己气血不足 30% 的时候自动逃离战场？"
q.answer="set wimpy 30"
q.choose={ "set wimpy 30","set brief 30","set no_accept 30","set block 30" }
table.insert(question_list,q)

q={}
q.question="请问如何把玄铁剑法(xuantie-jianfa)指定为你使用的基本剑法种类？"
q.answer="jifa sword xuantie-jianfa"
q.choose={ "bei xuantie-jianfa","jifa xuantie-jianfa","jifa sword xuantie-jianfa","bei sword xuantie-jianfa" }
table.insert(question_list,q)
--请问：帮派系统中帮主可以用解散(gdismiss)命令来解散帮派，也可以使用禅
--让把帮主位置传给帮派中符合条件的玩家？
--A、是                             B、否

--请问：在任何地方都可以对通缉犯叫杀(kill)，而且没有忙碌状态？
function test_answer()
  local q="帮派系统中帮主可以用解散(gdismiss)命令来解散帮派，也可以使用禅"
  wuguan:auto_answer(q,"是","否","","")
end
--/wuguan:auto_answer("请问：请问如何设定当自己气血不足 30% 的时候自动逃离战场？","set wimpy 30","set brief 30","set no_accept 30","set block 30")
function wuguan:auto_answer(_quest,_a,_b,_c,_d)
  --print("问题:",_quest)
	local s,e=string.find(_quest,"%%")
	if s~=nil then
      _quest=string.sub(_quest,1,s-1).."%%"..string.sub(_quest,e+1,string.len(_quest))
   end

   local s,e=string.find(_quest,"-")
	if s~=nil then
      _quest=string.sub(_quest,1,s-1).."%-"..string.sub(_quest,e+1,string.len(_quest))
   end

   local s,e=string.find(_quest,"%(")
   if s~=nil then
      _quest=string.sub(_quest,1,s-1).."%("..string.sub(_quest,e+1,string.len(_quest))
	  s,e=string.find(_quest,"%(",e+2)
      if s~=nil then
        _quest=string.sub(_quest,1,s-1).."%("..string.sub(_quest,e+1,string.len(_quest))
	    --s,e=string.find(_quest,"%(",e)
      end
   end

   local s,e=string.find(_quest,"%)")
   if s~=nil then
      _quest=string.sub(_quest,1,s-1).."%)"..string.sub(_quest,e+1,string.len(_quest))
	   s,e=string.find(_quest,"%)",e+2)
      if s~=nil then
        _quest=string.sub(_quest,1,s-1).."%)"..string.sub(_quest,e+1,string.len(_quest))
      end
   end

  print("问题:",_quest)
  print("a:",_a,"b:",_b,"c:",_c,"d:",_d)
  for _,q in ipairs(question_list) do
      --print("wenti: ",q.question)
	  --print("result:",_quest)
       if string.find(q.question,_quest) then
	       print("找到问题")
	       local choose=""
	      if Trim(q.answer)==_a then
		    choose="answer a"
		  elseif q.answer==_b then
		    choose="answer b"
		  elseif q.answer==_c then
		    choose="answer c"
		  elseif q.answer==_d then
		    choose="answer d"
		  else
		     choose="answer e"
		  end
		 world.Send(choose)
		 self:answer()
         return

	   end

  end
   print("没有找到匹配问题！！！ 手动加入!!")
end

function wuguan:leave()
  local b=busy.new()
  b.Next=function()
    world.Execute("n;w;w;w;w;w;wu;sd;s;s")
   local w=walk.new()
   w.walkover=function()
      world.Execute("ask sun about 离馆;credit vip")
	  local b=busy.new()
	  b.Next=function()
        world.Send("out")
	    world.Send("ask wei about 信")
        self:out_wuguan()
	  end
	  b:check()
	end
	w:go(21)
  end
  b:check()
end

function wuguan:moveshi()
	local h=hp.new()
	h.checkover=function()
	     if h.jingxue>=90 then
		     world.Send("move shi")

			 local b=busy.new()
		    b.Next=function()
		      world.Send("enter")
	          world.Send("l wall")
	          world.Send("l fuhao")
	          world.Execute("#5 lingwu fuhao")
		      world.Send("jifa all")
		      local f2=function()
		         world.Send("out")
			     world.Execute("out;zuan feng")
                 local f=function()
			       self:leave()
				 end
				 f_wait(f,4)
		      end
		     f_wait(f2,5)
	        end
	        b:check()
		 else
		   local f=function()
		    self:moveshi()
		   end
		   f_wait(f,3)
		 end

	  end
	  h:check()
end

--武馆学神照经
function wuguan:shenzhaojing()
   local w=walk.new()
   w.walkover=function()
      world.Send("zuan feng")
	  self:moveshi()

   end
   w:go(44)
end
--[[
>
问题: 请问如何把玄铁剑法(xuantie-jianfa)指定为你使用的基本剑法种类？
a: bei xuantie-jianfa b: jifa xuantie-jianfa c: jifa sword xuantie-jianfa d: bei sword xuantie-jianfa]]
