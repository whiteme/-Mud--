--���Ƶմ�����
tiezhang={
  new=function()
    local tz={}
	  setmetatable(tz,{__index=tiezhang})
	 return tz
  end,
  neili_upper=1.8,
}


function tiezhang:do_jobs()

end

function tiezhang:xiu()
   world.Send("repair կ��")
   wait.make(function()
    local l,w=wait.regexp("^(> |)�������ٸ�ʿ����ɱ���㣡$|^(> |)�㷢�ֻ������Ѿ���կ���޲��ò���ˣ�Ӧ�û�ȥ������!!$|^(> |)������û������������$|^(> |)���������������⹤�������������! $",2)

	if l==nil then
	   self:xiu()
	   return
	end
	if string.find(l,"�������ٸ�ʿ����ɱ����") then
	   shutdown()
	   world.Send("kill shibing")
	   world.Send("unwield tie chui")
	   self:combat()
	   return
	end
	if string.find(l,"���������������⹤�������������") then
	   self:go_fa_mu()
	   return
	end
	if string.find(l,"������û����������") then
	   self:repair_liba()
	   return
	end
	if string.find(l,"Ӧ�û�ȥ����") then
	   self:return_tools()
	   return
	end
  end)

end

function tiezhang:go_xiu()
local ts={
	           task_name="���Ƶմ�����",
	           task_stepname="��դ��",
	           task_step=2,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
   w.walkover=function()
      self:repair_liba()
   end
   w:go(246)
end

function tiezhang:repair_liba()
 local sp=special_item.new()
	sp.cooldown=function()
      world.Send("wield tie chui")
	  local f=function()
	  self:xiu()
	  end
	  f_wait(f,1)
   end
   sp:unwield_all()
end
--2698
--�㷢�ֵ��ϵ�ľͷ���ÿ�����һ���ˣ�Ӧ�û�ȥ������!!

--> �������ٸ�ʿ����ɱ���㣡
function tiezhang:fa_mu()
  world.Send("fa mu")
  wait.make(function()
    local l,w=wait.regexp("^(> |)�������ٸ�ʿ����ɱ���㣡$|^(> |)�㷢�ֵ��ϵ�ľͷ���ÿ�����һ���ˣ�Ӧ�û�ȥ������!!$|^(> |)������ʲô����ľ��$|^(> |)���������������⹤�������������! $",2)

	if l==nil then
	   self:fa_mu()
	   return
	end
	if string.find(l,"������ʲô����ľ") then
	   self:start_fa_mu()
	   return
	end
	if string.find(l,"���������������⹤�������������") then
	   self:go_wa_xianjing()
	   return
	end
	if string.find(l,"�������ٸ�ʿ����ɱ����") then
	   shutdown()
	   world.Send("unwield axe")
	   world.Send("kill shibing")
	   self:combat()
	   return
	end
	if string.find(l,"Ӧ�û�ȥ����") then
	   self:return_tools()
	   return
	end
  end)
end

function tiezhang:before_kill()

end

function tiezhang:jobDone()

end


function tiezhang:return_tools()
local ts={
	           task_name="���Ƶմ�����",
	           task_stepname="����",
	           task_step=3,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
    local w=walk.new()
   w.walkover=function()
       world.Send("give tong axe")
	   world.Send("give tong tie chui")
	   world.Send("give tong chan")
	   world.Execute("w;w;w;n;task ok")
	   self:jobDone()

   end
   w:go(2419)
end

function tiezhang:start_fa_mu()
  local sp=special_item.new()
	sp.cooldown=function()
      world.Send("wield axe")
	  local f=function()
	    self:fa_mu()
	  end
	  f_wait(f,1)
   end
   sp:unwield_all()
end

function tiezhang:go_fa_mu()
local ts={
	           task_name="���Ƶմ�����",
	           task_stepname="��ľ",
	           task_step=2,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
   w.walkover=function()
      self:start_fa_mu()
   end
   w:go(2698)

end

function tiezhang:wa_xianjing()
  world.Send("wa �ݾ�")
  wait.make(function()
    local l,w=wait.regexp("^(> |)�������ٸ�ʿ����ɱ���㣡$|^(> |)�㷢���ݾ����ںã��Ͻ���һЩ�ɲ������ݾ��ϣ���ȥ������!!$|^(> |)������ʲô���ڣ�$|^(> |)���������������⹤�������������! $",2)

	if l==nil then
	   self:wa_xianjing()
	   return
	end
	if string.find(l,"������ʲô����") then
	   local f=function()
	     self:start_wa_xianjing()
	   end
	   f_wait(f,2)
	   return
	end
	if string.find(l,"���������������⹤�������������") then
	   self:go_xiu()
	   return
	end
	if string.find(l,"�������ٸ�ʿ����ɱ����") then
	   shutdown()
	   world.Send("unwield tie chan")
	   world.Send("kill shibing")
	   self:combat()
	   return
	end
	if string.find(l,"��ȥ����") then
	   self:return_tools()
	   return
	end
  end)
end


function tiezhang:start_wa_xianjing()
  local sp=special_item.new()
	sp.cooldown=function()
      world.Send("wield tie chan")
	  local f=function()
	  self:wa_xianjing()
	  end
	  f_wait(f,1)
   end
   sp:unwield_all()
end

function tiezhang:go_wa_xianjing()
local ts={
	           task_name="���Ƶմ�����",
	           task_stepname="������",
	           task_step=2,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
      local w=walk.new()
   w.walkover=function()
      self:start_wa_xianjing()
   end
   w:go(244)
end

function tiezhang:ask_tools()
   world.Send("ask tong about ����")
   wait.make(function()
      local l,w=wait.regexp("^(> |)С��˵��������ָ��ɽ����һƬ�����֣�������ȥ��ľ�ɣ�������˵��������Ұ�ޣ�Ҫ���İ���$|^(> |)С��˵������ɽ�Ŷ����կ���޲�һ�£��Ѿ��кܳ�ʱ��û��ȥ�޲���կ���ˡ�$|^(> |)С��˵�������ݾ����ڹ㳡���ɽ·�ϣ��Է��������ɺ͹ٸ������ư����˺�Ѱ��$|^(> |)С��˵�������Ȱѹ��߻��ˣ����칤�߰ɡ�$",5)
	  if l==nil then
	     self:ask_tools()
	     return
	  end
	  if string.find(l,"������") then
	     self.do_jobs=function()
		    self:start_fa_mu()
		 end
		local b=busy.new()
	     b.Next=function()
	       self:go_fa_mu()
	     end
	     b:check()
	     return
	  end
	  if string.find(l,"���ݾ����ڹ㳡���ɽ·��") then
	      self.do_jobs=function()
		    self:start_wa_xianjing()
		 end
		local b=busy.new()
	     b.Next=function()
	       self:go_wa_xianjing()
	     end
	     b:check()

	  end
      if string.find(l,"կ���޲�") then
	      self.do_jobs=function()
		      self:repair_liba()
		   end
	     local b=busy.new()
	     b.Next=function()
	        self:go_xiu()
	     end
		b:check()
	     return
	  end
	  if string.find(l,"���Ȱѹ��߻���") then
	     world.Execute("look chui;look chan;look axe")
		 wait.make(function()
		   local l,w=wait.regexp("^(> |)����һ����������$|^(> |)����һ�Ѵ�������$|^(> |)����һ����ͨͨ��������$",5)
		   if l==nil then
		      self:ask_tools()
		      return
		   end
		   if string.find(l,"����") then

		      self.do_jobs=function()
		        self:repair_liba()
		      end
	          local b=busy.new()
	          b.Next=function()
	            self:go_xiu()
	         end
		     b:check()
		     return
		   end

		 if string.find(l,"������") then
		   self.do_jobs=function()
		      self:start_wa_xianjing()
		    end
		   local b=busy.new()
	        b.Next=function()
	          self:go_wa_xianjing()
	        end
	        b:check()
		    return
		 end

		 if string.find(l,"����") then

		   self.do_jobs=function()
		    self:start_fa_mu()
		   end
		  local b=busy.new()
	       b.Next=function()
	         self:go_fa_mu()
	       end
	       b:check()
		    return
		 end

	  end)
          return
	   end
   end)

end
--С��˵��������ָ��ɽ����һƬ�����֣�������ȥ��ľ�ɣ�������˵��������Ұ�ޣ�Ҫ���İ���
function tiezhang:get_tools()
 local w=walk.new()
   w.walkover=function()
       self:ask_tools()

   end
   w:go(2419)
end


function tiezhang:ask_job()
   local w=walk.new()
   w.walkover=function()
      world.Send("ask qiu about ����")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)��ǧ��˵������.*����û��ʲô�¿���������ʱ�������ɡ���$|^(> |)��ǧ��˵���������ư��Ҫ��ֹ�ٸ������ǵ���ˣ���Ҫ��ֹ�����������ɶ����ǰ���Ѱ��.*|^(> |)��ǧ��˵�������㲻���Ѿ����˹����𣿻�����ȥ������$",5)
		if l==nil then
		   self:ask_job()
		   return
		end
		if string.find(l,"����û��ʲô�¿���") then

	    	local b=busy.new()
			b.interval=0.3
			b.Next=function()
		       local f=function()
			      self:ask_job()
			   end
			   f_wait(f,5)
			end
			b:check()

		end

        if string.find(l,"���ư��Ҫ��ֹ�ٸ������ǵ����") or string.find(l,"������ȥ��") then
		    local b=busy.new()
	  b.Next=function()
	    self:before_kill()
	    self:get_tools()
	  end
	  b:check()
		   return
		end

	  end)


   end
   w:go(2389)
end

function tiezhang:full()
	 local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	 	local qi_percent=world.GetVariable("qi_percent") or 100
		qi_percent=assert(tonumber(qi_percent),"qi_percent���������������֣�") or 100
	local vip=world.GetVariable("vip") or "��ͨ���"
  	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="����������" then
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

		elseif h.jingxue_percent<=liao_percent or h.qi_percent<=80 then
		    print(h.jingxue_percent," jingxue_percent",h.qi_percent," qi_percent")
		   --�������ƶ�        �����                    �� �� ��
		   --�����ж���
			  print("����")
              local rc=heal.new()
			  rc.saferoom=234
			  --rc.teach_skill=teach_skill --config ȫ�ֱ���
			  rc.heal_ok=function()
			     heal_ok=true
			     self:Status_Check()
			  end
			  rc.liaoshang_fail=function()

			    self:liaoshang_fail()
			    local f=function()
					rc:heal(false,true)
				end
				local drugname
				local drugid
				if h.jingxue_percent<=80 then
				    drugname="��Ѫ�ƾ���"
				    drugid="huoxue dan"
				else
				    drugname="���ɽ�ҩ"
				    drugid="chantui yao"
				end
			    rc:buy_drug(drugname,drugid,f)
			end
			  rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("��ͨ����")
            local rc=heal.new()
			world.Send("set heal jing")
			rc.saferoom=234
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.heal_ok=function()
			    world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=234
			rc.heal_ok=function()
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(true,false)
        elseif h.neili<h.max_neili*0.5 then
		    local r=rest.new()
			r.wash_over=function()
                self:Status_Check()
            end
			r:wash()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
			if h.neili<=h.max_neili then
			  world.Send("fu chuanbei wan")
			end
		    heal_ok=false --��λ
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
			x.min_amount=100
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
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(234)
			   end
			end
			x.success=function(h)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     world.Send("yun recover")
			     self:ask_job()
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
			  self:ask_job()
			end
			b:check()
		end
	end
	h:check()
end


--�㷢�ֻ������Ѿ���կ���޲��ò���ˣ�Ӧ�û�ȥ������!!
function tiezhang:Status_Check()
  	local ts={
	           task_name="���Ƶմ�����",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=3,
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
			     local s,e=string.find(i[1],"��")
				 if s~=nil then
                    s=s%2
				 else
				    s=0
				 end
			     if i[1]=="�����ƶ�" or s==1 then
				   print("�ж���")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
					  local f=function()
			             self:Status_Check()
					  end
					  f_wait(f,3)
			        end
					if rc.omit_snake_poison==true and i[1]=="�߶�" then --�����߶�

					else
			          rc:qudu(sec,i[1],false)
					  return
					end
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
			        rc:heal(true,false)
				    return
				 end
			   end
		     end
            self:full()
		end
		cd:start()
end
