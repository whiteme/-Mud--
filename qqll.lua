--[[ 1:  ������������������������������������������������������������
 2:                 ����������������ܡ��������ڣ�
 3:  ������������������������������������������������������������
 4:
 5:      ���껪ɽ�۽���ȫ�������������˻���ˡ�����ͨ���ĳƺš���
 6:  ϧ��������������Ȼ�����ϳ���ѧ��ȴ����������ɽ�С�����������
 7:  ʱ���͸�������������һ��һ��������˾��ȵ��ǣ���Щ�����
 8:  ���������䱦��Ҳ�����书�ؼ�������Щ��ֵ�����֮�������ʢ
 9:  ����Щ�����������̺��ż�������ܡ�
10:
11:      ���У������������ȫ���ƽ����ڵõ�����һ�����õ�ʯͷ����
12:  ����ʯ�����ڶ�����һֱ��Ѱ���ܹ��ɽ������⿪��ʦ���µ������
13:  �š�
14:
15:  ������������������������������������������������������������
16:                          ������Ҫ��
17:  ������������������������������������������������������������
18:
19:      ����֮�������
20:      �ӳ�Ҫ���侭��ȶ�Ա��4�������£�1�������ϡ�
21:      �ӳ�Ҫ���������/֯����/ũɣ��/�ɿ���������һ����220��
22:  ���ϡ�
23:
== ��ʣ 41 �� == (ENTER ������һҳ��q �뿪��b ǰһҳ)

24:  ������������������������������������������������������������
25:                          ��������̡�
26:  ������������������������������������������������������������
27:
28:      ������ɽ�������ҵ����ڣ�������Ӻ��ɶӳ�������ֵ�͵�һ
29:  �ˣ�ask ma about ����ʯ��ask ma about job ������
30:      ���ڻ�����㣬��һλ�������˴�����Ҳ��֪������ʯ�����ܲ�
31:  ��������ʯ������������˵��ĳһλ��Ϸ�е����֪�����˵�λ�á�
32:  ���ȥѰ�Ҵ��ˣ� ask player-id about ����������ʱ��Ҫask�ü�
33:  �Σ��Ϳ�֪����������λ�á�Ȼ����һ���follow���ɶӳ���·
34:  ���ߣ�һ·�ϣ������������������������ɱ�������顣ɱ�ֻ�Զ�
35:  ����ɱ���������ֽ���Щɱ�ֻ��˺��������������ֵ�λ�ã��ҵ�
36:  �����������û��ɱ���㹻��ɱ�֣���������������֣���ask lan
37:  about ����ʯ����������������ʯ���������
38:
39:      ��ʱ��������ֲ�ͬ�������
40:      ���һ�Ǵ����������ɹ��������������ʯֻ������һ����Ϊ��
41:  �������ʯ�������ܳ�Ϊ�����һص����ڴ�ask ma about ���
42:  �õ���������
43:      ������Ǵ�����������ң�����ʵֻ�Ǹ��߽����Ļ�졣��һ�
44:  �����ڴ� ask ma about ��ɣ����õ����ٵ���������
45:
46:      �������������������������ʯ������Ŀ�Լ����������´���
== ��ʣ 18 �� == (ENTER ������һҳ��q �뿪��b ǰһҳ)

47:  ���������塣��һص����ڴ� ask ma about ��ɣ��õ���������
48:  �������ڻ��һ�顾���������񡿸���ӳ���
49:
50:      ��������У���Ҷ�ʧ������ʯ��������ʧ�ܡ����Ҳ�����Լ�
51:  ȥask ma about ��������������
52:
53:
54:  ������������������������������������������������������������
55:                          ��������ܡ�
56:  ������������������������������������������������������������
57:
58:      ��������Ѷȴ���������������һ�������ƣ�û�и߳��Ĵ�
59:  ��ϵ�м����޷������񣬻���ҪѰ�Һ��ʵĺ�����飻��Ȼɱ�ֲ�ֱ
60:  ��ɱ����ң���Σ��ϵ�����Ǻܸߣ�����ҪѰ�Ҵ�������λ�ã�����
61:  �ҵ�������player������������˵�������Ǻ��ʺ���Ϊ��ҵ���ѡ��
62:  �񡣵�Ψһ���˵��ǣ������������ǿ顾���������񡿣���Ȼ������
63:  ������ľ�����;�����ƺ��������߼��������ܵı��豦�
64:  ]]
-- ��· ս�� �ָ�
--require "wait8"
require "wait"
qqll={
  new=function()
     local ql={}
	 ql.uid=string.sub(CreateGUID(),25,30)
	 setmetatable(ql,{__index=qqll})
	 return ql
  end,
  co=nil,
  neili_upper=1.5,
  uid="",
  child_worldID="",
  master_worldID="",
  look_player=false,
  look_player_place="",
  playername="",
  playerid="",
  rooms={},
  wait_count=0,
  is_find=false,
  starttime=0,
  target={},
  stop=false,
  robbername="",
  master_ready=false,
  child_ready=false,
}

local heal_ok=false

local function child_Exe(cmd)
  local otherworld=GetWorldById(qqll.child_worldID)
   if otherworld ~= nil then
     otherworld:Execute(cmd)
   end
end

local function main_Exe(cmd)
  local mainworld=GetWorldById(qqll.master_worldID)
   if mainworld ~= nil then
     mainworld:Execute(cmd)
   end
end

function qqll:main_link()
   local leader_id=world.GetVariable("qqll_leader_id") or ""
   local partner_id=world.GetVariable("qqll_partner_id") or ""
   if partner_id=="" then
	  print("qqll_partner_id ����û������")
	  return
   end
    if leader_id=="" then
	  print("qqll_leader_id ����û������")
	  return
   end

   qqll.child_ready=false
   qqll.master_ready=false

    for k, v in pairs (GetWorldIdList ()) do
      local player_id=GetWorldById (v):GetVariable("player_id") or ""
	  if string.lower(player_id)==string.lower(leader_id) then
	    qqll.master_worldID=v
	    break
	  end
	end
   print(qqll.master_worldID," master_worldID")
   for k, v in pairs (GetWorldIdList ()) do
    local player_id=GetWorldById (v):GetVariable("player_id") or ""
	if string.lower(player_id)==string.lower(partner_id) then
	   print(player_id)
	  if v~=qqll.master_worldID then
	        qqll.partner1_id=string.lower(partner_id)
	        qqll.child_worldID= v
	   break
	  end
	end
  end
  print(qqll.child_worldID," child_worldID")
  --����id ��������
  local cmd="/qqll.master_worldID='"..qqll.master_worldID.."'"
  child_Exe(cmd)
  main_Exe(cmd)

  cmd="/qqll.child_worldID='"..qqll.child_worldID.."'"
  child_Exe(cmd)
  main_Exe(cmd)

  local leitai=world.GetVariable("qqll_leitai")
  cmd="/SetVariable('qqll_leitai',"..leitai..")"
  child_Exe(cmd)
  main_Exe(cmd)

  cmd="/qqll:Status_Check()"
  child_Exe(cmd)
  main_Exe(cmd)
end

function qqll:team()
   local player_id=world.GetVariable("player_id")
   local otherworld=GetWorldById(qqll.child_worldID)
   local parter_id=otherworld:GetVariable("player_id")
   print("��id",parter_id)
   print("��id",player_id)
   world.Send("team dismiss")
   child_Exe("team dismiss")
   world.Send("team with "..string.lower(parter_id))
   world.Send("follow "..string.lower(parter_id))
   local f=function()
     child_Exe("team with "..string.lower(player_id))
     child_Exe("follow "..string.lower(player_id))
	 qqll:ask_job()
   end
   f_wait(f,2)
   --
end

function qqll:main_pfm()
  local otherworld=GetWorldById(qqll.child_worldID)
  local mainworld=GetWorldById(qqll.master_worldID)
  local pfm1=mainworld:GetVariable("qqll_pfm") or ""
  local pfm2=otherworld:GetVariable("qqll_pfm") or ""

  local _pfm1=mainworld:GetVariable(pfm1)
  local _pfm2=otherworld:GetVariable(pfm2)

  main_Exe("/Send('alias pfm ".._pfm1.."')")
  child_Exe("/Send('alias pfm ".._pfm2.."')")
end

