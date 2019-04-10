--少林方丈
-- 2:                       【少林救援介绍】
-- 3: ──────────────────────────────
-- 4:
-- 5:     魔教教主任我行自来危害江湖，这次率大军前往恒山，想灭掉恒
-- 6: 山派，少林作为白道代表，玄慈方丈请少林长老方正大师率少林弟子
-- 7: ，前往恒山救援。
-- 8:
-- 9: ──────────────────────────────
--10:                         【任务要求】
--11: ──────────────────────────────
--12:
--13:     团队：２－４人组队，队员经验值都大于1m，队员间相差不超过
--14:           1m，必须是少林弟子做队伍首领，队员不限门派。
--15:     个人：经验值大于3m，只限于少林弟子。
--16:
--17: ──────────────────────────────
--18:                         【任务过程】
--19: ──────────────────────────────
--20:
--21:     在方丈室由队伍首领向玄慈大师要任务 ask dashi about job，
--22: 大师会告诉你方正大师现在何处，到指定地点找到方正大师，由队伍
--23: 首领向方正大师询问救援ask dashi about 救援，方正大师会follow
--24: 该队伍首领，杀掉拦路的魔教教徒，并把大师带到恒山白云庵那里就
--25: 算任务完成，如果大师死亡，任务就失败。
--2553

--你向玄慈大师打听有关『job』的消息。
--玄慈大师说道：「我接到本派弟子通报，魔教教主任我行亲率数万教众，
--欲血洗恒山派。虽定静师太并未向我少林求援，但少林不能坐视恒山
--覆灭，我已请方正大师亲率罗汉堂和般若堂弟子前去救援。」
--玄慈大师说道：「就请各位随同方正大师前去恒山，一路小心。」
--玄慈大师说道：「方正大师现在立雪亭。」
--1381
--陕晋渡口 1356 1351
--关键点
--蓝田 211
--安远门  1087
--陕晋渡口 1351
--终点 1381
--方正大师高喊一声：情况紧急，我撤退，你掩护。
require "map"
require "wait"
require "heal"
require "xiulian"
require "sj_mini_win"
require "fight"

jiuyuan={
  new=function()
    local jy={}
	 setmetatable(jy,{__index=jiuyuan})
	 return jy
  end,
  co=nil,
  player_id='',
  dashi_name='',
  target_roomno=nil,
  neili_upper=1.9,
  failure=false,
}
--空智大师高喊一声：情况紧急，我撤退，你掩护。
--关键点
--蓝田 211
--安远门  1087
--陕晋渡口 1351
--终点 1381
--空性大师高喊一声：情况紧急，我撤退，你掩护。
function jiuyuan:jiaotu_die()
   if self.dashi_name==nil or self.dashi_name=="" then
	     self.dashi_name=world.GetVariable("dashi_name")
   end
  wait.make(function()
    local l,w=wait.regexp("^(> |)魔教教徒「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)"..self.dashi_name.."高喊一声：情况紧急，我撤退，你掩护。$|^(> |)这里没有这个人。$",5)
	if l==nil then
	   self:jiaotu_die()
	   return
	end
   if string.find(l,"这里没有这个人") or string.find(l,"高喊一声：情况紧急，我撤退")  then
      self:search_dashi()
      return
   end
	if string.find(l,"挣扎着抽动了几下就死了") then
	    print("战斗结束2")
		shutdown()
		local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  world.Send("get silver from corpse")
		  if self.failure==true then
		    self:jobDone()
		  else
  		    self:recover()
		  end
		end
		b:check()
	   return
	end
	wait.time(5)
  end)
end
--> 你感觉胸中充满浩然正气，心中为之一震。
function jiuyuan:zhengqi()
end

function jiuyuan:search_dashi()
-- 定位当前房间号
-- 范围3格进行搜索
    print("寻找大师!!!")
   local f=function()
      print("定位")
	  local _R
      _R=Room.new()
      _R.CatchEnd=function()
        local count,roomno=Locate(_R)
		print(roomno[1]," 房间号")
	     --if count==1 then
	       --roomno[1]
            local rooms={}
			rooms=depth_search(roomno,3)
			--print("why")
			for _,r in ipairs(rooms) do
			  print("需要遍历的房间->",r)
			end
			jiuyuan.co=coroutine.create(function()
		      for _,r in ipairs(rooms) do
                local w
		        w=walk.new()
		        w.walkover=function()
			      --self:NextPoint()
				  local f2=function() self:NextPoint() end
				  self:check_dashi_status(f2)
		        end
		        w:go(r)
		        coroutine.yield()
              end
			  --print("没找到打湿")
			  print("没找到")
			  self:giveup()
			end)
			self:NextPoint()
		 --end
      end
      _R:CatchStart()
   end
   self:check_dashi_status(f)
