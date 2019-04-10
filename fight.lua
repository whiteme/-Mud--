require "wait"
require "hp"
require "special_item"
local combat_table = {}
local _id=""
fight={
  new=function()
    _id=""
	for i,v in pairs(combat_table) do
      local thread=combat_table[i]
	  if thread then
		print("战斗清理")
        combat_table[i]=nil
      end
    end
	combat_table = {}
    local cb={}
	 cb.lost_weapon_id={}
	 setmetatable(cb,fight)
	 return cb
  end,
  combat_alias="",
  pfm_list="",  --组合描述列表
  unarmed_alias="",
  current_alias="",
  weapon_id="",
  run_recover=false,
  run_yunjing=false,
  run_refresh=false,
  run_flee=false,
  interval=5,
  lost_weapon_id={},
  is_duo=false,
  auto_perform=false,
  fightcmd="",
  enemy_name="",
  check_co=nil,
  losting_weapon="",
  dazhuan=false,
  check_pfm=true,
  running=false,
  combine_list={},
  version="1.80",
  check_time=15,
  status=nil,
  ratio=100,
  target="",
  hp={},
  pfm_threads={}, --pfm 进程
}
fight.__index=fight
--[[
		// 毒类
		case "7bug_poison"	: name = "七虫软筋散"; break;
		case "bee_poison"	: name = "玉蜂毒"; break;
		case "bing_poison"	: name = "冰魄银针毒"; break;
		case "bt_poison"	: name = "怪蛇毒"; break;
		case "cold_poison"	: name = "寒毒"; break;
		case "fs_poison"	: name = "腐尸毒"; break;
		case "hb_poison"	: name = "寒冰绵掌毒"; break;
		case "huagu_poison"	: name = "化骨绵掌毒"; break;
		case "hot_poison"	: name = "火毒"; break;
		case "lvbo_poison"	: name = "绿波香露奇毒"; break;
		case "man_poison"	: name = "蔓陀萝花毒"; break;
		case "qianli_poison"	: name = "千里销魂散"; break;
		case "qtlh_poi"		: name = "青陀罗花毒"; break;
		case "qzhu_poison"	: name = "千蛛万毒手毒"; break;
		case "sanxiao"		: name = "三笑逍遥散毒"; break;
		case "sl_poison"	: name = "神龙毒"; break;
		case "snake_poison"	: name = "蛇毒"; break;
		case "sxs_poison"	: name = "三笑散之毒"; break;
		case "sy_poison"	: name = "大手印掌毒"; break;
		case "tz_poison"	: name = "铁掌毒"; break;
		case "warm_poison"	: name = "热毒"; break;
		case "xx_poison"	: name = "星宿掌毒"; break;
		case "wh_poison"	: name = "神龙五行毒"; break;

		case "xuanmin_poison"	: name = "玄冥神掌寒毒"; break;
		case "xx_poison"	: name = "星宿掌毒"; break;
		case "wh_poison"	: name = "神龙五行毒"; break;

		// 伤类
		case "broken_arm"	: name = "断手"; break;
		case "dgb_ban_wound"	: name = "打狗棒脚伤"; break;
		case "fugu_poison"	: name = "化血腐骨粉"; break;
		case "dsy_poison"	: name = "大手印内伤"; break;
		case "huagong"		: name = "化功大法内伤"; break;
		case "hunyuan_hurt"	: name = "混元掌内伤"; break;
		case "hyd_condition"    : name = "火焰刀烧伤"; break;
		case "juehu_hurt"	: name = "虎爪绝户手伤"; break;
		case "neishang"		: name = "内伤"; break;
		case "nxsz_hurt"	: name = "凝血神爪内伤"; break;
		case "qiankun_wound"	: name = "弹指神通内伤"; break;
		case "qishang_poison"	: name = "七伤拳内伤"; break;
		case "ruanjin_poison"	: name = "软筋散毒"; break;
		case "yyz_hurt"		: name = "一阳指内伤"; break;
		case "yzc_qiankun"	: name = "一指禅内劲"; break;
		// 忙类
		case "no_exert"		: name = "闭气"; break; 不能切换内功 jifa force
		case "no_perform"	: name = "封招"; break; 不能pfm
		case "no_force"		: name = "气息不匀";break; 不能yun
		//生病类
		case "ill_fashao"	: name = "发烧"; break;
		case "ill_kesou"	: name = "咳嗽"; break;
		case "ill_shanghan"	: name = "伤寒"; break;
		case "ill_zhongshu"	: name = "中暑"; break;
		case "ill_dongshang"	: name = "冻伤"; break;		]]

--战斗心跳 心跳执行频率 0.1
local is_recover=false

function fight:hurt()
   print("hunt:",self.hp.qi_percent)
   print("ratio:",self.ratio)
   local per=self.hp.qi_percent-self.ratio
  if (per>20 or (self.hp.qi_percent<=70 and per>10)) and self.run_recover==false and is_recover==false then
      self.run_recover=true
	  self:recover(true)
	  self:reset()
  end
end

local msg={"看起来气血充盈，并没有受伤。","似乎受了点轻伤，不过光从外表看不大出来。","看起来可能受了点轻伤。","受了几处伤，不过似乎并不碍事。",
"受伤不轻，看起来状况并不太好。","气息粗重，动作开始散乱，看来所受的伤着实不轻。","已经伤痕累累，正在勉力支撑着不倒下去。","受了相当重的伤，只怕会有生命危险。",
"伤重之下已经难以支撑，眼看就要倒在地上。","受伤过重，已经奄奄一息，命在旦夕了。","受伤过重，已经有如风中残烛，随时都可能断气。",
"看起来充满活力，一点也不累。","似乎有些疲惫，但是仍然十分有活力。","看起来可能有些累了。","动作似乎开始有点不太灵光，但是仍然有条不紊。",
"气喘嘘嘘，看起来状况并不太好。","似乎十分疲惫，看来需要好好休息了。","已经一副头重脚轻的模样，正在勉力支撑着不倒下去。","看起来已经力不从心了。",
"摇头晃脑、歪歪斜斜地站都站不稳，眼看就要倒在地上。","已经陷入半昏迷状态，随时都可能摔倒晕去。",}
function fight:status_msg()
  print("status_msg")
  local regexp=""
  for _,reg in ipairs(msg) do
      regexp=regexp.."\\( 你"..reg.." \\)|"
  end
  regexp=regexp.."^(> |)你的体力快消耗完了！$"
  --regexp=string.sub(regexp,1,-2)
  --print(regexp)
  wait.make(function()
    local l,w=wait.regexp(regexp,5)
    if l==nil then
	  self:status_msg()
	  return
	end
	if string.find(l,"看起来气血充盈，并没有受伤") then
	   self.ratio=100
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"似乎受了点轻伤，不过光从外表看不大出来") then
	   self.ratio=90
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"看起来可能受了点轻伤") then
	   self.ratio=80
	   self:hurt()
	   self:status_msg()
	   return
	end

	if string.find(l,"受了几处伤，不过似乎并不碍事") then
	   self.ratio=70
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"受伤不轻，看起来状况并不太好") then
	   self.ratio=60
	   self:status_msg()
	   return
	end
	if string.find(l,"气息粗重，动作开始散乱，看来所受的伤着实不轻") then
	   self.ratio=50
	   self:hurt()
	   self:status_msg()
	   return
	end

	if string.find(l,"已经伤痕累累，正在勉力支撑着不倒下去") then
	   self.ratio=40
	   self:hurt()
	   self:status_msg()
	   return
	end

	if string.find(l,"受了相当重的伤，只怕会有生命危险") then
	   self.ratio=30
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"伤重之下已经难以支撑，眼看就要倒在地上") then
	   self.ratio=20
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"受伤过重，已经奄奄一息，命在旦夕了") then
	   self.ratio=10
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"受伤过重，已经有如风中残烛，随时都可能断气") then
	   self.ratio=0
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"看起来充满活力，一点也不累") then
	   self.ratio=99
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"似乎有些疲惫，但是仍然十分有活力") then
	   self.ratio=88
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"看起来可能有些累了") then
	   self.ratio=77
	   self:hurt()
	   self:status_msg()
	   return
	end

	if string.find(l,"动作似乎开始有点不太灵光，但是仍然有条不紊") then
	   self.ratio=66
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"气喘嘘嘘，看起来状况并不太好") then
	   self.ratio=55
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"似乎十分疲惫，看来需要好好休息了") then
	   self.ratio=44
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"已经一副头重脚轻的模样，正在勉力支撑着不倒下去") then
	   self.ratio=33
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"看起来已经力不从心了") then
	   self.ratio=22
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"摇头晃脑、歪歪斜斜地站都站不稳，眼看就要倒在地上") then
	   self.ratio=11
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"已经陷入半昏迷状态，随时都可能摔倒晕去") then
	   self.ratio=1
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"你的体力快消耗完了") then
	  if self.run_refresh==false then
	   --self.run_refresh=true
	    self:refresh()
	   self.reset()
	  end
	   self:status_msg()
	   return
	end
  end)
