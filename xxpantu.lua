
--[[  ���䵱��Զ��������ask song about job�����������������
22: �������ڵ��ң�Ҫ��ȥ��һ������ָ���ĵط�����robber���ܺ󣬻�
23: ����Զ�����Ｔ�ɣ������Զ������exp��pot��
== ��ʣ 17 �� == (ENTER ������һҳ��q �뿪��b ǰһҳ)24:
25:     ���������ɣ���Ҫ��������ask song about ��������������
26: �µ�����
27:
28: ������������������������������������������������������������
29:                         ������̸֮��
30: ������������������������������������������������������������
31:
32:     ��������robber��������Ϲ�ȥ��Ҫʱ�䣬����robber��һ������
33: song������ķ��䣬����Ҫ����Ѱ��һ�¡���һ���ҵ��ˣ�������Ҫ
34: ע����ǣ�robber��������ɱ�㣬���robberû�н�ɱ�㣬�������߶�
35: һ�¾Ϳ����ˡ���Ҫ������ɱrobber��������ɱ��robber���ǿ�ġ�
36:
37:     *�޸Ĺ�����䵱�����˵�ֳ�7-10����Σ�ÿ���һ��������
38: ������һ�㣬������Ҳ����һ�㡣���ʧ����һ���������Ѷ��½�
39: һ����Ρ������µ�robber��ʹ��perform����Щ����ս�����ܸߵģ���
40: ����ҪС�ġ�
Τ����|�򹷰���|��������|��ɽ�ȷ�|��ս�����|��ָ��ͨ|���¾Ž�|����ذ��

��Щ�ǱȽ�������
��ָ��ͨ|����ذ��|�򹷰���
��3����2mǰ����2�»��������ļ���

Τ����  2-10m
> �麣�ö�����˵�����ٺ٣��е��Ҹ���������ү�Ҳ������ˣ�

]]

local heal_ok=false
xxpantu={
  new=function()
    heal_ok=false
    local xx={}
	 setmetatable(xx,xxpantu)
	 return xx
  end,
  co=nil,
  co2=nil,
  win=false,
  robber_name="",
  robber_id="",
  place="",
  reward_ok=false,
  playname="",
  menpai="",
  skills="",
  strong="",
  location="",
  depth="",
  is_checkPlace=false,
  look_robber=false,
  look_robber_place="",
  blacklist="",
  difficulty=1,
  --is_giveup=false,
  neili_upper=1.9,
  rooms={},
  exist_rooms={},
  beast_kill=false,
  beast="",
  kick_count=0,
  check_place_count=0,
}
xxpantu.__index=xxpantu

local combat_start_time=nil
local search_start_time=nil

function xxpantu:NextPoint()
   print("���ָ̻�")
   coroutine.resume(xxpantu.co)
end

function xxpantu:Child_checkRobber(npc,roomno)

  wait.make(function()
      world.Execute("look;set action 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������action \\= 1",6)
	  if l==nil then
		self:Child_checkRobber(npc,roomno)
		return
	  end
	  if string.find(l,"�趨����������action") then
	      --û���ҵ�
		  self:Child_NextPoint() --����һ������
		  return
	  end
	  if string.find(l,npc) then
	     --�ҵ�
		 self:auto_pfm()
		  local _id=w[3]
		  local _id=string.lower(Trim(w[2]))
		   self.robber_id=_id
           self:kill_robber(_id)
		  return
	  end
	  wait.time(6)
   end)
end

function xxpantu:Child_NextPoint()
   print("�ӽ��ָ̻�")
   coroutine.resume(xxpantu.co2)
end

--20����ͨ����
local function returnPath(dx)
  --��ͷ
  if dx=="east" then --1
    return "west"
  elseif dx=="west" then --2
     return "east"
  elseif dx=="north" then --3
     return "south"
  elseif dx=="south" then --4
     return "north"
  elseif dx=="northwest" then --5
     return "southeast"
  elseif dx=="northeast" then --6
     return "southwest"
  elseif dx=="southwest" then --7
     return "northeast"
  elseif dx=="southeast" then  --8
     return "northwest"
  elseif dx=="up" then --9
     return "down"
  elseif dx=="down" then --10
     return "up"
  elseif dx=="enter" then --11
     return "out"
  elseif dx=="out" then --12
     return "enter"
  elseif dx=="northup" then --13
     return "southdown"
  elseif dx=="northdown" then --14
     return "southup"
  elseif dx=="southup" then --15
     return "northdown"
  elseif dx=="southdown" then --16
     return "northup"
  elseif dx=="westup" then --17
     return "eastdown"
  elseif dx=="westdown" then  --18
     return "eastup"
  elseif dx=="eastup" then --19
     return "westdown"
  elseif dx=="eastdown" then  --20
     return "westup"
  end
  return false
end

local function reverse_path(path) --�ߵ�·��
    local P={}
	local P2={}
	P=Split(path,";")
	local n=table.getn(P)

	for i,v in ipairs(P) do
	   local g=returnPath(v)
	   if g==false then
	      return false
	   else
	      local location=n-i+1
	      table.insert(P2,location,g)
	   end
	end
	return P2

end

function xxpantu:quick_checkRobber(alias_txt)
  wait.make(function()
      marco(alias_txt)
      local l,w=wait.regexp("^(> |)�趨����������action \\= 1",6)
	  if l==nil then
		self:quick_checkRobber(alias_txt)
		return
	  end
	  if string.find(l,"�趨����������action") then
	      print("��ת����")
		  self:Child_NextPoint()
		  return
	  end
   end)

end

function xxpantu:auto_pfm()
   print("��ǰpfm")
end

function xxpantu:Child_Search(rooms,npc)
     local zone=partition(self.location)

	  --print("��������:",self.look_robber_place)
	  local zz=""
	 --local zone=partition(location)
	 for _,z in pairs(zone) do
	     print(z.zone)
	    if Trim(z.zone)~="" then
		   zz=z.zone
		   break
		end
	 end
	-- print("check ����:",zz..Trim(self.look_robber_place))
	local P=zz..Trim(self.look_robber_place)
-- ˿��֮· �ų���
    local is_reverse_ok=true
 local location=world.GetVariable("robber_place")
	location=Trim(location)
   if location=="ɽ��" or location=="˿��֮·" or location=='�����' or location=="����" or location=="���ԭ" or location=="ɳ̲" or location=="С��" then
      is_reverse_ok=false  --�������������
   end
   if P=="���ݳǴ��" or P=="��ɽɽ·" or P=="���ݳ�ɽ·" then
      is_reverse_ok=false  --�������������
   end

   local n=table.getn(rooms)
   print("��Ҫ������������:",n)
   if n>1 and is_reverse_ok==true then
      local i=self.section
	  local startroomno=self.sections[i].startroomno
	  local endroomno=self.sections[i].endroomno
	  local s=self.sections[i].alias_paths
	  print(s," ����������:",startroomno,"->",endroomno)
	  local g=reverse_path(s)
	  if g~=false then
	     self:auto_pfm()
	     local _id=self.robber_id
		 local cmd="kill "..self.robber_id
		 local alias_txt=""
		 for _,p in pairs(g) do
			alias_txt=alias_txt..p.."|"..cmd.."|#wa 500|"
		 end
		 alias_txt=alias_txt.."set action 1"
		 self:quick_checkRobber(alias_txt)
		 coroutine.yield()
		 return
	  end
	  --is_Special_exits
--south;north;north;north;north;north;north;northeast;northeast;north;north  ����������: 193 -> 341
   end
	local w
	w=walk.new()
	w.noway=function()
		--self:giveup()
		self:Child_NextPoint()
	end
    local al
	al=alias.new()
	al:SetSearchRooms(rooms)
	al.out_songlin=function()
		self.NextPoint2=function()
			print("���ָ̻�")
			self:Child_NextPoint()
		end
		al:finish()
    end
    al.out_zishanlin=function()
		self.NextPoint2=function()
			self:Child_NextPoint()
		end
		al:finish()
	end
	if string.find(self.look_robber_place,"�ɴ�") then
		print("ǿ���ڶɴ���")
		al.duhe=function()
			al:yellboat()
		end
		al.dujiang=function()
			al:yellboat()
		end
	end
	al.noway=function()
		self:Child_NextPoint()
	end
	al.songlin_check=function()
		self.NextPoint2=function() al:NextPoint() end
		self:Child_checkRobber(npc,1764)
	end
	al.maze_done=function()
	   self.NextPoint2=function() al.maze_step() end
	   self:Child_checkRobber(npc,nil)
	end
	--[[al.zishanlin_check=function()
		self.NextPoint2=function() al:NextPoint() end
		self:Child_checkRobber(npc,2464)
	end
	al.zishanlin2_check=function(n)
	    print("������:",n)
		self.NextPoint2=function() al:zishanlin_tiandifenglei(n) end
		self:Child_checkRobber(npc,2464)
	end

	al.circle_done=function()
		print("����")
		self.NextPoint2=function() coroutine.resume(al.circle_co) end

		self:Child_checkRobber(npc,998)
	end]]

	al.break_in_failure=function()
		--self:giveup()
		self:Child_NextPoint()
	end
	w.user_alias=al

   for _,r in ipairs(rooms) do

           print("��췿���:",r)
		   local target=tonumber(r)
		   w.walkover=function()
			 self:Child_checkRobber(npc,target)
		   end
		   w:go(target)
		   --wait.time(0.8)
		   coroutine.yield()
   end
