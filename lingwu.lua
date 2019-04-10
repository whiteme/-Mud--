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
	  print("���ȼ�:",self.max_level)
   end
end

function lingwu:set_exps(level,exps)
   local value={}
   value.level=level
   value.exps=exps
   table.insert(self.exps_table,value)
end

function lingwu:get_exps_end()
   --��ü���������
   self:get_max_level()
   self:get_skills()
end

--���������߶�Сʱ��ʮ�ķֶ�ʮ���롣
--����ֵ������4006�㡣
--ÿСʱ���ʣ�һǧ���ٶ�ʮ�㾭�顣
function lingwu:get_exps_add()
   wait.make(function()
    local l,w=wait.regexp("^(> |)����ֵ������(.*)�㡣",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"����ֵ������") then
	      local get_exp=w[2]
		  world.SetVariable("get_exp",get_exp)
	      return
	  end
   end)
end

function lingwu:get_per_exps_add()
   wait.make(function()
      local l,w=wait.regexp("^(> |)ÿСʱ���ʣ�(.*)�㾭�顣",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"ÿСʱ����") then
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
    print(seconds," ��ָ�����!")
	self.seconds=seconds
	--[[lingwu.co=coroutine.create(function()
	   print("ֹͣ���� �ָ�������")
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
       local l,w=wait.regexp("(\\d*)\\s+(\\d*)\\s*\\|\\s*(\\d*)\\s+(\\d*)\\s*\\|\\s*(\\d*)\\s+(\\d*)\\s*\\|\\s*(\\d*)\\s+(\\d*)\\s*\\|\\s*(\\d*)\\s+(\\d*)$|^(> |)����������(.*)��$",10)
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
	   if string.find(l,"����������") then
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
--[[�ȼ��;���������ձ�
433  8062156 | 438  8345345 | 443  8635088 | 448  8931462 | 453  9234540
434  8118273 | 439  8402767 | 444  8693830 | 449  8991539 | 454  9295967
435  8174650 | 440  8460451 | 445  8752838 | 450  9051884 | 455  9357666
436  8231287 | 441  8518400 | 446  8812112 | 451  9112500 | 456  9419637
437  8288185 | 442  8576612 | 447  8871653 | 452  9173385 | 457  9481881
������������Сʱһ����ʮ���롣]]
   self.status=true
   print("��ǰ�������ޣ���")
    world.Send("exp")
	self.exps_table={},
   wait.make(function()
     local l,w=wait.regexp("�ȼ��;���������ձ�",5)
	 if l==nil then
	    self:get_exps()
	    return
	 end
	 if string.find(l,"�ȼ��;���������ձ�") then
	    self:exps_list()
	    return
	 end
   end)
end


function lingwu:get_skill(skill_id)
   -- print("��õȼ�:",skill_id)
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
	skill.name=string.gsub(skill_name,"��","")
    table.insert(self.me_skills,skill)
end

--������⼼�ܵȼ� ��ǰ���ܵȼ�  ֧������ܵȼ�  �ж��ܷ�����

--��û������ܵȼ� ��ǰ���ܵȼ�  ֧������ܵȼ�  �ж��ܷ���

function lingwu:wuxing()
end

--1 �ж��ܷ����� �� ��
function lingwu:ok_lingwu(base_skill,special_skill)
   --print("ok_lingwu:",base_skill," -> ",special_skill)
    local base_level=self:get_skill(base_skill)
	--print("����:",base_level)
	local special_level=self:get_skill(special_skill)
	--print("����:",special_level)
   if base_level<=special_level and base_level<self.max_level then
      return true
   end
   return false
end

function lingwu:ok_lian(base_skill,special_skill)
    --print("ok_lian:",base_skill," -> ",special_skill)
    local base_level=self:get_skill(base_skill)
	--print("����:",base_level)
	local special_level=self:get_skill(special_skill)
	--print("����:",special_level,"  <  ",self.max_level)
	if base_level>special_level and special_level<self.max_level  then
	  --print("��")
	  return true
	else
	  --print("��")
      return false
    end

end

function lingwu:Next() --��һ��ѧϰ����
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

--2 �� -> �ж��Ƿ��� �� ��
--3 �� -> ��һ��

---**************** ��������
function lingwu:lag()
  -- print("lag ��ԭ")
   wait.make(function()
	 local l,w=wait.regexp("^(> |)����ʵս���鲻�㣬�谭����ġ�(.*)��������$|^(> |)���.*���費�����޷��������һ���(.*)��$|^(> |)���ʵս�еõ���Ǳ���Ѿ������ˡ�$|^(> |)��ġ�.*�������ˣ�$",10)
	 if l==nil then

	    --self.continue=true--10s ��ԭ
		self:lag()
		 --print("self continue:",true)
		return
	 end
	 if string.find(l,"������") then
	    self:base_levelup()
		shutdown()
		local f=function() self:start() end
		f_wait(f,self.interval)
	    return
	 end
	  if string.find(l,"����ʵս���鲻��") then
	     shutdown()


		local f=function() self:get_skills() end
		f_wait(f,self.interval)
		return
     end


	 if  string.find(l,"���費��") then
	    shutdown()
		--vip ��Ҫ��ȥ�ر�
		--��ʼ��skill


		 local f=function() self:get_skills() end
		f_wait(f,self.interval)
	    return
	 end
	 if string.find(l,"���ʵս�еõ���Ǳ���Ѿ�������") then
	     --self.continue=true
		 --print("self continue:",true)
         --print("�������һ��"..w[1])
		 shutdown()
		 print("���Ǳ�ܲ���")
		 local f=function() self:finish() end
		 f_wait(f,self.interval)
		 return
     end

	--[[ if string.find(l,"���˼����") then
	    print("self continue:",true)
		self.continue=true--10s ��ԭ
		self:lag()
		return
	 end]]

	wait.time(10)
   end)
end

function lingwu:rest() --Ĭ�Ϻ���
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
			          print("˯��̫Ƶ����!")
			          local ch=hp.new()
			          ch.checkover=function()
			             if ch.pot<10 then
							 self:finish()
						 else
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  ˯��̫Ƶ�� ���� start
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
	                           if id==202 then
			                    --�������
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
							  ---  ˯��̫Ƶ�� ���� end
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
			 rc.teach_skill=teach_skill --config ȫ�ֱ���
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
	local l,w=wait.regexp("^(> |)�������������$|^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)�����ھ�������$",5)
   if l==nil then
	  self:regenerate()
	  return
   end
   if string.find(l,"����") then
	  self:neili_empty()
	 return
   end
   if string.find(l,"���������˼����������������ö���") or string.find(l,"�����ھ�����") then
     self:start()
	 return
   end
   wait.time(5)
   end)
end

function lingwu:lingwu_Execute(cmd,times)
  if self.starttime then  --���ʱ��

		 local t1=os.time()
		 local interval=os.difftime(t1,self.starttime)
		 --print(interval,":��","ʱ����")
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
	    world.Execute("yun regenerate;"..cmds..";set action ����")
	   --world.Execute(cmd)
	   --world.Execute(cmd)
	   --world.Execute(cmd)
	   --world.Execute(cmd)
	   --world.Execute(cmd)
	   --world.Send("set action ����")
	   --self.continue=false
	--   print("flag",false)
	-- else
	--   local f=function() self:Execute(cmd) end
	--   f_wait(f,self.interval)
	--   return
	-- end
	 local l,w=wait.regexp("^(> |)��û�취���о���$|^(> |)��ʽ�� lingwu.*$|^(> |)�趨����������action \\= \\\"����\\\"$",5)

     if l==nil then
	      print("����ʱ")
		  self:lingwu_Execute(cmd,times)
		  --self:try_again(cmd)
		return
     end
	if string.find(l,"��û�취���о���") then
	     --self.continue=true
		 --print("self continue:",true)
         --print("�������һ��"..w[1])
		 --shutdown()
		 print("��û�취���о���")
		 local f=function() self:regenerate() end
		 f_wait(f,self.interval)
		 return
     end

	 if string.find(l,"lingwu") then
	   shutdown()
	   self:go()
	   return
	 end
	 if string.find(l,"�趨����������action") then
	  local f=function()
	   self:lingwu_Execute(cmd,times)
	  end
	  f_wait(f,0.3)
       return
	 end
     --�ȴ�
    wait.time(5)
end)
end


---****************** ���Ĳ��� ********************
function lingwu:neili_lack(callback)
  --print("neili_lack")
   shutdown()
  local f2=function()
    print("��������2")
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
			f=function() x:dazuo() end  --���
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
		  print("��������")
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
	local l,w=wait.regexp("^(> |)�������������$|^(> |)�㳤��������һ������$|^(> |)�����ھ������档$",5)
   if l==nil then
      --self.start_failure(-1)
	  self:refresh(cmd)
	  return
   end
   if string.find(l,"��������") then
	  self:neili_empty()
	 return
   end
   if string.find(l,"�㳤��������һ����") or string.find(l,"�����ھ�������") then
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
  print("��������1")
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
			f=function() x:dazuo() end  --���
			f_wait(f,0.5)
		end
		if id==202 then
	          local w
		      w=walk.new()
		      w.walkover=function()
			     --BigData:catchData(2542,"����")
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
		  print("��������")
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

   wait.make(function() --�㽫һ������̫�絶������������С�
	local l,w=wait.regexp("^(> |)������û������������$|^(> |)��װ��.*��������$|^(> |)��.*����.*���С�$|^(> |)��о�ȫ����Ϣ���ڣ�ԭ������������������װ��.*��$|^(> |)���Ѿ�װ�����ˡ�$|^(> |)��ӻ����ͳ�.*|^(> |)��ӱ���ȡ��.*|^(> |)�㽫.*�������С�$|^(> |)������һ�����к�ӧ������ǹ��ֻ��ǹ��ͻ�����磬�ڿ��е���߶��滨��$|^(> |)�Ѷ��˱��������������α���������ĺ���ӳ�ճ������ϸ��ֳ��������顣$|^(> |)�㡰ৡ���һ����������һ�Ѻ���������ѩ���ֵ���$|^(> |)���੹�Ц����֪����������һ�ѽ���׶�������У�$|^(> |)���੹�Ц������ȴ�ѽ���׶�������ģ�$|^(> |)�㡸ৡ���һ������һ��.*�������С�$|^(> |)����˸��������˶����е���ü����$|^(> |)�㻺�����һ�����������ֻ����â���£�����������֮����$|^(> |)���������һֻ.*$|^(> |)����.*�������е��˵ࡣ$",5)
	 if l==nil then
	    self:wield_weapon_Catch(cmd)
	    return
	 end
	 if string.find(l,"������û����������") then
	    print("��ϰ�¸�")
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
	 if string.find(l,"��о�ȫ����Ϣ����") then
	    self:xiulian()
	    return
	 end
	 --> ���੹�Ц����֪����������һ�ѽ���׶�������У�
	 --�㡰ৡ���һ����������һ�Ѻ���������ѩ���ֵ���
	 if string.find(l,"����") or string.find(l,"���������һֻ") or string.find(l,"�㻺�����һ������������") or string.find(l,"����˸���") or string.find(l,"���") or string.find(l,"����") or string.find(l,"����") or string.find(l,"�Ѷ���") or string.find(l,"װ��") or string.find(l,"��ӻ����ͳ�") or string.find(l,"ȡ��") or string.find(l,"��������") then
         self:lian_Execute(cmd)
		 return
	 end
	 wait.time(5)
	end)
end

function lingwu:wield_weapon_Catch(cmd)



	wait.make(function()

	   local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"װ��\\\"$",5)
	   if l==nil then
	      self:wield_weapon_start(cmd)
	      return
	   end
	   if string.find(l,"�趨����������action") then
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
    world.Send("set action װ��")
	if weapon~=nil then

	      world.Send("wield "..weapon)
	      self.weapon=weapon
          self:wield_weapon_Catch(cmd)
		  return
	end
	print(skillname," ���ݼ��������ж�ʹ�õ�����!!")
	if string.find(skillname,"sword") then
		world.Send("wield jian")
		world.Send("wield xiao")
		world.Send("wield sword")
		self.weapon="sword"
	elseif string.find(skillname,"blade") then
	   if special_skill=="wuhu-duanmendao" then
	      --�鿴�Ƿ�Я���ؼ�
		  --һ���廢���ŵ��ؼ�(Wuhuduanmendao miji)
		   local sp2=special_item.new()
		   sp2.cooldown=function()
		       for _,i in ipairs(sp.equipment_items) do
		        if string.find(i.name,"�廢���ŵ��ؼ�") then
				 local f=function()
		          self:get_skills()
		         end
	             process.readbook("read wuhuduanmendao miji",f)
				 return
				end
			   end
			    print("û���ؼ�")
			   world.Send("wield dao")
			   world.Send("wield wan dao")
		       world.Send("wield blade")
		       self.weapon="blade"
			   self:wield_weapon_Catch(cmd)
		   end
		   sp2:check_items("�廢���ŵ��ؼ�")
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
--��ġ����ǹ���������ˣ�
--��Ļ��������δ���������ȴ�û������ܼ�����ߡ�
--����������������������ڴ���ӡ��
--���������һ�����Ӳ������޷���
function lingwu:lian_Execute(cmd,callback)
  if self.starttime then  --���ʱ��

		 local t1=os.time()
		 local interval=os.difftime(t1,self.starttime)
		 --print(interval,":��","ʱ����")
	if 	interval>self.seconds then
       self:reset()
	   return
	end
  end
  wait.make(function()
	 world.Execute(cmd) --�������̫���ˣ��������������� ��ľ���̫���ˣ��޷���ϰ��ɽ���� �����ڵľ���̫���ˣ�������ϰ��ɽ������ϰ����ɨҶ�ȱ����б̺���������ϡ�
	 local l,w=wait.regexp("(> |)�������������.*$|^(> |)�������̫���ˣ��������嶾���ܲ���$|^(> |)�������̫���ˡ�$|^(> |)��ľ���̫���ˣ�������.*��|^(> |)�������������.*|^(> |)�������������$|^(> |)�����������.*��$|^(> |)�������̫���ˡ�$|^(> |)�������̫���ˣ�������.*��$|^(> |)��ľ���̫���ˡ�$|^(> |)�����ڵ���Ϊ���������.*$|^(> |)��ʹ�õ��������ԡ�$|^(> |)����ʵս���鲻�㣬�谭�����.*������$|^(> |)(��|ѧϰ|ѧ).*�����.*$|^(> |)ѧ.*ʱ���ﲻ����������$|^(> |)���ַ�����.*$|^(> |)��ġ�.*�������ˣ�$|^(> |)����ʱ�޷���.*��$|^(> |)�����Ϣһ���ˣ��Ȼ�����.*��$|^(> |)���޷���������������$|^(> |)���Ҳ�����������Ӱ�������Ϣ��$|^(> |)����Ъ���������ɡ�$|^(> |)������.*��$|^(> |)�����ϵ���������������.*��$|^(> |)��ľ���������.*$|^(> |)�������б�����.*$|^(> |)�����������.*$|^(> |)������ڵ���������,�޷�������.*$|^(> |)��ľ���̫���ˣ��޷���ϰ.*$|^(> |).*������֡�$|^(> |)�����ڵľ���̫���ˣ�������ϰ.*��$|^(> |)�������Ŀǰû�а취��ϰ.*��$|^(> |)��û��ʹ�õ�����.*$|^(> |)���Ⱦۼ�����������.*$|^(> |)��Ļ��������δ���������ȴ�û������ܼ�����ߡ�$|^(> |)��.*����֡�$|^(> |)��ϰ.*�����б̺���������ϡ�$|^(> |)������ý������ܽ�һ����ϰ���߽�����$|^(> |)���廢���ŵ�����ѧֻ�ܴ��ؼ�������$|^(> |)�㷴����ϰ�����ָ������˲��ٽ�����$|^(> |)��̫���ˡ�$|^(> |)�����ʹ�ý��߽����ܽ�һ����ϰ��Ľ��߽�����$|^(> |)����ɽ�����Ʊ�����ơ�$|^(> |)�������������������.*$|^(> |)����ϰ�����ϴ����Ʒ���ȴ�е�����̫���Ծ���$|^(> |)��̫���ˣ�Ъ���������ɡ�$|^(> |)�������̫���ˣ�Ъ���������ɡ�$|^(> |)���������һ�����Ӳ������޷���$",1.5)
     if l==nil then
		    self:lian_Execute(cmd,callback)
		return
     end
	 --�����ڵ���Ϊ��������̺߱��������ˡ�
	if string.find(l,"�㷴����ϰ�����ָ������˲��ٽ���") then
	    print("�������ָ")
	    callback()
	    return
	end
	if string.find(l,"����ʵս���鲻��") or string.find(l,"��Ļ��������δ���������ȴ�û������ܼ������") then
	  	local f=function() self:get_skills() end
        print "����ʵս���鲻��,�����ж�skill"
		f_wait(f,self.interval)
		return
	 end
	 --[[
	  if string.find(l,"�������������") then
	     world.Send("unset ����")
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
	 if string.find(l,"�����ڵ���Ϊ���������") then  --�����ڵ���Ϊ��������߾����񹦡�
	 --�������� or pot����
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
    --[[ if string.find(l,"����˲��ٽ���") then
	    local f=function() self:start_success() end
        --print "�ɹ�"
		f_wait(f,self.interval)
		return
     end]]
	 if string.find(l,"������") then
	    --world.("lingwu_end","false")
		--self.levelup=true
		print("*******************�ȼ�������������***********************")
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
             print "�����ж�skill"
	     	 f_wait(f,self.interval)
		 end
	    return
	 end
    if string.find(l,"ȴ�е�����̫���Ծ�") or string.find(l,"������ý�") or string.find(l,"�����ʹ�ý��߽�") or string.find(l,"��ʹ�õ���������") or string.find(l,"����ʱ�޷���") or string.find(l,"�����ϵ�����") or string.find(l,"��û��ʹ�õ�����") or string.find(l,"һ������") then
		self:wield_weapon(cmd)
		return
     end--����̫�� > �������̫���ˡ�
	 if string.find(l,"�������̫����") or string.find(l,"�������̫����") or string.find(l,"�����������") then
	    world.Send("yun qi")
	    self:refresh(cmd)
	   return
	 end
     if string.find(l,"��̫����") or string.find(l,"����̫����") or string.find(l,"��ľ���̫����") or string.find(l,"�������̫����") or string.find(l,"�����������") or string.find(l,"�������̫����") or string.find(l,"�����Ϣһ����") or string.find(l,"Ъ����") or string.find(l,"��ľ�������") or string.find(l,"�������Ŀǰû�а취��ϰ") or string.find(l,"��̫����") then
	   self:refresh(cmd)
	   return
	 end
	 if string.find(l,"�������̫����") or string.find(l,"�������������������") or string.find(l,"�������������") or string.find(l,"�����������") or string.find(l,"������ڵ���������") or string.find(l,"���Ⱦۼ�����������") then
	   local f=function() self:get_skills() end
	   self:neili_lack(f)
	   return
	 end
	 if string.find(l,"���޷�������������") or string.find(l,"���Ҳ�����������Ӱ�������Ϣ") then
	   print("�޷���ϰ����")
	   self:move(cmd)
	   return
	 end
	 if string.find(l,"��ϰ.*�����б̺����������") then
	    world.Send("jifa force bihai-chaosheng")
		self:lian_Execute(cmd)
	    return
	 end
	 if string.find(l,"�廢���ŵ�") then
	    local f=function()
		  self:get_skills()
		end
	    process.readbook("read miji",f)

	    return
	 end

     if string.find(l,"����") or string.find(l,"����") or string.find(l,"����������") or string.find(l,"������") or string.find(l,"�������б���")  then
	    local sp=special_item.new()
		sp.cooldown=function()
		  self:lian_Execute(cmd)
		end
		sp:unwield_all()
	    return
	 end
     --�ȴ�
    wait.time(1.5)
	--print("����")
end)
end

function lingwu:lingwu_dzxy(cmd)
  wait.make(function()
    world.Send(cmd)
    local l,w=wait.regexp("^(> |)��.*��ڤڤ֮����Ķ�ת�����ֽ���һ����$|^(> |)����������һЩ��ʵս�����ö�ת���Ƶļ��ɡ�$|^(> |)�������������$|^(> |)���������죬̫����������У����ƶ�䣬����˳���Ʋ�ı�Ե���������������Щ���ۡ�$|^(> |)��Ҫ��ʲô��$|^(> |)������ֻ����˰��죬���������˵�Ѿ�̫ǳ�ˣ�ʲô��û��ѧ����$",5)
     if l==nil then
	   self:lingwu_dzxy(cmd)
	   return
	 end
	 if string.find(l,"ڤڤ֮����Ķ�ת�����ֽ���һ��") or string.find(l,"����������һЩ��ʵս�����ö�ת���Ƶļ���") then
	   local f=function()
	     world.Send("yun jing")
	     self:lingwu_dzxy(cmd)
	   end
	   f_wait(f,0.3)
	   return
	 end
	 if string.find(l,"�����������") then
		  local f=function()
		     self:lingwu_dzxy(cmd)
		  end
         self:neili_lack(f)
	   return
	 end
	 if string.find(l,"���������죬̫����������У����ƶ�䣬����˳���Ʋ�ı�Ե���������������Щ����") then
		print("��ϰ�¸�")
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
	 if string.find(l,"������ֻ����˰��죬���������˵�Ѿ�̫ǳ�ˣ�ʲô��û��ѧ��") then
	    self:douzhuan_xingyi2()
	    return
	 end
	 if string.find(l,"��Ҫ��ʲô") then
	    self:douzhuan_xingyi3()
	    return
	 end
	 wait.time(5)
  end)
end

function lingwu:douzhuan_xingyi()  --����ת
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("lingwu zihua")
   end
   w:go(2756)
end

function lingwu:douzhuan_xingyi2()  --����ת
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("lingwu miji")
   end
   w:go(2846)
end

function lingwu:douzhuan_xingyi3()  --����ת
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
    local l,w=wait.regexp("^(> |)����ʵս���鲻�㣬�谭����ġ����¾Ž���������$|^(> |)�����ڵ�Ǳ�ܲ�����������¾Ž���$|^(> |)�������������$",0.8)
     if l==nil then
	   self:lingwu_jiujian(cmd)
	   return
	 end
	 if string.find(l,"�����ڵ�Ǳ�ܲ�����������¾Ž�") or string.find(l,"����ʵս���鲻��")  then
	    self:finish()
	    return
	 end
	 if string.find(l,"�����������") then
		  local f=function()
		     self:lingwu_jiujian(cmd)
		   end
          self:neili_lack(f)
	   return
	 end
	 wait.time(2)
  end)
end

function lingwu:dugu_jiujian()  --������¾Ž�
  local w=walk.new()
   w.walkover=function()
      self:lingwu_jiujian("lingwu dugu-jiujian")
   end
   w:go(4985)
end

function lingwu:getdzxytime()
  wait.make(function()
      world.Send("time")
	  local l,w=wait.regexp("^(> |)�������齣(.*)��(.*)��(.*)��(.*)ʱ(.*)��$",15)
	  if l==nil then
	    print("��ʱ:")--��
	    return
	  end
	  if string.find(l,"�������齣") then
	    --print(w[2],w[3],w[4],w[5],w[6])
	    local hour=w[5]
	    --print(hour)
	    local mins=w[6]
	     --print(mins)
	    if hour=="��" or hour=="��" or hour=="��" then
	      print("����ȥ������")
		  self:douzhuan_xingyi3()
	    else
	      print("�����޷�������")
		  print("��ϰ�¸�")
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
	  local l,w=wait.regexp("^(> |)�������齣(.*)��(.*)��(.*)��(.*)ʱ(.*)��$",15)
	  if l==nil then
	    print("��ʱ:")--��
	    return
	  end
	  if string.find(l,"�������齣") then
	    --print(w[2],w[3],w[4],w[5],w[6])
	    local hour=w[5]
	    --print(hour)
	    local mins=w[6]
	     --print(mins)
	    if hour=="��" or hour=="��" or hour=="��" or hour=="î" or hour=="��" or hour=="��" or hour=="��" then
	        print("�����޷���ɽ��")
		  print("��ϰ�¸�")
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
  --�´���
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
     print("��ʼ�ֽ�Ǭ����Ų��")
	 local taojiao={}
	  taojiao=learn.new()
	  taojiao.timeout=1.2
	  sj.World_Init=function()
          taojiao:go()
      end
	   taojiao.master_place=tonumber(trim(master_place)) --ʦ�������
       taojiao.masterid= masterid  --ʦ��id
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
		   if error_id==2 then  --û���ҵ�ʦ��
			  local f=function() taojiao:go() end
			  f_wait(f,5)
		   end
		   if error_id==102 or error_id==1 or error_id==201 or error_id==301 then  --Ǳ������ �������� �� ��Խʦ�� ����������
	           print("��ϰ�¸�")
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
			  print("��������:",taojiao.weapon)

			end

			if error_id==401 then
			   taojiao:regenerate()
			end
			if error_id==402 then  --��������
			  shutdown()
			  local exps=world.GetVariable("exps")
			  if tonumber(exps)>800000 then
			     taojiao:xiulian()
			  else
                 taojiao:rest()
			  end
			end
			if error_id==403 then  --����ת����Ѫ ����ѧϰ
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
function lingwu:start() --��ʼѧϰ

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


	    if self.run_vip==true and level>400 then  --��ʱ��ر�vip
		  self:vip_close()
		  return
		end
	    self:wuxing()

		if base_skill=="hand" or base_skill=="cuff" or base_skill=="strike" or base_skill=="claw" or base_skill=="finger" or base_skill=="leg" then
			  world.Send("bei none")
			  world.Send("jifa "..base_skill.." "..special_skill)
			  world.Send("bei "..base_skill)
		    if special_skill=="wuxiang-zhi" then

			    print("�����ָ")
				local special=self:get_skill("wuxiang-zhi")
				if special<=200 then
				    self:wxjz() --�����Լ���
				else
				    self:wxjz2()
				end
				return
			end
		elseif base_skill=="parry" then
			if special_skill=="douzhuan-xingyi" then
			      print("����ת����")
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
				  print("�ֽ�Ǭ����Ų��")
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
--Ŀ�귿��: 2540  GO!!!!
function lingwu:go() --go ����

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
	if self.vip==true and self.run_vip==false and (self:ok_lingwu(base_skill,special_skill)==true or i==1) then --��vip vip û���� (�������� or ��һ��)
	   self:vip_start()
	elseif self:ok_lian(base_skill,special_skill)==true then
		self:start()
	else
	  local place
	  place=self.lingwu_place
	  local w
	  w=walk.new()
	  w.walkover=function()
	   print("����ʼ")
	   --self.start()
	   --BigData:catchData(2540,"��ĦԺ��Ժ")
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
          world.Send("ask ying gu about �������")
		  local l,w=wait.regexp("^(> |)����˵�������㱾�ܻ�����ʹ�ù������(.*)�����ڿ�ʼ��ʱ�ˡ���$|(> |)�Բ��𰡣�Ŀǰ�������ֻ�Թ��VIP�û�����ǿ��ѧϰ���ܡ�$|(> |)�㲻��������ϰ�������������ô���������ץ��ʱ�䡭��$|^(> |)����˵����������Ȼ���ʴϻۣ�����̰������ã�������ð���ˣ�����������ѯ�ʰɡ���$",10)
		  if l==nil then
            local f=function() self:vip_start() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"���ڿ�ʼ��ʱ��") or string.find(l,"�㲻��������ϰ�������������ô") then
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
		  if string.find(l,"�������ֻ�Թ��VIP�û�����") or string.find(l,"����Ȼ���ʴϻۣ�����̰������ã�������ð���ˣ�����������ѯ�ʰ�") then
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
	  world.Send("ask ying gu about ����")

	   local l,w=wait.regexp("^(> |)�������ô����йء�����������Ϣ��$",3)
		  if l==nil then
            self:vip_end()
	        return
          end
		  if string.find(l,"�������ô����йء�����������Ϣ") then
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
	  world.Send("ask ying gu about ����")

	   local l,w=wait.regexp("^(> |)�������ô����йء�����������Ϣ��$",3)
		  if l==nil then
            self:vip_close()
	        return
          end
		  if string.find(l,"�������ô����йء�����������Ϣ") then
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
   ---��ʼ����

   	 local st=status_win.new()
     st:init(nil,self,nil)
	 st:skill_draw_win()
	 --��Ҫ�ж��Ƿ�ȫ��������
    for _,skill in ipairs(self.skills) do
       local base_skill=skill.base_skill
	   local special_skill=skill.special_skill
	    if self:ok_lingwu(base_skill,special_skill)==true or self:ok_lian(base_skill,special_skill)==true then
		  print("�ܹ�����")
		  self:go()  --�ܹ�����
		  return
		end
	end
	--���ж�����
	self:finish()

end

function lingwu:skills_level()
  wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)\\((.*)\\).*\\s+(\\d*)\\/\\s*(\\d*)$|^(> |)�趨����������cha \\= \\\"YES\\\"$",5)
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
	 if string.find(l,"�趨����������cha") then
	    self:get_skills_end()
		return
	 end
  end)
