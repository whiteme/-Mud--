
function wizard_end()
end

local function wizard_start()
  local _exps=world.GetVariable("exps")
  _exps=tonumber(_exps)

----------------Õ½¶·-------------------

  local pfm
  pfm=world.GetVariable("pfm")
  if pfm==nil then
     print("ĞèÒªÉèÖÃpfm±äÁ¿:Õ½¶·Ê±×Ô¶¯Ê©·Å Àı wield jian;jiali max;perform sword.haichao;jiali 1;yun xinjing")
     world.SetVariable("pfm","")
  end
  local cmd --block npc perform
  cmd=world.GetVariable("cmd")
  if cmd==nil then
    print("ĞèÒªÉèÖÃcmd±äÁ¿: kill µ²Â·npc Ê±ºòÊ¹ÓÃ Àı perform xxxx")
    world.SetVariable("cmd","")
  end
  local unarmed_pfm
  unarmed_pfm=world.GetVariable("unarmed_pfm")
  if unarmed_pfm==nil then
    print("ĞèÒªÉèÖÃunarmed_pfm±äÁ¿: ÎäÆ÷¶ªÊ§±»¶áÊ±ºòµÄ¼¼ÄÜ Àı get jian;wield jian;perform haichao »ò ÇĞ»»¿ÕÊÖ¼¼ÄÜ Ààpfm±äÁ¿ÉèÖÃ")
	world.SetVariable("unarmed_pfm","")
  end
-----------------¼¼ÄÜ--------------------

  local wuxing
  wuxing=world.GetVariable("wuxing")
  if wuxing==nil then
     print("ĞèÒªÉèÖÃwuxing ±äÁ¿£ºÈç¹ûÑ§Ï°ÁìÎòĞèÒª ÌáÇ°yun ÄÚ¹¦  ¿ÉÒÔĞ´Èë£¬Àı yun qimen »ò yun xinjing  ")
     world.SetVariable("wuxing","")
  end
  local shield
  shield=world.GetVariable("shield")
  if shield==nil then
    print("ĞèÒªÉèÖÃshield ±äÁ¿£ºÈç¹ûÕ½¶·Ç°ĞèÒª yun ÄÚ¹¦ »ò×°±¸ÎäÆ÷  ¿ÉÒÔĞ´Èë£¬Àı wield sword;yun longxiang »ò yun shield  ")
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
    print("ĞèÒªÉèÖÃsp_exert ±äÁ¿£ºÈç¹ûÕ½¶·Ç°ĞèÒª yun ÄÚ¹¦ »ò×°±¸ÎäÆ÷  ¿ÉÒÔĞ´Èë£¬Àı 'È«²¿':'wield sword;yun longxiang'  ")
    world.SetVariable("sp_exert","")
  end
  local liao_percent
  liao_percent=world.GetVariable("liao_percent")
  if liao_percent==nil then
    print("ĞèÒªÉèÖÃliao_percent ±äÁ¿£ºÕÒÑ¦ÁÆÉËÆøÑª±ÈÀı")
    world.SetVariable("liao_percent","80")
  end
  local pot
  pot=world.GetVariable("pot")
  if pot==nil then
    print("ĞèÒªÉèÖÃpot ±äÁ¿£º Ã¿´ÎÑ§Ï°µÄpot ÉèÖÃÖµ 1~50 ")
    world.SetVariable("pot","1")
  end
  local pot_overflow
  pot_overflow=world.GetVariable("pot_overflow")
  if pot_overflow==nil then
     print("ĞèÒªÉèÖÃpot_overflow ±äÁ¿£º pot=maxpot-pot_overflow Ê±¾ÍÈ¥Ñ§Ï°ÁìÎò,¸ºÖµ¾Í»áÒ»Ö±job  ")
     world.SetVariable("pot_overflow",20)
  end
  local up
  up=world.GetVariable("up")
  if up==nil then
     print("ĞèÒªÉèÖÃup ±äÁ¿: ÏûºÄpot ·½Ê½ up Öµ=learn,lingwu,duanzao,zhizhao,chenggao,literate »á×Ô¶¯ÏûºÄÒøĞĞ´æ¿îÑ§Ï°,cun ´æÇ±ÄÜÒøĞĞ")

	 if _exps>1000000 then
	    world.SetVariable("up","lingwu")
	 else
	    world.SetVariable("up","learn")
	 end
  end
  local bei_up
  bei_up=world.GetVariable("bei_up")
  if bei_up==nil then
     print("ĞèÒªÉèÖÃbei_up ±äÁ¿: ÏûºÄpot ·½Ê½ bei_up Öµ=learn,lingwu ÒøĞĞgold ²»¹»Ê±×Ô¶¯ÇĞ»»")
	  if _exps>1000000 then
	    world.SetVariable("bei_up","lingwu")
	 else
	    world.SetVariable("bei_up","learn")
	 end
  end
  local skills
  skills=world.GetVariable("skills")
  if skills==nil then
     print("ĞèÒªÉèÖÃskills ±äÁ¿: Ñ§Ï°skills »ò ÁìÎòµÄ skills  Àı longxiang-boruo|dashou-yin|hand|dodge|yuxue-dunxing|parry|poison|huanxi-chan|force")
     world.SetVariable("skills","")
  end
  local lian_skills
  lian_skills=world.GetVariable("lian_skills")
  if lian_skills==nil then
	 print("ĞèÒªÉèÖÃlian_skills ±äÁ¿: Á·Ï°skills  Àı ÁúÏó°ãÈô¹¦&force|´óÊÖÓ¡&hand|ÕªĞÇ¹¦&dodge")
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
     print("ĞèÒªÉèÖÃsleeproomno ±äÁ¿: Ñ§Ï°Ê±ºòµ½Ö¸¶¨·¿¼äĞİÏ¢»Ö¸´¡£Ö»ÔÚup=learn ÓĞĞ§¡£szÇøÓò·¿¼äÃû³Æ ²éÕÒ¶ÔÓ¦·¿¼äºÅ Àı szÉÙÁÖË¯·¿")
     world.SetVariable("sleeproomno","")
  end
  local master_place
  master_place=world.GetVariable("master_place")
  if master_place==nil then
	print("ĞèÒªÉèÖÃmaster_place ±äÁ¿: Ñ§Ï°Ê±ºòµ½Ö¸¶¨·¿¼äÑ§Ï°Ê¦¸µ¡£Ö»ÔÚup=learn ÓĞĞ§¡£szÇøÓò·¿¼äÃû³Æ ²éÕÒ¶ÔÓ¦·¿¼äºÅ Àı szÉÙÁÖË¯·¿")
	world.SetVariable("master_place","")
  end
  local masterid
  masterid=world.GetVariable("masterid")
  if masterid==nil then
     print("ĞèÒªÉèÖÃmasterid ±äÁ¿: Ê¦¸µµÄid¡£Ö»ÔÚup=learn ÓĞĞ§¡£Àı huang")
	world.SetVariable("masterid","")
  end


  local neili_upper
  neili_upper=world.GetVariable("neili_upper")
  if neili_upper==nil then
    print("ĞèÒªÉèÖÃneili_upper ±äÁ¿: ¿ªÊ¼job Ç°´ò×øµÄ±¶Êı1-1.99 Ö®¼äÖµ")
	world.SetVariable("neili_upper","1.9")
  end
  local i_equip
  i_equip=world.GetVariable("i_equip")
  if i_equip==nil then
     print("ĞèÒªÉèÖÃi_equip ±äÁ¿:×Ô¶¯¼ì²é»ñÈ¡×°±¸")
     world.SetVariable("i_equip","<±£´æ>»Æ½ğ&5|<±£´æ>°×Òø&200|<±£´æ>Í­Ç®&200|<±£´æ>ÒøÆ±&10")
  end
  local xiulian
  xiulian=world.GetVariable("xiulian")
  if xiulian==nil then
     print("ĞèÒªÉèÖÃxiulian ±äÁ¿:job busy ĞŞÁ¶ÄÚÁ¦»ò¾«Á¦ ÌîĞ´ xiulian_jingli »ò xiulian_neili")
	 world.SetVariable("xiulian","xiulian_neili")
  end
------------------hb job ĞèÒªÊ¹ÓÃ
  local hb_auto=world.GetVariable("hb_auto")
  if hb_auto==nil then
      print("»¤ïÚ×Ô¶¯ÇĞ»»jobslist")
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

      print("»¤ïÚÖ÷id ÃüÁî×Óid Ö´ĞĞÖ¸Áî,ÓÃÓÚ×Óid ÇĞ»»jobslist")
     world.SetVariable("hb_cmd","")
  end

------------------xs job ĞèÒªÊ¹ÓÃ
  local xs_blacklist
  xs_blacklist=world.GetVariable("xs_blacklist")
  if xs_blacklist==nil then
     print("ĞèÒªÉèÖÃxs_blacklist ±äÁ¿: Ñ©É½job ĞèÒª·ÅÆúµÄ guard  ¿ÉÒÔÉèÖÃÃÅÅÉºÍÎäÆ÷µÄ×éºÏ Àı ÌÒ»¨µº|²³Äàµº&³¤½£|ÉÙÁÖ&²¼ÒÂ")
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
------------------sx job ĞèÒªÊ¹ÓÃ
  local sx_blacklist
  sx_blacklist=world.GetVariable("sx_blacklist")
  if sx_blacklist==nil then
     print("ĞèÒªÉèÖÃsx_blacklist ±äÁ¿: ËÍĞÅjob ĞèÒª·ÅÆúµÄ sx2 npc ÎäÆ÷¼¼ÄÜÁĞ±í ¿ÉÒÔÉèÖÃÃÅÅÉºÍÎäÆ÷µÄ×éºÏ Àı ÉÙÁÖÅÉ&Î¤ÍÓèÆ|ĞÇËŞÅÉ&ÌìÉ½ÕÈ·¨|»ªÉ½ÅÉ&¶À¹Â¾Å½£")
     world.SetVariable("sx_blacklist","")
  end
  local cl_blacklist
  cl_blacklist=world.GetVariable("cl_blacklist")
  if cl_blacklist==nil then
	 print("ĞèÒªÉèÖÃcl_blacklist ±äÁ¿: ³¤ÀÖ°ïjob ·ÅÆúµÄÃÅÅÉ Àı ĞÇËŞ|ÌÒ»¨")
     world.SetVariable("cl_blacklist","")
  end
  local wd_blacklist
  wd_blacklist=world.GetVariable("wd_blacklist")
  if cl_blacklist==nil then
	 print("ĞèÒªÉèÖÃwd_blacklist ±äÁ¿: Îäµ±job ·ÅÆúµÄÃÅÅÉ»ò¼¼ÄÜ Àı ĞÇËŞÅÉ|¶À¹Â¾Å½£|ÌÚÁúØ°Ê×")
     world.SetVariable("wd_blacklist","")
  end
  local difficulty
  difficulty=world.GetVariable("difficulty")
  if difficulty==nil then
     print("ĞèÒªÉèÖÃdifficulty ±äÁ¿: Îäµ±job ÄÑ¶ÈµÈ¼¶1~4 ¼¶ 1 ²»×ãÎªÂÇ 2 ÆÄÎªÁËµÃ 3 ¼«ÆäÀ÷º¦ 4 ÒÑÈç»¯¾³")
     world.SetVariable("difficulty","1")
  end
  local immediate_sx1
  immediate_sx1=world.GetVariable("immediate_sx1")
  if immediate_sx1==nil then
     print("ĞèÒªÉèÖÃimmediate_sx1 ±äÁ¿:sx1 Á¢¼´ËÍĞÅ²»µÈ´ıÉ±ÊÖ")
     world.SetVariable("immediate_sx1","")
  end
  local blockNPC
  blockNPC=world.GetVariable("blockNPC")
  if blockNPC==nil then
     print("ĞèÒªÉèÖÃblockNPC:µ²Â·NPC pfmÊ¹ÓÃÉèÖÃ")
	 world.SetVariable("blockNPC","")
  end
  local sx_giveup_pos
   sx_giveup_pos=world.GetVariable("sx_giveup_pos")
  if sx_giveup_pos==nil then
     print("ĞèÒªÉèÖÃsx_giveup_pos:ËÍĞÅ·ÅÆúµØµã")
	 world.SetVariable("sx_giveup_pos","¾øÇé¹È|ÉñÁúµº|¹ÃËÕÄ½Èİ|Ñà×ÓÎë|ÂüÙ¢ÂŞÉ½×¯|ÌìÉ½|Îäµ±É½ÔºÃÅ|Îäµ±É½ºóÉ½Ğ¡Ôº|É³Ì²|Ğ¡µº")
  end

    local ss_blacklist
  ss_blacklist=world.GetVariable("ss_blacklist")
  if ss_blacklist==nil then
	 print("ĞèÒªÉèÖÃss_blacklist ±äÁ¿: áÔÉ½job ·ÅÆúµÄÃÅÅÉ»ò¼¼ÄÜ Àı ĞÇËŞÅÉ|¶À¹Â¾Å½£|ÌÚÁúØ°Ê×")
     world.SetVariable("ss_blacklist","")
  end