end

function xxpantu:Check_Point_Robber()

	 --�ƺӶɴ�
	 --�ɴ�
	 local target_room={}

      --print("��������:",look_robber_place)
	  --self.look_robber_place=look_robber_place
	  --self.location=location
	 local zz=""
	 local zone=partition(self.location)

	  print("��������:",self.look_robber_place)
	 --local zone=partition(location)
	 for _,z in pairs(zone) do
	     print(z.zone)
	    if Trim(z.zone)~="" then
		   zz=z.zone
		   break
		end
	 end
	 self:auto_pfm()
	 print("check ����:",zz..Trim(self.look_robber_place))
	  local n,e=Where(zz..Trim(self.look_robber_place)) --��ⷿ����
      if table.getn(e)==0 then
	     n,e=Where(Trim(self.look_robber_place)) --��ⷿ����
	  end
	  for _,r in ipairs(e) do
		  print("���ݷ����1:",r)
	      table.insert(target_room,tonumber(r))
	  end
       print("�ӽ���")
      if self.section==nil then
	     self.section=1
	  end
	   if self.section>1 then
	       self.section=self.section-1 --����һ��
		else
		   self.section=table.getn(self.sections)
	    end
	    print("�����̻���һ��:",self.section)

	   self:check_next_point(target_room)
end

function xxpantu:check_next_point(target_room)
      xxpantu.co2=coroutine.create(function()
		 -- �ص���������ȥ
             self:Child_Search(target_room,self.robber_name)

		   print("�ص���������ȥ!")
		   xxpantu.co2=nil
		   self:robber_exist()
		   self:check_section()

	   end)
	   self:Child_NextPoint()
end

function xxpantu:combat()

end

function xxpantu:run(i)
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
	      self:run(i)
	      return
	   end
	   if string.find(l,"�����Ϊ����") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"��Ķ�����û����ɣ������ƶ�") or string.find(l,"������ʧ��") or string.find(l,"��ʱ�޷�ֹͣս��") then
		  self:run(i)
	      return
	   end
	   if string.find(l,"�趨����������action") then
		 world.DoAfter(1.5,"set action ����")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"����\\\"$|^(> |)�趨����������action \\= \\\"����\\\"$",5)
			if l==nil then
			   self:run(i)
			  return
			end
			if string.find(l,"����") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"����") then
			   shutdown()
			   world.Send("unset wimpy")
			   self:giveup()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function xxpantu:flee(i)
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
	 print(run_dx, " ����")
	 local halt
	 if _R.roomname=="ϴ��ر�" then
	    world.Send("alias pfm "..run_dx..";set action ����")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set action ����")
	 end
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
	 self:run(i)
   end
   _R:CatchStart()
end

function xxpantu:sure_robber()
end

function xxpantu:get_id(npc)
	wait.make(function()
		 world.Execute("look")
		 self:look()
	    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$",5)
		if l==nil then
		   self:get_id(npc)
		   return
		end
		if string.find(l,npc) then
		   local _id=string.lower(Trim(w[2]))
		   --world.Send("kill ".._id)
		   --self:auto_pfm()
		   self.robber_id=_id
		   --self:sure_robber()
		   --self:combat()
		   self:kill_robber(_id)
		   return
		end
		wait.time(5)
	end)
end
--> ���׶����㷢��һ����Ц��˵��������������ط�̫С�����ָ����ӵ�����Ȼ��Ȼ���
--> ���������˵������ƥ����׷���ᣬ��Ȼ�Ӳ�������ү�Ҹ���ƴ�ˣ�
--����۳��������鷿�뿪��
function xxpantu:auto_kill()
--�����˾ͽ�����һ��������ƥ���Ҿ����˼��˰�����~~��~~ħ�޵У���(-��-)y-�b�b�b"����
   wait.make(function()
      local l,w=wait.regexp("^(> |)(.*)�����㷢��һ����Ц��˵������Ȼ�������.*����Ҳ��ֻ�����������ˣ�|^(> |)(.*)������˵�����ٺ٣��е��Ҹ�������.*$|^(> |).*�����㷢��һ����Ц��˵��������������ط�̫С�����ָ�.*������Ȼ��Ȼ���$|^(> |)(.*)����˵����.*����׷���ᣬ��Ȼ�Ӳ�����.*�Ҹ���ƴ�ˣ�$|^(> |)�����"..self.robber_name.."���һ����.*$|^(> |)�����"..self.robber_name.."�ȵ���.*$",10)
      if l==nil then
	    self:auto_kill()
		return
	  end
	  if string.find(l,"����ط�̫С") then
	      shutdown()

		    local _R
            _R=Room.new()
			_R.CatchEnd=function()
               local count,roomno=Locate(_R)
			   local target_room=depth_search(roomno,1)  --1��Χ��ѯ
		       print("npc �ڰ�ȫ����")
			   print("�ӽ���")
	          xxpantu.co2=coroutine.create(function()
                self:Child_Search(target_room,self.robber_name)
		        --�ص���������ȥ
				xxpantu.co2=nil
				print("�ص���������ȥ!")
		        self:robber_exist()
		        self:check_section()
	          end)
	          self:Child_NextPoint()
			end
			_R:CatchStart()
	      return
	  end
	  if string.find(l,"��Ҳ��ֻ������������") or string.find(l,"�е��Ҹ�����") or string.find(l,"��Ȼ�Ӳ���") or string.find(l,"�����") then
		 self:auto_pfm()
	    local killshou=Trim(w[2])
		if killshou==nil or killshou=="" then
		    killshou=Trim(w[4])
		end
		if killshou==nil or killshou=="" then
		    killshou=Trim(w[7])
		end
		print("name:",killshou," ɱ��:",self.robber_name)
		if string.find(self.robber_name,killshou) then
		 if combat_start_time then
	       combat_usedtime = os.difftime (os.time(), combat_start_time)
		   if combat_usedtime<10 then
		      print("�Ѿ�����ս��״̬!!")
			  return
		   end
		 end
		   shutdown()
		    local ts={
	           task_name="������ͽ",
	           task_stepname="KOǿ��",
	           task_step=4,
	           task_maxsteps=5,
	           task_location=self.location.." ��Բ:"..self.depth,
	           task_description=self.robber_name.." ����:"..self.menpai.." ����:"..self.skills,
	        }
			local st=status_win.new()
		   st:init(nil,nil,ts)
		   st:task_draw_win()
		   self:get_id(self.robber_name)
		   self:robber_finish()

		   combat_start_time=os.time()
		   local interval=os.difftime(os.time(),search_start_time)

		   --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ����ʱ�䣡"..interval.." "..self.location.." depth:"..self.depth.."\r\n")
	       self:combat()
		else
		   self:auto_kill()
		end
	    return
	  end
	  wait.time(10)
   end)
end

