require "wait"
--�㡸ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�
--��һʱ�벻��ʮ������������ʲô�ô��������ְ��������ˡ�
--������� �Զ�
local threads={} --ȫ�ֽ��̼��ӱ�
local dangerous_Man={} --Σ������
local dangerous_man_list={} --Σ������
local clock_out_time=""
local clock_in_time=""
local wdj_in_time=""
local wdj_refresh_time=""
local wdj_give_time=""
local month_expire=""
local marks_bed=""
local index
for index=1,20,1 do
   dangerous_Man[index]=""

end
--���ʣ��ʱ�䣺��ʮ�����Сʱ��ʮ������ʮ���롣
--[[��ʦ�߾���ȭ��ҧ���гݵظߺ������򵹡�ĳĳĳ������
��ʦ˵���������Ѿ��ۼ�ǩ��һ���ˣ������ȶһ�����Ʒ�ɣ���]]
function clock_out(callback)
  wait.make(function()
     local l,w=wait.regexp("^(> |)��ʦ˵��������ϲ�㱾��ǩ���򿨳ɹ�!��$|^(> |)��ʦ˵��������24Сʱ��ſɼ���ǩ������$|^(> |)��ʦ˵���������Ѿ��ۼ�ǩ��һ���ˣ������ȶһ�����Ʒ�ɣ���$",5)
	 if l==nil then
		get_clock_time() --���ʱ��
        callback()
	    return
	 end
	 if string.find(l,"��24Сʱ��ſɼ���ǩ��") then
		get_clock_time() --���ʱ��
	    callback()
	    return
	 end
	 if string.find(l,"��ϲ�㱾��ǩ���򿨳ɹ�") or string.find(l,"�����ȶһ�����Ʒ") then
	     local d=os.time()
	     world.Send("set clock_out "..d)
	     get_clock_time() --���ʱ��
	     local b=busy.new()
	     b.Next=function()
	      world.Send("ask wizard about ǩ���һ�") --ask ˫������ ask ����η��
		  wait.time(3)
		  world.Send("ask wizard about ˫������")
		  wait.time(3)
		  world.Send("ask wizard about ����η��")
          --�ڼ��ջ���ʱ����
		  local b2=busy.new()
		  b2.interval=0.5
		  b2.Next=function()
		    callback()
		  end
		  b2:check()
		end
        b:check()
        --world.Send("ask wizard about ˫������")
        --world.Send("ask wizard about ����η��")
	    return
	 end
  end)
end
--���ʣ��ʱ�䣺��ʮ�����Сʱ��ʮ������ʮ���롣
function ConvertSec(n)
   local D={}
   D=Split(n,"��")
   local day=0

   if D[2]==nil then
      day="��"
   else
      day=D[1]
	  n=D[2]
   end
   local hour=0
   D=Split(n,"Сʱ")
   if D[2]==nil then
      hour="��"
   else
      hour=D[1]
	  n=D[2]
   end
   local minute=0
    D=Split(n,"��")
   if D[2]==nil then
      minute="��"
   else
      minute=D[1]
	  n=D[2]
   end
   local sec=0
     D=Split(n,"��")
   if D[2]==nil then
      sec="��"
   else
      sec=D[1]
	  n=D[2]
   end
    --print(day,"��")
	day=ChineseNum(day)
    --print(hour,"ʱ")
	hour=ChineseNum(hour)
	--print(minute,"��")
	minute=ChineseNum(minute)
	--print(sec,"��")
	sec=ChineseNum(sec)
	local num=0
	num=day*24*3600+hour*3600+minute*60+sec
	return num
end

