
--你的内力不够，无法施展「纯阳无极功」
--你盘膝而坐，双手十指张开，举在胸前，作火焰飞腾之状，运起圣火神功开始疗伤。
--你气息不匀，暂时不能施用内功。

heal={
  new=function()
    local hl={}
	setmetatable(hl,heal)
	hl.teach_skill={}
    local teach_skills=world.GetVariable("teach_skills") or nil
    if teach_skills==nil or teach_skills=="" then
      print("teach_skills变量没有设置!!")
    else
      local _skills=Split(teach_skills,"|")
      for _,ts in ipairs(_skills) do
        table.insert(hl.teach_skill,ts)
      end
    end
	return hl
  end,
  is_killxue=false,
  is_qudu=true,
  saferoom=nil,
  count=0,
  omit_snake_poison=true,
  teach_skill={},
}
heal.__index=heal
--内力缺乏停止打坐

function heal:in_progress(count)
    wait.make(function()
	--等待
	print("等待",count)
	  --local l,w=wait.regexp("^(> |)你呼出一口气站了起来，可惜伤势还没有完全恢复。$|^(> |)你内息一停，却见伤势已经全好了。$|^(> |)你运功完毕，站起身来，看上去气色饱满，精神抖擞。$|^(> |)良久，你感觉通过自己的内息运行，身上的伤势已经全好了。$|^(> |)你缓缓站起，只觉全身说不出的舒服畅快，便道：“善哉！善哉！本门易筋经当真是天下绝学！”$|^(> |)你脸色渐渐变得舒缓，箫声亦随之急转直下，渐不可闻。$",20)
	   local l,w=wait.regexp("^(> |)你将草木精华与内息融纳一体，感觉伤势已然痊愈，神情也变得清朗起来。$|^(> |)过了良久，琴音顿止，你蓦觉一股清幽安宁的感觉遍透全身。$|^(> |)突然间琴音在脑海中止歇，你便即惊醒，深吸了一口气，站起身来。$|^(> |)你“哇！”的大叫一声，全身的白气渐渐消散。$|^(> |)你“哇！”的大叫一声，站了起来，但脸色苍白，看来还有伤在身。$|^(> |)你呼出一口气站了起来，可惜伤势还没有完全恢复。$|^(> |)你脸色渐渐变得舒缓，箫声亦随之急转直下，渐不可闻。$|^(> |)你内息一停，却见伤势已经全好了。$|^(> |)你运功完毕，站起身来，看上去气色饱满，精神抖擞。$|^(> |)良久，你感觉通过自己的内息运行，身上的伤势已经全好了。$|^(> |)良久，你感觉通过自己的内息运行，身上所受内伤已经全好了。$|^(> |)你缓缓站起，只觉全身说不出的舒服畅快，便道：“善哉！善哉！本门易筋经当真是天下绝学！”$|^(> |)你并没有受伤！$",20)

	  if l==nil then
	     if count==nil  then
		    count=1
		 end
	    if count>3 then  --超时
		   print("heal 等待时间超时!")
		   self:heal()
		   return
		else
		   count=count+1
		end
	    world.Send("hp")
	    self:in_progress(count)
	    return
	  end
	  if string.find(l,"你并没有受伤") or string.find(l,"本门易筋经") or string.find(l,"你将草木精华与内息融纳一体") or string.find(l,"琴音顿止") or string.find(l,"你脸色渐渐变得舒缓") or string.find(l,"看上去气色饱满") or string.find(l,"已经全好了") then
	     print("完全恢复")
		 self.teach_skill=nil
		 self:kill_xue()
		--self:heal_ok()
	    return
	  end--你呼出一口气站了起来，可惜伤势还没有完全恢复。
	  if string.find(l,"可惜伤势还没有完全恢复") or string.find(l,"突然间琴音在脑海中止歇") or string.find(l,"全身的白气渐渐消散") or string.find(l,"但脸色苍白") then
	    print("内力不够")
	    self:halt()
	    return
	  end

	end)
end

function heal:yangzhou()
    local w=walk.new()
	w.walkover=function()
	  world.Send("ask laoban about 疗伤")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)一柱香的工夫过去了，你觉得伤势已经基本痊愈了。$|^(> |)药铺老板说道：「调皮蛋，跑我这里添乱！」$",5)
	    if l==nil then
		   self:yangzhou()
		   return
		end
		if string.find(l,"一柱香的工夫过去了，你觉得伤势已经基本痊愈了") or string.find(l,"跑我这里添乱") then
		   self.teach_skill=nil
		   self:kill_xue()
		   --self:heal_ok()
		   return
		end
	  end)
	end
	w:go(95)
end

function heal:halt()
    local x
	x=xiulian.new()
	x.min_amount=100
	x.safe_qi=300
	x.limit=true
	x.fail=function(id)
	  --print(id)
		if id==201 or id==1 or id==777 then
			local f
			f=function() x:dazuo() end  --外壳
			f_wait(f,10)
		end
		if id==202 then
		   if self.saferoom==nil then
		     --没有指定房间
              local _R
              _R=Room.new()
              _R.CatchEnd=function()
	          --print("R. hui diao")
                local count,roomno=Locate(_R)
                --print(count,roomno)
	            if count==0 then --new room
	              print("不存在")
	            end
	            if count>=1 then
	              local link=nearest_room(roomno)
	              for _,l in ipairs(link) do
		           if is_Special_exits(l.direction)==false then
		           local w
			       w=walk.new()
			       w.walkover=function()
			        x:dazuo()
			       end
			       w:go(l.linkroomno)
				   return
		           end
		          end
		          --都是特殊出口
		          local w
		          w=walk.new()
		          w.walkover=function()
			        x:dazuo()
		          end
		          w:go(link[1].linkroomno)
	            end
            end
           _R:CatchStart()
	     else
			local w
			w=walk.new()
			w.walkover=function()
			  x:dazuo()
			end
			w:go(self.saferoom)
		   end
		end
	end
	x.success=function(h)
		if h.neili>h.max_neili then
			self:heal()
		else
			print("继续打坐")
			world.Send("yun recover")
			x:dazuo()
		end
	end
	x:dazuo()
