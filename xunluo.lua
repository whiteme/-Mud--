
xunluo={
  new=function()
     local xl={}
	 setmetatable(xl,{__index=xunluo})
	 return xl
   end,
  co=nil,
  playername="����ʮ",
  check_ling_count=0,
  attacker_name="",
  neili_upper=1.9,
  huayin_npc="",
  current_exps=0,
  current_pot=0,
  xiulian="false",

}

local nod=false
--[[

�����ҵ�����»ask wulu about Ѳ�ߣ��õ�������Ϳ��Կ�ʼ��(��������
»��һ�����NPC�����Կ�������� follow���粻֪�����ķ�λ���������٣�
ask yin about yin wulu)��
    ��һ�����ӷ�ң����ʼ�������д���ӡ��
    �ڶ������ҵ��ĸ�������ӡ��
    �����������Ų��ɴ���ӡ��
    ���Ĳ�������Ұ������ӡ��
    ���岽�������޸�����ӡ��
    ������������ҵ�����» ask yin wulu about����ɲ� give wulu ling��
����»���Ѳ���������Ǻź󻹸��㡣
    ���߲�����ΤһЦ���� give wei ling �ʹ�����ˣ�

    �ڻ�ӡ���������˵�п����ˣ��͵���ľ��{w;e;e;w;w;e;e;w} ���߼��ξ�
�����һ��Attacker������������ȥ��ӡ��


����»������ʮ����һЦ��˵������Ȼ����������ڹ�������Сɳ��֮��ú�Ѳ�ߡ�
]]

function xunluo:ask_job(flag)
	 	 	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="ѯ�ʹ���",
	           task_step=1,
	           task_maxsteps=9,
	           task_location="",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
   local f=function()
      world.Send("ask wulu about Ѳ��")--����»˵���������ϴ�����Ѳ����������꣬��������Ϣһ�°ɡ�������»˵�������ţ���ո�Ѳ����ϣ�������ȥ��Ϣ��Ϣ�ɡ���
	  wait.make(function()
	     local l,w=wait.regexp("^(> |)����»˵���������ϴ�����Ѳ����������꣬��������Ϣһ�°ɡ���$|^(> |)����»˵�������ţ���ո�Ѳ����ϣ�������ȥ��Ϣ��Ϣ�ɡ���$|^(> |)����û������ˡ�$|^(> |)����»��"..self.playername.."����һЦ��˵������Ȼ����������ڹ�������Сɳ��֮��ú�Ѳ�ߡ�$|^(> |)����»˵��������!�㾹Ȼ��ͬʱ��������񣡡�$|^(> |)����»˵�������㲻����Ѳ������ô�����������$|^(> |)����»˵���������ǳ�����ɽ��ˮ�ģ����ش����⡣$|^(> |)����»˵�������㲻����Ѳ������ô�����������$",5)
         if l==nil then
		    self:ask_job()
		    return
		 end
		 if string.find(l,"����û�������") then
		    --print("test")
		    self:NextPoint()
		    return
		 end
		 if string.find(l,"���ϴ�����Ѳ�����������") then
		    --print("����")
		    world.Send("follow none")
			local b=busy.new()
		    b.interval=0.5
		    b.Next=function()
		      self.fail(101)
		    end
		    b:check()
		    return
		 end
         if string.find(l,"�㾹Ȼ��ͬʱ���������") then
			local b=busy.new()
		    b.interval=0.5
		    b.Next=function()
		      self.fail(102)
		    end
		    b:check()
             return
         end
		 if string.find(l,"��ո�Ѳ����ϣ�������ȥ��Ϣ��Ϣ��") then
		    --world.Send("follow none")
		    self:giveup(true)
		    return
		 end
		 if string.find(l,"���ش�����") then
		    self:ask_job(true)
		    return
		 end
		 if string.find(l,"����ڹ�������Сɳ��֮��ú�Ѳ��") or string.find(l,"�㲻����Ѳ����") then
		    world.Send("follow none")
			local b=busy.new()
			b.interval=0.5
			b.Next=function()
		      self:step1()
			end
			b:check()
		    return
		 end
	  end)
   end
   if flag==true then
      f()
   else
      self:wulu(f)
	end
end

function xunluo:fail(id)
end

local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    if v==r then
		   return true
		end
	end
	return false
end

