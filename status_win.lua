require "movewindow"
require "gauge"
require "serialize"

-- 公用
local FONT_NAME = "f1"
local FONT_SIZE = "9"

-- HP用
local hp_win = "hp_window"
local hp_win_width = 260
local hp_win_height = 183

-- 技能用
local skill_win = "skill_window"
local skill_win_width = 260
local skill_win_height = 10

-- 任务用
local task_win="task_window"
local task_win_width=260
local task_win_height=100

--伙伴 HP用

local partner_hp_win_width = 260
local partner_hp_win_height = 183

status_win =
{
    new=function()
     local st={}
	 setmetatable(st,status_win)
	 return st
   end,
	-- 精神
	jing = 100,
	jing_max = 100,
	jing_pre = 100,

	-- 气血
	qi = 100,
	qi_max = 100,
	qi_pre = 100,

	-- 精力
	jingli = 100,
	jingli_max = 100,
	jingli_limit=0,

	-- 内力
	neili = 100,
	neili_max = 100,
	neili_limit=100,

	-- 食物
	food = 100,
	max_food=100,
	-- 饮水
	water = 100,
	max_water=100,


	-- 潜能
	pot = 0,
    max_pot=0, --最大潜能

	-- 经验
	exps = 0,
	exps_percent = 0, --经验百分比

	jiali = 1,
	jiajing=1,
	VERSION = 1.0,   -- for querying by plugins
	-- 技能
	skills={},
	max_level=0,
	-- 任务
	task_name="",
	task_stepname="",
	task_step=0,
	task_maxsteps=0,
	task_location="",
	task_description="",
}
status_win.__index=status_win
---------------------------------------------------------------------------
-- 公用的一些函数和定义
---------------------------------------------------------------------------

--[[
	Alarm()				---报警！
	Run(cmdtext)		---自定义执行命令
	RunWait(WaitTime)	---加入等待进命令队列
	RunNextCmd()		---继续处理下条命令
	RunClear()			---清空命令队列
	Printlog()			---打印临时记录队列
	ChangeModel()		---改变模式
	Fun_AddAlias(name,match,group,script)		---自定义AddAlias函数
	Fun_AddAliasRE(name,match,group,script)		---自定义AddAlias函数(带正则表达式)
	Fun_AddTrigger(name,match,group,script)		---自定义AddTrigger函数，同时会加入组
	Fun_AddTriggerHide(name,match,group,script)		---隐藏某些显示，同时会加入组
	Fun_AddTimer(name,time,group,script)		---自定义AddTime函数 注意是正则表达式模式
	Fun_DrawGrid(win, cur, max, left, top, width, height, curcolor, maxcolor)							---自定义绘制进度条
	Fun_DrawGrid2(win, cur, curmax, max, left, top, width, height, curcolor, curmaxcolor, maxcolor)		---自定义绘制进度条2个进度
	Fun_ChangeKM(value)							---修改经验的K、M为正常数值模式
	Fun_AddTaskData(taskname, taskaim)			---加入任务数据
	Fun_TimeChangeText(Time)					---把秒换算成以天、小时、分钟、秒显示的文字
	Fun_TimeChange(Time)						---把秒换算成以小时、分钟、秒
	Fun_CHNum(str)								---把中文数字转换成正常数字
	Fun_GetBackPath(strgo)						---根据路径获取反向路径
]]

-- ------------------------------------
-- 描述: 自定义绘制进度条
-- ------------------------------------
local function Fun_DrawGrid(win, cur, max, left, top, width, height, curcolor, maxcolor)
	gauge (win, "", cur, max,
			left, top, width, height,
			curcolor, maxcolor,
			0, 0x000000, 0x000000, 0x000000)
end
-- ------------------------------------
-- 描述: 自定义绘制进度条2个进度
-- ------------------------------------
local function Fun_DrawGrid2(win, cur, curmax, max, left, top, width, height, curcolor, curmaxcolor, maxcolor)
	gauge (win, "", cur, max,
			left, top, width, height,
			curcolor, maxcolor,
			0, 0x000000, 0x000000, 0x000000)

	if curmax < max then
		local lenght = math.floor((max - curmax) * width / max)
		if lenght < 1 then
			lenght = 1
		end
		WindowRectOp (win, 2, left + width - lenght - 1, top + 1, left + width + 1, top + height - 1, curmaxcolor)
	end
