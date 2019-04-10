
local heal_ok=false
huashan={
  new=function()
      heal_ok=false
    local hs={}
	 setmetatable(hs,huashan)
	 return hs
  end,
  co=nil,
  co2=nil,
  robbername="",
  robberid="",
  hs2=true,
  appear=false,
  run_hs2=false,
  dayun=false,
  weapon="",
  neili_upper=1.9,
  look_NPC=false,
  look_NPC_place="",
  rooms={},
  round=1,
  check_place_count=0,
  version=1.8,
}
huashan.__index=huashan

local combat_starttime=nil
function huashan:fail(id)
end

function huashan:catch_place()
   wait.make(function()
	   local l,w=wait.regexp("����Ⱥ������һ�����ơ�|^(> |)����Ⱥ˵����������û����˵�ж���Ϊ�����գ����Լ�ȥ��ϰ�书ȥ�ɣ���$|^(> |)����Ⱥ˵��������������æ�������������أ���$|^(> |)����Ⱥ˵�������㲻�ܹ�˵ѽ������������ɼ����ҿ�������$|^(> |)����Ⱥ˵����������¶�׹�, ����ȥ�Ͷ�����.*$|^(> |)����Ⱥ˵�����㻹û���ʦ���������ء�$|^(> |)����Ⱥ˵�������㻹����ȥ˼�������˼��ȥ�ɡ���$",5)
		if l==nil then
		   self:catch_place()
		   return
		end
		if string.find(l,"����Ⱥ������һ������") then
		    local b=busy.new()
			b.interval=0.5
			b.Next=function()
			   self:songlin()
			end
			b:check()
			return
		 end
		 if string.find(l,"���Լ�ȥ��ϰ�书ȥ��") then
		    self.fail(101)
		    return
		 end
		 if string.find(l,"��������æ��������������") then
		    self.fail(102)
		    return
		 end
		 if string.find(l,"����¶�׹�") then
		    self:look_zhengqidan()
		    return
		 end
		 if string.find(l,"�㻹û���ʦ����������") or string.find(l,"�㲻�ܹ�˵ѽ������������ɼ����ҿ���") then
		    local b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:giveup()
			end
			b:check()
		    return
		 end
		 if string.find(l,"�㻹����ȥ˼�������˼��ȥ��") then
		    print (utils.msgbox ("��ʼ��Ž���������", "Warning!", "ok", "!", 1)) --> ok
			world.Send("nick ��ʼ��Ž���������")
		    local q=quest.new()
			q:jiujian()
		   return
		 end
        wait.time(5)
   end)
end