function xunluo:xunluo(roomno,flag)
   if roomno==2243 and flag~=true then
       self:xl1()
   elseif roomno==2179 then
      local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
       self:xl2()
	  end
	  b:check()
   elseif roomno==2469 then
      local b=busy.new()
	  b.interval=0.5
      b.Next=function()
  	    self:xl3()
	  end
	  b:check()
   elseif roomno==2243 and flag==true then
        self:huayin("����","zhang zhong")
   elseif roomno==2888 then
      --��ӡ
	   local w=walk.new()
	   w.walkover=function()
	     self:here(2175)
	   end
       w:go(2175)
   elseif roomno==2175 then
      self:huayin("��ԫ","yan tan")
   elseif roomno==2887 then
            --�һ������Ȼ��ӡ
	   local w=walk.new()
	   w.walkover=function()
		  self:here(2178)
	   end
       w:go(2178)
   elseif roomno==2178 then
	    self:huayin("��Ȼ","xin ran")
   elseif roomno==2890 then
    --��ˮ�������
       local w=walk.new()
	   w.walkover=function()
		 self:here(2173)
	   end
       w:go(2173)
   elseif roomno==2173 then
		self:huayin("����","tang yang")
   elseif roomno==2889 then
       local w=walk.new()
	   w.walkover=function()
	     self:here(2455)
	   end
       w:go(2455)
	elseif roomno==2455 then
		self:huayin("ׯ�","zhuang zheng")
	elseif roomno==2168 and flag~=true then
	    self:xl4()
	elseif roomno==2168 and flag==true then
		self:huayin("�Ų���","wen cangsong")
	elseif roomno==2164 and flag~=true then
	  self:xl5()
	elseif roomno==2082 then
	  self:xl6()
	elseif roomno==2164 and flag==true then
	  self:huayin("��Ұ��","yin yewang")
    end
end

function xunluo:checkPlace(roomno,here,flag)

	if is_contain(roomno,here) then
	    print("������ȷλ��")
        self:xunluo(roomno,flag)
	else
	  local w=walk.new()
      w.walkover=function()
        self:here(roomno,flag)
      end
      w:go(roomno)
	end
end

function xunluo:here(roomno,flag)
   local f=function(r)
	 self:checkPlace(roomno,r,flag)
   end
   WhereAmI(f)
end
--[[����˵�������ȵȣ������ڼ���ء���
���ж���Ļ��ǧ���������ִ�Ĵָ�������ġ�
����˵�������ã��������Ѿ�Ѳ������ˣ��Ҹ��㻭ӡ�ɡ���
����˵�������ף����ǽ���ȥ������û�п��ɵ�������ô��ûȥ����

����˵�������ţ��ո��е���������˵���󿴼��˲�����ݵ��ˣ��������ȥ��������
���г�����󺰣�׳ʿ�����ͣ����ͣ�

���ж��������������ִ�Ĵָ�������ġ�
����˵�������ã��������Ѿ�Ѳ������ˣ��Ҹ��㻭ӡ�ɡ���
��ԫ���������������ִ�Ĵָ�������ġ�
��ԫ˵�������ã��������Ѿ�Ѳ������ˣ��Ҹ��㻭ӡ�ɡ���

���̽�ӵ�����Ѩ��ץ�����ţ�ȫ����������һ������ʱ���ɶ�����
> ѩɽ���ôӾ�ľ�����˹�����
̽��ת��������Ͳ����ˡ�

�߸�˧������ǰȥ�������ؽ�����ס����»��˫�֣�������˵����������
����»˵�������ã������������ȥ����Τ�����ɡ���
�������»һƬѲ���
> �߸�˧��������»�����йء���ɡ�����Ϣ��
����»���Ÿ߸�˧�����˵�ͷ��
����»˵������ �ã��߸�˧������ɵúܺã������Ƹ��Ұɡ���

����»��Ѳ������д��д������
����»����һƬѲ���
]]
--�Ų���˵�������ã��������Ѿ�Ѳ������ˣ��Ҹ��㻭ӡ�ɡ���
--�������Ľ�ݹ�����������ִ�Ĵָ�������ġ�
--��Ұ��˵�������㻹��Щ�ط�û��Ѳ�ߵ��ɣ��Ȳ�æ��ӡ����
function xunluo:wait_huayin(name,id)
  print("wait_huayin",name,id)
  wait.make(function()
     local l,w=wait.regexp("^(> |)"..name.."����(.*)���������ִ�Ĵָ�������ġ�$|^(> |)"..name.."˵���������(.*)�Ѿ�Ѳ�����ˣ���ȥ��ĵط������ɡ���$|^(> |)"..name.."����(.*)�󺰣�.*���ͣ����ͣ�$|^(> |)"..name.."˵�������ף����ǽ�(.*)ȥ������û�п��ɵ�������ô��ûȥ����$|^(> |)"..name.."����(.*)ҡ��ҡͷ��$",20)
	 if l==nil then
	   shutdown() --��ֹ���д�����
	   local b=busy.new()
		b.interval=0.5
		b.Next=function()
	        self:huayin(name,id)
		end
		b:check()
	   return
	 end
	 if string.find(l,"���������ִ�Ĵָ") then
	    print("............OK1...........",w[2])

	    shutdown() --��ֹ���д�����
	    if w[2]=="��" then

		 nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	        self:huayin_ok(name)
	      end
	      b:check()
		else
		  if self.xiulian=="false" then
		   self:huayin(name,id)
		 else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	    return
	 end
	if string.find(l,"������Ѿ�Ѳ������") then
	    print("............OK2...........",w[4])
	    shutdown() --��ֹ���д�����
	    if w[4]=="��" then

		 nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	        self:huayin_ok(name)
	      end
	      b:check()
		else
		  if self.xiulian=="false" then
		   self:huayin(name,id)
		 else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	   return
	 end

	if string.find(l,"���ͣ�����") then
	    print("............OK3...........",w[6])
	    shutdown() --��ֹ���д�����
	    if w[6]=="��" then

		  nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	         self.huayin_npc=name
             self:recover()
	      end
	      b:check()
		else
		 if self.xiulian=="false" then
		   self:huayin(name,id)
		 else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	    return
	end
	if string.find(l,"��ô��ûȥ")  then
	   print("............OK4...........",w[8])
	   shutdown() --��ֹ���д�����
	    if w[8]=="��" then

		 nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	         self.huayin_npc=name
             self:recover()
	      end
	      b:check()
		else
		  if self.xiulian=="false" then
		   self:huayin(name,id)
		 else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	   return
	end

	if string.find(l,"ҡ��ҡͷ") then
	    print("............OK5...........",w[10])
	    shutdown() --��ֹ���д�����
	    if w[10]=="��" then

		  nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	         self:xunluo_again(name)
	      end
	      b:check()
		else
		  if self.xiulian=="false" then
		   self:huayin(name,id)
		  else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	   return
	end
  end)
