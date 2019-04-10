require "map"
require "wait"
fish={
 new=function()
    local fishing={}
    setmetatable(hl,{__index=fish})
	return fishing
  end,
}


local starttime=nil
local fish_count=0

function fish:diaoyu()
   wait.make(function()
      world.Send("diaoyu")
      local l,w=wait.regexp("^(> |)�����������˶�����Ǳ�ܷ����������ɡ�$|^(> |)ֻ����Ưһ����һ��С��������Ե��ˡ��㽫�չ�ק��������$|^(> |)��ͻȻ�����������һ���������Ϲ��ˣ�������\\\(shouxian\\\)����$|^(> |)��Ԩ���㣬�����˶�������û����ͣ�������ô��������$|^(> |)�����Ѿ���ô�����ˣ���Ҫ�������ﰡ��$",3)
	 if l==nil then
	    self:diaoyu()
		return
	 end
	 if string.find(l,"�����������˶�") then
	    world.Send("lian force")
		wait.time(2)
		self:diaoyu()
	    return
	 end
	 if string.find(l,"�㽫�չ�ק������") then
	   wait.time(1.6)
	   self:diaoyu()
	   return
	 end
	 if string.find(l,"û�����") then
	   self:get_yugan()
	   return
	 end
	  if string.find(l,"��ͻȻ�����������һ���������Ϲ���") then
	     wait.time(2)
	     self:shouxian()
         return
	  end
	  if string.find(l,"�����Ѿ���ô�����ˣ���Ҫ�������ﰡ") then
	     world.Execute("#10 get yu")
		 world.Send("wd")
		 world.Execute("#10 drop yu")
		 world.Send("eu")
		 self:diaoyu()
	     return
	  end
   end)

end

local function convert_seconds(seconds)
    local hours = math.floor(seconds / 3600)
    seconds = seconds - (hours * 3600)
    local minutes = math.floor(seconds / 60)
    seconds = seconds - (minutes * 60)
    return hours, minutes, seconds
end

function fish:sell_gui()
 	   local sp=special_item.new()
       sp.cooldown=function()
           print("cooldown")
		   for _,i in ipairs(sp.equipment_items) do
		      print(i.name,i.id,i.num)
		      if string.find(i.name,"����") or string.find(i.name,"��Ƥ") then
				 local w=walk.new()
                 w.walkover=function()
				   local t=os.time()
				   local interval=os.difftime(t,starttime)
				    local hours,minutes,seconds=convert_seconds(interval)
					print(hours,minutes,seconds)
	                print(interval,":��")
                   --world.Execute("#10 drop yu")
				  fish_count=fish_count+1
				local ts={
	             task_name="����",
	             task_stepname="����",
	             task_step=1,
	             task_maxsteps=1,
	             task_location=" ʱ��:"..hours..":"..minutes..":"..seconds,
	             task_description="���ڹ���:"..fish_count,
             	}
	            local st=status_win.new()
	            st:init(nil,nil,ts)
	            st:task_draw_win()

	               world.Execute("sell gui")
				   world.Execute("sell xiong pi")
				   local f=function()
				      self:sell_gui()
				   end
				   f_wait(f,2)
                 end
                 w:go(1332)
		        return
		       end
		   end
		    self:go_fish()
       end
       local equip={}
	   equip=Split("<����>��|<����>�ϵ������|<��ȡ>��Ƥ&10|<����>�ƽ�&50|<����>����&300","|")
       sp:check_items(equip)
end

function fish:find()
      world.Execute("#5 find")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)�����˰��죬û����ʲô�������õĶ�����$|^(> |)���ҵ���һ�Ѳ�֪��˭��������ľ���͡�$|^(> |)�����ϲ����������ô��$$|^(> |)ʲô��$",2)
		if l==nil then
		   self:find()
		   return
		end
		if string.find(l,"û����ʲô�������õĶ���") then
		   self:get_yugan()
		   return
		end
		if string.find(l,"�����") or string.find(l,"�����ϲ����������") then
		  wait.time(2)
		  self:go_fish()
		  return
		end
		if string.find(l,"ʲô") then
		   self:find_yugan()
		   return
		end
	  end)
