
function wizard_end()
end

local function wizard_start()
  local _exps=world.GetVariable("exps")
  _exps=tonumber(_exps)

----------------ս��-------------------

  local pfm
  pfm=world.GetVariable("pfm")
  if pfm==nil then
     print("��Ҫ����pfm����:ս��ʱ�Զ�ʩ�� �� wield jian;jiali max;perform sword.haichao;jiali 1;yun xinjing")
     world.SetVariable("pfm","")
  end
  local cmd --block npc perform
  cmd=world.GetVariable("cmd")
  if cmd==nil then
    print("��Ҫ����cmd����: kill ��·npc ʱ��ʹ�� �� perform xxxx")
    world.SetVariable("cmd","")
  end
  local unarmed_pfm
  unarmed_pfm=world.GetVariable("unarmed_pfm")
  if unarmed_pfm==nil then
    print("��Ҫ����unarmed_pfm����: ������ʧ����ʱ��ļ��� �� get jian;wield jian;perform haichao �� �л����ּ��� ��pfm��������")
	world.SetVariable("unarmed_pfm","")
  end
-----------------����--------------------

  local wuxing
  wuxing=world.GetVariable("wuxing")
  if wuxing==nil then
     print("��Ҫ����wuxing ���������ѧϰ������Ҫ ��ǰyun �ڹ�  ����д�룬�� yun qimen �� yun xinjing  ")
     world.SetVariable("wuxing","")
  end
  local shield
  shield=world.GetVariable("shield")
  if shield==nil then
    print("��Ҫ����shield ���������ս��ǰ��Ҫ yun �ڹ� ��װ������  ����д�룬�� wield sword;yun longxiang �� yun shield  ")
    world.SetVariable("shield","")
  end
   local afk_cmd=world.GetVariable("afk_cmd")
   local afk_sec=world.GetVariable("afk_sec")
   if afk_cmd==nil then
      world.SetVariable("afk_cmd","")
   end
   if afk_sec==nil then
      world.SetVariable("afk_sec","60")
   end

    local sp_exert
	sp_exert=world.GetVariable("sp_exert")
  if sp_exert==nil then
    print("��Ҫ����sp_exert ���������ս��ǰ��Ҫ yun �ڹ� ��װ������  ����д�룬�� 'ȫ��':'wield sword;yun longxiang'  ")
    world.SetVariable("sp_exert","")
  end
  local liao_percent
  liao_percent=world.GetVariable("liao_percent")
  if liao_percent==nil then
    print("��Ҫ����liao_percent ��������Ѧ������Ѫ����")
    world.SetVariable("liao_percent","80")
  end
  local pot
  pot=world.GetVariable("pot")
  if pot==nil then
    print("��Ҫ����pot ������ ÿ��ѧϰ��pot ����ֵ 1~50 ")
    world.SetVariable("pot","1")
  end
  local pot_overflow
  pot_overflow=world.GetVariable("pot_overflow")
  if pot_overflow==nil then
     print("��Ҫ����pot_overflow ������ pot=maxpot-pot_overflow ʱ��ȥѧϰ����,��ֵ�ͻ�һֱjob  ")
     world.SetVariable("pot_overflow",20)
  end
  local up
  up=world.GetVariable("up")
  if up==nil then
     print("��Ҫ����up ����: ����pot ��ʽ up ֵ=learn,lingwu,duanzao,zhizhao,chenggao,literate ���Զ��������д��ѧϰ,cun ��Ǳ������")

	 if _exps>1000000 then
	    world.SetVariable("up","lingwu")
	 else
	    world.SetVariable("up","learn")
	 end
  end
  local bei_up
  bei_up=world.GetVariable("bei_up")
  if bei_up==nil then
     print("��Ҫ����bei_up ����: ����pot ��ʽ bei_up ֵ=learn,lingwu ����gold ����ʱ�Զ��л�")
	  if _exps>1000000 then
	    world.SetVariable("bei_up","lingwu")
	 else
	    world.SetVariable("bei_up","learn")
	 end
  end
  local skills
  skills=world.GetVariable("skills")
  if skills==nil then
     print("��Ҫ����skills ����: ѧϰskills �� ����� skills  �� longxiang-boruo|dashou-yin|hand|dodge|yuxue-dunxing|parry|poison|huanxi-chan|force")
     world.SetVariable("skills","")
  end
  local lian_skills
  lian_skills=world.GetVariable("lian_skills")
  if lian_skills==nil then
	 print("��Ҫ����lian_skills ����: ��ϰskills  �� ���������&force|����ӡ&hand|ժ�ǹ�&dodge")
     world.SetVariable("lian_skills","")
  end
  local lingwu_end
  lingwu_end=world.GetVariable("lingwu_end")
  if lingwu_end==nil then

     world.SetVariable("lingwu_end","false")
  end
  local sleeproomno
  sleeproomno=world.GetVariable("sleeproomno")
  if sleeproomno==nil then
     print("��Ҫ����sleeproomno ����: ѧϰʱ��ָ��������Ϣ�ָ���ֻ��up=learn ��Ч��sz���򷿼����� ���Ҷ�Ӧ����� �� sz����˯��")
     world.SetVariable("sleeproomno","")
  end
  local master_place
  master_place=world.GetVariable("master_place")
  if master_place==nil then
	print("��Ҫ����master_place ����: ѧϰʱ��ָ������ѧϰʦ����ֻ��up=learn ��Ч��sz���򷿼����� ���Ҷ�Ӧ����� �� sz����˯��")
	world.SetVariable("master_place","")
  end
  local masterid
  masterid=world.GetVariable("masterid")
  if masterid==nil then
     print("��Ҫ����masterid ����: ʦ����id��ֻ��up=learn ��Ч���� huang")
	world.SetVariable("masterid","")
  end


  local neili_upper
  neili_upper=world.GetVariable("neili_upper")
  if neili_upper==nil then
    print("��Ҫ����neili_upper ����: ��ʼjob ǰ�����ı���1-1.99 ֮��ֵ")
	world.SetVariable("neili_upper","1.9")
  end
  local i_equip
  i_equip=world.GetVariable("i_equip")
  if i_equip==nil then
     print("��Ҫ����i_equip ����:�Զ�����ȡװ��")
     world.SetVariable("i_equip","<����>�ƽ�&5|<����>����&200|<����>ͭǮ&200|<����>��Ʊ&10")
  end
  local xiulian
  xiulian=world.GetVariable("xiulian")
  if xiulian==nil then
     print("��Ҫ����xiulian ����:job busy ������������ ��д xiulian_jingli �� xiulian_neili")
	 world.SetVariable("xiulian","xiulian_neili")
  end
------------------hb job ��Ҫʹ��
  local hb_auto=world.GetVariable("hb_auto")
  if hb_auto==nil then
      print("�����Զ��л�jobslist")
     world.SetVariable("hb_auto","true")
  end
  local hb_jobslist=world.GetVariable("hb_jobslist")
  if hb_jobslist==nil then
     world.SetVariable("hb_jobslist","")
  end
  local hb_pfm=world.GetVariable("hb_pfm")
  if hb_pfm==nil then
     world.SetVariable("hb_pfm","")
  end
  local hb_cmd=world.GetVariable("hb_cmd")
  if hb_cmd==nil then

      print("������id ������id ִ��ָ��,������id �л�jobslist")
     world.SetVariable("hb_cmd","")
  end

------------------xs job ��Ҫʹ��
  local xs_blacklist
  xs_blacklist=world.GetVariable("xs_blacklist")
  if xs_blacklist==nil then
     print("��Ҫ����xs_blacklist ����: ѩɽjob ��Ҫ������ guard  �����������ɺ���������� �� �һ���|���ൺ&����|����&����")
     world.SetVariable("xs_blacklist","")
  end
  local xs_pfm
  xs_pfm=world.GetVariable("xs_pfm")
  if xs_pfm==nil then
     world.SetVariable("xs_pfm","")
  end
  local sx_pfm
  sx_pfm=world.GetVariable("sx_pfm")
  local sx2_pfm
  sx2_pfm=world.GetVariable("sx2_pfm")
  if sx_pfm==nil then
     world.SetVariable("sx_pfm","")
  end
  if sx2_pfm==nil then
     world.SetVariable("sx2_pfm","")
  end
    local cl_pfm
  cl_pfm=world.GetVariable("cl_pfm")
  if cl_pfm==nil then
     world.SetVariable("cl_pfm","")
  end
    local wd_pfm
  wd_pfm=world.GetVariable("wd_pfm")
  if wd_pfm==nil then
     world.SetVariable("wd_pfm","")
  end
    local hs_pfm
  hs_pfm=world.GetVariable("hs_pfm")
  if hs_pfm==nil then
     world.SetVariable("hs_pfm","")
  end
    local hs2_pfm
  hs2_pfm=world.GetVariable("hs2_pfm")
  if hs2_pfm==nil then
     world.SetVariable("hs2_pfm","")
  end
    local gb_pfm
  gb_pfm=world.GetVariable("gb_pfm")
  if gb_pfm==nil then
     world.SetVariable("gb_pfm","")
  end
    local tdh_pfm
  tdh_pfm=world.GetVariable("tdh_pfm")
  if tdh_pfm==nil then
     world.SetVariable("tdh_pfm","")
  end
  local zs_pfm
  zs_pfm=world.GetVariable("zs_pfm")
  if zs_pfm==nil then
     world.SetVariable("zs_pfm","")
  end
  local ss_kill_pfm
  ss_kill_pfm=world.GetVariable("ss_kill_pfm")
  if ss_kill_pfm==nil then
     world.SetVariable("ss_kill_pfm","")
  end
  local ss_fight_pfm
  ss_fight_pfm=world.GetVariable("ss_fight_pfm")
  if ss_fight_pfm==nil then
     world.SetVariable("ss_fight_pfm","")
  end
  local ss_fight_pfm_list
  ss_fight_pfm_list=world.GetVariable("ss_fight_pfm_list")
  if ss_fight_pfm_list==nil then
     world.SetVariable("ss_fight_pfm_list","")
  end
  local ss_kill_pfm_list
  ss_kill_pfm_list=world.GetVariable("ss_kill_pfm_list")
  if ss_kill_pfm_list==nil then
     world.SetVariable("ss_kill_pfm_list","")
  end
 local tm_pfm
  tm_pfm=world.GetVariable("tm_pfm")
  if tm_pfm==nil then
     world.SetVariable("tm_pfm","")
  end

  local sm_pfm
  sm_pfm=world.GetVariable("sm_pfm")
  if sm_pfm==nil then
     world.SetVariable("sm_pfm","")
  end

  local xl_pfm
  xl_pfm=world.GetVariable("xl_pfm")
  if xl_pfm==nil then
     world.SetVariable("xl_pfm","")
  end

  local jy_pfm
  jy_pfm=world.GetVariable("jy_pfm")
  if jy_pfm==nil then
     world.SetVariable("jy_pfm","")
  end
------------------sx job ��Ҫʹ��
  local sx_blacklist
  sx_blacklist=world.GetVariable("sx_blacklist")
  if sx_blacklist==nil then
     print("��Ҫ����sx_blacklist ����: ����job ��Ҫ������ sx2 npc ���������б� �����������ɺ���������� �� ������&Τ����|������&��ɽ�ȷ�|��ɽ��&���¾Ž�")
     world.SetVariable("sx_blacklist","")
  end
  local cl_blacklist
  cl_blacklist=world.GetVariable("cl_blacklist")
  if cl_blacklist==nil then
	 print("��Ҫ����cl_blacklist ����: ���ְ�job ���������� �� ����|�һ�")
     world.SetVariable("cl_blacklist","")
  end
  local wd_blacklist
  wd_blacklist=world.GetVariable("wd_blacklist")
  if cl_blacklist==nil then
	 print("��Ҫ����wd_blacklist ����: �䵱job ���������ɻ��� �� ������|���¾Ž�|����ذ��")
     world.SetVariable("wd_blacklist","")
  end
  local difficulty
  difficulty=world.GetVariable("difficulty")
  if difficulty==nil then
     print("��Ҫ����difficulty ����: �䵱job �Ѷȵȼ�1~4 �� 1 ����Ϊ�� 2 ��Ϊ�˵� 3 �������� 4 ���绯��")
     world.SetVariable("difficulty","1")
  end
  local immediate_sx1
  immediate_sx1=world.GetVariable("immediate_sx1")
  if immediate_sx1==nil then
     print("��Ҫ����immediate_sx1 ����:sx1 �������Ų��ȴ�ɱ��")
     world.SetVariable("immediate_sx1","")
  end
  local blockNPC
  blockNPC=world.GetVariable("blockNPC")
  if blockNPC==nil then
     print("��Ҫ����blockNPC:��·NPC pfmʹ������")
	 world.SetVariable("blockNPC","")
  end
  local sx_giveup_pos
   sx_giveup_pos=world.GetVariable("sx_giveup_pos")
  if sx_giveup_pos==nil then
     print("��Ҫ����sx_giveup_pos:���ŷ����ص�")
	 world.SetVariable("sx_giveup_pos","�����|������|����Ľ��|������|��٢��ɽׯ|��ɽ|�䵱ɽԺ��|�䵱ɽ��ɽСԺ|ɳ̲|С��")
  end

    local ss_blacklist
  ss_blacklist=world.GetVariable("ss_blacklist")
  if ss_blacklist==nil then
	 print("��Ҫ����ss_blacklist ����: ��ɽjob ���������ɻ��� �� ������|���¾Ž�|����ذ��")
     world.SetVariable("ss_blacklist","")
  end