end


function xunluo:huayin_reply(name,id)
  wait.make(function()
     local l,w=wait.regexp("^(> |)"..name.."��������˵�ͷ��$|^(> |)"..name.."˵������������Ѿ�Ѳ�����ˣ���ȥ��ĵط������ɡ���$|^(> |)"..name.."������󺰣�.*�����ͣ����ͣ�$|^(> |)"..name.."˵�������ף����ǽ���ȥ������û�п��ɵ�������ô��ûȥ����$|^(> |)"..name.."˵�������ȵȣ������ڼ���ء���$|^(> |)"..name.."˵��������ȥ��ĵط��������Ȼ������Ѳ���������$|^(> |)"..name.."������ҡ��ҡͷ��$|^(> |)"..name.."˵����������û��Ѳ�ߣ�Ҫ�һ�ӡ�����$",5)
    if l==nil then
	   self:huayin(name,id)
	   return
	end
	if string.find(l,"�������") or string.find(l,"��ô��ûȥ") then
       --���� name id
	   self.huayin_npc=name
       self:recover()
	   return
	end
    if string.find(l,"���ִ�Ĵָ") or string.find(l,"������Ѿ�Ѳ������") then
       self:huayin_ok(name)
	   return
	end
	if string.find(l,"��������˵�ͷ") then
	   print("************",name,"����","*****************")
	   --BigData:Auto_catchData()
	   nod=true
	   self:wait_huayin(name,id)
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
	     self:dazuo() --�����ָ�����
	   end
	   b:check()
	   return
	end
	if string.find(l,"�ȵȣ������ڼ����") then
	   self:wait_huayin(name,id)
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
	     self:dazuo() --�����ָ�����
	   end
	   b:check()
       return
 	end
	if string.find(l,"��ȥ��ĵط�����") then
	   self:xunluo_back(name)
	   return
	end

	if string.find(l,"ҡ��ҡͷ") then
	   self:xunluo_again(name)
	   return
	end
	if string.find(l,"Ҫ�һ�ӡ����") then
	   self:Status_Check()
	   return
	end
  end)
end

function xunluo:huayin(name,id)
  world.Send("ask "..id.." about ��ӡ")
  world.Send("unset ask")
  wait.make(function()
     local l,w=wait.regexp("^(> |)����"..name.."�����йء���ӡ������Ϣ��$",5)
	 if l==nil then
	    self:huayin(name,id)
	    return
	 end
	 if string.find(l,"�����йء���ӡ������Ϣ") then
	   self:huayin_reply(name,id)
	   return
	 end
  end)
end

