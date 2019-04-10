
wdj={
  new=function()
	 local _wdj={}
	 setmetatable(_wdj,wdj)
	 return _wdj
  end,
  wdj1_ok=false,--�Ƿ��ܹ���Ӯ����
  wdj1_do=false,
  wdj2_ok=false,
  wdj3_ok=false,
}
wdj.__index=wdj
function wdj:start()
   if wdj.wdj1_ok==true then  --�Ѿ��ж�����
       if wdj.wdj2_ok==false then
         self:get_dan()
	   elseif wdj.wdj2_ok==true and wdj.wdj3_ok==false then
	     self:check_poison()
	   else
	       self:finish()
	   end
   elseif wdj.wdj1_do==true then
        self:finish()
   else
        self:guard()
   end
end

function wdj:finish()
end

function wdj:guard()
   local w=walk.new()
   w.walkover=function()--��λ�嶾�̵ڶ������� �嶾��Ů����(Wudujiao dizi)
      world.Send("compare wudujiao dizi")
	  local l,w=wait.regexp("^(> |)wudujiao dizi ��������$|^(> |)��о�.*�����Ǹ������, ������мһ�ˡ�$|^(> |)�۹�������, .*����������������Ķ���!$|^(> |)��Ҫɱ��.*����Ҫ�������ϰ����ס�$|^(> |)��Ȼ�Ӹ����濴���㶼��.*��ʤһ��, ����Ҳ������С�$|^(> |)���Ա�����Ϊ�ж�.*�ļ�����",5)
	  if l==nil then
	     self:guard()
	     return
	  end
	  if string.find(l,"��������") then
	      local exps=tonumber(world.GetVariable("exps")) or 0
		  if exps>800000 then
		      wdj.wdj1_ok=true --��̬����
		      wdj.wdj1_do=true
              self:get_dan()
		  else
		      wdj.wdj1_ok=false  --û���б�
		      wdj.wdj1_do=false  --û���б�
		      self:finish()
		  end

		  return
	  end
   	  if string.find(l,"������мһ��") or string.find(l,"������Ķ���") or string.find(l,"�������ϰ�����") or string.find(l,"����Ҳ�������") then
	      --�ܹ����
		  wdj.wdj1_ok=true --��̬����
		  wdj.wdj1_do=true
          self:get_dan()
	      return
	  end
	  if string.find(l,"���Ա�����Ϊ�ж�") then
	      wdj.wdj1_ok=false
		  wdj.wdj1_do=true
		  self:finish()
	     return
	  end
   end
   w:go(366)
end

function wdj:enter()
    world.Send("northup")
	world.Send("northup")
	local _R
	_R=Room.new()
	_R.CatchEnd=function()
		local cd=cond.new()
		cd.over=function()
			for _,i in ipairs(cd.lists) do
				  print(i[1],i[2])
		         if i[1]=="�����ܻ���" then
		           print("�ж�״̬:",i[2])
				   print("�õ����Ǽ�ҩ!!")
			       local sec=i[2]
				   wdj.wdj2_ok=false
			       self:catch_spider()
			       return
		         end
			end
			local count,roomno=Locate(_R)
			if roomno[1]==3187 then
			    wdj.wdj2_ok=true
			    local now=os.time()
		 	    world.Send("set wdj_in "..now)
			    sj.wdj_in_time=now
				local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --��wdj.wdj2_ok ����һ��
		        DatabaseExec("sj",cmd)
				refresh_link()--ˢ�¹�ϵ��
				self:catch_spider()
	        else
			    self:kill_wudujiaodizi()
		    end
		end
		cd:start()
	end
	_R:CatchStart()

end

