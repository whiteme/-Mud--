--�䵱�ض�
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
	           task_name="�ض�",
	           task_stepname="�ض�",
	           task_step=1,
	           task_maxsteps=1,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    self:shield()
	--CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ѩɽ����:������ʼ!", "yellow", "black") -- yellow on white

       local w
        w=walk.new()
	    w.walkover=function()
        wait.make(function()
        world.Send("kanshou")
		local l,w=wait.regexp("^(> |)���뿴��ͭ����¯��$|^(> |)�㻹����ȥЪϢƬ�������ɡ�$",5)
		if l==nil then
		   self:kanshou()
		   return
		end
		if string.find(l,"���뿴��ͭ����¯") then
		   self:wait_attacker()
 		   return
		end
		if string.find(l,"�㻹����ȥЪϢƬ��������") then
		   self:jobDone()
		   return
		end

	  end)
     end
     w:go(2984)
end

function shouding:combat()
    print("Ĭ��ս����ʼ")
	shutdown()
	world.Execute("halt;halt;halt;halt")
	wait.make(function()
	    local l,w=wait.regexp("^(> |)ֻ��.*ת��������Ͳ����ˡ�$",30)--һ����ӰͻȻ�������˳�������ס���ȥ·��
		if l==nil then
		  local b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      self:wait_attacker()
		   end
		    b:jifa()
		   return
		end
		if string.find(l,"ֻ��.*ת��������Ͳ�����") then

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
   world.ColourNote("salmon", "", "����auto_kill")
   wait.make(function()
   --|^(> |)һ����ӰͻȻ�������˳�������ס���ȥ·��$
      local l,w=wait.regexp("^(> |)(.*)ֻ�����ѡ���һ�����죬һ��.*���Ŷ��룬���㷢�����ҵĹ�����$",10)--һ����ӰͻȻ�������˳�������ס���ȥ·��
	  --�����˶�ݺݵض����㣺�������ҿ���������Ķ��ܡ�
      if l==nil then
	    self:auto_kill()
		return
	  end
	  if string.find(l,"���Ŷ���") then
         --world.ColourNote("salmon", "", w[2].."���ҿ���������Ķ���")
	     shutdown()
	     --self.attacker_name=w[2]
	     --self:wait_attacker_escape(w[2])
		 print("ս����ʼ")
		 self:combat()
	  end
	  wait.time(10)
   end)
end

function shouding:wait_attacker()
   world.Send("unset ����")
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
	     print(h.neili_limit," ����  ",h.max_neili)
		 print(h.jingli_limit," ���� ",h.max_jingli)
        if h.qi_percent<100 then
			print("��ͨ����")
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
		          f=function() x:dazuo() end  --���
				  f_wait(f,4)
			    end
				if id==777 then
				   self:recover()
				end
			end
			x.success=function(h)

				print("��������")

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
		          f=function() x:dazuo() end  --���
				  f_wait(f,4)
			    end
				if id==777 then
				   self:recover()
				end
			end
			x.success=function(h)

				print("��������")

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
   --|^(> |)һ����ӰͻȻ�������˳�������ס���ȥ·��$
      local l,w=wait.regexp("^(> |)��˴ο��ع��õ�.*����$|^(> |)����ʱ���ѵ�������������ְ�أ�����ʧ���ˣ�$",60)--һ����ӰͻȻ�������˳�������ס���ȥ·��
	  --�����˶�ݺݵض����㣺�������ҿ���������Ķ��ܡ�
      if l==nil then
	    self:wait_jobDone()
		return
	  end
	  if string.find(l,"��˴ο��ع��õ�") or string.find(l,"����������ְ�أ�����ʧ����") then
         --world.ColourNote("salmon", "", w[2].."���ҿ���������Ķ���")
	     shutdown()
		  self:jobDone()
		 return
	  end
	  wait.time(10)
   end)
end

function shouding:jobDone()

end
--�㻹����ȥЪϢƬ�������ɡ�

--��˴ο��ع��õ����ٶ�ʮ���㾭�飬��ʮ�˵�Ǳ��,��ʮ��������
--ֻ�������ת��������Ͳ����ˡ�
