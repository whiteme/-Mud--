--小青蛇");break;
--		case 1: me->set("name","菜花蛇");break;
--		case 2: me->set("name","眼镜蛇");break;
--		case 3: me->set("name","腹蛇");break;
--		case 4: me->set("name","五步蛇");break;
--		case 5: me->set("name","银环蛇");break;
--		case 6: me->set("name","响尾蛇");break;
--		case 7: me->set("name","四脚蛇");break;
--		case 8: me->set("name","金环蛇");break;
--		case 9: me->set("name","赤练蛇");break;
--		case 10: me->set("name","野鸡脖子");break;
--你突然发现草丛中有一条蛇。
--看起来腹蛇想杀死你！

zhuashe={
  new=function()
     local zs={}
	 setmetatable(zs,{__index=zhuashe})
	 zs.room={}
	 return zs
  end,
  co=nil,
  neili_upper=1.9,
  rooms={},
  version="1.55",
}

function zhuashe:NextPoint()
   print("进程恢复")
   coroutine.resume(zhuashe.co)
end

function zhuashe:Search(rooms)
   for _,r in ipairs(rooms) do
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
             local f=function()
			   self:NextPoint()
			 end
			 f_wait(f,1.5)
		  end
		  --
		  w:go(r)
		  coroutine.yield()
   end
end

function zhuashe:wait_she_idle(snake)
   wait.make(function()  --淳于纳泉神志迷糊，脚下一个不稳，倒在地上昏了过去。
     --print(npc.."神志迷糊，脚下一个不稳，倒在地上昏了过去。")
     local l,w=wait.regexp("^(> |).*缩成一团，不动了。你伸手抓了起来。$",5)
     if l==nil then
	   self:wait_she_idle(snake)
	   return
	 end
	 if string.find(l,"缩成一团，不动了。你伸手抓了起来") then
	    shutdown()
        --self:reward()
		local b=busy.new()
		b.Next=function()
		  local f=function() self:reward() end
		  self:poison(f)
		end
		b:check()
	    return
	 end
	 wait.time(5)
   end)
end

function zhuashe:auto_kill_check()
  --看起来盗墓贼想杀死你！
  --print("auto kill 检查")
  wait.make(function()
    local l,w=wait.regexp("^(> |)看起来(.*)想杀死你！$",5)
	if l==nil then
	  self:auto_kill_check()
	  return
	end
	if string.find(l,"想杀死你") then
	  local snake=w[2]
	  if snake=="野鸡脖子" or snake=="小青蛇" or snake=="菜花蛇" or snake=="眼镜蛇" or snake=="腹蛇" or snake=="五步蛇" or snake=="银环蛇" or snake=="响尾蛇" or snake=="四脚蛇" or snake=="金环蛇" or snake=="赤练蛇" then
          world.Send("say "..snake.."妹妹你身上有样东西比天上的月亮还要圆还要白！")
		  shutdown()
		  local ts={
	           task_name="抓蛇",
	           task_stepname="战斗",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	       }
	       local st=status_win.new()
	       st:init(nil,nil,ts)
	       st:task_draw_win()
		  self:wait_she_idle(snake)
		  self:combat()
	     return
	  end
    end
	wait.time(5)
  end)
end

