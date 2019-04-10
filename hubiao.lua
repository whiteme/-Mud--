--[[
 1:  ──────────────────────────────
 2:                        【护镖任务介绍】
 3:  ──────────────────────────────
 4:
 5:      福威镖局，一个在江湖上响当当的字号。其曾祖远图公创下七十
 6:  二路辟邪剑法，当年威震江湖，当真说得上打遍天下无敌手。属下有
 7:  十处镖局，八十四位镖头，遍布大江南北。江湖上的朋友无不卖它三
 8:  分面子。
 9:
10:  ──────────────────────────────
11:                          【任务要求】
12:  ──────────────────────────────
13:
14:      需要2-4 人组队，组队经验值总和大于1.5M，队员经验值相差小
15:  于1M，每人银行有100gold做为押金。
16:
17:
18:  ──────────────────────────────
19:                          【任务过程】
20:  ──────────────────────────────
21:
22:      所有队员到福州福威镖局，找林震南，由队伍的首领，就是team
23:  leader ask lin about 护镖，当他同意后用driver 方向推镖车，除
== 还剩  2 行 == (ENTER 继续下一页，q 离开，b 前一页)

24:  去拦路的劫匪，将镖车推到目的地。
25:      当所有队员到达后，由首领finish，即完成工作。]]
--xzl_gb
-- 走路 战斗 恢复
--由于你护镖失败，交给镖局的五十两黄金被用来赔偿了。
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
  rooms={}, --经过的房间号
  steps={}, --路径步
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

local cb=nil --战斗对象
local function child_Exe(cmd)
  local otherworld=GetWorldById(hubiao.child_worldID)
  --需要防止 子id 断线
  --Note(otherworld:IsConnected().."")
  if otherworld==nil then
  -- 防止另一个id 窗体关闭了重新打开
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
is_dangerous_man: 敖宝钗
不在危险名单中: 敖宝钗
fpk敖宝钗
看起来敖宝钗想杀死你！
is_dangerous_man: 宋同
不在危险名单中: 宋同
fpk宋同
看起来宋同想杀死你！
【你现在正处于福州城】
                            山路
                             ｜
                          武夷山路
                             ｜
                            北门
武夷山路 -
    你走在东南第一山脉武夷山上。海风从东面吹来，带着几分寒意。南边就
是著名的海港福州了。
　　这是一个初春的深夜，夜幕低垂，满天繁星。
    这里明显的出口是 north 和 south。
  恶虎沟帮众 宋同(Song tong) <战斗中>
  福威镖局总镖头 段千湘云(Duanqian xiangyun) <战斗中>
  镖车(Biao che)
  青竹帮女帮众 敖宝钗(Ao baochai) <战斗中>
  白袍剑侠(Baipao jianxia)
]]

function hubiao:main_link()
   local partner_id=world.GetVariable("hb_partner_id") or ""
   if partner_id=="" then
	  print("hb_partner_id 变量没有设置")
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
   print("删除超时计时器")
	world.DeleteTimer("hubiao_outoftime")
	child_Exe("/print('删除超时计时器')")
	child_Exe("/world.DeleteTimer(\"hubiao_outoftime\")")
  --辅助id 参数设置
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
	  print("hb_partner_id 变量没有设置")
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
  --辅助id 参数设置
  local cmd="/hubiao.master_worldID='"..hubiao.master_worldID.."'"
  child_Exe(cmd)
  cmd="/hubiao.child_worldID='"..hubiao.child_worldID.."'"
  child_Exe(cmd)
  print("连接完毕!!!!!")
end

function hubiao:team()
   local player_id=world.GetVariable("player_id")
   local otherworld=GetWorldById(hubiao.child_worldID)
   local partner_id=otherworld:GetVariable("player_id")
   print("子id",partner_id)
   print("主id",player_id)
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
	qi_percent=assert(tonumber(qi_percent),"qi_percent变量必须输入数字！") or 100
    local h
	h=hp.new()
	h.checkover=function()
	   -- print(h.food,h.drink)
	   print(h.qi_percent,"气血百分百 ",h.qi,"气血")
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
		   w:go(1960) --299 ask xiao tong about 食物 ask xiao tong about 茶
		elseif h.jingxue_percent<=80 or (h.qi_percent<=liao_percent and heal_ok==false) then
		    print("疗伤")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=1333
			rc.heal_ok=function()
			   heal_ok=true
			   self:full()
			end
			rc:liaoshang()
        elseif h.jingxue_percent<100 then
		    print("打通经脉")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=1333
			rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:full()
			end
			rc:heal(false,true)
		elseif h.qi_percent<qi_percent and heal_ok==false  then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=1333
			rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			   heal_ok=true
			   self:full()
			end
			rc.hudiegu=function() --取消门派医保
			   rc:heal(false,false)
			end
			rc.xiaoyao=function() --取消门派医保
			   rc:heal(false,false)
			end
			rc.liao_bed=function() --取消门派医保
			   rc:heal(false,false)
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    heal_ok=false --复位
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
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
			    end
				if id==777 then
				   f=function()
				     heal_ok=false
   				     self:full()
				   end  --外壳
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
	             print("继续修炼")
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
	           task_name="护镖",
	           task_stepname="打坐",
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
	          print("检查状态")
		     if table.getn(cd.lists)>0 then

		      local sec=0
		       for _,i in ipairs(cd.lists) do
				local s,e=string.find(i[1],"毒")
				 if s~=nil then
                    s=s%2
				 else
				    s=0
				 end
			     if i[1]=="星宿掌毒" or s==1 then
				   print("中毒了")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=1333
			        rc.heal_ok=function()
			          self:Status_Check()
			        end
			        rc:qudu(sec,i[1],false)
				    return
			     end
				 if i[1]=="内伤" or i[1]=="七伤拳内伤" then
				    print("内伤")
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
		hubiao:team() --开始组队
	 elseif hubiao.master_ready==false then
	    safe_child_Exe("say 等等大师")
		world.DoAfterSpecial(1,"hubiao:ready_check()",12)
	 elseif hubiao.child_ready==false then
		safe_main_Exe("say 等等助手")
		world.DoAfterSpecial(1,"hubiao:ready_check()",12)
	 end
end


