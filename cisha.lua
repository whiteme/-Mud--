--kill shiwei
--��Ч����
-- ask lu about ��Ч����
--[[
 9:
10:  ������������������������������������������������������������
11:                          ������Ҫ��
12:  ������������������������������������������������������������
13:
14:      ����ֵ80K��500K
15:
16:  ������������������������������������������������������������
17:                          ��������̡�
18:  ������������������������������������������������������������
19:
20:      ����Ҫ׼��һ�����ۣ�Fire����
21:      ��ؤ������������³�н�Ҫ���� ask lu about ��Ч���ң�
22:  ³�н�˵�������ɹŴ�����Ҵ��������ǣ�ÿ�ζ�������Ϊ����֮��
23:  �������������������͵Ϯ�������ؽ��������ܶ�ʧ�ܡ���
24:      ³�н�˵����ǰ���챾����Ӵ�̽�������Ǳ���һ�����£�����
25:  �վ����ɹű����ؿ��顣��Ӹô�����ȥ���Ż��յ��ɹ����֣��Խ�
26:  ������֮Χ��
27:      �����Ա������֡���ɽ����������һ����һ�����֣�����һ��
28:  �ɵ����£�ǰ����һ��ʮ�ֶ��͵Ķ��£��վ��쳣��������Խ(pa)��
29:      ��һ���ĸ����������pa up���������϶��¡��϶�������sd�͵�
30:  �о���֣����������Ԫ����auto kill�㣬һ������Ѳ��ϣ�ɱ��Ԫ
31:  �������ղ��϶�(Caoliao dui)���ɣ�������ɡ��ص�³�нŴ����͡�

����³�нŴ����йء���Ч���ҡ�����Ϣ��
³�н�˵�������ɹŴ�����Ҵ��������ǣ�ÿ�ζ�������Ϊ����֮������
³�н�˵�����������������������͵Ϯ�������ؽ��������ܶ�ʧ�ܡ���
³�н�˵������ǰ���챾����Ӵ�̽�������Ǳ���һ�����£������վ����ɹű����ؿ��顣��
³�нŶ���˵������Ӹô�����ȥ���Ż��յ��ɹ����֣��Խ�������֮Χ��
>
�ã������Ѿ���ɣ����Ի�ȥ�����ˡ�

�ã���������ˣ���õ���������ʮ�ĵ�ʵս���飬һ����ʮ���Ǳ�ܺ�һǧ�Ű���ʮ��������
]]
--gt������������
--1348 ��������
cisha={
  new=function()
    local cs={}
	  setmetatable(cs,cisha)
	 return cs
  end,
  neili_upper=1.8,
  zhongjun=false,
  npc_count=1,
  kill_count=0,
  version=1.8,
}
cisha.__index=cisha
--�㻹����ɱ����ǰ�������ٵ��ɡ�
--Ԫ����ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
--�ã������Ѿ���ɣ����Ի�ȥ�����ˡ�
function cisha:huoshao_NextPoint()
 local ts={
	           task_name="��Ч����",
	           task_stepname="��ɱ����",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   world.Send("look")
   world.Send("set action ����")
   wait.make(function()
   --�������û�г�·��
      local l,w=wait.regexp("^(> |)���� -.*$|^(> |)�¶� -.*$|^(> |)С· -.*$|^(> |)��� -.*$|^(> |)�в� -.*$|^(> |)��� -.*$|^(> |)�Ҳ� -.*$|^(> |)ǰ�� -.*$|^(> |)������ -.*$|^(> |)�趨����������action = \\\"����\\\"$|^(> |)���������꣬�е��޷�����ȥ��ˤ��������$",5)
	  if l==nil then
        self:huoshao_NextPoint()
	    return
	  end
	  if string.find(l,"���������꣬�е��޷�����ȥ��ˤ������") then
	     self:Status_Check()
	     return
	  end
	  if string.find(l,"����") then
	     world.Send("pa up")
	     self:huoshao_NextPoint()
	    return
	  end
	  if string.find(l,"�¶�") then
		 world.Execute("sd;sd;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	  if string.find(l,"С·") then
	       world.Execute("sd;kill yuan bing")
		   self:die()
		 self:combat()
	     return

	  end
	  if string.find(l,"���") then
		 world.Execute("s;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	   if string.find(l,"�в�") then
		 world.Execute("w;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	    if string.find(l,"�Ҳ�") then
		 world.Execute("e;e;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	  if string.find(l,"���") then
		 world.Execute("w;s;kill yuan bing")
		 self:die()
		 self:combat()
	     return
	  end
	   if string.find(l,"ǰ��") then
	     self.kill_count=self.kill_count+1
		 if self.kill_count>5 then
		    world.Execute("n;n;nu;nu;d")
			     shutdown()

		local cisha_jobslist=world.GetVariable("cisha_jobslist") or ""
		local nocisha_jobslist=world.GetVariable("nocisha_jobslist")
		if cisha_jobslist~="" then
			   world.SetVariable("jobslist",nocisha_jobslist)
			   world.AddTimer("huoshao_reset", 0, 15, 0, "SetVariable('jobslist','"..cisha_jobslist.."')", timer_flag.Enabled +timer_flag.OneShot+timer_flag.Replace, "")
	           world.SetTimerOption ("huoshao_reset", "send_to", 12)
		end
		    self:jobDone()
		    return
		 end
		 world.Execute("n;n;kill yuan bing")
		 self:die()
		 self:combat()

	     return
	  end
	  if string.find(l,"�趨����������action") then
	     self:huoshao()
	     return
	  end
	   if string.find(l,"������") then
	     self:get_reward()
	     return
	  end
   end)
end

function cisha:get_reward()
   self:reward()
   local ts={
	           task_name="��Ч����",
	           task_stepname="�ص�³����",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
   w.walkover=function()

	   local _R=Room.new()
	   _R.CatchEnd=function()
		  if _R.RoomName=="������"then
		       shutdown()

		local cisha_jobslist=world.GetVariable("cisha_jobslist") or ""
		local nocisha_jobslist=world.GetVariable("nocisha_jobslist")
		if cisha_jobslist~="" then
			   world.SetVariable("jobslist",nocisha_jobslist)
			   world.AddTimer("huoshao_reset", 0, 15, 0, "SetVariable('jobslist','"..cisha_jobslist.."')", timer_flag.Enabled +timer_flag.OneShot+timer_flag.Replace, "")
	           world.SetTimerOption ("huoshao_reset", "send_to", 12)
		end
			self:jobDone()
		  else
		    self:get_reward()
		  end
		end
		_R:CatchStart()

   end
   w:go(1000)
end

function cisha:NextPoint()
  if self.zhongjun==false then
  local ts={
	           task_name="��Ч����",
	           task_stepname="��ɱ����",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   world.Send("n")
   wait.make(function()
   --�������û�г�·��
      local l,w=wait.regexp("^(> |)�о����� -.*$|^(> |)�о� -.*$|^(> |)�о�ԯ�� -.*$|^(> |)�������û�г�·��$",5)
	  if l==nil then
        self:NextPoint()
	    return
	  end

	  if string.find(l,"�о�����") then
	     self.npc_count=1
	     self.zhongjun=true
		  world.Send("kill shiwei")
		   world.Send("kill shiwei 2")
		   self:die()
	     self:kill_shiwei()
	    return
	  end
	  if string.find(l,"�������û�г�·") then
	      shutdown()
	      self:jobDone()
	     return
	  end
	   if string.find(l,"�о�") or string.find(l,"�о�ԯ��") then
	     self.zhongjun=false
		  world.Send("kill shiwei")
		  self:die()
		 self:kill_shiwei()
	     return
	  end
   end)
   else
   local ts={
	           task_name="��Ч����",
	           task_stepname="��ɱԪ˧",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    print("��ɱԪ˧")
	world.Send("n")
	self:reward()
	world.Send("kill zhan")
    self:combat()
   wait.make(function()
      local l,w=wait.regexp("^(> |)��ʯ��� -*$|^(> |)�����ճ�����ȵ�����.*��$|^(> |)����û������ˡ�$",5) --������ճ������ɱ���㣡
	  if l==nil then
        self:NextPoint()
	    return
	  end

	  if string.find(l,"��ʯ���") or string.find(l,"����û�������") then
	    shutdown()
	    self:jobDone()
	    return
	  end
	   if string.find(l,"ճ����") then

	     return
	  end
   end)


  end
end

function cisha:baicaodan()

	local w
	w=walk.new()
	w.walkover=function()
	   world.Send("ask chen about �ٲݵ�")
	   local b=busy.new()
	   b.interval=0.3
		b.Next=function()
           self:xiangyang()
		end
		b:check()
	end
     w:go(1002)
end

function cisha:buy_fire()
    local sp=special_item.new()
       sp.cooldown=function()
           self:huoshao()
       end
       local equip={}
	   equip=Split("<��ȡ>����","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end



function cisha:huoshao()
	   local ts={
	           task_name="��Ч����",
	           task_stepname="��������",
	           task_step=2,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w
	w=walk.new()
	w.walkover=function()

	   --���������꣬�е��޷�����ȥ��ˤ��������
	   self.NextPoint=function()
	      world.Send("dian gancao")
	      self:huoshao_NextPoint()
	   end
	   world.Execute("pa up;sd;sd;kill yuan bing")
	   self:die()
	   self:combat()

	end
     w:go(1348)

end

function cisha:recover()
    -- self:begin_transaction(function() self:recover() end)  --�ϵ�
	world.Send("yun recover")
	world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()


		if h.jingxue_percent<100 then
		    print("��ͨ����")
			world.Send("fu bai caodan")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.halt=function()
			   world.Send("sleep")
			   local f=function()
			      rc:heal(false,true)
			   end
			   f_wait(f,2)
			end
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 and h.qi_percent>=80 and h.neili>=h.max_neili*0.9 then --������
		    print("��ͨ����")
            local rc=heal.new()
			rc.halt=function()
			   world.Send("sleep")
			   local f=function()
			      rc:heal(true,false)
			   end
			   f_wait(f,2)
			end
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal(true,false)
		elseif h.neili<h.max_neili*self.neili_upper then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun recover")
				  local f=function()
				     self:recover()
				  end
				  f_wait(f,2)
			    end
				if id==777 then
				  self:recover()
				end
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
					   --BigData:catchData(505,"��ʯ��")
			          self:recover()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
			   world.Send("yun recover")
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=h.max_neili*self.neili_upper then
				  self:shield()
				  self:NextPoint()
				  --self:NextPoint()
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			self:shield()
		    self:NextPoint()
		end
	end
	h:check()
end

function cisha:jobDone()

end

function cisha:combat()

end

function cisha:fail(id)
end

function cisha:reward()
  wait.make(function()
    local l,w=wait.regexp("^(> |)�ã���������ˣ���õ���.*��",10)
	if l==nil then
		self:reward()
	  return
	end
	if string.find(l,"�ã����������") then
	local ts={
	           task_name="��Ч����",
	           task_stepname="����",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	  local b=busy.new()
	  b.Next=function()
	    shutdown()

		local cisha_jobslist=world.GetVariable("cisha_jobslist") or ""
		local nocisha_jobslist=world.GetVariable("nocisha_jobslist")
		if cisha_jobslist~="" then
			   world.SetVariable("jobslist",nocisha_jobslist)
			   world.AddTimer("huoshao_reset", 0, 15, 0, "SetVariable('jobslist','"..cisha_jobslist.."')", timer_flag.Enabled +timer_flag.OneShot+timer_flag.Replace, "")
	           world.SetTimerOption ("huoshao_reset", "send_to", 12)
		end


	    self:jobDone()
	  end
	  b:check()
	   return
	end
  end)
end
--[[
����³�нŴ����йء���Ч���ҡ�����Ϣ��
³�н�˵�������ɹŴ��ɸ����ճ�����ʾ�����ʮ�򣬱�����·����ͼ������������
³�н�˵������Ϊ��֮�ƣ�ֻ��Ѱ����ɱ�ɹŴ󽫣�������ʹ�ɹŴ����Χ��������
³�н�˵��������ؤ������״���Ѿ�Ǳ���ɹž��У����ȥ�������ŵ�������
³�н�˵�����������������ɹŴ�Ӫ���Ż���ɱ�ɹŴ󺹡���

198

> �״�����˹�������˵��������������

�״������������ɹŴ���ļ������ڣ������о�Ӫǰ��
�״���������˵�����ҷ��о�ʿ�����޷����ڣ��Ժ�Ϳ�����ˡ�˵��ת���߿��ˡ�
�о�����˵�������󵨣�������
�������о�������ɱ���㣡
is_dangerous_man: �о�����
����Σ��������: �о�����
fpk�о�����
set wimpy 100
��������������ؤ�

��������������ؤ�


                          �о�����
                             ��
                            �о�
�о����� -
    �����ɹŴ�����о����ʣ�Զ�����������ŽǺ�ս���˻��֮���������
��ͨ�����������������Ĵ����������ס�
    ����Ψһ�ĳ����� south��
  �ɹ� �о�Ԫ˧ ճ����(Zhan ertie)
  �����о�������ʬ��(Corpse)

��������������ؤ�
                            �о�
                             ��
                            �о�
                             ��
                          �о�ԯ��
�о� -
    �����ɹŴ�����о���Զ�����������ŽǺ�ս���˻��֮��������ʿ����
��Χ������ȥ������ս��һ��������
    �������Եĳ����� north �� south��
  �о�������ʬ��(Corpse)



�ã���������ˣ���õ���һǧ������ĵ�ʵս���飬�İٶ�ʮ����Ǳ�ܺ;Ű���ʮ��������

����Ż��ҳ����Ԫ����Ӫ��
�������������������ǡ�

��������������ؤ�
                            �о�
                             ��
                          �о�ԯ��


�о�ԯ�� -
    �����ɹŴ�����о�ԯ�ţ�Զ�����������ŽǺ�ս���˻��֮��������ʿ
������Χ������ȥ������ս��һ��������
    ����Ψһ�ĳ����� north��
  �о�������ʬ��(Corpse)]]

function cisha:shield()

end

function cisha:die()
--�о�������ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
  wait.make(function()
    local l,w=wait.regexp("^(> |)�о�������ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$|^(> |)Ԫ����ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",10)
	if l==nil then
	  self:die()
	  return
	end
	if string.find(l,"����û�������") then
	     shutdown()
		  local b=busy.new()
		  b.Next=function()
		    self:recover()
		  end
		  b:check()
	   return
	end
	if string.find(l,"Ԫ��") then
	     shutdown()
		  local b=busy.new()
		  b.Next=function()
		    world.Send("dian gancao")
		    self:recover()
		  end
		  b:check()
	   return
	end
	if string.find(l,"�����ų鶯�˼��¾�����") then
	   if self.zhongjun==true and self.npc_count==1 then
	      world.Send("kill shiwei")
	      self.npc_count=2
		  self:die()
		else
		  shutdown()
		  local b=busy.new()
		  b.Next=function()
		    self:recover()
		  end
		  b:check()
	   end
	   return
	end
  end)
end

function cisha:kill_shiwei()

  self:combat()
end


function cisha:enter()
--�״�����˹�������˵��������������
   wait.make(function()
      local l,w=wait.regexp("^(> |)�״�����˹�������˵��������������$",15)
	  if l==nil then
         self:enter()
		 return
	  end

	  if string.find(l,"��������") then
        print("��ʼ��ɱ")
		shutdown()
		 world.Send("kill shiwei")
		 self:before_kill()
		 self:die()
	     self:kill_shiwei()
	     return
	  end
   end)
end

--^(> |)�о����� -.*$|^(> |)�о� -.*$|^(> |)�о�ԯ�� -.*$|^(> |)�������û�г�·��

function cisha:xiangyang()
   local ts={
	           task_name="��Ч����",
	           task_stepname="ǰ������",
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
      self:enter()
      world.Send("look")
      world.Send("set action ������")

	 wait.make(function()
        local l,w=wait.regexp("^(> |)������ -.*$|^(> |)�趨����������action = \\\"������\\\"$|^(> |)�о�ԯ�� -.*$",3)
	    if l==nil then
         self:xiangyang()
		 return
	    end
        if string.find(l,"�о�ԯ��") then
		   shutdown()
		    world.Send("kill shiwei")
		   self:before_kill()
		   self:die()
	       self:kill_shiwei()
		   return
		end
	    if string.find(l,"�趨����������action") then
	     self:xiangyang()
	     return
	    end
	    if string.find(l,"������") then

	      return
	    end
	 end)
   end

   w:go(198)
end

function cisha:select_job()
   wait.make(function()
      local l,w=wait.regexp("^(> |)³�н�˵�������ɹŴ���ʱû�ҵ��ټ����Ȼ������ɡ���$|^(> |)³�н�˵�����������������ɹŴ�Ӫ���Ż���ɱ�ɹŴ󺹡���$|^(> |)³�н�˵�������㲻���Ѿ��ӹ��������𣿡�$|^(> |)³�н�˵���������ϴ����������ˣ���������Ϣһ����˵�ɡ���$|^(> |)³�н�˵����������������û��ʲô������Ը��㡣��$|^(> |)³�н�˵��������Ӹô�����ȥ���Ż��յ��ɹ����֣��Խ�������֮Χ����$",5)
	  if l==nil then
        self:ask_job()
	    return
	  end
	  if string.find(l,"��ɱ�ɹŴ�")  then
	    local b=busy.new()
		b.Next=function()
	     self:baicaodan()
		end
		b:check()

	     return
	  end
	  if string.find(l,"�Ż��յ��ɹ�����") then
	      local b=busy.new()
		b.Next=function()
	     self:buy_fire()
		end
		b:check()

		 return
	  end
	  if string.find(l,"�㲻���Ѿ��ӹ���������") then
		sj.World_Init=function()
		--��������
          Weapon_Check(process.cisha)
        end
	     local b=busy.new()
		 b.Next=function()
			relogin(5)
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"�ɹŴ���ʱû�ҵ��ټ�") or string.find(l,"�ϴ�����������") or string.find(l,"����������û��ʲô������Ը���") then
        self.fail(101)
	    return
	  end

   end)
end

function cisha:ask_job()
   local w=walk.new()
   w.walkover=function()
      world.Send("ask lu about ��Ч����")
	  self:select_job()
	  --³�н�˵�������ɹŴ���ʱû�ҵ��ټ����Ȼ������ɡ���
   end
   w:go(1000)
end

function cisha:full()
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
			  rc.saferoom=505
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
			rc.saferoom=505
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
			rc.saferoom=1000
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
		         w:go(1000)
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

function cisha:before_kill()

end
--
function cisha:Status_Check()
  	local ts={
	           task_name="��Ч����",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --��ʼ��

     --self:begin_transaction(function() self:Status_Check() end)  --�ϵ�

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