end

--[[
function fight:injure()
   wait.make(function()
     local l,w=wait.regexp("( 你摇头晃脑、歪歪斜斜地站都站不稳，眼看就要倒在地上。 )|( 你已经陷入半昏迷状态，随时都可能摔倒晕去。 )|( 你已经一副头重脚轻的模样，正在勉力支撑着不倒下去。 )|( 你似乎十分疲惫，看来需要好好休息了。 )|( 你看起来可能受了点轻伤。 )|( 你气喘嘘嘘，看起来状况并不太好。 )|( 你看起来已经力不从心了。 )|^(> |)你的体力快消耗完了！$",10)
	  if l==nil then
	     self:injure()
	     return
	  end
	  if string.find(l,"你摇头晃脑、歪歪斜斜地站都站不稳，眼看就要倒在地上") or string.find(l,"你已经陷入半昏迷状态，随时都可能摔倒晕去") or string.find(l,"你似乎十分疲惫，看来需要好好休息了") or string.find(l,"你已经一副头重脚轻的模样，正在勉力支撑着不倒下去") or string.find(l,"你看起来可能受了点轻伤") or string.find(l,"你气喘嘘嘘，看起来状况并不太好") or string.find(l,"你看起来已经力不从心了")then
		self.run_recover=true
		self:injure()
	    return
	  end
	  if string.find(l,"你的体力快消耗完了") then
	       world.Send("yun jingli")
	       self.run_refresh=true
		   self:injure()
	    return
	  end
	 wait.time(10)
   end)
end]]

--你身上没有这样东西。^?????*顺势夺过你的
--^{> 你|你}*不由自主地把手
--^{> 你|你}顿时觉得压力骤增，手腕一麻，手中*脱手而出！
--^{> 只|只}见「呼呼」连响，你*一个把持不定脱手飞
--只见昝后韦右手扣住你的脉门，左手反腕一曲一点，径取你手腕的阳溪穴。
--你只觉手腕一阵酸麻，手中的夏禹剑再也把持不住，当啷一声掉落在了地上。
--只听“当”的一声，你手臂一麻，闪电太极棒被打落到地下。
--你要用什么来吹奏？
--杜赫手中长鞭如银蛇般四下游走，只闻叮当之声，你手腕上中了一击，被迫放弃了手中的碧玉箫。
--杜赫顺势夺过你的碧玉箫，乘你情急狼狈之际，左手握住碧玉箫，使出玉女剑法速攻三招。
--你气运手臂用力一拽，凝晶雁翎箫却无法从长鞭的缠绕中脱开，情急之下只好放弃了手中的兵刃。

function fight:lost_weapon_name(weapon_name)
   print("lost weapon name")
   local weapon_id
   if string.find(weapon_name,"剑") then
      weapon_id="sword"
   elseif string.find(weapon_name,"刀") then
      weapon_id="blade"
   elseif string.find(weapon_name,"箫") then
      weapon_id="xiao"
   elseif string.find(weapon_name,"杖") then
      weapon_id="staff"
   elseif string.find(weapon_name,"棒") then
      weapon_id="stick"
   elseif string.find(weapon_name,"匕") then
      weapon_id="dagger"
   elseif string.find(weapon_name,"斧") then
      weapon_id="axe"
   elseif string.find(weapon_name,"笔") then
      weapon_id="bi"
   elseif string.find(weapon_name,"铙") then
      weapon_id="nao"
   elseif string.find(weapon_name,"锤") then
      weapon_id="hammer"
   elseif string.find(weapon_name,"轮") then
      weapon_id="falun"
   elseif string.find(weapon_name,"鞭") or string.find(weapon_name,"幡") then
      weapon_id="whip"
   elseif string.find(weapon_name,"棍") then
      weapon_id="club"
   elseif string.find(weapon_name,"枪") then
       weapon_id="spear"
   end
   print(weapon_name," ",weapon_id)
   if weapon_name=="木剑" then
       weapon_id="mu jian"
   end
   if weapon_name=="游龙鞭" then
       weapon_id="youlong bian"

   end
   table.insert(self.lost_weapon_id,weapon_id)