function hubiao:ready()
	world.DoAfterSpecial(1,"hubiao:ready_check()",12)
end

--走到位置
function hubiao:start()
  local w=walk.new()
  w.walkover=function()
	 local worldID=GetWorldID()
	  if hubiao.master_worldID==worldID then
	     print("主id就绪!")
		 child_Exe("/hubiao.sayword=false")
		 hubiao.master_ready=true
		 hubiao:ready()
	  else
	     print("子id就绪!")
		 local cmd="/hubiao.child_ready=true"
		 --hubiao.sayword=true
		 --hubiao:say()
		 main_Exe(cmd)
		 main_Exe("/hubiao:ready()")
	  end

  end
  w:go(1333)
end

function hubiao:prepare() --重新整备好 上路
 local worldID=GetWorldID()
  if hubiao.master_worldID==worldID then
	         --子id
		hubiao.master_ready=true
		hubiao:fight_end()
  else
	         --主id
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
			print("打通经脉")
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
			print("打通经脉")
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
				   local f=function() x:dazuo() end  --外壳
				    f_wait(f,1)
				end
				if id==201 then
				  if h.jingxue_percent<=60 then
				     hubiao:recover()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --外壳
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
			      print("继续!!")
			      hubiao:prepare()
			   else
	             print("继续修炼")
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
这支镖是由福威镖局镖师莫言负责送到嵩山少林卧室岑德本手上的。
   hubiao.follow_success=nil
    local mainworld=GetWorldById(hubiao.master_worldID)
		  local player_name1=mainworld:GetVariable("player_name") or ""
		  local otherworld=GetWorldById(hubiao.child_worldID)
		  local player_name2=otherworld:GetVariable("player_name") or ""
   world.Execute("look cart;look cart 2;look cart 3;look cart 4;set action 镖车")
   wait.make(function()
     local l,w=wait.regexp("^(> |)这支镖是由福威镖局镖师("..player_name1.."|"..player_name2.."")负责送到(.*)手上的。$|^(> |)设定环境变量：action \= \"镖车\"$",5)
	 if l==nil then
	    hubiao:followche(dir,roomname,direct)
	    return
	 end
	 if string.find(l,"这支镖是由福威镖局") then
	      hubiao.follow_success=true
		  return
     end
	 if string.fin(l,"设定环境变量：action ") then
	    hubiao.follow_success=false
	    return
	 end

   end)
]]
end

function hubiao:child_move(dir,roomname,direct)
  world.Execute(direct)

 world.Send("set action 移动")
  wait.make(function()
     --tell_room(newroom,HIR"突然路边跳出一群劫匪！\n"NOR);
		--tell_room(newroom,HIR+jf->query("name")+"恶狠狠地说道：此路是我开！此树是我栽！知道下面是什么了吧！\n"NOR);
      local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)设定环境变量：action \= \"移动\"",10)
	  if l==nil then
	     hubiao:child_move(dir,roomname,direct)
		 return
	  end

	  if string.find(l,"不能移动") then
	     local b=busy.new()
		 b.Next=function()
	       hubiao:child_move(dir,roomname,direct)
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"设定环境变量：action") then

	    return
	  end
   end)
end

--回调函数
function hubiao:move(dir,roomname,direct,again,action)
   if hubiao.master_ready==true and hubiao.child_ready==true then
	 if action~=nil then
	    world.Execute(action)
	 end
	 world.Execute(direct)
     world.Send("set action 移动")

	 if again==nil then
	   if action~=nil then
	    child_Exe(action)
	   end

	   child_Exe("/hubiao:child_move('"..dir.."','"..roomname.."','"..direct.."')")
	 end
	 wait.make(function()
     --tell_room(newroom,HIR"突然路边跳出一群劫匪！\n"NOR);
	 --你的动作还没有完成，不能移动。
		--tell_room(newroom,HIR+jf->query("name")+"恶狠狠地说道：此路是我开！此树是我栽！知道下面是什么了吧！\n"NOR);
      local l,w=wait.regexp("^(> |).*(鄱阳帮|天河帮|长鲸岛|神农帮|巨鲸帮|海沙派|青竹帮|龙游帮|金龙帮|恶虎沟|千柳庄)(女|)帮众.*(<战斗中>|<昏迷不醒>)|^(> |)你的动作还没有完成，不能移动。$|^(> |)设定环境变量：action \= \"移动\"|^.*"..hubiao.NPC..".*",10)
	  if l==nil then
	     hubiao:move(dir,roomname,direct)
		 return
	  end
	  if string.find(l,"帮众") then
	      shutdown()
		   hubiao.master_ready=false
		   hubiao.child_ready=false
		   hubiao:lineup()--布阵
		   hubiao:fight()
	      return
	  end
	  if string.find(l,hubiao.NPC) then
	     hubiao.find_NPC=true
	     hubiao:check_fight()

	     return
	  end
	  --|^(> |)你的动作还没有完成，不能移动。$
	  if string.find(l,"不能移动") then
	     local b=busy.new()
		 b.Next=function()
	       hubiao:move(dir,roomname,direct,true)
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"设定环境变量：action") then
	    print("没有劫匪!!!")
		-- child_Exe("/hubiao:move('"..dir.."','"..roomname.."','"..direct.."')")
	     --hubiao:followche(dir,roomname,direct)
		  world.ColourNote("red","yellow","***************************没有劫匪!!!继续!***********************")
		  local f=function()
		    --coroutine.resume(hubiao.co)
			hubiao:checkhere()
		  end
		  f_wait(f,1)

		--ColourNote("red","yellow","**********************没有劫匪!!!继续!!*************")
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
   --保证两个id 都没有busy 一起移动
   local b=busy.new()
   b.halt_error=function()  --超时
      local f=function()
	     b:jifa()
	  end
	  f_wait(f,3)
   end
   b.Next=function()

       local worldID=GetWorldID()
	    if hubiao.master_worldID==worldID then
	       --子id
		    local cmd="/hubiao.master_ready=true"
		    main_Exe(cmd)
			if action~=nil then
		  	  cmd="hubiao:move('"..dir.."','"..roomname.."','"..direct.."',nil,'"..action.."')"
			else
			  cmd="hubiao:move('"..dir.."','"..roomname.."','"..direct.."')"
			end
            DoAfterSpecial(1,cmd,12)
			--cmd="/hubiao:followche2('"..dir.."','"..roomname.."','"..direct.."')"
			--main_Exe(cmd) --回调主
	    else
	      --主id
		   local cmd="/hubiao.child_ready=true"
			main_Exe(cmd)
            --child_Exe(cmd)
			--cmd="/hubiao:followche2('"..dir.."','"..roomname.."','"..direct.."')"
			--main_Exe(cmd) --回调主
	    end
   end
   b:jifa()

