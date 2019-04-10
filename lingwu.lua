lingwu={
  new=function()
     lw={}
	 lw.skills={}
	  setmetatable(lw,lingwu)
	 return lw
  end,
  lingwu_times=5,
  lingwu_place=2540,
  vip=false,
  run_vip=false,
  interval=0.3,
  skills={},
  exps_table={},
  me_skills={},
  exps=0,
  skillsIndex=1,
  max_level=0,
  co=nil,
  status=false,
  isfull=false,
  times=5,
}
lingwu.__index=lingwu

function lingwu:addskill(skill)
   --print(table.getn(self.skills),skillname)
   table.insert(self.skills,skill)
end

function lingwu:get_max_level()
   local m=99999
   for _,i in ipairs(self.exps_table) do
      --print(i.exps," ?>",self.exps)
      if tonumber(i.exps)>self.exps and tonumber(i.level)<m then
	     m=tonumber(i.level)
	  end
   end
   if m==99999 then
       self.max_level=0
   else
      self.max_level=m-1
	  print("最大等级:",self.max_level)
   end
end

function lingwu:set_exps(level,exps)
   local value={}
   value.level=level
   value.exps=exps
   table.insert(self.exps_table,value)
end

function lingwu:get_exps_end()
   --获得技能上限制
   self:get_max_level()
   self:get_skills()
end

--您本次在线二小时五十四分二十九秒。
--经验值增加了4006点。
--每小时进帐：一千三百二十点经验。
function lingwu:get_exps_add()
   wait.make(function()
    local l,w=wait.regexp("^(> |)经验值增加了(.*)点。",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"经验值增加了") then
	      local get_exp=w[2]
		  world.SetVariable("get_exp",get_exp)
	      return
	  end
   end)
end

function lingwu:get_per_exps_add()
   wait.make(function()
      local l,w=wait.regexp("^(> |)每小时进帐：(.*)点经验。",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"每小时进帐") then
	      local per_exps=ChineseNum(w[2])
		  world.SetVariable("per_exps",per_exps)
	      return
	  end
   end)
end

function lingwu:reset()
	shutdown()
	local b=busy.new()
	b.Next=function()
		self:finish()
	end
	b:check()
end

function lingwu:SetTime(seconds)
     local d=os.time()
	--world.Send("set clock_out "..d)
    self.starttime=d
    print(seconds," 秒恢复工作!")
	self.seconds=seconds
	--[[lingwu.co=coroutine.create(function()
	   print("停止领悟 恢复工作！")
	   if self.status==false then
	      return
	   end
		shutdown()
		local b=busy.new()
		b.Next=function()
		  self:finish()
		end
		b:check()
	end)
   local hours = math.floor(seconds / 3600)
    seconds = seconds - (hours * 3600)
   local minutes = math.floor(seconds / 60)
    seconds = seconds - (minutes * 60)
	world.AddTimer("lw", hours, minutes, seconds, "lingwu:reset()", timer_flag.Enabled + timer_flag.OneShot, "")
    world.SetTimerOption ("lw", "send_to", 12)]]
end

function lingwu:exps_list()
   wait.make(function()
       local l,w=wait.regexp("(\\d*)\\s+(\\d*)\\s*\\|\\s*(\\d*)\\s+(\\d*)\\s*\\|\\s*(\\d*)\\s+(\\d*)\\s*\\|\\s*(\\d*)\\s+(\\d*)\\s*\\|\\s*(\\d*)\\s+(\\d*)$|^(> |)您本次在线(.*)。$",10)
	   if l==nil then
	      self:get_exps()
	      return
	   end
	   if string.find(l,"|") then
		  --print(w[1],w[2],w[3],w[4],w[5],w[6],w[7],w[8],w[9],w[10])
          self:set_exps(w[1],w[2])
		  self:set_exps(w[3],w[4])
		  self:set_exps(w[5],w[6])
		  self:set_exps(w[7],w[8])
		  self:set_exps(w[9],w[10])
		  self:exps_list()
		  return
	   end
	   if string.find(l,"您本次在线") then
	      local connect_hour=w[12]
		  world.SetVariable("connect_hour",connect_hour)
		  self:get_exps_add()
		  self:get_per_exps_add()
	      self:get_exps_end()
	      return
	   end

   end)
end

function lingwu:get_exps()
--[[等级和经验简明对照表
433  8062156 | 438  8345345 | 443  8635088 | 448  8931462 | 453  9234540
434  8118273 | 439  8402767 | 444  8693830 | 449  8991539 | 454  9295967
435  8174650 | 440  8460451 | 445  8752838 | 450  9051884 | 455  9357666
436  8231287 | 441  8518400 | 446  8812112 | 451  9112500 | 456  9419637
437  8288185 | 442  8576612 | 447  8871653 | 452  9173385 | 457  9481881
您本次在线三小时一分三十七秒。]]
   self.status=true
   print("当前技能上限！！")
    world.Send("exp")
	self.exps_table={},
   wait.make(function()
     local l,w=wait.regexp("等级和经验简明对照表",5)
	 if l==nil then
	    self:get_exps()
	    return
	 end
	 if string.find(l,"等级和经验简明对照表") then
	    self:exps_list()
	    return
	 end
   end)
end


function lingwu:get_skill(skill_id)
   -- print("获得等级:",skill_id)
	--print(table.getn(self.me_skills))
    for _,i in ipairs(self.me_skills) do
       if i.skill_id==skill_id then
	      --print(i.skill_id," -> ",skill_id)
		  return tonumber(i.level)
  	   end
	end
	return 0
end

function lingwu:set_skill(skill_name,skill_id,level,pots)
	local skill={}
	skill.skill_id=skill_id
	skill.level=tonumber(level)
	skill.pots=tonumber(pots)
	skill.name=string.gsub(skill_name,"□","")
    table.insert(self.me_skills,skill)
end

--获得特殊技能等级 当前技能等级  支持最大技能等级  判断能否领悟

--获得基本技能等级 当前技能等级  支持最大技能等级  判断能否练

function lingwu:wuxing()
end

--1 判断能否领悟 是 否
function lingwu:ok_lingwu(base_skill,special_skill)
   --print("ok_lingwu:",base_skill," -> ",special_skill)
    local base_level=self:get_skill(base_skill)
	--print("基本:",base_level)
	local special_level=self:get_skill(special_skill)
	--print("特殊:",special_level)
   if base_level<=special_level and base_level<self.max_level then
      return true
   end
   return false
end

function lingwu:ok_lian(base_skill,special_skill)
    --print("ok_lian:",base_skill," -> ",special_skill)
    local base_level=self:get_skill(base_skill)
	--print("基本:",base_level)
	local special_level=self:get_skill(special_skill)
	--print("特殊:",special_level,"  <  ",self.max_level)
	if base_level>special_level and special_level<self.max_level  then
	  --print("真")
	  return true
	else
	  --print("假")
      return false
    end

end

function lingwu:Next() --下一个学习内容
  self.skillsIndex=self.skillsIndex+1
  --print(self.skillsIndex,"/",table.getn(self.skills))
  if self.skillsIndex>table.getn(self.skills) then
     self.isfull=true
     return false
  else
     self.isfull=false
     return true
  end
end

--2 否 -> 判断是否练 是 否
--3 否 -> 下一项