end

function heal:heal_ok() --回调函数
end

function heal:heal(special,liaojing)
   --print("疗伤"," 毒 ",check_poison)
   if liaojing==false or liaojing==nil then
      world.Send("unset heal")
   else
      world.Send("set heal jing")
   end
   local g_heal=function()
-- 扬州药店老板疗伤
   local exps=tonumber(world.GetVariable("exps")) or nil
   if exps~=nil and exps<=50000 then
      self:yangzhou()
      return
   end
   local special_heal=world.GetVariable("special_heal") or ""
   if (special==true or special==nil) and (check_poison==false or check_poison==nil) and liaojing==false then  --check_poison 默认是false
     if special_heal=="juxue" then
       self:juxue()
       return
	 elseif special_heal=="hudiegu" then
	   self:hudiegu()
	   return
	 elseif special_heal=="shangyao" then
	   self:shangyao()
	   return
	 elseif special_heal=="liao" then
	    self:liao()
	    return
	 elseif special_heal=="xiaoyao" then
	    self:xiaoyao()
	    return
	 elseif special_heal=="bed" then
	    self:liao_bed()
	    return
     end
   end
    wait.make(function()
	   world.Send("yun heal")
	   local l,w=wait.regexp("^(> |)你连催.*道冷泉内劲游走受损经络开始运功疗伤！$|^(> |)你盘膝而坐，双手十指张开，举在胸前，作火焰飞腾之状，运起圣火神功开始疗伤。$|^(> |)你并没有受伤！$|^(> |)你运起寒冰真气，开始缓缓运气疗伤。$|^(> |)你已经受伤过重，经受不起真气震荡！$|^(> |)你盘膝坐下，开始运功疗伤。$|^(> |)你凝神静气，内息随悠扬箫声在全身游走，恰似碧海浪涛般冲击受损被封经脉。$|^(> |)你盘膝坐下，开始运功疗伤。$|^(> |)你盘膝坐下，依照经中所示的法门调息，只觉丹田中暖烘烘地、活泼泼地，真气流动。$|^(> |)你双手合什，盘膝而坐，口中念起“往生咒”，开始运功疗伤。$|^(> |)你对本草术理的研究还不够，不能疗伤。$|^(> |)你还没有选择你要使用的内功。$|^(> |)你的真气不够。$|^(> |)战斗中运功疗伤？找死吗？$|^(> |)你正要有所动作，突然身旁有人将你一拍：好好看比武，别乱动！$|^(> |)你气息不匀，暂时不能施用内功。$|^(> |)你神情肃然，双目虚闭，开始吸呐身周草木精华为已所用，恢复受损元气。$",20)
	   if l==nil then
	      self:heal(special,liaojing)
	      return
	   end
	   if string.find(l,"你并没有受伤") then
	     self.teach_skill=nil
	     self:kill_xue()
		 --self:heal_ok()
	     return
	   end
	   --你呼出一口气站了起来，可惜伤势还没有完全恢复。
	   if string.find(l,"恢复受损元气") or string.find(l,"冷泉内劲") or string.find(l,"运起圣火神功开始疗伤") or string.find(l,"你双手合什") or string.find(l,"你运起.*，开始缓缓运气疗伤") or string.find(l,"你盘膝坐下，开始运功疗伤。") or string.find(l,"恰似碧海浪涛般冲击受损被封经脉") or string.find(l,"你盘膝坐下，开始运功疗伤") or string.find(l,"你盘膝坐下，依照经中所示的法门调息") then
	      --print("heal 中")
  		  self:in_progress()
		 return
	   end
	   if string.find(l,"你的真气不够") then
		  self:halt()
	      return
	   end
	   if string.find(l,"你已经受伤过重，经受不起真气震荡") then
	     --self:liaoshang()
		 self.eat_drug_busy=function(drugname,drugid,CallBack)  --吃药busy
		     --添加延迟
			 print("尝试")
			 local f=function()
		       self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
		 end
		 self:auto_drug()
	     return
	   end
	   if string.find(l,"你对本草术理的研究还不够，不能疗伤") then
	      print("没法疗伤")
	      self.eat_drug_busy=function(drugname,drugid,CallBack)  --吃药busy
		     --添加延迟
			 print("尝试")
			 local f=function()
		       self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
		  end
	      self:auto_drug(true)
	      return
	   end
	   if string.find(l,"你还没有选择你要使用的内功") then
	     local f=function()
	        world.Send("jifa all")
		    self:heal()
		  end
		  f_wait(f,0.8)
	      return
	   end
	   if string.find(l,"战斗中运功疗伤") then
	      local f=function()
		     self:heal(special,liaojing)
		  end
          safe_room(f)
	      return
	   end

	   if string.find(l,"你正要有所动作") then


		  local f=function()
		     world.Send("out")
	        world.Send("nw")
		    self:heal(special,liaojing)
		  end
		  f_wait(f,2)
	      return
	   end
	   if string.find(l,"你气息不匀") then
	       print("等待2s 继续")

		  local f=function()

		    self:heal(special,liaojing)
		  end
		  f_wait(f,2)
		  return
	   end
	   wait.time(10)

	end)
  end
