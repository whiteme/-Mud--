
--��������������޷�ʩչ�������޼�����
--����ϥ������˫��ʮָ�ſ���������ǰ�����������֮״������ʥ���񹦿�ʼ���ˡ�
--����Ϣ���ȣ���ʱ����ʩ���ڹ���

heal={
  new=function()
    local hl={}
	setmetatable(hl,heal)
	hl.teach_skill={}
    local teach_skills=world.GetVariable("teach_skills") or nil
    if teach_skills==nil or teach_skills=="" then
      print("teach_skills����û������!!")
    else
      local _skills=Split(teach_skills,"|")
      for _,ts in ipairs(_skills) do
        table.insert(hl.teach_skill,ts)
      end
    end
	return hl
  end,
  is_killxue=false,
  is_qudu=true,
  saferoom=nil,
  count=0,
  omit_snake_poison=true,
  teach_skill={},
}
heal.__index=heal
--����ȱ��ֹͣ����

function heal:in_progress(count)
    wait.make(function()
	--�ȴ�
	print("�ȴ�",count)
	  --local l,w=wait.regexp("^(> |)�����һ����վ����������ϧ���ƻ�û����ȫ�ָ���$|^(> |)����Ϣһͣ��ȴ�������Ѿ�ȫ���ˡ�$|^(> |)���˹���ϣ�վ������������ȥ��ɫ�����������ӡ�$|^(> |)���ã���о�ͨ���Լ�����Ϣ���У����ϵ������Ѿ�ȫ���ˡ�$|^(> |)�㻺��վ��ֻ��ȫ��˵������������죬����������գ����գ������׽���������¾�ѧ����$|^(> |)����ɫ��������滺����������֮��תֱ�£��������š�$",20)
	   local l,w=wait.regexp("^(> |)�㽫��ľ��������Ϣ����һ�壬�о�������ȻȬ��������Ҳ�������������$|^(> |)�������ã�������ֹ�������һ�����İ����ĸо���͸ȫ��$|^(> |)ͻȻ���������Ժ���ֹЪ����㼴���ѣ�������һ������վ��������$|^(> |)�㡰�ۣ����Ĵ��һ����ȫ��İ���������ɢ��$|^(> |)�㡰�ۣ����Ĵ��һ����վ������������ɫ�԰ף���������������$|^(> |)�����һ����վ����������ϧ���ƻ�û����ȫ�ָ���$|^(> |)����ɫ��������滺����������֮��תֱ�£��������š�$|^(> |)����Ϣһͣ��ȴ�������Ѿ�ȫ���ˡ�$|^(> |)���˹���ϣ�վ������������ȥ��ɫ�����������ӡ�$|^(> |)���ã���о�ͨ���Լ�����Ϣ���У����ϵ������Ѿ�ȫ���ˡ�$|^(> |)���ã���о�ͨ���Լ�����Ϣ���У��������������Ѿ�ȫ���ˡ�$|^(> |)�㻺��վ��ֻ��ȫ��˵������������죬����������գ����գ������׽���������¾�ѧ����$|^(> |)�㲢û�����ˣ�$",20)

	  if l==nil then
	     if count==nil  then
		    count=1
		 end
	    if count>3 then  --��ʱ
		   print("heal �ȴ�ʱ�䳬ʱ!")
		   self:heal()
		   return
		else
		   count=count+1
		end
	    world.Send("hp")
	    self:in_progress(count)
	    return
	  end
	  if string.find(l,"�㲢û������") or string.find(l,"�����׽") or string.find(l,"�㽫��ľ��������Ϣ����һ��") or string.find(l,"������ֹ") or string.find(l,"����ɫ��������滺") or string.find(l,"����ȥ��ɫ����") or string.find(l,"�Ѿ�ȫ����") then
	     print("��ȫ�ָ�")
		 self.teach_skill=nil
		 self:kill_xue()
		--self:heal_ok()
	    return
	  end--�����һ����վ����������ϧ���ƻ�û����ȫ�ָ���
	  if string.find(l,"��ϧ���ƻ�û����ȫ�ָ�") or string.find(l,"ͻȻ���������Ժ���ֹЪ") or string.find(l,"ȫ��İ���������ɢ") or string.find(l,"����ɫ�԰�") then
	    print("��������")
	    self:halt()
	    return
	  end

	end)
end

function heal:yangzhou()
    local w=walk.new()
	w.walkover=function()
	  world.Send("ask laoban about ����")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)һ����Ĺ����ȥ�ˣ�����������Ѿ�����Ȭ���ˡ�$|^(> |)ҩ���ϰ�˵��������Ƥ���������������ң���$",5)
	    if l==nil then
		   self:yangzhou()
		   return
		end
		if string.find(l,"һ����Ĺ����ȥ�ˣ�����������Ѿ�����Ȭ����") or string.find(l,"������������") then
		   self.teach_skill=nil
		   self:kill_xue()
		   --self:heal_ok()
		   return
		end
	  end)
	end
	w:go(95)
end

function heal:halt()
    local x
	x=xiulian.new()
	x.min_amount=100
	x.safe_qi=300
	x.limit=true
	x.fail=function(id)
	  --print(id)
		if id==201 or id==1 or id==777 then
			local f
			f=function() x:dazuo() end  --���
			f_wait(f,10)
		end
		if id==202 then
		   if self.saferoom==nil then
		     --û��ָ������
              local _R
              _R=Room.new()
              _R.CatchEnd=function()
	          --print("R. hui diao")
                local count,roomno=Locate(_R)
                --print(count,roomno)
	            if count==0 then --new room
	              print("������")
	            end
	            if count>=1 then
	              local link=nearest_room(roomno)
	              for _,l in ipairs(link) do
		           if is_Special_exits(l.direction)==false then
		           local w
			       w=walk.new()
			       w.walkover=function()
			        x:dazuo()
			       end
			       w:go(l.linkroomno)
				   return
		           end
		          end
		          --�����������
		          local w
		          w=walk.new()
		          w.walkover=function()
			        x:dazuo()
		          end
		          w:go(link[1].linkroomno)
	            end
            end
           _R:CatchStart()
	     else
			local w
			w=walk.new()
			w.walkover=function()
			  x:dazuo()
			end
			w:go(self.saferoom)
		   end
		end
	end
	x.success=function(h)
		if h.neili>h.max_neili then
			self:heal()
		else
			print("��������")
			world.Send("yun recover")
			x:dazuo()
		end
	end
	x:dazuo()