end

---------------------------------------------------------------------------
-- 状态模块
---------------------------------------------------------------------------


function status_win:init(hp,lw,task,partners)
-- 初始化
  if hp~=nil then
   self.jing=hp.jingxue

   self.jing_max=hp.max_jingxue
   self.jing_pre=hp.jingxue_percent

   self.qi=hp.qi
   self.qi_max=hp.max_qi
   self.qi_pre=hp.qi_percent

   self.jingli=hp.jingli
   self.jingli_max=hp.max_jingli
   self.jingli_limit=hp.jingli_limit


   self.neili=hp.neili
   self.neili_max=hp.max_neili
   self.neili_limit=hp.neili_limit

   self.jiali=hp.jiali
   self.food=hp.food
  if hp.max_food~=nil then
     self.max_food=hp.max_food
  end
  self.water=hp.drink
  if hp.max_drink~=nil then
     self.max_water=hp.max_drink
  end
  self.pot=hp.pot
  self.max_pot=hp.max_pot
  self.exps=hp.exps
  self.exps_percent=hp.exps_percent
 end

  ----------------skills--------------
 if lw~=nil then
   self.max_level=lw.max_level
   self.skills={}
   for _,i in ipairs(lw.me_skills) do
      table.insert(self.skills,i)
   end
 end

  if task~=nil then
     self.task_name=task.task_name
	 self.task_stepname=task.task_stepname
	 self.task_step=task.task_step
	 self.task_maxsteps=task.task_maxsteps
	 self.task_location=task.task_location
	 self.task_description=task.task_description
  end

  if partners~=nil then
     self.partners=partners
  end
end

