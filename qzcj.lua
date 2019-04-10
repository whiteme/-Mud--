require "wait"
require "map"
require "cond"
require "status_win"
chujian={
  new=function()
     local cj={}
	 setmetatable(cj,chujian)
	 return cj
  end,
  co=nil,
  name="",
  id="",
  place="",
  neili_upper=1.9,
  --blacklist="������|�ɹ��|������|�嶾��Ů����|�˵�����|���ҹ���|éʮ��|������|���ϴ��|������|�͵�ŵ|�ܹ�ͩ|���Ӣ|ժ����|ʨ����|��Ȼ��|�ɹ���ʿ|ʷ��ͷ|������|����|���ĵ�|�����|������|�����|�����|���ƹ�|�ź���|������|�ֲ�|ѦĽ��",
}
chujian.__index=chujian
--[[
�����ⳤ�ϴ����йء�job������Ϣ��
�ⳤ��˵�������ðɣ���������������һֱ����ؤ�����ԣ���ǰȥ�跨�����˳�������
�ⳤ��˵���������������ڲ��ݳǴ����һ�����������î�����¶�ʮ������ʱ����֮ǰ�ϻ�������


����ⳤ��һ�Ž���������׼���
>
yun refresh
( ����һ��������û����ɣ�����ʩ���ڹ���)
> �ⳤ�϶��������������ִ�Ĵָ�������ġ�
�ⳤ��˵��������Ϊؤ�������˹��ͣ����Ǿ����������ġ���
�ⳤ�Ϸ��������������ָ������һЩ�书Ҫ��...
��������л�Ȼ���ʣ���������ʮ���Ǳ�ܺ�һ��һʮ���㾭�飡

]]

local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    if v==r then
		   return true
		end
	end
	return false
end

function chujian:shield()
end

