nongsang={
  new=function()
     ns={}
	  setmetatable(ns,{__index=nongsang})
	 return ns
  end,
}

local sign_txt=""
local number=1
    if not IsPluginInstalled("4e38a3aade8c0892c5f19e86") then
		LoadPlugin(GetInfo(60) .. "escape.xml")
	end
	--print("开插件")
	EnablePlugin("4e38a3aade8c0892c5f19e86", false)

function nongsang:lookSign()

	EnablePlugin("4e38a3aade8c0892c5f19e86", true)
    --world.AddTriggerEx ("sign0", "(.*)", "sign_add(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 151)
	world.AddTriggerEx ("sign1", "(.*)\\^\\>", "nongsang:sign_end(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150)

	sign_txt=""

	--world.EnableTrigger("sign0",true)
    world.EnableTrigger("sign1",true)
    Send("l sign")
end

local working=nil
function nongsang:caikuangrukou()
   local w=walk.new()
   w.walkover=function()
      world.Send("wu")
	   local seed=math.random(3)
	   local dx={"northup","southup","westup"}
	   world.Send(dx[seed])
	   nongsang:lookSign()
	   working=function()
	      local sp=special_item.new()
		  sp.cooldown=function()
	         nongsang:caikuang_dig()
          end
		  sp:unwield_all()
	   end
	   local f=function()
		 world.Send("look")
	   end
	   f_wait(f,1)
   end
   w:go(724)
end

--[[
function test_nongsang(dx)
     world.Send(dx)
	working=function() nongsang(s,reward) end
	lookSign()
	local f=function()
		world.Send("look")
	end
	f_wait(f,1)
end]]

function nongsang:nongsangrukou(s,location,reward,dir)
   --print(location)
     local w=walk.new()
   w.walkover=function()
     if location=="nongtian" then
      world.Send("s")
	 else
      world.Send("n")
	 end
	  --world.Send("ne")
	  --world.Send("sw")
	  if dir==nil then
	     dir="se"
	  end
	  world.Send(dir)
	  --[[ local seed=math.random(4)
	   local dx={"east","west","north","south"}
	   world.Send(dx[seed])]]
	    working=function() nongsang:nongsang(s,location,reward,dir) end
	   nongsang:lookSign()
	   local f=function()
		 world.Send("look")
		 local f2=function()
		   world.Send("look")
		 end
		 f_wait(f2,3)
	   end
	   f_wait(f,1)
   end
   w:go(1091)
end

--1091
function nongsang:buy_fromxiaofan()
   wait.make(function()
      world.Send("list")
		world.Send("buy tieqiao")
		local l,w=wait.regexp("^(> |)你以.*的价格从.*那里买下了一(把|柄)(.*)。$|^(> |)采矿师傅说道：「穷光蛋，一边呆着去！」$",5)
		if l==nil then
		   nongsang:follow_xiaofan()
		   return --> 你以六十六两白银的价格从采矿师傅那里买下了一柄铁锹。
		end
		if string.find(l,"那里买下") then
		   world.Send("follow none")
		   local b=busy.new()
		   b.Next=function()
		     nongsang:caikuangrukou()
		   end
		   b:check()
		   return
		end
		if string.find(l,"穷光蛋") then
		   local f=function()
		      nongsang:follow_xiaofan()
		   end
		   qu_gold(f,10,50)
		   return
		end

   end)
end

function nongsang:follow_xiaofan()
  world.Send("follow dali xiaofan")
  world.Send("follow shifu")
  world.Send("set follow")
  wait.make(function()
     local l,w=wait.regexp("^(> |)你决定跟随(.*)一起行动。$|^(> |)你已经这样做了。$|^(> |)设定环境变量：follow = \\\"YES\\\"$",5)
	 if l==nil then
	    nongsang:follow_xiaofan()
	    return
	 end
	 if string.find(l,"你决定跟随") or string.find(l,"你已经这样做了") then
	    world.Send("say 我已书剑城管名义宣布你为乱设摊典型代表！")
		nongsang:buy_fromxiaofan()
		return
	 end
	 if string.find(l,"设定环境变量") then
		coroutine.resume(equipments.co)
	    return
	 end
  end)
end

function nongsang:buy_qiao()

   local sp=special_item.new()

	sp.check_items_over=function()
	   print("检查结束")
	   local nums={}
		for index,item in pairs(sp.itemslistNum) do
            --print(index," index ",item," item")
	        if string.find(index,"铁锹") then
			   nongsang:caikuangrukou()
			   return
			end
		end
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

   equipments.co=coroutine.create(function()
    for _,r in ipairs(rooms) do
      local w=walk.new()
	  w.walkover=function()
	    nongsang:follow_xiaofan()
	  end
	  w:go(r)
	  coroutine.yield()
    end
	nongsang:buy_qiao()
  end)
  coroutine.resume(equipments.co)
	end
	--print("1 tieiqiao 2 liandao 3 种子 ")
	local equip={}
	equip=Split("<存在>铁锹","|")
	sp:check_items(equip)

end

--[[
  此地出产矿物：
        青铜(Qingtong)
        生铁(Shengtie)
        软铁(Ruantie)
        绿石(Lushi)
        流花石(Liuhuashi)
        软银(Ruanyin)
        金铁(Jintie)
        万年神铁(Shentie)
        玄铁(Xuantie)]]
function nongsang:caikuang_dig(index)
  if index==nil then
    index=1
  end
  local mine={"xuantie","shentie","jintie","ruanyin","liuhuashi","lushi","ruantie","shengtie","qingtong"}
  local id=mine[index]
  world.Send("wield tieqiao")
  world.Send("caikuang "..id)
  wait.make(function()
    local l,w=wait.regexp("^(> |)你已经把在这里你可以发现的矿石都挖走了！$|^(> |)你必须装备铁锹才能采矿。$|^(> |)你的采矿技能不够！$|^(> |)你挖了好长一段时间，总算找到一块(.*)。$|^(> |)你挖了好长一段时间，但是什么都没有得到。$|^(> |)你刚刚采矿结束，感觉过于劳累！|^(> |)什么？$",10)
	if l==nil then
	   nongsang:caikuang_dig(index)
	   return
	end
	if string.find(l,"你已经把在这里你可以发现的矿石都挖走了") then
	   world.Execute("out;ed")
	   local seed=math.random(3)
	   local dx={"northup","southup","westup"}
	   world.Send(dx[seed])
	   return
	end
	if string.find(l,"你的采矿技能不够") then
	     index=index+1
		 nongsang:caikuang_dig(index)
	    return
	end
	if string.find(l,"你挖了好长一段时间，总算找到一块") then
	   if index>=4 then
	      wait.time(1)
		  world.Send("drop "..id)

	   end
	    nongsang:caikuang_dig(index)
	   return
	end
	if string.find(l,"你刚刚采矿结束") then
	   wait.time(1)
	   nongsang:caikuang_dig(index)
	   return
	end
    if string.find(l,"你必须装备铁锹才能采矿") then
	    world.Execute("out;ed;ed")
        nongsang:buy_qiao()
		return
	end
	if string.find(l,"你挖了好长一段时间") then
	   nongsang:caikuang_dig(index)
	   return
	end
	if string.find(l,"什么") then

	  local _R=Room.new()
      _R.CatchEnd=function()
	     if _R.roomname=="采矿场" then
		     wait.time(1)
		    nongsang:caikuang_dig(index)
		 else
		    nongsang:buy_qiao()
		 end
      end
       _R:CatchStart()
	   return
	end

  end)
end

function nongsang:leave_nongtian(seed,location,reward,dx)
  --[[> 你开始用铁锹松土......
   你总算种好了！
   > 你从田地旁的水沟里挑了些水，开始浇地......
   > 你累地满头大汗，总算浇完了地。
   你从田地旁的肥料坑里铲了些肥料，开始施肥......
   > 你累地满头大汗，总算完成了施肥的工作。
   你兴高采烈的开始收割......]]
		world.Send("out")
		print(dx," dx")
        if dx=="se" then
		  world.Send("nw")
		  nongsang:nongsangrukou(s,location,reward,"sw")
		elseif dx=="ne" then
		  world.Send("sw")
		  nongsang:nongsangrukou(s,location,reward,"se")
		elseif dx=="sw" then
		  world.Send("ne")
		  nongsang:nongsangrukou(s,location,reward,"ne")
		end
end

function nongsang:leave_sanglin(seed,location,reward,dx)

		world.Send("out")
		print(dx," dx")
        if dx=="se" then
		  world.Send("nw")
		  nongsang:nongsangrukou(s,location,reward,"sw")
		elseif dx=="sw" then
		  world.Send("ne")
		  nongsang:nongsangrukou(s,location,reward,"nw")
		elseif dx=="nw" then
		  world.Send("se")
		  nongsang:nongsangrukou(s,location,reward,"se")
		end
end
--|^(> |)你必须装备镰刀才能收割。$
function nongsang:zhongdi_work(seed,location,reward,dx)
   wait.make(function()
     local l,w=wait.regexp("^(> |)你开始用铁锹松土\\.\\.\\.\\.\\.\\.$$|^(> |)你从田地旁的水沟里挑了些水，开始浇地\\.\\.\\.\\.\\.\\.$|^(> |)你从田地旁的肥料坑里铲了些肥料，开始施肥\\.\\.\\.\\.\\.\\.$|^(> |)你兴高采烈的开始收割\\.\\.\\.\\.\\.\\.$|^(> |)现在还没有到收割季节呢。$|^(> |)你还没有开始种植，收割什么！$|^(> |)设定环境变量：action = \\\"农桑\\\"$",5)
	  if l==nil then
	     nongsang:zhongdi(seed,location,reward,dx)
	     return
	  end
	  if string.find(l,"你开始用铁锹松土") or string.find(l,"开始浇地.") or string.find(l,"开始施肥")  then
		 local b=busy.new()
		 b.interval=0.8
		 b.Next=function()
		     nongsang:leave_nongtian(seed,location,reward,dx)
		 end
		 b:check()
		 return
	  end
	  if string.find(l,"现在还没有到收割季节呢") then
	     local f=function()
		    nongsang:leave_nongtian(seed,location,reward,dx)
		 end
		 f_wait(f,2)
	     return
	  end

	  if string.find(l,"你还没有开始种植") then
	     world.Send("out")
	     nongsang:getNongsang()
	     return
	  end
	  if string.find(l,"设定环境变量：action") then
	     --nongsangrukou(seed,location,reward,dx)
		 nongsang:getNongsang()
	     return
	  end
	  if string.find(l,"开始收割") then
         wait.time(8)
	     local b=busy.new()
		 b.interval=0.8
		 b.Next=function()

		    world.Execute("#12 drop "..reward)
		    nongsang:nongsang(seed,location,reward,dx)
		 end
		 b:check()
		 return
	  end
   end)
end

function nongsang:yangcan_work(seed,location,reward,dx)
   wait.make(function()
     local l,w=wait.regexp("^(> |)你开始用蚕卵孵化蚕\\.\\.\\.\\.\\.\\.$$|^(> |)你开始仔细的清扫养蚕用的竹篓\\.\\.\\.\\.\\.\\.$|^(> |)你开始用桑叶给蚕喂食\\.\\.\\.\\.\\.\\.$|^(> |)你开始小心翼翼的从蚕茧中抽取蚕丝\\.\\.\\.\\.\\.\\.$|^(> |)现在蚕还没有开始结茧呢。$|^(> |)你还没有开始养蚕，抽什么丝啊！$|^(> |)设定环境变量：action = \\\"农桑\\\"$",5)
	  if l==nil then
	     nongsang:zhongdi(seed,location,reward,dx)
	     return
	  end
	  if string.find(l,"你开始用蚕卵孵化") or string.find(l,"清扫养蚕") or string.find(l,"桑叶给蚕喂食")  then
		 local b=busy.new()
		 b.interval=0.8
		 b.Next=function()
		     nongsang:leave_sanglin(seed,location,reward,dx)
		 end
		 b:check()
		 return
	  end
	  if string.find(l,"现在蚕还没有开始结茧呢") then
	     local f=function()
		    nongsang:leave_sanglin(seed,location,reward,dx)
		 end
		 f_wait(f,2)
	     return
	  end
	  if string.find(l,"你还没有开始养蚕，抽什么丝啊") then
	     world.Send("out")
	     nongsang:getNongsang()
	     return
	  end
	  if string.find(l,"设定环境变量：action") then
	     --nongsangrukou(seed,location,reward,dx)
		 nongsang:getNongsang()
	     return
	  end
	  if string.find(l,"蚕茧中抽取蚕丝") then
         wait.time(8)
	     local b=busy.new()
		 b.interval=0.8
		 b.Next=function()

		    world.Execute("#12 drop "..reward)
		    nongsang:nongsang(seed,location,reward,dx)
		 end
		 b:check()
		 return
	  end
   end)
end

function nongsang:nongsang(seed,location,reward,dx)
   print("开始农桑")
   --nongsang:zhongzhi()
   --你必须装备铁锹才能种植。
   --你该给你所种植的作物施肥了。
   --你从田地旁的水沟里挑了些水，开始浇地......
   --> 你该给你所种植的作物浇水了。
   --你必须装备铁锹才能施肥。
   --你所种植的植物已经成熟，你可以开始收割了。
   --你必须装备镰刀才能收割。
   --你总共收获了十茧亚麻。
	local sp=special_item.new()
	sp.cooldown=function()
	  if location=="nongtian" then
        world.Execute("wield tieqiao;zhongzhi zhongzi")
	    world.Execute("unwield tieqiao;jiaoshui")
	    world.Execute("wield tieqiao;shifei")
	    world.Execute("unwield tieqiao;wield lian dao;shouge")
	    world.Send("set action 农桑")
		nongsang:zhongdi_work(seed,location,reward,dx)
	  else
	      world.Execute("yangcan "..seed)
		  world.Execute("weishi")
		  world.Execute("wield saoba;qingsao")
		  world.Execute("unwield saoba;wield jiandao;chousi")
		  world.Send("set action 农桑")
		  nongsang:yangcan_work(seed,location,reward,dx)
	  end



   end
   sp:unwield_all()
end

function nongsang:signResult(dx)
   world.Send(dx)
   working()
end

function nongsang:sign_end(line)
   --world.EnableTrigger("sign0",false)
   world.EnableTrigger("sign1",false)
   print("结束")
   sign_txt=line
    EnablePlugin("4e38a3aade8c0892c5f19e86", false)
    --print(sign_txt,"数据!!!")
	nongsang:escapeSign(sign_txt)
end
local look_count=0
--start middle  end
function nongsang:escapeSign(txt)
	local arrow=1
    if string.find(txt,"请注意第四个箭头：") then
	   arrow=4
	elseif string.find(txt,"请注意第三个箭头：") then
	   arrow=3
	elseif string.find(txt,"请注意第二个箭头：") then
	   arrow=2
	elseif string.find(txt,"请注意第一个箭头：") then
	   arrow=1
	elseif string.find(txt,"请注意下列箭头：") then
	   arrow=1
	end
  --local txt="^^^^^^  [[[[[[[[[[[[[[      ]]]]]]]]]]]]]]]]]]]]          **  [[[[[[ [[[[[[[[[[[[[[[[[[  ]]]]]]]]]]]]]]]]]]]]      |           [[  [[[[[[[[[[[         ]]]]]]]]]]]]]]]]]]]]*   *     \[[[[[[[[[ [[[[[[[[--------    ]]]]]]]]]]]]]]]]]]]]  ****--[[[[[[[[[[[["
  --local txt="请注意第四个箭头：^^^^^^   [[[[[[    **        ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[ [[[[[[[[[[[[[[[[    ]]]]]]]]]]]]]]]]]]]]      |         [[[[ [[[[[[[[[[[[[[[[[[[ ]]]]]]]]]]]]]]]]]]]]          |        [  [[[[[[[[[[[[[[[--   ]]]]]]]]]]]]]]]]]]]]   \---    ----[[[[[^^^   [[[[[[[[[[[[[[      ]]]]]]]]]]]]]]]]]]]]              [[[[[[ [[[[[[[[[[[[[[      ]]]]]]]]]]]]]]]]]]]]      /\      [[[[[[ [[[[[[[[[[[[[[[     ]]]]]]]]]]]]]]]]]]]]               [[[[[  [[[[[[[[[[[         ]]]]]]]]]]]]]]]]]]]]      \    [[[[[[[[[^^^^^^^^^   [[[[[[      *       ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[ [[[[[[[|            ]]]]]]]]]]]]]]]]]]]]       [[[[[[[[[[[[[ [[[[[[    \/     |  ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[  [[[[[[[[[[[[[[[[[   ]]]]]]]]]]]]]]]]]]]]                 [[[^^^^^^^^   [[[[[[[[[[[[[[[[    ]]]]]]]]]]]]]]]]]]]]                [[[[ [[[[[[[[[[          ]]]]]]]]]]]]]]]]]]]]          [[[[[[[[[[ [[[[[[[[            ]]]]]]]]]]]]]]]]]]]]        [[[[[[[[[[[[  [[[[[[[[[[[[        ]]]]]]]]]]]]]]]]]]]]            [[[[[[[[^^^^^^^^   [[[[     *******    ]]]]]]]]]]]]]]]]]]]]    [[[[[[[[[[[[[[[[ [[[[[[[[[[[[[[[[    ]]]]]]]]]]]]]]]]]]]]       |        [[[[ [[[[[[[[[[[[ \\     ]]]]]]]]]]]]]]]]]]]]      //   |[[[[[[[[  [[[   *             ]]]]]]]]]]]]]]]]]]]]   [[[[[[[[[[[[[[[[[^^^   [[[[[[              ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[ [[[[[[[[[[[[[[[[[   ]]]]]]]]]]]]]]]]]]]]    \ |  //      [[[ [[--      |     --  ]]]]]]]]]]]]]]]]]]]]  [[[[[[[[[[[[[[[[[[  [[[[\  ----         ]]]]]]]]]]]]]]]]]]]]    [[[[[[[[[[[[[[[[^   [[[[[[              ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[ [[[[[\\//           ]]]]]]]]]]]]]]]]]]]]     [[[[[[[[[[[[[[[ [[[[[[[   |         ]]]]]]]]]]]]]]]]]]]]       [[[[[[[[[[[[[  [[[[[[              ]]]]]]]]]]]]]]]]]]]]     \[[[[[[[[[[[[[[^^^^^^^   [[[[[[[[[[[[[**     ]]]]]]]]]]]]]]]]]]]]  *******    [[[[[[[ [[[[[  |            ]]]]]]]]]]]]]]]]]]]]     [[[[[[[[[[[[[[[ [[[[[   // \\    |  ]]]]]]]]]]]]]]]]]]]]  ---[[[[[[[[[[[[[[[         **           ]]]]]]]]]]]]]]]]]]]][[[[[[[[[[[[[[[[[[[[^^^^   [[                  ]]]]]]]]]]]]]]]]]]]]  [[[[[[[[[[[[[[[[[[ [[[[[[[[[[[[[       ]]]]]]]]]]]]]]]]]]]]       |     [[[[[[[ [[[[[[              ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[  [[[[[[[[[[[[[[[[    ]]]]]]]]]]]]]]]]]]]]                [[[[^^^^   [[[[[       **      ]]]]]]]]]]]]]]]]]]]]     [[[[[[[[[[[[[[[ [[[[   |            ]]]]]]]]]]]]]]]]]]]]    [[[[[[[[[[[[[[[[ [[[[[[[[[ |    \    ]]]]]]]]]]]]]]]]]]]]     /   [[[[[[[[[[[  [   **              ]]]]]]]]]]]]]]]]]]]] [[[[[[[[[[[[[[[[[[[^^^^^^"
  --local txt="^^^^ [[[[[[[[[[[[[[[[[   ]]]]]]]]]]]]]]]]]]]]                 [[[^ [[[[[[[[[[[[        ]]]]]]]]]]]]]]]]]]]]      **    [[[[[[[[^ [[[[[[[[[[[         ]]]]]]]]]]]]]]]]]]]]    **     [[[[[[[[[^^^^^ [[[[[[[[[           ]]]]]]]]]]]]]]]]]]]]         [[[[[[[[[[[^^^^^ [[[[[[[[[[[[[[[     ]]]]]]]]]]]]]]]]]]]]   \\\\        [[[[[^ [[[[[[[[[[[[[[[[[[[ ]]]]]]]]]]]]]]]]]]]]     \\\           [^ [[[[[[[[[[[[[[[[[[  ]]]]]]]]]]]]]]]]]]]]       \          [[^^^^^^^^^^^ [[[[[[[[[[[[[[[[[[[ ]]]]]]]]]]]]]]]]]]]]                   [^ [[[[                ]]]]]]]]]]]]]]]]]]]]    [[[[[[[[[[[[[[[[^^^^^ [[[[[[[[[[[[****    ]]]]]]]]]]]]]]]]]]]]  \\\*******[[[[[[[[^^^^"
    local signs = {
		east={"******--*****..*", "-----------/", "*******    **", "**********###*", "***********/", "------     **"},
		south={"*## *  *#", "***  **", "\\  |     --", "\\ |  //", "\\   * //", "* | *"},
		west={"%%%%%%%%%%%%%%%%", "\\\\**************", "\\---    ------", "****----------", "\\\\\\***********", "** //   ------"},
		north={"*#*#*#**", "---   // \\\\    |", "**  ** *\\\\", "#/  *#    #\\", "/*** \\\\**      **", "***  *        \\"},
	}
  local i
  local row=0
  local col=0
  local lower=false
  local hight=false
  local L_value=""
  local H_value=""
  local s_count=0
  local tb={}
  for i=1,4 do
    tb[i]={}
	for j=1,10 do
	  tb[i][j]=nil
	end
  end
   for i=1,string.len(txt) do
      local w=string.sub(txt,i,i)
      if w=="^" then
	      row=row+1
		 col=0
		 s_count=0
	  elseif w=="U" then
	     row=row-1
	  elseif w=="[" then
	      if lower==false and hight==false then
		     lower=true
			  s_count=1
		   elseif lower==true then
		      s_count=s_count+1
		   elseif hight==true then --结尾
		       s_count=s_count+1
              if s_count>=20 then
		         hight=false
			     lower=false
		         local value=H_value..L_value
				 H_value=""
				 L_value=""
				 col=col+1
                --[[ value = string.gsub(value, "%*", "%%*")
				  value = string.gsub(value, "%-", "%%-")
				  value = string.gsub(value, "%.", "%%.")]]
                   --value = string.gsub(value, "\\", "\\\\")
				 value=Trim(value)
				 tb[col][row]=value
				 if col==arrow then -- 目标列
                   for _,v in ipairs(signs.east) do
				    --print(v)
					if v==value then
					  print("结果    east")
					  nongsang:signResult("east")
					  return
					end
				   end
				   for _,v in ipairs(signs.west) do
				    --print("west:",v)
					if v==value then
					  print("结果    west！！！！！")
					  nongsang:signResult("west")
					  return
					end
				   end

				  for _,v in ipairs(signs.south) do
				    --print(v)
					if v==value then
					  print("结果    south")
					  nongsang:signResult("south")
					  return
					end
				   end

				  for _,v in ipairs(signs.north) do
				    --print(v)
					if v==value then
					  print("结果    north")
					  nongsang:signResult("north")
					  return
					end
				  end

				end
			  end
		  end
	  elseif w=="]" then
		   lower=false
		   hight=true
	  else

	      if lower==true then
		     L_value=L_value..w
		  end
		  if hight==true then
		    H_value=H_value..w
		  end
	  end
	  --print(w)
   end
   if look_count<6 then
      look_count=look_count+1
   print("结束!!!再看一次！！")
   nongsang:lookSign()
	local f=function()
		 world.Send("look")
		 local f2=function() world.Send("look") end
		 f_wait(f2,3)
	end
	f_wait(f,1)
   else
      look_count=0
       --getNongsang()
	   working()

   end
end

function nongsang:nongsang_checkItem(seed,location,reward)
   local sp=special_item.new()

	sp.check_items_over=function()
	   print("检查结束")
	   local nums={}
		for index,item in pairs(sp.itemslistNum) do
            --print(index," index ",item," item")
			if string.find(index,"镰刀") then
			    nums[3]=item
			elseif string.find(index,"铁锹") then
			    nums[2]=item
			elseif string.find(index,"种子") then
                nums[1]=item
			elseif string.find(index,"蚕子") then
			    nums[4]=item
			elseif string.find(index,"扫把") then
			    nums[5]=item
			elseif string.find(index,"剪刀") then
				nums[6]=item
			end
		end
		nongsang:start_Nongsang(seed,location,reward,nums)
	end
	--print("1 tieiqiao 2 liandao 3 种子 ")
	local equip={}
	equip=Split("<存在>种子&6|<存在>铁锹|<存在>镰刀|<存在>蚕子&6|<存在>扫把|<存在>剪刀","|")
	sp:check_items(equip)
end

--你以二两白银又十六文铜钱的价格从养蚕婆婆那里买下了一颗亚麻种子。
local buy_count=0
function nongsang:buy_frompopo(seed,location,reward,tools_num)
    buy_count=buy_count+1
    local seed_num=tools_num[1] or 0
   local tieqiao_num=tools_num[2] or 0
   local liandao_num=tools_num[3] or 0
   local canzi_num=tools_num[4] or 0
   local saoba_num=tools_num[5] or 0
   local jiandao_num=tools_num[6] or 0
     print("seed:",seed_num," tieqiao:",tieqiao_num," liandao:",liandao_num)

	  print("canzi:",canzi_num," saobaqiao:",saoba_num," jiandao:",jiandao_num)
   wait.make(function()
      world.Send("list")
		local tool=""
		if tieqiao_num==0 then
		   tool="tieqiao"
		elseif liandao_num==0 then
		    tool="liandao"
		elseif seed_num<=6 then
		    tool=seed
		end
		world.Send("buy "..tool)
		local l,w=wait.regexp("^(> |)你以.*的价格从.*那里买下了一(把|柄|颗)(.*)。$|^(> |)养蚕婆婆说道：「穷光蛋，一边呆着去！」$|^(> |)什么？$",5)
		if l==nil then
		   if buy_count>6 then
		      buy_count=0
			  nongsang:getNongsang()
		   else
		     nongsang:buy_frompopo(seed,location,reward,tools_num)
		   end
		   return --> 你以六十六两白银的价格从采矿师傅那里买下了一柄铁锹。
		end
		if string.find(l,"什么") then
		    nongsang:follow_popo(seed,location,reward,tools_num)
		    return
		end
		if string.find(l,"那里买下") then
		   buy_count=0
		   print(w[2],w[3])
		   local new_num={}

		   if tool=="tieqiao" then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num+1
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num
		   elseif tool=="liandao" then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num+1
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num
		    elseif tool=="jiandao" then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num+1
		    elseif tool=="saoba" then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num+1
			  new_num[6]=jiandao_num
		   elseif tool==seed and string.find(seed,"zhongzi") then
		      new_num[1]=seed_num+1
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num
			  if new_num[1]>6 then
			     local b=busy.new()
				 b.Next=function()
				 nongsang:nongsangrukou(seed,location,reward)
				 end
				 b:check()
			     return
			  end
		   elseif tool==seed and string.find(seed,"can zi") then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num+1
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num
			  if new_num[4]>6 then
			   local b=busy.new()
			    b.Next=function()
				 nongsang:nongsangrukou(seed,location,reward)
				 end
				 b:check()
			     return
			  end
		   end
		   nongsang:buy_frompopo(seed,location,reward,new_num)
		   return
		end
		if string.find(l,"穷光蛋") then
		   world.Send("follow none")
		   local f=function()
		      follow_popo(seed,location,reward,tools_num)
		   end
		   qu_gold(f,10,50)
		   return
		end

   end)
end

function nongsang:follow_popo(seed,location,reward,tools_num)
   world.Send("follow popo")
   world.Send("set follow")
     wait.make(function()
     local l,w=wait.regexp("^(> |)你决定跟随(.*)一起行动。$|^(> |)你已经这样做了。$|^(> |)设定环境变量：follow = \\\"YES\\\"$",5)
	 if l==nil then
	    nongsang:follow_popo(seed,location,reward,tools_num)
	    return
	 end
	 if string.find(l,"你决定跟随") or string.find(l,"你已经这样做了") then
	    world.Send("say 我已书剑城管名义宣布你为乱设摊典型代表！")
        nongsang:buy_frompopo(seed,location,reward,tools_num)
		return
	 end
	 if string.find(l,"设定环境变量") then
		coroutine.resume(equipments.co)
	    return
	 end
   end)
end

function nongsang:start_Nongsang(seed,location,reward,tools_num)
 local seed_num=tools_num[1] or 0
   local tieqiao_num=tools_num[2] or 0
   local liandao_num=tools_num[3] or 0
    print("seed:",seed_num," tieqiao:",tieqiao_num," liandao:",liandao_num)
   if  seed_num>=6 and tieqiao_num>=1 and liandao_num>=1 then
       nongsang:nongsangrukou(seed,location,reward)
       return
   end

       local rooms={}
   table.insert(rooms,920)
   table.insert(rooms,918)
   table.insert(rooms,919)
   table.insert(rooms,912)
   table.insert(rooms,1087)
   table.insert(rooms,913)
   table.insert(rooms,914)
   table.insert(rooms,915)
   table.insert(rooms,911)
    table.insert(rooms,921)
	 table.insert(rooms,922)
	  table.insert(rooms,924)
	   table.insert(rooms,890)
	    table.insert(rooms,891)
		table.insert(rooms,927)
		 table.insert(rooms,901)
		  table.insert(rooms,1541)
		  table.insert(rooms,911)

   equipments.co=coroutine.create(function()
    for _,r in ipairs(rooms) do
      local w=walk.new()
	  w.walkover=function()
	    nongsang:follow_popo(seed,location,reward,tools_num)
	  end
	  w:go(r)
	  coroutine.yield()
    end
    print("走到底")
	local f=function()
	 nongsang:start_Nongsang(seed,location,reward,tools_num)
	end
	f_wait(f,3)
  end)
  coroutine.resume(equipments.co)
end

function nongsang:getNongsang()
    local lw=lingwu:new()
      lw.get_skills_end=function()
	      local level = lw:get_skill("nongsang")
	  if level < 40 then
		nongsang:nongsang_checkItem("mianhua zhongzi", "nongtian", "mian hua")
	   elseif level < 80 then
		nongsang:nongsang_checkItem("yama zhongzi", "nongtian", "ya ma")
	   elseif level < 120 then
		nongsang:nongsang_checkItem("dama zhongzi", "nongtian", "da ma")
	   elseif level < 170 then
		nongsang:nongsang_checkItem("zhuma zhongzi", "nongtian", "zhu ma")
	   elseif level < 220 then
	     nongsang:nongsang_checkItem("zhuma zhongzi", "nongtian", "zhu ma")
		--nongsang_checkItem("can zi", "sanglin", "cansi")
	  elseif level < 270 then
	 	nongsang:nongsang_checkItem("mumian zhongzi", "nongtian", "mumianhua")
	  elseif level < 330 then
		nongsang:nongsang_checkItem("yucan zi", "sanglin", "yucansi")
	  elseif level < 390 then
		nongsang:nongsang_checkItem("bingcan zi", "sanglin", "bingcansi")
	  else
		nongsang:nongsang_checkItem("tiancan zi", "sanglin", "tiancansi")
	  end
	end
	lw:get_skills()
end
