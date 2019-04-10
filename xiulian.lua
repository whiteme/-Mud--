require "hp"
 local dazuo_start_regexp="(> |)你至少需要\(.*\)点的气来打坐！$|^(> |)你现在精不够，无法控制内息的流动！$|^(> |)这里不准战斗，也不准打坐。$|^(> |)卧室不能打坐，会影响别人休息。$|^(> |)你无法静下心来修炼。$|^(> |)这里可不是让你提高内力的地方。$|^(> |)你刚施用过内功，不能马上打坐。$|^(> |)战斗中不能练内功，会走火入魔。$|^(> |)此地不宜修练！$"


		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你手捏剑诀，将寒冰真气提起在体内慢慢转动。$" --ss 1
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你随意一站，双手缓缓抬起，深吸一口气，真气开始在体内运转。$" --mr 2
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你气运丹田，将体内毒素慢慢逼出，控制着它环绕你缓缓飘动。你感觉到内劲开始有所加强了。$" --xx 3
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你慢慢盘膝而坐，双手摆于胸前，体内一股暖流随经脉缓缓流转。$" --szj 4
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘腿坐下，双目微闭，双手掌心相向成虚握太极，天人合一，练气入虚。$" --thd 5 21 同9y
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你收敛心神闭目打坐，手搭气诀，调匀呼吸，感受天地之深邃，自然之精华，渐入无我境界。" --dls 6
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你抉弃杂念盘膝坐定，手捏气诀，脑中一片空明，渐入无我境界，一道炽热的内息在任督二脉之间游走。$" --dls 6
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你席地而坐，五心向天，脸上红光时隐时现，内息顺经脉缓缓流动。$" --emei 7
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你随意坐下，双手平放在双膝，默念口诀，开始运起独门心法。$" --gb 8
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你轻轻的吸一口气，闭上眼睛，运起玉女心经，内息在脉络中开始运转。$" --gumu 9
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你坐下来运气用功，一股内息开始在体内流动。$" --hama 10
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你屏息静气，坐了下来，左手搭在右手之上，在胸前捏了个剑诀，引导内息游走各处经脉。$" --huashan 11
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你运起玄天无极神功，气聚丹田，一股真气在四肢百脉中流动。$" --kunlun 12
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝而坐，双手垂于胸前成火焰状，深吸口气，让经络中的真气化做一股灼流缓缓涌入丹田。$" --mj 13
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝而坐，运使九阳，气向下沉，由两肩收入脊骨，注于腰间，进入人我两忘之境界。$" --mj  14
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你五心向天，排除一切杂念，内息顺经脉缓缓流动。$" --shaolin 15
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝坐下，双手合十置于头顶，潜运内力，一团黑气渐渐将你包围了起来，双眼冒出一丝绿光。$"  --shenlong 16
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝坐下，垂目合什，默运枯荣禅功，只觉冷热两股真气开始在体内缓缓游动。$" --tls 17
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝坐下，闭目合什，运起乾天一阳神功，一股纯阳真气开始在体内运转。$" --dali1 18
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝坐下，暗运内力，试图采取天地之精华，只觉得四周暗潮渐生，天地顿合，四周白茫茫一片。$" --tz 19
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝而坐，双目紧闭，深深吸一口气引入丹田，慢慢让一股内息在周身大穴流动，渐入忘我之境。$" --wd 20
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝而坐，双目紧闭，深深吸一口气引入丹田，将北冥真气引入周身大穴流动。$" --bm 21
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你凝神静气，盘坐下来，运一口内家真气游走全身。$" --hs2 22
          dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝而坐，运起八荒六合唯我独尊功，丹田真气升腾而起，开始打坐。$"  --ljg
          dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你随意坐下，双手平放在双膝，默念口诀，开始运起吸星大法。$" --xxdf
		  dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝而坐，形神合一，暗运「冷泉神功」，将冷泉内劲游走全身经络。$" --lq
		  dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你手捏绣花针，盘膝坐下，默运葵花神功，只觉冷热两股紫气开始在体内缓缓游动。$" --khbd
		  dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你盘膝坐下，默运天魔大法，顿时脸上红光时隐时现，内息顺经脉缓缓流动。"--tmg
              dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你还是先洗澡吧。$"
        dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你运起纯阳神通功，片刻之间，白气笼罩全身，双眼精光四射，身手分外矫健，进退神速，与平时判若两人。$"
		dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你必须先用 enable 选择你要用的特殊内功。$"
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)你现在手脚戴着镣铐，不能做出正确的姿势来打坐。$"
 local dazuo_end_regexp="^(> |)你感到自己和天地融为一体，全身清爽如浴春风，忍不住舒畅的呻吟了一声，缓缓睁开了眼睛。$" --dls
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你只觉神元归一，全身精力弥漫，无以复加，忍不住长啸一声，徐徐站了起来。$" --dls
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将内息走了个小周天，流回丹田，收功站了起来。$"  --emei
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你吸气入丹田，真气运转渐缓，慢慢收功，双手抬起，站了起来。$" --gaibang
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你慢慢收气，归入丹田，睁开眼睛，轻轻的吐了一口气。$" --gumu
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你运功完毕，站了起来。$" --hama
                 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将内息走满一个周天，只感到全身通泰，丹田中暖烘烘的，双手一分，缓缓站了起来。$" --huashan
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将内息又运了一个小周天，缓缓导入丹田，双臂一震，站了起来。$"  --jiuyin
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)过了片刻，你感觉自己已经将玄天无极神功气聚丹田，深吸口气站了起来。$"   --kl
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将周身内息贯通经脉，缓缓睁开眼睛，站了起来。$"   --mj1
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你呼翕九阳，抱一含元，缓缓睁开双眼，只觉得全身真气流动，体内阳气已然充旺之极。$"   --mj2
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将真气在体内沿脉络运行了一圈，缓缓纳入丹田，放下手，长吐了一口气。$"   --mr
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将内息走了个小周天，流回丹田，收功站了起来。$"   --shaolin
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你分开双手，黑气慢慢沉下，眼中的绿光也渐渐暗淡下来。$"   --shenlongdao
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将寒冰真气按周天之势搬运了一周，感觉精神充沛多了。$"   --ss
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你一个周天行将下来，精神抖擞的站了起来。$"   --szj
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将内息又运了一个小周天，缓缓导入丹田，双臂一震，站了起来。$"   --thd
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你真气在体内运行了一个周天，冷热真气收于丹田，慢慢抬起了眼睛。$"   --tls
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你真气在体内运行了一个周天，缓缓收气于丹田，慢慢睁开了眼睛。$"   --tls2
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你双眼微闭，缓缓将天地精华之气吸入体内,见天地恢复清明，收功站了起来。$"   --tz
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将内息在体内运行十二周天，返回丹田，只觉得全身暖洋洋的。$"   --wd
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你感觉毒素越转越快，就快要脱离你的控制了！你连忙收回毒素和内息，冷笑一声站了起来。$" --xx
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你的内力修为已经达到圆满之境。$" --full
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你把正在运行的真气强行压回丹田，站了起来。$" --thd halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你感到烦躁难耐，只得懈了内息，轻吁口气，身上涔涔透出层冷汗。$" --xs male halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你眉头一皱，急速运气，把手放了下来。$" --mr halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你双眼一睁，极速压下内息站了起来。$" --ss halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你内息一转，迅速收气，停止了内息的运转。$" --gumu halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你心神一动，将内息压回丹田，双臂一振站了起来。$"--hs halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你匆匆将内息退了回去，吸一口气缓缓站了起来。$" --kl halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你周身微微颤动，长出口气，站了起来。$" --mj halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你双眼一睁，眼中射出一道精光，接着阴阴一笑，站了起来。$" --xx halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你双眼缓缓闭合，片刻猛地睁开，两道绿光急射而出。$" --sld halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你长出一口气，将内息急速退了回去，站了起来。$" --sl halt
                 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你微一簇眉，将内息压回丹田，长出一口气，站了起来。$" --wd halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将纯阳神通功运行完毕，除却白气笼罩，双眼精光四射，缓缓站了起来。$"
				 	 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将北冥真气在体内运行十二周天，返回丹田，只觉得全身通泰的。$"
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你双眼微闭，缓缓将天地精华之气吸入体内,见天地恢复清明，收功站了起来。$" --tz
					 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将内息走了个一个周天，将满脸红光退去，收功站了起来。$"--tmg
                 	  dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你长出一口气，将内息急速退了回去，站了起来。$" --tmg halt
					  dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将内息游走全身，但觉全身舒畅，内力充沛无比。$"
					  	  dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你忽然强运一口真气，双眼一睁，缓缓站了起来。$"
                     dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你只觉真力运转顺畅，周身气力充沛，气沉丹田，站起身来。$"  --ljg
                     dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将真气逼入体内，将全身聚集的蓝色气息散去，站了起来。$" --xxdf
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你面色一沉，迅速收气，站了起来。$"
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你忽然双眼一睁，一声长啸，将运转全身的「冷泉内劲」散去，随即站了起来。$" --lq halt
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你已将「冷泉内劲」游走全身经脉诸穴，只觉精神充沛，内劲充足无比！$" --lq
                    dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你将紫气在体内运行了一个周天，冷热紫气收于丹田，慢慢抬起了眼睛。$" --khbd
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你猛的睁开双眼，双手迅速回复体侧，仔细打量四周。$" --ss neigong halt
		            dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你把正在运行的真气强行压回丹田，站了起来。$" --thd neigong halt
		            dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你眉头一皱，急速运气，把手放了下来。$" --mr neigong halt
		            dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你双眼一睁，极速压下内息站了起来。$" --szj neigong halt
					 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)你放下绣花针，两股真气迅速交汇消融。$" --khbd neigong halt





