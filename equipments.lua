
equipments={
  new=function()
     local eq={}
	 setmetatable(eq,equipments)
	 eq.lists={}
	 eq:register()
	 return eq
  end,
  lists={},
  eq_co=nil,
  pi=0,
  count=10,
  version=1.8,
}
equipments.__index=equipments
--  һ������(Jin he)

--[[��������ᣬ������·���ڰ�ť��һ�������ӵļв���˿�����
һ�ŷ��Ƶ�ֽ����д��ģ���ļ�����:
���ݺὭ��ʱ�����������ִ�ĦԺ����Щ�����£�����Ե��ǰȥ�ھ�(dig)��]]
--�������� ��Ʒ
--[[function equipments:putianshaolin()
  local w
  w=walk.new()
  w.walkover=function()
     world.Send("kill seng")
  end
  w:go(1903)

end
--ѩ��Ƥ
function equipments:xuebaopi()
end
--�������Ƥ
function equipments:longpi()
  wait.make(function()
    world.Send("kan ɽ��")
	--�µ������������У���һ��ɽ���ƺ�ͦ�⻬������������(climb)��ȥ��
	local l,w=wait.regexp("^(> |)�µ������������У���һ��ɽ���ƺ�ͦ�⻬������������\\\(climb\\\)��ȥ��",5)
	if l==nil then
	   self:longpi()
	   return
	end
	if string.find(l,"��һ��ɽ���ƺ�ͦ�⻬") then
	  world.Send("climb")
	  world.Send("kill shenlong")
	  world.Send("get pi")
	end
	wait.time(5)
  end)
end

function equipments:shaya()
  local w
  w=walk.new()
  w.walkover=function()
     self:longpi()
  end
  w:go(1809)
end]]
function equipments:kill_Next_Point(num)
  print(self.count,"ʣ�����")
  if self.pi>=num or self.count<=0 then
      self:finish()
      return
  else
      self.count=self.count-1
  end
   local w=walk.new()
   w.walkover=function()
      self:look_here(num)
   end
   w:go(2677)
end

function equipments:get_pi(num)
   world.Send("get pi")
   wait.make(function()
     local l,w=wait.regexp("�����һ����Ƥ��",5)
	 if l==nil then
	   self:look_here(num)
	   return
	 end
	 if string.find(l,"�����") then
	    self.pi=self.pi+1
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()

	      --world.Send("remove all")
          world.Send("wear all")
		  if num==nil then num=1 end
		  if num<=self.pi then
            self:finish()
		  else
		    self:look_here(num)
		  end
		end
		b:check()
	   return
	 end
	 wait.time(5)
   end)
end

function equipments:wandao()
    local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
	    local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
	    world.Send("kill chou")
		local l,w=wait.regexp("^(> |).*��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:jinbishou()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
		   local b=busy.new()
	        b.Next=function()
		     world.Send("get all from corpse")
		     self:wandao()
		   end
		   b:check()
		   return
		end
		if string.find(l,"����û�������") then
		   self:finish()
		   return
		end
		wait.time(10)
	 end)
   end
	w:go(1653)
end

function equipments:bear(num)
   local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
  world.Send("kill xiong")
   world.Send("kill hu")
   world.Send("kill bao zi")

  wait.make(function()

   local l,w=wait.regexp("(�����|�ϻ�|����)�Һ�һ���������������ˣ�|(�����|�ϻ�|����)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�",10)
	if l==nil then
	   self:look_here(num)
	   return
	end
	if string.find(l,"����") then
	   self:look_here(num)
	   return
	end
	wait.time(10)
  end)
end

function equipments:look_here(num)
--����ܲҺ�һ���������������ˣ�
--�����һ����Ƥ��
   world.Send("look")
   world.Send("set look 1")
   wait.make(function()
     local l,w=wait.regexp(".*�����.*|.*�ϻ�.*|.*����\\(Bao zi\\).*|.*��Ƥ.*|.*��Ƥ.*|^(> |)�趨����������look \\= 1",5)
	  if l==nil then
	     self:kill_Next_Point(num)
	     return
	  end
	  if string.find(l,"�����") or string.find(l,"�ϻ�") or string.find(l,"����") then
	     print("����")
	     self:bear(num)
	     return
	  end
	  if string.find(l,"��Ƥ") or string.find(l,"��Ƥ") then
	     print("����")
	     self:get_pi(num)
	     return
	  end
	  if string.find(l,"�趨����������look") then
	     wait.time(1.5)
	     self:kill_Next_Point(num)
	     return
	  end

	end)
end

local bear_appear=os.time()-901
function equipments:xiongpi(num)
   local h=hp.new()
   h.checkover=function()
     if h.qi_percent>=100 and h.neili>=h.max_neili then
	   print("��ɱ�ܵ�����:",num)
       if os.difftime(os.time(),bear_appear)<=60*15 then
         print("ע�Ᵽ������")
         self:finish()
		 return
	   end
       bear_appear=os.time()
       self.pi=0
       self.count=10
       local pfm=world.GetVariable("huaxue_pfm") or ""
        world.Send("alias pfm "..pfm)
        world.Send("set wimpy 100")
        world.Send("set wimpycmd pfm\\hp\\cond")
        local w=walk.new()
        w.walkover=function()
		   world.Send("alias pfm "..pfm)
           world.Send("set wimpy 100")
           world.Send("set wimpycmd pfm\\hp\\cond")
          self:look_here(num)
        end
        w:go(2667)
	 else
        self:finish()
	 end
   end
   h:check()

end

function equipments:baicaodan()
	 local w
	 w=walk.new()
	 w.walkover=function()
		world.Send("ask chen about �ٲݵ�")
		wait.make(function()
		 local l,w=wait.regexp("^(> |)�³���˵�����������û���ж����������ʲô����$|^(> |)�³��ϸ���һ�Űٲݵ���$|^(> |)�³���˵������.*�ٲݵ�����������ϻ��У�������һЩ�����������ֵܰɣ�ؤ��������������$",5)
		 if l==nil then
		   self:baicaodan()
		   return
		 end
		 if string.find(l,"�³��ϸ���һ�Űٲݵ�") or string.find(l,"ؤ����������") then
		     local b
		      b=busy.new()
		      b.interval=0.5
		      b.Next=function()
			     --print("why2")
		        self.finish("�ٲݵ�","bai caodan",true)
		      end
		      b:check()
		      return
		 end
		 if string.find(l,"�����û���ж���") then
		      local b
		      b=busy.new()
		      b.interval=0.5
		      b.Next=function()
			   --print("why3")
		        self:finish()
		      end
		      b:check()
		      return
		 end
		end)
     end
     w:go(1002)
end

function equipments:jinbishou()
   local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
	     local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
	    world.Send("kill chen")
		local l,w=wait.regexp("^(> |)�´ﺣ��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:jinbishou()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
		   local b=busy.new()
	        b.Next=function()
		     world.Send("get bishou from corpse")
		     world.Send("get silver from corpse")
		     self:finish()
		   end
		   b:check()
		   return
		end
		if string.find(l,"����û�������") then
		   self:finish()
		   return
		end
		wait.time(10)
	 end)
   end
	w:go(2070)
end

function equipments:chaidao()
  local w=walk.new()
  w.walkover=function()
    world.Send("ask dashi about ��")
	local b=busy.new()
	b.Next=function()
      self:finish()
	end
	b:check()
  end
  w:go(3160)
end

function equipments:kill_chanshi()

   wait.make(function()

    local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
    world.Send("kill chanshi")
		local l,w=wait.regexp("^(> |)������ʦ��ž����һ�����ڵ��ϣ������ų鶯�˼��¾�����.*$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:kill_chanshi()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
		   local b=busy.new()
		   b.Next=function()
		     self:finish()
		   end
		   b:check()
		   return
		end
		if string.find(l,"����û�������") then
		   self:finish()
		   return
		end
   end)
end

function equipments:tiebeixin()
  local w=walk.new()
  w.walkover=function()

    world.Send("ask chanshi about ������")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)�������һ�������ġ�$|^(> |)����û������ˡ�$|^(> |)������ʦ˵��������Ǹ�������ò���ʱ�������Ѿ������ˡ���$",5)
	  if l==nil then
	     self:tiebeixin()
	     return
	  end
	  if string.find(l,"�����Ѿ�������") then
	     world.Send("kill chanshi")
		 local f=function()
		    self:finish()
		 end
		 f_wait(f,5)
	     return
	  end
	  if string.find(l,"����һ��������") or string.find(l,"����û�������") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  world.Send("ask chanshi about ����")
		  wait.time(2)
		  world.Send("ask chanshi about ɮЬ")
		  wait.time(2)
		  world.Send("ask chanshi about ����")
		  wait.time(2)
		    world.Send("ask chanshi about ��ָ")
		  wait.time(2)
		  world.Send("remove all")
		  world.Send("wear all")
		  self:finish()
		end
		b:check()
	    return
	  end

	end)

  end
  w:go(1763)
