
local equipment_win = "equipment_window"
local equipment_win_width = 260
local equipment_win_height = 50
-- 公用
local FONT_NAME = "f1"
local FONT_SIZE = "9"
local left = 5
local top = 10
local equipment_items={}
local getback_failure_weaponlist={}
special_item={
  new=function()
     local si={}
	 setmetatable(si,special_item)
	 return si
  end,
  num=1,
  version=1.8,
  my_weapons={},
  lost_my_weapons={},
  sp_co=nil,
  longxiang_dao=0,
  itemslist={},
  itemslistNum={},
  equipment_items=nil,
  getback_failure_weaponlist=getback_failure_weaponlist,
  weight=0,--负重
  repairweapon_list={},
  default_setting="<使用>残篇|<使用>精要|<使用>丸|<使用>丹|<使用>锦盒|<使用>秘函|<保存>倚天匠技残篇|<保存>珠宝商秘闻|<保存>幸运珍珠|<保存>田七鲨胆散|<保存>银票&0|<保存>白银&200|<保存>黄金&20|<保存>铜钱&200|<保存>玉|<使用>韦兰之锤|<丢弃>青铜|<丢弃>种子|<丢弃>棉花|<使用>传记"
  --default_setting="<使用>丸|<使用>丹|<使用>锦盒|<使用>秘函|<保存>倚天匠技残篇|<保存>珠宝商秘闻|<保存>幸运珍珠|<保存>田七鲨胆散|<保存>银票&0|<保存>白银&200|<保存>黄金&10|<保存>铜钱&200|<保存>玉|<使用>韦兰之锤|<丢弃>青铜<|丢弃>种子|<丢弃>棉花|<获取>雄黄|<出售>痘疹定论|<丢弃>石头|<丢失>石块|<保存>万年神铁|<保存>玄铁|<>保存>玉蚕丝",
}
special_item.__index=special_item
function special_item:cooldown()  --回调

end

function is_special_drug(drugname)
   --print("药品:",drugname)
   --赤 橙 黄 蓝 绿 紫 青 金 银 玉 飞 仙
   --豹 凤 虎 龙 竹 林 石 砂 水 肌
   --丹 丸
  --[[local wan1="黄水丹|玉豹丹|玉凤丸|飞竹丹|赤虎丹|仙竹丹|紫肌丹|蓝凤丹|蓝砂丸|银砂丸|黄凤丹|橙砂丹|玉砂丹|玉凤丹|紫龙丹|银肌丸"
   wan1=wan1 .."|青肌丹|金林丹|飞虎丸|仙肌丹|赤凤丹|玉肌丹|玉龙丸|金龙丹|紫肌丸|蓝竹丹|飞水丸|绿石丸|橙砂丸|黄水丸|紫虎丸"
   wan1=wan1 .."|金水丸|青凤丹|金石丸|绿砂丸|紫石丸|玉虎丸|黄龙丹|绿龙丹|紫石丹|黄林丹|仙豹丹|赤豹丹|蓝水丸|蓝林丸|仙虎丹|仙林丸"
   wan1=wan1 .."|仙竹丸|橙虎丸|黄砂丹|仙林丹|青凤丸|黄石丹|飞肌丸|仙龙丹|仙砂丹|飞龙丹|黄石丸|飞石丸|绿水丸|紫龙丸|金肌丹|橙水丸"
   wan1=wan1 .."|橙竹丹|黄竹丸|绿林丹|橙龙丸|玉林丹|橙肌丹|飞水丹|玉肌丸|飞豹丸|紫林丹|银凤丸|绿凤丹|橙竹丸|赤石丸|赤砂丸|赤龙丸|玉林丸|青虎丹|绿肌丹"
   local wan2="赤肌丸|仙石丸|飞肌丹|赤林丸|黄虎丹|银林丸|青砂丸|紫豹丹|金砂丸|银虎丸|仙豹丸"
   local wans={}
   wans=Split(wan1,"|")
   for _,w in ipairs(wans) do
      if drugname==w then
	    -- print("return true")
	     return true
	  end
   end]]
   local d1="赤橙黄蓝绿紫青金银玉飞仙"
   local d2="豹凤虎龙竹林石砂水肌"
   local d3="丹丸"
   if string.len(drugname)==6 then
      local a=string.sub(drugname,1,2)
      local b=string.sub(drugname,3,4)
	  local c=string.sub(drugname,5,6)
	  --print(a)
	  --print(b)
	  --print(c)
	  if string.find(d1,a) and string.find(d2,b) and string.find(d3,c) then
	     return true
	  end
   end
   return false
end

function special_item:infusion()  --内力灌注
  wait.make(function()
   world.Send("longxiang")
   local l,w=wait.regexp("你的内力不足，无法注入足够的内力！|^(> |)你脸上泛起一层隐隐的紫气，双手虚按十三龙象袈裟，把龙象内力注入袈裟之中。$|你潜运内功，努力把内力注入十三龙象袈裟，最后虽然成功但因为不是龙象内力而多花了点力气。|^(> |)你脸上泛起一层隐隐的紫气，双手虚按十三龙象袈裟，把龙象内力注入袈裟之中。$",5)
    if string.find(l,"你的内力不足") then
	   self:infusion_over()
	   return
	end
	if string.find(l,"努力把内力注入十三龙象袈裟") or string.find(l,"把龙象内力注入袈裟之中") then
       self:longxiang_jiasha()
	   return
	end
   wait.time(5)
  end)
end

function special_item:infusion_over()

end

function special_item:longxiang_jiasha_dao()
   wait.make(function()
	 local l,w=wait.regexp("袈裟之上已经注有(.*)道内力！$|^(> |)设定环境变量：look \\= \\\"YES\\\"$",5)
	 if l==nil then
	    self:longxiang_jiasha()
	    return
	 end
     if string.find(l,"设定环境变量：look") then

		if self.longxiang_dao<13 then
		   self:infusion()
		else
           self:infusion_over()
		end
		return
	 end
	 if string.find(l,"袈裟") then
	    local dao=w[1]
		print(dao.."道")
		self.longxiang_dao=ChineseNum(dao)
        self:longxiang_jiasha_dao()
		return
	 end
	 wait.time(5)
   end)
end

function special_item:longxiang_jiasha()
--你潜运内功，努力把内力注入十三龙象袈裟，最后虽然成功但因为不是龙象内力而多花了点力气。
--[[
十三龙象袈裟(Shisan longxiang)
这是一件喇嘛穿的袈裟，上面绣着些梵文，看似普通但却是大轮寺开寺始祖终身所穿的袈裟。
可能是因为它长时间被龙象内力笼罩，所以也似乎有了储存内力的功效。你可以试试注入内力(longxiang)。
袈裟之上已经注有十一道内力！

你的内力不足，无法注入足够的内力！
]]

  wait.make(function()
     world.Send("look shisan longxiang")
	-- world.Send("set look 1")
	 local  l,w=wait.regexp("^(> |)你要看什么？$|^(> |)十三龙象袈裟\\(Shisan longxiang\\)$",5)
	 if l==nil then
        self:longxiang_jiasha()
	    return
	 end
	 if string.find(l,"你要看什么") then
	    world.Send("wear pi")
		world.Send("wear cloth")
	    world.Send("wear pao")
		self:infusion_over()
	    return
	 end
	 if string.find(l,"十三龙象袈裟") then
		world.Send("set action 物品检查")
		self.longxiang_dao=0
	    self:longxiang_jiasha_dao()
	    return
	 end
	 wait.time(5)
  end)
end

