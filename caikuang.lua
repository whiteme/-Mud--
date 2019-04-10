
--[[> ask tiejiang about job
你向铁匠打听有关『job』的消息。
铁匠正盯着你看，不知道打些什么主意。
铁匠在你的耳边悄声说道：听说在苏州城翰林府院周围方圆八里内发现了新奇的矿石，你去给我找来。
铁匠说道：「我不会亏待你的。」
wield tieqiao
你拿起一柄铁锹。
> 蓝云依辉周身的寒气散尽，不再能起到保护的作用了。
caikuang kuangshi
你仔细地搜索矿石的踪迹......

可惜什么都没有找到。
苏州北郊 - northwest、south、southwest、west
> s
北门 - north、south、west
　武将(Wu jiang)
　腐烂的女尸(Nv shi)
　二位官兵(Guan bing)
> caikuang kuangshi
你仔细地搜索矿石的踪迹......

可惜什么都没有找到。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
北门兵营 - east、west
　四位官兵(Guan bing)
　武将(Wu jiang)
　童松(Tong song)
　钢剑(Jian)
　铁甲(Tie jia)
> caikuang kuangshi
你仔细地搜索矿石的踪迹......

可惜什么都没有找到。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
你的动作还没有完成，不能移动。
> w
监狱 - east
　丁典(Ding dian)
> caikuang kuangshi
你仔细地搜索矿石的踪迹......

似乎有所发现.....
> 你从土里挖出一块从来没有见过的矿石！
i
你身上带着七件东西(负重 20.44)：
　二十二文铜钱(Coin)
　二十三锭黄金(Gold)
　二两白银(Silver)
□铁锹(Tieqiao)
□布履(Shoes)
□白色道袍(Pao)
　一块未知矿石(Weizhi kuangshi)
> l kuangshi
未知矿石(Weizhi kuangshi)
这是一块还没有人能够识别的新奇矿石。
> l
监狱 -
　　这里是监狱，约莫两丈见方的一间大石室，墙壁和顶板都是大石所砌。
墙角里放着一只粪桶，鼻中闻到的尽是臭气和霉气。从西面墙上的小窗望
去，可以见到翰林府的一角。
　　这里唯一的出口是 east。
　丁典(Ding dian)
> e
你的动作还没有完成，不能移动。
打铁铺 - south
　铁匠(Tiejiang)
> give tiejiang kuangshi
铁匠对着你鼓起掌来，干得好。
铁匠说道：「好啊，我又收集到一块新奇的矿石，说不定哪天就能造出一把神兵利器！」
铁匠仔细传授你采矿的诀窍，你的采矿技术提升了四百七十一点技能点数，和二十三点经验！--]]


caikuang={
   new=function()
     local ck={}
	 setmetatable(ck,{__index=caikuang})
	 return ck
   end,
   co=nil,
   max_rooms=40,
   to_play_id="",
   version=1.8,
}

function caikuang:fail(id)
end

function caikuang:ask_tiejiang()
  wait.make(function()
     world.Send("ask tiejiang about job")
	 local l,w=wait.regexp("^(> |)铁匠在你的耳边悄声说道：听说在(.*)周围方圆(.*)里内发现了新奇的矿石，你去给我找来。$|^(> |)铁匠说道：「你太忙了吧，要注意休息啊。」$",5)
	 --铁匠在你的耳边悄声说道：听说在兰州城景泰周围方圆一里内发现了新奇的矿石，你去给我找来。
	 if l==nil then
		self:ask_job()
	    return
	 end
	 if string.find(l,"铁匠在你的耳边悄声说道") then
	    local place=w[2]
		local range=w[3]
		r=ChineseNum(range)
		print(place,r)
		self:find(place,r)
		return
	 end
     if string.find(l,"你太忙了吧，要注意休息啊") then
	    self.fail(101)
	    return
	 end
  end)
end

function caikuang:ask_job()
   local w=walk.new()
   w.walkover=function()
      self:ask_tiejiang()
   end
   w:go(76)
