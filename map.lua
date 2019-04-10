--�����˺���·�����㶨λ����
--require "strict"
world.AddAlias("zmud", "zmud", "zmud_alias_convert()", alias_flag.Enabled + alias_flag.Replace, "")
world.SetAliasOption ("zmud", "send_to", 12) --��ű�����
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
  local zmud_alias=utils.inputbox("����zmud alias��ʽ", "��ʽת��", "", "����", 9) or ""
  if zmud_alias~="" then
    zmud_alias=string.gsub(zmud_alias,";","|")
    zmud_alias=Trim(zmud_alias)
    marco(zmud_alias)
  end
end
--local search_count=0 --��������
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
   elseif exitname=="jump out" or exitname=="jump river"  or exitname=="pa up" or exitname=="climb down" or exitname=="swim"  or exitname=="enter ������" or exitname=="climb up" then
       return false
   elseif exitname=="shanzhuang" or exitname=="xiaodao" or exitname=="yanziwu" or exitname=="jump liang" or exitname=="jump zhuang" or exitname=="jump down" or exitname=="climb" or exitname=="jump window" then
       return false

   elseif exitname=="weapon" or exitname=="gift" or exitname=="combat" or string.find(exitname,";") then
       return false
   else
       return true
   end
end

local tbl_query={} --����hashtable rows
local tbl_bottom_query={} --�ӵײ�������
local tbl_top_query={} --�Ӷ���������
function import_query()  --�ӵײ���ʼ �����ڵ㶼��ͬ
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
	  ----print("�ر�")
	  DatabaseFinalize ("sj")
end

function import_bottom()  --�ӵײ���ʼ �����ڵ㶼��ͬ
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
	  ----print("�ر�")
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
      print(roomno," �����")
	  print(table.getn(item))

	     print(item.roomno," > ",item.linkroomno," ",item.direction)
	  --end
   end
end

function test_top()
   for roomno,item in pairs(tbl_top_query) do
      print(roomno," �����")
	  print(table.getn(item.rows))
	  for _,i in ipairs(item.rows) do
	     print(i.id)
	  end

   end
end

