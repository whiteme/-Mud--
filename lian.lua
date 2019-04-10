lian={
  new=function()
     local ln={}
	  setmetatable(ln,lian)
	  ln.skills={}
	 return ln
  end,
  count=50,
  vip=false,
  run_vip=false,
  interval=0.3,
  skills={},
  skillsIndex=1,
  weapon="",
  levelup=false,
  lian_end=false,
  settime=nil,
  setpot=nil,
}
lian.__index=lian

function lian:move(cmd)
  local w
  w=walk.new()
  w.walkover=function()
	self:Execute(cmd)
  end
 local _R
 _R=Room.new()
 _R.CatchEnd=function()
	local count,roomno=Locate(_R)
	--print(roomno[1])
	local r=nearest_room(roomno)
	w:go(r)
  end
  _R:CatchStart()
end
--ѧ��ָ��ͨ������ֻ��ְֳ�����
--��ľ���̫���ˣ��������沨��������
function lian:neili_lack(callback)
  --
  print("��������")
   local x
	x=xiulian.new()
	x.safe_qi=300
	x.limit=true
	x.fail=function(id)
		--print(id)
		if id==201 or id==1 then
			world.Send("yun recover")
			world.Send("yun jing")
			local f
			f=function() x:dazuo() end  --���
			f_wait(f,0.5)
		end
		if id==202 then
	          local w
		      w=walk.new()
		      w.walkover=function()
			    x:dazuo()
		      end
		     local _R
             _R=Room.new()
             _R.CatchEnd=function()
               local count,roomno=Locate(_R)
		       --print(roomno[1])
		       local r=nearest_room(roomno)
			   w:go(r)
	         end
			_R:CatchStart()
	    end
	end
	x.success=function(h)
		print(h.qi,h.max_qi*0.9)
		print(h.neili,h.max_neili*2-200)
		if h.neili>h.max_neili*2-200 then
		  if callback~=nil then
		     callback()
		  else
		     self:start()
		  end

		else
		  print("��������")
		  world.Send("yun recover")
		  x:dazuo()
		end
	end
	x:dazuo()
end

function lian:xiulian()
  --
  print("��������")
   local x
	x=xiulian.new()
	x.safe_qi=300
	x.limit=true
	x.fail=function(id)
		--print(id)
		if id==201 or id==1 then
			world.Send("yun recover")
			world.Send("yun jing")
			local f
			f=function() x:dazuo() end  --���
			f_wait(f,0.5)
		end
		if id==202 then
	          local w
		      w=walk.new()
		      w.walkover=function()
			    x:dazuo()
		      end
		     local _R
             _R=Room.new()
             _R.CatchEnd=function()
               local count,roomno=Locate(_R)
		      -- print(roomno[1])
		       local r=nearest_room(roomno)
			   w:go(r)
	         end
			_R:CatchStart()
	    end
	end
	x.success=function(h)
		print(h.qi,h.max_qi*0.9)
		print(h.neili,h.max_neili*2-200)
		if h.neili>h.max_neili*2-200 then
		   self:wield_weapon()
		else
		  print("��������")
		  world.Send("yun recover")
		  x:dazuo()
		end
	end
	x:dazuo()
end

