--武当守鼎
shouding={
  new=function()
    local sd={}
	 setmetatable(sd,{__index=shouding})
	 return sd
  end,
  neili_upper=1.9,


}

function shouding:kanshou()
	local ts={
	           task_name="守鼎",
	           task_stepname="守鼎",
	           task_step=1,
	           task_maxsteps=1,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    self:shield()
	--CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:工作开始!", "yellow", "black") -- yellow on white

       local w
        w=walk.new()
	    w.walkover=function()
        wait.make(function()
        world.Send("kanshou")
		local l,w=wait.regexp("^(> |)你想看守铜鼎丹炉。$|^(> |)你还是先去歇息片刻再来吧。$",5)
		if l==nil then
		   self:kanshou()
		   return
		end
		if string.find(l,"你想看守铜鼎丹炉") then
		   self:wait_attacker()
 		   return
		end
		if string.find(l,"你还是先去歇息片刻再来吧") then
		   self:jobDone()
		   return
		end

	  end)
     end
     w:go(2984)
end

function shouding:combat()
    print("默认战斗开始")
	shutdown()
	world.Execute("halt;halt;halt;halt")
	wait.make(function()
	    local l,w=wait.regexp("^(> |)只见.*转身几个起落就不见了。$",30)--一个人影突然从旁跳了出来，拦住你的去路！
		if l==nil then
		  local b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      self:wait_attacker()
		   end
		    b:jifa()
		   return
		end
		if string.find(l,"只见.*转身几个起落就不见了") then

		    local b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      self:wait_attacker()
		   end
		    b:jifa()
		   return
		end
	end)
end

function shouding:auto_kill()
   world.ColourNote("salmon", "", "启动auto_kill")
   wait.make(function()
   --|^(> |)一个人影突然从旁跳了出来，拦住你的去路！$
      local l,w=wait.regexp("^(> |)(.*)只听「哐」的一声巨响，一名.*破门而入，对你发起猛烈的攻击！$",10)--一个人影突然从旁跳了出来，拦住你的去路！
	  --神秘人恶狠狠地盯着你：臭贼，我看你这次往哪儿跑。
      if l==nil then
	    self:auto_kill()
		return
	  end
	  if string.find(l,"破门而入") then
         --world.ColourNote("salmon", "", w[2].."叫我看你这次往哪儿跑")
	     shutdown()
	     --self.attacker_name=w[2]
	     --self:wait_attacker_escape(w[2])
		 print("战斗开始")
		 self:combat()
	  end
	  wait.time(10)
   end)
end

function shouding:wait_attacker()
   world.Send("unset 积蓄")
   self:auto_kill()
   self:wait_jobDone()
   local b=busy.new()
   b.Next=function()

     self:recover()
   end
   b:check()

end

function shouding:shield()

end

function shouding:recover()


	local h
	h=hp.new()
	h.checkover=function()
	     print(h.neili_limit," 内力  ",h.max_neili)
		 print(h.jingli_limit," 精力 ",h.max_jingli)
        if h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.8
			x.safe_jingxue=h.max_jingxue*0.8
			x.limit=false
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				   world.Send("yun qi")
				   world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,4)
			    end
				if id==777 then
				   self:recover()
				end
			end
			x.success=function(h)

				print("继续修炼")

			   if h.neili_limit<=h.max_neili and h.neili>h.max_neili*1.8 then
			      world.Send("yun jing")
			      x:tuna()
			   else
			      world.Send("yun recover")
			      x:dazuo()
			   end

			end
			x:dazuo()
		elseif h.qi<=h.max_qi*0.8  then
		     world.Send("yun recover")
			 self:recover()
		else
			 local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.8
			x.safe_jingxue=h.max_jingxue*0.8
			x.limit=false
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				   world.Send("yun qi")
				   world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,4)
			    end
				if id==777 then
				   self:recover()
				end
			end
			x.success=function(h)

				print("继续修炼")

			   if h.neili_limit<=h.max_neili and h.neili>h.max_neili*1.8 then
			      world.Send("yun jing")
			      x:tuna()
			   else
			      world.Send("yun recover")
			      x:dazuo()
			   end

			end
			x:dazuo()
		end
	end
	h:check()
end

function shouding:wait_jobDone()
 wait.make(function()
   --|^(> |)一个人影突然从旁跳了出来，拦住你的去路！$
      local l,w=wait.regexp("^(> |)你此次看守共得到.*正神！$|^(> |)看守时限已到，但是你擅离职守，任务失败了！$",60)--一个人影突然从旁跳了出来，拦住你的去路！
	  --神秘人恶狠狠地盯着你：臭贼，我看你这次往哪儿跑。
      if l==nil then
	    self:wait_jobDone()
		return
	  end
	  if string.find(l,"你此次看守共得到") or string.find(l,"但是你擅离职守，任务失败了") then
         --world.ColourNote("salmon", "", w[2].."叫我看你这次往哪儿跑")
	     shutdown()
		  self:jobDone()
		 return
	  end
	  wait.time(10)
   end)
end

function shouding:jobDone()

end
--你还是先去歇息片刻再来吧。

--你此次看守共得到二百二十六点经验，五十八点潜能,六十三点正神！
--只见蒙面大汉转身几个起落就不见了。
