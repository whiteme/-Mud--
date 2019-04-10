lian={
  new=function()
     local ln={}
	  setmetatable(ln,lian)
	  ln.skills={}
	 return ln
  end,
  count=50,
  vip=false,
  run_vip=false,
  interval=0.3,
  skills={},
  skillsIndex=1,
  weapon="",
  levelup=false,
  lian_end=false,
  settime=nil,
  setpot=nil,
}
lian.__index=lian

function lian:move(cmd)
  local w
  w=walk.new()
  w.walkover=function()
	self:Execute(cmd)
  end
 local _R
 _R=Room.new()
 _R.CatchEnd=function()
	local count,roomno=Locate(_R)
	--print(roomno[1])
	local r=nearest_room(roomno)
	w:go(r)
  end
  _R:CatchStart()
end
--学弹指神通必须空手或手持暗器。
--你的精力太差了，不能练随波逐流身法。
function lian:neili_lack(callback)
  --
  print("修炼内力")
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
		       --print(roomno[1])
		       local r=nearest_room(roomno)
			   w:go(r)
	         end
			_R:CatchStart()
	    end
	end
	x.success=function(h)
		print(h.qi,h.max_qi*0.9)
		print(h.neili,h.max_neili*2-200)
		if h.neili>h.max_neili*2-200 then
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

function lian:xiulian()
  --
  print("修炼内力")
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
		      -- print(roomno[1])
		       local r=nearest_room(roomno)
			   w:go(r)
	         end
			_R:CatchStart()
	    end
	end
	x.success=function(h)
		print(h.qi,h.max_qi*0.9)
		print(h.neili,h.max_neili*2-200)
		if h.neili>h.max_neili*2-200 then
		   self:wield_weapon()
		else
		  print("继续修炼")
		  world.Send("yun recover")
		  x:dazuo()
		end
	end
	x:dazuo()
end

function lian:wield_weapon()
   local sp=special_item.new()
   sp.cooldown=function()
	local i=self.skillsIndex
	local skillname=self.skills[i].skill_id
	print(skillname," 根据技能名称判断使用的武器!!")
	if string.find(skillname,"sword") then
		world.Send("wield jian")
		world.Send("wield xiao")
		world.Send("wield sword")
		self.weapon="sword"
	elseif string.find(skillname,"blade") then
	    world.Send("wield dao")
		world.Send("wield blade")
		self.weapon="blade"
	elseif string.find(skillname,"staff") then
	    world.Send("wield zhang")
		world.Send("wield staff")
		self.weapon="staff"
	elseif string.find(skillname,"whip") or string.find(skillname,"bian") then
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
	end
	wait.make(function() --你将一柄不老太风刀抽出握在了手中。
	local l,w=wait.regexp("^(> |)你.*握在.*手中。$|^(> |)你感觉全身气息翻腾，原来你真气不够，不能装备.*。$|^(> |)你已经装备著了。$",5)
	 if l==nil then
	    self:wield_weapon()
	    return
	 end
	 if string.find(l,"你感觉全身气息翻腾") then
	    self:xiulian()
	    return
	 end
	 if string.find(l,"手中") or string.find(l,"你已经装备著了") then
         self:start()
		 return
	 end
	 wait.time(5)
	end)
  end
  sp:unwield_all()
