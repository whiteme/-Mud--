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
		print("ս������")
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
  pfm_list="",  --��������б�
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
  pfm_threads={}, --pfm ����
}
fight.__index=fight
--[[
		// ����
		case "7bug_poison"	: name = "�߳����ɢ"; break;
		case "bee_poison"	: name = "��䶾"; break;
		case "bing_poison"	: name = "�������붾"; break;
		case "bt_poison"	: name = "���߶�"; break;
		case "cold_poison"	: name = "����"; break;
		case "fs_poison"	: name = "��ʬ��"; break;
		case "hb_poison"	: name = "�������ƶ�"; break;
		case "huagu_poison"	: name = "�������ƶ�"; break;
		case "hot_poison"	: name = "��"; break;
		case "lvbo_poison"	: name = "�̲���¶�涾"; break;
		case "man_poison"	: name = "�����ܻ���"; break;
		case "qianli_poison"	: name = "ǧ������ɢ"; break;
		case "qtlh_poi"		: name = "�����޻���"; break;
		case "qzhu_poison"	: name = "ǧ�����ֶ�"; break;
		case "sanxiao"		: name = "��Ц��ңɢ��"; break;
		case "sl_poison"	: name = "������"; break;
		case "snake_poison"	: name = "�߶�"; break;
		case "sxs_poison"	: name = "��Цɢ֮��"; break;
		case "sy_poison"	: name = "����ӡ�ƶ�"; break;
		case "tz_poison"	: name = "���ƶ�"; break;
		case "warm_poison"	: name = "�ȶ�"; break;
		case "xx_poison"	: name = "�����ƶ�"; break;
		case "wh_poison"	: name = "�������ж�"; break;

		case "xuanmin_poison"	: name = "��ڤ���ƺ���"; break;
		case "xx_poison"	: name = "�����ƶ�"; break;
		case "wh_poison"	: name = "�������ж�"; break;

		// ����
		case "broken_arm"	: name = "����"; break;
		case "dgb_ban_wound"	: name = "�򹷰�����"; break;
		case "fugu_poison"	: name = "��Ѫ���Ƿ�"; break;
		case "dsy_poison"	: name = "����ӡ����"; break;
		case "huagong"		: name = "����������"; break;
		case "hunyuan_hurt"	: name = "��Ԫ������"; break;
		case "hyd_condition"    : name = "���浶����"; break;
		case "juehu_hurt"	: name = "��צ��������"; break;
		case "neishang"		: name = "����"; break;
		case "nxsz_hurt"	: name = "��Ѫ��צ����"; break;
		case "qiankun_wound"	: name = "��ָ��ͨ����"; break;
		case "qishang_poison"	: name = "����ȭ����"; break;
		case "ruanjin_poison"	: name = "���ɢ��"; break;
		case "yyz_hurt"		: name = "һ��ָ����"; break;
		case "yzc_qiankun"	: name = "һָ���ھ�"; break;
		// æ��
		case "no_exert"		: name = "����"; break; �����л��ڹ� jifa force
		case "no_perform"	: name = "����"; break; ����pfm
		case "no_force"		: name = "��Ϣ����";break; ����yun
		//������
		case "ill_fashao"	: name = "����"; break;
		case "ill_kesou"	: name = "����"; break;
		case "ill_shanghan"	: name = "�˺�"; break;
		case "ill_zhongshu"	: name = "����"; break;
		case "ill_dongshang"	: name = "����"; break;		]]

--ս������ ����ִ��Ƶ�� 0.1
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