function lian:wield_weapon()
   local sp=special_item.new()
   sp.cooldown=function()
	local i=self.skillsIndex
	local skillname=self.skills[i].skill_id
	print(skillname," ���ݼ��������ж�ʹ�õ�����!!")
	if string.find(skillname,"sword") then
		world.Send("wield jian")
		world.Send("wield xiao")
		world.Send("wield sword")
		self.weapon="sword"
	elseif string.find(skillname,"blade") then
	    world.Send("wield dao")
		world.Send("wield blade")
		self.weapon="blade"
	elseif string.find(skillname,"staff") then
	    world.Send("wield zhang")
		world.Send("wield staff")
		self.weapon="staff"
	elseif string.find(skillname,"whip") or string.find(skillname,"bian") then
		world.Send("wield bian")
		world.Send("wield whip")
		self.weapon="bian"
	elseif string.find(skillname,"dagger") then
       world.Send("wield bishou")
	   world.Send("wield dagger")
		self.weapon="bishou"
    elseif string.find(skillname,"hammer") then
	   world.Send("wield falun")
	   world.Send("wield hammer")
		self.weapon="falun"
	elseif string.find(skillname,"brush") then
	   world.Send("wield bi")
	   world.Send("brush")
		self.weapon="bi"
	elseif string.find(skillname,"stick") then
	   world.Send("wield bang")
	   world.Send("wield stick")
	   self.weapon="bang"
	elseif string.find(skillname,"force") then
	   self.weapon=""
	   self:start()
	   return
	elseif string.find(skillname,"hook") then
	   world.Send("wield gou")
	   world.Send("wield hook")
	   self.weapon="gou"
	end
	wait.make(function() --�㽫һ������̫�絶������������С�
	local l,w=wait.regexp("^(> |)��.*����.*���С�$|^(> |)��о�ȫ����Ϣ���ڣ�ԭ������������������װ��.*��$|^(> |)���Ѿ�װ�����ˡ�$",5)
	 if l==nil then
	    self:wield_weapon()
	    return
	 end
	 if string.find(l,"��о�ȫ����Ϣ����") then
	    self:xiulian()
	    return
	 end
	 if string.find(l,"����") or string.find(l,"���Ѿ�װ������") then
         self:start()
		 return
	 end
	 wait.time(5)
	end)
  end
  sp:unwield_all()