end

function lingwu:get_skills()
  --[[ ��Ŀǰѧ����ʮ���ּ��ܣ�

  �̺�������   (bihai-chaosheng)           - �񹦸��� 427/127038
  �ɿ���     (caikuang)                  - ��������  62/   900
  �����Ṧ     (dodge)                     - ������˫ 434/  3504
  ���켼��     (duanzao)                   - �ڻ��ͨ 130/  5632
  ����ָ��     (finger)                    - ������� 408/108825
  �����ڹ�     (force)                     - �������� 446/109230
  �����ַ�     (hand)                      - ������� 408/ 95858
  ���߽���     (jinshe-jianfa)             - ����С�� 157/ 12322
  ����������   (jinshe-zhangfa)            - ƽƽ���� 101/  6860
��������Ѩ��   (lanhua-shou)               - ������� 410/ 84460
  �����ȷ�     (leg)                       - ��ͬ���� 348/ 60901
  ����д��     (literate)                  - ������ 249/ 31250
����Ӣ����   (luoying-zhang)             - ��ͬ���� 350/ 61600
  ��������     (medicine)                  - ����С�� 119/   247
  �����м�     (parry)                     - ��ͬ���� 350/ 12902
  ���Ű���     (qimen-bagua)               - ���д�� 197/     0
  ���Ű�����   (qimen-baguazhen)           - ����һ��   2/     5
�����վ�       (shenzhao-jing)             - �������� 446/ 99904
  �����Ʒ�     (strike)                    - ��ͬ���� 347/ 60552
���沨����     (suibo-zhuliu)              - ������˫ 434/ 94612
  ��������     (sword)                     - �������� 388/ 32057
  ��ʬ����     (tangshi-jianfa)            - ����ǿǿ  53/  1662
����ָ��ͨ     (tanzhi-shentong)           - ������� 410/ 84473
  ��ѧ�ķ�     (taoism)                    - ���д�� 197/ 19602
  ��������     (throwing)                  - ������� 407/ 31216
  �ּۻ���     (trade)                     - ��֪һ��  43/  1801
������ɨҶ��   (xuanfeng-tui)              - ��ͬ���� 350/ 61600
�����｣��     (yuxiao-jian)               - �������� 390/ 76448]]

  -- ^(> |).*"..item.skill_id..".*\\s+(\\d*)\\/\\s*(\\d*)
   --[[for _,i in ipairs(self.skills) do
   --ɾ���ظ�����
       self:set_special_skill(i.special_skill)
	   self.set_base_skill(i.base_skill)
   end]]
   self.me_skills={}
   world.Send("cha")
   world.Send("set cha")
   world.Send("unset cha")
   wait.make(function()
      local l,w=wait.regexp("��Ŀǰѧ��.*�ּ��ܣ�$|^(> |)��Ŀǰѧ��.*�ּ���.*$",5)
	  if l==nil then
	     self:get_skills()
	     return
	  end
	  if string.find(l,"��Ŀǰѧ��") then
	     self:skills_level()
	     return
	  end
   end)
