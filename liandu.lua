
liandu={
  new=function()
     local ld={}
	 setmetatable(ld,{__index=liandu})
	 return ld
   end,
   liandu_time=0,
}
function liandu:liandu_end()
end

function liandu:lianing()
  wait.make(function()
     local l,w=wait.regexp("^(> |)炼毒时需要双手的配合，所以你最好还是不要拿武器。$|^(> |)你刚刚炼毒完成不久，频繁炼毒会有生命危险的！$|^(> |)飘然子说道：「好吧，你来试着练习.*一下毒技吧。」$|猛地，你感觉到一股至阳的毒气顺手臂袭来，竟然透过你的内劲直抵丹田！$|^(> |)这一瞬间，你发觉那至阴的毒气和自己体内原本的毒气相互融合，一同归纳进了气海！$|^(> |)你全身放松，将内息自丹田循任脉引向会阴穴，引导那毒素向气海而去。$|^(> |)你双掌平抬，凌空运气，开始汇聚腐尸于奇经八脉之毒气！$|^(> |)你现在精不够，这样下去会很危险的！$|^(> |)你现在的内力不足，强制炼毒会很危险的。$",10)
	 if l==nil then
	    self:lianing()
	    return
	 end
	 if string.find(l,"所以你最好还是不要拿武器") then
	    local sp=special_item.new()
		sp.cooldown=function()
		   world.Send("liandu")
		   self:lianing()
		end
		sp:unwield_all()
	    return
	 end
	 if string.find(l,"你刚刚炼毒完成不久，频繁炼毒会有生命危险的") or string.find(l,"你现在精不够") or string.find(l,"强制炼毒会很危险的") then
	    self:liandu_end()
	    return
	 end
	 if string.find(l,"你来试着练习") then
	    world.Send("say 洗剥干净开始吃唐僧肉")
	    world.Send("liandu")
		self:lianing()
	    return
	 end
	 if string.find(l,"引导那毒素向气海而去") or string.find(l,"开始汇聚腐尸于奇经八脉之毒气") then
	    world.Send("say 继续不要停！！")
		self:lianing()
		return
	 end
	 if string.find(l,"竟然透过你的内劲直抵丹田") or string.find(l,"一同归纳进了气海") then
		liandu.liandu_time=os.time()
	    self:liandu_end()
	    return
	 end

  end)
end

function liandu:liandu_corpse()
   world.Send("give zi corpse")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你给飘然子一具.*的尸体。$|^(> |)对方不接受这样东西。$|^(> |)你身上没有这样东西。$",3)
	 if l==nil then

	    return
	 end
	 if string.find(l,"对方不接受这样东西") or string.find(l,"你身上没有这样东西") then
	    world.Send("drop corpse")
		self:liandu_end()
	    return
	 end
	 if string.find(l,"你给飘然子") then
	    print("开始炼毒")

	    self:lianing()
	    return
	 end

   end)
end

function liandu:ask_liandu()
    world.Send("ask zi about 炼毒")
    wait.make(function()
     local l,w=wait.regexp("^(> |)飘然子对着你嘿嘿一笑：“想练毒是吧？先去给你自己找具有用的尸体来。”$|^(> |)飘然子说道：「你还在为其他师兄弟们做事呢，等完成了再来我这里吧。」$",3)
	 if l==nil then
	    local _R=Room.new()
         _R.CatchEnd=function()
           if _R.roomname=="山洞" then
		      world.Send("use fire")
			  wait.time(4)
		      world.Send("zuan")
			  wait.time(1)
			  self:ask_liandu()
		   else
			  self:go()
		   end
         end
		 _R:CatchStart()
	    return
	 end
	 if string.find(l,"先去给你自己找具有用的尸体来") then
	    local b=busy.new()
		b.Next=function()
	      self:liandu_corpse()
		end
		b:check()
	    return
	 end
	 if string.find(l,"等完成了再来我这里吧。」") then
		wait.time(3)
	    self:ask_liandu()
	    return
	 end

   end)
end

function liandu:go()
    local w=walk.new()
	 w.walkover=function()
		world.Send("enter cave")
		world.Send("use fire")
		wait.time(4)
		world.Send("zuan")
		wait.time(1)
		self:ask_liandu()

	 end
	 w:go(2234)
end

function liandu:liandu()
   local t1=os.time()
   local int1= os.difftime(t1,liandu.liandu_time)
   print("离上次炼毒时间间隔:",int1)
   if int1<=600 then --十分钟 炼毒
       world.Send("drop corpse")
	   world.Send("drop skeleton")
	  self:liandu_end()
	  return
   end
   	   local sp=special_item.new()
       sp.cooldown=function()
	      print(table.getn(sp.equipment_items))
		  for _,i in ipairs(sp.equipment_items) do
	          --print(i.name,i.id,i.num)
			  if string.find(i.name,"尸体") then
			     self:go()
				 return
			  end
	      end
           self:liandu_end()
       end
       local equip={}
	   equip=Split("<获取>火折|<丢弃>骸骨|<丢弃>腐烂的尸体|<丢弃>腐烂的女尸|<丢弃>腐烂的男尸","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

--[[你开始凝神运气，将化功大法功力满布全身。
> 你将内力聚于三焦，舌根微微上抬，双掌平伸按在腐烂的尸体上。
你急催化功大法，将体内的毒素和功力顺手臂直传到腐烂的尸体上。
腐尸内的毒素开始缓缓聚于一点，并顺着你的手掌向你侵来。
【谣言】某人：澄郎弄到了一颗绿石丹！
你全身放松，将内息自丹田循任脉引向会阴穴，引导那毒素向气海而去。
【闲聊】亢泰(Kang tai)：雨霖玲奸诈险恶，竟然投靠清廷做了鞑子的走狗，大家小心...

你双掌游动，指尖扣住腐尸的肺手太阴之脉。功力起於中焦，下络大肠，还循胃口，横出腋下，
行少阴心主之前，循臂内上骨下廉，入寸口，上鱼，左指劲力循鱼际，出大指之端，右指劲力直
出次指内廉，出其端，复汇于中焦。
【谣言】某人：灭衣弄到了一颗蓝林丸！

腐尸内的毒素越聚越密。你双爪晃过，内力注入其手阳明之脉，起於大指次指之端，循指上廉，
出合谷两骨之间，上入两筋之中，循臂上廉，上肩，上出於柱骨之会上，下入缺盆络肺；其支者，
从上颈贯颊，入下齿中，还出挟口，交人中，左之右，右之左，上挟鼻孔，将内息会引，流向气
海。

【巫师公告】现在是年卡贵宾玩家任务奖励增幅时间 ！

【巫师公告】距离结束时间还剩下 1小时15 分25 秒。
【谣言】某人：有人带着冰魄银针在嘉兴一带出现！

你再将双掌按在腐尸三焦手少阳之脉处，一吐一引，过其阳池，外关，上出两指之间，出臂外两骨
之间，上肩而交出足少阳之後，入缺盆，布膻中，散络心胞；又从膻中上出缺盆，上项，直上出耳
上角，以屈下颊至；又从耳後入耳中，出走耳前，交颊。三路合于一处！
你双掌平抬，凌空运气，开始汇聚腐尸于奇经八脉之毒气！
【谣言】某人：听说本段从宋远桥处获得了一块青铜！
入任脉，起於中极之下，以上毛际，循腹里，上关元，至咽喉，上颐循面，入目络舌！
hp

·精血· 2003 /  2003 (100%)  ·精力· 2652 /  3163(3657)
·气血· 3318 /  3318 (100%)  ·内力·  485 /  3240(+1)
·戾气· 510,765          ·内力上限· 3594 /  4742
·食物·  49.50%              ·潜能·  265 /  316
·饮水·  81.00%              ·经验· 1,002,561 (62.62%)
> 入阳脉者，起于跟中，循外踝，上行入风池！
l
山洞 -
    本来是黑黝黝的山洞里，伸手不见五指。只有一丝微光从洞顶的裂缝透进
来，可以勉强看见正中央有一个石棺，散发着浓厚的腐尸气味，微光下更显得
洞内阴森可怕。一个鬼一般的人影坐在石壁边，两只闪着蓝光的眼睛正盯着你
看，山壁上有人工修缮之处。
    这里没有任何明显的出路。
  神木王鼎(Shenmu wangding)
  石棺(Shi guan)
  星宿派第二代弟子「星宿派五师兄」飘然子(Piaoran zi)
>
use fire
什么？
>> 你现在的内力不足，强制炼毒会很危险的。
use fire
什么？
>
l
山洞 -
    本来是黑黝黝的山洞里，伸手不见五指。只有一丝微光从洞顶的裂缝透进
来，可以勉强看见正中央有一个石棺，散发着浓厚的腐尸气味，微光下更显得
洞内阴森可怕。一个鬼一般的人影坐在石壁边，两只闪着蓝光的眼睛正盯着你
看，山壁上有人工修缮之处。
    这里没有任何明显的出路。
  星宿派第二代弟子「星宿派五师兄」飘然子(Piaoran zi)
  石棺(Shi guan)
  神木王鼎(Shenmu wangding)
>
i
你身上带着十八件东西(负重 34.29%)：
  四锭黄金(Gold)
  二颗大还丹(Dahuan dan)
  三十四两白银(Silver)
  九十九文铜钱(Coin)
□锦虎披风(Jinhu pifeng)
□软底快靴(Ruan xue)
□黄葛布衫(Cloth)
  二张江湖贵宾周卡(Wkcard)
  一双布履(Shoes)
  一柄柳絮云竹杖(Good staff)
  一柄钢刀(Blade)
  一柄骷髅杖(Miegod zhang)
  一支火折(Fire)
  一件布衣(Cloth)
  一柄木剑(Mu jian)
  一颗川贝内息丸(Chuanbei wan)
  一包阴阳合欢散(Hehuan san)
>
use fire
什么？
>
猛地，你感觉到一股至阳的毒气顺手臂袭来，竟然透过你的内劲直抵丹田！
这一瞬间，你发觉那至阳的毒气和自己体内原本的毒气相互融合，一同归纳进了气海！]]
