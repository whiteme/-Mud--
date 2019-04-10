--[[
宝象背着双手踱来踱去，似乎在想什么坏念头。
宝象在你的耳边悄声说道：听说最近南阳城南门附近来了个漂亮的小妞，你去给我弄来。
宝象说道：「给老祖爷爷干活，速去速回。」

郭小姐(Beauty)
这是位有闭月羞花之貌的绝色美女，在保镖的保护下悠闲的游山玩水。
看来就是血刀老祖要求叶知秋(Outstand)强抢的美女。
她看起来约二十多岁。
她的武艺看上去初学乍练，出手似乎极轻。
她看起来气血充盈，并没有受伤。
她穿戴着：
  □绣花小鞋(Xiuhua xie)
  □绿杉长裙(Chang qun)

]]
local heal_ok=false
xueshan={
  new=function()
     local xs={}
	 setmetatable(xs,xueshan)
	 xs.beauty_list={}
	 xs.rooms={}
	 return xs
  end,
  xs_co=nil,
  xs_co2=nil,--分支搜索
  id="Outstand",
  auto_kill=false,
  auto_kill_npc="",
  look_beauty=false,
  look_beauty_name="",
  look_beauty_place=nil,
  guard_name="",
  guard_id="",
  guard_real_id="",
  guard_party="",
  gurad_weapon="",
  beauty_name="",
  beauty_list={},
  rooms={},
  neili_upper=1.9,
  super_guard=false,
  win=false,
  location='',
  blacklist="",
  is_idle=false,
  run_kill=true,
  gender="男性",
  try_fight=false,
}
xueshan.__index=xueshan

local ask_fight=0

function xueshan:NextPoint()
   print("进程恢复")
   coroutine.resume(xueshan.xs_co)
end

function xueshan:Search(rooms)
   local al
	al=alias.new()
	al:SetSearchRooms(rooms)
	local w
	w=walk.new()
	w.noway=function()
		     print("noway 事件")
          local f=function()
		     self:NextPoint()
			 -- print("noway 事件2")
		  end
		  f_wait(f,1)

	end
   for index,r in ipairs(rooms) do


		  --[[al.out_zishanlin=function()
			   self.NextPoint=function()
				  print("恢复进程")
                  coroutine.resume(xueshan.co)
			   end
			   al:finish()
		  end
		  al.zishanlin_check=function()
			 self.NextPoint=function() al:NextPoint() end
			   local f1=function()
			      self:NextPoint()
			   end
             self:checkBeauty(f1)
		  end]]
		  if string.find(self.location,"字门")==nil then
		     al.maze_done=function()
		       self:checkBeauty(al.maze_step)
		     end
		  end
		  al.break_in_failure=function()
		      self:giveup()
			  --self:beauty_exist()
			  --self:NextPoint()
		  end
		 --[[ al.circle_done=function()
		     print("遍历")
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkBeauty(f2)
		  end]]
		  al.nanmen_chengzhongxin=function()
       --1972 _ 2349
             world.Send("north")
             local _R
             _R=Room.new()
			_R.CatchEnd=function()
               local count,roomno=Locate(_R)
	           print("当前房间号",roomno[1])
	           if roomno[1]==2349 then
				  al:finish()
			   elseif roomno[1]==1972 then
			      print("无法进入伊犁城")
				  self:NextPoint()
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
		    self:NextPoint()
		  end
		  al.xiaojing2_yuanmen=function()
		     self:NextPoint()
		  end
		  w.user_alias=al

		  w.walkover=function()
		    if self.look_beauty==true then
			   print("看美女耶！")
			   --self.look_beauty=false
			   local f1=function()
			      print("雪山回调函数")
			      self:NextPoint()
			   end
		       self:checkBeauty(f1)
			else
			   print("下一个")
			   self:NextPoint()
			end
		  end
		  --
		 -- print(index," index")

		  if index==1 then
		    w.current_roomno=1657
		  end
		  --print("目标:",r)
		  w:go(r)
		  coroutine.yield()
   end
end

function xueshan:Child_NextPoint()
   print("恢复子进程")
   coroutine.resume(xueshan.xs_co2)
end

function xueshan:Child_Search(rooms)
   local al
   al=alias.new()
   al:SetSearchRooms(rooms)
   for _,r in ipairs(rooms) do
          local w
		  w=walk.new()

		  --al.break_pfm=self.break_pfm
		  --[[al.out_zishanlin=function()
			   self.Child_NextPoint=function()
				  print("恢复子进程")
                  coroutine.resume(xueshan.co2)
			   end
			   al:finish()
		  end
		  al.zishanlin_check=function()
			 self.Child_NextPoint=function() al:NextPoint() end
             self:Child_checkBeauty()
		  end]]
		  al.maze_done=function()
			  self:Child_checkBeauty(al.maze_step)
		  end
		  al.break_in_failure=function()
		      --self:giveup()
			  self:Child_NextPoint()
		  end
		   al.xiaojing2_yuanmen=function()
		     self:Child_NextPoint()
		  end
		  w.user_alias=al
		  w.walkover=function()
			self:Child_checkBeauty()
		  end
		  w:go(r)
		  coroutine.yield()
   end
end

