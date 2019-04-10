 --[[找慕容复ask fu about 武学(注意：要任务的时候旁边不能有人
 ，有人的话，慕容复会说今天天气不错什么的。还有连尸体也不能有
 ，有尸体要先搬才行）。问完了，fu会告诉你最近想学什么工夫。这
 时会有一个dizi出来跟着你走，你带着他到会这种武功的NPC那里和他
 fight，一边fight一边打touxue 某人 功夫 一直到你的dizi说可以走
 了，你就可以会燕子坞交差了。
 慕容复在你的耳边悄声说道：我姑苏慕容傲视天下所有武功，但也不乏为之羡慕的。
慕容复在你的耳边悄声说道：好吧，「打狗棒法」「dagou-bang」我垂涎已久，你们把它学回来，我大大的有赏。
慕容复说道：「今天天气就是好，就是好。」]]

--1345
--散花掌 玄慈大师
local touxue_skills_target={
{"打狗棒法","史青山",{126}},
{"打狗棒法","宋长老",{998}},
{"锁喉擒拿手","白世镜",{998}},
{"四象六合刀","接引弟子",{2287}},
{"散花掌","元哀尊者",{1899}},
{"燃木刀法","元怒尊者",{1907}},
{"般若掌","澄明",{870}},
{"风云手","澄观",{872}},
{"大金刚拳","澄知",{871}},
{"达摩剑","澄尚",{804}},
{"伏魔剑","澄和",{867}},
{"寂灭爪","澄识",{805}},
{"龙爪功","澄净",{868}},
{"罗汉拳","澄意",{807}},
{"摩诃指","澄坚",{860}},
{"韦驮棍","澄寂",{865}},
{"韦驮掌","澄思",{806}},
{"韦陀杵","玄苦大师",{1904}},
{"普渡杖法","澄欲",{803}},
{"如来千叶手","澄心",{808}},
{"少林弹腿","澄灵",{802}},
{"少林醉棍","玄难大师",{796}},
{"如影随形腿","玄生大师",{839}},
{"无常杖法","澄灭",{866}},
{"慈悲刀","澄行",{864}},
{"修罗刀","澄信",{801}},
{"一指禅","澄志",{800}},
{"鹰爪功","清乐比丘",{2552}},
{"拈花指","黄眉和尚",{492}},
{"抽髓掌","五毒教女弟子",{366}},
{"五罗轻烟掌","高升泰",{466}},
{"段家剑法","高升泰",{466}},
{"一阳指","武三通",{4021}},
{"一阳指","段正淳",{481}},
{"回风拂柳剑","静真师太",{667}},
{"四象掌","静真师太",{667}},
{"雁行刀法","静慧师太",{696}},
{"烈焰刀","周颠",{2246}},
{"鹰爪擒拿手","男教众",{2246,2243,2242}},
{"寒冰绵掌","女教众",{2246,2243,2242}},
{"劈石破玉拳","梁发",{1517}},
{"华山剑法","梁发",{1517}},
{"混元掌","梁发",{1517}},
{"玉箫剑法","陆冠英",{2477}},
{"旋风扫叶腿","陆冠英",{2477}},
{"落英神剑掌","陆冠英",{2477}},
{"风魔杖法","瑞婆婆",{613}},
{"截手九式","郭芙",{162}},
{"虎爪绝户手","万青里",{1952}},
{"玄虚刀法","谷虚道长",{1947}},
{"武当长拳","谷虚道长",{1947}},
--{"太极剑法","张松溪",{1958}},
{"太极剑法","陈运清",{1953}},
{"太极拳","张松溪",{1958}},
{"天山杖法","黯然子",{1968}},
{"天山杖法","星宿派弟子",{1963,2235}},
{"温家刀法","温南扬",{173}},
{"降龙十八掌","耶律齐",{190}},
{"温家拳","温南扬",{173}}}


--玄生喝道：证道院乃本寺弟子禅修之处，你非本寺弟子，不能入内。
--千蛛万毒手
--兰花拂穴手
--弹指神通
--反两仪刀法
--回风鞭法
--降龙十八掌 耶律齐 190
--日月鞭
--你要向谁偷学？
--不在战斗中怎么能偷学呢？
--[[你向慕容复打听有关『复命』的消息。
慕容复仔细研究着你记在纸卷上的武功精要，情不自禁地说道：好一个烈焰刀。
慕容复拍了拍你的头，对你说道：辛苦你了，下去休息吧。
你获得了二百零七点经验和五十一点潜能的奖励。
你已经为慕容世家做了2次任务!]]
touxue={
  new=function()
     local tx={}
	 setmetatable(tx,{__index=touxue})
	 return tx
  end,
  skill_id="",
  skill_name="",
  co=nil,
  success=false,
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

function touxue:fail(id)
end

function touxue:ask_job()
  local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask murong fu about 武学")
    local l,w=wait.regexp("^(> |)慕容复在你的耳边悄声说道：好吧，「(.*)」「(.*)」我垂涎已久，你们把它学回来，我大大的有赏。|慕容复说道：「.*先等等吧，我现在没有什么感兴趣的武功想学。」$|^(> |)慕容复说道：「.*还没完成我交给你的任务呢。」$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"慕容复在你的耳边悄声说道") then
	  world.AppendToNotepad (WorldName(),os.date()..": 偷学skill:".. w[2].." "..w[3].."\r\n")
	  local name=w[2]
	  local id=w[3]
	  self.skill_id=w[3]
	  self.skill_name=w[2]
	  self:touxue(name,id)
	  return
	end
	if string.find(l,"先等等吧，我现在没有什么感兴趣的武功想学") then
	  	local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=0
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   self.fail(102)
			   return
			  end
			end
		 end
		 self.fail(101)

	   end
	   cd:start()
	   return
	end
	if string.find(l,"还没完成我交给你的任务呢") then
	   self:giveup()
	   return
	end
	wait.time(5)
   end)
  end
  w:go(1989)
end

function touxue:reward()
 --[[local win=window.new() --监控窗体
 win.name="status_window"
 win:addText("label1","目前工作:偷学任务")
 win:addText("label2","目前过程:奖励")
 win:refresh()]]

   	local ts={
	           task_name="慕容偷学",
	           task_stepname="奖励",
	           task_step=4,
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
    world.Send("ask murong fu about 复命")
    local l,w=wait.regexp("^(> |)慕容复拍了拍你的头，对你说道：辛苦你了，下去休息吧。$|^(> |)慕容复说道：「你学到什么东西了？还有脸敢回来？」$|^(> |)慕容复说道：「你现在没有任务吧？」$",5)
	if l==nil then
	  self:reward()
	  return
	end
	if string.find(l,"慕容复拍了拍你的头") then
	  self:exps()
      local b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	     self:jobDone()
	  end
	  b:check()
	  return
	end
	if string.find(l,"你现在没有任务吧") then
	   self:giveup()
	   return
	end
	if string.find(l,"你学到什么东西了？还有脸敢回来") then
	   self:giveup()
	   return
	end
	wait.time(5)
   end)
  end
  w:go(1989)
end

function touxue:NextPoint()
   print("进程恢复")
   coroutine.resume(touxue.co)
end

function touxue:giveup()
   local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask murong fu about 放弃")
    local l,w=wait.regexp("^(> |)你向慕容复打听有关『放弃』的消息。$",5)
	if l==nil then
	  self:giveup()
	  return
	end
	if string.find(l,"你向慕容复打听有关") then
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	    self:Status_Check()
	  end
	  b:check()
	  return
	end
	wait.time(5)
   end)
  end
  w:go(1989)
end

function touxue:exps()
 wait.make(function()
   local l,w=wait.regexp("^(> |)你获得了.*$",5)
    if l==nil then
       self:exps()
	   return
    end
    if string.find(l,"你获得了") then
	   --world.AppendToNotepad (WorldName(),os.date()..": 偷学job 经验:".. ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]).."\r\n")
	   --local exps=world.GetVariable("get_exp")
	   --exps=tonumber(exps)+ChineseNum(w[2])
	   --world.SetVariable("get_exp",exps)
	   --world.AppendToNotepad (WorldName(),os.date().."目前获得总经验值"..exps.."\r\n")
	  return
	end
	wait.time(5)
 end)