function special_item:qu_gold(f,gold)
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
	    if gold==nil then
          world.Send("qu 50 gold")
		else
		  world.Send("qu "..gold.." gold")
		end
		local l,w=wait.regexp("^(> |)你从银号里取出.*锭黄金。$",5)
		print("金子")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold(f,gold)
		   return
		end
		if string.find(l,"你从银号里") then
		   --回调
		   --print("回调")
		   f()
		   return
		end
		wait.time(5)
	  end)
   end
   w:go(50)
end
--铁匠仔细的维修丽晶天火剑，总算大致恢复了它的原貌。
--你本次修理花费十九锭黄金八两白银。
function special_item:repair_ok()
   wait.make(function()
      local l,w=wait.regexp("^(> |)铁匠仔细的维修.*总算大致恢复了它的原貌。$",20)
	  if l==nil then
	    self:repair_ok()
	    return
	  end
	  if string.find(l,"总算大致恢复了它的原貌") then
	    self:check_items_next()
	    return
	  end
   end)
end
--local l,w=wait.regexp("^(> |)铁匠说道：「你带的零钱不够了！你需要(.*)锭黄金.*。」|铁匠说道：「你还没有装备武器。」|^(> |)你本次修理花费.*。$",5)

--[[

你将手一挥，一柄柔晶昆仑剑从身后飞出，电光一闪，已经握在了你手中。
> 你向铁匠打听有关『repair』的消息。
你本次修理花费四十一锭黄金七十六两白银。
铁匠开始仔细的维修柔晶昆仑剑，不时用铁锤敲敲打打......

>
你吸气入丹田，又缓缓吐出，逐渐收回了神元功力。
【谣言】某人：有人带着星月菩提在天龙寺一带出现！
您的资料已经自动保存好了。
铁匠仔细的维修柔晶昆仑剑，总算大致恢复了它的原貌。
]]
function special_item:tiejiang_repair_ok(weapon_id)
   wait.make(function()
     local l,w=wait.regexp("^(> |)铁匠说道：「你带的零钱不够了！你需要(.*)锭黄金.*修理费用。」|铁匠说道：「你还没有装备武器。」|^(> |)你本次修理花费.*$|^(> |)铁匠轻轻地拍了拍你的头。$|^(> |)铁匠仔细的维修柔晶昆仑剑，总算大致恢复了它的原貌。$",50)
     if l==nil then
	    self:tiejiang_repair(weapon_id)
	    return
	 end
	 if string.find(l,"你还没有装备武器") then
	    self:tiejiang_repair(weapon_id)
	    return
	 end
	 if string.find(l,"你带的零钱不够了") then
	    local needgold=ChineseNum(w[2])
		needgold=needgold+1
		local f=function()
		   self:tiejiang_repair(weapon_id)
		end
		self:qu_gold(f,needgold)
	   return
	 end
	 if string.find(l,"铁匠轻轻地拍了拍你的头") then
	    print("不需要修理")
		print("下一个")
		--local f=function()
         self:relogin()
		--self:check_items_next()
		--end
		--f_wait(f,0.1)
	    return
	  end
	 if string.find(l,"你本次修理花费") then
	    print("等待修复")
	    self:repair_ok()
		return
	 end
   end)
end

function special_item:tiejiang_repair(weapon_id)
 self.cooldown=function()
  local w=walk.new()
  w.walkover=function()
    wait.make(function()
     world.Send("wield "..weapon_id)
	 world.Send("ask tiejiang about repair")
	 local l,w=wait.regexp("你向铁匠打听有关『repair』的消息。",5)
	 if l==nil then
	   self:tiejiang_repair(weapon_id)
	   return
	 end
	 if string.find(l,"你向铁匠打听有关") then
	   self:tiejiang_repair_ok(weapon_id)
	   return
	 end
	 wait.time(5)
	end)
  end
  w:go(76)
  end
  self:unwield_all()
end


function special_item:weapon_repair(weapon_id)

--[[   丽晶天火剑(Tianhuo sword)
这是一柄由比较坚硬的金铁制成，重二十斤六两一钱的丽晶天火剑。
看起来比较锋利，具有水准以上的威力！
装备要求：臂力【二十五】，最大内力【零】，内力【四百五十六】
以及一排古篆字【 无最大内力要求 】
隐约能看见兵器制造者的姓名：韦兰铁匠(Weilan tiejiang)
看起来没有什么损坏。]]

    local now=os.time()
    --print(now,"检查")
	if special_item.repairweapon_list[weapon_id]~="" and special_item.repairweapon_list[weapon_id]~=nil then
	   local interval=os.difftime(now,special_item.repairweapon_list[weapon_id])
	   --print(interval,":秒",weapon_id," 刷新间隔600s!")
	   if interval<=600 then --10分钟
	       --print("换一个")
		   local f=function()
	          self:check_items_next()
		    end
		  f_wait(f,0.1)
		  return
	   end
    end
   wait.make(function()
     world.Send("look "..weapon_id)
	 world.Send("set action 武器检查")
	 local l,w=wait.regexp("^(> |)看起来没有什么损坏。$|^(> |)看起来已经使用过一段时间了。$|^(> |)看起来需要修理了。|^(> |)你要看什么？$|^(> |)设定环境变量：action \\= \\\"武器检查\\\"$",5)
	 if l==nil then
	   self:weapon_repair(weapon_id)
	   return
	 end
	 if string.find(l,"看起来没有什么损坏") then
	    print("weapon ok!!")
		--self:cooldown()
		local now=os.time()
		special_item.repairweapon_list[weapon_id]=now --更新时间
		self:check_items_next()
	    return
	 end
	 if string.find(l,"看起来已经使用过一段时间了") then
		print("weapon damage 1")
		--self:cooldown()
		self:check_items_next()
	    return
	 end
	 if string.find(l,"看起来需要修理了") then
	    print("weapon damage 2")
	    self:tiejiang_repair(weapon_id)
        return
	 end
	 if string.find(l,"你要看什么") then
	    --self:cooldown()
		self:check_items_next()
		return
	 end
	 if string.find(l,"设定环境变量：action") then
	    --self:cooldown()
		self:check_items_next()
	    return
	 end
   end)
end

local weapon_list={}
function special_item:unwield_all()
   weapon_list={}
  wait.make(function()
    world.Send("i")
	world.Send("remove glove")
	world.Send("set action unwield")
	--print("why")
	local l,w=wait.regexp("^(> |)你身上带著下列这些东西.*|^(> |)你身上带着.*件东西.*",5)
	if l==nil then
	  self:unwield_all()
	  return
	end
	if string.find(l,"你身上带着") or string.find(l,"这些东西") then
	   --print("taohua")
	   self:unwield_id()
	   return
	end
	wait.time(5)
  end)
end

function special_item:unwield_id()
--□锦虎披风(Jinhu pifeng)
 wait.make(function()
   local reg="^□(.*)\\((.*)\\)$|^(> |)设定环境变量：action \\= \\\"unwield\\\"$"
   --print(table.getn(weapon_list))
   --if table.getn(weapon_list)>0 then


	 local weapon_name_list=""
	 local weapon_id_list=""
    for _,r in pairs(weapon_list) do
	    weapon_name_list=weapon_name_list..r.name.."|"
		--weapon_id_list=weapon_id_list..r.id.."|"
       --reg=reg..r.."|"
    end
	--print(weapon_name_list,"??")
	if string.len(weapon_name_list)>0 then
	   weapon_name_list=string.sub(weapon_name_list,1,-2)
	   reg=reg .."|^(> |)(.*)(柄|把|支|只|株|棵|块).*"
	   	reg=reg.."("..weapon_name_list..")"
	   reg=reg.."\\((.*)\\)$"
	end

   local l,w=wait.regexp(reg,5)
   if l==nil then
      self:unwield_id()
	  return
   end
   if string.find(l,"□") then
     --print(w[1])
	 local item={}
	 item.name=string.sub(w[1],-2,-1)
	 item.id=string.lower(w[2])
	 weapon_list[item.name]=item
	 local id=string.lower(w[2])
	 world.Send("unwield "..id)
	 self:unwield_id()
	 return
   end
   if string.find(l,"柄") or string.find(l,"把") or string.find(l,"支") or string.find(l,"只") or string.find(l,"株") or string.find(l,"棵") or string.find(l,"块") then
     --print("复数判断")
     --print(w[4],w[5],w[6])
	 local num=Trim(w[5])
	 --print(w[7],"武器名")
	 local id= weapon_list[w[7]].id
	 --print(id)
	 local n=ChineseNum(num)
	 for i=2, n+1 do
	   world.Send("unwield "..id.." "..i)
	 end
	 self:unwield_id()
	 return
   end
   if string.find(l,"设定环境变量：action") then
      --print("结束")
	  self:cooldown()
	  return
   end
   wait.time(5)
 end)
end

function special_item:quick_check()  --快速检查
   world.Execute("drop qingtong;drop zhongzi;drop shitou;drop mianhua;drop head")
end

function special_item:check_items_over()
     self:draw_win()  --物品显示窗口
	 --print(os.date()) --检查处理速度
     special_item.sp_co=coroutine.create(function()
	     --print(table.getn(self.itemslist),"数目4")
		local deal_function
		local index
		for index,deal_function in pairs(self.itemslist) do
		  --print("继续3",index)

          local num=self.itemslistNum[index] --有具体物品数量
		  --print("具体物品数量",num)
		  if num~=nil then
		     deal_function(num)
			 --print("挂起")
			 --coroutine.yield()
		  else
		     deal_function()
		  end
		  --print("挂起")
	      coroutine.yield()
        end
		special_item.sp_co=nil
		equipment_items=nil
		getback_failure_weaponlist=nil
		--print(os.date())
		--print("处理结束")
		self:cooldown()
	 end)
	 --print(special_item.co)
	 coroutine.resume(special_item.sp_co)
end

function special_item:draw_win()
    WindowCreate (equipment_win, 0, 0,  equipment_win_width, equipment_win_height, miniwin.pos_bottom_left, 0, 0x000010)
	local equipment_win_info = movewindow.install(equipment_win, miniwin.pos_bottom_left, miniwin.create_absolute_location, true)
	WindowCreate(equipment_win, equipment_win_info.window_left, equipment_win_info.window_top, equipment_win_width, equipment_win_height, equipment_win_info.window_mode, equipment_win_info.window_flags, 0x000010)
	movewindow.add_drag_handler (equipment_win, 0, 0, equipment_win_width, 30)
	WindowFont (equipment_win, FONT_NAME, "Arial", FONT_SIZE)
	equipment_win_height = 35+table.getn(equipment_items)*15+15
	WindowResize (equipment_win, equipment_win_width, equipment_win_height, 0x000010)
    WindowCircleOp (equipment_win, miniwin.circle_round_rectangle, 0, 2, equipment_win_width - 2, equipment_win_height, 0xc0c0c0, 0, 1,0, 0, 9, 9)
	left = 5
	top = 10

	WindowText (equipment_win, FONT_NAME, "物品信息",
					left+94, top, 0, 0,
					ColourNameToRGB ("white"), false)


	top = top + 15
    WindowText (equipment_win, FONT_NAME, "－－－－－－－－－－－－－－－－－－－－－",
                left, top, 0, 0,
                ColourNameToRGB ("gray"), false)
	top = top + 15
	for _,i in ipairs(equipment_items) do
	     table.insert(self.equipment_items,i)
	     self:draw_items(i.name,i.id,i.num)
	end
	WindowShow (equipment_win, true)
	movewindow.save_state(equipment_win)
	equipment_items=nil
end


function special_item:update_items(name,id,num)

      local item={}
	  item.name=name
	  item.id=id
	  item.num=num
	  --print(name," ? ",id,"  ? ",num)
	  table.insert(equipment_items,item)
end

function special_item:draw_items(name,id,num)
    if string.find(name,"□") then
		color = ColourNameToRGB ("yellow")
	else
		color = 0x40FF40
	end
	WindowText (equipment_win, FONT_NAME, num.." "..name.."("..id..") ",
                left, top, 0, 0,
                color, false)

	top = top + 15
end


function is_containkey(filter_str,name_str)
   local filter=filter_str
   filter=string.gsub(filter,"{","")
   filter=string.gsub(filter,"}","")
   local f=Split(filter,",")
   for _,item in ipairs(f) do
	    --print("item",item," name_sr ",name_str)
       if name_str==item then
	       return true
	   end
   end
   return false
end

function special_item:check_item(items,flag)

   local regexp="^(> |)设定环境变量：action \\= \\\"物品检查\\\"$|^(> |)(.*)\\\((.*)\\\)$|^(> |)你身上带着.*件东西\\\(负重(.*)%\\\)："

   wait.make(function()
     local l,w=wait.regexp(regexp,5)
	 if l==nil then
	     world.Send("i")
         world.Send("set action 物品检查")
	     equipment_items={}
	     self.itemslist={}
	     self.itemslistNum={}
	     self:check_item(items,flag)
	    return
	 end
	 if string.find(l,"负重") then
	    local weight=Trim(w[6])
		self.weight=tonumber(weight)
		print("负重:",self.weight)
		self:check_item(items,true) --启动标志位
		return
	 end
	 if string.find(l,")") then
	   if flag==true then --启动标志位

	    local name=Trim(w[3])
		local id=string.lower(Trim(w[4]))
		local charnum=string.len(name)
		local num=""

		--print(name)
		local real_name=""
		local wield=""
		if string.sub(name,1,2)=="□" then
		     num="一"
			 real_name=string.gsub(name,"□","")
			 wield="□"
			 if string.find(name,"二块阴阳九龙令") then
			   num="二"
			   real_name="阴阳九龙令"
			 end
		else
		   for i=1,charnum,2 do
		    local c= string.sub(name,i,i+1)
		    if c=="零" or c=="一" or c=="二" or c=="三" or c=="四" or c=="五" or c=="六" or c=="七" or c=="八" or c=="九" or c=="十" or c=="百" or c=="千" or c=="万" or c=="亿" then
		       num=num .. c
			else
			  if num=="" then
			    real_name=string.sub(name,i,-1)
			  else
		        real_name=string.sub(name,i+2,-1)
			  end
		      break
            end
	  	  end
		end
		--print("real_name "..real_name)
		if num=="" then
		     num=1
		else
			 num=ChineseNum(num)
		end
		--print(real_name," ",num)
		-- 物品显示
		--
		self:update_items(wield..real_name,id,num)
         --self:draw_items(wield..real_name,id,num)
		for index,i in ipairs(items) do
		   --print(i.name," ? ",name,id,num,i.filter)
		   --出售物品
		   local used=string.match(i.name, "<.*>") --获取用途
		   local i_equip_name=string.gsub(i.name, "<.*>", "") --去除功能字符 -<出售>
		    i_equip_name=string.gsub(i_equip_name,"+","") --去掉+号
			name=string.gsub(name,"+","")
		   local s,e=string.find(name,i_equip_name)


		   --print(i_equip_name,"? <> ",name)
		   --print(string.find(name,i_equip_name), "is_ok")
		  if (string.lower(i_equip_name)==id or string.len(name)==e) and (not is_containkey(i.filter,real_name) or i.filter=="") then
		     --print("持有")
			 --print(i.name," ? ",name,id,num,i.filter)
			 if i.totle_num==nil then
				i.totle_num=num
			 else
				i.totle_num=i.totle_num+num  --复合条件数量
			 end
			 local hold=function(sum_num)
			    --print("hold了",sum_num)
			    --print(id,"id",real_name)
			    i.hold(i.totle_num,real_name,id,sum_num)
			  end
			  --print("插入1",hold)
			  local index=real_name..id..used --真实名字id用途
			  --print(index," index")
			  self.itemslist[index]=hold
			  if self.itemslistNum[index]==nil then  --保存相同id 名称的 物品数量
			     self.itemslistNum[index]=num
			  else
			     self.itemslistNum[index]=self.itemslistNum[index]+num
			  end
			 --table.remove(items,index)
			 --break
		  end
		end
		    self:check_item(items,flag)
		else
		    self:check_item(items,flag)
		end
		return
	 end
	 if string.find(l,"设定环境变量：action") then
	     --print("结束")
		 --print("缺少",table.getn(items))
		  --print(os.date())
		 --print("i start deal")

		 for _,i in ipairs(items) do
		    if i.totle_num==nil then
		      local lost=function()
			     --print("丢失")
			     i.lost()
			  end
			  --print("插入2",lost)
			  table.insert(self.itemslist,lost)
			end
		 end
		 self:check_items_over()
	    return
	 end
   end)
