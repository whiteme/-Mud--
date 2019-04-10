--公共quest 模块
quest={
  new=function()
	 local _quest={}
	 setmetatable(_quest,quest)
	 return _quest
  end,
  co=nil,
  path_co=nil,
  list={},
  neili_upper=1.9,
  hama1_try=0,
}
quest.__index=quest
--
function quest:quest_over() --回调
end

function quest:yinyang4()
   wait.make(function()
      local l,w=wait.regexp("乐厚随即将阴阳手的诀窍悉数传授于你，你终于学会了大阴阳手！|乐厚对着你讲了一大堆诀窍，你想了又想，根本不知道他在说些什么...",10)
	  if l==nil then
		 self:quest_over()
	     return
	  end
	  if string.find(l,"根本不知道他在说些什么") then
	      world.Send("set yinyang "..os.date())
		  world.Send("cry")
		  self:quest_over()
	      return
	  end
	  if string.find(l,"你终于学会了大阴阳手") then
	     world.Send("set yinyang 成功")
	     world.Send("laugh")
		 self:quest_over()
	     return
	  end
      wait.time(10)
   end)
end

function quest:yinyang3()
   wait.make(function()
     world.Send("ask le about 阴阳绝技")
     local l,w=wait.regexp("乐厚在你耳边悄悄说了几句话。|乐厚说道：「.*，练武之人如果只是跟着师傅学，是不会有好结果的！」|乐厚说道：「练武要有节制，当心走火入魔。」",5)
     if l==nil then
		self:yinyang3()
		return
	 end
	 if string.find(l,"乐厚在你耳边悄悄说了几句话") then
	    self:yinyang4()
	    return
	 end
	 if string.find(l,"练武之人如果只是跟着师傅学") or string.find(l,"练武要有节制，当心走火入魔") then
	    self:quest_over()
	    return
	 end
	 wait.time(5)
   end)
end

function quest:yinyang2()
  wait.make(function()
    world.Send("ask le about 大阴阳手")
    local l,w=wait.regexp("乐厚说道：「.*，我的大阴阳手绝技，那可是天下武功数一数二的！」",5)
	if l==nil then
	   self:yinyang2()
	   return
	end
	if string.find(l,"那可是天下武功数一数二的") then
	   self:yinyang3()
	   return
	end
	wait.time(5)
  end)
end

function quest:yinyang()
  local w=walk.new()
  w.walkover=function()
     world.Send("ask le about name")
	 wait.make(function()
	   local l,w=wait.regexp("乐厚对你哈哈一笑：乐厚便是大爷我！",5)
	   if l==nil then
	      self:yinyang()
		  return
	   end
	   if string.find(l,"乐厚对你哈哈一笑：乐厚便是大爷我") then
	     self:yinyang2()
	     return
	   end
	   wait.time(5)
	 end)
  end
  w:go(323)
end

function quest:_chen()
  local rooms={1247,1246,1245,1346}
  local i=1
  return function()
     if i>=table.getn(rooms) then
	    i=1
	 else
	    i=i+1
	 end
	 return rooms[i]
  end
end
function quest:tiandihui()
  local r=self:_chen()
  local w2
  w2=walk.new()
  w2.walkover=function()
  --陈近南说道：「这位壮士看来还需要努力一番才行，你现在状态不太适合学习凝血神爪。」
--陈近南往北面的石桥离开。

  --你向陈近南打听有关『凝血神爪』的消息。
    wait.make(function()
        world.Send("ask chen about 凝血神爪")
		local l,w=wait.regexp("^(> |)你向陈近南打听有关『凝血神爪』的消息。$|^(> |)这里没有这个人。$",5)
		if l==nil then
           self:tiandihui()
		   return
		end
		if string.find(l,"这里没有这个人") then
		  w2:go(r())
		  return
		end
		if string.find(l,"你向陈近南打听有关") then
		  self:quest_over()
		  return
		end
	 end)
  end
  --1247
  --1246
  --1346
  w2:go(r())
end

function quest:NextPoint()
    print("进程恢复")
   coroutine.resume(quest.co)
end

function quest:checkPlace(npc,roomno,here)
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
		  w.walkover=function()
		    self:checkNPC(npc,roomno)
		  end
		  w:go(roomno)
	   end
end

function quest:kill_weixiaobao()

end

function quest:checkNPC(npc,roomno)
    wait.make(function()
      world.Execute("look|set look 1")
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
		  self:kill_weixiaobao()
		  return
	  end
	  wait.time(6)
   end)
end

function quest:xiaobao()
  wait.make(function()
      local l,w=wait.regexp("^(> |)韦春芳说道：「这位.*，不瞒您说，我那乖儿子正在(.*)卖兵器呢。」",5)
	  if l==nil then
	     self:weichunhua()
		 return
	  end
	  if string.find(l,"卖兵器") then
	     local location=w[2]
		 local n,rooms=Where(location)
		 local b
		 b=busy.new()
	     b.interval=0.5
	     b.Next=function()
	     quest.co=coroutine.create(function()
	      for _,r in ipairs(rooms) do
             local w
		     w=walk.new()
		     w.walkover=function()
		       self:checkNPC("韦小宝",r)
		     end
		     w:go(r)
		     coroutine.yield()
	       end
		   --print("没有找到npc!!")
		   self:weichunhua()
	     end)
	       self:NextPoint()
	     end
    	 b:check()
		 return
	  end
  end)
end

function quest:weichunhua()
   local w=walk.new()
   w.walkover=function()
      world.Send("ask wei about 韦小宝")
      self:xiaobao()
   end
   w:go(2292)
end

function quest:wudangjianjue()
   --jz_endtime = os.time()
   --jz_diftime = os.difftime (jz_endtime , jz_starttime)/3600
   --jz_diftime1=string.format("%.2f", jz_diftime)
   local w=walk.new()
   w.walkover=function()

	  local gender=world.GetVariable("gender")
	  if gender=="男性" then
	      world.Execute("s;e;s;zhao mao tan")
	  else
	      world.Execute("s;w;s;zhao mao tan")
	  end
      local b
       b=busy.new()
        b.interval=0.3
         b.Next=function()

		if gender=="男性" then
	      world.Execute("n;w")
	    else
	      world.Execute("n;e")
	    end
         world.Execute("n;out;n;find yao chu;s;su;su;su;su;e;give caiyao chu;eu;su;bang song;pa down;pa down;pa down;pa down")
           local b1
       b1=busy.new()
        b1.interval=0.3
         b1.Next=function()
         world.Execute("tiao down")
           local b2
       b2=busy.new()
        b2.interval=0.3
         b2.Next=function()
         world.Execute("enter;look wall;read wall")
           local b4
       b4=busy.new()
        b4.interval=0.3
         b4.Next=function()
           world.Execute("out;jump down;ne")
              local b5
       b5=busy.new()
        b5.interval=0.3
         b5.Next=function()
            self:Execute()
          end
           b5:check()
                 end
                 b4:check()
                 end
                 b2:check()
                 end
                 b1:check()
                 end
                 b:check()
                 end
   w:go(1957)
end

function quest:yitiantulong_ok()
   wait.make(function()
      local l,w=wait.regexp("^(> |)你于目眩神驰之际，随即潜心记忆。。|^(> |)张三丰袍袖一挥，说道:你也下去吧。说罢进了内堂。$",10)
	  if l==nil then
		 world.AppendToNotepad (WorldName().."_自动解谜:",os.date()..": 武当倚天屠龙功！！！\r\n")
	     self:quest_over()
		 return
	  end
	  if string.find(l,"你于目眩神驰之际，随即潜心记忆") then
		 self:yitiantulong_ok()
	     return
	  end
	  if string.find(l,"张三丰袍袖一挥，说道:你也下去吧。说罢进了内堂") then
	     world.AppendToNotepad (WorldName().."_自动解谜:",os.date()..": 武当倚天屠龙功！！！\r\n")
	     self:quest_over()
	     return
	  end

   end)
end

function quest:yitiantulong_wake()
  wait.make(function()
     local l,w=wait.regexp("^(> |)你见大厅中这人身长背厚，步履凝重，正是师父。$",10)
	 if l==nil then
	    self:yitiantulong_sleep()
	    return
	 end
	 if string.find(l,"你见大厅中这人身长背厚，步履凝重，正是师父") then
	    self:yitiantulong_ok()
	    return
	 end

  end)

end

function quest:yitiantulong_sleep()
   local w=walk.new()
   w.walkover=function()
       --[[world.Send("sleep")
	   wait.make(function()
	       local l,w=wati.regexp("^(> |)你往床上一躺，开始睡觉。$",5)
		   if l==nil then
		      self:yitiantulong_sleep()
		      return
		   end
		   if string.find(l,"你往床上一躺，开始睡觉") then

		      return
		   end
	   end)]]
	   self:yitiantulong_wake()
   end
   local gender=world.GetVariable("gender")
   local roomno=2790
   if gender=="男性" then
     roomno=2790
   else
     roomno=3175
   end
   w:go(roomno)

end

function quest:yitiantulong_zhang()
   world.Send("n")
   world.Send("s")
   print("找三丰")
    wait.make(function()
	   local l,w=wait.regexp("^(> |)张三丰大袖一挥,说道:你且退下吧。$",10)
	   if l==nil then
	       self:yitiantulong_zhang()
		   return
	   end
	   if string.find(l,"张三丰大袖一挥,说道:你且退下吧") then
	      self:yitiantulong_sleep()
	      return
	   end
	end)
end

function quest:yitiantulong()

    world.AppendToNotepad (WorldName().."_自动解谜:",os.date()..": 武当倚天屠龙功！！！\r\n")
	shutdown()

	local b=busy.new()
	b.Next=function()
	  world.Send("ask song about 俞岱岩")
	   local f=function()
    --print (utils.msgbox ("开始倚天屠龙！！！！", "Warning!", "ok", "!", 1)) --> ok
    world.Send("nick 倚天屠龙")
	local w=walk.new()
	w.walkover=function()

	   world.Send("l dache")
	   world.Send("l caocong")
	   world.Send("bo 长草")
	    world.Send("get 俞岱岩")
	    local f=function()
	       self:yitiantulong_zhang()
	     end
	    f_wait(f,10)

	end
	w:go(1933)
	end
	   f_wait(f,5)
	end
	b:check()

end

function quest:jiujian()
     world.AppendToNotepad (WorldName().."_自动解谜:",os.date()..": 独孤九剑！！！\r\n")
	   local sp=special_item.new()
       sp.cooldown=function()
	      local w=walk.new()
		  w.walkover=function()
             self:mianbi()

		  end
		   w:go(1537)
       end
   	   local equip={}
	   equip=Split("<获取>火折|<获取>大还丹","|")
       sp:check_items(equip)
end

function quest:fengyi_over()

    wait.make(function()
	   local l,w=wait.regexp("^(> |)你觉得似乎有点心得，可能还需要一些实战来积累经验吧。$|^(> |)你心中竟无半点残渣，这数招使地一气呵成，招招衔接地天衣无缝，完美无.*",5)
	    if l==nil then
		    self:fengyi_over()
		    return
		end
		if string.find(l,"你觉得似乎有点心得") then
		  wait.time(3)
		  self:log_time("fy")
		    world.Execute("out;wield jian;wield sword;break wall;out")
		    self:Execute()
		   return
		end
		if string.find(l,"你心中竟无半点残渣") then

		    wait.time(3)
		    self:log_time("fy")
		    world.Execute("out;wield jian;wield sword;break wall;out")
			world.Send("set quest fengyi")
			world.Send("nick 凤仪")
		    self:Execute()
		   return
		end

	end)
end

function quest:mianbi()
    world.Execute("enter;mianbi")
	--只有晚上能进去
	wait.make(function()
	  local l,w=wait.regexp("^(> |)你忽然产生一种破壁的欲望，不禁站了起来。$",1)
	  if l==nil then
	    self:mianbi()
	    return
	  end
	  if string.find(l,"你忽然产生一种破壁的欲望，不禁站了起来") then
	     wait.time(2)
		 world.Execute("wield jian;wield sword;break wall;enter;use fire;left")
		 wait.time(8)
		 world.Send("zhuomo 有凤来仪")
		 self:fengyi_over()

	     return
	  end

	end)
end

--九阴
local ask_zhou_count=0
function quest:answer_start()
  --ask zhou about 功夫
  wait.make(function()
    world.Send("give zhou fan he")

	--> 这里没有这个人。
	local l,w=wait.regexp("^(> |)这里没有这个人。$|^(> |)你给周伯通一个饭盒。$",5)
	if l==nil then
	   self:answer_start()
	   return
	end
	if string.find(l,"这里没有这个人") then
	   local f=function()
	      self:answer_start()
	   end
	   f_wait(f,5)

	   return
	end
	if string.find(l,"你给周伯通一个饭盒") then

    world.Send("ask zhou about 九阴真经")
	wait.time(3)
    world.Send("ask zhou about 故事")
	wait.time(3)
    world.Send("ask zhou about 后来怎样")
	wait.time(3)
	self:answer_quest()
    world.Send("answer n")
    ask_zhou_count=0
	   return
	end
  end)
end
--  全真教第二代弟子「老顽童」周伯通(Zhou botong)
--我老顽童的自创拳招是什么啊？
local l_zhou=0

function quest:answer_quest()
  wait.make(function()
     local l,w=wait.regexp("^(> |)周伯通说道：「(.*)」$|^(> |)周伯通说道：「你陪我陪了这么久，一定很无聊吧？」$|.*全真教第二代弟子「老顽童」周伯通.*",5)
	 if l==nil then
	    world.Send("look")
		world.Send("ask zhou about 功夫")
		l_zhou=l_zhou+1
		ask_zhou_count=ask_zhou_count+1
		if ask_zhou_count>=50 then
		   print("防止一直ask zhou")
		   self:Execute()
		   return
		end
		if l_zhou>2 then
		     world.Execute("out|enter")
		     self:answer_quest()
		else
		    self:answer_quest()
		end
		--world.Send("set action 九阴")

	    return
	 end
	 if string.find(l,"老顽童") and string.find(l,"全真教第二代弟子") then
	    l_zhou=0
	     self:answer_quest()
		 return
	 end

	 if string.find(l,"周伯通说道") then
	    self:answer_quest()
	    local quest=Trim(w[2])
		local answer=self:answer(quest)
		if answer~="" then
		  world.Send("answer "..answer)
		--else
		  --self:Execute()
		end

	    return
	 end

  end)
end
function quest:answer(quest)
     local answer=""
      if quest=="我全真教的内功心法是什么？" then

			answer = "xiantian-gong"

	  elseif quest=="黄老邪的那厉害指法是什么？" then

			answer = "tanzhi-shentong"

      elseif  quest=="段家有门以指为剑的剑法，叫什么名字？" then
			answer = "liumai-shenjian"

	  elseif  quest=="铁掌帮的著名轻功是？" then
			answer = "shuishangpiao"

	  elseif  quest=="神龙洪老头的暗器是叫做什么？" then
			answer = "hansha-sheying"

	 elseif  quest=="老毒物的奇怪内功是什么？" then
			answer = "hamagong"

	 elseif  quest=="老叫化和郭兄弟都会的掌法是什么？" then
			answer = "xianglong-zhang"

	 elseif  quest=="少林和尚们的内功是什么？" then
			answer = "yijin-jing"

	 elseif  quest=="峨嵋的剑法是什么？" then
			answer = "huifeng-jian"

	 elseif  quest=="武当张老头创出的软绵绵拳法叫什么名字？" then
			answer = "taiji-quan"

     elseif  quest=="明教张无忌那小子的内功是什么？" then
			answer = "jiuyang-shengong"

	 elseif  quest=="星宿派恶名昭彰的功夫是什么？" then
			answer = "huagong-dafa"

	 elseif  quest=="慕容家的家传特殊招架技能是？" then
			answer = "douzhuan-xingyi"

	 elseif  quest=="明教前教主阳顶天练什么功夫练到走火而死的？" then
			answer = "qiankun-danuoyi"

	 elseif  quest=="黄老邪的箫乐是由他的内功而来。这个内功的名字是？" then
			answer = "bihai-chaosheng"

	 elseif  quest=="金蛇郎君夏雪宜的剑法叫什么名称？" then
			answer = "jinshe-jianfa"

	 elseif  quest=="有种剑法，练了使人绝子绝孙。这个剑法的名字是什么？" then
			answer = "pixie-jian"

	 elseif  quest=="华山气宗的镇山之宝是什么？" then
			answer = "zixia-gong"