function xxpantu:follow(id)
   print("ǿ������!!")
   self.kick_count=self.kick_count+1
   if self.kick_count>30 then
       print("����30������")
       self:giveup()
      return
   end
   world.Send("follow "..id)
   world.Send("kick "..id)
    local f1=function()
		self:NextPoint()
	end
   local f=function()
       local _R
      _R=Room.new()
      _R.CatchEnd=function()
          local exits=Split(_R.exits,";")
		   local n=table.getn(exits)
	      local seed=math.random(n)
		  local comeback=""
		  if exits[seed]=="east" then
		    comeback="east;west"
		  elseif exits[seed]=="eastup" then
		    comeback="eastup;westdown"
  		  elseif exits[seed]=="eastdown" then
		    comeback="eastdown;westup"
		  elseif exits[seed]=="west" then
		    comeback="west;east"
		  elseif exits[seed]=="westup" then
		    comeback="westup;eastdown"
		  elseif exits[seed]=="westdown" then
		    comeback="westdown;eastup"
		  elseif exits[seed]=="north" then
		    comeback="north;south"
		  elseif exits[seed]=="northup" then
		    comeback="northup;southdown"
		  elseif exits[seed]=="northdown" then
		    comeback="northdown;southup"
		  elseif exits[seed]=="south" then
		    comeback="south;north"
		  elseif exits[seed]=="southup" then
		    comeback="southup;northdown"
		  elseif exits[seed]=="southdown" then
		    comeback="southdown;northup"
		  elseif exits[seed]=="up" then
		    comeback="up;down"
		  elseif exits[seed]=="down" then
		    comeback="down;up"
		  elseif exits[seed]=="out" then
		    comeback="out;enter"
		  elseif exits[seed]=="enter" then
		    comeback="enter;out"
		  elseif exits[seed]=="northeast" then
		    comeback="northeast;southwest"
		  elseif exits[seed]=="northwest" then
			comeback="northwest;southeast"
		  elseif exits[seed]=="southwest" then
		    comeback="southwest;northeast"
		  elseif exits[seed]=="southeast" then
		    comeback="southeast;northwest"
		  end
		  world.Execute(comeback)
		  self:checkRobber(self.robber_name,nil,f1)
       end
       _R:CatchStart()
	   return
   end
   print("�ȴ�����,�����ƶ���!")
   f_wait(f,5)
end

local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    print("��ǰ����:",v)
	    if v==r then
		   print("��ͬ")
		   return true
		end
	end
	print("��ͬ")
	return false
end

--����û������ˡ�
function xxpantu:kill_robber(id)

      wait.make(function()
       --world.Send("follow "..id)
	    --print("����Σ�ն����npc:",self.beast_kill)

		--if self.beast_kill==false then
		    world.Send("kill "..id)
			--self:auto_pfm()--�����Ϳ�������ͺ�һ����������������Ľ��������ļ��գ��ô�ү��������·�ɣ�����
		  local l,w=wait.regexp("^(> |)�����.*(���|�ͺ�)һ����.*$|^(> |)���ͣ����ͣ�$|�����.*�ȵ���.*$|^(> |)����Ҫ����������ͻȻ�������˽���һ�ģ��úÿ����䣬���Ҷ���$|^(> |)����û������ˡ�$|^(> |)���ﲻ׼ս����$|^(> |)����û�� "..id.."��$",2)
		  if l==nil then
		    self:kill_robber(id)
		    return
		  end
		  if string.find(l,"���һ��") or string.find(l,"�ͺ�") or string.find(l,"����") or string.find(l,"�ȵ�") then
		    --combat_start_time=os.time()
			--local interval=os.difftime(os.time(),search_start_time)

		   --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ����ʱ�䣡"..interval.." "..self.location.." depth:"..self.depth.."\r\n")
			  world.Send("look")
			  self:look()
			--world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ս����ʼ��\r\n")
			self:robber_finish()
			self:combat()
	        self:sure_robber()
	        return
	      end
	      if string.find(l,"����Ҫ��������") then
		    self:follow(id)
		   --[[world.Send("kick "..id)
 		   local f=function()
		     local b=busy.new()
		     b.interval=0.5
		     b.Next=function()
		      self:kill_robber(id)
		     end
		     b:check()
		   end
		   f_wait(f,1.5)]]
	       return
	      end
	      if string.find(l,"����û�������") or string.find(l,"����û��") then
	        --self:NextPoint()
			 --if xxpantu.co2~=nil then
			 --   self:Child_NextPoint()
             --else
			  self:robber_exist()
			  self:check_section()
			 --end
	        return
		  end
	      if string.find(l,"���ﲻ׼ս��") then
            --world.Send("kick "..id)
		    --wait.time(2)
		    --self:kill_robber(id)
			self:follow(id)
            return
	      end
		--else
		--  self:check_beast_kill_again(id)
		--end
	 end)
end

local zone=""
function xxpantu:look()

    wait.make(function()
	   local l,w=wait.regexp("^(> |)(.*) -.*|^(> |)��������������(.*)��$",5)
	   if l==nil then
	      --self:look()
	      return
	   end
	   if string.find(l,"������������") then

		   zone=w[4]
		   print(zone)
		   self:look()
	      return
	   end
	   if string.find(l,"-") then
	       local line, total_lines
           total_lines = GetLinesInBufferCount ()
           local relation=""
           for line = total_lines - 5, total_lines-1 do
              relation=relation..Trim(GetLineInfo (line, 1))
           end
		    relation=string.gsub(relation,"%-%-%-%-%-","��")
	       relation=string.gsub(relation,"%-%-%-%-","��")
	       relation=string.gsub(relation,"%-%-%-","��")
	       relation=string.gsub(relation,"%-%-%s*","��")
           relation=string.gsub(relation,"%s*%��","��")
	       relation=string.gsub(relation,"%s*%��","��")

	       relation=string.gsub(relation,"%-%-","��")
	       relation=string.gsub(relation,"% % % ","  ")
	       relation=string.gsub(relation,"% % % % % "," ")
	       relation=string.gsub(relation,"% % % % "," ")
	       relation=string.gsub(relation,"% % % "," ")
	       relation=string.gsub(relation,"% % "," ")
		   --print("relation:",relation)
	      local roomname=w[2]
		  --print(roomname)
		  local _RA=Room.new()
		  _RA.zone=zone
		  _RA.roomname=roomname
		  _RA.relation=relation
	      local count,roomno=Locate(_RA)
		  print("����ս�������:",roomno[1])
		   _G["fight_Roomno"]=roomno[1]
	      return
	   end
	end)
end

function xxpantu:checkRobber(npc,CallBack)

  wait.make(function()
      world.Execute("look;set action 1")
	  self:look()
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������action \\= 1$",6)
	  if l==nil then
		self:checkRobber(npc,CallBack)
		return
	  end
	  if string.find(l,"�趨����������action") then
	       if self.look_robber==true then --·�Ͼ���
		     self.look_robber=false--ֻ���һ��
			 print("·�Ͼ���")
			 self:Check_Point_Robber()--��� ������ �ص�section��ʼ����

		   else
             if CallBack==nil then
			   self:check_section()
			 else
			   print("�Թ�")
			   CallBack()
			 end
			  --
		   end
		  return
	  end

	  if string.find(l,npc) then
	      print("�ҵ�")
		  self:auto_pfm()
		  --self:follow(id)
  		   local _id=string.lower(Trim(w[2]))
		   self.robber_id=_id
           self:kill_robber(_id)
		  return
	  end

   end)
end