function xueshan:Child_checkBeauty(CallBack)
   wait.make(function()
	 world.AddTriggerEx ("beauty_name", "^(> |)(.*)\\(Beauty\\)$", "print(\"%2\")\nSetVariable(\"beauty_name\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 50)

      world.Execute("look beauty;set look 1")
      local l,w=wait.regexp("^(> |)看来就是血刀老祖要求.*\\\((.*)\\\)强抢的美女。$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		world.EnableTrigger("beauty_name",false)
		world.DeleteTrigger("beauty_name")
		self:Child_checkBeauty(CallBack)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
		  world.EnableTrigger("beauty_name",false)
		  world.DeleteTrigger("beauty_name")
		  local b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		    if CallBack==nil then
			  self:Child_NextPoint()
			else
			  CallBack()
			end
		  end
		  b:check()
		  return
	  end
	  if string.find(l,"看来就是血刀老祖要求") then
		   world.EnableTrigger("beauty_name",false)
		   world.DeleteTrigger("beauty_name")
		   self.beauty_name=Trim(world.GetVariable("beauty_name"))
		   world.DeleteVariable("beauty_name")
		   print(self.beauty_name," 芳名")
	    if string.lower(self.id)==string.lower(w[2]) then
	       --找到
		   world.Send("yun recover")
		   self:follow()
		 else
            print("不是自己的beauty")
			self:beauty_exist()
			table.insert(self.beauty_list,self.beauty_name)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   if CallBack==nil then
			     self:NextPoint()
			   else
			     CallBack()
			   end
			end
			b:check()
		 end
		  return
	  end
	  wait.time(6)
   end)
end

local round=1
function xueshan:beauty(location)
	local ts={
	           task_name="雪山",
	           task_stepname="搜索",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  --world.AppendToNotepad (WorldName(),os.date()..": 雪山:".. location.."\r\n")
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:搜索位置 "..location, "white", "black") -- yellow on white
   if zone_entry(location)==true then
      self:giveup()
      return
   end
   self.location=location
   local exps=world.GetVariable("exps")
    if location=="武当山后山小院" or location=="神龙岛蛇窟" or location=="回疆针叶林" or location=="华山思过崖洞口" or location=="归云庄九宫桃花阵" or location=="武当山院门" or location=="嵩山少林松树林" or ((location=="明教风字门" or location=="明教地字门" or location=="明教雷字门" or location=="明教天字门") and self.run_kill==true)  or (location=="嵩山少林藏经阁二楼" and tonumber(exps)<=800000) then
	     self:giveup()
		 return
	end
	--print(location)
   local n,e=Where(location)
   local range
   if string.find(location,"武当后山") then
      range=3
   else
      range=6
   end
	local rooms=depth_search(e,1)  --范围查询

    self.rooms=rooms

     self:beauty_exist()
	self:auto_kill_check()
    if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	   print("抓取")
	   xueshan.xs_co=coroutine.create(function()
	    self:Search(rooms)
		print("没有找到npc!!")
		if  table.getn(rooms)<=80 and round==1 then
		   print("重新尝试一次")
		   self:Search(rooms)
		   self:giveup()
		else
		  self:giveup()
		end
	   end)
       --ColourNote("red","yellow","大内高手? ")
	   --print(self.super_guard)
	   local is_giveup=false
	    local blacklist=Split(self.blacklist,"|")
	    for _,b in ipairs(blacklist) do
	       local i=Split(b,"&")
		   local party_id=i[1]
		   local carry_weapon=i[2] or nil
		   local gender=i[4] or nil
		   local super=i[3] or nil
		   if party_id=="大内高手" and self.super_guard==true then
		      is_giveup=true
		      break
		   end

	    end
	   if is_giveup then
		  shutdown()
		  self:giveup()
	      return
	   end

		self:NextPoint()

	 end
	 b:check()
	else
	  print("没有目标")
	  self:giveup()
	end
end

function xueshan:jobDone() --回调函数
end

function xueshan:after_giveup() --回调函数
end

function xueshan:giveup()
    xueshan.xs_co=nil
	xueshan.xs_co2=nil
	world.Send("unset wimpy")
	world.Send("set wimpycmd hp")
	local pfm=world.GetVariable("pfm") or ""
    world.Send("alias pfm "..pfm)
	 world.EnableTrigger("beauty_place",false)
     world.DeleteTrigger("beauty_place")
	--  world.AppendToNotepad (WorldName(),os.date()..": 雪山放弃 \r\n")
	--CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:放弃", "red", "black") -- yellow on white
 local w
   w=walk.new()
   w.walkover=function()
      world.Send("ask bao xiang about 失败")
	   wait.make(function()
	   local l,w=wait.regexp("^(> |)你向宝象打听有关『失败』的消息。$",8)
	   if l==nil then
		 self:giveup()
	     return
	   end
	   if string.find(l,"你向宝象打听有关『失败』的消息") then
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		       local f1=function()
	             self:Status_Check()
	           end
               Weapon_Check(f1)
		 end
		 b:check()
	     return
	   end
	   wait.time(8)
	 end)
   end
   w:go(1657)
end

function xueshan:auto_kill_check()
  wait.make(function()
    local l,w=wait.regexp("^(> |)看起来(.*)想杀死你！$",5)
	if l==nil then
	  self:auto_kill_check()
	  return
	end
	if string.find(l,"想杀死你") then
	  self.auto_kill=true
	  self.auto_kill_npc=w[2]
	  self:auto_kill_check()
	  return
    end
	wait.time(5)
  end)
end
-- 黄郡主(Beauty)

function xueshan:beauty_exist()
  --看起来盗墓贼想杀死你！
  --print("auto kill 检查")
   world.AddTriggerEx ("beauty_place", "^(> |)(.*) - .*$", "print(\"%2\")\nSetVariable(\"beauty_place\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 150)

  wait.make(function()
    local l,w=wait.regexp("^(> |)(.*)\\(Beauty\\)$",5)
	if l==nil then
	  self:beauty_exist()
	  return
	end
	if string.find(l,"Beauty") then
	--
	  if self:is_check_already(w[2])==true then
	     print("已经检测过")
	     self:beauty_exist()
	     return
	  end
	  print("发现美女")
	  self.look_beauty=true
	  self.look_beauty_name=Trim(w[2])
	  local location=world.GetVariable("beauty_place")
	  location=Trim(location)
	  self.look_beauty_place=location
	  print("名字:",self.look_beauty_name)
	  print("发现地点:",location)
	  world.EnableTrigger("beauty_place",false)
	  world.DeleteTrigger("beauty_place")
	  --world.DeleteVariable("beauty_place")
	  return
    end
	wait.time(5)
  end)
end

function xueshan:run(i)
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

function xueshan:flee(i)
  world.Send("go away")
  dangerous_man_list_add(self.guard_name) --加入危险名单
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
	 self:run(i)
   end
   _R:CatchStart()
end
--[[
江南捕头 过士(Guo shi)
这是位威风凛凛的保镖，身体壮实，一看就是武功高手！
这位高手似乎来自苏州。
他看起来约三十多岁。
他的武艺看上去融会贯通，出手似乎很轻。
他气喘嘘嘘，看起来状况并不太好。
他穿戴着：
  □布衣(Cloth)
他装备着：
  □长剑(Changjian)
]]

function xueshan:party(id,weapon,super_guard,gender)
   --party=id

	 local blacklist=Split(self.blacklist,"|")
	 for _,b in ipairs(blacklist) do
	     local i=Split(b,"&")
		 local party_id=i[1]
		 local carry_weapon=i[2] or nil
		 local super=i[3] or nil
		 local guard_gender=i[4] or nil
		 --print(party_id,"?",id," ",weapon)
		 if party_id=="大内高手" and super_guard==true then
			return false
		 end

		 if id==party_id then
		    if carry_weapon==nil or carry_weapon=="" then
			  if guard_gender==nil or guard_gender=="" then
			   if super==nil or super=="" then
			    return false
			   elseif super=="大内高手" and  super_guard==true then
			    return false
			   end
			  elseif guard_gender==gender then
               if super==nil or super=="" then
			    return false
			   elseif super=="大内高手" and  super_guard==true then
			    return false
			   end
	          end

			elseif carry_weapon==weapon then
			  if guard_gender==nil or guard_gender=="" then
			    if super==nil or super=="" then
			    return false
			   elseif super=="大内高手" and  super_guard==true then
			    return false
			   end
			 elseif guard_gender==gender then
			  if super==nil or super=="" then
			    return false
			   elseif super=="大内高手" and  super_guard==true then
			    return false
			   end
			  end
			end
		 end
	 end
	  return true
end

function xueshan:check_auto_kill_npc()
   wait.make(function()
     world.Send("look")
	 world.Send("set look 1")
	 world.Send("unset wimpy")
	 --老虎 熊 豹 蛇 野猪 巨蟒
	 local regexp
	 if self.auto_kill_npc~="" and self.auto_kill_npc~=nil then
	    regexp=".*"..self.auto_kill_npc.."\\((.*)\\) <战斗中>$|.*(白熊|黑熊|老虎|蛇|豹子|野猪|巨蟒|野狼|灰狼|马贼|值勤兵|帮众|毒蟒|教众|鳄鱼|疯狗|慧真尊者)\\((.*)\\).*|^(> |)设定环境变量：look \\= 1$"
	else
 	    regexp=".*(白熊|黑熊|老虎|蛇|豹子|野猪|野狼|灰狼|巨蟒|马贼|值勤兵|帮众|毒蟒|教众|鳄鱼|疯狗|慧真尊者)\\((.*)\\).*|^(> |)设定环境变量：look \\= 1$"
	end
	 local l,w=wait.regexp(regexp,10)
	 if l==nil then
	    self:check_auto_kill_npc()
	    return
	 end
	 if string.find(l,"战斗中") then
	     local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"值勤兵") then
		world.Send("kill zhiqin bing")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"帮众") then
	     world.Send("kill bangzhong")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
		 return
	 end

	 if string.find(l,"马贼") then
	    world.Send("kill ma zei")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"熊") then
	    world.Send("kill bear")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"豹子") then
	    world.Send("kill bao")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	    return
	 end
	if string.find(l,"蛇") then

		if string.find(l,"金蛇") then
		   self:check_auto_kill_npc()
		   return
		end
	    local id1=w[2]
		local id2=w[4]
		print(w[1],w[2],w[3],w[4])
		local id=""
		if id1~=nil then
		   id=id1
		end
		if id2~=nil then
		   id=id2
		end
		id=string.lower(id)
	    world.Send("kill snake")
		world.Send("kill "..id)
		world.Send("kill dushe")
		--world.Send("kill she")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"教众") then
	    world.Send("kill jiao zhong")
		--world.Send("kill she")
		local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"老虎") then
	    world.Send("kill lao hu")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"野猪") then
	    world.Send("kill ye zhu")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end

	 if string.find(l,"巨蟒") or string.find(l,"毒蟒")  then
		 world.Send("kill mang")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"鳄鱼") then
	    world.Send("kill e yu")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"狼") or string.find(l,"狗") then
		 world.Send("kill wolf")
		 world.Send("kill dog")
		 world.Send("kill lang")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"慧真尊者") then

		 world.Send("kill zunzhe")
		 local f=function() self:check_auto_kill_npc() end
		 f_wait(f,3)
	 end
	 if string.find(l,"设定环境变量：look") then
	   self.auto_kill_npc=""
	   self.auto_kill=false
	   self:kill_guard(true)
	   return
	 end
     wait.time(10)
   end)