--[[周伯通说道：「我老顽童的自创拳招是什么啊？」
用 answer 来回答，回答请使用拼音输入，不要用汉字。
周伯通说道：「瑛姑的高明身法是什么？」
answer niqiugong
周伯通说道：「不错不错，有点头脑嘛。」
周伯通指着你赞叹道：“秋猫是武林第一高手！”
周伯通说道：「再来一题吧。」
> 周伯通「嘿嘿嘿」奸笑了几声。
周伯通说道：「注意听好了！」
用 answer 来回答，回答请使用拼音输入，不要用汉字。
周伯通说道：「我老顽童的自创拳招是什么啊？」]]
	 elseif  quest=="我老顽童的自创拳招是什么啊？" then
			answer = "kongming-quan"

	 elseif  quest=="华山剑宗的高级剑法是？" then
			answer = "dugu-jiujian"

	 elseif  quest=="古墓派的内功心法是什么？" then
			answer = "yunu-xinjing"

	 elseif  quest=="我求杨过这小子教我的掌法叫做什么名称？" then
			answer = "anran-zhang"

	 elseif  quest=="一灯大师的拿手绝学是什么？" then
			answer = "yiyang-zhi"

	 elseif  quest=="老叫化教黄蓉那小丫头的是什么拳法？" then
			answer = "xiaoyaoyou"

	elseif  quest=="古墓一派的特殊拳法，叫什么名称？" then
			answer = "meinv-quanfa"

	elseif  quest=="黄老邪除了教杨过弹指神通，还教了什么武功？" then
			answer = "yuxiao-jian"

	elseif  quest=="瑛姑的高明身法是什么？" then
			answer = "niqiugong"

	elseif  quest=="黄蓉的家传手法叫什么名字？" then
			answer = "lanhua-shou"

	elseif  quest=="桃花的狂风绝技要以什么和旋风扫叶腿配合施展？" then
			answer = "luoying-zhang"

	elseif  quest=="峨嵋的灭绝师太曾经以那种功夫将张无忌打的倒地不起？" then
			answer = "jieshou-jiushi"

	elseif quest=="你陪我陪了这么久，一定很无聊吧？" then
		self:log_time("jyu")
		local b=busy.new()
		b.Next=function()
		  shutdown()
	      world.Send("ask zhou about 功夫")
		  self:Execute()
        end
		b:check()
		--answer=""
	end
	return answer
end

function quest:zhoubotong()

end

local taohuazhen_index=1
function quest:catch_taohuazhen(Serial)
  if taohuazhen_index>24 then
    print("走到底了")
	world.Send("enter")
	self:zhoubotong()
    return
  end
  world.Send("look north")
  wait.make(function()
     local l,w=wait.regexp("密密地没有一丝缝隙。$|中间露出一条小径。$|^(> |)草地 -.*",5)
	 if l==nil then
         self:catch_taohuazhen()
  	    return
     end

	 if string.find(l,"草地") then
	   self:taohuazhen()
	   return
	 end
     if string.find(l,"中间露出一条小径") then
	    local zi="断"
		if zi==Serial[taohuazhen_index] then
		   world.Send("north")
		else
		   world.Send("west")
		end
		taohuazhen_index=1+taohuazhen_index
		local f=function()
		   self:catch_taohuazhen(Serial)
	    end
		f_wait(f,0.4)
		return
     end
     if string.find(l,"密密地没有一丝缝隙") then
	   local zi="连"
		if zi==Serial[taohuazhen_index] then
		   world.Send("north")
		else
		   world.Send("west")
		end
		taohuazhen_index=1+taohuazhen_index
		local f=function()
		   self:catch_taohuazhen(Serial)
	    end
		f_wait(f,0.4)
	   return
     end
  end)
end

--断,断,连,连,连,连,断,断,断,连,断,断,断,连,连,连,断,连,连,连,断,断,连,断,
function quest:taohuazhen()
  --[[local w=walk.new()
  w.walkover=function()
  world.Send("look bagua")
  wait.make(function()
    local l,w=wait.regexp("^(> |)一个奇怪的铁八卦，上面按顺时针顺序排列着：(.*)。$",5)
	if l==nil then
	  self:taohuazhen()
	  return
	end
	if string.find(l,"一个奇怪的铁八卦") then
		local key=w[2]
		local code=""
		local codebook={}
		codebook["乾"]={"连","连","连"}
		codebook["坤"]={"断","断","断"}
		codebook["巽"]={"连","连","断"}
		codebook["震"]={"断","断","连"}
		codebook["离"]={"连","断","连"}
		codebook["坎"]={"断","连","断"}
		codebook["艮"]={"连","断","断"}
		codebook["兑"]={"断","连","连"}
		--巽兑坤艮坎震离乾
		local dx={}

		for i=1,16,2 do
		   local c=string.sub(key,i,i+1)
		   print(c)
		   table.insert(dx,codebook[c])
		end
		print("*********")
		for _,i in ipairs(dx) do
		   local steps=""
		   for _,g in ipairs(i) do
		      steps=steps..g..","
		   end
		   print(steps)
		   code=code..steps
		end
		code=string.sub(code,1,-1)
		print(code)
		local Serial={}
		Serial=Split(code,",")
		local w=walk.new()
		w.walkover=function()
		   world.Send("west")
		   --world.Send("look")
		   taohuazhen_index=2
           self:catch_taohuazhen(Serial)
		end
		w:go(2824)
	   return
	end
  end)
  end
  w:go(2808)]]

  local w=walk.new()
  w.walkover=function()
     world.Send("west")
     world.Execute("#10 s")
	 local f=function()
	   world.Execute("#13 s")
	   world.Send("enter")
	   self:zhoubotong()
	 end
	 f_wait(f,0.8)
  end
  w:go(2824)

end

--结拜

function quest:zhou_ask(ask_cmd,marcocmd)

  world.Send(ask_cmd)
		  --这里没有这个人。
  wait.make(function()
		     local l,w=wait.regexp("^(> |)这里没有这个人。$|^(> |)你向周伯通打听有关.*$",5)
			 if l==nil then
			    self:zhou_ask(ask_cmd,marcocmd)
			    return
			 end
			 if string.find(l,"你向周伯通打听有关") then
				   marco(marcocmd)
			       local b1=busy.new()
				   b1.interval=5
		           b1.Next=function()

        			   self:Execute()
			       end
				   b1:check()
			     return
			 end

			if string.find(l,"这里没有这个人") then
			    wait.time(4)
			    self:zhou_ask(ask_cmd,marcocmd)
			   return
			end
  end)
end

function quest:jiebai(manual_operate)
    local q_record=self:get_log_time("jiebai")
	local last_jiebai_time=q_record.quest_time
	local jiebai_time=os.time()

	local interval=os.difftime(jiebai_time,last_jiebai_time)
	print(interval,":秒","和周伯通时间间隔")
  if interval>3600*24 or manual_operate==true then
     self.zhoubotong=function()
		  --world.SetVariable("last_jiebai_time",jiebai_time)
		  self:log_time("jiebai")
		  print("找周伯通结拜")
		  self:zhou_ask("ask zhou about 结拜","#wa 3000|ask zhou about 左右互搏|#wa 3000|#30 hua fang yuan")
	 end
     self:taohuazhen()
  else
     self:Execute()
  end
end


function quest:kmq(manual_operate)
    local q_record=self:get_log_time("kmq")
	local last_kmq_time=q_record.quest_time
	local kmq_time=os.time()

	local interval=os.difftime(kmq_time,last_kmq_time)
	print(interval,":秒","空明拳总决时间间隔")
  if interval>3600*24 or manual_operate==true  then
     self.zhoubotong=function()
		  --world.SetVariable("last_jiebai_time",jiebai_time)
           self:log_time("kmq")
		  self:zhou_ask("ask zhou about 空明拳总决","say bye")
		  --你向周伯通打听有关『空明拳总决』的消息。



	 end
     self:taohuazhen()
  else
     self:Execute()
  end
end

--杨家枪
function quest:yangjiaqiang()
    local q_record=self:get_log_time("yangjiaqiang")
	local last_yangjiaqiang_time=q_record.quest_time
	local yangjiaqiang_time=os.time()

	local interval=os.difftime(yangjiaqiang_time,last_yangjiaqiang_time)
	print(interval,":秒","杨家枪时间间隔")
  if interval>3600*24 and q_record.success==0 then
    local w=walk.new()
    w.walkover=function()
      world.Execute("n;n")

	   local b=busy.new()
	   b.Next=function()
		  world.Send("ask yang about 杨家枪")
	      --world.SetVariable("last_yangjiaqiang_time",yangjiaqiang_time)
		   self:log_time("yangjiaqiang")
		  local f=function()
		    world.Execute("s;s")
	        self:Execute()
		  end
		  f_wait(f,30)
	   end
	   b:check()
    end
    w:go(1836)
  else
     self:Execute()
  end
end

local path_redo_finish=function()
   --回调函数
end

local function path_redo(path,cmd)
   local P=Split(path,";")
  local count=0
   quest.path_co=coroutine.create(function()
      for _,g in ipairs(P) do
	    world.Send(cmd)
		world.Send(g)
		if count>=10 then
		  count=0
		  local f=function()
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     coroutine.resume(quest.path_co)
		   end
		   b:check()
		  end
		  f_wait(f,1)
		  coroutine.yield()
        else
		  count=count+1
		end
	  end
	  quest.path_co=nil
	  path_redo_finish()
  end)
  coroutine.resume(quest.path_co)
end
--千蛛万毒手
function quest:qzwds()
  local w=walk.new()
  w.walkover=function()
     local cmd="ask yin about 千蛛万毒手"
	 local path="ne;e;e;e;e;e;w;n;s;e;w;n;w;n;s;s;s;s;sw;ne;n;n;n;w;s;e;n;n;e;e;w;w;w;w;e;e;n;n;e;nw;sw;e;n;nd;nd;nd;wd;sd;e;se;nw;w;w;sd;sw;ne;nu;w;w;wd;wu;nu;wu"
	 path_redo(path,cmd)
  end
  w:go(2830)
end
--- 9yd
function quest:jyd()
    local q_record=self:get_log_time("jyd")
	local last_jyd_time=q_record.quest_time
	local jyd_time=os.time()
	local interval=os.difftime(jyd_time,last_jyd_time)
	print(interval,":秒","九阴下时间间隔")
  if interval>3600*24 and q_record.success==0 then
   local w=walk.new()
   w.walkover=function()
        local _R
	  _R=Room.new()
	  _R.CatchEnd=function()
		local count,roomno=Locate(_R)
		print("当前房间号",roomno[1])
		if roomno[1]==1705 then
			world.Send("enter")
            world.Send("kill mei")
	        world.Send("kill chen")
	        local _pfm=world.GetVariable("quest_pfm") or ""
	        local f=function()
	            self:Execute()
	        end
	        self:fight(_pfm,f)
		else
			self:jyd()
		end
	  end
	 _R:CatchStart()
   end
   w:go(1705)
  else
    self:Execute()
  end
end

function quest:jyu2()
    local b2=busy.new()
	 b2.Next=function()
	  local w1=walk.new()
	  w1.walkover=function()
	     world.Send("ask huang about 周伯通")
		 local bb=busy.new()
		 bb.Next=function()
		    self.zhoubotong=function()
               self:answer_start()
            end
		    self:taohuazhen()
		 end
		 bb:check()
	  end
	  w1:go(2803)
	 end
	 b2:check()
end
--- 9yu
function quest:jyu()
    local q_record=self:get_log_time("jyu")
	local last_jyu_time=q_record.quest_time
	local jyu_time=os.time()

	local interval=os.difftime(jyu_time,last_jyu_time)
	print(interval,":秒","九阴上时间间隔")
  if interval>3600*24 and q_record.success==0 then
   local w=walk.new()
   w.walkover=function()
     world.Send("ask huang about 周伯通")
	 wait.make(function()
	    local l,w=wait.regexp("^(> |)你向黄药师打听有关『周伯通』的消息。$",5)
		if l==nil then
		    self:jyu()
		   return
		end
		if string.find(l,"你向黄药师打听有关") then
		    self:jyu2()
		    return
		end
	 end)

   end
   w:go(2814)
  else
    self:Execute()
  end
end

--- 金刀黑剑
function quest:jindaoheijian()
    local q_record=self:get_log_time("jindaoheijian")
	local last_jindaoheijian_time=q_record.quest_time
	local jindaoheijian_time=os.time()

	local interval=os.difftime(jindaoheijian_time,last_jindaoheijian_time)
	print(interval,":秒","金刀黑剑时间间隔")
  if interval>3600*24 and q_record.success==0 then
   local w=walk.new()
   w.walkover=function()

      world.Send("ask gongsun about 金刀黑剑")
	   local b=busy.new()
	   b.Next=function()
	      --world.SetVariable("last_jindaoheijian_time",jindaoheijian_time)
	      self:log_time("jindaoheijian")
		  self:Execute()
	   end
	   b:check()
   end
   w:go(2998)
  else
    self:Execute()
  end
end

--金蛇3
function quest:jsjf()
    local q_record=self:get_log_time("jsjf")
	local last_jsjf_time=q_record.quest_time
	local jsjf_time=os.time()

	local interval=os.difftime(jsjf_time,last_jsjf_time)
	print(interval,":秒","金蛇剑法时间间隔")
	if interval>3600*24 and q_record.success==0 then
     local w=walk.new()
      w.walkover=function()
        --world.Send("ask xia about 秘诀")
		--world.Execute("|n|ask xia xueyi about 秘诀|w|ask xia xueyi about 秘诀|s|ask xia xueyi about 秘诀|eu|ask xia xueyi about 秘诀|wd|ask xia xueyi about 秘诀|n|ask xia xueyi about 秘诀|e|ask xia xueyi about 秘诀|n|ask xia xueyi about 秘诀|enter|ask xia xueyi about 秘诀|out|ask xia xueyi about 秘诀|s|ask xia xueyi about 秘诀|e|ask xia xueyi about 秘诀")
		path_redo_finish=function()
		  local b=busy.new()
		  b.Next=function()
		  --world.SetVariable("last_jsjf_time",jsjf_time)
		   self:log_time("jsjf")
	       self:Execute()
		  end
		  b:check()
		end
		local cmd="ask xia xueyi about 秘诀"
		local path="wd;n;e;n;enter;out;s;e;s;e;s;w;s;eu"
		  -- local dx={"wd","n","e","n","enter","out","s","e","s","e","s","w","s","eu"}
		path_redo(path,cmd)

      end
      w:go(2654)
   else
      print("next")
      self:Execute()
   end

end
--冰蚕

function quest:bingcan3()
   local w=walk.new()
   w.walkover=function()
      local b=busy.new()
	  b.Next=function()
	    world.Send("shenshou wa weng")
		local f=function()
	    self:Execute()
		end
		f_wait(f,20)
	  end
	  b:check()
   end
   w:go(134)
end

function quest:bingcan2()
    local w=walk.new()
	w.walkover=function()
	    wait.time(2)
		world.Send("open xiaobao")
		wait.time(2)
		world.Send("ask zi about 瓦瓮")
	    self:bingcan3()
	end
	w:go(1964)
end

function quest:bingcan()
--
    local q_record=self:get_log_time("bingcan")
    local last_bingcan_time=q_record.quest_time
	local bingcan_time=os.time()

	local interval=os.difftime(bingcan_time,last_bingcan_time)
	print(interval,":秒","冰蚕时间间隔")
	if interval>24*3600 and q_record.success==0 then

      local w=walk.new()
     w.walkover=function()
        world.Send("search 草丛")
	    wait.make(function()
	      local l,w=wait.regexp("^(> |)你来晚了，油布小包已经给人取走了。$|^(> |)你拨了拨周围的草丛，忽见左首草丛中有个油布小包,当即拾起。$|^(> |)你拨了拨草丛，并没有别的什么发现，不禁有些怅然。$",5)
		  if l==nil then
		      self:bingcan()
			  return
		  end
		  if string.find(l,"你来晚了") then
			  self:Execute() --执行
		     return
		  end
	      if string.find(l,"忽见左首草丛中有个油布小包") or string.find(l,"不禁有些怅然") then
             --world.SetVariable("last_bingcan_time",bingcan_time)
			 self:log_time("bingcan")
 			 self:bingcan2()
		     return
		  end
	   end)
	   --你来晚了，油布小包已经给人取走了。
     end
     w:go(3996)
	else
	 self:Execute()
   end
end

--自动疗伤

