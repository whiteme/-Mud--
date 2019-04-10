--铁匠送宝剑
songjian={
new=function()
     local sj={}
	 setmetatable(sj,{__index=songjian})
	 return sj
  end,
  customer="",
  co=nil,
  co2=nil,
  rooms={},
  exist_rooms={},
  location="",
  depth="",
  round=0,
  is_checkPlace=false,
  look_customer_place="",
  look_customer=false,

}

function songjian:ask_job()

--[[
你向铸剑师打听有关『job』的消息。
铸剑师轻轻地拍了拍你的头。
铸剑师在你的耳边悄声说道：快帮我把宝剑送给林复，他在泰山单家庄周围方圆六里之内。
铁匠给你一把刚刚打造好的定制宝剑。铸剑师在你的耳边悄声说道：快帮我把宝剑送给昆仑山镇远桥的官兵。
铸剑师说道：「好好干活，我不会亏待你的。」]]
  local w=walk.new()
  w.walkover=function()
    world.Send("ask shi about job")

  wait.make(function()
     local l,w=wait.regexp("^(> |)铸剑师在你的耳边悄声说道：快帮我把宝剑送给(.*)，.*在(.*)周围方圆(.*)里之内。$|^(> |)铸剑师在你的耳边悄声说道：快帮我把宝剑送给(.*)的(.*)。$",5)
	 if l==nil then
        self:ask_job()
	    return
	 end
	 if string.find(l,"周围方圆") then
	   local npc=w[2]
		local place=w[3]
		local depth=w[4]
		print(npc,place,depth)
		depth=ChineseNum(depth)
		self:song(place,depth,npc)
	    return
	 end
	 if string.find(l,"铸剑师在你的耳边悄声说道") then
	    local place=w[6]
		local npc=w[7]
	    local depth=1
		print(npc,place,depth)
	    self:song(place,depth,npc)
	    return
	 end
  end)
  end
  w:go(97)
end

function songjian:reward()
  local w=walk.new()
  w.walkover=function()
    world.Send("ask shi about reward")
  end
  w:go(97)
end

function songjian:giveup()
 local w=walk.new()
  w.walkover=function()
    world.Send("ask shi about 放弃")
  end
  w:go(97)
end
function songjian:customer_exist()

   world.AddTriggerEx ("customer_place", "^(> |)(.*) - .*$", "print(\"%2\")\nSetVariable(\"customer_place\",\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 1000)
  wait.make(function()
    local l,w=wait.regexp("^(> |).*\\\s"..self.customer.."\\\((.*)\\\).*$",5)
	if l==nil then
	  self:customer_exist()
	  return
	end
	if string.find(l,self.customer) then
	  world.EnableTrigger("customer_place",false)
	  world.DeleteTrigger("customer_place")
	  self.look_customer=true
	  local location=world.GetVariable("customer_place")
	  print("test "..location)
	  location=Trim(location)
	  self.look_customer_place=location

      --self.customer_id=string.lower(Trim(w[2]))
	  print("发现地点:",self.look_customer_place)
	  --world.DeleteVariable("beauty_place")
	  return
    end
	wait.time(5)
  end)
end

function songjian:Search(paths,rooms,npc)
    self.round=1
	--world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 开始搜索\r\n")

    self.is_checkPlace=true
	self:customer_exist()
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
	   print("wudang 执行搜索迷宫")
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
	    --local f=function() self:NextPoint() end
	    self:checkNPC(npc)
	end
	w.current_room=97
	w:go(tr.startroomno)	--走到起始房间
end

function songjian:Check_Point_NPC()
 --渡船
	 local target_room={}

      --print("房间名称:",look_robber_place)
	  --self.look_robber_place=look_robber_place
	  --self.location=location
	 local zz=""
	 local zone=partition(self.location)

	  print("房间名称:",self.look_customer_place)
	 --local zone=partition(location)
	 for _,z in pairs(zone) do
	     print(z.zone)
	    if Trim(z.zone)~="" then
		   zz=z.zone
		   break
		end
	 end
	 print("check 区域:",zz..Trim(self.look_customer_place))
	  local n,e=Where(zz..Trim(self.look_customer_place)) --检测房间名
      if table.getn(e)==0 then
	     n,e=Where(Trim(self.look_customer_place)) --检测房间名
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

function songjian:Child_NextPoint()
   print("子进程恢复")
   coroutine.resume(songjian.co2)
end

function songjian:check_next_point(target_room)
      songjian.co2=coroutine.create(function()
		 -- 回到主进程上去
             self:Child_Search(target_room,self.customer)

		   print("回到主进程上去!")
		   songjian.co2=nil
		   self:customer_exist()
		   self:check_section()

	   end)
	   self:Child_NextPoint()
end


function songjian:check_section()

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

function songjian:checkNPC(npc,CallBack)

  wait.make(function()
      world.Execute("look;set action 1")
	 -- self:look()
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)设定环境变量：action \\= 1$",6)
	  if l==nil then
		self:checkNPC(npc,CallBack)
		return
	  end
	  if string.find(l,"设定环境变量：action") then
	       print("check NPC")
	       if self.look_customer==true then --路上经过

		     self.look_customer=false--只检查一次
			 print("路上经过")
			 self:Check_Point_NPC()--点检 点检完毕 回到section起始房间

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
	     --找到
		  --self:follow(id)
  		   local _id=string.lower(Trim(w[2]))
		   --self.robber_id=_id
           --self:kill_robber(_id)
		   self:give(_id)
		  return
	  end

   end)
