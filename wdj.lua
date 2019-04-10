
wdj={
  new=function()
	 local _wdj={}
	 setmetatable(_wdj,wdj)
	 return _wdj
  end,
  wdj1_ok=false,--是否能够打赢门卫
  wdj1_do=false,
  wdj2_ok=false,
  wdj3_ok=false,
}
wdj.__index=wdj
function wdj:start()
   if wdj.wdj1_ok==true then  --已经判定过了
       if wdj.wdj2_ok==false then
         self:get_dan()
	   elseif wdj.wdj2_ok==true and wdj.wdj3_ok==false then
	     self:check_poison()
	   else
	       self:finish()
	   end
   elseif wdj.wdj1_do==true then
        self:finish()
   else
        self:guard()
   end
end

function wdj:finish()
end

function wdj:guard()
   local w=walk.new()
   w.walkover=function()--二位五毒教第二代弟子 五毒教女弟子(Wudujiao dizi)
      world.Send("compare wudujiao dizi")
	  local l,w=wait.regexp("^(> |)wudujiao dizi 不在这里$|^(> |)你感觉.*不过是个大肉脚, 根本不屑一顾。$|^(> |)哇哈哈哈～, .*看起来根本不是你的对手!$|^(> |)你要杀死.*就如要踩死蚂蚁般容易。$|^(> |)虽然从各方面看来你都比.*略胜一筹, 但是也不能轻敌。$|^(> |)你以本身修为判断.*的级数。",5)
	  if l==nil then
	     self:guard()
	     return
	  end
	  if string.find(l,"不在这里") then
	      local exps=tonumber(world.GetVariable("exps")) or 0
		  if exps>800000 then
		      wdj.wdj1_ok=true --静态变量
		      wdj.wdj1_do=true
              self:get_dan()
		  else
		      wdj.wdj1_ok=false  --没法判别
		      wdj.wdj1_do=false  --没法判别
		      self:finish()
		  end

		  return
	  end
   	  if string.find(l,"根本不屑一顾") or string.find(l,"不是你的对手") or string.find(l,"踩死蚂蚁般容易") or string.find(l,"但是也不能轻敌") then
	      --能够打过
		  wdj.wdj1_ok=true --静态变量
		  wdj.wdj1_do=true
          self:get_dan()
	      return
	  end
	  if string.find(l,"你以本身修为判断") then
	      wdj.wdj1_ok=false
		  wdj.wdj1_do=true
		  self:finish()
	     return
	  end
   end
   w:go(366)
end

function wdj:enter()
    world.Send("northup")
	world.Send("northup")
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
		local cd=cond.new()
		cd.over=function()
			for _,i in ipairs(cd.lists) do
				  print(i[1],i[2])
		         if i[1]=="蔓陀萝花毒" then
		           print("中毒状态:",i[2])
				   print("拿到的是假药!!")
			       local sec=i[2]
				   wdj.wdj2_ok=false
			       self:catch_spider()
			       return
		         end
			end
			local count,roomno=Locate(_R)
			if roomno[1]==3187 then
			    wdj.wdj2_ok=true
			    local now=os.time()
		 	    world.Send("set wdj_in "..now)
			    sj.wdj_in_time=now
				local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --和wdj.wdj2_ok 保持一致
		        DatabaseExec("sj",cmd)
				refresh_link()--刷新关系表
				self:catch_spider()
	        else
			    self:kill_wudujiaodizi()
		    end
		end
		cd:start()
	end
	_R:CatchStart()

end

