kanchai={
  new=function()

    local kc={}
	 setmetatable(kc,kanchai)
	 return kc
  end,

}
kanchai.__index=kanchai

function kanchai:ask_lu()
  local w=walk.new()
  w.walkover=function()
    world.Send("ask lu about ����")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)½����˵�������﷿��������˵������������ȱ�����������ȥ�����忳Щ�ɡ���$|^(> |)½����˵�����������ں�æ����һ�������ɡ���$",2)
	  if l==nil then
	     self:ask_lu()
	     return
	  end
	  if string.find(l,"�����ں�æ") then
	     local b=busy.new()
		 b.Next=function()
	       self.fail(102)
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"��ȥ�����忳Щ��") then
	    local b=busy.new()
		b.Next=function()
	    self:chaoyangfeng()
		end
		b:check()
	    return
	  end
	end)

  end
  w:go(1525)
end

function kanchai:chaoyangfeng()
 	 local sp=special_item.new()
		 sp.cooldown=function()
		     world.Send("wield chai dao")
			   local w=walk.new()
				w.walkover=function()
                   self:kan()
                end
                w:go(1511)
		 end
		 sp:unwield_all()

end

function kanchai:fail(id)

end

function kanchai:kan()
  world.Send("kan ��")
 wait.make(function()
   local l,w=wait.regexp("^(> |)��ѵ��ϵĲ������һ���������û�ȥ�ˡ�$|^(> |)��ȥ֪ͨ������ȡ��̰ɡ�$",1)
   if l==nil then
      self:kan()
      return
   end
   if string.find(l,"�����û�ȥ��") or string.find(l,"֪ͨ������ȡ��̰�") then
      self:reward()
      return
   end

 end)

end

function kanchai:jobDone()
end

function kanchai:reward()
  local w=walk.new()
  w.walkover=function()
     world.Send("unwield chai dao")
     world.Send("askk pu ren about ���")
    local b=busy.new()
	b.Next=function()
	   self:jobDone()
	end
	b:check()
  end
  w:go(1528)
end