end
--你的基本功火候未到，必须先打好基础才能继续提高。
--你必须先找一条鞭子才能练鞭法。
function lian:Execute(cmd)
  wait.make(function()
	 world.Execute(cmd) --你的体力太差了，不能练燕灵身法。 你的精力太低了，无法练习震山绵掌 你现在的精力太差了，不能练习华山身法。
	 local l,w=wait.regexp("^(> |)你的精力太差了，不能练.*。|^(> |)你的内力不够练.*。|^(> |)你的体力不够.*。$|^(> |)你的体力太低了。$|^(> |)你的体力太差了，不能练.*。$|^(> |)你的精力太低了。$|^(> |)你现在的修为不足以提高.*$|^(> |)你使用的武器不对。$|^(> |)由于实战经验不足，阻碍了你的.*进步！$|^(> |)(练|学习|学).*须空手.*$|^(> |)学.*时手里不能拿武器。$|^(> |)空手方能练.*$|^(> |)你的「.*」进步了！$|^(> |)空手时无法练.*。$|^(> |)你该休息一下了，等会再练.*。$|^(> |)你无法静下心来修炼。$|^(> |)卧室不能练功，会影响别人休息。$|^(> |)你先歇口气再练吧。$|^(> |)空了手.*。$|^(> |)你手上的武器不能用来练.*。$|^(> |)你的精力不够练.*$|^(> |)你手里有兵器，.*$|^(> |)你的内力不够.*$|^(> |)你的现在的内力不足,无法继续练.*$|^(> |)你的精力太低了，无法练习.*$|^(> |).*必须空手。$|^(> |)你现在的精力太差了，不能练习.*。$|^(> |)你的体力目前没有办法练习.*。$|^(> |)你没有使用的武器.*$|^(> |)你先聚集点内力再练.*$|^(> |)你的基本功火候未到，必须先打好基础才能继续提高。$|^(> |)练.*须空手。$|^(> |)修习弹指神通必须有碧海潮生功配合。$|^(> |)你必须使用金蛇剑才能进一步练习你的金蛇剑法。$|^(> |)你必须先找一条鞭子才能练鞭法。$|^(> |)你的内力不够。$|^(> |)你太累了。$|^(> |)你练习着.*却感到武器太不对劲。$|^(> |)你太累了，歇口气再练吧。$",1.5)
     if l==nil then
		 self:Execute(cmd)
		return
     end
	 --你现在的修为不足以提高碧海潮生功了。
	if string.find(l,"由于实战经验不足") or string.find(l,"你的基本功火候未到，必须先打好基础才能继续提高") or string.find(l,"你的内力不够") then
	  	local f=function() self.start_failure(1) end
        print "由于实战经验不足1"
		f_wait(f,self.interval)
		return
	 end
	 if string.find(l,"你现在的修为不足以提高") then  --你现在的修为不足以提高九阳神功。
	 --内力不够 or pot不够
	    local h=hp.new()
		h.checkover=function()
		  if h.pot<10 then
			 local f=function() self.start_failure(502) end
             print "由于pot不足502"
		     f_wait(f,self.interval)
			 return
		  end
	       local f=function() self.start_failure(501) end
           print "由于内力不足501"
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
		self.levelup=true
		self:Execute(cmd)
	    return
	 end
    if  string.find(l,"却感到武器太不对劲") or string.find(l,"你必须用剑") or string.find(l,"你必须使用金蛇剑") or string.find(l,"你使用的武器不对") or string.find(l,"空手时无法练") or string.find(l,"你手上的武器") or string.find(l,"你没有使用的武器") or string.find(l,"你必须先找") then
		self:wield_weapon()
		return
     end--精力太差
     if string.find(l,"你太累了") or string.find(l,"精力太差了") or string.find(l,"你太累了") or string.find(l,"你的精力太低了") or string.find(l,"你的体力太差了") or string.find(l,"你的体力不够") or string.find(l,"你的体力太低了") or string.find(l,"你该休息一下了") or string.find(l,"歇口气") or string.find(l,"你的精力不够") or string.find(l,"你的体力目前没有办法练习") then
	   self.start_failure(401)
	   return
	 end
	 if string.find(l,"你的内力不够练") or string.find(l,"你的内力不够") or string.find(l,"你的现在的内力不足") or string.find(l,"你先聚集点内力再练") then
	   self.start_failure(201)
	   return
	 end
	 if string.find(l,"你无法静下心来修炼") or string.find(l,"卧室不能练功，会影响别人休息") then
	   print("无法练习房间")
	   --self.start_failure(666)
	   self:move(cmd)
	   return
	 end
	 if string.find(l,"修习弹指神通必须有碧海潮生功配合") then

	    world.Send("jifa force bihao-chaosheng")
	    return
	 end

     if string.find(l,"空手") or string.find(l,"不能拿武器") or string.find(l,"空了手") or string.find(l,"你手里有兵器")  then
	    local sp=special_item.new()
		sp.cooldown=function()
		  self:Execute(cmd)
		end
		sp:unwield_all()
	    return
	 end
     --等待
    wait.time(1.5)
	print("继续")
end)
end