end

function touxue:checkPlace(npc,roomno,here)
      if is_contain(roomno,here) then
	       print("确定到达出发点->Next Room")
		   local b
		   b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
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


function touxue:run(i)
   if i==nil then
      i=1
   end
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
			   if self.success==true then
                  self:reward()
               else
                  self:giveup()
               end
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function touxue:combat_check()
end

function touxue:flee(i)
  world.Send("yield no")
  --world.Send("go away")
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
	 self:combat_check()
	 self:run(i)
   end
   _R:CatchStart()
end

function touxue:combat()
end

function touxue:start(npc,id)
  wait.make(function()
   world.Send("yun qi")
   world.Send("yun jing")
   world.Send("yun refresh")
   world.Send("hp")
   --world.Send("yun shenyuan")
   world.Send("touxue "..self.skill_id.." from "..id)
   local l,w=wait.regexp("^(> |)你感觉已经渐渐领悟了"..self.skill_name.."的精髓，可以回去复命了。|^(> |)不在战斗中怎么能偷学呢？$|^(> |)你要向谁偷学？$|^(> |)你现在没有用斗转星移，怎么能偷学到别人的武功？$",3)
   if l==nil then
      self:start(npc,id)
      return
   end
   if string.find(l,"不在战斗中怎么能偷学呢") then
      world.Send("hit "..id)
      self:start(npc,id)
	  return
   end
   if string.find(l,"你感觉已经渐渐领悟了") then
      shutdown()
      self.success=true
      self:flee()
      return
   end
   if string.find(l,"你现在没有用斗转星移，怎么能偷学到别人的武功") then
      world.Send("jifa parry douzhuan-xingyi")
	  self:start(npc,id)
      return
   end
   if string.find(l,"你要向谁偷学") then
     print("战斗结束")
     shutdown()
     self:recover()
     return
   end
   wait.time(3)
  end)