------------------wd job ��Ҫʹ��


------------------ģ���л�---------------
  local jobslist
  jobslist=world.GetVariable("jobslist")
  if jobslist==nil then
     print("��Ҫ����without_fight ����: ѩɽjob ��Ҫ������ guard  �����������ɺ���������� �� �һ���|���ൺ&����|����&����")
     world.SetVariable("jobslist","")
  end
  local shashou_level
  shashou_level=world.GetVariable("shashou_level")
  if shashou_level==nil then
     print("��Ҫ����shashou_level ����: ����job ɱ���Ѷȵȼ� -1 ���� sx2 job 0 ΢����� 1 ������ 2 С������ 3 �ڻ��ͨ 5 ��Ϊ�˵� 9 �������� 10 ���뻯��")
     world.SetVariable("shashou_level","-1")
  end
------------------�����������
   local wdj_entry=world.GetVariable("wdj_entry")
   if wdj_entry==nil then
       world.SetVariable("wdj_entry","false")
   end
   local putian_entry=world.GetVariable("putian_entry")
   if putian_entry==nil then
     if _exps>=170000 then
	    world.SetVariable("putian_entry","true")
	 else
	    world.SetVariable("putian_entry","false")
	 end
   end
	local shaolin_entry=world.GetVariable("shaolin_entry")
	if shaolin_entry==nil then
     if _exps>=170000 then
	    world.SetVariable("shaolin_entry","true")
	 else
	    world.SetVariable("shaolin_entry","false")
	 end
    end
	local heimuya_entry=world.GetVariable("heimuya_entry")
	if heimuya_entry==nil then
	  if _exps>=1500000 then
	    world.SetVariable("heimuya_entry","true")
	 else
	    world.SetVariable("heimuya_entry","false")
	 end
	end
	local wudanghoushan_entry=world.GetVariable("wudanghoushan_entry")
	if wudanghoushan_entry==nil then
	   world.SetVariable("wudanghoushan_entry","false")
	end
    local tianshan_entry=world.GetVariable("tianshan_entry")
	if tianshan_entry==nil then
	   if _exps>=200000 then
	    world.SetVariable("tianshan_entry","true")
	   else
	    world.SetVariable("tianshan_entry","false")
	   end
	end
	local jueqinggu_entry=world.GetVariable("jueqinggu_entry")
    if jueqinggu_entry==nil then
	    if _exps>=200000 then
	      world.SetVariable("jueqinggu_entry","true")
	   else
	      world.SetVariable("jueqinggu_entry","false")
	   end
	end
    local taoyuan_entry=world.GetVariable("taoyuan_entry")
	if taoyuan_entry==nil then
	   world.SetVariable("taoyuan_entry","false")
	end
	local hudiegu_entry=world.GetVariable("hudiegu_entry")
	if hudiegu_entry==nil then
	   world.SetVariable("hudiegu_entry","false")
	end
	local sld_entry=world.GetVariable("sld_entry")
	if sld_entry==nil then
	    world.SetVariable("sld_entry","true")
	end
	local taohuadao_entry=world.GetVariable("taohuadao_entry")
	if taohuadao_entry==nil then
	   world.SetVariable("taohuadao_entry","false")
	end
	local mr_entry=world.GetVariable("mr_entry")
	if mr_entry==nil then
	   world.SetVariable("mr_entry","false")
	end
	local mty_entry=world.GetVariable("mty_entry")
	if mty_entry==nil then
	   world.SetVariable("mty_entry","false")
	end
	--
	local pfm1
	local pfm2
	local pfm3
	local pfm4
	local pfm5
	pfm1=world.GetVariable("pfm1")
	pfm2=world.GetVariable("pfm2")
	pfm3=world.GetVariable("pfm3")
	pfm4=world.GetVariable("pfm4")
	pfm5=world.GetVariable("pfm5")
	if pfm1==nil then
	  world.SetVariable("pfm1","")
	end
   if pfm2==nil then
	  world.SetVariable("pfm2","")
	end
	if pfm3==nil then
	  world.SetVariable("pfm3","")
	end
	if pfm4==nil then
	  world.SetVariable("pfm4","")
	end
	if pfm5==nil then
	  world.SetVariable("pfm5","")
	end
	--����heal ����
	local special_heal=world.GetVariable("special_heal")
	if special_heal==nil then
	   world.SetVariable("special_heal","false")
	end
	--wizard end
	local liandu=world.GetVariable("liandu")
	if liandu==nil then
	   world.SetVariable("liandu","")
	end
	--
	local is_canwu=world.GetVariable("is_canwu")
	if is_canwu==nil then
	   world.SetVariable("is_canwu","true")
	end
	wizard_end()
end

local _skills_id
function get_all_skills_id()
    wait.make(function()
	  local l,w=wait.regexp("^.*\\((.*)\\).*$|^(> |)�趨����������look \\= \"YES\"$",5)
	  if l==nil then
	     get_all_skills_id()
	     return
	  end
	  if string.find(l,")") then
	     _skills_id=_skills_id..w[1].."|"
	     get_all_skills_id()
	     return
	  end
	  if string.find(l,"�趨����������look") then
	     if string.len(_skills_id)>0 then
		    world.SetVariable("teach_skills",string.sub(_skills_id,1,-2))
		 end
	     return
	  end
	  wait.time(5)
	end)
end

function get_skill()
 -- local teach_skills
 --teach_skills=world.GetVariable("teach_skills")
 --if teach_skills==nil then
    --print("��Ҫ����teach_skills����: ��ѦĽ����skill���� �� dashou-yin|yuxue-dunxing|longxiang-boruo|huanxi-chan")
	world.Send("cha")
	world.Send("set look")
	--world.SetVariable("teach_skills","")
	_skills_id=""
	get_all_skills_id()
 --end
end

function ch_over()
   print("������")
end
--����������ȡ�����ٷ�֮��ʮ��    �����츳����          δ�����츳����      ��
function get_score()
	  wait.make(function()
	    local l,w=wait.regexp("^����    ����(.*)\\((.*)\\).*��$|^����    ��(.*)��$|^��.*ʦ    �У���(.*)����(.*)��.*|^��ע�᣺(.*)��$|^����    ν����(.*)��.*|^����������ȡ��(.*)�����츳��(.*)δ�����츳��(.*)��|^��.*ʦ    �У�����ͨ���ա�.*|.*ʦ    �У�����Ĺ�ɡ�.*",5)
		if l==nil then
		   auto_variable()
		   return
		end
		if string.find(l,"��    ��") then
		   world.SetVariable("player_name",Trim(w[1]))
		   world.SetVariable("player_id",w[2])
		   get_score()
		   return
		end
		if string.find(l,"��    ��") then
		  if string.find(w[3],"����") then
		     world.SetVariable("gender","����")
		  elseif string.find(w[3],"Ů��") then
             world.SetVariable("gender","Ů��")
          else
		      world.SetVariable("gender","��������")
          end
		   get_score()
		   return
		end
		if string.find(l,"��ͨ����") then
		   world.SetVariable("party","��")
		   world.SetVariable("mastername","��")
		   get_score()
		   return
		end
		if string.find(l,"��Ĺ��") and Trim(w[5])=="" then
		   --print(w[5],"  w5")
		    world.SetVariable("party","��Ĺ��")
		   world.SetVariable("mastername","��")
		   get_score()
           return
		end
		if string.find(l,"ʦ    ��") then
		   world.SetVariable("party",w[4])
		   world.SetVariable("mastername",w[5])
		   get_score()
		   return
		end
		if string.find(l,"ע��") then
		   if string.find( w[6],"��ͨ���") then
		      world.SetVariable("vip","��ͨ���")
		   elseif string.find(w[6],"����������") then
		      world.SetVariable("vip","����������")
		   else
		      world.SetVariable("vip","������")
		   end
		   wizard_start()
		   ch_over()
		   return
		end
		if string.find(l,"��    ν") then
			world.SetVariable("title",w[7])
		    get_score()
		   return
		end
		if string.find(l,"�����츳") then
		   local exert_reward=Trim(w[8])
		   exert_reward=string.gsub(exert_reward,"��","")
		   exert_reward=string.gsub(exert_reward,"��","")
		   if exert_reward=="��" then
		      world.SetVariable("exert_reward","0")
		   else
		      exert_reward=string.gsub(exert_reward,"�ٷ�֮","")
			  exert_reward=ChineseNum(exert_reward)
			  world.SetVariable("exert_reward",exert_reward)
		   end

		   local exert_gift=Trim(w[9])
		   if exert_gift=="��" then
		      world.SetVariable("exert_gift","0")
		   else
		      exert_gift=ChineseNum(exert_gift)
			  world.SetVariable("exert_gift",exert_gift)
		   end
		   local exert_unset_gift=Trim(w[10])
		   if exert_unset_gift=="��" then
		      world.SetVariable("exert_unset_gift","0")
		   else
		      exert_unset_gift=ChineseNum(exert_unset_gift)
		      world.SetVariable("exert_unset_gift",exert_unset_gift)
		   end
		   get_score()
		   return
		end
		wait.time(5)
	  end)
end

function auto_variable()
  --player_id ���� exps vip �������� �������ڼ��
---------------�Զ����---------------
  --world.SetVariable("get_exp","0")
  local h=hp.new()
  h.checkover=function()
      get_skill()
      world.Send("score")
	  get_score()
  end
  h:check()
end