end

function songjian:NextPoint()
  print("进程恢复")
   coroutine.resume(songjian.co)
end
function songjian:give(id)
   world.Send("song "..id)
   wait.make(function()
     local l,w=wait.regexp("^(> |)你把刚刚打造好的定制宝剑送给.*。$",5)
	 if l==nil then
	    self:give(id)
	    return
	 end
	 if string.find(l,"你把刚刚打造好的定制宝剑") then
	    self:reward()

	    return
	 end
   end)
  --你把刚刚打造好的定制宝剑送给道童。
end

function songjian:c_paths(e,depth,omit,opentime)
  local paths,rooms=depth_path_search(e,depth,omit,opentime)  --搜索路径 房间号
  --print(paths)
  --print(rooms)
   print("需要遍历房间")
   local ex_rooms={}
   --local ex_list={}
   ex_rooms=Split(rooms,";")
   for _,g in ipairs(ex_rooms) do
      --if ex_list[g]==nil then
	   -- ex_list[g]=g
		self.exist_rooms[g]=true
        table.insert(self.rooms,g)
	  --end
   end

   if paths~="" then
	  local b
	  b=busy.new()
	  b.interval=0.5
	  b.Next=function()
	     self:Search(paths,rooms,self.customer)
	  end
	  b:check()
	else
	  self:giveup()
    end
end

function songjian:song(location,depth,npc)
	local ts={
	           task_name="送剑任务",
	           task_stepname="寻找客户",
	           task_step=1,
	           task_maxsteps=3,
	           task_location=location.." 方圆:"..depth,
	           task_description="寻找"..npc,
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   --print("robber ",location," ",depth," ",npc)
   self.customer=npc
   self.location=location
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
      omit="duhe"
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
     omit="zishanlin_ruijin|tiandifenglei_feng|tiandifenglei_di|tiandifenglei_tian|tiandifenglei_lei|west_zishanlin_tiandifenglei_quick|east_zishanlin_tiandifenglei_quick" --zishanlin_search|
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
      omit="changjie_changjie|caidi_cunzhongxin|changjie_nandajie|R651"

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
   --print("omit:",omit)
  -- self:c_paths(e,depth,omit,true)
   if string.find(location,"平定州") then
      omit="duhe|dutan"
   end
   self:c_paths(e,depth,omit,true) --固定范围
end

function songjian:checkPlace(roomno,here,is_omit)
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
			  local ex_rooms={}
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
             end

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
				  self:checkNPC(self.customer)
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
			  self:checkNPC(self.customer,f2)
			end
			al.maze_done=function()
			   print("迷宫check npc")
			   local f2=function() al.maze_step() end
			   self:checkNPC(self.customer,f2)
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
				 print("检查NPC")
			     self:checkNPC(self.customer)
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
		   --local f=function() self:NextPoint() end
		    self:checkNPC(self.customer)
		  end
		  w:go(roomno)
	   end
end
