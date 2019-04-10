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
  4 基本配置方式说明，请见MC通用机器人模块.xml文件       

