--����quest ģ��
quest={
  new=function()
	 local _quest={}
	 setmetatable(_quest,quest)
	 return _quest
  end,
  co=nil,
  path_co=nil,
  list={},
  neili_upper=1.9,
  hama1_try=0,
}
quest.__index=quest
--
function quest:quest_over() --�ص�
end

function quest:yinyang4()
   wait.make(function()
      local l,w=wait.regexp("�ֺ��漴�������ֵľ���Ϥ���������㣬������ѧ���˴������֣�|�ֺ�����㽲��һ��Ѿ��ϣ����������룬������֪������˵Щʲô...",10)
	  if l==nil then
		 self:quest_over()
	     return
	  end
	  if string.find(l,"������֪������˵Щʲô") then
	      world.Send("set yinyang "..os.date())
		  world.Send("cry")
		  self:quest_over()
	      return
	  end
	  if string.find(l,"������ѧ���˴�������") then
	     world.Send("set yinyang �ɹ�")
	     world.Send("laugh")
		 self:quest_over()
	     return
	  end
      wait.time(10)
   end)
end

function quest:yinyang3()
   wait.make(function()
     world.Send("ask le about ��������")
     local l,w=wait.regexp("�ֺ������������˵�˼��仰��|�ֺ�˵������.*������֮�����ֻ�Ǹ���ʦ��ѧ���ǲ����кý���ģ���|�ֺ�˵����������Ҫ�н��ƣ������߻���ħ����",5)
     if l==nil then
		self:yinyang3()
		return
	 end
	 if string.find(l,"�ֺ������������˵�˼��仰") then
	    self:yinyang4()
	    return
	 end
	 if string.find(l,"����֮�����ֻ�Ǹ���ʦ��ѧ") or string.find(l,"����Ҫ�н��ƣ������߻���ħ") then
	    self:quest_over()
	    return
	 end
	 wait.time(5)
   end)
end

function quest:yinyang2()
  wait.make(function()
    world.Send("ask le about ��������")
    local l,w=wait.regexp("�ֺ�˵������.*���ҵĴ������־������ǿ��������书��һ�����ģ���",5)
	if l==nil then
	   self:yinyang2()
	   return
	end
	if string.find(l,"�ǿ��������书��һ������") then
	   self:yinyang3()
	   return
	end
	wait.time(5)
  end)
end

function quest:yinyang()
  local w=walk.new()
  w.walkover=function()
     world.Send("ask le about name")
	 wait.make(function()
	   local l,w=wait.regexp("�ֺ�������һЦ���ֺ���Ǵ�ү�ң�",5)
	   if l==nil then
	      self:yinyang()
		  return
	   end
	   if string.find(l,"�ֺ�������һЦ���ֺ���Ǵ�ү��") then
	     self:yinyang2()
	     return
	   end
	   wait.time(5)
	 end)
  end
  w:go(323)
end

function quest:_chen()
  local rooms={1247,1246,1245,1346}
  local i=1
  return function()
     if i>=table.getn(rooms) then
	    i=1
	 else
	    i=i+1
	 end
	 return rooms[i]
  end
end
function quest:tiandihui()
  local r=self:_chen()
  local w2
  w2=walk.new()
  w2.walkover=function()
  --�½���˵��������λ׳ʿ��������ҪŬ��һ�����У�������״̬��̫�ʺ�ѧϰ��Ѫ��צ����
--�½����������ʯ���뿪��

  --����½��ϴ����йء���Ѫ��צ������Ϣ��
    wait.make(function()
        world.Send("ask chen about ��Ѫ��צ")
		local l,w=wait.regexp("^(> |)����½��ϴ����йء���Ѫ��צ������Ϣ��$|^(> |)����û������ˡ�$",5)
		if l==nil then
           self:tiandihui()
		   return
		end
		if string.find(l,"����û�������") then
		  w2:go(r())
		  return
		end
		if string.find(l,"����½��ϴ����й�") then
		  self:quest_over()
		  return
		end
	 end)
  end
  --1247
  --1246
  --1346
  w2:go(r())
end

function quest:NextPoint()
    print("���ָ̻�")
   coroutine.resume(quest.co)
end

function quest:checkPlace(npc,roomno,here)
      if is_contain(roomno,here) then
  	     print("�ȴ�0.5s,��һ������")
		 local f=function()
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:NextPoint()
		   end
		   b:check()
		 end
		 f_wait(f,0.5)
	   else
	   --û���ߵ�ָ������
	    print("û���ߵ�ָ������")
	      w=walk.new()
		  w.walkover=function()
		    self:checkNPC(npc,roomno)
		  end
		  w:go(roomno)
	   end
end

function quest:kill_weixiaobao()

end

function quest:checkNPC(npc,roomno)
    wait.make(function()
      world.Execute("look|set look 1")
      local l,w=wait.regexp("^(> |).*"..npc.."\\\((.*)\\\).*$|^(> |)�趨����������look \\= 1",6)
	  if l==nil then
		self:checkNPC(npc,roomno)
		return
	  end
	  if string.find(l,"�趨����������look") then
	      --û���ҵ�
		  --
		  local f=function(r)
		     self:checkPlace(npc,roomno,r)
		  end
		  WhereAmI(f,10000) --�ų����ڱ仯

		  return
	  end
	  if string.find(l,npc) then
	     --�ҵ�
		  self:kill_weixiaobao()
		  return
	  end
	  wait.time(6)
   end)
end

function quest:xiaobao()
  wait.make(function()
      local l,w=wait.regexp("^(> |)Τ����˵��������λ.*��������˵�����ǹԶ�������(.*)�������ء���",5)
	  if l==nil then
	     self:weichunhua()
		 return
	  end
	  if string.find(l,"������") then
	     local location=w[2]
		 local n,rooms=Where(location)
		 local b
		 b=busy.new()
	     b.interval=0.5
	     b.Next=function()
	     quest.co=coroutine.create(function()
	      for _,r in ipairs(rooms) do
             local w
		     w=walk.new()
		     w.walkover=function()
		       self:checkNPC("ΤС��",r)
		     end
		     w:go(r)
		     coroutine.yield()
	       end
		   --print("û���ҵ�npc!!")
		   self:weichunhua()
	     end)
	       self:NextPoint()
	     end
    	 b:check()
		 return
	  end
  end)
end

function quest:weichunhua()
   local w=walk.new()
   w.walkover=function()
      world.Send("ask wei about ΤС��")
      self:xiaobao()
   end
   w:go(2292)
end

function quest:wudangjianjue()
   --jz_endtime = os.time()
   --jz_diftime = os.difftime (jz_endtime , jz_starttime)/3600
   --jz_diftime1=string.format("%.2f", jz_diftime)
   local w=walk.new()
   w.walkover=function()

	  local gender=world.GetVariable("gender")
	  if gender=="����" then
	      world.Execute("s;e;s;zhao mao tan")
	  else
	      world.Execute("s;w;s;zhao mao tan")
	  end
      local b
       b=busy.new()
        b.interval=0.3
         b.Next=function()

		if gender=="����" then
	      world.Execute("n;w")
	    else
	      world.Execute("n;e")
	    end
         world.Execute("n;out;n;find yao chu;s;su;su;su;su;e;give caiyao chu;eu;su;bang song;pa down;pa down;pa down;pa down")
           local b1
       b1=busy.new()
        b1.interval=0.3
         b1.Next=function()
         world.Execute("tiao down")
           local b2
       b2=busy.new()
        b2.interval=0.3
         b2.Next=function()
         world.Execute("enter;look wall;read wall")
           local b4
       b4=busy.new()
        b4.interval=0.3
         b4.Next=function()
           world.Execute("out;jump down;ne")
              local b5
       b5=busy.new()
        b5.interval=0.3
         b5.Next=function()
            self:Execute()
          end
           b5:check()
                 end
                 b4:check()
                 end
                 b2:check()
                 end
                 b1:check()
                 end
                 b:check()
                 end
   w:go(1957)
end

function quest:yitiantulong_ok()
   wait.make(function()
      local l,w=wait.regexp("^(> |)����Ŀѣ���֮�ʣ��漴Ǳ�ļ��䡣��|^(> |)����������һ�ӣ�˵��:��Ҳ��ȥ�ɡ�˵�ս������á�$",10)
	  if l==nil then
		 world.AppendToNotepad (WorldName().."_�Զ�����:",os.date()..": �䵱����������������\r\n")
	     self:quest_over()
		 return
	  end
	  if string.find(l,"����Ŀѣ���֮�ʣ��漴Ǳ�ļ���") then
		 self:yitiantulong_ok()
	     return
	  end
	  if string.find(l,"����������һ�ӣ�˵��:��Ҳ��ȥ�ɡ�˵�ս�������") then
	     world.AppendToNotepad (WorldName().."_�Զ�����:",os.date()..": �䵱����������������\r\n")
	     self:quest_over()
	     return
	  end

   end)
end

function quest:yitiantulong_wake()
  wait.make(function()
     local l,w=wait.regexp("^(> |)������������������񣬲������أ�����ʦ����$",10)
	 if l==nil then
	    self:yitiantulong_sleep()
	    return
	 end
	 if string.find(l,"������������������񣬲������أ�����ʦ��") then
	    self:yitiantulong_ok()
	    return
	 end

  end)

end

function quest:yitiantulong_sleep()
   local w=walk.new()
   w.walkover=function()
       --[[world.Send("sleep")
	   wait.make(function()
	       local l,w=wati.regexp("^(> |)��������һ�ɣ���ʼ˯����$",5)
		   if l==nil then
		      self:yitiantulong_sleep()
		      return
		   end
		   if string.find(l,"��������һ�ɣ���ʼ˯��") then

		      return
		   end
	   end)]]
	   self:yitiantulong_wake()
   end
   local gender=world.GetVariable("gender")
   local roomno=2790
   if gender=="����" then
     roomno=2790
   else
     roomno=3175
   end
   w:go(roomno)

end

function quest:yitiantulong_zhang()
   world.Send("n")
   world.Send("s")
   print("������")
    wait.make(function()
	   local l,w=wait.regexp("^(> |)���������һ��,˵��:�������°ɡ�$",10)
	   if l==nil then
	       self:yitiantulong_zhang()
		   return
	   end
	   if string.find(l,"���������һ��,˵��:�������°�") then
	      self:yitiantulong_sleep()
	      return
	   end
	end)
end

function quest:yitiantulong()

    world.AppendToNotepad (WorldName().."_�Զ�����:",os.date()..": �䵱����������������\r\n")
	shutdown()

	local b=busy.new()
	b.Next=function()
	  world.Send("ask song about �����")
	   local f=function()
    --print (utils.msgbox ("��ʼ����������������", "Warning!", "ok", "!", 1)) --> ok
    world.Send("nick ��������")
	local w=walk.new()
	w.walkover=function()

	   world.Send("l dache")
	   world.Send("l caocong")
	   world.Send("bo ����")
	    world.Send("get �����")
	    local f=function()
	       self:yitiantulong_zhang()
	     end
	    f_wait(f,10)

	end
	w:go(1933)
	end
	   f_wait(f,5)
	end
	b:check()

end

function quest:jiujian()
     world.AppendToNotepad (WorldName().."_�Զ�����:",os.date()..": ���¾Ž�������\r\n")
	   local sp=special_item.new()
       sp.cooldown=function()
	      local w=walk.new()
		  w.walkover=function()
             self:mianbi()

		  end
		   w:go(1537)
       end
   	   local equip={}
	   equip=Split("<��ȡ>����|<��ȡ>�󻹵�","|")
       sp:check_items(equip)
end

function quest:fengyi_over()

    wait.make(function()
	   local l,w=wait.regexp("^(> |)������ƺ��е��ĵã����ܻ���ҪһЩʵս�����۾���ɡ�$|^(> |)�����о��ް�������������ʹ��һ���ǳɣ������νӵ������޷죬������.*",5)
	    if l==nil then
		    self:fengyi_over()
		    return
		end
		if string.find(l,"������ƺ��е��ĵ�") then
		  wait.time(3)
		  self:log_time("fy")
		    world.Execute("out;wield jian;wield sword;break wall;out")
		    self:Execute()
		   return
		end
		if string.find(l,"�����о��ް�����") then

		    wait.time(3)
		    self:log_time("fy")
		    world.Execute("out;wield jian;wield sword;break wall;out")
			world.Send("set quest fengyi")
			world.Send("nick ����")
		    self:Execute()
		   return
		end

	end)
end

function quest:mianbi()
    world.Execute("enter;mianbi")
	--ֻ�������ܽ�ȥ
	wait.make(function()
	  local l,w=wait.regexp("^(> |)���Ȼ����һ���Ʊڵ�����������վ��������$",1)
	  if l==nil then
	    self:mianbi()
	    return
	  end
	  if string.find(l,"���Ȼ����һ���Ʊڵ�����������վ������") then
	     wait.time(2)
		 world.Execute("wield jian;wield sword;break wall;enter;use fire;left")
		 wait.time(8)
		 world.Send("zhuomo �з�����")
		 self:fengyi_over()

	     return
	  end

	end)
end

--����
local ask_zhou_count=0
function quest:answer_start()
  --ask zhou about ����
  wait.make(function()
    world.Send("give zhou fan he")

	--> ����û������ˡ�
	local l,w=wait.regexp("^(> |)����û������ˡ�$|^(> |)����ܲ�ͨһ�����С�$",5)
	if l==nil then
	   self:answer_start()
	   return
	end
	if string.find(l,"����û�������") then
	   local f=function()
	      self:answer_start()
	   end
	   f_wait(f,5)

	   return
	end
	if string.find(l,"����ܲ�ͨһ������") then

    world.Send("ask zhou about �����澭")
	wait.time(3)
    world.Send("ask zhou about ����")
	wait.time(3)
    world.Send("ask zhou about ��������")
	wait.time(3)
	self:answer_quest()
    world.Send("answer n")
    ask_zhou_count=0
	   return
	end
  end)
end
--  ȫ��̵ڶ������ӡ�����ͯ���ܲ�ͨ(Zhou botong)
--������ͯ���Դ�ȭ����ʲô����
local l_zhou=0

function quest:answer_quest()
  wait.make(function()
     local l,w=wait.regexp("^(> |)�ܲ�ͨ˵������(.*)��$|^(> |)�ܲ�ͨ˵������������������ô�ã�һ�������İɣ���$|.*ȫ��̵ڶ������ӡ�����ͯ���ܲ�ͨ.*",5)
	 if l==nil then
	    world.Send("look")
		world.Send("ask zhou about ����")
		l_zhou=l_zhou+1
		ask_zhou_count=ask_zhou_count+1
		if ask_zhou_count>=50 then
		   print("��ֹһֱask zhou")
		   self:Execute()
		   return
		end
		if l_zhou>2 then
		     world.Execute("out|enter")
		     self:answer_quest()
		else
		    self:answer_quest()
		end
		--world.Send("set action ����")

	    return
	 end
	 if string.find(l,"����ͯ") and string.find(l,"ȫ��̵ڶ�������") then
	    l_zhou=0
	     self:answer_quest()
		 return
	 end

	 if string.find(l,"�ܲ�ͨ˵��") then
	    self:answer_quest()
	    local quest=Trim(w[2])
		local answer=self:answer(quest)
		if answer~="" then
		  world.Send("answer "..answer)
		--else
		  --self:Execute()
		end

	    return
	 end

  end)
end
function quest:answer(quest)
     local answer=""
      if quest=="��ȫ��̵��ڹ��ķ���ʲô��" then

			answer = "xiantian-gong"

	  elseif quest=="����а��������ָ����ʲô��" then

			answer = "tanzhi-shentong"

      elseif  quest=="�μ�������ָΪ���Ľ�������ʲô���֣�" then
			answer = "liumai-shenjian"

	  elseif  quest=="���ư�������Ṧ�ǣ�" then
			answer = "shuishangpiao"

	  elseif  quest=="��������ͷ�İ����ǽ���ʲô��" then
			answer = "hansha-sheying"

	 elseif  quest=="�϶��������ڹ���ʲô��" then
			answer = "hamagong"

	 elseif  quest=="�Ͻл��͹��ֵܶ�����Ʒ���ʲô��" then
			answer = "xianglong-zhang"

	 elseif  quest=="���ֺ����ǵ��ڹ���ʲô��" then
			answer = "yijin-jing"

	 elseif  quest=="���ҵĽ�����ʲô��" then
			answer = "huifeng-jian"

	 elseif  quest=="�䵱����ͷ������������ȭ����ʲô���֣�" then
			answer = "taiji-quan"

     elseif  quest=="�������޼���С�ӵ��ڹ���ʲô��" then
			answer = "jiuyang-shengong"

	 elseif  quest=="�����ɶ������õĹ�����ʲô��" then
			answer = "huagong-dafa"

	 elseif  quest=="Ľ�ݼҵļҴ������мܼ����ǣ�" then
			answer = "douzhuan-xingyi"

	 elseif  quest=="����ǰ������������ʲô���������߻�����ģ�" then
			answer = "qiankun-danuoyi"

	 elseif  quest=="����а���������������ڹ�����������ڹ��������ǣ�" then
			answer = "bihai-chaosheng"

	 elseif  quest=="�����ɾ���ѩ�˵Ľ�����ʲô���ƣ�" then
			answer = "jinshe-jianfa"

	 elseif  quest=="���ֽ���������ʹ�˾��Ӿ�����������������ʲô��" then
			answer = "pixie-jian"

	 elseif  quest=="��ɽ���ڵ���ɽ֮����ʲô��" then
			answer = "zixia-gong"
