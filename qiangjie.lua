 --[[2:                    ������������������ܡ�
 3: ������������������������������������������������������������
 4:
 5:     ���������Ŷ�����һ����������������ɵĹ����Զ�����������
 6: ���������������������������������������޲�̸��ɫ�䡣��Ȼ
 7: Ҳ������ФСǰȥͶ�����ɣ�Ϊ����������
 8:
 9: ������������������������������������������������������������
10:                         ������Ҫ��
11: ������������������������������������������������������������
12:
13:     ����ֵ����200k��С��1m���������10k��
14:
15: ������������������������������������������������������������
16:                         ��������̡�
17: ������������������������������������������������������������
18:
19:     ����duandi�󣬵���Ȼ�Ӵ���ask anran about ���١�Ȼ����Ȼ
20: �ӻ����ȥ˿��֮·�е�һ���ط�(���)�������������ȥ�����
21: һ�����ͻ����ģ��ٺ������һ�ᣬ�ͻ���һ�������̶Ӿ�������ʱ
22: ��Ȼ�ӻ���� qiang�̶ӣ�������ָ��󣬾ͻ��б����̶ӵı��ڳ�
23: �ֺ����ɱ�����̶�Ҳ�û������ˡ�ϵͳ�᲻����ʾ���̶���ȥ����
24: �����ɱ��һ��ʼ�ı��ں󣬾�����Ҫ��ȥ�̶����ڵĵط� qiang
25: ��Ȼ���ټ���ɱ���ڣ����ڵ�����������ľ�������ġ��̶ӵĻ
26: ��Χ���ڼ�ԣ�����ŵ����棬һ�����ӳ������Χ��������ʧ�ܣ���
27: ��ɱ���ڵ��ٶ�һ��Ҫ�졣
28:     ����������������Ҫ�ȴ�����ʱ���ȥ�����������µ�����
29:
30:
31:
��Ȼ������һЦ��˵�������������һ�������̶Ӿ������㹻���ͺ���һ��ȥ�����ɡ�
��Ȼ��˵�������һ���Щ��Ҫ�죬����ȥ����ӵ��ҡ���
 ���ȵ��������¶�������������� flatter �������ɣ�������أ�����
���Ž��ޱȡ�100K-300K(ʨ����)��300K-500K(������)��500K-800K(ժ����)
��ask XXX about ���ɣ����ǻ����һ���̵ѡ�
 ]]
require "wait"
require "map"
require "cond"
require "status_win"
qiangjie={
  new=function()
     local qj={}
	 setmetatable(qj,{__index=qiangjie})
	 return qj
  end,
  co=nil,
  neili_upper=1.5,
  biaoshi_num=2,
  id="hubiao biaoshi",
}

function qiangjie:combat()

end


function qiangjie:recover()
	local h
	h=hp.new()
	h.checkover=function()
        if h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()

			    self:recover()
			end
			rc:heal(false)
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.8
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				   world.Send("yun qi")
				   world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,4)
			    end
				if id==777 then
				   self:recover()
				end
	           if id==202 then
	             local w
				  w=walk.new()
				  w.walkover=function()
					 x:dazuo()
				  end
				  local _R
				  _R=Room.new()
				  R.CatchEnd=function()
					local count,roomno=Locate()
					local r=nearest_room(roomno)
					 w:go(r)
				  end
				  _R:CatchStart()
			   end
			end
			x.success=function(h)
			   world.Send("yun recover")
			   if h.neili>math.floor(h.max_neili*self.neili_upper) and h.qi>=h.max_qi*0.8  then
			      print("������")
				  world.SetVariable("qj_loc_refresh","true")--�������̶�
				  self:check(nil)
				  --self:shangdui()
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		elseif h.qi<=h.max_qi*0.8  then
		     world.Send("yun recover")
			 self:recover()
		else
			local b
			b=busy.new()
			b.Next=function()
			   world.SetVariable("qj_loc_refresh","true")--�������̶�
			   self:check(nil)
			end
			b:check()
		end
	end
	h:check()
end

function qiangjie:biaoshi_escape() --�ص�����
end