function lian:start_failure(error_id) --回调函数

end

function lian:rest() --回调函数

end


function lian:refresh()
   -- regenerate_trigger()
    wait.make(function()
    world.Send("yun refresh")
	local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你长长地舒了一口气。$|^(> |)你现在精力充沛。$",5)
   if l==nil then
      --self.start_failure(-1)
	  self:refresh()
	  return
   end
   if string.find(l,"内力不够") then
     print("lian",402)
     self.start_failure(402)
	 return
   end
   if string.find(l,"你长长地舒了一口气") or string.find(l,"你现在精力充沛") then
     print("lian",403)
     self.start_failure(403)
	 return
   end
   wait.time(5)
   end)
end

function lian:go()
    if self.settime~=nil then
       print(self.settime," 秒恢复工作!")
	   local f=function()
	      shutdown()
		  local b=busy.new()
		  b.Next=function()
		    self:finish()
		  end
		  b:check()
	   end
	   f_wait(f,self.settime)

	end
	if self.vip==true and self.run_vip==false then
	   self:vip_start()
	else
       self:start()
	end
end

--[[

  基本轻功     (dodge)                     - 心领神会 221/    10
  锻造技能     (duanzao)                   - 融会贯通 122/   556
  基本内功     (force)                     - 心领神会 223/ 27097
□寒冰神掌     (hanbing-shenzhang)         - 心领神会 220/  9765
□寒冰真气     (hanbing-zhenqi)            - 心领神会 223/ 33541
  基本手法     (hand)                      - 心领神会 221/    73
  读书写字     (literate)                  - 心领神会 147/ 19416
  本草术理     (medicine)                  - 半生不熟  69/  4014
  基本招架     (parry)                     - 心领神会 221/    51
□嵩山剑法     (songshan-jian)             - 心领神会 220/  1531
  嵩阳鞭       (songyang-bian)             - 不堪一击   1/     0
□大嵩阳手     (songyang-shou)             - 心领神会 221/ 10791
  基本掌法     (strike)                    - 心领神会 220/   975
  基本剑法     (sword)                     - 心领神会 221/     0
  讨价还价     (trade)                     - 初窥门径  23/   474
□中岳神风     (zhongyuefeng)              - 心领神会 221/ 49284

]]
function lian:skills_level()
   --print("触发器行数",table.getn(self.skills))
   local i=0
   for i,item in ipairs(self.skills) do
	 --world.AddTriggerEx ("skill"..i, "^(> |).*"..item[i].skill_name..".*\\s+(\\d*)\\/\\s+(\\d*)", "print(\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 2000);
     --world.SetTriggerOption ("skill"..i, "group", "skills")
     --world.EnableTrigger("skill"..i,true)

	 world.AddTriggerEx ("skill_base"..i, "^(> |).*"..item.skill_id..".*\\s+(\\d*)\\/\\s*(\\d*)", "print(\"%2\")\nSetVariable('"..item.skill_id.."',trim(\"%2\"))",trigger_flag.OneShot + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 2000);
     world.SetTriggerOption ("skill_base"..i, "group", "skills")
     world.EnableTrigger("skill_base"..i,true)
   end
   world.Send("cha")
end

function lian:start(base,level,skill,practice,special) --开始练习

	local i
	i=self.skillsIndex
	--当前等级  熟练度
	wait.make(function()
	   -- world.Send("cha") --确定练习技能
	   if base==nil and level==nil and skill==nil then
	    world.Send("cha")
		world.Send("set action 技能")
	   end
		local s=self.skills[i].skill_name
		local b=self.skills[i].skill_id
		--print(s)
        s=string.gsub(s,"%-","%%-")
		b=string.gsub(b,"%-","%%-")
		--print("^(> |).*\\\("..self.skills[i].skill_name.."\\\).*\\s+(\\d*)\\/(\\s*)(\\d*)")
		--print("^(> |).*\\\("..self.skills[i].skill_id.."\\\).*\\s+(\\d*)\\/(\\s*)(\\d*)")
	   local l,w=wait.regexp("^(> |).*\\\("..self.skills[i].skill_name.."\\\).*\\s+(\\d*)\\/(\\s*)(\\d*)|^(> |).*\\\("..self.skills[i].skill_id.."\\\).*\\s+(\\d*)\\/(\\s*)(\\d*)|^(> |)^(> |)设定环境变量：action \\= \\\"技能\\\"",5)
	   if l==nil then
	       self:start()
	      return
	   end
	   if string.find(l,b) then

	       local base=tonumber(w[6])
		   --print("4:",w[4],"5:",w[5],"8:",w[6],"7:",w[7])
		  self:start(base,level,skill,practice,special)
		  return
	   end
	   if string.find(l,s) then
	       --local exps=world.GetVariable("exps")
	        local special=tonumber(w[2])
	      local skill=(tonumber(w[2])+1)
		  skill=skill*skill
		  --print(exp," | ",w[3])
		  local level=tonumber(w[2])
		  --print(level)
		  level=level*level*level*0.1

		   local practice=tonumber(w[4])
		   self:start(base,level,skill,practice,special)
	       return
	   end

	   --print(self.skills[i].skill_name,"why",l)
	   --print(string.find(l,"("..self.skills[i].skill_name..")"))
	   if string.find(l,"设定环境变量：action") then
	      --print("ok?")
	       local exps=world.GetVariable("exps")
	       --print("测试")
	      --[[local special=tonumber(w[2])
	      local skill=(tonumber(w[2])+1)
		  skill=skill*skill
		  --print(exp," | ",w[3])
		  local level=tonumber(w[2])
		  print(level)
		  level=level*level*level*0.1]]


		  print("if ",level," < ",exps," and ",special,"<",base," or ",skill,">",practice)
		   if self.skills[i].skill_name=="wuxing-zhen" and special<200 then
		     print("五行阵ask")
			 self:wxz()
		     return
		  end
		  --熟练度没有到达上限  等级小于经验上限 并且 特殊技能小于基本功
           if skill==nil then
		      print("熟练度没有到达上限  等级小于经验上限 并且 特殊技能小于基本功")
		      return
		   end
	      if skill>practice or (level<tonumber(exps) and (special<base or base=="force"))  then
		    print("练习技能")
		    local cmd
	        local skill_id
			local skill_name
	      --print(i)
	        skill_id=self.skills[i].skill_id
			skill_name=self.skills[i].skill_name
			if skill_id=="hand" or skill_id=="cuff" or skill_id=="strike" or skill_id=="claw" or skill_id=="finger" or skill_id=="leg" then
			  world.Send("bei none")
			  world.Send("bei "..skill_id)
			elseif skill_id=="parry" then
			   local party=world.GetVariable("party") or ""
			   if party=="姑苏慕容" then
			      print("练斗转星移")
				  if special>=201 then
				   self:douzhuan_xingyi3()
				  elseif special>=171 then
				   self:douzhuan_xingyi2()
				  else
				   self:douzhuan_xingyi()
				  end
				  return
			   elseif party=="明教" then
				  print("讨教乾坤大挪移")
				  self:qiankundanuoyi()
				  return
			   end
			end
			world.Send("jifa "..skill_id.." "..skill_name)
	        cmd="lian "..skill_id--.." "..self.count
	        self:Execute(cmd)
		  else
		    print("练习下个")
		    if self:Next()==true then
			   local f=function()
			     self:start()
			   end
			   f_wait(f,0.2)
			else
			   --world.SetVariable("lian_end","true")  --lian 到最后一个技能
			   --local lingwu_end=world.GetVariable("lingwu_end") or "false"
			   --if lingwu_end=="true" then
			   --   print("等待等级升级！")
			   --   world.SetVariable("levelup","false")
			   --end
			   self.lian_end=true
			   self:finish()
			end
		  end
	      return
	   end
	   --print("wrong?")
		wait.time(5)
	end)

end

function lian:qiankundanuoyi()
  local sleeproomno=2248
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
			print(error_id," learn_error_id")
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
	  taojiao:go()  --ss go learn
end

function lian:start_success()  --回调函数
  --你听了.*的指导，似乎有些心得。
   self:start() --默认
end

function lian:Next() --下一个学习内容
  self.skillsIndex=self.skillsIndex+1
 -- print(self.skillsIndex,"?>",table.getn(self.skills))
  if self.skillsIndex>table.getn(self.skills) then
     return false
  else
     return true
  end
end

function lian:addskill(skillname)
   --print(table.getn(self.skills),skillname)
   table.insert(self.skills,skillname)
end

function lian:vip_start()
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
			   self:start()
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
			   self:start()
			 end
			 b:check()
		     return
		  end
		  wait.time(10)
	   end)
   end
   w:go(435)