end
--��Ļ��������δ���������ȴ�û������ܼ�����ߡ�
--���������һ�����Ӳ������޷���
function lian:Execute(cmd)
  wait.make(function()
	 world.Execute(cmd) --�������̫���ˣ��������������� ��ľ���̫���ˣ��޷���ϰ��ɽ���� �����ڵľ���̫���ˣ�������ϰ��ɽ����
	 local l,w=wait.regexp("^(> |)��ľ���̫���ˣ�������.*��|^(> |)�������������.*��|^(> |)�����������.*��$|^(> |)�������̫���ˡ�$|^(> |)�������̫���ˣ�������.*��$|^(> |)��ľ���̫���ˡ�$|^(> |)�����ڵ���Ϊ���������.*$|^(> |)��ʹ�õ��������ԡ�$|^(> |)����ʵս���鲻�㣬�谭�����.*������$|^(> |)(��|ѧϰ|ѧ).*�����.*$|^(> |)ѧ.*ʱ���ﲻ����������$|^(> |)���ַ�����.*$|^(> |)��ġ�.*�������ˣ�$|^(> |)����ʱ�޷���.*��$|^(> |)�����Ϣһ���ˣ��Ȼ�����.*��$|^(> |)���޷���������������$|^(> |)���Ҳ�����������Ӱ�������Ϣ��$|^(> |)����Ъ���������ɡ�$|^(> |)������.*��$|^(> |)�����ϵ���������������.*��$|^(> |)��ľ���������.*$|^(> |)�������б�����.*$|^(> |)�����������.*$|^(> |)������ڵ���������,�޷�������.*$|^(> |)��ľ���̫���ˣ��޷���ϰ.*$|^(> |).*������֡�$|^(> |)�����ڵľ���̫���ˣ�������ϰ.*��$|^(> |)�������Ŀǰû�а취��ϰ.*��$|^(> |)��û��ʹ�õ�����.*$|^(> |)���Ⱦۼ�����������.*$|^(> |)��Ļ��������δ���������ȴ�û������ܼ�����ߡ�$|^(> |)��.*����֡�$|^(> |)��ϰ��ָ��ͨ�����б̺���������ϡ�$|^(> |)�����ʹ�ý��߽����ܽ�һ����ϰ��Ľ��߽�����$|^(> |)���������һ�����Ӳ������޷���$|^(> |)�������������$|^(> |)��̫���ˡ�$|^(> |)����ϰ��.*ȴ�е�����̫���Ծ���$|^(> |)��̫���ˣ�Ъ���������ɡ�$",1.5)
     if l==nil then
		 self:Execute(cmd)
		return
     end
	 --�����ڵ���Ϊ��������̺߱��������ˡ�
	if string.find(l,"����ʵս���鲻��") or string.find(l,"��Ļ��������δ���������ȴ�û������ܼ������") or string.find(l,"�����������") then
	  	local f=function() self.start_failure(1) end
        print "����ʵս���鲻��1"
		f_wait(f,self.interval)
		return
	 end
	 if string.find(l,"�����ڵ���Ϊ���������") then  --�����ڵ���Ϊ��������߾����񹦡�
	 --�������� or pot����
	    local h=hp.new()
		h.checkover=function()
		  if h.pot<10 then
			 local f=function() self.start_failure(502) end
             print "����pot����502"
		     f_wait(f,self.interval)
			 return
		  end
	       local f=function() self.start_failure(501) end
           print "������������501"
		   f_wait(f,self.interval)
		end
		h:check()
		return
	 end
    --[[ if string.find(l,"����˲��ٽ���") then
	    local f=function() self:start_success() end
        --print "�ɹ�"
		f_wait(f,self.interval)
		return
     end]]
	 if string.find(l,"������") then
	    --world.("lingwu_end","false")
		self.levelup=true
		self:Execute(cmd)
	    return
	 end
    if  string.find(l,"ȴ�е�����̫���Ծ�") or string.find(l,"������ý�") or string.find(l,"�����ʹ�ý��߽�") or string.find(l,"��ʹ�õ���������") or string.find(l,"����ʱ�޷���") or string.find(l,"�����ϵ�����") or string.find(l,"��û��ʹ�õ�����") or string.find(l,"���������") then
		self:wield_weapon()
		return
     end--����̫��
     if string.find(l,"��̫����") or string.find(l,"����̫����") or string.find(l,"��̫����") or string.find(l,"��ľ���̫����") or string.find(l,"�������̫����") or string.find(l,"�����������") or string.find(l,"�������̫����") or string.find(l,"�����Ϣһ����") or string.find(l,"Ъ����") or string.find(l,"��ľ�������") or string.find(l,"�������Ŀǰû�а취��ϰ") then
	   self.start_failure(401)
	   return
	 end
	 if string.find(l,"�������������") or string.find(l,"�����������") or string.find(l,"������ڵ���������") or string.find(l,"���Ⱦۼ�����������") then
	   self.start_failure(201)
	   return
	 end
	 if string.find(l,"���޷�������������") or string.find(l,"���Ҳ�����������Ӱ�������Ϣ") then
	   print("�޷���ϰ����")
	   --self.start_failure(666)
	   self:move(cmd)
	   return
	 end
	 if string.find(l,"��ϰ��ָ��ͨ�����б̺����������") then

	    world.Send("jifa force bihao-chaosheng")
	    return
	 end

     if string.find(l,"����") or string.find(l,"����������") or string.find(l,"������") or string.find(l,"�������б���")  then
	    local sp=special_item.new()
		sp.cooldown=function()
		  self:Execute(cmd)
		end
		sp:unwield_all()
	    return
	 end
     --�ȴ�
    wait.time(1.5)
	print("����")
end)
end

function lian:start_failure(error_id) --�ص�����

end

function lian:rest() --�ص�����

end


function lian:refresh()
   -- regenerate_trigger()
    wait.make(function()
    world.Send("yun refresh")
	local l,w=wait.regexp("^(> |)�������������$|^(> |)�㳤��������һ������$|^(> |)�����ھ������档$",5)
   if l==nil then
      --self.start_failure(-1)
	  self:refresh()
	  return
   end
   if string.find(l,"��������") then
     print("lian",402)
     self.start_failure(402)
	 return
   end
   if string.find(l,"�㳤��������һ����") or string.find(l,"�����ھ�������") then
     print("lian",403)
     self.start_failure(403)
	 return
   end
   wait.time(5)
   end)
end