--full
function qqll:full()
    local liao_percent=world.GetVariable("liao_percent") or 80
	liao_percent=tonumber(liao_percent)
	local qi_percent=world.GetVariable("qi_percent") or 100
	qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100
	local vip=world.GetVariable("vip") or "��ͨ���"
    local h
	h=hp.new()
	h.checkover=function()
	   -- print(h.food,h.drink)
	   --print(h.qi_percent,"��Ѫ�ٷְ� ",h.qi,"��Ѫ ",heal_ok," heal_ok")
	    if (h.food<50 or h.drink<50) and vip~="������" then
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
				    qqll:Status_Check()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(1960) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif h.jingxue_percent<=80 or (h.qi_percent<=liao_percent and heal_ok==false) then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   --heal_ok=true
			   qqll:full()
			end
			rc:liaoshang()
        elseif h.jingxue_percent<100 then
		    print("��ͨ����")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   qqll:full()
			end
			rc:heal(false,true)
		elseif h.qi_percent<qi_percent and heal_ok==false  then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			   heal_ok=true
			   qqll:full()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*qqll.neili_upper) then
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
   				     qqll:full()
				   end  --���
				   f_wait(f,0.5)
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(643)
		 	   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*qqll.neili_upper) then
			     qqll:start()
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
			  heal_ok=false
			  qqll:start()
			end
			b:check()
		end
	end
	local b=busy.new()
	b.Next=function()
	  h:check()
	end
	b:check()
end

local list=""
local tb_who={}
function qqll:wholist(info)
   if string.find(info,"����������������") then
   elseif string.find(info,"λ���������") then
       world.EnableTrigger("wholist",false)
	   world.DoAfterSpecial(0.1,"DeleteTrigger('wholist')",12)
		--print(list)
		local who={}
		who=Split(list," ")
		local party=""
		local playername=""
		local playerid=""
		local status=""
		 tb_who={}
		for _,w in ipairs(who) do
		   if Trim(w)~="" then
		      --print(w)
			  if string.find(w,"��") then
			     party=w
			  else
			     local s,e=string.find(w,"%(")
				 playername=string.sub(w,1,s-1)
				 playerid=string.sub(w,e+1,string.len(w)-1)
				 playerid=string.lower(playerid)
				 if string.find(playername,"%*") then
				     status="����"
				 elseif string.find(playername,"%+") then
				     status="����"
				 else
				    status=""
				 end
				 --print(playername," ",playerid," ",party," ",status)
				 tb_who[playerid]={}
				 tb_who[playerid].name=playername
				 tb_who[playerid].party=party
				 tb_who[playerid].status=status
			  end
		   end
		end
		qqll:wanted()
   else
        --print(info)
       list=list..info
   end
end

local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    --print("��ǰ����:",v)
	    if v==r then
		   --print("��ͬ")
		   return true
		end
	end
	--print("��ͬ")
	return false
end

local function get_dir(dx)
   if dx=="up" then
      return "down"
	elseif dx=="down" then
	   return "up"
   elseif dx=="east" then
      return "west"
	elseif dx=="west" then
	  return "east"
	elseif dx=="north" then
	  return "south"
	elseif dx=="south" then
	  return "north"
	elseif dx=="northwest" then
	  return "southeast"
	elseif dx=="northeast" then
	  return "southwest"
	elseif dx=="southwest" then
	   return "northeast"
	elseif dx=="southeast" then
	   return "northwest"
	elseif dx=="enter" then
	  return "out"
	elseif dx=="out" then
	  return "enter"
	elseif dx=="southdown" then
	  return "northup"
	elseif dx=="northup" then
	  return "southdown"
	elseif dx=="eastup" then
	  return "westdown"
	elseif dx=="westdown" then
	   return "eastup"
	elseif dx=="northdown" then
	   return "southup"
	elseif dx=="southup" then
	   return "northdown"
	elseif dx=="eastdown" then
	    return "westup"
	elseif dx=="westup" then
	    return "eastdown"
   end
end

function qqll:recover_check()
   if qqll.master_ready==true and qqll.child_ready==true then
      qqll.master_ready=false
	  qqll.child_ready=false
	   qqll:back() --2��id ���ص���̨
	   child_Exe("/qqll:back()")
   end
end

function qqll:recover_status()
	 local worldID=GetWorldID()
	  if qqll.master_worldID==worldID then
	     print("��id����!")
		 qqll.master_ready=true
		 qqll:recover_check()
	  else
	     print("��id����!")
		 local cmd="/qqll.child_ready=true"
		 main_Exe(cmd)
		 local cmd="/qqll:recover_check()"
		 main_Exe(cmd)
	  end
end

function qqll:recover()
     world.Send("follow none")
	local ts={
	           task_name="����������",
	           task_stepname="�ָ�",
	           task_step=5,
	           task_maxsteps=7,
	           task_location=qqll.lan_place,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local liao_percent=world.GetVariable("liao_percent") or 80
	liao_percent=tonumber(liao_percent)
	local qi_percent=world.GetVariable("qi_percent") or 100
	qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100

	local cd=cond.new()
	heal_ok=false
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
			          qqll:recover()
			        end
			        rc:qudu(sec,i[1],false)
				    return
			     end
				 if i[1]=="����" or i[1]=="����ȭ����" then
				    print("����")
				    sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			            qqll:recover()
					  end
					  f_wait(f,5)
			        end
			        rc:heal(true,true)
				    return
				 end
			   end
		end
		local b2=busy.new()
	    b2.Next=function()
  	      world.Send("yun qi")
	      world.Send("yun jingli")
	      local h
	      h=hp.new()
	      h.checkover=function()
	       if h.jingxue_percent<=80 or (h.qi_percent<=liao_percent and heal_ok==false) then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			 rc.heal_ok=function()
			   --heal_ok=true
			   qqll:recover()
			 end
		 	rc:liaoshang()
		   elseif h.jingxue_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    qqll:recover()
			end
			rc:heal(false,true)
		  elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    qqll:recover()
			end
			rc:heal(true,false)
		  elseif h.neili<math.floor(h.max_neili*qqll.neili_upper)  then
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
				     qqll:recover()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,10)
			    end
				if id==777 then
				   qqll:recover()
				end
	           if id==202 then
			     local roomno=153
                 local leitai=world.GetVariable("qqll_leitai")
		         roomno=tonumber(leitai)
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(roomno)
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   world.Send("yun recover")
			   if h.neili>h.max_neili*2-200 then
				  heal_ok=false
			      qqll:recover_status()
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
			   heal_ok=false
			   qqll:recover_status()
			end
			b:check()
		end
	  end
	  h:check()
	  end
	    b2:check()
	end
	cd:start()
end

--[[
��������������˵�������ú���������Щ�ƽ���Ц�ɡ� ...��
���϶���һЩ�ƽ�
����ת��������Ͳ����ˡ�]]



local function short_dir(dir)
   local d=dir
   d=string.gsub(d,"eastdown","ed")
   d=string.gsub(d,"westdown","wd")
   d=string.gsub(d,"northdown","nd")
   d=string.gsub(d,"southdown","sd")
   d=string.gsub(d,"eastup","eu")
   d=string.gsub(d,"westup","wu")
   d=string.gsub(d,"northup","nu")
   d=string.gsub(d,"southup","su")
   d=string.gsub(d,"northwest","nw")
   d=string.gsub(d,"northeast","ne")
   d=string.gsub(d,"southwest","sw")
   d=string.gsub(d,"southeast","se")
   d=string.gsub(d,"east","e")
   d=string.gsub(d,"west","w")
   d=string.gsub(d,"south","s")
   d=string.gsub(d,"north","n")
   d=string.gsub(d,"up","u")
   d=string.gsub(d,"down","d")
   return d
end

function qqll:back_status()
  if qqll.child_ready==true and qqll.master_ready==true then
	local player_id=world.GetVariable("player_id")
    local otherworld=GetWorldById(qqll.child_worldID)
    local parter_id=otherworld:GetVariable("player_id")
	main_Exe("follow "..string.lower(parter_id))
	child_Exe("follow "..string.lower(player_id))
	qqll:shield()
	child_Exe("/qqll:shield()")
	qqll:robber()
	qqll.stop=false
	local dir=qqll.g_dir
	qqll:go(dir)
	qqll.child_ready=false
	qqll.master_ready=false
   end
end

function qqll:back() --�ص�������

   local roomno=153
   local leitai=world.GetVariable("qqll_leitai")
   roomno=tonumber(leitai)
   local w=walk.new()
   local worldID=GetWorldID()
   w.walkover=function()
	  if qqll.master_worldID==worldID then
		qqll.master_ready=true
        qqll:back_status()
	  else
	    main_Exe("/qqll.child_ready=true") --֪ͨ��id
		main_Exe("/qqll:back_status()")
	  end
   end
   w:go(roomno)
end

--����������һ������ʯ��
function qqll:givelanshi()
    wait.make(function()
	  local l,w=wait.regexp("^(> |)����������һ������ʯ��$",5)
	  if l==nil then
	     world.Send("give lan qiyan shi")
         qqll:givelanshi()
	     return
	  end
	  if string.find(l,"����ʯ") then
	    qqll:reward()
	     return
	  end
	end)
end