xiulian={
   new=function()
     local x={}
	 x.hp={}
	 setmetatable(x,xiulian)
	 return x
   end,
   min_amount=10,
   safe_qi=10,
   safe_jingxue=10,
   limit=false,
   co=nil,
   halt=false,
   xiulian_failure=function(id)
	   world.EnableGroup("xiulian",false)
       coroutine.resume(xiulian.co,false,id)
   end,
   xiulian_success=function()
       world.EnableGroup("xiulian",false)
       coroutine.resume(xiulian.co,true)
   end,
   hp={},--hp对象
}
xiulian.__index=xiulian
function xiulian:fail(id)  --回调函数

end

function xiulian:success() --回调函数

end

function xiulian:danger()
   local f=function()
     self:dazuo()
   end
   f_wait(f,3)
end

function xiulian:clear()
  for k, v in pairs (GetTriggerList()) do
    --Note (v)
	local line=GetTriggerInfo(v, 1)
	if line==dazuo_end_regexp then
	   world.DeleteTrigger(v)
	   return
	end
  end
end

--> 战斗中不能练内功，会走火入魔。
function xiulian:dazuo()
     if self.halt==true then
	    return
	 end
   local h
   h=hp.new()
   self.hp=h
   h.checkover=function()
     --print("打坐1")
	 if h.max_neili>=1000 and h.qi_percent>=100 and self.min_amount==10 then
	    self.min_amount=math.modf (h.max_qi/5)
	 end
     if h.qi>self.safe_qi+self.min_amount or h.max_qi<=self.safe_qi+self.min_amount then
	     local qi
		 qi=h.qi-self.safe_qi
		 --print(qi," qi1")
		 --dazuo_trigger()
		 --

		 if self.limit==true then --不增加最大内力
             world.Send("set 积蓄")
			 if qi>(h.max_neili*2-h.neili-1) then
		       qi=h.max_neili*2-h.neili-1
			   --modified by 2011-9-13 防止打坐太大
			   if qi>self.min_amount*2 then
			     qi=self.min_amount
			   end
			 else
			    qi=self.min_amount
		     end
			 if qi<self.min_amount then  --太小
			    qi=self.min_amount
			 end
		 else
		    -- world.Send("unset 积蓄")
			 if qi>(h.max_neili*2-h.neili) then
		       qi=h.max_neili*2-h.neili
			    --modified by 2011-9-13 防止打坐太大
				--print(qi," 值")
			   if qi>self.min_amount*2 then
			     qi=self.min_amount
			   end
			 else
                 qi=self.min_amount
		     end
		     if qi<self.min_amount then
		         qi=self.min_amount
		     end
		 end
		 wait.make(function()
		       world.Send("dazuo "..qi)
			   --print("dazuo")
			   --print(dazuo_start_regexp)
			   local l,w=wait.regexp(dazuo_start_regexp,30)
			   if l==nil then
			      print("超时3")
				  self:dazuo()
			      return
			   end
			   if string.find(l,"战斗中不能练内功，会走火入魔") then
			       local f=function()
				      self:dazuo()
				   end
			       safe_room(f)
				   return
			   end
			   if string.find(l,"你现在精不够，无法控制内息的流动") then
			      self.fail(201)
				  return
			   end
			   if string.find(l,"此地不宜修练") or string.find(l,"这里不准战斗，也不准打坐")  or string.find(l,"卧室不能打坐，会影响别人休息") or string.find(l,"你无法静下心来修炼") or string.find(l,"这里可不是让你提高内力的地方") then
			      self.fail(202)
				  return
			   end
				if string.find(l,"默运天魔大法") or string.find(l,"默运葵花神功") or string.find(l,"冷泉神功") or string.find(l,"八荒六合唯我独尊功") or string.find(l,"深深吸一口气引入丹田，慢慢让一股内息在周身大穴流动") or string.find(l,"暗运内力，试图采取天地之精华") or string.find(l,"运起乾天一阳神功") or string.find(l,"默运枯荣禅功") or string.find(l,"双手合十置于头顶，潜运内力") or string.find(l,"五心向天，排除一切杂念") or string.find(l,"运使九阳，气向下沉，由两肩收入脊骨") or string.find(l,"双手垂于胸前成火焰状，深吸口气") or string.find(l,"玄天无极神功，气聚丹田") or string.find(l,"在胸前捏了个剑诀") or string.find(l,"你坐下来运气用功") or string.find(l,"运起玉女心经，内息在脉络中开始运转") or string.find(l,"你随意坐下，双手平放在双膝") or string.find(l,"你席地而坐") or string.find(l,"你抉弃杂念盘膝坐定") or string.find(l,"你收敛心神闭目打坐") or string.find(l,"双手摆于胸前，体内一股暖流随经脉缓缓流转") or string.find(l,"你手捏剑诀") or string.find(l,"你随意一站，双手缓缓抬起") or string.find(l,"将体内毒素慢慢逼出，控制着它环绕你缓缓飘动") or string.find(l,"天人合一，练气入虚") or string.find(l,"自然之精华，渐入无我境界") or string.find(l,"一道炽热的内息在任督二脉之间游走") or string.find(l,"你盘膝而坐") or string.find(l,"你凝神静气") or string.find(l,"运起纯阳神通功") or string.find(l,"开始运起吸星大法") then

				wait.make(function()
				 print("开始打坐")
				 --print(dazuo_end_regexp)

		         local l,w=wait.regexp(dazuo_end_regexp,60)
			     if l==nil then
					 print("超时2")
					 self:dazuo()
					 return
			     end
			     if string.find(l,"收功站了起来") or string.find(l,"将满脸红光退去") or string.find(l,"冷热紫气收于丹田") or string.find(l,"内劲充足无比") or string.find(l,"全身清爽如浴春风") or string.find(l,"站起身来") or string.find(l,"达到圆满之境") or string.find(l,"冷笑一声站了起来") or string.find(l,"缓缓睁开了眼睛") or string.find(l,"徐徐站了起来") or string.find(l,"收功站了起来") or string.find(l,"轻轻的吐了一口气") or string.find(l,"你运功完毕，站了起来") or string.find(l,"缓缓站了起来") or string.find(l,"双臂一震，站了起来") or string.find(l,"你呼翕九阳，抱一含元") or string.find(l,"真气在体内沿脉络运行了一圈") or string.find(l,"流回丹田，收功站了起来") or string.find(l,"眼中的绿光也渐渐暗淡下来") or string.find(l,"寒冰真气按周天之势搬运了一周") or string.find(l,"精神抖擞的站了起来") or string.find(l,"双臂一震，站了起来") or string.find(l,"冷热真气收于丹田，慢慢抬起了眼睛") or string.find(l,"缓缓收气于丹田，慢慢睁开了眼睛") or string.find(l,"见天地恢复清明，收功站了起来") or string.find(l,"体内运行十二周天，返回丹田") or string.find(l,"你吸气入丹田") or string.find(l,"你感觉自己已经将玄天无极神功气聚丹田") or string.find(l,"缓缓睁开眼睛，站了起来") or string.find(l,"只觉得全身通泰的") or string.find(l,"你将内息游走全身") or string.find(l,"将全身聚集的蓝色气息散去") then
                       --print("end")
				       local h1=hp.new()
			           h1.checkover=function()
			             self.success(h1)
			           end
			           h1:check()  --成功继续
					   return
			     end
				 if string.find(l,"将内息急速退了回去") or string.find(l,"两股真气迅速交汇消融") or string.find(l,"随即站了起来") or string.find(l,"忽然强运一口真气") or string.find(l,"你微一簇眉，将内息压回丹田") or string.find(l,"你长出一口气，将内息急速退了回去") or string.find(l,"你周身微微颤动，长出口气") or string.find(l,"你心神一动，将内息压回丹田") or string.find(l,"你匆匆将内息退了回去") or string.find(l,"你内息一转，迅速收气") or string.find(l,"你把正在运行的真气强行压回丹田，站了起来") or string.find(l,"你感到烦躁难耐") or string.find(l,"你眉头一皱") or string.find(l,"你双眼一睁，极速压下内息站了起来") or string.find(l,"你双眼一睁，眼中射出一道精光") or string.find(l,"你双眼缓缓闭合，片刻猛地睁开") or string.find(l,"你双眼一睁，极速压下内息站了起来") or string.find(l,"你猛的睁开双眼，双手迅速回复体侧，仔细打量四周") or string.find(l,"你眉头一皱，急速运气，把手放了下来") then
				    --halt
					print("打坐强制中断")
					local f=function() self:dazuo() end
					f_wait(f,20)
					return
				 end
	             end)
				  return
			   end
			   if string.find(l,"你现在手脚戴着镣铐，不能做出正确的姿势来打坐") then
			     print("挑水")
				 local ts=tiaoshui.new()
				 ts.jobDone=function()
				    self:dazuo()
				 end
				 ts:ask_job()
				 return
			   end
			   --if string.find(l,"你双眼一睁，极速压下内息站了起来") or string.find(l,"你猛的睁开双眼，双手迅速回复体侧，仔细打量四周") or string.find(l,"你眉头一皱，急速运气，把手放了下来") then
			      --self.fail(205)
				--  return
			   --end
			   if string.find(l,"选择你要用的特殊内功")  then
			      local shield=world.GetVariable("shield") or ""
				  world.Execute(shield)
			      world.Send("jifa all")
			      self:dazuo()
			      return
			   end
				if string.find(l,"你至少需要") then
				  --print("t",w[2])
				  self.min_amount=ChineseNum(w[2])
				  --print(self.min_amount,"至少")
			      self:dazuo()
			      return
			   end
			   if string.find(l,"你刚施用过内功") then
			     local f=function()
			      self:dazuo()
				 end
				 f_wait(f,0.8)
			   end
			  if string.find(l,"你还是先洗澡吧") then
			    world.Execute("e;w;wear all")
				  local f=function()
			      self:dazuo()
				 end
				 f_wait(f,0.8)
			    return
			  end
		  end)
	 else
	   if h.qi_percent<100 then
	      print("打坐时候受伤,恢复伤势")
		  self.fail(777)
	   else
          print("没有足够气血")
		 --world.Send("yun qi")
          self.fail(1)  --没有足够气血
	   end
	 end
   end
   h:check()
