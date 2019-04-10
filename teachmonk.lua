
teachmonk={
    new=function()
     local tm={}
	 setmetatable(tm,{__index=teachmonk})
	 return tm
  end,
  co=nil,
  neili_upper=1.5,
  usedroom={},
  place="",
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

function teachmonk:fail(id)
end

function teachmonk:recover()
    world.Send("yun recover")
	world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()
	    if h.qi_percent<100 then --受伤了
		    print("打通经脉")
            local rc=heal.new()
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
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
				if id==777 then
				  self:recover()
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
			   world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
				  self:NextPoint()
			   else
	             print("继续修炼")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
		    self:NextPoint()
		end
	end
	h:check()
end

local path1="ask xuancan dashi about 罗汉堂值勤;w;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤"
local path2="ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;n;ask xuancan dashi about 罗汉堂值勤;n;ask xuancan dashi about 罗汉堂值勤;n;ask xuancan dashi about 罗汉堂值勤;n;ask xuancan dashi about 罗汉堂值勤"
local path3="ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤"
local path4="ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;n;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;s;ask xuancan dashi about 罗汉堂值勤;w;ask xuancan dashi about 罗汉堂值勤;w;ask xuancan dashi about 罗汉堂值勤;n;ask xuancan dashi about 罗汉堂值勤"
local path5="ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤;e;ask xuancan dashi about 罗汉堂值勤"
local paths={
 path1,path2,path3,path4,path5
}
function teachmonk:ask_job(index)
--随机移动
  	local ts={
	           task_name="少林教学",
	           task_stepname="开始教学",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  if index==nil or index>5 then
     index=1
  end
  local w=walk.new()
  w.walkover=function()
    world.Execute(paths[index])
	world.Send("set action 值勤")
	local l,w=wait.regexp("^(> |)玄惭说道：好吧，你就在罗汉堂里训练武僧吧，若有外敌入侵，你们负担着护寺重任。$|^(> |)设定环境变量：action \\= \\\"值勤\\\"$|^(> |)玄惭大师说道：「你正在忙着做其它任务呢。」$|^(> |)玄惭大师说道：「你刚才不是已经问过了吗？」$|^(> |)玄惭大师说道：「你刚训练武僧结束，还是先休息一会吧。」",5)
	if l==nil then
	   self:ask_job(index)
	   return
	end
	if string.find(l,"你就在罗汉堂里训练武僧") then
	  self.usedroom={}
	  table.insert(self.usedroom,3164)
	  table.insert(self.usedroom,3165)
	  table.insert(self.usedroom,3166)
	  table.insert(self.usedroom,3167)
	  table.insert(self.usedroom,3168)
      table.insert(self.usedroom,3169)
	   self:motou()
	   local b=busy.new()
	   b.Next=function()
	     self:go_monk()
	   end
	   b:check()
	   return
	end
	if string.find(l,"你刚才不是已经问过了吗") then
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
	     self:go_monk()
	   end
	   b:check()
	   return
	end
	if string.find(l,"你正在忙着做其它任务呢") then
        self.fail(102)
	   return
	end
	if string.find(l,"先休息一会") then
	   self.fail(101)
	   return
	end
	if string.find(l,"设定环境变量：action") then
	   index=index+1
	   local f=function()
	     self:ask_job(index)
	   end
	   f_wait(f,0.5)
	   return
	end
  end--
  w:go(869)
end

function teachmonk:kill_monk(index)
    --for _,r in ipairs(self.usedroom) do

	--end
	if index==nil then
	   index=1
	end
	print("剩余房间数目:",table.getn(self.usedroom))
	if table.getn(self.usedroom)>=index then
	   local w=walk.new()
	   w.walkover=function()
	      world.Send("kill monk")
		  local l,w=wait.regexp("^(> |)圆.*「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",20)
		  if l==nil then
		    self:kill_monk(index)
			return
		  end
		  if string.find(l,"死了") or string.find(l,"没有这个人") then
			index=index+1
			self:kill_monk(index)
		    return
		  end
	   end
	   print("房间号:",self.usedroom[index])
	   w:go(self.usedroom[index])
	   return
	end
	self:giveup()
end

function teachmonk:go_monk(targetRoomNo)
  if targetRoomNo==nil then
    roomno=3165
  elseif targetRoomNo==3165 then
   roomno=3164
  elseif targetRoomNo==3164 then
   roomno=3166
  elseif targetRoomNo==3166 then
   roomno=3167
  elseif targetRoomNo==3167 then
   roomno=3168
  elseif targetRoomNo==3168 then
   roomno=3169
  elseif roomno==3169 then
    print("都在搞基！！,莫怪我心黑！！")
    self:kill_monk(1)
	return
  end
   local w=walk.new()
   w.walkover=function()
      --world.Send("ask monk about 武技")
	    	local ts={
	           task_name="少林教学",
	           task_stepname="教武僧",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  BigData:Auto_catchData()
      self:teach(roomno)
   end
   w:go(roomno)
end

function teachmonk:motou()

  wait.make(function()
    local l,w=wait.regexp("^(> |)圆.*和尚神情振奋，一声大叫向(.*)奔去！$|^(> |)一个浑厚的声音直透你的耳骨，你的值勤时间已经到了。$",5)
	if l==nil then
	   self:motou()
	   return
	end
	if string.find(l,"一个浑厚的声音直透你的耳骨，你的值勤时间已经到了") then
	      	local ts={
	           task_name="少林教学",
	           task_stepname="下课了",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	    shutdown()
		self:jobDone()
	   return
	end
	if string.find(l,"一声大叫向") then
	    shutdown()

	    local place=w[2]
		local location="嵩山少林"..place

		  	local ts={
	           task_name="少林教学",
	           task_stepname="魔教来袭",
	           task_step=4,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
		local n,rooms=Where(location)
	  if n>0 then
	    teachmonk.co=coroutine.create(function()
	        for _,r in ipairs(rooms) do
               local w
		       w=walk.new()
		       local al
		       al=alias.new()
		       al.do_jobing=true
		  --al.break_pfm=self.break_pfm
		       al.break_in_failure=function()
		          self:giveup()
		       end
		       al.out_songlin=function()
			      self.NextPoint=function()
				    print("进程恢复")
				     coroutine.resume(teachmonk.co)
			      end
			      al:finish()
		      end
		      al.songlin_check=function()
	             self.NextPoint=function() al:NextPoint() end
			     self:checkNPC("邪道魔头",1764)
	     	  end
		      w.user_alias=al
		      w.noway=function()
		        self:NextPoint()
		      end
		      w.walkover=function()
		        self:checkNPC("邪道魔头",r)
		      end
		      w:go(r)
		      coroutine.yield()
	       end
		     print("没有找到npc!!")
		     self:giveup()
		 end)
	   else
	       print("没有找到npc!!")
		   self:giveup()
	   end
	   self:recover()
	   return
    end
  end)
end

function teachmonk:giveup()
   print("做后备job！！")
end

function teachmonk:run(i)
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

function teachmonk:flee(i)
  world.Send("go away")
  dangerous_man_list_add("邪道魔头")
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

function teachmonk:combat_end()
end

function teachmonk:combat()
end

function teachmonk:checkPlace(npc,roomno,here)
   if is_contain(roomno,here) then
  	     print("等待0.8s,下一个房间")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
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
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复")
				  coroutine.resume(songxin.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno)
		  end
		  w:go(roomno)
	   end
end

function teachmonk:checkNPC(npc,roomno)
   wait.make(function()
      world.Execute("look;set action 检查")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)设定环境变量：action \\= \\\"检查\\\"$",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
	      --没有找到
		  print("Next 地点")
		  local f=function(r)
		     self:checkPlace(npc,roomno,r)
		  end
		  WhereAmI(f,10000) --排除出口变化
		  return
	  end
	  if string.find(l,npc) then
	    	local ts={
	           task_name="少林教学",
	           task_stepname="击败魔头",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	     print("找到目标")
		 self:wait_motou_die()
		 world.Send("kill mo tou")
	     --找到
          self:combat()
		  return
	  end
	  wait.time(6)
   end)
end

function teachmonk:wait_motou_die()
wait.make(function()
   local l,w=wait.regexp("^(> |)邪道魔头「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里不准战斗。$",5)
	 if l==nil then
	    self:wait_motou_die()
	    return
	 end
	 if string.find(l,"挣扎着抽动了几下就死了") then
		self:motou_die()
	    return
	 end
	 if string.find(l,"这里不准战斗") then
	    self:jobDone()
		return
	 end
	 wait.time(5)
  end)
end

function teachmonk:NextPoint()
   --print("进程恢复:",coroutine.status(songxin.co))
   if teachmonk.co==nil or coroutine.status(teachmonk.co)=="dead" then
      self:giveup()
   else
      coroutine.resume(teachmonk.co)
   end
end

function teachmonk:cun(roomno)
   print("删除房间号:",roomno)
   for i,r in ipairs(self.usedroom) do
      if r==roomno then
		 table.remove(self.usedroom,i)
	     break
	  end
   end
end

function teachmonk:teach(roomno)
 wait.make(function()
  world.Send("teach monk")

  local l=wait.regexp("^(> |)你问我想学什么了吗.*$|^(> |)你的修为还不如我呢，还想教我？！$|^(> |)你还是先去跟玄惭大师打声招呼吧。$|^(> |)你尽心竭力，对圆心和尚指点拈花指的道理。$|^(> |)圆.*和尚说道：「我正由.*教着呢！」$|^(> |)什么？$",3)
	if l==nil then
	   self:teach(roomno)
	   return
	end
	if string.find(l,"你尽心竭力，对圆心和尚指点拈花指的道理") then
	   local f=function()
	     self:teach(roomno)
	   end
	   f_wait(f,0.8)
	   return
	end
	if string.find(l,"你的修为还不如我呢") then
	   self:go_monk(roomno)
	   return
	end
	if string.find(l,"你问我想学什么了吗") then
	   world.Send("ask monk about 武技")
	   local f=function()
	     self:teach(roomno)
	   end
	   f_wait(f,0.5)
	   return
	end
	if string.find(l,"你还是先去跟玄惭大师打声招呼吧") then
       self:Status_Check()
       return
	end
	if string.find(l,"教着呢") then
	   print("保存房间号!")
	   self:cun(roomno)
	   self:go_monk(roomno)
	   return
	end
	if string.find(l,"什么") then
	   self:go_monk(roomno)
	   return
	end
  end)
  --圆音和尚神情振奋，一声大叫向心禅坪奔去！      self:motou()
end

function teachmonk:jobDone()

end

function teachmonk:Status_Check()

	   	local ts={
	           task_name="少林教学",
	           task_stepname="恢复内力",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

	 dangerous_man_list_clear("邪道魔头")

     world.Send("yun refresh")
	 world.Send("yun recover")
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
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
		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80 then
		    print("疗伤")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc.liaoshang_fail=function()
			   print("hs 疗伤fail")
			   self:liaoshang_fail()
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
		    local x
			x=xiulian.new()
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
		         w:go(869)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
			   else
	             print("继续修炼")
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