function huashan:ask_job()
  	local ts={
	           task_name="��ɽ",
	           task_stepname="ѯ������Ⱥ",
	           task_step=2,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --world.AppendToNotepad (WorldName().."_��ɽ����:",os.date()..": ��ɽjob��ʼ\r\n")
    CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ɽ����:������ʼ!", "yellow", "black") -- black on white
   local w
   w=walk.new()
   local al=alias.new()
   al.do_jobing=true
   w.user_alias=al
   w.walkover=function()
     wait.make(function()
        world.Send("ask yue buqun about �Ͷ�����")

	     local l,w=wait.regexp("^(> |)��������Ⱥ�����йء��Ͷ����ơ�����Ϣ��$",5)--��������Ⱥ�����йء��Ͷ����ơ�����Ϣ��

		 if l==nil then
		    self:ask_job()
			return
		 end
		 if string.find(l,"��������Ⱥ�����й�") then
		    --print("ץȡ")
			--BigData:catchData(1532,"������")
		    self:catch_place()
		    return
		 end


		 wait.time(5)
     end)
   end
   w:go(1532)
end

function huashan:giveup()
   --world.AppendToNotepad (WorldName().."_��ɽ����:",os.date()..": ����ʧ��,׼������!\r\n")
   dangerous_man_list_add(self.robbername)
   danerous_man_list_push()
   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ɽ����:����!", "red", "black") -- black on white
   local w
   w=walk.new()
   w.walkover=function()
   wait.make(function()
     world.Send("ask yue buqun about ʧ��")
      wait.make(function()
	     local l,w=wait.regexp("��������Ⱥ�����йء�ʧ�ܡ�����Ϣ��",5)
		 if l==nil then
		    self:giveup()
			return
		 end
		 if string.find(l,"ʧ��") then
		    --BigData:catchData(1532,"������")
		    local b=busy.new()
			b.interval=0.5
			b.Next=function()
			   local f=function()
			      self:Status_Check()
			   end
			   Weapon_Check(f)
			end
			b:check()
			return
		 end
		 wait.time(5)
	  end)
   end)
   end
   w:go(1532)

end

function huashan:exps()
   wait.make(function()
      local l,w=wait.regexp("^(> |)������(.*)�㾭�飬(.*)��Ǳ�ܣ�.*������$",5)
	  if l==nil then
	     self:exps()
		 return
	  end
	  if string.find(l,"����") then
       world.AppendToNotepad (WorldName(),os.date()..": ��ɽ���� ��þ���:".. ChineseNum(w[2]).." Ǳ��:"..ChineseNum(w[3]).."\r\n")
	   local exps=world.GetVariable("get_exp")
	   exps=tonumber(exps)+ChineseNum(w[2])
	   world.SetVariable("get_exp",exps)
	   world.AppendToNotepad (WorldName(),os.date()..": Ŀǰ����ܾ���ֵ"..exps.."\r\n")
	   return
	  end
	  wait.time(5)
  end)
end

function huashan:xxdf()
    local player_name=world.GetVariable("player_name") or ""
	--^(> |)����Ⱥ.*˵������"..player_name.."����˵ħ�̽��������ں����������ף���ȥ����ɱ�ˣ��Ҿ��������������ɡ���$
    wait.make(function()
	   local l,w=wait.regexp("^(> |)����Ⱥ˵������"..player_name..".*��˵ħ�̽��������ں����������ף���ȥ����ɱ�ˣ��Ҿ��������������ɡ���$",10)
	   if l==nil then

	      return
	   end
	   if string.find(l,"��������") then
	      world.Send("nick ���Ǵ�")
		  -- print (utils.msgbox ("��ʼ�⻯���󷨣�������", "Warning!", "ok", "!", 1)) --> ok
	      return
	   end
	end)
end

function huashan:reward()
  dangerous_man_list_clear()
  	local ts={
	           task_name="��ɽ",
	           task_stepname="����",
	           task_step=7,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w
   w=walk.new()
   w.walkover=function()
   wait.make(function()
	 --self:exps()
	 local rc=reward.new()
	 world.Send("give ling to yue buqun")
	 rc:get_reward()
	--[[ ����Ⱥ���������������ִ�Ĵָ�������ġ�
����Ⱥ˵����������С�ֵ��պ�������£����кñ�����
��������ʮ�ĵ㾭�飬ʮ����Ǳ�ܣ�һ��һʮ�ĵ�����
�������Ⱥһ�����ơ�]]
      wait.make(function()
	     local l,w=wait.regexp("�������Ⱥһ�����ơ�|^(> |)������û������������$|^(> |)����Ⱥ˵��������ѽ����ɽ�ɾ�Ȼ������������ƭ�ӣ�$",5)
		 if l==nil then
		    self:reward()
			return
		 end
		 if string.find(l,"�������Ⱥһ������") then
            self:xxdf()
			--BigData:catchData(1532,"������")
		    local b=busy.new()
			b.interval=0.5
			b.Next=function()
				CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ɽ����:����! ����:"..rc.exps_num.." Ǳ��:"..rc.pots_num, "red", "black") -- black on white
			    self:jobDone()
			end
			b:check()
			return
		 end
		 if string.find(l,"������û����������") or string.find(l,"��ɽ�ɾ�Ȼ������������ƭ��") then
		   --print("bug!!!!")
		   self:giveup()
		   return
		 end
		 wait.time(5)
	  end)
   end)
   end
   w:go(1532)
end

function huashan:jobDone() --�ص�����
end

function huashan:get_npc()
     world.Send("get ling from "..self.robberid)
	 world.Send("kill "..self.robberid)
	 self:wait_robber_die()
    --[[wait.make(function()


	    --world.Send("get "..self.robberid)
		local l,w=wait.regexp("^(> |)�㽫"..self.robbername.."�����������ڱ��ϡ�$|^(> |)"..self.robbername.."�������̫���ˡ�$|^(> |)�����ʦ�ȼ�����ȶԷ��ߣ���������$|^(> |)���Ҳ��� "..self.robberid.." ����������$",5)
		if l==nil then
		   self:get_npc()
		   return
		end
		if string.find(l,"���ڱ���") then
		   shutdown()
		   self:jitan(self.robberid)
		   return
		end
        if string.find(l,"�������̫����") then
		   world.Send("kill "..self.robberid)
		   self:wait_robber_die()
		   return
		end
		if string.find(l,"��������") then
		    world.Send("kill "..self.robberid)
			self:combat()
		    self:wait_robber_die()
		   return
		end
		if string.find(l,"���Ҳ���") then
			self:giveup()
		    return
		end
	end)]]
end


function huashan:auto_wield_weapon(f,error_deal)
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

function huashan:get_corpse(index)
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
	      if w[2]==self.robbername then
            self:jitan()
		  else
		   index=index+1
		   world.Send("drop corpse")
           self:get_corpse(index)
		  end
		  return
	   end
	   if string.find(l,"�㸽��û����������") then
	      self:giveup()
	      return
	   end
   end
   b:check()
end

function huashan:qie_corpse(index)
   --local f=function(arg)
    --  self:qie_corpse(arg)
   --end
   --thread_monitor("huashan:qie_corpse",f,{index})
  wait.make(function()
    world.Send("wield jian")
	if self.weapon~="" then
	   world.Send("wield "..self.weapon)
	end
   if index==nil then
      world.Send("get gold from corpse")
	  world.Send("get ling from corpse")
      world.Send("qie corpse")
	else
	   world.Send("get gold from corpse "..index)
	  world.Send("get ling from corpse "..index)
	  world.Send("qie corpse ".. index)
   end


   local l,w=wait.regexp("ֻ�����ǡ���һ�����㽫"..self.robbername.."���׼�ն���������������С�|^(> |)���б���ɱ���˸��ﰡ��$|^(> |)�Ǿ�ʬ���Ѿ�û���׼��ˡ�$|^(> |)���Ҳ��� corpse ����������$|^(> |)�Ҳ������������$|(> |)��������������޷����У������������ʬ���ͷ����$|^(> |)����ü����������߲���������ʬ���ͷ����$|^(> |)����ɣ���Զ����ʬ��Ҳ����Ȥ��$",5)
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
           self:jitan()
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

function huashan:run(i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)������ʧ�ܡ�$|^(> |)�����Ϊ������$|^(> |)�趨����������action \\= \\\"����\\\"$",1.5)
	   if l==nil then
	      self:run(i)
	      return
	   end
	   if string.find(l,"�����Ϊ����") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"��Ķ�����û����ɣ������ƶ�") or string.find(l,"������ʧ��") then
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
			   world.Send("unset wimpy")
			   shutdown()
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

function huashan:flee(i)
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

function huashan:escape_place(place)
  --world.AppendToNotepad (WorldName().."_��ɽ����:",os.date()..": ��������"..place.."�Ӵ�!\r\n")
  --��һ��ץ����������ͼ�������ƣ��������������ݵö��˹�ȥ����˳�ֳ��������˵����֣�����ԭ�����������𽭺��ĺ�����
  wait.make(function()
     local l,w=wait.regexp("^(> |)��һ��ץ����������ͼ�������ƣ��������������ݵö��˹�ȥ����˳�ֳ��������˵����֣�����ԭ�����������𽭺���(.*)��$",5)
    if l==nil then
       self:escape_place(place)
	   return
	end
    if string.find(l,"��һ��ץ����������ͼ��������") then
	   --print(w[2])
	   self.robbername=w[2]
	    -- ����Σ�������б�
	   --dangerous_man_list_add(self.robbername)
	   self:escape(place,self.robbername)
	   return
	end
	wait.time(5)
  end)
end
--[[
�͵ش�������ܳ�һ�������˶���������ƣ���Сɽ·�����·��ȥ��
��һ��ץ����������ͼ�������ƣ��������������ݵö��˹�ȥ����˳�ֳ��������˵����֣�����ԭ�����������𽭺������ꡣ

]]

--[[

�͵ش�������ܳ�һ�������˶���������ƣ���
   *    *           *         *     *       *                        *    *      *           *
   *     *          *    *    *     *       * *                 *     **  *   *****    *     *
   *     *  *       *    *    *     *       *  *   ***************     *  *   *  *      *    *
   *  ********      *    *    *     *  **********       *   *             *   *  *      *    *   *
******            * * *  * *  *   ******    *           *   *       *  ********  *        *********
   *       *      * *  * *  * *     *  *    *           *   *   *    **   *   ****           *   *
  **   ******     * *  * *  * *     *  *    *  *    **************    *   * * *  *   ****    *   *
  ***  *   *     *  *    *    *     *  **** *  *    *   *   *   *       *******  *      *    *   *
 * * * *   *        *    *    *     *  *  * * *     *   *   *   *      **   * *  *      *   *    *
 * *   *   *        *    *    *     *  *  * * *     *   *   *   *     * *   * ****      *   *    *
*  *   *   *        *    *    *     ****  *  *      *   *   *   *   **  *   * *  *      *   *    *
   *   *   *        *    *    *   ***  ** *  *      *  *     ** *    *  *   * *  *      *  *  * *
   *   *   *  *    *     *    *    *   * *  **      * *         *    *  *   * *  *      * *    *
   *  *    *  *    *     *    *        *   *  * *   *           *    *  ***** *  *     * *        **
   * *      ***   *           *       *   *   * *   *************    *  *    * * *    *   *********
   **                         *      *         **   *           *    *      *   *
������ȥ��
��һ��ץ����������ͼ�������ƣ��������������ݵö��˹�ȥ����˳�ֳ��������˵����֣�����ԭ�����������𽭺��ĳ������ǡ�

]]


function huashan:bigword()
    new_bigword()
	world.AddTriggerEx ("bigword1", "^(.*)$", "get_bigword2(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1001)
	world.SetTriggerOption ("bigword1", "group", "bigword")

	wait.make(function()
	   local l,w=wait.regexp("^(����|��).*��ȥ��$",10)
	   if string.find(l,"��ȥ") then
	      world.EnableTriggerGroup("bigword",false)
		  world.DeleteTriggerGroup("bigword")
		   local locate=deal_bigword2()
		    print(locate)
	       self:escape_place(locate)
		  return
	   end
	   wait.time(10)
	end)
    --world.AddTriggerEx ("bigword2", "^���ġ�(.*)�����ϡ�$", "print(\"%1\")\EnableTriggerGroup(\"bigword\",false)\nDeleteTriggerGroup(\"bigword\")\nsongxin.deal_bigword(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	--world.SetTriggerOption ("bigword2", "group", "bigword")

end
--"��Ȼ","ͻȻ","�͵�","�䲻��","�䲻��",
--�䲻���������ɱ��һ�������˶���������ƣ�����ȪԺ����·��ȥ��
function huashan:menmian_ren()
   wait.make(function()
      local l,w=wait.regexp("^(> |)(��Ȼ|ͻȻ|�͵�|�䲻��|�䲻��)������.*��һ��������.*������ƣ���(.*)(��|����).*��ȥ��$|^(> |)(��Ȼ|ͻȻ|�͵�|�䲻��|�䲻��)������.*��һ��������.*������ƣ���$",10)
      if l==nil then
	     self:menmian_ren()
	     return
      end
      if string.find(l,"��ȥ") then
	     self.appear=true
		 self:shield()
	     shutdown()
	     print("��ȥ",w[3])
		 local location=Trim(w[3])
	     self:escape_place(location)
	     return
	  end
	  if string.find(l,"�������") then
	     self.appear=true
		 self:shield()
	     shutdown()
	    self:bigword()
	    return
 	  end
      wait.time(10)
   end)
end

function huashan:NextPoint()
   print("���ָ̻�")
   coroutine.resume(huashan.co)
end

function huashan:combat()
end

function huashan:pickup()
     world.Send("get ling from "..self.robberid)
	 world.Send("get "..self.robberid)
	 self:jitan(self.robberid)
end

function huashan:robber_idle()

end

function huashan:combat_end()
   local combat_endtime=os.time()
   local combat_usedtime=0
   if combat_starttime==nil then
     combat_usedtime=0
   else
     combat_usedtime=os.difftime (combat_endtime, combat_starttime)
   end
   --world.AppendToNotepad (WorldName().."_��ɽ����:",os.date()..": ��ɽս������(��ʱ:"..combat_usedtime..")\n")
end

function huashan:kill(npc,id)
     local ts2=""
     if self.run_hs2==true then
	     ts2="��ɽ2"
	 else
        ts2="��ɽ"
	 end
	local ts={
	           task_name=ts2,
	           task_stepname="ս��",
	           task_step=5,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	world.Send("kill "..id)
    if self.dayun==false then
	  --world.Send("kill "..id)
	  self:wait_robber_die()
	else
	  self:wait_robber_idle()
	  self:wait_robber_die()
	end
	--world.Send("follow "..id)
	--world.AppendToNotepad (WorldName().."_��ɽ����:",os.date()..": ��ɽս����ʼ\r\n")
	combat_starttime=os.time()
    self:combat()

end

function huashan:shield()
end

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

function huashan:wait_robber_idle()
   wait.make(function()  --������Ȫ��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
     --print(npc.."��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��")
     local l,w=wait.regexp("^(> |)"..self.robbername.."��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��",5)
     if l==nil then
	   self:wait_robber_idle()
	   return
	 end
	 if string.find(l,"��־�Ժ�������һ������") then
	    self:robber_idle()
	    return
	 end
	 wait.time(5)
   end)
end

function huashan:wait_robber_die()
   wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",5)
	 if l==nil then
	    self:wait_robber_die()
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
	    --print(self.robbername,w[2])
	    if string.find(w[2],self.robbername) then
		   self:robber_die()
		else
           self:wait_robber_die()
		end
	    return
	 end
	 if string.find(l,"����û�������")  then
	    self:robber_die()
		return
	 end
	 wait.time(5)
  end)
end

function huashan:robber_die()
end

function huashan:checkPlace(npc,roomno,here,CallBack,is_omit)
      if is_contain(roomno,here) or is_omit==true then
	     if self.look_NPC==true then --·�Ͼ���
			   self.look_NPC=false --ֻ���ڻ�ɽ2 ʱ���������־
			   self:Check_Point_NPC()--���
		 else
  	       print("�ȴ�0.3s,��һ������")
		   local f=function()
		     local b
		     b=busy.new()
		     b.interval=0.5
		     b.Next=function()
		        CallBack()
		     end
		     b:check()
		   end
		   f_wait(f,0.3)
		 end
	   else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
        self.check_place_count=self.check_place_count+1
		 if self.check_place_count>3 then
		    --self.check_place_count=0
			print("����3��ʧ�� ������")
			self:checkPlace(npc,roomno,here,CallBack,true)
		    return
		 end
	      local w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		 --[[ al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�")
				  coroutine.resume(huashan.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764)
		  end]]
		  al.noway=function()
		     self:giveup()
		  end
		  w.noway=function()
			 self:giveup()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno,CallBack)
		  end
		  w:go(roomno)
	   end
end

function huashan:checkNPC(npc,roomno,CallBack)

      --thread_monitor("huashan:checkNPC",f,{npc,roomno})
    wait.make(function()
      world.Execute("look;set action �˶����")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |).*"..npc.."��ʬ��\\\((.*)\\\).*$|^(> |)�趨����������action \\= \\\"�˶����\\\"",2)
	  if l==nil then
		self:checkNPC(npc,roomno,CallBack)
		return
	  end
	  if string.find(l,"�趨����������action") then
	      --û���ҵ�
		  --
		  if roomno==nil then
		    CallBack()
		  else
		    local f=function(r)
		       self:checkPlace(npc,roomno,r,CallBack)
		    end
		    WhereAmI(f,10000) --�ų����ڱ仯
          end
		  return
	  end
	  if string.find(l,"��ʬ��") then
	     self:robber_die()
	     return
	  end
	  if string.find(l,npc) then
	     --�ҵ�
		  local id=string.lower(Trim(w[2]))
		  self.robberid=id
		  --print(id)
		  world.Send("follow "..id)
		  shutdown()
		  self:kill(npc,id)
		  return
	  end
	  wait.time(6)
   end)