function chujian:catch_place()
  wait.make(function()
    local l,w=wait.regexp("^(> |)�𴦻�����˵�����������зɸ봫���֪�������ϸӦ����(.*)һ���������ȥ������ȥ��$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"�����ϸӦ����") then
	  self.place=w[2]
	  --world.AppendToNotepad (WorldName(),os.date().." ���ڵ�:".. w[2].."\r\n")
	    --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ؤ������:�����ص�"..self.place, "red", "black") -- black on white
	  self:find()
	  return
	end

  end)
end

function chujian:catch_badman()
  local playername=world.GetVariable("playername") or ""
  wait.make(function()
    local l,w=wait.regexp("^(> |)�𴦻�����˵�������������������ǽ�����պ��ҵ�����������װ������Ҵ��Σ���$|^(> |)�ⳤ��˵����������������û�и����������ȥ�����ط������ɣ���$|^(> |)�ⳤ��˵�����������ҿ�û�и�������񣬵Ȼ������ɣ���$|�ⳤ��˵�����������ϸ�����ȥ������ȥ�������ҽ��İɣ��Ȼ���������",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"һֱ����ؤ�����ԣ���ǰȥ�跨�����˳���") then
	  self:catch_place()
	  --world.AppendToNotepad (WorldName(),os.date()..": ��������:".. w[2].."\r\n")
      --self.name=w[2]
	  --print(self.name)
	  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ؤ������:ɱ��"..self.name, "red", "black") -- black on white
	  return
	end
	if string.find(l,"����������û�и����������ȥ�����ط�������") then
	  self.fail(101)
	  return
	end
	if string.find(l,"�����ҿ�û�и�������񣬵Ȼ�������") then
	  self.fail(102)
	  return
	end
	if string.find(l,"�����ϸ�����ȥ������ȥ�������ҽ��İɣ��Ȼ�����") then
	  self:giveup()
	  return
	end
	wait.time(5)
  end)
end

function chujian:ask_job()
  local w=walk.new()
  local al=alias.new()
  al.do_jobing=true
  w.user_alias=al
  w.walkover=function()
   wait.make(function()
	--CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ؤ������:������ʼ!", "yellow", "black") -- black on white
    world.Send("ask qiu about ȫ�����")
    local l,w=wait.regexp("^(> |)�����𴦻������йء�ȫ����须����Ϣ��$",5)
	if l==nil then
	  self:ask_job()
	  return
	end
	if string.find(l,"�����𴦻������й�") then
	  self:catch_badman()
	  --BigData:catchData(1345,"ؤ��")
	  return
	end
	wait.time(5)
   end)
  end
  w:go(4152)
end
--[[
function chujian:exps()
  wait.make(function()
    local l,w=wait.regexp("^(> |)��������л�Ȼ���ʣ�������(.*)��Ǳ�ܺ�(.*)�㾭�飡",5)
    if l==nil then
	  self:exps()
	  return
	end
	if string.find(l,"��������л�Ȼ����") then
       --world.AppendToNotepad (WorldName(),os.date()..": ؤ��job ����:".. ChineseNum(w[3]).." Ǳ��:"..ChineseNum(w[2]).."\r\n")
	   local exps=world.GetVariable("get_exp")
	   exps=tonumber(exps)+ChineseNum(w[3])
	   world.SetVariable("get_exp",exps)
	   world.AppendToNotepad (WorldName(),os.date().."Ŀǰ����ܾ���ֵ"..exps.."\r\n")
	   return
	end
	wait.time(5)
  end)

end]]

function chujian:reward()
	local ts={
	           task_name="��������",
	           task_stepname="����",
	           task_step=4,
	           task_maxsteps=4,
	           task_location=self.place,
	           task_description=self.name,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	chujian.co=nil
  local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("give ling to qiu chuji")
    local playername=world.GetVariable("playername") or ""
    local l,w=wait.regexp("^(> |)�𴦻�˵�������ܺã�"..playername.."����Ȼ��������ϸ��ɱ�ˣ�Ϊ��Ϊ����֮���ߣ���$|^(> |)������û������������$|^(> |)�ⳤ��˵�������Һ���û�и��������񰡣���$",5)
	if l==nil then
	  self:reward()
	  return
	end
	if string.find(l,"��Ȼ��������ϸ��ɱ") then
	  --self:exps()
	  --[[local rc=reward.new()
	  rc.finish=function()
	       --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ؤ������:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- black on white
		  local b=busy.new()
	       b.interval=0.3
	       b.Next=function()
	         self:jobDone()
	       end
	       b:check()
	  end
	  rc:get_reward()]]

	  --BigData:catchData(1345,"ؤ��")
      local b=busy.new()
	       b.interval=0.3
	       b.Next=function()
	         self:jobDone()
	       end
	       b:check()
	  return
	end
	if string.find(l,"��������") then
	   local b=busy.new()
	   b.check=function()
	     world.Send("drop shouji")
	     self:giveup()
	   end
	   b:check()
	   return
	end
	if string.find(l,"������û����������")  then
	   self:giveup()
	   return
	end
	wait.time(5)
   end)
  end
  w:go(4152)
end

function chujian:combat()

end
--[[
function chujian:qie_corpse(index)
local b=busy.new()
b.interval=0.5
b.Next=function()
  wait.make(function()
    --world.Send("get all from corpse")
   world.Send("wield jian")
   if index==nil then
       world.Send("get gold from corpse")
	   world.Send("get silver from corpse")
       world.Send("qie corpse")
	else
	   world.Send("get gold from corpse "..index)
	   world.Send("get silver from corpse "..index)
	   world.Send("qie corpse ".. index)
   end
   local l,w=wait.regexp("^(> |)ֻ�����ǡ���һ�����㽫"..self.name.."���׼�ն���������������С�$|^(> |)���б���ɱ���˸��ﰡ��$|^(> |)�Ǿ�ʬ���Ѿ�û���׼��ˡ�$|^(> |)�Ҳ������������$|^(> |)�Ǿ�ʬ���Ѿ������ˡ�$|(> |)��������������޷����У������������ʬ���ͷ����$|^(> |)����ü����������߲���������ʬ���ͷ����$",5)
   if l==nil then
      self:qie_corpse(index)
	  return
   end
   if string.find(l,"���б���ɱ���˸��ﰡ") or string.find(l,"�Ǿ�ʬ���Ѿ�û���׼���") or string.find(l,"�Ǿ�ʬ���Ѿ�������") then
      if index==nil then
	     index=2
	  else
	     index=index+1
	  end
      self:qie_corpse(index)
      return
   end
   if string.find(l,"�Ҳ����������") then
      self:giveup()
      return
   end
   if string.find(l,"�׼�ն����������������") then
      local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	    local sp=special_item.new()
   	     sp.cooldown=function()
		     if self.name=='���ĵ�' then
			     self:wait_wanted()
		     else
                 self:reward()
		     end
         end
        sp:unwield_all()
	  end
	  b:check()
      return
   end
    if string.find(l,"��������������޷����У������������ʬ���ͷ��") or string.find(l,"����ü����������߲���������ʬ���ͷ��") then
      local sp=special_item.new()
   	  sp.cooldown=function()
	    local f=function()
          self:qie_corpse(index)
		end
		local error_deal=function()
		     self:get_weapon()
		end
		local do_again=function()
		  world.Send("i")
	  	  self:auto_wield_weapon(f,error_deal)
		  world.Send("set look 1")
		end
		f_wait(do_again,0.5)
      end
      sp:unwield_all()
      return
   end
   wait.time(5)
  end)
 end
 b:check()
end
function chujian:get_weapon()
   local b=busy.new()
   b.interval=0.5
   b.Next=function()
      local w=walk.new()
	  w.walkover=function()
	     world.Send("get changjian")
		 world.Send("get dao")
		 --
		 print("û�к���������ͷ,����ʧ��!!")
		 self:giveup()

	  end
	  w:go(roomno)
   end
   b:check()
end

function chujian:auto_wield_weapon(f,error_deal)
--�㽫�����������������С��㡸ৡ���һ�����һ�������������С�

   wait.make(function()
	 local l,w=wait.regexp("(.*)\\((.*)\\)$|^(> |)�趨����������look \\= 1$",5)
    if l==nil then
	   self:auto_wield_weapon(f,error_deal)
	   return
	end
	if string.find(l,")") then
	   --print(w[1],w[2])
	   local item_name=w[1]
	   local item_id=string.lower(w[2])
      if (string.find(item_id,"sword") or string.find(item_id,"jian") or string.find(item_id,"lanyu duzhen")) and (string.find(item_name,"��") or string.find(item_name,"������")) then
         world.Send("wield "..item_id)
		  self.weapon_exist=true
      elseif (string.find(item_id,"axe") or string.find(item_id,"fu")) and string.find(item_name,"��") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"blade") or string.find(item_id,"dao") or string.find(item_id,"xue sui")) and string.find(item_name,"��") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
      elseif (string.find(item_id,"dagger") or string.find(item_id,"bishou")) and string.find(item_name,"ذ") then
         world.Send("wield "..item_id)
		 self.weapon_exist=true
	  end
	  self:auto_wield_weapon(f,error_deal)
	  return
	end
    if string.find(l,"�趨����������look") then
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
]]
function chujian:wait_wanted()
  local w=walk.new()
  w.walkover=function()
      world.Send("enter")
      wait.make(function()
      local l,w=wait.regexp("^(> |)������ǰ����һ�죺����书�����ˣ������ѧ����ʲô�ˡ�$",5)
      if l==nil then
	     self:wait_wanted()
	     return
	  end
	  if string.find(l,"�����ѧ����ʲô��") then
         self:reward()
	     return
	  end
	  wait.time(5)
      end)
   end
   w:go(155)