function xunluo:back()
   self:auto_kill()
   if self.huayin_npc=="����" then
       local w=walk.new()
       w.walkover=function()
          self:here(2243,true)
       end
       w:go(2243)
   elseif self.huayin_npc=="��ԫ" then
      local w=walk.new()
       w.walkover=function()
          self:here(2175,true)
       end
       w:go(2175)
   elseif self.huayin_npc=="��Ȼ" then
       local w=walk.new()
       w.walkover=function()
          self:here(2178,true)
       end
       w:go(2178)
   elseif self.huayin_npc=="����" then
       local w=walk.new()
       w.walkover=function()
          self:here(2173,true)
       end
       w:go(2173)
   elseif self.huayin_npc=="ׯ�" then
       local w=walk.new()
       w.walkover=function()
          self:here(2455,true)
       end
       w:go(2455)
   elseif self.huayin_npc=="�Ų���" then
      local w=walk.new()
       w.walkover=function()
          self:here(2168,true)
       end
       w:go(2168)
   elseif self.huayin_npc=="��Ұ��" then
      local w=walk.new()
       w.walkover=function()
          self:here(2164,true)
       end
       w:go(2164)
   end
end

function xunluo:huayin_ok(name)
   if name=="����" then
      self:step2()
   elseif name=="��ԫ" then
      self:step3()
   elseif name=="��Ȼ" then
      self:step4()
   elseif name=="����" then
      self:step5()
   elseif name=="ׯ�" then
      self:step6()
	elseif name=="�Ų���" then
	  self:step7()
	elseif name=="��Ұ��" then
	  self:reward()
   end
end

function xunluo:xunluo_again(name)
   nod=false
   if name=="����" then
      self:step1()
   elseif name=="��ԫ" then
      self:step2()
   elseif name=="��Ȼ" then
      self:step3()
   elseif name=="����" then
      self:step4()
   elseif name=="ׯ�" then
      self:step5()
	elseif name=="�Ų���" then
	  self:step6()
	elseif name=="��Ұ��" then
	  self:step7()
   end
end

function xunluo:xunluo_back(name)
   nod=false
   if name=="��ԫ" then
      self:step1()
   elseif name=="��Ȼ" then
      self:step2()
   elseif name=="����" then
      self:step3()
   elseif name=="ׯ�" then
      self:step4()
	elseif name=="�Ų���" then
	  self:step5()
	elseif name=="��Ұ��" then
	  self:step6()
   end
end
--����˵�������ţ��ո��е���������˵���󿴼��˲�����ݵ��ˣ��������ȥ��������
--���г�����󺰣�׳ʿ�����ͣ����ͣ�
function xunluo:xl1()
   world.Execute("w;e;e;w;n;w;e;e;w;n;nu;nu;enter;out;sd;sd;w;w;w;e;s;s;s;w;e;s")
   self:here(2179)
end

function xunluo:xl2()
   world.Execute("n;n;e;e;s;w;w;n;e;e;e;e;s;w;w;e;e;e;w;ed;ed;e")
   self:here(2469)
end
function xunluo:xl3()
   world.Execute("w;wu;wu;n;n;ne;nw;s;n;e;w;w;w;s;s")
   self:here(2243,true)
end

function xunluo:xl4()
   world.Execute("e;s;s;se;nw;e;e;w")
   self:here(2168,true)
end

function xunluo:xl5()
  world.Execute("sd;se;se;wd;nd;ed;nd;wd;se;se;s;sd;ed;nd;wd;s;e;e")
  self:here(2082)
end

function xunluo:xl6()
  world.Execute("w;w;n;eu;su;wu;nu;n;nw;nw;eu;su;wu;su;eu;nw;nw;nu;n;n;s;w;e;e")
  local delay=function()
     world.Execute("w;s")
	 self:here(2164,true)
  end
  f_wait(delay,0.5)
end

function xunluo:step1()

	 	 	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="Ѱ������",
	           task_step=2,
	           task_maxsteps=9,
	           task_location="2243",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	self.huayin_npc="����"
	nod=false
   self:protect()
 local w=walk.new()
  w.walkover=function()
     self:here(2243)
  end
  w:go(2243)
end

--2243
function xunluo:step2()
	 	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="Ѱ����ԫ",
	           task_step=3,
	           task_maxsteps=9,
	           task_location="2888",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	 nod=false

	self.huayin_npc="��ԫ"
   self:protect()
 local w=walk.new()
  local al=alias.new()
  al.zishanlin_tiandifenglei=function()
    al:zishanlin_tiandifenglei_quick()
  end
  w.user_alias=al
  w.walkover=function()
     self:here(2888)
  end
  w:go(2888)
end

function xunluo:step3()


	 	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="Ѱ����Ȼ",
	           task_step=4,
	           task_maxsteps=9,
	           task_location="2887",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	 	self.huayin_npc="��Ȼ"
		nod=false
   self:protect()
 local w=walk.new()
   local al=alias.new()
  al.zishanlin_tiandifenglei=function()
    al:zishanlin_tiandifenglei_quick()
  end
  w.user_alias=al
  w.walkover=function()
     self:here(2887)
  end
  w:go(2887)