end

function equipments:mudao()
  local w=walk.new()
  w.walkover=function()
    world.Send("get mu dao")
    world.Send("ask chanshi about ľ��")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)��������һ��ľ����$|^(> |)������ʦ˵��������Ǹ�������ò���ʱ�������Ѿ������ˡ���$|^(> |)����û������ˡ�$",5)
	  if l==nil then
	     self:mudao()
	     return
	  end
	  if string.find(l,"��������һ��ľ��") or string.find(l,"����û�������") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  self:finish()
		end
		b:check()
	    return
	  end
	  if string.find(l,"�����Ѿ�������") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  self:kill_chanshi()
		end
		b:check()
		return
	  end
	  wait.time(5)
	end)

  end
  w:go(1762)
end

function equipments:falun()
   local w
   w=walk.new()
   w.walkover=function()

	    world.Send("ask fawang about ����")
		wait.time(2)
		self:finish()
   end

  w:go(2438)
end

function equipments:fenghuolun()
   local w
   w=walk.new()
   w.walkover=function()

	    world.Send("ask fawang about �����")
		wait.time(2)
		self:finish()
   end

  w:go(2438)
end

function equipments:changjian()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
	    world.Send("get chang jian")
		local l,w=wait.regexp("^(> |)�����һ��������$",5)
		if l==nil then
           self:changjian()
		   return
		end
		if string.find(l,"����һ������") then
		   self:finish()
		   return
		end
	 end)
   end
   w:go(5057)
end

function equipments:mujian()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
	    world.Send("buy mu jian")
		local l,w=wait.regexp("^(> |)����.*�ļ۸��ľ������������һ��ľ����$|ľ��˵������������Ķ���������û�С���$|ľ��˵��������⵰��һ�ߴ���ȥ��",5)
		if l==nil then
		   self:mujian()
		   return
		end
		if string.find(l,"������һ��ľ��") then
		   self:finish()
		   return
		end
		if string.find(l,"������û��") then
		   self:finish()
		   return
		end
		if string.find(l,"��⵰��һ�ߴ���ȥ") then
		   local f=function()
		      self:mujian()
		   end
		   qu_gold(f,1,50)
		   return
		end
		wait.time(5)
	 end)
   end
   w:go(168)
end

function equipments:huwan()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function() --����һ����������ʮ����ͭǮ�ļ۸��ľ������������һ˫���˻���
	    world.Send("buy huwan")
		local l,w=wait.regexp("^(> |)����.*�ļ۸��ľ������������һ˫���˻���$|ľ��˵������������Ķ���������û�С���$|ľ��˵��������⵰��һ�ߴ���ȥ��",5)
		if l==nil then
		   self:huwan()
		   return
		end
		if string.find(l,"������һ˫���˻���") then
		   world.Send("remove all")
		   world.Send("wear all")
		   self:finish()
		   return
		end
		if string.find(l,"������û��") then
		   self:finish()
		   return
		end
		if string.find(l,"��⵰��һ�ߴ���ȥ") then
		   local f=function()
		      self:huwan()
		   end
		   qu_gold(f,1,50)
		   return
		end
		wait.time(5)
	 end)
   end
   w:go(168)
end

function equipments:gangdao()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function() --����һ����������ʮ����ͭǮ�ļ۸��ľ������������һ˫���˻���
	    world.Send("buy blade")
		local l,w=wait.regexp("^(> |)����.*�ļ۸��.*����������һ���ֵ���$|.*˵������������Ķ���������û�С���$|.*˵��������⵰��һ�ߴ���ȥ��",5)
		if l==nil then
		   self:gangdao()
		   return
		end
		if string.find(l,"������һ���ֵ�") then
		   self:finish()
		   return
		end
		if string.find(l,"������û��") then
		   self:finish()
		   return
		end
		if string.find(l,"��⵰��һ�ߴ���ȥ") then
		   local f=function()
		      self:gangdao()
		   end
		   qu_gold(f,1,50)
		   return
		end
		wait.time(5)
	 end)
   end
   w:go(345)
end

function equipments:neixiwan()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
	    world.Send("buy neixi wan")
		local l,w=wait.regexp("����.*�ļ۸��ҩ���ƹ�����������һ����Ϣ�衣|^(> |)������Ķ���������û�С�$|^(> |)��⵰��һ�ߴ���ȥ��|^(> |).*������Ǯ�����ˣ���Ʊ��û���ҵÿ���$",5)
		if l==nil then
		   self:neixiwan()
		   return
		end
		if string.find(l,"������Ķ���������û��") then
	      self:finish()
	      return
	    end
	    if string.find(l,"һ����Ϣ��") then
          self:finish()
	      return
	    end
	    if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
	        local f=function()
		      self:neixiwan()
		    end
	        qu_gold(f,1,410)
	        return
	    end
	    wait.time(5)
	 end)
   end
   w:go(413)
end

function equipments:chuanbeiwan()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
	    world.Send("buy chuanbei wan")
		local l,w=wait.regexp("����.*�ļ۸��ҩ���ƹ�����������һ�Ŵ�����Ϣ�衣|^(> |)������Ķ���������û�С�$|^(> |)��⵰��һ�ߴ���ȥ��|^(> |).*������Ǯ�����ˣ���Ʊ��û���ҵÿ���$",5)
		if l==nil then
		   self:chuanbeiwan()
		   return
		end
		if string.find(l,"������Ķ���������û��") then
	      self:finish()
	      return
	    end
	    if string.find(l,"һ�Ŵ�����Ϣ��") then
          self:finish()
	      return
	    end
	    if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
	        local f=function()
		      self:chuanbeiwan()
		    end
	        qu_gold(f,3,410)
	        return
	    end
	    wait.time(5)
	 end)
   end
   w:go(413)
end

function equipments:longxiang()
   local w
   w=walk.new()
   w.walkover=function()
      world.Send("ask zhi about ʮ����������")
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
		  world.Send("remove all")
		  --world.Send("wear jiasha")
		  world.Send("wear all")
		  self:finish()
	  end
	  b:check()
   end
   w:go(3060)
end

function equipments:xuedao()
   local w
   w=walk.new()
   w.walkover=function()
      world.Send("ask laozu about Ѫ��")
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
		 --world.Send("remove all")
		  --world.Send("wear jiasha")
		  --world.Send("wear all")
		  self:finish()
	  end
	  b:check()
   end
   w:go(1660)
end

function equipments:songwenjian()
   local w
   w=walk.new()
   w.walkover=function()
      world.Send("ask zhang about ��ɽ")
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
		  world.Send("ask zhang about �̻�")
		--[[  ���䵱�ɡ��������������ɻ��˻��֡�

�����������һ�����ƽ���
������˵�����������Ϊ֮����
���������Ѿ��Զ�������ˡ�
ask zhang about �̻�
��������������йء��̻塻����Ϣ��
������˵��������Ϊ���������Ҷ������㣡ȥ�ɡ���]]
         local player_name=world.GetVariable("player_name")
          wait.make(function()
		     local l,w=wait.regexp("^(> |)�����������һ�ѹ��ⰻȻ��ľ����$|^(> |)������˵������.*����Ľ�һ��Ҫ�պá���",5)
		    if l==nil then
			    self:songwenjian()
			   return
			end
			if string.find(l,"���ⰻȻ��ľ��") then
			  wait.time(3)
			  --world.Send("drop sword 2")
			  --world.Send("get sword")
		      self:finish()
			  return
			end
			if string.find(l,"����Ľ�һ��Ҫ�պ�") then
			  world_init=function()
		         self:songwenjian()
		      end
			  local b=busy.new()
		      b.interval=0.5
 			  b.Next=function()
			     relogin(30)
		      end
		      b:check()
			  return
			end
		  end)
	  end
	  b:check()
   end
   w:go(2772)
end


function equipments:get_shuaijian(cmd)
   --> ˦���������̫���ˡ�
	world.Send(cmd)
	wait.make(function()
       local l,w=wait.regexp("^(> |)˦���������̫���ˡ�$|^(> |)�㸽��û������������$|^(> |)�����һ��˦����$",5)
	   if l==nil then
		  self:shuaijian()
		  return
	   end
	   if string.find(l,"˦���������̫����") then
	       self:get_shuaijian("get 1000 shuaijian")
	       return
	   end
    	if string.find(l,"�����һ��˦��") then
            self:finish()
		    return
		end
	  if string.find(l,"�㸽��û����������") then
		 local	_R=Room.new()
         _R.CatchEnd=function()
         local count,roomno=Locate(_R)
         --print("��ǰ�����",roomno[1])
	     if roomno[1]==2179  then
	       self:finish()
	     else
	       w:go(2179)
	     end
        end
        _R:CatchStart()
	  end
	end)