--[[�ܲ�ͨ˵������������ͯ���Դ�ȭ����ʲô������
�� answer ���ش𣬻ش���ʹ��ƴ�����룬��Ҫ�ú��֡�
�ܲ�ͨ˵���������õĸ�������ʲô����
answer niqiugong
�ܲ�ͨ˵�������������е�ͷ�����
�ܲ�ָͨ������̾��������è�����ֵ�һ���֣���
�ܲ�ͨ˵����������һ��ɡ���
> �ܲ�ͨ���ٺٺ١���Ц�˼�����
�ܲ�ͨ˵������ע�������ˣ���
�� answer ���ش𣬻ش���ʹ��ƴ�����룬��Ҫ�ú��֡�
�ܲ�ͨ˵������������ͯ���Դ�ȭ����ʲô������]]
	 elseif  quest=="������ͯ���Դ�ȭ����ʲô����" then
			answer = "kongming-quan"

	 elseif  quest=="��ɽ���ڵĸ߼������ǣ�" then
			answer = "dugu-jiujian"

	 elseif  quest=="��Ĺ�ɵ��ڹ��ķ���ʲô��" then
			answer = "yunu-xinjing"

	 elseif  quest=="���������С�ӽ��ҵ��Ʒ�����ʲô���ƣ�" then
			answer = "anran-zhang"

	 elseif  quest=="һ�ƴ�ʦ�����־�ѧ��ʲô��" then
			answer = "yiyang-zhi"

	 elseif  quest=="�Ͻл��̻�����СѾͷ����ʲôȭ����" then
			answer = "xiaoyaoyou"

	elseif  quest=="��Ĺһ�ɵ�����ȭ������ʲô���ƣ�" then
			answer = "meinv-quanfa"

	elseif  quest=="����а���˽������ָ��ͨ��������ʲô�书��" then
			answer = "yuxiao-jian"

	elseif  quest=="���õĸ�������ʲô��" then
			answer = "niqiugong"

	elseif  quest=="���صļҴ��ַ���ʲô���֣�" then
			answer = "lanhua-shou"

	elseif  quest=="�һ��Ŀ�����Ҫ��ʲô������ɨҶ�����ʩչ��" then
			answer = "luoying-zhang"

	elseif  quest=="���ҵ����ʦ̫���������ֹ������޼ɴ�ĵ��ز���" then
			answer = "jieshou-jiushi"

	elseif quest=="������������ô�ã�һ�������İɣ�" then
		self:log_time("jyu")
		local b=busy.new()
		b.Next=function()
		  shutdown()
	      world.Send("ask zhou about ����")
		  self:Execute()
        end
		b:check()
		--answer=""
	end
	return answer
end

function quest:zhoubotong()

end

local taohuazhen_index=1
function quest:catch_taohuazhen(Serial)
  if taohuazhen_index>24 then
    print("�ߵ�����")
	world.Send("enter")
	self:zhoubotong()
    return
  end
  world.Send("look north")
  wait.make(function()
     local l,w=wait.regexp("���ܵ�û��һ˿��϶��$|�м�¶��һ��С����$|^(> |)�ݵ� -.*",5)
	 if l==nil then
         self:catch_taohuazhen()
  	    return
     end

	 if string.find(l,"�ݵ�") then
	   self:taohuazhen()
	   return
	 end
     if string.find(l,"�м�¶��һ��С��") then
	    local zi="��"
		if zi==Serial[taohuazhen_index] then
		   world.Send("north")
		else
		   world.Send("west")
		end
		taohuazhen_index=1+taohuazhen_index
		local f=function()
		   self:catch_taohuazhen(Serial)
	    end
		f_wait(f,0.4)
		return
     end
     if string.find(l,"���ܵ�û��һ˿��϶") then
	   local zi="��"
		if zi==Serial[taohuazhen_index] then
		   world.Send("north")
		else
		   world.Send("west")
		end
		taohuazhen_index=1+taohuazhen_index
		local f=function()
		   self:catch_taohuazhen(Serial)
	    end
		f_wait(f,0.4)
	   return
     end
  end)
end

--��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,��,
function quest:taohuazhen()
  --[[local w=walk.new()
  w.walkover=function()
  world.Send("look bagua")
  wait.make(function()
    local l,w=wait.regexp("^(> |)һ����ֵ������ԣ����水˳ʱ��˳�������ţ�(.*)��$",5)
	if l==nil then
	  self:taohuazhen()
	  return
	end
	if string.find(l,"һ����ֵ�������") then
		local key=w[2]
		local code=""
		local codebook={}
		codebook["Ǭ"]={"��","��","��"}
		codebook["��"]={"��","��","��"}
		codebook["��"]={"��","��","��"}
		codebook["��"]={"��","��","��"}
		codebook["��"]={"��","��","��"}
		codebook["��"]={"��","��","��"}
		codebook["��"]={"��","��","��"}
		codebook["��"]={"��","��","��"}
		--������޿�����Ǭ
		local dx={}

		for i=1,16,2 do
		   local c=string.sub(key,i,i+1)
		   print(c)
		   table.insert(dx,codebook[c])
		end
		print("*********")
		for _,i in ipairs(dx) do
		   local steps=""
		   for _,g in ipairs(i) do
		      steps=steps..g..","
		   end
		   print(steps)
		   code=code..steps
		end
		code=string.sub(code,1,-1)
		print(code)
		local Serial={}
		Serial=Split(code,",")
		local w=walk.new()
		w.walkover=function()
		   world.Send("west")
		   --world.Send("look")
		   taohuazhen_index=2
           self:catch_taohuazhen(Serial)
		end
		w:go(2824)
	   return
	end
  end)
  end
  w:go(2808)]]

  local w=walk.new()
  w.walkover=function()
     world.Send("west")
     world.Execute("#10 s")
	 local f=function()
	   world.Execute("#13 s")
	   world.Send("enter")
	   self:zhoubotong()
	 end
	 f_wait(f,0.8)
  end
  w:go(2824)

end

--���

function quest:zhou_ask(ask_cmd,marcocmd)

  world.Send(ask_cmd)
		  --����û������ˡ�
  wait.make(function()
		     local l,w=wait.regexp("^(> |)����û������ˡ�$|^(> |)�����ܲ�ͨ�����й�.*$",5)
			 if l==nil then
			    self:zhou_ask(ask_cmd,marcocmd)
			    return
			 end
			 if string.find(l,"�����ܲ�ͨ�����й�") then
				   marco(marcocmd)
			       local b1=busy.new()
				   b1.interval=5
		           b1.Next=function()

        			   self:Execute()
			       end
				   b1:check()
			     return
			 end

			if string.find(l,"����û�������") then
			    wait.time(4)
			    self:zhou_ask(ask_cmd,marcocmd)
			   return
			end
  end)
end

function quest:jiebai(manual_operate)
    local q_record=self:get_log_time("jiebai")
	local last_jiebai_time=q_record.quest_time
	local jiebai_time=os.time()

	local interval=os.difftime(jiebai_time,last_jiebai_time)
	print(interval,":��","���ܲ�ͨʱ����")
  if interval>3600*24 or manual_operate==true then
     self.zhoubotong=function()
		  --world.SetVariable("last_jiebai_time",jiebai_time)
		  self:log_time("jiebai")
		  print("���ܲ�ͨ���")
		  self:zhou_ask("ask zhou about ���","#wa 3000|ask zhou about ���һ���|#wa 3000|#30 hua fang yuan")
	 end
     self:taohuazhen()
  else
     self:Execute()
  end
end


function quest:kmq(manual_operate)
    local q_record=self:get_log_time("kmq")
	local last_kmq_time=q_record.quest_time
	local kmq_time=os.time()

	local interval=os.difftime(kmq_time,last_kmq_time)
	print(interval,":��","����ȭ�ܾ�ʱ����")
  if interval>3600*24 or manual_operate==true  then
     self.zhoubotong=function()
		  --world.SetVariable("last_jiebai_time",jiebai_time)
           self:log_time("kmq")
		  self:zhou_ask("ask zhou about ����ȭ�ܾ�","say bye")
		  --�����ܲ�ͨ�����йء�����ȭ�ܾ�������Ϣ��



	 end
     self:taohuazhen()
  else
     self:Execute()
  end
end

--���ǹ
function quest:yangjiaqiang()
    local q_record=self:get_log_time("yangjiaqiang")
	local last_yangjiaqiang_time=q_record.quest_time
	local yangjiaqiang_time=os.time()

	local interval=os.difftime(yangjiaqiang_time,last_yangjiaqiang_time)
	print(interval,":��","���ǹʱ����")
  if interval>3600*24 and q_record.success==0 then
    local w=walk.new()
    w.walkover=function()
      world.Execute("n;n")

	   local b=busy.new()
	   b.Next=function()
		  world.Send("ask yang about ���ǹ")
	      --world.SetVariable("last_yangjiaqiang_time",yangjiaqiang_time)
		   self:log_time("yangjiaqiang")
		  local f=function()
		    world.Execute("s;s")
	        self:Execute()
		  end
		  f_wait(f,30)
	   end
	   b:check()
    end
    w:go(1836)
  else
     self:Execute()
  end
end

local path_redo_finish=function()
   --�ص�����
end

local function path_redo(path,cmd)
   local P=Split(path,";")
  local count=0
   quest.path_co=coroutine.create(function()
      for _,g in ipairs(P) do
	    world.Send(cmd)
		world.Send(g)
		if count>=10 then
		  count=0
		  local f=function()
		   local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     coroutine.resume(quest.path_co)
		   end
		   b:check()
		  end
		  f_wait(f,1)
		  coroutine.yield()
        else
		  count=count+1
		end
	  end
	  quest.path_co=nil
	  path_redo_finish()
  end)
  coroutine.resume(quest.path_co)
end
--ǧ������
function quest:qzwds()
  local w=walk.new()
  w.walkover=function()
     local cmd="ask yin about ǧ������"
	 local path="ne;e;e;e;e;e;w;n;s;e;w;n;w;n;s;s;s;s;sw;ne;n;n;n;w;s;e;n;n;e;e;w;w;w;w;e;e;n;n;e;nw;sw;e;n;nd;nd;nd;wd;sd;e;se;nw;w;w;sd;sw;ne;nu;w;w;wd;wu;nu;wu"
	 path_redo(path,cmd)
  end
  w:go(2830)
end
--- 9yd
function quest:jyd()
    local q_record=self:get_log_time("jyd")
	local last_jyd_time=q_record.quest_time
	local jyd_time=os.time()
	local interval=os.difftime(jyd_time,last_jyd_time)
	print(interval,":��","������ʱ����")
  if interval>3600*24 and q_record.success==0 then
   local w=walk.new()
   w.walkover=function()
        local _R
	  _R=Room.new()
	  _R.CatchEnd=function()
		local count,roomno=Locate(_R)
		print("��ǰ�����",roomno[1])
		if roomno[1]==1705 then
			world.Send("enter")
            world.Send("kill mei")
	        world.Send("kill chen")
	        local _pfm=world.GetVariable("quest_pfm") or ""
	        local f=function()
	            self:Execute()
	        end
	        self:fight(_pfm,f)
		else
			self:jyd()
		end
	  end
	 _R:CatchStart()
   end
   w:go(1705)
  else
    self:Execute()
  end
end

function quest:jyu2()
    local b2=busy.new()
	 b2.Next=function()
	  local w1=walk.new()
	  w1.walkover=function()
	     world.Send("ask huang about �ܲ�ͨ")
		 local bb=busy.new()
		 bb.Next=function()
		    self.zhoubotong=function()
               self:answer_start()
            end
		    self:taohuazhen()
		 end
		 bb:check()
	  end
	  w1:go(2803)
	 end
	 b2:check()
end
--- 9yu
function quest:jyu()
    local q_record=self:get_log_time("jyu")
	local last_jyu_time=q_record.quest_time
	local jyu_time=os.time()

	local interval=os.difftime(jyu_time,last_jyu_time)
	print(interval,":��","������ʱ����")
  if interval>3600*24 and q_record.success==0 then
   local w=walk.new()
   w.walkover=function()
     world.Send("ask huang about �ܲ�ͨ")
	 wait.make(function()
	    local l,w=wait.regexp("^(> |)�����ҩʦ�����йء��ܲ�ͨ������Ϣ��$",5)
		if l==nil then
		    self:jyu()
		   return
		end
		if string.find(l,"�����ҩʦ�����й�") then
		    self:jyu2()
		    return
		end
	 end)

   end
   w:go(2814)
  else
    self:Execute()
  end
end

--- �𵶺ڽ�
function quest:jindaoheijian()
    local q_record=self:get_log_time("jindaoheijian")
	local last_jindaoheijian_time=q_record.quest_time
	local jindaoheijian_time=os.time()

	local interval=os.difftime(jindaoheijian_time,last_jindaoheijian_time)
	print(interval,":��","�𵶺ڽ�ʱ����")
  if interval>3600*24 and q_record.success==0 then
   local w=walk.new()
   w.walkover=function()

      world.Send("ask gongsun about �𵶺ڽ�")
	   local b=busy.new()
	   b.Next=function()
	      --world.SetVariable("last_jindaoheijian_time",jindaoheijian_time)
	      self:log_time("jindaoheijian")
		  self:Execute()
	   end
	   b:check()
   end
   w:go(2998)
  else
    self:Execute()
  end
end

--����3
function quest:jsjf()
    local q_record=self:get_log_time("jsjf")
	local last_jsjf_time=q_record.quest_time
	local jsjf_time=os.time()

	local interval=os.difftime(jsjf_time,last_jsjf_time)
	print(interval,":��","���߽���ʱ����")
	if interval>3600*24 and q_record.success==0 then
     local w=walk.new()
      w.walkover=function()
        --world.Send("ask xia about �ؾ�")
		--world.Execute("|n|ask xia xueyi about �ؾ�|w|ask xia xueyi about �ؾ�|s|ask xia xueyi about �ؾ�|eu|ask xia xueyi about �ؾ�|wd|ask xia xueyi about �ؾ�|n|ask xia xueyi about �ؾ�|e|ask xia xueyi about �ؾ�|n|ask xia xueyi about �ؾ�|enter|ask xia xueyi about �ؾ�|out|ask xia xueyi about �ؾ�|s|ask xia xueyi about �ؾ�|e|ask xia xueyi about �ؾ�")
		path_redo_finish=function()
		  local b=busy.new()
		  b.Next=function()
		  --world.SetVariable("last_jsjf_time",jsjf_time)
		   self:log_time("jsjf")
	       self:Execute()
		  end
		  b:check()
		end
		local cmd="ask xia xueyi about �ؾ�"
		local path="wd;n;e;n;enter;out;s;e;s;e;s;w;s;eu"
		  -- local dx={"wd","n","e","n","enter","out","s","e","s","e","s","w","s","eu"}
		path_redo(path,cmd)

      end
      w:go(2654)
   else
      print("next")
      self:Execute()
   end

end
--����

function quest:bingcan3()
   local w=walk.new()
   w.walkover=function()
      local b=busy.new()
	  b.Next=function()
	    world.Send("shenshou wa weng")
		local f=function()
	    self:Execute()
		end
		f_wait(f,20)
	  end
	  b:check()
   end
   w:go(134)
end

function quest:bingcan2()
    local w=walk.new()
	w.walkover=function()
	    wait.time(2)
		world.Send("open xiaobao")
		wait.time(2)
		world.Send("ask zi about ����")
	    self:bingcan3()
	end
	w:go(1964)
end

function quest:bingcan()
--
    local q_record=self:get_log_time("bingcan")
    local last_bingcan_time=q_record.quest_time
	local bingcan_time=os.time()

	local interval=os.difftime(bingcan_time,last_bingcan_time)
	print(interval,":��","����ʱ����")
	if interval>24*3600 and q_record.success==0 then

      local w=walk.new()
     w.walkover=function()
        world.Send("search �ݴ�")
	    wait.make(function()
	      local l,w=wait.regexp("^(> |)�������ˣ��Ͳ�С���Ѿ�����ȡ���ˡ�$|^(> |)�㲦�˲���Χ�Ĳݴԣ��������ײݴ����и��Ͳ�С��,����ʰ��$|^(> |)�㲦�˲��ݴԣ���û�б��ʲô���֣�������Щ��Ȼ��$",5)
		  if l==nil then
		      self:bingcan()
			  return
		  end
		  if string.find(l,"��������") then
			  self:Execute() --ִ��
		     return
		  end
	      if string.find(l,"�������ײݴ����и��Ͳ�С��") or string.find(l,"������Щ��Ȼ") then
             --world.SetVariable("last_bingcan_time",bingcan_time)
			 self:log_time("bingcan")
 			 self:bingcan2()
		     return
		  end
	   end)
	   --�������ˣ��Ͳ�С���Ѿ�����ȡ���ˡ�
     end
     w:go(3996)
	else
	 self:Execute()
   end