--解毒代码
  --[[ if check_poison==true then
    local cd=cond.new()
	cd.over=function()
	  print("检查状态")
	  if table.getn(cd.lists)>0 then
		local sec=0
		for _,i in ipairs(cd.lists) do
		    local s,d=string.find(i[1],"毒")
			if s~=nil then
			  --print(s,"test")
		 	  if (s%2)==1 or string.find(i[1],"大手印内伤") or string.find(i[1],"七伤拳内伤") then
				sec=i[2]
				--print(string.find(i[1]),"毒"),":test")
				print("中"..i[1].."毒",sec)
				self.saferoom=505
				if self.omit_snake_poison==true and i[1]=="蛇毒" then
				else
				--if sec>=20 then
				    shutdown()
					self:qudu(sec,i[1],special)
					return
				end
				--end
			  end
			end
	    end
	  end
	  g_heal()
	end
	cd:start()
   else]]
      g_heal()
   --end

end



function heal:wait_ok()
     wait.make(function()

	   local l,w=wait.regexp("^(> |)一柱香的工夫过去了，你觉得伤势已经基本痊愈了。$",5)
	   if l==nil then
	     self.count=self.count+1
		 if self.count>5 then
		   self:ask_heal()
		 else
		   self:wait_ok()
		 end
		 return
	   end
	   if string.find(l,"你觉得伤势已经基本痊愈了") then
	      local b=busy.new()
		  b.Next=function()
		    self.teach_skill=nil
			self:kill_xue()
	        --self:heal_ok()
		  end
		  b:check()
		  return
	   end
	   wait.time(5)
   end)
end

function heal:ask_heal()
  wait.make(function()
       world.Send("ask xue about 疗伤")
	   local l,w=wait.regexp("^(> |)这里没有这个人。$|^(> |)薛神医拿出一根银针轻轻捻入你受伤部位附近的穴道，你感觉舒服多了。|^(> |)一柱香的工夫过去了，你觉得伤势已经基本痊愈了。$|^(> |)薛慕华说道：「你根本没受伤，跑我这里添乱！」$|^(> |)薛慕华说道：「阁下武功是否能指导我一些？」$",5)
	   if l==nil then
	     self:ask_heal()
		 return
	   end
	   if string.find(l,"阁下武功是否能指导我一些") then
	     self:liaoshang()
	     return
	   end
	   if string.find(l,"薛神医拿出一根银针轻轻捻入你受伤部位附近的穴道") then
	     self.count=0
	     self:wait_ok()
	     return
	   end
	   --薛神医拿出一根银针轻轻捻入你受伤部位附近的穴道，你感觉舒服多了。
	   if string.find(l,"你觉得伤势已经基本痊愈了") or string.find(l,"你根本没受伤，跑我这里添乱") then
	      self.teach_skill=nil
		  self:kill_xue()
		  --self:heal_ok()
		  return
	   end
	   if string.find(l,"这里没有这个人") then
	      self:check_place()
	      return
	   end
	   wait.time(5)
   end)
end

function heal:kill_xue()
	if self.is_killxue then
      local exps=world.GetVariable("exps") or 0
	  exps=tonumber(exps)
	  print("kill 薛慕华",exps)
	  if tonumber(exps)>=15000000 then
	    local b=busy.new()
	    b.Next=function()
	     local w=walk.new()
	     w.walkover=function()
		  world.Send("say 薛慕华你的末日到了!!")
		  world.Send("kill xue muhua")
		  wait.make(function()
		    local l,w=wait.regexp("^(> |)薛慕华「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",10)
			if l==nil then
			    self:kill_xue(CallBack)
			    return
			end
			if string.find(l,"这里没有这个人") or string.find(l,"挣扎着抽动了几下就死了") then
			   world.Send("get gold from corpse")
			   self:heal_ok()
			   return
			end
		  end)
		 end
	     w:go(623)
		end
		b:check()
	 else
	   self:heal_ok()
	 end

	else
	   self:heal_ok()
	end
end

