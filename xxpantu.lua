
--[[  向武当宋远桥领任务ask song about job，他会告诉你哪里哪
22: 里有人在捣乱，要你去看一看。到指定的地方，把robber打跑后，回
23: 到宋远桥那里即可，他会自动给你加exp与pot。
== 还剩 17 行 == (ENTER 继续下一页，q 离开，b 前一页)24:
25:     如果不能完成，需要放弃任务：ask song about 放弃，才能再领
26: 新的任务。
27:
28: ──────────────────────────────
29:                         【经验之谈】
30: ──────────────────────────────
31:
32:     首先是找robber，由于你赶过去需要时间，所以robber不一定是在
33: song告诉你的房间，你需要四周寻找一下。而一旦找到了，尤其需要
34: 注意的是：robber会主动叫杀你，如果robber没有叫杀你，来回再走动
35: 一下就可以了。不要主动叫杀robber。主动叫杀的robber会很强的。
36:
37:     *修改过后的武当任务据说分成7-10个层次，每完成一个任务，难
38: 度上升一层，任务奖励也上升一层。如果失败了一个任务，则难度下降
39: 一个层次。而且新的robber会使用perform，有些还是战斗力很高的，切
40: 切需要小心。
韦陀杵|打狗棒法|玄阴剑法|天山杖法|金刚降伏轮|弹指神通|独孤九剑|腾龙匕法

这些是比较厉害的
弹指神通|腾龙匕法|打狗棒法
这3个是2m前，中2下基本就死的技能

韦陀杵  2-10m
> 归海缑对着你说道：嘿嘿！有胆敢跟过来，大爷我不客气了！

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
   print("进程恢复")
   coroutine.resume(xxpantu.co)
end

function xxpantu:Child_checkRobber(npc,roomno)

  wait.make(function()
      world.Execute("look;set action 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)设定环境变量：action \\= 1",6)
	  if l==nil then
		self:Child_checkRobber(npc,roomno)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
	      --没有找到
		  self:Child_NextPoint() --找下一个房间
		  return
	  end
	  if string.find(l,npc) then
	     --找到
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
   print("子进程恢复")
   coroutine.resume(xxpantu.co2)
end

--20个普通方向
local function returnPath(dx)
  --掉头
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

local function reverse_path(path) --颠倒路径
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
      local l,w=wait.regexp("^(> |)设定环境变量：action \\= 1",6)
	  if l==nil then
		self:quick_checkRobber(alias_txt)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
	      print("逆转结束")
		  self:Child_NextPoint()
		  return
	  end
   end)

end

function xxpantu:auto_pfm()
   print("提前pfm")
end

function xxpantu:Child_Search(rooms,npc)
     local zone=partition(self.location)

	  --print("房间名称:",self.look_robber_place)
	  local zz=""
	 --local zone=partition(location)
	 for _,z in pairs(zone) do
	     print(z.zone)
	    if Trim(z.zone)~="" then
		   zz=z.zone
		   break
		end
	 end
	-- print("check 区域:",zz..Trim(self.look_robber_place))
	local P=zz..Trim(self.look_robber_place)
-- 丝绸之路 排除掉
    local is_reverse_ok=true
 local location=world.GetVariable("robber_place")
	location=Trim(location)
   if location=="山涧" or location=="丝绸之路" or location=='树林深处' or location=="树林" or location=="大草原" or location=="沙滩" or location=="小岛" then
      is_reverse_ok=false  --不满足可逆条件
   end
   if P=="兰州城大道" or P=="嵩山山路" or P=="杭州城山路" then
      is_reverse_ok=false  --不满足可逆条件
   end

   local n=table.getn(rooms)
   print("需要搜索房间数量:",n)
   if n>1 and is_reverse_ok==true then
      local i=self.section
	  local startroomno=self.sections[i].startroomno
	  local endroomno=self.sections[i].endroomno
	  local s=self.sections[i].alias_paths
	  print(s," 多个房间符合:",startroomno,"->",endroomno)
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
--south;north;north;north;north;north;north;northeast;northeast;north;north  多个房间符合: 193 -> 341
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
			print("进程恢复")
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
	if string.find(self.look_robber_place,"渡船") then
		print("强盗在渡船中")
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
	    print("计数器:",n)
		self.NextPoint2=function() al:zishanlin_tiandifenglei(n) end
		self:Child_checkRobber(npc,2464)
	end

	al.circle_done=function()
		print("遍历")
		self.NextPoint2=function() coroutine.resume(al.circle_co) end

		self:Child_checkRobber(npc,998)
	end]]

	al.break_in_failure=function()
		--self:giveup()
		self:Child_NextPoint()
	end
	w.user_alias=al

   for _,r in ipairs(rooms) do

           print("点检房间号:",r)
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

	 --黄河渡船
	 --渡船
	 local target_room={}

      --print("房间名称:",look_robber_place)
	  --self.look_robber_place=look_robber_place
	  --self.location=location
	 local zz=""
	 local zone=partition(self.location)

	  print("房间名称:",self.look_robber_place)
	 --local zone=partition(location)
	 for _,z in pairs(zone) do
	     print(z.zone)
	    if Trim(z.zone)~="" then
		   zz=z.zone
		   break
		end
	 end
	 self:auto_pfm()
	 print("check 区域:",zz..Trim(self.look_robber_place))
	  local n,e=Where(zz..Trim(self.look_robber_place)) --检测房间名
      if table.getn(e)==0 then
	     n,e=Where(Trim(self.look_robber_place)) --检测房间名
	  end
	  for _,r in ipairs(e) do
		  print("回溯房间号1:",r)
	      table.insert(target_room,tonumber(r))
	  end
       print("子进程")
      if self.section==nil then
	     self.section=1
	  end
	   if self.section>1 then
	       self.section=self.section-1 --后退一格
		else
		   self.section=table.getn(self.sections)
	    end
	    print("主进程回退一格:",self.section)

	   self:check_next_point(target_room)
end

function xxpantu:check_next_point(target_room)
      xxpantu.co2=coroutine.create(function()
		 -- 回到主进程上去
             self:Child_Search(target_room,self.robber_name)

		   print("回到主进程上去!")
		   xxpantu.co2=nil
		   self:robber_exist()
		   self:check_section()

	   end)
	   self:Child_NextPoint()
end

function xxpantu:combat()

end

