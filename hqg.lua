--洪七公爱吃叫花鸡
require "map"
require "wait"
require "status_win"
hqg={
  new=function()
    local qg={}
	qg.caipulist={}
    setmetatable(qg,{__index=hqg})
	return qg
  end,
  caipulist={},
  co=nil,
  co2=nil,
  test_co=nil,
  get_cailiao=false,
  neili_upper=1.9,
}

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

function hqg:_caipu()
-- 进行排序 小到大
   for j=1,table.getn(self.caipulist)-1 do
    for i=1,table.getn(self.caipulist)-1 do
      local current_item=self.caipulist[i]
	  local P=current_item[2]
	  local next_item=self.caipulist[i+1]
	  local B=next_item[2]
	  --print(P,B)
	  local C=zone(P)
	  local D=zone(B)
	   --print(C,D)
	  if C>D then
	   self.caipulist[i],self.caipulist[i+1]=self.caipulist[i+1],self.caipulist[i]  --交换
	  end
    end
   end
   print("排序结果")
   for _,i in ipairs(self.caipulist) do
      print(i[1],i[2],i[3])
   end
   self:test()
end

function hqg:NextPoint()
   print("进程恢复")
   coroutine.resume(hqg.co)
end

function hqg:NextPoint2()
   print("进程恢复")
   coroutine.resume(hqg.co2)
end

function hqg:checkPot(npc,roomno,id,silver,here)
      if is_contain(roomno,here) then
  	     print("等待0.1s,下一个房间")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint2()
		   end
		   b:check()
		 end
		 f_wait(f,0.1)
	   else
	   --没有走到指定房间
	    print("没有走到指定房间")
	      w=walk.new()
		  local al
		  al=alias.new()
		  al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		 al.circle_done=function()
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkPot(npc,roomno,id,silver,f2)
			 --self:checkBeauty(f2)
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:PayAgain(npc,id,silver,roomno)
		  end
		  w:go(roomno)
	   end
end

function hqg:PayAgain(npc,id,silver,roomno)
    wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:PayAgain(npc,id,silver)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      local f=function(r)
		     self:checkPot(npc,roomno,id,silver,r)
		  end
		  WhereAmI(f)
		  return
	  end
	  if string.find(l,npc) then
	     print("找到目标")
	     --找到
		  self:pay(id,npc,silver)
		  return
	  end
	  wait.time(6)
   end)
end

function hqg:return_hotPot(location,id,npc,silver)
  local n,rooms=Where(location)
      hqg.co2=coroutine.create(function()
	    for _,r in ipairs(rooms) do
		  print("目标房间:",r)
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end

		  if location=="少林寺松树林" then
		     self:giveup()
	           --[[ al.continue=function()
			    wait.make(function()
                    world.Execute("look;set look 1")
                    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)设定环境变量：look \\= 1",6)
	                if l==nil then
					   --al:NextPoint()
					   --world.Execute("look;set look 1")
					   return
	                end
	                if string.find(l,"设定环境变量：look") then
					   al:NextPoint()
					   return
	                end
					if string.find(l,npc) then
	                  print("找到目标")
	                 --找到
					  local id=w[2]
					  id=string.lower(id)
					  self:songlin(npc,id,cailiao,al)
		              return
	                end
	                wait.time(6)
                end)
			 end]]
			 return
	      end
		  w.user_alias=al
		  w.noway=function()
		    shutdown()
		    self:giveup()
		  end
		  --[[w.locate_fail_deal=function()
         --定位失败处理函数  防止九宫桃花阵
	      local _R
          _R=Room.new()
          _R.CatchEnd=function()
		    local error_alias=alias.new()
		    print("房间名:",_R.roomname)
            if _R.roomname=="九宫桃花阵" then
			  print("定位失败！ 桃花阵中！")
			  error_alias.finish=function()
			   print("出桃花瘴")
			   print("目标房间号:",targetRoomNo)
			   w:go(targetRoomNo)
			 end
		     error_alias:reset_taohuazhen()
			elseif _R.roomname=="小帆船" then
			  world.Send("order 开船")
			  error_alias.finish=function()
			    w:go(targetRoomNo)
			  end
			  error_alias:order_chuan()
		    end
          end
			_R:CatchStart()
          end]]
		  w.walkover=function()
		    self:PayAgain(npc,id,silver,r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("没有找到npc!!")
		self:giveup()
	   end)
	  self:NextPoint2()