end

function chujian:run(dx,i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)������ʧ�ܡ�$|^(> |)�����Ϊ������$|^(> |)�趨����������action \\= \\\"����\\\"$",1.5)
	   if l==nil then
	      self:run(dx,i)
	      return
	   end
	   if string.find(l,"�����Ϊ����") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"��Ķ�����û����ɣ������ƶ�") or string.find(l,"������ʧ��") then
		  self:run(dx,i)
	      return
	   end
	   if string.find(l,"�趨����������action") then
		 world.DoAfter(1.5,"set action ����")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"����\\\"$|^(> |)�趨����������action \\= \\\"����\\\"$",5)
			if l==nil then
			   self:run(dx,i)
			  return
			end
			if string.find(l,"����") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"����") then
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

function chujian:flee(i)
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
	 self:run(run_dx,i)
   end
   _R:CatchStart()
end
--���˿���ȥʦ��������̣��ó�ʹ���������ν��˵У�
--[[
function chujian:kill(npc,id)
  	local ts={
	           task_name="��������",
	           task_stepname="ս��",
	           task_step=3,
	           task_maxsteps=4,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  self:combat()
  self:wait_badman_die()

  wait.make(function()
    --print("kill"..id)

	world.Send("follow "..id)
    world.Send("kill "..id)
	local l,w=wait.regexp("^(> |)�����򲻻����أ���ôɱ��$",5)
	if l==nil then

	  return
	end
	if string.find(l,"�����򲻻�����") then
	  world.Send("yield no")
	  self:kill(npc,id)
	  return
	end
    wait.time(5)
  end)
end

function chujian:is_ok(name)
   --print(name)
   local lists=self.blacklist
   --print(lists)
   if lists==nil then
       --print("ok")
      lists="�ɹ��|������|�嶾��Ů����|éʮ��|������|������|�͵�ŵ|�ܹ�ͩ|���Ӣ|ժ����|ʨ����|��Ȼ��|�ɹ���ʿ|ʷ��ͷ|������|����|���ĵ�|�����|������|�����|�����|���ƹ�|�ź���|������"
   end
   if lists~="" then

    local items=Split(lists,"|")
	 for _,i in ipairs(items) do
	     if i==name then
		    return false
		 end
	 end
   end
   return true
end

function chujian:test(place,name)

  local ts={
	           task_name="ؤ������",
	           task_stepname="Ѱ��NPC",
	           task_step=2,
	           task_maxsteps=4,
	           task_location=place,
	           task_description=name,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	--
	local name=Trim(name)
	local result=self:is_ok(name)
	 if result==false then
	   self:giveup()
	   print("�������ò��ܹ���������")
	   return
	 end
	if zone_entry(place)==true then
      self:giveup()
      return
    end

   local n,rooms=Where(place)
   if name=="�������" then
      n=1
	  rooms={1445}
   end
	if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	   chujian.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		      self:giveup()
		  end

		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
		    self:giveup()
		  end
		  al.do_jobing=true
		  w.user_alias=al
		  w.walkover=function()
		    print("Ѱ��"..name)
		    self:checkNPC(name,r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("û���ҵ�npc!!")
		self:giveup()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��,����")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:giveup()
	  end
	  b:check()
	end
end]]

function chujian:find()

	local ts={
	           task_name="��������",
	           task_stepname="Ѱ��NPC",
	           task_step=2,
	           task_maxsteps=4,
	           task_location=self.place,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	--
	--local name=Trim(self.name)
	--local result=self:is_ok(name)
	 --if result==false then
	  -- self:giveup()
	  -- print("�������ò��ܹ���������")
	  -- return
	 --end
	if zone_entry(self.place)==true then
      self:giveup()
      return
    end

   local n,rooms=Where(self.place)

	if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	   chujian.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
		    self:giveup()
		  end
		  al.do_jobing=true
		  w.user_alias=al
		  w.walkover=function()
		    --print("Ѱ��"..self.name)
		    --self:checkNPC("",r)
			self:checkSpy(r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
		print("û���ҵ�npc!!")
		self:giveup()
	   end)
	   self:findSpy()
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��,����")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:giveup()
	  end
	  b:check()
	end
end

function chujian:jobDone()
end

function chujian:giveup()
 chujian.co=nil
 local w=walk.new()
  w.walkover=function()
   wait.make(function()
    world.Send("ask qiu about ����")
    local l,w=wait.regexp("^(> |)�����𴦻������йء�����������Ϣ��$",5)
	if l==nil then
	  self:giveup()
	  return
	end
	if string.find(l,"�����𴦻������й�") then
	   --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ؤ������:����", "pink", "black") -- black on white
	    --BigData:catchData(1345,"ؤ��")
	  local b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	     self:Status_Check()
	  end
	  b:check()
	  return
	end
	--wait.time(5)
   end)
  end
  w:go(4152)
end

function chujian:NextPoint()
   print("���ָ̻�")
   coroutine.resume(chujian.co)
end

function chujian:checkPlace(r,here)
      if is_contain(r,here) then
  	     print("�ȴ�0.5s,��һ������")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
		 end
		 f_wait(f,0.5)
	   else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
	     local w=walk.new()
		  local al
		  al=alias.new()
		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
		     self:giveup()
		  end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    --self:checkNPC("",r)
			self:checkSpy(r)
		  end
		  w:go(r)
	   end
end

function chujian:badman_die()
end

function chujian:wait_badman_die()
wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",5)
	 if l==nil then
	    self:wait_badman_die()
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
	    --print(self.name,w[2])
	    if string.find(self.name,w[2]) then
		   self:badman_die()
		else
           self:wait_badman_die()
		end
	    return
	 end
	 wait.time(5)
  end)
end

function chujian:look_id(npc,id)
  world.Send("look "..id)
  world.Send("set action ����")
  wait.make(function()
     local l,w=wait.regexp("^(> |)���˿���ȥʦ��(.*)���ó�ʹ��(.*)�˵У�$|^(> |)��Ҫ��ʲô��$|^(> |)�趨����������action \\= \\\"����\\\"$",5)
	 if l==nil then
       self:look_id(npc,id)
	   return
	 end
	 if string.find(l,"��Ҫ��ʲô") then
	    self:giveup()
	    return
	 end
	 if string.find(l,"�趨����������action") then
	    self:check_auto_kill_npc(npc,id)
	    return
	 end
	 if string.find(l,"���˿���ȥʦ��") then
		local party=w[2]
		local skill=w[3]
		CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."ؤ������:���� ".. party.." skill "..skill, "white", "black")
		local lists=self.blacklist

        local items=Split(lists,"|")
	    for _,b in ipairs(items) do
	      if b==party or b==skill then
			 self:giveup()
		     return
		   end
	    end
		self:check_auto_kill_npc(npc,id)
	    --self:kill(npc,id)
	    return
	 end

  end)
end

function chujian:check_auto_kill_npc(npc,id)
   wait.make(function()
     world.Send("look")
	 world.Send("set look 1")
	 world.Send("unset wimpy")
	 --�ϻ� �� �� �� Ұ�� ����
	 local regexp
	 --if self.auto_kill_npc~="" and self.auto_kill_npc~=nil then
	    regexp=".*(����|����|�ϻ�|��|����|Ұ��|����|Ұ��|����|����|ֵ�ڱ�|���ǹ�|����|����|����|����)\\(.*\\).*|^(> |)�趨����������look \\= 1$"
	--else
 	--    regexp=".*(����|����|�ϻ�|��|����|Ұ��|Ұ��|����|����|����|ֵ�ڱ�|���ǹ�|����|����|����|����)\\(.*\\).*|^(> |)�趨����������look \\= 1$"
	--end
	 local l,w=wait.regexp(regexp,10)
	 if l==nil then
	    self:check_auto_kill_npc(npc,id)
	    return
	 end

	 if string.find(l,"ֵ�ڱ�") then
		world.Send("kill zhiqin bing")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"����") then
	     world.Send("kill bangzhong")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
		 return
	 end

	 if string.find(l,"����") then
	    world.Send("kill ma zei")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"��") then
	    world.Send("kill bear")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"����") then
	    world.Send("kill bao")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	    return
	 end
	if string.find(l,"��") then
	    world.Send("kill snake")
		world.Send("kill she")
		world.Send("kill dushe")
		--world.Send("kill she")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"����") then
	    world.Send("kill jiao zhong")
		--world.Send("kill she")
		local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"�ϻ�") then
	    world.Send("kill lao hu")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"Ұ��") then
	    world.Send("kill ye zhu")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end

	 if string.find(l,"����") or string.find(l,"����")  then
		 world.Send("kill mang")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"����") then
	    world.Send("kill e yu")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"��") then
		 world.Send("kill wolf")
		 world.Send("kill dog")
		 world.Send("kill lang")
		 local f=function() self:check_auto_kill_npc(npc,id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"�趨����������look") then
	   self:kill(npc,id)
	   return
	 end

   end)