function xxpantu:run(i)
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
	      self:run(i)
	      return
	   end
	   if string.find(l,"你的修为不够") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"你的动作还没有完成，不能移动") or string.find(l,"你逃跑失败") or string.find(l,"暂时无法停止战斗") then
		  self:run(i)
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
		 world.DoAfter(1.5,"set action 结束")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"逃跑\\\"$|^(> |)设定环境变量：action \\= \\\"结束\\\"$",5)
			if l==nil then
			   self:run(i)
			  return
			end
			if string.find(l,"逃跑") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"结束") then
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
	 print(run_dx, " 方向")
	 local halt
	 if _R.roomname=="洗象池边" then
	    world.Send("alias pfm "..run_dx..";set action 逃跑")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set action 逃跑")
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
--> 谯易对着你发出一阵阴笑，说道：臭贼，这里地方太小，有种跟老子到外面比划比划！
--> 祖廉风对你说道：老匹夫！穷追不舍，既然逃不掉，大爷我跟你拼了！
--益汝鄢往北面的书房离开。
function xxpantu:auto_kill()
--你对着司徒蒋大喝一声：「老匹夫！我就是人贱人爱！贱~~贱~~魔无敌！！(-。-)y-゜゜゜"！」
   wait.make(function()
      local l,w=wait.regexp("^(> |)(.*)对着你发出一阵阴笑，说道：既然被你这个.*，那也就只能算你命短了！|^(> |)(.*)对着你说道：嘿嘿！有胆敢跟过来，.*$|^(> |).*对着你发出一阵阴笑，说道：臭贼，这里地方太小，有种跟.*到外面比划比划！$|^(> |)(.*)对你说道：.*！穷追不舍，既然逃不掉，.*我跟你拼了！$|^(> |)你对着"..self.robber_name.."大喝一声：.*$|^(> |)你对着"..self.robber_name.."喝道：.*$",10)
      if l==nil then
	    self:auto_kill()
		return
	  end
	  if string.find(l,"这里地方太小") then
	      shutdown()

		    local _R
            _R=Room.new()
			_R.CatchEnd=function()
               local count,roomno=Locate(_R)
			   local target_room=depth_search(roomno,1)  --1格范围查询
		       print("npc 在安全房间")
			   print("子进程")
	          xxpantu.co2=coroutine.create(function()
                self:Child_Search(target_room,self.robber_name)
		        --回到主进程上去
				xxpantu.co2=nil
				print("回到主进程上去!")
		        self:robber_exist()
		        self:check_section()
	          end)
	          self:Child_NextPoint()
			end
			_R:CatchStart()
	      return
	  end
	  if string.find(l,"那也就只能算你命短了") or string.find(l,"有胆敢跟过来") or string.find(l,"既然逃不掉") or string.find(l,"你对着") then
		 self:auto_pfm()
	    local killshou=Trim(w[2])
		if killshou==nil or killshou=="" then
		    killshou=Trim(w[4])
		end
		if killshou==nil or killshou=="" then
		    killshou=Trim(w[7])
		end
		print("name:",killshou," 杀手:",self.robber_name)
		if string.find(self.robber_name,killshou) then
		 if combat_start_time then
	       combat_usedtime = os.difftime (os.time(), combat_start_time)
		   if combat_usedtime<10 then
		      print("已经进入战斗状态!!")
			  return
		   end
		 end
		   shutdown()
		    local ts={
	           task_name="星宿叛徒",
	           task_stepname="KO强盗",
	           task_step=4,
	           task_maxsteps=5,
	           task_location=self.location.." 方圆:"..self.depth,
	           task_description=self.robber_name.." 门派:"..self.menpai.." 技能:"..self.skills,
	        }
			local st=status_win.new()
		   st:init(nil,nil,ts)
		   st:task_draw_win()
		   self:get_id(self.robber_name)
		   self:robber_finish()

		   combat_start_time=os.time()
		   local interval=os.difftime(os.time(),search_start_time)

		   --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 搜索时间！"..interval.." "..self.location.." depth:"..self.depth.."\r\n")
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
   print("强盗发呆!!")
   self.kick_count=self.kick_count+1
   if self.kick_count>30 then
       print("超过30次上限")
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
   print("等待五秒,来回移动下!")
   f_wait(f,5)
end

local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    print("当前房间:",v)
	    if v==r then
		   print("相同")
		   return true
		end
	end
	print("不同")
	return false
end

--这里没有这个人。
function xxpantu:kill_robber(id)

      wait.make(function()
       --world.Send("follow "..id)
	    --print("有无危险动物或npc:",self.beast_kill)

		--if self.beast_kill==false then
		    world.Send("kill "..id)
			--self:auto_pfm()--你对着涂钦柳章猛吼一声：「臭贼！明年的今天就是你的祭日，让大爷我送你上路吧！！」
		  local l,w=wait.regexp("^(> |)你对着.*(大喝|猛吼)一声：.*$|^(> |)加油！加油！$|你对着.*喝道：.*$|^(> |)你正要有所动作，突然身旁有人将你一拍：好好看比武，别乱动！$|^(> |)这里没有这个人。$|^(> |)这里不准战斗。$|^(> |)这里没有 "..id.."。$",2)
		  if l==nil then
		    self:kill_robber(id)
		    return
		  end
		  if string.find(l,"大喝一声") or string.find(l,"猛吼") or string.find(l,"加油") or string.find(l,"喝道") then
		    --combat_start_time=os.time()
			--local interval=os.difftime(os.time(),search_start_time)

		   --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 搜索时间！"..interval.." "..self.location.." depth:"..self.depth.."\r\n")
			  world.Send("look")
			  self:look()
			--world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 战斗开始！\r\n")
			self:robber_finish()
			self:combat()
	        self:sure_robber()
	        return
	      end
	      if string.find(l,"你正要有所动作") then
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
	      if string.find(l,"这里没有这个人") or string.find(l,"这里没有") then
	        --self:NextPoint()
			 --if xxpantu.co2~=nil then
			 --   self:Child_NextPoint()
             --else
			  self:robber_exist()
			  self:check_section()
			 --end
	        return
		  end
	      if string.find(l,"这里不准战斗") then
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
	   local l,w=wait.regexp("^(> |)(.*) -.*|^(> |)【你现在正处于(.*)】$",5)
	   if l==nil then
	      --self:look()
	      return
	   end
	   if string.find(l,"你现在正处于") then

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
		    relation=string.gsub(relation,"%-%-%-%-%-","─")
	       relation=string.gsub(relation,"%-%-%-%-","─")
	       relation=string.gsub(relation,"%-%-%-","─")
	       relation=string.gsub(relation,"%-%-%s*","─")
           relation=string.gsub(relation,"%s*%←","←")
	       relation=string.gsub(relation,"%s*%→","→")

	       relation=string.gsub(relation,"%-%-","─")
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
		  print("保存战斗房间号:",roomno[1])
		   _G["fight_Roomno"]=roomno[1]
	      return
	   end
	end)
end

function xxpantu:checkRobber(npc,CallBack)

  wait.make(function()
      world.Execute("look;set action 1")
	  self:look()
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)设定环境变量：action \\= 1$",6)
	  if l==nil then
		self:checkRobber(npc,CallBack)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
	       if self.look_robber==true then --路上经过
		     self.look_robber=false--只检查一次
			 print("路上经过")
			 self:Check_Point_Robber()--点检 点检完毕 回到section起始房间

		   else
             if CallBack==nil then
			   self:check_section()
			 else
			   print("迷宫")
			   CallBack()
			 end
			  --
		   end
		  return
	  end

	  if string.find(l,npc) then
	      print("找到")
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
       print("起始房间:",roomno)

      if is_contain(roomno,here) or is_omit==true then
	       print("确定到达出发点->Next Room")
		   --self.is_checkPlace=false
		   self.check_place_count=0
		   local b
		   b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      print("执行")
		      local i=self.section
			  local s=self.sections[i]
		      local tr=traversal.new()

			 --self.rooms={}
			--[[  local ex_rooms={}
               ex_rooms=Split(self.sections[i].alias_rooms,";")
             for _,g in ipairs(ex_rooms) do
		       if g~=nil then
			     print("插入房间号:",g)
				 if self.exist_rooms[g]==true then
				   print("已经插入过！",g)
				 else
                   table.insert(self.rooms,g)
				 end
	           end
             end]]

			  local al=alias.new()
			  al:SetSearchRooms(self.rooms)
			  al.break_in_failure=function()
			      print("无法进入,跳过路径")
			      self.section=self.section+1 --步进
				  self:checkRobber(self.robber_name)
			  end
			   al.xidajie_mingyufang=function()
                  world.Send("north")
                  wait.make(function()
                  local l,w=wait.regexp("^(> |)鸣玉坊.*|小朋友不要到那种地方去！！",5)
	              if l==nil then
	                al:finish()
	                return
				  end
	              if string.find(l,"小朋友不要到那种地方") then
				     print("无法进入妓院，重新生成遍历路径！")
				     local n,e=Where(self.location)
	                 self:c_paths(e,self.depth,"xidajie_mingyufang",true)
	                 return
	              end
				  if string.find(l,"鸣玉坊") then
	                 al:finish()
					 return
	              end
                  end)
               end
			  --  晚上无法进入的房间 伊犁  扬州酒店 湖滨小酒店
			  al.waitday_south=function() --湖滨小酒馆
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==1068 then
	                   al:finish()
	               elseif roomno[1]==1065 then
						print("无法进入,跳过路径")
						self.section=self.section+1 --步进
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
	               print("当前房间号",roomno[1])
	               if roomno[1]==109 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("无法进入,跳过路径")
						self.section=self.section+1 --步进
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
	               print("当前房间号",roomno[1])
	               if roomno[1]==111 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("无法进入,跳过路径")
						self.section=self.section+1 --步进
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
	               print("当前房间号",roomno[1])
	               if roomno[1]==2349 then
					   table.insert(self.rooms,2349)
					    self.exist_rooms[2349]=true
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("无法进入,跳过路径")
						self.section=self.section+1 --步进
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
			      print("跳过路径")
			      self.section=self.section+1 --步进
				  self:checkRobber(self.robber_name)
			  end
			 --[[ al.circle_done=function()
		         print("遍历")
		         local f2=function()
				    coroutine.resume(alias.circle_co)
			     end
			     self:checkRobber(self.robber_name,f2)
		      end]]
			  ---
		    al.songlin_check=function()
			  print("迷宫check npc")
	          local f2=function() al:NextPoint() end
			  self:checkRobber(self.robber_name,f2)
			end
			al.maze_done=function()
			   print("迷宫check npc")
			   local f2=function() al.maze_step() end
			   self:checkRobber(self.robber_name,f2)
			end
			--[[al.zishanlin_check=function()
			   print("紫杉路check")
	          local f2=function() al:NextPoint() end
			  self:checkRobber(self.robber_name,f2)
		    end
			al.zishanlin2_check=function()
			   --print("计数器")
			   print("紫杉路2check")
	          local f2=function() al:zishanlin_tiandifenglei() end
			  self:checkRobber(self.robber_name,f2)
		    end]]
			  ---
			  tr.user_alias=al
			  tr.step_over=function()
			     --检查强盗
				 print("检查强盗")
			     self:checkRobber(self.robber_name)
			  end
			  self.section=self.section+1 --步进
	          tr:exec(s) --队列
		   end
		   b:check()
	   else
	   --没有走到指定房间
	     print("没有走到指定房间")
         self.check_place_count=self.check_place_count+1
		 if self.check_place_count>3 then
		    --self.check_place_count=0
			print("连续3次失败 放弃！")
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
		    --  晚上无法进入的房间 伊犁  扬州酒店 湖滨小酒店
			  al.waitday_south=function() --湖滨小酒馆
				 world.Send("south")
				 local _R
				 _R=Room.new()
                 _R.CatchEnd=function()
                   local count,roomno=Locate(_R)
	               print("当前房间号",roomno[1])
	               if roomno[1]==1068 then
	                   al:finish()
	               elseif roomno[1]==1065 then
						print("无法进入,跳过路径")
						--self.section=self.section+1 --步进
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
	               print("当前房间号",roomno[1])
	               if roomno[1]==109 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("无法进入,跳过路径")
						--self.section=self.section+1 --步进
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
	               print("当前房间号",roomno[1])
	               if roomno[1]==111 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("无法进入,跳过路径")
						--self.section=self.section+1 --步进
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
	               print("当前房间号",roomno[1])
	               if roomno[1]==2349 then
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("无法进入,跳过路径")
						--self.section=self.section+1 --步进
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
       print("巡逻完成一次")
	   print(self.round," 次数")
	   if self.round>3 then
	       self:giveup()
		   return
	   else

	       self.round=self.round+1
		   self.section=1
	       i=1
	   end
	else
	   print("继续巡逻")
	   print(i)
	end
	local aim_roomno=sections[i].startroomno
	local f=function(r)
		 self:checkPlace(aim_roomno,r)
	end
	WhereAmI(f,10000) --排除出口变化
end

function xxpantu:Search(paths,rooms,npc)
    self.round=1
	--world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 开始搜索\r\n")
	-- CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:开搜搜索", "blue", "black") -- yellow on white
    self.is_checkPlace=true
	self:robber_exist()
	--print("paths",paths)
	local tr=traversal.new()
	self.sections=tr:fast_walk(paths,rooms) --队列
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
		    --print("显示相关的房间号:",e)
	   end
	end
	 --print("------end-------")
	al:SetSearchRooms(_r2)
	al.noway=function()
	   self:giveup()
	end
	al.maze_done=function()
	   print("xxpantu 执行搜索迷宫")
	   self:checkRobber(self.robber_name,al.maze_step)
	end
	al.nanmen_chengzhongxin=function()
		if self.look_robber==true then --路上经过
		     self.section=1 --路段
		     self.look_robber=false--只检查一次
			 print("路上经过")
			 self:Check_Point_Robber()--点检 点检完毕 回到section起始房间
		else
			world.Send("north")
            local _R
            _R=Room.new()
            _R.CatchEnd=function()
               local count,roomno=Locate(_R)
	           print("当前房间号",roomno[1])
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
	    ---执行前 先 check roomno
	    self.section=1 --路段
		self.rooms={}
		self.exist_rooms={}
		local ex_rooms={}
        ex_rooms=Split(self.sections[1].alias_rooms,";")
       for _,g in ipairs(ex_rooms) do
		   if g~=nil then
		      --print("插入房间号:",g)
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
	w:go(tr.startroomno)	--走到起始房间
end

function xxpantu:c_paths(e,depth,omit,opentime)
  depth=depth+4
  local paths,rooms=depth_path_search(e,depth,omit,opentime)  --搜索路径 房间号
  --print(paths)
   print(rooms)
   print("需要遍历房间")
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
	           task_name="星宿叛徒",
	           task_stepname="找强盗",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=self.location.." 方圆:"..self.depth,
	           task_description=self.robber_name.." 门派:"..self.menpai.." 技能:"..self.skills,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --print("robber ",location," ",depth," ",npc)

   local n,e=Where(location)

   --print(n)
   if n==0 then
       print("不存在该房间！！")
       self:giveup()
       return
   end
   local party=world.GetVariable("party") or ""
	local mastername=world.GetVariable("mastername") or ""
   local omit=""
   if string.find(location,"襄阳城") or string.find(location,"华山村") then
        --fengyun、longhu、north 和 tiandi
      omit="fengyun|longhu|tiandi|xiaoxi_dufengling|huigong|dujiang"
   end
   if string.find(location,"绝情谷") then
      omit="dufengling_xiaoxi"
   end
   if string.find(location,"嵩山少林") then
      omit="duanyaping_yading|qingyunpin_fumoquan|duhe"
   end
   if string.find(location,"天山") then
      omit="baizhangjian_xianchoumen|xianchoumen_baizhangjian|t_leave|R3108|shanjian_longtan"
   end
   if string.find(location,"佛山镇") then
      omit="dujiang"
   end
   if string.find(location,"塘沽城") then
      omit="shatan_shenlongdao"
   end
   if string.find(location,"神龙岛") then
      omit="shenlongdao_shatan"
   end
   if string.find(location,"峨嵋山") then
      omit="houshanxiaolu_guanmucong|R1712"
   end
   if string.find(location,"兰州城") then
      omit="duhe|shamo_qingcheng|climb_shanlu"
   end
  if string.find(location,"苏州城") then
      omit="dujiang|beimenbingying_jianyu|yamendating_yamenzhengting|bingyingdamen_bingying|ll_sl"
   end
   if string.find(location,"宁波城") then
      omit="haibing_taohuadao"
   end
   if string.find(location,"武当山") then
     --if party=="武当派" and mastername=="张三丰" then
       omit="xiaojing2_xiaojing1|xiaojing2_yuanmen|yitiantulong|dujiang|holdteng|zuanshulin|dujiang|holdteng"
	 --else
       --omit="yitiantulong|dujiang|holdteng"
     --end
   end
   if string.find(location,"恒山") then
      omit="duhe|shamo_lvzhou|R6154"
   end
   if string.find(location,"铁掌山") then
     omit="zoulang_shufang|movebei"
   end
   if string.find(location,"星宿海") then
     omit="zuan|push_door|zhenyelin|chengzhongxin_nanmen|nanmen_chengzhongxin|dacaoyuan_yingmen|shamo_caoyuanbianyuan"
   end
   if string.find(location,"福州城") then
      omit="swim"
   end
   if string.find(location,"天龙寺") then
      omit="dangtianmen_xiuxishi"
   end
   if string.find(location,"成都城") then
      omit="shamo_qingcheng|xiaoxi_dufengling|dufengling_xiaoxi"
   end
   if string.find(location,"宁波城") or string.find(location,"牛家村") then
      omit="haibing_taohuadao"
   end
   --
   if string.find(location,"曼佗罗山庄") or string.find(location,"姑苏慕容") or string.find(location,"燕子坞") then
      omit="xiaodaobian_matou|quyanziwu|tanqin|qumr|yellboat|zuan_didao|didao|jump liang|yanziwu|push_qiaolan|shanzhuang|xiaodao"
   end
   if string.find(location,"明教") then
     omit="juyiting_longwangdian|zishanlin_ruijin|tiandifenglei_feng|tiandifenglei_di|tiandifenglei_tian|tiandifenglei_lei|west_zishanlin_tiandifenglei_quick|east_zishanlin_tiandifenglei_quick" --zishanlin_search|
     if Trim(location)=="明教树林" then
        table.sort(e,function(a,b) return a>b end) --重新排序
		depth=5
	 elseif Trim(location)=="明教广场" then
	    omit=omit.."|zishanlin_zishanlin2_quick"
     end
  end
   if string.find(location,"逍遥派") then
      omit="push_door|shamo_caoyuanbianyuan|shamo_sichouzhilu|xingxiuhai_north|nanmen_chengzhongxin|R2064|R1965|R3875"
	  if string.find(location,"逍遥派林间小道") then
          e={4238}

	  end
   end
   if string.find(location,"长安城") then
      omit="changjie_changjie|caidi_cunzhongxin|changjie_nandajie|R651|shamo_lvzhou|duhe"

   end
   if string.find(location,"黄河流域") then
      omit="xiaofudamen_xiaofudating|duhe"
	 if string.find(location,"黄河流域黄河岸边") then
	    e={742,760,761,762,763,764,765}

     end
	 depth=8
   end
   if string.find(location,"丐帮") then
      omit="dujiang|beimenbingying_jianyu|yamendating_yamenzhengting"
	  e={1001}
   end

   if string.find(location,"武当后山") then
      omit="jump_river|pa ya"
   end
   if string.find(location,"扬州城") then
      omit="dujiang"
   end

   if string.find(location,"杭州城") then
      omit="enter_meizhuang|yamendating_yamenzhengting|bingyingdamen_bingying"
	  if string.find(location,"山路") then
	    omit=omit.."|changlang_huanglongdong"
	  end
   end
   if string.find(location,"大理城") then
      omit="yuren"
   end
   if string.find(location,"伊犁城") then
       omit="zhenyelin|shamo_sichouzhilu|shamo_caoyuanbianyuan|R2064|R2049"
   end
   if string.find(location,"苗疆") then
      --if wdj.wdj2_ok==false or wdj.wdj2_ok==nil then

	     if string.find(location,"苗疆山路") then
		    if wdj.wdj2_ok==true then
	          n=8
		      e={3157,3187,3196,3197,3198,3199,3200,3202}
		    else
			   self:giveup() --五毒教不进入直接放弃
			   return
			end
		 end
	      omit="shanjiao_shanlu"
	  --end
   end
   if string.find(location,"福州城") then
      local al=alias.new()
	  al.finish=function(result)
	     --print(result," 结果")
	     self:c_paths(e,depth,omit,result)
	  end
	  al:opentime("fuzhouchengnanmen")
	  return
   end
   if string.find(location,"华山石屋") then
		e={1508}
   end
   if string.find(location,"莆田少林") then
      omit="knockgatesouth|opengatenorth"
   end
	if string.find(location,"华山") then

      omit="shiguoya_shiguoyadongkou|siguoya_jiashanbi"
   end
   local sindex,eindex=string.find(location,"大草原")
   if sindex==1 then
      e={2438}
   end
   if string.find(location,"回疆") then
      omit="caoyuanbianyuan_heishiweizi|dacaoyuan_yingmen|zhenyelin|nanmen_chengzhongxin|R2049|R1965|R4994|caoyuanbianyuan_heishiweizi"
   end
   if string.find(location,"黑木崖") then
      omit="yading_riyuepin|riyuepin_yading"
   end
   if string.find(location,"归云庄") then
      omit="hubinxiaolu_hubinxiaolu|hubinxiaolu_guiyunzhuang|east_taohuazhen"
   end
   if string.find(location,"武当山") then
     omit="xiaojing_xiaojing1|xiaojing2_xiaojing1"
   end
     if string.find(location,"紫杉林") then
	  e={2466,2461,2462,2464,2465,3041}
	end
    if string.find(location,"无量山") then
      omit="songlin1_songlin2"
   end
   --print("omit:",omit)
  -- self:c_paths(e,depth,omit,true)
   if string.find(location,"平定州") then
      omit="duhe|dutan|shamo_lvzhou"
   end
   self:c_paths(e,depth,omit,true) --固定范围
end

--[[function xxpantu:robber(location,depth,npc)

    local round=1
	local ts={
	           task_name="武当",
	           task_stepname="找强盗",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=self.location.." 方圆:"..self.depth,
	           task_description=self.robber_name.." 门派:"..self.menpai.." 技能:"..self.skills,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --print("robber ",location," ",depth," ",npc)
   local n,e=Where(location)
   print("房间数目:",n)
	local rooms=depth_search(e,tonumber(depth))  --范围查询
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
	   print("抓取")
	   xxpantu.co=coroutine.create(function()
		 print(table.getn(rooms),"房间数")
        self:Search(rooms,npc)
		print("没有找到npc!!")
		if  table.getn(rooms)<=40 and round==1 then
		   print("重新尝试一次")
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
	  print("没有目标")
	  self:giveup()
	end
end]]

function xxpantu:robber_die() --跑了
end

function xxpantu:roober_die2()  --死了
end

function xxpantu:robber_finish()

--了沈大喊一声：不好！！转身几个起落就不见了。
--白瑛「啪」的一声倒在地上，挣扎着抽动了几下就死了。婷霞大喊一声：不好！！转身几个起落就不见了。
--乐徐「啪」的一声倒在地上，挣扎着抽动了几下就死了。
   wait.make(function()
      local l,w=wait.regexp("^(> |)(.*)大喊一声：不好！！转身几个起落就不见了。|^(> |)(.*)「啪」的一声倒在地上，挣扎着抽动.*|^(> |)(.*)大喊一声：.*不奉陪了！转身几个起落就不见了。$",10)
	  if l==nil then
	     self:robber_finish()
		 return
	  end
	   if string.find(l,"不奉陪") then
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
	  if string.find(l,"转身几个起落就不见了") then
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
	  if string.find(l,"一声倒在地上") then
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
	  if string.find(l,"不奉陪") then
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
       world.Send("ask song yuanqiao about 放弃")
       wait.make(function()
	   --宋远桥说道：「叶知秋，你又没在我这里领任务，瞎放弃什么呀！」
	   --宋远桥说道：「叶知秋，你又没在我这里领任务，瞎放弃什么呀！」
	      local l,w=wait.regexp("^(> |)宋远桥说道：「"..self.playname.."，你又没在我这里领任务，瞎放弃什么呀！」$|^(> |)宋远桥说道：「"..self.playname.."，你太让我失望了，居然这么点活都干不好，先退下吧！」$|^(> |)宋远桥说道：「"..self.playname.."，这个任务确实比较难完成，下次给你简单的，先退下吧！」$",5)
		  if l==nil then
		     self:redure_difficulty()
		     return
		  end
		  if string.find(l,"瞎放弃什么呀") then
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
    if strong=="不足为虑" then
	   _diff= 1
	elseif strong=="颇为了得" then
	   _diff=2
	elseif strong=="极其厉害" then
	   _diff=3
	elseif strong=="已入化境" then
	   _diff=4
	else
	   _diff=1
	end
	if self.difficulty=="" then
	   self.difficulty=1
	end
	 print("控制难度:",self.difficulty,"  ?> 当前难度",_diff)
    if tonumber(self.difficulty)>=_diff  then
	    self:robber(self.location,self.depth,self.robber_name)
    else --降低难度
		--self:redure_difficulty()
		self:giveup()-- 直接放弃
	end
end

function xxpantu:npc_strong()

   wait.make(function()
      local l,w=wait.regexp("^(> |)丁春秋在你的耳边悄声说道：此人的武功(.*)，你可得小心对付哦。$|^(> |)设定环境变量：ask \\= \\\"YES\\\"$",5)
	  if l==nil then
	     self:npc_strong()
		 return
	  end
	  if string.find(l,"丁春秋在你的耳边悄声说道") then
	     local strong=w[2]
		 self.strong=strong
		 print("强度")
	     --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 武功强度:"..strong.."\r\n")
		  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:难度 "..strong, "red", "black") -- yellow on white
		 --self.robber_name=npc 星宿派的叛徒，尤为擅长天山杖法的功夫。
		 if self:deal_blacklist(self.skills,self.menpai)==true then
			--world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 黑名单技能直接放弃\r\n")
			 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:黑名单技能,放弃", "red", "black") -- yellow on white
		    self:giveup()
		    return
		 end
		 print("难度控制:",strong)
		 self:select_difficulty(strong)
	    return
	  end
	  if string.find(l,"设定环境变量：ask") then --难度确定
        self.strong=""
		print("普通难度")
		--world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 武功强度:普通".."\r\n")
		 -- CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:难度 普通", "white", "black") -- yellow on white
		 --self.robber_name=npc 星宿派的叛徒，尤为擅长天山杖法的功夫。
		 if self:deal_blacklist(self.skills,self.menpai)==true then
		    --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 黑名单技能直接放弃\r\n")
			 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:黑名单技能,放弃", "red", "black") -- yellow on white
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
	  print("发现地点:",location," npc id:",self.robber_id)
	  --world.DeleteVariable("beauty_place")
	  return
    end
	wait.time(5)
  end)
end

function xxpantu:gongfu(npc,location,depth)

   if zone_entry(location)==true then
      --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 无法进入"..location.."直接放弃\r\n")
      self:giveup()
      return
   end
    wait.make(function()
	--宋远桥在你的耳边悄声说道：据门派弟子来报，此人是来自天龙寺的叛徒，尤为擅长一阳指的功夫。
	--宋远桥在你的耳边悄声说道：老头子已追查到此人是我武当出身，尤为擅长玄虚刀法的功夫。
	  local l,w=wait.regexp("^(> |)丁春秋在你的耳边悄声说道：据门派弟子来报，此人是来自(.*)的.*，尤为擅长(.*)的功夫。|^(> |)丁春秋在你的耳边悄声说道：老头子已追查到此人是我(.*)出身，尤为擅长(.*)的功夫。",5)
	  if l==nil then
	     self:ask_job()
		 return
	  end
	  if string.find(l,"丁春秋在你的耳边悄声说道") then
	     self:npc_strong()
		 self.menpai=w[2]
		 self.skills=w[3]
		 if self.menpai==nil or self.menpai=="" then
		    self.menpai=w[5]
			self.skills=w[6]
		 end
		 if location=="中原神州龙门镖局" then
		    location="龙门镖局"
		 end
		 if location=="中原神州陈列室" then
		    localtion="巫师雕像陈列室"
		 end
		 self.location=location
		 self.depth=depth
		 print("门派:",self.menpai," 功夫:",self.skills)
		 --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 地点:"..location.." 方圆:"..depth.."\r\n")
		 --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 门派:"..self.menpai.." 功夫:"..self.skills.."\r\n")
		 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:"..location.." "..self.menpai.." "..self.skills, "white", "black") -- yellow on white
         self:sure_enemy_skill()  --根据npc 技能不同使用不同对应pfm
	     return
	  end


	end)
end

function xxpantu:sure_enemy_skill() --回调函数
end

function xxpantu:fail(id) --回调函数

end


--[[宋远桥在你的耳边悄声说道：据说河南土匪管平顾正在
     :   :   .   .............:.         :           `.. .......:.
`````:```:`````       : .......          :          :  `        :
     `   `  .     :```: :..:..:   .......:.....:.   :           :
  :````:````:`    :    .:..:..:.        .`.         :           :
  :    :    :     `:``: .......         : `.        :           :
  :````:````:     `:` : :..:..:        :   `.       :           :
  :    :    :    ..`` : :..:..:      .`      `...   :           :
  :`````````:       `.`.........   ``          `    :         `.`
周围方圆一里之内捣乱，你马上去给我巡视一圈。
周围方圆四里之内捣乱，你马上去给我巡视一圈。
]]
function xxpantu:bigword()
    new_bigword()
	world.AddTriggerEx ("bigword1", "^(.*)$", "get_bigword(\"%1\")", trigger_flag.Enabled + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 1001)
	world.SetTriggerOption ("bigword1", "group", "bigword")

	wait.make(function()
	   local l,w=wait.regexp("^周围方圆(.*)里之内捣乱，你马上去给我巡视一圈。$|^捣乱，你马上去给我巡视一圈。$",10)
	   if string.find(l,"你马上去给我巡视一圈") then
	      world.EnableTriggerGroup("bigword",false)
		  world.DeleteTriggerGroup("bigword")
		  print("方圆:",w[1])
		  local deep=w[1]
		  if deep==nil or deep=="" then
		     deep="五"
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
  print("名字:",self.robber_name," 地点:",place," 范围:",deep)
  local depth=ChineseNum(deep)+1
  self:gongfu(self.robber_name,place,depth)
end

function xxpantu:test(w1,w2,w3)
 --print( 地点:",w[1]," 范围:",w[2],"名字:",w[3],")
--成都城关帝庙 方圆:6
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

丁春秋对着你点了点头。
丁春秋在你的耳边悄声说道：据说星宿叛徒大轮寺的淑盈正在襄阳城山间小路捣乱，你马上去给我巡视一圈。
丁春秋在你的耳边悄声说道：据门派弟子来报，此人是来自大轮寺的高手，尤为擅长无上大力杵的功夫。
丁春秋说道：「你快去快回，一切小心啊。」
]]

   wait.make(function()
        local l,w=wait.regexp("^(> |)丁春秋在你的耳边悄声说道：据说星宿叛徒.*的(.*)正在(.*)周围方圆(.*)里之内捣乱，你马上去给我巡视一圈。$|^(> |)丁春秋在你的耳边悄声说道：据说星宿叛徒.*的(.*)正在(.*)捣乱，你马上去给我巡视一圈。$|^(> |)丁春秋说道：「你刚做完(.*)任务，还是先(去|)休息一会吧。」$|^(> |)丁春秋说道：「现在暂时没有适合你的工作。」$|^(> |)宋远桥在你的耳边悄声说道：据说(.*)正在$|^(> |)丁春秋说道：「我不是告诉你了吗，有人在捣乱。你就快去吧！」$|^(> |)丁春秋说道：「.*的正气还不够，我无法放心让你做这个任务！」$",5)
		  if l==nil then
		     self:ask_job()
		     return
		  end
		  if string.find(l,"休息一会吧") then
		     print(w[9])
		     if w[9]=="星宿叛徒" then
		      self.fail(101)
			 else
			  self.fail(102)
			 end
		     return
		  end
		  if string.find(l,"现在暂时没有适合你的工作") then
		     --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 现在暂时没有适合的工作！\r\n")
			  --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:没有合适工作！", "red", "black") -- yellow on white
		     self.fail(102)
		     return
		  end
		  if string.find(l,"你马上去给我巡视一圈") then
		     --search_start_time=os.time()
			 print("名字:",w[2]," 地点:",w[3]," 范围:",w[4])
			 local name=w[2]
			 local place=w[3]
			 local deep=w[4]
			 if name==nil or name=="" then
			   print("名字:",w[6]," 地点:",w[7])
			   name=w[6]
			   place=w[7]
			   deep="五"
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
		  if string.find(l,"丁春秋在你的耳边悄声说道") then
		     print("13 ",w[13])
			 local name=Trim(w[13])
			  name=string.sub(name,9,-1)
			  print("name:",name)
			  self.robber_name=name
		     self:bigword()
		     return
		  end
		  if string.find(l,"我不是告诉你了吗，有人在捣乱。你就快去吧") then
		     --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 无法知晓所在地点,放弃！\r\n")
			 --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:无法知晓所在地点,放弃", "red", "black") -- yellow on white
		     self:giveup()
		     return
		  end
		  if string.find(l,"正气还不够") then
		     self:look_zhengqidan()
		  end
		  wait.time(5)
    end)
end

function xxpantu:ask_job()
	local ts={
	           task_name="星宿叛徒",
	           task_stepname="询问丁春秋",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 武当job开始!\r\n")
     --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:工作开始!", "yellow", "black") -- yellow on white
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
	 虚第看见你走过来，神色有些异常，赶忙低下了头。
你忍不住想狠狠踢(kick)这个家伙一脚。
宋远桥在你的耳边悄声说道：据说西南草寇薛叶风正在大雪山雪谷周围方圆三里之内捣乱，你马上去给我巡视一圈。
宋远桥在你的耳边悄声说道：据门派弟子来报，此人是来自桃花岛的高手，尤为擅长弹指神通的功夫。
宋远桥在你的耳边悄声说道：据说东北飞贼舒有正在大理城茶馆捣乱，你马上去给我巡视一圈。
宋远桥在你的耳边悄声说道：据门派弟子来报，此人是来自丐帮的高手，尤为擅长打狗棒法的功夫。
宋远桥说道：「你刚做完大理送信任务，还是先休息一会吧。」 宋远桥说道：「你刚做完天地会任务，还是先休息一会吧。」



丁春秋对着你点了点头。
丁春秋在你的耳边悄声说道：据说星宿叛徒大轮寺的淑盈正在襄阳城山间小路捣乱，你马上去给我巡视一圈。
丁春秋在你的耳边悄声说道：据门派弟子来报，此人是来自大轮寺的高手，尤为擅长无上大力杵的功夫。
丁春秋说道：「你快去快回，一切小心啊。」
]]
     wait.make(function()
	     local l,w=wait.regexp("^(> |)你向丁春秋打听有关『pantu』的消息。$",5)
		 if l==nil then
		    self:ask_job()
		    return
		 end

		 if string.find(l,"你向丁春秋打听有关") then
		   self:catch_place()
		   --BigData:catchData(1957,"三清殿")
		   return
		 end
		 wait.time(5)

	 end)
   end
   w:go(1969)
end

function xxpantu:shield()
end

function xxpantu:job_failure() --回调函数
end

function xxpantu:giveup()
  dangerous_man_list_add(self.robber_name)
  danerous_man_list_push()
   local pfm=world.GetVariable("pfm") or ""
    ---world.Send("alias pfm "..pfm)
  --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 任务失败,准备放弃!\r\n")
   --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:任务失败,准备放弃!", "red", "black") -- yellow on white
  --if combat_start_time~=nil then
     --sj.log_catch(WorldName().."_武当任务:",400)
  --end
  world.EnableTrigger("robber_place",false)
  world.DeleteTrigger("robber_place")
  -- 这次武当job 失败了
  self:job_failure()

  --if self.is_giveup==true then
  --   self:Status_Check()
  --   return
 --end
 local w
   w=walk.new()
   w.walkover=function()
       world.Send("ask ding chunqiu about 放弃")
       wait.make(function()
	   --宋远桥说道：「叶知秋，你又没在我这里领任务，瞎放弃什么呀！」
	   --宋远桥说道：「叶知秋，你又没在我这里领任务，瞎放弃什么呀！」
	      local l,w=wait.regexp("丁春秋说道：「"..self.playname.."，这个任务确实比较难完成，下次给你简单的，先退下吧！」$|^(> |)丁春秋说道：「"..self.playname.."，你又没在我这里领任务，瞎放弃什么呀！」$|^(> |)丁春秋说道：「"..self.playname.."，你太让我失望了，居然这么点活都干不好，先退下吧！」$",5)
		  if l==nil then
		     self:giveup()
		     return
		  end
		  if string.find(l,"瞎放弃什么呀") or string.find(l,"居然这么点活都干不好，先退下吧") or string.find(l,"这个任务确实比较难完成") then
			--BigData:catchData(1957,"三清殿")
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

function xxpantu:jobDone()--回调
end
--[[
你获得了一百二十七点经验，二十九点潜能！你的侠义正气增加了！
宋远桥为你在钱庄里存入三锭黄金。
]]
function xxpantu:is_reward()

       wait.make(function()
	      local l,w=wait.regexp("(> |)你获得了(.*)点经验，(.*)点潜能！你的侠义正气增加了！$",30)
		  if l==nil then
		     self:is_reward()
		     return
		  end
		  if string.find(l,"你获得了") then
			 --world.AppendToNotepad (WorldName(),os.date()..": 武当任务 获得经验:".. ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]).."\r\n")
			 --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 武当job 经验:".. ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]).."\r\n")
			 --local exps=world.GetVariable("get_exp")
			 exps=tonumber(exps)+ChineseNum(w[2])
			 --world.SetVariable("get_exp",exps)
			 --world.AppendToNotepad (WorldName(),os.date()..": 目前获得总经验值"..exps.."\r\n")
		     self.reward_ok=true
			 return
		  end
		  wait.time(30)
	   end)
end

function xxpantu:reward()
	local ts={
		task_name="星宿叛徒",
		task_stepname="奖励",
		task_step=5,
		task_maxsteps=5,
		task_location=self.location.." 方圆:"..self.depth,
		task_description=self.robber_name.." 门派:"..self.menpai.." 技能:"..self.skills,
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
		world.Send("ask ding chunqiu about 完成")
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

	      local l,w=wait.regexp("(> |)你获得了(.*)点经验，(.*)点潜能！你的侠义正气增加了！$|^(> |)你向丁春秋打听有关『完成』的消息。$",5)
		  if l==nil then
		    print("超时")
		    shutdown()
		    self:reward()
		     return
		  end
		 if string.find(l,"你获得了") then
			 --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 武当job 经验:".. ChineseNum(w[2]).." 潜能:"..ChineseNum(w[3]).."\r\n")
			 --local exps=world.GetVariable("get_exp")
			 --exps=tonumber(exps)+ChineseNum(w[2])
			 --world.SetVariable("get_exp",exps)
			 --world.AppendToNotepad (WorldName(),os.date().."目前获得总经验值"..exps.."\r\n")
		     shutdown()
	         local b
			 b=busy.new()
			 b.Next=function()
		       self:jobDone()
			 end
			 b:check()
			 return
		  end
		  if string.find(l,"你向丁春秋打听有关") then
		     shutdown()
			 --BigData:catchData(1957,"三清殿")

		     local b
			 b=busy.new()
			 b.Next=function()
			    --CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:奖励! 经验:"..rc.exps_num.." 潜能:"..rc.pots_num, "red", "black") -- yellow on white
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
	 qi_percent=assert(tonumber(qi_percent),"qi_percent变量必须输入数字！") or 100
	 local vip=world.GetVariable("vip") or "普通玩家"
   local h
	h=hp.new()
	h.checkover=function()
	   -- print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="荣誉终身贵宾" then
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
			--rc.teach_skill=teach_skill --config 全局变量
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
				    drugname="活血疗精丹"
				    drugid="huoxue dan"
				else
				    drugname="蝉蜕金疮药"
				    drugid="chantui yao"
				end
			    rc:buy_drug(drugname,drugid,f)
			end]]
			rc:liaoshang()
        elseif h.jingxue_percent<100 then
		    print("打通经脉")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<qi_percent and heal_ok==false  then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
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
   				     self:Status_Check()
				   end  --外壳
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
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end

function xxpantu:Status_Check()
	local ts={
	           task_name="星宿叛徒",
	           task_stepname="打坐",
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
			        rc.saferoom=505
			        rc.heal_ok=function()
			          self:Status_Check()
			        end
					if rc.omit_snake_poison==true and i[1]=="蛇毒" then --忽略蛇毒

					else
			          rc:qudu(sec,i[1],false)
					  return
					end
			     end
				 if i[1]=="内伤" or i[1]=="七伤拳内伤" then
				    print("内伤")
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
				 if Trim(i[1])=="星宿追杀叛徒" then
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
  --看起来盗墓贼想杀死你！
  --print("auto kill 检查")
  wait.make(function()
    local l,w=wait.regexp("^(> |)看起来(.*)想杀死你！$",5)
	if l==nil then
	  self:beast_kill_check()
	  return
	end
	if string.find(l,"想杀死你") then--排除强盗
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
--(熊|老虎|毒蛇|蛇|豹子|野猪|巨蟒|毒蟒|狼|折冲将军|平寇将军|车骑将军|征东将军|藏獒|值勤兵)
--  毒蟒(Du mang)
function xxpantu:check_beast_kill_again(id)
   wait.make(function()

     world.Send("look")
	 world.Send("set action 1")
	 world.Send("unset wimpy")
	 	 --老虎 熊 豹 蛇 野猪 巨蟒
	 local regexp
	 if self.beast~="" and self.beast~=nil then
	    regexp=".*"..self.beast.."\\(.*\\) <战斗中>$|.*(白熊|黑熊|老虎|蛇|豹子|野猪|巨蟒|野狼|灰狼|马贼|值勤兵|帮众|毒蟒)\\(.*\\).*|^(> |)设定环境变量：action \\= 1$"
	else
 	    regexp=".*(白熊|黑熊|老虎|蛇|豹子|野猪|巨蟒|马贼|值勤兵|野狼|灰狼|帮众|毒蟒)\\(.*\\).*|^(> |)设定环境变量：action \\= 1$"
	end
	 local l,w=wait.regexp(regexp,10)
	 if l==nil then
	    self:check_beast_kill_again(id)
	    return
	 end
	 	 if string.find(l,"值勤兵") then
		world.Send("kill zhiqin bing")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"马贼") then
	    world.Send("kill ma zei")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
		 return
	 end
	 if string.find(l,"战斗中") then
	     local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"熊") then
	    world.Send("kill bear")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"豹子") then
	    world.Send("kill bao")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"帮众") then
	      world.Send("kill bangzhong")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	   return
	 end
	if string.find(l,"蛇") then
	    world.Send("kill snake")
		world.Send("kill she")
		world.Send("kill dushe")
		local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"老虎") then
	    world.Send("kill lao hu")
		 local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"野猪") then
	    world.Send("kill ye zhu")
		 local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"巨蟒") or string.find(l,"毒蟒") then
		 world.Send("kill mang")
		 world.Send("kill du mang")
		 local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"狼") then
	     world.Send("kill wolf")
		 world.Send("kill dog")
		 world.Send("kill lang")
		 local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	 end
	 if string.find(l,"战斗中") then
	     local f=function() self:check_beast_kill_again(id) end
		 f_wait(f,3)
	    return
	 end
	 if string.find(l,"设定环境变量：action") then
	   self.beast=""
	   self.beast_kill=false
	   self:kill_robber(id)
	   return
	 end
     wait.time(10)
   end)
end
