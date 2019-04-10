require "wait"
alias={
   new=function()
     local al={}
	 setmetatable(al,alias)
	--[[ for i,v in pairs(self.alias_table) do
      local thread=self.alias_table[i]
	  if thread then
		--print("alias 清理")
        self.alias_table[i]=nil
      end
    end]]

	 --setmetatable(al.self.alias_table, {__mode = "k"}) --weak table
	 al.id=string.sub(CreateGUID(),25,30)
	 al.alias_table={}
	 al:register()
	 --print("why2")
	 return al
   end,
   owner=nil,--行走对象 walk 类
  -- co=nil,
   weapon_exist=false,
   do_jobing=false,
   circle_co=nil,
   zishanlin_co=nil,
   id="",
   alias_table={},
   maze_step=nil,-- 迷宫步进回调函数
  break_in_count=0,
  version=1.8,
}
alias.__index=alias

function alias:SetSearchRooms(Rooms)
       --print("set")
    local dx=Get_Special(Rooms)
	for _,d in ipairs(dx) do
	   if self.alias_table[d]~=nil then
	      --print(d,"加入")
	      self.alias_table[d].is_search=true
	   end
	end
end

function alias:redo(CallBack)
    print("路径出错默认函数")
	CallBack()
end

function alias:ATM_carry_silver(bank_roomno,CallBack,roomno)
  wait.make(function()
  world.Execute("i;set look")
   local l,w=wait.regexp("^(> |)(.*)两白银\\(Silver\\)|^(> |)设定环境变量：look \\= \\\"YES\\\"$",5)
   if l==nil then
	 self:ATM_carry_silver(bank_roomno,CallBack,roomno)
     return
   end
   if string.find(l,"两白银") then
      print(w[2])
	  local silver=ChineseNum(w[2])
	  if silver<99 then
	     local qu_silver=99-silver
	    local w=walk.new()
		w.walkover=function()
		   world.Send("qu "..qu_silver.." silver")
		   self:ATM_carry_silver(bank_roomno,CallBack,roomno)
		end
	    w:go(bank_roomno)
	  else
	    local w=walk.new()
		w.walkover=function()
	      CallBack()
		end
		w:go(roomno)
	  end
   end
   if string.find(l,"设定环境变量：look") then
        local w=walk.new()
		w.walkover=function()
		   world.Send("qu 99 silver")
		   self:ATM_carry_silver(bank_roomno,CallBack,roomno)
		end
	    w:go(bank_roomno)
      return
   end
   wait.time(5)
  end)
end

function alias:ATM(CallBack)
   print("没钱了,取款机在哪里?")
--确定当前位置
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --根据当前位置 前往最近的钱庄
--{大理 410} {塘沽 1474} {扬州 50} {成都 546} {西域 1973} {苏州 1069} {杭州 1119} {福州 1331} {长安 926} {兰州城}
      local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	  local bank_roomno
	  local index=zone(_R.zone)
	  if index==1 then
	     bank_roomno=1331
	  elseif index==2 then
	     bank_roomno=1331
	  elseif index==3 or roomno[1]==767 then
	     bank_roomno=50
	  elseif index==4 then
	     bank_roomno=410
	  elseif index==5 or roomno[1]==1479 then
	     bank_roomno=1474
	  elseif index==6 then
	     bank_roomno=1973
	  else
	     bank_roomno=926
	  end
	  if roomno[1]==1573 then
	     bank_roomno=926
	  elseif roomno[1]==1574 then
	     bank_roomno=1973
	  end
	  print(bank_roomno," 银行")
	  local b=busy.new()
	  b.interval=0.3
	  b.Next=function()
          self:ATM_carry_silver(bank_roomno,CallBack,roomno[1])
	  end
	  b:check()
   end
  _R:CatchStart()
--返回 pay again
end

--获取房间绘制位置

function alias:draw_special_direction(alias_name)
   --self:register()
   --print("alias_name:",alias_name)
   for _,a in ipairs(self.alias_table) do
	  if a.name==alias_name then
		return a.dir --返回绘制位置
	  end
   end
   return nil
end

function alias:exec(alias_name)
   	--print("alias id3:",self.id,"  ",alias_name)
    --self:register()
	--print("执行")
	--	print("alias id4:",self.id,"  ",alias_name)
	--for _,a in ipairs(self.alias_table) do
	  --if a.name==alias_name then
	  --print("alias_name:",alias_name)
		local f=self.alias_table[alias_name].alias or nil--a.alias
		if f==nil then
		  print("未注册"..alias_name.." alias 函数")
		  return
		end
		--print("alias id5:",self.id,"  ",alias_name)
		f()
		--print("alias id6:",self.id,"  ",alias_name)
		--break
	  --end
   --end
   --print("")
end

function alias:outboat(flag)
--渡船猛地一震，已经靠岸，船夫说道：“请大伙儿下船吧！”
--说着将一块踏脚板搭上堤岸，形成一个出去(out)的阶梯。
  wait.make(function()
	local l,w=wait.regexp("^(> |)渡船猛地一震，已经靠岸，船夫说道：“请大伙儿下船吧！”$|^(> |)艄公说“到啦，上岸吧”，随即把一块踏脚板搭上堤岸。$|^(> |)艄公轻声说道：“都下船吧，我也要回去了。”$",5)
	 if l==nil then
	    self:outboat(flag)
	    return
	 end
	 if string.find(l,"渡船猛地一震，已经靠岸") or string.find(l,"到啦，上岸吧") or string.find(l,"都下船吧，我也要回去了") then

	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()

		 world.Send("out")
        if flag==true then
		  world.Execute("east;east;west")
		end

		 self:finish()
	   end
	   b:check()
	    return
	 end

    wait.time(5)
  end)
end
--由于你已经听了神雕侠杨过的指导，所以不用多想，信步就走出了林海。

--一艘渡船缓缓地驶了过来，艄公将一块踏脚板搭上堤岸，以便乘客上下(enter)。
function alias:yellboat_wait(flag)
  if world.IsTrigger("beauty_place")==0 or world.IsTrigger("player_place")==0 or world.IsTrigger("robber_place")==0 or self.do_jobing==true then
     print("job 中")
	 world.Send("set 积蓄")
  else
     print("非job 中")
     world.Send("unset 积蓄")
  end
     world.Send("yun qi")
    local h=hp.new()
	h.checkover=function()
		if  h.neili<h.max_neili*1.9 and h.max_qi>=200 then
		 print("开始打坐修炼内力")
		 if h.max_neili>=h.neili_limit then
		   world.Send("set 积蓄")
		 end
		 local x=xiulian.new()
		 x.halt=false
		 x.safe_qi=100
		 x.min_amount=100
         x.fail=function(id)
	     if id==1 then
	     --正循环打坐
		  print("正循环打坐")
		  Send("yun recover")
		  x:dazuo()
	     end
	     if id==201 then
		  Send("yun recover")
	      world.Send("yun regenerate")
		  x:dazuo()
	     end
	     if id==202 then
		   print("已经在船上")
		   return
		 end
         end
           x.success=function(h)
	          --if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then --气量太少了
		        --print("正循环打坐 yellboat")
		        Send("yun recover")
		        x:dazuo()
	          --else
	          --  print("继续修炼")
		      --  x:dazuo()
	         -- end
		   end
		   --print("等船打坐")
           x:dazuo()
		  local f=function()
	        print("尝试叫船")
	        x.halt=true
	        local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:yellboat(flag)
			end
			b:check()
	      end
	      f_wait(f,5)
	   else
	      print("内力满无需打坐")
		  local f=function()
		    self:yellboat(flag)
		  end
		  f_wait(f,2)
	   end
	end
	h:check()
end

function alias:boat_busy(flag)
   wait.make(function()
     local l,w=wait.regexp("^(> |).*渡船\\\s*-\\\s*(out|)$|.*渡船\\\s*-.*|^(> |)设定环境变量：look \\= \"YES\"$|^(> |)你掏了掏腰包，却发现身上带的钱不够了。$",5)

	  if l==nil then
	     self:yellboat(flag)
		 return
	  end
	  if string.find(l,"渡船") then
	     self:outboat(flag)
		 return
	  end
	  if string.find(l,"设定环境变量：look") then
		 self:yellboat_wait()
		 return
	  end
	  if string.find(l,"你掏了掏腰包，却发现身上带的钱不够了") then
	    local f=function()
		   self:yellboat(flag)
		end
        self:ATM(f)
		return
	  end
	  wait.time(5)
   end)
end

function alias:yellboat(flag)
   wait.make(function()

	  world.Send("yell boat")
	  world.Send("enter")
	  world.Send("look")
	  world.Send("set action 上船")
	  --黄河渡船 - out --
      local l,w=wait.regexp("^(> |).*渡船\\\s*-\\\s*(out|)$|.*渡船\\\s*-.*|^(> |)(江|河)面上远远传来一声：“等等啊，这就来了～～～”$|^(> |)只听得湖面不远处隐隐传来：“别急嘛，这儿正忙着呐……”$|^(> |)设定环境变量：action \\= \\\"上船\\\"$",5)
	  if l==nil then
	    self:yellboat(flag)
	    return
	  end
	  if string.find(l,"渡船") then
	     --BigData:Auto_catchData()
	     self:outboat(flag)
		 return
	  end
	  if string.find(l,"等等啊") or string.find(l,"只听得湖面不远处隐隐传来") then
	     if flag==true then
	          local _R
               _R=Room.new()
               _R.CatchEnd=function()
                  if _R.roomname=="长江南岸" or _R.roomname=="长江北岸" then
				      if _R.exits=="east;south;west;" or _R.exits=="east;north;west;" then
					      local dx="west"
					      world.Execute(dx)
						  self:yellboat(flag)
					  elseif _R.exits=="east;" then
						  local dx="east;east"
						  world.Execute(dx)
						  self:yellboat(flag)
                      elseif _R.exits=="west;" then
					      local dx="west"
						   world.Execute(dx)
						  self:yellboat_wait(flag)
					  else
						  self:yellboat(flag)
					  end
				  else
				      self:yellboat_wait()
				  end
			   end
               _R:CatchStart()
		 else
	        self:boat_busy()
		 end
	     return
	  end
	  if string.find(l,"设定环境变量：action") then --错误异常
	    self:finish()
	    return
	  end

	  wait.time(2)
   end)
end

function alias:dujiang_wait()
  if world.IsTrigger("beauty_place")==0 or world.IsTrigger("player_place")==0 or world.IsTrigger("robber_place")==0 or self.do_jobing==true then
     print("job 中")
	 world.Send("set 积蓄")
  else
     print("非 job")
	 world.Send("unset 积蓄")
  end
    world.Send("yun qi")
    local h=hp.new()
	h.checkover=function()
	  if  h.neili<h.max_neili*1.9 and h.max_qi>=200 then
		 print("开始打坐修炼内力")
		 if h.max_neili>=h.neili_limit then
		   world.Send("set 积蓄")
		 end
		 local x=xiulian.new()
		 x.halt=false
		 x.safe_qi=10
		 x.min_amount=100
         x.fail=function(id)
	      if id==1 then
	     --正循环打坐
		  print("正循环打坐")
		  Send("yun recover")
		  x:dazuo()
	      end
	      if id==201 then
		    if h.jingxue_percent>=80 then
		      world.Send("yun recover")
	          world.Send("yun regenerate")
		       x:dazuo()
		   --self:dujiang_now(x)
		     else
		       print("精力太低无法打坐")
		       local f=function()
		           self:dujiang()
			   end
		      local _R
               _R=Room.new()
               _R.CatchEnd=function()
                  if _R.roomname=="长江南岸" or _R.roomname=="长江北岸" then
				      if _R.exits=="east;south;west;" or _R.exits=="east;north;west;" then
					      local dx="west"
					      world.Execute(dx)
					  elseif _R.exits=="east;" or _R.exits=="east;enter;" then
						  local dx="e;e"
						  world.Execute(dx)
                      elseif _R.exits=="west;" or _R.exits=="enter;west;" then
					      local dx="w"
						   world.Execute(dx)
					  else
						  local dx="e;e"
						  world.Execute(dx)
					  end

					  f_wait(f,1)

				  else
				      f_wait(f,1)
				  end
			   end
               _R:CatchStart()
			 end
	      end
	      if id==202 then
           print("上船了")
		   return
          end
		 end
           x.success=function(h)
	          --if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then --气量太少了
			    if x.halt==false then
		          print("正循环打坐 dujiang")
		          Send("yun recover")
		          x:dazuo()
				else
				  print("dujiang 结束")
				end
	          --else
	          --  print("继续修炼")
		      --  x:dazuo()
	         -- end
		   end
           x:dazuo()
		   self:dujiang_now(x)
	   else
	      print("内力满无需打坐")
		  local f=function()
		    self:dujiang()
		  end
		   local _R
               _R=Room.new()
               _R.CatchEnd=function()
                  if _R.roomname=="长江南岸" or _R.roomname=="长江北岸" then
				      if _R.exits=="east;south;west;" or _R.exits=="east;north;west;" then
					      local dx="west"
					      world.Execute(dx)
					  elseif _R.exits=="east;" or _R.exits=="east;enter;" then
						  local dx="e;e"
						  world.Execute(dx)
                      elseif _R.exits=="west;" or _R.exits=="enter;west;" then
					      local dx="w"
						   world.Execute(dx)
					  else
						  local dx="e;e"
						  world.Execute(dx)
					  end

					  f_wait(f,1)

				  else
				      f_wait(f,1)
				  end
			   end
               _R:CatchStart()

	   end
	end
	h:check()
end

function alias:duhe_now(x)

	print("进入渡江检测！")
   wait.make(function()
     local l,w=wait.regexp("紧了紧随身物品|长袖飘飘",7)
	 if l==nil then
	 	 	print("时间到，尝试渡江！")
			x.halt=true
			x:clear()
		 	local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:duhe()
			end
			b:check()
	    return
	 end
	 if string.find(l,"紧了紧随身物品") or string.find(l,"长袖飘飘") then
	        x.halt=true
			x:clear()
	 	 	print("有人渡江，赶快跟上！")
		 	local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:duhe()
			end
			b:check()
	    return
	 end
	 wait.time(10)
   end)
end


function alias:dujiang_now(x)

	print("进入渡江检测！")
   wait.make(function()
     local l,w=wait.regexp("紧了紧随身物品|长袖飘飘",7)
	 if l==nil then
	        x:clear()
			x.halt=true
	 	 	print("时间到，尝试渡江！")
		 	local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:dujiang()
			end
			b:check()
	    return
	 end
	 if string.find(l,"紧了紧随身物品") or string.find(l,"长袖飘飘") then
	 	 	print("有人渡江，赶快跟上！")
			x:clear()
			 x.halt=true
		 	local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:dujiang()
			end
			b:check()
	    return
	 end
	 wait.time(10)
   end)
end
--> 你使出「一苇渡江」渡过了汉水。
--> 你一提内息，看准了江中渡船位置，使出「一苇渡江」轻功想要飞越长江。
function alias:dujiang()
   wait.make(function()
	  world.Send("dujiang")
      local l,w=wait.regexp("^(> |)你在江中渡船上轻轻一点，又提气飞纵向.*。$|^(> |)你使出「一苇渡江」渡过了.*。$|^(> |)你的修为不够！$|(> |)这里的水太深太急，你渡不过去。$|^(> |)你的内力修为不够，怎能支持！？|^(> |)你还想提气，却发现力不从心了。$|^(> |)你的真气不够了！$|^(> |)你的精力不够了！$|^(> |)江面太宽了，如果没有中途借力的地方根本没法飞越过去！$|^(> |)有船不坐，你想扮Cool啊？$|^(> |)你一提内息，看准了江中渡船位置，使出「一苇渡江」轻功想要飞越长江。$|^(> |)你吓了一大跳，回头看看······到对岸还远，只有往回游了！$|^(> |)你正要继续跃出，突然小腿一疼，“扑通”一声掉进江水之中！抬起头才发现是船老大用竿子将你扫下船的.*$",5)
	  if l==nil then
	    print("渡江超时！！")
	    self:finish()
	    return
	  end

	  if string.find(l,"使出「一苇渡江」") or string.find(l,"你在江中渡船上轻轻一点，又提气飞纵向") then
	     --BigData:Auto_catchData()
	     local b
		 b=busy.new()
		 b.interval=0.9
		 b.Next=function()
		   if string.find(l,"长江") then
		     world.Execute("e;e;w")
		   end
	       self:finish()
		 end
		 b:check()
		 return
	  end
	  if string.find(l,"你的精力不够了") then
		 world.Send("yun refresh")
		 local h=hp.new()
		 h.checkover=function()
		    if h.max_jingli>=1800 then
		      local f=function() self:dujiang() end
		      f_wait(f,0.8)
			else
 			  self:yellboat(true)
			end
		 end
		 h:check()
		 return
	  end
	  if string.find(l,"你吓了一大跳，回头看看") or string.find(l,"你正要继续跃出，突然小腿一疼") then
		 local b
		 b=busy.new()
		 b.interval=0.9
		 b.Next=function()
	       self:dujiang()
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"你的真气不够了") or string.find(l,"你的修为不够") or string.find(l,"这里的水太深太急，你渡不过去") or string.find(l,"你的内力修为不够，怎能支持") then
         self:yellboat(true)
		 return
	  end
	  if string.find(l,"江面太宽了") or string.find(l,"有船不坐") then
	     self:dujiang_wait()
	     return
	  end
	  if string.find(l,"你还想提气，却发现力不从心了") or string.find(l,"抬起头才发现是船老大用竿子将你扫下船的") then
	     self:outboat()
	     return
	  end
	  --[[if string.find(l,"什么") then
	    print("出现异常")
		self:finish()
		return
	  end
	  wait.time(2)]]
   end)
end

function alias:finish() --回调函数
   print("默认回调函数")
end


function alias:xzl_gb() --丐帮杏子林
--n;e;n;w;n;e;n;w;n 996
   print("丐帮杏子林")
   --world.Execute("north;east;north;west;north;east;north;west;north")
   --self:finish()

      local p={"north","east","north","west","north","east","north","west","north"}
   alias.circle_co=coroutine.create(function()
      --print("启动3")
      for _,i in ipairs(p) do
	     world.Send(i)
         self:circle_done("xzl_gb")
	     coroutine.yield()
	  end
	  self:finish()
   end)
  --print("启动2")
   coroutine.resume(alias.circle_co)
end

function alias:opendoornorthup()
   world.Send("open door")
   world.Send("northup")
   self:finish()
end

function alias:opendoorsouthdown()
   world.Send("open door")
   world.Send("southdown")
   self:finish()
end

function alias:opendoornorth()
   world.Send("open door")
   world.Send("north")
   self:finish()
end

function alias:opendoorout()
   world.Send("open door")
   world.Send("out")
   self:finish()
end

function alias:opendoorsouth()
   world.Send("open door")
   world.Send("south")
   self:finish()
end

function alias:opendoorwest()
   world.Send("open door")
   world.Send("west")
   self:finish()
end

function alias:opendooreast()
   world.Send("open door")
   world.Send("east")
   self:finish()
end

function alias:get_range(alias_name)
   --self:register()
   --print(alias_name)
   for _,i in ipairs(self.alias_table) do
       if i.name==alias_name then
	      --print(i.name)
	      if i.range==nil then
		    return 1
		  else
	        return i.range
		  end
	   end
   end
   return 1
end

function alias:fengyun()
   world.Send("fengyun")
   self:finish()
end

function alias:longhu()
   world.Send("longhu")
   self:finish()
end

function alias:tiandi()
   world.Send("tiandi")
   self:finish()
end

function alias:qingyunpin_fumoquan()
   world.Send("enter")
   self:finish()
end

function alias:nanjiangshamo_tuyuhun()

    world.Execute("east;east;east;east;east;east;")
	wait.make(function()
	   local l,w=wait.regexp("^(> |)你已经感到不行了，冥冥中你觉得有人将你抬了出来。$",2)
	   if l==nil then
		  self:nanjiangshamo_tuyuhun()
		  return
	   end
	   if string.find(l,"冥冥中你觉得有人将你抬了出来") then
	      wait.time(8)
	      self:finish()
	      return
	   end

	end)
end

function alias:female_south()
   local gender=world.GetVariable("gender") or ""
   if gender=="男性" then
      self:noway()
	else
	  world.Send("south")
	  self:finish()
   end
end

function alias:d_west()

	local b=busy.new()
	 b.interval=0.9
	b.Next=function()
	   world.Send("west")
      self:finish()
	end
	b:check()
end

function alias:baizhangjian_south()--百丈涧
    world.Send("drop tielian")
	world.Send("south")
	self:finish()
end

function alias:noway()
  print("默认alias noway函数")
  self:finish()
end

local function dx_serial(dx)
   local index=1
   return function()
      if index>table.getn(dx) then
		index=1
	  end
	  local d=dx[index]
	  index=index+1
	  return d
   end
end

function alias:tou_conglin()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2665 then
	   self:finish()
	 elseif roomno[1]==2664 then
	    world.Send("tou conglin")
		self:tou_conglin()
	 else
	    local f=function()
           local w
		   w=walk.new()
		   w.walkover=function()
		      self:tou_conglin()
		   end
		   w:go(2664)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:ll_sl(d)  --柳林山路
--苏州柳林
--一直n;w;s;e就可出来
--1124
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1124 then
	   self:finish()
	 elseif roomno[1]==1123 then
	   if d==nil then
	    local dx={"north","west","south","east"}
	    d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         self:ll_sl(d)
	   end
	   f_wait(f,0.2)
	 else
        local f=function()
		  local w
	   	  w=walk.new()
	 	  w.walkover=function()
		   self:ll_sl()
		  end
		  w:go(1123)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:duhe_wait()

  if world.IsTrigger("beauty_place")==0 or world.IsTrigger("player_place")==0 or world.IsTrigger("robber_place")==0 or self.do_jobing==true then
     print("job 中 ")
	 world.Send("set 积蓄")
  else
     print("非job")
     world.Send("unset 积蓄")
  end
 local h=hp.new()
	h.checkover=function()
	   if  h.neili<h.max_neili*1.9 and h.max_qi>=200 then
		 print("渡河 开始打坐修炼内力")
		 if h.max_neili>=h.neili_limit then
		   world.Send("set 积蓄")
		 end
		 local x=xiulian.new()
		 x.safe_qi=100
		 x.min_amount=10
		 x.halt=false
         x.fail=function(id)
	     if id==1 then
	     --正循环打坐
		  print("正循环打坐")
		  Send("yun recover")
		  x:dazuo()
		  return
	     end
	     if id==201  then
		  if h.jingxue_percent>=80 then
		    world.Send("yun recover")
	        world.Send("yun regenerate")
		    x:dazuo()
		  --self:duhe_now(x)
		  else
		    print("精力太低!")
		    local f=function()
		       self:duhe()
		    end
		    f_wait(f,2)
		  end
	     end
	     if id==202 then
	        print("上船了")
			return
         end
		 end
           x.success=function(h)
	          --if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then --气量太少了 sleep 恢复
			  if x.halt==false then
		        print("正循环打坐 duhe")
		        Send("yun recover")
		        x:dazuo()
			  else
				print("duhe 结束")
			  end
	          --else
	          --  print("继续修炼")
		      --  x:dazuo()
	          --end
		   end
           x:dazuo()
		   self:duhe_now(x)
	   else
	      print("内力满无需打坐")
		  local f=function()
		    self:duhe()
		  end
		  f_wait(f,2)
	   end
	end
	h:check()
end

function alias:duhe()
  wait.make(function()
	  world.Send("duhe")--你在河中渡船上轻轻一点，又提气飞纵向西岸。
      local l,w=wait.regexp("(> |)你使出「一苇渡江」渡过了.*。$|^(> |)你在.*中渡船上轻轻一点，又提气飞纵向.*。|^(> |)你的修为不够！$|(> |)这里的水太深太急，你渡不过去。$|^(> |)你的内力修为不够，怎能支持！？|^(> |)你还想提气，却发现力不从心了。$|^(> |)你的真气不够了！$|^(> |)你的精力不够了！$|^(> |)江面太宽了，如果没有中途借力的地方根本没法飞越过去！$|^(> |)河面太宽了，如果没有中途借力的地方根本没法飞越过去！$|^(> |)有船不坐，你想扮Cool啊？$",5)
	  if l==nil then
	    self:finish()
	    return
	  end

	  if string.find(l,"你使出「一苇渡江」") or string.find(l,"渡船上轻轻一点") then
	     --BigData:Auto_catchData()
	     local b
		 b=busy.new()
		 b.interval=0.9
		 b.Next=function()
	       self:finish()
		 end
		 b:check()
		 return
	  end --河面太宽了，如果没有中途借力的地方根本没法飞越过去！
	  if string.find(l,"你的修为不够") or string.find(l,"这里的水太深太急，你渡不过去") or string.find(l,"你的内力修为不够，怎能支持") or string.find(l,"你的真气不够了") then
         self:yellboat()
		 return
	  end
	  if string.find(l,"你还想提气，却发现力不从心了") then
	     print("真气不足")
	     self:outboat()
		 return
	  end
	  if string.find(l,"你的精力不够了") then
	     world.Send("yun refresh")
		 local h=hp.new()
		 h.checkover=function()
		    if h.max_jingli>=1400 then
		      local f=function() self:duhe() end
		      f_wait(f,0.8)
			else
 			  self:yellboat()
			end
		 end
		 h:check()
		 return
	  end
	  if string.find(l,"中途借力的地方根本没法飞越过去") or string.find(l,"有船不坐") then
	     self:duhe_wait()
	     return
	  end
	 --[[if string.find(l,"什么") then
	    print("出现异常")
		self:finish()
		return
	  end
	  wait.time(5)]]
   end)
end

function alias:dutan()
  wait.make(function()
	  world.Send("dutan")
      local l,w=wait.regexp("(> |)你使出「一苇渡江」渡过了.*。$|^(> |)你的修为不够！$|(> |)这里的水太深太急，你渡不过去。$|^(> |)什么.*$|^(> |)你的内力修为不够，怎能支持！？",5)
	  if l==nil then
	    self:dutan()
	    return
	  end

	   if string.find(l,"你使出「一苇渡江」") then
	     local b
		 b=busy.new()
		 b.interval=0.3
		 b.Next=function()
	       self:finish()
		 end
		 b:check()
		 return
	  end
	  if string.find(l,"你的修为不够") or string.find(l,"这里的水太深太急，你渡不过去") or string.find(l,"你的内力修为不够，怎能支持") then
         self:yellboat()
		 return
	  end
	  if string.find(l,"什么") then
	    print("出现异常")
		self:finish()
		return
	  end
	  wait.time(5)
   end)
end

--shulin_shendiao 襄阳树林 到神雕 n;s;n;n  1496- 1601
-- 1495- 1497 直接穿越
function alias:shanlu1_shanlu2()
   world.Send("north")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1497 then
	   self:finish()
	 elseif roomno[1]==1496 or roomno[1]==1602 then
	    self.maze_step=function()
		    local _al=alias.new()
	        _al.finish=function()
	           world.Send("north")
		       self:finish()
			end
	        _al:shulin_shendiao()
		end
		if self.alias_table["shanlu_shanlu2"].is_search==true then

	       self:maze_done()
		else
		   self.maze_step()
		end

     else
	      local f=function()
		    local w
	    	w=walk.new()
		    w.walkover=function()
		      self:finish()
		    end
		    w:go(1497)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--1497 -1495
----
-- 襄阳树林 n;s;n;n，出来是n;s;n;s;s;n;w;n;s;s
--
function alias:shanlu2_shanlu1()
   world.Send("south")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1495 or roomno[1]==1497 then
	   self:finish()
	 elseif roomno[1]==1496 or roomno[1]==1601 then
	   self.maze_step=function()
	        local _al=alias.new()
	        _al.finish=function()
	         world.Send("south")
		     self:finish()
	       end
	       _al:shulin_kongdi()
	   end
	   if self.alias_table["shanlu2_shanlu1"].is_search==true then
	     self:maze_done()
	   else
		  self.maze_step()
	   end

	 else
	      local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:finish()
		end
		w:go(1495)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--从树林出来

function alias:xiangyangshulin_circle()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1601 then
	    local p={"south","south","north","north","east","north","east","west","south","north"}

        alias.circle_co=coroutine.create(function()

          for _,i in ipairs(p) do
	         world.Send(i)
              self:circle_done("xiangyangshulin_circle")
	         coroutine.yield()
	      end
	      self:finish()
       end)
	   coroutine.resume(alias.circle_co)
	 elseif roomno[1]==1496  then

		local dx={"north","east","south","west"}
	   local i=math.random(4)
	   local d=dx[i]
	   world.Send(d)
	   --print("执行2")
	   self.maze_step=function()
	     --print("执行")
	      local f=function()
            self:xiangyangshulin_circle()
	      end
	      f_wait(f,0.2)
	   end
	    --print("执行2222")
	   --print(self.alias_table["xiangyangshulin_circle"].is_search)

	   if self.alias_table["xiangyangshulin_circle"].is_search==true then
        --print("执行4")
		self:maze_done()
	   else
	      -- print("执行3")
	      self.maze_step()
	   end
	 elseif roomno[1]==1602 then
	   --1602 shulin1 s
	   --1601 shulin8 n
--world.Execute("n;e;n;e;w;s;n")
		local p={"north","east","north","east","west","south","north","south","south","north"}
		 alias.circle_co=coroutine.create(function()
          for _,i in ipairs(p) do
	         world.Send(i)
              self:circle_done("xiangyangshulin_circle")
	         coroutine.yield()
	      end
	      self:finish()
       end)
	    coroutine.resume(alias.circle_co)
	 else
        local f=function() local w
		w=walk.new()
		w.walkover=function()
		   self:xiangyangshulin_circle()
		end
		w:go(1496)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()

end

function alias:shulin_shendiao()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1601 then
	   self:finish()
	 elseif roomno[1]==1496  then

		local dx={"north","south","north","north"}
	   local i=math.random(4)
	   local d=dx[i]
	   world.Send(d)
	   self.maze_step=function()
	      local f=function()
            self:shulin_shendiao(d)
	      end
	      f_wait(f,0.2)
	   end
	   if self.alias_table["shulin_shendiao"].is_search==true then
	     self:maze_done()
	   else
	      self.maze_step()
	   end
	 elseif roomno[1]==1602 then
	   --1602 shulin1 s
	   --1601 shulin8 n
	    world.Execute("n;e;n;e;w;s;n")

		self:shulin_shendiao()
	 else
        local f=function() local w
		w=walk.new()
		w.walkover=function()
		   self:shulin_shendiao()
		end
		w:go(1496)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--shulin_kongdi 神雕处到空地 n;s;n;s;s;n;w;n;s;s  1496 - 1602
function alias:shulin_kongdi()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1602 then
	   self:finish()
	 elseif roomno[1]==1496 then
       local dx={"north","south","north","north"}
	   local i=math.random(4)
	   local d=dx[i]
	   world.Send(d)
	   self.maze_step=function()
	     local f=function()

           self:shulin_kongdi()
	     end
	     f_wait(f,0.2)
	   end
	   if self.alias_table["shulin_kongdi"].is_search==true then
	     self:maze_done()
	   else
	     self.maze_step()
	   end
	 elseif roomno[1]==1601 then
		world.Execute("s;s;n") --shulin8
		--world.Send("south") --shulin9
	    --world.Send("north") --shulin10
		--world.Send("south")
		self:shulin_kongdi()
	 else
        local f=function()
		 local w
		 w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:shulin_kongdi()
		 end
		 w:go(1496)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--caidi_cunzhongxin 华山菜地 到 村中心
function alias:caidi_cunzhongxin()
--你乱走了一通，居然发现自己走回了原地。
--这个方向没有出路。
--你的动作还没有完成，不能移动。
--print("测试")
 world.Send("n")
  wait.make(function()


	 local l,w=wait.regexp("^(> |)菜地 \\- .*$|^(> |)你的动作还没有完成，不能移动。$|^(> |)你乱走了一通，居然发现自己走回了原地。$|^(> |)这个方向没有出路。$",5)
	 if l==nil then
        --print("test3")
	    self:caidi_cunzhongxin()
	    return
	 end
	 if string.find(l,"你的动作还没有完成") then
	   --print("test")
	    wait.time(0.3)
		self:caidi_cunzhongxin()
		return
	 end
     if string.find(l,"居然发现自己走回了原地") then
	    self:finish()
	    return
	 end
     if string.find(l,"这个方向没有出路") then
        local f=function()
	      local w
		 w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:finish()
		 end
		 w:go(651) end
		 self:redo(f)
		return
	 end
     if string.find(l,"菜地") then
	    --print("test2")
		wait.time(0.3)
		self:caidi_cunzhongxin()

        return

	 end

 end)
end

--songlin_shanjiao
--进入松树林后s;e;s;然后走n;#4 e找到穆人清，因为穆的所在地是随机变动的，所以如果一次不行就请#4 n;e走一次，最多不会超过6次。找到穆人清后，再w;s就到华山脚下了。
function alias:songlin_shanjiao()
--print("why")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3095 then
	   self:finish()
	 elseif roomno[1]==956 then
	   --[[local f=function()
	     world.Execute("north;east;east;east;east;east")
		 wait.time(0.3)
		 world.Execute("north;north;north;north;east")
		 wait.time(0.3)
		 world.Execute("north;north;north;north;east")
         self:songlin_shanjiao()
	   end
	   f_wait(f,0.2)]]
		local p={"north","east","east","east","east","north","north","north","north","east"}
         alias.circle_co=coroutine.create(function()
        --print("启动3")
        for _,i in ipairs(p) do
	       world.Send(i)
		   print("松树林遍历:",i)
           self:circle_done("songlin_shanjiao")
	       coroutine.yield()
	    end
	     self:songlin_shanjiao()
       end)
       coroutine.resume(alias.circle_co)



	 elseif roomno[1]==1508 then
		world.Send("west")
		self:finish()
	 else
	      local f=function()
          local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:songlin_shanjiao()
		end
		w:go(956)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:tiao()
   world.Send("tiao gou")
   self:finish()
end

function alias:tiaodown()
   world.Send("tiao down")
   self:finish()
end

function alias:pullgatesouthdown()

   --布旺亲饶白了你一眼道：“门已经开着你还敲？
   --[[你走到门前，轻轻地扣了两下门环。
> 吱的一声，门向里开了。

巴桑喀走了出来。
巴桑喀说道：这位小兄弟光临大轮寺,请入内礼佛。]]
   wait.make(function()
      world.Send("pull gate")
	  local l,w=wait.regexp("^(> |)门已经是开着的！$|^(> |)你将大门拉开。$|^(> |)什么.*",5)
      if l==nil then
	     self:pullgatesouthdown()
	     return
	  end
	  if string.find(l,"你将大门拉开") or string.find(l,"门已经是开着的") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("southdown")
		  self:finish()
		end
		b:check()
		return
	  end
	  if string.find(l,"什么") then
	    self:finish()
	    return
	  end
	  wait.time(5)
   end)
end

function alias:opengateenter()
  world.Send("knock gate")
  local f=function()
   world.Execute("open gate;enter")
   self:finish()
  end
  f_wait(f,1)
end

function alias:opengateout()
   world.Execute("open gate;out")
   self:finish()
end

function alias:opengatesouth()

   --布旺亲饶白了你一眼道：“门已经开着你还敲？
   --[[你走到门前，轻轻地扣了两下门环。
> 吱的一声，门向里开了。

巴桑喀走了出来。
巴桑喀说道：这位小兄弟光临大轮寺,请入内礼佛。]]
   wait.make(function()
      world.Send("open gate")
	  local l,w=wait.regexp("^(> |)大门已经是开着了。$|^(> |)你使劲把大门打了开来。$|^(> |)什么.*",5)
      if l==nil then
	     self:opengatesouth()
	     return
	  end
	  if string.find(l,"大门打了开来") or string.find(l,"大门已经是开着了") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("south")
		  self:finish()
		end
		b:check()
		return
	  end
	  if string.find(l,"什么") then
	    self:finish()
	    return
	  end
	  wait.time(5)

   end)
end

function alias:opengatenorth()

   --布旺亲饶白了你一眼道：“门已经开着你还敲？
   --[[你走到门前，轻轻地扣了两下门环。
> 吱的一声，门向里开了。

巴桑喀走了出来。
巴桑喀说道：这位小兄弟光临大轮寺,请入内礼佛。]]
   wait.make(function()
      world.Send("open gate")
	  local l,w=wait.regexp("^(> |)大门已经是开着了。$|^(> |)你使劲把大门打了开来。$|^(> |)什么.*",5)
      if l==nil then
	     self:opengatenorth()
	     return
	  end
	  if string.find(l,"大门打了开来") or string.find(l,"大门已经是开着了") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("north")
		  self:finish()
		end
		b:check()
		return
	  end
	  if string.find(l,"什么") then
	    self:finish()
	    return
	  end
	  wait.time(5)
   end)
end

function alias:dalunsishanmen_dianqianguangchang()
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1669  then
	    self:knockgatenorthup()
	 else

        local f=function()
		local w
		w=walk.new()
		w.walkover=function()
		   self:dalunsishanmen_dianqianguangchang()
		end
		w:go(1669)
		end
		 self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:knockgatenorthup()

   wait.make(function()
      world.Send("knock gate")
	  local l,w=wait.regexp("^(> |)吱的一声，门向里开了。$|^(> |).*白了你一眼道：“门已经开着你还敲？$|(> |)你突然发现原来门是开着的，直接进去就行了。$",5)
      if l==nil then
	     self:knockgatenorthup()
	     return
	  end
	  if string.find(l,"吱的一声，门向里开了") or string.find(l,"门已经开着你还敲") or string.find(l,"你突然发现原来门是开着的，直接进去就行了") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("northup")
		  self:finish()
		end
		b:check()
		return
	  end
	  wait.time(5)

   end)
end

function alias:knockgatenorth()
	world.Send("knock gate")
	world.Send("north")
	local _R
	 _R=Room.new()
	_R.CatchEnd=function()
		local count,roomno=Locate(_R)
	      print("当前房间号",roomno[1])
	        if roomno[1]==780 then
	          self:finish()
	        elseif roomno[1]==781 then
	          self:knockgatenorth()
			else
			  local f=function()
			  local w
			  w=walk.new()
			  w.walkover=function()
			     self:knockgatenorth()
			  end
			  w:go(781)
			  end
			  self:redo(f)
	        end
	end
	_R:CatchStart()
end

function alias:knockgatesouth()
   wait.make(function()
      world.Send("knock gate")
	  local l,w=wait.regexp("^(> |)你提起门环在门上轻轻叩了叩，吱地一声，一位僧人打开大门用锐利的目光上下打量着你。$|^(> |)你要对谁做这个动作？$|^(> |)吱的一声，门向里开了。$|^(> |).*白了你一眼道：“门已经开着你还敲？$",10)
      if l==nil then
	     self:knockgatesouth()
	     return
	  end
	  if string.find(l,"吱的一声") or string.find(l,"门已经开着你还敲") or string.find(l,"一位僧人打开大门用锐利的目光上下打量着你") then
	    local b
		b=busy.new()
		b.Next=function()
		  world.Send("south")
		  self:finish()
		end
		b:check()
		return
	  end

	  if string.find(l,"你要对谁做这个动作") then
		  world.Send("south")
	      local _R
          _R=Room.new()
          _R.CatchEnd=function()
          local count,roomno=Locate(_R)
	      print("当前房间号",roomno[1])
	        if roomno[1]==1894 then
	          self:finish()
	        elseif roomno[1]==1887 then
	          self:knockgatesouth()
			else

			  local f=function()
			  local w
			  w=walk.new()
			  w.walkover=function()
			     self:knockgatesouth()
			  end
			  w:go(1887)
			  end
			  self:redo(f)
	        end
         end
        _R:CatchStart()
	     return
	  end
	  wait.time(10)

   end)
end
--[[青城沙漠
#10 w s，不行就 quit and relogin，然后再#10 s，一直到出来为止。注意见到enter的地方不要进去，里面是autokill的梅超风与陈玄风。]]
--631 1705
function alias:shamo_quick_qingcheng()
  world.Execute("w;#10 s;")
  local f2=function()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==630 then
	   self:finish()
	 elseif roomno[1]==1705 or roomno[1]==631 then

	   local f=function()
	     --world.Send(d())
         self:shamo_quick_qingcheng()
	   end
	   f_wait(f,0.1)
	 else
	    local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:shamo_quick_qingcheng()
		end
		w:go(630)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
  end
  f_wait(f2,0.3)
end

function alias:shamo_qingcheng(d)
   self:shamo_quick_qingcheng()
 --[[
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==630 then
	   self:finish()
	 elseif roomno[1]==1705 or roomno[1]==631 then
	   if d==nil then
	     local dx={"north","north","north","north","north","south","south","south","south","south","west","west","west","west","west","west","west","west","west","west","south"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         self:shamo_qingcheng(d)
	   end
	   f_wait(f,0.3)
	 else
	    local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:shamo_qingcheng()
		end
		w:go(630)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]
end
--649 - 1706
function alias:heilin_gumu(d)
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1706  then
	   self:finish()
	 elseif roomno[1]==649 then
	   if d==nil then
	     local dx={"east"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         self:heilin_gumu(d)
	   end
	   f_wait(f,0.3)
	 else
	  local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:heilin_gumu()
		end
		w:go(649)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--649 - 648
function alias:heilin_shulin(d)
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==648  then
	   self:finish()
	 elseif roomno[1]==649 then
	   if d==nil then
	     local dx={"west"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         self:heilin_shulin(d)
	   end
	   f_wait(f,0.3)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:heilin_shulin()
		end
		w:go(649)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:gudelin_bailongdong(d)
--[[ 1708
jump zhuang
你跳上了梅花桩。
梅花桩 - down
你跳了上来。]]
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1709  then
	   self:finish()
	 elseif roomno[1]==1710 then

		world.Send("down")
		self:gudelin_bailongdong()
	 elseif roomno[1]==1708 then
	   if d==nil then
	     local dx={"west","south","east","north"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
		 world.Send("jump zhuang")
         self:gudelin_bailongdong(d)
	   end
	   f_wait(f,0.3)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:gudelin_bailongdong()
		end
		w:go(1708)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

--use fire;e;w;n;s;nw;se;ne;sw;out
function alias:jiulaodong_zhouzhiruo()
	world.Execute("use fire;e;w;n;s;nw;se;ne;sw;out")
	self:finish()
end

function alias:leave()
   world.Execute("use fire;leave;leave;leave")
   self:finish()
end

function alias:t_leave()
    world.Send("leave")
	local b=busy.new()
	b.Next=function()
      self:finish()
	end
	b:check()
end

function alias:push_huan()
    world.Send("knock huan")
    world.Send("push huan")
	world.Send("enter")
	local b=busy.new()
	b.Next=function()
      self:finish()
	end
	b:check()
end


--[[进入峨嵋冷杉林以后，千万不要走ne和nw 方向，只要走se方向，如果走了两三次，还走步出来，就先走一下sw,然后se...就可以出来了。
否则会走到小竹林，如果想出来的话，会昏倒的。不过没有危险，进入小竹林以后，只要一直往南走，就会提示:"突然一股奇异的香气扑鼻而来，你只觉得一阵头晕目眩......你觉得自己已经沉迷于香气之中，渐渐的手脚已经不听使唤了……你只觉得头昏脑胀，眼前一黑，接着什么也不知道了...."，等醒过来，只要重复上面的步骤就可以了。



少林寺松树林
去--e;w;e;s;e;n;n;e;w;s 回--w;e;n;e;s;n;e;w;s  ]]

function alias:unwield_northup()
   local sp=special_item.new()
	sp.cooldown=function()
     world.Send("northup")
	 local shield=world.GetVariable("shield") or ""
	 if shield~="" then
	   world.Execute(shield)
	 end
     self:finish()
   end
   sp:unwield_all()
end

function alias:NextPoint()
   coroutine.resume(alias.co)
end

function alias:songlin_check()  --步进检查
   --print("进程恢复 alias")
   self.maze_step=function()
     local f=function()
       self:NextPoint()  --默认回调函数
     end
     f_wait(f,0.1)
   end
   if self.alias_table["songlin_check"].is_search==true then
     self:maze_done()
   else
      self.maze_step()
   end
end

function alias:songlin_shanlu()
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])

	 if roomno[1]==1766 then
		 world.Send("southdown")
		 local dx={"west","east","north","east","south","north","east","west"} --,"south"
	      --[[ alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do
		    --local b=busy.new()
		    --b.interval=0.3
		    --b.Next=function()
			  print(j.."/9 方向:",d)
		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("走到底结束")
			alias.co=nil
		    self:songlin_shanlu()
		 end)
		self:songlin_check()]]
		alias.circle_co=coroutine.create(function()
         --print("启动3")
           for _,i in ipairs(dx) do
	        world.Send(i)
		    print("少林松林遍历:",i)
            self:circle_done("songlin_shanlu")
	        coroutine.yield()
	       end
	       self:finish()
        end)
        --print("启动2")
		coroutine.resume(alias.circle_co)


	 elseif roomno[1]==1764 then
	    if _R.relation=="松树林｜松树林─松树林─松树林｜青云坪" then
		   world.Send("south")
		   self:songlin_shanlu()
		   return
		end
		if _R.relation=="松树林｜松树林─松树林─松树林｜山路" then
		   world.Send("south")
		   self:out_songlin()
		   return
		end
	    print("松林中间开始")
	   if alias.circle_co==nil then
	      local dx={"west","east","south","east","north","north","east","west"} --,"south"

		    alias.circle_co=coroutine.create(function()
            --print("启动3")
             for _,i in ipairs(dx) do
	          world.Send(i)
		      print("少林松林遍历:",i)
              self:circle_done("songlin_shanlu")
	          coroutine.yield()
	         end
			 alias.circle_co=nil
	         self:finish()
           end)
        --print("启动2")
		   coroutine.resume(alias.circle_co)
		else
		  --走到一半的路径 继续
		   print("没走到底")
		   coroutine.resume(alias.circle_co)
		end
	 else
	    local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:songlin_shanlu()
		end
		w:go(1751)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:out_songlin()
   self:finish()
end

function alias:songlin_fumoquan()
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])

	 if roomno[1]==1751 then
	    world.Send("east")
		 local dx={"west","east","south","east","north","north","east","west"} --,"south"
	      --[[ alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do
		    --local b=busy.new()
		    --b.interval=0.3
		    --b.Next=function()
			  print(j.."/9 方向:",d)
		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("走到底结束")
			alias.co=nil
		    self:songlin_fumoquan()
		 end)
		self:songlin_check()]]
        alias.circle_co=coroutine.create(function()
          --print("启动3")
         for _,i in ipairs(dx) do
	        world.Send(i)
		    print("少林松林遍历:",i)
            self:circle_done("songlin_fumoquan")
	        coroutine.yield()
	     end
	     alias.circle_co=nil
	     self:finish()
        end)
        --print("启动2")
        coroutine.resume(alias.circle_co)
	 elseif roomno[1]==1764 then
	    if _R.relation=="松树林｜松树林─松树林─松树林｜青云坪" then
		   world.Send("south")
		   --self:finish()
		   self:out_songlin()
		   return
		end
		if _R.relation=="松树林｜松树林─松树林─松树林｜山路" then
		   world.Send("south")
		   self:songlin_fumoquan()
		   return
		end
	    print("松林中间开始")
	   if alias.circle_co==nil then
	      local dx={"west","east","south","east","north","north","east","west"} --,"south"
	      --[[ alias.co=coroutine.create(function()
		   local d
	       for j,d in ipairs(dx) do
		    --local b=busy.new()
		    --b.interval=0.3
		    --b.Next=function()
			 print(j.."/9 方向:",d)
		     world.Send(d)
             self:songlin_check()
		    --end
			--b:check()
			 coroutine.yield()
	        end
			print("走到底结束")
			alias.co=nil
		    self:songlin_fumoquan()
	       end)
	      self:NextPoint() --启动进程]]

		alias.circle_co=coroutine.create(function()
            --print("启动3")
          for _,i in ipairs(dx) do
	         world.Send(i)
		     print("少林松林遍历:",i)
             self:circle_done("songlin_fumoquan")
	         coroutine.yield()
		  end
		  alias.circle_co=nil
	       self:finish()
        end)
         --print("启动2")
         coroutine.resume(alias.circle_co)
		else
		  --走到一半的路径 继续
		   print("没走到底")
		   coroutine.resume(alias.circle_co)
		end
	 else
	     local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:songlin_fumoquan()
		end
		w:go(1751)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:push_flag()
  world.Send("push flag")
  world.Send("out")
  world.Send("get sheyao")
  world.Send("fu sheyao")
  local b=busy.new()
  b.Next=function()
     self:finish()
  end
  b:check()
end

function alias:shanlu_songlin()
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1751 then
	    world.Send("east")
		 local dx={"west","east","south","east","north","north","east","west"} --,"south"
		--[[alias.co=coroutine.create(function()
		 local d
	     for j,d in ipairs(dx) do
		   --local b=busy.new()
		   --b.interval=0.3
		   --b.Next=function()
			print(j.."/9 方向:",d)
		    world.Send(d)
            self:songlin_check()
		   --end
		   --b:check()
		   coroutine.yield()
	     end
		 print("走到底结束")
		 alias.co=nil
		 self:shanlu_songlin()
	    end)
		 self:songlin_check()]]
		   alias.circle_co=coroutine.create(function()
            --print("启动3")
          for _,i in ipairs(dx) do
	         world.Send(i)
		     print("少林松林遍历:",i)
             self:circle_done("shanlu_songlin")
	         coroutine.yield()
		  end
		  alias.circle_co=nil
	       self:finish()
        end)
         --print("启动2")

         coroutine.resume(alias.circle_co)
	 elseif roomno[1]==1764 then
	     if _R.relation=="松树林｜松树林─松树林─松树林｜青云坪" then
		   --world.Send("south")
		   --self:finish()
		   self:out_songlin()
		   return
		end
	    if _R.relation=="松树林｜松树林─松树林─松树林｜山路" then
		    world.Send("south")
		   --self:finish()
		    self:shanlu_songlin()
		   return
		end
	   print("松林中间开始")
	   if alias.circle_co==nil then
		 local dx={"west","east","south","east","north","north","east","west"} --,"south"
	     --[[alias.co=coroutine.create(function()
		 local d
	     for j,d in ipairs(dx) do
		   --local b=busy.new()
		   --b.interval=0.3
		   --b.Next=function()
			print(j.."/9 方向:",d)
		    world.Send(d)
            self:songlin_check()
		   --end
		   --b:check()
		   coroutine.yield()
	     end]]
		  alias.circle_co=coroutine.create(function()
            --print("启动3")
            for _,i in ipairs(dx) do
	           world.Send(i)
		       print("少林松林遍历:",i)
               self:circle_done("shanlu_songlin")
	           coroutine.yield()
		    end
		    alias.circle_co=nil
	        self:finish()
          end)
          --print("启动2")
          coroutine.resume(alias.circle_co)
		  print("走到底结束")
		  --self:shanlu_songlin()

	   else
		  --走到一半的路径 继续
		  print("没走到底")
		  --[[self.out_songlin=function()
		     print("上次的没走完的路径！！")
			 world.Send("south")
			 local w
		     w=walk.new()
		     w.walkover=function()
		       self:finish()
		     end
		     w:go(1751)
		  end]]
		  --[[self.songlin_check=function()
		     self:NextPoint()
		  end
		  self:NextPoint()]]
		  coroutine.resume(alias.circle_co)
		end
	 else
	    local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:shanlu_songlin()
		end
		w:go(1754)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:fumoquan_songlin()
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1766 then
	     world.Send("southdown")
		local dx={"west","east","north","east","south","north","east","west"} --,"south"
		--[[alias.co=coroutine.create(function()
		 local d
	     for j,d in ipairs(dx) do
		   --local b=busy.new()
		   --b.interval=0.3
		   --b.Next=function()
			print(j.."/9 方向:",d)
		    world.Send(d)
            self:songlin_check()
		   --end
		   --b:check()
		   coroutine.yield()
	     end
		 print("走到底结束")
		 alias.co=nil
		 self:fumoquan_songlin()
	    end)
		 self:songlin_check()]]
		alias.circle_co=coroutine.create(function()
            --print("启动3")
          for _,i in ipairs(dx) do
	         world.Send(i)
		     print("少林松林遍历:",i)
             self:circle_done("fumoquan_songlin")
	         coroutine.yield()
		  end
	       self:finish()
        end)
         --print("启动2")
         coroutine.resume(alias.circle_co)
	 elseif roomno[1]==1764 then
	     if _R.relation=="松树林｜松树林─松树林─松树林｜青云坪" then
		   world.Send("south")
		   self:fumoquan_songlin()
		   return
		end
	    if _R.relation=="松树林｜松树林─松树林─松树林｜山路" then
		   --world.Send("south")
		   --self:finish()
		   self:out_songlin()
		   return
		end
	   print("松林中间开始")
	   if alias.circle_co==nil then
		 local dx={"west","east","north","east","south","north","east","west"} --,"south"
	     --[[alias.co=coroutine.create(function()
		 local d
	     for j,d in ipairs(dx) do
		   --local b=busy.new()
		   --b.interval=0.3
		   --b.Next=function()
			print(j.."/9 方向:",d)
		    world.Send(d)
            self:songlin_check()
		   --end
		   --b:check()
		   coroutine.yield()
	     end]]
		 alias.circle_co=coroutine.create(function()
            --print("启动3")
          for _,i in ipairs(dx) do
	         world.Send(i)
		     print("少林松林遍历:",i)
             self:circle_done("fumoquan_songlin")
	         coroutine.yield()
		  end
		   alias.circle_co=nil
	       self:finish()
        end)
         --print("启动2")
         coroutine.resume(alias.circle_co)
		 print("走到底结束")

		 --self:fumoquan_songlin()

	   else
		  --走到一半的路径 继续
		  print("没走到底")
		  --[[self.out_songlin=function()
		     print("上次的没走完的路径！！")
			 world.Send("south")
			 local w
		     w=walk.new()
		     w.walkover=function()
		       self:finish()
		     end
		     w:go(1751)
		  end]]
		  --[[self.songlin_check=function()
		     self:NextPoint()
		  end
		  self:NextPoint()]]
		  coroutine.resume(alias.circle_co)
		end
	 else
	   local f=function()
        local w
		w=walk.new()
		w.walkover=function()
		   self:fumoquan_songlin()
		end
		w:go(1754)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end



function alias:duxiaohe()
   world.Send("ask lao zhe about 裘千丈")
   local b
   b=busy.new()
   b.interval=0.3
   b.Next=function()
 --> 你试了试，发觉河面很宽，你绝对跳不过去。
   --你向老者打听有关『裘千丈』的消息。
     wait.make(function()
      world.Send("jump river")
	  local l,w=wait.regexp("^(> |)你试了试，发觉河面很宽，你绝对跳不过去。$|^(> |)你要对谁做这个动作？$|^(> |)你踩着水底的暗桩，慢慢的走过了小河。$",5)
	  if l==nil then
		self:duxiaohe()
		return
	  end
	  if string.find(l,"你踩着水底的暗桩，慢慢的走过了小河") then
	   local b2
	   b2=busy.new()
       b2.interval=0.3
	   b2.Next=function()
	    self:finish()
	   end
	   b2:check()
	   return
	  end
	  if string.find(l,"你试了试，发觉河面很宽，你绝对跳不过去") then
        local _R
		_R=Room.new()
        _R.CatchEnd=function()
          local count,roomno=Locate(_R)
	      print("当前房间号",roomno[1])
	      if roomno[1]==1064  then
		    world.Send("west")
			world.Send("east")
            self:duxiaohe()
	      elseif roomno[1]==1063 then
		    world.Send("east")
			world.Send("west")
	        self:duxiaohe()
		  end
        end
        _R:CatchStart()
	    return
	  end
	  if string.find(l,"你要对谁做这个动作") then
	    self:finish()
		return
	  end
	  wait.time(5)
	 end)
   end
   b:check()
end
--[[少林寺竹林
去--nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n 回--s

少林寺回廊
去--w;n;w;w;n 回--s;e;e;s;e]]
--[[你不动声色地靠近陆高轩，偷偷地把手向陆的身上伸去...
你成功地偷到了块通行令牌!]]
--1457_1767
--> 小木筏顺着海风，一直向东飘去。
--只见你轻轻一跃，已坐在木筏上。

function alias:error_mufa()
   world.Send("hua mufa")
   self:shangan()
end

function alias:shangan()
  wait.make(function()
    local l,w=wait.regexp("^(> |)只听“轰”的一声，小木筏好象撞到了什么东西，你一下在子被抛了出来。$|^(> |)你回头一看，小木筏撞得散架，沉到海里了。$|^(> |)小木筏顺着海风，一直向东飘去。$",5)
	if l==nil then
	   self:shangan()
	   return
	end
	if string.find(l,"只听“轰”的一声，小木筏好象撞到了什么东西，你一下在子被抛了出来") or string.find(l,"你回头一看，小木筏撞得散架，沉到海里了") then
	 	local b=busy.new()
		b.Next=function()
		  local shield=world.GetVariable("shield") or ""
	      if shield~="" then
	        world.Execute(shield)
	      end
  	      self:finish()
		end
		b:check()
	   return
	end
	if string.find(l,"小木筏顺着海风，一直向东飘去") then
	  world.Send("hua mufa")
	  self:shangan()
	  return
	end
    wait.time(5)
  end)
end

function alias:mufa()
  -- world.Send("unwield jian")
  local sp=special_item.new()
  sp.cooldown=function()
    world.Send("zuo mufa")
    wait.make(function()
     local l,w=wait.regexp("^(> |)只见你轻轻一跃，已坐在木筏上。$",3)
	 if l==nil then
	   self:shatan_shenlongdao()
	   return
	 end
	 if string.find(l,"只见你轻轻一跃，已坐在木筏上") then
	   world.Send("hua mufa")
	   self:shangan()
	   return
	 end
	 wait.time(3)
   end)
 end
 sp:unwield_all()
end

function alias:shatan_shenlongdao()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1457  then
        self:zuomufa()
	 elseif roomno[1]==1767 then
		local shield=world.GetVariable("shield") or ""
	    if shield~="" then
	      world.Execute(shield)
	    end
	    self:finish()
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shatan_shenlongdao()
		end
		w:go(1457)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:auto_wield_weapon(success_deal,error_deal)
--你将凝晶雁翎箫握在手中。你「唰」的一声抽出一柄长剑握在手中。

   wait.make(function()
	 local l,w=wait.regexp("(.*)\\((.*)\\)$|^(> |)设定环境变量：look \\= 1$",5)
    if l==nil then
	   self:auto_wield_weapon(success_deal,error_deal)
	   return
	end
	if string.find(l,")") then
	   --print(w[1],w[2])
	   local item_name=w[1]
	   item_name=string.gsub(item_name,"【.*】$","")
	   local item_id=string.lower(w[2])

      if string.find(item_id,"sword") or string.find(item_id,"jian") then
	     local s,e=string.find(item_name,"剑")
		 if string.len(item_name)==e then
           world.Send("wield "..item_id)
		   self.weapon_exist=true
		 end
      elseif string.find(item_id,"axe") or string.find(item_id,"fu") then
	    local s,e=string.find(item_name,"斧")
		 if string.len(item_name)==e then
           world.Send("wield "..item_id)
		   self.weapon_exist=true
		 end
      elseif string.find(item_id,"blade") or string.find(item_id,"dao") or string.find(item_id,"xue sui") then
	    local s,e=string.find(item_name,"刀")
		 if string.len(item_name)==e then
           world.Send("wield "..item_id)
		   self.weapon_exist=true
		 end
      elseif string.find(item_id,"dagger") or string.find(item_id,"bishou") then
	     local s,e=string.find(item_name,"匕首")
		 if string.len(item_name)==e then
           world.Send("wield "..item_id)
		   self.weapon_exist=true
		 end
	  --[[elseif string.find(item_id,"club") or string.find(l,"gun") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"fork") or string.find(l,"cha") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"hammer") or string.find(l,"falun") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"hook") or string.find(l,"gou") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"spear") or string.find(l,"qiang") then
         world.Send("wield "..item_id)
      elseif string.find(item_id,"staff") or string.find(l,"zhang") then
         world.Send("wield "..item_id)
	  elseif string.find(item_id,"brush") or string.find(l,"bi") then
          world.Send("wield "..item_id)
	  elseif string.find(item_id,"stick") or string.find(l,"bang") then
	     world.Send("wield "..item_id)
	  elseif string.find(item_id,"xiao") then
	     world.Send("wield "..item_id)
	  elseif string.find(item_id,"whip") or string.find(item_id,"bian") then
	     world.Send("wield "..item_id)]]
	  end
	  self:auto_wield_weapon(success_deal,error_deal)
	  return
	end
	--print(success_deal," why222")
    if string.find(l,"设定环境变量：look") then
	   --print(self.weapon_exits,"值")
	   if self.weapon_exist==true then
	     success_deal()
	   else
	     print("没有合适武器!!，建议购买武器!")
         error_deal()
	   end
	   return
	end
	wait.time(5)
   end)
end

function alias:zuomufa()
    world.Send("wield changjian")
	world.Send("chop tree")
	world.Send("bang mu tou")
	wait.make(function()
	  local l,w=wait.regexp("(> |)只见你用粗绳子将几根大木头绑在一起...|^(> |)你正在用粗绳子将几根大木头绑在一起...$|^(> |)你好象没有武器，拿手砍？$|^(> |)你手上这件兵器无锋无刃，如何能砍树啊？$",3)
	  if l==nil then
	     world.Send("buy cu shengzi")
		 self:shatan_shenlongdao()
		 return
	  end
	  if string.find(l,"你手上这件兵器无锋无刃，如何能砍树啊") then
	      --print("why")
		  local success_deal=function() self:shatan_shenlongdao() end
		  local error_deal=function()
		     self:buy_weapon(success_deal,1466,"blade")
		  end
	     local sp=special_item.new()
		 sp.cooldown=function()
		    self.weapon_exist=false
		    world.Send("i")
		    self:auto_wield_weapon(success_deal,error_deal)
	        world.Send("set look 1")
		 end
		 sp:unwield_all()
		 return
	  end
	  if string.find(l,"你好象没有武器，拿手砍") then
	   local success_deal=function() self:shatan_shenlongdao() end
		  local error_deal=function()
		     self:buy_weapon(success_deal,1466,"blade")
		  end
	     local sp=special_item.new()
		 sp.cooldown=function()
		    self.weapon_exist=false
		    world.Send("i")
		    self:auto_wield_weapon(success_deal,error_deal)
	        world.Send("set look 1")
		 end
		 sp:unwield_all()
		 return
	  end
	  if string.find(l,"只见你用粗绳子将几根大木头绑在一起") or string.find(l,"你正在用粗绳子将几根大木头绑在一起") then
	    print("木筏做成")
		self:mufa()
		return
	  end
	  wait.time(3)
	end)
end

function alias:order_chuan()
  wait.make(function()
   local l,w=wait.regexp("(> |)你轻轻一跃，下了船。",5)
   if l==nil then
     self:order_chuan()
     return
   end
   if string.find(l,"你轻轻一跃，下了船") then
	 self:finish()
	 return
   end
   wait.time(5)
  end)
end

function alias:wait_chuan()
   wait.make(function()
     local l,w=wait.regexp("你轻轻一跃，上了小船",20) --等待20秒
	 if l==nil then
	    print("等待20秒没有响应!")
	    self:give_lingpai()
	    return
	 end
	if string.find(l,"你轻轻一跃，上了小船") then
		  world.Send("order 开船")
		  self:order_chuan()
		  return
	end
     wait.time(20)
   end)
end

function alias:give_lingpai()
   local w
   w=walk.new()
   w.walkover=function()
       wait.make(function()
        world.Send("give ling pai to chuan fu")

		local l,w=wait.regexp("你轻轻一跃，上了小船。|你身上没有这样东西。|^(> |)对方不接受这样东西。$|^(> |)船夫说道：「现在没船，请等一会吧。」$",5)
		if l==nil then
		  self:give_lingpai()
		  return
		end
		if string.find(l,"你身上没有这样东西") or string.find(l,"对方不接受这样东西") then
		   self:steal_lingpai()
		   return
		end
		if string.find(l,"你轻轻一跃，上了小船") then
		  world.Send("order 开船")
		  self:order_chuan()
		  return
		end
		if string.find(l,"现在没船，请等一会吧") then
		  self:wait_chuan()
		  return
		end
		wait.time(5)
	   end)
   end
   w:go(1767)
end

function alias:steal_lingpai()
	local w
	w=walk.new()
	w.walkover=function()
	  wait.make(function()
	    world.Send("steal lingpai")
		local l,w=wait.regexp("你成功地偷到了块通行令牌!|^(> |)你已经有了令牌，还偷它作甚？$",5)
		if l==nil then
		   self:steal_lingpai()
		   return
		end
		if string.find(l,"你成功地偷到了块通行令牌") or string.find(l,"你已经有了令牌，还偷它作甚") then
		   self:give_lingpai()
		   return
		end
		wait.time(5)
	  end)

	end
	w:go(1772)
end

function alias:shenlongdao_shatan()
    self:steal_lingpai()
end
--1772 _ 1767 上船
--steal lingpai
--[[你不动声色地靠近陆高轩，偷偷地把手向陆的身上伸去...
你成功地偷到了块通行令牌!]]
--give ling pai to chuan fu
--[[你给船夫一块通行令牌。
> 船夫说道：「既然有神龙教通行令牌，我这就带你上船！」

只见船夫向海上打了个手势，似乎是什么暗号。
不一会儿，一艘小帆船从海上缓缓驶来。

船夫对你说道：「海上风大，一切小心！」
你轻轻一跃，上了小船。]]
--order 开船
--只见小帆船慢慢的减速，缓缓向岸边驶去。精灵风轻轻一跃，下了船。
--“到了！”水手对你吆喝一声。
--你轻轻一跃，下了船。

--梅庄 1180 进入
--[[s 进入 梅庄 n 出 梅庄
xixi;#if @step=s {next_step=w};#if @step=w {next_step=n};#if @step=n {next_step=e};#if @step=e {next_step=s};step=@next_step;@step

#if @step=n {next_step=w};#if @step=w {next_step=s};#if @step=s {next_step=e};#if @step=e {next_step=n};step=@next_step;@step
--]]
local function way_meizhuang(dx)
  if dx=="south" then
     dx="west"
  elseif dx=="west" then
     dx="north"
  elseif dx=="north" then
     dx="east"
  else
     dx="south"
  end
  return dx
end

local function noway_meizhuang(dx)
   if dx=="north" then
     dx="west"
  elseif dx=="west" then
     dx="south"
  elseif dx=="south" then
     dx="east"
  else
     dx="north"
  end
  return dx
end

function alias:out_meizhuang(dx)
      if dx==nil then
           dx="north"
      end

		world.Send(dx)
		wait.make(function()
		   local l,w=wait.regexp("^(> |)这个方向没有出路。$|^(> |)梅林 - .*$|^(> |)小路 - .*$|^(> |)青石板大路 - .*$",5)
		   if l==nil then
			  self:out_meizhuang()
			  return
		   end
		   if string.find(l,"这个方向没有出路") then
		      print("失败")

		      local dx1=noway_meizhuang(dx)
			   print(dx1)
		       local f=function()
			    self:out_meizhuang(dx1)
			  end
			  f_wait(f,0.3)
		      return
		   end
		   if string.find(l,"梅林") then
		      print("成功")
			  local dx2=way_meizhuang(dx)
			  print(dx2)
			  local f=function()
			    self:out_meizhuang(dx2)
			  end
			  f_wait(f,0.3)
			  return
		   end
		   if string.find(l,"小路") then
		       self:finish()
			   return
		   end
		   if string.find(l,"青石板大路") then
		       self:out_meizhuang()
			  --self:finish()
		      return
		   end
		end)

end

function alias:enter_meizhuang(dx)

     if dx==nil then
           dx="south"
      end

		world.Send(dx)
		wait.make(function()
		   local l,w=wait.regexp("^(> |)这个方向没有出路。$|^(> |)梅林 - .*$|^(> |)小路 - .*$|^(> |)青石板大路 - .*$",5)
		   if l==nil then
			  self:enter_meizhuang()
			  return
		   end
		   if string.find(l,"这个方向没有出路") then
		      print("失败")

		      local dx1=noway_meizhuang(dx)
			   print(dx1)
		       local f=function()
			    self:enter_meizhuang(dx1)
			  end
			  f_wait(f,0.3)
		      return
		   end
		   if string.find(l,"梅林") then
		      print("成功")
			  local dx2=way_meizhuang(dx)
			  print(dx2)
			  local f=function()
			    self:enter_meizhuang(dx2)
			  end
			  f_wait(f,0.3)
			  return
		   end
		   if string.find(l,"小路") then
		       self:enter_meizhuang()
			   return
		   end
		   if string.find(l,"青石板大路") then

			  self:finish()
		      return
		   end
		end)
end

-- 1066_1848 north
function alias:hubinxiaolu_guiyunzhuang()
   world.Execute("#4 n")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
	 if _R.roomname=="归云庄前"  then
	   self:finish()
	 elseif _R.roomname=="树林"  then
	   world.Execute("s;s")
	   self:finish()
	 elseif _R.roomname=="草地"  then
	   world.Send("s")
	   self:finish()
	 elseif _R.roomname=="湖滨小路" then
	   local f=function()
         self:hubinxiaolu_guiyunzhuang()
	   end
	   f_wait(f,0.1)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:hubinxiaolu_guiyunzhuang()
		end
		w:go(1066)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
-- 1066_1065 south
function alias:hubinxiaolu_hubinxiaolu()
  world.Execute("#3 s")
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     --local count,roomno=Locate(_R)
	  --print("当前房间号",roomno[1])
	 if string.find(_R.relation,"湖滨小路｜湖滨小路─小河西岸")  then
	   self:finish()
	 elseif string.find(_R.relation,"归云庄前｜湖滨小路｜湖滨小路") then
	   local f=function()
	      self:hubinxiaolu_hubinxiaolu()
	   end
	   f_wait(f,0.1)
	 elseif _R.roomname=="小酒馆" then
	    world.Send("n")
		self:finish()
	 else

	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:hubinxiaolu_hubinxiaolu()
		end
		w:go(1066)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:qusuzhou()
   --self:error_boat()
   self:yellboat()
end

function alias:error_boat()  --防止被打断
   world.AddTriggerEx ("error_boat", "^.*船夫把小舟靠在岸边，快下船吧。$", "Send('out')", trigger_flag.OneShot+trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 300);
   world.SetTriggerOption ("error_boat", "group", "alias")
   world.EnableTrigger("error_boat",true)
end

function alias:shangdao()
   wait.make(function()
      local l,w=wait.regexp("船夫把小舟靠在岸边，快下船吧。$",6)
	  if l==nil then
	     self:shangdao()
		 return
	  end
	  if string.find(l,"船夫把小舟靠在岸边，快下船吧") then
	     world.DeleteTrigger("error_boat")
	     world.Send("out")
		 self:finish()
	     return
	  end
	  wait.time(6)
   end)
end

function alias:qumr()
     world.Send("qu mr")
	 self:error_boat()
 --[[  你在口袋里翻来覆去地找船钱。
>
你把钱交给船家，船家领你上了一条小舟。
船夫把小舟靠在岸边，快下船吧。]]
--终于到了小岛边，船夫把小舟靠在岸边，快下船吧。
--穷光蛋，一边呆着去！
   wait.make(function()
      local l,w=wait.regexp("渡船|小舟|^(> |)什么.*|^(> |)穷光蛋，一边呆着去！$",6)
	  if l==nil then
	     self:qumr()
		 return
	  end
	  if string.find(l,"渡船") or string.find(l,"小舟") then
	     --world.Send("out")
		 --self:finish()
		 self:shangdao()
		 return
	  end
	  if string.find(l,"穷光蛋，一边呆着去") then
			local f=function()
		      local w=walk.new()
			   w.user_alias=self
		       w.walkover=function()
		        self:finish()
			   end
		       w:go(2700)
			 end
		    self:ATM(f)
	    return
	  end
	  if string.find(l,"什么") then
	     --local w=walk.new()
		 --w.walkover=function()
		 --  self:qumr()
		    self:finish()
		 --end
		 --w:go(2700)
	     return
	  end
	  wait.time(6)
   end)
end

function alias:tanqin()
  world.Send("tan qin")
   wait.make(function()
      local l,w=wait.regexp("渡船|小舟|^(> |)什么.*$|^(> |)你要弹什么东西？$",6)
	  if l==nil then
	     self:qumr()
		 return
	  end
	  if string.find(l,"渡船")  or string.find(l,"小舟") then
	     --world.Send("out")
		 --self:finish()
		 self:shangdao()
		 return
	  end
	   if string.find(l,"什么") or string.find(l,"你要弹什么东西") then
	     self:finish()
	     return
	  end
	  wait.time(6)
   end)
end
--只见你轻轻一跃，已坐在木筏上。
function alias:quyanziwu()
   world.Send("qu yanziwu")
   self:error_boat()
 --[[  你在口袋里翻来覆去地找船钱。
>
你把钱交给船家，船家领你上了一条小舟。
船夫把小舟靠在岸边，快下船吧。]]
   wait.make(function()
      local l,w=wait.regexp("渡船|小舟|^(> |)什么.*$|^(> |)穷光蛋，一边呆着去！$",6)
	  if l==nil then
	     self:quyanziwu()
		 return
	  end
	  if string.find(l,"渡船") or string.find(l,"小舟") then
	    -- world.Send("out")
		-- self:finish()
		self:shangdao()
		return
	  end
	  if string.find(l,"穷光蛋，一边呆着去") then
	    local f=function()
		  self:quyanziwu()
		end
		self:ATM(f)
	    return
	  end
	  if string.find(l,"什么") then
	     self:finish()
	     return
	  end
	  wait.time(6)
   end)
end

--;ge tielian;#wa 4000;tiao duimian
--2060 baizhangjian  2297 xianchoumen
--哈萨克小店 2071 buy wan dao
function alias:buy_weapon(f,roomno,weapon_id)
   local w=walk.new()
   w.walkover=function()
      world.Send("buy "..weapon_id)
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)你以.*买下了一.*。$|^.*说道：「穷光蛋，一边呆着去！」",5)
	    if l==nil then
		   self:buy_weapon(f,roomno,weapon_id)
		   return
		end
		if string.find(l,"买下") then
		    f()
		   return
		end
		if string.find(l,"穷光蛋，一边呆着去") then
		   local c=function()
			  self:buy_weapon(f,roomno,weapon_id)
		   end
		   self:qu_gold(c)
		   return
		end
	  end)
   end
   w:go(roomno)
end

function alias:qu_gold(CallBack)
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
          world.Send("qu 5 gold")
		local l,w=wait.regexp("^(> |)你从银号里取出五锭黄金。$",5)
		print("金子")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold()
		   return
		end
		if string.find(l,"你从银号里") then
		   CallBack()
		   return
		end
		wait.time(5)
	  end)
   end
   w:go(410)
end

function alias:tiaoduimian()
   	wait.make(function()
	  local l,w=wait.regexp("(> |)铁链不是已经斩断了吗？$|^(> |)你觉得自己的轻功太差，跳过去岂不是送死！$|(> |)你得用件锋利的器具才能砍断铁链。$|^(> |)你握紧手中.*，内力到处，已将扣在峭壁石洞中的半截铁链斩了下来，握在手中!$|^(> |)你手上这件兵器无锋无刃，如何能砍断这根铁链？$",5)
	  if l==nil then
	     self:tiaoduimian()
		 return
	  end
	  if string.find(l,"你得用件锋利的器具才能砍断铁链") then
		local sp=special_item.new()
		 sp.cooldown=function()
		    local f=function()
			    local f2=function()
				   --print("test2:",self.id)
			       self:baizhangjian_xianchoumen()
				end
				--print("test:",self.id)
				self:redo(f2) --被自定义walk.redo函数覆盖 w:go(targetRoomNo)
			end
		    world.Send("i")
	        world.Send("set look 1")
			 self.weapon_exist=false
		  local error_deal=function()
		     self:buy_weapon(f,2071,"wandao")
		  end
	      self:auto_wield_weapon(f,error_deal)
		end
		sp:unwield_all()
		 return
	  end
	  if string.find(l,"已将扣在峭壁石洞中的半截铁链斩了下来，握在手中") or string.find(l,"铁链不是已经斩断") then
		local b
         b=busy.new()
		 b.interval=0.3
         b.Next=function()
          world.Send("tiao duimian")
          local b1
	       b1=busy.new()
	       b1.interval=0.5
	       b1.Next=function()
	         local sp=special_item.new()
			 sp.cooldown=function()
			   	 local shield=world.GetVariable("shield") or ""
				 if shield~="" then
	               world.Execute(shield)
	             end
			   self:finish()
			 end
	         sp:unwield_all()
	       end
	       b1:check()
         end
         b:check()
		return
	  end
	  if string.find(l,"你觉得自己的轻功太差，跳过去岂不是送死") then
	      self.break_in_failure()
	     return
	  end
	  if string.find(l,"你手上这件兵器无锋无刃，如何能砍断这根铁链") then
	    local sp=special_item.new()
		sp.cooldown=function()
		    local f=function()
			    local f2=function()
				   --print("test2:",self.id)
			       self:baizhangjian_xianchoumen()
				end
				--print("test:",self.id)
				self:redo(f2) --被自定义walk.redo函数覆盖 w:go(targetRoomNo)
			end
		    world.Send("i")
	        world.Send("set look 1")
			 self.weapon_exist=false
		  local error_deal=function()
		     self:buy_weapon(f,2071,"wandao")
		  end
	      self:auto_wield_weapon(f,error_deal)
		end
		sp:unwield_all()
		return
	  end
	  wait.time(5)
	end)
end

function alias:baizhangjian_xianchoumen()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2060  then
		world.Send("wield sword")
		world.Send("wield blade")
		world.Send("wield jian")
		world.Send("wield dagger")
        world.Send("ge tielian")
        self:tiaoduimian()
	 elseif roomno[1]==2297 then
	    self:finish()
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:baizhangjian_xianchoumen()
		end
		w:go(2060)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:xianchoumen_baizhangjian()
    local sp=special_item.new()
	sp.cooldown=function()
	     world.Send("tiao duimian")
        local b
        b=busy.new()
        b.interval=0.5
        b.Next=function()
		   local shield=world.GetVariable("shield") or ""
			if shield~="" then
	               world.Execute(shield)
			end
            self:finish()
        end
        b:check()
	end
	sp:unwield_all()

end


function alias:zhenyelin_circle()
   local p={"north","east","south","west","south","east","west","north","east","west","south"}
   alias.circle_co=coroutine.create(function()
      --print("启动3")
      for _,i in ipairs(p) do
	     world.Send(i)
		 print("针叶林遍历:",i)
         self:circle_done("zhenyelin_circle")
	     coroutine.yield()
	  end
	  self:finish()
   end)
  --print("启动2")
   coroutine.resume(alias.circle_co)
end

--出口  2050  迷宫2049 针叶林
function alias:zhenyelin(d)
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3875  then
	   self:finish()
	 elseif roomno[1]==2049  then
	   if d==nil then
	     local dx={"west;west;west;west;west;west;west;west","south;south;south;south;south;south;south;south","east;east;east;east;east;east;east;east","north;north;north;north;north;north;north;north"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     local dx=""
		 dx="halt;".. d()
		 print("方向:",dx)
	     world.Execute(dx)
         self:zhenyelin(d)
	   end
	   f_wait(f,0.8)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zhenyelin()
		end
		w:go(2049)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--#al 陕晋黄河黑木崖顶去 {#2 n;e;ne;eu;#2 e;#wa 1000;e;ne;#3 n;#2 nw;n;wd;dutan;e;#5 wu;whisper jia 教主文成武德，一统江湖;whisper jia 教主千秋万载，一统江湖;whisper jia 属下忠心为主，万死不辞;whisper jia 教主令旨英明，算无遗策;whisper jia 教主烛照天下，造福万民;whisper jia 教主战无不胜，攻无不克;whisper jia 日月神教文成武德、仁义英明;whisper jia 教主中兴圣教，泽被苍生;wu;zong}
--#al 绝情谷杨过小龙女去 {halt;#10 jian shi;tiao tan;#wa 3000;qian down;#wa 3000;qian down;#wa 3000;qian down;#wa 3000;#10 drop stone;#wa 5000;qian zuoshang;#wa 3000;qian up;#wa 3000;pa up;n;enter;e;e}
--[[function alias:caoyuanbianyuan_sichouzhilu()

  print("alias id step2:",self.id)
 world.Execute("east;east;east;east;east;east")
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1962  then
	   self:finish()
	 elseif roomno[1]==2064 or roomno[1]==2063 then
	   self:caoyuanbianyuan_sichouzhilu()
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(1962)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:sichouzhilu_caoyuanbianyuan()
 world.Execute("west;west;west;west;west;west")
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2063 then
	   self:finish()
	 elseif roomno[1]==1962 or roomno[1]==2064 then
	   self:sichouzhilu_caoyuanbianyuan()
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2063)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end]]

function alias:shamo_caoyuanbianyuan() --沙漠到 草原边缘
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2063  then
	   self:finish()
	 elseif roomno[1]==2064 then

	  local p={"north","west","west","west","west"}
      alias.circle_co=coroutine.create(function()
      --print("启动3")
        for _,i in ipairs(p) do
	     world.Send(i)
		 print("大沙漠遍历:",i)
         self:circle_done("shamo_caoyuanbianyuan")
	     coroutine.yield()
	    end
	      self:shamo_caoyuanbianyuan()
      end)

       coroutine.resume(alias.circle_co)

	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shamo_caoyuanbianyuan()
		end
		w:go(2064)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:shamo_sichouzhilu()  --沙漠 丝绸之路
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1962 then
	   self:finish()
	 elseif roomno[1]==2064 then

	  local p={"north","east","east","east","east"}
      alias.circle_co=coroutine.create(function()
      --print("启动3")
        for _,i in ipairs(p) do
	     world.Send(i)
		 print("大沙漠遍历:",i)
         self:circle_done("shamo_sichouzhilu")
	     coroutine.yield()
	    end
	      self:shamo_sichouzhilu()
        end)
	     coroutine.resume(alias.circle_co)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shamo_sichouzhilu()
		end
		w:go(2064)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--373 药王
--366   山脚

-- 明教树林
--[[明教树林解密
树林深处一共有五处

1 树林深处 - north、northeast、southeast、west
  一棵药草(Yao cao)
  大树干(Da shugan)
  去 (e;s;s)
  回 (se;nw;e;e;w)

2 树林深处 - north、northwest(n;w)
  老虎(Lao hu)
  去 (e;s;s;se;w)
  回 (n;w)

3 树林深处 - northwest、west(nw;e;e;w)
  野兔(Ye tu)
  野兔(Ye tu)
  小树枝(Xiao shuzhi)
  去 (e;e;s)
  回 (nw;e;e;w)

4 树林深处 - north、south
  毒蛇(Snake)
  毒蛇(Snake)
  去 (e;s)
  回 (s;se;nw;e;e;w)

5 树林深处 - east、northwest、south、southwest
  毒蛇(Snake)
  无名尸体(Corpse)
  去(e;e;s;w)
  回(e;nw;e;e;w)

  而树林一共有六处
1 树林 - east、north、south、west 2249
  大树干
  去 (e)
  回 (w)

2 树林 - east、north、south、west 2250 _2251
  常遇春
  去 (e;e;w) -- e e 测试
  回 (e;e;w) ok

3 树林 - east、north、south、west 2250 _2252
  朱元璋
  去 (e;e)  -- 不对 先要经过 2251 e e w e
  回 (e;w)  ok

4 树林 - east、north、south、west 2250 _2253
  去 (w;w;e;w) -- 不对 先要经过 2254
  回 (e;e) ok

5 树林 - east、north、south、west 2250 _2254
  小树枝(Xiao shuzhi)
  明教洪水旗弟子 徐达(Xu da)
  去 (w;w) ok
  回 (e;w;e;e) ? 不对 必定有一个连接 2253

6 树林 - east、north、south、west 2169
  大石头
  小石头
  去(w)
  回(e)]]
--2250 特殊迷宫 依靠房间npc来确定房间位置
--2168 巨木旗
--2169 树木
--2249 树木
--2168 巨木旗 明教
--[[在这个房间中, 生物及物品的(英文)名称如下：
巨木旗教众 = jiao zhong, zhong
巨木旗教众 = jiao zhong, zhong
巨木旗教众 = jiao zhong, zhong
叶知秋 = outstand
闻苍松 = wen cangsong, wen, cangsong]]

local function dx_mingjiaoshulin(index)

	local dx={"east","north","west","south"}
	if index==nil then
	  index=0
	end
	local new_index=index+1
	if new_index>4 then
	   new_index=1
	end
	return dx[new_index],new_index
end

function alias:mingjiaoshulin_noman()
	 wait.make(function()
		 --local d,new_index=dx_mingjiaoshulin(index)
		 --print("方向",d," new_index:",new_index)
		 --world.Send("look " ..d)
		 world.Send("look")
        local l,w=wait.regexp("^(> |).*树林深处 -.*$|^.*常遇春.*$|^.*朱元璋.*$|^.*徐达.*$",4)
        if l==nil then
		  --探测是否结束
		  print("探测是否结束")
		  wait.make(function()
		    world.Send("set look 1")
			local l,w=wait.regexp("^(> |)设定环境变量：look \\= 1$",3)
			if l==nil then
			--超时
			  print("超时或未预期的错误!")
			  self:mingjiaoshulin_noman()
			  return
			end
			if string.find(l,"设定环境变量：look") then
	           --正确
				print("正确方向:",d)
	            world.Send(d)
			    self:mingjiaoshulin_houtuqi()
			   return
			end
		    wait.time(3)
		  end)
		  return
		end
		if string.find(l,"树林深处") then
		   world.Send("north")
		   world.Send("northwest")
		   self:mingjiaoshulin_noman()
		   return
		end
		if string.find(l,"常遇春") or string.find(l,"朱元璋") or string.find(l,"徐达") then
		   print("不是正确方向")
		   world.Send("west")
		   self:mingjiaoshulin_noman()
		   return
		end
		--2169

	    wait.time(4)
	 end)
end

function alias:mingjiaoshulin_zhuyuanzhang(index)
	 wait.make(function()
	     local d,new_index=dx_mingjiaoshulin(index)
		 world.Send("look " ..d)
		 print("方向",d," new_index:",new_index)
        local l,w=wait.regexp("^树林深处 -$|^.*常遇春.*$|^.*朱元璋.*$|^.*徐达.*$",5)
		if l==nil then
		  self:mingjiaoshulin_zhuyuanzhang(index)
		  return
		end
        if string.find(l,"朱元璋") then
		  print("正确方向:",d)
	      world.Send(d)
  	      self:mingjiaoshulin_houtuqi()
	      return
	    end
	    if string.find(l,"徐达") or string.find(l,"常遇春")  then
		  print("不是正确方向")
		  self:mingjiaoshulin_zhuyuanzhang(new_index)
		  return
	    end
		if string.find(l,"树林深处") then
		  world.Send("north")
		  world.Send("northwest")
		  self:mingjiaoshulin_zhuyuanzhang(new_index)
		end
	    wait.time(5)
	 end)
end

function alias:mingjiaoshulin_houtuqi()
  wait.make(function()
   world.Send("look")
   world.Send("set look 1")
   local l,w=wait.regexp("^.*常遇春.*$|^.*朱元璋.*$|^.*徐达.*$|^(> |)设定环境变量：look \\= 1$",5)
   if l==nil then
      self:mingjiaoshulin_houtuqi()
      return
   end
   if string.find(l,"常遇春") then
   -- 树林(常遇春)：e;n 返回路径：#2 e;w

      -- 先跑到 朱元璋 2252
      world.Execute("east;east;west")
	  self:finish()
	  return
   end

   if string.find(l,"朱元璋") then
      world.Execute("east;west")
	  self:finish()
	  return
   end

   if string.find(l,"徐达") then
   -- 树林(徐达)：#2 w 返回路径：：#6 w;#2 nw;se;nw;#2 e;w
      --先跑到 2253
      world.Execute("west;west;west;west;west;west;northwest;northwest;southeast;northwest;east;east;west")
	  self:finish()
	  return
   end

   if string.find(l,"设定环境变量：look") then
       world.Execute("east;east")
	   self:finish()
       return
   end
   wait.time(5)
  end)

end
--2249 west shuling1
--"south" : __DIR__"shuling3",
--"west" : __DIR__"shuling4",

--2169 east shuling2
--"north" : __DIR__"shuling6",

--shuling6 常遇春 chang
--"east" : __DIR__"shuling5",
--"north" : __DIR__"shuling4",
--shuling5 zhu
--"east" : __DIR__"shuling2",
--"north" : __DIR__"shuling6",
--shuling4 xu
--"south" : __DIR__"shuling3",
--"north" shenchu

--shuling3
--"east" : __DIR__"shuling1",
--"north" : __DIR__"shuling4",
local shenchu_dx=""
function alias:shuling_shenchu(CallBack)
   shenchu_dx=""
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      print(_R.relation)
       if _R.relation=="树林深处｜树林─树林─树林｜树林" then
	       shenchu_dx="north"
	   elseif _R.relation=="树林｜树林─树林─树林｜树林深处" then
	       shenchu_dx="south"
	   elseif _R.relation=="树林｜树林深处─树林─树林｜树林" then
	       shenchu_dx="west"
 	   end
	   print("方向",shenchu_dx)
	   CallBack()
   end
   _R:CatchStart()
end

function alias:houtuqi_mingjiaoshulin1() --4个子房间 shuling6



 --2251  常遇春
   wait.make(function()
   world.Send("look")
   world.Send("set look 1")
   local l,w=wait.regexp("^.*常遇春.*$|^.*朱元璋.*$|^.*徐达.*$|^(> |)设定环境变量：look \\= 1$",5)
   if l==nil then
      self:houtuqi_mingjiaoshulin1()
      return
   end
   if string.find(l,"常遇春") then
      self:finish()
	  return
   end

   if string.find(l,"朱元璋") then
     --5 -> 6 west
	 local f=function()
	   if shenchu_dx=="west" then
         world.Send("north")
	   elseif shenchu_dx=="north" then
	     world.Send("south")
	   elseif shenchu_dx=="south" then
	     world.Send("west")
	   end
       self:finish()
	 end
	 self:shuling_shenchu(f)

	  return
   end

   if string.find(l,"徐达") then
   -- 树林(徐达)：#2 w 返回路径：：#6 w;#2 nw;se;nw;#2 e;w
      --先跑到 2253
       --4->6 north
	  local f=function()
		if shenchu_dx=="north" then
           world.Send("south")
	    elseif shenchu_dx=="south" then
	      world.Send("west")
	    elseif shenchu_dx=="west" then
	      world.Send("north")
	    end
	    world.Execute("east;east;east;north")
        self:finish()
      end
	  self:shuling_shenchu(f)
	  return
   end

   if string.find(l,"设定环境变量：look") then
       world.Execute("east;east;east;north")

       self:finish()
       return
   end
   wait.time(5)
  end)

end

--2249 west shuling1
--"south" : __DIR__"shuling3",
--"west" : __DIR__"shuling4",

--2169 east shuling2
--"north" : __DIR__"shuling6",

--shuling6 常遇春 chang
--"east" : __DIR__"shuling5",
--"north" : __DIR__"shuling4",
--"west" : __DIR__"shenchu4",
--w n |n s| s w |e e

--shuling5 zhu 朱元璋
--"east" : __DIR__"shuling2",
--"north" : __DIR__"shuling6",
--"west" : __DIR__"shenchu4",
--"south" : __DIR__"shuling5",
--w n |n s| s w |e e


--shuling4 xu 徐达
--"south" : __DIR__"shuling3",
--"north" : __DIR__"shenchu1",
--w n |n s| s w |e e

--shuling3
--"east" : __DIR__"shuling1",
--"north" : __DIR__"shuling4",
--"west" : __DIR__"shenchu1",
--w n |n s| s w |e e

function alias:houtuqi_mingjiaoshulin2() --shuling5
 --2252 朱元璋
  wait.make(function()
   world.Send("look")
   world.Send("set look 1")
   local l,w=wait.regexp("^.*常遇春.*$|^.*朱元璋.*$|^.*徐达.*$|^(> |)设定环境变量：look \\= 1$",5)
   if l==nil then
      self:houtuqi_mingjiaoshulin2()
      return
   end
   if string.find(l,"常遇春") then
      --6 ->5
      world.Send("east")
      self:finish()
	  return
   end

   if string.find(l,"朱元璋") then
      self:finish()
	  return
   end

   if string.find(l,"徐达") then
   -- 树林(徐达)：#2 w 返回路径：：#6 w;#2 nw;se;nw;#2 e;w
      --先跑到 2253
      --4 >5
	  local f=function()
	    if shenchu_dx=="north" then
           world.Send("south")
	    elseif shenchu_dx=="south" then
	      world.Send("west")
	    elseif shenchu_dx=="west" then
	      world.Send("north")
	   end
	   world.Execute("east;east;east;east;east")
       self:finish()
	  end
	  self:shuling_shenchu(f)
	  return
   end

   if string.find(l,"设定环境变量：look") then
       world.Execute("east;east;east;east;east")
       self:finish()
       return
   end
   wait.time(5)
  end)

end
--2249 west shuling1
--"south" : __DIR__"shuling3",
--"west" : __DIR__"shuling4",

--2169 east shuling2
--"north" : __DIR__"shuling6",

--shuling6 常遇春 chang
--"east" : __DIR__"shuling5",
--"north" : __DIR__"shuling4",
--shuling5 zhu
--"east" : __DIR__"shuling2",
--"north" : __DIR__"shuling6",
--shuling4 xu
--"south" : __DIR__"shuling3",
--shuling3
--"east" : __DIR__"shuling1",
--"north" : __DIR__"shuling4",

function alias:houtuqi_mingjiaoshulin3() --shuling3
 --2253 徐达隔壁 随机一个房间
 wait.make(function()
    self:shuling_shenchu()
   world.Send("set look 1")
   local l,w=wait.regexp("^.*常遇春.*$|^.*朱元璋.*$|^.*徐达.*$|^(> |)设定环境变量：look \\= 1$",5)
   if l==nil then
      self:houtuqi_mingjiaoshulin3()
      return
   end
   if string.find(l,"常遇春") then
   -- 树林(常遇春)：e;n 返回路径：#2 e;w

      --6->3

	  world.Execute("east;east;west;west;south")
      self:finish()

	  return
   end

   if string.find(l,"朱元璋") then
	--5-3
	  --world.Execute("north;north;south")
      --self:finish()
	  world.Execute("east;west;west;south")

	  self:finish()

	  return
   end

   if string.find(l,"徐达") then
   -- 树林(徐达)：#2 w 返回路径：：#6 w;#2 nw;se;nw;#2 e;w
      --先跑到 2253
	  -- 4 3
	  --world.Send("south")
	  local f=function()
	    if shenchu_dx=="north" then
           world.Send("south")
	    elseif shenchu_dx=="south" then
	      world.Send("west")
	    elseif shenchu_dx=="west" then
	      world.Send("north")
	    end
        self:finish()
	  end
	  self:shuling_shenchu(f)
	  return
   end

   if string.find(l,"设定环境变量：look") then
       self:finish()
       return
   end
   wait.time(5)
  end)
end

--2249 west shuling1
--"south" : __DIR__"shuling3",
--"west" : __DIR__"shuling4",

--2169 east shuling2
--"north" : __DIR__"shuling6",

--shuling6 常遇春 chang
--"east" : __DIR__"shuling5",
--"north" : __DIR__"shuling4",
--shuling5 zhu
--"east" : __DIR__"shuling2",
--"north" : __DIR__"shuling6",
--shuling4 xu
--"south" : __DIR__"shuling3",
--shuling3
--"east" : __DIR__"shuling1",
--"north" : __DIR__"shuling4",

function alias:houtuqi_mingjiaoshulin4() --shuling4
 --2254 徐达
   wait.make(function()
    self:shuling_shenchu()
   world.Send("set look 1")
   local l,w=wait.regexp("^.*常遇春.*$|^.*朱元璋.*$|^.*徐达.*$|^(> |)设定环境变量：look \\= 1$",5)
   if l==nil then
      self:houtuqi_mingjiaoshulin4()
      return
   end
   if string.find(l,"常遇春") then
   -- 树林(常遇春)：e;n 返回路径：#2 e;w
   --"north" : __DIR__"shenchu1",
     local f=function()
	  if shenchu_dx=="west" then
       world.Send("north")
	  elseif shenchu_dx=="north" then
	   world.Send("south")
	  elseif shenchu_dx=="south" then
	   world.Send("west")
	  end
      --6 -4
       self:finish()

	   end
	  self:shuling_shenchu(f)
	  return
   end

   if string.find(l,"朱元璋") then
     --5 4
	  world.Execute("east;west;west;east")
	  self:finish()
	  return
   end

   if string.find(l,"徐达") then
   -- 树林(徐达)：#2 w 返回路径：：#6 w;#2 nw;se;nw;#2 e;w
      --先跑到 2253

      self:finish()
	  return
   end

   if string.find(l,"设定环境变量：look") then
	  --3 4
	 local f=function()
	   	if shenchu_dx=="west" then
          world.Send("north")
	    elseif shenchu_dx=="north" then
	      world.Send("south")
		elseif shenchu_dx=="south" then
	      world.Send("west")
	    end
        self:finish()
	 end
	 self:shuling_shenchu(f)
       return
   end
   wait.time(5)
  end)

end

--回调函数

function alias:break_in_failure(f)
 --闯入失败 默认
   print("默认break fail处理函数")
   print("延迟3s 重新行走",self.break_in_count)
   self.break_in_count=self.break_in_count+1
   if self.break_in_count>5 then
      print("失败超过5次")
        self:finish()
	  return
   end
   if f==nil then
      print("空函数")
   else
      f_wait(f,3)
   end
  --[[ if type (self.finish) == "function" then
    -- print("jieshu")
     self:finish()
	else
	  print("空函数")
   end]]
end

local function defeat_guard(id,exps)
   if (id=="ya yi" or id=="guan bing" or id=="bing" or id=="ya huan" or id=="guan jia" or id=="dali guanbing|dali guanbing|dali wujiang" or id=="a bi" or id=="jia ding") and tonumber(exps)>=80000 then
      return true
   end
   if (id=="ren feiyan") and tonumber(exps)>=500000 then
      return true
   end
   if (id=="hou zi") and tonumber(exps)>=20000 then
      return true
   end
   if (id=="hufa lama" or id=="da yayi" or id=="caihua zi") and tonumber(exps)>=100000 then
      return true
   end
   if (id=="chanshi|wu seng|wu seng" or id=="zayi lama") and tonumber(exps)>=300000 then
      return true
   end
   if (id=="bangzhong") and tonumber(exps)>=80000 then
      return true
   end
   if (id=="yin wushou" or id=="chanshi" or id=="zhuang ding" or id=="wu seng" or id=="dizi") and tonumber(exps)>=400000 then
      return true
   end
   if (id=="ge guangpei|gan guanghao")  and tonumber(exps)>=200000 then
      return true
   end
   if (id=="hong xiaotian" or id=="xi huazi" or id=="yin liting") and tonumber(exps)>=350000 then
     return true
   end
   if (id=="wu guangsheng|yu guangbiao" or id=="rong ziju" or id=="zhao liangdong") and tonumber(exps)>=300000 then
     return true
   end
   if (id=="gong guangjie|xin shuangqing|zuo zimu") and tonumber(exps)>=300000 then
     return true
   end
   if (id=="guan bing|guan bing|wu jiang") and tonumber(exps)>=200000 then
     return true
   end
   if id=="yang xiao" and tonumber(exps)>=5000000 then
     return true
   end
    if (id=="fan yao" or id=="ding mian") and tonumber(exps)>=1200000 then
     return true
   end
   if (id=="fan yiweng")  and tonumber(exps)>=800000 then
     return true
   end
   if (id=="yu lianzhou" or id=="zhang songxi" or id=="xuansheng dashi") and tonumber(exps)>1300000 then
      return true
   end
   if (id=="dadian dashi" or id=="he taichong" or id=="benyin dashi") and tonumber(exps)>2000000 then
      return true
   end
   if (id=="murong bo") and tonumber(exps)>20000000 then
	  return true
   end
   if (id=="zhong wanchou") and tonumber(exps)>=800000 then
      return true
   end
   if (id=="huang lingtian|ling zhentian" or id=="shitai") and tonumber(exps)>=500000 then
      return true
   end
   --print("false")
   return false
end

local break_npc=nil
function break_npc_id(ids)
   local id={}
   id=Split(ids,"|")
   local index=0
   return function()
     index=index+1
	 if index>table.getn(id) then
	    index=1
	 end
	 --print(id[index])
	 local is_end=true
	 if index<table.getn(id) then
	   is_end=false
	 end
	 return id[index],is_end
   end
end

function convert_pfm(pfm)
    pfm=string.gsub(pfm,"perform dazhuan","perform wushuai")
	pfm=string.gsub(pfm,"perform hammer.dazhuan","perform hammer.wushuai")
	pfm=string.gsub(pfm,"perform parry.dazhuan","perform parry.wushuai")

	--[[

	wield jian;wield sword;jifa blade jindao-heijian;jifa sword jindao-heijian;jifa parry jindao-heijian;perform sword.nizhuan;perform sword.jianquan;perform sword.daoluanren;jifa sword huashan-jianfa;jifa parry huashan-jianfa;jiali max;perform sword.luomu;perform sword.cangsong;yun yujianshi;yun refresh;jiali 1
	]]
	pfm=string.gsub(pfm,"perform sword.nizhuan;","")
	pfm=string.gsub(pfm,"perform sword.jianquan;","")
	pfm=string.gsub(pfm,"perform sword.daoluanren;","")

	return pfm
end

function alias:block_kill(id,f,is_end)
    --local pfm=world.GetVariable("pfm") or ""
    --world.Send("alias pfm "..pfm)
	    local pfm=world.GetVariable("pfm") or ""
		pfm=convert_pfm(pfm)
	    world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
		world.Send("set wimpy 100")
     world.Send("kill "..id)

      wait.make(function()
       local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了.*|^(> |)这里没有这个人。$",15)
	   if l==nil then
	      self:block_kill(id,f,is_end)
		  return
	   end
	   if string.find(l,"挣扎着抽动了几下就死了") or (string.find(l,"这里没有这个人") and is_end==true) then
	     world.Send("unset wimpy")
         local b=busy.new()
         b.interval=0.3
         b.Next=function()
		   f()
		 end
		 b:check()
		 return
	   end
	   if string.find(l,"这里没有这个人") and is_end==false then
		  world.Send("unset wimpy")
	      self:compare(f)
		  return
	   end
	   wait.time(15)
	  end)
end

function alias:get_break_npc()
   local npc,is_end=break_npc()
   return npc
end

function alias:compare(CallBack)
   local npc,is_end=break_npc()
   wait.make(function()
     world.Send("compare "..npc)
	 --world.AppendToNotepad (WorldName().."_挡路NPC:",os.date()..": NPC:"..npc.."\r\n")
	 local l,w=wait.regexp("^(> |)"..npc.." 不在这里$|^(> |)你感觉.*不过是个大肉脚, 根本不屑一顾。$|^(> |)哇哈哈哈～, .*看起来根本不是你的对手!$|^(> |)你要杀死.*就如要踩死蚂蚁般容易。$|^(> |)虽然从各方面看来你都比.*略胜一筹, 但是也不能轻敌。$|你以本身修为判断.*的级数。",5)
	  if l==nil then
	     self:compare(CallBack)
	     return
	  end
	  if string.find(l,"不在这里") or string.find(l,"根本不屑一顾") or string.find(l,"不是你的对手") or string.find(l,"踩死蚂蚁般容易") or string.find(l,"但是也不能轻敌") then
	      self:block_kill(npc,CallBack,is_end)
	      return
	  end
	  if string.find(l,"你以本身修为判断") then
	      world.Send("unset wimpy")
	      print("打不过 放弃!!")
	     self.break_in_failure(CallBack)
	     return
	  end

   end)
end

function alias:PreCompare(success,failure)
   print("PreCompare!!!!")
   local npc,is_end=break_npc()
   wait.make(function()
     world.Send("compare "..npc)
	 --world.AppendToNotepad (WorldName().."_挡路NPC:",os.date()..": NPC:"..npc.."\r\n")
	 local l,w=wait.regexp("^(> |)"..npc.." 不在这里$|^(> |)你感觉.*不过是个大肉脚, 根本不屑一顾。$|^(> |)哇哈哈哈～, .*看起来根本不是你的对手!$|^(> |)你要杀死.*就如要踩死蚂蚁般容易。$|^(> |)虽然从各方面看来你都比.*略胜一筹, 但是也不能轻敌。$|你以本身修为判断.*的级数。",5)
	  if l==nil then
	     self:PreCompare(success,failure)
	     return
	  end
	  if string.find(l,"不在这里") or string.find(l,"根本不屑一顾") or string.find(l,"不是你的对手") or string.find(l,"踩死蚂蚁般容易") or string.find(l,"但是也不能轻敌") then
	      success()
	      return
	  end
	  if string.find(l,"你以本身修为判断") then
	      world.Send("unset wimpy")
	      print("打不过 放弃!!")
	     failure()
	     return
	  end

   end)
end

function alias:break_in(id,CallBack)
   print("break in")
   world.Send("yun recover")
   world.Send("yun refresh")
   self:compare(CallBack)
end


function alias:yamen_cucangshi()
-- 247
   world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2285 then
	   self:finish()
	 elseif roomno[1]==247 then
        --npc block
		local f
		f=function()
		  self:yamen_cucangshi()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamen_cucangshi()
		end
		w:go(247)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
   --2285
end

function alias:yamen_zhengting()
--247
   world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2286 then
	   self:finish()
	 elseif roomno[1]==247 then
        print("npc block")
		local f
		f=function()
		  self:yamen_zhengting()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamen_zhengting()
		end
		w:go(247)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
   --2286
end

function alias:changan_bingyingdamen_bingying()
   --1082  -  2275
    world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==936 then
	   self:finish()
	 elseif roomno[1]==935 then
        --npc block
		local f
		f=function()
		  self:changan_bingyingdamen_bingying()
		end
		break_npc=break_npc_id("guan bing")
        self:break_in("guan bing",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changan_bingyingdamen_bingying()
		end
		w:go(935)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:bingyingdamen_bingying()
   --1082  -  2275
    world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2275 then
	   self:finish()
	 elseif roomno[1]==1082 then
        --npc block
		local f
		f=function()
		  self:bingyingdamen_bingying()
		end
		break_npc=break_npc_id("guan bing")
        self:break_in("guan bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:bingyingdamen_bingying()
		end
		w:go(1082)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:outwuguan()
     world.Send("ask sun about 离馆")
	 local b=busy.new()
	 b.Next=function()
	   world.Send("out")
	   self:finish()
	 end
	 b:check()
end

function alias:jumpwell()
   world.Send("jump well")
   self:finish()
end

function alias:pullhuan()
   world.Send("pull huan")
   world.Send("down")
   self:finish()
end

function alias:xieketing_rimulundian()
--1691 enter 2271
   --print("奇怪bug")
   world.Send("open door")
   world.Send("enter")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2271 then
	   self:finish()
	 elseif roomno[1]==1691 then
        --npc block
		local f
		f=function()
		  self:xieketing_rimulundian()
		end
		break_npc=break_npc_id("hufa lama")
        self:break_in("hufa lama",f)
	 else
	   local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xieketing_rimulundian()
		end
		w:go(1691)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:rimulundian_yueliangmen()
--1691 enter 2271
   world.Send("west")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2711 then
	   self:finish()
	 elseif roomno[1]==2271 then
        --npc block
		local f
		f=function()
		  self:rimulundian_yueliangmen()
		end
		break_npc=break_npc_id("hufa lama")
        self:break_in("hufa lama",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:rimulundian_yueliangmen()
		end
		w:go(2271)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:rimulundian_zhaitang()
--1691 enter 2271
   world.Send("southeast")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2885 then
	   self:finish()
	 elseif roomno[1]==2271 then
        --npc block
		local f
		f=function()
		  self:rimulundian_zhaitang()
		end
		break_npc=break_npc_id("hufa lama")
        self:break_in("hufa lama",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:rimulundian_zhaitang()
		end
		w:go(2271)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:nanmen_chengzhongxin()
--1972 _ 2349

   world.Send("north")
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2349 then
	     self:finish()
	   elseif roomno[1]==1972 then
		  local f=function()
		    self:nanmen_chengzhongxin()
		  end
		  f_wait(f,10)
	   else
	     local f=function()
            local w
		    w=walk.new()
		    w.user_alias=self
		    w.walkover=function()
		     self:nanmen_chengzhongxin()
		    end
		    w:go(1972)
	      end
		  self:redo(f)
        end --if
	  end   --function
	 _R:CatchStart()
end

function alias:chengzhongxin_nanmen()
--2349 _ 1972
   world.Send("south")
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1972 then
	     self:finish()
	   elseif roomno[1]==2349 then
		  local f=function()
		    self:chengzhongxin_nanmen()
		  end
		  f_wait(f,10)
	   else
	     local f=function()
            local w
		    w=walk.new()
	  	    w.user_alias=self
		    w.walkover=function()
		      self:finish()
		    end
	  	    w:go(1972)
	      end
		  self:redo(f)
       end
	  end
       _R:CatchStart()
end
--崇圣寺——白石路 1604
function alias:baishilu_tianwangdian() --1611_2276 northup
    world.Send("northup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1699 then
	   self:finish()
	 elseif roomno[1]==1604 then
        --npc block
		local f
		f=function()
		  self:baishilu_tianwangdian()
		end
		-- 天龙寺第十四代弟子「漏尽尊者」了惑禅师(Liaohuo chanshi)
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
		local f=function()
         local w
		 w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:baishilu_tianwangdian()
		 end
		 w:go(1604)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--白石路--斑竹院  1604--1605
function alias:baishilu_banzuyuan()
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1605 then
	   self:finish()
	 elseif roomno[1]==1604 then
        --npc block
		local f
		f=function()
		  self:baishilu_banzuyuan()
		end
		-- 天龙寺第十四代弟子「漏尽尊者」了惑禅师(Liaohuo chanshi)
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:baishilu_banzuyuan()
		end
		w:go(1604)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--白石路--斑竹院  1604--1692
function alias:baishilu_songshuyuan()
  world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1692 then
	   self:finish()
	 elseif roomno[1]==1604 then
        --npc block
		local f
		f=function()
		  self:baishilu_songshuyuan()
		end
		-- 天龙寺第十四代弟子「漏尽尊者」了惑禅师(Liaohuo chanshi)
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:baishilu_songshuyuan()
		end
		w:go(1604)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--1611 清都瑶台 -
-- 天龙寺第十四代弟子「无为尊者」了清禅师(Liaoqing chanshi)
function alias:qingduyaotai_baishilu() --1611_2276 northup
   --print("qingduyaotai_baishilu() --1611_2276 northup")
    world.Send("northup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2276 then
	   self:finish()
	 elseif roomno[1]==1611 then
        --npc block
		local f
		f=function()
		  self:qingduyaotai_baishilu()
		end
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:qingduyaotai_baishilu()
		end
		w:go(1611)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--1611_2283
function alias:qingduyaotai_banruotai() --1611_2276 northup
    world.Send("eastup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2283 then
	   self:finish()
	 elseif roomno[1]==1611 then
        --npc block
		local f
		f=function()
		  self:qingduyaotai_banruotai()
		end
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:qingduyaotai_banruotai()
		end
		w:go(1611)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:circle_done(alias_name) --回调函数
  -- print("启动4",alias_name," ",self.alias_table[alias_name].is_search)
    self.maze_step=function()
      local f=function()
        coroutine.resume(alias.circle_co,true)
      end
      f_wait(f,0.1)
   end
   if self.alias_table[alias_name].is_search==true then
      self:maze_done()
   else
      self.maze_step()
   end
end
--[[
function alias:xingxiuhai_circle()
   --星宿海循环遍历
--   roomno	linkroomno	direction
--1965	2369	east
--1965	2370	north
--1965	2371	west
--1965	2372	south
--1965	2373	east
--1965	2374	north
--1965	2375	west
--1965	2376	south
--1965	2377	east
--1965	2378	west
--1965	2379	north
--1965	2380	north
--1965	2381	north
--1965	2382	south
--1965	2383	south
--e;n;w;s;e;n;w;s;e;w;n;n;n;s;s
   --print("启动")
   local p={"n","w","n","e","n","s","n","n","w","e","s"}
   alias.circle_co=coroutine.create(function()
      --print("启动3")
      for _,i in ipairs(p) do

	     world.Send(i)
		 print("停下来遍历")
         self:circle_done()
	     coroutine.yield()
	  end
	  self:finish()
   end)
  --print("启动2")
   coroutine.resume(alias.circle_co)
end]]
local dx="n"
function alias:xingxiuhai_search()
    self.maze_step=function()
       world.Send(dx)
       if dx=="n" then
	    dx="e"
	   else
	    dx="n"
	   end
	   self:finish()
   end
   if self.alias_table["xingxiuhai_search"].is_search==true then
     self:maze_done()
   else
      self.maze_step()
   end
end

function alias:xingxiuhai_south(c)
--1965_1964
--[[local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1964 then
	   self:finish()
	 elseif roomno[1]==1965 then
	   if d==nil then
	     local dx={"south"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
		 local f2=function()
		     self:xingxiuhai_south(d)
		 end
         self.maze_done(f2)
	   end
	   f_wait(f,0.2)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xingxiuhai_south()
		end
		w:go(1965)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]
   if c==nil then c=1 end
   if c>10 then
      self:finish()
	  return
   end
     world.Send("south")
	 world.Send("set action 星宿海")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)你累得半死，终於走出了星宿海。$|^(> |)设定环境变量：action \\= \\\"星宿海\\\"",5)
	    if l==nil then
		  self:xingxiuhai_south(c)
		  return
		end
		if string.find(l,"你累得半死，终於走出了星宿海") then
		   self:finish()
		   return
		end
		if string.find(l,"星宿海") then
		  self.maze_step=function()
		    c=c+1
		    self:xingxiuhai_south(c)
		  end
		  --print("xingxiuhai_south:", self.alias_table["xingxiuhai_south"].is_search)
		  if self.alias_table["xingxiuhai_south"].is_search==true then
		      self:maze_done()
		  else
		      self.maze_step()
		  end
		  return
		end

	 end)

end

function alias:xingxiuhai_north(c)
--1965_1967
--[[local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1967 then
	   self:finish()
	 elseif roomno[1]==1965 then
	   if d==nil then
	     local dx={"north"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
		  local f2=function()
		     self:xingxiuhai_north(d)
		 end
         self.maze_done(f2)
	   end
	   f_wait(f,0.2)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xingxiuhai_north()
		end
		w:go(1965)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]

     if c==nil then c=1 end
   if c>10 then
      self:finish()
	  return
   end
     world.Send("north")
	 world.Send("set action 星宿海")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)你累得半死，终於走出了星宿海。$|^(> |)设定环境变量：action \\= \\\"星宿海\\\"",5)
	    if l==nil then
		  self:xingxiuhai_north(c)
		  return
		end
		if string.find(l,"你累得半死，终於走出了星宿海") then
		   self:finish()
		   return
		end
		if string.find(l,"星宿海") then
		  self.maze_step=function()
		    c=c+1
		    self:xingxiuhai_north(c)
		  end
		  --print("xingxiuhai_north:",self.alias_table["xingxiuhai_north"].is_search)
		  if self.alias_table["xingxiuhai_north"].is_search==true then
		    self:maze_done()
		  else
		    self.maze_step()
		  end
		  return
		end

	 end)

end

function alias:xingxiuhai_east(c)
--1965_2235
--[[local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2235 then
	   self:finish()
	 elseif roomno[1]==1965 then
	   if d==nil then
	     local dx={"east"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
         local f2=function()
		     self:xingxiuhai_east(d)
		 end
         self.maze_done(f2)
	   end
	   f_wait(f,0.2)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xingxiuhai_east()
		end
		w:go(1965)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]
     if c==nil then c=1 end
   if c>10 then
      self:finish()
	  return
   end
     world.Send("east")
	 world.Send("set action 星宿海")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)你累得半死，终於走出了星宿海。$|^(> |)设定环境变量：action \\= \\\"星宿海\\\"",5)
	    if l==nil then
		  self:xingxiuhai_east(c)
		  return
		end
		if string.find(l,"你累得半死，终於走出了星宿海") then
		   self:finish()
		   return
		end
		if string.find(l,"星宿海") then
		  --print("触发1")
		  self.maze_step=function()

		      --print("回调hansh east")
		      c=c+1
		       self:xingxiuhai_east(c)
		  end
		  if self.alias_table["xingxiuhai_east"].is_search==true then
		    --print(self.alias_table["xingxiuhai_east"].is_search," true")
		    self:maze_done()
		  else
		    --print("直接执行")
		    self.maze_step()
		  end
		  return
		end

	 end)

end

function alias:xingxiuhai_west(c)
--1965,2233
--[[local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2233 then
	   self:finish()
	 elseif roomno[1]==1965 then
	   if d==nil then
	     local dx={"west"}
	     d=dx_serial(dx)
	   end
	   local f=function()
	     world.Send(d())
          local f2=function()
		     self:xingxiuhai_west(d)
		 end
         self.maze_done(f2)
	   end
	   f_wait(f,0.2)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xingxiuhai_west()
		end
		w:go(1965)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()]]
     if c==nil then c=1 end
   if c>10 then
      self:finish()
	  return
   end
     world.Send("west")
	 world.Send("set action 星宿海")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)你累得半死，终於走出了星宿海。$|^(> |)设定环境变量：action \\= \\\"星宿海\\\"",5)
	    if l==nil then
		  self:xingxiuhai_west(c)
		  return
		end
		if string.find(l,"你累得半死，终於走出了星宿海") then
		   self:finish()
		   return
		end
		if string.find(l,"星宿海") then
		  self.maze_step=function()
		    c=c+1
		    self:xingxiuhai_west(c)
		  end
		  if self.alias_table["xingxiuhai_west"].is_search==true then
		    self:maze_done()
		  else
		    self.maze_step()
		  end
		  return
		end

	 end)

end

function alias:shanmen_shanlu()
--240_243
  world.Send("northup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==243 then
	   self:finish()
	 elseif roomno[1]==240 then
        --npc block
		local f
		f=function()
		  self:shanmen_shanlu()
		end
		break_npc=break_npc_id("bangzhong")
        self:break_in("bangzhong",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanmen_shanlu()
		end
		w:go(240)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:jiayuguanximen_yanmenguan()
--1861
 local f2=function()
   world.Send("say 好狗不挡路")
 world.Send("get gold from corpse")
 world.Send("get silver from corpse")
 world.Send("eastup")
 --保留旧的self.break_in_failure
 --local old_function=self.break_in_failure
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1860 then
	   --self.break_in_failure=old_function
	   self:finish()
	 elseif roomno[1]==1861 then
        --npc block
		local f
		f=function()
		  self:jiayuguanximen_yanmenguan()
		end
		break_npc=break_npc_id("guan bing")
		--[[self.break_in_failure=function(f)
		  local f=function()
		    self:jiayuguanximen_yanmenguan()
		   end
		   print("2s 官兵重新检查")
		   f_wait(f,2)
		end]]
        self:break_in("guan bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jiayuguanximen_yanmenguan()
		end
		w:go(1861)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
  end
  break_npc=break_npc_id("guan bing")
  --self.break_in_failure=function()
  --	  f2()
  --end
  self:break_in("guan bing",f2)
end

function alias:jiayuguanximen_sichouzhilu()
  local f2=function()
    world.Send("say 好狗不挡路")
  world.Send("get gold from corpse")
  world.Send("get silver from corpse")
  world.Send("west")
  --保留旧的self.break_in_failure
  --local old_function=self.break_in_failure
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1862 then
	   --self.break_in_failure=old_function
	   self:finish()
	 elseif roomno[1]==1861 then
        --npc block
		local f
		f=function()
		  self:jiayuguanximen_sichouzhilu()
		end
		break_npc=break_npc_id("guan bing")

		--新的值
		--[[self.break_in_failure=function()
		   print("2s 官兵重新检查")
		   local f=function()
		     self:jiayuguanximen_sichouzhilu()
		   end
		   f_wait(f,2)
		end]]
        self:break_in("guan bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jiayuguanximen_sichouzhilu()
		end
		w:go(1861)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
   end
    break_npc=break_npc_id("guan bing")
	--self.break_in_failure=function()
	--	f2()
	--end
    self:break_in("guan bing",f2)
end

function alias:wangfudating_changlang()
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==480 then
	   self:finish()
	 elseif roomno[1]==445 then
        --npc block
		local f
		f=function()
		  self:wangfudating_changlang()
		end
		break_npc=break_npc_id("bing")
        self:break_in("bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wangfudating_changlang()
		end
		w:go(445)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wangfudating_changlang2()
  world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==468 then
	   self:finish()
	 elseif roomno[1]==445 then
        --npc block
		local f
		f=function()
		  self:wangfudating_changlang2()
		end
		break_npc=break_npc_id("bing")
        self:break_in("bing",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wangfudating_changlang2()
		end
		w:go(445)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:lianwuchang_guangchang()
--殷无寿 2171_2240
  world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2240 then
	   self:finish()
	 elseif roomno[1]==2171 then
        --npc block
		local f
		f=function()
		  self:lianwuchang_guangchang()
		end
		break_npc=break_npc_id("yin wushou")
        self:break_in("yin wushou",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:lianwuchang_guangchang()
		end
		w:go(2171)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:lianwuchang_zoulang1()
--殷无寿 2171_2240
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2172 then
	   self:finish()
	 elseif roomno[1]==2171 then
        --npc block
		local f
		f=function()
		  self:lianwuchang_zoulang1()
		end
		break_npc=break_npc_id("yin wushou")
        self:break_in("yin wushou",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:lianwuchang_zoulang1()
		end
		w:go(2171)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:lianwuchang_zoulang2()
--殷无寿 2171_2240
  world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2180 then
	   self:finish()
	 elseif roomno[1]==2171 then
        --npc block
		local f
		f=function()
		  self:lianwuchang_zoulang2()
		end
		break_npc=break_npc_id("yin wushou")
        self:break_in("yin wushou",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:lianwuchang_zoulang2()
		end
		w:go(2171)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:yamenzhenting_fuyahouyuan()
 world.Send("northwest")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2750 then
	   self:finish()
	 elseif roomno[1]==1005 then
        --npc block
		local f
		f=function()
		  self:yamenzhenting_fuyahouyuan()
		end
		break_npc=break_npc_id("da yayi")
        self:break_in("da yayi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamenzhenting_fuyahouyuan()
		end
		w:go(1005)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--衙门大门 衙门正厅
function alias:yamendamen_yamenzhengting()
  world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1546 then
	   self:finish()
	 elseif roomno[1]==1545 then
        --npc block
		local f
		f=function()
		  self:yamendamen_yamenzhengting()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamendamen_yamenzhengting()
		end
		w:go(1545)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:yamendamen_menlang()
  world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1008 then
	   self:finish()
	 elseif roomno[1]==61 then
        --npc block
		local f
		f=function()
		  self:yamendamen_menlang()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yamendamen_menlang()
		end
		w:go(61)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:qianting_shilu()
--房间号: 2219_2220
   world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2220 then
	   self:finish()
	 elseif roomno[1]==2219 then
        --npc block
		local f
		f=function()
		  self:qianting_shilu()
		end
		break_npc=break_npc_id("xi huazi")
        self:break_in("xi huazi",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:qianting_shilu()
		end
		w:go(2219)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wuzhitang_houxiangfang()
 --[[2390
                     后厢房
                             ｜
                   走廊--  五指堂--走廊
                             ↑
                            广场
五指堂 -
  麻衣长老「铁掌四鹰」洪哮天(Hong xiaotian)

roomno	linkroomno	direction
2390	2389	north
2390	2416	east
2390	2421	west
  ]]
    world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2389 then
	   self:finish()
	 elseif roomno[1]==2390 then
        --npc block
		local f
		f=function()
		  self:wuzhitang_houxiangfang()
		end
		break_npc=break_npc_id("hong xiaotian")
        self:break_in("hong xiaotian",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wuzhitang_houxiangfang()
		end
		w:go(2390)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wuzhitang_east_zoulang()
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2416 then
	   self:finish()
	 elseif roomno[1]==2390 then
        --npc block
		local f
		f=function()
		  self:wuzhitang_east_zoulang()
		end
		break_npc=break_npc_id("hong xiaotian")
        self:break_in("hong xiaotian",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wuzhitang_east_zoulang()
		end
		w:go(2390)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wuzhitang_west_zoulang()
  world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2421 then
	   self:finish()
	 elseif roomno[1]==2390 then
        --npc block
		local f
		f=function()
		  self:wuzhitang_west_zoulang()
		end
		break_npc=break_npc_id("hong xiaotian")
        self:break_in("hong xiaotian",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wuzhitang_west_zoulang()
		end
		w:go(2390)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:wuliangjianzong_shibanlu()
  world.Send("enter")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1928 then
	   self:finish()
	 elseif roomno[1]==604 then
        --npc block
		local f
		f=function()
		  self:wuliangjianzong_shibanlu()
		end
		break_npc=break_npc_id("wu guangsheng|yu guangbiao")
        self:break_in("wu guangsheng|yu guangbiao",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:wuliangjianzong_shibanlu()
		end
		w:go(604)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--604
--  无量剑东宗弟子 吴光胜(Wu guangsheng)
--  无量剑东宗弟子 郁光标(Yu guangbiao)
function alias:shibanlu_jianhugong()
--1928_2411
 world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2411 then
	   self:finish()
	 elseif roomno[1]==1928 then
        --npc block
		local f
		f=function()
		  self:shibanlu_jianhugong()
		end--容子矩
		break_npc=break_npc_id("rong ziju")
        self:break_in("rong ziju",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shibanlu_jianhugong()
		end
		w:go(1928)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:dacaoyuan_yingmen()
    local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2435  then
	   self:finish()
	 elseif roomno[1]==2434 then
	     if _R.relation=="草海｜草海─草海─草海｜草原" then
           local p={"west","east","north","north","west","east"}
      alias.circle_co=coroutine.create(function()
      for _,i in ipairs(p) do
	     world.Send(i)
         self:circle_done("dacaoyuan_yingmen")
	     coroutine.yield()
	  end
	  self:finish()
   end)
   coroutine.resume(alias.circle_co)
		   return
		end
	 elseif roomno[1]==2630 then
	   if _R.relation=="草海｜沼泽─沼泽─草海｜沼泽" then
		   world.Send("east")
           self:dacaoyuan_yingmen()
		   return
		end
	elseif roomno[1]==2617 then
		if _R.relation=="草海｜沼泽─沼泽─沼泽｜沼泽" then
		   world.Send("north")
           self:dacaoyuan_yingmen()
		   return
		end
	elseif roomno[1]==2641 then
		if _R.relation=="沼泽｜沼泽─沼泽─草海｜草海" then
		   world.Send("east")
           self:dacaoyuan_yingmen()
		   return
		end
	 elseif roomno[1]==2439 then
        local dx={} --,"north"
		if _R.relation=="草海｜沼泽─草海─草海｜草海" then--caihai2 or caihao3
		   dx={"east","north","north","west","east"}
		end
		if _R.relation=="草海｜沼泽─草海─草海｜沼泽" then  --caihao4
		   dx={"north","west","east"}
		end
		if _R.relation=="草海｜草海─草海─草海｜沼泽" then  --caihao5
		  dx={"west","east"}
		end
		if _R.relation=="草海｜沼泽─草海─营门｜草海" then --caihao6
		  dx={"east"}
		end

		alias.circle_co=coroutine.create(function()
          --print("启动3")
          for j,i in ipairs(dx) do
			--print(j.."/13 方向:",i)
	       world.Send(i)
           self:circle_done("dacaoyuan_yingmen")
	       coroutine.yield()
	      end
	      self:dacaoyuan_yingmen()
        end)
		coroutine.resume(alias.circle_co)

	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dacaoyuan_yingmen()
		end
		w:go(2439)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end


function alias:ruhuanggong()
    local w
	w=walk.new()
	w.walkover=function()
		world.Send("ask gao about 入皇宫")
		wait.make(function()
		  local l,w=wait.regexp("^(> |)高升泰说道：「.*，你不是本王府随从，此话从何说起？」|^(> |)高升泰说道：「.*只要说是镇南王府的，就可以入宫了。」$|^(> |)高升泰说道：「我看你为镇南王府做事做的还不够啊，努力做吧！」$",5)
		  if l==nil then
		    self:ruhuanggong()
			return
		  end
		  if  string.find(l,"我看你为镇南王府做事做的还不够啊") then
		     self:finish()
	         return
	      end
		  if string.find(l,"你不是本王府随从") then

		   local w1
           w1=walk.new()
           w1.walkover=function ()
	           wait.make(function()
	           world.Send("ask fu about join")
		        local l,w=wait.regexp("^(> |)傅思归说道：「好，不错，这位.*可以为本王府工作了。」$|^(> |)傅思归说道：「.*已经是本王府随从了，何故还要开这种玩笑？」$",5)
		       if l==nil then
                print("网络太慢或是发生了一个非预期的错误")
		        self:ruhuanggong()
		        return
			   end
		       if string.find(l,"可以为本王府工作了。") or string.find(l,"已经是本王府随从了") then
		          local b
		      	   b=busy.new()
			       b.interval=0.3
				   b.Next=function()
			         self:ruhuanggong()
			       end
			       b:check()
		          return
			   end
		     wait.time(5)
	       end)
         end
		   local b=busy.new()
		   b.Next=function()
              w1:go(445)
		   end
           b:check()
		    return
		  end
		  if string.find(l,"是镇南王府的") then
			local b
		     b=busy.new()
		    b.interval=0.3
		    b.Next=function()
		    local w1=walk.new()
		     w1.walkover=function()
		       self:huanggongzhengting_zoulang()
		    end
		    w1:go(507)
		    end
		    b:check()
		    return
		  end
		  wait.time(5)
		end)
	end
	w:go(466)
end

function alias:halt_northwest()
  local b=busy.new()
  b.interval=0.4
  b.Next=function()
     world.Send("northwest")
	 self:finish()
  end
  b:check()
end

function alias:huanggongzhengting_zoulang()
   world.Send("north")
   _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1083  then
	   self:finish()
	 elseif roomno[1]==507 then
	   self:ruhuanggong()
	 else
		local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:huanggongzhengting_zoulang()
		end
		w:go(507)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

local jiugong={}
function alias:kick_out(current_roomno,is_ok)
   print("兵临列斗皆列阵在前")
   for j,e in ipairs(jiugong) do
      print("房间号:",e)
   end
   print("----------------")
   local room_index
   for i,c in ipairs(jiugong) do
       room_index=i
       if c==current_roomno then
	     if is_ok==true then
	      table.remove(jiugong,i)
		 else
		  room_index=i+1
		 end
		 break
	   end
	end
	--print("why",table.getn(jiugong)," ",room_index)
	--下一个
	if table.getn(jiugong)>=room_index then
		     print("下一个")
			 return jiugong[room_index]
	    elseif table.getn(jiugong)==0 then
			 jiugong={}
			 jiugong={2490,2491,2492,2493,2494,2495,2496,2497,2498}
			 print("按桃花数目进行猜测:",self.carry_taohua)
			 if self.carry_taohua==4 then
			    return(2492)
			 elseif self.carry_taohua==9 then
			    return(2493)
			 elseif self.carry_taohua==2 then
			    return(2494)
			 elseif self.carry_taohua==3 then
			    return(2491)
             elseif	self.carry_taohua==5 then
			    return(2498)
			 elseif	self.carry_taohua==7 then
			     return(2495)
			 elseif	self.carry_taohua==8 then
			    return(2490)
		elseif	self.carry_taohua==1 then
			    return(2497)
		elseif	self.carry_taohua==6 then
			    return(2496)
		elseif self.carry_taohua==0 then
			    print("走到底！！！！")
			    return 2490
		end
	else
		print("error")
		return jiugong[1]
	end
end

function alias:out_taohuazhen(current_roomno,targetRoomNo)
      local mp=map.new()
		mp.Search_end=function(path,room_type)
		  world.Execute(path)
		  print("查看环境!")
		  local f1=function()
		     self:taohuazhen()
		  end
		  f_wait(f1,1)
		end
		print("查询出路:",current_roomno,"->",targetRoomNo)
	    mp:Search(current_roomno,targetRoomNo,nil)
end

function alias:is_out_taohuazhen(current_roomno,targetRoomNo)
    wait.make(function()
	   local l,w=wait.regexp("桃花阵中忽然发出一阵“轧轧”的声音，随后现出一条道路，你赶忙走了出去。|^(> |)设定环境变量：taohua \\= \\\"YES\\\"$",3)
	   if l==nil then
	      world.Send("set taohua")
		  world.Send("unset taohua")
		  self:is_out_taohuazhen(current_roomno,targetRoomNo)
		  return
	   end
	   if string.find(l,"设定环境变量：taohua") then
	      self:out_taohuazhen(current_roomno,targetRoomNo)
		  return
	   end
	   if string.find(l,"你赶忙走了出去") then
		  print("走出桃花林！！！！！"," 回调")
	      self:finish()
	      return
	   end

	   wait.time(3)
	end)
end
function alias:taohuazhen()
--   4 9 2　　　　　　　　　5 5 5
--   3 5 7　　　　或　　　　5 5 5　
--   8 1 6　　　　　　　　　5 5 5
--桃花阵中忽然发出一阵“轧轧”的声音，随后现出一条道路，你赶忙走了出去。
--你丢下一株桃花。
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     print("房间名:",_R.roomname)
     local num=0
	 if _R.roomname=="九宫桃花阵"  then
		local taohua
		local current_roomno
		local targetRoomNo
	    if _R.exits=="east;south;" then
		--4
		   current_roomno=2492
		   taohua=4
		elseif _R.exits=="east;south;west;" then
		--9
		   current_roomno=2493
           taohua=9
		elseif _R.exits=="south;west;" then
		--2
		   current_roomno=2494
           taohua=2
		elseif _R.exits=="east;north;south;" then
		--3
		   current_roomno=2491
           taohua=3
		elseif _R.exits=="north;west;" then
		--6
		   current_roomno=2496
           taohua=6
		elseif _R.exits=="east;north;" then
		--8
		   current_roomno=2490
           taohua=8
		elseif _R.exits=="east;north;west;" then
		--1
		   current_roomno=2497
           taohua=1
	    elseif _R.exits=="east;north;south;west;" then
		--5
		   current_roomno=2498
           taohua=5
		elseif _R.exits=="north;south;west;" then
		--7
		   current_roomno=2495
           taohua=7
		end
		 if string.find(_R.description,"也没有") then
		    num=0
		 else
		    local _,_,chinese_num=string.find(_R.description,"这是一片茂密的桃花丛，你一走进来就迷失了方向。地上有(.*)株桃花.*")
			 print(chinese_num)
			num= ChineseNum(chinese_num)
		 end
		 print("当前房间号:",current_roomno," 核定桃花数目:",taohua," 目前桃花数目:",num)
		 local target_roomno
		 if self.carry_taohua==nil then
		    self.carry_taohua=0
		 end
		 if  table.getn(jiugong)==0 then
		    jiugong={2490,2491,2492,2493,2494,2495,2496,2497,2498}
		 end
		  print("携带桃花数前:",self.carry_taohua)
		if num>taohua then
		 print("多余")
		 world.Send("get "..num-taohua.." taohua")
		 self.carry_taohua=self.carry_taohua+num-taohua
		 targetRoomNo=self:kick_out(current_roomno,true)
		 print("携带桃花数后:",self.carry_taohua)
		 self:out_taohuazhen(current_roomno,targetRoomNo)
			--移除 targetRooms
	    elseif num<taohua then
		 print("少于")
		 if self.carry_taohua>=taohua-num then
		    print("携带足够",self.carry_taohua," ",taohua-num)
		     self.carry_taohua=self.carry_taohua-taohua+num
			 targetRoomNo=self:kick_out(current_roomno,true)
			 world.Send("drop "..taohua-num.." taohua")
			 if self.carry_taohua==0 then
			    print("检测是否出阵")
				--桃花阵中忽然发出一阵“轧轧”的声音，随后现出一条道路，你赶忙走了出去。
				self:is_out_taohuazhen(current_roomno,targetRoomNo)
			 else
                 self:out_taohuazhen(current_roomno,targetRoomNo)
			 end
		 else
			print("不足")
	         world.Send("get "..num.." taohua")
		     self.carry_taohua=self.carry_taohua+num
			 targetRoomNo=self:kick_out(current_roomno,false)
			 print("携带桃花数后:",self.carry_taohua)
		     self:out_taohuazhen(current_roomno,targetRoomNo)
		 end
	    else
	      print("等于")
		  targetRoomNo=self:kick_out(current_roomno,true)
		  print("携带桃花数后:",self.carry_taohua)
		  self:out_taohuazhen(current_roomno,targetRoomNo)
		end
	 else
	   local count,roomno=Locate(_R)
	   print("当前房间号",roomno[1])
	   if roomno[1]==self.out_exit  then
	      self:finish()
	   else
	      local f=function()
		  local w2
		  w2=walk.new()
		  w2.user_alias=self
		  w2.walkover=function()
		   self:finish()
		  end
		   print(self.out_exit," 方向")
		  w2:go(self.out_exit)
		  end
		  self:redo(f)
		end
	 end
   end
  _R:CatchStart()
end

function alias:east_taohuazhen()
   world.Send("east")
   jiugong={2490,2491,2492,2493,2494,2495,2496,2497,2498}
   self.carry_taohua=0
   self.out_exit=1848
   self:taohuazhen()
end

function alias:west_taohuazhen()
   world.Send("west")
   jiugong={2490,2491,2492,2493,2494,2495,2496,2497,2498}
   self.carry_taohua=0
   self.out_exit=2476
   self:taohuazhen()
end

function alias:reset_taohuazhen()
   self.carry_taohua=0
   wait.make(function()
	 world.Send("drop 1 taohua")
     local l,w=wait.regexp("^(> |)你身上没有这样东西。$|^(> |)你丢下一株桃花。$|^(> |)桃花阵中忽然发出一阵“轧轧”的声音，随后现出一条道路，你赶忙走了出去。$",5)
	 if l==nil then
	    self:reset_taohuazhen()
	    return
	 end
	 if string.find(l,"你丢下一株桃花") then
	    self:reset_taohuazhen()
	    return
	 end
	 if string.find(l,"你身上没有这样东西") then
	    self:taohuazhen()
		return
	 end
	 if string.find(l,"你赶忙走了出去") then
	    self:finish()
	    return
	 end
	 wait.time(5)
   end)
end
---九宫桃花阵
function alias:waitday_south()
      world.Send("south")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1068 then
	     self:finish()
	   elseif roomno[1]==1065 then
		  local f=function()
		    self:waitday_south()
		  end
		  f_wait(f,10)
	   else
	        local f=function()
            local w
	  	     w=walk.new()
		     w.user_alias=self
		     w.walkover=function()
		       self:waitday_south()
		     end
		     w:go(1065)
		    end
		    self:redo(f)
	    end
       end
       _R:CatchStart()
end



function alias:changjie_changjie()
     world.Send("east")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2509 then
	     self:finish()
	   elseif roomno[1]==217 then
	      self.maze_step=function()
		     self:changjie_changjie()
		  end
	      if self.alias_table["changjie_changjie"].is_search==true then
			  self:maze_done()
		 else
			 self.maze_step()
		  end

	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changjie_changjie()
		end
		w:go(217)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:changjie_nandajie()
      world.Send("west")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==216 then
	     self:finish()
	   elseif roomno[1]==217 then
		  local f=function()
		    self:changjie_nandajie()
		  end
		  f_wait(f,0.5)
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changjie_nandajie()
		end
		w:go(217)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:out_zishanlin()
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
	   --local count,roomno=Locate(_R,10000)
	   --print(roomno[1])
	   if string.find(_R.relation,"门") then
	       world.Send("west")
	       world.Send("southeast")
		   --world.Send("east")
		   self:out_zishanlin()
		elseif string.find(_R.relation,"厚土旗") or string.find(_R.relation,"烈火旗") then

			local dx={"west","east","west"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("启动3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_zishanlin2_quick")
	          coroutine.yield()
		   end
	        self:out_zishanlin()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"锐金旗") or string.find(_R.relation,"洪水旗") then

		   	local dx={"east","west","east"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("启动3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_zishanlin2_quick")
	          coroutine.yield()
		   end
	        self:out_zishanlin()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"紫杉林")  then
		   world.Send("west")
		   self:finish()
		else
		     local f=function()
		     local w
		     w=walk.new()
			 w.user_alias=self
		     w.walkover=function()
		       self:out_zishanlin()
		     end
		     w:go(2175)
			 end
			 self:redo(f)
	   end
	end
	_R:CatchStart("west")
end

function alias:zishanlin_check()
   local f=function()
     coroutine.resume(alias.zishanlin_co)
   end
   f_wait(f,0.1)
end

function alias:zishanlin_search()--2519 房间号

	local dx={"south","south","south","south","south","south","south","south","south"} --,"south"
	alias.zishanlin_co=coroutine.create(function()
		local d
		for j,d in ipairs(dx) do
			 print(j.."/9 方向:",d)
		     world.Send(d)
			 self:zishanlin_check()
			 coroutine.yield()
		end
		print("走到底结束")
		alias.zishanlin_co=nil
		self:out_zishanlin()

	end)
	coroutine.resume(alias.zishanlin_co)
end


--[[function alias:zishanlin2_check()
    --print("计数器:",n)
    local f2=function()
	  local f=function()
	  	self:zishanlin_tiandifenglei()
	  end
	  f_wait(f,0.5)
	end
	self.maze_done(f2)
end]]
function alias:zishanlin_zishanlin2_quick()
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
	   --local count,roomno=Locate(_R,10000)
	   --print(roomno[1])
	   if string.find(_R.relation,"门") then
	       world.Send("west")
	       world.Send("southeast")
		   --world.Send("east")
		   self:zishanlin_zishanlin2_quick()
		elseif string.find(_R.relation,"厚土旗") or string.find(_R.relation,"烈火旗") then

			local dx={"west","east","west"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("启动3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_zishanlin2_quick")
	          coroutine.yield()
		   end
	        self:zishanlin_zishanlin2_quick()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"锐金旗") or string.find(_R.relation,"洪水旗") then

		   	local dx={"east","west","east"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("启动3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_zishanlin2_quick")
	          coroutine.yield()
		   end
	        self:zishanlin_zishanlin2_quick()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"紫杉林")  then
		   world.Send("west")
		   self:finish()
		else
		     local f=function()
		     local w
		     w=walk.new()
			 w.user_alias=self
		     w.walkover=function()
		       self:zishanlin_zishanlin2_quick()
		     end
		     w:go(2175)
			 end
			 self:redo(f)
	   end
	end
	_R:CatchStart("west")
end

function alias:zishanlin_tiandifenglei_quick()
--2175 厚土旗 w
--2455 锐金旗 e
--2173 洪水旗 e
--2178 烈火旗 w
--3041
   -- world.Send("west")
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
	   --local count,roomno=Locate(_R,10000)
	   --print(roomno[1])
	   if string.find(_R.relation,"门") then
	       world.Send("west")
		   self:finish()
		elseif string.find(_R.relation,"厚土旗") or string.find(_R.relation,"烈火旗") then
		 	local dx={"west","east","west"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("启动3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_tiandifenglei_quick")
	          coroutine.yield()
		   end
	        self:zishanlin_tiandifenglei_quick()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"锐金旗") or string.find(_R.relation,"洪水旗") then
		 	local dx={"east","west","east"} --,"north"

		  alias.circle_co=coroutine.create(function()
             --print("启动3")
           for j,i in ipairs(dx) do

	           world.Send(i)
              self:circle_done("zishanlin_tiandifenglei_quick")
	          coroutine.yield()
		   end
	        self:zishanlin_tiandifenglei_quick()
          end)
		   coroutine.resume(alias.circle_co)
		elseif string.find(_R.relation,"紫杉林")  then
		   world.Send("east")
		   self:zishanlin_tiandifenglei_quick()
		else
		     local f=function()
		     local w
		     w=walk.new()
			 w.user_alias=self
		     w.walkover=function()
		       self:zishanlin_tiandifenglei_quick()
		     end
		     w:go(2175)
			 end
			 self:redo(f)
	   end
	end
	_R:CatchStart("west")
end


--local zishanlin_tiandifenglei_count=0
--[[
function alias:zishanlin_tiandifenglei()
--2464_3041
     local _R
      _R=Room.new()

	   zishanlin_tiandifenglei_count=zishanlin_tiandifenglei_count+1
	   local n=zishanlin_tiandifenglei_count
	  --print(n,"n")
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==3041 then
	     zishanlin_tiandifenglei_count=0
	     self:finish()
	   elseif roomno[1]==2464 then
	     if n>20 then
		   world.Send("north")
		   n=0
		 else
	       world.Send("south")
		 end
		 self:zishanlin2_check()

	   elseif _R.relation=="紫杉林｜洪水旗─紫杉林─紫杉林｜紫杉林" or _R.relation=="紫杉林｜锐金旗─紫杉林─紫杉林｜紫杉林" then
	     if n>20 then
	      world.Send("east")
		  n=0
		 else
		  world.Send("south")
		 end
		 self:zishanlin2_check()

	   elseif _R.relation=="紫杉林｜紫杉林─紫杉林─厚土旗｜紫杉林" or _R.relation=="紫杉林｜紫杉林─紫杉林─烈火旗｜紫杉林" then
		 if n>20 then
	      world.Send("west")
		  n=0
		 else
		  world.Send("south")
		 end
		 self:zishanlin2_check()
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zishanlin_tiandifenglei()
		end
		w:go(2464)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end]]

function alias:zishanlin_houtu()
     local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	     if roomno[1]==2464 then
              world.Send("south")
			 self.maze_step=function()
			   self:zishanlin_houtu()
			 end
			 if self.alias_table["zishanlin_houtu"].is_search==true then
			  self:maze_done()
			  else
			   self.maze_step()
			  end
	   elseif roomno[1]==2466 then
			  world.Execute("w;w;w;w;w;w")

		     self:finish()
	   elseif  roomno[1]==2462 then
			 world.Send("east")
		     self:finish()

	   else
		local f=function()
         local w
	 	 w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:finish()
		 end
		 w:go(2462)
		 end
		 self:redo(f)
        end
       end
       _R:CatchStart()
end

function alias:zishanlin_ruijin()
     local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
       if roomno[1]==2464 then
		     world.Send("south")
			 self.maze_step=function()
			   self:zishanlin_ruijin()
			 end
			 if self.alias_table["zishanlin_ruijin"].is_search==true then
			  self:maze_done()
			 else
               self.maze_step()
			 end
	   elseif roomno[1]==2466 then

		     --从锐金旗到洪水
			 world.Send("west")
		     self:finish()
	   elseif  roomno[1]==2462 then
			 world.Execute("e;e;e;e;e;e")
		     self:finish()

	   else
	      local f=function()
          local w
		  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		    self:zishanlin_ruijin()
	  	  end
		  w:go(2464)
		  end
		  self:redo(f)
       end
	 end
       _R:CatchStart()
end

function alias:tiandifenglei_out()
--2887 地 2888 天 2889 雷 2890 风
   world.Send("east")
   world.Send("southeast")
    local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
		--随机9个房间
	   if roomno[1]==2466  then
	      self:finish()
	   elseif roomno[1]==2461 or roomno[1]==2462 or roomno[1]==2465 or roomno[1]==2466 then
	      --重新计算路径
		    print("重新计算路径")
	        self:redo()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:tiandifenglei_out()
		end
		w:go(2466)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

local function tiandifenglei(relation,men)
local tian
local di
local feng
local lei
 if relation=="地字门｜天字门─紫杉林─风字门｜雷字门" then
   tian="west"
   di="north"
   feng="east"
   lei="south"
 elseif relation=="风字门｜地字门─紫杉林─雷字门｜天字门" then
   tian="south"
   di="west"
   feng="north"
   lei="east"
 elseif relation=="雷字门｜风字门─紫杉林─天字门｜地字门" then
   tian="east"
   di="south"
   feng="west"
   lei="north"
 elseif relation=="天字门｜雷字门─紫杉林─地字门｜风字门" then
   tian="north"
   di="east"
   feng="south"
   lei="west"
 end
 if men=="天字门" then
    return tian
 elseif men=="地字门" then
    return di
 elseif men=="风字门" then
    return feng
 elseif men=="雷字门" then
    return lei
 end
end

function alias:tiandifenglei_tian()
   local _R
	_R=Room.new()
	_R.CatchEnd=function()
		local dx=tiandifenglei(_R.relation,"天字门")
		world.Send(dx)
		  local _R1
        _R1=Room.new()
        _R1.CatchEnd=function()
         local count,roomno=Locate(_R1)
	     print("当前房间号",roomno[1])
	     if roomno[1]==2888 then
	       self:finish()
	     else
		    local f=function()
		  local w
		  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		     self:finish()
		  end
		  w:go(2888)
		  end
		  self:redo(f)
	     end
       end
       _R1:CatchStart()
	end
	_R:CatchStart()
end

function alias:tiandifenglei_di()
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
		  local dx=tiandifenglei(_R.relation,"地字门")
		  world.Send(dx)
		local _R1
        _R1=Room.new()
        _R1.CatchEnd=function()
         local count,roomno=Locate(_R1)
	     print("当前房间号",roomno[1])
	     if roomno[1]==2887 then
	       self:finish()
	     else
		    local f=function()
		  local w
		  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		    self:finish()
		  end
		  w:go(2887)
		  end
		  self:redo(f)
	     end
       end
       _R1:CatchStart()
       end
       _R:CatchStart()
end

function alias:tiandifenglei_feng()
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
		  local dx=tiandifenglei(_R.relation,"风字门")
		  world.Send(dx)
		    local _R1
        _R1=Room.new()
        _R1.CatchEnd=function()
         local count,roomno=Locate(_R1)
	     print("当前房间号",roomno[1])
	     if roomno[1]==2890 then
	       self:finish()
	     else
		    local f=function()
		  local w
		  w=walk.new()
		  w.user_alias=self
		 --[[ self.zishanlin_tiandifenglei=function()
		     self:zishanlin_tiandifenglei_quick() --
		  end]]
		  w.walkover=function()
		    self:finish()
		  end
		  w:go(2890)
		  end
		  self:redo(f)
	     end
       end
       _R1:CatchStart()
       end
       _R:CatchStart()
end

function alias:tiandifenglei_lei()
     local _R
      _R=Room.new()
      _R.CatchEnd=function()
		  local dx=tiandifenglei(_R.relation,"雷字门")
		  world.Send(dx)
		    local _R1
        _R1=Room.new()
        _R1.CatchEnd=function()
         local count,roomno=Locate(_R1)
	     print("当前房间号",roomno[1])
	      if roomno[1]==2889 then
	        self:finish()
	      else
		     local f=function()
		  local w
		   w=walk.new()
		   w.user_alias=self
		   w.walkover=function()
		     self:finish()
		   end
		   w:go(2889)
		   end
		   self:redo(f)
	      end
        end
         _R1:CatchStart()
       end
       _R:CatchStart()
end
--小朋友不要到那种地方去！！
function alias:xidajie_mingyufang()
   world.Send("north")
   wait.make(function()
      local l,w=wait.regexp("^(> |)鸣玉坊.*|小朋友不要到那种地方去！！",5)
	  if l==nil then
	     self:finish()
	     return
	  end
	  if string.find(l,"小朋友不要到那种地方") then
	     self.break_in_failure()
	     return
	  end
   	  if string.find(l,"鸣玉坊") then
	     self:finish()
	     return
	  end
   end)
end



function alias:huilang1_huilang2()
   world.Execute("s;e;e;s")
   self:finish()
end

function alias:huilang2_huilang1()
  world.Execute("n;w;w;n")
  self:finish()
end

function alias:huilang_huilang2(d)
--1755 1754
 local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1755 then
	   if d==nil then
	     local dx={"south","east"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:huilang_huilang2(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==1754 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:huilang_huilang2()
		end
		w:go(1755)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:huilang_huilang1(d)
--1755 2542
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1755 then
	   if d==nil then
	     local dx={"north","west"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:huilang_huilang1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2542 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:huilang_huilang1()
		end
		w:go(1755)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:tiaochuang()
   world.Send("push chuang")
   world.Send("tiao chuang")

      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2556 then
          local b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		     self:tiaochuang()
		  end
		  b:check()
	   elseif roomno[1]==2557 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:tiaochuang()
		end
		w:go(2556)
		end
		self:redo(f)
	    end
	 end
	 _R:CatchStart()
end

function alias:changjinggeyilou_changjinggeerlou()
--2555
--2556
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2555 then
	    local party=world.GetVariable("party")
		if party=="少林派" then
		   world.Send("up")
		   self:finish()
		else
          local f
		  f=function()
		   world.Send("up")
		   self:finish()
		  --self:changjinggeyilou_changjinggeerlou()
		  end
		  local exps=world.GetVariable("exps") or 0
		if tonumber(exps)>=5500000 then
		   break_npc=break_npc_id("chanshi")
           self:break_in("chanshi",f)
		else
		  self.break_in_failure()
		end


	    --elseif roomno[1]==2556 then
        end
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changjinggeyilou_changjinggeerlou()
		end
		w:go(2555)
		end
		self:redo(f)
	    end
	 end
	 _R:CatchStart()
end

function alias:yuchuan2_yuchuan1(d)
--1343-1342
	  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1343 then
	   if d==nil then
	     local dx={"south","west"}
	     d=dx_serial(dx)
	   end
	    --[[ local f=function()
	       world.Send(d())
           self:yuchuan2_yuchuan1(d)
	     end
	     f_wait(f,0.3)]]


		self.maze_step=function()
	       world.Send(d())
           self:yuchuan2_yuchuan1(d)
	    end
	     if self.alias_table["yuchuan2_yuchuan1"].is_search==true then
	        self:maze_done()
	     else
		   self.maze_step()
		 end
	   elseif roomno[1]==1342 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yuchuan2_yuchuan1()
		end
		w:go(1343)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end
--ysl2 ysl6
function alias:clg_ysl()
 --ysl6 3181 east;out;southeast;east;south
 --ysl5 2769*
 --ysl4 3185
 --ysl3 2767
 --ysl2 2760

 --ysl2 e ysl1 se ysl3
 --ysl3 e ysl4
 --ysl4 s ysl5
   world.Send("out")
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
             --local count,roomno=Locate(_R)
	    --print("当前房间号",roomno[1])
	   if _R.relation=="后院｜云杉林─云杉林─云杉林｜云杉林" then
	      world.Execute("e;se;e;s")
	      self:finish()
	   elseif _R.relation=="云杉林｜云杉林─云杉林─苦寒楼一层｜云杉林" then
	      world.Execute("east;out;southeast;east;south")
		  self:finish()
		elseif  _R.relation=="云杉林｜云杉林─云杉林─云杉林｜葱岭谷" then
		   self:finish()
		elseif _R.relation=="云杉林｜云杉林─云杉林─云杉林｜云杉林" then
		     local _R2=Room.new()
             _R2.CatchEnd=function()

			  if _R2.relation=="云杉林｜云杉林─云杉林─云杉林｜葱岭谷" then
			     world.Send("s")
			  else
			     world.Execute("e;s")
			  end
			    self:finish()
			 end
			 _R2:CatchStart("south")

	   else
          local f=function()
           local w
		   w=walk.new()
		   w.user_alias=self
		   w.walkover=function()
		     self:clg_ysl()
		   end
		   w:go(2769)
		 end
		 self:redo(f)
       end
	  end
       _R:CatchStart()
end

function alias:yugangmatou_chuancang()
 --1244 1345
      world.Execute("enter;north;enter;east;enter;norht;enter;east;enter;north;enter;east;enter;north;enter;east;enter;north;enter;east;enter")
	  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        --local count,roomno=Locate(_R)
	    --print("当前房间号",roomno[1])
	   if _R.RoomName=="船舱" then
	      self:finish()
	   elseif _R.RoomName=="渔船" then
	      self:yugangmatou_chuancang()
	   else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yugangmatou_chuancang()
		end
		w:go(1244)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:chuancang_yugangmatou()
 --1345 1244
    world.Execute("out;south;out;west;out;south;out;west;out;south;out;west;out;south;out;south;out;west;out")
	local _R
      _R=Room.new()
      _R.CatchEnd=function()
        --local count,roomno=Locate(_R)
	    --print("当前房间号",roomno[1])
	   if _R.RoomName=="渔港码头" then
	      self:finish()
	   elseif _R.RoomName=="渔船" then
	      self:chuancang_yugangmatou()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(1244)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:yuchuan2_yuchuan3(d)
--1343-1344
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
	    --print(_R.zone)
		--print("error")
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1343 then
	   if d==nil then
	     local dx={"north","east"}
	     d=dx_serial(dx)
	   end
		 --[[
	     local f=function()
	       world.Send(d())
           self:yuchuan2_yuchuan3(d)
	     end
	     f_wait(f,0.3)]]
		 self.maze_step=function()
	       world.Send(d())
           self:yuchuan2_yuchuan3(d)
	    end
	     if self.alias_table["yuchuan2_yuchuan3"].is_search==true then
	        self:maze_done()
	     else
		   self.maze_step()
		 end
	   elseif roomno[1]==1344 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yuchuan2_yuchuan3()
		end
		w:go(1343)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:changlang_huanglongdong(d)
--1170 2542
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1170 then
	   if d==nil then
	     local dx={"west","east","north","south"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:changlang_huanglongdong(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2631 then
	      print("jieshu")
	      self:finish()
		  print("jieshu")
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changlang_huanglongdong()
		end
		w:go(1170)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:xiaodaobian_matou()
--1975-1058
    local _R
	_R=Room.new()
	_R.CatchEnd=function()
	    local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1975 then
	      self:yellboat()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaodaobian_matou()
		end
		w:go(1975)
		end
		self:redo(f)
	    end
	end
	_R:CatchStart()
end

function alias:beimenbingying_jianyu()
--972_973
   world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==973 then
	   self:finish()
	 elseif roomno[1]==972 then
        --npc block
		local f
		f=function()
		  self:beimenbingying_jianyu()
		end
		break_npc=break_npc_id("zhao liangdong")
        self:break_in("zhao liangdong",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:beimenbingying_jianyu()
		end
		w:go(972)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--2418 2422
function alias:zoulang_shufang()
--
     local party=world.GetVariable("party") or ""
	 if party=="铁掌帮" then
       world.Send("north")
	   self:finish()
	 else
	   self:noway()
	 end
	--[[ wait.make(function()
	   local l,w=wait.regexp("^(> |)突然有个声音在你耳边响起：壮士不是铁掌帮的人，不得进入禁地。$",5)
	   if l==nil then
          self:zoulang_shufang()
	      return
	   end
	   if string.find(l,"突然有个声音在你耳边响起") then
		  self:noway()
		  return
	   end

	 end)]]

end

local whisper_count=0
function alias:shimen_riyuepin()
  world.Send("whisper jia 教主文成武德，一统江湖")
  world.Send("whisper jia 教主千秋万载，一统江湖")
  world.Send("whisper jia 属下忠心为主，万死不辞")
  world.Send("whisper jia 教主令旨英明，算无遗策")
  world.Send("whisper jia 教主烛照天下，造福万民")
  world.Send("whisper jia 教主战无不胜，攻无不克")
  world.Send("whisper jia 日月神教文成武德、仁义英明")
  world.Send("whisper jia 教主中兴圣教，泽被苍生")
  world.Send("westup")
  world.Send("whisper jia 教主文成武德，一统江湖")
  world.Send("whisper jia 教主千秋万载，一统江湖")
  world.Send("whisper jia 属下忠心为主，万死不辞")
  world.Send("whisper jia 教主令旨英明，算无遗策")
  world.Send("whisper jia 教主烛照天下，造福万民")
  world.Send("whisper jia 教主战无不胜，攻无不克")
  world.Send("whisper jia 日月神教文成武德、仁义英明")
  world.Send("whisper jia 教主中兴圣教，泽被苍生")
  world.Send("westup")
  --2111
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2854 then
	   self:finish()
	 elseif roomno[1]==2111 then
	   whisper_count=whisper_count+1
	   if whisper_count>=5 then
	      self:noway()
	      return
	   end
	   local f=function()
        self:shimen_riyuepin()
	   end
       f_wait(f,1.5)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shimen_riyuepin()
		end
		w:go(2111)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:holdteng()
   world.Execute("hold teng;jump down")
   self:finish()
end


function alias:jump_river()
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1930 then
	   self:finish()
	 elseif roomno[1]==2674 then
	    wait.make(function()
          world.Send("jump river")
          --你随波逐流，终于发现了岸边，浑身湿漉漉的爬上了汉水西岸。你随波逐流，终于发现了岸边，浑身湿漉漉的爬上了汉水西岸。
          local l,w=wait.regexp("^(> |)你随波逐流，终于发现了岸边，浑身湿漉漉的爬上了汉水西岸。$",15)
          if l==nil then
            self:jump_river()
	        return
          end
          if string.find(l,"你随波逐流，终于发现了岸边，浑身湿漉漉的爬上了汉水西岸") then
            self:finish()
	        return
          end
        end)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jump_river()
		end
		w:go(2674)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--[[function alias:liehuo_liehuo(d,pre_direction_index)
  if pre_direction_index==nil then
     pre_direction_index=1
  end
  local dx=nil
  for i=pre_direction_index,9 do
    if d[i]=="烈火丛林" and i~=5  then
		if i==1 then
		      dx="northwest"
			   pre_direction_index=i+1
		elseif i==2 then
		      dx="north"
			   pre_direction_index=i+1
		elseif i==3 then
		      dx="northeast"
			   pre_direction_index=i+1
		elseif i==4 then
		      dx="east"
              pre_direction_index=i+1
		elseif i==6 then
		      dx="southeast"
			   pre_direction_index=i+1
		elseif i==7 then
		      dx="south"
			   pre_direction_index=i+1
		elseif i==8 then
			  dx="southwest"
			   pre_direction_index=i+1
		elseif i==9 then
			  dx="west"
			   pre_direction_index=1
		end

		break
	end
  end
  --出循环
  if dx==nil then
    --没有找到合适的落叶
	pre_direction_index=1
	self:liehuo_liehuo(d,pre_direction_index)
    return
  end
 print(pre_direction_index)
  world.Send(dx)
  local f=function() self:liehuo_luoye(pre_direction_index) end
  f_wait(f,0.8)
end]]

function alias:liehuo_luoye(pre_direction_index)
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")  --井字格
	    --顺时针化
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
	  --判断哪几个方向是落叶丛林
	  local dx=nil
	  for i=1,9 do
	    if direction[i]=="落叶丛林"  then
           if i==1 then
		      world.Send("northwest")
		   elseif i==2 then
		      world.Send("north")
		   elseif i==3 then
		      world.Send("northeast")
		   elseif i==4 then
		      world.Send("east")
		   elseif i==6 then
		      world.Send("southeast")
		   elseif i==7 then
		      world.Send("south")
		   elseif i==8 then
			  world.Send("southwest")
		   elseif i==9 then
			  world.Send("west")
		   end
		   self:finish()
		   return
		end
      end
	  local j=math.random(9)

	      if j==1 then
		      world.Send("northwest")
		   elseif j==2 then
		      world.Send("north")
		   elseif j==3 then
		      world.Send("northeast")
		   elseif j==4 then
		      world.Send("east")
		   elseif j==6 then
		      world.Send("southeast")
		   elseif j==7 then
		      world.Send("south")
		   elseif j==8 then
			  world.Send("southwest")
		   elseif j==9 then
			  world.Send("west")
		   end
		   self:liehuo_luoye(pre_direction_index)

	 --[[if dx==nil then
      --没有找到合适的落叶

	  if pre_direction_index==nil then
	    pre_direction_index=1
	  end
	  self:liehuo_liehuo(direction,pre_direction_index)
      return
     end]]

   end
   _R:CatchStart()
end

function alias:luoye_liehuo(pre_direction_index)
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     if _R.roomname=="落叶丛林" then
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")  --井字格
	    --顺时针化
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
	  --判断哪几个方向是落叶丛林
	  for i=1,9 do
	    if direction[i]=="烈火丛林"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="east"
		   elseif i==6 then
		      dx="southeast"
		   elseif i==7 then
		      dx="south"
		   elseif i==8 then
			  dx="southwest"
		   elseif i==9 then
			  dx="west"
		   end
           local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
			  world.Send(dx)
			  self:finish()
		   end
		   b:check()
		   return
		end
      end
      --没有找到合适的落叶
	  if pre_direction_index==nil then
	    pre_direction_index=1
	  end
	  self:luoye_luoye(direction,pre_direction_index)
     else
	     local f=function()
	    local w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:luoye_liehuo()
		end
		w:go(2666)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:luoye_luoye(d,pre_direction_index)
  if pre_direction_index==nil then
     pre_direction_index=1
  end
  local dx=nil
  for i=pre_direction_index,9 do
    if d[i]=="落叶丛林" and i~=5  then
		if i==1 then
		      dx="northwest"
			   pre_direction_index=i+1
		elseif i==2 then
		      dx="north"
			   pre_direction_index=i+1
		elseif i==3 then
		      dx="northeast"
			   pre_direction_index=i+1
		elseif i==4 then
		      dx="east"
              pre_direction_index=i+1
		elseif i==6 then
		      dx="southeast"
			   pre_direction_index=i+1
		elseif i==7 then
		      dx="south"
			   pre_direction_index=i+1
		elseif i==8 then
			  dx="southwest"
			   pre_direction_index=i+1
		elseif i==9 then
			  dx="west"
			   pre_direction_index=1
		end
		break
	end
  end
  --出循环
  if dx==nil then
    --没有找到合适的落叶
	pre_direction_index=1
	self:luoye_luoye(d,pre_direction_index)
    return
  end
  world.Send(dx)
  local f=function() self:luoye_jixue(pre_direction_index) end
  f_wait(f,0.8)

end

function alias:jixue_luoye(pre_direction_index)
	local _R
   _R=Room.new()
   _R.CatchEnd=function()
      if _R.roomname=="积雪丛林" then

      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	    --顺时针化
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
  --判断哪几个方向是积雪丛林
	  for i=1,9 do
	    if direction[i]=="落叶丛林"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="east"
		   elseif i==6 then
		      dx="southeast"
		   elseif i==7 then
		      dx="south"
		   elseif i==8 then
			  dx="southwest"
		   elseif i==9 then
			  dx="west"
		   end
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     world.Send(dx)
		     self:finish()
		   end
		   b:check()
		   return
		end
      end
	  --没有积雪丛林 找下一个落叶丛林
      self:jixue_jixue(direction,pre_direction_index)
	  else  --不是积雪丛林
	      local f=function()
	     local w=walk.new()
		 w.user_alias=self
		 w.walkover=function()
		   self:jixue_luoye()
		 end
		 w.go(2667)
		 end
		 self:redo(f)
	  end
   end
   _R:CatchStart()
end

function alias:luoye_jixue(pre_direction_index)
	local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	    --顺时针化
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
  --判断哪几个方向是积雪丛林
	  for i=1,9 do
	    if direction[i]=="积雪丛林"  then
           if i==1 then
		      world.Send("northwest")
		   elseif i==2 then
		      world.Send("north")
		   elseif i==3 then
		      world.Send("northeast")
		   elseif i==4 then
		      world.Send("east")
		   elseif i==6 then
		      world.Send("southeast")
		   elseif i==7 then
		      world.Send("south")
		   elseif i==8 then
			  world.Send("southwest")
		   elseif i==9 then
			  world.Send("west")
		   end
		   self:finish()
		   return
		end
      end
	  --没有积雪丛林 找下一个落叶丛林
      self:luoye_luoye(direction,pre_direction_index)
   end
   _R:CatchStart()
end

local jixue_count=0
function alias:jixue_jixue(d,pre_direction_index)
   jixue_count=jixue_count+1
  if pre_direction_index==nil then
     pre_direction_index=1
  end
  local dx=nil
  for i=pre_direction_index,9 do
    if d[i]=="积雪丛林" and i~=5  then
		if i==1 then
		      dx="northwest"
			   pre_direction_index=i+1
		elseif i==2 then
		      dx="north"
			   pre_direction_index=i+1
		elseif i==3 then
		      dx="northeast"
			   pre_direction_index=i+1
		elseif i==4 then
		      dx="east"
              pre_direction_index=i+1
		elseif i==6 then
		      dx="southeast"
			   pre_direction_index=i+1
		elseif i==7 then
		      dx="south"
			   pre_direction_index=i+1
		elseif i==8 then
			  dx="southwest"
			   pre_direction_index=i+1
		elseif i==9 then
			  dx="west"
			   pre_direction_index=1
		end
		break
	end
  end
  --出循环
  if dx==nil then
    --没有找到合适的落叶
	pre_direction_index=1
	self:jixue_jixue(d,pre_direction_index)
    return
  end
  if jixue_count>3 then --连续几次没有走出来 随机行走
     print("迷路 死循环了！！")
	 pre_direction_index=1
	 jixue_count=0
     local n=math.random(1,8)
	 local dir={"east","north","west","south","northeast","northwest","southwest","southeast"}
	 dx=dir[n]
  end
  world.Send(dx)
  local f=function() self:jixue_kuoye(pre_direction_index) end
  local b=busy.new()
   b.interval=0.8
	 b.Next=function()
	     f()
	 end
  b:check()
  --f_wait(f,1)
end

function alias:kuoye_jixue(pre_direction_index)
     local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林	烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	    --顺时针化
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
  --判断哪几个方向是落叶丛林
	  for i=1,9 do
	     local dx
	    if direction[i]=="积雪丛林"  then
           if i==1 then
		     dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="east"
		   elseif i==6 then
		     dx="southeast"
		   elseif i==7 then
		      dx="south"
		   elseif i==8 then
			 dx="southwest"
		   elseif i==9 then
			 dx="west"
		   end
           local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		      world.Send(dx)
		      self:finish()
		   end
		   b:check()
		   return
		end
      end
    --没有阔叶丛林 找下一个积雪丛林
      self:kuoye_kuoye(direction,pre_direction_index)
   end
   _R:CatchStart()
end

local jixue_kuoye_count=0
function alias:jixue_kuoye(pre_direction_index)
     local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林	烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	    --顺时针化
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
  --判断哪几个方向是落叶丛林
	  for i=1,9 do
	    if direction[i]=="阔叶丛林"  then
           if i==1 then
		      world.Send("northwest")
		   elseif i==2 then
		      world.Send("north")
		   elseif i==3 then
		      world.Send("northeast")
		   elseif i==4 then
		      world.Send("east")
		   elseif i==6 then
		      world.Send("southeast")
		   elseif i==7 then
		      world.Send("south")
		   elseif i==8 then
			  world.Send("southwest")
		   elseif i==9 then
			  world.Send("west")
		   end

		   self:finish()
		   return
		end
      end
    --没有阔叶丛林 找下一个积雪丛林
      self:jixue_jixue(direction,pre_direction_index)
   end
   _R:CatchStart()
end

local step_count=0
function alias:kuoye_kuoye(d,pre_direction_index)
	step_count=step_count+1
	local _R
	_R=Room.new()
    _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林	烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="阔叶丛林"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  if step_count>=10 then
		 print("迷路了！！")
	    for i=1,9 do
	     if direction[i]=="积雪丛林"  then
           if i==1 then
		      world.Send("northwest")
		   elseif i==2 then
		      world.Send("north")
		   elseif i==3 then
		      world.Send("northeast")
		   elseif i==4 then
		      world.Send("east")
		   elseif i==6 then
		      world.Send("southeast")
		   elseif i==7 then
		      world.Send("south")
		   elseif i==8 then
			  world.Send("southwest")
		   elseif i==9 then
			  world.Send("west")
		   end
		    local f=self.finish
		    self.finish=function()
			    self.finish=f
                self:kuoye_conglin(pre_direction_index)
		    end
		    self:jixue_kuoye(pre_direction_index)
		   return
		 end
        end
	  end
	  --随机数
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("范围:",n," 随机出口",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	       local f=function() self:kuoye_conglin(pre_direction_index) end
          f_wait(f,0.8)
	  end
	  b:check()
   end
   _R:CatchStart()
end

function alias:kuoye_conglin(pre_direction_index)
	step_count=0
	local _R
   _R=Room.new()
   print("寻找丛林边缘")--落叶丛林
   _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林	烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	  --顺时针化
	  direction[4],direction[6],direction[7],direction[8],direction[9]=direction[6],direction[9],direction[8],direction[7],direction[4]
	  local dx
      for i=1,9 do
	    if direction[i]=="丛林边缘"  then
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="east"
		   elseif i==6 then
		      dx="southeast"
		   elseif i==7 then
		      dx="south"
		   elseif i==8 then
			  dx="southwest"
		   elseif i==9 then
			  dx="west"
		   end
		   local b=busy.new()
		   b.Next=function()
		     world.Send(dx)
		     self:finish()
		   end
		   b:check()
		   return
		end
      end
       self:kuoye_kuoye(direction,pre_direction_index)
   end
   _R:CatchStart()
end

--1257 天黑关门 west 关闭
function alias:opening(c,hour,minutes)
   local h
   local m
   if hour=="子" then
       h=1
   elseif hour=="丑" then
       h=2
   elseif hour=="寅" then
       h=3
   elseif hour=="卯" then
       h=4
   elseif hour=="辰" then
       h=5
   elseif hour=="巳" then
       h=6
   elseif hour=="午" then
       h=7
   elseif hour=="未" then
       h=8
   elseif hour=="申" then
       h=9
   elseif hour=="酉" then  --酉时二刻。
       h=10
   elseif hour=="戌" then
       h=11
   elseif hour=="亥" then
       h=12
   end
   if minutes=="正" then
      m=0
   elseif minutes=="一刻" then
      m=15
   elseif minutes=="二刻" then
      m=30
   elseif minutes=="三刻" then
      m=45
   end
   --print(c)
   local result=true
    print(c," 时间:",h)
   if c=="fuzhouchengximen" or c=="fuzhouchengnanmen"  then
     if h>=3 and h<10 then
	   print("opening",true)
       result= true
	 elseif h==2 and m>=45 then
	   result=true
	 else
	   print("opening",false)
	   result= false
	 end
   end
   self.finish(result)
end

function alias:jy()
   return false
end

function alias:virtual_rooms(c)
   if c=="fuzhouchengximen" or c=="fuzhouchengnanmen" then
      return true
   elseif c=="jump_river" or c=="goboat" or c=="guanmucong" then
      return false
   else
      return false
   end
end

function alias:opentime(c)  -- 确定开发时间
  wait.make(function()
     --world.Send("time")
      world.Send("time -s")
	  local l,w=wait.regexp("^(> |)现在是书剑(.*)年(.*)月(.*)日(.*)时(.*)。$",15)
	  if l==nil then
	    print("超时:")--酉
	    self:opentime(c)
		return
	  end
	  if string.find(l,"现在是书剑") then
	    print(w[2],w[3],w[4],w[5],w[6])
	    self:opening(c,w[5],w[6])
		return
	  end
   end)
end

function alias:push_grass()
   world.Execute("push grass;northwest")
   self:finish()
end

function alias:liehuo()
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林	烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="烈火丛林"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  --随机数
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("范围:",n," 随机出口",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	      self:finish()
	  end
	  b:check()
   end
   _R:CatchStart()
end

function alias:luoye()
    local _R
	_R=Room.new()
   _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林	烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="落叶丛林"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  --随机数
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("范围:",n," 随机出口",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	      self:finish()
	  end
	  b:check()
   end
   _R:CatchStart()
end

function alias:jixue()

   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林	烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="积雪丛林"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  --随机数
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("范围:",n," 随机出口",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	      self:finish()
	  end
	  b:check()
   end
   _R:CatchStart()
end

function alias:kuoye()
    local _R
	_R=Room.new()
    _R.CatchEnd=function()
      --烈火丛林 烈火丛林 烈火丛林↖ ｜ ↗落叶丛林─烈火丛林─烈火丛林↙ ｜ ↘烈火丛林 烈火丛林 烈火丛林	烈火丛林
	  local matrix=string.gsub(_R.relation, "↖ ｜ ↗", " ")
	   matrix=string.gsub(matrix,"↙ ｜ ↘"," ")
	   matrix=string.gsub(matrix,"─"," ")
	  local direction=Split(matrix, " ")
	  local All_exits={}
      for i=1,9 do
	    if direction[i]=="阔叶丛林"  then
		   local dx
           if i==1 then
		      dx="northwest"
		   elseif i==2 then
		      dx="north"
		   elseif i==3 then
		      dx="northeast"
		   elseif i==4 then
		      dx="west"
		   elseif i==6 then
		      dx="east"
		   elseif i==7 then
		      dx="southwest"
		   elseif i==8 then
			  dx="south"
		   elseif i==9 then
			  dx="southeast"
		   end
		   table.insert(All_exits,dx)
		end
      end
	  --随机数
	  local n=table.getn(All_exits)
	  local seed=math.random(n)
	  print("范围:",n," 随机出口",seed)
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	      world.Send(All_exits[seed])
	      self:finish()
	  end
	  b:check()

   end
   _R:CatchStart()
end


function alias:opendoorenter()
   world.Send("open door")
   world.Send("enter")
   self:finish()
end

function alias:push_qiaolan()
   world.Send("push 桥栏")
   world.Send("down")
   self:finish()
end

function alias:zuan_didao()
  world.Send("zuan didao")
  self:finish()
end

function alias:shanlu_shanzhongxiaoxi(d)
    local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==1704 then
	   if d==nil then
	     local dx={"south","east"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:shanlu_shanzhongxiaoxi(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==531 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanlu_shanzhongxiaoxi()
		end
		w:go(531)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:chanyan_shidao()
	world.Send("north")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==294 then
		 print("npc block")
		 local f
		 f=function()
		   self:chanyan_shidao()
		 end
		 break_npc=break_npc_id("ding mian")
         self:break_in("ding mian",f)
	   elseif roomno[1]==295 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:chanyan_shidao()
		end
		w:go(294)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

local mark_x=0
local mark_y=0
local axis=1
local index=0
local dx="e"
function alias:maze_shandao()
-- 进行顺时针旋转
  print(mark_x,":",mark_y)
  if index<axis then
      index=index+1
  else
      if dx=="e" then
	     dx="s"
		 index=0
	  elseif dx=="s" then
         dx="w"
		  axis=axis+1 --轴长+1
		 index=0
	  elseif dx=="w" then
		 dx="n"
		 index=0
	  elseif dx=="n" then
	     dx="e"
		 axis=axis+1 --轴长+1
	     index=0
	  end

  end
  if dx=="e" then
       mark_x=mark_x+1
  elseif dx=="w" then
       mark_x=mark_x-1
  elseif dx=="n" then
       mark_y=mark_y-1
  elseif dx=="s" then
      mark_y=mark_y+1
  end

  world.Send(dx)
  wait.make(function()
	 local l,w=wait.regexp("^(> |)山道 \\- .*$|^(> |)你的动作还没有完成，不能移动。$|^(> |)这个方向没有出路。$|^(> |)你乱走了一通，居然发现自己走回了原地。$|^(> |)你喃喃骂道：「这灯可有点儿邪门。」$|^(> |)你凝目向山谷望去，只见那灯火发出绿油油的光芒，迥不同寻常灯火的色作$",5)
	 if l==nil then
        --print("test3")
	    self:maze_shandao()
	    return
	 end
	 if string.find(l,"你的动作还没有完成") then
	   --print("test")
	    wait.time(0.1)
		self:maze_shandao()
		return
	 end
     if string.find(l,"你喃喃骂道") or string.find(l,"这个方向没有出路") then
	    mark_x=-16
		mark_y=-16
	    self:finish()
	    return
	 end
     if string.find(l,"你凝目向山谷望去，只见那灯火发出绿油油的光芒，迥不同寻常灯火的色作") then
	    local q=quest.new()
		q.Execute=function()
		   self:finish()
		end
		q:tianshan()
	    return
	 end
     if string.find(l,"山道") then
	    --print("test2")
		wait.time(0.1)
		self:maze_shandao()

        return

	 end

 end)
end

function alias:shandao_shanjin()
--天山山道 - 迷宫 -8*+8
    -- print("开始找童姥")
	--[[
	        i=random(5)+2;
	j=random(4)+3;
			me->set_temp("tonglao/steps",j); 3~7   w -1 e 1
		me->set_temp("tonglao/step",-i); -2~-7     s 1 n -1
			if (dir == "west") me->add_temp("mark/steps",-1);
	if (dir == "south") me->add_temp("mark/step",1);
	if (dir == "east") me->add_temp("mark/steps",1);
        if (dir == "north") me->add_temp("mark/step",-1);
		]]
    -- world.Execute("n;n;n;n;n;n;n;n;w;w;w;w;w;w;w;w")  --从左上角开始
	 mark_x=0
	 mark_y=0
	 axis=1
	 index=0
	 dx="e"
	 local b=busy.new()
	 b.Next=function()
	   --world.Execute("#16w")
	   --world.Execute("#16s")
	   world.AppendToNotepad (WorldName(),os.date()..": 天山山道".."\r\n")

       local _R
       _R=Room.new()
       _R.CatchEnd=function()
         local count,roomno=Locate(_R)
	     print("当前房间号",roomno[1])
	     if roomno[1]==2743 then
	        self:maze_shandao()

		 elseif roomno[1]==2299 then
		    world.AppendToNotepad (WorldName(),os.date().."结束: 天山山道"..dx.." ".. c.." range:"..range.."\r\n")
	        self:finish()
	      end
        end
	    _R:CatchStart()
	  end
	  b:check()
end

function alias:juyiting_shenhuotang()
--2457_2745
 world.Send("northup")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2745 then
	   self:finish()
	 elseif roomno[1]==2457 then
        --npc block
		local f
		f=function()
		  self:juyiting_shenhuotang()
		end
		break_npc=break_npc_id("fan yao")
        self:break_in("fan yao",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:juyiting_shenhuotang()
		end
		w:go(2457)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:juyiting_longwangdian()
--2457_2748
   local party=world.GetVariable("party")
   if party=="明教" then
      world.Send("west")
	  self:finish()
      return
   end
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2748 then
	   self:finish()
	 elseif roomno[1]==2457 then
        --npc block
		local f
		f=function()
		  self:juyiting_longwangdian()
		end
		local exps=world.GetVariable("exps") or 0
		if tonumber(exps)>=5000000 then
		  world.Send("west")
		  break_npc=break_npc_id("yang xiao")
          self:break_in("yang xiao",f)
		else
		  self.break_in_failure()
		end

	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:juyiting_longwangdian()
		end
		w:go(2457)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--第一种：ne;ne;se;e;s;w;e;up;up;out
--从班淑娴到苦寒楼一层{sw;sw;se;e;s;w;e} 2225 se e s w e
--第二种  ne;ne;se;w;e;up;up;out
function alias:yunshanlin2_yunshanlin1(d)
    local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2769 then
	   if d==nil then
	     local dx={"east","north","west","east","west","north","south","east","north","south"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:yunshanlin2_yunshanlin1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2767 then
	      world.Send("south")
	   elseif roomno[1]==2760 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2760)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:xiaojing2_xiaojing1(d)
---2771 2755 2754
  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2755 then
	   if d==nil then
	     local dx={"north","east","west"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:xiaojing2_xiaojing1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2754 then
	      self:finish()
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing2_xiaojing1()
		end
		w:go(2755)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:light()
   wait.make(function()
      local l,w=wait.regexp("^(> |)你站在小径上，四周打量，仿佛看见(.*)面有些亮光。$",8)
	  if l==nil then
	     world.Send("south")
	     self:xiaojing2_yuanmen()
	     return
	  end
	  if string.find(l,"你站在小径上") then
	    local dx=w[2]
		if dx=="东" then
		   world.Send("east")
		elseif dx=="南" then
		    world.Send("south")
		elseif dx=="北" then
		   world.Send("north")
		elseif dx=="西" then
		   world.Send("west")
		end
		self:xiaojing2_yuanmen()
		return
	  end
	  wait.time(5)
   end)
end

function alias:xiaojing2_yuanmen()
---2771 2755 2754
  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2755 then
          self:light()
	   elseif roomno[1]==2771 then
	      self:finish()
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing2_yuanmen()
		end
		w:go(2755)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:yuanmen_houshanxiaoyuan()
 world.Send("open door")
 world.Send("south")
 local _R
	_R=Room.new()
	_R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	 if roomno[1]==2771 then
		local f
		 f=function()
		   self:yuanmen_houshanxiaoyuan()
		 end
		 break_npc=break_npc_id("yin liting")
         self:break_in("yin liting",f,true)
	 elseif roomno[1]==2772 then
	      self:finish()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yuanmen_houshanxiaoyuan()
		end
		w:go(2772)
		end
		self:redo(f)
	  end
	end
  _R:CatchStart()
end

--小径 2045 东厢走廊 2046
function alias:xiaojing_dongxiangzoulang()
   world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2046 then
	   self:finish()
	 elseif roomno[1]==2045 then
        --npc block
		local f
		f=function()
		  self:xiaojing_dongxiangzoulang()
		end
		break_npc=break_npc_id("yu lianzhou")
        self:break_in("yu lianzhou",f,true)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing_dongxiangzoulang()
		end
		w:go(2045)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--西厢走廊 2752
function alias:xiaojing_xixiangzoulang()
   world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2752 then
	   self:finish()
	 elseif roomno[1]==2045 then
        --npc block
		local f
		f=function()
		  self:xiaojing_xixiangzoulang()
		end
		break_npc=break_npc_id("yu lianzhou")
        self:break_in("yu lianzhou",f,true)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing_xixiangzoulang()
		end
		w:go(2045)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--小径 2754
function alias:xiaojing_xiaojing1()
   world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2754 then
	   self:finish()
	 elseif roomno[1]==2045 then
        --npc block
		local f
		f=function()
		  self:xiaojing_xiaojing1()
		end
		break_npc=break_npc_id("yu lianzhou")
        self:break_in("yu lianzhou",f,true)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaojing_xiaojing1()
		end
		w:go(2045)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:songshulin2_songshulin1(d)
--2779 2698
 local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2779 then
	   if d==nil then
	     --s;s;e;s;w;s
	     local dx={"south","south","east","south","west","south"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:songshulin2_songshulin1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2698 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:songshulin2_songshulin1()
		end
		w:go(2779)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:songshulin2_songshulin3(d)
--2779 2774
 local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2779 then
	   if d==nil then

	     local dx={"north","east","north","west","north","north"}
	     d=dx_serial(dx)
	   end

	    self.maze_step=function()
	     local f=function()
	       world.Send(d())
           self:songshulin2_songshulin3(d)
	     end
	     f_wait(f,0.3)
	    end
	   if self.alias_table["songshulin2_songshulin3"].is_search==true then
	     self:maze_done()
	   else
	      self.maze_step()
	   end


	   elseif roomno[1]==2774 then
	      self:finish()
	   else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:songshulin2_songshulin3()
		end
		w:go(2779)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:zoulang_lianwuchang()
--2489 2786
  world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2786 then
	   self:finish()
	 elseif roomno[1]==2489 then
        --npc block
		local f
		f=function()
		  self:zoulang_lianwuchang()
		end
		break_npc=break_npc_id("zhuang ding")--庄丁(Zhuang ding)
        self:break_in("zhuang ding",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zoulang_lianwuchang()
		end
		w:go(2489)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()

end
--去桃花岛 1842_2794 2803 黄蓉 2814 黄药师
--2794
function alias:haibing_taohuadao()
 wait.make(function()
 --船「咣」的一声撞到了岸边，你急忙纵身跳上了岸。
  world.Send("look rock")
  world.Send("jump boat")
    local l,w=wait.regexp("^(> |)船「咣」的一声撞到了岸边，你急忙纵身跳上了岸。$|^(> )你要对谁做这个动作？$",5)
	if l==nil then
	   self:haibing_taohuadao()
	   return

	end
	if string.find(l,"你要对谁做这个动作") then
	   local w=walk.new()
	   w.walkover=function()
	      self:haibing_taohuadao()
	   end
	   w:go(1842)
	   return
	end
	if string.find(l,"船「咣」的一声撞到了岸边，你急忙纵身跳上了岸") then
	    wait.time(2)
	    --local b=busy.new()
		--b.interval=0.3
		--b.Next=function()
	      self:finish()
		--end
		--b:check()
	   return
	end

  end)
end

function alias:leave_taohuadao()
   --2814 --1842
   wait.make(function()
      world.Send("ask huang yaoshi about leave")
	  local l,w=wait.regexp("^(> |)海上正是顺风，船借风势，数日内便到达了。$|^(> |)这里没有这个人。$|^(> |)黄药师一招手，喊过一个艄公来：载这位.*回陆地。$",5)
	  if l==nil then
	      self:leave_taohuadao()
	     return
	  end
	  if string.find(l,"这里没有这个人") then
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:leave_taohuadao()
		end
		w:go(2814)
		end
		self:redo(f)
	     return
	  end
      if string.find(l,"海上正是顺风，船借风势，数日内便到达了") or string.find(l,"喊过一个艄公来") then
	    local b=busy.new()
		b.interval=0.3
		b.Next=function()
	      self:finish()
		end
		b:check()
	     return
	  end
	  wait.time(5)
   end)


end

function alias:out_graveyard()
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
      local count,roomno=Locate(_R)
	  if roomno[1]==2834 then
	   self:finish()
	 elseif roomno[1]==2836 then
        --npc block
		local exits=Split(_R.exits,";")
	    for _,e in ipairs(exits) do
	       if e~="down" then
		    world.Send(e)
			world.Execute("up;out")
			print("出墓地，检查")
			self:out_graveyard()
			break
		   end
	    end
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:out_graveyard()
		end
		w:go(2836)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shufang_jiabi()
  world.Execute("sit chair;zhuan")
  self:finish()
end

function alias:jiabi_shufang()
  world.Execute("push shujia")
  self:finish()
end

--2850 n w e 3个房间都是2850 本身 迷宫没有出路
function alias:dasonglin_findway(d,test_dir)
   if test_dir==nil then
      test_dir="west"
      world.Send("west")
   elseif test_dir=="west" then
      test_dir="north"
      world.Send("north")
   elseif test_dir=="north" then
       test_dir="east"
      world.Send("east")
   elseif test_dir=="east" then
      self:noway() --没有出路
	  return
   end
   local _R
	_R=Room.new()
	_R.CatchEnd=function()
	    if _R.relation=="大松林｜大松林─大松林─大松林｜后院" then
		    self:dasonglin_findway(d,test_dir)
		else
		    self:songlin1_songlin2(d)
		end
	end
    _R:CatchStart()

end

function alias:songlin_mark(dir)
  world.Send("get coin")
   world.Send("drop 1 coin")
  wait.make(function()
    local l,w=wait.regexp("^(> |)你捡起一些铜钱。$|^(> |)你附近没有这样东西。$",5)
	if l==nil then
	  self:songlin_mark(dir)
	  return
	end
	if string.find(l,"你捡起一些铜钱") then
	  if dir=="e" then
	     dir="w"
	  elseif dir=="w" then
	     dir="s"
	  elseif dir=="s" then
	     dir="e"
	  end
	  --wait.time(0.5)
	  world.Send(dir)
	  self:songlin1_songlin2(dir)
	  return
	end
	if string.find(l,"你附近没有这样东西") then
	   dir="e"
	   world.Send(dir)
	   self:songlin1_songlin2(dir)
	   return
	end
 end)
end


local songlin_count=0
function alias:songlin1_songlin2(d)
      if d==nil then
	     songlin_count=0
	  end
--w;e;s;e
--晚上才能进去
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
		songlin_count=songlin_count+1
	   if roomno[1]==2850 then

         print("计数器:",80-songlin_count)
		 if songlin_count>80 then
		   songlin_count=0
		   self:noway()
		   --self:finish()
		   print("松树林找不到出路!!!!")
		   return
		 end
	     self:dasonglin_findway(d)
	   elseif roomno[1]==2891 then
	     if d==nil then
	     --local dx={"west","east","south","east"}
		   --songlin_count=0
		   -- d=dx_serial(dx)
		   d="e"
	     end
	     print("计数器:",80-songlin_count)
	     if songlin_count>80 then
		   songlin_count=0
		   self:noway()

		   --self:finish()
		   print("松树林找不到出路!!!!")
		   return
		 end
		 self:songlin_mark(d)
		 --[[
	     local f=function()
		   world.Send(d)
           self:songlin1_songlin2(d)
	     end
	     f_wait(f,0.3)]]
	   elseif roomno[1]==2853 then
	      self:finish()
	   else
	       local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:songlin1_songlin2(d)
		end
		w:go(2850)
		end
		self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:songlin2_songlin1(d)
--w;e;s;e
--晚上才能进去
   local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==2853 then
	      world.Send("east")
          world.Send("west")
		  self:songlin2_songlin1()
	   elseif roomno[1]==2891 then
	    if d==nil then
	     local dx={"west","east","south","east"}
	     d=dx_serial(dx)
	   end
	     local f=function()
	       world.Send(d())
           self:songlin2_songlin1(d)
	     end
	     f_wait(f,0.3)
	   elseif roomno[1]==2850 then
	      self:finish()
	   else
	       local f=function()
		  local w
		  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		   self:finish()
		  end
		  w:go(2850)
		  end
		  self:redo(f)
	    end
       end
  _R:CatchStart()
end

function alias:jianhugong_houyuan()
 world.Send("north") --2411
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2849 then
	   self:finish()
	 elseif roomno[1]==2411 then
        --npc block
		local f
		f=function()
		  self:jianhugong_houyuan()
		end
		break_npc=break_npc_id("gong guangjie|xin shuangqing|zuo zimu")
        self:break_in("gong guangjie|xin shuangqing|zuo zimu",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jianhugong_houyuan()
		end
		w:go(2411)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:jianhugong_donglianwuchang()
  world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2847 then
	   self:finish()
	 elseif roomno[1]==2411 then
        --npc block
		local f
		f=function()
		  self:jianhugong_donglianwuchang()
		end
		break_npc=break_npc_id("gong guangjie|xin shuangqing|zuo zimu")
        self:break_in("gong guangjie|xin shuangqing|zuo zimu",f)
	 else
	    local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jianhugong_donglianwuchang()
		end
		w:go(2411)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:jianhugong_xilianwuchang()
  world.Send("west")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2848 then
	   self:finish()
	 elseif roomno[1]==2411 then
        --npc block
		local f
		f=function()
		  self:jianhugong_xilianwuchang()
		end
		break_npc=break_npc_id("gong guangjie|xin shuangqing|zuo zimu")
        self:break_in("gong guangjie|xin shuangqing|zuo zimu",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jianhugong_xilianwuchang()
		end
		w:go(2411)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:dapubu_bailongfeng()--2851_2852
  world.Send("southeast")

 --无量剑西宗弟子 葛光佩(ge guangpei)
  --无量剑东宗弟子 干光豪(gan guanghao)
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2852 then
	   self:finish()
	 elseif roomno[1]==2851 then
        --npc block
		local f
		f=function()
		  self:dapubu_bailongfeng()
		end
		break_npc=break_npc_id("ge guangpei|gan guanghao")
        self:break_in("ge guangpei|gan guanghao",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dapubu_bailongfeng()
		end
		w:go(2851)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--黑木崖
function alias:outlou()
--竹篓晃了几下，在一间石屋之内停了下来。
  wait.make(function()
     local l,w=wait.regexp("^(> |)竹篓晃了几下，在一间石屋之内停了下来。$",5)
     if l==nil then
	    self:outlou()
	    return
	 end
	 if string.find(l,"竹篓晃了几下，在一间石屋之内停了下来") then
	    world.Send("out")
	    self:finish()
	    return
	 end
	 wait.time(5)
  end)
end

function alias:xiaya()
	wait.make(function()
	       world.Send("yell xiaya")
	       world.Send("enter")

           local l,w=wait.regexp("^(> |).*竹篓\\\s*-\\\s*(out|)$",2)
	       if l==nil then
	          self:xiaya()
	         return
	       end
	      if string.find(l,"竹篓") then
	        self:outlou()
		    return
		  end
	     wait.time(2)
	end)
end

function alias:shangya()
	wait.make(function()
	       world.Send("yell shangya")
	       world.Send("enter")
           local l,w=wait.regexp("^(> |).*竹篓\\\s*-\\\s*(out|)$",2)
	       if l==nil then
	          self:shangya()
	         return
	       end
	      if string.find(l,"竹篓") then
	        self:outlou()
		    return
		  end
	     wait.time(2)
	end)
end

function alias:yading_riyuepin()
--2856_2854 --2856
  wait.make(function()
    world.Send("zong")
	  local l,w=wait.regexp("^(> |)你一提内息，看准了崖间竹篓位置，使出「纵字诀」，想要飞身.*崖。$|^(> |)你的修为不够！$|^(> |)你的内力修为不够，怎能支持！？$|^(> |)什么.*$",5)
	  if l==nil then
	    self:yading_riyuepin()
	    return
	  end
	  if string.find(l,"你一提内息，看准了崖间竹篓位置") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
	     self:finish()
		end
		b:check()
	     return
	  end
	  if string.find(l,"你的修为不够") or string.find(l,"你的内力修为不够") then
         self:xiaya()
	     return
	  end
	  if string.find(l,"什么") then
	    self:finish()
		return
	  end
	  wait.time(5)
 end)
end

function alias:riyuepin_yading()
--2854_2856
 wait.make(function()
    world.Send("zong")
	  local l,w=wait.regexp("^(> |)你一提内息，看准了崖间竹篓位置，使出「纵字诀」，想要飞身.*崖。$|^(> |)你的修为不够！$|^(> |)你的内力修为不够，怎能支持！？$|^(> |)什么.*$",5)
	  if l==nil then
	    self:yading_riyuepin()
	    return
	  end
	  if string.find(l,"你一提内息，看准了崖间竹篓位置") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
	     self:finish()
		end
		b:check()
	     return
	  end
	  if string.find(l,"你的修为不够") or string.find(l,"你的内力修为不够") then
         self:shangya()
	     return
	  end
	  if string.find(l,"什么") then
	     self:finish()
		 return
	  end
	  wait.time(5)
 end)
end

function alias:unwield_west()
 local sp=special_item.new()
	sp.cooldown=function()
     world.Send("west")
	 local shield=world.GetVariable("shield") or ""
	 if shield~="" then
	   world.Execute(shield)
	 end
     self:finish()
   end
   sp:unwield_all()
end

function alias:unwield_east()
 local sp=special_item.new()
	sp.cooldown=function()
     world.Send("east")
	local shield=world.GetVariable("shield") or ""
	 if shield~="" then
	   world.Execute(shield)
	 end
     self:finish()
   end
   sp:unwield_all()
end

function alias:unwield_north()
 local sp=special_item.new()
	sp.cooldown=function()
     world.Send("north")
	 local shield=world.GetVariable("shield") or ""
	 if shield~="" then
	   world.Execute(shield)
	 end
     self:finish()
   end
   sp:unwield_all()
end

function alias:out_boat1()
   wait.make(function()
      local l,w=wait.regexp("^(> |)又划出三四里，溪心忽有九块大石迎面耸立，犹如屏风一般，挡住了来船去路。$",5)
	  if l==nil then

	     self:out_boat1()
		 return
	  end
	  if string.find(l,"又划出三四里，溪心忽有九块大石迎面耸立，犹如屏风一般，挡住了来船去路") then
	     world.Send("out")
		 self:finish()
	     return
	  end
	 wait.time(5)
   end)
end
function alias:out_boat2()
   wait.make(function()
	  local l,w=wait.regexp("^(> |)又划出三四里，溪流曲折，小舟经划过了几个弯后又回到溪边。$",5)
	  if l==nil then

	     self:out_boat2()
		 return
	  end
	  if string.find(l,"又划出三四里，溪流曲折，小舟经划过了几个弯后又回到溪边") then
	     world.Send("out")
		 self:finish()
	     return
	  end
	 wait.time(5)
   end)
end
function alias:xiaoxi_dufengling()
--610_2897
--又划出三四里，溪心忽有九块大石迎面耸立，犹如屏风一般，挡住了来船去路。
  world.Send("look boat")
  world.Send("yue zhou")
  --你屏气凝神，稳稳地站落在小舟之上。
  wait.make(function()
     local l,w=wait.regexp("^(> |)你要对谁做这个动作？$|^(> |)你屏气凝神，稳稳地站落在小舟之上。$|^(> |)你要看什么？$",5)
	 if l==nil then
	     self:xiaoxi_dufengling()
	     return
	 end
	 if string.find(l,"你要对谁做这个动作") or string.find(l,"你要看什么") then
	    self:finish()
		return
	 end
	 if string.find(l,"你屏气凝神") then
	    self:out_boat1()
		return
	 end
	 wait.time(5)
  end)
end

function alias:dufengling_xiaoxi()
--2897 610_
--又划出三四里，溪流曲折，小舟经划过了几个弯后又回到溪边。
 local sp=special_item.new()
 sp.cooldown=function()
  world.Send("tui boat")
  world.Send("jump boat")
  --你吸了口气，纵身向小舟上跳将过去。
  --> 你要对谁做这个动作？
    wait.make(function()
     local l,w=wait.regexp("^(> |)你要对谁做这个动作？$|^(> |)你吸了口气，纵身向小舟上跳将过去。$",5)
	 if l==nil then
	     self:xiaoxi_dufengling()
	     return
	 end
	 if string.find(l,"你要对谁做这个动作") then
	    self:finish()
		return
	 end
	 if string.find(l,"纵身向小舟上跳将过去") then
	    self:out_boat2()
		return
	 end
	 wait.time(5)
  end)
  end
  sp:unwield_all()
end

function alias:shuitang_shanjianpingdi()
   world.Send("eastup")
	 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2903 then
	   self:finish()
	 elseif roomno[1]==2910 then

		  local seed=math.random(4)
	      local dx={"west","north","east","south"}
		  local d=dx[seed]
	      world.Send(d)
	     local f=function()
           self:shuitang_shanjianpingdi()
	     end
	     f_wait(f,0.3)
	 elseif roomno[1]==2911 then
	     world.Send("westdown")
	     self:finish()
	 elseif roomno[1]==2915 then
	     world.Send("southup")
		 self:finish()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shuitang_shanjianpingdi()
		end
		w:go(2903)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shanjianpingdi_shuitang()
   world.Send("northdown")
	 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2912 then
	   self:finish()
	 elseif roomno[1]==2910 then
	      local seed=math.random(4)
	      local dx={"west","north","east","south"}
		  local d=dx[seed]
	      world.Send(d)

	     local f=function()
           self:shanjianpingdi_shuitang()
	     end
	     f_wait(f,0.3)
	elseif roomno[1]==2911 then
	     world.Send("westdown")
	     self:finish()
	elseif roomno[1]==2915 then
	     world.Send("southup")
	     self:finish()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanjianpingdi_shuitang()
		end
		w:go(2903)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:out_zhulin_shuitang()
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])

	 if roomno[1]==2910 then
          local seed=math.random(4)
	      local dx={"west","north","east","south"}
		  local d=dx[seed]
	      world.Send(d)
	     local f=function()
           self:out_zhulin_shuitang()
	     end
	     f_wait(f,0.3)
	 elseif roomno[1]==2911 then
	     world.Send("westdown")
	     self:finish()
	 elseif roomno[1]==2912 then
	     self:finish()
	 elseif roomno[1]==2915 then
	     world.Send("southup")
	     self:finish()
	 else
	     local f=function()
		local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2912)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:out_zhulin_shanjianpingdi()
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])

	  if roomno[1]==2903 then
	    self:finish()
	  elseif roomno[1]==2910 then

		  local seed=math.random(4)
	      local dx={"west","north","east","south"}
		  local d=dx[seed]
	      world.Send(d)
	     local f=function()
           self:out_zhulin_shanjianpingdi()
	     end
	     f_wait(f,0.3)
	  elseif roomno[1]==2911 then
	     world.Send("westdown")
	     self:finish()
	  elseif roomno[1]==2915 then
	     world.Send("southup")
		 self:finish()
	  else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shuitang_shanjianpingdi()
		end
		w:go(2903)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:enter_zhulin()
  world.Send("northdown")
  world.Send("eastup")
	 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2910 or roomno[1]==2915 or roomno[1]==2911 then
	   self:finish()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2910)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end


function alias:fuyaqianting_situtang()
  world.Send("east")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])

	 if roomno[1]==2917 then
        self:finish()
	 elseif roomno[1]==436 then
			local f
		f=function()
		  self:fuyaqianting_situtang()
		end
		break_npc=break_npc_id("dali guanbing|dali guanbing|dali wujiang")
        self:break_in("dali guanbing|dali guanbing|dali wujiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:fuyaqianting_situtang()
		end
		w:go(436)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:fuyaqianting_sikongtang()
  world.Send("north")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])

	 if roomno[1]==2918 then
        self:finish()
	 elseif roomno[1]==436 then
			local f
		f=function()
		  self:fuyaqianting_sikongtang()
		end
		break_npc=break_npc_id("dali guanbing|dali guanbing|dali wujiang")
        self:break_in("dali guanbing|dali guanbing|dali wujiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:fuyaqianting_sikongtang()
		end
		w:go(436)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:fuyaqianting_simatang()
  world.Send("west")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])

	 if roomno[1]==2919 then
        self:finish()
	 elseif roomno[1]==436 then
			local f
		f=function()
		  self:fuyaqianting_simatang()
		end
		break_npc=break_npc_id("dali guanbing|dali guanbing|dali wujiang")
        self:break_in("dali guanbing|dali guanbing|dali wujiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:fuyaqianting_simatang()
		end
		w:go(436)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:changlemen_dongmenchenglou()
--934 2920
  world.Send("up")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2920 then
        self:finish()
	 elseif roomno[1]==934 then
			local f
		f=function()
		  self:changlemen_dongmenchenglou()
		end
		break_npc=break_npc_id("guan bing|guan bing|wu jiang")
        self:break_in("guan bing|guan bing|wu jiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changlemen_dongmenchenglou()
		end
		w:go(934)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:anyuanmen_beimenchenglou()
--1087 2951
  world.Send("up")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2951 then
        self:finish()
	 elseif roomno[1]==1087 then
		local f
		f=function()
		  self:anyuanmen_beimenchenglou()
		end
		break_npc=break_npc_id("guan bing|guan bing|wu jiang")
        self:break_in("guan bing|guan bing|wu jiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:anyuanmen_beimenchenglou()
		end
		w:go(1087)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:yongningmen_nanmenchenglou()
--215_2934
  world.Send("up")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2934 then
        self:finish()
	 elseif roomno[1]==215 then
		local f
		f=function()
		  self:yongningmen_nanmenchenglou()
		end
		break_npc=break_npc_id("guan bing|guan bing|wu jiang")
        self:break_in("guan bing|guan bing|wu jiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yongningmen_nanmenchenglou()
		end
		w:go(215)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:andingmen_ximenchenglou()
--896 2942
 world.Send("up")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2942 then
        self:finish()
	 elseif roomno[1]==896 then
		local f
		f=function()
		  self:andingmen_ximenchenglou()
		end
		break_npc=break_npc_id("guan bing|guan bing|wu jiang")
        self:break_in("guan bing|guan bing|wu jiang",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:andingmen_ximenchenglou()
		end
		w:go(896)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end


function alias:xixiangchibian_xixiangchibian()
--
 world.Send("north")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2965 then
        self:finish()
	 elseif roomno[1]==685 then
		local f
		f=function()
		  self:xixiangchibian_xixiangchibian()
		end
		break_npc=break_npc_id("hou zi")
        self:break_in("hou zi",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xixiangchibian_xixiangchibian()
		end
		w:go(685)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:changlang_guifang()
 world.Send("east")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2977 then
        self:finish()
	 elseif roomno[1]==2195 then
		local f
		f=function()
		  self:changlang_guifang()
		end
		break_npc=break_npc_id("ya huan")
        self:break_in("ya huan",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changlang_guifang()
		end
		w:go(2195)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:zoulang_xixiangzoulang()
 world.Send("west")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2983 then
        self:finish()
	 elseif roomno[1]==1958 then
		local f
		f=function()
		  self:zoulang_xixiangzoulang()
		end
		break_npc=break_npc_id("zhang songxi")
        self:break_in("zhang songxi",f,true)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zoulang_xixiangzoulang()
		end
		w:go(1958)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:zoulang_dongxiangzoulang()
 world.Send("east")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2985 then
        self:finish()
	 elseif roomno[1]==1958 then
		local f
		f=function()
		  self:zoulang_dongxiangzoulang()
		end
		break_npc=break_npc_id("zhang songxi")
        self:break_in("zhang songxi",f,true)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zoulang_dongxiangzoulang()
		end
		w:go(1958)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:zoulang_liangongfang()
 world.Send("north")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2986 then
        self:finish()
	 elseif roomno[1]==1958 then
		local f
		f=function()
		  self:zoulang_liangongfang()
		end
		break_npc=break_npc_id("zhang songxi")
        self:break_in("zhang songxi",f,true)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zoulang_liangongfang()
		end
		w:go(1958)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:xiaowu_liwu()
 world.Send("enter")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2991 then
        self:finish()
	 elseif roomno[1]==2558 then
		local f
		f=function()
		  self:xiaowu_liwu()
		end
		break_npc=break_npc_id("murong bo")
        self:break_in("murong bo",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaowu_liwu()
		end
		w:go(2558)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end


function alias:dashiwu_dating()
 world.Send("enter")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2998 then
        self:finish()
	 elseif roomno[1]==2914 then
		local f
		f=function()
		  self:dashiwu_dating()
		end
		break_npc=break_npc_id("fan yiweng")
        self:break_in("fan yiweng",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dashiwu_dating()
		end
		w:go(2914)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:dating_houtang()
  world.Send("ask zhi about 绝情谷")
 local b=busy.new()
 b.Next=function()
  world.Send("xian hua")
  world.Send("zuan dao")
  self:finish()
 end
 b:check()
end

function alias:jump_back()
  world.Send("jump back")
  self:finish()
end

function alias:jump_qiaobi()
  world.Send("look ya")
  world.Send("jump qiaobi")
  self:finish()
end

function alias:xiao()
  world.Send("xiao")
  self:finish()
end

function alias:hubian()
   local _R
    _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1648 then
        self:yell_tengkuang()
	 elseif string.find(_R.roomname,"藤筐") then
		local f
		f=function()
		  self:out_tengkuang()
		end
        f_wait(f,5)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:yell_tengkuang()
		end
		w:go(1648)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:out_tengkuang()
  wait.make(function()
    local l,w=wait.regexp("一个番僧用沙哑的声音道：“大轮寺到啦，出来吧。”，话音未落，藤筐已经被稳稳的停住了。$|^(> |)藤筐一歪，似乎要往上升起，你赶忙从藤筐中窜了出来。$",10)
	if l==nil then
	   self:hubian()
	   return
	end
	if string.find(l,"似乎要往上升起，你赶忙从藤筐中窜了出来") then
	   self:yell_tengkuang()
	   return
	end
    if string.find(l,"藤筐已经被稳稳的停住了") then
	   world.Send("out")
	   self:finish()
	   return
	end
	wait.time(10)
  end)
end

function alias:yell_tengkuang()
  wait.make(function()
    world.Send("yell tengkuang")
	world.Send("enter")
	local l,w=wait.regexp("^(> |)藤筐 -.*$|^(> |)什么.*",5)
	if l==nil then
	   self:yell_tengkuang()
	   return
	end
	if string.find(l,"什么") then
	   local w=walk.new()
	   w.walkover=function()
	      self:finish()
	   end
	   w:go(1648)
	   return
	end
	if string.find(l,"藤筐") then
	   self:out_tengkuang()
	   return
	end
 	wait.time(5)
  end)
end


function alias:miaofadian_cangjingge()
  world.Send("southup")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3031 then
        self:finish()
	 elseif roomno[1]==1910 then
		local f
		f=function()
		  self:miaofadian_cangjingge()
		end
		break_npc=break_npc_id("wu seng")
        self:break_in("wu seng",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:miaofadian_cangjingge()
		end
		w:go(1910)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--local p={"ne","se","n","e","sw","e","ne","se","s","se"}
--local p={"n","nw","sw","w","ne","w","s","nw","sw"}
--小朋友不要到那种地方去！！
--塔林_古佛舍利塔
function alias:talin_gufoshelita(again)
--ne;n;nw;sw;w;ne;w;s;nw;sw;n
--open door;w;ne;n;nw;sw;w;ne;w;s;nw;sw;n;enter;u
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3039 then
	   self:finish()
	 elseif roomno[1]==3034  then
          --print("执行1")

		local p={"ne","n","nw","sw","w","ne","w","s","nw","sw"}

        alias.circle_co=coroutine.create(function()

          for _,i in ipairs(p) do
	         world.Send(i)
              self:circle_done("talin_gufoshelita")
	         coroutine.yield()
	      end
	      self:talin_gufoshelita(true)
        end)
		self.maze_step=function()
		  --print("444")
	     local f=function()
	       if again==true then
		    local seed=math.random(8)
		    local dx={"south","north","west","east","northeast","northwest","southeast","southwest"}
		     world.Send(dx[seed])
			 world.Send("east")
			 self:talin_gufoshelita(false)
		   else
			 coroutine.resume(alias.circle_co)
		   end
	     end
		  f_wait(f,0.2)
	   end
	     --print("执行3")
		-- print(self.alias_table["talin_gufoshelita"].is_search)
		  --print("执行5")
	    if self.alias_table["talin_gufoshelita"].is_search==true then

	      self:maze_done()
	   else
	     --print("执行4")
		  self.maze_step()
	   end
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(3039)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end
--3039

--3034 3040

function alias:gufoshelita_talin(again,index,last)
--ne;se;n;e;sw;e;ne;se;s;se;e
--out;d;out;s;ne;se;n;e;sw;e;ne;se;s;se;e
 local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3034 then
	   self:finish()
	 elseif roomno[1]==3039  then

		local p={"ne","se","n","e","sw","e","ne","se","s","se"}

        alias.circle_co=coroutine.create(function()

          for _,i in ipairs(p) do
	         world.Send(i)
              self:circle_done("gufoshelita_talin")
	         coroutine.yield()
	      end
	      self:gufoshelita_talin(true)
        end)

	    self.maze_step=function()
		    local f=function()
	          if again==true then
		        local seed=math.random(8)
		        local dx={"south","north","west","east","northeast","northwest","southeast","southwest"}
			     world.Send(dx[seed])
			     world.Send("east")
			     self:gufoshelita_talin(false)
		      else
				 coroutine.resume(alias.circle_co)
		      end

	        end
	        f_wait(f,0.2)
		end
		--print("why",self.alias_table["gufoshelita_talin"].is_search)
	   if self.alias_table["gufoshelita_talin"].is_search==true then
	      --print("why1")
	      self:maze_done()
	   else
	      --print("why2")
		  self.maze_step()
	   end
	 elseif roomno[1]==3040 then

		   if again==false then
		      index=1

		   elseif index==nil then
		       index=1
			--else
			   --[[if index>9 then
			      index=1
				  --加入8随机
				  local _r=math.random(9)

				  --local dx={"south","north","west","east","northeast","northwest","southeast","southwest"}
				  local dx={"ne","se","n","e","sw","e","ne","se","s","se"}
				  world.Send(dx[_r])
				  print("随机方向","->",dx[_r])
				  self:gufoshelita_talin(true,index)
				  return
			   end]]
		   end
		  -- local p={"ne","se","n","e","sw","e","ne","se","s","se"}
		   --local p={"south","north","west","east","northeast","northwest","southeast","southwest"}
		   local p={"ne","se","n","e","sw","e","ne","se","s","se"}
		       if last==nil then
			      last=1
			   end
			   if index>last then
			       last=last+1
				   index=1
			   end
			   if last>9 then
			      world.Execute("s;s;e;s;se;se;;w;n")
			       last=1
			   end
		   print(index,"->",p[index]," last:",last)
		   index=index+1
			world.Send(p[index])
			self:gufoshelita_talin(true,index,last)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(3034)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:majiu_houshanxiaojing()
  world.Send("move gancao")
  world.Send("zuan dong")
  self:finish()
end

function alias:kantree()
    world.Send("wield jian")
	world.Send("wield sword")
	world.Send("kan tree")
	wait.make(function()
	  local l,w=wait.regexp("(> |)你拿起.*对着灌木丛砍了起来，一转眼就钻了进去。$|^(> |)你拿什么砍？$|^(> |)你手上这件兵器无锋无刃，如何能砍树啊？$",3)
	  if l==nil then
		 self:kantree()
		 return
	  end
	  if string.find(l,"你手上这件兵器无锋无刃，如何能砍树啊") then
	     local sp=special_item.new()
		 sp.cooldown=function()
		   local f=function()
		      print("convert weapon")
		      self:houshanxiaolu_guanmucong()
		   end
		  self.weapon_exist=false
		  local error_deal=function()
		     self:buy_weapon(f,462,"blade")
		  end
		   world.Send("i")
		    self:auto_wield_weapon(f,error_deal)
	       world.Send("set look 1")
		 end
		 sp:unwield_all()
		 return
	  end
	  if string.find(l,"你拿什么砍") then
	     local f=function() self:houshanxiaolu_guanmucong() end
		  local error_deal=function()
		     self:buy_weapon(f,462,"blade")
		  end
		local sp=special_item.new()
		 sp.cooldown=function()
		    self.weapon_exist=false
		    world.Send("i")
		    self:auto_wield_weapon(f,error_deal)
	        world.Send("set look 1")
		 end
		 sp:unwield_all()
		 return
	  end
	  if string.find(l,"一转眼就钻了进去") then
	     self:houshanxiaolu_guanmucong()
		return
	  end
	  wait.time(3)
	end)
end

function alias:houshanxiaolu_guanmucong()
  local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3049 then
	   self:finish()
	 elseif roomno[1]==3047 then
	     self:kantree()
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:houshanxiaolu_guanmucong()
		end
		w:go(3047)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:guamucong_dongkou()
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3051 then
	   self:finish()
	 elseif roomno[1]==3050 then
	   local f=function()
	     world.Send("yue dongkou")
	     world.Send("yue tan")
         self:guamucong_dongkou()
	   end
	   f_wait(f,0.2)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:guamucong_dongkou()
		end
		w:go(3050)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

local guamucong_step_count=0
function alias:guanmucong_out()
    local mastername=world.GetVariable("mastername") or ""
	if mastername=="孤鸿子" then
	    world.Send("ed")
		self:finish()
	end
    if guamucong_step_count>=15 then
      sj.World_Init=function()
	     guamucong_step_count=0
         self:guanmucong_out()
      end
	  sj.quit()
	end
    local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3050 then
	   self:finish()
	 elseif roomno[1]==3049 then
	  local f=function()
	    world.Send("northeast")
		world.Send("yun qi")
	    world.Send("yun refresh")
        self:guanmucong_out()
	   end
	   f_wait(f,0.2)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:guanmucong_out()
		end
		w:go(3049)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
end

function alias:movestone()
  world.Send("move stone")
  world.Send("northdown")
  self:finish()
end

function alias:laofang_dilao()


  local b=busy.new()
  b.Next=function()
	world.Send("give 5 silver to yu zu")
    world.Send("wear all")
	world.Send("south")
	 local _R
    _R=Room.new()
    _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2749 then
	    self:finish()
	 elseif roomno[1]==3057 then
	   local f=function()
           self:laofang_dilao()
	   end
	   f_wait(f,0.2)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:finish()
		end
		w:go(2749)
		end
		self:redo(f)
	 end
   end
  _R:CatchStart()
  end
  b:check()
end

function alias:changlang_chufang()
   world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3059 then
        self:finish()
	 elseif roomno[1]==2196 then
		local f
		f=function()
		  self:changlang_chufang()
		end
		break_npc=break_npc_id("jia ding")
        self:break_in("jia ding",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changlang_chufang()
		end
		w:go(2196)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:xiaoting_chufang()
   world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3058 then
        self:finish()
	 elseif roomno[1]==1979 then
		local f
		f=function()
		  self:xiaoting_chufang()
		end
		break_npc=break_npc_id("a bi")
        self:break_in("a bi",f)
	 else
		local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaoting_chufang()
		end
		w:go(1979)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:sajiafatang_fatangerlou()
   world.Send("up")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3060 then
        self:finish()
	 elseif roomno[1]==2270 then
		local f
		f=function()
		  self:sajiafatang_fatangerlou()
		end
		break_npc=break_npc_id("zayi lama")
        self:break_in("zayi lama",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:sajiafatang_fatangerlou()
		end
		w:go(2270)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:jiechiyuan_jingshi()
   world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3065 then
        self:finish()
	 elseif roomno[1]==1919 then
		local f
		f=function()
		  self:jiechiyuan_jingshi()
		end
		break_npc=break_npc_id("dadian dashi")
        self:break_in("dadian dashi",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jiechiyuan_jingshi()
		end
		w:go(1919)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--铁琴居 _卧室
--He taichong
function alias:tieqingju_woshi()
   world.Execute("open door;west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3074 then
        self:finish()
	 elseif roomno[1]==2830 then
		local f
		f=function()
		  self:tieqingju_woshi()
		end
		break_npc=break_npc_id("he taichong")
        self:break_in("he taichong",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:tieqingju_woshi()
		end
		w:go(2830)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:block_eastup()
   local gender=world.GetVariable("gender")
   if gender=="女性" then
     local b=busy.new()
	 b.interval=0.3
	 b.Next=function()
	  world.Send("eastup")
      self:finish()
	 end
	 b:check()
   else
      world.Send("eastup")
	  self:finish()
   end
end

function alias:block_westup()
   local gender=world.GetVariable("gender")
   if gender=="女性" then
     local b=busy.new()
	 b.interval=0.3
	 b.Next=function()
	  world.Send("westup")
      self:finish()
	 end
	 b:check()
   else
      world.Send("westup")
	  self:finish()
   end
end

function alias:shushang()
     local pfm=world.GetVariable("pfm") or ""
	 pfm=convert_pfm(pfm)
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
    world.Send("kill ju mang")
	local f=function()
	  world.Send("down")
	  self:finish()
	end
    f_wait(f,0.8)
end
--去神龙岛
function alias:wait_shangan()
--> 大船慢慢靠向陸地，你整理了下衣冠便缓缓走了下去。
  wait.make(function()
     local l,w=wait.regexp("^(> |)大船慢慢靠向陸地，你整理了下衣冠便缓缓走了下去。$",5)
	 if l==nil then
	    self:wait_shangan()
	    return
	 end
	 if string.find(l,"大船慢慢靠向陸地") then
	    self:finish()
	    return
	 end
  end)
end

function alias:dadukou_shenlongdao()
   local w=walk.new()
   w.walkover=function()
     world.Send("yell 洪教主洪福齐天")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)只见一艘大船已经驶进海口，你慢慢走了进去。$",5)
		if l==nil then
		   self:dadukou_shenlongdao()
		   return
		end
		if string.find(l,"只见一艘大船已经驶进海口") then
		    self:wait_shangan()
		   return
		end
	 end)
   end
   w:go(767) --1767
end

--离开神龙岛
function alias:shenlongdao_dadukou()
	local w
	w=walk.new()
	w.walkover=function()
	  wait.make(function()
	    world.Send("ask lu gaoxuan about 令牌")
		local player_name=world.GetVariable("player_name")
		local l,w=wait.regexp("^(> |)陆高轩给"..player_name.."一块令牌。$|^(> |)你不是已经有令牌了么？$",5)
		if l==nil then
		   self:shenlongdao_dadukou()
		   return
		end
		if string.find(l,"一块令牌") or string.find(l,"你不是已经有令牌了") then
		  local b=busy.new()
		  b.interval=0.3
		  b.Next=function()
		    self:give_lingpai2()
		  end
		  b:check()
		  return
		end
		wait.time(5)
	  end)
	end
	w:go(1772)
end

function alias:wait_chuan2()
   wait.make(function()
     local l,w=wait.regexp("你轻轻一跃，上了小船",20) --等待20秒
	 if l==nil then
	    print("等待20秒没有响应!")
	    self:give_lingpai2()
	    return
	 end
	if string.find(l,"你轻轻一跃，上了小船") then
		  world.Send("order 去入海口")
		  self:order_chuan()
		  return
	end
     wait.time(20)
   end)
end

function alias:give_lingpai2()
   local w
   w=walk.new()
   w.walkover=function()
       wait.make(function()
        world.Send("give ling pai to chuan fu")
		local l,w=wait.regexp("^(> |)你轻轻一跃，上了小船。$|^(> |)你身上没有这样东西。$|^(> |)对方不接受这样东西。$|^(> |)船夫说道：「现在没船，请等一会吧。」$",5)
		if l==nil then
		  self:give_lingpai2()
		  return
		end
		if string.find(l,"你身上没有这样东西") or string.find(l,"对方不接受这样东西") then
		   self:shenlongdao_dadukou()
		   return
		end
		if string.find(l,"你轻轻一跃，上了小船") then
		  world.Send("order 去入海口")
		  self:order_chuan()
		  return
		end
		if string.find(l,"现在没船，请等一会吧") then
		  self:wait_chuan2()
		  return
		end
		wait.time(5)
	   end)
   end
   w:go(1767)
end

--[[function alias:longshuyuan_shibanlu()

   local p={"out","south","south","south","south","south","east","south","south","west","south","south","north","south","south","south"}
      alias.circle_co=coroutine.create(function()
      --print("启动3")
        for _,i in ipairs(p) do
	      world.Send(i)

          self:circle_done("longshuyuan_shibanlu")
	      coroutine.yield()
	    end
	    local _R
        _R=Room.new()
        _R.CatchEnd=function()
           local count,roomno=Locate(_R)
	       print("当前房间号",roomno[1])
	       if roomno[1]==2280 then
	         self:finish()
	       elseif roomno[1]==3055 or roomno[1]==3056 then
	         self:longshuyuan_shibanlu()
	       else
	         local f=function()
               local w
		       w=walk.new()
		       w.user_alias=self
		       w.walkover=function()
		        self:finish()
		       end
		       w:go(2280)
		     end
		    self:redo(f)
		 end
	    end
        _R:CatchStart()
	 end)
  --print("启动2")
   coroutine.resume(alias.circle_co)
end

function alias:shibanlu_longshuyuan()
  -- world.Execute()
   local p={"north","north","north","west","west","north","north","north","west","west","west","enter"}
   alias.circle_co=coroutine.create(function()
      --print("启动3")
      for _,i in ipairs(p) do
	     world.Send(i)
         self:circle_done("shibanlu_longshuyuan")
	     coroutine.yield()
	  end
	  local _R
       _R=Room.new()
       _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	     print("当前房间号",roomno[1])
	    if roomno[1]==3082 then
	      self:finish()
	    elseif roomno[1]==3055 or roomno[1]==3056 then
		  self:shibanlu_longshuyuan()
	    else
	      local f=function()
          local w
	  	   w=walk.new()
		   w.user_alias=self
		   w.walkover=function()
		    self:shibanlu_longshuyuan()
		   end
		   w:go(3056)
		 end
		 self:redo(f)
	    end
       end
       _R:CatchStart()
   end)
  --print("启动2")
   coroutine.resume(alias.circle_co)

end]]

function alias:songlin_longshuyuan()
  -- world.Execute()
   local p={"north","north","north","west","west","north","north","north","west","west","west"}
   alias.circle_co=coroutine.create(function()
      --print("启动3")
      for _,i in ipairs(p) do
	     world.Send(i)
		 world.Send("set action 松树林")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)你正走着，突然发现前面有一间小木屋,你不由的走了过去。$|^(> )你正走着，透过树枝，隐约发现前面有片空地，你拨开树枝钻了过去。$|^(> |)设定环境变量：action \\= \\\"松树林\\\"",5)
		    if l==nil then
			     self:circle_done("songlin_longshuyuan")
				 return
            end
            if string.find(l,"一间小木屋") then
			   self:finish()
			   return
			end
			if string.find(l,"设定环境变量") then
			   self:circle_done("songlin_longshuyuan")
			   return
			end
			if string.find(l,"你正走着，透过树枝，隐约发现前面有") then
               world.Send("w")
			   self:circle_done("songlin_longshuyuan")
		       return
			end
		 end)

	     coroutine.yield()
	  end
	  local _R
       _R=Room.new()
       _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	     print("当前房间号",roomno[1])
	    if roomno[1]==3082 then
	      self:finish()
	    elseif roomno[1]==3055 or roomno[1]==3056 then
		  self:songlin_longshuyuan()
	    else
	      local f=function()
          local w
	  	   w=walk.new()
		   w.user_alias=self
		   w.walkover=function()
		    self:songlin_longshuyuan()
		   end
		   w:go(3056)
		 end
		 self:redo(f)
	    end
       end
       _R:CatchStart()
   end)
  --print("启动2")
   coroutine.resume(alias.circle_co)

end

function alias:songlin_shibanlu()
     local p={"south","west","south","west","south","west","south","south","south","south","south","south","south"}
      alias.circle_co=coroutine.create(function()
      --print("启动3")
        for _,i in ipairs(p) do
	      world.Send(i)
		  world.Send("set action 松树林")
          wait.make(function()
		    local l,w=wait.regexp("^(> |)你筋疲力尽,终于走出了松林。$|^(> )你正走着，透过树枝，隐约发现前面有片空地，你拨开树枝钻了过去。$|^(> |)设定环境变量：action \\= \\\"松树林\\\"",5)
		    if l==nil then
			     self:circle_done("songlin_shibanlu")
				 return
            end
            if string.find(l,"你筋疲力尽") then
			   self:finish()
			   return
			end
			if string.find(l,"设定环境变量") then
			   self:circle_done("songlin_shibanlu")
			   return
			end
			if string.find(l,"你正走着，透过树枝，隐约发现前面有") then
               world.Send("w")
			   self:circle_done("songlin_shibanlu")
		       return
			end
		  end)

	      coroutine.yield()
	    end
	    local _R
        _R=Room.new()
        _R.CatchEnd=function()
           local count,roomno=Locate(_R)
	       print("当前房间号",roomno[1])
	       if roomno[1]==2280 then
	         self:finish()
	       elseif roomno[1]==3055 or roomno[1]==3056 then
	         self:songlin_shibanlu()
	       else
	         local f=function()
               local w
		       w=walk.new()
		       w.user_alias=self
		       w.walkover=function()
		        self:finish()
		       end
		       w:go(2280)
		     end
		    self:redo(f)
		 end
	    end
        _R:CatchStart()
	 end)
  --print("启动2")
   coroutine.resume(alias.circle_co)
end

function alias:zuanshulin()
  world.Send("zuan shulin")
  wait.make(function()
    local l,w=wait.regexp("^(> |)你打听清楚再钻吧！$|^(> |)什么.*$|^(> |)你拨开树枝，一弯腰，钻了进去。$",5)
	if l==nil then
	   self:zuanshulin()
	   return
	end
	if string.find(l,"什么") then
	   self:finish()
	   return
	end
	if string.find(l,"你拨开树枝，一弯腰，钻了进去") then
	   self:finish()
	   return
	end
	if string.find(l,"你打听清楚再钻吧") then
	   local w2=walk.new()
	   w2.walkover=function()
	       world.Send("ask caiyao daozhang about 只是")
	       local b=busy.new()
		   b.interval=0.5
		   b.Next=function()

			 w2.walkover=function()
			    world.Send("ask tao hua about rumor")
				b.Next=function()
				   w2.walkover=function()
				     self:zuanshulin()
				   end
				   w2:go(2638)
				end
			    b:check()
			 end
			 w2:go(1960)
		   end
		   b:check()
	   end
	   w2:go(2028)

	   return
	end
  end)
end

--那处强盗出没，比较危险，还是走大道吧。
function alias:special_east()
   print("特殊")
   world.Send("east")
   wait.make(function()
      local l,w=wait.regexp("^(> |)那处强盗出没，比较危险，还是走大道吧。$",0.5)
      if l==nil then
	       self:finish()
	     return
	  end
	  if string.find(l,"那处强盗出没") then
--338-211
        world.Execute("south;south;south;south;south;southwest;southwest;northwest;northwest;northwest")
        wait.time(0.8)
--安远门 211 1087
        world.Execute("north;north;north;north;north;north;north;north;north;north;north;north")
        wait.time(0.8)
--1087 1347
        world.Execute("north;north;north;northeast;northup;northeast;northdown;northeast;north;southeast;southeast;southeast;south;southwest")
		self:finish()
		return
	  end
   end)
end


function alias:guangchang_shanmendian()
 --壮年僧人沉下脸来，说道：戒律院主持玄寂大师请师兄火速去戒律院陈述此行过犯。
 --执戒僧说道：「渡夜，戒律院玄寂大师请你去陈述此次下山经过 ！」
  local party=world.GetVariable("party")
  if party~="少林派" then
    self:knockgatenorth()
  else
	world.Send("knock gate")
	world.Send("north")
	world.Send("set action 回寺")
	world.Send("unset action")
    wait.make(function()
       local l,w=wait.regexp("^(> |)壮年僧人沉下脸来，说道：戒律院主持玄寂大师请师兄火速去戒律院陈述此行过犯。$|^(> |)设定环境变量：action \\= \\\"回寺\\\"",5)
	   if l==nil then
	      self:guangchang_shanmendian()
	      return
	   end
	   if string.find(l,"戒律院主持玄寂大师请师兄火速去戒律院陈述此行过犯") then
	      self:jielvyuan()
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
	    local _R
	    _R=Room.new()
	    _R.CatchEnd=function()
		 local count,roomno=Locate(_R)
	      print("当前房间号",roomno[1])
	        if roomno[1]==780 then
	          self:finish()
	        elseif roomno[1]==781 then
	          self:guangchang_shanmendian()
			else
			   local f=function()
			  local w
			  w=walk.new()
			  w.user_alias=self
			  w.walkover=function()
			     self:guangchang_shanmendian()
			  end
			  w:go(781)
			  end
			  self:redo(f)
	        end
		 end
	     _R:CatchStart()
	   end
	end)
  end
end

--戒律院
function alias:jielvyuan()
  --print("少林戒律院")
  world.Send("say 色既是空,空既是色.")
  --world.Send("say 酒肉穿肠过！！")
  local w=walk.new()
  w.walkover=function()
    wait.make(function()
	 local player_name=world.GetVariable("player_name")
     local l,w=wait.regexp("^(> |)玄寂盯着你看了半饷，说道："..player_name.."，你惩恶扬善，锄暴安良，当得表彰，$",5)
	 if l==nil then
	    local _R=Room.new()
		  _R.CatchEnd=function()
		 local count,roomno=Locate(_R)
	        print("当前房间号",roomno[1])
	        if roomno[1]==3078 then
	           local w
		        w=walk.new()
		        w.walkover=function()
			       self:finish()
		        end
		        w:go(780)
			else
				self:jielvyuan()
	        end
		 end
	     _R:CatchStart()
	    return
	 end
	 if string.find(l,"你惩恶扬善，锄暴安良，当得表彰") then
	     local w
		  w=walk.new()
		  w.walkover=function()
			 self:finish()
		  end
		  w:go(780)
	    return
	 end
	 wait.time(5)
	 end)
  end
  w:go(3078)
end

function alias:fanyinge_fotang()
  world.Send("open door")
  world.Send("northwest")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3105 then
        self:finish()
	 elseif roomno[1]==2265 then
		local f
		f=function()
		  self:fanyinge_fotang()
		end
		break_npc=break_npc_id("hufa lama")
        self:break_in("hufa lama",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:fanyinge_fotang()
		end
		w:go(2265)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shanjian_longtan()
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3109 then
        self:finish()
	 elseif roomno[1]==3108 then
	    local dx
	    if string.find(_R.description,"北下方") then
		   dx="northdown"
		elseif string.find(_R.description,"北上方") then
		   dx="northup"
		elseif string.find(_R.description,"东北方") then
		   dx="northeast"
		elseif string.find(_R.description,"西北方") then
		   dx="northwest"
	    elseif string.find(_R.description,"北方") then
		   dx="north"

        elseif string.find(_R.description,"南上方") then
		   dx="southup"
		elseif string.find(_R.description,"南下方") then
		   dx="southdown"
        elseif string.find(_R.description,"东南方") then
		   dx="southeast"
		elseif string.find(_R.description,"西南方") then
		   dx="southwest"
		elseif string.find(_R.description,"南方") then
		   dx="south"

		elseif string.find(_R.description,"东方") then
		   dx="east"
		elseif string.find(_R.description,"东上方") then
		   dx="eastup"
		elseif string.find(_R.description,"东下方") then
		   dx="eastdown"
		elseif string.find(_R.description,"西方") then
		   dx="west"
		elseif string.find(_R.description,"西上方") then
		   dx="westup"
		elseif string.find(_R.description,"西下方") then
		   dx="westdown"
		end
		world.Send(dx)
		self:shanjian_longtan()
        --"这是天山里的一个山涧，旁边是由于上面的山泉常年累月冲击形成的一个很深的水潭。这里周围长满了灌木，北下方似乎能走过去，你不由的加快了步伐。"
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanjian_longtan()
		end
		w:go(3108)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shidao_xiaoyaodong()
 world.Send("kill chuchen zi")
  world.Send("give 1 coin to caihua zi")
  world.Send("enter")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3110 then
        self:finish()
	 elseif roomno[1]==2366 then
		local f
		f=function()
		  self:shidao_xiaoyaodong()
		end
		break_npc=break_npc_id("caihua zi")
        self:break_in("caihua zi",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shidao_xiaoyaodong()
		end
		w:go(2366)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:keting_xiangfang()
  world.Send("east")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3113 then
        self:finish()
	 elseif roomno[1]==2661 then
		local f
		f=function()
		  self:keting_xiangfang()
		end
		break_npc=break_npc_id("zhong wanchou")
        self:break_in("zhong wanchou",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:keting_xiangfang()
		end
		w:go(2661)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:yamendating_yamenzhengting()
 world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1078 then
	   self:finish()
	 elseif roomno[1]==1077 then
        --npc block
		local f
		f=function()
		  self:yamendating_yamenzhengting()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	     local f=function()
        local w
		w.user_alias=self
		w=walk.new()
		w.walkover=function()
		   self:yamendating_yamenzhengting()
		end
		w:go(1077)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shanbi_huacong()
   world.Send("bo huacong")
   world.Send("right")
   self:finish()
end

function alias:qianting_miaojiazhuang()
   world.Send("east")
   local b=busy.new()
   b.Next=function()
      self:finish()
   end
   b:check()
end

function alias:miaojiazhuang_qianting()
   world.Send("west")
   local b=busy.new()
   b.Next=function()
      self:finish()
   end
   b:check()
end


function alias:maowu_hetang()
   world.Send("enter tongdao")
   self:finish()
end

function alias:hetang_maowu()
   world.Send("enter tongdao")
   self:finish()
end

function alias:dierzhijie_shandong()
  world.Send("enter")
 local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3148 then
        self:finish()
	 elseif roomno[1]==2775 then
		local f
		f=function()
		  self:dierzhijie_shandong()
		end
		break_npc=break_npc_id("huang lingtian|ling zhentian")--黄令天*|凌震天
        self:break_in("huang lingtian|ling zhentian",f)
	 else
	     local f=function()
	    local w
		w.user_alias=self
		w=walk.new()
		w.walkover=function()
		   self:dierzhijie_shandong()
		end
		w:go(2775)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--1425 3152
function alias:changzhouyayi_fuyazhenting()
   world.Send("west")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3152 then
        self:finish()
	 elseif roomno[1]==1425 then
		local f
		f=function()
		  self:changzhouyayi_fuyazhenting()
		end
		break_npc=break_npc_id("ya yi")
        self:break_in("ya yi",f)
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:changzhouyayi_fuyazhenting()
		end
		w:go(1425)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--ne;n;nw;sw;w;ne;w;s;nw;sw;n;enter;u 进去
--ne;se;n;e;sw;e;ne;se;s;se;e;e;e;s;s 出来

--nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n 竹林-达摩洞
--[[function alias:zhulin_damodong()

  --world.Execute("sw;se;n;s;w;e;w;e;e;s;w;n;nw;n")
                 --nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==4058 then --3171
        self:finish()
	 elseif roomno[1]==3172 or roomno[1]==1753 then

	     local dx={"southwest","southeast","north","south","west","east","west","east","east","south","west","north","northwest"} --,"north"
	       alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do
			  print(j.."/14 方向:",d)
		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("走到底结束")
			alias.co=nil
		    self:zhulin_damodong()
		 end)
		self:songlin_check()
		--self:zhulin_damodong()
	 else
	    local w
		w=walk.new()
		w.walkover=function()
		   self:zhulin_damodong()
		end
		w:go(1753)
	 end
   end
   _R:CatchStart()

end]]


local zhulin_count=0
function alias:zhulin_damodong()

  --world.Execute("sw;se;n;s;w;e;w;e;e;s;w;n;nw;n")
                 --nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n
   local _R
   _R=Room.new()
    zhulin_count=zhulin_count+1
	   local n=zhulin_count
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==4077 then --3171
	      world.Send("north")
	      zhulin_count = 0
        self:finish()
	 elseif roomno[1]==4058 then
	    self:finish()
   elseif roomno[1]==3171  then
        zhulin_count = 0
        self:finish()
   elseif roomno[1]==3172  then
        world.Execute("nw;sw;se;n;s;w;e;w;e;e;s;w;n;nw;n;out")
        self:zhulin_damodong()
   elseif roomno[1]==4076  then
        zhulin_count = 0
        local dx={"southeast","north","south","west","east","west","east","east","south","west","north","northwest"} --,"north"

		alias.circle_co=coroutine.create(function()
          --print("启动3")
          for j,i in ipairs(dx) do
			print(j.."/13 方向:",i)
	       world.Send(i)
           self:circle_done("zhulin_damodong")
	       coroutine.yield()
	      end
	      self:zhulin_damodong()
        end)
		coroutine.resume(alias.circle_co)
	     --[[  alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do

		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("走到底结束")
			alias.co=nil
		    self:zhulin_damodong()
		 end)
		self:songlin_check()]]
	 elseif roomno[1]==1753 then
       zhulin_count = 0
	     local dx={"southwest","southeast","north","south","west","east","west","east","east","south","west","north","northwest"} --,"north"

		 alias.circle_co=coroutine.create(function()
          --print("启动3")
          for j,i in ipairs(dx) do
			print(j.."/14 方向:",i)
	       world.Send(i)
           self:circle_done("zhulin_damodong")
	       coroutine.yield()
	      end
	      self:zhulin_damodong()
        end)
		coroutine.resume(alias.circle_co)

	   --[[    alias.co=coroutine.create(function()
		   local d
	        for j,d in ipairs(dx) do
			  print(j.."/14 方向:",d)
		      world.Send(d)
              self:songlin_check()
		    --end
			--b:check()
			  coroutine.yield()
	        end
			print("走到底结束")
			alias.co=nil
		    self:zhulin_damodong()
		 end)
		self:songlin_check()]]
		--self:zhulin_damodong()
	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zhulin_damodong()
		end
		w:go(1753)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

local ruxiaofu_count=0
function alias:ruxiaofu()
	local w=walk.new()
	w.walkover=function()
	      local pfm=world.GetVariable("pfm") or ""
		  pfm=convert_pfm(pfm)
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
		world.Send("kill ren feiyan")
		wait.make(function()
		   local l,w=wait.regexp("^(> |)任飞燕「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",30)
		   if l==nil then
			  self:ruxiaofu()
			  return
		   end
		   if string.find(l,"挣扎着抽动了几下就死了") then
		      local b=busy.new()
			  b.interval=0.5
			  b.Next=function()
		        world.Send("get silver from corpse")
				world.Send("get jin chai from corpse")
			    self:xiaofudamen_xiaofudating()
			  end
			  b:check()
		      return
		   end
		   if string.find(l,"这里没有这个人") then
		      ruxiaofu_count=ruxiaofu_count+1
			  if ruxiaofu_count>5 then
			     print("尝试超过5次放弃")
				 self:break_in_failure()
				 return
			  end
		      local f=function()
			     self:ruxiaofu()
			  end
		      f_wait(f,5)
		   end
        end)
	end
	w:go(764)
end

function alias:xiaofudamen_xiaofudating()
  world.Send("give jin chai to zhang ma")
  world.Send("north")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3177 then
        self:finish()
	 elseif roomno[1]==769 then

	  exps=tonumber(world.GetVariable("exps")) or 0 --变量

        if defeat_guard("ren feiyan",exps) then
		 --真
		    ruxiaofu_count=0
		    self:ruxiaofu()
		else
		  --假
		   self.break_in_failure()
		end

	 else
	     local f=function()
	    local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xiaofudamen_xiaofudating()
		end
		w:go(769)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--126 2766
function alias:bingying_wuqiku()
   world.Send("south")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==2766 then
        self:finish()
	 elseif roomno[1]==126 then
		local f
		f=function()
		  self:bingying_wuqiku()
		end
		break_npc=break_npc_id("guan bing")
        self:break_in("guan bing",f)
	 else
	    local w
		w=walk.new()
		w.walkover=function()
		   self:bingying_wuqiku()
		end
		w:go(126)
	 end
   end
   _R:CatchStart()
end

-- 进入苗疆 您已经连续玩了六小时五十六分十六秒。
--
--[[dian fire

你点燃了火折，借着光亮你看到洞的四壁全是树藤，
树藤的空隙中布满了雪白的蜘蛛网。
>
yao shuteng
你轻轻摇晃树藤，忽然掉下一只雪蛛。
>
l
山洞 -
    这个山洞里黑漆漆的，四下里伸手不见五指。仔细看去，隐隐约约可以看
到四壁上爬满了树藤（shuteng）。 树藤间仿佛有什么东西发出声音，你不由
心生惧意。
    这里唯一的出口是 out。
  雪蛛(Xue zhu)
>
hp

·精血· 3520 /  3520 (100%)  ·精力· 5133 /  5133(5236)
·气血· 9075 /  9075 (100%)  ·内力·23906 / 12487(+1)
·戾气· 17,640           ·内力上限·13395 / 15609
·食物·  70.00%              ·潜能·  458 /  539
·饮水·  66.25%              ·经验· 8,459,185 (97.80%)
>
fight zhu

你大喝一声，开始对雪蛛发动攻击！

看起来雪蛛想杀死你！
雪蛛
不在危险名单中: 雪蛛
>
你跃起在半空，双手急挥，中指连弹，「弹指惊雷」铺天盖地般向雪蛛涌去！
雪蛛被你点中了「内关穴」，内息大乱！
你手指微动，又点中了雪蛛的「神风穴」！
雪蛛只觉得头微微晕眩，精神不能集中！
结果只听见雪蛛一声惨嚎，手指已在它的头部对穿而出，鲜血溅得满地！！
( 雪蛛已经陷入半昏迷状态，随时都可能摔倒晕去。 )

雪蛛挣扎了几下，一个不稳晕倒过去。


雪蛛神志迷糊，脚下一个不稳，倒在地上昏了过去。

get zhu
你将雪蛛扶了起来背在背上。
>
l]]
--2351 fire

--3201 山洞

function alias:shanjiao_shanlu()
--虚拟路径

   -- 杀苗疆女弟子
   world.Send("northup")

   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3157 then
	    self:finish()
	 elseif roomno[1]==366 then
        --npc block
		local f
		f=function()
		  self:shanjiao_shanlu()
		end
		break_npc=break_npc_id("dizi")
        self:break_in("dizi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:shanjiao_shanlu()
		end
		w:go(366)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()

end



--716	3880	chuwujian_cangjinglou
function alias:chuwujian_cangjinglou()
   world.Send("up")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3880 then
	    self:finish()
	 elseif roomno[1]==716 then
        --npc block
		local f
		f=function()
		  self:chuwujian_cangjinglou()
		end
		break_npc=break_npc_id("shitai")
        self:break_in("shitai",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:chuwujian_cangjinglou()
		end
		w:go(716)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()

end


--光佛宝殿 松树院    nd 1616 3881
--本因大师(Benyin dashi)
function alias:guangfobaodian_songshuyuan()
   world.Send("northdown")

   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3881 then
	    self:finish()
	 elseif roomno[1]==1616 then
        --npc block
		local f
		f=function()
		  self:guangfobaodian_songshuyuan()
		end
		break_npc=break_npc_id("benyin dashi")
        self:break_in("benyin dashi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:guangfobaodian_songshuyuan()
		end
		w:go(1616)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()

end

--荡天门-休息室
function alias:dangtianmen_xiuxishi()
    world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==4050 then
	   self:finish()
	 elseif roomno[1]==1619 then
        --npc block
		local f
		f=function()
		  self:dangtianmen_xiuxishi()
		end
		break_npc=break_npc_id("chanshi|wu seng|wu seng")
        self:break_in("chanshi|wu seng|wu seng",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dangtianmen_xiuxishi()
		end
		w:go(1619)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--
function alias:yitiantulong()
   local q=quest.new()
   q.quest_over=function()
      self:finish()
   end
   q:yitiantulong()
end

function alias:zuan()
   world.Send("use fire")
   local f=function()
     world.Send("zuan")
     self:finish()
   end
   f_wait(f,5)
end

function alias:zhenting_houmen()
  --1549 south 1552
    world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1552 then
	   self:finish()
	 elseif roomno[1]==1549 then
        --npc block
		local f
		f=function()
		  self:zhenting_houmen()
		end
		break_npc=break_npc_id("guan jia")
        self:break_in("guan jia",f)
	 else
	    local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zhenting_houmen()
		end
		w:go(1549)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--证道院
function alias:zhendaoyuan_chanfang()
  --1549 south 1552
    world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==840 then
	   self:finish()
	 elseif roomno[1]==839 then
        --npc block
		local f
		f=function()
		  self:zhendaoyuan_chanfang()
		end
		break_npc=break_npc_id("xuansheng dashi")
        self:break_in("xuansheng dashi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:zhendaoyuan_chanfang()
		end
		w:go(839) end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--证道院
function alias:xilianwuchang_shibanlu()
  --1549 south 1552
    world.Send("west")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==3985 then
	   self:finish()
	 elseif roomno[1]==1627 then
        --npc block
		local f
		f=function()
		  self:xilianwuchang_shibanlu()
		end
		break_npc=break_npc_id("chanshi")
        self:break_in("chanshi",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xilianwuchang_shibanlu()
		end
		w:go(1627) end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:xidajie_shouxihujiulou()

      world.Send("north")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==109 then
	     self:finish()
	   elseif roomno[1]==108 then
		  local f=function()
		    self:xidajie_shouxihujiulou()
		  end
		  f_wait(f,10)
	   else

		local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:xidajie_shouxihujiulou()
		end
		w:go(108)
		end
		self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:xidajie_shoushidian()

      world.Send("south")
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==111 then
	     self:finish()
	   elseif roomno[1]==108 then
		  local f=function()
		    self:xidajie_shoushidian()
		  end
		  f_wait(f,10)
	   else

		local f=function()
          local w
	  	  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		   self:xidajie_shoushidian()
		  end
		  w:go(108)
		end
		 self:redo(f)
	    end
       end
       _R:CatchStart()
end

function alias:duanyaping_yading()
	self:noway()
    --self:finish()
end

--默认迷宫处理函数
--job迷宫处理接口函数
function alias:maze_done()
     print("默认迷宫函数")
    self.maze_step()
end

function alias:huigong()
	world.Send("huigong")

	local b=busy.new()
	 b.interval=0.9
	b.Next=function()
      self:finish()
	end
	b:check()
end

function alias:push_door()
   --print("why")
   world.Send("push door")
   local b=busy.new()
   b.interval=0.9
		 b.Next=function()
	       self:finish()
	end
   b:check()
end
function alias:climb_shanlu()
   --print("why")
   world.Send("climb 山路")
   local b=busy.new()
   b.interval=0.9
		 b.Next=function()
	       self:finish()
	end
   b:check()
end

function alias:siguoya_jiashanbi()
    world.Send("enter")
    local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==4986 then
	     self:finish()
	   elseif roomno[1]==1537 then
		  local f=function()
		    self:siguoya_jiashanbi()
		  end
		  f_wait(f,5)
	   else

		local f=function()
          local w
	  	  w=walk.new()
		  w.user_alias=self
		  w.walkover=function()
		   self:siguoya_jiashanbi()
		  end
		  w:go(1537)
		end
		 self:redo(f)
	    end
       end
       _R:CatchStart()

end
--4244
--211 襄阳城 huigong 天山 2304
--天山 2304 leave 633 终南山
function alias:huapu_caojing(dx)
  if dx==nil then
     dx="e"
  end
  world.Send(dx)
  wait.make(function()

	 local l,w=wait.regexp("^(> |)花圃 \\-.*$|^(> |)你的动作还没有完成，不能移动。$|^(> |)你累得半死，却颓然发现又走回了牛棚。$|^(> |)你乱走一气，忽然眼前一亮，来到一处草径。$|^(> |)这个方向没有出路。$",5)
	 if l==nil then
        --print("test3")
	    self:huapu_caojing()
	    return
	 end
	 if string.find(l,"你的动作还没有完成") then
	   --print("test")
	    wait.time(0.3)
		self:huapu_caojing()
		return
	 end
	 if string.find(l,"却颓然发现又走回了牛棚") then
	    world.Send("yun jing")
	    world.Send("northdown")

		wait.time(0.3)
	    self:huapu_caojing(dx)
	    return
	 end
     if string.find(l,"忽然眼前一亮") then
	    self:finish()
	    return
	 end
     if string.find(l,"这个方向没有出路") then
        self:finish()
		return
	 end
     if string.find(l,"花圃") then
	    --print("test2")
		world.Send("yun jing")
		wait.time(0.8)
		self:huapu_caojing()

        return

	 end

 end)
end

function alias:niupeng_caojing()
   world.Send("northdown")
   wait.make(function()
      local l,w=wait.regexp("^(> |)草径 \\-.*$|^(> |)花圃 \\-.*$",1.2)
	  if l==nil then
	     self:finish()
	     return
	  end
	  if string.find(l,"草径") then
	     self:finish()
	     return
	  end
	  if string.find(l,"花圃") then
	     self:huapu_caojing()
	     return
	  end
   end)
end

function alias:huapu_niupeng()
 world.Send("s")
  wait.make(function()


	 local l,w=wait.regexp("^(> |)花圃 \\-.*$|^(> |)你的动作还没有完成，不能移动。$|^(> |)你累得半死，却颓然发现又走回了牛棚。$|^(> |)这个方向没有出路。$",5)
	 if l==nil then
        --print("test3")
	    self:huapu_niupeng()
	    return
	 end
	 if string.find(l,"你的动作还没有完成") then
	   --print("test")
	    wait.time(0.3)
		self:huapu_niupeng()
		return
	 end
     if string.find(l,"却颓然发现又走回了牛棚") then
	    self:finish()
	    return
	 end
     if string.find(l,"这个方向没有出路") then
        self:finish()
		return
	 end
     if string.find(l,"花圃") then
	    --print("test2")
		wait.time(0.3)
		self:huapu_niupeng()

        return

	 end

 end)
end


function alias:caojing_niupeng()
   world.Send("south")
    wait.make(function()
      local l,w=wait.regexp("^(> |)草径 \\-.*$|^(> |)花圃 \\-.*$",1.2)
	  if l==nil then
		 self:finish()
	     return
	  end
	  if string.find(l,"草径") then
	     self:finish()
	     return
	  end
	  if string.find(l,"花圃") then
	     self:huapu_niupeng()
	     return
	  end
   end)
end

function alias:ask_qiuqianzhang(roomno)
    if roomno==nil then
      roomno=2427
    end
    local w
	w=walk.new()
	w.walkover=function()
		world.Send("ask qiu qianzhang about 闹鬼")
		wait.make(function()
		  local l,w=wait.regexp("^(> |)你向裘千丈打听有关『闹鬼』的消息。$|^(> |)这里没有这个人。$",5)
		  if l==nil then
		    self:ask_qiuqianzhang(roomno)
			return
		  end
		   if string.find(l,"这里没有这个人")  then
			print("裘走开了")
			   local _R
             _R=Room.new()
              _R.CatchEnd=function()
              local count,roomno=Locate(_R)

                   print("当前房间号:",roomno[1])
	                     if roomno[1]==2424 then
	                          self:ask_qiuqianzhang(245)
	                      elseif roomno[1]==245 then
	                          self:ask_qiuqianzhang(244)
			       elseif roomno[1]==244 then
			          self:ask_qiuqianzhang(1929)
					elseif roomno[1]==1929 then
					   self:ask_qiuqianzhang(2417)
    			      elseif roomno[1]==2417 then
			           self:ask_qiuqianzhang(2427)
					  elseif roomno[1]==2427 then
					     self:ask_qiuqianzhang(2416)
					  else
			           self:ask_qiuqianzhang(2424)
					  end
                           end
                           _R:CatchStart()
			  end
		  if string.find(l,"你向裘千丈打听有关『闹鬼』的消息") then
		   local b
		      	   b=busy.new()
			       b.interval=0.3
				   b.Next=function()
				   local w1
               w1=walk.new()
               w1.walkover=function ()
	              self:movebei()
				       end
               w1:go(4009)
			       end
			       b:check()
		          return
			   end
		  wait.time(5)
		end)
	end
	w:go(roomno)
end

function alias:tzmovebei()
  local w=walk.new()
  w.walkover=function()
     self:movebei()
  end
  w:go(4009)

end

function alias:movebei()
   wait.make(function()
   --你有病呀！没事推墓碑做什么？？
   world.Send("move bei")
   local l,w=wait.regexp("^(> |)你扎下马步，深深的吸了口气，将墓碑缓缓的向旁推开。$|^(> )你有病呀！没事推墓碑做什么.*$|^(> )什么？$",5)
   if l==nil then
	   self:movebei()
	   return
	end
	if string.find(l,"你有病呀！没事推墓碑做什么") or string.find(l,"什么？") then
	  local w1
           w1=walk.new()
           w1.walkover=function ()
	           wait.make(function()
	           world.Send("ask qiu qianzhang about 闹鬼")
		        local l,w=wait.regexp("^(> |)听一些帮众说，经常听见无名峰上的坟墓中，传出响声！嘿嘿！一定有什么蹊跷在里面！$|^(> |)这里没有这个人。$",5)
		       if l==nil then
                print("网络太慢或是发生了一个非预期的错误")
		        self:movebei()
		        return
			   end
			     if string.find(l,"这里没有这个人") then
			       self:ask_qiuqianzhang(roomno)
              return
			   end
		       if string.find(l,"经常听见无名峰上的坟墓中")  then
		          local b
		      	   b=busy.new()
			       b.interval=0.3
				   b.Next=function()
			         self:tzmovebei()
			       end
			       b:check()
		          return
			   end
	       end)
         end
		   local b=busy.new()
		   b.Next=function()
              w1:go(1929)
		   end
           b:check()
		    return
		  end
   if string.find(l,"你扎下马步，深深的吸了口气，将墓碑缓缓的向旁推开") then
	    local b=busy.new()
		b.interval=0.3
		b.Next=function()
		    world.Send("enter")
	      self:finish()
		end
		b:check()
	   return
	end
  end)
end

function alias:caoyuanbianyuan_heishiweizi()
   world.Execute("n;n;n;n")
   self:finish()
end

function alias:danfang_eyutan()
   world.Execute("tui zhonglu;tui donglu middle;tui xilu east;tui zhonglu west")
   self:finish()
end

function alias:ta_corpse()

     local pfm=world.GetVariable("pfm") or ""
	    pfm=convert_pfm(pfm)
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
   world.Send("kill e yu")
   world.Send("ta corpse")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你右足踏在死鳄肚上，借劲跃起，接著左足在鳄鱼的背上一点。你已跃到对岸。$",5)
	 if l==nil then
	    local _R=Room.new()
		_R.CatchEnd=function()
		   if _R.roomname=="鳄鱼潭" then
	         self:ta_corpse()
		   else
		      local w=walk.new()
			  w.walkover=function()
			     self:ta_corpse()
			  end
			  w:go(4996)
		   end
		end
		_R:CatchStart()
	    return
	 end
	 if string.find(l,"你已跃到对岸") then
	    self:finish()
	    return
	 end
   end)
end

function alias:enter_dong()
   world.Send("enter dong")
   self:finish()
end

function alias:climb_down()
   world.Send("climb down")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你眼前霍然一亮，山洞越来越大，地下越来越平整。$",5)
	 if l==nil then
	    self:climb_down()
	    return
	 end
	 if string.find(l,"你眼前霍然一亮") then
	    local b=busy.new()
		b.interval=8
		b.Next=function()
		  self:finish()
		end
		b:check()
	    return
	 end
   end)
end

function alias:shiku_shibi()
   world.Send("l tree")
--这是一颗枣树，树上枝叶茂盛，长满了枣子。
   world.Send("zhe shugan")
   --你折下一根枣树的枝干，长约一丈五尺。
  --你费劲地从枣树上剥下树皮。
  --bo shupi
  --什么？
  local b=busy.new()
  b.Next=function()
   world.Execute("#7 bo shupi")

   --你费劲地从枣树上剥下树皮。
   world.Send("cuo shupi")
   --你把树皮搓绞成索，费尽了力气，才把树皮搓成一条极长的索子。
   --你屏住呼吸，纵上石壁，一路向上攀援。
     local b2=busy.new()
     b2.Next=function()
		world.Send("drop corpse")
        world.Send("climb shibi")
        self:finish()
	 end
     b2:check()

  end
  b:check()
end

function alias:shibi_liguifeng()
    world.Send("west")
	world.Send("drop corpse")
    world.Send("climb shibi")
	world.Send("fu shugan")
     --你将绳索一端缚在树干中间。
   world.Send("shuai shugan")
 wait.make(function()
    local l,w=wait.regexp("^(> |)你用什么东西摔啊？$|^(> |)这一下劲力使得恰到好处，树干落下时正好横架在洞穴口上。$|^(> |)你就这样把树干摔上去有何用？$|^(> |)你已经把树干摔出洞穴了。$",6)

	if l==nil then
		self:shibi_liguifeng()
	    return
	end
	if string.find(l,"你用什么东西摔啊") or string.find(l,"你就这样把树干摔上去有何用") then
        world.Send("climb down")
       self:shiku_shibi()
	   return
	end
	if string.find(l,"这一下劲力使得恰到好处") or string.find(l,"你已经把树干摔出洞穴了") then
      local b=busy.new()
	  b.Next=function()
        world.Send("climb up")
        self:finish()
      end
      b:check()
	  return
	end
 end)
end

function alias:shiguoya_shiguoyadongkou()
   world.Send("enter")
   self:finish()
end

function alias:dagebi_caoyuan()
  --dagebi_caoyuan
   --world.Send("ado s|s|s|s|s|s|s|s|s|s|s|s|s|s")
   world.Execute("#14s")
   --你只觉得头昏脑胀，眼前一黑，接着什么也不知道了……
   self:finish()
end

--拜一灯大师
--山谷瀑布 521 开始
function alias:yuren()
  wait.make(function()
    world.Send("ask yu about 一灯大师")
    world.Send("l pubu")
    wait.time(2)
    world.Send("tiao pubu")
	local l,w=wait.regexp("^(> |)你当下一语不发，也不除衣裤鞋袜，涌身就往瀑布中跳落。$",5)
    if l==nil then
	   self:yuren()
	   return
	end
	if string.find(l,"涌身就往瀑布中跳落") then

	   	local sp=special_item.new()
	    sp.cooldown=function()
           self:zhuawawayu()
        end
        sp:unwield_all()

	   return
	end

  end)
end

function alias:zhuawawayu()

  wait.make(function()
	world.Send("yun qi")
	wait.time(1.5)
	world.Send("zhua yu")

    local l,w=wait.regexp("^(> |)动，挣脱了你掌握，先后窜入石底。$|^(> |)响声在山谷间激荡发出回音，轰轰然良久不绝，你趁势抓住了这对金娃娃。$",5)
	if l==nil then
	   self:zhuawawayu()
	   return
	end
	if string.find(l,"动，挣脱了你掌握，先后窜入石底") then
	   wait.time(3)
	   self:zhuawawayu()
	   return
	end
	if string.find(l,"你趁势抓住了这对金娃娃") then
	   wait.time(5)
	   world.Send("tiao anbian")
	   world.Send("give yu yu")
	   wait.time(5)
	   world.Send("zhi tie zhou")
	   self:tiezhou()
	   return
	end
  end)
end

function alias:tiezhou()
	local sp=special_item.new()
	sp.cooldown=function()
      world.Send("wield jiang")
      self:huaboat()
   end
   sp:unwield_all()
end

function alias:huaboat()
  world.Send("hua boat")
  wait.make(function()
     local l,w=wait.regexp("^(> |)你已经划到岸了，想办法上岸吧！$",3)
	 if l==nil then
		self:huaboat()
	    return
	 end
	 if string.find(l,"想办法上岸吧") then
	    world.Send("tiao shandong")
		world.Send("out")
		wait.time(10)

		self:qiaofu()
	    return
	 end
  end)
end

function alias:qiaofu()
  world.Send("answer 青山相待，白云相爱。梦不到紫罗袍共黄金带。一茅斋，野花开，管甚谁家兴废谁成败？陋巷单瓢亦乐哉。贫，气不改！达，志不改！")
  world.Send("pa teng")
  world.Send("eu")
  wait.make(function()
     local l,w=wait.regexp("^(> |)那樵子在侧，挡住了你的路线。$|^(> |)樵子听得心中大悦，心旷神怡之际，向山边一指，道：上去罢！$|^(> |)已有十余丈，隐隐听得那樵子又在唱曲。$",5)
	 if l==nil then
	    self:qiaofu()
	    return
	 end
	 if string.find(l,"那樵子在侧，挡住了你的路线") then
	    wait.time(1)
		self:qiaofu()
	    return
	 end
	 if string.find(l,"向山边一指") or string.find(l,"已有十余丈，隐隐听得那樵子又在唱曲") then
	     wait.time(2)
        self:nongfu()
		return
	 end
  end)
end

function alias:nongfu()
-- 需要2500 内力
  local x
   x=xiulian.new()
   x.halt=false
   x.min_amount=100
   x.safe_qi=500
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

   end
	x.success=function(h)
       self:nongfu()
	end
  local h=hp.new()
  h.checkover=function()
   if h.neili>2500 then

   world.Send("tuo shi")
   world.Send("e")
   wait.make(function()
     local l,w=wait.regexp("^(> |)农夫双手托住大石，臂上运劲，挺起大石，对你说道：「多谢相助，你过去吧。」$|^(> |)石梁 -$",8)
	  if l==nil then
	     self:nongfu()
	     return
	  end
	  if string.find(l,"多谢相助，你过去吧") then
	     wait.time(2)
	     world.Send("e")
		 self:shiliang()
	     return
	  end
	  if string.find(l,"石梁") then
	     self:shiliang()
	     return
	  end
   end)
   else
      print("内力打坐到2500")
	  x:dazuo()

   end
 end
 h:check()
end

function alias:tui_westwall()
   world.Send("tui westwall")
   world.Send("out")
   self:finish()
end

function alias:tui_eastwall()
   world.Send("tui eastwall")
   world.Send("enter")
   self:finish()
end

--6154 6155 西域沙漠 戈壁绿洲
function alias:shamo_lvzhou()
   world.Execute("#10n")
   wait.make(function()
     local l,w=wait.regexp("^(> |).*戈壁绿洲.*",2)
	 if l==nil then
	     self:shamo_lvzhou()
	    return
	 end
	  if string.find(l,"戈壁绿洲") then

	     world.Send("yun heal")
		 wait.time(3)
		  local b=busy.new()
		  b=busy.new()
		  b.Next=function()
	        self:finish()
		  end
		  b:check()
	    return
	 end
   end)
end

function alias:shiliang()

   local x
   x=xiulian.new()
   x.halt=false
   x.min_amount=100
   x.safe_qi=500
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

   end
	x.success=function(h)
       self:shiliang()

	end

   	local h
	h=hp.new()
	h.checkover=function()
	    if h.neili>1000 then
		   world.Send("jump front")  --每次掉1000内力
		  wait.make(function()
            local l,w=wait.regexp("^(> |)你要对谁做这个动作？$|^(> |)石梁 -$",3)
	          if l==nil then
			     self:shiliang()
		        return
		      end

		      if string.find(l,"你要对谁做这个动作") then
		        self:shusheng()
		        return
		      end
			  if string.find(l,"石梁") then
			    self:shiliang()
                return
			  end
          end)
		else
		   x:dazuo()
		end

	end
	h:check()
end

function alias:shusheng()
     world.Send("ask shu about 一灯大师")

     local f=function()
	   world.Send("ask shu about 题目")
	   local f2=function()
	     world.Send("answer 辛未状元")
		 local f3=function()
	       world.Send("answer 霜凋荷叶，独脚鬼戴逍遥巾")
		   local f4=function()
	         world.Send("answer 魑魅魍魉，四小鬼各自肚肠")
	        local b=busy.new()
	         b.Next=function()
	           world.Send("n")
		       self:finish()
	         end
	         b:check()
		   end
		   f_wait(f4,2)
		 end
		 f_wait(f3,2)
	   end
	   f_wait(f2,2)

	 end
	 f_wait(f,2)

end

function alias:jingxiushi_houshan()
    world.Send("east")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==5010 then
	   self:finish()
	 elseif roomno[1]==4156 then
        --npc block
		local f
		f=function()
		  self:jingxiushi_houshan()
		end
		break_npc=break_npc_id("liu chuxuan")
        self:break_in("liu chuxuan",f)
	 else
	      local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:jingxiushi_houshan()
		end
		w:go(4156)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

function alias:shibixia_dongkou()
  world.Execute("si teng;tui dashi right;tui dashi right;tui dashi right;huang dashi left;huang dashi left;enter")
  self:finish()
end

function alias:shatan2(count)
 wait.make(function()
      local l,w,styles=wait.regexp(".*沙滩.*|^(> |)设定环境变量：action \\= \\\"沙滩二\\\"$",5)
	  if l==nil then

	      return
	  end
	  if string.find(l,"设定环境变量：action") then
	     self:xiaodao_shatan2()
	     return
	  end
	  if string.find(l,"沙滩") then

	   for _, v in ipairs (styles) do
          print (RGBColourToName (v.textcolour), RGBColourToName (v.backcolour), v.text)
		  if Trim(v.text)=="沙滩" then
		     count=count+1
			 print(count," count")
			 if RGBColourToName(v.textcolour)=="magenta" then
		       if count==1 then
			    world.Send("n")
				self:finish()
				return
			   elseif count==2 then
			     world.Send("w")
				 self:finish()
				 return
			   elseif count==3 then
			      world.Send("e")
				  self:finish()
				  return
			   elseif count==4 then
			      world.Send("s")
				  self:finish()
				  return
			   end

			 end

		  end
	   end -- for each style run
	     self:noway()

		 --self:finish()
       --if count<4 then
		--self:shatan2(count)
	   --end
	     return
	  end
   end)
end

function alias:xiaodao_shatan2()
   world.Send("look")
   world.Send("set action 沙滩二")
   self:shatan2(0)
      --[[                      沙滩
silver black
blue black 沙滩
silver black
                             ｜
                   沙滩--    小岛--沙滩
silver black
blue black 沙滩
silver black --
olive black 小岛
silver black --
blue black 沙滩
silver black
                             ｜
                            沙滩
silver black
magenta black 沙滩
silver black   ]]

end

function alias:si_teng()
  world.Send("si teng")
  self:finish()
end

function alias:banshan_shangugudi()
  world.Send("down")
  world.Send("down")
  world.Send("down")
  self:finish()
end

--绝情谷 > 什么?
function alias:duanchang_gudi()
--什么？
    world.Execute("#9 cuo shupi")
  wait.make(function()
     local l,w=wait.regexp("^(> |)树皮都被你剥光了，你还剥什么剥？$|^(> |)什么.*$",5)
	 if l==nil then
	    self:duanchang_gudi()
	    return
	 end
	  if string.find(l,"树皮都被你剥光") then
	   world.Send("bang song")
	    self:yabi_gudi()
	   return
	 end
	 if string.find(l,"什么") then
	    local w=walk.new()
		w.walkover=function()
		   self:duanchang_gudi()
		end
		w:go(3012)
	    return
	 end

  end)
end

function alias:gudi_duanchang()
   world.Send("pa yabi")
   local f=function()
     self:yabi_duanchang()
   end
   f_wait(f,1.5)
end

function alias:yabi_gudi()
   world.Send("pa down")
   wait.make(function()
      local l,w=wait.regexp("^(> |)谷底 -.*$|^(> |)崖壁 -.*$|^(> |)藤条已经放尽，你无法再往下面爬了！$|^(> |)你要往哪爬？$",2)
	  if l==nil then
	      self:yabi_gudi()
	      return
	  end
	  if string.find(l,"崖壁") then
	     wait.time(1.5)
		 self:yabi_gudi()
	     return
	  end
	  if string.find(l,"谷底") or string.find(l,"你要往哪爬") then
         wait.time(1.5)
		self:finish()
	    return
	  end
   end)
end

function alias:yabi_duanchang() --水潭爬上来 回到3012
 world.Send("pa up")
   wait.make(function()
      local l,w=wait.regexp("^(> |)峭壁 -.*$|^(> |)崖壁 -.*$|^(> |)你要往哪爬？$",2)
	  if l==nil then
	      self:yabi_duanchang()
	      return
	  end
	  if string.find(l,"崖壁") then
	     wait.time(1.5)
		 self:yabi_duanchang()
	     return
	  end
	  if string.find(l,"峭壁") or string.find(l,"你要往哪爬") then
         wait.time(1.5)
		self:finish()
	    return
	  end
   end)
end

function alias:gudi_gudishuitan()  --需要检查身上负重 需要50%以上
  --需要检查下初始的负重 如果超过50% 不在进入水潭
  local sp=special_item.new()
  sp.cooldown=function()  --检查完毕
	 if sp.weight<50 then
	  world.Execute("#10 jian shi")  --谷底水潭
      world.Send("tiao tan")
      self:qian_down()
	 else
	   self:noway()
	 end

  end
  local tb={}
  sp:check_items(tb,false)
end

function alias:tanan_tongdao() --通道
   world.Execute("#10 jian shi")
   world.Send("tiao tan")
   self:qian_down()
end

function alias:tongdao_gudi()  --qian zuoshang 入谷  qian up 出谷
   world.Send("qian up")
   local f=function()
      self:qian_up()
   end
   f_wait(f,1.5)
end

function alias:guditan_tanan()   --qian zuoshang 入谷  qian up 出谷
   world.Send("qian zuoshang")
   local f=function()
      self:qian_up()
   end
   f_wait(f,1.5)
end

local try_qian_up=0
function alias:qian_down()
   world.Send("qian down")
   wait.make(function()
     local l,w=wait.regexp("^(> |)一个猛栽，潜了下去。$|^(> |)你要往哪里潜？$|^(> |)由于重力不够，你无法继续下潜!$|^(> |)什么？$",5)
	 if l==nil then
	    self:qian_down()
	    return
	 end
	 if string.find(l,"什么") then
      local _R
      _R=Room.new()
      _R.CatchEnd=function()
       local count,roomno=Locate(_R)
	    print("当前房间号",roomno[1])
	   if roomno[1]==5081 then
	      self:finish()
	   else
	      local f=function()
            local w
		    w=walk.new()
	     	w.user_alias=self
		    w.walkover=function()
		     self:qian_down()
		    end
		    w:go(5082)
		   end
		   self:redo(f)
	    end
      end
       _R:CatchStart()
	    return
	 end
	 if string.find(l,"由于重力不够") then
	    world.Send("pa up")
		local f=function()
		   world.Execute("#10 jian shi")
           world.Send("tiao tan")
		   self:qian_down()
		end
        f_wait(f,1)
	    return
	 end
	 if string.find(l,"你要往哪里潜") then
		wait.time(1.5)
		world.Execute("#10 drop stone")
		try_qian_up=0
		self:finish()
	    return
	 end
	 if string.find(l,"潜了下去") then
	    wait.time(1.5)
		self:qian_down()
	    return
	 end
   end)
end

function alias:pa_up()
   world.Send("pa up")
   self:finish()
end

function alias:nanjie_changjie()
   world.Send("east")
   self:finish()
end

function alias:shamo1_shamo2()
   world.Send("north")
   world.Send("south")
   self:finish()
end


function alias:qian_up()
   world.Send("qian up")
   wait.make(function()
     local l,w=wait.regexp("^(> |)手脚齐划，顺着水势向上面浮去。$|^(> |)你身子沉重，用尽全力也无法潜回上面!$|^(> |)你要往哪里潜？$|^(> |)什么？$",5)
	 if l==nil then
		try_qian_up=try_qian_up+1
		if  try_qian_up>10 then
	        self:finish()
		    return
		end
		self:qian_up()
	    return
	 end
	 if string.find(l,"什么") then

	       self:finish()
		 --end
	    return
	 end
	 if string.find(l,"你身子沉重") then
	   if try_qian_up==0 then
	    world.Execute("#10 drop stone;drop coin")
	   elseif try_qian_up==1 then
	     world.Execute("#10 drop stone;drop silver")
	   elseif try_qian_up==2 then
	        world.Execute("#10 drop stone;drop gold")
	   else
	      world.Execute("drop tuichui;drop hammer;drop zhang;drop armor;drop dao")
	   end
	    try_qian_up=try_qian_up+1

		local f=function()
		  self:qian_up()
		end
		f_wait(f,1.5)
	    return
	 end
	 if string.find(l,"你要往哪里潜") then
	    wait.time(1.5)
		world.Send("pa up")
		wait.time(1.5)
		self:finish()
	    return
	 end
	 if string.find(l,"手脚齐划，顺着水势向上面浮去") then
	    wait.time(1.5)
		self:qian_up()
	    return
	 end
   end)
end

--离开活死人墓  --检查身上是否有fire
function alias:search_fire()
  local w=walk.new()
   w.walkover=function()
     world.Execute("#5 search qiangjiao")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)你在墙脚的物品堆里翻来翻去找出一把火折。$|^(> |)你已经拿了火折了，怎么这么贪心？$",5)
	   if l==nil then
	      self:search_fire()
	      return
	   end
	   if string.find(l,"你在墙脚的物品堆里翻来翻去找出一把火折") or string.find(l,"你已经拿了火折了") then
	      world.Execute("n;n;w;n")
	      self:ws_ss()
	      return
	   end
	 end)
   end
   w:go(5056)
end

function alias:ws_ss()
   world.Execute("tang bed;ban shiban")
   wait.make(function()
      local l,w=wait.regexp("^(> |)你使出吃奶的劲力，但石板却纹丝不动。$|^(> |)你发现什么地方好象卡住了，怎么也扳不动石板。$|^(> |)你用力扳动突起的石板，只听得轧轧几响，石床已落入下层石室。$|^(> |)什么？$",5)
	   if l==nil then
	      self:ws_ss()
	      return
	   end
	  if string.find(l,"石板却纹丝不动") or string.find(l,"怎么也扳不动石板") then
	     print("exp不满100000 或 内力不满500")
	     return
	  end
	  if string.find(l,"用力扳动突起的石板") then
	     self:finish()
	     return
	  end
	  if string.find(l,"什么") then
		 local w=walk.new()
		 w.walkover=function()
		    self:ws_ss()
		 end
		 w:go(5050)
	     return
	  end
   end)

end

function alias:ss_ws()
  world.Execute("tui shibi;up")
  self:finish()
end

function alias:chy0_chy1()
  world.Execute("give xiaohuo 5 silver;nu")
  self:finish()
end

--5084---5083
function alias:shishi4_shishi0(dir)
--你慢慢发现自己体力不支.....
--5084
  if dir==nil or dir=="s" then
     dir="e"
  elseif dir=="e" then
     dir="w"
  elseif dir=="w" then
     dir="n"
  elseif dir=="n" then
     dir="s"
  end
  world.Execute("#10 "..dir)
 wait.make(function()
    local l,w=wait.regexp("^(> |)你慢慢发现自己体力不支.*$",1.5)
	if l==nil then
	   self:shishi4_shishi0(dir)
	   return
	end
	if string.find(l,"你慢慢发现自己体力不支") then
	   local f=function()
	     local b=busy.new()
		 b.Next=function()
	       self:finish()
		 end
		 b:check()
	   end
	   f_wait(f,8)
	   return
	end
  end)
end
--5084--5085
function alias:shishi1_shishi5(dir)
--你累得半死，终於发现前方有一道光亮。
  if dir==nil or dir=="s" then
     dir="e"
  elseif dir=="e" then
     dir="w"
  elseif dir=="w" then
     dir="n"
  elseif dir=="n" then
     dir="s"
  end
  world.Execute("#6 "..dir..";yun jingli")
 wait.make(function()
    local l,w=wait.regexp("^(> |)你累得半死，终於发现前方有一道光亮。$",1.5)
	if l==nil then
	   self:shishi1_shishi5(dir)
	   return
	end
	if string.find(l,"终於发现前方有一道光亮") then
	   local b=busy.new()
	   b.Next=function()
	     self:finish()
	   end
	   b:check()
	   return
	end

 end)
end

function alias:shiguan_sshi()
--领悟古墓九阴的地方 5088
--> 你没有火折，点什么？
   world.Execute("use fire;search;search;search;search;search;search;search;search;search;turn ao left")  --什么？
   wait.make(function()
      local l,w=wait.regexp("^(> |)你将凹处往左转动几下，果然有些松动。$|^(> |)你没有火折，点什么.*$|^(> |)什么？$",5)
	  if l==nil then
	     self:shiguan_sshi()
	     return
	  end
	  if string.find(l,"你没有火折") then
	    local b=busy.new()
		b.Next=function()
	     world.Execute("out;get fire;tui guangai;tang guan")
		 self:shiguan_sshi()
		end
		b:check()
	     return
	  end
	  if string.find(l,"什么") then
	     local w=walk.new()
		 w.walkover=function()
		    self:shiguan_sshi()
		 end
		 w:go(5087)
	     return
	  end
	  if string.find(l,"你将凹处往左转动几下") then
	    --print("deng dai")
        local f=function()
          local b=busy.new()
	      b.Next=function()
            world.Send("ti up")
            self:finish()
	      end
	      b:check()
		end
		f_wait(f,3)
		return
      end

   end)
end

function alias:lingshi_shiguan()
  world.Execute("tui guangai;tang guan")
  self:finish()
end

function alias:walkdown()
 --需要115 force
  world.Send("look map")
 local f=function()
       world.Send("walk down")
	   local b2=busy.new()
	   b2.Next=function()
         self:finish()
	   end
	   b2:check()
 end
 f_wait(f,3)

end

function alias:gumu_shulin()
   world.Execute("#7 w")
   self:finish()
end

function alias:shulin_gumu()
    world.Execute("#7 e")
   self:finish()
end

function alias:gml_lcd()
 world.Execute("#10 e")
   self:finish()
end

function alias:tiao_anbian()
    world.Send("tiao anbian")
    self:finish()
end

function alias:hjxl_bhg()
  world.Send("find 蜜蜂")
  wait.make(function()
    local l,w=wait.regexp("^(> |)你见到这个玉蜂甚是奇怪，凑近一看，见这只小玉蜂上似乎身上有字！$",2)
	if l==nil then
	   self:hjxl_bhg()
	   return
	end
	if string.find(l,"见这只小玉蜂上似乎身上有字") then
	   world.Send("gensui 玉蜂")
	   wait.time(2)
	   self:finish()
	   return
	end
  end)
 -- 7066 7067

end

function alias:dxssk_dxssg()
  local f=function()
   world.Send("southup")
   self:finish()
  end
  f_wait(f,1.2)
end
function alias:tiao_up()
   world.Send("tiao up")
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
     self:finish()
   end
   b:check()
end

function alias:daxueshan_daxueshankou()
  local f=function()
   world.Send("southup")
   self:finish()
  end
  f_wait(f,1.2)
end

function alias:dongkou_shandong()
   world.Send("enter")
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==5224 then
	   self:finish()
	 elseif roomno[1]==5227 then
        --npc block
		local f
		f=function()
		  self:dongkou_shandong()
		end
		break_npc=break_npc_id("sheng xiong")
        self:break_in("sheng xiong",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:dongkou_shandong()
		end
		w:go(5227)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end

--2166
function alias:d_east()
  local b=busy.new()
  b.interval=0.5
  b.Next=function()
      world.Send("east")
	  self:finish()
  end
  b:check()
end

function alias:bydm_dlzws()  --兵营大门-第六指挥所
 world.Send("south")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==7040 then
	   self:finish()
	 elseif roomno[1]==7041 then
        --npc block
		local f
		f=function()
		  self:bydm_dlzws()
		end
		break_npc=break_npc_id("guan bing")
        self:break_in("guan bing",f)
	 else
	     local f=function()
        local w
		w=walk.new()
		w.user_alias=self
		w.walkover=function()
		   self:bydm_dlzws()
		end
		w:go(7041)
		end
		self:redo(f)
	 end
   end
   _R:CatchStart()
end
--2816 到 2814
function alias:zhulin_jicui()
  world.Send("north")
   local _R
   _R=Room.new()
   _R.CatchEnd=function()

	 if _R.roomname=="绿竹林" then
	   self:zhulin_jicui()
	 elseif _R.roomname=="积翠亭" then
        --npc block
		self:finish()
	 else
	      self:noway()
	 end
   end
   _R:CatchStart()
end
--函数注册
function alias:register()
   --print("注册 alias")
   local alias_item={}
	alias_item.name="xzl_gb"
	alias_item.dir="n"
	alias_item.alias=function() self:xzl_gb() end
    self.alias_table["xzl_gb"]=alias_item

    alias_item={}
	alias_item.name="d_east"
	alias_item.dir="e"
	alias_item.alias=function() self:d_east() end
	self.alias_table["d_east"]=alias_item


	alias_item={}
	alias_item.name="zhulin_jicui"
	alias_item.dir="n"
	alias_item.alias=function() self:zhulin_jicui() end
	self.alias_table["zhulin_jicui"]=alias_item

	alias_item={}
	alias_item.name="tiao_anbian"
	alias_item.dir="w"
	alias_item.alias=function() self:tiao_anbian() end
	self.alias_table["tiao_anbian"]=alias_item

	alias_item={}
	alias_item.name="tiao_up"
	alias_item.dir="e"
	alias_item.alias=function() self:tiao_up() end
	self.alias_table["tiao_up"]=alias_item

	alias_item={}
	alias_item.name="nanjie_changjie"
	alias_item.dir="e"
	alias_item.alias=function() self:nanjie_changjie() end
	self.alias_table["nanjie_changjie"]=alias_item

	alias_item={}
	alias_item.name="fengyun"
	alias_item.dir="e"
	alias_item.alias=function() self:fengyun() end
	self.alias_table["fengyun"]=alias_item

	alias_item={}
	alias_item.name="longhu"
	alias_item.dir="s"
	alias_item.alias=function() self:longhu() end
	self.alias_table["longhu"]=alias_item

	alias_item={}
	alias_item.name="bydm_dlzws"
	alias_item.dir="s"
	alias_item.alias=function() self:bydm_dlzws() end
	self.alias_table["bydm_dlzws"]=alias_item

	alias_item={}
	alias_item.name="tiandi"
	alias_item.dir="w"
	alias_item.alias=function() self:tiandi() end
	self.alias_table["tiandi"]=alias_item

	alias_item={}
	alias_item.name="dujiang"
	alias_item.dir="n"
	alias_item.alias=function() self:dujiang() end
	self.alias_table["dujiang"]=alias_item

    alias_item={}
	alias_item.name="duhe"
	alias_item.dir="nw"
	alias_item.alias=function() self:duhe() end
	self.alias_table["duhe"]=alias_item

	alias_item={}
	alias_item.name="dutan"
	alias_item.dir="w"
	alias_item.alias=function() self:dutan() end
	self.alias_table["dutan"]=alias_item

	alias_item={}
	alias_item.name="opendoornorthup"
	alias_item.dir="n"
	alias_item.alias=function() self:opendoornorthup() end
	self.alias_table["opendoornorthup"]=alias_item

	alias_item={}
	alias_item.name="opendoorsouthdown"
	alias_item.dir="s"
	alias_item.alias=function() self:opendoorsouthdown() end
	self.alias_table["opendoorsouthdown"]=alias_item

    alias_item={}
	alias_item.name="opendoornorth"
	alias_item.dir="n"
	alias_item.alias=function() self:opendoornorth() end
	self.alias_table["opendoornorth"]=alias_item

	alias_item={}
	alias_item.name="opendoorout"
	alias_item.dir="sw"
	alias_item.alias=function() self:opendoorout() end
	self.alias_table["opendoorout"]=alias_item

	alias_item={}
	alias_item.name="opendoorsouth"
	alias_item.dir="s"
	alias_item.alias=function() self:opendoorsouth() end
	self.alias_table["opendoorsouth"]=alias_item

	alias_item={}
	alias_item.name="opendooreast"
	alias_item.dir="e"
	alias_item.alias=function() self:opendooreast() end
	self.alias_table["opendooreast"]=alias_item

	alias_item={}
	alias_item.name="opendoorwest"
	alias_item.dir="w"
	alias_item.alias=function() self:opendoorwest() end
	self.alias_table["opendoorwest"]=alias_item

	alias_item={}
	alias_item.name="shulin_shendiao"
	alias_item.dir="n"
	alias_item.alias=function() self:shulin_shendiao() end
	self.alias_table["shulin_shendiao"]=alias_item

	alias_item={}
	alias_item.name="daxueshan_daxueshankou"
	alias_item.dir="s"
	alias_item.alias=function() self:daxueshan_daxueshankou() end
	self.alias_table["daxueshan_daxueshankou"]=alias_item


	alias_item={}
	alias_item.name="shulin_kongdi"
	alias_item.dir="s"
	alias_item.alias=function() self:shulin_kongdi() end
	self.alias_table["shulin_kongdi"]=alias_item

	alias_item={}
	alias_item.name="movebei"
	alias_item.dir="n"
	alias_item.alias=function() self:movebei() end
	self.alias_table["movebei"]=alias_item

	alias_item={}
	alias_item.name="songlin_shanjiao"
	alias_item.dir="e"
	alias_item.alias=function() self:songlin_shanjiao() end
	self.alias_table["songlin_shanjiao"]=alias_item

	alias_item={}
	alias_item.name="caidi_cunzhongxin"
	alias_item.dir="s"
	alias_item.alias=function() self:caidi_cunzhongxin() end
	self.alias_table["caidi_cunzhongxin"]=alias_item

	alias_item={}
	alias_item.name="tiaodown"
	alias_item.dir="sw"
	alias_item.alias=function() self:tiaodown() end
	self.alias_table["tiaodown"]=alias_item

	alias_item={}
	alias_item.name="dalunsishanmen_dianqianguangchang"
	alias_item.dir="n"
	alias_item.alias=function() self:dalunsishanmen_dianqianguangchang() end
	self.alias_table["dalunsishanmen_dianqianguangchang"]=alias_item

	alias_item={}
	alias_item.name="guangchang_shanmendian"
	alias_item.dir="n"
	alias_item.alias=function() self:guangchang_shanmendian() end
	self.alias_table["guangchang_shanmendian"]=alias_item

	alias_item={}
	alias_item.name="caoyuanbianyuan_heishiweizi"
	alias_item.dir="n"
	alias_item.alias=function() self:caoyuanbianyuan_heishiweizi() end
	self.alias_table["caoyuanbianyuan_heishiweizi"]=alias_item

	alias_item={}
	alias_item.name="knockgatesouth"
	alias_item.dir="s"
	alias_item.alias=function() self:knockgatesouth() end
	self.alias_table["knockgatesouth"]=alias_item

	alias_item={}
	alias_item.name="pullgatesouthdown"
	alias_item.dir="s"
	alias_item.alias=function() self:pullgatesouthdown() end
	self.alias_table["pullgatesouthdown"]=alias_item

	alias_item={}
	alias_item.name="opengatesouth"
	alias_item.dir="s"
	alias_item.alias=function() self:opengatesouth() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="opengateout"
	alias_item.dir="s"
	alias_item.alias=function() self:opengateout() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="opengatenorth"
	alias_item.dir="n"
	alias_item.alias=function() self:opengatenorth() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="opengateenter"
	alias_item.dir="n"
	alias_item.alias=function() self:opengateenter() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="shamo_qingcheng"
	alias_item.dir="ne"
	alias_item.alias=function() self:shamo_qingcheng() end
	self.alias_table["shamo_qingcheng"]=alias_item

	alias_item={}
	alias_item.name="heilin_gumu"
	alias_item.dir="e"
	alias_item.alias=function() self:heilin_gumu() end
	self.alias_table["heilin_gumu"]=alias_item

	alias_item={}
	alias_item.name="heilin_shulin"
	alias_item.dir="w"
	alias_item.alias=function() self:heilin_shulin() end
	self.alias_table["heilin_shulin"]=alias_item

	alias_item={}
	alias_item.name="gudelin_bailongdong"
	alias_item.dir="ne"
	alias_item.alias=function() self:gudelin_bailongdong() end
	self.alias_table["gudelin_bailongdong"]=alias_item

	alias_item={}
	alias_item.name="leave"
	alias_item.dir="se"
	alias_item.alias=function() self:leave() end
	self.alias_table["leave"]=alias_item

	alias_item={}
	alias_item.name="unwield_northup"
	alias_item.dir="n"
	alias_item.alias=function() self:unwield_northup() end
	self.alias_table["unwield_northup"]=alias_item

	alias_item={}
	alias_item.name="fumoquan_songlin"
	alias_item.dir="n"
	alias_item.alias=function() self:fumoquan_songlin() end
	self.alias_table["fumoquan_songlin"]=alias_item

	alias_item={}
	alias_item.name="songlin_fumoquan"
	alias_item.dir="e"
	alias_item.alias=function() self:songlin_fumoquan() end
	self.alias_table["songlin_fumoquan"]=alias_item

    alias_item={}
	alias_item.name="shanlu_songlin"
	alias_item.dir="n"
	alias_item.alias=function() self:shanlu_songlin() end
	self.alias_table["shanlu_songlin"]=alias_item

	alias_item={}
	alias_item.name="songlin_shanlu"
	alias_item.dir="s"
	alias_item.alias=function() self:songlin_shanlu() end
	self.alias_table["songlin_shanlu"]=alias_item

	alias_item={}
	alias_item.name="duxiaohe"
	alias_item.dir="s"
	alias_item.alias=function() self:duxiaohe() end
	self.alias_table["duxiaohe"]=alias_item

	alias_item={}
	alias_item.name="hubinxiaolu_hubinxiaolu"
	alias_item.dir="n"
	alias_item.alias=function() self:hubinxiaolu_hubinxiaolu() end
	self.alias_table["hubinxiaolu_hubinxiaolu"]=alias_item

	alias_item={}
	alias_item.name="hubinxiaolu_guiyunzhuang"
	alias_item.dir="w"
	alias_item.alias=function() self:hubinxiaolu_guiyunzhuang() end
	self.alias_table["hubinxiaolu_guiyunzhuang"]=alias_item

	alias_item={}
	alias_item.name="qusuzhou"
	alias_item.dir="nw"
	alias_item.range=10
	alias_item.alias=function() self:qusuzhou() end
	self.alias_table["qusuzhou"]=alias_item

	alias_item={}
	alias_item.name="quyanziwu"
	alias_item.dir="n"
	alias_item.range=99
	alias_item.alias=function() self:quyanziwu() end
	self.alias_table["quyanziwu"]=alias_item

	alias_item={}
	alias_item.name="shamo_sichouzhilu"
	alias_item.dir="e"
	alias_item.range=4
	alias_item.alias=function() self:shamo_sichouzhilu() end
	self.alias_table["shamo_sichouzhilu"]=alias_item

	alias_item={}
	alias_item.name="shamo_caoyuanbianyuan"
	alias_item.dir="w"
	alias_item.range=4
	alias_item.alias=function() self:shamo_caoyuanbianyuan() end
	self.alias_table["shamo_caoyuanbianyuan"]=alias_item

	alias_item={}
	alias_item.name="zhenyelin"
	alias_item.dir="n"
	alias_item.range=10
	alias_item.alias=function() self:zhenyelin() end
	self.alias_table["zhenyelin"]=alias_item

	alias_item={}
	alias_item.name="zhenyelin_circle"
	alias_item.dir="nw"
	alias_item.range=10
	alias_item.alias=function() self:zhenyelin_circle() end
	self.alias_table["zhenyelin_circle"]=alias_item

	alias_item={}
	alias_item.name="houtuqi_mingjiaoshulin1"
	alias_item.dir="w"
	alias_item.alias=function() self:houtuqi_mingjiaoshulin1() end
	self.alias_table["houtuqi_mingjiaoshulin1"]=alias_item

	alias_item={}
	alias_item.name="houtuqi_mingjiaoshulin2"
	alias_item.dir="nw"
	alias_item.alias=function() self:houtuqi_mingjiaoshulin2() end
	self.alias_table["houtuqi_mingjiaoshulin2"]=alias_item

	alias_item={}
	alias_item.name="houtuqi_mingjiaoshulin3"
	alias_item.dir="ne"
	alias_item.alias=function() self:houtuqi_mingjiaoshulin3() end
	self.alias_table["houtuqi_mingjiaoshulin3"]=alias_item

	alias_item={}
	alias_item.name="houtuqi_mingjiaoshulin4"
	alias_item.dir="sw"
	alias_item.alias=function() self:houtuqi_mingjiaoshulin4() end
	self.alias_table["houtuqi_mingjiaoshulin4"]=alias_item

	alias_item={}
	alias_item.name="bingyingdamen_bingying"
	alias_item.dir="n"
	alias_item.alias=function() self:bingyingdamen_bingying() end
	self.alias_table["bingyingdamen_bingying"]=alias_item

	alias_item={}
	alias_item.name="yamen_zhengting"
	alias_item.dir="n"
	alias_item.alias=function() self:yamen_zhengting() end
	self.alias_table["yamen_zhengting"]=alias_item

	alias_item={}
	alias_item.name="yamen_cucangshi"
	alias_item.dir="nw"
	alias_item.alias=function() self:yamen_cucangshi() end
	self.alias_table["yamen_cucangshi"]=alias_item

	alias_item={}
	alias_item.name="jumpwell"
	alias_item.dir="se"
	alias_item.alias=function() self:jumpwell() end
	self.alias_table["jumpwell"]=alias_item

    alias_item={}
	alias_item.name="pullhuan"
	alias_item.dir="w"
	alias_item.alias=function() self:pullhuan() end
	self.alias_table["pullhuan"]=alias_item

	alias_item={}
	alias_item.name="xieketing_rimulundian"
	alias_item.dir="n"
	alias_item.alias=function() self:xieketing_rimulundian() end
	self.alias_table["xieketing_rimulundian"]=alias_item

	alias_item={}
	alias_item.name="baizhangjian_xianchoumen"
	alias_item.dir="w"
	alias_item.alias=function() self:baizhangjian_xianchoumen() end
	self.alias_table["baizhangjian_xianchoumen"]=alias_item

	alias_item={}
	alias_item.name="xianchoumen_baizhangjian"
	alias_item.dir="e"
	alias_item.alias=function() self:xianchoumen_baizhangjian() end
	self.alias_table["xianchoumen_baizhangjian"]=alias_item

	alias_item={}
	alias_item.name="chengzhongxin_nanmen"
	alias_item.dir="s"
	alias_item.alias=function() self:chengzhongxin_nanmen() end
	self.alias_table["chengzhongxin_nanmen"]=alias_item

	alias_item={}
	alias_item.name="nanmen_chengzhongxin"
	alias_item.dir="n"
	alias_item.range=1
	alias_item.alias=function() self:nanmen_chengzhongxin() end
	self.alias_table["nanmen_chengzhongxin"]=alias_item

	alias_item={}
	alias_item.name="mingjiaoshulin_houtuqi"
	alias_item.dir="e"
	alias_item.alias=function() self:mingjiaoshulin_houtuqi() end
	self.alias_table["mingjiaoshulin_houtuqi"]=alias_item

	alias_item={}
	alias_item.name="shatan_shenlongdao"
	alias_item.dir="ne"
	alias.range=50
	alias_item.alias=function() self:shatan_shenlongdao() end
	self.alias_table["shatan_shenlongdao"]=alias_item

	alias_item={}
	alias_item.name="shenlongdao_shatan"
	alias_item.dir="sw"
	alias.range=50
	alias_item.alias=function() self:shenlongdao_shatan() end
	self.alias_table["shenlongdao_shatan"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_east"
	alias_item.dir="e"
	alias_item.alias=function() self:xingxiuhai_east() end
	self.alias_table["xingxiuhai_east"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_north"
	alias_item.dir="n"
	alias_item.alias=function() self:xingxiuhai_north() end
	self.alias_table["xingxiuhai_north"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_west"
	alias_item.dir="w"
	alias_item.alias=function() self:xingxiuhai_west() end
	self.alias_table["xingxiuhai_west"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_south"
	alias_item.dir="s"
	alias_item.alias=function() self:xingxiuhai_south() end
	self.alias_table["xingxiuhai_south"]=alias_item

	alias_item={}
	alias_item.name="xingxiuhai_search"
	alias_item.dir="n"
	alias_item.alias=function() self:xingxiuhai_search() end
	self.alias_table["xingxiuhai_search"]=alias_item

	alias_item={}
	alias_item.name="shanmen_shanlu"
	alias_item.dir="n"
	alias_item.alias=function() self:shanmen_shanlu() end
	self.alias_table["shanmen_shanlu"]=alias_item

	alias_item={}
	alias_item.name="baishilu_tianwangdian"
	alias_item.dir="n"
	alias_item.alias=function() self:baishilu_tianwangdian() end
	self.alias_table["baishilu_tianwangdian"]=alias_item

	alias_item={}
	alias_item.name="tanqin"
	alias_item.dir="n"
	alias_item.alias=function() self:tanqin() end
	self.alias_table["tanqin"]=alias_item

	alias_item={}
	alias_item.name="qumr"
	alias_item.dir="s"
    alias_item.range=10
	alias_item.alias=function() self:qumr() end
	self.alias_table["qumr"]=alias_item

	alias_item={}
	alias_item.name="changan_bingyingdamen_bingying"
	alias_item.dir="n"
	alias_item.alias=function() self:changan_bingyingdamen_bingying() end
	self.alias_table["changan_bingyingdamen_bingying"]=alias_item

	alias_item={}
	alias_item.name="jiayuguanximen_yanmenguan"
	alias_item.dir="w"
	alias_item.alias=function() self:jiayuguanximen_yanmenguan() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="jiayuguanximen_sichouzhilu"
	alias_item.dir="e"
	alias_item.alias=function() self:jiayuguanximen_sichouzhilu() end
	self.alias_table["jiayuguanximen_sichouzhilu"]=alias_item

	alias_item={}
	alias_item.name="wangfudating_changlang"
	alias_item.dir="e"
	alias_item.alias=function() self:wangfudating_changlang() end
	self.alias_table["wangfudating_changlang"]=alias_item

	alias_item={}
	alias_item.name="wangfudating_changlang2"
	alias_item.dir="w"
	alias_item.alias=function() self:wangfudating_changlang2() end
	self.alias_table["wangfudating_changlang2"]=alias_item

	alias_item={}
	alias_item.name="lianwuchang_guangchang"
	alias_item.dir="n"
	alias_item.alias=function() self:lianwuchang_guangchang() end
	self.alias_table["lianwuchang_guangchang"]=alias_item

	alias_item={}
	alias_item.name="yamendamen_menlang"
		alias_item.dir="n"
	alias_item.alias=function() self:yamendamen_menlang() end
	self.alias_table["yamendamen_menlang"]=alias_item

	alias_item={}
	alias_item.name="wuzhitang_houxiangfang"
	alias_item.dir="n"
	alias_item.alias=function() self:wuzhitang_houxiangfang() end
	self.alias_table["wuzhitang_houxiangfang"]=alias_item

	alias_item={}
	alias_item.name="wuzhitang_west_zoulang"
	alias_item.dir="w"
	alias_item.alias=function() self:wuzhitang_west_zoulang() end
	self.alias_table["wuzhitang_west_zoulang"]=alias_item

	alias_item={}
	alias_item.name="wuzhitang_east_zoulang"
	alias_item.dir="e"
	alias_item.alias=function() self:wuzhitang_east_zoulang() end
	self.alias_table["wuzhitang_east_zoulang"]=alias_item

	alias_item={}
	alias_item.name="wuliangjianzong_shibanlu"
	alias_item.dir="se"
	alias_item.alias=function() self:wuliangjianzong_shibanlu() end
	self.alias_table["wuliangjianzong_shibanlu"]=alias_item

	alias_item={}
	alias_item.name="shibanlu_jianhugong"
	alias_item.dir="n"
	alias_item.alias=function() self:shibanlu_jianhugong() end
	self.alias_table["shibanlu_jianhugong"]=alias_item

	alias_item={}
	alias_item.name="qingduyaotai_baishilu"
	alias_item.dir="n"
	alias_item.alias=function() self:qingduyaotai_baishilu() end
	self.alias_table["qingduyaotai_baishilu"]=alias_item

	alias_item={}
	alias_item.name="qingduyaotai_banruotai"
	alias_item.dir="e"
	alias_item.alias=function() self:qingduyaotai_banruotai() end
	self.alias_table["qingduyaotai_banruotai"]=alias_item

	alias_item={}
	alias_item.name="dacaoyuan_yingmen"
	alias_item.dir="n"
	alias_item.alias=function() self:dacaoyuan_yingmen() end
	self.alias_table["dacaoyuan_yingmen"]=alias_item

	alias_item={}
	alias_item.name="huanggongzhengting_zoulang"
	alias_item.dir="n"
	alias_item.alias=function() self:huanggongzhengting_zoulang() end
	self.alias_table["huanggongzhengting_zoulang"]=alias_item

	alias_item={}
	alias_item.name="ll_sl"
	alias_item.dir="n"
	alias_item.alias=function() self:ll_sl() end
	self.alias_table["ll_sl"]=alias_item

	alias_item={}
	alias_item.name="error_mufa"
	alias_item.dir=nil
	alias_item.alias=function() self:error_mufa() end
	self.alias_table["error_mufa"]=alias_item

	alias_item={}
	alias_item.name="west_taohuazhen"
	alias_item.dir="w"
	alias_item.alias=function() self:west_taohuazhen() end
	self.alias_table["west_taohuazhen"]=alias_item

	alias_item={}
	alias_item.name="east_taohuazhen"
	alias_item.dir="e"
	alias_item.alias=function() self:east_taohuazhen() end
	self.alias_table["east_taohuazhen"]=alias_item

	alias_item={}
	alias_item.name="yellboat"
	alias_item.dir="s"
	alias_item.alias=function() self:yellboat() end
	self.alias_table["yellboat"]=alias_item

	alias_item={}
	alias_item.name="waitday_south"
	alias_item.dir="s"
	alias_item.alias=function() self:waitday_south() end
	self.alias_table["waitday_south"]=alias_item

	alias_item={}
	alias_item.name="baishilu_banzuyuan"
	alias_item.dir="e"
	alias_item.alias=function() self:baishilu_banzuyuan() end
	self.alias_table["baishilu_banzuyuan"]=alias_item

	alias_item={}
	alias_item.name="changjie_changjie"
	alias_item.dir="e"
	alias_item.alias=function() self:changjie_changjie() end
	self.alias_table["changjie_changjie"]=alias_item

	alias_item={}
	alias_item.name="changjie_nandajie"
	alias_item.dir="w"
	alias_item.alias=function() self:changjie_nandajie() end
	self.alias_table["changjie_nandajie"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_zishanlin2_quick"
	alias_item.range=5
	alias_item.alias=function() self:zishanlin_zishanlin2_quick() end
	self.alias_table["zishanlin_zishanlin2_quick"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_ruijin"
	alias_item.dir="se"
	alias_item.alias=function() self:zishanlin_ruijin() end
	self.alias_table["zishanlin_ruijin"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_houtu"
	alias_item.dir="nw"
	alias_item.alias=function() self:zishanlin_houtu() end
	self.alias_table["zishanlin_houtu"]=alias_item

	--[[alias_item={}
	alias_item.name="zishanlin_hongshui"
	alias_item.dir="ne"
	alias_item.alias=function() self:zishanlin_hongshui() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="zishanlin_liehuo"
	alias_item.dir="sw"
	alias_item.alias=function() self:zishanlin_liehuo() end
	self.alias_table[alias_item.name]=alias_item]]

	alias_item={}
	alias_item.name="huilang_huilang1"
	alias_item.dir="w"
	alias_item.alias=function() self:huilang_huilang1() end
	self.alias_table["huilang_huilang1"]=alias_item

	alias_item={}
	alias_item.name="huilang_huilang2"
	alias_item.dir="s"
	alias_item.alias=function() self:huilang_huilang2() end
	self.alias_table["huilang_huilang2"]=alias_item

	alias_item={}
	alias_item.name="tiaochuang"
	alias_item.dir="w"
	alias_item.alias=function() self:tiaochuang() end
	self.alias_table["tiaochuang"]=alias_item

	alias_item={}
	alias_item.name="jingxiushi_houshan"
	alias_item.dir="e"
	alias_item.alias=function() self:jingxiushi_houshan() end
	self.alias_table["jingxiushi_houshan"]=alias_item

	alias_item={}
	alias_item.name="lianwuchang_zoulang2"
	alias_item.dir="w"
	alias_item.alias=function() self:lianwuchang_zoulang2() end
	self.alias_table["lianwuchang_zoulang2"]=alias_item

	alias_item={}
	alias_item.name="lianwuchang_zoulang1"
	alias_item.dir="e"
	alias_item.alias=function() self:lianwuchang_zoulang1() end
	self.alias_table["lianwuchang_zoulang1"]=alias_item

	alias_item={}
	alias_item.name="yuchuan2_yuchuan1"
	alias_item.dir="s"
	alias_item.alias=function() self:yuchuan2_yuchuan1() end
	self.alias_table["yuchuan2_yuchuan1"]=alias_item

	alias_item={}
	alias_item.name="yuchuan2_yuchuan3"
	alias_item.dir="n"
	alias_item.alias=function() self:yuchuan2_yuchuan3() end
	self.alias_table["yuchuan2_yuchuan3"]=alias_item

	alias_item={}
	alias_item.name="zishanlin"
	alias_item.dir="n"
	alias_item.range=1
	alias_item.alias=function() self:zishanlin() end
	self.alias_table["zishanlin"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_tiandifenglei"
	alias_item.dir="n"
	alias_item.range=10
	alias_item.alias=function() self:zishanlin_tiandifenglei() end
	self.alias_table["zishanlin_tiandifenglei"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_out"
	alias_item.dir="se"
	alias_item.alias=function() self:tiandifenglei_out() end
	self.alias_table["tiandifenglei_out"]=alias_item

	alias_item={}
	alias_item.name="changlang_huanglongdong"
	alias_item.dir="e"
	alias_item.alias=function() self:changlang_huanglongdong() end
	self.alias_table["changlang_huanglongdong"]=alias_item

	alias_item={}
	alias_item.name="baishilu_songshuyuan"
	alias_item.alias=function() self:baishilu_songshuyuan() end
	self.alias_table["baishilu_songshuyuan"]=alias_item

	alias_item={}
	alias_item.name="xiaodaobian_matou"
	alias_item.dir="w"
	alias_item.alias=function() self:xiaodaobian_matou() end
	self.alias_table["xiaodaobian_matou"]=alias_item


	alias_item={}
	alias_item.name="beimenbingying_jianyu"
	alias_item.dir="w"
	alias_item.alias=function() self:beimenbingying_jianyu() end
	self.alias_table["beimenbingying_jianyu"]=alias_item

	alias_item={}
	alias_item.name="holdteng"
	alias_item.dir="ne"
	alias_item.alias=function() self:holdteng() end
	self.alias_table["holdteng"]=alias_item

	alias_item={}
	alias_item.name="liehuo_luoye"
	alias_item.dir="se"
	alias_item.alias=function() self:liehuo_luoye() end
	self.alias_table["liehuo_luoye"]=alias_item

	alias_item={}
	alias_item.name="luoye_jixue"
	alias_item.dir="se"
	alias_item.alias=function() self:luoye_jixue() end
	self.alias_table["luoye_jixue"]=alias_item

	alias_item={}
	alias_item.name="jixue_kuoye"
	alias_item.dir="se"
	alias_item.alias=function() self:jixue_kuoye() end
	self.alias_table["jixue_kuoye"]=alias_item

	alias_item={}
	alias_item.name="kuoye_conglin"
	alias_item.dir="se"
	alias_item.alias=function() self:kuoye_conglin() end
	self.alias_table["kuoye_conglin"]=alias_item

	alias_item={}
	alias_item.name="luoye_liehuo"
	alias_item.dir="nw"
	alias_item.alias=function() self:luoye_liehuo() end
	self.alias_table["luoye_liehuo"]=alias_item

	alias_item={}
	alias_item.name="jixue_luoye"
	alias_item.dir="nw"
	alias_item.alias=function() self:jixue_luoye() end
	self.alias_table["jixue_luoye"]=alias_item

	alias_item={}
	alias_item.name="kuoye_jixue"
	alias_item.dir="nw"
	alias_item.alias=function() self:kuoye_jixue() end
	self.alias_table["kuoye_jixue"]=alias_item

	alias_item={}
	alias_item.name="jump_river"
	alias_item.dir="sw"
	alias_item.alias=function() self:jump_river() end
	self.alias_table["jump_river"]=alias_item

	alias_item={}
	alias_item.name="push_grass"
	alias_item.dir="e"
	alias_item.alias=function() self:push_grass() end
	self.alias_table["push_grass"]=alias_item

	alias_item={}
	alias_item.name="liehuo_liehuo"
	alias_item.dir="e"
	alias_item.alias=function() self:liehuo() end
	self.alias_table["liehuo_liehuo"]=alias_item

	alias_item={}
	alias_item.name="luoye_luoye"
	alias_item.dir="e"
	alias_item.alias=function() self:luoye() end
	self.alias_table["luoye_luoye"]=alias_item

	alias_item={}
	alias_item.name="jixue_jixue"
	alias_item.dir="e"
	alias_item.alias=function() self:jixue() end
	self.alias_table["jixue_jixue"]=alias_item

	alias_item={}
	alias_item.name="kuoye_kuoye"
	alias_item.dir="e"
	alias_item.alias=function() self:kuoye() end
	self.alias_table["kuoye_kuoye"]=alias_item

	alias_item={}
	alias_item.name="qianting_shilu"
	alias_item.dir="s"
	alias_item.alias=function() self:qianting_shilu() end
	self.alias_table["qianting_shilu"]=alias_item

	alias_item={}
	alias_item.name="zuan_didao"
	alias_item.dir="nw"
	alias_item.alias=function() self:zuan_didao() end
	self.alias_table["zuan_didao"]=alias_item

	alias_item={}
	alias_item.name="push_qiaolan"
	alias_item.dir="se"
	alias_item.alias=function() self:push_qiaolan() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="shanlu_shanzhongxiaoxi"
	alias_item.alias=function() self:shanlu_shanzhongxiaoxi() end
	self.alias_table["shanlu_shanzhongxiaoxi"]=alias_item

	alias_item={}
	alias_item.name="noway"
	alias_item.dir=nil
	alias_item.alias=function() self:noway() end
	self.alias_table["noway"]=alias_item

	alias_item={}
	alias_item.name="chanyan_shidao"
	alias_item.dir="n"
	alias_item.alias=function() self:chanyan_shidao() end
	self.alias_table["chanyan_shidao"]=alias_item

	alias_item={}
	alias_item.name="shandao_shanjin"
	alias_item.dir="ne"
	alias_item.alias=function() self:shandao_shanjin() end
	self.alias_table["shandao_shanjin"]=alias_item

	alias_item={}
	alias_item.name="tou_conglin"
	alias_item.dir="se"
	alias_item.alias=function() self:tou_conglin() end
	self.alias_table["tou_conglin"]=alias_item

	alias_item={}
	alias_item.name="juyiting_shenhuotang"
	alias_item.dir="n"
	alias_item.alias=function() self:juyiting_shenhuotang() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="juyiting_longwangdian"
	alias_item.dir="w"
	alias_item.alias=function() self:juyiting_longwangdian() end
	self.alias_table["juyiting_longwangdian"]=alias_item

	alias_item={}
	alias_item.name="yamenzhenting_fuyahouyuan"
	alias_item.dir="nw"
	alias_item.alias=function() self:yamenzhenting_fuyahouyuan() end
	self.alias_table["yamenzhenting_fuyahouyuan"]=alias_item

	alias_item={}
	alias_item.name="opendoorenter"
	alias_item.dir="ne"
	alias_item.alias=function() self:opendoorenter() end
	self.alias_table["opendoorenter"]=alias_item

	alias_item={}
	alias_item.name="changjinggeyilou_changjinggeerlou"
	alias_item.dir="n"
	alias_item.alias=function() self:changjinggeyilou_changjinggeerlou() end
	self.alias_table["changjinggeyilou_changjinggeerlou"]=alias_item

	alias_item={}
	alias_item.name="yunshanlin2_yunshanlin1"
	alias_item.dir="sw"
	alias_item.alias=function() self:yunshanlin2_yunshanlin1() end
	self.alias_table["yunshanlin2_yunshanlin1"]=alias_item

	alias_item={}
	alias_item.name="xiaojing2_xiaojing1"
	alias_item.dir="n"
	alias_item.range=5
	alias_item.alias=function() self:xiaojing2_xiaojing1() end
	self.alias_table["xiaojing2_xiaojing1"]=alias_item

	alias_item={}
	alias_item.name="xiaojing2_yuanmen"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:xiaojing2_yuanmen() end
	self.alias_table["xiaojing2_yuanmen"]=alias_item

	alias_item={}
	alias_item.name="xiaojing_dongxiangzoulang"
	alias_item.dir="e"
	alias_item.alias=function() self:xiaojing_dongxiangzoulang() end
	self.alias_table["xiaojing_dongxiangzoulang"]=alias_item

	alias_item={}
	alias_item.name="xiaojing_xixiangzoulang"
	alias_item.dir="w"
	alias_item.alias=function() self:xiaojing_xixiangzoulang() end
	self.alias_table["xiaojing_xixiangzoulang"]=alias_item

	alias_item={}
	alias_item.name="xiaojing_xiaojing1"
	alias_item.dir="n"
	alias_item.alias=function() self:xiaojing_xiaojing1() end
	self.alias_table["xiaojing_xiaojing1"]=alias_item

	alias_item={}
	alias_item.name="songshulin2_songshulin1"
	alias_item.dir="s"
	alias_item.alias=function() self:songshulin2_songshulin1() end
	self.alias_table["songshulin2_songshulin1"]=alias_item


	alias_item={}
	alias_item.name="songshulin2_songshulin3"
	alias_item.dir="n"
	alias_item.alias=function() self:songshulin2_songshulin3() end
	self.alias_table["songshulin2_songshulin3"]=alias_item

	alias_item={}
	alias_item.name="zoulang_lianwuchang"
	alias_item.dir="s"
	alias_item.alias=function() self:zoulang_lianwuchang() end
	self.alias_table["zoulang_lianwuchang"]=alias_item

	alias_item={}
	alias_item.name="haibing_taohuadao"
	alias_item.dir="ne"
	alias_item.alias=function() self:haibing_taohuadao() end
	self.alias_table["haibing_taohuadao"]=alias_item

	alias_item={}
	alias_item.name="leave_taohuadao"
	alias_item.dir="sw"
	alias_item.alias=function() self:leave_taohuadao() end
	self.alias_table["leave_taohuadao"]=alias_item

	alias_item={}
	alias_item.name="out_graveyard"
	alias_item.dir="s"
	alias_item.alias=function() self:out_graveyard() end
	self.alias_table["out_graveyard"]=alias_item

	alias_item={}
	alias_item.name="shufang_jiabi"
	alias_item.dir="n"
	alias_item.alias=function() self:shufang_jiabi() end
	self.alias_table["shufang_jiabi"]=alias_item

	alias_item={}
	alias_item.name="jiabi_shufang"
	alias_item.dir="s"
	alias_item.alias=function() self:jiabi_shufang() end
	self.alias_table["jiabi_shufang"]=alias_item

	alias_item={}
	alias_item.name="dapubu_bailongfeng"
	alias_item.dir="se"
	alias_item.alias=function() self:dapubu_bailongfeng() end
	self.alias_table["dapubu_bailongfeng"]=alias_item

	alias_item={}
	alias_item.name="jianhugong_xilianwuchang"
	alias_item.dir="w"
	alias_item.alias=function() self:jianhugong_xilianwuchang() end
	self.alias_table["jianhugong_xilianwuchang"]=alias_item

	alias_item={}
	alias_item.name="jianhugong_donglianwuchang"
	alias_item.dir="e"
	alias_item.alias=function() self:jianhugong_donglianwuchang() end
	self.alias_table["jianhugong_donglianwuchang"]=alias_item

	alias_item={}
	alias_item.name="jianhugong_houyuan"
	alias_item.dir="n"
	alias_item.alias=function() self:jianhugong_houyuan() end
	self.alias_table["jianhugong_houyuan"]=alias_item

	alias_item={}
	alias_item.name="shimen_riyuepin"
	alias_item.dir="w"
	alias_item.alias=function() self:shimen_riyuepin() end
	self.alias_table["shimen_riyuepin"]=alias_item

	alias_item={}
	alias_item.name="riyuepin_yading"
	alias_item.dir="n"
	alias_item.alias=function() self:riyuepin_yading() end
	self.alias_table["riyuepin_yading"]=alias_item

	alias_item={}
	alias_item.name="yading_riyuepin"
	alias_item.dir="s"
	alias_item.alias=function() self:yading_riyuepin() end
	self.alias_table["yading_riyuepin"]=alias_item

	alias_item={}
	alias_item.name="unwield_east"
	alias_item.dir="e"
	alias_item.alias=function() self:unwield_east() end
	self.alias_table["unwield_east"]=alias_item

	alias_item={}
	alias_item.name="unwield_west"
	alias_item.dir="w"
	alias_item.alias=function() self:unwield_west() end
	self.alias_table["unwield_west"]=alias_item

	alias_item={}
	alias_item.name="unwield_north"
	alias_item.dir="n"
	alias_item.alias=function() self:unwield_north() end
	self.alias_table["unwield_north"]=alias_item

    alias_item={}
	alias_item.name="rimulundian_yueliangmen"
	alias_item.alias=function() self:rimulundian_yueliangmen() end
	self.alias_table["rimulundian_yueliangmen"]=alias_item

	alias_item={}
	alias_item.name="rimulundian_zhaitang"
	alias_item.dir="se"
	alias_item.alias=function() self:rimulundian_zhaitang() end
	self.alias_table["rimulundian_zhaitang"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_feng"
	alias_item.dir="se"
	alias_item.alias=function() self:tiandifenglei_feng() end
	self.alias_table["tiandifenglei_feng"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_lei"
	alias_item.dir="sw"
	alias_item.alias=function() self:tiandifenglei_lei() end
	self.alias_table["tiandifenglei_lei"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_tian"
	alias_item.dir="nw"
	alias_item.alias=function() self:tiandifenglei_tian() end
	self.alias_table["tiandifenglei_tian"]=alias_item

	alias_item={}
	alias_item.name="tiandifenglei_di"
	alias_item.dir="ne"
	alias_item.alias=function() self:tiandifenglei_di() end
	self.alias_table["tiandifenglei_di"]=alias_item

	alias_item={}
	alias_item.name="songlin1_songlin2"
	alias_item.dir="w"
	alias_item.alias=function() self:songlin1_songlin2() end
	self.alias_table["songlin1_songlin2"]=alias_item

	alias_item={}
	alias_item.name="songlin2_songlin1"
	alias_item.dir="e"
	alias_item.alias=function() self:songlin2_songlin1() end
	self.alias_table["songlin2_songlin1"]=alias_item

	alias_item={}
	alias_item.name="halt_northwest"
	alias_item.dir="nw"
	alias_item.alias=function() self:halt_northwest() end
	self.alias_table["halt_northwest"]=alias_item

	alias_item={}
	alias_item.name="out_zhulin_shuitang"
	alias_item.dir="nw"
	alias_item.alias=function() self:out_zhulin_shuitang() end
	self.alias_table["out_zhulin_shuitang"]=alias_item

	alias_item={}
	alias_item.name="out_zhulin_shanjianpingdi"
	alias_item.dir="se"
	alias_item.alias=function() self:out_zhulin_shanjianpingdi() end
	self.alias_table["out_zhulin_shanjianpingdi"]=alias_item

	alias_item={}
	alias_item.name="shanjianpingdi_shuitang"
	alias_item.dir="n"
	alias_item.alias=function() self:shanjianpingdi_shuitang() end
	self.alias_table["shanjianpingdi_shuitang"]=alias_item

	alias_item={}
	alias_item.name="clg_ysl"
	alias_item.dir="n"
	alias_item.alias=function() self:clg_ysl() end
	self.alias_table["clg_ysl"]=alias_item


	alias_item={}
	alias_item.name="shuitang_shanjianpingdi"
	alias_item.dir="s"
	alias_item.alias=function() self:shuitang_shanjianpingdi() end
	self.alias_table["shuitang_shanjianpingdi"]=alias_item

	alias_item={}
	alias_item.name="xiaoxi_dufengling"
	alias_item.dir="ne"
	alias_item.alias=function() self:xiaoxi_dufengling() end
	self.alias_table["xiaoxi_dufengling"]=alias_item

	alias_item={}
	alias_item.name="dufengling_xiaoxi"
	alias_item.dir="sw"
	alias_item.alias=function() self:dufengling_xiaoxi() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="fuyaqianting_situtang"
	alias_item.dir="e"
	alias_item.alias=function() self:fuyaqianting_situtang() end
	self.alias_table["fuyaqianting_situtang"]=alias_item

	alias_item={}
	alias_item.name="fuyaqianting_sikongtang"
	alias_item.dir="n"
	alias_item.alias=function() self:fuyaqianting_sikongtang() end
	self.alias_table["fuyaqianting_sikongtang"]=alias_item

	alias_item={}
	alias_item.name="fuyaqianting_simatang"
	alias_item.dir="w"
	alias_item.alias=function() self:fuyaqianting_simatang() end
	self.alias_table["fuyaqianting_simatang"]=alias_item

	alias_item={}
	alias_item.name="changlemen_dongmenchenglou"
	alias_item.dir="e"
	alias_item.alias=function() self:changlemen_dongmenchenglou() end
	self.alias_table["changlemen_dongmenchenglou"]=alias_item

	alias_item={}
	alias_item.name="anyuanmen_beimenchenglou"
	alias_item.dir="n"
	alias_item.alias=function() self:anyuanmen_beimenchenglou() end
	self.alias_table["anyuanmen_beimenchenglou"]=alias_item

	alias_item={}
	alias_item.name="yongningmen_nanmenchenglou"
	alias_item.dir="s"
	alias_item.alias=function() self:yongningmen_nanmenchenglou() end
	self.alias_table["yongningmen_nanmenchenglou"]=alias_item

	alias_item={}
	alias_item.name="andingmen_ximenchenglou"
	alias_item.dir="w"
	alias_item.alias=function() self:andingmen_ximenchenglou() end
	self.alias_table["andingmen_ximenchenglou"]=alias_item

	alias_item={}
	alias_item.name="enter_zhulin"
	alias_item.dir="n"
	alias_item.alias=function() self:enter_zhulin() end
	self.alias_table["enter_zhulin"]=alias_item

	alias_item={}
	alias_item.name="xixiangchibian_xixiangchibian"
	alias_item.dir="n"
	alias_item.alias=function() self:xixiangchibian_xixiangchibian() end
	self.alias_table["xixiangchibian_xixiangchibian"]=alias_item

	alias_item={}
	alias_item.name="changlang_guifang"
	alias_item.dir="e"
	alias_item.alias=function() self:changlang_guifang() end
	self.alias_table["changlang_guifang"]=alias_item

	alias_item={}
	alias_item.name="xiaodao_shatan2"
	alias_item.dir="sw"
	alias_item.alias=function() self:xiaodao_shatan2() end
	self.alias_table["xiaodao_shatan2"]=alias_item

	alias_item={}
	alias_item.name="zoulang_xixiangzoulang"
	alias_item.dir="w"
	alias_item.alias=function() self:zoulang_xixiangzoulang() end
	self.alias_table["zoulang_xixiangzoulang"]=alias_item

    alias_item={}
	alias_item.name="hjxl_bhg"
	alias_item.dir="n"
	alias_item.alias=function() self:hjxl_bhg() end
	self.alias_table["hjxl_bhg"]=alias_item

	alias_item={}
	alias_item.name="zoulang_liangongfang"
	alias_item.dir="n"
	alias_item.alias=function() self:zoulang_liangongfang() end
	self.alias_table["zoulang_liangongfang"]=alias_item

	alias_item={}
	alias_item.name="zoulang_dongxiangzoulang"
	    alias_item.dir="e"
	alias_item.alias=function() self:zoulang_dongxiangzoulang() end
	self.alias_table["zoulang_dongxiangzoulang"]=alias_item

	alias_item={}
	alias_item.name="xiaowu_liwu"
	alias_item.dir="ne"
	alias_item.alias=function() self:xiaowu_liwu() end
	self.alias_table["xiaowu_liwu"]=alias_item

	alias_item={}
	alias_item.name="dating_houtang"
	 alias_item.dir="n"
	alias_item.alias=function() self:dating_houtang() end
	self.alias_table["dating_houtang"]=alias_item

	alias_item={}
	alias_item.name="dashiwu_dating"
	 alias_item.dir="ne"
	alias_item.alias=function() self:dashiwu_dating() end
	self.alias_table["dashiwu_dating"]=alias_item

	alias_item={}
	alias_item.name="jump_back"
	alias_item.dir="sw"
	alias_item.alias=function() self:jump_back() end
	self.alias_table["jump_back"]=alias_item

	alias_item={}
	alias_item.name="jump_qiaobi"
	alias_item.dir="ne"
	alias_item.alias=function() self:jump_qiaobi() end
	self.alias_table["jump_qiaobi"]=alias_item

	alias_item={}
	alias_item.name="xiao"
	alias_item.dir=nil
	alias_item.range=20
	alias_item.alias=function() self:xiao() end
	self.alias_table["xiao"]=alias_item

	alias_item={}
	alias_item.name="yell_tengkuang"
	alias_item.dir="n"
	alias_item.alias=function() self:yell_tengkuang() end
	self.alias_table["yell_tengkuang"]=alias_item

	alias_item={}
	alias_item.name="miaofadian_cangjingge"
	alias_item.dir="s"
	alias_item.alias=function() self:miaofadian_cangjingge() end
	self.alias_table["miaofadian_cangjingge"]=alias_item

	alias_item={}
	alias_item.name="gufoshelita_talin"
	alias_item.dir="se"
	alias_item.alias=function() self:gufoshelita_talin() end
	self.alias_table["gufoshelita_talin"]=alias_item

	alias_item={}
	alias_item.name="talin_gufoshelita"
	alias_item.dir="nw"
	alias_item.alias=function() self:talin_gufoshelita() end
	self.alias_table["talin_gufoshelita"]=alias_item

	alias_item={}
	alias_item.name="majiu_houshanxiaojing"
	alias_item.dir="n"
	alias_item.alias=function() self:majiu_houshanxiaojing() end
	self.alias_table["majiu_houshanxiaojing"]=alias_item

	alias_item={}
	alias_item.name="houshanxiaolu_guanmucong"
	alias_item.dir="nw"
	alias_item.alias=function() self:houshanxiaolu_guanmucong() end
	self.alias_table["houshanxiaolu_guanmucong"]=alias_item

	alias_item={}
	alias_item.name="guamucong_dongkou"
	alias_item.dir="e"
	alias_item.alias=function() self:guamucong_dongkou() end
	self.alias_table["guamucong_dongkou"]=alias_item

	alias_item={}
	alias_item.name="huilang2_huilang1"
	alias_item.dir="w"
	alias_item.alias=function() self:huilang2_huilang1() end
	self.alias_table["huilang2_huilang1"]=alias_item

	alias_item={}
	alias_item.name="huilang1_huilang2"
	alias_item.dir="e"
	alias_item.alias=function() self:huilang1_huilang2() end
	self.alias_table["huilang1_huilang2"]=alias_item

	alias_item={}
	alias_item.name="guanmucong_out"
	alias_item.dir="se"
	alias_item.alias=function() self:guanmucong_out() end
	self.alias_table["guanmucong_out"]=alias_item

    alias_item={}
	alias_item.name="yuanmen_xiaoyuan"
	alias_item.dir="s"
	alias_item.alias=function() self:yuanmen_houshanxiaoyuan() end
	self.alias_table["yuanmen_xiaoyuan"]=alias_item

	alias_item={}
	alias_item.name="movestone"
		alias_item.dir="n"
	alias_item.alias=function() self:movestone() end
	self.alias_table["movestone"]=alias_item

	alias_item={}
	alias_item.name="laofang_dilao"
	alias_item.dir="s"
	alias_item.alias=function() self:laofang_dilao() end
	self.alias_table["laofang_dilao"]=alias_item

	alias_item={}
	alias_item.name="changlang_chufang"
	alias_item.dir="e"
	alias_item.alias=function() self:changlang_chufang() end
	self.alias_table["changlang_chufang"]=alias_item

	alias_item={}
	alias_item.name="xiaoting_chufang"
	alias_item.dir="n"
	alias_item.alias=function() self:xiaoting_chufang() end
	self.alias_table["xiaoting_chufang"]=alias_item

	alias_item={}
	alias_item.name="sajiafatang_fatangerlou"
	alias_item.dir="n"
	alias_item.alias=function() self:sajiafatang_fatangerlou() end
	self.alias_table["sajiafatang_fatangerlou"]=alias_item

	alias_item={}
	alias_item.name="shanlu2_shanlu1"
	alias_item.dir="s"
	alias_item.alias=function() self:shanlu2_shanlu1() end
	self.alias_table["shanlu2_shanlu1"]=alias_item

	alias_item={}
	alias_item.name="shanlu1_shanlu2"
		alias_item.dir="n"
	alias_item.alias=function() self:shanlu1_shanlu2() end
	self.alias_table["shanlu1_shanlu2"]=alias_item

	alias_item={}
	alias_item.name="jiechiyuan_jingshi"
			alias_item.dir="s"
	alias_item.alias=function() self:jiechiyuan_jingshi() end
	self.alias_table["jiechiyuan_jingshi"]=alias_item

	alias_item={}
	alias_item.name="tieqingju_woshi"
		alias_item.dir="w"
	alias_item.alias=function() self:tieqingju_woshi() end
	self.alias_table["tieqingju_woshi"]=alias_item

	alias_item={}
	alias_item.name="block_eastup"
		alias_item.dir="e"
	alias_item.alias=function() self:block_eastup() end
	self.alias_table["block_eastup"]=alias_item

	alias_item={}
	alias_item.name="block_westup"
		alias_item.dir="w"
	alias_item.alias=function() self:block_westup() end
	self.alias_table["block_westup"]=alias_item

	alias_item={}
	alias_item.name="shushang"
		alias_item.dir="s"
	alias_item.alias=function() self:shushang() end
	self.alias_table["shushang"]=alias_item

	alias_item={}
	alias_item.name="dadukou_shenlongdao"
	alias_item.dir="ne"
	alias_item.alias=function() self:dadukou_shenlongdao() end
	self.alias_table["dadukou_shenlongdao"]=alias_item

	alias_item={}
	alias_item.name="shenlongdao_dadukou"
	alias_item.dir="sw"
	alias_item.alias=function() self:shenlongdao_dadukou() end
	self.alias_table["shenlongdao_dadukou"]=alias_item

	alias_item={}
	alias_item.name="songlin_longshuyuan"
	alias_item.dir="n"
	alias_item.range=6
	alias_item.alias=function() self:songlin_longshuyuan() end
	self.alias_table["songlin_longshuyuan"]=alias_item

	alias_item={}
	alias_item.name="songlin_shibanlu"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:songlin_shibanlu() end
	self.alias_table["songlin_shibanlu"]=alias_item

	alias_item={}
	alias_item.name="zuanshulin"
	alias_item.dir="ne"
	alias_item.alias=function() self:zuanshulin() end
	self.alias_table["zuanshulin"]=alias_item

	alias_item={}
	alias_item.name="fanyinge_fotang"
	alias_item.dir="nw"
	alias_item.alias=function() self:fanyinge_fotang() end
	self.alias_table["fanyinge_fotang"]=alias_item

	alias_item={}
	alias_item.name="shanjian_longtan"
	alias_item.dir="w"
	alias_item.alias=function() self:shanjian_longtan() end
	self.alias_table["shanjian_longtan"]=alias_item

	alias_item={}
	alias_item.name="shidao_xiaoyaodong"
	alias_item.dir="nw"
	alias_item.alias=function() self:shidao_xiaoyaodong() end
	self.alias_table["shidao_xiaoyaodong"]=alias_item

	alias_item={}
	alias_item.name="keting_xiangfang"
	alias_item.dir="e"
	alias_item.alias=function() self:keting_xiangfang() end
	self.alias_table["keting_xiangfang"]=alias_item

	alias_item={}
	alias_item.name="yamendating_yamenzhengting"
	alias_item.dir="n"
	alias_item.alias=function() self:yamendating_yamenzhengting() end
	self.alias_table["yamendating_yamenzhengting"]=alias_item

	alias_item={}
	alias_item.name="shanbi_huacong"
	alias_item.dir="n"
	alias_item.alias=function() self:shanbi_huacong() end
	self.alias_table["shanbi_huacong"]=alias_item

	alias_item={}
	alias_item.name="maowu_hetang"
	alias_item.dir="w"
	alias_item.alias=function() self:maowu_hetang() end
	self.alias_table["maowu_hetang"]=alias_item

	alias_item={}
	alias_item.name="hetang_maowu"
	alias_item.dir="e"
	alias_item.alias=function() self:hetang_maowu() end
	self.alias_table["hetang_maowu"]=alias_item

	alias_item={}
	alias_item.name="dierzhijie_shandong"
	alias_item.dir="ne"
	alias_item.alias=function() self:dierzhijie_shandong() end
	self.alias_table["dierzhijie_shandong"]=alias_item

	alias_item={}
	alias_item.name="changzhouyayi_fuyazhenting"
	alias_item.dir="w"
	alias_item.alias=function() self:changzhouyayi_fuyazhenting() end
	self.alias_table["changzhouyayi_fuyazhenting"]=alias_item

	alias_item={}
	alias_item.name="xidajie_mingyufang"
	alias_item.dir="n"
	alias_item.alias=function() self:xidajie_mingyufang() end
	self.alias_table["xidajie_mingyufang"]=alias_item

	alias_item={}
	alias_item.name="zhulin_damodong"
	alias_item.dir="n"
	alias_item.alias=function() self:zhulin_damodong() end
	self.alias_table["zhulin_damodong"]=alias_item

	alias_item={}
	alias_item.name="xiaofudamen_xiaofudating"
	alias_item.dir="n"
	alias_item.alias=function() self:xiaofudamen_xiaofudating() end
	self.alias_table["xiaofudamen_xiaofudating"]=alias_item

	alias_item={}
	alias_item.name="yugangmatou_chuancang"
	alias_item.dir=nil
	alias_item.alias=function() self:yugangmatou_chuancang() end
	self.alias_table["yugangmatou_chuancang"]=alias_item

	alias_item={}
	alias_item.name="chuancang_yugangmatou"
	alias_item.dir=nil
	alias_item.alias=function() self:chuancang_yugangmatou() end
	self.alias_table["chuancang_yugangmatou"]=alias_item

	alias_item={}
	alias_item.name="bingying_wuqiku"
	alias_item.dir="s"
	alias_item.alias=function() self:bingying_wuqiku() end
	self.alias_table["bingying_wuqiku"]=alias_item

	--[[alias_item={}
	alias_item.name="sichouzhilu_caoyuanbianyuan"
	alias_item.dir=nil
	alias_item.alias=function() self:sichouzhilu_caoyuanbianyuan() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="caoyuanbianyuan_sichouzhilu"
	alias_item.dir=nil
	alias_item.alias=function()
	   --print("register why:",this.id)
	   self:caoyuanbianyuan_sichouzhilu()
	end
	self.alias_table[alias_item.name]=alias_item]]

	--[[alias_item={}
	alias_item.name="longshuyuan_shibanlu"
	alias_item.dir=nil
	alias_item.alias=function() self:longshuyuan_shibanlu() end
	self.alias_table[alias_item.name]=alias_item

	alias_item={}
	alias_item.name="shibanlu_longshuyuan"
		alias_item.dir=nil
	alias_item.alias=function() self:shibanlu_longshuyuan() end
	self.alias_table[alias_item.name]=alias_item]]

	alias_item={}
	alias_item.name="xiangyangshulin_circle"
	alias_item.dir=nil
	alias_item.alias=function() self:xiangyangshulin_circle() end
	self.alias_table["xiangyangshulin_circle"]=alias_item

	--百丈涧

	alias_item={}
	alias_item.name="baizhangjian_south"
	alias_item.dir="s"
	alias_item.alias=function() self:baizhangjian_south() end
	self.alias_table["baizhangjian_south"]=alias_item

	alias_item={}
	alias_item.name="shanjiao_shanlu"
	alias_item.dir="n"
	alias_item.alias=function() self:shanjiao_shanlu() end
	self.alias_table["shanjiao_shanlu"]=alias_item

	alias_item={}
	alias_item.name="chuwujian_cangjinglou"
	alias_item.dir="n"
	alias_item.alias=function() self:chuwujian_cangjinglou() end
	self.alias_table["chuwujian_cangjinglou"]=alias_item

	alias_item={}
	alias_item.name="guangfobaodian_songshuyuan"
	alias_item.dir="n"
	alias_item.alias=function() self:guangfobaodian_songshuyuan() end
	self.alias_table["guangfobaodian_songshuyuan"]=alias_item

	alias_item={}
	alias_item.name="dangtianmen_xiuxishi"
	alias_item.dir="s"
	alias_item.alias=function() self:dangtianmen_xiuxishi() end
	self.alias_table["dangtianmen_xiuxishi"]=alias_item

	alias_item={}
	alias_item.name="zoulang_shufang"
	alias_item.dir="n"
	alias_item.alias=function() self:zoulang_shufang() end
	self.alias_table["zoulang_shufang"]=alias_item

	alias_item={}
	alias_item.name="yitiantulong"
	alias_item.dir="s"
	alias_item.alias=function() self:yitiantulong() end
	self.alias_table["yitiantulong"]=alias_item

	alias_item={}
	alias_item.name="zuan"
	alias_item.dir="s"
	alias_item.alias=function() self:zuan() end
	self.alias_table["zuan"]=alias_item

	alias_item={}
	alias_item.name="zhenting_houmen"
	alias_item.dir="s"
	alias_item.alias=function() self:zhenting_houmen() end
	self.alias_table["zhenting_houmen"]=alias_item

	alias_item={}
	alias_item.name="special_east"
	alias_item.dir="e"
	alias_item.alias=function() self:special_east() end
	self.alias_table["special_east"]=alias_item

	alias_item={}
	alias_item.name="yamendamen_yamenzhengting"
	alias_item.dir="n"
	alias_item.alias=function() self:yamendamen_yamenzhengting() end
	self.alias_table["yamendamen_yamenzhengting"]=alias_item

	alias_item={}
	alias_item.name="zhendaoyuan_chanfang"
	alias_item.dir="w"
	alias_item.alias=function() self:zhendaoyuan_chanfang() end
	self.alias_table["zhendaoyuan_chanfang"]=alias_item

	alias_item={}
	alias_item.name="xilianwuchang_shibanlu"
	alias_item.dir="w"
	alias_item.alias=function() self:xilianwuchang_shibanlu() end
	self.alias_table["xilianwuchang_shibanlu"]=alias_item

	alias_item={}
	alias_item.name="xidajie_shouxihujiulou"
	alias_item.dir="n"
	alias_item.alias=function() self:xidajie_shouxihujiulou() end
	self.alias_table["xidajie_shouxihujiulou"]=alias_item

	alias_item={}
	alias_item.name="xidajie_shoushidian"
	alias_item.dir="s"
	alias_item.alias=function() self:xidajie_shoushidian() end
	self.alias_table["xidajie_shoushidian"]=alias_item

	alias_item={}
	alias_item.name="duanyaping_yading"
	alias_item.dir="n"
	alias_item.alias=function() self:duanyaping_yading() end
	self.alias_table["duanyaping_yading"]=alias_item

	alias_item={}
	alias_item.name="zishanlin_tiandifenglei_quick"
	alias_item.dir="n"
	alias_item.range=10
	alias_item.alias=function() self:zishanlin_tiandifenglei_quick() end
	self.alias_table["zishanlin_tiandifenglei_quick"]=alias_item

	alias_item={}
	alias_item.name="t_leave"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:t_leave() end
	self.alias_table["t_leave"]=alias_item

	alias_item={}
	alias_item.name="huigong"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:huigong() end
	self.alias_table["huigong"]=alias_item

	alias_item={}
	alias_item.name="push_door"
	alias_item.dir="s"
	alias_item.range=10
	alias_item.alias=function() self:push_door() end
	self.alias_table["push_door"]=alias_item

	alias_item={}
	alias_item.name="climb_shanlu"
	alias_item.dir="n"
	alias_item.range=10
	alias_item.alias=function() self:climb_shanlu() end
	self.alias_table["climb_shanlu"]=alias_item

	alias_item={}
	alias_item.name="female_south"
	alias_item.dir="s"
	alias_item.alias=function() self:female_south() end
	self.alias_table["female_south"]=alias_item


	alias_item={}
	alias_item.name="d_west"
	alias_item.dir="w"
	alias_item.alias=function() self:d_west() end
	self.alias_table["d_west"]=alias_item

	alias_item={}
	alias_item.name="east_zishanlin_tiandifenglei_quick"
	alias_item.dir="e"
	alias_item.alias=function()
     	 world.Send("east")
	    self:zishanlin_tiandifenglei_quick()
	end
	self.alias_table["east_zishanlin_tiandifenglei_quick"]=alias_item

	alias_item={}
	alias_item.name="west_zishanlin_tiandifenglei_quick"
	alias_item.dir="w"
	alias_item.alias=function()
	   world.Send("west")
	   self:zishanlin_tiandifenglei_quick()
	end
	self.alias_table["west_zishanlin_tiandifenglei_quick"]=alias_item

	alias_item={}
	alias_item.name="siguoya_jiashanbi"
	alias_item.dir="w"
	alias_item.alias=function()
	   self:siguoya_jiashanbi()
	end
	self.alias_table["siguoya_jiashanbi"]=alias_item

	alias_item={}
	alias_item.name="huapu_caojing"
	alias_item.dir="n"
	alias_item.alias=function()
	   self:huapu_caojing()
	end
	self.alias_table["huapu_caojing"]=alias_item

	alias_item={}
	alias_item.name="huapu_niupeng"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:huapu_niupeng()
	end
	self.alias_table["huapu_niupeng"]=alias_item

	alias_item={}
	alias_item.name="caojing_niupeng"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:caojing_niupeng()
	end
	self.alias_table["caojing_niupeng"]=alias_item

	alias_item={}
	alias_item.name="niupeng_caojing"
	alias_item.dir="n"
	alias_item.alias=function()
	   self:niupeng_caojing()
	end
	self.alias_table["niupeng_caojing"]=alias_item

	alias_item={}
	alias_item.name="push_flag"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:push_flag()
	end
	self.alias_table["push_flag"]=alias_item

    alias_item={}
	alias_item.name="nanjiangshamo_tuyuhun"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:nanjiangshamo_tuyuhun()
	end
	alias_item.range=5
	self.alias_table["nanjiangshamo_tuyuhun"]=alias_item

	alias_item={}
	alias_item.name="danfang_eyutan"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:danfang_eyutan()
	end
	alias_item.range=1
	self.alias_table["danfang_eyutan"]=alias_item

	alias_item={}
	alias_item.name="ta_corpse"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:ta_corpse()
	end
	alias_item.range=1
	self.alias_table["ta_corpse"]=alias_item

   	alias_item={}
	alias_item.name="enter_dong"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:enter_dong()
	end
	alias_item.range=1
	self.alias_table["enter_dong"]=alias_item

	alias_item={}
	alias_item.name="climb_down"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:climb_down()
	end
	alias_item.range=1
	self.alias_table["climb_down"]=alias_item

	alias_item={}
	alias_item.name="shiku_shibi"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:shiku_shibi()
	end
	alias_item.range=1
	self.alias_table["shiku_shibi"]=alias_item

	alias_item={}
	alias_item.name="enter_meizhuang"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:enter_meizhuang()
	end
	alias_item.range=30
	self.alias_table["enter_meizhuang"]=alias_item

	alias_item={}
	alias_item.name="out_meizhuang"
	alias_item.dir="n"
	alias_item.alias=function()
	   self:out_meizhuang()
	end
	alias_item.range=30
	self.alias_table["out_meizhuang"]=alias_item

	alias_item={}
	alias_item.name="shibi_liguifeng"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:shibi_liguifeng()
	end
	alias_item.range=1
	self.alias_table["shibi_liguifeng"]=alias_item

	alias_item={}
	alias_item.name="shiguoya_shiguoyadongkou"
	alias_item.dir="w"
	alias_item.alias=function()
	   self:shiguoya_shiguoyadongkou()
	end
	alias_item.range=1
	self.alias_table["shiguoya_shiguoyadongkou"]=alias_item


	alias_item={}
	alias_item.name="qingyunpin_fumoquan"
	alias_item.dir="e"
	alias_item.alias=function()
	   self:qingyunpin_fumoquan()
	end
	alias_item.range=1
	self.alias_table["qingyunpin_fumoquan"]=alias_item

	alias_item={}
	alias_item.name="dagebi_caoyuan"
	alias_item.dir="s"
	alias_item.alias=function()
	   self:dagebi_caoyuan()
	end
	alias_item.range=1
	self.alias_table["dagebi_caoyuan"]=alias_item

	alias_item={}
	alias_item.name="yuren"
	alias_item.dir="n"
	alias_item.alias=function() self:yuren() end
	self.alias_table["yuren"]=alias_item

	alias_item={}
	alias_item.name="nongfu"
	alias_item.dir="n"
	alias_item.alias=function() self:nongfu() end
	self.alias_table["nongfu"]=alias_item

	alias_item={}
	alias_item.name="qiaofu"
	alias_item.dir="n"
	alias_item.alias=function() self:qiaofu() end
	self.alias_table["qiaofu"]=alias_item

	alias_item={}
	alias_item.name="shiliang"
	alias_item.dir="e"
	alias_item.alias=function() self:shiliang() end
	self.alias_table["shiliang"]=alias_item

	alias_item={}
	alias_item.name="shibixia_dongkou"
	alias_item.dir="n"
	alias_item.alias=function() self:shibixia_dongkou() end
	self.alias_table["shibixia_dongkou"]=alias_item

	alias_item={}
	alias_item.name="si_teng"
	alias_item.dir="n"
	alias_item.alias=function() self:si_teng() end
	self.alias_table["si_teng"]=alias_item

	alias_item={}
	alias_item.name="banshan_shangugudi"
	alias_item.dir="n"
	alias_item.alias=function() self:banshan_shangugudi() end
	self.alias_table["banshan_shangugudi"]=alias_item

	alias_item={}
	alias_item.name="push_huan"
	alias_item.dir="n"
	alias_item.alias=function() self:push_huan() end
	self.alias_table["push_huan"]=alias_item

	alias_item={}
	alias_item.name="qianting_miaojiazhuang"
	alias_item.dir="e"
	alias_item.alias=function() self:qianting_miaojiazhuang() end
	self.alias_table["qianting_miaojiazhuang"]=alias_item

	alias_item={}
	alias_item.name="miaojiazhuang_qianting"
	alias_item.dir="w"
	alias_item.alias=function() self:miaojiazhuang_qianting() end
	self.alias_table["miaojiazhuang_qianting"]=alias_item

	alias_item={}
	alias_item.name="shusheng"
	alias_item.dir="n"
	alias_item.alias=function() self:shusheng() end
	self.alias_table["shusheng"]=alias_item
    --全真 古墓地图
	alias_item={}
	alias_item.name="tiao"
	alias_item.dir="e"
	alias_item.alias=function() self:tiao() end
	self.alias_table["tiao"]=alias_item

	alias_item={}
	alias_item.name="tui_eastwall"
	alias_item.dir="e"
	alias_item.alias=function() self:tui_eastwall() end
	self.alias_table["tui_eastwall"]=alias_item

	alias_item={}
	alias_item.name="tui_westwall"
	alias_item.dir="w"
	alias_item.alias=function() self:tui_westwall() end
	self.alias_table["tui_westwall"]=alias_item

	alias_item={}
	alias_item.name="pa_up"
	alias_item.dir="e"
	alias_item.alias=function() self:pa_up() end
	self.alias_table["pa_up"]=alias_item

	alias_item={}
	alias_item.name="qian_up"
	alias_item.dir="e"
	alias_item.alias=function() self:qian_up() end
	self.alias_table["qian_up"]=alias_item

	alias_item={}
	alias_item.name="qian_down"
	alias_item.dir="w"
	alias_item.alias=function() self:qian_down() end
	self.alias_table["qian_down"]=alias_item


	alias_item={}
	alias_item.name="duanchang_gudi"
	alias_item.dir="s"
	alias_item.alias=function() self:duanchang_gudi() end
	self.alias_table["duanchang_gudi"]=alias_item

	alias_item={}
	alias_item.name="gudi_duanchang"
	alias_item.dir="n"
	alias_item.alias=function() self:gudi_duanchang() end
	self.alias_table["gudi_duanchang"]=alias_item

	alias_item={}
	alias_item.name="gudi_gudishuitan"
	alias_item.dir="s"
	alias_item.alias=function() self:gudi_gudishuitan() end
	self.alias_table["gudi_gudishuitan"]=alias_item

	alias_item={}
	alias_item.name="yabi_gudi"
	alias_item.dir="s"
	alias_item.alias=function() self:yabi_gudi() end
	self.alias_table["yabi_gudi"]=alias_item

	alias_item={}
	alias_item.name="yabi_duanchang"
	alias_item.dir="n"
	alias_item.alias=function() self:yabi_duanchang() end
	self.alias_table["yabi_duanchang"]=alias_item

	alias_item={}
	alias_item.name="guditan_tanan"
	alias_item.dir="n"
	alias_item.alias=function() self:guditan_tanan() end
	self.alias_table["guditan_tanan"]=alias_item

    alias_item={}
	alias_item.name="tanan_tongdao"
	alias_item.range=20
	alias_item.dir="s"
	alias_item.alias=function() self:tanan_tongdao() end
	self.alias_table["tanan_tongdao"]=alias_item

	alias_item={}
	alias_item.name="tongdao_gudi"
	alias_item.dir="n"
	alias_item.alias=function() self:tongdao_gudi() end
	self.alias_table["tongdao_gudi"]=alias_item

	alias_item={}
	alias_item.name="ss_ws"
	alias_item.dir="w"
	alias_item.alias=function() self:ss_ws() end
	self.alias_table["ss_ws"]=alias_item

	alias_item={}
	alias_item.name="ws_ss"
	alias_item.dir="e"
	alias_item.alias=function() self:search_fire() end
	self.alias_table["ws_ss"]=alias_item

	alias_item={}
	alias_item.name="shishi4_shishi0"
	alias_item.dir="e"
	alias_item.alias=function() self:shishi4_shishi0() end
	self.alias_table["shishi4_shishi0"]=alias_item

	alias_item={}
	alias_item.name="shishi1_shishi5"
	alias_item.dir="w"
	alias_item.alias=function() self:shishi1_shishi5() end
	self.alias_table["shishi1_shishi5"]=alias_item

	alias_item={}
	alias_item.name="lingshi_shiguan"
	alias_item.dir="n"
	alias_item.alias=function() self:lingshi_shiguan() end
	self.alias_table["lingshi_shiguan"]=alias_item

	alias_item={}
	alias_item.name="shiguan_sshi"
	alias_item.dir="n"
	alias_item.alias=function() self:shiguan_sshi() end
	self.alias_table["shiguan_sshi"]=alias_item

	alias_item={}
	alias_item.name="walkdown"
	alias_item.dir="s"
	alias_item.alias=function() self:walkdown() end
	self.alias_table["walkdown"]=alias_item

	alias_item={}
	alias_item.name="gumu_shulin"
	alias_item.dir="w"
	alias_item.alias=function() self:gumu_shulin() end
	self.alias_table["gumu_shulin"]=alias_item

	alias_item={}
	alias_item.name="shulin_gumu"
	alias_item.dir="e"
	alias_item.alias=function() self:shulin_gumu() end
	self.alias_table["shulin_gumu"]=alias_item

	alias_item={}
	alias_item.name="gml_lcd"
	alias_item.dir="e"
	alias_item.alias=function() self:gml_lcd() end
	self.alias_table["gml_lcd"]=alias_item

	alias_item={}
	alias_item.name="dxssk_dxssg"
	alias_item.dir="s"
	alias_item.alias=function() self:dxssk_dxssg() end
	self.alias_table["dxssk_dxssg"]=alias_item

	alias_item={}
	alias_item.name="chy0_chy1"
	alias_item.dir="n"
	alias_item.alias=function() self:chy0_chy1() end
	self.alias_table["chy0_chy1"]=alias_item

	alias_item={}
	alias_item.name="dongkou_shandong"
	alias_item.dir="ne"
	alias_item.alias=function() self:dongkou_shandong() end
	self.alias_table["dongkou_shandong"]=alias_item

	alias_item={}
	alias_item.name="shamo_lvzhou"
	alias_item.dir="n"
	alias_item.alias=function() self:shamo_lvzhou() end
	self.alias_table["shamo_lvzhou"]=alias_item

	alias_item={}
	alias_item.name="shamo1_shamo2"
	alias_item.dir="n"
	alias_item.alias=function() self:shamo1_shamo2() end
	self.alias_table["shamo1_shamo2"]=alias_item


	alias_item={}
	alias_item.name="outwuguan"
	alias_item.dir="s"
	alias_item.alias=function() self:outwuguan() end
	self.alias_table["outwuguan"]=alias_item
	--print("注册 结束")
end
--骷髅头
--带火折去娥嵋九老洞(enter;enter;use fire;w;nw;n;ne;e;se;s;sw;out;get tou)
