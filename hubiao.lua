--[[
 1:  ������������������������������������������������������������
 2:                        ������������ܡ�
 3:  ������������������������������������������������������������
 4:
 5:      �����ھ֣�һ���ڽ������쵱�����ֺš�������Զͼ��������ʮ
 6:  ��·��а�������������𽭺�������˵���ϴ�������޵��֡�������
 7:  ʮ���ھ֣���ʮ��λ��ͷ���鲼���ϱ��������ϵ������޲�������
 8:  �����ӡ�
 9:
10:  ������������������������������������������������������������
11:                          ������Ҫ��
12:  ������������������������������������������������������������
13:
14:      ��Ҫ2-4 ����ӣ���Ӿ���ֵ�ܺʹ���1.5M����Ա����ֵ���С
15:  ��1M��ÿ��������100gold��ΪѺ��
16:
17:
18:  ������������������������������������������������������������
19:                          ��������̡�
20:  ������������������������������������������������������������
21:
22:      ���ж�Ա�����ݸ����ھ֣��������ϣ��ɶ�������죬����team
23:  leader ask lin about ���ڣ�����ͬ�����driver �������ڳ�����
== ��ʣ  2 �� == (ENTER ������һҳ��q �뿪��b ǰһҳ)

24:  ȥ��·�Ľٷˣ����ڳ��Ƶ�Ŀ�ĵء�
25:      �����ж�Ա�����������finish������ɹ�����]]
--xzl_gb
-- ��· ս�� �ָ�
--�����㻤��ʧ�ܣ������ھֵ���ʮ���ƽ������⳥�ˡ�
require "wait"
hubiao={
  new=function()
     local hb={}
	 hb.uid=string.sub(CreateGUID(),25,30)
	 setmetatable(hb,{__index=hubiao})
	 return hb
  end,
  co=nil,
  co2=nil,
  co3=nil,
  neili_upper=1.5,
  uid="",
  child_worldID="",
  master_worldID="",
  child_ready=false,
  master_ready=false,
  rooms={}, --�����ķ����
  steps={}, --·����
  step=1,
  alias={},
  timestamp=nil,
  find_NPC=false,
  sayword=false,
  follow_success=false,
  id1_ok=false,
  id2_ok=false,
  leader_roomno=nil,
  tui_count=0,
}

local cb=nil --ս������
local function child_Exe(cmd)
  local otherworld=GetWorldById(hubiao.child_worldID)
  --��Ҫ��ֹ ��id ����
  --Note(otherworld:IsConnected().."")
  if otherworld==nil then
  -- ��ֹ��һ��id ����ر������´�
    hubiao:link()
  end
   local IsConnected=otherworld:IsConnected()
   if IsConnected==false then
	  hubiao:wait_outoftime()
	  return
   end
   if otherworld ~= nil and IsConnected==true then
     otherworld:Execute(cmd)
   end
end

local function main_Exe(cmd)
  local mainworld=GetWorldById(hubiao.master_worldID)
   if mainworld ~= nil then
     mainworld:Execute(cmd)
   end
end

local function safe_child_Exe(cmd)
   local otherworld=GetWorldById(hubiao.child_worldID)
   if otherworld ~= nil then
      local safe_cmd="/f_wait(function() world.Execute('"..cmd.."') end,1,false)"
       otherworld:Execute(safe_cmd)
   end
end
local function safe_main_Exe(cmd)
   local mainworld=GetWorldById(hubiao.master_worldID)
   if mainworld ~= nil then
     local safe_cmd="/f_wait(function() world.Execute('"..cmd.."') end,1,false)"
     mainworld:Execute(safe_cmd)
   end
end

--[[
is_dangerous_man: ������
����Σ��������: ������
fpk������
��������������ɱ���㣡
is_dangerous_man: ��ͬ
����Σ��������: ��ͬ
fpk��ͬ
��������ͬ��ɱ���㣡
�������������ڸ��ݳǡ�
                            ɽ·
                             ��
                          ����ɽ·
                             ��
                            ����
����ɽ· -
    �����ڶ��ϵ�һɽ������ɽ�ϡ�����Ӷ��洵�������ż��ֺ��⡣�ϱ߾�
�������ĺ��۸����ˡ�
��������һ����������ҹ��ҹĻ�ʹ������췱�ǡ�
    �������Եĳ����� north �� south��
  �񻢹����� ��ͬ(Song tong) <ս����>
  �����ھ�����ͷ ��ǧ����(Duanqian xiangyun) <ս����>
  �ڳ�(Biao che)
  �����Ů���� ������(Ao baochai) <ս����>
  ���۽���(Baipao jianxia)
]]

function hubiao:main_link()
   local partner_id=world.GetVariable("hb_partner_id") or ""
   if partner_id=="" then
	  print("hb_partner_id ����û������")
	  return
   end
   hubiao.master_worldID=GetWorldID()
   hubiao.child_ready=false
   hubiao.master_ready=false
   --print(hubiao.master_worldID)
   for k, v in pairs (GetWorldIdList ()) do
    local player_id=GetWorldById (v):GetVariable("player_id")
	if string.lower(player_id)==string.lower(partner_id) then
	  if v~=hubiao.master_worldID then
	        hubiao.partner1_id=string.lower(partner_id)
	        hubiao.child_worldID= v
	   break
	  end
	end
  end
   print("ɾ����ʱ��ʱ��")
	world.DeleteTimer("hubiao_outoftime")
	child_Exe("/print('ɾ����ʱ��ʱ��')")
	child_Exe("/world.DeleteTimer(\"hubiao_outoftime\")")
  --����id ��������
  local cmd="/hubiao.master_worldID='"..hubiao.master_worldID.."'"
  child_Exe(cmd)
  cmd="/hubiao.child_worldID='"..hubiao.child_worldID.."'"
  child_Exe(cmd)

  hubiao:Status_Check()
  cmd="/hubiao:Status_Check()"
  child_Exe(cmd)
end

function hubiao:link()
   local partner_id=world.GetVariable("hb_partner_id") or ""
   if partner=="" then
	  print("hb_partner_id ����û������")
	  return
   end
   hubiao.master_worldID=GetWorldID()
   hubiao.child_ready=false
   hubiao.master_ready=false
   --print(hubiao.master_worldID)
   for k, v in pairs (GetWorldIdList ()) do
    local player_id=GetWorldById (v):GetVariable("player_id")
	if string.lower(player_id)==string.lower(partner_id) then
	  if v~=hubiao.master_worldID then
	        hubiao.partner1_id=string.lower(partner_id)
	        hubiao.child_worldID= v
	   break
	  end
	end
  end
  --����id ��������
  local cmd="/hubiao.master_worldID='"..hubiao.master_worldID.."'"
  child_Exe(cmd)
  cmd="/hubiao.child_worldID='"..hubiao.child_worldID.."'"
  child_Exe(cmd)
  print("�������!!!!!")
end

function hubiao:team()
   local player_id=world.GetVariable("player_id")
   local otherworld=GetWorldById(hubiao.child_worldID)
   local partner_id=otherworld:GetVariable("player_id")
   print("��id",partner_id)
   print("��id",player_id)
   world.Send("team dismiss")
   child_Exe("team dismiss")
   world.Send("team with "..string.lower(partner_id))
   world.Send("follow "..string.lower(partner_id))
   local f=function()
     child_Exe("team with "..string.lower(player_id))
     child_Exe("follow "..string.lower(player_id))
	 local b=busy.new()
	 b.Next=function()
	   hubiao:ask_job()
	 end
	 b:check()
   end
   f_wait(f,1)
   --self:ask_job()
end


function hubiao:main_pfm()
  local otherworld=GetWorldById(hubiao.child_worldID)
  local mainworld=GetWorldById(hubiao.master_worldID)
  local pfm1=mainworld:GetVariable("hb_pfm") or ""
  local pfm2=otherworld:GetVariable("hb_pfm") or ""

  local _pfm1=mainworld:GetVariable(pfm1)
  local _pfm2=otherworld:GetVariable(pfm2)
   world.SetVariable("pfm",_pfm1)
   otherworld:SetVariable("pfm",_pfm2)
  --main_Exe(_pfm1)
  --child_Exe(_pfm2)
   main_Exe("/Send('alias pfm ".._pfm1.."')")
   child_Exe("/Send('alias pfm ".._pfm2.."')")

   world.ColourNote("blue", "Red", _pfm1)
   world.ColourNote("blue", "Red", _pfm2)



end

local heal_ok=false
--full
function hubiao:full()
  local b=busy.new()
  b.Next=function()

    local liao_percent=world.GetVariable("liao_percent") or 80
	liao_percent=tonumber(liao_percent)
	local qi_percent=world.GetVariable("qi_percent") or 100
	qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100
    local h
	h=hp.new()
	h.checkover=function()
	   -- print(h.food,h.drink)
	   print(h.qi_percent,"��Ѫ�ٷְ� ",h.qi,"��Ѫ")
	    if h.food<50 or h.drink<50 then
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
		elseif h.jingxue_percent<=80 or (h.qi_percent<=liao_percent and heal_ok==false) then
		    print("����")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=1333
			rc.heal_ok=function()
			   heal_ok=true
			   self:full()
			end
			rc:liaoshang()
        elseif h.jingxue_percent<100 then
		    print("��ͨ����")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=1333
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:full()
			end
			rc:heal(false,true)
		elseif h.qi_percent<qi_percent and heal_ok==false  then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=1333
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			   heal_ok=true
			   self:full()
			end
			rc.hudiegu=function() --ȡ������ҽ��
			   rc:heal(false,false)
			end
			rc.xiaoyao=function() --ȡ������ҽ��
			   rc:heal(false,false)
			end
			rc.liao_bed=function() --ȡ������ҽ��
			   rc:heal(false,false)
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    heal_ok=false --��λ
		    local x
			x=xiulian.new()
			x.min_amount=10
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
				  world.Send("yun recover")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
			    end
				if id==777 then
				   f=function()
				     heal_ok=false
   				     self:full()
				   end  --���
				   f_wait(f,0.5)
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(1333)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     hubiao:start()
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
			  hubiao:start()
			end
			b:check()
		end
	end
	h:check()
   end
   b:check()
end


