--[[4124 lu
鹿清笃对光王说道，“你来的正好,掌药道长又来催我了，需要一批中草药。”
askk lu about 采药
7018 datie pu
askk sun about 药锄

648

4246
你用药锄拨动着四周的灌木杂草，仔细地看有没有草药！

你用药锄不断的拨动着四周的山草，忽然发现杂草之中有一株特别的草！
wa cao

你兴奋过度，把药锄一甩，忽听嘎巴一声，药锄断为两截！]]

caiyao={
  new=function()
     local cy={}
	 setmetatable(cy,{__index=caiyao})
	 return cy
  end,
  neili_upper=1.8,
  version=1.8,

}

function caiyao:ask_lu()
   local player_name=world.GetVariable("player_name") or ""
   world.Send("ask lu about 采药")
   wait.make(function()
     local l,w=wait.regexp("^(> |)鹿清笃对"..player_name.."说道，“你来的正好,掌药道长又来催我了，需要一批中草药。”$|^(> |)鹿清笃说道：「"..player_name.."，我不是安排你去采药去了么？是不是偷懒了？」$",5)

	 if l==nil then
		self:ask_job()
	    return
	 end
	 if string.find(l,"你来的正好") or string.find(l,"我不是安排你去采药去") then
	    local b=busy.new()
		b.Next=function()
	    self:get_yaochu()
		end
		b:check()
	   return
	 end

   end)
end

function caiyao:Status_Check()
	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)

	local vip=world.GetVariable("vip") or "普通玩家"
	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="荣誉终身贵宾" and vip~="月卡贵宾" then
		   print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
		     if h.food<50 then
		       world.Send("ask xiao tong about 食物")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get fan")
			  	 world.Execute("eat fan;eat fan;eat fan;eat fan;drop fan")
				 local f
				 f=function()
				   self:Status_Check()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 elseif h.drink<50 then
			   world.Send("ask xiao tong about 茶")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get cha")
			  	 world.Execute("drink cha;drink cha;drink cha;drop cha")
				 local f
				 f=function()
				    self:Status_Check()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 end
		   end
		   w:go(133) --299 ask xiao tong about 食物 ask xiao tong about 茶
		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
		    print("疗伤")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=4139
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=300
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
		         w:go(4139)
			   end
			end
			x.success=function(h)

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

function caiyao:ask_job()
  	local ts={
	           task_name="全真采药",
	           task_stepname="询问鹿清笃",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
   w.walkover=function()
      self:shield()
      self:ask_lu()
   end
   w:go(4124)
end

--接口函数
function caiyao:jobDone()

end

function caiyao:get_yaochu()
 local ts={
	           task_name="全真采药",
	           task_stepname="拿工具",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
      world.Send("ask sun about 药锄")
	  wait.make(function()
	    local l,w2=wait.regexp("^(> |)孙铁匠给了你一把挖药专用的药锄。$|^(> |)孙铁匠说道：「你不是有了吗，还想要什麽？」$",5)
		if l==nil then
		   self:get_yaochu()
		   return
		end
		if string.find(l,"孙铁匠给了你一把挖药专用的药锄") or string.find(l,"你不是有了") then
		   local b=busy.new()
		   b.Next=function()
		   self:search_caoyao()
		   end
		   b:check()
		   return
		end
	  end)
  end
  w:go(7018)
end

function caiyao:cun_pots()
   local w=walk.new()
   w.walkover=function()
      world.Send("qn_cun 100")
	  self:ask_job()
   end
   w:go(4067)
end

local drug_count=0

function caiyao:reward()
   local ts={
	           task_name="全真采药",
	           task_stepname="奖励",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	drug_count=0
    local w=walk.new()
	w.walkover=function()
	   world.Send("give lu fu ling")
	   world.Send("give lu shouwu")
	   world.Send("give lu ju geng")
	   world.Send("give lu chuan bei")
	   world.Send("give lu jinyin hua")
	   world.Send("give lu sheng di")
	   world.Send("give lu gouzhi zi")
	   world.Send("give lu huang lian")
	   wait.make(function()
	     local l,w=wait.regexp("^(> |)恭喜你！你成功的完成了全真采药任务！你被奖励了：$",2)
		 if l==nil then
			self:jobDone()
		    return
		 end
		 if string.find(l,"你成功的完成了全真采药任务") then
		    self:jobDone()
		    return
		 end
	   end)

	end
	w:go(4124)
end

function caiyao:wa_caoyao()
   local ts={
	           task_name="全真采药",
	           task_stepname="挖药",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   world.Send("wa cao")
   drug_count=drug_count+1
   local f=function()
      if drug_count>3 then
        self:reward()
	  else
	     self:get_yaochu()
	  end
   end
   f_wait(f,0.8)

end

function caiyao:shield()

end

function caiyao:next_search()
   _R=Room.new()
  _R.CatchEnd=function()
     if _R.exits=="east;north;" then
		world.Execute("n;n;n;n")
	 else
         world.Send("south")
  	 end

      self:search()
   end
  _R:CatchStart()


end
--突然从草丛中惊起一只梅花鹿，它大概受了惊吓，发疯似地向你发起进攻！
--地上尚有你寻找的小动物，阻碍你继续寻找草药！
function caiyao:combat()

end

function caiyao:run(i)
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
			   self:recover()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function caiyao:flee()
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

function caiyao:recover()
	local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)

		if  h.qi_percent<=70 or h.jingxue_percent<=80  then
		    print("疗伤")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper)  then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.danger=function()
			   world.Send("yun qi")
			   world.Send("yun jingli")
			   local w=walk.new()
			   w.walkover=function()
			      x:dazuo()
			   end
			   w:go(53)
			end
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self:recover()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,10)
			    end
				if id==777 then
				   self:recover()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(1512)
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   world.Send("yun recover")
			   if h.neili>h.max_neili*2-200 then
			     self:search()
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
			  self:search()
			end
			b:check()
		end
	end
	h:check()
end

function caiyao:search()
   world.Send("search")
   wait.make(function()
      local l,w=wait.regexp("(> |)突然从草丛中惊起一只(.*)，它大概受了惊吓，发疯似地向你发起进攻！$|^(> |)你用药锄不断的拨动着四周的山草，忽然发现杂草之中有一株特别的草！$|^(> |)你把四周的灌木杂草都翻遍了，可是没发现什么，看来这里没指望了！$|^(> |)你没有工具，无法拨开灌木山草寻找草药！$|^(> |)地上尚有你寻找的小动物，阻碍你继续寻找草药！$",2)
	  if l==nil then
		 self:search()
		return
	  end
	 --[[ if string.find(l,"仔细地看有没有草药") then
	    local f=function()
	      self:search()
		end
		f_wait(f,1)
	    return
	  end]]

	  if string.find(l,"你没有工具，无法拨开灌木山草寻找草药") then
	     self:get_yaochu()
	     return
	  end
	  if string.find(l,"你把四周的灌木杂草都翻遍了，可是没发现什么") then
	     local b=busy.new()
		 b.Next=function()
	       self:next_search()
		 end
		 b:check()
		return
	  end
	  if string.find(l,"发疯似地向你发起进攻") then
	      world.Send("kill deer")
		 world.Send("kill baozi")
		 world.Send("kill bee")
		 world.Send("kill monkey")
		 world.Send("kill ye tu")
		  world.Send("kill wuya")
		 self:combat()
	     return
	  end
	  if string.find(l,"地上尚有你寻找的小动物") then
	     world.Send("kill deer")
		 world.Send("kill baozi")
		 world.Send("kill bee")
		 world.Send("kill monkey")
		 world.Send("kill ye tu")
		 world.Send("kill wuya")
		 self:combat()
	     return
	  end
	  if string.find(l,"忽然发现杂草之中有一株特别的草") then
	    local b=busy.new()
		b.Next=function()
		   self:wa_caoyao()
		end
		b:check()
	     return
	  end
   end)
end

function caiyao:search_caoyao()
  local ts={
	           task_name="全真采药",
	           task_stepname="树林挖药",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
     local r=math.random(0,4)
	 if r~=0 then
	   world.Execute("#"..r.." s")
	 end
     self:search()
  end
  w:go(4246)

end