------------------wd job ĞèÒªÊ¹ÓÃ


------------------Ä£¿éÇĞ»»---------------
  local jobslist
  jobslist=world.GetVariable("jobslist")
  if jobslist==nil then
     print("ĞèÒªÉèÖÃwithout_fight ±äÁ¿: Ñ©É½job ĞèÒª·ÅÆúµÄ guard  ¿ÉÒÔÉèÖÃÃÅÅÉºÍÎäÆ÷µÄ×éºÏ Àı ÌÒ»¨µº|²³Äàµº&³¤½£|ÉÙÁÖ&²¼ÒÂ")
     world.SetVariable("jobslist","")
  end
  local shashou_level
  shashou_level=world.GetVariable("shashou_level")
  if shashou_level==nil then
     print("ĞèÒªÉèÖÃshashou_level ±äÁ¿: ËÍĞÅjob É±ÊÖÄÑ¶ÈµÈ¼¶ -1 ·ÅÆú sx2 job 0 Î¢²»×ãµÀ 1 ÂíÂí»¢»¢ 2 Ğ¡ÓĞËù³É 3 ÈÚ»á¹áÍ¨ 5 ÆÄÎªÁËµÃ 9 ¼«ÆäÀ÷º¦ 10 ÒÑÈë»¯¾³")
     world.SetVariable("shashou_level","-1")
  end
------------------ÇøÓò½ø³ö¿ª¹Ø
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
	--ÌØÊâheal ±äÁ¿
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
	  local l,w=wait.regexp("^.*\\((.*)\\).*$|^(> |)Éè¶¨»·¾³±äÁ¿£ºlook \\= \"YES\"$",5)
	  if l==nil then
	     get_all_skills_id()
	     return
	  end
	  if string.find(l,")") then
	     _skills_id=_skills_id..w[1].."|"
	     get_all_skills_id()
	     return
	  end
	  if string.find(l,"Éè¶¨»·¾³±äÁ¿£ºlook") then
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
    --print("ĞèÒªÉèÖÃteach_skills±äÁ¿: ½ÌÑ¦Ä½»ªµÄskillÃû³Æ Àı dashou-yin|yuxue-dunxing|longxiang-boruo|huanxi-chan")
	world.Send("cha")
	world.Send("set look")
	--world.SetVariable("teach_skills","")
	_skills_id=""
	get_all_skills_id()
 --end
end

function ch_over()
   print("¼ì²é½áÊø")
