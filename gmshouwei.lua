--ȫ��մ�����
--��־ƽ�������С��˵�����������Ѿ����ˣ��˴�����Ϯ��������������ǹ���ֹ���������
--��־ƽҪ��ȥɱ����ֹ,�����Ը�������(answer yes ),��Ը�������(answer no)��
gmshouwei={
  new=function()
    local gm={}
	  setmetatable(gm,{__index=gmshouwei})
	 return gm
  end,
  neili_upper=1.8,
  version=1.8,
}
--��־ƽ˵����������,����һ������û����ء���
function gmshouwei:catch_place()
   local player_name=world.GetVariable("player_name") or ""
   wait.make(function()

      local l,w=wait.regexp("^(> |)��־ƽ˵�������ҿ�����������ȥ����Ĺ�ıؾ�֮·��"..player_name.."�����������Ķ����Է��������˵��ҡ���$|^(> |)��־ƽ˵�������Ҳ�������ȥɱ.*��ô������ô����ȥ��!��$|^(> |)��־ƽ˵������"..player_name..",��ս���������Ĺ����������Ϣһ��ɡ���$|^(> |)��־ƽ˵������"..player_name..",����һ������û����ء���$",10)
	  if l==nil then
	     self:ask_job()
	     return
	  end
	  if string.find(l,"����������ȥ����Ĺ�ıؾ�֮·") then
	    local b=busy.new()
		b.Next=function()
	     self:zhongtian()
		end
		b:check()
	     return
	  end
	  if string.find(l,"��ս���������Ĺ") then
	    local b=busy.new()
		b.Next=function()
	     self:jobDone()
		end
		b:check()
	    return
	  end

	  if string.find(l,"�Ҳ�������ȥɱ") or string.find(l,"����һ������û�����") then
	   local b=busy.new()
		b.Next=function()
	     self:giveup()
		end
		b:check()

	     return
	  end
   end)
end
--Զ������һ��Ų�������������,�����в��������ڸ�����
--��־ƽ˵�������ҿ�����������ȥ����Ĺ�ıؾ�֮·�����������������Ķ����Է��������˵��ҡ���
function gmshouwei:ask_job()
   local w=walk.new()
    w.walkover=function()
	   world.Send("ask yin about ������Ĺ")
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
--һ��������Ҫ׷�õ������˻����Ƶ����˹����������ڴ��������������㷢�����ҵĹ�����
--��ϲ�㣡��ɹ��������������Ĺ�����㱻�����ˣ�
--�����ˡ�ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
function gmshouwei:combat()



end

function gmshouwei:giveup()
   local w=walk.new()
   w.walkover=function()
       world.Send("ask yin about ����")
	   local f=function()
	      self:ask_job()
	   end
	   f_wait(f,2)
   end
   w:go(4121)
end

function gmshouwei:auto_wield_weapon(f,error_deal)
--�㽫�����������������С��㡸ৡ���һ�����һ�������������С�

   wait.make(function()
	 local l,w=wait.regexp("(.*)\\((.*)\\)$|^(> |)�趨����������action \\= \\\"��ͷ\\\"$",5)
    if l==nil then
	   --self:auto_wield_weapon(f,error_deal)
	   self:qie_corpse()
	   return
	end
	if string.find(l,")") then
	   --print("auto_wield_weapon",w[1],w[2])
	   local item_name=w[1]
	   local item_id=string.lower(w[2])
      if (string.find(item_id,"sword") or string.find(item_id,"jian")) and string.find(item_name,"��") then
         world.Send("wield "..item_id)
		  self.weapon_exist=true
      elseif (string.find(item_id,"axe") or string.find(item_id,"fu")) and string.find(item_name,"��") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"blade") or string.find(item_id,"dao")) and string.find(item_name,"��") or string.find(item_id,"xue sui") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"dagger") or string.find(item_id,"bishou")) and string.find(item_name,"ذ") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
	  end
	  self:auto_wield_weapon(f,error_deal)
	  return
	end
    if string.find(l,"�趨����������action") then
	  --print(self.weapon_exits,"ֵ")
	   if self.weapon_exist==true then
	      f()
	   else
	     print("û�к�������!!�����鹺������!")
         error_deal()
	   end

	   return
	end
	wait.time(5)
   end)
end