end

function xueshan:shield()

end
--熊春向后退了几步，说道：这场比试算我输了，佩服，佩服！
--丁杨哈哈大笑，说道：承让了！

function xueshan:loseFight()
    self.win=false
	shutdown()
	self:giveup()
end

function xueshan:knockdownNPC()
 local b=busy.new()
	 b.Next=function()
		print("打通经脉")
		local rc=heal.new()
		--rc.saferoom=505
		--rc.teach_skill=teach_skill --config 全局变量
		rc.heal_ok=function()
		   local kill_again=function()
		       print("继续fight")
			   self:kill_success(self.guard_id,false)
			   self:combat()
			   self:wait_guard_idle()
			   self:wait_guard_die()
		   end

			local x
			x=xiulian.new()
			x.min_amount=10
			x.safe_qi=1000
			x.limit=true
			x.is_jobing=true
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
			    if id==201 and x.hp.jingxue_percent<100 then
				   rc:heal(false,true)
				   return
				end
				if id==201 or id==1 then
				  world.Send("yun recover")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
			    end
				if id==777 then
				   f=function()
				     --heal_ok=false
   				     kill_again()
				   end  --外壳
				   f_wait(f,0.5)
				end

			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
				  world.Send("yun recover")
			      kill_again()
			   else
	             print("继续修炼")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()

		end
		rc:heal(true,false)

	 end
	 b:check()
end

function xueshan:status()
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
			          self:status()
			        end
			        rc:qudu(sec,i[1],false)
				    return
			     end
				 if i[1]=="一指禅内劲" or i[1]=="气息不匀" or i[i]=="封招" or i[i]=="闭气" or i[i]=="内伤" or i[i]=="断手" or i[i]=="一指禅内劲" or i[i]=="弹指神通内伤" then
				    print("等待状态消失")
				    sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			            self:status()
					  end
					  f_wait(f,5)
			        end
			        rc:heal(true,false)
				    return
				 end
			   end
		     end
			self:knockdownNPC()
	end
	cd:start()
end

function xueshan:winFight()
     self.win=true
	 print("打赢了！！")
	 shutdown()
	 self:check_superguard_status(self.guard_id)
	 self:status()

end

function xueshan:fight_end(id)
    wait.make(function()
	      local regexp="^(> |)(.*)哈哈大笑，说道：承让了！$|^(> |)(.*)双手一拱，笑着说道：承让！$|"
		  regexp=regexp.."^(> |)(.*)向后一纵，说道：阁下武艺果然高明，这场算是在下输了！$|^(> |)(.*)胜了这招，向后跃开三尺，笑道：承让！$|"
		   regexp=regexp.."^(> |)(.*)脸色微变，说道：佩服，佩服！$|^(> |)(.*)向后退了几步，说道：这场比试算我输了，佩服，佩服！$|^(> |)(.*)向后一纵，躬身做揖说道：阁下武艺不凡，果然高明！$"
		--[[	CYN "\n$N哈哈大笑，说道：承让了！\n\n" NOR,
	CYN "\n$N双手一拱，笑着说道：承让！\n\n" NOR,
        CYN "\n$n向后一纵，说道：阁下武艺果然高明，这场算是在下输了！\n\n" NOR,
	CYN "\n$N胜了这招，向后跃开三尺，笑道：承让！\n\n" NOR,
	CYN "\n$n脸色微变，说道：佩服，佩服！\n\n" NOR,
	CYN "\n$n向后退了几步，说道：这场比试算我输了，佩服，佩服！\n\n" NOR,
	CYN "\n$n向后一纵，躬身做揖说道：阁下武艺不凡，果然高明！\n\n" NOR戚德华向后退了几步，说道：这场比试算我输了，佩服，佩服！,]]

	    local l,w=wait.regexp(regexp,10)
		if l==nil then
		    self:fight_end(id)
		   return
		end
		if string.find(l,"哈哈大笑") or string.find(l,"双手一拱") or string.find(l,"武艺果然高明") or string.find(l,"跃开三尺") or string.find(l,"佩服") or string.find(l,"果然高明") then
		    local name=nil
			name=w[2]
			if name==nil or name=="" then
			   name=w[4]
			end
		   	if name==nil or name=="" then
			   name=w[6]
			end
			if name==nil or name=="" then
			   name=w[8]
			end
			if name==nil or name=="" then
			   name=w[10]
			end
			if name==nil or name=="" then
			   name=w[12]
			end
			if name==nil or name=="" then
			   name=w[14]
			end
			--print("1",w[1],"2",w[2],"3",w[3],"4",w[4],"5",w[5],"6",w[6],"7",w[7],"8",w[8])
			print(name," 战斗结束")
			if name=="你" then
			   if w[2]=="你" or w[4]=="你" or w[8]=="你" then
			        self:winFight()
			   else

				   self:loseFight()
			   end
			elseif name==self.guard_name then
				if w[2]==self.guard_name or w[4]==self.guard_name or w[8]==self.guard_name then
			        self:loseFight()
			   else

				    self:winFight()
			   end
			else
			    self:fight_end(id)
			end
			return
		end

	end)
