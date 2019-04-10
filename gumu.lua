
gumu={
   new=function()
     local gm={}
	 setmetatable(gm,gumu)
	 return gm
   end,
}
gumu.__index=gumu
--离开活死人墓 115 基本内功  500内力
--拜小龙女要求 120 玉女心经 100 基本剑法

function gumu:get_pots(path,back_path,callback)
   world.Execute(path)
   world.Send("qn_qu 3000")
   wait.make(function()
      local l,w=wait.regexp("^(> |)你从银行里取出.*点潜能。$",5)
	  if l==nil then
	     self:get_pots(path,back_path,callback)
	     return
	  end
	  if string.find(l,"你从银行里取") then
		 world.Execute(back_path)
		 callback()
	     return
	  end

   end)
end

function gumu:canwu_literate()  --5070
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 read qiang;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你的潜能没了，不能再继续修习了。$|^(> |)你已经完全读懂了墙上的文字。$",10)
	 if l==nil then
	    self:canwu_literate()
	    return
	 end
	 if string.find(l,"你的潜能没了") then
	    local f=function()
		   self:canwu_literate()
		end
	    self:get_pots("open door;w;w;w;w;out;up","d;enter;e;e;e;open door;e",f)
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:canwu_literate()
	    return
	 end
	 if string.find(l,"你已经完全读懂了墙上的文字") then
	    shutdown()
        self:lingwu_skills()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:canwu_literate()
		end
		local path="open door;w;w;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;e;open door;e",f)
	    return
	 end
   end)
end

function gumu:canwu_parry51() --5063 50 parry
    world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 yanxi ground;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你对着地上研习一会，只觉所述早已尽藏心胸。$",10)
	 if l==nil then
	    self:canwu_parry51()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:canwu_parry51()
	    return
	 end
	 if string.find(l,"你对着地上研习一会，只觉所述早已尽藏心胸") then
	    shutdown()
		wait.time(0.8)
		world.Send("yanxi top")
	    self:lingwu_skills()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:canwu_parry51()
		end
		local path="s;e;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;w;n",f)
	    return
	 end
   end)
end

function gumu:canwu_parry101() --5063 50 parry
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 yao tree;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你使劲地摇晃大树，发现大树快被你摇断了。$",10)
	 if l==nil then
	    self:canwu_parry101()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:canwu_parry101()
	    return
	 end
	 if string.find(l,"你使劲地摇晃大树，发现大树快被你摇断了") then
	    shutdown()
		wait.time(0.8)
		--world.Send("yanxi top")
	    self:lingwu_skills()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:canwu_parry101()
		end
		local path="n;enter;e;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;w;out;s",f)
	    return
	 end
   end)
end

function gumu:canwu_force() --5063 50 force
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 yanxi wall;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)石壁所述尽在你心，你无法再悟出什么新东西。$",10)
	 if l==nil then
	    self:canwu_force()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:canwu_force()
	    return
	 end
	 if string.find(l,"石壁所述尽在你心，你无法再悟出什么新东西") then
	    shutdown()
		wait.time(0.8)
		world.Send("yanxi top")
	    self:lingwu_skills()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:canwu_force()
		end
		local path="s;e;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;w;n",f)
	    return
	 end
   end)
end
--yanxi top quanzhen-jianfa sword >10 yanxi top 5059  yunu-jianfa 5073
function gumu:canwu_sword51()  --古墓练功房1 eastwall 51 练功房2 westwall 100 5059
    world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 xiulian eastwall;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你对石壁上所述剑法已全然掌握,无须再费力了. $",10)
	 if l==nil then
	    self:canwu_sword51()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:canwu_sword51()
	    return
	 end
	 if string.find(l,"你对石壁上所述剑法已全然掌握") then
	    shutdown()
		local gender=world.GetVariable("gender") or ""
		if gender=="男性" then
		   world.Send("yanxi top")
		else
		   world.Execute("tui eastwall;enter;yanxi top")
		end
        self:lingwu_skills()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:canwu_sword51()
		end
		local path="s;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;n",f)
	    return
	 end
   end)
end

function gumu:canwu_sword101()  --古墓练功房1 eastwall 51 练功房2 westwall 100 5073
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 xiulian westwall;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)由于实战经验不足，阻碍了你的「.*」进步！$|^(> |)你对石壁上所述剑法已全然掌握,无须再费力了. $",10)
	 if l==nil then
	    self:canwu_sword101()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:canwu_sword101()
	    return
	 end
	 if string.find(l,"你对石壁上所述剑法已全然掌握") then
	    shutdown()
		self:lingwu_skills()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:canwu_sword101()
		end
		local path="tui westwall;out;s;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;n;tui eastwall;enter",f)
	    return
	 end
   end)