end

function special_item:sell_over(id,num)
   wait.make(function()
       local l,w=wait.regexp("^(> |)你以.*的价格卖掉了.*给当铺老板。$|^(> |)什么？$|^(> |)当铺老板说道：「.*不值钱，你卖给我也没用。」$|^(> |)当铺老板说道：「新手武器禁止卖店」$|^(> |)你要卖什么？$|^(> |)当铺老板说道：「这种东西我不识货，不敢要。」$|^(> |)当铺老板说道：「这样的宝物我可买不起。」$|^(> |)哟，抱歉啊，我这儿正忙着呢……您请稍候。$|^(> |)当铺老板说道：「小的只有一个脑袋，可不敢买少林庙产。」$|^(> |)什么.*$",10)
	   if l==nil then
	      world.Send("sell "..id)
		  self:sell_over(id,num)
	      return
	   end
		if string.find(l,"我这儿正忙着呢")  then
		   local f=function()
	          world.Send("sell "..id)
	          self:sell_over(id,num)
		   end
		   f_wait(f,0.5)
		  return
	   end
	   if string.find(l,"给当铺老板") then
		  num=num-1
	      if num==0 then
		    world.Send("wear all")
			--BigData:catchData(84,"当铺")
			self:check_items_next()
		  else
		   local f=function()
		      world.Send("sell "..id)
	          self:sell_over(id,num)
		   end
		   f_wait(f,0.8)
		  end
		  return
	   end
       if string.find(l,"新手武器禁止卖店") or string.find(l,"你要卖什么") or string.find(l,"这种东西我不识货，不敢要")  or string.find(l,"这样的宝物我可买不起")  then
		  --BigData:catchData(84,"当铺")
		  self:check_items_next()
	      return
	   end
	   if string.find(l,"什么") then
	       self:sell_item(id,num)
		  return
	   end
	   if string.find(l,"你卖给我也没用") or string.find(l,"可不敢买少林庙产") then
	      local b=busy.new()
		  b.Next=function()
		     world.Send("drop "..id)
			 world.Send("wear all")
			 self:check_items_next()
		  end
		  b:check()
	      return
	   end
   end)
end

function special_item:sell_item(id,real_num,setup_num,same_num)
   local num=0
   --print(real_num," ? ",same_num," setup_num:",setup_num)
   if real_num==same_num then  --物品数量一致
       num=real_num-setup_num+1
   end

   local w=walk.new()
   w.walkover=function()
      world.Send("sell "..id)
      self:sell_over(id,num)
   end
   w:go(84)
end

function special_item:convert_money(num,id)
      world.Send("cun "..num.." "..id)
	  world.Send("set action 存钱")
	    --BigData:catchData(bank_roomno,"天阁斋")
		--您目前已有存款三万零九百六十二锭黄金四十七两白银五十文铜钱，再存那么多的钱，小号可难保管了。
		--> 钱善人说道：“哟，抱歉啊，我这儿正忙着呢……您请稍候。”
	  wait.make(function()
		--BigData:Auto_catchData()
		local l,w=wait.regexp("^(> |)您目前已有存款.*再存那么多的钱，小号可难保管了。$|^(> |)你拿出.*存进了银号。$|^(> |).*哟，抱歉啊，我这儿正忙着呢.*您请稍候。”$|^(> |)设定环境变量：action \\= \\\"存钱\\\"",10)
		if l==nil then
		   self:convert_money(num,id)
		   return
		end
		if string.find(l,"小号可难保管了") then

		  local b=busy.new()
	      b.Next=function()
		    world.Send("convert "..num.." "..id.." to cash")
	        local f=function()
			  self:check_items_next()
			end
			f_wait(f,2)
	      end
	      b:check()
		   return
		end
		if string.find(l,"您请稍候") then
		  local f=function()
		    self:convert_money(num,id)
		  end
		  f_wait(f,1)
		   return
		end
		if string.find(l,"存进了银号") or string.find(l,"设定环境变量") then
	      local b=busy.new()
	      b.Next=function()
	       self:check_items_next()
	      end
	      b:check()
		end

	  end)

end

function special_item:save_money(id,real_num,setup_num)  --id 真正数量 设置数量

 local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --根据当前位置 前往最近的钱庄
--{大理 410} {塘沽 1474} {扬州 50} {成都 546} {西域 1973} {苏州 1069} {杭州 1119} {福州 1331} {长安 926} {兰州城}
      local count,roomno=Locate(_R)
	  print("当前房间号",roomno[1])
	  local bank_roomno
	  local index=zone(_R.zone)
	  if index==1 then
	     bank_roomno=1331
	  elseif index==2 then
	     bank_roomno=1331
	  elseif index==3 or roomno[1]==767 then
	     --224 or 50 or 926
		 local r=math.random(1,3)
		 local _room={224,50,926}
		 if roomno[1]==50 or roomno[1]==224 or roomno[1]==926 then
		    bank_roomno=roomno[1]
		 else
		    bank_roomno=_room[r]
		 end
	  elseif index==4 then
	     bank_roomno=410
	  elseif index==5 or roomno[1]==1479 then
	     bank_roomno=1474
	  elseif index==6 then
	     bank_roomno=1973
	  else
	     bank_roomno=926
	  end
	  if roomno[1]==1573 then
	     bank_roomno=926
	  elseif roomno[1]==1574 then
	     bank_roomno=1973
	  end
	  print(bank_roomno," 银行")
	 local num=real_num-setup_num
     if num==0 then num=1 end
     if setup_num>=50 and num==1 then --防止存的太少 来回存钱
       num=30
     end
     local w=walk.new()
     w.walkover=function()
        self:convert_money(num,id)
    end
    w:go(bank_roomno)
   end
  _R:CatchStart()


end

function special_item:save_item(id,real_num,setup_num)  --id 真正数量 设置数量
   if id=="gold" or id=="silver" or id=="coin" or id=="cash" or id=="thousand-cash" then
	  self:save_money(id,real_num,setup_num)  --id 真正数量 设置数量
      return
   end
   local w=walk.new()
   w.walkover=function()
      world.Send("cun "..id)
	  local b=busy.new()
	  b.Next=function()
	     self:check_items_next()
		-- world.AppendToNotepad (WorldName(),os.date()..": 物品保存 "..id.." \r\n")
	  end
	  b:check()
   end
   w:go(94)
end