function wdj:kill_wudujiaodizi()
   --print("kkkkkk wudujiaodizi")
   local w=walk.new()
   w.walkover=function()--二位五毒教第二代弟子 五毒教女弟子(Wudujiao dizi)
      local pfm=world.GetVariable("pfm") or ""
	   pfm=convert_pfm(pfm)
	  world.Send("alias pfm "..pfm)
	  world.Send("set wimpycmd pfm\\hp\\cond")
      world.Send("kill wudujiao dizi")
	  local l,w=wait.regexp("^(> |)这里没有这个人。$|^(> |)看起来五毒教女弟子想杀死你！$|^(> |)加油！加油！$",5)
	  if l==nil then
	     self:kill_wudujiaodizi()
	     return
	  end
	  if string.find(l,"这里没有这个人") then
	      --能够打过
		    local _R
            _R=Room.new()
			_R.CatchEnd=function()
               local count,roomno=Locate(_R)
			   if roomno[1]==366 then
			       self:enter()
			   else
			       self:kill_wudujiaodizi()
			   end
			end
			_R:CatchStart()
	      return
	  end
	  if string.find(l,"加油") or string.find(l,"看起来五毒教女弟子") then
	     local f=function()
	        self:kill_wudujiaodizi()
		 end
		 f_wait(f,3)
	     return
	  end
   end
   w:go(366)
end

function wdj:check_poison()
  --print("hi")
    local cd=cond.new()
	cd.over=function()
	   for _,i in ipairs(cd.lists) do
	      print(i[1],i[2])
		   if i[1]=="蔓陀萝花毒" then
		        print("中毒状态:",i[2])
				--print("拿到的是假药!!")
			   local sec=i[2]
			    self:finish()
			   return
		   end
	   end
	   local sp=special_item.new()
       sp.cooldown=function()
	      --print("kill guard")
           self:kill_wudujiaodizi()
       end
	   local equip={}
	   equip=Split("<获取>火折","|")
       sp:check_items(equip)
	end
	cd:start()
end

function wdj:eat_dan()
  wait.make(function()
	  world.Send("fu jiuxuebiyun dan")
      local l,w=wait.regexp("^(> |)你把一颗九雪碧云丹，轻轻咬碎含进嘴里，顿觉神明意朗，脸色红润。$",5)
	  if l==nil then
	     self:eat_dan()
	     return
	  end
      if string.find(l,"你把一颗九雪碧云丹") then
		 local b=busy.new()
		 b.Next=function()
            self:check_poison() --去检查是否会中毒
		 end
		 b:check()
	     return
	  end
  end)
end

function wdj:get_dan()
	local w=walk.new()
	w.walkover=function()
		wait.make(function()
			world.Send("ask cheng about 五毒教")
			world.Send("yes")
			local l,w=wait.regexp("程灵素说道：「你上次答应我的事情还没做，怎麽又来要.*|^(> |)程灵素对你微微一笑，说道：祝你此行顺利。另外希望你能言而有信。$|^(> |)程灵素说道：「我已经给过你了，为何还要向我要？此药很难炼制，不要太贪心！」$",5)
			if l==nil then
				self:get_dan()
				return
			end
			if string.find(l,"怎麽又来要") then
				-- 抓蜘蛛流程  还会给你一颗假丹
				world.AppendToNotepad (WorldName().."_wdj:",os.date()..": 拿到假药!\r\n")
	            --sj.log_catch(WorldName().."_wdj:",500)
				local b=busy.new()
		        b.Next=function()
                  --self:eat_dan() --去检查是否会中毒
				  --self:catch_spider()
				  world.SetVariable("wdj_entry","false")
				  --local cmd="update MUD_Entrance set linkroomno=-1 where direction='shanjiao_shanlu'"
		          --DatabaseExec("sj",cmd)
				  self:finish()
		        end
		        b:check()
				return
			end
			if string.find(l,"程灵素对你微微一笑") or string.find(l,"此药很难炼制，不要太贪心") then
			    --world.AppendToNotepad (WorldName().."_wdj:",os.date()..": yao!\r\n")
	            --sj.log_catch(WorldName().."_wdj:",500)
				self:eat_dan()
				return
			end
		end)
	end
	w:go(373)
end

function wdj:give_spider()
     local w=walk.new()
   w.walkover=function()

	  wait.make(function()
	    world.Send("give cheng zhu")
	   local l,w=wait.regexp("^(> |)你给程灵素一只雪蛛。$|^(> |)你身上没有这样东西。$",5)
	   if l==nil then
		   self:give_spider()
	      return
	   end
	   if string.find(l,"你身上没有这样东西") then
		   self:finish()
	       return
	   end
	   if string.find(l,"你给程灵素") then
			local now=os.time()
			world.Send("set wdj_give "..now)
			--world.AppendToNotepad (WorldName().."_wdj:",os.date()..": sj.wdj_give_time="..now.."!\r\n")
			sj.wdj_give_time=now
	       if wdj.wdj2_ok==true then  --确定吃的真药
		      wdj.wdj3_ok=true
			else
			  wdj.wdj3_ok=false
		   end
		   self:finish()
	      return
	   end
	  end)
	  --
   end
   w:go(373)
