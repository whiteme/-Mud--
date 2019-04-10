
changle={
   new=function()
     local cl={}
	 setmetatable(cl,changle)
	 return cl
   end,
   cl_co=nil,
   party=nil,
   party_weapon=nil,
   murder_id="",
   player_id="",
   player_name="",
   look_player_place="",
   look_player=false,
   find_player=true,
   neili_upper=1.9,
   blacklist="星宿",
   version=1.8,
}
changle.__index=changle
local xunwen_count=0
--你仔细地查看梁丘佩的尸体，发现似乎是被空手内功震伤，从伤口看来，应该是大轮寺所为。
--你暗下寻思询问神龙教的基基棋基(Lbxa)或许能得到提示，传闻她曾在华山百尺峡附近出现。

function changle:jobDone()
end

function changle:catch()
    wait.make(function()
	   --你向贝海石打听有关『job』的消息。
	   --贝海石在你的耳边悄声说道：我接到飞鸽传书，狮威堂属下帮众郝忠在伊犁城铁铺处遇到袭击，你赶快前去救援！
       --贝海石说道：「这位小兄弟肯为我帮出力，如能完成使命，必有重赏。」
       --贝海石说道：「你刚做完长乐帮任务，还是先去休息一会吧。
	   --」
	     local l,w=wait.regexp("^(> |)贝海石在你的耳边悄声说道：我接到飞鸽传书，.*属下帮众(.*)在(.*)处遇到袭击，你赶快前去救援！$|^(> |)贝海石说道：「你刚做完长乐帮任务，还是先去休息一会吧。」$|^(> |)贝海石说道：「我帮现在比较空闲，暂时还没有任务让你去做。」$|^(> |)贝海石说道：「我不是告诉你了吗，我帮有人在.*遇到袭击，你还不赶快前去救援！」$|^(> |)贝海石说道：「你不是已经进展到一定地步了，还是继续努力吧！」$|^(> |)贝海石说道：「你不是已经知道了，杀害我帮帮众的仇人在(.*)一带出现过。」$",5)
		 if l==nil then
            print("网络太慢或是发生了一个非预期的错误")
		    self:ask_job()
		    return
         end
		 if string.find(l,"我接到飞鸽传书") then
		    print(w[2],w[3])
			self:appear(w[2],w[3])
		    return
		 end
		 if string.find(l,"你刚做完长乐帮任务，还是先去休息一会吧") then
		    local b=busy.new()
		    b.Next=function()
			  self.fail(101)
			end
			b:check()
		    return
		 end
		 if string.find(l,"我帮现在比较空闲，暂时还没有任务让你去做") then
		    local b=busy.new()
			b.Next=function()
		      self.fail(102)
			end
			b:check()
		    return
		 end
		 if string.find(l,"我不是告诉你了吗") then
		    shutdown()
		    self:giveup()
			return
		 end
		 if string.find(l,"你不是已经进展到一定地步了") or string.find(l,"你不是已经知道了") then
		    self:reward()
		    return
		 end
		 wait.time(5)
	 end)
end

function changle:ask_job()
  	local ts={
	           task_name="长乐帮",
	           task_stepname="询问贝海石",
	           task_step=2,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."长乐帮任务:询问贝海石", "yellow", "black") -- yellow on white
  local w
  w=walk.new()
  w.walkover=function()
	 world.Send("ask bei haishi about job")
     local l,w=wait.regexp("^(> |)你向贝海石打听有关『job』的消息。",5)
	 if l==nil then
	    self:ask_job()
	    return
	 end
	 if string.find(l,"你向贝海石打听有关") then
	    self:catch()
		 --BigData:catchData(135,"小厅")
	    return
	 end
	 wait.time(5)
  end
  w:go(135)
end

function changle:fail()

end