function special_item:drop(id,real_num,setup_num,same_num)
   -- print(id," ",real_num," ? ",same_num," setup_num:",setup_num)
    local num=0
   if real_num==same_num then  --物品数量一致
       num=real_num-setup_num+1
   else
	   num=1
   end
   local i
   --print("test")
   if id=="falun" then --法轮是可以层叠的必须加上数量
     local drop_num=num-1
	 if drop_num>0 then
       world.Send("drop "..drop_num.." "..id)
     end
   else
     for i=1,num,1 do
       world.Send("drop "..id)
     end
   end
   world.Send("wear all")
   self:check_items_next()
end

function special_item:items(name,item_id)
   local items={}
   items["十三龙象袈裟"]=function()
        self.infusion_over=function()
			self:check_items_next() --下一个
		end
		self:longxiang_jiasha()
   end
   items["牛皮酒袋"]=function()
		local party=world.GetVariable("party") or ""
		if party=="嵩山派" then
	       self.hanjianshenjian_over=function()
		      self:check_items_next() --下一个
		   end
	       self:fill_jiudai()
		else
		   self:check_items_next() --下一个
		end
   end
   items["精要"]=function()
		local f=function()
			self:readbook(item_id)
		end
		f_wait(f,0.1)
	end
	items["丸子"]=function()
	    local f=function()
		     self:eat(item_id)
		end
		f_wait(f,0.1)
	end
	items["锦盒"]=function()
			 local _equip=equipments.new()
			 _equip.finish=function(item_name,item_id,get_ok)  --get 完毕
				self:check_items_next() --下一个
		     end
			 _equip:jinhe()
	end
	items["秘函"]=function()
		local _equip=equipments.new()
	     _equip.finish=function(item_name,item_id,get_ok)  --get 完毕
			self:check_items_next() --下一个
		end
		_equip:mihan(item_id)
	end
    items["韦兰之锤"]=function()
		local _equip=equipments.new()
	     _equip.finish=function(item_name,item_id,get_ok)  --get 完毕
			self:check_items_next() --下一个
		end
		_equip:weilan()
	end

    items["传记"]=function()
		local _equip=equipments.new()
	     _equip.finish=function(item_name,item_id,get_ok)  --get 完毕
			self:check_items_next() --下一个
		end
		_equip:zhuanji()
	end
	local z=items[name]
	if z==nil then
	    local f=function()
			self:check_items_next()
		end
		f_wait(f,0.1)
	else
	    z()
	end
end

function special_item:use_item(item_name,item_id,i_equip_name)
      --print("使用2",item_name,item_id,i_equip_name)
	  --print("丹药",is_special_drug(item_name))
	   local _item
		_item=item_name
	   if (string.find(item_name,"精要") or string.find(item_name,"残篇")) and not string.find(item_name,"匠技残篇") then
	        _item="精要"
	   end

	   if (string.find(item_name,"丹") or string.find(item_name,"丸")) and (is_special_drug(item_name) or string.find(i_equip_name,item_name)) then
	       --print("丸子")
 		    _item="丸子"
	   end
	   if string.find(item_name,"锦盒") then
	      _item="锦盒"
	   end
	    if string.find(item_name,"秘函") then
	      _item="秘函"
	   end
		if string.find(item_name,"传记") then
	      _item="传记"
	   end
	   self:items(_item,item_id)
end


function special_item:hanjian_shenjian()
  wait.make(function()
     world.Send("look hanbing shenjian")
	 local  l,w=wait.regexp("^(> |)你要看什么？$|^(> |)寒冰神剑\\(Hanbing shenjian\\)$",5)
	 if l==nil then
        self:hanjian_shenjian()
	    return
	 end
	 if string.find(l,"你要看什么") then
		   self:hanjian()
	    return
	 end
	 if string.find(l,"寒冰神剑") then
	   world.Send("drop hanbing shenjian 2")
	   world.Send("wield sword")

	    -- local quest=quest.new()
		 --  quest:wuyue()

		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	       self:hanjianshenjian_over()
	       end
		   b:check()
	    return
	 end
	 wait.time(5)
  end)
end

function special_item:fill_jiudai()
   local w
   w=walk.new()
   w.walkover=function()
      world.Send("yun hanbing")
      world.Send("fill jiudai")
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
		 self:hanjian_shenjian()
		 end
	  b:check()
   end
   w:go(120)
end

function special_item:hanjian()  --运寒冰
  wait.make(function()
      world.Send("unwield sword")
		  world.Send("yun hanjian jiudai")
   local l,w=wait.regexp("^(> |)寒冰诀运用当中，你不能施用内功。$|^(> |)你还没有运行寒冰真气于周身，如何使用寒冰神剑？$|^(> |)你的内力不够，无法施展「寒冰神剑」$|^(> |)你将寒冰真气注入牛皮酒袋之中，同时用内力将清水逼出牛皮酒袋，霎时形成了一柄寒冰神剑。$|^(> |)你现在手里不是有兵器吗？还造剑干吗？$|^(> |)寒冰神剑没有了寒冰真气的支持，崩裂为无数的碎片，飘散在空中。$",5)
    if string.find(l,"你的内力不够") or string.find(l,"你现在手里不是有兵器吗") or string.find(l,"你还没有运行寒冰真气于周身") then
	   self:hanjianshenjian_over()
	   return
	end
	if string.find(l,"寒冰诀运用当中，你不能施用内功")  then
	   self:fill_jiudai()
	   return
	end
	if string.find(l,"你将寒冰真气注入.*酒袋之中")  then
       local b1=busy.new()
	        b1.interval=0.5
	         b1.Next=function()
	           world.Send("drop hanbing shenjian 2")
	           world.Send("wield sword")
	           world.Send("yun hanbing")
	           self:hanjianshenjian_over()
	         end
	         b1:check()
	   return
	end
   wait.time(5)
  end)
end

function special_item:readbook(id)

   world.Send("read "..id)
   world.Send("drop "..id)
   local b=busy.new()
	  b.Next=function()
	     self:check_items_next()
	  end
	  b:check()
end

function special_item:eat(id)
   if id=="yuji wan" then id="wan" end
   world.Send("fu "..id)
   world.Send("eat "..id)
   local b=busy.new()
	  b.Next=function()
	     self:check_items_next()
	  end
	  b:check()

end

function special_item:check_items(equip,default)
    local items={}
	if default==true then
	   local setting={}
	   setting=Split(self.default_setting,"|")
	   for _,s in ipairs(setting) do
	      table.insert(equip,s)
	   end
	end
	-- 去除重复内容
	local items_record={}
    for _,eq in ipairs(equip) do
		  local _wanted=Split(eq,"&")
	      local _item={}
		  local name=_wanted[1]
		  --排除 ！
		  local names=Split(name,"~")
		  name=names[1]
		  local filter=names[2] or ""
          --print(filter)
		  _item.name=string.lower(name)
		  _item.filter=filter
		  local num=1
		  if _wanted[2]~=nil then
		   num=assert(tonumber(_wanted[2])) or 1
		  end
		  _item.num=num
		   --print("数量",num)
		   if _item.num==nil then
		       _item.num=1
		   end
		   if _item.num<=0 then
			  _item.num=1
		   end
           --print(_item.name)
		  _item.hold=function(n,real_item_name,item_id,sum_num) --符合匹配的物品数量(剑 符合匹配的 二把长剑 暗金剑 轩辕剑 共计4) 物品中文全称 物品英文id  物品数量(长剑2 暗金剑1 轩辕剑1)
               --print(n,"?<=",sum_num,"  ",_item.name)
			  if _item.num~=nil then
			     if n<_item.num then --数量少 get
				    --print("get 数量少")
				     --_Get(_item.name)
					 self:handle(_item.name,nil,nil,_item.filter,n,_item.num,sum_num)
				 else
					 self:handle(_item.name,real_item_name,item_id,_item.filter,n,_item.num,sum_num) --有足够数量  --n 实际数量 _item.num设置数量
				 end
			  else
			     self:handle(_item.name,real_item_name,item_id,_item.filter,n,1,sum_num)
			  end
		  end
	 	  _item.lost=function()
		      --print("lost")
			  if _item.num==nil then
			     _item.num=1
			  end
              self:handle(_item.name,nil,nil,_item.filter,0,_item.num,0)
		  end
		  if items_record[_item.name]==nil then
		     table.insert(items,_item)
			 items_record[_item.name]="ok"
		  end
	end
	 world.Send("i")
     world.Send("set action 物品检查")
	 equipment_items={}
	 self.equipment_items={}
	 self.itemslist={}
	 self.itemslistNum={}
	 self:check_item(items)