end

function equipments:shuaijian()
 local w
   w=walk.new()
   w.walkover=function()
    local b=busy.new()
	b.Next=function()
       self:get_shuaijian("get shuaijian")
	end
	b:check()
   end
  w:go(2179)
end

function equipments:pifeng()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()

	     local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
	    world.Send("kill wangzi")
		local l,w=wait.regexp("^(> |)�������ӡ�ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:pifeng()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
		   local b=busy.new()
	        b.Next=function()
		     world.Send("get pifeng from corpse")
		     world.Send("wear pifeng")
		     self:finish()
		   end
		   b:check()
		   return
		end
		if string.find(l,"����û�������") then
		--print("finish")
		   self:finish()
		   return
		end
		wait.time(10)
	 end)
   end
   w:go(1637)
end

function equipments:get_fan()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
	     local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
	    world.Send("kill ma qingxiong")
		local l,w=wait.regexp("^(> |)�����ۡ�ž����һ�����ڵ��ϣ������ų鶯�˼��¾�����.*$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:ruanxue()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
			local b=busy.new()
	        b.Next=function()
		   world.Send("get all from corpse")
		   world.Send("drop cloth")
		   world.Send("drop whip 2")
		   world.Send("get whip")
		   self:finish()
		   end
		   b:check()
		   return
		end
		if string.find(l,"����û�������") then
		   self:finish()
		   return
		end

	 end)
   end
   w:go(772)
end

function equipments:ruanxue()
 local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
	     local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
	    world.Send("kill wujiang")
		local l,w=wait.regexp("^(> |)�佫��ž����һ�����ڵ��ϣ������ų鶯�˼��¾�����.*$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:ruanxue()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
			local b=busy.new()
	        b.Next=function()
		   world.Send("get jian from corpse")
		   world.Send("get shoes from corpse")
		   world.Send("get armor from corpse")
		   world.Send("remove all")
		   world.Send("wear all")
		   self:finish()
		   end
		   b:check()
		   return
		end
		if string.find(l,"����û�������") then
		   self:finish()
		   return
		end
		wait.time(10)
	 end)
   end
   w:go(75)
end
--����ɮ��
function equipments:huju1()
 local w
   w=walk.new()
   w.walkover=function()
     world.Send("get zhitao")
	 world.Send("get hu wan")
	 world.Send("get hu yao")
     world.Send("wear all")
	 wait.make(function()
	      local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
	    world.Send("kill seng")
		local l,w=wait.regexp("^(> |)(����ɮ��|��ɮ)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:huju1()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
			local b=busy.new()
	        b.Next=function()
		     world.Send("get zhitao from corpse")
	         world.Send("get hu yao from corpse")
	         world.Send("get hu wan from corpse")
		     world.Send("wear all")
		     self:finish()
		   end
		    b:check()
		   return
		end
		if string.find(l,"����û�������") then
		   --print("û�������")
		   self:finish()
		   return
		end
		wait.time(10)
	 end)
   end
   w:go(1900)
end

function equipments:huju2()
 local w
   w=walk.new()
   w.walkover=function()
     world.Send("get zhitao")
	 world.Send("get hu wan")
	 world.Send("get hu yao")
     world.Send("wear all")
	 wait.make(function()
	     local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
	    world.Send("kill seng")
		local l,w=wait.regexp("^(> |)(����ɮ��|��ɮ)��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:huju2()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
			local b=busy.new()
	        b.Next=function()
		     world.Send("get zhitao from corpse")
	         world.Send("get hu yao from corpse")
	         world.Send("get hu wan from corpse")
		     world.Send("wear all")
		     self:finish()
		   end
		    b:check()
		   return
		end
		if string.find(l,"����û�������") then
		   --print("û�������")
		   self:huju1()
		   return
		end
		wait.time(10)
	 end)
   end
   w:go(1902)
end

function equipments:huju()
 local w
   w=walk.new()
   w.walkover=function()
     world.Send("get zhitao")
	 world.Send("get hu wan")
	 world.Send("get hu yao")
     world.Send("wear all")
	 wait.make(function()
	     local pfm=world.GetVariable("pfm") or ""
		world.Send("alias pfm "..pfm)
		world.Send("set wimpycmd pfm\\hp\\cond")
	    world.Send("kill seng")
		local l,w=wait.regexp("^(> |)��ɮ��ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$|^(> |)����û������ˡ�$",10)
		if l==nil then
		   self:huju()
		   return
		end
		if string.find(l,"�����ų鶯�˼��¾�����") then
			local b=busy.new()
	        b.Next=function()
		     world.Send("get zhitao from corpse")
	         world.Send("get hu yao from corpse")
	         world.Send("get hu wan from corpse")
		     world.Send("wear all")
		     self:finish()
		   end
		    b:check()
		   return
		end
		if string.find(l,"����û�������") then
		   --print("û�������")
		   self:huju2()
		   return
		end
		wait.time(10)
	 end)
   end
   w:go(1903)
end

function equipments:mumianjiasha()
   local w
   w=walk.new()
   w.walkover=function()
     wait.make(function()
         world.Send("ask jie about ľ������")
		 local l,w2=wait.regexp("^(> |)�ɽ�˵�������Ҳ��Ǹ�����ľ�����������$",3)
		 if l==nil then
			local b=busy.new()
			b.interval=0.5
	        b.Next=function()
		     world.Send("remove all")
		     world.Send("wear ruanwei jia")
		     world.Send("wear pi")
		     world.Send("wear all")
		     self:finish()
	        end
	        b:check()
		    return
		 end
		 if string.find(l,"�Ҳ��Ǹ�����ľ����������") then
			 world_init=function()
		         self:mumianjiasha()
		      end
			  local b=busy.new()
		      b.interval=0.5
 			  b.Next=function()
			     relogin(30)
		      end
		      b:check()
		    return
		 end

	  end)
   end
  w:go(3163)--2798
end

function equipments:jiuhuawan()
 local w
   w=walk.new()
   w.walkover=function()
      world.Send("get jiuhua wan")
	_R=Room.new()
    _R.CatchEnd=function()
      local count,roomno=Locate(_R)
	   print("��ǰ�����",roomno[1])
	  if roomno[1]==2486  then
	      self:finish()
	  else
	     w:go(2486)
	  end
     end
    _R:CatchStart()
   end
  w:go(2486)--2798
end

function equipments:ruanweijia()
   local w
   w=walk.new()
   w.walkover=function()
      world.Send("ask huang about ��⬼�")
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
		  world.Send("remove all")
		  world.Send("wear ruanwei jia")
		  world.Send("wear pi")
		  world.Send("wear all")
		  self:finish()
	  end
	  b:check()
   end
   w:go(2814)
end

function equipments:jiaohui()
  local h=hp.new()
  h.checkover=function()
     --print(h.shen," exp/10 ",h.exps/10)
    if h.shen>190000 and h.shen>h.exps/10 then
      local w=walk.new()
      w.walkover=function()
        world.Send("ask huang about �̻�")
	    local b=busy.new()
	    b.interval=0.3
	    b.Next=function()
	      self:finish()
	    end
	    b:check()
	  end
      w:go(2814)
    else
	  self:finish()
	end
  end
  h:check()
end

function equipments:finish()
   print("Ĭ�ϵ�finish")
end

function equipments:huxi()
--��������ϥ
  local w=walk.new()
  w.walkover=function()
    world.Send("ask shou about ��ϥ")
	local b=busy.new()
	 b.interval=0.3
	b.Next=function()
	  self:finish()
	end
	b:check()
  end
  w:go(1795)
end


--[[
������������������������������������������������������������������������������
��  ��  ��                          ��  ��                        ���/���� ��
�ǩ���������������������������������������������������������������������������
�����ѩ�轣(Snowsword)         �嶧�ƽ��־�ʮ��������              50/  50 ��
����������(Youlong bian)        �嶧�ƽ��ֶ�ʮ��������             100/ 100 ��
��������ʮ��ö�����滨��(Zhen)  ��ʮ�嶧�ƽ�����ʮ��������         100/ 100 ��
�����������(Zhu bang)          �߶��ƽ��־�ʮ��������             100/ 100 ��
������(Yu xiao)                 �嶧�ƽ�����ʮ������������ʮ��ͭǮ 100/ 100 ��
���ٱ�ذ��(Bishou)              �߶��ƽ��־�ʮ��������             100/ 100 ��
�����ô�(Kulou chui)            �Ŷ��ƽ��־�ʮ������               100/ 100 ��
����ü��(Tiegun)                �����ƽ�����ʮ������               100/ 100 ��
��������(Dafu)                �嶧�ƽ��־�ʮ��������             100/ 100 ��
����ֻ�ش�����(Falun)           ʮ���ƽ�����ʮ��������             100/ 100 ��
����ӧ������ǹ(Hongying qiang)  �Ŷ��ƽ��ֶ�ʮ��������             100/ 100 ��
������(Hanyu gou)             �˶��ƽ�����ʮ��������             100/ 100 ��
����ϻ(Jian xia)                ��ʮ�����ƽ�����ʮ������             2/   2 ��
��������(Lanyu duzhen)        ʮ���ƽ�����ʮ��������              20/  20 ��
����ѩ��(Xue sui)               �嶧�ƽ��־�ʮ��������              20/  20 ��
�����öɥ�Ŷ�(Sangmen ding)    ��ʮ�Ŷ��ƽ�����������             100/ 100 ��
���йٱ�(Panguan bi)            �߶��ƽ��־�ʮ��������             100/ 100 ��
�����߽�(Yinshe sword)          �߶��ƽ��ֶ�ʮ��������             120/ 120 ��
��������(Tianshe zhang)         �Ŷ��ƽ��־�ʮ������                20/  20 ��
��һ������������(Jiulong ling)  �Ķ��ƽ�����ʮ���������ֶ�ʮ��ͭǮ 200/ 200 ��
������������������������������������������������������������������������������]]

function equipments:register()
   self.lists={}
      self.lists["dahuan dan"]=function(num)

   	     self:dahuandan(num)
	 end
	 self.lists["�󻹵�"]=function(num)

   	     self:dahuandan(num)
	 end
	 self.lists["longpao"]=function(num)

   	     self:longpao()
	 end
	 self.lists["����"]=function(num)

   	     self:longpao()
	 end
     self.lists["snowsword"]=function(num)
	    local id="snowsword"
			 local name="���ѩ�轣"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["���ѩ�轣"]=function(num)
	    local id="snowsword"
			 local name="���ѩ�轣"
   	      self:bingqipu(name,id,num)
	 end

	self.lists["��������"]=function(num)
	    local id="youlong bian"
			 local name="��������"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["Youlong bian"]=function(num)
	    local id="youlong bian"
			 local name="��������"
   	      self:bingqipu(name,id,num)
	 end

	 self.lists["�����滨��"]=function(num)
	    local id="zhen"
			 local name="�����滨��"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["zhen"]=function(num)
	    local id="zhen"
			 local name="�����滨��"
   	      self:bingqipu(name,id,num)
	 end

	 self.lists["�����"]=function(num)
	    local id="zhu bang"
			 local name="�����"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["zhu bang"]=function(num)
	    local id="zhu bang"
				 local name="�����"
   	      self:bingqipu(name,id,num)
	 end

	 self.lists["����"]=function(num)
	    local id="yu xiao"
				 local name="����"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["Yu xiao"]=function(num)
	    local id="yu xiao"
			 local name="����"
   	      self:bingqipu(name,id,num)
	 end


	 --���ٱ�ذ��(Bishou)              �߶��ƽ��־�ʮ��������             100/ 100 ?

	 self.lists["�ٱ�ذ��"]=function(num)
	    local id="bishou"
			 local name="�ٱ�ذ��"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["bishou"]=function(num)
	    local id="bishou"
		 local name="�ٱ�ذ��"
   	      self:bingqipu(name,id,num)
	 end

--	 �����ô�(Kulou chui)            �Ŷ��ƽ��־�ʮ������               100/ 100 ��
	 self.lists["���ô�"]=function(num)
	    local id="kulou chui"
		   local name="���ô�"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["kulou chui"]=function(num)
	    local id="kulou chui"
		 local name="���ô�"
   	      self:bingqipu(name,id,num)
	 end
--����ü��(Tiegun)                �����ƽ�����ʮ������               100/ 100 ��
	 self.lists["��ü��"]=function(num)
	    local id="tiegun"
		   local name="��ü��"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["tiegun"]=function(num)
	     local id="tiegun"
		   local name="��ü��"
   	      self:bingqipu(name,id,num)
	 end
--��������(Dafu)                �嶧�ƽ��־�ʮ��������             100/ 100 ��
	 self.lists["������"]=function(num)
	    local id="dafu"
		  local name="������"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["dafu"]=function(num)
	     local id="dafu"
		  local name="������"
   	      self:bingqipu(name,id,num)
	 end
--����ֻ�ش�����(Falun)           ʮ���ƽ�����ʮ��������             100/ 100 ��
	 self.lists["�ش�����"]=function(num)
        print("�ش�����")
        local f=_G["fight_Roomno"]
	    local id="falun"
		local name="�ش�����"
		if f==nil or f=="" then
		   print("���¹���!")
		    self:bingqipu(name,id,num)
		else
		   print("���Լ������!")
		   self:getback_lostweapon(name,id,num)
   	    end
	 end
	 self.lists["falun"]=function(num)
	    local f=_G["fight_Roomno"]
	     local id="falun"
		  local name="�ش�����"
   	     if f==nil or f=="" then
		   print("���¹���!")
		    self:bingqipu(name,id,num)
		else
		   print("���Լ������!")
		   self:getback_lostweapon(name,id,num)
   	    end
	 end
--����ӧ������ǹ(Hongying qiang)  �Ŷ��ƽ��ֶ�ʮ��������             100/ 100 ��
	 self.lists["��ӧ������ǹ"]=function(num)
	    local id="hongying qiang"
		 local name="��ӧ������ǹ"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["hongying qiang"]=function(num)
	      local id="hongying qiang"
		     local name="��ӧ������ǹ"
   	      self:bingqipu(name,id,num)
	 end
--������(Hanyu gou)             �˶��ƽ�����ʮ��������             100/ 100 ��
	 self.lists["����"]=function(num)
	    local id="hanyu gou"
		   local name="����"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["hanyu gou"]=function(num)
	      local id="hanyu gou"
		  	   local name="����"
   	      self:bingqipu(name,id,num)
	 end
--����ϻ(Jian xia)                ��ʮ�����ƽ�����ʮ������             2/   2 ��
	 self.lists["��ϻ"]=function(num)
	    local id="jian xia"
		 local name="��ϻ"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["jian xia"]=function(num)
	      local id="jian xia"
		   local name="��ϻ"
   	      self:bingqipu(name,id,num)
	 end
--��������(Lanyu duzhen)        ʮ���ƽ�����ʮ��������              20/  20 ��
	 self.lists["������"]=function(num)
	    local id="lanyu duzhen"
		   local name="������"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["lanyu duzhen"]=function(num)
	      local id="lanyu duzhen"
		   local name="������"
   	      self:bingqipu(name,id,num)
	 end
--����ѩ��(Xue sui)               �嶧�ƽ��־�ʮ��������              20/  20 ��
	 self.lists["ѩ�鵶"]=function(num)
	    local id="xue sui"
		   local name="ѩ�鵶"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["xue sui"]=function(num)
	      local id="xue sui"
		   local name="ѩ�鵶"
   	      self:bingqipu(name,id,num)
	 end

--�����öɥ�Ŷ�(Sangmen ding)    ��ʮ�Ŷ��ƽ�����������             100/ 100 ��
	 self.lists["ɥ�Ŷ�"]=function(num)
	    local id="sangmen ding"
		 local name="ɥ�Ŷ�"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["sangmen ding"]=function(num)
	      local id="sangmen ding"
		    local name="ɥ�Ŷ�"
   	      self:bingqipu(name,id,num)
	 end
--���йٱ�(Panguan bi)            �߶��ƽ��־�ʮ��������             100/ 100 ��
	 self.lists["�йٱ�"]=function(num)
	    local id="panguan bi"
		local name="�йٱ�"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["panguan bi"]=function(num)
	      local id="panguan bi"
		  local name="�йٱ�"
   	      self:bingqipu(name,id,num)
	 end
--�����߽�(Yinshe sword)          �߶��ƽ��ֶ�ʮ��������             120/ 120 ��
	 self.lists["���߽�"]=function(num)
	    local id="yinshe sword"
		local name="���߽�"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["yinshe sword"]=function(num)
	      local id="yinshe sword"
		  local name="���߽�"
   	      self:bingqipu(name,id,num)

	 end

	 self.lists["jinshe zhui"]=function(num)
	      local id="jinshe zhui"
		  local name="����׶"
   	      self:bingqipu(name,id,num)

	 end
	 self.lists["����׶"]=function(num)
	      local id="jinshe zhui"
		  local name="����׶"
   	      self:bingqipu(name,id,num)

	 end
--��������(Tianshe zhang)         �Ŷ��ƽ��־�ʮ������                20/  20 ��
	 self.lists["������"]=function(num)
	    local id="tianshe zhang"
		  local name="������"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["tianshe zhang"]=function(num)
	      local id="tianshe zhang"
		    local name="������"
   	      self:bingqipu(name,id,num)
	 end
--��һ������������(Jiulong ling)  �Ķ��ƽ�����ʮ���������ֶ�ʮ��ͭǮ 200/ 200 ?
	 self.lists["����������"]=function(num)
	    local name="����������"
	    local id="jiulong ling"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["jiulong ling"]=function(num)
	      local id="jiulong ling"
		    local name="����������"
   	     self:bingqipu(name,id,num)
	 end

   self.lists["shuaijian"]=function(num) self:shuaijian() end
   self.lists["˦��"]=function(num) self:shuaijian() end

   self.lists["jinhu pifeng"]=function() self:pifeng() end
   self.lists["��������"]=function() self:pifeng() end

   self.lists["ruan xue"]=function() self:ruanxue() end
   self.lists["��׿�ѥ"]=function() self:ruanxue() end

   self.lists["shisan longxiang"]=function() self:longxiang() end
   self.lists["ʮ����������"]=function() self:longxiang() end

   self.lists["hu wan"]=function() self:huju() end
   self.lists["����"]=function() self:huju() end

   self.lists["tie beixin"]=function() self:tiebeixin() end
   self.lists["������"]=function() self:tiebeixin() end

   self.lists["ľ��"]=function() self:mujian() end
   self.lists["mu jian"]=function() self:mujian() end

   self.lists["���˻���"]=function() self:huwan() end
   self.lists["huwan"]=function() self:huwan() end

   self.lists["Ѫ��"]=function() self:xuedao() end
   self.lists["xuedao"]=function() self:xuedao() end

   self.lists["ruanwei jia"]=function() self:ruanweijia() end
   self.lists["��⬼�"]=function() self:ruanweijia() end

   self.lists["jiaohui"]=function() self:jiaohui() end
   self.lists["�̻�"]=function() self:jiaohui() end

   self.lists["songwen jian"]=function() self:songwenjian() end
   self.lists["���ƹŽ�"]=function() self:songwenjian() end

   self.lists["jiuhua wan"]=function() self:jiuhuawan() end
   self.lists["�Ż���¶��"]=function() self:jiuhuawan() end

   self.lists["jin bishou"]=function() self:jinbishou() end
   self.lists["��ذ��"]=function() self:jinbishou() end

   self.lists["neixi wan"]=function() self:neixiwan() end
   self.lists["��Ϣ��"]=function() self:neixiwan() end

   self.lists["chuanbei wan"]=function() self:chuanbeiwan() end
   self.lists["������Ϣ��"]=function() self:chuanbeiwan() end

   self.lists["huxi"]=function() self:huxi() end
   self.lists["��ϥ"]=function() self:huxi() end

   self.lists["chai dao"]=function() self:chaidao() end
   self.lists["��"]=function() self:chaidao() end

   self.lists["mu dao"]=function() self:mudao() end
   self.lists["ľ��"]=function() self:mudao() end

   self.lists["mumian jiasha"]=function() self:mumianjiasha() end
   self.lists["ľ������"]=function() self:mumianjiasha() end

   self.lists["xiong pi"]=function(num) self:xiongpi(num) end
   self.lists["��Ƥ"]=function(num) self:xiongpi(num) end

   self.lists["baicaodan"]=function() self:baicaodan() end
   self.lists["�ٲݵ�"]=function() self:baicaodan() end

   self.lists["zhen"]=function() self:xiuhuazhen() end
   self.lists["�廨��"]=function() self:xiuhuazhen() end

   self.lists["danfeng huyao"]=function() self:danfenghuyao() end
   self.lists["���ﻤ��"]=function() self:danfenghuyao() end

   self.lists["tanmu huxiong"]=function() self:tanmuhuxiong() end
   self.lists["̴ľ����"]=function() self:tanmuhuxiong() end

   self.lists["changjian"]=function() self:changjian() end
   self.lists["����"]=function() self:changjian() end

   self.lists["xiao shuzhi"]=function() self:xiaoshuzhi() end
   self.lists["С��֦"]=function() self:xiaoshuzhi() end

   self.lists["blade"]=function() self:gangdao() end
   self.lists["�ֵ�"]=function() self:gangdao() end

   self.lists["fire"]=function()
      local _R
       _R=Room.new()
       _R.CatchEnd=function()
         local index= zone(_R.zone)
		 if index==6 then
		   self:fire2()
		 elseif index==1 then
		   self:fire3()
		 else
           self:fire()
		 end
       end
       _R:CatchStart()
   end
   self.lists["����"]=function()
      local _R
       _R=Room.new()
       _R.CatchEnd=function()
         local index= zone(_R.zone)
		 if index==6 then
		   self:fire2()
		 elseif index==1 then
		   self:fire3()
		 else
           self:fire()
		 end
       end
       _R:CatchStart()
   end

   self.lists["coin"]=function(num) self:coin(num) end
   self.lists["ͭǮ"]=function(num) self:coin(num) end

   self.lists["silver"]=function(num) self:silver(num) end
   self.lists["����"]=function(num) self:silver(num) end
   self.lists["gold"]=function(num) self:gold(num) end
   self.lists["�ƽ�"]=function(num) self:gold(num) end

   self.lists["liuhuang"]=function(num) self:liuhuang() end
   self.lists["���"]=function(num) self:liuhuang() end

   self.lists["tanzi"]=function(num) self:tanzi() end
   self.lists["̳��"]=function(num) self:tanzi() end

   self.lists["duandi"]=function(num) self:duandi() end
   self.lists["����̵�"]=function(num) self:duandi() end

   self.lists["Zhaohun fan"]=function(num) self:get_fan() end
   self.lists["�л��"]=function(num) self:get_fan() end

   self.lists["�ӹ�"]=function(num) self:naogou() end
   self.lists["nao gou"]=function(num) self:naogou() end

   self.lists["�����"]=function(num) self:fenghuolun() end
   self.lists["fenghuo lun"]=function(num) self:fenghuolun() end

     self.lists["����"]=function(num) self:falun() end
   self.lists["lun"]=function(num) self:falun() end

    self.lists["ѩɽ���µ�"]=function(num) self:wandao() end
   self.lists["xinyue dao"]=function(num) self:wandao() end

	self.lists["����"]=function(num) self:biyujian() end
   self.lists["biyu jian"]=function(num) self:biyujian() end

   	self.lists["��������"]=function(num) self:pearl() end
   self.lists["pearl"]=function(num) self:pearl() end

   	self.lists["����"]=function(num) self:shengzi() end
   self.lists["sheng zi"]=function(num) self:shengzi() end

   self.lists["�ۻ�"]=function(num) self:xionghuang() end
   self.lists["xiong huang"]=function(num) self:xionghuang() end

	self.lists["����"]=function(num) self:zhushao() end
   self.lists["zhushao"]=function(num) self:zhushao() end

   	self.lists["����"]=function(num) self:jinshe() end
   self.lists["jinshe"]=function(num) self:jinshe() end

	self.lists["�Ͻ�"]=function(num) self:zijindao() end
   self.lists["zijin dao"]=function(num) self:zijindao() end

   self.lists["�����"]=function(num) self:yufengzhen() end
   self.lists["yufeng zhen"]=function(num) self:yufengzhen()  end

   self.lists["������"]=function(num) self:xuantie() end
   self.lists["xuantie jian"]=function(num) self:xuantie() end

   self.lists["������Ϣ��"]=function(num) self:buy_neixiwan() end
    self.lists["chuanbei wan"]=function(num) self:buy_neixiwan() end

end

function equipments:auto_get(item_name,num)

   local f=self.lists[item_name]
   --print(f)
   if f~=nil then
      assert (type (f) == "function", "auto_get��Ҫһ��ִ�к���")
	  f(num)
	  return
   end
   self:finish()
end

function equipments:xionghuang()
   local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
      world.Send("buy xiong huang")
	  local l,w=wait.regexp("^(> |)����.*�ļ۸���ӻ����ϰ�����������һ���ۻơ�$|^(> |)������Ķ���������û�С�$|^(> |)�ӻ����ϰ�˵��������⵰��һ�ߴ���ȥ����$|^(> |)*��⵰��һ�ߴ���ȥ��|^(> |)�ӻ����ϰ�˵������������Ǯ�����ˣ���Ʊ��û���ҵÿ�����$",5)
	  if l==nil then
	      self:xionghuang()
		  return
	  end
	  if string.find(l,"������Ķ���������û��") then
	      self:finish()
	      return
	    end
	  if string.find(l,"������һ���ۻ�") then
	     --self.finish("�廨��","xiuhua zhen",true)
	     self:finish()
	     return
	  end
   if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
	        local f=function()
		      self:xionghuang()
		    end
	        qu_gold(f,1,50)
	        return
	    end
	    wait.time(5)
	 end)
   end
   w:go(94)
end


function equipments:xiuhuazhen()
   local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
      world.Send("buy xiuhua zhen")
	  local l,w=wait.regexp("^(> |)����.*�ļ۸�ӳ°�������������һ���廨�롣$|^(> |)������Ķ���������û�С�$|^(> |)�°���˵��������⵰��һ�ߴ���ȥ����$|^(> |)*��⵰��һ�ߴ���ȥ��|^(> |)�°���˵������������Ǯ�����ˣ���Ʊ��û���ҵÿ�����$",5)
	  if l==nil then
	      self:xiuhuazhen()
		  return
	  end
	  if string.find(l,"������Ķ���������û��") then
	      self:finish()
	      return
	    end
	  if string.find(l,"�ӳ°�������������һ���廨��") then
	     --self.finish("�廨��","xiuhua zhen",true)
	     self:finish()
	     return
	  end
   if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
	        local f=function()
		      self:xiuhuazhen()
		    end
	        qu_gold(f,1,1331)
	        return
	    end
	    wait.time(5)
	 end)
   end
   w:go(1339)
end

function equipments:danfenghuyao()
   local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
      world.Send("ask guxu about huyao")
	  local l,w=wait.regexp("^(> |)�����������һ�����ﻤ����$|^(> |)�������˵������.*���������ϲ�����������������������Ҫ�ˣ� ����̰�����У���$",5)
	  if l==nil then
	      self:danfenghuyao()
		  return
	  end
	  if string.find(l,"���ﻤ��") then
		  local b=busy.new()
		  b.Next=function()
	        world.Send("remove all")
		    world.Send("wear all")
	        self:finish()
		  end
		  b:check()
	      return
	  end
	  if string.find(l,"����̰������") then
		 local b=busy.new()
		  b.Next=function()
	        world.Send("drop huyao")
		    self:danfenghuyao()
		  end
		  b:check()
	      return
	  end
	 end)
   end
   w:go(1947)
end

function equipments:tanmuhuxiong()
   local w
   w=walk.new()
   w.walkover=function()
	 wait.make(function()
      world.Send("ask guxu about huxiong")
	  local l,w=wait.regexp("^(> |)�����������һ��̴ľ���ء�$|^(> |)�������˵������.*���������ϲ�����������������������Ҫ�ˣ� ����̰�����У���$",5)
	  if l==nil then
	      self:tanmuhuxiong()
		  return
	  end
	  if string.find(l,"�����������һ��̴ľ����") or string.find(l,"����̰������") then
	      local b=busy.new()
		  b.Next=function()
	        world.Send("remove all")
		    world.Send("wear all")
	        self:finish()
		  end
		  b:check()
	      return
	  end
	 end)
   end
   w:go(1947)
end

--��������� ������
function equipments:fire3()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy fire")
	  local l,w=wait.regexp("^(> |)����.*�۸��С��������������һ֧���ۡ�$|^(> |)С����˵��������⵰��һ�ߴ���ȥ����$|^(> |)С����˵������������Ǯ�����ˣ���Ʊ��û���ҵÿ�����$",5)
	  if l==nil then
	      self:fire3()
		  return
	  end
	  if string.find(l,"С��������������һ֧����") then
	     self:finish()
	     return
	  end
	  if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
		 local f=function()
			self:fire3()
		 end
		 qu_gold(f,1,1331)
		 return
	  end
   end
   w:go(1116)
end
--��������� ����
function equipments:fire2()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy fire")
	  local l,w=wait.regexp("^(> |)����.*�۸������������������һ֧���ۡ�$|^(> |)������˵��������⵰��һ�ߴ���ȥ����$|^(> |)������˵������������Ǯ�����ˣ���Ʊ��û���ҵÿ�����$",5)
	  if l==nil then
	      self:fire2()
		  return
	  end
	  if string.find(l,"����������������һ֧����") then
	     self:finish()
	     return
	  end
	  if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
		 local f=function()
			self:fire2()
		 end
		 qu_gold(f,1,1973)
		 return
	  end
   end
   w:go(2351)
end

--���������
function equipments:fire()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy fire")
	  local l,w=wait.regexp("^(> |)����.*�۸��С��������������һ֧���ۡ�$|^(> |)С����˵��������⵰��һ�ߴ���ȥ����$|^(> |)С����˵������������Ǯ�����ˣ���Ʊ��û���ҵÿ�����$",5)
	  if l==nil then
	      self:fire()
		  return
	  end
	  if string.find(l,"С��������������һ֧����") then
	     self:finish()
	     return
	  end
	  if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
		 local f=function()
			self:fire()
		 end
		 qu_gold(f,1,50)
		 return
	  end
   end
   w:go(568)
end

function equipments:coin(num)
    --print(num,"num")
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
		world.Send("qu "..num.." coin")
		local l,w=wait.regexp("^(> |)���������ȡ��.*ͭǮ��$",5)
		if l==nil then
		--duanzao_learn(CallBack)
		   self:coin(num)
		   return
		end
		if string.find(l,"���������") then
		   self:finish()
		   return
		end
	  end)
   end
   w:go(50)
end

function equipments:silver(num)
    --print(num,"num")
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
		world.Send("qu "..num.." silver")
		local l,w=wait.regexp("^(> |)���������ȡ��.*������$",5)
		if l==nil then
		--duanzao_learn(CallBack)
		   self:silver(num)
		   return
		end
		if string.find(l,"���������") then
		   self:finish()
		   return
		end
	  end)
   end
   w:go(50)
end

function equipments:gold(num)
    --print(num,"num")
   local w
   w=walk.new()
   w.walkover=function()
      wait.make(function()
		world.Send("qu "..num.." gold")
		local l,w=wait.regexp("^(> |)���������ȡ��.*�ƽ�$",5)
		if l==nil then
		--duanzao_learn(CallBack)
		   self:gold(num)
		   return
		end
		if string.find(l,"���������") then
		   self:finish()
		   return
		end
	  end)
   end
   w:go(50)
end

function equipments:tanzi()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy tan zi")
	  local l,w=wait.regexp("^(> |)����.*�۸������������������һ��̳�ӡ�$|^(> |)������˵��������⵰��һ�ߴ���ȥ����$|^(> |)������˵������������Ǯ�����ˣ���Ʊ��û���ҵÿ�����$",5)
	  if l==nil then
	      self:tanzi()
		  return
	  end
	  if string.find(l,"������������������һ��̳��") then
	      self.finish("̳��","tan zi",true)
	     return
	  end
	  if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
		 local f=function()
			self:tanzi()
		 end
		 qu_gold(f,1,1973)
		 return
	  end
   end
   w:go(2351)
end

function equipments:liuhuang()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy liu huang")
	  local l,w=wait.regexp("^(> |)����.*�۸������������������һ����ǡ�$|^(> |)������˵��������⵰��һ�ߴ���ȥ����$|^(> |)������˵������������Ǯ�����ˣ���Ʊ��û���ҵÿ�����$",5)
	  if l==nil then
	      self:liuhuang()
		  return
	  end
	  if string.find(l,"������������������һ�����") then
	     self:finish()
	     return
	  end
	  if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������") then
		 local f=function()
			self:liuhuang()
		 end
		 qu_gold(f,1,1973)
		 return
	  end
   end
   w:go(2351)
end

-- һֻ����̵�(Duandi) ʨ�����ó�һֻ���ƶ̵ѣ������㡣
function equipments:duandi()
  local w=walk.new()
  w.walkover=function()
      world.Send("flatter �������ɣ�������أ��������Ž��ޱȡ�")
	  local exps=world.GetVariable("exps")
	  local roomno=2234
	  if tonumber(exps)>=350000 then
	     roomno=2235
	  end
	  local f=function()
        local w=walk.new()
         w.walkover=function()
             world.Send("ask zi about ����")
			 self.finish("����̵�","duandi",true)
		 end
         w:go(roomno)
	  end
	  local b=busy.new()
	  b.Next=function()
	     f_wait(f,5)
	  end
	  b:check()
  end
  w:go(1969)

end

function equipments:biyujian()
  local w=walk.new()
  w.walkover=function()
       world.Send("ask murong fu about ����")
	   wait.time(3)
	   self:finish()
  end
  w:go(1989)
end
--> �����嶧�ƽ��ְ�ʮ���������ļ۸�����ϰ�����������һ����ѩ����
function equipments:bingqipu(name,id,num)
    if num==nil then
		num=1
	end
  local w=walk.new()
  w.walkover=function()

	   world.Send("buy "..id)
	   world.Send("set action ������")
	 local l,w=wait.regexp("^(> |)���ϰ�˵��������⵰��һ�ߴ���ȥ����$|^(> |)�趨����������action \\= \\\"������\\\"$|^(> |)����.*�۸�����ϰ�����������.*��$|^(> |)���ϰ�˵������������Ǯ�����ˣ���Ʊ��û���ҵÿ�����$",20)
	  if l==nil then
	      self:bingqipu(name,id,num)
		  return
	  end
	  if string.find(l,"�趨��������") then
			local sp=special_item.new()

			sp.check_items_over=function()
			   print("������")
			  for index,deal_function in pairs(sp.itemslist) do

			     if sp.itemslistNum[index]==nil then
				     self:bingqipu(name,id,num)
			     else
			        self:finish()
			     end
			    break
			  end
	        end
            local equip={}
	         equip=Split("<����>"..name,"|")
              sp:check_items(equip)
	     return
	  end
	  if string.find(l,"�����ϰ�����������") then

	      if id=="zhen" then
			  num=num-365
			 elseif id=="falun" then
			   num=num-5
			 elseif id=="sangmen ding" then
			   num=num-500
			else
		      num=num-1  --�������ı��� ��Ǯ������
		 end
	    print("������������",num)
	     if num<=1 then
	        self:finish()
		 else

			self:bingqipu(name,id,num)
		 end
	     return
	  end
	  if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"������Ǯ������")  then
		 local f=function()
			self:bingqipu(name,id,num)
		 end
		 qu_gold(f,10,50)
		 return
	  end
  end
  w:go(4104)
end


function equipments:longpao()
  local w=walk.new()
  w.walkover=function()
       world.Send("ask murong bo about ����") --�̲���¶��
	   wait.time(3)
	   world.Send("remove all")
	   world.Send("wear all")
	   self:finish()
  end
  w:go(2558)
end

function equipments:naogou()
  local w=walk.new()
  w.walkover=function()
       world.Send("ask dashi about ����")
	   wait.time(3)
	   world.Send("ask dashi about �ӹ�")
	   wait.time(3)
	   self:finish()
  end
  w:go(3160)
end

function equipments:safe_room()

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
	     self:finish()
		 return
	  end
   end
   w:go(53)
end

function equipments:recheck(name,id,num)
       local sp=special_item.new()
       sp.cooldown=function()
           self:finish()
       end
	   local equip={}
	   local item="<��ȡ>"..name.."&"..id
	   table.insert(equip,item)
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

function equipments:getback_lostweapon(name,id,num)
  --�ղ��Ƿ�����
  --�Ƿ�����������������ʧ
   local newdie=world.GetVariable("newdie") or ""
   if newdie=="true" then
      world.DeleteVariable("newdie")
	  _G["fight_Roomno"]=nil
      self:bingqipu(name,id,num)
	  return
   end
   world.Send("alias pfm") --ɾ��pfm
   local f=_G["fight_Roomno"] --��ս������������� ���������ս������
   -- f=50
    local r={}
	table.insert(r,f)
    _G["fight_Roomno"]=nil
   if f==nil or f=="" then
	   self:recheck(name,id,num)
       --self:finish()
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

	     world.Send("get "..id)
		 world.Send("halt")
		 world.Send("alias pfm halt;get "..id..";"..g_dx..";set action ����")
	     world.Send("set wimpy 100")
	     world.Send("set wimpycmd pfm\\hp")
		 world.Send(g_dx)
		 self:safe_room()
		 --world.Send("go away")
		 --self:finish()
		 self:recheck(name,id,num)
	  end
	  w:go(f)
   end
end
--[[
jiancha jinhe
�㷴�����ź��ӣ����ҳ�������ʲô���ܡ�
��������ᣬ������·���ڰ�ť��һ�������ӵļв���˿�����
һ�ŷ��Ƶ�ֽ����д��ģ���ļ�����:
���ݺὭ��ʱ���������°���̨����Щ�����£�����Ե��ǰȥ�ھ�(dig)��]]
function equipments:NextPoint()
   print("���ָ̻�:",coroutine.status(equipments.eq_co))
   if equipments.eq_co==nil or coroutine.status( equipments.eq_co)=="dead" then
      self:finish()
   else
      print("�ָ�")
      coroutine.resume(equipments.eq_co)
   end
end
--[[
> ��ͻȻ�ڵ�һ���ź���������Լ�л��ܵ�������
��о���������������ɵ�����飬�ƺ�Ӧ�����ż��ͳ�ȥ��
��ҥ�ԡ�ĳ�ˣ����˿���Ҷ֪����һ�ݾ��ܾ��飡
��ҥ�ԡ�ĳ�ˣ�Ҷ֪��Ū����һ�������غ���
>
dig
����ڵ��ϣ������ڵ���һ�����١�
������һ��ʲôҲû���ҵ���]]

function equipments:dig()

   world.Send("dig")
     wait.make(function()
      local l,w=wait.regexp("^(> |)����.*�ڣ�����������ְɣ�$|^(> |)��������ѽ��$|(> |)����ڵ���.*�ڵ���һ�����١�$|^(> |)���϶���һ������߰ߵ������ӣ�����˲�ע�⣬Ѹ�ٰ����д��뻳�С�$|^(> |)��ͻȻ�ڵ�һ���ź���������Լ�л��ܵ�������$",5)
	  if l==nil then
	     self:dig()
		 return
	  end
	  if string.find(l,"���϶���һ������߰ߵ�������") or string.find(l,"��ͻȻ�ڵ�һ���ź�") then
		 local b=busy.new()
		 b.Next=function()
	       self:finish()
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"����������ְ�") then
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("ж������")
			self:dig()
		 end
		 sp:unwield_all()
	     return
	  end
	  if string.find(l,"�������") or string.find(l,"�ڵ���һ������") then
	     local b=busy.new()
		 b.Next=function()
	       self:NextPoint()
		 end
		 b:check()
	     return
	  end
   end)
end

function equipments:start_dig(rooms,count,is_save)
  if is_save==true then
     local w=walk.new()
	 w.walkover=function()
	    world.Send("cun jinhe")
		local b=busy.new()
		b.Next=function()
		   self:finish()
		end
		b:check()
	 end
	 w:go(94)
	 return
  end
  equipments.eq_co=coroutine.create(function()
      --print(rooms)
      --print(table.getn(rooms))
      for _,r in ipairs(rooms) do
          local w
		  w=walk.new()
		  local al
		  al=alias.new()
		  --al.do_jobing=true
		   --al.break_pfm=self.break_pfm
		  al.break_in_failure=function()
		      self:finish() --����
		  end

		  w.user_alias=al
		  w.noway=function()
		     self:NextPoint()
			 --self:giveup()
		  end
		  w.walkover=function()
			self:dig()
		  end
		  print("��һ�������:",r)
		  w:go(r)
		  coroutine.yield()
	  end
	  print("û�ڶԵط�����")
	  if count==nil then
		    count=1
	  end
	  if count>3 then
	     world.Send("drop jinhe")
	     self:finish()
	  else

	    count=count+1
	    self:start_dig(rooms,count,is_save)
	  end

  end)
  --print("ִ���۾�")
  self:NextPoint()
end

function equipments:weilan()

   local w=walk.new()
   w.walkover=function()

	  world.Send("give weilan's hammer to zhujian shi")
	   self:finish()
  end
  w:go(97)

end

function equipments:zhuanji()

   local w=walk.new()
   w.walkover=function()
      local cmd="give zha zhuanji"
	  local paths="e;w;w;n;e;w;w;u;d;nw;se;e;s;w;e;s;e;n;s;w;w"
	  local P=Split(paths,";")
	  for _,N in ipairs(P) do
	     world.Execute(N..";"..cmd)
	  end
	  --world.Execute("give zhai zhuanji;e;give zhai zhuanji;w;give zhai zhuanji;w;give zhai zhuanji;n;give zhai zhuanji;e;give zhai zhuanji;w;give zhai zhuanji;s;give zhai zhuanji;w;give zhai zhuanji")
	   self:finish()
  end
  w:go(45)

end

function equipments:mihan(id)

   local room
   local npc
   if string.lower(id)=="menggu mihan" then
	    room=348
	   npc="meng ge"
   else

	   room=198
	   npc="guo"
   end
   local w=walk.new()
   w.walkover=function()

	  world.Send("give mihan to "..npc)
	   self:finish()
  end
  w:go(room)

end