wizard={
  jobslist={},
  jobs_auto_setting=false,
}
--1
function wizard:jobs_select()
    self.jobslist={}
    local yesno=utils.msgbox ("�Ƿ�ʹ�ó���������ϣ�", "����ѡ��", "yesno", "?")
	if yesno=="yes" then
	   local jobslist={
	     combo1="��ɽ1+ؤ��",
	     combo2="��ɽ2+����",
		 combo3="���ְ�+��ɽ",
		 combo4="�䵱+��ɽ1+����",
		 combo5="ѩɽ+��ɽ+���ְ�",
		 combo6="��ɽ1+����",
		 combo7="����+���ְ�",
		 combo8="ؤ��+���ְ�",
	   }

	     local select_job=utils.listbox ("ѡ����Ҫ������", "����ѡ��", jobslist)
         if select_job=="combo1" then
		    table.insert(self.jobslist,"hs")
			table.insert(self.jobslist,"gb")
			world.SetVariable("jobslist","hs|gb")
		 elseif select_job=="combo2" then
		     table.insert(self.jobslist,"hs2")
			table.insert(self.jobslist,"sx")
			world.SetVariable("jobslist","hs2|sx")
		 elseif select_job=="combo3" then
		    table.insert(self.jobslist,"ss")
			table.insert(self.jobslist,"cl")
			world.SetVariable("jobslist","cl|ss")
		 elseif select_job=="combo4" then
		    table.insert(self.jobslist,"wd")
			table.insert(self.jobslist,"sx")
			table.insert(self.jobslist,"hs")
			world.SetVariable("jobslist","wd|(hs|sx)")
		 elseif select_job=="combo5" then
		     table.insert(self.jobslist,"xs")
			table.insert(self.jobslist,"ss")
			table.insert(self.jobslist,"cl")
			world.SetVariable("jobslist","xs|(ss|cl)")
		 elseif select_job=="combo6" then
		    table.insert(self.jobslist,"hs")
			table.insert(self.jobslist,"sx")
			world.SetVariable("jobslist","hs|sx")
		 elseif select_job=="combo7" then
		    table.insert(self.jobslist,"sx")
			table.insert(self.jobslist,"cl")
			world.SetVariable("jobslist","sx|cl")
		 elseif select_job=="combo8" then
		    table.insert(self.jobslist,"gb")
			table.insert(self.jobslist,"cl")
			world.SetVariable("jobslist","gb|cl")
		 end
		 self.jobs_auto_setting=true
	     self:jobs_setting()
	    return

	end

  local jobs={
    xc="1.1 ����Ѳ��",
	tdh="2.1 ��ػ�",
	zc="2.2 ���߹�����",
	wd="3.1 �䵱",
	hs="3.2 ��ɽ1",
	hs2="3.3 ��ɽ2",
	sx="3.4 ��������",
	xs="4.1 ѩɽ",
	cl="4.2 ���ְ�",
	tx="5.1 Ľ��͵ѧ",
	suoming="5.2 ����������",
	sm="5.3 �һ�����Ĺ",
	ss="5.4 ����������",
	gb="5.5 ؤ��",
	zs="5.6 ץ��",
	jh="5.7 ����",
	tm="5.8 ���ֽ���ɮ",
	ck="5.9 �ɿ�",
	xl="6.0 ����Ѳ������",
	jy="6.1 ���־�Ԯ����",
	xxbug="6.2 ����ץ��",
	qqll="6.3 ��������������"

  }
  local select_job=utils.multilistbox ("ѡ����Ҫ������", "����ѡ��", jobs)
  if select_job then
     local str_jobs=""
	 for n,j in pairs(select_job) do
	   --if j==select_job then
	      --local name=n
		  --print(name)
	      table.insert(self.jobslist,n)
		  str_jobs=str_jobs..n.."|"
	   --end
	 end
	 if str_jobs~="" then
	   str_jobs=string.sub(str_jobs,1,-2)
	 end
     --for _,i in pairs(self.jobslist) do print(i) end
   local _jobs=utils.inputbox ("�����������", "����ѡ��", str_jobs, "����", 9)
   if _jobs then
       world.SetVariable("jobslist",_jobs)
   end
	self:jobs_setting()

  else
     self.jobslist={}
  end
end


function wizard:jobs_setting()
   for _,job in ipairs(self.jobslist) do
       print(job)
       if job=="wd" then
	     self:wudang_setting()
	   elseif job=="sx" then
	     self:songxin_setting()
	   elseif job=="hs" then
	     self:huashan_setting()
	   elseif job=="hs2" then
	     self:huashan2_setting()
	   elseif job=="xs" then
	     self:xueshan_setting()
	   elseif job=="cl" then
	     self:changle_setting()
	   elseif job=="gb" then
	     self:gaibang_setting()
	   elseif job=="tdh" then
	     self:tiandihui_setting()
	   elseif job=="xc" then
	     self:xuncheng_setting()
	    elseif job=="zc" then
		 self:zuocai_setting()
	   elseif job=="ss" then
		 self:songshan_setting()
	   elseif job=="suoming" then
	     self:suoming_setting()
	   elseif job=="zs" then
	      self:zhuashe_setting()
	   elseif job=="tm" then
	      self:teachmonk_setting()
	   elseif job=="tx" then
	      self:touxue_setting()
	   elseif job=="ck" then
	      self:caikuang_setting()
	   elseif job=="sm" then
		  self:shoumu_setting()
		elseif job=="xl" then
		  self:xunluo_setting()
		elseif job=="jy" then
		  self:jiuyuan_setting()
		elseif job=="qj" then
		  self:qiangjie_setting()
	  end
   end
end

function wizard:touxue_setting()
     --[[
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="tx" then
		     table.insert(jb1,j)
		  end
	   end

	   local _jb1=utils.listbox ("����͵ѧ���������job1:", "͵ѧ����", jb1)
	   if _jb1 then
	     result="tx|"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end]]
end

function wizard:xuncheng_setting()
   local drug={
     neixiwan="1 ��Ϣ��",
	 xujingdan="2 ������",
   }
   local _drug=utils.listbox ("����Ѳ�������ҩ:", "Ѳ������", drug)
   if _drug then
       world.SetVariable("xc_type",_drug)
   else
       return
   end

end

function wizard:caikuang_setting()
--[[
    if self.jobs_auto_setting==false then
	  local jb1={}
	   for _,j in ipairs(self.jobslist) do
		  table.insert(jb1,j)
	   end
       local _jb1=utils.listbox ("���òɿ����������job:", "�ɿ�����", jb1)
	   if _jb1 then
	   else
          return
	   end
	   local jb2={}
	    for _,j in ipairs(self.jobslist) do
	      if j~="ck" and j~=self.jobslist[_jb1] then
		     table.insert(jb2,j)
		  end
	   end
	   local _jb2=utils.listbox ("���òɿ����������job2:", "�ɿ�����", jb2)
	   if _jb2 then
	     result="ck|("..jb1[_jb1].."|"..jb2[_jb2]..")"
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
    end]]
	local ck_playId=utils.inputbox ("��ʯ��Ҫ�͸�����ҵ�ID����д��ʾ�Լ���������", "�ɿ�����", "", "����", 9)
   if ck_playId then
     world.SetVariable("ck_playId",ck_playId)
   else
     return
   end
end

