
--[[> ask tiejiang about job
�������������йء�job������Ϣ��
�����������㿴����֪����Щʲô���⡣
��������Ķ�������˵������˵�����ݳǺ��ָ�Ժ��Χ��Բ�����ڷ���������Ŀ�ʯ����ȥ����������
����˵�������Ҳ��������ġ���
wield tieqiao
������һ�����¡�
> ������������ĺ���ɢ�����������𵽱����������ˡ�
caikuang kuangshi
����ϸ��������ʯ���ټ�......

��ϧʲô��û���ҵ���
���ݱ��� - northwest��south��southwest��west
> s
���� - north��south��west
���佫(Wu jiang)
�����õ�Ůʬ(Nv shi)
����λ�ٱ�(Guan bing)
> caikuang kuangshi
����ϸ��������ʯ���ټ�......

��ϧʲô��û���ҵ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
���ű�Ӫ - east��west
����λ�ٱ�(Guan bing)
���佫(Wu jiang)
��ͯ��(Tong song)
���ֽ�(Jian)
������(Tie jia)
> caikuang kuangshi
����ϸ��������ʯ���ټ�......

��ϧʲô��û���ҵ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
��Ķ�����û����ɣ������ƶ���
> w
���� - east
������(Ding dian)
> caikuang kuangshi
����ϸ��������ʯ���ټ�......

�ƺ���������.....
> ��������ڳ�һ�����û�м����Ŀ�ʯ��
i
�����ϴ����߼�����(���� 20.44)��
����ʮ����ͭǮ(Coin)
����ʮ�����ƽ�(Gold)
����������(Silver)
������(Tieqiao)
������(Shoes)
����ɫ����(Pao)
��һ��δ֪��ʯ(Weizhi kuangshi)
> l kuangshi
δ֪��ʯ(Weizhi kuangshi)
����һ�黹û�����ܹ�ʶ��������ʯ��
> l
���� -
���������Ǽ�����ԼĪ���ɼ�����һ���ʯ�ң�ǽ�ںͶ��嶼�Ǵ�ʯ������
ǽ�������һֻ��Ͱ�������ŵ��ľ��ǳ�����ù����������ǽ�ϵ�С����
ȥ�����Լ������ָ���һ�ǡ�
��������Ψһ�ĳ����� east��
������(Ding dian)
> e
��Ķ�����û����ɣ������ƶ���
������ - south
������(Tiejiang)
> give tiejiang kuangshi
��������������������ɵúá�
����˵�������ð��������ռ���һ������Ŀ�ʯ��˵��������������һ�������������
������ϸ������ɿ�ľ��ϣ���Ĳɿ����������İ���ʮһ�㼼�ܵ������Ͷ�ʮ���㾭�飡--]]


caikuang={
   new=function()
     local ck={}
	 setmetatable(ck,{__index=caikuang})
	 return ck
   end,
   co=nil,
   max_rooms=40,
   to_play_id="",
   version=1.8,
}

function caikuang:fail(id)
end

function caikuang:ask_tiejiang()
  wait.make(function()
     world.Send("ask tiejiang about job")
	 local l,w=wait.regexp("^(> |)��������Ķ�������˵������˵��(.*)��Χ��Բ(.*)���ڷ���������Ŀ�ʯ����ȥ����������$|^(> |)����˵��������̫æ�˰ɣ�Ҫע����Ϣ������$",5)
	 --��������Ķ�������˵������˵�����ݳǾ�̩��Χ��Բһ���ڷ���������Ŀ�ʯ����ȥ����������
	 if l==nil then
		self:ask_job()
	    return
	 end
	 if string.find(l,"��������Ķ�������˵��") then
	    local place=w[2]
		local range=w[3]
		r=ChineseNum(range)
		print(place,r)
		self:find(place,r)
		return
	 end
     if string.find(l,"��̫æ�˰ɣ�Ҫע����Ϣ��") then
	    self.fail(101)
	    return
	 end
  end)