function wdj:kill_wudujiaodizi()
   --print("kkkkkk wudujiaodizi")
   local w=walk.new()
   w.walkover=function()--��λ�嶾�̵ڶ������� �嶾��Ů����(Wudujiao dizi)
      local pfm=world.GetVariable("pfm") or ""
	   pfm=convert_pfm(pfm)
	  world.Send("alias pfm "..pfm)
	  world.Send("set wimpycmd pfm\\hp\\cond")
      world.Send("kill wudujiao dizi")
	  local l,w=wait.regexp("^(> |)����û������ˡ�$|^(> |)�������嶾��Ů������ɱ���㣡$|^(> |)���ͣ����ͣ�$",5)
	  if l==nil then
	     self:kill_wudujiaodizi()
	     return
	  end
	  if string.find(l,"����û�������") then
	      --�ܹ����
		    local _R
            _R=Room.new()
			_R.CatchEnd=function()
               local count,roomno=Locate(_R)
			   if roomno[1]==366 then
			       self:enter()
			   else
			       self:kill_wudujiaodizi()
			   end
			end
			_R:CatchStart()
	      return
	  end
	  if string.find(l,"����") or string.find(l,"�������嶾��Ů����") then
	     local f=function()
	        self:kill_wudujiaodizi()
		 end
		 f_wait(f,3)
	     return
	  end
   end
   w:go(366)
end

function wdj:check_poison()
  --print("hi")
    local cd=cond.new()
	cd.over=function()
	   for _,i in ipairs(cd.lists) do
	      print(i[1],i[2])
		   if i[1]=="�����ܻ���" then
		        print("�ж�״̬:",i[2])
				--print("�õ����Ǽ�ҩ!!")
			   local sec=i[2]
			    self:finish()
			   return
		   end
	   end
	   local sp=special_item.new()
       sp.cooldown=function()
	      --print("kill guard")
           self:kill_wudujiaodizi()
       end
	   local equip={}
	   equip=Split("<��ȡ>����","|")
       sp:check_items(equip)
	end
	cd:start()
end

function wdj:eat_dan()
  wait.make(function()
	  world.Send("fu jiuxuebiyun dan")
      local l,w=wait.regexp("^(> |)���һ�ž�ѩ���Ƶ�������ҧ�麬������پ��������ʣ���ɫ����$",5)
	  if l==nil then
	     self:eat_dan()
	     return
	  end
      if string.find(l,"���һ�ž�ѩ���Ƶ�") then
		 local b=busy.new()
		 b.Next=function()
            self:check_poison() --ȥ����Ƿ���ж�
		 end
		 b:check()
	     return
	  end
  end)
end

function wdj:get_dan()
	local w=walk.new()
	w.walkover=function()
		wait.make(function()
			world.Send("ask cheng about �嶾��")
			world.Send("yes")
			local l,w=wait.regexp("������˵���������ϴδ�Ӧ�ҵ����黹û������������Ҫ.*|^(> |)�����ض���΢΢һЦ��˵����ף�����˳��������ϣ�������Զ����š�$|^(> |)������˵���������Ѿ��������ˣ�Ϊ�λ�Ҫ����Ҫ����ҩ�������ƣ���Ҫ̫̰�ģ���$",5)
			if l==nil then
				self:get_dan()
				return
			end
			if string.find(l,"��������Ҫ") then
				-- ץ֩������  �������һ�żٵ�
				world.AppendToNotepad (WorldName().."_wdj:",os.date()..": �õ���ҩ!\r\n")
	            --sj.log_catch(WorldName().."_wdj:",500)
				local b=busy.new()
		        b.Next=function()
                  --self:eat_dan() --ȥ����Ƿ���ж�
				  --self:catch_spider()
				  world.SetVariable("wdj_entry","false")
				  --local cmd="update MUD_Entrance set linkroomno=-1 where direction='shanjiao_shanlu'"
		          --DatabaseExec("sj",cmd)
				  self:finish()
		        end
		        b:check()
				return
			end
			if string.find(l,"�����ض���΢΢һЦ") or string.find(l,"��ҩ�������ƣ���Ҫ̫̰��") then
			    --world.AppendToNotepad (WorldName().."_wdj:",os.date()..": yao!\r\n")
	            --sj.log_catch(WorldName().."_wdj:",500)
				self:eat_dan()
				return
			end
		end)
	end
	w:go(373)
end