end

function gumu:canwu_dodge51()  --古墓练功房1 eastwall 51 练功房2 westwall 100 5073
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 zhuo maque;yun jing;yun jingli")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你不用在这里浪费时间精力了。$|^(> |)由于实战经验不足，阻碍了你的「.*」进步！$",10)
	 if l==nil then
	    self:canwu_dodge51()
	    return
	 end
	 if string.find(l,"你不用在这里浪费时间精力了") or string.find(l,"实战经验不足") then
	     shutdown()
	     self:lingwu_skills()
	     return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:canwu_dodge51()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:canwu_dodge51()
		end
		local path="open door;n;e;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;open door;s",f)
	    return
	 end
   end)
end

function gumu:canwu_dodge101()  --古墓练功房1 eastwall 51 练功房2 westwall 100 5073
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 zhuo maque;yun jing;yun jingli")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)由于实战经验不足，阻碍了你的「.*」进步！$|^(> |)你不用在这里浪费时间精力了。$",10)
	 if l==nil then
	    self:canwu_dodge101()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:canwu_dodge101()
	    return
	 end
	 if string.find(l,"你不用在这里浪费时间精力了") then
	    shutdown()
		world.Execute("s;s;#5 zhuo maque")
		self:lingwu_skills()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:canwu_dodge101()
		end
		local path="out;open door;n;e;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;open door;s;enter",f)
	    return
	 end
   end)
end

function gumu:sleep(path,back_path,callback) --5050
   wait.make(function()
      local l,w=wait.regexp("^(> |)你一觉醒来，觉得精力充沛，该活动一下了。$|^(> |)你一觉醒来，由于睡得太频繁，精神不是很好。$",15)
	  if l==nil then
		 self:sleep(path,back_path,callback)
	     return
	  end
	  if string.find(l,"你一觉醒来") then
	     world.Execute(back_path)
		 callback()
	     return
	  end
   end)
end

function gumu:zuobed() --5050 51
   world.Execute("#10 zuo bed;yun jing")
    wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你的潜能没了，不能再继续修习了$|^(> |)你的玉女心经已有相当火厚,寒玉床不能再助你修习内功了。$",10)
	 if l==nil then
	    self:zuobed()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.8)
		self:zuobed()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:zuobed()
		end
		local path="sleep"
		world.Execute(path)
	    self:sleep(path,"ok",f)
	    return
	 end
	if string.find(l,"你的玉女心经已有相当火厚") then
	    self:lingwu_skills()
	    return
	end
	   if string.find(l,"你的潜能没了") then
	    local f=function()
		   self:zuobed()
		end
		local b=busy.new()
		b.Next=function()
	       self:get_pots("n;w;w;out;up","d;enter;e;e;s",f)
		end
		b:check()
	    return
	 end
   end)
end

function gumu:yanxi_table() --5049 120
    world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 yanxi table;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你的潜能没了，不能再继续修习了$|^(> |)你对着桌上的古琴研究了一番，发现它很值钱。$|^(> |)由于实战经验不足，阻碍了你的「.*」进步！$",10)
	 if l==nil then
	    self:yanxi_table()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.5)
		self:yanxi_table()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:yanxi_table()
		end
		local path="w;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;e",f)
	    return
	 end
	 if string.find(l,"你对着桌上的古琴研究了一番") then
	     world.Send("nuo qin")
		 self:yanxi_table()
	    return
	 end
	 if string.find(l,"由于实战经验不足") then
	    shutdown()
	    self:lingwu_skills()
	    return
	 end
	  if string.find(l,"你的潜能没了") then
	    local f=function()
		   self:yanxi_table()
		end
		local b=busy.new()
		b.Next=function()
	       self:get_pots("w;w;w;out;up","d;enter;e;e;e",f)
		end
		b:check()
	    return
	 end
   end)
end

function gumu:tanqin() --5049 51 force 120
    world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 tan qin;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|由于实战经验不足，阻碍了你的「基本内功」进步！",10)
	 if l==nil then
	    self:tanqin()
	    return
	 end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") then
	    wait.time(0.3)
		self:tanqin()
	    return
	 end
	 if string.find(l,"由于实战经验不足") then
	    shutdown()
		self:lingwu_skills()
	    return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:tanqin()
		end
		local path="w;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;e",f)
	    return
	 end

   end)
end