local msg={"��������Ѫ��ӯ����û�����ˡ�","�ƺ����˵����ˣ��������������������","�������������˵����ˡ�","���˼����ˣ������ƺ��������¡�",
"���˲��ᣬ������״������̫�á�","��Ϣ���أ�������ʼɢ�ң��������ܵ�����ʵ���ᡣ","�Ѿ��˺����ۣ���������֧���Ų�����ȥ��","�����൱�ص��ˣ�ֻ�»�������Σ�ա�",
"����֮���Ѿ�����֧�ţ��ۿ���Ҫ���ڵ��ϡ�","���˹��أ��Ѿ�����һϢ�����ڵ�Ϧ�ˡ�","���˹��أ��Ѿ�������в�����ʱ�����ܶ�����",
"����������������һ��Ҳ���ۡ�","�ƺ���Щƣ����������Ȼʮ���л�����","������������Щ���ˡ�","�����ƺ���ʼ�е㲻̫��⣬������Ȼ�������ɡ�",
"�������꣬������״������̫�á�","�ƺ�ʮ��ƣ����������Ҫ�ú���Ϣ�ˡ�","�Ѿ�һ��ͷ�ؽ����ģ������������֧���Ų�����ȥ��","�������Ѿ����������ˡ�",
"ҡͷ���ԡ�����бб��վ��վ���ȣ��ۿ���Ҫ���ڵ��ϡ�","�Ѿ���������״̬����ʱ������ˤ����ȥ��",}
function fight:status_msg()
  print("status_msg")
  local regexp=""
  for _,reg in ipairs(msg) do
      regexp=regexp.."\\( ��"..reg.." \\)|"
  end
  regexp=regexp.."^(> |)����������������ˣ�$"
  --regexp=string.sub(regexp,1,-2)
  --print(regexp)
  wait.make(function()
    local l,w=wait.regexp(regexp,5)
    if l==nil then
	  self:status_msg()
	  return
	end
	if string.find(l,"��������Ѫ��ӯ����û������") then
	   self.ratio=100
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�ƺ����˵����ˣ������������������") then
	   self.ratio=90
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�������������˵�����") then
	   self.ratio=80
	   self:hurt()
	   self:status_msg()
	   return
	end

	if string.find(l,"���˼����ˣ������ƺ���������") then
	   self.ratio=70
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"���˲��ᣬ������״������̫��") then
	   self.ratio=60
	   self:status_msg()
	   return
	end
	if string.find(l,"��Ϣ���أ�������ʼɢ�ң��������ܵ�����ʵ����") then
	   self.ratio=50
	   self:hurt()
	   self:status_msg()
	   return
	end

	if string.find(l,"�Ѿ��˺����ۣ���������֧���Ų�����ȥ") then
	   self.ratio=40
	   self:hurt()
	   self:status_msg()
	   return
	end

	if string.find(l,"�����൱�ص��ˣ�ֻ�»�������Σ��") then
	   self.ratio=30
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"����֮���Ѿ�����֧�ţ��ۿ���Ҫ���ڵ���") then
	   self.ratio=20
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"���˹��أ��Ѿ�����һϢ�����ڵ�Ϧ��") then
	   self.ratio=10
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"���˹��أ��Ѿ�������в�����ʱ�����ܶ���") then
	   self.ratio=0
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"����������������һ��Ҳ����") then
	   self.ratio=99
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�ƺ���Щƣ����������Ȼʮ���л���") then
	   self.ratio=88
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"������������Щ����") then
	   self.ratio=77
	   self:hurt()
	   self:status_msg()
	   return
	end

	if string.find(l,"�����ƺ���ʼ�е㲻̫��⣬������Ȼ��������") then
	   self.ratio=66
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�������꣬������״������̫��") then
	   self.ratio=55
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�ƺ�ʮ��ƣ����������Ҫ�ú���Ϣ��") then
	   self.ratio=44
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�Ѿ�һ��ͷ�ؽ����ģ������������֧���Ų�����ȥ") then
	   self.ratio=33
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�������Ѿ�����������") then
	   self.ratio=22
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"ҡͷ���ԡ�����бб��վ��վ���ȣ��ۿ���Ҫ���ڵ���") then
	   self.ratio=11
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�Ѿ���������״̬����ʱ������ˤ����ȥ") then
	   self.ratio=1
	   self:hurt()
	   self:status_msg()
	   return
	end
	if string.find(l,"�����������������") then
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
     local l,w=wait.regexp("( ��ҡͷ���ԡ�����бб��վ��վ���ȣ��ۿ���Ҫ���ڵ��ϡ� )|( ���Ѿ���������״̬����ʱ������ˤ����ȥ�� )|( ���Ѿ�һ��ͷ�ؽ����ģ������������֧���Ų�����ȥ�� )|( ���ƺ�ʮ��ƣ����������Ҫ�ú���Ϣ�ˡ� )|( �㿴�����������˵����ˡ� )|( ���������꣬������״������̫�á� )|( �㿴�����Ѿ����������ˡ� )|^(> |)����������������ˣ�$",10)
	  if l==nil then
	     self:injure()
	     return
	  end
	  if string.find(l,"��ҡͷ���ԡ�����бб��վ��վ���ȣ��ۿ���Ҫ���ڵ���") or string.find(l,"���Ѿ���������״̬����ʱ������ˤ����ȥ") or string.find(l,"���ƺ�ʮ��ƣ����������Ҫ�ú���Ϣ��") or string.find(l,"���Ѿ�һ��ͷ�ؽ����ģ������������֧���Ų�����ȥ") or string.find(l,"�㿴�����������˵�����") or string.find(l,"���������꣬������״������̫��") or string.find(l,"�㿴�����Ѿ�����������")then
		self.run_recover=true
		self:injure()
	    return
	  end
	  if string.find(l,"�����������������") then
	       world.Send("yun jingli")
	       self.run_refresh=true
		   self:injure()
	    return
	  end
	 wait.time(10)
   end)
end]]

--������û������������^?????*˳�ƶ�����
--^{> ��|��}*���������ذ���
--^{> ��|��}��ʱ����ѹ������������һ�飬����*���ֶ�����
--^{> ֻ|ֻ}�������������죬��*һ���ѳֲ������ַ�
--ֻ���ú�Τ���ֿ�ס������ţ����ַ���һ��һ�㣬��ȡ���������ϪѨ��
--��ֻ������һ�����飬���е�������Ҳ�ѳֲ�ס�����һ���������˵��ϡ�
--ֻ����������һ�������ֱ�һ�飬����̫���������䵽���¡�
--��Ҫ��ʲô�����ࣿ
--�ź����г��������߰��������ߣ�ֻ�Ŷ���֮����������������һ�������ȷ��������еı����
--�ź�˳�ƶ����ı���������鼱�Ǳ�֮�ʣ�������ס�����ʹ����Ů�����ٹ����С�
--�������ֱ�����һק������������ȴ�޷��ӳ��޵Ĳ������ѿ����鼱֮��ֻ�÷��������еı��С�

function fight:lost_weapon_name(weapon_name)
   print("lost weapon name")
   local weapon_id
   if string.find(weapon_name,"��") then
      weapon_id="sword"
   elseif string.find(weapon_name,"��") then
      weapon_id="blade"
   elseif string.find(weapon_name,"��") then
      weapon_id="xiao"
   elseif string.find(weapon_name,"��") then
      weapon_id="staff"
   elseif string.find(weapon_name,"��") then
      weapon_id="stick"
   elseif string.find(weapon_name,"ذ") then
      weapon_id="dagger"
   elseif string.find(weapon_name,"��") then
      weapon_id="axe"
   elseif string.find(weapon_name,"��") then
      weapon_id="bi"
   elseif string.find(weapon_name,"��") then
      weapon_id="nao"
   elseif string.find(weapon_name,"��") then
      weapon_id="hammer"
   elseif string.find(weapon_name,"��") then
      weapon_id="falun"
   elseif string.find(weapon_name,"��") or string.find(weapon_name,"�") then
      weapon_id="whip"
   elseif string.find(weapon_name,"��") then
      weapon_id="club"
   elseif string.find(weapon_name,"ǹ") then
       weapon_id="spear"
   end
   print(weapon_name," ",weapon_id)
   if weapon_name=="ľ��" then
       weapon_id="mu jian"
   end
   if weapon_name=="������" then
       weapon_id="youlong bian"

   end
   table.insert(self.lost_weapon_id,weapon_id)