end

--�Զ�����

function quest:Status_Check()
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
			        rc:qudu(sec,i[1],false)
				    return
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
			        rc:heal(true,true)
				    return
				 end

			   end
		     end
			--self:xuli()
            self:full()
	end
	cd:start()
end

function quest:full()
	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 local qi_percent=world.GetVariable("qi_percent") or 100
	 qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
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
		   w:go(1960) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif (h.qi_percent<=liao_percent or h.jingxue_percent<=80) and heal_ok==false then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
			end

			rc:liaoshang()

		elseif h.jingxue_percent<100 then
		    print("��ͨ����")
            local rc=heal.new()
			--world.Send("set heal jing")
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
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			   heal_ok=true
			   self:Status_Check()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    heal_ok=false --��λ
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
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
			    end
				if id==777 then
				   f=function()
				     heal_ok=false
   				     self:Status_Check()
				   end  --���
				   f_wait(f,0.5)
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(126)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			      self:auto_ask()
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
			  self:auto_ask()
			end
			b:check()
		end
	end
	h:check()
end

function quest:quest_ask()
	local quests={
	pearl="00 �һ�����",
    bingcan="01 ���ޱ���",
	hjdf="02-1 ���ҵ���",
	mjjf="02-2 ��ҽ���",
	bz="02-3 ��Ȫ��",
	djrh="02-4 �����ں�",
	jsjf="03 ���߲�",
	yjq="04 ���ǹ",
	jianjue="05-1 ȫ�潣��",
	dingyang="05-2 ȫ�涨����",
	jiebai="06-1 �ܲ�ͨ���",
	jyu="06-2 ������",
	 jyd="06-3 ������",
	 jdhj="07 �𵶺ڽ�",
	 szj="08-1 ���վ�1",
	 szj2="08-2 ���վ�2",
	 lbwb="09 �貨΢��",
	 hama1="10 ���1",
	 qzwds="11 ǧ������",
	 yuenvjian="12 ԽŮ��",
	 kh="13 ��������",
	 gmhb="14-1 ��Ĺ����",
	 gmjy="14-2 ��Ĺ����",
	 gmsk="14-3 ��Ĺʯ��",
	  guess="15 ������",
	  nxsz="16 ��Ѫ��צ",
	  sxbf="17 ���󲽷�",
	  zzr="18 Ѱ��������",
      hrz="19 ȫ���Ȼ��",
	  nqg="20 ������",
      jgys="21 ���칦�������",
	  jjs="22 ��ɽ�ؽ�ʽ",
	   xxdfrg="23 ���Ǵ��ں�",
	   arz="24 ��Ȼ��",
	   lxg="25 ����",
	   gw="26 ��ɽ����",
	   jianqi="27 ȫ�潣��",
	   kmq="28 ����ȭ�ܾ�",
	   yyz="29 һ��ָ",
	   yysz="30 һ��ָ��",
	   tz="31 �����Ƶ�",
	   zl="32 �������",
	   hyd="33 ���浶����",
	   fy="34 �з�����",
	   taiji="35 �䵱����",

  }
  local select_quest=utils.listbox ("����", "�ֶ�ѡ�����", quests)
  if select_quest then
    local _qlist={}
	 _qlist["pearl"]=function() self:get_pearl(94) end
    _qlist["bingcan"]=function() self:bingcan(true) end
	_qlist["hjdf"]=function() self:hujiadaofa(true) end
    _qlist["jsjf"]=function() self:jsjf(true) end
	_qlist["yjq"]=function() self:yangjiaqiang(true) end
	_qlist["jianjue"]=function() self:jianjue(true) end
	_qlist["dingyang"]=function() self:qz_dingyang(true) end
	_qlist["jiebai"]=function() self:jiebai(true) end
	_qlist["lbwb"]=function() self:lbwb(true) end
	_qlist["mjjf"]=function() self:miaojiajianfa(true) end
	_qlist["djrh"]=function() self:rh(true) end
	_qlist["jdhj"]=function() self:jindaoheijian(true) end
	_qlist["hama1"]=function() self:hama1(true) end
	_qlist["bz"]=function() self:baozang(true) end
	_qlist["szj2"]=function() self:szj2(true) end
	_qlist["szj"]=function() self:szj(true) end
	_qlist["guess"]=function() self:ask_question() end
	_qlist["jyu"]=function() self:jyu(true) end
	_qlist["jyd"]=function() self:jyd(true) end
    _qlist["kh"]=function() self:kuihua(true) end
    _qlist["qzwds"]=function() self:qzwds(true) end
	_qlist["yuenvjian"]=function() self:yuenvjian(true) end
	_qlist["gmhb"]=function() self:gumu_yufengzhen(true) end
	_qlist["nxsz"]=function() self:nxsz(true) end
	_qlist["sxbf"]=function() self:sxbf(true) end
	_qlist["zzr"]=function() self:zzr(true) end
	_qlist["gmsk"]=function() self:gumu_shike(true) end
	_qlist["gmjy"]=function() self:gumu_jiuyin(true) end
	_qlist["hrz"]=function() self:qz_haotian_lianhuan(true) end
	_qlist["nqg"]=function() self:nqg_start(true) end
	_qlist["jgys"]=function() self:qz_jgys(true) end
	_qlist["jjs"]=function() self:hs_jjs_start(true) end
	_qlist["xxdfrg"]=function() self:ronggong(true) end
	 _qlist["arz"]=function() self:arz_start(true) end
	 _qlist["lxg"]=function() self:dls_longxiang(true) end
	 _qlist["gw"]=function() self:ss_guanwu_songtao_start(true) end
	 _qlist["jianqi"]=function() self:qixingjian(true) end
	 _qlist["kmq"]=function() self:kmq(true) end
	 _qlist["yyz"]=function() self:yyz(true) end
	 _qlist["yysz"]=function() self:yysz(true) end
	 _qlist["tz"]=function() self:tiezhang_zhangdao(true) end
	 _qlist["zl"]=function() self:zhenlong(true) end
	 _qlist["hyd"]=function() self:dls_hyd(true) end
     _qlist["fy"]=function() self:hs_fengyi(true) end
	 _qlist["taiji"]=function() self:taiji(true) end

	local exe_quest=_qlist[select_quest]
	 exe_quest()
  else

  end
end

function quest:auto_ask(callback)
     local q_list=world.GetVariable("quest_list") or ""
     self.list=Split(q_list,"|")
   local _qlist={}
    _qlist["���ޱ���"]=function() self:bingcan() end
	_qlist["���ҵ���"]=function() self:hujiadaofa() end
    _qlist["jsjf"]=function() self:jsjf() end
	_qlist["���ǹ"]=function() self:yangjiaqiang() end
	_qlist["jianjue"]=function() self:jianjue() end
	_qlist["dingyang"]=function() self:qz_dingyang() end
	_qlist["�ܲ�ͨ���"]=function() self:jiebai() end
	_qlist["�貨΢��"]=function() self:lbwb() end
	_qlist["��ҽ���"]=function() self:miaojiajianfa() end
	_qlist["�����ں�"]=function() self:rh() end
	_qlist["���1"]=function() self:hama1() end
	_qlist["��Ȫ��"]=function() self:baozang() end
	_qlist["���վ�2"]=function() self:szj2() end
	_qlist["���վ�1"]=function() self:szj() end
    _qlist["��������"]=function() self:kuihua() end
    _qlist["ǧ������"]=function() self:qzwds() end
	_qlist["ԽŮ��"]=function() self:yuenvjian() end
	_qlist["������"]=function() self:jyu() end
	_qlist["������"]=function() self:jyd() end
	_qlist["��Ѫ��צ"]=function() self:nxsz() end
	_qlist["sxbf"]=function() self:sxbf() end
    _qlist["�����ں�"]=function() self:rh() end

	--����quest
   _qlist["��ɽ����"]=function() self:ss_guanwu_songtao_start() end

   _qlist["�䵱����"]=function() self:wd_taoyue_start() end

   _qlist["��ɽ�ؽ�ʽ"]=function() self:hs_jjs_start() end

   _qlist["���޺�������"]=function() self:xx_laoyue_start() end

   _qlist["������"]=function() self:nqg_start() end

   _qlist["�𵶺ڽ�"]=function() self:jdhj_start() end

   _qlist["��Ȼ��"]=function() self:arz_start() end
   _qlist["��ħ����"]=function() self:tianmo() end
   _qlist["���Ǵ��ڹ�"]=function() self:ronggong() end
   _qlist["ǧ����"]=function() self:qbwh() end
   _qlist["���ν�"]=function() self:wxj() end
   _qlist["���컨��"]=function() self:huayu() end
   _qlist["��ħ����"]=function() self:juedao() end
   _qlist["���������"]=function() self:qz_haotian_lianhuan() end
   _qlist["���칦�������"]=function() self:qz_jgys() end
   _qlist["���������"]=function() self:dls_longxiang() end
   _qlist["ȫ�潣��"]=function() self:qixingjian() end
   _qlist["����ȭ�ܾ�"]=function() self:kmq() end
    _qlist["һ��ָ"]=function() self:yyz() end
	 _qlist["һ��ָ��"]=function() self:yyzs() end
	 _qlist["�����Ƶ�"]=function() self:tiezhang_zhangdao() end
	 _qlist["�������"]=function() self:zhenlong() end
	  _qlist["���浶����"]=function() self:dls_hyd() end
	  _qlist["�з�����"]=function() self:hs_fengyi() end
	   _qlist["�䵱����"]=function() self:taiji() end

	--self:success_msg()
	 quest.co=coroutine.create(function()
	    for _,v in ipairs(self.list) do
	       print("��ʼ�Զ�����:",v)
		   local f=_qlist[v]  --����
		   f()
           --print("��ͣ")
	       coroutine.yield()
	    end
		--print("�ص�2")
		quest.co=nil
		if callback~=nil then
		  callback() --�ص�
		end
	end)
	self:Execute()
end

function quest:Execute()
   local b=busy.new()
   b.Next=function()
      if quest.co~=nil then
	    coroutine.resume(quest.co)
	  end
   end
   b:check()
end

function quest:get_pearl(roomno,callback,count)
    if count==nil then
	   count=0
	else
	   count=count+1 --��ֹ���๺������

	   if count>5 then
	     local b=busy.new()
		 b.Next=function()
			world.Send("pray pearl")
			self:auto_ask(callback)
		 end
		 b:check()
	   end
	end
    local w=walk.new()
	  w.walkover=function()
	    if roomno==94 then
	     world.Send("qu pearl")
		else
		 world.Send("duihuan pearl")
		end
		 --world.Send("pray pearl")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)�㲢û�б������Ʒ��$|^(> |)�����������Ӹ��˴���������ȡ������$|^(> |)�����ϰ�ߺ��һ������.*�һ����Ƽ������������飬����.*���齣ͨ������$",8)
			if l==nil then
			   self:get_pearl(roomno,callback,count)
			   return
			end
			if string.find(l,"����������ȡ����") or string.find(l,"�һ�") then
				local b=busy.new()
		        b.Next=function()
				   world.Send("pray pearl")
                   callback()
				end
		        b:check()
			   return
			end
			if string.find(l,"�㲢û�б������Ʒ") then
			   self:get_pearl(84,callback,count)
			   return
			end
		 end)
	  end
	  w:go(roomno)
end

function quest:auto_check(callback)
   local Quest=self:group_time()
   local auto_ask_time=Quest.quest_time
   local t1=os.time()
   if os.difftime(t1,auto_ask_time)>=86400 and Quest.success==0 then
   -- ������
      local do_quest=function() self:auto_ask(callback) end
	  self:get_pearl(94,do_quest)
	else
	   callback()
	end
end

function quest:zzr()
--������ʼ   {ɽ��( ������):sw;#2 s;sw;wu;sw;wu;sw;#2 enter;use fire;e;s;w;n;ne;se;sw;nw;out
  local w=walk.new()
  w.walkover=function()
      world.Execute("sw;#2 s;sw;wu;sw;wu;sw;#2 enter;use fire;e;s;w;n;ne;se;sw;nw;out")
  end
  w:go(669)
end


function quest:ask_jianjue()

--�������޷���������б������ǣ������ָ����ѧϰȫ�潣���Ľ������衣
--��Ľ��������Ѿ����ڱ���֮���ˣ��ֺιʿ�����Ц�أ�
    local w=walk.new()
	w.walkover=function()
	    world.Send("ask qiu about ����")
		local l,w=wait.regexp("^(> |)�𴦻�˵�������������޷���������б������ǣ������ָ����ѧϰȫ�潣���Ľ������衣��$|^(> |)�𴦻�˵�������ţ��㲻�Ǹ�����̹��ҽ����𣿻�����Ŭ����ʱ��ɣ���$|^(> |)�𴦻�����Ŀ����㣬����˵���������ɵ�ȫ�潣���������ǵ��ҹ۲������Ƕ��������Ǳ任֮����ȡǧ���򻯡������޾�֮ԭ��$|^(> |)^(> |)�𴦻�˵�������ţ��㲻�Ǹ�����̹��ҽ����𣿻�����Ŭ����ʱ��ɣ���$|^(> |)�𴦻�˵������.*����Ľ��������Ѿ����ڱ���֮���ˣ��ֺιʿ�����Ц�أ���$",5)
	    if l==nil then
		   self:ask_jianjue()
		   return
		end
		if string.find(l,"�����ָ����ѧϰȫ�潣���Ľ�������") then
		    wait.time(1.5)
			world.Send("unset ����")
		    process.neigong3()
			local f=function()
			    shutdown()
				local b=busy.new()
				b.Next=function()
				   self:ask_jianjue()
				end
				b:check()
			end
			f_wait(f,30)
		    return
		end
		if string.find(l,"������Ŭ����ʱ���") then
		   local f=function()
			   self:Execute()
			end
			f_wait(f,3)
			return
		end
		if string.find(l,"ȡǧ���򻯡������޾�֮ԭ��") then
		   local b=busy.new()
		   b.Next=function()
		    world.Send("qingjiao")
			local f=function()
			   self:Execute()
			end
			f_wait(f,20)
		   end
		   b:check()
		    return
		end
		if string.find(l,"��Ľ�������") then
		 --local b=busy.new()
		   --b.Next=function()
		     self:Execute()
		   --end
		   --b:check()
		    return
		end
	end
	w:go(4152)
end

function quest:ask_yiyangzhi()
	local w=walk.new()
	w.walkover=function()
	    world.Send("give yideng lingwen")
		local f=function()
	      world.Send("ask yideng about һ��ָ")
		  local f=function()
		  --local b=busy.new()
		  --b.Next=function()
		     self:Execute()
		  --end
		  --b:check()
		  end
		  f_wait(f,20)
		end
		f_wait(f,3)

	end

      w:go(2740)
end

function quest:jianjue()
   local q_record=self:get_log_time("jianjue")
  local last_quanzhen_time
	last_quanzhen_time=q_record.quest_time

	local quanzhen_time=os.time()

	local interval=os.difftime(quanzhen_time,last_quanzhen_time)
	print(interval,":��","ȫ�����ʱ����")
	if interval>24*3600 and q_record.success==0 then
	 -- local w=walk.new()
	 -- w.walkover=function()
	  -- world.Send("duihuan pearl")
	   --world.Send("pray pearl")
	    --world.SetVariable("last_quanzhen_time",quanzhen_time)
	   self:log_time("jianjue")
       self:qzjj()
	  --end
	  --w:go(84)
	else
	 self:Execute()
   end
end

function quest:qz_dingyang()
   local q_record=self:get_log_time("dingyang")
  local last_quanzhen_time
	last_quanzhen_time=q_record.quest_time

	local quanzhen_time=os.time()

	local interval=os.difftime(quanzhen_time,last_quanzhen_time)
	print(interval,":��","ȫ�����ʱ����")
	if interval>24*3600 and q_record.success==0 then
	 -- local w=walk.new()
	 -- w.walkover=function()
	  -- world.Send("duihuan pearl")
	   --world.Send("pray pearl")
	    --world.SetVariable("last_quanzhen_time",quanzhen_time)
	   self:log_time("dingyang")
       self:ask_yiyangzhi()
	  --end
	  --w:go(84)
	else
	 self:Execute()
   end
end

function quest:qzjj() --ȫ�潣��

   local w=walk.new()
   w.walkover=function()
    world.Send("ketou ����")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)������ǰȥ�����������İγ����Ǳ�����$",5)
	  if l==nil then
	     self:qzjj()
	     return
	  end
	  if string.find(l,"���Ǳ���") then
	    local f=function()
	      self:ask_jianjue()
		end
		f_wait(f,2)
	     return
	  end
	end)
   end
   w:go(5014)