---**************** 领悟问题
function lingwu:lag()
  -- print("lag 复原")
   wait.make(function()
	 local l,w=wait.regexp("^(> |)由于实战经验不足，阻碍了你的「(.*)」进步！$|^(> |)你的.*造诣不够，无法领悟更深一层的(.*)。$|^(> |)你从实战中得到的潜能已经用完了。$|^(> |)你的「.*」进步了！$",10)
	 if l==nil then

	    --self.continue=true--10s 还原
		self:lag()
		 --print("self continue:",true)
		return
	 end
	 if string.find(l,"进步了") then
	    self:base_levelup()
		shutdown()
		local f=function() self:start() end
		f_wait(f,self.interval)
	    return
	 end
	  if string.find(l,"由于实战经验不足") then
	     shutdown()


		local f=function() self:get_skills() end
		f_wait(f,self.interval)
		return
     end


	 if  string.find(l,"造诣不够") then
	    shutdown()
		--vip 需要先去关闭
		--开始练skill


		 local f=function() self:get_skills() end
		f_wait(f,self.interval)
	    return
	 end
	 if string.find(l,"你从实战中得到的潜能已经用完了") then
	     --self.continue=true
		 --print("self continue:",true)
         --print("你捡起了一柄"..w[1])
		 shutdown()
		 print("你的潜能不足")
		 local f=function() self:finish() end
		 f_wait(f,self.interval)
		 return
     end

	--[[ if string.find(l,"你瞑思苦想") then
	    print("self continue:",true)
		self.continue=true--10s 还原
		self:lag()
		return
	 end]]

	wait.time(10)
   end)
end

function lingwu:rest() --默认函数
	     local w
		  w=walk.new()
		  w.walkover=function()
			 local _rest=rest.new()
			 _rest.failure=function(id)
			    local f=function() w:go(142) end
				f_wait(f,10)
 			 end
			 _rest.wake=function(flag)
			     if flag==0 then
			          print("睡觉太频繁了!")
			          local ch=hp.new()
			          ch.checkover=function()
			             if ch.pot<10 then
							 self:finish()
						 else
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  睡觉太频繁 打坐 start
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
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
							     self:go()
							  end
	                          x:dazuo()
							  ---  睡觉太频繁 打坐 end
			                end
                            w1:go(142)
						 end
			          end
					  ch:check()
				  else
					self:go()
				  end
			 end
			 _rest:sleep()
		  end
		  w:go(142)
end

function lingwu:neili_empty()
      --shutdown()
         local lwhp=hp.new()
		 lwhp.checkover=function()
		   if lwhp.qi_percent<=80 or lwhp.jingxue_percent<=80  then
			 local rc=heal.new()
			 rc.teach_skill=teach_skill --config 全局变量
			 rc.saferoom=505
			 rc.heal_ok=function()
			    self:go()
			 end
			 rc:liaoshang()
			 return
		   end
		   if lwhp.neili<lwhp.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                self:xiulian()
            end
			r:wash()
			return
		   end
		   --[[
		   if lwhp.neili<500 then

			  if self.exps>800000 then
			     --self:xiulian()
				  local h=hp.new()
                  h.checkover=function()
                   if h.neili<h.max_neili*0.5 then
		           local r=rest.new()
			       r.wash_over=function()
                     self:xiulian()
                   end
			 	   r:wash()
                  else
      --
                    self:xiulian()
			      end
                 end
                 h:check()
			  else
                 self:rest()
			  end
		   end]]
         end
		 lwhp:check()
end

 function lingwu:regenerate()
   -- regenerate_trigger()
    wait.make(function()
    world.Send("yun regenerate")
	local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你的真气不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你现在精神饱满。$",5)
   if l==nil then
	  self:regenerate()
	  return
   end
   if string.find(l,"不够") then
	  self:neili_empty()
	 return
   end
   if string.find(l,"你深深吸了几口气，精神看起来好多了") or string.find(l,"你现在精神饱满") then
     self:start()
	 return
   end
   wait.time(5)
   end)
end

function lingwu:lingwu_Execute(cmd,times)
  if self.starttime then  --最大时间

		 local t1=os.time()
		 local interval=os.difftime(t1,self.starttime)
		 --print(interval,":秒","时间间隔")
	if 	interval>self.seconds then
       self:reset()
	   return
	end
  end
  wait.make(function()
--[[ self.lingwu_times>1 then
     self.lingwu_times=self.lingwu_times-1
  else
	   self:neili_empty()
  end]]

	   self:wuxing()
	   local cmds=""
	   local i
	   for i=1,times,1 do
	     cmds=cmds..cmd..";"
	   end
	   cmds=string.sub(cmds,1,-2)
	    world.Execute("yun regenerate;"..cmds..";set action 领悟")
	   --world.Execute(cmd)
	   --world.Execute(cmd)
	   --world.Execute(cmd)
	   --world.Execute(cmd)
	   --world.Execute(cmd)
	   --world.Send("set action 领悟")
	   --self.continue=false
	--   print("flag",false)
	-- else
	--   local f=function() self:Execute(cmd) end
	--   f_wait(f,self.interval)
	--   return
	-- end
	 local l,w=wait.regexp("^(> |)你没办法集中精神。$|^(> |)格式： lingwu.*$|^(> |)设定环境变量：action \\= \\\"领悟\\\"$",5)

     if l==nil then
	      print("领悟超时")
		  self:lingwu_Execute(cmd,times)
		  --self:try_again(cmd)
		return
     end
	if string.find(l,"你没办法集中精神") then
	     --self.continue=true
		 --print("self continue:",true)
         --print("你捡起了一柄"..w[1])
		 --shutdown()
		 print("你没办法集中精神")
		 local f=function() self:regenerate() end
		 f_wait(f,self.interval)
		 return
     end

	 if string.find(l,"lingwu") then
	   shutdown()
	   self:go()
	   return
	 end
	 if string.find(l,"设定环境变量：action") then
	  local f=function()
	   self:lingwu_Execute(cmd,times)
	  end
	  f_wait(f,0.3)
       return
	 end
     --等待
    wait.time(5)
end)
end


---****************** 练的部分 ********************
function lingwu:neili_lack(callback)
  --print("neili_lack")
   shutdown()
  local f2=function()
    print("修炼内力2")
   local x
	x=xiulian.new()
	x.safe_qi=300
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
		if id==202 then
	          local w
		      w=walk.new()
		      w.walkover=function()
			    x:dazuo()
		      end
		     local _R
             _R=Room.new()
             _R.CatchEnd=function()
               local count,roomno=Locate(_R)
		       print(roomno[1])
		       local r=nearest_room(roomno)
			   w:go(r)
	         end
			_R:CatchStart()
	    end
	end
	x.success=function(h)
		print(h.qi,h.max_qi*0.9)
		print(h.neili,h.max_neili*1.5)
		if h.neili>h.max_neili*1.5 then
		  if callback~=nil then
		     callback()
		  else
		     self:start()
		  end

		else
		  print("继续修炼")
		  world.Send("yun recover")
		  x:dazuo()
		end
	end
	x:dazuo()
  end

  local h=hp.new()
  h.checkover=function()
   if h.neili<h.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                f2()
            end
			r:wash()
   else
      --
      f2()

   end
  end
  h:check()

