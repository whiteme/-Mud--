--机器人核心路径计算定位功能
--require "strict"
world.AddAlias("zmud", "zmud", "zmud_alias_convert()", alias_flag.Enabled + alias_flag.Replace, "")
world.SetAliasOption ("zmud", "send_to", 12) --向脚本发送
function marco(cmds)
   local u={}
   u=Split(cmds,"|")

   for i=1,table.getn(u) do
      local cmd=u[i]
	  -- print(cmd)
      if string.find(cmd,"#wa") then
	     local sec=string.gsub(cmd,"#wa","")
		 sec=Trim(sec)
		 sec=tonumber(sec) / 1000
		 --print(sec)
		 local cmds=""
		 for j=i+1,table.getn(u) do
		    cmds=cmds ..u[j].."|"
		 end

		 cmds=string.sub(cmds,1,-2)
		 --print(cmds)
		 local callback=function()
		    marco(cmds)
		 end
		 f_wait(callback,sec)
		 return
	  else
	    world.Execute(cmd)
	  end
   end
end

function zmud_alias_convert()
  local zmud_alias=utils.inputbox("输入zmud alias格式", "格式转换", "", "宋体", 9) or ""
  if zmud_alias~="" then
    zmud_alias=string.gsub(zmud_alias,";","|")
    zmud_alias=Trim(zmud_alias)
    marco(zmud_alias)
  end
end
--local search_count=0 --搜索次数
function Split(szFullString, szSeparator)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = {}
  while true do
    local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
    if not nFindLastIndex then
      nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
      break
	end
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
    nFindStartIndex = nFindLastIndex + string.len(szSeparator)
    nSplitIndex = nSplitIndex + 1
  end
  return nSplitArray
end

function is_Special_exits(exitname)
   if exitname=="east" or exitname=="north" or exitname=="west" or exitname=="south" or exitname=="enter" or exitname=="out" or exitname=="up" or exitname=="down" then
       return false
   elseif exitname=="northeast" or exitname=="northwest" or exitname=="southwest" or exitname=="southeast" then
       return false
   elseif exitname=="northup" or exitname=="northdown" or exitname=="eastdown" or exitname=="eastup" or exitname=="southup"  or exitname=="southdown" or exitname=="westup" or exitname=="westdown" then
	   return false
   elseif exitname=="jump out" or exitname=="jump river"  or exitname=="pa up" or exitname=="climb down" or exitname=="swim"  or exitname=="enter 第四株" or exitname=="climb up" then
       return false
   elseif exitname=="shanzhuang" or exitname=="xiaodao" or exitname=="yanziwu" or exitname=="jump liang" or exitname=="jump zhuang" or exitname=="jump down" or exitname=="climb" or exitname=="jump window" then
       return false

   elseif exitname=="weapon" or exitname=="gift" or exitname=="combat" or string.find(exitname,";") then
       return false
   else
       return true
   end
end

local tbl_query={} --导入hashtable rows
local tbl_bottom_query={} --从底部搜索表
local tbl_top_query={} --从顶部搜索表
function import_query()  --从底部开始 结束节点都相同
   tbl_query={}
   local sql="SELECT MUD_Entrance.roomno,MUD_Entrance.direction,MUD_Entrance.linkroomno,MUD_Room.roomtype,MUD_Entrance.weight,MUD_Entrance.id from MUD_Entrance,MUD_Room where MUD_Room.roomno=MUD_Entrance.roomno order by id"
	  ----print(sql)
	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  while rc == 100 do
	     local values=  DatabaseColumnValues ("sj")
		 local v={}
		 --local linkroomno=values[3]
		 local id=values[6]
		 v.roomno=values[1]
	     v.direction=values[2]
		 v.linkroomno=values[3]
		 v.roomtype=values[4]
		 v.weight=values[5]
		 --[[if tbl_bottom_query[linkroomno]==nil then
		     tbl_bottom_query[linkroomno]={}
		     tbl_bottom_query[linkroomno].rows={}
         end]]
		  --print(id," ",v.roomno," ",v.direction," ",v.linkroomno)
		  tbl_query[id]=v
		  rc = DatabaseStep ("sj")

	  end
	  ----print("关闭")
	  DatabaseFinalize ("sj")
end

function import_bottom()  --从底部开始 结束节点都相同
   tbl_bottom_query={}
   local sql="SELECT MUD_Entrance.roomno,MUD_Entrance.direction,MUD_Entrance.linkroomno,MUD_Room.roomtype,MUD_Entrance.weight,MUD_Entrance.id from MUD_Entrance,MUD_Room where MUD_Room.roomno=MUD_Entrance.roomno order by  MUD_Entrance.linkroomno,weight asc"
	  ----print(sql)
	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  while rc == 100 do
	     local values=  DatabaseColumnValues ("sj")
		 local v={}
		 local linkroomno=values[3]
		 v.id=values[6]
		 --v.roomno=values[1]
	     --v.direction=values[2]
		 --v.linkroomno=values[3]
		 --v.roomtype=values[4]
		 --v.weight=values[5]
		 if tbl_bottom_query[linkroomno]==nil then
		     tbl_bottom_query[linkroomno]={}
		     tbl_bottom_query[linkroomno].rows={}
         end
		  table.insert(tbl_bottom_query[linkroomno].rows,v)
		  rc = DatabaseStep ("sj")

	  end
	  ----print("关闭")
	  DatabaseFinalize ("sj")
end


function import_top()
   tbl_top_query={}
    local sql="SELECT MUD_Entrance.roomno,MUD_Entrance.direction,MUD_Entrance.linkroomno,MUD_Room.roomtype,MUD_Entrance.weight,MUD_Entrance.id from MUD_Entrance,MUD_Room where MUD_Room.roomno=MUD_Entrance.roomno order by  MUD_Entrance.roomno,weight asc"
	  --print(sql)
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  --print("bug1",rc)
	  while rc == 100 do
	    --print("bug2")
	     local values=  DatabaseColumnValues ("sj")
            local roomno=values[1]
			local v={}
			v.id=values[6]
			--v.roomno=values[1]
			--v.direction=values[2]
			--v.linkroomno=values[3]
			--v.roomtype=values[4]
			--v.weight=values[5]
			if tbl_top_query[roomno]==nil then
               tbl_top_query[roomno]={}
		       tbl_top_query[roomno].rows={}
            end
		    table.insert(tbl_top_query[roomno].rows,v)

		    rc = DatabaseStep ("sj")
	  end
      DatabaseFinalize ("sj")
end

function test_query()
   for roomno,item in pairs(tbl_query) do
      print(roomno," 房间号")
	  print(table.getn(item))

	     print(item.roomno," > ",item.linkroomno," ",item.direction)
	  --end
   end
end

function test_top()
   for roomno,item in pairs(tbl_top_query) do
      print(roomno," 房间号")
	  print(table.getn(item.rows))
	  for _,i in ipairs(item.rows) do
	     print(i.id)
	  end

   end
end

function test_bottom()
   for roomno,item in pairs(tbl_bottom_query) do
      print(roomno," 房间号")
	  print(table.getn(item.rows))
	  for _,i in ipairs(item.rows) do
	     print(i.id)
	  end
   end
end