end

function hqg:ATM_carry_silver(bank_roomno,CallBack)
  wait.make(function()
  world.Send("look silver")
   local l,w=wait.regexp("^(> |)(.*)两白银\\(Silver\\)|^(> |)你要看什么？$",5)
   if l==nil then
	 self:ATM_carry_silver(bank_roomno,CallBack)
     return
   end
   if string.find(l,"两白银") then
      --print(w[2])
	  local silver=ChineseNum(w[2])
	  if silver<99 then
	     local qu_silver=99-silver
	    local w=walk.new()
		w.walkover=function()
		   world.Send("qu "..qu_silver.." silver")
		   self:ATM_carry_silver(bank_roomno,CallBack)
		end
	    w:go(bank_roomno)
	  else
	    CallBack()
	  end
   end
   if string.find(l,"你要看什么") then
        local w=walk.new()
		w.walkover=function()
		   world.Send("qu 99 silver")
		   self:ATM_carry_silver(bank_roomno,CallBack)
		end
	    w:go(bank_roomno)
      return
   end
   wait.time(5)
  end)
end

function hqg:ATM(id,npc,silver)
   print("没钱了,取款机在哪里?")
--确定当前位置
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --根据当前位置 前往最近的钱庄
--{大理 410} {沧州 1474} {扬州 50} {成都 546} {西域 1973} {苏州 1069} {杭州 1119} {福州 1331} {长安 926}

	  --print("当前房间号",roomno[1])
	  local bank_roomno
	  local index=zone(_R.zone)
	  if index==1 then
	     bank_roomno=1331
	  elseif index==2 then
	     bank_roomno=1331
	  elseif index==3 then
	     bank_roomno=50
	  elseif index==4 then
	     bank_roomno=410
	  elseif index==5 then
	     bank_roomno=1474
	  elseif index==6 then
	     bank_roomno=1973
	  else
	     bank_roomno=926
	  end
	  local b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	      local f=function()
		     self:return_hotPot(_R.zone,_R.roomname,id,npc,silver)
		  end
          self:ATM_carry_silver(bank_roomno,f)
	  end
	  b:check()
   end
  _R:CatchStart()
--返回 pay again
end

function hqg:pay(id,npc,silver)
  wait.make(function()
   world.Send("give "..silver.." silver to "..id)
   local l,w=wait.regexp("^(> |)"..npc.."好象突然想起什么事，急急忙忙的走开了。$|^(> |)你身上没有这样东西。$|^(> |)你没有那么多的白银。$|^(> |)这里没有这个人。$",5)
   if l==nil then
       self:pay(id,npc,silver)
       return
   end
   if string.find(l,"好象突然想起什么事") then
      self.get_cailiao=true
      self:look_caipu()
	  return
	end
	if string.find(l,"你身上没有这样东西") or string.find(l,"你没有那么多的白银") then
	   self:ATM(id,npc,silver)
	   return
	end
	if string.find(l,"这里没有这个人") then
	   local f=function()
	     self:pay(id,npc,silver)
	   end
	   self:look_around(f)
	   return
	end
   wait.time(5)
  end)
end

local dx=nil

function hqg:follow_again(exits,f,npc,roomname,zone)
    wait.make(function()
     print("寻找:",npc)
     local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)设定环境变量：look \\= \\\"YES\\\"",5)
	  if l==nil then  --异常
	     self:follow_again(exits,f,npc,roomname,zone)
         return
	  end
	  if string.find(l,npc) then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		 --危险地点
		 --西域南疆沙漠 明教龙王殿 少林寺松树林
		 if (roomname=="南疆沙漠" and zone=="西域") or (roomname=="龙王殿" and zone=="明教") or (roomname=="松树林" and zone=="少林寺") then
		   self:giveup()
		 else
	       world.Send(exits)
		   f()
		 end
		end
        b:check()
		return
	  end
	  if string.find(l,"设定环境变量：look") then
		 coroutine.resume(dx)
		 return
	  end
	  wait.time(5)
	end)