end


function lingwu:refresh(cmd)
   -- regenerate_trigger()
    wait.make(function()
    world.Send("yun refresh")
	local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你长长地舒了一口气。$|^(> |)你现在精力充沛。$",5)
   if l==nil then
      --self.start_failure(-1)
	  self:refresh(cmd)
	  return
   end
   if string.find(l,"内力不够") then
	  self:neili_empty()
	 return
   end
   if string.find(l,"你长长地舒了一口气") or string.find(l,"你现在精力充沛") then
     self:lian_Execute(cmd)
	 return
   end
   wait.time(5)
   end)
end

function lingwu:move(cmd)
  local w
  w=walk.new()
  w.walkover=function()
    --BigData:Auto_catchData()
	self:lian_Execute(cmd)
  end
 local _R
 _R=Room.new()
 _R.CatchEnd=function()
	local count,roomno=Locate(_R)
	print(roomno[1])
	local r=nearest_room(roomno)
	w:go(r)
  end
  _R:CatchStart()
end

function lingwu:xiulian()
  --
  shutdown()
  print("修炼内力1")
   local x
	x=xiulian.new()
	x.safe_qi=300
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
		if id==202 then
	          local w
		      w=walk.new()
		      w.walkover=function()
			     --BigData:catchData(2542,"回廊")
			    x:dazuo()
		      end
		     local _R
             _R=Room.new()
             _R.CatchEnd=function()
               local count,roomno=Locate(_R)
		       print(roomno[1])
		       local r=nearest_room(roomno)
			   w:go(r)
	         end
			_R:CatchStart()
	    end
	end
	x.success=function(h)
		print(h.qi,h.max_qi*0.9)
		print(h.neili,h.max_neili*1.5)
		if h.neili>h.max_neili*1.5 then
		   self:go()
		else
		  print("继续修炼")
		  world.Send("yun recover")
		  x:dazuo()
		end
	end
	x:dazuo()

  --[[
  local h=hp.new()
  h.checkover=function()
   if h.neili<h.max_neili*0.5 and h.max_neili>=4000 then
		    local r=rest.new()
			r.wash_over=function()
                f2()
            end
			r:wash()
   else
      --
      f2()

  end
  end
  h:check()]]
end

function lingwu:wield_weapon_start(cmd)

   wait.make(function() --你将一柄不老太风刀抽出握在了手中。
	local l,w=wait.regexp("^(> |)你身上没有这样东西。$|^(> |)你装备.*作武器。$|^(> |)你.*握在.*手中。$|^(> |)你感觉全身气息翻腾，原来你真气不够，不能装备.*。$|^(> |)你已经装备著了。$|^(> |)你从怀中掏出.*|^(> |)你从背后取出.*|^(> |)你将.*握在手中。$|^(> |)你轻轻一抖手中红缨白蜡大枪，只见枪尖突如闪电，在空中点出七朵梨花。$|^(> |)已多了柄弯弯曲曲的奇形宝剑。剑身的寒光映照出你脸上浮现出诡异神情。$|^(> |)你“唰”的一声从腰间抽出一把寒光凛冽的雪亮钢刀。$|^(> |)你喋喋怪笑，不知不觉中摸出一把金蛇锥扣在手中！$|^(> |)你喋喋怪笑，暗中却把金蛇锥扣在手心！$|^(> |)你「唰」的一声抖出一柄.*握在手中。$|^(> |)你跨了个马步，抖了抖手中的齐眉棍。$|^(> |)你缓缓抽出一柄阴阳九龙令，只见寒芒吞吐，隐隐有龙吟之声。$|^(> |)你从袖里抽出一只.*$|^(> |)你抽出.*握在手中掂了掂。$",5)
	 if l==nil then
	    self:wield_weapon_Catch(cmd)
	    return
	 end
	 if string.find(l,"你身上没有这样东西") then
	    print("练习下个")
		if self:Next()==true then
			local f=function()
				self:start()
			end
			f_wait(f,0.2)
		else
			self:finish()
		end
	    return
	 end
	 if string.find(l,"你感觉全身气息翻腾") then
	    self:xiulian()
	    return
	 end
	 --> 你喋喋怪笑，不知不觉中摸出一把金蛇锥扣在手中！
	 --你“唰”的一声从腰间抽出一把寒光凛冽的雪亮钢刀。
	 if string.find(l,"你抽出") or string.find(l,"你从袖里抽出一只") or string.find(l,"你缓缓抽出一柄阴阳九龙令") or string.find(l,"你跨了个马步") or string.find(l,"抽出") or string.find(l,"手中") or string.find(l,"手心") or string.find(l,"已多了") or string.find(l,"装备") or string.find(l,"你从怀中掏出") or string.find(l,"取出") or string.find(l,"握在手中") then
         self:lian_Execute(cmd)
		 return
	 end
	 wait.time(5)
	end)
end

function lingwu:wield_weapon_Catch(cmd)



	wait.make(function()

	   local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"装备\\\"$",5)
	   if l==nil then
	      self:wield_weapon_start(cmd)
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
	      self:wield_weapon_start(cmd)
	      return
	   end
	end)
end

function lingwu:wield_weapon(cmd)
   local sp=special_item.new()
   sp.cooldown=function()
	local i=self.skillsIndex
	local skillname=self.skills[i].base_skill
	local special_skill=self.skills[i].special_skill
	local weapon=self.skills[i].weapon
    world.Send("set action 装备")
	if weapon~=nil then

	      world.Send("wield "..weapon)
	      self.weapon=weapon
          self:wield_weapon_Catch(cmd)
		  return
	end
	print(skillname," 根据技能名称判断使用的武器!!")
	if string.find(skillname,"sword") then
		world.Send("wield jian")
		world.Send("wield xiao")
		world.Send("wield sword")
		self.weapon="sword"
	elseif string.find(skillname,"blade") then
	   if special_skill=="wuhu-duanmendao" then
	      --查看是否携带秘籍
		  --一本五虎断门刀秘籍(Wuhuduanmendao miji)
		   local sp2=special_item.new()
		   sp2.cooldown=function()
		       for _,i in ipairs(sp.equipment_items) do
		        if string.find(i.name,"五虎断门刀秘籍") then
				 local f=function()
		          self:get_skills()
		         end
	             process.readbook("read wuhuduanmendao miji",f)
				 return
				end
			   end
			    print("没有秘籍")
			   world.Send("wield dao")
			   world.Send("wield wan dao")
		       world.Send("wield blade")
		       self.weapon="blade"
			   self:wield_weapon_Catch(cmd)
		   end
		   sp2:check_items("五虎断门刀秘籍")
	      return
	   else
	      world.Send("wield dao")
		  world.Send("wield blade")
		  self.weapon="blade"
	   end

	elseif string.find(skillname,"staff") then
	    world.Send("wield zhang")
		world.Send("wield staff")
		self.weapon="staff"
	elseif string.find(skillname,"whip") then
		world.Send("wield bian")
		world.Send("wield whip")
		self.weapon="bian"
	elseif string.find(skillname,"dagger") then
       world.Send("wield bishou")
	   world.Send("wield dagger")
		self.weapon="bishou"
    elseif string.find(skillname,"hammer") then
	   world.Send("wield falun")
	   world.Send("wield hammer")
		self.weapon="falun"
	elseif string.find(skillname,"brush") then
	   world.Send("wield bi")
	   world.Send("brush")
		self.weapon="bi"
	elseif string.find(skillname,"stick") then
	   world.Send("wield bang")
	   world.Send("wield stick")
	   self.weapon="bang"
	elseif string.find(skillname,"force") then
	   self.weapon=""
	   self:start()
	   return
	elseif string.find(skillname,"hook") then
	   world.Send("wield gou")
	   world.Send("wield hook")
	   self.weapon="gou"
	elseif string.find(skillname,"club") then
	    world.Send("wield club")
		world.Send("wield gun")
		self.weapon="club"
	elseif weapon~=nil then
	    world.Send("wield "..weapon)
	    self.weapon=weapon
	end
    self:wield_weapon_Catch(cmd)
  end
  sp:unwield_all()