end


function wdj:get_spider()
   wait.make(function()
    world.Send("get zhu")
    local l,w=wait.regexp("^(> |)你将雪蛛扶了起来背在背上。$|^(> |)你附近没有这样东西。$",5)
	if l==nil then
	   self:get_spider()
	   return
	end
	if string.find(l,"你将雪蛛扶了起来背在背上") then
	   self:give_spider()
	   return
	end
	if string.find(l,"你附近没有这样东西") then
	   self:finish()
	   return
	end
  end)
end

function wdj:fight_spider(flag)
		if flag==nil or flag==false then
         world.Send("dian fire")
		 world.Send("wield mu jian")
	     world.Send("alias pfm")
		 world.Send("jiali 0")
	     world.Send("yao shuteng")
		 world.Send("unset wimpy")
		 world.Send("unset wimpycmd")
		end
		 world.DoAfter(1.5,"hit zhu")
		 world.DoAfter(1.5,"look")
	    wait.make(function()
		--
	    local l,w=wait.regexp("^(> |).*雪蛛\(Xue zhu\).*(\<战斗中\>|\<昏迷不醒\>).*$|^(> |)雪蛛挣扎了几下，一个不稳晕倒过去。$|^(> |)雪蛛「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)你晃动了半天，发现什麽也没有。$",15)
		if l==nil then
		   self:catch_spider()
		   return
		end
		if string.find(l,"雪蛛挣扎了几下")  or string.find(l,"昏迷不醒") then
		   world.Send("unwield mu jian")
		   self:get_spider()
		   return
		end
		if string.find(l,"Xue zhu") then
		   self:fight_spider(true)
		   return
		end
		if string.find(l,"你晃动了半天，发现什麽也没有") or string.find(l,"挣扎着抽动了几下就死了") then
		   print("蜘蛛死了,等待刷新")
		   world.Send("unwield mu jian")
		   self:finish()
		   return
		end

	    end)
end

function wdj:catch_spider()
    local d=os.time()
	world.Send("set wdj_refresh "..d)
	sj.wdj_refresh_time=d
	--邹柏芝神志迷糊，脚下一个不稳，倒在地上昏了过去。
	--world.AppendToNotepad (WorldName().."_wdj:",os.date()..": sj.wdj_refresh_time="..d.."!\r\n")
   local w=walk.new()
   w.walkover=function()
	  local sp=special_item.new()
	  sp.cooldown=function()
         self:fight_spider()
      end
      sp:unwield_all()

   end
   w:go(3201)
end

function wdj:go()
   -- print("九阳神功直接进入2")
  -- 检查蜘蛛刷新时间
   if sj.wdj_refresh_time~="" then
      local t1=os.time()
	  local interval=os.difftime(t1,sj.wdj_refresh_time)
	  print(interval,":秒"," 蜘蛛刷新间隔600s!")
	  if interval<=600 then --10分钟
	     self:finish()
		 return
	  end
   end

   self:check()
end