-- ------------------------------------
-- 绘制窗口
-- ------------------------------------
function status_win:hp_draw_win()
	WindowCreate (hp_win, 0, 0, hp_win_width, hp_win_height, miniwin.pos_bottom_left, 0, 0x000010)
	local hp_win_info = movewindow.install (hp_win, miniwin.pos_bottom_left, miniwin.create_absolute_location, true)
	WindowCreate(hp_win, hp_win_info.window_left, hp_win_info.window_top, hp_win_width, hp_win_height, hp_win_info.window_mode, hp_win_info.window_flags, 0x000010)
	movewindow.add_drag_handler (hp_win, 0, 0, hp_win_width, 30)
	WindowFont (hp_win, FONT_NAME, "Arial", FONT_SIZE)

	WindowCircleOp (hp_win, miniwin.circle_round_rectangle, 0, 2, hp_win_width - 2, hp_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)

	local left = 5
	local top = 10
	local title_leght = 28
	local titletarger_leght = 75
	local grid_lenght = 100
	local grid_height = 12
   --print(hp_win,"test")

	WindowText (hp_win, FONT_NAME, "玩家信息",
					left+94, top, 0, 0,
					ColourNameToRGB ("white"), false)


	top = top + 15
    WindowText (hp_win, FONT_NAME, "－－－－－－－－－－－－－－－－－－－－－",
                left, top, 0, 0,
                ColourNameToRGB ("gray"), false)
	top = top + 15

	-- 精神
    WindowText (hp_win, FONT_NAME, "精血",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
	Fun_DrawGrid2(hp_win, self.jing, self.jing_max, self.jing_max*100/self.jing_pre,
				left + title_leght, top + 1, grid_lenght, grid_height,
				0x40FF40, ColourNameToRGB("red"), ColourNameToRGB ("white"))
    WindowText (hp_win, FONT_NAME, self.jing.."/"..self.jing_max.."("..self.jing_pre.."%)",
                left + title_leght + grid_lenght + 2, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	-- 气血
    WindowText (hp_win, FONT_NAME, "气血",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
	Fun_DrawGrid2(hp_win, self.qi, self.qi_max, self.qi_max*100/self.qi_pre,
				left + title_leght, top + 1, grid_lenght, grid_height,
				0x40FF40, ColourNameToRGB("red"), ColourNameToRGB ("white"))
    WindowText (hp_win, FONT_NAME, self.qi.."/"..self.qi_max.."("..self.qi_pre.."%)",
                left + title_leght + grid_lenght + 2, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	-- 精力
    WindowText (hp_win, FONT_NAME, "精力",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)

		Fun_DrawGrid(hp_win, self.jingli, self.jingli_max,
					left + title_leght, top + 1, grid_lenght, grid_height,
					0xFFDA58, 0xFF6060)
		WindowText (hp_win, FONT_NAME, self.jingli.."/"..self.jingli_max.."(+"..self.jiajing..")",
					left + title_leght + grid_lenght + 2, top, 0, 0,
					0xFFDA58, false)


	top = top + 15

	-- 内力
    WindowText (hp_win, FONT_NAME, "内力",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)

	Fun_DrawGrid(hp_win, self.neili, self.neili_max,
					left + title_leght, top + 1, grid_lenght, grid_height,
					0xFFDA58, 0xFF6060)
	WindowText (hp_win, FONT_NAME, self.neili.."/"..self.neili_max.."(+"..self.jiali..")",
					left + title_leght + grid_lenght + 2, top, 0, 0,
					0xFFDA58, false)


	top = top + 15
    WindowText (hp_win, FONT_NAME, "－－－－－－－－－－－－－－－－－－－－－",
                left, top, 0, 0,
                ColourNameToRGB ("gray"), false)
	top = top + 15

	-- 食物
    WindowText (hp_win, FONT_NAME, "食物",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
	Fun_DrawGrid(hp_win, self.food, self.max_food,
				left + title_leght, top + 1, grid_lenght, grid_height,
				0x58A7FF, ColourNameToRGB ("white"))
    WindowText (hp_win, FONT_NAME, self.food.."/"..self.max_food,
                left + title_leght + grid_lenght + 2, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	-- 饮水
    WindowText (hp_win, FONT_NAME, "饮水",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
	Fun_DrawGrid(hp_win, self.water, self.max_water,
				left + title_leght, top + 1, grid_lenght, grid_height,
				0x58A7FF, ColourNameToRGB ("white"))
    WindowText (hp_win, FONT_NAME, self.water.."/"..self.max_water,
                left + title_leght + grid_lenght + 2, top, 0, 0,
                0x40FF40, false)

	-- fullme后经过时间


	top = top + 15

	-- 潜能
    WindowText (hp_win, FONT_NAME, "潜能",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
    WindowText (hp_win, FONT_NAME, self.pot.."/"..self.max_pot,
                left + title_leght, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	-- 经验
    WindowText (hp_win, FONT_NAME, "经验",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
    WindowText (hp_win, FONT_NAME, self.exps.."("..self.exps_percent.."%)",
                left + title_leght, top, 0, 0,
                0x40FF40, false)

	WindowShow (hp_win, true)
	movewindow.save_state(hp_win)
end


-- ------------------------------------
-- 绘制窗口
-- ------------------------------------
function status_win:partner_hp_draw_win()
--[[
   for index,partner in ipair(self.partners) do
    local partner_hp_win="partner_hp_window"..index
    WindowCreate (partner_hp_win, 0, 0, partner_hp_win_width, partner_hp_win_height, miniwin.pos_bottom_left, 0, 0x000010)
	local partner_hp_win_info = movewindow.install (partner_hp_win, miniwin.pos_bottom_left, miniwin.create_absolute_location, true)
	WindowCreate(partner_hp_win, partner_hp_win_info.window_left, partner_hp_win_info.window_top, partner_hp_win_width, partner_hp_win_height, partner_hp_win_info.window_mode, partner_hp_win_info.window_flags, 0x000010)
	movewindow.add_drag_handler (partner_hp_win, 0, 0, partner_hp_win_width, 30)
	WindowFont (partner_hp_win, FONT_NAME, "Arial", FONT_SIZE)

	WindowCircleOp (partner_hp_win, miniwin.circle_round_rectangle, 0, 2, partner_hp_win_width - 2, partner_hp_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)

	local left = 5
	local top = 10
	local title_leght = 28
	local titletarger_leght = 75
	local grid_lenght = 100
	local grid_height = 12
   --print(partner_hp_win,"test")

	WindowText (partner_hp_win, FONT_NAME, "伙伴"..partner.player_name.."信息",
					left+94, top, 0, 0,
					ColourNameToRGB ("white"), false)


	top = top + 15
    WindowText (partner_hp_win, FONT_NAME, "－－－－－－－－－－－－－－－－－－－－－",
                left, top, 0, 0,
                ColourNameToRGB ("gray"), false)
	top = top + 15

	-- 精神
    WindowText (partner_hp_win, FONT_NAME, "精血",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
	Fun_DrawGrid2(partner_hp_win, partner.jing, partner.jing_max, partner.jing_max*100/partner.jing_pre,
				left + title_leght, top + 1, grid_lenght, grid_height,
				0x40FF40, ColourNameToRGB("red"), ColourNameToRGB ("white"))
    WindowText (partner_hp_win, FONT_NAME, partner.jing.."/"..partner.jing_max.."("..partner.jing_pre.."%)",
                left + title_leght + grid_lenght + 2, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	-- 气血
    WindowText (partner_hp_win, FONT_NAME, "气血",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
	Fun_DrawGrid2(partner_hp_win, partner.qi, partner.qi_max, partner.qi_max*100/partner.qi_pre,
				left + title_leght, top + 1, grid_lenght, grid_height,
				0x40FF40, ColourNameToRGB("red"), ColourNameToRGB ("white"))
    WindowText (partner_hp_win, FONT_NAME, partner.qi.."/"..partner.qi_max.."("..partner.qi_pre.."%)",
                left + title_leght + grid_lenght + 2, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	-- 精力
    WindowText (partner_hp_win, FONT_NAME, "精力",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)

		Fun_DrawGrid(partner_hp_win, partner.jingli, partner.jingli_max,
					left + title_leght, top + 1, grid_lenght, grid_height,
					0xFFDA58, 0xFF6060)
		WindowText (partner_hp_win, FONT_NAME, partner.jingli.."/"..partner.jingli_max.."(+"..partner.jiajing..")",
					left + title_leght + grid_lenght + 2, top, 0, 0,
					0xFFDA58, false)


	top = top + 15

	-- 内力
    WindowText (partner_hp_win, FONT_NAME, "内力",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)

	Fun_DrawGrid(partner_hp_win, partner.neili, partner.neili_max,
					left + title_leght, top + 1, grid_lenght, grid_height,
					0xFFDA58, 0xFF6060)
	WindowText (partner_hp_win, FONT_NAME, partner.neili.."/"..partner.neili_max.."(+"..partner.jiali..")",
					left + title_leght + grid_lenght + 2, top, 0, 0,
					0xFFDA58, false)


	top = top + 15
    WindowText (partner_hp_win, FONT_NAME, "－－－－－－－－－－－－－－－－－－－－－",
                left, top, 0, 0,
                ColourNameToRGB ("gray"), false)
	top = top + 15

	-- 食物
    WindowText (partner_hp_win, FONT_NAME, "食物",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
	Fun_DrawGrid(partner_hp_win, partner.food, partner.max_food,
				left + title_leght, top + 1, grid_lenght, grid_height,
				0x58A7FF, ColourNameToRGB ("white"))
    WindowText (partner_hp_win, FONT_NAME, partner.food.."/"..partner.max_food,
                left + title_leght + grid_lenght + 2, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	-- 饮水
    WindowText (partner_hp_win, FONT_NAME, "饮水",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
	Fun_DrawGrid(partner_hp_win, partner.water, partner.max_water,
				left + title_leght, top + 1, grid_lenght, grid_height,
				0x58A7FF, ColourNameToRGB ("white"))
    WindowText (partner_hp_win, FONT_NAME, partner.water.."/"..partner.max_water,
                left + title_leght + grid_lenght + 2, top, 0, 0,
                0x40FF40, false)

	-- fullme后经过时间


	top = top + 15

	-- 潜能
    WindowText (partner_hp_win, FONT_NAME, "潜能",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
    WindowText (partner_hp_win, FONT_NAME, partner.pot.."/"..partner.max_pot,
                left + title_leght, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	-- 经验
    WindowText (partner_hp_win, FONT_NAME, "经验",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
    WindowText (partner_hp_win, FONT_NAME, partner.exps.."("..partner.exps_percent.."%)",
                left + title_leght, top, 0, 0,
                0x40FF40, false)

	WindowShow (partner_hp_win, true)
	movewindow.save_state(partner_hp_win)
   end]]
end


-- ------------------------------------
-- 绘制窗口
-- ------------------------------------
local MAX_LINES=30
local curor=1 --游标
local is_refresh=false
local callback_refresh=nil --回调函数
function status_win:skill_draw_win()
	--skill = skilltemp

	WindowCreate (skill_win, 0, 0, skill_win_width, skill_win_height, miniwin.pos_top_left, 0, 0x000010)
	local skill_win_info = movewindow.install (skill_win, miniwin.pos_top_left, miniwin.create_absolute_location, true)
	WindowCreate(skill_win, skill_win_info.window_left, skill_win_info.window_top, skill_win_width, skill_win_height, skill_win_info.window_mode, skill_win_info.window_flags, 0x000010)
	movewindow.add_drag_handler (skill_win, 0, 0, skill_win_width, 30)
	WindowFont (skill_win, FONT_NAME, "Arial", FONT_SIZE)

	-- 确定高度
	skill_win_height = 35+table.getn(self.skills)*15+15
	-- 最大高度
	skill_win_max_height=50+ MAX_LINES*15+7 --最大是 30项技能
    if skill_win_height>skill_win_max_height then
	    skill_win_height=skill_win_max_height
	end
	-- 绘制背景
	--WindowResize (skill_win, skill_win_width, skill_win_height, 0x000010)
	--WindowCircleOp (skill_win, miniwin.circle_round_rectangle, 0, 2, skill_win_width - 2, skill_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	-- add mouse wheel events
    WindowAddHotspot(skill_win, "Mouse_wheel",
                 skill_win_width-150,20, skill_win_width, skill_win_height,   -- rectangle
                 "",  -- mouseover
                 "",  -- cancelmouseover
                 "",  -- mousedown
                 "",  -- cancelmousedown
                 "",  -- mouseup
                 "",  -- tooltip text
                 miniwin.cursor_ns_arrow, 0)  -- hand cursor

    self:redraw_skill()

    --self.skills=nil
    WindowScrollwheelHandler (skill_win,"Mouse_wheel", "skill_wheel_updown")
	WindowShow (skill_win, true)
	movewindow.save_state(skill_win)
    callback_refresh=function(line)
	   local c=self:redraw_skill(line)
	   return c
	end
end

function status_win:redraw_skill(line)
	WindowRectOp (skill_win, miniwin.rect_fill, 0, 0, 0, 0, ColourNameToRGB ("black"))
	-- 绘制背景
	WindowResize (skill_win, skill_win_width, skill_win_height, 0x000010)
	WindowCircleOp (skill_win, miniwin.circle_round_rectangle, 0, 2, skill_win_width - 2, skill_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
  	local left = 5
	local top = 10
	local title_leght = 68
	local grid_off = title_leght + 30
	local grid_lenght = 100
	local grid_height = 12

	WindowText (skill_win, FONT_NAME, "技能最大等级限制："..self.max_level,
				left + 60, top, 0, 0,ColourNameToRGB ("white"), false)
	top = top + 15
	WindowText (skill_win, FONT_NAME, "－－－－－－－－－－－－－－－－－－－－－",
                left, top, 0, 0,
                ColourNameToRGB ("gray"), false)
	local function comps(a,b)
	   if a.level==b.level then
	      return a.name < b.name
       else
	       return a.level<b.level
	   end
    end

    table.sort(self.skills,comps)
	top = top + 15
        if line==nil then
		   line=1
		end
		if line>=table.getn(self.skills)- MAX_LINES+20 then
		   line= table.getn(self.skills)- MAX_LINES+20
		end
		for index,skillobj in ipairs(self.skills) do
           --print(index," index  ",line," 游标")
		   if index>=line and index<=MAX_LINES+line then
			 local color = ColourNameToRGB ("white")
			 if skillobj.level >= self.max_level then
				color = 0xFFDA58
			 else
				color = 0x40FF40
			 end
			 WindowText (skill_win, FONT_NAME, skillobj.name,
						left + title_leght - WindowTextWidth (skill_win, FONT_NAME, skillobj.name), top, 0, 0,
						color, false)
			 WindowText (skill_win, FONT_NAME, skillobj.level,
						left + title_leght + 2, top, 0, 0,
						color, false)
			 Fun_DrawGrid(skill_win, skillobj.pots, (skillobj.level+1)*(skillobj.level+1),
						left + grid_off, top + 1, grid_lenght, grid_height,
						color, ColourNameToRGB ("gray"))

			 top = top + 15
		  end
		end

    return line
end

function lines_refresh()
   --print("refresh 更新:",is_refresh)
  if is_refresh==false then
     return
  end
  local c=callback_refresh(curor)
  --print("返回值:",c)
  curor=c
  is_refresh=false
end

function skill_wheel_updown(flags, hotspot_id)

   if bit.band (flags, 0x100) ~= 0 then
    -- wheel scrolled down (towards you)
	-- print("wheel down")

	 --if curor<table.getn(self.skills)-MAX_LINES then
	     curor=curor+1
	 --else
	    -- curor=table.getn(self.skills)
	 --end

  else
    -- wheel scrolled up (away from you)
	 --print("wheel up")

	 if curor>1 then
	     curor=curor-1
	 else
	     curor=1 --顶部
	 end
  end -- if

  if is_refresh==false then
    is_refresh=true
	world.DoAfterSpecial (0.1, "lines_refresh()", 12)
  end
  return 0  -- needed for some languages
end

-- ------------------------------------
-- 绘制窗口
-- ------------------------------------
function status_win:task_draw_win()

	WindowCreate (task_win, 0, 0, task_win_width, task_win_height, miniwin.pos_top_left, 0, 0x000010)
	local task_win_info = movewindow.install (task_win, miniwin.pos_top_left, miniwin.create_absolute_location, true)
	WindowCreate(task_win, task_win_info.window_left, task_win_info.window_top, task_win_width, task_win_height, task_win_info.window_mode, task_win_info.window_flags, 0x000010)
	movewindow.add_drag_handler (task_win, 0, 0, task_win_width, 30)
	WindowFont (task_win, FONT_NAME, "Arial", FONT_SIZE)

	--print("绘制背景")
	WindowResize (task_win, task_win_width, task_win_height, 0x000010)
	WindowCircleOp (task_win, miniwin.circle_round_rectangle, 0, 2, task_win_width - 2, task_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)

	local left = 5
	local top = 10
	local title_leght = 68
	local grid_off = title_leght + 30
	local grid_lenght = 100
	local grid_height = 12

	WindowText (task_win, FONT_NAME, "当前任务："..self.task_name,
				left + 60, top, 0, 0,
				0x40FF40, false)
	top = top + 15

	local color = ColourNameToRGB ("white")
    WindowText (task_win, FONT_NAME, "当前步骤：",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
    WindowText (task_win, FONT_NAME, self.task_stepname,
                left + title_leght, top, 0, 0,
                0x40FF40, false)



	top = top + 15

    WindowText (task_win, FONT_NAME, "任务位置：",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
    WindowText (task_win, FONT_NAME, self.task_location,
                left + title_leght, top, 0, 0,
                0x40FF40, false)

	top = top + 15

	WindowText (task_win, FONT_NAME, "任务内容：",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)
    WindowText (task_win, FONT_NAME, self.task_description,
                left + title_leght, top, 0, 0,
                0x40FF40, false)
    top = top + 15


	WindowText (task_win, FONT_NAME, "进度：",
                left, top, 0, 0,
                ColourNameToRGB ("white"), false)

	WindowText (task_win, FONT_NAME, self.task_step..'/'..self.task_maxsteps,
						left + title_leght + 2, top, 0, 0,color, false)

	Fun_DrawGrid(task_win, self.task_step, self.task_maxsteps,
						left + grid_off, top + 1, grid_lenght, grid_height,
						color, ColourNameToRGB ("gray"))
	WindowShow (task_win, true)
	movewindow.save_state(task_win)
end