end

function xunluo:step4()

	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="Ѱ������",
	           task_step=5,
	           task_maxsteps=9,
	           task_location="2890",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	self.huayin_npc="����"
	nod=false
   self:protect()
  local w=walk.new()
    local al=alias.new()
  al.zishanlin_tiandifenglei=function()
    al:zishanlin_tiandifenglei_quick()
  end
  w.user_alias=al
  w.walkover=function()
     self:here(2890)
  end
  w:go(2890)

end

function xunluo:step5()


	 	 	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="Ѱ��ׯ�",
	           task_step=6,
	           task_maxsteps=9,
	           task_location="2889",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	    self.huayin_npc="ׯ�"
		nod=false
   self:protect()
  local w=walk.new()
    local al=alias.new()
  al.zishanlin_tiandifenglei=function()
    al:zishanlin_tiandifenglei_quick()
  end
  w.user_alias=al
  w.walkover=function()
     self:here(2889)
  end
  w:go(2889)
end

function xunluo:step6()
 	--[[local win=window.new() --��ش���
     win.name="status_window"
	 win:addText("label1","Ŀǰ����:Ѳ��")
	 win:addText("label2","Ŀǰ����:�Ų���")
     win:refresh()]]

	 	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="Ѱ���Ų���",
	           task_step=7,
	           task_maxsteps=9,
	           task_location="2168",
	           task_description="",
	      }
	       local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	self.huayin_npc="�Ų���"
	nod=false
   self:protect()
--��ľ��
  local w=walk.new()
  w.walkover=function()
     self:here(2168)
  end
  w:go(2168)
end


function xunluo:step7()
	 	 	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="Ѱ����Ұ��",
	           task_step=8,
	           task_maxsteps=9,
	           task_location="2164",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
   self.huayin_npc="��Ұ��"
   nod=false
   self:protect()
  --Ұ��
  local w=walk.new()
  w.walkover=function()
     self:here(2164)
  end
  w:go(2164)
end

function xunluo:NextPoint()
   print("�ָ��ӽ���")
   coroutine.resume(xunluo.co)
end

function xunluo:follow_wulu(cmd)
  wait.make(function()
    world.Send("follow wulu")
	 local l,w=wait.regexp("^(> |)����û�� wulu��$|^(> |)�������������»һ���ж���$|^(> |)���Ѿ��������ˡ�",5)
	 if l==nil then
	    self:follow_wulu(cmd)
	    return
	 end
	 if string.find(l,"����û�� wulu") then
		self:NextPoint()
		return
	 end
	 if string.find(l,"����»") or string.find(l,"���Ѿ���������") then
		cmd()
	    return
	 end
  end)
end

function xunluo:wulu(cmd)
  local w=walk.new()
  w.walkover=function()
     world.Send("ask yewang about yin wulu")
     --��Ұ��˵�������ţ�����»���������䳡һ��Ѳ�ߡ���
	  wait.make(function()
           local l,w=wait.regexp("^(> |)��Ұ��˵�������ţ�����»������(.*)һ��Ѳ�ߡ���",5)
		   if l==nil then
		      self:wulu(cmd)
		      return
		   end
		   if string.find(l,"һ��Ѳ��") then
			     local location=w[2]
		          print(location)
                 local n,rooms=Where("����"..location)

				  local b
			       b=busy.new()
				   b.interval=0.5
	               b.Next=function()
				      print("��������")
				      xunluo.co=coroutine.create(function()
		                --self:Search(rooms,cmd)
						 for _,r in ipairs(rooms) do
						   print("��ѯ�����:",r)
	                       local w
	                        w=walk.new()
	                        w.walkover=function()
		                       self:follow_wulu(cmd)
	                        end
							--
	                        w:go(r)
	                        coroutine.yield()
						 end
                         self:wulu(cmd) --���¿�ʼѰ��
				      end)
					  self:NextPoint()
			       end
			       b:check()
			end
	  end)
  end
  w:go(2164)
end