function heal:Next_skill(index)
   wait.make(function()
     --print(index,"?>=",table.getn(self.teach_skill))  --薛慕华神志迷糊，脚下一个不稳，倒在地上昏了过去。加入自动杀薛慕华
    if index>=table.getn(self.teach_skill) then
       wait.time(2) --延时2s
	   local special_heal=world.GetVariable("special_heal") or "" --特殊治疗不需要吃金疮药

      if special_heal=="juxue" then
         self:juxue()
         return
	   elseif special_heal=="hudiegu" then
	     self:hudiegu()
	     return
	   elseif special_heal=="shangyao" then
	     self:shangyao()
	     return
	   elseif special_heal=="liao" then
	     self:liao()
	     return
	   elseif special_heal=="xiaoyao" then
	     self:xiaoyao()
	     return
	   elseif special_heal=="bed" then
	     self:liao_bed()
	     return
       end
	   self.is_killxue=true
	   self.eat_drug_busy=function(drugname,drugid,CallBack)  --吃药busy
		     --添加延迟
			 --print("尝试自动吃药")
			local f=function()
		       self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
	   end
	   --print("zidong")
	   self:auto_drug()  --所有技能都太低
	   return
	end
      world.Send("teach xue "..self.teach_skill[index])  --> 薛慕华(Xue xue)告诉你：你的功夫太差。> 薛慕华(Xue xue)告诉你：你的功夫太差。
	   local l,w=wait.regexp("^(> |)你向薛慕华仔细地解说。$|^(> |)薛神医的这个技能已经不能再进步了。$|^(> |)薛慕华说道：「你的功夫太差了。」$|^(> |)你的这个技能太差了，薛神医可没兴趣。$|^(> |)薛慕华.*告诉你.*你的功夫太差。",5)
	   if l==nil then
	      self:liaoshang()
		  return
	   end
	   if string.find(l,"薛神医的这个技能已经不能再进步了") then
	      index=index+1
		  self:Next_skill(index)
	      return
	   end
	   if string.find(l,"你向薛慕华仔细地解说") then
	     self.count=self.count+1
		 if self.count>=5 then
	       local f=function()
             self:ask_heal()
		   end
		   f_wait(f,0.8)
		 else
		   self:Next_skill(index)
		 end
		  return
	   end
	   if string.find(l,"你的功夫太差了") or string.find(l,"你的这个技能太差了") or string.find(l,"你的功夫太差") then
	      index=index+1
		  self:Next_skill(index)
	      return
	   end
	   wait.time(5)
   end)
end

function heal:liaoshang_fail()  --回调函数
   local special_heal=world.GetVariable("special_heal") or ""

     if special_heal=="juxue" then
       self:juxue()
       return
	 elseif special_heal=="hudiegu" then
	   self:hudiegu()
	   return
	 elseif special_heal=="shangyao" then
	   self:shangyao()
	   return
	 elseif special_heal=="liao" then
	    self:liao()
	    return
	 elseif special_heal=="xiaoyao" then
	    self:xiaoyao()
	    return
	 elseif special_heal=="bed" then
	    self:bed()
	    return
     end

    --默认
     print("自定义服药")
	  self.eat_drug_busy=function(drugname,drugid,CallBack)  --吃药busy
		     --添加延迟
			 print("尝试")
			 local f=function()
		        self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
	  end
	 self:auto_drug()
end

function heal:check_place()
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==623  then
	   print("薛神医不在家，有事请烧纸！！")
	 local special_heal=world.GetVariable("special_heal") or ""
     if special_heal=="juxue" then
       local h=hp.new()
       h.checkover=function()
		if h.jingxue_percent<100 then
	      self:heal(false,true)
	    else
          self:juxue()
	    end
       end
	   h:check()
       return
	 elseif special_heal=="hudiegu" then
	   self:hudiegu()
	   return
	 elseif special_heal=="shangyao" then
	   self:shangyao()
	   return
	 elseif special_heal=="xiaoyao" then
	    self:xiaoyao()
	    return
	 elseif special_heal=="liao" then
	   local h=hp.new()
       h.checkover=function()
		if h.jingxue_percent<100 then
	      self:heal(false,true)
	    else
          self:liao()
	    end
       end
	   h:check()
	    return
	 elseif special_heal=="bed" then
	    self:liao_bed()
	     return
     end
	   self.eat_drug_busy=function(drugname,drugid,CallBack)  --吃药busy
		     --添加延迟
			 print("尝试薛神医")
			 local f=function()
		        self:liaoshang()
			 end
			 f_wait(f,5)
		end
	   self:liaoshang_fail()
	 else
	   self:liaoshang()
	 end
   end
  _R:CatchStart()
end

function heal:liaoshang()
 local special_heal=world.GetVariable("special_heal")
   if special==false or special==nil then
     if special_heal=="hudiegu" then
	   self:hudiegu()
	   return
     end
   end
	local teach_skills=world.GetVariable("teach_skills") or nil
    if teach_skills==nil or teach_skills=="" then
      print("teach_skills变量没有设置!!")
    else
      local _skills=Split(teach_skills,"|")
      for _,ts in ipairs(_skills) do
        table.insert(self.teach_skill,ts)
      end
    end
  local w=walk.new()
  w.walkover=function()
    wait.make(function()
	   world.Send("ask xue about 疗伤")
	   if index==nil then
	      index=1
	   end
	   world.Send("teach xue "..self.teach_skill[1])
	   local l,w=wait.regexp("^(> |)这里没有这个人。$|^(> |)你向薛慕华仔细地解说。$|^(> |)薛神医的这个技能已经不能再进步了。$|^(> |)薛慕华说道：「你的功夫太差了。」$|^(> |)你的这个技能太差了，薛神医可没兴趣。$|(> |)薛慕华.*告诉你：你的功夫太差。$",5)
	   if l==nil then
	      self:liaoshang()
		  return
	   end
	   if string.find(l,"薛神医的这个技能已经不能再进步了") then
		  self:Next_skill(2)
	      return
	   end
	   if string.find(l,"你向薛慕华仔细地解说") then
	       self.count=1
	       local f=function()
             self:Next_skill(1)
		   end
		   f_wait(f,0.8)
		   return
	   end
	   if string.find(l,"你的功夫太差") or string.find(l,"你的这个技能太差了") then
	       print("功夫差了！！")
	       self:Next_skill(2)
	       --self:drug()
	       return
	   end
	    if string.find(l,"这里没有这个人") then
	      self:check_place()
	      return
	   end
	   --wait.time(5)
	end)
  end
  w:go(623)
end