end

function touxue:yield()
  wait.make(function()
    world.Send("yield yes")
    local l,w=wait.regexp("^(> |)你决定打架时打不还手。$",2)
	if l==nil then
	  self:yield()
	  return
	end
	if string.find(l,"你决定打架时打不还手") then
	  print("开始进行盗版!!!")
	  return
	end
	wait.time(2)
  end)
end

function touxue:fight(npc,id)
    	local ts={
	           task_name="慕容偷学",
	           task_stepname="战斗",
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="偷学"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --[[local win=window.new() --监控窗体
   win.name="status_window"
   win:addText("label1","目前工作:偷学任务")
   win:addText("label2","目前过程:fight")
   win:addText("label3","偷学npc:"..npc)
   win:refresh()]]
   world.Send("jifa parry douzhuan-xingyi")
   --world.Send("yun shenyuan")
   world.Send("yield yes")
   world.Send("hit "..id)
   self:yield()
   self:combat()
   self:start(npc,id)
end

function touxue:checkNPC(npc,roomno)
  print(npc)
  wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc..".*\\\((.*)\\\).*$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      --没有找到
		  if roomno~=nil then
		     local f=function(r)
		        self:checkPlace(npc,roomno,r)
		     end
		     WhereAmI(f,10000) --排除出口变化
		  else
		     self:NextPoint()
		  end
		  return
	  end
	  if string.find(l,npc) then
	     --找到
		  local id=string.lower(w[2])
		  if id=="corpse" then
			if roomno~=nil then
		      local f=function(r)
		        self:checkPlace(npc,roomno,r)
		      end
		      WhereAmI(f,10000) --排除出口变化
		    else
		      self:NextPoint()
			end
		  else
			 self:fight(npc,id)
		  end
		  return
	  end
	  wait.time(6)
   end)
end

function touxue:look_paper()
   wait.make(function()
      world.Send("look paper")
	  local l,w=wait.regexp("^(> |)这是一张发黄的卷帛，上面写着：偷学.*级 (.*) \\((.*)\\)。$",5)
	  if l==nil then
	     self:look_paper()
	     return
	  end
	  if string.find(l,"这是一张发黄的卷帛") then
	     --print(w[2],w[3])
	     local name=w[2]
	     local id=w[3]

	     self.skill_name=Trim(w[2])
		 self.skill_id=Trim(w[3])
	     self:touxue(name,id)
	     return
	  end
	  wait.time(5)
   end)
end

function touxue:shield()
end