end

function caikuang:find(place,range)
  local n,e=Where(place)
  local rooms=depth_search(e,range)  --范围查询
    if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   caikuang.co=coroutine.create(function()
	     self:Search(rooms)
		 print("没有找到矿石!!")
		 self:giveup()
	   end)
	   local b2
	   b2=busy.new()
	   b2.interval=0.5
	   b2.Next=function()
	     self:NextPoint()
	   end
	   b2:check()
	 end
	 b:check()
	else
	  print("没有目标 或 目标房间过多")
	  self:giveup()
	end
end

function caikuang:NextPoint()
   print("进程恢复")
   coroutine.resume(caikuang.co)
end

function caikuang:caikuang_end()
   wait.make(function()
      local l,w=wait.regexp("^(> |)可惜什么都没有找到。$|^(> |)你从土里挖出一块从来没有见过的矿石！$",5)
	  if l==nil then
	     self:caikuang_end()
	     return
	  end
	  if string.find(l,"可惜什么都没有找到") then
	     local b=busy.new()
		 b.interval=0.8
		 b.Next=function()
		     self:NextPoint()
		 end
		 b:check()
	     return
	  end
      if string.find(l,"你从土里挖出一块从来没有见过的矿石") then
	     local b=busy.new()
		 b.interval=0.8
		 b.Next=function()
		     self:reward()
		 end
		 b:check()
	     return
	  end
   end)
end

function caikuang:caikuang()
  wait.make(function()
    world.Send("wield qiao")
    world.Send("caikuang kuangshi")
	local l,w=wait.regexp("^(> |)你仔细地搜索矿石的踪迹.*$|^(> |)你必须先放下你目前装备的武器。$",5)
	if l==nil then
	   self:caikuang()
	   return
	end
	if string.find(l,"你仔细地搜索矿石的踪迹") then
	   self:caikuang_end()
	   return
	end
	if string.find(l,"你必须先放下你目前装备的武器") then
	    local sp=special_item.new()
		sp.cooldown=function()
			self:caikuang()
		end
	    sp:unwield_all()
	   return
	end
  end)
end

function caikuang:Search(rooms)
   for i,r in ipairs(rooms) do
      if i>self.max_rooms then
	     break
	  end
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      --self:giveup()
			  --self:beauty_exist()
			  self:NextPoint()
		  end
		  w.user_alias=al
		  w.noway=function()
		     self:NextPoint()
		  end
		  w.walkover=function()
			self:caikuang()
		  end
		  --
		  w:go(r)
		  coroutine.yield()
   end
end

function caikuang:jobDone()  --接口函数 回调
end

function caikuang:reward()
    local w=walk.new()
   w.walkover=function()
     if self.to_play_id~="" then
	    world.Send("give kuangshi to "..self.to_play_id)
	 else
	    world.Send("give tiejiang kuangshi")
     end

	  wait.make(function()
	   local l,w=wait.regexp("^(> |)你给(.*)一块未知矿石。$|^(> |)你身上没有这样东西。$",5)
		if l==nil then
		    self:reward()
		    return
		 end
		 if string.find(l,"一块未知矿石") then
		    if w[2]=="铁匠" then
		       self:jobDone()
			else
			   self:giveup()
			end
		    return
		 end
		 if string.find(l,"你身上没有这样东西") then
		    self:giveup()
		    return
		 end
	  end)
   end
   w:go(76)
end

function caikuang:giveup()
   local w=walk.new()
   w.walkover=function()
      world.Send("ask tiejiang about 放弃")
	  wait.make(function()
        local l,w=wait.regexp("你向铁匠打听有关『放弃』的消息。",5)
        if l==nil then
		   self:giveup()
		   return
		end
		if string.find(l,"你向铁匠打听有") then
		   self:Status_Check()
		   return
		end
	  end)
   end
   w:go(76)
end

function caikuang:liaoshang_fail()
end