function qqll:checkLan(callback)

   local _R=Room.new()
    local _R
	_R=Room.new()
	_R.CatchEnd=function()
	    print(_R.roomname,"��������")
        print(_R.exits)
		local dx=Split(_R.exits,";")
		local _dir=""
		for _,d in ipairs(dx) do
		   if d~="enter" and d~="out" then
		      _dir=d
			  break
		   end
		end
		if _dir=="" then
		    _dir=string.gsub(_R.exits,";","")
		end
		print(_dir)
		local rev_dir=get_dir(_dir)
		local path=_dir..";"..rev_dir
		path=short_dir(path)
		print(path)
		if _R.roomname=="����ƺ" then
		   path="w;e"
		elseif _R.roomname=="ɽ��С·" then  --��̶��busy
		   path="wu;ed"
		end
		world.Execute(path)
		world.Send("ask lan about ����ʯ")
        wait.make(function()
         local l,w=wait.regexp("^(> |)����û������ˡ�$|^(> |)�������������йء�����ʯ������Ϣ��$",5)
	     if l==nil then
	       qqll:checkLan(callback)
	       return
	     end
	     if string.find(l,"����û�������") then
	       callback()
	       return
	      end
		 if string.find(l,"�������������й�") then
	      world.DoAfter(2,"give lan qiyan shi")
		  wait.time(2)
		  qqll:givelanshi()
	      return
	     end
        end)
	end
	_R:CatchStart()
end

function qqll:checkLan_status()
  if qqll.master_ready==true and qqll.child_ready==true then
     local playerid=world.GetVariable("player_id")
     child_Exe("follow "..playerid)
     local f=function()
		coroutine.resume(qqll.co)
	 end
	 qqll:checkLan(f)
   end
end

function qqll:go_room(roomno)
    local worldID=GetWorldID()
    local w=walk.new()
	w.noway=function()
	    print("noway")
	end
	w.walkover=function()

		if qqll.master_worldID==worldID then
	        print("��id����!")
		    qqll.master_ready=true
            qqll:checkLan_status()
		  else
	        print("��id����!")
		    main_Exe("/qqll.child_ready=true")
	    	main_Exe("/qqll:checkLan_status()")
		  end
	end
	w:go(roomno)
end

local giveshi_test=0
function qqll:give_shi()
   local ts={
	           task_name="����������",
	           task_stepname="Ѱ�Ҵ�����",
	           task_step=6,
	           task_maxsteps=7,
	           task_location=qqll.lan_place,
	           task_description="Ѱ��"..qqll.lan_place.."�Ĵ�����",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	--CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."������������:Ѱ�Ҵ����� "..qqll.lan_place, "blue", "black") -- yellow on white
    local place=qqll.lan_place
    local n,e=Where(place)
	if n==0 then
	  if string.find(place,"�����") or string.find(place,"�������") then

	     --place=string.gsub(place,"�����","�������")
	     local place2=string.gsub(place,"�������","�����")
		 --print(place2," place2")
		 n,e=Where(place2)
		 if n==0 then
		     place2=string.gsub(place,"����ɽ","�����")
			 n,e=Where(place2)
		 end
		 if n==0 then
		     place2=string.gsub(place,"����ʹ�","�����")
			 n,e=Where(place2)
		 end
		 if n==0 then
			 place2=string.gsub(place,"��������","�����")
			 n,e=Where(place2)
		 end
		 if n==0 then
			 place2=string.gsub(place,"�����","�����")
			 n,e=Where(place2)
		 end
	  end
	  if string.find(place,"������") then
	     place=string.gsub(place,"������","����")
		 n,e=Where(place)
	  end
	  if string.find(place,"����Ľ��") then
	     place=string.gsub(place,"����Ľ��","������")
		 n,e=Where(place)
		  if n==0 then
		     place=string.gsub(place,"����Ľ��","��٢��ɽׯ")
			 n,e=Where(place)
		 end
	  end
	  if string.find(place,"������") then
		 place=string.gsub(place,"������","������")
		 n,e=Where(place)
	  end
	  if string.find(place,"��ԭ����") then
	     place=string.gsub(place,"��ԭ����","")
		 n,e=Where(place)
	  end
	  if string.find(place,"ƽ����") then
	     place=string.gsub(place,"ƽ����","���޺�")
		 n,e=Where(place)
	  end
	  if string.find(place,"�ɶ�����") then
		 place=string.gsub(place,"�ɶ�����","�ɶ���")
		 n,e=Where(place)
	  end
	  if string.find(place,"���ԭ") then
		 place=string.gsub(place,"���ԭ","��ѩɽ")
		 n,e=Where(place)
	  end
	   if string.find(place,"�����") then
		 place=string.gsub(place,"�����","���޺�")
		 n,e=Where(place)
	  end
	  if string.find(place,"���޺�") then

	      place=string.gsub(place,"���޺�","�����")
		  n,e=Where(place)
	  end
	end
	if n==0 then
	   --[[local worldID=GetWorldID()
	   if qqll.master_worldID==worldID then
	     print("��id ������")
	     qqll:wanted()
	   end]]
	   qqll:wanted()
	   return
	end
	qqll.target=e
   	qqll.co=coroutine.create(function()
      for _,roomno in ipairs(e) do
	    local w=walk.new()
		local al=alias.new()
		al.maze_done=function()
			print("�Թ�check npc")
			local f2=function() al.maze_step() end
			qqll:checkLan(f2)
		end
		al.songlin_check=function()
			print("�Թ�check npc")
			local f2=function() al:NextPoint() end
			qqll:checkLan(f2)
		end
		al.noway=function()
		   print("alias noway")
		   qqll:wanted()
		end
		w.user_alias=al
		w.noway=function()
		   print("walk noway")
		   qqll:wanted()
		end
	    w.walkover=function()
		   qqll.master_ready=true
		   qqll:checkLan_status()
	    end
		world.Send("follow none")
		child_Exe("follow none")
	    w:go(roomno)
		qqll.master_ready=false
		qqll.child_ready=false
		child_Exe("/qqll:go_room("..roomno..")")
        coroutine.yield()
	  end
	  print("�ߵ���û�ҵ�")
	  if giveshi_test>1 then
	     giveshi_test=0
	     qqll:giveup()
	  else
	     giveshi_test=9
		 local b=busy.new()
		 b.Next=function()
	       qqll:give_shi()
		 end
		 b:check()
	  end
	end)
	coroutine.resume(qqll.co)
end

function qqll:shield()

end

local steps=0
function qqll:go(dir)
   if qqll.stop==false then
	 qqll.g_dir=dir
	 world.Execute(dir)
	 local f=function()
	    steps=steps+1
		print("����:",steps)
		if qqll.robber_count>=5 then
		  print("�ѽ������5��ǿ��")
		  qqll:give_shi()
		elseif steps>30 then
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."������������:������"..qqll.robber_count.."λǿ��", "yellow", "black") -- yellow on white
		   qqll:give_shi()

		else
		  qqll:go(dir)
		end
	 end
	 f_wait(f,0.5)
   end
end

function qqll:qiyanshi_exist()
    world.EnableTimer("qiyanshi_exist",false)
	world.DeleteTimer("qiyanshi_exist")
    local sp=special_item.new()
	sp.cooldown=function()
        print("cooldown")
		for _,i in ipairs(sp.equipment_items) do
		   print(i.name,i.id,i.num)
		   if string.find(i.name,"����ʯ") then
			  local b=busy.new()
		      b.Next=function()
		       world.Send("get gold")
			   qqll.child_ready=false
			   qqll.master_ready=false
			   qqll:recover()
			   child_Exe("/qqll:recover()")
		      end
		      b:check()
		      return
		   end
		end
		world.Send("follow none")
		child_Exe("/shutdown()")
		child_Exe("follow none")
		qqll:main_link()
	end
	local equip={}
	equip=Split("<ʹ��>����ʯ","|")
	sp:check_items(equip)
end
--�㡸ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
function qqll:robber_fight()
  wait.make(function()
       local l,w=wait.regexp("^(> |).*����������˵������.*��������Щ�ƽ���Ц�ɡ� ...��$|^(> |)��ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪���ˡ���$|^(> |)"..qqll.robbername.."����ææ���뿪�ˡ�$",5)
	   if l==nil then
	      qqll:robber_fight()
	      return
	   end
	   if string.find(l,"��ǰһ��") or string.find(l,"����ææ���뿪��") then
	      world.AddTimer("qiyanshi",0,0,8,"qqll:qiyanshi_exist()", timer_flag.Enabled + timer_flag.OneShot , "")
          world.SetTimerOption ("qiyanshi", "send_to", 12)
	      return
	   end
       if string.find(l,"��Щ�ƽ���Ц��") then
	      shutdown()
	      local b=busy.new()
		  b.Next=function()
		      world.Send("get gold")
			  qqll.child_ready=false
			  qqll.master_ready=false
			  qqll:recover()
			  child_Exe("/qqll:recover()")
		  end
		  b:check()
		  return
       end
  end)
end

--|^(> |)�������������˹�����$
--����ʱ�����������һ���ж���
function qqll:robber_follow()
    wait.make(function()
       local l,w=wait.regexp("^(> |)(.*)����������һ���ж���$",5)
	   if l==nil then
	      qqll:robber_follow()
	      return
	   end
       if string.find(l,"����������һ���ж�") then
	      qqll.robbername=w[2]
		  return
       end
  end)