end
local weapon_lost="^(> |)��ֻ��(.*)�������ַɳ���һ�����ղ�ס�����б����������˳�ȥ��$|^(> |)��ı�����.*һѹһ����ɲ�Ǽ�(.*)�ѱ�.*���£�$|^(> |)�������ֱ�����һק��(.*)ȴ�޷���.*�Ĳ������ѿ����鼱֮��ֻ�÷��������еı��С�$|^(> |).*����.*�����߰��������ߣ�ֻ�Ŷ���֮����������������һ�������ȷ��������е�(.*)��$|^(> |)��ֻ������һ�����飬���е�(.*)��Ҳ�ѳֲ�ס�����һ���������˵��ϡ�$|^(> |)���ʱ����ѹ������������һ�飬����(.*)���ֶ�����$|^(> |)��ֻ�����ֱ�һ�飬�ѱ�.*������Ѩ�������������ذ����е�(.*)׹�أ�$|^(> |).*˳�ƶ�����(.*)�������鼱�Ǳ�֮�ʣ�������ס.*$|^(> |)ֻ�������������죬�����е�(.*)�Ѿ���.*����һ���ѳֲ������ַɳ���$|^(> |)���޷������мܣ�������������.*�����Լ��ʺ�ֻ��Ʋ��(.*)���͵�һ��.*$|^(> |)ֻ����������һ�������ֱ�һ�飬(.*)�����䵽���¡�$|^(> |)������Ϯ��һ���ѳֲ�ס��(.*)���ֶ��������´󾪣���ʱ��æ���ң�$|^(> |)��ֻ���������ʹ������(.*)��Ҳ����ס�����ֶ�����$|^(> |)�㱻.*һ�����������ɵ�������,ֻ����(.*)����һ�ߡ�$"
weapon_lost=weapon_lost.."|^(> |)��ֻ��һ�ɴ���Ϯ�����۰��ʹ������(.*)��Ҳ����ס�����ֶ�����$"
weapon_lost=weapon_lost.."|^(> |)��ֻ������һ���ʹ��Ǻ�һ����(.*)���ֶ�����$"
weapon_lost=weapon_lost.."|^(> |)��ֻ���û���һ�ȣ����ƻ��ھ�ʹ������(.*)���ֶ�����$"
--��ı������ۺ������һѹһ����ɲ�Ǽ��ӧ������ǹ�ѱ��ۺ���¡�
function fight:lost_weapon()
--��ֻ�г����������ַɳ���һ�����ղ�ס�����б����������˳�ȥ��
--�����ı���������������һѹһ���������ѱ��������£�
--��ֻ�����ֱ�һ�飬�ѱ�ٻƼ��ķɻ�ʯ������Ѩ�������������ذ����е�����Ǭ����׹�أ�
   wait.make(function()
     local l,w=wait.regexp(weapon_lost,5)
     if l==nil then
	   self:lost_weapon()
	   return
	 end
	 --�㱻������ӫ���а�ɱذ��һ�����������ɵ�������,ֻ����ѩɽ���µ�����һ�ߡ�
	 --�㱻������ӫ���а�ɱذ��һ�����������ɵ�������,ֻ����ѩɽ���µ�����һ�ߡ�
	 --��ֻ���������ʹ��������ѩ����Ҳ����ס�����ֶ�����
	 if string.find(l,"����") or string.find(l,"����") or string.find(l,"���������еı���") or string.find(l,"���ȷ��������е�") or string.find(l,"��ֻ������һ������") or string.find(l,"���ʱ����ѹ������") or string.find(l,"�ֱ�һ��") or string.find(l,"˳�ƶ�����") or string.find(l,"����һ���ѳֲ������ַɳ�") or string.find(l,"���޷������м�") or string.find(l,"���ֶ���") or string.find(l,"����һ��") then
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
		--log(""..player_id.."�����¼.txt",string.format("��"..player_name.."("..player_id..")��������ʧ:"..test.."\r\n"))
		--world.AppendToNotepad (WorldName(),os.date()..": ������ʧ:"..test.."\r\n")
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
	     if weapon_name=="�����" then
	      weapon_name=world.GetVariable("mark_weapon_name") or ""
	   end
	   self.losting_weapon=weapon_name
 	   self.is_duo=true
	   self:lost_weapon_name(weapon_name)
	   self:lost_weapon()
	     --����
		 print("�Զ�ʰȡ����")
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
	 print("�Զ�ʰȡ����2")
	self.current_alias=self.unarmed_alias
	self:reset()
end

function fight:unarmedpfm()

	   local sp=special_item.new()
	   sp.cooldown=function()
          print("ʹ�ÿ��ּ���")
		   self.current_alias=self.unarmed_alias
	       --world.Send("alias pfm "..self.current_alias)
		   self:reset()
	   end
	   sp:unwield_all()
end
--��ʧ�����У�����ղ������񹦣�����æ�������ܡ�
function fight:idle()
--һ��ů�����Ե�������ȫ�����������ָֻ���֪������
--������Լ�����ʶԽ��Խ����������ʡ�����ˡ�����
   wait.make(function()
      local l,w=wait.regexp("^(> |)һ��ů�����Ե�������ȫ�����������ָֻ���֪������$",5)
	  if l==nil then
	     self:idle()
	     return
	  end
	  if string.find(l,"һ��ů�����Ե�������ȫ��") then
		 print("fight:ս������")
		 if self.status=="��ת" then
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
     world.Send("set action ��ҩ")
    wait.make(function()
     local l,w=wait.regexp("^(> |)�����һ��.*����ʱ�������������˲��١�$|^(> |)�����һ�Ŵ�����Ϣ�裬��ʱ�о��������档$|^(> |)����æ���ء�$|^(> |)���ϴε�ҩ������û���أ��Ȼ���ٷ��ðɡ�$|^(> |)�趨����������action = \\\"��ҩ\\\"$",5)
     if l==nil then
	   self:eat_wan(true)
	   return
	 end

	 if string.find(l,"�����һ��") then
       print("������Ϣ��")
	   self.running=false
	   return
	 end
	 if string.find(l,"����æ����") then
	   local f=function()
	     --self.running=false
	     self:eat_wan(true)
	   end
	   f_wait(f,0.8)
	   return
	 end
	 if string.find(l,"���ϴε�ҩ������û���أ��Ȼ���ٷ��ð�")  then
	    self:neili_lack()
	   return
	 end
	 if string.find(l,"�趨����������action") then
	   self:neili_lack()
	   return
	 end
   end)
end

function fight:neili_lack()  --�ص�����

end
--����������������ˣ�
--����������̫����ʹ�����������������
function fight:run()
  --print("ս���쳣���")
  wait.make(function()
   --( ���ƺ�ʮ��ƣ����������Ҫ�ú���Ϣ�ˡ� )> �㲻��ս���С�
   --( ���Ѿ�һ��ͷ�ؽ����ģ������������֧���Ų�����ȥ�� )
   --���������˼���������ɫ�������ö��ˡ�
   --( �㿴�����������˵����ˡ� )�����������ֻ����ս����ʹ�á�
   --�߽�����ָֻ�ܶ�ս���еĶ���ʹ�á�
   --���������֡�����ֻ�ܶ�ս���еĶ���ʹ�á�
      --> ���������ơ�ֻ����ս�����á���ֻ����ս����ʹ�á��Ա�֮��
	 -- world.Send(self.cmd)
	 --��������������޷�ʩչ����Ӱ��
	  if self.auto_perform==true then
	    world.Execute(self.current_alias)
	  end
	   local regexp="^(> |)�㲻��ս���С�$|^(> |)�����Ѫ���㡣$|^(> |)����������㣬����ʩչ.*$|^(> |)�������������$|^(> |)�������������$|^(> |)��ľ��������ˣ�$|^(> |)��ľ����������޷�ʩչ.*$|^(> |)����������������ˣ�$|^(> |)����������̫����ʹ����.*��$|^(> |)��ľ������㣬����ʩչ.*$|^(> |)����ʹ�õ��⹦��û�����ֹ��ܡ�$|^(> |)�����ھ������㣬����ʹ��.*$|^(> |)������������ô��ʹ��.*$|^(> |)��ʹ�õ��������ԣ�����ʩչ.*$|^(> |)ֻ�п��ֲ���ʩչ.*$|^(> |)��������ʹ��.*$|^(> |)ʹ��.*ʱ�������.*$|^(> |)�����ﲻ�ܹ������ˡ�$|^(> |)�������ֲ���ʹ��.*$|^(> |)����Ҫ��˭���ࣿ$|^(> |)��ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪���ˡ���$|^(> |)��ľ����������޷�ʩչ.*$|^(> |)��ֻ�ܿ�������.*$|^(> |)��������������.*$|^(> |)������޷���ʹ�ñ����Ķ���ʹ�á��Ա�֮�� ��ʩ����������$|^(> |)���������ڲ���.*$|^(> |)�������̫����.*$|^(> |)��ľ���������$|^(> |)�����ڵ������޷�ʹ��.*$|^(> |)��������������޷�ʩչ.*$|^(> |)����������㣬�޷�ʹ��.*��$|^(> |)������� enable һ���ڹ���$|^(> |)�������������$|^(> |)��û��ʹ�����������ʩչ.*$|^(> |)��������������޷�ʩչ.*$|^(> |).*������ͻȻ�������Σ����ظ�������������$|^(> |)�������ʹ�ý�ʱ����ʹ�������߿��衹��$|^(> |)��ֻ��һ�ֱ����������������з���$|^(> |)���ȷ������е�������˵�ɣ���$|^(> |)��ʹ�õ��������ԡ�$"
      local l,w=wait.regexp(regexp,5)
	  if l==nil then
	    self:run()
	    return
	  end
	  if string.find(l,"����ͻȻ�������Σ����ظ�����������") then
	     local player_id=world.GetVariable("player_id")
	       if string.lower(player_id) == "she" then
	       world.Send("unset ��ɽѩ��")
	       end
	    self:run()
	    return
	  end
	  if  string.find(l,"����Ҫ��˭����") or string.find(l,"�����ﲻ�ܹ�������") then
	    print("fight:ս������")
		world.Send("unset wimpy")
	    self:finish()
	    return
	  end
	  if string.find(l,"�����Ѫ����") then
	    world.Send("yun recover")
	    self:run()
	    return
	  end
	  if string.find(l,"�����������") or string.find(l,"�����������") or string.find(l,"�����������") or string.find(l,"�����������") or string.find(l,"�����������") or string.find(l,"����������̫��") or string.find(l,"��������������") or string.find(l,"���������ڲ���") or string.find(l,"�������̫����") then
		self:eat_wan()
		local f
		f=function()
		   self:run()
		end
		f_wait(f,0.8)
	    return
	  end
	  if string.find(l,"��ľ�������") or string.find(l,"�����������������") or string.find(l,"��ľ�������") or string.find(l,"�����ھ�������") or string.find(l,"��ľ�������") then
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
	  if string.find(l,"������� enable һ���ڹ�") then
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
	   if string.find(l,"�������ʹ�ý�ʱ") or string.find(l,"�����ڵ������޷�ʹ��") or string.find(l,"��ʹ�õ���������")  or string.find(l,"���ȷ������е�������˵��") or string.find(l,"����ʹ�õ��⹦��û�����ֹ���") or string.find(l,"������������ô") or string.find(l,"����") or string.find(l,"ֻ��һ�ֱ����������������з�") then --string.find(l,"������ȷ�����Ŀǰװ��������")  ^(> |)������ȷ�����Ŀǰװ����������$|
	    print("��������!")
	    self:no_pfm()
	    return
	  end
	  --������û�н����޷�ʹ���߽�����ָ��
	  if string.find(l,"������޷���ʹ�ñ����Ķ���ʹ��") or string.find(l,"��û��ʹ�����������ʩչ") then
	     print("������ʧ")
	     self:unarmedpfm()
	     return
	  end
	   if string.find(l,"��ֻ����ͷ�����ͣ���ǰһ�ڣ�����ʲôҲ��֪����") then
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
   self.current_alias=string.gsub(self.current_alias," @id",target) --ָ��id
   world.SetVariable("pfm",self.current_alias)
   if self.run_flee==true then
     print("�������ܣ���")
   elseif self.run_recover==true and is_recover==false then
      world.Send("alias pfm yun qi;"..self.current_alias)
   elseif self.run_yunjing==true then
      world.Send("alias pfm yun jing;"..self.current_alias)
   elseif self.run_refresh==true then
      world.Send("alias pfm yun jingli;"..self.current_alias)
   else
      print("ɾ�� ����")
      self.current_alias=string.gsub(self.current_alias,"yun qi;","")
	  self.current_alias=string.gsub(self.current_alias,"yun jingli;","")
	  self.current_alias=string.gsub(self.current_alias,"yun jing;","")
      world.Send("alias pfm "..self.current_alias)
	  world.SetVariable("pfm",self.current_alias)
   end
end

function fight:enemy_busy() --�ص�����
end

function fight:enemy_yunqi()
   wait.make(function()
     local l,w=wait.regexp("^(> |)"..self.enemy_name.."�������˼���������ɫ�������ö��ˡ�$",5)
	 if l==nil then
	    self:enemy_yunqi()
	    return
	 end
	 if string.find(l,"�������˼�����") then
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
    print("ս����ʼ")
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
       world.ColourNote ("red", "yellow", "�Զ�����")
       world.Send(self.current_alias)
       world.ColourNote ("red", "blue", "���ֽ���")
     end
     f_wait(f,0.1)
   end]]
   if self.pfm_list~="" and self.pfm_list~=nil then
     --�������
	    self:create_combine_list(self.pfm_list) --��������б�
		--
		self:catch_pfm()
   end
   wait.make(function()
   --( ���ƺ�ʮ��ƣ����������Ҫ�ú���Ϣ�ˡ� )> �㲻��ս���С�
   --( ���Ѿ�һ��ͷ�ؽ����ģ������������֧���Ų�����ȥ�� )
   --���������˼���������ɫ�������ö��ˡ�
   --( �㿴�����������˵����ˡ� )�����������ֻ����ս����ʹ�á�
   --�߽�����ָֻ�ܶ�ս���еĶ���ʹ�á�
   --���������֡�����ֻ�ܶ�ս���еĶ���ʹ�á�
      --> ���������ơ�ֻ����ս�����á�  �����򲻻����أ���ôɱ��( �����򲻻����أ�ʩ���⹦���)
	  --���������ڲ���, ����ʹ���黨��Ѩ��
       --�������̫���ˣ��޷�ʹ�ó����ļ�ɢ������
       --�����Ĵ󷨡�ֻ�ܶ�ս���еĶ���ʹ�á�
	   --������û�н����޷�ʹ���߽�����ָ��
	  local regexp="^(> |)�㲻��ս���С�$|^(> |)�����Ѫ���㡣$|(> |)��ֻ����ս����ʹ��.*��$|^(> |).*ֻ����ս����(ʹ|)�á�$|^(> |)����������㣬����ʩչ.*$|^(> |)�������������$|^(> |)��ľ��������ˣ�$|^(> |)��ľ����������޷�ʩչ.*$|^(> |)����������������ˣ�$|^(> |)����������̫����ʹ����.*��$|^(> |)��ľ������㣬����ʩչ.*|^(> |)(.*)([^�����Ĵ󷨡�])ֻ��(��|��)ս����(��|��)����ʹ�á�$|^(> |)����ʹ�õ��⹦��û�����ֹ��ܡ�$|^(> |)�����ھ������㣬����ʹ��.*$|^(> |)����Ҫ��˭���ࣿ$|^(> |)������ȷ�����Ŀǰװ����������$|^(> |)������������ô��ʹ��.*$|^(> |)��������ʹ��.*$|^(> |)ʹ��.*ʱ�������.*$|^(> |)�����ﲻ�ܹ������ˡ�$|^(> |)�������ֲ���ʹ�á�.*����$|^(> |)ֻ�п��ֲ���ʩչ.*|^(> |)����Ҫ��˭���ࣿ$|^(> |).*ֻ����ս��ʱ�ã�$|^(> |)��ľ����������޷�ʩչ.*$|^(> |)���������ڲ���.*$|^(> |)�������̫����.*$|^(> |)���Ҳ��ܶ��飬��Ӱ�������Ϣ��$|^(> |)������� enable һ���ڹ���$|^(> |)��û��ʹ�����������ʩչ.*$|^(> |)��ʹ�õ��������ԣ�����ʩչ.*$|^(> |)��ʹ�õ��������ԡ�$|^(> |)�������ֲ���ʹ��.*|^(> |)������û��.*���޷�ʹ��.*$|^(> |)��ʹ���ˡ�������ô?$|^(> |)�㲻�ñ�����ôʹ�á�����������$|^(> |)��װ�����������ԣ��޷�ʩչ�����������֡���$"
     if self.check_pfm==false then
        regexp="^(> |)�����Ѫ���㡣$|^(> |)����������㣬����ʩչ.*$|^(> |)�������������$|^(> |)��ľ��������ˣ�$|^(> |)����������������ˣ�$|^(> |)����������̫����ʹ����.*��$|^(> |)��ľ������㣬����ʩչ.*|^(> |)��ľ����������޷�ʩչ.*$|^(> |)����ʹ�õ��⹦��û�����ֹ��ܡ�$|^(> |)�����ھ������㣬����ʹ��.*$|^(> |)������������ô��ʹ��.*$|^(> |)��������ʹ��.*$|^(> |)ʹ��.*ʱ�������.*$|^(> |)�������ֲ���ʹ�á�.*����$|^(> |)��ľ����������޷�ʩչ.*$|^(> |)ֻ�п��ֲ���ʩչ.*$|^(> |)��������������޷�ʩչ��.*$|^(> |)������� enable һ���ڹ���$|^(> |)�������������$|^(> |)��û��ʹ�����������ʩչ.*$|^(> |)��ʹ�õ��������ԣ�����ʩչ.*$"
	 end
	 local l,w=wait.regexp(regexp,2)
	  if l==nil then
	    self:run()
	    return
	  end

	  if string.find(l,"���Ҳ��ܶ��飬��Ӱ�������Ϣ") or string.find(l,"�����ﲻ�ܹ�������") or string.find(l,"��ֻ����ս����ʹ��") or string.find(l,"ֻ����ս����") or string.find(l,"�㲻��ս����") or string.find(l,"ֻ�ܶ�ս���еĶ���ʹ��") or string.find(l,"����Ҫ��˭����") or string.find(l,"ս��ʱ��") then
		print("fight:ս������")
		world.Send("unset wimpy")
		self:finish()
	    return
	  end
	  if string.find(l,"�����Ѫ����") then
	    world.Send("yun recover")
	    self:run()
	    return
	  end
	  if string.find(l,"������� enable һ���ڹ�") then
	    world.Send("jifa all")
	    self:run()
	    return
	  end
	  if string.find(l,"�����������") or string.find(l,"�����������") or string.find(l,"�����������") or string.find(l,"����������̫��") or string.find(l,"���������ڲ���") or string.find(l,"�������̫����") then
		self:eat_wan()
		local f
		f=function()
		   self:run()
		end
		f_wait(f,0.8)
	    return
	  end
	  if string.find(l,"��ľ�������") or string.find(l,"�����������������") or string.find(l,"��ľ�������") or string.find(l,"��ľ�������") then
	    self:refresh()
		local f
		f=function()
		   self:run()
		end
		f_wait(f,0.8)
	    return
	  end --��ʹ���ˡ�������ô?
	  if string.find(l,"��װ������������") or string.find(l,"����ʹ�õ��⹦��û�����ֹ���") or string.find(l,"������������ô") or string.find(l,"����")  or string.find(l,"��ʹ�õ��������ԣ�����ʩչ") or string.find(l,"����") then --string.find(l,"������ȷ�����Ŀǰװ��������")
		 if self.dazhuan==false then
		    print("��������!")
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
	  if string.find(l,"��û��ʹ�����������ʩչ") or string.find(l,"��ʹ�õ���������") or string.find(l,"������û��") or string.find(l,"�㲻�ñ�����ôʹ��") then
	  self:unarmedpfm()
	  return
	  end
   end)
end
--����ʹ�õ��⹦��û�����ֹ��ܡ�
--> ����������㣬����ʩչ���������ơ���
function fight:no_pfm()
   if self.is_duo==true then
      print("������ʧ�����޷�ʩ��")
	  self.current_alias=self.unarmed_alias
	  --world.Send("..self.current_alias2..")
	  --world.Send("alias pfm get "..self.weapon_id..";"..self.current_alias)
	  self:reset()
   else
       local sp=special_item.new()
	   sp.cooldown=function()
	        print("�жϣ�pfm����")
		    self:run()
	   end
	   sp:unwield_all()
   end
end

function fight:finish()

end

--���˳̶�?
function fight:damage(percent)

end
--������޷���ʹ�ñ����Ķ���ʹ�á��Ա�֮�� ��ʩ����������
function fight:check()
 fight.check_co=coroutine.create(function()
    local h=hp.new()
	 self.hp=h
     h.checkover=function()
       print("���˳̶�",h.qi_percent)
       self.damage(h) --���˳̶�
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
--����ȭ����|����|���浶����|һָ���ھ�|�߶�|��Ϣ����|����|����|����|�������ƶ�|�����ܻ���|�򹷰�����

function fight:combat_end(f)
   wait.make(function()
	 local l,w=wait.regexp("^(> |)����Ҫ����������ͻȻ�������˽���һ�ģ��úÿ����䣬���Ҷ���$|^(> |)��Ҫ��ʲô��$|^(> |)���޷���ս����ר�������ж���֪��$|^(> |)���ﲻ�ܶ��飡$|^(> |)���޷���������������$|^(> |)���Ҳ��ܶ��飬��Ӱ�������Ϣ��$|^(> |)�����صأ�������ˣ�$|^(> |)�����������������뾲���޹ص����飡$",5)
	 if l==nil then
	    self:resume_combat_check()
	    return
	 end
	 if string.find(l,"����������") or string.find(l,"��Ҫ��ʲô") or string.find(l,"���ﲻ�ܶ���") or string.find(l,"���Ҳ��ܶ���") or string.find(l,"�����ص�") or string.find(l,"����Ҫ��������") then
	   self:close_combat_check()
	   print("ս������")
	   self:finish()
	   return
	 end
	 if string.find(l,"���޷�������������") then
	   world.Send("jifa all")
	   self:close_combat_check()
	   print("ս������")
	   if self.pfm_list~="" and self.pfm_list~=nil then
	      self:clear_pfm_list()
	   end
	   self:finish()
	    return
	 end
	 if string.find(l,"���޷���ս����ר�������ж���֪") then
	   --self:test_combat()
	   --print(check_time.."s �ٴμ��")
	   f_wait(f,self.check_time) --�ӳ�30���ִ��
	   return
	 end
  end)
end


function fight:combat_check() --ս�����  test_combat �����Ժ��Զ�ʧЧ
  local wait_id = "combat_timer_" .. GetUniqueNumber ()
  _id=wait_id
  local f=function()
	   --print(coroutine.status(combat_table[id]))
	   --local status=coroutine.status(combat_table[id])
	   --if status=="suspended" then --���̱��������ѽ���
	   --print("id:",wait_id)
	   --print("co:",combat_table[wait_id])
	   if combat_table[wait_id]~=nil then
	     local status=coroutine.status(combat_table[wait_id])
		 --print(status)
		 if status=="suspended" then
		   print(self.check_time.." s ��"..wait_id.."���")
		   local f2=function() self:resume_combat_check() end
	       f_wait(f2,self.check_time) --�ӳ�30���ִ��
		 else
		  print(wait_id,"->",status)
		 end
	   end
  end
  combat_table[wait_id]=coroutine.create(function()
    print("ս����⿪��",wait_id)
	f_wait(f,self.check_time) --�ӳ�30���ִ��
	local run=true
	while run do
	  print("�ȴ�"..self.check_time.."s ��⣡��")
	  run=coroutine.yield()
	  world.Send("du")
	  self:combat_end(f)
	end
	print("�˳�����:"..wait_id)
	combat_table[wait_id]=nil--clear
  end)
  coroutine.resume(combat_table[wait_id],true)  --��������
end

function fight:resume_combat_check()
   if combat_table[_id] and coroutine.status(combat_table[_id])=="suspended" then
     coroutine.resume(combat_table[_id],true)  --��������
   end
end

function fight:close_combat_check()
   if combat_table[_id] and coroutine.status(combat_table[_id])=="suspended" then
      coroutine.resume(combat_table[_id],false) --�رյ� combat_check ����
   end
end

function fight:fight_reset()
end

function fight:halt_fight() --��ֹս��
    print("���ţ����� ��Ϣ����")
	self.fight_reset=function()
	       print("reset")
		   if self.fightcmd~="" then
		     print("unset wimpy")
		     world.Execute("unset wimpy;"..self.fightcmd..";set wimpy 100")
		   end
		   -- �����µ�combat_check ����
		   self:combat_check()
		   self:resume_combat_check()
		   self.fight_reset=function() end
	 end
     print("�ر�combat_check:id=".._id)
	 self:close_combat_check()

	 world.Send("halt")
	 local f=function()
	   world.Send("cond")
       self:cond()
	 end
	 f_wait(f,0.5)
end

function fight:cond()
--������û�а����κ�����״̬�������ϰ�����������״̬��
   --world.Send("cond") ͨ��wimpycmd ����condָ�� �Է��Ѿ��������ˣ��㲻�����á���������ˡ�
    wait.make(function()
      local l,w=wait.regexp("\\��.*��Ϣ����.*\\||\\��.*����.*\\||\\|.*����.*\\||\\��.*һָ���ھ�.*\\||^(> |)��ǰ��û�б��ж�Ϊ�����ˡ�$|^(> |)�㱻�ж�Ϊ�����ˣ��Ͽ���robot�����ٻ�һ�������ɡ�$",2)
	  if l==nil then
	     self:cond()
	     return
	  end
	 --[[ if string.find(l,"��Ϣ����") or string.find(l,"����") or string.find(l,"����") or string.find(l,"����") then
		print("busy ״̬�� halt")
	    self:halt_fight()
		return
	  end
	  ]]
	   if string.find(l,"��Ϣ����") or string.find(l,"����") or string.find(l,"����") or string.find(l,"һָ���ھ�") then
		print("busy ״̬�� halt")
		   shutdown()
		  world.Send("unset wimpy")
		  world.Send("halt")
		 self:escape()
	   -- self:halt_fight()
		return
	  end
	--[[ if string.find(l,"��ǰ��û�б��ж�Ϊ������") or string.find(l,"�㱻�ж�Ϊ������") then
	    self:fight_reset() --ս��״̬�б�
		self:cond()
	    return
	 end
	 ]]
    end)
end

--^?????{@killer_name|@wdjob_name|@hs_name}��Ծ���ᣬ��ʱ���ء����ˡ����֮���������������������˸˸����ֻ���Ӵ������ͬ��λ��Ϯ������

--^?????������{@killer_name|@wdjob_name|@hs_name}�������˸�Ȧ�ӣ�*����һ�У��Ƿ����е�*���ֱ����·ɻ�*�����У�

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
		if string.find (l,"�����ڲ�æ") then
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

function fight:escape()  --���ܻص�����
end
--^{> ��|��}ֻ����@killer_nameÿһ�ж�������Ƶĺ��޻���֮�࣡
--^{> ��|��}ֻ���ô������ƣ��书������֮����ȫ�޷����ӳ�����
--ξ�پ������̺�̫��֮�������಻�ϣ���ͬѩ����Ϯ���㣡
--��ֻ����ȫ������Ѩ�����裬����̰��ʹ��
--����������������ˮ�߰����Ѷ������������죬�������ϵ�
--��ֻ�����Լ�����١�ý������ƣ���������������ת���磡
--�����һ����С�ģ���ָ�����ڵ���֮�ϣ���ʱ�������ң���ɫ����
--��ֻ�е�Ѩ��һ�飬��������ɢ���������á�����Ծ���ᣬ��ʱ���ء����ˡ����֮���������������������˸˸����ֻ���Ӵ������ͬ��λ��Ϯ������
function fight:danger_skill()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)([^��])��Ծ���ᣬ��ʱ���ء����ˡ����֮���������������������˸˸.*$|^(> |)ֻ���������ֻ���ӻ򹥻��أ�������ˣ�ʵ�˰���ǳ���$|^(> |)��ֻ�����Լ�����(.*)�������ƣ���������������ת���磡$|^(> |)����������ë�������Ż�Ƥ��ͷ�����յ�֨֨���죬�����ڵأ���ס�����ſޣ�$|^(> |)�����ϵ�.*�����浶���٣���ƬƬ�Ʋ���Ʈ�䡣$|^(> |)��ֻ���á�*ÿһ�ж�������Ƶĺ��޻���֮�࣡$|^(> |)��ֻ���ô������ƣ��书������֮����ȫ�޷����ӳ�����$|^(> |)(.*)�����̺�̫��֮�������಻�ϣ���ͬѩ����Ϯ���㣡$|^(> |)��ֻ����ȫ������Ѩ�����裬����̰��ʹ��$|^(> |)(.*)����������������ˮ�߰����Ѷ������������죬�������ϵġ�(.*)���������޵��У�$|^(> |)�����һ����С�ģ���ָ�����ڵ���֮�ϣ���ʱ�������ң���ɫ���ף�$|^(> |)��ֻ��ȫ��һ�飬�ѱ���һ�С����Ź�ɡ����У�$|^(> |)�������Ѫһ�ͣ��ѱ����ڵ��á�$|^(> |)��ֻ�е�Ѩ��һ�飬��������ɢ���������á�$|^(> |)��о���ָ���ڵ������Ҵܣ��ŵ�����������ɼ���$",2)
	  if l==nil then
	     self:danger_skill()
	     return
	  end
	  if string.find(l,"ֻ���������ֻ���ӻ򹥻��أ�������ˣ�ʵ�˰���ǳ�") or string.find(l,"��ʱ���ء����ˡ����֮���������������") then
	    print("��ת��ʼ����")
	    self.dazhuan=true
		return
	  end
	  --if string.find(l,"����Ƶĺ��޻���֮��") or string.find(l,"�����һ����С�ģ���ָ�����ڵ���֮�ϣ���ʱ�������ң���ɫ����") or string.find(l,"��������������ת����") or string.find(l,"����������������ˮ�߰����Ѷ������������죬�������ϵ�") or string.find(l,"�书������֮����ȫ�޷����ӳ���") or string.find(l,"��ֻ����ȫ������Ѩ�����裬����̰��ʹ��") then
	  if string.find(l,"����Ƶĺ��޻���֮��")  or  string.find(l,"�书������֮����ȫ�޷����ӳ���")  then
		print("���˶��¾Ž�")
		  _G["����"]=true
		  -- shutdown()
		  --world.Send("halt")
		 self:escape()
	     return
	  end
	  if  string.find(l,"�����һ����С�ģ���ָ�����ڵ���֮�ϣ���ʱ�������ң���ɫ����")   or string.find(l,"��ֻ��ȫ��һ�飬�ѱ���һ��")  or string.find(l,"��Ѫһ�ͣ��ѱ����ڵ���")  or string.find(l,"��ֻ�е�Ѩ��һ�飬��������ɢ����������") or string.find(l,"��о���ָ���ڵ������Ҵܣ��ŵ�����������ɼ�")  then
	   self:yunjing()
	  end
	    if string.find(l,"����������������ˮ�߰����Ѷ������������죬�������ϵ�") or string.find(l,"��ֻ����ȫ������Ѩ�����裬����̰��ʹ��")   then
	   --  print("���˶��¾Ž�")
		-- _G["����"]=true
		   --shutdown()
		  --world.Send("halt")
		 --self:escape()
		 self:danger_skill()
	     return
	  end
	 --if string.find(l,"���������У���ʱ�����޴�") then
	    --world.Send("halt")
		--self:danger_skill_end("^(> |).*���㲼�������Ѿ�����ʶ���ˡ�$","����ʶ����")
	--	return
	 --end
   end)
end

function fight:check_resume()
   coroutine.resume(fight.check_co)
end

function fight:get_weapon()
--�����һ��������
--�㸽��û������������
--���컯�յ������ٰ���
--����һ��������û����ɣ�
  wait.make(function()
     local l,w=wait.regexp("^(> |)�����.*"..self.losting_weapon..".*$|^(> |)�㸽��û������������$",5)
	 if l==nil then
	    self:get_weapon()
		return
	 end
	 	 if string.find(l,"�����") then
	    self.is_duo=false
		--self:reset()
		  self:unarmed()
	    return
	 end
	 if string.find(l,"�㸽��û����������") then
	    self:unarmed()
	    return
	 end
	 wait.time(5)
  end)
end

--һ��busy skills ��һ��ǿ��pfm �������
--1 �жϼ��ܳɹ� ��־λ
--2 �ж�pfm busy �ж��Ƿ�jifa parry �л��ɹ�
--3 �л� ʩչ��һ������
--4 �ص� 1 ����ѭ��

-- pfm {���ʽ���ɹ����ʽ����һ��pfmָ�룬ִ�����}
--1
--������� ������ϼ��
--�佫ֻ���á�����Ѩ���ѱ����ָ����У����β��ɵĻ���������
--��ָ��ͨ.��,���｣��.��Ӱ, .*ֻ���á�.*���ѱ����ָ����У����β��ɵĻ���������,���β��ɵĻ�������,unwield xiao;jifa parry tanzhi-shentong;perform finger.tan
--���｣��.��Ӱ,��ָ��ͨ.��, ���Ӱʹ�꣬��һ�ν�.*�û����С�,���Ӱʹ��,wield xiao;jifa parry yuxiao-jian;perform sword.feiying
--"��ת������ӡ":{"regexp":"^(> |)����Ծ���ᣬ��ʱ���ء����ˡ����֮���������������������˸˸����ֻ���Ӵ������ͬ��λ��Ϯ������$","ok_regexp":"��ֻ���Ӵ������ͬ��λ��Ϯ����","cmd":"unwield falun;unwield hammer;jiali max;bei hand;jifa parry dashou-yin;perform parry.tianyin;jiali 1;yun longxiang;yun shield"}
-- 2016 -12-21 ��pfms ��ϸ�Ϊ��̬������ģʽ
--��ƥ�� �Զ��л���ָ��pfm ������ʽ  ���ʽ:pfm1|���ʽ:pfm2:״̬  --���� Ĭ�� PFM
--��һȭ�������������˸յľ�����ѧ�������;��öԷ�ȭ���������ޣ��Լ�����ʹʵ�˹�Ȼ���ԣ�ʹ����Ҳ�Ǽ���Σ�գ����������Ծ��� yun maze
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
      local json=cjson.decode(pfm_list) --json���ݽ���
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
   --���������pfm_list ����
   for _,th in pairs(fight.pfm_threads) do
     for _,i in pairs(th) do
	     i=nil  --��item
	 end
     th= nil
   end
   fight.pfm_threads={}
   --
   world.DeleteTriggerGroup("pfm_list") --ɾ��������

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
   --��Ӵ�����

   for _,i in ipairs(self.combine_list) do
       local _pfm=i.pfm
	   local cmd=world.GetVariable(_pfm) or ""
	   local id = "pfm_" .. os.time()..GetUniqueNumber() --���һ��id
	   fight.pfm_threads[id]={}
	   fight.pfm_threads[id].regexp=i.regexp
	   fight.pfm_threads[id].cmd=cmd
	   fight.pfm_threads[id].status=i.status
       fight.pfm_threads[id].co=coroutine.create(function(trigger_id)
	      while true do  --ѭ��
			 print("ִ���л�")
	        if i.status=="set" then
			   world.Execute(fight.pfm_threads[trigger_id].cmd)
		    else
			  self.combat_alias=fight.pfm_threads[trigger_id].cmd
			  self.current_alias=self.combat_alias
			  self.status=fight.pfm_threads[trigger_id].status --��־
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

			if i.status=="����" then
			   world.Execute(i.cmd)
			else
			  self.combat_alias=i.cmd
			  self.current_alias=self.combat_alias
			  self.status=i.status --��־
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
     print("��������")
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
     local l,w=wait.regexp("^(> |)���������˼���������ɫ�������ö��ˡ�$|^(> |)�������������档$|^(> |)���������˼����������������ö��ˡ�$|^(> |)�����ھ�������$",2)
	 if l==nil then
	     --print("����")
	     self:recover(flag)
	   return
     end
	 if string.find(l,"���������˼�����") or string.find(l,"��������������")  or string.find(l,"�����ھ�����") then
	   --world.Send("alias pfm "..self.current_alias)
	   print("�����ɹ���")
	   is_recover=true
	   local f=function()
		  print(is_recover," recover ��־λ")
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
   print("���Իָ���")
     local l,w=wait.regexp("^(> |)���������˼����������������ö��ˡ�$|^(> |)�����ھ�������$",2)
	 if l==nil then
	   self:yunjing()
	   return
     end
	 if string.find(l,"���������˼����������������ö���") or string.find(l,"�����ھ�����") then
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
   print("���Իָ�����")
     local l,w=wait.regexp("^(> |)�㳤��������һ������$|^(> |)�����ھ������档$",2)
	 if l==nil then
	   self:refresh()
	   return
     end
	 if string.find(l,"�㳤��������һ����") or string.find(l,"�����ھ�������") then
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

--�书��Ӧ��
--��ȡ�书��Ӧ�б�

function fight:po_enemy_skills(skillname)
   --���˵ļ������� ʹ�õ�pfm1-pfm5  ʹ��pfm1_list �л�˳��
   --����ֵ 1 pfm1-pfm5 2 pfm1_list pfm5_list
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