end

function lingwu:base_levelup()
    local i
	i=self.skillsIndex
	local base_skill=self.skills[i].base_skill

	for _,i in ipairs(self.me_skills) do
        if i.skill_id==base_skill then
	        i.level=tonumber(i.level)+1
			break
     	end
    end
	--print("*******")
	--for _,i in ipairs(self.me_skills) do
	--    print(i.skill_id," -> ",i.level)
	--end
end


function  lingwu:special_levelup()
    local i
	i=self.skillsIndex
	local special_skill=self.skills[i].special_skill

	for _,i in ipairs(self.me_skills) do
        if i.skill_id==special_skill then
	        i.level=tonumber(i.level)+1
			break
     	end
    end
	--print("*******")
	--for _,i in ipairs(self.me_skills) do
	--    print(i.skill_id," -> ",i.level)
	--end
end
--你的「杨家枪法」进步了！
--你的基本功火候未到，必须先打好基础才能继续提高。
--你的内力不够，练不了密宗大手印。
--你必须先找一条鞭子才能练鞭法。
function lingwu:lian_Execute(cmd,callback)
  if self.starttime then  --最大时间

		 local t1=os.time()
		 local interval=os.difftime(t1,self.starttime)
		 --print(interval,":秒","时间间隔")
	if 	interval>self.seconds then
       self:reset()
	   return
	end
  end
  wait.make(function()
	 world.Execute(cmd) --你的体力太差了，不能练燕灵身法。 你的精力太低了，无法练习震山绵掌 你现在的精力太差了，不能练习华山身法。修习旋风扫叶腿必须有碧海潮生功配合。
	 local l,w=wait.regexp("(> |)你的体力不够练.*$|^(> |)你的体力太差了，不能练五毒烟萝步。$|^(> |)你的体力太低了。$|^(> |)你的精力太差了，不能练.*。|^(> |)你的内力不够练.*|^(> |)你的内力不够。$|^(> |)你的体力不够.*。$|^(> |)你的体力太低了。$|^(> |)你的体力太差了，不能练.*。$|^(> |)你的精力太低了。$|^(> |)你现在的修为不足以提高.*$|^(> |)你使用的武器不对。$|^(> |)由于实战经验不足，阻碍了你的.*进步！$|^(> |)(练|学习|学).*须空手.*$|^(> |)学.*时手里不能拿武器。$|^(> |)空手方能练.*$|^(> |)你的「.*」进步了！$|^(> |)空手时无法练.*。$|^(> |)你该休息一下了，等会再练.*。$|^(> |)你无法静下心来修炼。$|^(> |)卧室不能练功，会影响别人休息。$|^(> |)你先歇口气再练吧。$|^(> |)空了手.*。$|^(> |)你手上的武器不能用来练.*。$|^(> |)你的精力不够练.*$|^(> |)你手里有兵器，.*$|^(> |)你的内力不够.*$|^(> |)你的现在的内力不足,无法继续练.*$|^(> |)你的精力太低了，无法练习.*$|^(> |).*必须空手。$|^(> |)你现在的精力太差了，不能练习.*。$|^(> |)你的体力目前没有办法练习.*。$|^(> |)你没有使用的武器.*$|^(> |)你先聚集点内力再练.*$|^(> |)你的基本功火候未到，必须先打好基础才能继续提高。$|^(> |)练.*须空手。$|^(> |)修习.*必须有碧海潮生功配合。$|^(> |)你必须用剑，才能进一步练习金蛇剑法。$|^(> |)「五虎断门刀」绝学只能从秘籍中领悟。$|^(> |)你反复练习无相劫指，获得了不少进步！$|^(> |)你太累了。$|^(> |)你必须使用金蛇剑才能进一步练习你的金蛇剑法。$|^(> |)练天山六阳掌必须空掌。$|^(> |)你的内力不够，练不了.*$|^(> |)你练习着无上大力杵法，却感到武器太不对劲。$|^(> |)你太累了，歇口气再练吧。$|^(> |)你的内力太少了，歇口气再练吧。$|^(> |)你必须先找一条鞭子才能练鞭法。$",1.5)
     if l==nil then
		    self:lian_Execute(cmd,callback)
		return
     end
	 --你现在的修为不足以提高碧海潮生功了。
	if string.find(l,"你反复练习无相劫指，获得了不少进步") then
	    print("练无相劫指")
	    callback()
	    return
	end
	if string.find(l,"由于实战经验不足") or string.find(l,"你的基本功火候未到，必须先打好基础才能继续提高") then
	  	local f=function() self:get_skills() end
        print "由于实战经验不足,重新判断skill"
		f_wait(f,self.interval)
		return
	 end
	 --[[
	  if string.find(l,"你的内力不够。") then
	     world.Send("unset 积蓄")
		    local f=function()
			   local f2=function() self:lian_Execute(cmd) end
	           switch(f2)
	        end
	        f_wait(f,120)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			    process.neigong3()
			end
			b:check()
	     return
	  end
   ]]
	 if string.find(l,"你现在的修为不足以提高") then  --你现在的修为不足以提高九阳神功。
	 --内力不够 or pot不够
	    local h=hp.new()
		h.checkover=function()
		  if h.pot<10 then
			 local f=function() self:finish() end
		     f_wait(f,self.interval)
			 return
		  end
	       local f=function() self:neili_lack() end
		   f_wait(f,self.interval)
		end
		h:check()
		return
	 end
    --[[ if string.find(l,"获得了不少进步") then
	    local f=function() self:start_success() end
        --print "成功"
		f_wait(f,self.interval)
		return
     end]]
	 if string.find(l,"进步了") then
	    --world.("lingwu_end","false")
		--self.levelup=true
		print("*******************等级升级！！！！***********************")
		self:special_levelup()
		 local i
	     i=self.skillsIndex
		 local special_skill=self.skills[i].special_skill
		 local base_skill=self.skills[i].base_skill
		 local base_level=0
		 local special_level=0
		 for _,i in ipairs(self.me_skills) do
           if i.skill_id==base_skill then
	          base_level=tonumber(i.level)
     	   end
		   if i.skill_id==special_skill then
		      special_level=tonumber(i.level)
		   end
         end
		 print(special_level,"?",base_level)
		 if special_level<base_level then
		   self:lian_Execute(cmd)
		 else
		    local f=function() self:get_skills() end
             print "重新判断skill"
	     	 f_wait(f,self.interval)
		 end
	    return
	 end
    if string.find(l,"却感到武器太不对劲") or string.find(l,"你必须用剑") or string.find(l,"你必须使用金蛇剑") or string.find(l,"你使用的武器不对") or string.find(l,"空手时无法练") or string.find(l,"你手上的武器") or string.find(l,"你没有使用的武器") or string.find(l,"一条鞭子") then
		self:wield_weapon(cmd)
		return
     end--精力太差 > 你的体力太低了。
	 if string.find(l,"你的体力太差了") or string.find(l,"你的体力太低了") or string.find(l,"你的体力不够") then
	    world.Send("yun qi")
	    self:refresh(cmd)
	   return
	 end
     if string.find(l,"你太累了") or string.find(l,"精力太差了") or string.find(l,"你的精力太低了") or string.find(l,"你的体力太差了") or string.find(l,"你的体力不够") or string.find(l,"你的体力太低了") or string.find(l,"你该休息一下了") or string.find(l,"歇口气") or string.find(l,"你的精力不够") or string.find(l,"你的体力目前没有办法练习") or string.find(l,"你太累了") then
	   self:refresh(cmd)
	   return
	 end
	 if string.find(l,"你的内力太少了") or string.find(l,"你的内力不够，练不了") or string.find(l,"你的内力不够练") or string.find(l,"你的内力不够") or string.find(l,"你的现在的内力不足") or string.find(l,"你先聚集点内力再练") then
	   local f=function() self:get_skills() end
	   self:neili_lack(f)
	   return
	 end
	 if string.find(l,"你无法静下心来修炼") or string.find(l,"卧室不能练功，会影响别人休息") then
	   print("无法练习房间")
	   self:move(cmd)
	   return
	 end
	 if string.find(l,"修习.*必须有碧海潮生功配合") then
	    world.Send("jifa force bihai-chaosheng")
		self:lian_Execute(cmd)
	    return
	 end
	 if string.find(l,"五虎断门刀") then
	    local f=function()
		  self:get_skills()
		end
	    process.readbook("read miji",f)

	    return
	 end

     if string.find(l,"空手") or string.find(l,"空掌") or string.find(l,"不能拿武器") or string.find(l,"空了手") or string.find(l,"你手里有兵器")  then
	    local sp=special_item.new()
		sp.cooldown=function()
		  self:lian_Execute(cmd)
		end
		sp:unwield_all()
	    return
	 end
     --等待
    wait.time(1.5)
	--print("继续")
end)
end