----------------------------------------------------------买药
function heal:drug_sellout()  --药物卖光了
    local f=function()
     self:heal(true,false) --默认
	end
	f_wait(f,2) --5s 以后尝试治疗
end

function heal:buy_drug(drugname,drugid,CallBack)  --各种买药
  local w=walk.new()
	 w.walkover=function()
	    wait.make(function()
	     world.Send("list")
         world.Send("buy "..drugid)
		 local l,w=wait.regexp("你以.*的价格从药店掌柜那里买下了一颗.*"..drugname.."。|^(> |)穷光蛋，一边呆着去！$|^(> |)你想买的东西我这里没有。$|^(> |)您的零钱不够了，银票又没人找得开。$",5)
		 if l==nil then
		    self:buy_drug(drugname,drugid,CallBack)
			return
		 end
		 if string.find(l,drugname) then
		    self:eat_drug(drugname,drugid,CallBack)
		    return
		 end
		 if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
		    local f=function()
			   self:buy_drug(drugname,drugid,CallBack)
			end
		    self:qu_gold(f)
		    return
		 end
		 if string.find(l,"你想买的东西我这里没有") then
		    self:drug_sellout() --卖光了
		    return
		 end
		 wait.time(5)
		end)
	 end
	 w:go(413)
end

function heal:eat_drug_busy(drugname,drugid,CallBack)
    --默认的
	 local f=function()
		self:eat_drug(drugname,drugid,CallBack)
	 end
	 f_wait(f,5)
end

function heal:eat_drug(drugname,drugid,CallBack)
   world.Send("fu "..drugid)
   world.Send("eat "..drugid)
   local l,w=wait.regexp("^(> |)你服下一颗.*丹，恢复了不少的精血。$|^(> |)你服下一颗.*丹，顿时感觉精血不再流失。$|^(> |)你敷上一副.*$|^(> |)你上次的药劲儿还没过呢，等会儿再服用吧。$|^(> |)你吃下一颗大还丹，觉得丹田处有暖流涌上，顿时伤势痊愈气血充盈。$|^(> |)你要吃什么？$|^(> |)什么?$|^(> |)你含吃什么？|^(> |)你身上没有这样东西。$",5)
   if l==nil then
      self:eat_drug(drugname,drugid,CallBack)
      return
   end
   if string.find(l,"你敷上一副") or string.find(l,"恢复了不少的精血") or string.find(l,"顿时感觉精血不再流失") or string.find(l,"顿时伤势痊愈气血充盈") then
      CallBack()
      return
   end
   if string.find(l,"等会儿再服用吧") then
      print("服药busy中:",drugname," ",drugid)
	  local f=function()
		--self:eat_drug(drugname,drugid,CallBack)
	   self:heal(true,true)
	   end
	   f_wait(f,2)

      return
   end
   if string.find(l,"你要吃什么") or string.find(l,"什么") or string.find(l,"你身上没有这样东西") then
	    self:buy_drug(drugname,drugid,CallBack)
	    return
   end
   wait.time(5)
end
------------------获取黄金
function heal:qu_gold(CallBack)
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
          world.Send("qu 2 gold")
		local l,w=wait.regexp("^(> |)你从银号里取出二锭黄金。$",5)
		print("金子")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold(CallBack)
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

function heal:auto_drug(flag)  --自动判定服药的种类
   print("吃药")
   local h=hp.new()
   h.checkover=function()
      local drugname
	  local drugid
	  local f=nil

     if h.jingxue_percent<=90 and tonumber(h.max_neili)<=1400  then
	    drugname="疗精丹"
		drugid="liaojing dan"
		f=function()
	      self:heal(false,true)
	   end

	 elseif h.jingxue_percent<=80 and tonumber(h.max_neili)>=1400 then
		drugname="活血疗精丹"
		drugid="huoxue dan"
        f=function()
	      self:heal(false,true)
	   end
	 elseif (h.qi_percent<=80 or flag==true) and h.qi_percent<100 and tonumber(h.max_neili)<=1400 then
	    drugname="金疮药"
		drugid="jinchuang yao"
       f=function()
	      self:heal(true,false)
	   end
     elseif (h.qi_percent<=80 or flag==true) and h.qi_percent<100 and tonumber(h.max_neili)>=1400 then
		drugname="蝉蜕金疮药"
		drugid="chantui yao"
		f=function()
	      self:heal(true,false)
	   end
	 elseif h.qi_percent>=100 and h.jingxue_percent>=90 then
	     print("不需要治疗")
		 self.teach_skill=nil
		 self:kill_xue()
	     --self:heal_ok()
		 return
	 else
		--self:heal_ok()--不进行治疗
		print("不需要吃药")
		if h.jingxue_percent<100 then
		   self:heal(false,true)

		else
		   --self:heal(true,false)
		   drugname="金疮药"
		   drugid="jinchuang yao"
           f=function()
	         self:heal(true,false)
		   end
		   self:eat_drug(drugname,drugid,f)
		end
		return
	 end
	 --print("drug")
	 self:eat_drug(drugname,drugid,f)
   end
   h:check()
