
local equipment_win = "equipment_window"
local equipment_win_width = 260
local equipment_win_height = 50
-- ����
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
  weight=0,--����
  repairweapon_list={},
  default_setting="<ʹ��>��ƪ|<ʹ��>��Ҫ|<ʹ��>��|<ʹ��>��|<ʹ��>����|<ʹ��>�غ�|<����>���콳����ƪ|<����>�鱦������|<����>��������|<����>�����赨ɢ|<����>��Ʊ&0|<����>����&200|<����>�ƽ�&20|<����>ͭǮ&200|<����>��|<ʹ��>Τ��֮��|<����>��ͭ|<����>����|<����>�޻�|<ʹ��>����"
  --default_setting="<ʹ��>��|<ʹ��>��|<ʹ��>����|<ʹ��>�غ�|<����>���콳����ƪ|<����>�鱦������|<����>��������|<����>�����赨ɢ|<����>��Ʊ&0|<����>����&200|<����>�ƽ�&10|<����>ͭǮ&200|<����>��|<ʹ��>Τ��֮��|<����>��ͭ<|����>����|<����>�޻�|<��ȡ>�ۻ�|<����>�����|<����>ʯͷ|<��ʧ>ʯ��|<����>��������|<����>����|<>����>���˿",
}
special_item.__index=special_item
function special_item:cooldown()  --�ص�

end

function is_special_drug(drugname)
   --print("ҩƷ:",drugname)
   --�� �� �� �� �� �� �� �� �� �� �� ��
   --�� �� �� �� �� �� ʯ ɰ ˮ ��
   --�� ��
  --[[local wan1="��ˮ��|�񱪵�|�����|����|�໢��|����|�ϼ���|���ﵤ|��ɰ��|��ɰ��|�Ʒﵤ|��ɰ��|��ɰ��|��ﵤ|������|������"
   wan1=wan1 .."|�༡��|���ֵ�|�ɻ���|�ɼ���|��ﵤ|�񼡵�|������|������|�ϼ���|����|��ˮ��|��ʯ��|��ɰ��|��ˮ��|�ϻ���"
   wan1=wan1 .."|��ˮ��|��ﵤ|��ʯ��|��ɰ��|��ʯ��|����|������|������|��ʯ��|���ֵ�|�ɱ���|�౪��|��ˮ��|������|�ɻ���|������"
   wan1=wan1 .."|������|�Ȼ���|��ɰ��|���ֵ�|�����|��ʯ��|�ɼ���|������|��ɰ��|������|��ʯ��|��ʯ��|��ˮ��|������|�𼡵�|��ˮ��"
   wan1=wan1 .."|����|������|���ֵ�|������|���ֵ�|�ȼ���|��ˮ��|����|�ɱ���|���ֵ�|������|�̷ﵤ|������|��ʯ��|��ɰ��|������|������|�໢��|�̼���"
   local wan2="�༡��|��ʯ��|�ɼ���|������|�ƻ���|������|��ɰ��|�ϱ���|��ɰ��|������|�ɱ���"
   local wans={}
   wans=Split(wan1,"|")
   for _,w in ipairs(wans) do
      if drugname==w then
	    -- print("return true")
	     return true
	  end
   end]]
   local d1="��Ȼ�����������������"
   local d2="���ﻢ������ʯɰˮ��"
   local d3="����"
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

function special_item:infusion()  --������ע
  wait.make(function()
   world.Send("longxiang")
   local l,w=wait.regexp("����������㣬�޷�ע���㹻��������|^(> |)�����Ϸ���һ��������������˫���鰴ʮ���������ģ�����������ע������֮�С�$|��Ǳ���ڹ���Ŭ��������ע��ʮ���������ģ������Ȼ�ɹ�����Ϊ���������������໨�˵�������|^(> |)�����Ϸ���һ��������������˫���鰴ʮ���������ģ�����������ע������֮�С�$",5)
    if string.find(l,"�����������") then
	   self:infusion_over()
	   return
	end
	if string.find(l,"Ŭ��������ע��ʮ����������") or string.find(l,"����������ע������֮��") then
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
	 local l,w=wait.regexp("����֮���Ѿ�ע��(.*)��������$|^(> |)�趨����������look \\= \\\"YES\\\"$",5)
	 if l==nil then
	    self:longxiang_jiasha()
	    return
	 end
     if string.find(l,"�趨����������look") then

		if self.longxiang_dao<13 then
		   self:infusion()
		else
           self:infusion_over()
		end
		return
	 end
	 if string.find(l,"����") then
	    local dao=w[1]
		print(dao.."��")
		self.longxiang_dao=ChineseNum(dao)
        self:longxiang_jiasha_dao()
		return
	 end
	 wait.time(5)
   end)
end

function special_item:longxiang_jiasha()
--��Ǳ���ڹ���Ŭ��������ע��ʮ���������ģ������Ȼ�ɹ�����Ϊ���������������໨�˵�������
--[[
ʮ����������(Shisan longxiang)
����һ�����ﴩ�����ģ���������Щ���ģ�������ͨ��ȴ�Ǵ����¿���ʼ���������������ġ�
��������Ϊ����ʱ�䱻�����������֣�����Ҳ�ƺ����˴��������Ĺ�Ч�����������ע������(longxiang)��
����֮���Ѿ�ע��ʮһ��������

����������㣬�޷�ע���㹻��������
]]

  wait.make(function()
     world.Send("look shisan longxiang")
	-- world.Send("set look 1")
	 local  l,w=wait.regexp("^(> |)��Ҫ��ʲô��$|^(> |)ʮ����������\\(Shisan longxiang\\)$",5)
	 if l==nil then
        self:longxiang_jiasha()
	    return
	 end
	 if string.find(l,"��Ҫ��ʲô") then
	    world.Send("wear pi")
		world.Send("wear cloth")
	    world.Send("wear pao")
		self:infusion_over()
	    return
	 end
	 if string.find(l,"ʮ����������") then
		world.Send("set action ��Ʒ���")
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
		local l,w=wait.regexp("^(> |)���������ȡ��.*���ƽ�$",5)
		print("����")
		if l==nil then
		--duanzao_learn(CallBack)
		   self:qu_gold(f,gold)
		   return
		end
		if string.find(l,"���������") then
		   --�ص�
		   --print("�ص�")
		   f()
		   return
		end
		wait.time(5)
	  end)
   end
   w:go(50)