end

function lingwu:finish()
    --print("vip״̬:",self.vip)
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

function lingwu:AfterFinish() --�ص�����

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
	       if error_id==2 then  --û���ҵ�ʦ��
			  l_learn:go()
		   end
		   if error_id==102 then  --Ǳ������
		       self:finish()
		   end
		   if error_id==1 or error_id==201 then  --�������� �� ��Խʦ��
			  local is_ok=l_learn:Next()
				if is_ok==true then  --���к�ѡ��
				  l_learn:start()
				else
				  self:wxjz_cave()
				end
			end
			if error_id==401 then
			   l_learn:regenerate()
			end
			if error_id==402 then  --��������
			  l_learn:rest()
			end
			if error_id==403 then  --����ת����Ѫ ����ѧϰ
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
			          print("˯��̫Ƶ����!")
			          local ch=hp.new()
			          ch.checkover=function()
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  ˯��̫Ƶ�� ���� start
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
								if id==202 then --safe room û�а취����
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
							  ---  ˯��̫Ƶ�� ���� end
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
      world.Execute("#10 bo ľм")
      --world.Send("bo ľм")
      --world.Send("bo ľм")
      --world.Send("bo ľм")
      --world.Send("bo ľм")
	  world.Send("yun refresh")
      --��˫�����䣬�����ľ������ϵ���ľмͻȻ������Ծ����������������һ�����ε�ϸ����������һ�㡣
	  local l,w=wait.regexp("^(> |)��о��Ѿ��޷�����������ľм����Լ������ָ����Ϊ�ˡ�$|^(> |)������һ�󣬲�������������Щ���ҡ�$|^(> |)�������������$|^(> |)���Ȼ������Щ��˼����������վ��������$|^(> |)���ķ����ң��������ĵ�����һ��ɱ����$",1)
	  if l==nil then
		  self:wxjz_bomuxie()
		  return
	  end
	  if string.find(l,"��������������Щ����") or string.find(l,"���Ȼ������Щ��˼����") or string.find(l,"���ķ�����") then
	     self:wxjz_buddhism()
		 return
	  end
	  if string.find(l,"��о��Ѿ��޷���������") then
	     self:finish()
	     return
	  end
	  if string.find(l,"�����������") then
	     self.go=function()  --�滻Ĭ�� go ����
		     --���Ժ�
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
		 print("��鸺��")
		  if sp.weight>50 then
			print("���ع��أ�")
			print("��ϰ�¸�")
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
	      Get_items(f)  --��������Ʒ���� ���� ���� ��֤������50%����
       end
       local equip={}
	   equip=Split("<��ȡ>�ӹ�","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)

end

function lingwu:wxjz2()
    local sp=special_item.new()
       sp.cooldown=function()
	      print("��鸺��")
		  if sp.weight>50 then
			print("���ع��أ�")
			print("��ϰ�¸�")
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
	      Get_items(f)  --��������Ʒ���� ���� ���� ��֤������50%����
       end
       local equip={}
	   equip=Split("<��ȡ>�ӹ�","|")
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
			 world.Send("ask wuxiang about ��")
			 local l,w=wait.regexp("^(> |)������ʦ˵��������ʦ�𷨾���Ļ��ȱ�����Ŀǰʵ��û��ʲô���Խ���ġ���$|^(> |)������ʦ˵���������Ǳ�ܲ����ˡ���$|^(> |)��������ã���������$",5)
			 if l==nil then
			     self:wxjz_buddhism2()
			     return
			 end
			 if string.find(l,"��Ŀǰʵ��û��ʲô���Խ����") then
			    local f=function()
				   self:wxjz_buddhism2()
				end
			    cmd="lian finger"
		        self:lian_Execute(cmd,f)
			    return
			 end
			 if string.find(l,"���Ǳ�ܲ�����") then
			    self:finish()
			    return
			 end
			 if string.find(l,"��������ã���������") then
			    self:wxjz_buddhism2()
				 --���Ժ�

			    return
			 end
		  end
		  w:go(4055)
	end
	xiulian_Status_Check(f) --�����ˮʳ��
end