function lingwu:lingwu_dzxy(cmd)
  wait.make(function()
    world.Send(cmd)
    local l,w=wait.regexp("^(> |)你.*，冥冥之中你的斗转星移又进了一步。$|^(> |)你又掌握了一些在实战中运用斗转星移的技巧。$|^(> |)你的内力不够。$|^(> |)你仰首望天，太阳挂在天空中，白云朵朵，阳光顺着云层的边缘洒下来，你觉得有些刺眼。$|^(> |)你要看什么？$|^(> |)你对着字画看了半天，结果对你来说已经太浅了，什么都没有学到！$",5)
     if l==nil then
	   self:lingwu_dzxy(cmd)
	   return
	 end
	 if string.find(l,"冥冥之中你的斗转星移又进了一步") or string.find(l,"你又掌握了一些在实战中运用斗转星移的技巧") then
	   local f=function()
	     world.Send("yun jing")
	     self:lingwu_dzxy(cmd)
	   end
	   f_wait(f,0.3)
	   return
	 end
	 if string.find(l,"你的内力不够") then
		  local f=function()
		     self:lingwu_dzxy(cmd)
		  end
         self:neili_lack(f)
	   return
	 end
	 if string.find(l,"你仰首望天，太阳挂在天空中，白云朵朵，阳光顺着云层的边缘洒下来，你觉得有些刺眼") then
		print("练习下个")
		if self:Next()==true then
			local f=function()
				self:start()
			end
			f_wait(f,0.2)
		else
			self:finish()
		end
	    return
	 end
	 if string.find(l,"你对着字画看了半天，结果对你来说已经太浅了，什么都没有学到") then
	    self:douzhuan_xingyi2()
	    return
	 end
	 if string.find(l,"你要看什么") then
	    self:douzhuan_xingyi3()
	    return
	 end
	 wait.time(5)
  end)
end

function lingwu:douzhuan_xingyi()  --领悟斗转
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("lingwu zihua")
   end
   w:go(2756)
end

function lingwu:douzhuan_xingyi2()  --领悟斗转
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("lingwu miji")
   end
   w:go(2846)
end

function lingwu:douzhuan_xingyi3()  --领悟斗转
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("look sky")
   end
   w:go(2966)
end

function lingwu:taojiao_xingyi()
    local w=walk.new()
    w.walkover=function()
      world.Send("taojiao douzhuan-xingyi")
	   if self:Next()==true then
			   local f=function()
				 self:start()
			   end
			   f_wait(f,0.8)
		else
			   self.lian_end=true
			   self:finish()
	   end
   end
   w:go(1989)

end

function lingwu:lingwu_jiujian(cmd)
  wait.make(function()
    world.Send(cmd)
	 world.Send(cmd)
	  world.Send(cmd)
	   world.Send(cmd)
	    world.Send(cmd)
    local l,w=wait.regexp("^(> |)由于实战经验不足，阻碍了你的「独孤九剑」进步！$|^(> |)你现在的潜能不足以领悟独孤九剑。$|^(> |)你的内力不够。$",0.8)
     if l==nil then
	   self:lingwu_jiujian(cmd)
	   return
	 end
	 if string.find(l,"你现在的潜能不足以领悟独孤九剑") or string.find(l,"由于实战经验不足")  then
	    self:finish()
	    return
	 end
	 if string.find(l,"你的内力不够") then
		  local f=function()
		     self:lingwu_jiujian(cmd)
		   end
          self:neili_lack(f)
	   return
	 end
	 wait.time(2)
  end)
end

function lingwu:dugu_jiujian()  --领悟独孤九剑
  local w=walk.new()
   w.walkover=function()
      self:lingwu_jiujian("lingwu dugu-jiujian")
   end
   w:go(4985)
end

function lingwu:getdzxytime()
  wait.make(function()
      world.Send("time")
	  local l,w=wait.regexp("^(> |)现在是书剑(.*)年(.*)月(.*)日(.*)时(.*)。$",15)
	  if l==nil then
	    print("超时:")--酉
	    return
	  end
	  if string.find(l,"现在是书剑") then
	    --print(w[2],w[3],w[4],w[5],w[6])
	    local hour=w[5]
	    --print(hour)
	    local mins=w[6]
	     --print(mins)
	    if hour=="戌" or hour=="亥" or hour=="子" then
	      print("可以去看星星")
		  self:douzhuan_xingyi3()
	    else
	      print("白天无法看星星")
		  print("练习下个")
		  if self:Next()==true then
			local f=function()
				self:start()
			end
			f_wait(f,0.2)
		  else
			self:finish()
		  end
	    end
        return
	  end
	  wait.time(1)
   end)
end