function changle:giveup()
    self.find_player=false
	world.EnableTrigger("player_place",false)
	world.DeleteTrigger("player_place")
  changle.cl_co=nil
  local w
  w=walk.new()
  w.walkover=function()
    wait.make(function()
      world.Send("ask bei haishi about fangqi")
	  local l2,w2=wait.regexp("^(> |)贝海石对你失望极了：“你没救了。”$|^(> |)贝海石说道：「你根本就没有领任务，完成什么啊？」$",10)
	  if l2==nil then
	    self:giveup()
		return
	  end
	  if string.find(l2,"贝海石对你失望极了") or string.find(l2,"你根本就没有领任务") then
	   print("放弃")
	   --BigData:catchData(135,"小厅")
	   local b
	   b=busy.new()
	   b.interval=0.3
	   b.Next=function()
	     self:Status_Check()
	   end
	   b:check()
	   return
	  end
	  wait.time(10)
	 end)
  end
  w:go(135)

end

function changle:run(i)
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

function changle:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("寻找出口")
     local dx=_R:get_all_exits(_R)
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil or i>table.getn(dx) then
	    --获得随机方向
	     local n=table.getn(dx)
	     i=math.random(n)
		 print("随机:",i)
	 end
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

function changle:look_corpse(npc,seq)
  wait.make(function()
    --print(npc.."尸体")
	world.Execute("look;set look 1")
	if seq~=nil then
		seq=seq+1
	else
		seq=1
	end
	local l,w=wait.regexp("^(> |).*"..npc.."的尸体\\\(Corpse\\\)|^(> |)设定环境变量：look \\= 1$",5)
	if l==nil then
	   self:look_corpse(npc,seq)
	   return
	end
	if string.find(l,npc.."的尸体") then
	   self:hint(npc,seq)
       return
	end
	if string.find(l,"设定环境变量：look") then
	   --没有看到corpse
		 print("下一个房间")
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
	   return
	end
	--wait.time(5)

  end)
end

function changle:reward()
  	local ts={
	           task_name="长乐帮",
	           task_stepname="奖励",
	           task_step=7,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 danerous_man_list_push()
	changle.cl_co=nil

  local w
  w=walk.new()
  w.walkover=function()
     self.find_player=false
	 world.EnableTrigger("player_place",false)
	 world.DeleteTrigger("player_place")
	 --world.DeleteVariable("player_place")
     world.Send("ask bei haishi about finish")
	 wait.make(function()
	   local l,w=wait.regexp("你向贝海石打听有关『finish』的消息。",10)
	   if l==nil then
	      self:reward()
		  return
	   end
	   if string.find(l,"你向贝海石打听有关『finish』的消息") then
	       local rc=reward.new()
	       rc:get_reward()
		   --BigData:catchData(135,"小厅")
	       local b
	       b=busy.new()
	       b.interval=0.3
	       b.Next=function()
			 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."长乐帮任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black")
	         self:jobDone()
	       end
	       b:check()
	      return
	   end
	    wait.time(10)
	 end)
  end
  w:go(135)
end