function quest:Status_Check()
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
			        rc:qudu(sec,i[1],false)
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
			        rc:heal(true,true)
				    return
				 end

			   end
		     end
			--self:xuli()
            self:full()
	end
	cd:start()
end

function quest:full()
	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 local qi_percent=world.GetVariable("qi_percent") or 100
	 qi_percent=assert(tonumber(qi_percent),"qi_percent变量必须输入数字！") or 100
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
		elseif (h.qi_percent<=liao_percent or h.jingxue_percent<=80) and heal_ok==false then
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
			    world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    heal_ok=false --复位
		    local x
			x=xiulian.new()
			x.min_amount=10
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
				  world.Send("yun recover")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
			    end
				if id==777 then
				   f=function()
				     heal_ok=false
   				     self:Status_Check()
				   end  --外壳
				   f_wait(f,0.5)
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(126)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			      self:auto_ask()
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
			  self:auto_ask()
			end
			b:check()
		end
	end
	h:check()
end

function quest:quest_ask()
	local quests={
	pearl="00 兑换珍珠",
    bingcan="01 星宿冰蚕",
	hjdf="02-1 胡家刀法",
	mjjf="02-2 苗家剑法",
	bz="02-3 冷泉神功",
	djrh="02-4 刀剑融合",
	jsjf="03 金蛇步",
	yjq="04 杨家枪",
	jianjue="05-1 全真剑诀",
	dingyang="05-2 全真定阳针",
	jiebai="06-1 周伯通结拜",
	jyu="06-2 九阴上",
	 jyd="06-3 九阴下",
	 jdhj="07 金刀黑剑",
	 szj="08-1 神照经1",
	 szj2="08-2 神照经2",
	 lbwb="09 凌波微步",
	 hama1="10 蛤蟆1",
	 qzwds="11 千蛛万毒手",
	 yuenvjian="12 越女剑",
	 kh="13 葵花宝典",
	 gmhb="14-1 古墓互搏",
	 gmjy="14-2 古墓九阴",
	 gmsk="14-3 古墓石刻",
	  guess="15 猜数字",
	  nxsz="16 凝血神爪",
	  sxbf="17 四象步法",
	  zzr="18 寻找周芷若",
      hrz="19 全真昊然掌",
	  nqg="20 泥鳅功",
      jgys="21 先天功金关玉锁",
	  jjs="22 华山截剑式",
	   xxdfrg="23 吸星大法融合",
	   arz="24 黯然掌",
	   lxg="25 龙象功",
	   gw="26 嵩山飞舞",
	   jianqi="27 全真剑气",
	   kmq="28 空明拳总决",
	   yyz="29 一阳指",
	   yysz="30 一阳指书",
	   tz="31 铁掌掌刀",
	   zl="32 珍珑棋局",
	   hyd="33 火焰刀绝技",
	   fy="34 有凤来仪",
	   taiji="35 武当绝世",

  }
  local select_quest=utils.listbox ("解谜", "手动选择解谜", quests)
  if select_quest then
    local _qlist={}
	 _qlist["pearl"]=function() self:get_pearl(94) end
    _qlist["bingcan"]=function() self:bingcan(true) end
	_qlist["hjdf"]=function() self:hujiadaofa(true) end
    _qlist["jsjf"]=function() self:jsjf(true) end
	_qlist["yjq"]=function() self:yangjiaqiang(true) end
	_qlist["jianjue"]=function() self:jianjue(true) end
	_qlist["dingyang"]=function() self:qz_dingyang(true) end
	_qlist["jiebai"]=function() self:jiebai(true) end
	_qlist["lbwb"]=function() self:lbwb(true) end
	_qlist["mjjf"]=function() self:miaojiajianfa(true) end
	_qlist["djrh"]=function() self:rh(true) end
	_qlist["jdhj"]=function() self:jindaoheijian(true) end
	_qlist["hama1"]=function() self:hama1(true) end
	_qlist["bz"]=function() self:baozang(true) end
	_qlist["szj2"]=function() self:szj2(true) end
	_qlist["szj"]=function() self:szj(true) end
	_qlist["guess"]=function() self:ask_question() end
	_qlist["jyu"]=function() self:jyu(true) end
	_qlist["jyd"]=function() self:jyd(true) end
    _qlist["kh"]=function() self:kuihua(true) end
    _qlist["qzwds"]=function() self:qzwds(true) end
	_qlist["yuenvjian"]=function() self:yuenvjian(true) end
	_qlist["gmhb"]=function() self:gumu_yufengzhen(true) end
	_qlist["nxsz"]=function() self:nxsz(true) end
	_qlist["sxbf"]=function() self:sxbf(true) end
	_qlist["zzr"]=function() self:zzr(true) end
	_qlist["gmsk"]=function() self:gumu_shike(true) end
	_qlist["gmjy"]=function() self:gumu_jiuyin(true) end
	_qlist["hrz"]=function() self:qz_haotian_lianhuan(true) end
	_qlist["nqg"]=function() self:nqg_start(true) end
	_qlist["jgys"]=function() self:qz_jgys(true) end
	_qlist["jjs"]=function() self:hs_jjs_start(true) end
	_qlist["xxdfrg"]=function() self:ronggong(true) end
	 _qlist["arz"]=function() self:arz_start(true) end
	 _qlist["lxg"]=function() self:dls_longxiang(true) end
	 _qlist["gw"]=function() self:ss_guanwu_songtao_start(true) end
	 _qlist["jianqi"]=function() self:qixingjian(true) end
	 _qlist["kmq"]=function() self:kmq(true) end
	 _qlist["yyz"]=function() self:yyz(true) end
	 _qlist["yysz"]=function() self:yysz(true) end
	 _qlist["tz"]=function() self:tiezhang_zhangdao(true) end
	 _qlist["zl"]=function() self:zhenlong(true) end
	 _qlist["hyd"]=function() self:dls_hyd(true) end
     _qlist["fy"]=function() self:hs_fengyi(true) end
	 _qlist["taiji"]=function() self:taiji(true) end

	local exe_quest=_qlist[select_quest]
	 exe_quest()
  else

  end
end

function quest:auto_ask(callback)
     local q_list=world.GetVariable("quest_list") or ""
     self.list=Split(q_list,"|")
   local _qlist={}
    _qlist["星宿冰蚕"]=function() self:bingcan() end
	_qlist["胡家刀法"]=function() self:hujiadaofa() end
    _qlist["jsjf"]=function() self:jsjf() end
	_qlist["杨家枪"]=function() self:yangjiaqiang() end
	_qlist["jianjue"]=function() self:jianjue() end
	_qlist["dingyang"]=function() self:qz_dingyang() end
	_qlist["周伯通结拜"]=function() self:jiebai() end
	_qlist["凌波微步"]=function() self:lbwb() end
	_qlist["苗家剑法"]=function() self:miaojiajianfa() end
	_qlist["刀剑融合"]=function() self:rh() end
	_qlist["蛤蟆1"]=function() self:hama1() end
	_qlist["冷泉神功"]=function() self:baozang() end
	_qlist["神照经2"]=function() self:szj2() end
	_qlist["神照经1"]=function() self:szj() end
    _qlist["葵花宝典"]=function() self:kuihua() end
    _qlist["千蛛万毒手"]=function() self:qzwds() end
	_qlist["越女剑"]=function() self:yuenvjian() end
	_qlist["九阴上"]=function() self:jyu() end
	_qlist["九阴下"]=function() self:jyd() end
	_qlist["凝血神爪"]=function() self:nxsz() end
	_qlist["sxbf"]=function() self:sxbf() end
    _qlist["刀剑融合"]=function() self:rh() end

	--门派quest
   _qlist["嵩山飞舞"]=function() self:ss_guanwu_songtao_start() end

   _qlist["武当套月"]=function() self:wd_taoyue_start() end

   _qlist["华山截剑式"]=function() self:hs_jjs_start() end

   _qlist["星宿海底捞月"]=function() self:xx_laoyue_start() end

   _qlist["泥鳅功"]=function() self:nqg_start() end

   _qlist["金刀黑剑"]=function() self:jdhj_start() end

   _qlist["黯然掌"]=function() self:arz_start() end
   _qlist["天魔绝掌"]=function() self:tianmo() end
   _qlist["吸星大法融功"]=function() self:ronggong() end
   _qlist["千变万化"]=function() self:qbwh() end
   _qlist["无形剑"]=function() self:wxj() end
   _qlist["漫天花雨"]=function() self:huayu() end
   _qlist["天魔绝刀"]=function() self:juedao() end
   _qlist["昊天掌连环"]=function() self:qz_haotian_lianhuan() end
   _qlist["先天功金关玉锁"]=function() self:qz_jgys() end
   _qlist["龙象般若功"]=function() self:dls_longxiang() end
   _qlist["全真剑气"]=function() self:qixingjian() end
   _qlist["空明拳总决"]=function() self:kmq() end
    _qlist["一阳指"]=function() self:yyz() end
	 _qlist["一阳指书"]=function() self:yyzs() end
	 _qlist["铁掌掌刀"]=function() self:tiezhang_zhangdao() end
	 _qlist["珍珑棋局"]=function() self:zhenlong() end
	  _qlist["火焰刀绝技"]=function() self:dls_hyd() end
	  _qlist["有凤来仪"]=function() self:hs_fengyi() end
	   _qlist["武当绝世"]=function() self:taiji() end

	--self:success_msg()
	 quest.co=coroutine.create(function()
	    for _,v in ipairs(self.list) do
	       print("开始自动解谜:",v)
		   local f=_qlist[v]  --函数
		   f()
           --print("暂停")
	       coroutine.yield()
	    end
		--print("回调2")
		quest.co=nil
		if callback~=nil then
		  callback() --回调
		end
	end)
	self:Execute()
end

function quest:Execute()
   local b=busy.new()
   b.Next=function()
      if quest.co~=nil then
	    coroutine.resume(quest.co)
	  end
   end
   b:check()
end

function quest:get_pearl(roomno,callback,count)
    if count==nil then
	   count=0
	else
	   count=count+1 --防止过多购买珍珠

	   if count>5 then
	     local b=busy.new()
		 b.Next=function()
			world.Send("pray pearl")
			self:auto_ask(callback)
		 end
		 b:check()
	   end
	end
    local w=walk.new()
	  w.walkover=function()
	    if roomno==94 then
	     world.Send("qu pearl")
		else
		 world.Send("duihuan pearl")
		end
		 --world.Send("pray pearl")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)你并没有保存该物品。$|^(> |)你把幸运珍珠从个人储物箱中提取出来。$|^(> |)当铺老板吆喝一声：“.*兑换限制级宝物幸运珍珠，收讫.*个书剑通宝。”$",8)
			if l==nil then
			   self:get_pearl(roomno,callback,count)
			   return
			end
			if string.find(l,"储物箱中提取出来") or string.find(l,"兑换") then
				local b=busy.new()
		        b.Next=function()
				   world.Send("pray pearl")
                   callback()
				end
		        b:check()
			   return
			end
			if string.find(l,"你并没有保存该物品") then
			   self:get_pearl(84,callback,count)
			   return
			end
		 end)
	  end
	  w:go(roomno)
end

function quest:auto_check(callback)
   local Quest=self:group_time()
   local auto_ask_time=Quest.quest_time
   local t1=os.time()
   if os.difftime(t1,auto_ask_time)>=86400 and Quest.success==0 then
   -- 拿珍珠
      local do_quest=function() self:auto_ask(callback) end
	  self:get_pearl(94,do_quest)
	else
	   callback()
	end
end

function quest:zzr()
--清音阁开始   {山坡( 周芷若):sw;#2 s;sw;wu;sw;wu;sw;#2 enter;use fire;e;s;w;n;ne;se;sw;nw;out
  local w=walk.new()
  w.walkover=function()
      world.Execute("sw;#2 s;sw;wu;sw;wu;sw;#2 enter;use fire;e;s;w;n;ne;se;sw;nw;out")
  end
  w:go(669)
end


function quest:ask_jianjue()

--我现在无法看见天空中北斗七星，又如何指导你学习全真剑法的剑诀精髓。
--你的剑诀造诣已经不在本道之下了，又何故开此玩笑呢？
    local w=walk.new()
	w.walkover=function()
	    world.Send("ask qiu about 剑诀")
		local l,w=wait.regexp("^(> |)丘处机说道：「我现在无法看见天空中北斗七星，又如何指导你学习全真剑法的剑诀精髓。」$|^(> |)丘处机说道：「嗯？你不是刚来请教过我剑诀吗？还是再努力段时间吧！」$|^(> |)丘处机严肃的看着你，慢慢说道：“我派的全真剑法讲究的是道家观测宇宙星斗北斗七星变换之道，取千变万化、无穷无尽之原理，$|^(> |)^(> |)丘处机说道：「嗯？你不是刚来请教过我剑诀吗？还是再努力段时间吧！」$|^(> |)丘处机说道：「.*，你的剑诀造诣已经不在本道之下了，又何故开此玩笑呢？」$",5)
	    if l==nil then
		   self:ask_jianjue()
		   return
		end
		if string.find(l,"又如何指导你学习全真剑法的剑诀精髓") then
		    wait.time(1.5)
			world.Send("unset 积蓄")
		    process.neigong3()
			local f=function()
			    shutdown()
				local b=busy.new()
				b.Next=function()
				   self:ask_jianjue()
				end
				b:check()
			end
			f_wait(f,30)
		    return
		end
		if string.find(l,"还是再努力段时间吧") then
		   local f=function()
			   self:Execute()
			end
			f_wait(f,3)
			return
		end
		if string.find(l,"取千变万化、无穷无尽之原理") then
		   local b=busy.new()
		   b.Next=function()
		    world.Send("qingjiao")
			local f=function()
			   self:Execute()
			end
			f_wait(f,20)
		   end
		   b:check()
		    return
		end
		if string.find(l,"你的剑诀造诣") then
		 --local b=busy.new()
		   --b.Next=function()
		     self:Execute()
		   --end
		   --b:check()
		    return
		end
	end
	w:go(4152)
end

function quest:ask_yiyangzhi()
	local w=walk.new()
	w.walkover=function()
	    world.Send("give yideng lingwen")
		local f=function()
	      world.Send("ask yideng about 一阳指")
		  local f=function()
		  --local b=busy.new()
		  --b.Next=function()
		     self:Execute()
		  --end
		  --b:check()
		  end
		  f_wait(f,20)
		end
		f_wait(f,3)

	end

      w:go(2740)
end

function quest:jianjue()
   local q_record=self:get_log_time("jianjue")
  local last_quanzhen_time
	last_quanzhen_time=q_record.quest_time

	local quanzhen_time=os.time()

	local interval=os.difftime(quanzhen_time,last_quanzhen_time)
	print(interval,":秒","全真解谜时间间隔")
	if interval>24*3600 and q_record.success==0 then
	 -- local w=walk.new()
	 -- w.walkover=function()
	  -- world.Send("duihuan pearl")
	   --world.Send("pray pearl")
	    --world.SetVariable("last_quanzhen_time",quanzhen_time)
	   self:log_time("jianjue")
       self:qzjj()
	  --end
	  --w:go(84)
	else
	 self:Execute()
   end
end

function quest:qz_dingyang()
   local q_record=self:get_log_time("dingyang")
  local last_quanzhen_time
	last_quanzhen_time=q_record.quest_time

	local quanzhen_time=os.time()

	local interval=os.difftime(quanzhen_time,last_quanzhen_time)
	print(interval,":秒","全真解谜时间间隔")
	if interval>24*3600 and q_record.success==0 then
	 -- local w=walk.new()
	 -- w.walkover=function()
	  -- world.Send("duihuan pearl")
	   --world.Send("pray pearl")
	    --world.SetVariable("last_quanzhen_time",quanzhen_time)
	   self:log_time("dingyang")
       self:ask_yiyangzhi()
	  --end
	  --w:go(84)
	else
	 self:Execute()
   end
end

function quest:qzjj() --全真剑诀

   local w=walk.new()
   w.walkover=function()
    world.Send("ketou 宝剑")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)你走向前去，恭恭敬敬的拔出七星宝剑。$",5)
	  if l==nil then
	     self:qzjj()
	     return
	  end
	  if string.find(l,"七星宝剑") then
	    local f=function()
	      self:ask_jianjue()
		end
		f_wait(f,2)
	     return
	  end
	end)
   end
   w:go(5014)
end