function touxue:touxue(name,id)
  --[[ local win=window.new() --监控窗体
   win.name="status_window"
   win:addText("label1","目前工作:偷学任务")
   win:addText("label2","目前过程:偷学")
   win:addText("label3","偷学skills:"..name)
   win:refresh()]]


  print(name,id)
  local npc=""
  local rooms=nil
  print(table.getn(touxue_skills_target))
  for _,i in ipairs(touxue_skills_target) do
    -- print(i[1]," 比对 ",name)
     if i[1]==name then
	   print("找到")
	   npc=i[2]
	   rooms=i[3]
	   break
	 end
  end



  local exps=world.GetVariable("exps")
  print(name,exps)
  if (name=="散花掌" or name=="如影随形腿" or name=="降龙十八掌") and tonumber(exps)<=800000 then
    local b=busy.new()
	b.interval=0.3
	b.Next=function()
     self:giveup()
	end
    b:check()
     return
  end
  if rooms==nil then
	local b=busy.new()
	b.interval=0.3
	b.Next=function()
     self:giveup()
	end
    b:check()
     return
  end
  local n=table.getn(rooms)
  if n>0 then

	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   print("抓取")
	   self:shield()
	   touxue.co=coroutine.create(function()
          for _,r in ipairs(rooms) do
		       	local ts={
	           task_name="慕容偷学",
	           task_stepname="偷学"..npc,
	           task_step=2,
	           task_maxsteps=4,
	           task_location=r,
	           task_description="偷学 "..name.."("..id..")",
	      }
	       local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
		    local w=walk.new()
			w.walkover=function()
			   self:checkNPC(npc,r)
			end
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

function touxue:auto_kill()
  wait.make(function()
    print("防auto kill")
     local l,w=wait.regexp("^(> |)看起来.*想杀死你！$",10)
	 if l==nil then
	    self:auto_kill()
	   return
	 end
	 if string.find(l,"想杀死你") then
	   shutdown()
	   self:flee()
	   return
	 end
     wait.time(10)
  end)
end

function touxue:recover()
    self:auto_kill()
	local h
	h=hp.new()
	h.checkover=function()
		if h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal()
		elseif h.neili<(h.max_neili*2-200) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.8
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
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   if h.neili>h.max_neili*2-200 then
			      world.Send("yun recover")
			      self:look_paper()
			   else
	             print("继续修炼")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)
			shutdown()
			local b
			b=busy.new()
			b.Next=function()
			  self:look_paper()
			end
			b:check()
		end
	end
	h:check()
end

local chufang=1997

function touxue:full()
   local h
	h=hp.new()
	h.checkover=function()
	    --[[print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
		     local w
		     if h.food<50 then
			    print("eat")
			    w=walk.new()
		        w.walkover=function()
		         --world.Send("ask xiao tong about 食物")
			     world.Execute("get ji;get ya;get yuyuan")
			  	 world.Execute("eat ji;eat ji;eat ji;eat ya;eat ya;eat yuyuan;eat yuyuan;drop ji;drop ya;drop yuyuan")
				 local f
				 f=function()
				   self:full()
				 end
				 f_wait(f,1.5)
			   end
			   w:go(chufang) --2707
			    if chufang==1997 then
			      chufang=2707
				else
				  chufang=1997
			    end
			 elseif h.drink<50 then
			   --world.Send("ask xiao tong about 茶")
			    print("drink")
			    w=walk.new()
		        w.walkover=function()
			     world.Execute("get cha")
			  	 world.Execute("drink cha;drink cha;drink cha;drop cha")
				 local f
				 f=function()
				   self:full()
				 end
				 f_wait(f,1.5)
			   end
			    w:go(1992) --299 ask xiao tong about 食物 ask xiao tong about 茶
			 end]]
		if h.qi_percent<=30 or h.jingxue_percent<=80 then
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

		elseif h.neili<(h.max_neili*2-200) then
		    local x
			x=xiulian.new()
			x.safe_qi=300
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun qi")
				  world.Send("yun regenerate")
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
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   if h.neili>h.max_neili*2-200 then
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

function touxue:jobDone()
end

function touxue:Status_Check()
   --[[ local win=window.new() --监控窗体
     win.name="status_window"
	 win:addText("label1","目前工作:慕容偷学")
	 win:addText("label2","目前过程:打坐")
     win:refresh()]]
	   	local ts={
	           task_name="慕容偷学",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    self.win=false
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