function changle:xunwen_man(id,roomno,rooms)
  wait.make(function()
    world.Send("xunwen "..string.lower(id))
	self.find_player=false
	world.EnableTrigger("player_place",false)
	world.DeleteTrigger("player_place")
	local l,w=wait.regexp("^(> |)你要询问谁？$|^(> |)你身旁有这个人么？$|^.*在你的耳边悄声说道：适才(.*)从我身边经过，好像前往了(.*)。$|^(> |)什么？$|^(> |)你不是已经询问过了.*$|^(> |)看起来.*暂时无法回答你的问题。$",5)
	if l==nil then
	   self:xunwen_man(id,roomno,rooms)
	   return
	end
	if string.find(l,"你要询问谁") or string.find(l,"你身旁有这个人么") or string.find(l,"什么") then
	  if self.look_player==true then
	     self.look_player=false
		 print("重新定位:",self.look_player_place)
		 self:xunwen_place(id,self.player_name,self.look_player_place,rooms)
	  else
	     self:NextPoint()
	  end
	 return
	end
	if string.find(l,"你不是已经询问过了")  then
	  self:reward()
	  return
	end
	if string.find(l,"暂时无法回答你的问题") then
	  xunwen_count=xunwen_count+1
	  print("询问剩余次数:",10-xunwen_count)
	  if xunwen_count>10 then
	     self:reward()
      else
	     self:xunwen_man(id,roomno,rooms)
	  end
	  return
	end
	if string.find(l,"在你的耳边悄声说道") then
	   world.Send("say 纵里寻她千百度，蓦然回首灯火阑珊处！！")
	   world.Send("say "..self.player_name.."我找你找的好苦！！")
	   --[[local exps=world.GetVariable("exps")
	   if tonumber(exps)<=1000000 then
		  self:reward()
	      return
	   end]]
	   print(w[3],w[4])
	   local murder=w[3]
	   local place=w[4]
	   -- world.AppendToNotepad (WorldName(),os.date().." 凶手名字: "..murder.." 躲藏地点: "..place.."\r\n")
		--[[
		"少林派弟子"
		"武当派弟子"
		"峨眉派弟子"
		"华山派弟子"
		"昆仑派弟子"
		"嵩山派弟子"
		"桃花岛弟子"
		"神龙岛弟子"
		"星宿派弟子"
		"丐帮弟子"
        "铁掌帮弟子"
		"明教弟子"
		"天龙寺弟子"
		"大轮寺弟子"
		"姑苏慕容"
		"古墓派"
		]]
		local _blacklist
		 if not (self.blacklist=="" or self.blacklist==nil) then
            _blacklist=Split(self.blacklist,"|")
			for _,b in ipairs(_blacklist) do
	           if string.find(Trim(murder),b) then
	             self:reward()
		         return
		       end
		    end
		 end
		  local name
		  name=string.gsub(murder,self.party.."弟子","")
		  print(murder,"->",name)
		   -- 加入危险人物列表
	      dangerous_man_list_add(name)
		  self:catch_murder(name,place)
	   return
	end
	wait.time(5)
  end)
end

function changle:combat()
end

function changle:shield()
end

function changle:wait_murder_die(murder_name)
  wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了.*$",5)--淳于羽「啪」的一声倒在地上，挣扎着抽动了几下就死了。
	 if l==nil then
	    self:wait_murder_die(murder_name)
	    return
	 end
	 if string.find(l,"挣扎着抽动了几下就死了") then
	    print(murder_name,w[2])
	    if string.find(murder_name,w[2]) then
		   self:murder_die()
		else
           self:wait_murder_die(murder_name)
		end
	    return
	 end
	 wait.time(5)
  end)
end

function changle:murder_die()
end

function changle:kill_murder(id,name,roomno)
  	local ts={
	           task_name="长乐帮",
	           task_stepname="战斗",
	           task_step=6,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  wait.make(function()
   world.Send("kill "..id)--你对着陈难猛吼一声：「老匹夫！明年的今天就是你的祭日，让大爷我送你上路吧！！」你对着澹台杨喝道：「臭贼！你死期已到，今天就让大爷我送你上西天吧！」
   self.murder_id=id
   local l,w=wait.regexp("^(> |)这里不准战斗。$|^(> |)你对着.*大喝一声：.*$|^(> |)你对着.*猛吼一声.*$|^(> |)加油！加油！$|^(> |)你正要有所动作，突然身旁有人将你一拍：好好看比武，别乱动！$|^(> |)你对着.*喝道：.*|^(> |)这里没有这个人。$",5)
   if l==nil then
      self:kill_murder(id,name,roomno)
	  return
   end
   if string.find(l,"大喝一声") or string.find(l,"喝道") or string.find(l,"加油") or string.find(l,"猛吼一声") then
        self:wait_murder_die(name)
        self:combat()
		return
	end
   if string.find(l,"这里不准战斗") or string.find(l,"你正要有所动作") or string.find(l,"没有这个人") then
     local _R
	 _R=Room.new()
	 _R.CatchEnd=function()
		local count,roomno=Locate(_R)
		print(roomno[1])
		local r=nearest_room(roomno)
		local w=walk.new()
		w.walkover=function()
		  self:check_murder(name,roomno)
		end
		w:go(r)
	  end
	  _R:CatchStart()
      return
   end
   wait.time(5)
  end)
end

function changle:check_murder(name,roomno)
   wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*"..name.."\\((.*)\\).*$|^(> |)设定环境变量：look \\= 1$|^(> |).*"..name.."的尸体\\((.*)\\).*$",15)
	  if l==nil then
	     self:check_murder(name,roomno)
		 return
	  end
	  if string.find(l,"设定环境变量：look") then
		 self:NextPoint()
	     return
	  end
	  if string.find(l,"尸体") then
	     self:reward()
	     return
	  end
	  if string.find(l,name) then
		 local murder_id=w[2]
		 murder_id=string.lower(murder_id)
         self:kill_murder(murder_id,name,roomno)
	     return
	  end
	  wait.time(15)
   end)