function quest:dingyang()
--fankan 道藏经典
--give dashi lingwen

  wait.make(function()
     world.Send("ketou")
	 wait.time(1.5)
	 world.Send("fankan 道藏经典")

     local l,w=wait.regexp("^(> |)你随意的翻看了几页，都是玄门温养丹鼎之法，你只觉得云里雾里，不甚了解，索然无味。$|^(> |)你连忙将密笈收好。$",5)
	 if l==nil then
		self:dingyang()
	    return
	 end
	 if string.find(l,"不甚了解，索然无味") then
	    wait.time(1)
	    self:dingyang()
	    return
	 end
	 if string.find(l,"你连忙将密笈收好") then
	     self:ask_jianjue()
	     return
	  end

  end)
end

function quest:tiashan()
   wait.make(function()
     local l,w=wait.regexp("^(> |)你慌不择路，见那里树林茂密，便钻了进去。奔了将近两个时辰，竟丝毫不累。$|^(> |)山谷.*",10)
	 if l==nil then
	    world.Send("l")
		self:tianshan()
		return
	 end
	 if string.find(l,"丝毫不累") then
        local f=function()
		   self:Execute()
		end
		f_wait(10)
	    return
	 end

   end)
end

function quest:yuxiang()
  self:log_time("lbwb")
  local w=walk.new()
  w.walkover=function()
      world.Send("ketou yuxiang")
	  world.Send("l left")
	  world.Send("l right")
	  local f=function()
	      marco("#20 ketou yuxiang|#wa 3000|#10 fan bo juan|#wa 3000|#10 read bo juan")

		  local f2=function()
		     world.Send("look picture")
			 local b=busy.new()
			 b.Next=function()
			   world.Send("yanjiu picture")
			   local f=function()
			     self:Execute()
			   end
			   f_wait(f,5)
			 end
			 b:check()
		  end
		  f_wait(f2,4)
	  end
	  f_wait(f,3)
  end
   w:go(5016)
end