end
----------------------------------------解毒 基本流程  判定中毒时间  薛要求疗伤 失败 ->吃药 打坐 检测中毒时间
function heal:yun_qudu(sec,posion)
--你并没有中毒。
--你好象没有中毒吧。
   world.Send("yun qudu")
   world.Send("yun liaodu")
   wait.make(function()
       local l,w=wait.regexp("^(> |)你好象没有中毒吧。$|^(> |)你坐在地上，脸上青一阵白一阵,将体内积蓄的.*逼了出去。$|^(> |)你并没有中毒。$|^(> |)你现在没有中毒。$|^(> |)你深深吸了口气，口中“咕咕。。。”地叫了几声。$|^(> |)你将内力循环一周，身子如灌甘露，丹田里的真气似香烟缭绕，悠游自在。$|^(> |)你所中之毒颇为怪异，看来无法疗毒。$|^(> |)你还得多学点草木药理。$|^(> |)你的内力不够，无法施展「纯阳无极功」$|^(> |)你倒运气息，头下脚上，气血逆行，默运「蛤蟆功」，将体内的.*从进入身子之处逼了出去。",5)
	   if l==nil then
	      self:yun_qudu(sec,posion)
	      return
	   end
	   if string.find(l,"地叫了几声") or string.find(l,"没有中毒") then
	      self:heal()
		  return
	   end
	   if string.find(l,"你的内力不够") then
	       local h=hp.new()
		    h.checkover=function()
				local x=xiulian.new()
			    x.min_amount=10
			    x.safe_qi=h.max_qi*0.5
			    x.limit=true
			    x.fail=function(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self.liaoshang_fail=function()
					    local f=function()
                          self:heal(false,true)
				        end
			            self:buy_drug("活血疗精丹","huoxue dan",f)
			         end
		             self:liaoshang()
				     return
				  end
				  world.Send("yun recover")
				  world.Send("yun jing")
	              local f2
		          f2=function() x:dazuo() end  --外壳
				  f_wait(f2,0.5)
			    end
				if id==777 then
                    --打坐气量大于当前最大气量
				   self.liaoshang_fail=function()
				     local f=function()
					   self:heal(true,false)
				     end
			         self:buy_drug("蝉蜕金疮药","chantui yao",f)
			       end
		           self:liaoshang()
				end
	           if id==202 then
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
                self:yun_qudu(sec,posion)
			end
			x:dazuo()
		   end
		   h:check()
	        return
	   end
	   if string.find(l,"悠游自在") or string.find(l,"气血逆行，默运「蛤蟆功」") or string.find(l,"逼了出去") then
	      self:heal(false,true)
		  return
	   end
	   if string.find(l,"你所中之毒颇为怪异，看来无法疗毒") or string.find(l,"你还得多学点草木药理") then
		  self.is_qudu=false
	      self:heal(false,true)
	      return
	   end
   end)
end

function heal:bingchan()
   local w=walk.new()
   w.walkover=function()
      wait.make(function()
	      world.Send("duihuan bingchan")
	      wait.time(3)
		  local b=busy.new()
		  b.Next=function()
	        world.Execute("#10 xidu")
		    local cd=cond.new()
	        cd.over=function()
	        print("检查状态")
	        if table.getn(cd.lists)>0 then
		      local sec=0
			  for _,i in ipairs(cd.lists) do
		        local s,d=string.find(i[1],"毒")
			  if s~=nil then
			  --print(s,"test")
		 	  if (s%2)==1 or string.find(i[1],"大手印内伤") then
				sec=i[2]
				--print(string.find(i[1]),"毒"),":test")
				print("中"..i[1].."毒",sec)
				self.saferoom=505
				--if sec>=20 then
				    shutdown()
					self:qudu(sec,i[1],special)
					return
				--end
			  end
			end
	    end
	   end
	  self:heal(false,true)
	end
	        cd:start()
		  end
		  b:check()
	  end)

   end
   w:go(84)
end

--[[
      wait.make(function()
	      world.Send("qu tianqi")
	      wait.time(3)
	      world.Send("eat tianqi")
		    local cd=cond.new()
	        cd.over=function()
	        print("检查状态")
	        if table.getn(cd.lists)>0 then
		      local sec=0
			  for _,i in ipairs(cd.lists) do
		        local s,d=string.find(i[1],"毒")
			  if s~=nil then
			  --print(s,"test")
		 	  if (s%2)==1 or string.find(i[1],"大手印内伤") then
				sec=i[2]
				--print(string.find(i[1]),"毒"),":test")
				print("中"..i[1].."毒",sec)
				self.saferoom=505
				if sec>=20 then
				    shutdown()
					self:qudu(sec,i[1],special)
					return
				end
			  end
			end
	    end
	   end
	  self:heal(false,true)
	end
	cd:start()
	  end)]]
function heal:eat_tianqi()
    world.Execute("#5 eat tianqi")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)你服下一份田七鲨胆散，盘膝良久，只觉得一股清凉的气息自丹田涌上来。$",3)
	  if l==nil then
	     self:eat_tianqi()
	     return
	  end
	  if string.find(l,"只觉得一股清凉的气息自丹田涌上来") then
	     local b=busy.new()
		 b.Next=function()
	       self:heal(false,true)
		 end
		 b:check()
	     return
	  end


	end)
end

function heal:qu_tianqi()
    world.Execute("#10 qu tianqi")
	wait.make(function()
	   local l,w=wait.regexp("^(> |)你把田七鲨胆散从个人储物箱中提取出来。$|^(> |)你并没有保存该物品。$",3)
	   if l==nil then
	     self:qu_tianqi()
	     return
	   end
	   if string.find(l,"你把田七鲨胆散从个人储物箱中提取出来") then
		  local b=busy.new()
		  b.Next=function()
	        self:eat_tianqi()
		  end
		  b:check()
	      return
	   end
	   if string.find(l,"你并没有保存该物品") then
	      local b=busy.new()
		  b.Next=function()
		    self:bingchan()
		  end
		  b:check()
	      return
	   end

	end)