end

function qqll:robber()
  --����������е���ʯԽ��Խ��������ٲ�ά�衭����
  wait.make(function()
       local l,w=wait.regexp("^(> |)����������е���ʯԽ��Խ��������ٲ�ά�衭����$",5)
	   if l==nil then
	      qqll:robber()
	      return
	   end
       if string.find(l,"����������е���ʯԽ��Խ��") then
	      qqll.robber_count=qqll.robber_count+1
		  steps=0
		  qqll:robber_follow()
	      qqll:robber_fight()
          qqll.stop=true
		   print("ս��ģ��")
	      local cb=fight.new()
		  local pfm=world.GetVariable("pfm")
		   cb.combat_alias=pfm
	      local unarmed_pfm=world.GetVariable("unarmed_pfm")
	      cb.unarmed_alias=unarmed_pfm
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
		    world.Send("unset wimpy")
		    shutdown()
		    qqll:qiyanshi_exist()
	      end
	      cb:start()
		  return
       end
  end)
end

function qqll:Dragon()
   steps=0
   world.Send("say ��ս��̨")
   qqll:robber()
   qqll:go("e;w")
end
  --[[
function qqll:go_round()
   print("Ѳ��")
   print("���ù̶��ص�Ѳ��")
 local points={}
   for i,r in ipairs(qqll.target) do
      local p={}
	  p.startroomno=r
	  if i+1>table.getn(qqll.target) then
	     p.endroomno=qqll.target[1]
	  else
	     p.endroomno=qqll.target[i+1]
	  end
	  print(p.startroomno,p.endroomno)
	  table.insert(points,p)
   end
   local dir=""
   for i,r in ipairs(points) do
      local path,room_type,rooms=Search(r.startroomno,r.endroomno)
      dir=dir..path
   end
   dir=string.sub(dir,1,-2)
   --print(dir)
   if string.find(dir,"noway") then
      qqll:get_way()
   else
      qqll:go(dir)
   end

   --����Ѳ��·��

   --����������е���ʯԽ��Խ��������ٲ�ά�衭����
end

function qqll:prepare_status()
	 if qqll.master_ready==false then
	    child_Exe("say �ȵȴ�ʦ")
		world.DoAfterSpecial(1,"qqll:prepare_status()",12)
	 elseif qqll.child_ready==false then
		main_Exe("say �ȵ�����")
		world.DoAfterSpecial(1,"qqll:prepare_status()",12)
	 end
end]]

function qqll:prepare_check()
     if qqll.child_ready==true and qqll.master_ready==true then
		qqll:Dragon()
		qqll.child_ready=false
		qqll.master_ready=false
	 elseif qqll.master_ready==false then
	    child_Exe("say �ȵȴ�ʦ")
		--world.DoAfterSpecial(1,"qqll:prepare_status()",12)
	 elseif qqll.child_ready==false then
		main_Exe("say �ȵ�����")
		--world.DoAfterSpecial(1,"qqll:prepare_status()",12)
	 end
end

function qqll:check_place(roomno,place)
   local worldID=GetWorldID()
   local f=function(r)
     if is_contain(roomno,r)==true then
         print("��ȷ����")
		 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."������������:������̨,׼��ս��", "white", "black") -- yellow on white
		 if qqll.master_worldID==worldID then
	        print("��id����!")
		    qqll.master_ready=true
            qqll:prepare_check()
		  else
	        print("��id����!")
		   local cmd="/qqll.child_ready=true"
		    main_Exe(cmd)
			local cmd="/qqll:prepare_check()"
		    main_Exe(cmd)
		  end
	  else
         qqll:dragonGate(place)
	  end
   end
   print("ȷ��λ��")
   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."������������:�Ƿ񵽴���̨", "blue", "black") -- yellow on white
   WhereAmI(f,10000) --�ų����ڱ仯
end

function qqll:dragonGate(place)
   local ts={
	           task_name="����������",
	           task_stepname="ɱ��ǿ��",
	           task_step=5,
	           task_maxsteps=7,
	           task_location="��̨",
	           task_description=place,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."������������:ǰ����̨,����"..place, "blue", "black") -- yellow on white
	qqll.lan_place=place
	qqll.robber_count=0 --ǿ������

	world.Send("follow none")
	local roomno=153
	local leitai=world.GetVariable("qqll_leitai")
	roomno=tonumber(leitai)
	local w=walk.new()
	w.walkover=function()
		local masterworld=GetWorldById(qqll.master_worldID)
	    local master_id=masterworld:GetVariable("player_id")
        local otherworld=GetWorldById(qqll.child_worldID)
        local parter_id=otherworld:GetVariable("player_id")
		main_Exe("follow "..string.lower(parter_id))
		child_Exe("follow "..string.lower(master_id))
		main_Exe("emote �ֽ�վ��,��ر�ɫ")
		child_Exe("emote �ֵ�վ��,������ӿ")

		qqll:check_place(roomno,place)
	end
	w:go(roomno)
end

function qqll:ketou(roomno,uid)
   wait.make(function()
--С������Ķ�������˵���������������Ѿ�ȥ��̳�ˡ�
      local l,w=wait.regexp("^(> |)"..qqll.playername.."����Ķ�������˵���������������Ѿ�ȥ(.*)�ˡ�|^(> |)����û������ˡ�$|^(> |)�趨����������action \\= \\\""..uid.."\\\"$|^(> |)��Ĵȥ������.*$",3)
	  if l==nil then
	     qqll:ask_lan(roomno)
		 return
	  end
	  if string.find(l,"����Ķ�������˵��") then
	     world.Send("follow none")
		 child_Exe("follow none")
		 qqll.is_find=true
	     --main_Exe("follow "..qqll.playerid)
	     --child_Exe("follow "..qqll.playerid)
	     local place=w[2]
		 place=qqll.location..place
		 if place=="�������߿�" or place=="����������" or place=="����ȹȵ�" or place=="�����������" or place=="�ؽ����ԭ" or place=="����������" or place=="����������" or place=="���̷�����" or place=="���̵�����" or place=="��ɽ��̳" or place=="��ɽ��ɽ��" or place=="��ɽ�ܵ�" or place=="��ɽʯ��" or place=="���������̶" or place=="����ȴ���" or place=="�����С��" or place=="��ɽ������ɮ��" or place=="��ɽ����������" or place=="��ɽ��������" then
		    qqll:wanted()
		    return
		 end
		 qqll.stop=false
		 world.ColourNote ("red", "yellow", place)
		 qqll:set_guard()

		 qqll:dragonGate(place)
		 qqll.master_ready=false
	     qqll.child_ready=false
		 child_Exe("say ս��׼��")
		 child_Exe("/qqll:dragonGate('"..place.."')")
	     return
	  end
	  if string.find(l,"����û�������") then
	     qqll.is_find=false
	     local f=function()
		    qqll:ask_lan(roomno)
		 end
		 f_wait(f,1)
	     return
	  end
	  if string.find(l,"�趨����������action") then
	     world.Execute("ask "..qqll.playerid.." about ������")

		 local uid=string.sub(CreateGUID(),25,30)
		  world.DoAfter(0.3,"set action "..uid)
		 qqll:ketou(roomno,uid)
	     return
	  end
		if string.find(l,"��Ĵȥ������") then
	       print("����")
	       qqll:wanted()
	       return
	   end
   end)
   -- �Ϲٽ�������Ķ�������˵���������������Ѿ�ȥĥ�뾮�ˡ�

end