end

--AddTrigger("由于你护镖失败，交给镖局的五十两黄金被用来赔偿了。")
--由于你护镖失败，交给镖局的五十两黄金被用来赔偿了。


function hubiao:tui(direct,who,action)
    --你推那么快，想把镖车弄散架吗？
	--你现在正忙，不能指挥镖车前进。
	--local cmd="drop 1 gold;tui "..direct..";get 1 gold"
	hubiao.tui_count=hubiao.tui_count+1
	if hubiao.tui_count>50 then
	   print("超过50次！！异常！！！")
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
	  --本人推车 主id
	   main_Exe(cmd)
	elseif who=="none" then
	    print("别人的镖车")
	   main_Exe(cmd)
	else
	   child_Exe(cmd)
	end
	if action~=nil then
	   world.Execute(action)
	end
    wait.make(function()
	   local l,w=wait.regexp("^(> |)镖车在(.*)的护卫下缓缓地往(.*)的(.*)离去了。$|^(> |)你推那么快，想把镖车弄散架吗？$|^(> |)你现在正忙，不能指挥镖车前进。$|^(> |)劫匪尚未除去，你想往哪里走？！$",2)
	   if l==nil then
		  hubiao:tui(direct,who,action)
		  return
	   end
	   if string.find(l,"劫匪尚未除去，你想往哪里走") then
	      hubiao:fight()
	      return
	   end
	   if string.find(l,"你现在正忙，不能指挥镖车前进") then
	      wait.time(1)
		  hubiao.tui_count=0
		  hubiao:tui(direct,who,action)
	      return
	   end
	   if string.find(l,"你推那么快，想把镖车弄散架吗") then
	      hubiao.tui_count=0
	      hubiao:tui(direct,"child",action)
	      return
	   end
	   if string.find(l,"离去了") then
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
		  if guardname==player_name1 or guardname==player_name2 or guardname=="你" then
             hubiao.tui_count=0
			 if roomname=="荒路" then
			    print("荒路！！")
			    direct="nu;s;nu;n;nu;s;nu;s;nu"
			 end

			 --镖车在三清的护卫下缓缓地往一边的沙漠离去了。

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
		     --分开
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
	local l,w=wait.regexp("^(> |)渡船猛地一震，已经靠岸，船夫说道：“请大伙儿下船吧！”$|^(> |)艄公说“到啦，上岸吧”，随即把一块踏脚板搭上堤岸。$|^(> |)艄公轻声说道：“都下船吧，我也要回去了。”$",5)
	 if l==nil then
	    safe_main_Exe("say 百年修得同船渡")
		safe_child_Exe("say 千年修得共枕眠")
	    hubiao:outboat()
	    return
	 end
	 if string.find(l,"渡船猛地一震，已经靠岸") or string.find(l,"到啦，上岸吧") or string.find(l,"都下船吧，我也要回去了") then

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
--岸边一只渡船上的老艄公说道：正等着你呢，上来吧。
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
	  --黄河渡船 - out --
	  --镖车在专业护镖的护卫下缓缓地往一边的陕晋渡口离去了。
	  --镖车在专业护镖的护卫下缓缓地往里面的渡船离去了。
	  --渡船 - |^(> |)(江|河)面上远远传来一声：“等等啊，这就来了～～～”$|^(> |)只听得湖面不远处隐隐传来：“别急嘛，这儿正忙着呐……”$
      local l,w=wait.regexp("^(> |)镖车在(.*)的护卫下缓缓地往(.*)的(.*)离去了。$|^(> |).*渡船\\\s*-\\\s*(out|)$|.*渡船\\\s*-.*",3)
	  if l==nil then
	    hubiao:yellboat(is_tui)
	    return
	  end
	  if string.find(l,"的护卫下缓缓地往") then
		 --world.Send("enter")
		 --child_Exe("enter")
		  -- print("镖车已经上船!")
          world.ColourNote("blue","yellow","镖车已经上船!")
		  local guardname=w[2]
	      local dir=w[3]
		  local roomname=w[4]
		  local mainworld=GetWorldById(hubiao.master_worldID)
		  local player_name1=mainworld:GetVariable("player_name") or ""
		  local otherworld=GetWorldById(hubiao.child_worldID)
		  local player_name2=otherworld:GetVariable("player_name") or ""

		  if guardname==player_name1 or guardname==player_name2 or guardname=="你" then
		      hubiao:yellboat(false)
		  else
		      hubiao:yellboat(true)
		  end
		 return
	  end
	  if string.find(l,"渡船") then
	     --print("out boat 触发")
	     hubiao:outboat()
		 return
	  end
	 --[[ if string.find(l,"等等啊") or string.find(l,"只听得湖面不远处隐隐传来") then
	     wait.time(5)
		 hubiao:yellboat()
	     return
	  end]]

	  --[[
	  if string.find(l,"什么") then --错误异常
	    --self:finish()
		--重新计算
	    return
	  end]]
  end)
end