end

function lian:vip_end()
  local w
   w=walk.new()
   w.walkover=function()
	  world.Send("ask ying gu about 结束")

	   local l,w=wait.regexp("^(> |)你向瑛姑打听有关『结束』的消息。$",10)
		  if l==nil then
            local f=function() self:vip_end() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"你向瑛姑打听有关『结束』的消息") then
		     self.run_vip=false
			 local b
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:AfterFinish()
			 end
			 b:check()
			 return
		  end
		  wait.time(10)
   end
   w:go(435)
end

function lian:AfterFinish() --回调函数

end

function lian:ask_wxz()
   local w=walk.new()
   w.walkover=function()
	   world.AddTimer ("wxz", 0, 0, 1, "ask wen about 五行阵", timer_flag.Enabled + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
       world.SetTimerOption ("wxz", "send_to", 10)
   end
   w:go(177)
end

function lian:wxz()

   local w=walk.new()
   w.walkover=function()
        world.Send("qn_qu 500")
		local b=busy.new()
		b.Next=function()
		   self:ask_wxz()

		end
		b:check()
   end
   w:go(4067)
end

function lian:finish()
    if self.weapon~="" then
		world.Send("unwield "..self.weapon)
	end
    --print("vip状态:",self.vip)
	--print("vip run:",self.run_vip)
   if self.vip==true or self.run_vip==true then
      self:vip_end()
   else
      self:AfterFinish()
   end
end

function lian:lingwu_dzxy(cmd)
  wait.make(function()
    world.Send(cmd)
    local l,w=wait.regexp("^(> |)你.*，冥冥之中你的斗转星移又进了一步。$|^(> |)你又掌握了一些在实战中运用斗转星移的技巧。$|^(> |)你的内力不够。$|^(> |)你仰首望天，太阳挂在天空中，白云朵朵，阳光顺着云层的边缘洒下来，你觉得有些刺眼。$|^(> |)你要看什么？$",5)
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
	     print("lian",402)
         self.start_failure(402)
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
			self.lian_end=true
			self:finish()
		end
	    return
	 end
	 if string.find(l,"你要看什么") then
	    self:douzhuan_xingyi3()
	    return
	 end
	 wait.time(5)
  end)
end

function lian:douzhuan_xingyi()  --领悟斗转
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("lingwu zihua")
   end
   w:go(2756)
end

function lian:douzhuan_xingyi2()  --领悟斗转
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("lingwu miji")
   end
   w:go(2846)
end

function lian:douzhuan_xingyi3()  --领悟斗转
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("look sky")
   end
   w:go(2966)
end

function lian:kan()
 wait.make(function()
    world.Send("kan tree")
    local l,w=wait.regexp("^(> |)你使开柴刀对准崖边怪松，一刀刀劈去.*$|^(> |)你要用柴刀劈树。$|^(> |)什么？$|^(> |)你的内力不够。$",5)
     if l==nil then
	   self:kan()
	   return
	 end
	 if string.find(l,"你使开柴刀对准崖边怪松，一刀刀劈去") then
	   local f=function()
	     world.Send("yun refresh")
	     self:kan()
	   end
	   f_wait(f,0.3)
	   return
	 end
	 if string.find(l,"你的内力不够") then
	    local f=function()
		   self:kantree()
		end
	    self:neili_lack(f)
	    return
	 end
	 if string.find(l,"你要用柴刀劈树") then
		world.Send("wield chai dao")
		self:kan()
	   return
	 end
     if string.find(l,"什么") then
	    self:kantree()
	    return
	 end
	 wait.time(5)
  end)
end

function lian:kantree()
  local w=walk.new()
   w.walkover=function()
      world.Send("wield chai dao")
	  self:kan()
   end
   w:go(3158)

end
