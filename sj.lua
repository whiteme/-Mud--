require "wait"
--你「啪」的一声倒在地上，挣扎着抽动了几下就死了。
--你一时想不起十三龙象袈裟有什么用处，就随手把它丢掉了。
--发呆检测 自动
local threads={} --全局进程监视表
local dangerous_Man={} --危险人物
local dangerous_man_list={} --危险人物
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
--贵宾剩余时间：二十三天二小时二十六分五十七秒。
--[[巫师高举右拳，咬牙切齿地高呼：“打倒「某某某」！”
巫师说道：「你已经累计签到一周了，还是先兑换下礼品吧！」]]
function clock_out(callback)
  wait.make(function()
     local l,w=wait.regexp("^(> |)巫师说道：「恭喜你本次签到打卡成功!」$|^(> |)巫师说道：「你24小时后才可继续签到！」$|^(> |)巫师说道：「你已经累计签到一周了，还是先兑换下礼品吧！」$",5)
	 if l==nil then
		get_clock_time() --获得时间
        callback()
	    return
	 end
	 if string.find(l,"你24小时后才可继续签到") then
		get_clock_time() --获得时间
	    callback()
	    return
	 end
	 if string.find(l,"恭喜你本次签到打卡成功") or string.find(l,"还是先兑换下礼品") then
	     local d=os.time()
	     world.Send("set clock_out "..d)
	     get_clock_time() --获得时间
	     local b=busy.new()
	     b.Next=function()
	      world.Send("ask wizard about 签到兑换") --ask 双倍奖励 ask 悍不畏死
		  wait.time(3)
		  world.Send("ask wizard about 双倍奖励")
		  wait.time(3)
		  world.Send("ask wizard about 悍不畏死")
          --节假日还临时开放
		  local b2=busy.new()
		  b2.interval=0.5
		  b2.Next=function()
		    callback()
		  end
		  b2:check()
		end
        b:check()
        --world.Send("ask wizard about 双倍奖励")
        --world.Send("ask wizard about 悍不畏死")
	    return
	 end
  end)
end
--贵宾剩余时间：二十三天二小时二十六分五十七秒。
function ConvertSec(n)
   local D={}
   D=Split(n,"天")
   local day=0

   if D[2]==nil then
      day="零"
   else
      day=D[1]
	  n=D[2]
   end
   local hour=0
   D=Split(n,"小时")
   if D[2]==nil then
      hour="零"
   else
      hour=D[1]
	  n=D[2]
   end
   local minute=0
    D=Split(n,"分")
   if D[2]==nil then
      minute="零"
   else
      minute=D[1]
	  n=D[2]
   end
   local sec=0
     D=Split(n,"秒")
   if D[2]==nil then
      sec="零"
   else
      sec=D[1]
	  n=D[2]
   end
    --print(day,"日")
	day=ChineseNum(day)
    --print(hour,"时")
	hour=ChineseNum(hour)
	--print(minute,"分")
	minute=ChineseNum(minute)
	--print(sec,"秒")
	sec=ChineseNum(sec)
	local num=0
	num=day*24*3600+hour*3600+minute*60+sec
	return num
end