end

function huashan:Search(rooms,npc)
	for _,r in ipairs(rooms) do

          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		   al.break_in_failure=function()
		      self:giveup()
		  end
		   al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�")
				  coroutine.resume(huashan.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  local f=function()
			     self:NextPoint()
			  end
			  self:checkNPC(npc,1764,f)
		  end
		  al.maze_done=function()
		    local f=function()
			    al:maze_step()
			end
		    self:checkNPC(npc,nil,f)
		  end
		  w.user_alias=al
		  w.noway=function()
		    self:NextPoint()
		  end

		  w.walkover=function()
		    print("Ѱ��"..npc)
			local f=function()
			   self:NextPoint()
			end
		    self:checkNPC(npc,r,f)
		  end
		  print("��һ�������:",r)
		  self.target_roomno=r
		  w:go(r)
		  coroutine.yield()
	end
end
--[[unwield xiao
yun qimen
��ȥ ������
��һ��ץ����������ͼ�������ƣ��������������ݵö��˹�ȥ����˳�ֳ��������˵����֣�����ԭ�����������𽭺�����ͳ��
��ͳ
������
��ɽ    ��������
��ɽ��    ������
��ɽ    ������
�����: 953
�����: 956
�����: 1509
�����: 3066
�����: 3067
�����: 3068
�����: 3069
�����: 3070
�����: 3071
�����: 3072
�����: 3073]]
function huashan:auto_kill()

   wait.make(function()
     local l,w=wait.regexp("^(> |)������"..self.robbername.."��ɱ���㣡$",5)
	  if l==nil then
	     self:auto_kill()
	     return
 	  end
	  if string.find(l,"��ɱ����") then
	     print("���֣���")
	     shutdown()
		 local f
		 if self.run_hs2==true and self.sections~=nil then  --���ڻ�ɽ������
			 f=function()
	           self:check_section()
	         end
		 else
		    f=function()
			   self:NextPoint()
			end
		 end
		  self:checkNPC(self.robbername,self.target_roomno,f)
		 return
	  end
   end)
end

function huashan:NPC_exist()

   world.AddTriggerEx ("npc_place", "^(> |)(.*) - .*$", "print(\"%2\")\nSetVariable(\"NPC_place\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 350)
  wait.make(function()
    local l,w=wait.regexp("^(> |).*\\\s"..self.robbername.."\\\(.*\\\).*$",5)
	if l==nil then
	  self:NPC_exist()
	  return
	end
	if string.find(l,self.robbername) then
	  world.EnableTrigger("NPC_place",false)
	  world.DeleteTrigger("NPC_place")
	  self.look_NPC=true
	  local location=world.GetVariable("NPC_place")
	  location=Trim(location)
	  self.look_NPC_place=location
	  print("���ֵص�:",location)

	  --world.DeleteVariable("beauty_place")
	  return
    end
  end)
end

function huashan:Child_NextPoint()
  print("�ָ��ӽ���")
   coroutine.resume(huashan.co2)
end

function huashan:Child_Search(rooms)
  local al
   al=alias.new()
   al:SetSearchRooms(rooms)
   for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  al.maze_done=function()
			  self:checkNPC(self.robbername,nil,al.maze_step)
		  end
		  al.break_in_failure=function()
		      --self:giveup()
			  self:Child_NextPoint()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    local f=function()
			   self:Child_NextPoint()
			end
			self:checkNPC(self.robbername,r,f)
		  end
		  w:go(r)
		  coroutine.yield()
   end
end

function huashan:Check_Point_NPC()
	 local n,e=Where(self.look_NPC_place) --��ⷿ����
			   --��������Χ�󽻼�
	 local target_room={}
	  for _,r in ipairs(self.rooms) do
			      for _,t in ipairs(e) do
				    if t==r then
					  print("roomno:",t)
					  table.insert(target_room,t)
					end
				  end
	  end
       print("�ӽ���")
	   huashan.co2=coroutine.create(function()
            self:Child_Search(target_room)
		 --�ص���������ȥ
		   print("�ص���������ȥ!")
		   self:NPC_exist()
		   self:NextPoint()
	   end)
	   self:Child_NextPoint()
end

function huashan:goPlace(roomno,here,is_omit)
       print("��ʼ����:",roomno)
		local f=function()
	     self:check_section()
	   end
      if is_contain(roomno,here) or is_omit==true then
	       print("ȷ�����������->Next Room")
		   --self.is_checkPlace=false
		   self.check_place_count=0
		   local b
		   b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      --print("ִ��")
		      local i=self.section
			  local s=self.sections[i]
		      local tr=traversal.new()

			 self.rooms={}
			  local ex_rooms={}
               ex_rooms=Split(self.sections[i].alias_rooms,";")
             for _,g in ipairs(ex_rooms) do
		       if g~=nil then
			     --print("���뷿���:",g)
                 table.insert(self.rooms,g)
	           end
             end

			  local al=alias.new()
			  al:SetSearchRooms(self.rooms)
			  al.break_in_failure=function()
			      print("�޷�����,����·��")
			      self.section=self.section+1 --����
				  self:checkNPC(self.robbername,nil,f)
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
						self:checkNPC(self.robbername,nil,f)
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
						self:checkNPC(self.robbername,nil,f)
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
						self:checkNPC(self.robbername,nil,f)
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
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("�޷�����,����·��")
						self.section=self.section+1 --����
						self:checkNPC(self.robbername,nil,f)
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
				  self:checkNPC(self.robbername,nil,f)
			  end

		    al.songlin_check=function()
			  print("�Թ�check npc")
	          local f2=function() al:NextPoint() end
			  self:checkNPC(self.robbername,nil,f2)
			end
			al.maze_done=function()
			   print("�Թ�check npc")
			   local f2=function() al.maze_step() end
			   self:checkNPC(self.robbername,nil,f2)
			end

			  tr.user_alias=al
			  tr.step_over=function()
			     --���ǿ��
				 print("���ǿ��")
			     self:checkNPC(self.robbername,nil,f)
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
			self:goPlace(roomno,here,true)
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
						self:goPlace(roomno,here,true)
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
						--self:checkNPC(self.robbername,f)
						self:goPlace(roomno,here,true)
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
						--self:checkNPC(self.robbername,f)
						self:goPlace(roomno,here,true)
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
						--self:checkNPC(self.robbername,f)
						self:goPlace(roomno,here,true)
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
		    self:checkNPC(self.robbername,roomno,f)
		  end
		  w:go(roomno)
	   end
end

function huashan:check_section()

    local sections=self.sections
	local i=self.section
	if i>table.getn(sections) then
       print("Ѳ�����һ��")
	   if self.round>2 then
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
		 self:goPlace(aim_roomno,r)
	end
	WhereAmI(f,10000) --�ų����ڱ仯
end

function huashan:hs2_Search(paths,rooms,npc)
    self.is_checkPlace=true
	self:auto_kill()
	self:NPC_exist()
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
	al.do_jobing=true
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
	   al:NextPoint()
	end
	al.maze_done=function()
	   --print("wudang ִ�������Թ�")
	   self:checkNPC(self.robbername,nil,al.maze_step)
	end
	al.nanmen_chengzhongxin=function()
		if self.look_NPC==true then --·�Ͼ���
		     self.section=1 --·��
		     self.look_robber=false--ֻ���һ��
			 print("·�Ͼ���")
			 self:Check_Point_NPC()--��� ������ �ص�section��ʼ����
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
	w.user_alias=al
	w.noway=function()
	   self:giveup()
	end
	w.walkover=function()
	    ---ִ��ǰ �� check roomno
	    self.section=1 --·��
		self.rooms={}
		local ex_rooms={}
        ex_rooms=Split(self.sections[1].alias_rooms,";")
       for _,g in ipairs(ex_rooms) do
		   if g~=nil then
		      print("���뷿���:",g)
              table.insert(self.rooms,g)
	       end
       end
	   local f=function()
	     self:check_section()
	   end
	    self:checkNPC(npc,tr.startroomno,f)
	end
	w:go(tr.startroomno)	--�ߵ���ʼ����
end

function huashan:c_paths(e,depth,omit,opentime)
  local paths,rooms=depth_path_search(e,depth,omit,opentime)  --����·�� �����
  --print(paths)
  --print(rooms)
   print("��Ҫ��������")
   local ex_rooms={}
   local ex_list={}
   ex_rooms=Split(rooms,";")
   for _,g in ipairs(ex_rooms) do
      if ex_list[g]==nil then
	    ex_list[g]=g
        table.insert(self.rooms,g)
	  end
   end

   if paths~="" then
      --self:auto_kill(self.robbername)
	  --self:beast_kill_check()
	  local b
	  b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	     world.Send("yun recover")
	     self:shield()
	     self:hs2_Search(paths,rooms,self.robbername)
	  end
	  b:check()
	else
	  self:giveup()
    end
end

function huashan:test(location,depth,npc)
      print("��Χ��ѯ")
	  self.robbername=npc
		self.sections={}
		self:hs2_robber(location,6,npc)
end

function huashan:hs2_robber(location,depth,npc)
    local n,e=Where(location)
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
      omit="fengyun|longhu|tiandi|xiaoxi_dufengling|huigong"
   end
   if string.find(location,"�����") then
      omit="dufengling_xiaoxi"
   end
   if string.find(location,"��ɽ����") then
      omit="duanyaping_yading|qingyunpin_fumoquan"
   end
   if string.find(location,"��ɽ") then
      omit="baizhangjian_xianchoumen|xianchoumen_baizhangjian|t_leave"
   end
   if string.find(location,"������") then
      omit="shatan_shenlongdao"
   end
   if string.find(location,"������") then
      omit="shenlongdao_shatan"
   end
   if string.find(location,"����ɽ") then
      omit="houshanxiaolu_guanmucong"
   end
   if string.find(location,"���ݳ�") then
      omit="duhe|shamo_qingcheng|climb_shanlu"
   end
  if string.find(location,"���ݳ�") then
      omit="dujiang"
   end
   if string.find(location,"������") then
      omit="haibing_taohuadao"
   end
   if string.find(location,"�䵱ɽ") then
     if party=="�䵱��" and mastername=="������" then
       omit="xiaojing2_xiaojing1|xiaojing2_yuanmen|yitiantulong|dujiang|holdteng"
	 else
       omit="yitiantulong|dujiang|holdteng"
     end
   end

	if string.find(location,"�ƺ�����") then
      omit="xiaofudamen_xiaofudating"
   end
   if string.find(location,"��ɽ") then
      omit="duhe"
   end
   if string.find(location,"����ɽ") then
     omit="zoulang_shufang|movebei"
   end
   if string.find(location,"���޺�") then
     omit="zuan|push_door"
   end
   if string.find(location,"���ݳ�") then
      omit="swim"
   end
   if string.find(location,"������") then
      omit="dangtianmen_xiuxishi"
   end
   if string.find(location,"�ɶ���") then
      omit="shamo_qingcheng"
   end
   if string.find(location,"������") or string.find(location,"ţ�Ҵ�") then
      omit="haibing_taohuadao"
   end
--push_qiaolan' or direction='shanzhuang' or direction='xiaodao' or direction='yanziwu
   if string.find(location,"��٢��ɽׯ") or string.find(location,"����Ľ��") or string.find(location,"������") then
      omit="xiaodaobian_matou|quyanziwu|tanqin|qumr|yellboat|zuan_didao|didao|jump liang|yanziwu|push_qiaolan|shanzhuang|xiaodao"
   end
   if string.find(location,"����") then
     omit="tiandifenglei_feng|tiandifenglei_di|tiandifenglei_tian|tiandifenglei_lei|west_zishanlin_tiandifenglei_quick|east_zishanlin_tiandifenglei_quick" --zishanlin_search|
     if Trim(location)=="��������" then
        table.sort(e,function(a,b) return a>b end) --��������
		depth=5
     end
  end


   if string.find(location,"�䵱��ɽ") then
      omit="jump_river|pa ya"
   end
   if string.find(location,"���ݳ�") then
      omit="dujiang"
   end
    if string.find(location,"���ݳ�") then
      omit="enter_meizhuang"
   end
   if string.find(location,"�置") then
      if wdj.wdj2_ok==false or wdj.wdj2_ok==nil then
	     if string.find(location,"�置ɽ·") then
	      n=2
		  e={234,367}
		 end
	      omit="shanjiao_shanlu"
	  end
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
   if string.find(location,"��ɽ") then

      omit="shiguoya_shiguoyadongkou|siguoya_jiashanbi|huigong"
   end
   --print("omit:",omit)
  -- self:c_paths(e,depth,omit,true)
   --omit=omit.."|huigong|t_leave"
   self:c_paths(e,depth,omit,true) --�̶���Χ
end

function huashan:escape(location,npc)
     local ts=""
     if self.run_hs2==true then
	     ts="��ɽ2"
	 else
        ts="��ɽ"
	 end
	local ts={
	           task_name=ts,
	           task_stepname="����������",
	           task_step=4,
	           task_maxsteps=7,
	           task_location=location,
	           task_description="Ѱ�������� "..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��ɽ����:����"..location.." "..npc, "blue", "black") -- black on white
    local Max_round=2
	local z1="��ɽ��"
	local z2="��ɽ"
    if zone_entry(location)==true then
      self:giveup()
      return
   end
   location=string.gsub(location,"��ԭ����","")
    local n,rooms=Where(z1..location)
    if n==0 then
	  n,rooms=Where(z2..location)
	  if n==0 then
	    n,rooms=Where(location)
	  else
	    self.dayun=false
		location=z2..location
	  end
	else
	   self.dayun=false
	   location=z1..location
	end
    if n>0 and location=="��ɽ����" then
	   rooms=depth_search(rooms,2)
	end

	if location=="��ɽ������" then
	   Max_round=5
	   rooms=depth_search(rooms,2)
	end
	if location=="��ɽ��˵�" then
	   self.dayun=false
	end

	if n>0 then
	  if self.run_hs2==true then
	    if string.find(location,"��ɽ������") then
		  print("��ɽ����������")
	      rooms=depth_search(rooms,6)
	    else
	      print("��Χ��ѯ")
	      self.sections={}
	      self:hs2_robber(location,6,npc)
	     return
	    end
	  end
	 self:auto_kill()
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   huashan.co=coroutine.create(function()
		print(table.getn(rooms),"������")
        self:Search(rooms,npc)
		print("û���ҵ�npc!!")
		if self.round<=Max_round then
		   self.round=self.round+1
		   print("���³���һ��:",self.round)
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
--[[�䲻���������ɱ��һ����������ȥ������ƣ���˵ش���·��ȥ��
��һ��ץ����������ͼ�������ƣ��������������ݵö��˹�ȥ����˳�ֳ��������˵����֣�����ԭ�����������𽭺�����ïǬ��
]]
function huashan:songlin()
     local ts2=""
     if self.run_hs2==true then
	     ts2="��ɽ2"
	 else
        ts2="��ɽ"
	 end
  	local ts={
	           task_name=ts2,
	           task_stepname="����Ѳ��",
	           task_step=3,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  self:menmian_ren()
  world.Send("south")
  world.Send("east")

  --local w
  --w=walk.new()
  --w.walkover=function()
  local f=function()  self:patrol() end
  f_wait(f,1)
  --end
  --w:go(953)
end

function huashan:patrol()
  --ɽ���� 950
  if self.appear==true then
    print("ǿ������")
  else
    local w
     w=walk.new()
     w.walkover=function()
      self:songlin()
    end
    w:go(950)
  end
end

local jitan_count=1
function huashan:jitan(id)
  	local ts={
	           task_name="��ɽ",
	           task_stepname="���ؼ�̳",
	           task_step=6,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
local w
  w=walk.new()
  w.walkover=function()
  --����ɺ�����������д����һ�� һ �֡�
    if id==nil then
       world.Send("give shouji to yue lingshan")
	   world.Send("give corpse to yue lingshan")
	else
	   world.Send("give "..id.." to yue lingshan")
	end
	 world.Send("set action ���Ƽ��")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)����ɺ�����������д����һ�� һ �֡�$|^(> |)����ɺ�����������д����һ�� �� �֡�$|^(> |)�趨����������action \\= \\\"���Ƽ��\\\"|^(> )��������أ�$",5)
	   if l==nil then
	     self:jitan(id)
	     return
	   end
	   if string.find(l,"һ ��") then
	     if self.hs2==true then
		    self.dayun=false
		    local b=busy.new()
			b.interval=0.3
			b.Next=function()
              world.Send("jitan force")
			  local b2=busy.new()
			  b2.interval=0.5
			  b2.Next=function()
				self:recover()
			  end
	          b2:check()
			end
			b:check()
		 else
		   local b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      world.Send("jitan force")
			  local b2=busy.new()
			  b2.interval=0.5
			  b2.Next=function()
		        world.Send("ask yue lingshan about ��������")
			    local b1=busy.new()
			    b1.interval=0.3
			    b1.Next=function()
			       self:reward()
			    end
			    b1:check()
			  end
	          b2:check()
		   end
		   b:check()
		 end
		    jitan_count=1
		 return
	   end
	   if string.find(l,"�� ��") then
	     local b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      world.Send("jitan force")
			  local b2=busy.new()
			  b2.interval=0.5
			  b2.Next=function()
				self:reward()
			  end
	          b2:check()
		   end
		   b:check()
		    jitan_count=1
	     return
	   end
	   if string.find(l,"���������") then
		  if id==nil then
		     world.Send("drop shouji")
		  else
		     world.Send("drop "..id)
		  end
		  self:giveup()
	      return
	   end
	   if string.find(l,"�趨����������action") then


		  if jitan_count<=5 then
		    print("����5��")
		     self:jitan(id)
		  else
		     self:giveup()
		  end
		   jitan_count=jitan_count+1
	      return
	   end
	   wait.time(5)
	 end)
  end
  w:go(1514)
end

function huashan:liaoshang_fail()
end

function huashan:recover()

	local ts={
	           task_name="��ɽ2",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=7,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

    self.robbername=""
	self.appear=false
	self.run_hs2=true
	local vip=world.GetVariable("vip") or "��ͨ���"
	local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="����������" then
		   print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
		     if h.food<50 then
		       world.Send("ask xiao tong about ʳ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get fan")
			  	 world.Execute("eat fan;eat fan;eat fan;eat fan;drop fan")
				 local f
				 f=function()
				    self:recover()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 elseif h.drink<50 then
			   world.Send("ask xiao tong about ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get cha")
			  	 world.Execute("drink cha;drink cha;drink cha;drop cha")
				 local f
				 f=function()
				    self:recover()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 end
		   end
		   w:go(133) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif  h.qi_percent<=70 or h.jingxue_percent<=80  then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper)  then
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
				     self:recover()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,10)
			    end
				if id==777 then
				   self:recover()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(1512)
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   world.Send("yun recover")
			   if h.neili>h.max_neili*2-200 then
			     self:songlin()
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
			  self:songlin()
			end
			b:check()
		end
	end
	h:check()
end

function huashan:full()


     world.Send("yun refresh")
	 world.Send("yun recover")
	 self.robbername=""
	 self.appear=false
	 self.run_hs2=false
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 local qi_percent=world.GetVariable("qi_percent") or 100
	 qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100
	 local vip=world.GetVariable("vip") or "��ͨ���"

	local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)
	    --[[if (h.food<50 or h.drink<50) and vip~="������" then
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
		else]]
		if  h.jingxue_percent<=80 or (h.qi_percent<=liao_percent) then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
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
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			-- rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
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
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self:Status_Check()
				     return
				  end
				  world.Send("yun qi")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,10)
			    end
				if id==777 then
				   self:Status_Check()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(1512)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
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