function quest:lbwb(manual_operate)
    local q_record=self:get_log_time("lbwb")
    local last_lbwb_time=q_record.quest_time
	--local manual_operate=world.GetVariable("quest_manual") or false
	local lbwb_time=os.time()

	local interval=os.difftime(lbwb_time,last_lbwb_time)
	print(interval,":秒","凌波微步时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
     local w=walk.new()
	 local al=alias.new()
	 w.user_alias=al
	 al.noway=function()
	    self:Execute()
	 end
     w.walkover=function()
        world.Execute("jump down;pa yabi;gou feng")

	    self:yuxiang()
     end
     w:go(2852)
   else
      self:Execute()
   end
end

function quest:rh(manual_operate)
	local q_record=self:get_log_time("djrh")
    local last_djrh_time=q_record.quest_time
	local djrh_time=os.time()

	local interval=os.difftime(djrh_time,last_djrh_time)
	print(interval,":秒","刀剑融合时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	 -- world.SetVariable("djrh_time_time",djrh_time)
	 self:log_time("djrh")
	 local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
         world.Execute("w;n")
		 DoAfter(2,"ask miao about 刀剑融合")
		 local f=function()
		    self:Execute()
		 end
		 f_wait(f,8)
		end
		b:check()
     end
     w:go(1568)
  else
     self:Execute()
  end
end

function quest:szj(manual_operate)
    local q_record=self:get_log_time("szj")
    local last_szj_time=q_record.quest_time
	local szj_time=os.time()

	local interval=os.difftime(szj_time,last_szj_time)
	print(interval,":秒","神照经时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)
	  self:log_time("szj")
    local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
		 DoAfter(1,"ask ding about 神照经")
		 local f=function()
		    self:Execute()
		 end
		 f_wait(f,4)

		end
		b:check()
     end
     w:go(973)
  else
     self:Execute()
  end
end

function quest:szj2(manual_operate)
    local q_record=self:get_log_time("szj2")
    local last_szj2_time=q_record.quest_time
	local szj2_time=os.time()

	local interval=os.difftime(szj2_time,last_szj2_time)
	print(interval,":秒","神照经2时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)
	  self:log_time("szj2")
    local w=walk.new()
     w.walkover=function()
		 world.Send("tiao down")
		 local b=busy.new()
		 b.Next=function()
		   DoAfter(1,"ask di yun about 神照经")
		   local f=function()
		     self:Execute()
		   end
		   f_wait(f,4)
         end
		 b:check()
     end
     w:go(1660)
  else
     self:Execute()
  end
end

function quest:hujiadaofa(manual_operate)
local q_record=self:get_log_time("hjdf")
    local last_hjdf_time=q_record.quest_time
	local hjdf_time=os.time()

	local interval=os.difftime(hjdf_time,last_hjdf_time)
	print(interval,":秒","胡家刀法时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)

	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			     local f=function()
				    self:hujiadaofa(manual_operate)
				 end
			     f_wait(f,10)
			     return
			  end
			end
			self:log_time("hjdf")
            local w=walk.new()
            w.walkover=function()
	         local b=busy.new()
		      b.Next=function()
		        DoAfter(1,"ask hu about 胡家刀法")
		       local f=function()
		          self:Execute()
		        end
		        f_wait(f,30)

		      end
			  b:check()
            end
             w:go(732)
		 else
		     self:log_time("hjdf")
            local w=walk.new()
            w.walkover=function()
	         local b=busy.new()
		      b.Next=function()
		        DoAfter(1,"ask hu about 胡家刀法")
		       local f=function()
		          self:Execute()
		        end
		        f_wait(f,30)

		      end
			  b:check()
            end
             w:go(732)
		 end
	   end
	   cd:start()

  else
     self:Execute()
  end


end

function quest:sxbf(manual_operate)
    local q_record=self:get_log_time("sxbf")
    local last_sxbf_time=q_record.quest_time
	local sxbf_time=os.time()

	local interval=os.difftime(sxbf_time,last_sxbf_time)
	print(interval,":秒","四象步法时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)
	  self:log_time("sxbf")
    local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
		 DoAfter(1,"ask hu about 四象步法")
		 DoAfter(5,"ask hu about 飞天神行")
		 local f=function()
		    self:Execute()
		 end
		 f_wait(f,10)

		end
		b:check()
     end
     w:go(732)
  else
     self:Execute()
  end
end

--突然从角落里跳出一个人，施岳对着你嚷道：“我就是黑风寨寨主，赶快离开大草原。”
function quest:miaojiajianfa(manual_operate)
    local q_record=self:get_log_time("mjjf")
    local last_mjjf_time=q_record.quest_time
	local mjjf_time=os.time()

	local interval=os.difftime(mjjf_time,last_mjjf_time)
	print(interval,":秒","苗家剑法时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)
	  self:log_time("mjjf")
    local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
         world.Execute("w;n")
		 DoAfter(2,"ask miao about 苗家剑法")
		 local f=function()
		    self:Execute()
		 end
		 f_wait(f,30)

		end
		b:check()
     end
     w:go(1568)
  else
     self:Execute()
  end
end

function quest:nxsz(manual_operate)
	local q_record=self:get_log_time("nxsz")
	local last_nxsz_time=q_record.quest_time
	local nxsz_time=os.time()

	local interval=os.difftime(nxsz_time,last_nxsz_time)
	print(interval,":秒","凝血神爪时间间隔")
	if (interval>3600*24 and q_record.success==0) or manual_operate==true then
     local w=walk.new()
      w.walkover=function()
        --world.Send("ask xia about 秘诀")
				--world.Execute("|n|ask xia xueyi about 秘诀|w|ask xia xueyi about 秘诀|s|ask xia xueyi about 秘诀|eu|ask xia xueyi about 秘诀|wd|ask xia xueyi about 秘诀|n|ask xia xueyi about 秘诀|e|ask xia xueyi about 秘诀|n|ask xia xueyi about 秘诀|enter|ask xia xueyi about 秘诀|out|ask xia xueyi about 秘诀|s|ask xia xueyi about 秘诀|e|ask xia xueyi about 秘诀")
		path_redo_finish=function()
		  --world.Execute("|w|ask chen about 凝血神爪|s|ask chen about 凝血神爪|e|ask chen about 凝血神爪|w|ask chen about 凝血神爪|n|ask chen about 凝血神爪|n|ask chen about 凝血神爪|n|ask chen about 凝血神爪|e|ask chen about 凝血神爪|w|ask chen about 凝血神爪|w|ask chen about 凝血神爪|s|ask chen about 凝血神爪|s|ask chen about 凝血神爪")
		  local b=busy.new()
	  	  b.Next=function()
		   --world.SetVariable("last_nxsz_time",nxsz_time)
		   self:log_time("nxsz")
	       self:Execute()
		  end
		  b:check()
		end
		local cmd="ask chen about 凝血神爪"
		local path="w;s;e;w;n;n;n;e;w;w;w;s;s"
		path_redo(path,cmd)
      end
      w:go(1346)
   else
      print("next")
      self:Execute()
   end
end

function quest:baozang(manual_operate)
    local q_record=self:get_log_time("bz")
	local last_bz_time=q_record.quest_time
	local bz_time=os.time()

	local interval=os.difftime(bz_time,last_bz_time)
	print(interval,":秒","宝藏时间间隔")
	if (interval>3600*24 and q_record.success==0) or manual_operate==true then
       local w=walk.new()
	   w.walkover=function()
	     self:bz1()
	   end
	   w:go(71)
   else
      print("next")
      self:Execute()
   end
end

function quest:ask_baozang()
    DoAfter(1,"ask miao about 宝藏")
	wait.make(function()
	   local l,w=wait.regexp("^(> |)苗人凤交给你一张宝藏图。$|^(> |)苗人凤说道：「这样吧，你还是抓紧时间练功去吧，过一会再来问吧，我这就找找看。」$",5)
	    if l==nil then
		   self:ask_baozang()
		   return
		end
	   if string.find(l,"苗人凤交给你一张宝藏图") then
	        local f=function()
		     self:bz_place()
    	    end
        	f_wait(f,4)
	      return
	   end
       if string.find(l,"过一会再来问吧，我这就找找看") then
	    local b=busy.new()
		b.Next=function()
	      world.Send("drop lengyue dao")
	      self:Execute()
		end
		b:check()
	      return
	   end

	end)
end

function quest:bz3()
    local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
         world.Execute("w;n")
		 self:ask_baozang()

		end
		b:check()
     end
     w:go(1568)
end

function quest:bz_place()
  marco("yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|guanzhu lengyue|#wa 1000|guanzhu lengyue|#wa 1000|duizhao lengyue|#wa 1000|duizhao lengyue")

  wait.make(function()
    local l,w=wait.regexp("^(> |)你突然发现两者结合最终的标志竟然落在一个你曾经熟悉的地方——(.*)。$",20)
	if l==nil then
	   self:bz_place()
	   return
	end
	if string.find(l,"你突然发现两者结合最终的标志") then
	   local roomno
	   local place=w[2]
	   if place=="青城" then
	     roomno=630
	   elseif place=="五佛寺" then
	     roomno=1591
	   elseif place=="昆仑小溪" then
	      roomno=2139
	   elseif place=="草海" then
	      roomno=2065
	   elseif place=="古长城" then
	      roomno=1589
	   elseif place=="兰州土门子" then
	      roomno=1585
	   end
	   shutdown()
	   local b=busy.new()
	   b.Next=function()
	     self:bz4(roomno)
	   end
	   b:check()
	   return
	end
  end)
end

function quest:wa_di()
   world.Execute("#10 wa di")
  wait.make(function()
    local l,w=wait.regexp("^(> |)你抓住刀柄轻轻把单刀从土中抽出，刀刃抽出寸许，毫无生锈。$",5)
	if l==nil then
	    self:bz2()
	   return
	end
	if string.find(l,"你抓住刀柄轻轻把单刀从土中抽出") then
		local b=busy.new()
		b.Next=function()
		   self:bz3()
		end
		b:check()
	end
  end)
end

function quest:bz2()
	 local w=walk.new()
	 --
     w.walkover=function()
	    self:wa_di()
     end
     w:go(732)
end

--bang zhuozi|#wa 3000|move hua pen|#wa 3000|tui zhuozi|#wa 3000|tui anmen
function quest:bz1()
    local equip={}
	equip=Split("<获取>火折|<获取>绳子~{粗绳子}","|")
	local sp=special_item.new()
	sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	end
	sp.cooldown=function()
		self:bz2()
	end
	sp:check_items(equip)
end

function quest:fight(pfm,callback)
      print("战斗模块")

	  local cb=fight.new()
       cb.combat_alias=pfm

	   cb.check_time=5
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	   cb.unarmed_alias=unarmed_pfm
	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("战斗结束")
		  world.Send("unset wimpy")
		  shutdown()
		  local b=busy.new()
		  b.Next=function()
		    callback()
		  end
		  b:check()
	  end
	  cb:before_kill()
	  cb:start()
end
--突然从角落里跳出一个人，施岳对着你嚷道：“我就是黑风寨寨主，赶快离开大草原。”
function quest:bz_search()
  world.Send("search")
 wait.make(function()
    local l,w=wait.regexp("^(> |)你已经发现找到藏宝地址了！$|^(> |)你意外地发现一个可以通向地下的通道。$|^(> |).*警惕地看着你，神色极其慌张。$|^(> |)你似乎发现.*一些什么特别的地方，绕着青城走来走去！$|^(> |)突然从角落里跳出一个人，.*对着你嚷道：“我就是黑风寨寨主，赶快离开大草原。”$",2)

    if l==nil then
      self:bz_search()
	  return
	end
	if string.find(l,"你似乎发现") then
	   wait.time(2)
	   self:bz_search()
	   return
	end
	--庞涛前警惕地看着你，神色极其慌张。
	if string.find(l,"警惕地看着你，神色极其慌张") or string.find(l,"黑风寨寨主") then
	   local _pfm=world.GetVariable("pfm") or ""
	   local f=function()
	     self:bz_search()
	   end
	   self:fight(_pfm,f)
	   return
	end
    if string.find(l,"你意外地发现一个可以通向地下的通道") or string.find(l,"你已经发现找到藏宝地址了") then
	   local b=busy.new()
	   b.Next=function()
	      self:bz5()
	   end
	   b:check()

	end
 end)
end

function quest:bz4(target_roomno)
   local w=walk.new()
   w.walkover=function()
      local _R
	  _R=Room.new()
	  _R.CatchEnd=function()
		local count,roomno=Locate(_R)
		print("当前房间号",roomno[1])
		if roomno[1]==target_roomno then
			self:bz_search()
		else
			self:bz4(target_roomno)
		end
	  end
	 _R:CatchStart()

  end
  w:go(target_roomno)
end

function quest:bz_path()
   wait.make(function()
     local l,w=wait.regexp("^(> |)你又暗里推算一番，原来如此：东行(.*)步，西行(.*)，北折(.*)，南回(.*)即可！$",5)
	  if l==nil then
	     self:bz_path()
	     return
	  end
	  if string.find(l,"你又暗里推算一番") then
		local g_east=ChineseNum(w[2])
		local g_west=ChineseNum(w[3])
		local g_north=ChineseNum(w[4])
		local g_south=ChineseNum(w[5])

		marco("#"..g_east.." e|#"..g_west.." w|#"..g_north.." n|#"..g_south.." s")
		wait.time(3)
		self:bz6()
		return
	  end
   end)
end

function quest:bz5()
   local b=busy.new()
   b.Next=function()
      self:bz_path()
	  --> 突然你听到一个声音道：“宝藏已经被人抢先一步了！”
      world.Execute("d;e;use fire")
   end
   b:check()
end

function quest:bz6()
   marco("bang zhuozi|#wa 3000|move hua pen|#wa 3000|tui zhuozi|#wa 3000|tui anmen")
   wait.make(function()
      local l,w=wait.regexp("^(> |)你用力推开活动的暗门，奋力从门缝挤了进去。$",10)
	  if l==nil then
		 self:bz6()
	     return
	  end
	  if string.find(l,"你用力推开活动的暗门") then
	     self:search_zhituan()
		 return
	  end
   end)
end

local yanjiu_zhituan_count=1
function quest:yanjiu_zhituan()
		  marco("#wa 3000|look ka|#wa 1000|yanjiu zhituan")
 		  wait.make(function()
		     local l,w=wait.regexp("^(> |)你携带了不允许携带出去的物品，请丢弃之后再尝试离开。$|^(> |)你按照纸团上的这些线线运行全身经脉，发现全无用处，更别说提高武功了。$|^(> |)你按照纸团上的这些线线运行全身经脉，发现全无用处，更别说提高武功了。$",5)
			   if l==nil then
			      yanjiu_zhituan_count=yanjiu_zhituan_count+1
				  if yanjiu_zhituan_count>=3 then
				      local b=busy.new()
				     b.Next=function()
				      world.Execute("drop ka;drop lengyue dao")
		              world.Execute("out;w;u")
					  self:log_time("bz")
			          self:Execute()
				    end
				    b:check()
				  else

				     self:yanjiu_zhituan()
				  end

			      return
			   end
			   if string.find(l,"请丢弃之后再尝试离开") then
			      local b=busy.new()
				  b.Next=function()
				    world.Send("yanjiu zhituan")
				    world.Execute("drop ka;drop lengyue dao")
		            world.Execute("out;w;u")
					self:log_time("bz")
			        self:Execute()
				  end
				  b:check()
			      return
			   end
			   if string.find(l,"你按照纸团上的这些线线运行全身经脉") then
			      local b=busy.new()
				  b.Next=function()
				    world.Execute("drop ka;drop lengyue dao")
		            world.Execute("out;w;u")
					self:log_time("bz")
			        self:Execute()
				  end
				  b:check()
			     return
			   end
		  end)

end

function quest:search_zhituan()
    world.Execute("#10 search")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)你展开纸团，仔细看了看似乎是武功秘籍之类的介绍。$",5)
	   if l==nil then
	      self:search_zhituan()
	      return
	   end
	   if string.find(l,"你展开纸团") then
	     yanjiu_zhituan_count=1
	     local b=busy.new()
		 b.Next=function()
		   self:yanjiu_zhituan()
		end
		b:check()
	      return
	   end

	end)

end

function quest:hama1()
 local q_record=self:get_log_time("hama")
	local last_hama1_time=q_record.quest_time
	local hama1_time=os.time()

	local interval=os.difftime(hama1_time,last_hama1_time)
	print(interval,":秒","蛤蟆功1时间间隔")
	if interval>3600*24 and q_record.success==0 then
      self:hama1_lookli()
   else
      --print("next")
      self:Execute()
   end
end


--忽听背後一人说道：「小娃娃，知道厉害了罢？」这声音铿锵刺耳，似从地底下钻出来一般。
function quest:hama1_move()

    wait.make(function()
	   local l,w=wait.regexp("^(> |)忽听背後一人说道：「小娃娃，知道厉害了罢？」这声音铿锵刺耳，似从地底下钻出来一般。$|^(> )你只觉手臂麻木，早已不听使唤，只急得大汗淋漓，不知如何是好，慌乱中跑进了柳树林子。$|^(> |)河岸 - west$|^(> |)你脚下突然一软，骨碌碌地滚出了数十丈！$",10)
	   if l==nil then
	       self:hama1_move()
		   return
	   end
	   if string.find(l,"转过头来却发现什么也没有") then
	      print("出现！！")
	      quest.hama1_try=0
	      self:hama1_move()
	      return
	   end
	   if string.find(l,"慌乱中跑进了柳树林子") then
	       world.EnableTimer("hama1",false)
	       wait.time(3)
		   Execute("look guairen|ask guairen about 欧阳锋")
		   wait.time(3)
		   Send("ask guairen about 洪七公")
		   wait.time(3)
		   Send("ask guairen about 蛤蟆功")
		   wait.time(3)
		   Send("ask guairen about name")
		   wait.time(3)
		   Send("kneel man")
		   wait.time(3)
		   Send("turn")
		   wait.time(3)
		   Send("jiao 爸爸")
		   return
	   end
	   if string.find(l,"忽听背後一人说道") then
	        world.EnableTimer("hama1",false)
			world.DeleteTrigger("hama1_appear")
		     shutdown()
			self:hama1_move()
	      return
	   end
	   if string.find(l,"河岸") then
	      quest.hama1_try=quest.hama1_try+1
		  print("次数:",quest.hama1_try)
		  if quest.hama1_try>120 then
		     world.EnableTimer("hama1",false)
		     shutdown()
			 self:Execute()
		  else
		      self:hama1_move()
		  end
	      return
	   end
	   if string.find(l,"你脚下突然一软") then
	        world.EnableTimer("hama1",false)
			world.DeleteTrigger("hama1_appear")
		     shutdown()
			 self:Execute()
	      return
	   end
	end)
end

function quest:hama1_lookli()
   local w=walk.new()
   w.walkover=function()
      world.Execute("look li mochou;halt;w;s;move zhen")
	  world.AddTimer ("hama1", 0, 0, 1, "w;s;e;yun jingli", timer_flag.ActiveWhenClosed+timer_flag.Replace, "")
      world.SetTimerOption ("hama1", "send_to", 10)

	  local cd=cond.new()
	  cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=0
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="冰魄银针毒" then
				world.EnableTimer("hama1",true)
				world.AddTriggerEx ("hama1_appear", "^(> ;)你突然觉得好象有人在你身后，转过头来却发现什么也没有。$", "print(quest.hama1_try)\nquest.hama1_try=0", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 350)
	            self:hama1_move()
			    return
			  end
			end
		 end
		 local f=function()
		    self:hama1_lookli()
		 end
		 f_wait(f,5)
	   end
	    cd:start()

   end
   w:go(4012)
end

function copyfile(source,destination)
  sourcefile = io.open(source,"rb")
  destinationfile = io.open(destination,"wb")
  local _lines=sourcefile:read("*a")
  destinationfile:write(_lines)
  sourcefile:close()
  destinationfile:flush()
  destinationfile:close()
end

local quest_database=GetInfo (66) .. "quest.db"
local quest_source_database=GetInfo (66) .. "tools\\quest.db"

local F,err=io.open(quest_database,"r+")
if err~=nil then
    print("复制quest log 数据库")
   copyfile(quest_source_database,quest_database)
   DatabaseOpen ("quest", quest_database, 6) --修改数据库
else
   F:close()
   DatabaseOpen ("quest", quest_database, 6) --修改数据库
end

function quest:log_time(quest)
  --获得一个id 号
  local quest_time=os.time()
  local quest_date=os.date("%Y/%m/%d %H:%M:%S")
  local player_id=world.GetVariable("player_id")
  local player_name=world.GetVariable("player_name")
  local cmd
  cmd="insert into MUD_Quest (quest,quest_time,quest_date,playerName,playerID,success) values('"..quest.."',"..quest_time..",'"..quest_date.."','"..player_name.."','"..player_id.."',0)"
   --print(cmd)
  DatabaseExec ("quest",cmd)
  DatabaseFinalize ("quest")

end

function quest:update_status(quest)
  local player_id=world.GetVariable("player_id")
  local player_name=world.GetVariable("player_name")
  local cmd
  cmd="update MUD_Quest set success=1  where id in (select id from MUD_Quest where quest='"..quest.."' and playerID='"..player_id.."' order by id desc limit 1)"
  -- print(cmd)
  DatabaseExec ("quest",cmd)
  DatabaseFinalize ("quest")
end

function quest:group_time()
  local player_id=world.GetVariable("player_id")
  local player_name=world.GetVariable("player_name")
  --[[
  local q_cmd=""
  --debug 使用
  --if self.list==nil or table.getn(self.list)==0 then
     local q_list=world.GetVariable("quest_list") or ""
     self.list=Split(q_list,"|")
  --end
  for _,me_quest in ipairs(self.list) do
      q_cmd=q_cmd.." quest='"..me_quest.."' or "
	  --print(q_cmd,"q_cmd")
  end
  if q_cmd=="" then
	  local P={}
	  P.success=1
	  P.quest_time=0
	  P.quest_data=nil
     return P
  else
     q_cmd=string.sub(q_cmd,1,-5)
  end
  ]]
  local cmd
  cmd="select max(quest_time),max(quest_date) from MUD_Quest where success=0 and playerID='"..player_id.."'"
 --确定是否都解开
  local inner_sql="select quest from MUD_Quest where success=1 and playerID='"..player_id.."'"
  cmd=cmd.." and not quest in ("..inner_sql..")"
  --print(cmd)
  DatabasePrepare ("quest", cmd)
	  rc = DatabaseStep ("quest")
   	  local P={}
	  P.success=1
	  P.quest_time=0
	  P.quest_data=nil
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("quest")
		  ----print("房间号:",values[1])

		  P.quest_time=values[1]
		  P.quest_date=values[2]
		  P.success=0
		  rc = DatabaseStep ("quest")
	  end
	  DatabaseFinalize ("quest")
  return P
end

function quest:get_log_time(quest)

  local player_id=world.GetVariable("player_id")
  local player_name=world.GetVariable("player_name")
  local cmd
  cmd="select quest_time,quest_date,success from MUD_Quest where quest='"..quest.."' and playerID='"..player_id.."' order by quest_date desc limit 1"
  -- print(cmd)
  DatabasePrepare ("quest", cmd)
	  rc = DatabaseStep ("quest")
   	  local P={}
	  P.success=0
	  P.quest_time=0
	  P.quest_data=nil
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("quest")
		  ----print("房间号:",values[1])

		  P.quest_time=values[1]
		  P.quest_date=values[2]
		  P.success=values[3]
		  rc = DatabaseStep ("quest")
	  end
	  DatabaseFinalize ("quest")
  return P
end

local quest_msg="^(> |)陈近南给了你一本凝血神爪谱。$|^(> |)你听了夏雪宜的指点，再与金蛇秘笈中不解之处一加参照，登时豁然贯通，果然妙用无穷。$|^(> |)你听了苗人凤的指点，对苗家剑法和胡家刀法的奥妙似乎更加明白。$|^(> |)你已经找到你想要的了。$|^(> |)你意外地发现一个可以通向地下的通道。$"

function quest:success_msg()
  wait.make(function()
    local l,w=wait.regexp(quest_msg,10)
	if l==nil then
	    self:success_msg()
	    return
	end
	if string.find(l,"凝血神爪谱") then
	   self:update_status("nxsz")
	   return
	end
	if string.find(l,"果然妙用无穷") then
	   self:update_status("jsjf")
	   return
	end
	if string.find(l,"对苗家剑法和胡家刀法的奥妙似乎更加明白") then
	   self:update_status("rh")
	   return
	end
	if string.find(l,"你已经找到你想要的了") then
	   self:update_status("lbwb")
	   return
	end
	if string.find(l,"你意外地发现") then
	   self:success_msg()
	   self:bz5()
	   return
	end
   end)
end

function quest:ask_question()
   world.Send("ask liu about question")
   self:get_guess()
   world.Send("guess 1234")
end

function quest:get_guess()
  wait.make(function()
    --刘好弈道：“你猜的是1234，全对的有零个，只有书架对的有二个。
     local l,w=wait.regexp("^(> |)刘好弈道：“你猜的是(.*)，全对的有(.*)个，只有书架对的有(.*)个。$|^(> |)刘好弈在墙上按了几下，道：“好了，你可以进书房去了。”$",5)
     if l==nil then
	    self:get_guess()
	    return
	 end
	 if string.find(l,"你可以进书房去") then
		world.ColourNote ("red", "yellow", "guess ok")
		world.Send("w")
		world.Send("look shelf")
		world.Send("e")
		wait.time(1)
		self:finish()
	    return
	 end
	if string.find(l,"你猜的是") then
		local status=w[2]..w[3]..w[4]
		--print(stauts)
		local rc=self:guess(status)

		self:get_guess()
	    return
	 end
   end)
end

function quest:guess(status)
	local sql="Select [Return_Data] From MUD_Guess where [Data]='"..status.."'"
	print(sql)
	DatabasePrepare ("db2", sql)

  	 local rc=DatabaseStep ("db2")
	  local gs=""
	  while rc == 100 do
	     ------print("row",i)
	     local values= DatabaseColumnValues ("db2")
		 gs=values[1]
		 print(gs)
		 rc = world.DatabaseStep ("db2")
	  end
	  print(rc)
	  world.DatabaseFinalize ("db2")
	  --local f=function()
	    print(gs)
	    world.Send("guess "..gs)
	  --end
	  --f_wait(f,1)
end

--越女剑
function quest:yuenvjian()
    local q_record=self:get_log_time("yuenvjian")
	local last_yuenvjian_time=q_record.quest_time
	local yuenvjian_time=os.time()

	local interval=os.difftime(yuenvjian_time,last_yuenvjian_time)
	print(interval,":秒","越女剑时间间隔")
  if interval>3600*24 and q_record.success==0 then
    local w=walk.new()
    w.walkover=function()
	   local b=busy.new()
	   b.Next=function()
		  world.Send("ask aqing about 越女剑")
	      --world.SetVariable("last_yuenvjian_time",yuenvjian_time)
		   self:log_time("yuenvjian")
		  local f=function()
	        self:Execute()
		  end
		  f_wait(f,30)
	   end
	   b:check()
    end
    w:go(5009)
  else
     self:Execute()
  end
end
--葵花宝典
--东方阿姨
function quest:check_donfang()
   local _R=Room.new()
   _R.CatchEnd=function()
      print(_R.roomname)
      if _R.roomname=="小舍" then
		self:dongfang(true)
	  else
	    self:dongfang()
	  end
   end
   _R:CatchStart()
end

function quest:kill_dongfang(cmd)
   		  local _pfm=world.GetVariable("quest_pfm") or ""

		  marco(cmd)

		  --东方不败说道：「我现在很忙，没兴趣和你多罗嗦。」
		  wait.make(function()
		     local l,w=wait.regexp("^(> |)东方不败将那「葵花宝典」放在双掌中一搓，功力到处，一本原已十分陈旧的册页登时化作碎片。$|^(> |)你向东方不败打听有关『葵花宝典』的消息。$|^(> |)你向东方不败打听有关『任我行』的消息。$",10)
			 if l==nil then
			    self:check_donfang()
			    return
			 end
			 if string.find(l,"任我行") then

			     local f=function()
		   	       shutdown()
			       self:log_time("ronggong")
			       local f=function()
				     self:back_ronggong()
			       end
			        f_wait(f,10)
		           end
		          self:fight(_pfm,f)
			     return
			 end

			 if string.find(l,"你向东方不败打听有关") then
			     local f=function()
		   	       shutdown()
			       self:log_time("kuihua")
			       local f=function()
				     self:Execute()
			       end
			        f_wait(f,10)
		           end
		          self:fight(_pfm,f)
			     return
			 end
			 if string.find(l,"一本原已十分陈旧的册页登时化作碎片") then
			    shutdown()
			    self:log_time("kuihua")
			    local f=function()
				self:Execute()
				end
				f_wait(f,3)

			    return
			 end
		  end)
end

function quest:dongfang(flag)
     local _pfm=world.GetVariable("quest_pfm") or ""
       local cmd=""
         if flag==nil then
		    cmd="tui qiang|open men|#2 d|w|ask dongfang about 葵花宝典|".._pfm
			local w2=walk.new()
		     w2.walkover=function()
               self:kill_dongfang(cmd)
		    end
		    w2:go(2880)
		 else
			 cmd="ask dongfang about 葵花宝典|".._pfm
			 self:kill_dongfang(cmd)
		 end

end

function quest:kuihua_getkey(quest_type)
	marco("l shujia|l shuji|na shu 1 from jia|fan shu|#wa 1000|open shu|na shu 2 from jia|fan shu|#wa 1000|open shu|na shu 3 from jia|fan shu|#wa 1000|open shu|na shu 4 from jia|fan shu|#wa 1000|open shu|na shu 5 from jia|fan shu|#wa 1000|open shu")
	wait.make(function()
       local l,w=wait.regexp("^(> |)你缓缓打开手中古籍的夹层，取出了钥匙。$|^(> |)你正要打开手中的古籍，突然，一位日月神教长老冲了进来。$",5)

	  -- 你打开书的封页，发现里面是一个夹层。
	  if l==nil then
	     self:kuihua_getkey()
	     return
	  end

	  if string.find(l,"一位日月神教长老冲了进来") then
	     shutdown()
	     local _pfm=world.GetVariable("quest_pfm") or ""
		 world.Send("kill zhanglao")
		  local f=function()
			 self:kuihua_getkey()
		  end
		 self:fight(_pfm,f)
	     return
	  end
	  if string.find(l,"你缓缓打开手中古籍的夹层，取出了钥匙") then
	     shutdown()
	    local f=function()
	      local b=busy.new()
	   	  b.Next=function()
	       self:dongfang()
		  end
	   	  b:check()
		end
		f_wait(f,2)
	     return
	  end

	end)
end

function quest:kuihua()
  local q_record=self:get_log_time("kuihua")
	local last_kuihua_time=q_record.quest_time
	local kuihua_time=os.time()

	local interval=os.difftime(kuihua_time,last_kuihua_time)
	print(interval,":秒","葵花宝典时间间隔")
  if interval>3600*24 and q_record.success==0 then
    local w=walk.new()
    w.walkover=function()
        self:kuihua_getkey()
	end
    w:go(2881)
  else
     self:Execute()
  end
end

function quest:gumu_yufengzhen()
   local w=walk.new()
   w.walkover=function()

       world.Send("qu yufeng zhen")
	   local b=busy.new()
	   b.Next=function()
	       self:gumu_hubo()
	   end
	   b:check()
   end
   w:go(94)
end

function quest:gumu_hubo(flag)
  --小龙女
  local w=walk.new()
  w.walkover=function()

	 if flag==nil then
	    marco("ask longnv about 周伯通|#wa 3000|ask longnv about 玉蜂针")
	   local f=function()
	     local w2=walk.new()
	     w2.walkover=function()
	       world.Execute("give 1 yufeng zhen to zhou|ask zhou about 小龙女")
		   local f=function()
		      self:gumu_hubo(false)
		   end
		   f_wait(f,3)
	     end
	     w2:go(4121)
	    end
	    f_wait(f,5)
	else
		world.Send("ask longnv about 周伯通")
		local f=function()
		   local sp=special_item.new()
		   local item="<保存>玉蜂针"
		   sp.cooldown=function()
		     world.Send("n|w|s")
	         self:yunu_xinjing()
		   end
		   local equip={}
		   equip=Split(item,"|")
           sp:check_items(equip)
		end
		f_wait(f,3)
	 end
  end
  w:go(3018)
end

function quest:yunu_xinjing_ok()
wait.make(function()
	local l,w=wait.regexp("^(> |)恭喜！.*成功运用古墓心法悟通全真剑法与玉女剑法的单人双剑合璧！",5)
	if l==nil then
		self:yunu_xinjing()
		return
	end
	if string.find(l,"恭喜") then
		sj.log_catch("gmhb",300)
		local b=busy.new()
		b.Next=function()
			self:Execute()
		end
		b:check()
		return
	end
end)
end

function quest:yunu_xinjing()
wait.make(function()
	world.Execute("pray pearl;yun xinjing;dazuo 3000;dazuo 2000;dazuo 1000;yun qi")
	local l,w=wait.regexp("^(> ;)你屏气凝神，口中默念「多思则神怠，多念则精散」的玉女心经正反要诀。$",5)
	if l==nil then
		self:yunu_xinjing()
		return
	end
	if string.find(l,"你屏气凝神") then
		self:yunu_xinjing_ok()
		return
	end

end)
end

function quest:gumu_jiuyin()
 local w=walk.new()
 w.walkover=function()

    world.Execute("look map;look ceiling;look zi")
	self:Execute()
 end
 w:go(5071)
end

function quest:gumu_shike()
   local w=walk.new()
   w.walkover=function()
    world.Send("ask yang about 古墓石刻")
	  local b=busy.new()
	  b.Next=function()
	     self:gumu_jiuyin()
	  end
	  b:check()
   end
   w:go(3017)

end

--古墓九阴石刻代码
--[[

	if ( arg =="zi") {
		write(HIY"你望著那些小字，似乎都是一些武功要诀。\n"NOR)|
		if( !me->query_temp("ceiling")
                 || me->query("combat_exp", 1) < 2000000 ){
			tell_object(me,HIY"不过上面写的艰深难懂，你看了一会，觉得自己理解能力不足，只好放弃了。\n"NOR)|
			return 1|
		}
                i = (me->query("combat_exp") - 1000000) / 500000|
		time = time() - me->query("quest/jiuyingm/time")|
                if ( me->query("quest/jiuyingm/fail") >= i && me->query("registered") < 3 ){
			tell_object(me,HIY"不过上面写的艰深难懂，你看了一会，觉得自己上次看过以后，增加的历练还不足以理解其奥义。\n"NOR)|
			return 1|
		}
                if ( time < 86400 ){
			tell_object(me,HIY"不过上面写的艰深难懂，你自从上次看过后，思绪一直无法平静下来，或许需要再过一点时间。\n"NOR)|
			return 1|
		}

                 if(( random(me->query("kar")) > 28
                 && me->query("kar") <31
                 && me->query("buyvip")
                 && me->query("combat_exp")>=2000000
                 && random(10) == 3
                 && me->query("int") > 30)
         || me->query("quest/jiuyingm/pass") ){

			write(HIR"你陡然一瞥间，看到几个小字“九阴真经内功要诀”，你兴奋极了。\n"NOR)|
			write(HIC"你研究了一下，发现应该能研读(yandu)些道德经(daode-jing) \n"NOR)|
			write(HIB"九阴真功(jiuyin-zhengong)以及九阴身法(jiuyin-shenfa)、\n"NOR)|
                        write(HIM"九阴神爪(jiuyin-shenzhua)以及九阴银龙鞭(yinlong-bian)的皮毛。\n"NOR)|
			if( !me->query("quest/jiuyingm/pass"))
				log_file("quest/jiuyin",
					sprintf("%-18s失败%s次后，在古墓石壁上得到九阴真经，福：%d，悟：%d。\n",
						me->name(1)+"("+capitalize(getuid(me))+")",
						chinese_number(me->query("quest/jiuyingm/fail")),
						me->query("kar"),
						me->query("int")
					), me
				)|
			me->set("quest/jiuyingm/pass", 1)|
		}

         if(( random(me->query("kar")) >= 28
                 && random(15) == 10
                 && me->query("int") > 40)
                 && me->query_temp("quest/gmsuper/ask")
         || me->query("quest/gmsuper/pass") ){

                        write(HBMAG"\n你看到在密密麻麻的小字旁边，另外刻了一些图形招式，似乎与古墓武学有关。\n"NOR)|
			write(HIW"你仔细研究了一下，发现石刻上所刻画的，正是杨过与小龙女的毕生武学精要。 \n"NOR)|
			write(HIW"其中密密麻麻的记录了古墓武学在吸收了左右互搏、九阴真经、蛤蟆功、黯然销魂掌后的诸多变化。 \n"NOR)|
	   if( !me->query("quest/gmsuper/pass"))
				log_file("quest/gmsuper",
					sprintf("%-18s失败%s次后，在古墓石壁上得到古墓武学总纲，福：%d，悟：%d。\n",
						me->name(1)+"("+capitalize(getuid(me))+")",
						chinese_number(me->query("quest/jiuyingm/fail")),
						me->query("kar"),
						me->query("int")
					), me
				)|
   me->set("quest/jiuyingm/pass", 1)|
                        me->set("quest/gmsuper/pass", 1)|
		}

		else {
			me->add("quest/jiuyingm/fail", 1)|
			me->set("quest/jiuyingm/time", time())|
			log_file("quest/jiuyin",
				sprintf("%-18s错过%s次，没有发现古墓石壁上的九阴真经。\n",
                      			me->name(1)+"("+capitalize(getuid(me))+")",
                      			chinese_number(me->query("quest/jiuyingm/fail"))
                      		), me
                      	)|
			write(HIY"不过上面写的艰深难懂，你看了一会就放弃了。\n"NOR)|
		}
		me->delete_temp("ceiling")|
		return 1|
	}
	return notify_fail("你要看什么？\n")|
]]
--[[ 陆无双出现房间代码
"/d/emei/xiaowu",		"/d/wudang/xiaolu1",		"/d/xiangyang/zhuquemen",
"/d/xiangyang/hanshui1",	"/d/fuzhou/road1",		"/d/xueshan/xuelu2",
"/d/xueshan/houzidong",		"/d/suzhou/lingyansi",		"/d/suzhou/liuyuan",
"/d/jiaxing/tieqiang",		"/d/hz/longjing",		"/d/hz/huanglong",
"/d/hz/yuhuang" 1206,		"/d/hz/tianxiang",		"/d/miaojiang/jiedao4",
"/d/foshan/duchang",		"/d/huanghe/shulin5",		"/d/hz/changlang1",
"/d/hz/yuquan",			"/d/hz/longjing",		"/d/xingxiu/shamo3",
"/d/wudang/xuanyue",		"/d/emei/guanyinqiao",		"/d/emei/basipan3",
"/d/tiezhang/shanmen",		"/d/tiezhang/hclu",		"/d/xueshan/huilang4",
"/d/emei/caopeng",		"/d/mingjiao/bishui",		"/d/mingjiao/shanting",
"/d/fuzhou/haigang",		"/d/fuzhou/laozhai",		"/d/xingxiu/shamo2",
"/d/jiaxing/nanhu",		"/d/village/caidi",		"/d/shaolin/songshu2",
"/d/xiangyang/tanxi",		"/d/huashan/husun",		"/d/huashan/yunu",
"/d/mr/yanziwu/xiaojing2",	"/d/mr/mtl/liulin",		"/d/suzhou/shihu",
"/d/suzhou/xuanmiaoguan",	"/d/suzhou/zijinan",		"/d/hengshan/cuiping2",
"/d/hengshan/guolaoling",	"/d/shaolin/talin1",		"/d/wudang/houshan/husunchou",
"/d/shaolin/shanlu8",		"/d/xueshan/shanlu7",		"/d/foshan/road10",
"/d/foshan/xiaolu2",		"/d/emei/jiulaodong",		"/d/hengshan/beiyuemiao",
"/d/gb/xinglin2",		"/d/city/shangang",		"/d/fuzhou/zhongxin",
"/d/huanghe/huanghe4",		"/d/lanzhou/shamo",		"/d/emei/gudelin3",
"/d/cangzhou/dongjie1",		"/d/tanggu/center",		"/d/putian/xl6",
"/d/dali/wuliang/songlin6",	"/d/gumu/xuantie/linhai8",	"/d/gumu/jqg/zhulin5",
function quest:lu_place()
  local lu_place={
   "xiaowu"=-1,  --看到佛光 曙光台
   "xiaolu1"=2045,
   "zhuquemen"=225,
   "hanshui1"=203,
   "road1"=1219,
   "xuelu2"=3106,
	"houzidong"=1667,
	"lingyansi"=1152,
	"liuyuan"=1030,
	"tieqiang"=4012
	莆田少林 1891
  }
end]]

--[[
后堂开始：e|s|s|#4 search qiangjiao|i|#wa 10000|n|n|w|n|tang bed|ban shiban|out|#6 e|#6 w|#6 n|#6 s|#wa 10000|enter|tui guangai|tang guan|use fire|#9 search|turn ao left|#wa 5000|ti up|l map|l ceiling|l zi
5026 climb cliff

2351 yuyi cao
2244  sangang shilue

2028 ask daozhang about 药典;ask daozhang about 只是
2640 ask lao weng about 搭救
2028 askk daozhang about 结果
]]

function quest:medicinebook1()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy yuyi cao")
   end
   w:go(2351)
end

function quest:medicinebook2()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy sangang shilue")
   end
   w:go(2244)
end

function quest:medicinebook3()


   local w=walk.new()
   w.walkover=function()
      world.Send("buy ya")

	  local w=walk.new()
      w.walkover=function()
        world.Send("ask laoban about 药典")

      end
      w:go(95)
	  --ask kong about 药典
	  --give kong ya
	  --空空儿说道：「你这么聪明，这本书你就拿去吧.」
   end
   w:go(51)
end

function quest:getbook()
  wait.make(function()
    local l,w=wait.regexp("^(> |)你向空空儿打听有关『药典』的消息。$",3)
	if l==nil then
	  coroutine.resume(quest.sp_co)
	  return
	end
	if string.find(l,"你向空空儿打听有关") then
	   wait.time(1)
	   world.Send("give kong ya")
	   quest.sp_co=nil
	   return
	end
  end)

end


function quest:askkong()
 local cmd="ask kong about 药典"
   local route={}
    table.insert(route,"ne|"..cmd.."|sw|"..cmd.."|n|"..cmd.."|s|"..cmd.."|s|"..cmd.."|set action 购买")
    table.insert(route,"n|"..cmd.."|e|"..cmd.."|e|"..cmd.."|w|"..cmd.."|w|"..cmd.."|set action 购买")
	table.insert(route,"w|"..cmd.."|n|"..cmd.."|s|"..cmd.."|set action 购买")
	table.insert(route,"s|"..cmd.."|n|"..cmd.."|w|"..cmd.."|set action 购买")
	table.insert(route,"s|"..cmd.."|w|"..cmd.."|e|"..cmd.."|set action 购买")
	table.insert(route,"n|"..cmd.."|n|"..cmd.."|s|"..cmd.."|set action 购买")
	table.insert(route,"w|"..cmd.."|n|"..cmd.."|s|"..cmd.."|set action 购买")
	table.insert(route,"s|"..cmd.."|n|"..cmd.."|w|"..cmd.."|set action 购买")
	table.insert(route,"n|"..cmd.."|s|"..cmd.."|s|"..cmd.."|set action 购买")
	table.insert(route,"n|"..cmd.."|w|"..cmd.."|w|"..cmd.."|s|"..cmd.."|e|"..cmd.."|e|"..cmd.."|w|"..cmd.."|w|"..cmd.."|w|"..cmd.."|e|"..cmd.."|s|"..cmd.."|e|"..cmd.."|w|"..cmd.."|w|"..cmd.."|set action 购买")
    local w=walk.new()
	w.walkover=function()
	 quest.sp_co=coroutine.create(function()

	    for _,r in ipairs(route) do
		  marco(r)
		  self:getbook()

	      coroutine.yield()
		end
		--
		--[[结 束 重新搜索
		local f=function()
		   self:buy_tools(tools_id,itemid)
		end]]

		--print("间隔2s")
		--f_wait(f,2)
	 end)

	 coroutine.resume(quest.sp_co)
	end
	w:go(75)
end

function quest:medicinebook4()
   local w=walk.new()
   w.walkover=function()
      marco("ask daozhang about 药典|#wa 1000|ask daozhang about 只是")
   end
   w:go(2028)
end

function quest:medicinebook5()
   local w=walk.new()
   w.walkover=function()
      world.Execute("ask lao weng about 搭救")

	  local f=function()
	   local w=walk.new()
       w.walkover=function()
        world.Execute("ask daozhang about 结果")
       end
       w:go(2028)
	  end
	  f_wait(f,2)
   end
   w:go(2640)
end

--[[
初级经脉学——杨州药铺可买得。(0 lev-41 lev)

进阶经脉学——薛幕华处可买得，from 青龙门内街 {w;n;w;w;w;sw;#7 n} back {#7 s;ne;e;e;e;s;e} 。
(41 lev-81 lev)
高级经脉学——平一指处可买得。from 青龙门内街 {w;n;e} back {w;s;e}。
(81 lev-121 lev)
针灸概论——薛幕华处ask xue about 学问，薛幕华说道：「听说阁下武功不错。。。」，接着就ask xue about 武功，薛幕华说道：「多谢，我会好好报答的。请使用 teach xue <skill> 来指导我。」，然后你可以挑选一两个武功去教他，然后再ask xue about 学问，薛幕华说道：「拿去好好研究吧。」，薛神医给你一本针灸概论。(121 lev-141 lev)
孙思邈千斤方——薛幕华处ask xue about 救人，薛幕华说道：「听说有人被星宿派的恶贼下了慢性毒药，自己却不知。」薛幕华说道：「请找到***。」薛幕华说道：「你去朱雀门找找看。」薛幕华对所有在场的人表示感谢。薛幕华说道：「用这瓶药水，heal *** 就可以了。」heal ***，你手指微弹，将药水撒向了***！再回去xue那里就会得到了。(141 lev-151 lev)
黄帝内经——平一指处ask ping about 杀人，平一指会让你去杀一个玩家，杀了他后将其corpse切割，将头给平一指就可以了。如果你没完成其他的人就不能再ask ping了，平一指会说他正在等别人杀人，如果你不想杀了，可再向平一指ask ping about 杀人 一次就会取消了。
黄帝内经——平一指处ask ping about 杀人，平一指会让你去杀一个玩家，杀了他后将其corpse切割，将头给平一指就可以了。如果你没完成其他的人就不能再ask ping了，平一指会说他正在等别人杀人，如果你不想杀了，可再向平一指ask ping about 杀人 一次就会取消了。
]]

function quest:jmxbook1()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy jingmai book")
   end
   w:go(95)
end

function quest:jmxbook2()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy jingmai book")
   end
   w:go(623)
end

function quest:jmxbook3()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy jingmai book")
   end
   w:go(273)
end

function quest:jdhj_start()
    local w=walk.new()
  w.walkover=function()
   world.Send("askk gongsun about 金刀黑剑")
   local Quest_log= function()
		  self:quest_log(5)
		   local b=busy.new()
		   b.Next=function()
		     self:next_quest()
		   end
		   b:check()
		end
   f_wait(Quest_log,5)
  end
  w:go(2998)
end

function quest:nqg_start()
 local q_record=self:get_log_time("nqg")
	local last_nqg_time=q_record.quest_time
	local nqg_time=os.time()

	local interval=os.difftime(nqg_time,last_nqg_time)
	print(interval,":秒","泥鳅功时间间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

    local w=walk.new()
  w.walkover=function()
   world.Send("askk ying about 泥鳅功绝技")
   local Quest_log= function()
		  self:quest_log(5)
		   local b=busy.new()
		   b.Next=function()
		     self:Execute()
			  self:log_time("nqg")
		   end
		   b:check()
		end
   f_wait(Quest_log,1)
  end
  w:go(435)
  else
     self:Execute()
  end
end

function quest:xx_laoyue_start()
    local w=walk.new()
  w.walkover=function()
   world.Send("ask zhaixing about 海底捞月")
   local Quest_log= function()
		  self:quest_log(10)
		   local b=busy.new()
		   b.Next=function()
		     self:next_quest()
		   end
		   b:check()
		end
   f_wait(Quest_log,10)
  end
  w:go(1969)
end
--[[
然后去襄阳4个城门转转，注意之前药啊丹啊带齐，护甲穿好。会发生一个抢劫事件，主角的你当然挺身而出了，砍退一堆蒙面人之后，出来个用华山剑法的有名字的boss。
这个可以杀死，就出现下面的情况了


你只觉得彭四使得华山剑法奇特无比，顿时让你想到了石壁
上的剑招。
突然你觉得如果可以再次揣摩下，或许会有新的发现！


然后回到密洞


chuaimo 剑招
你对照着石壁上的剑招，慢慢揣摩刚才蒙面恶人的剑招，虽然觉得有点思路，但还是无
法理解透彻！
chuaimo 剑招
你对照着石壁上的剑招，回想起刚才蒙面恶人所使用的招数，突然间领会了
这“有凤来仪”的最后一招，你不禁哈哈大笑道：“哈哈~！原来如此啊!”
]]
function quest:hs_sgy()


	   local sp=special_item.new()
       sp.cooldown=function()
	      local w=walk.new()
		  w.walkover=function()
             self:mianbi()
		  end
		   w:go(1537)
       end
   	   local equip={}
	   equip=Split("<获取>火折","|")
       sp:check_items(equip)
end

function quest:hs_fengyi(manual_operate)
 local q_record=self:get_log_time("fy")
	local last_fy_time=q_record.quest_time
	local fy_time=os.time()

	local interval=os.difftime(fy_time,last_fy_time)
	print(interval,":秒","有凤来仪时间间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()

     world.Send("askk yue about 华山石壁")
	 local f=function()
	   self:hs_sgy()
	 end
	 f_wait(f,5)

   --f_wait(Quest_log,40)
  end
  w:go(1532)
  else
     self:Execute()
  end
end

function quest:hs_jjs_start(manual_operate)
  local q_record=self:get_log_time("jjs")
	local last_jjs_time=q_record.quest_time
	local jjs_time=os.time()

	local interval=os.difftime(jjs_time,last_jjs_time)
	print(interval,":秒","截剑式时间间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
  self:log_time("jjs")
   world.Send("ask mu about 截剑式")
   local Quest_log= function()
		 -- self:quest_log(50)
		   local b=busy.new()
		   b.interval=10
		   b.Next=function()
		     self:Execute()

		   end
		   b:check()
		end
   f_wait(Quest_log,40)
  end
  w:go(1508)
  else
     self:Execute()
  end
end

function quest:wd_taoyue_start(manual_operate)
  local q_record=self:get_log_time("taoyue")
	local last_taoyue_time=q_record.quest_time
	local taoyue_time=os.time()

	local interval=os.difftime(taoyue_time,last_taoyue_time)
	print(interval,":秒","三环套月时间间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then
     local w=walk.new()
	 w.walkover=function()
		world.Send("guanmo 剑痕")
		local Quest_log= function()
		  self:quest_log(50)
		   local b=busy.new()
		   b.Next=function()
		     self:Execute()
			  self:log_time("taoyue")
		   end
		   b:check()
		end
		f_wait(Quest_log,40)

	 end
	 w:go(2044)
  else
     self:Execute()
  end
end

function quest:ss_guanwu_songtao_start()
     local w=walk.new()
	 w.walkover=function()
		self:ss_guanwu_songtao()
	 end
	 w:go(328)
end

function quest:ss_guanrifeng()
   local w=walk.new()
	 w.walkover=function()
		world.Execute("guan ri;guanwu songtao;west")
		local Quest_log= function()
		  self:quest_log(50)
		end
		f_wait(Quest_log,1)
        local b=busy.new()
		b.Next=function()
		   self:log_time("songyang")
		   self:Execute()
		end
		b:check()
	 end
	 w:go(311)
end

function quest:ss_songyang(manual_operate)
   local q_record=self:get_log_time("songyang")
	local last_songyang_time=q_record.quest_time
	local songyang_time=os.time()

	local interval=os.difftime(taoyue_time,last_songyang_time)
	print(interval,":秒","嵩山嵩阳时间间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

	   self:ss_guanwu_songtao()
  else
     self:Execute()
  end
end

function quest:ss_guanwu_songtao(index)
  --328
  local path="wu;nd;nu;nu;nu;nu;nw;nw;ne;nu;n;n;n;n;n;n;e;e;w;w;w;w;e;e;n;nu;n;e;e;e;w;w;w;w;w;w;e;e;e;nu;nu;nu"
  --311
  local paths={}
  paths=Split(path,";")
  if index==nil then
     index=1
  end
  local n=table.getn(paths)
  if index>n then
	 index=1
	 local f=function()
	    self:ss_guanwu_songtao_start()
	 end
	 f_wait(f,1.5)
	 return
  end
   world.Send(paths[index])
   world.Send("ask fei about 观日峰")
	wait.make(function()
       local l,w=wait.regexp("^(> |)这里没有这个人。$|^(> |)你向费彬打听有关『观日峰』的消息。$",5)
	    if l==nil then
		   index=index+1
		   self:ss_guanwu_songtao(index)
		   return
		end
		if string.find(l,"你向费彬打听有关") then
		   local b=busy.new()
		   b.Next=function()
		      self:ss_guanrifeng()
		   end
		   b:check()
		   return
		end
	    if string.find(l,"这里没有这个人") then
	        index=index+1
			self:ss_guanwu_songtao(index)
	       return
	    end
	end)


    --world.Send("guanwu songtao")
end

--自动解xxdf
--获得物品
function quest:xxdf_item_Next()
  --回调函数
end

function quest:guanglingsan()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy tie qiao")
	  local f=function()
	  w.walkover=function()
	   world.Send("wa mu")
	   world.Send("drop tie qiao")
	   self:xxdf_item_Next()
	  end
	  w:go(347)
	  end
	  f_wait(f,5)
   end
   w:go(568)

end

function quest:ouxuepu()
  local w=walk.new()
  w.walkover=function()
   self.finish=function()
      world.Send("w")
       world.Send("look shelf")
	   self:xxdf_item_Next()
   end
    self:ask_question()

  end
  w:go(626)
end

function quest:hua()
local w=walk.new()
   w.walkover=function()
     world.Send("move wan")
     world.Execute("#3 zhuan tiewan zuo")
     world.Execute("#7 zhuan tiewan right")
     world.Send("open xiang")
     world.Send("open jiaceng")
     world.Execute("#30 fan painting")
     world.Send("out")
	 local f=function()
       world.Execute("#10 fan painting;out")
	   self:qxwxj_yinlv()
	 end
	 f_wait(f,2)
   end
   w:go(1833)
end

function quest:kill_zuo()
 local w=walk.new()
   w.walkover=function()

      world.Send("kill zuo")
	   local _pfm=world.GetVariable("quest_pfm") or ""

	   world.Execute(_pfm)
	  local f=function()
	     --world.Send("get shuaiyi tie from corpse")
	     world.Send("get wuyue lingqi from corpse")
		 world.Send("get gold from corpse")
		 self:xxdf_item_Next()

	  end
	    self:fight(_pfm,f)
   end
   w:go(311)

end

function quest:meizhuang_quest()

end

function quest:enter_meizhuang()
    wait.make(function()
       world.Send("huida 求见江南四友")
       world.Send("show wuyue lingqi")
	   world.Send("s")

	   local l,w=wait.regexp("不见客",5)
	   if l==nil then
	      self:enter_meizhuang()
	      return
	   end
	   if string.find(l,"不见客") then
		  self:meizhuang_quest()
	      return
	   end
       --world.Execute("s;s;s;e;e;s;s;e;s;w;w;w;n")
       --world.Send("give huang guangling san")
    end)

end

function quest:xxdf()
--1180
  local w=walk.new()
  w.walkover=function()

      local w1=walk.new()
       w1.walkover=function()
         marco("qiao gate 4 times|#wa 1000|qiao gate 2 times|#wa 1000|qiao gate 5 times|#wa 1000|qiao gate 3 times")
         self:enter_meizhuang()
      end
      w1:go(2624)
  end
  w:go(1180)

end

function quest:pumo()
	self.meizhuang_quest=function()
      world.Execute("w;w;s;s;s;w")
       marco("askk sheng about 泼墨披麻剑|#wa 2000|give sheng tu|#wa 2000|askk sheng about 泼墨披麻剑|#wa 1000|guanmo 醉")
	 --  world.Send("")
	 --  world.Send("askk sheng about 泼墨披麻剑")
	 -- world.Send("guanmo 醉")
	  --back
	  local f=function()
	     world.Execute("e;e;n;n;n;e;e")
		 self:qxwxj_yinlv()
      end
	  f_wait(f,8)
	end
	self:xxdf()
end

function quest:qxwxj_yinlv()
   --self.meizhuang_quest=function()
     world.Execute("s;s;s;e;e;s;s;e;s;w;w;w;n")
	  world.Send("give huang guangling san")
	  world.Send("ask huang about 五弦音律")
	--back
	local f=function()
	   world.Execute("s;e;e;e;n;w;n;n;w;w;n;n;n")
	   self:log_time("wxj")
        world.Send("drop lingqi")
        self:leave_meizhuang()
	end
	f_wait(f,8)
  --end
  --self:xxdf()
end

function quest:leave_meizhuang()
    world.Execute("#4 n")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
	 if _R.roomname=="梅林"  then
	    self:Execute()
	 else
	    local f=function()
	       self:leave_meizhuang()
		end
		f_wait(f,5)
	 end
   end
  _R:CatchStart()

end

function quest:wxj(manual_operate)
  -- pumo 和 音律 组成
   local q_record=self:get_log_time("wxj")
	local last_wxj_time=q_record.quest_time
	local wxj_time=os.time()

	local interval=os.difftime(wxj_time,last_wxj_time)
	print(interval,":秒","无形剑间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then
       self.xxdf_item_Next=function()

          self.xxdf_item_Next=function()
		     self.xxdf_item_Next=function()
		       self:pomo()
			 end
			 self:hua()
		  end
		  self:kill_zuo()

       end
       self:guanglingsan()

   else
         self:Execute()
   end
end

--1162
function quest:tianmo(manual_operate)
  local q_record=self:get_log_time("tianmo")
	local last_tianmo_time=q_record.quest_time
	local tianmo_time=os.time()

	local interval=os.difftime(tianmo_time,last_tianmo_time)
	print(interval,":秒","天魔掌间间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
     world.Send("askk ren about 天魔掌绝技")
	 local f=function()
	    self:Execute()
		self:log_time("tianmo")
	 end
	 f_wait(f,2)
  end
  w:go(1162)
   else
         self:Execute()
   end
end

function quest:qbwh(manual_operate)
--千变万化 无形剑法
local q_record=self:get_log_time("qbwh")
	local last_qbwh_time=q_record.quest_time
	local qbwh_time=os.time()

	local interval=os.difftime(qbwh_time,last_qbwh_time)
	print(interval,":秒","千变万化绝技时间间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then
    local w=walk.new()
     w.walkover=function()
     world.Send("askk ren about 千变万化绝技")
	 local f=function()
	    self:Execute()
		self:log_time("qbwh")
	 end
	 f_wait(f,2)
  end
  w:go(1162)
  else
      self:Execute()
  end
end

function quest:ronggong_kill_dongfang(flag)
     local _pfm=world.GetVariable("quest_pfm") or ""
	 print("PK 东方不败")


    local w=walk.new()
    w.walkover=function()
        local cmd="tui qiang|open men|#2 d|w|ask dongfang about 任我行|#wa 1000|kill dongfang|".._pfm

        self:kill_dongfang(cmd)
	end
    w:go(2880)

end


function quest:ronggong_dongfang()

    self.dongfang=function(flag)
	   --
	   print("找东方不败")
	   self:ronggong_kill_dongfang(flag)
	end
    local w=walk.new()
    w.walkover=function()
        self:kuihua_getkey()
	end
    w:go(2881)

end

function quest:back_ronggong()
 local w=walk.new()
  w.walkover=function()
     world.Send("ask ren about 吸星大法融功")
	 self:log_time("ronggong")
	 self:Execute()
  end
  w:go(1162)
end

function quest:ronggong(manual_operate)
--ask 任我行 吸星大法融合    sz 东方不败  ask 东方 任我行   杀人
    local q_record=self:get_log_time("ronggong")
	local last_ronggong_time=q_record.quest_time
	local ronggong_time=os.time()

	local interval=os.difftime(ronggong_time,last_ronggong_time)
	print(interval,":秒","吸星大法融合时间间隔")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then
--回任我行  ask  吸星大法融合
 local w=walk.new()
  w.walkover=function()
     world.Send("ask ren about 吸星大法融功")
	 local f=function()
	    self:ronggong_dongfang(manual_operate)
	 end
	 f_wait(f,3)
  end
  w:go(1162)
   else
     self:Execute()
  end
end
--曲阳
function quest:huayu(manual_operate)
   local q_record=self:get_log_time("huayu")
    local last_huayu_time=q_record.quest_time
	local huayu_time=os.time()

	local interval=os.difftime(huayu_time,last_huayu_time)
	print(interval,":秒","漫天花雨时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
     world.Send("ask qu about 漫天花雨绝技")
	 self:log_time("huayu")
	 self:Execute()
  end
  w:go(2873)
  else
     self:Execute()
  end
end
--童百熊
function quest:tianmodao(manual_operate)
  local q_record=self:get_log_time("juedao")
    local last_juedao_time=q_record.quest_time
	local juedao_time=os.time()

	local interval=os.difftime(juedao_time,last_juedao_time)
	print(interval,":秒","漫天花雨时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
  local w=walk.new()
  w.walkover=function()
     world.Send("ask tong about 天魔绝刀")
	 self:log_time("juedao")
	 self:Execute()
  end
  w:go(2868)
   else
     self:Execute()
  end
end

function quest:qz_haotian_lianhuan_finish()
  local l=wait.make(function()
    local l,w=wait.regexp("^(> |)现在是白天，你无法观悟北斗七星阵势变化！$|^(> |)你盘膝而坐，五心向天，观悟天上北斗七星运转变化，心中潮起潮落，万物寂寥！$|^(> |)你来的太频繁了.*$",5)
	if l==nil then

	   self:qz_haotian_lianhuan_finish()
	   return
	end
	if string.find(l,"现在是白天，你无法观悟北斗七星阵势变化") then
	  local f=function()
	      world.Send("canwu 北斗七星")
	      self:qz_haotian_lianhuan_finish()
	   end
	   f_wait(f,10)
	   return
	end
    if string.find(l,"你来的太频繁了") then
	   world.Execute("d;ed;sd;wd;out")
	    self:Execute()
		return
	end
    if string.find(l,"你盘膝而坐，五心向天") then
		world.AddTimer ("lianhuan_timer", 0, 0, 10, "look", timer_flag.Enabled + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
		world.SetTimerOption ("lianhuan_timer", "send_to", 10)
		local f=function()
	      local b=busy.new()
		  b.interval=15
          b.Next=function()
           self:log_time("qz_lianhuan")
	       world.Execute("d;ed;sd;wd;out")
	       world.DeleteTimer("lianhuan_timer")
	       self:Execute()
	      end
	     b:check()
    	end
	    f_wait(f,90)
	   return
	end
  end)

end



function quest:qz_haotian_lianhuan(manual_operate)

--4151
--重阳连环掌绝技
local q_record=self:get_log_time("qz_lianhuan")
    local last_qz_lianhuan_time=q_record.quest_time
	local qz_lianhuan_time=os.time()

	local interval=os.difftime(qz_lianhuan_time,last_qz_lianhuan_time)
	print(interval,":秒","昊天掌连环时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
      world.Send("ask ma about 重阳连环掌绝技")
	  local b=busy.new()
	  b.interval=10
	  b.Next=function()
       local w2=walk.new()
	   w2.walkover=function()
         world.Execute("ketou 画;ketou 画;ketou 画;ketou 画;ketou 画;ketou 画")
         world.Execute("ketou 青砖;ketou 青砖;ketou 青砖;ketou 青砖;ketou 青砖;ketou 青砖;rukou;eu;nu;wu;u;canwu 北斗七星")
         self:qz_haotian_lianhuan_finish()
       end
	   w2:go(7063)
	 end
     b:check()
  end
  w:go(4151)
  else
     self:Execute()
  end
end

function quest:qz_jgys(manual_operate)

--4151
--重阳连环掌绝技
local q_record=self:get_log_time("qz_jgys")
    local last_qz_jgys_time=q_record.quest_time
	local qz_jgys_time=os.time()

	local interval=os.difftime(qz_jgys_time,last_qz_jgys_time)
	print(interval,":秒","jgys时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
      world.Send("qu yusuo jingyao")
	  local b=busy.new()
	  b.Next=function()
       local w2=walk.new()
	   w2.walkover=function()
	     world.Send("sit")
         world.Send("canwu 金关玉锁二十四诀")
		 world.Send("stand")
		world.AddTimer ("jgys_timer", 0, 0, 10, "look", timer_flag.Enabled + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
		world.SetTimerOption ("jgys_timer", "send_to", 10)
		 local f=function()

           local b=busy.new()
		   b.interval=30
		   b.Next=function()
             world.DeleteTimer("jgys_timer")
			 self:log_time("qz_jgys")

		      self:Execute()
		   end
		   b:check()
		 end
		 f_wait(f,80)
       end
	   w2:go(4162)
	 end
     b:check()
  end
  w:go(94)
  else
     self:Execute()
  end
end

--han 帮主；han 帮主; han 七公;han 师父

function quest:tieqiangmiao()
   local w=walk.new()
   w.walkover=function()
     world.Execute("han 帮主;han 帮主;han 七公;han 师父")
   end
   w:go(4012)
end

--龙象绝技
function quest:dls_longxiang(manual_operate)
 local q_record=self:get_log_time("dls_longxiang")
 local last_dls_longxiang_time=q_record.quest_time
	local dls_longxiang_time=os.time()

	local interval=os.difftime(dls_longxiang_time,last_dls_longxiang_time)
	print(interval,":秒","龙象般若时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then


   local w=walk.new()
   w.walkover=function()

     marco("askk zhi about 大轮寺绝技|#wa 3000|answer 龙象般若功|#wa 3000|fankan jingshu|#wa 3000|canwu 龙象般若经")
	 world.AddTimer ("longxiang_time", 0, 0, 15, "look", timer_flag.Enabled +timer_flag.ActiveWhenClosed+timer_flag.Replace, "")
       world.SetTimerOption ("longxiang_time", "send_to", 10)
	 local f=function()
	  local b=busy.new()
		b.Next=function()
		   world.DeleteTimer("longxiang_time")
           self:log_time("dls_longxiang")
		   world.Execute("open door;down")
		   self:Execute()
		end
		b:check()
	 end
	 f_wait(f,90)
   end
   w:go(3060)

    else
     self:Execute()
  end
end
--火焰刀绝技

function quest:dls_hyd(manual_operate)
 local q_record=self:get_log_time("dls_hyd")
 local last_dls_hyd_time=q_record.quest_time
	local dls_hyd_time=os.time()

	local interval=os.difftime(dls_hyd_time,last_dls_hyd_time)
	print(interval,":秒","火焰刀时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

    self:jiumozhi()
	--[[
   local w=walk.new()
   w.walkover=function()

     marco("askk zhi about 大轮寺绝技|#wa 1000|answer 火焰刀绝技")
	wait.make(function()

	  local l,w=wait.regexp(".*你来的太勤快了.*|",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"你来的太勤快了") then
	     self:Execute()
	     return
	  end
	  if string.find(l,"") then
	   local b=busy.new()
		b.Next=function()
            self:gotoTLS()
		end
		b:check()
	     return
	  end


	end)


   end
   w:go(3060)
]]
    else
     self:Execute()
  end
end

function quest:jiumozhi()
local w=walk.new()
   w.walkover=function()
      world.Send("give zhi jianpu")
      world.Execute("askk zhi about 碧烟纵横绝技")
	  wait.make(function()
	     local l,w=wait.regexp("^(> |)鸠摩智严肃的看着你.*",5)
		 if l==nil then

		   return
		 end

		 if string.find(l,"鸠摩智严肃的看着你") then
		     self:log_time("hyd")
	         self:Execute()
		   return
		 end
	  end)

   end
   w:go(3060)
end

function quest:get_liumai()
--Liumai jianpu
    world.Send("get liumai jianpu")
	wait.make(function()
	  local l,w=wait.regexp("你捡起一本六脉神剑谱。",5)

	  if l==nil then
	      self:get_liumai()
		  return

	  end
	  if string.find(l,"你捡起一本六脉神剑谱") then
	    self:jiumozhi()
	     return
	  end
	end)
end

function quest:huoyandao_liumai()
   local w=walk.new()
   w.walkover=function()
      local pfm="bei none;jifa parry huoyan-dao;jifa strike huoyan-dao;bei strike;yun longxiang;yun shield;perform daoqi"
      world.Send("alias pfm "..pfm)
      marco("baijian 枯荣长老|#wa 1000|doujian")
	  world.Send("set wimpy 100")
	  local f=function()
	     self:get_liumai()
	  end
	  f_wait(f,30)
   end
   w:go(2358)
end

function quest:gotoTLS()

   local w=walk.new()
   w.walkover=function()

     marco("askk chanshi about 拜见枯荣大师|#wa 1000|give chanshi baitie")
	 --对方不接受这样东西。
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)对方不接受这样东西。$",5)
	   if l==nil then
	      self:gotoTLS()
	      return
	   end
	   if string.find(l,"对方不接受这样东西") then

	       self:huoyandao_liumai()
		  return
	   end

	 end)
	 local f=function()
	  local b=busy.new()
		b.Next=function()
           self:huoyandao()
		end
		b:check()
	 end

   end
   w:go(1604)


end

function quest:arz_start()
  local q_record=self:get_log_time("arz")
 local last_arz_time=q_record.quest_time
	local arz_time=os.time()

	local interval=os.difftime(arz_time,last_arz_time)
	print(interval,":秒","黯然掌时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then


   local w=walk.new()
   w.walkover=function()
     marco("askk yang about 黯然销魂掌")
	 local f=function()
	  local b=busy.new()
		b.Next=function()
           self:log_time("arz")
		   self:Execute()
		end
		b:check()
	 end
	 f_wait(f,60)
   end
   w:go(3017)

    else
     self:Execute()
  end
end

function quest:qz_guilingao()
  local w=walk.new()
  w.walkover=function()
    world.Send("buy fu ling")
	 local w1=walk.new()
  w1.walkover=function()
     world.Send("buy gui jia")

	 local w2=walk.new()
	 w2.walkover=function()
	    world.Exectute("give daozhang gui jia;give daozhang fu ling")


	 end
	 w2:go(4141)
  end
  w1:go(636)

  end
  w:go(2982)


end

function quest:qixingjian(manual_operate)

local q_record=self:get_log_time("jianqi")
 local last_jianqi_time=q_record.quest_time
	local jianqi_time=os.time()

	local interval=os.difftime(jianqi_time,last_jianqi_time)
	print(interval,":秒","全真剑气时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
    marco("ask sun about 王重阳|#wa 3000|ask sun about 七星宝剑")
	local f=function()
     self:jianqi()
	end
	f_wait(f,5)

  end
  w:go(4172)

   else
     self:Execute()
  end
end


function quest:ask_jianqi()
    world.Send("askk qiu about 全真剑气")


	 wait.make(function()

	   local l,w=wait.regexp("^(> |)丘处机对你说道：我现在无法看见天空中北斗七星，又如何指导你学习全真剑法的剑诀精髓。$|^(> |)丘处机严肃的看着你，慢慢说道：“我派的全真剑法讲究的是道家观测宇宙星斗北斗七星变换之道，取千变万化、无穷无尽之原理.*",5)
	   if l==nil then
	      self:ask_jianqi()
	      return
	   end
	   if string.find(l,"指导你学习全真剑法的剑诀精髓") then
	     local f=function()
	        self:ask_jianqi()
          end
		  f_wait(f,30)
	      return
	   end
	   if string.find(l,"变换之道") then
           wait.time(5)
	       local b=busy.new()
		   b.Next=function()
		    world.Send("qingjiao")
            self:log_time("jianqi")
		    self:Execute()
		   end
	 	   b:check()

	   end
   end)
end

function quest:jianqi()
  local w=walk.new()
  w.walkover=function()
     self:ask_jianqi()
  end

   w:go(4152)
end

function quest:yyz(manual_operate)

 local q_record=self:get_log_time("yyz")
 local last_yyz_time=q_record.quest_time
	local yyz_time=os.time()

	local interval=os.difftime(yyz_time,last_yyz_time)
	print(interval,":秒","一阳指时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
    marco("ask duan about 一阳指神功|#wa 3000|askk duan about 指剑绝技|#wa 3000|askk duan about 阳关三叠")



		 local b=busy.new()
		   b.Next=function()

            self:log_time("yyz")
		    self:Execute()
		   end
	 	   b:check()
  end
  w:go(1084)

   else
     self:Execute()
  end
end


function quest:yysz(manual_operate)
local q_record=self:get_log_time("yysz")
 local last_yysz_time=q_record.quest_time
	local yysz_time=os.time()

	local interval=os.difftime(yysz_time,last_yysz_time)
	print(interval,":秒","一阳指时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
 local w=walk.new()
  w.walkover=function()
    world.Send("ask shu about 一阳书指")
	self:log_time("yysz")
		 local b=busy.new()
		   b.Next=function()

            self:log_time("yysz")
		    self:Execute()
		   end
	 	   b:check()
  end
  w:go(2728)
   else
     self:Execute()
  end
end


function quest:tiezhang_zhangdao(manual_operate)
  local q_record=self:get_log_time("zhangdao")
 local last_zhangdao_time=q_record.quest_time
	local zhangdao_time=os.time()

	local interval=os.difftime(zhangdao_time,last_zhangdao_time)
	print(interval,":秒","铁掌掌刀时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()
        world.Send(" askk qiu about 铁掌掌刀绝技")

		 local b=busy.new()
		   b.Next=function()

            self:log_time("zhangdao")
		    self:Execute()
		   end
	 	   b:check()
      end
      w:go(2389)
   else
     self:Execute()
  end


end


function quest:kurong(manual_operate)
  local q_record=self:get_log_time("kurong")
 local last_kurong_time=q_record.quest_time
	local kurong_time=os.time()

	local interval=os.difftime(kurong_time,last_kurong_time)
	print(interval,":秒","枯荣禅功时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()
        world.Send("askk kurong about 枯荣禅功")
	     local b=busy.new()
		   b.Next=function()

            self:log_time("kurong")
		    self:Execute()
		   end
	 	   b:check()
      end
      w:go(3082)
   else
     self:Execute()
  end


end

function quest:zhenlong(manual_operate)
  local q_record=self:get_log_time("zhenlong")
 local last_zhenlong_time=q_record.quest_time
	local zhenlong_time=os.time()

	local interval=os.difftime(zhenlong_time,last_zhenlong_time)
	print(interval,":秒","珍珑棋局时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()
        world.Send("askk su about 珍珑棋局")
		world.Send("look zhenlong")

		  local b=busy.new()
		   b.Next=function()

            self:log_time("jianqi")
		    self:Execute()
		   end
	 	   b:check()

      end
      w:go(7011)
   else
     self:Execute()
   end

end

function quest:huagong(manual_operate)
  local q_record=self:get_log_time("huagong")
 local last_huagong_time=q_record.quest_time
	local huagong_time=os.time()

	local interval=os.difftime(huagong_time,last_huagong_time)
	print(interval,":秒","珍珑棋局时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()
        world.Send("askk ding about 化功大法奥秘")
		--world.Send("look zhenrong")

		 local b=busy.new()
		   b.Next=function()

            self:log_time("huagong")
		    self:Execute()
		   end
	 	   b:check()
      end
      w:go(1964)
   else
     self:Execute()
  end

end


function quest:taiji(manual_operate)
  local q_record=self:get_log_time("taiji")
 local last_taiji_time=q_record.quest_time
	local taiji_time=os.time()

	local interval=os.difftime(taiji_time,last_taiji_time)
	print(interval,":秒","武当绝世时间间隔")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()

        marco("askk zhang about 太极剑诀|#wa 3000|askk zhang about 太极拳绝技|#wa 30000|askk zhang about 太极剑绝技")
	   world.AddTimer ("taiji_time", 0, 0, 15, "look", timer_flag.Enabled +timer_flag.ActiveWhenClosed+timer_flag.Replace, "")
       world.SetTimerOption ("taiji_time", "send_to", 10)
		local f=function()
		--world.Send("look zhenrong")

		 local b=busy.new()
		   b.Next=function()
		    world.DeleteTimer("taiji_time")
            self:log_time("taiji")

		    self:Execute()
		   end
	 	   b:check()
		end
		f_wait(f,120)
      end
      w:go(2772)
   else
     self:Execute()
  end

end


--[[
function quest:yyz_dbf()
  baohu 王妃
  418

  ask duan about 保护王妃
  481


end


function quest:yyz_mwq()

  askk duan about 保护木婉清
  g481


  #4n
  askk huanghou about 木婉清
  askk huanghou about 玉镯

   w:go(1084)
   w:go(611)
   baohu 木婉清
end


function quest:qhm()
  w:go(2409)
  askk qin about 段正淳
answer 确认
baohu 秦红棉
end

function quest:gbb()
  askk gan about 段正淳
  baohu 甘宝宝
  w:go(3113)
end

function quest:bhnhs()
  askk duan about 保护拈花寺
  g584
end]]


--[[
function quest:shediao()

  askk qiu about 风雪惊变
   askk qiu about 救人
  g(4152)
end

function quest:getshouji()
   l mugan
    pa mugan
	你顺着这个木杆爬上去，小心取下郭啸天的首级收好,并爬了下来！
   g7041
end

function quest:()
  mai 郭啸天首级
  你刚偷了首级并安葬，难道想自投罗网？
  1171
end

function quest:duantiande()
  han 段天德
  g7041
  askk zhihuishi about 段天德
  zhua duan
   g7040
end

function quest:duantiande2()
  ask dashi about 段天德
  1207


  7044
end

function quest:doujiu()
   drop tong gang;ask pao tang about 铜缸装酒;get tong gang;up;ask dashi about 我已经到了;ask dashi about 评理
   get tong gang;jing jiu;jing 柯镇恶;jing 韩小莹;jing 全金发;jing 韩宝驹;jing 朱聪;jing 南希仁;jing 张阿生;doujiu 江南七怪

   gt烟雨楼
end

function quest:fahuasi()
   alias pfm
   zhuang zhong
   dadu 江南七怪
   gt法华寺
end

]]
--wu


--s3enw2ne
--w2ses3wn
--wse
--[[
qiao gate 4 times
qiao gate 2 times
qiao gate 5 times
qiao gate 3 times

出来俩仆人后:
huida 求见江南四友
show wuyue lingqi

s;s;s进入梅庄

按下列步骤给每个人东西

广陵散
give huang guangling san
黄钟公对着你「哈哈哈」大笑几声

呕血谱
give zi ouxue pu
黑白子对着你「哈哈哈」大笑几声。

率意帖
give weng shuaiyi tie
秃笔翁对着你「哈哈哈」大笑几声

溪山行旅图
give sheng tu
丹青生对着你「哈哈哈」大笑几声。

「一字电剑」丁坚(Ding jian)
kill ding

zuan table
ask wizard about 贵宾专享
戚少商
go north
go north
pull floor
d

go north
go east
go north
go north
go east
go east
go north
go west
go north
go south

kai men
go north

{zuan table;n;n;pull floor;d;n;e;n;n;e;e;n;w;n;s;kai men;n;ask ren about 比剑}
ask ren about 比剑

move man

l miji
read miji

push men]]