end

function xueshan:auto_pfm(cmd)
   print("提前pfm")
   world.Execute(cmd)
end

function xueshan:check_superguard_status(id)
   if self.super_guard==true and self.try_fight==true then
      wait.make(function()
	     local l,w=wait.regexp("^(> |)"..self.guard_name.."「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)"..self.guard_name.."神志迷糊，脚下一个不稳，倒在地上昏了过去。$",10)
		 if l==nil then
		    self:check_superguard_status(id)
		    return
		 end
		 if string.find(l,"死了") then
			shutdown()
			print("guard 死了")
            local b=busy.new()
			b.Next=function()
 			   self:guard_die()
			end
			b:check()
		    return
		 end
		 if string.find(l,"昏了过去") then
            shutdown()
			print("guard 晕了")
            local b=busy.new()
			b.Next=function()
			   self:kill_success(id,false)
			end
			b:check()
		 end
	  end)

   end
end


local kill_count=0
function xueshan:kill_success(id,flag)
   if kill_count>10 then
      kill_count=0
	  --连续10次失败放弃
	  self:giveup()
	  return
   end
   self:shield()
   self:auto_pfm()
   wait.make(function()
     print("kill_success !!!!!!!!!! ","kill "..id," 大内高手:",self.super_guard)
	 --self:shield()
	 if self.super_guard==false or flag==true then
		--world.Send()
		--直接发送pfm
		world.Send("kill "..id)
		self.try_fight=false
		--print("kill:",flag)
		--self.super_guard=false
		--world.Send("sa beauty")
	 else
	    self.try_fight=true
	    self:fight_end(id)
		self:check_superguard_status(id)
	    world.Send("fight "..id)
		world.Send("set action 战斗")
		--self.super_guard=false
	 end
	 --print(self.guard_name," guard")

	 local l,w=wait.regexp("^(> |)"..self.guard_name.."说道：「今日有公务在身，恕不奉陪。」$|^(> |)加油！加油！加油！$|^(> |)加油！加油！$|^(> |)你正要有所动作，突然身旁有人将你一拍：好好看比武，别乱动！$|^(> |)这里没有这个人。$|^(> |)你嘿嘿阴笑了几声，用指甲向.*轻轻弹了点粉沫。.*$|^(> |)看起来"..self.guard_name.."并不想跟你较量。$|^(> |)"..self.guard_name.."已经无法战斗了。$",2)
--> 这里不准战斗。
--你向后一纵，说道：阁下武艺果然高明，这场算是在下输了！
--你对着邹富城大喝一声：「臭贼！一曲肝肠断来觅知音╭(╯3╰)╮！」你对着杜培嘿嘿一笑：来来来！就让大爷我来领教领教壮士的高招吧！
     if l==nil then
	    self:kill_success(id,flag)
	    return
	 end
	 if string.find(l,"加油") then
	     --self:checkfight()
	     return
	 end
	 if string.find(l,"今日有公务在身") then
	     if self.super_guard==true then
		    self:giveup()
		 else
		     self:kill_success(id,true)
		 end
	 end
	 if string.find(l,"并不想跟你较量") then
	    if self.super_guard==true then
		   print("超级guard 不接受fight")
		   print("是否打赢过！>",self.win)
		   if self.win==false then
		      self:giveup()
		   else
		     local f=function()
			   if ask_fight>=3 then
			     self:kill_success(id,true)
			   else
			     self:kill_success(id,false)
			   end
			 end
			 ask_fight=ask_fight+1
			 --world.Send("ask "..self.guard_id.." about 较量")
			 print("等待1秒")
			 f_wait(f,1)
		   end
		   --print("检查是否在疗伤")
		else
		   self:kill_success(id,true)
	    end
		 return
	 end
	 if string.find(l,"已经无法战斗了") then
	   print("晕了")
	   self:kill_success(id,true)
	   return
	 end
	 if string.find(l,"这里没有这个人") then
	    world.Send("sa beauty")
		kill_count=kill_count+1
		self:kill_success(id,flag)
	    return
	 end
	 if string.find(l,"你嘿嘿阴笑了几声") then
	      local b
		  b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		     self:reward()
		  end
		  b:check()
	    return
	 end
	 if string.find(l,"你正要有所动作") then
	    shutdown()
		local f=function()
		  local b=busy.new()
		  b.interval=0.5
		  b.Next=function()
		    self:follow()
		  end

		  b:check()
		end
		f_wait(f,3)
	    return
	 end
     wait.time(2)
   end)
end
--
--[[
他装备着：
  □铁笔(Tie bi)
]]
function xueshan:check_guard()
   wait.make(function()
     local l,w=wait.regexp("^(> |)这位高手似乎来自(.*)。$|^(> |)  □(.*)\\((.*)\\)|^(> |)最近治安不太好，这个保镖是特别从京城请来的，据说还曾经是大内高手呢！$|^(> |)(.*)穿戴着：$",5)
	 if l==nil then
	   self:check_guard()
	   return
	 end

	 if string.find(l,"大内高手") then
	    print("大内高手")
		CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:大内高手", "red", "black") -- yellow on white
				--[[关润发盘膝坐下，开始运功疗伤。
你脸上紫气一闪，又恢复如常。

你对着关润发嘿嘿一笑：来来来！就让大爷我来领教领教壮士的高招吧！]]
	    self.super_guard=true
		self:check_guard()
	    return
	 end
	 if string.find(l,"穿戴着") then
	     local gender=w[7]
		 if Trim(gender)=="他" then
		    self.gender="男性"
		 else
		    self.gender="女性"
		 end
	     self:check_guard()
		 return
	 end
	 if string.find(l,"这位高手似乎来自") then
	    self.guard_party=w[2]
		self:check_guard()
	    return
	 end
	 if string.find(l,"□") then
	    self.guard_weapon=w[4]
		self:check_guard()
		return
	 end
	 wait.time(5)
   end)
end

function xueshan:sure_enemy_party()
end


function xueshan:look()
     _R=Room.new()
        _R.CatchEnd=function()
          local count,roomno=Locate(_R)
		  print("保存战斗房间号:",roomno[1])
		   _G["fight_Roomno"]=roomno[1]

	    end
	_R:CatchStart()