function wdj:give_spider()
     local w=walk.new()
   w.walkover=function()

	  wait.make(function()
	    world.Send("give cheng zhu")
	   local l,w=wait.regexp("^(> |)���������һֻѩ�롣$|^(> |)������û������������$",5)
	   if l==nil then
		   self:give_spider()
	      return
	   end
	   if string.find(l,"������û����������") then
		   self:finish()
	       return
	   end
	   if string.find(l,"���������") then
			local now=os.time()
			world.Send("set wdj_give "..now)
			--world.AppendToNotepad (WorldName().."_wdj:",os.date()..": sj.wdj_give_time="..now.."!\r\n")
			sj.wdj_give_time=now
	       if wdj.wdj2_ok==true then  --ȷ���Ե���ҩ
		      wdj.wdj3_ok=true
			else
			  wdj.wdj3_ok=false
		   end
		   self:finish()
	      return
	   end
	  end)
	  --
   end
   w:go(373)
end


function wdj:get_spider()
   wait.make(function()
    world.Send("get zhu")
    local l,w=wait.regexp("^(> |)�㽫ѩ������������ڱ��ϡ�$|^(> |)�㸽��û������������$",5)
	if l==nil then
	   self:get_spider()
	   return
	end
	if string.find(l,"�㽫ѩ������������ڱ���") then
	   self:give_spider()
	   return
	end
	if string.find(l,"�㸽��û����������") then
	   self:finish()
	   return
	end
  end)
end

function wdj:fight_spider(flag)
		if flag==nil or flag==false then
         world.Send("dian fire")
		 world.Send("wield mu jian")
	     world.Send("alias pfm")
		 world.Send("jiali 0")
	     world.Send("yao shuteng")
		 world.Send("unset wimpy")
		 world.Send("unset wimpycmd")
		end
		 world.DoAfter(1.5,"hit zhu")
		 world.DoAfter(1.5,"look")
	    wait.make(function()
		--
	    local l,w=wait.regexp("^(> |).*ѩ��\(Xue zhu\).*(\<ս����\>|\<���Բ���\>).*$|^(> |)ѩ�������˼��£�һ�������ε���ȥ��$|^(> |)ѩ�롸ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)��ζ��˰��죬����ʲ��Ҳû�С�$",15)
		if l==nil then
		   self:catch_spider()
		   return
		end
		if string.find(l,"ѩ�������˼���")  or string.find(l,"���Բ���") then
		   world.Send("unwield mu jian")
		   self:get_spider()
		   return
		end
		if string.find(l,"Xue zhu") then
		   self:fight_spider(true)
		   return
		end
		if string.find(l,"��ζ��˰��죬����ʲ��Ҳû��") or string.find(l,"�����ų鶯�˼��¾�����") then
		   print("֩������,�ȴ�ˢ��")
		   world.Send("unwield mu jian")
		   self:finish()
		   return
		end

	    end)
end

function wdj:catch_spider()
    local d=os.time()
	world.Send("set wdj_refresh "..d)
	sj.wdj_refresh_time=d
	--�ް�֥��־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ��
	--world.AppendToNotepad (WorldName().."_wdj:",os.date()..": sj.wdj_refresh_time="..d.."!\r\n")
   local w=walk.new()
   w.walkover=function()
	  local sp=special_item.new()
	  sp.cooldown=function()
         self:fight_spider()
      end
      sp:unwield_all()

   end
   w:go(3201)
end

function wdj:go()
   -- print("������ֱ�ӽ���2")
  -- ���֩��ˢ��ʱ��
   if sj.wdj_refresh_time~="" then
      local t1=os.time()
	  local interval=os.difftime(t1,sj.wdj_refresh_time)
	  print(interval,":��"," ֩��ˢ�¼��600s!")
	  if interval<=600 then --10����
	     self:finish()
		 return
	  end
   end

   self:check()
end