end

function quest:dingyang()
--fankan ���ؾ���
--give dashi lingwen

  wait.make(function()
     world.Send("ketou")
	 wait.time(1.5)
	 world.Send("fankan ���ؾ���")

     local l,w=wait.regexp("^(> |)������ķ����˼�ҳ������������������֮������ֻ����������������˽⣬��Ȼ��ζ��$|^(> |)����æ�������պá�$",5)
	 if l==nil then
		self:dingyang()
	    return
	 end
	 if string.find(l,"�����˽⣬��Ȼ��ζ") then
	    wait.time(1)
	    self:dingyang()
	    return
	 end
	 if string.find(l,"����æ�������պ�") then
	     self:ask_jianjue()
	     return
	  end

  end)
end

function quest:tiashan()
   wait.make(function()
     local l,w=wait.regexp("^(> |)��Ų���·������������ï�ܣ������˽�ȥ�����˽�������ʱ������˿�����ۡ�$|^(> |)ɽ��.*",10)
	 if l==nil then
	    world.Send("l")
		self:tianshan()
		return
	 end
	 if string.find(l,"˿������") then
        local f=function()
		   self:Execute()
		end
		f_wait(10)
	    return
	 end

   end)
end

function quest:yuxiang()
  self:log_time("lbwb")
  local w=walk.new()
  w.walkover=function()
      world.Send("ketou yuxiang")
	  world.Send("l left")
	  world.Send("l right")
	  local f=function()
	      marco("#20 ketou yuxiang|#wa 3000|#10 fan bo juan|#wa 3000|#10 read bo juan")

		  local f2=function()
		     world.Send("look picture")
			 local b=busy.new()
			 b.Next=function()
			   world.Send("yanjiu picture")
			   local f=function()
			     self:Execute()
			   end
			   f_wait(f,5)
			 end
			 b:check()
		  end
		  f_wait(f2,4)
	  end
	  f_wait(f,3)
  end
   w:go(5016)
end