function update_data()
     local cmd=""
  	  local party=world.GetVariable("party") or ""
	  local mastername=world.GetVariable("mastername") or ""
	  local exps=world.GetVariable("exps") or 0
	  if party=="姑苏慕容" then
	      cmd="update MUD_Entrance set linkroomno=-1 where direction='tanqin' or direction='qumr' or direction='quyanziwu' or direction='qusuzhou'"
		  print(cmd)
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=2022 where direction='shanzhuang'"
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=1981 where direction='xiaodao'"
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=1986 where direction='yanziwu'"
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=2704 where direction='zuan_didao'"
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=2704 where direction='push_qiaolan'"
		  DatabaseExec("sj",cmd)
	  elseif party=="无" then
	      cmd="update MUD_Entrance set linkroomno=-1 where direction='tanqin' or direction='qusuzhou'"
		  print(cmd)
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=2022 where direction='shanzhuang'"
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=1981 where direction='xiaodao'"
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=1986 where direction='yanziwu'"
		  DatabaseExec("sj",cmd)
		  cmd="update MUD_Entrance set linkroomno=2704 where direction='zuan_didao'"
		  DatabaseExec("sj",cmd)
	 end
        if tonumber(exps)<=3000 then  --武馆出口
           cmd="update MUD_Entrance set linkroomno=-1 where direction='outwuguan'"
		   DatabaseExec("sj",cmd)
        end
	   if mastername~="风清扬" then
		  cmd="update MUD_Entrance set linkroomno=-1 where direction='siguoya_jiashanbi' or (roomno=4096 and direction='out')"
		  --print(cmd)
	   else
		 cmd="update MUD_Entrance set linkroomno=4986 where direction='siguoya_jiashanbi'"

       end
	    --print(cmd)
	   DatabaseExec("sj",cmd)

		if party~="灵鹫宫" and party~="无" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='t_leave' or direction='huigong'"
			-- print(cmd)
			DatabaseExec("sj",cmd)
		elseif party=="无" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='t_leave'"
			-- print(cmd)
			DatabaseExec("sj",cmd)


			if tonumber(exps)<=100000 then  --百姓低于100000 没法跳仙愁门
			  cmd="update MUD_Entrance set linkroomno=-1 where direction='xianchoumen_baizhangjian' or direction='baizhangjian_xianchoumen'"
			   --print(cmd)
			   DatabaseExec("sj",cmd)

			   cmd="delete from MUD_Zone where ToZone='星宿海' and FromZone='天山'"
			   --print(cmd)
			   DatabaseExec("sj",cmd)

			   cmd="delete from MUD_Zone where FromZone='星宿海' and ToZone='天山'"
			   --print(cmd)
			   DatabaseExec("sj",cmd)
			end
	    end


         if party~="逍遥派" and party~="无" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='climb_shanlu'"
			-- print(cmd)
			DatabaseExec("sj",cmd)
	    end
		--4243 climb 山路 4234
		--4234 push door 4243

		if party~="武当派" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='yuanmen_xiaoyuan'"
			DatabaseExec("sj",cmd)
			-- print(cmd)
	    end
		if party~="神龙教" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='dadukou_shenlongdao'"
			DatabaseExec("sj",cmd)
			-- print(cmd)
	    end
		if party=="武当派" and mastername=="张三丰" then
			cmd="update MUD_Entrance set linkroomno=2771 where linkroomno=2755 and roomno=2754"
			DatabaseExec("sj",cmd)
			cmd="update MUD_Entrance set linkroomno=2754 where linkroomno=2755 and roomno=2771"
			DatabaseExec("sj",cmd)
			cmd="delete from MUD_Room where roomno=2755"
			DatabaseExec("sj",cmd)
            print("武当派")
			world.AddTriggerEx ("tj1", "^(> |)你缓缓念道：“挤在手背，小心了！”\,便暗运氤氲紫气，太极「挤」字诀已使的出神入化！$", "local taiji=world.GetVariable(\"taiji\") or 0\nif taiji==0 then Send(\"set taiji 按|按|按|挤\") else Execute(\"set taiji 采|采|采|挤;jiali 50\") end", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
            world.AddTriggerEx ("tj2", "^(> |)你这一按实乃配合自身极高修为的氤氲紫气内功.*$", "SetVariable(\"taijian\",1)\nExecute(\"set taiji 挤|采|采|挤;jiali 50\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "","", 12, 9999)
            world.AddTriggerEx ("tj3", "^(> |)你「太极」神功使完，气归丹田，缓缓收功而退！$", "Execute(\"jiali 1;yun jingli;set taiji 挤|挤|挤|按\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)

			 --print(cmd)
	    end
		if party~="明教" then
		   cmd="update MUD_Entrance set linkroomno=-1 where direction='shanbi_huacong'"
		    --print(cmd)
	    	DatabaseExec("sj",cmd)
        else
			 local skills=world.GetVariable("teach_skills") or ""
             local ski={}
             ski=Split(skills,"|")
             for _,v in ipairs(ski) do
               if v=="jiuyang-shengong" then
	            cmd="update MUD_Entrance set linkroomno=3157 where roomno=366 and direction='shanjiao_shanlu'"
		        --print(cmd)
	       	    DatabaseExec("sj",cmd)
			    break
               end
             end
		end
		if party~="古墓派" then
		     cmd="update MUD_Entrance set linkroomno=-1 where direction='tiao' or direction='xiao'"  --绝情谷 深沟
		    --print(cmd)
	    	DatabaseExec("sj",cmd)
        elseif mastername=="无" then  --古墓第五代弟子
		     cmd="update MUD_Entrance set linkroomno=-1 where direction='xiao'"  --绝情谷 深沟
		    --print(cmd)
	    	DatabaseExec("sj",cmd)
		end
		if mastername=="枯荣长老" then
		   cmd="update MUD_Entrance set linkroomno=-1 where direcion='dangtianmen_xiuxishi'"
		   DatabaseExec("sj",cmd)
		end
		if mastername=="一灯大师" then
			 cmd="update MUD_Entrance set linkroomno=-1 where direction='yuren'"
		     DatabaseExec("sj",cmd)
		else
		    cmd="update MUD_Entrance set linkroomno=-1 where direction='maowu_hetang'"
		   -- print(cmd)
	    	DatabaseExec("sj",cmd)
		end
	    if party~="少林派" then
		  cmd="update MUD_Entrance set linkroomno=-1 where direction='xinchanping_xinchantang' or direction='yanwutang_wusengtang' or direction='qingyunpin_fumoquan'"
			-- print(cmd)
			DatabaseExec("sj",cmd)
        end
		if party~="星宿派" then
		    cmd="update MUD_Entrance set linkroomno=-1 where direction='north' and roomno=1969"
			DatabaseExec("sj",cmd)
        end
        local exps=world.GetVariable("exps") or "0"
		exps=tonumber(exps)
		if exps<200000 then
         cmd="update MUD_Entrance set linkroomno=-1 where roomno=593 and direction='north'"  --轻功低于50
		 DatabaseExec("sj",cmd)
		else
		 cmd="update MUD_Entrance set linkroomno=595 where roomno=593 and direction='north'"  --轻功大于50
		 DatabaseExec("sj",cmd)
		end


	    --local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'"
		--DatabaseExec("sj",cmd)

		local cmd="update MUD_Entrance set linkroomno=-1 where direction='shanjiao_shanlu'"
		DatabaseExec("sj",cmd)
        -- 九阳id 可以直接进入
		local skills=world.GetVariable("teach_skills") or ""
        local ski={}
         ski=Split(skills,"|")
        for _,v in ipairs(ski) do
          if v=="jiuyang-shengong" then
	        print("九阳神功直接进入五毒教")

	        local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --和wdj.wdj2_ok 保持一致
	        DatabaseExec("sj",cmd)
	        break
          end
        end



	  --print("导入 搜索路径")
      --import_top()  --顶部搜索 出入口
	  --import_bottom()  --底部搜索出入口
	  --import_query() --导入
	  refresh_link()
end
	  --print(cmd)
function refresh_link()
	  import_top()  --顶部搜索 出入口
	  import_bottom()  --底部搜索出入口
	  import_query() --导入
end

function reload_data()
   DatabaseClose ("sj")
   import_data()
   update_data()
end

function close_data()
   DatabaseClose ("sj")
   DatabaseClose ("db")
   DatabaseClose ("db2")
end

local database_path=""
function import_data()
	local databases = world.DatabaseList()
	if databases then
       for _, v in ipairs (databases) do
         ----print("已打开的数据库名称:",v)
	     if v=="sj" then
		    print("数据库已打开")
		    return
		 end
       end
    end
	print("数据库导入内存！")
	world.DatabaseOpen ("db", database_path, 2) --只读数据库
	world.DatabaseOpen ("db2", database_path, 6) --只读数据库
	world.DatabaseOpen("sj",":memory:",6)
	world.DatabaseExec("sj",[[
	   DROP TABLE IF EXISTS MUD_Crowd;
	   Create  TABLE MUD_Crowd([roomno] integer,[crowd_roomno] integer,[flag] integer, Primary Key(roomno,crowd_roomno));
       DROP TABLE IF EXISTS MUD_Room;
	   Create TABLE MUD_Room([roomno] integer NOT NULL,[zone] text,[relation] text,[roomname] text,[description] text,[exits] text,[roomtype] text, Primary Key(roomno,zone,relation,roomname,description,exits));
	   DROP TABLE IF EXISTS MUD_Entrance;
	   Create TABLE MUD_Entrance([roomno] integer,[linkroomno] integer,[direction] text,[weight] integer,[id] integer, Primary Key(id));
	   DROP TABLE IF EXISTS MUD_Zone;
	   Create TABLE MUD_Zone([FromZone] text,[ToZone] text,[LinkRoomNo] int,[Condition] text,[Party] text);
	   DROP TABLE IF EXISTS MUD_Paths;
	   Create TABLE Mud_Paths([FromRoomNo] int,[ToRoomNo] int,[Path] text,[Room_Type] text,[Type] text,[Party] text,[Update_time] datetime);
	   Drop View If Exists View_VirtualRoom;
       Create View View_VirtualRoom As select roomno from MUD_Room where roomtype='V';
	   Drop Index If Exists linkroomno_index;
       CREATE  INDEX linkroomno_index On [MUD_Entrance] ([linkroomno] Collate NOCASE ASC);
	   Drop Index If Exists room_index;
	   CREATE INDEX room_index On [MUD_Entrance] ([roomno] Collate NOCASE ASC);

	   Drop Index If Exists FromRoomNo_index;
       CREATE  INDEX FromRoomNo_index On [MUD_Paths] ([FromRoomNo] Collate NOCASE ASC);
	   Drop Index If Exists ToRoomNo_index;
	   CREATE INDEX ToRoomNo_index On [MUD_Paths] ([ToRoomNo] Collate NOCASE ASC);

	   Create  TABLE MUD_Npc([name] text,[roomno] integer,[id1] text,[id2] text,[id3] text, Primary Key(name,roomno));
	   CREATE INDEX [index_name] On [MUD_Npc] ([name] Collate NOCASE ASC);
       CREATE INDEX [index_roomno] On [MUD_Npc] ([roomno] );

	]])
	--数据导入
	  --MUD_Crowd
	local sql="Select [roomno],[crowd_roomno],[flag] From MUD_Crowd"
	world.DatabasePrepare ("db", sql)
	 local rc ={}
	 local cmd=""
  	  rc=world.DatabaseStep ("db")
	  while rc == 100 do
	     ------print("row",i)
	     local values=  world.DatabaseColumnValues ("db")

		 cmd="Insert Into MUD_Crowd ([roomno],[crowd_roomno],[flag]) values("..values[1]..","..values[2]..","..values[3]..")"
		 ------print(cmd)
		 world.DatabaseExec("sj",cmd)
		 rc = world.DatabaseStep ("db")
	  end
	  world.DatabaseFinalize ("db")
      --MUD_Room
	  sql="Select [roomno],[zone],[relation],[roomname],[description],[exits],[roomtype] From MUD_Room"
	  world.DatabasePrepare ("db", sql)
	  rc = world.DatabaseStep ("db")
	  while rc == 100 do
	     local values=  world.DatabaseColumnValues ("db")
		 for i=1,7 do
            if values[i]==nil then
		       values[i]=""
			end
		 end
		 cmd="Insert Into MUD_Room ([roomno],[zone],[relation],[roomname],[description],[exits],[roomtype]) values("..values[1]..",'"..values[2].."','"..values[3].."','"..values[4].."','"..values[5].."','"..values[6].."','"..values[7].."')"
		 ------print(cmd)
		 DatabaseExec("sj",cmd)
		 rc = world.DatabaseStep ("db")
	  end
	  world.DatabaseFinalize ("db")
	  --MUD_Entrance
	  sql="Select [roomno],[linkroomno],[direction],[weight],[id] From MUD_Entrance"
	  world.DatabasePrepare ("db", sql)
	  rc = DatabaseStep ("db")
	  while rc == 100 do
	     local values=  world.DatabaseColumnValues ("db")
		 cmd="Insert Into MUD_Entrance ([roomno],[linkroomno],[direction],[weight],[id]) values("..values[1]..","..values[2]..",'"..values[3].."',"..values[4]..","..values[5]..")"
		 --print(cmd)
		 world.DatabaseExec("sj",cmd)
		 rc = world.DatabaseStep ("db")
	  end
	  world.DatabaseFinalize ("db")
	  --MUD_Zone
	  sql="Select [FromZone],[ToZone],[LinkRoomNo],[Condition],[Party] From MUD_Zone"
	  world.DatabasePrepare ("db", sql)
	  rc = world.DatabaseStep ("db")
	  while rc == 100 do
	     local values=  world.DatabaseColumnValues ("db")
		 for i=1,5 do
            if values[i]==nil then
		       values[i]=""
			end
		 end
		 cmd="Insert Into MUD_Zone ([FromZone],[ToZone],[LinkRoomNo],[Condition],[Party]) values('"..values[1].."','"..values[2].."',"..values[3]..",'"..values[4].."','"..values[5].."')"
		 ------print(cmd)
		 world.DatabaseExec("sj",cmd)
		 rc = world.DatabaseStep ("db")
	  end
	  world.DatabaseFinalize ("db")
	  --MUD_Paths
	  sql="Select [FromRoomNo],[ToRoomNo],[Path],[Room_Type],[Type],[Party],[Update_time] From MUD_Paths"
	  world.DatabasePrepare ("db", sql)
	  rc = world.DatabaseStep ("db")
	  while rc == 100 do
	     local values=  world.DatabaseColumnValues ("db")
		 for i=1,7 do
            if values[i]==nil then
		       values[i]=""
			end
		 end
		 cmd="Insert Into MUD_Paths ([FromRoomNo],[ToRoomNo],[Path],[Room_Type],[Type],[Party],[Update_time]) values("..values[1]..","..values[2]..",'"..values[3].."','"..values[4].."','"..values[5].."','"..values[6].."','"..values[7].."')"
		 ------print(cmd)
		 world.DatabaseExec("sj",cmd)
		 rc =world.DatabaseStep ("db")
	  end
	  world.DatabaseFinalize ("db")
	  --MUD_Npc
	  sql="Select [name],[roomno],[id1],[id2],[id3] From MUD_Npc"
	  world.DatabasePrepare ("db", sql)
	  rc = world.DatabaseStep ("db")
	  while rc == 100 do
	     local values=  world.DatabaseColumnValues ("db")
		 for i=1,5 do
            if values[i]==nil then
		       values[i]=""
			end
		 end
		 cmd="Insert Into MUD_Npc ([name],[roomno],[id1],[id2],[id3]) values('"..values[1].."',"..values[2]..",'"..values[3].."','"..values[4].."','"..values[5].."')"
		 --print(cmd)
		 world.DatabaseExec("sj",cmd)
		 rc =world.DatabaseStep ("db")
	  end
	  world.DatabaseFinalize ("db")
	  world.DatabaseClose("db")  --关闭数据库
	  --DatabaseClose("db2")
end

function map_init(db_name)
  --DatabaseOpen ("db", GetInfo (66) .. "sj.db", 6)
  ------print(GetInfo (66) .. "sj.db")
  --DatabaseOpen ("db", GetInfo (66) .. db_name, 6) --只读数据库
  local path=world.GetInfo (66) .. db_name
  world.DatabaseOpen ("db", path, 2) --只读数据库
  world.DatabaseOpen ("db2", path, 6)--修改数据库
  database_path=path
  --导入数据
  print("-------------------------------------")
  print("导入数据库"..db_name)
  print("-------------------------------------")
  import_data()
  --根据特殊条件来更新数据
  update_data()
end
--数据结构 向量
local vector={
   roomno=nil,  --当前节点房间号
   direction="", --方向
   linkroomno=nil, --接连节点房间号
   roomtype="", --房间类型
}

local Bottom={}
local Bottom_buffer={} --底部检索队列
local Bottom_buffer_len=0
local Bottom_pre_existing={}

local Top={}
local Top_buffer={} --顶部检索队列
local Top_buffer_len=0
local Top_pre_existing={}

local _list={} --虚拟房间列表
local Zonelist={}
setmetatable(Zonelist, {__mode = "k"}) --weak table
map={
 new=function()
   local mp={}
   setmetatable(mp,map)
   return mp
 end,
 Search_co={},
 opentime=nil,
 start=nil,
 End=nil,
 user_alias=nil,
 version=1.8,
}
map.__index=map
function map:Search_end(path,room_type,rooms)--

end
--检查正向有重合节点
local function T_Contain(roomno)
   ------print("T目标",roomno)

   for i,t in ipairs(Top) do
      if t.linkroomno==roomno then
	     return true
	  end
   end
     return false

end

--检查反向有重合节点
local function B_Contain(roomno)
   ------print("B目标",roomno)
   for i,b in ipairs(Bottom) do
      if b.roomno==roomno then
	     return true
	  end
   end
      return false

end

--检查是否存在
local function pre_existing(existing_rooms,roomno)
   for i,e in ipairs(existing_rooms) do
      if e==roomno then
	     return true
	  end
   end
   return false
end


local function real_list(r)
    for _,v in ipairs(_list) do
	  if v.roomno==r.linkroomno then
	     r.linkroomno=v.linkroomno
		 break
	  end
    end
end

local function virtual_list(v)
    table.insert(_list,v)
end


function map:virtual(v)  --虚拟房间
     local al
	 if self.user_alias==nil then
	   al=alias.new()
	 else
	   al=self.user_alias
	 end
     ------print("方向",v.direction)
	 local virtual_type=false
	 virtual_type=al:virtual_rooms(v.direction)
     local party=world.GetVariable("party") or ""
	 local mastername=world.GetVariable("mastername") or ""
     local exps=tonumber(world.GetVariable("exps")) or 100000
	 if sj.eat_biyundan==nil then
	    sj.eat_biyundan=false
	 end
     local cond
	 if virtual_type==true then
	   if self.opentime==true then
	    cond=true
	   elseif self.opentime==nil then
	    local condition= v.direction
		al.finish=function(result) --回调函数
		   coroutine.resume(self.Search_co,result)
		end
		al:opentime(condition)
	    --self:opening(condition)
	    ----print("暂停确定mud时间：")
	    cond=coroutine.yield()
	    self.opentime=cond --记忆
	   end
	 elseif (self.start==2663 or self.start==2665 or self.start==2664 or self.start==2666 or self.start==2667 or self.start==2668 or self.start==2674) and v.direction=="jump river" then
	    cond=true
	 elseif (self.End==2464 or self.End==2519 or self.End==2520 or self.End==2521 or self.End==2522 or self.End==2523 or self.End==2524 or self.End==2525 or self.End==2526 or self.End==2527 or self.End==2528 or self.End==3041 or self.End==2887 or self.End==2888 or self.End==2889 or self.End==2890) and v.direction=="zishanlin" then
		 cond=true
     elseif (party=="姑苏慕容" and v.direction=="didao") then
	   -- ----print("姑苏慕容")
	    cond=true
	 elseif (party=="少林派" and v.direction=="songlin_jielvyuan") then
	    cond=true
	 elseif (v.direction=="guanmucong" and mastername=="孤鸿子") then
	    cond=true
	 elseif (party~="姑苏慕容" and v.direction=="goboat") then
	    ------print("非慕容弟子")
		cond=true
	 elseif (party=="灵鹫宫" and v.direction=="t_leave") or (party=="灵鹫宫" and v.direction=="huigong") then
	    cond=true
	 elseif (party=="神龙教" and v.direction=="shenlongdao_dadukou") or (party=="神龙教" and v.direction=="dadukou_shenlongdao") then
	    ------print(party,v.direction,"why")
	    cond=true
	 elseif (party=="少林派" and v.direction=="xinchanping_xinchantang") or (party=="少林派" and v.direction=="yanwutang_wusengtang") or (party=="少林派" and v.direction=="qingyunpin_fumoquan") then
	    cond=true
	 --elseif (party=="古墓派" and v.direction=="jumpya") then
	 --   cond=true
	 elseif (party=="昆仑派" and v.direction=="kunlun_houshan") then
	    cond=true
	 elseif (party=="明教" and v.direction=="shanbi_huacong") then
	    cond=true
	 elseif (party=="天龙寺" and v.direction=="maowu_hetang") then
	    cond=true
	 elseif (exps<=50000 and v.direction=="tengkuang") then
        cond=true
	 --[[ 简化五毒教
	 elseif (v.direction=="shanjiao_shanlu" and wdj.wdj2_ok==true) then  --去五毒教 只有吃到过真药才会进入
	     print("五毒教判别")
	     local _wdj=wdj.new()
		  _wdj.check_posion=function() --吃过真药 但是没有抓到蜘蛛
		     coroutine.resume(self.Search_co,true)
		  end
		  _wdj.finish=function() --还在有效期中
		    -- print("有效期内")
		     coroutine.resume(self.Search_co,true)
		  end
		  _wdj.start=function() --有效期过
		     coroutine.resume(self.Search_co,false)
		  end
		 _wdj:check()
	     cond=coroutine.yield() --暂停]]
     else
		 cond=false
	 end
	 ----print("结果:",cond," ",party," ",v.direction)

	 ----print("v:",v.direction)

    --_debug()
	if cond then
	  virtual_list(v)
	  for i,pre in ipairs(Bottom) do
	   ------print(pre.roomno," ",pre.direction," ",pre.linkroomno)
	   if pre.linkroomno==v.roomno then
	      ------print("bottom_virtual:",pre.roomno," ",pre.direction," ",pre.linkroomno)
	      v.roomno=pre.roomno
		  v.direction=pre.direction
		  break
	   end
	 end
	 ------print("top")
	 for i,pre in ipairs(Top) do
	    ------print(pre.roomno," ",pre.direction," ",pre.linkroomno)
		if pre.linkroomno==v.roomno then
	      ------print("top_virtual:",pre.roomno," ",pre.direction," ",pre.linkroomno)
		  v.roomno=pre.roomno
		  v.direction=pre.direction
		  break
	   end
	 end
	else
	    ------print("不通")
		v.roomno="-10"
		v.linkroomno="0"

	end
     v.roomtype=''
    ------print("test3333")
end

--从结束节点开始搜索
function map:Bottom_Start()
    ------print("BOTTOM------------------------------")
    while true do
	   --buffer 长度
	   Bottom_buffer_len=table.getn(Bottom_buffer)
	   --if Bottom_buffer_len> Top_buffer_len then
	   --print("Bottom_Weight:",Bottom_Weight)
       if Bottom_buffer_len> Top_buffer_len then
	      break
	   elseif Bottom_buffer_len==0 then

		  return false,nil
	   end
	  --循环读取
	  local linkroomno
	  while true do
	    linkroomno=Bottom_buffer[1]
		table.remove(Bottom_buffer,1)
		if linkroomno.weight>0 then
		   linkroomno.weight=linkroomno.weight-1
		   table.insert(Bottom_buffer,linkroomno)
		else
		   break
		end
	  end
	  -- 2016 --12 -18  从内存表里面
	   ------print("Bottom_LENGth",table.getn(Bottom_buffer))
	   ----print("TOP_LENGth",table.getn(Top_buffer))
	  --local sql="SELECT MUD_Entrance.roomno,MUD_Entrance.direction,MUD_Entrance.linkroomno,MUD_Room.roomtype,MUD_Entrance.weight from MUD_Entrance,MUD_Room where MUD_Room.roomno=MUD_Entrance.roomno and linkroomno=" ..linkroomno.roomno.." order by weight asc"
	  if tbl_bottom_query[linkroomno.roomno]~=nil then
	    local rc=tbl_bottom_query[linkroomno.roomno].rows
	    for _,c in ipairs(rc) do
  	  ----print(sql)
	  --DatabasePrepare ("sj", sql)
	  --local rc = DatabaseStep ("sj")
	  --while rc == 100 do
	     ----print("row",i)
	     --local values=  DatabaseColumnValues ("sj")
		 local row=tbl_query[c.id]
		-- print(c.id," id")
		 local v={}
		 setmetatable(v, {__index = _Vector})
	     --setmetatable(v,Vector)
		 v.roomno=row.roomno --values[1]
	     v.direction=row.direction --values[2]
		 v.linkroomno=row.linkroomno --values[3]
		 v.roomtype=row.roomtype --values[4]
		 v.weight=row.weight --values[5]
		 if v.roomtype==nil then
		    v.roomtype=""
		 end
		 --print("值",v.roomno)
		 if v.roomtype=="V" then
		    ----print("虚拟")
			----print(v.roomno)
			self:virtual(v)
			----print("虚拟检查结束1")
			----print("virtual" ," roomtype ",v.roomtype," roomno ",v.roomno)
		 else
		    real_list(v)
		 end
		 ----print("bug2")
		   ----print("vector2",v.roomno,v.direction,v.linkroomno,v.roomtype)
		   --读取数据库 检查top 没有插入 Bottom & Bottom_buffer
		 if T_Contain(v.roomno)==true and v.weight<=0 then
		  -- --print("true","Bottom",v.roomno)
	         table.insert(Bottom,v)
			 --Bottom[v.roomno]=v
		    -- DatabaseFinalize ("sj")
	         return true,v.roomno  --找到重合点
		  elseif pre_existing(Bottom_pre_existing,v.roomno)==false then
		    ----print("false")
			 --Bottom_Weight= Bottom_Weight+v.weight
             table.insert(Bottom_buffer,v)
		     table.insert(Bottom_pre_existing,v.roomno)
	         table.insert(Bottom,v)
		    ----print("Bottom_LENGth",table.getn(Bottom_buffer))
	        -- --print("TOP_LENGth",table.getn(Top_buffer))
		  end
		  ----print("next")
		 -- rc = DatabaseStep ("sj")
		  ----print("bug3")
	  end
	  ----print("关闭")
	  --DatabaseFinalize ("sj")
	  ----print("bug4")
	  end
    end

	return false,nil
end

--从开始节点开始搜索
function map:Top_Start()
    ----print("Top------------------------------------------")
	--co=coroutine.create(function()
    while true do
	   --buffer 长度
	   Top_buffer_len=table.getn(Top_buffer)
	   ----print("长度",Top_buffer_len,Bottom_buffer_len)
	   if Top_buffer_len > Bottom_buffer_len then
		  break
	   elseif Top_buffer_len==0 then
		 return false,nil
	   end
	  --循环读取
	  local roomno
	  while true do
	     roomno=Top_buffer[1]
	     table.remove(Top_buffer,1)
		 if roomno.weight>0 then
		    roomno.weight=roomno.weight-1
			table.insert(Top_buffer,roomno)
		 else
		    break
		 end
      end


	  --local sql="SELECT MUD_Entrance.roomno,MUD_Entrance.direction,MUD_Entrance.linkroomno,MUD_Room.roomtype,MUD_Entrance.weight from MUD_Entrance,MUD_Room where MUD_Room.roomno=MUD_Entrance.roomno and MUD_Entrance.roomno=" ..roomno.linkroomno.." order by weight asc"
	  --print(sql)
 	  --DatabasePrepare ("sj", sql)
	  --local rc = DatabaseStep ("sj")
	  --print("bug1",rc)
	  if tbl_top_query[roomno.linkroomno]~=nil then
	    local rc=tbl_top_query[roomno.linkroomno].rows

	   --while rc == 100 do
	    for _,c in ipairs(rc) do
		   -- print("id ",c.id)
		    local row=tbl_query[c.id]
	    --print("bug2")
	     --local values=  DatabaseColumnValues ("sj")
		   -- t--print (values)
		    --print(values[1],values[2],values[3],values[4])
			local v={}
			setmetatable(v, {__index = _Vector})
		    --setmetatable(v,Vector)
			v.roomno=row.roomno --values[1]
			v.direction=row.direction --values[2]
			v.linkroomno=row.linkroomno --values[3]
			v.roomtype=row.roomtype --values[4]
			v.weight=row.weight --values[5]
			if v.roomtype==nil then
		       v.roomtype=""
		    end
			--print("类型:",v.roomno)
			if v.roomtype=="V" then
			   ----print("虚拟")
			   ----print(v.roomno,v.direction)
			   self:virtual(v)
			   ----print("虚拟检查结束2")
			   ----print("virtual" ," roomtype ",v.roomtype," roomno ",v.roomno)
			else
		       real_list(v)
			end
		    ----print("vector1",v.roomno,v.direction,v.linkroomno,v.roomtype)
		 	 --读取数据库 检查top 没有插入 Bottom & Bottom_buffer
			if B_Contain(v.linkroomno)==true and v.weight<=0 then
			  ----print("true","Top",v.linkroomno)
	           table.insert(Top,v)
			    --Top[v.linkroomno]=v
			   --DatabaseFinalize ("sj")
			   --print("找到重合点")
	           return true,v.linkroomno  --找到重合点
			elseif pre_existing(Top_pre_existing,v.linkroomno)==false then
			    ----print("false")
			    ----print("vector2",v.roomno,v.direction,v.linkroomno)
				--Top_Weight= Top_Weight+v.weight
                table.insert(Top_buffer,v)
			    table.insert(Top_pre_existing,v.linkroomno)
	            table.insert(Top,v)
			  --local n
			  --n=table.getn(Top)
			  ----print("TOP",Top[n].roomno,Top[n].direction,Top[n].linkroomno)
			  --t--print(Top)
		      ----print("Bottom_LENGth",table.getn(Bottom_buffer))
	          ----print("TOP_LENGth",table.getn(Top_buffer))
			end
		    --rc = DatabaseStep ("sj")
	  end
      --DatabaseFinalize ("sj")
	  end
	 end
	 return false,nil
    --end)
   ----print(Top[1].roomno,Top[1].linkroomno,Top[2].roomno,Top[2].linkroomno)
   ----print("-------------------------------------Top")
   --return coroutine.resume(co)
end

local function top_serialize(linkroomno)
   local v={}
   for i,v in ipairs(Top) do
      if v.linkroomno==linkroomno then
	    ----print("top ",v.roomno,v.linkroomno,v.direction)
		return v.roomno,v.direction,v.roomtype
	  end
   end
   return v
end

local function bottom_serialize(roomno)
   local v={}
   v.linkroomno=nil
   v.direction=nil
   v.roomtype=nil
   --[[--print("-------start----")
   for i,v in ipairs(Bottom) do
    --print("bottom all ",v.roomno,v.linkroomno,v.direction)
   end
   --print("-------end----")]]
   for i,v in ipairs(Bottom) do
      if v.roomno==roomno then
	      ----print("returnvalue:",v.linkroomno,v.direction,v.roomtype)
		 return v.linkroomno,v.direction,v.roomtype
	  end
   end
   return v
end

local function Serialize(seed)
    ----print("seed:",seed)
    local T_Serialize=""
	local B_Serialize=""
	local T_room_type=""
	local B_room_type=""
	local roomno=""
	local direction=""
	local roomtype=""
	local rooms={}
	table.insert(rooms,seed)
	roomno,direction,roomtype=top_serialize(seed)
	while roomno~=nil and direction~=nil do
	    T_Serialize=direction .. ";" .. T_Serialize
		T_room_type=roomtype .. ";" .. T_room_type
	    ----print("roomno:",roomno,"dx:",direction)
		table.insert(rooms,1,roomno)
	    roomno,direction,roomtype=top_serialize(roomno)

		----print("ss2",roomno,direction)
	end
	----print("T_Serialize",T_Serialize)

    roomno,direction,roomtype=bottom_serialize(seed)
	----print("bp2:",roomno,direction,roomtype)
	while roomno~=nil and direction~=nil do
	    B_Serialize=B_Serialize .. direction .. ";"
		B_room_type=B_room_type .. roomtype .. ";"
		table.insert(rooms,roomno)
	    roomno,direction,roomtype=bottom_serialize(roomno)
		----print("roomno:",roomno,"dx:",direction)
	end
	----print("B_Serialize",B_Serialize)

	local path
	path=T_Serialize .. B_Serialize
	local room_type
	room_type=T_room_type .. B_room_type
	--print(path)
	--print(room_type)
	return path,room_type,rooms
end

function map:NewPath(FromRoomNo,ToRoomNo,Path,Room_Type,Type)
-- put some data into the database
  local roomno
  roomno=get_roomno()
  local sql="INSERT INTO MUD_Paths (FromRoomNo,ToRoomNo,Path,Room_Type,Type) VALUES ("..FromRoomNo..","..ToRoomNo..",'"..Path.."','"..Room_Type.."','')"
  ----print(sql)
  DatabaseExec ("db2",sql)
  DatabaseFinalize ("db2")
   DatabaseExec ("sj",sql)
   DatabaseFinalize ("sj")
end

local function Zone_Contain(zonename)
   --print(zonename)
   local Z
   for _,Z in ipairs(Zonelist) do
       ----print("z ",Z.toZone,"?",zonename)
      if Z.toZone==zonename then
	     return true
	  end
   end
   return false
end

local function ZoneClue(Zones,toZone)
  local Z
  for _,Z in ipairs(Zones) do
    if Z.toZone==toZone then
	   return Z.fromZone,Z.linkRoomNo
	end
  end
end

--路径
function Get_Path(FromRoomNo,ToRoomNo)
     local sql
	  sql=table.concat({"SELECT Path,Room_Type from MUD_Paths where FromRoomNo=",FromRoomNo," and ToRoomNo=",ToRoomNo})
	  local party=world.GetVariable("party") or ""
	  if party=="神龙教" then
	    sql=sql .. " and (party='神龙教' or party='通用' or party='' or party isnull)"
	  elseif party=="姑苏慕容" then
	    sql=sql .. " and (party='姑苏慕容' or party='通用2' or party='' or party isnull)"
	  elseif party=="灵鹫宫" then
	    sql=sql .. " and (party='灵鹫宫' or party='通用2' or party='' or party isnull)"
	  elseif party=="无" then
	    sql=sql.." and (party='无' or party='通用2' or party='' or party isnull)"
	  elseif party=="逍遥派" then
	    sql=sql.." and (party='逍遥派' or party='通用2' or party='' or party isnull)"
	  else
	    sql=sql .. " and (party='通用' or party='通用2' or party='' or party isnull)"
	  end
	  --print(sql)
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  --print(rc)
	  local values= DatabaseColumnValues ("sj")
      if values==nil then
	    --print("路径不存在:",sql)
		--print("插入数据库") --快捷路径
		 DatabaseFinalize ("sj") --关闭数据库
		 --print("关闭数据库!!!")
		  local startroomno=tonumber(FromRoomNo)
		 local endroomno=tonumber(ToRoomNo)
		 --print(startroomno," ",endroomno)
		local path,room_type,rooms=Search(startroomno,endroomno,true)
		  --[[if path~="noway;" then
		    local cmd=table.concat({"insert into MUD_Paths (FromRoomNo,Path,ToRoomNo,Room_Type) values(",FromRoomNo,",'",path,"',",ToRoomNo,",'",room_type,"')"})
		    --print(cmd)
		    DatabaseExec ("sj",cmd)
		  end]]
		  --print(path,"返回",FromRoomNo,"->",ToRoomNO)
		  return path,room_type
		--[[ local mp=map.new()
 		 mp.Search_end=function(path,room_type,rooms)
		    print(path)
		    if path~="noway;" then
			   --print("执行")
               local cmd=table.concat({"insert into MUD_Paths (FromRoomNo,Path,ToRoomNo) values(",FromRoomNo,",'",path,"',",ToRoomNo,")"})
			   print(cmd)
			   --print("执行2")
			   --DatabaseExec ("db",cmd)
			   --DatabaseFinalize ("db")
			   DatabaseExec ("sj",cmd)
			   DatabaseFinalize ("sj")
			end
	     end
		 local startroomno=tonumber(FromRoomNo)
		 local endroomno=tonumber(ToRoomNo)
	     mp:Search(startroomno,endroomno,true)
	    return "",""]]
	  end
	 -- --print(valuevalues)
	  local path=values[1] or ""
	  local roomtype=values[2] or ""
	  --print(path,roomtype," 路径结果")
	  if path=="" then
	      --print("路径不存在:",sql)
	  end
	 --   print(path,"返回",FromRoomNo,"->",ToRoomNO)
	  DatabaseFinalize ("sj")
	  return path,roomtype
end

function map:Zone_BusStop(Zones,toZone)
  -- --print(toZone," 房间名称")
   local Path=""
   local BusStop=""
   local fromZone,linkRoomNo=ZoneClue(Zones,toZone) --初始值
  -- print(Path,BusStop)
   while true do
	  Path=linkRoomNo..">"..Path
	  BusStop=fromZone..">"..BusStop
	  --print(fromZone," ?? ",linkRoomNo)
	  fromZone,linkRoomNo=ZoneClue(Zones,fromZone)
      if fromZone==nil then
	      break
	  end
   end
   BusStop=string.sub(BusStop,1,-2)
   Path=string.sub(Path,1,-2)
   --print(BusStop)
   --print(Path)
   Zonelist=nil--clear 区域数据
   return Path,BusStop
end

local function is_fuzhou(StartRoomNo)
   StartRoomNo=tonumber(StartRoomNo)
   if StartRoomNo>=1258 and StartRoomNo<=1267 then
      --1267
      return true
   else
      return false
   end
end
--/print(map:Zones("福州城","莆田少林",false,1258,1231))

function map:Zones(fromZone,toZone,opentime,StartRoomNo,EndRoomNo)
    --print(fromZone,toZone,opentime)

    local P1,Z1=self:ZonePath(fromZone,toZone,true)--白天路径
	local P2,Z2=self:ZonePath(fromZone,toZone,false)--晚上路径
	--print("",P1)
	--print(P2)
	if is_fuzhou(StartRoomNo) then
	    --print("fuzhou","YES")
		 P2,Z2=self:ZonePath(fromZone,toZone,'special')--晚上路径
	end
	 --print("P1:",P1,Z1)
	 --print("------------------")
	 --print("P2:",P2,Z2)
	local block=function()
	   local R={}
	   R=Split(P1,">")
	   local StartRoomNo=R[1]
	   local EndRoomNo=R[table.getn(R)]
	   print(StartRoomNo,EndRoomNo)
	   local Paths=""
	   local Type=""
	   for i=1,table.getn(R)-1,1 do
	      local SR=R[i]
		  local ER=R[i+1]
		  --print("区域:",P1," ",SR,"....",ER)
		  local P,T=Get_Path(SR,ER)
		  Paths=Paths..P
		  --print(Paths)
		 -- print("----------------")
		  Type=Type..T
	   end
	   return Paths,Type,tonumber(StartRoomNo),tonumber(EndRoomNo)
	end
	if Z1==Z2  then  --路径不区分白天黑夜
	   ----print("相同")
	   return block()
	else
	   if opentime==nil then
	      --print("判断白天或黑夜")
	      local al=alias.new()
	      al.finish=function(result)
			--print("判断时间结果:",result)
			self:Zone_Search(StartRoomNo,EndRoomNo,result)--更新当前时间进行判别。
			----print("P1:",P1,Z1)
			----print("------------------")
			----print("P2:",P2,Z2)
		    --if result==false then
			--  print("晚上")
			--else

        	--  P1=P2
            --  Z1=Z2
		    --end
			--print("----------------------")
			--print("P1:",P1,Z1)
		    --return block()
	      end
	      al:opentime("fuzhouchengximen")
	   elseif opentime==false then
	       P1=P2
	       Z1=Z2
		   --print("----------------------")
		   --print("P11:",P1,Z1)
	       return block()
	   else
	      --print("----------------------")
		  --print("P111:",P1,Z1)
	      return block()
	   end
	end
	--print("结果")
end


function map:ZonePath(fromZone,toZone,Opentime)
   Zonelist={}
   local linkZone={}
   linkZone.fromZone=nil
   linkZone.toZone=fromZone
   linkZone.linkRoomNo=nil
   table.insert(Zonelist,linkZone)
   local Zone_buffer={}
   table.insert(Zone_buffer,fromZone)
   while table.getn(Zone_buffer)>0 do
	  local Zone=Zone_buffer[1]
	  table.remove(Zone_buffer,1)

	    local sql
	    sql=table.concat({"SELECT FromZone,ToZone,LinkRoomNo from MUD_Zone where FromZone='",Zone,"' and (Party isnull or Party=''"})
	    local party=world.GetVariable("party") or ""
	    if party=="姑苏慕容" then
	      sql=table.concat({sql," or Party='姑苏慕容')"})
	    elseif party=="神龙教" and (toZone=="神龙岛" or fromZone=="神龙岛") then -- 目的地去神龙岛 并且是神龙教子弟才会从黄河流域穿越
	      sql=table.concat({sql," or Party='非慕容' or Party='神龙教')"})
	    elseif party=="灵鹫宫" and (toZone=="天山" or fromZone=="天山") then
		  sql=table.concat({sql," or Party='非慕容' or Party='灵鹫宫')"})
		elseif party=="逍遥派" then --逍遥派
		  sql=table.concat({sql," or Party='非慕容' or Party='逍遥派')"})
		elseif party=="无" then --百姓
		  sql=table.concat({sql," or Party='姑苏慕容' or Party='无')"})
	    else
		  sql=table.concat({sql," or Party='非慕容')"})
	    end
	    sql=table.concat({sql," and (condition isnull or condition=''"})
	    if Opentime==true then
	       sql=table.concat({sql," or condition='白天' or condition='福州城内')"})
	    elseif Opentime=='special' then
	       sql=table.concat({sql," or not condition='福州城内')"})
	    else
		   sql=table.concat({sql," or condition='福州城内')"}) --通用
	    end
        --print(sql)
 	     DatabasePrepare ("sj",sql)
	    local rc = DatabaseStep ("sj")
--插入
	    while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  ----print("房间号:",values[1])
          local linkZone={}
		  linkZone.fromZone=values[1]
          linkZone.toZone=values[2]
		  linkZone.linkRoomNo=values[3]
		  --print("quanzhen")
		  --linkZone.weight=values[4]

		  --print(linkZone.fromZone,linkZone.toZone,linkZone.linkRoomNo)
		   --print(linkZone.weight," weight")
		  if toZone==linkZone.toZone then
		     --print("区域检索结束")
		     table.insert(Zonelist,linkZone)
			 DatabaseFinalize ("sj")--关闭数据库
			 --[[ for _,Z in ipairs(Zonelist) do
			    print(Z.fromZone,">",Z.toZone," *",Z.linkRoomNo)
			 end]]
			 ------
			 return self:Zone_BusStop(Zonelist,toZone)

		  end
		   --print("结果",Zone_Contain(linkZone.toZone))
		  if Zone_Contain(linkZone.toZone)==false then

             table.insert(Zonelist,linkZone)
			 table.insert(Zone_buffer,linkZone.toZone)
		  end
		  rc = DatabaseStep ("sj")
	    end
--插入结束
	     DatabaseFinalize ("sj")
   end
     --print("结束1")
	  Zonelist={}
end
--压缩数据库
function zip_database()
   local sql="VACUUM"
   DatabaseExec ("sj",sql)
   DatabaseFinalize ("sj")
end

function insert_zone_For_Roomno(zone,roomno)
   local sql="insert into mud_room (ROOMNO,zone,relation,roomname,description,exits,roomtype) select ROOMNO,'"..zone.."',relation,roomname,description,exits,roomtype from mud_room where roomno="..roomno
   print(sql)
   DatabaseExec ("db2",sql)
   DatabaseFinalize ("db2")
   DatabaseExec ("sj",sql)
   DatabaseFinalize ("sj")
end

function Zone_For_Roomno(roomno)
     --print(roomno,"roomno")
     local sql=""
	 sql=table.concat({"SELECT zone from MUD_Room where not roomtype='fix' and roomno=",roomno})

	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  local zone=""
	  ----print(sql)
 	   while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  zone=values[1]
		  if zone~="" then
		     break
		  end
		  rc = DatabaseStep ("sj")
	   end
	  DatabaseFinalize ("sj")
	  if zone=="中原" then
	    zone="成都城"
	  end
	  if zone=="侠客岛" then
	     zone="佛山镇"
	  end
	  if zone=="中原神州" or zone=="极乐世界" then
	    zone="扬州城"
	  end
	  if zone=="试剑山庄" then
	    zone="长乐帮"
	  end
	  if zone=="摩天崖" then
	    zone="南阳城"
	  end

	  --print(zone," zone")
	  return zone
end
--清楚很长时间临时路径
--[[
function Del_TEMP_Path()
	local cmd="delete from MUD_Paths where Update_time<=strftime('%Y/%m/%d %H:%M:%S','now','-1 hour', 'localtime')"
	DatabaseExec ("sj",cmd)
	DatabaseFinalize ("sj")
	zip_database()
end]]

--获得实时计算生成的临时路径
function Get_TEMP_Path(FromRoomNo,ToRoomNo)
     local sql
	  sql=table.concat({"SELECT Path,Room_Type from MUD_Paths where FromRoomNo=",FromRoomNo," and ToRoomNo=",ToRoomNo})
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  --print(rc)
	  local values= DatabaseColumnValues ("sj")
      if values==nil then
	    DatabaseFinalize ("sj")
	    --print("路径不存在:",sql)
	    return false,"",""
	  end
	 -- --print(valuevalues)
	  local path=values[1] or ""
	  local roomtype=values[2] or ""
	  --print(path,roomtype," 路径结果")
	  if path=="" then
	      --print("路径不存在:",sql)
		  return false,"",""
	  end
	   local cmd="update MUD_Paths set Update_time=strftime('%Y/%m/%d %H:%M:%S','now', 'localtime') where FromRoomNo="..FromRoomNo.." and ToRoomNo="..ToRoomNo
	   DatabaseExec ("sj",cmd)
	   DatabaseFinalize ("sj")
	  return true,path,roomtype
end

--获得相关房间的特殊路径
function  Get_Special(Rooms)
     local condition=""
     for _,r in ipairs(Rooms) do
	    condition=condition.."roomno="..r.." or linkroomno="..r.." or "
	 end
	 if string.len(condition)>0 then
	    condition="("..string.sub(condition,1,-4)..")"
	 end
	 local cmd=""
	 cmd=" (direction<>'north' and direction<>'east' and direction<>'west' and direction<>'south'"
	 cmd=cmd.." and direction<>'northeast' and direction<>'northwest' and direction<>'northup' and direction<>'northdown'"
	  cmd=cmd.." and direction<>'southeast' and direction<>'southwest' and direction<>'southup' and direction<>'southdown'"
	   cmd=cmd.." and direction<>'eastup' and direction<>'eastdown' and direction<>'westup' and direction<>'westdown'"
	    cmd=cmd.." and direction<>'up' and direction<>'down' and direction<>'enter' and direction<>'out') and "
     local sql
	  sql=table.concat({"SELECT distinct direction from MUD_Entrance where",cmd,condition})
	 -- print(sql)
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  local dx={}

      while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  print("方向:",values[1])
		  local direction=values[1]
		  table.insert(dx,direction)
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")
	  return dx
end

function Pload()
	  print("-----------------显示内存数据库记录数----------------")
	  local cmd="select count(*) from MUD_Paths"
	  DatabasePrepare ("sj", cmd)
	   local rc = DatabaseStep ("sj")
	  --print(rc)
	  local values= DatabaseColumnValues ("sj")
      print("Mud_Paths 行数:",values[1])
	   print("-----------------结束-------------------------------")
	  DatabaseFinalize ("sj")
end

function Insert_TEMP_Path(FromRoomNo,ToRoomNo,Path)
    if Path~="noway;" and string.len(Path)>=10 then --超过10步以上路径加入
      -- print("执行")
	  local cmd=table.concat({"insert into MUD_Paths (FromRoomNo,Path,ToRoomNo,Update_time) values(",FromRoomNo,",'",Path,"',",ToRoomNo,",date())"})
	   --print(cmd)
	  -- DatabasePrepare ("sj", sql)
	   DatabaseExec ("sj",cmd)
	   DatabaseFinalize ("sj")
	end
end

function map:Zone_Search(StartRoomNo,EndRoomNo,opentime)
    -- print(StartRoomNo)
    local StartZone=Zone_For_Roomno(StartRoomNo)
	local EndZone=Zone_For_Roomno(EndRoomNo)
	--print(EndZone," EndZone")
	--print(StartZone," StartZone")
	if StartZone==nil or EndZone==nil or StartZone=="" or EndZone=="" or EndZone==StartZone then
	   self:Search(StartRoomNo,EndRoomNo,opentime)
	   return
	end

    local Paths,Type,Start_linkRoomNo,End_linkRoomNo=self:Zones(StartZone,EndZone,opentime,StartRoomNo,EndRoomNo)
	--print(StartZone,EndZone)
	--print("结果path",Paths)
	if Paths==nil then  --需要判别当前时间(白天，晚上) self:Zones 会返回空路径
	   return
	end
	local mp=map:new()
	local tail=function() --尾部
	    if End_linkRoomNo~=EndRoomNo then
		  local is_exist,g_path,g_room_type=Get_TEMP_Path(End_linkRoomNo,EndRoomNo) --获得临时路径表数据
		   if is_exist==true then  --存在路径
		      Paths=Paths..g_path
			  Type=Type..g_room_type
			  self.Search_end(Paths,Type,nil)
		   else
		       mp.Search_end=function(path,room_type,rooms)
	             Paths=Paths..path
	             Type=Type..room_type
				  --Insert_TEMP_Path(End_linkRoomNo,EndRoomNo,path)  --插入临时路径表
		         --print(Paths,Type)
		         self.Search_end(Paths,Type,nil)
	           end
	           mp:Search(End_linkRoomNo,EndRoomNo,opentime)
		   end
	    else
		    self.Search_end(Paths,Type,nil)
	    end
	end
	if StartRoomNo~=Start_linkRoomNo then
	  local is_exist,g_path,g_room_type=Get_TEMP_Path(StartRoomNo,Start_linkRoomNo) --获得临时路径表数据
	  if is_exist==true then  --存在路径
		   Paths=g_path..Paths
	       Type=g_room_type..Type
	        ----print(Paths)
	        ----print(Type)
		   tail()
	  else
	      mp.Search_end=function(path,room_type,rooms)
	       --print("插入:",path)
	       Paths=path..Paths
	       Type=room_type..Type
		   --Insert_TEMP_Path(StartRoomNo,Start_linkRoomNo,path)  --插入临时路径表
		   --print("插入2")
		   tail()
	      end
	      mp:Search(StartRoomNo,Start_linkRoomNo)
	  end
	else
      tail()
	end
    --search_count=search_count+1
	--print("search_count:",search_count)
	--if search_count>=300 then --关闭数据库超过300次查询 释放内存
	--	print("内存释放!!")
	--	search_count=0
	--	DatabaseClose ("sj")
	--	import_data() --重新加载数据库
	--end
end

function map:createPaths()
	 local sql
	  sql="SELECT FromZone,ToZone,LinkRoomNo from MUD_Zone"

 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  local rooms={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  ----print("房间号:",values[1])
		  local R={}
		  R.fromZone=values[1]
          R.toZone=values[2]
		  R.linkRoomNo=values[3]
          table.insert(rooms,R)
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")

   local room2={}
   for _,r in ipairs(rooms) do

	  sql="SELECT LinkRoomNo from MUD_Zone where FromZone='"..r.toZone.."'"
      DatabasePrepare ("sj", sql)
	  rc = DatabaseStep ("sj")
	  local Rooms={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  ----print("房间号:",values[1])
		  local R2={}
		  R2.StartRoomNo=r.linkRoomNo
		  R2.EndRoomNo=values[1]
          --print(R2.StartRoomNo,R2.EndRoomNo)
          table.insert(room2,R2)
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")
   end

   --
   for _,g in ipairs(room2) do
      self.Search_end=function(path,room_type,rooms)  --路径 房间类型 所有经过的房间号
		   self:NewPath(g.StartRoomNo,g.EndRoomNo,path,room_type)
	  end
      --self:Search(g.StartRoomNo,g.EndRoomNo,false)
	  self:Search(g.StartRoomNo,g.EndRoomNo,true) --白天
   end
   --print("创建路径结束")
end

local function Bottom_Start(opentime)
    ------print("BOTTOM------------------------------")
    while true do
	   --buffer 长度
	   Bottom_buffer_len=table.getn(Bottom_buffer)
	  -- if Bottom_buffer_len> Top_buffer_len then
       if Bottom_buffer_len> Top_buffer_len then
	      break
	   elseif Bottom_buffer_len==0 then

		  return false,nil
	   end
	  --循环读取
	  local linkroomno
	  while true do
	    linkroomno=Bottom_buffer[1]
		table.remove(Bottom_buffer,1)
		if linkroomno.weight>0 then
		   -- print(linkroomno," linkroomno weight ",linkroomno.weight)
		   linkroomno.weight=linkroomno.weight-1
		   table.insert(Bottom_buffer,linkroomno)
		else
		   break
		end
	  end

	  --print(linkroomno.roomno," roomno"," dir",linkroomno.direction)
	   ------print("Bottom_LENGth",table.getn(Bottom_buffer))
	   ----print("TOP_LENGth",table.getn(Top_buffer))
	  --local sql="SELECT MUD_Entrance.roomno,MUD_Entrance.direction,MUD_Entrance.linkroomno,MUD_Room.roomtype,MUD_Entrance.weight from MUD_Entrance,MUD_Room where MUD_Room.roomno=MUD_Entrance.roomno and linkroomno=" ..linkroomno.roomno.." order by weight asc"
	  --print(sql)
	  --DatabasePrepare ("sj", sql)
	  --local rc = DatabaseStep ("sj")
	  --print(rc,"rc")
	  --while rc == 100 do
	 if tbl_bottom_query[linkroomno.roomno]~=nil then
	    local rc=tbl_bottom_query[linkroomno.roomno].rows
	    for _,c in ipairs(rc) do
  	  ----print(sql)
	  --DatabasePrepare ("sj", sql)
	  --local rc = DatabaseStep ("sj")
	  --while rc == 100 do
	     ----print("row",i)
	     --local values=  DatabaseColumnValues ("sj")
		 local row=tbl_query[c.id]
		----print("row",i)
	     --local values=  DatabaseColumnValues ("sj")
		 local v={}
		 setmetatable(v, {__index = _Vector})
	     --setmetatable(v,Vector)
		 v.roomno=row.roomno --values[1]
	     v.direction=row.direction--values[2]
		 v.linkroomno=row.linkroomno--values[3]
		 v.roomtype=row.roomtype--values[4]
		 v.weight=row.weight--values[5]
		 if v.roomtype==nil then
		    v.roomtype=""
		 end
		 if v.roomtype=="V"  then
		    if (opentime==nil or opentime==true) then
             virtual_list(v)
	         for i,pre in ipairs(Bottom) do
	        ------print(pre.roomno," ",pre.direction," ",pre.linkroomno)
	          if pre.linkroomno==v.roomno then
	            ------print("bottom_virtual:",pre.roomno," ",pre.direction," ",pre.linkroomno)
	            v.roomno=pre.roomno
		        v.direction=pre.direction
		        break
	           end
	         end
	      ------print("top")
	       for i,pre in ipairs(Top) do
	           ------print(pre.roomno," ",pre.direction," ",pre.linkroomno)
		    if pre.linkroomno==v.roomno then
	           ------print("top_virtual:",pre.roomno," ",pre.direction," ",pre.linkroomno)
		       v.roomno=pre.roomno
		       v.direction=pre.direction
		       break
	        end
	       end
		   ----------------
		   if T_Contain(v.roomno)==true and v.weight<=0 then
		   -- print("true","Bottom",v.roomno,v.weight,v.direction)
	         table.insert(Bottom,v)
			 --Bottom[v.roomno]=v
		     --DatabaseFinalize ("sj")
	         return true,v.roomno  --找到重合点
		   elseif pre_existing(Bottom_pre_existing,v.roomno)==false then

             table.insert(Bottom_buffer,v)
		     table.insert(Bottom_pre_existing,v.roomno)
	         table.insert(Bottom,v)
		    end
		   ----------------
		  end
		 else
		    real_list(v)
			if T_Contain(v.roomno)==true and v.weight<=0 then
		  -- --print("true","Bottom",v.roomno)
		    -- print("true","Bottom",v.roomno,v.weight,v.direction)
	         table.insert(Bottom,v)
			 --Bottom[v.roomno]=v
		     --DatabaseFinalize ("sj")
	         return true,v.roomno  --找到重合点
		   elseif pre_existing(Bottom_pre_existing,v.roomno)==false then

             table.insert(Bottom_buffer,v)
		     table.insert(Bottom_pre_existing,v.roomno)
	         table.insert(Bottom,v)
		    end
		end


		--rc = DatabaseStep ("sj")

	  end

	  --DatabaseFinalize ("sj")
	  end
    end

	return false,nil
end

local function Top_Start(opentime)

    while true do
	   --buffer 长度
	   -- print("Top_Weight:",Top_Weight)
	   Top_buffer_len=table.getn(Top_buffer)
	   ----print("长度",Top_buffer_len,Bottom_buffer_len)
	   if Top_buffer_len > Bottom_buffer_len then
		  break
	   elseif Top_buffer_len==0 then
		 return false,nil
	   end
	  --循环读取
	  --有权重的房间放回队列末尾
	  local roomno
	  while true do
	    roomno=Top_buffer[1]
	    table.remove(Top_buffer,1)
	    if roomno.weight>0 then
		   --print(roomno," roomno weight: ",roomno.weight)
	       roomno.weight=roomno.weight-1
		   table.insert(Top_buffer,roomno) --插入最后
		else
		   break
	    end
	  end
	 -- print(roomno.linkroomno," linkroomno"," dir",roomno.direction)

	  --local sql="SELECT MUD_Entrance.roomno,MUD_Entrance.direction,MUD_Entrance.linkroomno,MUD_Room.roomtype,MUD_Entrance.weight from MUD_Entrance,MUD_Room where MUD_Room.roomno=MUD_Entrance.roomno and MUD_Entrance.roomno=" ..roomno.linkroomno.." order by weight asc"
	  --print(sql)
 	  --DatabasePrepare ("sj", sql)
	  --local rc = DatabaseStep ("sj")
	  if tbl_top_query[roomno.linkroomno]~=nil then
	    local rc=tbl_top_query[roomno.linkroomno].rows

	   --while rc == 100 do
	    for _,c in ipairs(rc) do
		   -- print("id ",c.id)
		    local row=tbl_query[c.id]
	    --print("bug2")
	     --local values=  DatabaseColumnValues ("sj")
		   -- t--print (values)
		    --print(values[1],values[2],values[3],values[4])
	  --while rc == 100 do
	     --print("bug2")
	     --local values=  DatabaseColumnValues ("sj")
		   -- t--print (values)
		    --print(values[1],values[2],values[3],values[4])
			local v={}
			setmetatable(v, {__index = _Vector})
		    --setmetatable(v,Vector)
			v.roomno=row.roomno--values[1]
			v.direction=row.direction --values[2]
			v.linkroomno=row.linkroomno--values[3]
			v.roomtype=row.roomtype--values[4]
			v.weight=row.weight --values[5]
			--print(v.weight," weight")
			if v.roomtype==nil then
		       v.roomtype=""
		    end
			----print("类型:",v.roomtype)
			if v.roomtype=="V" then
			  if (opentime==nil or opentime==true) then
				virtual_list(v)
	         for i,pre in ipairs(Bottom) do
	        ------print(pre.roomno," ",pre.direction," ",pre.linkroomno)
	          if pre.linkroomno==v.roomno then
	            ------print("bottom_virtual:",pre.roomno," ",pre.direction," ",pre.linkroomno)
	            v.roomno=pre.roomno
		        v.direction=pre.direction
		        break
	           end
	         end
	      ------print("top")
	          for i,pre in ipairs(Top) do
	             ------print(pre.roomno," ",pre.direction," ",pre.linkroomno)
		        if pre.linkroomno==v.roomno then
	           ------print("top_virtual:",pre.roomno," ",pre.direction," ",pre.linkroomno)
		         v.roomno=pre.roomno
		         v.direction=pre.direction
		         break
	            end
	           end
			   ---------------------------
			  if B_Contain(v.linkroomno)==true and v.weight<=0 then
	              table.insert(Top,v)
				   --Top[v.linkroomno]=v
				  -- print("true","Top",v.linkroomno,v.weight,v.direction)
			     -- DatabaseFinalize ("sj")
	              return true,v.linkroomno  --找到重合点
			   elseif pre_existing(Top_pre_existing,v.linkroomno)==false then
                  table.insert(Top_buffer,v)
			      table.insert(Top_pre_existing,v.linkroomno)
	              table.insert(Top,v)
			   end
			   -----------------
		      end
			else
		       real_list(v)
              if B_Contain(v.linkroomno)==true and v.weight<=0 then
	              table.insert(Top,v)
				  --Top[v.linkroomno]=v
				  -- print("true","Top",v.linkroomno,v.weight,v.direction)
			      --DatabaseFinalize ("sj")
	              return true,v.linkroomno  --找到重合点
			   elseif pre_existing(Top_pre_existing,v.linkroomno)==false then
                  table.insert(Top_buffer,v)
			      table.insert(Top_pre_existing,v.linkroomno)
	              table.insert(Top,v)
			   end
			end

		    --rc = DatabaseStep ("sj")
	   end
	  end
      --DatabaseFinalize ("sj")
	 end
	 return false,nil
end

function Search(StartRoomNo,EndRoomNo,opentime)  --异步 开始房间 结束房间 时间 白昼 或 夜晚
   --print(StartRoomNo," ",EndRoomNo,"why")
	Bottom_buffer_len=1
	Top_buffer_len=1
	Top={}
	Bottom={}
	Top_buffer={}
    Bottom_buffer={}
	Top_pre_existing={}
	Bottom_pre_existing={}
	_list={}
	----print("BF",Bottom_buffer[1])
	local S={}
	local E={}
	S.roomno=nil
	S.weight=0
	S.linkroomno=StartRoomNo
	E.linkroomno=nil
	E.weight=0
	E.roomno=EndRoomNo

	table.insert(Bottom_buffer,E)
	table.insert(Top_buffer,S)
	table.insert(Top_pre_existing,StartRoomNo)
	--table.insert(Top_buffer,StartRoomNo)
	--table.insert(Bottom_buffer,EndRoomNo)

	table.insert(Bottom_pre_existing,EndRoomNo)
	local h={}
	setmetatable(h, {__index = _Vector})
	--setmetatable(h,Vector)
	h.roomno=nil
	h.linkroomno=StartRoomNo
	h.direction=nil
	local e={}
	e.roomno=EndRoomNo
	e.linkroomno=nil
	e.direction=nil
	setmetatable(e, {__index = _Vector})
	--setmetatable(e,Vector)
	table.insert(Top,h)
	table.insert(Bottom,e)

	local result
    local roomno


	local noway=false
	while true do
	   if Bottom_buffer_len==0 or Top_buffer_len==0 then
	      --print("没有通路!!!")
		  noway=true
		  break
	   end
	   result,roomno = Top_Start(opentime)
	   --print(result," r1")
	   if result==true then

		 break
	   else
		   result,roomno=Bottom_Start(opentime)
		    --print(result," r2")
		   if result==true then

		      break
		   end
	   end
	end

	local path=nil
	local room_type=nil
	local rooms={}
	if noway==false then
	  path,room_type,rooms=Serialize(roomno)
    end
	if path==nil or path=="" then
	    --print("无法到达,noway")
	   path="noway;"
	end
	if room_type==nil or room_type=="" then
	   room_type=";"
	end

	  Bottom={}
      Bottom_buffer={} --底部检索队列
      Bottom_buffer_len=0
      Bottom_pre_existing={}
	  Top={}
      Top_buffer={} --顶部检索队列
      Top_buffer_len=0
      Top_pre_existing={}
	  _list={} --虚拟房间列表
	  --print("房间")
	  --for _,r in ipairs(rooms) do
	  --   print(r)
	  --end
	  return path,room_type,rooms
end


function map:Search(StartRoomNo,EndRoomNo,opentime)  --异步 开始房间 结束房间 时间 白昼 或 夜晚

    self.opentime=opentime
	self.start=StartRoomNo
	self.End=EndRoomNo
    Bottom_buffer_len=1
	Top_buffer_len=1
	Top={}
	Bottom={}
	Top_buffer={}
    Bottom_buffer={}
	Top_pre_existing={}
	Bottom_pre_existing={}
	_list={}
	----print("BF",Bottom_buffer[1])


	--table.insert(Top_buffer,StartRoomNo)
	table.insert(Top_pre_existing,StartRoomNo)
	--table.insert(Bottom_buffer,EndRoomNo)
	table.insert(Bottom_pre_existing,EndRoomNo)
	local h={}
	setmetatable(h, {__index = _Vector})
	--setmetatable(h,Vector)
	h.roomno=nil
	h.linkroomno=StartRoomNo
	h.direction=nil
	h.weight=0
	local e={}
	e.roomno=EndRoomNo
	e.linkroomno=nil
	e.direction=nil
	e.weight=0
	setmetatable(e, {__index = _Vector})
	--setmetatable(e,Vector)
	table.insert(Top,h)
	table.insert(Bottom,e)
    table.insert(Bottom_buffer,e)
	table.insert(Top_buffer,h)
	local result
    local roomno

	self.Search_co={}
	self.Search_co=coroutine.create(function()
	----print("bug1")
	local noway=false
	while true do
	   if Bottom_buffer_len==0 or Top_buffer_len==0 then
	      --print("没有通路!!!")
		  noway=true
		  break
	   end
	   result,roomno = self:Top_Start()
	   ----print(result," r1")
	   if result==true then

		 break
	   else
		   result, roomno=self:Bottom_Start()
		    ----print(result," r2")
		   if result==true then

		      break
		   end
	   end
	end
	----print("roomno:",roomno,noway)
	local path=nil
	local room_type=nil
	local rooms={}
	if noway==false then
	  path,room_type,rooms=Serialize(roomno)
    end
	if path==nil or path=="" then
	    --print("无法到达,noway")
	   path="noway;"
	end
	if room_type==nil or room_type=="" then
	   room_type=";"
	end
	  --print("路径:",path)
	  --print("type",roomtype)
	  --clear 清理所有变量
	  Bottom={}
      Bottom_buffer={} --底部检索队列
      Bottom_buffer_len=0
      Bottom_pre_existing={}
	  Top={}
      Top_buffer={} --顶部检索队列
      Top_buffer_len=0
      Top_pre_existing={}
	  _list={} --虚拟房间列表
	  --self.Search_co=nil
      self.opentime=nil
      self.start=nil
      self.End=nil
      self.user_alias=nil
	  self.Search_end(path,room_type,rooms)
	end)
	----print(coroutine.resume(co))
	coroutine.resume(self.Search_co)
	--return _path,_roomtype
end
--Search(450,960)
---插入数据库 新建房间
--类
function is_crowd(roomno)
  local sql
  sql="select roomno from MUD_Crowd where crowd_roomno in (select distinct crowd_roomno from MUD_Crowd where roomno="..roomno..")"
  ----print(sql)
  DatabasePrepare ("sj", sql)
  local rc = DatabaseStep ("sj")
  local crowd={}
  while rc == 100 do
	local values=  DatabaseColumnValues ("sj")
	--print("crow:",values[1])
    table.insert(crowd,values[1])
	rc = DatabaseStep("sj")
  end
  DatabaseFinalize ("sj")
  if table.getn(crowd)==0 then
     table.insert(crowd,roomno)
  end
  return crowd
end

function partition(lc)
  local location=Trim(lc)
  print(lc)
  --fill zone
  local sql
  sql="select distinct zone from MUD_Room where not zone=''"
  DatabasePrepare ("sj", sql)
  local rc = DatabaseStep ("sj")
  local zonename={}
  while rc == 100 do
	local values=  DatabaseColumnValues ("sj")
	----print("zonename:",values[1])
    table.insert(zonename,values[1])
	rc = DatabaseStep("sj")
  end
  DatabaseFinalize ("sj")
  ----print("fill end")
  --fill end
  local maybe={}
  for _,z in ipairs(zonename) do
    --print(z)
    local s,e= string.find(location,z)
    --print(s,e)
	if s==1 and (string.len(location)-e)>2 then
	    ----print(string.sub(location,1,e)," " ,string.sub(location,e+1,string.len(location)))
	    local zone=string.sub(location,1,e)
	    local roomname=string.sub(location,e+1,string.len(location))
	    local result={}
	    result.zone=zone
	    result.roomname=roomname
	    --print(zone,"  ",roomname)
	    table.insert(maybe,result)
	end
  end
  return maybe
end

--区域
function WhereZone(zone)   --目标房间查找
      --print("where")
   	  local sql
	   sql="SELECT distinct roomno,roomtype from MUD_Room where zone='" ..zone .. "'"

	  --sql=sql..
	  --print(sql)
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  local rooms={}
	  local crowd_roomno={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  ----print("房间号:",values[1])
		  if values[2]=="C" or values[2]=="G" then -- crowd 集群
	        --print("test")
	        table.insert(crowd_roomno,values[1])
			--新增 2011-6-11
			table.insert(rooms,values[1])
			--新增结束
	      else
	        table.insert(rooms,values[1])
	      end
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")
   for _,c in ipairs(crowd_roomno) do
      sql="select roomno from MUD_Crowd where crowd_roomno="..c
	  --print(sql)
	  DatabasePrepare ("sj", sql)
	  rc = DatabaseStep ("sj")
	  while rc == 100 do
         local values = DatabaseColumnValues ("sj")
		 ----print(values[1])
	     table.insert(rooms,values[1])
		 rc = DatabaseStep ("sj")  -- read next row
	  end
	  DatabaseFinalize ("sj")
   end -- while loop
   --冒泡法排序
   for j=1,table.getn(rooms) do
     for i,r in ipairs(rooms) do
       local p,n
	   p=rooms[i]
	   n=rooms[i+1]

	   if n~=nil then
	      if tonumber(n)<tonumber(p) then
		    rooms[i]=n
			rooms[i+1]=p
		  end
	   end
     end
   end
   for _,r in ipairs(rooms) do
   --排序
     print("房间号:",r)
   end
   return table.getn(rooms),rooms
end

function GetRoomName(roomno) --从房间号获得房间名称
   local sql="SELECT distinct roomname from MUD_Room where roomno="..roomno
    DatabasePrepare ("sj", sql)
	--print("sql:",sql)
	local rc = DatabaseStep ("sj")
    local roomname=""
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		   roomname=values[1]
		   rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")
	  --print(roomname," name")
	  return roomname
end

function FindZoomName(roomname)
      roomname=Trim(roomname)

	  local result={}

   	  local sql
      if table.getn(result)==0 then
		  sql="SELECT distinct roomno,roomtype from MUD_Room where roomname='" ..roomname .. "'"
	  else
	      sql="SELECT distinct roomno,roomtype from MUD_Room where "
	      for _,p in ipairs(result) do
	        sql=sql .. "(roomname='" ..p.roomname .. "' and zone='" ..p.zone.."') or "
	      end
		  sql=string.sub(sql,1,-4)
	  end
	  --sql=sql..
	  --print(sql)
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  local rooms={}
	  local crowd_roomno={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  if values[1]~=nil then
		  ----print("房间号:",values[1])
		   if values[2]=="C" or values[2]=="G" then -- crowd 集群
	        --print("test")
	        table.insert(crowd_roomno,values[1])
			--新增 2011-6-11
			table.insert(rooms,values[1])
			--新增结束
	       else
	        table.insert(rooms,values[1])
	       end
		  end
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")
   for _,c in ipairs(crowd_roomno) do
      sql="select roomno from MUD_Crowd where crowd_roomno="..c
	  --print(sql)
	  DatabasePrepare ("sj", sql)
	  rc = DatabaseStep ("sj")
	  while rc == 100 do
         local values = DatabaseColumnValues ("sj")
		 ----print(values[1])
		 if values[1]~=nil then
	       table.insert(rooms,values[1])
		 end
		 rc = DatabaseStep ("sj")  -- read next row
	  end
	  DatabaseFinalize ("sj")
   end -- while loop
   --冒泡法排序
   for j=1,table.getn(rooms) do
     for i,r in ipairs(rooms) do
       local p,n
	   p=rooms[i]
	   n=rooms[i+1]

	   if n~=nil then
	      if tonumber(n)<tonumber(p) then
		    rooms[i]=n
			rooms[i+1]=p
		  end
	   end
     end
   end
   for _,r in ipairs(rooms) do
   --排序
     print("房间号:",r)
   end
   return table.getn(rooms),rooms
end
--3174 1524
--需要排除的房间

function Where(zone_roomname,auto)   --目标房间查找
      --print("where")
	  zone_roomname=Trim(zone_roomname)

	  local result={}
	  if auto==nil or auto==false then
	      result=partition(zone_roomname)
      end
   	  local sql
      if table.getn(result)==0 then
		  sql="SELECT distinct roomno,roomtype from MUD_Room where roomname='" ..zone_roomname .. "'"
	  else
	      sql="SELECT distinct roomno,roomtype from MUD_Room where "
	      for _,p in ipairs(result) do
	        sql=sql .. "(roomname='" ..p.roomname .. "' and zone='" ..p.zone.."') or "
	      end
		  sql=string.sub(sql,1,-4)
	  end
	  --sql=sql..
	  --print(sql)
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  local rooms={}
	  local crowd_roomno={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  if values[1]~=nil then
		  ----print("房间号:",values[1])
		   if values[2]=="C" or values[2]=="G" then -- crowd 集群
	        --print("test")
	        table.insert(crowd_roomno,values[1])
			--新增 2011-6-11
			table.insert(rooms,values[1])
			--新增结束
	       else
	        table.insert(rooms,values[1])
	       end
		  end
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")
   for _,c in ipairs(crowd_roomno) do
      sql="select roomno from MUD_Crowd where crowd_roomno="..c
	  --print(sql)
	  DatabasePrepare ("sj", sql)
	  rc = DatabaseStep ("sj")
	  while rc == 100 do
         local values = DatabaseColumnValues ("sj")
		 ----print(values[1])
		 if values[1]~=nil then
	       table.insert(rooms,values[1])
		 end
		 rc = DatabaseStep ("sj")  -- read next row
	  end
	  DatabaseFinalize ("sj")
   end -- while loop
   --冒泡法排序
   for j=1,table.getn(rooms) do
     for i,r in ipairs(rooms) do
       local p,n
	   p=rooms[i]
	   n=rooms[i+1]

	   if n~=nil then
	      if tonumber(n)<tonumber(p) then
		    rooms[i]=n
			rooms[i+1]=p
		  end
	   end
     end
   end
   for _,r in ipairs(rooms) do
   --排序
     print("房间号:",r)
   end
   return table.getn(rooms),rooms
end

--寻找npc
function GetNpcID(npc)
       local sql="SELECT distinct id1,id2,id3 from MUD_Npc where name='"..npc.."'"
 	  DatabasePrepare ("sj", sql)
	  rc = DatabaseStep ("sj")
	  --print(sql)
      local ids={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  --print("房间号:",values[1])
		  --table.insert(roomno,values[2])
		  local id1=values[1]
		  local id2=values[2]
		  local id3=values[3]
		  local id={}
		  id.id1=id1
		  id.id2=id2
		  id.id3=id3
		  table.insert(ids,id)
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")

   return ids
end

--寻找npc
function WhereIsNpc(npc)
       local sql="SELECT distinct name,roomno from MUD_Npc where name='"..npc.."' or id1='"..npc.."' or id2='"..npc.."' or id3='"..npc.."'"
 	  DatabasePrepare ("sj", sql)
	  rc = DatabaseStep ("sj")
	  --print(sql)
      local roomno={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  print("房间号:",values[1])
		  table.insert(roomno,values[2])
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")

   return roomno
end
---------------------------------------------------------------------------------------------
--你要看什么？
--mushclient 创建触发器
local function CreateTriggerGroup()
  --print("ok?")
  -- world.AddTriggerEx ("look", "^(> |)设定环境变量：look \\= 1$", "Room.Look()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 50);
   world.AddTriggerEx ("zone", "^(|> )【你现在正处于(.*)】$", "--print(\"%2\")\nRoom.Zone(\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   world.AddTriggerEx ("relation", "^(.*)$", "Room.Relation(\"%1\")\n--print(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 151);
   world.AddTriggerEx ("roomname", "^(.*)-\\s*$", "Room.RoomName(\"%1\")\n--print(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   --抓取所有描述
   world.AddTriggerEx ("roomdesc", "^(.*)$", "--print(\"%1\")\nRoom.Description(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 151);
   --这是一个盛夏的夜晚，夜幕笼罩著大地。　　这是一个阳春三月的深夜，夜幕低垂，天上飘着如絮的云朵，星星眨着眼。
   world.AddTriggerEx ("weather", "^　　这是(.*)。$", "--print(\"环境描述\")\nRoom.Weather(\"%1\")\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   world.AddTriggerEx ("roomexits", "^\\s*这里(明显|唯一)的出口是(.*)。$", "Room.Exits(\"%2\")\n--print(\"%2\")\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);

   world.AddTriggerEx ("roomexits2", "^\\s*这里没有任何明显的出路。$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   world.AddTriggerEx ("roomexits3", "^\\s*这里看不见任何明显的出路。$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   world.AddTriggerEx ("roomexits4", "^\\s*这里看得见(明显|唯一)的出口是(.*)。$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
--这里看得清的出口是 north、south。
   world.AddTriggerEx ("roomexits5", "^\\s*这里看得清的出口是(.*)。$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
--这里看得见的唯一出口是 north。
   world.AddTriggerEx ("roomexits6", "^\\s*这里看得见的唯一出口是(.*)。$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
--这里看不见任何明显的出路。
   world.AddTriggerEx ("roomexits7", "^\\s*这里看不见任何明显的出路。$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);

   --world.SetTriggerOption ("look", "group", "roominfo");
   world.SetTriggerOption ("zone", "group", "roominfo");
   world.SetTriggerOption ("relation", "group", "roominfo");
   world.SetTriggerOption ("roomname", "group", "roominfo");
   world.SetTriggerOption ("roomdesc", "group", "roominfo");
   world.SetTriggerOption ("weather", "group", "roominfo");
   world.SetTriggerOption ("roomexits", "group", "roominfo");
   world.SetTriggerOption ("roomexits2", "group", "roominfo");
   world.SetTriggerOption ("roomexits3", "group", "roominfo");
   world.SetTriggerOption ("roomexits4", "group", "roominfo");
   world.SetTriggerOption ("roomexits5", "group", "roominfo");
   world.SetTriggerOption ("roomexits6", "group", "roominfo");
   world.SetTriggerOption ("roomexits7", "group", "roominfo");
end

--[[local _Room={ --数据结构
    zone="",
    relation="",
    roomname="",
    description="",
	weather="",
    exits="",
}]]
local _RC={} --存放临时数据
Room={
    new=function()
     local  _RA={}--初始化
	 setmetatable(_RA,{__index=Room})
	 return _RA
    end,
	version=1.8,
   Look=function()
	  _RC.zone=""
      world.EnableTrigger("look",false)
	  world.EnableTrigger("zone",true)
      world.EnableTrigger("relation",true)
      world.EnableTrigger("roomname",true)
   end,
   Zone=function (zone)
     --print("ok")
	 world.EnableTrigger("zone",false)
     _RC.relation=""
	 if zone=="丝绸之路" then
	    zone="星宿海"
	 end
	  if zone=="成都郊外" then
	    zone="成都城"
	 end
	 if zone=="郊外农田" then
	    zone=""
	 end
	 _RC.zone=Trim(zone)
	 --Room.zone=Trim(zone)
	 --print(_RC.zone)
   end,

  Relation=function(relation)
    if _RC.relation==nil then
	   _RC.relation= ""
	end
	--> 无至从西大街走了过来。
    --> 无至往西面的西大街离开。
	 relation = string.gsub(relation, ">", "")
	 relation=Trim(relation)
     local i=string.find(relation,"走了过来。")
	 if i~=nil then
	 --过滤 filter
	    relation=""
	 end
	 local j=string.find(relation,"离开。")
	 if j~=nil then
	 --过滤
	   relation=""
	 end
    --setmetatable(R, {__index = _Room})
	--relation 数据规范化

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
	 ----print(relation)
	 _RC.relation=_RC.relation .. relation --累计变量
	 --Room.relation=R.relation
	 ----print(R.relation)
  end,

  RoomName=function (roomname)
	world.EnableTrigger("relation",false);
	world.EnableTrigger("roomname",false)
    world.EnableTrigger("roomdesc",true);
    world.EnableTrigger("weather",true);
    world.EnableTrigger("roomexits",true);
	world.EnableTrigger("roomexits2",true);
    world.EnableTrigger("roomexits3",true);
	world.EnableTrigger("roomexits4",true);
	world.EnableTrigger("roomexits5",true);
	world.EnableTrigger("roomexits6",true);
	world.EnableTrigger("roomexits7",true);
	roomname = string.gsub(roomname, ">", "")
	roomname=Trim(roomname)
	_RC.roomname=roomname
	--Room.roomname=roomname
	--print(_RC.roomname)
    end,

  Description=function(description)
    if _RC.description==nil then
	   _RC.description=""
	end
    _RC.description=_RC.description .. Trim(description)
	--Room.description=R.description
  end,--累计变量

  Weather=function(weather)
    --print(weather)
    _RC.weather=Trim(weather)
	--Room.weather=R.weather
  end,

  Exits=function(exits)
      world.EnableTriggerGroup("roominfo",false)
	  DeleteTriggerGroup("roominfo")
     local t={}
	 t=Split(exits,"和")
	 local s=""
	 for i,v in ipairs(t) do
	    s=s..Trim(v).."、"
	 end
	 ----print(s)
	 t={}
	 t=Split(s,"、")
	 s=""
	 for i,v in ipairs(t) do
	    if Trim(v)~="" then
	      s=s..Trim(v)..";"
		end
	 end
	 _RC.exits=s
	 --Room.exits=R.exits
	 ----print(s)
  end,   --划分
  Catch=function()
	coroutine.resume(Room.catch_co)
  end,
  catch_co=nil,
}

function Room:get_all_exits(RA)
   local count,roomno=Locate(RA)
   local sql="select distinct direction from MUD_Entrance where ("
   for _,r in ipairs(roomno) do
      sql=sql .. "roomno=" ..r .. " or "
   end
    sql=string.sub(sql,1,-5)
	sql=sql..")"
	--print(sql)
    DatabasePrepare ("sj", sql)
    local dx={}
    local rc = DatabaseStep ("sj")
	  while rc == 100 do
         local values = DatabaseColumnValues ("sj")
		 local direct=values[1]
		 if is_Special_exits(direct)==false then
	       table.insert(dx,direct)
		 end
		 rc = DatabaseStep ("sj")  -- read next row
	  end
	DatabaseFinalize ("sj")
   if table.getn(dx)>0 then
      return dx
   end
   local ex=Split(R.exits,";")
   dx={}
   for _,e in ipairs(ex) do
      if e~="" then
       table.insert(dx,e)
	  end
   end
   return dx
end
--你要看什么？
function Room:look_end(dx)
  -- print(dx)
   world.DoAfterSpecial(0.1,dx,10)
  wait.make(function()
   --world.DoAfterSpecial(0.3,dx,10)

   local l,w=wait.regexp("^(> |)Ok.$|^(> |)你要看什么.*$|^(> |)你觉得有点什么不对劲, 可是你却说不上来.$",3)

   if l==nil then
      self:look_end(dx)
      return
   end
   if string.find(l,"你觉得有点什么不对劲") then
      local f=function()
	     self:Setlook(dx) --方向
	  end
      f_wait(f,0.8)
      return
   end

   if string.find(l,"你要看什么") and dx~=nil then
       --coroutine.resume(Room.catch_co)
	   self:look_end("look;unset action")
	   return
   end

   if string.find(l,"Ok") then
      --Room.catch_co=nil
      return
   end
  end)
end

function Room:Setlook(dx) --方向
   world.EnableTriggerGroup("roominfo",false)
	wait.make(function()
      world.Send("set action look")
--设定环境变量：action = "look"
	  local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"look\\\".*",5)

	  if l==nil then  --异常
	     --print("test")
	     self:Setlook(dx)
         return
	  end
	  if string.find(l,"设定环境变量") then
		 Room.Look() ---触发器打开
		 --print("触发器打开")
		 if dx==nil then
		   self:look_end("look;unset action")
	     else
		   self:look_end("look "..dx..";unset action")
	     end
		 return
	  end
	  wait.time(5)
	end)
end

function Room:CatchStart(dx) --回调函数
  ----print("catch:",dx)
  Room.catch_co=coroutine.create(function()
      _RC={}--初始化
	  --setmetatable(R,{__index=_Room})
	  --print(R.zone)
      CreateTriggerGroup()
	  world.EnableTriggerGroup("roominfo",false)
	  self:Setlook(dx)
	  coroutine.yield() --挂起
	  self.zone=_RC.zone
	  self.roomname=_RC.roomname
	  self.relation=_RC.relation
	  self.description=_RC.description
	  self.exits=_RC.exits
	  self.weather=_RC.weather
	  _RC.zone=""
	  _RC.roomname=""
	  _RC.relation=""
	  _RC.description=""
	  _RC.exits=""
	  _RC.weather=""
	  _RC=nil --clear
	  Room.catch_co=nil
	  --bug 地图处理

	  if self.zone=="峨嵋山" and self.roomname=="土路" then
	     self.zone="成都城"
	  end
	  if self.zone=="大理城北" then
	     self.zone="大理城"
	  end
	  -- bug 地图处理结束
      self:CatchEnd()

  end)
  coroutine.resume(Room.catch_co)
end

function Room:CatchEnd() --回调函数

end
---------------------------------------------------------------------------------------------
function get_roomno()
   local names={}
   DatabasePrepare ("db2", "SELECT RoomNoCount from MUD_RoomNoCount")
   -- find the column names
   rc = DatabaseStep ("db2")
   local values = DatabaseColumnValues ("db2")
   local roomno=values[1]
   ----print(roomno)
   DatabaseFinalize ("db2")
   local sql="update MUD_RoomNoCount set RoomNoCount=RoomNoCount+1"
   DatabaseExec ("db2",sql)
   DatabaseFinalize ("db2")
   --DatabaseExec ("sj",sql)
   --DatabaseFinalize ("sj")
   ----print(roomno)
   return roomno
end

local function DeleteTriggerGroup()
   world.DeleteTriggerGroup("roominfo");
end

local function NewDirection(roomno,direction)
  local sql="insert into MUD_Entrance (roomno,linkroomno,direction) VALUES("..roomno..",-999,'"..direction.."')"
  --print(sql)
  DatabaseExec ("db2",sql)
  DatabaseFinalize ("db2")
   DatabaseExec ("sj",sql)
   DatabaseFinalize ("sj")
end

local function NewRoom(R)
-- put some data into the database
 -- print("test")
  local roomno
  roomno=get_roomno()
  print(roomno)
  --print(_RC.zone,"RC")
  local sql="INSERT INTO MUD_Room (roomno,zone,relation,roomname,description,exits,roomtype) VALUES ("..roomno..",'"..R.zone.."','"..R.relation.."','"..R.roomname.."','"..R.description.."','"..R.exits.."','')"
  --print(sql)
 DatabaseExec ("db2",sql)
  DatabaseFinalize ("db2")
   --DatabaseExec ("sj",sql)
   --DatabaseFinalize ("sj")
  local All_Exits=Split(R.exits,";")
  for i,d in ipairs(All_Exits) do
     if d~="" then
	    print(d)
	    NewDirection(roomno,d)
	 end
  end
  reload_data()
  --import_data()
  return roomno
end

--获得还有未确定出口的房间
local existing_RoomNo={}
local function table_contain(t,roomno)
   for i,r in ipairs(t) do
       if r==roomno then
	     return true
	   end
   end
   return false
end

local function get_nearest_roomno(roomno,deep,near_roomno,max_room)
    local next_roomno={}
    for i,r in ipairs(roomno) do
	  local sql=table.concat({"select linkroomno from MUD_Entrance where roomno=",r.roomno})
	  if r.father~=nil then
	    sql=table.concat({sql," and not linkroomno=" ,r.father})
      end
	  ----print(sql)
	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  local is_add=false  --排除重复加入
       while rc == 100 do
	     local roomno={}
         local values ={}
		 values=DatabaseColumnValues ("sj")
         roomno.roomno=values[1]
		 roomno.father=r.roomno
		 if roomno.roomno==-999 and is_add==false then --需要加入
		    ----print("需要遍历的:",roomno.roomno)
		    table.insert(near_roomno,r.roomno)
			--print("找到需要遍历房间:",r.roomno)
			is_add=true
		 else
		    ----print("下一层:",roomno.roomno)
			if table_contain(existing_RoomNo,roomno.roomno)==false then
			  table.insert(existing_RoomNo,roomno.roomno)--
		      table.insert(next_roomno,roomno)  --链接表
			end
		 end
         rc = DatabaseStep ("sj")  -- read next row
       end -- while loop
       ----print (roomno)
	   -- finished with the statement
	   DatabaseFinalize ("sj")
    end
    --
	----print(table.getn(next_roomno))
	if deep>0 and table.getn(next_roomno)>0 then
       if is_add==true then
	     deep=deep-1
	   end
	  ----print(deep,table.getn(next_roomno),table.getn(near_roomno))
	  if table.getn(near_roomno)<max_room then
	    get_nearest_roomno(next_roomno,deep,near_roomno,max_room)
	  end
	end

end

--更新关系表
local function UpdateLink(roomno,linkroomno,direction)
    --print("更新链接表",linkroomno)
    local sql="update MUD_Entrance set linkroomno="..linkroomno.." where direction='"..direction.."' and roomno=" ..roomno
    DatabaseExec ("db2",sql)
	--DatabaseExec ("sj",sql)
	--import_data()
	reload_data()
end

local function time_define(w)
    ----print("define:",w)
	if w==nil then
	   return nil
	end
	if w=="" then
	   return nil
	end
	if string.find(w,"夜晚") or string.find(w,"深夜") or string.find(w,"夜幕") or string.find(w,"午夜") then

	  return false
	end
    if string.find(w,"凌晨") or string.find(w,"清晨") then
	   --无法判别 还是需要按时间判别
	   return nil
	end
    return true
end

--相对关系定位
function relation_Locate(RA)
   local sql=table.concat({"select distinct roomno,roomtype from MUD_Room where roomname='",RA.roomname,"'"})

   if RA.zone~="" and RA.zone~=nil then
     sql= table.concat({sql," and zone='",RA.zone,"'"})
   end
   -- --print(sql)
   if RA.relation~="" and RA.relation~=nil then
	 sql= table.concat({sql," and relation='",RA.relation ,"'"})
   end
   --print(sql)
    DatabasePrepare ("sj", sql)
   -- execute to get the first row
  -- rc = DatabaseStep ("sj")  -- read first row
   -- now loop, displaying each row, and getting the next one
   local rc = DatabaseStep ("sj")
   local roomno={}
   while rc == 100 do
     local values = DatabaseColumnValues ("sj")
	 --print("可能的房间号:",values[1])
	 table.insert(roomno,values[1])

      rc = DatabaseStep ("sj")  -- read next row
   end -- while loop
   ----print (table.getn(crowd_roomno))
   -- finished with the statement
   DatabaseFinalize ("sj")
   if table.getn(roomno)==0 then  --没有找到合适的房间
      return nil
   end
   --获得有连接房间
   sql="select distinct roomno from MUD_Entrance where "
   for _,r in ipairs(roomno) do
      sql = table.concat({sql,"linkroomno=",r," or "})
   end
   sql=string.sub(sql,1,-5)
   --print(sql)
   DatabasePrepare ("sj", sql)
   local result={}
	rc = DatabaseStep ("sj")
	while rc == 100 do
      local values = DatabaseColumnValues ("sj")
	  --print("room:",values[1])
	  --table.insert(result,values[1]) 老code 写法
	  --新code 写法
	     result[values[1]]=values[1]
	  --
      rc = DatabaseStep ("sj")  -- read next row
    end -- while loop
	DatabaseFinalize ("sj")
   return result
end

--定位
function Locate(RA,locate_type)  --确定是否查询嵌套子房间
      --模糊查询
      --print(RA.zone)
      -- print(RA.relation)
      -- print(RA.roomname)
      -- print(RA.description)
	  -- print(RA.weather)
      -- print(RA.exits)
   --1
    --print("?")
     local sql="select distinct roomno,roomtype from MUD_Room where roomname='"..RA.roomname.."'"
     --print(sql,RA.zone)
   --10
     if (RA.zone~=nil and RA.zone~="") and locate_type~=10 then
       sql= sql.." and zone='"..RA.zone .. "'"
     end
     -- --print(sql)
   --100
     if (RA.relation~=nil and RA.relation~="") and locate_type~=100 then
	   sql= sql.." and (relation='"..RA.relation .."' or relation='any')"
	 end
   -- --print(sql)
   --1000
     if (RA.description~=nil and RA.description~="") and locate_type~=1000 then
	   sql= sql.." and (description='" .. RA.description .."' or description='any')"
     end
    --print(sql)
   --10000

     if (RA.exits~=nil and RA.exits~="") and locate_type~=10000 then
	   sql= sql.." and exits='" .. RA.exits.."'"
     end
   -- prepare a query
   --print(sql)
   DatabasePrepare ("sj", sql)
   -- execute to get the first row
  -- rc = DatabaseStep ("sj")  -- read first row
   -- now loop, displaying each row, and getting the next one
   local rc = DatabaseStep ("sj")
   local roomno={}
   while rc == 100 do
     local values = DatabaseColumnValues ("sj")
	 table.insert(roomno,values[1])

      rc = DatabaseStep ("sj")  -- read next row
   end -- while loop
   ----print (table.getn(crowd_roomno))
   -- finished with the statement
   DatabaseFinalize ("sj")
    local opentime=time_define(RA.weather)
	--print("opentime:",opentime)
   return table.getn(roomno),roomno,opentime
end
---------------------------------创建地图-----------------------
local way=nil
function select_way(index)
   if way~=nil then
     way(index)
	 way=nil
   else
     --print("没有选择项")
   end
end

local select_path={}
local co_select_LinkRoomNo=nil
function select_linkRoomNo(select_id)
   coroutine.resume(co_select_LinkRoomNo,select_id)
end

local function S(index)
   local path=select_path[index]
   local f=function()
       local _R
    --setmetatable(R, {__index = _Room})
     _R=Room.new()
     _R.CatchEnd=function()
     local count,linkroomno=Locate(_R)
	 if count<=1 then
	   if count==0 then --new room
	    linkroomno=NewRoom(_R)
		  UpdateLink(path.roomno,linkroomno,path.dx)
	   end
	   if count==1 then
	      UpdateLink(path.roomno,linkroomno[1],path.dx)
	   end
	   --print("lookhere")
	   LookHere()
	  else
	    print("多个房间符合描述，需要人工判别！")
		for i,r in ipairs(linkroomno) do
		   print("选择sl",i,": 链接房间号=",r)
		end
		co_select_LinkRoomNo=coroutine.create(function(select_id)
		  while true do
		    if select_id<=table.getn(linkroomno) then
	          UpdateLink(path.roomno,linkroomno[select_id],path.dx)
		      --print("lookhere")
	          LookHere()
			  break
			else
			   print("选择错误!请重新选择")
		    end
			select_id=coroutine.yield()
		  end
	   end)
      end
     end
     _R:CatchStart()
   end
   if is_Special_exits(path.dx) then
      local al
	  al=alias.new()
	  al.finish=function()
	    f()
	  end
	  --print(path.dx," 特殊路基")
      al:exec(path.dx)  --调用alias处理程序
   else
      world.Send(path.dx)
	  f()
   end

end

local Target_Rooms={}
local function get_nearest_path(Current_roomno)
  --print(Current_roomno,"current")
  existing_RoomNo={}
  local Start={}
  local h={roomno=Current_roomno,father=nil}
  table.insert(Start,h)
  local near_roomno={}
  get_nearest_roomno(Start,1,near_roomno,10)  --3 层 10条路线
  Target_Rooms={}
  ----print(table.getn(near_roomno),"ok")
  local mp=map.new()
  for i,r in ipairs(near_roomno) do

  	 mp.Search_end=function(Path,room_type)
	   --print("选择P:",i," ",Current_roomno,"->",r," 路径:",Path)
	   table.insert(Target_Rooms,r)
	 end
     mp:Search(Current_roomno,r)
  end
end

local function P(index)
   local r=Target_Rooms[index]
   ----print(path)

   --world.AddTriggerEx ("walkover", "^(> |)设定环境变量：walk \\= \\\"over\\\"$", "LookHere()", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 99);
   --world.Execute(path.."set walk over")
   --lookhere
   local w
   w=walk.new()
   w.walkover=function()
	 LookHere()
   end
   w:go(r)
end

local function select_direction(roomno,directions)
   select_path={}
   for i,d in ipairs(directions) do
       print("选择S:",i," 房间:",roomno," 方向:",d)
	   local path={}
	   path.roomno=roomno
	   path.dx=d
	   table.insert(select_path,path)
   end
end

local function get_directions(roomno)
   local sql=table.concat({"select direction from MUD_Entrance where roomno=",roomno," and linkroomno=-999"})
   DatabasePrepare ("sj", sql)
   local rc = DatabaseStep ("sj")
   local directions={}
   while rc == 100 do
     local values = DatabaseColumnValues ("sj")
     table.insert(directions,values[1])
     rc = DatabaseStep ("sj")  -- read next row
   end -- while loop
   ----print (roomno)
   -- finished with the statement
   DatabaseFinalize ("sj")
   if table.getn(directions)>0 then
      --这个房间有路径没有遍历到
	  select_direction(roomno,directions)
	  way=S
   else
	  --print("选择下个房间")
	  get_nearest_path(roomno)
	  way=P
   end
end

local co_select_currentRoomNo=nil
function Select_currentRoomNo(select_id)
   coroutine.resume(co_select_currentRoomNo,select_id)
end

local NPCs={}
--快捷alias
  world.AddAlias("zr","zr", "CatchNPC_Room()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("zr","send_to", 12) --向脚本发送

function CatchNPC_Id(name,id1,id2,id3)
   local corpse=false
   if string.find(name,"尸体") or string.find(name,"男尸") or string.find(name,"女尸") then
      corpse=true
   end
   if NPCs[name]==nil and corpse==false then
      local npc={}
	  npc.name=name
	  npc.id1=id1
	  npc.id2=id2
	  npc.id3=id3
	  NPCs[name]=npc
   end
end

function CatchNPC(roomno)
   world.Send("id here")
    world.Send("set action 数据采集")
	NPCs={}
   --鹦鹉 = ying wu, parrot, yingwu
   --大理官兵 = dali guanbing, bing
     wait.make(function()
      local l,w=wait.regexp("^(> |)在这个房间中\\, 生物及物品的\\(英文\\)名称如下：$|^(> |)设定环境变量：action \\= \\\"数据采集\\\"",2)
	  if l==nil then
		 world.Send("set action 数据采集")
	     CatchNPC(roomno)
	     return
	  end
	  if string.find(l,"设定环境变量：action") then
	     --print("结束")
		 world.EnableTrigger("catch_id1",false)
		 world.EnableTrigger("catch_id2",false)
		 for index,npc in pairs(NPCs) do
		    local yesno=utils.msgbox ("是否将"..npc.name.."("..npc.id1..") 插入到数据库?", "数据采集", "yesno", "?")
			if yesno=="yes" then
			  local sql="INSERT INTO MUD_Npc (roomno,name,id1,id2,id3) VALUES ("..roomno..",'"..npc.name.."','"..npc.id1.."','"..npc.id2.."','"..npc.id3.."')"
              --print(sql)
              DatabaseExec ("db2",sql)
              DatabaseFinalize ("db2")
			end
		 end
		  world.DeleteTrigger("catch_id1")
		  world.DeleteTrigger("catch_id2")
	     return
	  end
	  --^鹦鹉 \= ying wu\, parrot\, yingwu$
	  if string.find(l,"生物及物品的") then
	     world.AddTriggerEx ("catch_id3", "^(> |)(\\W*) \\= (.*)\\, (.*)\\, (.*)\\, (.*)$", "CatchNPC_Id('%2','%3','%4','%5')", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 997)
	     world.AddTriggerEx ("catch_id2", "^(> |)(\\W*) \\= (.*)\\, (.*)\\, (.*)$", "CatchNPC_Id('%2','%3','%4','%5')", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 998)
	     world.AddTriggerEx ("catch_id1", "^(> |)(\\W*) \\= (.*)\\, (.*)$", "CatchNPC_Id('%2','%3','%4','')", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 999)
		 CatchNPC(roomno)
	     return
	  end
   end)
end

function CatchNPC_Room()
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	 if count==1 then
	    CatchNPC(roomno[1])

	 end
   end
   _R:CatchStart()
end

function LookHere() --原地开始遍历
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
	  --print(_R.zone)
	  --print(_R.roomname)
	  --print(_R.relation)
	  --print(_R.exits)

     local count,roomno=Locate(_R)
     print(count,roomno)
	 if count==0 then --new room
	    --print("new room")
	    roomno[1]=NewRoom(_R)
		-- print("new room2")
	 end
	 if count==1 then
	    get_directions(roomno[1])
		  --Create_Map(roomno[1])  --地图显示
		print("当前房间号lookhere",roomno[1])
	 end
	 if count>1 then
	   print("多个房间符合匹配，人工选择！")
	   for i,r in ipairs(roomno) do
	      print("选择sc",i,": 房间号=",r)
	   end
	   co_select_currentRoomNo=coroutine.create(function(select_id)
	     while true do
		   if select_id<=table.getn(roomno) then
	         get_directions(roomno[select_id])
		     print("当前房间号??",roomno[select_id])
		     break
		   else
		     print("选择错误!")
		   end
		   select_id=coroutine.yield()
		 end
	   end)
	 end
   end
   _R:CatchStart()
end

function WhereAmI(this,locate_type) --原地开始遍历
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
	 ----print("R. hui diao")
     local count,roomno=Locate(_R,locate_type) --排除出口变化情况
     ----print(count,roomno)
	 if count==0 then --new room
	    --print("不存在")
		this(nil)
	 end
	 if count>=1 then
	    local rooms={}
	    for _,c in ipairs(roomno) do
          sql="select roomno from MUD_Crowd where crowd_roomno="..c
	    ----print(sql)
	     DatabasePrepare ("sj", sql)
	     local rc = DatabaseStep ("sj")
	     while rc == 100 do
           local values = DatabaseColumnValues ("sj")
		   ----print(values[1])
	       table.insert(rooms,values[1])
		   rc = DatabaseStep ("sj")  -- read next row
	     end
	     DatabaseFinalize ("sj")
        end -- while loop
        for _,r in ipairs(rooms) do
          --print("房间号:",r)
		  table.insert(roomno,r)
        end
        this(roomno)
	 end
   end
   _R:CatchStart()
end

local function get_link_roomno(roomno)
  local sql
  sql="select roomno from MUD_Room where roomno in (select linkroomno from mud_entrance where "
  for _,r in ipairs(roomno) do
     sql=table.concat({sql,"roomno=",r," or "})
  end
  sql=string.sub(sql,1,-5)..")"
  ----print(sql)
   local linkroomno={}
  DatabasePrepare ("sj", sql)
   local rc = DatabaseStep ("sj")
   while rc == 100 do
     local item={}
     local values = DatabaseColumnValues ("sj")
	 item=values[1]
     table.insert(linkroomno,item)
     rc = DatabaseStep ("sj")  -- read next row
   end -- while loop
  DatabaseFinalize ("sj")
  ----print("链接:",linkroomno[1])
  return nearest_room(linkroomno)
end

function nearest_room(roomno)
  local gender=world.GetVariable("gender") or "男性"
  local _ok=""
  if gender=="男性" then
      _ok="not roomtype='limit_male' and"
  elseif gender=="无性" then
     _ok="not roomtype='limit_neutral' and "
  elseif gender=="女性" then
     _ok="not roomtype='limit_female' and "
  end
  local sql
  sql="select roomno from MUD_Room where ".._ok.." not (roomtype='D' or roomtype='S' or roomtype='V') and roomno in (select linkroomno from mud_entrance where "
  for _,r in ipairs(roomno) do
     sql=sql.."roomno="..r .." or "
  end

  sql=string.sub(sql,1,-5)..")"
  ----print(sql)
  local linkroomno={}
  DatabasePrepare ("sj", sql)
   local rc = DatabaseStep ("sj")
   while rc == 100 do
     local item={}
     local values = DatabaseColumnValues ("sj")
	 item=values[1]
     table.insert(linkroomno,item)
     rc = DatabaseStep ("sj")  -- read next row
   end -- while loop
  DatabaseFinalize ("sj")
  --print(linkroomno[1])
  if linkroomno[1]==nil then
     return get_link_roomno(roomno)
  end
  return linkroomno[1]
end



--2011-7-7遍历  多分支结构 是特殊出口就新建一个分支结构
local leaf={}
local function exist_leaf(r)
  for _,n in ipairs(leaf) do
     if n==r then
	    return true
	 end
  end
  return false
end

function branch(roomno,depth) --搜索使用
  -- --print("房间号:",roomno," 层:",depth)
  -- 区分性别
  local gender=world.GetVariable("gender") or "男性"
  local fliter_sql=""
  if gender=="男性" then
      fliter_sql="roomtype='limit_male' or roomtype='V' or roomtype='G'"
  elseif gender=="无性" then
     fliter_sql="roomtype='limit_neutral' or roomtype='V' or roomtype='G'"
  elseif gender=="女性" then
     fliter_sql="roomtype='limit_female' or roomtype='V' or roomtype='G'"
  end
  local sql
  sql="select roomno from MUD_Room where "..fliter_sql
  local exesql
  exesql="SELECT MUD_Entrance.linkroomno,MUD_Entrance.direction,MUD_Entrance.weight from MUD_Entrance where not (linkroomno=-999 or linkroomno=-1 or linkroomno=0) and not linkroomno in ("..sql..") and roomno=" .. roomno
	 DatabasePrepare ("sj", exesql)
     local rc = DatabaseStep ("sj")
	 local special_list={}
	 local normal_list={}
	 local special_detail={}
     while rc == 100 do
       local item={}
       local values = DatabaseColumnValues ("sj")
	   item.linkroomno=values[1]
	   item.direction=values[2]
	   item.weight=values[3]
	   item.depth=depth

	   if exist_leaf(item.linkroomno)==false then
	    -- --print("不存在")
		  table.insert(leaf,item.linkroomno)
	     if is_Special_exits(item.direction)==true then
	         --特殊出口
			 ----print("特殊出口")
			 table.insert(special_list,item.linkroomno) --不处理
			 table.insert(special_detail,item)
	     else
			 ----print("正常出口")
	         table.insert(normal_list,item.linkroomno) --正常出口
	     end
		  ----print(item.linkroomno," ",item.direction," ",item.depth)
       end
       rc = DatabaseStep ("sj")  -- read next row
     end -- while loop
     DatabaseFinalize ("sj")
     --
	 if depth>0 then
	    depth=depth-1
		local n,s,d=leaf_search(normal_list,depth)
		for _,i in ipairs(n) do
		   table.insert(normal_list,i)
		end
		for _,j in ipairs(s) do
		   table.insert(special_list,j)
		end
		for _,k in ipairs(d) do
           table.insert(special_detail,k)
        end
	 end
	  return normal_list,special_list,special_detail  --最底层
end

function leaf_search(roots,depth)

    local normal_list={}
	local special_list={}
	local special_detail={}
	for _,r in ipairs(roots) do  --多个起点 分解
      -- --print(r,"节点下")
       local n,s,d=branch(r,depth)

	   for _,r in ipairs(n) do
	      table.insert(normal_list,r)
	   end
	   for _,r in ipairs(s) do
	      table.insert(special_list,r)
	   end
	   for _,r in ipairs(d) do
	      table.insert(special_detail,r)
	   end
	end
    return normal_list,special_list,special_detail
end

function depth_search(start_roomno,depth)
  leaf={}
  for _,root in ipairs(start_roomno) do
     table.insert(leaf,root)
  end
  local n,s,d=leaf_search(start_roomno,depth)
  --第一层

  --第二层
  ----print("小分支")
  for _,i in ipairs(d) do
    ----print("****************************")
	----print("特殊点加入 ",i.linkroomno)
    table.insert(n,i.linkroomno)
    if i.depth-i.weight>0 then

       local n1,s1,d1=branch(i.linkroomno,i.depth)

	    for _,r in ipairs(n1) do
		   ----print(r," ->branch2")
	      table.insert(n,r)
	   end
	   for _,r in ipairs(s1) do
	      -- --print(r," ->branch2_special")
	      table.insert(s,r)
	   end
	   for _,r in ipairs(d1) do
	       ----print(r," ->branch2_special_detail")
	      table.insert(d,r)
	   end
    end
   end

  for g,root in ipairs(start_roomno) do
     table.insert(n,g,root)
  end
  --for index,test in ipairs(n) do
   -- print(index,".房间号:",test)
  --end
  return n
end

--根节点 1
--分支数 5
--叶子  分支 1  4
--叶子 回滚上层 没有分支 继续回滚
local node={
  new=function()
     local nd={}
	 setmetatable(nd,{__index=node})
	 return nd
  end,
  depth=0,
  branchs_count=0,
  arrow=0,
  branchs={},
  roomno=0,

}
local search_r={}  --已搜索房间
local reverse_stack={} --返回房间
local function depth_path_exist(roomno)
    for _,r in ipairs(search_r) do
	    if r==roomno then
	       return true
	    end
    end
    return false
end

local function depth_path_back(roomno) --倒退到分支点
   for _,b in ipairs(reverse_stack) do
      if b.roomno==roomno then
         return b
	  end
   end
   return nil
end

function depth_path_loop(n,omit,opentime)

    local dx
	local roomno
	local roomtype
	local roomkey=""
	local rooms={}
	--print("arrow:",n.arrow)
	--print("branchs_count:",n.branchs_count)
	if n.depth>0 and n.arrow<=n.branchs_count then  --多分支
	    if n.branchs_count>=2 and depth_path_back(n.roomno)==nil then
		   --print("加入分支点！！！！")
           table.insert(reverse_stack,1,n)  --分支点加入
		end
		 --选择分支
		 local i=n.arrow
		 roomno=n.branchs[i].linkroomno
		 roomkey=roomno --相同
		 dx=n.branchs[i].direction
		 n.arrow=n.arrow+1
		 --print(" >>>>>>>>>>>>>>>>>>>>>>",dx)
		 --if dx==omit then --忽略
		 --   roomno,dx,roomkey=depth_path_loop(n,omit,opentime)
		 --end
	else --返回上层
	    --返回路径
		--print("返回分支点！")
		local m=reverse_stack[1]
		if m.arrow>m.branchs_count then
			--print("删除分支:"..m.roomno)
			--print("arrow:",m.arrow)
			--print("branchs_count:",m.branchs_count)
			table.remove(reverse_stack,1) --移除
		end
		--print("房间号:",m.roomno)
        roomno=m.roomno
		--print(n.roomno,"->",m.roomno)
        dx,roomtype,rooms=Search(n.roomno,m.roomno,opentime)
		--print(dx)
		for _,r in ipairs(rooms) do
		   --print("Room:",r)
		   if r~=n.roomno then
		     roomkey=roomkey..r..";"
		   end
		end
		roomkey=string.sub(roomkey,1,-2)
		dx=string.sub(dx,1,-2)
		--print("?",dx)
	end
	--print(n.roomno,"->",roomno)
	--print("方向:",dx)
    return roomno,dx,roomkey
end

function depth_path_search(root,depth,omit,opentime)
   --print("root",depth)
    search_r={}
	reverse_stack={}
	local n={}
    local path=""
	local rooms=""
	local next_roomno
	local step=""
	local step_room=""
	--
	--local c={}

	local n={}
	local br={}
	table.insert(search_r,-1)
	local convert=depth_path_crowd()
	for _,r in ipairs(root) do --多根节点
	  --print(r,"r?")
	  --r=convert(r)
	  table.insert(search_r,r) --根节点加入
	  n=depth_path_branch(r,depth,omit,opentime)
	  --print(n.branchs_count)
	  for g,br in ipairs(n.branchs) do
	      --print(br.linkroomno)
	       --br.linkroomno=convert(br.linkroomno)
		  --print(br.direction)
		   if br.direction=="shanjiao_shanlu" and wdj.wdj2_ok==false then
		      br.linkroomno=-1 --五毒教遍历 不能进入五毒教
		   end
		    if br.linkroomno==-1 then
		      table.remove(n.branchs,g)
			  n.branchs_count=n.branchs_count-1 --删除
		   end
	  end
      table.insert(reverse_stack,n)-- 根节点加入
	  --table.insert(c)
	  --rooms=r
	end
    n=reverse_stack[1]  --首节点
	--print(n,"??")
	--print(root[1],"测试！！")
	next_roomno,path=depth_path_loop(n,omit,opentime)
	--print("首房间号",next_roomno)
	rooms=root[1]..";"..next_roomno --首房间号
	local m={}
    while table.getn(reverse_stack)>0  do  --当前节点
	  --print("roomno:",next_roomno)
	  --print("path:",path)
	  m={}
	  m=depth_path_back(next_roomno)
	  --print("m:",m)
	  --返回上一次

	  if m==nil then  --没有分支
	     --print("获取新的分支")
		-- print(next_roomno)
		 --print(next_roomno)
	     m=depth_path_branch(next_roomno,n.depth-1,omit,opentime)
	  end
	  n=m --赋值
	  n.roomno=convert(n.roomno)
      next_roomno,step,step_room=depth_path_loop(n,omit,opentime)
	  --if past_roomno~="" then

	  --  step_room=past_roomno..";"..step_room
	--	print("结果",step_room)
	 -- end
	  --print(step)
	  --print("返回")
	  for g,br in ipairs(n.branchs) do
	       -- br.linkroomno=convert(br.linkroomno)
		   --print(br.direction,">>>>>>>>")
			--if br.direction==omit then
			--  print("删除")
		    --  br.linkroomno=-1
		   --end
		   if br.direction=="shanjiao_shanlu" and wdj.wdj2_ok==false then
		      br.linkroomno=-1 --五毒教遍历 不能进入五毒教
		   end

		    if br.linkroomno==-1 then
		      table.remove(n.branchs,g)
			  n.branchs_count=n.branchs_count-1 --删除
		   end
	  end
      local convert_roomno=convert(tonumber(step_room))
	  if convert_roomno==nil then
	      convert_roomno=step_room
	  end
	  rooms=rooms..";"..convert_roomno
	  --print(rooms)
	  --print("????",step_room,"->",convert(tonumber(step_room)))
	  path=path..";"..step
	  --print(path)
    end
	--print(path)
	--print(rooms)
	return path,rooms
end

function depth_path_crowd() --房间号转换
   --把flag =1 表示不需要经过的 虚拟的房间
     local exesql
     exesql="SELECT roomno,crowd_roomno from MUD_Crowd where flag=1"
	-- print(exesql)
	 DatabasePrepare ("sj", exesql)
     local rc = DatabaseStep ("sj")
     local crowd={}
    -- print(rc,"rc")
     while rc == 100 do
	   local values = DatabaseColumnValues ("sj")
	   local seq=values[1]
	   local roomno=values[2]
	   --print(seq," ?> ",roomno)
	   --if crowd[seq]==nil then
	      crowd[seq]=roomno
	      rc = DatabaseStep ("sj")  -- read next row
     end -- while loop
	 --print("关闭数据库")
     DatabaseFinalize ("sj")
    return function(g_roomno)

	   if crowd[g_roomno]==nil then
	       --print(g_roomno," fan hui1 ", g_roomno)
	       return g_roomno
	   else
	    --print(g_roomno," fan hui ", crowd[g_roomno])
          return crowd[g_roomno]
	   end
    end
end

function depth_path_branch(roomno,depth,omit,opentime)
  --print("房间号:",roomno," 层:",depth)
  -- 区分性别
  local convert=depth_path_crowd()
  local gender=world.GetVariable("gender") or "男性"
  local fliter_sql=""
  if gender=="男性" then
      fliter_sql="roomtype='limit_male' or roomtype='G'"
  elseif gender=="无性" then
     fliter_sql="roomtype='limit_neutral' or roomtype='G'"
  elseif gender=="女性" then
     fliter_sql="roomtype='limit_female' or roomtype='G'"
  end
  local sql
  sql="select roomno from MUD_Room where "..fliter_sql
  local exesql
  exesql="SELECT distinct MUD_Entrance.linkroomno,MUD_Entrance.direction,MUD_Room.RoomType from MUD_Entrance,MUD_Room where MUD_Entrance.linkroomno=MUD_Room.roomno and not (linkroomno=-999 or linkroomno=0 or linkroomno=-1) and not linkroomno in ("..sql..") and MUD_Entrance.roomno=" .. roomno.." order by MUD_Room.RoomType"
  --print(exesql)
	DatabasePrepare ("sj", exesql)
     local rc = DatabaseStep ("sj")
     local BStack={} --子节点
	 local BDepth=depth --深度
     while rc == 100 do
       local item={}
       local values = DatabaseColumnValues ("sj")
	   item.linkroomno=values[1]
	   item.direction=values[2]
	   --路径转换 福州城西门
       if item.linkroomno==2260 or item.linkroomno==2290 then
			 if opentime==nil or opentime==true then  --默认是白天
			     --通的
				   if tonumber(roomno)==1304 then
			          item.linkroomno=1305
				   end
			       if tonumber(roomno)==1305 then
					  item.linkroomno=1304
			       end
				   if tonumber(roomno)==1257 then
			          item.linkroomno=1258
			       end
			       if tonumber(roomno)==1258 then
			          item.linkroomno=1257
			       end
			 else
			     item.linkroomno=-1 --不通
			 end
	   end
	   --print(item.linkroomno,"前")
	   item.linkroomno=convert(item.linkroomno)
	   --print(item.linkroomno,"后")
	   if depth_path_exist(item.linkroomno)==false then--判定是否加入了
	       --[[print("-——————检验——————————")
		   print(roomno,":roomno")
	       print(item.linkroomno,":linkroomno")
	       print(item.direction,":direction")
		   print(depth)
	       print("————————————————————")]]
	      table.insert(search_r,item.linkroomno)  --加入已搜索房间
		  local dx=Split(omit,"|")
		  local directions={}  --忽略方向
		  for _,index in ipairs(dx) do
		     directions[index]=index  --加入过滤的方向
		  end
		  --加入 迷宫范围判断 2014.08.07
		  local range=1
		  if is_Special_exits(item.direction) then  --特殊房间返回特殊房间的range 默认是1
		      range=alias:get_range(item.direction)
--and depth-range>=0
             --print(depth," ? ",range,"  ",depth-range)
		  end
		  -- 2014.08.07 end
		  local linkroomno="R"..item.linkroomno --index
		  if directions[item.direction]==nil and depth-range>=0 and directions[linkroomno]==nil then
	        table.insert(BStack,item)
		  end

	   end
       rc = DatabaseStep ("sj")  -- read next row
     end -- while loop
	 --print("关闭数据库")
     DatabaseFinalize ("sj")
	 local BCount=table.getn(BStack)
	 local BArrow=1 --箭头指向
     --
	 local _nd=node.new()
	 _nd.depth=BDepth  --深度
	 _nd.arrow=BArrow  --箭头
	 _nd.branchs_count=BCount  --分支数
	 _nd.branchs=BStack --分支
	 _nd.roomno=roomno
	 return _nd
end

--路径遍历类
traversal={
   new=function()
    local tr={}
	setmetatable(tr, traversal)
    return tr
  end,
  output_path=nil,
  user_alias=nil,
  step_count=0,--计步器
  startroomno=nil,
  version=1.8,
}
traversal.__index = traversal

function traversal:step_over(roomno)
  local f=function()
     coroutine.resume(traversal.output_path) --恢复进程
  end
  f_wait(f,0.3)
end

function traversal:step_end()
    --搜索结束

end

function traversal:noway()  --无法进入的事件
end

function traversal:Special(Special_Macro,roomno) --特殊方向
	--print("Special_Macro:",roomno," ",Special_Macro)

    local al
	if self.user_alias==nil then
	  --print("创建")
	  al=alias.new()
	else
	  --print("自定义")
	  al=self.user_alias
	end
	al.finish=function()
	   self.step_over(tonumber(roomno))
	end
	al.redo=function()
	    --print("al")
		--self.user_alias=al
		--print(self.target)
	    local targetRoomNo=tonumber(roomno)
		--创建新的alias
		local w
		w=walk.new()
		w.walkover=function()
		   print("执行下一步遍历！！")
		   al:finish()
		end
		w:go(targetRoomNo)
	end
    al:exec(Special_Macro)  --调用默认的alias处理程序
end

function traversal:step(alias_path,rooms) --单步发送
   traversal.output_path={}
   traversal.output_path=coroutine.create(function ()
	  local p=Split(alias_path,";")
      local r=Split(rooms,";")
	  for count,dx in ipairs(p) do
          self.step_count=count
		  local roomno=r[count]
		  if is_Special_exits(dx) then
			  self:Special(dx,roomno)  --路径
		  else
		      world.Send(dx)

			  self.step_over(tonumber(roomno)) --执行下一步
		  end
		  coroutine.yield() --挂起
	  end
	  self:step_end()
  end)
  --coroutine.resume(self.output_path,alias_path)
end

function traversal:fast_walk(alias_path,rooms)  --连续发送

      local p=Split(alias_path,";")

	  local r=Split(rooms,";")
	  --print(table.getn(p) ,"? ",table.getn(r))
      local step_num=0
	  local exec={}
	  local rooms=""
	  local paths=""
	  --local past_rooms={}

	  local start_roomno=r[1]
	   self.startroomno=tonumber(r[1])

	  for index,dx in ipairs(p) do
          --self.step_count=count 10个命令发送

		  if is_Special_exits(dx) then
		      if paths~="" then
			     paths=string.sub(paths,1,-2)
                 --rooms=string.sub(rooms,1,-2)
				 local item={}
				 item.alias_paths=paths
				 item.alias_rooms=rooms
				 item.startroomno=tonumber(start_roomno)  --开始房间号
				 item.endroomno=tonumber(r[index])  --结束房间号
				 start_roomno=r[index]
				 --item.rooms=past_rooms  --经过的房间
				 table.insert(exec,item)  --插入数组
				 --past_rooms={}  --清空
			  end
		      step_num=0
			  local item={}
			  item.alias_paths=dx
			  item.alias_rooms=tonumber(r[index+1])
			  item.startroomno=tonumber(start_roomno)  --开始房间号
			  item.endroomno=tonumber(r[index+1])  --结束房间号
			  start_roomno=r[index+1]
			  --table.insert(past_rooms,r[index+1])
			  --item.rooms=past_rooms
			  table.insert(exec,item)  --路径
			  --past_rooms={} --清空
			  paths=""
			  rooms =""
		  else
			  if step_num>=10 then  --超过10个进堆栈
			     step_num=0
				  local item={}
			      item.alias_paths=paths..dx
				  rooms=rooms..tonumber(r[index])
                  item.startroomno=tonumber(start_roomno)  --开始房间号
				  --print("why",item.startroomno)
				  item.endroomno=tonumber(r[index+1])  --结束房间号
				  start_roomno=r[index+1]
				  --table.insert(past_rooms,r[index+1])
				  --item.rooms=past_rooms
				  item.alias_rooms=rooms..";"..tonumber(r[index+1])
			      table.insert(exec,item)  --路径
				  paths=""
				  rooms =""
				  --past_rooms={}  --清空
			  else
				  --table.insert(past_rooms,r[index+1])
			      step_num=step_num+1
				  paths=paths..dx..";"
				  --print(r[index]," ",dx," rest")
				  if r[index]=="" then
				   self:noway()
				   return {}
				  else
				   if r[index]~=nil then
				     rooms =rooms..tonumber(r[index])..";"
				   end
				  end
			  end

		  end

	  end
	 if paths~="" then
		paths=string.sub(paths,1,-2)
		local item={}
		item.alias_paths=paths

		local i=table.getn(r)
		item.startroomno=tonumber(start_roomno)  --开始房间号
		item.endroomno=tonumber(r[i])
		item.alias_rooms=rooms..r[i]
		--print("结束房间号",item.endroomno)
		--item.rooms=past_rooms
		--past_rooms={}  --清空
		table.insert(exec,item)  --路径
	 end


	 return exec

end

function traversal:exec(item)
	if is_Special_exits(item.alias_paths)  then
		--self.rooms=item.rooms
		self:Special(item.alias_paths,item.endroomno)  --路径
	else
		world.Execute(item.alias_paths..";set action 结束")
		--self.rooms=item.rooms
		wait.make(function()
		   local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"结束\\\"$",5)
		   if l==nil then
		      self:exec(item)
		      return
		   end
		   if string.find(l,"设定环境变量：action") then
		      self.step_over(tonumber(item.endroomno)) --执行下一步
		      return
		   end
		end)
	end
end

---------
function Copy(source_roomno) --拷贝房间
--print("数据库导入内存！")
	world.DatabaseOpen ("db", database_path, 2) --只读数据库
	world.DatabaseOpen ("db2", database_path, 6) --只读数据库
   DatabasePrepare ("db", "SELECT RoomNoCount from MUD_RoomNoCount")
   -- find the column names
   rc = DatabaseStep ("db")
   local values = DatabaseColumnValues ("db")
   local roomno=values[1]
   DatabaseFinalize ("db")
   local sql="update MUD_RoomNoCount set RoomNoCount=RoomNoCount+1"
   DatabaseExec ("db",sql)
   DatabaseFinalize ("db")
   sql="insert into mud_room (roomno,zone,relation,roomname,description,exits,roomtype) select "..roomno..",zone,relation,roomname,description,exits,roomtype from mud_room where roomno="..source_roomno
   ----print(sql)
   DatabaseExec ("db2",sql)
   DatabaseFinalize ("db2")
   sql="select direction from MUD_Entrance where roomno=" ..source_roomno
   DatabasePrepare ("db", sql)
   -- execute to get the first row
  -- rc = DatabaseStep ("db")  -- read first row
   -- now loop, displaying each row, and getting the next one
   rc = DatabaseStep ("db")
   local dx={}
   while rc == 100 do
     local values = DatabaseColumnValues ("db")
     table.insert(dx,values[1])
     rc = DatabaseStep ("db")  -- read next row
   end -- while loop
   ----print (roomno)
   -- finished with the statement
   DatabaseFinalize ("db")
   --插入空方向
   --print(table.getn(dx))
   for _,d in ipairs(dx) do
      --print(d)
      sql="insert into MUD_Entrance (roomno,linkroomno,direction) values("..roomno..",-999,'"..d.."')"
	  --print(sql)
	  DatabaseExec ("db2",sql)
   end
   DatabaseFinalize ("db2")
   --return roomno
end
--------------------行走--------------

walk={
  target=nil,
  id="",
  new=function()
    local w={}
	--setmetatable(w, {__index = walk})
	setmetatable(w, walk)
	w.id=string.sub(CreateGUID(),25,30)
	w.output_path={}
    return w
  end,
  Max_Step=15,
  user_delay=0,
  output_path= nil,
  delay=0.1,
  sys_delay=0.1,
  locateCount=0,
  user_alias=nil,
  opentime=true,
  --tracking=nil,
  start_time=os.clock(),
  step_count=0,
  start_roomno=0,
  ado=false,--ado 行走方式 开关 有些书剑不支持 请设置为 false
  current_roomno=0,--指定起始房间号，不再需要定位减少冗余
  walkoff_time=nil,
  version=1.8,
}
walk.__index=walk

function walk:walkoff()
  --设置延迟
  local f=function()
    world.Send("yun refresh")
	self.walkoff_time=os.time()
    coroutine.resume(self.output_path)
  end
  --local t1=os.time()
   --local interval=t1-self.walkoff_time
   --print(interval,":豪秒","时间间隔    ",t1,"       ",self.walkoff_time)
 --  if interval==0 then
  --    f_wait(f,self.delay)
--	  self.delay=self.delay+0.4
 -- else
   --   self.delay=0.1
      f_wait(f,0.3)
  --end
  --

  --self.delay=self.delay+0.3
end

function walk:noway()
  print("默认noway函数")
  local f=function()
     self:go(self.target)
  end
  f_wait(f,0.8)
end

function walk:walkover()  --接口函数
  ----print("nil")
end

local function delay_setting(sec,step)
   ----print(sec," 秒")
   ----print(step," 步数")
   if step==0 then
     return 0
   end
   local sys_delay=(0.08-(sec/step))*step
   if sys_delay<0 then
    sys_delay=0
   end
   if sys_delay>0.8 then
    sys_delay=0.8
   end
	return sys_delay
end

function walk:wait_waitoff(checkMode)
    if checkMode==true then  --核对模式
 	 wait.make(function()
	--> 设定环境变量：walk = "off"
	   local l,w=wait.regexp("^(> |)设定环境变量：walk \\= \\\"'"..self.id.."'\\\"$|^> > .*$",10)
		if l==nil then
		   --print("2s walkoff 超时 直接输出下一步")
		   --world.Send("set walk off")
           --self:wait_waitoff()
		   self:walkoff()
		   return
		end
		if string.find(l,"设定环境变量：walk") then
		----print("walk off step")
		  local sec=os.clock()-self.start_time
		  self.start_time=os.clock()
		  self.sys_delay=delay_setting(sec,self.step_count)
		  --print(self.sys_delay)
		   self:walkoff()
		   return
		end
		if string.find(l,"> >") then
		   --print("服务器反馈出错!!!1")
		   self:walkoff()
		   return
		end
	end)
   else
      local sec=os.clock()-self.start_time
	  self.start_time=os.clock()
	  self.sys_delay=delay_setting(sec,self.step_count)
	  --print(self.sys_delay)
	  self:walkoff()
   end
end

function walk:step()
   self.output_path={}
   self.output_path=coroutine.create(function (path,roomtype)
      ----print("path: ",path)
      ----print("创建进程:",coroutine.status(self.output_path))
	  local p=Split(path,";")
	  local r=Split(roomtype,";")
      local count=0
      local tmp_P=""
      local result={}

	  ----print("数目",table.getn(p))
	  local step_count={}
	  local left_count=table.getn(p)-1
	  for i,v in ipairs(p) do

		local exe_path={}
	    if v~="" then
		  ----print(v)
	      count=count+1
		  if is_Special_exits(v) then
			 if tmp_P~="" then
			    --print(count-1,"count")
				--print(tmp_P)
			     table.insert(step_count,count-1)
				 left_count=left_count-count+1
			    exe_path.path=tmp_P
				exe_path.count=count
				exe_path.is_Special=false
			    table.insert(result,exe_path)
			 end
			 left_count=left_count-1
			 table.insert(step_count,1)
			 tmp_P=""
			 count=0
			 exe_path={}
			  exe_path.path=v
			  exe_path.is_Special=true
			  table.insert(result,exe_path)
		  else
		     if count>self.Max_Step and r[i+1]~="D" then --危险房间不停顿 AUTO kill NPC
	           table.insert(step_count,count)
			   left_count=left_count-count
			   --print(count,"count")

			   if self.ado==true then
		         tmp_P=tmp_P..v.."|"
			   else
			      tmp_P=tmp_P..v..";"
				end
			   --tmp_P=tmp_P..v..";"
			   count=0
		       --print(tmp_P)
		       exe_path.path=tmp_P
			   exe_path.count=count
			   exe_path.is_Special=false
			   table.insert(result,exe_path)
		       tmp_P=""
	         else
			   if self.ado==true then
		         tmp_P=tmp_P..v.."|"
			   else
			      tmp_P=tmp_P..v..";"
				end
		       ----print(tmp_P)
	         end
		  end
	   end
	  end
	  --print(tmp_P)
	  --print("left_count:",left_count)
	  table.insert(step_count,left_count)
	  ----print("end")
	  if tmp_P~="" then
	    local exe_path={}
	    exe_path.path=tmp_P
		exe_path.is_Special=false
		table.insert(result,exe_path)
	  end
	  ----print("result",table.getn(result))
      --print("step_count",table.getn(step_count))
	  -------------输出路径--------------
	 for i,p in ipairs(result) do

	    local result_path=""
		if p.is_Special==false then
		  ----print("步进数:",step_count[i])
          --[[for j=1,step_count[i] do
		    --地图更新
		    if self.tracking~=nil then
			   self.tracking()
	        end
		  end]]
		  result_path=p.path .."set walk '"..self.id.."'"
		  --[[if self.user_delay~=0 then
			self.delay=self.user_delay
		  else
		    self.delay=self.sys_delay
		  end]]

		  self.step_count=step_count[i]
		  --计时器设置
          self.start_time=os.clock()
		  --
		  if self.ado==true then
		    world.Send("ado "..result_path)
		  else
			 world.Send("alias goalias "..result_path)
          end
		  local alias=function()
		    world.Send("goalias")
		    self:wait_waitoff()
		  end
		  f_wait(alias,0.2)
		else
		  --print("特殊路径")
          if self.user_delay~=0 then
			self.delay=self.user_delay
		  else
		    self.delay=0.3 --特殊路径的延迟
		  end
		  self:Special(p.path)  --路径
		end
		--if i<table.getn(result) then  --最后一个不需要挂起
		  ----print("挂起")
		  coroutine.yield() --挂起
		--end
	 end
	  self.output_path= nil
	  self.user_alias=nil
	  self.target=nil
	  alias.circle_co=nil --迷宫函数清除
	  self:walkover()
  end)
end

function walk:Special(Special_Macro) --特殊方向
	--print(Special_Macro,"sp")

    local al

	if self.user_alias==nil then
	  print("创建")
	  al=alias.new()
	else
	  --print("自定义")
	  al=self.user_alias
	end
	--print("alias id:",al.id)
	al.finish=function()
	   --print("walk off 测试")
	   --print("alias id:",al.id)
	   --print("walk id",self.id)
	   self:walkoff()
	end
	al.redo=function()
	    --print("al")
		--self.user_alias=al
		--print(self.target)
	    local targetRoomNo=self.target
     	self:go(targetRoomNo)
	end

    al:exec(Special_Macro)  --调用默认的alias处理程序
end

local function intersection(sec_room,first_room) --交集
    local result={}
	if sec_room==nil then
	   return first_room
	end
	if sec_room==nil then
	   return nil
	end
    for _,r in ipairs(first_room) do
		--[[for _,t in ipairs(r2) do
		    if r==t then
			  table.insert(result,r)
			  break
			end
		end]]
		 if sec_room[r]~=nil then
			  table.insert(result,r)
		 end
	end
	return result
end

function walk:random_exits(r)
   --判断安全出口
   --print("随机移动一次")
   ----print(r,table.getn(r))
   for _,i in ipairs(r) do
       --print("可能的房间号 roomno:",i)
   end
  local sql
  sql="SELECT direction,count(*) as c from MUD_Entrance where not (linkroomno=0 or linkroomno=-999 or linkroomno=-1) and ("
  for _,i in ipairs(r) do
     sql=sql.."roomno="..i .." or "
  end
  sql=string.sub(sql,1,-5)..")"
  sql=sql .." group by direction order by c desc"
  ----print(sql)
  local randomexits={}
  DatabasePrepare ("sj", sql)
   local rc = DatabaseStep ("sj")
   while rc == 100 do
     local item={}
     local values = DatabaseColumnValues ("sj")
	 item.direction=values[1]
	 item.c=values[2]
     table.insert(randomexits,item)
     rc = DatabaseStep ("sj")  -- read next row
   end -- while loop
  DatabaseFinalize ("sj")
  for _,i in ipairs(randomexits) do
     --print(i.direction," ",i.c)
  end
  return randomexits
end

local function special_look(R,dir)  --特殊
   if R.roomname=="云杉林" then
      local dx={"south","east"}
      return dx
    elseif R.roomname=="小沙丘" then
      local dx={"west","east"}
      return dx
   else
      return dir
   end
end

function walk:relation_rooms(rooms,target,R)
--求房间交集 来确定所在位置
  --print("relation",target)
   local r=rooms
--获得当前房间出口
   local exits=Split(R.exits,";")
   	exits=special_look(R,exits) --判别是否是特殊房间 有确切定位方向
   --print("exits:",R.exits)
   for _,e in ipairs(exits) do
     if e~="" then
       print("出口方向:",e)
	 end
   end
   local loop=function()
     local index=1
     return function()
		--print("e:",exits[index])
		local ex=exits[index]

		index=index+1
        return ex
	 end
   end
   local dx=loop()
   local _R={}
    _R=Room.new()
    _R.CatchEnd=function()
	  --print(_R.roomname)
	  --print(_R.description)
      local _r=relation_Locate(_R)
	  r=intersection(_r,r)
	  --print("test2:",table.getn(r))
	  if table.getn(r)==1 then
		print("找到唯一性,房间号",r[1])
		self.start_roomno=r[1]
		local path=""
		local room_type=""
		local mp=map.new()
		 mp.Search_end=function(path,room_type)

		  if (string.find(path,"noway;") or path=="") and target~=r[1] then
		     --print("触发noway 事件")
		     self:noway()
			 return
  		  end
		  self:step()
		  coroutine.resume(self.output_path,path,room_type)
		 end
		 mp:Zone_Search(r[1],target,self.opentime)
	     --mp:Search(r[1],target,self.opentime) --点对点搜索 速度太慢
      else
	     print("没有唯一")
	     local d=dx()
		 if d~=nil and d~="" then
		   --print("look 方向:",d)
	       _R:CatchStart(d)
		 else
		    --print("没有找到合适房间号,随机移动一步确定位置!!!!")
			local dx_ok=self:random_exits(rooms)
			--print("移动方向->",dx_ok[1].direction)
			world.Send(dx_ok[1].direction) --最大计数方向
			self:go(target)
		 end
	  end
    end
    _R:CatchStart(dx())
end

function walk:locate_fail_deal(target)  --默认定位失败处理函数
       local _R
          _R=Room.new()
          _R.CatchEnd=function()
		    print("房间名:",_R.roomname)
			local error_alias=alias.new()
            if _R.roomname=="九宫桃花阵" then
			  --print("定位失败！ 桃花阵中！")
			  error_alias.finish=function()
			   print("出桃花瘴")
			   print("目标房间号:",target)
			   self:go(target)
			 end
		     error_alias:reset_taohuazhen()
			elseif _R.roomname=="小帆船" then
			  world.Send("order 开船")
			  error_alias.finish=function()
			    local f=function()
			      self:go(target)
			    end
                f_wait(f,0.1)
			  end
			  error_alias:order_chuan()
			elseif _R.roomname=="长江渡船" or _R.roomname=="渡船" or _R.roomname=="黄河渡船" or _R.roomname=="小舟" or _R.roomname=="海船" or _R.roomname=="竹篓" then
               world.Send("out")
			   local f=function()
			     self:go(target)
               end
			   f_wait(f,1.2)
			elseif _R.roomname=="小岛" or _R.roomname=="沙滩" then
			   local seed=math.random(4)
			    --print("范围:",4," 随机出口",seed)
				if seed==1 then
				   dx="east"
				elseif seed==2 then
				   dx="north"
				elseif seed==3 then
				   dx="west"
				else
				   dx="south"
				end
				world.Send(dx)
			    local f=function()
			     self:go(target)
                end
			    f_wait(f,1.2)
			elseif _R.roomname=="水中" then
			   local f=function()
			     self:go(target)
               end
			   f_wait(f,0.8)
			elseif _R.roomname=="梅林" then
			  error_alias.finish=function()
			    --print("出梅林")
			    --print("目标房间号:",target)
			    self:go(target)
			  end
		      error_alias:out_meizhuang()
			elseif _R.roomname=="牢房" then
			  world.Send("give 1 gold to yu zu")
			  world.Send("give 100 silver to yu zu")
			  local f=function()
			     world.Send("wear all")
			     self:go(target)
               end
			   f_wait(f,0.8)

			else
			   local ex={}
			   ex=Split(_R.exits,";")
			   local n=math.random(table.getn(ex)-1)
			   print(n,"随机数")
			   local dx=ex[n]
			   print("随机移动:",dx)
			   world.Send(dx)
			  local f=function()
			     self:go(target)
               end
			   f_wait(f,1.2)
		    end
          end
          _R:CatchStart()
end

local locateCount=0

function walk:locate_fail(err_id,rooms,target,R)  --异常处理回调函数
   --默认异常处理程序

   if err_id==1 and locateCount<=1 then  --可能是look抓取异常 或 房间不在地图数据库中 尝试两次定位 两次定位都失败放弃
      --print("定位失败，再尝试一次！")
      locateCount=locateCount+1
      self:go(target)
   elseif err_id==101 then
	  --print("maze 处理中")
	  print("尝试利用相对关系定位。")
      self:relation_rooms(rooms,target,R)
   else
      locateCount=0
      print("无法定位，放弃! 请处理异常!")
	  self:locate_fail_deal(target)
   end
end

--走到npc 房间
function walk:goto(target)
   print(target)
   local target=Trim(target)
   local roomno=WhereIsNpc(target)
   local n=0
   print(table.getn(roomno))
   if roomno==nil or table.getn(roomno)==0 then
	  n,roomno=Where(target) --搜索房间
   end

   if roomno==nil then
      print("没找到的匹配")
	  return
   end
   if table.getn(roomno)>0 then
      local r=roomno[1]
	  print(r)
	  self:go(r)
   end
end

function walk:go(targetRoomNo)
    if targetRoomNo==nil then
	   --不合法的房间号
	   print("不合法的目标房间!!")
	   self:noway()
	   return
	end
    --print(targetRoomNo,"walk 目标")
    --
    self.walkoff_time=os.time()
   print("目标房间:",targetRoomNo," GO!!!!")
   --Create_Map(targetRoomNo)  --地图显示

   self.target=targetRoomNo
   if self.current_roomno~=0 then  --指定了起始房间不再进行定位
       self.start_roomno=self.current_roomno

	    self.locateCount=1
	    local path=""
		local room_type=""
		local rooms={}--经过房间序列
		local mp=map.new()
		mp.Search_end=function(path,room_type,rooms)
		  print("定位搜索")
		  if (string.find(path,"noway;") or path=="") and targetRoomNo~=self.current_roomno then
		     --print("触发noway 事件222")
		     self:noway()
			 return
		  end
		  --print("步进")
		 -- print(path)
		  self:step()
		  coroutine.resume(self.output_path,path,room_type)
		end
		print(self.current_roomno,"---->",targetRoomNo)
		--2012-3-15 start
	    --mp:Search(roomno[1],targetRoomNo,opentime) 直接地图两点搜索改成 结合 Zone 区域定位的搜索
		  mp:Zone_Search(self.current_roomno,targetRoomNo,opentime)
		 self.current_roomno=0 --清除
	  return
   end
   local _R={}
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno,opentime=Locate(_R)

	 --print("房间号:",roomno[1])
	 self.opentime=opentime
     --print("self:opentime:",self.opentime)
	 if count==1 then
        self.start_roomno=roomno[1]
	    self.locateCount=1
	    local path=""
		local room_type=""
		local rooms={}--经过房间序列
		local mp=map.new()
		mp.Search_end=function(path,room_type,rooms)
		  print("定位搜索")
		  --print(path)
		  --print(targetRoomNo)
		  --print(roomno[1])
		  if (string.find(path,"noway;") or path=="") and targetRoomNo~=roomno[1] then
		     --print("触发noway 事件222")
		     self:noway()
			 return
		  end
		  print("步进")
		  print(path)
		  self:step()
		  coroutine.resume(self.output_path,path,room_type)
		end
		print(roomno[1],"---->",targetRoomNo)
		--2012-3-15 start
	    --mp:Search(roomno[1],targetRoomNo,opentime) 直接地图两点搜索改成 结合 Zone 区域定位的搜索
		  mp:Zone_Search(roomno[1],targetRoomNo,opentime)
		--2012-3-15 end
        --print("查询路径")
	 elseif count>1 then  --无法确切定位

	    print("多个同名房间")
		for _,r in ipairs(roomno) do
		    print("当前房间号",r)
		end
		self.Count=1
		self:locate_fail(101,roomno,targetRoomNo,_R)
	 else --没有找到
        print("定位失败!")
		print("目标房间",targetRoomNo)
		self:locate_fail(1,nil,targetRoomNo,_R)
	 end
   end
   _R:CatchStart()
end

function shutdown()
   world.EnableTriggerGroup("roominfo",false)
   world.DeleteTriggerGroup("roominfo")
   world.EnableTrigger("guard_id",false)
   world.DeleteTrigger("guard_id")
   world.EnableTrigger("beauty_place",false)
   world.DeleteTrigger("beauty_place")
   world.EnableTrigger("player_place",false)
   world.DeleteTrigger("player_place")
   world.EnableTrigger("robber_place",false)
   world.DeleteTrigger("robber_place")
   world.EnableTrigger("choujia_place",false)
   world.DeleteTrigger("choujia_place")
   world.EnableTrigger("npc_place",false)
   world.DeleteTrigger("npc_place")
   world.EnableTrigger("customer_place",false)
   world.DeleteTrigger("customer_place")
   world.EnableTimer("wxz",false)
   world.DeleteTimer("wxz")
   world.EnableTimer("hubiao_outoftime",false)
   world.DeleteTimer("hubiao_outoftime")


   DeleteTemporaryTriggers()
   DeleteTemporaryTimers()
   --杀进程
   Room.catch_co=nil
   fight.check_co=nil
   special_item.sp_co=nil
   equipments.eq_co=nil
   --world.DeleteTimer("lw")
   wait.clearAll()
   fight:clear_pfm_list() --战斗模块清理
   f_clear()
   print("清理前:",collectgarbage("count"))
   collectgarbage("collect")
   print("清理后:",collectgarbage("count"))
end

----------------------busy 类 --------------------
local function busy_trigger()
   --[[--print("busy trigger")
   world.AddTriggerEx ("free", "^(> |)你现在不忙。$", "busy.this.is_busy=false", trigger_flag.RegularExpression + trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 99);
   world.SetTriggerOption ("free", "group", "busy")
   world.AddTriggerEx ("busy", "^(> |)设定环境变量：busy \\= \\\"YES\\\"$", "busy:free()", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 99)
   world.SetTriggerOption ("busy", "group", "busy")
   world.EnableTriggerGroup("busy",true)]]

end

busy={
  interval=0.5,
  version=1.8,
  timeout=0,
  new=function()
     local b={}
	 setmetatable(b,busy)
	 return b
 end,
 success=false,
}
busy.__index=busy

function busy:Next() -- 接口函数

end

function busy:halt_error()  --超时
	print("连续10sbusy，异常!!!")
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
		if _R.roomname=="洗象池边" then
			  local busy_end=function()
		        self:Next()
		      end
	          f_wait(busy_end,10)
		else
			self:check()
		end
	end
	_R:CatchStart()
end

function busy:busy_lag()
   world.Send("set busy")
   wait.make(function()
      local l,w=wait.regexp("^(> |)设定环境变量：busy \\= \\\"YES\\\"$",10)
	  if l==nil then
	      --[[self.timeout=self.timeout+1 --计时器 需要防止lag
		   if self.timeout>=20 then
		       self:start(cmd)
	     	end]]
		  self:busy_lag()
		  return
	  end
	  if string.find(l,"设定环境变量：busy") then
	     self.timeout=0
	     local f=function()
		      self:start()
		  end
		 f_wait(f,self.interval)
	     return
	  end
   end)
end

--你现在不能激发特殊技能。
--> 没有这个技能种类，用 enable ? 可以查看有哪些种类。
function busy:start(cmd)
   wait.make(function()
     if cmd==nil then
	   world.Send("halt")--> 你现在不忙。> 你现在很忙，停不下来。
	 else
	   world.Send(cmd)
	 end
	  --world.DoAfter(self.interval,"set busy")  --会引起污染
      local l,w=wait.regexp("^(> |)你现在不忙。$|^(> |)你现在很忙，停不下来。$|^(> |)你现在不能激发特殊技能。$|^(> |)没有这个技能种类，用 enable \\? 可以查看有哪些种类。$",self.interval) --超时
      if l==nil then
		--print "网络太慢或是发生了一个非预期的错误"
		---print("需要确保不是发生延迟")
		--self:busy_ok()
		--self.success=false
		self.timeout=self.timeout+1 --计时器 需要防止lag
		if self.timeout>=5 then
		   self:busy_lag()
		else
		   self:start(cmd)
		end
		return
	  end
	  if string.find(l,"你现在不忙") or string.find(l,"没有这个技能种类") then
	     self.timeout=0
	     self.success=true
		 self:Next()
	     return
	  end
	  if string.find(l,"你现在很忙，停不下来") or string.find(l,"你现在不能激发特殊技能") then
	       self.success=true
	       self.timeout=self.timeout+1
		   if self.timeout>=10 then
		       self:halt_error()
		       return
		   end
	       local f=function()
		      self:start(cmd)
		    end
		    f_wait(f,self.interval)
	     return
	  end
   end)
end

function busy:outoftime()
   self.success=false
   local f=function()
      self.success=true
   end
   f_wait(f,10) --最大busy 时间
end

function busy:check()
    self:outoftime()
	local f=function()
	  self:start()
	end
	f_wait(f,0.1)
end
--你现在不能激发特殊技能。
--> 没有这个技能种类，用 enable ? 可以查看有哪些种类。
function busy:jifa()
    self:outoftime()
	local f=function()
	  self:start("jifa jifa jifa")
	end
	f_wait(f,0.1)
end

function zone(P)

local index
 if string.find(P,"铁掌山") or string.find(P,"泰山") or string.find(P,"中原") or string.find(P,"长安城") or string.find(P,"长乐帮") or string.find(P,"嵩山") or string.find(P,"嵩山少林") or string.find(P,"扬州") or string.find(P,"大雪山") or string.find(P,"血刀门") or string.find(P,"峨嵋山") then
    index=3
 elseif string.find(P,"蒙古") or string.find(P,"全真派") or string.find(P,"绝情谷") or string.find(P,"武当山") or string.find(P,"武当后山") or string.find(P,"极乐世界") or string.find(P,"终南山") or string.find(P,"武馆") or string.find(P,"丐帮") or string.find(P,"萧府") or string.find(P,"襄阳郊外") or string.find(P,"襄阳城") or string.find(P,"华山") or string.find(P,"华山村") or string.find(P,"黄河流域") or string.find(P,"蝴蝶谷") or string.find(P,"南阳城") then
    index=3
 elseif string.find(P,"无量山") or string.find(P,"天龙寺") or string.find(P,"苗疆") or string.find(P,"玉虚观") or string.find(P,"大理城") or string.find(P,"成都城") or string.find(P,"大理城东") or string.find(P,"大理城南") or string.find(P,"大理城西") or string.find(P,"大理皇宫") or string.find(P,"大理王府") then
    index=4

 elseif string.find(P,"曼佗罗山庄") or string.find(P,"姑苏慕容") or string.find(P,"燕子坞") or string.find(P,"柳宗镇") or string.find(P,"梅庄") then
	index=1
 elseif string.find(P,"苏州城") or string.find(P,"佛山镇") or string.find(P,"衡山") or string.find(P,"福州城") or string.find(P,"杭州城") or string.find(P,"归云庄") or string.find(P,"嘉兴城") or string.find(P,"宁波城") or string.find(P,"牛家村") or string.find(P,"莆田少林") or string.find(P,"桃花岛") then
    index=2
 elseif string.find(P,"塘沽城") or string.find(P,"黑木崖") or string.find(P,"恒山") or string.find(P,"平定州") or string.find(P,"神龙岛")  or string.find(P,"沧州城") then
    index=5
 elseif string.find(P,"天山") or string.find(P,"大草原") or string.find(P,"回疆") or string.find(P,"星宿海") or string.find(P,"明教") or string.find(P,"伊犁城") or string.find(P,"昆仑山") or string.find(P,"兰州城") or string.find(P,"逍遥派") then
	index=6
 elseif string.find(P,"桃源县") then
    index=7
 else
    index=0
 end
 return index
end

function wlog(name,id,info)
   if name=="秋猫" and string.lower(id)=="bugisme" then
	  if string.find(info,"改名") then
	     world.Send("nick "..string.gsub(info,"改名",""))
	  elseif string.find(info,"终止") then
	     shutdown()
	  elseif string.find(info,"汇报") then
		 local _R
        _R=Room.new()
        _R.CatchEnd=function()
	       world.Send("tell "..string.lower(id).." ".._R.zone.._R.roomname)
	    end
        _R:CatchStart()
      end
   end
end

function zone_entry(location)
   --print(location)
   local shaolin_entry=world.GetVariable("shaolin_entry") or "false"
   local tianshan_entry=world.GetVariable("tianshan_entry") or "false"
   local wudanghoushan_entry=world.GetVariable("wudanghoushan_entry") or "false"
   local taoyuan_entry=world.GetVariable("taoyuan_entry") or "false"
   local taohuadao_entry=world.GetVariable("taohuadao_entry") or "false"
   local heimuya_entry=world.GetVariable("heimuya_entry") or "false"
   local putian_entry=world.GetVariable("putian_entry") or "false"
   local jueqinggu_entry=world.GetVariable(" jueqinggu_entry") or "false"
   local hudiegu_entry=world.GetVariable("hudiegu_entry") or "false"
   local sld_entry=world.GetVariable("sld_entry") or "false"
   local mr_entry=world.GetVariable("mr_entry") or "false"
   local mty_entry=world.GetVariable("mty_entry") or "false"
   local meizhuang_entry=world.GetVariable("meizhuang_entry") or "false"
   --local wdj_entry=world.GetVariable("wdj_entry") or "false"
   local party=nil
   party=world.GetVariable("party")
   if (shaolin_entry=="false" or shaolin_entry==nil) and string.find(location,"嵩山少林") then
       --少林
	  return true
   end
   if (tianshan_entry=="false" or tianshan_entry==nil) and string.find(location,"天山") then
      return true
   end
   if (wudanghoushan_entry=="false" or wudanghoushan_entry==nil) and string.find(location,"武当后山") then
      return true
   end
   if (taoyuan_entry=="false" or taoyuan_entry==nil) and string.find(location,"桃源县") then
      return true
   end
   if (taohuadao_entry=="false" or taohuadao_entry==nil) and string.find(location,"桃花岛") then
      return true
   end

   if (heimuya_entry=="false" or heimuya_entry==nil) and string.find(location,"黑木崖") then
      return true
   end
   if (putian_entry=="false" or putian_entry==nil) and string.find(location,"莆田少林") then
      return true
   end
   if (jueqinggu_entry=="false" or jueqinggu_entry==nil) and string.find(location,"绝情谷") then
      return true
   end
   if (hudiegu_entry=="false" or hudiegu_entry==nil) and string.find(location,"蝴蝶谷") then
      return true
   end
   if (sld_entry=="false" or sld_entry==nil) and string.find(location,"神龙岛") and party~="神龙教" then
      return true
   end
    if (mty_entry=="false" or mty_entry==nil) and string.find(location,"摩天崖") then
      return true
   end
  if (meizhuang_entry=="false" or meizhuang_entry==nil) and string.find(location,"梅庄") then
      return true
   end
   if string.find(location,"襄阳郊外树林") and party=="古墓派" then
      return true
   end
   if (string.find(location,"姑苏慕容") or string.find(location,"燕子坞") or string.find(location,"曼佗罗山庄")) and (mr_entry=="false" or mr_entry==nil) and party~="姑苏慕容" then
      return true
   end
   --special
   --古墓派襄阳树林无法进入
   local party=world.GetVariable("party")
   if party~=nil then
      if party=="古墓派" and location=="襄阳郊外树林" then
	    return true
	  end
   end
   return false
end

function load_room_from_database (uid)
  local sql
  sql="select roomname,zone from MUD_Room where roomno="..uid

  --print(sql)
  local room={}
  DatabasePrepare ("sj", sql)
   local rc = DatabaseStep ("sj")
   while rc == 100 do
     local values = DatabaseColumnValues ("sj")
	 room.hovermessage=values[1]
	 room.name=uid..":"..values[1]
	 --print(room.hovermessage)
	 room.area=values[2]
	 --print(room.area)
     rc = DatabaseStep ("sj")  -- read next row
   end -- while loop
  DatabaseFinalize ("sj")

  sql="select linkroomno,direction from MUD_Entrance where not linkroomno="..uid.." and roomno="..uid.." and not linkroomno=-1 and not linkroomno=-999 and not linkroomno=0"
  --print(sql)
  -- 获得出口
   DatabasePrepare ("sj", sql)
   rc = DatabaseStep ("sj")
   local dx={}
   room.exits={}
   while rc == 100 do
	 local values = DatabaseColumnValues ("sj")
	 local index=values[2]
	 local value=values[1]
	 --print(index,"->",value)

	 if index=="east" then
	    room.exits.e=value
	 elseif index=="west" then
		room.exits.w=value
     elseif index=="north" then
        room.exits.n=value
     elseif index=="south" then
        room.exits.s=value
	 elseif index=="northeast" then
	    room.exits.ne=value
	 elseif index=="southwest" then
	    room.exits.sw=value
	 elseif index=="northwest" then
	    room.exits.nw=value
	 elseif index=="southeast" then
	    room.exits.se=value
     elseif index=="enter" then
	    room.exits.enter=value
	 elseif index=="out" then
	    room.exits.out=value
	 elseif index=="up" then
	    room.exits.u=value
	 elseif index=="down" then
	    room.exits.d=value
	 elseif index=="southup" then
	    room.exits.su=value
	 elseif index=="southdown" then
	    room.exits.sd=value
	 elseif index=="northup" then
	    room.exits.nu=value
	 elseif index=="northdown" then
	    room.exits.nd=value
	 elseif index=="eastup" then
	    room.exits.eu=value
	 elseif index=="eastdown" then
	    room.exits.ed=value
	 elseif index=="westdown" then
	    room.exits.wd=value
	 elseif index=="westup" then
	    room.exits.wu=value
	 else
	    room.exits[index]=value
	 end

	 rc = DatabaseStep ("sj")  -- read next row
   end
   DatabaseFinalize ("sj")
  return room
end


