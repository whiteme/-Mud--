
songxin={
   new=function()
     local sx={}
	 setmetatable(sx,songxin)
	 sx.shashou_all_die=false
	 return sx
   end,
   co=nil,
   --shashou_id="",
   --shashou_name="",
   --sec_shashou_id="",
   --sec_shashou_name="",
   shashou_list={},
   _id="",
   target_roomno="",
   target_npc="",
   breakPoint=nil,
   danger=false,
   is_giveup=false,
   is_end=false,
   on_attack=false,
   neili_upper=1.9,
   immediate_sx1=false,  --����Ͷ��
   shashou_level=-1,
   blacklist="",
   shashou_all_die=false,
   neili_upper=1.9,
   robber_skill="",
   shashou_name="",
   status="����1",
   check_idle=false,
}
songxin.__index=songxin
--�������ֵ
--[[function songxin:begin_transaction(procedure)
   --���浱ǰ����
    local _sx={}
	_sx.shashou_id=self.shashou_id
	_sx.shashou_name=self.shashou_name
	_sx._id=self._id
	_sx.target_roomno=self.target_roomno
	_sx.target_npc=self.target_npc
	local item={}
	item.source=self
	item.variable=_sx
	item.method=procedure
	if self.breakPoint~=nil then
	   table.insert(self.breakPoint,item)
	end
end

function songxin:rollback(variable,procedure)
    self.shashou_id=variable.shashou_id
	self.shashou_name=variable.shashou_name
	self._id=variable._id
	self.target_roomno=variable.target_roomno
	self.target_npc=variable.target_npc
    procedure()
end--]]

function songxin:join()
   local w
   w=walk.new()
   w.walkover=function ()
	  wait.make(function()
	     world.Send("ask fu about join")
		 local l,w=wait.regexp("^(> |)��˼��˵�������ã�������λ.*����Ϊ�����������ˡ���$|^(> |)��˼��˵������.*�Ѿ��Ǳ���������ˣ��ιʻ�Ҫ��������Ц����$",5)
		 if l==nil then
            print("����̫�����Ƿ�����һ����Ԥ�ڵĴ���")
		    self:join()
		    return
         end
		 if string.find(l,"����Ϊ�����������ˡ�") or string.find(l,"�Ѿ��Ǳ����������") then
		    local b
			b=busy.new()
			b.interval=0.3
			b.Next=function()
			   self:ask_job()
			end
			b:check()
		    return
		 end
		 wait.time(5)
	  end)
   end
   w:go(445)
end

function songxin:fail(id) --�ص�����

end

function songxin:combat_check()
end

function songxin:run(i)
   wait.make(function()
	   local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)������ʧ�ܡ�$|^(> |)�����Ϊ������$|^(> |)�趨����������action \\= \\\"����\\\"$",1.5)
	   if l==nil then
		  --world.DoAfter(1.5,"set action ����")
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
			   --self:giveup()
			   self:check_poison()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function songxin:check_poison()  --����Ƿ��ж�
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
			          self:giveup()
			        end
			        rc:qudu(sec,i[1],false)
				    return
			     end

			   end
		     end
            self:giveup()
	end
	cd:start()
end

function songxin:flee(i)
  world.Send("go away")

  self.combat_end=function()
      print("flee combat_end")
       world.Send("unset wimpy")
	    shutdown()
		--����Ƿ��ж�
	   self:check_poison()

  end
  self:combat_check() --ս�����
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

function songxin:zonefilter(P)
 local party=world.GetVariable("party")
 local go=true
 if string.find(P,"�ؾ����¥") or string.find(P,"������") then --��ȥ
    return false
 end
 --[[if string.find(P,"̩ɽ") or string.find(P,"��ԭ") or string.find(P,"������") or string.find(P,"���ְ�") or string.find(P,"��ɽ") or string.find(P,"��ɽ����") or string.find(P,"���ݳ�") or string.find(P,"��ѩɽ") or string.find(P,"����ɽ") then
     go=true
 elseif string.find(P,"�����") or string.find(P,"�䵱ɽ") or string.find(P,"�䵱��ɽ") or string.find(P,"��������") or string.find(P,"����ɽ") or string.find(P,"���") or string.find(P,"ؤ��") or string.find(P,"����") or string.find(P,"��������") or string.find(P,"������") or string.find(P,"��ɽ") or string.find(P,"��ɽ��") or string.find(P,"�ƺ�����") or string.find(P,"������") or string.find(P,"������") then
	 go=true
 elseif string.find(P,"����ɽ") or string.find(P,"������") or string.find(P,"�置") or string.find(P,"�����") or string.find(P,"�����") or string.find(P,"�ɶ���") or string.find(P,"����Ƕ�") or string.find(P,"�������") or string.find(P,"�������") or string.find(P,"����ʹ�") or string.find(P,"��������") then
     go=true
 elseif string.find(P,"������") or string.find(P,"÷ׯ") then
	 go=true
 elseif (string.find(P,"��٢��ɽׯ") or string.find(P,"����Ľ��") or string.find(P,"������")) and party=="����Ľ��" then
     go=true
 elseif string.find(P,"����ɽ") or string.find(P,"���ݳ�") or string.find(P,"��ɽ��") or string.find(P,"���ݳ�") or string.find(P,"���ݳ�") or string.find(P,"����ׯ") or string.find(P,"���˳�") or string.find(P,"������") or string.find(P,"ţ�Ҵ�") or string.find(P,"��������") or string.find(P,"�һ���") then
     go=true
 end]]
 --print("go flag:",go)
 return go
end

function songxin:catch_place()
   wait.make(function()
      local l,w=wait.regexp("^(> |)������\\(Zhu wanli\\)�����㣺.*�͵���(.*)���ġ�(.*)�����ϡ�$|^(> |)������˵������.*���㲻�Ǳ�������ӣ��˻��Ӻ�˵�𣿡�$|^(> |)������˵�����������������������񣬻���ȥ��Ϣһ��ɡ���$|^(> |)������˵�������㲻���Ѿ��������ŵ������𣿻�����ȥ������$|^(> |)������˵����������ȥ��Ϣһ��ɣ���$",5)
	  if l==nil then
		print("����̫�����Ƿ�����һ����Ԥ�ڵĴ���")
		self:ask_job()
		return
	  end
	  if string.find(l,"�㲻�Ǳ�������ӣ��˻��Ӻ�˵��") then
	     local b
		 b=busy.new()
		 b.interval=0.3
		 b.Next=function()
	       self:join()
		 end
		 b:check()
	     return
	  end
	  --������(Zhu wanli)�����㣺��Ͻ������͵������޺����Źء��ġ��߷��佫�����ϡ�
	  --print("l:",l)
	  if string.find(l,"������%(Zhu wanli%)������") then
	    --print("w2:",w[2]," w3:",w[3])
		if string.find(w[3],"���°���") or string.find(w[3],"����") or string.find(w[3],"������") or string.find(w[3],"��ؤ") or string.find(w[3],"��ҩ��") or string.find(w[3],"����") or string.find(l,"������ʦ") or string.find(w[3],"Ѳ��") or string.find(w[3],"����") or string.find(w[3],"��������") or string.find(w[2],"�ؽ����ԭ") or string.find(w[2],"�����ʯ��") or string.find(w[3],"ֵ�ڱ�") then
		   self:giveup()
		else
		   --�Ż�
		   if self:zonefilter(w[2])==true then
		     self:delivery(w[2],w[3])
			 world.AddTriggerEx ("sx", "^(> |)��ʱ���ѹ�������ʧЧ��$", "shutdown();process.sx()", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
		   else
             self:giveup()
		   end
		end
	    return
	  end
	  if string.find(l,"�����������������񣬻���ȥ��Ϣһ���") then
	     local b=busy.new()
		 b.Next=function()
	        self.jobDone()
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"����ȥ��Ϣһ���")  then
		 self.fail(102)
	     return
	  end
	  if string.find(l,"�㲻���Ѿ��������ŵ������𣿻�����ȥ��") then
	     self:giveup()
	     return
	  end
	  --print("error")
	  wait.time(5)
   end)