function lingwu:getdugutime()
  wait.make(function()
      world.Send("time")
	  local l,w=wait.regexp("^(> |)现在是书剑(.*)年(.*)月(.*)日(.*)时(.*)。$",15)
	  if l==nil then
	    print("超时:")--酉
	    return
	  end
	  if string.find(l,"现在是书剑") then
	    --print(w[2],w[3],w[4],w[5],w[6])
	    local hour=w[5]
	    --print(hour)
	    local mins=w[6]
	     --print(mins)
	    if hour=="戌" or hour=="亥" or hour=="子" or hour=="卯" or hour=="丑" or hour=="寅" or hour=="酉" then
	        print("晚上无法进山洞")
		  print("练习下个")
		  if self:Next()==true then
			local f=function()
				self:start()
			end
			f_wait(f,0.2)
		  else
			self:finish()
		  end
	    else
	        self:dugu_jiujian()
	    end
        return
	  end
	  wait.time(1)
   end)
end

function lingwu:qiankundanuoyi()
  --新代码
  --local master_place=2745
  local w=walk.new()
  w.walkover=function()
      world.Send("taojiao qiankun-danuoyi")
	   if self:Next()==true then
			   local f=function()
				 self:start()
			   end
			   f_wait(f,0.8)
		else
			   self.lian_end=true
			   self:finish()
	   end
  end
   w:go(2745)
 --[[ local sleeproomno=2248
  local masterid="zhang"
  local master_place=2745
     print("开始讨教乾坤大挪移")
	 local taojiao={}
	  taojiao=learn.new()
	  taojiao.timeout=1.2
	  sj.World_Init=function()
          taojiao:go()
      end
	   taojiao.master_place=tonumber(trim(master_place)) --师傅房间号
       taojiao.masterid= masterid  --师傅id
	   taojiao.start=function()
		  local cmd="taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi"
		  taojiao:Execute(cmd)

	   end
       taojiao.start_success=function()
	      taojiao:regenerate()
	      --taojiao:start()
	   end
	   taojiao.wuxing=function()
	      local wx=world.GetVariable("wuxing")
		  world.Execute(wx)
	   end
	   taojiao.start_failure=function(error_id)
			--print(error_id," learn_error_id")
		   if error_id==2 then  --没有找到师傅
			  local f=function() taojiao:go() end
			  f_wait(f,5)
		   end
		   if error_id==102 or error_id==1 or error_id==201 or error_id==301 then  --潜能用完 经验限制 或 超越师傅 或武器不对
	           print("练习下个")
		     if self:Next()==true then
			   local f=function()
				 self:start()
			   end
			   f_wait(f,0.2)
		     else
			   self.lian_end=true
			   self:finish()
		     end
	         return
		   end
			if error_id==202 then
			  print("武器不对:",taojiao.weapon)

			end

			if error_id==401 then
			   taojiao:regenerate()
			end
			if error_id==402 then  --内力不足
			  shutdown()
			  local exps=world.GetVariable("exps")
			  if tonumber(exps)>800000 then
			     taojiao:xiulian()
			  else
                 taojiao:rest()
			  end
			end
			if error_id==403 then  --内力转换精血 继续学习
			  taojiao:start()
			end
	  end
	 taojiao.rest=function()
	      local w
		  w=walk.new()
		  w.walkover=function()
			 local mr_rest=rest.new()
			 mr_rest.failure=function(id)
			    local f=function()
				  --w:go(2186)
				  -- w:go(2785)
				  w:go(sleeproomno)
				end
				f_wait(f,10)
 			 end
			 mr_rest.wake=function(flag)
				taojiao:go()
			 end
			 mr_rest:sleep()
		  end
		 -- w:go(2186)
		-- w:go(2785)
		  w:go(sleeproomno)
	  end
	  taojiao:go()  --ss go learn]]
end

--********************
function lingwu:start() --开始学习

	local cmd
	local base_skill
	local special_skill
	local i
	i=self.skillsIndex
	base_skill=self.skills[i].base_skill
	special_skill=self.skills[i].special_skill
	--print("start:",base_skill," -> ",special_skill)
	if self:ok_lingwu(base_skill,special_skill)==true then
	  	self:wuxing()
		if base_skill=="strike" or base_skill=="hand" or base_skill=="claw" or base_skill=="cuff" or base_skill=="finger" or base_skill=="leg" then
		   world.Send("bei none")
		end
		world.Send("jifa "..base_skill.." "..special_skill)
 	    cmd="lingwu "..base_skill
		if base_skill=="strike" or base_skill=="hand" or base_skill=="claw" or base_skill=="cuff" or base_skill=="finger" or base_skill=="leg" then
		   world.Send("bei "..base_skill)
		end
	    --print(cmd)
	    self:lag()
	    self:lingwu_Execute(cmd,self.times)
	elseif self:ok_lian(base_skill,special_skill)==true then
	    local level=9999
	    for _,ski in ipairs(self.me_skills) do
		   if ski.skill_id==special_skill then
		     level=tonumber(ski.level)
			 break
		   end
		end


	    if self.run_vip==true and level>400 then  --练时候关闭vip
		  self:vip_close()
		  return
		end
	    self:wuxing()

		if base_skill=="hand" or base_skill=="cuff" or base_skill=="strike" or base_skill=="claw" or base_skill=="finger" or base_skill=="leg" then
			  world.Send("bei none")
			  world.Send("jifa "..base_skill.." "..special_skill)
			  world.Send("bei "..base_skill)
		    if special_skill=="wuxiang-zhi" then

			    print("无相劫指")
				local special=self:get_skill("wuxiang-zhi")
				if special<=200 then
				    self:wxjz() --不能自己练
				else
				    self:wxjz2()
				end
				return
			end
		elseif base_skill=="parry" then
			if special_skill=="douzhuan-xingyi" then
			      print("练斗转星移")
				  local special=self:get_skill("douzhuan-xingyi")
				  if special>=201 then
				   self:getdzxytime()
				  elseif special>=171 and special<201 then
				   self:douzhuan_xingyi2()
				  elseif special>=51 and special<171 then
				   self:douzhuan_xingyi()
				  --[[else
				    self:taojiao_xingyi()]]
				  end
				  return
			elseif special_skill=="qiankun-danuoyi" then
				  print("讨教乾坤大挪移")
				  self:qiankundanuoyi()
				  return
			elseif self:Next()== true then
			     self:start()
			else
			     self:finish()
			end
		elseif base_skill=="sword" and special_skill=="dugu-jiujian" then
		    local special=self:get_skill("dugu-jiujian")
			if special>=300 then
			    world.Send("jifa "..base_skill.." "..special_skill)
				cmd="lian "..base_skill
		        self:lian_Execute(cmd)
			else
			    self:getdugutime()
			end
			return
		else
		    world.Send("jifa "..base_skill.." "..special_skill)
		end

	        cmd="lian "..base_skill
            --print(cmd)
		    self:lian_Execute(cmd)
	elseif self:Next()== true then
		 self:start()
	else
		 self:finish()
	end
end
--lingwu.go cuff taiji-quan
--lingwu_ok: false
--lian_ok: false
--目标房间: 2540  GO!!!!
function lingwu:go() --go 领悟

    local base_skill
	local special_skill
	local i
	i=self.skillsIndex
	base_skill=self.skills[i].base_skill
	special_skill=self.skills[i].special_skill
	--print(i," skillIndex")
	--print("lingwu.go",base_skill,special_skill)
	--print("lingwu_ok:",self:ok_lingwu(base_skill,special_skill))
	--print("lian_ok:",self:ok_lian(base_skill,special_skill))
	if self.vip==true and self.run_vip==false and (self:ok_lingwu(base_skill,special_skill)==true or i==1) then --是vip vip 没有起到 (可以领悟 or 第一个)
	   self:vip_start()
	elseif self:ok_lian(base_skill,special_skill)==true then
		self:start()
	else
	  local place
	  place=self.lingwu_place
	  local w
	  w=walk.new()
	  w.walkover=function()
	   print("领悟开始")
	   --self.start()
	   --BigData:catchData(2540,"达摩院后院")
       self:start()
	  end
	  w:go(place)
	end
end

function lingwu:vip_start()
   local w
   w=walk.new()
   w.walkover=function()
       wait.make(function()
          world.Send("ask ying gu about 鬼谷算术")
		  local l,w=wait.regexp("^(> |)瑛姑说道：「你本周还可以使用鬼谷算术(.*)，现在开始计时了。」$|(> |)对不起啊，目前鬼谷算术只对贵宾VIP用户开放强化学习功能。$|(> |)你不是正在研习修炼鬼谷算术中么？还不快点抓紧时间……$|^(> |)瑛姑说道：「你虽然天资聪慧，但是贪多嚼不烂，不能再冒进了，请下周再来询问吧。」$",10)
		  if l==nil then
            local f=function() self:vip_start() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"现在开始计时了") or string.find(l,"你不是正在研习修炼鬼谷算术中么") then
		     self.run_vip=true
			 local b
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:go()
			 end
			 b:check()
			 return
		  end
		  if string.find(l,"鬼谷算术只对贵宾VIP用户开放") or string.find(l,"你虽然天资聪慧，但是贪多嚼不烂，不能再冒进了，请下周再来询问吧") then
		     self.vip=false
		     self.run_vip=false
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:go()
			 end
			 b:check()
		     return
		  end
		  wait.time(10)
	   end)
   end
   w:go(435)
end

function lingwu:vip_end()
  local w
   w=walk.new()
   w.walkover=function()
	  world.Send("ask ying gu about 结束")

	   local l,w=wait.regexp("^(> |)你向瑛姑打听有关『结束』的消息。$",3)
		  if l==nil then
            self:vip_end()
	        return
          end
		  if string.find(l,"你向瑛姑打听有关『结束』的消息") then
		     self.run_vip=false
			 local b
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:AfterFinish(self.isfull)
			 end
			 b:check()
			 return
		  end
   end
   w:go(435)
end

function lingwu:vip_close()
  local w
   w=walk.new()
   w.walkover=function()
	  world.Send("ask ying gu about 结束")

	   local l,w=wait.regexp("^(> |)你向瑛姑打听有关『结束』的消息。$",3)
		  if l==nil then
            self:vip_close()
	        return
          end
		  if string.find(l,"你向瑛姑打听有关『结束』的消息") then
		     self.run_vip=false
			 local b
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:start()
			 end
			 b:check()
			 return
		  end
   end
   w:go(435)
end

function lingwu:get_skills_end()
   ---开始领悟

   	 local st=status_win.new()
     st:init(nil,self,nil)
	 st:skill_draw_win()
	 --需要判断是否全部技能满
    for _,skill in ipairs(self.skills) do
       local base_skill=skill.base_skill
	   local special_skill=skill.special_skill
	    if self:ok_lingwu(base_skill,special_skill)==true or self:ok_lian(base_skill,special_skill)==true then
		  print("能够领悟")
		  self:go()  --能够领悟
		  return
		end
	end
	--所有都满了
	self:finish()

end

function lingwu:skills_level()
  wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)\\((.*)\\).*\\s+(\\d*)\\/\\s*(\\d*)$|^(> |)设定环境变量：cha \\= \\\"YES\\\"$",5)
	 if l==nil then
	    self:get_skills()
	    return
	 end
     if string.find(l,")") then
	     --print(w[2],w[3],w[4])
		 self:set_skill(w[2],w[3],w[4],w[5])
		 self:skills_level()
		 return
	  end
	 if string.find(l,"设定环境变量：cha") then
	    self:get_skills_end()
		return
	 end
  end)
end

function lingwu:get_skills()
  --[[ 你目前学过二十八种技能：

  碧海潮生功   (bihai-chaosheng)           - 神功盖世 427/127038
  采矿技能     (caikuang)                  - 半生不熟  62/   900
  基本轻功     (dodge)                     - 举世无双 434/  3504
  锻造技能     (duanzao)                   - 融会贯通 130/  5632
  基本指法     (finger)                    - 精深奥妙 408/108825
  基本内功     (force)                     - 惊世骇俗 446/109230
  基本手法     (hand)                      - 精深奥妙 408/ 95858
  金蛇剑法     (jinshe-jianfa)             - 略有小成 157/ 12322
  金蛇游身掌   (jinshe-zhangfa)            - 平平淡淡 101/  6860
□兰花拂穴手   (lanhua-shou)               - 精深奥妙 410/ 84460
  基本腿法     (leg)                       - 非同凡响 348/ 60901
  读书写字     (literate)                  - 震古铄今 249/ 31250
□落英神剑掌   (luoying-zhang)             - 非同凡响 350/ 61600
  本草术理     (medicine)                  - 已有小成 119/   247
  基本招架     (parry)                     - 非同凡响 350/ 12902
  奇门八卦     (qimen-bagua)               - 已有大成 197/     0
  奇门八卦阵   (qimen-baguazhen)           - 不堪一击   2/     5
□神照经       (shenzhao-jing)             - 惊世骇俗 446/ 99904
  基本掌法     (strike)                    - 非同凡响 347/ 60552
□随波逐流     (suibo-zhuliu)              - 举世无双 434/ 94612
  基本剑法     (sword)                     - 所向披靡 388/ 32057
  躺尸剑法     (tangshi-jianfa)            - 勉勉强强  53/  1662
□弹指神通     (tanzhi-shentong)           - 精深奥妙 410/ 84473
  道学心法     (taoism)                    - 已有大成 197/ 19602
  基本暗器     (throwing)                  - 精深奥妙 407/ 31216
  讨价还价     (trade)                     - 略知一二  43/  1801
□旋风扫叶腿   (xuanfeng-tui)              - 非同凡响 350/ 61600
□玉箫剑法     (yuxiao-jian)               - 所向披靡 390/ 76448]]

  -- ^(> |).*"..item.skill_id..".*\\s+(\\d*)\\/\\s*(\\d*)
   --[[for _,i in ipairs(self.skills) do
   --删除重复内容
       self:set_special_skill(i.special_skill)
	   self.set_base_skill(i.base_skill)
   end]]
   self.me_skills={}
   world.Send("cha")
   world.Send("set cha")
   world.Send("unset cha")
   wait.make(function()
      local l,w=wait.regexp("你目前学过.*种技能：$|^(> |)你目前学过.*种技能.*$",5)
	  if l==nil then
	     self:get_skills()
	     return
	  end
	  if string.find(l,"你目前学过") then
	     self:skills_level()
	     return
	  end
   end)
end