end

function hqg:look_dx(exits,f,npc)
     --print("look_dx:",exits)
     local _R=Room.new()
	 _R.CatchEnd=function()
	    world.Send("set look")
	 end
	 self:follow_again(exits,f,npc,_R.roomname,_R.zone)
	  _R:CatchStart(exits)
end

function hqg:look_around(f,npc)
    print("大鱼跑掉了")
    local _R
	_R=Room.new()
   _R.CatchEnd=function()
   --查看房间出口
	dx=coroutine.create(function()
	  local exits=Split(_R.exits,";")
	  --print("why")
      for _,e in ipairs(exits) do
	       --print(e)
		   self:look_dx(e,f,npc)
		   coroutine.yield()
	  end
	  self:giveup() --没找到
	 end)
	 coroutine.resume(dx)
   end
   _R:CatchStart()
end

function hqg:ask_cailiao(npc,id,cailiao)  --这里没有这个人。
  wait.make(function()
    --print(id,cailiao)
    world.Send("ask "..id.." about "..cailiao)
	local l,w=wait.regexp("^(> |)"..npc.."说道：「嘿嘿，你总要表示表示吧？就(.*)两银子吧。」|^(> |)"..npc.."漫不经心的“嗯”了一声，似乎根本没在听你说什么。$|^(> |)"..npc.."好象突然想起什么事，急急忙忙的走开了。$|^(> |)这里没有这个人。$|^(> |)"..npc.."说道：「罗嗦什么啊？一口价，我都说了，不要就算了。」$",3)
--诸葛克说道：「嗯，你要就拿去吧。」
--冷宇漫不经心的“嗯”了一声，似乎根本没在听你说什么。安拓说道：「嗯，你要的话，就拿去吧。」
     if l==nil then
	    self:ask_cailiao(npc,id,cailiao)
	    return
	 end
    if string.find(l,"你总要表示表示") then
	   --print(w[2])
	   local silver=w[2]
	   silver=ChineseNum(silver)
       self:pay(id,npc,silver)
	   return
	end
	if string.find(l,"漫不经心的“嗯”了一声，似乎根本没在听你说什么") then
      self:ask_cailiao(npc,id,cailiao)
	  return
	end
    if string.find(l,"这里没有这个人") then
	  local f=function()
	     self:ask_cailiao(npc,id,cailiao)
	  end
	   self:look_around(f,npc)
	   return
	end
	if string.find(l,"不要就算了") then
	   self:pay(id,npc,20)
	   return
	end
	if string.find(l,"好象突然想起什么事") then
	  self.get_cailiao=true
      self:look_caipu()
	  return
	end
	wait.time(3)
  end)
end

function hqg:follow(npc,id,cailiao,roomno)
  wait.make(function()
      id=string.lower(Trim(id))
      world.Send("follow " ..id)
	  local l,w=wait.regexp("^(> |)你决定跟随"..npc.."一起行动。$|^(> |)你已经这样做了。$|^(> |)这里没有 "..id.."。$",5)
	  if l==nil then
	    self:follow(npc,id,cailiao,roomno)
	    return
	  end
	  if string.find(l,npc) or string.find(l,"你已经这样做了") then
	    self:ask_cailiao(npc,id,cailiao)
	    return
	  end
	  if string.find(l,"这里没有") then
		 self:checkNPC(npc,roomno,cailiao)
	     return
	  end
	  wait.time(5)
  end)
end

function hqg:checkPlace(npc,roomno,cailiao,here)
      if is_contain(roomno,here) then
  	     print("等待0.1,下一个房间")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
		 end
		 f_wait(f,0.1)
	   else
	   --没有走到指定房间
	    print("没有走到指定房间")
	      w=walk.new()
		  local al
		  al=alias.new()
		  al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.maze_done=function()
			 self:checkNPC(npc,roomno,cailiao,al.maze_step)
			 --self:checkBeauty(f2)
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno,cailiao)
		  end
		  w:go(roomno)
	   end
end