end

function caikuang:ask_job()
   local w=walk.new()
   w.walkover=function()
      self:ask_tiejiang()
   end
   w:go(76)
end

function caikuang:find(place,range)
  local n,e=Where(place)
  local rooms=depth_search(e,range)  --��Χ��ѯ
    if n>0 then
	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	   caikuang.co=coroutine.create(function()
	     self:Search(rooms)
		 print("û���ҵ���ʯ!!")
		 self:giveup()
	   end)
	   local b2
	   b2=busy.new()
	   b2.interval=0.5
	   b2.Next=function()
	     self:NextPoint()
	   end
	   b2:check()
	 end
	 b:check()
	else
	  print("û��Ŀ�� �� Ŀ�귿�����")
	  self:giveup()
	end
end

function caikuang:NextPoint()
   print("���ָ̻�")
   coroutine.resume(caikuang.co)
end

function caikuang:caikuang_end()
   wait.make(function()
      local l,w=wait.regexp("^(> |)��ϧʲô��û���ҵ���$|^(> |)��������ڳ�һ�����û�м����Ŀ�ʯ��$",5)
	  if l==nil then
	     self:caikuang_end()
	     return
	  end
	  if string.find(l,"��ϧʲô��û���ҵ�") then
	     local b=busy.new()
		 b.interval=0.8
		 b.Next=function()
		     self:NextPoint()
		 end
		 b:check()
	     return
	  end
      if string.find(l,"��������ڳ�һ�����û�м����Ŀ�ʯ") then
	     local b=busy.new()
		 b.interval=0.8
		 b.Next=function()
		     self:reward()
		 end
		 b:check()
	     return
	  end
   end)
end

function caikuang:caikuang()
  wait.make(function()
    world.Send("wield qiao")
    world.Send("caikuang kuangshi")
	local l,w=wait.regexp("^(> |)����ϸ��������ʯ���ټ�.*$|^(> |)������ȷ�����Ŀǰװ����������$",5)
	if l==nil then
	   self:caikuang()
	   return
	end
	if string.find(l,"����ϸ��������ʯ���ټ�") then
	   self:caikuang_end()
	   return
	end
	if string.find(l,"������ȷ�����Ŀǰװ��������") then
	    local sp=special_item.new()
		sp.cooldown=function()
			self:caikuang()
		end
	    sp:unwield_all()
	   return
	end
  end)
end

function caikuang:Search(rooms)
   for i,r in ipairs(rooms) do
      if i>self.max_rooms then
	     break
	  end
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      --self:giveup()
			  --self:beauty_exist()
			  self:NextPoint()
		  end
		  w.user_alias=al
		  w.noway=function()
		     self:NextPoint()
		  end
		  w.walkover=function()
			self:caikuang()
		  end
		  --
		  w:go(r)
		  coroutine.yield()
   end
end

function caikuang:jobDone()  --�ӿں��� �ص�
end

function caikuang:reward()
    local w=walk.new()
   w.walkover=function()
     if self.to_play_id~="" then
	    world.Send("give kuangshi to "..self.to_play_id)
	 else
	    world.Send("give tiejiang kuangshi")
     end

	  wait.make(function()
	   local l,w=wait.regexp("^(> |)���(.*)һ��δ֪��ʯ��$|^(> |)������û������������$",5)
		if l==nil then
		    self:reward()
		    return
		 end
		 if string.find(l,"һ��δ֪��ʯ") then
		    if w[2]=="����" then
		       self:jobDone()
			else
			   self:giveup()
			end
		    return
		 end
		 if string.find(l,"������û����������") then
		    self:giveup()
		    return
		 end
	  end)
   end
   w:go(76)
end

function caikuang:giveup()
   local w=walk.new()
   w.walkover=function()
      world.Send("ask tiejiang about ����")
	  wait.make(function()
        local l,w=wait.regexp("�������������йء�����������Ϣ��",5)
        if l==nil then
		   self:giveup()
		   return
		end
		if string.find(l,"��������������") then
		   self:Status_Check()
		   return
		end
	  end)
   end
   w:go(76)