end

function heal:heal_ok() --�ص�����
end

function heal:heal(special,liaojing)
   --print("����"," �� ",check_poison)
   if liaojing==false or liaojing==nil then
      world.Send("unset heal")
   else
      world.Send("set heal jing")
   end
   local g_heal=function()
-- ����ҩ���ϰ�����
   local exps=tonumber(world.GetVariable("exps")) or nil
   if exps~=nil and exps<=50000 then
      self:yangzhou()
      return
   end
   local special_heal=world.GetVariable("special_heal") or ""
   if (special==true or special==nil) and (check_poison==false or check_poison==nil) and liaojing==false then  --check_poison Ĭ����false
     if special_heal=="juxue" then
       self:juxue()
       return
	 elseif special_heal=="hudiegu" then
	   self:hudiegu()
	   return
	 elseif special_heal=="shangyao" then
	   self:shangyao()
	   return
	 elseif special_heal=="liao" then
	    self:liao()
	    return
	 elseif special_heal=="xiaoyao" then
	    self:xiaoyao()
	    return
	 elseif special_heal=="bed" then
	    self:liao_bed()
	    return
     end
   end
    wait.make(function()
	   world.Send("yun heal")
	   local l,w=wait.regexp("^(> |)������.*����Ȫ�ھ����������翪ʼ�˹����ˣ�$|^(> |)����ϥ������˫��ʮָ�ſ���������ǰ�����������֮״������ʥ���񹦿�ʼ���ˡ�$|^(> |)�㲢û�����ˣ�$|^(> |)�����𺮱���������ʼ�����������ˡ�$|^(> |)���Ѿ����˹��أ����ܲ��������𵴣�$|^(> |)����ϥ���£���ʼ�˹����ˡ�$|^(> |)������������Ϣ������������ȫ�����ߣ�ǡ�Ʊ̺����ΰ������𱻷⾭����$|^(> |)����ϥ���£���ʼ�˹����ˡ�$|^(> |)����ϥ���£����վ�����ʾ�ķ��ŵ�Ϣ��ֻ��������ů���ء������õأ�����������$|^(> |)��˫�ֺ�ʲ����ϥ�������������������䡱����ʼ�˹����ˡ�$|^(> |)��Ա���������о����������������ˡ�$|^(> |)�㻹û��ѡ����Ҫʹ�õ��ڹ���$|^(> |)�������������$|^(> |)ս�����˹����ˣ�������$|^(> |)����Ҫ����������ͻȻ�������˽���һ�ģ��úÿ����䣬���Ҷ���$|^(> |)����Ϣ���ȣ���ʱ����ʩ���ڹ���$|^(> |)��������Ȼ��˫Ŀ��գ���ʼ�������ܲ�ľ����Ϊ�����ã��ָ�����Ԫ����$",20)
	   if l==nil then
	      self:heal(special,liaojing)
	      return
	   end
	   if string.find(l,"�㲢û������") then
	     self.teach_skill=nil
	     self:kill_xue()
		 --self:heal_ok()
	     return
	   end
	   --�����һ����վ����������ϧ���ƻ�û����ȫ�ָ���
	   if string.find(l,"�ָ�����Ԫ��") or string.find(l,"��Ȫ�ھ�") or string.find(l,"����ʥ���񹦿�ʼ����") or string.find(l,"��˫�ֺ�ʲ") or string.find(l,"������.*����ʼ������������") or string.find(l,"����ϥ���£���ʼ�˹����ˡ�") or string.find(l,"ǡ�Ʊ̺����ΰ������𱻷⾭��") or string.find(l,"����ϥ���£���ʼ�˹�����") or string.find(l,"����ϥ���£����վ�����ʾ�ķ��ŵ�Ϣ") then
	      --print("heal ��")
  		  self:in_progress()
		 return
	   end
	   if string.find(l,"�����������") then
		  self:halt()
	      return
	   end
	   if string.find(l,"���Ѿ����˹��أ����ܲ���������") then
	     --self:liaoshang()
		 self.eat_drug_busy=function(drugname,drugid,CallBack)  --��ҩbusy
		     --����ӳ�
			 print("����")
			 local f=function()
		       self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
		 end
		 self:auto_drug()
	     return
	   end
	   if string.find(l,"��Ա���������о�����������������") then
	      print("û������")
	      self.eat_drug_busy=function(drugname,drugid,CallBack)  --��ҩbusy
		     --����ӳ�
			 print("����")
			 local f=function()
		       self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
		  end
	      self:auto_drug(true)
	      return
	   end
	   if string.find(l,"�㻹û��ѡ����Ҫʹ�õ��ڹ�") then
	     local f=function()
	        world.Send("jifa all")
		    self:heal()
		  end
		  f_wait(f,0.8)
	      return
	   end
	   if string.find(l,"ս�����˹�����") then
	      local f=function()
		     self:heal(special,liaojing)
		  end
          safe_room(f)
	      return
	   end

	   if string.find(l,"����Ҫ��������") then


		  local f=function()
		     world.Send("out")
	        world.Send("nw")
		    self:heal(special,liaojing)
		  end
		  f_wait(f,2)
	      return
	   end
	   if string.find(l,"����Ϣ����") then
	       print("�ȴ�2s ����")

		  local f=function()

		    self:heal(special,liaojing)
		  end
		  f_wait(f,2)
		  return
	   end
	   wait.time(10)

	end)
  end