function clock_time()
--clock in
--clock out
--���ʣ��ʱ�䣺��ʮ�����Сʱ��ʮ������ʮ���롣
--���ʣ��ʱ�䣺��ʮ�룬�뼰ʱ���ѡ�
--���ʣ��ʱ�䣺ʮ��Сʱ��ʮ����ʮ�룬�뼰ʱ���ѡ�
  wait.make(function()
	 local l,w=wait.regexp("^clock_in(.*)$|^clock_out(.*)$|^wdj_in(.*)$|^wdj_refresh(.*)$|^wdj_give(.*)$|^(> |)���ʣ��ʱ�䣺(.*)���뼰ʱ���ѡ�$|^(> |)���ʣ��ʱ�䣺(.*)��$|^(> |)���Ĺ���Ѿ����ڣ�ϵͳ�Ѿ��Զ�ȡ�����Ĺ����$|^(> |)���ϵͳ��ʾ�����Ĺ����Ч���Ѿ����ڣ��뼰ʱ���ѡ�$",5)  --�嶾��ʱ�� ��ʱ��
	 if l==nil then

	     return
	 end
	 if string.find(l,"clock_in") then
	     clock_in_time=Trim(w[1])
		 local t1=os.time()
		 print(os.difftime(t1,clock_in_time),":��","ʱ����")
		 clock_time()
		return
	 end
	 if string.find(l,"clock_out") then
	     clock_out_time=Trim(w[2])
		local t1=os.time()
		 print(os.difftime(t1,clock_out_time),":��","ʱ����")
		 clock_time()
	    return
	 end
	 if string.find(l,"wdj_in") then
		sj.wdj_in_time=Trim(w[3])
		--print(sj.wdj_in_time)
		local t1=os.time()
		 print(os.difftime(t1,sj.wdj_in_time),":��"," �嶾��ʱ����")
		 clock_time()
		 return
	 end
	 if string.find(l,"wdj_refresh") then
		 sj.wdj_refresh_time=Trim(w[4])
		--print(sj.wdj_in_time)
		 local t1=os.time()
		 print(os.difftime(t1,sj.wdj_refresh_time),":��"," ֩��ˢ�¼��")
		 clock_time()
		 return
	 end
	 if string.find(l,"wdj_give") then
		 sj.wdj_give_time=Trim(w[5])
		--print(sj.wdj_in_time)
		 local t1=os.time()
		 print(os.difftime(t1,sj.wdj_give_time),":��"," ʵ��ŵ��ʱ����")
		 clock_time()
		 return
	 end
	  if string.find(l,"�뼰ʱ����") then
	      local month_vip=Trim(w[7])
		 local t1=os.time()
		 print(month_vip," vip ʣ��ʱ��2")
		 local Phase=ConvertSec(month_vip)
		 sj.month_expire=t1+Phase

	    return
	 end
	 if string.find(l,"���ʣ��ʱ��") then
	     local month_vip=Trim(w[9])
		 local t1=os.time()
		 print(month_vip," vip ʣ��ʱ��")
		 local Phase=ConvertSec(month_vip)
		 sj.month_expire=t1+Phase
	    return
	 end
	 if string.find(l,"���Ĺ���Ѿ����ڣ�ϵͳ�Ѿ��Զ�ȡ�����Ĺ��") or string.find(l,"���Ĺ����Ч���Ѿ�����") then

	     sj.month_expire=t1-10
	    return
	 end

  end)
end

function get_clock_time()
  if IsConnected()==true then  --
     world.Send("set")
	 world.Send("time")
	 world.Send("jifa")
	 clock_time()
  else
	  world.AddTimer("clock", 0, 0, 5, "get_clock_time()", timer_flag.Enabled + timer_flag.OneShot, "")
	  world.SetTimerOption ("clock", "send_to", 12)
  end

end
get_clock_time() --����mud �Զ���ȡsetֵ

function ask_month_vip(callback)
   local w=walk.new()
   w.walkover=function()
      world.Send("ask wizard about �¿����")

	  get_clock_time()
	  local b=busy.new()

	  b.Next=function()
	     callback()
	  end
	  b:check()

   end
   w:go(54)
end