function hqg:checkNPC(npc,roomno,cailiao,CallBack)
   if self.get_cailiao==true then
      print("已经找到了材料")
	  self:look_caipu()
      return
   else
      print("寻找NPC")
   end
   wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno,cailiao)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      local f=function(r)
		     self:checkPlace(npc,roomno,cailiao,r)
		  end
		  if CallBack~=nil then
		    WhereAmI(CallBack)
		  else
		    WhereAmI(f)
		  end
		  return
	  end
	  if string.find(l,npc) then
	     print("找到目标")
	     --找到
		  self:follow(npc,w[2],cailiao,roomno)
		  return
	  end
	  wait.time(6)
   end)
end

function hqg:songlin(npc,id,cailiao,alias)
	wait.make(function()
	  world.Send("ask "..id.." about "..cailiao)
	 local l,w=wait.regexp("^(> |)"..npc.."说道：「嘿嘿，你总要表示表示吧？就(.*)两银子吧。」|^(> |)"..npc.."漫不经心的“嗯”了一声，似乎根本没在听你说什么。$|^(> |)"..npc.."好象突然想起什么事，急急忙忙的走开了。$|^(> |)这里没有这个人。$",3)
     if l==nil then
	    self:songlin(npc,id,cailiao,alias)
	    return
	 end
    if string.find(l,"你总要表示表示") then
	   --print(w[2])
	   local silver=w[2]
	   silver=ChineseNum(silver)
       world.Send("give "..id.." "..silver.." silver")
	   self.get_cailiao=true
	   alias:NextPoint()
	   return
	end
	if string.find(l,"漫不经心的“嗯”了一声，似乎根本没在听你说什么") then
      self:songlin(npc,id,cailiao,alias)
	  return
	end
    if string.find(l,"这里没有这个人") then
       alias:NextPoint()
	   return
	end
	if string.find(l,"好象突然想起什么事") then
	  self.get_cailiao=true
      alias:NextPoint()
	  return
	end
	wait.time(3)
	end)
end

function hqg:go(npc,location,cailiao)
	local ts={
	           task_name="洪七公做菜",
	           task_stepname="寻找材料",
	           task_step=3,
	           task_maxsteps=4,
	           task_location=location,
	           task_description="寻找"..npc.." 材料:"..cailiao,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  local n,rooms=Where(location)
      hqg.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
		  print("目标房间:",r)
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.maze_done=function()

			 self:checkNPC(npc,r,cailiao,al.maze_step)

		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  --print("进程恢复")
				  coroutine.resume(hqg.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764,cailiao)
		  end
		  al.out_zishanlin=function()
			   self.NextPoint=function()
				  --print("进程恢复")
				  coroutine.resume(hqg.co)
			   end
			   al:finish()
		  end
		  al.zishanlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,2464,cailiao)
		  end
		  w.user_alias=al
		  w.noway=function()
		    shutdown()
		    self:giveup()
		  end
		  w.walkover=function()
		    self:checkNPC(npc,r,cailiao)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("没有找到npc!!")
		self:giveup()
	   end)
	  self:NextPoint()
end

function hqg:break_pfm()
end


--对所有节点可达进行检验
function hqg:test()
   local exps=world.GetVariable("exps") or 0
   exps=tonumber(exps)
   --print(165073)
   for _,i in ipairs(self.caipulist) do
       local location=i[2]
       local n,rooms=Where(location)
	   --print("n:",n)

	   if n<=0 or zone_entry(location) or location=="大草原沼泽" or location=="嵩山少林松树林" or (location=="明教龙王殿" and exps<=1500000) then
	     print(location," 无法到达")
	     self:giveup()
		 return
	   end
	    --测试 1001 到达 目标房间的路径
		--2012-8-11 修改算法
      hqg.test_co=coroutine.create(function()
		for _,r in ipairs(rooms) do
		    local mp=map.new()
			mp.Search_end=function(path,room_type)
			    if (path=="noway;" or path=="") then
					print(location," 无法到达")
	                self:giveup()
				    return
				end
				coroutine.resume(hqg.test_co)
			end
		    mp:Zone_Search(1001,r,true)
			coroutine.yield()
		end
	  end)
   end
   -- 路径测试

   --全部可以到达
   print("可以到达")
   local b=busy.new()
	b.interval=0.5
	b.Next=function()
	  local item=self.caipulist[1]
	  self:go(item[1],item[2],item[3])
   end
   b:check()