function xxpantu:checkPlace(roomno,here,is_omit)
       print("��ʼ����:",roomno)

      if is_contain(roomno,here) or is_omit==true then
	       print("ȷ�����������->Next Room")
		   --self.is_checkPlace=false
		   self.check_place_count=0
		   local b
		   b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      print("ִ��")
		      local i=self.section
			  local s=self.sections[i]
		      local tr=traversal.new()

			 --self.rooms={}
			--[[  local ex_rooms={}
               ex_rooms=Split(self.sections[i].alias_rooms,";")
             for _,g in ipairs(ex_rooms) do
		       if g~=nil then
			     print("���뷿���:",g)
				 if self.exist_rooms[g]==true then
				   print("�Ѿ��������",g)
				 else
                   table.insert(self.rooms,g)
				 end
	           end
             end]]

			  local al=alias.new()
			  al:SetSearchRooms(self.rooms)
			  al.break_in_failure=function()
			      print("�޷�����,����·��")
			      self.section=self.section+1 --����
				  self:checkRobber(self.robber_name)
			  end
			   al.xidajie_mingyufang=function()
                  world.Send("north")
                  wait.make(function()
                  local l,w=wait.regexp("^(> |)����.*|С���Ѳ�Ҫ�����ֵط�ȥ����",5)
	              if l==nil then
	                al:finish()
	                return
				  end
	              if string.find(l,"С���Ѳ�Ҫ�����ֵط�") then
				     print("�޷������Ժ���������ɱ���·����")
				     local n,e=Where(self.location)
	                 self:c_paths(e,self.depth,"xidajie_mingyufang",true)
	                 return
	              end
				  if string.find(l,"����") then
	                 al:finish()
					 return
	              end
                  end)
               end
			  --  �����޷�����ķ��� ����  ���ݾƵ� ����С�Ƶ�
			  al.waitday_south=function() --����С�ƹ�
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==1068 then
	                   al:finish()
	               elseif roomno[1]==1065 then
						print("�޷�����,����·��")
						self.section=self.section+1 --����
						self:checkRobber(self.robber_name)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:waitday_south()
					   end
		               w:go(1065)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.xidajie_shouxihujiulou=function()
			      world.Send("north")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==109 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("�޷�����,����·��")
						self.section=self.section+1 --����
						self:checkRobber(self.robber_name)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:xidajie_shouxihujiulou()
					   end
		               w:go(108)
	               end
                 end
                 _R:CatchStart()
			  end

			  al.xidajie_shoushidian=function()
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==111 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("�޷�����,����·��")
						self.section=self.section+1 --����
						self:checkRobber(self.robber_name)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:xidajie_shoushidian()
					   end
		               w:go(108)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.nanmen_chengzhongxin=function()
			      world.Send("north")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==2349 then
					   table.insert(self.rooms,2349)
					    self.exist_rooms[2349]=true
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("�޷�����,����·��")
						self.section=self.section+1 --����
						self:checkRobber(self.robber_name)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:nanmen_chengzhongxin()
					   end
		               w:go(1972)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.noway=function()
			      print("����·��")
			      self.section=self.section+1 --����
				  self:checkRobber(self.robber_name)
			  end
			 --[[ al.circle_done=function()
		         print("����")
		         local f2=function()
				    coroutine.resume(alias.circle_co)
			     end
			     self:checkRobber(self.robber_name,f2)
		      end]]
			  ---
		    al.songlin_check=function()
			  print("�Թ�check npc")
	          local f2=function() al:NextPoint() end
			  self:checkRobber(self.robber_name,f2)
			end
			al.maze_done=function()
			   print("�Թ�check npc")
			   local f2=function() al.maze_step() end
			   self:checkRobber(self.robber_name,f2)
			end
			--[[al.zishanlin_check=function()
			   print("��ɼ·check")
	          local f2=function() al:NextPoint() end
			  self:checkRobber(self.robber_name,f2)
		    end
			al.zishanlin2_check=function()
			   --print("������")
			   print("��ɼ·2check")
	          local f2=function() al:zishanlin_tiandifenglei() end
			  self:checkRobber(self.robber_name,f2)
		    end]]
			  ---
			  tr.user_alias=al
			  tr.step_over=function()
			     --���ǿ��
				 print("���ǿ��")
			     self:checkRobber(self.robber_name)
			  end
			  self.section=self.section+1 --����
	          tr:exec(s) --����
		   end
		   b:check()
	   else
	   --û���ߵ�ָ������
	     print("û���ߵ�ָ������")
         self.check_place_count=self.check_place_count+1
		 if self.check_place_count>3 then
		    --self.check_place_count=0
			print("����3��ʧ�� ������")
			self:checkPlace(roomno,here,true)
		    return
		 end
	      local w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		    --  �����޷�����ķ��� ����  ���ݾƵ� ����С�Ƶ�
			  al.waitday_south=function() --����С�ƹ�
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==1068 then
	                   al:finish()
	               elseif roomno[1]==1065 then
						print("�޷�����,����·��")
						--self.section=self.section+1 --����
						self:checkPlace(roomno,here,true)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:waitday_south()
					   end
		               w:go(1065)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.xidajie_shouxihujiulou=function()
			      world.Send("north")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==109 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("�޷�����,����·��")
						--self.section=self.section+1 --����
						--self:checkRobber(self.robber_name)
						self:checkPlace(roomno,here,true)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:xidajie_shouxihujiulou()
					   end
		               w:go(108)
	               end
                 end
                 _R:CatchStart()
			  end

			  al.xidajie_shoushidian=function()
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==111 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("�޷�����,����·��")
						--self.section=self.section+1 --����
						--self:checkRobber(self.robber_name)
						self:checkPlace(roomno,here,true)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:xidajie_shoushidian()
					   end
		               w:go(108)
	               end
                 end
                 _R:CatchStart()
			  end
			  al.nanmen_chengzhongxin=function()
			      world.Send("north")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==2349 then
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("�޷�����,����·��")
						--self.section=self.section+1 --����
						--self:checkRobber(self.robber_name)
						self:checkPlace(roomno,here,true)
	               else
					   local w
		               w=walk.new()
	       	           w.walkover=function()
		                  al:nanmen_chengzhongxin()
					   end
		               w:go(1972)
	               end
                 end
                 _R:CatchStart()
			  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkRobber(self.robber_name)
		  end
		  w:go(roomno)
	   end
end

function xxpantu:check_section()

    local sections=self.sections
	local i=self.section or 1
	if i>table.getn(sections) then
       print("Ѳ�����һ��")
	   print(self.round," ����")
	   if self.round>3 then
	       self:giveup()
		   return
	   else

	       self.round=self.round+1
		   self.section=1
	       i=1
	   end
	else
	   print("����Ѳ��")
	   print(i)
	end
	local aim_roomno=sections[i].startroomno
	local f=function(r)
		 self:checkPlace(aim_roomno,r)
	end
	WhereAmI(f,10000) --�ų����ڱ仯
end

function xxpantu:Search(paths,rooms,npc)
    self.round=1
	--world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ��ʼ����\r\n")
	-- CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:��������", "blue", "black") -- yellow on white
    self.is_checkPlace=true
	self:robber_exist()
	--print("paths",paths)
	local tr=traversal.new()
	self.sections=tr:fast_walk(paths,rooms) --����
	print("-------------")
    for i,v in ipairs(self.sections) do
      print(i)
	  print(v.startroomno)
	  print(v.alias_paths)
	  print(v.endroomno)
	  print(v.alias_rooms)
	  print("-------------")
    end
	local al=alias.new()
	local r=Split(rooms,";")
	-- print("-------start------")
	 local _r1={}
	 local _r2={}
	for _,e in ipairs(r) do

	   if _r1[e]==nil then
	       _r1[e]=e
		   table.insert(_r2,e)
		    --print("��ʾ��صķ����:",e)
	   end
	end
	 --print("------end-------")
	al:SetSearchRooms(_r2)
	al.noway=function()
	   self:giveup()
	end
	al.maze_done=function()
	   print("xxpantu ִ�������Թ�")
	   self:checkRobber(self.robber_name,al.maze_step)
	end
	al.nanmen_chengzhongxin=function()
		if self.look_robber==true then --·�Ͼ���
		     self.section=1 --·��
		     self.look_robber=false--ֻ���һ��
			 print("·�Ͼ���")
			 self:Check_Point_Robber()--��� ������ �ص�section��ʼ����
		else
			world.Send("north")
            local _R
            _R=Room.new()
            _R.CatchEnd=function()
               local count,roomno=Locate(_R)
	           print("��ǰ�����",roomno[1])
	           if roomno[1]==2349 then
	              al:finish()
	           elseif roomno[1]==1972 then
				 local f=function()
		           al:nanmen_chengzhongxin()
			     end
		        f_wait(f,10)
			  else
                local w
		         w=walk.new()
		         w.walkover=function()
		            al:nanmen_chengzhongxin()
		         end
		         w:go(1972)
	          end
            end
            _R:CatchStart()
		end
	end
	al.break_in_failure=function()
	   self:giveup()
	end
	local w=walk.new()
	 w.noway=function()
		self:giveup()
	end
	w.user_alias=al
	w.walkover=function()
	    ---ִ��ǰ �� check roomno
	    self.section=1 --·��
		self.rooms={}
		self.exist_rooms={}
		local ex_rooms={}
        ex_rooms=Split(self.sections[1].alias_rooms,";")
       for _,g in ipairs(ex_rooms) do
		   if g~=nil then
		      --print("���뷿���:",g)
			  if g==2250 then
			       table.insert(self.rooms,2251)
				   self.exist_rooms[2251]=true
				   table.insert(self.rooms,2252)
				   self.exist_rooms[2252]=true
				   table.insert(self.rooms,2253)
				   self.exist_rooms[2253]=true
				   table.insert(self.rooms,2254)
				   self.exist_rooms[2254]=true
			  end
			  self.exist_rooms[g]=true
              table.insert(self.rooms,g)
	       end
       end
	    self:checkRobber(npc)
	end
	w.current_room=1957
	w:go(tr.startroomno)	--�ߵ���ʼ����
end

function xxpantu:c_paths(e,depth,omit,opentime)
  depth=depth+4
  local paths,rooms=depth_path_search(e,depth,omit,opentime)  --����·�� �����
  --print(paths)
   print(rooms)
   print("��Ҫ��������")
   local ex_rooms={}
   local ex_list={}
   ex_rooms=Split(rooms,";")
   for _,g in ipairs(ex_rooms) do
      --if ex_list[g]==nil then
	   -- ex_list[g]=g
		self.exist_rooms[g]=true
        table.insert(self.rooms,g)
	  --end
   end

   if paths~="" then
      self:auto_kill()
	  self:beast_kill_check()
	  local b
	  b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	     world.Send("yun recover")
	     self:shield()
	     self:Search(paths,rooms,self.robber_name)
	  end
	  b:check()
	else
	  self:giveup()
    end
end