end

function special_item:check_items_next()
    --print("继续",special_item.co)
   coroutine.resume(special_item.sp_co)
end

function special_item:relogin()
   self:check_items_next()  --物品丢失重新连接
end

function special_item:recheck(item_name,item_id)
    print(item_name,item_id)
	self:check_items_next()
end

function special_item:safe_room(item_name,item_id)

 --跑城隍庙
   local w=walk.new()
   w.walkover=function()
      world.Send("look")
	  world.Send("set action leave")
      local l,w=wait.regexp(".*城隍庙.*|^(> |)设定环境变量：action \\= \\\"leave\\\".*",3)
	  if l==nil then
	     self:safe_room()
		 return
	  end
	  if string.find(l,"设定环境变量：action") then
	     self:safe_room()
	     return
	  end
	  if string.find(l,"城隍庙") then
	     --self:check_items_next()
		 self.recheck(item_name,item_id)
		 return
	  end
   end
   w:go(53)
end

local function get_weapon_id(name)
    local weapon_id
   local weapon_type=string.sub(name,-2,-1)
   if weapon_type=="锤" then
      weapon_id="hammer"
   elseif weapon_type=="轮" then
      weapon_id="falun"
   elseif weapon_type=="枪" then
      weapon_id="spear"
   elseif weapon_type=="剑" then
      weapon_id="sword"
	elseif weapon_type=="刀" then
	   weapon_id="blade"
    elseif weapon_type=="棒" then
	   weapon_id="stick"
    elseif weapon_type=="棍" then
	    weapon_id="club"
    elseif weapon_type=="首" then
		weapon_id="dagger"
	elseif weapon_type=="箫" then
	     weapon_id="xiao"
	elseif weapon_type=="杖" then
       weapon_id="staff"
    elseif weapon_type=="斧" then
      weapon_id="axe"
   elseif weapon_type=="笔" then
      weapon_id="bi"
   elseif weapon_type=="铙" then
      weapon_id="nao"
   elseif weapon_type=="鞭" or weapon_type=="幡" then
      weapon_id="whip"
   end
   return weapon_id
end

function special_item:getback_lostweapon(name)
  --刚才是否死亡
  --是否是死亡导致武器丢失
   local is_omit=special_item.getback_failure_weaponlist[name]
   if is_omit==nil then
      is_omit=false
   end
   special_item.getback_failure_weaponlist[name]=true
   local newdie=world.GetVariable("newdie") or ""
   if newdie=="true" then

      world.DeleteVariable("newdie")
	  _G["fight_Roomno"]=nil
	  --需要排除掉这个选项
	  local f2=function()
	     self:check_items_next()
	  end
	  f_wait(f2,0.1)
	  return
   end
   world.Send("alias pfm") --删除pfm
   local f=_G["fight_Roomno"] --在战斗中脱落的武器 保留的最后战斗房间
   -- f=50
    local r={}
	table.insert(r,f)
    _G["fight_Roomno"]=nil
	print("roomno",f)
   if f==nil or f=="" or is_omit==true then
	   local f2=function()
	     self:check_items_next()
	   end
	   f_wait(f2,0.1)
	else
	  local w=walk.new()
	  local dx={}
	  dx=w:random_exits(r)

	  local g_dx=""
	  for _,i in ipairs(dx) do

	      g_dx=i.direction
		   print("脱离方向!",g_dx)
		  break
	  end
	  w.walkover=function()
         local weapon_id=get_weapon_id(name)
	     world.Send("get "..weapon_id)
		 world.Send("halt")
		 world.Send("alias pfm halt;get "..weapon_id..";"..g_dx..";set action 逃跑")
	     world.Send("set wimpy 100")
	     world.Send("set wimpycmd pfm\\hp")
		 world.Send(g_dx)
		 self:safe_room(name)
		 --world.Send("go away")
		 --self:finish()
		 --self:recheck(name,id,num)
	  end
	  w:go(f)
   end
end

function special_item:handle(i_equip_name,item_name,item_id,filter,real_num,setup_num,same_num)  ---filter 过滤条件
    --print("装备",i_equip_name,item_name,item_id,filter)
 --基本功能
   --获取 装备 使用 保存 出售 丢弃
   if string.find(i_equip_name,"<获取>") and item_name==nil and item_id==nil then
            --print("获取")
			 local id=string.gsub(i_equip_name,"<获取>","")
			 local id=string.lower(id)
			 --print(id)
			 local _equip=equipments.new()
			 _equip.finish=function(item_name,item_id,get_ok)  --get 完毕
			   --print(item_name,item_id,get_ok,"?")
			   if get_ok==true then
			      --print("ok")
			      self.recheck(item_name,item_id)
			   else
				  local f=function()
		             self:check_items_next()
				  end
			      f_wait(f,0.3)
			   end
		     end
			 --print("auto get"," setup ",setup_num," r",real_num," same_num", same_num)
			 if setup_num==nil then
			    setup_num=0
			 end
			 if real_num==nil then
			    real_num=0
			 end
			 --print(setup_num,real_num)
			 _equip:auto_get(id,setup_num-real_num)
   elseif string.find(i_equip_name,"<使用>") and item_name~=nil and item_id~=nil then
       -- print("使用1")
		if is_containkey(filter,item_name) then
		--物品名称和过滤条件符合 直接跳过不处理
		    local f=function()
			   self:check_items_next()
		    end
		    f_wait(f,0.1)
		else
            local f=function()
		       self:use_item(item_name,item_id,i_equip_name)
			end
	        f_wait(f,0.1)
	    end
   elseif string.find(i_equip_name,"<保存>") and item_name~=nil and item_id~=nil then
       if filter=="[普通药物]"  then  --保存药物
	        if is_special_drug(item_name)==true then
	           local f=function()
		         self:save_item(item_id,real_num,setup_num)
			   end
	           f_wait(f,0.1)
		   else
		       local f=function()
			     self:check_items_next()
		       end
		       f_wait(f,0.1)
		    end
       elseif is_containkey(filter,item_name) then
		--物品名称和过滤条件符合 直接跳过不处理
		    local f=function()
			   self:check_items_next()
		    end
		    f_wait(f,0.1)
		else
            local f=function()
		       self:save_item(item_id,real_num,setup_num)
			end
	        f_wait(f,0.1)
	    end
   elseif string.find(i_equip_name,"<出售>") and item_name~=nil and item_id~=nil then
         --print("出售",i_equip_name,item_name,item_id," 实际:",real_num," 设置:",setup_num)
        if is_containkey(filter,item_name) then
		--物品名称和过滤条件符合 直接跳过不处理
		    --print("跳过")
		    local f=function()
			   self:check_items_next()
		    end
		    f_wait(f,0.1)
		else
           --print("出售"," 实际数量:",real_num," 设置数量:",setup_num)
		   local f=function()
			   self:sell_item(item_id,real_num,setup_num,same_num)
	   	   end
		   f_wait(f,0.1)
	   end
   elseif string.find(i_equip_name,"<丢弃>") and item_name~=nil and item_id~=nil then
         --print("丢弃",i_equip_name,item_name,item_id,filter)
        if is_containkey(filter,item_name) then
		--物品名称和过滤条件符合 直接跳过不处理
		    local f=function()
			   self:check_items_next()
		    end
		    f_wait(f,0.1)
		else
          local f=function()
		  	 self:drop(item_id,real_num,setup_num,same_num)
		   end
		   f_wait(f,0.1)
		end
	elseif string.find(i_equip_name,"<存在>") and item_name==nil and item_id==nil then --mark 物品 物品丢失
		print("我的weilan武器丢失")
		print("180s以后重新连接")
		sj.log_catch(WorldName()..'武器丢失记录',900)
		sj.world_init=function()
			print("重新连接，检查MY物品！！！")
			self:relogin()
		end
		local b=busy.new()
		b.Next=function()
			relogin(180,false)
		end
		b:check()
	elseif string.find(i_equip_name,"<捡回>") then
	    if item_name==nil and item_id==nil then --mark 物品 物品丢失
		   print("捡回我的weilan武器")
		   local equip_name=string.gsub(i_equip_name,"<捡回>","")
		   self:getback_lostweapon(equip_name)
		else
           --print(item_name.." () "..item_id)
		  local equip_name=string.gsub(i_equip_name,"<捡回>","")
		  --print(equip_name," 捡回装备存在！")
		   special_item.getback_failure_weaponlist[equip_name]=false
		   local f=function()
			self:check_items_next()
		   end
		   f_wait(f,0.1)
		end
	elseif string.find(i_equip_name,"<自动修理>") and item_name~=nil and item_id~=nil then
	    self:weapon_repair(item_id)

	elseif string.find(i_equip_name,"<人工修理>") and item_name~=nil and item_id~=nil then
		self:check_equipment(item_name,item_id)
    else
		local f=function()
			self:check_items_next()
		end
		f_wait(f,0.1)
   end