function zhuashe:she(location)
	 	local ts={
	           task_name="抓蛇",
	           task_stepname="搜索",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   if zone_entry(location)==true then
      self:giveup()
      return
   end
    if location=="归云庄九宫桃花阵" or location=="嵩山少林松树林" then
	     self:giveup()
		 return
	end
	print(location)
   local n,e=Where(location)
   local range
   if string.find(location,"武当后山") then
      range=3
   else
      range=6
   end
	local rooms=depth_search(e,3)  --范围查询

    self.rooms=rooms
	self:auto_kill_check()
    if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	   print("抓取")
	   zhuashe.co=coroutine.create(function()
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
	  print("没有目标")
	  self:giveup()
	end
end

function zhuashe:jobDone() --回调函数
end

function zhuashe:run(i)
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

function zhuashe:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("寻找出口")
     local dx=_R.get_all_exits()
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
	 self:run(run_dx,i)
   end
   _R:CatchStart()
end

function zhuashe:shield()

end

function zhuashe:exps()
  wait.make(function()
    local l,w=wait.regexp("^(> |)你获得了(.*)经验和(.*)点潜能。$",5)
		if l==nil then
		   self:exps()
		   return
		end
		if string.find(l,"你获得了") then
		    --world.AppendToNotepad (WorldName(),os.date()..": 抓蛇经验".. ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]).."\r\n")
		  --[[local exps=nil
		  exps=world.GetVariable("get_exp")
		  if exps==nil then
		    exps=0
		  end]]
		 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."丐帮抓蛇任务:奖励! 经验:"..ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]), "green", "black") -- yellow
		  --exps=tonumber(exps)+ChineseNum(w[2])
		  --world.SetVariable("get_exp",exps)
		  --world.AppendToNotepad (WorldName(),os.date().."目前获得总经验值"..exps.."\r\n")

		   return
		end

  end)
end

function zhuashe:getdan(count)
    if count==nil then
	  count=0
	end
	print(count,"中毒检查")
	if count>5 then
	   self:jobDone()
       return
	end
	local f=function()
		self:getdan(count)
	end

	local h=hp.new()
	h.checkover=function()
		if h.jingxue_percent<100 then --受伤了
			world.Send("ask chen about 百草丹")
			world.Send("fu dan")
			count=0
			f_wait(f,1)

		else
		    count=count+1
		    f_wait(f,1)
		end
   end
   h:check()
end

function zhuashe:qudu()

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
			         self:getdan()

					return
			     end

			   end
		     end
			local h=hp.new()
 	        h.checkover=function()
	        	if h.jingxue_percent<100 then --受伤了
			       world.Send("ask chen about 百草丹")
			       world.Send("fu dan")

		        end
			self:jobDone()
           end
           h:check()
		end
	cd:start()
end

function zhuashe:reward()
	 	local ts={
	           task_name="抓蛇",
	           task_stepname="奖励",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
        --world.Send("ask chen about 百草丹")
		self:exps()
		local l,w=wait.regexp("^(> |)你获得了(.*)经验和(.*)点潜能。$|^(> |)陈长老从你手里接过蛇，转身装进一个口袋里。$",5)
		if l==nil then
		   world.Send("e")
		   self:reward()
		   return
		end

		if string.find(l,"陈长老从你手里接过蛇，转身装进一个口袋里") then

		      local b
		      b=busy.new()
		      b.interval=0.5
		      b.Next=function()
		         self:qudu()
			  end
		      b:check()

		   return
		end
	  end)
   end
   w:go(1002)
end

function zhuashe:liaoshang_fail()
end

function zhuashe:giveup()
	 	local ts={
	           task_name="抓蛇",
	           task_stepname="放弃",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
 local w
   w=walk.new()
   w.walkover=function()
      world.Send("ask chen about 放弃")
	   wait.make(function()
	   local l,w=wait.regexp("^(> |)你向陈长老打听有关『放弃』的消息。$",8)
	   if l==nil then
		 self:giveup()
	     return
	   end
	   if string.find(l,"你向陈长老打听有关『放弃』的消息") then
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		  self:Status_Check()
		 end
		 b:check()
	     return
	   end
	   wait.time(8)
	 end)
   end
   w:go(1002)
end
--陈长老说道：你去嵩山少林汝州城附近帮我捉条蛇回来吧！
function zhuashe:xunwen()
    wait.make(function()
		local l,w=wait.regexp("^(> |)陈长老说道：你去(.*)附近帮我捉条蛇回来吧！$|^(> |)陈长老说道：「你刚抓完蛇，还是先去休息一会吧。」$|^(> |)陈长老说道：「刚才不是让你帮我抓蛇去了吗，你怎么还不去？」$|^(> |)陈长老说道：「你手头还有其他的事吧？过一会再来吧！」$",5)
		if l==nil then
		   self:xunwen()
		   return
		end
		if string.find(l,"你手头还有其他的事吧") then
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self.fail(102)
		   end
		   b:check()
		   return
		end
		if string.find(l,"你刚抓完蛇，还是先去休息一会吧") then
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self.fail(101)
		   end
		   b:check()
		   return
		end
		if string.find(l,"附近帮我捉条蛇回来吧") then
		   --print(w[2])
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."丐帮抓蛇任务:地点"..w[2], "green", "yellow") -- yellow
		   self:she(w[2])
		   return
		end
		if string.find(l,"你怎么还不去") then
		   self:giveup()
		   return
		end
		if string.find(l,"你发现事情不大对了，但是又说不上来") then
		   self:ask_job()
		   return
		end
	    wait.time(5)
    end)