end
--������ϸ��ά��������𽣣�������»ָ�������ԭò��
--�㱾��������ʮ�Ŷ��ƽ����������
function special_item:repair_ok()
   wait.make(function()
      local l,w=wait.regexp("^(> |)������ϸ��ά��.*������»ָ�������ԭò��$",20)
	  if l==nil then
	    self:repair_ok()
	    return
	  end
	  if string.find(l,"������»ָ�������ԭò") then
	    self:check_items_next()
	    return
	  end
   end)
end
--local l,w=wait.regexp("^(> |)����˵�������������Ǯ�����ˣ�����Ҫ(.*)���ƽ�.*����|����˵�������㻹û��װ����������|^(> |)�㱾��������.*��$",5)

--[[

�㽫��һ�ӣ�һ���ᾧ���ؽ������ɳ������һ�����Ѿ������������С�
> �������������йء�repair������Ϣ��
�㱾����������ʮһ���ƽ���ʮ����������
������ʼ��ϸ��ά���ᾧ���ؽ�����ʱ���������ô��......

>
�������뵤��ֻ����³������ջ�����Ԫ������
��ҥ�ԡ�ĳ�ˣ����˴�������������������һ�����֣�
���������Ѿ��Զ�������ˡ�
������ϸ��ά���ᾧ���ؽ���������»ָ�������ԭò��
]]
function special_item:tiejiang_repair_ok(weapon_id)
   wait.make(function()
     local l,w=wait.regexp("^(> |)����˵�������������Ǯ�����ˣ�����Ҫ(.*)���ƽ�.*������á���|����˵�������㻹û��װ����������|^(> |)�㱾��������.*$|^(> |)������������������ͷ��$|^(> |)������ϸ��ά���ᾧ���ؽ���������»ָ�������ԭò��$",50)
     if l==nil then
	    self:tiejiang_repair(weapon_id)
	    return
	 end
	 if string.find(l,"�㻹û��װ������") then
	    self:tiejiang_repair(weapon_id)
	    return
	 end
	 if string.find(l,"�������Ǯ������") then
	    local needgold=ChineseNum(w[2])
		needgold=needgold+1
		local f=function()
		   self:tiejiang_repair(weapon_id)
		end
		self:qu_gold(f,needgold)
	   return
	 end
	 if string.find(l,"������������������ͷ") then
	    print("����Ҫ����")
		print("��һ��")
		--local f=function()
         self:relogin()
		--self:check_items_next()
		--end
		--f_wait(f,0.1)
	    return
	  end
	 if string.find(l,"�㱾��������") then
	    print("�ȴ��޸�")
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
	 local l,w=wait.regexp("�������������йء�repair������Ϣ��",5)
	 if l==nil then
	   self:tiejiang_repair(weapon_id)
	   return
	 end
	 if string.find(l,"�������������й�") then
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

--[[   �������(Tianhuo sword)
����һ���ɱȽϼ�Ӳ�Ľ����Ƴɣ��ض�ʮ������һǮ��������𽣡�
�������ȽϷ���������ˮ׼���ϵ�������
װ��Ҫ�󣺱�������ʮ�塿������������㡿���������İ���ʮ����
�Լ�һ�Ź�׭�֡� ���������Ҫ�� ��
��Լ�ܿ������������ߵ�������Τ������(Weilan tiejiang)
������û��ʲô�𻵡�]]

    local now=os.time()
    --print(now,"���")
	if special_item.repairweapon_list[weapon_id]~="" and special_item.repairweapon_list[weapon_id]~=nil then
	   local interval=os.difftime(now,special_item.repairweapon_list[weapon_id])
	   --print(interval,":��",weapon_id," ˢ�¼��600s!")
	   if interval<=600 then --10����
	       --print("��һ��")
		   local f=function()
	          self:check_items_next()
		    end
		  f_wait(f,0.1)
		  return
	   end
    end
   wait.make(function()
     world.Send("look "..weapon_id)
	 world.Send("set action �������")
	 local l,w=wait.regexp("^(> |)������û��ʲô�𻵡�$|^(> |)�������Ѿ�ʹ�ù�һ��ʱ���ˡ�$|^(> |)��������Ҫ�����ˡ�|^(> |)��Ҫ��ʲô��$|^(> |)�趨����������action \\= \\\"�������\\\"$",5)
	 if l==nil then
	   self:weapon_repair(weapon_id)
	   return
	 end
	 if string.find(l,"������û��ʲô��") then
	    print("weapon ok!!")
		--self:cooldown()
		local now=os.time()
		special_item.repairweapon_list[weapon_id]=now --����ʱ��
		self:check_items_next()
	    return
	 end
	 if string.find(l,"�������Ѿ�ʹ�ù�һ��ʱ����") then
		print("weapon damage 1")
		--self:cooldown()
		self:check_items_next()
	    return
	 end
	 if string.find(l,"��������Ҫ������") then
	    print("weapon damage 2")
	    self:tiejiang_repair(weapon_id)
        return
	 end
	 if string.find(l,"��Ҫ��ʲô") then
	    --self:cooldown()
		self:check_items_next()
		return
	 end
	 if string.find(l,"�趨����������action") then
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
	local l,w=wait.regexp("^(> |)�����ϴ���������Щ����.*|^(> |)�����ϴ���.*������.*",5)
	if l==nil then
	  self:unwield_all()
	  return
	end
	if string.find(l,"�����ϴ���") or string.find(l,"��Щ����") then
	   --print("taohua")
	   self:unwield_id()
	   return
	end
	wait.time(5)
  end)
end

function special_item:unwield_id()
--����������(Jinhu pifeng)
 wait.make(function()
   local reg="^��(.*)\\((.*)\\)$|^(> |)�趨����������action \\= \\\"unwield\\\"$"
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
	   reg=reg .."|^(> |)(.*)(��|��|֧|ֻ|��|��|��).*"
	   	reg=reg.."("..weapon_name_list..")"
	   reg=reg.."\\((.*)\\)$"
	end

   local l,w=wait.regexp(reg,5)
   if l==nil then
      self:unwield_id()
	  return
   end
   if string.find(l,"��") then
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
   if string.find(l,"��") or string.find(l,"��") or string.find(l,"֧") or string.find(l,"ֻ") or string.find(l,"��") or string.find(l,"��") or string.find(l,"��") then
     --print("�����ж�")
     --print(w[4],w[5],w[6])
	 local num=Trim(w[5])
	 --print(w[7],"������")
	 local id= weapon_list[w[7]].id
	 --print(id)
	 local n=ChineseNum(num)
	 for i=2, n+1 do
	   world.Send("unwield "..id.." "..i)
	 end
	 self:unwield_id()
	 return
   end
   if string.find(l,"�趨����������action") then
      --print("����")
	  self:cooldown()
	  return
   end
   wait.time(5)
 end)
end

function special_item:quick_check()  --���ټ��
   world.Execute("drop qingtong;drop zhongzi;drop shitou;drop mianhua;drop head")
end

function special_item:check_items_over()
     self:draw_win()  --��Ʒ��ʾ����
	 --print(os.date()) --��鴦���ٶ�
     special_item.sp_co=coroutine.create(function()
	     --print(table.getn(self.itemslist),"��Ŀ4")
		local deal_function
		local index
		for index,deal_function in pairs(self.itemslist) do
		  --print("����3",index)

          local num=self.itemslistNum[index] --�о�����Ʒ����
		  --print("������Ʒ����",num)
		  if num~=nil then
		     deal_function(num)
			 --print("����")
			 --coroutine.yield()
		  else
		     deal_function()
		  end
		  --print("����")
	      coroutine.yield()
        end
		special_item.sp_co=nil
		equipment_items=nil
		getback_failure_weaponlist=nil
		--print(os.date())
		--print("�������")
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

	WindowText (equipment_win, FONT_NAME, "��Ʒ��Ϣ",
					left+94, top, 0, 0,
					ColourNameToRGB ("white"), false)


	top = top + 15
    WindowText (equipment_win, FONT_NAME, "������������������������������������������",
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
    if string.find(name,"��") then
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

   local regexp="^(> |)�趨����������action \\= \\\"��Ʒ���\\\"$|^(> |)(.*)\\\((.*)\\\)$|^(> |)�����ϴ���.*������\\\(����(.*)%\\\)��"

   wait.make(function()
     local l,w=wait.regexp(regexp,5)
	 if l==nil then
	     world.Send("i")
         world.Send("set action ��Ʒ���")
	     equipment_items={}
	     self.itemslist={}
	     self.itemslistNum={}
	     self:check_item(items,flag)
	    return
	 end
	 if string.find(l,"����") then
	    local weight=Trim(w[6])
		self.weight=tonumber(weight)
		print("����:",self.weight)
		self:check_item(items,true) --������־λ
		return
	 end
	 if string.find(l,")") then
	   if flag==true then --������־λ

	    local name=Trim(w[3])
		local id=string.lower(Trim(w[4]))
		local charnum=string.len(name)
		local num=""

		--print(name)
		local real_name=""
		local wield=""
		if string.sub(name,1,2)=="��" then
		     num="һ"
			 real_name=string.gsub(name,"��","")
			 wield="��"
			 if string.find(name,"��������������") then
			   num="��"
			   real_name="����������"
			 end
		else
		   for i=1,charnum,2 do
		    local c= string.sub(name,i,i+1)
		    if c=="��" or c=="һ" or c=="��" or c=="��" or c=="��" or c=="��" or c=="��" or c=="��" or c=="��" or c=="��" or c=="ʮ" or c=="��" or c=="ǧ" or c=="��" or c=="��" then
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
		-- ��Ʒ��ʾ
		--
		self:update_items(wield..real_name,id,num)
         --self:draw_items(wield..real_name,id,num)
		for index,i in ipairs(items) do
		   --print(i.name," ? ",name,id,num,i.filter)
		   --������Ʒ
		   local used=string.match(i.name, "<.*>") --��ȡ��;
		   local i_equip_name=string.gsub(i.name, "<.*>", "") --ȥ�������ַ� -<����>
		    i_equip_name=string.gsub(i_equip_name,"+","") --ȥ��+��
			name=string.gsub(name,"+","")
		   local s,e=string.find(name,i_equip_name)


		   --print(i_equip_name,"? <> ",name)
		   --print(string.find(name,i_equip_name), "is_ok")
		  if (string.lower(i_equip_name)==id or string.len(name)==e) and (not is_containkey(i.filter,real_name) or i.filter=="") then
		     --print("����")
			 --print(i.name," ? ",name,id,num,i.filter)
			 if i.totle_num==nil then
				i.totle_num=num
			 else
				i.totle_num=i.totle_num+num  --������������
			 end
			 local hold=function(sum_num)
			    --print("hold��",sum_num)
			    --print(id,"id",real_name)
			    i.hold(i.totle_num,real_name,id,sum_num)
			  end
			  --print("����1",hold)
			  local index=real_name..id..used --��ʵ����id��;
			  --print(index," index")
			  self.itemslist[index]=hold
			  if self.itemslistNum[index]==nil then  --������ͬid ���Ƶ� ��Ʒ����
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
	 if string.find(l,"�趨����������action") then
	     --print("����")
		 --print("ȱ��",table.getn(items))
		  --print(os.date())
		 --print("i start deal")

		 for _,i in ipairs(items) do
		    if i.totle_num==nil then
		      local lost=function()
			     --print("��ʧ")
			     i.lost()
			  end
			  --print("����2",lost)
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
       local l,w=wait.regexp("^(> |)����.*�ļ۸�������.*�������ϰ塣$|^(> |)ʲô��$|^(> |)�����ϰ�˵������.*��ֵǮ����������Ҳû�á���$|^(> |)�����ϰ�˵����������������ֹ���꡹$|^(> |)��Ҫ��ʲô��$|^(> |)�����ϰ�˵���������ֶ����Ҳ�ʶ��������Ҫ����$|^(> |)�����ϰ�˵�����������ı����ҿ����𡣡�$|^(> |)Ӵ����Ǹ�����������æ���ء��������Ժ�$|^(> |)�����ϰ�˵������С��ֻ��һ���Դ����ɲ����������������$|^(> |)ʲô.*$",10)
	   if l==nil then
	      world.Send("sell "..id)
		  self:sell_over(id,num)
	      return
	   end
		if string.find(l,"�������æ����")  then
		   local f=function()
	          world.Send("sell "..id)
	          self:sell_over(id,num)
		   end
		   f_wait(f,0.5)
		  return
	   end
	   if string.find(l,"�������ϰ�") then
		  num=num-1
	      if num==0 then
		    world.Send("wear all")
			--BigData:catchData(84,"����")
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
       if string.find(l,"����������ֹ����") or string.find(l,"��Ҫ��ʲô") or string.find(l,"���ֶ����Ҳ�ʶ��������Ҫ")  or string.find(l,"�����ı����ҿ�����")  then
		  --BigData:catchData(84,"����")
		  self:check_items_next()
	      return
	   end
	   if string.find(l,"ʲô") then
	       self:sell_item(id,num)
		  return
	   end
	   if string.find(l,"��������Ҳû��") or string.find(l,"�ɲ������������") then
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
   if real_num==same_num then  --��Ʒ����һ��
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
	  world.Send("set action ��Ǯ")
	    --BigData:catchData(bank_roomno,"���ի")
		--��Ŀǰ���д��������Ű���ʮ�����ƽ���ʮ����������ʮ��ͭǮ���ٴ���ô���Ǯ��С�ſ��ѱ����ˡ�
		--> Ǯ����˵������Ӵ����Ǹ�����������æ���ء��������Ժ򡣡�
	  wait.make(function()
		--BigData:Auto_catchData()
		local l,w=wait.regexp("^(> |)��Ŀǰ���д��.*�ٴ���ô���Ǯ��С�ſ��ѱ����ˡ�$|^(> |)���ó�.*��������š�$|^(> |).*Ӵ����Ǹ�����������æ����.*�����Ժ򡣡�$|^(> |)�趨����������action \\= \\\"��Ǯ\\\"",10)
		if l==nil then
		   self:convert_money(num,id)
		   return
		end
		if string.find(l,"С�ſ��ѱ�����") then

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
		if string.find(l,"�����Ժ�") then
		  local f=function()
		    self:convert_money(num,id)
		  end
		  f_wait(f,1)
		   return
		end
		if string.find(l,"���������") or string.find(l,"�趨��������") then
	      local b=busy.new()
	      b.Next=function()
	       self:check_items_next()
	      end
	      b:check()
		end

	  end)

end

function special_item:save_money(id,real_num,setup_num)  --id �������� ��������

 local _R
  _R=Room.new()
  _R.CatchEnd=function()
  --���ݵ�ǰλ�� ǰ�������Ǯׯ
--{���� 410} {���� 1474} {���� 50} {�ɶ� 546} {���� 1973} {���� 1069} {���� 1119} {���� 1331} {���� 926} {���ݳ�}
      local count,roomno=Locate(_R)
	  print("��ǰ�����",roomno[1])
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
	  print(bank_roomno," ����")
	 local num=real_num-setup_num
     if num==0 then num=1 end
     if setup_num>=50 and num==1 then --��ֹ���̫�� ���ش�Ǯ
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

function special_item:save_item(id,real_num,setup_num)  --id �������� ��������
   if id=="gold" or id=="silver" or id=="coin" or id=="cash" or id=="thousand-cash" then
	  self:save_money(id,real_num,setup_num)  --id �������� ��������
      return
   end
   local w=walk.new()
   w.walkover=function()
      world.Send("cun "..id)
	  local b=busy.new()
	  b.Next=function()
	     self:check_items_next()
		-- world.AppendToNotepad (WorldName(),os.date()..": ��Ʒ���� "..id.." \r\n")
	  end
	  b:check()
   end
   w:go(94)
end

function special_item:drop(id,real_num,setup_num,same_num)
   -- print(id," ",real_num," ? ",same_num," setup_num:",setup_num)
    local num=0
   if real_num==same_num then  --��Ʒ����һ��
       num=real_num-setup_num+1
   else
	   num=1
   end
   local i
   --print("test")
   if id=="falun" then --�����ǿ��Բ���ı����������
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
   items["ʮ����������"]=function()
        self.infusion_over=function()
			self:check_items_next() --��һ��
		end
		self:longxiang_jiasha()
   end
   items["ţƤ�ƴ�"]=function()
		local party=world.GetVariable("party") or ""
		if party=="��ɽ��" then
	       self.hanjianshenjian_over=function()
		      self:check_items_next() --��һ��
		   end
	       self:fill_jiudai()
		else
		   self:check_items_next() --��һ��
		end
   end
   items["��Ҫ"]=function()
		local f=function()
			self:readbook(item_id)
		end
		f_wait(f,0.1)
	end
	items["����"]=function()
	    local f=function()
		     self:eat(item_id)
		end
		f_wait(f,0.1)
	end
	items["����"]=function()
			 local _equip=equipments.new()
			 _equip.finish=function(item_name,item_id,get_ok)  --get ���
				self:check_items_next() --��һ��
		     end
			 _equip:jinhe()
	end
	items["�غ�"]=function()
		local _equip=equipments.new()
	     _equip.finish=function(item_name,item_id,get_ok)  --get ���
			self:check_items_next() --��һ��
		end
		_equip:mihan(item_id)
	end
    items["Τ��֮��"]=function()
		local _equip=equipments.new()
	     _equip.finish=function(item_name,item_id,get_ok)  --get ���
			self:check_items_next() --��һ��
		end
		_equip:weilan()
	end

    items["����"]=function()
		local _equip=equipments.new()
	     _equip.finish=function(item_name,item_id,get_ok)  --get ���
			self:check_items_next() --��һ��
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
      --print("ʹ��2",item_name,item_id,i_equip_name)
	  --print("��ҩ",is_special_drug(item_name))
	   local _item
		_item=item_name
	   if (string.find(item_name,"��Ҫ") or string.find(item_name,"��ƪ")) and not string.find(item_name,"������ƪ") then
	        _item="��Ҫ"
	   end

	   if (string.find(item_name,"��") or string.find(item_name,"��")) and (is_special_drug(item_name) or string.find(i_equip_name,item_name)) then
	       --print("����")
 		    _item="����"
	   end
	   if string.find(item_name,"����") then
	      _item="����"
	   end
	    if string.find(item_name,"�غ�") then
	      _item="�غ�"
	   end
		if string.find(item_name,"����") then
	      _item="����"
	   end
	   self:items(_item,item_id)
end


function special_item:hanjian_shenjian()
  wait.make(function()
     world.Send("look hanbing shenjian")
	 local  l,w=wait.regexp("^(> |)��Ҫ��ʲô��$|^(> |)������\\(Hanbing shenjian\\)$",5)
	 if l==nil then
        self:hanjian_shenjian()
	    return
	 end
	 if string.find(l,"��Ҫ��ʲô") then
		   self:hanjian()
	    return
	 end
	 if string.find(l,"������") then
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

function special_item:hanjian()  --�˺���
  wait.make(function()
      world.Send("unwield sword")
		  world.Send("yun hanjian jiudai")
   local l,w=wait.regexp("^(> |)���������õ��У��㲻��ʩ���ڹ���$|^(> |)�㻹û�����к����������������ʹ�ú����񽣣�$|^(> |)��������������޷�ʩչ�������񽣡�$|^(> |)�㽫��������ע��ţƤ�ƴ�֮�У�ͬʱ����������ˮ�Ƴ�ţƤ�ƴ�����ʱ�γ���һ�������񽣡�$|^(> |)���������ﲻ���б����𣿻��콣����$|^(> |)������û���˺���������֧�֣�����Ϊ��������Ƭ��Ʈɢ�ڿ��С�$",5)
    if string.find(l,"�����������") or string.find(l,"���������ﲻ���б�����") or string.find(l,"�㻹û�����к�������������") then
	   self:hanjianshenjian_over()
	   return
	end
	if string.find(l,"���������õ��У��㲻��ʩ���ڹ�")  then
	   self:fill_jiudai()
	   return
	end
	if string.find(l,"�㽫��������ע��.*�ƴ�֮��")  then
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
	-- ȥ���ظ�����
	local items_record={}
    for _,eq in ipairs(equip) do
		  local _wanted=Split(eq,"&")
	      local _item={}
		  local name=_wanted[1]
		  --�ų� ��
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
		   --print("����",num)
		   if _item.num==nil then
		       _item.num=1
		   end
		   if _item.num<=0 then
			  _item.num=1
		   end
           --print(_item.name)
		  _item.hold=function(n,real_item_name,item_id,sum_num) --����ƥ�����Ʒ����(�� ����ƥ��� ���ѳ��� ���� ��ԯ�� ����4) ��Ʒ����ȫ�� ��ƷӢ��id  ��Ʒ����(����2 ����1 ��ԯ��1)
               --print(n,"?<=",sum_num,"  ",_item.name)
			  if _item.num~=nil then
			     if n<_item.num then --������ get
				    --print("get ������")
				     --_Get(_item.name)
					 self:handle(_item.name,nil,nil,_item.filter,n,_item.num,sum_num)
				 else
					 self:handle(_item.name,real_item_name,item_id,_item.filter,n,_item.num,sum_num) --���㹻����  --n ʵ������ _item.num��������
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
     world.Send("set action ��Ʒ���")
	 equipment_items={}
	 self.equipment_items={}
	 self.itemslist={}
	 self.itemslistNum={}
	 self:check_item(items)
end

function special_item:check_items_next()
    --print("����",special_item.co)
   coroutine.resume(special_item.sp_co)
end

function special_item:relogin()
   self:check_items_next()  --��Ʒ��ʧ��������
end

function special_item:recheck(item_name,item_id)
    print(item_name,item_id)
	self:check_items_next()
end

function special_item:safe_room(item_name,item_id)

 --�ܳ�����
   local w=walk.new()
   w.walkover=function()
      world.Send("look")
	  world.Send("set action leave")
      local l,w=wait.regexp(".*������.*|^(> |)�趨����������action \\= \\\"leave\\\".*",3)
	  if l==nil then
	     self:safe_room()
		 return
	  end
	  if string.find(l,"�趨����������action") then
	     self:safe_room()
	     return
	  end
	  if string.find(l,"������") then
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
   if weapon_type=="��" then
      weapon_id="hammer"
   elseif weapon_type=="��" then
      weapon_id="falun"
   elseif weapon_type=="ǹ" then
      weapon_id="spear"
   elseif weapon_type=="��" then
      weapon_id="sword"
	elseif weapon_type=="��" then
	   weapon_id="blade"
    elseif weapon_type=="��" then
	   weapon_id="stick"
    elseif weapon_type=="��" then
	    weapon_id="club"
    elseif weapon_type=="��" then
		weapon_id="dagger"
	elseif weapon_type=="��" then
	     weapon_id="xiao"
	elseif weapon_type=="��" then
       weapon_id="staff"
    elseif weapon_type=="��" then
      weapon_id="axe"
   elseif weapon_type=="��" then
      weapon_id="bi"
   elseif weapon_type=="��" then
      weapon_id="nao"
   elseif weapon_type=="��" or weapon_type=="�" then
      weapon_id="whip"
   end
   return weapon_id
end

function special_item:getback_lostweapon(name)
  --�ղ��Ƿ�����
  --�Ƿ�����������������ʧ
   local is_omit=special_item.getback_failure_weaponlist[name]
   if is_omit==nil then
      is_omit=false
   end
   special_item.getback_failure_weaponlist[name]=true
   local newdie=world.GetVariable("newdie") or ""
   if newdie=="true" then

      world.DeleteVariable("newdie")
	  _G["fight_Roomno"]=nil
	  --��Ҫ�ų������ѡ��
	  local f2=function()
	     self:check_items_next()
	  end
	  f_wait(f2,0.1)
	  return
   end
   world.Send("alias pfm") --ɾ��pfm
   local f=_G["fight_Roomno"] --��ս������������� ���������ս������
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
		   print("���뷽��!",g_dx)
		  break
	  end
	  w.walkover=function()
         local weapon_id=get_weapon_id(name)
	     world.Send("get "..weapon_id)
		 world.Send("halt")
		 world.Send("alias pfm halt;get "..weapon_id..";"..g_dx..";set action ����")
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

function special_item:handle(i_equip_name,item_name,item_id,filter,real_num,setup_num,same_num)  ---filter ��������
    --print("װ��",i_equip_name,item_name,item_id,filter)
 --��������
   --��ȡ װ�� ʹ�� ���� ���� ����
   if string.find(i_equip_name,"<��ȡ>") and item_name==nil and item_id==nil then
            --print("��ȡ")
			 local id=string.gsub(i_equip_name,"<��ȡ>","")
			 local id=string.lower(id)
			 --print(id)
			 local _equip=equipments.new()
			 _equip.finish=function(item_name,item_id,get_ok)  --get ���
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
   elseif string.find(i_equip_name,"<ʹ��>") and item_name~=nil and item_id~=nil then
       -- print("ʹ��1")
		if is_containkey(filter,item_name) then
		--��Ʒ���ƺ͹����������� ֱ������������
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
   elseif string.find(i_equip_name,"<����>") and item_name~=nil and item_id~=nil then
       if filter=="[��ͨҩ��]"  then  --����ҩ��
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
		--��Ʒ���ƺ͹����������� ֱ������������
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
   elseif string.find(i_equip_name,"<����>") and item_name~=nil and item_id~=nil then
         --print("����",i_equip_name,item_name,item_id," ʵ��:",real_num," ����:",setup_num)
        if is_containkey(filter,item_name) then
		--��Ʒ���ƺ͹����������� ֱ������������
		    --print("����")
		    local f=function()
			   self:check_items_next()
		    end
		    f_wait(f,0.1)
		else
           --print("����"," ʵ������:",real_num," ��������:",setup_num)
		   local f=function()
			   self:sell_item(item_id,real_num,setup_num,same_num)
	   	   end
		   f_wait(f,0.1)
	   end
   elseif string.find(i_equip_name,"<����>") and item_name~=nil and item_id~=nil then
         --print("����",i_equip_name,item_name,item_id,filter)
        if is_containkey(filter,item_name) then
		--��Ʒ���ƺ͹����������� ֱ������������
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
	elseif string.find(i_equip_name,"<����>") and item_name==nil and item_id==nil then --mark ��Ʒ ��Ʒ��ʧ
		print("�ҵ�weilan������ʧ")
		print("180s�Ժ���������")
		sj.log_catch(WorldName()..'������ʧ��¼',900)
		sj.world_init=function()
			print("�������ӣ����MY��Ʒ������")
			self:relogin()
		end
		local b=busy.new()
		b.Next=function()
			relogin(180,false)
		end
		b:check()
	elseif string.find(i_equip_name,"<���>") then
	    if item_name==nil and item_id==nil then --mark ��Ʒ ��Ʒ��ʧ
		   print("����ҵ�weilan����")
		   local equip_name=string.gsub(i_equip_name,"<���>","")
		   self:getback_lostweapon(equip_name)
		else
           --print(item_name.." () "..item_id)
		  local equip_name=string.gsub(i_equip_name,"<���>","")
		  --print(equip_name," ���װ�����ڣ�")
		   special_item.getback_failure_weaponlist[equip_name]=false
		   local f=function()
			self:check_items_next()
		   end
		   f_wait(f,0.1)
		end
	elseif string.find(i_equip_name,"<�Զ�����>") and item_name~=nil and item_id~=nil then
	    self:weapon_repair(item_id)

	elseif string.find(i_equip_name,"<�˹�����>") and item_name~=nil and item_id~=nil then
		self:check_equipment(item_name,item_id)
    else
		local f=function()
			self:check_items_next()
		end
		f_wait(f,0.1)
   end
end

--------------
--������ʮ������������ʮ����ͭǮ�ļ۸�Ӵ���С������������һ��������
function special_item:buy_fromxiaofan(tools_id,itemid)
   --print("test")
   wait.make(function()
      --world.Send("list")
		--world.Send("buy "..tools_id)
		local l,w=wait.regexp("^(> |)����.*�ļ۸��.*����������һ(��|��)(.*)��$|^(> |)����С��˵��������⵰��һ�ߴ���ȥ����$|^(> |)�趨����������action \\= \\\"����\\\"$",10)
		if l==nil then
		   coroutine.resume(special_item.sp_co)
		   return
		end
		if string.find(l,"��⵰��һ�ߴ���ȥ") then

		local f=function()
			self:buy_tools(tools_id,itemid)
		end
		qu_gold(f,5,410)
		  return
		end
		if string.find(l,"�趨����������action") then
		  -- print("why")
		   wait.time(1)
		   coroutine.resume(special_item.sp_co)
		   return
		end
		if string.find(l,"����������") then
		   world.Send("follow none")
		   if w[3]=="����" then
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
     local l,w=wait.regexp("^(> |)����û�� dali xiaofan��$|^(> |)������������С��һ���ж���$|^(> |)���Ѿ��������ˡ�$",5)
	 if l==nil then
	    self:follow_xiaofan(tools_id,itemid)
	    return
	 end
     if string.find(l,"����û��") then
	    coroutine.resume(special_item.sp_co)
	    return
	 end
	 if string.find(l,"������������С��һ���ж�") or string.find(l,"���Ѿ���������") then
	    world.Send("say �����齣�ǹ�����������Ϊ����̯���ʹ���")
		self:buy_fromxiaofan(tools_id,itemid)
	 end
  end)
end]]

function special_item:buy_tiechui(tools_id,itemid)
 local cmd="buy "..tools_id
   local route={}
    table.insert(route,"ne;"..cmd..";sw;"..cmd..";n;"..cmd..";s;"..cmd..";s;"..cmd..";set action ����")
    table.insert(route,"n;"..cmd..";e;"..cmd..";e;"..cmd..";w;"..cmd..";w;"..cmd..";set action ����")
	table.insert(route,"w;"..cmd..";n;"..cmd..";s;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";n;"..cmd..";w;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"n;"..cmd..";n;"..cmd..";s;"..cmd..";set action ����")
	table.insert(route,"w;"..cmd..";n;"..cmd..";s;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";n;"..cmd..";w;"..cmd..";set action ����")
	table.insert(route,"n;"..cmd..";s;"..cmd..";s;"..cmd..";set action ����")
	table.insert(route,"n;"..cmd..";set action ����")
    local w=walk.new()
	w.walkover=function()
	 special_item.sp_co=coroutine.create(function()

	    for _,r in ipairs(route) do
		  self:buy_fromxiaofan(tools_id,itemid)
          world.Execute(r)
	      coroutine.yield()
		end
		--
		--[[�� �� ��������
		local f=function()
		   self:buy_tools(tools_id,itemid)
		end]]
		if tools_id=="tiechui" then
		   self:self_repair_weapon(itemid)
		else
		   self:self_repair_armor(itemid)
		end
		--print("���2s")
		--f_wait(f,2)
	 end)

	 coroutine.resume(special_item.sp_co)
	end
	w:go(75)
end

function special_item:buy_tools(tools_id,itemid)
   local cmd="buy "..tools_id
   local route={}
    table.insert(route,"e;"..cmd..";n;"..cmd..";s;"..cmd..";e;"..cmd..";w;"..cmd..";set action ����")
    table.insert(route,"s;"..cmd..";e;"..cmd..";w;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";w;"..cmd..";e;"..cmd..";set action ����")
	table.insert(route,"s;"..cmd..";n;"..cmd..";e;"..cmd..";s;"..cmd..";n;"..cmd..";e;"..cmd..";set action ����")
    local w=walk.new()
	w.walkover=function()
	 special_item.sp_co=coroutine.create(function()

	    for _,r in ipairs(route) do
		  self:buy_fromxiaofan(tools_id,itemid)
          world.Execute(r)
	      coroutine.yield()
		end
		--
		--[[�� �� ��������
		local f=function()
		   self:buy_tools(tools_id,itemid)
		end]]
		if tools_id=="tiechui" then
		   self:self_repair_weapon(itemid)
		else
		   self:self_repair_armor(itemid)
		end
		--print("���2s")
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
   --sz���������
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

--437 �÷��
function special_item:self_repair_armor(armor_id)
   local sp=special_item.new()
	sp.cooldown=function()
	   world.Send("wield jian dao")
	   --������һ��������
		--������һ�Ѽ�����
	   wait.make(function()
	     local l,w=wait.regexp("^(> |)������û������������$|^(> |)���Ѿ�װ�����ˡ�$|^(> |)������һ�Ѽ�����$",5)
		 if l==nil then
		     self:self_repair_armor(armor_id)
		    return
		 end
		 if string.find(l,"������û����������") then
		     --local f=function()
			    self:buy_tools("jian dao",armor_id)
			-- end
		     --qu_gold(f,1,410)
			return
         end
		 if string.find(l,"������һ�Ѽ���") or string.find(l,"���Ѿ�װ������") then
		     self:repair_armor(armor_id)
		     return
		 end
	   end)
	end
	sp:unwield_all()
end
--462 ������
function special_item:repair_armor(armor_id)
  world.Send("repair "..armor_id)
  wait.make(function()
     local l,w=wait.regexp("^(> |)����ϸ���޲�.*��������»ָ�������ԭò��$|^(> |)�������Ǯ�����ˣ�����Ҫ(.*)���ƽ�.*�޲����á�$|^(> |)�������������������޲���$",20)
     if l==nil then
	    self:repair_armor(armor_id)
	    return
	 end
	 if string.find(l,"�������Ǯ�����ˣ�") then
	    local gold=w[3]
		gold=ChineseNum(gold)+1
		local f=function()
			self:repair_armor(armor_id)
		end
		qu_gold(f,gold,410)
	    return
	 end
	 if string.find(l,"������»ָ�������ԭò") or string.find(l,"�����޲�") then
	    --self:check_items_next()
	    return
	 end
  end)
--�㱾���޲������Ķ��ƽ���ʮ����������
--�㿪ʼ��ϸ���޲���Ʒ�������У���ʱ�ü������زü�������......
--����ϸ���޲���Ʒ�������У�������»ָ�������ԭò��
--��Լ�ܿ������������ߵ���������˵�е�����ʦ  ׷�·�(Kfzya)
--��Լ�ܿ������������ߵ���������˵�е�֯���ʦ  ������(Yumeiren)
end

local repair_count=0
function special_item:repair_weapon(weapon_id)
  world.Send("repair "..weapon_id)
  wait.make(function()
     local l,w=wait.regexp("^(> |)����ϸ��ά��.*��������»ָ�������ԭò��$|^(> |)�������Ǯ�����ˣ�����Ҫ(.*)���ƽ�.*������á�$|^(> |)����������������������$",10)
     if l==nil then
	    print("�ȴ�......",repair_count)
		world.Send("say ~~~~�ȵ������޸�~~~~~")
	    repair_count=repair_count+1
		if repair_count>6 then
	      self:repair_weapon(weapon_id)
		end
	    return
	 end
	 if string.find(l,"�������Ǯ�����ˣ�") then
	    local gold=w[3]
		gold=ChineseNum(gold)+1
		local f=function()
			self:repair_weapon(weapon_id)
		end
		qu_gold(f,gold,410)
	    return
	 end
	 if string.find(l,"������»ָ�������ԭò") or string.find(l,"��������") then
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
	   local l,w=wait.regexp("^(> |)������û������������$|^(> |)������һ��������$|^(> |)���Ѿ�װ�����ˡ�$",5)
		 if l==nil then
		     self:self_repair_weapon(weapon_id)
		    return
		 end
		 if string.find(l,"������û����������") then
			 --local f=function()
			   local r=math.random(2)
			   print("����������������",r)
			   if r==1 then
			    self:buy_tools("tiechui",weapon_id)
			   else
				self:buy_tiechui("tiechui",weapon_id)
			   end
			 --end
		     --qu_gold(f,1,410)
			return
         end
		  if string.find(l,"������һ������") or string.find(l,"���Ѿ�װ������") then
			 repair_count=0
		     self:repair_weapon(weapon_id)
		     return
		 end
	end
	sp:unwield_all()
end

function special_item:equipment_status(item_name,item_id,equipment_type)
 wait.make(function()
	 local l,w=wait.regexp("^(> |)������û��ʲô�𻵡�$|^(> |)�������Ѿ�ʹ�ù�һ��ʱ���ˡ�$|^(> |)��������Ҫ�����ˡ�|^(> |)�趨����������action \\= \\\"�������\\\"$",5)  --|^(> |)�趨����������action \\= \\\"�������\\\"$|^(> |)��Լ�ܿ���(.*)�����ߵ�����.*$
	 if l==nil then
	   self:check_equipment(item_name,item_id)
	   return
	 end
	 if string.find(l,"������û��ʲô��") then
	    print("equipments ok!!")
		self:check_items_next()
	    return
	 end
	 if string.find(l,"�������Ѿ�ʹ�ù�һ��ʱ����") then
		print("equipments damage 1")
		self:check_items_next()
	    return
	 end
	 if string.find(l,"��������Ҫ������") then
	    print("equipments damage 2")
        if equipment_type=="����" then
		   self:self_repair_weapon(item_id)
		else
		   self:self_repair_armor(item_id)
		end
        return
	 end
	 if string.find(l,"�趨����������action") then
		self:check_items_next()
	    return
	 end

   end)
end

function special_item:check_equipment(item_name,item_id)
	world.Send("look "..string.lower(item_id))
    world.Send("set action �������")
	world.Send("unset action")
	local item_type
	--[[19:  ��(sword) ��(axe) ��(blade) ��(brush) ��(club) ذ��(dagger)
20:  ��(fork)����(hammer) ��(hook) ǹ(spear) ��(staff) ��(stick)
21:  ��(xiao) ��(whip)]]
	if string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") or string.find(item_name,"��") then
	   item_type="����"
	elseif string.find(item_name,"��") or string.find(item_name,"ǹ") or string.find(item_name,"ذ��") or string.find(item_name,"��") then
	   item_type="����"
	else
	   item_type="����"
	end
	self:equipment_status(item_name,item_id,item_type)
end