end

function hqg:caipu_item()
   wait.make(function()
      local l,w=wait.regexp("^(> |)你已经找到的原料有：.*$|^(\\S*)\\s+(\\S*)\\s+(\\S*)\\s*$",5)
	  if l==nil then
	     self:caipu_item()
	     return
	  end
	  if string.find(l,"你已经找到的原料") then
		--self:_caipu()
		--print("end")
		self:_caipu()
	     return
	  end
      if string.find(l,"") then
	    --print("name:",w[2])
	    _item={w[2],w[3],w[4]}
		--print("error")
		table.insert(self.caipulist,_item)
		--print("error2")
		self:caipu_item()
	    return
	  end
	  wait.time(5)
   end)
end

function hqg:jobDone()
end

function hqg:reward()
local w
   w=walk.new()
   w.walkover=function()
       world.Send("ask hong about finish")
       wait.make(function()

	      local l,w=wait.regexp("^(> |)洪七公接过你做的「玉笛谁家听落梅」，口中啧啧声不断，大笑道：今日可大饱口福了。$|^(> |)洪七公说道：「你真的完成了？？」$|^(> |)洪七公说道：「我有叫你去做什么吗？你完成什么啊？」$",5)
		  if l==nil then
		     self:reward()
		     return
		  end
		  if string.find(l,"洪七公接过你做的「玉笛谁家听落梅」") then
		    self:jobDone()
			return
		  end
		  if string.find(l,"你真的完成了") or string.find(l,"我有叫你去做什么吗？你完成什么啊") then
		    self:jobDone()
			return
		  end
		  wait.time(5)
	   end)
   end
   w:go(1001)
end

function hqg:zuocai()
	local ts={
	           task_name="洪七公做菜",
	           task_stepname="做菜",
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
   world.Send("zuo cai")
   local l,w=wait.regexp("你将原料放在一起，一会就做出了一盘香口美味的「玉笛谁家听落梅」。|^(> |)你一时走神，放错了配料，浪费了制成「玉笛谁家听落梅」的大好机会。$",5)
   if l==nil then
      self:zuocai()
      return
   end
   if string.find(l,"你将原料放在一起") then
      self:reward()
      return
   end
   if string.find(l,"你一时走神，放错了配料") then
      world.Send("xbc")
      self:ask_job()
	  return
   end
   wait.time(5)
  end)
  end
  w:go(999)
end

function hqg:look_caipu()
  self.get_cailiao=false --标志位赋值
  wait.make(function()
    self.caipulist={}
    world.Send("look cai pu")
	local l,w=wait.regexp("^(> |)你还有下列原料尚未找到：$|^(> |)你已经找齐了原料，赶快做「玉笛谁家听落梅」\\\(zuo cai\\\)吧。$",5)
	if l==nil then
	   self:look_caipu()
	   return
	end
	if string.find(l,"你已经找齐了原料") then
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
	    self:zuocai()
	   end
	   b:check()
	   return
	end
	if string.find(l,"你还有下列原料尚未找到") then
	   self:caipu_item()
	   return
	end
	wait.time(5)
  end)
end