function hubiao:Status_Check()
	local ts={
	           task_name="����",
	           task_stepname="����",
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
			        rc.saferoom=1333
			        rc.heal_ok=function()
			          self:Status_Check()
			        end
			        rc:qudu(sec,i[1],false)
				    return
			     end
				 if i[1]=="����" or i[1]=="����ȭ����" then
				    print("����")
				    sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=1333
			        rc.heal_ok=function()
					  local f=function()
			            self:Status_Check()
					  end
					  f_wait(f,5)
			        end
			        rc:heal(true,true)
				    return
				 end
			   end
		     end
            self:full()
	end
	cd:start()
end

function hubiao:shield()

end

function hubiao:ready_check()
     if hubiao.child_ready==true and hubiao.master_ready==true then
		hubiao:team() --��ʼ���
	 elseif hubiao.master_ready==false then
	    safe_child_Exe("say �ȵȴ�ʦ")
		world.DoAfterSpecial(1,"hubiao:ready_check()",12)
	 elseif hubiao.child_ready==false then
		safe_main_Exe("say �ȵ�����")
		world.DoAfterSpecial(1,"hubiao:ready_check()",12)
	 end
end


function hubiao:ready()
	world.DoAfterSpecial(1,"hubiao:ready_check()",12)
end

--�ߵ�λ��
function hubiao:start()
  local w=walk.new()
  w.walkover=function()
	 local worldID=GetWorldID()
	  if hubiao.master_worldID==worldID then
	     print("��id����!")
		 child_Exe("/hubiao.sayword=false")
		 hubiao.master_ready=true
		 hubiao:ready()
	  else
	     print("��id����!")
		 local cmd="/hubiao.child_ready=true"
		 --hubiao.sayword=true
		 --hubiao:say()
		 main_Exe(cmd)
		 main_Exe("/hubiao:ready()")
	  end

  end
  w:go(1333)
end

function hubiao:prepare() --���������� ��·
 local worldID=GetWorldID()
  if hubiao.master_worldID==worldID then
	         --��id
		hubiao.master_ready=true
		hubiao:fight_end()
  else
	         --��id
		main_Exe("/hubiao.child_ready=true")
		main_Exe("/hubiao:fight_end()")
		--hubiao:recover()
  end
end

function hubiao:recover()
  local b=busy.new()
  b.halt_error=function()
     local delay=function()
	    b:check()
	 end
     f_wait(delay,3)
  end
  b.Next=function()
    local weapon_id=world.GetVariable("hb_weapon_id") or ""
	if weapon_id~="" then
	   world.Send("get "..weapon_id)
	end
	local h
	h=hp.new()
	h.checkover=function()
		if h.jingxue_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.auto_drug=function()
			    local f=function()
	              rc:heal(true,true)
	            end
				f_wait(f,1)
			end
			--rc.saferoom=505
			rc.heal_ok=function()
			    hubiao:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
			if h.qi_percent<=60 then
			    world.Send("fu dahuan dan")
			end
            local rc=heal.new()
			--rc.saferoom=505
			rc.auto_drug=function()
			    local f=function()
	              rc:heal(true,true)
	            end
				f_wait(f,1)
			end
			rc.heal_ok=function()
			    hubiao:recover()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper)  then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
			    if id==1 then
				   world.Send("yun qi")
				   local f=function() x:dazuo() end  --���
				    f_wait(f,1)
				end
				if id==201 then
				  if h.jingxue_percent<=60 then
				     hubiao:recover()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,10)
			    end
				if id==777 then
				   hubiao:recover()
				end
				if id==101 then
				   world.Send("yun qi")
				   world.Send("yun jing")
				   hubiao:recover()
				end
	           if id==202 then
	              local b
			       b=busy.new()
			       b.Next=function()
			        hubiao:prepare()
			       end
			       b:check()
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*1.2)
			   world.Send("yun recover")
			   world.Send("yun refresh")
			   if h.neili>h.max_neili*1.2 then
			      print("����!!")
			      hubiao:prepare()
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)

			local b
			b=busy.new()
			b.Next=function()
			   world.Send("yun recover")
		       world.Send("yun refresh")
			  hubiao:prepare()
			end
			b:check()
		end
	end
	h:check()
  end
  b:check()
end


function hubiao:followche(dir,roomname,direct)
--[[
��֧�����ɸ����ھ���ʦĪ�Ը����͵���ɽ��������᯵±����ϵġ�
   hubiao.follow_success=nil
    local mainworld=GetWorldById(hubiao.master_worldID)
		  local player_name1=mainworld:GetVariable("player_name") or ""
		  local otherworld=GetWorldById(hubiao.child_worldID)
		  local player_name2=otherworld:GetVariable("player_name") or ""
   world.Execute("look cart;look cart 2;look cart 3;look cart 4;set action �ڳ�")
   wait.make(function()
     local l,w=wait.regexp("^(> |)��֧�����ɸ����ھ���ʦ("..player_name1.."|"..player_name2.."")�����͵�(.*)���ϵġ�$|^(> |)�趨����������action \= \"�ڳ�\"$",5)
	 if l==nil then
	    hubiao:followche(dir,roomname,direct)
	    return
	 end
	 if string.find(l,"��֧�����ɸ����ھ�") then
	      hubiao.follow_success=true
		  return
     end
	 if string.fin(l,"�趨����������action ") then
	    hubiao.follow_success=false
	    return
	 end

   end)
]]
end

function hubiao:child_move(dir,roomname,direct)
  world.Execute(direct)

 world.Send("set action �ƶ�")
  wait.make(function()
     --tell_room(newroom,HIR"ͻȻ·������һȺ�ٷˣ�\n"NOR);
		--tell_room(newroom,HIR+jf->query("name")+"��ݺݵ�˵������·���ҿ������������ԣ�֪��������ʲô�˰ɣ�\n"NOR);
      local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)�趨����������action \= \"�ƶ�\"",10)
	  if l==nil then
	     hubiao:child_move(dir,roomname,direct)
		 return
	  end

	  if string.find(l,"�����ƶ�") then
	     local b=busy.new()
		 b.Next=function()
	       hubiao:child_move(dir,roomname,direct)
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"�趨����������action") then

	    return
	  end
   end)
end

--�ص�����
function hubiao:move(dir,roomname,direct,again,action)
   if hubiao.master_ready==true and hubiao.child_ready==true then
	 if action~=nil then
	    world.Execute(action)
	 end
	 world.Execute(direct)
     world.Send("set action �ƶ�")

	 if again==nil then
	   if action~=nil then
	    child_Exe(action)
	   end

	   child_Exe("/hubiao:child_move('"..dir.."','"..roomname.."','"..direct.."')")
	 end
	 wait.make(function()
     --tell_room(newroom,HIR"ͻȻ·������һȺ�ٷˣ�\n"NOR);
	 --��Ķ�����û����ɣ������ƶ���
		--tell_room(newroom,HIR+jf->query("name")+"��ݺݵ�˵������·���ҿ������������ԣ�֪��������ʲô�˰ɣ�\n"NOR);
      local l,w=wait.regexp("^(> |).*(۶����|��Ӱ�|������|��ũ��|�޾���|��ɳ��|�����|���ΰ�|������|�񻢹�|ǧ��ׯ)(Ů|)����.*(<ս����>|<���Բ���>)|^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)�趨����������action \= \"�ƶ�\"|^.*"..hubiao.NPC..".*",10)
	  if l==nil then
	     hubiao:move(dir,roomname,direct)
		 return
	  end
	  if string.find(l,"����") then
	      shutdown()
		   hubiao.master_ready=false
		   hubiao.child_ready=false
		   hubiao:lineup()--����
		   hubiao:fight()
	      return
	  end
	  if string.find(l,hubiao.NPC) then
	     hubiao.find_NPC=true
	     hubiao:check_fight()

	     return
	  end
	  --|^(> |)��Ķ�����û����ɣ������ƶ���$
	  if string.find(l,"�����ƶ�") then
	     local b=busy.new()
		 b.Next=function()
	       hubiao:move(dir,roomname,direct,true)
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"�趨����������action") then
	    print("û�нٷ�!!!")
		-- child_Exe("/hubiao:move('"..dir.."','"..roomname.."','"..direct.."')")
	     --hubiao:followche(dir,roomname,direct)
		  world.ColourNote("red","yellow","***************************û�нٷ�!!!����!***********************")
		  local f=function()
		    --coroutine.resume(hubiao.co)
			hubiao:checkhere()
		  end
		  f_wait(f,1)

		--ColourNote("red","yellow","**********************û�нٷ�!!!����!!*************")
		--hubiao:checkhere()
	    return
	  end
   end)

   else
      local cmd="hubiao:move('"..dir.."','"..roomname.."','"..direct.."')"
      DoAfterSpecial(1,cmd,12)
   end
end

function hubiao:followche(dir,roomname,direct,action)
   --��֤����id ��û��busy һ���ƶ�
   local b=busy.new()
   b.halt_error=function()  --��ʱ
      local f=function()
	     b:jifa()
	  end
	  f_wait(f,3)
   end
   b.Next=function()

       local worldID=GetWorldID()
	    if hubiao.master_worldID==worldID then
	       --��id
		    local cmd="/hubiao.master_ready=true"
		    main_Exe(cmd)
			if action~=nil then
		  	  cmd="hubiao:move('"..dir.."','"..roomname.."','"..direct.."',nil,'"..action.."')"
			else
			  cmd="hubiao:move('"..dir.."','"..roomname.."','"..direct.."')"
			end
            DoAfterSpecial(1,cmd,12)
			--cmd="/hubiao:followche2('"..dir.."','"..roomname.."','"..direct.."')"
			--main_Exe(cmd) --�ص���
	    else
	      --��id
		   local cmd="/hubiao.child_ready=true"
			main_Exe(cmd)
            --child_Exe(cmd)
			--cmd="/hubiao:followche2('"..dir.."','"..roomname.."','"..direct.."')"
			--main_Exe(cmd) --�ص���
	    end
   end
   b:jifa()

end

--AddTrigger("�����㻤��ʧ�ܣ������ھֵ���ʮ���ƽ������⳥�ˡ�")
--�����㻤��ʧ�ܣ������ھֵ���ʮ���ƽ������⳥�ˡ�


function hubiao:tui(direct,who,action)
    --������ô�죬����ڳ�Ūɢ����
	--��������æ������ָ���ڳ�ǰ����
	--local cmd="drop 1 gold;tui "..direct..";get 1 gold"
	hubiao.tui_count=hubiao.tui_count+1
	if hubiao.tui_count>50 then
	   print("����50�Σ����쳣������")
	   main_Exe("/hubiao.tui_count=0")
	   child_Exe("/hubiao.tui_count=0")
	   child_Exe("tui north")
	   main_Exe("tui north")
	   child_Exe("/hubiao:jobDone()")
	   main_Exe("/hubiao:jobDone()")
	   return
	end
	local cmd="tui "..direct
	if who==nil then
	  --�����Ƴ� ��id
	   main_Exe(cmd)
	elseif who=="none" then
	    print("���˵��ڳ�")
	   main_Exe(cmd)
	else
	   child_Exe(cmd)
	end
	if action~=nil then
	   world.Execute(action)
	end
    wait.make(function()
	   local l,w=wait.regexp("^(> |)�ڳ���(.*)�Ļ����»�������(.*)��(.*)��ȥ�ˡ�$|^(> |)������ô�죬����ڳ�Ūɢ����$|^(> |)��������æ������ָ���ڳ�ǰ����$|^(> |)�ٷ���δ��ȥ�������������ߣ���$",2)
	   if l==nil then
		  hubiao:tui(direct,who,action)
		  return
	   end
	   if string.find(l,"�ٷ���δ��ȥ��������������") then
	      hubiao:fight()
	      return
	   end
	   if string.find(l,"��������æ������ָ���ڳ�ǰ��") then
	      wait.time(1)
		  hubiao.tui_count=0
		  hubiao:tui(direct,who,action)
	      return
	   end
	   if string.find(l,"������ô�죬����ڳ�Ūɢ����") then
	      hubiao.tui_count=0
	      hubiao:tui(direct,"child",action)
	      return
	   end
	   if string.find(l,"��ȥ��") then
          hubiao.id1_ok=false
          hubiao.id2_ok=false
		  local guardname=w[2]
	      local dir=w[3]
		  local roomname=w[4]
		  local mainworld=GetWorldById(hubiao.master_worldID)
		  local player_name1=mainworld:GetVariable("player_name") or ""
		  local otherworld=GetWorldById(hubiao.child_worldID)
		  local player_name2=otherworld:GetVariable("player_name") or ""
		  main_Exe("/dangerous_man_list_clear()")
		  child_Exe("/dangerous_man_list_clear()")
		  if guardname==player_name1 or guardname==player_name2 or guardname=="��" then
             hubiao.tui_count=0
			 if roomname=="��·" then
			    print("��·����")
			    direct="nu;s;nu;n;nu;s;nu;s;nu"
			 end

			 --�ڳ�������Ļ����»�������һ�ߵ�ɳĮ��ȥ�ˡ�

		     hubiao.master_ready=false
		     hubiao.child_ready=false
		     local cmd=""
			 if action~=nil then
			    cmd="/hubiao:followche('"..dir.."','"..roomname.."','"..direct.."','"..action.."')"
		 	 else
			    cmd="/hubiao:followche('"..dir.."','"..roomname.."','"..direct.."')"
			 end
			 local cmd2="/hubiao:id_follow()"
			 main_Exe(cmd2)
			 child_Exe(cmd2)
		     --�ֿ�
		     main_Exe(cmd)
			 child_Exe(cmd)
		  else
		      hubiao:tui(direct,"none",action)
		  end
		  return
	   end
	end)
end

function hubiao:outboat()
  wait.make(function()
	local l,w=wait.regexp("^(> |)�ɴ��͵�һ���Ѿ�����������˵������������´��ɣ���$|^(> |)����˵���������ϰ��ɡ����漴��һ��̤�Ű���ϵ̰���$|^(> |)��������˵���������´��ɣ���ҲҪ��ȥ�ˡ���$",5)
	 if l==nil then
	    safe_main_Exe("say �����޵�ͬ����")
		safe_child_Exe("say ǧ���޵ù�����")
	    hubiao:outboat()
	    return
	 end
	 if string.find(l,"�ɴ��͵�һ���Ѿ�����") or string.find(l,"�������ϰ���") or string.find(l,"���´��ɣ���ҲҪ��ȥ��") then

	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("out")
		 --hubiao:checkhere()
	   end
	   b:check()
	    return
	 end

  end)
end

function hubiao:yellboat(is_tui)
 wait.make(function()
--����һֻ�ɴ��ϵ�������˵�������������أ������ɡ�
    world.Send("yell boat")
    if is_tui==nil or is_tui==true then
	  --hubiao:tui("enter")
	  world.Send("tui enter")
	  --world.Send("enter")
	  --child_Exe("enter")
	  child_Exe("tui enter")
	else
	   world.Send("enter")
	   child_Exe("enter")
	end
	  --world.Send("set look")
	  --�ƺӶɴ� - out --
	  --�ڳ���רҵ���ڵĻ����»�������һ�ߵ��½��ɿ���ȥ�ˡ�
	  --�ڳ���רҵ���ڵĻ����»�����������Ķɴ���ȥ�ˡ�
	  --�ɴ� - |^(> |)(��|��)����ԶԶ����һ�������ȵȰ���������ˡ�������$|^(> |)ֻ���ú��治Զ����������������������æ���š�����$
      local l,w=wait.regexp("^(> |)�ڳ���(.*)�Ļ����»�������(.*)��(.*)��ȥ�ˡ�$|^(> |).*�ɴ�\\\s*-\\\s*(out|)$|.*�ɴ�\\\s*-.*",3)
	  if l==nil then
	    hubiao:yellboat(is_tui)
	    return
	  end
	  if string.find(l,"�Ļ����»�������") then
		 --world.Send("enter")
		 --child_Exe("enter")
		  -- print("�ڳ��Ѿ��ϴ�!")
          world.ColourNote("blue","yellow","�ڳ��Ѿ��ϴ�!")
		  local guardname=w[2]
	      local dir=w[3]
		  local roomname=w[4]
		  local mainworld=GetWorldById(hubiao.master_worldID)
		  local player_name1=mainworld:GetVariable("player_name") or ""
		  local otherworld=GetWorldById(hubiao.child_worldID)
		  local player_name2=otherworld:GetVariable("player_name") or ""

		  if guardname==player_name1 or guardname==player_name2 or guardname=="��" then
		      hubiao:yellboat(false)
		  else
		      hubiao:yellboat(true)
		  end
		 return
	  end
	  if string.find(l,"�ɴ�") then
	     --print("out boat ����")
	     hubiao:outboat()
		 return
	  end
	 --[[ if string.find(l,"�ȵȰ�") or string.find(l,"ֻ���ú��治Զ����������") then
	     wait.time(5)
		 hubiao:yellboat()
	     return
	  end]]

	  --[[
	  if string.find(l,"ʲô") then --�����쳣
	    --self:finish()
		--���¼���
	    return
	  end]]
  end)
end

--���� id
local partner=false
local cart=false
function hubiao:lists(regexp)
  wait.make(function()
      local l,w=wait.regexp(regexp,5)
	  if l==nil then
	     hubiao:lists(regexp)
		 return
	  end
	  if string.find(l,"�ڳ�") then
	     cart=true
		 hubiao:lists(regexp)
	     return
	  end
	  if string.find(l,partner_id) then
	    partner=true
	    hubiao:lists(regexp)
		return
	  end
	  if string.find(l,"�趨����������action") then
	    --������ظ�������
	    local cmd
		if cart==true and partner==true then
		  cmd="/hubiao.together=true"
		elseif cart==false and partner==true then
		  cmd="/hubiao.together='cart'"
		elseif cart==false and partner==false then
          cmd="/hubiao.together=false"
        elseif cart==true and partner==false then
          cmd="/hubiao.together='partner'"
		end
	    main_Exe(cmd)
		main_Exe("/hubiao:idhere_result()")
	    return
	  end
   end)
end



function hubiao:idhere()
   cart=false
   partner=false
   world.Send("id here")
   world.Send("set action ���")
   local otherworld=GetWorldById(hubiao.master_worldID)
   local partner_id=otherworld:GetVariable("player_id")
   local regexp=".* = "..partner_id.."$|^(> |)�ڳ� = .*$|^(> |)�趨����������action \= \"���\"$"
   hubiao:lists(regexp)
end

function hubiao:check_shamo()
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --���ݵ�ǰλ�� ǰ�������Ǯׯ
--{���� 410} {���� 1474} {���� 50} {�ɶ� 546} {���� 1973} {���� 1069} {���� 1119} {���� 1331} {���� 926} {���ݳ�}
      local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==1705 then
	   hubiao.co2=nil
	   print("ɳĮ��Ե!!")

        hubiao:checkhere()
	 elseif roomno[1]==630 then
	     print("���!!")
	    world.Send("ne")
		hubiao:checkhere()
	 elseif roomno[1]==631 then
	    hubiao:maze()
	 else
	    hubiao:maze()
	 end
   end
  _R:CatchStart()
end

function hubiao:wuzhitang_east_zoulang()
   local f=function()
		--print("������")
		hubiao:tui("east")
	end
	hubiao:break_in("kill hong xiaotian",f,nil)
end
hubiao.alias["wuzhitang_east_zoulang"]=function() hubiao:wuzhitang_east_zoulang() end

function hubiao:wuzhitang_west_zoulang()
   local f=function()
		--print("������")
		hubiao:tui("west")
	end
	hubiao:break_in("kill hong xiaotian",f,nil)
end
hubiao.alias["wuzhitang_west_zoulang"]=function() hubiao:wuzhitang_west_zoulang() end

function hubiao:xieketing_rimulundian()
	local f=function()
		print("������")
		hubiao:tui("enter",nil,"open door")
	end
	hubiao:break_in("kill hufa lama|kill hufa lama|kill hufa lama",f,nil)
end
hubiao.alias["xieketing_rimulundian"]=function() hubiao:xieketing_rimulundian() end

function hubiao:rimulundian_yueliangmen()
	local f=function()
		print("������")
		hubiao:tui("west")
	end
	hubiao:break_in("kill hufa lama|kill hufa lama|kill hufa lama",f,nil)
end
hubiao.alias["rimulundian_yueliangmen"]=function() hubiao:rimulundian_yueliangmen() end

function hubiao:block_eastup()
   --world.Send("knock gate")
	local b=busy.new()
	b.interval=0.5
	b.Next=function()
		hubiao:tui("eastup")
		--hubiao:checkhere()
	end
	b:check()
end
hubiao.alias["block_eastup"]=function() hubiao:block_eastup() end

