print("叶知秋 mc 通用机器人 版本3.8")
local update_log="2018-8-10\n"
update_log=update_log.."1.01 新增加功能\n"
update_log=update_log.."  1 增加 防饥饿 防口渴 触发器\n"
update_log=update_log.."  2 增加weapon_id变量，weilan 武器自动修理\n"
update_log=update_log.."  3 自动存钱\n"
update_log=update_log.."  4 cmd 变量删除，pfm变量格式 例 jifa parry dashou-yin;bei none;bei dashou-yin;pfm jiali max;perform hand.tianyin;jiali 1;yun longxiang\n"
update_log=update_log.."  5 武器丢失 ，自动下线10分钟，重新登录\n"

update_log=update_log.."1.02 新增功能\n"
update_log=update_log.."  1 xs job 支持 @id 变量 pfm 可以设置成 yun play @id 自动转换成  yun play guard 的id\n"
update_log=update_log.."  2 xs job 支持 特殊 npc 放弃功能 比如 按门派和武器 放弃 新增 without_fight 变量 格式 桃花岛|少林&铁棍\n"
update_log=update_log.."  3 cmd 变量用途改变，被npc 阻挡时候使用 cmd  施放perform\n"
update_log=update_log.."1.03 新增功能\n"
update_log=update_log.."  1 修正长乐帮2 战斗模块bug 问题 和xs 一样 在pfm 可以设置@id 用来获得npc id\n"
update_log=update_log.."  2 修正heal 模块死循环问题 气血低于20% ask 薛慕华 导致死循环 自动吃药 银行需要存有gold 内力1300以下吃金疮药\n"
update_log=update_log.."  3 增加学习锻造模块，自动取gold 保证银行有足够存款\n"
update_log=update_log.."  4 修正fight 模块 吸气 吸精力的bug\n"
update_log=update_log.."  5 领悟模块修正 增加lian 模块 新增练 技能设置变量 lian_skills 设置格式 玉女心经&force|玉女身法&dodge|全真剑法&sword|天罗地网式&hand|银索金铃&whip\n"
update_log=update_log.."  6 战斗时内力不够会自动逃跑\n"
update_log=update_log.."  7 jobslist 提供 gb->sm->cl|cl->gb|sm->gb 多路选择格式\n"
update_log=update_log.."  8 支持学习织造 up=zhizao\n"
update_log=update_log.."  9 战斗中武器打飞 被夺自己get back 功能\n"
update_log=update_log.."  10 添加 unarmed_pfm 变量 武器被夺丢失使用的空手武功 使用第二pfm\n"
update_log=update_log.."1.04 新增功能\n"
update_log=update_log.."  1 自动配置变量功能，新增自动配置模块,输入ch 启动自动配置\n"
update_log=update_log.."  2 sx 任务\n"
update_log=update_log.."  3 lian 模块增加 【你感觉全身气息翻腾，原来你真气不够，不能装备武器 的判断\n"
update_log=update_log.."  4 长乐帮模块bug 修正，原来pot 满了不继续做clb 任务\n"
update_log=update_log.."  5 地图修正，青城山沙漠\n"
update_log=update_log.."1.05 新增功能\n"
update_log=update_log.."  1 设置精灵会自动设置 teach_skills 变量\n"
update_log=update_log.."  2 修正练得时候武器不会自动卸载 导致下一个技能无法练\n"
update_log=update_log.."  3 修正 jobslist变量 设置以后不会立即起效的错误\n"
update_log=update_log.."  4 heal模块修正，薛默华不在时候自动去吃药。\n"
update_log=update_log.."  5 fight模块武器掉落修正,判断自动捡起武器后切换回原来的技能，不再使用unarmed技能\n"
update_log=update_log.."  6 自动购买武器时候gold 判断\n"
update_log=update_log.."  7 雪山job增加beauty guard 死亡事件，用来判断战斗是否已经结束\n"
update_log=update_log.."  8 changle job 增加杀手 死亡事件，用来判断战斗是否已经结束\n"
update_log=update_log.."  9 峨眉部分地图bug 修正\n"
update_log=update_log.."  10 打坐最佳值修改\n"
update_log=update_log.."  11 gb 机器人能够使用了，jobslist = gb->sx|sx->gb\n"
update_log=update_log.."  12 hs 机器人能够使用了, jobslist= hs->sx|sx->hs\n"
update_log=update_log.."1.06 新增内容\n"
update_log=update_log.."  1 增加内力倍数变量 neili_upper 值可以在0-2 1.9表示1.9倍内力开始job 默认是1.9倍\n"
update_log=update_log.."  2 去武当后山小路bug 修复\n"
update_log=update_log.."  3 gaibang 吃喝错误修正\n"
update_log=update_log.."  4 wizard 设置精灵模块 lian_skills 变量没有自动创建\n"
update_log=update_log.."  5 up变量新增 full_lingwu 值 lingwu 完了 继续lian skill 练完以后继续领悟 直到pot 消耗完为止\n"
update_log=update_log.."  6 yell boat 自动打坐\n"
update_log=update_log.."  7 zc 不去领悟bug 修复\n"
update_log=update_log.."1.07 新增内容\n"
update_log=update_log.."  1 过河打坐bug 修复，打坐前提前yun qi\n"
update_log=update_log.."  2 天龙寺松林地图bug修复\n"
update_log=update_log.."  3 wizard 模块 bug 修正，修正vip 和 teach_skills 没有初始化成功问题。\n"
update_log=update_log.."  4 峨眉孤鸿子路径修复\n"
update_log=update_log.."  5 做菜bug 地点排序错误修复\n"
update_log=update_log.."1.08 新增内容\n"
update_log=update_log.."  1 增加 “你的这个技能太差了，薛神医可没兴趣” 触发器语句\n"
update_log=update_log.."  2 xs job 打坐内力上限bug 修复\n"
update_log=update_log.."  3 yell boat 过黄河打坐bug 修复\n"
update_log=update_log.."  4 做菜任务身上没钱会自动就近取钱，最初取钱钱庄位置变化，前往福州城取钱，避免杭州苏州钱庄老板被杀取不到钱\n"
update_log=update_log.."  5 做菜前会自动检查状态吃喝和yun heal\n"
update_log=update_log.."  6 full_lingwu 模式会导致死循环bug修正\n"
update_log=update_log.."  7 增加了xc 功能 jobslist xc->xc\n"
update_log=update_log.."  8 做菜判断身上携带白银方式改变，不再look silver，i 方式判断\n"
update_log=update_log.."  9 sx2 新增blacklist变量 出现列表中的门派和技能自动逃跑 玄阴剑法|星宿派|华山派&独孤九剑|少林派&韦陀杵\n"
update_log=update_log.."  10 sx job 新增 immediate_sx1 变量 sx1 不等待杀手直接投递\n"
update_log=update_log.."  11 姑苏慕容地图部分更新，姑苏yell boat bug 修复\n"
update_log=update_log.."1.09 新增内容\n"
update_log=update_log.."  1 修复战斗模块晕倒后继续pfm 问题\n"
update_log=update_log.."  2 修复雪山job 【阴阳合欢散】丢失导致无法撒的bug\n"
update_log=update_log.."  3 修复学习模块wield 武器bug\n"
update_log=update_log.."  4 修复做菜模块bug,follow npc 时候被小动物拦住导致发呆，现在会自动look 周围来寻找npc\n"
update_log=update_log.."  5 峨眉地图禅房bug\n"
update_log=update_log.."  6 lian模块增加一个延迟，防止flood\n"
update_log=update_log.."  7 修复福建小岛地图bug\n"
update_log=update_log.."  8 增加hs2 job 输入hs2 启动,jobslist = sx->hs2|hs2->sx\n"
update_log=update_log.."  9 支持古墓派直接穿越襄阳郊外树林迷宫,古墓派无法进入襄阳郊外树林，所以有关任务都自动放弃！\n"
update_log=update_log.."  10 lian 模块不支持stick 修正\n"
update_log=update_log.."  11 fight 模块去除auto perform 发送\n"
update_log=update_log.."  12 xueshan模块 逃跑修正\n"
update_log=update_log.."  *13 新增i_equip变量 自动获得装备 目前支持 甩箭 莆田少林护腕 披风 软靴 今后支持物品会陆续增加 变量设置id&数量 id首字母注意大写 例 Shuaijian&800|Jinhu pifeng|Hu wan \n"
update_log=update_log.."  14 修正新建mcl文件加载mc_通用机器人报错的问题\n"
update_log=update_log.."1.10 新增内容\n"
update_log=update_log.."  1 每次job前先检查装备\n"
update_log=update_log.."  2 修正长乐帮逃跑\n"
update_log=update_log.."  3 ChineseNum函数修正能够真确将汉字转换成阿拉伯数字\n"
update_log=update_log.."  4 增加部分门派halt 描述\n"
update_log=update_log.."  5 修正i_equip变量不设置导致发呆问题\n"
update_log=update_log.."1.11 新增内容\n"
update_log=update_log.."  1 送信战斗问题解决，能够正确判断多个npc\n"
update_log=update_log.."  2 clb2 bug 修正 \n"
update_log=update_log.."  3 clb2 增加cl_blacklist 放弃一些特殊门派的杀手。cl_blacklist 星宿派|桃花岛 \n"
update_log=update_log.."  4 过河时候没钱会自己跑去取钱 \n"
update_log=update_log.."  5 福建小岛地图修复 \n"
update_log=update_log.."  6 fight 模块战斗停止和逃跑设置都重新设计过了，能够支持多人混战。\n"
update_log=update_log.."  7 渡河渡江时候判断最大精力 渡河精力必须大于1400 渡江精力必须大于1800 \n"
update_log=update_log.."  8 做菜job 遇到毒蛇老虎等小动物导致follow npc失败，现在会自己look around 判别npc 所在位置。\n"
update_log=update_log.."  9 物品检查不再是一项一项检查，一次性检查完毕以后依次处理。\n"
update_log=update_log.."1.12 新增内容\n"
update_log=update_log.."  1 wd job支持,jobslist 设置 wd->hs->sx 后一个为备选\n"
update_log=update_log.."  2 hs1 job 修正现在只打晕npc"
update_log=update_log.."  3 wd_blacklist 武当黑名单 可以设置放弃skill 门派  例 星宿派|独孤九剑|韦陀杵\n"
update_log=update_log.."  4 部分地图小bug 修正 \n"
update_log=update_log.."  5 hs 松树林bug 修正 路径修正，npc出现在松树林会正确处理 \n"
update_log=update_log.."  6 wd 增加difficulty 变量， 设置值1-4 1:不足为虑 2:颇为了得 3:极其厉害 4:已如化境 \n"
update_log=update_log.."  7 pot_overflow变量 控制pot溢出值，当max_pot -当前pot<溢出值时就去学习领悟,pot_overflow为负数时候不学习不领悟 \n"
update_log=update_log.."  8 i_equip变量 shuai jian|jinhu pifeng 变量值不在要求首字母大写，大小写不敏感 \n"
update_log=update_log.."  9 新指令hlp 查看更新日志 \n"
update_log=update_log.."1.13 新增内容\n"
update_log=update_log.."  1 wd job 六合加入\n"
update_log=update_log.."  2 hs1 job 菜地砍头\n"
update_log=update_log.."  3* 设置精灵全面改进,ch启动新版设置精灵，帮助玩家更加简单进行设置\n"
update_log=update_log.."  4* 提供了5个pfm选项，每个job可以根据需要选择不同的pfm,可以通过设置精灵进行绑定\n"
update_log=update_log.."  5 新的wizard命令启动设置向导\n"
update_log=update_log.."  6 做菜小动物导致follow 失败问题修正\n"
update_log=update_log.."1.14 新增内容\n"
update_log=update_log.."  1 修正峨嵋孤鸿子的道路非峨眉弟子不再进入峨眉灌木丛\n"
update_log=update_log.."  2 修正lian lingwu 一些bug\n"
update_log=update_log.."  3 lian的时候会jifa force 技能名称\n"
update_log=update_log.."  4 wd npc强度已入化境的触发语句出错，问题修正\n"
update_log=update_log.."  5 hs 砍头以后unwield all\n"
update_log=update_log.."  6 宝象_骚扰处女问题处理\n"
update_log=update_log.."  7 吃喝地点改武当茶亭\n"
update_log=update_log.."  8 疗伤时候没有金疮药时候尝试自己yun heal\n"
update_log=update_log.."  9 渡河渡江精力上限不够打坐会导致死循环\n"
update_log=update_log.."  10 hs2 job 结束接下一个任务报错修正\n"
update_log=update_log.."  11 i_equip 变量新增2个选项 mu jian  和 武当 songwen jian \n"
update_log=update_log.."  12 fight模块精力不够不能施展pfm没有自动yun jingli 修复 \n"
update_log=update_log.."  13 武当job 记录上次wd job 是否成功，来判断能否继续job\n"
update_log=update_log.."1.15 新增内容\n"
update_log=update_log.."  1 mc 目录下新增一个tools目录里面有sqlite数据库编辑器sqliteadmin.exe可以打开sj.db来看地图数据\n"
update_log=update_log.."  2 神龙岛弟子特殊回神龙岛快捷路径添加\n"
update_log=update_log.."  3 练模块 抓取基本等级触发器表达式bug修正\n"
update_log=update_log.."  4 天地会战斗结束判断修正\n"
update_log=update_log.."  5 fight 模块 闭气,内息不均,封招时 自动halt\n"
update_log=update_log.."  6 少林寺松林路-伏魔圈路径修复\n"
update_log=update_log.."  7 天龙寺龙树院地图加入\n"
update_log=update_log.."1.16 新增内容\n"
update_log=update_log.."  1 中了火焰刀自动逃跑\n"
update_log=update_log.."  2 为了解决发呆问题，增加进程监视器\n"
update_log=update_log.."  3 hs job 在松树林巡逻有可能失败的问题修正\n"
update_log=update_log.."  4 fight 模块大改动\n"
update_log=update_log.."  5 物品检查模块能够正确识别层叠在一起的物品数量\n"
update_log=update_log.."  6 少林派在外杀人以后会去戒律院领受处罚！！\n"
update_log=update_log.."  7 领悟学习 饥渴触发自动吃喝 会发呆问题修正\n"
update_log=update_log.."1.16b 新增内容\n"
update_log=update_log.."  1 部分地图修正。少林松林问题修正，加入天山龙潭天山山涧逍遥洞地图——在此特别感谢布拉格提供bug\n"
update_log=update_log.."  2 block npc 修复cmd 设置以后会自动释放pfm\n"
update_log=update_log.."1.17 新增内容\n"
update_log=update_log.."  1 神龙岛非神龙教弟子会ask ling 问题修正\n"
update_log=update_log.."  2 没钱坐船会自动取silver\n"
update_log=update_log.."  3 weapon_id 变量修改成repair_weapon_id\n"
update_log=update_log.."  *4 新增self_repair变量,自动修理武器盔甲,还没有完善\n"
update_log=update_log.."  *5 新增地图显示功能,地图还不完善\n"
update_log=update_log.."1.18 新增内容\n"
update_log=update_log.."  1 加入明教讨教 up=taojiao\n"
update_log=update_log.."  2 clb get 粗布会导致死循环 bug修复\n"
update_log=update_log.."  3 hs npc 超重会自动kill砍头\n"
update_log=update_log.."1.19 新增内容\n"
update_log=update_log.."  1 wizard 全面更新支持窗体设置 wizard启动设置\n"
update_log=update_log.."  2 中了火焰刀会退出relogin\n"
update_log=update_log.."  3 lost weapon 修正了笔丢了不会捡得bug\n"
update_log=update_log.."  4 能够正确领悟匕首了\n"
update_log=update_log.."  5 修正几个地图bug\n"
update_log=update_log.."  6 hs 打斗过程中失手杀人不砍头的bug修正\n"
update_log=update_log.."  7 hs 会follow npc\n"
update_log=update_log.."  8 修正tdh yun heal 过程中出现朝廷侍卫导致发呆问题\n"
update_log=update_log.."  9 tdh 渡船发呆问题修正\n"
update_log=update_log.."1.20 新增内容\n"
update_log=update_log.."  1 天山山涧地图bug修正\n"
update_log=update_log.."  2 vip练force 不关闭vip问题修正\n"
update_log=update_log.."  3 学习匕首不装备武器问题修正\n"
update_log=update_log.."  4 练hammer bug 异常修正\n"
update_log=update_log.."1.20b 新增内容\n"
update_log=update_log.."  1 苏州衙门地图bug修复\n"
update_log=update_log.."  2 hs2 小bug修复\n"
update_log=update_log.."  3 可以对挡路npc使用pfm,wizard 也相应更新了\n"
update_log=update_log.."  4 少林松林bug修复了\n"
update_log=update_log.."1.21 新增内容\n"
update_log=update_log.."  1 送信超时信件丢失问题修正\n"
update_log=update_log.."  2 插件的窗体在重新加载脚本以后会消失的问题修正,现在加载脚本以后会自动重新加载插件\n"
update_log=update_log.."  3 少林松林bug\n"
update_log=update_log.."  4 武器丢失,get 以后没有wield问题修正\n"
update_log=update_log.."  5 使用法轮大转武器丢失导致异常修正\n"
update_log=update_log.."  6 busy类超时导致关闭所有触发的bug修正\n"
update_log=update_log.."1.22 新增内容\n"
update_log=update_log.."  1 job 中不会对挡路npc使用pfm问题修正\n"
update_log=update_log.."  2 武器丢失get weapon 报错修正\n"
update_log=update_log.."  3 打坐safe_qi按 max_qi 百分之50 计算不再是固定值\n"
update_log=update_log.."  4 增加桃源县地图(一灯大师房间号2740),必须拜了一灯才能进入\n"
update_log=update_log.."  5 增加了蝴蝶谷地图,\n"
update_log=update_log.."  6 增加了变量special_heal，(特殊治疗 一阳指的liao 龙象般若 和明教蝴蝶谷) 值=liao,juxue,hudiegu\n"
update_log=update_log.."1.22b 新增内容\n"
update_log=update_log.."  1 武器丢失重新连接时间有问题，修正\n"
update_log=update_log.."  2 特殊疗伤bug 修正，能够正确yun juxue perform liao 去蝴蝶谷\n"
update_log=update_log.."  3 天地会一些小bug修复\n"
update_log=update_log.."  4 所有设定技能都领悟练满了以后,会自动转入job中,等级升级以后又会转入领悟\n"
update_log=update_log.."1.22c 新增内容\n"
update_log=update_log.."  1 巡城job修正,能够服药，内息丸 续精丹\n"
update_log=update_log.."  2 hs1 hs2 pfm 分开。变量 hs_pfm hs2_pfm\n"
update_log=update_log.."  3 sx1 sx2 pfm 分开。变量 sx_pfm sx2_pfm\n"
update_log=update_log.."  4 新增huxi(白牛山)呼吸模块,自动mj 吃喝睡觉,hx命令启动\n"
update_log=update_log.."  5 有些地方unwield weapon过后会自动wield 武器\n"
update_log=update_log.."1.23 新增内容\n"
update_log=update_log.."  1 天地会小bug修正\n"
update_log=update_log.."  2 自动保存玉,weilan'hammer 残篇，丢弃青铜 棉花 种子(special_items.lua equipments.lua wizard.lua)\n"
update_log=update_log.."  3 找薛疗伤比例可以自己调整,新增变量liao_percent(xueshan.lua songxin.lua changle.lua tiandi.lua wudang.lua huashan.lua wizard.lua)\n"
update_log=update_log.."  4 嘉峪关路径处理方式改变(alias.lua)\n"
update_log=update_log.."  5 战斗结束增加busy判断(mc_通用机器人.lua)\n"
update_log=update_log.."  6 洪七公job+领悟会导致死循环(感谢宁静提供bug lingwu.lua)\n"
update_log=update_log.."1.23b 新增内容\n"
update_log=update_log.."  1 自动保存物品小bug 修复\n"
update_log=update_log.."  2 若干地图bug修复(地图数据库)\n"
update_log=update_log.."  3 洪七公做菜pot 没用完会导致死循环，修复\n"
update_log=update_log.."1.24b 新增内容\n"
update_log=update_log.."  1 领悟学习前先自动疗伤\n"
update_log=update_log.."  2 福州小岛地图错误会导致发呆bug修正\n"
update_log=update_log.."  3 过河过江打坐会导致发呆问题修正\n"
update_log=update_log.."1.25 新增内容\n"
update_log=update_log.."  1 新增抓蛇job\n"
update_log=update_log.."1.26 新增内容\n"
update_log=update_log.."  1 新增慕容领悟斗转功能lian_skills 变量加入 douzhuan-xingyi&parry,自动在练skil 去领悟斗转 \n"
update_log=update_log.."  2 修复自动保存玉的bug,玉佩也会当做yu保存,玉改为 南玉|独玉|密玉|风雷玉|龙鳞玉|脂玉|琉玉|香凝玉|绿玉髓|凤瓴玉\n"
update_log=update_log.."  3 xx 打坐halt 描述加入\n"
update_log=update_log.."  4 1.25版学习领悟前在安全房间heal导致乱跑的bug修复\n"
update_log=update_log.."  5 新增武器护具自己修理功能,self_repair变量加入armor|belt|boot 物品id\n"
update_log=update_log.."  6 heal 模块增加吃疗精丹和活血丹功能\n"
update_log=update_log.."  7 领悟模块增加判断内力功能,内力低于500自动打坐\n"
update_log=update_log.."  8 沧州 铁掌山 若干地图修正\n"
update_log=update_log.."1.27 新增内容\n"
update_log=update_log.."  1 巡城job若干bug修复\n"
update_log=update_log.."  2 新增少林熬粥job az->az,慕容浇花jh->jh 嵩山 五岳并派任务 ss  \n"
update_log=update_log.."  3 若干路径问题修复,梅庄可以自动出来\n"
update_log=update_log.."  4 坐船打坐会导致发呆的bug修复,小号max_qi<=200 等船时候不打坐\n"
update_log=update_log.."1.28 新增内容\n"
update_log=update_log.."  1 做菜机器人在经验不满1.2m以前不会去明教龙王殿\n"
update_log=update_log.."  2 ss job 修改增加ss_kill_pfm 和 ss_fight_pfm 针对请人和杀人任务\n"
update_log=update_log.."  3 修复sx bug\n"
update_log=update_log.."1.28b 新增内容\n"
update_log=update_log.."  1 新增mark_weapon_name 变量，用于检测uweapon 武器装备。原有bug修复\n"
update_log=update_log.."  2 sx2 流程优化，送信1 投递->打坐，等待sx2 杀手到来。 改为先打坐->送信1 投递 ->等待杀手\n"
update_log=update_log.."1.29 新增内容\n"
update_log=update_log.."  1 少林增加挑水job 发现戴了镣铐自动启动挑水！\n"
update_log=update_log.."  2 新增bei_up变量 后备升级，发现没gold 学literate 时候自动切换 设置lingwu 或learn \n"
update_log=update_log.."  3 新增神龙岛区域设置，玩家可以自己控制是否去神龙岛做job \n"
update_log=update_log.."  4 i_equip 新增内息丸和川贝丸两种药物 fight时候内力低 时候会自动服药 \n"
update_log=update_log.."  5 sx2 bug 修复\n"
update_log=update_log.."  6 sx hs 任务放弃以后，再次遇到上个npc会自动quit 5分钟保护。\n"
update_log=update_log.."  7 sx1 会等待杀手出现以后再过河过江。\n"
update_log=update_log.."  8 霍都自我保护\n"
update_log=update_log.."1.29b 新增内容\n"
update_log=update_log.."  1 送信1 giveup会导致扣50-70点经验,现在除非无法找到地点外不会放弃job\n"
update_log=update_log.."  2 fight 模块自动吃药有bug 修复\n"
update_log=update_log.."  3 sx1 过河时候不再打坐\n"
update_log=update_log.."1.29c 新增内容\n"
update_log=update_log.."  1 sx2 送信第一个寻找的房间号不对,修正bug\n"
update_log=update_log.."1.30 新增内容\n"
update_log=update_log.."  1 sx2 tdh mj id 中途疗伤去蝴蝶谷 修复\n"
update_log=update_log.."  2 新增teach monk 任务 TM->任务1->任务2\n"
update_log=update_log.."  3 增加少林派可以自动拿 柴刀 和 木棉袈裟\n"
update_log=update_log.."  4 峨眉后山灌木丛 除非孤鸿子弟子一般不再进去,灌木丛路径修复,连续几次不成功会quit 再重新连接继续！\n"
update_log=update_log.."  5 MR偷学任务加入\n"
update_log=update_log.."  6 hs 和 wd 的女睡房加入\n"
update_log=update_log.."1.31 新增内容\n"
update_log=update_log.."  1 钱庄存满会自动兑换处cash\n"
update_log=update_log.."  2 mr 偷学报错bug 修复\n"
update_log=update_log.."  3 练skill 支持 hook\n"
update_log=update_log.."  4 路径核心算法改变，加快计算速度。\n"
update_log=update_log.."1.32 新增内容\n"
update_log=update_log.."  1 新的地图遍历算法bug修复\n"
update_log=update_log.."  2 一次走15步\n"
update_log=update_log.."  3 learn wuxing bug 修复\n"
update_log=update_log.."  4 mini_map_show =true 迷你地图才会显示,默认是关闭的\n"
update_log=update_log.."  5 clb job bug 修复\n"
update_log=update_log.."  6 行走自动根据延时情况动态调整路径发送频率.\n"
update_log=update_log.."1.33 新增内容\n"
update_log=update_log.."  1 修正了个地图bug,福州丐帮新增快捷穿越路径。\n"
update_log=update_log.."  2 mr sld 回慕容回神龙岛快捷路径bug 修复\n"
update_log=update_log.."  3 长乐帮查看corpse 做了部分优化\n"
update_log=update_log.."  4 星宿沙漠新增快捷穿越路径。\n"
update_log=update_log.."1.34 新增内容\n"
update_log=update_log.."  1 战斗模块新增pfm切换功能,新增变量 pfm1_list,pfm2_list,pfm3_list,pfm4_list,pfm5_list。\n"
update_log=update_log.."  2 战斗模块新增pfm切换功能,新增变量 xs_pfm_list,wd_pfm_list,sx_pfm_list。\n"
update_log=update_log.."  3 战斗模块新增pfm切换功能,战斗中pfm切换格式:   ^.*只觉得.*已被你的指风点中，身形不由的缓慢下来！$#身形不由的缓慢下来#wield xiao;jifa parry yuxiao-jian;jiali max;perform sword.feiying;yun qi;yun jingli&^.*你飞影使完，手一晃将.*拿回手中。$#你飞影使完#unwield xiao;jiali 1;jifa parry tanzhi-shentong;perform finger.tan"
update_log=update_log.."  4 地图bug 导致没有通路情况下无法自动放弃job 导致发呆下线问题修正。"
update_log=update_log.."  5 敌人危险技能fen 独孤九剑 昆仑雪崩"
update_log=update_log.."1.35 新增内容\n"
update_log=update_log.."  1 新增采矿job，按wizard进行设置\n"
update_log=update_log.."1.36 新增内容\n"
update_log=update_log.."  1 一些迷宫遍历算法优化，明教树林，紫杉林，星宿星宿海\n"
update_log=update_log.."  2 襄阳树林迷宫，昆仑山冷杉林迷宫bug修正,少林寺塔林迷宫bug修正,加入天龙寺松林穿越路径,星宿沙漠穿越路径\n"
update_log=update_log.."  3 增加了读九阴真经 up=9yzj\n"
update_log=update_log.."1.37 新增内容\n"
update_log=update_log.."  1 洪七公做菜任务做菜前往佛山有bug修正\n"
update_log=update_log.."  2 萧府路径bug修复\n"
update_log=update_log.."  3 明教学圣火令会自己装备匕首\n"
update_log=update_log.."  4 采矿的交矿石bug修复\n"
update_log=update_log.."1.38 新增内容\n"
update_log=update_log.."  1 fight模块新增根据敌人武功使用不能对应技能的功能,目前只针对武当任务开放此功能,新增变量all_skills_list,设置格式all_skills_list=弹指神通#pfm1#pfm1_list(或空)|打狗棒法#pfm2#pfm2_list\n"
update_log=update_log.."  2 Room类 地图抓取会导致异常发呆,问题修正\n"
update_log=update_log.."  3 fight模块 武器打飞导致无法切换skill bug修正\n"
update_log=update_log.."  4 新增reconnect2.xml发呆插件,新增afk_cmd变量,填写发呆以后执行的命令,配合插件一起使用\n"
update_log=update_log.."1.39 新增内容\n"
update_log=update_log.."  1 一些小bug 和地图bug 修复\n"
update_log=update_log.."  2 新增wdj_entry变量,可以前往五毒教,建议2m以后考虑\n"
update_log=update_log.."1.40 新增内容\n"
update_log=update_log.."  1 新增mj 巡逻模块 jobslist=xl->hs|hs->xl,第一次请按wizard设置\n"
update_log=update_log.."1.41 新增内容\n"
update_log=update_log.."  1 mj 巡逻任务一些bug修复\n"
update_log=update_log.."  2 五毒教进入算法错误,修复\n"
update_log=update_log.."  3 襄阳郊外树林地图错误修正\n"
update_log=update_log.."1.41b 新增内容\n"
update_log=update_log.."  1 mj 巡逻任务战斗结束判断修改，能够有效判别是否脱离战斗\n"
update_log=update_log.."1.41c 新增内容\n"
update_log=update_log.."  1 mj 巡逻任务没有全部巡逻到会重新在巡逻一次。\n"
update_log=update_log.."  2 mj 找attacker 只在巨木旗两侧寻找，提高效率。\n"
update_log=update_log.."  3 mushclient 客户端升级到4.73,希望解决mushclient不稳定闪退的情况。\n"
update_log=update_log.."1.42 新增内容\n"
update_log=update_log.."  1 地图引擎的通路算法有bug，会无法正确计算没有通路情况，bug修正。\n"
update_log=update_log.."  2 自动加载重连反发呆插件,wizard设置时候可以对插件进行设置，插件设置好以后可以实现开机自动启动任务的功能。\n"
update_log=update_log.."1.43 新增内容\n"
update_log=update_log.."  1 路径优化,去回疆走大沙漠,不再走针叶林,大沙漠有直接穿越路径。\n"
update_log=update_log.."  2 巡逻打坐bug修复,画印等待时候会自己打坐修炼内力。打架打完以后疗伤恢复内力不再打坐双倍内力,1.2左右内力。\n"
update_log=update_log.."  3 回疆针叶林能正确遍历，地图问题修正。\n"
update_log=update_log.."  4 地图算法优化,地图数据库加载入内存中计算,防止挂多个id导致文件频繁读写操作导致mc崩溃,运算速度更快。\n"
update_log=update_log.."1.44 新增内容\n"
update_log=update_log.."  1 领悟练pot消耗有bug修复。\n"
update_log=update_log.."  2 松文剑丢失以后会重新quit在ask。\n"
update_log=update_log.."  3 绝情谷的竹林算法bug修正，验证正确性。\n"
update_log=update_log.."1.45 新增内容\n"
update_log=update_log.."  1 修正了几个路径alias错误。\n"
update_log=update_log.."  2 大理巡城任务不会本草疗伤导致发呆修正，受伤以后会自己去吃金疮药。\n"
update_log=update_log.."1.46 新增内容\n"
update_log=update_log.."  1 领悟练模块合并，领悟练只看lian_skils变量，新增一个ready变量，当领悟完成会执行这个变量。\n"
update_log=update_log.."1.47 新增内容\n"
update_log=update_log.."  1 i_equip变量错误设置会导致发呆。现在新增放错措施，发现无法处理的物品自动提示然后跳过处理下一个。\n"
update_log=update_log.."  2 断线会不停出现重连提示问题结果。\n"
update_log=update_log.."  3 领悟bug修正。\n"
update_log=update_log.."  4 打坐加入最小气量计算。\n"
update_log=update_log.."  5 嵩山左冷禅任务bug修复。\n"
update_log=update_log.."  6 送信等待npc出现时候自动发送look 指令防止发呆模块处理启动。\n"
update_log=update_log.."  7 雪山任务sa beauty bug 修复。\n"
update_log=update_log.."  8 扬州地牢地图加入。\n"
update_log=update_log.."1.48 新增内容\n"
update_log=update_log.."  1 绝情谷竹林修复。\n"
update_log=update_log.."  2 萧府路径修复。\n"
update_log=update_log.."  3 扬州地牢路径修复。\n"
update_log=update_log.."  4 做菜卡的问题修正。\n"
update_log=update_log.."  5 log功能完善中,新增死亡自动log功能。\n"
update_log=update_log.."  6 ss gb任务发现没有路径不会主动放弃bug修复。\n"
update_log=update_log.."  7 hs任务没武器砍头会自动get corpse。\n"
update_log=update_log.."  8 天龙寺松林bug修复。\n"
update_log=update_log.."1.49 新增内容\n"
update_log=update_log.."  1 天龙寺部分地图补充完整。\n"
update_log=update_log.."  2 雪山任务小bug修复，会导致发呆。\n"
update_log=update_log.."  3 新增mini地图功能,鼠标左键点击房间会自动前往目标房间，鼠标右键点击显示房间名称房间号,支持滚轮放大缩小地图。\n"
update_log=update_log.."1.50 新增内容\n"
update_log=update_log.."  1 战斗模块修正对独孤九剑的bug。\n"
update_log=update_log.."  2 领悟模块小bug修复，技能满时候不会在先去一次少林在去job。\n"
update_log=update_log.."  3 用户界面大调整，新增hp,技能 任务信息窗体,bj命令可以加载背景,bj_d删除背景图片。\n"
update_log=update_log.."1.51 新增内容\n"
update_log=update_log.."  1 lian_skills格式修改，lian_skills=特殊技能名称&基本中文名称&武器名称 最后一个为选填 例 dugu-jiujian&dodge&jian确保武器存在\n"
update_log=update_log.."  2 修正1.50版领悟斗转星移和领悟大挪移bug。\n"
update_log=update_log.."1.52 新增内容\n"
update_log=update_log.."  1 长乐帮抓捕凶手时候,过河过江会打坐的bug修正。\n"
update_log=update_log.."  2 少林增加救援恒山任务！启动救援输入jy\n"
update_log=update_log.."  3 新增学习成高道长农桑锻造采矿，设置up变量=chenggao,skills 变量设置为需要学习的技能名称nongshang|duanzao|caikuang\n"
update_log=update_log.."1.53 新增内容\n"
update_log=update_log.."  1 修正少林救援的若干bug。\n"
update_log=update_log.."1.54 新增内容\n"
update_log=update_log.."  1 一些累积bug修复。\n"
update_log=update_log.."1.55 新增内容\n"
update_log=update_log.."  1 抓蛇bug修复。\n"
update_log=update_log.."  2 昆仑地图bug修复。\n"
update_log=update_log.."  3 i_equip变量修改,具体帮助。\n"
update_log=update_log.."  4 黄金,白银,铜钱,银票在i_equip设置携带上限<保存>黄金&5 超过5gold 部分回去存钱庄。\n"
update_log=update_log.."  5 明教天地风雷地图修复。\n"
update_log=update_log.."1.56 新增内容\n"
update_log=update_log.."  1 武当送信华山bug修复。\n"
update_log=update_log.."  2 i_equip 新增<自动修理> <存在> <手动修理> 同时 mark_weapon_name,repair_weapon_id 变量都废弃。\n"
update_log=update_log.."  3 vip 领悟bug修正，效率提高。\n"
update_log=update_log.."  4 busy 类bug修正。\n"
update_log=update_log.."1.57 新增内容\n"
update_log=update_log.."  1 路径bug累计修复。\n"
update_log=update_log.."  2 i_equip 新增<获取>黄金&1 <获取>白银&1 <获取>铜钱用法。\n"
update_log=update_log.."  3 新增五毒教进入判定。\n"
update_log=update_log.."1.58 新增内容\n"
update_log=update_log.."  1 xx 抓虫模块加入,jobslist 格式xs->xxbug|xxbug->xs,输入xxbug启动任务\n"
update_log=update_log.."  2 xx炼毒模块加入,liandu变量设置为自动时候，在wd xs sx 任务结束以后会自动炼毒。\n"
update_log=update_log.."  3 xs雪山任务 bug 修复。\n"
update_log=update_log.."  4 ss嵩山任务 bug 修复。\n"
update_log=update_log.."  5 wizard 自动配置更新。\n"
update_log=update_log.."1.59 新增内容\n"
update_log=update_log.."  1 新增遍历类。\n"
update_log=update_log.."  2 武当job采用新的遍历寻找npc 方式。\n"
update_log=update_log.."  3 华山树林路径优化。\n"
update_log=update_log.."  4 部分地图路径bug修复。\n"
update_log=update_log.."1.60 新增内容\n"
update_log=update_log.."  1 武当job遍历bug 累积修复。\n"
update_log=update_log.."1.61 新增内容\n"
update_log=update_log.."  1 武当job遍历bug 累积修复。\n"
update_log=update_log.."1.62 新增内容\n"
update_log=update_log.."  1 武当job遍历bug 累积修复。\n"
update_log=update_log.."  2 少林可以自动练无相劫指,在lian_skills=wuxiang-jiezhi&finger 就可以。\n"
update_log=update_log.."  3 增加少林后山地图。\n"
update_log=update_log.."  4 修复武当后山烈火丛林bug。\n"
update_log=update_log.."1.63 新增内容\n"
update_log=update_log.."  1 少林竹林路径bug 修复。\n"
update_log=update_log.."  2 遍历算法优化，迷宫会留最后去搜索。\n"
update_log=update_log.."  3 special_item 物品检查对象增加一个weight 属性来获取负重值。\n"
update_log=update_log.."1.7 新增内容\n"
update_log=update_log.."  1 更新数据，新增全真蒙古地图。\n"
update_log=update_log.."  2 修复天地会 华山 送信若干 job bug\n"
update_log=update_log.."1.71 新增内容\n"
update_log=update_log.."  1 更新数据，新增天山灵鹫宫快捷路径，逍遥派地图快捷路径。\n"
update_log=update_log.."  2 修复送信2 不放弃bug\n"
update_log=update_log.."1.8 新增内容\n"
update_log=update_log.."  1 walk类无法执行回调函数修复\n"
update_log=update_log.."  2 多个地图bug 修复"
update_log=update_log.."1.81 新增内容\n"
update_log=update_log.."  1 长乐帮大门的路径修复,明教天地风雷的路径修复\n"
update_log=update_log.."  2 改进路径搜索速度。\n"
update_log=update_log.."1.82 新增内容\n"
update_log=update_log.."  1 姑苏慕容路径修复\n"
update_log=update_log.."  2 walk类bug修复。\n"
update_log=update_log.."1.9 新增内容\n"
update_log=update_log.."  1 wudang 任务bug\n"
update_log=update_log.."  2 华山树林bug修复\n"
update_log=update_log.."  3 巡逻和慕容偷学修复\n"
update_log=update_log.."2.0 新增内容\n"
update_log=update_log.."  1 少林塔林bug修复\n"
update_log=update_log.."  2 自动提送密函<使用>密函\n"
update_log=update_log.."  3 修复自动解锦盒的bug\n"
update_log=update_log.."3.0 新增内容\n"
update_log=update_log.."  1 机器人自动更新插件\n"
update_log=update_log.."  2 自取quest 加入\n"
update_log=update_log.."  3 修复内存溢出问题，mush自动重连问题\n"
update_log=update_log.."3.1 新增内容\n"
update_log=update_log.."  1 累积bug修复\n"
update_log=update_log.."  2 jobslist书写方式改变\n"
update_log=update_log.."3.5 新增内容\n"
update_log=update_log.."  1 map 搜索算法改变\n"
update_log=update_log.."  2 pfm_list格式修改\n"
update_log=update_log.."  3 古墓活死人,古墓绝情谷地图增加\n"
update_log=update_log.."  4 新增工具按钮\n"
update_log=update_log.."3.6 新增内容\n"
update_log=update_log.."  1 map 新增若干房间\n"
update_log=update_log.."  2 gumu 一键full 技能若干bug 修复\n"
update_log=update_log.."  3 重连插件bug修复,自动更新插件bug修复,自动备份配置文件bug修复\n"
update_log=update_log.."  4 gb 抓蛇 慕容偷学bug 五岳并派bug 修复\n"
update_log=update_log.."3.7 新增内容\n"
update_log=update_log.."  1 map 房间bug 修正\n"
update_log=update_log.."  2 新增全真挖药job\n"
update_log=update_log.."  3 新增护镖任务\n"
update_log=update_log.."3.8 新增内容\n"
update_log=update_log.."  1 新增用户配置文件检查排错功能\n"
update_log=update_log.."  2 新增全真古墓守卫任务\n"
update_log=update_log.."  3 新增铁掌模块\n"