function hqg:fail(id)
end
--洪七公说道：「这位兄台的潜能已经这么多了，还是先去用完再来吧！」
function hqg:catch_place()

   wait.make(function()
     local l,w=wait.regexp("^(> |)洪七公给了你一本关于如何制作「玉笛谁家听落梅」的菜谱。$|^(> |)洪七公说道：「唉！我这里什么原料都没有，你速速帮我找来吧。」$|^(> |)洪七公说道：「我这里已经有些原料，先给你，其余的你去找吧！」$|^(> |)洪七公说道：「我现在不饿，你还是先去休息一会吧。」$|^(> |)洪七公说道：「你的读书写字等级够高了，无法再做这个任务了。」$|^(> |)洪七公说道：「嗯？我不是告诉你了吗，快去取原料啊，不想做就算了！」$|^(> |)洪七公说道：「这位.*的潜能已经这么多了，还是先去用完再来吧！」$",5)
	 if l==nil then
	   self:ask_job()
	   return
	 end

	 if string.find(l,"洪七公给了你一本关于如何制作") or string.find(l,"我这里已经有些原料，先给你，其余的你去找吧") or string.find(l,"我这里什么原料都没有") then
	   self:look_caipu()
	   return
	 end
	 if string.find(l,"我现在不饿，你还是先去休息一会吧") then
	   self.fail(102)
	   return
	 end
	 if string.find(l,"你的读书写字等级够高了，无法再做这个任务了") then
	   self.fail(301)
	   return
	end
	if string.find(l,"嗯？我不是告诉你了吗，快去取原料啊，不想做就算了") then
	   self:giveup()
	   return
	end
	if string.find(l,"还是先去用完再来吧") then
	   local b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	     self:jobDone()
	   end
	   b:check()
	   return
	end
     wait.time(5)
   end)
end

function hqg:ask_job()
	local ts={
	           task_name="洪七公做菜",
	           task_stepname="询问洪七公",
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
    world.Send("ask hong about job")
	local l,w=wait.regexp("^(> |)你向洪七公打听有关『job』的消息。$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"你向洪七公打听有关") then
	  self:catch_place()
	  return
	end
	wait.time(5)
  end
  w:go(1001)
end

function hqg:giveup()
 local w
   w=walk.new()
   w.walkover=function()
       world.Send("ask hong about 放弃")
       wait.make(function()
	   --宋远桥说道：「叶知秋，你又没在我这里领任务，瞎放弃什么呀！」
	   --宋远桥说道：「叶知秋，你又没在我这里领任务，瞎放弃什么呀！」
	      local l,w=wait.regexp("^(> |)洪七公说道：「既然做不了，也就不勉强你了。」$|^(> |)洪七公说道：「我有叫你去做什么吗？你放弃什么啊？」$",5)
		  if l==nil then
		     self:giveup()
		     return
		  end
		  if string.find(l,"既然做不了，也就不勉强你了") or string.find(l,"我有叫你去做什么吗？你放弃什么啊") then
		    --self:ask_job()
			self.fail(102)
			return
		  end
		  wait.time(5)
	   end)
   end
   w:go(1001)
end

function hqg:carry_silver()
  local  bank_roomno=1331
  wait.make(function()
  world.Send("i")
  world.Send("set look 1")
   local l,w=wait.regexp("^(> |)(.*)两白银\\(Silver\\)$|^(> |)设定环境变量：look \\= 1$",5)
   if l==nil then
	 self:carry_silver()
     return
   end
   if string.find(l,"两白银") then
      --print(w[2])
	  local silver=ChineseNum(w[2])
	  if silver<99 then
	     local qu_silver=99-silver
	    local w=walk.new()
		w.walkover=function()
		   world.Send("qu "..qu_silver.." silver")
		   self:carry_silver()
		end
	    w:go(bank_roomno)
	  else
	    self:ask_job()
	  end
	  return
   end
   if string.find(l,"设定环境变量：look") then
        local w=walk.new()
		w.walkover=function()
		   world.Send("qu 99 silver")
		   self:carry_silver()
		end
	    w:go(bank_roomno)
      return
   end
   wait.time(5)
  end)
end

function hqg:Status_Check()
	local ts={
	           task_name="洪七公做菜",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --初始化
	  local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)
	    --[[if h.food<50 or h.drink<50 then
		   -- print("eat")
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
		else]]
		if  h.qi_percent<=70 or h.jingxue_percent<=80 then
		    print("疗伤")
            local rc=heal.new()
			rc.saferoom=505
			rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			 rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
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
			    --最近房间
				  local _R
                  _R=Room.new()
                  _R.CatchEnd=function()
                    local count,roomno=Locate(_R)
					local target_roomno=nearest_room(roomno)
                    local w
		            w=walk.new()
		            w.walkover=function()
			          x:dazuo()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:carry_silver()
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
			  self:carry_silver()
			end
			b:check()
		end
	end
	h:check()
end

