rest={
  new=function()
     local r={}
	 setmetatable(r,{__index=rest})
	 return r
 end,
}

function rest:wake(status) --�ص�����

end

function rest:failure(id) -- �ص�����

end

function rest:sleeping()
   wait.make(function()
    local l,w=wait.regexp("^(> |)��һ������������˯��̫Ƶ���������Ǻܺá�$|^(> |)��һ�����������þ������棬�ûһ���ˡ�$|^(> |)���ﲻ������˯�ĵط���$",5)
	if l==nil then
	   self:sleeping()
	   return
	end
	if string.find(l,"����˯��̫Ƶ���������Ǻܺ�") then
	   self:wake(0)
	   return
	end
	if string.find(l,"���þ������棬�ûһ����") then
	   self:wake(1)
	   return
	end
	wait.time(5)
  end)
end

function rest:sleep()
   wait.make(function()
    world.Send("sleep")
	--��һ�������ͽ��������硣
	local l,w=wait.regexp("^(> |)��һ�������ͽ��������硣$|^(> |)���ﲻ������˯�ĵط���$",5)
	if l==nil then
	   self:sleep()
	   return
	end
	if string.find(l,"��һ�������ͽ���������") then
	   self:sleeping()
	   return
	end
	if string.find(l,"���ﲻ������˯�ĵط�") then
	  self.failure(101)
	  return
	end
	wait.time(5)
   end)
end

function rest:wash_over() --�ص�����

end

function rest:wait_wash()
  wait.make(function()
     local l,w=wait.regexp("^(> |)�㾫���ӵĴ�ԡ�������˳�����$",20)

	 if l==nil then
	    print("��ʱ!1")
		local gender=world.GetVariable("gender")
	   world.Send("wear all")
	   if gender=="����" then
	      world.Send("e")
	   else
	      world.Send("w")
	   end
	     self:wash_over()
	     return
	 end
	 if string.find(l,"�㾫���ӵĴ�ԡ�������˳���") then
	   local b=busy.new()
	   b.Next=function()
	   local gender=world.GetVariable("gender")
	   world.Send("wear all")
	   if gender=="����" then
	      world.Send("e")
	   else
	      world.Send("w")
	   end
	     self:wash_over()
	  end
	  b:check()
	    return
	 end
  end)
end

function rest:wash()
   local w=walk.new()
   w.walkover=function()
       local gender=world.GetVariable("gender")
	  -- world.Send("show card")
	   world.Send("give 1 gold to yahuan")
	   wait.make(function()
	      local l,w=wait.regexp("^(> |)���ó�һ���ƽ�\\(Gold\\)��СѾ����$|^(> |)������û������������$",5)
		  if l==nil then
		     self:wash()
		     return
		  end
		  if string.find(l,"������û����������") then
			local f=function()
			 self:wash()
		    end
		    qu_gold(f,10,50)
		     return
		  end
		  if string.find(l,"��СѾ��") then
		     if gender=="����" then
	             world.Send("w")
	          else
	             world.Send("e")
	         end
			local sp=special_item.new()
		    sp.cooldown=function()
		      world.Send("remove all")
	          world.Send("wash")
	          self:wait_wash()
		    end
		    sp:unwield_all()


		     return
		  end

	   end)

   end
   w:go(939)
end
