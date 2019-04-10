--�����ͱ���
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
��������ʦ�����йء�job������Ϣ��
����ʦ��������������ͷ��
����ʦ����Ķ�������˵��������Ұѱ����͸��ָ�������̩ɽ����ׯ��Χ��Բ����֮�ڡ�
��������һ�Ѹոմ���õĶ��Ʊ���������ʦ����Ķ�������˵��������Ұѱ����͸�����ɽ��Զ�ŵĹٱ���
����ʦ˵�������úøɻ�Ҳ��������ġ���]]
  local w=walk.new()
  w.walkover=function()
    world.Send("ask shi about job")

  wait.make(function()
     local l,w=wait.regexp("^(> |)����ʦ����Ķ�������˵��������Ұѱ����͸�(.*)��.*��(.*)��Χ��Բ(.*)��֮�ڡ�$|^(> |)����ʦ����Ķ�������˵��������Ұѱ����͸�(.*)��(.*)��$",5)
	 if l==nil then
        self:ask_job()
	    return
	 end
	 if string.find(l,"��Χ��Բ") then
	   local npc=w[2]
		local place=w[3]
		local depth=w[4]
		print(npc,place,depth)
		depth=ChineseNum(depth)
		self:song(place,depth,npc)
	    return
	 end
	 if string.find(l,"����ʦ����Ķ�������˵��") then
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
    world.Send("ask shi about ����")
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
	  print("���ֵص�:",self.look_customer_place)
	  --world.DeleteVariable("beauty_place")
	  return
    end
	wait.time(5)
  end)
end

function songjian:Search(paths,rooms,npc)
    self.round=1
	--world.AppendToNotepad (WorldName().."_�䵱����:",os.date()..": ��ʼ����\r\n")

    self.is_checkPlace=true
	self:customer_exist()
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
	   self:giveup()
	end
	al.maze_done=function()
	   print("wudang ִ�������Թ�")
	   self:checkRobber(self.robber_name,al.maze_step)
	end
	al.nanmen_chengzhongxin=function()
		if self.look_robber==true then --·�Ͼ���
		     self.section=1 --·��
		     self.look_robber=false--ֻ���һ��
			 print("·�Ͼ���")
			 self:Check_Point_Robber()--��� ������ �ص�section��ʼ����
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
	 w.noway=function()
		self:giveup()
	end
	w.user_alias=al
	w.walkover=function()
	    ---ִ��ǰ �� check roomno
	    self.section=1 --·��
		self.rooms={}
		self.exist_rooms={}
		local ex_rooms={}
        ex_rooms=Split(self.sections[1].alias_rooms,";")
       for _,g in ipairs(ex_rooms) do
		   if g~=nil then
		      --print("���뷿���:",g)
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
	w:go(tr.startroomno)	--�ߵ���ʼ����
end

function songjian:Check_Point_NPC()
 --�ɴ�
	 local target_room={}

      --print("��������:",look_robber_place)
	  --self.look_robber_place=look_robber_place
	  --self.location=location
	 local zz=""
	 local zone=partition(self.location)

	  print("��������:",self.look_customer_place)
	 --local zone=partition(location)
	 for _,z in pairs(zone) do
	     print(z.zone)
	    if Trim(z.zone)~="" then
		   zz=z.zone
		   break
		end
	 end
	 print("check ����:",zz..Trim(self.look_customer_place))
	  local n,e=Where(zz..Trim(self.look_customer_place)) --��ⷿ����
      if table.getn(e)==0 then
	     n,e=Where(Trim(self.look_customer_place)) --��ⷿ����
	  end
	  for _,r in ipairs(e) do
		  print("���ݷ����1:",r)
	      table.insert(target_room,tonumber(r))
	  end
       print("�ӽ���")
      if self.section==nil then
	     self.section=1
	  end
	   if self.section>1 then
	       self.section=self.section-1 --����һ��
		else
		   self.section=table.getn(self.sections)
	    end
	    print("�����̻���һ��:",self.section)

	   self:check_next_point(target_room)
end

function songjian:Child_NextPoint()
   print("�ӽ��ָ̻�")
   coroutine.resume(songjian.co2)