local is_reset=0
function qqll:lan(roomno)
--�Ϲٽ�������Ķ�������˵���������������Ѿ�ȥĥ�뾮�ˡ�
	--world.Send("follow "..qqll.playerid)
	--child_Exe("follow "..qqll.playerid)

   local player_id=world.GetVariable("player_id")
   local otherworld=GetWorldById(qqll.child_worldID)
   local parter_id=otherworld:GetVariable("player_id")
   --print("��id",parter_id)
   --print("��id",player_id)
	--world.Send("follow "..string.lower(qqll.playerid))
	--child_Exe("follow "..string.lower(qqll.player_id))
	world.Send("ask "..string.lower(qqll.playerid).." about ������")

	wait.make(function()
	   local l,w=wait.regexp("^(> |)"..qqll.playername.."����Ķ�������˵���������������Ѿ�ȥ(.*)�ˡ�$|^(> |)����û�� "..qqll.playerid.."��$|^(> |)���������"..qqll.playername.."һ���ж���$|^(> |)����û������ˡ�$",2)
	   if l==nil then
	      qqll:lan(roomno)
	      return
	   end
	   --[[
	   if string.find(l,"һ���ж�") then
	       qqll.is_find=true
	       local uid=string.sub(CreateGUID(),25,30)
	       qqll:ketou(roomno,uid)
		   --world.Send("ask "..qqll.playerid.." about ������")
		   world.DoAfter(0.3,"set action "..uid)
	       --world.EnableTimer("catch_id",false)
		   --world.DeleteTimer("catch_id")
	       world.Send("say �һ�����,��ݲ���,��Ǯ���,��ͷ����! "..qqll.playername.."�����������ܣ������ڿ㣡")
	       return
	   end]]
      if string.find(l,"����Ķ�������˵��") then
	     world.Send("follow none")
		 child_Exe("follow none")
		 qqll.is_find=true
	     --main_Exe("follow "..qqll.playerid)
	     --child_Exe("follow "..qqll.playerid)
	     local place=w[2]
		 place=qqll.location..place
		 if place=="�䵱ɽ�һ����" or place=="�䵱ɽ��ѩ����" or place=="�䵱ɽ��Ҷ����" or place=="�䵱ɽԺ��" or place=="�������߿�" or place=="����������" or place=="�����������" or place=="�ؽ����ԭ" or place=="����������" or place=="����������" or place=="���̷�����" or place=="���̵�����" or place=="��ɽ��̳" or place=="��ɽ��ɽ��" or place=="��ɽ�ܵ�" or place=="��ɽʯ��" or place=="���������̶" or place=="����ȴ���" or place=="�����С��" or place=="����ȶ���" or place=="��ɽ������ɮ��" or place=="��ɽ����������" or place=="��ɽ��������" then
		    qqll:lan(roomno)
		    return
		 end
		 qqll.stop=false
		 world.ColourNote ("red", "yellow", place)
		 qqll:set_guard()

		 qqll:dragonGate(place)
		 qqll.master_ready=false
	     qqll.child_ready=false
		 child_Exe("say ս��׼��")
		 child_Exe("/qqll:dragonGate('"..place.."')")
	     return
	  end
	   if string.find(l,"����û��") then
		  local sec=480-os.difftime(os.time(),qqll.starttime)
		  print(sec," ����ʱ")
	     if is_reset>=10 then

		    local interval=os.difftime(os.time(),qqll.starttime)
		    print("����")
			child_Exe("say")
			is_reset=0
			if interval>480 then
			  print("���� 480 ",interval)
			  qqll:giveup()
			else
	          qqll:wanted()
		    end
		 else
		    if is_reset==2 then
		     qqll:collectData() --�ռ�����
			end
	        local f=function()
			  is_reset=is_reset+1
		      qqll:lan(roomno)
            end
		    f_wait(f,0.5)
		 end
		  --world.EnableTimer("catch_id",true)
	      return
	   end
	end)
end


function qqll:ask_lan(roomno,is_omit)
   world.Send("follow none")
   local w=walk.new()
   w.walkover=function()
       	local f=function(r)
		    if is_contain(roomno,r) then
			   if is_omit==true then
			     world.Send("say �Һ��㵽���ĺ���")
			   else
				qqll:lan(roomno)
			   end

			else
				qqll:ask_lan(roomno)
			end
	    end
	    WhereAmI(f,10000) --�ų����ڱ仯
   end
   w:go(roomno)
end
--���ݲɼ���

local database_path=""
function qqll:db_init()
  local db_name="sjcentury.db" --��ͼ���ݿ�
--���ݲ���
 local path=world.GetInfo (66) .. db_name
  database_path=path
end
qqll:db_init()

function qqll:ClearDB()
	world.DatabaseOpen ("db2", database_path, 6) --ֻ�����ݿ�

   local sql="delete from mud_bigdata"
   DatabaseExec ("db2",sql)
   DatabaseFinalize ("db2")
   DatabaseClose ("db2")
end

function qqll:DeleteHistory()
	world.DatabaseOpen ("db2", database_path, 6) --ֻ�����ݿ�
   local t=os.time()
   local now_date = os.date("*t",t)
   --[[
      print("before")
print("year:" .. now_date.year)
print("month:" .. now_date.month)
print("day:" .. now_date.day)
print("hour:" .. now_date.hour)]]
   now_date.hour=now_date.hour-2
  --[[
   print("after")
print("year:" .. now_date.year)
print("month:" .. now_date.month)
print("day:" .. now_date.day)
print("hour:" .. now_date.hour)
]]
 local sql="delete from mud_bigdata where import_time<'"..os.date("%y/%m/%d %H:%M:%S",os.time({day=now_date.day,month=now_date.month,year=now_date.year,hour=now_date.hour,min=now_date.min,sec=now_date.sec})).."'"
 --  print(sql)
   DatabaseExec ("db2",sql)
   DatabaseFinalize ("db2")
   DatabaseClose ("db2")

end

function qqll:GetHistoryCount()
     world.DatabaseOpen ("db2", database_path, 6) --ֻ�����ݿ�
    local sql="select count(*) from mud_bigdata"
	world.DatabasePrepare ("db2", sql)
	 local rows={}
	 local rc={}
  	  rc=world.DatabaseStep ("db2")
	  while rc == 100 do
	     ------print("row",i)
	     local values=  world.DatabaseColumnValues ("db2")

		 rows=values[1]
		 break
	  end
	  world.DatabaseFinalize ("db2")
	  DatabaseClose ("db2")
	  return rows
end

function qqll:insert(playername,playerid,roomno,roomname)
    local item={}
	item.playername=playername
	item.playerid=playerid
	item.roomno=roomno
	item.roomname=roomname
	if item.playerid~="qingtong" and item.playerid~="board" and item.playerid~="head" then
	   self:Record(playername,playerid,roomno,roomname)
	end
end

--

function qqll:collectData()

  local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --���ݵ�ǰλ�� ǰ�������Ǯׯ
--1532 ������ 1657 ���Ŀ� 1957 ����� 506 ��վ 1413 ��ͤ 1969 ���¶�
      local count,roomno=Locate(_R)
	  local roomname=_R.roomname
	  print("��ǰ�����",roomno[1]," ",roomname)
	    world.Send("id here")
	    world.Send("set action ���ݲɼ�")
	    self:catch(roomno[1],roomname)
   end
  _R:CatchStart()
end

function qqll:start_collectData(count,interval)
   if interval==nil then
      interval=5
   end
   if count>0 then
     count=count-1
	   self:collectData()
	   --�ȴ�10s
       local f=function()
		   self:start_collectData(count)
       end
	   f_wait(f,interval)
   else
       coroutine.resume(qqll.co)

   end


end

function qqll:redo_collectData()

  local rooms={}
  local r=math.random(2)
  print("�����:",r)
  if r==1 then
   table.insert(rooms,1532)
   table.insert(rooms,1657)
   table.insert(rooms,1957)
  table.insert(rooms,2540)
   table.insert(rooms,1413)
   table.insert(rooms,506)
   table.insert(rooms,1969)
  else
     table.insert(rooms,1413)
     table.insert(rooms,1969)
	  table.insert(rooms,506)
	   table.insert(rooms,2540)
	  table.insert(rooms,1957)
	  table.insert(rooms,1657)
     table.insert(rooms,1532)
  end
   qqll.co=coroutine.create(function()
	  for _,r in ipairs(rooms) do
	    print("��һ��")
		 local w=walk.new()
         w.walkover=function()
            self:start_collectData(3,2)

         end
         w:go(r)

		coroutine.yield()
	  end
	   print("����!!!")

   end)
   coroutine.resume(qqll.co)
end

function qqll:init()
   qqll:ClearDB()
   local rooms={}

   local worldID=GetWorldID()
	if qqll.master_worldID==worldID then
	     table.insert(rooms,1532)
         table.insert(rooms,1657)
         table.insert(rooms,2540)
         table.insert(rooms,1957)
         table.insert(rooms,506)
         table.insert(rooms,1413)
         table.insert(rooms,1969)
	else
	      table.insert(rooms,1413)
          table.insert(rooms,1969)
	      table.insert(rooms,506)
	       table.insert(rooms,2540)
	      table.insert(rooms,1957)
	       table.insert(rooms,1657)
          table.insert(rooms,1532)
	end
   qqll.co=coroutine.create(function()
	  for _,r in ipairs(rooms) do
	    print("��һ��")
		 local w=walk.new()
         w.walkover=function()
            self:start_collectData(10)

         end
         w:go(r)

		coroutine.yield()
	  end
	   print("qqllyu ������ݻ�ȡ����!!!")
	   qqll:start()

   end)
   coroutine.resume(qqll.co)

end