end
--©§¾­Ñé¶îÍâ»ñÈ¡£º¡¼°Ù·ÖÖ®¶şÊ®¡½    ²ÎÎòÌì¸³£ºÎŞ          Î´·ÖÅäÌì¸³£ºÎŞ      ©§
function get_score()
	  wait.make(function()
	    local l,w=wait.regexp("^©§ĞÕ    Ãû£º(.*)\\((.*)\\).*©§$|^©§ĞÔ    ±ğ£º(.*)©§$|^©§.*Ê¦    ³Ğ£º¡¾(.*)¡¿¡¾(.*)¡¿.*|^©§×¢²á£º(.*)©§$|^©§³Æ    Î½£º¡¾(.*)¡¿.*|^©§¾­Ñé¶îÍâ»ñÈ¡£º(.*)²ÎÎòÌì¸³£º(.*)Î´·ÖÅäÌì¸³£º(.*)©§|^©§.*Ê¦    ³Ğ£º¡¾ÆÕÍ¨°ÙĞÕ¡¿.*|.*Ê¦    ³Ğ£º¡¾¹ÅÄ¹ÅÉ¡¿.*",5)
		if l==nil then
		   auto_variable()
		   return
		end
		if string.find(l,"ĞÕ    Ãû") then
		   world.SetVariable("player_name",Trim(w[1]))
		   world.SetVariable("player_id",w[2])
		   get_score()
		   return
		end
		if string.find(l,"ĞÔ    ±ğ") then
		  if string.find(w[3],"ÄĞĞÔ") then
		     world.SetVariable("gender","ÄĞĞÔ")
		  elseif string.find(w[3],"Å®ĞÔ") then
             world.SetVariable("gender","Å®ĞÔ")
          else
		      world.SetVariable("gender","¶«·½²»°Ü")
          end
		   get_score()
		   return
		end
		if string.find(l,"ÆÕÍ¨°ÙĞÕ") then
		   world.SetVariable("party","ÎŞ")
		   world.SetVariable("mastername","ÎŞ")
		   get_score()
		   return
		end
		if string.find(l,"¹ÅÄ¹ÅÉ") and Trim(w[5])=="" then
		   --print(w[5],"  w5")
		    world.SetVariable("party","¹ÅÄ¹ÅÉ")
		   world.SetVariable("mastername","ÎŞ")
		   get_score()
           return
		end
		if string.find(l,"Ê¦    ³Ğ") then
		   world.SetVariable("party",w[4])
		   world.SetVariable("mastername",w[5])
		   get_score()
		   return
		end
		if string.find(l,"×¢²á") then
		   if string.find( w[6],"ÆÕÍ¨Íæ¼Ò") then
		      world.SetVariable("vip","ÆÕÍ¨Íæ¼Ò")
		   elseif string.find(w[6],"ÈÙÓşÖÕÉí¹ó±ö") then
		      world.SetVariable("vip","ÈÙÓşÖÕÉí¹ó±ö")
		   else
		      world.SetVariable("vip","¹ó±öÍæ¼Ò")
		   end
		   wizard_start()
		   ch_over()
		   return
		end
		if string.find(l,"³Æ    Î½") then
			world.SetVariable("title",w[7])
		    get_score()
		   return
		end
		if string.find(l,"²ÎÎòÌì¸³") then
		   local exert_reward=Trim(w[8])
		   exert_reward=string.gsub(exert_reward,"¡½","")
		   exert_reward=string.gsub(exert_reward,"¡¼","")
		   if exert_reward=="ÎŞ" then
		      world.SetVariable("exert_reward","0")
		   else
		      exert_reward=string.gsub(exert_reward,"°Ù·ÖÖ®","")
			  exert_reward=ChineseNum(exert_reward)
			  world.SetVariable("exert_reward",exert_reward)
		   end

		   local exert_gift=Trim(w[9])
		   if exert_gift=="ÎŞ" then
		      world.SetVariable("exert_gift","0")
		   else
		      exert_gift=ChineseNum(exert_gift)
			  world.SetVariable("exert_gift",exert_gift)
		   end
		   local exert_unset_gift=Trim(w[10])
		   if exert_unset_gift=="ÎŞ" then
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
  --player_id ÃÅÅÉ exps vip ½ø³ö¿ª¹Ø ±äÁ¿´æÔÚ¼ì²é
---------------×Ô¶¯»ñµÃ---------------
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
    local yesno=utils.msgbox ("ÊÇ·ñÊ¹ÓÃ³£ÓÃÈÎÎñ×éºÏ£¿", "ÈÎÎñÑ¡Ôñ", "yesno", "?")
	if yesno=="yes" then
	   local jobslist={
	     combo1="»ªÉ½1+Ø¤°ï",
	     combo2="»ªÉ½2+ËÍĞÅ",
		 combo3="³¤ÀÖ°ï+áÔÉ½",
		 combo4="Îäµ±+»ªÉ½1+ËÍĞÅ",
		 combo5="Ñ©É½+áÔÉ½+³¤ÀÖ°ï",
		 combo6="»ªÉ½1+ËÍĞÅ",
		 combo7="ËÍĞÅ+³¤ÀÖ°ï",
		 combo8="Ø¤°ï+³¤ÀÖ°ï",
	   }

	     local select_job=utils.listbox ("Ñ¡ÔñÄãÒª×öÈÎÎñ", "ÈÎÎñÑ¡Ôñ", jobslist)
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
    xc="1.1 ´óÀíÑ²³Ç",
	tdh="2.1 ÌìµØ»á",
	zc="2.2 ºéÆß¹«×ö²Ë",
	wd="3.1 Îäµ±",
	hs="3.2 »ªÉ½1",
	hs2="3.3 »ªÉ½2",
	sx="3.4 ´óÀíËÍĞÅ",
	xs="4.1 Ñ©É½",
	cl="4.2 ³¤ÀÖ°ï",
	tx="5.1 Ä½ÈİÍµÑ§",
	suoming="5.2 ÉñÁúµºË÷Ãü",
	sm="5.3 ÌÒ»¨µºÊØÄ¹",
	ss="5.4 ×óÀäìøÈÎÎñ",
	gb="5.5 Ø¤°ï",
	zs="5.6 ×¥Éß",
	jh="5.7 ½½»¨",
	tm="5.8 ÉÙÁÖ½ÌÎäÉ®",
	ck="5.9 ²É¿ó",
	xl="6.0 Ã÷½ÌÑ²ÂßÈÎÎñ",
	jy="6.1 ÉÙÁÖ¾ÈÔ®ÈÎÎñ",
	xxbug="6.2 ĞÇËŞ×¥³æ",
	qqll="6.3 ÆßÇÏÁáççÓñÈÎÎñ"

  }
  local select_job=utils.multilistbox ("Ñ¡ÔñÄãÒª×öÈÎÎñ", "ÈÎÎñÑ¡Ôñ", jobs)
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
   local _jobs=utils.inputbox ("ÉèÖÃÈÎÎñ±äÁ¿", "ÈÎÎñÑ¡Ôñ", str_jobs, "ËÎÌå", 9)
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

	   local _jb1=utils.listbox ("ÉèÖÃÍµÑ§ÈÎÎñºóĞøµÄjob1:", "ÍµÑ§ÈÎÎñ", jb1)
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
     neixiwan="1 ÄÚÏ¢Íè",
	 xujingdan="2 Ğø¾«µ¤",
   }
   local _drug=utils.listbox ("ÉèÖÃÑ²³ÇÈÎÎñ³ÔÒ©:", "Ñ²³ÇÈÎÎñ", drug)
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
       local _jb1=utils.listbox ("ÉèÖÃ²É¿óÈÎÎñºóĞøµÄjob:", "²É¿óÈÎÎñ", jb1)
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
	   local _jb2=utils.listbox ("ÉèÖÃ²É¿óÈÎÎñºóĞøµÄjob2:", "²É¿óÈÎÎñ", jb2)
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
	local ck_playId=utils.inputbox ("¿óÊ¯ĞèÒªËÍ¸øµÄÍæ¼ÒµÄID²»ÌîĞ´±íÊ¾×Ô¼º½»¸øÌú½³", "²É¿óÈÎÎñ", "", "ËÎÌå", 9)
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
	   local _pfm=utils.listbox ("ÉèÖÃÌìµØ»áÈÎÎñÊ¹ÓÃµÄpfm:", "ÌìµØ»áÈÎÎñ", pfm)
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
	   local _jb1=utils.listbox ("ÉèÖÃÌìµØ»áÈÎÎñºóĞøµÄjob1:", "ÌìµØ»áÈÎÎñ", jb1)
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

     local t={"1.²»×ãÎªÂÇ","2.ÆÄÎªÁËµÃ","3.¼«ÆäÀ÷º¦","4.ÒÑÈë»¯¾³",}
	 local diff=utils.listbox ("ÉèÖÃÎäµ±ÈÎÎñÄÑ¶ÈµÈ¼¶:", "Îäµ±ÈÎÎñ", t)
	 if diff~=nil then
	   world.SetVariable("difficulty",diff)
	 else
	   return
	 end

   local blacklist={}

    blacklist={
	    ["Îäµ±ÅÉ"]="1.1 Îäµ±ÅÉ",
		["ÉÙÁÖÅÉ"]="1.2 ÉÙÁÖÅÉ",
		["ĞÇËŞÅÉ"]="1.3 ĞÇËŞÅÉ",
		["»ªÉ½ÅÉ"]="1.4 »ªÉ½ÅÉ",
		["¶ëáÒÅÉ"]="1.5 ¶ëáÒÅÉ",
		["Ñ©É½ÅÉ"]="1.6 Ñ©É½ÅÉ",
		["¹ÃËÕÄ½Èİ"]="1.7 ¹ÃËÕÄ½Èİ",
		["¹ÅÄ¹ÅÉ"]="1.8 ¹ÅÄ¹ÅÉ",
		["áÔÉ½ÅÉ"]="1.9 áÔÉ½ÅÉ",
		["À¥ÂØÅÉ"]="2.0 À¥ÂØÅÉ",
		["ÉñÁúµº"]="2.1 ÉñÁúµº",
		["ÌúÕÆ°ï"]="2.2 ÌúÕÆ°ï",
		["Ø¤°ï"]="2.3 Ø¤°ï",
		["ÌÒ»¨µº"]="2.4 ÌÒ»¨µº",
		["ÌìÁúËÂ"]="2.5 ÌìÁúËÂ",
		["´óÀí"]="2.6 ´óÀí",
		["Î¤ÍÓèÆ"]="3.1 Î¤ÍÓèÆ",
		["¶À¹Â¾Å½£"]="3.2 ¶À¹Â¾Å½£",
		["ĞşÒõ½£·¨"]="3.3 ĞşÒõ½£·¨",
		["´ò¹·°ô·¨"]="3.4 ´ò¹·°ô·¨",
		["ÌÚÁúØ°·¨"]="3.5 ÌÚÁúØ°·¨",
		["±ÙĞ°½£·¨"]="3.6 ±ÙĞ°½£·¨",
		["½µÁúÊ®°ËÕÆ"]="3.7 ½µÁúÊ®°ËÕÆ",
		["µ¯Ö¸ÉñÍ¨"]="3.8 µ¯Ö¸ÉñÍ¨",
		["ÌìÉ½ÕÈ·¨"]="3.9 ÌìÉ½ÕÈ·¨",
	  }

  local _blacklist=utils.multilistbox ("ÉèÖÃÎäµ±ÈÎÎñºÚÃûµ¥", "Îäµ±ÈÎÎñ", blacklist)
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
	   local _pfm=utils.listbox ("ÉèÖÃÎäµ±ÈÎÎñÊ¹ÓÃµÄpfm:", "Îäµ±ÈÎÎñ", pfm)
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
--^.*Ö»¾õµÃ.*ÒÑ±»ÄãµÄÖ¸·çµãÖĞ£¬ÉíĞÎ²»ÓÉµÄ»ºÂıÏÂÀ´£¡$#ÉíĞÎ²»ÓÉµÄ»ºÂıÏÂÀ´#wield xiao;jifa parry yuxiao-jian;jiali max;perform sword.feiying;yun qi;yun jingli&^.*Äã·ÉÓ°Ê¹Íê£¬ÊÖÒ»»Î½«.*ÄÃ»ØÊÖÖĞ¡£$#Äã·ÉÓ°Ê¹Íê#unwield xiao;jiali 1;jifa parry tanzhi-shentong;perform finger.tan
	   local _pfm_list=utils.listbox("ÉèÖÃÎäµ±ÈÎÎñÊ¹ÓÃµÄpfm_list ÉèÖÃ»ù±¾¸ñÊ½´¥·¢Æ÷µÄÍ¨Åä·û1#Æ¥ÅäÓï¾ä1#Ö´ĞĞµÄÃüÁî1&´¥·¢Æ÷µÄÍ¨Åä·û2#Æ¥ÅäÓï¾ä2#Ö´ĞĞµÄÃüÁî2\nÀı: ^.*Ö»¾õµÃ.*ÒÑ±»ÄãµÄÖ¸·çµãÖĞ£¬ÉíĞÎ²»ÓÉµÄ»ºÂıÏÂÀ´£¡$#ÉíĞÎ²»ÓÉµÄ»ºÂıÏÂÀ´#wield xiao;jifa parry yuxiao-jian;jiali max;perform sword.feiying&^.*Äã·ÉÓ°Ê¹Íê£¬ÊÖÒ»»Î½«.*ÄÃ»ØÊÖÖĞ¡£$#Äã·ÉÓ°Ê¹Íê#unwield xiao;jifa parry tanzhi-shentong;perform finger.tan","Îäµ±ÈÎÎñ",pfm_list)
	   if _pfm_list then
	       world.SetVariable("wd_pfm_list",_pfm_list)
	   else
	       return
	   end

	  local all_skills_list=utils.inputbox ("²ğ½âµĞÈË¼¼ÄÜËùÊ¹ÓÃµÄpfm pfm_list ÉèÖÃ»ù±¾¸ñÊ½:¼¼ÄÜÃû³Æ1#pfm1#pfm1_list|¼¼ÄÜÃû³Æ2#pfm2#pfm2_list\nÀı:¶À¹Â¾Å½£#pfm1#pfm1_list|µ¯Ö¸ÉñÍ¨#pfm2#|´ò¹·°ô·¨#pfm2#pfm2_list", "Îäµ±ÈÎÎñ", "", "ËÎÌå", 9)
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
	   local _jb1=utils.listbox ("ÉèÖÃÎäµ±ÈÎÎñºóĞøµÄjob:", "Îäµ±ÈÎÎñ", jb1)
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
	   local _jb2=utils.listbox ("ÉèÖÃÎäµ±ÈÎÎñºóĞøµÄjob2:", "Îäµ±ÈÎÎñ", jb2)
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

	local yesno=utils.msgbox ("µÚÒ»´ÎËÍĞÅÊÇ·ñÁ¢¼´Í¶µİ£¬²»¹ÜÉ±ÊÖÊÇ·ñ³öÏÖ£¿", "ËÍĞÅÈÎÎñ", "yesno", "?")
	if yesno=="yes" then
	  world.SetVariable("immediate_sx1","true")
    else
      world.SetVariable("immediate_sx1","false")
	end

	 local t={"1.²»×öËÍĞÅ2", "2.Î¢²»×ãµÀ", "3.ÂíÂí»¢»¢", "4.Ğ¡ÓĞËù³É", "5.ÈÚ»á¹áÍ¨","6.ÆÄÎªÁËµÃ", "7.¼«ÆäÀ÷º¦","8.ÒÑÈë»¯¾³","9.È«²¿×ö"}
	 local shashou_level=utils.listbox ("µÚ¶ş´ÎËÍĞÅÉ±ÊÖµÈ¼¶Ñ¡Ôñ:", "ËÍĞÅÈÎÎñ", t)
	 if shashou_level~=nil then
	   world.SetVariable("shashou_level",shashou_level-1)
	 else
	   return
	 end

	local shashou_level=world.GetVariable("shashou_level")
    if tonumber(shashou_level)>=0 then
	 local blacklist={}

     blacklist={
	    ["Îäµ±ÅÉ"]="1.1 Îäµ±ÅÉ",
		["ÉÙÁÖÅÉ"]="1.2 ÉÙÁÖÅÉ",
		["ĞÇËŞÅÉ"]="1.3 ĞÇËŞÅÉ",
		["»ªÉ½ÅÉ"]="1.4 »ªÉ½ÅÉ",
		["¶ëáÒÅÉ"]="1.5 ¶ëáÒÅÉ",
		["Ñ©É½ÅÉ"]="1.6 Ñ©É½ÅÉ",
		["¹ÃËÕÄ½Èİ"]="1.7 ¹ÃËÕÄ½Èİ",
		["¹ÅÄ¹ÅÉ"]="1.8 ¹ÅÄ¹ÅÉ",
		["áÔÉ½ÅÉ"]="1.9 áÔÉ½ÅÉ",
		["À¥ÂØÅÉ"]="2.0 À¥ÂØÅÉ",
		["ÉñÁúµº"]="2.1 ÉñÁúµº",
		["ÌúÕÆ°ï"]="2.2 ÌúÕÆ°ï",
		["Ø¤°ï"]="2.3 Ø¤°ï",
		["ÌÒ»¨µº"]="2.4 ÌÒ»¨µº",
		["ÌìÁúËÂ"]="2.5 ÌìÁúËÂ",
		["´óÀí"]="2.6 ´óÀí",
		["Î¤ÍÓèÆ"]="3.1 Î¤ÍÓèÆ",
		["¶À¹Â¾Å½£"]="3.2 ¶À¹Â¾Å½£",
		["ĞşÒõ½£·¨"]="3.3 ĞşÒõ½£·¨",
		["´ò¹·°ô·¨"]="3.4 ´ò¹·°ô·¨",
		["ÌÚÁúØ°·¨"]="3.5 ÌÚÁúØ°·¨",
		["±ÙĞ°½£·¨"]="3.6 ±ÙĞ°½£·¨",
		["½µÁúÊ®°ËÕÆ"]="3.7 ½µÁúÊ®°ËÕÆ",
		["µ¯Ö¸ÉñÍ¨"]="3.8 µ¯Ö¸ÉñÍ¨",
		["ÌìÉ½ÕÈ·¨"]="3.9 ÌìÉ½ÕÈ·¨",
	  }

      local _blacklist=utils.multilistbox ("ÉèÖÃËÍĞÅÈÎÎñºÚÃûµ¥", "ËÍĞÅÈÎÎñ", blacklist)
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
	   local _pfm=utils.listbox ("ÉèÖÃ¡¾ËÍĞÅ1¡¿ÈÎÎñÊ¹ÓÃµÄpfm:", "ËÍĞÅÈÎÎñ", pfm)
	   if _pfm then
	      world.SetVariable("sx_pfm",_pfm)
	   else
	      return
	   end
	   local _pfm_list=utils.listbox ("ÉèÖÃ¡¾ËÍĞÅ1¡¿ÈÎÎñÊ¹ÓÃµÄpfm_list:", "ËÍĞÅÈÎÎñ", pfm_list)
	   if _pfm_list then
	      world.SetVariable("sx1_pfm_list",_pfm_list)
	   else
	      return
	   end
	   local _pfm=utils.listbox ("ÉèÖÃ¡¾ËÍĞÅ2¡¿ÈÎÎñÊ¹ÓÃµÄpfm:", "ËÍĞÅÈÎÎñ", pfm)
	   if _pfm then
	      world.SetVariable("sx2_pfm",_pfm)
	   else
	      return
	   end
	   local _pfm_list=utils.listbox ("ÉèÖÃ¡¾ËÍĞÅ2¡¿ÈÎÎñÊ¹ÓÃµÄpfm_list:", "ËÍĞÅÈÎÎñ", pfm_list)
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
	   local _jb1=utils.listbox ("ÉèÖÃËÍĞÅÈÎÎñºóĞøµÄjob1:", "ËÍĞÅÈÎÎñ", jb1)
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
	   local _pfm=utils.listbox ("ÉèÖÃ»ªÉ½ÈÎÎñÊ¹ÓÃµÄpfm:", "»ªÉ½ÈÎÎñ", pfm)
	   if _pfm then
	      world.SetVariable("hs_pfm",_pfm)
	   else
	      return
	   end

	    local yesno
		yesno =utils.msgbox ("ÊÇ·ñ×Ô¶¯µ÷Õû¹¤×÷´ÎÊı½âÎüĞÇ´ó·¨£¿", "»ªÉ½ÈÎÎñ", "yesno", "?")
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
	   local _jb1=utils.listbox ("ÉèÖÃ»ªÉ½ÈÎÎñºóĞøµÄjob1:", "»ªÉ½ÈÎÎñ", jb1)
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
	   local _pfm=utils.listbox ("ÉèÖÃÉÙÁÖ½ÌÎäÉ®ÈÎÎñÊ¹ÓÃµÄpfm:", "ÉÙÁÖ½ÌÎäÉ®ÈÎÎñ", pfm)
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
	   local _jb1=utils.listbox ("ÉèÖÃÉÙÁÖ½ÌÎäÉ®ÈÎÎñºóĞøµÄjob:", "ÉÙÁÖ½ÌÎäÉ®ÈÎÎñ", jb1)
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
	   local _jb2=utils.listbox ("ÉèÖÃÉÙÁÖ½ÌÎäÉ®ºóĞøµÄjob2:", "ÉÙÁÖ½ÌÎäÉ®ÈÎÎñ", jb2)
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
	   local _pfm=utils.listbox ("ÉèÖÃ»ªÉ½1 ÈÎÎñÊ¹ÓÃµÄpfm:", "»ªÉ½2ÈÎÎñ", pfm)
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
	   local _pfm=utils.listbox ("ÉèÖÃ»ªÉ½2 ÈÎÎñÊ¹ÓÃµÄpfm:", "»ªÉ½2ÈÎÎñ", pfm)
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
	   local _jb1=utils.listbox ("ÉèÖÃ»ªÉ½2 ÈÎÎñºóĞøµÄjob1:", "»ªÉ½2ÈÎÎñ", jb1)
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
	    ["ÌÒ»¨µº"]="1 ÌÒ»¨µº",
		["ÉÙÁÖ&Ìú¹÷"]="2 ÉÙÁÖ&Ìú¹÷",
		["´óÄÚ¸ßÊÖ"]="3 ´óÄÚ¸ßÊÖ",
		["Ã÷½Ì&²¼ÒÂ"]="4 Ã÷½Ì&²¼ÒÂ",
	  }
      local _blacklist=utils.multilistbox ("ÉèÖÃÑ©É½ÈÎÎñºÚÃûµ¥", "Ñ©É½ÈÎÎñ", blacklist)
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
	   local _pfm=utils.listbox ("ÉèÖÃÑ©É½ÈÎÎñÊ¹ÓÃµÄpfm:", "Ñ©É½ÈÎÎñ", pfm)
	   if _pfm then
	      world.SetVariable("xs_pfm",_pfm)
	   else
	      return
	   end
	local yesno =utils.msgbox ("ÊÇ·ñ²ÉÓÃÅÜÉ±£¿", "Ñ©É½ÈÎÎñ", "yesno", "?")
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

	    local _jb1=utils.listbox ("ÉèÖÃÑ©É½ÈÎÎñºóĞøµÄjob:", "Ñ©É½ÈÎÎñ", jb1)
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
	   local _jb2=utils.listbox ("ÉèÖÃÑ©É½ÈÎÎñºóĞøµÄjob2:", "Ñ©É½ÈÎÎñ", jb2)
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
	   local _pfm=utils.listbox ("ÉèÖÃÉñÁúµºË÷ÃüÈÎÎñÊ¹ÓÃµÄpfm:", "ÉñÁúµºË÷ÃüÈÎÎñ", pfm)
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
	   local _jb1=utils.listbox ("ÉèÖÃÉñÁúµºË÷ÃüÈÎÎñºóĞøµÄjob:", "ÉñÁúµºË÷ÃüÈÎÎñ", jb1)
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
	   local _jb2=utils.listbox ("ÉèÖÃÉñÁúµºË÷ÃüºóĞøµÄjob2:", "ÉñÁúµºË÷ÃüÈÎÎñ", jb2)
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
	   local _pfm=utils.listbox ("ÉèÖÃ×¥ÉßÈÎÎñÊ¹ÓÃµÄpfm:", "Ø¤°ï×¥ÉßÈÎÎñ", pfm)
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
	   local _jb1=utils.listbox ("ÉèÖÃ×¥ÉßÈÎÎñÊ¹ÓÃµÄpfm:", "Ø¤°ï×¥ÉßÈÎÎñ", jb1)
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
	    ["ÌÒ»¨µº"]="1 ÌÒ»¨µº",
		["ĞÇËŞÅÉ"]="2 ĞÇËŞÅÉ",
	  }
      local _blacklist=utils.multilistbox ("ÉèÖÃ³¤ÀÖ°ïÈÎÎñºÚÃûµ¥", "³¤ÀÖ°ïÈÎÎñ", blacklist)
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
	   local _pfm=utils.listbox ("ÉèÖÃ³¤ÀÖ°ïÈÎÎñÊ¹ÓÃµÄpfm:", "³¤ÀÖ°ïÈÎÎñ", pfm)
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
	   local _jb1=utils.listbox ("ÉèÖÃ³¤ÀÖ°ïÈÎÎñºóĞøµÄjob1:", "³¤ÀÖ°ïÈÎÎñ", jb1)
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
	   local _pfm=utils.listbox ("ÉèÖÃØ¤°ïÈÎÎñÊ¹ÓÃµÄpfm:", "Ø¤°ïÈÎÎñ", pfm)
	   if _pfm then
	      world.SetVariable("gb_pfm",_pfm)
	   else
	      return
	   end
	   local gb_blacklist=world.GetVariable("gb_blacklist") or "¸É¹âºÀ|³ö³¾×Ó|Îå¶¾½ÌÅ®µÜ×Ó|ÀËµ´¹«×Ó|¸»¼Ò¹«×Ó|Ã©Ê®°Ë|ºéÏøÌì|ÁëÄÏ´óµÁ|Áº×ÓÎÌ|ÀÍµÂÅµ|ÖÜ¹ÂÍ©|Îâ°ØÓ¢|ÕªĞÇ×Ó|Ê¨ºğ×Ó|÷öÈ»×Ó|ÃÉ¹ÅÎÀÊ¿|Ê·ïÚÍ·|Íõ·òÈË|ÕÔÃô|ÂÀÎÄµÂ|ºî¾ı¼¯|ºö±ØÁÒ|´ï¶û°Í|Áú¾í·ç|ÂíÕÆ¹ñ|ÕÅºÆÌì|»ÆÁîÌì|Ñ¦Ä½»ª|¼Ö²¼|ÌìÀÇ×Ó"
	   gb_blacklist=utils.inputbox ("ĞèÒªÉèÖÃgb_blacklist ±äÁ¿: Ø¤°ïÈÎÎñÆÁ±ÎµÄNPC Àı ¸É¹âºÀ|³ö³¾×Ó|Îå¶¾½ÌÅ®µÜ×Ó|ÀËµ´¹«×Ó|¸»¼Ò¹«×Ó|Ã©Ê®°Ë|ºéÏøÌì|ÁëÄÏ´óµÁ|Áº×ÓÎÌ|ÀÍµÂÅµ|ÖÜ¹ÂÍ©|Îâ°ØÓ¢|ÕªĞÇ×Ó|Ê¨ºğ×Ó|÷öÈ»×Ó|ÃÉ¹ÅÎÀÊ¿|Ê·ïÚÍ·|Íõ·òÈË|ÕÔÃô|ÂÀÎÄµÂ|ºî¾ı¼¯|ºö±ØÁÒ|´ï¶û°Í|Áú¾í·ç|ÂíÕÆ¹ñ|ÕÅºÆÌì|»ÆÁîÌì|Ñ¦Ä½»ª|¼Ö²¼|ÌìÀÇ×Ó", "Ø¤°ïÈÎÎñ", gb_blacklist, "ËÎÌå", 9)
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
	   local _jb1=utils.listbox ("ÉèÖÃØ¤°ïÈÎÎñºóĞøµÄjob1:", "Ø¤°ïÈÎÎñ", jb1)
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
	   local _pfm=utils.listbox ("ÉèÖÃÃ÷½ÌÑ²ÂßÈÎÎñÊ¹ÓÃµÄpfm:", "Ã÷½ÌÑ²ÂßÈÎÎñ", pfm)
	   if _pfm then
	      world.SetVariable("xl_pfm",_pfm)
	   else
	      return
	   end


	  local yesno=utils.msgbox ("ÊÇ·ñµÈ´ı»­Ó¡Ê±ºò´ò×ø(Ñ²ÂßÈË¶àÊ±ºò×îºÃ¹Ø±Õ)", "Ã÷½ÌÑ²ÂßÈÎÎñ", "yesno", "?")
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
	   local _jb1=utils.listbox ("ÉèÖÃÃ÷½ÌÑ²ÂßÈÎÎñºóĞøµÄjob1:", "Ã÷½ÌÑ²ÂßÈÎÎñ", jb1)
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
	   local _pfm=utils.listbox ("ÉèÖÃÉÙÁÖ¾ÈÔ®ÈÎÎñÊ¹ÓÃµÄpfm:", "ÉÙÁÖ¾ÈÔ®ÈÎÎñ", pfm)
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
	   local _jb1=utils.listbox ("ÉèÖÃÉÙÁÖ¾ÈÔ®ÈÎÎñºóĞøµÄjob:", "ÉÙÁÖ¾ÈÔ®ÈÎÎñ", jb1)
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
	   local _jb2=utils.listbox ("ÉèÖÃÉÙÁÖ¾ÈÔ®ÈÎÎñºóĞøµÄjob2:", "ÉÙÁÖ¾ÈÔ®ÈÎÎñ", jb2)
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
	   local _pfm=utils.listbox ("ÉèÖÃÊØÄ¹ÈÎÎñÊ¹ÓÃµÄpfm:", "ÊØÄ¹ÈÎÎñ", pfm)
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
	   local _jb1=utils.listbox ("ÉèÖÃÊØÄ¹ÈÎÎñºóĞøµÄjob:", "ÊØÄ¹ÈÎÎñ", jb1)
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
	   local _jb2=utils.listbox ("ÉèÖÃÊØÄ¹ºóĞøµÄjob2:", "ÊØÄ¹ÈÎÎñ", jb2)
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
	   local _pfm=utils.listbox ("ÉèÖÃĞÇËŞÇÀ½ÙÈÎÎñÊ¹ÓÃµÄpfm:", "ĞÇËŞÇÀ½Ù", pfm)
	   if _pfm then
	      world.SetVariable("qj_pfm",_pfm)
	   else
	      return
	   end