end


function songxin:ask_job()
  	local ts={
	           task_name="����",
	           task_stepname="ѯ��������",
	           task_step=2,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
 -- self:begin_transaction(function() self:ask_job() end)  --�ϵ�
  self.shashou_all_die=false
  local w
  w=walk.new()
   local al=alias.new()
   al.do_jobing=true
   w.user_alias=al
  w.walkover=function()
	wait.make(function()
	  world.Send("ask zhu about job")
      local l,w=wait.regexp("^(> |)��������������йء�job������Ϣ��$",5)
	  if l==nil then
	     self:ask_job()
		 return
	  end
	  if string.find(l,"��������������й�") then
	     --world.AppendToNotepad (WorldName(),os.date().." �书:"..w[5].." ����:"..w[6].."\r\n")
		  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��������:������ʼ", "yellow", "black")

	     self:catch_place()
		 --BigData:catchData(506,"��վ")
		 return
	  end
	  wait.time(5)
	end)
  end
  w:go(506)
end

function songxin:giveup()
   world.DeleteTrigger("sx")
   danerous_man_list_push()
   local pfm=world.GetVariable("pfm") or ""
    world.Send("alias pfm "..pfm)
  --self:begin_transaction(function() self:giveup() end)  --�ϵ�
  --��ֹ
  --[[if self.shashou_name=="" and self.shashou_id=="" then --ɱ��û�г��ֹ�
    print("�Ż�������!!!Σ��")
    shutdown()
    self:wait_shashou()
	self.is_giveup=true
  else
    print("û����!!!")
  end]]

  local w
  w=walk.new()
  w.locate_fail_deal=function()
    local f=function()
     self:giveup()
	end
	--
	print("�ȴ�4��")
	f_wait(f,4)
  end
  w.walkover=function()
     world.Send("ask zhu about fangqi")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)��������������йء�fangqi������Ϣ��$",8)
	   if l==nil then
		 self:giveup()
	     return
	   end
	   if string.find(l,"��������������й�") then
	      --world.AppendToNotepad (WorldName(),os.date().." �书:"..w[5].." ����:"..w[6].."\r\n")
		  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��������:��������", "red", "black")
		  --BigData:catchData(506,"��վ")
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		   self:Status_Check()
		 end
		 b:check()
	     return
	   end
	   wait.time(8)
	 end)
  end
  w:go(506)
end

function songxin:NextPoint()
   print("���ָ̻�:",coroutine.status(songxin.co))
   if songxin.co==nil or coroutine.status(songxin.co)=="dead" then
      self:giveup()
   else
      coroutine.resume(songxin.co)
   end
end

--[[
> �����һ�Ѷ�ͷ�ĺ����ӻ����ͳ��Ž����ٱ�˵�������Ƕ���ү�������͸������ţ������պá�
�ٱ��ӹ��ſ��˿������˵�ͷ˵������λ׳ʿ�������ˡ�
�ã�������ɣ��㱻�����ˣ�һ��һʮһ��ʵս���飬��ʮ���Ǳ�ܡ���Ϊ���������ɹ�����һ��һʮ���Ρ�
�ٱ�˳�������Ϲ����˼��£�Ȼ������ŷ⣬�ֽ��������㡣
�ٱ�����Ķ�������˵������Ͻ������͵�������ɽ������ġ��ֹ᡹���ϡ�
�ٱ�����Ķ�������˵���������и��书��������ڻ��ͨ�ļһ�Ҫ��������ţ���ɵ�С�ĶԸ�Ŷ��]]

--[[
�ķ�Сʦ̫����Ķ�������˵������Ͻ������͵���
.............:.      : .  .....          :           ..........         :     :
       :   .     ````:``` : .`    .......:.....:.            .`         :     :  .
  :    :`````     ```:``  : ``.        .`:`.              ..`       ````:`` ``:````
  :    :     .   ````:``` :`..`     ..`  :  ``...  .......:.....:.     ::.   ::.
  ```````````:`    .:...:.:.:     `` ....:.... `          :           : : ` : : :..
             :   `` :   :   :        :       :            :         .`  : .`  :  `
         .   :      :   : . :        :       :            :             :     :
          `.`       `   :  `         :```````:          `.`             :     :

���ġ��ۺ졹���ϡ�
]]