end


function changle:catch_murder(name,place)
  	local ts={
	           task_name="长乐帮",
	           task_stepname="抓捕凶手",
	           task_step=5,
	           task_maxsteps=7,
	           task_location=place,
	           task_description="抓捕"..name,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --print("抓捕凶手")
   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."长乐帮任务:".."抓捕凶手:"..name.." 位置:"..place, "white", "black")
   if zone_entry(place)==true or Trim(place)=="明教紫杉林" or Trim(place)=="嵩山少林松树林" or Trim(place)=="大草原沼泽" or Trim(place)=="杭州城柳林" then
      self:reward()
	  return
   end
   local n,rooms=Where(place)
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	    local al
		al=alias.new()
		al:SetSearchRooms(rooms)
	   print("抓取")
	   world.Send("yun recover")

	   changle.cl_co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()

		  al.do_jobing=true
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:reward()
		  end
		  al.noway=function()
		    --print("ceshi")
		    self:reward()
		  end
		  al.maze_done=function()
		    self:check_murder(name,self.maze_step)
		  end
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
				  self:reward()
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
		  w.noway=function()
		    self:reward()
		  end

		  w.user_alias=al
		  w.walkover=function()
		    self:check_murder(name,r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("没有找到询问对象")
		self:reward()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("没有目标")
	  self:reward()
	end
end

function changle:player_exist()
  if self.find_player==true then
  --看起来盗墓贼想杀死你！
  --print("auto kill 检查")
   world.AddTriggerEx ("player_place", "^(> |)(.*) - .*$", "print(\"%2\")\nSetVariable(\"player_place\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 150)

  wait.make(function()
    local l,w=wait.regexp("^(> |).*"..self.player_id..".*$",5)
	if l==nil then
	  self:player_exist()
	  return
	end
	if string.find(l,self.player_name) then
	  print("发现玩家",self.player_name)
	  local location=world.GetVariable("player_place")
	  location=Trim(location)
	  self.look_player=true
	  self.look_player_place=location
	  print("发现地点:",location)
	  self.find_player=false
	  world.EnableTrigger("player_place",false)
	  world.DeleteTrigger("player_place")
	  --world.DeleteVariable("player_place")
	  return
    end
	wait.time(5)
  end)
 end
end

function changle:xunwen_place(id,name,location,pass_rooms)
  	local ts={
	           task_name="长乐帮",
	           task_stepname="询问玩家",
	           task_step=4,
	           task_maxsteps=7,
	           task_location=location,
	           task_description="寻找玩家"..name.."("..id..")",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."长乐帮任务:".."寻找玩家:"..name.."("..id..") 位置:"..location, "white", "black") -- yellow on white
	if zone_entry(location)==true then
	    self:reward()
	    return
	end
	shutdown()
	 print("询问玩家")
  self.find_player=true
  --self:player_exist()
  local n,rooms=Where(location)
  if pass_rooms~=nil then  --过滤
     print("过滤")
     local filter_rooms={}
	 --print("pass_rooms:")

     for _,j in ipairs(rooms) do

	    for _,k in ipairs(pass_rooms) do
		  --print("pass_rooms:",k)
		   if j==k then
		      --print("加入房间号:",k)
		      table.insert(filter_rooms,k)
		      break
		   end
		end
	 end
	 n=table.getn(filter_rooms)
	 rooms=filter_rooms
  end
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   print("抓取")
	   changle.cl_co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:reward()
		  end
		  w.user_alias=al
		  w.noway=function()
		     self:reward()
		  end

		  w.walkover=function()
		    self.xunwen_count=0
		    self:xunwen_man(id,r,w.pass_rooms)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("没有找到询问对象")
		self:reward()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("没有目标")
	  self:reward()
	end
end

function changle:check_place(name,id,place)

   if string.find(place,"大雪山") or string.find(place,"长乐帮") or string.find(place,"襄阳城") or string.find(place,"扬州城") or string.find(place,"华山") or place=="嵩山少林达摩院" or (string.find(place,"武当山") and not string.find(place,"院门") and not string.find(place,"后山小院")) or string.find(place,"大理城") then
       if string.find(place,"长江南岸") or string.find(place,"华山石屋") then
	       self:reward()
	   else
	       self:xunwen_place(id,name,place)
	   end
   else
      self:reward()
   end
end

function changle:xunwen()
--你暗下寻思询问神龙教的裙下风流(Kicksld)或许能得到提示，传闻她曾在黄河流域海船附近出现。
--看来只能查看到这步了，还是先回去交差吧。
   wait.make(function()
     local l,w=wait.regexp("^(> |)你暗下寻思询问(.*)\\((.*)\\)或许能得到提示，传闻.*曾在(.*)附近出现。$|^(> |)看来只能查看到这步了，还是先回去交差吧。$",5)
      if l==nil then
	     self:reward()
	     return
	  end
	  if string.find(l,"看来只能查看到这步了") then
	      self:reward()
	     return
	  end
	  if string.find(l,"你暗下寻思询问") then
	     print(w[2],w[3],w[4])
		 --world.AppendToNotepad (WorldName(),os.date()..": 长乐任务 询问".. w[2].." "..w[3].." "..w[4] .."\r\n")
		 self.player_name=w[2]
	     self.player_name=string.gsub(self.player_name,"少林派的","")
		 self.player_name=string.gsub(self.player_name,"武当派的","")
		 self.player_name=string.gsub(self.player_name,"峨眉派的","")
		 self.player_name=string.gsub(self.player_name,"华山派的","")
		  self.player_name=string.gsub(self.player_name,"昆仑派的","")
		  self.player_name=string.gsub(self.player_name,"嵩山派的","")
		self.player_name=string.gsub(self.player_name,"桃花岛的","")
		self.player_name=string.gsub(self.player_name,"神龙教的","")
		self.player_name=string.gsub(self.player_name,"星宿派的","")
		self.player_name=string.gsub(self.player_name,"丐帮的","")
		self.player_name=string.gsub(self.player_name,"铁掌帮的","")
		self.player_name=string.gsub(self.player_name,"明教的","")
		self.player_name=string.gsub(self.player_name,"天龙寺的","")
		self.player_name=string.gsub(self.player_name,"大轮寺的","")
        self.player_name=string.gsub(self.player_name,"姑苏慕容的","")
		 self.player_name=string.gsub(self.player_name,"古墓派的","")


		 self.player_id=w[3]
		 --self:reward()
		 print(self.player_name,self.player_id)
		 self:check_place(self.player_name,self.player_id,w[4])
	     return
	  end
	  wait.time(5)
   end)
end

function changle:chakan_corpse(seq)
--你仔细地查看石真的尸体，发现似乎是被空手内功震伤，从伤口看来，应该是少林派所为。

  wait.make(function()
     if seq~=nil then
       world.Send("get corpse "..seq)
	   world.Send("drop corpse")
	 end
	   world.Execute("chakan corpse;get corpse;chakan corpse;drop corpse;get corpse 2;chakan corpse;drop corpse;get corpse 3;chakan corpse;drop corpse")
--你仔细地查看江惠的尸体，发现似乎是被钢刀劈伤，从伤口看来，应该是姑苏慕容所为。
	  local l,w=wait.regexp("^(> |)你仔细地查看.*的尸体，发现似乎是被(.*)，从伤口看来，应该是(.*)所为。$|^(> |)你附近没有这样东西。$",5)
	  if l==nil then
	    if seq==nil then
		   seq=1
		else
		   seq=seq+1
		end
	    self:chakan_corpse(seq)
	    return
	  end
	  if string.find(l,"你仔细地查看") then
	  --你暗下寻思询问神龙教的裙下风流(Kicksld)或许能得到提示，传闻她曾在黄河流域海船附近出现。
	    --world.AppendToNotepad (WorldName(),os.date()..": 长乐任务 凶手门派 武功".. w[3] .." ".. w[2].."\r\n")
		self.party=w[3]
		self.party_weapon=w[2]
	    self:xunwen()
	    return
	  end
	  if string.find(l,"你附近没有这样东西") then
	    self:giveup()
		return
	  end
	  wait.time(5)
  end)
end

function changle:hint(npc,seq)
	wait.make(function()
	  if seq~=nil then
	     world.Send("get cu bu from corpse "..seq)
	  else
	     world.Send("get cu bu from corpse")
	  end

	   local l,w=wait.regexp("^(> |)你附近没有这样东西。$|(> |)你从.*的尸体身上搜出一块粗布碎片。$|^(> |)你别开玩笑了。$|^(> |)你找不到 corpse .*这样东西。$",6)
	   if l==nil then
         self:hint(npc,seq)
		 return
	   end
	   if string.find(l,"你找不到") then
	      print("粗布也有人要?")
	      self:giveup()
	      return
	   end
	   if string.find(l,"你别开玩笑了") or string.find(l,"你附近没有这样东西") then
	     local f=function()
	       self:look_corpse(npc,seq)
		 end
		 f_wait(f,2)
		 return
	   end
	   if string.find(l,"搜出一块粗布碎片") then
	     world.Send("chakan cu bu")
		 self:chakan_corpse(seq)
	     return
	   end
	   wait.time(6)
	end)
end

function changle:NextPoint()
-- 恢复
   print("进程恢复1")
   coroutine.resume(changle.cl_co)
end
--[[
你仔细地查看羊舌星驰的尸体，发现似乎是被空手内功震伤，从伤口看来，应该是大轮寺所为。
你暗下寻思询问姑苏慕容的慕容凌昭(Kunlun)或许能得到提示，传闻他曾在大雪山千步岭附近出现。]]
--没有npc时候 确认下是否到达准确地点
local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    if tonumber(v)==tonumber(r) then
		   return true
		end
	end
	return false
end

function changle:checkPlace(npc,roomno,here,f2)
      if is_contain(roomno,here) then
  	     print("等待0.8,下一个房间")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     if f2==nil then
				self:NextPoint()
			 else
				f2()
			 end
		   end
		   b:check()
		 end
		 f_wait(f,0.8)
	   else
	   --没有走到指定房间
	    print("没有走到指定房间")
	      w=walk.new()
		  local al
		  al=alias.new()
		  al:SetSearchRooms(roomno)
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复2")
				  coroutine.resume(changle.cl_co)
			   end
			   al:finish()
		  end
		  al.out_zishanlin=function()
			   self.NextPoint=function()
				  print("进程恢复2")
				  coroutine.resume(changle.cl_co)
			   end
			   al:finish()
		  end
		  al.maze_done=function()
			 self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.songlin_check=function()
			  print("al 松林check")
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end
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
				  self:giveup()
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
		  al.zishanlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,2464)
		  end
		  --房间号: 2464
          --房间号: 3041
          al.zishanlin2_check=function()
			  self.NextPoint=function() al:zishanlin_tiandifenglei() end
			  self:checkNPC(npc,2464)
		  end
		  --[[al.circle_done=function()
		     print("遍历")
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkNPC(npc,roomno,f2)
			 --self:checkBeauty(f2)
		  end]]
		 al.noway=function()
		     print("noway!!!")
		     self:giveup()
		  end
		  w.user_alias=al
		  w.noway=function()
		     shutdown()
			 self:giveup()
		  end
		  w.walkover=function()
			print("walk 事件")
		    self:checkNPC(npc,roomno)
		  end
		  print("目标房间:",roomno)
		  w:go(roomno)
	   end
end

function changle:checkNPC(npc,roomno,f2)
   wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*"..npc..".*$|^(> |)设定环境变量：look \\= 1$",15)
	  if l==nil then
	     self:checkNPC(npc,roomno,f2)
		 return
	  end
	  if string.find(l,"设定环境变量：look") then
	     if r==nil then
		  local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     if f2==nil then
				self:NextPoint()
			 else
				f2()
			 end
		   end
		   b:check()
		    return
		 end
		  local f=function(r)
		     self:checkPlace(npc,roomno,r,f2)
		  end
		  WhereAmI(f,10000)
	     return
	  end
	  if string.find(l,npc) then
	     local f=function()
           self:hint(npc)
		 end
		 print("等待3秒")
		 f_wait(f,3)
	     return
	  end
	  wait.time(15)
   end)