end

function jiuyuan:dashi_escape()
   if self.dashi_name==nil or self.dashi_name=="" then
	     self.dashi_name=world.GetVariable("dashi_name")
   end
  wait.make(function()
    local l,w=wait.regexp("^(> |)"..self.dashi_name.."高喊一声：情况紧急，我撤退，你掩护。$",5)
	if l==nil then
	   self:dashi_escape()
	   return
	end
   if string.find(l,"高喊一声：情况紧急，我撤退") then

      print("大师乱跑!!")
	  shutdown()
	  local f=function()
	     self:search_dashi()
	  end
	  f_wait(f,0.3)
	  return
   end
  end)

end

function jiuyuan:giveup()
   self:jobDone()
end

function jiuyuan:combat()

     local pfm=world.GetVariable("pfm1")
	 self:jiaotu_die()
	 local cb=fight.new()
	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
       pfm=string.gsub(pfm,"@id",string.lower(self.player_id).."'s jiaotu")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id",string.lower(self.player_id).."'s jiaotu")
	   cb.unarmed_alias=unarmed_pfm
	   cb.pfm_list=string.gsub(cb.pfm_list,"@id",string.lower(self.player_id).."'s jiaotu")


	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
      cb.finish=function()
	     print("战斗结束1")
		 local b=busy.new()
		 b.interval=0.5
		 b.Next=function()
		   world.Send("get silver from corpse")
		   if self.failure==true then
		     self:jobDone()
		   else
		     self:recover()
		   end
		 end
		 b:check()
	  end
      cb:start()
end

function jiuyuan:redo() --接口回调函数
end

--空性大师不幸阵亡，你任务失败。
function jiuyuan:dashi_die()

   wait.make(function()
      if self.dashi_name==nil or self.dashi_name=="" then
	     self.dashi_name=world.GetVariable("dashi_name")
	  end
      local l,w=wait.regexp("^(> |)"..self.dashi_name.."不幸阵亡，你任务失败。$",5)
	 if l==nil then
	    self:dashi_die()
	    return
	 end
	 if string.find(l,"不幸阵亡，你任务失败") then
	    print("任务失败!!")
	   self.failure=true
	   return
	 end
   end)

end


function jiuyuan:check()
--( 你上一个动作还没有完成，不能施用内功。)
	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
   wait.make(function()
      if self.dashi_name==nil or self.dashi_name=="" then
	     self.dashi_name=world.GetVariable("dashi_name")
	  end
      local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)突然从路边冲出一个魔教教徒，一声不吭的向"..self.dashi_name.."冲去。$",5)
	 if l==nil then
	    self:check()
	    return
	 end
	 if string.find(l,"突然从路边冲出一个魔教教徒，一声不吭的向") then
	   shutdown()
	   self:dashi_escape()
       world.Send("kill "..string.lower(self.player_id).."'s jiaotu")
	   local f=function()
	      world.Send("yun qi")
	      world.Send("kill "..string.lower(self.player_id).."'s jiaotu")
		  self:dashi_die()
	      self:combat()
	   end
	   f_wait(f,0.1)
	   return
	 end
	 if string.find(l,"你的动作还没有完成，不能移动") then
	    shutdown()
		self:shield()
		self:redo()
	   return
	 end

   end)

end

local _dashi_follow_ok=false
function jiuyuan:dashi_follow()
--空见大师从翠屏山道走了过来。
   wait.make(function()

	 local dashi_name=world.GetVariable("dashi_name") or self.dashi_name
     local l,w=wait.regexp("^(> |)"..dashi_name.."从.*走了过来。$",8)
	 if l==nil then
	    print("dashi follow 超时")
		self:dashi_follow()
	    return
	 end
	 if string.find(l,dashi_name) then
		_dashi_follow_ok=true
	    return
	 end
	 wait.time(8)
   end)
end