function lian:go()
    if self.settime~=nil then
       print(self.settime," ��ָ�����!")
	   local f=function()
	      shutdown()
		  local b=busy.new()
		  b.Next=function()
		    self:finish()
		  end
		  b:check()
	   end
	   f_wait(f,self.settime)

	end
	if self.vip==true and self.run_vip==false then
	   self:vip_start()
	else
       self:start()
	end
end

--[[

  �����Ṧ     (dodge)                     - ������� 221/    10
  ���켼��     (duanzao)                   - �ڻ��ͨ 122/   556
  �����ڹ�     (force)                     - ������� 223/ 27097
����������     (hanbing-shenzhang)         - ������� 220/  9765
����������     (hanbing-zhenqi)            - ������� 223/ 33541
  �����ַ�     (hand)                      - ������� 221/    73
  ����д��     (literate)                  - ������� 147/ 19416
  ��������     (medicine)                  - ��������  69/  4014
  �����м�     (parry)                     - ������� 221/    51
����ɽ����     (songshan-jian)             - ������� 220/  1531
  ������       (songyang-bian)             - ����һ��   1/     0
����������     (songyang-shou)             - ������� 221/ 10791
  �����Ʒ�     (strike)                    - ������� 220/   975
  ��������     (sword)                     - ������� 221/     0
  �ּۻ���     (trade)                     - �����ž�  23/   474
���������     (zhongyuefeng)              - ������� 221/ 49284

]]
function lian:skills_level()
   --print("����������",table.getn(self.skills))
   local i=0
   for i,item in ipairs(self.skills) do
	 --world.AddTriggerEx ("skill"..i, "^(> |).*"..item[i].skill_name..".*\\s+(\\d*)\\/\\s+(\\d*)", "print(\"%2\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 2000);
     --world.SetTriggerOption ("skill"..i, "group", "skills")
     --world.EnableTrigger("skill"..i,true)

	 world.AddTriggerEx ("skill_base"..i, "^(> |).*"..item.skill_id..".*\\s+(\\d*)\\/\\s*(\\d*)", "print(\"%2\")\nSetVariable('"..item.skill_id.."',trim(\"%2\"))",trigger_flag.OneShot + trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 2000);
     world.SetTriggerOption ("skill_base"..i, "group", "skills")
     world.EnableTrigger("skill_base"..i,true)
   end
   world.Send("cha")
end

function lian:start(base,level,skill,practice,special) --��ʼ��ϰ

	local i
	i=self.skillsIndex
	--��ǰ�ȼ�  ������
	wait.make(function()
	   -- world.Send("cha") --ȷ����ϰ����
	   if base==nil and level==nil and skill==nil then
	    world.Send("cha")
		world.Send("set action ����")
	   end
		local s=self.skills[i].skill_name
		local b=self.skills[i].skill_id
		--print(s)
        s=string.gsub(s,"%-","%%-")
		b=string.gsub(b,"%-","%%-")
		--print("^(> |).*\\\("..self.skills[i].skill_name.."\\\).*\\s+(\\d*)\\/(\\s*)(\\d*)")
		--print("^(> |).*\\\("..self.skills[i].skill_id.."\\\).*\\s+(\\d*)\\/(\\s*)(\\d*)")
	   local l,w=wait.regexp("^(> |).*\\\("..self.skills[i].skill_name.."\\\).*\\s+(\\d*)\\/(\\s*)(\\d*)|^(> |).*\\\("..self.skills[i].skill_id.."\\\).*\\s+(\\d*)\\/(\\s*)(\\d*)|^(> |)^(> |)�趨����������action \\= \\\"����\\\"",5)
	   if l==nil then
	       self:start()
	      return
	   end
	   if string.find(l,b) then

	       local base=tonumber(w[6])
		   --print("4:",w[4],"5:",w[5],"8:",w[6],"7:",w[7])
		  self:start(base,level,skill,practice,special)
		  return
	   end
	   if string.find(l,s) then
	       --local exps=world.GetVariable("exps")
	        local special=tonumber(w[2])
	      local skill=(tonumber(w[2])+1)
		  skill=skill*skill
		  --print(exp," | ",w[3])
		  local level=tonumber(w[2])
		  --print(level)
		  level=level*level*level*0.1

		   local practice=tonumber(w[4])
		   self:start(base,level,skill,practice,special)
	       return
	   end

	   --print(self.skills[i].skill_name,"why",l)
	   --print(string.find(l,"("..self.skills[i].skill_name..")"))
	   if string.find(l,"�趨����������action") then
	      --print("ok?")
	       local exps=world.GetVariable("exps")
	       --print("����")
	      --[[local special=tonumber(w[2])
	      local skill=(tonumber(w[2])+1)
		  skill=skill*skill
		  --print(exp," | ",w[3])
		  local level=tonumber(w[2])
		  print(level)
		  level=level*level*level*0.1]]


		  print("if ",level," < ",exps," and ",special,"<",base," or ",skill,">",practice)
		   if self.skills[i].skill_name=="wuxing-zhen" and special<200 then
		     print("������ask")
			 self:wxz()
		     return
		  end
		  --������û�е�������  �ȼ�С�ھ������� ���� ���⼼��С�ڻ�����
           if skill==nil then
		      print("������û�е�������  �ȼ�С�ھ������� ���� ���⼼��С�ڻ�����")
		      return
		   end
	      if skill>practice or (level<tonumber(exps) and (special<base or base=="force"))  then
		    print("��ϰ����")
		    local cmd
	        local skill_id
			local skill_name
	      --print(i)
	        skill_id=self.skills[i].skill_id
			skill_name=self.skills[i].skill_name
			if skill_id=="hand" or skill_id=="cuff" or skill_id=="strike" or skill_id=="claw" or skill_id=="finger" or skill_id=="leg" then
			  world.Send("bei none")
			  world.Send("bei "..skill_id)
			elseif skill_id=="parry" then
			   local party=world.GetVariable("party") or ""
			   if party=="����Ľ��" then
			      print("����ת����")
				  if special>=201 then
				   self:douzhuan_xingyi3()
				  elseif special>=171 then
				   self:douzhuan_xingyi2()
				  else
				   self:douzhuan_xingyi()
				  end
				  return
			   elseif party=="����" then
				  print("�ֽ�Ǭ����Ų��")
				  self:qiankundanuoyi()
				  return
			   end
			end
			world.Send("jifa "..skill_id.." "..skill_name)
	        cmd="lian "..skill_id--.." "..self.count
	        self:Execute(cmd)
		  else
		    print("��ϰ�¸�")
		    if self:Next()==true then
			   local f=function()
			     self:start()
			   end
			   f_wait(f,0.2)
			else
			   --world.SetVariable("lian_end","true")  --lian �����һ������
			   --local lingwu_end=world.GetVariable("lingwu_end") or "false"
			   --if lingwu_end=="true" then
			   --   print("�ȴ��ȼ�������")
			   --   world.SetVariable("levelup","false")
			   --end
			   self.lian_end=true
			   self:finish()
			end
		  end
	      return
	   end
	   --print("wrong?")
		wait.time(5)
	end)

end

function lian:qiankundanuoyi()
  local sleeproomno=2248
  local masterid="zhang"
  local master_place=2745
     print("��ʼ�ֽ�Ǭ����Ų��")
	 local taojiao={}
	  taojiao=learn.new()
	  taojiao.timeout=1.2
	  sj.World_Init=function()
          taojiao:go()
      end
	   taojiao.master_place=tonumber(trim(master_place)) --ʦ�������
       taojiao.masterid= masterid  --ʦ��id
	   taojiao.start=function()
		  local cmd="taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi"
		  taojiao:Execute(cmd)

	   end
       taojiao.start_success=function()
	      taojiao:regenerate()
	      --taojiao:start()
	   end
	   taojiao.wuxing=function()
	      local wx=world.GetVariable("wuxing")
		  world.Execute(wx)
	   end
	   taojiao.start_failure=function(error_id)
			print(error_id," learn_error_id")
		   if error_id==2 then  --û���ҵ�ʦ��
			  local f=function() taojiao:go() end
			  f_wait(f,5)
		   end
		   if error_id==102 or error_id==1 or error_id==201 or error_id==301 then  --Ǳ������ �������� �� ��Խʦ�� ����������
	           print("��ϰ�¸�")
		     if self:Next()==true then
			   local f=function()
				 self:start()
			   end
			   f_wait(f,0.2)
		     else
			   self.lian_end=true
			   self:finish()
		     end
	         return
		   end
			if error_id==202 then
			  print("��������:",taojiao.weapon)

			end

			if error_id==401 then
			   taojiao:regenerate()
			end
			if error_id==402 then  --��������
			  shutdown()
			  local exps=world.GetVariable("exps")
			  if tonumber(exps)>800000 then
			     taojiao:xiulian()
			  else
                 taojiao:rest()
			  end
			end
			if error_id==403 then  --����ת����Ѫ ����ѧϰ
			  taojiao:start()
			end
	  end
	 taojiao.rest=function()
	      local w
		  w=walk.new()
		  w.walkover=function()
			 local mr_rest=rest.new()
			 mr_rest.failure=function(id)
			    local f=function()
				  --w:go(2186)
				  -- w:go(2785)
				  w:go(sleeproomno)
				end
				f_wait(f,10)
 			 end
			 mr_rest.wake=function(flag)
				taojiao:go()
			 end
			 mr_rest:sleep()
		  end
		 -- w:go(2186)
		-- w:go(2785)
		  w:go(sleeproomno)
	  end
	  taojiao:go()  --ss go learn
end

function lian:start_success()  --�ص�����
  --������.*��ָ�����ƺ���Щ�ĵá�
   self:start() --Ĭ��
end

function lian:Next() --��һ��ѧϰ����
  self.skillsIndex=self.skillsIndex+1
 -- print(self.skillsIndex,"?>",table.getn(self.skills))
  if self.skillsIndex>table.getn(self.skills) then
     return false
  else
     return true
  end
end

function lian:addskill(skillname)
   --print(table.getn(self.skills),skillname)
   table.insert(self.skills,skillname)
end

function lian:vip_start()
   local w
   w=walk.new()
   w.walkover=function()
       wait.make(function()
          world.Send("ask ying gu about �������")
		  local l,w=wait.regexp("^(> |)����˵�������㱾�ܻ�����ʹ�ù������(.*)�����ڿ�ʼ��ʱ�ˡ���$|(> |)�Բ��𰡣�Ŀǰ�������ֻ�Թ��VIP�û�����ǿ��ѧϰ���ܡ�$|(> |)�㲻��������ϰ�������������ô���������ץ��ʱ�䡭��$|^(> |)����˵����������Ȼ���ʴϻۣ�����̰������ã�������ð���ˣ�����������ѯ�ʰɡ���$",10)
		  if l==nil then
            local f=function() self:vip_start() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"���ڿ�ʼ��ʱ��") or string.find(l,"�㲻��������ϰ�������������ô") then
		     self.run_vip=true
			 local b
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:start()
			 end
			 b:check()
			 return
		  end
		  if string.find(l,"�������ֻ�Թ��VIP�û�����") or string.find(l,"����Ȼ���ʴϻۣ�����̰������ã�������ð���ˣ�����������ѯ�ʰ�") then
		     self.vip=false
		     self.run_vip=false
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:start()
			 end
			 b:check()
		     return
		  end
		  wait.time(10)
	   end)
   end
   w:go(435)