end
local weapon_lost="^(> |)你只感(.*)似欲脱手飞出，一个把握不住，手中兵器被挑飞了出去。$|^(> |)你的兵器被.*一压一带，刹那间(.*)已被.*夺下！$|^(> |)你气运手臂用力一拽，(.*)却无法从.*的缠绕中脱开，情急之下只好放弃了手中的兵刃。$|^(> |).*手中.*如银蛇般四下游走，只闻叮当之声，你手腕上中了一击，被迫放弃了手中的(.*)。$|^(> |)你只觉手腕一阵酸麻，手中的(.*)再也把持不住，当啷一声掉落在了地上。$|^(> |)你顿时觉得压力骤增，手腕一麻，手中(.*)脱手而出！$|^(> |)你只觉得手臂一麻，已被.*打中了穴道，不由自主地把手中的(.*)坠地！$|^(> |).*顺势夺过你的(.*)，乘你情急狼狈之际，左手握住.*$|^(> |)只见「呼呼」连响，你手中的(.*)已经被.*卷中一个把持不定脱手飞出！$|^(> |)你无法回招招架，眼睁睁的瞧着.*抵向自己咽喉，只得撇下(.*)，就地一滚.*$|^(> |)只听“当”的一声，你手臂一麻，(.*)被打落到地下。$|^(> |)你手腕被袭，一个把持不住，(.*)脱手而出，心下大惊，顿时手忙脚乱！$|^(> |)你只觉得手腕剧痛，手中(.*)再也拿捏不住，脱手而出！$|^(> |)你被.*一番疾攻。不由的闪身急躲,只能任(.*)落在一边。$"
weapon_lost=weapon_lost.."|^(> |)你只觉一股大力袭来，臂膀剧痛，手中(.*)再也拿捏不住，脱手而出！$"
weapon_lost=weapon_lost.."|^(> |)你只觉腕上一阵剧痛，呛啷一声，(.*)脱手而出！$"
weapon_lost=weapon_lost.."|^(> |)你只觉得浑身一热，手掌虎口巨痛，手中(.*)脱手而出。$"
--你的兵器被慧红的令牌一压一带，刹那间红缨白蜡大枪已被慧红夺下。
function fight:lost_weapon()
--你只感长剑似欲脱手飞出，一个把握不住，手中兵器被挑飞了出去。
--结果你的兵器被翠姑淑的令牌一压一带，长剑已被翠姑淑夺下！
--你只觉得手臂一麻，已被倩萍风的飞蝗石打中了穴道，不由自主地把手中的柳絮乾坤棒坠地！
   wait.make(function()
     local l,w=wait.regexp(weapon_lost,5)
     if l==nil then
	   self:lost_weapon()
	   return
	 end
	 --你被春宝钗荧手中暗杀匕首一番疾攻。不由的闪身急躲,只能任雪山新月刀落在一边。
	 --你被春宝钗荧手中暗杀匕首一番疾攻。不由的闪身急躲,只能任雪山新月刀落在一边。
	 --你只觉得手腕剧痛，手中碎雪刀再也拿捏不住，脱手而出！
	 if string.find(l,"脱手") or string.find(l,"夺下") or string.find(l,"放弃了手中的兵刃") or string.find(l,"被迫放弃了手中的") or string.find(l,"你只觉手腕一阵酸麻") or string.find(l,"你顿时觉得压力骤增") or string.find(l,"手臂一麻") or string.find(l,"顺势夺过你的") or string.find(l,"卷中一个把持不定脱手飞出") or string.find(l,"你无法回招招架") or string.find(l,"脱手而出") or string.find(l,"落在一边") then
	   --print("1",w[1],"2",w[2],"3",w[3],"4",w[4],"5",w[5],"6",w[6],"7",w[7],"8",w[8],"9",w[9],"10",w[10],"11",w[11],"12",w[12],"13",w[13],"14",w[14],"15",w[15],"16",w[16],"17",w[17],"18",w[18],"19",w[19],"20",w[20])
      local p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35
	  if w[1]==nil then
	      p1=""
	    else
          p1=w[1]
	   end
	    if w[2]==nil then
	      p2=""
	    else
          p2=w[2]
	   end
	    if w[3]==nil then
	      p3=""
	    else
          p3=w[3]
	   end
	    if w[4]==nil then
	      p4=""
	    else
          p4=w[4]
	   end
	    if w[5]==nil then
	      p5=""
	    else
          p5=w[5]
	   end
	    if w[6]==nil then
	      p6=""
	    else
          p6=w[6]
	   end
	    if w[7]==nil then
	      p7=""
	    else
          p7=w[7]
	   end
	    if w[8]==nil then
	      p8=""
	    else
          p8=w[8]
	   end
	    if w[9]==nil then
	      p9=""
	    else
          p9=w[9]
	   end
	    if w[10]==nil then
	      p10=""
	    else
          p10=w[10]
	   end
	    if w[11]==nil then
	      p11=""
	    else
          p11=w[11]
	   end
	    if w[12]==nil then
	      p12=""
	    else
          p12=w[12]
	   end
	    if w[13]==nil then
	      p13=""
	    else
          p13=w[13]
	   end
	     if w[14]==nil then
	      p14=""
	    else
          p14=w[14]
	   end
		if w[15]==nil then
	      p15=""
	    else
          p15=w[15]
	   end
		if w[16]==nil then
	      p16=""
	    else
          p16=w[16]
	   end
	   if w[17]==nil then
	      p17=""
	    else
          p17=w[17]
	   end
	 if w[18]==nil then
	      p18=""
	    else
          p18=w[18]
	   end
	 	 if w[19]==nil then
	      p19=""
	    else
          p19=w[19]
	   end
	 	 if w[20]==nil then
	      p20=""
	    else
          p20=w[20]
	   end
	   	 if w[21]==nil then
	      p21=""
	    else
          p21=w[21]
	   end
	 	 if w[22]==nil then
	      p22=""
	    else
          p22=w[22]
	   end
	    if w[23]==nil then
	      p23=""
	    else
          p23=w[23]
	   end
	 	 if w[24]==nil then
	      p24=""
	    else
          p24=w[24]
	   end
	   	 	 if w[25]==nil then
	      p25=""
	    else
          p25=w[25]
	   end
	   if w[26]==nil then
	      p26=""
	    else
          p26=w[26]
	   end
	    if w[27]==nil then
	      p27=""
	    else
          p27=w[27]
	   end
	      if w[28]==nil then
	      p28=""
	    else
          p28=w[28]
	   end
	      if w[29]==nil then
	      p29=""
	    else
          p29=w[29]
	   end
	      if w[30]==nil then
	      p30=""
	    else
          p30=w[30]
	   end
	      if w[31]==nil then
	      p31=""
	    else
          p31=w[31]
	   end
	   	      if w[32]==nil then
	      p32=""
	    else
          p32=w[32]
	   end
		if w[33]==nil then
	      p33=""
	    else
          p33=w[33]
	   end
	   if w[34]==nil then
	      p34=""
	    else
          p34=w[34]
	   end
	   if w[35]==nil then
	      p35=""
	    else
          p35=w[35]
	   end
	   local test="1"..p1.."2"..p2.."3"..p3.."4"..p4.."5"..p5.."6"..p6.."7"..p7.."8"..p8.."9"..p9.."10"..p10.."11"..p11.."12"..p12.."13"..p13.."14"..p14.."15"..p15.."16"..p16.."17"..p17.."18"..p18.."19"..p19.."20"..p20.."21"..p21.."22"..p22.."23"..p23.."24"..p24.."25"..p25.."26"..p26.."27"..p27.."28"..p28.."29"..p29.."30"..p30.."31"..p31.."32"..p32
		--log(""..player_id.."任务记录.txt",string.format("【"..player_name.."("..player_id..")】武器丢失:"..test.."\r\n"))
		--world.AppendToNotepad (WorldName(),os.date()..": 武器丢失:"..test.."\r\n")
	   local weapon_name=nil
	   weapon_name=w[2]
	   if weapon_name==nil or weapon_name=="" then
	     weapon_name=w[4]
	   end
	   if weapon_name==nil or weapon_name=="" then
		  weapon_name=w[6]
	   end
	   if weapon_name==nil or weapon_name=="" then
		  weapon_name=w[8]
	   end
       if weapon_name==nil or weapon_name=="" then
		  weapon_name=w[10]
	   end
	   if weapon_name==nil or weapon_name=="" then
		  weapon_name=w[12]
	   end
	   if weapon_name==nil or weapon_name=="" then
		  weapon_name=w[14]
	   end
	   if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[16]
	   end
	   if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[18]
	   end
	    if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[20]
	   end
	    if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[22]
	   end
	    if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[24]
	   end
		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[25]
	   end
		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[26]
	   end
		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[27]
	   end
	   		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[28]
	   end
	   		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[29]
	   end
	   		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[30]
	   end
	   		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[31]
	   end
	   		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[32]
	   end
	    		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[33]
	   end
	      		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[34]
	   end
		if weapon_name==nil or weapon_name=="" then
	      weapon_name=w[35]
	   end
	   print("lost weapon_name:",weapon_name)
	     if weapon_name=="你兵器" then
	      weapon_name=world.GetVariable("mark_weapon_name") or ""
	   end
	   self.losting_weapon=weapon_name
 	   self.is_duo=true
	   self:lost_weapon_name(weapon_name)
	   self:lost_weapon()
	     --新增
		 print("自动拾取武器")
         self:unarmed()
	   return
	 end
      wait.time(5)
   end)
end

function fight:unarmed(weapon_id)
   --[[if weapon_id~="" and weapon_id~=nil then
     self.current_alias="get "..weapon_id..";"..self.unarmed_alias
     --self.current_alias=self.unarmed_alias
	 self:get_weapon()
   else
	  --self.current_alias=""
	  --self:reset()

   end]]
	  --world.Send("alias pfm "..self.current_alias)
	 print("自动拾取武器2")
	self.current_alias=self.unarmed_alias
	self:reset()
end

function fight:unarmedpfm()

	   local sp=special_item.new()
	   sp.cooldown=function()
          print("使用空手技能")
		   self.current_alias=self.unarmed_alias
	       --world.Send("alias pfm "..self.current_alias)
		   self:reset()
	   end
	   sp:unwield_all()
end
--你失声惊叫：“金刚不坏体神功！”连忙收掌闪避。
function fight:idle()
--一股暖流发自丹田流向全身，慢慢地你又恢复了知觉……
--你觉得自己的意识越来越弱，渐渐不省人事了。。。
   wait.make(function()
      local l,w=wait.regexp("^(> |)一股暖流发自丹田流向全身，慢慢地你又恢复了知觉……$",5)
	  if l==nil then
	     self:idle()
	     return
	  end
	  if string.find(l,"一股暖流发自丹田流向全身") then
		 print("fight:战斗结束")
		 if self.status=="大转" then
		    world.Send("get hammer")
			world.Send("get falun")
		 end
		 world.Send("unset wimpy")
		 self:finish()
		 return
	  end
	  wait.time(5)
   end)