--�ⶾ����
  --[[ if check_poison==true then
    local cd=cond.new()
	cd.over=function()
	  print("���״̬")
	  if table.getn(cd.lists)>0 then
		local sec=0
		for _,i in ipairs(cd.lists) do
		    local s,d=string.find(i[1],"��")
			if s~=nil then
			  --print(s,"test")
		 	  if (s%2)==1 or string.find(i[1],"����ӡ����") or string.find(i[1],"����ȭ����") then
				sec=i[2]
				--print(string.find(i[1]),"��"),":test")
				print("��"..i[1].."��",sec)
				self.saferoom=505
				if self.omit_snake_poison==true and i[1]=="�߶�" then
				else
				--if sec>=20 then
				    shutdown()
					self:qudu(sec,i[1],special)
					return
				end
				--end
			  end
			end
	    end
	  end
	  g_heal()
	end
	cd:start()
   else]]
      g_heal()
   --end

end



function heal:wait_ok()
     wait.make(function()

	   local l,w=wait.regexp("^(> |)һ����Ĺ����ȥ�ˣ�����������Ѿ�����Ȭ���ˡ�$",5)
	   if l==nil then
	     self.count=self.count+1
		 if self.count>5 then
		   self:ask_heal()
		 else
		   self:wait_ok()
		 end
		 return
	   end
	   if string.find(l,"����������Ѿ�����Ȭ����") then
	      local b=busy.new()
		  b.Next=function()
		    self.teach_skill=nil
			self:kill_xue()
	        --self:heal_ok()
		  end
		  b:check()
		  return
	   end
	   wait.time(5)
   end)
end

function heal:ask_heal()
  wait.make(function()
       world.Send("ask xue about ����")
	   local l,w=wait.regexp("^(> |)����û������ˡ�$|^(> |)Ѧ��ҽ�ó�һ�������������������˲�λ������Ѩ������о�������ˡ�|^(> |)һ����Ĺ����ȥ�ˣ�����������Ѿ�����Ȭ���ˡ�$|^(> |)ѦĽ��˵�����������û���ˣ������������ң���$|^(> |)ѦĽ��˵�����������书�Ƿ���ָ����һЩ����$",5)
	   if l==nil then
	     self:ask_heal()
		 return
	   end
	   if string.find(l,"�����书�Ƿ���ָ����һЩ") then
	     self:liaoshang()
	     return
	   end
	   if string.find(l,"Ѧ��ҽ�ó�һ�������������������˲�λ������Ѩ��") then
	     self.count=0
	     self:wait_ok()
	     return
	   end
	   --Ѧ��ҽ�ó�һ�������������������˲�λ������Ѩ������о�������ˡ�
	   if string.find(l,"����������Ѿ�����Ȭ����") or string.find(l,"�����û���ˣ�������������") then
	      self.teach_skill=nil
		  self:kill_xue()
		  --self:heal_ok()
		  return
	   end
	   if string.find(l,"����û�������") then
	      self:check_place()
	      return
	   end
	   wait.time(5)
   end)
end

function heal:kill_xue()
	if self.is_killxue then
      local exps=world.GetVariable("exps") or 0
	  exps=tonumber(exps)
	  print("kill ѦĽ��",exps)
	  if tonumber(exps)>=15000000 then
	    local b=busy.new()
	    b.Next=function()
	     local w=walk.new()
	     w.walkover=function()
		  world.Send("say ѦĽ�����ĩ�յ���!!")
		  world.Send("kill xue muhua")
		  wait.make(function()
		    local l,w=wait.regexp("^(> |)ѦĽ����ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",10)
			if l==nil then
			    self:kill_xue(CallBack)
			    return
			end
			if string.find(l,"����û�������") or string.find(l,"�����ų鶯�˼��¾�����") then
			   world.Send("get gold from corpse")
			   self:heal_ok()
			   return
			end
		  end)
		 end
	     w:go(623)
		end
		b:check()
	 else
	   self:heal_ok()
	 end

	else
	   self:heal_ok()
	end
end

function heal:Next_skill(index)
   wait.make(function()
     --print(index,"?>=",table.getn(self.teach_skill))  --ѦĽ����־�Ժ�������һ�����ȣ����ڵ��ϻ��˹�ȥ�������Զ�ɱѦĽ��
    if index>=table.getn(self.teach_skill) then
       wait.time(2) --��ʱ2s
	   local special_heal=world.GetVariable("special_heal") or "" --�������Ʋ���Ҫ�Խ�ҩ

      if special_heal=="juxue" then
         self:juxue()
         return
	   elseif special_heal=="hudiegu" then
	     self:hudiegu()
	     return
	   elseif special_heal=="shangyao" then
	     self:shangyao()
	     return
	   elseif special_heal=="liao" then
	     self:liao()
	     return
	   elseif special_heal=="xiaoyao" then
	     self:xiaoyao()
	     return
	   elseif special_heal=="bed" then
	     self:liao_bed()
	     return
       end
	   self.is_killxue=true
	   self.eat_drug_busy=function(drugname,drugid,CallBack)  --��ҩbusy
		     --����ӳ�
			 --print("�����Զ���ҩ")
			local f=function()
		       self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
	   end
	   --print("zidong")
	   self:auto_drug()  --���м��ܶ�̫��
	   return
	end
      world.Send("teach xue "..self.teach_skill[index])  --> ѦĽ��(Xue xue)�����㣺��Ĺ���̫�> ѦĽ��(Xue xue)�����㣺��Ĺ���̫�
	   local l,w=wait.regexp("^(> |)����ѦĽ����ϸ�ؽ�˵��$|^(> |)Ѧ��ҽ����������Ѿ������ٽ����ˡ�$|^(> |)ѦĽ��˵��������Ĺ���̫���ˡ���$|^(> |)����������̫���ˣ�Ѧ��ҽ��û��Ȥ��$|^(> |)ѦĽ��.*������.*��Ĺ���̫�",5)
	   if l==nil then
	      self:liaoshang()
		  return
	   end
	   if string.find(l,"Ѧ��ҽ����������Ѿ������ٽ�����") then
	      index=index+1
		  self:Next_skill(index)
	      return
	   end
	   if string.find(l,"����ѦĽ����ϸ�ؽ�˵") then
	     self.count=self.count+1
		 if self.count>=5 then
	       local f=function()
             self:ask_heal()
		   end
		   f_wait(f,0.8)
		 else
		   self:Next_skill(index)
		 end
		  return
	   end
	   if string.find(l,"��Ĺ���̫����") or string.find(l,"����������̫����") or string.find(l,"��Ĺ���̫��") then
	      index=index+1
		  self:Next_skill(index)
	      return
	   end
	   wait.time(5)
   end)