function lingwu:finish()
    --print("vip状态:",self.vip)
	--print("vip run:",self.run_vip)
		  world.DeleteTimer("lw")
          self.status=false
		  local h=hp.new()
          h.checkover=function()
		       if h.pot>=20 then
		         local w=walk.new()
				 w.walkover=function()
				  world.Send("qn_cun "..h.pot)
				  if self.run_vip==true then
					  self:vip_end()
                  else
                      self:AfterFinish(self.isfull)
				  end
			     end
			     w:go(4067)
               else
				  if self.run_vip==true then
					  self:vip_end()
                  else
                      self:AfterFinish(self.isfull)
				  end
			  end
          end
          h:check()
end

function lingwu:AfterFinish() --回调函数

end

function lingwu:wxjz_buddhism()
    l_learn=learn.new()
    l_learn:addskill("buddhism")
	l_learn.masterid="wuming"
	l_learn.pot=50
	l_learn.master_place=2991

	l_learn.start_success=function()
	      world.Send("yun regenerate")
	      l_learn:start()
	end

	l_learn.start_failure=function(error_id)
	       if error_id==2 then  --没有找到师傅
			  l_learn:go()
		   end
		   if error_id==102 then  --潜能用完
		       self:finish()
		   end
		   if error_id==1 or error_id==201 then  --经验限制 或 超越师傅
			  local is_ok=l_learn:Next()
				if is_ok==true then  --还有候选项
				  l_learn:start()
				else
				  self:wxjz_cave()
				end
			end
			if error_id==401 then
			   l_learn:regenerate()
			end
			if error_id==402 then  --内力不足
			  l_learn:rest()
			end
			if error_id==403 then  --内力转换精血 继续学习
			  l_learn:start()
			end
	  end

	   l_learn.rest=function()
	     local w
		  w=walk.new()
		  w.walkover=function()
			 local ss_rest=rest.new()
			 ss_rest.wake=function(flag)
			     if flag==0 then
			          print("睡觉太频繁了!")
			          local ch=hp.new()
			          ch.checkover=function()
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  睡觉太频繁 打坐 start
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
								if id==202 then --safe room 没有办法打坐
								   local b1
								   b1=busy.new()
								   b1.Next=function()
								     w1:go(876)
								   end
								   b1:check()
	                            else
		                           local f1
		                           f1=function()
								     world.Send("yun regenerate")
								     x:dazuo()
								   end
	                               f_wait(f1,10)
								end
                              end
							  x.success=function(h)
							     l_learn:go()
							  end
	                          x:dazuo()
							  ---  睡觉太频繁 打坐 end
			                end
                            w1:go(876)
			          end
					ch:check()
				  else
					l_learn:go()
				  end
			 end
			 ss_rest:sleep()
		  end
		  w:go(878)
	  end
	  l_learn:go()
end

function lingwu:wxjz_bomuxie()

   wait.make(function()
      world.Execute("#10 bo 木屑")
      --world.Send("bo 木屑")
      --world.Send("bo 木屑")
      --world.Send("bo 木屑")
      --world.Send("bo 木屑")
	  world.Send("yun refresh")
      --你双手笼袖，运气鼓劲，地上的碎木屑突然飞舞跳跃起来，便似有人以一根无形的细棒挑动搅拨一般。
	  local l,w=wait.regexp("^(> |)你感觉已经无法继续利用碎木屑提高自己无相劫指的修为了。$|^(> |)你练了一阵，不禁觉得心情有些烦乱。$|^(> |)你的内力不够。$|^(> |)你忽然觉得有些神思不属，不禁站了起来。$|^(> |)你心烦意乱，不禁从心底升起一阵杀气。$",1)
	  if l==nil then
		  self:wxjz_bomuxie()
		  return
	  end
	  if string.find(l,"不禁觉得心情有些烦乱") or string.find(l,"你忽然觉得有些神思不属") or string.find(l,"你心烦意乱") then
	     self:wxjz_buddhism()
		 return
	  end
	  if string.find(l,"你感觉已经无法继续利用") then
	     self:finish()
	     return
	  end
	  if string.find(l,"你的内力不够") then
	     self.go=function()  --替换默认 go 函数
		     --检查吃喝
			 local f=function()
			     self:wxjz_cave()
			 end
			 xiulian_Status_Check(f) --
		 end
	     self:xiulian()
	     return
	  end
   end)

end

function lingwu:wxjz_cave()
      local w=walk.new()
		  local al=alias.new()
		  al.duanyaping_yading=function()
		      world.Send("da gou")
              world.Send("shuai suo")
	          world.Send("pa up")
	          world.Send("enter")
	         al:finish()
	      end
	      w.user_alias=al
		  w.walkover=function()
			self:wxjz_bomuxie()
		  end
		  w:go(4055)
end

function lingwu:wxjz()
    local sp=special_item.new()
       sp.cooldown=function()
		 print("检查负重")
		  if sp.weight>50 then
			print("负重过重！")
			print("练习下个")
	    	if self:Next()==true then
		   	   local f=function()
				 self:start()
			   end
			   f_wait(f,0.2)
		    else
			  self:finish()
		    end
			return
		  end
	      local f=function()
		     self:wxjz_buddhism()
		  end
	      Get_items(f)  --将身上物品出售 保存 丢弃 保证负重在50%以下
       end
       local equip={}
	   equip=Split("<获取>挠钩","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)

end

function lingwu:wxjz2()
    local sp=special_item.new()
       sp.cooldown=function()
	      print("检查负重")
		  if sp.weight>50 then
			print("负重过重！")
			print("练习下个")
	    	if self:Next()==true then
		   	   local f=function()
				 self:start()
			   end
			   f_wait(f,0.2)
		    else
			  self:finish()
		    end
			return
		  end
	      local f=function()
		     self:wxjz_buddhism2()
		  end
	      Get_items(f)  --将身上物品出售 保存 丢弃 保证负重在50%以下
       end
       local equip={}
	   equip=Split("<获取>挠钩","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)

end

function lingwu:wxjz_buddhism2()
  local f=function()
     local w=walk.new()
		  local al=alias.new()
		  al.duanyaping_yading=function()
		      world.Send("da gou")
              world.Send("shuai suo")
	          world.Send("pa up")
	          world.Send("enter")
	         al:finish()
	      end
	      w.user_alias=al
		  w.walkover=function()
			 world.Send("ask wuxiang about 佛法")
			 local l,w=wait.regexp("^(> |)无相禅师说道：「大师佛法精深，心怀慈悲，我目前实在没有什么可以教你的。」$|^(> |)无相禅师说道：「你的潜能不够了。」$|^(> |)你端坐良久，若有所悟。$",5)
			 if l==nil then
			     self:wxjz_buddhism2()
			     return
			 end
			 if string.find(l,"我目前实在没有什么可以教你的") then
			    local f=function()
				   self:wxjz_buddhism2()
				end
			    cmd="lian finger"
		        self:lian_Execute(cmd,f)
			    return
			 end
			 if string.find(l,"你的潜能不够了") then
			    self:finish()
			    return
			 end
			 if string.find(l,"你端坐良久，若有所悟") then
			    self:wxjz_buddhism2()
				 --检查吃喝

			    return
			 end
		  end
		  w:go(4055)
	end
	xiulian_Status_Check(f) --检查饮水食物
end