function xunluo:full()

	 local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)

		local get_pot=h.pot-self.current_pot
		print(self.current_pot,"->",h.pot,":",get_pot)
		local get_exp=h.exps-self.current_exps
		print(self.current_exps,"->",h.exps,":",get_exp)
		if self.current_pot==0 or self.current_exps==0 then
		   get_pot=0
		   get_exp=0
		end
		 --[[world.AppendToNotepad (WorldName(),os.date()..": Ѳ�߾���:".. get_exp.." Ǳ��:"..get_pot.."\r\n")
		 local exps=nil
		  exps=world.GetVariable("get_exp")
		  if exps==nil then
		    exps=0
		  end
		  --exps=tonumber(exps)+get_exp
		  --world.SetVariable("get_exp",exps)
		  --world.AppendToNotepad (WorldName(),os.date().."Ŀǰ����ܾ���ֵ"..exps.."\r\n")]]

	    if h.food<50 then
           print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
		       world.Send("ask xiao tong about ʳ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get zong zi;eat zong zi;eat zong zi;drop zong zi")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:full()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(2247) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif h.drink<50  then
		   print("drink")
		   local w
		   w=walk.new()
		   w.walkover=function()
		       world.Send("ask xiao tong about ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get tang;drink tang;drink tang;drink tang;drop tang")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:full()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(2247) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		else
		   self:jobDone()
		end
	  end
	h:check()
end

function xunluo:wei()
	  	local ts={
	           task_name="����Ѳ��",
	           task_stepname="ΤһЦ����",
	           task_step=9,
	           task_maxsteps=9,
	           task_location="",
	           task_description="",
	      }
	       local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()

  local w
  w=walk.new()
  w.walkover=function()
	 world.Send("give xunluo ling to wei yixiao")
	 wait.make(function()
	 --ΤһЦ����Ķ�������˵�����������ˣ���Щ������ȥ�úÿ��һ���ɡ�
	   local l,w=wait.regexp("^(> |)ΤһЦ����Ķ�������˵�����������ˣ���Щ������ȥ�úÿ��һ���ɡ�$|^(> |)ΤһЦ����Ķ�������˵�����������ˣ���Щ������ȥ�úÿ��һ���ɡ�$|^(> |)ΤһЦ����Ķ�������˵�������ȥ�Ž�������һ�Σ���������ʲô����Ҫ�����㡣$",10)
	   if l==nil then
	      self:wei()
		  return
	   end
	   if string.find(l,"��������") then
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		      self:full()
		   end
		   b:check()
	      return
	   end
	   if string.find(l,"��������ʲô����Ҫ������") then
	      world.Send("set ����QUEST")
	      world.ColourNote("yellow","red","��������yeah!")
		   world.AppendToNotepad (WorldName(),os.date()..":*****************************�������***********************\r\n")
	      return
	   end
	 end)
  end
  w:go(2240)
end

function xunluo:check_ling()
    self.check_ling_count=self.check_ling_count+1 --�������������5���Զ�����
	if self.check_ling_count>5 then
	   self:giveup()
	   return
	end
   local sp=special_item.new()
  --[[ sp.check_weapon_finish=function()

   end
   sp.weapon_lost=function()

   end]]
       sp.check_items_over=function()
	      print("������")
		for index,deal_function in pairs(sp.itemslist) do
		    --print("����3",index)
            --print(sp.itemslistNum[index],"����")
			if sp.itemslistNum[index]==nil then
			    local f=function()
	               self:get_ling()
	            end
	            self:wulu(f)
			else
			     self:wei()
			end
			break
        end
	   end
      local equip={}
	   equip=Split("<����>Ѳ����","|")
       sp:check_items(equip)
end

function xunluo:get_ling()
   -- ����»��Ѳ������д��д������
   -- ����»����һƬѲ���
   wait.make(function()
      local l,w= wait.regexp("^(> |)����»����һƬѲ���$",5)
	  if l==nil then
	     self:check_ling()
	     return
	  end
	  if string.find(l,"����»����һƬѲ����") then
	     world.Send("follow none")
	     self:wei()
	     return
	  end
   end)
end

function xunluo:give_ling()

   world.Send("give xunluo ling to wulu")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������»һƬѲ���$|^(> |)����û������ˡ�$",5)
	 if l==nil then
	    self:give_ling()
	    return
	 end
	 if string.find(l,"һƬѲ����") then
		self.check_ling_count=0
	    self:get_ling()
	    return
	 end
	 if string.find(l,"����û�������") then
	   local f=function()
	      self:give_ling()
	   end
	   self:wulu(f)
	   return
	 end
   end)
end
--����»˵��������������ô�ò�Ѳ���꣬����û�ã���
function xunluo:reward(flag)
  f=function()
    wait.make(function()
      world.Send("ask wulu about ���")
	   local l,w=wait.regexp("^(> |)����»˵������ �ã�"..self.playername.."����ɵúܺã������Ƹ��Ұɡ���$|^(> |)����»˵��.*����ô�ò�Ѳ����.*$|^(> |)����û������ˡ�$|^(> |)����»˵���������ǳ�����ɽ��ˮ�ģ����ش����⡣$",5)
	   if l==nil then
	      self:reward()
		  return
	   end
	   if string.find(l,"����û�������") then
	      self:reward()
		  return
	   end
	   if string.find(l,"�����Ƹ��Ұ�") then
	       local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
	         self:give_ling()
		   end
		   b:check()
		  return
	   end
	   if string.find(l,"����ô�ò�Ѳ����") then
	      self:jobDone()
	      return
	   end
	   if string.find(l,"����»˵���������ǳ�����ɽ��ˮ�ģ����ش�����") then
	      local f=function()
       		  self:reward(false)
		  end
		  f_wait(f,0.5)
		  return
	   end
	end)
  end
  if flag==false then
     f()
  else
     self:wulu(f)
  end

  --world.Send("ask wulu about ���")