end

function fish:find_yugan()
   local w=walk.new()
   w.walkover=function()
      world.Execute("#5 find")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)�����˰��죬û����ʲô�������õĶ�����$|^(> |)���ҵ���һ�Ѳ�֪��˭��������ľ���͡�$|^(> |)�����ϲ����������ô��$$",2)
		if l==nil then
		   self:find()
		   return
		end
		if string.find(l,"û����ʲô�������õĶ���") then
		   self:get_yugan()
		   return
		end
		if string.find(l,"�����") or string.find(l,"�����ϲ����������") then
		  wait.time(2)
		  self:go_fish()
		  return
		end
	  end)
   end
   w:go(2656)
end

  local co=nil
function fish:get_yugan()
   local dx={"wd","wd","wd","n","e","n","enter","out","s","e","s","e","s","w","s","eu";"eu";"eu"}
--���߳���ǰȥ�������ؽ�����ס���˫�֣�������˵����������
--�����ϲ����������ô��
--�����˰��죬û����ʲô�������õĶ�����
--���ڽ����������﷭����ȥ��
--���ҵ���һ�Ѳ�֪��˭��������ľ���͡�
   co=coroutine.create(function()
    for _,d in ipairs(dx) do

	 world.Send("ask lao zhe about ���")
	 world.Send(d)
	 wait.make(function()
	   local l,w=wait.regexp("^(> |)���߳���ǰȥ�������ؽ�����ס���˫�֣�������˵����������$|^(> |)����˵���������Ǹ����������Լ�ȥ���ҡ���$",0.5)
	   if l==nil then
	      coroutine.resume(co)
	      return
	   end
	   if string.find(l,"���߳���ǰȥ") or string.find(l,"�Լ�ȥ����") then
	      wait.time(2)
	      self:find_yugan()
	      return
	   end
	 end)
	 coroutine.yield()
    end
	self:get_yugan()
  end)
  coroutine.resume(co)
end

function fish:go_fish()
   local w=walk.new()
   w.walkover=function()
      fish:diaoyu()
   end
  -- w:go(2654)
  w:go(5205)
end

function fish:shouxian()
   wait.make(function()
      world.Send("shouxian")
      local l,w=wait.regexp("^(> |)�𼱣���������$|^(> |)���������ͣ����ž��һ�����ˡ�$|^(> |)��������͵Ĺ���һ��������ֱ��ֱĽ���ˮ�$|^(> |)��˦�;������ߣ��и��ԣ�$|^(> |)�������أ�$|^(> |)�������ؽ�һ��������ק��������$",3)
	  if l==nil then
	     self:shouxian()
	     return
	  end
      if string.find(l,"�𼱣�������") then
	    wait.time(1)
	    self:shouxian()
	    return
	  end
	  if string.find(l,"��˦�;�������") then
	     self:diaoyu()
	     return
	  end
	  if string.find(l,"����") or string.find(l,"��������") then
	     wait.time(1.5)
	     world.Send("drop duan yugan")
		 self:get_yugan()
	     return
	  end
	  if string.find(l,"��������͵Ĺ���һ��������ֱ��ֱĽ���ˮ��") then
	     self:diaoyu()
	     return
	  end
	  if string.find(l,"�������ؽ�һ��������ק������") then
		wait.time(1)
	    self:sell_gui()
	    return
	  end
   end)
end

--find ��˦�;������ߣ��и��ԣ�
function fish:go()
   starttime=os.time()
   fish_count=0
  local w=walk.new()
   w.walkover=function()
    self:get_yugan()
  end
 -- w:go(2654)
  w:go(5205)
end
--[[
�㽫������ڹ��ϣ�һ�����е���ͣ�����˦�˳�ȥ��
��ͻȻ�����������һ���������Ϲ��ˣ�������(shouxian)����
> ������������ڹ��ϣ�һ�����е���ͣ�����˦�˳�ȥ��
shouxian
�𼱣���������
>
shouxian
���������ͣ����ž��һ�����ˡ�--]]
--2656