end

function heal:liaoshang_fail()  --�ص�����
   local special_heal=world.GetVariable("special_heal") or ""

     if special_heal=="juxue" then
       self:juxue()
       return
	 elseif special_heal=="hudiegu" then
	   self:hudiegu()
	   return
	 elseif special_heal=="shangyao" then
	   self:shangyao()
	   return
	 elseif special_heal=="liao" then
	    self:liao()
	    return
	 elseif special_heal=="xiaoyao" then
	    self:xiaoyao()
	    return
	 elseif special_heal=="bed" then
	    self:bed()
	    return
     end

    --Ĭ��
     print("�Զ����ҩ")
	  self.eat_drug_busy=function(drugname,drugid,CallBack)  --��ҩbusy
		     --����ӳ�
			 print("����")
			 local f=function()
		        self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
	  end
	 self:auto_drug()
end

function heal:check_place()
   local _R
  _R=Room.new()
  _R.CatchEnd=function()
     local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
	 if roomno[1]==623  then
	   print("Ѧ��ҽ���ڼң���������ֽ����")
	 local special_heal=world.GetVariable("special_heal") or ""
     if special_heal=="juxue" then
       local h=hp.new()
       h.checkover=function()
		if h.jingxue_percent<100 then
	      self:heal(false,true)
	    else
          self:juxue()
	    end
       end
	   h:check()
       return
	 elseif special_heal=="hudiegu" then
	   self:hudiegu()
	   return
	 elseif special_heal=="shangyao" then
	   self:shangyao()
	   return
	 elseif special_heal=="xiaoyao" then
	    self:xiaoyao()
	    return
	 elseif special_heal=="liao" then
	   local h=hp.new()
       h.checkover=function()
		if h.jingxue_percent<100 then
	      self:heal(false,true)
	    else
          self:liao()
	    end
       end
	   h:check()
	    return
	 elseif special_heal=="bed" then
	    self:liao_bed()
	     return
     end
	   self.eat_drug_busy=function(drugname,drugid,CallBack)  --��ҩbusy
		     --����ӳ�
			 print("����Ѧ��ҽ")
			 local f=function()
		        self:liaoshang()
			 end
			 f_wait(f,5)
		end
	   self:liaoshang_fail()
	 else
	   self:liaoshang()
	 end
   end
  _R:CatchStart()
end

function heal:liaoshang()
 local special_heal=world.GetVariable("special_heal")
   if special==false or special==nil then
     if special_heal=="hudiegu" then
	   self:hudiegu()
	   return
     end
   end
	local teach_skills=world.GetVariable("teach_skills") or nil
    if teach_skills==nil or teach_skills=="" then
      print("teach_skills����û������!!")
    else
      local _skills=Split(teach_skills,"|")
      for _,ts in ipairs(_skills) do
        table.insert(self.teach_skill,ts)
      end
    end
  local w=walk.new()
  w.walkover=function()
    wait.make(function()
	   world.Send("ask xue about ����")
	   if index==nil then
	      index=1
	   end
	   world.Send("teach xue "..self.teach_skill[1])
	   local l,w=wait.regexp("^(> |)����û������ˡ�$|^(> |)����ѦĽ����ϸ�ؽ�˵��$|^(> |)Ѧ��ҽ����������Ѿ������ٽ����ˡ�$|^(> |)ѦĽ��˵��������Ĺ���̫���ˡ���$|^(> |)����������̫���ˣ�Ѧ��ҽ��û��Ȥ��$|(> |)ѦĽ��.*�����㣺��Ĺ���̫�$",5)
	   if l==nil then
	      self:liaoshang()
		  return
	   end
	   if string.find(l,"Ѧ��ҽ����������Ѿ������ٽ�����") then
		  self:Next_skill(2)
	      return
	   end
	   if string.find(l,"����ѦĽ����ϸ�ؽ�˵") then
	       self.count=1
	       local f=function()
             self:Next_skill(1)
		   end
		   f_wait(f,0.8)
		   return
	   end
	   if string.find(l,"��Ĺ���̫��") or string.find(l,"����������̫����") then
	       print("������ˣ���")
	       self:Next_skill(2)
	       --self:drug()
	       return
	   end
	    if string.find(l,"����û�������") then
	      self:check_place()
	      return
	   end
	   --wait.time(5)
	end)
  end
  w:go(623)
end



----------------------------------------------------------��ҩ
function heal:drug_sellout()  --ҩ��������
    local f=function()
     self:heal(true,false) --Ĭ��
	end
	f_wait(f,2) --5s �Ժ�������
end

function heal:buy_drug(drugname,drugid,CallBack)  --������ҩ
  local w=walk.new()
	 w.walkover=function()
	    wait.make(function()
	     world.Send("list")
         world.Send("buy "..drugid)
		 local l,w=wait.regexp("����.*�ļ۸��ҩ���ƹ�����������һ��.*"..drugname.."��|^(> |)��⵰��һ�ߴ���ȥ��$|^(> |)������Ķ���������û�С�$|^(> |)������Ǯ�����ˣ���Ʊ��û���ҵÿ���$",5)
		 if l==nil then
		    self:buy_drug(drugname,drugid,CallBack)
			return
		 end
		 if string.find(l,drugname) then
		    self:eat_drug(drugname,drugid,CallBack)
		    return
		 end
		 if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
		    local f=function()
			   self:buy_drug(drugname,drugid,CallBack)
			end
		    self:qu_gold(f)
		    return
		 end
		 if string.find(l,"������Ķ���������û��") then
		    self:drug_sellout() --������
		    return
		 end
		 wait.time(5)
		end)
	 end
	 w:go(413)
end

function heal:eat_drug_busy(drugname,drugid,CallBack)
    --Ĭ�ϵ�
	 local f=function()
		self:eat_drug(drugname,drugid,CallBack)
	 end
	 f_wait(f,5)
end

function heal:eat_drug(drugname,drugid,CallBack)
   world.Send("fu "..drugid)
   world.Send("eat "..drugid)
   local l,w=wait.regexp("^(> |)�����һ��.*�����ָ��˲��ٵľ�Ѫ��$|^(> |)�����һ��.*������ʱ�о���Ѫ������ʧ��$|^(> |)�����һ��.*$|^(> |)���ϴε�ҩ������û���أ��Ȼ���ٷ��ðɡ�$|^(> |)�����һ�Ŵ󻹵������õ��ﴦ��ů��ӿ�ϣ���ʱ����Ȭ����Ѫ��ӯ��$|^(> |)��Ҫ��ʲô��$|^(> |)ʲô?$|^(> |)�㺬��ʲô��|^(> |)������û������������$",5)
   if l==nil then
      self:eat_drug(drugname,drugid,CallBack)
      return
   end
   if string.find(l,"�����һ��") or string.find(l,"�ָ��˲��ٵľ�Ѫ") or string.find(l,"��ʱ�о���Ѫ������ʧ") or string.find(l,"��ʱ����Ȭ����Ѫ��ӯ") then
      CallBack()
      return
   end
   if string.find(l,"�Ȼ���ٷ��ð�") then
      print("��ҩbusy��:",drugname," ",drugid)
	  local f=function()
		--self:eat_drug(drugname,drugid,CallBack)
	   self:heal(true,true)
	   end
	   f_wait(f,2)

      return
   end
   if string.find(l,"��Ҫ��ʲô") or string.find(l,"ʲô") or string.find(l,"������û����������") then
	    self:buy_drug(drugname,drugid,CallBack)
	    return
   end
   wait.time(5)
end
------------------��ȡ�ƽ�
function heal:qu_gold(CallBack)
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
          world.Send("qu 2 gold")
		local l,w=wait.regexp("^(> |)���������ȡ�������ƽ�$",5)
		print("����")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold(CallBack)
		   return
		end
		if string.find(l,"���������") then
		   CallBack()
		   return
		end
		wait.time(5)
	  end)
   end
   w:go(410)
end

function heal:auto_drug(flag)  --�Զ��ж���ҩ������
   print("��ҩ")
   local h=hp.new()
   h.checkover=function()
      local drugname
	  local drugid
	  local f=nil

     if h.jingxue_percent<=90 and tonumber(h.max_neili)<=1400  then
	    drugname="�ƾ���"
		drugid="liaojing dan"
		f=function()
	      self:heal(false,true)
	   end

	 elseif h.jingxue_percent<=80 and tonumber(h.max_neili)>=1400 then
		drugname="��Ѫ�ƾ���"
		drugid="huoxue dan"
        f=function()
	      self:heal(false,true)
	   end
	 elseif (h.qi_percent<=80 or flag==true) and h.qi_percent<100 and tonumber(h.max_neili)<=1400 then
	    drugname="��ҩ"
		drugid="jinchuang yao"
       f=function()
	      self:heal(true,false)
	   end
     elseif (h.qi_percent<=80 or flag==true) and h.qi_percent<100 and tonumber(h.max_neili)>=1400 then
		drugname="���ɽ�ҩ"
		drugid="chantui yao"
		f=function()
	      self:heal(true,false)
	   end
	 elseif h.qi_percent>=100 and h.jingxue_percent>=90 then
	     print("����Ҫ����")
		 self.teach_skill=nil
		 self:kill_xue()
	     --self:heal_ok()
		 return
	 else
		--self:heal_ok()--����������
		print("����Ҫ��ҩ")
		if h.jingxue_percent<100 then
		   self:heal(false,true)

		else
		   --self:heal(true,false)
		   drugname="��ҩ"
		   drugid="jinchuang yao"
           f=function()
	         self:heal(true,false)
		   end
		   self:eat_drug(drugname,drugid,f)
		end
		return
	 end
	 --print("drug")
	 self:eat_drug(drugname,drugid,f)
   end
   h:check()