function wdj:check()
    --�о����񹦿���ֱ�ӽ���
  local skills=world.GetVariable("teach_skills") or ""
  local ski={}
   ski=Split(skills,"|")
   for _,v in ipairs(ski) do
     if v=="jiuyang-shengong" then
	   --print("������ֱ�ӽ���1")
	   wdj.wdj1_ok=true
	   wdj.wdj2_ok=true
       wdj.wdj3_ok=true
	     local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --��wdj.wdj2_ok ����һ��
		            DatabaseExec("sj",cmd)
					refresh_link()--ˢ�¹�ϵ��
	   self:finish() --��Ч����
	   return
     end
   end
   local wdj_auto_entry=world.GetVariable("wdj_auto_entry") or ""
   if wdj_auto_entry=="true" then
	   wdj.wdj1_ok=true
	   wdj.wdj2_ok=true
       wdj.wdj3_ok=true
	     local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --��wdj.wdj2_ok ����һ��
		            DatabaseExec("sj",cmd)
					refresh_link()--ˢ�¹�ϵ��
	   self:finish() --��Ч����
	   return
   end
  world.Send("exp")
   wait.make(function()
       local l,w=wait.regexp("^(> |)����������(.*)��$",10)
	   if l==nil then
	      self:check()
	      return
	   end
      if string.find(l,"����������") then
	      local connect_hour=w[2]
		  if sj.wdj_in_time=="" then-- û�л�ù�
		     --print("ʱ��")
             self:start()
		  else

			 --print(connect_hour,"����ʱ��")

			 connect_hour=string.gsub(connect_hour,"��","|86400|")
			 connect_hour=string.gsub(connect_hour,"Сʱ","|3600|")
			 connect_hour=string.gsub(connect_hour,"��","|60|")
			 connect_hour=string.gsub(connect_hour,"��","|1|")
			 local connect_time={}
			 connect_hour=string.sub(connect_hour,1,-2)
			 connect_time=Split(connect_hour,"|")

			 local i
			 local connect_time_num=0
			 for i=1,table.getn(connect_time),2 do
			     connect_time_num=ChineseNum(connect_time[i])*connect_time[i+1]+connect_time_num
			 end
			 local now=os.time()
			 --print(now,"     ",sj.wdj_in_time)
			 local interval1=os.difftime(now,sj.wdj_in_time)
			 local interval2
			 if sj.wdj_give_time=="" then
			    interval2=-1
			 else
			    interval2=os.difftime(now,sj.wdj_give_time)
			 end
			 local interval3
			 if sj.wdj_refresh_time=="" then
			    interval3=-1
			 else
				interval3=os.difftime(now,sj.wdj_refresh_time)
			 end
			 print(interval1,":��"," �嶾��ʱ����:",sj.wdj_in_time)
			 print(interval2,":��"," ץ֩��ʱ����",sj.wdj_give_time)
			  print(interval3,":��"," ץ֩��ˢ�¼��",sj.wdj_refresh_time)
			 print(connect_time_num," connect_time")
			 --world.AppendToNotepad (WorldName().."_wdj:",os.date().." "..interval1,":��"," �嶾��ʱ����:",sj.wdj_in_time.."!\r\n")
			 --world.AppendToNotepad (WorldName().."_wdj:",os.date().." "..interval2,":��"," ץ֩��ʱ����",sj.wdj_give_time.."!\r\n")
			 --world.AppendToNotepad (WorldName().."_wdj:",os.date().." "..connect_time_num.." connect_time".."!\r\n")
             if connect_time_num>interval1 then
			    --print("��Ч")
			    if 	wdj.wdj2_ok==false then
				  	wdj.wdj2_ok=true--��Ч
				    local cmd="update MUD_Entrance set linkroomno=3157 where direction='shanjiao_shanlu'" --��wdj.wdj2_ok ����һ��
		            DatabaseExec("sj",cmd)
					refresh_link()--ˢ�¹�ϵ��
				end
				if sj.wdj_give_time=="" then
				   wdj.wdj3_ok=false
				   self:check_poison()
				   return
				elseif connect_time_num>interval2 then
				   wdj.wdj3_ok=true
				   self:finish() --��Ч����
				elseif interval3<=900 then --
				    print("��ץ��֩��!�ȴ�15����,900> ",interval3)
					wdj.wdj3_ok=false
				   self:finish() --��Ч
				else
				   print("ûץ��֩��")
			       wdj.wdj3_ok=false
				   self:check_poison() --ȥ���֩��
				   return
				end
			 else
			     --print("����")
				if 	wdj.wdj2_ok==true then
				  local cmd="update MUD_Entrance set linkroomno=-1 where direction='shanjiao_shanlu'" --��wdj.wdj2_ok ����һ��
		          DatabaseExec("sj",cmd)
				  refresh_link()--ˢ�¹�ϵ��
				end
				 wdj.wdj2_ok=false
				 wdj.wdj3_ok=false
			     self:start()
			 end

          end		  --�嶾��ʱ��
	      return
      end
  end)
end