--辅助 id
local partner=false
local cart=false
function hubiao:lists(regexp)
  wait.make(function()
      local l,w=wait.regexp(regexp,5)
	  if l==nil then
	     hubiao:lists(regexp)
		 return
	  end
	  if string.find(l,"镖车") then
	     cart=true
		 hubiao:lists(regexp)
	     return
	  end
	  if string.find(l,partner_id) then
	    partner=true
	    hubiao:lists(regexp)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
	    --结果返回给主进程
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
   world.Send("set action 检查")
   local otherworld=GetWorldById(hubiao.master_worldID)
   local partner_id=otherworld:GetVariable("player_id")
   local regexp=".* = "..partner_id.."$|^(> |)镖车 = .*$|^(> |)设定环境变量：action \= \"检查\"$"
   hubiao:lists(regexp)
end

function hubiao:check_shamo()
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --根据当前位置 前往最近的钱庄
--{大理 410} {塘沽 1474} {扬州 50} {成都 546} {西域 1973} {苏州 1069} {杭州 1119} {福州 1331} {长安 926} {兰州城}
      local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	 if roomno[1]==1705 then
	   hubiao.co2=nil
	   print("沙漠边缘!!")

        hubiao:checkhere()
	 elseif roomno[1]==630 then
	     print("青城!!")
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
		--print("大轮寺")
		hubiao:tui("east")
	end
	hubiao:break_in("kill hong xiaotian",f,nil)
end
hubiao.alias["wuzhitang_east_zoulang"]=function() hubiao:wuzhitang_east_zoulang() end

function hubiao:wuzhitang_west_zoulang()
   local f=function()
		--print("大轮寺")
		hubiao:tui("west")
	end
	hubiao:break_in("kill hong xiaotian",f,nil)
end
hubiao.alias["wuzhitang_west_zoulang"]=function() hubiao:wuzhitang_west_zoulang() end

function hubiao:xieketing_rimulundian()
	local f=function()
		print("大轮寺")
		hubiao:tui("enter",nil,"open door")
	end
	hubiao:break_in("kill hufa lama|kill hufa lama|kill hufa lama",f,nil)
end
hubiao.alias["xieketing_rimulundian"]=function() hubiao:xieketing_rimulundian() end

function hubiao:rimulundian_yueliangmen()
	local f=function()
		print("大轮寺")
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
		--检查房间号
		hubiao:check_shamo()
		coroutine.yield()
	  end
	   print("结束!!!")
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
		--检查房间号
		hubiao:check_shamo()
		coroutine.yield()
	  end
	   print("结束!!!")
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
		--检查房间号
		hubiao:check_shamo()
		coroutine.yield()
	  end
	   print("结束!!!")
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
		print("少林寺")
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
--天龙寺西练武场-龙象台
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
		  print("天龙寺")
		  hubiao:tui("northup")
		end

        hubiao:break_in("kill chanshi|kill wu seng|kill wu seng",f,nil)
end
hubiao.alias["qingduyaotai_baishilu"]=function() hubiao:qingduyaotai_baishilu() end

function hubiao:shanmen_shanlu()

		local f=function()
		  print("帮众")
		  hubiao:tui("northup")
		end

        hubiao:break_in("kill bangzhong|kill bangzhong",f,nil)

end
hubiao.alias["shanmen_shanlu"]=function() hubiao:shanmen_shanlu() end
--zoulang_liangongfang 1958
function hubiao:zoulang_liangongfang()

		local f=function()
		  print("张松溪")
		  hubiao:tui("north")
		end

        hubiao:break_in("kill zhang songxi",f,nil)

end
hubiao.alias["zoulang_liangongfang"]=function() hubiao:zoulang_liangongfang() end

function hubiao:zoulang_xixiangzoulang()

		local f=function()
		  print("张松溪")
		  hubiao:tui("west")
		end
        hubiao:break_in("kill zhang songxi",f,nil)
end
hubiao.alias["zoulang_xixiangzoulang"]=function() hubiao:zoulang_xixiangzoulang() end



--三清从西街走了过来。   关
--莫言往东北的山路离开。 开
function hubiao:id_follow()
  --检查2个id 是否在同一个房间
   local mainworld=GetWorldById(hubiao.master_worldID)
   local player_name1=mainworld:GetVariable("player_name") or ""
   local otherworld=GetWorldById(hubiao.child_worldID)
   local player_name2=otherworld:GetVariable("player_name") or ""
   wait.make(function()
      local l,w=wait.regexp("^(> |)"..player_name2.."从.*走了过来。$|^(> |)"..player_name1.."往.*离开。$",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"离开") then
	     main_Exe("/hubiao.id1_ok=true")
	     return
	  end
	  if string.find(l,"走了过来") then
	     main_Exe("/hubiao.id2_ok=true")
	     return
	  end

   end)
end

function hubiao:zoulang_dongxiangzoulang()

		local f=function()
		  print("张松溪")
		  hubiao:tui("east")
		end
        hubiao:break_in("kill zhang songxi",f,nil)
end
hubiao.alias["zoulang_dongxiangzoulang"]=function() hubiao:zoulang_dongxiangzoulang() end

function hubiao:shamo1_shamo2()
   local p={"north","south","south","north","south","south","north","south","north","south","south","north","south","south"}

	hubiao.co2=coroutine.create(function()
	  for _,s in ipairs(p) do
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
		--检查房间号
		hubiao:check_shamo()
		coroutine.yield()
	  end
	   print("结束!!!")
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
		print("丁勉")
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
       local l,w=wait.regexp("^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动了几下就死了.*|^(> |)这里没有这个人。$",15)
	   if l==nil then
	      self:break_in(cmds,callback,index)
		  return
	   end
	   if string.find(l,"挣扎着抽动了几下就死了") or string.find(l,"这里没有这个人") then
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
	  print("当前房间号",roomno[1])
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("结束!!!")
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
	       --子id
		    local cmd="/hubiao.master_ready=true"
		    main_Exe(cmd)
            --DoAfterSpecial(1,cmd,12)
			cmd="/hubiao:unwield_all_finish()"
			main_Exe(cmd) --回调主
	    else
	      --主id
		   local cmd="/hubiao.child_ready=true"
			main_Exe(cmd)
			cmd="/hubiao:unwield_all_finish()"
            --child_Exe(cmd)
			--cmd="/hubiao:followche2('"..dir.."','"..roomname.."','"..direct.."')"
			main_Exe(cmd) --回调主
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("结束!!!")
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("结束!!!")
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("结束!!!")
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("结束!!!")
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
	    print("下一步")
        local dir=s
		print("方向:",dir)
		if dir=="" then
		    print("结束")
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
			     world.AppendToNotepad (WorldName().."_护镖任务:",os.date().." 没有找到特殊路径处理:"..dir.."\r\n")
			     return
			   end
			   callback()
			end
        else
		   --world.Send(dir)
		   hubiao:tui(dir)
		   --hubiao:checkhere()
		end
		print("挂起!!")
		coroutine.yield()
		hubiao.step=hubiao.step+1
	end
	 print("结束!!!")
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
	           task_name="护镖",
	           task_stepname="奖励",
	           task_step=3,
	           task_maxsteps=3,
	           task_location=Place,
	           task_description="",
	       }
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
		 CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."运镖任务:奖励! 经验:"..rd.exps_num.." 潜能:"..rd.pots_num.." 黄金:"..rd.gold_num, "red", "black") -- yellow
		  --exps=tonumber(exps)+ChineseNum(w[2])
		end
		rd:get_reward()