end
----------------------------------------�ⶾ ��������  �ж��ж�ʱ��  ѦҪ������ ʧ�� ->��ҩ ���� ����ж�ʱ��
function heal:yun_qudu(sec,posion)
--�㲢û���ж���
--�����û���ж��ɡ�
   world.Send("yun qudu")
   world.Send("yun liaodu")
   wait.make(function()
       local l,w=wait.regexp("^(> |)�����û���ж��ɡ�$|^(> |)�����ڵ��ϣ�������һ���һ��,�����ڻ����.*���˳�ȥ��$|^(> |)�㲢û���ж���$|^(> |)������û���ж���$|^(> |)���������˿��������С��������������ؽ��˼�����$|^(> |)�㽫����ѭ��һ�ܣ���������¶����������������������ƣ��������ڡ�$|^(> |)������֮����Ϊ���죬�����޷��ƶ���$|^(> |)�㻹�ö�ѧ���ľҩ��$|^(> |)��������������޷�ʩչ�������޼�����$|^(> |)�㵹����Ϣ��ͷ�½��ϣ���Ѫ���У�Ĭ�ˡ���󡹦���������ڵ�.*�ӽ�������֮�����˳�ȥ��",5)
	   if l==nil then
	      self:yun_qudu(sec,posion)
	      return
	   end
	   if string.find(l,"�ؽ��˼���") or string.find(l,"û���ж�") then
	      self:heal()
		  return
	   end
	   if string.find(l,"�����������") then
	       local h=hp.new()
		    h.checkover=function()
				local x=xiulian.new()
			    x.min_amount=10
			    x.safe_qi=h.max_qi*0.5
			    x.limit=true
			    x.fail=function(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self.liaoshang_fail=function()
					    local f=function()
                          self:heal(false,true)
				        end
			            self:buy_drug("��Ѫ�ƾ���","huoxue dan",f)
			         end
		             self:liaoshang()
				     return
				  end
				  world.Send("yun recover")
				  world.Send("yun jing")
	              local f2
		          f2=function() x:dazuo() end  --���
				  f_wait(f2,0.5)
			    end
				if id==777 then
                    --�����������ڵ�ǰ�������
				   self.liaoshang_fail=function()
				     local f=function()
					   self:heal(true,false)
				     end
			         self:buy_drug("���ɽ�ҩ","chantui yao",f)
			       end
		           self:liaoshang()
				end
	           if id==202 then
	              local _R
                  _R=Room.new()
                  _R.CatchEnd=function()
                    local count,roomno=Locate(_R)
					local target_roomno=nearest_room(roomno)
                    local w
		            w=walk.new()
		            w.walkover=function()
			          x:dazuo()
		            end
		            w:go(target_roomno)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
                self:yun_qudu(sec,posion)
			end
			x:dazuo()
		   end
		   h:check()
	        return
	   end
	   if string.find(l,"��������") or string.find(l,"��Ѫ���У�Ĭ�ˡ���󡹦��") or string.find(l,"���˳�ȥ") then
	      self:heal(false,true)
		  return
	   end
	   if string.find(l,"������֮����Ϊ���죬�����޷��ƶ�") or string.find(l,"�㻹�ö�ѧ���ľҩ��") then
		  self.is_qudu=false
	      self:heal(false,true)
	      return
	   end
   end)
end

function heal:bingchan()
   local w=walk.new()
   w.walkover=function()
      wait.make(function()
	      world.Send("duihuan bingchan")
	      wait.time(3)
		  local b=busy.new()
		  b.Next=function()
	        world.Execute("#10 xidu")
		    local cd=cond.new()
	        cd.over=function()
	        print("���״̬")
	        if table.getn(cd.lists)>0 then
		      local sec=0
			  for _,i in ipairs(cd.lists) do
		        local s,d=string.find(i[1],"��")
			  if s~=nil then
			  --print(s,"test")
		 	  if (s%2)==1 or string.find(i[1],"����ӡ����") then
				sec=i[2]
				--print(string.find(i[1]),"��"),":test")
				print("��"..i[1].."��",sec)
				self.saferoom=505
				--if sec>=20 then
				    shutdown()
					self:qudu(sec,i[1],special)
					return
				--end
			  end
			end
	    end
	   end
	  self:heal(false,true)
	end
	        cd:start()
		  end
		  b:check()
	  end)

   end
   w:go(84)
end

--[[
      wait.make(function()
	      world.Send("qu tianqi")
	      wait.time(3)
	      world.Send("eat tianqi")
		    local cd=cond.new()
	        cd.over=function()
	        print("���״̬")
	        if table.getn(cd.lists)>0 then
		      local sec=0
			  for _,i in ipairs(cd.lists) do
		        local s,d=string.find(i[1],"��")
			  if s~=nil then
			  --print(s,"test")
		 	  if (s%2)==1 or string.find(i[1],"����ӡ����") then
				sec=i[2]
				--print(string.find(i[1]),"��"),":test")
				print("��"..i[1].."��",sec)
				self.saferoom=505
				if sec>=20 then
				    shutdown()
					self:qudu(sec,i[1],special)
					return
				end
			  end
			end
	    end
	   end
	  self:heal(false,true)
	end
	cd:start()
	  end)]]
function heal:eat_tianqi()
    world.Execute("#5 eat tianqi")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)�����һ�������赨ɢ����ϥ���ã�ֻ����һ����������Ϣ�Ե���ӿ������$",3)
	  if l==nil then
	     self:eat_tianqi()
	     return
	  end
	  if string.find(l,"ֻ����һ����������Ϣ�Ե���ӿ����") then
	     local b=busy.new()
		 b.Next=function()
	       self:heal(false,true)
		 end
		 b:check()
	     return
	  end


	end)
end

function heal:qu_tianqi()
    world.Execute("#10 qu tianqi")
	wait.make(function()
	   local l,w=wait.regexp("^(> |)��������赨ɢ�Ӹ��˴���������ȡ������$|^(> |)�㲢û�б������Ʒ��$",3)
	   if l==nil then
	     self:qu_tianqi()
	     return
	   end
	   if string.find(l,"��������赨ɢ�Ӹ��˴���������ȡ����") then
		  local b=busy.new()
		  b.Next=function()
	        self:eat_tianqi()
		  end
		  b:check()
	      return
	   end
	   if string.find(l,"�㲢û�б������Ʒ") then
	      local b=busy.new()
		  b.Next=function()
		    self:bingchan()
		  end
		  b:check()
	      return
	   end

	end)

end

function heal:tianqi()
   local w=walk.new()
   w.walkover=function()
         local _R
         _R=Room.new()
		 _R.CatchEnd=function()
            if _R.roomname=="�ӻ���" and _R.zone=="���ݳ�" then
			   self:qu_tianqi()
			else
			   self:tianqi()
			end
         end
		 _R:CatchStart()

   end
   w:go(94)
end

--�㵹����Ϣ��ͷ�½��ϣ���Ѫ���У�Ĭ�ˡ���󡹦���������ڵ������ܻ����ӽ�������֮�����˳�ȥ��
function heal:qudu(sec,posion,special)
     local party=world.GetVariable("party") or ""
	 local neigong=world.GetVariable("neigong") or ""
	 if (party=="�䵱��" or neigong=="��󡹦" or neigong=="������" or party=="������") and self.is_qudu==true then
	     self:yun_qudu(sec,posion)
		 return
	 end
	 if party=="��Ĺ��" then
		self:liaodu_bed()
	    return
	 end
	 local omit=false
	 if posion=="�߶�" and self.omit_snake_poison==true then
		omit=true
	 end
	 if sec>=90 and omit==false then
	      -- self:bingcan()
		 self:tianqi(sec,posion)
		 return
	 end
     if sec>=1800 and omit==false then
	    print("�ж�ʱ�䳬��,��ȫ�˳�")
        sj.quit(true)
        return
	 end
     print("����")
	  local h
	  h=hp.new()
	  h.checkover=function()
	      self.drug_sellout=function()  --ҩ������
		      print("ҩ������ ǿ���˳�!!!")
			  sj.quit(true)
		  end
	      if h.jingxue_percent<=40 or (h.max_jingxue<300 and h.jingxue_percent<100) then
		       self.liaoshang_fail=function()
			      local f=function()
                      self:heal(false,true)
				  end
			      self:buy_drug("��Ѫ�ƾ���","huoxue dan",f)
			   end
		       self:liaoshang()
			  return
		  end


		  if h.qi_percent<=40 or (h.max_qi<300 and h.qi_percent<100) then
		      self.liaoshang_fail=function()
				  local f=function()
					  self:heal(special,false)
				  end
			      self:buy_drug("���ɽ�ҩ","chantui yao",f)
			   end
		     self:liaoshang()
			 return
		  end
		   --����job
          if h.jingxue_percent<100 then
		     self:heal(false,true)
		     return
		  end
		  if h.qi_percent==100 then
		      print("����4")
		     self.teach_skill=nil
			 self:kill_xue()
			 --self:heal_ok() --�ص�����
			 return
		  end
         print("����3")
		  self:heal(special)
	  end
	  h:check()
end
---------------------------------------��������
--�����õ��ڹ���û�����ֹ��ܡ�
function heal:juxue()
   wait.make(function()
		print("��Ѫ")
	    world.Send("yun juxue")
	   local l,w=wait.regexp("^(> |)û������ʲô�ˣ�$|^(> |)�㳤��һ�����������ӵ�վ��������$|^(> |)���Ѿ����˹��أ����ܲ��������𵴣�$|^(> |)�������������$|^(> |)�����õ��ڹ���û�����ֹ��ܡ�$",10)
	   if l==nil then
	      self:juxue()
	      return
	   end
	   if string.find(l,"û������ʲô��") or string.find(l,"�㳤��һ�����������ӵ�վ������") then
	     local b=busy.new()
		 b.Next=function()
		   self.teach_skill=nil
		   self:kill_xue()
	       --self:heal_ok()
		 end
		 b:check()
	     return
	   end
	   if string.find(l,"���Ѿ����˹��أ����ܲ���������") then
	     --self:liaoshang()
		 self.eat_drug_busy=function(drugname,drugid,CallBack)  --��ҩbusy
		     --����ӳ�
			 print("����")
			 local f=function()
		     self:eat_drug(drugname,drugid,CallBack)
			 end
			 f_wait(f,5)
		 end
		 self:auto_drug()
	     return
	   end
	   if string.find(l,"�����õ��ڹ���û�����ֹ���") then
	       local fight_jifa=world.GetVariable("fight_jifa") or ""
			if fight_jifa~="" then
			   world.Execute(fight_jifa)
			else
			   world.Send("jifa all")
			end
			world.Send("jifa")
			self:juxue()

		  return
	   end
	   if string.find(l,"�����������") then
	      self:halt()
		  return
	   end
	   wait.time(10)
	end)
end

function heal:liao()
   wait.make(function()
		print("һ��ָ")
		--world.Send("jifa finger yiyang-zhi")
		--���������£�΢һ������ʳָ���Ρ���������Ѩ���˵����ʳָһ�գ����ư����ؿ����д�Ѩ����������ԴԴ͸�롣����
		--��ͷ��ð��˿˿����������һյ��ʱ�֣��ŷſ���ָ,�����ɫ������Ҳ�ö��ˡ�
		--��è��û�����ˣ�
		world.Execute("jifa finger yiyang-zhi;bei none;bei finger")
	    world.Send("yun liao")
	   local l,w=wait.regexp("^(> |).*��û�����ˣ�$|^(> |)��ͷ��ð��˿˿����������һյ��ʱ�֣��ŷſ���ָ,�����ɫ������Ҳ�ö��ˡ�$|^(> |)���������ҽ��֪ʶ��֪���٣���֪�������?$",10)
	   if l==nil then
	      self:liao()
	      return
	   end
	   if string.find(l,"��û������") then
	     local b=busy.new()
		 b.Next=function()
		   self.teach_skill=nil
	       self:kill_xue()
		   --self:heal_ok()
		 end
		 b:check()
	     return
	   end
	   if string.find(l,"�����ɫ������Ҳ�ö���") then
	     local b=busy.new()
		 b.Next=function()
		   self:liao()
		 end
		 b:check()
	     return
	   end
	   if string.find(l,"��֪�������") then
	     self:heal(false)
	     return
	   end
	   wait.time(10)
	end)
end

function heal:hudiegu()
	print("������")
	local r=math.random(0,5)
	local w=walk.new()
	w.walkover=function()
	   world.Send("ask hu about ����")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)����ţ�ݺݵ��������ͷ���������Դ��ϵĴ�����ŵû��˹�ȥ��$|^(> |)����ţ�ƺ����������˼��$|^(> |)����һ����������������ȫ�ظ��ˣ�$",8+r)
		if l==nil then
		   self:hudiegu()
		   return
		end
		if string.find(l,"�����������ȫ�ظ���") or string.find(l,"����ţ�ݺݵ��������ͷ") or string.find(l,"����ţ�ƺ����������˼") then
		   local b=busy.new()
		   b.Next=function()
		     self.teach_skill=nil
			 self:kill_xue()
		     --self:heal_ok()
		   end
		   b:check()
		   return
		end
	  end)
	end
	w:go(3122)
end

function heal:xiaoyao()
	print("��ң")
	local w1=walk.new()
	w1.walkover=function()
	   world.Send("ask xue about ����")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)ѦĽ��˵��������û�����κ��˰�����$|^(> |)��Լ����һ�Ѳ��ʱ�ݣ�ѦĽ��������վ��������$",8)
		if l==nil then
		   self:xiaoyao()
		   return
		end
		if string.find(l,"һ�Ѳ��ʱ��") or string.find(l,"��û�����κ���") then
		   local b=busy.new()
		   b.Next=function()
		     self.teach_skill=nil
		     self:kill_xue()
			 --self:heal_ok()
		   end
		   b:check()
		   return
		end
	  end)
	end
	w1:go(4234)
end

function heal:shangyao()
	print("ؤ����ҩ")
	local w=walk.new()
	w.walkover=function()
	   world.Send("ask xi about ��ҩ")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)�ɳ���˵������.*��û�����ˣ���ҩ���������˵İ����ֵܰɡ���$|^(> |)����һ��ؤ����ҩ��$|^(> |)�ɳ���˵������Ŀǰ��ҩû���ˣ��Ȼ�ɡ�$",5)
		if l==nil then
		   self:shangyao()
		   return
		end
		if string.find(l,"Ŀǰ��ҩû����") then
		   self:heal(false,true)
		   return
		end
		if string.find(l,"��ҩ���������˵İ����ֵܰ�") then
		   self.teach_skill=nil
		   self:kill_xue()
		   --self:heal_ok()
		   return
		end
		if string.find(l,"����һ��ؤ����ҩ") then
		   local b=busy.new()
		   b.Next=function()
		     world.Send("fu shangyao")
			 self:heal()
		   end
		   b:check()
		   return
		end
	  end)
	end
	w:go(2287)
end

function heal:liao_bed()
  print("��Ĺ����")
  local t1=os.time()
  if sj.marks_bed~=nil and sj.marks_bed~="" then
    local t2=os.difftime(t1,sj.marks_bed)
    --print(t2,":��","ʱ����")
	if t2<=200 then
	   local h=hp.new()
	   h.checkover=function()
          if h.qi_percent<100 then
 		     self:heal(false,false)
		  else
			  self:heal(false,true)
		  end
	   end
	   h:check()
	  return
	end
  end
  local h=hp.new()
  h.checkover=function()
     if h.qi_percent>=95 and h.qi_percent<100 then
		self:heal(false,false)
		return
	 end
	 if h.jingxue_percent<100 then
		self:liaodu_bed()
	    return
	 end
     local w=walk.new()
     w.walkover=function()
     world.Send("liao bed")
	 wait.make(function()
       local l,w=wait.regexp("^(> |)��һ�������ֻ����������ȣ��˿���ȻȬ����$|^(> |)����������û���ܵ��κ��˺���$",20)
	   if l==nil then
	      self:liao_bed()
		  return
	   end
	   if string.find(l,"��ֻ�����������") then
		  sj.marks_bed=os.time()
	      --self:heal_ok()
		  self:kill_xue()
	      return
	   end
	   if string.find(l,"û���ܵ��κ��˺�") then
	       self:kill_xue()
	      return
	   end

	 end)
    end
    w:go(5048)
  end
  h:check()

end

function heal:liaodu_bed()
  print("��Ĺ�����ƶ�")
  if sj.marks_bed~=nil and sj.marks_bed~="" then
    local t1=os.time()
    local t2=os.difftime(t1,sj.marks_bed)
    print(t2,":��","ʱ����")
	if t2<=200 then
      self:liaodu_bed()
	  return
	end
  end
  local w=walk.new()
  w.walkover=function()
    world.Send("liaodu bed")
    local l,w=wait.regexp("^(> |)��һ�������ֻ���ó���һ��󺹣�������Ȼ���᲻�١�$|^(> |)�����û���ж��ɣ�$",20)
	if l==nil then
	    self:liaodu_bed()
	    return
	end
	if string.find(l,"������Ȼ���᲻��") then
	   sj.marks_bed=os.time()
	   self:heal(false,false)
	   return
	end
	if string.find(l,"�����û���ж���") then
	   self:heal(false,true)
	   return
	end
  end
  w:go(5048)
end