end

function songjian:check_next_point(target_room)
      songjian.co2=coroutine.create(function()
		 -- �ص���������ȥ
             self:Child_Search(target_room,self.customer)

		   print("�ص���������ȥ!")
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
       print("Ѳ�����һ��")
	   print(self.round," ����")
	   if self.round>3 then
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
		 self:checkPlace(aim_roomno,r)
	end
	WhereAmI(f,10000) --�ų����ڱ仯
end

function songjian:checkNPC(npc,CallBack)

  wait.make(function()
      world.Execute("look;set action 1")
	 -- self:look()
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������action \\= 1$",6)
	  if l==nil then
		self:checkNPC(npc,CallBack)
		return
	  end
	  if string.find(l,"�趨����������action") then
	       print("check NPC")
	       if self.look_customer==true then --·�Ͼ���

		     self.look_customer=false--ֻ���һ��
			 print("·�Ͼ���")
			 self:Check_Point_NPC()--��� ������ �ص�section��ʼ����

		   else
             if CallBack==nil then
			   self:check_section()
			 else
			   print("�Թ�")
			   CallBack()
			 end
			  --
		   end
		  return
	  end

	  if string.find(l,npc) then
	     --�ҵ�
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
  print("���ָ̻�")
   coroutine.resume(songjian.co)
end
function songjian:give(id)
   world.Send("song "..id)
   wait.make(function()
     local l,w=wait.regexp("^(> |)��Ѹոմ���õĶ��Ʊ����͸�.*��$",5)
	 if l==nil then
	    self:give(id)
	    return
	 end
	 if string.find(l,"��Ѹոմ���õĶ��Ʊ���") then
	    self:reward()

	    return
	 end
   end)
  --��Ѹոմ���õĶ��Ʊ����͸���ͯ��
end

function songjian:c_paths(e,depth,omit,opentime)
  local paths,rooms=depth_path_search(e,depth,omit,opentime)  --����·�� �����
  --print(paths)
  --print(rooms)
   print("��Ҫ��������")
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
	           task_name="�ͽ�����",
	           task_stepname="Ѱ�ҿͻ�",
	           task_step=1,
	           task_maxsteps=3,
	           task_location=location.." ��Բ:"..depth,
	           task_description="Ѱ��"..npc,
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
       print("�����ڸ÷��䣡��")
       self:giveup()
       return
   end
    local party=world.GetVariable("party") or ""
	local mastername=world.GetVariable("mastername") or ""
   local omit=""
   if string.find(location,"������") or string.find(location,"��ɽ��") then
        --fengyun��longhu��north �� tiandi
      omit="fengyun|longhu|tiandi|xiaoxi_dufengling|huigong|dujiang"
   end
   if string.find(location,"�����") then
      omit="dufengling_xiaoxi"
   end
   if string.find(location,"��ɽ����") then
      omit="duanyaping_yading|qingyunpin_fumoquan|duhe"
   end
   if string.find(location,"��ɽ") then
      omit="baizhangjian_xianchoumen|xianchoumen_baizhangjian|t_leave|R3108|shanjian_longtan"
   end
   if string.find(location,"��ɽ��") then
      omit="dujiang"
   end
   if string.find(location,"������") then
      omit="shatan_shenlongdao"
   end
   if string.find(location,"������") then
      omit="shenlongdao_shatan"
   end
   if string.find(location,"����ɽ") then
      omit="houshanxiaolu_guanmucong|R1712"
   end
   if string.find(location,"���ݳ�") then
      omit="duhe|shamo_qingcheng|climb_shanlu"
   end
  if string.find(location,"���ݳ�") then
      omit="dujiang|beimenbingying_jianyu|yamendating_yamenzhengting|bingyingdamen_bingying|ll_sl"
   end
   if string.find(location,"������") then
      omit="haibing_taohuadao"
   end
   if string.find(location,"�䵱ɽ") then
     --if party=="�䵱��" and mastername=="������" then
       omit="xiaojing2_xiaojing1|xiaojing2_yuanmen|yitiantulong|dujiang|holdteng|zuanshulin|dujiang|holdteng"
	 --else
       --omit="yitiantulong|dujiang|holdteng"
     --end
   end
   if string.find(location,"��ɽ") then
      omit="duhe"
   end
   if string.find(location,"����ɽ") then
     omit="zoulang_shufang|movebei"
   end
   if string.find(location,"���޺�") then
     omit="zuan|push_door|zhenyelin|chengzhongxin_nanmen|nanmen_chengzhongxin|dacaoyuan_yingmen|shamo_caoyuanbianyuan"
   end
   if string.find(location,"���ݳ�") then
      omit="swim"
   end
   if string.find(location,"������") then
      omit="dangtianmen_xiuxishi"
   end
   if string.find(location,"�ɶ���") then
      omit="shamo_qingcheng|xiaoxi_dufengling|dufengling_xiaoxi"
   end
   if string.find(location,"������") or string.find(location,"ţ�Ҵ�") then
      omit="haibing_taohuadao"
   end
   --
   if string.find(location,"��٢��ɽׯ") or string.find(location,"����Ľ��") or string.find(location,"������") then
      omit="xiaodaobian_matou|quyanziwu|tanqin|qumr|yellboat|zuan_didao|didao|jump liang|yanziwu|push_qiaolan|shanzhuang|xiaodao"
   end
   if string.find(location,"����") then
     omit="zishanlin_ruijin|tiandifenglei_feng|tiandifenglei_di|tiandifenglei_tian|tiandifenglei_lei|west_zishanlin_tiandifenglei_quick|east_zishanlin_tiandifenglei_quick" --zishanlin_search|
     if Trim(location)=="��������" then
        table.sort(e,function(a,b) return a>b end) --��������
		depth=5
	 elseif Trim(location)=="���̹㳡" then
	    omit=omit.."|zishanlin_zishanlin2_quick"
     end
  end
   if string.find(location,"��ң��") then
      omit="push_door|shamo_caoyuanbianyuan|shamo_sichouzhilu|xingxiuhai_north|nanmen_chengzhongxin|R2064|R1965|R3875"
	  if string.find(location,"��ң���ּ�С��") then
          e={4238}

	  end
   end
   if string.find(location,"������") then
      omit="changjie_changjie|caidi_cunzhongxin|changjie_nandajie|R651"

   end
   if string.find(location,"�ƺ�����") then
      omit="xiaofudamen_xiaofudating|duhe"
	 if string.find(location,"�ƺ�����ƺӰ���") then
	    e={742,760,761,762,763,764,765}

     end
	 depth=8
   end
   if string.find(location,"ؤ��") then
      omit="dujiang|beimenbingying_jianyu|yamendating_yamenzhengting"
	  e={1001}
   end

   if string.find(location,"�䵱��ɽ") then
      omit="jump_river|pa ya"
   end
   if string.find(location,"���ݳ�") then
      omit="dujiang"
   end

   if string.find(location,"���ݳ�") then
      omit="enter_meizhuang|yamendating_yamenzhengting|bingyingdamen_bingying"
	  if string.find(location,"ɽ·") then
	    omit=omit.."|changlang_huanglongdong"
	  end
   end
   if string.find(location,"�����") then
      omit="yuren"
   end
   if string.find(location,"�����") then
       omit="zhenyelin|shamo_sichouzhilu|shamo_caoyuanbianyuan|R2064|R2049"
   end
   if string.find(location,"�置") then
      --if wdj.wdj2_ok==false or wdj.wdj2_ok==nil then

	     if string.find(location,"�置ɽ·") then
		    if wdj.wdj2_ok==true then
	          n=8
		      e={3157,3187,3196,3197,3198,3199,3200,3202}
		    else
			   self:giveup() --�嶾�̲�����ֱ�ӷ���
			   return
			end
		 end
	      omit="shanjiao_shanlu"
	  --end
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
   if string.find(location,"��������") then
      omit="knockgatesouth|opengatenorth"
   end
	if string.find(location,"��ɽ") then

      omit="shiguoya_shiguoyadongkou|siguoya_jiashanbi"
   end
   local sindex,eindex=string.find(location,"���ԭ")
   if sindex==1 then
      e={2438}
   end
   if string.find(location,"�ؽ�") then
      omit="caoyuanbianyuan_heishiweizi|dacaoyuan_yingmen|zhenyelin|nanmen_chengzhongxin|R2049|R1965|R4994|caoyuanbianyuan_heishiweizi"
   end
   if string.find(location,"��ľ��") then
      omit="yading_riyuepin|riyuepin_yading"
   end
   if string.find(location,"����ׯ") then
      omit="hubinxiaolu_hubinxiaolu|hubinxiaolu_guiyunzhuang|east_taohuazhen"
   end
   if string.find(location,"�䵱ɽ") then
     omit="xiaojing_xiaojing1|xiaojing2_xiaojing1"
   end
   --print("omit:",omit)
  -- self:c_paths(e,depth,omit,true)
   if string.find(location,"ƽ����") then
      omit="duhe|dutan"
   end
   self:c_paths(e,depth,omit,true) --�̶���Χ
end

function songjian:checkPlace(roomno,here,is_omit)
       print("��ʼ����:",roomno)

      if is_contain(roomno,here) or is_omit==true then
	       print("ȷ�����������->Next Room")
		   --self.is_checkPlace=false
		   self.check_place_count=0
		   local b
		   b=busy.new()
		   b.interval=0.3
		   b.Next=function()
		      print("ִ��")
		      local i=self.section
			  local s=self.sections[i]
		      local tr=traversal.new()

			 --self.rooms={}
			  local ex_rooms={}
               ex_rooms=Split(self.sections[i].alias_rooms,";")
             for _,g in ipairs(ex_rooms) do
		       if g~=nil then
			     print("���뷿���:",g)
				 if self.exist_rooms[g]==true then
				   print("�Ѿ��������",g)
				 else
                   table.insert(self.rooms,g)
				 end
	           end
             end

			  local al=alias.new()
			  al:SetSearchRooms(self.rooms)
			  al.break_in_failure=function()
			      print("�޷�����,����·��")
			      self.section=self.section+1 --����
				  self:checkRobber(self.robber_name)
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
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==109 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("�޷�����,����·��")
						self.section=self.section+1 --����
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
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==111 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("�޷�����,����·��")
						self.section=self.section+1 --����
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
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==2349 then
					   table.insert(self.rooms,2349)
					    self.exist_rooms[2349]=true
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("�޷�����,����·��")
						self.section=self.section+1 --����
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
			      print("����·��")
			      self.section=self.section+1 --����
				  self:checkNPC(self.customer)
			  end
			 --[[ al.circle_done=function()
		         print("����")
		         local f2=function()
				    coroutine.resume(alias.circle_co)
			     end
			     self:checkRobber(self.robber_name,f2)
		      end]]
			  ---
		    al.songlin_check=function()
			  print("�Թ�check npc")
	          local f2=function() al:NextPoint() end
			  self:checkNPC(self.customer,f2)
			end
			al.maze_done=function()
			   print("�Թ�check npc")
			   local f2=function() al.maze_step() end
			   self:checkNPC(self.customer,f2)
			end
			--[[al.zishanlin_check=function()
			   print("��ɼ·check")
	          local f2=function() al:NextPoint() end
			  self:checkRobber(self.robber_name,f2)
		    end
			al.zishanlin2_check=function()
			   --print("������")
			   print("��ɼ·2check")
	          local f2=function() al:zishanlin_tiandifenglei() end
			  self:checkRobber(self.robber_name,f2)
		    end]]
			  ---
			  tr.user_alias=al

			  tr.step_over=function()
			     --���ǿ��
				 print("���NPC")
			     self:checkNPC(self.customer)
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
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==109 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("�޷�����,����·��")
						--self.section=self.section+1 --����
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
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==111 then
	                   al:finish()
	               elseif roomno[1]==108 then
						print("�޷�����,����·��")
						--self.section=self.section+1 --����
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
	               print("��ǰ�����",roomno[1])
	               if roomno[1]==2349 then
	                   al:finish()
	               elseif roomno[1]==1972 then
						print("�޷�����,����·��")
						--self.section=self.section+1 --����
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