function huashan:Status_Check()
	local ts={
	           task_name="��ɽ",
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

function huashan:qu_gold()
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
        world.Send("qu 2 gold")
		local l,w=wait.regexp("^(> |)���������ȡ�������ƽ�$|^(> |)��û�д���ô���Ǯ��$",5)
		print("����")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold()
		   return
		end
		if string.find(l,"���������") then
		   --�ص�
		   self:buy_zhengqidan()
		   return
		end
		if string.find(l,"��û�д���ô���Ǯ") then
		  world.Send("quit")
		  return
		end
		wait.time(5)
	  end)
   end
   w:go(410)
end

function huashan:buy_zhengqidan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy zhengqi dan")
	 local l,w=wait.regexp("����.*�ļ۸��ҩ���ƹ�����������һ����������|^(> |)������Ķ���������û�С�$|^(> |)��⵰��һ�ߴ���ȥ��|^(> |)������Ǯ�����ˣ���Ʊ��û���ҵÿ���$",5)
	 if l==nil then
	   self:buy_zhengqidan()
	   return
	 end
	 if string.find(l,"������Ķ���������û��") then
	   local f=function()
	     self:buy_zhengqidan()
	   end
	   print("5s �Ժ����")
	   f_wait(f,5)
	   return
	 end
	 if string.find(l,"һ��������") then
	    self:eat_zhengqidan()
	    return
	 end
	 if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
	    self:qu_gold()
	    return
	 end
	 wait.time(5)
	end)
 end
 w:go(413)
end

function huashan:eat_zhengqidan()
    wait.make(function()
      world.Send("fu zhengqi dan")
	  local l,w=wait.regexp("^(> |)�����һ������������ʱ�о��������������$",5)
	  if l==nil then
	    self:eat_zhengqidan()
	    return
	  end
	  if string.find(l,"�����һ��������") then
	    self:ask_job()
		return
	  end
	  wait.time(5)
	end)
end

function huashan:look_zhengqidan()
--  ��ʮ�����Ϣ��(Neixi wan)
 wait.make(function()
   world.Send("i")
   world.Send("set look")
   local l,w=wait.regexp("^(> |)(.*)��������\\(Zhengqi dan\\)$|^(> |)�趨����������look \\= \\\"YES\\\"",5)
   if l==nil then
      self:look_zhengqidan()
      return
   end
   if string.find(l,"������") then
	  self:eat_zhengqidan()
	  return
   end
   if string.find(l,"�趨����������look ") then
	  self:buy_zhengqidan()
	  return
   end
   wait.time(5)
  end)
end
--��������Ⱥ�����йء��Ͷ����ơ�����Ϣ��
--����Ⱥ˵�������㻹����ȥ˼�������˼��ȥ�ɡ���
