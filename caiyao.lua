--[[4124 lu
¹���ƶԹ���˵����������������,��ҩ�������������ˣ���Ҫһ���в�ҩ����
askk lu about ��ҩ
7018 datie pu
askk sun about ҩ��

648

4246
����ҩ�����������ܵĹ�ľ�Ӳݣ���ϸ�ؿ���û�в�ҩ��

����ҩ�����ϵĲ��������ܵ�ɽ�ݣ���Ȼ�����Ӳ�֮����һ���ر�Ĳݣ�
wa cao

���˷ܹ��ȣ���ҩ��һ˦�������°�һ����ҩ����Ϊ���أ�]]

caiyao={
  new=function()
     local cy={}
	 setmetatable(cy,{__index=caiyao})
	 return cy
  end,
  neili_upper=1.8,
  version=1.8,

}

function caiyao:ask_lu()
   local player_name=world.GetVariable("player_name") or ""
   world.Send("ask lu about ��ҩ")
   wait.make(function()
     local l,w=wait.regexp("^(> |)¹���ƶ�"..player_name.."˵����������������,��ҩ�������������ˣ���Ҫһ���в�ҩ����$|^(> |)¹����˵������"..player_name.."���Ҳ��ǰ�����ȥ��ҩȥ��ô���ǲ���͵���ˣ���$",5)

	 if l==nil then
		self:ask_job()
	    return
	 end
	 if string.find(l,"����������") or string.find(l,"�Ҳ��ǰ�����ȥ��ҩȥ") then
	    local b=busy.new()
		b.Next=function()
	    self:get_yaochu()
		end
		b:check()
	   return
	 end

   end)
end

function caiyao:Status_Check()
	local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)

	local vip=world.GetVariable("vip") or "��ͨ���"
	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if (h.food<50 or h.drink<50) and vip~="����������" and vip~="�¿����" then
		   print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
		     if h.food<50 then
		       world.Send("ask xiao tong about ʳ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get fan")
			  	 world.Execute("eat fan;eat fan;eat fan;eat fan;drop fan")
				 local f
				 f=function()
				   self:Status_Check()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 elseif h.drink<50 then
			   world.Send("ask xiao tong about ��")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			     world.Execute("get cha")
			  	 world.Execute("drink cha;drink cha;drink cha;drop cha")
				 local f
				 f=function()
				    self:Status_Check()
				 end
				 f_wait(f,1.5)
			   end
			   b:check()
			 end
		   end
		   w:go(133) --299 ask xiao tong about ʳ�� ask xiao tong about ��
		elseif h.qi_percent<=liao_percent or h.jingxue_percent<=80  then
		    print("����")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=4139
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=300
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==1 then
				  world.Send("yun recover")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
				end
				if id==777 then
				  self:Status_Check()
				end
				if id==201 then
				  world.Send("yun regenerate")
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,0.5)
			    end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(4139)
			   end
			end
			x.success=function(h)

			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     self:ask_job()
			   else
	             print("��������")
				 world.Send("yun qi")
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

function caiyao:ask_job()
  	local ts={
	           task_name="ȫ���ҩ",
	           task_stepname="ѯ��¹����",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
   w.walkover=function()
      self:shield()
      self:ask_lu()
   end
   w:go(4124)
end

--�ӿں���
function caiyao:jobDone()

end

function caiyao:get_yaochu()
 local ts={
	           task_name="ȫ���ҩ",
	           task_stepname="�ù���",
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
      world.Send("ask sun about ҩ��")
	  wait.make(function()
	    local l,w2=wait.regexp("^(> |)������������һ����ҩר�õ�ҩ����$|^(> |)������˵�������㲻�������𣬻���Ҫʲ�᣿��$",5)
		if l==nil then
		   self:get_yaochu()
		   return
		end
		if string.find(l,"������������һ����ҩר�õ�ҩ��") or string.find(l,"�㲻������") then
		   local b=busy.new()
		   b.Next=function()
		   self:search_caoyao()
		   end
		   b:check()
		   return
		end
	  end)
  end
  w:go(7018)
end

function caiyao:cun_pots()
   local w=walk.new()
   w.walkover=function()
      world.Send("qn_cun 100")
	  self:ask_job()
   end
   w:go(4067)
end

local drug_count=0

function caiyao:reward()
   local ts={
	           task_name="ȫ���ҩ",
	           task_stepname="����",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	drug_count=0
    local w=walk.new()
	w.walkover=function()
	   world.Send("give lu fu ling")
	   world.Send("give lu shouwu")
	   world.Send("give lu ju geng")
	   world.Send("give lu chuan bei")
	   world.Send("give lu jinyin hua")
	   world.Send("give lu sheng di")
	   world.Send("give lu gouzhi zi")
	   world.Send("give lu huang lian")
	   wait.make(function()
	     local l,w=wait.regexp("^(> |)��ϲ�㣡��ɹ��������ȫ���ҩ�����㱻�����ˣ�$",2)
		 if l==nil then
			self:jobDone()
		    return
		 end
		 if string.find(l,"��ɹ��������ȫ���ҩ����") then
		    self:jobDone()
		    return
		 end
	   end)

	end
	w:go(4124)
end

function caiyao:wa_caoyao()
   local ts={
	           task_name="ȫ���ҩ",
	           task_stepname="��ҩ",
	           task_step=4,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   world.Send("wa cao")
   drug_count=drug_count+1
   local f=function()
      if drug_count>3 then
        self:reward()
	  else
	     self:get_yaochu()
	  end
   end
   f_wait(f,0.8)

end

function caiyao:shield()

end

function caiyao:next_search()
   _R=Room.new()
  _R.CatchEnd=function()
     if _R.exits=="east;north;" then
		world.Execute("n;n;n;n")
	 else
         world.Send("south")
  	 end

      self:search()
   end
  _R:CatchStart()


end
--ͻȻ�Ӳݴ��о���һֻ÷��¹����������˾��ţ������Ƶ����㷢�������
--����������Ѱ�ҵ�С����谭�����Ѱ�Ҳ�ҩ��
function caiyao:combat()

end

function caiyao:run(i)
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
			   self:recover()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function caiyao:flee()
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

function caiyao:recover()
	local h
	h=hp.new()
	h.checkover=function()
	    --print(h.food,h.drink)

		if  h.qi_percent<=70 or h.jingxue_percent<=80  then
		    print("����")
            local rc=heal.new()
			--rc.teach_skill=teach_skill --config ȫ�ֱ���
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper)  then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.danger=function()
			   world.Send("yun qi")
			   world.Send("yun jingli")
			   local w=walk.new()
			   w.walkover=function()
			      x:dazuo()
			   end
			   w:go(53)
			end
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  if h.jingxue_percent<=60 then
				     self:recover()
				     return
				  end
	              local f
		          f=function() x:dazuo() end  --���
				  f_wait(f,10)
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
		         w:go(1512)
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   world.Send("yun recover")
			   if h.neili>h.max_neili*2-200 then
			     self:search()
			   else
	             print("��������")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:search()
			end
			b:check()
		end
	end
	h:check()
end

function caiyao:search()
   world.Send("search")
   wait.make(function()
      local l,w=wait.regexp("(> |)ͻȻ�Ӳݴ��о���һֻ(.*)����������˾��ţ������Ƶ����㷢�������$|^(> |)����ҩ�����ϵĲ��������ܵ�ɽ�ݣ���Ȼ�����Ӳ�֮����һ���ر�Ĳݣ�$|^(> |)������ܵĹ�ľ�Ӳݶ������ˣ�����û����ʲô����������ûָ���ˣ�$|^(> |)��û�й��ߣ��޷�������ľɽ��Ѱ�Ҳ�ҩ��$|^(> |)����������Ѱ�ҵ�С����谭�����Ѱ�Ҳ�ҩ��$",2)
	  if l==nil then
		 self:search()
		return
	  end
	 --[[ if string.find(l,"��ϸ�ؿ���û�в�ҩ") then
	    local f=function()
	      self:search()
		end
		f_wait(f,1)
	    return
	  end]]

	  if string.find(l,"��û�й��ߣ��޷�������ľɽ��Ѱ�Ҳ�ҩ") then
	     self:get_yaochu()
	     return
	  end
	  if string.find(l,"������ܵĹ�ľ�Ӳݶ������ˣ�����û����ʲô") then
	     local b=busy.new()
		 b.Next=function()
	       self:next_search()
		 end
		 b:check()
		return
	  end
	  if string.find(l,"�����Ƶ����㷢�����") then
	      world.Send("kill deer")
		 world.Send("kill baozi")
		 world.Send("kill bee")
		 world.Send("kill monkey")
		 world.Send("kill ye tu")
		  world.Send("kill wuya")
		 self:combat()
	     return
	  end
	  if string.find(l,"����������Ѱ�ҵ�С����") then
	     world.Send("kill deer")
		 world.Send("kill baozi")
		 world.Send("kill bee")
		 world.Send("kill monkey")
		 world.Send("kill ye tu")
		 world.Send("kill wuya")
		 self:combat()
	     return
	  end
	  if string.find(l,"��Ȼ�����Ӳ�֮����һ���ر�Ĳ�") then
	    local b=busy.new()
		b.Next=function()
		   self:wa_caoyao()
		end
		b:check()
	     return
	  end
   end)
end

function caiyao:search_caoyao()
  local ts={
	           task_name="ȫ���ҩ",
	           task_stepname="������ҩ",
	           task_step=3,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
  local w=walk.new()
  w.walkover=function()
     local r=math.random(0,4)
	 if r~=0 then
	   world.Execute("#"..r.." s")
	 end
     self:search()
  end
  w:go(4246)

end