function wdj:check()
    --有九阳神功可以直接进入
  local skills=world.GetVariable("teach_skills") or ""
  local ski={}
   ski=Split(skills,"|")
   for _,v in ipairs(ski) do
     if v=="jiuyang-shengong" then
	   --print("九阳神功直接进入1")
	   wdj.wdj1_ok=true
	   wdj.wdj2_ok=true
       wdj.wdj3_ok=true
	     local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --和wdj.wdj2_ok 保持一致
		            DatabaseExec("sj",cmd)
					refresh_link()--刷新关系表
	   self:finish() --有效期内
	   return
     end
   end
   local wdj_auto_entry=world.GetVariable("wdj_auto_entry") or ""
   if wdj_auto_entry=="true" then
	   wdj.wdj1_ok=true
	   wdj.wdj2_ok=true
       wdj.wdj3_ok=true
	     local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --和wdj.wdj2_ok 保持一致
		            DatabaseExec("sj",cmd)
					refresh_link()--刷新关系表
	   self:finish() --有效期内
	   return
   end
  world.Send("exp")
   wait.make(function()
       local l,w=wait.regexp("^(> |)您本次在线(.*)。$",10)
	   if l==nil then
	      self:check()
	      return
	   end
      if string.find(l,"您本次在线") then
	      local connect_hour=w[2]
		  if sj.wdj_in_time=="" then-- 没有获得过
		     --print("时间")
             self:start()
		  else

			 --print(connect_hour,"连线时间")

			 connect_hour=string.gsub(connect_hour,"天","|86400|")
			 connect_hour=string.gsub(connect_hour,"小时","|3600|")
			 connect_hour=string.gsub(connect_hour,"分","|60|")
			 connect_hour=string.gsub(connect_hour,"秒","|1|")
			 local connect_time={}
			 connect_hour=string.sub(connect_hour,1,-2)
			 connect_time=Split(connect_hour,"|")

			 local i
			 local connect_time_num=0
			 for i=1,table.getn(connect_time),2 do
			     connect_time_num=ChineseNum(connect_time[i])*connect_time[i+1]+connect_time_num
			 end
			 local now=os.time()
			 --print(now,"     ",sj.wdj_in_time)
			 local interval1=os.difftime(now,sj.wdj_in_time)
			 local interval2
			 if sj.wdj_give_time=="" then
			    interval2=-1
			 else
			    interval2=os.difftime(now,sj.wdj_give_time)
			 end
			 local interval3
			 if sj.wdj_refresh_time=="" then
			    interval3=-1
			 else
				interval3=os.difftime(now,sj.wdj_refresh_time)
			 end
			 print(interval1,":秒"," 五毒教时间间隔:",sj.wdj_in_time)
			 print(interval2,":秒"," 抓蜘蛛时间间隔",sj.wdj_give_time)
			  print(interval3,":秒"," 抓蜘蛛刷新间隔",sj.wdj_refresh_time)
			 print(connect_time_num," connect_time")
			 --world.AppendToNotepad (WorldName().."_wdj:",os.date().." "..interval1,":秒"," 五毒教时间间隔:",sj.wdj_in_time.."!\r\n")
			 --world.AppendToNotepad (WorldName().."_wdj:",os.date().." "..interval2,":秒"," 抓蜘蛛时间间隔",sj.wdj_give_time.."!\r\n")
			 --world.AppendToNotepad (WorldName().."_wdj:",os.date().." "..connect_time_num.." connect_time".."!\r\n")
             if connect_time_num>interval1 then
			    --print("有效")
			    if 	wdj.wdj2_ok==false then
				  	wdj.wdj2_ok=true--有效
				    local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --和wdj.wdj2_ok 保持一致
		            DatabaseExec("sj",cmd)
					refresh_link()--刷新关系表
				end
				if sj.wdj_give_time=="" then
				   wdj.wdj3_ok=false
				   self:check_poison()
				   return
				elseif connect_time_num>interval2 then
				   wdj.wdj3_ok=true
				   self:finish() --有效期内
				elseif interval3<=900 then --
				    print("刚抓过蜘蛛!等待15分钟,900> ",interval3)
					wdj.wdj3_ok=false
				   self:finish() --有效
				else
				   print("没抓到蜘蛛")
			       wdj.wdj3_ok=false
				   self:check_poison() --去检查蜘蛛
				   return
				end
			 else
			     --print("过期")
				if 	wdj.wdj2_ok==true then
				  local cmd="update MUD_Entrance set linkroomno=-1 where direction='shanjiao_shanlu'" --和wdj.wdj2_ok 保持一致
		          DatabaseExec("sj",cmd)
				  refresh_link()--刷新关系表
				end
				 wdj.wdj2_ok=false
				 wdj.wdj3_ok=false
			     self:start()
			 end

          end		  --五毒教时间
	      return
      end
  end)
end