function clock_time()
--clock in
--clock out
--贵宾剩余时间：二十三天二小时二十六分五十七秒。
--贵宾剩余时间：三十秒，请及时续费。
--贵宾剩余时间：十七小时三十三分十秒，请及时续费。
  wait.make(function()
	 local l,w=wait.regexp("^clock_in(.*)$|^clock_out(.*)$|^wdj_in(.*)$|^wdj_refresh(.*)$|^wdj_give(.*)$|^(> |)贵宾剩余时间：(.*)，请及时续费。$|^(> |)贵宾剩余时间：(.*)。$|^(> |)您的贵宾已经到期，系统已经自动取消您的贵宾！$|^(> |)贵宾系统提示：您的贵宾有效期已经到期，请及时续费。$",5)  --五毒教时间 打卡时间
	 if l==nil then

	     return
	 end
	 if string.find(l,"clock_in") then
	     clock_in_time=Trim(w[1])
		 local t1=os.time()
		 print(os.difftime(t1,clock_in_time),":秒","时间间隔")
		 clock_time()
		return
	 end
	 if string.find(l,"clock_out") then
	     clock_out_time=Trim(w[2])
		local t1=os.time()
		 print(os.difftime(t1,clock_out_time),":秒","时间间隔")
		 clock_time()
	    return
	 end
	 if string.find(l,"wdj_in") then
		sj.wdj_in_time=Trim(w[3])
		--print(sj.wdj_in_time)
		local t1=os.time()
		 print(os.difftime(t1,sj.wdj_in_time),":秒"," 五毒教时间间隔")
		 clock_time()
		 return
	 end
	 if string.find(l,"wdj_refresh") then
		 sj.wdj_refresh_time=Trim(w[4])
		--print(sj.wdj_in_time)
		 local t1=os.time()
		 print(os.difftime(t1,sj.wdj_refresh_time),":秒"," 蜘蛛刷新间隔")
		 clock_time()
		 return
	 end
	 if string.find(l,"wdj_give") then
		 sj.wdj_give_time=Trim(w[5])
		--print(sj.wdj_in_time)
		 local t1=os.time()
		 print(os.difftime(t1,sj.wdj_give_time),":秒"," 实现诺言时间间隔")
		 clock_time()
		 return
	 end
	  if string.find(l,"请及时续费") then
	      local month_vip=Trim(w[7])
		 local t1=os.time()
		 print(month_vip," vip 剩余时间2")
		 local Phase=ConvertSec(month_vip)
		 sj.month_expire=t1+Phase

	    return
	 end
	 if string.find(l,"贵宾剩余时间") then
	     local month_vip=Trim(w[9])
		 local t1=os.time()
		 print(month_vip," vip 剩余时间")
		 local Phase=ConvertSec(month_vip)
		 sj.month_expire=t1+Phase
	    return
	 end
	 if string.find(l,"您的贵宾已经到期，系统已经自动取消您的贵宾") or string.find(l,"您的贵宾有效期已经到期") then

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
get_clock_time() --连接mud 自动获取set值

function ask_month_vip(callback)
   local w=walk.new()
   w.walkover=function()
      world.Send("ask wizard about 月卡贵宾")

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
  --print("检查签到时间")
  local exps=world.GetVariable("exps") or "0"
  --[[if tonumber(exps)<500000 then
	  f() --低于 500k不打卡
     return
  end]]
   --print("检查签到时间2")
  if clock_in_time=="" and clock_out_time=="" then
      clock_in(f)
      return
  end

  if tonumber(exps)<15000000 then
     print("检查签到时间3")
    local t1=os.time()
    if clock_in_time=="" then
	  clock_in(f)
	  return
    end
   --print("检查签到时间4")
     local int1= os.difftime(t1,clock_in_time)
     if clock_out_time=="" then --不知道最后签到时间,每个2小时检查一次
	  local int= os.difftime(t1,clock_in_time)
	   print(int1,"值")
	   if int1>=86400 then
	    clock_in(f)
	   else
	     f()
	   end
	  return
    end
  end
   --print("检查签到时间5")
  --[[ local int2= os.difftime(t1,clock_out_time)
   if int2>(3600*24) and int1>7200 then
	  clock_in(f)
	  return
   end]]
   --print("直接执行")
   f() --直接执行
end

function clock_in(callback)
   local w=walk.new()
  -- 你向巫师打听有关『打卡』的消息。
  --巫师飞起一脚，似乎在踢苍蝇。
  --巫师说道：「你24小时后才可继续签到！」
   w.walkover=function()
      world.Send("ask wei about 新手奖励")
	  wait.make(function()
		  local l,w=wait.regexp("^(> |)你向门卫打听有关『新手奖励』的消息。$",5)
		 if l==nil then
            clock_in(callback)
		    return
		 end
		 if string.find(l,"新手奖励") then
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
  -- 你向巫师打听有关『打卡』的消息。
  --巫师飞起一脚，似乎在踢苍蝇。
  --巫师说道：「你24小时后才可继续签到！」
   w.walkover=function()
      world.Send("ask wei about 新手奖励")
	  wait.make(function()
	     local l,w=wait.regexp("^(> |)你向门卫打听有关『新手奖励』的消息。$",5)
		 if l==nil then
            clock_in(callback)
		    return
		 end
		 if string.find(l,"新手奖励") then
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
   if name=="霍都" and exps<=800000  then
     print("启动保护")
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

  print("危险名单更新:",name)
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
    for i=20,2,-1 do  --开辟20个空间
     dangerous_Man[i]=dangerous_Man[i-1]
    end
	table.insert(dangerous_Man,1,l)
  end
  dangerous_man_list={}
end

function thread_monitor(thread_name,thread_function,arg) --发呆判断
     --print(thread_function)

     local str=os.date().." "..thread_name.." 函数:"..tostring(thread_function)
	  str=str.." 参数:"
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
--删除所有窗体
 local windows = WindowList()
  if windows then
   for _, P_win in ipairs (windows) do
       WindowDelete(P_win)  -- delete it
   end
  end
--所有插件重新加载
--[[
local plugin=GetPluginList() or {}
for k, v in pairs (plugin) do
  print("插件加载")
  Note (v, " = ", GetPluginInfo(v, 1))
  ReloadPlugin(v)
end]]

local function world_init()
end

world.SetOption("wrap_column",500)  --列宽度
world.SetOption("enable_command_stack",1) --mcl 设置

world.AddTriggerEx ("idle", "^(> |)对不起，您已经发呆超过.*分钟了，请下次再来。$", "sj.log_catch(WorldName()..'发呆记录',900)", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
world.SetTriggerOption ("idle", "repeat","1")
--world.AddTriggerEx ("longtime", "^(> |)你忽然觉得烦闷欲吐，看来该退出休息一会了。$", "sj.longtime()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)

--world.AddTriggerEx ("hungry", "^(> |)突然一阵“咕咕”声传来，原来是你的肚子在叫了。$", "sj.hungry()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)

--world.AddTriggerEx ("thirsty", "^(> |)你舔了舔干裂的嘴唇，看来是很久没有喝水了。$", "sj.thirsty()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
--world.AddTriggerEx ("thirsty2", "^(> |)你渴得眼冒金星，全身无力。$", "sj.thirsty()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)

world.AddTriggerEx ("dangerous", "^(> |)看起来(.*)想杀死你！$", "sj.danger('%2')", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)

world.AddTriggerEx("afk","^(> |)设定环境变量：afk \\= \\\"YES\\\"$","sj.afk()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 10)

world.AddTriggerEx ("die", "^(> |)你「啪」的一声倒在地上，挣扎着抽动了几下就死了。$", "shutdown()\nSetVariable(\"newdie\",\"true\")\nsj.log_catch(WorldName()..'死亡记录',600)", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
world.AddTriggerEx("reconnect","^(> |)重新连线完毕。$","update_data()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)
world.AddTriggerEx("reconnect2","^(> |)您目前的权限是：\\\(player\\\)$","print('关闭所有触发器!')\nDeleteVariable(\"newdie\")\nshutdown()\nprocess.check()", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)
local player_name=world.GetVariable("player_name") or ""
world.DeleteTrigger("xxdf") --删除掉xxdf 触发器 会引起mush 客户端bug
--world.AddTriggerEx("xxdf","^(> |)岳不群说道：「"..player_name..".*听说魔教教主被关在杭州西湖湖底，你去把他杀了，我就让你入五岳剑派。」$"," world.Send(\"nick 吸星大法\")\nprint(utils.msgbox (\"开始解化功大法！！！！\", \"Warning!\", \"ok\", \"!\", 1))", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)

--world.AddTriggerEx ("page", "^\\=\\= 还剩.*行 \\=\\= \\(ENTER 继续下一页，q 离开，b 前一页\\).*$", "world.Send('')", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 999)

world.AddTriggerEx ("bug1", "^(> |)你还是了结完江湖恩怨再说吧。$", "sj.log_catch(WorldName()..'bug记录器',800)\nEnableTrigger('bug1',false)", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
local function  longtime()
     wait.make(function()
	    shutdown()
	    world.Send("halt")
		world.Send("quit")
		local l,w=wait.regexp("正在退出游戏……",1.5)
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
		if string.find(l,"正在退出游戏") then
            world.AddTimer("world", 4, 0, 0, "sj.World_Opening()", timer_flag.Enabled + timer_flag.ActiveWhenClosed , "")
            world.SetTimerOption ("world", "send_to", 12)
			return
		end
		wait.time(5)
     end)
end

local function World_Opening()
 --print("开始重新连接")
 if IsConnected()==false then
    --ResetIP()
    --world.DoCommand("Disconnect")
	--world.DoCommand("Connect")
	set_WorldAddress()--设置ip
	world.Connect()
	wait.make(function()
	  local l,w=wait.regexp("^(> |)您目前的权限是：\\(player\\)",5)
	  if l==nil then
	     sj.World_Opening()
		 return
	  end
	  if string.find(l,"您目前的权限是") then
		world.DeleteTimer("world")
	    local relogin_Do=world.GetVariable("relogin_Do") or ""
		if relogin_Do~="" then
		   world.Execute(relogin_Do)
		end
	  --重新登录
	     shutdown()
	     sj.World_Init()
		 return
	  end
	  --wait.time(5)
	end)
  else
  --正在退出游戏……
  --您目前的权限是：(player)
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
			     --world.Execute("ask xiao tong about 食物")
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
			   w:go(1960) --299 ask xiao tong about 食物 ask xiao tong about 茶
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
			    -- world.Send("ask xiao tong about 茶")
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
			  w:go(1960) --299 ask xiao tong about 食物 ask xiao tong about 茶
end

local function quit(reconnect)

  	--[[   wait.make(function()
	    shutdown()
	    world.Execute("halt;halt;halt;quit;yun qi;yun jingli")
		local l,w=wait.regexp("^(> |)〖书剑〗：您本次总共在线.*",1)
		if l==nil then
		    quit()
		   return
		end
		if string.find(l,"您本次总共在线") then
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
	     print(os.date()," 安全保护退出！")
	     shutdown()
		 world.Execute("halt;halt;halt;quit;yun qi;yun jingli")
		 local f=function()
		    quit(reconnect)
		 end
		 f_wait(f,2,true)
	 else
		if reconnect==true then  --不需要重新连接
		     print("不需要重新连接")
			return
		end
		print("8分钟后重连mud！！！",os.date())
		world.AddTimer("world", 0, 8, 0, "sj.World_Opening()", timer_flag.Enabled  + timer_flag.ActiveWhenClosed , "")
		world.SetTimerOption ("world", "send_to", 12)
		world.EnableTimer("world",true)
	 end
end

function retest()
quit()
end

function safe_room(callback)

 --跑城隍庙
   local w=walk.new()
   w.walkover=function()
      world.Send("look")
	  world.Send("set action leave")
      local l,w=wait.regexp(".*城隍庙.*|^(> |)设定环境变量：action \\= \\\"leave\\\".*",3)
	  if l==nil then
	     safe_room()
		 return
	  end
	  if string.find(l,"设定环境变量：action") then
	     safe_room()
	     return
	  end
	  if string.find(l,"城隍庙") then
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
	     --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."启动退出保护！NPC:"..name, "green", "black") -- yellow on white
		local w=walk.new()
		w.walkover=function()
		   w:go(53)
		end
        world.Send("unset wimpy")
		w:go(53)
       quit()
	else
	   print("不在危险名单中:",name)
	   print("fpk"..name)
	   if name~="雪蛛" then
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
   world.AddTriggerEx ("Log1", "^(> |)(.*)\\((.*)\\)纵声长啸：(.*)$", "sj.glog('%2','%3','%4')", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
      world.AddTriggerEx ("Log2", "^(> |)(.*)\\((.*)\\)告诉你：(.*)$", "sj.glog('%2','%3','%4')", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
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
     local l,w=wait.regexp("^(> |)您已经连续玩了(.*)。$",5)
	  if l==nil then
	      update_onlinetime()
	      return
	  end
	  if string.find(l,"您已经连续玩了") then
	     local playtime=w[2]
		 local hour=0
		 local minute=0
		 local second=0
		 local regexp={}
		 regexp=Split(playtime,"小时")
		 if table.getn(regexp)>=2 then
		    hour=ChineseNum(regexp[1])
			playtime=regexp[2]
		 end
		 regexp=Split(playtime,"分")
       	 if table.getn(regexp)>=2 then
		    minute=ChineseNum(regexp[1])
          	playtime=regexp[2]
		 end
		 regexp=Split(playtime,"秒")
		 if table.getn(regexp)>=2 then
		    second=ChineseNum(regexp[1])
		 end


		 sj.onlinetime=hour*3600+minute*60+second
		  print("在线时间:",sj.onlinetime)
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
world.AppendToNotepad (logname,os.date()..": 事件记录器:"..line_count.."行内容!!\r\n")
for line = total_lines - line_count, total_lines do
  --Note (GetLineInfo (line, 1))
  world.AppendToNotepad (logname,GetLineInfo (line, 1).."\r\n")
  --Note ("Received ", GetLineInfo (line, 9))
end
world.AppendToNotepad (logname,os.date()..": *************关闭************\r\n")
end


------BackgroundPictures-------
BGpics = function()
  local  filter = { png="png文件",bmp = "bmp文件", ["*"] = "All files" }

   local filename = utils.filepicker ("选择背景图片",name, extension, filter, false)
   if filename~=nil then
      world.SetBackgroundImage (filename, 0)
   end
end --funtion

BGpics_del=function()
  world.SetBackgroundImage ("", 0)
end
--加载背景
--world.SetBackgroundImage (GetInfo (66).."佛.png", 12)
-- play sound once only, full volume, centered, in buffer 1
--加载背景音乐
--PlaySound (1, GetInfo (66).."彩虹糖的梦.wav", false, 0, 0)


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
  wdj_in_time=wdj_in_time, --记录最后进入五毒教时间
  wdj_refresh_time=wdj_refresh_time,
  wdj_give_time=wdj_give_time,
  marks_bed=marks_bed,--古墓寒玉床的使用时间
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
	--print("开插件")
EnablePlugin("4e38a3aade8c0892c5f19e86", false)

--world.AddTriggerEx ("tj1", "^(> |)你缓缓念道：“挤在手背，小心了！”\,便暗运氤氲紫气，太极「挤」字诀已使的出神入化！$", "local taiji=world.GetVariable(\"taiji\") or 0\nif taiji==0 then Send(\"set taiji 按|按|按|挤\") else Execute(\"set taiji 采|采|采|挤;jiali 50\") end", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
--world.AddTriggerEx ("tj2", "^(> |)你这一按实乃配合自身极高修为的氤氲紫气内功.*$", "SetVariable(\"taijian\",1)\nExecute(\"set taiji 挤|采|采|挤;jiali 50\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "","", 12, 9999)
--world.AddTriggerEx ("tj3", "^(> |)你「太极」神功使完，气归丹田，缓缓收功而退！$", "Execute(\"jiali 1;yun jingli;set taiji 挤|挤|挤|按\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
--[[ask wizard about 签到兑换

--设置窗体
world.AddTriggerEx ("pr1", "^(> |).*从.*走了过来。$", "", trigger_flag.RegularExpression + trigger_flag.OmitFromOutput + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
world.AddTriggerEx ("pr2", "^(> |).*往.*离开。$", "", trigger_flag.RegularExpression + trigger_flag.OmitFromOutput + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
--[[ask wizard about 签到兑换
节假日还临时开放
world.Send("ask wizard about 双倍奖励")
world.Send("ask wizard about 悍不畏死")
随机抽奖通宝物品
随机赠送小额通宝
通宝物品一般奖励玉肌丸 珍珠 素质书 周卡 还魂丹 精英书]]
--[[> 你丢下一柄木剑。
你丢下一把银蛇剑。
你丢下一块雄黄。
你丢下一柄钢刀。
你丢下一支火折。
你丢下一条粗绳子。
你丢下一份田七鲨胆散。
你丢下一双官靴。
因为这样东西并不值钱，所以人们并不会注意到它的存在。
你丢下一件金丝长袍。
因为这样东西并不值钱，所以人们并不会注意到它的存在。]]