end

local function get_dir(dx)
   if dx=="up" then
      return "down"
	elseif dx=="down" then
	   return "up"
   elseif dx=="east" then
      return "west"
	elseif dx=="west" then
	  return "east"
	elseif dx=="north" then
	  return "south"
	elseif dx=="south" then
	  return "north"
	elseif dx=="northwest" then
	  return "southeast"
	elseif dx=="northeast" then
	  return "southwest"
	elseif dx=="southwest" then
	   return "northeast"
	elseif dx=="southeast" then
	   return "northwest"
	elseif dx=="enter" then
	  return "out"
	elseif dx=="out" then
	  return "enter"
	elseif dx=="southdown" then
	  return "northup"
	elseif dx=="northup" then
	  return "southdown"
	elseif dx=="eastup" then
	  return "westdown"
	elseif dx=="westdown" then
	   return "eastup"
	elseif dx=="northdown" then
	   return "southup"
	elseif dx=="southup" then
	   return "northdown"
	elseif dx=="eastdown" then
	    return "westup"
	elseif dx=="westup" then
	    return "eastdown"
   end
end

local test_count=0
local escape_test_count=0
function xueshan:wait_back(id,dir,select_pfm)


	 --world.Send("set action 逃跑")
	 wait.make(function()
	     local l,w=wait.regexp("^(> |)这里没有这个人。$|^(> |)你嘿嘿阴笑了几声，用指甲向.*轻轻弹了点粉沫。.*$",1)
		 if l==nil then
		     escape_test_count=escape_test_count+1
			 print("尝试逃跑次数:",escape_test_count)
			 if escape_test_count<8 then
			    world.Send("sa beauty")
		        world.Send("kill "..id)
				world.Send("yun qi")
			    world.Execute(select_pfm)
		        self:wait_back(id,dir,select_pfm)
			 else
                self:escape_kill(id,dir,true)
			 end
		     return
		 end
		 if string.find(l,"轻轻弹了点粉沫") then
		    shutdown()
			 local b=busy.new()
			 b.Next=function()
		       self:reward()
			end
			b:check()
		    return
		 end
	     if string.find(l,"这里没有这个人") then

		     local b=busy.new()
			 b.Next=function()
                 local reversal_dir=get_dir(dir)
				 world.Send("yun qi")
				 world.Send("yun jingli")
				 print(test_count)

				 if test_count>5 then
				    shutdown()
				    self:giveup()
                    return
				 else
				     test_count=test_count+1
				 end
				 self:damage(id,reversal_dir,dir)
				 --world.Send(reversal_dir)
				 --self:escape_kill(id,dir)
			 end
			 b:check()
		 end
	 end)

end

function xueshan:escape_success()
   wait.make(function()
     local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"逃跑\\\"$",5)
	 if l==nil then
	     self:escape_success()
	     return
	 end
	 if string.find(l,"设定环境变量") then
	    test_count=0
	    return
	 end

   end)
end
--  京城大侠 朱强(Zhu qiang) <昏迷不醒>
--金秋班神志迷糊，脚下一个不稳，倒在地上昏了过去。
--  管晶岚的尸体(Corpse)
function xueshan:escape_guard_idle()
   print("escape guard idle ")
    wait.make(function()  --淳于纳泉神志迷糊，脚下一个不稳，倒在地上昏了过去。
     --print(npc.."神志迷糊，脚下一个不稳，倒在地上昏了过去。")
	 --欧阳香神志迷糊，脚下一个不稳，倒在地上昏了过去。
	 print(self.guard_name," 晕了没额！")
	 local id=self.guard_real_id
	 local name=self.guard_name
      print("real id "..id)
     local l,w=wait.regexp("^(> |)(.*)神志迷糊，脚下一个不稳，倒在地上昏了过去。$|^(.*)\\\("..id.."\\\) \\\<昏迷不醒\\\>$|^.*"..name.."的尸体\\\(Corpse\\\)$",5)
     if l==nil then
	   self:escape_guard_idle()
	   return
	 end
	 if string.find(l,"神志迷糊，脚下一个不稳") then
	    print(self.guard_name,w[2])
	    if string.find(self.guard_name,w[2]) then
		   self.is_idle=true
		else
           self:escape_guard_idle()
		end
	 end
	 if string.find(l,"昏迷不醒") then
	     self.is_idle=true
	    return
	 end
	 if string.find(l,"尸体") then
	    self.is_idle="dead"
		return
	 end

	end)
end

function xueshan:damage(id,reversal_dir,dir) --跑杀 气血
   local h=hp.new()
	h.checkover=function()
	   print("受伤程度",h.qi_percent)
	   local g=h.max_jingli/2
	   print(h.jingli,"/",h.max_jingli," ",g)
        if h.qi_percent<100 and h.qi_percent>=70 then
		    local b=busy.new()
			b.Next=function()
				print("打通经脉")
                local rc=heal.new()
			    rc.heal_ok=function()
			        world.Send("yun qi")
					self:damage(id,reversal_dir,dir)
			    end
			    rc:heal(true,false)
			end
			b:check()
		elseif h.qi_percent<70 then
	      --self:recover(true)
		   self:giveup()
	    elseif h.jingxue_percent<=80 then
	       self:giveup()
 	   elseif h.neili<=h.max_neili*1.2 then
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

				  world.Send("yun recover")
				  world.Send("yun jing")
				  if id==202 then
				     print("无法打坐的房间！！")
				      --world.Send(reversal_dir)
		              --self:escape_kill(id,dir)
					 self:giveup()
				  else
	                local f
		            f=function() x:dazuo() end  --外壳
				    f_wait(f,0.5)
				  end
			end
			x.success=function(h)
               world.Send("yun qi")
			   self:damage(id,reversal_dir,dir)
			end
			x:dazuo()
		elseif h.neili<500 then
		    self:giveup()
	   else
	      world.Send(reversal_dir)
		  self:escape_kill(id,dir)
	   end
	end
	h:check()
end

local function special_room(relation)
  if relation=="大厅｜厢房─后厅─厢房｜内堂" or relation=="长廊｜长廊─长廊─厢房｜长廊" then
    return 2
  else
    return 1
  end
end