end

--------------
--你以六十六两白银又六十七文铜钱的价格从大理小贩那里买下了一柄铁锤。
function special_item:buy_fromxiaofan(tools_id,itemid)
   --print("test")
   wait.make(function()
      --world.Send("list")
		--world.Send("buy "..tools_id)
		local l,w=wait.regexp("^(> |)你以.*的价格从.*那里买下了一(把|柄)(.*)。$|^(> |)大理小贩说道：「穷光蛋，一边呆着去！」$|^(> |)设定环境变量：action \\= \\\"购买\\\"$",10)
		if l==nil then
		   coroutine.resume(special_item.sp_co)
		   return
		end
		if string.find(l,"穷光蛋，一边呆着去") then

		local f=function()
			self:buy_tools(tools_id,itemid)
		end
		qu_gold(f,5,410)
		  return
		end
		if string.find(l,"设定环境变量：action") then
		  -- print("why")
		   wait.time(1)
		   coroutine.resume(special_item.sp_co)
		   return
		end
		if string.find(l,"那里买下了") then
		   world.Send("follow none")
		   if w[3]=="剪刀" then
			   self:self_repair_armor(itemid)
		   else
               self:self_repair_weapon(itemid)
		   end
		   return
		end

   end)
end
--[[
function special_item:follow_xiaofan(tools_id,itemid)
  world.Send("follow dali xiaofan")
  wait.make(function()
     local l,w=wait.regexp("^(> |)这里没有 dali xiaofan。$|^(> |)你决定跟随大理小贩一起行动。$|^(> |)你已经这样做了。$",5)
	 if l==nil then
	    self:follow_xiaofan(tools_id,itemid)
	    return
	 end
     if string.find(l,"这里没有") then
	    coroutine.resume(special_item.sp_co)
	    return
	 end
	 if string.find(l,"你决定跟随大理小贩一起行动") or string.find(l,"你已经这样做了") then
	    world.Send("say 我已书剑城管名义宣布你为乱设摊典型代表！")
		self:buy_fromxiaofan(tools_id,itemid)
	 end
  end)
end]]