function test_bottom()
   for roomno,item in pairs(tbl_bottom_query) do
      print(roomno," �����")
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
	  if party=="����Ľ��" then
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
	  elseif party=="��" then
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
        if tonumber(exps)<=3000 then  --��ݳ���
           cmd="update MUD_Entrance set linkroomno=-1 where direction='outwuguan'"
		   DatabaseExec("sj",cmd)
        end
	   if mastername~="������" then
		  cmd="update MUD_Entrance set linkroomno=-1 where direction='siguoya_jiashanbi' or (roomno=4096 and direction='out')"
		  --print(cmd)
	   else
		 cmd="update MUD_Entrance set linkroomno=4986 where direction='siguoya_jiashanbi'"

       end
	    --print(cmd)
	   DatabaseExec("sj",cmd)

		if party~="���չ�" and party~="��" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='t_leave' or direction='huigong'"
			-- print(cmd)
			DatabaseExec("sj",cmd)
		elseif party=="��" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='t_leave'"
			-- print(cmd)
			DatabaseExec("sj",cmd)


			if tonumber(exps)<=100000 then  --���յ���100000 û�����ɳ���
			  cmd="update MUD_Entrance set linkroomno=-1 where direction='xianchoumen_baizhangjian' or direction='baizhangjian_xianchoumen'"
			   --print(cmd)
			   DatabaseExec("sj",cmd)

			   cmd="delete from MUD_Zone where ToZone='���޺�' and FromZone='��ɽ'"
			   --print(cmd)
			   DatabaseExec("sj",cmd)

			   cmd="delete from MUD_Zone where FromZone='���޺�' and ToZone='��ɽ'"
			   --print(cmd)
			   DatabaseExec("sj",cmd)
			end
	    end


         if party~="��ң��" and party~="��" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='climb_shanlu'"
			-- print(cmd)
			DatabaseExec("sj",cmd)
	    end
		--4243 climb ɽ· 4234
		--4234 push door 4243

		if party~="�䵱��" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='yuanmen_xiaoyuan'"
			DatabaseExec("sj",cmd)
			-- print(cmd)
	    end
		if party~="������" then
			cmd="update MUD_Entrance set linkroomno=-1 where direction='dadukou_shenlongdao'"
			DatabaseExec("sj",cmd)
			-- print(cmd)
	    end
		if party=="�䵱��" and mastername=="������" then
			cmd="update MUD_Entrance set linkroomno=2771 where linkroomno=2755 and roomno=2754"
			DatabaseExec("sj",cmd)
			cmd="update MUD_Entrance set linkroomno=2754 where linkroomno=2755 and roomno=2771"
			DatabaseExec("sj",cmd)
			cmd="delete from MUD_Room where roomno=2755"
			DatabaseExec("sj",cmd)
            print("�䵱��")
			world.AddTriggerEx ("tj1", "^(> |)�㻺��������������ֱ���С���ˣ���\,�㰵����������̫���������־���ʹ�ĳ����뻯��$", "local taiji=world.GetVariable(\"taiji\") or 0\nif taiji==0 then Send(\"set taiji ��|��|��|��\") else Execute(\"set taiji ��|��|��|��;jiali 50\") end", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)
            world.AddTriggerEx ("tj2", "^(> |)����һ��ʵ�������������Ϊ���������ڹ�.*$", "SetVariable(\"taijian\",1)\nExecute(\"set taiji ��|��|��|��;jiali 50\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "","", 12, 9999)
            world.AddTriggerEx ("tj3", "^(> |)�㡸̫������ʹ�꣬���鵤������չ����ˣ�$", "Execute(\"jiali 1;yun jingli;set taiji ��|��|��|��\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 9999)

			 --print(cmd)
	    end
		if party~="����" then
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
		if party~="��Ĺ��" then
		     cmd="update MUD_Entrance set linkroomno=-1 where direction='tiao' or direction='xiao'"  --����� �
		    --print(cmd)
	    	DatabaseExec("sj",cmd)
        elseif mastername=="��" then  --��Ĺ���������
		     cmd="update MUD_Entrance set linkroomno=-1 where direction='xiao'"  --����� �
		    --print(cmd)
	    	DatabaseExec("sj",cmd)
		end
		if mastername=="���ٳ���" then
		   cmd="update MUD_Entrance set linkroomno=-1 where direcion='dangtianmen_xiuxishi'"
		   DatabaseExec("sj",cmd)
		end
		if mastername=="һ�ƴ�ʦ" then
			 cmd="update MUD_Entrance set linkroomno=-1 where direction='yuren'"
		     DatabaseExec("sj",cmd)
		else
		    cmd="update MUD_Entrance set linkroomno=-1 where direction='maowu_hetang'"
		   -- print(cmd)
	    	DatabaseExec("sj",cmd)
		end
	    if party~="������" then
		  cmd="update MUD_Entrance set linkroomno=-1 where direction='xinchanping_xinchantang' or direction='yanwutang_wusengtang' or direction='qingyunpin_fumoquan'"
			-- print(cmd)
			DatabaseExec("sj",cmd)
        end
		if party~="������" then
		    cmd="update MUD_Entrance set linkroomno=-1 where direction='north' and roomno=1969"
			DatabaseExec("sj",cmd)
        end
        local exps=world.GetVariable("exps") or "0"
		exps=tonumber(exps)
		if exps<200000 then
         cmd="update MUD_Entrance set linkroomno=-1 where roomno=593 and direction='north'"  --�Ṧ����50
		 DatabaseExec("sj",cmd)
		else
		 cmd="update MUD_Entrance set linkroomno=595 where roomno=593 and direction='north'"  --�Ṧ����50
		 DatabaseExec("sj",cmd)
		end


	    --local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'"
		--DatabaseExec("sj",cmd)

		local cmd="update MUD_Entrance set linkroomno=-1 where direction='shanjiao_shanlu'"
		DatabaseExec("sj",cmd)
        -- ����id ����ֱ�ӽ���
		local skills=world.GetVariable("teach_skills") or ""
        local ski={}
         ski=Split(skills,"|")
        for _,v in ipairs(ski) do
          if v=="jiuyang-shengong" then
	        print("������ֱ�ӽ����嶾��")

	        local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --��wdj.wdj2_ok ����һ��
	        DatabaseExec("sj",cmd)
	        break
          end
        end



	  --print("���� ����·��")
      --import_top()  --�������� �����
	  --import_bottom()  --�ײ����������
	  --import_query() --����
	  refresh_link()
end
	  --print(cmd)
function refresh_link()
	  import_top()  --�������� �����
	  import_bottom()  --�ײ����������
	  import_query() --����
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
         ----print("�Ѵ򿪵����ݿ�����:",v)
	     if v=="sj" then
		    print("���ݿ��Ѵ�")
		    return
		 end
       end
    end
	print("���ݿ⵼���ڴ棡")
	world.DatabaseOpen ("db", database_path, 2) --ֻ�����ݿ�
	world.DatabaseOpen ("db2", database_path, 6) --ֻ�����ݿ�
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
	--���ݵ���
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
	  world.DatabaseClose("db")  --�ر����ݿ�
	  --DatabaseClose("db2")
end

function map_init(db_name)
  --DatabaseOpen ("db", GetInfo (66) .. "sj.db", 6)
  ------print(GetInfo (66) .. "sj.db")
  --DatabaseOpen ("db", GetInfo (66) .. db_name, 6) --ֻ�����ݿ�
  local path=world.GetInfo (66) .. db_name
  world.DatabaseOpen ("db", path, 2) --ֻ�����ݿ�
  world.DatabaseOpen ("db2", path, 6)--�޸����ݿ�
  database_path=path
  --��������
  print("-------------------------------------")
  print("�������ݿ�"..db_name)
  print("-------------------------------------")
  import_data()
  --����������������������
  update_data()
end
--���ݽṹ ����
local vector={
   roomno=nil,  --��ǰ�ڵ㷿���
   direction="", --����
   linkroomno=nil, --�����ڵ㷿���
   roomtype="", --��������
}

local Bottom={}
local Bottom_buffer={} --�ײ���������
local Bottom_buffer_len=0
local Bottom_pre_existing={}

local Top={}
local Top_buffer={} --������������
local Top_buffer_len=0
local Top_pre_existing={}

local _list={} --���ⷿ���б�
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
--����������غϽڵ�
local function T_Contain(roomno)
   ------print("TĿ��",roomno)

   for i,t in ipairs(Top) do
      if t.linkroomno==roomno then
	     return true
	  end
   end
     return false

end

--��鷴�����غϽڵ�
local function B_Contain(roomno)
   ------print("BĿ��",roomno)
   for i,b in ipairs(Bottom) do
      if b.roomno==roomno then
	     return true
	  end
   end
      return false

end

--����Ƿ����
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


function map:virtual(v)  --���ⷿ��
     local al
	 if self.user_alias==nil then
	   al=alias.new()
	 else
	   al=self.user_alias
	 end
     ------print("����",v.direction)
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
		al.finish=function(result) --�ص�����
		   coroutine.resume(self.Search_co,result)
		end
		al:opentime(condition)
	    --self:opening(condition)
	    ----print("��ͣȷ��mudʱ�䣺")
	    cond=coroutine.yield()
	    self.opentime=cond --����
	   end
	 elseif (self.start==2663 or self.start==2665 or self.start==2664 or self.start==2666 or self.start==2667 or self.start==2668 or self.start==2674) and v.direction=="jump river" then
	    cond=true
	 elseif (self.End==2464 or self.End==2519 or self.End==2520 or self.End==2521 or self.End==2522 or self.End==2523 or self.End==2524 or self.End==2525 or self.End==2526 or self.End==2527 or self.End==2528 or self.End==3041 or self.End==2887 or self.End==2888 or self.End==2889 or self.End==2890) and v.direction=="zishanlin" then
		 cond=true
     elseif (party=="����Ľ��" and v.direction=="didao") then
	   -- ----print("����Ľ��")
	    cond=true
	 elseif (party=="������" and v.direction=="songlin_jielvyuan") then
	    cond=true
	 elseif (v.direction=="guanmucong" and mastername=="�º���") then
	    cond=true
	 elseif (party~="����Ľ��" and v.direction=="goboat") then
	    ------print("��Ľ�ݵ���")
		cond=true
	 elseif (party=="���չ�" and v.direction=="t_leave") or (party=="���չ�" and v.direction=="huigong") then
	    cond=true
	 elseif (party=="������" and v.direction=="shenlongdao_dadukou") or (party=="������" and v.direction=="dadukou_shenlongdao") then
	    ------print(party,v.direction,"why")
	    cond=true
	 elseif (party=="������" and v.direction=="xinchanping_xinchantang") or (party=="������" and v.direction=="yanwutang_wusengtang") or (party=="������" and v.direction=="qingyunpin_fumoquan") then
	    cond=true
	 --elseif (party=="��Ĺ��" and v.direction=="jumpya") then
	 --   cond=true
	 elseif (party=="������" and v.direction=="kunlun_houshan") then
	    cond=true
	 elseif (party=="����" and v.direction=="shanbi_huacong") then
	    cond=true
	 elseif (party=="������" and v.direction=="maowu_hetang") then
	    cond=true
	 elseif (exps<=50000 and v.direction=="tengkuang") then
        cond=true
	 --[[ ���嶾��
	 elseif (v.direction=="shanjiao_shanlu" and wdj.wdj2_ok==true) then  --ȥ�嶾�� ֻ�гԵ�����ҩ�Ż����
	     print("�嶾���б�")
	     local _wdj=wdj.new()
		  _wdj.check_posion=function() --�Թ���ҩ ����û��ץ��֩��
		     coroutine.resume(self.Search_co,true)
		  end
		  _wdj.finish=function() --������Ч����
		    -- print("��Ч����")
		     coroutine.resume(self.Search_co,true)
		  end
		  _wdj.start=function() --��Ч�ڹ�
		     coroutine.resume(self.Search_co,false)
		  end
		 _wdj:check()
	     cond=coroutine.yield() --��ͣ]]
     else
		 cond=false
	 end
	 ----print("���:",cond," ",party," ",v.direction)

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
	    ------print("��ͨ")
		v.roomno="-10"
		v.linkroomno="0"

	end
     v.roomtype=''
    ------print("test3333")
end

--�ӽ����ڵ㿪ʼ����
function map:Bottom_Start()
    ------print("BOTTOM------------------------------")
    while true do
	   --buffer ����
	   Bottom_buffer_len=table.getn(Bottom_buffer)
	   --if Bottom_buffer_len> Top_buffer_len then
	   --print("Bottom_Weight:",Bottom_Weight)
       if Bottom_buffer_len> Top_buffer_len then
	      break
	   elseif Bottom_buffer_len==0 then

		  return false,nil
	   end
	  --ѭ����ȡ
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
	  -- 2016 --12 -18  ���ڴ������
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
		 --print("ֵ",v.roomno)
		 if v.roomtype=="V" then
		    ----print("����")
			----print(v.roomno)
			self:virtual(v)
			----print("���������1")
			----print("virtual" ," roomtype ",v.roomtype," roomno ",v.roomno)
		 else
		    real_list(v)
		 end
		 ----print("bug2")
		   ----print("vector2",v.roomno,v.direction,v.linkroomno,v.roomtype)
		   --��ȡ���ݿ� ���top û�в��� Bottom & Bottom_buffer
		 if T_Contain(v.roomno)==true and v.weight<=0 then
		  -- --print("true","Bottom",v.roomno)
	         table.insert(Bottom,v)
			 --Bottom[v.roomno]=v
		    -- DatabaseFinalize ("sj")
	         return true,v.roomno  --�ҵ��غϵ�
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
	  ----print("�ر�")
	  --DatabaseFinalize ("sj")
	  ----print("bug4")
	  end
    end

	return false,nil
end

--�ӿ�ʼ�ڵ㿪ʼ����
function map:Top_Start()
    ----print("Top------------------------------------------")
	--co=coroutine.create(function()
    while true do
	   --buffer ����
	   Top_buffer_len=table.getn(Top_buffer)
	   ----print("����",Top_buffer_len,Bottom_buffer_len)
	   if Top_buffer_len > Bottom_buffer_len then
		  break
	   elseif Top_buffer_len==0 then
		 return false,nil
	   end
	  --ѭ����ȡ
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
			--print("����:",v.roomno)
			if v.roomtype=="V" then
			   ----print("����")
			   ----print(v.roomno,v.direction)
			   self:virtual(v)
			   ----print("���������2")
			   ----print("virtual" ," roomtype ",v.roomtype," roomno ",v.roomno)
			else
		       real_list(v)
			end
		    ----print("vector1",v.roomno,v.direction,v.linkroomno,v.roomtype)
		 	 --��ȡ���ݿ� ���top û�в��� Bottom & Bottom_buffer
			if B_Contain(v.linkroomno)==true and v.weight<=0 then
			  ----print("true","Top",v.linkroomno)
	           table.insert(Top,v)
			    --Top[v.linkroomno]=v
			   --DatabaseFinalize ("sj")
			   --print("�ҵ��غϵ�")
	           return true,v.linkroomno  --�ҵ��غϵ�
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

--·��
function Get_Path(FromRoomNo,ToRoomNo)
     local sql
	  sql=table.concat({"SELECT Path,Room_Type from MUD_Paths where FromRoomNo=",FromRoomNo," and ToRoomNo=",ToRoomNo})
	  local party=world.GetVariable("party") or ""
	  if party=="������" then
	    sql=sql .. " and (party='������' or party='ͨ��' or party='' or party isnull)"
	  elseif party=="����Ľ��" then
	    sql=sql .. " and (party='����Ľ��' or party='ͨ��2' or party='' or party isnull)"
	  elseif party=="���չ�" then
	    sql=sql .. " and (party='���չ�' or party='ͨ��2' or party='' or party isnull)"
	  elseif party=="��" then
	    sql=sql.." and (party='��' or party='ͨ��2' or party='' or party isnull)"
	  elseif party=="��ң��" then
	    sql=sql.." and (party='��ң��' or party='ͨ��2' or party='' or party isnull)"
	  else
	    sql=sql .. " and (party='ͨ��' or party='ͨ��2' or party='' or party isnull)"
	  end
	  --print(sql)
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  --print(rc)
	  local values= DatabaseColumnValues ("sj")
      if values==nil then
	    --print("·��������:",sql)
		--print("�������ݿ�") --���·��
		 DatabaseFinalize ("sj") --�ر����ݿ�
		 --print("�ر����ݿ�!!!")
		  local startroomno=tonumber(FromRoomNo)
		 local endroomno=tonumber(ToRoomNo)
		 --print(startroomno," ",endroomno)
		local path,room_type,rooms=Search(startroomno,endroomno,true)
		  --[[if path~="noway;" then
		    local cmd=table.concat({"insert into MUD_Paths (FromRoomNo,Path,ToRoomNo,Room_Type) values(",FromRoomNo,",'",path,"',",ToRoomNo,",'",room_type,"')"})
		    --print(cmd)
		    DatabaseExec ("sj",cmd)
		  end]]
		  --print(path,"����",FromRoomNo,"->",ToRoomNO)
		  return path,room_type
		--[[ local mp=map.new()
 		 mp.Search_end=function(path,room_type,rooms)
		    print(path)
		    if path~="noway;" then
			   --print("ִ��")
               local cmd=table.concat({"insert into MUD_Paths (FromRoomNo,Path,ToRoomNo) values(",FromRoomNo,",'",path,"',",ToRoomNo,")"})
			   print(cmd)
			   --print("ִ��2")
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
	  --print(path,roomtype," ·�����")
	  if path=="" then
	      --print("·��������:",sql)
	  end
	 --   print(path,"����",FromRoomNo,"->",ToRoomNO)
	  DatabaseFinalize ("sj")
	  return path,roomtype
end

function map:Zone_BusStop(Zones,toZone)
  -- --print(toZone," ��������")
   local Path=""
   local BusStop=""
   local fromZone,linkRoomNo=ZoneClue(Zones,toZone) --��ʼֵ
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
   Zonelist=nil--clear ��������
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
--/print(map:Zones("���ݳ�","��������",false,1258,1231))

function map:Zones(fromZone,toZone,opentime,StartRoomNo,EndRoomNo)
    --print(fromZone,toZone,opentime)

    local P1,Z1=self:ZonePath(fromZone,toZone,true)--����·��
	local P2,Z2=self:ZonePath(fromZone,toZone,false)--����·��
	--print("",P1)
	--print(P2)
	if is_fuzhou(StartRoomNo) then
	    --print("fuzhou","YES")
		 P2,Z2=self:ZonePath(fromZone,toZone,'special')--����·��
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
		  --print("����:",P1," ",SR,"....",ER)
		  local P,T=Get_Path(SR,ER)
		  Paths=Paths..P
		  --print(Paths)
		 -- print("----------------")
		  Type=Type..T
	   end
	   return Paths,Type,tonumber(StartRoomNo),tonumber(EndRoomNo)
	end
	if Z1==Z2  then  --·�������ְ����ҹ
	   ----print("��ͬ")
	   return block()
	else
	   if opentime==nil then
	      --print("�жϰ�����ҹ")
	      local al=alias.new()
	      al.finish=function(result)
			--print("�ж�ʱ����:",result)
			self:Zone_Search(StartRoomNo,EndRoomNo,result)--���µ�ǰʱ������б�
			----print("P1:",P1,Z1)
			----print("------------------")
			----print("P2:",P2,Z2)
		    --if result==false then
			--  print("����")
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
	--print("���")
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
	    if party=="����Ľ��" then
	      sql=table.concat({sql," or Party='����Ľ��')"})
	    elseif party=="������" and (toZone=="������" or fromZone=="������") then -- Ŀ�ĵ�ȥ������ �������������ӵܲŻ�ӻƺ�����Խ
	      sql=table.concat({sql," or Party='��Ľ��' or Party='������')"})
	    elseif party=="���չ�" and (toZone=="��ɽ" or fromZone=="��ɽ") then
		  sql=table.concat({sql," or Party='��Ľ��' or Party='���չ�')"})
		elseif party=="��ң��" then --��ң��
		  sql=table.concat({sql," or Party='��Ľ��' or Party='��ң��')"})
		elseif party=="��" then --����
		  sql=table.concat({sql," or Party='����Ľ��' or Party='��')"})
	    else
		  sql=table.concat({sql," or Party='��Ľ��')"})
	    end
	    sql=table.concat({sql," and (condition isnull or condition=''"})
	    if Opentime==true then
	       sql=table.concat({sql," or condition='����' or condition='���ݳ���')"})
	    elseif Opentime=='special' then
	       sql=table.concat({sql," or not condition='���ݳ���')"})
	    else
		   sql=table.concat({sql," or condition='���ݳ���')"}) --ͨ��
	    end
        --print(sql)
 	     DatabasePrepare ("sj",sql)
	    local rc = DatabaseStep ("sj")
--����
	    while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  ----print("�����:",values[1])
          local linkZone={}
		  linkZone.fromZone=values[1]
          linkZone.toZone=values[2]
		  linkZone.linkRoomNo=values[3]
		  --print("quanzhen")
		  --linkZone.weight=values[4]

		  --print(linkZone.fromZone,linkZone.toZone,linkZone.linkRoomNo)
		   --print(linkZone.weight," weight")
		  if toZone==linkZone.toZone then
		     --print("�����������")
		     table.insert(Zonelist,linkZone)
			 DatabaseFinalize ("sj")--�ر����ݿ�
			 --[[ for _,Z in ipairs(Zonelist) do
			    print(Z.fromZone,">",Z.toZone," *",Z.linkRoomNo)
			 end]]
			 ------
			 return self:Zone_BusStop(Zonelist,toZone)

		  end
		   --print("���",Zone_Contain(linkZone.toZone))
		  if Zone_Contain(linkZone.toZone)==false then

             table.insert(Zonelist,linkZone)
			 table.insert(Zone_buffer,linkZone.toZone)
		  end
		  rc = DatabaseStep ("sj")
	    end
--�������
	     DatabaseFinalize ("sj")
   end
     --print("����1")
	  Zonelist={}
end
--ѹ�����ݿ�
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
	  if zone=="��ԭ" then
	    zone="�ɶ���"
	  end
	  if zone=="���͵�" then
	     zone="��ɽ��"
	  end
	  if zone=="��ԭ����" or zone=="��������" then
	    zone="���ݳ�"
	  end
	  if zone=="�Խ�ɽׯ" then
	    zone="���ְ�"
	  end
	  if zone=="Ħ����" then
	    zone="������"
	  end

	  --print(zone," zone")
	  return zone
end
--����ܳ�ʱ����ʱ·��
--[[
function Del_TEMP_Path()
	local cmd="delete from MUD_Paths where Update_time<=strftime('%Y/%m/%d %H:%M:%S','now','-1 hour', 'localtime')"
	DatabaseExec ("sj",cmd)
	DatabaseFinalize ("sj")
	zip_database()
end]]

--���ʵʱ�������ɵ���ʱ·��
function Get_TEMP_Path(FromRoomNo,ToRoomNo)
     local sql
	  sql=table.concat({"SELECT Path,Room_Type from MUD_Paths where FromRoomNo=",FromRoomNo," and ToRoomNo=",ToRoomNo})
 	  DatabasePrepare ("sj", sql)
	  local rc = DatabaseStep ("sj")
	  --print(rc)
	  local values= DatabaseColumnValues ("sj")
      if values==nil then
	    DatabaseFinalize ("sj")
	    --print("·��������:",sql)
	    return false,"",""
	  end
	 -- --print(valuevalues)
	  local path=values[1] or ""
	  local roomtype=values[2] or ""
	  --print(path,roomtype," ·�����")
	  if path=="" then
	      --print("·��������:",sql)
		  return false,"",""
	  end
	   local cmd="update MUD_Paths set Update_time=strftime('%Y/%m/%d %H:%M:%S','now', 'localtime') where FromRoomNo="..FromRoomNo.." and ToRoomNo="..ToRoomNo
	   DatabaseExec ("sj",cmd)
	   DatabaseFinalize ("sj")
	  return true,path,roomtype
end

--�����ط��������·��
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
		  print("����:",values[1])
		  local direction=values[1]
		  table.insert(dx,direction)
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")
	  return dx
end

function Pload()
	  print("-----------------��ʾ�ڴ����ݿ��¼��----------------")
	  local cmd="select count(*) from MUD_Paths"
	  DatabasePrepare ("sj", cmd)
	   local rc = DatabaseStep ("sj")
	  --print(rc)
	  local values= DatabaseColumnValues ("sj")
      print("Mud_Paths ����:",values[1])
	   print("-----------------����-------------------------------")
	  DatabaseFinalize ("sj")
end

function Insert_TEMP_Path(FromRoomNo,ToRoomNo,Path)
    if Path~="noway;" and string.len(Path)>=10 then --����10������·������
      -- print("ִ��")
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
	--print("���path",Paths)
	if Paths==nil then  --��Ҫ�б�ǰʱ��(���죬����) self:Zones �᷵�ؿ�·��
	   return
	end
	local mp=map:new()
	local tail=function() --β��
	    if End_linkRoomNo~=EndRoomNo then
		  local is_exist,g_path,g_room_type=Get_TEMP_Path(End_linkRoomNo,EndRoomNo) --�����ʱ·��������
		   if is_exist==true then  --����·��
		      Paths=Paths..g_path
			  Type=Type..g_room_type
			  self.Search_end(Paths,Type,nil)
		   else
		       mp.Search_end=function(path,room_type,rooms)
	             Paths=Paths..path
	             Type=Type..room_type
				  --Insert_TEMP_Path(End_linkRoomNo,EndRoomNo,path)  --������ʱ·����
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
	  local is_exist,g_path,g_room_type=Get_TEMP_Path(StartRoomNo,Start_linkRoomNo) --�����ʱ·��������
	  if is_exist==true then  --����·��
		   Paths=g_path..Paths
	       Type=g_room_type..Type
	        ----print(Paths)
	        ----print(Type)
		   tail()
	  else
	      mp.Search_end=function(path,room_type,rooms)
	       --print("����:",path)
	       Paths=path..Paths
	       Type=room_type..Type
		   --Insert_TEMP_Path(StartRoomNo,Start_linkRoomNo,path)  --������ʱ·����
		   --print("����2")
		   tail()
	      end
	      mp:Search(StartRoomNo,Start_linkRoomNo)
	  end
	else
      tail()
	end
    --search_count=search_count+1
	--print("search_count:",search_count)
	--if search_count>=300 then --�ر����ݿⳬ��300�β�ѯ �ͷ��ڴ�
	--	print("�ڴ��ͷ�!!")
	--	search_count=0
	--	DatabaseClose ("sj")
	--	import_data() --���¼������ݿ�
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
		  ----print("�����:",values[1])
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
		  ----print("�����:",values[1])
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
      self.Search_end=function(path,room_type,rooms)  --·�� �������� ���о����ķ����
		   self:NewPath(g.StartRoomNo,g.EndRoomNo,path,room_type)
	  end
      --self:Search(g.StartRoomNo,g.EndRoomNo,false)
	  self:Search(g.StartRoomNo,g.EndRoomNo,true) --����
   end
   --print("����·������")
end

local function Bottom_Start(opentime)
    ------print("BOTTOM------------------------------")
    while true do
	   --buffer ����
	   Bottom_buffer_len=table.getn(Bottom_buffer)
	  -- if Bottom_buffer_len> Top_buffer_len then
       if Bottom_buffer_len> Top_buffer_len then
	      break
	   elseif Bottom_buffer_len==0 then

		  return false,nil
	   end
	  --ѭ����ȡ
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
	         return true,v.roomno  --�ҵ��غϵ�
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
	         return true,v.roomno  --�ҵ��غϵ�
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
	   --buffer ����
	   -- print("Top_Weight:",Top_Weight)
	   Top_buffer_len=table.getn(Top_buffer)
	   ----print("����",Top_buffer_len,Bottom_buffer_len)
	   if Top_buffer_len > Bottom_buffer_len then
		  break
	   elseif Top_buffer_len==0 then
		 return false,nil
	   end
	  --ѭ����ȡ
	  --��Ȩ�صķ���Żض���ĩβ
	  local roomno
	  while true do
	    roomno=Top_buffer[1]
	    table.remove(Top_buffer,1)
	    if roomno.weight>0 then
		   --print(roomno," roomno weight: ",roomno.weight)
	       roomno.weight=roomno.weight-1
		   table.insert(Top_buffer,roomno) --�������
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
			----print("����:",v.roomtype)
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
	              return true,v.linkroomno  --�ҵ��غϵ�
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
	              return true,v.linkroomno  --�ҵ��غϵ�
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

function Search(StartRoomNo,EndRoomNo,opentime)  --�첽 ��ʼ���� �������� ʱ�� ���� �� ҹ��
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
	      --print("û��ͨ·!!!")
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
	    --print("�޷�����,noway")
	   path="noway;"
	end
	if room_type==nil or room_type=="" then
	   room_type=";"
	end

	  Bottom={}
      Bottom_buffer={} --�ײ���������
      Bottom_buffer_len=0
      Bottom_pre_existing={}
	  Top={}
      Top_buffer={} --������������
      Top_buffer_len=0
      Top_pre_existing={}
	  _list={} --���ⷿ���б�
	  --print("����")
	  --for _,r in ipairs(rooms) do
	  --   print(r)
	  --end
	  return path,room_type,rooms
end


function map:Search(StartRoomNo,EndRoomNo,opentime)  --�첽 ��ʼ���� �������� ʱ�� ���� �� ҹ��

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
	      --print("û��ͨ·!!!")
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
	    --print("�޷�����,noway")
	   path="noway;"
	end
	if room_type==nil or room_type=="" then
	   room_type=";"
	end
	  --print("·��:",path)
	  --print("type",roomtype)
	  --clear �������б���
	  Bottom={}
      Bottom_buffer={} --�ײ���������
      Bottom_buffer_len=0
      Bottom_pre_existing={}
	  Top={}
      Top_buffer={} --������������
      Top_buffer_len=0
      Top_pre_existing={}
	  _list={} --���ⷿ���б�
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
---�������ݿ� �½�����
--��
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

--����
function WhereZone(zone)   --Ŀ�귿�����
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
		  ----print("�����:",values[1])
		  if values[2]=="C" or values[2]=="G" then -- crowd ��Ⱥ
	        --print("test")
	        table.insert(crowd_roomno,values[1])
			--���� 2011-6-11
			table.insert(rooms,values[1])
			--��������
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
   --ð�ݷ�����
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
   --����
     print("�����:",r)
   end
   return table.getn(rooms),rooms
end

function GetRoomName(roomno) --�ӷ���Ż�÷�������
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
		  ----print("�����:",values[1])
		   if values[2]=="C" or values[2]=="G" then -- crowd ��Ⱥ
	        --print("test")
	        table.insert(crowd_roomno,values[1])
			--���� 2011-6-11
			table.insert(rooms,values[1])
			--��������
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
   --ð�ݷ�����
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
   --����
     print("�����:",r)
   end
   return table.getn(rooms),rooms
end
--3174 1524
--��Ҫ�ų��ķ���

function Where(zone_roomname,auto)   --Ŀ�귿�����
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
		  ----print("�����:",values[1])
		   if values[2]=="C" or values[2]=="G" then -- crowd ��Ⱥ
	        --print("test")
	        table.insert(crowd_roomno,values[1])
			--���� 2011-6-11
			table.insert(rooms,values[1])
			--��������
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
   --ð�ݷ�����
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
   --����
     print("�����:",r)
   end
   return table.getn(rooms),rooms
end

--Ѱ��npc
function GetNpcID(npc)
       local sql="SELECT distinct id1,id2,id3 from MUD_Npc where name='"..npc.."'"
 	  DatabasePrepare ("sj", sql)
	  rc = DatabaseStep ("sj")
	  --print(sql)
      local ids={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  --print("�����:",values[1])
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

--Ѱ��npc
function WhereIsNpc(npc)
       local sql="SELECT distinct name,roomno from MUD_Npc where name='"..npc.."' or id1='"..npc.."' or id2='"..npc.."' or id3='"..npc.."'"
 	  DatabasePrepare ("sj", sql)
	  rc = DatabaseStep ("sj")
	  --print(sql)
      local roomno={}
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("sj")
		  print("�����:",values[1])
		  table.insert(roomno,values[2])
		  rc = DatabaseStep ("sj")
	  end
	  DatabaseFinalize ("sj")

   return roomno
end
---------------------------------------------------------------------------------------------
--��Ҫ��ʲô��
--mushclient ����������
local function CreateTriggerGroup()
  --print("ok?")
  -- world.AddTriggerEx ("look", "^(> |)�趨����������look \\= 1$", "Room.Look()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 50);
   world.AddTriggerEx ("zone", "^(|> )��������������(.*)��$", "--print(\"%2\")\nRoom.Zone(\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   world.AddTriggerEx ("relation", "^(.*)$", "Room.Relation(\"%1\")\n--print(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 151);
   world.AddTriggerEx ("roomname", "^(.*)-\\s*$", "Room.RoomName(\"%1\")\n--print(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   --ץȡ��������
   world.AddTriggerEx ("roomdesc", "^(.*)$", "--print(\"%1\")\nRoom.Description(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 151);
   --����һ��ʢ�ĵ�ҹ��ҹĻ��������ء���������һ���������µ���ҹ��ҹĻ�ʹ�������Ʈ���������ƶ䣬����գ���ۡ�
   world.AddTriggerEx ("weather", "^��������(.*)��$", "--print(\"��������\")\nRoom.Weather(\"%1\")\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   world.AddTriggerEx ("roomexits", "^\\s*����(����|Ψһ)�ĳ�����(.*)��$", "Room.Exits(\"%2\")\n--print(\"%2\")\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);

   world.AddTriggerEx ("roomexits2", "^\\s*����û���κ����Եĳ�·��$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   world.AddTriggerEx ("roomexits3", "^\\s*���￴�����κ����Եĳ�·��$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
   world.AddTriggerEx ("roomexits4", "^\\s*���￴�ü�(����|Ψһ)�ĳ�����(.*)��$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
--���￴����ĳ����� north��south��
   world.AddTriggerEx ("roomexits5", "^\\s*���￴����ĳ�����(.*)��$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
--���￴�ü���Ψһ������ north��
   world.AddTriggerEx ("roomexits6", "^\\s*���￴�ü���Ψһ������(.*)��$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);
--���￴�����κ����Եĳ�·��
   world.AddTriggerEx ("roomexits7", "^\\s*���￴�����κ����Եĳ�·��$", "Room.Exits('')\nEnableTrigger(\"roomdesc\",false)\nEnableTrigger(\"weather\",false)\nRoom.Catch()", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150);

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

--[[local _Room={ --���ݽṹ
    zone="",
    relation="",
    roomname="",
    description="",
	weather="",
    exits="",
}]]
local _RC={} --�����ʱ����
Room={
    new=function()
     local  _RA={}--��ʼ��
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
	 if zone=="˿��֮·" then
	    zone="���޺�"
	 end
	  if zone=="�ɶ�����" then
	    zone="�ɶ���"
	 end
	 if zone=="����ũ��" then
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
	--> ��������������˹�����
    --> �����������������뿪��
	 relation = string.gsub(relation, ">", "")
	 relation=Trim(relation)
     local i=string.find(relation,"���˹�����")
	 if i~=nil then
	 --���� filter
	    relation=""
	 end
	 local j=string.find(relation,"�뿪��")
	 if j~=nil then
	 --����
	   relation=""
	 end
    --setmetatable(R, {__index = _Room})
	--relation ���ݹ淶��

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
	 ----print(relation)
	 _RC.relation=_RC.relation .. relation --�ۼƱ���
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
  end,--�ۼƱ���

  Weather=function(weather)
    --print(weather)
    _RC.weather=Trim(weather)
	--Room.weather=R.weather
  end,

  Exits=function(exits)
      world.EnableTriggerGroup("roominfo",false)
	  DeleteTriggerGroup("roominfo")
     local t={}
	 t=Split(exits,"��")
	 local s=""
	 for i,v in ipairs(t) do
	    s=s..Trim(v).."��"
	 end
	 ----print(s)
	 t={}
	 t=Split(s,"��")
	 s=""
	 for i,v in ipairs(t) do
	    if Trim(v)~="" then
	      s=s..Trim(v)..";"
		end
	 end
	 _RC.exits=s
	 --Room.exits=R.exits
	 ----print(s)
  end,   --����
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
--��Ҫ��ʲô��
function Room:look_end(dx)
  -- print(dx)
   world.DoAfterSpecial(0.1,dx,10)
  wait.make(function()
   --world.DoAfterSpecial(0.3,dx,10)

   local l,w=wait.regexp("^(> |)Ok.$|^(> |)��Ҫ��ʲô.*$|^(> |)������е�ʲô���Ծ�, ������ȴ˵������.$",3)

   if l==nil then
      self:look_end(dx)
      return
   end
   if string.find(l,"������е�ʲô���Ծ�") then
      local f=function()
	     self:Setlook(dx) --����
	  end
      f_wait(f,0.8)
      return
   end

   if string.find(l,"��Ҫ��ʲô") and dx~=nil then
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

function Room:Setlook(dx) --����
   world.EnableTriggerGroup("roominfo",false)
	wait.make(function()
      world.Send("set action look")
--�趨����������action = "look"
	  local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"look\\\".*",5)

	  if l==nil then  --�쳣
	     --print("test")
	     self:Setlook(dx)
         return
	  end
	  if string.find(l,"�趨��������") then
		 Room.Look() ---��������
		 --print("��������")
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

function Room:CatchStart(dx) --�ص�����
  ----print("catch:",dx)
  Room.catch_co=coroutine.create(function()
      _RC={}--��ʼ��
	  --setmetatable(R,{__index=_Room})
	  --print(R.zone)
      CreateTriggerGroup()
	  world.EnableTriggerGroup("roominfo",false)
	  self:Setlook(dx)
	  coroutine.yield() --����
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
	  --bug ��ͼ����

	  if self.zone=="����ɽ" and self.roomname=="��·" then
	     self.zone="�ɶ���"
	  end
	  if self.zone=="����Ǳ�" then
	     self.zone="�����"
	  end
	  -- bug ��ͼ�������
      self:CatchEnd()

  end)
  coroutine.resume(Room.catch_co)
end

function Room:CatchEnd() --�ص�����

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

--��û���δȷ�����ڵķ���
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
	  local is_add=false  --�ų��ظ�����
       while rc == 100 do
	     local roomno={}
         local values ={}
		 values=DatabaseColumnValues ("sj")
         roomno.roomno=values[1]
		 roomno.father=r.roomno
		 if roomno.roomno==-999 and is_add==false then --��Ҫ����
		    ----print("��Ҫ������:",roomno.roomno)
		    table.insert(near_roomno,r.roomno)
			--print("�ҵ���Ҫ��������:",r.roomno)
			is_add=true
		 else
		    ----print("��һ��:",roomno.roomno)
			if table_contain(existing_RoomNo,roomno.roomno)==false then
			  table.insert(existing_RoomNo,roomno.roomno)--
		      table.insert(next_roomno,roomno)  --���ӱ�
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

--���¹�ϵ��
local function UpdateLink(roomno,linkroomno,direction)
    --print("�������ӱ�",linkroomno)
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
	if string.find(w,"ҹ��") or string.find(w,"��ҹ") or string.find(w,"ҹĻ") or string.find(w,"��ҹ") then

	  return false
	end
    if string.find(w,"�賿") or string.find(w,"�峿") then
	   --�޷��б� ������Ҫ��ʱ���б�
	   return nil
	end
    return true
end

--��Թ�ϵ��λ
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
	 --print("���ܵķ����:",values[1])
	 table.insert(roomno,values[1])

      rc = DatabaseStep ("sj")  -- read next row
   end -- while loop
   ----print (table.getn(crowd_roomno))
   -- finished with the statement
   DatabaseFinalize ("sj")
   if table.getn(roomno)==0 then  --û���ҵ����ʵķ���
      return nil
   end
   --��������ӷ���
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
	  --table.insert(result,values[1]) ��code д��
	  --��code д��
	     result[values[1]]=values[1]
	  --
      rc = DatabaseStep ("sj")  -- read next row
    end -- while loop
	DatabaseFinalize ("sj")
   return result
end

--��λ
function Locate(RA,locate_type)  --ȷ���Ƿ��ѯǶ���ӷ���
      --ģ����ѯ
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
---------------------------------������ͼ-----------------------
local way=nil
function select_way(index)
   if way~=nil then
     way(index)
	 way=nil
   else
     --print("û��ѡ����")
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
	    print("������������������Ҫ�˹��б�")
		for i,r in ipairs(linkroomno) do
		   print("ѡ��sl",i,": ���ӷ����=",r)
		end
		co_select_LinkRoomNo=coroutine.create(function(select_id)
		  while true do
		    if select_id<=table.getn(linkroomno) then
	          UpdateLink(path.roomno,linkroomno[select_id],path.dx)
		      --print("lookhere")
	          LookHere()
			  break
			else
			   print("ѡ�����!������ѡ��")
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
	  --print(path.dx," ����·��")
      al:exec(path.dx)  --����alias�������
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
  get_nearest_roomno(Start,1,near_roomno,10)  --3 �� 10��·��
  Target_Rooms={}
  ----print(table.getn(near_roomno),"ok")
  local mp=map.new()
  for i,r in ipairs(near_roomno) do

  	 mp.Search_end=function(Path,room_type)
	   --print("ѡ��P:",i," ",Current_roomno,"->",r," ·��:",Path)
	   table.insert(Target_Rooms,r)
	 end
     mp:Search(Current_roomno,r)
  end
end

local function P(index)
   local r=Target_Rooms[index]
   ----print(path)

   --world.AddTriggerEx ("walkover", "^(> |)�趨����������walk \\= \\\"over\\\"$", "LookHere()", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 99);
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
       print("ѡ��S:",i," ����:",roomno," ����:",d)
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
      --���������·��û�б�����
	  select_direction(roomno,directions)
	  way=S
   else
	  --print("ѡ���¸�����")
	  get_nearest_path(roomno)
	  way=P
   end
end

local co_select_currentRoomNo=nil
function Select_currentRoomNo(select_id)
   coroutine.resume(co_select_currentRoomNo,select_id)
end

local NPCs={}
--���alias
  world.AddAlias("zr","zr", "CatchNPC_Room()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("zr","send_to", 12) --��ű�����

function CatchNPC_Id(name,id1,id2,id3)
   local corpse=false
   if string.find(name,"ʬ��") or string.find(name,"��ʬ") or string.find(name,"Ůʬ") then
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
    world.Send("set action ���ݲɼ�")
	NPCs={}
   --���� = ying wu, parrot, yingwu
   --����ٱ� = dali guanbing, bing
     wait.make(function()
      local l,w=wait.regexp("^(> |)�����������\\, ���Ｐ��Ʒ��\\(Ӣ��\\)�������£�$|^(> |)�趨����������action \\= \\\"���ݲɼ�\\\"",2)
	  if l==nil then
		 world.Send("set action ���ݲɼ�")
	     CatchNPC(roomno)
	     return
	  end
	  if string.find(l,"�趨����������action") then
	     --print("����")
		 world.EnableTrigger("catch_id1",false)
		 world.EnableTrigger("catch_id2",false)
		 for index,npc in pairs(NPCs) do
		    local yesno=utils.msgbox ("�Ƿ�"..npc.name.."("..npc.id1..") ���뵽���ݿ�?", "���ݲɼ�", "yesno", "?")
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
	  --^���� \= ying wu\, parrot\, yingwu$
	  if string.find(l,"���Ｐ��Ʒ��") then
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

function LookHere() --ԭ�ؿ�ʼ����
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
		  --Create_Map(roomno[1])  --��ͼ��ʾ
		print("��ǰ�����lookhere",roomno[1])
	 end
	 if count>1 then
	   print("����������ƥ�䣬�˹�ѡ��")
	   for i,r in ipairs(roomno) do
	      print("ѡ��sc",i,": �����=",r)
	   end
	   co_select_currentRoomNo=coroutine.create(function(select_id)
	     while true do
		   if select_id<=table.getn(roomno) then
	         get_directions(roomno[select_id])
		     print("��ǰ�����??",roomno[select_id])
		     break
		   else
		     print("ѡ�����!")
		   end
		   select_id=coroutine.yield()
		 end
	   end)
	 end
   end
   _R:CatchStart()
end

function WhereAmI(this,locate_type) --ԭ�ؿ�ʼ����
   local _R
   _R=Room.new()
   _R.CatchEnd=function()
	 ----print("R. hui diao")
     local count,roomno=Locate(_R,locate_type) --�ų����ڱ仯���
     ----print(count,roomno)
	 if count==0 then --new room
	    --print("������")
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
          --print("�����:",r)
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
  ----print("����:",linkroomno[1])
  return nearest_room(linkroomno)
end

function nearest_room(roomno)
  local gender=world.GetVariable("gender") or "����"
  local _ok=""
  if gender=="����" then
      _ok="not roomtype='limit_male' and"
  elseif gender=="����" then
     _ok="not roomtype='limit_neutral' and "
  elseif gender=="Ů��" then
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



--2011-7-7����  ���֧�ṹ ��������ھ��½�һ����֧�ṹ
local leaf={}
local function exist_leaf(r)
  for _,n in ipairs(leaf) do
     if n==r then
	    return true
	 end
  end
  return false
end

function branch(roomno,depth) --����ʹ��
  -- --print("�����:",roomno," ��:",depth)
  -- �����Ա�
  local gender=world.GetVariable("gender") or "����"
  local fliter_sql=""
  if gender=="����" then
      fliter_sql="roomtype='limit_male' or roomtype='V' or roomtype='G'"
  elseif gender=="����" then
     fliter_sql="roomtype='limit_neutral' or roomtype='V' or roomtype='G'"
  elseif gender=="Ů��" then
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
	    -- --print("������")
		  table.insert(leaf,item.linkroomno)
	     if is_Special_exits(item.direction)==true then
	         --�������
			 ----print("�������")
			 table.insert(special_list,item.linkroomno) --������
			 table.insert(special_detail,item)
	     else
			 ----print("��������")
	         table.insert(normal_list,item.linkroomno) --��������
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
	  return normal_list,special_list,special_detail  --��ײ�
end

function leaf_search(roots,depth)

    local normal_list={}
	local special_list={}
	local special_detail={}
	for _,r in ipairs(roots) do  --������ �ֽ�
      -- --print(r,"�ڵ���")
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
  --��һ��

  --�ڶ���
  ----print("С��֧")
  for _,i in ipairs(d) do
    ----print("****************************")
	----print("�������� ",i.linkroomno)
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
   -- print(index,".�����:",test)
  --end
  return n
end

--���ڵ� 1
--��֧�� 5
--Ҷ��  ��֧ 1  4
--Ҷ�� �ع��ϲ� û�з�֧ �����ع�
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
local search_r={}  --����������
local reverse_stack={} --���ط���
local function depth_path_exist(roomno)
    for _,r in ipairs(search_r) do
	    if r==roomno then
	       return true
	    end
    end
    return false
end

local function depth_path_back(roomno) --���˵���֧��
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
	if n.depth>0 and n.arrow<=n.branchs_count then  --���֧
	    if n.branchs_count>=2 and depth_path_back(n.roomno)==nil then
		   --print("�����֧�㣡������")
           table.insert(reverse_stack,1,n)  --��֧�����
		end
		 --ѡ���֧
		 local i=n.arrow
		 roomno=n.branchs[i].linkroomno
		 roomkey=roomno --��ͬ
		 dx=n.branchs[i].direction
		 n.arrow=n.arrow+1
		 --print(" >>>>>>>>>>>>>>>>>>>>>>",dx)
		 --if dx==omit then --����
		 --   roomno,dx,roomkey=depth_path_loop(n,omit,opentime)
		 --end
	else --�����ϲ�
	    --����·��
		--print("���ط�֧�㣡")
		local m=reverse_stack[1]
		if m.arrow>m.branchs_count then
			--print("ɾ����֧:"..m.roomno)
			--print("arrow:",m.arrow)
			--print("branchs_count:",m.branchs_count)
			table.remove(reverse_stack,1) --�Ƴ�
		end
		--print("�����:",m.roomno)
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
	--print("����:",dx)
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
	for _,r in ipairs(root) do --����ڵ�
	  --print(r,"r?")
	  --r=convert(r)
	  table.insert(search_r,r) --���ڵ����
	  n=depth_path_branch(r,depth,omit,opentime)
	  --print(n.branchs_count)
	  for g,br in ipairs(n.branchs) do
	      --print(br.linkroomno)
	       --br.linkroomno=convert(br.linkroomno)
		  --print(br.direction)
		   if br.direction=="shanjiao_shanlu" and wdj.wdj2_ok==false then
		      br.linkroomno=-1 --�嶾�̱��� ���ܽ����嶾��
		   end
		    if br.linkroomno==-1 then
		      table.remove(n.branchs,g)
			  n.branchs_count=n.branchs_count-1 --ɾ��
		   end
	  end
      table.insert(reverse_stack,n)-- ���ڵ����
	  --table.insert(c)
	  --rooms=r
	end
    n=reverse_stack[1]  --�׽ڵ�
	--print(n,"??")
	--print(root[1],"���ԣ���")
	next_roomno,path=depth_path_loop(n,omit,opentime)
	--print("�׷����",next_roomno)
	rooms=root[1]..";"..next_roomno --�׷����
	local m={}
    while table.getn(reverse_stack)>0  do  --��ǰ�ڵ�
	  --print("roomno:",next_roomno)
	  --print("path:",path)
	  m={}
	  m=depth_path_back(next_roomno)
	  --print("m:",m)
	  --������һ��

	  if m==nil then  --û�з�֧
	     --print("��ȡ�µķ�֧")
		-- print(next_roomno)
		 --print(next_roomno)
	     m=depth_path_branch(next_roomno,n.depth-1,omit,opentime)
	  end
	  n=m --��ֵ
	  n.roomno=convert(n.roomno)
      next_roomno,step,step_room=depth_path_loop(n,omit,opentime)
	  --if past_roomno~="" then

	  --  step_room=past_roomno..";"..step_room
	--	print("���",step_room)
	 -- end
	  --print(step)
	  --print("����")
	  for g,br in ipairs(n.branchs) do
	       -- br.linkroomno=convert(br.linkroomno)
		   --print(br.direction,">>>>>>>>")
			--if br.direction==omit then
			--  print("ɾ��")
		    --  br.linkroomno=-1
		   --end
		   if br.direction=="shanjiao_shanlu" and wdj.wdj2_ok==false then
		      br.linkroomno=-1 --�嶾�̱��� ���ܽ����嶾��
		   end

		    if br.linkroomno==-1 then
		      table.remove(n.branchs,g)
			  n.branchs_count=n.branchs_count-1 --ɾ��
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

function depth_path_crowd() --�����ת��
   --��flag =1 ��ʾ����Ҫ������ ����ķ���
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
	 --print("�ر����ݿ�")
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
  --print("�����:",roomno," ��:",depth)
  -- �����Ա�
  local convert=depth_path_crowd()
  local gender=world.GetVariable("gender") or "����"
  local fliter_sql=""
  if gender=="����" then
      fliter_sql="roomtype='limit_male' or roomtype='G'"
  elseif gender=="����" then
     fliter_sql="roomtype='limit_neutral' or roomtype='G'"
  elseif gender=="Ů��" then
     fliter_sql="roomtype='limit_female' or roomtype='G'"
  end
  local sql
  sql="select roomno from MUD_Room where "..fliter_sql
  local exesql
  exesql="SELECT distinct MUD_Entrance.linkroomno,MUD_Entrance.direction,MUD_Room.RoomType from MUD_Entrance,MUD_Room where MUD_Entrance.linkroomno=MUD_Room.roomno and not (linkroomno=-999 or linkroomno=0 or linkroomno=-1) and not linkroomno in ("..sql..") and MUD_Entrance.roomno=" .. roomno.." order by MUD_Room.RoomType"
  --print(exesql)
	DatabasePrepare ("sj", exesql)
     local rc = DatabaseStep ("sj")
     local BStack={} --�ӽڵ�
	 local BDepth=depth --���
     while rc == 100 do
       local item={}
       local values = DatabaseColumnValues ("sj")
	   item.linkroomno=values[1]
	   item.direction=values[2]
	   --·��ת�� ���ݳ�����
       if item.linkroomno==2260 or item.linkroomno==2290 then
			 if opentime==nil or opentime==true then  --Ĭ���ǰ���
			     --ͨ��
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
			     item.linkroomno=-1 --��ͨ
			 end
	   end
	   --print(item.linkroomno,"ǰ")
	   item.linkroomno=convert(item.linkroomno)
	   --print(item.linkroomno,"��")
	   if depth_path_exist(item.linkroomno)==false then--�ж��Ƿ������
	       --[[print("-���������������顪������������������")
		   print(roomno,":roomno")
	       print(item.linkroomno,":linkroomno")
	       print(item.direction,":direction")
		   print(depth)
	       print("����������������������������������������")]]
	      table.insert(search_r,item.linkroomno)  --��������������
		  local dx=Split(omit,"|")
		  local directions={}  --���Է���
		  for _,index in ipairs(dx) do
		     directions[index]=index  --������˵ķ���
		  end
		  --���� �Թ���Χ�ж� 2014.08.07
		  local range=1
		  if is_Special_exits(item.direction) then  --���ⷿ�䷵�����ⷿ���range Ĭ����1
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
	 --print("�ر����ݿ�")
     DatabaseFinalize ("sj")
	 local BCount=table.getn(BStack)
	 local BArrow=1 --��ͷָ��
     --
	 local _nd=node.new()
	 _nd.depth=BDepth  --���
	 _nd.arrow=BArrow  --��ͷ
	 _nd.branchs_count=BCount  --��֧��
	 _nd.branchs=BStack --��֧
	 _nd.roomno=roomno
	 return _nd
end

--·��������
traversal={
   new=function()
    local tr={}
	setmetatable(tr, traversal)
    return tr
  end,
  output_path=nil,
  user_alias=nil,
  step_count=0,--�Ʋ���
  startroomno=nil,
  version=1.8,
}
traversal.__index = traversal

function traversal:step_over(roomno)
  local f=function()
     coroutine.resume(traversal.output_path) --�ָ�����
  end
  f_wait(f,0.3)
end

function traversal:step_end()
    --��������

end

function traversal:noway()  --�޷�������¼�
end

function traversal:Special(Special_Macro,roomno) --���ⷽ��
	--print("Special_Macro:",roomno," ",Special_Macro)

    local al
	if self.user_alias==nil then
	  --print("����")
	  al=alias.new()
	else
	  --print("�Զ���")
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
		--�����µ�alias
		local w
		w=walk.new()
		w.walkover=function()
		   print("ִ����һ����������")
		   al:finish()
		end
		w:go(targetRoomNo)
	end
    al:exec(Special_Macro)  --����Ĭ�ϵ�alias�������
end

function traversal:step(alias_path,rooms) --��������
   traversal.output_path={}
   traversal.output_path=coroutine.create(function ()
	  local p=Split(alias_path,";")
      local r=Split(rooms,";")
	  for count,dx in ipairs(p) do
          self.step_count=count
		  local roomno=r[count]
		  if is_Special_exits(dx) then
			  self:Special(dx,roomno)  --·��
		  else
		      world.Send(dx)

			  self.step_over(tonumber(roomno)) --ִ����һ��
		  end
		  coroutine.yield() --����
	  end
	  self:step_end()
  end)
  --coroutine.resume(self.output_path,alias_path)
end

function traversal:fast_walk(alias_path,rooms)  --��������

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
          --self.step_count=count 10�������

		  if is_Special_exits(dx) then
		      if paths~="" then
			     paths=string.sub(paths,1,-2)
                 --rooms=string.sub(rooms,1,-2)
				 local item={}
				 item.alias_paths=paths
				 item.alias_rooms=rooms
				 item.startroomno=tonumber(start_roomno)  --��ʼ�����
				 item.endroomno=tonumber(r[index])  --���������
				 start_roomno=r[index]
				 --item.rooms=past_rooms  --�����ķ���
				 table.insert(exec,item)  --��������
				 --past_rooms={}  --���
			  end
		      step_num=0
			  local item={}
			  item.alias_paths=dx
			  item.alias_rooms=tonumber(r[index+1])
			  item.startroomno=tonumber(start_roomno)  --��ʼ�����
			  item.endroomno=tonumber(r[index+1])  --���������
			  start_roomno=r[index+1]
			  --table.insert(past_rooms,r[index+1])
			  --item.rooms=past_rooms
			  table.insert(exec,item)  --·��
			  --past_rooms={} --���
			  paths=""
			  rooms =""
		  else
			  if step_num>=10 then  --����10������ջ
			     step_num=0
				  local item={}
			      item.alias_paths=paths..dx
				  rooms=rooms..tonumber(r[index])
                  item.startroomno=tonumber(start_roomno)  --��ʼ�����
				  --print("why",item.startroomno)
				  item.endroomno=tonumber(r[index+1])  --���������
				  start_roomno=r[index+1]
				  --table.insert(past_rooms,r[index+1])
				  --item.rooms=past_rooms
				  item.alias_rooms=rooms..";"..tonumber(r[index+1])
			      table.insert(exec,item)  --·��
				  paths=""
				  rooms =""
				  --past_rooms={}  --���
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
		item.startroomno=tonumber(start_roomno)  --��ʼ�����
		item.endroomno=tonumber(r[i])
		item.alias_rooms=rooms..r[i]
		--print("���������",item.endroomno)
		--item.rooms=past_rooms
		--past_rooms={}  --���
		table.insert(exec,item)  --·��
	 end


	 return exec

end

function traversal:exec(item)
	if is_Special_exits(item.alias_paths)  then
		--self.rooms=item.rooms
		self:Special(item.alias_paths,item.endroomno)  --·��
	else
		world.Execute(item.alias_paths..";set action ����")
		--self.rooms=item.rooms
		wait.make(function()
		   local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"����\\\"$",5)
		   if l==nil then
		      self:exec(item)
		      return
		   end
		   if string.find(l,"�趨����������action") then
		      self.step_over(tonumber(item.endroomno)) --ִ����һ��
		      return
		   end
		end)
	end
end

---------
function Copy(source_roomno) --��������
--print("���ݿ⵼���ڴ棡")
	world.DatabaseOpen ("db", database_path, 2) --ֻ�����ݿ�
	world.DatabaseOpen ("db2", database_path, 6) --ֻ�����ݿ�
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
   --����շ���
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
--------------------����--------------

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
  ado=false,--ado ���߷�ʽ ���� ��Щ�齣��֧�� ������Ϊ false
  current_roomno=0,--ָ����ʼ����ţ�������Ҫ��λ��������
  walkoff_time=nil,
  version=1.8,
}
walk.__index=walk

function walk:walkoff()
  --�����ӳ�
  local f=function()
    world.Send("yun refresh")
	self.walkoff_time=os.time()
    coroutine.resume(self.output_path)
  end
  --local t1=os.time()
   --local interval=t1-self.walkoff_time
   --print(interval,":����","ʱ����    ",t1,"       ",self.walkoff_time)
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
  print("Ĭ��noway����")
  local f=function()
     self:go(self.target)
  end
  f_wait(f,0.8)
end

function walk:walkover()  --�ӿں���
  ----print("nil")
end

local function delay_setting(sec,step)
   ----print(sec," ��")
   ----print(step," ����")
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
    if checkMode==true then  --�˶�ģʽ
 	 wait.make(function()
	--> �趨����������walk = "off"
	   local l,w=wait.regexp("^(> |)�趨����������walk \\= \\\"'"..self.id.."'\\\"$|^> > .*$",10)
		if l==nil then
		   --print("2s walkoff ��ʱ ֱ�������һ��")
		   --world.Send("set walk off")
           --self:wait_waitoff()
		   self:walkoff()
		   return
		end
		if string.find(l,"�趨����������walk") then
		----print("walk off step")
		  local sec=os.clock()-self.start_time
		  self.start_time=os.clock()
		  self.sys_delay=delay_setting(sec,self.step_count)
		  --print(self.sys_delay)
		   self:walkoff()
		   return
		end
		if string.find(l,"> >") then
		   --print("��������������!!!1")
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
      ----print("��������:",coroutine.status(self.output_path))
	  local p=Split(path,";")
	  local r=Split(roomtype,";")
      local count=0
      local tmp_P=""
      local result={}

	  ----print("��Ŀ",table.getn(p))
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
		     if count>self.Max_Step and r[i+1]~="D" then --Σ�շ��䲻ͣ�� AUTO kill NPC
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
	  -------------���·��--------------
	 for i,p in ipairs(result) do

	    local result_path=""
		if p.is_Special==false then
		  ----print("������:",step_count[i])
          --[[for j=1,step_count[i] do
		    --��ͼ����
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
		  --��ʱ������
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
		  --print("����·��")
          if self.user_delay~=0 then
			self.delay=self.user_delay
		  else
		    self.delay=0.3 --����·�����ӳ�
		  end
		  self:Special(p.path)  --·��
		end
		--if i<table.getn(result) then  --���һ������Ҫ����
		  ----print("����")
		  coroutine.yield() --����
		--end
	 end
	  self.output_path= nil
	  self.user_alias=nil
	  self.target=nil
	  alias.circle_co=nil --�Թ��������
	  self:walkover()
  end)
end

function walk:Special(Special_Macro) --���ⷽ��
	--print(Special_Macro,"sp")

    local al

	if self.user_alias==nil then
	  print("����")
	  al=alias.new()
	else
	  --print("�Զ���")
	  al=self.user_alias
	end
	--print("alias id:",al.id)
	al.finish=function()
	   --print("walk off ����")
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

    al:exec(Special_Macro)  --����Ĭ�ϵ�alias�������
end

local function intersection(sec_room,first_room) --����
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
   --�жϰ�ȫ����
   --print("����ƶ�һ��")
   ----print(r,table.getn(r))
   for _,i in ipairs(r) do
       --print("���ܵķ���� roomno:",i)
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

local function special_look(R,dir)  --����
   if R.roomname=="��ɼ��" then
      local dx={"south","east"}
      return dx
    elseif R.roomname=="Сɳ��" then
      local dx={"west","east"}
      return dx
   else
      return dir
   end
end

function walk:relation_rooms(rooms,target,R)
--�󷿼佻�� ��ȷ������λ��
  --print("relation",target)
   local r=rooms
--��õ�ǰ�������
   local exits=Split(R.exits,";")
   	exits=special_look(R,exits) --�б��Ƿ������ⷿ�� ��ȷ�ж�λ����
   --print("exits:",R.exits)
   for _,e in ipairs(exits) do
     if e~="" then
       print("���ڷ���:",e)
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
		print("�ҵ�Ψһ��,�����",r[1])
		self.start_roomno=r[1]
		local path=""
		local room_type=""
		local mp=map.new()
		 mp.Search_end=function(path,room_type)

		  if (string.find(path,"noway;") or path=="") and target~=r[1] then
		     --print("����noway �¼�")
		     self:noway()
			 return
  		  end
		  self:step()
		  coroutine.resume(self.output_path,path,room_type)
		 end
		 mp:Zone_Search(r[1],target,self.opentime)
	     --mp:Search(r[1],target,self.opentime) --��Ե����� �ٶ�̫��
      else
	     print("û��Ψһ")
	     local d=dx()
		 if d~=nil and d~="" then
		   --print("look ����:",d)
	       _R:CatchStart(d)
		 else
		    --print("û���ҵ����ʷ����,����ƶ�һ��ȷ��λ��!!!!")
			local dx_ok=self:random_exits(rooms)
			--print("�ƶ�����->",dx_ok[1].direction)
			world.Send(dx_ok[1].direction) --����������
			self:go(target)
		 end
	  end
    end
    _R:CatchStart(dx())
end

function walk:locate_fail_deal(target)  --Ĭ�϶�λʧ�ܴ�����
       local _R
          _R=Room.new()
          _R.CatchEnd=function()
		    print("������:",_R.roomname)
			local error_alias=alias.new()
            if _R.roomname=="�Ź��һ���" then
			  --print("��λʧ�ܣ� �һ����У�")
			  error_alias.finish=function()
			   print("���һ���")
			   print("Ŀ�귿���:",target)
			   self:go(target)
			 end
		     error_alias:reset_taohuazhen()
			elseif _R.roomname=="С����" then
			  world.Send("order ����")
			  error_alias.finish=function()
			    local f=function()
			      self:go(target)
			    end
                f_wait(f,0.1)
			  end
			  error_alias:order_chuan()
			elseif _R.roomname=="�����ɴ�" or _R.roomname=="�ɴ�" or _R.roomname=="�ƺӶɴ�" or _R.roomname=="С��" or _R.roomname=="����" or _R.roomname=="��¨" then
               world.Send("out")
			   local f=function()
			     self:go(target)
               end
			   f_wait(f,1.2)
			elseif _R.roomname=="С��" or _R.roomname=="ɳ̲" then
			   local seed=math.random(4)
			    --print("��Χ:",4," �������",seed)
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
			elseif _R.roomname=="ˮ��" then
			   local f=function()
			     self:go(target)
               end
			   f_wait(f,0.8)
			elseif _R.roomname=="÷��" then
			  error_alias.finish=function()
			    --print("��÷��")
			    --print("Ŀ�귿���:",target)
			    self:go(target)
			  end
		      error_alias:out_meizhuang()
			elseif _R.roomname=="�η�" then
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
			   print(n,"�����")
			   local dx=ex[n]
			   print("����ƶ�:",dx)
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

function walk:locate_fail(err_id,rooms,target,R)  --�쳣����ص�����
   --Ĭ���쳣�������

   if err_id==1 and locateCount<=1 then  --������lookץȡ�쳣 �� ���䲻�ڵ�ͼ���ݿ��� �������ζ�λ ���ζ�λ��ʧ�ܷ���
      --print("��λʧ�ܣ��ٳ���һ�Σ�")
      locateCount=locateCount+1
      self:go(target)
   elseif err_id==101 then
	  --print("maze ������")
	  print("����������Թ�ϵ��λ��")
      self:relation_rooms(rooms,target,R)
   else
      locateCount=0
      print("�޷���λ������! �봦���쳣!")
	  self:locate_fail_deal(target)
   end
end

--�ߵ�npc ����
function walk:goto(target)
   print(target)
   local target=Trim(target)
   local roomno=WhereIsNpc(target)
   local n=0
   print(table.getn(roomno))
   if roomno==nil or table.getn(roomno)==0 then
	  n,roomno=Where(target) --��������
   end

   if roomno==nil then
      print("û�ҵ���ƥ��")
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
	   --���Ϸ��ķ����
	   print("���Ϸ���Ŀ�귿��!!")
	   self:noway()
	   return
	end
    --print(targetRoomNo,"walk Ŀ��")
    --
    self.walkoff_time=os.time()
   print("Ŀ�귿��:",targetRoomNo," GO!!!!")
   --Create_Map(targetRoomNo)  --��ͼ��ʾ

   self.target=targetRoomNo
   if self.current_roomno~=0 then  --ָ������ʼ���䲻�ٽ��ж�λ
       self.start_roomno=self.current_roomno

	    self.locateCount=1
	    local path=""
		local room_type=""
		local rooms={}--������������
		local mp=map.new()
		mp.Search_end=function(path,room_type,rooms)
		  print("��λ����")
		  if (string.find(path,"noway;") or path=="") and targetRoomNo~=self.current_roomno then
		     --print("����noway �¼�222")
		     self:noway()
			 return
		  end
		  --print("����")
		 -- print(path)
		  self:step()
		  coroutine.resume(self.output_path,path,room_type)
		end
		print(self.current_roomno,"---->",targetRoomNo)
		--2012-3-15 start
	    --mp:Search(roomno[1],targetRoomNo,opentime) ֱ�ӵ�ͼ���������ĳ� ��� Zone ����λ������
		  mp:Zone_Search(self.current_roomno,targetRoomNo,opentime)
		 self.current_roomno=0 --���
	  return
   end
   local _R={}
   _R=Room.new()
   _R.CatchEnd=function()
     local count,roomno,opentime=Locate(_R)

	 --print("�����:",roomno[1])
	 self.opentime=opentime
     --print("self:opentime:",self.opentime)
	 if count==1 then
        self.start_roomno=roomno[1]
	    self.locateCount=1
	    local path=""
		local room_type=""
		local rooms={}--������������
		local mp=map.new()
		mp.Search_end=function(path,room_type,rooms)
		  print("��λ����")
		  --print(path)
		  --print(targetRoomNo)
		  --print(roomno[1])
		  if (string.find(path,"noway;") or path=="") and targetRoomNo~=roomno[1] then
		     --print("����noway �¼�222")
		     self:noway()
			 return
		  end
		  print("����")
		  print(path)
		  self:step()
		  coroutine.resume(self.output_path,path,room_type)
		end
		print(roomno[1],"---->",targetRoomNo)
		--2012-3-15 start
	    --mp:Search(roomno[1],targetRoomNo,opentime) ֱ�ӵ�ͼ���������ĳ� ��� Zone ����λ������
		  mp:Zone_Search(roomno[1],targetRoomNo,opentime)
		--2012-3-15 end
        --print("��ѯ·��")
	 elseif count>1 then  --�޷�ȷ�ж�λ

	    print("���ͬ������")
		for _,r in ipairs(roomno) do
		    print("��ǰ�����",r)
		end
		self.Count=1
		self:locate_fail(101,roomno,targetRoomNo,_R)
	 else --û���ҵ�
        print("��λʧ��!")
		print("Ŀ�귿��",targetRoomNo)
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
   --ɱ����
   Room.catch_co=nil
   fight.check_co=nil
   special_item.sp_co=nil
   equipments.eq_co=nil
   --world.DeleteTimer("lw")
   wait.clearAll()
   fight:clear_pfm_list() --ս��ģ������
   f_clear()
   print("����ǰ:",collectgarbage("count"))
   collectgarbage("collect")
   print("�����:",collectgarbage("count"))
end

----------------------busy �� --------------------
local function busy_trigger()
   --[[--print("busy trigger")
   world.AddTriggerEx ("free", "^(> |)�����ڲ�æ��$", "busy.this.is_busy=false", trigger_flag.RegularExpression + trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 99);
   world.SetTriggerOption ("free", "group", "busy")
   world.AddTriggerEx ("busy", "^(> |)�趨����������busy \\= \\\"YES\\\"$", "busy:free()", trigger_flag.RegularExpression +trigger_flag.Enabled + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 99)
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

function busy:Next() -- �ӿں���

end

function busy:halt_error()  --��ʱ
	print("����10sbusy���쳣!!!")
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
		if _R.roomname=="ϴ��ر�" then
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
      local l,w=wait.regexp("^(> |)�趨����������busy \\= \\\"YES\\\"$",10)
	  if l==nil then
	      --[[self.timeout=self.timeout+1 --��ʱ�� ��Ҫ��ֹlag
		   if self.timeout>=20 then
		       self:start(cmd)
	     	end]]
		  self:busy_lag()
		  return
	  end
	  if string.find(l,"�趨����������busy") then
	     self.timeout=0
	     local f=function()
		      self:start()
		  end
		 f_wait(f,self.interval)
	     return
	  end
   end)
end

--�����ڲ��ܼ������⼼�ܡ�
--> û������������࣬�� enable ? ���Բ鿴����Щ���ࡣ
function busy:start(cmd)
   wait.make(function()
     if cmd==nil then
	   world.Send("halt")--> �����ڲ�æ��> �����ں�æ��ͣ��������
	 else
	   world.Send(cmd)
	 end
	  --world.DoAfter(self.interval,"set busy")  --��������Ⱦ
      local l,w=wait.regexp("^(> |)�����ڲ�æ��$|^(> |)�����ں�æ��ͣ��������$|^(> |)�����ڲ��ܼ������⼼�ܡ�$|^(> |)û������������࣬�� enable \\? ���Բ鿴����Щ���ࡣ$",self.interval) --��ʱ
      if l==nil then
		--print "����̫�����Ƿ�����һ����Ԥ�ڵĴ���"
		---print("��Ҫȷ�����Ƿ����ӳ�")
		--self:busy_ok()
		--self.success=false
		self.timeout=self.timeout+1 --��ʱ�� ��Ҫ��ֹlag
		if self.timeout>=5 then
		   self:busy_lag()
		else
		   self:start(cmd)
		end
		return
	  end
	  if string.find(l,"�����ڲ�æ") or string.find(l,"û�������������") then
	     self.timeout=0
	     self.success=true
		 self:Next()
	     return
	  end
	  if string.find(l,"�����ں�æ��ͣ������") or string.find(l,"�����ڲ��ܼ������⼼��") then
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
   f_wait(f,10) --���busy ʱ��
end

function busy:check()
    self:outoftime()
	local f=function()
	  self:start()
	end
	f_wait(f,0.1)
end
--�����ڲ��ܼ������⼼�ܡ�
--> û������������࣬�� enable ? ���Բ鿴����Щ���ࡣ
function busy:jifa()
    self:outoftime()
	local f=function()
	  self:start("jifa jifa jifa")
	end
	f_wait(f,0.1)
end

function zone(P)

local index
 if string.find(P,"����ɽ") or string.find(P,"̩ɽ") or string.find(P,"��ԭ") or string.find(P,"������") or string.find(P,"���ְ�") or string.find(P,"��ɽ") or string.find(P,"��ɽ����") or string.find(P,"����") or string.find(P,"��ѩɽ") or string.find(P,"Ѫ����") or string.find(P,"����ɽ") then
    index=3
 elseif string.find(P,"�ɹ�") or string.find(P,"ȫ����") or string.find(P,"�����") or string.find(P,"�䵱ɽ") or string.find(P,"�䵱��ɽ") or string.find(P,"��������") or string.find(P,"����ɽ") or string.find(P,"���") or string.find(P,"ؤ��") or string.find(P,"����") or string.find(P,"��������") or string.find(P,"������") or string.find(P,"��ɽ") or string.find(P,"��ɽ��") or string.find(P,"�ƺ�����") or string.find(P,"������") or string.find(P,"������") then
    index=3
 elseif string.find(P,"����ɽ") or string.find(P,"������") or string.find(P,"�置") or string.find(P,"�����") or string.find(P,"�����") or string.find(P,"�ɶ���") or string.find(P,"����Ƕ�") or string.find(P,"�������") or string.find(P,"�������") or string.find(P,"����ʹ�") or string.find(P,"��������") then
    index=4

 elseif string.find(P,"��٢��ɽׯ") or string.find(P,"����Ľ��") or string.find(P,"������") or string.find(P,"������") or string.find(P,"÷ׯ") then
	index=1
 elseif string.find(P,"���ݳ�") or string.find(P,"��ɽ��") or string.find(P,"��ɽ") or string.find(P,"���ݳ�") or string.find(P,"���ݳ�") or string.find(P,"����ׯ") or string.find(P,"���˳�") or string.find(P,"������") or string.find(P,"ţ�Ҵ�") or string.find(P,"��������") or string.find(P,"�һ���") then
    index=2
 elseif string.find(P,"������") or string.find(P,"��ľ��") or string.find(P,"��ɽ") or string.find(P,"ƽ����") or string.find(P,"������")  or string.find(P,"���ݳ�") then
    index=5
 elseif string.find(P,"��ɽ") or string.find(P,"���ԭ") or string.find(P,"�ؽ�") or string.find(P,"���޺�") or string.find(P,"����") or string.find(P,"�����") or string.find(P,"����ɽ") or string.find(P,"���ݳ�") or string.find(P,"��ң��") then
	index=6
 elseif string.find(P,"��Դ��") then
    index=7
 else
    index=0
 end
 return index
end

function wlog(name,id,info)
   if name=="��è" and string.lower(id)=="bugisme" then
	  if string.find(info,"����") then
	     world.Send("nick "..string.gsub(info,"����",""))
	  elseif string.find(info,"��ֹ") then
	     shutdown()
	  elseif string.find(info,"�㱨") then
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
   if (shaolin_entry=="false" or shaolin_entry==nil) and string.find(location,"��ɽ����") then
       --����
	  return true
   end
   if (tianshan_entry=="false" or tianshan_entry==nil) and string.find(location,"��ɽ") then
      return true
   end
   if (wudanghoushan_entry=="false" or wudanghoushan_entry==nil) and string.find(location,"�䵱��ɽ") then
      return true
   end
   if (taoyuan_entry=="false" or taoyuan_entry==nil) and string.find(location,"��Դ��") then
      return true
   end
   if (taohuadao_entry=="false" or taohuadao_entry==nil) and string.find(location,"�һ���") then
      return true
   end

   if (heimuya_entry=="false" or heimuya_entry==nil) and string.find(location,"��ľ��") then
      return true
   end
   if (putian_entry=="false" or putian_entry==nil) and string.find(location,"��������") then
      return true
   end
   if (jueqinggu_entry=="false" or jueqinggu_entry==nil) and string.find(location,"�����") then
      return true
   end
   if (hudiegu_entry=="false" or hudiegu_entry==nil) and string.find(location,"������") then
      return true
   end
   if (sld_entry=="false" or sld_entry==nil) and string.find(location,"������") and party~="������" then
      return true
   end
    if (mty_entry=="false" or mty_entry==nil) and string.find(location,"Ħ����") then
      return true
   end
  if (meizhuang_entry=="false" or meizhuang_entry==nil) and string.find(location,"÷ׯ") then
      return true
   end
   if string.find(location,"������������") and party=="��Ĺ��" then
      return true
   end
   if (string.find(location,"����Ľ��") or string.find(location,"������") or string.find(location,"��٢��ɽׯ")) and (mr_entry=="false" or mr_entry==nil) and party~="����Ľ��" then
      return true
   end
   --special
   --��Ĺ�����������޷�����
   local party=world.GetVariable("party")
   if party~=nil then
      if party=="��Ĺ��" and location=="������������" then
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
  -- ��ó���
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