function clean_model()
package.loaded["status_win"] = nil
package.loaded["mapper"] = nil
package.loaded["map"] = nil
package.loaded["sj"] = nil

package.loaded["hp"] = nil

package.loaded["wait"] = nil

package.loaded["exps"] = nil
package.loaded["sj_mini_win"] = nil
package.loaded["wizard"] = nil
package.loaded["fight"] = nil
package.loaded["wdj"] = nil
package.loaded["tprint"] = nil
package.loaded["cond"] = nil
--package.loaded["gold"] = nil
package.loaded["equipments"] = nil
package.loaded["jobtimes"] = nil
package.loaded["special_item"] = nil
package.loaded["alias"] = nil
package.loaded["rest"] = nil
package.loaded["xiulian"]=nil
package.loaded["reward"]=nil
package.loaded["movewindow"]=nil
package.loaded["heal"]=nil
package.loaded["lingwu"]=nil
package.loaded["liandu"]=nil
package.loaded["quest"]=nil
package.loaded["hubiao"] = nil
package.loaded["sj_quest"]=nil
package.loaded["shenyou"]=nil
package.loaded["caiyao"]=nil
package.loaded["cisha"]=nil
package.loaded["chujian"]=nil
end

function load_model() --基本公共模块
require "map"
require "hp"
require "wait"
require "sj_mini_win"
require "exps"
require "wizard" --设置精灵
require "jobtimes"
require "special_item"
require "heal"
require "status_win"
require "mapper"
require "reward"
require "movewindow"
require "xiulian"
require "rest"
require "alias"
require "equipments" --装备
--require "gold"
require "cond"
require "tprint"
require "wdj"
require "fight"
require "sj"
require "lingwu"
--require "liandu"
require "quest"
--require "songjian"
--require "shouding"
--require "hubiao"
--require "wudang"
--require "xueshan"
--require "kanchai"
require "sj_quest"
require "chujian"
--require "tiezhang"
--require "gmshouwei"
--require "shenyou"
--require "caiyao"
end
load_model()
--[[
require "teachmonk"
require "tiaoshui"
require "huxi"
require "learn"
require "wuguan"

require "xuncheng"
require "changle"
require "songxin"
--require "combat"
require "songshan"
require "xueshan"
require "tiandi"

require "huashan"
require "wudang"
require "jiaohua"
require "hqg"

require "touxue"
require "gaibang"
require "fish"
require "lingwu"

require "suoming" --神龙岛索命
require "zhuashe"
require "aozhou"
--require "caikuang" --采矿
require "xunluo" --明教巡逻
require "shoumu" --桃花岛守墓
require "duicao"
require "jiuyuan" --救援任务
--require "taishan" --泰山任务

require "zhuachong"
require "qiangjie"
require "liandu"
--require "ouyangke"
require "lian"
--require "fb"
require "hubiao" --ok1
--require "ckns2"
--require "qqll"
--require "bigdata" --大数据分析

require "gumu" --活死人墓
require "songmoya"]]
require "qqll"
require "chujian"
require "kjmg"
require "fish"
function clear_timer()
world.AddTimer("clear", 0, 0, 40, "print(\"清理前:\",collectgarbage(\"count\"))\ncollectgarbage(\"collect\")\nprint(\"清理后:\",collectgarbage(\"count\"))", timer_flag.Enabled , "")
world.SetTimerOption ("clear", "send_to", 12)
end
local world_init=function()--重连回调函数
end

local xp=exps.new()
sj.xp=xp--升级成全局变量
xp:reset()
--进程中断恢复 切换
--进程队列
--VIP 选项
run_vip=false
--real_vip=true  --vip 开关
map_init("sjcentury.db") --地图数据库
--Coordinate(1543)
local break_point={}
function switch(address)

--强制切换
   --需要保存变量 执行最后执行到元素
 --前后台切换
 --监视当前进程变量值
    shutdown()
   print("终止当前！")
    --table.insert(background,address)
 --前台切换
  local f=function()
    local b
	b=busy.new()
	b.Next=function()
	   address()
	end
	b:check()
  end
  f_wait(f,0.1)
end

function rollback()
    local object
	local n=table.getn(break_point)
	local bp=break_point[n]
	local r=bp.source
	r:rollback(bp.variable,bp.method)
end
--local register_job={} --注册的job
--job 顺序注册
local function chinese_job_name(jobname)
		local job
	     if jobname=="长乐帮" then
		    job="cl"
		 elseif jobname=="强抢美女" then
		    job="xs"
		 elseif jobname=="大理送信" or jobname=="送信" then
		    job="sx"
		 elseif jobname=="天地会" then
		    job="tdh"
		 elseif jobname=="华山" or jobname=="惩奸除恶" or jobname=="惩恶扬善" then
		    local do_hs2=world.GetVariable("do_hs2")
			if do_hs2=="true" then
			  job="hs2"
			else
		      job="hs"
			end
		 elseif jobname=="丐帮抓蛇" then
		    job="zs"
		 elseif jobname=="丐帮" then
		    job="gb"
		 elseif jobname=="武当锄奸" or jobname=="武当" then
		    job="wd"
		 elseif jobname=="神龙教" then
		    job="suoming"
		 elseif jobname=="浇花" then
		    job="jiaohua"
		 elseif jobname=="熬粥" then
		    job="az"
		 elseif jobname=="嵩山并派" or jobname=="嵩山" then
		    job="ss"
		 elseif jobname=="训练武僧" then
		    job="tm"
		 elseif jobname=="慕容偷学" then
		    job="tx"
		 elseif jobname=="桃花岛守墓" then
		    job="sm"
		 elseif jobname=="明教巡逻" then
		    job="xl"
		 elseif jobname=="恒山救援" then
		    job="jy"
		 elseif jobname=="泰山" then
		    job="ts"
		 elseif jobname=="星宿抓虫子" then
		     job="xxbug"
		 elseif jobname=="欧阳克" then
		     job="oyk"
		  elseif jobname=="星宿抢劫" then
		     job="qj"
		 elseif jobname=="七窍玲珑" then
		     job="qqll"
		 elseif jobname=="护镖" or jobname=="福州护镖" then
		     job="hb"
		 elseif jobname=="抗敌颂摩崖" then
		     job="smy"
		 elseif jobname=="星宿叛徒" then
		     job="xxpt"
		  elseif jobname=="日月复兴" then
		     job="ryfx"
		  elseif jobname=="看守铜鼎" then
		     job="ks"
		  elseif jobname=="砍柴" then
		     job="kc"
		  elseif jobname=="报效国家" or jobname=="火烧草料场" then
		     job="cisha"
		   elseif jobname=="全真教采药" or jobname=="全真采药" then
		     job="caiyao"
		    elseif jobname=="铁掌" then
			 job="tz"
			elseif jobname=="全真守卫" then
			  job="gmsw"
			elseif jobname=="全真锄奸" then
			  job="cj"
			elseif jobname=="抗敌蒙古入侵" then
			   job="kjmg"
  		 end
		 --print(job)
		 return job

end

local function check_job(name)
    local f={}
   if name=="cl" or name=="clb" then
       f=function() Weapon_Check(process.cl) end
	elseif name=="长乐帮" then
	    f=function() Weapon_Check(process.cl) end
	elseif name=="sx" then
	   f=function() Weapon_Check(process.sx) end
	elseif name=="送信" then
	   f=function() Weapon_Check(process.sx) end
	elseif name=="wd" then
	  f=function() Weapon_Check(process.wd) end
	elseif name=="武当" then
	  f=function() Weapon_Check(process.wd) end
	elseif name=="xs" then
	  f=function() Weapon_Check(process.xs) end
	elseif name=="雪山" then
	  f=function() Weapon_Check(process.xs) end
	elseif name=="ss" then
	  f=function() Weapon_Check(process.ss) end
	elseif name=="嵩山" then
	  f=function() Weapon_Check(process.ss) end
	elseif name=="gb" then
	  f=function() Weapon_Check(process.gb) end
	elseif name=="丐帮" then
	  f=function() Weapon_Check(process.gb) end
	elseif name=="tdh" then
	  f= function() Weapon_Check(process.tdh) end
	elseif name=="天地会" then
	  f= function() Weapon_Check(process.tdh) end
	elseif name=="hs" or name=="hs1" then
	  f=function() Weapon_Check(process.hs) end
	elseif name=="华山" then
	  f=function() Weapon_Check(process.hs) end
	elseif name=="hs2" then
	  f=function() Weapon_Check(process.hs2) end
	elseif name=="华山2" then
	  f=function() Weapon_Check(process.hs2) end
	elseif name=="zc" then
	  f=function() Weapon_Check(process.zc) end
	elseif name=="做菜" then
	  f=function() Weapon_Check(process.zc) end
	elseif name=="xc" then
	  f=function() Weapon_Check(process.xc) end
	elseif name=="巡城" then
	  f=function() Weapon_Check(process.xc) end
	elseif name=="zs" then
	  f= function() Weapon_Check(process.zs) end
	elseif name=="抓蛇" then
	  f= function() Weapon_Check(process.zs) end
	elseif name=="suoming" then
	  f= function() Weapon_Check(process.suoming) end
	elseif name=="神龙岛索命" then
	  f= function() Weapon_Check(process.suoming) end
	elseif name=="jh" then
	  f=function() process.jh() end
	elseif name=="浇花" then
	  f=function() process.jh() end
	elseif name=="az" then
	  f=function() process.az() end
	elseif name=="ss" then
	  f=function() Weapon_Check(process.ss) end
	elseif name=="嵩山" then
	  f=function() Weapon_Check(process.ss) end
	elseif name=="tm" then
	  f=function() Weapon_Check(process.tm) end
	elseif name=="少林教学" then
	  f=function() Weapon_Check(process.tm) end
	elseif name=="tx" then
	  f= function() Weapon_Check(process.tx) end
	elseif name=="慕容偷学" then
	  f= function() Weapon_Check(process.tx) end
	elseif name=="sm" then
	  f=function() Weapon_Check(process.sm) end
	elseif name=="桃花守墓" then
	  f=function() Weapon_Check(process.sm) end
	elseif name=="ck" then
	  f=function() process.ck() end
	elseif name=="采矿" then
	  f=function() process.ck() end
	elseif name=="xl" then
	  f= function() Weapon_Check(process.xl) end
	elseif name=="明教巡逻" then
	  f= function() Weapon_Check(process.xl) end
    elseif name=="jy" then
	  f=function() Weapon_Check(process.jy) end
	 elseif name=="少林救援" then
	  f=function() Weapon_Check(process.jy) end
	elseif name=="ts" then
	  f=function() Weapon_Check(process.ts) end
	elseif name=="xxbug" then
	  f=function() Weapon_Check(process.xxbug) end
	elseif name=="星宿抓虫" then
	  f=function() Weapon_Check(process.xxbug) end
	elseif name=="oyk" then
	  f= function() Weapon_Check(process.oyk) end
	elseif name=="qqll" then
	  f= function() Weapon_Check(process.qqllyu) end
	elseif name=="七巧玲珑玉" then
	  f= function() Weapon_Check(process.qqllyu) end
   	elseif name=="qj" then
	  f= function() Weapon_Check(process.qj) end
	elseif name=="星宿抢劫" then
	  f= function() Weapon_Check(process.qj) end
	elseif name=="护镖" then
	  f= function() Weapon_Check(process.hb) end
	elseif name=="hb" then
	  f= function() Weapon_Check(process.hb) end
	elseif name=="抗敌颂摩崖" then
	  f=function() Weapon_Check(process.smy) end
	elseif name=="smy" then
	  f=function() Weapon_Check(process.smy) end
	elseif name=="xxpt" then
	   f=function() Weapon_Check(process.xxpt) end
	elseif name=="星宿叛徒" then
	   f=function() Weapon_Check(process.xxpt) end
	elseif name=="日月复兴" then
	   f=function() Weapon_Check(process.ryfx) end
	elseif name=="ryfx" then
	   f=function() Weapon_Check(process.ryfx) end
	elseif name=="看守铜鼎" then
	  f=function() Weapon_Check(process.ks) end
	elseif name=="ks" then
	  f=function() Weapon_Check(process.ks) end
	elseif name=="kc" then
	  f=function() Weapon_Check(process.kc) end
    elseif name=="华山砍柴" then
	  f=function() Weapon_Check(process.kc) end
	elseif name=="报效国家" then
	  f=function() Weapon_Check(process.cisha) end
	elseif name=="cisha" then
	  f=function() Weapon_Check(process.cisha) end
	elseif name=="caiyao" then
	  f=function() Weapon_Check(process.caiyao) end
	elseif name=="采药" then
	   f=function() Weapon_Check(process.caiyao) end
	elseif name=="tz" then
	  f=function() Weapon_Check(process.tz) end
	elseif name=="铁掌" then
	   f=function() Weapon_Check(process.tz) end
	elseif name=="gmsw" then
	   f=function() Weapon_Check(process.gmsw) end
	elseif name=="全真守卫" then
	   f=function() Weapon_Check(process.gmsw) end
	elseif name=="cj" then
	    f=function() Weapon_Check(process.cj) end
	elseif name=="全真锄奸" then
	    f=function() Weapon_Check(process.cj) end
	elseif name=="抗敌蒙古入侵" then
	    f=function() Weapon_Check(process.kjmg) end
	elseif name=="kjmg" then
	    f=function() Weapon_Check(process.kjmg) end
     else
	  local jobname=name
      f=function() print("不正确jobslist,未知任务"..jobname) end
    end
	return f
end

function create_sub_jobslist(str,index)
     --local b=string.reverse(str)
  local s1,e1=string.find(str,"%(")
  --print(s1,e1)
  if s1==nil then
      return false,nil,str
  end
  local s2,e2=string.find(str,")")
  local value=string.sub(str,s1+1,s2-1)  --去掉括号( )
  --print(value)
  --value=string.sub(value,2,-2)
  --value=string.gsub(value,"|","&")
  str=string.sub(str,1,s1-1).."group"..index..""..string.sub(str,s2+1,string.len(str))
   return true,value,str
end

local function get_sub_jobslist(str,dictionary)
  	   --新的
	   local _jobslist={}
	   local j=Split(str,"|")
	   local i
	   for i=1,table.getn(j),1 do
	     local current_job=j[i]
		 --print(current_job)
	     local k
		  k=i+1
	      if k>table.getn(j) then
	        k=1
	      end
	      local value=j[k]
		  local item={}
			item.name=current_job
			item.nextjob=value
	      if string.find(current_job,"group") then  --是个组
	        --将组名转成table
		    local group={}
		    local _sub_str=dictionary[current_job] --获取子字符串
			  group=get_sub_jobslist(_sub_str,dictionary)
			 item.group=group
	      else

		     item.group=nil

		  end
	      table.insert(_jobslist,item)
	   end
	   return _jobslist
end

local function get_group_job_next(groupname,tab)
   --(武当|雪山)|华山   表示 武当->华山->雪山 | 雪山->华山->武当  华山->武当 华山->雪山
  for _,i in pairs(tab) do
       if i.name==groupname then
	       for _,item in pairs(i.group) do
             return item.name,item.nextjob

		   end


	   end

   end
end
-- 两种获取 job顺序方法
function get_job_next(jobname,tab)

   --[[for _,i in pairs(tab) do
       if i.name==jobname then
	       --row 嵩山 group1 雪山 | 长乐
	       if string.find(i.nextjob,"group") then  --如果是一个组需要 拆开组
              print("是 group")
			  local nextjob,bei_job=get_group_job_next(i.nextjob,tab)
			  return nextjob,bei_job
		   end
	       return i.nextjob,i.nextjob
	   end
	   --是个组  分解组
       if i.group~=nil then  --寻找子
           local sub_item=get_job_next(jobname,i.group)
		   if sub_item~=nil then  --子表中找到
		      return i.nextjob,i.nextjob
		   end
	   end

   end
   return nil]]
   return tab[jobname].jb1,tab[jobname].jb2
end
--新的
function get_jobslist()
    --local main_jobslist={}
    local lookup_sub_jobslist={}
	local jobslist=world.GetVariable("jobslist")
	--sx,hs,wd|wd,hs|
	local group={}
	group=Split(jobslist,"|")
	local tb={}
	for _,v in ipairs(group) do
	   local item=Split(v,",")

	   local index=item[1]
	   local job1=item[2]
	   local job2=item[3]

	   if job2==nil then
	      job2=v[1]
	   end
	   print(index,job1,job2)
	   tb[index]={}
	   tb[index].jb1=job1
	   tb[index].jb2=job2
	end
	return tb
	--[[
    if jobslist~=nil then
	   local index=1
       while true do
	      local is_exist,sub_list,newjobslist=create_sub_jobslist(jobslist,index) --返回三个值 是否存在子序列 子序列 新主序列
		  jobslist=newjobslist
		  if is_exist==true then
			  lookup_sub_jobslist["group"..index]=sub_list

			  --print("group"..index," @ ",sub_list)
			  index=index+1
		  else

		      break
		  end

 	   end

       local tab={}
	   tab=get_sub_jobslist(jobslist,lookup_sub_jobslist)
	    --测试

	   for _,i in pairs(tab) do
	       print("测试1:",i.name,i.nextjob)
		   if i.group~=nil then
		      for _,j in pairs(i.group) do
			      print("测试2:",j.name,j.nextjob)
			  end
		   end
	   end
	   return tab
	else
	   return nil
	end]]
end

function test_jobslist(name)
 local tb=get_jobslist()
   local vv,bei_vv=get_job_next(name,tb)
   --如果 vv 是group的话 成功1 失败 0 进行判断

    print("结果:",vv," bei ",bei_vv)
end

function Job_Next(name)
   --print("清理前:",collectgarbage("count"))
   collectgarbage("collect")
    local tb=get_jobslist()
   local vv,bei_vv=get_job_next(name,tb)
   --如果 vv 是group的话 成功1 失败 0 进行判断

   -- print("结果:",vv," bei ",bei_vv)
	if vv==bei_vv then
	   return vv,vv
	end
	return vv,bei_vv
   --print("清理后:",collectgarbage("count"))
   --2016-8-24 修改 jobslist格式为 (武当|送信1)|华山1
   --[[register()
   for _,i in ipairs(register_job) do
      --print(register_job)
      if i.current_job_name==name then
	    if i.next_job2=="" or i.next_job2==nil then
	      return check_job(i.next_job)
	    else
		  return i.next_job,i.next_job2--返回两个值
		end
	  end
   end]]
end
------------
-- 线程表，储存正在暂停的线程
local wait_table = {}
--setmetatable(wait_table, {__mode = "k"}) --weak table
-- 被定时器调用以恢复一个暂停的线程
function wait_timer_resume(name)
  --print(table.getn(wait_table),"数组大小")
  --print("wait_id: ",name)

  local thread = wait_table[name]

  if thread~=nil then
    assert(coroutine.resume (thread),"coroutine exception")
	 --assert (coroutine.running (), "Must be in coroutine")
  else
    --print(name," 不存在")
	return
  end -- if
  wait_table[name]=nil
  --collectgarbage()--垃圾回收
end -- function wait_timer_resume

-- 在脚本中调用这个函数来暂停当前的线程
function f_wait(address, seconds,ActiveWhenClosed)
  if seconds==nil then
      address()
	  return
  end
  if seconds<=0 then
    address()
	return
  end
  id = "wait_timer_" .. GetUniqueNumber ()
  hours = math.floor(seconds / 3600)
  seconds = seconds - (hours * 3600)
  minutes = math.floor(seconds / 60)
  seconds = seconds - (minutes * 60)
  --print("等待",seconds,"s"," ",id)
  wait_table[id] =coroutine.create(function()
     --print("执行")
     address()
  end)
  if ActiveWhenClosed==true then
    status = AddTimer (id, hours, minutes, seconds, "",
            timer_flag.Enabled + timer_flag.OneShot +
            timer_flag.Temporary + timer_flag.Replace+timer_flag.ActiveWhenClosed,
            "wait_timer_resume")
  else
	status = AddTimer (id, hours, minutes, seconds, "",
            timer_flag.Enabled + timer_flag.OneShot +
            timer_flag.Temporary + timer_flag.Replace,
            "wait_timer_resume")
  end
  assert(status == error_code.eOK, error_desc[status])
end

function f_clear()
   for i,v in pairs(wait_table) do
      local thread=wait_table[i]
	  if thread then
        wait_table[i]=nil
		--print(i)
	    --print(coroutine.status(thread))
      end
   end
   wait_table={}
end

function ChineseNum(n)
   local num=0
   local h_pos=0
   local l_pos=0
   for i=1,string.len(n),2 do
       local w=string.sub(n,i,i+1)
	   --print(w)
	   if w=="亿" then
	      num=num+h_pos*10000000
          h_pos=0
	   elseif w=="万" then
	      num=num+h_pos*10000
          h_pos=0
	   elseif w=="千" then
	      num=num+h_pos*1000
	      h_pos=0
	   elseif w=="百" then
		  num=num+h_pos*100
	      h_pos=0
	   elseif w=="十" then
	      if h_pos==0 then
		     num=num+10
		  else
			num=num+h_pos*10
			h_pos=0
		  end
	   elseif w=="一" then
	      h_pos=1
	   elseif w=="二" then
	      h_pos=2
	   elseif w=="三" then
	      h_pos=3
	   elseif w=="四" then
	      h_pos=4
	   elseif w=="五" then
	      h_pos=5
	   elseif w=="六" then
	      h_pos=6
	   elseif w=="七" then
	      h_pos=7
	   elseif w=="八" then
	      h_pos=8
	   elseif w=="九" then
	      h_pos=9
	   elseif w=="零" then
	      h_pos=0
 	   end
   end
   num=num+h_pos
   return num
end

local function start()
  --while true do  --主循环
    package.loaded["wuguan"]=nil
  require "wuguan"

    local newbie_robot
    newbie_robot=wuguan.new()
    world.Send("answer y")
	local f=function()
       newbie_robot:step1()
	end
	f_wait(f,3)
  --end
end

local function cun_pot(CallBack)
  	    --保存pot
		local w=walk.new()
		w.walkover=function()
		  local h=hp.new()
          h.checkover=function()
			world.Send("qn_cun "..h.pot)
		    CallBack()
          end
          h:check()

		end
		w:go(4067)
end

local function consume(CallBack)
   local up=world.GetVariable("up")
   if up==nil then
      up="learn"
   end
   if up=="literate" then
	  learn_literate(CallBack)
   elseif up=="learn" then
      Go_learn(CallBack)
   elseif up=="duanzao" then
      duanzao_learn(CallBack)
   elseif up=="zhizao" then
      zhizao_learn(CallBack)
   elseif up=="lingwu" then
       Go_lingwu(CallBack,true)
   --elseif up=="full_lingwu" then
   --    Go_full_lingwu(CallBack)
   elseif up=="taojiao" then
       taojiao(CallBack)
   elseif up=="shenzhaojing" then
       Shenzhaojing_learn(CallBack)
   elseif up=="9yzj" then
	   du_zhenjing(CallBack)
   elseif up=="chenggao" then
      chenggao_learn(CallBack)
   elseif up=="cun_pot" or up=="cun_pots" then
       cun_pot(CallBack)
   else
      Go_lingwu(CallBack,true)
   end
end

function ReadNext()
end

function du_zhenjing(CallBack)
  local skills=world.GetVariable("skills")
   print("读真经")
   print(skills)
	local items={}
	items=Split(skills,"|")
	local f=function(items)
	    local i=0
		return function()
		    i=i+1
			if i<=table.getn(items) then
			 -- return items[i]
			   local skill=items[i]
	            print(skill)
			   local cmd="read "..skill
	           process.readbook(cmd,CallBack)
			else
			   CallBack()
			end
		end
	end
	ReadNext=f(items)
	ReadNext()

end

function canwu_gift(CallBack)
       --local canwu_exp = 1600000
	   --canwu_exp = canwu_exp * point
      -- local exert_gift =tonumber(world.GetVariable("exert_gift")) or 0
	   --local min_exps=(exert_gift+1)*1000000
	   --canwu_exp=exert_gift*10000+canwu_exp
	  -- local combat_exp=world.GetVariable("exps")
     --print(combat_exp-canwu_exp," now exps")
	 --print(min_exps," min_exps")  --
	 --if min_exps > combat_exp-canwu_exp then
	 --    Status_Check(CallBack)
     --    return
	 --end
  local w=walk.new()
   w.walkover=function()
     world.Send("canwu gift")
	 --world.Send("canwu gift 1")
	 --local canwu_gift_limit=world.GetVariable("canwu_gift_limit") or 4600000
	 --canwu_gift_limit=tonumber(canwu_gift_limit) or 4600000
	 --canwu_gift_limit=canwu_gift_limit+1000000
	 --world.SetVariable("canwu_gift_limit",canwu_gift_limit)
	 local f=function()
	   local point= world.GetVariable("addgift") or ""
	   if point~="" then
	      world.Send("addgift 1 to "..point)
	   end
	   world.Send("score")
	   get_score()
	   Status_Check(CallBack)
	 end
	 f_wait(f,20)
   end
  w:go(5004)
end

local function canwu_combat(CallBack)
  local w=walk.new()
  w.walkover=function()
     world.Send("canwu combat")
	 --wait(20)
	 local f=function()
		world.Send("score")
	    get_score()
	   Status_Check(CallBack)
	 end
	 f_wait(f,20)
  end
  w:go(5003)

end

function Status_Check(CallBack)

	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 local neili_upper=world.GetVariable("neili_upper") or 1.8
	 local vip=world.GetVariable("vip") or "普通玩家"
	 neili_upper=tonumber(neili_upper)
     --初始化
	local h
	h=hp.new()
	h.checkover=function()
	     --print(h.neili_limit," 内力  ",h.max_neili)
		 --print(h.jingli_limit," 精力 ",h.max_jingli)
		local xiulian=world.GetVariable("xiulian") or ""
		if xiulian~="xiulian_dubook" then
		  if h.max_neili<h.neili_limit then
		  world.SetVariable("xiulian","xiulian_neili")

		 elseif h.max_jingli<h.jingli_limit then
           world.SetVariable("xiulian","xiulian_jingli")
	     else
		    world.SetVariable("xiulian","xiulian_skills")
         end
		end
	    if (h.food<50 or h.drink<50) and vip~="荣誉终身贵宾" then
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
				    Status_Check(CallBack)
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(1960) --299 ask xiao tong about 食物 ask xiao tong about 茶

		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
			local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   Status_Check(CallBack)
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("打通经脉")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   Status_Check(CallBack)
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 and h.qi_percent>liao_percent then
			print("打通经脉")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config 全局变量
			--rc.liaoshang_fail=self.liaoshang_fail
			rc.saferoom=505
			rc.heal_ok=function()
			   Status_Check(CallBack)
			end
			rc:heal(true,false)
		elseif h.neili<h.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                Status_Check(CallBack)
            end
			r:wash()

		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			   consume(CallBack)
			end
			b:check()
		end
	end
	h:check()
end

function level_up(CallBack)
   ---2011-1-9
   --先进行检查身体状况
   Status_Check(CallBack)

end

local function neigong()
   local x
   x=xiulian.new()
   x.safe_qi=100
   x.min_amount=100
   x.fail=function(id)
      --print(id)
	  if id==201 or id==1 or id==777 then
	     local f
		 f=function() x:dazuo() end  --外壳
	     f_wait(f,10)
	  end
	  if id==202 then
	     local w
		 w=walk.new()
		 w.walkover=function()
			x:dazuo()
		 end
		 w:go(1817)
	  end
   end
   x.success=function(h)

	  if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then --气量太少了 sleep 恢复
	      print("sleep 恢复")
		  local w
		  w=walk.new()
		  w.walkover=function()
			local r
			r=rest.new()
			r.wake=function()
			  --醒来
			  local w2
			  w2=walk.new()
			  w2.walkover=function()
				x:dazuo()
			  end
			  w2:go(1817)
			end
			r:sleep()
		  end
		  w:go(1818)
	  else
	     print("继续修炼")
		 --h.checkover()
		 x:dazuo()
	  end
   end
   x:dazuo()
end