function songxin:bigword()
    new_bigword()
	world.AddTriggerEx ("bigword1", "^(.*)$", "print(\"%1\")\get_bigword(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1001)
	world.SetTriggerOption ("bigword1", "group", "bigword")

	wait.make(function()
	   local l,w=wait.regexp("^���ġ�(.*)�����ϡ�$",10)
	   if string.find(l,"����") then
	      world.EnableTriggerGroup("bigword",false)
		  world.DeleteTriggerGroup("bigword")
		  self:deal_bigword(w[1])
		  return
	   end
	   wait.time(10)
	end)
    --world.AddTriggerEx ("bigword2", "^���ġ�(.*)�����ϡ�$", "print(\"%1\")\EnableTriggerGroup(\"bigword\",false)\nDeleteTriggerGroup(\"bigword\")\nsongxin.deal_bigword(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	--world.SetTriggerOption ("bigword2", "group", "bigword")

end

function songxin:deal_bigword(npc)
    print("npc:",npc)
    local locate=deal_bigword()
    --Where(locate)
	self:deliveryAgain(locate,npc)
	--�ڶ�������
end

local function look_bigword()
    new_bigword()--�µĴ���
	world.AddTriggerEx ("bigword0", "^(> |).*����һ���ɴ�����������������ż�������д��$", "EnableTriggerGroup(\"bigword\",true)\nEnableTrigger(\"bigword0\",false)", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	world.SetTriggerOption ("bigword0", "group", "bigword")
	world.AddTriggerEx ("bigword01", "^.*��$", "print(\"right\")\nEnableTriggerGroup(\"bigword\",true)", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	world.SetTriggerOption ("bigword01", "group", "bigword")
    world.AddTriggerEx ("bigword1", "^(.*)$", "print(\"%1\")\nget_bigword(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1001)
	world.SetTriggerOption ("bigword1", "group", "bigword")
    world.AddTriggerEx ("bigword2", "(.*)�� ������$", "print(\"%1\")\EnableTriggerGroup(\"bigword\",false)\ndeal_bigword()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1000)
	world.SetTriggerOption ("bigword2", "group", "bigword")
	world.Send("look letter")
end
--����������Ķ�������˵���������и��书���������Ϊ�˵õļһ�Ҫ��������ţ���ҪС�ĵ�Ŷ��
--�����ŵ�������Ķ�������˵���������и��书�������΢������ļһ�Ҫ��������ţ���Ӧ�����Ը����¾Ϳ����˰ɡ�
function songxin:strong()
    wait.make(function()
	  print("̽��ǿ��:")
	  --�ٱ�����Ķ�������˵���������и��书����������뻯���ļһ�Ҫ��������ţ��򲻹��ɲ�Ҫ���ܡ�
	  local l,w=wait.regexp("^(> |).*����Ķ�������˵���������и��书�������(.*)�ļһ�Ҫ���������.*$",3)
	  if self.is_end==true then
	    print("̽�����")
	    return
	  end
	  if l==nil then
	    --print("strong")
		self:strong()
		return
	  end
	  if string.find(l,"����Ķ�������˵����") then
        print("ǿ�ȣ�",w[2])
		local str=w[2]
		local value
		if str=="΢�����" then
		  value=1
		elseif str=="������" then
		  value=2
		elseif str=="С������" then
		  value=3
		elseif str=="�ڻ��ͨ" then
		   value=4
		elseif str=="��Ϊ�˵�" then
		   value=5
		elseif str=="��������" then
		   value=6
		elseif str=="���뻯��" then
		   value=7
		else
		   value=8
		end
		if value<=self.shashou_level then
		  	 local b
	         b=busy.new()
	         b.interval=0.3
	         b.Next=function()
			  print("�ָ�����")
	          self:shield()
		      self:recover()
			 end
			 b:check()
		else
		   print("ɱ��̫Σ��,����")
	       world.Send("no")
		   world.DeleteTrigger("sx")
		   shutdown()
	       local b
	       b=busy.new()
	       b.interval=0.3
	       b.Next=function()
	         self:jobDone()
	       end
	       b:check()
		end
        return
	  end
	  wait.time(3)
	end)
end

function songxin:reward()
   dangerous_man_list_clear()
   --[[ wait.make(function()
      local l,w=wait.regexp("^(> |)�ã�������ɣ��㱻�����ˣ�(.*)��ʵս���飬(.*)��Ǳ�ܡ�.*|^(> |)��ϲ�㣡��ɹ�����������������㱻�����ˣ�",5)
	  if l==nil then
	     self:reward()
	     return
	  end

	  ��ϲ�㣡��ɹ�����������������㱻�����ˣ�
��ʮ�㾭��!
ʮ����Ǳ��!
����˳������
�����: 10188.86328125
set action ����
���ؽӹ��ſ��˿������˵�ͷ˵������λС�ֵ��������ˡ�
��ϲ�㣡��ɹ�����������������㱻�����ˣ�
һ����ʮ�ĵ㾭��!
��ʮ�ĵ�Ǳ��!
����˳�������Ϲ����˼��£�Ȼ������ŷ⣬�ֽ��������㡣
��������Ķ�������˵������Ͻ������͵������������š��ġ����ҡ����ϡ�
�ڶ���Ͷ�� ���������� ����
]]
	  --if string.find(l,"�������") or string.find(l,"�㱻������") then

		local rd=reward.new()
		rd.finish=function()
         local ts={
	           task_name="����",
	           task_stepname="����",
	           task_step=8,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	       }
	     local st=status_win.new()
	     st:init(nil,nil,ts)
     	 st:task_draw_win()
		 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��������:����! ����:"..rd.exps_num.." Ǳ��:"..rd.pots_num, "red", "black") -- yellow
		  --exps=tonumber(exps)+ChineseNum(w[2])
		end
		rd:get_reward()
	--	return
    -- end
   --end)
end


function songxin:is_jobOver()
   wait.make(function()
       world.Send("set action ����")
       local l,w=wait.regexp("^(> |).*����Ķ�������˵����.*�͵���(.*)���ġ�(.*)�����ϡ�$|^(> |).*����Ķ�������˵������Ͻ������͵���$|^(> |)�趨����������action \\= \\\"����\\\"$",5)
	   if l==nil then
		 self:is_jobOver()
		 return
	   end
	   if string.find(l,"�����ϡ�") then
		 self.status="����2"
		 print("�ڶ���Ͷ��",w[2],w[3])
		 self:strong()  --̽��ǿ��
	     self:deliveryAgain(w[2],w[3])

		return
	   end
	   if string.find(l,"����Ķ�������˵������Ͻ������͵���") then
		 self.status="����2"
		 self:bigword()
		 return
	   end
	   if string.find(l,"�趨����������action") then
	     print("�������")
		 world.DeleteTrigger("sx")
		 self.is_end=true
		 local b
	     b=busy.new()
	     b.interval=0.5
	     b.Next=function()
	       self:jobDone()
	     end
	     b:check()
		 return
	   end
	   wait.time(5)
   end)
end

function songxin:recover2(npc_id)

	world.Send("yun recover")
	world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()
	    if h.qi_percent<100 and h.qi_percent>=80 then --������
		    print("��ͨ����")
            local rc=heal.new()
			--rc.saferoom=505
			rc.hudiegu=function()
			  rc:heal(false,false)
			end
			rc.heal_ok=function()
			   self:recover2(npc_id)
			end
			rc:heal(true,false)
		elseif h.qi_percent<80 then
		     self:songxin(npc_id,1,true)

		elseif h.neili<=math.floor(h.max_neili*1.2) then
		    local x
			x=xiulian.new()
			x.safe_qi=200
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
				  world.Send("yun jing")
				  world.Send("yun recover")
				  local f=function()
				     self:recover2(npc_id)
				  end
				  f_wait(f,2)
			    end
				if id==777 then
				  self:recover2(npc_id)
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

			          self:recover2(npc_id)
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
			   world.Send("yun recover")
			   --print(h.neili,math.floor(h.max_neili*self.neili_upper))
			   if h.neili>math.floor(h.max_neili*self.neili_upper) then
			       self:songxin(npc_id,1,true)
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
            self:songxin(npc_id,1,true)
		end
	end
	h:check()
end

function songxin:look_letter(id,index,recover)
--    �������볤�� ���� ������
   world.Send("look letter")
   wait.make(function()
       local l,w=wait.regexp("^(> |)\\s*��(.*) (.*)�� ������$|^(> |)��Ҫ��ʲô��$",5)
	   if l==nil then
	      self:look_letter(id,index,recover)
	      return
	   end
	   if string.find(l,"��Ҫ��ʲô") then
	      self:giveup()
	      return
	   end
	   if string.find(l,"����") then
	      print("ȷ��")
	      print("�ص�",w[2]," ���� ",w[3])
		  if self.target_npc~=w[3] then
		     self:delivery(w[2],w[3])
		  else
		      if index==nil or index==1 then
	     	      index=2
			  else
		          index=index+1
		      end
	          self:songxin(id,index,recover)
		  end
	      return
	   end
   end)
end

function songxin:songxin(id,index,recover)
--�ж����Ƿ�������2
  if self.shashou_level>0 and recover~=true and self.status~="����2" then
     print("������2,�Ȼָ��£���")
  	local ts={
	           task_name="����",
	           task_stepname="������2�ָ�",
	           task_step=5,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	 self:recover2(id)
     return
  end
--�жϽ���
  --self:begin_transaction(function() self:songxin(id,index) end)  --�ϵ�
  print("Ͷ���ż�")
  wait.make(function()
    if index==1 or index==nil then
      world.Send("songxin "..id)
	else
	  world.Send("songxin "..id.." "..index)
	end
	--�ο���ֵ����㿴������Ƿ��ʹ����ˣ�����ͬ�����˿ɲ���Ŷ��
	--����ҵ³��������Ų��Ǹ��ҵģ����ǲ����ʹ��ˣ�> â׿�Ϳ���������Ų��Ǹ��ҵģ����ǲ����ʹ��ˣ�
    --�����һ�Ѷ�ͷ�ĺ����ӻ����ͳ��Ž�������˵�������ǳ��ְ�������������͸������ţ������պá�
     local l,w=wait.regexp("(> |)��Ҫ�͸�˭��$|^(> |).*��������Ų��Ǹ��ҵģ����ǲ����ʹ��ˣ�$|^(> |).*��ֵ����㿴������Ƿ��ʹ����ˣ�����ͬ�����˿ɲ���Ŷ��|(> |)������㣬���ǻ����𣿣�$|^(> |)�����һ�Ѷ�ͷ�ĺ����ӻ����ͳ��Ž���.*˵��������.*�������͸������ţ������պá�$|^(> |)ʲô.*$",10)
	 --������������Ķ�������˵������Ͻ������͵����������������ġ����߶������ϡ�
	 if l==nil then
	   self:songxin(id,index,recover)
	   return
	 end
	 if string.find(l,"����Ų��Ǹ��ҵ�") then
	    self:look_letter(id,index,recover)

    	 return
	 end
	 if string.find(l,"����ͬ�����˿ɲ���Ŷ") then
	    self:NextPoint()
	    return
	 end
	 if  string.find(l,"��Ҫ�͸�˭") then
	    self:continue()
	    return
	 end
	 if string.find(l,"������㣬���ǻ�����") then
	   -- wait npc auto ����
	    local f=function()
		self:songxin(id,index,recover)
		end
		print("�ȴ�1.5��")
		f_wait(f,1.5)
	    return
	 end

	 if string.find(l,"�����һ�Ѷ�ͷ�ĺ����ӻ����ͳ��Ž���") then
	    shutdown()
	    --û�к�������
		self:reward()
		self:is_jobOver()
	    return
	 end
	 if string.find(l,"ʲô") then
	    print("�Ƿ��ż���ʧ")
		self:check_letter()
	    return
	 end
	 wait.time(10)
  end)
end

function songxin:send(npc,id)
   id=string.lower(Trim(id))
   self._id=id
   print(npc," id:=",self._id)
   if self.shashou_all_die==false then
     if self.immediate_sx1==true or self.target_roomno==4141 then  --ȫ��ҩ�����ǰ�ȫ���� �޷�fight
	     self:strong()--ǿ��̽��
         self:songxin(id)
	 else
		 self.check_idle=true
	     self:auto_pfm()
         world.Send("follow "..id)
	  end
   else
     self:strong()--ǿ��̽��
     self:songxin(id)
   end

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

function songxin:checkPlace(npc,roomno,here,Callback)
   if is_contain(roomno,here) then
  	     print("�ȴ�0.3s,��һ������")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     Callback()
		   end
		   b:check()
		 end
		 f_wait(f,0.3)
	   else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
		  local f1=function()
		     self:NextPoint()
		  end
	      local w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		     print("checkplace giveup")
		      self:giveup()
		  end
		  --[[al.circle_done=function()
		     print("����")
		     local f2=function()
				coroutine.resume(alias.circle_co)
			 end
			 self:checkNPC(npc,nil,f2)
		  end]]
		  al.maze_done=function()
		       print("�����Թ�����")

			 self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.noway=function()
		     self:NextPoint()
		  end
		  al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�")
				  coroutine.resume(songxin.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	          self.NextPoint=function() al:NextPoint() end
			  self:checkNPC(npc,1764,f1)
		  end
		  w.noway=function()
		     self:NextPoint()
		  end
		  w.user_alias=al
		  w.walkover=function()
		    self:checkNPC(npc,roomno,f1)
		  end
		  if roomno>0 then
		     w:go(roomno)
		  else
		    self:NextPoint()
		  end
	   end
end

function songxin:checkNPC(npc,roomno,Callback)
  --print(roomno," room")
  --print(npc," npc")
  --print(Callback," callback")
   --self:begin_transaction(function() self:checkNPC(npc,roomno) end)  --�ϵ�
   wait.make(function()
      world.Execute("look;set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\)$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno,Callback)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      if roomno==nil then  --�Թ�
			local b
		    b=busy.new()
		    b.interval=0.5
		    b.Next=function()
		      Callback()
		    end
		    b:check()
		     return
		  end
	      --û���ҵ�
		  --print("Next �ص�")
		  local f=function(r)
		     self:checkPlace(npc,roomno,r,Callback)
		  end
		  WhereAmI(f,10000) --�ų����ڱ仯
		  return
	  end
	  if string.find(l,npc) then
	     print("�ҵ�Ŀ��")
	     --�ҵ�

		  self:send(npc,w[2])
		  return
	  end
	  wait.time(6)
   end)
end

   --���ٱ�����־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��

function songxin:combat_end(cb)

end

function songxin:combat()
end

function songxin:sure_shashou()
end

function songxin:shashou(name,id)
     id=Trim(id)
	 id=string.lower(id)
	 print("ɱ��:",name,id)
	 self.shashou_name=name
	 local _item={}
	 _item.shashou_id=id
	 _item.shashou_name=name
	 table.insert(self.shashou_list,_item)
	 self.get_shashou_id(id) --�ص����� ��combat ����ֵ
	 self:sure_shashou()
	 -- ����Σ�������б�
	 dangerous_man_list_add(name)
end
--[[function songxin:sec_shashou(name,id)
     id=Trim(id)
	 id=string.lower(id)
	 print("sec ","ɱ��:",name,id)
	 self.sec_shashou_id=id
	 self.sec_shashou_name=name
	 self:sure_sec_shashou()
end]]

function songxin:get_id(npc)
	wait.make(function()
		 world.Execute("look")
	    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$",5)
		if l==nil then
		   self:get_id(npc)
		   return
		end
		if string.find(l,npc) then
		   self:shashou(npc,w[2])
		   return
		end
		wait.time(5)
	end)
end
--��õڶ���id
--[[function songxin:get_sec_id(npc)
	wait.make(function()
		 world.Execute("look")
	    local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$",5)
		if l==nil then
		   self:get_sec_id(npc)
		   return
		end
		if string.find(l,npc) then
		   self:sec_shashou(npc,w[2])
		   return
		end
		wait.time(5)
	end)
end]]

function songxin:continue()
    local w
	w=walk.new()
	local al
	al=alias.new()
	--al.break_pfm=self.break_pfm
	al.break_in_failure=function()
	   print("continue ����")
	  self:giveup()
	end
	al.noway=function()
	  self:NextPoint()
	end
	w.noway=function()
	  self:giveup()
	end
	local f1=function()
	    self:NextPoint()
	end
	w.user_alias=al
	w.walkover=function()
		self:checkNPC(self.target_npc,self.target_roomno,f1)
	end
	--w:go(2745)
	w:go(self.target_roomno)
end

function songxin:loot_corpse()
end

function songxin:loot(index)
  --print("loot corpse")
  self.shashou_all_die=true
   wait.make(function()
    if index==nil or index==1 then
     world.Send("get silver from corpse")
	  world.Send("get gold from corpse")
	 world.Send("get letter from corpse")
	 world.Send("get silver from corpse 2")
	else
	 world.Send("get gold from corpse "..index)
	 world.Send("get silver from corpse "..index)
	 world.Send("get letter from corpse "..index)
	 world.Send("get silver from corpse "..index+1)
	end
	world.Send("set look 1")
	 --���Ҳ��� corpse 2 ����������
	 --���������յ�ʬ�������ѳ�һ���ż���
	 local l,w=wait.regexp("���.*ʬ�������ѳ�һ���ż���|���Ҳ��� corpse.*����������|^(> |)�趨����������look \\= 1",3)
	 if l==nil then
	    self:loot(index)
		return
	 end

	 if string.find(l,"ʬ�������ѳ�һ���ż�") then
	    self:loot_corpse()
	    if self._id~="" then
		   self:strong()--ǿ��̽��
		   self:songxin(self._id)
	    else
		   if self.target_roomno==-99 then
		     self:NextPoint()  --�������̻�δ����
		   else
		     self:continue()
		   end
	    end
	    return
	 end
	 if string.find(l,"���Ҳ���") then
	    self:check_letter()
	    return
	 end
	if string.find(l,"�趨����������look") then
	   local new_index
	   if index==nil then
	      new_index=1
		else
		  new_index=index+1
	   end
	    self:loot(new_index)
	    return
	 end
	 wait.time(3)
	end)

end

function songxin:check_letter()
    --print("����ż�")

	wait.make(function()
	   world.Execute("i;set action ���")

	   local l,w=wait.regexp("^(> |)  һ���ż�\\\(Letter\\\)$|^(> |)�趨����������action \\= \\\"���\\\"$",3)
	   if l==nil then
	     self:no_live()
		 return
	   end
        if string.find(l,"�ż�") then
		   print("��letter")
		   if self._id~="" then
		     self:strong()--ǿ��̽��
		     self:songxin(self._id)
	       else
		     self:continue()
	       end
		   return
		end
		if string.find(l,"�趨����������action") then
			print("no letter")
	        self:giveup()
		   return
		end
	end)
end

function songxin:no_live()
   --self:giveup()
   local b=busy.new()
   b.Next=function()
     self:loot()
   end
   b:check()
end

function songxin:lookCorpse()

	--self:begin_transaction(function() self:lookCorpse() end)  --�ϵ�
    wait.make(function()
	    print("�鿴ʬ��")
		local regexp="^(> |)�趨����������look \\= 1$"
		for _,i in ipairs(self.shashou_list) do
		    local name
			local id
			name=i.shashou_name
			id=i.shashou_id
		    regexp=regexp.."|^(> |).*"..name.."\\\(.*\\\) <ս����>$|^(> |).*"..name.."\\\(.*\\\) <���Բ���>$"
		end
	     world.Execute("look;set look 1")
		 local l,w=wait.regexp(regexp,3)
		   --  ��ɷ��Ůɱ�� Ǯ����(Qian juyan) <ս����>
		   --  ��ɷ��Ůɱ�� Ǯ����(Qian juyan) <���Բ���>
		if l==nil then
		   self:lookCorpse()
		   --self:giveup() --û��ʬ��
		   return
		end
--�㸽��û������������
--���������������һ���´������ã��ű�͵��!
--���������յ�ʬ�������ѳ�һ���ż���

		if string.find(l,"���Բ���") then
		   print("��û������")
		   local f=function()
		      for _,i in ipairs(self.shashou_list) do
				 local name
			     local id
				 name=i.shashou_name
			     id=i.shashou_id
				 world.Send("kill "..id)
			  end
		      self:lookCorpse()
		   end
		   f_wait(f,1.5)
		   return
		end
		if string.find(l,"ս����") then
		   --print("��������������")
		   print("����ս����")
		   local f=function()
		      for _,i in ipairs(self.shashou_list) do
				 local name
			     local id
				 name=i.shashou_name
			     id=i.shashou_id
				 world.Send("kill "..id)
			  end
		      self:combat()
		   end
		   f_wait(f,0.5)
		   return
		end
		if string.find(l,"�趨����������look") then
		   shutdown()
		   self:no_live()
		   return
		end
		wait.time(3)
	end)
end
--�����ŵ�������Ķ�������˵���������и��书�������΢������ļһ�Ҫ��������ţ���Ӧ�����Ը����¾Ϳ����˰ɡ�
--����ǿ��
--[[
��⣬�ֳ������˸��ˣ�
�ʸ���˵������ʦ�֣�����Ӳ�úܣ��������㣡������
�������ʸ�����ɱ���㣡
]]
function songxin:secondCome()
   wait.make(function()
   --�㶨��һ����ԭ�����������������Ҵ����书���ߣ��ƺ��õ��������ɵ�Ѹ��ʮ������
      local l,w=wait.regexp("^(> |)��⣬�ֳ������˸��ˣ�$",10)
	  if l==nil then
	     self:secondCome()
		 return
	  end
	  if string.find(l,"�ֳ������˸���") then
	     self:secondAttack()
		 return
	  end
	  wait.time(10)
   end)
end

function songxin:secondAttack()
  --print("sec killer")
  wait.make(function()
   --�㶨��һ����ԭ�����������������Ҵ����书���ߣ��ƺ��õ��������ɵ�Ѹ��ʮ������
      local l,w=wait.regexp("^(> |)(.*)˵������ʦ�֣�����Ӳ�úܣ��������㣡������$",10)
	  if l==nil then
	     self:secondAttack()
		 return
	  end
	  if string.find(l,"ʦ�֣�����Ӳ�úܣ���������") then
	     print("sec ","who:",w[2])
		 if self.on_attack==false then
		   self.on_attack=true
		   shutdown()
		   self:get_id(w[2])
		   self:wait_shashou_die()
		   self:wait_shashou_idle()
		   self.combat()
		 else
		    self:get_id(w[2])
		 end
		 return
	  end
	  wait.time(10)
   end)
end

function songxin:deal_blacklist(skill)
   if self.blacklist=="" or self.blacklist==nil then
      return false
   end
   local blacklist=Split(self.blacklist,"|")
	for _,b in ipairs(blacklist) do
	       local i=Split(b,"&")
		   local party_name=i[1]
		   local party_skill=i[2]

		   if string.find(skill,party_name) then
		     if party_skill==nil then
			    return true
			 elseif string.find(skill,party_skill) then
			    return true
		 	 end
		   end
	end
	return false
end

function songxin:UnderAttack()
   --shutdown()
 --  ���������������һ���´������ã��ű�͵��!
 --�����˵������С�ӣ��Թ԰��ܺ��������ɣ�������
   print("wait attack")
   world.Execute("halt;halt;halt;halt")
   self:secondCome()
   wait.make(function()
   --�㶨��һ����ԭ�����������������Ҵ����书���ߣ��ƺ��õ��������ɵ�Ѹ��ʮ������
      local l,w=wait.regexp("^(> |)(.*)˵������.*���Թ԰��ܺ��������ɣ�������$|^(> |)�㶨��һ����ԭ����(.*)�����Ҵ����书(.*)���ƺ��õ���(.*)��",10)
	  if l==nil then
	     self:UnderAttack()
		 return
	  end
	  if string.find(l,"�Թ԰��ܺ���������") then
	     --print("who:",w[2])
		   	local ts={
	           task_name="����",
	           task_stepname="����1ս��",
	           task_step=4,
	           task_maxsteps=8,
	           task_location="",
	           task_description=w[2],
	        }
	       local st=status_win.new()
         	st:init(nil,nil,ts)
         	st:task_draw_win()
		  self.shashou_name=w[2]
		  self:wait_shashou_die()
		  self:wait_shashou_idle()
		print("�Ƿ����? ",self.is_giveup)
		if self.is_giveup==true then
		  self.danger=true
		  self:flee()
		else
		  self.on_attack=true
		  self:combat()
		  self:get_id(w[2])
		end
		 return
	  end
	  if string.find(l,"�㶨��һ��") then
	    --print("who:"," name:",w[4]," �书:",w[5]," ����:",w[6])
		 --world.AppendToNotepad (WorldName(),os.date().." �书:"..w[5].." ����:"..w[6].."\r\n")
		  CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��������:"..w[4].."�书:"..w[5].." ����:"..w[6], "red", "black") -- gray on white
		   	local ts={
	           task_name="����",
	           task_stepname="����2ս��",
	           task_step=6,
	           task_maxsteps=8,
	           task_location="",
	           task_description=w[4].." �书:"..w[5].." ����:"..w[6],
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
		--who:  name: ��é����  �书: ����  ����: �����ɵ���ɽ�ȷ�
		local skill= Trim(w[6])
		self.shashou_name=w[4]
		self.robber_skill=skill
		print("�Ƿ����? ",self.is_giveup)

		if self:deal_blacklist(skill) or self.is_giveup==true then
		   shutdown()
		   print("Σ�ռ�������!!!")
		   self.danger=true
		   self:flee()
		   return
		end
		self:wait_shashou_die()
		self:wait_shashou_idle()
		self.on_attack=true
		self:get_id(w[4])
		self:combat()
		return
	  end
	  wait.time(10)
   end)
end

function songxin:shield() --�����ڹ� �ص�����

end

function songxin:wait_shashou()
--[[�������Щ����ƺ����˸������ˣ�
����Լ�о�������Χ�˹�������!!!
���������������һ���´������ã��ű�͵��!
�����˵������С�ӣ��Թ԰��ܺ��������ɣ�������
�������������ɱ���㣡
��۾�����ض��������Ѱ����ѳ��л��ᡣ]]
   wait.make(function()
      local l,w=wait.regexp("^(> |)�������Щ����ƺ����˸������ˣ�$|^(> |)���������������һ���´������ã��ű�͵��!$",10)
	  if l==nil then
	     if self.check_idle==true then
		     world.Send("look")
		 end
	     self:wait_shashou()
		 return
	  end
	  --
	  if string.find(l,"�������Щ����ƺ����˸�������") or string.find(l,"���������������һ���´������ã��ű�͵��") then
	      shutdown()
	      self:UnderAttack()
		  return
	  end
	  wait.time(10)
   end)
end

local function giveup_Location(location)
   local pos=world.GetVariable("sx_giveup_pos") or ""
    local P={}
	if pos=="" then
	   return false
	end
	P=Split(pos,"|")
	for _,loc in ipairs(P) do
	  if string.find(location,loc) then
	     return true
	  end
	end
   return false
end

function songxin:delivery(location,npc)
   if zone_entry(location)==true or giveup_Location(location)==true then
      self:giveup()
      return
   end
  	local ts={
	           task_name="����",
	           task_stepname="��һ��Ͷ��",
	           task_step=2,
	           task_maxsteps=8,
	           task_location=location,
	           task_description="���Ÿ�"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
 --self:begin_transaction(function() self:delivery(location,npc) end)  --�ϵ�
 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."��������:��һ��Ͷ��"..npc.." "..location, "white", "black") -- gray on white
 local n,rooms=Where(location)
 if npc~="����" then  --���׸�ɱnpc
   rooms=depth_search(rooms,1)  --��Χ��ѯ
 end
   if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   self:shield()
	     local al
		  al=alias.new()
		  al:SetSearchRooms(rooms)
	   songxin.co=coroutine.create(function()
	    for index,r in ipairs(rooms) do
		  print("����1 ","Ŀ�귿��:",r)
          local w
		  w=walk.new()
		  local f1=function()
		     self:NextPoint()
		  end

		  al.do_jobing=true
		   ---ɱ��û������ǰ
		  if self.shashou_all_die==false then
		      local exps=tonumber(world.GetVariable("exps")) or 0 --��ȡ�����expֵ
		      if exps<=800000 then

			   al.compare=function(f)
			      print("����ֵ����800k,�ȴ�ɱ�ֳ���!,��ֱ�Ӵ���!")
			      local s1=function()
				    print("ԭ�صȴ�")
				    self:look()
				  end
				  local f1=function()
				     print("����")
				     self.is_giveup=true
				     self:giveup()
				   end
			     al:PreCompare(s1,f1)
			   end
		      end
		  al.yellboat_wait=function()
		     print("���ٴ���!")
             --print("�����ɴ�")
			 local f=function()
			   al:yellboat()
			 end
			 f_wait(f,1.2)
		  end

		  al.quyanziwu=function()
		      print("�ȴ�ɱ�ֳ���!")
              print("�����ɴ�")
		  end
		  al.qumr=function()
		      print("�ȴ�ɱ�ֳ���!")
              print("�����ɴ�")
		  end
		  al.zuomufa=function()
		       print("�ȴ�ɱ�ֳ���!")
			   print("�����ɴ�")
		  end
		  al.gudi_gudishuitan=function()
		     print("�ȴ�ɱ�ֳ���!")
			  -- print("�����ɴ�")
		  end
		 end
         ---ɱ��û������ǰ ����
		  al.maze_done=function()
			 print("�����Թ����� ")
			 self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.break_in_failure=function()
		      self:giveup()
		  end
		  al.huigong=function()
		     self:NextPoint()
		  end
          al.noway=function()
		     self:NextPoint()
		  end
		  w.user_alias=al
		  w.noway=function()
		    self:NextPoint()
		  end
		  w.walkover=function()
		     --local f1=function() self:NextPoint() end
		     self:checkNPC(npc,r,f1)
		  end
		  self:auto_pfm()
		  self:wait_shashou()
		  self.check_idle=false
		  self.target_npc=npc
		  self.target_roomno=r
		  if index==1 then
		    w.current_roomno=506
		  end
		  if r>0 then
		     w:go(r)
		     coroutine.yield()
		  end
	    end
		print("û���ҵ�npc!!")
		self:giveup()
	   end)
	   self:NextPoint()
	 end
	 b:check()
	else
	  print("û��Ŀ��")
	  self:giveup()
	end
end

function songxin:auto_escape()
  wait.make(function()
	   local l,w=wait.regexp("^(> |)�趨����������lookway \\= \\\"YES\\\"",5)
	   if l==nil then
	      self:auto_escape()
		  return
	   end
	   if string.find(l,"�趨����������lookway") then
	       self:lookway()
		  return
	   end
  end)
end

function songxin:lookway()
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("Ѱ�ҳ���")
     local dx=_R.get_all_exits()
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
	 if _R.roomname=="ϴ��ر�" then
	    world.Send("alias pfm "..run_dx..";set lookway")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set lookway")
	 end
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
	 self:auto_escape()
   end
   _R:CatchStart()
end

function songxin:look()
     _R=Room.new()
        _R.CatchEnd=function()
          local count,roomno=Locate(_R)
		  print("����ս�������:",roomno[1])
		   _G["fight_Roomno"]=roomno[1]
		  if roomno[1]==46 then
		     world.Send("west")
			 world.Send("west")
			  _G["fight_Roomno"]=47
		  end
		  f=function()
	         self:look()
	      end
		  f_wait(f,10)
	    end
	_R:CatchStart()
end

function songxin:recover()
     --ս��ģ�� ��ʼ�Ļ� ��ִ��
	 if table.getn(self.shashou_list)>0 or self.on_attack==true then
	    print("����ս���У�ֹͣ����")
	    return
	 end

    -- self:begin_transaction(function() self:recover() end)  --�ϵ�
	world.Send("yun recover")
	world.Send("yun refresh")
    local h
	h=hp.new()
	h.checkover=function()
	    if h.qi_percent<100 and h.qi_percent>=80 and h.neili>=h.max_neili*0.9 then --������
		    print("��ͨ����")
            local rc=heal.new()
			rc.hudiegu=function()
			  rc:heal(false,true)
			end
			--rc.saferoom=505
			rc.heal_ok=function()
			   self:recover()
			end
			rc:heal(true,false)
		elseif h.qi_percent<80 or h.neili<=h.max_neili*0.5 then
		    print("����̫�٣�������̫���أ�����job")
		    world.Send("no")
			world.DeleteTrigger("sx")
			shutdown()
		    local b
	         b=busy.new()
	         b.interval=0.3
	         b.Next=function()
	           self:jobDone()
	         end
	         b:check()
		elseif h.neili>h.max_neili*0.5 then
		    local x
			x=xiulian.new()
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
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			      if table.getn(self.shashou_list)>0 or self.on_attack==true then
	                print("����ս����")
	                return
	              end

			      print("��ʼ�����ȴ�ɱ�֣���")
				  self:shield()
				  self:look()
				  --self:NextPoint()
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
		     if table.getn(self.shashou_list)>0 or self.on_attack==true then
				print("����ս����")
				return
			 end
		     print("״̬����")
		     self:NextPoint()
		end
	end
	h:check()
end

function songxin:deliveryAgain(location,npc)
	local ts={
		task_name="����",
		task_stepname="������2�ָ�",
		task_step=5,
		task_maxsteps=8,
		task_location=location,
		task_description="���Ÿ�"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   if zone_entry(location)==true then
	  print("�޷�ǰ��������")
	  shutdown()
	  world.DeleteTrigger("sx")
	  world.Send("no")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:jobDone()
	  end
	  b:check()
      return
   end

  self._id="" --��ʼ��
  self.shashou_list={}
  self.is_giveup=false
  self.on_attack=false
  self.check_idle=false
  print("location:",location)
 local n,rooms=Where(location)
 --if location=="���ݳǱ����" or location=="��ɽ���ֽ���Ժ" then
  -- if range~=nil then
	 rooms=depth_search(rooms,6)  --��Χ��ѯ
  -- end
 --end
   if n>0 then

	   --print("ץȡ")
	   --��Ѫ�ָ� �����ָ�
	    --self:shield()--������
		self:auto_pfm()
		self:wait_shashou()
		self:lookway()
		self.target_npc=npc
		self.target_roomno=-99
		local f1=function()
		    self:NextPoint()
		end
	   songxin.co=coroutine.create(function()
	       	local ts={
	           task_name="����",
	           task_stepname="�ڶ���Ͷ��",
	           task_step=7,
	           task_maxsteps=8,
	           task_location=location,
	           task_description="���Ÿ�"..npc,
	        }
	       local st=status_win.new()
		   st:init(nil,nil,ts)
	       st:task_draw_win()
           self.status="����2"
		  local al
		  al=alias.new()
		  al:SetSearchRooms(rooms)
	    for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  al.do_jobing=true
		  print("����2 ","�����:",r)
		   --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:giveup()
		  end
		 --[[ al.out_songlin=function()
			   self.NextPoint=function()
				  print("���ָ̻�")
				  coroutine.resume(songxin.co)
			   end
			   al:finish()
		  end
		  al.songlin_check=function()
	         -- self.NextPoint=function() al:NextPoint() end
			  local f1=function()
			     al:NextPoint()
			  end
			  self:checkNPC(npc,1764,f1)
		  end]]
          al.fengyun=function()
             self:NextPoint()
          end
          al.tiandi=function()
            self:NextPoint()
		  end
          al.longhu=function()
             self:NextPoint()
          end
		  al.maze_done=function()
		       print("�����Թ�����")

		     --[[local f2=function()
				coroutine.resume(alias.circle_co)
			 end]]
			 self:checkNPC(npc,nil,al.maze_step)
		  end
		  al.noway=function()
		     self:NextPoint()
		  end
		  w.user_alias=al
		  w.noway=function()
		     self:NextPoint()
			 --self:giveup()
		  end
		  w.walkover=function()
		    local f1=function()
			  self:NextPoint()
			end
		    self:checkNPC(npc,r,f1)
		  end
		  print("��һ�������:",r)
		  self.target_roomno=r
		  if r~=-1 and r~=0 then
		    w:go(r)
		    coroutine.yield()
		  end
	    end
		print("û���ҵ�npc!!")
		self:giveup()
	   end)
	else
	  print("û��Ŀ��,����")
	  shutdown()
	  world.Send("no")
	  world.DeleteTrigger("sx")
	  local b
	  b=busy.new()
	  b.interval=0.3
	  b.Next=function()
	    self:jobDone()
	  end
	  b:check()
	end
end

function songxin:liaoshang_fail()
end
local heal_ok=false
-- ��������
function songxin:full()
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
			   print("sx ����fail")
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
			rc.saferoom=505
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
		         w:go(505)
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
--
function songxin:Status_Check()
  	local ts={
	           task_name="����",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=8,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --��ʼ��
	  self.shashou_list={}
	  self._id=""
	  self.target_roomno=""
	  self.target_npc=""
	  self.is_end=false
	  self.is_giveup=false
	  self.danger=false
	  self.on_attack=false
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

function songxin:jobDone()  --�ص�����
end

function songxin:test_combat()
end

function songxin:wait_shashou_die()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",5)
	 if l==nil then
	    self:wait_shashou_die()
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
	    print(self.guard_name,w[2])
		for pos,item in ipairs(self.shashou_list) do
		   local name=item.shashou_name
		   if string.find(w[2],name) then
		      table.remove(self.shashou_list,pos)
			  print(table.getn(self.shashou_list))
			  -- ����
			  if table.getn(self.shashou_list)>0 then
			    self:sure_shashou()
			  else
			    self.on_attack=false
			    print("�ȴ�,����ս���Ƿ������")
				self:test_combat()
			    --self:combat_end()
              end
			  break
		   end
		end
		self:wait_shashou_die()
	    return
	 end
	 wait.time(5)
   end)
end
--�������־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��

function songxin:auto_pfm()

end

function songxin:kill_shashou(name,id)
  self:auto_pfm()
  world.Send("kill "..id)

  wait.make(function()
    --�������ʸ�����ɱ���㣡

    local l,w=wait.regexp("^(> |)������"..name.."��ɱ���㣡$|^(> |)���ͣ����ͣ�$|^(> |)����û������ˡ�$|^(> |)�����"..name.."���һ��.*",5)
	if l==nil then
	   self:kill_shashou(name,id)
	   return
	end
	if string.find(l,"����û�������") then
	   self:lookCorpse()
	   return
	end
	if string.find(l,name) or string.find(l,"���ͣ�����") then
	   print(name," kill ok")
	   return
	end
    wait.time(5)
  end)
end

function songxin:get_shashou_id(id) --�ص�����

end

function songxin:wait_shashou_idle()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��$",5)
	 if l==nil then
	    self:wait_shashou_idle()
	    return
	 end
	 if string.find(l,"���ڵ��ϻ��˹�ȥ") then
	    --print(self.guard_name,w[2])
	    for pos,item in ipairs(self.shashou_list) do
		   local id=item.shashou_id
		   local name=item.shashou_name
		   if string.find(w[2],name) then
		      self:kill_shashou(name,id)
			  break
		   end
		end
		self:wait_shashou_idle()
	    return
	 end
	 wait.time(5)
   end)
end


function songxin:liuhe()
--[[(*){����Ľ��|��ɽ��|����}�ĸ��֣���Ϊ�ó�(*)�Ĺ���
set ���Ͼ� ����

^��Զ������Ķ�������˵���������ɵ�������������������(*){������|������}�ĸ��֣���Ϊ�ó�(*)�Ĺ���
set ���Ͼ� ����
^��Զ������Ķ�������˵���������ɵ�������������������(*){���ư�|������|������}�ĸ��֣���Ϊ�ó�(*)�Ĺ���
set ���Ͼ� ����
^��Զ������Ķ�������˵���������ɵ�������������������(*){������|ؤ��|�䵱��}�ĸ��֣���Ϊ�ó�(*)�Ĺ���
set ���Ͼ� �귭
^��Զ������Ķ�������˵���������ɵ�������������������(*){������|��ɽ��|������|�һ���}�ĸ��֣���Ϊ�ó�(*)�Ĺ���
set ���Ͼ� ����
^��Զ������Ķ�������˵���������ɵ�������������������(*){��Ĺ��|��Ĺ��}�ĸ��֣���Ϊ�ó�(*)�Ĺ���
set ���Ͼ� ����]]
 if string.find(self.robber_skill,"����Ľ��") or string.find(self.robber_skill,"��ɽ��") or string.find(self.robber_skill,"����") then
    world.Send("set ���Ͼ� ����")
 elseif string.find(self.robber_skill,"������") or string.find(self.robber_skill,"������") then
    world.Send("set ���Ͼ� ����")
 elseif string.find(self.robber_skill,"���ư�") or string.find(self.robber_skill,"������") or string.find(self.robber_skill,"������") then
    world.Send("set ���Ͼ� ����")
 elseif string.find(self.robber_skill,"������") or string.find(self.robber_skill,"ؤ��") or string.find(self.robber_skill,"�䵱��") then
   world.Send("set ���Ͼ� �귭")
 elseif string.find(self.robber_skill,"������") or string.find(self.robber_skill,"��ɽ��") or string.find(self.robber_skill,"������") or string.find(self.robber_skill,"�һ���") then
   world.Send("set ���Ͼ� ����")
 elseif string.find(self.robber_skill,"��Ĺ��") then
   world.Send("set ���Ͼ� ����")
 else
    world.Send("set ���Ͼ� ����")
 end
end

