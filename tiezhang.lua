--铁掌嫡传任务
tiezhang={
  new=function()
    local tz={}
	  setmetatable(tz,{__index=tiezhang})
	 return tz
  end,
  neili_upper=1.8,
}


function tiezhang:do_jobs()

end

function tiezhang:xiu()
   world.Send("repair 寨栏")
   wait.make(function()
    local l,w=wait.regexp("^(> |)看起来官府士兵想杀死你！$|^(> |)你发现基本上已经把寨栏修补得差不多了，应该回去覆命了!!$|^(> |)你身上没有这样东西。$|^(> |)你必须跟帮主领了这工作才能在这里干! $",2)

	if l==nil then
	   self:xiu()
	   return
	end
	if string.find(l,"看起来官府士兵想杀死你") then
	   shutdown()
	   world.Send("kill shibing")
	   world.Send("unwield tie chui")
	   self:combat()
	   return
	end
	if string.find(l,"你必须跟帮主领了这工作才能在这里干") then
	   self:go_fa_mu()
	   return
	end
	if string.find(l,"你身上没有这样东西") then
	   self:repair_liba()
	   return
	end
	if string.find(l,"应该回去覆命") then
	   self:return_tools()
	   return
	end
  end)

end

function tiezhang:go_xiu()
local ts={
	           task_name="铁掌嫡传任务",
	           task_stepname="修栅栏",
	           task_step=2,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
   w.walkover=function()
      self:repair_liba()
   end
   w:go(246)
end

function tiezhang:repair_liba()
 local sp=special_item.new()
	sp.cooldown=function()
      world.Send("wield tie chui")
	  local f=function()
	  self:xiu()
	  end
	  f_wait(f,1)
   end
   sp:unwield_all()
end
--2698
--你发现地上的木头正好可以挑一担了，应该回去覆命了!!

--> 看起来官府士兵想杀死你！
function tiezhang:fa_mu()
  world.Send("fa mu")
  wait.make(function()
    local l,w=wait.regexp("^(> |)看起来官府士兵想杀死你！$|^(> |)你发现地上的木头正好可以挑一担了，应该回去覆命了!!$|^(> |)你想用什么来伐木？$|^(> |)你必须跟帮主领了这工作才能在这里干! $",2)

	if l==nil then
	   self:fa_mu()
	   return
	end
	if string.find(l,"你想用什么来伐木") then
	   self:start_fa_mu()
	   return
	end
	if string.find(l,"你必须跟帮主领了这工作才能在这里干") then
	   self:go_wa_xianjing()
	   return
	end
	if string.find(l,"看起来官府士兵想杀死你") then
	   shutdown()
	   world.Send("unwield axe")
	   world.Send("kill shibing")
	   self:combat()
	   return
	end
	if string.find(l,"应该回去覆命") then
	   self:return_tools()
	   return
	end
  end)
end

function tiezhang:before_kill()

end

function tiezhang:jobDone()

end


function tiezhang:return_tools()
local ts={
	           task_name="铁掌嫡传任务",
	           task_stepname="奖励",
	           task_step=3,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
   w.walkover=function()
       world.Send("give tong axe")
	   world.Send("give tong tie chui")
	   world.Send("give tong chan")
	   world.Execute("w;w;w;n;task ok")
	   self:jobDone()

   end
   w:go(2419)
end

function tiezhang:start_fa_mu()
  local sp=special_item.new()
	sp.cooldown=function()
      world.Send("wield axe")
	  local f=function()
	    self:fa_mu()
	  end
	  f_wait(f,1)
   end
   sp:unwield_all()
end

function tiezhang:go_fa_mu()
local ts={
	           task_name="铁掌嫡传任务",
	           task_stepname="伐木",
	           task_step=2,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
   w.walkover=function()
      self:start_fa_mu()
   end
   w:go(2698)

end

function tiezhang:wa_xianjing()
  world.Send("wa 陷井")
  wait.make(function()
    local l,w=wait.regexp("^(> |)看起来官府士兵想杀死你！$|^(> |)你发现陷井已挖好，赶紧把一些干草铺在陷井上，回去覆命了!!$|^(> |)你想用什么来挖？$|^(> |)你必须跟帮主领了这工作才能在这里干! $",2)

	if l==nil then
	   self:wa_xianjing()
	   return
	end
	if string.find(l,"你想用什么来挖") then
	   local f=function()
	     self:start_wa_xianjing()
	   end
	   f_wait(f,2)
	   return
	end
	if string.find(l,"你必须跟帮主领了这工作才能在这里干") then
	   self:go_xiu()
	   return
	end
	if string.find(l,"看起来官府士兵想杀死你") then
	   shutdown()
	   world.Send("unwield tie chan")
	   world.Send("kill shibing")
	   self:combat()
	   return
	end
	if string.find(l,"回去覆命") then
	   self:return_tools()
	   return
	end
  end)
end


function tiezhang:start_wa_xianjing()
  local sp=special_item.new()
	sp.cooldown=function()
      world.Send("wield tie chan")
	  local f=function()
	  self:wa_xianjing()
	  end
	  f_wait(f,1)
   end
   sp:unwield_all()
end

function tiezhang:go_wa_xianjing()
local ts={
	           task_name="铁掌嫡传任务",
	           task_stepname="挖陷阱",
	           task_step=2,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
      local w=walk.new()
   w.walkover=function()
      self:start_wa_xianjing()
   end
   w:go(244)
end

function tiezhang:ask_tools()
   world.Send("ask tong about 工具")
   wait.make(function()
      local l,w=wait.regexp("^(> |)小僮说道：在中指锋山上有一片松树林，到那里去伐木吧，不过听说树林里有野兽，要当心啊。$|^(> |)小僮说道：把山门二侧的寨栏修补一下，已经有很长时间没人去修补过寨栏了。$|^(> |)小僮说道：把陷井挖在广场外的山路上，以防江湖门派和官府对铁掌帮的清剿和寻仇。$|^(> |)小僮说道：你先把工具还了，再领工具吧。$",5)
	  if l==nil then
	     self:ask_tools()
	     return
	  end
	  if string.find(l,"松树林") then
	     self.do_jobs=function()
		    self:start_fa_mu()
		 end
		local b=busy.new()
	     b.Next=function()
	       self:go_fa_mu()
	     end
	     b:check()
	     return
	  end
	  if string.find(l,"把陷井挖在广场外的山路上") then
	      self.do_jobs=function()
		    self:start_wa_xianjing()
		 end
		local b=busy.new()
	     b.Next=function()
	       self:go_wa_xianjing()
	     end
	     b:check()

	  end
      if string.find(l,"寨栏修补") then
	      self.do_jobs=function()
		      self:repair_liba()
		   end
	     local b=busy.new()
	     b.Next=function()
	        self:go_xiu()
	     end
		b:check()
	     return
	  end
	  if string.find(l,"你先把工具还了") then
	     world.Execute("look chui;look chan;look axe")
		 wait.make(function()
		   local l,w=wait.regexp("^(> |)这是一个大铁锤。$|^(> |)这是一把大铁铲。$|^(> |)这是一普普通通的铁斧。$",5)
		   if l==nil then
		      self:ask_tools()
		      return
		   end
		   if string.find(l,"铁锤") then

		      self.do_jobs=function()
		        self:repair_liba()
		      end
	          local b=busy.new()
	          b.Next=function()
	            self:go_xiu()
	         end
		     b:check()
		     return
		   end

		 if string.find(l,"大铁铲") then
		   self.do_jobs=function()
		      self:start_wa_xianjing()
		    end
		   local b=busy.new()
	        b.Next=function()
	          self:go_wa_xianjing()
	        end
	        b:check()
		    return
		 end

		 if string.find(l,"铁斧") then

		   self.do_jobs=function()
		    self:start_fa_mu()
		   end
		  local b=busy.new()
	       b.Next=function()
	         self:go_fa_mu()
	       end
	       b:check()
		    return
		 end

	  end)
          return
	   end
   end)

end
--小僮说道：在中指锋山上有一片松树林，到那里去伐木吧，不过听说树林里有野兽，要当心啊。
function tiezhang:get_tools()
 local w=walk.new()
   w.walkover=function()
       self:ask_tools()

   end
   w:go(2419)
end


function tiezhang:ask_job()
   local w=walk.new()
   w.walkover=function()
      world.Send("ask qiu about 工作")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)裘千仞说道：「.*现在没有什么事可做，过段时间再来吧。」$|^(> |)裘千仞说道：「铁掌帮既要防止官府对我们的清剿，还要防止江湖其它门派对我们帮会的寻仇.*|^(> |)裘千仞说道：「你不是已经领了工作吗？还不快去做。」$",5)
		if l==nil then
		   self:ask_job()
		   return
		end
		if string.find(l,"现在没有什么事可做") then

	    	local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local f=function()
			      self:ask_job()
			   end
			   f_wait(f,5)
			end
			b:check()

		end

        if string.find(l,"铁掌帮既要防止官府对我们的清剿") or string.find(l,"还不快去做") then
		    local b=busy.new()
	  b.Next=function()
	    self:before_kill()
	    self:get_tools()
	  end
	  b:check()
		   return
		end

	  end)


   end
   w:go(2389)
end

function tiezhang:full()
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
function tiezhang:Status_Check()
  	local ts={
	           task_name="铁掌嫡传任务",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=3,
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