function equipments:jinhe(cmd,count)
   if cmd==nil then
      world.Send("jiancha jinhe")
	else
	  world.Send(cmd)
	end

   if count==nil then
      count=1
	else
	   count=count+1
   end
   if count>=3 then
      print("����3��û�򿪽���!")
	  self:finish()
	  return
   end
   wait.make(function()
      local l,w=wait.regexp("^(> |)���ݺὭ��ʱ����(.*)����Щ�����£�����Ե��ǰȥ�ھ�.*$|^(> |)���ӵļв��Ѿ���.*$",5)
	  if l==nil then
         self:jinhe(cmd,count)
		 return
	  end
	  if string.find(l,"���ӵļв��Ѿ���") then
	     local c="look jinhe"
		 self:jinhe(c)
		 return
	  end
	  if string.find(l,"����Ե��ǰȥ�ھ�") then
	     local Location=w[2]
		 print(Location," �ھ�ص�")
	     local is_save=false
		 local exps=tonumber(world.GetVariable("exps")) or 0
		 if string.find(Location,"�ؾ����¥") and exps<800000 then  --����Σ�շ���
		    is_save=true
		 end
		 local rooms={}
		 local n,rooms=Where(Location)
		 self:start_dig(rooms,0,is_save)
	     return
	  end
   end)
end

function equipments:dahuandan()
     local w=walk.new()
  w.walkover=function()
       world.Send("duihuan dahuan dan")
	   self:finish()
  end
  w:go(84)
end

function equipments:pearl()
  local w=walk.new()
  w.walkover=function()
       world.Send("duihuan pearl")
	   self:finish()
  end
  w:go(84)
end

function equipments:shengzi()
	 local w=walk.new()
     w.walkover=function()
	   world.Send("get sheng zi")
	   --> �㸽��û������������
	   wait.make(function()
	      local l,w=wait.regexp("^(> |)�㸽��û������������$|^(> |)�����һ�����ӡ�$",10)
		  if l==nil then
		     self:shengzi()
		     return
		  end
		  if string.find(l,"�㸽��û����������") then
		     local f=function()
  			   self:shengzi()
			 end
			 f_wait(f,10)
		     return
		  end
	      if string.find(l,"�����һ������") then
		     self:finish()
		     return
		  end
	   end)

     end
     w:go(1526)
end
--sld ����
function equipments:jinshe()
   local w=walk.new()
   w.walkover=function()
      --xunshe
	  --zhaoshe
	  world.Send("zhaoshe")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)ʲô��$|^(> |)�㻹û�����أ�$|^(> |)���Ѿ��õ����ˡ�$|^(> |)���������Ҳ����ߡ�|^(> |)���ó����ڣ����ĵĴ�����������һ�����һ�����������С�ߴ���$N�����ϡ�$",5)
	    if l==nil then
		   self:jinshe()
		   return
		end
	    if string.find(l,"һ�����������С��")then
		  self:finish()
		  return
		end
		if string.find(l,"���������Ҳ�����") then
		  self:jinshe()
		  return
		end
		if string.find(l,"�㻹û������") or string.find(l,"���Ѿ��õ�����")  then
		   world.Send("xunshe")
		   wait.time(1)
		   world.Send("zhaoshe")
		   self:finish()
		   return
		end
		if string.find(l,"ʲô") then
		   --self:finish()
		   self:zhushao()
		   return
		end
	  end)
   end
   w:go(1775)
end

--����(Zhushao)
function equipments:zhushao()
  local w=walk.new()
  w.walkover=function()
       local b=busy.new()
	   b.interval=0.8
	   world.Send("ask su about ����")
	   b.Next=function()
	    self:jinshe()
	   end
	   b:check()
  end
  w:go(1795)
end

function equipments:fangshe()
  local w=walk.new()
   w.walkover=function()
      --xunshe
	  --zhaoshe
	  world.Send("fangshe")
	  self:finish()

   end
   w:go(1775)
end

--��Ĺ �����
function equipments:yufengzhen()
  local w=walk.new()
  w.walkover=function()
       local b=busy.new()
	   b.interval=0.8
	   world.Send("ask longnv about �����")
	   b.Next=function()
	    self:finish()
	   end
	   b:check()
  end
  w:go(3018)
end

function equipments:pingtai()
   world.Execute("d;nw;nu;l shibi;mo shibi;cuan up")
   wait.make(function()


		local l,w=wait.regexp("^(> |)ƽ̨ -.*$",5)
		if l==nil then
		   self:pingtai()
		   return
		end
		if string.find(l,"ƽ̨") then
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("ж������")
			world.Execute("l zi;move stone;enter;ti xuantiejian;tui shi;out;tiao down;sd;se;s;out")
			self:finish()
		 end
		 sp:unwield_all()
		  return
		end
	end)
end

function equipments:xuantie2()
  wait.make(function()
   world.Execute("l qingtai;mo qingtai;l zi;l mu;kneel mu")
     local l,w=wait.regexp("^(> |)���֮�ʺ�Ȼ����ɽ�������ƺ��и����ڣ�͸����һ˿������$",4)
	 if l==nil then
	    self:xuantie2()
	    return
	 end
	 if string.find(l,"͸����һ˿����") then

	    wait.time(1)
		 world.Send("zuan dong")
		 wait.time(2)
		 self:pingtai()

		return
	 end
  end)
end

function equipments:shandong()
--  ��ɽ�� -
   world.Send("enter")
   wait.make(function()
      local l,w=wait.regexp("^(> |)��ɽ�� -.*$",5)
	  if l==nil then
	     world.Send("out")
	     self:xuantie()
		 return
	  end
	  if string.find(l,"��ɽ��") then
	     world.Send("dian shuzhi")
		 self:xuantie2()
	     return
	  end
   end)
end

--��Ĺ�������� 2000���� 35bl ����
--��������������:��Я������,С��֦������ɽ·ʷ�����ֵܿ�ʼnw;n;n�����һ������,�ߵ���nu��ʱ��,nu;nu;nw;nu;�������,kill diao;enter;dian shuzhi;l qingtai;mo qingtai;l zi;l mu;kneel mu;zuan dong;nw;nu;l shi bi;mo shi bi;cuan;up;l zi;move stone;enter;ti xuantie(������);ti gangjian(��������),����:tui shi;out;tiao down; sd;se;s;out
function equipments:xuantie()
 --�����Ʒ
      local equip={}
	  local item="<��ȡ>����|<��ȡ>С��֦|<��ȡ>������"

	  local sp=special_item.new()
	   sp.cooldown=function()
           local w=walk.new()
           w.walkover=function()
	         self:shandong()
           end
           w:go(1501)
       end
       equip=Split(item,"|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

function equipments:zijindao()
  local w=walk.new()
  w.walkover=function()
       world.Send("ask laozu about �Ͻ�")
       local b=busy.new()
	   b.interval=0.8

	   b.Next=function()
	    self:finish()
	   end
	   b:check()
  end
  w:go(1660)
end

function equipments:xiaoshuzhi(roomno)
  if roomno==nil or roomno==2210 then
     roomno=1012
  elseif roomno==1012 then
     roomno=1042
  elseif roomno==1042 then
     roomno=2210
  end
 local w=walk.new()
  w.walkover=function()
       world.Send("get xiao shuzhi")
       wait.make(function()
		  local l,w=wait.regexp("^(> |)�㸽��û������������$|^(> |)�����һ֦С��֦��$",5)
		  if l==nil then
		     self:xiaoshuzhi(roomno)
		     return
		  end
		  if string.find(l,"�㸽��û����������") then
			 self:xiaoshuzhi(roomno)
		     return
		  end
		  if string.find(l,"�����һ֦С��֦") then
		     self:finish()
			 return
		  end
	   end)
  end
  w:go(roomno)
end

function equipments:buy_neixiwan()
 local w=walk.new()
 w.walkover=function()
   wait.make(function()
     world.Send("buy chuanbei wan")
	 local l,w=wait.regexp("^(> |)����.*�۸��ҩ���ƹ�����������һ�Ŵ�����Ϣ�衣$|^(> |)������Ķ���������û�С�$|^(> |)��⵰��һ�ߴ���ȥ��|^(> |).*������Ǯ�����ˣ���Ʊ��û���ҵÿ���$",2)
	 if l==nil then
	   self:buy_neixiwan()
	   return
	 end
	 if string.find(l,"������Ķ���������û��") then
	   self:finish()
	   return
	 end
	 if string.find(l,"һ�Ŵ�����Ϣ��") then
	   self:finish()
	    return
	 end
	 if string.find(l,"��⵰��һ�ߴ���ȥ") or string.find(l,"��Ʊ��û���ҵÿ�") then
	    local f=function()
			self:buy_neixiwan()
		 end
		 qu_gold(f,10,410)
	    return
	 end
	-- wait.time(5)
	end)
 end
 w:go(413)
end