function quest:lbwb(manual_operate)
    local q_record=self:get_log_time("lbwb")
    local last_lbwb_time=q_record.quest_time
	--local manual_operate=world.GetVariable("quest_manual") or false
	local lbwb_time=os.time()

	local interval=os.difftime(lbwb_time,last_lbwb_time)
	print(interval,":��","�貨΢��ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
     local w=walk.new()
	 local al=alias.new()
	 w.user_alias=al
	 al.noway=function()
	    self:Execute()
	 end
     w.walkover=function()
        world.Execute("jump down;pa yabi;gou feng")

	    self:yuxiang()
     end
     w:go(2852)
   else
      self:Execute()
   end
end

function quest:rh(manual_operate)
	local q_record=self:get_log_time("djrh")
    local last_djrh_time=q_record.quest_time
	local djrh_time=os.time()

	local interval=os.difftime(djrh_time,last_djrh_time)
	print(interval,":��","�����ں�ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	 -- world.SetVariable("djrh_time_time",djrh_time)
	 self:log_time("djrh")
	 local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
         world.Execute("w;n")
		 DoAfter(2,"ask miao about �����ں�")
		 local f=function()
		    self:Execute()
		 end
		 f_wait(f,8)
		end
		b:check()
     end
     w:go(1568)
  else
     self:Execute()
  end
end

function quest:szj(manual_operate)
    local q_record=self:get_log_time("szj")
    local last_szj_time=q_record.quest_time
	local szj_time=os.time()

	local interval=os.difftime(szj_time,last_szj_time)
	print(interval,":��","���վ�ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)
	  self:log_time("szj")
    local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
		 DoAfter(1,"ask ding about ���վ�")
		 local f=function()
		    self:Execute()
		 end
		 f_wait(f,4)

		end
		b:check()
     end
     w:go(973)
  else
     self:Execute()
  end
end

function quest:szj2(manual_operate)
    local q_record=self:get_log_time("szj2")
    local last_szj2_time=q_record.quest_time
	local szj2_time=os.time()

	local interval=os.difftime(szj2_time,last_szj2_time)
	print(interval,":��","���վ�2ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)
	  self:log_time("szj2")
    local w=walk.new()
     w.walkover=function()
		 world.Send("tiao down")
		 local b=busy.new()
		 b.Next=function()
		   DoAfter(1,"ask di yun about ���վ�")
		   local f=function()
		     self:Execute()
		   end
		   f_wait(f,4)
         end
		 b:check()
     end
     w:go(1660)
  else
     self:Execute()
  end
end

function quest:hujiadaofa(manual_operate)
local q_record=self:get_log_time("hjdf")
    local last_hjdf_time=q_record.quest_time
	local hjdf_time=os.time()

	local interval=os.difftime(hjdf_time,last_hjdf_time)
	print(interval,":��","���ҵ���ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)

	   local cd=cond.new()
	   cd.over=function()
	     print("���״̬")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="����æ״̬" then
			     local f=function()
				    self:hujiadaofa(manual_operate)
				 end
			     f_wait(f,10)
			     return
			  end
			end
			self:log_time("hjdf")
            local w=walk.new()
            w.walkover=function()
	         local b=busy.new()
		      b.Next=function()
		        DoAfter(1,"ask hu about ���ҵ���")
		       local f=function()
		          self:Execute()
		        end
		        f_wait(f,30)

		      end
			  b:check()
            end
             w:go(732)
		 else
		     self:log_time("hjdf")
            local w=walk.new()
            w.walkover=function()
	         local b=busy.new()
		      b.Next=function()
		        DoAfter(1,"ask hu about ���ҵ���")
		       local f=function()
		          self:Execute()
		        end
		        f_wait(f,30)

		      end
			  b:check()
            end
             w:go(732)
		 end
	   end
	   cd:start()

  else
     self:Execute()
  end


end

function quest:sxbf(manual_operate)
    local q_record=self:get_log_time("sxbf")
    local last_sxbf_time=q_record.quest_time
	local sxbf_time=os.time()

	local interval=os.difftime(sxbf_time,last_sxbf_time)
	print(interval,":��","���󲽷�ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)
	  self:log_time("sxbf")
    local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
		 DoAfter(1,"ask hu about ���󲽷�")
		 DoAfter(5,"ask hu about ��������")
		 local f=function()
		    self:Execute()
		 end
		 f_wait(f,10)

		end
		b:check()
     end
     w:go(732)
  else
     self:Execute()
  end
end

--ͻȻ�ӽ���������һ���ˣ�ʩ���������µ������Ҿ��Ǻڷ�կկ�����Ͽ��뿪���ԭ����
function quest:miaojiajianfa(manual_operate)
    local q_record=self:get_log_time("mjjf")
    local last_mjjf_time=q_record.quest_time
	local mjjf_time=os.time()

	local interval=os.difftime(mjjf_time,last_mjjf_time)
	print(interval,":��","��ҽ���ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
	  --world.SetVariable("last_mjjf_time",mjjf_time)
	  self:log_time("mjjf")
    local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
         world.Execute("w;n")
		 DoAfter(2,"ask miao about ��ҽ���")
		 local f=function()
		    self:Execute()
		 end
		 f_wait(f,30)

		end
		b:check()
     end
     w:go(1568)
  else
     self:Execute()
  end
end

function quest:nxsz(manual_operate)
	local q_record=self:get_log_time("nxsz")
	local last_nxsz_time=q_record.quest_time
	local nxsz_time=os.time()

	local interval=os.difftime(nxsz_time,last_nxsz_time)
	print(interval,":��","��Ѫ��צʱ����")
	if (interval>3600*24 and q_record.success==0) or manual_operate==true then
     local w=walk.new()
      w.walkover=function()
        --world.Send("ask xia about �ؾ�")
				--world.Execute("|n|ask xia xueyi about �ؾ�|w|ask xia xueyi about �ؾ�|s|ask xia xueyi about �ؾ�|eu|ask xia xueyi about �ؾ�|wd|ask xia xueyi about �ؾ�|n|ask xia xueyi about �ؾ�|e|ask xia xueyi about �ؾ�|n|ask xia xueyi about �ؾ�|enter|ask xia xueyi about �ؾ�|out|ask xia xueyi about �ؾ�|s|ask xia xueyi about �ؾ�|e|ask xia xueyi about �ؾ�")
		path_redo_finish=function()
		  --world.Execute("|w|ask chen about ��Ѫ��צ|s|ask chen about ��Ѫ��צ|e|ask chen about ��Ѫ��צ|w|ask chen about ��Ѫ��צ|n|ask chen about ��Ѫ��צ|n|ask chen about ��Ѫ��צ|n|ask chen about ��Ѫ��צ|e|ask chen about ��Ѫ��צ|w|ask chen about ��Ѫ��צ|w|ask chen about ��Ѫ��צ|s|ask chen about ��Ѫ��צ|s|ask chen about ��Ѫ��צ")
		  local b=busy.new()
	  	  b.Next=function()
		   --world.SetVariable("last_nxsz_time",nxsz_time)
		   self:log_time("nxsz")
	       self:Execute()
		  end
		  b:check()
		end
		local cmd="ask chen about ��Ѫ��צ"
		local path="w;s;e;w;n;n;n;e;w;w;w;s;s"
		path_redo(path,cmd)
      end
      w:go(1346)
   else
      print("next")
      self:Execute()
   end
end

function quest:baozang(manual_operate)
    local q_record=self:get_log_time("bz")
	local last_bz_time=q_record.quest_time
	local bz_time=os.time()

	local interval=os.difftime(bz_time,last_bz_time)
	print(interval,":��","����ʱ����")
	if (interval>3600*24 and q_record.success==0) or manual_operate==true then
       local w=walk.new()
	   w.walkover=function()
	     self:bz1()
	   end
	   w:go(71)
   else
      print("next")
      self:Execute()
   end
end

function quest:ask_baozang()
    DoAfter(1,"ask miao about ����")
	wait.make(function()
	   local l,w=wait.regexp("^(> |)���˷ｻ����һ�ű���ͼ��$|^(> |)���˷�˵�����������ɣ��㻹��ץ��ʱ������ȥ�ɣ���һ�������ʰɣ���������ҿ�����$",5)
	    if l==nil then
		   self:ask_baozang()
		   return
		end
	   if string.find(l,"���˷ｻ����һ�ű���ͼ") then
	        local f=function()
		     self:bz_place()
    	    end
        	f_wait(f,4)
	      return
	   end
       if string.find(l,"��һ�������ʰɣ���������ҿ�") then
	    local b=busy.new()
		b.Next=function()
	      world.Send("drop lengyue dao")
	      self:Execute()
		end
		b:check()
	      return
	   end

	end)
end

function quest:bz3()
    local w=walk.new()
     w.walkover=function()
	    local b=busy.new()
		b.Next=function()
         world.Execute("w;n")
		 self:ask_baozang()

		end
		b:check()
     end
     w:go(1568)
end

function quest:bz_place()
  marco("yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|yanjiu lengyue|#wa 1000|guanzhu lengyue|#wa 1000|guanzhu lengyue|#wa 1000|duizhao lengyue|#wa 1000|duizhao lengyue")

  wait.make(function()
    local l,w=wait.regexp("^(> |)��ͻȻ�������߽�����յı�־��Ȼ����һ����������Ϥ�ĵط�����(.*)��$",20)
	if l==nil then
	   self:bz_place()
	   return
	end
	if string.find(l,"��ͻȻ�������߽�����յı�־") then
	   local roomno
	   local place=w[2]
	   if place=="���" then
	     roomno=630
	   elseif place=="�����" then
	     roomno=1591
	   elseif place=="����СϪ" then
	      roomno=2139
	   elseif place=="�ݺ�" then
	      roomno=2065
	   elseif place=="�ų���" then
	      roomno=1589
	   elseif place=="����������" then
	      roomno=1585
	   end
	   shutdown()
	   local b=busy.new()
	   b.Next=function()
	     self:bz4(roomno)
	   end
	   b:check()
	   return
	end
  end)
end

function quest:wa_di()
   world.Execute("#10 wa di")
  wait.make(function()
    local l,w=wait.regexp("^(> |)��ץס��������ѵ��������г�������г�������������⡣$",5)
	if l==nil then
	    self:bz2()
	   return
	end
	if string.find(l,"��ץס��������ѵ��������г��") then
		local b=busy.new()
		b.Next=function()
		   self:bz3()
		end
		b:check()
	end
  end)
end

function quest:bz2()
	 local w=walk.new()
	 --
     w.walkover=function()
	    self:wa_di()
     end
     w:go(732)
end

--bang zhuozi|#wa 3000|move hua pen|#wa 3000|tui zhuozi|#wa 3000|tui anmen
function quest:bz1()
    local equip={}
	equip=Split("<��ȡ>����|<��ȡ>����~{������}","|")
	local sp=special_item.new()
	sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	end
	sp.cooldown=function()
		self:bz2()
	end
	sp:check_items(equip)
end

function quest:fight(pfm,callback)
      print("ս��ģ��")

	  local cb=fight.new()
       cb.combat_alias=pfm

	   cb.check_time=5
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	   cb.unarmed_alias=unarmed_pfm
	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("ж������")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("ս������")
		  world.Send("unset wimpy")
		  shutdown()
		  local b=busy.new()
		  b.Next=function()
		    callback()
		  end
		  b:check()
	  end
	  cb:before_kill()
	  cb:start()
end
--ͻȻ�ӽ���������һ���ˣ�ʩ���������µ������Ҿ��Ǻڷ�կկ�����Ͽ��뿪���ԭ����
function quest:bz_search()
  world.Send("search")
 wait.make(function()
    local l,w=wait.regexp("^(> |)���Ѿ������ҵ��ر���ַ�ˣ�$|^(> |)������ط���һ������ͨ����µ�ͨ����$|^(> |).*����ؿ����㣬��ɫ������š�$|^(> |)���ƺ�����.*һЩʲô�ر�ĵط����������������ȥ��$|^(> |)ͻȻ�ӽ���������һ���ˣ�.*�������µ������Ҿ��Ǻڷ�կկ�����Ͽ��뿪���ԭ����$",2)

    if l==nil then
      self:bz_search()
	  return
	end
	if string.find(l,"���ƺ�����") then
	   wait.time(2)
	   self:bz_search()
	   return
	end
	--����ǰ����ؿ����㣬��ɫ������š�
	if string.find(l,"����ؿ����㣬��ɫ�������") or string.find(l,"�ڷ�կկ��") then
	   local _pfm=world.GetVariable("pfm") or ""
	   local f=function()
	     self:bz_search()
	   end
	   self:fight(_pfm,f)
	   return
	end
    if string.find(l,"������ط���һ������ͨ����µ�ͨ��") or string.find(l,"���Ѿ������ҵ��ر���ַ��") then
	   local b=busy.new()
	   b.Next=function()
	      self:bz5()
	   end
	   b:check()

	end
 end)
end

function quest:bz4(target_roomno)
   local w=walk.new()
   w.walkover=function()
      local _R
	  _R=Room.new()
	  _R.CatchEnd=function()
		local count,roomno=Locate(_R)
		print("��ǰ�����",roomno[1])
		if roomno[1]==target_roomno then
			self:bz_search()
		else
			self:bz4(target_roomno)
		end
	  end
	 _R:CatchStart()

  end
  w:go(target_roomno)
end

function quest:bz_path()
   wait.make(function()
     local l,w=wait.regexp("^(> |)���ְ�������һ����ԭ����ˣ�����(.*)��������(.*)������(.*)���ϻ�(.*)���ɣ�$",5)
	  if l==nil then
	     self:bz_path()
	     return
	  end
	  if string.find(l,"���ְ�������һ��") then
		local g_east=ChineseNum(w[2])
		local g_west=ChineseNum(w[3])
		local g_north=ChineseNum(w[4])
		local g_south=ChineseNum(w[5])

		marco("#"..g_east.." e|#"..g_west.." w|#"..g_north.." n|#"..g_south.." s")
		wait.time(3)
		self:bz6()
		return
	  end
   end)
end

function quest:bz5()
   local b=busy.new()
   b.Next=function()
      self:bz_path()
	  --> ͻȻ������һ�����������������Ѿ���������һ���ˣ���
      world.Execute("d;e;use fire")
   end
   b:check()
end

function quest:bz6()
   marco("bang zhuozi|#wa 3000|move hua pen|#wa 3000|tui zhuozi|#wa 3000|tui anmen")
   wait.make(function()
      local l,w=wait.regexp("^(> |)�������ƿ���İ��ţ��������ŷ켷�˽�ȥ��$",10)
	  if l==nil then
		 self:bz6()
	     return
	  end
	  if string.find(l,"�������ƿ���İ���") then
	     self:search_zhituan()
		 return
	  end
   end)
end

local yanjiu_zhituan_count=1
function quest:yanjiu_zhituan()
		  marco("#wa 3000|look ka|#wa 1000|yanjiu zhituan")
 		  wait.make(function()
		     local l,w=wait.regexp("^(> |)��Я���˲�����Я����ȥ����Ʒ���붪��֮���ٳ����뿪��$|^(> |)�㰴��ֽ���ϵ���Щ��������ȫ����������ȫ���ô�������˵����书�ˡ�$|^(> |)�㰴��ֽ���ϵ���Щ��������ȫ����������ȫ���ô�������˵����书�ˡ�$",5)
			   if l==nil then
			      yanjiu_zhituan_count=yanjiu_zhituan_count+1
				  if yanjiu_zhituan_count>=3 then
				      local b=busy.new()
				     b.Next=function()
				      world.Execute("drop ka;drop lengyue dao")
		              world.Execute("out;w;u")
					  self:log_time("bz")
			          self:Execute()
				    end
				    b:check()
				  else

				     self:yanjiu_zhituan()
				  end

			      return
			   end
			   if string.find(l,"�붪��֮���ٳ����뿪") then
			      local b=busy.new()
				  b.Next=function()
				    world.Send("yanjiu zhituan")
				    world.Execute("drop ka;drop lengyue dao")
		            world.Execute("out;w;u")
					self:log_time("bz")
			        self:Execute()
				  end
				  b:check()
			      return
			   end
			   if string.find(l,"�㰴��ֽ���ϵ���Щ��������ȫ����") then
			      local b=busy.new()
				  b.Next=function()
				    world.Execute("drop ka;drop lengyue dao")
		            world.Execute("out;w;u")
					self:log_time("bz")
			        self:Execute()
				  end
				  b:check()
			     return
			   end
		  end)

end

function quest:search_zhituan()
    world.Execute("#10 search")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)��չ��ֽ�ţ���ϸ���˿��ƺ����书�ؼ�֮��Ľ��ܡ�$",5)
	   if l==nil then
	      self:search_zhituan()
	      return
	   end
	   if string.find(l,"��չ��ֽ��") then
	     yanjiu_zhituan_count=1
	     local b=busy.new()
		 b.Next=function()
		   self:yanjiu_zhituan()
		end
		b:check()
	      return
	   end

	end)

end

function quest:hama1()
 local q_record=self:get_log_time("hama")
	local last_hama1_time=q_record.quest_time
	local hama1_time=os.time()

	local interval=os.difftime(hama1_time,last_hama1_time)
	print(interval,":��","��󡹦1ʱ����")
	if interval>3600*24 and q_record.success==0 then
      self:hama1_lookli()
   else
      --print("next")
      self:Execute()
   end
end


--��������һ��˵������С���ޣ�֪�������˰գ�����������ϴ̶����ƴӵص��������һ�㡣
function quest:hama1_move()

    wait.make(function()
	   local l,w=wait.regexp("^(> |)��������һ��˵������С���ޣ�֪�������˰գ�����������ϴ̶����ƴӵص��������һ�㡣$|^(> )��ֻ���ֱ���ľ�����Ѳ���ʹ����ֻ���ô����죬��֪����Ǻã��������ܽ����������ӡ�$|^(> |)�Ӱ� - west$|^(> |)�����ͻȻһ����µµ�ع�������ʮ�ɣ�$",10)
	   if l==nil then
	       self:hama1_move()
		   return
	   end
	   if string.find(l,"ת��ͷ��ȴ����ʲôҲû��") then
	      print("���֣���")
	      quest.hama1_try=0
	      self:hama1_move()
	      return
	   end
	   if string.find(l,"�������ܽ�����������") then
	       world.EnableTimer("hama1",false)
	       wait.time(3)
		   Execute("look guairen|ask guairen about ŷ����")
		   wait.time(3)
		   Send("ask guairen about ���߹�")
		   wait.time(3)
		   Send("ask guairen about ��󡹦")
		   wait.time(3)
		   Send("ask guairen about name")
		   wait.time(3)
		   Send("kneel man")
		   wait.time(3)
		   Send("turn")
		   wait.time(3)
		   Send("jiao �ְ�")
		   return
	   end
	   if string.find(l,"��������һ��˵��") then
	        world.EnableTimer("hama1",false)
			world.DeleteTrigger("hama1_appear")
		     shutdown()
			self:hama1_move()
	      return
	   end
	   if string.find(l,"�Ӱ�") then
	      quest.hama1_try=quest.hama1_try+1
		  print("����:",quest.hama1_try)
		  if quest.hama1_try>120 then
		     world.EnableTimer("hama1",false)
		     shutdown()
			 self:Execute()
		  else
		      self:hama1_move()
		  end
	      return
	   end
	   if string.find(l,"�����ͻȻһ��") then
	        world.EnableTimer("hama1",false)
			world.DeleteTrigger("hama1_appear")
		     shutdown()
			 self:Execute()
	      return
	   end
	end)
end

function quest:hama1_lookli()
   local w=walk.new()
   w.walkover=function()
      world.Execute("look li mochou;halt;w;s;move zhen")
	  world.AddTimer ("hama1", 0, 0, 1, "w;s;e;yun jingli", timer_flag.ActiveWhenClosed+timer_flag.Replace, "")
      world.SetTimerOption ("hama1", "send_to", 10)

	  local cd=cond.new()
	  cd.over=function()
	     print("���״̬")
		 if table.getn(cd.lists)>0 then
		    local sec=0
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="�������붾" then
				world.EnableTimer("hama1",true)
				world.AddTriggerEx ("hama1_appear", "^(> ;)��ͻȻ���ú��������������ת��ͷ��ȴ����ʲôҲû�С�$", "print(quest.hama1_try)\nquest.hama1_try=0", trigger_flag.RegularExpression + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 350)
	            self:hama1_move()
			    return
			  end
			end
		 end
		 local f=function()
		    self:hama1_lookli()
		 end
		 f_wait(f,5)
	   end
	    cd:start()

   end
   w:go(4012)
end

function copyfile(source,destination)
  sourcefile = io.open(source,"rb")
  destinationfile = io.open(destination,"wb")
  local _lines=sourcefile:read("*a")
  destinationfile:write(_lines)
  sourcefile:close()
  destinationfile:flush()
  destinationfile:close()
end

local quest_database=GetInfo (66) .. "quest.db"
local quest_source_database=GetInfo (66) .. "tools\\quest.db"

local F,err=io.open(quest_database,"r+")
if err~=nil then
    print("����quest log ���ݿ�")
   copyfile(quest_source_database,quest_database)
   DatabaseOpen ("quest", quest_database, 6) --�޸����ݿ�
else
   F:close()
   DatabaseOpen ("quest", quest_database, 6) --�޸����ݿ�
end

function quest:log_time(quest)
  --���һ��id ��
  local quest_time=os.time()
  local quest_date=os.date("%Y/%m/%d %H:%M:%S")
  local player_id=world.GetVariable("player_id")
  local player_name=world.GetVariable("player_name")
  local cmd
  cmd="insert into MUD_Quest (quest,quest_time,quest_date,playerName,playerID,success) values('"..quest.."',"..quest_time..",'"..quest_date.."','"..player_name.."','"..player_id.."',0)"
   --print(cmd)
  DatabaseExec ("quest",cmd)
  DatabaseFinalize ("quest")

end

function quest:update_status(quest)
  local player_id=world.GetVariable("player_id")
  local player_name=world.GetVariable("player_name")
  local cmd
  cmd="update MUD_Quest set success=1  where id in (select id from MUD_Quest where quest='"..quest.."' and playerID='"..player_id.."' order by id desc limit 1)"
  -- print(cmd)
  DatabaseExec ("quest",cmd)
  DatabaseFinalize ("quest")
end

function quest:group_time()
  local player_id=world.GetVariable("player_id")
  local player_name=world.GetVariable("player_name")
  --[[
  local q_cmd=""
  --debug ʹ��
  --if self.list==nil or table.getn(self.list)==0 then
     local q_list=world.GetVariable("quest_list") or ""
     self.list=Split(q_list,"|")
  --end
  for _,me_quest in ipairs(self.list) do
      q_cmd=q_cmd.." quest='"..me_quest.."' or "
	  --print(q_cmd,"q_cmd")
  end
  if q_cmd=="" then
	  local P={}
	  P.success=1
	  P.quest_time=0
	  P.quest_data=nil
     return P
  else
     q_cmd=string.sub(q_cmd,1,-5)
  end
  ]]
  local cmd
  cmd="select max(quest_time),max(quest_date) from MUD_Quest where success=0 and playerID='"..player_id.."'"
 --ȷ���Ƿ񶼽⿪
  local inner_sql="select quest from MUD_Quest where success=1 and playerID='"..player_id.."'"
  cmd=cmd.." and not quest in ("..inner_sql..")"
  --print(cmd)
  DatabasePrepare ("quest", cmd)
	  rc = DatabaseStep ("quest")
   	  local P={}
	  P.success=1
	  P.quest_time=0
	  P.quest_data=nil
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("quest")
		  ----print("�����:",values[1])

		  P.quest_time=values[1]
		  P.quest_date=values[2]
		  P.success=0
		  rc = DatabaseStep ("quest")
	  end
	  DatabaseFinalize ("quest")
  return P
end

function quest:get_log_time(quest)

  local player_id=world.GetVariable("player_id")
  local player_name=world.GetVariable("player_name")
  local cmd
  cmd="select quest_time,quest_date,success from MUD_Quest where quest='"..quest.."' and playerID='"..player_id.."' order by quest_date desc limit 1"
  -- print(cmd)
  DatabasePrepare ("quest", cmd)
	  rc = DatabaseStep ("quest")
   	  local P={}
	  P.success=0
	  P.quest_time=0
	  P.quest_data=nil
	  while rc == 100 do
	      local values=  DatabaseColumnValues ("quest")
		  ----print("�����:",values[1])

		  P.quest_time=values[1]
		  P.quest_date=values[2]
		  P.success=values[3]
		  rc = DatabaseStep ("quest")
	  end
	  DatabaseFinalize ("quest")
  return P
end

local quest_msg="^(> |)�½��ϸ�����һ����Ѫ��צ�ס�$|^(> |)��������ѩ�˵�ָ�㣬������������в���֮��һ�Ӳ��գ���ʱ��Ȼ��ͨ����Ȼ�������$|^(> |)���������˷��ָ�㣬����ҽ����ͺ��ҵ����İ����ƺ��������ס�$|^(> |)���Ѿ��ҵ�����Ҫ���ˡ�$|^(> |)������ط���һ������ͨ����µ�ͨ����$"

function quest:success_msg()
  wait.make(function()
    local l,w=wait.regexp(quest_msg,10)
	if l==nil then
	    self:success_msg()
	    return
	end
	if string.find(l,"��Ѫ��צ��") then
	   self:update_status("nxsz")
	   return
	end
	if string.find(l,"��Ȼ��������") then
	   self:update_status("jsjf")
	   return
	end
	if string.find(l,"����ҽ����ͺ��ҵ����İ����ƺ���������") then
	   self:update_status("rh")
	   return
	end
	if string.find(l,"���Ѿ��ҵ�����Ҫ����") then
	   self:update_status("lbwb")
	   return
	end
	if string.find(l,"������ط���") then
	   self:success_msg()
	   self:bz5()
	   return
	end
   end)
end

function quest:ask_question()
   world.Send("ask liu about question")
   self:get_guess()
   world.Send("guess 1234")
end

function quest:get_guess()
  wait.make(function()
    --�����ĵ�������µ���1234��ȫ�Ե��������ֻ����ܶԵ��ж�����
     local l,w=wait.regexp("^(> |)�����ĵ�������µ���(.*)��ȫ�Ե���(.*)����ֻ����ܶԵ���(.*)����$|^(> |)��������ǽ�ϰ��˼��£����������ˣ�����Խ��鷿ȥ�ˡ���$",5)
     if l==nil then
	    self:get_guess()
	    return
	 end
	 if string.find(l,"����Խ��鷿ȥ") then
		world.ColourNote ("red", "yellow", "guess ok")
		world.Send("w")
		world.Send("look shelf")
		world.Send("e")
		wait.time(1)
		self:finish()
	    return
	 end
	if string.find(l,"��µ���") then
		local status=w[2]..w[3]..w[4]
		--print(stauts)
		local rc=self:guess(status)

		self:get_guess()
	    return
	 end
   end)
end

function quest:guess(status)
	local sql="Select [Return_Data] From MUD_Guess where [Data]='"..status.."'"
	print(sql)
	DatabasePrepare ("db2", sql)

  	 local rc=DatabaseStep ("db2")
	  local gs=""
	  while rc == 100 do
	     ------print("row",i)
	     local values= DatabaseColumnValues ("db2")
		 gs=values[1]
		 print(gs)
		 rc = world.DatabaseStep ("db2")
	  end
	  print(rc)
	  world.DatabaseFinalize ("db2")
	  --local f=function()
	    print(gs)
	    world.Send("guess "..gs)
	  --end
	  --f_wait(f,1)
end

--ԽŮ��
function quest:yuenvjian()
    local q_record=self:get_log_time("yuenvjian")
	local last_yuenvjian_time=q_record.quest_time
	local yuenvjian_time=os.time()

	local interval=os.difftime(yuenvjian_time,last_yuenvjian_time)
	print(interval,":��","ԽŮ��ʱ����")
  if interval>3600*24 and q_record.success==0 then
    local w=walk.new()
    w.walkover=function()
	   local b=busy.new()
	   b.Next=function()
		  world.Send("ask aqing about ԽŮ��")
	      --world.SetVariable("last_yuenvjian_time",yuenvjian_time)
		   self:log_time("yuenvjian")
		  local f=function()
	        self:Execute()
		  end
		  f_wait(f,30)
	   end
	   b:check()
    end
    w:go(5009)
  else
     self:Execute()
  end
end
--��������
--��������
function quest:check_donfang()
   local _R=Room.new()
   _R.CatchEnd=function()
      print(_R.roomname)
      if _R.roomname=="С��" then
		self:dongfang(true)
	  else
	    self:dongfang()
	  end
   end
   _R:CatchStart()
end

function quest:kill_dongfang(cmd)
   		  local _pfm=world.GetVariable("quest_pfm") or ""

		  marco(cmd)

		  --��������˵�����������ں�æ��û��Ȥ��������¡���
		  wait.make(function()
		     local l,w=wait.regexp("^(> |)�������ܽ��ǡ��������䡹����˫����һ�꣬����������һ��ԭ��ʮ�ֳ¾ɵĲ�ҳ��ʱ������Ƭ��$|^(> |)���򶫷����ܴ����йء��������䡻����Ϣ��$|^(> |)���򶫷����ܴ����йء������С�����Ϣ��$",10)
			 if l==nil then
			    self:check_donfang()
			    return
			 end
			 if string.find(l,"������") then

			     local f=function()
		   	       shutdown()
			       self:log_time("ronggong")
			       local f=function()
				     self:back_ronggong()
			       end
			        f_wait(f,10)
		           end
		          self:fight(_pfm,f)
			     return
			 end

			 if string.find(l,"���򶫷����ܴ����й�") then
			     local f=function()
		   	       shutdown()
			       self:log_time("kuihua")
			       local f=function()
				     self:Execute()
			       end
			        f_wait(f,10)
		           end
		          self:fight(_pfm,f)
			     return
			 end
			 if string.find(l,"һ��ԭ��ʮ�ֳ¾ɵĲ�ҳ��ʱ������Ƭ") then
			    shutdown()
			    self:log_time("kuihua")
			    local f=function()
				self:Execute()
				end
				f_wait(f,3)

			    return
			 end
		  end)
end

function quest:dongfang(flag)
     local _pfm=world.GetVariable("quest_pfm") or ""
       local cmd=""
         if flag==nil then
		    cmd="tui qiang|open men|#2 d|w|ask dongfang about ��������|".._pfm
			local w2=walk.new()
		     w2.walkover=function()
               self:kill_dongfang(cmd)
		    end
		    w2:go(2880)
		 else
			 cmd="ask dongfang about ��������|".._pfm
			 self:kill_dongfang(cmd)
		 end

end

function quest:kuihua_getkey(quest_type)
	marco("l shujia|l shuji|na shu 1 from jia|fan shu|#wa 1000|open shu|na shu 2 from jia|fan shu|#wa 1000|open shu|na shu 3 from jia|fan shu|#wa 1000|open shu|na shu 4 from jia|fan shu|#wa 1000|open shu|na shu 5 from jia|fan shu|#wa 1000|open shu")
	wait.make(function()
       local l,w=wait.regexp("^(> |)�㻺�������йż��ļв㣬ȡ����Կ�ס�$|^(> |)����Ҫ�����еĹż���ͻȻ��һλ������̳��ϳ��˽�����$",5)

	  -- �����ķ�ҳ������������һ���в㡣
	  if l==nil then
	     self:kuihua_getkey()
	     return
	  end

	  if string.find(l,"һλ������̳��ϳ��˽���") then
	     shutdown()
	     local _pfm=world.GetVariable("quest_pfm") or ""
		 world.Send("kill zhanglao")
		  local f=function()
			 self:kuihua_getkey()
		  end
		 self:fight(_pfm,f)
	     return
	  end
	  if string.find(l,"�㻺�������йż��ļв㣬ȡ����Կ��") then
	     shutdown()
	    local f=function()
	      local b=busy.new()
	   	  b.Next=function()
	       self:dongfang()
		  end
	   	  b:check()
		end
		f_wait(f,2)
	     return
	  end

	end)
end

function quest:kuihua()
  local q_record=self:get_log_time("kuihua")
	local last_kuihua_time=q_record.quest_time
	local kuihua_time=os.time()

	local interval=os.difftime(kuihua_time,last_kuihua_time)
	print(interval,":��","��������ʱ����")
  if interval>3600*24 and q_record.success==0 then
    local w=walk.new()
    w.walkover=function()
        self:kuihua_getkey()
	end
    w:go(2881)
  else
     self:Execute()
  end
end

function quest:gumu_yufengzhen()
   local w=walk.new()
   w.walkover=function()

       world.Send("qu yufeng zhen")
	   local b=busy.new()
	   b.Next=function()
	       self:gumu_hubo()
	   end
	   b:check()
   end
   w:go(94)
end

function quest:gumu_hubo(flag)
  --С��Ů
  local w=walk.new()
  w.walkover=function()

	 if flag==nil then
	    marco("ask longnv about �ܲ�ͨ|#wa 3000|ask longnv about �����")
	   local f=function()
	     local w2=walk.new()
	     w2.walkover=function()
	       world.Execute("give 1 yufeng zhen to zhou|ask zhou about С��Ů")
		   local f=function()
		      self:gumu_hubo(false)
		   end
		   f_wait(f,3)
	     end
	     w2:go(4121)
	    end
	    f_wait(f,5)
	else
		world.Send("ask longnv about �ܲ�ͨ")
		local f=function()
		   local sp=special_item.new()
		   local item="<����>�����"
		   sp.cooldown=function()
		     world.Send("n|w|s")
	         self:yunu_xinjing()
		   end
		   local equip={}
		   equip=Split(item,"|")
           sp:check_items(equip)
		end
		f_wait(f,3)
	 end
  end
  w:go(3018)
end

function quest:yunu_xinjing_ok()
wait.make(function()
	local l,w=wait.regexp("^(> |)��ϲ��.*�ɹ����ù�Ĺ�ķ���ͨȫ�潣������Ů�����ĵ���˫����赣�",5)
	if l==nil then
		self:yunu_xinjing()
		return
	end
	if string.find(l,"��ϲ") then
		sj.log_catch("gmhb",300)
		local b=busy.new()
		b.Next=function()
			self:Execute()
		end
		b:check()
		return
	end
end)
end

function quest:yunu_xinjing()
wait.make(function()
	world.Execute("pray pearl;yun xinjing;dazuo 3000;dazuo 2000;dazuo 1000;yun qi")
	local l,w=wait.regexp("^(> ;)���������񣬿���Ĭ���˼���񵡣�������ɢ������Ů�ľ�����Ҫ����$",5)
	if l==nil then
		self:yunu_xinjing()
		return
	end
	if string.find(l,"����������") then
		self:yunu_xinjing_ok()
		return
	end

end)
end

function quest:gumu_jiuyin()
 local w=walk.new()
 w.walkover=function()

    world.Execute("look map;look ceiling;look zi")
	self:Execute()
 end
 w:go(5071)
end

function quest:gumu_shike()
   local w=walk.new()
   w.walkover=function()
    world.Send("ask yang about ��Ĺʯ��")
	  local b=busy.new()
	  b.Next=function()
	     self:gumu_jiuyin()
	  end
	  b:check()
   end
   w:go(3017)

end

--��Ĺ����ʯ�̴���
--[[

	if ( arg =="zi") {
		write(HIY"��������ЩС�֣��ƺ�����һЩ�书Ҫ����\n"NOR)|
		if( !me->query_temp("ceiling")
                 || me->query("combat_exp", 1) < 2000000 ){
			tell_object(me,HIY"��������д�ļ����Ѷ����㿴��һ�ᣬ�����Լ�����������㣬ֻ�÷����ˡ�\n"NOR)|
			return 1|
		}
                i = (me->query("combat_exp") - 1000000) / 500000|
		time = time() - me->query("quest/jiuyingm/time")|
                if ( me->query("quest/jiuyingm/fail") >= i && me->query("registered") < 3 ){
			tell_object(me,HIY"��������д�ļ����Ѷ����㿴��һ�ᣬ�����Լ��ϴο����Ժ����ӵ��������������������塣\n"NOR)|
			return 1|
		}
                if ( time < 86400 ){
			tell_object(me,HIY"��������д�ļ����Ѷ������Դ��ϴο�����˼��һֱ�޷�ƽ��������������Ҫ�ٹ�һ��ʱ�䡣\n"NOR)|
			return 1|
		}

                 if(( random(me->query("kar")) > 28
                 && me->query("kar") <31
                 && me->query("buyvip")
                 && me->query("combat_exp")>=2000000
                 && random(10) == 3
                 && me->query("int") > 30)
         || me->query("quest/jiuyingm/pass") ){

			write(HIR"�㶸ȻһƳ�䣬��������С�֡������澭�ڹ�Ҫ���������˷ܼ��ˡ�\n"NOR)|
			write(HIC"���о���һ�£�����Ӧ�����ж�(yandu)Щ���¾�(daode-jing) \n"NOR)|
			write(HIB"�����湦(jiuyin-zhengong)�Լ�������(jiuyin-shenfa)��\n"NOR)|
                        write(HIM"������צ(jiuyin-shenzhua)�Լ�����������(yinlong-bian)��Ƥë��\n"NOR)|
			if( !me->query("quest/jiuyingm/pass"))
				log_file("quest/jiuyin",
					sprintf("%-18sʧ��%s�κ��ڹ�Ĺʯ���ϵõ������澭������%d����%d��\n",
						me->name(1)+"("+capitalize(getuid(me))+")",
						chinese_number(me->query("quest/jiuyingm/fail")),
						me->query("kar"),
						me->query("int")
					), me
				)|
			me->set("quest/jiuyingm/pass", 1)|
		}

         if(( random(me->query("kar")) >= 28
                 && random(15) == 10
                 && me->query("int") > 40)
                 && me->query_temp("quest/gmsuper/ask")
         || me->query("quest/gmsuper/pass") ){

                        write(HBMAG"\n�㿴�������������С���Աߣ��������һЩͼ����ʽ���ƺ����Ĺ��ѧ�йء�\n"NOR)|
			write(HIW"����ϸ�о���һ�£�����ʯ�������̻��ģ����������С��Ů�ı�����ѧ��Ҫ�� \n"NOR)|
			write(HIW"������������ļ�¼�˹�Ĺ��ѧ�����������һ����������澭����󡹦����Ȼ�����ƺ�����仯�� \n"NOR)|
	   if( !me->query("quest/gmsuper/pass"))
				log_file("quest/gmsuper",
					sprintf("%-18sʧ��%s�κ��ڹ�Ĺʯ���ϵõ���Ĺ��ѧ�ܸ٣�����%d����%d��\n",
						me->name(1)+"("+capitalize(getuid(me))+")",
						chinese_number(me->query("quest/jiuyingm/fail")),
						me->query("kar"),
						me->query("int")
					), me
				)|
   me->set("quest/jiuyingm/pass", 1)|
                        me->set("quest/gmsuper/pass", 1)|
		}

		else {
			me->add("quest/jiuyingm/fail", 1)|
			me->set("quest/jiuyingm/time", time())|
			log_file("quest/jiuyin",
				sprintf("%-18s���%s�Σ�û�з��ֹ�Ĺʯ���ϵľ����澭��\n",
                      			me->name(1)+"("+capitalize(getuid(me))+")",
                      			chinese_number(me->query("quest/jiuyingm/fail"))
                      		), me
                      	)|
			write(HIY"��������д�ļ����Ѷ����㿴��һ��ͷ����ˡ�\n"NOR)|
		}
		me->delete_temp("ceiling")|
		return 1|
	}
	return notify_fail("��Ҫ��ʲô��\n")|
]]
--[[ ½��˫���ַ������
"/d/emei/xiaowu",		"/d/wudang/xiaolu1",		"/d/xiangyang/zhuquemen",
"/d/xiangyang/hanshui1",	"/d/fuzhou/road1",		"/d/xueshan/xuelu2",
"/d/xueshan/houzidong",		"/d/suzhou/lingyansi",		"/d/suzhou/liuyuan",
"/d/jiaxing/tieqiang",		"/d/hz/longjing",		"/d/hz/huanglong",
"/d/hz/yuhuang" 1206,		"/d/hz/tianxiang",		"/d/miaojiang/jiedao4",
"/d/foshan/duchang",		"/d/huanghe/shulin5",		"/d/hz/changlang1",
"/d/hz/yuquan",			"/d/hz/longjing",		"/d/xingxiu/shamo3",
"/d/wudang/xuanyue",		"/d/emei/guanyinqiao",		"/d/emei/basipan3",
"/d/tiezhang/shanmen",		"/d/tiezhang/hclu",		"/d/xueshan/huilang4",
"/d/emei/caopeng",		"/d/mingjiao/bishui",		"/d/mingjiao/shanting",
"/d/fuzhou/haigang",		"/d/fuzhou/laozhai",		"/d/xingxiu/shamo2",
"/d/jiaxing/nanhu",		"/d/village/caidi",		"/d/shaolin/songshu2",
"/d/xiangyang/tanxi",		"/d/huashan/husun",		"/d/huashan/yunu",
"/d/mr/yanziwu/xiaojing2",	"/d/mr/mtl/liulin",		"/d/suzhou/shihu",
"/d/suzhou/xuanmiaoguan",	"/d/suzhou/zijinan",		"/d/hengshan/cuiping2",
"/d/hengshan/guolaoling",	"/d/shaolin/talin1",		"/d/wudang/houshan/husunchou",
"/d/shaolin/shanlu8",		"/d/xueshan/shanlu7",		"/d/foshan/road10",
"/d/foshan/xiaolu2",		"/d/emei/jiulaodong",		"/d/hengshan/beiyuemiao",
"/d/gb/xinglin2",		"/d/city/shangang",		"/d/fuzhou/zhongxin",
"/d/huanghe/huanghe4",		"/d/lanzhou/shamo",		"/d/emei/gudelin3",
"/d/cangzhou/dongjie1",		"/d/tanggu/center",		"/d/putian/xl6",
"/d/dali/wuliang/songlin6",	"/d/gumu/xuantie/linhai8",	"/d/gumu/jqg/zhulin5",
function quest:lu_place()
  local lu_place={
   "xiaowu"=-1,  --������� ���̨
   "xiaolu1"=2045,
   "zhuquemen"=225,
   "hanshui1"=203,
   "road1"=1219,
   "xuelu2"=3106,
	"houzidong"=1667,
	"lingyansi"=1152,
	"liuyuan"=1030,
	"tieqiang"=4012
	�������� 1891
  }
end]]

--[[
���ÿ�ʼ��e|s|s|#4 search qiangjiao|i|#wa 10000|n|n|w|n|tang bed|ban shiban|out|#6 e|#6 w|#6 n|#6 s|#wa 10000|enter|tui guangai|tang guan|use fire|#9 search|turn ao left|#wa 5000|ti up|l map|l ceiling|l zi
5026 climb cliff

2351 yuyi cao
2244  sangang shilue

2028 ask daozhang about ҩ��;ask daozhang about ֻ��
2640 ask lao weng about ���
2028 askk daozhang about ���
]]

function quest:medicinebook1()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy yuyi cao")
   end
   w:go(2351)
end

function quest:medicinebook2()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy sangang shilue")
   end
   w:go(2244)
end

function quest:medicinebook3()


   local w=walk.new()
   w.walkover=function()
      world.Send("buy ya")

	  local w=walk.new()
      w.walkover=function()
        world.Send("ask laoban about ҩ��")

      end
      w:go(95)
	  --ask kong about ҩ��
	  --give kong ya
	  --�տն�˵����������ô�������Ȿ�������ȥ��.��
   end
   w:go(51)
end

function quest:getbook()
  wait.make(function()
    local l,w=wait.regexp("^(> |)����տն������йء�ҩ�䡻����Ϣ��$",3)
	if l==nil then
	  coroutine.resume(quest.sp_co)
	  return
	end
	if string.find(l,"����տն������й�") then
	   wait.time(1)
	   world.Send("give kong ya")
	   quest.sp_co=nil
	   return
	end
  end)

end


function quest:askkong()
 local cmd="ask kong about ҩ��"
   local route={}
    table.insert(route,"ne|"..cmd.."|sw|"..cmd.."|n|"..cmd.."|s|"..cmd.."|s|"..cmd.."|set action ����")
    table.insert(route,"n|"..cmd.."|e|"..cmd.."|e|"..cmd.."|w|"..cmd.."|w|"..cmd.."|set action ����")
	table.insert(route,"w|"..cmd.."|n|"..cmd.."|s|"..cmd.."|set action ����")
	table.insert(route,"s|"..cmd.."|n|"..cmd.."|w|"..cmd.."|set action ����")
	table.insert(route,"s|"..cmd.."|w|"..cmd.."|e|"..cmd.."|set action ����")
	table.insert(route,"n|"..cmd.."|n|"..cmd.."|s|"..cmd.."|set action ����")
	table.insert(route,"w|"..cmd.."|n|"..cmd.."|s|"..cmd.."|set action ����")
	table.insert(route,"s|"..cmd.."|n|"..cmd.."|w|"..cmd.."|set action ����")
	table.insert(route,"n|"..cmd.."|s|"..cmd.."|s|"..cmd.."|set action ����")
	table.insert(route,"n|"..cmd.."|w|"..cmd.."|w|"..cmd.."|s|"..cmd.."|e|"..cmd.."|e|"..cmd.."|w|"..cmd.."|w|"..cmd.."|w|"..cmd.."|e|"..cmd.."|s|"..cmd.."|e|"..cmd.."|w|"..cmd.."|w|"..cmd.."|set action ����")
    local w=walk.new()
	w.walkover=function()
	 quest.sp_co=coroutine.create(function()

	    for _,r in ipairs(route) do
		  marco(r)
		  self:getbook()

	      coroutine.yield()
		end
		--
		--[[�� �� ��������
		local f=function()
		   self:buy_tools(tools_id,itemid)
		end]]

		--print("���2s")
		--f_wait(f,2)
	 end)

	 coroutine.resume(quest.sp_co)
	end
	w:go(75)
end

function quest:medicinebook4()
   local w=walk.new()
   w.walkover=function()
      marco("ask daozhang about ҩ��|#wa 1000|ask daozhang about ֻ��")
   end
   w:go(2028)
end

function quest:medicinebook5()
   local w=walk.new()
   w.walkover=function()
      world.Execute("ask lao weng about ���")

	  local f=function()
	   local w=walk.new()
       w.walkover=function()
        world.Execute("ask daozhang about ���")
       end
       w:go(2028)
	  end
	  f_wait(f,2)
   end
   w:go(2640)
end

--[[
��������ѧ��������ҩ�̿���á�(0 lev-41 lev)

���׾���ѧ����ѦĻ��������ã�from �������ڽ� {w;n;w;w;w;sw;#7 n} back {#7 s;ne;e;e;e;s;e} ��
(41 lev-81 lev)
�߼�����ѧ����ƽһָ������á�from �������ڽ� {w;n;e} back {w;s;e}��
(81 lev-121 lev)
��ĸ��ۡ���ѦĻ����ask xue about ѧ�ʣ�ѦĻ��˵��������˵�����书���������������ž�ask xue about �书��ѦĻ��˵��������л���һ�úñ���ġ���ʹ�� teach xue <skill> ��ָ���ҡ�����Ȼ���������ѡһ�����书ȥ������Ȼ����ask xue about ѧ�ʣ�ѦĻ��˵��������ȥ�ú��о��ɡ�����Ѧ��ҽ����һ����ĸ��ۡ�(121 lev-141 lev)
��˼��ǧ�﷽����ѦĻ����ask xue about ���ˣ�ѦĻ��˵��������˵���˱������ɵĶ����������Զ�ҩ���Լ�ȴ��֪����ѦĻ��˵���������ҵ�***����ѦĻ��˵��������ȥ��ȸ�����ҿ�����ѦĻ���������ڳ����˱�ʾ��л��ѦĻ��˵����������ƿҩˮ��heal *** �Ϳ����ˡ���heal ***������ָ΢������ҩˮ������***���ٻ�ȥxue����ͻ�õ��ˡ�(141 lev-151 lev)
�Ƶ��ھ�����ƽһָ��ask ping about ɱ�ˣ�ƽһָ������ȥɱһ����ң�ɱ��������corpse�и��ͷ��ƽһָ�Ϳ����ˡ������û����������˾Ͳ�����ask ping�ˣ�ƽһָ��˵�����ڵȱ���ɱ�ˣ�����㲻��ɱ�ˣ�������ƽһָask ping about ɱ�� һ�ξͻ�ȡ���ˡ�
�Ƶ��ھ�����ƽһָ��ask ping about ɱ�ˣ�ƽһָ������ȥɱһ����ң�ɱ��������corpse�и��ͷ��ƽһָ�Ϳ����ˡ������û����������˾Ͳ�����ask ping�ˣ�ƽһָ��˵�����ڵȱ���ɱ�ˣ�����㲻��ɱ�ˣ�������ƽһָask ping about ɱ�� һ�ξͻ�ȡ���ˡ�
]]

function quest:jmxbook1()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy jingmai book")
   end
   w:go(95)
end

function quest:jmxbook2()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy jingmai book")
   end
   w:go(623)
end

function quest:jmxbook3()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy jingmai book")
   end
   w:go(273)
end

function quest:jdhj_start()
    local w=walk.new()
  w.walkover=function()
   world.Send("askk gongsun about �𵶺ڽ�")
   local Quest_log= function()
		  self:quest_log(5)
		   local b=busy.new()
		   b.Next=function()
		     self:next_quest()
		   end
		   b:check()
		end
   f_wait(Quest_log,5)
  end
  w:go(2998)
end

function quest:nqg_start()
 local q_record=self:get_log_time("nqg")
	local last_nqg_time=q_record.quest_time
	local nqg_time=os.time()

	local interval=os.difftime(nqg_time,last_nqg_time)
	print(interval,":��","������ʱ����")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

    local w=walk.new()
  w.walkover=function()
   world.Send("askk ying about ����������")
   local Quest_log= function()
		  self:quest_log(5)
		   local b=busy.new()
		   b.Next=function()
		     self:Execute()
			  self:log_time("nqg")
		   end
		   b:check()
		end
   f_wait(Quest_log,1)
  end
  w:go(435)
  else
     self:Execute()
  end
end

function quest:xx_laoyue_start()
    local w=walk.new()
  w.walkover=function()
   world.Send("ask zhaixing about ��������")
   local Quest_log= function()
		  self:quest_log(10)
		   local b=busy.new()
		   b.Next=function()
		     self:next_quest()
		   end
		   b:check()
		end
   f_wait(Quest_log,10)
  end
  w:go(1969)
end
--[[
Ȼ��ȥ����4������תת��ע��֮ǰҩ���������룬���״��á��ᷢ��һ�������¼������ǵ��㵱Ȼͦ������ˣ�����һ��������֮�󣬳������û�ɽ�����������ֵ�boss��
�������ɱ�����ͳ�������������


��ֻ��������ʹ�û�ɽ���������ޱȣ���ʱ�����뵽��ʯ��
�ϵĽ��С�
ͻȻ�������������ٴδ�Ħ�£���������µķ��֣�


Ȼ��ص��ܶ�


chuaimo ����
�������ʯ���ϵĽ��У�������Ħ�ղ�������˵Ľ��У���Ȼ�����е�˼·����������
�����͸����
chuaimo ����
�������ʯ���ϵĽ��У�������ղ����������ʹ�õ�������ͻȻ�������
�⡰�з����ǡ������һ�У��㲻��������Ц����������~��ԭ����˰�!��
]]
function quest:hs_sgy()


	   local sp=special_item.new()
       sp.cooldown=function()
	      local w=walk.new()
		  w.walkover=function()
             self:mianbi()
		  end
		   w:go(1537)
       end
   	   local equip={}
	   equip=Split("<��ȡ>����","|")
       sp:check_items(equip)
end

function quest:hs_fengyi(manual_operate)
 local q_record=self:get_log_time("fy")
	local last_fy_time=q_record.quest_time
	local fy_time=os.time()

	local interval=os.difftime(fy_time,last_fy_time)
	print(interval,":��","�з�����ʱ����")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()

     world.Send("askk yue about ��ɽʯ��")
	 local f=function()
	   self:hs_sgy()
	 end
	 f_wait(f,5)

   --f_wait(Quest_log,40)
  end
  w:go(1532)
  else
     self:Execute()
  end
end

function quest:hs_jjs_start(manual_operate)
  local q_record=self:get_log_time("jjs")
	local last_jjs_time=q_record.quest_time
	local jjs_time=os.time()

	local interval=os.difftime(jjs_time,last_jjs_time)
	print(interval,":��","�ؽ�ʽʱ����")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
  self:log_time("jjs")
   world.Send("ask mu about �ؽ�ʽ")
   local Quest_log= function()
		 -- self:quest_log(50)
		   local b=busy.new()
		   b.interval=10
		   b.Next=function()
		     self:Execute()

		   end
		   b:check()
		end
   f_wait(Quest_log,40)
  end
  w:go(1508)
  else
     self:Execute()
  end
end

function quest:wd_taoyue_start(manual_operate)
  local q_record=self:get_log_time("taoyue")
	local last_taoyue_time=q_record.quest_time
	local taoyue_time=os.time()

	local interval=os.difftime(taoyue_time,last_taoyue_time)
	print(interval,":��","��������ʱ����")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then
     local w=walk.new()
	 w.walkover=function()
		world.Send("guanmo ����")
		local Quest_log= function()
		  self:quest_log(50)
		   local b=busy.new()
		   b.Next=function()
		     self:Execute()
			  self:log_time("taoyue")
		   end
		   b:check()
		end
		f_wait(Quest_log,40)

	 end
	 w:go(2044)
  else
     self:Execute()
  end
end

function quest:ss_guanwu_songtao_start()
     local w=walk.new()
	 w.walkover=function()
		self:ss_guanwu_songtao()
	 end
	 w:go(328)
end

function quest:ss_guanrifeng()
   local w=walk.new()
	 w.walkover=function()
		world.Execute("guan ri;guanwu songtao;west")
		local Quest_log= function()
		  self:quest_log(50)
		end
		f_wait(Quest_log,1)
        local b=busy.new()
		b.Next=function()
		   self:log_time("songyang")
		   self:Execute()
		end
		b:check()
	 end
	 w:go(311)
end

function quest:ss_songyang(manual_operate)
   local q_record=self:get_log_time("songyang")
	local last_songyang_time=q_record.quest_time
	local songyang_time=os.time()

	local interval=os.difftime(taoyue_time,last_songyang_time)
	print(interval,":��","��ɽ����ʱ����")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

	   self:ss_guanwu_songtao()
  else
     self:Execute()
  end
end

function quest:ss_guanwu_songtao(index)
  --328
  local path="wu;nd;nu;nu;nu;nu;nw;nw;ne;nu;n;n;n;n;n;n;e;e;w;w;w;w;e;e;n;nu;n;e;e;e;w;w;w;w;w;w;e;e;e;nu;nu;nu"
  --311
  local paths={}
  paths=Split(path,";")
  if index==nil then
     index=1
  end
  local n=table.getn(paths)
  if index>n then
	 index=1
	 local f=function()
	    self:ss_guanwu_songtao_start()
	 end
	 f_wait(f,1.5)
	 return
  end
   world.Send(paths[index])
   world.Send("ask fei about ���շ�")
	wait.make(function()
       local l,w=wait.regexp("^(> |)����û������ˡ�$|^(> |)����ѱ�����йء����շ塻����Ϣ��$",5)
	    if l==nil then
		   index=index+1
		   self:ss_guanwu_songtao(index)
		   return
		end
		if string.find(l,"����ѱ�����й�") then
		   local b=busy.new()
		   b.Next=function()
		      self:ss_guanrifeng()
		   end
		   b:check()
		   return
		end
	    if string.find(l,"����û�������") then
	        index=index+1
			self:ss_guanwu_songtao(index)
	       return
	    end
	end)


    --world.Send("guanwu songtao")
end

--�Զ���xxdf
--�����Ʒ
function quest:xxdf_item_Next()
  --�ص�����
end

function quest:guanglingsan()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy tie qiao")
	  local f=function()
	  w.walkover=function()
	   world.Send("wa mu")
	   world.Send("drop tie qiao")
	   self:xxdf_item_Next()
	  end
	  w:go(347)
	  end
	  f_wait(f,5)
   end
   w:go(568)

end

function quest:ouxuepu()
  local w=walk.new()
  w.walkover=function()
   self.finish=function()
      world.Send("w")
       world.Send("look shelf")
	   self:xxdf_item_Next()
   end
    self:ask_question()

  end
  w:go(626)
end

function quest:hua()
local w=walk.new()
   w.walkover=function()
     world.Send("move wan")
     world.Execute("#3 zhuan tiewan zuo")
     world.Execute("#7 zhuan tiewan right")
     world.Send("open xiang")
     world.Send("open jiaceng")
     world.Execute("#30 fan painting")
     world.Send("out")
	 local f=function()
       world.Execute("#10 fan painting;out")
	   self:qxwxj_yinlv()
	 end
	 f_wait(f,2)
   end
   w:go(1833)
end

function quest:kill_zuo()
 local w=walk.new()
   w.walkover=function()

      world.Send("kill zuo")
	   local _pfm=world.GetVariable("quest_pfm") or ""

	   world.Execute(_pfm)
	  local f=function()
	     --world.Send("get shuaiyi tie from corpse")
	     world.Send("get wuyue lingqi from corpse")
		 world.Send("get gold from corpse")
		 self:xxdf_item_Next()

	  end
	    self:fight(_pfm,f)
   end
   w:go(311)

end

function quest:meizhuang_quest()

end

function quest:enter_meizhuang()
    wait.make(function()
       world.Send("huida �����������")
       world.Send("show wuyue lingqi")
	   world.Send("s")

	   local l,w=wait.regexp("������",5)
	   if l==nil then
	      self:enter_meizhuang()
	      return
	   end
	   if string.find(l,"������") then
		  self:meizhuang_quest()
	      return
	   end
       --world.Execute("s;s;s;e;e;s;s;e;s;w;w;w;n")
       --world.Send("give huang guangling san")
    end)

end

function quest:xxdf()
--1180
  local w=walk.new()
  w.walkover=function()

      local w1=walk.new()
       w1.walkover=function()
         marco("qiao gate 4 times|#wa 1000|qiao gate 2 times|#wa 1000|qiao gate 5 times|#wa 1000|qiao gate 3 times")
         self:enter_meizhuang()
      end
      w1:go(2624)
  end
  w:go(1180)

end

function quest:pumo()
	self.meizhuang_quest=function()
      world.Execute("w;w;s;s;s;w")
       marco("askk sheng about ��ī���齣|#wa 2000|give sheng tu|#wa 2000|askk sheng about ��ī���齣|#wa 1000|guanmo ��")
	 --  world.Send("")
	 --  world.Send("askk sheng about ��ī���齣")
	 -- world.Send("guanmo ��")
	  --back
	  local f=function()
	     world.Execute("e;e;n;n;n;e;e")
		 self:qxwxj_yinlv()
      end
	  f_wait(f,8)
	end
	self:xxdf()
end

function quest:qxwxj_yinlv()
   --self.meizhuang_quest=function()
     world.Execute("s;s;s;e;e;s;s;e;s;w;w;w;n")
	  world.Send("give huang guangling san")
	  world.Send("ask huang about ��������")
	--back
	local f=function()
	   world.Execute("s;e;e;e;n;w;n;n;w;w;n;n;n")
	   self:log_time("wxj")
        world.Send("drop lingqi")
        self:leave_meizhuang()
	end
	f_wait(f,8)
  --end
  --self:xxdf()
end

function quest:leave_meizhuang()
    world.Execute("#4 n")
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
	 if _R.roomname=="÷��"  then
	    self:Execute()
	 else
	    local f=function()
	       self:leave_meizhuang()
		end
		f_wait(f,5)
	 end
   end
  _R:CatchStart()

end

function quest:wxj(manual_operate)
  -- pumo �� ���� ���
   local q_record=self:get_log_time("wxj")
	local last_wxj_time=q_record.quest_time
	local wxj_time=os.time()

	local interval=os.difftime(wxj_time,last_wxj_time)
	print(interval,":��","���ν����")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then
       self.xxdf_item_Next=function()

          self.xxdf_item_Next=function()
		     self.xxdf_item_Next=function()
		       self:pomo()
			 end
			 self:hua()
		  end
		  self:kill_zuo()

       end
       self:guanglingsan()

   else
         self:Execute()
   end
end

--1162
function quest:tianmo(manual_operate)
  local q_record=self:get_log_time("tianmo")
	local last_tianmo_time=q_record.quest_time
	local tianmo_time=os.time()

	local interval=os.difftime(tianmo_time,last_tianmo_time)
	print(interval,":��","��ħ�Ƽ���")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
     world.Send("askk ren about ��ħ�ƾ���")
	 local f=function()
	    self:Execute()
		self:log_time("tianmo")
	 end
	 f_wait(f,2)
  end
  w:go(1162)
   else
         self:Execute()
   end
end

function quest:qbwh(manual_operate)
--ǧ���� ���ν���
local q_record=self:get_log_time("qbwh")
	local last_qbwh_time=q_record.quest_time
	local qbwh_time=os.time()

	local interval=os.difftime(qbwh_time,last_qbwh_time)
	print(interval,":��","ǧ���򻯾���ʱ����")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then
    local w=walk.new()
     w.walkover=function()
     world.Send("askk ren about ǧ���򻯾���")
	 local f=function()
	    self:Execute()
		self:log_time("qbwh")
	 end
	 f_wait(f,2)
  end
  w:go(1162)
  else
      self:Execute()
  end
end

function quest:ronggong_kill_dongfang(flag)
     local _pfm=world.GetVariable("quest_pfm") or ""
	 print("PK ��������")


    local w=walk.new()
    w.walkover=function()
        local cmd="tui qiang|open men|#2 d|w|ask dongfang about ������|#wa 1000|kill dongfang|".._pfm

        self:kill_dongfang(cmd)
	end
    w:go(2880)

end


function quest:ronggong_dongfang()

    self.dongfang=function(flag)
	   --
	   print("�Ҷ�������")
	   self:ronggong_kill_dongfang(flag)
	end
    local w=walk.new()
    w.walkover=function()
        self:kuihua_getkey()
	end
    w:go(2881)

end

function quest:back_ronggong()
 local w=walk.new()
  w.walkover=function()
     world.Send("ask ren about ���Ǵ��ڹ�")
	 self:log_time("ronggong")
	 self:Execute()
  end
  w:go(1162)
end

function quest:ronggong(manual_operate)
--ask ������ ���Ǵ��ں�    sz ��������  ask ���� ������   ɱ��
    local q_record=self:get_log_time("ronggong")
	local last_ronggong_time=q_record.quest_time
	local ronggong_time=os.time()

	local interval=os.difftime(ronggong_time,last_ronggong_time)
	print(interval,":��","���Ǵ��ں�ʱ����")
  if (interval>3600*24 and q_record.success==0) or manual_operate==true then
--��������  ask  ���Ǵ��ں�
 local w=walk.new()
  w.walkover=function()
     world.Send("ask ren about ���Ǵ��ڹ�")
	 local f=function()
	    self:ronggong_dongfang(manual_operate)
	 end
	 f_wait(f,3)
  end
  w:go(1162)
   else
     self:Execute()
  end
end
--����
function quest:huayu(manual_operate)
   local q_record=self:get_log_time("huayu")
    local last_huayu_time=q_record.quest_time
	local huayu_time=os.time()

	local interval=os.difftime(huayu_time,last_huayu_time)
	print(interval,":��","���컨��ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
     world.Send("ask qu about ���컨�����")
	 self:log_time("huayu")
	 self:Execute()
  end
  w:go(2873)
  else
     self:Execute()
  end
end
--ͯ����
function quest:tianmodao(manual_operate)
  local q_record=self:get_log_time("juedao")
    local last_juedao_time=q_record.quest_time
	local juedao_time=os.time()

	local interval=os.difftime(juedao_time,last_juedao_time)
	print(interval,":��","���컨��ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
  local w=walk.new()
  w.walkover=function()
     world.Send("ask tong about ��ħ����")
	 self:log_time("juedao")
	 self:Execute()
  end
  w:go(2868)
   else
     self:Execute()
  end
end

function quest:qz_haotian_lianhuan_finish()
  local l=wait.make(function()
    local l,w=wait.regexp("^(> |)�����ǰ��죬���޷����򱱶��������Ʊ仯��$|^(> |)����ϥ�������������죬�������ϱ���������ת�仯�����г����䣬������ȣ�$|^(> |)������̫Ƶ����.*$",5)
	if l==nil then

	   self:qz_haotian_lianhuan_finish()
	   return
	end
	if string.find(l,"�����ǰ��죬���޷����򱱶��������Ʊ仯") then
	  local f=function()
	      world.Send("canwu ��������")
	      self:qz_haotian_lianhuan_finish()
	   end
	   f_wait(f,10)
	   return
	end
    if string.find(l,"������̫Ƶ����") then
	   world.Execute("d;ed;sd;wd;out")
	    self:Execute()
		return
	end
    if string.find(l,"����ϥ��������������") then
		world.AddTimer ("lianhuan_timer", 0, 0, 10, "look", timer_flag.Enabled + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
		world.SetTimerOption ("lianhuan_timer", "send_to", 10)
		local f=function()
	      local b=busy.new()
		  b.interval=15
          b.Next=function()
           self:log_time("qz_lianhuan")
	       world.Execute("d;ed;sd;wd;out")
	       world.DeleteTimer("lianhuan_timer")
	       self:Execute()
	      end
	     b:check()
    	end
	    f_wait(f,90)
	   return
	end
  end)

end



function quest:qz_haotian_lianhuan(manual_operate)

--4151
--���������ƾ���
local q_record=self:get_log_time("qz_lianhuan")
    local last_qz_lianhuan_time=q_record.quest_time
	local qz_lianhuan_time=os.time()

	local interval=os.difftime(qz_lianhuan_time,last_qz_lianhuan_time)
	print(interval,":��","���������ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
      world.Send("ask ma about ���������ƾ���")
	  local b=busy.new()
	  b.interval=10
	  b.Next=function()
       local w2=walk.new()
	   w2.walkover=function()
         world.Execute("ketou ��;ketou ��;ketou ��;ketou ��;ketou ��;ketou ��")
         world.Execute("ketou ��ש;ketou ��ש;ketou ��ש;ketou ��ש;ketou ��ש;ketou ��ש;rukou;eu;nu;wu;u;canwu ��������")
         self:qz_haotian_lianhuan_finish()
       end
	   w2:go(7063)
	 end
     b:check()
  end
  w:go(4151)
  else
     self:Execute()
  end
end

function quest:qz_jgys(manual_operate)

--4151
--���������ƾ���
local q_record=self:get_log_time("qz_jgys")
    local last_qz_jgys_time=q_record.quest_time
	local qz_jgys_time=os.time()

	local interval=os.difftime(qz_jgys_time,last_qz_jgys_time)
	print(interval,":��","jgysʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
      world.Send("qu yusuo jingyao")
	  local b=busy.new()
	  b.Next=function()
       local w2=walk.new()
	   w2.walkover=function()
	     world.Send("sit")
         world.Send("canwu ���������ʮ�ľ�")
		 world.Send("stand")
		world.AddTimer ("jgys_timer", 0, 0, 10, "look", timer_flag.Enabled + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
		world.SetTimerOption ("jgys_timer", "send_to", 10)
		 local f=function()

           local b=busy.new()
		   b.interval=30
		   b.Next=function()
             world.DeleteTimer("jgys_timer")
			 self:log_time("qz_jgys")

		      self:Execute()
		   end
		   b:check()
		 end
		 f_wait(f,80)
       end
	   w2:go(4162)
	 end
     b:check()
  end
  w:go(94)
  else
     self:Execute()
  end
end

--han ������han ����; han �߹�;han ʦ��

function quest:tieqiangmiao()
   local w=walk.new()
   w.walkover=function()
     world.Execute("han ����;han ����;han �߹�;han ʦ��")
   end
   w:go(4012)
end

--�������
function quest:dls_longxiang(manual_operate)
 local q_record=self:get_log_time("dls_longxiang")
 local last_dls_longxiang_time=q_record.quest_time
	local dls_longxiang_time=os.time()

	local interval=os.difftime(dls_longxiang_time,last_dls_longxiang_time)
	print(interval,":��","�������ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then


   local w=walk.new()
   w.walkover=function()

     marco("askk zhi about �����¾���|#wa 3000|answer ���������|#wa 3000|fankan jingshu|#wa 3000|canwu ���������")
	 world.AddTimer ("longxiang_time", 0, 0, 15, "look", timer_flag.Enabled +timer_flag.ActiveWhenClosed+timer_flag.Replace, "")
       world.SetTimerOption ("longxiang_time", "send_to", 10)
	 local f=function()
	  local b=busy.new()
		b.Next=function()
		   world.DeleteTimer("longxiang_time")
           self:log_time("dls_longxiang")
		   world.Execute("open door;down")
		   self:Execute()
		end
		b:check()
	 end
	 f_wait(f,90)
   end
   w:go(3060)

    else
     self:Execute()
  end
end
--���浶����

function quest:dls_hyd(manual_operate)
 local q_record=self:get_log_time("dls_hyd")
 local last_dls_hyd_time=q_record.quest_time
	local dls_hyd_time=os.time()

	local interval=os.difftime(dls_hyd_time,last_dls_hyd_time)
	print(interval,":��","���浶ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

    self:jiumozhi()
	--[[
   local w=walk.new()
   w.walkover=function()

     marco("askk zhi about �����¾���|#wa 1000|answer ���浶����")
	wait.make(function()

	  local l,w=wait.regexp(".*������̫�ڿ���.*|",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"������̫�ڿ���") then
	     self:Execute()
	     return
	  end
	  if string.find(l,"") then
	   local b=busy.new()
		b.Next=function()
            self:gotoTLS()
		end
		b:check()
	     return
	  end


	end)


   end
   w:go(3060)
]]
    else
     self:Execute()
  end
end

function quest:jiumozhi()
local w=walk.new()
   w.walkover=function()
      world.Send("give zhi jianpu")
      world.Execute("askk zhi about �����ݺ����")
	  wait.make(function()
	     local l,w=wait.regexp("^(> |)�Ħ������Ŀ�����.*",5)
		 if l==nil then

		   return
		 end

		 if string.find(l,"�Ħ������Ŀ�����") then
		     self:log_time("hyd")
	         self:Execute()
		   return
		 end
	  end)

   end
   w:go(3060)
end

function quest:get_liumai()
--Liumai jianpu
    world.Send("get liumai jianpu")
	wait.make(function()
	  local l,w=wait.regexp("�����һ���������ס�",5)

	  if l==nil then
	      self:get_liumai()
		  return

	  end
	  if string.find(l,"�����һ����������") then
	    self:jiumozhi()
	     return
	  end
	end)
end

function quest:huoyandao_liumai()
   local w=walk.new()
   w.walkover=function()
      local pfm="bei none;jifa parry huoyan-dao;jifa strike huoyan-dao;bei strike;yun longxiang;yun shield;perform daoqi"
      world.Send("alias pfm "..pfm)
      marco("baijian ���ٳ���|#wa 1000|doujian")
	  world.Send("set wimpy 100")
	  local f=function()
	     self:get_liumai()
	  end
	  f_wait(f,30)
   end
   w:go(2358)
end

function quest:gotoTLS()

   local w=walk.new()
   w.walkover=function()

     marco("askk chanshi about �ݼ����ٴ�ʦ|#wa 1000|give chanshi baitie")
	 --�Է�����������������
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)�Է�����������������$",5)
	   if l==nil then
	      self:gotoTLS()
	      return
	   end
	   if string.find(l,"�Է���������������") then

	       self:huoyandao_liumai()
		  return
	   end

	 end)
	 local f=function()
	  local b=busy.new()
		b.Next=function()
           self:huoyandao()
		end
		b:check()
	 end

   end
   w:go(1604)


end

function quest:arz_start()
  local q_record=self:get_log_time("arz")
 local last_arz_time=q_record.quest_time
	local arz_time=os.time()

	local interval=os.difftime(arz_time,last_arz_time)
	print(interval,":��","��Ȼ��ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then


   local w=walk.new()
   w.walkover=function()
     marco("askk yang about ��Ȼ������")
	 local f=function()
	  local b=busy.new()
		b.Next=function()
           self:log_time("arz")
		   self:Execute()
		end
		b:check()
	 end
	 f_wait(f,60)
   end
   w:go(3017)

    else
     self:Execute()
  end
end

function quest:qz_guilingao()
  local w=walk.new()
  w.walkover=function()
    world.Send("buy fu ling")
	 local w1=walk.new()
  w1.walkover=function()
     world.Send("buy gui jia")

	 local w2=walk.new()
	 w2.walkover=function()
	    world.Exectute("give daozhang gui jia;give daozhang fu ling")


	 end
	 w2:go(4141)
  end
  w1:go(636)

  end
  w:go(2982)


end

function quest:qixingjian(manual_operate)

local q_record=self:get_log_time("jianqi")
 local last_jianqi_time=q_record.quest_time
	local jianqi_time=os.time()

	local interval=os.difftime(jianqi_time,last_jianqi_time)
	print(interval,":��","ȫ�潣��ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
    marco("ask sun about ������|#wa 3000|ask sun about ���Ǳ���")
	local f=function()
     self:jianqi()
	end
	f_wait(f,5)

  end
  w:go(4172)

   else
     self:Execute()
  end
end


function quest:ask_jianqi()
    world.Send("askk qiu about ȫ�潣��")


	 wait.make(function()

	   local l,w=wait.regexp("^(> |)�𴦻�����˵�����������޷���������б������ǣ������ָ����ѧϰȫ�潣���Ľ������衣$|^(> |)�𴦻�����Ŀ����㣬����˵���������ɵ�ȫ�潣���������ǵ��ҹ۲������Ƕ��������Ǳ任֮����ȡǧ���򻯡������޾�֮ԭ��.*",5)
	   if l==nil then
	      self:ask_jianqi()
	      return
	   end
	   if string.find(l,"ָ����ѧϰȫ�潣���Ľ�������") then
	     local f=function()
	        self:ask_jianqi()
          end
		  f_wait(f,30)
	      return
	   end
	   if string.find(l,"�任֮��") then
           wait.time(5)
	       local b=busy.new()
		   b.Next=function()
		    world.Send("qingjiao")
            self:log_time("jianqi")
		    self:Execute()
		   end
	 	   b:check()

	   end
   end)
end

function quest:jianqi()
  local w=walk.new()
  w.walkover=function()
     self:ask_jianqi()
  end

   w:go(4152)
end

function quest:yyz(manual_operate)

 local q_record=self:get_log_time("yyz")
 local last_yyz_time=q_record.quest_time
	local yyz_time=os.time()

	local interval=os.difftime(yyz_time,last_yyz_time)
	print(interval,":��","һ��ָʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then

  local w=walk.new()
  w.walkover=function()
    marco("ask duan about һ��ָ��|#wa 3000|askk duan about ָ������|#wa 3000|askk duan about ��������")



		 local b=busy.new()
		   b.Next=function()

            self:log_time("yyz")
		    self:Execute()
		   end
	 	   b:check()
  end
  w:go(1084)

   else
     self:Execute()
  end
end


function quest:yysz(manual_operate)
local q_record=self:get_log_time("yysz")
 local last_yysz_time=q_record.quest_time
	local yysz_time=os.time()

	local interval=os.difftime(yysz_time,last_yysz_time)
	print(interval,":��","һ��ָʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
 local w=walk.new()
  w.walkover=function()
    world.Send("ask shu about һ����ָ")
	self:log_time("yysz")
		 local b=busy.new()
		   b.Next=function()

            self:log_time("yysz")
		    self:Execute()
		   end
	 	   b:check()
  end
  w:go(2728)
   else
     self:Execute()
  end
end


function quest:tiezhang_zhangdao(manual_operate)
  local q_record=self:get_log_time("zhangdao")
 local last_zhangdao_time=q_record.quest_time
	local zhangdao_time=os.time()

	local interval=os.difftime(zhangdao_time,last_zhangdao_time)
	print(interval,":��","�����Ƶ�ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()
        world.Send(" askk qiu about �����Ƶ�����")

		 local b=busy.new()
		   b.Next=function()

            self:log_time("zhangdao")
		    self:Execute()
		   end
	 	   b:check()
      end
      w:go(2389)
   else
     self:Execute()
  end


end


function quest:kurong(manual_operate)
  local q_record=self:get_log_time("kurong")
 local last_kurong_time=q_record.quest_time
	local kurong_time=os.time()

	local interval=os.difftime(kurong_time,last_kurong_time)
	print(interval,":��","��������ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()
        world.Send("askk kurong about ��������")
	     local b=busy.new()
		   b.Next=function()

            self:log_time("kurong")
		    self:Execute()
		   end
	 	   b:check()
      end
      w:go(3082)
   else
     self:Execute()
  end


end

function quest:zhenlong(manual_operate)
  local q_record=self:get_log_time("zhenlong")
 local last_zhenlong_time=q_record.quest_time
	local zhenlong_time=os.time()

	local interval=os.difftime(zhenlong_time,last_zhenlong_time)
	print(interval,":��","�������ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()
        world.Send("askk su about �������")
		world.Send("look zhenlong")

		  local b=busy.new()
		   b.Next=function()

            self:log_time("jianqi")
		    self:Execute()
		   end
	 	   b:check()

      end
      w:go(7011)
   else
     self:Execute()
   end

end

function quest:huagong(manual_operate)
  local q_record=self:get_log_time("huagong")
 local last_huagong_time=q_record.quest_time
	local huagong_time=os.time()

	local interval=os.difftime(huagong_time,last_huagong_time)
	print(interval,":��","�������ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()
        world.Send("askk ding about �����󷨰���")
		--world.Send("look zhenrong")

		 local b=busy.new()
		   b.Next=function()

            self:log_time("huagong")
		    self:Execute()
		   end
	 	   b:check()
      end
      w:go(1964)
   else
     self:Execute()
  end

end


function quest:taiji(manual_operate)
  local q_record=self:get_log_time("taiji")
 local last_taiji_time=q_record.quest_time
	local taiji_time=os.time()

	local interval=os.difftime(taiji_time,last_taiji_time)
	print(interval,":��","�䵱����ʱ����")
 	if (interval>24*3600 and q_record.success==0) or manual_operate==true then
      local w=walk.new()
      w.walkover=function()

        marco("askk zhang about ̫������|#wa 3000|askk zhang about ̫��ȭ����|#wa 30000|askk zhang about ̫��������")
	   world.AddTimer ("taiji_time", 0, 0, 15, "look", timer_flag.Enabled +timer_flag.ActiveWhenClosed+timer_flag.Replace, "")
       world.SetTimerOption ("taiji_time", "send_to", 10)
		local f=function()
		--world.Send("look zhenrong")

		 local b=busy.new()
		   b.Next=function()
		    world.DeleteTimer("taiji_time")
            self:log_time("taiji")

		    self:Execute()
		   end
	 	   b:check()
		end
		f_wait(f,120)
      end
      w:go(2772)
   else
     self:Execute()
  end

end


--[[
function quest:yyz_dbf()
  baohu ����
  418

  ask duan about ��������
  481


end


function quest:yyz_mwq()

  askk duan about ����ľ����
  g481


  #4n
  askk huanghou about ľ����
  askk huanghou about ����

   w:go(1084)
   w:go(611)
   baohu ľ����
end


function quest:qhm()
  w:go(2409)
  askk qin about ������
answer ȷ��
baohu �غ���
end

function quest:gbb()
  askk gan about ������
  baohu �ʱ���
  w:go(3113)
end

function quest:bhnhs()
  askk duan about �����黨��
  g584
end]]


--[[
function quest:shediao()

  askk qiu about ��ѩ����
   askk qiu about ����
  g(4152)
end

function quest:getshouji()
   l mugan
    pa mugan
	��˳�����ľ������ȥ��С��ȡ�¹�Х����׼��պ�,������������
   g7041
end

function quest:()
  mai ��Х���׼�
  ���͵���׼������ᣬ�ѵ�����Ͷ������
  1171
end

function quest:duantiande()
  han �����
  g7041
  askk zhihuishi about �����
  zhua duan
   g7040
end

function quest:duantiande2()
  ask dashi about �����
  1207


  7044
end

function quest:doujiu()
   drop tong gang;ask pao tang about ͭ��װ��;get tong gang;up;ask dashi about ���Ѿ�����;ask dashi about ����
   get tong gang;jing jiu;jing �����;jing ��СӨ;jing ȫ��;jing ������;jing ���;jing ��ϣ��;jing �Ű���;doujiu �����߹�

   gt����¥
end

function quest:fahuasi()
   alias pfm
   zhuang zhong
   dadu �����߹�
   gt������
end

]]
--wu


--s3enw2ne
--w2ses3wn
--wse
--[[
qiao gate 4 times
qiao gate 2 times
qiao gate 5 times
qiao gate 3 times

���������˺�:
huida �����������
show wuyue lingqi

s;s;s����÷ׯ

�����в����ÿ���˶���

����ɢ
give huang guangling san
���ӹ������㡸����������Ц����

ŻѪ��
give zi ouxue pu
�ڰ��Ӷ����㡸����������Ц������

������
give weng shuaiyi tie
ͺ���̶����㡸����������Ц����

Ϫɽ����ͼ
give sheng tu
�����������㡸����������Ц������

��һ�ֵ罣������(Ding jian)
kill ding

zuan table
ask wizard about ���ר��
������
go north
go north
pull floor
d

go north
go east
go north
go north
go east
go east
go north
go west
go north
go south

kai men
go north

{zuan table;n;n;pull floor;d;n;e;n;n;e;e;n;w;n;s;kai men;n;ask ren about �Ƚ�}
ask ren about �Ƚ�

move man

l miji
read miji

push men]]