end

function xiulian:dazuo2(h)
     self.hp=h
     if h.max_neili>=1000 and h.qi_percent>=100 and self.min_amount==10 then
	    self.min_amount=math.modf (h.max_qi/5)
	 end
     if self.halt==true then
	    return
	 end
	 if h.qi>self.safe_qi+self.min_amount or h.max_qi<=self.safe_qi+self.min_amount then
		local qi
		qi=h.qi-self.safe_qi
		--dazuo_trigger()
		 --
		if self.limit==true then --不增加最大内力
		    world.Send("set 积蓄")
		     if qi>(h.max_neili*2-h.neili-1) then
		       qi=h.max_neili*2-h.neili-1
			   if qi>self.min_amount*2 then
			     qi=self.min_amount
			   end
			 else
  			    qi=self.min_amount
		     end
			 if qi<self.min_amount then  --太小

			   qi=self.min_amount
			 end
		else
		     --world.Send("unset 积蓄")
			 if qi>(h.max_neili*2-h.neili) then
		       qi=h.max_neili*2-h.neili
			   --print(qi," 值")
			    if qi>self.min_amount*2 then
			     qi=self.min_amount
			   end
			 else
			    qi=self.min_amount
		     end
		     if qi<self.min_amount then

		        qi=self.min_amount
		     end
		end

		 wait.make(function()
		       world.Send("dazuo "..qi)
			    print("dazuo2")
			   local l,w=wait.regexp(dazuo_start_regexp,30)
			   if l==nil then
			      print("超时2")
				  self:dazuo()
			      return
			   end
			   if string.find(l,"你现在精不够，无法控制内息的流动") then
			      self.fail(201)
				  return
			   end
			   if string.find(l,"这里不准战斗，也不准打坐")  or string.find(l,"卧室不能打坐，会影响别人休息") or string.find(l,"你无法静下心来修炼") then
			      self.fail(202)
				  return
			   end
			  if string.find(l,"你现在手脚戴着镣铐，不能做出正确的姿势来打坐") then
			     print("挑水")
				 local ts=tiaoshui.new()
				 ts.jobDone=function()
				    self:dazuo()
				 end
				 ts:ask_job()
				 return
			   end
               if string.find(l,"默运天魔大法") or string.find(l,"默运葵花神功") or string.find(l,"冷泉神功") or string.find(l,"八荒六合唯我独尊功") or string.find(l,"深深吸一口气引入丹田，慢慢让一股内息在周身大穴流动") or string.find(l,"暗运内力，试图采取天地之精华") or string.find(l,"运起乾天一阳神功") or string.find(l,"默运枯荣禅功") or string.find(l,"双手合十置于头顶，潜运内力") or string.find(l,"五心向天，排除一切杂念") or string.find(l,"运使九阳，气向下沉，由两肩收入脊骨") or string.find(l,"双手垂于胸前成火焰状，深吸口气") or string.find(l,"玄天无极神功，气聚丹田") or string.find(l,"在胸前捏了个剑诀") or string.find(l,"你坐下来运气用功") or string.find(l,"运起玉女心经，内息在脉络中开始运转") or string.find(l,"你随意坐下，双手平放在双膝") or string.find(l,"你席地而坐") or string.find(l,"你抉弃杂念盘膝坐定") or string.find(l,"你收敛心神闭目打坐") or string.find(l,"双手摆于胸前，体内一股暖流随经脉缓缓流转") or string.find(l,"你手捏剑诀") or string.find(l,"你随意一站，双手缓缓抬起") or string.find(l,"将体内毒素慢慢逼出，控制着它环绕你缓缓飘动") or string.find(l,"天人合一，练气入虚") or string.find(l,"自然之精华，渐入无我境界") or string.find(l,"一道炽热的内息在任督二脉之间游走") or string.find(l,"你盘膝而坐") or string.find(l,"你凝神静气") or string.find(l,"运起纯阳神通功") or string.find(l,"开始运起吸星大法") then

				wait.make(function()
		         local l,w=wait.regexp(dazuo_end_regexp,60)

				 if l==nil then
					 print("超时2")
					 self:dazuo()
					 return
			     end
				 if string.find(l,"将满脸红光退去") or string.find(l,"冷热紫气收于丹田") or string.find(l,"内劲充足无比") or string.find(l,"全身清爽如浴春风") or string.find(l,"站起身来") or string.find(l,"达到圆满之境") or string.find(l,"冷笑一声站了起来") or string.find(l,"缓缓睁开了眼睛") or string.find(l,"徐徐站了起来") or string.find(l,"收功站了起来") or string.find(l,"轻轻的吐了一口气") or string.find(l,"你运功完毕，站了起来") or string.find(l,"缓缓站了起来") or string.find(l,"双臂一震，站了起来") or string.find(l,"你呼翕九阳，抱一含元") or string.find(l,"真气在体内沿脉络运行了一圈") or string.find(l,"流回丹田，收功站了起来") or string.find(l,"眼中的绿光也渐渐暗淡下来") or string.find(l,"寒冰真气按周天之势搬运了一周") or string.find(l,"精神抖擞的站了起来") or string.find(l,"双臂一震，站了起来") or string.find(l,"冷热真气收于丹田，慢慢抬起了眼睛") or string.find(l,"缓缓收气于丹田，慢慢睁开了眼睛") or string.find(l,"见天地恢复清明，收功站了起来") or string.find(l,"体内运行十二周天，返回丹田") or string.find(l,"你吸气入丹田") or string.find(l,"你感觉自己已经将玄天无极神功气聚丹田") or string.find(l,"缓缓睁开眼睛，站了起来") or string.find(l,"只觉得全身通泰的") or string.find(l,"你将内息游走全身") or string.find(l,"将全身聚集的蓝色气息散去") then
                       --print("end")
				       local h1=hp.new()
			           h1.checkover=function()
			             self.success(h1)
			           end
			           h1:check()  --成功继续
					   return
			     end
	             end)
				  return
			   end
			   --[[if string.find(l,"你双眼一睁，极速压下内息站了起来") or string.find(l,"你猛的睁开双眼，双手迅速回复体侧，仔细打量四周") then
			      self.fail(205)
				  return
			   end]]
			    if string.find(l,"选择你要用的特殊内功") then
			      world.Send("jifa all")
			      self:dazuo()
			      return
			   end
				if string.find(l,"你至少需要") then
				  --print("t",w[2])
				  self.min_amount=ChineseNum(w[2])
			      self:dazuo()
			      return
			   end
			    if string.find(l,"你刚施用过内功") then
			     local f=function()
			      self:dazuo()
				 end
				 f_wait(f,0.8)
			   end
			   if string.find(l,"你还是先洗澡吧") then
			    world.Execute("e;w;wear all")
				  local f=function()
			      self:dazuo()
				 end
				 f_wait(f,0.8)
			    return
			  end

		  end)

	 else
        print("没有足够气血")
        self.fail(1)  --没有足够气血
	 end
end

function xiulian:tuna()
    if self.halt==true then
	    return
	 end
   local h
   h=hp.new()
   self.hp=h
   h.checkover=function()
     if h.jingxue>self.safe_jingxue then
	     local jingxue

		 jingxue=h.jingxue-self.safe_jingxue
		 if jingxue>(h.max_jingli*2-h.jingli) then
		    jingxue=h.max_jingli*2-h.jingli
		 end
		 if jingxue<self.min_amount then
		    jingxue=self.min_amount
		 end
		 if jingxue>h.jingxue then
		    jingxue=h.jingxue-self.safe_jingxue
		 end
         --print(h.jingxue," jingxue:",jingxue)
		 wait.make(function()
		   world.Send("tuna "..jingxue)
		    local l,w=wait.regexp("(> |)你闭上眼睛开始吐纳。$|^(> |)你猛吸几口大气，站了起来。$|^(> |)你现在身体状况太差了，无法集中精神！$|^(> |)这里不准战斗，也不准吐纳。$|^(> |)卧室不能吐纳，会影响别人休息。$|^(> |)你无法静下心来修炼。$|^(> |)你现在手脚戴着镣铐，不能做出正确的姿势来吐纳。$",10)
			   if l==nil then
			      print("超时")
				  self:tuna()
			      return
			   end
			   if string.find(l,"你现在身体状况太差了，无法集中精神！") then
			      self.fail(301)
				  return
			   end
			   if string.find(l,"这里不准战斗，也不准吐纳")  or string.find(l,"卧室不能吐纳，会影响别人休息。")  or string.find(l,"你无法静下心来修炼") then
			      self.fail(202)
				  return
			   end
				if string.find(l,"你闭上眼睛开始吐纳。") then
				wait.make(function()
		         local l,w=wait.regexp("^(> |)你吐纳完毕，睁开双眼，站了起来。$",3000)
			     if l==nil then
					 print("超时")
					 self:tuna()
					 return
			     end
			     if string.find(l,"你吐纳完毕，睁开双眼，站了起来。") then
				       h1=hp.new()
			           h1.checkover=function()
			             self.success(h)
			           end
			           h1:check()  --成功继续
					   return
			     end
	             end)
				  return
			   end
			   if string.find(l,"你现在手脚戴着镣铐，不能做出正确的姿势来吐纳") then
				  print("挑水")
				  local ts=tiaoshui.new()
				  ts.jobDone=function()
				    self:tuna()
				  end
				  ts:ask_job()
			      return
			   end
			   if string.find(l,"你猛吸几口大气，站了起来。") then
			      self.fail(305)
				  return
			   end
				if string.find(l,"你至少需要") then
				  --print("t",w[2])
				  self.min_amount=ChineseNum(w[2])
			      self:tuna()
			      return
			   end
			wait.time(10)
		 end)
	 else
        print("没有足够精血")
        self.fail(1)  --没有足够气血
	 end
   end
   h:check()
end