end

function xunluo:jobDone() --�ص�����
  print("Ĭ��jobdone")

end

--[[��������»�����йء�����������Ϣ��
����»����ʧ�����ˣ�����û���ˡ���
����»˵�������������Ϣһ�ᣬ������������Ѳ�߰ɡ���
]]
function xunluo:giveup(flag)
  f=function()
     wait.make(function()
	    world.Send("ask wulu about ����")
		-- self:after_giveup()
	    local l,w=wait.regexp("^(> |)����»����ʧ�����ˣ�����û���ˡ�$|^(> |)����»˵�������������������û����������ʲô������$|^(> |)����»˵��������ոշ�����������Ҫ����ʲô������$",5)
		if l==nil then
		  self:giveup()
		  return
		end
		if string.find(l,"��û����") then
		   world.Send("follow none")
           local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:jobDone()
		   end
		   b:check()
		  return
		end
		if string.find(l,"����ʲô��") then
		   self:Status_Check()
		   return
		end
     end)
  end
  if flag==true then
     f()
  else
     self:wulu(f)
  end

end

function xunluo:Status_Check()

     --��ʼ��
     local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
		self.current_exps=h.exps
		self.current_pot=h.pot
	    if h.food<70 then
           print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
		       world.Send("ask xiao tong about ʳ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get zong zi;eat zong zi;eat zong zi;drop zong zi")
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
		   w:go(2247) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif h.drink<70  then
		   print("drink")
		   local w
		   w=walk.new()
		   w.walkover=function()
		       world.Send("ask xiao tong about ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get tang;drink tang;drink tang;drink tang;drop tang")
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
		   w:go(2247) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif  h.qi_percent<=liao_percent or h.jingxue_percent<=80 then
		    print("����")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("��ͨ����")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			-- rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		   --print(h.neili,h.max_neili*self.neili_upper," +++ ",self.neili_upper)
		    local x
			x=xiulian.new()
			x.halt=false
			x.min_amount=100
			x.safe_qi=h.max_qi*0.6
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun qi")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,3)
			    end
				if id==777 then
				   self:Status_Check()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(2457)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
				  world.Send("drop xunluo ling")
			      world.Send("drop xunluo ling")
			      world.Send("drop xunluo ling")
			     self:ask_job()
			   else
	             print("��������")
				 world.Send("yun qi")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  world.Send("drop xunluo ling")
			  world.Send("drop xunluo ling")
			  world.Send("drop xunluo ling")
			  self:ask_job()
			end
			b:check()
		end
	  end
	h:check()
end

--�������� ��ӡʱ��ȴ�
function xunluo:dazuo()
  print("nod:",nod)
  print("xiulian:",self.xiulian)
  if nod==false then
   if self.xiulian=="false" then
      print("������")
      return
   end
 end
   world.Send("unset ����")
   local x
   x=xiulian.new()
   x.safe_qi=400
   x.min_amount=100
   x.fail=function(id)
      print(id)
	  if id==1 or id==777 then
	     --��ѭ������
		 print("��ѭ������")
		 Send("yun recover")
		 x:dazuo()
	  end
	  if id==201 then
	      world.Send("yun regenerate")
		  x:dazuo()
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
	  if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then
		  print("��ѭ������")
		 Send("yun recover")
		 x:dazuo()
	  else
	     print("��������")
		 x:dazuo()
	  end
   end
   x:dazuo()
end

-----ս��ģ��
--[[
һ����ӰͻȻ�������˳�������ס���ȥ·��

̽�Ӷ�ݺݵض����㣺�������ҿ���������Ķ��ܡ�
������̽����ɱ���㣡

���̽�ӵĴ��Ѩ��ץ�����ţ�ȫ����������һ������ʱ���ɶ�����
> ̽��ת��������Ͳ����ˡ�
--> ������һ�Բ�����������������ǰ��
--]]

function xunluo:get_name()

end