end

function heal:tianqi()
   local w=walk.new()
   w.walkover=function()
         local _R
         _R=Room.new()
		 _R.CatchEnd=function()
            if _R.roomname=="杂货铺" and _R.zone=="扬州城" then
			   self:qu_tianqi()
			else
			   self:tianqi()
			end
         end
		 _R:CatchStart()

   end
   w:go(94)
end

--你倒运气息，头下脚上，气血逆行，默运「蛤蟆功」，将体内的蔓陀萝花毒从进入身子之处逼了出去。
function heal:qudu(sec,posion,special)
     local party=world.GetVariable("party") or ""
	 local neigong=world.GetVariable("neigong") or ""
	 if (party=="武当派" or neigong=="蛤蟆功" or neigong=="九阳神功" or party=="星宿派") and self.is_qudu==true then
	     self:yun_qudu(sec,posion)
		 return
	 end
	 if party=="古墓派" then
		self:liaodu_bed()
	    return
	 end
	 local omit=false
	 if posion=="蛇毒" and self.omit_snake_poison==true then
		omit=true
	 end
	 if sec>=90 and omit==false then
	      -- self:bingcan()
		 self:tianqi(sec,posion)
		 return
	 end
     if sec>=1800 and omit==false then
	    print("中毒时间超长,安全退出")
        sj.quit(true)
        return
	 end
     print("驱毒")
	  local h
	  h=hp.new()
	  h.checkover=function()
	      self.drug_sellout=function()  --药物卖完
		      print("药物售完 强制退出!!!")
			  sj.quit(true)
		  end
	      if h.jingxue_percent<=40 or (h.max_jingxue<300 and h.jingxue_percent<100) then
		       self.liaoshang_fail=function()
			      local f=function()
                      self:heal(false,true)
				  end
			      self:buy_drug("活血疗精丹","huoxue dan",f)
			   end
		       self:liaoshang()
			  return
		  end


		  if h.qi_percent<=40 or (h.max_qi<300 and h.qi_percent<100) then
		      self.liaoshang_fail=function()
				  local f=function()
					  self:heal(special,false)
				  end
			      self:buy_drug("蝉蜕金疮药","chantui yao",f)
			   end
		     self:liaoshang()
			 return
		  end
		   --继续job
          if h.jingxue_percent<100 then
		     self:heal(false,true)
		     return
		  end
		  if h.qi_percent==100 then
		      print("驱毒4")
		     self.teach_skill=nil
			 self:kill_xue()
			 --self:heal_ok() --回调函数
			 return
		  end
         print("驱毒3")
		  self:heal(special)
	  end
	  h:check()
end
---------------------------------------特殊治疗
--你所用的内功中没有这种功能。
function heal:juxue()
   wait.make(function()
		print("聚血")
	    world.Send("yun juxue")
	   local l,w=wait.regexp("^(> |)没受伤疗什么伤？$|^(> |)你长吸一口气，精神抖擞的站了起来。$|^(> |)你已经受伤过重，经受不起真气震荡！$|^(> |)你的真气不够。$|^(> |)你所用的内功中没有这种功能。$",10)
	   if l==nil then
	      self:juxue()
	      return
	   end
	   if string.find(l,"没受伤疗什么伤") or string.find(l,"你长吸一口气，精神抖擞的站了起来") then
	     local b=busy.new()
		 b.Next=function()
		   self.teach_skill=nil
		   self:kill_xue()
	       --self:heal_ok()
		 end
		 b:check()
	     return
	   end
	   if string.find(l,"你已经受伤过重，经受不起真气震荡") then
	     --self:liaoshang()
		 self.eat_drug_busy=function(drugname,drugid,CallBack)  --吃药busy
		     --添加延迟
			 print("尝试")
			 local f=function()
		     self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
		 end
		 self:auto_drug()
	     return
	   end
	   if string.find(l,"你所用的内功中没有这种功能") then
	       local fight_jifa=world.GetVariable("fight_jifa") or ""
			if fight_jifa~="" then
			   world.Execute(fight_jifa)
			else
			   world.Send("jifa all")
			end
			world.Send("jifa")
			self:juxue()

		  return
	   end
	   if string.find(l,"你的真气不够") then
	      self:halt()
		  return
	   end
	   wait.time(10)
	end)
end

function heal:liao()
   wait.make(function()
		print("一阳指")
		--world.Send("jifa finger yiyang-zhi")
		--你盘腿坐下，微一凝气，食指依任、督二脉各穴依此点过，食指一收，虚掌按在胸口膻中大穴，纯阳真气源源透入。。。
		--你头顶冒起丝丝白气，过了一盏茶时分，才放开手指,你的脸色看起来也好多了。
		--秋猫并没有受伤！
		world.Execute("jifa finger yiyang-zhi;bei none;bei finger")
	    world.Send("yun liao")
	   local l,w=wait.regexp("^(> |).*并没有受伤！$|^(> |)你头顶冒起丝丝白气，过了一盏茶时分，才放开手指,你的脸色看起来也好多了。$|^(> |)看样子你的医理知识所知甚少，不知如何下手?$",10)
	   if l==nil then
	      self:liao()
	      return
	   end
	   if string.find(l,"并没有受伤") then
	     local b=busy.new()
		 b.Next=function()
		   self.teach_skill=nil
	       self:kill_xue()
		   --self:heal_ok()
		 end
		 b:check()
	     return
	   end
	   if string.find(l,"你的脸色看起来也好多了") then
	     local b=busy.new()
		 b.Next=function()
		   self:liao()
		 end
		 b:check()
	     return
	   end
	   if string.find(l,"不知如何下手") then
	     self:heal(false)
	     return
	   end
	   wait.time(10)
	end)