function wizard:tiandihui_setting()
   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5",
	    }
	   local _pfm=utils.listbox ("������ػ�����ʹ�õ�pfm:", "��ػ�����", pfm)
	   if _pfm then
	      world.SetVariable("tdh_pfm",_pfm)
	   else
	      return
	   end
	   --[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="tdh" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("������ػ����������job1:", "��ػ�����", jb1)
	   if _jb1 then
	     result="tdh|"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:wudang_setting()

     local t={"1.����Ϊ��","2.��Ϊ�˵�","3.��������","4.���뻯��",}
	 local diff=utils.listbox ("�����䵱�����Ѷȵȼ�:", "�䵱����", t)
	 if diff~=nil then
	   world.SetVariable("difficulty",diff)
	 else
	   return
	 end

   local blacklist={}

    blacklist={
	    ["�䵱��"]="1.1 �䵱��",
		["������"]="1.2 ������",
		["������"]="1.3 ������",
		["��ɽ��"]="1.4 ��ɽ��",
		["������"]="1.5 ������",
		["ѩɽ��"]="1.6 ѩɽ��",
		["����Ľ��"]="1.7 ����Ľ��",
		["��Ĺ��"]="1.8 ��Ĺ��",
		["��ɽ��"]="1.9 ��ɽ��",
		["������"]="2.0 ������",
		["������"]="2.1 ������",
		["���ư�"]="2.2 ���ư�",
		["ؤ��"]="2.3 ؤ��",
		["�һ���"]="2.4 �һ���",
		["������"]="2.5 ������",
		["����"]="2.6 ����",
		["Τ����"]="3.1 Τ����",
		["���¾Ž�"]="3.2 ���¾Ž�",
		["��������"]="3.3 ��������",
		["�򹷰���"]="3.4 �򹷰���",
		["����ذ��"]="3.5 ����ذ��",
		["��а����"]="3.6 ��а����",
		["����ʮ����"]="3.7 ����ʮ����",
		["��ָ��ͨ"]="3.8 ��ָ��ͨ",
		["��ɽ�ȷ�"]="3.9 ��ɽ�ȷ�",
	  }

  local _blacklist=utils.multilistbox ("�����䵱���������", "�䵱����", blacklist)
  if _blacklist then
       --print(_menpai)
	  local result=""
      for n,i in pairs(_blacklist) do
		 result=result..n.."|"
	  end
	  if result~="" then
		result=string.sub(result,1,-2)
	  end
      world.SetVariable("wd_blacklist",result)
  else
      world.SetVariable("wd_blacklist","")
  end

	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("�����䵱����ʹ�õ�pfm:", "�䵱����", pfm)
	   if _pfm then
	      world.SetVariable("wd_pfm",_pfm)
	   else
	      return
	   end
	   local pfm_list={
	     pfm1_list="1 pfm1_list",
		 pfm2_list="2 pfm2_list",
		 pfm3_list="3 pfm3_list",
		 pfm4_list="4 pfm4_list",
		 pfm5_list="5 pfm5_list"
	   }
--^.*ֻ����.*�ѱ����ָ����У����β��ɵĻ���������$#���β��ɵĻ�������#wield xiao;jifa parry yuxiao-jian;jiali max;perform sword.feiying;yun qi;yun jingli&^.*���Ӱʹ�꣬��һ�ν�.*�û����С�$#���Ӱʹ��#unwield xiao;jiali 1;jifa parry tanzhi-shentong;perform finger.tan
	   local _pfm_list=utils.listbox("�����䵱����ʹ�õ�pfm_list ���û�����ʽ��������ͨ���1#ƥ�����1#ִ�е�����1&��������ͨ���2#ƥ�����2#ִ�е�����2\n��: ^.*ֻ����.*�ѱ����ָ����У����β��ɵĻ���������$#���β��ɵĻ�������#wield xiao;jifa parry yuxiao-jian;jiali max;perform sword.feiying&^.*���Ӱʹ�꣬��һ�ν�.*�û����С�$#���Ӱʹ��#unwield xiao;jifa parry tanzhi-shentong;perform finger.tan","�䵱����",pfm_list)
	   if _pfm_list then
	       world.SetVariable("wd_pfm_list",_pfm_list)
	   else
	       return
	   end

	  local all_skills_list=utils.inputbox ("�����˼�����ʹ�õ�pfm pfm_list ���û�����ʽ:��������1#pfm1#pfm1_list|��������2#pfm2#pfm2_list\n��:���¾Ž�#pfm1#pfm1_list|��ָ��ͨ#pfm2#|�򹷰���#pfm2#pfm2_list", "�䵱����", "", "����", 9)
	  if all_skills_list then
        world.SetVariable("all_skills_list",all_skills_list)
	  end
	--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      --print(j)
	      if j~="wd" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("�����䵱���������job:", "�䵱����", jb1)
	   if _jb1 then
	   else
          return
	   end
	   local jb2={}
	    for _,j in ipairs(self.jobslist) do
	      if j~="wd" and j~=self.jobslist[_jb1] then
		     table.insert(jb2,j)
		  end
	   end
	   local _jb2=utils.listbox ("�����䵱���������job2:", "�䵱����", jb2)
	   if _jb2 then
	     result="wd->"..jb1[_jb1].."->"..jb2[_jb2]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end


function wizard:songxin_setting()

	local yesno=utils.msgbox ("��һ�������Ƿ�����Ͷ�ݣ�����ɱ���Ƿ���֣�", "��������", "yesno", "?")
	if yesno=="yes" then
	  world.SetVariable("immediate_sx1","true")
    else
      world.SetVariable("immediate_sx1","false")
	end

	 local t={"1.��������2", "2.΢�����", "3.������", "4.С������", "5.�ڻ��ͨ","6.��Ϊ�˵�", "7.��������","8.���뻯��","9.ȫ����"}
	 local shashou_level=utils.listbox ("�ڶ�������ɱ�ֵȼ�ѡ��:", "��������", t)
	 if shashou_level~=nil then
	   world.SetVariable("shashou_level",shashou_level-1)
	 else
	   return
	 end

	local shashou_level=world.GetVariable("shashou_level")
    if tonumber(shashou_level)>=0 then
	 local blacklist={}

     blacklist={
	    ["�䵱��"]="1.1 �䵱��",
		["������"]="1.2 ������",
		["������"]="1.3 ������",
		["��ɽ��"]="1.4 ��ɽ��",
		["������"]="1.5 ������",
		["ѩɽ��"]="1.6 ѩɽ��",
		["����Ľ��"]="1.7 ����Ľ��",
		["��Ĺ��"]="1.8 ��Ĺ��",
		["��ɽ��"]="1.9 ��ɽ��",
		["������"]="2.0 ������",
		["������"]="2.1 ������",
		["���ư�"]="2.2 ���ư�",
		["ؤ��"]="2.3 ؤ��",
		["�һ���"]="2.4 �һ���",
		["������"]="2.5 ������",
		["����"]="2.6 ����",
		["Τ����"]="3.1 Τ����",
		["���¾Ž�"]="3.2 ���¾Ž�",
		["��������"]="3.3 ��������",
		["�򹷰���"]="3.4 �򹷰���",
		["����ذ��"]="3.5 ����ذ��",
		["��а����"]="3.6 ��а����",
		["����ʮ����"]="3.7 ����ʮ����",
		["��ָ��ͨ"]="3.8 ��ָ��ͨ",
		["��ɽ�ȷ�"]="3.9 ��ɽ�ȷ�",
	  }

      local _blacklist=utils.multilistbox ("�����������������", "��������", blacklist)
      if _blacklist then
       --print(_menpai)
	    local result=""
        for n,i in pairs(_blacklist) do
		 result=result..n.."|"
	    end
	    if result~="" then
		 result=string.sub(result,1,-2)
	    end
        world.SetVariable("sx_blacklist",result)
      else
        world.SetVariable("sx_blacklist","")
      end
	end

	  local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }

	  local pfm_list={
	    pfm1_list="1 pfm1_list",
		pfm2_list="2 pfm2_list",
		pfm3_list="3 pfm3_list",
		pfm4_list="4 pfm4_list",
		pfm5_list="5 pfm5_list"
	  }
	   local _pfm=utils.listbox ("���á�����1������ʹ�õ�pfm:", "��������", pfm)
	   if _pfm then
	      world.SetVariable("sx_pfm",_pfm)
	   else
	      return
	   end
	   local _pfm_list=utils.listbox ("���á�����1������ʹ�õ�pfm_list:", "��������", pfm_list)
	   if _pfm_list then
	      world.SetVariable("sx1_pfm_list",_pfm_list)
	   else
	      return
	   end
	   local _pfm=utils.listbox ("���á�����2������ʹ�õ�pfm:", "��������", pfm)
	   if _pfm then
	      world.SetVariable("sx2_pfm",_pfm)
	   else
	      return
	   end
	   local _pfm_list=utils.listbox ("���á�����2������ʹ�õ�pfm_list:", "��������", pfm_list)
	   if _pfm_list then
	      world.SetVariable("sx2_pfm_list",_pfm_list)
	   else
	      return
	   end
	--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="sx" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("�����������������job1:", "��������", jb1)
	   if _jb1 then
	     result="sx->"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:huashan_setting()
    local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("���û�ɽ����ʹ�õ�pfm:", "��ɽ����", pfm)
	   if _pfm then
	      world.SetVariable("hs_pfm",_pfm)
	   else
	      return
	   end

	    local yesno
		yesno =utils.msgbox ("�Ƿ��Զ������������������Ǵ󷨣�", "��ɽ����", "yesno", "?")
		if yesno=="yes" then
			world.SetVariable("quest_xxdf","true")
		else
			world.SetVariable("quest_xxdf","false")
		end
	--[[
	if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="hs" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("���û�ɽ���������job1:", "��ɽ����", jb1)
	   if _jb1 then
	     result="hs->"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:teachmonk_setting()
      local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("�������ֽ���ɮ����ʹ�õ�pfm:", "���ֽ���ɮ����", pfm)
	   if _pfm then
	      world.SetVariable("tm_pfm",_pfm)
	   else
	      return
	   end
	--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      --print(j)
	      if j~="tm" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("�������ֽ���ɮ���������job:", "���ֽ���ɮ����", jb1)
	   if _jb1 then
	   else
          return
	   end
	   local jb2={}
	    for _,j in ipairs(self.jobslist) do
	      if j~="tm" and j~=self.jobslist[_jb1] then
		     table.insert(jb2,j)
		  end
	   end
	   local _jb2=utils.listbox ("�������ֽ���ɮ������job2:", "���ֽ���ɮ����", jb2)
	   if _jb2 then
	     result="tm->"..jb1[_jb1].."->"..jb2[_jb2]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:huashan2_setting()
       local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("���û�ɽ1 ����ʹ�õ�pfm:", "��ɽ2����", pfm)
	   if _pfm then
	      world.SetVariable("hs_pfm",_pfm)
	   else
	      return
	   end

		local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("���û�ɽ2 ����ʹ�õ�pfm:", "��ɽ2����", pfm)
	   if _pfm then
	      world.SetVariable("hs2_pfm",_pfm)
	   else
	      return
	   end
	--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="hs" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("���û�ɽ2 ���������job1:", "��ɽ2����", jb1)
	   if _jb1 then
	     result="hs2->"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:xueshan_setting()
	  local blacklist={}
      blacklist={
	    ["�һ���"]="1 �һ���",
		["����&����"]="2 ����&����",
		["���ڸ���"]="3 ���ڸ���",
		["����&����"]="4 ����&����",
	  }
      local _blacklist=utils.multilistbox ("����ѩɽ���������", "ѩɽ����", blacklist)
      if _blacklist then
       --print(_menpai)
	    local result=""
        for n,i in pairs(_blacklist) do
		 result=result..n.."|"
	    end
	    if result~="" then
		 result=string.sub(result,1,-2)
	    end
        world.SetVariable("xs_blacklist",result)
      else
        world.SetVariable("xs_blacklist","")
      end

	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("����ѩɽ����ʹ�õ�pfm:", "ѩɽ����", pfm)
	   if _pfm then
	      world.SetVariable("xs_pfm",_pfm)
	   else
	      return
	   end
	local yesno =utils.msgbox ("�Ƿ������ɱ��", "ѩɽ����", "yesno", "?")
	if yesno=="yes" then
		world.SetVariable("xs_runkill","true")
	else
		world.SetVariable("xs_runkill","false")
	end
	--[[
	if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="xs" then
		     table.insert(jb1,j)
		  end
	   end

	    local _jb1=utils.listbox ("����ѩɽ���������job:", "ѩɽ����", jb1)
	   if _jb1 then
	   else
          return
	   end
	   local jb2={}
	    for _,j in ipairs(self.jobslist) do
	      if j~="xs" and j~=self.jobslist[_jb1] then
		     table.insert(jb2,j)
		  end
	   end
	   local _jb2=utils.listbox ("����ѩɽ���������job2:", "ѩɽ����", jb2)
	   if _jb2 then
	     result="xs->"..jb1[_jb1].."->"..jb2[_jb2]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:suoming_setting()
    local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("������������������ʹ�õ�pfm:", "��������������", pfm)
	   if _pfm then
	      world.SetVariable("suoming_pfm",_pfm)
	   else
	      return
	   end
	   --[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      --print(j)
	      if j~="suoming" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("�����������������������job:", "��������������", jb1)
	   if _jb1 then
	   else
          return
	   end
	   local jb2={}
	    for _,j in ipairs(self.jobslist) do
	      if j~="suoming" and j~=self.jobslist[_jb1] then
		     table.insert(jb2,j)
		  end
	   end
	   local _jb2=utils.listbox ("��������������������job2:", "��������������", jb2)
	   if _jb2 then
	     result="suoming->"..jb1[_jb1].."->"..jb2[_jb2]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:zhuashe_setting()
	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("����ץ������ʹ�õ�pfm:", "ؤ��ץ������", pfm)
	   if _pfm then
	      world.SetVariable("zs_pfm",_pfm)
	   else
	      return
	   end
	   --[[
   if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="cl" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("����ץ������ʹ�õ�pfm:", "ؤ��ץ������", jb1)
	   if _jb1 then
	     result="zs->"..jb1[_jb1]
		 print(result)
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:changle_setting()
	  local blacklist={}
      blacklist={
	    ["�һ���"]="1 �һ���",
		["������"]="2 ������",
	  }
      local _blacklist=utils.multilistbox ("���ó��ְ����������", "���ְ�����", blacklist)
      if _blacklist then
       --print(_menpai)
	    local result=""
        for n,i in pairs(_blacklist) do
		 result=result..n.."|"
	    end
	    if result~="" then
		 result=string.sub(result,1,-2)
	    end
        world.SetVariable("cl_blacklist",result)
      else
        world.SetVariable("cl_blacklist","")
      end

	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("���ó��ְ�����ʹ�õ�pfm:", "���ְ�����", pfm)
	   if _pfm then
	      world.SetVariable("cl_pfm",_pfm)
	   else
	      return
	   end
	--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="cl" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("���ó��ְ����������job1:", "���ְ�����", jb1)
	   if _jb1 then
	     result="cl->"..jb1[_jb1]
		 print(result)
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:gaibang_setting()
  	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("����ؤ������ʹ�õ�pfm:", "ؤ������", pfm)
	   if _pfm then
	      world.SetVariable("gb_pfm",_pfm)
	   else
	      return
	   end
	   local gb_blacklist=world.GetVariable("gb_blacklist") or "�ɹ��|������|�嶾��Ů����|�˵�����|���ҹ���|éʮ��|������|���ϴ��|������|�͵�ŵ|�ܹ�ͩ|���Ӣ|ժ����|ʨ����|��Ȼ��|�ɹ���ʿ|ʷ��ͷ|������|����|���ĵ�|�����|������|�����|�����|���ƹ�|�ź���|������|ѦĽ��|�ֲ�|������"
	   gb_blacklist=utils.inputbox ("��Ҫ����gb_blacklist ����: ؤ���������ε�NPC �� �ɹ��|������|�嶾��Ů����|�˵�����|���ҹ���|éʮ��|������|���ϴ��|������|�͵�ŵ|�ܹ�ͩ|���Ӣ|ժ����|ʨ����|��Ȼ��|�ɹ���ʿ|ʷ��ͷ|������|����|���ĵ�|�����|������|�����|�����|���ƹ�|�ź���|������|ѦĽ��|�ֲ�|������", "ؤ������", gb_blacklist, "����", 9)
       if gb_blacklist~=nil then
          world.SetVariable("gb_blacklist",gb_blacklist)
       end
	--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="cl" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("����ؤ�����������job1:", "ؤ������", jb1)
	   if _jb1 then
	     result="gb->"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:xunluo_setting()
  	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("��������Ѳ������ʹ�õ�pfm:", "����Ѳ������", pfm)
	   if _pfm then
	      world.SetVariable("xl_pfm",_pfm)
	   else
	      return
	   end


	  local yesno=utils.msgbox ("�Ƿ�ȴ���ӡʱ�����(Ѳ���˶�ʱ����ùر�)", "����Ѳ������", "yesno", "?")
	   if yesno=="yes" then
	     world.SetVariable("xl_xiulian","true")
	   else
	     world.SetVariable("xl_xiulian","false")
	   end
--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="xl" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("��������Ѳ�����������job1:", "����Ѳ������", jb1)
	   if _jb1 then
	     result="xl->"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:jiuyuan_setting()
  	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("�������־�Ԯ����ʹ�õ�pfm:", "���־�Ԯ����", pfm)
	   if _pfm then
	      world.SetVariable("jy_pfm",_pfm)
	   else
	      return
	   end
	 --[[
	if self.jobs_auto_setting==false then
		local jb1={}
		for _,j in ipairs(self.jobslist) do
	      if j~="sm" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("�������־�Ԯ���������job:", "���־�Ԯ����", jb1)
	   if _jb1 then
	   else
          return
	   end
	   local jb2={}
	    for _,j in ipairs(self.jobslist) do
	      if j~="jy" and j~=self.jobslist[_jb1] then
		     table.insert(jb2,j)
		  end
	   end
	   local _jb2=utils.listbox ("�������־�Ԯ���������job2:", "���־�Ԯ����", jb2)
	   if _jb2 then
	     result="sm->"..jb1[_jb1].."->"..jb2[_jb2]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:shoumu_setting()
  	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("������Ĺ����ʹ�õ�pfm:", "��Ĺ����", pfm)
	   if _pfm then
	      world.SetVariable("sm_pfm",_pfm)
	   else
	      return
	   end
	--[[
	if self.jobs_auto_setting==false then
		local jb1={}
		for _,j in ipairs(self.jobslist) do
	      if j~="sm" then
		     table.insert(jb1,j)
		  end
	   end
	   local _jb1=utils.listbox ("������Ĺ���������job:", "��Ĺ����", jb1)
	   if _jb1 then
	   else
          return
	   end
	   local jb2={}
	    for _,j in ipairs(self.jobslist) do
	      if j~="sm" and j~=self.jobslist[_jb1] then
		     table.insert(jb2,j)
		  end
	   end
	   local _jb2=utils.listbox ("������Ĺ������job2:", "��Ĺ����", jb2)
	   if _jb2 then
	     result="sm->"..jb1[_jb1].."->"..jb2[_jb2]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:qiangjie_setting()
  	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("����������������ʹ�õ�pfm:", "��������", pfm)
	   if _pfm then
	      world.SetVariable("qj_pfm",_pfm)
	   else
	      return
	   end
--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   local _jb1=utils.listbox ("�����������ٺ�����job1:", "��������", jb1)
	   if _jb1 then
	     result="qj->"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:songshan_setting()
  	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("������ɽ���� ������ʹ�õ�pfm:", "��ɽ����", pfm)
	   if _pfm then
	      world.SetVariable("ss_fight_pfm",_pfm)
	   else
	      return
	   end


	   local pfm={
	     pfm1="1 pfm1",
		 pfm2="2 pfm2",
		 pfm3="3 pfm3",
		 pfm4="4 pfm4",
		 pfm5="5 pfm5"
	    }
	   local _pfm=utils.listbox ("������ɽ���� ��ɱ��ʹ�õ�pfm:", "��ɽ����", pfm)
	   if _pfm then
	      world.SetVariable("ss_kill_pfm",_pfm)
	   else
	      return
	   end


	   local ss_blacklist=world.GetVariable("ss_blacklist")
	   ss_blacklist=utils.inputbox ("��Ҫ����ss_blacklist ����: ��ɽ�������εļ��ܻ����� �� ������|������ ", "��ɽ����", ss_blacklist, "����", 9)
       if ss_blacklist~=nil then
          world.SetVariable("ss_blacklist",ss_blacklist)
       end
	if self.jobs_auto_setting==false then
	   local jb1={}
	   for _,j in ipairs(self.jobslist) do
	      if j~="ss" then
		     table.insert(jb1,j)
		  end
	   end
	   --[[
	   local _jb1=utils.listbox ("������ɽ���������job1:", "��ɽ����", jb1)
	   if _jb1 then
	     result="ss->"..jb1[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end]]
	end
end

function wizard:zuocai_setting()

--[[	   local _jb1=utils.listbox ("���ú��߹����˺�����job1:", "���߹���������", self.jobslist)
	if self.jobs_auto_setting==false then
	   if _jb1 then
	     local result="zc->"..self.jobslist[_jb1]
	     local jobslist=world.GetVariable("jobslist")
	     if jobslist==nil or jobslist=="" then
           world.SetVariable("jobslist",result)
	     else
           world.SetVariable("jobslist",jobslist.."|"..result)
	     end
	   end
	end]]
end

function wizard:skills_select()
	   local up={
	     learn="1 ѧʦ��",
		 literate="2 ѧ����ʶ��",
		 zhizhao="3 ѧ֯��",
		 duanzao="4 ѧ����",
		 lingwu="5 ��ĦԺ����",
		 taojiao="6 �����ֽ�",
		 shenzhaojing="7 ���վ�",
		 chenggao="8 �ɸߵ���"
	    }
	   local _up=utils.listbox ("������ʽ:", "��������", up)
	   if _up then
	      world.SetVariable("up",_up)
	   else
	      return
	   end

	local up=world.GetVariable("up")
	if up=="learn" then
	  local master_id=utils.inputbox ("���ʦ��[id]?", "��������", "", "����", 9)
	  if master_id then
        world.SetVariable("masterid",master_id)
	  end
     local master_place=utils.inputbox ("ʦ�����ڷ����?", "��������", "", "����", 9)
	 if master_place then
       world.SetVariable("master_place",master_place)
	 end
     local sleeproomno=utils.inputbox ("˯���ķ����?", "��������", "", "����", 9)
	 if sleeproomno then
	  world.SetVariable("sleeproomno",sleeproomno)
	 end
      local pot=utils.inputbox ("ÿ��ѧϰ���ĵ�pot��?", "��������", "1", "����", 9)
	 if pot then
       world.SetVariable("pot",pot)
	 end
	end

		local bei_up={
	     learn="1 ѧʦ��",
		 lingwu="2 ��ĦԺ����",
	    }
	   local _bei_up=utils.listbox ("��������ʽ(gold ���������Զ��л�):", "��������", bei_up)
	   if _bei_up then
	      world.SetVariable("bei_up",_bei_up)
	   else
	      return
	   end
	  --ѧϰ ����� skills ѡ��
	if up=="learn" then

	  local teach_skills=world.GetVariable("teach_skills")
	  local _skills=Split(teach_skills,"|")
      local _list=utils.multilistbox ("����ѧϰ����(����ѡ��) �ֶ�����������skills���м���ѧϰ���Ⱥ�˳��,���� zui-gun&tiegun|liuhe-dao&mu dao ֧��װ���Զ�������", "��������", _skills)
	   if _list then
       --print(_menpai)
	    local result=""
        for n,i in pairs(_list) do
		 result=result.._skills[n].."|"
		 print(result)
	    end
	    if result~="" then
		 result=string.sub(result,1,-2)
	    end
         world.SetVariable("skills",result)
      else
        return
      end
	end
	 -- �� skills ����ѡ��
	if up=="lingwu" then
	 local baseskills={}
	 --1 ��������
	 local teach_skills=world.GetVariable("teach_skills")
	 local _skills=Split(teach_skills,"|")
	 local _special_skills=Split(teach_skills,"|")
	 for i=table.getn(_skills),1,-1 do
	   if _skills[i]~="force" and _skills[i]~="parry" and _skills[i]~="dodge" and _skills[i]~="sword" and _skills[i]~="blade" and _skills[i]~="dagger" and _skills[i]~="whip" and _skills[i]~="staff" and _skills[i]~="hook" and _skills[i]~="club" and _skills[i]~="stick" and _skills[i]~="spear" and _skills[i]~="hammer" and _skills[i]~="strike" and _skills[i]~="cuff" and _skills[i]~="hand" and _skills[i]~="claw" and _skills[i]~="leg" and _skills[i]~="finger" and _skills[i]~="throwing" and _skills[i]~="axe" and _skills[i]~="brush" then
	     table.remove(_skills,i)
	   else
	     table.remove(_special_skills,i)
	   end
	 end
	 local _list=utils.multilistbox ("��Ҫ���Ļ���������(����ѡ��)", "��������", _skills)
	 if _list then
        for n,i in pairs(_list) do
		  --print(n,_skills[n])
		  table.insert(baseskills,_skills[n])
	    end
	 else
        return
	 end
	 --2 ���⼼��
	 --print("lian skills ����2 �ͻ�������Ӧ�����书���á� �� bihao-chaosheng��Ӧforce,lanhua-shou��Ӧhand")
	 local specialskills={}
	 for _,value in ipairs(baseskills) do
	   local special_skills={}
	   local _special_index=utils.listbox ("��"..value.."��Ӧ�������书:", "��������", _special_skills)
	   if _special_index then
	       local result=_special_skills[_special_index].."&"..value
		   print(result)
		   table.insert(specialskills,result)
	   else
	      return
	   end
	 end
	 --����ļ���
	 local result=""
	 for n,i in ipairs(baseskills) do
		result=result..i.."|"
	 end
	 if result~="" then
		result=string.sub(result,1,-2)
	 end
	 world.SetVariable("skills",result)
	 --����ļ���
	 local result=""
	 for n,i in ipairs(specialskills) do
	    result=result..i.."|"
	 end
	 if result~="" then
		result=string.sub(result,1,-2)
	 end
	 world.SetVariable("lian_skills",result)
	end
	--3 ready ִ�к���

	local lingwu_finish=utils.inputbox ("��������Ժ�ִ�е�����,����jifa force bihai-chaoshen;jifa sword yuxiao-jian\n�����Ժ�����bei jifa ����ʹ�á�", "��������", "", "����", 9)
   if lingwu_finish then
     world.SetVariable("lingwu_finish",lingwu_finish)
   else
     return
   end
end

function wizard:equipments()

   local i_equip_sample="���ܴ�ȫ <��ȡ> <����> <����> <����> <����> <ʹ��> <�Զ�����> <����>\n"
  i_equip_sample=i_equip_sample .."1.<��ȡ>��Ʒ����&���� ����<��ȡ>ľ��&2|<��ȡ>����&50\n"
  i_equip_sample=i_equip_sample .."2.<����>��&����~{�ų�1,�ų�2} ���Զ�������������,Ƥ�ס�����{��ѡ���дĬ����1}.\n�ų�~{��⬼�}���������⬼�\n"
  i_equip_sample=i_equip_sample .."3.<����>��Ʒ���� ������ʱ����Զ��˳�\n"
  i_equip_sample=i_equip_sample .."4.<����>��~{����}|<����>����&200 ���Զ������� ��������200 ���Զ�����\n"
  i_equip_sample=i_equip_sample .."5.<����>����|<����>����\n"
  i_equip_sample=i_equip_sample .."6.<ʹ��>ʮ����������|<ʹ��>��|<ʹ��>�� �Զ��Խ�����ҩ�����������\n"
  local i_equip= world.GetVariable("i_equip") or ""
  local i_equip=utils.inputbox(i_equip_sample, "��Ʒ����", i_equip, "����", 9)
  if i_equip then
     world.SetVariable("i_equip",i_equip)
  else
     return
  end
end

function wizard:other()
   local neili_upper=utils.inputbox ("����ǰ������������ 1~1.9��ֵ", "��������", "1.5", "����", 9)
   if neili_upper then
       world.SetVariable("neili_upper",neili_upper)
   else
       return
   end
   local _xiulian={
		xiulian_neili="1 ��������",
		xiulian_jingli="2 ��������",
	}
	local xiulian=utils.listbox ("����busyʱ��������������:", "��������", _xiulian,"xiulian_neili")
	if xiulian then
		world.SetVariable("xiulian",xiulian)
	else
		return
	end

   local pot_overflow=world.GetVariable("pot_overflow") or "20"
   pot_overflow=utils.inputbox("pot����ֵ ���pot-��ǰpot<=����ֵʱ��ֹͣjob ȥѧϰ��������pot���������ѧϰ�������ֵ���ó�-1", "��������", pot_overflow, "����", 9)
   if pot_overflow then
       world.SetVariable("pot_overflow",pot_overflow)
   else
       return
   end
   local wuxing=utils.inputbox("ѧϰǰ��ǰ���Ķ������� ����yun maze;yun xinjing װ�� wield ��Ȫ��", "��������", "", "����", 9)
   if wuxing then
       world.SetVariable("wuxing",wuxing)
   else
      -- return
   end
   local sp_exert=world.GetVariable("sp_exert")
   local shield=utils.inputbox("ս��ǰ��ǰ���Ķ������ñ���װ���������԰������������json��ʽ �� \"��ɽ1\":\"wield sword\",\"ȫ��\":\"bei none;bei strike;unwield zhen;unwield jian;wield yinshe sword;wield jian;yun huti\"", "��������", sp_exert, "����", 9)
   if shield then
       world.SetVariable("sp_exert",shield)
	else
	   world.SetVariable("sp_exert","\"ȫ��\":\"\"")
   end

	 local yesno=utils.msgbox ("�Ƿ��Զ���������:", "��������", "yesno", "?")
	     if yesno=="no" then
            world.SetVariable("is_canwu","false")
         else
			world.SetVariable("is_canwu","true")
			local canwu_exps_limit=utils.inputbox("���پ��鿪ʼ������⾭��?", "��������", "15000000", "����", 9)
            if canwu_exps_limit then
              world.SetVariable("canwu_exps_limit",canwu_exps_limit)
	        end
	        local canwu_gift_limit=utils.inputbox("���پ��鿪ʼ�����츳��", "��������", "20000000", "����", 9)
            if canwu_gift_limit then
              world.SetVariable("canwu_gift_limit",canwu_gift_limit)
	        end
		 end


   local pfm1=world.GetVariable("pfm1")
   local pfm2=world.GetVariable("pfm2")
   local pfm3=world.GetVariable("pfm3")
   local pfm4=world.GetVariable("pfm4")
   local pfm5=world.GetVariable("pfm5")
   local _pfm1=utils.inputbox("pfm1 alias����", "��������", pfm1, "����", 9)
   if _pfm1 then
      world.SetVariable("pfm1",_pfm1)
   else
   end

   local _pfm2=utils.inputbox("pfm2 alias����", "��������", pfm2, "����", 9)
   if _pfm2 then
      world.SetVariable("pfm2",_pfm2)
   else
   end

   local _pfm3=utils.inputbox("pfm3 alias����", "��������", pfm3, "����", 9)
   if _pfm3 then
      world.SetVariable("pfm3",_pfm3)
   else
   end

   local _pfm4=utils.inputbox("pfm4 alias����", "��������", pfm4, "����", 9)
   if _pfm4 then
      world.SetVariable("pfm4",_pfm4)
   else
   end

   local _pfm5=utils.inputbox("pfm5 alias����", "��������", pfm5, "����", 9)
   if _pfm5 then
      world.SetVariable("pfm5",_pfm5)
   else
   end

   local _blockNPC={
		["fan yiweng"]="1 ��һ��",
		["yin liting"]="2 ����ͤ",
		["huang lingtian"]="3 ������*",
		["ling zhentian"]="4 ������*",
		["chuchen zi"]="5 ������*",
		["xi huazi"]="6 ������",
		["hong xiaotian"]="7 ������",
		["xuansheng dashi"]="8 ������ʦ*",
		["yang xiao"]="9 ����*",
		["fan yao"]="10 ��ң",
		["he taichong"]="11 ��̫��",
		["hufa shizhe"]="12 ����ʹ��*",
		["wu seng"]="13 ��ɮ",
		["zhang songxi"]="14 ����Ϫ",
		["zhao liangdong"]="15 ������",
		["ding mian"]="16 ����",
		["yu lianzhou"]="17 ������",
		["huizhen zunzhe"]="18 ��������*",
		["dadian dashi"]="19 ����ʦ*",
	    ["murong bo"]="20 Ľ�ݲ�", }

  local blockNPC=utils.multilistbox("��·npc ʹ��pfm����:", "��������", _blockNPC)
  local result=""
  for n,i in pairs(_blockNPC) do
	 result=result..n.."|"
  end
  if result~="" then
	 result=string.sub(result,1,-2)
  end
  world.SetVariable("blockNPC",result)

  local cmd=world.GetVariable("cmd")
  local _cmd=utils.inputbox("cmd �Ե�·NPCʹ��pfm��alias����", "��������", cmd, "����", 9)
   if _cmd then
      world.SetVariable("cmd",_cmd)
   else
   end
end

function wizard:special_heal()
   local liao_percent=world.GetVariable("liao_percent")
   local _liao_percent=utils.inputbox("��ѦĽ��������Ѫ�ٷֱ�����", "����", liao_percent, "����", 9)
   if _liao_percent then
      world.SetVariable("liao_percent",_liao_percent)
   else
   end
  local party=world.GetVariable("party")
  if party=="����" then
	 local yesno=utils.msgbox ("�Ƿ�ȥ�������Һ���ţ���ˣ�", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("special_heal","hudiegu")
	 end
  end
   local yesno=utils.msgbox ("�Ƿ�ʹ������������ľ�Ѫ���ˣ�", "����", "yesno", "?")
	if yesno=="yes" then
	   world.SetVariable("special_heal","juxue")
	end
	local yesno=utils.msgbox ("�Ƿ�ʹ��һ��ָ���ˣ�", "����", "yesno", "?")
	if yesno=="yes" then
	   world.SetVariable("special_heal","liao")
	end
end

function wizard:zone()

	 local yesno=utils.msgbox ("�Ƿ�ȥ�������֣�", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("putian_entry","true")
	 else
	   world.SetVariable("putian_entry","false")
	 end

	  local yesno=utils.msgbox ("�Ƿ�ȥ��ɽ���֣�", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("shaolin_entry","true")
	 else
	   world.SetVariable("shaolin_entry","false")
	 end

	 local yesno=utils.msgbox ("�Ƿ�ȥ��ľ�£�", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("heimuya_entry","true")
	 else
	   world.SetVariable("heimuya_entry","false")
	 end


	 local yesno=utils.msgbox ("�Ƿ�ȥ�䵱��ɽ��", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("wudanghoushan_entry","true")
	 else
	   world.SetVariable("wudanghoushan_entry","false")
	 end

	 local yesno=utils.msgbox ("�Ƿ�ȥ��ɽ��", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("tianshan_entry","true")
	 else
	   world.SetVariable("tianshan_entry","false")
	 end


	 local yesno=utils.msgbox ("�Ƿ�ȥ����ȣ�", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("jueqinggu_entry","true")
	 else
	   world.SetVariable("jueqinggu_entry","false")
	 end

	 local yesno=utils.msgbox ("�Ƿ�ȥ��Դ��", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("taoyuan_entry","true")
	 else
	   world.SetVariable("taoyuan_entry","false")
	 end

	 local yesno=utils.msgbox ("�Ƿ�ȥ�����ȿ", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("hudiegu_entry","true")
	 else
	   world.SetVariable("hudiegu_entry","false")
	 end

	 local yesno=utils.msgbox ("�Ƿ�ȥ������?", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("sld_entry","true")
	 else
	   world.SetVariable("sld_entry","false")
	 end

	 local yesno=utils.msgbox ("�Ƿ�ȥ�嶾��?", "����", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("wdj_entry","true")
	 else
	   world.SetVariable("wdj_entry","false")
	 end
end

function wizard:plugin()

   local afk_cmd=world.GetVariable("afk_cmd")
   local afk_sec=world.GetVariable("afk_sec")

   local _afk_cmd=utils.inputbox("��������������������(�������뷢���Ժ������䵱�����������дWeapon_Check(process.wd)��\nWeapon_Check��ʾ�������,process.wd���䵱����Ľ���,����д���ͱ�ʾ��������Ժ������䵱����)", "�������", afk_cmd, "����", 9)
   if _afk_cmd then
      world.SetVariable("afk_cmd",_afk_cmd)
   else
   end
   local _afk_sec=utils.inputbox("����ʱ��������(��),������趨ʱ����û���κ�ָ���������Ϊ�����ˣ�һ������Ϊ60", "�������", afk_sec, "����", 9)
   if _afk_sec then
      world.SetVariable("afk_sec",_afk_sec)
      if GetPluginList()~=nil then
        for k, v in pairs (GetPluginList()) do
         if GetPluginInfo(v, 1)=="reconnect2" then
           local PluginID=GetPluginInfo(v, 7)
	       local afk_sec=tonumber(world.GetVariable("afk_sec")) or 60
	       CallPlugin(PluginID, "set_AFKTime", afk_sec)
		   CallPlugin(PluginID, "Enable_AFK")
          end
        end
      end
   else
   end
   	 local yesno=utils.msgbox ("�Ƿ���ʾС��ͼ?", "���", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("mini_map","true")
	 else
	   world.SetVariable("mini_map","false")
	 end
end

function loadnode (node)

  -- root node won't have a name
  local tag_type=""
  local tag_content=""
  local tag_name=""
  if node.name ~= "" then

    -- show node name followed by attributes (if any)
    --Tell ("<" .. node.name)
	tag_type=node.name
    if node.attributes then
      --print ""
      for k, v in pairs (node.attributes) do
        --print ("  " .. k .. '="' .. FixupHTML (v) .. '"')
		if k=="name" then
		  tag_name=v
		end
      end -- doing attributes
    end -- if

    if node.empty then
      --print ("/>")
      return  -- no closing tag
    else
      --Tell (">")
    end -- if

  end -- if have a node name

  -- print node contents
  --Tell (FixupHTML (node.content))
  tag_content=node.content

  -- do children
  if node.nodes then
    for k, v in ipairs (node.nodes) do
      loadnode (v)
    end -- for
  end -- of having children

  -- root node won't have a name
  if node.name ~= "" then

	-- closing tag
    --print ("</" .. node.name .. ">")
	if tag_type=="variable" then
	   print("�������:",tag_name," ",tag_content)
	   world.SetVariable(tag_name,tag_content)
	end

  end -- if have a node name

end -- writenode

function wizard:update_webconfig()
   local player_id=world.GetVariable("player_id") or ""
   local world_address=world.GetVariable("world_address") or ""
   local id=player_id.."@"..world_address
   local config_updated=utils.msgbox ("�Ƿ񽫵�ǰ�����ϴ�������?", "���þ���", "yesno", "?")
   if config_updated=="yes" then
		--��ǰ���б���
		local variables=""
		for k, v in pairs (GetVariableList()) do
           --Note (k, " = ", v)
		   if k~="world_address" then
		     config_txt=string.gsub(v,"<","lt;")
	         config_txt=string.gsub(config_txt,">","gt;")
		     config_txt=string.gsub(config_txt,"+","2b;")
		   --config_txt=string.gsub(config_txt,"&","&amp;")
		     variables=Trim(variables).."<variable name=\""..k.."\">"..config_txt.."</variable>"
		   end
        end
       local config_txt=utils.inputbox("�뽫������Ϣ���Ƶ��������", "���þ���", variables, "����", 9)

	   --config_txt=string.gsub(config_txt,"&amp;","&")
       --print(config_txt)
	   package.loaded["webServer"]=nil
	   require "webServer"
       webServer:Config_Save(id,config_txt)
	   package.loaded["webServer"]=nil
	   print("�ϴ����ý���!")
   end

end

function wizard:select_settings(flag)
   --ѡ���������ݣ�
   local mastername=world.GetVariable("mastername") or ""
   local exps=world.GetVariable("exps") or "0"
   local player_name=world.GetVariable("player_name") or ""
   local player_id=world.GetVariable("player_id") or ""
   local world_address=world.GetVariable("world_address") or ""
   local party=world.GetVariable("party") or ""
   local gender=world.GetVariable("gender") or "����"
   local exert_gift=world.GetVariable("exert_gift") or "0"
   local exert_reward=world.GetVariable("exert_reward") or "0"
   --[[
   local url="http://112.65.143.180:9001/SJMain.aspx?mastername="..mastername.."&exps="..exps.."&name="..player_name.."&id="..player_id.."&party="..party.."&gender="..gender.."&exert_gift="..exert_gift.."&exert_reward="..exert_reward
   --print(url)
   local xml=""
    local is_download=utils.msgbox ("�Ƿ�ӷ��������������ļ�?", "���þ���", "yesno", "?")
	if is_download=="yes" then
	    local id=player_id.."@"..world_address
		package.loaded["webServer"]=nil
		require "webServer"
	    xml=webServer:Config_Get(id)
		package.loaded["webServer"]=nil
		print("_______________________�����ļ��������_________________________________")
		xml=string.gsub(xml,"&lt;","<")
		xml=string.gsub(xml,"&gt;",">")
	else
	   local yesno =utils.msgbox ("�Ƿ���Ҫǰ�����߰�����վ���û�����?", "���þ���", "yesno", "?")
	   if yesno=="yes" then
	      world.OpenBrowser(url)
	   end
	end

	local loadingVariable=false
	 loadingVariable=utils.msgbox("�Ƿ���������Ϣ","���þ���","yesno","?")
	 if loadingVariable=="yes" then
	       local xml_txt=utils.inputbox("�뽫������Ϣ���Ƶ��������", "���þ���", xml, "����", 9)
           if xml_txt then

			 xml_txt=string.gsub(xml_txt,"&","&amp;")
			 xml_txt=string.gsub(xml_txt,"lt;","&lt;")
			 xml_txt=string.gsub(xml_txt,"gt;","&gt;")
			  xml_txt=string.gsub(xml_txt,"2b;","+")


			 --print(xml_txt)
			 xml_txt="<variables>"..xml_txt.."</variables>"
             local value=world.ImportXML(xml_txt)
			 if value>0 then
			    utils.msgbox("��������ɹ�,��"..value.."���롣","���þ���","ok","?")
			 else
                utils.msgbox("��ʽ������ʧ��!","���þ���","ok","?")
			 end
           end
	 end]]

	  local loadingVariable=false
	  loadingVariable=utils.msgbox("�Ƿ��������ļ�","���þ���","yesno","?")
	  if loadingVariable=="yes" then
	     local filter = { txt = "Text files", ["*"] = "All files" }
	     local filename = utils.filepicker ("�����ļ�", name, "txt", filter, false)
		 local f = assert (io.open (filename, "r"))  -- open it
		 local s = f:read ("*a")  -- read all of it
         --print (s)  -- print out
         f:close ()  -- close it
	     local a, b, c = utils.xmlread (s)
		--tprint (a)
         loadnode(a)
		 process.check()
	      return
	  end
     local yesno
     if flag==nil then
        yesno =utils.msgbox ("�Ƿ��һ������?", "���þ���", "yesno", "?")
	 end
	 if yesno=="yes" and flag==nil then
	      self:plugin()
	      self:jobs_select()
          self:skills_select()
	      self:equipments()
	      self:other()
	      self:special_heal()
	      self:zone()
	 else
	       local model=utils.listbox ("ѡ����Ҫ���õ�ģ��", "ѡ��ģ��", { "1.�������", "2.����˳������", "3.����ѡ������", "4.װ������","5.��������","6.������������","7.�����������" })
		   if model==1 then
		      self:plugin()
		   elseif model==2 then
		      self:jobs_select()
		   elseif model==3 then
		      self:skills_select()
		   elseif model==4 then
		      self:equipments()
		   elseif model==5 then
		      self:other()
		   elseif model==6 then
		      self:special_heal()
		   elseif model==7 then
		      self:zone()
		   end
		   --
		    local yesno=utils.msgbox ("�Ƿ��������?", "���þ���", "yesno", "?")
			if yesno=="yes" then
			     print("---------------------------------------------------------")
				 register() --����ע��
				 world.ColourNote ("red", "yellow", "���ý�������������ʼ������")
			else
			    self:select_settings(true)
			end

	 end

end

function mousedown()
  return function (flags, hotspot_id)
    --print(flags)

	if flags==16 then
      wizard:start()
	end
  end
end

function stopRobot()
  return function (flags, hotspot_id)
    --print(flags)
     print("ֹͣ������")
	if flags==16 then
      shutdown()
	end
  end
end

function mapHere()
   return function(flags,hotspot_id)
      if flags==16 then
	     Map_Here()
	  end
   end
end

local help_win = "help_window"
local help_win_width = 240
local help_win_height = 25
local FONT_NAME = "f1"
local FONT_SIZE = "9"
local left = 50
local top = 10
--[[
local stop_win= "stop_window"
local stop_win_width = 40
local stop_win_height = 25
local FONT_NAME = "f1"
local FONT_SIZE = "9"]]

function switchmode()
  return function(flags,hotspot_id)
      if flags==16 then
        for k, v in pairs (GetPluginList()) do
            if GetPluginInfo(v, 1)=="reconnect2" then

				local PluginID=GetPluginInfo(v, 7)
			    local value=GetPluginVariable(PluginID,"is_afk")
				if value=="true" then
				    print("�ֶ�ģʽ")
				    CallPlugin(PluginID, "Disable_AFK")
				else
				    print("�һ�ģʽ")
			        CallPlugin(PluginID, "Enable_AFK")
			    end

            end
         end

	  end
  end
end

local function pots_bank(pots,callback)
   local w=walk.new()
   w.walkover=function()
       world.Send("qn_qu "..pots)
	   local b=busy.new()
	   b.Next=function()
	      callback()
	   end
	   b:check()
   end
   w:go(4067)
end

function startjob()
  return function(flags,hotspot_id)
	if flags==16 then

	     local jobs={
    xc="1.1 ����Ѳ��",
	tdh="2.1 ��ػ�",
	zc="2.2 ���߹�����",
	wudang="3.1 �䵱",
	hs="3.2 ��ɽ1",
	hs2="3.3 ��ɽ2",
	sx="3.4 ��������",
	xs="4.1 ѩɽ",
	cl="4.2 ���ְ�",
	tx="5.1 Ľ��͵ѧ",
	suoming="5.2 ����������",
	sm="5.3 �һ�����Ĺ",
	ss="5.4 ����������",
	gb="5.5 ؤ��",
	zs="5.6 ץ��",
	jh="5.7 ����",
	tm="5.8 ���ֽ���ɮ",
	ck="5.9 �ɿ�",
	xl="6.0 ����Ѳ������",
	jy="6.1 ���־�Ԯ����",
	xxbug="6.2 ����ץ��",
	qqll="6.3 ��������������"

  }
       local select_job=utils.listbox ("ѡ����Ҫ������", "���þ���", jobs)
	   if select_job then
          world.Execute(select_job)
       else
         return
       end
   end
   end
end

function neili_canwu()
  local w=walk.new()
  w.walkover=function()
     world.Send("jump ţ��ʯ")
     world.Send("canwu 100000 to neili")
  end
  w:go(669)
end

--�Զ����� master�ķ���� ˯�� id
function master_setting(master_name)
    --�䵱  2790 �� 3175 Ů
	--���� 877 878
	--��ü 653
	--��Ĺ  3016 �����
	--��ɽ 1524 ����  3174 Ů��
	--ȫ�� 4166
	--��ң 4242
	--���չ�  2339
	--������ 3110
	--������ 2711 Ů�� 2272 ���� ���ԭ ���������� 2072 2075
	--�һ��� 2785 ���� 3146 Ů�� ����ׯ  2815 �һ���
	--������� 142
	--������  3023
	--���� 2248
	--������ 1800
	--ؤ��
	--Ľ�� 877 Ľ�ݲ�  2003 Ľ�ݸ� 2186 ������
	--���� 484
	--������ 3890 3892
	--��ɽ 308  ���� 3154 Ů��
	--���� 2418 ���� 4989 Ů��
	local party=world.GetVariable("party") or ""
	local gender=world.GetVariable("gender") or ""
	if master_name==nil or master_name=="" then
	   master_name=world.GetVariable("mastername") or ""
	end
	print(master_name," mastername")
	local roomno=WhereIsNpc(master_name)
	 if roomno==nil or table.getn(roomno)==0 then
	   print("û���ҵ�ʦ�����ڵ�!!���ֶ�����!")

	   return
	else
		local r=roomno[1]
	    print(r)
	   world.SetVariable("master_place",r)

	   local ids={}
	   ids=GetNpcID(master_name)
	   local id=ids[1]
	   local len=string.len(id.id1)
	   local short_id=id.id1
	   if len>string.len(id.id2) and string.len(id.id2)>0 then
		   len=string.len(id.id2)
		   short_id=id.id2
	   end
	    if len>string.len(id.id3) and string.len(id.id3)>0 then
		   len=string.len(id.id3)
		   short_id=id.id3
	   end
	   if master_name=="������" then
	    short_id="tianzheng"
	   end
	   print("ʦ��id:",short_id)
	   world.SetVariable("masterid",short_id)
	   local sleeproomno=0
	   if string.find(party,"�䵱") then
	      if gender=="����" then
		    sleeproomno=2790
		  else
		    sleeproomno=3175
		  end
	   elseif string.find(party,"����") then
	      sleeproomno=877
	   elseif string.find(party,"��ɽ") then
		  if gender=="����" then
		    sleeproomno=1524
		  else
		    sleeproomno=3174
		  end
		elseif string.find(party,"����") then
		   sleeproomno=653
		elseif string.find(party,"ȫ��") then
		   sleeproomno=4166
		elseif string.find(party,"��ң") then
		   sleeproomno=4242
		elseif string.find(party,"��Ĺ") then
		   sleeproomno=3016
		elseif string.find(party,"���չ�") then
		   sleeproomno=2339
		elseif string.find(party,"������") then
		   sleeproomno=3110
		 elseif string.find(party,"�������") then
		   sleeproomno=142
		 elseif string.find(party,"������") then
		   sleeproomno=3023
	    elseif string.find(party,"����") then
		   sleeproomno=2248
		 elseif string.find(party,"������") then
		   sleeproomno=1800
		 elseif string.find(party,"����") then
		   sleeproomno=484
		 elseif string.find(party,"������") then
		   local title=world.GetVariable("title") or ""
		   if string.find(title,"��  ɮ") then
		      sleeproomno=3890
		   else
		      sleeproomno=484
		   end
	    elseif string.find(party,"����") then
		  if gender=="����" then
		    sleeproomno=2418
		  else
		    sleeproomno=4989
		  end
		elseif string.find(party,"��ɽ") then
		  if gender=="����" then
		    sleeproomno=308
		  else
		    sleeproomno=3154
		  end
		elseif string.find(party,"Ľ��") then
		  if master_name=="Ľ�ݲ�" then
		    sleeproomno=877
		  elseif master_name=="Ī�ݸ�" then
		   sleeproomno=2003
		  elseif master_name=="������" then
		    sleeproomno=2186
		  end
		elseif string.find(party,"�һ���") then
		  if master_name=="��ҩʦ" then
		    sleeproomno=2815
		  elseif gender=="����" then
		   sleeproomno=2785
		  else
		    sleeproomno=3146
		  end
		elseif string.find(party,"������") then
		  if master_name=="���ַ���" then
		    sleeproomno=2072
		  elseif gender=="����" then
		   sleeproomno=2273
		  else
		    sleeproomno=2712
		  end
		--������ 2711 Ů�� 2272 ���� ���ԭ ���������� 2072 2075
       elseif string.find(party,"ؤ��") then
	      sleeproomno=r
	   end
	   print("sleeproomno:",sleeproomno)
	    world.SetVariable("sleeproomno",sleeproomno)
	end
end

function gongneng()
  return function(flags,hotspot_id)
      if flags==16 then
            local selectItem={
			 master_setting="0 ѧϰ�Զ�����(ʦ��˯��)",
	         fish="1 ����",
		     readbook="2 ���鼮",
		    xiulian1="3 ��������",
		    xiulian2="4 ��������",
			 fullskills="5 full����",
			 quest="6 ����",
			 canwu="7 ţ��ʯ��������(Ҫ��100m)",
			 gumu="8 ��Ĺһ��full",
			  haichao="9 ��Ĺ�ٲ�����������",
			  dzxy="10 ����ת���� 51~201",
			  gancao="11 �Ѹɲ�����������(�Լ�wield ����)",
	      }
	      local _select=utils.listbox ("��������:", "���þ���", selectItem)
		    if _select=="fish" then
			  package.loaded["fish"]=nil
			  require "fish"
			   fish:go()
			elseif _select=="readbook" then
			   	 local cmd=utils.inputbox("����ִ�е���������read medicine book", "���þ���", "read medicine book", "����", 9) or "read medicine book"
	            local f=function(r)
		             local readroomno=r[1]
					 print(readroomno)
					 local sleeproomno=world.GetVariable("sleeproomno") or 126
					 sleeproomno=tonumber(sleeproomno)
					 process.readbook(cmd,nil,readroomno,sleeproomno)
				end
	            WhereAmI(f,10000) --�ų����ڱ仯
			elseif _select=="xiulian1" then
			   world.Send("unset ����")
			   process.neigong3()
			elseif _select=="xiulian2" then
			   process.neigong2()
			elseif _select=="quest" then
			   require "quest"
			   quest:quest_ask()
			elseif _select=="canwu" then
               neili_canwu()
		    elseif _select=="gumu" then
			    package.loaded["gumu"]=nil
			    require "gumu"
			    gumu:lingwu_skills()
		    elseif _select=="haichao" then
			    process.xuantie()
			elseif _select=="master_setting" then
				local master_name=world.GetVariable("mastername") or ""
			    local master_name=utils.inputbox("ʦ������������", "���þ���", master_name, "����", 9) or master_name
			     master_setting(master_name)
			elseif _select=="dzxy" then
			      package.loaded["lingwu"]=nil
			      require "lingwu"
                  local lw=lingwu.new()
				  lw.exps=tonumber(world.GetVariable("exps")) or 0
				  lw.get_skills_end=function()
				    local special=lw:get_skill("douzhuan-xingyi")
				    if special>=171 and special<201 then
				      lw:douzhuan_xingyi2()
				    elseif special>=51 and special<171 then
				      lw:douzhuan_xingyi()
			        end
				  end
                  lw:get_exps()
			elseif _select=="gancao" then
			       package.loaded["duicao"]=nil
                  require "duicao"
			      duicao:start()
			elseif _select=="fullskills" then
			   local select_up={
			     learn="ѧϰʦ��",
				 lingwu="����",
				 literate="����д��",
				 chenggao="�ɸ�",
				 jyzj="����������Ƥ",
			   }

	          local pots=utils.inputbox("��ҪǱ������ȡ����pots", "���þ���", "10000", "����", 9) or "10000"
			  local  _select_up=utils.listbox ("��ʽѡ��:", "���þ���", select_up)
		      if _select_up=="learn" then
		        local f=function()
			 	   world.Send("unset skilllimit")
				   local f=function()
				      world.Send("ѧϰ����")
					   print (utils.msgbox ("ѧϰ����", "Warning!", "ok", "!", 1)) --> ok
				   end
		           Go_learn(f)
				end
				pots_bank(pots,f)
		      elseif _select_up=="lingwu" then
		        local f=function()
				    world.Send("unset skilllimit")
					local f2=function()
					   world.Send("�������")
					   print (utils.msgbox ("�������", "Warning!", "ok", "!", 1)) --> ok
					end
			       process.lingwu(f2,false)
			     end
			     pots_bank(pots,f)
		      elseif _select_up=="literate" then
		         local f=function()
					local f2=function()
				      world.Send("ѧϰ����")
					   print (utils.msgbox ("ѧϰ����", "Warning!", "ok", "!", 1)) --> ok
				    end
			       learn_literate(f2)
			     end
			     pots_bank(pots,f)
		      elseif _select_up=="chenggao" then
		         local f=function()
				    local f2=function()
				      world.Send("ѧϰ����")
					   print (utils.msgbox ("ѧϰ����", "Warning!", "ok", "!", 1)) --> ok
				   end
			       chenggao_learn(f2)
			     end
			     pots_bank(pots,f)
		      elseif _select_up=="jyzj" then
			     local f=function()
				    local f2=function()
				      world.Send("ѧϰ����")
					   print (utils.msgbox ("ѧϰ����", "Warning!", "ok", "!", 1)) --> ok
				   end
			       du_zhenjing(f2)
			     end
			     pots_bank(pots,f)
		      end
	      end
	  end  --end flag
	end
end

function wizard:draw_win()
    WindowCreate (help_win, 0, 0,  help_win_width, help_win_height, miniwin.pos_bottom_left, 0, 0x000010)
	local help_win_info = movewindow.install(help_win, miniwin.pos_bottom_left, miniwin.create_absolute_location, true)
	WindowCreate(help_win, help_win_info.window_left, help_win_info.window_top, help_win_width, help_win_height, help_win_info.window_mode, help_win_info.window_flags, 0x000010)
	movewindow.add_drag_handler (help_win, 0, 0, help_win_width, 30)
	WindowFont (help_win, FONT_NAME, "Arial", FONT_SIZE)
	WindowResize (help_win, help_win_width, help_win_height, 0x000010)
    WindowCircleOp (help_win, miniwin.circle_round_rectangle, 0, 2, 38, help_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	WindowCircleOp (help_win, miniwin.circle_round_rectangle, 40, 2, 78, help_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	WindowCircleOp (help_win, miniwin.circle_round_rectangle, 80, 2, 118, help_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	WindowCircleOp (help_win, miniwin.circle_round_rectangle, 120, 2, 158, help_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	WindowCircleOp (help_win, miniwin.circle_round_rectangle, 160, 2, 198, help_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	WindowCircleOp (help_win, miniwin.circle_round_rectangle, 200, 2, help_win_width, help_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	--help_win_width
	left = 5
	top = 5

	WindowText (help_win, FONT_NAME, "����",
					7, top, 0, 0,
					ColourNameToRGB ("yellow"), false)

	WindowText (help_win, FONT_NAME, "ֹͣ",
					47, top, 0, 0,
					ColourNameToRGB ("yellow"), false)
	WindowText (help_win, FONT_NAME, "��λ",
				    87, top, 0, 0,
					ColourNameToRGB ("yellow"), false)
	WindowText (help_win, FONT_NAME, "ģʽ",
				    127, top, 0, 0,
					ColourNameToRGB ("yellow"), false)

    WindowText (help_win, FONT_NAME, "����",
				    167, top, 0, 0,
					ColourNameToRGB ("yellow"), false)

	WindowText (help_win, FONT_NAME, "����",
				    207, top, 0, 0,
					ColourNameToRGB ("yellow"), false)

	top = top + 15
	WindowShow (help_win, true)
	movewindow.save_state(help_win)
   local _mousedown=mousedown()
   _G["at_mousedown"]=_mousedown
   local _stopRobot=stopRobot()
   _G["at_mousedown1"]=_stopRobot
   local _mapHere=mapHere()
   _G["at_mousedown2"]=_mapHere
   local _switchmode=switchmode()
      _G["at_mousedown3"]=_switchmode
   local _startjob=startjob()
	_G["at_mousedown4"]=_startjob
	  local _gongneng=gongneng()
	_G["at_mousedown5"]=_gongneng

   WindowAddHotspot(help_win, "setting_hotspot",
                    10,  0, 35, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "����",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags

   WindowAddHotspot(help_win, "stop_hotspot",
                    50,  0, 75, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown1",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "ֹͣ������",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags
    WindowAddHotspot(help_win, "mapHere_hotspot",
                    90,  0, 115, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown2",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "��ǰ�����",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags
	 WindowAddHotspot(help_win, "hand_hotspot",
                    130,  0, 155, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown3",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "ģʽ�л�",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags
	WindowAddHotspot(help_win, "startjob_hotspot",
                    170,  0, 195, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown4",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "����JOB",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags
	WindowAddHotspot(help_win, "gongneng_hotspot",
                    210,  0, 235, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown5",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "��������",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags

--[[
    WindowCreate (stop_win, 0, 0,  stop_win_width, stop_win_height, miniwin.pos_top_center, 0, 0x000010)
	local stop_win_info = movewindow.install(stop_win, miniwin.pos_top_center, miniwin.create_absolute_location, true)
	--WindowCreate(stop_win, stop_win_info.window_left, stop_win_info.window_top, stop_win_width, stop_win_height, stop_win_info.window_mode, stop_win_info.window_flags, 0x000010)
	movewindow.add_drag_handler (stop_win, 0, 0, stop_win_width, 30)
	WindowFont (stop_win, FONT_NAME, "Arial", FONT_SIZE)
	WindowResize (stop_win, stop_win_width, stop_win_height, 0x000010)
    WindowCircleOp (stop_win, miniwin.circle_round_rectangle, 0, 2, stop_win_width - 2, stop_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	left = 5
	top = 5

	WindowText (stop_win, FONT_NAME, "ֹͣ",
					left+2, top, 0, 0,
					ColourNameToRGB ("yellow"), false)

	top = top + 15
	WindowShow (stop_win, true)
	movewindow.save_state(stop_win)
   local _stopRobot=stopRobot()
   _G["at_mousedown1"]=_stopRobot
   WindowAddHotspot(stop_win, "stop_hotspot",
                    10,  0, 25, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown1",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "ֹͣ������",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags]]
end

--require('LuaXml')
function wizard:test()
local xml = require("xmlSimple").newParser()

--[[

local testXml = '<testOne param="param1value">'
testXml = testXml .. '<testTwo paramTwo="param2value">'
testXml = testXml .. '<testThree>'
testXml = testXml .. 'testThreeValue'
testXml = testXml .. '</testThree>'
testXml = testXml .. '<testThree duplicate="one" duplicate="two">'
testXml = testXml .. 'testThreeValueTwo'
testXml = testXml .. '</testThree>'
testXml = testXml .. '<test_Four something="else">'
testXml = testXml .. 'testFourValue'
testXml = testXml .. '</test_Four>'
testXml = testXml .. '<testFive>'
testXml = testXml .. '<testFiveDeep>'
testXml = testXml .. '<testFiveEvenDeeper>'
testXml = testXml .. '<testSix someParam="someValue"/>'
testXml = testXml .. '</testFiveEvenDeeper>'
testXml = testXml .. '</testFiveDeep>'
testXml = testXml .. '</testFive>'
testXml = testXml .. 'testTwoValue'
testXml = testXml .. '</testTwo>'
testXml = testXml .. '</testOne>'


local parsedXml = xml:ParseXmlText(testXml)


if parsedXml.testOne == nil then error("Node not created") end
if parsedXml.testOne:name() ~= "testOne" then error("Node name not set") end
if parsedXml.testOne.testTwo == nil then error("Child node not created") end
if parsedXml.testOne.testTwo:name() ~= "testTwo" then error("Child node name not set") end
if parsedXml.testOne.testTwo:value() ~= "testTwoValue" then error("Node value not set") end
if parsedXml.testOne.testTwo.test_Four:value() ~= "testFourValue" then error("Second child node value not set") end
if parsedXml.testOne["@param"] ~= "param1value" then error("Parameter not set") end
if parsedXml.testOne.testTwo["@paramTwo"] ~= "param2value" then error("Second child node parameter not set") end
if parsedXml.testOne.testTwo.test_Four["@something"] ~= "else" then error("Deepest node parameter not set") end

-- duplicate names tests
if parsedXml.testOne.testTwo.testThree[1]:value() ~= "testThreeValue" then error("First of duplicate nodes value not set") end
if parsedXml.testOne.testTwo.testThree[2]:value() ~= "testThreeValueTwo" then error("Second of duplicate nodes value not set") end
if parsedXml.testOne.testTwo.testThree[2]["@duplicate"][1] ~= "one" then error("First of duplicate parameters not set") end
if parsedXml.testOne.testTwo.testThree[2]["@duplicate"][2] ~= "two" then error("Second of duplicate parameters not set") end

-- deep element test

if parsedXml.testOne.testTwo.testFive.testFiveDeep.testFiveEvenDeeper.testSix['@someParam'] ~= "someValue" then error("Deep test error") end

-- node functions test
local node = require("xmlSimple").newNode("testName")

if node:name() ~= "testName" then error("Node creation failed") end

node:setName("nameTest")
if node:name() ~= "nameTest" then error("Name function test failed") end

node:setValue("valueTest")
if node:value() ~= "valueTest" then error("Value function test failed") end

local childNode = require("xmlSimple").newNode("parent")

node:addChild(childNode)

if type(node:children()) ~= "table" then error("children function test failed") end
if #node:children() ~= 1 then error("AddChild function test failed") end
if node:numChildren() ~= 1 then error("numChildren function test failed") end


node:addProperty("name", "value")

if type(node:properties()) ~= "table" then error("properties function test failed") end
if #node:properties() ~= 1 then error("Add property function test failed") end
if node:numProperties() ~= 1 then error("Num properties function test failed") end

print("Tests passed")
]]



end

function wizard:start()
  --��һ�� jobs
  --ѧϰ ���� �� �����б� ʦ�� ��Ϣ����
  --ս�� pfm unarmed_pfm
  --װ�� i_equip ����
  --self:support_job()
  --print("��������������������������������������������������������������������������������������������������������")

   wizard_end=function()

	teach_skill={}
    local teach_skills=world.GetVariable("teach_skills")
    if teach_skills==nil or teach_skills=="" then
      print("teach_skills����û������!!")
    else
     local _skills=Split(teach_skills,"|")
     for _,ts in ipairs(_skills) do
       table.insert(teach_skill,ts)
     end
    end
    run_vip=world.GetVariable("VIP")
    if run_vip=="������" then
     run_vip=true
    else
     run_vip=false
    end
	 --
	 --print("�������ݼ��")

	 --jobslist ��ʽ����
	 --get_jobslist
	 --sp_exert ��ʽ����

	 --i_equip
	 --filename = utils.filepicker (title, name, extension, filter, save)
	 --�༭Ĭ��ģ��
	 --ѡ���������ݣ�
     --self:select_settings()
   end
   auto_variable()
end

----2016-11-23���� ���� xml�����ļ����뵼������
-- show all variables and their values
function wizard:import_xml()
for k, v in pairs (GetVariableList()) do
  Note (k, " = ", v)
end
Note (ExportXML (4, "gb_pfm"))
end
