# -Mud--
笑傲江湖站的Mushclient 机器人
网站地址
www.xojh.cn
Lua 语言开发 For Mushclient
秋猫开发 2019-4-10 建立
开发者联系方式 7854001@qq.com zhaojunster@gmail.com
本程序使用面向对象开发，适合有一定编程基础用户

需要了解的基础内容
Mushclient 使用指南 (略) 请查看Mushclient 使用帮助
Lua 语言 
Sqlite 数据库
面向对象程序编程
遍历算法(非必须)

机器人基本框架

数据库(sqlite)
     |
    GPS（定位，逻辑，搜索）
     |
 基础类 (战斗，行走，busy,hp,cond,jobtimes,物品检查)
     |
  任务模板(武当，华山等等)
     |
  mc通用机器人.lua （主程序，Mushclient 加载此主程序）
  
  
  1 任务模板可以学习基础类的使用方式，任务模板都是使用基础类来实现的
  2 gps (map.lua）,路径算法使用双向平衡遍历方式
  3 地图数据都存放在 db文件中
  4 基本配置方式遍历说明       
  
  请将以下内容保存到txt 中，扩展名给为 mcl ，可以使用Mushclient打开，此 mcl id="740b42f1d6a9fc28bca979e6"，需要更改
  
  <?xml version="1.0" encoding="gb2312"?>
<!--MC通用机器人模板
   叶知秋2018-8-8创建 
   将文件另存mcl扩展名
   mushclient加载此配置文件既可以使用
   1 需要修改用户名 密码 
   2 需要脚本设置为 mc通用机器人.lua
  -->

<!DOCTYPE muclient>
<!-- Saved on 星期四, 八月 09, 2018, 11:08 上午 -->
<!-- MuClient version 4.73 -->
<!-- Written by Nick Gammon -->
<!-- Home Page: http://www.mushclient.com/ -->
<muclient>
  <!--需要自己在mc中设置用户名 密码
  需要设置 mc通用机器人.lua所在路径
  其他参数不需要更改
  -->
 <world muclient_version="4.73" world_file_version="15" date_saved="2018-08-09 11:08:41" auto_say_override_prefix="-" auto_say_string="say" chat_name="" command_stack_character=";" id="740b42f1d6a9fc28bca979e6" input_font_name="Fixedsys" mapping_failure="Alas, you cannot go that way." name="" new_activity_sound="(No sound)" output_font_name="楷体" password_base64="y" password="" player="player" script_editor="notepad" script_editor_argument="%file" script_filename="mc_通用版机器人.lua" script_language="Lua" script_prefix="/" site="0.0.0.0" spam_message="look" speed_walk_prefix="#" terminal_identification="mushclient" arrows_change_history="y" auto_pause="y" auto_repeat="y" auto_resize_minimum_lines="1" auto_resize_maximum_lines="20" chat_foreground_colour="red" chat_background_colour="black" chat_port="4051" confirm_before_replacing_typing="y" confirm_on_paste="y" confirm_on_send="y" copy_selection_to_clipboard="y" default_trigger_sequence="100" default_alias_sequence="100" detect_pueblo="y" display_my_input="y" echo_colour="10" echo_hyperlink_in_output_window="y" edit_script_with_notepad="y" enable_aliases="y" enable_beeps="y" enable_command_stack="y" enable_scripts="y" enable_timers="y" enable_triggers="y" enable_trigger_sounds="y" history_lines="1000" hyperlink_adds_to_command_history="y" hyperlink_colour="#0080FF" indent_paras="y" input_background_colour="white" input_font_height="9" input_font_weight="400" input_text_colour="black" keypad_enable="y" line_information="y" log_input="y" log_notes="y" log_output="y" max_output_lines="5000" mud_can_change_link_colour="y" mud_can_change_options="y" note_text_colour="#040000" no_echo_off="y" output_font_height="11" output_font_weight="400" output_font_charset="134" paste_delay_per_lines="1" pixel_offset="3" port="5555" proxy_port="1080" script_errors_to_output_window="y" send_file_delay_per_lines="1" send_mxp_afk_response="y" show_connect_disconnect="y" spam_line_count="20" tab_completion_lines="200" timestamp_input_text_colour="maroon" timestamp_notes_text_colour="blue" timestamp_output_text_colour="white" timestamp_input_back_colour="black" timestamp_notes_back_colour="black" timestamp_output_back_colour="black" underline_hyperlinks="y" unpause_on_send="y" use_custom_link_colour="y" use_default_input_font="y" warn_if_scripting_inactive="y" wrap_column="500" write_world_name_to_log="y">
  <!-- end of general world attributes -->
  <connect_text>n
%name%
%password%
y</connect_text>
 </world>
 <!-- triggers -->
 <!-- aliases -->
 <aliases muclient_version="4.73" world_file_version="15" date_saved="2018-08-09 11:08:41">
  <alias name="repeat" match="^#(\d.)(.*)$" enabled="y" regexp="y" send_to="12" sequence="100">
   <send>local i
local num=tonumber(%1)
for i=1,num do
world.Execute('%2')
end</send>
  </alias>
  <alias name="go" match="^g(\d*)$" enabled="y" regexp="y" send_to="12" sequence="100">
   <send>local w=walk.new();w:go(%1)</send>
  </alias>
  <alias name="gt" match="^gt(.*)$" enabled="y" regexp="y" send_to="12" sequence="100">
   <send>local w=walk.new();w:goto('%1')</send>
  </alias>
  <alias name="pots" match="^pots(\d*)$" enabled="y" regexp="y" send_to="12" sequence="100">
   <send>process.pots(%1)</send>
  </alias>
  <alias name="smi" match="^smi(.*)$" enabled="y" regexp="y" send_to="12" sequence="100">
   <send>process.masterid('%1')</send>
  </alias>
  <alias name="smp" match="^smp(\d*)$" enabled="y" regexp="y" send_to="12" sequence="100">
   <send>process.masterplace(%1)</send>
  </alias>
  <alias name="sz" match="^sz(.*)$" enabled="y" regexp="y" send_to="12" sequence="100">
   <send>Where('%1')</send>
  </alias>
  <alias name="xz" match="^xz(.*)$" enabled="y" regexp="y" send_to="12" sequence="100">
   <send>tprint(WhereIsNpc('%1'))</send>
  </alias>
  <alias name="az" match="az" enabled="y" send_to="12" sequence="100">
   <send>process.az()</send>
  </alias>
  <alias name="bj" match="bj" enabled="y" send_to="12" sequence="100">
   <send>BGpics()</send>
  </alias>
  <alias name="bj_d" match="bj_d" enabled="y" send_to="12" sequence="100">
   <send>BGpics_del()</send>
  </alias>
  <alias name="caiyao" match="caiyao" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.caiyao)</send>
  </alias>
  <alias name="check" match="ch" enabled="y" send_to="12" sequence="100">
   <send>process.check()</send>
  </alias>
  <alias name="ch" match="ch" enabled="y" send_to="12" sequence="100">
   <send>process.check()</send>
  </alias>
  <alias name="cisha" match="cisha" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.cisha)</send>
  </alias>
  <alias name="ck" match="ck" enabled="y" send_to="12" sequence="100">
   <send>process.ck()</send>
  </alias>
  <alias name="cl" match="cl" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.cl)</send>
  </alias>
  <alias name="cp" match="cp" enabled="y" send_to="12" sequence="100">
   <send>hqg:look_caipu()</send>
  </alias>
  <alias name="fish" match="fish" enabled="y" send_to="12" sequence="100">
   <send>fish:go()</send>
  </alias>
  <alias name="fullskill" match="fullskill" enabled="y" send_to="12" sequence="100">
   <send>process.fullskills()</send>
  </alias>
  <alias name="gb" match="gb" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.gb)</send>
  </alias>
  <alias name="gmsw" match="gmsw" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.gmsw)</send>
  </alias>
  <alias name="hb" match="hb" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.hb)</send>
  </alias>
  <alias name="hlp" match="hlp" enabled="y" send_to="12" sequence="100">
   <send>process.update_log()</send>
  </alias>
  <alias name="hs" match="hs" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.hs)</send>
  </alias>
  <alias name="hs2" match="hs2" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.hs2)</send>
  </alias>
  <alias name="hx" match="hx" enabled="y" send_to="12" sequence="100">
   <send>process.huxi()</send>
  </alias>
  <alias name="jy" match="jy" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.jy)</send>
  </alias>
  <alias name="kc" match="kc" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.kc)</send>
  </alias>
  <alias name="ks" match="ks" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.ks)</send>
  </alias>
  <alias name="mapper_show" match="map" enabled="y" send_to="12" sequence="100">
   <send>if mapper.hidden==true then mapper.show() else mapper.hide() end</send>
  </alias>
  <alias name="mh" match="mh" enabled="y" send_to="12" sequence="100">
   <send>Map_Here()</send>
  </alias>
  <alias name="ns" match="ns" enabled="y" send_to="12" sequence="100">
   <send>zhongzhi()</send>
  </alias>
  <alias name="pl" match="pl" enabled="y" send_to="12" sequence="100">
   <send>Pload()</send>
  </alias>
  <alias name="q_time" match="q_time" enabled="y" send_to="12" sequence="100">
   <send>tprint(quest:group_time())</send>
  </alias>
  <alias name="qqll" match="qqll" enabled="y" send_to="12" sequence="100">
   <send>process.qqllyu()</send>
  </alias>
  <alias name="ryfx" match="ryfx" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.ryfx)</send>
  </alias>
  <alias name="shutdown" match="shutdown" enabled="y" send_to="12" sequence="100">
   <send>shutdown()</send>
  </alias>
  <alias name="sld" match="sld" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.suoming)</send>
  </alias>
  <alias name="sm" match="sm" enabled="y" send_to="12" sequence="100">
   <send>process.sm()</send>
  </alias>
  <alias name="smy" match="smy" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.smy)</send>
  </alias>
  <alias name="ss" match="ss" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.ss)</send>
  </alias>
  <alias name="sx" match="sx" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.sx)</send>
  </alias>
  <alias name="tdh" match="tdh" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.tdh)</send>
  </alias>
  <alias name="tm" match="tm" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.tm)</send>
  </alias>
  <alias name="ts" match="ts" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.ts)</send>
  </alias>
  <alias name="tx" match="tx" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.tx)</send>
  </alias>
  <alias name="tz" match="tz" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.tz)</send>
  </alias>
  <alias name="webconfig" match="webconfig" enabled="y" send_to="12" sequence="100">
   <send>wizard:update_webconfig()</send>
  </alias>
  <alias name="wg" match="wg" enabled="y" send_to="12" sequence="100">
   <send>process.wg()</send>
  </alias>
  <alias name="wizard" match="wizard" enabled="y" send_to="12" sequence="100">
   <send>wizard:start()</send>
  </alias>
  <alias name="wk" match="wk" enabled="y" send_to="12" sequence="100">
   <send>digging()</send>
  </alias>
  <alias name="wudang" match="wudang" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.wd)</send>
  </alias>
  <alias name="xc" match="xc" enabled="y" send_to="12" sequence="100">
   <send>process.xc()</send>
  </alias>
  <alias name="xl" match="xl" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.xl)</send>
  </alias>
  <alias name="xs" match="xs" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.xs)</send>
  </alias>
  <alias name="xxbug" match="xxbug" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.xxbug)</send>
  </alias>
  <alias name="xxpt" match="xxpt" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.xxpt)</send>
  </alias>
  <alias name="zc" match="zc" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.zc)</send>
  </alias>
  <alias name="zmud" match="zmud" enabled="y" send_to="12" sequence="100">
   <send>zmud_alias_convert()</send>
  </alias>
  <alias name="zr" match="zr" enabled="y" send_to="12" sequence="100">
   <send>CatchNPC_Room()</send>
  </alias>
  <alias name="zs" match="zs" enabled="y" send_to="12" sequence="100">
   <send>Weapon_Check(process.zs)</send>
  </alias>
 </aliases>
 <!-- timers -->
 <timers muclient_version="4.73" world_file_version="15" date_saved="2018-08-09 11:08:41"/>
 <!-- macros -->
 <macros muclient_version="4.73" world_file_version="15" date_saved="2018-08-09 11:08:41">
  <macro name="up" type="send_now">
   <send>up</send>
  </macro>
  <macro name="down" type="send_now">
   <send>down</send>
  </macro>
  <macro name="north" type="send_now">
   <send>north</send>
  </macro>
  <macro name="south" type="send_now">
   <send>south</send>
  </macro>
  <macro name="east" type="send_now">
   <send>east</send>
  </macro>
  <macro name="west" type="send_now">
   <send>west</send>
  </macro>
  <macro name="examine" type="replace">
   <send>examine </send>
  </macro>
  <macro name="look" type="replace">
   <send>look </send>
  </macro>
  <macro name="page" type="replace">
   <send>page </send>
  </macro>
  <macro name="say" type="replace">
   <send>say </send>
  </macro>
  <macro name="whisper" type="replace">
   <send>whisper </send>
  </macro>
  <macro name="doing" type="send_now">
   <send>DOING</send>
  </macro>
  <macro name="who" type="send_now">
   <send>WHO</send>
  </macro>
  <macro name="drop" type="replace">
   <send>drop </send>
  </macro>
  <macro name="take" type="replace">
   <send>take </send>
  </macro>
  <macro name="F2" type="send_now">
   <send>hf</send>
  </macro>
  <macro name="F3" type="send_now">
   <send>wield hammer;wield falun;jifa parry xiangfu-lun;yun longxiang;perform hammer.dazhuan;jiali 1;</send>
  </macro>
  <macro name="F4" type="send_now">
   <send>dahuandan</send>
  </macro>
  <macro name="F5" type="send_now">
   <send>yjj</send>
  </macro>
  <macro name="logout" type="send_now">
   <send>LOGOUT</send>
  </macro>
  <macro name="quit" type="send_now">
   <send>QUIT</send>
  </macro>
  <macro name="F6" type="send_now">
   <send>tui</send>
  </macro>
 </macros>
 <!-- variables -->
  <!--需求用户自己配置-->
 <variables muclient_version="4.73" world_file_version="15" date_saved="2018-08-09 11:08:41">
   <!--发呆判断-->
      <!--发呆检验时间(秒) 设置60(建议）机器人在这段时间内没有发送任何数据就判断为发呆-->
   <variable name="afk_sec">60</variable>
      <!--发呆后机器人 自动执行动作 Weapon_Check(process.hs) 前面一个为武器检查函数,检查完武器执行华山1任务,请配合jobslist变量设置-->
   <variable name="afk_cmd">Weapon_Check(process.hs)</variable>
   <!--发呆判断结束-->
   <!--区域进出控制开始-->
   <!--前往黑木崖-->
   <variable name="heimuya_entry">false</variable>
   <!--前往蝴蝶谷-->
   <variable name="hudiegu_entry">false</variable>
   <!--前往莆田少林-->
   <variable name="putian_entry">true</variable>
   <!--前往少林-->
   <variable name="shaolin_entry">true</variable>
   <!--前往五毒教 有九阳 或 蓝凤凰弟子可以直接进去-->
   <variable name="wdj_entry">false</variable>
   <!--前往武当后山-->
   <variable name="wudanghoushan_entry">false</variable>
   <!--前往桃花岛-->
   <variable name="taohuadao_entry">false</variable>
   <!--前往桃源-->
   <variable name="taoyuan_entry">false</variable>
    <!--前往天山-->
   <variable name="tianshan_entry">false</variable>
   <!--前往慕容山庄-->
   <variable name="mr_entry">false</variable>
   <!--前往摩天崖-->
   <variable name="mty_entry">false</variable>
   <!--前往绝情谷-->
   <variable name="jueqinggu_entry">false</variable>
   <!--前往神龙岛-->
   <variable name="sld_entry">true</variable>
   <!--区域进出控制结束-->
   <!--长乐帮任务黑名单 默认是星宿派-->
   <variable name="cl_blacklist"/>
   <!--长乐帮任务使用的pfm 默认是pfm1 -->
   <variable name="cl_pfm">pfm1</variable>
   <!--丐帮任务黑名单-->
  <variable name="gb_blacklist">干光豪|茅十八|洪哮天|周孤桐|吴柏英|摘星子|狮吼子|黯然子|蒙古卫士|王夫人|赵敏|吕文德|侯君集|忽必烈|达尔巴|张浩天|黄令天|梁子翁|薛慕华</variable>
   <!--丐帮任务使用的pfm 默认是pfm1-->
   <variable name="gb_pfm">pfm1</variable>
    <!--明教巡逻使用的pfm 默认是pfm1-->
   <variable name="xl_pfm">pfm1</variable>
   <!--华山2任务使用的pfm 默认是pfm1-->
   <variable name="hs2_pfm">pfm1</variable>
   <!--华山1任务使用的pfm 默认是pfm1-->
   <variable name="hs_pfm">pfm1</variable>
   <!--雪山任务黑名单 丐帮&竹棒&大内高手|少林&长鞭&大内高手|大理天龙寺&布衣&大内高手 如果不写大内高手普通也会放弃 建议初期放弃昆仑女弟子 空手-->
   <variable name="xs_blacklist"/>
   <!--雪山任务使用的pfm 默认是pfm1-->
   <variable name="xs_pfm">pfm1</variable>
   <!--丐帮抓蛇任务使用的pfm 默认是pfm1-->
   <variable name="zs_pfm">pfm1</variable>
   <!--星宿抓虫使用的pfm,默认是pfm1-->
   <variable name="xxbug_pfm">pfm1</variable>
   <!--星宿抓虫自动炼毒-->
   <variable name="liandu">false</variable>
    <!--少林救援任务使用的pfm,默认是pfm1-->
   <variable name="jy_pfm">pfm1</variable>
   <!--少林教和尚任务使用的pfm,默认是pfm1-->
   <variable name="tm_pfm">pfm1</variable>
    <!--古墓守墓使用的pfm,默认是pfm1-->
   <variable name="sm_pfm">pfm1</variable>
   <!--人地会使用的pfm,默认是pfm1-->
   <variable name="tdh_pfm">pfm1</variable>
   <!--嵩山五岳并派任务黑名单-->
   <variable name="ss_blacklist"/>
   <!--嵩山五岳并派请人使用的pfm,默认是pfm1-->
   <variable name="ss_fight_pfm">pfm1</variable>
   <!--嵩山五岳并派请人使用的pfm,默认是pfm1-->
   <variable name="ss_kill_pfm">pfm1</variable>
   <!--武当任务黑名单-->
   <variable name="wd_blacklist">玄阴剑法|灵蛇杖法|天山杖法|辟邪剑法|独孤九剑|折梅手|打狗棒法</variable>
   <!--武当任务使用的pfm,默认是pfm1-->
   <variable name="wd_pfm">pfm1</variable>
   <!--武当任务 难度控制1-8-->
    <variable name="difficulty">8</variable>
   <!--送信1任务是否直接送不等人-->
   <variable name="immediate_sx1"/>
   <!--送信1使用pfm-->
   <variable name="sx_pfm">pfm1</variable>
   <!--送信2使用的pfm-->
   <variable name="sx2_pfm">pfm1</variable>
   <!--送信2黑名单-->
   <variable name="sx_blacklist">玄阴剑法|灵蛇杖法|天山杖法|辟邪剑法|独孤九剑|折梅手|打狗棒法</variable>
   <!--送信2难度控制-1 不做  最大4-->
   <variable name="shashou_level">-1</variable>
   <!--送信1不送地点-->
   <variable name="sx_giveup_pos">绝情谷|神龙岛|姑苏慕容|燕子坞|曼佗罗山庄|天山|武当山院门|武当山后山小院|沙滩|小岛</variable>
   
   <!--装备设置 非常重要 参数设置见word 说明 -->
   <variable name="i_equip">&lt;保存&gt;白银&amp;60|&lt;保存&gt;黄金&amp;2|&lt;保存&gt;韦兰之锤|&lt;获取&gt;雄黄|&lt;使用&gt;锦盒|&lt;保存&gt;银票&amp;0|&lt;使用&gt;秘函|</variable>
   <!--任务循环设置 非常重要-->
   <variable name="jobslist">hs,tdh|tdh,hs</variable>
   <!--任务提前切换武器技能 json 格式  非常重要-->
   <variable name="sp_exert">"全部":"unwield chui;unwield chui 2;jifa all;unwield blade;wield fengyun sword;wield sword;yun fengyun;jifa dodge anying-fuxiang;yun zhixin"</variable>
  
   <!--pfm预设 需要配合 任务_pfm 变量来调用预设信息--> 
  <variable name="pfm1"/>
  <variable name="pfm2"/>
  <variable name="pfm3"/>
  <variable name="pfm4"/>
  <variable name="pfm5"/>

  <!--空手武器打飞使用的pfm-->
   <variable name="unarmed_pfm"/>


   <!--学习方式 learn 学习师父 lingwu 达摩院领悟 literate 学读书写字--> 
  <variable name="up">learn</variable>
   <!--gold 消耗完了切换 up 的方式 默认lingwu-->
   <variable name="bei_up">lingwu</variable>
   <!--增加悟性的特效 比如yun qimen 加悟性装备 wield longquan jian 可以用xxx;xxx;xxx 多命令方式-->
  <variable name="wuxing"/>
   <!--师傅所在房间号-->
   <variable name="master_place">2340</variable>
   <!--师傅id-->
   <variable name="masterid">mei</variable>
    <!--学习读书用的睡房房间号-->
   <variable name="sleeproomno">2339</variable>
   <!--学习的技能列表-->
   <variable name="skills">bahuang-gong|force|dodge|parry|sword|strike|hand|liuyang-zhang|tianyu-qijian|yueying-wubu|zhemei-shou|yangyanshu|</variable>
   <!--领悟的技能列表 特殊技能&基本技能&武器名称(武器可以不设置)-->
   <variable name="lian_skills">longxiang-boruo&amp;force|dashou-yin&amp;hand|huoyan-dao&amp;strike|xiangfu-lun&amp;hammer&amp;falun|yuxue-dunxing&amp;dodge|dashou-yin&amp;parry|tianwang-zhua&amp;claw|wushang-dali&amp;staff&amp;staff</variable>
   <!--每次学习花费的pot-->
   <variable name="pot">5</variable>
   <!--pot临界值当前pot+当前值>最大pot,会启动领悟学习 不再任务获取pot,默认20-->
   <variable name="pot_overflow">20</variable>
    <!--任务前double内力,exp低时可以设置高点 0到2数值-->
   <variable name="neili_upper">1.9</variable>
   <!--气血低于百分百 去 薛慕华哪里ask heal-->
   <variable name="liao_percent">70</variable>
   <!--特殊疗伤选项 bed 为古墓寒玉床 juxue 为大轮寺龙象 liao 一阳指 hudiegu 明教张无忌弟子免费医保--> 
   <variable name="special_heal"></variable>
   <!--任务繁忙时候修炼 可以设置为 xiulian_neili xiulian_jingli xiulian_skills-->
   <variable name="xiulian">xiulian_neili</variable>
   <!--MUD服务器的IP地址或域名-->
   <variable name="world_address">123.57.149.222</variable>
 </variables>
 <!-- colours -->
 <colours muclient_version="4.73" world_file_version="15" date_saved="2018-08-09 11:08:41">
  <ansi>
   <normal>
    <colour seq="1" rgb="black"/>
    <colour seq="2" rgb="maroon"/>
    <colour seq="3" rgb="green"/>
    <colour seq="4" rgb="olive"/>
    <colour seq="5" rgb="navy"/>
    <colour seq="6" rgb="purple"/>
    <colour seq="7" rgb="teal"/>
    <colour seq="8" rgb="silver"/>
   </normal>
   <bold>
    <colour seq="1" rgb="gray"/>
    <colour seq="2" rgb="red"/>
    <colour seq="3" rgb="lime"/>
    <colour seq="4" rgb="yellow"/>
    <colour seq="5" rgb="blue"/>
    <colour seq="6" rgb="magenta"/>
    <colour seq="7" rgb="cyan"/>
    <colour seq="8" rgb="white"/>
   </bold>
  </ansi>
  <custom>
   <colour seq="1" name="Custom1" text="#FF8080" back="black"/>
   <colour seq="2" name="Custom2" text="#FFFF80" back="black"/>
   <colour seq="3" name="Custom3" text="#80FF80" back="black"/>
   <colour seq="4" name="Custom4" text="#80FFFF" back="black"/>
   <colour seq="5" name="Custom5" text="#0080FF" back="black"/>
   <colour seq="6" name="Custom6" text="#FF80C0" back="black"/>
   <colour seq="7" name="Custom7" text="red" back="black"/>
   <colour seq="8" name="Custom8" text="#0080C0" back="black"/>
   <colour seq="9" name="Custom9" text="magenta" back="black"/>
   <colour seq="10" name="Custom10" text="#804040" back="black"/>
   <colour seq="11" name="Custom11" text="#FF8040" back="black"/>
   <colour seq="12" name="Custom12" text="teal" back="black"/>
   <colour seq="13" name="Custom13" text="#004080" back="black"/>
   <colour seq="14" name="Custom14" text="#FF0080" back="black"/>
   <colour seq="15" name="Custom15" text="green" back="black"/>
   <colour seq="16" name="Custom16" text="blue" back="black"/>
  </custom>
 </colours>
 <!-- keypad -->
 <keypad muclient_version="4.73" world_file_version="15" date_saved="2018-08-09 11:08:41">
  <key name="0">
   <send>look</send>
  </key>
  <key name="1">
   <send>sw</send>
  </key>
  <key name="2">
   <send>south</send>
  </key>
  <key name="3">
   <send>se</send>
  </key>
  <key name="4">
   <send>west</send>
  </key>
  <key name="5">
   <send>WHO</send>
  </key>
  <key name="6">
   <send>east</send>
  </key>
  <key name="7">
   <send>nw</send>
  </key>
  <key name="8">
   <send>north</send>
  </key>
  <key name="9">
   <send>ne</send>
  </key>
  <key name=".">
   <send>hide</send>
  </key>
  <key name="/">
   <send>inventory</send>
  </key>
  <key name="*">
   <send>score</send>
  </key>
  <key name="-">
   <send>up</send>
  </key>
  <key name="+">
   <send>down</send>
  </key>
  <key name="Ctrl+0"/>
  <key name="Ctrl+1"/>
  <key name="Ctrl+2"/>
  <key name="Ctrl+3"/>
  <key name="Ctrl+4"/>
  <key name="Ctrl+5"/>
  <key name="Ctrl+6"/>
  <key name="Ctrl+7"/>
  <key name="Ctrl+8"/>
  <key name="Ctrl+9"/>
  <key name="Ctrl+."/>
  <key name="Ctrl+/"/>
  <key name="Ctrl+*"/>
  <key name="Ctrl+-"/>
  <key name="Ctrl++"/>
 </keypad>
 <!-- printing -->
 <printing muclient_version="4.73" world_file_version="15" date_saved="2018-08-09 11:08:41">
  <ansi>
   <normal/>
   <bold>
    <style seq="1" bold="y"/>
    <style seq="2" bold="y"/>
    <style seq="3" bold="y"/>
    <style seq="4" bold="y"/>
    <style seq="5" bold="y"/>
    <style seq="6" bold="y"/>
    <style seq="7" bold="y"/>
    <style seq="8" bold="y"/>
   </bold>
  </ansi>
 </printing>
 <!-- plugins -->
</muclient>