function xueshan:escape_kill(id,g_dir,reset)
    local f=function(x_dir)
            local select_pfm
			local xs_pfm=world.GetVariable("xs_pfm") or ""
			select_pfm=world.GetVariable(xs_pfm) or ""
             if select_pfm  == "" then
		        select_pfm=world.GetVariable("pfm") or ""
		     end
			 print("npc 情况:",self.is_idle)
			 escape_test_count=0
			 if self.is_idle==false then
		       world.Send("alias pfm "..x_dir.."")
		       world.Send("set wimpy 100")
	           world.Send("set wimpycmd halt\\pfm\\hp\\set action 逃跑")
			   self:wait_back(id,x_dir,select_pfm)
			   self:escape_success()
			 elseif self.is_idle=="dead" then  -- guard 直接打死
			    print("guard 死了")
				self:guard_die()
				return
			 else
			   world.Send("alias pfm")
			   world.Send("unset wimpy")
			   world.Send("set wimpycmd hp")
			   self:wait_back(id,x_dir,select_pfm)
	         end

             world.Send("kill "..id)
             world.Execute(select_pfm)

	end
	if g_dir==nil or reset==true then
        _R=Room.new()
        _R.CatchEnd=function()
		     self.is_idle=false
			 self:escape_guard_idle()
             local count,roomno=Locate(_R)
			   print("保存战斗房间号:",roomno[1])
		     _G["fight_Roomno"]=roomno[1]
			 --print(_R.Exits)
			 --local dir = Split(_R.Exits,";")
			 print("寻找出口")
             local dx=_R:get_all_exits(_R)
	          --for _,d in ipairs(dx) do
	            --print("exit:",d)
			 --end
			 local r=special_room(_R.relation)
			 local _dx=dx[r]
			 if g_dir==nil then
			     --print(_dx)
			     f(_dx)
			 else
			    for index,dir in ipairs(dx) do
				    if dir==g_dir then
					    local i=index+1
						if dx[i]==nil then
						    _dx=dx[1]
							print(_dx)
			                f(_dx)
						else
						    _dx=dx[i]
                            print(_dx)
			                f(_dx)
						end
						return
					end

				end
			 end

	    end
	   _R:CatchStart()
   else
        f(g_dir)
   end

end