function hubiao:dxssk_dxssg()  --5182-5232
  local b=busy.new()
	b.interval=0.5
	b.Next=function()
		hubiao:tui("southup")
		 --hubiao:checkhere()
	end
	b:check()
end
hubiao.alias["dxssk_dxssg"]=function() hubiao:dxssk_dxssg() end

function hubiao:gudelin_bailongdong()
local p={"west","south","east","north","west","south","east","north","west","south","east","north"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
		--��鷿���
		hubiao:check_shamo()
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end
hubiao.alias["gudelin_bailongdong"]=function() hubiao:gudelin_bailongdong() end

function hubiao:xiangyangshulin_circle()
local p={"south","south","north","north","east","north","east","west","south","north"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
		--��鷿���
		hubiao:check_shamo()
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end
hubiao.alias["xiangyangshulin_circle"]=function() hubiao:xiangyangshulin_circle() end

function hubiao:shulin_shendiao()
local p={"north","south","north","north"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
		--��鷿���
		hubiao:check_shamo()
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end
hubiao.alias["shulin_shendiao"]=function() hubiao:shulin_shendiao() end

function hubiao:nanjie_changjie()
   local b=busy.new()
	b.interval=0.5
	b.Next=function()
		hubiao:tui("east")
		 --hubiao:checkhere()
	end
	b:check()
end
hubiao.alias["nanjie_changjie"]=function() hubiao:nanjie_changjie() end

function hubiao:zhendaoyuan_chanfang()
	local f=function()
		print("������")
		hubiao:tui("west")
	end
	hubiao:break_in("kill xuansheng dashi",f,nil)
end
hubiao.alias["zhendaoyuan_chanfang"]=function() hubiao:zhendaoyuan_chanfang() end

function hubiao:daxueshan_daxueshankou()
 local b=busy.new()
	b.interval=0.5
	b.Next=function()
		hubiao:tui("southup")
		 --hubiao:checkhere()
	end
	b:check()
end
hubiao.alias["daxueshan_daxueshankou"]=function() hubiao:daxueshan_daxueshankou() end
--�����������䳡-����̨
function hubiao:block_westup()
    local b=busy.new()
	b.interval=0.5
	b.Next=function()
		hubiao:tui("westup")
		 --hubiao:checkhere()
	end
	b:check()
end
hubiao.alias["block_westup"]=function() hubiao:block_westup() end

function hubiao:dalunsishanmen_dianqianguangchang()
    world.Send("knock gate")
	 local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("northup",nil,"knock gate")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["dalunsishanmen_dianqianguangchang"]=function() hubiao:dalunsishanmen_dianqianguangchang() end

function hubiao:qingduyaotai_baishilu()

		local f=function()
		  print("������")
		  hubiao:tui("northup")
		end

        hubiao:break_in("kill chanshi|kill wu seng|kill wu seng",f,nil)
end
hubiao.alias["qingduyaotai_baishilu"]=function() hubiao:qingduyaotai_baishilu() end

function hubiao:shanmen_shanlu()

		local f=function()
		  print("����")
		  hubiao:tui("northup")
		end

        hubiao:break_in("kill bangzhong|kill bangzhong",f,nil)

end
hubiao.alias["shanmen_shanlu"]=function() hubiao:shanmen_shanlu() end
--zoulang_liangongfang 1958
function hubiao:zoulang_liangongfang()

		local f=function()
		  print("����Ϫ")
		  hubiao:tui("north")
		end

        hubiao:break_in("kill zhang songxi",f,nil)

end
hubiao.alias["zoulang_liangongfang"]=function() hubiao:zoulang_liangongfang() end

function hubiao:zoulang_xixiangzoulang()

		local f=function()
		  print("����Ϫ")
		  hubiao:tui("west")
		end
        hubiao:break_in("kill zhang songxi",f,nil)
end
hubiao.alias["zoulang_xixiangzoulang"]=function() hubiao:zoulang_xixiangzoulang() end



--������������˹�����   ��
--Ī����������ɽ·�뿪�� ��
function hubiao:id_follow()
  --���2��id �Ƿ���ͬһ������
   local mainworld=GetWorldById(hubiao.master_worldID)
   local player_name1=mainworld:GetVariable("player_name") or ""
   local otherworld=GetWorldById(hubiao.child_worldID)
   local player_name2=otherworld:GetVariable("player_name") or ""
   wait.make(function()
      local l,w=wait.regexp("^(> |)"..player_name2.."��.*���˹�����$|^(> |)"..player_name1.."��.*�뿪��$",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"�뿪") then
	     main_Exe("/hubiao.id1_ok=true")
	     return
	  end
	  if string.find(l,"���˹���") then
	     main_Exe("/hubiao.id2_ok=true")
	     return
	  end

   end)
end

function hubiao:zoulang_dongxiangzoulang()

		local f=function()
		  print("����Ϫ")
		  hubiao:tui("east")
		end
        hubiao:break_in("kill zhang songxi",f,nil)
end
hubiao.alias["zoulang_dongxiangzoulang"]=function() hubiao:zoulang_dongxiangzoulang() end

function hubiao:shamo1_shamo2()
   local p={"north","south","south","north","south","south","north","south","north","south","south","north","south","south"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
		--��鷿���
		hubiao:check_shamo()
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end

hubiao.alias["shamo1_shamo2"]=function() hubiao:shamo1_shamo2() end

function hubiao:knockgatesouth()
   world.Send("knock gate")
	 local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("south",nil,"knock gate")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["knockgatesouth"]=function() hubiao:knockgatesouth() end

function hubiao:knockgatenorthup()
     world.Send("knock gate")
	 local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("northup",nil,"knock gate")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["knockgatenorthup"]=function() hubiao:knockgatenorthup() end

function hubiao:guangchang_shanmendian()
	world.Send("knock gate")
	 local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("north",nil,"knock gate")
		 --hubiao:checkhere()
	   end
	   b:check()

end
hubiao.alias["guangchang_shanmendian"]=function() hubiao:guangchang_shanmendian() end

function hubiao:opendoornorthup()
   world.Send("open door")
     local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("northup",nil,"open door")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["opendoornorthup"]=function() hubiao:opendoornorthup() end

function hubiao:opendoorsouthdown()
  world.Send("open door")
     local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("southdown",nil,"open door")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["opendoorsouthdown"]=function() hubiao:opendoorsouthdown() end

function hubiao:opendoornorth()
  world.Send("open door")
     local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("north",nil,"open door")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["opendoornorth"]=function() hubiao:opendoornorth() end

function hubiao:shushang()
  local f=function()
		hubiao:tui("down")
	end
	hubiao:break_in("kill ju mang",f,nil)
end
hubiao.alias["shushang"]=function() hubiao:shushang() end

function hubiao:baishilu_songshuyuan()
	local f=function()

		hubiao:tui("west")
	end
	hubiao:break_in("kill wu seng|kill wu seng|kill chanshi",f,nil)
end
hubiao.alias["baishilu_songshuyuan"]=function() hubiao:baishilu_songshuyuan() end

function hubiao:yamen_zhengting()
   local f=function()
		hubiao:tui("north")
	end
	hubiao:break_in("kill ya yi",f,nil)
end
hubiao.alias["yamen_zhengting"]=function() hubiao:yamen_zhengting() end

function hubiao:opendoorout()
  world.Send("open door")
     local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("out",nil,"open door")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["opendoorout"]=function() hubiao:opendoorout() end

function hubiao:opendoorsouth()
   world.Send("open door")
     local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("south",nil,"open door")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["opendoorsouth"]=function() hubiao:opendoorsouth() end

function hubiao:opendoorwest()
   world.Send("open door")
   local b=busy.new()
    b.interval=0.5
	   b.Next=function()
         hubiao:tui("west",nil,"open door")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["opendoorwest"]=function() hubiao:opendoorwest() end

function hubiao:opendooreast()
   world.Send("open door")
     local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("east",nil,"open door")
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["opendooreast"]=function() hubiao:opendooreast() end


function hubiao:chanyan_shidao()
	local f=function()
		print("����")
		hubiao:tui("north")
	end
	hubiao:break_in("kill ding mian",f,nil)
end
hubiao.alias["chanyan_shidao"]=function() hubiao:chanyan_shidao() end

function hubiao:break_in(cmds,callback,index)
    local cmd=Split(cmds,"|")
	if index==nil then
	    index=1
	else
	    index=index+1
	end
	print(index," index",table.getn(cmd))
	if index>table.getn(cmd) then
	   print("callback")
	   index=nil
	   callback()
	else
	   world.Execute(cmd[index])
	end
	 wait.make(function()
       local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾�����.*|^(> |)����û������ˡ�$",15)
	   if l==nil then
	      self:break_in(cmds,callback,index)
		  return
	   end
	   if string.find(l,"�����ų鶯�˼��¾�����") or string.find(l,"����û�������") then
	     world.Send("unset wimpy")
         local b=busy.new()
         b.interval=0.3
         b.Next=function()
		   hubiao:break_in(cmds,callback,index)
		 end
		 b:check()
		 return
	   end

	  end)
end

function hubiao:changlemen_dongmenchenglou()
--934 2920

 --[[local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
      if roomno[1]==934 then]]
		local f=function()
		  print("hudiao")
		  hubiao:tui("up")
		end

        hubiao:break_in("kill guan bing|kill guan bing|kill wu jiang",f,nil)
	--[[
	 end
   end
   _R:CatchStart()]]
end
hubiao.alias["changlemen_dongmenchenglou"]=function() hubiao:changlemen_dongmenchenglou() end

function hubiao:anyuanmen_beimenchenglou()
        local f=function()
		  hubiao:tui("up")
		end

        hubiao:break_in("kill guan bing|kill guan bing|kill wu jiang",f,nil)
end
hubiao.alias["anyuanmen_beimenchenglou"]=function() hubiao:anyuanmen_beimenchenglou() end

function hubiao:yongningmen_nanmenchenglou()
       local f=function()
		  hubiao:tui("up")
		end

        hubiao:break_in("kill guan bing|kill guan bing|kill wu jiang",f,nil)
end
hubiao.alias["yongningmen_nanmenchenglou"]=function() hubiao:yongningmen_nanmenchenglou() end
function hubiao:andingmen_ximenchenglou()
	local f=function()
		  hubiao:tui("up")
		end

    hubiao:break_in("kill guan bing|kill guan bing|kill wu jiang",f,nil)
end
hubiao.alias["andingmen_ximenchenglou"]=function() hubiao:andingmen_ximenchenglou() end

function hubiao:baishilu_tianwangdian()

	 local f=function()
		  hubiao:tui("northup")
	 end
    hubiao:break_in("kill chanshi|kill wu seng|kill wu seng",f,nil)
end
hubiao.alias["baishilu_tianwangdian"]=function() hubiao:baishilu_tianwangdian() end

function hubiao:xzl_gb()
    local p={"north","east","north","west","north","east","north","west","north"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)

end
hubiao.alias["xzl_gb"]=function() hubiao:xzl_gb() end

function hubiao:unwield_all_finish()

end

function hubiao:unwield_all()
 local sp=special_item.new()
	sp.cooldown=function()

		local worldID=GetWorldID()
	    if hubiao.master_worldID==worldID then
	       --��id
		    local cmd="/hubiao.master_ready=true"
		    main_Exe(cmd)
            --DoAfterSpecial(1,cmd,12)
			cmd="/hubiao:unwield_all_finish()"
			main_Exe(cmd) --�ص���
	    else
	      --��id
		   local cmd="/hubiao.child_ready=true"
			main_Exe(cmd)
			cmd="/hubiao:unwield_all_finish()"
            --child_Exe(cmd)
			--cmd="/hubiao:followche2('"..dir.."','"..roomname.."','"..direct.."')"
			main_Exe(cmd) --�ص���
	    end
   end
   sp:unwield_all()
end

function hubiao:unwield_northup()
    hubiao.master_ready=false
	hubiao.child_ready=false
    hubiao.unwield_all_finish=function()
	   if hubiao.master_ready==true and hubiao.child_ready==true then
			local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
            hubiao:tui("northup")
		 --hubiao:checkhere()
	      end
	      b:check()
	   end
	end
    hubiao:unwield_all()
	child_Exe("/hubiao:unwield_all()")

end
hubiao.alias["unwield_northup"]=function() hubiao:unwield_northup() end

function hubiao:rimulundian_zhaitang()
      local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
         hubiao:tui("southeast",nil)
		 --hubiao:checkhere()
	   end
	   b:check()
end
hubiao.alias["rimulundian_zhaitang"]=function() hubiao:rimulundian_zhaitang() end

function hubiao:wuzhitang_houxiangfang()
	 local f=function()
		  hubiao:tui("north")
	 end
    hubiao:break_in("kill hong xiaotian",f,nil)
end
hubiao.alias["wuzhitang_houxiangfang"]=function() hubiao:wuzhitang_houxiangfang() end

function hubiao:songlin_shibanlu()
 local p={"south","west","south","west","south","west","south","south","south","south","south","south","south"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end
hubiao.alias["songlin_shibanlu"]=function() hubiao:songlin_shibanlu() end

function hubiao:songlin_longshuyuan()
  local p={"north","north","north","west","west","north","north","north","west","west","west"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end
hubiao.alias["songlin_longshuyuan"]=function() hubiao:songlin_longshuyuan() end

function hubiao:songshulin2_songshulin3()
 local p={"north","east","north","west","north","north"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end
hubiao.alias["songshulin2_songshulin3"]=function() hubiao:songshulin2_songshulin3() end

function hubiao:shanlu1_shanlu2()
   local p={"north","north","south","north","north","north","south","north"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end
hubiao.alias["shanlu1_shanlu2"]=function() hubiao:shanlu1_shanlu2() end


function hubiao:qingduyaotai_banruotai()
    local f=function()
		  hubiao:tui("eastup")
	 end
    hubiao:break_in("kill chanshi|kill wu seng|kill wu seng",f,nil)
end
hubiao.alias["qingduyaotai_banruotai"]=function() hubiao:qingduyaotai_banruotai() end

function hubiao:do_tui()
   hubiao.co2=nil
   hubiao.co=coroutine.create(function()
	 for _,s in ipairs(hubiao.steps) do
	--if i<=table.getn(hubiao.steps) then
	    print("��һ��")
        local dir=s
		print("����:",dir)
		if dir=="" then
		    print("����")
		    hubiao:finish()
		    return
		end
		if is_Special_exits(dir)==true then
		    if dir=="duhe" or dir=="dujiang" then
			  local f=function()
			    hubiao:yellboat()
			  end
			  f_wait(f,1)
			else
			   local callback=hubiao.alias[dir]
			   if callback==nil then
			     world.AppendToNotepad (WorldName().."_��������:",os.date().." û���ҵ�����·������:"..dir.."\r\n")
			     return
			   end
			   callback()
			end
        else
		   --world.Send(dir)
		   hubiao:tui(dir)
		   --hubiao:checkhere()
		end
		print("����!!")
		coroutine.yield()
		hubiao.step=hubiao.step+1
	end
	 print("����!!!")
	 hubiao:finish()
   end)
  coroutine.resume(hubiao.co)
end

function hubiao:jobDone()

end

function hubiao:reward()
 local rd=reward.new()
		rd.finish=function()
          local ts={
	           task_name="����",
	           task_stepname="����",
	           task_step=3,
	           task_maxsteps=3,
	           task_location=Place,
	           task_description="",
	       }
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
		 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��������:����! ����:"..rd.exps_num.." Ǳ��:"..rd.pots_num.." �ƽ�:"..rd.gold_num, "red", "black") -- yellow
		  --exps=tonumber(exps)+ChineseNum(w[2])
		end
		rd:get_reward()
end

function hubiao:finish()
--�����ڻ�û�е���Ŀ�ĵأ�
--����Т�����ʾ���ĵĸ�л��
--�㱻��������ǧ�˰���˵㾭�飬һǧһ����ʮ�ĵ�Ǳ�ܣ�һ�ٶ�ʮ���ƽ�
  local worldID=GetWorldID()
   if hubiao.master_worldID==worldID then
       child_Exe("/hubiao:finish()")
	   world.Send("finish")
   end
--�����ڻ�û�е���Ŀ�ĵأ�
  wait.make(function()
    local l,w=wait.regexp("^(> |)�����ڻ�û�е���Ŀ�ĵ�.*$|^(> |)��Ķ�Ա��δ���룡|^(> |)"..hubiao.NPC.."�����ʾ���ĵĸ�л��$",5)
	if l==nil then
	  hubiao:finish()
	  return
	end
	if string.find(l,"��Ķ�Ա��δ����") then

	   print("����ͬһ������!!!�쳣!!")
		 world.AppendToNotepad (WorldName().."_��������:",os.date().." ����ͬһ������!!!�쳣!! �����"..hubiao.leader_roomno.."\r\n")
		 local w=walk.new()
		 w.walkover=function()
		    world.AppendToNotepad (WorldName().."_��������:",os.date().." ���¶�λ\r\n")
		    local cmd="/hubiao:finish()"
			 main_Exe(cmd)
		 end
		 w:go(hubiao.leader_roomno)
	   return
	end
    if string.find(l,"�����ʾ���ĵĸ�л") then
	  if hubiao.master_worldID==worldID then
	    hubiao.co=nil
	    hubiao.co2=nil
	    hubiao.co3=nil
		hubiao.child_ready=false
		hubiao.master_ready=false
	    local t1=os.time()
	    print(hubiao.starttime," ���!! ",t1)
	    local t2=os.difftime(t1,hubiao.starttime)
	    print(t2,"����!")
	    local t3=math.floor(t2/60)
        world.AppendToNotepad (WorldName().."_��������:",os.date().."��ʱ:"..t3.."����\r\n")
	   end
	    hubiao:reward()
	    child_Exe("")
		child_Exe("/DeleteTrigger(\"hb_fail\")")
		main_Exe("/DeleteTrigger(\"hb_fail\")")
		local f=function()
	      hubiao:jobDone()
		end
		f_wait(f,2)
	   return
	end
	if string.find(l,"�����ڻ�û�е���Ŀ�ĵ�") then
	   print("�������ƥ��")
	   coroutine.resume(hubiao.co3)
	   return
	end
  end)
end

function hubiao:maze()
   coroutine.resume(hubiao.co2)
end

--[[
function hubiao:find_che()
     world.Send("look che")
	 wait.make(function()
	    local l,w=wait.regexp("^.*�ڳ�.*",5)
		if l==nil then
           --hubiao:find_che()
		   return
		end
		if string.find(l,"�ڳ�") then
           hubiao:Call_Partner()
		   return
		end
	 end)
end]]

--��Ҫȷ�ϸ��� id �Ƿ���һ��
function hubiao:id_follow_check()
    local hb_leader_id=world.GetVariable("hb_leader_id") or ""
	hb_leader_id=string.lower(hb_leader_id)
	world.Send("follow "..hb_leader_id)
	world.Send("set action ����")
	print("������ڷ���>",hubiao.leader_roomno)
	wait.make(function()
	  local l,w=wait.regexp("^(> |)���Ѿ��������ˡ�$|^(> |)���������.*һ���ж���$|^(> |)�趨����������action \= \"����\"$",2)
	  if l==nil then
	     self:id_follow_check()
	     return
	  end
	  if string.find(l,"���Ѿ���������") or string.find(l,"һ���ж�") then
	     --child_Exe("follow none")
		 --main_Exe("follow none")
		 world.Send("follow none")
	     main_Exe("/coroutine.resume(hubiao.co)")
	     return
	  end
	  if string.find(l,"�趨��������") then
         print("����ͬһ������!!!�쳣!!")
		 world.AppendToNotepad (WorldName().."_��������:",os.date().." ����ͬһ������!!!�쳣!! �����"..hubiao.leader_roomno.."\r\n")
		 local w=walk.new()
		 w.walkover=function()
		    world.AppendToNotepad (WorldName().."_��������:",os.date().." ���¶�λ\r\n")
		    local cmd="/hubiao:look_che()"
			 main_Exe(cmd)
		 end
		 w:go(hubiao.leader_roomno)

		 --child_Exe(cmd)
	     return
	  end
	end)

end

function hubiao:checkhere() --��鷿����Ƿ�һ��
	--print("player1:",hubiao.id1_ok," player2:",hubiao.id2_ok)

    --�Թ� �̶�·��
	if hubiao.co2~=nil then
	   print("�����Թ�")
	   hubiao:maze()
	   return
	end

    local index=hubiao.step+1
	--print(index,index)
	local r=hubiao.rooms[index]
	--print("checkhere")
	--print(hubiao.rooms[1])
	--print(r)
	if index>table.getn(hubiao.rooms) then
	   print("���� checkhere")
	   hubiao:finish()
	   hubiao.co=nil
	   --hubiao.co2=nil
	   --hubiao.co3=nil
	   return
	end
	local roomname=GetRoomName(r)
	--print(roomname,"Ŀ��")
	--

    local _R=Room.new()
    _R.CatchEnd=function()
	     --print(_R.roomname)
	    if _R.roomname==roomname then
            --�����Ƴ�
            --print("����")
            --local cmd="/hubiao:idhere()"
			--child_Exe(cmd)

			--print("�ȴ�ս��,����")
			--hubiao:check_result()


			child_Exe("/hubiao.leader_roomno="..r)
			local f=function()
			  print("����·��")
			  child_Exe("/hubiao:id_follow_check()")
            end
			f_wait(f,0.2)
			--
			--hubiao:test_path()
		else
		    --���¿�ʼ����
			--print("��ǰ��������:",_R.roomname)
			--print("Ŀ�귿������:",roomname)
			print("���¼���")
			--local location=hubiao.place
			--hubiao:get_path(location,nil)
			hubiao:look_che()
		end
	end
	_R:CatchStart()
end
--"��Ӱ�", "������", "��ũ��", "�޾���", "��ɳ��", "�����",
--	"���ΰ�", "������", "۶����", "�񻢹�", "ǧ��ׯ"
--4~7 �����
--�������ھֻ��ڵ���ʱ������                    �� �� ��
function hubiao:fight()

    world.Execute("kill jie fei;kill jie fei 2")
	child_Exe("kill jie fei 2;kill jie fei")
	child_Exe("/hubiao:fight_start()")
	hubiao:fight_start()
	hubiao:check_fight()
end

function hubiao:fight_end()
    print("��־1",hubiao.master_ready)
	print("��־2",hubiao.child_ready)
   if hubiao.master_ready==true and hubiao.child_ready==true then
      hubiao.sayword=false
      --coroutine.resume(hubiao.co)
	  world.ColourNote("red","yellow","***************************�ָ�����,����***********************")
	  hubiao:checkhere() --���
   else
      hubiao.sayword=true
	  hubiao:say()
   end
end

function hubiao:say()
   if hubiao.sayword==true then
	safe_main_Exe("say ����������ˮ��")
    safe_child_Exe("say ׳ʿһȥ�ⲻ����")
	DoAfterSpecial(5,"hubiao:say()",12)
   end
end

function hubiao:fight_finish()
    if cb.is_duo==true then
	    world.ColourNote("green","yellow","**********������ʧ**********")
		for _,weapon_item in ipairs(cb.lost_weapon_id) do
			world.Send("get " ..weapon_item.. " from corpse")
			world.Send("get "..weapon_item)
		end
		cb.lost_weapon_id={}
		cb.is_duo=false
		world.ColourNote("green","yellow","**********������ʧ ����**********")
	end
end

function hubiao:check_fight()
   wait.make(function()
		     world.Send("look")
			 world.Send("set action ս��")
			 safe_child_Exe("say С�ùԹ�,���ſ���!")
			 --^(> |)  ����������.*<ս����>|
		     local l,w=wait.regexp("^.*(۶����|��Ӱ�|������|��ũ��|�޾���|��ɳ��|�����|���ΰ�|������|�񻢹�|ǧ��ׯ)(Ů|)����.*(\<ս����\>|\<���Բ���\>).*|^(> |)�趨����������action \= \"ս��\"$",5)
			 if l==nil then
			    hubiao:check_fight()
				return
			 end
			 if string.find(l,"����") then
			    print("���ڣ�����")
				world.Send("kill jie fei")
			    wait.time(5)
				hubiao:check_fight()
			    return
			 end
			 if string.find(l,"�趨��������") then
			    shutdown()
				if hubiao.find_NPC==true then
				   hubiao:finish()
				   return
				end
				child_Exe("/shutdown()")
				world.ColourNote("red","yellow","***************************ս������***********************")
				hubiao:main_pfm() --�ָ���ʼpfm ����
				hubiao:fight_finish()
				child_Exe("/hubiao:fight_finish()")
				world.Execute("get silver from corpse;get silver from corpse 2")
				hubiao.sayword=true
				hubiao:say()
			    hubiao:recover()
				child_Exe("/hubiao:recover()")

			    return
			 end

	end)
end

function hubiao:run(i)
--[[> ��� "pfm" �趨Ϊ "halt;east;set action ����" �ɹ���ɡ�
> �趨����������wimpy = 100
> �趨����������wimpycmd = "pfm\hp"
> ������ʹ�á��ļ�ɢ��������ʱ�޷�ֹͣս����
��ת���Ҫ��������ҷ�һ����ס��
������ʧ�ܡ�
�趨����������action = "����"]]

   wait.make(function()
	   local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)������ʧ�ܡ�$|^(> |)������ʹ��.*��ʱ�޷�ֹͣս����$|^(> |)�����Ϊ������$|^(> |)�趨����������action \\= \\\"����\\\"$",1.5)
	   if l==nil then
	      hubiao:run(i)
	      return
	   end
	   if string.find(l,"�����Ϊ����") then
	     i=i+1
		 hubiao:flee(i)
	     return
	   end
	   if string.find(l,"��Ķ�����û����ɣ������ƶ�") or string.find(l,"������ʧ��") or string.find(l,"��ʱ�޷�ֹͣս��") then
		  hubiao:run(i)
	      return
	   end
	   if string.find(l,"�趨����������action") then
		 world.DoAfter(1.5,"set action ����")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"����\\\"$|^(> |)�趨����������action \\= \\\"����\\\"$",5)
			if l==nil then
			   hubiao:run(i)
			  return
			end
			if string.find(l,"����") then
			    i=i+1
		        hubiao:flee(i)
			   return
			end
			if string.find(l,"����") then


			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function hubiao:flee()
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
     print("Ѱ�ҳ���")
     local dx=_R:get_all_exits(_R)
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil or i>table.getn(dx) then
	    --����������
	     local n=table.getn(dx)
	     i=math.random(n)
		 print("���:",i)
	 end
	 local run_dx=dx[i]
	 --print(run_dx, " ����")
	 local halt
	 if _R.roomname=="ϴ��ر�" then
	    world.Send("alias pfm "..run_dx..";set action ����")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set action ����")
	 end
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
	 hubiao:run(i)
   end
   _R:CatchStart()
end

function hubiao:fight_start()

	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
	   --world.Execute(pfm)
	   cb=fight.new()
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	   cb.unarmed_alias=unarmed_pfm
      cb:before_kill()
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 and tonumber(hp.qi_percent)>30 then
	      print("���ڰ�ȫ���ó�ҩ")
		  world.Send("fu dahuan dan")
	     end
		 if tonumber(hp.qi_percent)<=30 then
	      print("���ڰ�ȫ���ó�ҩ")
		  hubiao:flee()
	     end
      end
	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("ж������")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("ս������")
		  local worldID=GetWorldID()
	      if hubiao.master_worldID==worldID then
		     hubiao:check_fight()
		  else
		     world.DoAfterSpecial(10,"bow",10)
			 hubiao:recover()
		  end
		  --hubiao:recover()
	  end
	  cb.neili_lack=function()
	     print("��������")
		 world.Send("fu dahuan dan")
	  end
	  cb:start()
end

function hubiao:special_east()
     local b=busy.new()
	b.interval=0.5
	b.Next=function()
		hubiao:tui("east")
		 --hubiao:checkhere()
	end
	b:check()
end
hubiao.alias["special_east"]=function() hubiao:special_east() end

function hubiao:guangfobaodian_songshuyuan()
   local f=function()
		hubiao:tui("northdown")
	end
    hubiao:break_in("benyin dashi",f,nil)
end
hubiao.alias["guangfobaodian_songshuyuan"]=function() hubiao:guangfobaodian_songshuyuan() end

function hubiao:shanlu_songlin()
   local p={"east","west","east","south","east","north","north","east","west"}
	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("��һ��")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("����!!!")
	   hubiao.co2=nil
	   hubiao:checkhere()
   end)
   coroutine.resume(hubiao.co2)
end
hubiao.alias["shanlu_songlin"]=function() hubiao:shanlu_songlin() end

function hubiao:yamen_cucangshi()
   local f=function()
		hubiao:tui("south")
	end
    hubiao:break_in("kill ya yi|kill ya yi|kill ya yi|kill ya yi|kill ya yi",f,nil)
end
hubiao.alias["yamen_cucangshi"]=function() hubiao:yamen_cucangshi() end

function hubiao:yamendamen_yamenzhengting()
    local f=function()
		hubiao:tui("north")
	end
    hubiao:break_in("kill ya yi|kill ya yi|kill ya yi|kill ya yi|kill ya yi",f,nil)
end
hubiao.alias["yamendamen_yamenzhengting"]=function() hubiao:yamendamen_yamenzhengting() end

function hubiao:dongkou_shandong()
    local f=function()
		hubiao:tui("enter")
	end
    hubiao:break_in("kill sheng xiong",f,nil)
end
hubiao.alias["dongkou_shandong"]=function() hubiao:dongkou_shandong() end

function hubiao:xiaojing_xixiangzoulang()
	local f=function()
		hubiao:tui("west")
	end
    hubiao:break_in("kill yu lianzhou",f,nil)
end
hubiao.alias["xiaojing_xixiangzoulang"]=function() hubiao:xiaojing_xixiangzoulang() end

function hubiao:baishilu_banzuyuan()
    local f=function()
		  hubiao:tui("east")
	 end
    hubiao:break_in("kill chanshi|kill wu seng|kill wu seng",f,nil)
end
hubiao.alias["baishilu_banzuyuan"]=function() hubiao:baishilu_banzuyuan() end

function hubiao:xiaojing_dongxiangzoulang()
    local f=function()
	  hubiao:tui("east")
	 end
    hubiao:break_in("kill yu lianzhou",f,nil)
end
hubiao.alias["xiaojing_dongxiangzoulang"]=function() hubiao:xiaojing_dongxiangzoulang() end

function hubiao:paths(path,rooms)
   hubiao.steps={}
   hubiao.steps=Split(path,";")
   hubiao.rooms={}
   hubiao.rooms=rooms
   --print(rooms[1]," test")
   hubiao.step=1
   --��ʼ��
   --
   --hubiao:test_path()
   hubiao:do_tui()
end

function hubiao:giveup()

   world.AppendToNotepad (WorldName().."_��������:",os.date().." �޷�����ص�"..hubiao.place..": ��������\r\n")
   local b=busy.new()
   b.Next=function()
   child_Exe("tui north")
   world.Send("tui north")
   print("�޷�����ķ��䣡")
   local f=function()
     hubiao:jobDone()
     child_Exe("/hubiao:jobDone()")
   end
   f_wait(f,2)
  end
  b:check()
end

function hubiao:get_path(location,opentime)  --ȷ����������

  local n,e=Where(location) --��ⷿ����
  print("������",n)
  for _,r in ipairs(e) do
     print(r)
  end
  if n==0 then
     hubiao:giveup()
     return
  end
  local last_target_room=-999
  hubiao.co3=coroutine.create(function()

   for _,target_room in ipairs(e) do
    local f=function(r)
	    local mp=map.new()
	    mp.Search_end=function(path,room_type,rooms)
            if string.find(path,"noway;") or path=="" then
			   hubiao:giveup()
			   return
			end
			print("�Ƴ�·��:",path)
			--tprint(rooms)
			hubiao:paths(path,rooms)
	    end
		local room
		--print("����·��:",r[1],"->",target_room)
        if table.getn(r)==1 then
		   room=r[1]
		else
		   print("�������ƥ��!!�޷���λ!")
		   for _,roomno in ipairs(r) do
			  if roomno==last_target_room then
			    room=last_target_room
			    break
			  end
		   end
		   print("��󷿼�:",last_target_room," �Ƿ�ƥ�� ", room)
		end
		print("����·��:",room,"->",target_room)
		last_target_room=target_room
        mp:Search(room,target_room,opentime)
	end
	WhereAmI(f,10000) --�ų����ڱ仯
	coroutine.yield()
   end
  end)
  --local b=busy.new()
  --b.interval=2
  --b.Next=function()
     --hubiao:main_pfm() --����pfm
     coroutine.resume(hubiao.co3)
  --end
  --b:check()
end
--�������ھֻ��ڵ���ʱ������                    �� �� ��
function hubiao:fail(id)

end


function hubiao:update_title(Place,NPC)
 	local ts={
	           task_name="����",
	           task_stepname="����",
	           task_step=2,
	           task_maxsteps=3,
	           task_location=Place,
	           task_description="Ѱ��"..NPC,
	       }
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
end
--������˵����������û������Ҫ�ͼ�׳ʿ������


function hubiao:look_che()
--��ɫ����
   world.Send("look che")
   wait.make(function()

   local l,w=wait.regexp("^(> |)��֧�����ɸ����ھ���ʦ.*$",5)


   if l==nil then
      shutdown()
      self:ask_job()
      return
   end

   if string.find(l,"��֧�����ɸ����ھ���ʦ") then

   --^(> |)��֧�����ɸ����ھ���ʦ(.*)�����͵�(.*)���ϵġ�$
      local line=world.GetLinesInBufferCount()
      local t=GetStyleInfo (line)     -- get all styles, all types for line 71

      local is_match=false
      local Place=""
      local NPC=""
	  local player_name=world.GetVariable("player_name") or ""
	  local tt={}
	   for k, v in pairs (t) do

	    local text=(v.text)
		print(text)

        if string.find(text,"��֧�����ɸ����ھ���ʦ"..player_name) then

	       is_match=true
	    elseif string.find(text,"���ϵ�") then
	       local n=table.getn(tt)
		   NPC=tt[n]
		   table.remove(tt,n)
		   for _,P in ipairs(tt) do
		     Place=Place..P
		   end

           print(Place," place ",NPC," npc")
		   self:restart(Place,NPC)
	    else
	      if is_match==true then
		   table.insert(tt,text)
		  end
	    end
	   end
      return
    end
  end)
end

function hubiao:restart(Place,NPC)
   hubiao.find_NPC=false
		  child_Exe("/hubiao.find_NPC=false")


		  	local ts={
	           task_name="����",
	           task_stepname="����",
	           task_step=2,
	           task_maxsteps=3,
	           task_location=Place,
	           task_description="Ѱ��"..NPC,
	       }
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
		 child_Exe("/hubiao:update_title('"..Place.."','"..NPC.."')")

		 world.AppendToNotepad (WorldName().."_��������:",os.date().."�ص�:"..Place.." "..NPC.."\r\n")
		 hubiao.starttime=os.time()
		 hubiao:main_pfm() --����2 id pfm
		 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��������:"..Place.." "..NPC, "white", "black")
		  hubiao.place=Place
		  hubiao.NPC=NPC

		  child_Exe("/hubiao.NPC='"..NPC.."'")

           dangerous_man_list_clear()
		   child_Exe("/dangerous_man_list_clear()")

		  local b=busy.new()
		  b.Next=function()

		   local f=function()

  		    local al=alias.new()
		    al.finish=function(result)
		      local b=busy.new()
			  b.interval=2
			  b.Next=function()
			    world.Send("follow none")
				child_Exe("follow none")
				hubiao:shield()
				child_Exe("/hubiao:shield()")

	            hubiao:get_path(Place,result)
			  end
			  b:check()
	        end
	        al:opentime("fuzhouchengximen")
		   end
		   f_wait(f,2)
		  end
		  b:check()
end

function hubiao:ask_job()
--������˵����������·;Σ�գ�����ô�ٵ��ˣ��ҿɲ����ġ���
  local w=walk.new()
  w.walkover=function()
    world.Send("ask lin about ����")
	--world.Send("look che")
	world.Send("set action ѯ��")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)������˵�������뻤����һ��������(.*)��(.*)���С���$|^(> |)������˵�������ף���ô�����˲�ȫ����(.*)��ôû������$|^(> |)�趨����������action \\= \\\"ѯ��\\\"$|^(> |)������˵������һֱ���ں�����ģ��ҿ���λ.*����ȥЪϢƬ�̰ɣ���$|^(> |)������˵����������·;Σ�գ�����ô�ٵ��ˣ��ҿɲ����ġ���$",5)
	   if l==nil then
          hubiao:ask_job()
	      return
	   end
	   if string.find(l,"�뻤����һ��������") then
	      shutdown()
		  hubiao.find_NPC=false
		  child_Exe("/hubiao.find_NPC=false")
	      local NPC=w[3]
		  local Place=w[2]
		  	local ts={
	           task_name="����",
	           task_stepname="����",
	           task_step=2,
	           task_maxsteps=3,
	           task_location=Place,
	           task_description="Ѱ��"..NPC,
	       }
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
		 child_Exe("/hubiao:update_title('"..Place.."','"..NPC.."')")

		 world.AppendToNotepad (WorldName().."_��������:",os.date().."�ص�:"..Place.." "..NPC.."\r\n")
		 hubiao.starttime=os.time()
		 hubiao:main_pfm() --����2 id pfm
		 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��������:"..Place.." "..NPC, "white", "black")
		  hubiao.place=Place
		  hubiao.NPC=NPC

		  child_Exe("/hubiao.NPC='"..NPC.."'")

           dangerous_man_list_clear()
		   child_Exe("/dangerous_man_list_clear()")

		  local b=busy.new()
		  b.Next=function()

		     print("HB��һ��")

             main_Exe("tui north")
			 child_Exe("follow none")
			 main_Exe("follow none")

		   local f=function()
		     child_Exe("north")
		     main_Exe("north")

  		    local al=alias.new()
		    al.finish=function(result)
		      local b=busy.new()
			  b.interval=2
			  b.Next=function()
			    world.Send("follow none")
				child_Exe("follow none")
				hubiao:shield()
				child_Exe("/hubiao:shield()")

	            hubiao:get_path(Place,result)
			  end
			  b:check()
	        end
	        al:opentime("fuzhouchengximen")
		   end
		   f_wait(f,2)
		  end
		  b:check()
	      return
	   end
	   if string.find(l,"����ȥЪϢƬ�̰�") then
	      local b=busy.new()
		  b.Next=function()
            world.Send("follow none")
			child_Exe("follow none")
	        self:jobDone()
			child_Exe("/hubiao:jobDone()")
		  end
		  b:check()
	      return
	   end
	   if string.find(l,"��ô�����˲�ȫ��") or string.find(l,"����·;Σ�գ�����ô�ٵ���") then
	   --����id ����һ������
	     hubiao.master_ready=false
		 hubiao.child_ready=false

	     local b=busy.new()
		 b.Next=function()
	      --hubiao:team()
		     print("�˲�ȫ�����¼���!!")
            world.Send("follow none")
			world.AppendToNotepad (WorldName().."_��������:",os.date().." �˲�ȫ�����¼���\r\n")
		    hubiao:start()
			child_Exe("follow none")
			child_Exe("/shutdown()")
			child_Exe("/hubiao:start()")

		 end
		  b:check()
	      return
	   end
	   if string.find(l,"�趨����������action") then
	      hubiao:look_che()
	      return
	   end
	   --[[
	   if string.find(l,"����û������Ҫ") then
	      local b=busy.new()
		  b.Next=function()
	        -- world.Send("follow none")
            --child_Exe("follow none")
	        --hubiao.fail(101)
		    --child_Exe("/hubiao.fail(101)")
			 local f=function()
			    hubiao:ask_job()
			 end
			 f_wait(f,5)
		  end
		  b:check()
	      return
	   end]]
	 end)
  end
  w:go(1335)
end


--�����㻤��ʧ�ܣ������ھֵ���ʮ���ƽ������⳥�ˡ�
function hubiao:lineup()
   world.Send("lineup form wuxing-zhen")
   world.Send("lineup with "..string.lower(hubiao.partner1_id))
   child_Exe("lineup with "..string.lower(world.GetVariable("player_id")))
end

function hubiao:continue()
   coroutine.resume(hubiao.co)
end

function hubiao:Partner_to(ToRoomNo)
  local b=busy.new()
  b.Next=function()
     local w=walk.new()
	 w.walkover=function()
		local cmd="/hubiao:Call_Partner_Over()"
		local worldID=GetWorldID()
	    if hubiao.master_worldID==worldID then
	       --��id
            child_Exe(cmd)
	    else
	      --��id
			main_Exe(cmd)
	    end
	 end
	 w:go(ToRoomNo)
  end
  b:check()
end
--�ص�����
function hubiao:Call_Partner_Over()
   local worldID=GetWorldID()
   local partner_id=""
	if hubiao.master_worldID==worldID then
	   --�����id player_id
		local otherworld=GetWorldById(hubiao.child_worldID)
		partner_id=string.lower(otherworld:GetVariable("player_id"))
	else
		local otherworld=GetWorldById(hubiao.master_worldID)
        partner_id=string.lower(otherworld:GetVariable("player_id"))
	end
	world.Send("follow "..partner_id)
--follow zhang
--����û�� zhang��

	wait.make(function()
	   local l,w=wait.regexp("^(> |)����û��.*$|^(> |)���������.*һ���ж���$",5)
	   if l==nil then
		   hubiao:Call_Partner_Over()
		  return
	   end
	   if string.find(l,"����û��") then
	      wait.time(1)
		  hubiao:Call_Partner()
		  return
	   end
	   if string.find(l,"���������") then
	        --��һ�� ��һ��
		  world.Send("follow none")
		  --�ص���id �� together
		  local cmd="/hubiao:look_che()"
		  main_Exe(cmd)
	      return
	   end
	end)

end
-- ���д
function hubiao:Call_Partner()
   local _R=Room.new()
    _R.CatchEnd=function()
	   local count,roomno=Locate(_R)
	   print("��ǰ�����",roomno[1])
	   local cmd="/hubiao:Partner_to("..roomno[1]..")"
       local worldID=GetWorldID()
	   if hubiao.master_worldID==worldID then
	       --��id
		  child_Exe(cmd)
	    else
	       --��id
          main_Exe(cmd)
	    end
	end
	_R:CatchStart()
end

function hubiao:wait_stop()
    shutdown()
	--child_Exe("/hubiao.timestamp=nil")
	--hubiao.timestamp=hubiao.timestamp
	world.ColourNote("red", "yellow", os.date()..":��������׼����ʼ��������������������")
	local b=busy.new()
	b.Next=function()
	   if hubiao.master_worldID==GetWorldID() then
	      hubiao:main_link()
	   end
	end
	b:check()
end


function hubiao:wait_another_player()
	print("*******************�ڹ�����**************************")
	world.Send("unset ����")
	local b=busy.new()
	b.interval=0.5
	b.Next=function()
		local xiulian=world.GetVariable("xiulian") or ""
		if xiulian=="xiulian_jingli" then
			process.neigong2()
		elseif xiulian=="xiulian_neili" then
			process.neigong3()
		else
			process.neigong3()
		end
	end
	b:check()
end

local child_master_ready=false
local child_child_ready=false

function hubiao:return_child_flag(m_ready,c_ready)
   child_master_ready=m_ready
   child_child_ready=c_ready
end

function hubiao:update_status()
   --����id �Ż�ִ��
   if hubiao.master_ready==true and hubiao.child_ready==true then
			main_Exe("/hubiao:return_child_flag(true,true)")
	elseif hubiao.master_ready==false and hubiao.child_ready==true then
			main_Exe("/hubiao:return_child_flag(false,true)")
	elseif hubiao.master_ready==true and hubiao.child_ready==false then
			main_Exe("/hubiao:return_child_flag(true,false)")
	elseif hubiao.master_ready==false and hubiao.child_ready==false then
			main_Exe("/hubiao:return_child_flag(false,false)")
	end
end

function hubiao:fail_log()
  -- sj.log_catch(WorldName()..'����ʧ�ܼ�¼',5)
  local worldID=GetWorldID()
   if hubiao.master_worldID==worldID then
		world.AppendToNotepad (WorldName().."_��������:",os.date().." ����ʧ��!!\r\n")
  end

end

function hubiao:Partner_is_ready(id)
--��� �� id master_ready child_ready  ���� id master_ready child_ready
--3 true 1 false ׼��������ʼ����
    print(hubiao.master_ready," ? ",hubiao.child_ready)
	print(child_master_ready," ? ",child_child_ready)
   if (hubiao.master_ready==true and hubiao.child_ready==true and child_master_ready==false and child_child_ready==true) or (hubiao.master_ready==true and hubiao.child_ready==false and child_master_ready==true and child_child_ready==true) then
      --���� ����ֹͣ׼����������
	  hubiao.child_ready=false
	  hubiao.master_ready=false
      hubiao:wait_stop() --��id ֹͣ
	  print("ɾ����ʱ��ʱ��")
	  world.DeleteTimer("hubiao_outoftime")
	  child_Exe("/hubiao:wait_stop()")
	  child_Exe("/print('ɾ����ʱ��ʱ��')")
	  child_Exe("/world.DeleteTimer(\"hubiao_outoftime\")")
	  return
   end
   --print("id:",id)
   if id=="leader" then
      print("�ӳ��ȴ���")
	  hubiao:wait_another_player()
   end

end

local wait_count=1
function hubiao:countdown()
   if (hubiao.master_ready==true and hubiao.child_ready==true and child_master_ready==false and child_child_ready==true) or (hubiao.master_ready==true and hubiao.child_ready==false and child_master_ready==true and child_child_ready==true) then
      return
   end

   if (300-wait_count*10)<0 then
      return
   end
    world.Send("cond")
   print(300-wait_count*10," �ȴ����ѵ���ʱ!!")
   wait_count=wait_count+1
   wait.make(function()
      local l,w=wait.regexp("!!!!!!!",10)
	  if l==nil then
	     hubiao:countdown()
	     return
	  end
   end)
end

function hubiao:wait_outoftime()
    print("���ڵȴ���ʱ!!!")
    shutdown()
	local old_jobslist=world.GetVariable("jobslist") or ""
	local jobslist=world.GetVariable("hb_jobslist") or ""
	world.SetVariable("jobslist",jobslist)
	hubiao.master_ready=false --�رջ��ڵ��жϱ���
    hubiao.child_ready=false --�رջ����жϱ���
	local hb_auto=world.GetVariable("hb_auto") or false
	if hb_auto=="true" then
	   world.AddTimer("hubiao_reset", 0, 5, 0, "SetVariable('jobslist','"..old_jobslist.."')\nprint('jobslist ���ó�"..old_jobslist.."')", timer_flag.Enabled +timer_flag.OneShot+timer_flag.Replace + timer_flag.ActiveWhenClosed, "")
	   world.SetTimerOption ("hubiao_reset", "send_to", 12)
	end
	--��������������
	local b=busy.new()
	b.Next=function()
	  local f=function()
	     hubiao:jobDone()
	  end
	  f_wait(f,2)
	end
	b:check()
end

function hubiao:Partner_Status_Check()
    --cond �Ѿ�ok ��
   --�Ƿ���id
   --��id ����
   --print(hubiao.timestamp)
    world.AddTriggerEx ("hb_fail", "^(> |)�����㻤��ʧ�ܣ������ھֵ���ʮ���ƽ������⳥�ˡ�$", "shutdown();hubiao:fail_log();Weapon_Check(process.hb)", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)

		local ts={
	           task_name="����",
	           task_stepname="�ȴ����",
	           task_step=0,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
		}
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
        --hubiao.timestamp=os.time()

		local leader_id=world.GetVariable("hb_leader_id") or "" --�ӳ�id

		local partner_id=world.GetVariable("hb_partner_id") or ""
       if partner_id=="" or leader_id=="" then
	        print("hb_partner_id �� hb_leader_id ����û������")
	        return
       end
	   hubiao.child_ready=false
       hubiao.master_ready=false
       --print(hubiao.master_worldID)
       for k, v in pairs (GetWorldIdList ()) do
          local player_id=GetWorldById (v):GetVariable("player_id")
	      if string.lower(player_id)==string.lower(partner_id) then
	        hubiao.partner1_id=string.lower(partner_id)
	        hubiao.child_worldID= v
	      end
	      if string.lower(player_id)==string.lower(leader_id) then

	         hubiao.master_worldID= v

		  end
       end
	   --2�� id 4 �����ֵ
	   -- �� id master_ready=true child_ready=true  ���� id master_ready=false

		 print("��:",hubiao.master_worldID)
         print("����:",hubiao.child_worldID)
		 if hubiao.master_worldID==GetWorldID() then
            --�ӳ�id ����
            --hubiao.child_ready=false
			--��¼��������ʱ��

			--safe_child_Exe("say ֪ͨ����,�ӳ���λ!!!")
			local hb_cmd=world.GetVariable("hb_cmd") or ""
			if hb_cmd~="" then
			   child_Exe("/"..hb_cmd)
			end
            hubiao.master_ready=true
			child_Exe("/hubiao.master_ready=true")
			child_Exe("/hubiao:update_status()")
			hubiao:Partner_is_ready("leader")
			-- ����ȴ���ʱ 5����
			world.AddTimer("hubiao_outoftime", 0, 5, 0, "hubiao:wait_outoftime()", timer_flag.Enabled +timer_flag.OneShot, "")
            world.SetTimerOption ("hubiao_outoftime", "send_to", 12)
			wait_count=1
			hubiao:countdown()
            --world.DoAfterSpecial(300,"",12)
		else
			--����id ����
			hubiao.child_ready=true
			main_Exe("/hubiao.child_ready=true")
			--����ֵ
			if hubiao.master_ready==true and hubiao.child_ready==true then
			  main_Exe("/hubiao:return_child_flag(true,true)")
			elseif hubiao.master_ready==false and hubiao.child_ready==true then
			   main_Exe("/hubiao:return_child_flag(false,true)")
			elseif hubiao.master_ready==true and hubiao.child_ready==false then
			   main_Exe("/hubiao:return_child_flag(true,false)")
			elseif hubiao.master_ready==false and hubiao.child_ready==false then
			   main_Exe("/hubiao:return_child_flag(false,false)")
			end
			--safe_main_Exe("say ֪ͨ�ӳ���λ��������")
			--safe_child_Exe("say �����Ѿ�λ!!!")
			local hb_cmd=world.GetVariable("hb_cmd") or ""
			if hb_cmd~="" then
			   main_Exe("/"..hb_cmd)
			end
			print("*************************************")
			hubiao:wait_another_player()
			world.AddTimer("hubiao_outoftime", 0, 5, 0, "hubiao:wait_outoftime()", timer_flag.Enabled+timer_flag.OneShot , "")
            world.SetTimerOption ("hubiao_outoftime", "send_to", 12)
			main_Exe("/hubiao:Partner_is_ready()")
			wait_count=1
			hubiao:countdown()
            print("*****************����********************")
		end


end