function qiangjie:biaoshi_leave()
--����սȦ��ת��������Ͳ����ˡ�
    --print("biaoshi_leave")
  wait.make(function()
     local l,w=wait.regexp("^(> |)������ʦ����սȦ��ת��������Ͳ����ˡ�$",10)

	 if l==nil then
	    self:biaoshi_leave()
	    return
	 end
	 if string.find(l,"ת��������Ͳ�����") then
        print("leave")
	   self.biaoshi_num=self.biaoshi_num-1
	   -- print("��ʦ����:"..self.biaoshi_num)
	   if self.biaoshi_num<=0 then
	        self:biaoshi_escape()
		else
		    self:biaoshi_leave()
	   end
	   return
	 end

  end)
end
--[[
�����̶Ӻ���������ʯ��һ����
ͻȻ���̶Ӻ�ܳ�һ��������ʦ��������˵���������㣡
������������ʦ��ɱ���㣡
������ʦ
����Σ��������: ������ʦ
ͻȻ���̶Ӻ�ܳ�һ��������ʦ��������˵���������㣡
������������ʦ��ɱ���㣡
������ʦ
����Σ��������: ������ʦ]]
function qiangjie:qiang()
	local ts={
	           task_name="��������",
	           task_stepname="���ٿ�ʼ",
	           task_step=4,
	           task_maxsteps=5,
	           task_location=world.GetVariable("qj_loc") or "",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()


  world.Send("qiang")
  --
  wait.make(function()
     local l,w=wait.regexp("^(> |)ͻȻ���̶Ӻ�ܳ�һ��������ʦ��������˵���������㣡$|^(> |).*���Ѿ����˱������������в�£�ֻ��ͣ���������������Ĳ���ԹԵ����ϣ�$|^(> |)������������ҹ��컯��֮�������̶ӣ����±�����������$��^(> |)������ʦ�����书�������㻹���ȴ�����ǰ�����˵�ɣ�$|^(> |)ʲô.*$")
   if string.find(l,"��������") or string.find(l,"������ʦ�����书����") then
      self.biaoshi_num=2
	 -- print("___________________________________________________")
      self:biaoshi_leave()
	  self:combat()
      return
   end
   if string.find(l,"ʲô") then
      print("??")
	  world.SetVariable("qj_loc_refresh","true")--�������̶�
	  self:shangdui()
      return
   end
   if string.find(l,"���±�����������") then
       self:NextPoint()
	   return
   end
	if string.find(l,"�������Ĳ���ԹԵ�����") then
	   self:reward()
	   return
	 end

  end)

end

function qiangjie:check(room)
  wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*�����̶�.*$|^(> |)�趨����������look \\= 1$",15)
	  if l==nil then
	     self:check(room)
		 return
	  end
	  if string.find(l,"�趨����������look") then
	     if roomno==nil then
		    self:shangdui()
		    return
		 end
		  local f=function(r)
		     if r[1]==room then
			    self:NextPoint()
			 else
			    print("û���ߵ�ָ������")
	            local w=walk.new()
		        w.walkover=function()
			      print("walk �¼�")
		          self:check(room)
		        end
			    w:go(room)
			 end
		  end
		  WhereAmI(f,10000)
	     return
	  end
	  if string.find(l,"�����̶�") then
	     self:qiang()
	     return
	  end
	  wait.time(15)
   end)
end

local shangdui_Place={}

shangdui_Place["������������"]=1864
shangdui_Place["˿��֮·"]=1865
shangdui_Place["������"]=1866
shangdui_Place["�����"]=1971
shangdui_Place["��Զ"]=1970
shangdui_Place["��ɽ����"]=1963
shangdui_Place["��¡ɽ"]=2091
shangdui_Place["��ɳɽ"]=1879
shangdui_Place["�¹Ȼ��ٹ��"]=1875
shangdui_Place["��ͷ���"]=1876
shangdui_Place["ɳ��"]=1874
shangdui_Place["��֬ɽ"]=1974
shangdui_Place["ʯ��"]=1590