function caikuang:Status_Check()
    local win=window.new() --监控窗体
     win.name="status_window"
     win:addText("label1","目前工作:采矿")
	 win:addText("label2","目前过程:打坐")
     win:refresh()
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
     --初始化
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

		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
			local rc=heal.new()
			rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.liaoshang_fail=function()
			   self:liaoshang_fail()
			end
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 and h.qi_percent>=80 then
			print("打通经脉")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config 全局变量
			rc.liaoshang_fail=self.liaoshang_fail
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			 local sp=special_item.new()

			sp.check_items_over=function()
			   print("检查结束")
			  for index,deal_function in pairs(sp.itemslist) do

			     if sp.itemslistNum[index]==nil then
				  self:buy_qiao()
			     else
			      self:ask_job()
			     end
			    break
			  end
	        end
            local equip={}
	         equip=Split("<存在>铁锹","|")
              sp:check_items(equip)
			end
			b:check()
		end
	end
	h:check()
end

--465
function caikuang:buy_fromxiaofan()
   wait.make(function()
      world.Send("list")
		world.Send("buy tieqiao")
		local l,w=wait.regexp("^(> |)你以.*的价格从.*那里买下了一(把|柄)(.*)。$",5)
		if l==nil then
		   self:follow_xiaofan()
		   return --> 你以六十六两白银的价格从采矿师傅那里买下了一柄铁锹。
		end
		if string.find(l,"那里买下") then
		   world.Send("follow none")
		   self:ask_job()
		   return
		end

   end)
end

function caikuang:follow_xiaofan()
  world.Send("follow dali xiaofan")
  world.Send("follow shifu")
  world.Send("set follow")
  wait.make(function()
     local l,w=wait.regexp("^(> |)你决定跟随(.*)一起行动。$|^(> |)你已经这样做了。$|^(> |)设定环境变量：follow = \\\"YES\\\"$",5)
	 if l==nil then
	    self:follow_xiaofan()
	    return
	 end
	 if string.find(l,"你决定跟随") or string.find(l,"你已经这样做了") then
	    world.Send("say 我已书剑城管名义宣布你为乱设摊典型代表！")
		self:buy_fromxiaofan()
		return
	 end
	 if string.find(l,"设定环境变量") then
		coroutine.resume(equipments.co)
	    return
	 end
  end)
end

function caikuang:buy_qiao()
--Tiechui
--Jian dao
   local rooms={}
   table.insert(rooms,76)
   table.insert(rooms,74)
   table.insert(rooms,97)
   table.insert(rooms,75)
   table.insert(rooms,87)
   table.insert(rooms,88)
   table.insert(rooms,73)
   table.insert(rooms,96)
   table.insert(rooms,100)
    table.insert(rooms,71)
	 table.insert(rooms,94)
	  table.insert(rooms,80)
	   table.insert(rooms,83)
	    table.insert(rooms,81)
		 table.insert(rooms,82)
		  table.insert(rooms,68)
		   table.insert(rooms,70)
		    table.insert(rooms,73)


  --[[ table.insert(rooms,427)
   table.insert(rooms,428)
    table.insert(rooms,429)
   table.insert(rooms,430)
   table.insert(rooms,431)
	table.insert(rooms,432)
    table.insert(rooms,433)
	table.insert(rooms,434)
	table.insert(rooms,435)
	 table.insert(rooms,437)
	  table.insert(rooms,450)
	   table.insert(rooms,453)
	    table.insert(rooms,457)
	table.insert(rooms,458)
    table.insert(rooms,459)

   table.insert(rooms,461)
    table.insert(rooms,462)
   table.insert(rooms,463)
   table.insert(rooms,464)
   table.insert(rooms,465)
   table.insert(rooms,466)--]]
   --sz大理城西门
   equipments.co=coroutine.create(function()
    for _,r in ipairs(rooms) do
      local w=walk.new()
	  w.walkover=function()
	    self:follow_xiaofan()
	  end
	  w:go(r)
	  coroutine.yield()
    end
	self:buy_qiao()
  end)
  coroutine.resume(equipments.co)
end