function qqll:catch(roomno,roomname)

   wait.make(function()
      local l,w=wait.regexp("^(> |)�����������\\, ���Ｐ��Ʒ��\\(Ӣ��\\)�������£�$|^(> |)�趨����������action \\= \\\"���ݲɼ�\\\"",2)
	  if l==nil then
		 world.Send("set action ���ݲɼ�")
	     self:catch(roomno,roomname)
	     return
	  end
	  if string.find(l,"�趨����������action") then
	     --print("����")
		 world.EnableTrigger("idhere",false)
		 world.DoAfterSpecial(0.1,"DeleteTrigger('idhere')",12)
	     return
	  end
	  if string.find(l,"���Ｐ��Ʒ��") then
	     world.AddTriggerEx ("idhere", "^(> |)(\\W*) \\= (\\w*)$", "qqll:insert('%2','%3',"..roomno..",'"..roomname.."')", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 999)
		 self:catch(roomno,roomname)
	     return
	  end
   end)
end

function qqll:Record(playername,playerid,roomno,roomname)

	world.DatabaseOpen ("db2", database_path, 6) --ֻ�����ݿ�
   local editwho=world.GetVariable("player_id") or "sys"
   if editwho~=playerid then
     local sql="insert into mud_bigdata (roomno,roomname,import_time,editwho,playername,playerid) values("..roomno..",'"..roomname.."','"..os.date("%y/%m/%d %H:%M:%S").."','"..editwho.."','"..playername.."','"..playerid.."')"
     print(sql)
     DatabaseExec ("db2",sql)
     DatabaseFinalize ("db2")
     DatabaseClose ("db2")
   end
end

function qqll:loadDataCount(id)
     world.DatabaseOpen ("db2", database_path, 6) --ֻ�����ݿ�
    local sql="select roomno,count(*) b from mud_bigdata where playerid='"..id.."' group by roomno order by b desc"
	world.DatabasePrepare ("db2", sql)
	 local rc ={}

	 local returnvalue={}
  	  rc=world.DatabaseStep ("db2")
	  while rc == 100 do
	     ------print("row",i)
	     local values=  world.DatabaseColumnValues ("db2")
         local r={}
		 r.roomno=values[1]
		 r.count=values[2]
		 table.insert(returnvalue,r)
		 rc = world.DatabaseStep ("db2")

	  end
	  world.DatabaseFinalize ("db2")
	  DatabaseClose ("db2")
	  return returnvalue
end

function qqll:loadData(id)
   qqll:DeleteHistory()

   world.DatabaseOpen ("db2", database_path, 6) --ֻ�����ݿ�

	local sql="select roomno,roomname,import_time,editwho,playername,playerid from mud_bigdata where playerid='"..id.."' order by import_time desc limit 1"
	print(sql)
	world.DatabasePrepare ("db2", sql)
	 local rc ={}
	 local r={}
	 local returnvalue={}
  	  rc=world.DatabaseStep ("db2")
	  while rc == 100 do
	     ------print("row",i)
	     local values=  world.DatabaseColumnValues ("db2")

		 r.roomno=values[1]
		 r.roomname=values[2]
		 r.import_time=values[3]
		 r.editwho=values[4]
		 r.playername=values[5]
		 r.playerid=values[6]
		 table.insert(returnvalue,r)
		 rc = world.DatabaseStep ("db2")

	  end
	  world.DatabaseFinalize ("db2")
	  DatabaseClose ("db2")
	  return returnvalue
end


local last_roomno=0
function qqll:wanted()
    local party=""
	local status=""
	local name=""
	local id=qqll.playerid
    qqll.is_find=false
	local result=qqll:loadData(id)
	local count=qqll:loadDataCount(id)
	--ͨ�� ���ι���������λ��

	if result==nil then
	   print("��ȡ����ʧ��")
	   local f=function()
	     qqll:wanted()
	   end
	   f_wait(f,2)
	   return
	end
    print("�������ҳ��ֵĵص�")
	local r=result[1]
	if r==nil then
	   print("û�й켣!!")
	   qqll:giveup()
	   return
	end
	print(r.import_time,":",r.playername," ",r.playerid," ",r.roomname,"(",r.roomno,") ",r.editwho)
	for _,v in ipairs(count) do
	   print("�����:",v.roomno," ���� ",v.count)

	end
	r.roomno=tonumber(r.roomno)

	--03/15/16 19:58:18:147
	--[[
	r.import_time=string.sub(r.import_time,1,17)
    local tab={}
	tab.year="20"..string.sub(r.import_time,7,8)
	tab.month=string.sub(r.import_time,1,2)
	tab.day=string.sub(r.import_time,4,5)
    tab.hour=string.sub(r.import_time,10,11)
	tab.min=string.sub(r.import_time,13,14)
	tab.sec=string.sub(r.import_time,16,17)
	local t = os.time(tab)  --����ϴ�ʱ��
	--print(t)
	local interval=os.difftime(os.time(),t)
	if interval>=900 then
	    print("ʱ��������6����")
		qqll:giveup()
	   return
	end]]
	-- BigData:catchData(2542,"����")
	----1532 ������ 1657 ���Ŀ� 1957 ����� 506 ��վ 1413 ��ͤ 1969 ���¶�
    if r.roomno==1532 then
	    last_roomno=1532
	    qqll:ask_lan(1532)
		child_Exe("/qqll:ask_lan(1532,true)")
	elseif r.roomno==2542 or r.roomname=="����" then
	    last_roomno=2542
	    qqll:ask_lan(2542)
		child_Exe("/qqll:ask_lan(2542,true)")
	elseif r.roomno==2540 then
	    last_roomno=2540
	    qqll:ask_lan(2540)
		child_Exe("/qqll:ask_lan(2540,true)")
	elseif r.roomno==506 then
	    last_roomno=506
	    qqll:ask_lan(506)
		child_Exe("/qqll:ask_lan(506,true)")
	elseif r.roomno==1969 then
	    last_roomno=1969
		qqll:ask_lan(1969)
		child_Exe("/qqll:ask_lan(1969,true)")
	elseif r.roomno==1413 then
	    last_roomno=1413
		qqll:ask_lan(1413)
		child_Exe("/qqll:ask_lan(1413,true)")
	elseif r.roomno==1657 then
         last_roomno=1657
		 qqll:ask_lan(1657)
         child_Exe("/qqll:ask_lan(1657,true)")
	elseif r.roomno==1957 or string.find(r.roomname,"��ˮ����") then
	    last_roomno=1957
	    qqll:ask_lan(1957)
		child_Exe("/qqll:ask_lan(1957,true)")
    elseif r.roomno==50 then
	    last_roomno=50
	    qqll:ask_lan(50)
		child_Exe("/qqll:ask_lan(50,true)")
	elseif r.roomno==84 then
	    last_roomno=84
	    qqll:ask_lan(84)
		child_Exe("/qqll:ask_lan(84,true)")
	elseif r.roomno==135 then
	    last_roomno=135
	    qqll:ask_lan(135)
		child_Exe("/qqll:ask_lan(135,true)")
	elseif r.roomno==2540 then
	    last_roomno=2540
	    qqll:ask_lan(2540)
		child_Exe("/qqll:ask_lan(2540,true)")
	elseif r.roomno==1345 then
	    last_roomno=1345
	    qqll:ask_lan(1345)
		child_Exe("/qqll:ask_lan(1345,true)")
	elseif r.roomno==311 then
	    last_roomno=311
	    qqll:ask_lan(311)
		child_Exe("/qqll:ask_lan(311,true)")
	elseif r.roomno==2553 then
	    last_roomno=2553
	    qqll:ask_lan(2553)
		child_Exe("/qqll:ask_lan(2553,true)")
	elseif string.find(r.roomname,"�����ɴ�") or string.find(r.roomname,"��������") or string.find(r.roomname,"�����ϰ�") or string.find(r.roomname,"�ɴ�") then
		last_roomno=148
		qqll:ask_lan(148)
		child_Exe("/qqll:ask_lan(148,true)")
	elseif string.find(r.roomname,"��ɿ�") then
	    last_roomno=1573
	     qqll:ask_lan(1573)
		child_Exe("/qqll:ask_lan(1573,true)")
	elseif string.find(r.roomname,"�½��ɿ�") then
	    last_roomno=1351
	     qqll:ask_lan(1351)
		child_Exe("/qqll:ask_lan(1351,true)")
	elseif string.find(r.roomname,"���׽���") then
	    last_roomno=525
	      qqll:ask_lan(525)
		child_Exe("/qqll:ask_lan(525,true)")
	elseif string.find(r.roomname,"���Ķɿ�") then
	    last_roomno=1596
	    qqll:ask_lan(1596)
		child_Exe("/qqll:ask_lan(1596,true)")
	else
	     print("û�ҵ���Ӧ����")
		 if last_roomno==0 then
		    last_roomno=50
		 end
		qqll:ask_lan(last_roomno)
	  	child_Exe("/qqll:ask_lan("..last_roomno..",true)")
	end