end

function zhuashe:ask_job()
	 	local ts={
	           task_name="抓蛇",
	           task_stepname="询问",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 self.beauty_list={}
	 self.rooms={}
       local w
        w=walk.new()
		local al=alias.new()
        al.do_jobing=true
        w.user_alias=al
	    w.walkover=function()
        wait.make(function()
		world.Send("ask chen about 百草丹")
		local b=busy.new()
		b.interval=0.3
		b.Next=function()
          world.Send("ask chen about job")
		end
		b:check()
		local l,w=wait.regexp("^(> |)你向陈长老打听有关『job』的消息。$",5)
		if l==nil then
		   self:ask_job()
		   return
		end
		if string.find(l,"你向陈长老打听有关『job』的消息") then
		   self:xunwen()
 		   return
		end
		wait.time(5)
	  end)
     end
     w:go(1002)
end

function zhuashe:eat()
    local w=walk.new()
	w.walkover=function()
	      world.Execute("buy baozi")
		  world.Execute("eat baozi;eat baozi;eat baozi;drop baozi")
		 local f
		  f=function()
			self:Status_Check()
		  end
		  f_wait(f,1.5)
	end
	w:go(976) --春在楼 976
end

function zhuashe:drink()
     local w=walk.new()
	   w.walkover=function()
	      world.Execute("buy jiudai")
		  world.Execute("drink jiudai;drink jiudai;drink jiudai;drink jiudai;drink jiudai;drop jiudai")
		 local f
		  f=function()
			self:Status_Check()
		  end
		  f_wait(f,1.5)
		end
		w:go(976) --春在楼 976
end

function zhuashe:Status_Check()
   	 	local ts={
	           task_name="抓蛇",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	   }
	  local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
     --初始化
	local h
	h=hp.new()
	h.checkover=function()
	   --[[ print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
			 if h.food<50 then
			    self:eat()
			 elseif h.drink<50 then
			    self:drink()
			 end

		else]]
		if h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
			local rc=heal.new()
			rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=999
			rc.liaoshang_fail=function()
			   print("xs 疗伤fail")
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
			rc.saferoom=999
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
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(999)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
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
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end

function zhuashe:poison(callback)
     local sp=special_item.new()
       sp.cooldown=function()
           callback()
       end
       local equip={}
	   equip=Split("<获取>雄黄","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
	   --[[ 有雄黄解百毒
   	 local cd=cond.new()
	 cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=0
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="蛇毒" then
			   sec=i[2]
			   local b=busy.new()
			   b.Next=function()
			     world.Send("fu dan")
				 callback()
			   end
			   b:check()
			   return
			  end
			end
			callback()
		else
		   callback()
		end
	 end
	 cd:start()]]
end

function zhuashe:combat()  --回调函数
end

function zhuashe:combat_end()
end

function zhuashe:fail(id)
end

--[[你嘿嘿阴笑了几声，用指甲向黄格格轻轻弹了点粉沫。
不一会儿，黄格格就满面通红的晕了过去！

只见走出几个壮年男子将黄格格背起往大雪山的方向疾奔而去。]]