end
-->

function chujian:checkSpy(roomno)
    local NextPoint=function()
      local f=function(r)
		     self:checkPlace(roomno,r)
	  end
	  WhereAmI(f,10000) --�ų����ڱ仯
	end
	f_wait(NextPoint,1)
end

function chujian:findSpy()
   wait.make(function()

     local l,w=wait.regexp("^(> |)(.*)�੹�Ц���ϣ���Ȼ�����ˣ��Ǿ��������ɣ�$",5)
	 if l==nil then
	    self:findSpy()
	    return
	 end
	 if string.find(l,"��Ȼ������") then
	     shutdown()
		local name=w[2]
		self.name=name
		self:combat()
	    return
	 end
   end)
end

--[[
function chujian:checkNPC(npc,roomno)
    wait.make(function()
      world.Execute("look;set action 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������action \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"�趨����������action") then
	      --û���ҵ�
		  --
		  local f=function(r)
		     self:checkPlace(npc,roomno,r)
		  end
		  WhereAmI(f,10000) --�ų����ڱ仯

		  return
	  end
	  if string.find(l,npc) then
	     --�ҵ�
		  local id=string.lower(Trim(w[2]))
		  self.id=id
		  --print(id)
		  self:look_id(npc,id)
		  --self:kill(npc,id)
		  return
	  end
	  wait.time(6)
   end)
end]]

function chujian:eat()
    --[[local w=walk.new()
	w.walkover=function()
	      world.Execute("buy baozi")
		  world.Execute("eat baozi;eat baozi;eat baozi;drop baozi")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
	end
	w:go(976) --����¥ 976]]
	  print("eat")
		        w=walk.new()
		        w.walkover=function()
			      local b
			       b=busy.new()
			       b.interval=0.3
			       b.Next=function()
			          world.Execute("ask xiao tong about ʳ��")
				      local f
				      f=function()
				        local b1=busy.new()
				         b1.Next=function()
				           world.Execute("get fan;eat fan;eat fan;eat fan;drop fan")
					       self:full()
				         end
				         b1:check()
				       end
				      f_wait(f,1.5)
				   end
			       b:check()
		       end
			   w:go(133) --299 ask xiao tong about ʳ�� ask xiao tong about ��
end

function chujian:drink()
     print("drink")
			    local w
		         w=walk.new()
		         w.walkover=function()
			      local b
			      b=busy.new()
			      b.interval=0.3
			      b.Next=function()
			         world.Send("ask xiao tong about ��")
				     local f
				     f=function()
				      local b1=busy.new()
				       b1.Next=function()
				          world.Execute("get cha;drink cha;drink cha;drink cha;drop cha")
					      self:full()
				       end
				       b1:check()
				     end
				     f_wait(f,1.5)
			       end
			       b:check()
		          end
				 w:go(133) --299 ask xiao tong about ʳ�� ask xiao tong about ��
end

function chujian:full()
   local vip=world.GetVariable("vip") or "��ͨ���"
   local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="����������" then
		     if h.food<50 then
			    self:eat()
			 elseif h.drink<50 then
			    self:drink()
			 end
		elseif h.qi_percent<=30 or h.jingxue_percent<=80 then
		    print("����")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal(true,false)
		elseif h.neili<h.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                self:Status_Check()
            end
			r:wash()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
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
			   --�������
				  --local _R
                  --_R=Room.new()
                  --_R.CatchEnd=function()
                    --local count,roomno=Locate(_R)
					--local target_roomno=nearest_room(roomno)
                    local w
		            w=walk.new()
		            w.walkover=function()
			          self:full()
		            end
		            w:go(1345)
                  --end
                 --_R:CatchStart()
			   end
			end
			x.success=function(h)
               world.Send("yun recover")
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
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
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end

function chujian:Status_Check()
	local ts={
	           task_name="��������",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=4,
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
			   end
		     end
            self:full()
	end
	cd:start()
end