end

function fight:eat_wan(flag)
   if self.running==false or flag==true then
     self.running=true
   else
     return
   end

     world.Send("fu neixi wan")
     world.Send("fu chuanbei wan")
     world.Send("set action 吃药")
    wait.make(function()
     local l,w=wait.regexp("^(> |)你服下一颗.*，顿时觉得内力充沛了不少。$|^(> |)你服下一颗川贝内息丸，顿时感觉内力充沛。$|^(> |)你正忙着呢。$|^(> |)你上次的药劲儿还没过呢，等会儿再服用吧。$|^(> |)设定环境变量：action = \\\"吃药\\\"$",5)
     if l==nil then
	   self:eat_wan(true)
	   return
	 end

	 if string.find(l,"你服下一颗") then
       print("吃下内息丸")
	   self.running=false
	   return
	 end
	 if string.find(l,"你正忙着呢") then
	   local f=function()
	     --self.running=false
	     self:eat_wan(true)
	   end
	   f_wait(f,0.8)
	   return
	 end
	 if string.find(l,"你上次的药劲儿还没过呢，等会儿再服用吧")  then
	    self:neili_lack()
	   return
	 end
	 if string.find(l,"设定环境变量：action") then
	   self:neili_lack()
	   return
	 end
   end)
end

function fight:neili_lack()  --回调函数

end
--你的体力快消耗完了！
--你现在真气太弱，使不出「雷霆万钧」。
function fight:run()
  --print("战斗异常检测")
  wait.make(function()
   --( 你似乎十分疲惫，看来需要好好休息了。 )> 你不在战斗中。
   --( 你已经一副头重脚轻的模样，正在勉力支撑着不倒下去。 )
   --你深深吸了几口气，脸色看起来好多了。
   --( 你看起来可能受了点轻伤。 )「雷霆万钧」只能在战斗中使用。
   --七剑连环指只能对战斗中的对手使用。
   --「大阴阳手」绝技只能对战斗中的对手使用。
      --> 「峻极神掌」只能在战斗中用。你只能在战斗中使用「以彼之道
	 -- world.Send(self.cmd)
	 --你的真气不够，无法施展出飞影。
	  if self.auto_perform==true then
	    world.Execute(self.current_alias)
	  end
	   local regexp="^(> |)你不在战斗中。$|^(> |)你的气血不足。$|^(> |)你的真气不足，不能施展.*$|^(> |)你的内力不够。$|^(> |)你的真气不够！$|^(> |)你的精力不够了！$|^(> |)你的精力不够，无法施展.*$|^(> |)你的体力快消耗完了！$|^(> |)你现在真气太弱，使不出.*。$|^(> |)你的精力不足，不能施展.*$|^(> |)你所使用的外功中没有这种功能。$|^(> |)你现在精力不足，不能使用.*$|^(> |)你拿着武器怎么能使用.*$|^(> |)你使用的武器不对，难以施展.*$|^(> |)只有空手才能施展.*$|^(> |)你必须空手使用.*$|^(> |)使用.*时必须空手.*$|^(> |)在这里不能攻击他人。$|^(> |)你必须空手才能使用.*$|^(> |)你想要对谁吹奏？$|^(> |)你只觉得头昏脑胀，眼前一黑，接着什么也不知道了……$|^(> |)你的精气不够，无法施展.*$|^(> |)你只能空手运用.*$|^(> |)你现在内力不足.*$|^(> |)你空手无法对使用兵器的对手使用「以彼之道 还施彼身」绝技。$|^(> |)你内力现在不够.*$|^(> |)你的内力太少了.*$|^(> |)你的精力不够。$|^(> |)你现在的武器无法使用.*$|^(> |)你的真气不够，无法施展.*$|^(> |)你的真气不足，无法使用.*。$|^(> |)你必须先 enable 一种内功。$|^(> |)你的真气不够！$|^(> |)你没有使用武器，如何施展.*$|^(> |)你的内力不够，无法施展.*$|^(> |).*的身子突然晃了两晃，牙关格格地响了起来。$|^(> |)你必须在使用剑时才能使出「金蛇狂舞」！$|^(> |)你只有一种兵器就想阴阳倒乱刃法？$|^(> |)你先放下手中的武器再说吧？！$|^(> |)你使用的武器不对。$"
      local l,w=wait.regexp(regexp,5)
	  if l==nil then
	    self:run()
	    return
	  end
	  if string.find(l,"身子突然晃了两晃，牙关格格地响了起来") then
	     local player_id=world.GetVariable("player_id")
	       if string.lower(player_id) == "she" then
	       world.Send("unset 天山雪崩")
	       end
	    self:run()
	    return
	  end
	  if  string.find(l,"你想要对谁吹奏") or string.find(l,"在这里不能攻击他人") then
	    print("fight:战斗结束")
		world.Send("unset wimpy")
	    self:finish()
	    return
	  end
	  if string.find(l,"你的气血不足") then
	    world.Send("yun recover")
	    self:run()
	    return
	  end
	  if string.find(l,"你的真气不够") or string.find(l,"你的真气不足") or string.find(l,"你的真气不足") or string.find(l,"你的真气不够") or string.find(l,"你的内力不够") or string.find(l,"你现在真气太弱") or string.find(l,"你现在内力不足") or string.find(l,"你内力现在不够") or string.find(l,"你的内力太少了") then
		self:eat_wan()
		local f
		f=function()
		   self:run()
		end
		f_wait(f,0.8)
	    return
	  end
	  if string.find(l,"你的精力不够") or string.find(l,"你的体力快消耗完了") or string.find(l,"你的精力不足") or string.find(l,"你现在精力不足") or string.find(l,"你的精气不够") then
	    --world.Send("yun refresh")
		--self:run()
		self:refresh()
		local f
		f=function()
		   self:run()
		end
		f_wait(f,0.8)
	    return
	  end
	  if string.find(l,"你必须先 enable 一种内功") then
	    -- world.Send("jifa all")
		 local fight_jifa=world.GetVariable("fight_jifa") or ""
			if fight_jifa~="" then
			   world.Execute(fight_jifa)
			else
			   world.Send("jifa all")
			end
			world.Send("jifa")
	     self:run()
	     return
	  end--
	   if string.find(l,"你必须在使用剑时") or string.find(l,"你现在的武器无法使用") or string.find(l,"你使用的武器不对")  or string.find(l,"你先放下手中的武器再说吧") or string.find(l,"你所使用的外功中没有这种功能") or string.find(l,"你拿着武器怎么") or string.find(l,"空手") or string.find(l,"只有一种兵器就想阴阳倒乱刃法") then --string.find(l,"你必须先放下你目前装备的武器")  ^(> |)你必须先放下你目前装备的武器。$|
	    print("武器不对!")
	    self:no_pfm()
	    return
	  end
	  --你手里没有剑，无法使用七剑连环指！
	  if string.find(l,"你空手无法对使用兵器的对手使用") or string.find(l,"你没有使用武器，如何施展") then
	     print("武器丢失")
	     self:unarmedpfm()
	     return
	  end
	   if string.find(l,"你只觉得头昏脑胀，眼前一黑，接着什么也不知道了") then
	     shutdown()
		 self:idle()
	     return
	  end
	  wait.time(5)
   end)
end



function fight:reset()

   --self.current_alias=Trim(self.combat_alias)
   --self.current_alias=Trim(self.current_alias)
   --self.current_alias=string.gsub(self.current_alias,"ado","")
   --self.current_alias=string.gsub(self.current_alias,"|",";")
   local target=self.target or ""
   if target~="" then
      target=" "..target
   end
   if self.current_alias=="" then

      self.current_alias=self.combat_alias
   end
   self.current_alias=string.gsub(self.current_alias," @id",target) --指定id
   world.SetVariable("pfm",self.current_alias)
   if self.run_flee==true then
     print("运行逃跑！！")
   elseif self.run_recover==true and is_recover==false then
      world.Send("alias pfm yun qi;"..self.current_alias)
   elseif self.run_yunjing==true then
      world.Send("alias pfm yun jing;"..self.current_alias)
   elseif self.run_refresh==true then
      world.Send("alias pfm yun jingli;"..self.current_alias)
   else
      print("删除 吸气")
      self.current_alias=string.gsub(self.current_alias,"yun qi;","")
	  self.current_alias=string.gsub(self.current_alias,"yun jingli;","")
	  self.current_alias=string.gsub(self.current_alias,"yun jing;","")
      world.Send("alias pfm "..self.current_alias)
	  world.SetVariable("pfm",self.current_alias)
   end