function xueshan:kill_guard(flag)
    world.Send("yun recover")
    world.AddTriggerEx ("guard_id", "^(> |)(.*)\\((.*)\\)$", "print(\"%2\")\nSetVariable(\"guard_name\",\"%2\")\nprint(\"%3\")\nSetVariable(\"guard_id\",\"%3\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 150)
    world.Send("sa beauty")
	world.Send("look guard")
	self:check_guard()
	world.Send("set look")

	wait.make(function()
	  local l,w=wait.regexp("^(> |)你要看什么？$|^(> |)设定环境变量：look \\= \"YES\"$",5)

	   if l==nil then
	       world.EnableTrigger("guard_id",false)
		   world.DeleteTrigger("guard_id")
		   world.DeleteTrigger("guard_name")
	      self:kill_guard(flag)
		  return
	   end
	   --> 江南捕头 萧孝(Xiao xiao)
	   if string.find(l,"设定环境变量：look") then
	     shutdown()
	   --if string.find(l,"这位高手似乎来自") then
	     world.EnableTrigger("guard_id",false)
		 world.DeleteTrigger("guard_id")
		 local id=world.GetVariable("guard_id")
		 world.DeleteVariable("guard_id")
		 local name=world.GetVariable("guard_name")
		 world.DeleteTrigger("guard_name")
         self.guard_real_id=id
		 id=string.lower(id)
	      print(w[2])
	      local family=self.guard_party--Trim(w[2])
		  local weapon=self.guard_weapon
		  local super_guard=self.super_guard
		  local run_kill=self.run_kill --跑杀
		  local gender=self.gender
		  -- world.AppendToNotepad (WorldName().."_雪山任务:",os.date()..": 雪山:guard 门派 ".. family.." weapon "..self.guard_weapon.."\r\n")
		   	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:门派 ".. family.." weapon "..self.guard_weapon, "white", "black") -- yellow on white
			local ts={
	           task_name="雪山",
	           task_stepname="战斗",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description=Split(name," ")[2] .." 门派:"..family.." 武器:"..weapon,
	        }
	        local st=status_win.new()
	         st:init(nil,nil,ts)
	         st:task_draw_win()

			 print(gender)
			 print(family)
			 print(weapon)

          local result=self:party(family,weapon,super_guard,gender)
		  print("result",result)
		  if result==true then
		      self:auto_pfm()
		     print("检查有无危险动物")
			    self:sure_enemy_party()
                self.guard_id=id
				self.guard_name=Split(name," ")[2]
			 --if super_guard==true then
			   --关闭跑杀
			  if run_kill==true then
			    self:escape_kill(id)  --跑杀
                self:wait_guard_die()
			  else
			    self:kill_success(id,false)
	            self:combat()
				self:wait_guard_idle()
				self:wait_guard_die()
			  end
				--return
			 --end
			 --[[self:look()
		     if flag==true and self.auto_kill==false then  --检查
				self:sure_enemy_party() --根据npc 门派来使用不同应对skill
				self:kill_success(id,true)
				self.guard_id=id
				self.guard_name=Split(name," ")[2]
	            self:combat()
				self:wait_guard_idle()
				self:wait_guard_die()
		     else
			    self:check_auto_kill_npc()
             end]]

		  elseif result==false then
		    --self.super_guard=true
			--print("放弃列表的内容，测试！！")
			 --print("检查有无危险动物")
			 --print("使用跑杀")
             --self:look()
		     --[[if flag==true and self.auto_kill==false then  --检查
				self:sure_enemy_party() --根据npc 门派来使用不同应对skill
	            --self:kill_success(id,false)
				self:kill_success(id,true)
				self.guard_id=id
				self.guard_name=Split(name," ")[2]
	            self:combat()
				self:wait_guard_idle()
				self:wait_guard_die()
		     else
			    self:check_auto_kill_npc()
             end]]
		  --else
		     print("fangqi")
		     self:giveup()
		  end
		  --end
	      return
	   end
	   if string.find(l,"你要看什么") then
	      world.EnableTrigger("guard_id",false)
		  world.DeleteTrigger("guard_id")
		  world.DeleteTrigger("guard_name")
	      --print
		  self:beauty_exist()
		  self:NextPoint()
	      return
	   end
	   wait.time(5)
	end)
end


function xueshan:guard_idle()

end

function xueshan:wait_guard_idle()
   wait.make(function()  --淳于纳泉神志迷糊，脚下一个不稳，倒在地上昏了过去。
     --print(npc.."神志迷糊，脚下一个不稳，倒在地上昏了过去。")
	 --欧阳香神志迷糊，脚下一个不稳，倒在地上昏了过去。
	 --print(self.guard_name," 晕了没额！")
     local l,w=wait.regexp("^(> |)(.*)神志迷糊，脚下一个不稳，倒在地上昏了过去。$",5)
     if l==nil then
	   self:wait_guard_idle()
	   return
	 end
	 if string.find(l,"神志迷糊，脚下一个不稳") then
		print(self.guard_name,w[2])
	    if string.find(self.guard_name,w[2]) then
		   self:guard_idle()
		else
           self:wait_guard_idle()
		end
	    return
	 end
	 --wait.time(5)
   end)
end

function xueshan:follow()
   wait.make(function()
     world.Send("follow beauty")
	 local l,w=wait.regexp("^(> |)你决定跟随(.*)一起行动。$|^(> |)这里没有 beauty。$|^(> |)你已经这样做了。$",5)
	  if l==nil then
	    self:follow()
	    return
	  end
	  if string.find(l,"这里没有 beauty") then
	    self:beauty_exist()
	    self:NextPoint()
	    return
	  end
	  if string.find(l,"你决定跟随") then
	    if w[2]==self.beauty_name then
		   --self:kill_guard()
		   self:check_auto_kill_npc()
		 else
		  print("跟错目标!!!")
		  world.Send("follow none")
		  local f1=function()
			 self:NextPoint()
		  end
		  self:checkBeauty(f1)
		end
		 return
	  end
	  if string.find(l,"你已经这样做了") then
	      world.Send("follow none")
		  self:follow()
		  return
	  end
	  wait.time(5)
   end)
end

function xueshan:is_check_already(beauty_name)
  print("target:",beauty_name)
  for _,g in ipairs(self.beauty_list) do
     print(g)
     if g==beauty_name then
	     print("--------------")
	    return true
	 end
  end
  print("--------------")
  return false
end

function xueshan:Check_Point_Beauty()

	 local n,e=Where(self.look_beauty_place) --检测房间名
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
	   xueshan.xs_co2=coroutine.create(function()
            self:Child_Search(target_room)
		 --回到主进程上去
		   print("回到主进程上去!")
		   self:beauty_exist()
		   self:NextPoint()
	   end)
	   self:Child_NextPoint()
end

function xueshan:checkBeauty(CallBack)

   wait.make(function()
   --[[郭小姐(Beauty)
这是位有闭月羞花之貌的绝色美女，在保镖的保护下悠闲的游山玩水。
看来就是血刀老祖要求叶知秋(Outstand)强抢的美女。]]
      world.AddTriggerEx ("beauty_name", "^(> |)(.*)\\(Beauty\\)$", "print(\"%2\")\nSetVariable(\"beauty_name\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 50)

      world.Execute("look beauty;set look 1")
      local l,w=wait.regexp("^(> |)看来就是血刀老祖要求.*\\\((.*)\\\)强抢的美女。$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		world.EnableTrigger("beauty_name",false)
		world.DeleteTrigger("beauty_name")
		self:checkBeauty(CallBack)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
		world.EnableTrigger("beauty_name",false)
		world.DeleteTrigger("beauty_name")
	      --没有找到
		   print(self.look_beauty)
		   print(self.look_beauty_name)
		   print(self:is_check_already(self.look_beauty_name),"->结果")
		   if self.look_beauty==true then --路上经过
			   self.look_beauty=false

			   if self:is_check_already(self.look_beauty_name)==false and not (self.look_beauty_place=="山路" and self.location=="福州城山路") then
		         --print("回调")
                 self:Check_Point_Beauty()--点检
			   else
				 print("开启美女检测 触发器")
				 self:beauty_exist()
                 local b=busy.new()
                 b.interval=0.3
                 b.Next=function()
		           CallBack()
                 end
                 b:check()
			   end
		   else
			   print("开启美女检测 触发器")
		       self:beauty_exist()
               local b=busy.new()
               b.interval=0.3
               b.Next=function()
		         CallBack()
               end
               b:check()
		   end
		  return
	  end
	  if string.find(l,"看来就是血刀老祖要求") then
		   world.EnableTrigger("beauty_name",false)
		   world.DeleteTrigger("beauty_name")
		   self.beauty_name=Trim(world.GetVariable("beauty_name"))
		   world.DeleteVariable("beauty_name")
		   print(self.beauty_name," 芳名")
	    if string.lower(self.id)==string.lower(w[2]) then
	       --找到
		   world.Send("yun recover")
		   self:follow()
		 else
            print("不是自己的beauty,加入排除列表中!")
			table.insert(self.beauty_list,self.beauty_name)
			 print("开启美女检测 触发器")
			 self:beauty_exist()
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   CallBack()
			end
			b:check()
		 end
		  return
	  end
	  wait.time(6)
   end)
end

function xueshan:eat_xieqiwan()
    wait.make(function()
      world.Send("fu xieqi wan")
	  local l,w=wait.regexp("^(> |)你服下一颗邪气丸，顿时感觉浑身充满邪气。$",5)
	  if l==nil then
	    self:eat_xieqiwan()
	    return
	  end
	  if string.find(l,"你服下一颗邪气丸") then
	    self:ask_job()
		return
	  end
	  wait.time(5)
	end)
end

function xueshan:look_xieqiwan()
--  二十五颗内息丸(Neixi wan)
 wait.make(function()
   world.Send("i")
   world.Send("set look")
   local l,w=wait.regexp("^(> |)(.*)颗邪气丸\\(Xieqi wan\\)$|^(> |)设定环境变量：look \\= \\\"YES\\\"",5)
   if l==nil then
      self:look_xieqiwan()
      return
   end
   if string.find(l,"邪气丸") then
	  self:eat_xieqiwan()
	  return
   end
   if string.find(l,"设定环境变量：look ") then
	  self:buy_xieqiwan()
	  return
   end
   wait.time(5)
  end)
end

function xueshan:guard_die()  --守卫死亡事件
end

function xueshan:wait_guard_die()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了。$",5)
	 if l==nil then
	    self:wait_guard_die()
	    return
	 end
	 if string.find(l,"挣扎着抽动了几下就死了") then
	    print(self.guard_name,w[2])
	    if string.find(self.guard_name,w[2]) then
		   self:guard_die()
		else
           self:wait_guard_die()
		end
	    return
	 end
	 --|^(> |)你只觉得头昏脑胀，眼前一黑，接着什么也不知道了……$
	 --[[if string.find(l,"你只觉得头昏脑胀") then
	    print("晕倒")
		local f=function()
		   self:is_combat()
		end
		f_wait(f,5)
		return
	 end]]
	 wait.time(5)
   end)
end

function xueshan:qu_gold()
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
		   self:buy_xieqiwan()
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

function xueshan:buy_xieqiwan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy xieqi wan")
	 local l,w=wait.regexp("你以.*的价格从药店掌柜那里买下了一颗邪气丸。|^(> |)你想买的东西我这里没有。$|^(> |)穷光蛋，一边呆着去！$|^(> |)您的零钱不够了，银票又没人找得开。$",5)
	 if l==nil then
	   self:buy_xieqiwan()
	   return
	 end
	 if string.find(l,"你想买的东西我这里没有") then
	   local f=function()
	     self:buy_xieqiwan()
	   end
	   print("5s 以后继续")
	   f_wait(f,5)
	   return
	 end
	 if string.find(l,"一颗邪气丸") then
	    self:eat_xieqiwan()
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

function xueshan:is_super_guard()
  wait.make(function()
    local l,w=wait.regexp("^(> |)宝象在你的耳边悄声说道：这个任务比较困难，不行不要勉强！$|^(> |)宝象说道：「给老祖爷爷干活，速去速回。」$",5)
	if l==nil then
	   return
	end
	if string.find(l,"速去速回") then
	    self.super_guard=false
	   return
	end
	if string.find(l,"这个任务比较困难") then
	    world.ColourNote("red","yellow","大内高手")
		self.super_guard=true
	   return
	end
  end)
end

function xueshan:xunwen()
    wait.make(function()
	--宝象说道：「我看你不够心狠手辣，爷爷我不喜欢。」  宝象在你的耳边悄声说道：听说最近明教狮王殿附近来了个漂亮的小妞，你去给我弄来。
		local l,w=wait.regexp("^(> |)宝象在你的耳边悄声说道：听说最近(.*)附近来了个漂亮的小妞，你去给我弄来。$|^(> |)宝象说道：「你要累死你老祖爷爷啊！一边呆着去！」$|^(> |)宝象说道：「身体是革命的本钱啊，同志！你还是先歇息一会儿吧。」|^(> |)宝象说道：「我不是叫你到.*去给老祖爷爷抢美女了嘛！」$|^(> |)宝象说道：「我看你不够心狠手辣，爷爷我不喜欢。」$|^(> |)你发现事情不大对了，但是又说不上来。$",5)
		if l==nil then
		   self:xunwen()
		   return
		end

		if string.find(l,"身体是革命的本钱啊") then
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self.fail(102)
		   end
		   b:check()
		   return
		end
		if string.find(l,"你要累死你老祖爷爷啊") then
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self.fail(101)
		   end
		   b:check()
		   return
		end
		if string.find(l,"宝象在你的耳边悄声说道：") then
		   print(w[2])
		   self:is_super_guard()
		   self:beauty(w[2])
		   return
		end
		if string.find(l,"去给老祖爷爷抢美女了") then
		   self:giveup()
		   return
		end
		if string.find(l,"我看你不够心狠手辣") then
		   self:look_xieqiwan()
		  return
		end
		if string.find(l,"你发现事情不大对了，但是又说不上来") then
		   self:ask_job()
		   return
		end
	    wait.time(5)
    end)
end

function xueshan:ask_job()
	local ts={
	           task_name="雪山",
	           task_stepname="询问宝象",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	ask_fight=0
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:工作开始!", "yellow", "black") -- yellow on white
	 self.beauty_list={}
	 self.rooms={}
       local w
        w=walk.new()
		local al=alias.new()
        al.do_jobing=true
        w.user_alias=al
	    w.walkover=function()
        wait.make(function()
		 wait.time(1.5)
        world.Send("ask bao xiang about job")
		local l,w=wait.regexp("^(> |)你向宝象打听有关『job』的消息。$",5)
		if l==nil then
		   self:ask_job()
		   return
		end
		if string.find(l,"你向宝象打听有关『job』的消息") then
		   self:xunwen()
 		   return
		end
		wait.time(5)
	  end)
     end
     w:go(1657)
end

function xueshan:reward()
	local ts={
	           task_name="雪山",
	           task_stepname="奖励",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	xueshan.xs_co=nil
	xueshan.xs_co2=nil
	 world.Send("alias pfm")
	 world.Send("unset wimpy")
	 world.Send("set wimpycmd hp")
	world.EnableTrigger("beauty_place",false)
    world.DeleteTrigger("beauty_place")
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
        world.Send("ask bao xiang about 完成")
		local l,w=wait.regexp("^(> |)你被奖励了(.*)点经验，(.*)潜能！你感觉邪恶之气更胜从前！$|^(> |)宝象似乎不懂你的意思。$|^(> |)恭喜你！你成功的完成了雪山任务！你被奖励了：$|^(> |)宝象一脚正好踢中你的屁股！$",5)
		if l==nil then
		   self:reward()
		   return
		end
		if string.find(l,"你感觉邪恶之气更胜从前") then
		   local rc=reward.new()
	       rc:get_reward()
           local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
			  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on white
		      self:jobDone()
		   end
		   b:check()
		   return
		end
		if string.find(l,"恭喜你！你成功的完成了雪山任务") then
		   local rc=reward.new()
	       rc:exps()
           local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
			  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on white
		      self:jobDone()
		   end
		   b:check()
		   return
		end
		if string.find(l,"宝象一脚正好踢中你的屁股") then
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		      self:giveup()
		   end
		   b:check()
		    return
		end
		if string.find(l,"宝象似乎不懂你的意思") then
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
   w:go(1657)
end

function xueshan:liaoshang_fail()
end

function xueshan:full()
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
				   --BigData:Auto_catchData()
			       x:dazuo()
		         end
		         w:go(1656)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
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


function xueshan:Status_Check(flag)
	local ts={
	           task_name="雪山",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=5,
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
			        rc:heal(true,true)
				    return
				 end
				  if Trim(i[1])=="雪山强抢美女" then
				    --print("?")
				    self.fail(102)
				    return
				 end
			   end
		     end
			--self:xuli()
            self:full()
	end
	cd:start()
end

function xueshan:combat()  --回调函数
end

function xueshan:combat_end()
end

function xueshan:is_ok()
    world.Send("yun recover")
    world.Send("yun refresh")
	local h
	h=hp.new()
	h.checkover=function()
	  if h.qi_percent>=80 and h.qi_percent<=100 then
	    self:kill_guard()
	  else
        self:giveup()
	  end
	end
	h:check()
end

function xueshan:sa(count)
    wait.make(function()
	   if count==nil then
	      count=1
	   else
	      count=count+1
	   end

	    world.Send("sa beauty")
		if count>1 then
		  world.Send("sa beauty 2")
		end
		world.Send("set action sa")

	   local l,w=wait.regexp("^(> |)hmm，你似乎在利用BUG！$|^(> |)你嘿嘿阴笑了几声，用指甲向.*轻轻弹了点粉沫。.*$|^(> |)你要撒谁？$|^(> |)设定环境变量：action \\= \"sa\"$|^(> |)人家有保镖在呢！你这么干太冒险了吧！$|^(> |)这个女人好象不是老祖要的那个啦！$",5)
	   if l==nil then
	      self:sa()
		  return
	   end
	   if string.find(l,"人家有保镖在呢！你这么干太冒险了吧") then
	       --world.AppendToNotepad (WorldName().."_雪山任务:",os.date()..": super-guard\r\n")

	      --self.super_guard=true
	      self:is_ok()
		  return
	   end
	   if string.find(l,"你似乎在利用BUG")  then
	      --self.super_guard=false
	      self:is_ok()
	      return
	   end
	   if string.find(l,"你嘿嘿阴笑了几声") then
	      local b
		  b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		     self:reward()
		  end
		  b:check()
	      return
	   end
	   if string.find(l,"你要撒谁") then
	      self:reward()
	      return
	   end
	   if string.find(l,"这个女人好象不是老祖要的那个啦") then
	      if count>5 then
			 print("尝试超过5次")
		     self:giveup()
		     return
		  end

	      local f=function()
		     self:sa(count)
		  end
          f_wait(f,0.8)
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
	     print("药粉丢失!!!!")
	     self:giveup()
	     return
	   end
	   wait.time(5)
	end)
end

function xueshan:fail(id)
end

--[[你嘿嘿阴笑了几声，用指甲向黄格格轻轻弹了点粉沫。
不一会儿，黄格格就满面通红的晕了过去！

只见走出几个壮年男子将黄格格背起往大雪山的方向疾奔而去。]]