end

function hubiao:finish()
--你现在还没有到达目的地！
--钟离孝对你表示衷心的感谢。
--你被奖励了六千八百零八点经验，一千一百三十四点潜能，一百二十两黄金！
  local worldID=GetWorldID()
   if hubiao.master_worldID==worldID then
       child_Exe("/hubiao:finish()")
	   world.Send("finish")
   end
--你现在还没有到达目的地！
  wait.make(function()
    local l,w=wait.regexp("^(> |)你现在还没有到达目的地.*$|^(> |)你的队员尚未到齐！|^(> |)"..hubiao.NPC.."对你表示衷心的感谢。$",5)
	if l==nil then
	  hubiao:finish()
	  return
	end
	if string.find(l,"你的队员尚未到齐") then

	   print("不在同一个房间!!!异常!!")
		 world.AppendToNotepad (WorldName().."_护镖任务:",os.date().." 不在同一个房间!!!异常!! 房间号"..hubiao.leader_roomno.."\r\n")
		 local w=walk.new()
		 w.walkover=function()
		    world.AppendToNotepad (WorldName().."_护镖任务:",os.date().." 重新定位\r\n")
		    local cmd="/hubiao:finish()"
			 main_Exe(cmd)
		 end
		 w:go(hubiao.leader_roomno)
	   return
	end
    if string.find(l,"对你表示衷心的感谢") then
	  if hubiao.master_worldID==worldID then
	    hubiao.co=nil
	    hubiao.co2=nil
	    hubiao.co3=nil
		hubiao.child_ready=false
		hubiao.master_ready=false
	    local t1=os.time()
	    print(hubiao.starttime," 间隔!! ",t1)
	    local t2=os.difftime(t1,hubiao.starttime)
	    print(t2,"秒间隔!")
	    local t3=math.floor(t2/60)
        world.AppendToNotepad (WorldName().."_护镖任务:",os.date().."耗时:"..t3.."分钟\r\n")
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
	if string.find(l,"你现在还没有到达目的地") then
	   print("多个房间匹配")
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
	    local l,w=wait.regexp("^.*镖车.*",5)
		if l==nil then
           --hubiao:find_che()
		   return
		end
		if string.find(l,"镖车") then
           hubiao:Call_Partner()
		   return
		end
	 end)
end]]

--需要确认辅助 id 是否在一起
function hubiao:id_follow_check()
    local hb_leader_id=world.GetVariable("hb_leader_id") or ""
	hb_leader_id=string.lower(hb_leader_id)
	world.Send("follow "..hb_leader_id)
	world.Send("set action 跟随")
	print("领队所在房间>",hubiao.leader_roomno)
	wait.make(function()
	  local l,w=wait.regexp("^(> |)你已经这样做了。$|^(> |)你决定跟随.*一起行动。$|^(> |)设定环境变量：action \= \"跟随\"$",2)
	  if l==nil then
	     self:id_follow_check()
	     return
	  end
	  if string.find(l,"你已经这样做了") or string.find(l,"一起行动") then
	     --child_Exe("follow none")
		 --main_Exe("follow none")
		 world.Send("follow none")
	     main_Exe("/coroutine.resume(hubiao.co)")
	     return
	  end
	  if string.find(l,"设定环境变量") then
         print("不在同一个房间!!!异常!!")
		 world.AppendToNotepad (WorldName().."_护镖任务:",os.date().." 不在同一个房间!!!异常!! 房间号"..hubiao.leader_roomno.."\r\n")
		 local w=walk.new()
		 w.walkover=function()
		    world.AppendToNotepad (WorldName().."_护镖任务:",os.date().." 重新定位\r\n")
		    local cmd="/hubiao:look_che()"
			 main_Exe(cmd)
		 end
		 w:go(hubiao.leader_roomno)

		 --child_Exe(cmd)
	     return
	  end
	end)

end

function hubiao:checkhere() --检查房间号是否一致
	--print("player1:",hubiao.id1_ok," player2:",hubiao.id2_ok)

    --迷宫 固定路径
	if hubiao.co2~=nil then
	   print("进入迷宫")
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
	   print("结束 checkhere")
	   hubiao:finish()
	   hubiao.co=nil
	   --hubiao.co2=nil
	   --hubiao.co3=nil
	   return
	end
	local roomname=GetRoomName(r)
	--print(roomname,"目标")
	--

    local _R=Room.new()
    _R.CatchEnd=function()
	     --print(_R.roomname)
	    if _R.roomname==roomname then
            --继续推车
            --print("继续")
            --local cmd="/hubiao:idhere()"
			--child_Exe(cmd)

			--print("等待战斗,挂起")
			--hubiao:check_result()


			child_Exe("/hubiao.leader_roomno="..r)
			local f=function()
			  print("继续路程")
			  child_Exe("/hubiao:id_follow_check()")
            end
			f_wait(f,0.2)
			--
			--hubiao:test_path()
		else
		    --重新开始计算
			--print("当前房间名称:",_R.roomname)
			--print("目标房间名称:",roomname)
			print("重新计算")
			--local location=hubiao.place
			--hubiao:get_path(location,nil)
			hubiao:look_che()
		end
	end
	_R:CatchStart()
end
--"天河帮", "长鲸岛", "神农帮", "巨鲸帮", "海沙派", "青竹帮",
--	"龙游帮", "金龙帮", "鄱阳帮", "恶虎沟", "千柳庄"
--4~7 秒出现
--│福州镖局护镖倒计时三分                     ？ │
function hubiao:fight()

    world.Execute("kill jie fei;kill jie fei 2")
	child_Exe("kill jie fei 2;kill jie fei")
	child_Exe("/hubiao:fight_start()")
	hubiao:fight_start()
	hubiao:check_fight()