local function neigong2(flag)
    if flag==true then
	  sj.World_Init=function()
          process.neigong2(flag)
      end
   end
   world.Send("unset 积蓄")
   local x
   x=xiulian.new()
   x.safe_qi=100
   x.fail=function(id)
      --print(id)
	  if id==301  then
		 world.Send("yun recover")
	     local f
		 f=function() x:tuna() end  --外壳
	     f_wait(f,5)
	  end
	  if id==1 then
		if eat_dan==true then
		   eat_dan=false
		   world.Send("fu neixi wan")  --吃摇头丸
		 else
		   eat_dan=true
		 end
		  world.Send("yun regenerate")
	     local f
		 f=function() x:tuna() end  --外壳
	     f_wait(f,5)
	  end
	  if id==202 then
		local w
		 w=walk.new()
		 w.walkover=function()
			x:tuna()
		 end
		local _R
        _R=Room.new()
        _R.CatchEnd=function()
          local count,roomno=Locate(_R)
		  print(roomno[1])
		    local r=nearest_room(roomno)
	        w:go(r)
	    end
       _R:CatchStart()
	  end
   end
   x.success=function(h)
      print(h.jingxue,"<=",x.safe_jingxue+h.max_jingli/2)
	  print(h.jingli,"<",h.max_jingli+10)
	  print(h.neili,"<300")
	  if h.max_jingli>=h.jingli_limit then
	     print("内力到达上限")
		 --callback()
		 if process.jobbusy~=nil then
		 process.jobbusy()
		 end
	     return
	  end
	  --(h.jingxue<=x.safe_jingxue+h.max_jingli/2) and (h.jingli<h.max_jingli+10) and
	  if  (h.neili<=800) then --气量太少了 sleep 恢复 打坐恢复
	      world.Send("yun regenerate")
	     x:dazuo()

	  else
	     print("继续修炼")
		 world.Send("yun regenerate")
		 x:tuna()
	  end
   end
   x:tuna()
end

local eat_dan=false

local function neigong3(flag)
   if flag==true then
	  sj.World_Init=function()
          process.neigong3(flag)
      end
   end
   local x
   x=xiulian.new()
   x.safe_qi=100
   x.min_amount=100
   x.fail=function(id)
      print(id)
	  if id==1 or id==777 then
	     --正循环打坐
		 print("正循环打坐")
		 Send("yun recover")
		 if eat_dan==true then
		   eat_dan=false
		   world.Send("fu neixi wan")  --吃摇头丸
		 else
		   eat_dan=true
		 end
		 x:dazuo()
	  end
	  if id==201 then
	      world.Send("yun regenerate")
		  local f=function()
		    x:dazuo()
		  end
		  f_wait(f,2)
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
		  print(roomno[1])
		    local r=nearest_room(roomno)

	        w:go(r)
	    end
       _R:CatchStart()
	  end
   end
   x.success=function(h)
      if h.max_neili>=h.neili_limit then
	     print("内力到达上限")
		 if process.jobbusy~=nil then
		 process.jobbusy()
		 end
	     return
	  end
	  if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then --气量太少了 sleep 恢复
	     --[[ print("sleep 恢复")
		  local w
		  w=walk.new()
		  w.walkover=function()
			local r
			r=rest.new()
			r.wake=function()
			  --醒来
			  xiulian_Status_Check(process.neigong3)
			end
			r:sleep()
		  end
		  w:go(308)]]
		  print("正循环打坐")
		 Send("yun recover")
		 x:dazuo()
	  else
	     print("继续修炼")
		 x:dazuo()
	  end
   end
   x:dazuo()
end

function self_repair_items(CallBack)
    local _self_repair=world.GetVariable("self_repair")
    _items=Split(_self_repair,"|")
	local self_item_list={}
	for _,item in ipairs(_items) do

	   local i={}
	   i.id=Trim(item)
	   if string.find(item,"boot") or string.find(item,"belt") or string.find(item,"coat") or string.find(item,"glove") or string.find(item,"cap") or string.find(item,"armor") or string.find(item,"mantle") then
	       i.item_type="防具"
	   else
	       i.item_type="兵器"
	   end
	   table.insert(self_item_list,i)
	end
	local _equip=equipments.new()
	 _equip.finish=function()
	    coroutine.resume(equipments.eq_co)
	 end
	_equip:check_equipments(self_item_list,CallBack)
end

local last_check_time=nil
function Get_items(CallBack,g_i_equip)
   --print("GET ITEMS")
   local sp=special_item.new()
   local i_equip=world.GetVariable("i_equip")
   if g_i_equip~=nil then
      i_equip=g_i_equip
   end
   if i_equip==nil or i_equip=="" then
       --CallBack()
	   --默认set
	  i_equip=special_item.default_setting
   end
	  local equip={}
	  equip=Split(i_equip,"|")
      sp.recheck=function(item_name,item_id)
	    --print(item_name,item_id,"!!!")
	    local del_item="<获取>"..item_name.."|"
		--print(del_item)
		i_equip=string.gsub(i_equip,del_item,"")
		del_item="|<获取>"..item_name
		i_equip=string.gsub(i_equip,del_item,"")
		--print("new i_equip",i_equip)
		Get_items(CallBack,i_equip)  --必须重新检验
	  end
      sp.relogin=function()
	     Get_items(CallBack)
	  end
	  sp.cooldown=function()  --检查完毕
	     print("检查物品结束")
		 sp.sp_co=nil
		 CallBack()
	  end
	  local t1=os.time()
	  if last_check_time==nil then
	    sp:check_items(equip,true)
		last_check_time=os.time()
	  elseif os.difftime(t1,last_check_time)>=10*60 then --超过20分钟才会检查
	     print("最大化物品检查!!!!!")
	     sp:check_items(equip,true)
		 last_check_time=os.time()
	  else
	      print("最小化物品检查")
		  print(os.difftime(t1,last_check_time)," 物品检查间隔")
	      sp:check_items(equip,false)
	  end
   --end
end

function Weapon_Check(CallBack)
	local dugu=_G["独孤"]
	if dugu==true then
	    world.Send("jifa all")
		_G["独孤"]=false
	end
    local fen=_G["焚"]
    if fen==true then
	    print("火焰刀焚20秒重新登录！")
         _G["焚"]=false
		 world_init=function()
		    print("重新连接，检查MY武器！！！")
			Weapon_Check(CallBack)
		 end
		 local b=busy.new()
		 b.Next=function()
			relogin(20)
		 end
		 b:check()
	    return
	end
	-- 月卡到期
	local t1=os.time()
	if sj.month_expire~=nil and sj.month_expire~="" then
	 if t1>=sj.month_expire then
	   local g=function()
	      Weapon_Check(CallBack)
	   end
       ask_month_vip(g)
	   return
	 end
	else
	  get_clock_time()
    end
	local exps=world.GetVariable("exps")
	local exert_reward=world.GetVariable("exert_reward")
	local exert_gift=world.GetVariable("exert_gift") or "0"
	local is_canwu=world.GetVariable("is_canwu") or "true"
	local canwu_exps_limit=tonumber(world.GetVariable("canwu_exps_limit")) or 15000000
	local canwu_gift_limit=tonumber(world.GetVariable("canwu_gift_limit")) or 20000000
	if tonumber(exps)>canwu_exps_limit and tonumber(exert_reward)<100 and is_canwu=="true" then
	   --print("zhix")
	   canwu_combat(CallBack)
	   return
	end
     if tonumber(exps)>canwu_gift_limit and tonumber(exert_gift)<119 and is_canwu=="true" then
	   canwu_gift(CallBack)
	   return
	end
	local wrap=function()
	     print("内存清理")
		 Clean_Memory()  --内存清理
	     print("检查随身携带")
		 Get_items(CallBack)
	end
	local dk=function()
	  --print("222")
	  local q_list=world.GetVariable("quest_list") or ""
	  local _list={}
	  if q_list~="" then
	      _list=Split(q_list,"|")
	  end
	  package.loaded["quest"]=nil
	  require "quest"
	  local q=quest.new()
	  q.list=_list
	  local quest_over=function()
	    print("内存清理")
		 Clean_Memory()  --内存清理
	     print("检查随身携带")
		 Get_items(CallBack)
	  end
	  q:auto_check(quest_over)
	end
	--五毒教
	local wdj_entry=world.GetVariable("wdj_entry") or ""
	local auto_ask=world.GetVariable("auto_ask") or ""
	--print(szj_ask,"szj")
	if wdj_entry=="true" then
	    local _wdj=wdj.new()
		_wdj.finish=function()

			if auto_ask=="true" then
			  dk()
			else
			  wrap()
			end
		end
		_wdj:go()
		--sj.wdj_enter(dk)
	else

	      if auto_ask=="true" then
			  dk()
		  else
			  wrap()
		  end
	end
	---
end

function xiulian_Status_Check(CallBack)
    local changle_eat=world.GetVariable("changle_eat") or nil
	local vip=world.GetVariable("vip") or "普通玩家"
	if (changle_eat=="true" or changle_eat==nil) and vip~="荣誉终身贵宾" then
     -- print("主程序吃喝！！")
	    local h
	    h=hp.new()
	    h.checkover=function()
	   	     print(h.neili_limit," 内力  ",h.max_neili)
		 print(h.jingli_limit," 精力 ",h.max_jingli)
		 if xiulian~="xiulian_dubook" then
	  	  if h.max_neili<h.neili_limit-100 then
		     world.SetVariable("xiulian","xiulian_neili")

		   elseif h.max_jingli<h.jingli_limit then
              world.SetVariable("xiulian","xiulian_jingli")
	       else
		      world.SetVariable("xiulian","xiulian_skills")
           end
		end
	      if h.food<60 or h.drink<60 then
		   print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
			   world.Send("ask xiao tong about 食物")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get mi fan")
			  	 world.Execute("eat mi fan;eat mi fan;eat mi fan;eat mi fan;drop mi fan")
				 local f
				 f=function()
				     world.Send("ask xiao tong about 茶")
			        local b
			        b=busy.new()
			        b.interval=0.3
			        b.Next=function()
			          world.Execute("get cha")
					  world.Execute("drink cha;drink cha;drink cha;drop cha")
				      local f2
				     f2=function()
				       xiulian_Status_Check(CallBack)
				     end
				     f_wait(f2,1.5)
				    end
					b:check()
			     end
				 f_wait(f,1.5)
			   end
			   b:check()
		   end
		    w:go(133) --299 ask xiao tong about 食物 ask xiao tong about 茶
		  else
		     --print("ok")
		     CallBack()
		  end
	    end
	    h:check()
	else
		--print("ok")
		 CallBack()
	end
end