--[[
    if self.jobs_auto_setting==false then
	   local jb1={}
	   local _jb1=utils.listbox ("ÉèÖÃĞÇËŞÇÀ½ÙºóĞøµÄjob1:", "ĞÇËŞÇÀ½Ù", jb1)
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
	   local _pfm=utils.listbox ("ÉèÖÃáÔÉ½ÈÎÎñ ÇëÈËËùÊ¹ÓÃµÄpfm:", "áÔÉ½ÈÎÎñ", pfm)
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
	   local _pfm=utils.listbox ("ÉèÖÃáÔÉ½ÈÎÎñ ´ÌÉ±ËùÊ¹ÓÃµÄpfm:", "áÔÉ½ÈÎÎñ", pfm)
	   if _pfm then
	      world.SetVariable("ss_kill_pfm",_pfm)
	   else
	      return
	   end


	   local ss_blacklist=world.GetVariable("ss_blacklist")
	   ss_blacklist=utils.inputbox ("ĞèÒªÉèÖÃss_blacklist ±äÁ¿: áÔÉ½ÈÎÎñÆÁ±ÎµÄ¼¼ÄÜ»òÃÅÅÉ Àı ĞÇËŞÅÉ|½µ·üÂÖ ", "áÔÉ½ÈÎÎñ", ss_blacklist, "ËÎÌå", 9)
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
	   local _jb1=utils.listbox ("ÉèÖÃáÔÉ½ÈÎÎñºóĞøµÄjob1:", "áÔÉ½ÈÎÎñ", jb1)
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

--[[	   local _jb1=utils.listbox ("ÉèÖÃºéÆß¹«×ö²ËºóĞøµÄjob1:", "ºéÆß¹«×ö²ËÈÎÎñ", self.jobslist)
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
	     learn="1 Ñ§Ê¦¸µ",
		 literate="2 Ñ§¶ÁÊéÊ¶×Ö",
		 zhizhao="3 Ñ§Ö¯Ôì",
		 duanzao="4 Ñ§¶ÍÔì",
		 lingwu="5 ´ïÄ¦ÔºÁìÎò",
		 taojiao="6 Ã÷½ÌÌÖ½Ì",
		 shenzhaojing="7 ÉñÕÕ¾­",
		 chenggao="8 ³É¸ßµÀ³¤"
	    }
	   local _up=utils.listbox ("Éı¼¶·½Ê½:", "Éı¼¶ÉèÖÃ", up)
	   if _up then
	      world.SetVariable("up",_up)
	   else
	      return
	   end

	local up=world.GetVariable("up")
	if up=="learn" then
	  local master_id=utils.inputbox ("ÄãµÄÊ¦¸µ[id]?", "Éı¼¶ÉèÖÃ", "", "ËÎÌå", 9)
	  if master_id then
        world.SetVariable("masterid",master_id)
	  end
     local master_place=utils.inputbox ("Ê¦¸µËùÔÚ·¿¼äºÅ?", "Éı¼¶ÉèÖÃ", "", "ËÎÌå", 9)
	 if master_place then
       world.SetVariable("master_place",master_place)
	 end
     local sleeproomno=utils.inputbox ("Ë¯¾õµÄ·¿¼äºÅ?", "Éı¼¶ÉèÖÃ", "", "ËÎÌå", 9)
	 if sleeproomno then
	  world.SetVariable("sleeproomno",sleeproomno)
	 end
      local pot=utils.inputbox ("Ã¿´ÎÑ§Ï°ÏûºÄµÄpotÁ¿?", "Éı¼¶ÉèÖÃ", "1", "ËÎÌå", 9)
	 if pot then
       world.SetVariable("pot",pot)
	 end
	end

		local bei_up={
	     learn="1 Ñ§Ê¦¸µ",
		 lingwu="2 ´ïÄ¦ÔºÁìÎò",
	    }
	   local _bei_up=utils.listbox ("ºó±¸Éı¼¶·½Ê½(gold ÏûºÄÍêÁË×Ô¶¯ÇĞ»»):", "Éı¼¶ÉèÖÃ", bei_up)
	   if _bei_up then
	      world.SetVariable("bei_up",_bei_up)
	   else
	      return
	   end
	  --Ñ§Ï° ÁìÎòµÄ skills Ñ¡Ôñ
	if up=="learn" then

	  local teach_skills=world.GetVariable("teach_skills")
	  local _skills=Split(teach_skills,"|")
      local _list=utils.multilistbox ("ÉèÖÃÑ§Ï°¼¼ÄÜ(¶àÏîÑ¡Ôñ) ÊÖ¶¯µ÷Õû±äÁ¿¡¾skills¡¿ÖĞ¼¼ÄÜÑ§Ï°µÄÏÈºóË³Ğò,¿ÉÒÔ zui-gun&tiegun|liuhe-dao&mu dao Ö§³Ö×°±¸×Ô¶¨ÒåÎäÆ÷", "Éı¼¶ÉèÖÃ", _skills)
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
	 -- Á· skills ¼¼ÄÜÑ¡Ôñ
	if up=="lingwu" then
	 local baseskills={}
	 --1 »ù±¾¼¼ÄÜ
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
	 local _list=utils.multilistbox ("ĞèÒªÁ·µÄ»ù±¾¹¦ÉèÖÃ(¶àÏîÑ¡Ôñ)", "Éı¼¶ÉèÖÃ", _skills)
	 if _list then
        for n,i in pairs(_list) do
		  --print(n,_skills[n])
		  table.insert(baseskills,_skills[n])
	    end
	 else
        return
	 end
	 --2 ÌØÊâ¼¼ÄÜ
	 --print("lian skills ÉèÖÃ2 ºÍ»ù±¾¹¦¶ÔÓ¦ÌØÊâÎä¹¦ÉèÖÃ¡£ Àı bihao-chaosheng¶ÔÓ¦force,lanhua-shou¶ÔÓ¦hand")
	 local specialskills={}
	 for _,value in ipairs(baseskills) do
	   local special_skills={}
	   local _special_index=utils.listbox ("ºÍ"..value.."¶ÔÓ¦µÄÌØÊâÎä¹¦:", "Éı¼¶ÉèÖÃ", _special_skills)
	   if _special_index then
	       local result=_special_skills[_special_index].."&"..value
		   print(result)
		   table.insert(specialskills,result)
	   else
	      return
	   end
	 end
	 --ÁìÎòµÄ¼¼ÄÜ
	 local result=""
	 for n,i in ipairs(baseskills) do
		result=result..i.."|"
	 end
	 if result~="" then
		result=string.sub(result,1,-2)
	 end
	 world.SetVariable("skills",result)
	 --ÌØÊâµÄ¼¼ÄÜ
	 local result=""
	 for n,i in ipairs(specialskills) do
	    result=result..i.."|"
	 end
	 if result~="" then
		result=string.sub(result,1,-2)
	 end
	 world.SetVariable("lian_skills",result)
	end
	--3 ready Ö´ĞĞº¯Êı

	local lingwu_finish=utils.inputbox ("ÁìÎòÍê³ÉÒÔºóÖ´ĞĞµÄÃüÁî,±ÈÈçjifa force bihai-chaoshen;jifa sword yuxiao-jian\nÁìÎòÒÔºóÖØĞÂbei jifa ¼¼ÄÜÊ¹ÓÃ¡£", "Éı¼¶ÉèÖÃ", "", "ËÎÌå", 9)
   if lingwu_finish then
     world.SetVariable("lingwu_finish",lingwu_finish)
   else
     return
   end
end

function wizard:equipments()

   local i_equip_sample="¹¦ÄÜ´óÈ« <»ñÈ¡> <³öÊÛ> <´æÔÚ> <±£´æ> <¶ªÆú> <Ê¹ÓÃ> <×Ô¶¯ĞŞÀí> <ĞŞÀí>\n"
  i_equip_sample=i_equip_sample .."1.<»ñÈ¡>ÎïÆ·Ãû³Æ&ÊıÁ¿ ±ÈÈç<»ñÈ¡>Ä¾½£&2|<»ñÈ¡>°×Òø&50\n"
  i_equip_sample=i_equip_sample .."2.<³öÊÛ>¼×&ÊıÁ¿~{ÅÅ³ı1,ÅÅ³ı2} »á×Ô¶¯³öÊÛËùÓĞÌú¼×,Æ¤¼×¡£ÊıÁ¿{¿ÉÑ¡Ïî²»ÌîĞ´Ä¬ÈÏÊÇ1}.\nÅÅ³ı~{Èíâ¬¼×}²»»á³öÊÛÈíâ¬¼×\n"
  i_equip_sample=i_equip_sample .."3.<´æÔÚ>ÎïÆ·Ãû³Æ ²»´æÔÚÊ±ºò»á×Ô¶¯ÍË³ö\n"
  i_equip_sample=i_equip_sample .."4.<±£´æ>Óñ~{ğàÓñ}|<±£´æ>°×Òø&200 »á×Ô¶¯±£´æÓñ °×Òø³¬¹ı200 »á×Ô¶¯±£´æ\n"
  i_equip_sample=i_equip_sample .."5.<¶ªÆú>²¼ÒÂ|<¶ªÆú>³¤ÅÛ\n"
  i_equip_sample=i_equip_sample .."6.<Ê¹ÓÃ>Ê®ÈıÁúÏóôÂôÄ|<Ê¹ÓÃ>µ¤|<Ê¹ÓÃ>Íè ×Ô¶¯³Ô½±ÀøµÄÒ©ÍèºÍÁúÏóôÂôÄ\n"
  local i_equip= world.GetVariable("i_equip") or ""
  local i_equip=utils.inputbox(i_equip_sample, "ÎïÆ·ÉèÖÃ", i_equip, "ËÎÌå", 9)
  if i_equip then
     world.SetVariable("i_equip",i_equip)
  else
     return
  end
end

function wizard:other()
   local neili_upper=utils.inputbox ("¹¤×÷Ç°ÄÚÁ¦´ò×ø±¶Êı 1~1.9µÄÖµ", "ÆäËûÉèÖÃ", "1.5", "ËÎÌå", 9)
   if neili_upper then
       world.SetVariable("neili_upper",neili_upper)
   else
       return
   end
   local _xiulian={
		xiulian_neili="1 ĞŞÁ¶ÄÚÁ¦",
		xiulian_jingli="2 ĞŞÁ¶¾«Á¦",
	}
	local xiulian=utils.listbox ("¹¤×÷busyÊ±ºòĞŞÁ¶ÄÚÁ¦»ò¾«Á¦:", "ÆäËûÉèÖÃ", _xiulian,"xiulian_neili")
	if xiulian then
		world.SetVariable("xiulian",xiulian)
	else
		return
	end

   local pot_overflow=world.GetVariable("pot_overflow") or "20"
   pot_overflow=utils.inputbox("pot±£ÁôÖµ ×î´ópot-µ±Ç°pot<=±£ÁôÖµÊ±»áÍ£Ö¹job È¥Ñ§Ï°ÁìÎòÏûºÄpot£¬Èç¹û²»ÏëÑ§Ï°ÁìÎò£¬Õâ¸öÖµÉèÖÃ³É-1", "ÆäËûÉèÖÃ", pot_overflow, "ËÎÌå", 9)
   if pot_overflow then
       world.SetVariable("pot_overflow",pot_overflow)
   else
       return
   end
   local wuxing=utils.inputbox("Ñ§Ï°Ç°ÌáÇ°×öµÄ¶¯×÷ÉèÖÃ ±ÈÈçyun maze;yun xinjing ×°±¸ wield ÁúÈª½£", "ÆäËûÉèÖÃ", "", "ËÎÌå", 9)
   if wuxing then
       world.SetVariable("wuxing",wuxing)
   else
      -- return
   end
   local sp_exert=world.GetVariable("sp_exert")
   local shield=utils.inputbox("Õ½¶·Ç°ÌáÇ°×öµÄ¶¯×÷ÉèÖÃ±ÈÈç×°±¸ÎäÆ÷¿ÉÒÔ°´ÈÎÎñ½øĞĞÉèÖÃjson¸ñÊ½ Àı \"»ªÉ½1\":\"wield sword\",\"È«²¿\":\"bei none;bei strike;unwield zhen;unwield jian;wield yinshe sword;wield jian;yun huti\"", "ÆäËûÉèÖÃ", sp_exert, "ËÎÌå", 9)
   if shield then
       world.SetVariable("sp_exert",shield)
	else
	   world.SetVariable("sp_exert","\"È«²¿\":\"\"")
   end

	 local yesno=utils.msgbox ("ÊÇ·ñ×Ô¶¯²ÎÎòÊôĞÔ:", "ÆäËûÉèÖÃ", "yesno", "?")
	     if yesno=="no" then
            world.SetVariable("is_canwu","false")
         else
			world.SetVariable("is_canwu","true")
			local canwu_exps_limit=utils.inputbox("¶àÉÙ¾­Ñé¿ªÊ¼²ÎÎò¶îÍâ¾­Ñé?", "ÆäËûÉèÖÃ", "15000000", "ËÎÌå", 9)
            if canwu_exps_limit then
              world.SetVariable("canwu_exps_limit",canwu_exps_limit)
	        end
	        local canwu_gift_limit=utils.inputbox("¶àÉÙ¾­Ñé¿ªÊ¼²ÎÎòÌì¸³£¿", "ÆäËûÉèÖÃ", "20000000", "ËÎÌå", 9)
            if canwu_gift_limit then
              world.SetVariable("canwu_gift_limit",canwu_gift_limit)
	        end
		 end


   local pfm1=world.GetVariable("pfm1")
   local pfm2=world.GetVariable("pfm2")
   local pfm3=world.GetVariable("pfm3")
   local pfm4=world.GetVariable("pfm4")
   local pfm5=world.GetVariable("pfm5")
   local _pfm1=utils.inputbox("pfm1 aliasÉèÖÃ", "ÆäËûÉèÖÃ", pfm1, "ËÎÌå", 9)
   if _pfm1 then
      world.SetVariable("pfm1",_pfm1)
   else
   end

   local _pfm2=utils.inputbox("pfm2 aliasÉèÖÃ", "ÆäËûÉèÖÃ", pfm2, "ËÎÌå", 9)
   if _pfm2 then
      world.SetVariable("pfm2",_pfm2)
   else
   end

   local _pfm3=utils.inputbox("pfm3 aliasÉèÖÃ", "ÆäËûÉèÖÃ", pfm3, "ËÎÌå", 9)
   if _pfm3 then
      world.SetVariable("pfm3",_pfm3)
   else
   end

   local _pfm4=utils.inputbox("pfm4 aliasÉèÖÃ", "ÆäËûÉèÖÃ", pfm4, "ËÎÌå", 9)
   if _pfm4 then
      world.SetVariable("pfm4",_pfm4)
   else
   end

   local _pfm5=utils.inputbox("pfm5 aliasÉèÖÃ", "ÆäËûÉèÖÃ", pfm5, "ËÎÌå", 9)
   if _pfm5 then
      world.SetVariable("pfm5",_pfm5)
   else
   end

   local _blockNPC={
		["fan yiweng"]="1 ·®Ò»ÎÌ",
		["yin liting"]="2 ÒóÀæÍ¤",
		["huang lingtian"]="3 ÁèÕğÌì*",
		["ling zhentian"]="4 ÁèÕğÌì*",
		["chuchen zi"]="5 ³ö³¾×Ó*",
		["xi huazi"]="6 Î÷»ª×Ó",
		["hong xiaotian"]="7 ºéÏøÌì",
		["xuansheng dashi"]="8 ĞşÉú´óÊ¦*",
		["yang xiao"]="9 ÑîåĞ*",
		["fan yao"]="10 ·¶Ò£",
		["he taichong"]="11 ºÎÌ«³å",
		["hufa shizhe"]="12 »¤·¨Ê¹Õß*",
		["wu seng"]="13 ÎäÉ®",
		["zhang songxi"]="14 ÕÅËÉÏª",
		["zhao liangdong"]="15 ÕÔÁ¼¶°",
		["ding mian"]="16 ¶¡Ãã",
		["yu lianzhou"]="17 ÓáÁ«ÖÛ",
		["huizhen zunzhe"]="18 »ÛÕæ×ğÕß*",
		["dadian dashi"]="19 ´óñ²´óÊ¦*",
	    ["murong bo"]="20 Ä½Èİ²©", }

  local blockNPC=utils.multilistbox("µ²Â·npc Ê¹ÓÃpfmÉèÖÃ:", "ÆäËûÉèÖÃ", _blockNPC)
  local result=""
  for n,i in pairs(_blockNPC) do
	 result=result..n.."|"
  end
  if result~="" then
	 result=string.sub(result,1,-2)
  end
  world.SetVariable("blockNPC",result)

  local cmd=world.GetVariable("cmd")
  local _cmd=utils.inputbox("cmd ¶Ôµ²Â·NPCÊ¹ÓÃpfmµÄaliasÉèÖÃ", "ÆäËûÉèÖÃ", cmd, "ËÎÌå", 9)
   if _cmd then
      world.SetVariable("cmd",_cmd)
   else
   end
end

function wizard:special_heal()
   local liao_percent=world.GetVariable("liao_percent")
   local _liao_percent=utils.inputbox("ÕÒÑ¦Ä½»ªÁÆÉËÆøÑª°Ù·Ö±ÈÉèÖÃ", "ÁÆÉË", liao_percent, "ËÎÌå", 9)
   if _liao_percent then
      world.SetVariable("liao_percent",_liao_percent)
   else
   end
  local party=world.GetVariable("party")
  if party=="Ã÷½Ì" then
	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥ºûµû¹ÈÕÒºúÇàÅ£ÁÆÉË£¿", "ÁÆÉË", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("special_heal","hudiegu")
	 end
  end
   local yesno=utils.msgbox ("ÊÇ·ñÊ¹ÓÃÁúÏó°ãÈô¹¦µÄ¾ÛÑªÁÆÉË£¿", "ÁÆÉË", "yesno", "?")
	if yesno=="yes" then
	   world.SetVariable("special_heal","juxue")
	end
	local yesno=utils.msgbox ("ÊÇ·ñÊ¹ÓÃÒ»ÑôÖ¸ÁÆÉË£¿", "ÁÆÉË", "yesno", "?")
	if yesno=="yes" then
	   world.SetVariable("special_heal","liao")
	end
end

function wizard:zone()

	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥ÆÎÌïÉÙÁÖ£¿", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("putian_entry","true")
	 else
	   world.SetVariable("putian_entry","false")
	 end

	  local yesno=utils.msgbox ("ÊÇ·ñÈ¥áÔÉ½ÉÙÁÖ£¿", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("shaolin_entry","true")
	 else
	   world.SetVariable("shaolin_entry","false")
	 end

	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥ºÚÄ¾ÑÂ£¿", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("heimuya_entry","true")
	 else
	   world.SetVariable("heimuya_entry","false")
	 end


	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥Îäµ±ºóÉ½£¿", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("wudanghoushan_entry","true")
	 else
	   world.SetVariable("wudanghoushan_entry","false")
	 end

	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥ÌìÉ½£¿", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("tianshan_entry","true")
	 else
	   world.SetVariable("tianshan_entry","false")
	 end


	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥¾øÇé¹È£¿", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("jueqinggu_entry","true")
	 else
	   world.SetVariable("jueqinggu_entry","false")
	 end

	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥ÌÒÔ´£¿", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("taoyuan_entry","true")
	 else
	   world.SetVariable("taoyuan_entry","false")
	 end

	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥ºûµû¹È¿", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("hudiegu_entry","true")
	 else
	   world.SetVariable("hudiegu_entry","false")
	 end

	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥ÉñÁúµº?", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("sld_entry","true")
	 else
	   world.SetVariable("sld_entry","false")
	 end

	 local yesno=utils.msgbox ("ÊÇ·ñÈ¥Îå¶¾½Ì?", "ÇøÓò", "yesno", "?")
	 if yesno=="yes" then
	   world.SetVariable("wdj_entry","true")
	 else
	   world.SetVariable("wdj_entry","false")
	 end
end

function wizard:plugin()

   local afk_cmd=world.GetVariable("afk_cmd")
   local afk_sec=world.GetVariable("afk_sec")

   local _afk_cmd=utils.inputbox("·¢´ôÖØĞÂÆô¶¯ÈÎÎñÃüÁî(±ÈÈçÄãÏë·¢´ôÒÔºóÆô¶¯Îäµ±ÈÎÎñ¿ÉÒÔÕâÑùĞ´Weapon_Check(process.wd)¡£\nWeapon_Check±íÊ¾ÎäÆ÷¼ì²é,process.wdÊÇÎäµ±ÈÎÎñµÄ½ø³Ì,ÕâÖÖĞ´·¨¾Í±íÊ¾ÎäÆ÷¼ì²éÒÔºóÆô¶¯Îäµ±ÈÎÎñ)", "²å¼şÉèÖÃ", afk_cmd, "ËÎÌå", 9)
   if _afk_cmd then
      world.SetVariable("afk_cmd",_afk_cmd)
   else
   end
   local _afk_sec=utils.inputbox("·¢´ôÊ±¼ä¼ä¸ôÉèÖÃ(Ãë),²å¼şÔÚÉè¶¨Ê±¼äÄÚÃ»ÓĞÈÎºÎÖ¸ÁîÊäÈë¾ÍÈÏÎª·¢´ôÁË£¬Ò»°ãÉèÖÃÎª60", "²å¼şÉèÖÃ", afk_sec, "ËÎÌå", 9)
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
   	 local yesno=utils.msgbox ("ÊÇ·ñÏÔÊ¾Ğ¡µØÍ¼?", "²å¼ş", "yesno", "?")
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
	   print("µ¼Èë±äÁ¿:",tag_name," ",tag_content)
	   world.SetVariable(tag_name,tag_content)
	end

  end -- if have a node name

end -- writenode

function wizard:update_webconfig()
   local player_id=world.GetVariable("player_id") or ""
   local world_address=world.GetVariable("world_address") or ""
   local id=player_id.."@"..world_address
   local config_updated=utils.msgbox ("ÊÇ·ñ½«µ±Ç°ÅäÖÃÉÏ´«·şÎñÆ÷?", "ÉèÖÃ¾«Áé", "yesno", "?")
   if config_updated=="yes" then
		--µ±Ç°ËùÓĞ±äÁ¿
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
       local config_txt=utils.inputbox("Çë½«ÅäÖÃĞÅÏ¢¸´ÖÆµ½ÊäÈë¿òÖĞ", "ÉèÖÃ¾«Áé", variables, "ËÎÌå", 9)

	   --config_txt=string.gsub(config_txt,"&amp;","&")
       --print(config_txt)
	   package.loaded["webServer"]=nil
	   require "webServer"
       webServer:Config_Save(id,config_txt)
	   package.loaded["webServer"]=nil
	   print("ÉÏ´«ÅäÖÃ½áÊø!")
   end

end

function wizard:select_settings(flag)
   --Ñ¡ÔñÉèÖÃÄÚÈİ£¡
   local mastername=world.GetVariable("mastername") or ""
   local exps=world.GetVariable("exps") or "0"
   local player_name=world.GetVariable("player_name") or ""
   local player_id=world.GetVariable("player_id") or ""
   local world_address=world.GetVariable("world_address") or ""
   local party=world.GetVariable("party") or ""
   local gender=world.GetVariable("gender") or "ÄĞĞÔ"
   local exert_gift=world.GetVariable("exert_gift") or "0"
   local exert_reward=world.GetVariable("exert_reward") or "0"
   --[[
   local url="http://112.65.143.180:9001/SJMain.aspx?mastername="..mastername.."&exps="..exps.."&name="..player_name.."&id="..player_id.."&party="..party.."&gender="..gender.."&exert_gift="..exert_gift.."&exert_reward="..exert_reward
   --print(url)
   local xml=""
    local is_download=utils.msgbox ("ÊÇ·ñ´Ó·şÎñÆ÷ÏÂÔØÅäÖÃÎÄ¼ş?", "ÉèÖÃ¾«Áé", "yesno", "?")
	if is_download=="yes" then
	    local id=player_id.."@"..world_address
		package.loaded["webServer"]=nil
		require "webServer"
	    xml=webServer:Config_Get(id)
		package.loaded["webServer"]=nil
		print("_______________________ÅäÖÃÎÄ¼şÏÂÔØÍê³É_________________________________")
		xml=string.gsub(xml,"&lt;","<")
		xml=string.gsub(xml,"&gt;",">")
	else
	   local yesno =utils.msgbox ("ÊÇ·ñĞèÒªÇ°ÍùÔÚÏß°ïÖúÍøÕ¾ÅäÖÃ»úÆ÷ÈË?", "ÉèÖÃ¾«Áé", "yesno", "?")
	   if yesno=="yes" then
	      world.OpenBrowser(url)
	   end
	end

	local loadingVariable=false
	 loadingVariable=utils.msgbox("ÊÇ·ñµ¼ÈëÅäÖÃĞÅÏ¢","ÉèÖÃ¾«Áé","yesno","?")
	 if loadingVariable=="yes" then
	       local xml_txt=utils.inputbox("Çë½«ÅäÖÃĞÅÏ¢¸´ÖÆµ½ÊäÈë¿òÖĞ", "ÉèÖÃ¾«Áé", xml, "ËÎÌå", 9)
           if xml_txt then

			 xml_txt=string.gsub(xml_txt,"&","&amp;")
			 xml_txt=string.gsub(xml_txt,"lt;","&lt;")
			 xml_txt=string.gsub(xml_txt,"gt;","&gt;")
			  xml_txt=string.gsub(xml_txt,"2b;","+")


			 --print(xml_txt)
			 xml_txt="<variables>"..xml_txt.."</variables>"
             local value=world.ImportXML(xml_txt)
			 if value>0 then
			    utils.msgbox("µ¼Èë±äÁ¿³É¹¦,¹²"..value.."µ¼Èë¡£","ÉèÖÃ¾«Áé","ok","?")
			 else
                utils.msgbox("¸ñÊ½´íÎóµ¼ÈëÊ§°Ü!","ÉèÖÃ¾«Áé","ok","?")
			 end
           end
	 end]]

	  local loadingVariable=false
	  loadingVariable=utils.msgbox("ÊÇ·ñµ¼ÈëÅäÖÃÎÄ¼ş","ÉèÖÃ¾«Áé","yesno","?")
	  if loadingVariable=="yes" then
	     local filter = { txt = "Text files", ["*"] = "All files" }
	     local filename = utils.filepicker ("ÅäÖÃÎÄ¼ş", name, "txt", filter, false)
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
        yesno =utils.msgbox ("ÊÇ·ñµÚÒ»´ÎÉèÖÃ?", "ÉèÖÃ¾«Áé", "yesno", "?")
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
	       local model=utils.listbox ("Ñ¡ÔñĞèÒªÉèÖÃµÄÄ£¿é", "Ñ¡ÔñÄ£¿é", { "1.²å¼şÉèÖÃ", "2.ÈÎÎñË³ĞòÉèÖÃ", "3.¼¼ÄÜÑ¡ÔñÉèÖÃ", "4.×°±¸ÉèÖÃ","5.ÆäËûÉèÖÃ","6.ÌØÊâÁÆÉËÉèÖÃ","7.ÇøÓò½ø³öÉèÖÃ" })
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
		    local yesno=utils.msgbox ("ÊÇ·ñÍê³ÉÉèÖÃ?", "ÉèÖÃ¾«Áé", "yesno", "?")
			if yesno=="yes" then
			     print("---------------------------------------------------------")
				 register() --ÈÎÎñ×¢²á
				 world.ColourNote ("red", "yellow", "ÉèÖÃ½áÊø£¬ÊäÈëÈÎÎñ¿ªÊ¼µÄÃüÁî")
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
     print("Í£Ö¹»úÆ÷ÈË")
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
				    print("ÊÖ¶¯Ä£Ê½")
				    CallPlugin(PluginID, "Disable_AFK")
				else
				    print("¹Ò»úÄ£Ê½")
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
    xc="1.1 ´óÀíÑ²³Ç",
	tdh="2.1 ÌìµØ»á",
	zc="2.2 ºéÆß¹«×ö²Ë",
	wudang="3.1 Îäµ±",
	hs="3.2 »ªÉ½1",
	hs2="3.3 »ªÉ½2",
	sx="3.4 ´óÀíËÍĞÅ",
	xs="4.1 Ñ©É½",
	cl="4.2 ³¤ÀÖ°ï",
	tx="5.1 Ä½ÈİÍµÑ§",
	suoming="5.2 ÉñÁúµºË÷Ãü",
	sm="5.3 ÌÒ»¨µºÊØÄ¹",
	ss="5.4 ×óÀäìøÈÎÎñ",
	gb="5.5 Ø¤°ï",
	zs="5.6 ×¥Éß",
	jh="5.7 ½½»¨",
	tm="5.8 ÉÙÁÖ½ÌÎäÉ®",
	ck="5.9 ²É¿ó",
	xl="6.0 Ã÷½ÌÑ²ÂßÈÎÎñ",
	jy="6.1 ÉÙÁÖ¾ÈÔ®ÈÎÎñ",
	xxbug="6.2 ĞÇËŞ×¥³æ",
	qqll="6.3 ÆßÇÏÁáççÓñÈÎÎñ"

  }
       local select_job=utils.listbox ("Ñ¡ÔñÄãÒª×öÈÎÎñ", "ÉèÖÃ¾«Áé", jobs)
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
     world.Send("jump Å£ĞÄÊ¯")
     world.Send("canwu 100000 to neili")
  end
  w:go(669)
end

--×Ô¶¯ÉèÖÃ masterµÄ·¿¼äºÅ Ë¯·¿ id
function master_setting(master_name)
    --Îäµ±  2790 ÄĞ 3175 Å®
	--ÉÙÁÖ 877 878
	--¶ëÃ¼ 653
	--¹ÅÄ¹  3016 ¾øÇé¹È
	--»ªÉ½ 1524 ÄĞĞÔ  3174 Å®ĞÔ
	--È«Õæ 4166
	--åĞÒ£ 4242
	--ÁéğÕ¹¬  2339
	--ĞÇËŞÅÉ 3110
	--´óÂÖËÂ 2711 Å®ĞÔ 2272 ÄĞĞÔ ´ó²İÔ­ ¹şÈø¿ËÕÊÅñ 2072 2075
	--ÌÒ»¨µº 2785 ÄĞĞÔ 3146 Å®ĞÔ ¹éÔÆ×¯  2815 ÌÒ»¨µº
	--ÈÕÔÂÉñ½Ì 142
	--À¥ÂØÅÉ  3023
	--Ã÷½Ì 2248
	--ÉñÁúµº 1800
	--Ø¤°ï
	--Ä½Èİ 877 Ä½Èİ²©  2003 Ä½Èİ¸´ 2186 Íõ·òÈË
	--´óÀí 484
	--ÌìÁúËÂ 3890 3892
	--áÔÉ½ 308  ÄĞĞÔ 3154 Å®ĞÔ
	--ÌúÕÆ 2418 ÄĞĞÔ 4989 Å®ĞÔ
	local party=world.GetVariable("party") or ""
	local gender=world.GetVariable("gender") or ""
	if master_name==nil or master_name=="" then
	   master_name=world.GetVariable("mastername") or ""
	end
	print(master_name," mastername")
	local roomno=WhereIsNpc(master_name)
	 if roomno==nil or table.getn(roomno)==0 then
	   print("Ã»ÓĞÕÒµ½Ê¦¸¸ËùÔÚµØ!!ÇëÊÖ¶¯ÉèÖÃ!")

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
	   if master_name=="ÒóÌìÕı" then
	    short_id="tianzheng"
	   end
	   print("Ê¦¸¸id:",short_id)
	   world.SetVariable("masterid",short_id)
	   local sleeproomno=0
	   if string.find(party,"Îäµ±") then
	      if gender=="ÄĞĞÔ" then
		    sleeproomno=2790
		  else
		    sleeproomno=3175
		  end
	   elseif string.find(party,"ÉÙÁÖ") then
	      sleeproomno=877
	   elseif string.find(party,"»ªÉ½") then
		  if gender=="ÄĞĞÔ" then
		    sleeproomno=1524
		  else
		    sleeproomno=3174
		  end
		elseif string.find(party,"¶ëáÒ") then
		   sleeproomno=653
		elseif string.find(party,"È«Õæ") then
		   sleeproomno=4166
		elseif string.find(party,"åĞÒ£") then
		   sleeproomno=4242
		elseif string.find(party,"¹ÅÄ¹") then
		   sleeproomno=3016
		elseif string.find(party,"ÁéğÕ¹¬") then
		   sleeproomno=2339
		elseif string.find(party,"ĞÇËŞÅÉ") then
		   sleeproomno=3110
		 elseif string.find(party,"ÈÕÔÂÉñ½Ì") then
		   sleeproomno=142
		 elseif string.find(party,"À¥ÂØÅÉ") then
		   sleeproomno=3023
	    elseif string.find(party,"Ã÷½Ì") then
		   sleeproomno=2248
		 elseif string.find(party,"ÉñÁúµº") then
		   sleeproomno=1800
		 elseif string.find(party,"´óÀí") then
		   sleeproomno=484
		 elseif string.find(party,"ÌìÁúËÂ") then
		   local title=world.GetVariable("title") or ""
		   if string.find(title,"Éñ  É®") then
		      sleeproomno=3890
		   else
		      sleeproomno=484
		   end
	    elseif string.find(party,"ÌúÕÆ") then
		  if gender=="ÄĞĞÔ" then
		    sleeproomno=2418
		  else
		    sleeproomno=4989
		  end
		elseif string.find(party,"áÔÉ½") then
		  if gender=="ÄĞĞÔ" then
		    sleeproomno=308
		  else
		    sleeproomno=3154
		  end
		elseif string.find(party,"Ä½Èİ") then
		  if master_name=="Ä½Èİ²©" then
		    sleeproomno=877
		  elseif master_name=="ÄªÈİ¸´" then
		   sleeproomno=2003
		  elseif master_name=="Íõ·òÈË" then
		    sleeproomno=2186
		  end
		elseif string.find(party,"ÌÒ»¨µº") then
		  if master_name=="»ÆÒ©Ê¦" then
		    sleeproomno=2815
		  elseif gender=="ÄĞĞÔ" then
		   sleeproomno=2785
		  else
		    sleeproomno=3146
		  end
		elseif string.find(party,"´óÂÖËÂ") then
		  if master_name=="½ğÂÖ·¨Íõ" then
		    sleeproomno=2072
		  elseif gender=="ÄĞĞÔ" then
		   sleeproomno=2273
		  else
		    sleeproomno=2712
		  end
		--´óÂÖËÂ 2711 Å®ĞÔ 2272 ÄĞĞÔ ´ó²İÔ­ ¹şÈø¿ËÕÊÅñ 2072 2075
       elseif string.find(party,"Ø¤°ï") then
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
			 master_setting="0 Ñ§Ï°×Ô¶¯ÉèÖÃ(Ê¦¸¸Ë¯·¿)",
	         fish="1 µöÓã",
		     readbook="2 ¶ÁÊé¼®",
		    xiulian1="3 ĞŞÁ¶ÄÚÁ¦",
		    xiulian2="4 ĞŞÁ¶¾«Á¦",
			 fullskills="5 full¼¼ÄÜ",
			 quest="6 ½âÃÕ",
			 canwu="7 Å£ĞÄÊ¯²ÎÎòÄÚÁ¦(ÒªÇó100m)",
			 gumu="8 ¹ÅÄ¹Ò»¼üfull",
			  haichao="9 ¹ÅÄ¹ÆÙ²¼Á·º£³±½£·¨",
			  dzxy="10 ²ÎÎò¶·×ªĞÇÒÆ 51~201",
			  gancao="11 ¶Ñ¸É²İÁ·»ù±¾¼¼ÄÜ(×Ô¼ºwield ÎäÆ÷)",
	      }
	      local _select=utils.listbox ("¸¨Öú¹¦ÄÜ:", "ÉèÖÃ¾«Áé", selectItem)
		    if _select=="fish" then
			  package.loaded["fish"]=nil
			  require "fish"
			   fish:go()
			elseif _select=="readbook" then
			   	 local cmd=utils.inputbox("¶ÁÊéÖ´ĞĞµÄÃüÁîÀıÈçread medicine book", "ÉèÖÃ¾«Áé", "read medicine book", "ËÎÌå", 9) or "read medicine book"
	            local f=function(r)
		             local readroomno=r[1]
					 print(readroomno)
					 local sleeproomno=world.GetVariable("sleeproomno") or 126
					 sleeproomno=tonumber(sleeproomno)
					 process.readbook(cmd,nil,readroomno,sleeproomno)
				end
	            WhereAmI(f,10000) --ÅÅ³ı³ö¿Ú±ä»¯
			elseif _select=="xiulian1" then
			   world.Send("unset »ıĞî")
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
			    local master_name=utils.inputbox("Ê¦¸¸µÄÖĞÎÄÃû×Ö", "ÉèÖÃ¾«Áé", master_name, "ËÎÌå", 9) or master_name
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
			     learn="Ñ§Ï°Ê¦¸¸",
				 lingwu="ÁìÎò",
				 literate="¶ÁÊéĞ´×Ö",
				 chenggao="³É¸ß",
				 jyzj="¶Á¾ÅÒõÏÂÈËÆ¤",
			   }

	          local pots=utils.inputbox("ĞèÒªÇ±ÄÜÒøĞĞÈ¡¶àÉÙpots", "ÉèÖÃ¾«Áé", "10000", "ËÎÌå", 9) or "10000"
			  local  _select_up=utils.listbox ("·½Ê½Ñ¡Ôñ:", "ÉèÖÃ¾«Áé", select_up)
		      if _select_up=="learn" then
		        local f=function()
			 	   world.Send("unset skilllimit")
				   local f=function()
				      world.Send("Ñ§Ï°½áÊø")
					   print (utils.msgbox ("Ñ§Ï°½áÊø", "Warning!", "ok", "!", 1)) --> ok
				   end
		           Go_learn(f)
				end
				pots_bank(pots,f)
		      elseif _select_up=="lingwu" then
		        local f=function()
				    world.Send("unset skilllimit")
					local f2=function()
					   world.Send("ÁìÎò½áÊø")
					   print (utils.msgbox ("ÁìÎò½ÓÊÕ", "Warning!", "ok", "!", 1)) --> ok
					end
			       process.lingwu(f2,false)
			     end
			     pots_bank(pots,f)
		      elseif _select_up=="literate" then
		         local f=function()
					local f2=function()
				      world.Send("Ñ§Ï°½áÊø")
					   print (utils.msgbox ("Ñ§Ï°½áÊø", "Warning!", "ok", "!", 1)) --> ok
				    end
			       learn_literate(f2)
			     end
			     pots_bank(pots,f)
		      elseif _select_up=="chenggao" then
		         local f=function()
				    local f2=function()
				      world.Send("Ñ§Ï°½áÊø")
					   print (utils.msgbox ("Ñ§Ï°½áÊø", "Warning!", "ok", "!", 1)) --> ok
				   end
			       chenggao_learn(f2)
			     end
			     pots_bank(pots,f)
		      elseif _select_up=="jyzj" then
			     local f=function()
				    local f2=function()
				      world.Send("Ñ§Ï°½áÊø")
					   print (utils.msgbox ("Ñ§Ï°½áÊø", "Warning!", "ok", "!", 1)) --> ok
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

	WindowText (help_win, FONT_NAME, "ÉèÖÃ",
					7, top, 0, 0,
					ColourNameToRGB ("yellow"), false)

	WindowText (help_win, FONT_NAME, "Í£Ö¹",
					47, top, 0, 0,
					ColourNameToRGB ("yellow"), false)
	WindowText (help_win, FONT_NAME, "¶¨Î»",
				    87, top, 0, 0,
					ColourNameToRGB ("yellow"), false)
	WindowText (help_win, FONT_NAME, "Ä£Ê½",
				    127, top, 0, 0,
					ColourNameToRGB ("yellow"), false)

    WindowText (help_win, FONT_NAME, "Æô¶¯",
				    167, top, 0, 0,
					ColourNameToRGB ("yellow"), false)

	WindowText (help_win, FONT_NAME, "¹¦ÄÜ",
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
                   "ÉèÖÃ",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags

   WindowAddHotspot(help_win, "stop_hotspot",
                    50,  0, 75, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown1",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "Í£Ö¹»úÆ÷ÈË",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags
    WindowAddHotspot(help_win, "mapHere_hotspot",
                    90,  0, 115, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown2",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "µ±Ç°·¿¼äºÅ",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags
	 WindowAddHotspot(help_win, "hand_hotspot",
                    130,  0, 155, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown3",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "Ä£Ê½ÇĞ»»",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags
	WindowAddHotspot(help_win, "startjob_hotspot",
                    170,  0, 195, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown4",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "Æô¶¯JOB",  -- tooltip text
                   cursor or 1, -- cursor
                   0)  -- flags
	WindowAddHotspot(help_win, "gongneng_hotspot",
                    210,  0, 235, 25,   -- rectangle
                   "",   -- MouseOver
                   "",   -- CancelMouseOver
                   "at_mousedown5",  -- MouseDown
                   "",   -- CancelMouseDown
                   "",   -- MouseUp
                   "¸¨Öú¹¦ÄÜ",  -- tooltip text
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

	WindowText (stop_win, FONT_NAME, "Í£Ö¹",
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
                   "Í£Ö¹»úÆ÷ÈË",  -- tooltip text
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
  --µÚÒ»²½ jobs
  --Ñ§Ï° ÁìÎò Á· ¼¼ÄÜÁĞ±í Ê¦¸µ ĞİÏ¢·¿¼ä
  --Õ½¶· pfm unarmed_pfm
  --×°±¸ i_equip ÉèÖÃ
  --self:support_job()
  --print("¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù¡ù")

   wizard_end=function()

	teach_skill={}
    local teach_skills=world.GetVariable("teach_skills")
    if teach_skills==nil or teach_skills=="" then
      print("teach_skills±äÁ¿Ã»ÓĞÉèÖÃ!!")
    else
     local _skills=Split(teach_skills,"|")
     for _,ts in ipairs(_skills) do
       table.insert(teach_skill,ts)
     end
    end
    run_vip=world.GetVariable("VIP")
    if run_vip=="¹ó±öÍæ¼Ò" then
     run_vip=true
    else
     run_vip=false
    end
	 --
	 --print("ÅäÖÃÄÚÈİ¼ì²é")

	 --jobslist ¸ñÊ½¼ìÑé
	 --get_jobslist
	 --sp_exert ¸ñÊ½¼ìÑé

	 --i_equip
	 --filename = utils.filepicker (title, name, extension, filter, save)
	 --±à¼­Ä¬ÈÏÄ£°å
	 --Ñ¡ÔñÉèÖÃÄÚÈİ£¡
     --self:select_settings()
   end
   auto_variable()
end

----2016-11-23¸üĞÂ ĞÂÔö xmlÅäÖÃÎÄ¼şµ¼Èëµ¼³ö¹¦ÄÜ
-- show all variables and their values
function wizard:import_xml()
for k, v in pairs (GetVariableList()) do
  Note (k, " = ", v)
end
Note (ExportXML (4, "gb_pfm"))
end