end

function hubiao:fight_end()
    print("标志1",hubiao.master_ready)
	print("标志2",hubiao.child_ready)
   if hubiao.master_ready==true and hubiao.child_ready==true then
      hubiao.sayword=false
      --coroutine.resume(hubiao.co)
	  world.ColourNote("red","yellow","***************************恢复结束,继续***********************")
	  hubiao:checkhere() --检查
   else
      hubiao.sayword=true
	  hubiao:say()
   end
end

function hubiao:say()
   if hubiao.sayword==true then
	safe_main_Exe("say 风萧萧兮易水寒")
    safe_child_Exe("say 壮士一去兮不复还")
	DoAfterSpecial(5,"hubiao:say()",12)
   end
end

function hubiao:fight_finish()
    if cb.is_duo==true then
	    world.ColourNote("green","yellow","**********武器丢失**********")
		for _,weapon_item in ipairs(cb.lost_weapon_id) do
			world.Send("get " ..weapon_item.. " from corpse")
			world.Send("get "..weapon_item)
		end
		cb.lost_weapon_id={}
		cb.is_duo=false
		world.ColourNote("green","yellow","**********武器丢失 结束**********")
	end
end

function hubiao:check_fight()
   wait.make(function()
		     world.Send("look")
			 world.Send("set action 战斗")
			 safe_child_Exe("say 小兔乖乖,把门开开!")
			 --^(> |)  长鲸岛帮众.*<战斗中>|
		     local l,w=wait.regexp("^.*(鄱阳帮|天河帮|长鲸岛|神农帮|巨鲸帮|海沙派|青竹帮|龙游帮|金龙帮|恶虎沟|千柳庄)(女|)帮众.*(\<战斗中\>|\<昏迷不醒\>).*|^(> |)设定环境变量：action \= \"战斗\"$",5)
			 if l==nil then
			    hubiao:check_fight()
				return
			 end
			 if string.find(l,"帮众") then
			    print("帮众！！！")
				world.Send("kill jie fei")
			    wait.time(5)
				hubiao:check_fight()
			    return
			 end
			 if string.find(l,"设定环境变量") then
			    shutdown()
				if hubiao.find_NPC==true then
				   hubiao:finish()
				   return
				end
				child_Exe("/shutdown()")
				world.ColourNote("red","yellow","***************************战斗结束***********************")
				hubiao:main_pfm() --恢复初始pfm 设置
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
--[[> 你把 "pfm" 设定为 "halt;east;set action 逃跑" 成功完成。
> 设定环境变量：wimpy = 100
> 设定环境变量：wimpycmd = "pfm\hp"
> 你正在使用「四季散花」，暂时无法停止战斗。
你转身就要开溜，被莲芬芳一把拦住！
你逃跑失败。
设定环境变量：action = "逃跑"]]

   wait.make(function()
	   local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)你逃跑失败。$|^(> |)你正在使用.*暂时无法停止战斗。$|^(> |)你的修为不够！$|^(> |)设定环境变量：action \\= \\\"逃跑\\\"$",1.5)
	   if l==nil then
	      hubiao:run(i)
	      return
	   end
	   if string.find(l,"你的修为不够") then
	     i=i+1
		 hubiao:flee(i)
	     return
	   end
	   if string.find(l,"你的动作还没有完成，不能移动") or string.find(l,"你逃跑失败") or string.find(l,"暂时无法停止战斗") then
		  hubiao:run(i)
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
		 world.DoAfter(1.5,"set action 结束")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"逃跑\\\"$|^(> |)设定环境变量：action \\= \\\"结束\\\"$",5)
			if l==nil then
			   hubiao:run(i)
			  return
			end
			if string.find(l,"逃跑") then
			    i=i+1
		        hubiao:flee(i)
			   return
			end
			if string.find(l,"结束") then


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
     print("寻找出口")
     local dx=_R:get_all_exits(_R)
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil or i>table.getn(dx) then
	    --获得随机方向
	     local n=table.getn(dx)
	     i=math.random(n)
		 print("随机:",i)
	 end
	 local run_dx=dx[i]
	 --print(run_dx, " 方向")
	 local halt
	 if _R.roomname=="洗象池边" then
	    world.Send("alias pfm "..run_dx..";set action 逃跑")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set action 逃跑")
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
	      print("低于安全设置吃药")
		  world.Send("fu dahuan dan")
	     end
		 if tonumber(hp.qi_percent)<=30 then
	      print("低于安全设置吃药")
		  hubiao:flee()
	     end
      end
	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("战斗结束")
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
	     print("内力不够")
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
	    print("下一步")
		print(s)
        hubiao:tui(s)
		coroutine.yield()
	  end
	   print("结束!!!")
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
   --初始化
   --
   --hubiao:test_path()
   hubiao:do_tui()
end

function hubiao:giveup()

   world.AppendToNotepad (WorldName().."_护镖任务:",os.date().." 无法到达地点"..hubiao.place..": 放弃！！\r\n")
   local b=busy.new()
   b.Next=function()
   child_Exe("tui north")
   world.Send("tui north")
   print("无法到达的房间！")
   local f=function()
     hubiao:jobDone()
     child_Exe("/hubiao:jobDone()")
   end
   f_wait(f,2)
  end
  b:check()
end

function hubiao:get_path(location,opentime)  --确定白天晚上

  local n,e=Where(location) --检测房间名
  print("房间数",n)
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
			print("推车路径:",path)
			--tprint(rooms)
			hubiao:paths(path,rooms)
	    end
		local room
		--print("搜索路径:",r[1],"->",target_room)
        if table.getn(r)==1 then
		   room=r[1]
		else
		   print("多个房间匹配!!无法定位!")
		   for _,roomno in ipairs(r) do
			  if roomno==last_target_room then
			    room=last_target_room
			    break
			  end
		   end
		   print("最后房间:",last_target_room," 是否匹配 ", room)
		end
		print("搜索路径:",room,"->",target_room)
		last_target_room=target_room
        mp:Search(room,target_room,opentime)
	end
	WhereAmI(f,10000) --排除出口变化
	coroutine.yield()
   end
  end)
  --local b=busy.new()
  --b.interval=2
  --b.Next=function()
     --hubiao:main_pfm() --设置pfm
     coroutine.resume(hubiao.co3)
  --end
  --b:check()