function xxpantu:robber(location,depth,npc)
	local ts={
	           task_name="������ͽ",
	           task_stepname="��ǿ��",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=self.location.." ��Բ:"..self.depth,
	           task_description=self.robber_name.." ����:"..self.menpai.." ����:"..self.skills,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --print("robber ",location," ",depth," ",npc)

   local n,e=Where(location)

   --print(n)
   if n==0 then
       print("�����ڸ÷��䣡��")
       self:giveup()
       return
   end
   local party=world.GetVariable("party") or ""
	local mastername=world.GetVariable("mastername") or ""
   local omit=""
   if string.find(location,"������") or string.find(location,"��ɽ��") then
        --fengyun��longhu��north �� tiandi
      omit="fengyun|longhu|tiandi|xiaoxi_dufengling|huigong|dujiang"
   end
   if string.find(location,"�����") then
      omit="dufengling_xiaoxi"
   end
   if string.find(location,"��ɽ����") then
      omit="duanyaping_yading|qingyunpin_fumoquan|duhe"
   end
   if string.find(location,"��ɽ") then
      omit="baizhangjian_xianchoumen|xianchoumen_baizhangjian|t_leave|R3108|shanjian_longtan"
   end
   if string.find(location,"��ɽ��") then
      omit="dujiang"
   end
   if string.find(location,"������") then
      omit="shatan_shenlongdao"
   end
   if string.find(location,"������") then
      omit="shenlongdao_shatan"
   end
   if string.find(location,"����ɽ") then
      omit="houshanxiaolu_guanmucong|R1712"
   end
   if string.find(location,"���ݳ�") then
      omit="duhe|shamo_qingcheng|climb_shanlu"
   end
  if string.find(location,"���ݳ�") then
      omit="dujiang|beimenbingying_jianyu|yamendating_yamenzhengting|bingyingdamen_bingying|ll_sl"
   end
   if string.find(location,"������") then
      omit="haibing_taohuadao"
   end
   if string.find(location,"�䵱ɽ") then
     --if party=="�䵱��" and mastername=="������" then
       omit="xiaojing2_xiaojing1|xiaojing2_yuanmen|yitiantulong|dujiang|holdteng|zuanshulin|dujiang|holdteng"
	 --else
       --omit="yitiantulong|dujiang|holdteng"
     --end
   end
   if string.find(location,"��ɽ") then
      omit="duhe|shamo_lvzhou|R6154"
   end
   if string.find(location,"����ɽ") then
     omit="zoulang_shufang|movebei"
   end
   if string.find(location,"���޺�") then
     omit="zuan|push_door|zhenyelin|chengzhongxin_nanmen|nanmen_chengzhongxin|dacaoyuan_yingmen|shamo_caoyuanbianyuan"
   end
   if string.find(location,"���ݳ�") then
      omit="swim"
   end
   if string.find(location,"������") then
      omit="dangtianmen_xiuxishi"
   end
   if string.find(location,"�ɶ���") then
      omit="shamo_qingcheng|xiaoxi_dufengling|dufengling_xiaoxi"
   end
   if string.find(location,"������") or string.find(location,"ţ�Ҵ�") then
      omit="haibing_taohuadao"
   end
   --
   if string.find(location,"��٢��ɽׯ") or string.find(location,"����Ľ��") or string.find(location,"������") then
      omit="xiaodaobian_matou|quyanziwu|tanqin|qumr|yellboat|zuan_didao|didao|jump liang|yanziwu|push_qiaolan|shanzhuang|xiaodao"
   end
   if string.find(location,"����") then
     omit="juyiting_longwangdian|zishanlin_ruijin|tiandifenglei_feng|tiandifenglei_di|tiandifenglei_tian|tiandifenglei_lei|west_zishanlin_tiandifenglei_quick|east_zishanlin_tiandifenglei_quick" --zishanlin_search|
     if Trim(location)=="��������" then
        table.sort(e,function(a,b) return a>b end) --��������
		depth=5
	 elseif Trim(location)=="���̹㳡" then
	    omit=omit.."|zishanlin_zishanlin2_quick"
     end
  end
   if string.find(location,"��ң��") then
      omit="push_door|shamo_caoyuanbianyuan|shamo_sichouzhilu|xingxiuhai_north|nanmen_chengzhongxin|R2064|R1965|R3875"
	  if string.find(location,"��ң���ּ�С��") then
          e={4238}

	  end
   end
   if string.find(location,"������") then
      omit="changjie_changjie|caidi_cunzhongxin|changjie_nandajie|R651|shamo_lvzhou|duhe"

   end
   if string.find(location,"�ƺ�����") then
      omit="xiaofudamen_xiaofudating|duhe"
	 if string.find(location,"�ƺ�����ƺӰ���") then
	    e={742,760,761,762,763,764,765}

     end
	 depth=8
   end
   if string.find(location,"ؤ��") then
      omit="dujiang|beimenbingying_jianyu|yamendating_yamenzhengting"
	  e={1001}
   end

   if string.find(location,"�䵱��ɽ") then
      omit="jump_river|pa ya"
   end
   if string.find(location,"���ݳ�") then
      omit="dujiang"
   end

   if string.find(location,"���ݳ�") then
      omit="enter_meizhuang|yamendating_yamenzhengting|bingyingdamen_bingying"
	  if string.find(location,"ɽ·") then
	    omit=omit.."|changlang_huanglongdong"
	  end
   end
   if string.find(location,"�����") then
      omit="yuren"
   end
   if string.find(location,"�����") then
       omit="zhenyelin|shamo_sichouzhilu|shamo_caoyuanbianyuan|R2064|R2049"
   end
   if string.find(location,"�置") then
      --if wdj.wdj2_ok==false or wdj.wdj2_ok==nil then

	     if string.find(location,"�置ɽ·") then
		    if wdj.wdj2_ok==true then
	          n=8
		      e={3157,3187,3196,3197,3198,3199,3200,3202}
		    else
			   self:giveup() --�嶾�̲�����ֱ�ӷ���
			   return
			end
		 end
	      omit="shanjiao_shanlu"
	  --end
   end
   if string.find(location,"���ݳ�") then
      local al=alias.new()
	  al.finish=function(result)
	     --print(result," ���")
	     self:c_paths(e,depth,omit,result)
	  end
	  al:opentime("fuzhouchengnanmen")
	  return
   end
   if string.find(location,"��ɽʯ��") then
		e={1508}
   end
   if string.find(location,"��������") then
      omit="knockgatesouth|opengatenorth"
   end
	if string.find(location,"��ɽ") then

      omit="shiguoya_shiguoyadongkou|siguoya_jiashanbi"
   end
   local sindex,eindex=string.find(location,"���ԭ")
   if sindex==1 then
      e={2438}
   end
   if string.find(location,"�ؽ�") then
      omit="caoyuanbianyuan_heishiweizi|dacaoyuan_yingmen|zhenyelin|nanmen_chengzhongxin|R2049|R1965|R4994|caoyuanbianyuan_heishiweizi"
   end
   if string.find(location,"��ľ��") then
      omit="yading_riyuepin|riyuepin_yading"
   end
   if string.find(location,"����ׯ") then
      omit="hubinxiaolu_hubinxiaolu|hubinxiaolu_guiyunzhuang|east_taohuazhen"
   end
   if string.find(location,"�䵱ɽ") then
     omit="xiaojing_xiaojing1|xiaojing2_xiaojing1"
   end
     if string.find(location,"��ɼ��") then
	  e={2466,2461,2462,2464,2465,3041}
	end
    if string.find(location,"����ɽ") then
      omit="songlin1_songlin2"
   end
   --print("omit:",omit)
  -- self:c_paths(e,depth,omit,true)
   if string.find(location,"ƽ����") then
      omit="duhe|dutan|shamo_lvzhou"
   end
   self:c_paths(e,depth,omit,true) --�̶���Χ
end

--[[function xxpantu:robber(location,depth,npc)

    local round=1
	local ts={
	           task_name="�䵱",
	           task_stepname="��ǿ��",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=self.location.." ��Բ:"..self.depth,
	           task_description=self.robber_name.." ����:"..self.menpai.." ����:"..self.skills,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --print("robber ",location," ",depth," ",npc)
   local n,e=Where(location)
   print("������Ŀ:",n)
	local rooms=depth_search(e,tonumber(depth))  --��Χ��ѯ
	self.rooms=rooms
    if n>0 then

	 self:auto_kill()
	 self:beast_kill_check()
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   world.Send("yun recover")
	   self:shield()
	   print("ץȡ")
	   xxpantu.co=coroutine.create(function()
		 print(table.getn(rooms),"������")
        self:Search(rooms,npc)
		print("û���ҵ�npc!!")
		if  table.getn(rooms)<=40 and round==1 then
		   print("���³���һ��")
		   self:Search(rooms,npc)
		   self:giveup()
		else
		  self:giveup()
		end
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��")
	  self:giveup()
	end
end]]

function xxpantu:robber_die() --����
end

function xxpantu:roober_die2()  --����
end

function xxpantu:robber_finish()

--�����һ�������ã���ת��������Ͳ����ˡ�
--������ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ���ϼ��һ�������ã���ת��������Ͳ����ˡ�
--���졸ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
   wait.make(function()
      local l,w=wait.regexp("^(> |)(.*)��һ�������ã���ת��������Ͳ����ˡ�|^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯.*|^(> |)(.*)��һ����.*�������ˣ�ת��������Ͳ����ˡ�$",10)
	  if l==nil then
	     self:robber_finish()
		 return
	  end
	   if string.find(l,"������") then
	    local name=w[6]
		 print(name)
		 if string.find(self.robber_name,name) then
		    self.win=true
			self:robber_die()
		 else
		    self:robber_finish()
		 end
	     return
	  end
	  if string.find(l,"ת��������Ͳ�����") then
	     local name=w[2]
		 print(name)
		 if string.find(self.robber_name,name) then
		    self.win=true
			self:robber_die()
		 else
		    self:robber_finish()
		 end
		 return
	  end
	  if string.find(l,"һ�����ڵ���") then
	     local name=w[4]
		 print(name)
		 if string.find(self.robber_name,name) then
		    self.win=true
			self:robber_die2()
		 else
		    self:robber_finish()
		 end
		 return
	  end
	  if string.find(l,"������") then
	    local name=w[6]
		 print(name)
		 if string.find(self.robber_name,name) then
		    self.win=true
			self:robber_die()
		 else
		    self:robber_finish()
		 end
	     return
	  end
      wait.time(10)
   end)
end

function xxpantu:deal_blacklist(skill,party)
   if self.blacklist=="" or self.blacklist==nil then
      return false
   end
   local blacklist=Split(self.blacklist,"|")
	for _,b in ipairs(blacklist) do
		if string.find(skill,b) or string.find(party,b) then
		  return true
		end
	end
	return false
end

function xxpantu:redure_difficulty()

   --self.is_giveup=true
   local w
   w=walk.new()
   w.walkover=function()
       world.Send("ask song yuanqiao about ����")
       wait.make(function()
	   --��Զ��˵������Ҷ֪�����û��������������Ϲ����ʲôѽ����
	   --��Զ��˵������Ҷ֪�����û��������������Ϲ����ʲôѽ����
	      local l,w=wait.regexp("^(> |)��Զ��˵������"..self.playname.."������û��������������Ϲ����ʲôѽ����$|^(> |)��Զ��˵������"..self.playname.."����̫����ʧ���ˣ���Ȼ��ô���ɲ��ã������°ɣ���$|^(> |)��Զ��˵������"..self.playname.."���������ȷʵ�Ƚ�����ɣ��´θ���򵥵ģ������°ɣ���$",5)
		  if l==nil then
		     self:redure_difficulty()
		     return
		  end
		  if string.find(l,"Ϲ����ʲôѽ") then
		    self:Status_Check()
			return
		  end
		  if string.find(l,self.playname) then
		     local b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:robber(self.location,self.depth,self.robber_name)
			 end
			 b:check()
		     return
		  end
		  wait.time(5)
	   end)
   end
   w:go(1957)
end

function xxpantu:select_difficulty(strong)

    local _diff
    if strong=="����Ϊ��" then
	   _diff= 1
	elseif strong=="��Ϊ�˵�" then
	   _diff=2
	elseif strong=="��������" then
	   _diff=3
	elseif strong=="���뻯��" then
	   _diff=4
	else
	   _diff=1
	end
	if self.difficulty=="" then
	   self.difficulty=1
	end
	 print("�����Ѷ�:",self.difficulty,"  ?> ��ǰ�Ѷ�",_diff)
    if tonumber(self.difficulty)>=_diff  then
	    self:robber(self.location,self.depth,self.robber_name)
    else --�����Ѷ�
		--self:redure_difficulty()
		self:giveup()-- ֱ�ӷ���
	end
end

function xxpantu:npc_strong()

   wait.make(function()
      local l,w=wait.regexp("^(> |)����������Ķ�������˵�������˵��书(.*)����ɵ�С�ĶԸ�Ŷ��$|^(> |)�趨����������ask \\= \\\"YES\\\"$",5)
	  if l==nil then
	     self:npc_strong()
		 return
	  end
	  if string.find(l,"����������Ķ�������˵��") then
	     local strong=w[2]
		 self.strong=strong
		 print("ǿ��")
	     --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �书ǿ��:"..strong.."\r\n")
		  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:�Ѷ� "..strong, "red", "black") -- yellow on white
		 --self.robber_name=npc �����ɵ���ͽ����Ϊ�ó���ɽ�ȷ��Ĺ���
		 if self:deal_blacklist(self.skills,self.menpai)==true then
			--world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ����������ֱ�ӷ���\r\n")
			 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:����������,����", "red", "black") -- yellow on white
		    self:giveup()
		    return
		 end
		 print("�Ѷȿ���:",strong)
		 self:select_difficulty(strong)
	    return
	  end
	  if string.find(l,"�趨����������ask") then --�Ѷ�ȷ��
        self.strong=""
		print("��ͨ�Ѷ�")
		--world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �书ǿ��:��ͨ".."\r\n")
		 -- CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:�Ѷ� ��ͨ", "white", "black") -- yellow on white
		 --self.robber_name=npc �����ɵ���ͽ����Ϊ�ó���ɽ�ȷ��Ĺ���
		 if self:deal_blacklist(self.skills,self.menpai)==true then
		    --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ����������ֱ�ӷ���\r\n")
			 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:����������,����", "red", "black") -- yellow on white
		    self:giveup()
		    return
		 end
		 self:robber(self.location,self.depth,self.robber_name)
		return
	  end
	  wait.time(5)
   end)
end

function xxpantu:robber_exist()

   world.AddTriggerEx ("robber_place", "^(> |)(.*) - .*$", "print(\"%2\")\nSetVariable(\"robber_place\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 1000)
  wait.make(function()
    local l,w=wait.regexp("^(> |).*\\\s"..self.robber_name.."\\\((.*)\\\).*$",5)
	if l==nil then
	  self:robber_exist()
	  return
	end
	if string.find(l,self.robber_name) then
	  world.EnableTrigger("robber_place",false)
	  world.DeleteTrigger("robber_place")
	  self.look_robber=true
	  local location=world.GetVariable("robber_place")
	  location=Trim(location)
	  self.look_robber_place=location

      self.robber_id=string.lower(Trim(w[2]))
	  print("���ֵص�:",location," npc id:",self.robber_id)
	  --world.DeleteVariable("beauty_place")
	  return
    end
	wait.time(5)
  end)
end

function xxpantu:gongfu(npc,location,depth)

   if zone_entry(location)==true then
      --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �޷�����"..location.."ֱ�ӷ���\r\n")
      self:giveup()
      return
   end
    wait.make(function()
	--��Զ������Ķ�������˵���������ɵ������������������������µ���ͽ����Ϊ�ó�һ��ָ�Ĺ���
	--��Զ������Ķ�������˵������ͷ����׷�鵽���������䵱������Ϊ�ó����鵶���Ĺ���
	  local l,w=wait.regexp("^(> |)����������Ķ�������˵���������ɵ�������������������(.*)��.*����Ϊ�ó�(.*)�Ĺ���|^(> |)����������Ķ�������˵������ͷ����׷�鵽��������(.*)������Ϊ�ó�(.*)�Ĺ���",5)
	  if l==nil then
	     self:ask_job()
		 return
	  end
	  if string.find(l,"����������Ķ�������˵��") then
	     self:npc_strong()
		 self.menpai=w[2]
		 self.skills=w[3]
		 if self.menpai==nil or self.menpai=="" then
		    self.menpai=w[5]
			self.skills=w[6]
		 end
		 if location=="��ԭ���������ھ�" then
		    location="�����ھ�"
		 end
		 if location=="��ԭ���ݳ�����" then
		    localtion="��ʦ���������"
		 end
		 self.location=location
		 self.depth=depth
		 print("����:",self.menpai," ����:",self.skills)
		 --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �ص�:"..location.." ��Բ:"..depth.."\r\n")
		 --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ����:"..self.menpai.." ����:"..self.skills.."\r\n")
		 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:"..location.." "..self.menpai.." "..self.skills, "white", "black") -- yellow on white
         self:sure_enemy_skill()  --����npc ���ܲ�ͬʹ�ò�ͬ��Ӧpfm
	     return
	  end


	end)
end

function xxpantu:sure_enemy_skill() --�ص�����
end

function xxpantu:fail(id) --�ص�����

end


--[[��Զ������Ķ�������˵������˵�������˹�ƽ������
     :   :   .   .............:.         :           `.. .......:.
`````:```:`````       : .......          :          :  `        :
     `   `  .     :```: :..:..:   .......:.....:.   :           :
  :````:````:`    :    .:..:..:.        .`.         :           :
  :    :    :     `:``: .......         : `.        :           :
  :````:````:     `:` : :..:..:        :   `.       :           :
  :    :    :    ..`` : :..:..:      .`      `...   :           :
  :`````````:       `.`.........   ``          `    :         `.`
��Χ��Բһ��֮�ڵ��ң�������ȥ����Ѳ��һȦ��
��Χ��Բ����֮�ڵ��ң�������ȥ����Ѳ��һȦ��
]]
function xxpantu:bigword()
    new_bigword()
	world.AddTriggerEx ("bigword1", "^(.*)$", "get_bigword(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1001)
	world.SetTriggerOption ("bigword1", "group", "bigword")

	wait.make(function()
	   local l,w=wait.regexp("^��Χ��Բ(.*)��֮�ڵ��ң�������ȥ����Ѳ��һȦ��$|^���ң�������ȥ����Ѳ��һȦ��$",10)
	   if string.find(l,"������ȥ����Ѳ��һȦ") then
	      world.EnableTriggerGroup("bigword",false)
		  world.DeleteTriggerGroup("bigword")
		  print("��Բ:",w[1])
		  local deep=w[1]
		  if deep==nil or deep=="" then
		     deep="��"
		  end
		  self:deal_bigword(deep)
		  return
	   end

	   wait.time(10)
	end)
end

function xxpantu:deal_bigword(deep)
  local place=deal_bigword()
  self.place=place
  print("����:",self.robber_name," �ص�:",place," ��Χ:",deep)
  local depth=ChineseNum(deep)+1
  self:gongfu(self.robber_name,place,depth)
end

function xxpantu:test(w1,w2,w3)
 --print( �ص�:",w[1]," ��Χ:",w[2],"����:",w[3],")
--�ɶ��ǹص��� ��Բ:6
			 local place=w1
			 local deep=w2
			 local name=w3

			  --name=string.sub(name,9,-1)
			 print("name:",name)
             self.robber_name=name
			 self.place=place
			 --print()
			 --local depth=ChineseNum(deep)+1
			 self:robber(place,deep,npc)
end

function xxpantu:catch_place()
--[[

�������������˵�ͷ��
����������Ķ�������˵������˵������ͽ�����µ���ӯ����������ɽ��С·���ң�������ȥ����Ѳ��һȦ��
����������Ķ�������˵���������ɵ������������������Դ����µĸ��֣���Ϊ�ó����ϴ����ƵĹ���
������˵���������ȥ��أ�һ��С�İ�����
]]

   wait.make(function()
        local l,w=wait.regexp("^(> |)����������Ķ�������˵������˵������ͽ.*��(.*)����(.*)��Χ��Բ(.*)��֮�ڵ��ң�������ȥ����Ѳ��һȦ��$|^(> |)����������Ķ�������˵������˵������ͽ.*��(.*)����(.*)���ң�������ȥ����Ѳ��һȦ��$|^(> |)������˵�������������(.*)���񣬻�����(ȥ|)��Ϣһ��ɡ���$|^(> |)������˵������������ʱû���ʺ���Ĺ�������$|^(> |)��Զ������Ķ�������˵������˵(.*)����$|^(> |)������˵�������Ҳ��Ǹ��������������ڵ��ҡ���Ϳ�ȥ�ɣ���$|^(> |)������˵������.*�����������������޷�����������������񣡡�$",5)
		  if l==nil then
		     self:ask_job()
		     return
		  end
		  if string.find(l,"��Ϣһ���") then
		     print(w[9])
		     if w[9]=="������ͽ" then
		      self.fail(101)
			 else
			  self.fail(102)
			 end
		     return
		  end
		  if string.find(l,"������ʱû���ʺ���Ĺ���") then
		     --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ������ʱû���ʺϵĹ�����\r\n")
			  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:û�к��ʹ�����", "red", "black") -- yellow on white
		     self.fail(102)
		     return
		  end
		  if string.find(l,"������ȥ����Ѳ��һȦ") then
		     --search_start_time=os.time()
			 print("����:",w[2]," �ص�:",w[3]," ��Χ:",w[4])
			 local name=w[2]
			 local place=w[3]
			 local deep=w[4]
			 if name==nil or name=="" then
			   print("����:",w[6]," �ص�:",w[7])
			   name=w[6]
			   place=w[7]
			   deep="��"
			 end

			 print("name:",name)
             self.robber_name=name
			 self.place=place
			 local depth=ChineseNum(deep)+1
			 if depth<=2 then
			    depth=3
			 end
			 self:gongfu(name,place,depth)
		     return
		  end
		  if string.find(l,"����������Ķ�������˵��") then
		     print("13 ",w[13])
			 local name=Trim(w[13])
			  name=string.sub(name,9,-1)
			  print("name:",name)
			  self.robber_name=name
		     self:bigword()
		     return
		  end
		  if string.find(l,"�Ҳ��Ǹ��������������ڵ��ҡ���Ϳ�ȥ��") then
		     --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �޷�֪�����ڵص�,������\r\n")
			 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:�޷�֪�����ڵص�,����", "red", "black") -- yellow on white
		     self:giveup()
		     return
		  end
		  if string.find(l,"����������") then
		     self:look_zhengqidan()
		  end
		  wait.time(5)
    end)
end

function xxpantu:ask_job()
	local ts={
	           task_name="������ͽ",
	           task_stepname="ѯ�ʶ�����",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �䵱job��ʼ!\r\n")
     --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:������ʼ!", "yellow", "black") -- yellow on white
   combat_start_time=nil
   search_start_time=nil
   self.rooms={}
   self.exist_rooms={}
   --self.is_giveup=false
   local w
   w=walk.new()
   local al=alias.new()
   al.do_jobing=true
   w.user_alias=al
   w.walkover=function()
     world.Send("ask ding chunqiu about pantu")
	 world.Send("set ask")
	 world.Send("unset ask")
	 --[[
	 ��ڿ������߹�������ɫ��Щ�쳣����æ������ͷ��
���̲�ס��ݺ���(kick)����һ�һ�š�
��Զ������Ķ�������˵������˵���ϲݿ�ѦҶ�����ڴ�ѩɽѩ����Χ��Բ����֮�ڵ��ң�������ȥ����Ѳ��һȦ��
��Զ������Ķ�������˵���������ɵ��������������������һ����ĸ��֣���Ϊ�ó���ָ��ͨ�Ĺ���
��Զ������Ķ�������˵������˵���������������ڴ���ǲ�ݵ��ң�������ȥ����Ѳ��һȦ��
��Զ������Ķ�������˵���������ɵ�������������������ؤ��ĸ��֣���Ϊ�ó��򹷰����Ĺ���
��Զ��˵�����������������������񣬻�������Ϣһ��ɡ��� ��Զ��˵���������������ػ����񣬻�������Ϣһ��ɡ���



�������������˵�ͷ��
����������Ķ�������˵������˵������ͽ�����µ���ӯ����������ɽ��С·���ң�������ȥ����Ѳ��һȦ��
����������Ķ�������˵���������ɵ������������������Դ����µĸ��֣���Ϊ�ó����ϴ����ƵĹ���
������˵���������ȥ��أ�һ��С�İ�����
]]
     wait.make(function()
	     local l,w=wait.regexp("^(> |)���򶡴�������йء�pantu������Ϣ��$",5)
		 if l==nil then
		    self:ask_job()
		    return
		 end

		 if string.find(l,"���򶡴�������й�") then
		   self:catch_place()
		   --BigData:catchData(1957,"�����")
		   return
		 end
		 wait.time(5)

	 end)
   end
   w:go(1969)
end

function xxpantu:shield()
end

function xxpantu:job_failure() --�ص�����
end

function xxpantu:giveup()
  dangerous_man_list_add(self.robber_name)
  danerous_man_list_push()
   local pfm=world.GetVariable("pfm") or ""
    ---world.Send("alias pfm "..pfm)
  --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ����ʧ��,׼������!\r\n")
   --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:����ʧ��,׼������!", "red", "black") -- yellow on white
  --if combat_start_time~=nil then
     --sj.log_catch(WorldName().."_�䵱����:",400)
  --end
  world.EnableTrigger("robber_place",false)
  world.DeleteTrigger("robber_place")
  -- ����䵱job ʧ����
  self:job_failure()

  --if self.is_giveup==true then
  --   self:Status_Check()
  --   return
 --end
 local w
   w=walk.new()
   w.walkover=function()
       world.Send("ask ding chunqiu about ����")
       wait.make(function()
	   --��Զ��˵������Ҷ֪�����û��������������Ϲ����ʲôѽ����
	   --��Զ��˵������Ҷ֪�����û��������������Ϲ����ʲôѽ����
	      local l,w=wait.regexp("������˵������"..self.playname.."���������ȷʵ�Ƚ�����ɣ��´θ���򵥵ģ������°ɣ���$|^(> |)������˵������"..self.playname.."������û��������������Ϲ����ʲôѽ����$|^(> |)������˵������"..self.playname.."����̫����ʧ���ˣ���Ȼ��ô���ɲ��ã������°ɣ���$",5)
		  if l==nil then
		     self:giveup()
		     return
		  end
		  if string.find(l,"Ϲ����ʲôѽ") or string.find(l,"��Ȼ��ô���ɲ��ã������°�") or string.find(l,"�������ȷʵ�Ƚ������") then
			--BigData:catchData(1957,"�����")
			local f=function()
			   --self:Status_Check()
			   self:jobDone()
			end
			Weapon_Check(f)
			return
		  end
	   end)
   end
   w:go(1969)
end

function xxpantu:jobDone()--�ص�
end
--[[
������һ�ٶ�ʮ�ߵ㾭�飬��ʮ�ŵ�Ǳ�ܣ�����������������ˣ�
��Զ��Ϊ����Ǯׯ����������ƽ�
]]
function xxpantu:is_reward()

       wait.make(function()
	      local l,w=wait.regexp("(> |)������(.*)�㾭�飬(.*)��Ǳ�ܣ�����������������ˣ�$",30)
		  if l==nil then
		     self:is_reward()
		     return
		  end
		  if string.find(l,"������") then
			 --world.AppendToNotepad (WorldName(),os.date()..": �䵱���� ��þ���:".. ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]).."\r\n")
			 --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �䵱job ����:".. ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]).."\r\n")
			 --local exps=world.GetVariable("get_exp")
			 exps=tonumber(exps)+ChineseNum(w[2])
			 --world.SetVariable("get_exp",exps)
			 --world.AppendToNotepad (WorldName(),os.date()..": Ŀǰ����ܾ���ֵ"..exps.."\r\n")
		     self.reward_ok=true
			 return
		  end
		  wait.time(30)
	   end)
end

function xxpantu:reward()
	local ts={
		task_name="������ͽ",
		task_stepname="����",
		task_step=5,
		task_maxsteps=5,
		task_location=self.location.." ��Բ:"..self.depth,
		task_description=self.robber_name.." ����:"..self.menpai.." ����:"..self.skills,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	self.sections={}
	xxpantu.co2=nil
	world.EnableTrigger("robber_place",false)
	world.DeleteTrigger("robber_place")


   local w
   w=walk.new()
   self:is_reward()
   w.walkover=function()
		world.Send("ask ding chunqiu about ���")
       if self.reward_ok==true then
			shutdown()
	        local b
			b=busy.new()
			b.Next=function()
		       self:jobDone()
			end
			b:check()
	      return
	   end
       wait.make(function()

	      local l,w=wait.regexp("(> |)������(.*)�㾭�飬(.*)��Ǳ�ܣ�����������������ˣ�$|^(> |)���򶡴�������йء���ɡ�����Ϣ��$",5)
		  if l==nil then
		    print("��ʱ")
		    shutdown()
		    self:reward()
		     return
		  end
		 if string.find(l,"������") then
			 --world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": �䵱job ����:".. ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]).."\r\n")
			 --local exps=world.GetVariable("get_exp")
			 --exps=tonumber(exps)+ChineseNum(w[2])
			 --world.SetVariable("get_exp",exps)
			 --world.AppendToNotepad (WorldName(),os.date().."Ŀǰ����ܾ���ֵ"..exps.."\r\n")
		     shutdown()
	         local b
			 b=busy.new()
			 b.Next=function()
		       self:jobDone()
			 end
			 b:check()
			 return
		  end
		  if string.find(l,"���򶡴�������й�") then
		     shutdown()
			 --BigData:catchData(1957,"�����")

		     local b
			 b=busy.new()
			 b.Next=function()
			    --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�䵱����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- yellow on white
		       self:jobDone()
			 end
			 b:check()
		     return
		  end
		  wait.time(5)
	   end)
   end
   w:go(1969)
end

function xxpantu:liaoshang_fail()
end


function xxpantu:full()

	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 local qi_percent=world.GetVariable("qi_percent") or 100
	 qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100
	 local vip=world.GetVariable("vip") or "��ͨ���"
   local h
	h=hp.new()
	h.checkover=function()
	   -- print(h.food,h.drink)
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
		elseif h.jingxue_percent<=80 or (h.qi_percent<=liao_percent and heal_ok==false) then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
			end
			--[[rc.liaoshang_fail=function()
			    self:liaoshang_fail()
			    local f=function()
					rc:heal(true,true)
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
			end]]
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
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<qi_percent and heal_ok==false  then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			   heal_ok=true
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
   				     self:Status_Check()
				   end  --���
				   f_wait(f,0.5)
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(1958)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
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

function xxpantu:Status_Check()
	local ts={
	           task_name="������ͽ",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	self.sections={}
	st:init(nil,nil,ts)
	st:task_draw_win()
    self.win=false
	self.reward_ok=false
	--self.is_giveup=false
	self.kick_count=0
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
			          self:Status_Check()
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
			        rc:heal(true,true)
				    return
				 end
				 if Trim(i[1])=="����׷ɱ��ͽ" then
				    --print("?")
				    self.fail(102)
				    return
				 end
			   end
		     end
            self:full()
	end
	cd:start()
end


function xxpantu:beast_kill_check()
  --��������Ĺ����ɱ���㣡
  --print("auto kill ���")
  wait.make(function()
    local l,w=wait.regexp("^(> |)������(.*)��ɱ���㣡$",5)
	if l==nil then
	  self:beast_kill_check()
	  return
	end
	if string.find(l,"��ɱ����") then--�ų�ǿ��
	  if string.find(self.robber_name,w[2])==nil then
	    self.beast_kill=true
	    self.beast=w[2]
	  end
	  self:beast_kill_check()
	  return
    end
	wait.time(5)
  end)
end
--(��|�ϻ�|����|��|����|Ұ��|����|����|��|�۳彫��|ƽ�ܽ���|���ｫ��|��������|����|ֵ�ڱ�)
--  ����(Du mang)
function xxpantu:check_beast_kill_again(id)
   wait.make(function()

     world.Send("look")
	 world.Send("set action 1")
	 world.Send("unset wimpy")
	 	 --�ϻ� �� �� �� Ұ�� ����
	 local regexp
	 if self.beast~="" and self.beast~=nil then
	    regexp=".*"..self.beast.."\\(.*\\) <ս����>$|.*(����|����|�ϻ�|��|����|Ұ��|����|Ұ��|����|����|ֵ�ڱ�|����|����)\\(.*\\).*|^(> |)�趨����������action \\= 1$"
	else
 	    regexp=".*(����|����|�ϻ�|��|����|Ұ��|����|����|ֵ�ڱ�|Ұ��|����|����|����)\\(.*\\).*|^(> |)�趨����������action \\= 1$"
	end
	 local l,w=wait.regexp(regexp,10)
	 if l==nil then
	    self:check_beast_kill_again(id)
	    return
	 end
	 	 if string.find(l,"ֵ�ڱ�") then
		world.Send("kill zhiqin bing")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"����") then
	    world.Send("kill ma zei")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"ս����") then
	     local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"��") then
	    world.Send("kill bear")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"����") then
	    world.Send("kill bao")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"����") then
	      world.Send("kill bangzhong")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	   return
	 end
	if string.find(l,"��") then
	    world.Send("kill snake")
		world.Send("kill she")
		world.Send("kill dushe")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"�ϻ�") then
	    world.Send("kill lao hu")
		 local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"Ұ��") then
	    world.Send("kill ye zhu")
		 local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"����") or string.find(l,"����") then
		 world.Send("kill mang")
		 world.Send("kill du mang")
		 local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"��") then
	     world.Send("kill wolf")
		 world.Send("kill dog")
		 world.Send("kill lang")
		 local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"ս����") then
	     local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"�趨����������action") then
	   self.beast=""
	   self.beast_kill=false
	   self:kill_robber(id)
	   return
	 end
     wait.time(10)
   end)
end