end

function fight:enemy_busy() --回调函数
end

function fight:enemy_yunqi()
   wait.make(function()
     local l,w=wait.regexp("^(> |)"..self.enemy_name.."深深吸了几口气，脸色看起来好多了。$",5)
	 if l==nil then
	    self:enemy_yunqi()
	    return
	 end
	 if string.find(l,"深深吸了几口气") then
	     self:enemy_busy()
		 self:enemy_yunqi()
	     return
	 end
   end)
end

function fight:before_kill()
   print("before kill")
    self.current_alias=self.combat_alias
    world.Send("alias pfm "..self.current_alias)
    world.Send("set wimpycmd pfm\\hp\\cond")
    world.Send("set wimpy 100")
end

function fight:start(SendPFM)
    --world.Send("set wimpy 100")
    world.DeleteTrigger("npc_place")
	world.DeleteTrigger("robber_place")
--
   --self:injure()
    print("战斗开始")
   self:run()
   self:status_msg()
   self:lost_weapon()
   self:check()
   self:cond()
   self:enemy_yunqi()
   self:danger_skill()
   self:combat_check()
  --[[
   if SendPFM==nil then
     local f=function()
       world.ColourNote ("red", "yellow", "自动出手")
       world.Send(self.current_alias)
       world.ColourNote ("red", "blue", "出手结束")
     end
     f_wait(f,0.1)
   end]]
   if self.pfm_list~="" and self.pfm_list~=nil then
     --技能组合
	    self:create_combine_list(self.pfm_list) --创建组合列表
		--
		self:catch_pfm()
   end
   wait.make(function()
   --( 你似乎十分疲惫，看来需要好好休息了。 )> 你不在战斗中。
   --( 你已经一副头重脚轻的模样，正在勉力支撑着不倒下去。 )
   --你深深吸了几口气，脸色看起来好多了。
   --( 你看起来可能受了点轻伤。 )「雷霆万钧」只能在战斗中使用。
   --七剑连环指只能对战斗中的对手使用。
   --「大阴阳手」绝技只能对战斗中的对手使用。
      --> 「峻极神掌」只能在战斗中用。  你正打不还手呢，怎么杀？( 你正打不还手呢，施用外功干嘛？)
	  --你内力现在不够, 不能使用拈花拂穴！
       --你的内力太少了，无法使用出「四季散花」！
       --「摄心大法」只能对战斗中的对手使用。
	   --你手里没有剑，无法使用七剑连环指！
	  local regexp="^(> |)你不在战斗中。$|^(> |)你的气血不足。$|(> |)你只能在战斗中使用.*。$|^(> |).*只能在战斗中(使|)用。$|^(> |)你的真气不足，不能施展.*$|^(> |)你的内力不够。$|^(> |)你的精力不够了！$|^(> |)你的精力不够，无法施展.*$|^(> |)你的体力快消耗完了！$|^(> |)你现在真气太弱，使不出.*。$|^(> |)你的精力不足，不能施展.*|^(> |)(.*)([^「摄心大法」])只能(对|在)战斗中(的|对)对手使用。$|^(> |)你所使用的外功中没有这种功能。$|^(> |)你现在精力不足，不能使用.*$|^(> |)你想要对谁吹奏？$|^(> |)你必须先放下你目前装备的武器。$|^(> |)你拿着武器怎么能使用.*$|^(> |)你必须空手使用.*$|^(> |)使用.*时必须空手.*$|^(> |)在这里不能攻击他人。$|^(> |)你必须空手才能使用「.*」！$|^(> |)只有空手才能施展.*|^(> |)你想要对谁吹奏？$|^(> |).*只能在战斗时用！$|^(> |)你的精气不够，无法施展.*$|^(> |)你内力现在不够.*$|^(> |)你的内力太少了.*$|^(> |)卧室不能读书，会影响别人休息。$|^(> |)你必须先 enable 一种内功。$|^(> |)你没有使用武器，如何施展.*$|^(> |)你使用的武器不对，难以施展.*$|^(> |)你使用的武器不对。$|^(> |)你必须空手才能使用.*|^(> |)你手里没有.*，无法使用.*$|^(> |)你使得了「飞掷」么?$|^(> |)你不用鞭子怎么使用「飞龙诀」？$|^(> |)你装备的武器不对，无法施展「三无三不手」。$"
     if self.check_pfm==false then
        regexp="^(> |)你的气血不足。$|^(> |)你的真气不足，不能施展.*$|^(> |)你的内力不够。$|^(> |)你的精力不够了！$|^(> |)你的体力快消耗完了！$|^(> |)你现在真气太弱，使不出.*。$|^(> |)你的精力不足，不能施展.*|^(> |)你的精力不够，无法施展.*$|^(> |)你所使用的外功中没有这种功能。$|^(> |)你现在精力不足，不能使用.*$|^(> |)你拿着武器怎么能使用.*$|^(> |)你必须空手使用.*$|^(> |)使用.*时必须空手.*$|^(> |)你必须空手才能使用「.*」！$|^(> |)你的精气不够，无法施展.*$|^(> |)只有空手才能施展.*$|^(> |)你的真气不够，无法施展出.*$|^(> |)你必须先 enable 一种内功。$|^(> |)你的真气不够！$|^(> |)你没有使用武器，如何施展.*$|^(> |)你使用的武器不对，难以施展.*$"
	 end
	 local l,w=wait.regexp(regexp,2)
	  if l==nil then
	    self:run()
	    return
	  end

	  if string.find(l,"卧室不能读书，会影响别人休息") or string.find(l,"在这里不能攻击他人") or string.find(l,"你只能在战斗中使用") or string.find(l,"只能在战斗中") or string.find(l,"你不在战斗中") or string.find(l,"只能对战斗中的对手使用") or string.find(l,"你想要对谁吹奏") or string.find(l,"战斗时用") then
		print("fight:战斗结束")
		world.Send("unset wimpy")
		self:finish()
	    return
	  end
	  if string.find(l,"你的气血不足") then
	    world.Send("yun recover")
	    self:run()
	    return
	  end
	  if string.find(l,"你必须先 enable 一种内功") then
	    world.Send("jifa all")
	    self:run()
	    return
	  end
	  if string.find(l,"你的真气不足") or string.find(l,"你的真气不够") or string.find(l,"你的内力不够") or string.find(l,"你现在真气太弱") or string.find(l,"你内力现在不够") or string.find(l,"你的内力太少了") then
		self:eat_wan()
		local f
		f=function()
		   self:run()
		end
		f_wait(f,0.8)
	    return
	  end
	  if string.find(l,"你的精力不够") or string.find(l,"你的体力快消耗完了") or string.find(l,"你的精力不足") or string.find(l,"你的精气不够") then
	    self:refresh()
		local f
		f=function()
		   self:run()
		end
		f_wait(f,0.8)
	    return
	  end --你使得了「飞掷」么?
	  if string.find(l,"你装备的武器不对") or string.find(l,"你所使用的外功中没有这种功能") or string.find(l,"你拿着武器怎么") or string.find(l,"空手")  or string.find(l,"你使用的武器不对，难以施展") or string.find(l,"飞掷") then --string.find(l,"你必须先放下你目前装备的武器")
		 if self.dazhuan==false then
		    print("武器不对!")
			--world.Send("jifa all")
			local fight_jifa=world.GetVariable("fight_jifa") or ""
			if fight_jifa~="" then
			   world.Execute(fight_jifa)
			else
			   world.Send("jifa all")
			end
			world.Send("jifa")
	        self:no_pfm()
		 end
	    return
	  end
	  if string.find(l,"你没有使用武器，如何施展") or string.find(l,"你使用的武器不对") or string.find(l,"你手里没有") or string.find(l,"你不用鞭子怎么使用") then
	  self:unarmedpfm()
	  return
	  end
   end)