--[[
mapping *dest = ({
([ "name":"yilihe",
           "context": ({
		"/d/xingxiu/yili/yili","/d/xingxiu/shanjiao","/d/xingxiu/silk9","/d/xingxiu/silk8","/d/xingxiu/silk7",
		"/d/xingxiu/silk6","/d/xingxiu/silk5","/d/xingxiu/silk4","/d/xingxiu/silk3","/d/xingxiu/silk2",
		"/d/xingxiu/silk1","/d/xingxiu/silk",
})]),

Start_Place["�����"]=1971

([ "name":"jygw",
           "context": ({
		"/d/xingxiu/silk","/d/xingxiu/silk1","/d/xingxiu/silk2","/d/xingxiu/silk3","/d/xingxiu/silk4",
		"/d/xingxiu/silk5","/d/xingxiu/silk6","/d/xingxiu/silk7","/d/xingxiu/silk8","/d/xingxiu/silk9",
		"/d/xingxiu/shanjiao","/d/xingxiu/yili/yili",
})]),

Start_Place["������������"]=1864
([ "name":"silk",
           "context": ({
		"/d/xingxiu/silk1","/d/xingxiu/silk2","/d/xingxiu/silk3","/d/xingxiu/silk4","/d/xingxiu/silk5a",
		"/d/xingxiu/silk7a","/d/xingxiu/silk7","/d/xingxiu/silk8","/d/xingxiu/silk9","/d/xingxiu/shanjiao",
		"/d/xingxiu/yili/yili",
})]),
([ "name":"silk1b",
           "context": ({
		"/d/xingxiu/silk1","/d/xingxiu/silk2","/d/xingxiu/silk3","/d/xingxiu/silk3a","/d/xingxiu/silk3b",
		"/d/xingxiu/silk3c","/d/xingxiu/silk7a","/d/xingxiu/silk7","/d/xingxiu/silk8","/d/xingxiu/silk10",
		"/d/xingxiu/yili/yili",
})]),

������=1866
([ "name":"yili",
           "context": ({
		"/d/xingxiu/silk10","/d/xingxiu/silk8","/d/xingxiu/silk7","/d/xingxiu/silk7a","/d/xingxiu/silk5a",
		"/d/xingxiu/silk4","/d/xingxiu/silk3","/d/xingxiu/silk2","/d/xingxiu/silk1","/d/xingxiu/silk1a",
		"/d/xingxiu/silk1b","/d/xingxiu/silk",
})]),
Start_Place["����"]=1970

([ "name":"shanjiao",
           "context": ({
		"/d/xingxiu/silk9","/d/xingxiu/silk8","/d/xingxiu/silk7","/d/xingxiu/silk7a","/d/xingxiu/silk3c",
		"/d/xingxiu/silk3b","/d/xingxiu/silk3a","/d/xingxiu/silk3","/d/xingxiu/silk2","/d/xingxiu/silk1",
		"/d/xingxiu/silk",
})]),
Start_Place["��ɽ����"]=1963

([ "name":"silk5b",
           "context": ({
		"/d/xingxiu/silk5","/d/xingxiu/silk5a","/d/xingxiu/silk7a","/d/xingxiu/silk3c","/d/xingxiu/silk3b",
		"/d/xingxiu/silk3a","/d/xingxiu/silk3","/d/xingxiu/silk2","/d/xingxiu/silk1","/d/xingxiu/silk1a",
		"/d/xingxiu/silk1b","/d/xingxiu/silk",
})]),
Start_Place["��¡ɽ"]=2091

([ "name":"silk3a",
           "context": ({
		"/d/xingxiu/silk3b","/d/xingxiu/silk3c","/d/xingxiu/silk7a","/d/xingxiu/silk5a","/d/xingxiu/silk5",
		"/d/xingxiu/silk6","/d/xingxiu/silk7","/d/xingxiu/silk8","/d/xingxiu/silk9","/d/xingxiu/shanjiao",
		"/d/xingxiu/yili/yili",
})]),
��ɳɽ=1879
([ "name":"silk8",
           "context": ({
		"/d/xingxiu/silk7","/d/xingxiu/silk6","/d/xingxiu/silk5","/d/xingxiu/silk5a","/d/xingxiu/silk7a",
		"/d/xingxiu/silk3c","/d/xingxiu/silk3b","/d/xingxiu/silk3a","/d/xingxiu/silk3","/d/xingxiu/silk2",
		"/d/xingxiu/silk1","/d/xingxiu/silk",
})]),
Start_Place["�¹Ȼ��ٹ��"]=1875
});]]

