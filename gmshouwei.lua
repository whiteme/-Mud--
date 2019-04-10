--全真嫡传任务
--尹志平在你耳边小声说道，“事情已经明了，此次主持袭扰龙姑娘的主凶是公孙止这恶贼！”
--尹志平要你去杀公孙止,你如果愿意就输入(answer yes ),不愿意就输入(answer no)！
gmshouwei={
  new=function()
    local gm={}
	  setmetatable(gm,{__index=gmshouwei})
	 return gm
  end,
  neili_upper=1.8,
  version=1.8,
}
--尹志平说道：「光王,你上一次任务还没完成呢。」
function gmshouwei:catch_place()
   local player_name=world.GetVariable("player_name") or ""
   wait.make(function()

      local l,w=wait.regexp("^(> |)尹志平说道：「我看中天门乃是去往古墓的必经之路，"..player_name.."，你守卫在哪儿，以防有人来此捣乱。」$|^(> |)尹志平说道：「我不是让你去杀.*了么？你怎么还不去？!」$|^(> |)尹志平说道：「"..player_name..",你刚结束守卫古墓，还是先休息一会吧。」$|^(> |)尹志平说道：「"..player_name..",你上一次任务还没完成呢。」$",10)
	  if l==nil then
	     self:ask_job()
	     return
	  end
	  if string.find(l,"中天门乃是去往古墓的必经之路") then
	    local b=busy.new()
		b.Next=function()
	     self:zhongtian()
		end
		b:check()
	     return
	  end
	  if string.find(l,"你刚结束守卫古墓") then
	    local b=busy.new()
		b.Next=function()
	     self:jobDone()
		end
		b:check()
	    return
	  end

	  if string.find(l,"我不是让你去杀") or string.find(l,"你上一次任务还没完成呢") then
	   local b=busy.new()
		b.Next=function()
	     self:giveup()
		end
		b:check()

	     return
	  end
   end)
end
--远处传来一阵脚步声，甚是喧嚣,看来有不少人正在赶来。
--尹志平说道：「我看中天门乃是去往古墓的必经之路，光王，你守卫在哪儿，以防有人来此捣乱。」
function gmshouwei:ask_job()
   local w=walk.new()
    w.walkover=function()
	   world.Send("ask yin about 守卫古墓")
	   self:catch_place()
	end
	w:go(4121)

end

function gmshouwei:zhongtian()

   local w=walk.new()
   w.walkover=function()
      self:shouwei()
   end
   w:go(643)

end
--一名光王所要追拿的神秘人晃悠悠的走了过来，见你在此守卫，立即对你发起猛烈的攻击！
--恭喜你！你成功的完成了守卫古墓任务！你被奖励了：
--黑衣人「啪」的一声倒在地上，挣扎着抽动了几下就死了。
function gmshouwei:combat()



end

function gmshouwei:giveup()
   local w=walk.new()
   w.walkover=function()
       world.Send("ask yin about 放弃")
	   local f=function()
	      self:ask_job()
	   end
	   f_wait(f,2)
   end
   w:go(4121)
end

function gmshouwei:auto_wield_weapon(f,error_deal)
--你将凝晶雁翎箫握在手中。你「唰」的一声抽出一柄长剑握在手中。

   wait.make(function()
	 local l,w=wait.regexp("(.*)\\((.*)\\)$|^(> |)设定环境变量：action \\= \\\"砍头\\\"$",5)
    if l==nil then
	   --self:auto_wield_weapon(f,error_deal)
	   self:qie_corpse()
	   return
	end
	if string.find(l,")") then
	   --print("auto_wield_weapon",w[1],w[2])
	   local item_name=w[1]
	   local item_id=string.lower(w[2])
      if (string.find(item_id,"sword") or string.find(item_id,"jian")) and string.find(item_name,"剑") then
         world.Send("wield "..item_id)
		  self.weapon_exist=true
      elseif (string.find(item_id,"axe") or string.find(item_id,"fu")) and string.find(item_name,"斧") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"blade") or string.find(item_id,"dao")) and string.find(item_name,"刀") or string.find(item_id,"xue sui") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"dagger") or string.find(item_id,"bishou")) and string.find(item_name,"匕") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
	  end
	  self:auto_wield_weapon(f,error_deal)
	  return
	end
    if string.find(l,"设定环境变量：action") then
	  --print(self.weapon_exits,"值")
	   if self.weapon_exist==true then
	      f()
	   else
	     print("没有合适武器!!，建议购买武器!")
         error_deal()
	   end

	   return
	end
	wait.time(5)
   end)
end

function gmshouwei:give_head()
local ts={
	           task_name="全真守墓任务",
	           task_stepname="奖励",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   world.Send("leavefb")
    local w=walk.new()
    w.walkover=function()
	   world.Send("give yin head")
	   world.Send("set action 奖励")
	   self:reward()
	end
	w:go(4121)
end

function gmshouwei:get_corpse(index)
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
--   你将司徒同的尸体扶了起来背在背上。
--   你附近没有这样东西。
      if index==nil then
	     index=1
		  world.Send("get corpse")
	  else
		  world.Send("get corpse "..index)
	  end

	   local l,w=wait.regexp("^(> |)你将(.*)的尸体扶了起来背在背上。$|^(> |)你附近没有这样东西。$|^(> |)光天化日的想抢劫啊？$",3)
	   if l==nil then
	      self:get_corpse(index)
	      return
	   end
	   if string.find(l,"想抢劫") then
	       wait.time(0.5)
		   index=index+1
	       self:get_corpse(index)
	       return
	   end
	   if string.find(l,"的尸体扶了起来背在背上。") then
		  self:give_head()
		  return
	   end
	   if string.find(l,"你附近没有这样东西") then
	      self:giveup()
	      return
	   end
   end
   b:check()
end

function gmshouwei:qie_corpse(index)
   --local f=function(arg)
    --  self:qie_corpse(arg)
   --end
   --thread_monitor("huashan:qie_corpse",f,{index})
  wait.make(function()
    world.Send("wield jian")

   if index==nil then
      world.Send("get gold from corpse")
	  world.Send("get ling from corpse")
      world.Send("qie corpse")
	else
	   world.Send("get gold from corpse "..index)
	  world.Send("get ling from corpse "..index)
	  world.Send("qie corpse ".. index)
   end


   local l,w=wait.regexp("只听“咔”的一声，你将.*的首级斩了下来，提在手中。|^(> |)乱切别人杀的人干嘛啊？$|^(> |)那具尸体已经没有首级了。$|^(> |)你找不到 corpse 这样东西。$|^(> |)找不到这个东西。$|(> |)你手上这件兵器无锋无刃，如何能切下这尸体的头来？$|^(> |)你得用件锋利的器具才能切下这尸体的头来。$|^(> |)不会吧，你对动物的尸体也感兴趣？$",5)
   if l==nil then
      self:qie_corpse()
	  return
   end
   if string.find(l,"乱切别人杀的人干嘛啊") or string.find(l,"那具尸体已经没有首级了") or string.find(l,"你对动物的尸体也感兴趣") then
      if index==nil then
	     index=2
	  else
	     index=index+1
	  end
      self:qie_corpse(index)
      return
   end
   if string.find(l,"首级斩了下来，提在手中") then
      local b=busy.new()
	  b.Next=function()
	    local sp=special_item.new()
   	     sp.cooldown=function()
           self:give_head()
         end
        sp:unwield_all()
	  end
	  b:check()
      return
   end
   if string.find(l,"找不到") then
       local sp=special_item.new()
	   sp.cooldown=function()
         self:giveup()
	   end
	   sp:unwield_all()
      return
   end
    if string.find(l,"你手上这件兵器无锋无刃，如何能切下这尸体的头来") or string.find(l,"你得用件锋利的器具才能切下这尸体的头来") then
      local sp=special_item.new()
   	  sp.cooldown=function()
	    local f=function()
          self:qie_corpse()
		end
		local error_deal=function()
		     self:get_corpse()
		end
		local do_again=function()
		  world.Send("i")
	  	  self:auto_wield_weapon(f,error_deal)
		  world.Send("set action 砍头")
		end
		f_wait(do_again,0.5)
      end
      sp:unwield_all()
      return
   end
   wait.time(5)
  end)
end

function gmshouwei:attacker_die()
    --草贼「啪」的一声倒在地上，挣扎着抽动了几下就死了。
end

--恭喜你！你成功的完成了守卫古墓任务！你被奖励了：
--你对尹志平点了点头，说道，“既然是公孙止这狗贼做的，那就杀了他好了！”
--尹志平(Yin zhiping)告诉你：公孙止尚未离开全真区域，正在石阶附近一带活动!

--尹志平道，“只有把这批人杀了才能彻底阻止他们对龙姑娘的骚扰！”

--石阶 4129

function gmshouwei:checkNPC(npc,roomno)

      --thread_monitor("huashan:checkNPC",f,{npc,roomno})
    wait.make(function()
      world.Execute("look;set action 核对身份")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)设定环境变量：action \\= \\\"核对身份\\\"",2)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
	      --没有找到
		  --

		  return
	  end
	  --[[if string.find(l,"的尸体") then
	     self:robber_die()
	     return
	  end]]
	  if string.find(l,npc) then
	     --找到
		  local id=string.lower(Trim(w[2]))
  	local ts={
	           task_name="全真守墓任务",
	           task_stepname="战斗"..npc,
	           task_step=5,
	           task_maxsteps=5,
	           task_location=roomno,
	           task_description="打击情敌",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

		  shutdown()
		  world.Send("kill "..id)
		  self:wait_attacker_die(npc)
		  return
	  end
	  wait.time(6)
   end)
end

function gmshouwei:escape(location,npc)

	local ts={
	           task_name="全真守墓任务",
	           task_stepname="搜索"..location,
	           task_step=4,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="寻找 "..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local roomno=0

    if location=="石阶" then
	   roomno=4129
	end

	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
		local w=walk.new()
	    w.walkover=function()
	      self:checkNPC(npc,roomno)
		end
		w:go(roomno)
	 end
	 b:check()
end
--尹志平对光王悄声说道，“马光佐尚未离开全真区域，正在石阶附近一带活动!”
--尹志平对光王悄声说道，“马光佐尚未离开全真区域，正在石阶附近一带活动!”
--尹志平(Yin zhiping)告诉你：公孙止尚未离开全真区域，正在石阶附近一带活动!

function gmshouwei:sec_attack()
     local player_name=world.GetVariable("player_name") or ""
     wait.make(function()
	    local l,w=wait.regexp("^(> |)尹志平\\(Yin zhiping\\)告诉你：(.*)尚未离开全真区域，正在(.*)附近一带活动!$|^(> |)尹志平对"..player_name.."悄声说道，“(.*)尚未离开全真区域，正在(.*)附近一带活动!”$",5)

		if l==nil then
			self:sec_attack()
		   return
		end
		if string.find(l,"悄声说道") then
		   local name=w[5]
		   local place=w[6]
          print(name,place)
		     self:escape(place,name)
		   return
		end
		if string.find(l,"告诉你") then
		   local name=w[2]
		   local place=w[3]
          print(name,place)
		     self:escape(place,name)
		   return
		end
	 end)

end

function gmshouwei:reward()
  wait.make(function()
    local l,w=wait.regexp("^(> |)尹志平在你耳边小声说道，“事情已经明了，此次主持袭扰龙姑娘的主凶是(.*)这恶贼！”$|^(> |)设定环境变量：action = \\\"奖励\\\"",5)
	if l==nil then

	    self:give_head()
	   return
	end
	if string.find(l,"事情已经明了") then
	    world.Send("answer yes")
	    self:sec_attack()
	    return
	end
	if string.find(l,"设定环境变量：action") then
	   self:jobDone()
	   return
	end

  end)
end

function gmshouwei:jobDone()

end

function gmshouwei:wait_attacker_die(npc)
  wait.make(function()
    local l,w=wait.regexp("^(> |)"..npc.."「啪」的一声倒在地上，挣扎着抽动了几下就死了。$",10)

	if l==nil then
	   self:wait_attacker_die(npc)
	   return
	end
	if string.find(l,"挣扎着抽动了几下就死了") then
	    self:attacker_die()
	   return
	end

  end)

end

function gmshouwei:wait_guard()
local ts={
	           task_name="全真守墓任务",
	           task_stepname="等待淫贼",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local player_name=world.GetVariable("player_name") or ""
   wait.make(function()
      local l,w=wait.regexp("^(> |)一名"..player_name.."所要追拿的(.*)晃悠悠的走了过来，见你在此守卫，立即对你发起猛烈的攻击！$|^(> |)(.*)\\\(Attacker\\\)",10)
	  if l==nil then
	     world.Send("look")
	     self:wait_guard()
	     return
	  end
	  if string.find(l,"立即对你发起猛烈的攻击") then
	      local npc=w[2]
		  print(npc," npc")
	      self:wait_attacker_die(npc)
	      self:combat()


		 return
	  end
	  if string.find(l,"Attacker") then
	     local npc=w[4]
		 print(npc," npc")
	      self:wait_attacker_die(npc)
	      self:combat()

	     return
	  end

   end)
end

function gmshouwei:shield()

end

function gmshouwei:shouwei()
--远处传来一阵脚步声，甚是喧嚣,看来有不少人正在赶来。
   world.Send("shouwei")
   wait.make(function()
      local l,w=wait.regexp("^(> |)远处传来一阵脚步声，甚是喧嚣,看来有不少人正在赶来。$",5)
	  if l==nil then
	     self:zhongtian()
	     return
	  end
	  if string.find(l,"远处传来一阵脚步声") then
	     self:shield()
	     local f=function()
		  world.Send("look")
	      self:wait_guard()
		 end
		 f_wait(f,5)
	     return
	  end

   end)
end

function gmshouwei:full()
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 	local qi_percent=world.GetVariable("qi_percent") or 100
		qi_percent=assert(tonumber(qi_percent),"qi_percent变量必须输入数字！") or 100
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

		elseif h.jingxue_percent<=liao_percent or h.qi_percent<=80 then
		    print(h.jingxue_percent," jingxue_percent",h.qi_percent," qi_percent")
		   --│星宿掌毒        五分                     毒 │
		   --可能中毒了
			  print("疗伤")
              local rc=heal.new()
			  rc.saferoom=234
			  --rc.teach_skill=teach_skill --config 全局变量
			  rc.heal_ok=function()
			     heal_ok=true
			     self:Status_Check()
			  end
			  rc.liaoshang_fail=function()

			    self:liaoshang_fail()
			    local f=function()
					rc:heal(false,true)
				end
				local drugname
				local drugid
				if h.jingxue_percent<=80 then
				    drugname="活血疗精丹"
				    drugid="huoxue dan"
				else
				    drugname="蝉蜕金疮药"
				    drugid="chantui yao"
				end
			    rc:buy_drug(drugname,drugid,f)
			end
			  rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("打通经脉")
            local rc=heal.new()
			world.Send("set heal jing")
			rc.saferoom=234
			--rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			    world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=234
			rc.heal_ok=function()
			   --heal_ok=true
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
		    heal_ok=false --复位
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
			x.min_amount=100
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun regenerate")
				  world.Send("yun recover")
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
		         w:go(234)
			   end
			end
			x.success=function(h)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     world.Send("yun recover")
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


--你发现基本上已经把寨栏修补得差不多了，应该回去覆命了!!
function gmshouwei:Status_Check()
  	local ts={
	           task_name="全真守墓任务",
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
					  local f=function()
			             self:Status_Check()
					  end
					  f_wait(f,3)
			        end
					if rc.omit_snake_poison==true and i[1]=="蛇毒" then --忽略蛇毒

					else
			          rc:qudu(sec,i[1],false)
					  return
					end
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
			        rc:heal(true,false)
				    return
				 end
			   end
		     end
            self:full()
		end
		cd:start()
end