function gmshouwei:give_head()
local ts={
	           task_name="ȫ����Ĺ����",
	           task_stepname="����",
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
	   world.Send("set action ����")
	   self:reward()
	end
	w:go(4121)
end

function gmshouwei:get_corpse(index)
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
--   �㽫˾ͽͬ��ʬ������������ڱ��ϡ�
--   �㸽��û������������
      if index==nil then
	     index=1
		  world.Send("get corpse")
	  else
		  world.Send("get corpse "..index)
	  end

	   local l,w=wait.regexp("^(> |)�㽫(.*)��ʬ������������ڱ��ϡ�$|^(> |)�㸽��û������������$|^(> |)���컯�յ������ٰ���$",3)
	   if l==nil then
	      self:get_corpse(index)
	      return
	   end
	   if string.find(l,"������") then
	       wait.time(0.5)
		   index=index+1
	       self:get_corpse(index)
	       return
	   end
	   if string.find(l,"��ʬ������������ڱ��ϡ�") then
		  self:give_head()
		  return
	   end
	   if string.find(l,"�㸽��û����������") then
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


   local l,w=wait.regexp("ֻ�����ǡ���һ�����㽫.*���׼�ն���������������С�|^(> |)���б���ɱ���˸��ﰡ��$|^(> |)�Ǿ�ʬ���Ѿ�û���׼��ˡ�$|^(> |)���Ҳ��� corpse ����������$|^(> |)�Ҳ������������$|(> |)��������������޷����У������������ʬ���ͷ����$|^(> |)����ü����������߲���������ʬ���ͷ����$|^(> |)����ɣ���Զ����ʬ��Ҳ����Ȥ��$",5)
   if l==nil then
      self:qie_corpse()
	  return
   end
   if string.find(l,"���б���ɱ���˸��ﰡ") or string.find(l,"�Ǿ�ʬ���Ѿ�û���׼���") or string.find(l,"��Զ����ʬ��Ҳ����Ȥ") then
      if index==nil then
	     index=2
	  else
	     index=index+1
	  end
      self:qie_corpse(index)
      return
   end
   if string.find(l,"�׼�ն����������������") then
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
   if string.find(l,"�Ҳ���") then
       local sp=special_item.new()
	   sp.cooldown=function()
         self:giveup()
	   end
	   sp:unwield_all()
      return
   end
    if string.find(l,"��������������޷����У������������ʬ���ͷ��") or string.find(l,"����ü����������߲���������ʬ���ͷ��") then
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
		  world.Send("set action ��ͷ")
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
    --������ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
end

--��ϲ�㣡��ɹ��������������Ĺ�����㱻�����ˣ�
--�����־ƽ���˵�ͷ��˵��������Ȼ�ǹ���ֹ�⹷�����ģ��Ǿ�ɱ�������ˣ���
--��־ƽ(Yin zhiping)�����㣺����ֹ��δ�뿪ȫ����������ʯ�׸���һ���!

--��־ƽ������ֻ�а�������ɱ�˲��ܳ�����ֹ���Ƕ��������ɧ�ţ���

--ʯ�� 4129

function gmshouwei:checkNPC(npc,roomno)

      --thread_monitor("huashan:checkNPC",f,{npc,roomno})
    wait.make(function()
      world.Execute("look;set action �˶����")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������action \\= \\\"�˶����\\\"",2)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"�趨����������action") then
	      --û���ҵ�
		  --

		  return
	  end
	  --[[if string.find(l,"��ʬ��") then
	     self:robber_die()
	     return
	  end]]
	  if string.find(l,npc) then
	     --�ҵ�
		  local id=string.lower(Trim(w[2]))
  	local ts={
	           task_name="ȫ����Ĺ����",
	           task_stepname="ս��"..npc,
	           task_step=5,
	           task_maxsteps=5,
	           task_location=roomno,
	           task_description="������",
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
	           task_name="ȫ����Ĺ����",
	           task_stepname="����"..location,
	           task_step=4,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="Ѱ�� "..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local roomno=0

    if location=="ʯ��" then
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
--��־ƽ�Թ�������˵�������������δ�뿪ȫ����������ʯ�׸���һ���!��
--��־ƽ�Թ�������˵�������������δ�뿪ȫ����������ʯ�׸���һ���!��
--��־ƽ(Yin zhiping)�����㣺����ֹ��δ�뿪ȫ����������ʯ�׸���һ���!

function gmshouwei:sec_attack()
     local player_name=world.GetVariable("player_name") or ""
     wait.make(function()
	    local l,w=wait.regexp("^(> |)��־ƽ\\(Yin zhiping\\)�����㣺(.*)��δ�뿪ȫ����������(.*)����һ���!$|^(> |)��־ƽ��"..player_name.."����˵������(.*)��δ�뿪ȫ����������(.*)����һ���!��$",5)

		if l==nil then
			self:sec_attack()
		   return
		end
		if string.find(l,"����˵��") then
		   local name=w[5]
		   local place=w[6]
          print(name,place)
		     self:escape(place,name)
		   return
		end
		if string.find(l,"������") then
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
    local l,w=wait.regexp("^(> |)��־ƽ�������С��˵�����������Ѿ����ˣ��˴�����Ϯ���������������(.*)���������$|^(> |)�趨����������action = \\\"����\\\"",5)
	if l==nil then

	    self:give_head()
	   return
	end
	if string.find(l,"�����Ѿ�����") then
	    world.Send("answer yes")
	    self:sec_attack()
	    return
	end
	if string.find(l,"�趨����������action") then
	   self:jobDone()
	   return
	end

  end)
end

function gmshouwei:jobDone()

end

function gmshouwei:wait_attacker_die(npc)
  wait.make(function()
    local l,w=wait.regexp("^(> |)"..npc.."��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",10)

	if l==nil then
	   self:wait_attacker_die(npc)
	   return
	end
	if string.find(l,"�����ų鶯�˼��¾�����") then
	    self:attacker_die()
	   return
	end

  end)

end

function gmshouwei:wait_guard()
local ts={
	           task_name="ȫ����Ĺ����",
	           task_stepname="�ȴ�����",
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
      local l,w=wait.regexp("^(> |)һ��"..player_name.."��Ҫ׷�õ�(.*)�����Ƶ����˹����������ڴ��������������㷢�����ҵĹ�����$|^(> |)(.*)\\\(Attacker\\\)",10)
	  if l==nil then
	     world.Send("look")
	     self:wait_guard()
	     return
	  end
	  if string.find(l,"�������㷢�����ҵĹ���") then
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
--Զ������һ��Ų�������������,�����в��������ڸ�����
   world.Send("shouwei")
   wait.make(function()
      local l,w=wait.regexp("^(> |)Զ������һ��Ų�������������,�����в��������ڸ�����$",5)
	  if l==nil then
	     self:zhongtian()
	     return
	  end
	  if string.find(l,"Զ������һ��Ų���") then
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
		qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100
	local vip=world.GetVariable("vip") or "��ͨ���"
  	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="����������" then
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
		   w:go(1960) --299 ask xiao tong about ʳ�� ask xiao tong about ��

		elseif h.jingxue_percent<=liao_percent or h.qi_percent<=80 then
		    print(h.jingxue_percent," jingxue_percent",h.qi_percent," qi_percent")
		   --�������ƶ�        �����                    �� �� ��
		   --�����ж���
			  print("����")
              local rc=heal.new()
			  rc.saferoom=234
			  --rc.teach_skill=teach_skill --config ȫ�ֱ���
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
				    drugname="��Ѫ�ƾ���"
				    drugid="huoxue dan"
				else
				    drugname="���ɽ�ҩ"
				    drugid="chantui yao"
				end
			    rc:buy_drug(drugname,drugid,f)
			end
			  rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("��ͨ����")
            local rc=heal.new()
			world.Send("set heal jing")
			rc.saferoom=234
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			    world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
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
		    heal_ok=false --��λ
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
		          f=function() x:dazuo() end  --���
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
	             print("��������")
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


--�㷢�ֻ������Ѿ���կ���޲��ò���ˣ�Ӧ�û�ȥ������!!
function gmshouwei:Status_Check()
  	local ts={
	           task_name="ȫ����Ĺ����",
	           task_stepname="����",
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
	          print("���״̬")
		     if table.getn(cd.lists)>0 then
		       local sec=0
		       for _,i in ipairs(cd.lists) do
			     local s,e=string.find(i[1],"��")
				 if s~=nil then
                    s=s%2
				 else
				    s=0
				 end
			     if i[1]=="�����ƶ�" or s==1 then
				   print("�ж���")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			             self:Status_Check()
					  end
					  f_wait(f,3)
			        end
					if rc.omit_snake_poison==true and i[1]=="�߶�" then --�����߶�

					else
			          rc:qudu(sec,i[1],false)
					  return
					end
			     end
				 if i[1]=="����" or i[1]=="����ȭ����" then
				    print("����")
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