end
--你所使用的外功中没有这种功能。
--> 你的真气不足，不能施展「峻极神掌」！
function fight:no_pfm()
   if self.is_duo==true then
      print("武器丢失导致无法施法")
	  self.current_alias=self.unarmed_alias
	  --world.Send("..self.current_alias2..")
	  --world.Send("alias pfm get "..self.weapon_id..";"..self.current_alias)
	  self:reset()
   else
       local sp=special_item.new()
	   sp.cooldown=function()
	        print("判断！pfm！！")
		    self:run()
	   end
	   sp:unwield_all()
   end
end

function fight:finish()

end

--受伤程度?
function fight:damage(percent)

end
--你空手无法对使用兵器的对手使用「以彼之道 还施彼身」绝技。
function fight:check()
 fight.check_co=coroutine.create(function()
    local h=hp.new()
	 self.hp=h
     h.checkover=function()
       print("受伤程度",h.qi_percent)
       self.damage(h) --受伤程度
	   local g=h.max_jingli/2
	   print(h.jingli,"/",h.max_jingli," ",g)
       if h.qi<=h.max_qi*0.8 then
		  is_recover=false
	      self:recover(true)
	    elseif h.jingxue<=h.max_jingxue*0.8 then
	      self:yunjing(true)
 	   elseif h.jingli<=g or h.jingli<=200 then
	      self:refresh()
	   else
		  h:capture()
	   end
	   if h.neili<=200 then
		  self:eat_wan()
	   end
    end
   while true do
     h:capture()
     coroutine.yield()
   end
  end)
  self:check_resume()
end
--七伤拳内伤|内伤|火焰刀烧伤|一指禅内劲|蛇毒|气息不匀|封招|闭气|寒毒|寒冰绵掌毒|蔓陀萝花毒|打狗棒脚伤

function fight:combat_end(f)
   wait.make(function()
	 local l,w=wait.regexp("^(> |)你正要有所动作，突然身旁有人将你一拍：好好看比武，别乱动！$|^(> |)你要读什么？$|^(> |)你无法在战斗中专心下来研读新知！$|^(> |)这里不能读书！$|^(> |)你无法静下心来修炼。$|^(> |)卧室不能读书，会影响别人休息。$|^(> |)丹房重地，不能如此！$|^(> |)这里是禅房不能做与静坐无关的事情！$",5)
	 if l==nil then
	    self:resume_combat_check()
	    return
	 end
	 if string.find(l,"这里是禅房") or string.find(l,"你要读什么") or string.find(l,"这里不能读书") or string.find(l,"卧室不能读书") or string.find(l,"丹房重地") or string.find(l,"你正要有所动作") then
	   self:close_combat_check()
	   print("战斗结束")
	   self:finish()
	   return
	 end
	 if string.find(l,"你无法静下心来修炼") then
	   world.Send("jifa all")
	   self:close_combat_check()
	   print("战斗结束")
	   if self.pfm_list~="" and self.pfm_list~=nil then
	      self:clear_pfm_list()
	   end
	   self:finish()
	    return
	 end
	 if string.find(l,"你无法在战斗中专心下来研读新知") then
	   --self:test_combat()
	   --print(check_time.."s 再次检测")
	   f_wait(f,self.check_time) --延迟30秒后执行
	   return
	 end
  end)
end


function fight:combat_check() --战斗检测  test_combat 开启以后自动失效
  local wait_id = "combat_timer_" .. GetUniqueNumber ()
  _id=wait_id
  local f=function()
	   --print(coroutine.status(combat_table[id]))
	   --local status=coroutine.status(combat_table[id])
	   --if status=="suspended" then --进程被挂起则唤醒进程
	   --print("id:",wait_id)
	   --print("co:",combat_table[wait_id])
	   if combat_table[wait_id]~=nil then
	     local status=coroutine.status(combat_table[wait_id])
		 --print(status)
		 if status=="suspended" then
		   print(self.check_time.." s 后"..wait_id.."检测")
		   local f2=function() self:resume_combat_check() end
	       f_wait(f2,self.check_time) --延迟30秒后执行
		 else
		  print(wait_id,"->",status)
		 end
	   end
  end
  combat_table[wait_id]=coroutine.create(function()
    print("战斗检测开启",wait_id)
	f_wait(f,self.check_time) --延迟30秒后执行
	local run=true
	while run do
	  print("等待"..self.check_time.."s 检测！！")
	  run=coroutine.yield()
	  world.Send("du")
	  self:combat_end(f)
	end
	print("退出进程:"..wait_id)
	combat_table[wait_id]=nil--clear
  end)
  coroutine.resume(combat_table[wait_id],true)  --启动进程
end

function fight:resume_combat_check()
   if combat_table[_id] and coroutine.status(combat_table[_id])=="suspended" then
     coroutine.resume(combat_table[_id],true)  --启动进程
   end
end

function fight:close_combat_check()
   if combat_table[_id] and coroutine.status(combat_table[_id])=="suspended" then
      coroutine.resume(combat_table[_id],false) --关闭掉 combat_check 进程
   end
end

function fight:fight_reset()
end

function fight:halt_fight() --终止战斗
    print("封着，闭气 气息不匀")
	self.fight_reset=function()
	       print("reset")
		   if self.fightcmd~="" then
		     print("unset wimpy")
		     world.Execute("unset wimpy;"..self.fightcmd..";set wimpy 100")
		   end
		   -- 创建新的combat_check 进程
		   self:combat_check()
		   self:resume_combat_check()
		   self.fight_reset=function() end
	 end
     print("关闭combat_check:id=".._id)
	 self:close_combat_check()

	 world.Send("halt")
	 local f=function()
	   world.Send("cond")
       self:cond()
	 end
	 f_wait(f,0.5)
end

function fight:cond()
--你身上没有包括任何特殊状态。你身上包含下列特殊状态：
   --world.Send("cond") 通过wimpycmd 发送cond指令 对方已经身受内伤，你不必再用「刚柔诀」了。
    wait.make(function()
      local l,w=wait.regexp("\\│.*气息不匀.*\\||\\│.*封招.*\\||\\|.*闭气.*\\||\\│.*一指禅内劲.*\\||^(> |)当前你没有被判断为机器人。$|^(> |)你被判断为机器人，赶快用robot命令召唤一个出来吧。$",2)
	  if l==nil then
	     self:cond()
	     return
	  end
	 --[[ if string.find(l,"气息不匀") or string.find(l,"封招") or string.find(l,"闭气") or string.find(l,"内伤") then
		print("busy 状态中 halt")
	    self:halt_fight()
		return
	  end
	  ]]
	   if string.find(l,"气息不匀") or string.find(l,"封招") or string.find(l,"闭气") or string.find(l,"一指禅内劲") then
		print("busy 状态中 halt")
		   shutdown()
		  world.Send("unset wimpy")
		  world.Send("halt")
		 self:escape()
	   -- self:halt_fight()
		return
	  end
	--[[ if string.find(l,"当前你没有被判断为机器人") or string.find(l,"你被判断为机器人") then
	    self:fight_reset() --战斗状态判别
		self:cond()
	    return
	 end
	 ]]
    end)
end

--^?????{@killer_name|@wdjob_name|@hs_name}纵跃退後，立时呜呜、嗡嗡、轰轰之声大作，金光闪闪，银光烁烁，五只轮子从五个不同方位飞袭出来！

--^?????法轮在{@killer_name|@wdjob_name|@hs_name}身旁绕了个圈子，*伸手一招，那飞行中的*法轮便重新飞回*的手中！

local _halt_count=0
function fight:danger_skill_end(regexp,name)
	 world.Send("halt")
     wait.make(function()
	    local l,w=wait.regexp(regexp,0.5)
		if l==nil then
		    self:danger_skill_end(regexp,name)
		   return
		end
		if string.find(l,name) then
		   self:danger_skill()
		   if self.fightcmd~="" then
		     world.Execute("unset wimpy;"..self.fightcmd..";set wimpy 100")
		   end
           self:combat_check()
		   self:resume_combat_check()
		   return
	    end
		if string.find (l,"你现在不忙") then
		   _halt_count=_halt_count+1
           if _halt_count<=10 then
		     self:danger_skill_end(regexp,name)
		   else
		     self:danger_skill()
		     if self.fightcmd~="" then
		       world.Execute("unset wimpy;"..self.fightcmd..";set wimpy 100")
		     end
             self:combat_check()
		     self:resume_combat_check()
		   end
		   return
		end
		wait.time(0.5)
	 end)
end

function fight:escape()  --逃跑回调函数
end
--^{> 你|你}只觉得@killer_name每一招都将你克制的毫无还手之余！
--^{> 你|你}只觉得处处受制，武功中厉害之处完全无法发挥出来！
--尉迟静掌势蕴含太极之力，连绵不断，如同雪崩般袭向你！
--你只觉得全身周遭穴道受阻，如针刺般绞痛。
--手中两条长鞭犹如水蛇般蜿蜒而出，玎玎两响，你手腕上的
--你只觉得自己周身被佟婷剑气缠绕，体内真气难以运转自如！
--结果你一个不小心，被指劲点在丹田之上，顿时丹气混乱，脸色发白
--你只感到穴道一麻，浑身劲气立散，动弹不得。你纵跃退後，立时呜呜、嗡嗡、轰轰之声大作，金光闪闪，银光烁烁，五只轮子从五个不同方位飞袭出来！
function fight:danger_skill()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)([^你])纵跃退後，立时呜呜、嗡嗡、轰轰之声大作，金光闪闪，银光烁烁.*$|^(> |)只是你的这五只轮子或攻或守，或进或退，实乃奥妙非常！$|^(> |)你只觉得自己周身被(.*)剑气缠绕，体内真气难以运转自如！$|^(> |)你身上衣衫毛发尽皆着火，皮肤头发被烧得吱吱做响，滚倒在地，不住翻滚号哭！$|^(> |)你身上的.*被火焰刀所焚，象片片破布般飘落。$|^(> |)你只觉得。*每一招都将你克制的毫无还手之余！$|^(> |)你只觉得处处受制，武功中厉害之处完全无法发挥出来！$|^(> |)(.*)掌势蕴含太极之力，连绵不断，如同雪崩般袭向你！$|^(> |)你只觉得全身周遭穴道受阻，如针刺般绞痛。$|^(> |)(.*)手中两条长鞭犹如水蛇般蜿蜒而出，玎玎两响，你手腕上的「(.*)」都被长鞭点中！$|^(> |)结果你一个不小心，被指劲点在丹田之上，顿时丹气混乱，脸色发白！$|^(> |)你只觉全身一麻，已被这一招「佛门广渡」点中！$|^(> |)结果你气血一滞，已被定在当堂。$|^(> |)你只感到穴道一麻，浑身劲气立散，动弹不得。$|^(> |)你感觉这指劲在丹田里乱窜，扰得你浑身发软，身不由己！$",2)
	  if l==nil then
	     self:danger_skill()
	     return
	  end
	  if string.find(l,"只是你的这五只轮子或攻或守，或进或退，实乃奥妙非常") or string.find(l,"立时呜呜、嗡嗡、轰轰之声大作，金光闪闪") then
	    print("大转开始！！")
	    self.dazhuan=true
		return
	  end
	  --if string.find(l,"你克制的毫无还手之余") or string.find(l,"结果你一个不小心，被指劲点在丹田之上，顿时丹气混乱，脸色发白") or string.find(l,"体内真气难以运转自如") or string.find(l,"手中两条长鞭犹如水蛇般蜿蜒而出，玎玎两响，你手腕上的") or string.find(l,"武功中厉害之处完全无法发挥出来") or string.find(l,"你只觉得全身周遭穴道受阻，如针刺般绞痛。") then
	  if string.find(l,"你克制的毫无还手之余")  or  string.find(l,"武功中厉害之处完全无法发挥出来")  then
		print("中了独孤九剑")
		  _G["独孤"]=true
		  -- shutdown()
		  --world.Send("halt")
		 self:escape()
	     return
	  end
	  if  string.find(l,"结果你一个不小心，被指劲点在丹田之上，顿时丹气混乱，脸色发白")   or string.find(l,"你只觉全身一麻，已被这一招")  or string.find(l,"气血一滞，已被定在当堂")  or string.find(l,"你只感到穴道一麻，浑身劲气立散，动弹不得") or string.find(l,"你感觉这指劲在丹田里乱窜，扰得你浑身发软，身不由己")  then
	   self:yunjing()
	  end
	    if string.find(l,"手中两条长鞭犹如水蛇般蜿蜒而出，玎玎两响，你手腕上的") or string.find(l,"你只觉得全身周遭穴道受阻，如针刺般绞痛。")   then
	   --  print("中了独孤九剑")
		-- _G["独孤"]=true
		   --shutdown()
		  --world.Send("halt")
		 --self:escape()
		 self:danger_skill()
	     return
	  end
	 --if string.find(l,"陷入迷阵中，登时手足无措") then
	    --world.Send("halt")
		--self:danger_skill_end("^(> |).*对你布的迷阵已经被你识破了。$","被你识破了")
	--	return
	 --end
   end)
end

function fight:check_resume()
   coroutine.resume(fight.check_co)
end

function fight:get_weapon()
--你捡起一柄长剑。
--你附近没有这样东西。
--光天化日的想抢劫啊？
--你上一个动作还没有完成！
  wait.make(function()
     local l,w=wait.regexp("^(> |)你捡起.*"..self.losting_weapon..".*$|^(> |)你附近没有这样东西。$",5)
	 if l==nil then
	    self:get_weapon()
		return
	 end
	 	 if string.find(l,"你捡起") then
	    self.is_duo=false
		--self:reset()
		  self:unarmed()
	    return
	 end
	 if string.find(l,"你附近没有这样东西") then
	    self:unarmed()
	    return
	 end
	 wait.time(5)
  end)
end

--一个busy skills 加一个强力pfm 技能组合
--1 判断技能成功 标志位
--2 判断pfm busy 判断是否jifa parry 切换成功
--3 切换 施展下一个技能
--4 回到 1 继续循环

-- pfm {表达式，成功表达式，下一个pfm指针，执行语句}
--1
--技能组合 启动组合监控
--武将只觉得「曲池穴」已被你的指风点中，身形不由的缓慢下来！
--弹指神通.弹,玉箫剑法.飞影, .*只觉得「.*」已被你的指风点中，身形不由的缓慢下来！,身形不由的缓慢下来,unwield xiao;jifa parry tanzhi-shentong;perform finger.tan
--玉箫剑法.飞影,弹指神通.弹, 你飞影使完，手一晃将.*拿回手中。,你飞影使完,wield xiao;jifa parry yuxiao-jian;perform sword.feiying
--"大转换大手印":{"regexp":"^(> |)你纵跃退後，立时呜呜、嗡嗡、轰轰之声大作，金光闪闪，银光烁烁，五只轮子从五个不同方位飞袭出来！$","ok_regexp":"五只轮子从五个不同方位飞袭出来","cmd":"unwield falun;unwield hammer;jiali max;bei hand;jifa parry dashou-yin;perform parry.tianyin;jiali 1;yun longxiang;yun shield"}
-- 2016 -12-21 将pfms 组合改为静态触发器模式
--当匹配 自动切换到指定pfm 基本格式  表达式:pfm1|表达式:pfm2:状态  --设置 默认 PFM
--你一拳打出，正是以柔克刚的绝顶武学，方庞猛觉得对方拳力若有若无，自己掌力使实了固然不对，使虚了也是极其危险，不禁暗暗吃惊。 yun maze
function fight:create_combine_list(pfm_list)
   if pfm_list==nil then
      pfm_list=world.GetVariable("pfm_list1")
   end
   self.combine_list={}
   local pfms=Split(pfm_list,"#")
   for _,p in ipairs(pfms) do
       local acts=Split(p,"&")
	   local v={}
	   v.regexp=acts[1]
	   v.regexp=string.gsub(v.regexp,"@npc",self.enemy_name)
	   v.pfm=acts[2]
	   v.status=acts[3]
	   print(v.regexp," pfm:",v.pfm," status:",v.status)
	   table.insert(self.combine_list,v)
   end
  --[[ local g
   for _,g in pairs(self.combine_list) do
      g={}
   end
   self.combine_list={}
   local cjson = require("json")
      --pfm_list=world.GetVariable("pfm_list")

   	  pfm_list="{"..pfm_list.."}"
      local json=cjson.decode(pfm_list) --json数据解析
	  for k,v in pairs(json) do
		 -- print(k)
          --print(v.cmd)
		  --print(v.regexp)
		  --print(v.ok_regexp)
		   local i={}

	        i.regexp=string.gsub(v.regexp,"@npc",self.enemy_name)
			--print("fight regexp:",i.regexp)
	        i.ok_regexp=v.ok_regexp
	        i.cmd=v.cmd
			i.status=v.status
	  --print(i.regexp," ",i.ok_regexp," ",i.cmd)
	      table.insert(self.combine_list,i)
	  end

     local regexp=""
      for _,pfm in ipairs(self.combine_list) do
         regexp=regexp..pfm.regexp.."|"
      end
      regexp=string.sub(regexp,1,-2)
      --print(regexp)
      return regexp]]