--�Ϲٽ�������Ķ�������˵���������������Ѿ�ȥĥ�뾮�ˡ�
    --1532
	--һ�����˸�����Ⱥһ�����ơ�
	--1957
	--��Զ�Ŷ�������ҵ��˵�ͷ��
	--506
	--311
	--���������氮���㽲��һЩ��ѧ�ϵ����ѣ��氮����������˼�ص���ͷ��
	--2540 --lingwu  2542

	--clb 135 ����ʯ���Ϲ��������С����˵��Щ����
	--����������һ�����˵�ͷ��
  --1345 �ⳤ�϶�������������������ִ�Ĵָ�������ġ�
  --��ҥ�ԡ�ĳ�ˣ������ʹ�ʦ˳�������ɽ�ˣ�
end

function qqll:get_who()
   wait.make(function()
      local l,w=wait.regexp("^.*�� ����������̴վ������ң�$|^(> |)�趨����������action \\= \\\"�����б�\\\"",2)
	  if l==nil then
		 world.Send("set action �����б�")
	     qqll:get_who()
	     return
	  end
	  if string.find(l,"�趨����������action") then
	     print("����")
	     return
	  end
	  if string.find(l,"��̴վ�������") then
	      print("����������")
         list=""
		 world.AddTriggerEx ("wholist", "^(> |)\\s*\\d*:(.*)$", "qqll:wholist('%2')", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 999);
         qqll:get_who()
	     return
	  end
   end)
end

function qqll:get_wholist()
  world.Send("who -i")
  --world.DoAfter(1,"\\n")
  qqll:get_who()
end

--[[
�����Ϲٽ��ϴ����йء�������������Ϣ��
�Ϲٽ���˵������Ŷ���ϴ�ȷʵ����ôһ������������
�Ϲٽ�������Ķ�������˵���������������Ѿ�ȥ˼�����ˡ�
һ������ɱ�ִ�·�����˳����������ȵ��������������ı������£���Ȼȡ�����������
�������������˹�����
������������һ���һ���ж���]]
function qqll:getid(guard_name)
    wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)��������"..guard_name.."һ���ж���$",5)
	 if l==nil then
	    qqll:getid(guard_name)
	    return
	 end
	 if string.find(l,"��������") then
        local npc=w[2]
		print(npc," id")
		qqll:killNPC(npc,guard_name)
	    return
	 end
   end)
end

function qqll:killNPC(npc,guard_name)

      --thread_monitor("huashan:checkNPC",f,{npc,roomno})
    wait.make(function()
      world.Execute("look;set action �˶����")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������action \\= \\\"�˶����\\\"",10)
	  if l==nil then
		qqll:killNPC(npc,guard_name)
		return
	  end
	  if string.find(l,"�趨����������action") then
	      qqll:guard(guard_name)
		  return
	  end

	  if string.find(l,npc) then
	     --�ҵ�
		  local id=string.lower(Trim(w[2]))
		  --print(id)
		  world.Send("kill "..id)
		  main_Exe("kill "..id)
		  qqll:main_pfm()
		  main_Exe("/qqll:set_guard()")
		  return
	  end
	  wait.time(6)
   end)
end

function qqll:guard(guard_name)

   print("�ȴ�",guard_name)
   world.Send("die2")
   main_Exe("say ���ڽ���Ʈ���ܲ�����!")
   wait.make(function()
     local l,w=wait.regexp("^(> |)һ������ɱ�ִ�·�����˳����������ȵ��������������ı������£���Ȼȡ�����������$|^(> |)"..guard_name.."��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",8)
	 if l==nil then
	    qqll:guard(guard_name)
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
	    world.Send("say ����������ʬ")
		world.Send("get gold")
		world.Send("get all from corpse")
		main_Exe("/qqll:qiyanshi_exist()")
	    return
	 end
	 if string.find(l,"һ������ɱ�ִ�·�����˳���") then
        qqll:getid(guard_name)
	    return
	 end
   end)

end

function qqll:set_guard()
   qqll:main_pfm()
   print("����pfm")
  local player_name=world.GetVariable("player_name")
   child_Exe("/qqll:guard('"..player_name.."')")
end

function qqll:xunwen_place(name,id,location)
  	local ts={
	           task_name="����������",
	           task_stepname="ѯ�����",
	           task_step=4,
	           task_maxsteps=7,
	           task_location=location,
	           task_description="Ѱ�����"..name.."("..id..")",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."������������:Ѱ�����"..name.."("..id..")", "blue", "black") -- yellow on white
	 print("ѯ�����")
  --qqll:player_exist()
   qqll.playername=name
   qqll.playerid=id
   qqll.location=location
   --qqll:get_wholist() --get who list
   qqll.starttime=os.time()
   qqll:wanted()--
end

function qqll:Status_Check()
	local ts={
	           task_name="����������",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local cd=cond.new()
	heal_ok=false
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
			          qqll:Status_Check()
			        end
			        rc:qudu(sec,i[1],false)
				    return
			     end
				 if i[1]=="����" or i[1]=="����ȭ����" then
				    print("����")
				    sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			            qqll:Status_Check()
					  end
					  f_wait(f,5)
			        end
			        rc:heal(true,true)
				    return
				 end
			   end
		     end
            qqll:full()
	end
	cd:start()
end

function qqll:ready_status()
    if qqll.master_ready==false then
	   child_Exe("say �ȵȴ�ʦ")
	   world.DoAfterSpecial(1,"qqll:ready_status()",12)
	elseif qqll.child_ready==false then
	   main_Exe("say �ȵ�����")
	   world.DoAfterSpecial(1,"qqll:ready_status()",12)
	end
end

function qqll:ready_check()
     if qqll.child_ready==true and qqll.master_ready==true then
		qqll:team() --��ʼ���
	 elseif qqll.master_ready==false then
	    child_Exe("say �ȵȴ�ʦ")
		world.DoAfterSpecial(1,"qqll:ready_status()",12)
	 elseif qqll.child_ready==false then
		main_Exe("say �ȵ�����")
		world.DoAfterSpecial(1,"qqll:ready_status()",12)
	 end
end

--�ߵ�λ��
function qqll:start()
  qqll:DeleteHistory()
   local rows=qqll:GetHistoryCount()
   if rows==0 then
	  qqll:init()
      return
   end
  local w=walk.new()
  w.walkover=function()
	 local worldID=GetWorldID()
	  if qqll.master_worldID==worldID then
	     print("��id����!")
		 qqll.master_ready=true
		  local cmd="/qqll.master_ready=true"
		 child_Exe(cmd)

		 qqll:ready_check()
	  else
	     print("��id����!")
		 qqll.child_ready=true
		 local cmd="/qqll.child_ready=true"
		 main_Exe(cmd)
		 local cmd="/qqll:ready_check()"
		 main_Exe(cmd)
	  end
  end
  w:go(644)
end

function qqll:wait_moment(flag)

	print("�ڹ�����")
	world.Send("unset ����")
	if flag==1 then
	  local f=function()
		 local q=function() qqll:main_link() end
		 switch(q)
	   end
	   f_wait(f,60)
	else
	  local f=function()
		 local q=function() world.Send("say ��Ϣ����") end
		 switch(q)
	   end
	   f_wait(f,60)
	end
	local b=busy.new()
	b.interval=0.5
	b.Next=function()
		local xiulian=world.GetVariable("xiulian")
		if xiulian=="xiulian_jingli" then
			process.neigong2()
		elseif xiulian=="xiulian_neili" then
			process.neigong3()
		elseif xiulian=="xiulian_dubook" then
		   local cmd=world.GetVariable("dubook_cmd") or "du book"
			process.readbook(cmd)
		elseif xiulian=="xiulian_skills" then
			qqll:redo_collectData()
		else
			process.neigong3()
		end
	end
	b:check()

end
--[[
�������ڴ����йء�job������Ϣ��
����˵��������Ȼ��ˣ����鷳���ｫ���ｻ�� ������ ����������
��������Ķ�������˵���������������ײ���β���ϴ�ߣ���(luda)�������������������ټ��������ȥ����������
���ڸ���һ������ʯ�

��������������˵�������ú���������Щ�ƽ���Ц�ɡ� ...��
���϶���һЩ�ƽ�
����ת��������Ͳ����ˡ�
���������ã�������������
]]
function qqll:ask_job()
  local w=walk.new()
  w.walkover=function()
    world.Send("ask ma about ����ʯ")
	local b=busy.new()
	b.interval=0.5
	b.Next=function()
	  world.Send("ask ma about job")
	  wait.make(function()
	   local l,w=wait.regexp("^(> |)��������Ķ�������˵���������������ײ���β���ϴ�(.*)\\((.*)\\)����(.*)���������ټ��������ȥ����������$|^(> |)����˵����������������ôæ�������鷳�����ˡ���$|^(> |)����˵����������û��������Ҫ�鷳���ǡ���$|^(> |)����˵�������㻹û�������أ���ô��ɣ���$|^(> |)����˵������ǰ·ãã��.*����һ��ǰ����׳־�ɼΣ���ƶ��ȴ���ܷ��İ�����$",5)
	   if l==nil then
		  qqll:start()
	      return
	   end
	   if string.find(l,"�����������ײ���β") then
	      qqll.wait_count=0
	      local playername=w[2]
		  local playerid=w[3]
		  local location=w[4]
		  local b=busy.new()
		  b.Next=function()
		    qqll:xunwen_place(playername,playerid,location)
		  end
		  b:check()
	      return
	   end
	   --����˵����������û��������Ҫ�鷳���ǡ���
	   if string.find(l,"�㻹û�������أ���ô���") or string.find(l,"����û��������Ҫ�鷳����") then
	       main_Exe("follow none")
		   child_Exe("follow none")
		    main_Exe("/qqll.child_ready=false")
		    main_Exe("/qqll.master_ready=false")
	      qqll:jobDone()
		   child_Exe("/qqll.child_ready=false")
		    child_Exe("/qqll.master_ready=false")
		  child_Exe("/qqll:jobDone()")

	      return
	   end
	   if string.find(l,"�����鷳������") then
		   main_Exe("follow none")
		   child_Exe("follow none")
		    main_Exe("/qqll.child_ready=false")
		    main_Exe("/qqll.master_ready=false")
		    child_Exe("/qqll.child_ready=false")
		    child_Exe("/qqll.master_ready=false")
	       --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."������������:û�к��ʹ�����", "red", "black") -- yellow on white
           qqll:wait_moment(1)
		   child_Exe("/qqll:wait_moment()")
	       return
	   end
	   if string.find(l,"ǰ·ãã") then
	      child_Exe("/qqll:start()")
		  qqll:start()
	      return
	   end
	  end)
	end
	b:check()

  end
  w:go(644)