function gumu:lingwu_skills()

   local level_literate
   local level_force
   local level_yunu
   local level_sword

  local lw=lingwu.new()
  lw.exps=tonumber(world.GetVariable("exps")) or 0
   lw.get_skills_end=function()
      level_literate=lw:get_skill("literate")
	  level_force=lw:get_skill("force")
	  level_yunu=lw:get_skill("yunu-xinjing")
	  level_sword=lw:get_skill("sword")
	  level_dodge=lw:get_skill("dodge")
	  level_parry=lw:get_skill("parry")
	  print(level_literate)
	  print(level_force)
	  print(level_yunu)
	  print(level_parry)
	  print(level_sword," 剑法")
	  print(level_dodge," 轻功")
	   print(lw.max_level," max_level")

	local work={}
	local w=walk.new()
	w.walkover=function()
	   work()
	end
    --玉女心经 51 120

		  --force 51  120
   if level_force<51 and level_force<lw.max_level then
       work=function() self:canwu_force() end
	   w:go(5063)
	   return
   end

   if level_yunu<51 and level_yunu<lw.max_level then
      work=function() self:zuobed() end
	  w:go(5048)
      return
   end

     --literate 150
   if level_literate<150 then
	   work=function() self:canwu_literate() end
	   w:go(5070)
	   return
   end
   --print(level_yunu," yunu max ",lw.max_level)
   if level_yunu<120 and level_yunu<lw.max_level then
      work=function() self:yanxi_table() end
	  w:go(5069)
      return
   end

   if level_force<=115 and level_force<lw.max_level then
       work=function() self:tanqin() end
	   w:go(5069)
      return
   end

  --sword 51 100
  if level_sword<51 and level_sword<lw.max_level then
      work=function()
      self:canwu_sword51()
	  end
	  w:go(5059)
      return
  end
  if level_sword<100 and level_sword<lw.max_level then
     work=function()
     self:canwu_sword101()
	 end
	 w:go(5073)
     return
  end
    --sword 51 100
  if level_dodge<51 and level_dodge<lw.max_level then
      work=function()
      self:canwu_dodge51()
	  end
	  w:go(5060)
      return
  end
  if level_dodge<101 and level_dodge<lw.max_level then
     work=function()
     self:canwu_dodge101()
	 end
	 w:go(5061)
     return
  end
  if level_parry<51 and level_parry<lw.max_level then
     work=function()
       self:canwu_parry51()
	 end
	 w:go(5063)
     return
  end
  if level_parry<101 and level_parry<lw.max_level then
     work=function()
       self:canwu_parry101()
	 end
	 w:go(5094)
     return
  end
    world.Send("unset 积蓄") --打坐到500
    process.neigong3()

   end

   lw:get_exps()
end

function gumu:leave()
--tang bed
--[[ local w=walk.new()
 w.walkover=function()
   world.Execute("tang bed;ban shiban;out;e;e;e;e;e;e;w;w;w;w;w;w;n;n;n;n;n;n;s;s;s;s;s;s")


   enter
tui guangai
tang guan
use fire
search
search
search
search
search
search
search
search
search
turn ao left
ti up
l map

> l ceiling
> l zi

walk down
wd
w
wu
nu
out
nw
n
n
e
e
se
s
s
s
s
s
s
e
n
 end
 w:go(5050)
 读书写字0-101级{e;e} 石室 read qiang (需用潜能)
基本内功0-51级：{w;w;n} 领悟室 yanxi wall
基本内功50-101级：{e} 琴室 tan qin
玉女心经0-51级：{s} 卧室 zuo bed (需用潜能)
玉女心经51-101级：{e} 琴室 nuo qin;yanxi table (需用潜能)
基本招架0-51级：{w;w;n} 领悟室 yanxi ground
基本招架51-101级：{w;w;out;s} 悬崖 yao tree
基本轻功0-51级：{w;open door;s;} 石室 zhuo maque
基本轻功51-101级：{w;open door;s;enter} 石室 zhuo maque
基本剑法0-51级：{w;n} 练功房 xiulian eastwall
基本剑法51-101级：{w;n;tui eastwall;enter} 练功房 xiulian westwall
基本拳法0-51级：{w;n} 练功房 xiulian backwall
基本拳法51-101级：{w;n;tui eastwall;enter} 练功房 xiulian frontwall
美女拳法：{w;w;out;n} 果园 zhao quan (要求基本拳法51级)
玉女身法：{w;w;n} 领悟室  yanxi top   (要求 dodge>20)
玉女素心剑法：{w;n;tui eastwall:enter} 练功房 yanxi top (要求基本剑法30级)
基本掌法0-51级：{w;n} 练功房 xiulian frontwall
基本掌法51-101级：{w;n;tui eastwall:enter} 练功房 xiulian backwall
全真剑法：{w;n} 练功房 yanxi top (要求基本剑法30级)
天罗地网: {w;s;enter;s} 石室 zhuo maque *只限男弟子

 ]]
end