function qiangjie:shangdui()

   local location=world.GetVariable("qj_loc") or ""
   -- print(location," why")
   if location=="fail" then
      print("ʧ��")
      self:Status_Check()
      return
	else
	  world.SetVariable("qj_loc_refresh","false")
   end
   local rooms={}
   if shangdui_Place[location]==nil then
     print("û���ҶԶ�Ӧ�ص�:",location)
     local n
	 n,rooms=Where(location)
   else
    local room=shangdui_Place[location]

	table.insert(rooms,room)
   end
	rooms=depth_search(rooms,1)  --��Χ��ѯ
	   qiangjie.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
		    local refresh=world.GetVariable("qj_loc_refresh") or "false"
           if refresh=="true" then
		      print("����λ��ˢ����!!")
		       self:shangdui()
		       return
		   end

          local w
		  w=walk.new()
		  w.walkover=function()
		    self:check(r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
         local f=function()
		    print("�������̶�")
			 world.SetVariable("qj_loc_refresh","true")--�������̶�
		    self:shangdui()
		 end
		 f_wait(f,1.5)
	   end)
	   self:NextPoint()
end


function qiangjie:NextPoint()
   print("���ָ̻�")
   coroutine.resume(qiangjie.co)
end



--> �����̶Ӻ�����������֬ɽһ����

function qiangjie:wait()
    --��Ȼ�Ӷ��������������������(qiang)�̶ӣ������Ը������ˣ�
	--��Ȼ�Ӷ��������������������(qiang)�̶ӣ������Ը������ˣ�
	wait.make(function()
	    local l,w=wait.regexp("^(> |)�������ڳ����ˣ�$|^(> |)��Ȼ�Ӷ��������������������.*�̶ӣ������Ը������ˣ�$",10)
		if l==nil then
		   world.Send("look")
		   world.Send("flower")
           self:wait()
		   return
		end
		if string.find(l,"��Ȼ�Ӷ������������") or string.find(l,"�������ڳ�����") then
		   world.Send("say ��٣����е���ߣ�Ů���ұߣ�����վ���У�")
		   world.AddTriggerEx ("qj1", "^(> |)�����̶Ӻ���������(.*)һ����$", "world.SetVariable(\"qj_loc_refresh\",\"true\")\nprint(\"%2\")\nworld.SetVariable(\'qj_loc\',\"%2\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
           world.AddTriggerEx ("qj2", "^(> |)�����̶ӳɹ����ӽ��˳���$", "world.SetVariable(\"qj_loc_refresh\",\"true\")\nworld.SetVariable(\'qj_loc\','fail')", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)


		   self:qiang()
		   return
		end
	end)
end

function qiangjie:equipments()
	   local sp=special_item.new()
       sp.cooldown=function()
           self:ask_job()
       end
       local equip={}
	   equip=Split("<��ȡ>����|<��ȡ>����̵�","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

function qiangjie:anran(room)
  wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*��Ȼ��.*$|^(> |)�趨����������look \\= 1$",15)
	  if l==nil then
	     self:anran(room)
		 return
	  end
	  if string.find(l,"�趨����������look") then
		  local f=function(r)
		     if r[1]==room then
			    print("����Ŀ�ĵأ��ȴ���")
			    self:wait()
			 else
			    print("û���ߵ�ָ������")
	            local w=walk.new()
		        w.walkover=function()
			      print("walk �¼�")
		          self:anran(room)
		        end
			    w:go(room)
			 end
		  end
		  WhereAmI(f,10000)
	     return
	  end
	  if string.find(l,"��Ȼ��") then
	     self:wait()
	     return
	  end
	  wait.time(15)
   end)
end
--[[
mapping *quest = ({
  (["name":                "yilihe",
    "start" :              "/d/xingxiu/yili/yilihe",
    "place" :              "�����", ]),
  (["name":                "jygw",
    "start" :              "/d/xingxiu/jygw",
    "place" :              "������������",]),
  (["name":                "silk",
    "start" :              "/d/xingxiu/silk",
    "place" :              "������������˿��֮·",]),
  (["name":                "silk1b",
    "start" :              "/d/xingxiu/silk1b",
    "place" :              "������",]),
  (["name":                "yili",
    "start" :              "/d/xingxiu/yili/yili",
    "place" :              "����",]),
  (["name":                "shanjiao",
    "start" :              "/d/xingxiu/shanjiao",
    "place" :              "��ɽ����",]),
  (["name":                "silk5b",
    "start" :              "/d/xingxiu/silk5b",
    "place" :              "��¡ɽ",]),
  (["name":                "silk3a",
    "start" :              "/d/xingxiu/silk3a",
    "place" :              "��ɳɽ",]),
  (["name":                "silk8",
    "start" :              "/d/xingxiu/silk8",
    "place" :              "�¹Ȼ��ٹ��",]),
});    ]]

local Start_Place={}
Start_Place["�����"]=1971
Start_Place["������������"]=1864
Start_Place["������������˿��֮·"]=1865
Start_Place["������"]=1866
Start_Place["����"]=1970
Start_Place["��ɽ����"]=1963
Start_Place["��¡ɽ"]=2091
Start_Place["��ɳɽ"]=1879
Start_Place["�¹Ȼ��ٹ��"]=1875

--�̶��������أ�����(qiang)����


function qiangjie:find(location)
	local ts={
	           task_name="��������",
	           task_stepname="�Ⱥ��̶�",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	     local r=Start_Place[location]

          local w
		  w=walk.new()
		  w.walkover=function()
		    self:anran(r)
		  end
		  w:go(r)

	 end
	 b:check()

end

--[[function qiangjie:shangdui()
--��Ȼ��˵�������һ���Щ��Ҫ�죬����ȥ�����µ��ҡ���
--��Ȼ��˵�������һ���Щ��Ҫ�죬����ȥ����ӵ��ҡ���
   wait.make(function()
      local l,w=wait.regexp("",5)
	  if l==nil then
	      self:ask_job()
	      return
	  end


   end)
end]]
--��Ȼ������һЦ��˵�������������һ�������̶Ӿ������㹻���ͺ���һ��ȥ�����ɡ�
--��Ȼ�Ӷ�������˵�ͷ��
--��Ȼ��˵�������ã����Ǿ�����������������ɡ���
--ֻ��һ�����շ�����������һֻ�����̶ӳ�������ǰ��
--��Ȼ��˵�������һ���Щ��Ҫ�죬����ȥ�����µ��ҡ���
--��Ȼ�Ӷ��������������������(qiang)�̶ӣ������Ը������ˣ�
--�����̶Ӻ�����������ɳɽһ����
--�����̶ӳɹ����ӽ��˳���
--������ʦ����սȦ��ת��������Ͳ����ˡ�
--��Ȼ������һЦ��˵�������������һ�������̶Ӿ������㹻���ͺ���һ��ȥ�����ɡ�
function qiangjie:fail(id)
end

function qiangjie:ask_job()
	local ts={
	           task_name="��������",
	           task_stepname="ѯ�ʵص�",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
    w.walkover=function()
        world.Send("ask anran about ����")

		-- world.Send("set ask")
	     --world.Send("unset ask")
		wait.make(function()
		   local l,w=wait.regexp("^(> |)��Ȼ��˵�������һ���Щ��Ҫ�죬����ȥ(.*)���ҡ���$|^(> |)��Ȼ��˵�����������ڻ�û�еõ��κ���Ϣ����Ȼ�������ɡ���$|^(> |)����û������ˡ�$",5)
		   if l==nil then
		      self:ask_job()
		      return
		   end
		   if string.find(l,"�����ڻ�û�еõ��κ���Ϣ") or string.find(l,"����û�������") then
		       self.fail(102)
		      return
		   end
	       if string.find(l,"�һ���Щ��Ҫ��") then
		     print(w[2],"�ص�")
	         local location=w[2]
	          self:find(location)
	          return
	       end
		end)
		--self:shangdui()
    end
    w:go(1968)
end

function qiangjie:get_reward()
  --��Ȼ�Ӷ���˵������������ü�Ϊ��ɫ��������õõĲ��֣���ȥ�ɣ�
  wait.make(function()
    local l,w=wait.regexp("^(> |)��Ȼ�Ӷ���˵������������ü�Ϊ��ɫ��������õõĲ��֣���ȥ�ɣ�$",10)
	 if l==nil then
	     self:get_reward()
	     return
	 end
	 if string.find(l,"������õõĲ���") then
	     self:jobDone()
	     return
	 end
  end)
end

function qiangjie:reward()
	local ts={
	           task_name="��������",
	           task_stepname="����",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
    w.walkover=function()
        world.Send("give prize to anran")

		-- world.Send("set ask")
	     --world.Send("unset ask")
		wait.make(function()
		   local l,w=wait.regexp("^(> |)�����Ȼ��һ�������$",5)
		   if l==nil then
		      self:reward()
		      return
		   end
	       if string.find(l,"�����Ȼ��һ��") then
		       world.DeleteTrigger("qj1")
			   world.DeleteTrigger("qj2")
			   self:get_reward()
		     -- self:jobDone()
	          return
	       end
		end)
		--self:shangdui()
    end
    w:go(1968)
end

function qiangjie:jobDone()
end

function qiangjie:eat()
    local w=walk.new()
	w.walkover=function()
	      world.Execute("get cai yao")
		  world.Execute("eat cai yao;eat cai yao;eat cai yao;drop cai yao")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
	end
	w:go(2367)
end

function qiangjie:drink()
     local w=walk.new()
	   w.walkover=function()
	        world.Send("ask chu about ˮ")

		 local f
		  f=function()
			 world.Execute("get hulu")
		     world.Execute("drink hulu;drink hulu;drink hulu;drop hulu")
			self:full()
		  end
		  f_wait(f,1.5)
		end
		w:go(2367) --����¥ 976
end

function qiangjie:full()
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<30 or h.drink<30 then
		     if h.food<30 then
			    self:eat()
			 elseif h.drink<30 then
			    self:drink()
			 end
		elseif h.qi_percent<=30 or h.jingxue_percent<=80 then
		    print("����")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:liaoshang()
   		elseif h.jingxue_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun regenerate")
				  world.Send("yun recover")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
			    end
				if id==777 then
				  self:full()
				end
			   if id==202 then
			   --�������
				  local _R
                  _R=Room.new()
                  _R.CatchEnd=function()
                    local count,roomno=Locate(_R)
					local target_roomno=nearest_room(roomno)
                    local w
		            w=walk.new()
		            w.walkover=function()
			          self:full()
		            end
		            w:go(1968)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
               print("����:",h.max_neili*self.neili_upper)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     world.Send("yun recover")
			     self:equipments()
			   else
	             print("��������")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:equipments()
			end
			b:check()
		end
	end
	h:check()
end

function qiangjie:Status_Check()
	local ts={
	           task_name="��������",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local cd=cond.new()
	cd.over=function()
	          print("���״̬")
		     if table.getn(cd.lists)>0 then
		       local sec=0
		       for _,i in ipairs(cd.lists) do
			     if i[1]=="�����ƶ�" then
				   print("�ж���")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
			          self:Status_Check()
			        end
			        rc:qudu()
				    return
			     end
				 if i[1]=="����" or i[1]=="����ȭ����" then
				    print("����")
				    sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			            self:Status_Check()
					  end
					  f_wait(f,5)
			        end
			        rc:heal()
				    return
				 end
			   end
		     end
            self:full()
	end
	cd:start()
end

function qiangjie:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("Ѱ�ҳ���")
     local dx=_R:get_all_exits(_R)
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil or i>table.getn(dx) then
	    --����������
	     local n=table.getn(dx)
	     i=math.random(n)
		 print("���:",i)
	 end
	 local run_dx=dx[i]
	 print(run_dx, " ����")
	 local halt
	 if _R.roomname=="ϴ��ر�" then
	    world.Send("alias pfm "..run_dx..";set action ����")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set action ����")
	 end
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
	 self:run(run_dx,i)
   end
   _R:CatchStart()
end