end

function qqll:jobDone()

end

function qqll:reward()
     child_Exe("follow none") --����id
   main_Exe("follow none") --����id
   child_Exe("/qqll:go_reward()") --����id
   main_Exe("/qqll:go_reward()") --����id
end

--[[
  ���������״����ӡ����Ǵ󷨡����ڱ�(Questa)
  ȫ����ƽ� ���칦���� ���(Hongji)
  Ǯׯ�ϰ塸ǧ��������������Ǯ��(Qian feng)
  ����(Da shou)]]

function qqll:go_reward()
   local ts={
	           task_name="����������",
	           task_stepname="����",
	           task_step=7,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."������������:����", "yellow", "black") -- yellow on white
   shutdown()
   local w=walk.new()
	w.walkover=function()

		local worldID=GetWorldID()
		if qqll.master_worldID==worldID then
		main_Exe("ask ma about ���")
		wait.make(function()
		  local l,w=wait.regexp("^(> |)������ɣ��㱻�����ˣ�$|^(> |)����˵�������㻹û�������أ���ô��ɣ���$|^(> |)����˵�������㻹û�������أ���ô��ɣ���$",10)
		  if l==nil then
		     qqll:reward()
		    return
		  end
		  if string.find(l,"�㱻������") or string.find(l,"�㻹û��������") then
		      print("����")
			  child_Exe("/qqll.master_ready=false")
	          main_Exe("/qqll.master_ready=false")
	          child_Exe("/qqll.child_ready=false")
	            main_Exe("/qqll.child_ready=false")
			  local b=busy.new()
		      b.Next=function()
		       qqll:jobDone()
			   child_Exe("/qqll:jobDone()")
		     end
		     b:check()
		     return
		  end
		end)
		end
	end
	w:go(644)
end

function qqll:giveup()
   child_Exe("follow none") --����id
   main_Exe("follow none") --����id
   child_Exe("/qqll:go_giveup()") --����id
   main_Exe("/qqll:go_giveup()") --����id
end

function qqll:go_giveup()
   local ts={
	           task_name="����������",
	           task_stepname="����",
	           task_step=7,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
	w.walkover=function()

		local worldID=GetWorldID()
	    if qqll.master_worldID==worldID then
		   main_Exe("ask ma about fangqi")
	        wait.make(function()
			  local l,w=wait.regexp("^(> |)���ڴ��������û�����ʯ��$|^(> |)����˵������������û�����������ʲô����$|^(> |)����˵������������û�����������ʲô����$",5)
			  if l==nil then
			     qqll:giveup()
				 return
			  end
			  if string.find(l,"����ʯ") or string.find(l,"û������") then
			     local b=busy.new()
				 b.Next=function()
				    qqll:main_link()
				 end
				 b:check()
			     return
			  end
			end)
	    end
	end
	w:go(644)
end

function qqll:lineup()
   world.Send("lineup form wuxing-zhen")
   world.Send("lineup with "..string.lower(qqll.partner1_id))
   child_Exe("lineup with "..string.lower(world.GetVariable("player_id")))
end

function qqll:continue()
  local cmd="/qqll:resume()"
   main_Exe(cmd)
end

function qqll:resume()
   coroutine.resume(qqll.co)
end

function qqll:stop_ok()
   if qqll.master_ready==true and qqll.child_ready==true then
       qqll.master_ready=false
	   qqll.child_ready=false
       qqll.main_link()
   end
end

function qqll:wait_stop()
   shutdown()
   world.DeleteVariable("qqll_player_status")
   local b=busy.new()
	b.interval=0.5
	b.Next=function()
	   local worldID=GetWorldID()
	   if qqll.master_worldID==worldID then
	     print("��id����!")
		 qqll.master_ready=true
		 qqll:stop_ok()
		 --qqll:recover_check()
	   else
	     print("��id����!")
		 local cmd="/qqll.child_ready=true"
		 main_Exe(cmd)

		 local cmd="/qqll:stop_ok()"
		 main_Exe(cmd)
	  end
	end
	b:check()
end

function qqll:wait_another_player()
	print("�ڹ�����")
	world.Send("unset ����")
	local b=busy.new()
	b.interval=0.5
	b.Next=function()
		local xiulian=world.GetVariable("xiulian")
		if xiulian=="xiulian_jingli" then
			process.neigong2()
		elseif xiulian=="xiulian_neili" then
			process.neigong3()
		elseif xiulian=="xiulian_dubook" then
		   local cmd=world.GetVariable("dubook_cmd") or "du book"
			process.readbook(cmd)
		elseif xiulian=="xiulian_skills" then
			process.lian()
		else
			process.neigong3()
		end
	end
	b:check()
end

function qqll:player_Status_recheck()
  --��ñ���ֵ
  print(qqll.child_ready," child_ready")
  print(qqll.master_ready," master_ready")
    if qqll.child_ready==true and qqll.master_ready==true then
      child_Exe("/qqll:wait_stop()")
	  main_Exe("/qqll:wait_stop()")
	  child_Exe("/qqll.master_ready=false")
	  main_Exe("/qqll.master_ready=false")
	  child_Exe("/qqll.child_ready=false")
	  main_Exe("/qqll.child_ready=false")
   else
      local f=function()
	     print("qqll ��������")
	     shutdown()
	     qqll:Player_Status_Check()
	  end
	  f_wait(f,30)
	  qqll:wait_another_player()
   end
end

function qqll:Player_Status_Check()
	--world.SetVariable("qqll_player_status","ok")

   --�Ƿ���id
   --��id ����
   local partner_id=world.GetVariable("qqll_partner_id") or ""
   local leader_id=world.GetVariable("qqll_leader_id") or ""

   if partner_id=="" then
	  print("qqll_partner_id ����û������")
	  print("����id ����Ҫ���ã�������Ϊ��")
	  qqll:wait_another_player()
	  return
   end

   --qqll.child_ready=false
   --qqll.master_ready=false
    for k, v in pairs (GetWorldIdList ()) do
      local player_id=GetWorldById (v):GetVariable("player_id") or ""
	  if string.lower(player_id)==string.lower(leader_id) then
	    qqll.master_worldID=v
	    break
	  end
	end
   print(qqll.master_worldID," master_worldID")
   for k, v in pairs (GetWorldIdList ()) do
    local player_id=GetWorldById (v):GetVariable("player_id") or ""
	if string.lower(player_id)==string.lower(partner_id) then
	   print(player_id)
	  if v~=qqll.master_worldID then
	        qqll.partner1_id=string.lower(partner_id)
	        qqll.child_worldID= v
	   break
	  end
	end
  end
  print(qqll.child_worldID," child_worldID")
  --����id ��������
  local cmd="/qqll.master_worldID='"..qqll.master_worldID.."'"
  child_Exe(cmd)
  main_Exe(cmd)
  cmd="/qqll.child_worldID='"..qqll.child_worldID.."'"
  child_Exe(cmd)
  main_Exe(cmd)

   if qqll.master_worldID==GetWorldID() then

      child_Exe("/qqll.master_ready=true")
	  main_Exe("/qqll.master_ready=true")
   else

      child_Exe("/qqll.child_ready=true")
	  main_Exe("/qqll.child_ready=true")
   end
  --qqll:wait_another_player()
   --cmd="/qqll:player_Status_recheck(true)'"
   --child_Exe(cmd)
  --main_Exe(cmd)
  qqll:player_Status_recheck()
end