end

--/changle:appear("钟瑞随","天龙寺松树林")

function changle:appear(npc,location)
  	local ts={
	           task_name="长乐帮",
	           task_stepname="搜索",
	           task_step=3,
	           task_maxsteps=7,
	           task_location=location,
	           task_description="寻找"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."长乐帮任务:搜索"..location.." 寻找"..npc, "blue", "black") -- yellow on white
	local party=world.GetVariable("party")
    --world.AppendToNotepad (WorldName(),os.date()..": 长乐任务 地点".. location .."\r\n")  --or location=="明教紫衫林"
 --  if zone_entry(location)==true or location=="大草原沼泽" or location=="天龙寺松树林" or (location=="武当山小径" and party=="武当派") then
      --self:giveup()
     -- return
   --end
   if zone_entry(location)==true then
      --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 无法进入"..location.."直接放弃\r\n")
      self:giveup()
      return
   end
   local n,rooms=Where(location)
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   print("抓取")
	   changle.cl_co=coroutine.create(function()
	      local al
		  al=alias.new()
		  al:SetSearchRooms(rooms)
		  --[[for _,r in ipairs(rooms) do
		     print("显示：",r)
		  end]]
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()

		  --al.break_pfm=self.break_pfm

		    --print("特殊")
			--[[al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复2")
				  coroutine.resume(changle.co)
			   end
			   al:finish()
			end
			al.out_zishanlin=function()
			   self.NextPoint=function()
				  print("进程恢复2")
				  coroutine.resume(changle.co)
			   end
			   al:finish()
		    end
		    al.songlin_check=function()
			  print("al 松林check")
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
			end]]
		--[[	if location=="明教紫杉林" then
		    	al.zishanlin_check=function()
	             self.NextPoint=function() al:NextPoint() end
			     self:checkNPC(npc,2464)
				end

			  al.zishanlin2_check=function()
			    self.NextPoint=function() al:zishanlin_tiandifenglei() end
			    self:checkNPC(npc,2464)
		      end
			end]]
		  al.maze_done=function()
		      print("迷宫check")
		      self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.noway=function()
            self:giveup()
		 end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		 --[[ al.circle_done=function()
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkNPC(npc,r,f2)
		  end]]
		  w.user_alias=al
		  w.noway=function()
		     shutdown()
		     self:giveup()
		  end
		  w.walkover=function()
		    self:checkNPC(npc,r)
		  end
		  print("房间号:",r)
		  w:go(r)
		  coroutine.yield()
	    end
		print("走到底没有找到npc,放弃job!!!")
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

function changle:Status_Check()
  	local ts={
	           task_name="长乐帮",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --初始化
     local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
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
		elseif  h.qi_percent<=liao_percent or h.jingxue_percent<=80 then
		    print("疗伤")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("打通经脉")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			 rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
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
		    local x
			x=xiulian.new()
			x.halt=false
			x.safe_qi=h.max_qi*0.5
			x.min_amount=100
			x.limit=true
			x.fail=function(id)
             --print(id)
			    if id==1 then
				  world.Send("yun recover")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
				end
				if id==777 then
				  self:Status_Check()
				end
				if id==201 then
				  world.Send("yun regenerate")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
			    end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(139)
			   end
			end
			x.success=function(h)
              -- print(h.qi,h.max_qi*0.9)
			  -- print(h.neili,h.max_neili*2-200)
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

--看起来狼木豆锕暂时无法回答你的问题。