function jiuyuan:check_dashi_status(callback)
--突然从路边冲出一个魔教教徒，一声不吭的向空见大师冲去。
--  少林派第三十五代弟子「少林长老」空见大师(Mission's dashi) <战斗中>
--  少林派第三十五代弟子「少林长老」空闻大师(Qsmya's dashi) <昏迷不醒>
  	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
	 local dashi_name=world.GetVariable("dashi_name") or self.dashi_name
   wait.make(function()
      world.Execute("look;set look 1") --  空见大师正在运功疗伤
	  local player_id=string.upper(string.sub(self.player_id,1,1))..string.lower(string.sub(self.player_id,2,-1))
      local l,w=wait.regexp("^(> |).*"..dashi_name.."\\\("..player_id.."'s dashi\\\) <昏迷不醒>$|^(> |).*"..dashi_name.."\\\("..player_id.."'s dashi\\\) <战斗中>$|^(> |).*"..dashi_name.."正在运功疗伤.*$|^(> |).*"..dashi_name.."\\\("..player_id.."'s dashi\\\)$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:check_dashi_status(callback)
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      --没有找到
		  callback()
		  return
	  end
	  if string.find(l,"战斗中") then
		 world.Send("kill "..self.player_id.."'s jiaotu")
	     local f=function()
	       world.Send("yun qi")
	       world.Send("kill "..string.lower(self.player_id).."'s jiaotu")
		   self:dashi_die()
	       self:combat()
	      end
	      f_wait(f,0.1)
	      return
	  end
	  if string.find(l,"昏迷不醒") then
	     f_wait(callback,3)
		 return
	  end
	  if string.find(l,player_id) or string.find(l,"正在运功疗伤") then
	      self:shield()
	      self:redo()
		  return
	  end
	  wait.time(6)
   end)
end

function jiuyuan:step_back()
end

function jiuyuan:step1()
	local ts={
	           task_name="少林护送",
	           task_stepname="第一段路径",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="前往蓝田",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	self:check()
    self.redo=function()
	    self:step1()
		--分支
		self.step_back=function()
		   print("重新计算起点:",w.start_roomno)
		   self:reverse(w.start_roomno)
		end
	end
	self.step_back=function()
	  self:reverse(self.target_roomno)
	end
	self:dashi_follow()
	w.Max_Step=0
    w.user_delay=5
	w.walkoff=function()
	  --1 确定大师是否跟上
	  if _dashi_follow_ok==true then --follow 成功
	    print("follow 成功")
        local f=function()
	      _dashi_follow_ok=false
		  self:dashi_follow()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
	    end
        f_wait(f,4)
	  else
	    print("follow 失败")
		if self.target_roomno==nil then
		   self.target_roomno=world.GetVariable("target_roomno")
		end
		self:step_back()
	  end
	end
	w.walkover=function()
	  -- BigData:Auto_catchData()
	   self:step2()
	end
	w:go(211)
end

function jiuyuan:back(roomno)

		--回到出发点
        local w=walk.new()
		  local al
		  al=alias.new()
		  al.guangchang_shanmendian=function()
		     al:knockgatenorth()
		  end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复2")
				  coroutine.resume(jiuyuan.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
			  print("al 松林check")
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end
		  w.user_alias=al
         w.Max_Step=0
		 local fail=function()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
        end
         w.walkoff=function()
            self:check_dashi_status(fail)
         end
         w.walkover=function()

		    local f=function()
			     print("没找到！！")
                 self:giveup()
			end
		    self:check_dashi_status(f)
         end
         w:go(roomno)
end



function jiuyuan:reverse(roomno)
   local fail=function()
	  self:back(roomno)
   end

   self:check_dashi_status(fail)
end


function jiuyuan:step2()
	local ts={
	           task_name="少林护送",
	           task_stepname="第二段路径",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="前往安远门",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	self:check()
    self.redo=function()
	    self:step2()
		self.step_back=function()
		   print("重新计算起点:",w.start_roomno)
		   self:reverse(w.start_roomno)
		end
	end
	self.step_back=function()
	   self:reverse(211)
	end
	self:dashi_follow()
	w.Max_Step=0
	w.user_delay=5
	w.walkoff=function()
	  --1 确定大师是否跟上
	  if _dashi_follow_ok==true then --follow 成功
	    print("follow 成功")
        local f=function()
	      _dashi_follow_ok=false
		  self:dashi_follow()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
	    end
        f_wait(f,4)
	  else
	    print("follow 失败")
		self:step_back()
	  end
	end
	w.walkover=function()
	  -- BigData:Auto_catchData()
	   self:step3()
	end
	w:go(1087)
end

function jiuyuan:step3()
	local ts={
	           task_name="少林护送",
	           task_stepname="第三段路径",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="前往黄河渡口",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	self:check()
    self.redo=function()
	    self:step3()
		self.step_back=function()
		   print("重新计算起点:",w.start_roomno)
		   self:reverse(w.start_roomno)
		end
	end
	self.step_back=function()
	   self:reverse(1087)
	end
	self:dashi_follow()
	w.Max_Step=0
	w.user_delay=5
	w.walkoff=function()
	  --1 确定大师是否跟上
	  if _dashi_follow_ok==true then --follow 成功
	    print("follow 成功")
        local f=function()
	      _dashi_follow_ok=false
		  self:dashi_follow()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
	    end
        f_wait(f,4)
	  else
	    print("follow 失败")
		self:step_back()
		--self:reverse(1087)
	  end
	end
	w.walkover=function()
	  --  BigData:Auto_catchData()
	    self:step4()
	end
	w:go(1351)
end


function jiuyuan:step4()
	local ts={
	           task_name="少林护送",
	           task_stepname="第四段路径",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="前往恒山",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	self:check()
	self:exps()
    self.redo=function()
	    self:step4()
		self.step_back=function()
		   print("重新计算起点:",w.start_roomno)
		   self:reverse(w.start_roomno)
		end
	end
	self.step_back=function()
	    self:reverse(1351)
	end
    local al=alias.new()
	al.dujiang=function()
	   al:yellboat()
	end
	al.duhe=function()
	   al:yellboat()
	end
	w.user_alias=al
	self:dashi_follow()
	w.Max_Step=0
	w.user_delay=5
	w.walkoff=function()
	  --1 确定大师是否跟上
	  if _dashi_follow_ok==true then --follow 成功
	    print("follow 成功")
        local f=function()
	      _dashi_follow_ok=false
		  self:dashi_follow()
          world.Send("yun refresh")
          coroutine.resume(w.output_path)
	    end
        f_wait(f,4)
	  else
	    print("follow 失败")
		self:step_back()
	  end
	end
	w.walkover=function()
	   wait.time(5)
	   print("超时！")
	        local b
			 b=busy.new()
			 b.Next=function()
		       self:jobDone()
			 end
			 b:check()
	end
	w:go(1381)
end

function jiuyuan:checkNPC()
	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
   wait.make(function()
      world.Execute("look;set look 1")
	  local player_id=string.upper(string.sub(self.player_id,1,1))..string.lower(string.sub(self.player_id,2,-1))
      local l,w=wait.regexp("^(> |).*\\\("..player_id.."'s dashi\\\)$|^(> |)设定环境变量：look \\= 1",6)
	  if l==nil then
		self:checkNPC()
		return
	  end
	  if string.find(l,"设定环境变量：look") then
	      --没有找到
		  self:NextPoint()
		  return
	  end
	  if string.find(l,player_id) then
	      world.SetVariable("target_roomno",self.target_roomno)
	      self:follow()
		  return
	  end
	  wait.time(6)
   end)
end

function jiuyuan:follow()
	 if self.player_id=='' then
	    self.player_id=world.GetVariable("player_id")
	 end
   world.Send("follow "..string.lower(self.player_id).."'s dashi")
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
     world.Send("ask "..string.lower(self.player_id).."'s dashi about 救援")
	 self:step1()
   end
   b:check()
end

function jiuyuan:jobDone()
end
--恭喜你！你成功的完成了恒山救援任务！你被奖励了：
--九百三十一点经验!
--二百七十九点潜能!
function jiuyuan:exps()
   wait.make(function()
      local l,w=wait.regexp("^(> |).*说道：「好了，历尽艰险，终于到了恒山。」$",5)
	  if l==nil then
	     self:exps()
	     return
	  end
	  if string.find(l,"好了，历尽艰险，终于到了恒山") then
		  local rc=reward.new()
		  rc:get_reward()
		  print("奖励！")
		  wait.time(2)
		  shutdown()
	         local b
			 b=busy.new()
			 b.Next=function()
		       self:jobDone()
			 end
			 b:check()
	     return
	  end

   end)
--好，任务完成，你得到了一千四百四十六点实战经验和三百七十点潜能。
end

function jiuyuan:NextPoint()
   print("进程恢复")
   coroutine.resume(jiuyuan.co)
end

function jiuyuan:find_dashi(location)

 local n,rooms=Where(location)
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	    self:shield()
	   jiuyuan.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  w.noway=function()
		    self:giveup()
		  end
		  local al
		  al=alias.new()
		  al.guangchang_shanmendian=function()
		     al:knockgatenorth()
		  end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("进程恢复2")
				  coroutine.resume(jiuyuan.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
			  print("al 松林check")
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC()
		  end
		  print("下一个房间号:",r)
		  self.target_roomno=r
		  w:go(r)
		  coroutine.yield()
	    end
		print("没有找到npc!!")
		self:giveup()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("没有目标,放弃")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:giveup()
	  end
	  b:check()
	end
end

function jiuyuan:catch_place()
--玄慈大师说道：「方正大师现在立雪亭。」
 wait.make(function()
      local l,w=wait.regexp("^(> |)玄慈大师说道：「(.*)现在(.*)。」$|^(> |)玄慈大师说道：「我这里现在没有什么任务给你。」$|^(> |)玄慈大师说道：「你武功精进也太慢了，老衲怎么放心让你去干啊。」$|^(> |)玄慈大师说道：「你刚才不是已经问过了吗？」$|^(> |)玄慈大师说道：「嗯，已经有人在帮我了，你还是去忙点别的什么吧。」$",5)
	  if l==nil then
	     self:ask_job()
	     return
	  end
	 if string.find(l,"我这里现在没有什么任务给你") or string.find(l,"你武功精进也太慢了") or string.find(l,"已经有人在帮我了") then
		world.AppendToNotepad (WorldName().."_少林护送任务:",os.date()..": 现在暂时没有适合的工作！\r\n")
	    self.fail(101)
	    return
	 end
	 if string.find(l,"你刚才不是已经问过了吗") then
        world.AppendToNotepad (WorldName().."_少林护送任务:",os.date()..": 重新连接\r\n")
		sj.world_init=function()
			print("重新连接!!")
			Weapon_Check(process.jy)
		end
		local b=busy.new()
		b.Next=function()
			relogin(60)
		end
		b:check()
	   return
	end
	  if string.find(l,"现在") then
       -- BigData:Auto_catchData()
		self.dashi_name=Trim(w[2])
		world.SetVariable("dashi_name",self.dashi_name)
	    local place=Trim(w[3])
		world.AppendToNotepad (WorldName().."_少林护送任务:",os.date()..": 地点->"..place.."\r\n")
	     print("地点:",place)
		 if place=="钟楼" then
	       place="钟楼七层"
	     end
		 if place=="鼓楼" then
		   place="鼓楼七层"
		 end
	     place="嵩山少林"..place
	     self:find_dashi(place)
	    return
	  end

	  wait.time(5)
 end)
end

function jiuyuan:fail(id)
end

function jiuyuan:ask_job()
  local w=walk.new()
  w.walkover=function()
   wait.make(function()
     world.Send("ask xuanci about job")
	 local l,w=wait.regexp("^(> |)你向玄慈大师打听有关『job』的消息。$",5)
	 if l==nil then
	    self:ask_job()
		return
	 end
	 if string.find(l,"你向玄慈大师打听有关") then
	    self:catch_place()
	    return
	 end

	 wait.time(5)
	 end)
  end
  w:go(2553)
end

function jiuyuan:recover()

    world.Send("yun recover")
    world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()
	    if h.qi_percent<100 then --受伤了
		    print("打通经脉")
            local rc=heal.new()
			rc.hudiegu=function()
			  rc:heal(false)
			end
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
			    if self.fighting==true then
	                print("正在战斗中，停止打坐")
					return
                end
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun jing")
				  world.Send("yun recover")
				  local f=function()
				     self:recover()
				  end
				  f_wait(f,2)
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
			    if self.fighting==true then
                   print("正在战斗中，停止打坐")
	               return
               end
			   world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			      print("状态恢复")
				  self:shield()
				  self:redo()
			   else
	             print("继续修炼")
		         self:recover()
			   end
			end
			x:dazuo()
		else
		     print("状态良好")
			 self:shield()
		     self:redo()
		end
	end
	h:check()
end

function jiuyuan:Status_Check()
	local ts={
	           task_name="少林护送",
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
			          self:Status_Check()
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
			        rc:heal()
				    return
				 end
			   end
		     end
		    print("full")
            self:full()
	end
	cd:start()
end

function jiuyuan:shield()

end

function jiuyuan:full()

	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<80 or h.drink<80 then
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
			--rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc.liaoshang_fail=function()
			   print("shaolin 疗伤fail")
			   self:liaoshang_fail()
			end
			rc:liaoshang()

		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    print("full")
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
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
				  self:full()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(2552)
			   end
			end
			x.success=function(h)
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