function check_clock_time(f)
  --print("���ǩ��ʱ��")
  local exps=world.GetVariable("exps") or "0"
  --[[if tonumber(exps)<500000 then
	  f() --���� 500k����
     return
  end]]
   --print("���ǩ��ʱ��2")
  if clock_in_time=="" and clock_out_time=="" then
      clock_in(f)
      return
  end

  if tonumber(exps)<15000000 then
     print("���ǩ��ʱ��3")
    local t1=os.time()
    if clock_in_time=="" then
	  clock_in(f)
	  return
    end
   --print("���ǩ��ʱ��4")
     local int1= os.difftime(t1,clock_in_time)
     if clock_out_time=="" then --��֪�����ǩ��ʱ��,ÿ��2Сʱ���һ��
	  local int= os.difftime(t1,clock_in_time)
	   print(int1,"ֵ")
	   if int1>=86400 then
	    clock_in(f)
	   else
	     f()
	   end
	  return
    end
  end
   --print("���ǩ��ʱ��5")
  --[[ local int2= os.difftime(t1,clock_out_time)
   if int2>(3600*24) and int1>7200 then
	  clock_in(f)
	  return
   end]]
   --print("ֱ��ִ��")
   f() --ֱ��ִ��
end

function clock_in(callback)
   local w=walk.new()
  -- ������ʦ�����йء��򿨡�����Ϣ��
  --��ʦ����һ�ţ��ƺ����߲�Ӭ��
  --��ʦ˵��������24Сʱ��ſɼ���ǩ������
   w.walkover=function()
      world.Send("ask wei about ���ֽ���")
	  wait.make(function()
		  local l,w=wait.regexp("^(> |)�������������йء����ֽ���������Ϣ��$",5)
		 if l==nil then
            clock_in(callback)
		    return
		 end
		 if string.find(l,"���ֽ���") then
		    local d=os.time()
            world.Send("set clock_in "..d)
			--local b=busy.new()
			--b.Next=function()
			clock_out(callback)
			--end
			--b:check()
		   return
		end
	  end)
   end
   w:go(155)
end

function clock_in2(callback)
   local w=walk.new()
  -- ������ʦ�����йء��򿨡�����Ϣ��
  --��ʦ����һ�ţ��ƺ����߲�Ӭ��
  --��ʦ˵��������24Сʱ��ſɼ���ǩ������
   w.walkover=function()
      world.Send("ask wei about ���ֽ���")
	  wait.make(function()
	     local l,w=wait.regexp("^(> |)�������������йء����ֽ���������Ϣ��$",5)
		 if l==nil then
            clock_in(callback)
		    return
		 end
		 if string.find(l,"���ֽ���") then
		    local d=os.time()
            world.Send("set clock_in "..d)
			--local b=busy.new()
			--b.Next=function()
			clock_out(callback)
			--end
			--b:check()
		   return
		end
	  end)
   end
   w:go(155)
end

function is_dangerous_man(name)
   print("is_dangerous_man:",name)
   local exps=tonumber(world.GetVariable("exps")) or 0
   if name=="����" and exps<=800000  then
     print("��������")
     return true
   end
   for i=20,1,-1 do
     --print(dangerous_Man[i])

     if dangerous_Man[i]==name then
         print(i,":",dangerous_Man[i]," ?> ",name)
	    return true
	 end
   end
   return false
end

function dangerous_man_list_add(name)

  print("Σ����������:",name)
   table.insert(dangerous_man_list,name)
end

function dangerous_man_list_clear(name)
  if name==nil then
     dangerous_man_list={}
  else
     for i,n in ipairs(dangerous_man_list) do
	     if n==name then
	        table.remove(dangerous_man_list,i)
		 end
     end
  end
end

function danerous_man_list_push()
  for _,l in ipairs(dangerous_man_list) do
    for i=20,2,-1 do  --����20���ռ�
     dangerous_Man[i]=dangerous_Man[i-1]
    end
	table.insert(dangerous_Man,1,l)
  end
  dangerous_man_list={}
end

function thread_monitor(thread_name,thread_function,arg) --�����ж�
     --print(thread_function)

     local str=os.date().." "..thread_name.." ����:"..tostring(thread_function)
	  str=str.." ����:"
	  if arg~=nil then
	    for _,p in ipairs(arg) do
        str=str..tostring(p).." "
        end
	  end
	  str=str.."\r\n"
	 world.AppendToNotepad (WorldName().."_thread:",str)
     local thread={}
	 thread.name=thread_name
	 thread.deal_function=thread_function
	 thread.arg=arg
	 thread.time=os.time()
	 --table.insert(threads,thread)
end
--ɾ�����д���
 local windows = WindowList()
  if windows then
   for _, P_win in ipairs (windows) do
       WindowDelete(P_win)  -- delete it
   end
  end