end

function lian:vip_end()
  local w
   w=walk.new()
   w.walkover=function()
	  world.Send("ask ying gu about ����")

	   local l,w=wait.regexp("^(> |)�������ô����йء�����������Ϣ��$",10)
		  if l==nil then
            local f=function() self:vip_end() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"�������ô����йء�����������Ϣ") then
		     self.run_vip=false
			 local b
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:AfterFinish()
			 end
			 b:check()
			 return
		  end
		  wait.time(10)
   end
   w:go(435)
end

function lian:AfterFinish() --�ص�����

end

function lian:ask_wxz()
   local w=walk.new()
   w.walkover=function()
	   world.AddTimer ("wxz", 0, 0, 1, "ask wen about ������", timer_flag.Enabled + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
       world.SetTimerOption ("wxz", "send_to", 10)
   end
   w:go(177)
end

function lian:wxz()

   local w=walk.new()
   w.walkover=function()
        world.Send("qn_qu 500")
		local b=busy.new()
		b.Next=function()
		   self:ask_wxz()

		end
		b:check()
   end
   w:go(4067)
end

function lian:finish()
    if self.weapon~="" then
		world.Send("unwield "..self.weapon)
	end
    --print("vip״̬:",self.vip)
	--print("vip run:",self.run_vip)
   if self.vip==true or self.run_vip==true then
      self:vip_end()
   else
      self:AfterFinish()
   end
end

function lian:lingwu_dzxy(cmd)
  wait.make(function()
    world.Send(cmd)
    local l,w=wait.regexp("^(> |)��.*��ڤڤ֮����Ķ�ת�����ֽ���һ����$|^(> |)����������һЩ��ʵս�����ö�ת���Ƶļ��ɡ�$|^(> |)�������������$|^(> |)���������죬̫����������У����ƶ�䣬����˳���Ʋ�ı�Ե���������������Щ���ۡ�$|^(> |)��Ҫ��ʲô��$",5)
     if l==nil then
	   self:lingwu_dzxy(cmd)
	   return
	 end
	 if string.find(l,"ڤڤ֮����Ķ�ת�����ֽ���һ��") or string.find(l,"����������һЩ��ʵս�����ö�ת���Ƶļ���") then
	   local f=function()
	     world.Send("yun jing")
	     self:lingwu_dzxy(cmd)
	   end
	   f_wait(f,0.3)
	   return
	 end
	 if string.find(l,"�����������") then
	     print("lian",402)
         self.start_failure(402)
	   return
	 end
	 if string.find(l,"���������죬̫����������У����ƶ�䣬����˳���Ʋ�ı�Ե���������������Щ����") then
		print("��ϰ�¸�")
		if self:Next()==true then
			local f=function()
				self:start()
			end
			f_wait(f,0.2)
		else
			self.lian_end=true
			self:finish()
		end
	    return
	 end
	 if string.find(l,"��Ҫ��ʲô") then
	    self:douzhuan_xingyi3()
	    return
	 end
	 wait.time(5)
  end)
end

function lian:douzhuan_xingyi()  --����ת
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("lingwu zihua")
   end
   w:go(2756)
end

function lian:douzhuan_xingyi2()  --����ת
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("lingwu miji")
   end
   w:go(2846)
end

function lian:douzhuan_xingyi3()  --����ת
   local w=walk.new()
   w.walkover=function()
      self:lingwu_dzxy("look sky")
   end
   w:go(2966)
end

function lian:kan()
 wait.make(function()
    world.Send("kan tree")
    local l,w=wait.regexp("^(> |)��ʹ���񵶶�׼�±߹��ɣ�һ������ȥ.*$|^(> |)��Ҫ�ò�������$|^(> |)ʲô��$|^(> |)�������������$",5)
     if l==nil then
	   self:kan()
	   return
	 end
	 if string.find(l,"��ʹ���񵶶�׼�±߹��ɣ�һ������ȥ") then
	   local f=function()
	     world.Send("yun refresh")
	     self:kan()
	   end
	   f_wait(f,0.3)
	   return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:kantree()
		end
	    self:neili_lack(f)
	    return
	 end
	 if string.find(l,"��Ҫ�ò�����") then
		world.Send("wield chai dao")
		self:kan()
	   return
	 end
     if string.find(l,"ʲô") then
	    self:kantree()
	    return
	 end
	 wait.time(5)
  end)
end

function lian:kantree()
  local w=walk.new()
   w.walkover=function()
      world.Send("wield chai dao")
	  self:kan()
   end
   w:go(3158)

end