end

function fight:clear_pfm_list()
   --清除掉所有pfm_list 进程
   for _,th in pairs(fight.pfm_threads) do
     for _,i in pairs(th) do
	     i=nil  --子item
	 end
     th= nil
   end
   fight.pfm_threads={}
   --
   world.DeleteTriggerGroup("pfm_list") --删除触发器

end

function fight:trigger_resume(id)
  --print("retume id:",id)
  --print("retume line:",line)
  local thread =fight.pfm_threads[id].co
  if thread then
    local ok, err = coroutine.resume (thread,id)
    if not ok then
       ColourNote ("deeppink", "black", "Error raised in trigger function (in fight module)")
       ColourNote ("darkorange", "black", debug.traceback (thread))
       error (err)
    end -- if
  end -- if
end

function fight:catch_pfm()
   --添加触发器

   for _,i in ipairs(self.combine_list) do
       local _pfm=i.pfm
	   local cmd=world.GetVariable(_pfm) or ""
	   local id = "pfm_" .. os.time()..GetUniqueNumber() --获得一个id
	   fight.pfm_threads[id]={}
	   fight.pfm_threads[id].regexp=i.regexp
	   fight.pfm_threads[id].cmd=cmd
	   fight.pfm_threads[id].status=i.status
       fight.pfm_threads[id].co=coroutine.create(function(trigger_id)
	      while true do  --循环
			 print("执行切换")
	        if i.status=="set" then
			   world.Execute(fight.pfm_threads[trigger_id].cmd)
		    else
			  self.combat_alias=fight.pfm_threads[trigger_id].cmd
			  self.current_alias=self.combat_alias
			  self.status=fight.pfm_threads[trigger_id].status --标志
              self:reset()
		    end
			coroutine.yield()
		  end
	   end)

	   world.AddTriggerEx (id,i.regexp,
            "fight:trigger_resume('"..id.."')",
            bit.bor (flags or 0, -- user-supplied extra flags, like omit from output
                     trigger_flag.Enabled,
                     trigger_flag.RegularExpression,
                     trigger_flag.Temporary,
                     trigger_flag.Replace),
            custom_colour.NoChange,
            0, "",  -- wildcard number, sound file name
            "",
            12, 100)  -- send to script (in case we have to delete the timer)
	   world.SetTriggerOption(id, "group", "pfm_list")
   end
 --print(regexp)
 --[[
  wait.make(function()
      local l,w=wait.regexp(regexp,5)
	  if l==nil then
	     self:catch_pfm(regexp)
	     return
	  end
	  for _,i in ipairs(self.combine_list) do
		 --print(i.ok_regexp)
		 if string.find(l,i.ok_regexp) then

			if i.status=="设置" then
			   world.Execute(i.cmd)
			else
			  self.combat_alias=i.cmd
			  self.current_alias=self.combat_alias
			  self.status=i.status --标志
              self:reset()
			end
			self:catch_pfm(regexp)
	        return
	     end
	  end
	  wait.time(5)
  end)]]
end



function fight:recover(flag)
  wait.make(function()
     print("尝试吸气")
	--[[   local status=coroutine.status(combat_table[_id])
		 --print(status)
		 if status=="suspended" then
			 world.Send("yun qi")
		 else
		     world.Send("set wimpy 100")
		  end
	 if self.run_recover==false then
	    self.run_recover=true
		self:reset()
	    --world.Send("alias pfm yun recover;"..self.current_alias)
	 end]]
     local l,w=wait.regexp("^(> |)你深深吸了几口气，脸色看起来好多了。$|^(> |)你现在气力充沛。$|^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你现在精神饱满。$",2)
	 if l==nil then
	     --print("吸气")
	     self:recover(flag)
	   return
     end
	 if string.find(l,"你深深吸了几口气") or string.find(l,"你现在气力充沛")  or string.find(l,"你现在精神饱满") then
	   --world.Send("alias pfm "..self.current_alias)
	   print("吸气成功！")
	   is_recover=true
	   local f=function()
		  print(is_recover," recover 标志位")
	      is_recover=false
	   end
	   f_wait(f,3)
	   self.run_recover=false
	   self:reset()
	   self:check_resume()
	   --self:injure()
	   --self:check()
	  -- if flag==true then
	  --   print("recover resume check")
	  --   self:check_resume()
	  -- end
	   return
	 end
     wait.time(2)
	end)
end

function fight:yunjing()
 wait.make(function()
    if self.run_yunjing==false then
	   self.run_yunjing=true
	   self:reset()
	end
   print("尝试恢复精")
     local l,w=wait.regexp("^(> |)你深深吸了几口气，精神看起来好多了。$|^(> |)你现在精神饱满。$",2)
	 if l==nil then
	   self:yunjing()
	   return
     end
	 if string.find(l,"你深深吸了几口气，精神看起来好多了") or string.find(l,"你现在精神饱满") then
	   self.run_yunjing=false
	   --world.Send("alias pfm "..self.current_alias)
       --self:check()
	   self:reset()
	   self:check_resume()
	   return
	 end
     wait.time(2)
   end)
end

function fight:refresh()
 wait.make(function()
    if self.run_refresh==false then
	   self.run_refresh=true
	   self:reset()
	end
   print("尝试恢复精力")
     local l,w=wait.regexp("^(> |)你长长地舒了一口气。$|^(> |)你现在精力充沛。$",2)
	 if l==nil then
	   self:refresh()
	   return
     end
	 if string.find(l,"你长长地舒了一口气") or string.find(l,"你现在精力充沛") then
	   self.run_refresh=false
	   --world.Send("alias pfm "..self.current_alias)
       --self:check()
	   self:reset()
	   print("refresh resume check")
	   self:check_resume()
	   return
	 end
     wait.time(2)
   end)
end

--武功对应表
--读取武功对应列表

function fight:po_enemy_skills(skillname)
   --敌人的技能名称 使用的pfm1-pfm5  使用pfm1_list 切换顺序
   --返回值 1 pfm1-pfm5 2 pfm1_list pfm5_list
   local all_skills_list=world.GetVariable("all_skills_list") or ""
   --print(all_skills_list)
   if all_skills_list==nil or all_skills_list=="" then
      return nil,nil
   end
   local l={}
   l=Split(all_skills_list,"|")
   for _,i in ipairs(l) do
       --print(i)
       local item={}
	   item=Split(i,"#")

	   if item[1]==skillname then
	      --print(item[2],item[3],"->",skillname)
	      return item[2],item[3]
	   end
   end
   return nil,nil
end