end

function heal:hudiegu()
	print("蝴蝶谷")
	local r=math.random(0,5)
	local w=walk.new()
	w.walkover=function()
	   world.Send("ask hu about 疗伤")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)胡青牛狠狠地敲着你的头，你数着脑袋上的大包，吓得昏了过去。$|^(> |)胡青牛似乎不懂你的意思。$|^(> |)过了一会儿，你觉得伤势完全回复了！$",8+r)
		if l==nil then
		   self:hudiegu()
		   return
		end
		if string.find(l,"你觉得伤势完全回复了") or string.find(l,"胡青牛狠狠地敲着你的头") or string.find(l,"胡青牛似乎不懂你的意思") then
		   local b=busy.new()
		   b.Next=function()
		     self.teach_skill=nil
			 self:kill_xue()
		     --self:heal_ok()
		   end
		   b:check()
		   return
		end
	  end)
	end
	w:go(3122)
end

function heal:xiaoyao()
	print("逍遥")
	local w1=walk.new()
	w1.walkover=function()
	   world.Send("ask xue about 疗伤")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)薛慕华说道：「你没有受任何伤啊？」$|^(> |)大约过了一盅茶的时份，薛慕华慢慢地站了起来。$",8)
		if l==nil then
		   self:xiaoyao()
		   return
		end
		if string.find(l,"一盅茶的时份") or string.find(l,"你没有受任何伤") then
		   local b=busy.new()
		   b.Next=function()
		     self.teach_skill=nil
		     self:kill_xue()
			 --self:heal_ok()
		   end
		   b:check()
		   return
		end
	  end)
	end
	w1:go(4234)
end

function heal:shangyao()
	print("丐帮伤药")
	local w=walk.new()
	w.walkover=function()
	   world.Send("ask xi about 伤药")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)奚长老说道：「.*并没有受伤，伤药留给受了伤的帮中兄弟吧。」$|^(> |)你获得一包丐帮伤药。$|^(> |)奚长老说道：「目前伤药没有了，等会吧」$",5)
		if l==nil then
		   self:shangyao()
		   return
		end
		if string.find(l,"目前伤药没有了") then
		   self:heal(false,true)
		   return
		end
		if string.find(l,"伤药留给受了伤的帮中兄弟吧") then
		   self.teach_skill=nil
		   self:kill_xue()
		   --self:heal_ok()
		   return
		end
		if string.find(l,"你获得一包丐帮伤药") then
		   local b=busy.new()
		   b.Next=function()
		     world.Send("fu shangyao")
			 self:heal()
		   end
		   b:check()
		   return
		end
	  end)
	end
	w:go(2287)
end

function heal:liao_bed()
  print("古墓寒玉床")
  local t1=os.time()
  if sj.marks_bed~=nil and sj.marks_bed~="" then
    local t2=os.difftime(t1,sj.marks_bed)
    --print(t2,":秒","时间间隔")
	if t2<=200 then
	   local h=hp.new()
	   h.checkover=function()
          if h.qi_percent<100 then
 		     self:heal(false,false)
		  else
			  self:heal(false,true)
		  end
	   end
	   h:check()
	  return
	end
  end
  local h=hp.new()
  h.checkover=function()
     if h.qi_percent>=95 and h.qi_percent<100 then
		self:heal(false,false)
		return
	 end
	 if h.jingxue_percent<100 then
		self:liaodu_bed()
	    return
	 end
     local w=walk.new()
     w.walkover=function()
     world.Send("liao bed")
	 wait.make(function()
       local l,w=wait.regexp("^(> |)不一会儿，你只觉得神采奕奕，伤口已然痊愈。$|^(> |)你现在身上没有受到任何伤害！$",20)
	   if l==nil then
	      self:liao_bed()
		  return
	   end
	   if string.find(l,"你只觉得神采奕奕") then
		  sj.marks_bed=os.time()
	      --self:heal_ok()
		  self:kill_xue()
	      return
	   end
	   if string.find(l,"没有受到任何伤害") then
	       self:kill_xue()
	      return
	   end

	 end)
    end
    w:go(5048)
  end
  h:check()

end

function heal:liaodu_bed()
  print("古墓寒玉床疗毒")
  if sj.marks_bed~=nil and sj.marks_bed~="" then
    local t1=os.time()
    local t2=os.difftime(t1,sj.marks_bed)
    print(t2,":秒","时间间隔")
	if t2<=200 then
      self:liaodu_bed()
	  return
	end
  end
  local w=walk.new()
  w.walkover=function()
    world.Send("liaodu bed")
    local l,w=wait.regexp("^(> |)不一会儿，你只觉得出了一身大汗，毒伤已然减轻不少。$|^(> |)你好象没有中毒吧？$",20)
	if l==nil then
	    self:liaodu_bed()
	    return
	end
	if string.find(l,"毒伤已然减轻不少") then
	   sj.marks_bed=os.time()
	   self:heal(false,false)
	   return
	end
	if string.find(l,"你好象没有中毒吧") then
	   self:heal(false,true)
	   return
	end
  end
  w:go(5048)
end