end

function caikuang:liaoshang_fail()
end

function caikuang:Status_Check()
    local win=window.new() --��ش���
     win.name="status_window"
     win:addText("label1","Ŀǰ����:�ɿ�")
	 win:addText("label2","Ŀǰ����:����")
     win:refresh()
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
     --��ʼ��
	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
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
				    self:Status_Check()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(1960) --299 ask xiao tong about ʳ�� ask xiao tong about ��

		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
			local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.liaoshang_fail=function()
			   self:liaoshang_fail()
			end
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 and h.qi_percent>=80 then
			print("��ͨ����")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.liaoshang_fail=self.liaoshang_fail
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			 local sp=special_item.new()

			sp.check_items_over=function()
			   print("������")
			  for index,deal_function in pairs(sp.itemslist) do

			     if sp.itemslistNum[index]==nil then
				  self:buy_qiao()
			     else
			      self:ask_job()
			     end
			    break
			  end
	        end
            local equip={}
	         equip=Split("<����>����","|")
              sp:check_items(equip)
			end
			b:check()
		end
	end
	h:check()
end

--465
function caikuang:buy_fromxiaofan()
   wait.make(function()
      world.Send("list")
		world.Send("buy tieqiao")
		local l,w=wait.regexp("^(> |)����.*�ļ۸��.*����������һ(��|��)(.*)��$",5)
		if l==nil then
		   self:follow_xiaofan()
		   return --> ������ʮ���������ļ۸�Ӳɿ�ʦ������������һ�����¡�
		end
		if string.find(l,"��������") then
		   world.Send("follow none")
		   self:ask_job()
		   return
		end

   end)
end

function caikuang:follow_xiaofan()
  world.Send("follow dali xiaofan")
  world.Send("follow shifu")
  world.Send("set follow")
  wait.make(function()
     local l,w=wait.regexp("^(> |)���������(.*)һ���ж���$|^(> |)���Ѿ��������ˡ�$|^(> |)�趨����������follow = \\\"YES\\\"$",5)
	 if l==nil then
	    self:follow_xiaofan()
	    return
	 end
	 if string.find(l,"���������") or string.find(l,"���Ѿ���������") then
	    world.Send("say �����齣�ǹ�����������Ϊ����̯���ʹ���")
		self:buy_fromxiaofan()
		return
	 end
	 if string.find(l,"�趨��������") then
		coroutine.resume(equipments.co)
	    return
	 end
  end)
end

function caikuang:buy_qiao()
--Tiechui
--Jian dao
   local rooms={}
   table.insert(rooms,76)
   table.insert(rooms,74)
   table.insert(rooms,97)
   table.insert(rooms,75)
   table.insert(rooms,87)
   table.insert(rooms,88)
   table.insert(rooms,73)
   table.insert(rooms,96)
   table.insert(rooms,100)
    table.insert(rooms,71)
	 table.insert(rooms,94)
	  table.insert(rooms,80)
	   table.insert(rooms,83)
	    table.insert(rooms,81)
		 table.insert(rooms,82)
		  table.insert(rooms,68)
		   table.insert(rooms,70)
		    table.insert(rooms,73)


  --[[ table.insert(rooms,427)
   table.insert(rooms,428)
    table.insert(rooms,429)
   table.insert(rooms,430)
   table.insert(rooms,431)
	table.insert(rooms,432)
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
   table.insert(rooms,466)--]]
   --sz���������
   equipments.co=coroutine.create(function()
    for _,r in ipairs(rooms) do
      local w=walk.new()
	  w.walkover=function()
	    self:follow_xiaofan()
	  end
	  w:go(r)
	  coroutine.yield()
    end
	self:buy_qiao()
  end)
  coroutine.resume(equipments.co)
end