function World_Check_Open(count)
   if IsConnected()==true then
         local auto_getitem=world.GetVariable("auto_getitem") or ""
		 if auto_getitem~="" then
		   login_getitem(auto_getitem)
		 else
	       sj.world_init()
		 end
   else  --延迟3s 进行检测
        if count==nil then
		    count=0
		else
		    count=count+1
			if count>=5 then
			   relogin(5)
			   return
			end
		end
	    world.AddTimer ("Check_Open_timer", 0, 0, 3, "World_Check_Open("..count..")", timer_flag.Enabled + timer_flag.OneShot + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
		world.SetTimerOption ("Check_Open_timer", "send_to", 12)
   end
end

function World_Opening()
  if IsConnected()==false then
    --sj.log_catch(WorldName().."重新连接",1)
    world.ResetIP()--重新设置ip
    world.Connect()
	World_Check_Open()
  end
end

function quit_saveitem(cmd,sec)  --quit 前把物品保存了

   local w=walk.new()
   w.walkover=function()
	  local cmds=Split(cmd,";")
	  wait.make(function()
	    for _,c in ipairs(cmds) do
		  world.Execute(c)
		  wait.time(1)
	    end
		 relogin(sec,false)
	  end)
   end
   w:go(94)
end

function login_getitem(cmd)

   local w=walk.new()
   w.walkover=function()
      local cmds=Split(cmd,";")
	  wait.make(function()
	    for _,c in ipairs(cmds) do
		  world.Execute(c)
		  wait.time(1)
	    end
		sj.world_init()
	  end)
   end
   w:go(94)
end

function relogin(sec,is_save)
 local auto_saveitem=world.GetVariable("auto_saveitem") or ""
 if auto_saveitem~="" and is_save==true then
    quit_saveitem(auto_saveitem)
  end
   if sec~=nil then
	  local hour=math.floor(sec/3600)
      sec=sec-hour*3600
      local mins=math.floor(sec/60)
      sec=sec-mins*60
      world.AddTimer ("my_timer", hour, mins, sec, "World_Opening()", timer_flag.Enabled + timer_flag.OneShot + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
   else
      world.AddTimer ("my_timer", 0, 10, 0, "World_Opening()", timer_flag.Enabled + timer_flag.OneShot + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
   end

    world.SetTimerOption ("my_timer", "send_to", 12)
    world.Send("quit")

end

function lian_force(CallBack)
   print("开始练习")
	 local ss_lian={}
	  ss_lian=lian.new()
	  local item={}
	  item.skill_name="神照经"
	  item.skill_id="force"
	  ss_lian.count=50
	  ss_lian.vip=false
	  ss_lian:addskill(item)

	  ss_lian.AfterFinish=function() xiulian_Status_Check(CallBack) end
	  ss_lian.start_failure=function(error_id)
           print(error_id," lian_error_id")
		   if error_id==1 then
              h=hp.new()
			  h.checkover=function()
			    if h.pot<10 then
				   xiulian_Status_Check(CallBack)
				else
		      --ss_lian:Next()
			     local b=busy.new()
				 b.Next=function()
			       local f=function()
			         print("重新开始练神照经")
					 local f2=function()  ss_lian:go() end
				      switch(f2)
				   end
			        local xiulian=world.GetVariable("xiulian")
			        if xiulian=="xiulian_jingli" then
			          process.neigong2()
			        elseif xiulian=="xiulian_neili" then
			          process.neigong3()
					elseif xiulian=="xiulian_dubook" then
			           local cmd=world.GetVariable("dubook_cmd") or "du book"
			         	process.readbook(cmd)
		        	elseif xiulian=="xiulian_skills" then

			           process.lian()
			        end
				   f_wait(f,30)
				 end
				 b:check()

			   end
			 end
			 h:check()
			end
			if error_id==402 or error_id==201 then  --内力不足
			   ss_lian:finish()

			end
			if error_id==403 then  --内力转换精血 继续学习
			  ss_lian:start()
			end
			if error_id==401 then
			   ss_lian:refresh()
			end
			--[[if error_id==1 then  --经验限制 或 超越师傅 或武器不对
			  local is_ok=ss_lian:Next()
			  if ss_lian.weapon~="" then
				world.Send("unwield "..ss_lian.weapon)
			  end
				if is_ok==true then  --还有候选项
				  ss_lian:start()
				else
				  ss_lian:finish()
				end
			end]]
			if error_id==202 then
			   world.Send("wield jian")
			   ss_lian.weapon="jian"
			   ss_lian:start()
			end
	  end
	  ss_lian.rest=function()
	     local w
		  w=walk.new()
		  w.walkover=function()
			 local ss_rest=rest.new()
			 ss_rest.failure=function(id)
			    local f=function() w:go(308) end
				f_wait(f,10)
 			 end
			 ss_rest.wake=function(flag)
				ss_lian:go()
			 end
			 ss_rest:sleep()
		  end
		  w:go(308)
	  end
	  ss_lian:go()  --ss go learn
end

function Shenzhaojing_learn(CallBack)
     package.loaded["learn"]=nil
     require "learn"

     print("开始学习神照经")
	 local szj_learn={}
	  szj_learn=learn.new()
	  szj_learn.vip=false
	  szj_learn.interval=0.2
	  szj_learn.timeout=0.4
	  szj_learn.AfterFinish=function()
		 xiulian_Status_Check(CallBack)
	  end
	  szj_learn.start_failure=function(error_id)
		   if error_id==2 then  --没有找到师傅
			  local f=function() szj_learn:go_ding() end
			  f_wait(f,5)
		   end
		   if error_id==102 then  --潜能用完
		      --process.xc()
			  --CallBack()
			  world.Send("unwield jian")
			  szj_learn:finish()
		   end
			if error_id==401 then
			   szj_learn:regenerate()
			end
			if error_id==402 then  --内力不足
			  szj_learn:rest()
			end
			if error_id==403 then  --内力转换精血 继续学习
			  szj_learn:shenzhaojing()
			end
	  end
	  szj_learn.start_success=function()
	      szj_learn:shenzhaojing()
	  end
	  szj_learn.go=function()
	      szj_learn:go_ding()
	  end
	  szj_learn.rest=function()
	     local w
		  w=walk.new()
		  w.walkover=function()
			 local szj_rest=rest.new()
			 szj_rest.failure=function(id)
			    local f=function() w:go(308) end
				f_wait(f,10)
 			 end
			 szj_rest.wake=function(flag)
			     if flag==0 then
			          print("睡觉太频繁了!")
			          local ch=hp.new()
			          ch.checkover=function()
			             if ch.pot<20 then
				           --process.xc()
						   -- print("xc")
						   --CallBack()
							MR_Status_Check(CallBack)
						 else
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  睡觉太频繁 打坐 start
							  local f
							  f=function()
							    local b
								b=busy.new()
								b.Next=function()
								  szj_learn:go()
								end
								b:check()
							  end
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
								if id==202 then --safe room 没有办法打坐
								   local b1
								   b1=busy.new()
								   b1.Next=function()
								     w1:go(306)
								   end
								   b1:check()
	                            else
		                           local f1
		                           f1=function()
								     world.Send("yun regenerate")
								     x:dazuo()
								   end
	                               f_wait(f1,10)
								end
                              end
							  x.success=function(h)
							     szj_learn:go()
							  end
	                          x:dazuo()
	                          f_wait(f,30)
							  ---  睡觉太频繁 打坐 end
			                end
                            w1:go(306)
						 end
			          end
					ch:check()
				  else
					szj_learn:go()
				  end
			 end
			 szj_rest:sleep()
		  end
		  w:go(308)
	  end
	  szj_learn:go()  --ss go learn
end

function taojiao(CallBack)
  package.loaded["learn"]=nil
  require "learn"

  local sleeproomno=world.GetVariable("sleeproomno")
  sleeproomno= tonumber(Trim(sleeproomno))
  local masterid=world.GetVariable("masterid")
  local master_place=world.GetVariable("master_place")
  local pot=world.GetVariable("pot")
  local skills=world.GetVariable("skills")
  print("开始学习")
	 local newbie_learn={}
	  newbie_learn=learn.new()
	  sj.World_Init=function()
          newbie_learn:go()
      end
	  local items=Split(skills,"|")
	  for _,i in ipairs(items) do
	     print(i)
		 if i~=nil and i~="" then
	       newbie_learn:addskill(i)
		 end
	  end
	 --[[ newbie_learn:addskill("shenyuan-gong")
	  newbie_learn:addskill("force")
	  newbie_learn:addskill("yanling-shenfa")
	  newbie_learn:addskill("murong-jianfa")
	  newbie_learn:addskill("parry")
	  newbie_learn:addskill("canhe-zhi")
	  newbie_learn:addskill("sword")
      newbie_learn:addskill("finger")
      newbie_learn:addskill("dodge")
	  newbie_learn:addskill("strike")
	  newbie_learn:addskill("xingyi-zhang")
	  newbie_learn:addskill("murong-daofa")
	  newbie_learn:addskill("blade")]]

	  --newbie_learn.masterid="wang"
	   newbie_learn.pot=pot --每次学的次数
	   newbie_learn.master_place=tonumber(Trim(master_place)) --师傅房间号
       newbie_learn.masterid= masterid  --师傅id
	   newbie_learn.weapon=""
	   newbie_learn.AfterFinish=function()
		--宝物
	     xiulian_Status_Check(CallBack)
	   end

	  --print(real_vip," 标志位")
	   newbie_learn.vip=run_vip
	   newbie_learn.start=function()
	     --start_trigger()
		  local cmd="taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi;taojiao qiankun-danuoyi"
		  newbie_learn:Execute(cmd)
	      --learn.this=self
	   end
       newbie_learn.start_success=function()
	      newbie_learn:regenerate()
	      --newbie_learn:start()
	   end
	   newbie_learn.wuxing=function()
	      local wx=world.GetVariable("wuxing") or ""
		   if wx~="" and wx~=nil then
		    --print("执行")
		    world.Execute(wx)
		  end
	   end
	   newbie_learn.start_failure=function(error_id)
			print(error_id," learn_error_id")
		   if error_id==2 then  --没有找到师傅
			  local f=function() newbie_learn:go() end
			  f_wait(f,5)
		   end
		   if error_id==102 then  --潜能用完
		      --process.xc()
			  --CallBack()
			  --world.Send("ask huang about 教诲")
		      --[[local bb=busy.new()
		      bb.interval=0.5
		      bb.Next=function()]]
	             newbie_learn:finish()
			  --end
              --bb:check()
		   end
		   if error_id==1 or error_id==201  then  --经验限制 或 超越师傅 或武器不对
			  local is_ok=newbie_learn:Next()
				if is_ok==true then  --还有候选项
				  newbie_learn:start()
				else
				  if newbie_learn.limit~=nil then
				    print("技能上限 ",newbie_learn.limit) --经验值上限
				    world.Send("set skilllimit "..mr_learn.limit)
					world.Send("unset skilllimit")
				  end
				  newbie_learn:finish()
				end
			end
			if error_id==301 then
			    local is_ok=newbie_learn:Next()
				if is_ok==true then  --还有候选项
				  newbie_learn:start()
				else
				  newbie_learn:finish()
				end
			end
			if error_id==202 then
			  print("武器不对:",newbie_learn.weapon)

			     local i=newbie_learn.skillsIndex
				 local skillname= newbie_learn.skills[i]
				 print(skillname," 根据技能名称判断使用的武器!!")
				 if string.find(skillname,"jian") or string.find(skillname,"xiao") then
				   world.Send("wield sword")
				   world.Send("wield jian")
				   world.Send("wield xiao")
				   newbie_learn.weapon="sword"
				 elseif string.find(skillname,"dao") then
			       world.Send("wield blade")
				   world.Send("wield dao")
				   newbie_learn.weapon="blade"
				 elseif string.find(skillname,"zhang") then
				   world.Send("wield staff")
				   newbie_learn.weapon="staff"
				 elseif string.find(skillname,"yinsuo") or string.find(skillname,"bian") then
				   world.Send("wield bian")
				   world.Send("wield whip")
				   newbie_learn.weapon="bian"
				 elseif string.find(skillname,"lun") then
				   world.Send("wield hammer")
				   world.Send("wield falun")
				   newbie_learn.weapon="falun"
				 elseif string.find(skillname,"sheying") then
				    world.Send("wield biao")
				    newbie_learn.weapon="biao"
				 elseif string.find(skillname,"bifa") or string.find(l,"lingfa")  then
				    world.Send("wield ling")
				     world.Send("wield bishou")
				    newbie_learn.weapon="bishou"

				 elseif string.find(skillname,"goufa") then
				    world.Send("wield gou")
					newbie_learn.weapon="gou"

				 end

			   newbie_learn:start()
			end

			if error_id==401 then
			   newbie_learn:regenerate()
			end
			if error_id==402 then  --内力不足
			  shutdown()
			  local exps=world.GetVariable("exps")
			  if tonumber(exps)>800000 then
			     newbie_learn:xiulian()
			  else
                 newbie_learn:rest()
			  end
			end
			if error_id==403 then  --内力转换精血 继续学习
			  newbie_learn:start()
			end
	  end
	 newbie_learn.rest=function()
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
				newbie_learn:go()
			 end
			 mr_rest:sleep()
		  end
		 -- w:go(2186)
		-- w:go(2785)
		  w:go(sleeproomno)
	  end
	  newbie_learn:go()  --ss go learn
end

function zhongzhi()
   package.loaded["ckns2"]=nil
  require "ckns2"
  nongsang:getNongsang()
end

function digging()
   package.loaded["ckns2"]=nil
  require "ckns2"
  nongsang:buy_qiao()
end

function Go_learn(CallBack)
     package.loaded["learn"]=nil
  require "learn"

  local sleeproomno=world.GetVariable("sleeproomno")
  sleeproomno= tonumber(Trim(sleeproomno))
  local masterid=world.GetVariable("masterid")
  local mastername=world.GetVariable("mastername")
  local master_place=world.GetVariable("master_place") or ""
  local pot=world.GetVariable("pot")
  local skills=world.GetVariable("skills")
  print("开始学习")
	 local _learn={}
	  _learn=learn.new()
	 -- sj.World_Init=function()
     --     _learn:go()
     -- end
	  local items=Split(skills,"|")
	   local skill_weapon={} --学习自定义武器
	  for _,i in ipairs(items) do
	     print(i)
		 local skill=Split(i,"&")
		 if skill[1]~=nil and skill[1]~="" then
	       _learn:addskill(skill[1])

		    if skill[2]~=nil and skill[2]~="" then
		       skill_weapon[skill[1]]=skill[2]
		    end
		 end
	  end
	   _learn.pot=pot --每次学的次数
	   if master_place=="" then
	     local master_room=WhereIsNpc(mastername)
		  local r=0
		  if table.getn(master_room)>0 then
		     r=master_room[1]
		  end
		  _learn.master_place=r --师傅房间号
	   else
		   _learn.master_place=tonumber(Trim(master_place)) --师傅房间号
	   end

       _learn.masterid= masterid  --师傅id
	   _learn.weapon=""
	   _learn.AfterFinish=function()

	    --保存pot
		local w=walk.new()
		w.walkover=function()
		  local h=hp.new()
          h.checkover=function()
			world.Send("qn_cun "..h.pot)
		    xiulian_Status_Check(CallBack)
          end
          h:check()

		end
		w:go(4067)
		--宝物
	   end

	  --print(real_vip," 标志位")
	  _learn.vip=run_vip
       _learn.start_success=function()
	      world.Send("yun regenerate")
	      _learn:start()
	   end
	   _learn.wuxing=function()

	      local wx=Trim(world.GetVariable("wuxing")) or ""
		   if wx~="" and wx~=nil then
		    --print("执行")
		    world.Execute(wx)
		  end
	   end
	   _learn.start_failure=function(error_id)
			print(error_id," learn_error_id")
		   if error_id==2 then  --没有找到师傅
			  local f=function() _learn:go() end
			  f_wait(f,5)
		   end
		   if error_id==102 then  --潜能用完
		      --process.xc()
			  --CallBack()
			  --world.Send("ask huang about 教诲")
		      --[[local bb=busy.new()
		      bb.interval=0.5
		      bb.Next=function()]]
	             _learn:finish()
			  --end
              --bb:check()
		   end
		   if error_id==1 or error_id==201  then  --经验限制 或 超越师傅 或武器不对
			  local is_ok=_learn:Next()
				if is_ok==true then  --还有候选项
				  _learn:start()
				else
				  print("limit:",_learn.limit)
				  if _learn.limit~=nil then
				    print("技能上限 ",_learn.limit) --经验值上限
				    world.Send("set skilllimit ".._learn.limit)
					--world.Send("unset skilllimit")
				  end
				  _learn:finish()
				end
			end
			if error_id==301 then
			    local is_ok=_learn:Next()
				if is_ok==true then  --还有候选项
				  _learn:start()
				else
				  _learn:finish()
				end
			end
			if error_id==202 then
			  print("武器不对:",_learn.weapon)

			     local i=_learn.skillsIndex
				 local skillname= _learn.skills[i]
				 print(skillname," 根据技能名称判断使用的武器!!")
				 if skill_weapon[skillname]~=nil then  --优先使用用户自定义的武器

				    local weapon=skill_weapon[skillname]
					print("用户自定义武器:",weapon)
					world.Send("wield "..weapon)
					_learn.weapon=weapon
				 elseif string.find(skillname,"xiao") or string.find(skillname,"jian") then
				   world.Send("wield xiao")
				   world.Send("wield sword")
				   world.Send("wield jian")
				   _learn.weapon="sword"
				 elseif string.find(skillname,"dao") then
			       world.Send("wield blade")
				   world.Send("wield dao")
				   _learn.weapon="blade"
				 elseif string.find(skillname,"zhang") then
				   world.Send("wield staff")
				   _learn.weapon="staff"
				 elseif string.find(skillname,"yinsuo") or string.find(skillname,"bian") then
				   world.Send("wield bian")
				   world.Send("wield whip")
				   _learn.weapon="bian"
				 elseif string.find(skillname,"lun") then
				   world.Send("wield hammer")
				   world.Send("wield falun")
				   _learn.weapon="falun"
				 elseif string.find(skillname,"sheying") then
				    world.Send("wield biao")
				    _learn.weapon="biao"
				 elseif string.find(skillname,"bifa") or string.find(skillname,"lingfa") then
				    world.Send("wield ling")
				    world.Send("wield bishou")
					_learn.weapon="bishou"
				 elseif string.find(skillname,"bang") or string.find("chu") then
				     world.Send("wield stick")
					 world.Send("wield club")
					 _learn.weapon="stick"
				 elseif string.find(skillname,"goufa") then
				    world.Send("wield gou")
					_learn.weapon="gou"
				 elseif string.find(skillname,"huayu") then
				     world.Send("wield coin")
					_learn.weapon="coin"
				 elseif string.find(skillname,"lingfa") then
				    world.Send("wield bishou")
					world.Send("wield ling")
					_learn.weapon="ling"
				 elseif string.find(skillname,"gun") then
				    world.Send("wield gun")
					world.Send("wield club")
					_learn.weapon="gun"
				 end

			   _learn:start()
			end

			if error_id==401 then
			   _learn:regenerate()
			end
			if error_id==402 then  --内力不足
			  _learn:rest()
			end
			if error_id==403 then  --内力转换精血 继续学习
			  _learn:start()
			end
	  end
	 _learn.rest=function()
	      local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  al.break_in_failure=function()
		    local f=function()
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
				_learn:go()
			  end
			  mr_rest:sleep()
			 end
			 f_wait(f,3)
		  end
		  w.user_alias=al
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
				_learn:go()
			 end
			 mr_rest:sleep()
		  end
		  w:go(sleeproomno)
	  end
	  local lw=lingwu:new()
	  lw.exps=tonumber(world.GetVariable("exps")) or 0
      lw.get_skills_end=function()
	    _learn.limit=lw.max_level
		local st=status_win.new()
        st:init(nil,lw,nil)
	    st:skill_draw_win()
      end
      lw:get_exps()
	  --_learn:go()  --ss go learn
	  _learn:catch_limit()
end

function qu_gold(f,gold,bank,CallBack)
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
	    if gold==nil then
          world.Send("qu 50 gold")
		else
		  world.Send("qu "..gold.." gold")
		end
		local l,w=wait.regexp("^(> |)你从银号里取出.*锭黄金。$|^(> |)你没有存那么多的钱。$",1.5)
		print("金子")
		if l==nil then
		--duanzao_learn(CallBack)
		   qu_gold(f,gold,bank)
		   return
		end
		if string.find(l,"你没有存那么多的钱") then
		   print("人生最大的不幸，no gold no woman!")
		   local bei_up=world.GetVariable("bei_up")
		   world.SetVariable("up",bei_up)
		   level_up(CallBack)
		   return
		end
		if string.find(l,"你从银号里") then
		   --回调
		   print("回调")
		   f()
		   return
		end
		wait.time(5)
	  end)
   end
   if bank==nil then
     bank=410
   end
   w:go(bank)
end

local function zc()
   package.loaded["hqg"]=nil
   require "hqg"
   local f=check_job(Job_Next("zc"))
  local _hqg=hqg.new()
  local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _hqg.neili_upper=tonumber(neili_upper)
	  -- print("倍率: ",_xs.neili_upper)
   end
  _hqg.fail=function(id)
     print(id)
	 if id==102 then
	    local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			    print("等待sec:",sec)
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f=function()
			   shutdown()
	           switch(process.zc)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    process.zc()
		 end
	   end
	    cd:start()
   end
  end
    _hqg.jobDone=function()
	 print("hqg 结束")
	  local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			   level_up(f)
		 else
		    --继续job
            print("继续")
			f()
		 end
	  end
	  h:check()
   end
 --end
  _hqg:Status_Check()
end

local function az()
  package.loaded["aozhou"]=nil
  require "aozhou"
  local f=check_job(Job_Next("az"))
  local _aozhou={}
  _aozhou=aozhou.new()
  _aozhou.jobDone=function()
       local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			   level_up(f)
		 else
		    --继续job
            print("继续")
			f()
		 end
	  end
	  h:check()
  end
  _aozhou:Status_Check()
end

local function jh()
  package.loaded["jiaohua"]=nil
  require "jiaohua"
  local f=check_job(Job_Next("jh"))
  local _jh={}
  _jh=jiaohua.new()
  _jh.fail=function(id)
      if id==102 then
	   local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			    print("等待sec:",sec)
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f=function()
	           switch(process.jh)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
		  	  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    process.jh()
		 end
	   end
	    cd:start()
	 end
  end
  _jh.jobDone=function()
       local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			   level_up(f)
		 else
		    --继续job
            print("继续")
			f()
		 end
	  end
	  h:check()
  end
  _jh:ask_job()
end

local function check()
   print("自动变量设置")
   --world.DoAfterSpecial (5,"up:auto_check",10)
   wizard_end=function()
    run_vip=world.GetVariable("VIP")
    if run_vip=="贵宾玩家" or run_vip=="荣誉终身贵宾" then
     run_vip=true
    else
     run_vip=false
    end
	reload_data()
   end
   auto_variable()
end

local function init()
 -- print("SJ 通用版机器人")
  --world.SetVariable("shaolin_entry","true")
  --world.SetVariable("tianshan_entry","true")
  --world.SetVariable("wudanghoushan_entry","false")
  --world.SetVariable("VIP",0)
  --world.SetVariable("skills","")
  --world.SetVariable("masterid","")
  --world.SetVariable("master_place",0)
  --world.SetVariable("pot",1)
  --world.SetVariable("sleeproomno",0)
--player_id
  --player_id 门派 exps vip 进出开关 变量存在检查
  --print("进入少林:"..world.GetVariable("shaolin_entry")," 可以手动修改变量shaolin_entry值") --150k
  --print("进入天山:"..world.GetVariable("tianshan_entry")," 可以手动修改变量tianshan_entry值") --200k
  --print("进入武当后山:"..world.GetVariable("wudanghoushan_entry")," 可以手动修改变量wudanghoushan_entry值") --1m +80hand
  --print("进入莆田少林:"..world.GetVariable("putian_entry")," 可以手动修改变量putian_entry值") --150k
  --print("进入绝情谷:"..world.GetVariable("jueqinggu_entry")) --200k
  --print("进入黑木崖:".. world.GetVariable("heimuya_entry")) --1.5m


  world.AddAlias("repeat", "^#(\\d.)(.*)$", "local i\nlocal num=tonumber(%1)\nfor i=1,num do \nworld.Execute('%2')\nend", alias_flag.Enabled + alias_flag.RegularExpression , "")
  world.SetAliasOption ("repeat", "send_to", 12) --向脚本发送
  --print("vip:",run_vip)

  local sleeproomno=world.GetVariable("sleeproomno")
  local masterid=world.GetVariable("masterid")
  local master_place=world.GetVariable("master_place")
  local pot=world.GetVariable("pot")
  local skills=world.GetVariable("skills")
  print("-----------------------------------------------")
  print("常用指令")
  world.AddAlias("shit", "shit", "shutdown()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("shit", "send_to", 12) --向脚本发送
  print("1. shit:关闭所有触发器，计时器！")
  world.AddAlias("go", "^g(\\\d*)$", "local w=walk.new();w:go(%1)", alias_flag.Enabled + alias_flag.RegularExpression + alias_flag.Replace, "")
  world.SetAliasOption ("go", "send_to", 12) --向脚本发送
  print("2. g房间号：走到指定的房间号例g50")
  world.AddAlias("sz", "^sz(.*)$", "Where('%1')", alias_flag.Enabled + alias_flag.RegularExpression , "")
  world.SetAliasOption ("sz", "send_to", 12) --向脚本发送
  print("3. sz(区域名称)房间名称 返回房间名称对应的房间号，可以加区域名称缩小范围,如sz扬州城当铺")
  world.AddAlias("zc", "zc", "Weapon_Check(process.zc)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("zc", "send_to", 12) --向脚本发送
  print("4. zc 做菜启动命令,任意地点启动！确保bank 有足够存款！")
  --world.AddAlias("check", "ch", "process.check()", alias_flag.Enabled + alias_flag.Replace, "")
  --world.SetAliasOption ("check", "send_to", 12) --向脚本发送
  print("5. ch 自动变量，自动获得玩家信息！！")
  world.AddAlias("ch", "ch", "process.check()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("ch", "send_to", 12) --向脚本发送
  print("6. cp  半自动做菜：中途开始,看菜谱配方完成做菜_不带学习!")
  world.AddAlias("cp", "cp", "hqg:look_caipu()", alias_flag.Enabled+ alias_flag.Replace , "")
  world.SetAliasOption ("cp", "send_to", 12) --向脚本发送
  print("7. wizard 启动设置精灵")
  world.AddAlias("wizard", "wizard", "wizard:start()", alias_flag.Enabled + alias_flag.Replace , "")
  world.SetAliasOption ("wizard", "send_to", 12) --向脚本发送
  print("8. smi  设置师傅ID")
  world.AddAlias("smi", "^smi(.*)$", "process.masterid('%1')", alias_flag.Enabled + alias_flag.RegularExpression+ alias_flag.Replace, "")
  world.SetAliasOption ("smi", "send_to", 12) --向脚本发送
  print("9. smp  设置师傅房间号")
  world.AddAlias("smp", "^smp(\\\d*)$", "process.masterplace(%1)", alias_flag.Enabled + alias_flag.RegularExpression+ alias_flag.Replace, "")
  world.SetAliasOption ("smp", "send_to", 12) --向脚本发送
  print("10. ssp  设置休息房间号")
  world.SetAliasOption ("vip", "send_to", 12) --向脚本发送
  print("11. pots pots30 一次学习30潜能 ")
  world.AddAlias("pots", "^pots(\\\d*)$", "process.pots(%1)", alias_flag.Enabled + alias_flag.RegularExpression+ alias_flag.Replace, "")
  world.SetAliasOption ("pots", "send_to", 12) --向脚本发送
  print("12. xs 启动雪山job ")
  world.AddAlias("xs", "xs", "Weapon_Check(process.xs)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("xs", "send_to", 12) --向脚本发送
  print("13. cl 启动长乐帮job ")
  world.AddAlias("cl", "cl", "Weapon_Check(process.cl)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("cl", "send_to", 12) --向脚本发送
  print("14. gb 启动丐帮job ")
  world.AddAlias("gb", "gb", "Weapon_Check(process.gb)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("gb", "send_to", 12) --向脚本发送
  print("15. sx 启动送信job ")
  world.AddAlias("sx", "sx", "Weapon_Check(process.sx)", alias_flag.Enabled  + alias_flag.Replace, "")
  world.SetAliasOption ("sx", "send_to", 12) --向脚本发送
  print("16. hs 启动华山job ")
  world.AddAlias("hs", "hs", "Weapon_Check(process.hs)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("hs", "send_to", 12) --向脚本发送
  print("17. hs2 启动华山job2 ")
  world.AddAlias("hs2", "hs2", "Weapon_Check(process.hs2)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("hs2", "send_to", 12) --向脚本发送
  print("18. wudang 启动武当 ")
  world.AddAlias("wudang", "wudang", "Weapon_Check(process.wd)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("wudang", "send_to", 12) --向脚本发送
  print("19. tdh 启动天地会")
  world.AddAlias("tdh", "tdh", "Weapon_Check(process.tdh)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("tdh", "send_to", 12) --向脚本发送
  print("20. hlp 显示帮助日志 ")
  world.AddAlias("hlp", "hlp", "process.update_log()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("hlp", "send_to", 12) --向脚本发送
  print("21. hx 启动呼吸")
  world.AddAlias("hx", "hx", "process.huxi()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("hx", "send_to", 12) --向脚本发送
  print("22. zs 启动抓蛇")
  world.AddAlias("zs", "zs", "Weapon_Check(process.zs)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("zs", "send_to", 12) --向脚本发送
  print("23. ss 启动嵩山左冷禅")
  world.AddAlias("ss", "ss", "Weapon_Check(process.ss)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("ss", "send_to", 12) --向脚本发送
  print("24. tm 启动少林教武僧")
  world.AddAlias("tm", "tm", "Weapon_Check(process.tm)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("tm", "send_to", 12) --向脚本发送
  print("25. tx 启动mr偷学")
  world.AddAlias("tx", "tx", "Weapon_Check(process.tx)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("tx", "send_to", 12) --向脚本发送
  print("26. xc 启动巡城")
  world.AddAlias("xc", "xc", "process.xc()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("xc", "send_to", 12) --向脚本发送
  print("27. ck 启动采矿")
  world.AddAlias("ck", "ck", "process.ck()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("ck", "send_to", 12) --向脚本发送
  print("28. sm 启动桃花岛守墓")
  world.AddAlias("sm", "sm", "process.sm()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("sm", "send_to", 12) --向脚本发送
  print("29. sld 启动神龙岛索命")
  world.AddAlias("sld", "sld", "Weapon_Check(process.suoming)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("sld", "send_to", 12) --向脚本发送
  print("30. tm 启动少林教和尚")
  world.AddAlias("tm", "tm", "Weapon_Check(process.tm)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("tm", "send_to", 12) --向脚本发送
  print("31. az 启动少林熬粥")
  world.AddAlias("az", "az", "process.az()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("az", "send_to", 12) --向脚本发送
  print("32. xl 启动明教巡逻")
  world.AddAlias("xl", "xl", "Weapon_Check(process.xl)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("xl", "send_to", 12) --向脚本发送
  print("33. jy 启动少林巡逻")
  world.AddAlias("jy", "jy", "Weapon_Check(process.jy)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("jy", "send_to", 12) --向脚本发送
  print("34. map 开启/关闭 小地图")
  world.AddAlias("mapper_show", "map", "if mapper.hidden==true then mapper.show() else mapper.hide() end", alias_flag.Enabled+ alias_flag.Replace, "")
  world.SetAliasOption ("mapper_show", "send_to", 12) --向脚本发送
  local mini_map=world.GetVariable("mini_map") or ""
  if mini_map=="false" then
     mapper.hide()
  end
  print("34. bj 加载背景图片")
  world.AddAlias("bj", "bj", "BGpics()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("bj", "send_to", 12) --向脚本发送
  print("35. bj_d 删除背景图片")
  world.AddAlias("bj_d", "bj_d", "BGpics_del()", alias_flag.Enabled+ alias_flag.Replace, "")
  world.SetAliasOption ("bj_d", "send_to", 12) --向脚本发送
  print("36. mh 地图显示当前位置")
  world.AddAlias("mh", "mh", "Map_Here()", alias_flag.Enabled+ alias_flag.Replace, "")
  world.SetAliasOption ("mh", "send_to", 12) --向脚本发送

  print("37. ts 启动泰山")
  world.AddAlias("ts","ts", "Weapon_Check(process.ts)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("ts","send_to", 12) --向脚本发送
  print("38. xxbug 启动星宿抓虫子")
  world.AddAlias("xxbug","xxbug", "Weapon_Check(process.xxbug)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("xxbug","send_to", 12) --向脚本发送

  print("39. pl 查看内存表记录数")
  world.AddAlias("pl", "pl", "Pload()", alias_flag.Enabled, "")
  world.SetAliasOption ("pl", "send_to", 12) --向脚本发送

  print("40. wg 启动武馆")
  world.AddAlias("wg","wg", "process.wg()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("wg","send_to", 12) --向脚本发送

  print("41. ns 启动农桑种田")
  world.AddAlias("ns","ns", "zhongzhi()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("ns","send_to", 12) --向脚本发送

  print("42. qqll 启动七巧玲珑玉")
  world.AddAlias("qqll","qqll", "process.qqllyu()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("qqll","send_to", 12) --向脚本发送

  print("43. wk 启动挖矿")
  world.AddAlias("wk","wk", "digging()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("wk","send_to", 12) --向脚本发送

  print("44. xz 寻找npc所在房间号")
  world.AddAlias("xz", "^xz(.*)$", "tprint(WhereIsNpc('%1'))", alias_flag.Enabled + alias_flag.RegularExpression + alias_flag.Replace , "")
  world.SetAliasOption ("xz", "send_to", 12) --向脚本发送

  print("45. gt名字:前往 NPC所在房间 名字可以写 拼音或中文")
  world.AddAlias("gt", "^gt(.*)$", "local w=walk.new();w:goto('%1')", alias_flag.Enabled + alias_flag.RegularExpression+ alias_flag.Replace, "")
  world.SetAliasOption ("gt", "send_to", 12) --向脚本发送

  print("46. fish 钓鱼")
  world.AddAlias("fish", "fish", "fish:go()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("fish", "send_to", 12) --向脚本发送

  print("47. q_time 检查自动解谜时间")
  world.AddAlias("q_time", "q_time", "tprint(quest:group_time())", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("q_time", "send_to", 12) --向脚本发送

  print("48. fullskill 取pot full skill")
  world.AddAlias("fullskill", "fullskill", "process.fullskills()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("fullskill", "send_to", 12) --向脚本发送

  print("49. webconfig 云功能,用户配置上传服务器")
  world.AddAlias("webconfig", "webconfig", "wizard:update_webconfig()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("webconfig", "send_to", 12) --向脚本发送

  print("50. hb 启动护镖任务，必须两个人护镖")
  world.AddAlias("hb","hb", "Weapon_Check(process.hb)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("hb","send_to", 12) --向脚本发送

  print("51. smy 启动颂摩崖任务")
  world.AddAlias("smy","smy", "Weapon_Check(process.smy)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("smy","send_to", 12) --向脚本发送

  print("52. xxpt 启动星宿叛徒任务")
  world.AddAlias("xxpt","xxpt", "Weapon_Check(process.xxpt)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("xxpt","send_to", 12) --向脚本发送

  print("53. ryfx 启动日月复兴任务")
  world.AddAlias("ryfx","ryfx", "Weapon_Check(process.ryfx)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("ryfx","send_to", 12) --向脚本发送

  print("54. ks 启动武当守鼎")
  world.AddAlias("ks","ks", "Weapon_Check(process.ks)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("ks","send_to", 12) --向脚本发送

    print("55. kc 启动华山砍柴")
  world.AddAlias("kc","kc", "Weapon_Check(process.kc)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("kc","send_to", 12) --向脚本发送

      print("56. cisha 启动报效国家")
  world.AddAlias("cisha","cisha", "Weapon_Check(process.cisha)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("cisha","send_to", 12) --向脚本发送

    print("57. caiyao 启动采药")
  world.AddAlias("caiyao","caiyao", "Weapon_Check(process.caiyao)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("caiyao","send_to", 12) --向脚本发送
  wizard:draw_win()
    print("58. tz 启动铁掌嫡传")
  world.AddAlias("tz","tz", "Weapon_Check(process.tz)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("tz","send_to", 12) --向脚本发送
      print("59. gmsw 启动古墓守卫")
  world.AddAlias("gmsw","gmsw", "Weapon_Check(process.gmsw)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("gmsw","send_to", 12) --向脚本发送

        print("60. cj 启动全真锄奸")
  world.AddAlias("cj","cj", "Weapon_Check(process.cj)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("cj","send_to", 12) --向脚本发送

   print("61. kjmg 启动全真抗击蒙古")
  world.AddAlias("kjmg","kjmg", "Weapon_Check(process.kjmg)", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("kjmg","send_to", 12) --向脚本发送


     print("62. jh")
  world.AddAlias("jh","jh", "process.jh()", alias_flag.Enabled + alias_flag.Replace, "")
  world.SetAliasOption ("jh","send_to", 12) --向脚本发送
  wizard:draw_win()
  --register()

  local _vip=world.GetVariable("VIP")
   if _vip~=nil then
     if _vip=="贵宾玩家" or _vip=="荣誉终身贵宾" then
       run_vip=true
	 else
       run_vip=false
     end
   end
end

local function masterid(id)
   print("masterid",id)
   world.SetVariable("masterid",id)
end

local function masterplace(id)
   print("master_place",id)
   world.SetVariable("master_place",id)
end

local function set_skills(id)
  local skills=world.GetVariable("skills")
  if skills~="" then
     skills=skills .."|"..id
	 print("技能:",skills)
	 world.SetVariable("skills",skills)
  else
     skills=id
	 print("技能:",skills)
	 world.SetVariable("skills",skills)
  end
end

local function pots(id)
  print("pot"..id)
  world.SetVariable("pot",id)
end

function Go_lingwu(CallBack,is_reset)
   package.loaded["lingwu"]=nil
   require "lingwu"
     local lw=lingwu.new()
	 local times=world.GetVariable("lingwu_times") or 5
	 lw.times=times
	 sj.World_Init=function()
         lw:get_skills()
      end
	  lw.vip=run_vip
     lw.exps=tonumber(world.GetVariable("exps")) or 0
	 lw.wuxing=function()
	      local wx=Trim(world.GetVariable("wuxing")) or ""
		   if wx~="" and wx~=nil then
		    --print("执行")
		    world.Execute(wx)
		  end
	 end
     local lian_skills=world.GetVariable("lian_skills")
	  local _skills=Split(lian_skills,"|")
	  for _,i in ipairs(_skills) do
	    local item={}
		local _item=Split(i,"&")
	    item.special_skill=_item[1]
	    item.base_skill=_item[2]
		item.weapon=_item[3]
		--print(_item[1],_item[2])
	    lw:addskill(item)
	  end
	  local lingwu_finish=world.GetVariable("lingwu_finish") or ""
      lw.AfterFinish=function()
	     if lingwu_finish~="" then
		   world.Execute(lingwu_finish)
		 end
		 xiulian_Status_Check(CallBack)
	  end

	  lw:get_exps() --获得经验值列表
	  if is_reset==true then
	    lw:SetTime(180)
   	  end

end

local function zs()
   package.loaded["zhuashe"]=nil
   require "zhuashe"
   local fj=check_job(Job_Next("zs"))
   xp:check()
   local _zs=zhuashe.new()
   local select_pfm=world.GetVariable("zs_pfm")
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _zs.neili_upper=tonumber(neili_upper)
   end

   	_zs.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert") --json数据解析
	  for k,v in pairs(json) do
	     if k=="抓蛇" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
   _zs.fail=function(id)
     --print("id:",id)
	 if id==101 then
       local b
	   b=busy.new()
	   b.Next=function()
		fj()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f2=function()
	           switch(process.zs)
	        end
	        f_wait(f2,sec)
            local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
			--process.dzxy()
		 else
		    process.zs()
		 end
	   end
	   cd:start()
	 end
   end
    local cb=fight.new()
	local unarmed_pfm=world.GetVariable("unarmed_pfm")
	cb.unarmed_alias=unarmed_pfm
	local pfm=string.gsub(_pfm,"@id","snake")
	cb.combat_alias=pfm

    _zs.combat=function()
       print("抓蛇战斗模块!!")
      cb:before_kill()
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  _zs:flee()
	     end
      end
	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("战斗结束")
		  world.Send("unset wimpy")
		  shutdown()
		 local f=function() _zs:reward() end
		 _zs:poison(f)
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		 _zs:flee()
	  end
	  cb:start()
   end
    _zs.jobDone=function()
      print("gb 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  level_up(fj)
		 else
		    --继续job
            print("继续")
			assert (type (fj) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			fj()
		 end
	  end
	  h:check()
   end
   _zs:Status_Check()
end

local function cj()
   package.loaded["chujian"]=nil
   require "chujian"
   local f=check_job(Job_Next("cj"))
   xp:check()
   local _cj=chujian.new()
   local select_pfm=world.GetVariable("cj_pfm")
   if select_pfm==nil then
      utils.msgbox ("你的cj_pfm没有设置！", "Warning!", "ok", "!", 1)--> ok
      return
   end
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _cj.neili_upper=tonumber(neili_upper)
   end
   	_cj.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert") --json数据解析
	  for k,v in pairs(json) do
	     if k=="全真锄奸" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end


   _cj.fail=function(id)
     --print("id:",id)
	 if id==101 then
       local b
	   b=busy.new()
	   b.Next=function()
		f()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" or i[1]=="执行全真锄奸任务" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f2=function()
	           switch(process.cj)
	        end
			print("等待时间",sec,"实际",sec-30)
			if sec-30>0 then
	        f_wait(f2,sec-30)
            local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
			else
			   print("小于20s 不在打坐")
			   f_wait(f2,5)
			end
			--process.dzxy()
		 else
		    process.cj()
		 end
	   end
	   cd:start()
	 end
   end
    local cb
	_cj.auto_pfm=function()
	   local select_pfm=world.GetVariable("cj_pfm")
	  local _pfm=world.GetVariable(select_pfm)
	  world.Execute(_pfm)
   end
    _cj.combat=function()

       print("战斗模块")
	   cb=fight.new()
	   cb.target=""
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
       cb.combat_alias=pfm
	   cb:before_kill()
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  cb.run_flee=true
		  _cj:flee()
	     end
      end
	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("战斗结束")
		  world.Send("unset wimpy")
		 shutdown()
		 _cj:get_ling()
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		 _cj:flee()
	  end
	  cb:start()
   end
    _cj.badman_die=function()
	  print("战斗结束")
	   world.Send("unset wimpy")
	  shutdown()
	   if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
	  end
	  _cj:get_ling()
	end
    _cj.jobDone=function()
      print("cj 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			   level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end
   _cj:Status_Check()
end

local function gb()
   package.loaded["gaibang"]=nil
   require "gaibang"
   local f=check_job(Job_Next("gb"))
   xp:check()
   local _gb=gaibang.new()
   local select_pfm=world.GetVariable("gb_pfm")
   if select_pfm==nil then
      utils.msgbox ("你的gb_pfm没有设置！", "Warning!", "ok", "!", 1)--> ok
      return
   end
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _gb.neili_upper=tonumber(neili_upper)
   end
   	_gb.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert") --json数据解析
	  for k,v in pairs(json) do
	     if k=="丐帮" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
	local blacklist=world.GetVariable("gb_blacklist") or ""
	--if blacklist~=nil then
	  --print(blacklist," 黑名单")
	_gb.blacklist=blacklist
	--else
	  --_gb.blacklist=""
	--end
   _gb.fail=function(id)
     --print("id:",id)
	 if id==101 then
	   gb_busy=true
       local b
	   b=busy.new()
	   b.Next=function()
		f()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f2=function()
	           switch(process.gb)
	        end
			print("等待时间",sec,"实际",sec-30)
			if sec-30>0 then
	        f_wait(f2,sec-30)
            local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
			else
			   print("小于20s 不在打坐")
			   f_wait(f2,5)
			end
			--process.dzxy()
		 else
		    process.gb()
		 end
	   end
	   cd:start()
	 end
   end
    local cb
    _gb.combat=function()

       print("战斗模块")
	   cb=fight.new()
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_gb.id)
       cb.combat_alias=pfm
	   cb:before_kill()
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id",_gb.id)
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  cb.run_flee=true
		  _gb:flee()
	     end
      end
	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("战斗结束")
		  world.Send("unset wimpy")
		 shutdown()
		 _gb:qie_corpse()
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		 _gb:flee()
	  end
	  cb:start()
   end
    _gb.badman_die=function()
	  print("战斗结束")
	   world.Send("unset wimpy")
	  shutdown()
	   if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
	  end
	  _gb:qie_corpse()
	end
    _gb.jobDone=function()
      print("gb 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			   level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end
   _gb:Status_Check()
end

local function cl()
    package.loaded["changle"]=nil
    require "changle"
    local f=check_job(Job_Next("cl"))
	xp:check()
    local _cl={}
    _cl=changle.new()
	local select_pfm=world.GetVariable("cl_pfm")
    local _pfm=world.GetVariable(select_pfm)
	if select_pfm==nil then
      utils.msgbox ("你的cl_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
      return
    end
    world.SetVariable("pfm",_pfm)
	local blacklist=world.GetVariable("cl_blacklist")
	if blacklist~=nil then
	  _cl.blacklist=blacklist
	end
	local neili_upper=assert(world.GetVariable("neili_upper"))
    if neili_upper~=nil then
       _cl.neili_upper=tonumber(neili_upper)
    end
	_cl.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="长乐" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
    _cl.fail=function(id)
	--失败
	  if id==101 then
	   local b
	   b=busy.new()
	   b.interval=0.3
	   b.Next=function()
		 f()
	   end
	   b:check()
	  elseif id==102 then
		local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   print("等待sec:",sec)
			   break
			  end
			end

			 print(sec," 时间")
			 if sec==0 then
			    process.cl()
				return
			 end
			print("内功修炼")
			 world.Send("unset 积蓄")
	        local f2=function()
	           switch(process.cl)
	        end
			process.jobbusy=function()
			  f_wait(f2,5)
			end
			print("等待时间",sec,"实际",sec-40)
			if sec-40>0 then
	        f_wait(f2,sec-40)
            local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
			else
			   print("小于40s 不在打坐")
			   f_wait(f2,5)
			end

			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    process.cl()
		 end
	   end
	   cd:start()
	  end
   end
   local cb
	_cl.combat=function()
       print("战斗模块")
	   cb=fight.new()
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_cl.murder_id)
       cb.combat_alias=pfm
	    -- 新增变量
	   local cl_pfm_list=world.GetVariable("cl_pfm_list") or ""
	   if cl_pfm_list~=nil then
	     cb.pfm_list=world.GetVariable(cl_pfm_list)
	   end
	   --
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id",_cl.murder_id)
	   cb.unarmed_alias=unarmed_pfm
	   cb:before_kill()
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		   world.Send("unset wimpy")
		  _cl:flee()
	     end
      end
	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
		   print("战斗结束")
		 shutdown()
		  world.Send("unset wimpy")
		 --world.Send("unwield jian")
		 world.Send("jiali 1")
		 local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		  world.Send("get silver from corpse")
		  world.Send("get coin")
		   if cb.status=="大转" then
			   print("延时2秒")
			   world.Send("alias pfm")
			   local f=function()
			       --world.Send("get hammer")
				   --world.Send("get falun")
			       _cl:reward()
			    end
			    f_wait(f,2)
		   else
		      _cl:reward()
		   end
		 end
		if cb.status=="大转" then
		  b:jifa()
		else
		  b:check()
		end
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		  world.Send("unset wimpy")
		 _cl:flee()
	  end
	  	 -- jue:wuzhuan()
	  --jue:maze()
	  --jue:fuxue()
	  --jue:tianyin()
	    cb:start()
   end
	_cl.murder_die=function()
	     print("战斗结束")
		 shutdown()
		  world.Send("unset wimpy")
		 --world.Send("unwield jian")
		 world.Send("jiali 1")
		  local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		  world.Send("get silver from corpse")
		  world.Send("get coin")
          if cb.status=="大转" then
			   print("延时2秒")
			   world.Send("alias pfm")
			   local f=function()
			       --world.Send("get hammer")
				   --world.Send("get falun")
			       _cl:reward()
			    end
			    f_wait(f,2)
		   else
		      _cl:reward()
		   end
	     end
	     if cb.status=="大转" then
		  b:jifa()
		 else
		  b:check()
		 end
   end
    _cl.jobDone=function()
      print("cl 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()

		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  --Songshan_male_learn(process.sx)
			  --Songshan_lingwu(process.sx)
			   --Go_learn(process.sx)
			   --Go_learn(process.xs)
			   level_up(f)
			  --dali_learn_literate(process.xs)
		 else
		    --继续job
            --print("继续wd")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end

    _cl:Status_Check()
end

local function ck()
    local jb1,jb2=Job_Next("ck")
	xp:check()
    local _ck={}
    _ck=caikuang.new()

    _ck.fail=function(id)
	--失败
	  if id==101 then
	    local b
	    b=busy.new()
	    b.interval=0.3
	    b.Next=function()
		 local _job=check_job(jb2)
		 _job()
	     end
	    b:check()
	  end
   end
    _ck.to_play_id=world.GetVariable("ck_playId") or ""
    _ck.jobDone=function()
      print("采矿 结束")
	  world.Send("unwield tieqiao")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()

		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			   local _job=check_job(jb1)
			   level_up(_job)
		 else
			local _job=check_job(jb1)
			_job()
		 end
	  end
	  h:check()
   end
    _ck:Status_Check()
end

local function ss()
    package.loaded["songshan"]=nil
    require "songshan"
    local f=check_job(Job_Next("ss"))
	xp:check()
    local _ss={}
    _ss=songshan.new()
	_ss.g_blacklist=world.GetVariable("ss_blacklist") or ""

	local neili_upper=assert(world.GetVariable("neili_upper"))
    if neili_upper~=nil then
       _ss.neili_upper=tonumber(neili_upper)
    end

	_ss.shield=function()

	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if (k=="嵩山请人" and _ss.jobtype=="请人") then
		   --world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 elseif (k=="嵩山刺杀" and _ss.jobtype=="刺杀") then
			--world.Execute(v)
			world.SetVariable("shield",v)
		    break
		 elseif k=="嵩山" or k=="全部" then
			--world.Execute(v)
		    world.SetVariable("shield",v)
		    break
		 end
	  end
	   local shield=world.GetVariable("shield")
       world.Execute(shield)
    end
    _ss.fail=function(id)
	--失败
	  if id==101 then
	   local b
	   b=busy.new()
	   b.interval=0.3
	   b.Next=function()
		 f()
	   end
	   b:check()
	  elseif id==102 then
		local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   print("等待sec:",sec)
			   break
			  end
			end
			print("内功修炼")
			 world.Send("unset 积蓄")
	        local f2=function()
	           switch(process.ss)
	        end
			process.jobbusy=function()
			  f_wait(f2,5)
			end
			print("等待时间",sec,"实际",sec-30)
			if sec-30>0 then
	        f_wait(f2,sec-30)
            local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
			else
			   print("小于20s 不在打坐")
			   f_wait(f2,5)
			end
		 else
		    Weapon_Check(process.ss)
		 end
	   end
	   cd:start()
	  end
   end
   local cb=fight.new()
	_ss.fight_reset=function()
	      print("ss fight reset!!")
	      local select_pfm=world.GetVariable("ss_fight_pfm")
          local _pfm=world.GetVariable(select_pfm)
		  local f=function()
		    print("重置pfm！！")
            world.SetVariable("pfm",_pfm)
		    local pfm=world.GetVariable("pfm")
	        pfm=string.gsub(pfm,"@id",_ss.id)
            cb.combat_alias=pfm
		  end
		  f_wait(f,1)
	end
	_ss.prepare=function()
		local flag=_ss.fight
	    print("战斗模块",flag)
	   if flag==true then
	      local select_pfm=world.GetVariable("ss_fight_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ss_fight_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
	   else
	      local select_pfm=world.GetVariable("ss_kill_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ss_kill_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
	   end
      print("自动auto_pfm")
	  local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
		world.Send("alias pfm "..pfm)
	end
    _ss.auto_pfm=function()

	   local flag=_ss.fight
	    print("战斗模块",flag)
	   if flag==true then
	      local select_pfm=world.GetVariable("ss_fight_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ss_fight_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
	   else
	      local select_pfm=world.GetVariable("ss_kill_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ss_kill_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
	   end
      --print("自动auto_pfm")
	  local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
	   cb.combat_alias=pfm
	  --world.Execute(pfm)
	  cb:before_kill()
   end
	_ss.combat=function()

	   local flag=_ss.fight
	    print("战斗模块",flag)
	   if flag==true then
	      local select_pfm=world.GetVariable("ss_fight_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ss_fight_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		   local ss_fight_pfm_list=world.GetVariable("ss_fight_pfm_list") or ""
	      if ss_fight_pfm_list~=nil then
	       cb.pfm_list=world.GetVariable(ss_fight_pfm_list)
	      end
	   else
	      local select_pfm=world.GetVariable("ss_kill_pfm")
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		   local ss_kill_pfm_list=world.GetVariable("ss_kill_pfm_list") or ""
	      if ss_kill_pfm_list~=nil then
	       cb.pfm_list=world.GetVariable(ss_kill_pfm_list)
	      end
	   end

	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_ss.id)

       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id",_ss.id)
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		   world.Send("unset wimpy")
		  _ss:flee()
	     end
      end
	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
		   print("战斗结束")
		   world.Send("unset wimpy")
		 shutdown()
           if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
		   	  end
		   end
		 if _ss.jobtype=="刺杀" then
		   _ss:qie_corpse()
		 else
		   _ss:qing_again()
		 end
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		  world.Send("unset wimpy")
		 _ss:flee()
	  end
	  	 -- jue:wuzhuan()
	  --jue:maze()
	  --jue:fuxue()
	  --jue:tianyin()
	    cb:start()
   end
   _ss.fight_end=function(callback)
       print("战斗结束")
		   world.Send("unset wimpy")
           if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
		   	  end
		   end
		callback()
   end
    _ss.jobDone=function()
      print("ss 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  --Songshan_male_learn(process.sx)
			  --Songshan_lingwu(process.sx)
			   --Go_learn(process.sx)
			   --Go_learn(process.xs)
			   level_up(f)
			  --dali_learn_literate(process.xs)
		 else
		    --继续job
            --print("继续wd")
			f()
		 end
	  end
	  h:check()
   end
    _ss:Status_Check()
end

local function tm()
   package.loaded["teachmonk"]=nil
   require "teachmonk"
   local jb1,jb2=Job_Next("tm")
   xp:check()
   local _tm=teachmonk.new()
   local select_pfm=world.GetVariable("tm_pfm")
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _tm.neili_upper=tonumber(neili_upper)
   end
   _tm.fail=function(id)
     print("id:",id)
	 if id==101 then
       local b
	   b=busy.new()
	   b.Next=function()
		  local _job
		  _job=check_job(jb1)
		  _job()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f2=function()
	           switch(process.tm)
	        end
	        f_wait(f2,sec)
            local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			   elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    process.tm()
		 end
	   end
	   cd:start()
	 end
   end
    local cb
    _tm.combat=function()

       print("战斗模块")
	   cb=fight.new()
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","mo tou")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id","mo tou")
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
          _tm:flee()
	     end
      end

	  cb.finish=function()
          print("战斗结束")
		  world.Send("unset wimpy")
		  shutdown()
		  local b=busy.new()
		  b.Next=function()
		      world.Send("jiali 1")
		     world.Send("get gold from corpse")
			 world.Send("get muou from corpse")
			 _tm.jobDone()
		  end
		  b:check()
	  end
	  cb.neili_lack=function()
	     print("内力不够")
          _tm:flee()
	  end
	  cb:start()
   end
    _tm.motou_die=function()
         print("战斗结束2")
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 local b=busy.new()
		 b.interval=0.5
		 b.Next=function()
		   world.Send("jiali 1")
		   world.Send("get gold from corpse")
		   world.Send("get muou from corpse")
           _tm.jobDone()
		 end
		b:check()
   end
    _tm.giveup=function()
	     print("继续")
		 local _job
		 _job=check_job(jb2)
		 assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
		 _job()

    end
    _tm.jobDone=function()
      print("tm 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			   print("继续")
			local _job
			_job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			level_up(_job)
		 else
		    --继续job
            print("继续")
			 print("继续")
			local _job
			_job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			_job()
		 end
	  end
	  h:check()
   end
   _tm:Status_Check()
end

local function xc()
   package.loaded["xuncheng"]=nil
   require "xuncheng"
   local f=check_job(Job_Next("xc"))
   local xc
   xc=xuncheng.new()
   xc.cycle=false
   local xc_type=world.GetVariable("xc_type")
   if xc_type=="neixiwan" then
      xc.eat_neixiwan=true
   elseif xc_type=="xujingdan" then
      xc.eat_xujingdan=true
   end
   xc.drug_ok=function()
      xc:xc()
   end
   xc.jobDone=function()
     -- print("xun cheng 结束")
	  local h
	  h=hp.new()
	  h.checkover=function()
	         print("潜能:",h.pot," max:",h.max_pot)
			 local pot_overflow=world.GetVariable("pot_overflow")
		    if pot_overflow==nil then
		       pot_overflow=20
		    else
		      pot_overflow=tonumber(pot_overflow)
		    end
	         if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  local f2=function()
			     level_up(f)
			  end
			  Weapon_Check(f2)
			  --dali_learn_literate(process.xc)
			  --dali_learn_zhizao(process.xc)
		    else
		    --继续job
			 assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
              f()
			end
	  end
	  h:check()
	  --xiulian_Status_Check(f)
   end
   xc:Status_Check()
end

local _sld_last_ok=true
function reset_sld()
	    --ColourNote("red","white","倒计时结束,_sld_last_ok=true！")
	--world.AppendToNotepad (WorldName(),os.date()..": 索命:_sld_last_ok=true \r\n")
    _sld_last_ok=true
end

local function sld_suoming()
  package.loaded["suoming"]=nil
  require "suoming" --神龙岛索命
   local jb1,jb2=Job_Next("suoming")
   print(jb1,jb2," suoming:",_sld_last_ok)
   if _sld_last_ok==true then
   world.AppendToNotepad (WorldName(),os.date()..": 索命:"..jb1..","..jb2..",".."true".." \r\n")
  else
   world.AppendToNotepad (WorldName(),os.date()..": 索命:"..jb1..","..jb2..",".."false".." \r\n")
  end
   if _sld_last_ok==false then
      print("神龙岛任务失败！！")
	  local jt=jobtimes.new()
	  jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	  end
	  jt:check()
	  return
   end
   xp:check()
   local _suoming=suoming.new()
   local select_pfm=world.GetVariable("suoming_pfm")
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _suoming.neili_upper=tonumber(neili_upper)
   end
   _suoming.job_failure=function()
      _sld_last_ok=false
	  -- world.AppendToNotepad (WorldName(),os.date()..": 索命:_sld_last_ok=false \r\n")

	  --world.DoAfterSpecial (900, "reset_sld()", 12)
	   world.AddTimer ("reset_sld", 0, 15, 0, "reset_sld()", timer_flag.Enabled + timer_flag.OneShot + timer_flag.ActiveWhenClosed + timer_flag.Replace, "")
       world.SetTimerOption ("reset_sld", "send_to", 12)
   end
   _suoming.fail=function(id)
     print("id:",id)
	 if id==101 then
		local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f=function()
	           switch(process.suoming)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.5
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    process.xs()
		 end
	   end
	   cd:start()
	 end
   end
    local cb
    _suoming.combat=function()

       print("战斗模块")
	   cb=fight.new()
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_suoming.id)
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id",_suoming.id)
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  --shutdown()
		  _suoming:flee()
	     end
      end
	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("战斗结束")
		  world.Send("unset wimpy")
		 shutdown()
		 _suoming:suoming()
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		 _suoming:flee()
	  end
	  cb:start()
   end
    _suoming.badman_die=function()
	  print("战斗结束")
	   world.Send("unset wimpy")
	   shutdown()
	  _suoming:suoming()
	end
    _suoming.jobDone=function()
      print("suoming 结束")
	  --_sld_last_ok=true
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			local _job
			_job=check_job(jb1)
			level_up(_job)
		 else
		    --继续job
            print("继续")
			local _job
			_job=check_job(jb1)
			_job()
		 end
	  end
	  h:check()
   end
   _suoming:Status_Check()
end

function learn_literate(CallBack)
  package.loaded["learn"]=nil
  require "learn"

	   l_learn=learn.new()
	   l_learn.vip=run_vip
	   l_learn:addskill("literate")
	   l_learn.masterid="gu"
	   l_learn.pot=world.GetVariable("pot")
	   l_learn.master_place=71
	   l_learn.wuxing=function()
	      local wx=world.GetVariable("wuxing") or ""
		  if wx~="" and wx~=nil then
		    --print("执行")
		    world.Execute(wx)
		  end
	   end
	   l_learn.start_success=function()
	      world.Send("yun regenerate")
	      l_learn:start()
	   end
	   l_learn.AfterFinish=function()
	      print("学习结束")
	      --TH_Status_Check(CallBack)
		  xiulian_Status_Check(CallBack)
	   end
	   l_learn.start_failure=function(error_id)
	       if error_id==101 then
		      local work=function(num)
			   local f=function()
			    l_learn:go()
			   end
			   qu_gold(f,num,50,CallBack)
			  end
		      l_learn:cost("ask gu about 学费",work)
		      --取钱
		   end
		   if error_id==2 then  --没有找到师傅
			  l_learn:go()
		   end
		   if error_id==102 then  --潜能用完
		      --process.xc()
			  --CallBack()
			   world.Send("unwield jian")
			  l_learn:finish()
		   end
		   if error_id==1 or error_id==201 then  --经验限制 或 超越师傅
			  local is_ok=l_learn:Next()
				if is_ok==true then  --还有候选项
				  l_learn:start()
				else
				  Songshan_male_learn(CallBack)
				end
			end
			if error_id==401 then
			   l_learn:regenerate()
			end
			if error_id==402 then  --内力不足
			  l_learn:rest()
			end
			if error_id==403 then  --内力转换精血 继续学习
			  l_learn:start()
			end
			if error_id==920 then  --学满了
			    local bei_up=world.GetVariable("bei_up")
		        world.SetVariable("up",bei_up)
		       level_up(CallBack)
			end
	  end

	   l_learn.rest=function()
	     local w
		  w=walk.new()
		  w.walkover=function()
			 local ss_rest=rest.new()
			 ss_rest.wake=function(flag)
			     if flag==0 then
			          print("睡觉太频繁了!")
			          local ch=hp.new()
			          ch.checkover=function()
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  睡觉太频繁 打坐 start
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
								if id==202 then --safe room 没有办法打坐
								   local b1
								   b1=busy.new()
								   b1.Next=function()
								     w1:go(141)
								   end
								   b1:check()
	                            else
		                           local f1
		                           f1=function()
								     world.Send("yun regenerate")
								     x:dazuo()
								   end
	                               f_wait(f1,10)
								end
                              end
							  x.success=function(h)
							     l_learn:go()
							  end
	                          x:dazuo()
							  ---  睡觉太频繁 打坐 end
			                end
                            w1:go(141)
			          end
					ch:check()
				  else
					l_learn:go()
				  end
			 end
			 ss_rest:sleep()
		  end
		  w:go(142)
	  end
	  l_learn:go()
end

local function reading(cmd,callback,read_roomno,sleeproomno)
         print("读书")
		 wait.make(function()
		   --world.Send("read medicine book")
		    local wx=world.GetVariable("wuxing")
			world.Execute(wx)
		   world.Execute("#10 "..cmd)
		    world.Send("yun regenerate")
		   world.Send("set action 读书")
		   local l,w=wait.regexp("你仔细研读着.*。|你现在过于疲倦，无法专心下来研读新知。|^(> |)你的内力不够。$|你正在研习.*，似乎有点心得。|^(> |)你研读着有关.*的技巧，似乎有点心得。$|^(> |)你研读着有关.*的技巧，对.*似乎有些心得。|^(> |)你研读.*颇有心得。$|^(> |)你内力不够，无法.*这么高深的武功。$|^(> |)你正在研读.*，似乎有些心得。$|^(> |)由于你的基本刀法火侯不够，无法再获得进一步的提高。$|^(> |)你望着佛像千奇百怪之手法，心中对基本手法有所领悟。$|^(> |)你研读着有关.*的技巧，似乎有些心得。$|^(> |)你对于六壬奇门之学的精深之处有了进一步的认识。$|^(> |)你的内力不够，无法领会这个技能。$|^(> |)你研读「吸星大法」秘籍拓本，对照自己的领悟要诀，似乎有些心得。$|^(> |)这最后一册书上的内容过于深奥，光靠研读而不身体力行是无法再获得进步的。$|^(> |)你的真气不够。$|^(> |)你太累了，还是先休息会.*$|^(> |)你的精神快不够了！$|^(> |)你的内力快不够了！$|^(> |)你照着图谱研习.*的运气法门，渐渐的悟出其中的精要所在。$|^(> |)你研读着.*似乎有些心得。$|^(> |)你内力不够，无法专心下来研读新知。$|^(> |)你对着大柱禅定，仿佛对大柱上的经文有所领悟。$|^(> |)你刚要冥想，只觉得天旋地转，原来你太疲劳了.*|^(> |)你屏息静气，闭目冥想，似乎对墙壁上的经文有所领悟。$|^(> |)你正在研习老子道德经，对于道家心法似乎有点心得。$|^(> |)设定环境变量：action \\= \\\"读书\\\"$",5)

		   if l==nil then
		     reading(cmd,callback,read_roomno,sleeproomno)
			 return
		   end
		   if string.find(l,"读书") or string.find(l,"对于道家心法似乎有点心得") or string.find(l,"你对着大柱禅定") or string.find(l,"你屏息静气") or string.find(l,"有了进一步的认识") or string.find(l,"似乎有些心得") or string.find(l,"你仔细研读着") or string.find(l,"你望着佛像千奇百怪之手法") or string.find(l,"你正在研习") or string.find(l,"似乎有点心得") or string.find(l,"似乎有些心得") or string.find(l,"颇有心得") or string.find(l,"你研读") or string.find(l,"你照着图谱") then

			 wait.time(0.5)
		    --local f=function()
			    reading(cmd,callback,read_roomno,sleeproomno)
			 --end
		     --f_wait(f,0.3)
			 return
		   end
		   if string.find(l,"由于你的基本刀法火侯不够，无法再获得进一步的提高") then
			   callback()
		      return
		   end
		   if string.find(l,"你现在过于疲倦，无法专心下来研读新知") or string.find(l,"你太累了，还是先休息会")  then
		      world.Send("yun regenerate")
			  reading(cmd,callback,read_roomno,sleeproomno)
		      return
		   end
		   if string.find(l,"你的精神快不够了") or string.find(l,"你的内力快不够了")  or string.find(l,"你内力不够，无法专心下来研读新知") or string.find(l,"天旋地转") then
		         world.Send("yun regenerate")
			  process.readbook(cmd,callback,read_roomno,sleeproomno)
		      return
		   end


		   if string.find(l,"你的内力不够") or string.find(l,"你内力不够") or string.find(l,"这最后一册书上的内容过于深奥") or string.find(l,"你的真气不够")  then
		      print("内力不够")

			  process.readbook(cmd,callback,read_roomno,sleeproomno)
		     return
		   end
		   wait.time(5)
		 end)
end

function readhand()
    world.Send("yun qi")
   process.readbook("ningwang foxiang")
   local f=function()
       shutdown()
	   local b=busy.new()
	   b.Next=function()

	      readhand()
	   end
	   b:check()
   end
   f_wait(f,90)
end

local function readbook(cmd,callback,read_roomno,sleeproomno) --前往指定房间读书
   if cmd=="du shibei" or cmd=="read shibei" then  --桃花岛读石碑
      local f=function()
	     shutdown()
		 local b=busy.new()
		 b.Next=function()
		    process.readbook(cmd,callback,read_roomno,sleeproomno)
		 end
		 b:check()
	  end
	  f_wait(f,60)

   end
   local x
   x=xiulian.new()
   x.min_amount=100
   x.safe_qi=200
   x.fail=function(id)
      print(id)
	  if id==1 then
	     --正循环打坐
		 print("正循环打坐")
		 if x.hp.max_neili>1000 then
		   world.Send("yun recover")
		 end
		 local f=function()
		   x:dazuo()
		 end
		 f_wait(f,1.5)
	  end
	  if id==201 then
	     --[[local f=function()
	      world.Send("yun regenerate")
		  x:dazuo()
         end
		 f_wait(f,3)]]
		  local w=walk.new()
		  w.walkover=function()
			local r
			r=rest.new()
			r.wake=function()
			  --醒来
			  process.readbook(cmd,callback,read_roomno,sleeproomno)

			end
			r:sleep()
		  end
		  w:go(sleeproomno)
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
			print(roomno[1])
			local r=nearest_room(roomno)
			w:go(r)
		end
		_R:CatchStart()
	  end
   end
   x.success=function(h)
     -- world.Send("yun qimen")
	  if h.qi>=h.max_qi*0.5 then
	     x:dazuo()
	  else
	    world.Send("yun qi")
	    if read_roomno==nil or read_roomno=="" then
	      reading(cmd,callback,read_roomno,sleeproomno)
		else
		  local w=walk.new()
		  w.walkover=function()
	        reading(cmd,callback,read_roomno,sleeproomno)
		  end
		  w:go(read_roomno)
		end
	  end
   end
   x:dazuo()
end

local function sx()
   package.loaded["songxin"]=nil
   require "songxin"
    local party=world.GetVariable("party") or ""
	local is_liandu=world.GetVariable("liandu") or ""
   local f=check_job(Job_Next("sx"))
    xp:check()
   local _sx={}
   _sx=songxin.new()
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _sx.neili_upper=tonumber(neili_upper)
   end
   local immediate_sx1=assert(world.GetVariable("immediate_sx1"))
   if immediate_sx1=="true" then
      _sx.immediate_sx1=true  --立刻投递 true
   else
	  _sx.immediate_sx1=false  --立刻投递 false
   end
   local sx_blacklist=""
   sx_blacklist=assert(world.GetVariable("sx_blacklist"))
	if sx_blacklist~=nil then
	   _sx.blacklist=sx_blacklist
	end
   _sx.shield=function()
	  --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	 local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if (k=="送信1" or k=="全部") and  _sx.status=="送信1" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
		 if (k=="送信2" or k=="全部")  and  _sx.status=="送信2" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
   end
   local shashou_level=world.GetVariable("shashou_level")
   if shashou_level~=nil then
      shashou_level=tonumber(shashou_level)
	  _sx.shashou_level=shashou_level
   end
   _sx.fail=function(id)
     --print("id:",id)
	 if id==101 then
       local b
	   b=busy.new()
	   b.Next=function()
         f()
	   end
	   b:check()
	 end
	 if id==102 then
		local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
	      local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   print("等待sec:",sec)
			   break
			  end
			end
	        print(sec," 时间")
			 if sec==0 then
			    process.sx()
				return
			 end
			print("内功修炼")
			 world.Send("unset 积蓄")
	        local f2=function()
	           switch(process.sx)
	        end
			print("等待时间",sec,"实际",sec-40)
			process.jobbusy=function()
			  f_wait(f2,5)
			end
			if sec-40>0 then
	        f_wait(f2,sec-40)
            local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
			else
			   print("小于40s 不在打坐")
			   f_wait(f2,5)
			end
	   end
	    cd:start()

	 end
   end
   local cb=fight.new()
   --cb.auto_perform=true
   _sx.auto_pfm=function()
        local select_pfm=world.GetVariable("sx_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的sx_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		  cb.combat_alias=_pfm
		  cb:before_kill()
	end
   _sx.test_combat=function()
      cb.check_time=5
	  cb:combat_check()
	  cb:resume_combat_check()
   end
   _sx.sure_shashou=function()
		 local party=world.GetVariable("party")
	    if party=="武当派" then
	      _sx:liuhe()
	    end
        local pfm=world.GetVariable("pfm")
	    local unarmed_pfm=world.GetVariable("unarmed_pfm")
		local _pfm_items=Split(pfm,";")
		local _unarmed_pfm_items=Split(unarmed_pfm,";")
      --[[
		for index,item in ipairs(_sx.shashou_list) do
				local id=item.shashou_id
				--print(id," ? ",index)
				if id then
				 if index==1 then
				   for _,cblist in ipairs(cb.combine_list) do
				      cblist.cmd=string.gsub(cblist.cmd,"@id1",id)
					  print(cblist.cmd)
				   end

				 elseif index==2 then
				    for _,cblist in ipairs(cb.combine_list) do
				      cblist.cmd=string.gsub(cblist.cmd,"@id2",id)
					  print(cblist.cmd)
				   end
				 end
				end
		end]]
		cb.combat_alias=""
		for _,p in ipairs(_pfm_items) do
		     if string.find(p,"@id1") or string.find(p,"@id") then
			   for index,item in ipairs(_sx.shashou_list) do
			      local id=item.shashou_id
			      --cb.combat_alias=cb.combat_alias..string.gsub(p,"@id1",id)..";"
				  cb.combat_alias=cb.combat_alias..string.gsub(p,"@id",id)..";"
				  --print(cb.combat_alias," 测试")
			   end
			 else
		       cb.combat_alias=cb.combat_alias..p..";"
			 end
		end
		if string.len(cb.combat_alias)>0 and string.sub(cb.combat_alias,-1,-1)==";" then
		     cb.combat_alias=string.sub(cb.combat_alias,1,-2)
		end

		cb.unarmed_alias=""
		for _,u in ipairs(_unarmed_pfm_items) do
		      if string.find(u,"@id") then
			   for index,item in ipairs(_sx.shashou_list) do
			      local id=item.shashou_id
				   cb.unarmed_alias=cb.unarmed_alias..string.gsub(u,"@id",id)..";"
			   end
			  else
			     cb.unarmed_alias=cb.unarmed_alias..u..";"
			  end
		end
		if string.len(cb.unarmed_alias)>0 and string.sub(cb.unarmed_alias,-1,-1)==";" then
		     cb.unarmed_alias=string.sub(cb.unarmed_alias,1,-2)
		end
		cb.current_alias=cb.combat_alias
		cb:reset()
   end

	_sx.combat_check=function()

	    print("逃跑以后启动战斗检查!!!")
	    cb.check_time=10
		cb:combat_check()
		cb.finish=function()
		  print("flee ")
		  shutdown()
		  _sx:giveup()
		end
	end
    _sx.get_shashou_id=function(id)
      cb.fightcmd="kill "..id
	  --world.Send("kill "..id)
	  print("fightcmd:",cb.fightcmd)
	  world.Send(cb.fightcmd)
    end
   _sx.combat=function()
      print("战斗模块")
	  local select_pfm
	  if _sx.status=="送信1" then
	    -- print(_sx.status,"")
		 local sx_pfm_list=world.GetVariable("sx_pfm_list") or ""
         if sx_pfm_list~=nil then
	       cb.pfm_list=world.GetVariable(sx_pfm_list)
         end
	     select_pfm=world.GetVariable("sx_pfm") or ""
	  else

		local sx2_pfm_list=world.GetVariable("sx2_pfm_list") or ""
        if sx2_pfm_list~=nil then
	      cb.pfm_list=world.GetVariable(sx2_pfm_list)
        end
	    select_pfm=world.GetVariable("sx2_pfm")
	    print("*********************")
	    print(_sx.robber_skill)
		local _pfm,_pfm_list=cb:po_enemy_skills(_sx.robber_skill)
	    print("*********************")
	    if _pfm~=nil and _pfm_list~=nil then
	       print(_pfm," 使用的技能")
		   print(_pfm_list," 使用的切换顺序")
		   select_pfm=_pfm
		   cb.pfm_list=_pfm_list
		end
	  end
	  if select_pfm==nil then
       utils.msgbox ("你的sx_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
       return
      end
      local _pfm=world.GetVariable(select_pfm)
	  world.SetVariable("pfm",_pfm)
	   local pfm=world.GetVariable("pfm")
	   local unarmed_pfm=world.GetVariable("unarmed_pfm") or ""
	   cb.combat_alias=string.gsub(pfm,"@id","")
	   cb.unarmed_alias=string.gsub(unarmed_pfm,"@id","")
	   cb.enemy_name=_sx.shashou_name
	  cb.enemy_busy=function()
	     print("抓busy:",cb.enemy_name)

	  end
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  cb.run_flee=true
		  _sx:flee()
	     end
      end
	  cb.escape=function()
	      print("flee")
		 _sx:flee()
	  end
	  cb.neili_lack=function()
		 print("flee")
		 _sx:flee()
	  end
	  cb.finish=function()
        print("战斗结束")
		 shutdown()
		  print("第二波")
          _sx:wait_shashou()
		  print("wait attack")
          _sx:secondCome()
		  world.Send("unset wimpy")
		 local b=busy.new()
		  b.interval=1
		 b.Next=function()
			 world.Send("get silver from corpse")
			 world.Send("get coin from corpse")
			if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		        world.Send("get " ..weapon_item.. " from corpse")
			    world.Send("get "..weapon_item)
			  end
		    end
			if cb.status=="大转" then
			   print("延时2秒")
			   world.Send("alias pfm")
			   local f=function()
			       --world.Send("get hammer")
				   --world.Send("get falun")
			      _sx:loot()
			    end
			    f_wait(f,2)
			elseif cb.status=="暴雨梨花针" then
				 world.Send("get zhen")
				 world.Send("get zhen from corpse")
				 world.Send("get zhen from corpse 2")
				 _sx:loot()
			else
			    _sx:loot()
			end

		end
		if cb.status=="大转" then
		  b:jifa()
		else
		  b:check()
		end
	  end
       cb:start()
   end
   _sx.loot_corpse=function()
		if party=="星宿派" and is_liandu=="自动" and _sx.status=="送信2" then
			  world.Send("drop corpse")
		      world.Send("drop pao")
			  world.Send("get corpse")
		end
   end
   _sx.combat_end=function()
        print("战斗结束")
		 shutdown()
		 print("第二波")
		 _sx:wait_shashou()
		  print("wait attack")
          _sx:secondCome()
		  world.Send("unset wimpy")
		 local b=busy.new()
		 b.interval=1
		 b.Next=function()
		   world.Send("get silver from corpse")
		   world.Send("get coin from corpse")
		   if cb.is_duo==true then
			 for _,weapon_item in ipairs(cb.lost_weapon_id) do
		        world.Send("get " ..weapon_item.. " from corpse")
			    world.Send("get "..weapon_item)
			 end
		   end
			if cb.status=="大转" then
			   print("延时2秒")
			    world.Send("alias pfm")
			   local f=function()
			      --world.Send("get hammer")
				  --world.Send("get falun")
			      _sx:loot()
			    end
			    f_wait(f,2)
			elseif cb.status=="暴雨梨花针" then
				 world.Send("get zhen")
				 world.Send("get zhen from corpse")
				 world.Send("get zhen from corpse 2")
				 _sx:loot()
			else
			    _sx:loot()
			end
		end
		if cb.status=="大转" then
		  b:jifa()
		else
		  b:check()
		end
   end
   _sx.jobDone=function()
      print("sx 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
         local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			 --星宿自动炼毒
		     if party=="星宿派" and is_liandu=="自动" then
			    package.loaded["liandu"]=nil
			    require "liandu"
			    local ld=liandu.new()
				ld.liandu_end=function()
				   level_up(f)
				end
				ld:liandu()
			 else
			   level_up(f)
		     end
		 else
		    --继续job
             if party=="星宿派" and is_liandu=="自动" then
			    package.loaded["liandu"]=nil
			    require "liandu"
		        local ld=liandu.new()
				ld.liandu_end=function()
				   f()
				end
				ld:liandu()
			else
			   f()
		   end
		 end
	  end
	  h:check()
   end
   _sx.liaoshang_fail=function()
      world.Send("fu jiuhua wan")
   end
   _sx:Status_Check()
end

local wait_count=0
function wait_test(count)
  if count~=nil then
     wait_count=count
  end
   wait.make(function()
      local l,w=wait.regexp("1",1)
	  if l==nil then
	     wait_count=wait_count+1
		 print(wait_count,"特殊")
		 if wait_count>10 then
		   return
		 else
		    wait_test()
		 end
	     return
	  end
   end)
end

local function xs()
   package.loaded["xueshan"]=nil
   require "xueshan"
   local jb1,jb2=Job_Next("xs")
   local f=check_job(jb1)
   local f2=check_job(jb2)
   xp:check()
   local _xs={}
   _xs=xueshan.new()
   _xs.blacklist=assert(world.GetVariable("xs_blacklist")) or ""
   local select_pfm=world.GetVariable("xs_pfm")
   local select_pfm2=world.GetVariable("xs_fight_pfm")
   if select_pfm==nil then
      utils.msgbox ("你的xs_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
      return
   end
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
    local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _xs.neili_upper=tonumber(neili_upper)
	  -- print("倍率: ",_xs.neili_upper)
   end
   local party=""
   local run_kill=world.GetVariable("xs_runkill") or true
   _xs.run_kill=run_kill
   _xs.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="雪山" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
   end
   --[[_xs.party=function(id,weapon,super_guard)
      if _xs.super_guard==true and party=="古墓" and weapon=="长剑" then
		 shutdown()
		 print("直接放弃！！海潮")
		 _xs:giveup()
	     return
	  end

   end]]
   local player_id=world.GetVariable("player_id")
   _xs.id=player_id
   _xs.fail=function(id)
     print("id:",id)
	 if id==101 then
        f()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态"  then
			   sec=i[2]
			   break
			  end
			  if i[1]=="雪山强抢美女" then
			    sec=i[2]
				if sec<20 then
				   break
				end

			    local jt=jobtimes.new()
			    jt.checkover=function(jobname)
		         print("jobname :",jobname)
				 if jobname=="强抢美女" or sec>=20 then --最后一个任务
	              local _job_name=chinese_job_name(jobname)
		          local _job={}
		          if string.find(jb1,_job_name) then
		            _job=check_job(jb2)
		           else
			        _job=check_job(jb1)
		           end
	               local b
	               b=busy.new()
	               b.Next=function()
		            _job()
	               end
	               b:check()
				 else
				   local f2=function()
				     local w=walk.new()
				      w.walkover=function()
				        process.xs()
				      end
				      w:go(1657)
	               end
				    f_wait(f2,5)
				 end
			    end
	            jt:check()
				return
			    --break
			  end
			end

			 print(sec," 时间")
			 if sec==0 then
			    process.xs()
				return
			 end
			print("内功修炼")
			 world.Send("unset 积蓄")
	        local f2=function()
	           switch(process.xs)
	        end
			process.jobbusy=function()
			  f_wait(f2,5)
			end
			print("等待时间",sec,"实际",sec-40)
			if sec-40>0 then
	        f_wait(f2,sec-40)
            local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
			else
			   print("小于40s 不在打坐")
			   f_wait(f2,5)
			end
		 else
		    process.xs()
		 end
	   end
	   cd:start()
	 end
   end
   local cb
   print("战斗模块")
   cb=fight.new()
   cb.escape=function()
	  print("flee")
      _xs:flee()
   end
   _xs.auto_pfm=function(cmd)
         local select_pfm=world.GetVariable("xs_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的xs_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		  cb.combat_alias=_pfm
		  cb:before_kill()
   end
   _xs.sure_enemy_party=function()
	  --2012-08-02 新增 根据门派选用不同skill
	  print("*********************")
	  print(_xs.guard_party)
	  local _pfm,_pfm_list=cb:po_enemy_skills(_xs.guard_party)
	  print("*********************")
	  if _pfm~=nil and _pfm_list~=nil then
	    print(_pfm," 使用的技能")
		print(_pfm_list," 使用的切换顺序")
	    cb.pfm_list=world.GetVariable(_pfm_list)
        local s_pfm=world.GetVariable(_pfm)
        world.SetVariable("pfm",s_pfm)
	  end
	  --
	end
   _xs.combat_end=function()
   -- npc 晕倒
      print("晕了！")
	  cb.auto_perform=false
	  local timeout=function()
	    print("超时!!guard 还没有死？")
	    cb.auto_perform=true
	  end
	  f_wait(timeout,10)
   end
   _xs.combat=function()
       --[[if _xs.super_guard==true then
          local _pfm=world.GetVariable(select_pfm2)
          world.SetVariable("pfm",_pfm)

		  local xs_fight_list=world.GetVariable("xs_fight_list") or ""
	      if xs_fight_list~=nil and xs_fight_list~="" then
	 	      cb.pfm_list=world.GetVariable(xs_fight_list)
		  else
			  cb.pfm_list=""
		  end
		   cb.fightcmd="fight ".._xs.guard_id
		else]]

			local xs_pfm_list=world.GetVariable("xs_pfm_list") or ""
	       if xs_pfm_list~=nil and xs_pfm_list~="" then
	  	       cb.pfm_list=world.GetVariable(xs_pfm_list)
	       end
		    cb.fightcmd="kill ".._xs.guard_id
		--end
		local select_pfm=world.GetVariable("xs_pfm")
		local _pfm=world.GetVariable(select_pfm)
		world.SetVariable("pfm",_pfm)
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_xs.guard_id)

       cb.combat_alias=pfm
	   cb.pfm_list=string.gsub(cb.pfm_list,"@id",_xs.guard_id)
	   cb.enemy_name=_xs.guard_name

	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id",_xs.guard_id)
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=30 or tonumber(hp.neili)<=500 or tonumber(hp.jingxue_percent)<=30 then
	      print("低于安全设置开始脱离战斗")
		  cb.run_flee=true
		  world.Send("unset wimpy")
		  world.Send("fu dan")
		  _xs:flee()
	     end
      end
	  --[[cb.fight_reset_fail=function()
	     shutdown()
		 print("守卫已经不在了！！")
	     _xs:NextPoint()
      end]]
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 world.Send("unset wimpy")
		 _xs:flee()
	  end
	  cb.finish=function()
		 print("战斗结束")
		 world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 world.Send("jiali 1")
		 local b=busy.new()
		 b.Next=function()
		  world.Execute("get silver from corpse;get gold from corpse")
		  --world.Send("get coin")
		  if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		    --   world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		  end
		     if cb.status=="大转" then
			   print("延时2秒")
			    world.Send("alias pfm")
			   local f=function()
			      --world.Send("get hammer")
				  --world.Send("get falun")
			      _xs:sa()
			    end
			    f_wait(f,2)
			elseif cb.status=="暴雨梨花针" then
				 world.Send("get zhen")
				 world.Send("get zhen from corpse")
				 _sx:loot()
			else
			    _xs:sa()
			end

		  _xs:sa()
		 end
		 if cb.status=="大转" then
		   b:jifa()
		 else
		   b:check()
		 end
	  end
	  cb:start(false)
   end
   _xs.guard_die=function()
	   print("战斗结束2")
	   world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 world.Send("jiali 1")
		 local b=busy.new()
		 b.Next=function()
		  world.Execute("get silver from corpse;get gold from corpse")
		  local party=world.GetVariable("party") or ""
		  local is_liandu=world.GetVariable("liandu") or ""
		  --星宿自动炼毒
		  if party=="星宿派" and is_liandu=="自动" then
		      world.Send("get corpse")
		  end
		  if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		    --   world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		  end
			if cb.status=="大转" then
			   print("延时2秒")
			    world.Send("alias pfm")
			   local f=function()
			      --world.Send("get hammer")
				  --world.Send("get falun")
			      _xs:sa()
			    end
			    f_wait(f,2)
			elseif cb.status=="暴雨梨花针" then
				 world.Send("get zhen")
				 world.Send("get zhen from corpse")
				 _sx:loot()
			else
			    _xs:sa()
			end

		 end
		 if cb.status=="大转" then
		   b:jifa()
		 else
		   b:check()
		 end
   end
   _xs.guard_idle=function()
        world.Send("unset wimpy")
		print("guard 晕了")
		world.Send("kill ".._xs.guard_id)
   end
   _xs.jobDone=function()
      print("xs 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	     -- world.AppendToNotepad (WorldName().."_雪山任务:",os.date()..": 受伤程度:"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")".."\r\n")
        --[[if h.qi_percent<80 then
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "red", "black") -- yellow on white
         elseif h.qi_percent<90 then
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "yellow", "black") -- yellow on white
		 else
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."雪山任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "white", "black") -- yellow on white
		 end
		print("潜能:",h.pot," max:",h.max_pot)]]
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
		 local party=world.GetVariable("party") or ""
		  local is_liandu=world.GetVariable("liandu") or ""

	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			--星宿自动炼毒
		     if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
			    local ld=liandu.new()
				ld.liandu_end=function()
				   level_up(f)
				end
				ld:liandu()
			 else
			   level_up(f)
		     end
		 else
		    --继续job
            print("继续")
			--星宿自动炼毒
		    if party=="星宿派" and is_liandu=="自动" then
			     package.loaded["liandu"]=nil
			    require "liandu"
		        local ld=liandu.new()
				ld.liandu_end=function()
				   f()
				end
				ld:liandu()
			else
			   f()
		   end
		 end
	  end
	  h:check()
   end
   local ready=world.GetVariable("ready") or ""
   if ready~="" then
	 local b=busy.new()
	 b.interval=0.3
	 b.Next=function()
	   world.Execute(ready)
	   _xs:Status_Check()
	 end
	 b:check()
   else
     _xs:Status_Check()
   end
   --_xs:use_item()
end

local function hs()
  package.loaded["huashan"]=nil
  require "huashan"
  world.DeleteVariable("do_hs2")
    local f=check_job(Job_Next("hs"))

   xp:check()
   local _hs={}
   _hs=huashan.new()
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _hs.neili_upper=tonumber(neili_upper)
	  -- print("倍率: ",_xs.neili_upper)
   end

     _hs.hs2=false
	 _hs.dayun=false
	 local select_pfm=world.GetVariable("hs_pfm")
     local _pfm=world.GetVariable(select_pfm)
     world.SetVariable("pfm",_pfm)

   _hs.shield=function()
	  --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	   local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="华山" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
   end
   _hs.fail=function(id)
     --print("id:",id)
	 if id==101 then
       local b
	   b=busy.new()
	   b.Next=function()
		 f()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=tonumber(i[2])
			   break
			  end
			end
			if sec>30 then
		      print("内功修炼")
			  world.Send("unset 积蓄")
	         local f2=function()
	            switch(process.hs)
	         end
	         f_wait(f2,sec)
			 local b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
              elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()

			  end
			 end
			 b:check()
			else
			  local f3=function()
			     process.hs()
			  end
			  f_wait(f3,10)
			end
		 else
		    process.hs()
		 end
	   end
	   cd:start()
	 end
   end
   local cb
   print("战斗模块")
   cb=fight.new()
   _hs.combat=function()
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_hs.robberid)
       cb.combat_alias=pfm
	   cb.enemy_name=_hs.robbername
	   cb:before_kill()
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id",_hs.robberid)
		local hs_pfm_list=world.GetVariable("hs_pfm_list") or ""
        if hs_pfm_list~=nil then
	      cb.pfm_list=world.GetVariable(hs_pfm_list)
		  cb.pfm_list=string.gsub(cb.pfm_list,"@id1",_hs.robberid)
        end
	   cb.unarmed_alias=unarmed_pfm
	   cb.enemy_busy=function()
	     print("抓busy:",cb.enemy_name)
	  end
	  cb.damage=function(hp)
         --if tonumber(hp.qi_percent)<=50 then
	     -- print("低于安全设置开始脱离战斗")
		 -- _hs:flee()
	     --end
      end
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 _hs:flee()
	  end
	  cb.finish=function()
		 print("战斗结束1")
		 _hs:combat_end()
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 world.Send("jiali 1")
		 --world.Send("get coin")
		 if _hs.dayun==true then
			if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from ".._hs.robber_id)
			   world.Send("get "..weapon_item)
			  end
		    end
	        _hs:get_npc()
		 else
		    if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			  end
			end
			if cb.status=="暴雨梨花针" then
				 world.Send("get zhen")
				 world.Send("get zhen from corpse")
			end
	        _hs:qie_corpse()
		 end
	  end
	  cb:start()
   end
   _hs.robber_die=function()
       print("战斗结束2")
	   _hs:combat_end()
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 local b=busy.new()
		 b.interval=0.5
		 b.Next=function()
		   world.Send("jiali 1")
		   world.Send("get silver from corpse")
		   --world.Send("get coin")
		   if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		   end
			if cb.status=="暴雨梨花针" then
				 world.Send("get zhen")
				 world.Send("get zhen from corpse")
			end
	       _hs:qie_corpse()
		end
		b:check()
   end
   _hs.robber_idle=function()
         print("战斗结束3")
		 _hs:combat_end()
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 _hs:wait_robber_die() --防止npc晕倒以后被杀
		 world.Send("jiali 1")
		local b=busy.new()
	     b.interval=0.5
	     b.Next=function()
		   world.Send("get silver from ".._hs.robberid)
		   world.Send("get coin")
		   if cb.is_duo==true then
			 for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from ".._hs.robberid)
			   world.Send("get "..weapon_item)
			 end
		   end

	       _hs:get_npc()
		 end
		b:check()
   end
   _hs.jobDone=function()
      print("hs 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	     --检查job 顺序是否真确
		 local jb=jobtimes.new()
		 jb.checkover=function()
		    local hs_count=jb.lists["华山岳不群惩恶扬善"] or 0
			local wd_count=0
			if jb.lists["武当宋远桥杀恶贼"] == nil then
			    wd_count=0
			else
			    wd_count=jb.lists["武当宋远桥杀恶贼"]
			end
		    local c=wd_count+hs_count
			print("总次数:",c," 剩余次数:",(50-c%50))
            local xxdf=world.GetVariable("quest_xxdf") or "false"
			if (c%2)==0 or xxdf=="false" then
			     print("潜能:",h.pot," max:",h.max_pot)
		        local pot_overflow=world.GetVariable("pot_overflow")
		         if pot_overflow==nil then
		            pot_overflow=20
		         else
		            pot_overflow=tonumber(pot_overflow)
		         end
		         print("潜能:",h.pot," max:",h.max_pot," pot_overflow",pot_overflow)
	             if h.pot>h.max_pot-pot_overflow then
			      --开始学习
			       print("开始学习")
				   level_up(f)
		         else
		            --继续job
                    print("继续")
			        --process.tdh()
			        f()
		         end
			else
			    --自动加入送信
				print("自动送信1")
				process.sx()
			end

		 end
		 jb:check()

	  end
	  h:check()
   end
   _hs.liaoshang_fail=function()
      world.Send("fu jiuhua wan")
   end
   _hs:Status_Check()
end

local function hs2()
    package.loaded["huashan"]=nil
    require "huashan"
    world.SetVariable("do_hs2","true")
	local f=check_job(Job_Next("hs2"))
   xp:check()
   local _hs={}
   _hs=huashan.new()
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _hs.neili_upper=tonumber(neili_upper)
	  -- print("倍率: ",_xs.neili_upper)
   end

     _hs.hs2=true
	 _hs.dayun=false


   _hs.shield=function()
	  --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	   local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  -- or k=="全部")
	  local cmd=""
	  for k,v in pairs(json) do
	     if k=="华山" and _hs.run_hs2==false then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   return
		 end
	     if k=="华山2" and _hs.run_hs2==true then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   return
		 end
		 if k=="全部" then
		    cmd=v
		 end
	  end
	   world.Execute(cmd)
	   world.SetVariable("shield",cmd)
   end
   _hs.fail=function(id)
     --print("id:",id)
	 if id==101 then
       local b
	   b=busy.new()
	   b.Next=function()
		 f()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=tonumber(i[2])
			   break
			  end
			end
			if sec>30 then
		      print("内功修炼")
			  world.Send("unset 积蓄")
	         local f2=function()
	            switch(process.hs2)
	         end
	         f_wait(f2,sec)
			 local b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  end
			 end
			 b:check()
			else
			  local f3=function()
			     process.hs2()
			  end
			  f_wait(f3,10)
			end
		 else
		    process.hs2()
		 end
	   end
	   cd:start()
	 end
   end
   local cb=fight.new()
   _hs.combat=function()
      print("战斗模块")

	    local select_pfm
	    if _hs.run_hs2==true then
		  select_pfm=world.GetVariable("hs2_pfm")
		  local hs2_pfm_list=world.GetVariable("hs2_pfm_list") or ""
           if hs2_pfm_list~=nil then
	        cb.pfm_list=world.GetVariable(hs2_pfm_list)
			cb.pfm_list=string.gsub(cb.pfm_list,"@id1",_hs.robberid)
           end
		else
		  select_pfm=world.GetVariable("hs_pfm")
		  local hs_pfm_list=world.GetVariable("hs_pfm_list") or ""
           if hs_pfm_list~=nil then
	        cb.pfm_list=world.GetVariable(hs_pfm_list)
			cb.pfm_list=string.gsub(cb.pfm_list,"@id1",_hs.robberid)
           end
		end
	    local _pfm=world.GetVariable(select_pfm)
        world.SetVariable("pfm",_pfm)
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_hs.robberid)
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id",_hs.robberid)
	   cb.unarmed_alias=unarmed_pfm
	   cb:before_kill()


	  cb.damage=function(hp)
         --if tonumber(hp.qi_percent)<=50 then
		  --world.Send("fu da huandan")
	      --print("低于安全设置开始脱离战斗")
		  --_hs:flee()
	     --end
      end
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 _hs:flee()
	  end
	  cb.finish=function()
		 print("战斗结束1")
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 world.Send("jiali 1")
		 world.Send("get coin")
		 if _hs.dayun==true then
			if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from ".._hs.robber_id)
			   world.Send("get "..weapon_item)
			  end
		    end
	        _hs:get_npc()
		 else
		    if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			  end
			end
			if cb.status=="暴雨梨花针" then
				 world.Send("get zhen")
				 world.Send("get zhen from corpse")
			end
	        _hs:qie_corpse()
		 end
	  end
	  cb:start()
   end
   _hs.robber_die=function()
       print("战斗结束2")
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 local b=busy.new()
		 b.interval=0.5
		 b.Next=function()
		   world.Send("jiali 1")
		   --world.Send("get silver from corpse")
		   --world.Send("get coin")
		   world.Execute("get silver from corpse;get gold from corpse")
		   if cb.is_duo==true and cb then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		   end
			if cb.status=="暴雨梨花针" then
				 world.Send("get zhen")
				 world.Send("get zhen from corpse")
			end
	       _hs:qie_corpse()
		end
		b:check()
   end
   _hs.robber_idle=function()
         print("战斗结束3")
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 _hs:wait_robber_die() --防止npc晕倒以后被杀
		 world.Send("jiali 1")
		local b=busy.new()
	     b.interval=0.5
	     b.Next=function()
		   world.Send("get silver from ".._hs.robberid)
		   world.Send("get coin")
		   if cb.is_duo==true and cb then
			 for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from ".._hs.robberid)
			   world.Send("get "..weapon_item)
			 end
		   end
	       _hs:get_npc()
		 end
		b:check()
   end
   _hs.jobDone=function()
      print("hs2 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow",pot_overflow)
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			   level_up(f)
		 else
		    --继续job
            print("继续")
			--process.tdh()
			f()
		 end
	  end
	  h:check()
   end
   _hs.liaoshang_fail=function()
      world.Send("fu jiuhua wan")
   end
   _hs:Status_Check()
end

function zhizao_learn(CallBack)
  package.loaded["learn"]=nil
  require "learn"

	   l_learn=learn.new()
	   l_learn.vip=run_vip
	   l_learn.pot=world.GetVariable("pot")
	   l_learn:addskill("zhizao")
	   l_learn.masterid="caifeng"
	   l_learn.wuxing=function()
	      local wx=world.GetVariable("wuxing") or ""
		  if wx~="" and wx~=nil then
		    --print("执行")
		    world.Execute(wx)
		  end
	  end
	   l_learn.master_place=437
	   l_learn.AfterFinish=function()
	      print("学习结束")
	     xiulian_Status_Check(CallBack)
	   end
	   l_learn.start_success=function()
	      world.Send("yun regenerate")
		  l_learn:start()
	   end
	   l_learn.start_failure=function(error_id)
	        if error_id==101 then
		      --取钱
			  local f=function()
			    l_learn:go()
			  end
			  qu_gold(f,50,50,CallBack)
		   end
		   if error_id==2 then  --没有找到师傅
			  l_learn:go()
		   end
		   if error_id==102 then  --潜能用完
		      --process.xc()
			  --CallBack()
			 l_learn:finish()
		   end
		   if error_id==1 or error_id==201 then  --经验限制 或 超越师傅
			  local is_ok=l_learn:Next()
				if is_ok==true then  --还有候选项
				  l_learn:start()
				else
				  l_learn:finish()
				end
			end
			if error_id==401 then
			   l_learn:regenerate()
			end
			if error_id==402 then  --内力不足
			  l_learn:rest()
			end
			if error_id==403 then  --内力转换精血 继续学习
			  l_learn:start()
			end
	  end

	   l_learn.rest=function()
	     local w
		  w=walk.new()
		  w.walkover=function()
			 local ss_rest=rest.new()
			 ss_rest.wake=function(flag)
			     if flag==0 then
			          print("睡觉太频繁了!")
			          local ch=hp.new()
			          ch.checkover=function()
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  睡觉太频繁 打坐 start
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
								if id==202 then --safe room 没有办法打坐
								   local b1
								   b1=busy.new()
								   b1.Next=function()
								     w1:go(141)
								   end
								   b1:check()
	                            else
		                           local f1
		                           f1=function()
								     world.Send("yun regenerate")
								     x:dazuo()
								   end
	                               f_wait(f1,10)
								end
                              end
							  x.success=function(h)
							     l_learn:go()
							  end
	                          x:dazuo()
							  ---  睡觉太频繁 打坐 end
			                end
                            w1:go(141)
			          end
					ch:check()
				  else
					l_learn:go()
				  end
			 end
			 ss_rest:sleep()
		  end
		  w:go(142)
	  end

	  l_learn:go()
end

local reverse=0
function chenggao_learn(CallBack)
     package.loaded["learn"]=nil
  require "learn"

     print("学习成高道长")
	 local cg_learn={}
	  cg_learn=learn.new()
	  cg_learn.interval=1
	  cg_learn.timeout=1
	  local pot=world.GetVariable("pot")
	  cg_learn.pot=pot
	  cg_learn.masterid="chenggao"
	  local skills=world.GetVariable("skills")
	  sj.World_Init=function()
          cg_learn:go()
      end
	  local items=Split(skills,"|")
	  for _,i in ipairs(items) do
	     print(i)
		 if i~=nil and i~="" then
	       cg_learn:addskill(i)
		 end
	  end
	  cg_learn.master_place=2033
	  reverse=0
	  cg_learn.vip=run_vip
	  cg_learn.wuxing=function()
	      local wx=world.GetVariable("wuxing") or ""
		   if wx~="" and wx~=nil then
		    --print("执行")
		    world.Execute(wx)
		  end
	  end
	  cg_learn.start=function()
		local cmd
	    local skill_id
	    local i
     	i=cg_learn.skillsIndex
	    skill_id=cg_learn.skills[i]
		local master
		master=cg_learn.masterid
		world.Send("follow "..master)
	    cmd="ask " ..master .." about " ..skill_id
	    cg_learn:Execute(cmd)
	  end
	  cg_learn.AfterFinish=function() xiulian_Status_Check(CallBack) end
	  cg_learn.start_success=function()
		  world.Send("yun regenerate")
	      cg_learn:start()
	  end
	  cg_learn.start_failure=function(error_id)
		   if error_id==2 then  --没有找到师傅

		     	      if cg_learn.master_place==2028 then
					      cg_learn.master_place=2029
						  reverse=0
					  elseif cg_learn.master_place==2029 and reverse==0 then
					      cg_learn.master_place=2030
					  elseif cg_learn.master_place==2029 and reverse==1 then
					      cg_learn.master_place=2028
					  elseif cg_learn.master_place==2030 and reverse==0 then
					      cg_learn.master_place=2031
					  elseif cg_learn.master_place==2030 and reverse==1 then
					      cg_learn.master_place=2029
					  elseif cg_learn.master_place==2031 and reverse==0 then
						  cg_learn.master_place=2032
					  elseif cg_learn.master_place==2031 and reverse==1 then
						  cg_learn.master_place=2030
					  elseif cg_learn.master_place==2032 and reverse==0 then
						  cg_learn.master_place=2033
					  elseif cg_learn.master_place==2032 and reverse==1 then
						  cg_learn.master_place=2031
					  elseif cg_learn.master_place==2033 and reverse==0 then
 					       cg_learn.master_place=2034
					  elseif cg_learn.master_place==2033 and reverse==1 then
 					       cg_learn.master_place=2032
					  elseif cg_learn.master_place==2034 and reverse==0 then
 					       cg_learn.master_place=2035
					  elseif cg_learn.master_place==2034 and reverse==1 then
 					       cg_learn.master_place=2033
					  elseif cg_learn.master_place==2035 and reverse==0 then
 					       cg_learn.master_place=2041
					  elseif cg_learn.master_place==2035 and reverse==1 then
 					       cg_learn.master_place=2034
					  elseif cg_learn.master_place==2041 then
					       cg_learn.master_place=2035
						   reverse=1
					  else
					      cg_learn.master_place=2028
						  reverse=0
					  end
					  print("没有找到师傅"," 下个地点:",cg_learn.master_place)
				      cg_learn:go()

		   end
		   if error_id==101 then
		      --取钱
			  local f=function()
			    cg_learn:go()
			  end
			   qu_gold(f,100,50,CallBack)
		   end
		   if error_id==102 then  --潜能用完
			  world.Send("follow none")
			  cg_learn:finish()
		   end
		   if error_id==1 or error_id==201  then  --经验限制 或 超越师傅 或武器不对
			  local is_ok=dz_learn:Next()

				if is_ok==true then  --还有候选项
				  cg_learn:start()
				else
				  cg_learn:finish()
				end
			end
			if error_id==401 then
			   cg_learn:regenerate()
			end
			if error_id==402 then  --内力不足
			  cg_learn:rest()
			end
			if error_id==403 then  --内力转换精血 继续学习
			  cg_learn:start()
			end
	  end
	  cg_learn.rest=function()
	     local w
		  w=walk.new()
		  w.walkover=function()
			 local ss_rest=rest.new()
			 ss_rest.failure=function(id)
			    local f=function() w:go(308) end
				f_wait(f,10)
 			 end
			 ss_rest.wake=function(flag)
			     if flag==0 then
			          print("睡觉太频繁了!")
			          local ch=hp.new()
			          ch.checkover=function()
			             if ch.pot<20 then
				           --process.xc()
						   -- print("xc")
						   --CallBack()
							xiulian_Status_Check(CallBack)
						 else
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  睡觉太频繁 打坐 start
							  local f
							  f=function()
							    local b
								b=busy.new()
								b.Next=function()
								  cg_learn:go()
								end
								b:check()
							  end
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
								if id==202 then --safe room 没有办法打坐
								  local w
		                           w=walk.new()
		                          w.walkover=function()
			                        x:dazuo()
		                          end
		                          local _R
                                  _R=Room.new()
								  _R.CatchEnd=function()
                                    local count,roomno=Locate(_R)
		                            print(roomno[1])
		                            local r=nearest_room(roomno)
	                                w:go(r)
	                               end
                                  _R:CatchStart()
								end
                              end
							  x.success=function(h)
							     dz_learn:go()
							  end
	                          x:dazuo()
	                          f_wait(f,30)
							  ---  睡觉太频繁 打坐 end
			                end
                            w1:go(142)
						 end
			          end
					ch:check()
				  else
					cg_learn:go()
				  end
			 end
			 ss_rest:sleep()
		  end
		  w:go(308)
	  end
	  cg_learn:go()  --ss go learn
end

function duanzao_learn(CallBack)
     package.loaded["learn"]=nil
  require "learn"

     print("学习锻造")
	 local dz_learn={}
	  dz_learn=learn.new()
	  local pot=world.GetVariable("pot")
	  dz_learn.pot=pot
	  dz_learn:addskill("duanzao")
	  dz_learn.masterid="shi"
	  dz_learn.master_place=97
	  dz_learn.vip=run_vip
	  dz_learn.wuxing=function()
	      local wx=world.GetVariable("wuxing") or ""
		   if wx~="" and wx~=nil then
		    --print("执行")
		    world.Execute(wx)
		  end
	  end
	  dz_learn.AfterFinish=function() xiulian_Status_Check(CallBack) end
	  dz_learn.start_success=function()
		  world.Send("yun regenerate")
	      dz_learn:start()
	  end
	  dz_learn.start_failure=function(error_id)
		   if error_id==2 then  --没有找到师傅
			  local f=function() dz_learn:go() end
			  f_wait(f,5)
		   end
		   if error_id==101 then
		      --取钱
			  local f=function()
			    dz_learn:go()
			  end
			   qu_gold(f,50,50,CallBack)
		   end
		   if error_id==102 then  --潜能用完
			  world.Send("unwield jian")
			  dz_learn:finish()
		   end
		   if error_id==1 or error_id==201  then  --经验限制 或 超越师傅 或武器不对
			  local is_ok=dz_learn:Next()
			  if dz_learn.weapon~="" then
			     world.Send("unwield "..dz_learn.weapon)
			  end
				if is_ok==true then  --还有候选项
				  dz_learn:start()
				else
				  dz_learn:finish()
				end
			end
			if error_id==202 then
			   world.Send("wield jian")
			   dz_learn.weapon="jian"
			   dz_learn:start()
			end
			if error_id==203 then
			   world.Send("unwield jian")
			   dz_learn.weapon=""
			   dz_learn:start()
			end
			if error_id==401 then
			   dz_learn:regenerate()
			end
			if error_id==402 then  --内力不足
			  dz_learn:rest()
			end
			if error_id==403 then  --内力转换精血 继续学习
			  dz_learn:start()
			end
	  end
	  dz_learn.rest=function()
	     local w
		  w=walk.new()
		  w.walkover=function()
			 local ss_rest=rest.new()
			 ss_rest.failure=function(id)
			    local f=function() w:go(308) end
				f_wait(f,10)
 			 end
			 ss_rest.wake=function(flag)
			     if flag==0 then
			          print("睡觉太频繁了!")
			          local ch=hp.new()
			          ch.checkover=function()
			             if ch.pot<20 then
				           --process.xc()
						   -- print("xc")
						   --CallBack()
							TH_Status_Check(CallBack)
						 else
			               local w1
			                w1=walk.new()
			                w1.walkover=function()
							  ---  睡觉太频繁 打坐 start
							  local f
							  f=function()
							    local b
								b=busy.new()
								b.Next=function()
								  dz_learn:go()
								end
								b:check()
							  end
							  world.Send("yun regenerate")
							  x=xiulian.new()
							  x.fail=function(id)
								if id==202 then --safe room 没有办法打坐
								  local w
		                           w=walk.new()
		                          w.walkover=function()
			                        x:dazuo()
		                          end
		                          local _R
                                  _R=Room.new()
								  _R.CatchEnd=function()
                                    local count,roomno=Locate(_R)
		                            print(roomno[1])
		                            local r=nearest_room(roomno)
	                                w:go(r)
	                               end
                                  _R:CatchStart()
								end
                              end
							  x.success=function(h)
							     dz_learn:go()
							  end
	                          x:dazuo()
	                          f_wait(f,30)
							  ---  睡觉太频繁 打坐 end
			                end
                            w1:go(142)
						 end
			          end
					ch:check()
				  else
					dz_learn:go()
				  end
			 end
			 ss_rest:sleep()
		  end
		  w:go(308)
	  end
	  dz_learn:go()  --ss go learn
end

local function tdh()
   package.loaded["tiandi"]=nil
   require "tiandi"
   local f=check_job(Job_Next("tdh"))
   xp:check()
   local _tdh={}
   _tdh=tiandi.new()
   local slow_back=world.GetVariable("tdh_slow_back") or true
   if slow_back==true then
       _tdh.is_wander=true
   end

   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _tdh.neili_upper=tonumber(neili_upper)
   end
    _tdh.shield=function()
	  --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""  --自定义
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="天地会" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
   end
   _tdh.fail=function(id)
     print(id)
	 if id==101 then
	  local b
	   b=busy.new()
	   b.Next=function()
         f()
	   end
	   b:check()
	 end
	 if id==102 then
	    world.Send("w")
	    local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   print("等待sec:",sec)
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
			 if sec>20 then
			   sec=sec-20
			 end
	        local f=function()
	           switch(process.tdh)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
              else
			    process.neigong3()
			  end
			end
			b:check()
		 else
		    process.tdh()
		 end
	    end
	    cd:start()
	 end
   end
   local cb=fight.new()
    cb.target=""
   local select_pfm=world.GetVariable("tdh_pfm")
   local pfm=world.GetVariable(select_pfm)
   --world.SetVariable("pfm",_pfm)
	pfm=string.gsub(pfm," @id","")
	cb.combat_alias=pfm
	local unarmed_pfm=world.GetVariable("unarmed_pfm")
	unarmed_pfm=string.gsub(unarmed_pfm," @id","")
	cb.unarmed_alias=unarmed_pfm

     local tdh_pfm_list=world.GetVariable("tdh_pfm_list") or ""
   if  tdh_pfm_list~=nil and  tdh_pfm_list~="" then
    -- print(cb.pfm_list)
	 cb.pfm_list=world.GetVariable(tdh_pfm_list)
	 -- print(cb.pfm_list," pfm_list")
   end
   _tdh.reset=function()
       local select_pfm=world.GetVariable("tdh_pfm")
	   local pfm=world.GetVariable(select_pfm)
	   pfm=string.gsub(pfm," @id","")
	   cb.combat_alias=pfm

	  local unarmed_pfm=world.GetVariable("unarmed_pfm")
	   unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm
	    local tdh_pfm_list=world.GetVariable("tdh_pfm_list") or ""
       if  tdh_pfm_list~=nil and  tdh_pfm_list~="" then
	     cb.pfm_list=world.GetVariable(tdh_pfm_list)
       end
   end
   _tdh.auto_pfm=function()
       local select_pfm=world.GetVariable("tdh_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的tdh_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		  cb.combat_alias=_pfm
		  cb:before_kill()
   end
   --id 更新
    _tdh.sure_shiwei=function()
	    local select_pfm=world.GetVariable("tdh_pfm")
        local pfm=world.GetVariable(select_pfm)
	    local unarmed_pfm=world.GetVariable("unarmed_pfm")
		local _pfm_items=Split(pfm,";")
		local _unarmed_pfm_items=Split(unarmed_pfm,";")
		if table.getn(_tdh.shiwei_list)==0 then
		    if _tdh.is_combat==false then
		     print("战斗结束检测?")
		     cb.check_time=5
	         cb:combat_check()
	         cb:resume_combat_check()
		   else
		     _tdh.shiwei_list={}
		     print("战斗结束")
		     print("开始恢复")
		     _tdh.fighting=false
		     shutdown()
		     _tdh:shiwei()
			 local cmd="get gold from corpse"
		     local b=busy.new()
		     b.interval=0.3
		     b.Next=function()
		      world.Execute(cmd)
			  _tdh:shield()
              _tdh:recover()
		     end
			 if cb.status=="大转" then
			    cmd="get gold from corpse;get hammer"
			     _tdh:reset()
			    b:jifa()
			 else
			    b:check()
			 end

		  end
		   return
		end
   end
   _tdh.combat=function()
	  print("战斗模块")

	  cb.damage=function(hp)
	     local damage=hp.max_qi*0.5

         if tonumber(hp.qi_percent)<=68 or hp.qi<damage then
		  print("吃大还丹")
		  world.Send("fu dahuan dan")
		 else
		   print(hp.qi_percent," >=60 or ",hp.qi," >= ",damage)

	     end
      end
	  cb.neili_lack=function()
	     world.Send("fu da huandan")
		 --print("flee")
		  --world.Send("unset wimpy")
		 --_tdh:flee()
	  end
	  cb.finish=function()
	     _tdh.shiwei_list={}
	     print("战斗结束")
		 print("开始恢复")
		 _tdh.fighting=false
		 shutdown()
		 _tdh:shiwei()
		 local cmd="get gold from corpse"
		 local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
		  world.Execute(cmd)
		 _tdh:shield()
         _tdh:recover()
		 end
		 if cb.status=="大转" then
		   cmd="get gold from corpse;get hammer"
		   _tdh:reset()
		   b:jifa()
		 else
		   b:check()
		 end
	  end
	  cb:start()
   end
   _tdh.test_combat=function()
	  cb.check_time=5
	  cb:combat_check()
	  cb:resume_combat_check()
   end
   _tdh.jobDone=function()
      xp:check()
      print("tdh 结束")
	  local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  local b=busy.new()
			  b.interval=0.3
			  b.Next=function()
			    level_up(f)
			  end
			  b:check()
		 else
		    --继续job
            print("继续")
			 local b=busy.new()
			  b.interval=0.3
			  b.Next=function()
			     f()
			  end
			  b:check()
		 end
	  end
	  h:check()
   end
   _tdh:Status_Check()
end

local _wd_last_ok=true

local function wd()
   package.loaded["wudang"]=nil
   require "wudang"
    local party=world.GetVariable("party") or ""
	local is_liandu=world.GetVariable("liandu") or ""
   local jb1,jb2=Job_Next("wd")
   xp:check()
   local _wd={}
   _wd=wudang.new()
   _wd.job_failure=function()
      _wd_last_ok=false
   end
   local select_pfm=world.GetVariable("wd_pfm")
	if select_pfm==nil then
      utils.msgbox ("你的wd_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
      return
   end
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
   _wd.difficulty=world.GetVariable("difficulty")
   _wd.playname=world.GetVariable("player_name")
   local blacklist=world.GetVariable("wd_blacklist") or ""
   if blacklist~=nil then
	  _wd.blacklist=blacklist
   end
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _wd.neili_upper=tonumber(neili_upper)
   end
   _wd.shield=function()
	  --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""  --自定义
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="武当" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
	  local party=world.GetVariable("party")
	  if party=="武当派" then
	     _wd:liuhe()
	  end
   end

   _wd.fail=function(id)
     --print("id:",id)
	 --print("_wd_last_ok:",_wd_last_ok)
	 if id==101 then
	   if _wd_last_ok==true then
	      print("最后一次成功,busy 15s")
	      local f=function()
		     _wd_last_ok=false
		     _wd:ask_job()
		  end
		  f_wait(f,15)
	   else
	   --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
	   end
	 end
	 if id==102 then

	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态"  then
			   sec=i[2]
			   break
			  end
			  if i[1]=="武当任务" then
			    sec=i[2]
			    local jt=jobtimes.new()
			    jt.checkover=function(jobname)
		         print("jobname :",jobname)
	             local _job_name=chinese_job_name(jobname)
		         local _job={}
		         if string.find(jb1,_job_name) then
		          _job=check_job(jb2)
		         else
			      _job=check_job(jb1)
		         end
	             local b
	             b=busy.new()
	             b.Next=function()
		          _job()
	             end
	             b:check()
			    end
	            jt:check()
				return
			    --break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
			 print(sec," 时间")
	        local f=function()
	           switch(process.wd)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.5
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()

              else
			    process.neigong3()
			  end
			end
			b:check()
		 else
		    process.wd()
		 end
	   end
	   cd:start()
	 end
   end
  local cb
  cb=fight.new()
  cb.escape=function()
      print("flee")
	  _wd:flee()
  end
  local wd_pfm_list=world.GetVariable("wd_pfm_list") or ""

  if wd_pfm_list~=nil and wd_pfm_list~="" then
	 cb.pfm_list=world.GetVariable(wd_pfm_list)
  end
   _wd.sure_enemy_skill=function() --确定敌人使用的技能
      print("*********************")
	  print(_wd.skills)

      local _pfm,_pfm_list=cb:po_enemy_skills(_wd.skills)
	  print("*********************")
	  if _pfm~=nil and _pfm_list~=nil then
	    print(_pfm," 使用的技能")
		print(_pfm_list," 使用的切换顺序")
	    cb.pfm_list=world.GetVariable(_pfm_list)
        local s_pfm=world.GetVariable(_pfm)
        world.SetVariable("pfm",s_pfm)
	  end
   end
    _wd.auto_pfm=function()
	   local select_pfm=world.GetVariable("wd_pfm")
	  local _pfm=world.GetVariable(select_pfm)
	  world.Execute(_pfm)
	  cb.combat_alias=_pfm
      cb:before_kill()
   end
   _wd.combat=function()
         print("战斗模块")
	  --shutdown()
	  cb.enemy_name=_wd.robber_name
      local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm
	   cb.pfm_list=string.gsub(cb.pfm_list,"@id","")
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
		  cb.run_flee=true
	      print("低于安全设置开始脱离战斗")
		  _wd:flee()
	     end
      end
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 _wd:flee()
	  end
	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
	     print("战斗结束1")
		 shutdown()
		 world.Send("unset wimpy")
		 world.Send("alias pfm hp")
		 world.Send("unwield jian")
		 world.Send("jiali 1")
		 world.Execute("get silver from corpse;get gold from corpse")
		 if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		 end
		 if _wd.win==true then
		    _wd:reward()
		 else
		    _wd:giveup()
		 end
	  end
	  cb:start(false)
   end
   _wd.sure_robber=function()
        local pfm=world.GetVariable("pfm")
	    local unarmed_pfm=world.GetVariable("unarmed_pfm")
		cb.fightcmd="kill ".._wd.robber_id
		cb.combat_alias=""
		cb.unarmed_alias=""
		cb.combat_alias=string.gsub(pfm,"@id",_wd.robber_id)
        cb.unarmed_alias=string.gsub(unarmed_pfm,"@id",_wd.robber_id)
		cb:reset()
   end
	_wd.robber_die=function()
         print("战斗结束2")

		 shutdown()
		 world.Send("alias pfm hp")
		 world.Send("unset wimpy")
		 world.Send("jiali 1")
		 local b=busy.new()
		 b.Next=function()

		   if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
		   	  end
		   end
		   if _wd.win==true then
			 local b=busy.new()
		     b.Next=function()
			    local delay_time=0.1
			   if cb.status=="大转" then
			       --world.Send("alias pfm hp")
				  -- world.Send("get hammer")
				   --world.Send("get falun")
			       delay_time=2
			   end
			   local f=function()
		          _wd:reward()
			   end
			   f_wait(f,delay_time)
			 end
			 b:check()
		   else
		      if cb.status=="大转" then
				 world.Send("alias pfm hp")
			     --world.Send("get hammer")
				 --world.Send("get falun")
			  end
		    _wd:giveup()
		   end
		 end
		 --if cb.status=="大转" then
		  b:jifa()
		 --else
		 -- b:check()
		 --end
   end
   	_wd.robber_die2=function()
         print("战斗结束3")
	     world.Send("unset wimpy")
		 shutdown()
		 world.Send("jiali 1")
		 local b=busy.new()
		 b.Next=function()
			world.Execute("get silver from corpse;get gold from corpse")
			 if party=="星宿派" and is_liandu=="自动" then
		        world.Send("get corpse")
			 end
		    if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			    world.Send("get "..weapon_item)
		   	  end
		    end
		   if _wd.win==true then
			 local b=busy.new()
		     b.Next=function()
				local delay_time=0.1
			    if cb.status=="大转" then
			      delay_time=2
				   --world.Send("alias pfm hp")
				    --world.Send("get hammer")
				    --world.Send("get falun")
			    end
		        local f=function()

		          _wd:reward()
			    end
			    f_wait(f,delay_time)
			 end
			 b:check()
		   else
			  if cb.status=="大转" then
			      world.Send("alias pfm hp")
			     --world.Send("get hammer")
				 --world.Send("get falun")
			  end
		    _wd:giveup()
		   end
		 end
		 --if cb.status=="大转" then
		  b:jifa()
		--else
		--  b:check()
		--end
   end
   _wd.jobDone=function()
      print("wd 结束")
	  _wd_last_ok=true
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	      world.Send("jifa")
		 --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 受伤程度:"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")".."\r\n")
		 --[[if h.qi_percent<80 then
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "red", "black") -- yellow on white
         elseif h.qi_percent<90 then
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "yellow", "black") -- yellow on white
		 else
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "white", "black") -- yellow on white
		 end
		print("潜能:",h.pot," max:",h.max_pot)]]
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  local _job
			   _job=check_job(jb1)
              assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			  if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
			    local ld=liandu.new()
				ld.liandu_end=function()
				   level_up(_job)
				end
				ld:liandu()
			 else
			   level_up(_job)
		     end
		 else
		    --继续job
            print("继续")
			local _job
			_job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")

			if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
		        local ld=liandu.new()
				ld.liandu_end=function()
				   _job()
				end
				ld:liandu()
			else
			   _job()
		    end
		 end
	  end
	  h:check()
   end
   _wd:Status_Check()
end

function hx()
  package.loaded["huxi"]=nil
  require "huxi"
  local _hx=huxi.new()
  local wx=world.GetVariable("wuxing")
  print(wx)
  _hx.wuxing=wx
  _hx:start()
end

local function tx()
   package.loaded["touxue"]=nil
   require "touxue"
  local f=check_job(Job_Next("tx"))
   local _tx=touxue.new()
    _tx.shield=function()
	 -- local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""  --自定义
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="慕容偷学" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
   end
   _tx.fail=function(id)
	 if id==101 then
		local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find("tx",_job_name) then
		       _job=f
		  else
			   _job=check_job("tx")
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(process.tx)
	        end
	        f_wait(f,sec)
			world.Send("unset 积蓄")
		    process.neigong3()
			--process.dzxy()
		 else
		    process.tx()
		 end
	   end
	   cd:start()
	 end
   end
     local cb
      cb=fight.new()
      cb.escape=function()
        print("flee")
	     _tx:flee()
      end
    _tx.combat=function()
	  print("战斗模块")
	  --shutdown()
	  --local jue
	  --jue=murong_jue.new()

	  cb.check_time=9999
	  cb.damage=function(hp)
          if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  cb.check_time=10
		  cb:combat_check()
		  _tx:flee()
	     end
      end

	  cb.neili_lack=function()
	     world.Send("fu wan")
		 print("flee")
		 cb.check_time=10
		 cb:combat_check()
		 _tx:flee()
	  end
	  cb.combat_alias="yun shenyuan"
	  cb.finish=function()
		 print("战斗结束")
		 --cb:close_combat_check()
		 world.Send("yield no")
		 shutdown()
		 if _tx.success==true then
		    _tx:reward()
		 else
		    _tx:giveup()
		 end
	  end
       cb:start()
   end
   _tx.combat_check=function()
      cb.check_time=10
	  cb:combat_check()
   end
    _tx.jobDone=function()
	  world.Send("yield no")
      print("tx 结束")
	  --world.Send("ask fu about 俸禄")
	 local pot_overflow=world.GetVariable("pot_overflow")
	  local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
	     if h.pot>h.max_pot-pot_overflow then
             level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
            f()
		 end
	  end
	  h:check()
   end
   _tx:Status_Check()
end

local function sm()
  package.loaded["shoumu"]=nil --桃花岛守墓
  require "shoumu" --桃花岛守墓
	local jb1,jb2=Job_Next("sm")
	xp:check()
   local select_pfm=world.GetVariable("sm_pfm")
   local _pfm=world.GetVariable(select_pfm)
    world.SetVariable("pfm",_pfm)
   local _sm=shoumu.new()
   _sm.fail=function(id)
	 if id==101 or id==103 then
       local b
	   b=busy.new()
	   b.Next=function()
		  local _job
		  _job=check_job(jb1)
		  _job()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(process.sm)
	        end
	        f_wait(f,sec)
			local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		 else
		    process.sm()
		 end
	   end
	   cd:start()
	 end
	 if id==201 then  --白天

         local jt=jobtimes.new()
	     jt.checkover=function(jobname)

	      local _job_name=chinese_job_name(jobname)
		  -- print("jobname :",jobname," j ",jb1," _job_name:",_job_name)
		  local _job={}
		  if string.find("sm",_job_name) or not string.find(jb1,_job_name)  then
		      _job=check_job(jb1)
		  else
			   _job=check_job(jb2)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()

     end
	end
	  local cb
      cb=fight.new()
      cb.escape=function()
        print("flee")
	    _sm:flee()
      end
    _sm.combat=function()
        local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  _sm:flee()
	     end
      end
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 _sm:flee()
	  end
	  cb.finish=function()
	     print("战斗结束1")
		 shutdown()
		 world.Send("jiali 1")
		 if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		 end
		 _sm:gem()
	  end
	  cb:start()
   end
   _sm.zei_die=function()
        print("战斗结束2")
		 shutdown()
		 world.Send("jiali 1")
		 if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		 end
		 _sm:gem()
   end
    _sm.jobDone=function()
	 local pot_overflow=world.GetVariable("pot_overflow")
	  local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
	     if h.pot>h.max_pot-pot_overflow then
		     local _job
		     _job=check_job(jb1)
             level_up(_job)
		 else
		    --继续job
            print("继续")
             local _job
		    _job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
		     _job()
		 end
	  end
	  h:check()
   end
   _sm:get_time()--获得时间
end

local function ts()
   local f=check_job(Job_Next("ts"))
	xp:check()
   local select_pfm=world.GetVariable("ts_pfm")
   local _pfm=world.GetVariable(select_pfm)
    world.SetVariable("pfm",_pfm)
   local _ts=taishan.new()
   _ts.id=world.GetVariable("player_id") or ""
   _ts.shield=function()
      local shield=world.GetVariable("shield")
      world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  world.Execute(sp_exert)
   end
   _ts.fail=function(id)
	 if id==101 or id==103 then
       local b
	   b=busy.new()
	   b.Next=function()
		  local _job
		  _job=check_job(jb1)
		  _job()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(process.ts)
	        end
	        f_wait(f,sec)
			local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		 else
		    process.ts()
		 end
	   end
	   cd:start()
	 end
	end
	  local cb
      cb=fight.new()
      cb.escape=function()
        print("flee")
	    _ts:flee()
      end
    _ts.combat=function()
        local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm
	   cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  _ts:flee()
	     end
      end
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 _ts:flee()
	  end
	  cb.finish=function()
	     print("战斗结束1")
		 shutdown()
		 _ts.jobDone()
	  end
	  cb:start()
   end
   _ts.pantu_die=function()
        print("战斗结束2")
		 shutdown()
		 world.Send("jiali 1")
		 world.Execute("get silver from corpse;get gold from corpse")
		 --world.Send("ado get silver from corpse|get gold from corpse")
		 if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		 end
		 _ts:combat_end()
   end
    _ts.jobDone=function()
      xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end
   _ts:Status_Check()
end


local function xl()
   package.loaded["xunluo"]=nil
   require "xunluo" --明教巡逻
   local f=check_job(Job_Next("xl"))
   xp:check()
   local _xl={}
   _xl=xunluo.new()
   _xl.xiulian=world.GetVariable("xl_xiulian") or "false"
   local select_pfm=world.GetVariable("xl_pfm")
	if select_pfm==nil then
      utils.msgbox ("你的xs_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
      return
   end
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
    local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _xl.neili_upper=tonumber(neili_upper)
   end
   local party=""
   _xl.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)

	    local sp_exert=world.GetVariable("sp_exert") or ""  --自定义
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="明教巡逻" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
   end
   local player_name=world.GetVariable("player_name")
   _xl.playername=player_name
   _xl.fail=function(id)
     print("id:",id)
	 if id==101 then
        f()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f=function()
	           switch(process.xl)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.5
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			 elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    process.xl()
		 end
	   end
	   cd:start()
	 end
   end
   local cb
   _xl.attacker_escape=function()
      print("战斗结束,战斗状态检测下！")
      cb:resume_combat_check()
   end
   _xl.combat=function()
	  print("战斗模块")
	   cb=fight.new()
	  cb.escape=function()
        print("flee")
	    _xl:flee()
      end
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","attacker")
	   cb.fightcmd="kill attacker"
       cb.combat_alias=pfm
	   -- 新增变量
	   local xl_pfm_list=world.GetVariable("xl_pfm_list") or ""
	   if xl_pfm_list~=nil and xl_pfm_list~="" then
	      local pfm_list=world.GetVariable(xl_pfm_list) or ""
		  cb.pfm_list=string.gsub(pfm_list,"@id","attacker")
	   end

	   --
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id","attacker")
	   cb.unarmed_alias=unarmed_pfm
	   cb.neili_lack=function()
	     world.Send("fu wan")
		 --print("flee")
		 --world.Send("unset wimpy")
		 --_xl:flee()
	  end
	  cb.finish=function()
	     sj.open_triggerGroup()
		 print("战斗结束")
		 world.Send("unset wimpy")
		 shutdown()
		 world.Send("jiali 1")
		 local b=busy.new()
		 b.Next=function()
			if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			    world.Send("get "..weapon_item)
		   	  end
		    end
		   _xl:recover2()
		 end
		 b:check()
	  end
	  sj.close_triggerGroup()
	  cb:start()
   end
   _xl.jobDone=function()
      print("xl 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end
   _xl:Status_Check()
end


  --地图
config = {
  -- assorted colours
  BACKGROUND_COLOUR       = { name = "Background",        colour =  world.ColourNameToRGB("lightseagreen"), },
  ROOM_COLOUR             = { name = "Room",              colour =  world.ColourNameToRGB("cyan"), },
  EXIT_COLOUR             = { name = "Exit",              colour =  world.ColourNameToRGB("darkgreen"), },
  EXIT_COLOUR_UP_DOWN     = { name = "Exit up/down",      colour =  world.ColourNameToRGB("darkmagenta"), },
  EXIT_COLOUR_IN_OUT      = { name = "Exit in/out",       colour =  world.ColourNameToRGB("#3775E8"), },
  UNKNOWN_ROOM_COLOUR     = { name = "Unknown room",      colour =  world.ColourNameToRGB("#00CACA"), },
  MAPPER_NOTE_COLOUR      = { name = "Messages",          colour =  world.ColourNameToRGB("lightgreen"),},

  ROOM_NAME_TEXT          = { name = "Room name text",    colour = world.ColourNameToRGB("#BEF3F1"), },
  ROOM_NAME_FILL          = { name = "Room name fill",    colour = world.ColourNameToRGB("#105653"), },
  ROOM_NAME_BORDER        = { name = "Room name box",     colour = world.ColourNameToRGB("black"), },

  AREA_NAME_TEXT          = { name = "Area name text",    colour = world.ColourNameToRGB("#BEF3F1"),},
  AREA_NAME_FILL          = { name = "Area name fill",    colour = world.ColourNameToRGB("#105653"), },
  AREA_NAME_BORDER        = { name = "Area name box",     colour = world.ColourNameToRGB("black"), },

  FONT = { name =  get_preferred_font {"Dina",  "宋体",  "Fixedsys", "Courier", "Sylfaen",} ,
           size = 8
         } ,

  -- size of map window
  WINDOW = { width = 250, height = 250 },

  -- how far from where we are standing to draw (rooms)
  SCAN = { depth = 30 },

  -- speedwalk delay
  DELAY = { time = 0.3 },

  -- how many seconds to show "recent visit" lines (default 3 minutes)
  LAST_VISIT_TIME = { time = 60 * 3 },
}

function get_room (uid)
   --print(uid," 房间号")
  local room = load_room_from_database (uid)
  --local room={}
 -- if not room then
 --    return nil  -- room does not exist
 -- end -- if

  --room.hovermessage ="test"  -- for hovering the mouse

  -- desired colours

  room.bordercolour = ColourNameToRGB "lightseagreen"
  room.borderpen = 0 -- solid
  room.borderpenwidth = 1
  room.fillcolour = ColourNameToRGB "green"
  room.fillbrush = 0 -- solid

  -- obviously you would look these up in practice
  --room.area = "扬州城"
  --room.exits = { n = 21001, s = 21002, se = 21003, w=21004 }
  return room
end -- function
function room_click(uid, flags)
    local room={}
	room=get_room(uid)
	--ColourNote ("red", "yellow", "Hello there ","white", "green", "everyone")
	ColourNote ("red", "yellow","房间号:"..uid,"darkgreen", "yellow", " 房间名称:"..room.hovermessage)
end

function draw_special_direction(dir)
	local al=alias.new() --从alias类表中获取特殊路径
	return al:draw_special_direction(dir)
end

function start_speedwalk(uid)
  if not mapper.check_connected () then
    return
  end
   print("go",uid)
   print(type (uid))
   local w=walk.new()
   local uid=tonumber(uid)
   w:go(uid)
end

mapper.init { config = config, get_room = get_room, show_help = nil, room_click =room_click,start_speedwalk=start_speedwalk,draw_special_direction=draw_special_direction}
--mapper.mapprint (string.format ("MUSHclient mapper installed, version %0.1f,mapper.show()", mapper.VERSION))
function Create_Map(uid)
   mapper.draw (uid)
end

--地图显示当前所在位置
function Map_Here()
    if mapper.hidden==true then mapper.show() end
    local _R
   _R=Room.new()
   _R.CatchEnd=function()
      local count,roomno,opentime=Locate(_R)
	  if count>=1 then

	     Create_Map(roomno[1])--画出当前地图
	  end
   end
   _R:CatchStart()
end



local function jy()
   package.loaded["jiuyuan"]=nil
   require "jiuyuan" --救援任务
   local jb1,jb2=Job_Next("jy")
   xp:check()
   local _jy={}
   _jy=jiuyuan.new()
	_jy.shield=function()
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="救援" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
   local select_pfm=world.GetVariable("jy_pfm")
	if select_pfm==nil then
      utils.msgbox ("你的jy_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
      return
   end
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)

   _jy.player_id=world.GetVariable("player_id")

   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _jy.neili_upper=tonumber(neili_upper)
   end
   _jy.fail=function(id)
     print("id:",id)
	 if id==101 then

	   --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  --print(_job_name," ",jb1," ",jb2)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()

	 end
	 if id==102 then
	    print("内功修炼")
		world.Send("unset 积蓄")
	    local f=function()
	      switch(process.jy)
	    end
	    f_wait(f,60)
		local b=busy.new()
		b.interval=0.3
		b.Next=function()
		    local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		end
		b:check()
	 end
   end
  local cb
  cb=fight.new()
  local jy_pfm_list=world.GetVariable("jy_pfm_list") or ""

  if jy_pfm_list~=nil and jy_pfm_list~="" then
	 cb.pfm_list=world.GetVariable(jy_pfm_list)
  end

   _jy.combat=function()
         print("战斗模块")

      local pfm=world.GetVariable("pfm")
	   _jy:jiaotu_die()
       pfm=string.gsub(pfm,"@id",string.lower(_jy.player_id).."'s jiaotu")
       cb.combat_alias=pfm
	   cb.before_kill()
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id",string.lower(_jy.player_id).."'s jiaotu")
	   cb.unarmed_alias=unarmed_pfm
	   cb.pfm_list=string.gsub(cb.pfm_list,"@id",string.lower(_jy.player_id).."'s jiaotu")
	  cb.damage=function(hp)
	     if hp.qi_percent<=50 then
		    world.Send("fu chantui yao")
		 end
	  end

	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
      cb.finish=function()
	     print("战斗结束1")
		 local b=busy.new()
		 b.interval=0.5
		 b.Next=function()
		   world.Send("get silver from corpse")
		   if _jy.failure==true then
		     _jy:jobDone()
		   else
		     _jy:recover()
		   end
		 end
		 b:check()
	  end
      cb:start()
   end

   _jy.jobDone=function()
      print("jy 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		 world.AppendToNotepad (WorldName().."_少林护送任务:",os.date()..": 受伤程度:"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")".."\r\n")
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  local _job
			   _job=check_job(jb1)
			   assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
              level_up(_job)
		 else
		    --继续job
            print("继续")
			local _job
			_job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			_job()
		 end
	  end
	  h:check()
   end

   _jy:Status_Check()
end

local function qz_kjmg() --抗击蒙古
   package.loaded["kjmg"]=nil
   require "kjmg"
    local _kjmg=kjmg.new()
	 local jb1,jb2=Job_Next("kjmg")
	 local kjmg_safety_percent=world.GetVariable("kjmg_safety_percent") or 0.6
	xp:check()
	_kjmg.smy_safety_percent=kjmg_safety_percent
   local kjmg_wave=world.GetVariable("kjmg_wave") or 6
   _kjmg.wave_set=tonumber(kjmg_wave)
   local select_pfm=world.GetVariable("kjmg_pfm")
   _kjmg.shield=function()
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="抗击蒙古" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
   local cb=fight.new()
    local pfm=world.GetVariable(select_pfm)
	cb.combat_alias=pfm
    local unarmed_pfm=world.GetVariable("unarmed_pfm")
	unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	cb.unarmed_alias=unarmed_pfm
	  local kjmg_pfm_list=world.GetVariable("kjmg_pfm_list") or ""

  if kjmg_pfm_list~=nil and kjmg_pfm_list~="" then
	 cb.pfm_list=world.GetVariable(kjmg_pfm_list)
  end
    _kjmg.get_weapon=function()
	    local weapon_id=world.GetVariable("kjmg_weapon_id") or ""
		if weapon_id~=nil then
		   world.Send("get "..weapon_id)
		   world.Send("wield "..weapon_id)
		end
	end
	_kjmg.auto_pfm=function()
	   cb.combat_alias=pfm
	   world.Send("alias pfm "..pfm)
	end

	_kjmg.fail=function(id)
     print("id:",id)
	 if id==101 then

	   --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  --print(_job_name," ",jb1," ",jb2)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()

	 end
	 if id==102 then
	   local b=busy.new()
	   b.Next=function()
	    --kjmg:get_weapon()
		_kjmg:Status_Check()
	   end
	   b:check()
	 end
	 if id==201 then
	   	local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   print("等待sec:",sec)
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f=function()
	           switch(process.kjmg)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			 elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    Weapon_Check(process.kjmg)
		 end
	   end
	   cd:start()
	 end
   end
	_kjmg.jobDone=function()
       xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  local _job
			   _job=check_job(jb1)
              assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			  if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
			    local ld=liandu.new()
				ld.liandu_end=function()
				   level_up(_job)
				end
				ld:liandu()
			 else
			   level_up(_job)
		     end
		 else
		    --继续job
            print("继续")
			local _job
			_job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")

			if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
		        local ld=liandu.new()
				ld.liandu_end=function()
				   _job()
				end
				ld:liandu()
			else
			   _job()
		    end
		 end
	  end
	  h:check()
   end
    _kjmg.combat=function()
	   print("战斗模块")
	  cb.current_alias=cb.combat_alias

	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.danger_skill=function()
	  end
      cb.finish=function()
	   local b=busy.new()
	   b.Next=function()
	    --kjmg:get_weapon()
		_kjmg:Status_Check()
	   end
	   b:check()
	  end
      cb:start()
   end
    _kjmg.target=function(id)
       cb.target=id
	end
	_kjmg.reset=function(id)
	   cb.target=id
	   cb:reset()
	end
   local work=function()
    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
   end
	 local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			  if i[1]=="抗敌蒙古入侵" then
			    sec=i[2]
			    --直接做下个任务
				work()
				return
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(function() _kjmg:Status_Check() end)
	        end
	        f_wait(f,sec)
			local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		 else
		    _kjmg:Status_Check()
		 end
	   end
	   cd:start()
end

local function smy()
   package.loaded["songmoya"]=nil
   require "songmoya"
    local smy=songmoya.new()
	 local jb1,jb2=Job_Next("smy")
	 local smy_safety_percent=world.GetVariable("smy_safety_percent") or 0.6
	xp:check()
	smy.smy_safety_percent=smy_safety_percent
   local smy_wave=world.GetVariable("smy_wave") or 13
   smy.wave_set=tonumber(smy_wave)
   local select_pfm=world.GetVariable("smy_pfm")
   smy.shield=function()
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="颂摩崖" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
   local cb=fight.new()
    local pfm=world.GetVariable(select_pfm)
	cb.combat_alias=pfm
    local unarmed_pfm=world.GetVariable("unarmed_pfm")
	unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	cb.unarmed_alias=unarmed_pfm
	  local smy_pfm_list=world.GetVariable("smy_pfm_list") or ""

  if smy_pfm_list~=nil and smy_pfm_list~="" then
	 cb.pfm_list=world.GetVariable(smy_pfm_list)
  end
    smy.get_weapon=function()
	    local weapon_id=world.GetVariable("smy_weapon_id") or ""
		if weapon_id~=nil then
		   world.Send("get "..weapon_id)
		   world.Send("wield "..weapon_id)
		end
	end
	smy.auto_pfm=function()
	   cb.combat_alias=pfm
	   world.Send("alias pfm "..pfm)
	end

	smy.fail=function(id)
     print("id:",id)
	 if id==101 then

	   --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  --print(_job_name," ",jb1," ",jb2)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()

	 end
	 if id==102 then
	   local b=busy.new()
	   b.Next=function()
	    smy:get_weapon()
		smy:Status_Check()
	   end
	   b:check()
	 end
	 if id==201 then
	   	local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   print("等待sec:",sec)
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f=function()
	           switch(process.smy)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			 elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    Weapon_Check(process.smy)
		 end
	   end
	   cd:start()
	 end
   end
	smy.jobDone=function()
       xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  local _job
			   _job=check_job(jb1)
              assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			  if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
			    local ld=liandu.new()
				ld.liandu_end=function()
				   level_up(_job)
				end
				ld:liandu()
			 else
			   level_up(_job)
		     end
		 else
		    --继续job
            print("继续")
			local _job
			_job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")

			if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
		        local ld=liandu.new()
				ld.liandu_end=function()
				   _job()
				end
				ld:liandu()
			else
			   _job()
		    end
		 end
	  end
	  h:check()
   end
    smy.combat=function()
	  cb.current_alias=cb.combat_alias
         print("战斗模块")
	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.danger_skill=function()
	  end
      cb.finish=function()
	   local b=busy.new()
	   b.Next=function()
	    smy:get_weapon()
		smy:Status_Check()
	   end
	   b:check()
	  end
      cb:start()
   end
    smy.target=function(id)
       cb.target=id
	end
	smy.reset=function(id)
	   cb.target=id
	   cb:reset()
	end
   local work=function()
    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
   end
	 local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			  if i[1]=="颂摩崖任务倒计时" then
			    sec=i[2]
			    --直接做下个任务
				work()
				return
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(function() smy:Status_Check() end)
	        end
	        f_wait(f,sec)
			local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		 else
		    smy:Status_Check()
		 end
	   end
	   cd:start()
end

local function xxbug()
   package.loaded["zhuachong"]=nil
   require "zhuachong"
   local f=check_job(Job_Next("xxbug"))
	xp:check()
   local select_pfm=world.GetVariable("xxbug_pfm")
   local _pfm=world.GetVariable(select_pfm)
    world.SetVariable("pfm",_pfm)
   local _xxbug=zhuachong.new()
   local party=world.GetVariable("party")
   local is_liandu=world.GetVariable("liandu")
   local t1=os.time()
   local int1= os.difftime(t1,liandu.liandu_time)
   print("离上次炼毒时间间隔:",int1)
   if int1<=600 then --十分钟 炼毒
      is_liandu=""
   end
   _xxbug.liandu=is_liandu
   _xxbug.shield=function()
      local shield=world.GetVariable("shield")
      world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  world.Execute(sp_exert)
   end
   _xxbug.fail=function(id)
	 if id==101 then
       local b
	   b=busy.new()
	   b.Next=function()
		  local _job
		  _job=check_job(Job_Next("xxbug"))
		  _job()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(process.xxbug)
	        end
	        f_wait(f,sec)
			local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		 else
		    process.xxbug()
		 end
	   end
	   cd:start()
	 end
	end
	  local cb
      cb=fight.new()
    _xxbug.combat=function()
        local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm
	   cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  _xxbug:flee()
	     end
      end
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 _xxbug:flee()
	  end
	  cb.finish=function()
	     world.Send("unset wimpy")
	     print("战斗结束1")
		 shutdown()
		 _xxbug:cbug()
	  end
	  cb:start()
   end

    _xxbug.jobDone=function()
      xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")

		 if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			--星宿自动炼毒
		     if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
			    local ld=liandu.new()
				ld.liandu_end=function()
				   level_up(f)
				end
				ld:liandu()
			 else
			   level_up(f)
		     end
		 else
		    --继续job
            print("继续")
			--星宿自动炼毒
		    if party=="星宿派" and is_liandu=="自动" then
			     package.loaded["liandu"]=nil
			    require "liandu"
		        local ld=liandu.new()
				ld.liandu_end=function()
				   f()
				end
				ld:liandu()
			else
			    print("继续")
			    assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			    f()
		    end
		 end
	  end
	  h:check()
   end
   _xxbug:Status_Check()
end

local function qj()
   package.loaded["qiangjie"]=nil
   require "qiangjie"
 -- local f=Job_Next("qj")
   local jb1,jb2=Job_Next("qj")
   xp:check()
   local _qj=qiangjie.new()
   local select_pfm=world.GetVariable("qj_pfm")
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _qj.neili_upper=tonumber(neili_upper)
   end
   	_qj.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="星宿抢劫" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end

   _qj.fail=function(id)
     --print("id:",id)
	 if id==101 then
	   gb_busy=true
       local b
	   b=busy.new()
	   b.Next=function()
		 local _job=check_job(jb1)
		 _job()
	   end
	   b:check()
	 end
	 if id==102 then
	     local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  print("_job_name",_job_name)
		  print("job1",jb1)
		  print("job2",jb2)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       print("zuo",jb2)
		       _job=check_job(jb2)
		  else
		      print("zuo",jb1)
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
	 end
   end
    local cb

    _qj.combat=function()

       print("战斗模块")
	   cb=fight.new()
	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_qj.id)
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id",_qj.id)
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  _qj:flee()
	     end
      end
	  cb.no_pfm=function()

		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("战斗结束")
		  world.Send("unset wimpy")
		   shutdown()
		  local b=busy.new()
		  b.Next=function()
		     print("get 梨花针")
		     world.Send("get zhen")
            _qj:recover()
		  end
		  b:check()
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		 _qj:flee()
	  end
	  cb:start()
   end
   _qj.biaoshi_escape=function()
      print("战斗结束,战斗状态检测下！")
	  cb.check_time=5
	  --cb:combat_check()
	  cb:resume_combat_check()
   end
    _qj.jobDone=function()
      print("qj 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			    local _job=check_job(jb1)

			   level_up(_job)
		 else
		    --继续job
            print("继续")
			--assert (type (jb1) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			  local _job=check_job(jb1)
			  _job()
		 end
	  end
	  h:check()
   end
   _qj:Status_Check()
end

local function qz_caiyao()
      package.loaded["caiyao"]=nil
    require "caiyao"
   local f=check_job(Job_Next("caiyao"))
   local _cy=caiyao.new()
   _cy.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="全真采药" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
	local select_pfm=world.GetVariable("cy_pfm")
    local _pfm=world.GetVariable(select_pfm)
	world.SetVariable("pfm",_pfm)
	_cy.combat=function()

       print("战斗模块")
	   cb=fight.new()
	   cb.check_time=2
	   local pfm=world.GetVariable("pfm")
	   --pfm=string.gsub(pfm,"@id",_qj.id)
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	   -- pfm=string.gsub(pfm,"@id",_qj.id)
	   cb.unarmed_alias=unarmed_pfm

	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
          print("战斗结束")
		  world.Send("unset wimpy")
		   shutdown()
		  local b=busy.new()
		  b.Next=function()
		     _cy:recover()
		  end
		  b:check()
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		 _cy:flee()
	  end
	  cb:before_kill()
	  cb:start()
   end
   _cy.jobDone=function()
      local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end
   _cy:Status_Check()
end

local function kc()
   local f=check_job(Job_Next("kc"))
   local _kc=kanchai.new()
   _kc.jobDone=function()
      local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end
    _kc.fail=function(id)

	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(process.kc)
	        end
	        f_wait(f,sec)
			local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		 else
		    process.kc()
		 end
	   end
	   cd:start()
	 end
	end
   _kc:ask_lu()
end

local function qqllyu()
   local f=check_job(Job_Next("qqll"))
   local _ql=qqll.new()
   local leitai=tonumber(world.GetVariable("qqll_leitai")) or 153
	world.SetVariable("qqll_leitai",leitai)
   	qqll.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)

	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="七巧玲珑" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
   qqll.jobDone=function()
      print("qqll jobDone")
	  local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end
   _ql:Player_Status_Check()
end

local function oyk()
   local f=check_job(Job_Next("oyk"))
	xp:check()
   local select_pfm=world.GetVariable("oyk_pfm")
   local _pfm=world.GetVariable(select_pfm)
    world.SetVariable("pfm",_pfm)
   local _oyk=ouyangke.new()

   _oyk.shield=function()
      local shield=world.GetVariable("shield")
      world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  world.Execute(sp_exert)
   end
   _oyk.fail=function(id)
	 if id==101 then
       local b
	   b=busy.new()
	   b.Next=function()
		  local _job
		  _job=check_job(Job_Next("oyk"))
		  _job()
	   end
	   b:check()
	 end
	 if id==102 then
	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(process.oyk)
	        end
	        f_wait(f,sec)
			local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		 else
		    process.oyk()
		 end
	   end
	   cd:start()
	 end
	end
	  local cb
      cb=fight.new()
    _oyk.combat=function()
        local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm
	   cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
	      print("低于安全设置开始脱离战斗")
		  _oyk:flee()
	     end
      end
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 _oyk:flee()
	  end
	  cb.finish=function()
	     world.Send("unset wimpy")
	     print("战斗结束1")
		 shutdown()
         _oyk:giveup()
	  end
	  cb:start()
   end

    _oyk.jobDone=function()
      xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  level_up(f)
		 else
		    --继续job
            print("继续")
			assert (type (f) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			f()
		 end
	  end
	  h:check()
   end
   _oyk:Status_Check()
end

local function slian()
   require "lian"
   print("开始练习")
     local f=function()
	     process.lian()
	 end
	 local busy_lian={}
	  busy_lian=lian.new()
	  busy_lian.count=50
	  busy_lian.vip=false

	  local lian_skills=world.GetVariable("skills_lian")
	  local _skills=Split(lian_skills,"|")
	  for _,i in ipairs(_skills) do
	    local item={}
		local _item=Split(i,"&")
	    item.skill_name=_item[1]
	    item.skill_id=_item[2]
		busy_lian:addskill(item)
	  end

	  busy_lian.AfterFinish=function() process.neigong3() end
	  busy_lian.start_failure=function(error_id)
           print(error_id," lian_error_id")
		   if error_id==1 then
               busy_lian:neili_lack(f)
			end
			if error_id==402 or error_id==201 then  --内力不足
			    busy_lian:neili_lack(f)
			end
			if error_id==403 then  --内力转换精血 继续学习
			   busy_lian:start()
			end
			if error_id==401 then
			   busy_lian:refresh()
			end
			if error_id==202 then
			   world.Send("wield jian")
			   busy_lian.weapon="jian"
			   busy_lian:start()
			end
	  end
	  busy_lian.rest=function()
		 busy_lian:neili_lack(f)
	  end
	  busy_lian:go()  --ss go learn
end

local function fullskills()
   local w=walk.new()
   w.walkover=function()
      world.Send("qn_qu 10000")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)你从银行里取出.*点潜能。$|^(> |)你存的潜能不够取。$",5)
	    if l==nil then
		   process.fullskills()
		  return
		end
		if string.find(l,"你存的潜能不够取") then
		    print("潜能不够")
		   return
		end
		if string.find(l,"你从银行里取出") then
		  local f=function(status)
		    if status==true then
		       print("领悟满了!")
			else
	           process.fullskills()
			end
	      end
	      process.lingwu(f,false)
		  return
		end

	  end)
   end
   w:go(4067)
end

local function jiflood()
   world.Execute("#10 ji flood;yun jingli")
   wait.make(function()

	  local l,w=wait.regexp("^(> |)你长长地舒了一口气。$|^(> |)你的内力不足，无法继续练下去。$|(> |)你想进一步提高玄铁剑法的修为，要进一步去领悟了。$|^(> |)你想进一步提高玄铁剑法的修为，要换一把剑了。$|^(> |)你对着山洪拳打脚踢了一阵，感到劲疲力尽。$",5)
	  if l==nil then
	     jiflood()
	     return
	  end
	  if string.find(l,"你长长地舒了一口气") then
	     wait.time(0.5)
		 jiflood()
	     return
	  end
	  if string.find(l,"你的内力不足") then
		 lianxuantie()
	     return
	  end
	  if string.find(l,"你想进一步提高玄铁剑法的修为，要换一把剑了") then
	     local sp=special_item.new()
		  sp.cooldown=function()
		    print("卸载武器")
			  world.Send("wield chang jian")
			  wait.time(0.5)
		     jiflood()
		  end
		  sp:unwield_all()
	     return
	  end
	  if string.find(l,"你想进一步提高玄铁剑法的修为，要进一步去领悟了") then

		  local sp=special_item.new()
		  sp.cooldown=function()
		    print("卸载武器")
			  world.Send("wield mu jian")
			  wait.time(0.5)
		      jiflood()
		  end
		  sp:unwield_all()
	     return
	  end
	  if string.find(l,"你对着山洪拳打脚踢了一阵，感到劲疲力尽") then
	     world.Send("wield xuantie jian")
		 world.Send("wield chang jian")
		 world.Send("wield mu jian")
		 wait.time(0.5)
		 jiflood()
	     return
	  end
   end)
end

function lianxuantie()
    local x
   x=xiulian.new()
   x.min_amount=100
   x.safe_qi=200
   x.fail=function(id)
      print(id)
	  if id==1 then
	     --正循环打坐
		 print("正循环打坐")
		 Send("yun recover")
		 x:dazuo()
	  end
	  if id==201 then
	     local f=function()
	      world.Send("yun regenerate")
		  x:dazuo()
         end
		 f_wait(f,3)

	  end

   end
   x.success=function(h)
     -- world.Send("yun qimen")
	  if h.neili<=h.max_qi*1.5 then
	     x:dazuo()
	  else
	     world.Send("yun qi")
	     jiflood()
	  end
   end
   x:dazuo()

end

local function pubu()
   local w=walk.new()
   w.walkover=function()
      world.Send("tiao pubu")
	  lianxuantie()
   end
   w:go(1500)
end

local function xuantie()
    package.loaded["lingwu"]=nil
    require "lingwu"

   print("玄铁剑法需要 2000点内力:120以下需要玄铁剑,160 以下需要长剑 古墓活死人墓出品,160以上需要木剑")
   --检查玄铁剑法等级
   local lw=lingwu.new()
  lw.exps=tonumber(world.GetVariable("exps")) or 0
   lw.get_skills_end=function()
      level_xuantie=lw:get_skill("xuantie-jianfa")
	   print(level_xuantie)
	    local equip={}
		local item=""

       if level_xuantie<=120 then
	       item="<获取>火折|<获取>小树枝|<获取>玄铁剑|<获取>长剑|<获取>木剑"
	   end
	   if level_xuantie<=160 and level_xuantie>120 then
	      item="<获取>长剑|<获取>木剑"
	   end
	   if level_xuantie>160 then
	      item="<获取>木剑"
	   end
	  local sp=special_item.new()
	   sp.cooldown=function()
           pubu()
       end
       equip=Split(item,"|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)

   end

   lw:get_exps()
   --检查装备

  --2000 内力 带玄铁剑 长剑 木剑
  --#10 ji flood
  --world.Send("tiao pubu")
  -- <=120 <=160
  --1500
end

local function hb()
   package.loaded["hubiao"] = nil
   require "hubiao"
   local jb1,jb2=Job_Next("hb")
   local f=che
   xp:check()

   hubiao.fail=function(id)
       if id==101 then
	       --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  --print(_job_name," ",jb1," ",jb2)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
	   end
   end
   hubiao.shield=function()
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="护镖" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
   hubiao.jobDone=function()
      xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	     print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
		 local _job=check_job(jb1)
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习

			  print("开始学习")
			  level_up(_job)
		 else
		    --继续job
            print("继续")
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			_job()
		 end
	  end
	  h:check()
   end
   local cd=cond.new()
   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态"  then
			   sec=i[2]
			    print(sec," 时间")
			   if sec==0 then
			    hubiao:Partner_Status_Check()
				 return
			  end
			 print("内功修炼")
			 world.Send("unset 积蓄")
	        local f=function()
	           switch(process.hb)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.5
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
              else
			    process.neigong3()
			  end
		 	end
		    	b:check()
			   return
			  end
			  --│福州镖局护镖倒计时六分                     ？ │
			  if i[1]=="福州镖局护镖倒计时" then
			    sec=i[2]
			    local jt=jobtimes.new()
			    jt.checkover=function(jobname)
		         print("jobname :",jobname)
	             local _job_name=chinese_job_name(jobname)
		         local _job={}
		         if string.find(jb1,_job_name) then
		          _job=check_job(jb2)
		         else
			      _job=check_job(jb1)
		         end
	             local b
	             b=busy.new()
	             b.Next=function()
		          _job()
	             end
	             b:check()
			    end
	            jt:check()
				return
			    --break
			  end
			end
		 end
		 hubiao:Partner_Status_Check()
   end
   cd:start()
end


local function xxpt()
   package.loaded["xxpantu"]=nil
   require "xxpantu"
   local jb1,jb2=Job_Next("xxpt")
   xp:check()
   local _xxpt={}
   _xxpt=xxpantu.new()

   local select_pfm=world.GetVariable("xxpt_pfm")
	if select_pfm==nil then
      utils.msgbox ("你的xxpt_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
      return
   end
   local _pfm=world.GetVariable(select_pfm)
   world.SetVariable("pfm",_pfm)
   _xxpt.difficulty=world.GetVariable("xxpt_level") or 1
   _xxpt.playname=world.GetVariable("player_name")
   local blacklist=world.GetVariable("xxpt_blacklist") or ""
   if blacklist~=nil then
	  _xxpt.blacklist=blacklist
   end
   local neili_upper=assert(world.GetVariable("neili_upper"))
   if neili_upper~=nil then
       _xxpt.neili_upper=tonumber(neili_upper)
   end
   _xxpt.shield=function()
	  --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""  --自定义
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="星宿叛徒" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
   end

   _xxpt.fail=function(id)
     --print("id:",id)
	 --print("_wd_last_ok:",_wd_last_ok)
	 if id==101 then

	   --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()

	 end
	 if id==102 then

	   local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态"  then
			   sec=i[2]
			   break
			  end
			  if i[1]=="星宿追杀叛徒" then
			    sec=i[2]
			    break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")

			print("等待时间",sec,"实际",sec-30)
			if sec-30>0 then

	        local f=function()
	           switch(process.xxpt)
	        end
	        f_wait(f,sec-30)
			local b=busy.new()
			b.interval=0.5
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
              else
			    process.neigong3()
			  end
			end
			b:check()
		   else
		       print("小于20s 不在打坐")
			   f_wait(process.xxpt,5)

		   end
		 end
	   end
	   cd:start()
	 end
   end
  local cb
  cb=fight.new()
  cb.escape=function()
      print("flee")
	  _xxpantu:flee()
  end
  local xxpantu_pfm_list=world.GetVariable("xxpt_pfm_list") or ""

  if xxpantu_pfm_list~=nil and xxpantu_pfm_list~="" then
	 cb.pfm_list=world.GetVariable(xxpantu_pfm_list)
  end
   _xxpt.sure_enemy_skill=function() --确定敌人使用的技能
      print("*********************")
	  print(_xxpt.skills)

      local _pfm,_pfm_list=cb:po_enemy_skills(_xxpt.skills)
	  print("*********************")
	  if _pfm~=nil and _pfm_list~=nil then
	    print(_pfm," 使用的技能")
		print(_pfm_list," 使用的切换顺序")
	    cb.pfm_list=world.GetVariable(_pfm_list)
        local s_pfm=world.GetVariable(_pfm)
        world.SetVariable("pfm",s_pfm)
	  end
   end
    _xxpt.auto_pfm=function()

	   local select_pfm=world.GetVariable("xxpt_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的xxpt_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		  cb.combat_alias=_pfm
		  cb:before_kill()
   end
   _xxpt.combat=function()
         print("战斗模块")
	  --shutdown()
	  cb.enemy_name=_xxpt.robber_name
      local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm
	   cb.pfm_list=string.gsub(cb.pfm_list,"@id","")
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=50 then
		  cb.run_flee=true
	      print("低于安全设置开始脱离战斗")
		  _xxpt:flee()
	     end
      end
	  cb.neili_lack=function()
	     --world.Send("fu wan")
		 print("flee")
		 _xxpt:flee()
	  end
	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
	     print("战斗结束1")
		 shutdown()
		 world.Send("unset wimpy")
		 world.Send("jiali 1")
		 world.Execute("get silver from corpse;get gold from corpse")
		 if cb.is_duo==true then
			for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
			end
		 end
		 if _xxpt.win==true then
		    _xxpt:reward()
		 else
		    _xxpt:giveup()
		 end
	  end
	  cb:start(false)
   end
   _xxpt.sure_robber=function()
        local pfm=world.GetVariable("pfm")
	    local unarmed_pfm=world.GetVariable("unarmed_pfm")
		cb.fightcmd="kill ".._xxpt.robber_id
		cb.combat_alias=""
		cb.unarmed_alias=""
		cb.combat_alias=string.gsub(pfm,"@id",_xxpt.robber_id)
        cb.unarmed_alias=string.gsub(unarmed_pfm,"@id",_xxpt.robber_id)
		cb:reset()
   end
	_xxpt.robber_die=function()
         print("战斗结束2")

		 shutdown()
		 world.Send("unset wimpy")
		 world.Send("jiali 1")
		 local b=busy.new()
		 b.Next=function()

		   if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
		   	  end
		   end
		   if _xxpt.win==true then
			 local b=busy.new()
		     b.Next=function()
			    local delay_time=0.1
			   if cb.status=="大转" then
			       --world.Send("alias pfm hp")
				  -- world.Send("get hammer")
				   --world.Send("get falun")
			       delay_time=2
			   end
			   local f=function()
		          _xxpt:reward()
			   end
			   f_wait(f,delay_time)
			 end
			 b:check()
		   else
		      if cb.status=="大转" then
				 world.Send("alias pfm hp")
			     --world.Send("get hammer")
				 --world.Send("get falun")
			  end
		    _xxpt:giveup()
		   end
		 end
		 --if cb.status=="大转" then
		  b:jifa()
		 --else
		 -- b:check()
		 --end
   end
   	_xxpt.robber_die2=function()
         print("战斗结束3")
	     world.Send("unset wimpy")
		 shutdown()
		 world.Send("jiali 1")
		 local b=busy.new()
		 b.Next=function()
			world.Execute("get silver from corpse;get gold from corpse")
		    if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			    world.Send("get "..weapon_item)
		   	  end
		    end
		   if _xxpt.win==true then
			 local b=busy.new()
		     b.Next=function()
				local delay_time=0.1
			    if cb.status=="大转" then
			      delay_time=2
				   --world.Send("alias pfm hp")
				    --world.Send("get hammer")
				    --world.Send("get falun")
			    end
		        local f=function()

		          _xxpt:reward()
			    end
			    f_wait(f,delay_time)
			 end
			 b:check()
		   else
			  if cb.status=="大转" then
			      world.Send("alias pfm hp")
			     --world.Send("get hammer")
				 --world.Send("get falun")
			  end
		    _xxpt:giveup()
		   end
		 end
		 --if cb.status=="大转" then
		  b:jifa()
		--else
		--  b:check()
		--end
   end
   _xxpt.jobDone=function()
      print("xxpantu 结束")
	  _xxpt_last_ok=true
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		 --world.AppendToNotepad (WorldName().."_武当任务:",os.date()..": 受伤程度:"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")".."\r\n")
		 --[[if h.qi_percent<80 then
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "red", "black") -- yellow on white
         elseif h.qi_percent<90 then
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "yellow", "black") -- yellow on white
		 else
		   CallPlugin ("88f53dbf74b5a0ac2fefbf95", "MsgNote", os.date().."武当任务:受伤程度"..h.qi.."/"..h.max_qi.."("..h.qi_percent..")", "white", "black") -- yellow on white
		 end
		print("潜能:",h.pot," max:",h.max_pot)]]
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  local _job
			   _job=check_job(jb1)
              assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")

			   level_up(_job)

		 else
		    --继续job
            print("继续")
			local _job
			_job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")

			_job()

		 end
	  end
	  h:check()
   end
   _xxpt:Status_Check()
end

local function ks()
     package.loaded["shouding"]=nil
    require "shouding"
	  local jb1,jb2=Job_Next("ks")
   xp:check()
   local _shouding={}
   _shouding=shouding.new()
   _shouding.shield=function()
	  --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""  --自定义
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="守鼎" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
	   local select_pfm=world.GetVariable("shouding_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的shouding_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		  local pfm=world.GetVariable("pfm")
	    pfm=string.gsub(pfm,"@id","")
		world.Send("alias pfm "..pfm)

   end
    _shouding.jobDone=function()

	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
		 	--开始学习
	  	 local _job
		 _job=check_job(jb1)
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")

			   level_up(_job)

		 else

			_job()
		 end
	  end
	  h:check()
   end
   _shouding:kanshou()
end

local function riyuefx()
    package.loaded["ryfx"]=nil
    require "ryfx"
    --local f=check_job(Job_Next("ryfx"))
	 local jb1,jb2=Job_Next("ryfx")
	xp:check()
    local _ryfx={}
    _ryfx=ryfx.new()
	_ryfx.g_blacklist=world.GetVariable("ryfx_blacklist") or ""

	local neili_upper=world.GetVariable("neili_upper")
    if neili_upper~=nil then
       _ryfx.neili_upper=tonumber(neili_upper)
    end

	_ryfx.shield=function()

	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if (k=="日月复兴请人" and _ryfx.jobtype=="请人") then
		   --world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 elseif (k=="日月复兴刺杀" and _ryfx.jobtype=="刺杀") then
			--world.Execute(v)
			world.SetVariable("shield",v)
		    break
		 elseif k=="日月复兴" or k=="全部" then
			--world.Execute(v)
		    world.SetVariable("shield",v)
		    break
		 end
	  end
	   local shield=world.GetVariable("shield")
       world.Execute(shield)
    end
    _ryfx.fail=function(id)
	--失败

	if id==101 then
	   --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
	  elseif id==102 then
		 local cd=cond.new()
	     cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态"  then
			   sec=i[2]
			   break
			  end
			  if i[1]=="日月复兴" then
			    sec=i[2]
			    break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")

			print("等待时间",sec,"实际",sec-30)
			if sec-30>0 then

			    local jt=jobtimes.new()
			    jt.checkover=function(jobname)
		         print("jobname :",jobname)
				 if jobname=="日月复兴" or sec>=20 then --最后一个任务
	              local _job_name=chinese_job_name(jobname)
		          local _job={}
		          if string.find(jb1,_job_name) then
		            _job=check_job(jb2)
		           else
			        _job=check_job(jb1)
		           end
	               local b
	               b=busy.new()
	               b.Next=function()
		            _job()
	               end
	               b:check()
				 else
				   local f2=function()
				     local w=walk.new()
				      w.walkover=function()
				        process.ryfx()
				      end
				      w:go(1413)
	               end
				    f_wait(f2,5)
				 end
			    end
	            jt:check()
			end
          --[[
	        local f=function()
	           switch(process.ryfx)
	        end
	        f_wait(f,sec-30)
			local b=busy.new()
			b.interval=0.5
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			  elseif xiulian=="xiulian_skills" then
			    process.lian()
              else
			    process.neigong3()
			  end
			end
			b:check()
		   else
		       print("小于20s 不在打坐")
			   f_wait(process.ryfx,5)

		   end]]

		 end
	   end
	   cd:start()
	  end
   end
   local cb=fight.new()
	_ryfx.fight_reset=function()
	      print("ryfx fight reset!!")
	      local select_pfm=world.GetVariable("ryfx_fight_pfm")
          local _pfm=world.GetVariable(select_pfm)
		  local f=function()
		    print("重置pfm！！")
            world.SetVariable("pfm",_pfm)
		    local pfm=world.GetVariable("pfm")
	        pfm=string.gsub(pfm,"@id",_ryfx.id)
            cb.combat_alias=pfm
		  end
		  f_wait(f,1)
	end
	_ryfx.prepare=function()
	   local flag=_ryfx.jobtype
	    print("战斗模块",flag)
	   if flag=="请人" then
	      local select_pfm=world.GetVariable("ryfx_fight_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ryfx_fight_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
	   else
	      local select_pfm=world.GetVariable("ryfx_kill_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ryfx_kill_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
	   end
      print("自动auto_pfm")
	  local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
		world.Send("alias pfm "..pfm)
	end
    _ryfx.auto_pfm=function()
	   local flag=_ryfx.jobtype
	    print("战斗模块",flag)
	   if flag=="请人" then
	      local select_pfm=world.GetVariable("ryfx_fight_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ryfx_fight_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
	   else
	      local select_pfm=world.GetVariable("ryfx_kill_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ryfx_kill_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
	   end
      --print("自动auto_pfm")
	  local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
	   cb.combat_alias=pfm
	  --world.Execute(pfm)
	  cb:before_kill()
   end
	_ryfx.combat=function()

	   local flag=_ryfx.jobtype
	    print("战斗模块",flag)
	   if flag=="请人" then
	      local select_pfm=world.GetVariable("ryfx_fight_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的ryfx_fight_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		   local ryfx_fight_pfm_list=world.GetVariable("ryfx_fight_pfm_list") or ""
	      if ryfx_fight_pfm_list~=nil then
	       cb.pfm_list=world.GetVariable(ryfx_fight_pfm_list)
	      end
	   else
	      local select_pfm=world.GetVariable("ryfx_kill_pfm")
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)
		   local ryfx_kill_pfm_list=world.GetVariable("ryfx_kill_pfm_list") or ""
	      if ryfx_kill_pfm_list~=nil then
	       cb.pfm_list=world.GetVariable(ryfx_kill_pfm_list)
	      end
	   end

	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id",_ryfx.id)

       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id",_ryfx.id)
	   cb.unarmed_alias=unarmed_pfm
	  cb.damage=function(hp)
         if tonumber(hp.qi_percent)<=70 then
	      print("低于安全设置开始脱离战斗")
		   world.Send("unset wimpy")
		  _ryfx:flee()

	     end
      end
	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
		   print("战斗结束")
		   world.Send("unset wimpy")
		 shutdown()
           if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
		   	  end
		   end
		 if _ryfx.jobtype=="刺杀" then
		   _ryfx:qie_corpse()
		 else
		   _ryfx:qing_again()
		 end
	  end
	  cb.neili_lack=function()
	     print("内力不够")
		  world.Send("unset wimpy")
		 _ryfx:flee()
	  end
	  	 -- jue:wuzhuan()
	  --jue:maze()
	  --jue:fuxue()
	  --jue:tianyin()
	    cb:start()
   end
   _ryfx.fight_end=function(callback)
       print("战斗结束")
		   world.Send("unset wimpy")
           if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
		   	  end
		   end
		callback()
   end
    _ryfx.jobDone=function()
      --print("ryfx 结束")

	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
	  --[[
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
		 	--开始学习
	  	 local _job
		 _job=check_job(jb1)
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  --Songshan_male_learn(proceryfx.sx)
			  --Songshan_lingwu(proceryfx.sx)
			   --Go_learn(proceryfx.sx)
			   --Go_learn(proceryfx.xs)
			   level_up(_job)
			  --dali_learn_literate(proceryfx.xs)
		 else
		    --继续job
            --print("继续wd")
			_job()
		 end]]
          local _job
		 _job=check_job(jb1)
		  local jb=jobtimes.new()
		 jb.checkover=function()
		    local ryfx_count=jb.lists["日月神教复兴"] or 0
			local xs_count=0
			if jb.lists["宝象抢美女"] == nil then
			    xs_count=0
			else
			    xs_count=jb.lists["宝象抢美女"]
			end
		    local c=xs_count+ryfx_count
			print("总次数:",c," 剩余次数:",(50-c%50))
            local xxdf=world.GetVariable("quest_xxdf") or "false"
			if (c%2)==0 or xxdf=="false" then
			     print("潜能:",h.pot," max:",h.max_pot)
		        local pot_overflow=world.GetVariable("pot_overflow")
		         if pot_overflow==nil then
		            pot_overflow=20
		         else
		            pot_overflow=tonumber(pot_overflow)
		         end
		         print("潜能:",h.pot," max:",h.max_pot," pot_overflow",pot_overflow)
	             if h.pot>h.max_pot-pot_overflow then
			      --开始学习
			       print("开始学习")
				   level_up(_job)
		         else
		            --继续job
                    print("继续")
			        --process.tdh()
			        _job()
		         end
			else
			    --自动加入送信
				print("自动送信1")
				process.sx()
			end

		 end
		 jb:check()
	  end
	  h:check()
   end
    _ryfx:Status_Check()
end

local function csha()
    package.loaded["cisha"]=nil
    require "cisha"
	 local jb1,jb2=Job_Next("cisha")
	xp:check()
    local _cisha={}
    _cisha=cisha.new()

	local neili_upper=world.GetVariable("neili_upper")
    if neili_upper~=nil then
       _cisha.neili_upper=tonumber(neili_upper)
    end

	_cisha.shield=function()

	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="报效国家" then
		   --world.Execute(v)
		   world.SetVariable("shield",v)

		    break
		 elseif  k=="全部" then
			--world.Execute(v)
		    world.SetVariable("shield",v)
		    break
		 end
	  end
	   local shield=world.GetVariable("shield")
       world.Execute(shield)
    end
    _cisha.fail=function(id)
	--失败
	 if id==101 then
	   --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()

      end
    end
     local cb=fight.new()
	 local select_pfm=world.GetVariable("cisha_pfm")
	 if select_pfm==nil then
		utils.msgbox ("你的cisha_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
	 end
	 local _pfm=world.GetVariable(select_pfm)
	 world.SetVariable("pfm",_pfm)

	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")

       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm

    _cisha.before_kill=function()

	      local select_pfm=world.GetVariable("cisha_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的cisha_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)

      --print("自动auto_pfm")
	  local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
	   cb.combat_alias=pfm
	  --world.Execute(pfm)
	  cb:before_kill()
   end
	_cisha.combat=function()

	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
		   print("战斗结束")
		   world.Send("unset wimpy")
		 shutdown()
           if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
		   	  end
		   end
		 _cisha:recover()
	  end

	  	 -- jue:wuzhuan()
	  --jue:maze()
	  --jue:fuxue()
	  --jue:tianyin()
	    cb:start()
   end
    _cisha.jobDone=function()
      print("cisha 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
		 	--开始学习
	  	 local _job
		 _job=check_job(jb1)
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  --Songshan_male_learn(proceryfx.sx)
			  --Songshan_lingwu(proceryfx.sx)
			   --Go_learn(proceryfx.sx)
			   --Go_learn(proceryfx.xs)
			   level_up(_job)
			  --dali_learn_literate(proceryfx.xs)
		 else
		    --继续job
            --print("继续wd")
			_job()
		 end
	  end
	  h:check()
   end
    _cisha:Status_Check()
end

local function gmsw()
	package.loaded["gmshouwei"]=nil
    require "gmshouwei"
	local jb1=Job_Next("gmsw")
	xp:check()
    local _gmsw={}
    _gmsw=gmshouwei.new()
	 local select_pfm=world.GetVariable("gmsw_pfm")
     local _pfm=world.GetVariable(select_pfm)
     --world.SetVariable("pfm",_pfm)
	 _gmsw.shield=function()
      --local shield=world.GetVariable("shield")
      --world.Execute(shield)
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="守卫古墓" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
	_gmsw.combat=function()
	   world.Send("kill attacker")

	   local cb=fight.new()
       cb.combat_alias=_pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	   cb.unarmed_alias=unarmed_pfm


	  cb.finish=function()
		 print("战斗结束1")
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 world.Send("jiali 1")
		 --world.Send("get coin")

		 _gmsw:qie_corpse()

	  end
	  cb:start()
	end
	_gmsw.attacker_die=function()
		 print("战斗结束2")
	     world.Send("unset wimpy")
		 shutdown()
		 --world.Send("unwield jian")
		 world.Send("jiali 1")
		 --world.Send("get coin")

		 _gmsw:qie_corpse()
	end
   _gmsw.jobDone=function()
	 local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
		 	--开始学习
	  	 local _job
		 _job=check_job(jb1)
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  --Songshan_male_learn(proceryfx.sx)
			  --Songshan_lingwu(proceryfx.sx)
			   --Go_learn(proceryfx.sx)
			   --Go_learn(proceryfx.xs)
			   level_up(_job)
			  --dali_learn_literate(proceryfx.xs)
		 else
		    --继续job
            --print("继续wd")
			_job()
		 end
	  end
	  h:check()
   end
   _gmsw:Status_Check()
end

local function tz()
    package.loaded["tiezhang"]=nil
    require "tiezhang"
	 local jb1=Job_Next("tz")
	xp:check()
    local _tz={}
    _tz=tiezhang.new()

	local neili_upper=world.GetVariable("neili_upper")
    if neili_upper~=nil then
       _tz.neili_upper=tonumber(neili_upper)
    end


	_tz.shield=function()

	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
      --local json=cjson.decode(sp_exert) --json数据解析
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="铁掌任务" then
		   --world.Execute(v)
		   world.SetVariable("shield",v)

		    break
		 elseif  k=="全部" then
			--world.Execute(v)
		    world.SetVariable("shield",v)
		    break
		 end
	  end
	   local shield=world.GetVariable("shield")
       world.Execute(shield)
    end

     local cb=fight.new()
	 local select_pfm=world.GetVariable("tz_pfm")
	 if select_pfm==nil then
		utils.msgbox ("你的tz_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
	 end
	 local _pfm=world.GetVariable(select_pfm)
	 world.SetVariable("pfm",_pfm)

	   local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
       cb.check_time=5
       cb.combat_alias=pfm
	   local unarmed_pfm=world.GetVariable("unarmed_pfm")
	    pfm=string.gsub(pfm,"@id","")
	   cb.unarmed_alias=unarmed_pfm

    _tz.before_kill=function()

	      local select_pfm=world.GetVariable("tz_pfm")
		  if select_pfm==nil then
            utils.msgbox ("你的tz_pfm没有设置！", "Warning!", "ok", "!", 1) --> ok
          end
          local _pfm=world.GetVariable(select_pfm)
          world.SetVariable("pfm",_pfm)

      --print("自动auto_pfm")
	  local pfm=world.GetVariable("pfm")
	   pfm=string.gsub(pfm,"@id","")
	   cb.combat_alias=pfm
	  --world.Execute(pfm)
	  cb:before_kill()
   end
	_tz.combat=function()

	  cb.no_pfm=function()
	    -- world.Send("unwield jian")
	    -- world.Send("unwield dao")
		-- world.Send("unwield chui")
	    -- world.Send("unwield xiao")
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.finish=function()
		   print("战斗结束")
		   world.Send("unset wimpy")
		 shutdown()
           if cb.is_duo==true then
			  for _,weapon_item in ipairs(cb.lost_weapon_id) do
		       --world.Send("get " ..weapon_item.. " from corpse")
			   world.Send("get "..weapon_item)
		   	  end
		   end
		 _tz:do_jobs()
	  end

	  	 -- jue:wuzhuan()
	  --jue:maze()
	  --jue:fuxue()
	  --jue:tianyin()
	    cb:start()
   end
    _tz.jobDone=function()
      print("cisha 结束")
	  xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		 print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
		 	--开始学习
	  	 local _job
		 _job=check_job(jb1)
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  --Songshan_male_learn(proceryfx.sx)
			  --Songshan_lingwu(proceryfx.sx)
			   --Go_learn(proceryfx.sx)
			   --Go_learn(proceryfx.xs)
			   level_up(_job)
			  --dali_learn_literate(proceryfx.xs)
		 else
		    --继续job
            --print("继续wd")
			_job()
		 end
	  end
	  h:check()
   end

    _tz:Status_Check()
end


local function kjmg()
   package.loaded["menggu"]=nil
   require "menggu"
    local mg=menggu.new()
	 local jb1,jb2=Job_Next("kjmg")
	 local safety_percent=world.GetVariable("kjmg_safety_percent") or 0.6
	xp:check()
	mg.safety_percent=safety_percent
   local mg_wave=world.GetVariable("mg_wave") or 13
   mg.wave_set=tonumber(mg_wave)
   local select_pfm=world.GetVariable("mg_pfm")
   mg.shield=function()
	  local sp_exert=world.GetVariable("sp_exert") or ""
	  local cjson = require("json")
	   sp_exert="{"..sp_exert.."}"
	  local json= assert(cjson.decode(sp_exert),"必须设置Sp_exert")
	  for k,v in pairs(json) do
	     if k=="抗击蒙古" or k=="全部" then
		   world.Execute(v)
		   world.SetVariable("shield",v)
		   break
		 end
	  end
    end
   local cb=fight.new()
    local pfm=world.GetVariable(select_pfm)
	cb.combat_alias=pfm
    local unarmed_pfm=world.GetVariable("unarmed_pfm")
	unarmed_pfm=string.gsub(unarmed_pfm,"@id","")
	cb.unarmed_alias=unarmed_pfm
	  local mg_pfm_list=world.GetVariable("mg_pfm_list") or ""

  if mg_pfm_list~=nil and mg_pfm_list~="" then
	 cb.pfm_list=world.GetVariable(mg_pfm_list)
  end
    mg.get_weapon=function()
	    local weapon_id=world.GetVariable("mg_weapon_id") or ""
		if weapon_id~=nil then
		   world.Send("get "..weapon_id)
		   world.Send("wield "..weapon_id)
		end
	end
	mg.auto_pfm=function()
	   cb.combat_alias=pfm
	   world.Send("alias pfm "..pfm)
	end

	mg.fail=function(id)
     print("id:",id)
	 if id==101 then

	   --下个工作 wd job busy 中
	    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  --print(_job_name," ",jb1," ",jb2)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()

	 end
	 if id==102 then
	   local b=busy.new()
	   b.Next=function()
	    mg:get_weapon()
		mg:Status_Check()
	   end
	   b:check()
	 end
	 if id==201 then
	   	local cd=cond.new()
	    cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  print(i[1])
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   print("等待sec:",sec)
			   break
			  end
			end
		     print("内功修炼")
			 world.Send("unset 积蓄")
	        local f=function()
	           switch(process.mg)
	        end
	        f_wait(f,sec)
			local b=busy.new()
			b.interval=0.3
			b.Next=function()
			  local xiulian=world.GetVariable("xiulian")
			  if xiulian=="xiulian_jingli" then
			    process.neigong2()
			  elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			  elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			 elseif xiulian=="xiulian_skills" then
			    process.lian()
			  end
			end
			b:check()
		 else
		    Weapon_Check(process.smy)
		 end
	   end
	   cd:start()
	 end
   end
	mg.jobDone=function()
       xp:check()
	  local h
	  h=hp.new()
	  h.checkover=function()
		print("潜能:",h.pot," max:",h.max_pot)
		 local pot_overflow=world.GetVariable("pot_overflow")
		 if pot_overflow==nil then
		    pot_overflow=20
		 else
		    pot_overflow=tonumber(pot_overflow)
		 end
		 print("潜能:",h.pot," max:",h.max_pot," pot_overflow")
	     if h.pot>h.max_pot-pot_overflow then
			--开始学习
			  print("开始学习")
			  local _job
			   _job=check_job(jb1)
              assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")
			  if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
			    local ld=liandu.new()
				ld.liandu_end=function()
				   level_up(_job)
				end
				ld:liandu()
			 else
			   level_up(_job)
		     end
		 else
		    --继续job
            print("继续")
			local _job
			_job=check_job(jb1)
			assert (type (_job) == "function", "jobslist变量没有设置正确,无法知道下一个job！！！")

			if party=="星宿派" and is_liandu=="自动" then
			      package.loaded["liandu"]=nil
			    require "liandu"
		        local ld=liandu.new()
				ld.liandu_end=function()
				   _job()
				end
				ld:liandu()
			else
			   _job()
		    end
		 end
	  end
	  h:check()
   end
    mg.combat=function()
         print("战斗模块")
	  cb.no_pfm=function()
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			cb:run()
		 end
		 sp:unwield_all()
	  end
	  cb.danger_skill=function()
	  end
      cb.finish=function()
	   local b=busy.new()
	   b.Next=function()
	    mg:get_weapon()
		mg:Status_Check()
	   end
	   b:check()
	  end
      cb:start()
   end
    mg.target=function(id)
       cb.target=id
	end
	mg.reset=function(id)
	   cb.target=id
	   cb:reset()
	end
   local work=function()
    local jt=jobtimes.new()
	    jt.checkover=function(jobname)
		  print("jobname :",jobname)
	      local _job_name=chinese_job_name(jobname)
		  local _job={}
		  if string.find(jb1,_job_name) then
		       _job=check_job(jb2)
		  else
			   _job=check_job(jb1)
		  end
	      local b
	      b=busy.new()
	      b.Next=function()
		    _job()
	      end
	      b:check()
	    end
	    jt:check()
   end
	 local cd=cond.new()
	   cd.over=function()
	     print("检查状态")
		 if table.getn(cd.lists)>0 then
		    local sec=10
		    for _,i in ipairs(cd.lists) do
			  if i[1]=="任务繁忙状态" then
			   sec=i[2]
			   break
			  end
			end
		     print("内功修炼")
	        local f=function()
	           switch(function() smy:Status_Check() end)
	        end
	        f_wait(f,sec)
			local xiulian=world.GetVariable("xiulian")
			if xiulian=="xiulian_jingli" then
			    process.neigong2()
			elseif xiulian=="xiulian_neili" then
			    process.neigong3()
			elseif xiulian=="xiulian_dubook" then
			    local cmd=world.GetVariable("dubook_cmd") or "du book"
				process.readbook(cmd)
			elseif xiulian=="xiulian_skills" then
			    process.lian()
			end
		 else
		    mg:Status_Check()
		 end
	   end
	   cd:start()
end

process={
  init=init,
  fullskills=fullskills,
  gb=gb,
  cl=cl,
  sx=sx,
  xc=xc,
  wd=wd,
  neigong=neigong,
  neigong2=neigong2,
  neigong3=neigong3,
  zc=zc,
  check=check,
  set_skills=set_skills,
  masterid=masterid,
  masterplace=masterplace,
  pots=pots,
  lingwu=Go_lingwu,
  readbook=readbook,
  xs=xs,
  hs=hs,
  tdh=tdh,
  hs2=hs2,
  update_log=function()
    print(update_log)
  end,
  wg=start,
  suoming=sld_suoming,
  zs=zs,
  huxi=hx,
  jh=jh,
  az=az,
  ss=ss,
  tm=tm,
  tx=tx,
  sm=sm,
  ck=ck,
  xl=xl,
  jy=jy,
  ts=ts,
  xxbug=xxbug,
  lian=slian,
  oyk=oyk,
  qj=qj,
  qqllyu=qqllyu,
  xuantie=xuantie,
  hb=hb,
  smy=smy,
  jobbusy~=nil,
  xxpt=xxpt,
  ryfx=riyuefx,
  ks=ks,
  kc=kc,
  cisha=csha,
  caiyao=qz_caiyao,
  tz=tz,
  gmsw=gmsw,
  cj=cj,
  kjmg=qz_kjmg,

}

process.init()

ch_over=function()
   --根据门派更新权重
  local f=function()
     print("特殊化数据库路径!")
     update_data()
  end
  f_wait(f,1)
end

--给重连插件使用的函数
local timers={}
function Timer_Pause()
 timers={}
 tl = GetTimerList ()
 if tl then
   for k, v in ipairs (tl) do
       --Note (v)
	   local enabled=GetTimerOption (v, "enabled")
	   --print(enabled," flag")
	   if enabled==1 then
	       Note (v)
	      world.EnableTimer(v,false)
		  table.insert(timers,v)
	   end
   end  -- for
 end -- if we have any timers
end

function Timer_Resume()
  for _,v in ipairs(timers) do
     world.EnableTimer(v,true)
  end
  timers={}
end

function Clean_Memory()
   world.EnableTriggerGroup("roominfo",false)
   world.DeleteTriggerGroup("roominfo")
   world.EnableTrigger("guard_id",false)
   world.DeleteTrigger("guard_id")
   world.EnableTrigger("beauty_place",false)
   world.DeleteTrigger("beauty_place")
   world.EnableTrigger("player_place",false)
   world.DeleteTrigger("player_place")
   world.EnableTrigger("robber_place",false)
   world.DeleteTrigger("robber_place")
   world.EnableTrigger("choujia_place",false)
   world.DeleteTrigger("choujia_place")
   world.EnableTrigger("npc_place",false)
   world.DeleteTrigger("npc_place")
   --杀进程
   Room.catch_co=nil
   fight.check_co=nil
   special_item.sp_co=nil
   equipments.eq_co=nil
   wait.clearAll()
   f_clear()
   print("清理前:",collectgarbage("count"))
   collectgarbage("collect")
   print("清理后:",collectgarbage("count"))
end

function clean_WorldAddress()
  local address=world.WorldAddress()  --原始地址
  if address~="0.0.0.0" then
     world.SetVariable("world_address",address) --保存入变量
  end
  world.SetAlphaOption("site","0.0.0.0") --清除掉
end

function set_WorldAddress()
  world.SetAlphaOption("script_prefix","/") --设置脚本前缀为 /
  world.SetOption("enable_speed_walk",false)
  local address=world.GetVariable("world_address") or world.WorldAddress()
  world.SetAlphaOption("site",address)
  print("设置服务器IP地址:",address)
end

set_WorldAddress()  --启动脚本时候将变量值自动赋值

function loadPlugin() --自动加载插件
 --[[local is_Pluginloaded=false
if GetPluginList()~=nil then

  for k, v in pairs (GetPluginList()) do
    Note (v, " = ", GetPluginInfo(v, 1))
    if GetPluginInfo(v, 1)=="reconnect2" then
       local PluginID=GetPluginInfo(v, 7)
	   local afk_sec=tonumber(world.GetVariable("afk_sec")) or 60
	   CallPlugin(PluginID, "set_AFKTime", afk_sec)
	   --CallPlugin(PluginID, "Enable_AFK")
       is_Pluginloaded=true
    end
   end
end]]

--if is_Pluginloaded==false then
  --print("插件检测:",GetInfo (66).."worlds\\plugins\\reconnect2.xml")
  --默认位置加载插件
--[[if IsPluginInstalled("083f0cf014dbc8895a197d2a")==true then
   UnloadPlugin("083f0cf014dbc8895a197d2a")

end]]
 UnloadPlugin("083f0cf014dbc8895a197d2a")
 world.LoadPlugin(GetInfo (66).."worlds\\plugins\\reconnect2.xml")
    local afk_sec=tonumber(world.GetVariable("afk_sec")) or 60
	   CallPlugin("083f0cf014dbc8895a197d2a", "set_AFKTime", afk_sec)
	   CallPlugin("083f0cf014dbc8895a197d2a", "Enable_AFK")
    --[[for k, v in pairs (GetPluginList()) do
    if GetPluginInfo(v, 1)=="reconnect2" then
       local PluginID=GetPluginInfo(v, 7)
	   local afk_sec=tonumber(world.GetVariable("afk_sec")) or 60
	   CallPlugin(PluginID, "set_AFKTime", afk_sec)
	   CallPlugin(PluginID, "Enable_AFK")
       is_Pluginloaded=true
    end
   end
end]]
--[[
if IsPluginInstalled("083f0cf014dbc8895a197d2a")==false then
 print("插件检测:",GetInfo (66).."worlds\\plugins\\reconnect2.xml")
 world.LoadPlugin(GetInfo (66).."worlds\\plugins\\reconnect2.xml")
end]]
--88f53dbf74b5a0ac2fefbf95
--if IsPluginInstalled("88f53dbf74b5a0ac2fefbf95")==false then
-- print("插件检测:",GetInfo (66).."worlds\\plugins\\SjMessage.xml")
-- world.LoadPlugin(GetInfo (66).."worlds\\plugins\\SjMessage.xml")
-- else
--   UnloadPlugin("88f53dbf74b5a0ac2fefbf95")
--end
--[[
if IsPluginInstalled("5c589f1ca4fd208978a46254")==true then
 UnloadPlugin("5c589f1ca4fd208978a46254")
 print("插件检测:",GetInfo (66).."worlds\\plugins\\rbt_update.xml")

end]]
UnloadPlugin("5c589f1ca4fd208978a46254")
world.LoadPlugin(GetInfo (66).."worlds\\plugins\\rbt_update.xml")

if IsPluginInstalled("b555825a4a5700c35fa80780")==true then

  UnloadPlugin("b555825a4a5700c35fa80780")

  print("插件检测:",GetInfo (66).."worlds\\plugins\\sj_chat.xml")

  else
   UnloadPlugin("b555825a4a5700c35fa80780")
end
world.LoadPlugin(GetInfo (66).."worlds\\plugins\\sj_chat.xml")
end
 --插件加载
 --world.DoAfterSpecial (5,"up:auto_check",10)
world.DoAfterSpecial(3,"loadPlugin()",12)

function Weapon_Lost()
--[[
  你丢下一柄凝水乾坤锤。
> 你捡起一柄凝水乾坤锤。
> 你丢下一只秘传法轮。
> 你捡起一只秘传法轮。]]
 wait.make(function()
   world.Execute("get falun;get hammer")
   local l,w=wait.regexp("^(> |)你捡起一柄.*锤。$|^(> |)你捡起一只.*法轮。$|^(> |)你附近没有这样东西。$",2)
   if l==nil then
      Weapon_Lost()
	  return
   end
   if string.find(l,"你捡起")then
      print("ok")
     return
   end
  end)
end