function special_item:buy_tiechui(tools_id,itemid)
 local cmd="buy "..tools_id
   local route={}
    table.insert(route,"ne;"..cmd..";sw;"..cmd..";n;"..cmd..";s;"..cmd..";s;"..cmd..";set action 购买")
    table.insert(route,"n;"..cmd..";e;"..cmd..";e;"..cmd..";w;"..cmd..";w;"..cmd..";set action 购买")
	table.insert(route,"w;"..cmd..";n;"..cmd..";s;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";n;"..cmd..";w;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"n;"..cmd..";n;"..cmd..";s;"..cmd..";set action 购买")
	table.insert(route,"w;"..cmd..";n;"..cmd..";s;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";n;"..cmd..";w;"..cmd..";set action 购买")
	table.insert(route,"n;"..cmd..";s;"..cmd..";s;"..cmd..";set action 购买")
	table.insert(route,"n;"..cmd..";set action 购买")
    local w=walk.new()
	w.walkover=function()
	 special_item.sp_co=coroutine.create(function()

	    for _,r in ipairs(route) do
		  self:buy_fromxiaofan(tools_id,itemid)
          world.Execute(r)
	      coroutine.yield()
		end
		--
		--[[结 束 重新搜索
		local f=function()
		   self:buy_tools(tools_id,itemid)
		end]]
		if tools_id=="tiechui" then
		   self:self_repair_weapon(itemid)
		else
		   self:self_repair_armor(itemid)
		end
		--print("间隔2s")
		--f_wait(f,2)
	 end)

	 coroutine.resume(special_item.sp_co)
	end
	w:go(75)
end

function special_item:buy_tools(tools_id,itemid)
   local cmd="buy "..tools_id
   local route={}
    table.insert(route,"e;"..cmd..";n;"..cmd..";s;"..cmd..";e;"..cmd..";w;"..cmd..";set action 购买")
    table.insert(route,"s;"..cmd..";e;"..cmd..";w;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action 购买")
	table.insert(route,"s;"..cmd..";n;"..cmd..";e;"..cmd..";s;"..cmd..";n;"..cmd..";e;"..cmd..";set action 购买")
    local w=walk.new()
	w.walkover=function()
	 special_item.sp_co=coroutine.create(function()

	    for _,r in ipairs(route) do
		  self:buy_fromxiaofan(tools_id,itemid)
          world.Execute(r)
	      coroutine.yield()
		end
		--
		--[[结 束 重新搜索
		local f=function()
		   self:buy_tools(tools_id,itemid)
		end]]
		if tools_id=="tiechui" then
		   self:self_repair_weapon(itemid)
		else
		   self:self_repair_armor(itemid)
		end
		--print("间隔2s")
		--f_wait(f,2)
	 end)

	 coroutine.resume(special_item.sp_co)
	end
	w:go(435)
--Tiechui
--Jian dao
--435
 --e;n;s;e;w;
 --s;e;w;w;e;
 --s;w;e
 --s;w;e
 --s;w;e
 --s;w;e
 --s;w;e
 --s;w;e
 --s;w;e
 --s;n;e;s;n;e
  --[[ local rooms={}
   table.insert(rooms,427)
   s
   table.insert(rooms,428)
   w
   table.insert(rooms,429)
   e
   s
   table.insert(rooms,430)
   w
   table.insert(rooms,431)
   e
   s
   table.insert(rooms,432)
   w
   table.insert(rooms,433)
   table.insert(rooms,434)
   table.insert(rooms,435)
   table.insert(rooms,437)
   table.insert(rooms,450)
   table.insert(rooms,453)
   table.insert(rooms,457)
   table.insert(rooms,458)
   table.insert(rooms,459)

   table.insert(rooms,461)
   table.insert(rooms,462)
   table.insert(rooms,463)
   table.insert(rooms,464)
   table.insert(rooms,465)
   table.insert(rooms,466)
   --sz大理城西门
   special_item.sp_co=coroutine.create(function()
    for _,r in ipairs(rooms) do
      local w=walk.new()
	  w.walkover=function()
	    self:follow_xiaofan(tools_id,itemid)
	  end
	  w:go(r)
	  coroutine.yield()
    end
	self:buy_tools(tools_id,itemid)
  end)
  coroutine.resume(special_item.sp_co)]]
end

--437 裁缝店
function special_item:self_repair_armor(armor_id)
   local sp=special_item.new()
	sp.cooldown=function()
	   world.Send("wield jian dao")
	   --你拿起一柄铁锤。
		--你拿起一把剪刀。
	   wait.make(function()
	     local l,w=wait.regexp("^(> |)你身上没有这样东西。$|^(> |)你已经装备著了。$|^(> |)你拿起一把剪刀。$",5)
		 if l==nil then
		     self:self_repair_armor(armor_id)
		    return
		 end
		 if string.find(l,"你身上没有这样东西") then
		     --local f=function()
			    self:buy_tools("jian dao",armor_id)
			-- end
		     --qu_gold(f,1,410)
			return
         end
		 if string.find(l,"你拿起一把剪刀") or string.find(l,"你已经装备著了") then
		     self:repair_armor(armor_id)
		     return
		 end
	   end)
	end
	sp:unwield_all()
end
--462 铸剑房
function special_item:repair_armor(armor_id)
  world.Send("repair "..armor_id)
  wait.make(function()
     local l,w=wait.regexp("^(> |)你仔细的修补.*，总算大致恢复了它的原貌。$|^(> |)你带的零钱不够了！你需要(.*)锭黄金.*修补费用。$|^(> |)这件防具完好无损，无需修补。$",20)
     if l==nil then
	    self:repair_armor(armor_id)
	    return
	 end
	 if string.find(l,"你带的零钱不够了！") then
	    local gold=w[3]
		gold=ChineseNum(gold)+1
		local f=function()
			self:repair_armor(armor_id)
		end
		qu_gold(f,gold,410)
	    return
	 end
	 if string.find(l,"总算大致恢复了它的原貌") or string.find(l,"无需修补") then
	    --self:check_items_next()
	    return
	 end
  end)
--你本次修补花费四锭黄金三十二两白银。
--你开始仔细的修补上品鬼王甲胄，不时用剪刀来回裁剪缝纫着......
--你仔细的修补上品鬼王甲胄，总算大致恢复了它的原貌。
--隐约能看见兵器制造者的姓名：传说中的铸剑师  追月风(Kfzya)
--隐约能看见防具制造者的姓名：传说中的织造大师  虞美人(Yumeiren)
end

local repair_count=0
function special_item:repair_weapon(weapon_id)
  world.Send("repair "..weapon_id)
  wait.make(function()
     local l,w=wait.regexp("^(> |)你仔细的维修.*，总算大致恢复了它的原貌。$|^(> |)你带的零钱不够了！你需要(.*)锭黄金.*修理费用。$|^(> |)这件兵器完好无损，无需修理。$",10)
     if l==nil then
	    print("等待......",repair_count)
		world.Send("say ~~~~等等武器修复~~~~~")
	    repair_count=repair_count+1
		if repair_count>6 then
	      self:repair_weapon(weapon_id)
		end
	    return
	 end
	 if string.find(l,"你带的零钱不够了！") then
	    local gold=w[3]
		gold=ChineseNum(gold)+1
		local f=function()
			self:repair_weapon(weapon_id)
		end
		qu_gold(f,gold,410)
	    return
	 end
	 if string.find(l,"总算大致恢复了它的原貌") or string.find(l,"无需修理") then
	    local b=busy.new()
		b.Next=function()
		  world.Send("unwield tiechui")
	       self:check_items_next()
		end
		b:check()
	    return
	 end
  end)
end

function special_item:self_repair_weapon(weapon_id)
   local sp=special_item.new()
	sp.cooldown=function()
	   world.Send("wield tiechui")
	   local l,w=wait.regexp("^(> |)你身上没有这样东西。$|^(> |)你拿起一柄铁锤。$|^(> |)你已经装备著了。$",5)
		 if l==nil then
		     self:self_repair_weapon(weapon_id)
		    return
		 end
		 if string.find(l,"你身上没有这样东西") then
			 --local f=function()
			   local r=math.random(2)
			   print("修理武器购买铁锤",r)
			   if r==1 then
			    self:buy_tools("tiechui",weapon_id)
			   else
				self:buy_tiechui("tiechui",weapon_id)
			   end
			 --end
		     --qu_gold(f,1,410)
			return
         end
		  if string.find(l,"你拿起一柄铁锤") or string.find(l,"你已经装备著了") then
			 repair_count=0
		     self:repair_weapon(weapon_id)
		     return
		 end
	end
	sp:unwield_all()
end

function special_item:equipment_status(item_name,item_id,equipment_type)
 wait.make(function()
	 local l,w=wait.regexp("^(> |)看起来没有什么损坏。$|^(> |)看起来已经使用过一段时间了。$|^(> |)看起来需要修理了。|^(> |)设定环境变量：action \\= \\\"武器检查\\\"$",5)  --|^(> |)设定环境变量：action \\= \\\"武器检查\\\"$|^(> |)隐约能看见(.*)制造者的姓名.*$
	 if l==nil then
	   self:check_equipment(item_name,item_id)
	   return
	 end
	 if string.find(l,"看起来没有什么损坏") then
	    print("equipments ok!!")
		self:check_items_next()
	    return
	 end
	 if string.find(l,"看起来已经使用过一段时间了") then
		print("equipments damage 1")
		self:check_items_next()
	    return
	 end
	 if string.find(l,"看起来需要修理了") then
	    print("equipments damage 2")
        if equipment_type=="兵器" then
		   self:self_repair_weapon(item_id)
		else
		   self:self_repair_armor(item_id)
		end
        return
	 end
	 if string.find(l,"设定环境变量：action") then
		self:check_items_next()
	    return
	 end

   end)
end

function special_item:check_equipment(item_name,item_id)
	world.Send("look "..string.lower(item_id))
    world.Send("set action 武器检查")
	world.Send("unset action")
	local item_type
	--[[19:  剑(sword) 斧(axe) 刀(blade) 笔(brush) 棍(club) 匕首(dagger)
20:  叉(fork)法轮(hammer) 钩(hook) 枪(spear) 杖(staff) 棒(stick)
21:  萧(xiao) 鞭(whip)]]
	if string.find(item_name,"剑") or string.find(item_name,"刀") or string.find(item_name,"鞭") or string.find(item_name,"轮") or string.find(item_name,"锤") or string.find(item_name,"杖") or string.find(item_name,"棒") or string.find(item_name,"萧") or string.find(item_name,"棍") or string.find(item_name,"笔") or string.find(item_name,"钩") then
	   item_type="兵器"
	elseif string.find(item_name,"斧") or string.find(item_name,"枪") or string.find(item_name,"匕首") or string.find(item_name,"叉") then
	   item_type="兵器"
	else
	   item_type="护甲"
	end
	self:equipment_status(item_name,item_id,item_type)
end