--���в�����¼���
--[[
local plugin=GetPluginList() or {}
for k, v in pairs (plugin) do
  print("�������")
  Note (v, " = ", GetPluginInfo(v, 1))
  ReloadPlugin(v)
end]]

local function world_init()
end

world.SetOption("wrap_column",500)  --�п��
world.SetOption("enable_command_stack",1) --mcl ����

world.AddTriggerEx ("idle", "^(> |)�Բ������Ѿ���������.*�����ˣ����´�������$", "sj.log_catch(WorldName()..'������¼',900)", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
world.SetTriggerOption ("idle", "repeat","1")
--world.AddTriggerEx ("longtime", "^(> |)���Ȼ���÷������£��������˳���Ϣһ���ˡ�$", "sj.longtime()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)

--world.AddTriggerEx ("hungry", "^(> |)ͻȻһ�󡰹�������������ԭ������Ķ����ڽ��ˡ�$", "sj.hungry()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)

--world.AddTriggerEx ("thirsty", "^(> |)����������ѵ��촽�������Ǻܾ�û�к�ˮ�ˡ�$", "sj.thirsty()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
--world.AddTriggerEx ("thirsty2", "^(> |)��ʵ���ð���ǣ�ȫ��������$", "sj.thirsty()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)

world.AddTriggerEx ("dangerous", "^(> |)������(.*)��ɱ���㣡$", "sj.danger('%2')", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)

world.AddTriggerEx("afk","^(> |)�趨����������afk \\= \\\"YES\\\"$","sj.afk()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 10)

world.AddTriggerEx ("die", "^(> |)�㡸ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$", "shutdown()\nSetVariable(\"newdie\",\"true\")\nsj.log_catch(WorldName()..'������¼',600)", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
world.AddTriggerEx("reconnect","^(> |)����������ϡ�$","update_data()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)
world.AddTriggerEx("reconnect2","^(> |)��Ŀǰ��Ȩ���ǣ�\\\(player\\\)$","print('�ر����д�����!')\nDeleteVariable(\"newdie\")\nshutdown()\nprocess.check()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)
local player_name=world.GetVariable("player_name") or ""
world.DeleteTrigger("xxdf") --ɾ����xxdf ������ ������mush �ͻ���bug
--world.AddTriggerEx("xxdf","^(> |)����Ⱥ˵������"..player_name..".*��˵ħ�̽��������ں����������ף���ȥ����ɱ�ˣ��Ҿ��������������ɡ���$"," world.Send(\"nick ���Ǵ�\")\nprint(utils.msgbox (\"��ʼ�⻯���󷨣�������\", \"Warning!\", \"ok\", \"!\", 1))", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)

--world.AddTriggerEx ("page", "^\\=\\= ��ʣ.*�� \\=\\= \\(ENTER ������һҳ��q �뿪��b ǰһҳ\\).*$", "world.Send('')", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)

world.AddTriggerEx ("bug1", "^(> |)�㻹���˽��꽭����Թ��˵�ɡ�$", "sj.log_catch(WorldName()..'bug��¼��',800)\nEnableTrigger('bug1',false)", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
local function  longtime()
     wait.make(function()
	    shutdown()
	    world.Send("halt")
		world.Send("quit")
		local l,w=wait.regexp("�����˳���Ϸ����",1.5)
		if l==nil then
		    local _R
			_R=Room.new()
			_R.CatchEnd=function()
				local count,roomno=Locate()
				print(roomno[1])
				local r=nearest_room(roomno)
				local w=walk.new()
				w.walkover=function()
				end
				w:go(r)
			end
			_R:CatchStart()
		   sj.longtime()
		   return
		end
		if string.find(l,"�����˳���Ϸ") then
            world.AddTimer("world", 4, 0, 0, "sj.World_Opening()", timer_flag.Enabled + timer_flag.ActiveWhenClosed , "")
            world.SetTimerOption ("world", "send_to", 12)
			return
		end
		wait.time(5)
     end)
end

local function World_Opening()
 --print("��ʼ��������")
 if IsConnected()==false then
    --ResetIP()
    --world.DoCommand("Disconnect")
	--world.DoCommand("Connect")
	set_WorldAddress()--����ip
	world.Connect()
	wait.make(function()
	  local l,w=wait.regexp("^(> |)��Ŀǰ��Ȩ���ǣ�\\(player\\)",5)
	  if l==nil then
	     sj.World_Opening()
		 return
	  end
	  if string.find(l,"��Ŀǰ��Ȩ����") then
		world.DeleteTimer("world")
	    local relogin_Do=world.GetVariable("relogin_Do") or ""
		if relogin_Do~="" then
		   world.Execute(relogin_Do)
		end
	  --���µ�¼
	     shutdown()
	     sj.World_Init()
		 return
	  end
	  --wait.time(5)
	end)
  else
  --�����˳���Ϸ����
  --��Ŀǰ��Ȩ���ǣ�(player)
    --shutdown()
    --sj.World_Init()
  end
end

local function hungry()
     shutdown()
      print("eat")
		      w=walk.new()
		      w.walkover=function()
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     --world.Execute("ask xiao tong about ʳ��")
				 local f
				 f=function()
				   local b1=busy.new()
				   b1.Next=function()
				       world.Execute("sit chair;knock table;get mi tao;get cha;drink cha;drink cha;drink cha;eat mi tao;eat mi tao;eat mi tao;drop mi tao;drop tea")
					   sj.World_Init()
				   end
				   b1:check()
				 end
				 f_wait(f,1.5)
			    end
			    b:check()
		       end
			   w:go(1960) --299 ask xiao tong about ʳ�� ask xiao tong about ��
end

local function thirsty()
    shutdown()
     print("drink")
			  local w
		      w=walk.new()
		      w.walkover=function()
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			    -- world.Send("ask xiao tong about ��")
				 local f
				 f=function()
				   local b1=busy.new()
				   b1.Next=function()
				      world.Execute("sit chair;knock table;get mi tao;get cha;drink cha;drink cha;drink cha;eat mi tao;eat mi tao;eat mi tao;drop mi tao;drop tea")

				      --world.Execute("get cha;drink cha;drink cha;drink cha;drop cha")
					  sj.World_Init()
				   end
				   b1:check()

				 end
				 f_wait(f,1.5)
			   end
			   b:check()
		      end
			  w:go(1960) --299 ask xiao tong about ʳ�� ask xiao tong about ��
end

local function quit(reconnect)

  	--[[   wait.make(function()
	    shutdown()
	    world.Execute("halt;halt;halt;quit;yun qi;yun jingli")
		local l,w=wait.regexp("^(> |)���齣�����������ܹ�����.*",1)
		if l==nil then
		    quit()
		   return
		end
		if string.find(l,"�������ܹ�����") then
		    shutdown()
			if reconnect==true then
			   return
			end
            world.AddTimer("world", 0, 5, 0, "sj.World_Opening()", timer_flag.Enabled + timer_flag.OneShot + timer_flag.ActiveWhenClosed , "")
            world.SetTimerOption ("world", "send_to", 12)
			return
		end
		wait.time(5)
     end)]]

	 if world.IsConnected()==true then
	     print(os.date()," ��ȫ�����˳���")
	     shutdown()
		 world.Execute("halt;halt;halt;quit;yun qi;yun jingli")
		 local f=function()
		    quit(reconnect)
		 end
		 f_wait(f,2,true)
	 else
		if reconnect==true then  --����Ҫ��������
		     print("����Ҫ��������")
			return
		end
		print("8���Ӻ�����mud������",os.date())
		world.AddTimer("world", 0, 8, 0, "sj.World_Opening()", timer_flag.Enabled  + timer_flag.ActiveWhenClosed , "")
		world.SetTimerOption ("world", "send_to", 12)
		world.EnableTimer("world",true)
	 end
end

function retest()
quit()
end

function safe_room(callback)

 --�ܳ�����
   local w=walk.new()
   w.walkover=function()
      world.Send("look")
	  world.Send("set action leave")
      local l,w=wait.regexp(".*������.*|^(> |)�趨����������action \\= \\\"leave\\\".*",3)
	  if l==nil then
	     safe_room()
		 return
	  end
	  if string.find(l,"�趨����������action") then
	     safe_room()
	     return
	  end
	  if string.find(l,"������") then
	      world.Send("unset wimpy")
	     f_wait(callback,5)
		 return
	  end
   end

	 world.Send("alias pfm halt;e;w;n;s;ne;nw;se;sw;up;down;enter;out;nd;nu;sd;su")
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
   w:go(53)
end

local function danger(name)
   --print(name)
    sj.danger_name=name
	if is_dangerous_man(name)==true then
	     --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."�����˳�������NPC:"..name, "green", "black") -- yellow on white
		local w=walk.new()
		w.walkover=function()
		   w:go(53)
		end
        world.Send("unset wimpy")
		w:go(53)
       quit()
	else
	   print("����Σ��������:",name)
	   print("fpk"..name)
	   if name~="ѩ��" then
	      world.Send("set wimpy 100")
	   end
	end
end

local function afk()
   local afk_cmd=world.GetVariable("afk_cmd") or ""
   if afk_cmd~="" then
      world.DoAfterSpecial(0.1,afk_cmd,12)
   end


   --local pluginID=
   --CallPlugin("c69beec0439bf82c0c5b0785", "set_AFKTime", afk_sec)
end

function worker()
   world.AddTriggerEx ("Log1", "^(> |)(.*)\\((.*)\\)������Х��(.*)$", "sj.glog('%2','%3','%4')", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
      world.AddTriggerEx ("Log2", "^(> |)(.*)\\((.*)\\)�����㣺(.*)$", "sj.glog('%2','%3','%4')", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
end
worker()

function glog(name,id,info)
   wlog(name,id,info)
end
--------------------------------------------

--local onlinetime=0
--local spider_catched=false
--local eat_biyundan=false

--[[local function jiedu(f,sec)
    local f2=function()
	   shutdown()
	   sj.wdj_enter(f)
	end
    f_wait(f2,sec)
	local rc=heal.new()
	rc.saferoom=505
	rc.qudu_ok=function()
		sj.wdj_enter(f)
	end
	rc:qudu()

end


local function update_onlinetime()
    wait.make(function()
     world.Send("time")
     local l,w=wait.regexp("^(> |)���Ѿ���������(.*)��$",5)
	  if l==nil then
	      update_onlinetime()
	      return
	  end
	  if string.find(l,"���Ѿ���������") then
	     local playtime=w[2]
		 local hour=0
		 local minute=0
		 local second=0
		 local regexp={}
		 regexp=Split(playtime,"Сʱ")
		 if table.getn(regexp)>=2 then
		    hour=ChineseNum(regexp[1])
			playtime=regexp[2]
		 end
		 regexp=Split(playtime,"��")
       	 if table.getn(regexp)>=2 then
		    minute=ChineseNum(regexp[1])
          	playtime=regexp[2]
		 end
		 regexp=Split(playtime,"��")
		 if table.getn(regexp)>=2 then
		    second=ChineseNum(regexp[1])
		 end


		 sj.onlinetime=hour*3600+minute*60+second
		  print("����ʱ��:",sj.onlinetime)
		 sj.xp:check()
	     return
	  end
   end)
end--]]

local function close_triggerGroup()
    world.EnableTrigger("hungry",false)
	world.EnableTrigger("thirsty",false)
	world.EnableTrigger("thirsty2",false)
end

local function open_triggerGroup()
    world.EnableTrigger("hungry",true)
	world.EnableTrigger("thirsty",true)
	world.EnableTrigger("thirsty2",true)
end
local function log_catch(logname,line_count)
  local line, total_lines
  total_lines = GetLinesInBufferCount ()

--
--  Example showing the last 10 lines in the output buffer
--   Shown is text of line, date/time received, count of style runs
--
world.AppendToNotepad (logname,os.date()..": �¼���¼��:"..line_count.."������!!\r\n")
for line = total_lines - line_count, total_lines do
  --Note (GetLineInfo (line, 1))
  world.AppendToNotepad (logname,GetLineInfo (line, 1).."\r\n")
  --Note ("Received ", GetLineInfo (line, 9))
end
world.AppendToNotepad (logname,os.date()..": *************�ر�************\r\n")
end


------BackgroundPictures-------
BGpics = function()
  local  filter = { png="png�ļ�",bmp = "bmp�ļ�", ["*"] = "All files" }

   local filename = utils.filepicker ("ѡ�񱳾�ͼƬ",name, extension, filter, false)
   if filename~=nil then
      world.SetBackgroundImage (filename, 0)
   end
end --funtion

BGpics_del=function()
  world.SetBackgroundImage ("", 0)
end
--���ر���
--world.SetBackgroundImage (GetInfo (66).."��.png", 12)
-- play sound once only, full volume, centered, in buffer 1
--���ر�������
--PlaySound (1, GetInfo (66).."�ʺ��ǵ���.wav", false, 0, 0)


sj={
  longtime=longtime,
  World_Opening=World_Opening,
  World_Init=world_init,
  hungry=hungry,
  thirsty=thirsty,
  danger=danger,
  quit=quit,
  afk=afk,
  danger_name="",
  xp={},
  quit=quit,
  close_triggerGroup=close_triggerGroup,
  open_triggerGroup=open_triggerGroup,
  log_catch=log_catch,
  wdj_in_time=wdj_in_time, --��¼�������嶾��ʱ��
  wdj_refresh_time=wdj_refresh_time,
  wdj_give_time=wdj_give_time,
  marks_bed=marks_bed,--��Ĺ���񴲵�ʹ��ʱ��
  glog=glog,
  month_expire=month_expire,
}

function ColourNote (text)
  world.CallPlugin ("8f86e2da6eea3806f1836050", "colournote", text)
end

function Make_Log(id,text)
   world.AppendToNotepad (id,os.date()..":"..text.."\r\n")
end

 if not IsPluginInstalled("4e38a3aade8c0892c5f19e86") then
		LoadPlugin(GetInfo(60) .. "escape.xml")
 else
     UnloadPlugin("4e38a3aade8c0892c5f19e86")
 end
	--print("�����")
EnablePlugin("4e38a3aade8c0892c5f19e86", false)

--world.AddTriggerEx ("tj1", "^(> |)�㻺��������������ֱ���С���ˣ���\,�㰵����������̫���������־���ʹ�ĳ����뻯��$", "local taiji=world.GetVariable(\"taiji\") or 0\nif taiji==0 then Send(\"set taiji ��|��|��|��\") else Execute(\"set taiji ��|��|��|��;jiali 50\") end", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
--world.AddTriggerEx ("tj2", "^(> |)����һ��ʵ�������������Ϊ���������ڹ�.*$", "SetVariable(\"taijian\",1)\nExecute(\"set taiji ��|��|��|��;jiali 50\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "","", 12, 9999)
--world.AddTriggerEx ("tj3", "^(> |)�㡸̫������ʹ�꣬���鵤������չ����ˣ�$", "Execute(\"jiali 1;yun jingli;set taiji ��|��|��|��\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
--[[ask wizard about ǩ���һ�

--���ô���
world.AddTriggerEx ("pr1", "^(> |).*��.*���˹�����$", "", trigger_flag.RegularExpression + trigger_flag.OmitFromOutput + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
world.AddTriggerEx ("pr2", "^(> |).*��.*�뿪��$", "", trigger_flag.RegularExpression + trigger_flag.OmitFromOutput + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
--[[ask wizard about ǩ���һ�
�ڼ��ջ���ʱ����
world.Send("ask wizard about ˫������")
world.Send("ask wizard about ����η��")
����齱ͨ����Ʒ
�������С��ͨ��
ͨ����Ʒһ�㽱������ ���� ������ �ܿ� ���굤 ��Ӣ��]]
--[[> �㶪��һ��ľ����
�㶪��һ�����߽���
�㶪��һ���ۻơ�
�㶪��һ���ֵ���
�㶪��һ֧���ۡ�
�㶪��һ�������ӡ�
�㶪��һ�������赨ɢ��
�㶪��һ˫��ѥ��
��Ϊ������������ֵǮ���������ǲ�����ע�⵽���Ĵ��ڡ�
�㶪��һ����˿���ۡ�
��Ϊ������������ֵǮ���������ǲ�����ע�⵽���Ĵ��ڡ�]]