function xunluo:auto_kill()
   world.ColourNote("salmon", "", "����auto_kill")
   wait.make(function()
   --|^(> |)һ����ӰͻȻ�������˳�������ס���ȥ·��$
      local l,w=wait.regexp("^(> |)(.*)��ݺݵض����㣺.*�ҿ���������Ķ��ܡ�$",10)--һ����ӰͻȻ�������˳�������ס���ȥ·��
	  --�����˶�ݺݵض����㣺�������ҿ���������Ķ��ܡ�
      if l==nil then
	    self:auto_kill()
		return
	  end
	  if string.find(l,"�ҿ���������Ķ���") then
         world.ColourNote("salmon", "", w[2].."���ҿ���������Ķ���")
	     shutdown()
	     self.attacker_name=w[2]
	     self:wait_attacker_escape(w[2])
		 print("ս����ʼ")
		 self:combat()
	  end
	  wait.time(10)
   end)
end


function xunluo:protect()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)һ�Բ�����������������ǰ��$",5)
	 if l==nil then
	     self:protect()
	     return
	 end
	 if string.find(l,"������������ǰ") then
	      print("����������������")
		   shutdown()
	       self.attacker_name=w[2]
	       self:wait_attacker_escape(w[2])
		   self:combat()
		   return
	  end
   end)
end

function xunluo:find_attacker()

  local w=walk.new()
  w.walkover=function()
     --world.Execute("e;s;s;se;nw;e;e;w;set walk")
	 world.Execute("w;e;e;w;w;e;e;w;set walk")
	 wait.make(function()
	    local l,w=wait.regexp("^(> |)(.*)һ�Բ�����������������ǰ��$|^(> |)�趨����������walk \\= \\\"YES\\\"$",5)
	    if l==nil then
 		    self:find_attacker()
		   return
		end
		if string.find(l,"������������ǰ") then
		   shutdown()
	       self.attacker_name=w[2]
	       self:wait_attacker_escape(w[2])
		   self:combat()
		   return
		end
		if string.find(l,"�趨����������walk") then
		   local f=function()
		     self:find_attacker()
		   end
		   f_wait(f,0.8)
		   return
		end
	 end)
  end
  w:go(2168)
end

function xunluo:combat()
    print("Ĭ��ս����ʼ")
end

function xunluo:attacker_escape()
end

function xunluo:wait_attacker_escape(attacker_name)
  wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)ת��������Ͳ����ˡ�$",5)
	 if l==nil then
	    self:wait_attacker_escape(attacker_name)
	    return
	 end
	 if string.find(l,"ת��������Ͳ�����") then
	    --print(murder_name,w[2])
	    if string.find(attacker_name,w[2]) then
		   self:attacker_escape()
		else
           self:wait_attacker_escape(attacker_name)
		end
	    return
	 end
	 wait.time(5)
  end)
end

--[[function xunluo:run(i)
     wait.make(function()
	   local l,w=wait.regexp("^(> |)��Ķ�����û����ɣ������ƶ���$|^(> |)������ʧ�ܡ�$|^(> |)�����Ϊ������$|^(> |)�趨����������action \\= \\\"����\\\"$",1.5)
	   if l==nil then
	      self:run(i)
	      return
	   end
	   if string.find(l,"�����Ϊ����") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"��Ķ�����û����ɣ������ƶ�") or string.find(l,"������ʧ��") then
		  self:run(i)
	      return
	   end
	   if string.find(l,"�趨����������action") then
		 world.DoAfter(1.5,"set action ����")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)�趨����������action \\= \\\"����\\\"$|^(> |)�趨����������action \\= \\\"����\\\"$",5)
			if l==nil then
			   self:run(i)
			  return
			end
			if string.find(l,"����") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"����") then
			   world.Send("unset wimpy")
			   shutdown()
			   self:giveup()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function xunluo:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("Ѱ�ҳ���")
     local dx=_R.get_all_exits()
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
end]]

function xunluo:recover()
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
				   self:auto_kill()
			       self:find_attacker()
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
			  self:auto_kill()
              self:find_attacker()
			end
			b:check()
		end
	end
	h:check()
end

function xunluo:recover2()
	--[[local win=window.new() --��ش���
     win.name="status_window"
	 win:addText("label1","Ŀǰ����:Ѳ��")
	 win:addText("label2","Ŀǰ����:���˻س�")
     win:refresh()]]

	local h
	h=hp.new()
	h.checkover=function()
        if h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover2()
			end
			rc:heal(false)
		elseif h.neili<math.floor(h.max_neili*1.2)  then
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
				   self:recover2()
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
					local r=nearest_room(roomno)
					 w:go(r)
				  end
				  _R:CatchStart()
			   end
			end
			x.success=function(h)
			   world.Send("yun recover")
			   if h.neili>math.floor(h.max_neili*1.2) then
				   self:auto_kill()
			       self:back()
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			local b
			b=busy.new()
			b.Next=function()
			  self:auto_kill()
              self:back()
			end
			b:check()
		end
	end
	h:check()
end