end
--│福州镖局护镖倒计时二分                     ？ │
function hubiao:fail(id)

end


function hubiao:update_title(Place,NPC)
 	local ts={
	           task_name="护镖",
	           task_stepname="运镖",
	           task_step=2,
	           task_maxsteps=3,
	           task_location=Place,
	           task_description="寻找"..NPC,
	       }
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
end
--林震南说道：「现在没有镖需要劳驾壮士出马。」


function hubiao:look_che()
--颜色触发
   world.Send("look che")
   wait.make(function()

   local l,w=wait.regexp("^(> |)这支镖是由福威镖局镖师.*$",5)


   if l==nil then
      shutdown()
      self:ask_job()
      return
   end

   if string.find(l,"这支镖是由福威镖局镖师") then

   --^(> |)这支镖是由福威镖局镖师(.*)负责送到(.*)手上的。$
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

        if string.find(text,"这支镖是由福威镖局镖师"..player_name) then

	       is_match=true
	    elseif string.find(text,"手上的") then
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
	           task_name="护镖",
	           task_stepname="运镖",
	           task_step=2,
	           task_maxsteps=3,
	           task_location=Place,
	           task_description="寻找"..NPC,
	       }
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
		 child_Exe("/hubiao:update_title('"..Place.."','"..NPC.."')")

		 world.AppendToNotepad (WorldName().."_护镖任务:",os.date().."地点:"..Place.." "..NPC.."\r\n")
		 hubiao.starttime=os.time()
		 hubiao:main_pfm() --设置2 id pfm
		 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."护镖任务:"..Place.." "..NPC, "white", "black")
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
--林震南说道：「护镖路途危险，你这么少的人，我可不放心。」
  local w=walk.new()
  w.walkover=function()
    world.Send("ask lin about 护镖")
	--world.Send("look che")
	world.Send("set action 询问")
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)林震南说道：「请护送这一笔镖银到(.*)的(.*)手中。」$|^(> |)林震南说道：「咦？怎么好象人不全啊？(.*)怎么没来？」$|^(> |)设定环境变量：action \\= \\\"询问\\\"$|^(> |)林震南说道：「一直护镖很辛苦的，我看这位.*还是去歇息片刻吧！」$|^(> |)林震南说道：「护镖路途危险，你这么少的人，我可不放心。」$",5)
	   if l==nil then
          hubiao:ask_job()
	      return
	   end
	   if string.find(l,"请护送这一笔镖银到") then
	      shutdown()
		  hubiao.find_NPC=false
		  child_Exe("/hubiao.find_NPC=false")
	      local NPC=w[3]
		  local Place=w[2]
		  	local ts={
	           task_name="护镖",
	           task_stepname="运镖",
	           task_step=2,
	           task_maxsteps=3,
	           task_location=Place,
	           task_description="寻找"..NPC,
	       }
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
		 child_Exe("/hubiao:update_title('"..Place.."','"..NPC.."')")

		 world.AppendToNotepad (WorldName().."_护镖任务:",os.date().."地点:"..Place.." "..NPC.."\r\n")
		 hubiao.starttime=os.time()
		 hubiao:main_pfm() --设置2 id pfm
		 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."护镖任务:"..Place.." "..NPC, "white", "black")
		  hubiao.place=Place
		  hubiao.NPC=NPC

		  child_Exe("/hubiao.NPC='"..NPC.."'")

           dangerous_man_list_clear()
		   child_Exe("/dangerous_man_list_clear()")

		  local b=busy.new()
		  b.Next=function()

		     print("HB第一步")

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
	   if string.find(l,"还是去歇息片刻吧") then
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
	   if string.find(l,"怎么好象人不全啊") or string.find(l,"护镖路途危险，你这么少的人") then
	   --两个id 不在一个房间
	     hubiao.master_ready=false
		 hubiao.child_ready=false

	     local b=busy.new()
		 b.Next=function()
	      --hubiao:team()
		     print("人不全，重新集合!!")
            world.Send("follow none")
			world.AppendToNotepad (WorldName().."_护镖任务:",os.date().." 人不全，重新集合\r\n")
		    hubiao:start()
			child_Exe("follow none")
			child_Exe("/shutdown()")
			child_Exe("/hubiao:start()")

		 end
		  b:check()
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
	      hubiao:look_che()
	      return
	   end
	   --[[
	   if string.find(l,"现在没有镖需要") then
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


--由于你护镖失败，交给镖局的五十两黄金被用来赔偿了。
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
	       --子id
            child_Exe(cmd)
	    else
	      --主id
			main_Exe(cmd)
	    end
	 end
	 w:go(ToRoomNo)
  end
  b:check()
end
--回调函数
function hubiao:Call_Partner_Over()
   local worldID=GetWorldID()
   local partner_id=""
	if hubiao.master_worldID==worldID then
	   --获得子id player_id
		local otherworld=GetWorldById(hubiao.child_worldID)
		partner_id=string.lower(otherworld:GetVariable("player_id"))
	else
		local otherworld=GetWorldById(hubiao.master_worldID)
        partner_id=string.lower(otherworld:GetVariable("player_id"))
	end
	world.Send("follow "..partner_id)
--follow zhang
--这里没有 zhang。

	wait.make(function()
	   local l,w=wait.regexp("^(> |)这里没有.*$|^(> |)你决定跟随.*一起行动。$",5)
	   if l==nil then
		   hubiao:Call_Partner_Over()
		  return
	   end
	   if string.find(l,"这里没有") then
	      wait.time(1)
		  hubiao:Call_Partner()
		  return
	   end
	   if string.find(l,"你决定跟随") then
	        --在一起 在一起
		  world.Send("follow none")
		  --回调主id 的 together
		  local cmd="/hubiao:look_che()"
		  main_Exe(cmd)
	      return
	   end
	end)

end
-- 呼叫搭档
function hubiao:Call_Partner()
   local _R=Room.new()
    _R.CatchEnd=function()
	   local count,roomno=Locate(_R)
	   print("当前房间号",roomno[1])
	   local cmd="/hubiao:Partner_to("..roomno[1]..")"
       local worldID=GetWorldID()
	   if hubiao.master_worldID==worldID then
	       --子id
		  child_Exe(cmd)
	    else
	       --主id
          main_Exe(cmd)
	    end
	end
	_R:CatchStart()
end

function hubiao:wait_stop()
    shutdown()
	--child_Exe("/hubiao.timestamp=nil")
	--hubiao.timestamp=hubiao.timestamp
	world.ColourNote("red", "yellow", os.date()..":护镖任务准备开始！！！！！！！！！！")
	local b=busy.new()
	b.Next=function()
	   if hubiao.master_worldID==GetWorldID() then
	      hubiao:main_link()
	   end
	end
	b:check()
end


function hubiao:wait_another_player()
	print("*******************内功修炼**************************")
	world.Send("unset 积蓄")
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
   --辅助id 才会执行
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
  -- sj.log_catch(WorldName()..'护镖失败记录',5)
  local worldID=GetWorldID()
   if hubiao.master_worldID==worldID then
		world.AppendToNotepad (WorldName().."_护镖任务:",os.date().." 护镖失败!!\r\n")
  end

end

function hubiao:Partner_is_ready(id)
--获得 主 id master_ready child_ready  辅助 id master_ready child_ready
--3 true 1 false 准备就绪开始任务
    print(hubiao.master_ready," ? ",hubiao.child_ready)
	print(child_master_ready," ? ",child_child_ready)
   if (hubiao.master_ready==true and hubiao.child_ready==true and child_master_ready==false and child_child_ready==true) or (hubiao.master_ready==true and hubiao.child_ready==false and child_master_ready==true and child_child_ready==true) then
      --所有 任务停止准备启动任务
	  hubiao.child_ready=false
	  hubiao.master_ready=false
      hubiao:wait_stop() --主id 停止
	  print("删除超时计时器")
	  world.DeleteTimer("hubiao_outoftime")
	  child_Exe("/hubiao:wait_stop()")
	  child_Exe("/print('删除超时计时器')")
	  child_Exe("/world.DeleteTimer(\"hubiao_outoftime\")")
	  return
   end
   --print("id:",id)
   if id=="leader" then
      print("队长等待中")
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
   print(300-wait_count*10," 等待队友倒计时!!")
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
    print("护镖等待超时!!!")
    shutdown()
	local old_jobslist=world.GetVariable("jobslist") or ""
	local jobslist=world.GetVariable("hb_jobslist") or ""
	world.SetVariable("jobslist",jobslist)
	hubiao.master_ready=false --关闭护镖的判断变量
    hubiao.child_ready=false --关闭护镖判断变量
	local hb_auto=world.GetVariable("hb_auto") or false
	if hb_auto=="true" then
	   world.AddTimer("hubiao_reset", 0, 5, 0, "SetVariable('jobslist','"..old_jobslist.."')\nprint('jobslist 设置成"..old_jobslist.."')", timer_flag.Enabled +timer_flag.OneShot+timer_flag.Replace + timer_flag.ActiveWhenClosed, "")
	   world.SetTimerOption ("hubiao_reset", "send_to", 12)
	end
	--不在做护镖任务
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
    --cond 已经ok 了
   --是否子id
   --主id 代码
   --print(hubiao.timestamp)
    world.AddTriggerEx ("hb_fail", "^(> |)由于你护镖失败，交给镖局的五十两黄金被用来赔偿了。$", "shutdown();hubiao:fail_log();Weapon_Check(process.hb)", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)

		local ts={
	           task_name="护镖",
	           task_stepname="等待伙伴",
	           task_step=0,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
		}
       	 local st=status_win.new()
	     st:init(nil,nil,ts)
	     st:task_draw_win()
        --hubiao.timestamp=os.time()

		local leader_id=world.GetVariable("hb_leader_id") or "" --队长id

		local partner_id=world.GetVariable("hb_partner_id") or ""
       if partner_id=="" or leader_id=="" then
	        print("hb_partner_id 或 hb_leader_id 变量没有设置")
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
	   --2个 id 4 组变量值
	   -- 主 id master_ready=true child_ready=true  辅助 id master_ready=false

		 print("主:",hubiao.master_worldID)
         print("辅助:",hubiao.child_worldID)
		 if hubiao.master_worldID==GetWorldID() then
            --队长id 就绪
            --hubiao.child_ready=false
			--记录护镖启动时间

			--safe_child_Exe("say 通知队友,队长就位!!!")
			local hb_cmd=world.GetVariable("hb_cmd") or ""
			if hb_cmd~="" then
			   child_Exe("/"..hb_cmd)
			end
            hubiao.master_ready=true
			child_Exe("/hubiao.master_ready=true")
			child_Exe("/hubiao:update_status()")
			hubiao:Partner_is_ready("leader")
			-- 加入等待超时 5分钟
			world.AddTimer("hubiao_outoftime", 0, 5, 0, "hubiao:wait_outoftime()", timer_flag.Enabled +timer_flag.OneShot, "")
            world.SetTimerOption ("hubiao_outoftime", "send_to", 12)
			wait_count=1
			hubiao:countdown()
            --world.DoAfterSpecial(300,"",12)
		else
			--队友id 就绪
			hubiao.child_ready=true
			main_Exe("/hubiao.child_ready=true")
			--返回值
			if hubiao.master_ready==true and hubiao.child_ready==true then
			  main_Exe("/hubiao:return_child_flag(true,true)")
			elseif hubiao.master_ready==false and hubiao.child_ready==true then
			   main_Exe("/hubiao:return_child_flag(false,true)")
			elseif hubiao.master_ready==true and hubiao.child_ready==false then
			   main_Exe("/hubiao:return_child_flag(true,false)")
			elseif hubiao.master_ready==false and hubiao.child_ready==false then
			   main_Exe("/hubiao:return_child_flag(false,false)")
			end
			--safe_main_Exe("say 通知队长就位！！！！")
			--safe_child_Exe("say 队友已就位!!!")
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
            print("*****************结束********************")
		end


end
