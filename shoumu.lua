require "map"
require "wait"
require "cond"
require "hp"
require "heal"
require "sj_mini_win"
shoumu={
  new=function()
     local sm={}
	 setmetatable(sm,{__index=shoumu})
	 return sm
  end,
}
--u;out;e;smok  n;n;n;n;n;w;w;n;n;give rong all
function shoumu:get_time()
  wait.make(function()
      world.Send("time")
	  local l,w=wait.regexp("^(> |)�������齣(.*)��(.*)��(.*)��(.*)ʱ(.*)��$",15)
	  if l==nil then
	    print("��ʱ:")--��
	    self:get_time()
		return
	  end
	  if string.find(l,"�������齣") then
	    print(w[2],w[3],w[4],w[5],w[6])
	    local hour=w[5]
	    print(hour)
	    local mins=w[6]
	     print(mins)
	    if hour=="��" or hour=="��" or hour=="��" or hour=="��" or hour=="��" or hour=="��" or hour=="��" or hour=="î" or hour=="��" then
	      print("����")
	      self:Status_Check()
	    else
	      print("����")
	      self.fail(201)
	    end
        return
	  end
	  wait.time(15)
   end)
end

function shoumu:out_mudi()
   world.Execute("up;out;east")
end

function shoumu:combat()
end

function shoumu:entry_mudi()
 wait.make(function()
	world.Send("guibai mubei")
	world.Send("push mubei left")
	world.Send("push mubei left")
	world.Send("push mubei left")
	world.Send("push mubei right")
	world.Send("push mubei right")
	world.Send("push mubei right")

   local l,w=wait.regexp("^(> |)Ĺ�������ƿ���¶��һ��ʯ���ĵص������æ���˽�ȥ��$",5)
   if l==nil then
      self:entry_mudi()
	  return

   end
   if string.find(l,"Ĺ�������ƿ���¶��һ��ʯ���ĵص�") then
     world.Send("down")
	 self:mudi()
     return
   end
   wait.time(5)
 end)
end


function shoumu:graveyard()
  wait.make(function()
    local l,w=wait.regexp("^(> |)ͻȻ����.*���һ����д���һ����Ĺ�������ʯ�ؾͲ����ˡ�$",5)
	if l==nil then
	   self:graveyard()
	   return
	end
	if string.find(l,"���ʯ�ؾͲ�����") then
	   self:entry_mudi()
	   return
	end
	wait.time(5)
  end)
end

function shoumu:shimu()
  local b=busy.new()
   b.interval=0.5
   b.Next=function()
     wait.make(function()
	  world.Send("ask huang rong about ʦĸ")
	   local l,w=wait.regexp("^(> |)������ش����йء�ʦĸ������Ϣ��$",10)
	  if l==nil then
	     self:ask_job()
		 return
	  end
	   if string.find(l,"������ش����й�") then
	     local b=busy.new()
		 b.interval=0.3
		 b.Next=function()
	       self:ask_job()
		 end
		 b:check()
		 return
	   end
	    wait.time(10)
	  end)
   end
  b:check()
end

function shoumu:fail(id)
end
--[[
�㳤��������һ������
> ������ش����йء���Ĺ������Ϣ��
halt
set busy
����˵�������ѵ�����������⣬������ĸ�׵�Ĺ���������ܽ�ȥ�ġ���
> �����ں�æ��ͣ��������
> �趨����������busy = "YES"
>
halt
set busy
�����ڲ�æ��
ask huang rong about ʦĸ
> �趨����������busy = "YES"
> ������ش����йء�ʦĸ������Ϣ��
halt
set busy
����̾�˿�����˵��: ��ĸ�׾�����������ϧ��Ӣ�����ţ��ҵ������������һ����ϵ�һ��Ĺ�
> �����ں�æ��ͣ��������
> �趨����������busy = "YES"
>
halt
set busy
�����ں�æ��ͣ��������
> �趨����������busy = "YES"
>
halt
set busy
�����ڲ�æ��
ask huang rong about ��Ĺ
> �趨����������busy = "YES"
> ������ش����йء���Ĺ������Ϣ��
����˵��������ҪС�ĵ㣬��ĸ�׵�Ĺ�ɲ���һ���˶��ܽ�ȥ�ġ���
���������룬˵��: ������,�Ҵ���ȥ!
������Ż��أ���һת����һת����һ��͵���Ĺǰ��]]
function shoumu:catch_place()
  wait.make(function()
   local l,w=wait.regexp("^(> |)�����ɻ�Ŀ�����,˵��: ���ڴ����ģ���ʲôĹѽ\\?$|^(> |)������Ż��أ���һת����һת����һ��͵���Ĺǰ��$|^(> |)����˵��������ո�������Ĺ���񣬻�������Ϣһ��ɡ���$|^(> |)����˵�������Ѿ�����ȥ��Ĺ�ˣ����´���ȥ�ɣ���$|^(> |)�趨����������ask \\= \\\"YES\\\"$|^(> |)����˵�������Բ�����������û��ʲô���Ը������ġ���$",5)
       if l==nil then
	     self:catch_place()
	     return
      end
      if string.find(l,"������Ż��أ���һת����һת����һ��͵���Ĺǰ") then
	     self:graveyard()
	     --self:shimu()
		 return
	  end
	  if string.find(l,"�����ɻ�Ŀ�����") then
	     print("bai tian")
	     self.fail(201)
		 return
	  end
	  if string.find(l,"��ո�������Ĺ���񣬻�������Ϣһ���") then
	     self.fail(101)
	     return
	  end
	  if string.find(l,"�Ѿ�����ȥ��Ĺ�ˣ����´���ȥ��") then
	     self.fail(103)
		 return
	  end
	  if string.find(l,"��������û��ʲô���Ը�������") then
	     self.fail(102)
	     return
	  end
	  if string.find(l,"�趨����������ask") then
	    self:shimu()
		return
	  end
	  wait.time(5)
  end)
end

function shoumu:ask_job()
	 	local ts={
	           task_name="�һ�����Ĺ",
	           task_stepname="ѯ�ʻ���",
	           task_step=2,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

  local w
  w=walk.new()
  w.walkover=function()

	wait.make(function()
	  world.Send("ask huang rong about ��Ĺ")--�����ɻ�Ŀ�����,˵��: ���ڴ����ģ���ʲôĹѽ?
	  world.Send("set ask")
      local l,w=wait.regexp("^(> |)������ش����йء���Ĺ������Ϣ��$",5)
	  if l==nil then
	     self:ask_job()
		 return
	  end
	  if string.find(l,"������ش����й�") then
	    self:catch_place()
	    return
	  end
	  wait.time(5)
	end)
  end
  w:go(2803)

end

function shoumu:zei_die()
end

function shoumu:wait_zei_die()
   wait.make(function()
     local l,w=wait.regexp("^(> |)��Ĺ����ž����һ�����ڵ��ϣ������ų鶯�˼��¾����ˡ�$",5)
	 if l==nil then
	    self:wait_zei_die()
	    return
	 end
	 if string.find(l,"�����ų鶯�˼��¾�����") then
        self:zei_die()
	    return
	 end
	 wait.time(5)
   end)
end

function shoumu:killzei()
  wait.make(function()
     world.Send("look zei")
	 local l,w=wait.regexp("^(> |)��Ĺ��\\(Daomu zei\\)$|^(> |)��Ҫ��ʲô��$",5)
	 if l==nil then
	   self:killzei()
	   return
	 end
     if string.find(l,"��Ĺ��") then
	   world.Send("kill zei")
	   self:wait_zei_die()
	   self:combat()
	   return
	 end
	 if string.find(l,"��Ҫ��ʲô") then
	   local f=function()
	     print("û�гɹ���")
	     self:mudi()
	   end
	   f_wait(f,0.8)
	   return
	 end
	 wait.time(5)
  end)
end

function shoumu:mudi()
--[[^{> ��|��}����*��*��*�ճ�ʱ
(su;se;down;s;su;d;kill zei)
^{> ��|��}����*��*��*�ճ�ʱ
(nu;nw;down;n;nu;down;kill zei)
^{> ��|��}����*��*��*�պ�ʱ
(sd;s;down;sw;sd;down;kill zei)
^{> ��|��}����*��*��*��îʱ
(e;ne;down;se;e;down;kill zei)
^{> ��|��}����*��*��*����ʱ
(nd;n;down;ne;nd;down;kill zei)
^{> ��|��}����*��*��*����ʱ
(sd;s;down;sw;sd;down;kill zei)
^{> ��|��}����*��*��*��δʱ
(nu;nw;down;n;nu;down;kill zei)
^{> ��|��}����*��*��*����ʱ
(w;sw;down;nw;w;down;kill zei)
^{> ��|��}����*��*��*����ʱ
(su;se;down;s;su;down;kill zei)
^{> ��|��}����*��*��*����ʱ
(nd;n;down;ne;nd;down;kill zei)
^{> ��|��}����*��*��*����ʱ
(e;ne;down;se;e;down;kill zei)
^{> ��|��}����*��*��*����ʱ
(w;sw;down;nw;w;down;kill zei)]]
wait.make(function()
  world.Send("time")
	  local l,w=wait.regexp("^(> |)�������齣(.*)��(.*)��(.*)��(.*)ʱ(.*)��$",15)
	  if l==nil then
	    print("��ʱ:")--��
	    self:mudi()
		return
	  end
	  if string.find(l,"�������齣") then
	  local path
	  print(w[2],w[3],w[4],w[5],w[6])
	  local hour=w[5]
	  print(hour)
	  local mins=w[6]
	  print(mins)
	if hour=="��" then
	  path="su;se;d;s;su;d"
	elseif hour=="��" then
	   path="nu;nw;d;n;nu;d"
	elseif hour=="��" then
	  path="sd;s;down;sw;sd;down"
	elseif hour=="î" then
	  path="e;ne;down;se;e;down"
	elseif hour=="��" then
	  path="nd;n;down;ne;nd;down"
	elseif hour=="��" then
	  path="sd;s;down;sw;sd;down"
	elseif hour=="δ" then
	  path="nu;nw;down;n;nu;down"
	elseif hour=="��" then
	  path="w;sw;down;nw;w;down"
	elseif hour=="��" then
	  path="su;se;down;s;su;down"
	elseif hour=="��" then
	  path="nd;n;down;ne;nd;down"
	elseif hour=="��" then
	  path="e;ne;down;se;e;down"
	elseif hour=="��" then
	  path="w;sw;down;nw;w;down"
	end
	   print(path)
	   world.Execute(path)
	   self:killzei()
	   return
	end
	  wait.time(15)
   end)
end

function shoumu:mudi1()
  wait.make(function()
      world.Send("time")
	  local l,w=wait.regexp("^(> |)�������齣(.*)��(.*)��(.*)��(.*)ʱ(.*)��$",15)
	  if l==nil then
	    print("��ʱ:")--��
	    self:mudi1()
		return
	  end
	  if string.find(l,"�������齣") then
	  local path
	  print(w[2],w[3],w[4],w[5],w[6])
	  local hour=w[5]
	  print(hour)
	  local mins=w[6]
	  print(mins)
	  if (hour=="��" or hour=="��") and (mins=="����" or mins=="����") then
	  --^??������*��*��*��{��|��}ʱ{����|����}��
      --sm12;kick daomu zei
        path="sw;d;sw;d;sd;d"
      elseif (hour=="��" or hour=="��") and (mins=="��" or mins=="һ��") then
      --^??������*��*��*��{��|��}ʱ{��|һ��}��
      --sm11;kick daomu zei
		path="sd;d;sd;d;s;d"
      elseif (hour=="��" or hour=="��") and (mins=="����" or mins=="����") then
      --^??������*��*��*��{��|��}ʱ{����|����}��
      --sm10;kick daomu zei
        path= "s;su;d;s;su;d"--{} "s;d;s;d;su;d"
      elseif (hour=="��" or hour=="��") and (mins=="��" or mins=="һ��") then
       --^??������*��*��*��{��|��}ʱ{��|һ��}��
       --sm09;kick daomu zei
        path="su;se;d;su;se;d" --{"su;d;su;d;se;d"}
	  elseif (hour=="î" or hour=="��") and (mins=="����" or mins=="����") then
        --^??������*��*��*��{î|��}ʱ{����|����}��
        --sm08;kick daomu zei
       path="se;e;d;se;e;d" --{"se;d;se;d;e;d"}
      elseif (hour=="î" or hour=="��") and (mins=="��" or mins=="һ��") then
	    --^??������*��*��*��{î|��}ʱ{��|һ��}��
        --sm07;kick daomu zei
       path="e;ne;d;e;ne;d" --{"e;d;e;d;ne;d"}
	  elseif (hour=="��" or hour=="��") and (mins=="����" or mins=="����") then
        --^??������*��*��*��{��|��}ʱ{����|����}��
        --sm06;kick daomu zei
       path="ne;d;ne;d;nd;d"
      elseif (hour=="��" or hour=="��") and (mins=="��" or mins=="һ��") then
        --^??������*��*��*��{��|��}ʱ{��|һ��}��
        --sm05;kick daomu zei
       path="nd;n;d;nd;n;d" --{"nd;d;nd;d;n;d"}
	  elseif (hour=="��" or hour=="δ") and (mins=="����" or mins=="����") then
        --^??������*��*��*��{��|δ}ʱ{����|����}��
        --sm04;kick daomu zei
       path="n;d;n;d;nu;d"
	  elseif (hour=="��" or hour=="δ") and (mins=="��" or mins=="һ��") then
        --^??������*��*��*��{��|δ}ʱ{��|һ��}��
        --sm03;kick daomu zei
       path="nu;nw;d;nu;nw;d" --{"nu;d;nu;d;nw;d"}
      elseif (hour=="��" or hour=="��") and (mins=="����" or mins=="����") then
        --^??������*��*��*��{��|��}ʱ{����|����}��
        --sm02;kick daomu zei w;sw;down;nw;w;down;kill zei)  {nw;d;nw;d;w;d}?
         path="nw;d;nw;d;w;d"
       elseif (hour=="��" or hour=="��") and (mins=="��" or mins=="һ��") then
	    --^??������*��*��*��{��|��}ʱ{��|һ��}��
        --sm01;kick daomu zei
       path="w;d;w;d;sw;d"
	  end
	   print(path)
	   world.Execute(path)
	   self:killzei()
	   return
	  end
	  wait.time(15)
   end)
end

function shoumu:eat()
    local w=walk.new()
	w.walkover=function()
	      world.Execute("buy baozi")
		  world.Execute("eat baozi;eat baozi;eat baozi;drop baozi")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
	end
	w:go(976) --����¥ 976
end

function shoumu:drink()
     local w=walk.new()
	   w.walkover=function()
	      world.Execute("buy jiudai")
		  world.Execute("drink jiudai;drink jiudai;drink jiudai;drink jiudai;drink jiudai;drop jiudai")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
		end
		w:go(976) --����¥ 976
end
function shoumu:full()
  	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<50 or h.drink<50 then
		   if h.food<50 then
			    self:eat()
			 elseif h.drink<50 then
			    self:drink()
			 end

		elseif h.jingxue_percent<=80 then
		   --�������ƶ�        �����                    �� �� ��
		   --�����ж���
			  print("����")
              local rc=heal.new()
			  rc.saferoom=505
			  rc.heal_ok=function()
			     self:Status_Check()
			  end
			  rc:liaoshang()
		elseif h.qi_percent<100 then
			print("��ͨ����")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()

		elseif h.neili<(h.max_neili*2-200) then
		    local x
			x=xiulian.new()
			x.safe_qi=300
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
	           if id==202 then
			   --�������
				   local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(2801)
			   end
			end
			x.success=function(h)
               print(h.qi,h.max_qi*0.9)
			   print(h.neili,h.max_neili*2-200)
			   if h.neili>h.max_neili*2-200 then
			     world.Send("yun recover")
			     self:ask_job()
			   else
	             print("��������")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()
		elseif h.pot>h.max_pot-20 then
			self:jobDone()
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

function shoumu:Status_Check()


	 	local ts={
	           task_name="�һ�����Ĺ",
	           task_stepname="����",
	           task_step=1,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
     --��ʼ��
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

function shoumu:gem()
  world.Send("get all from corpse")

  wait.make(function()
      local l,w=wait.regexp("^(> |)��ӵ�Ĺ����ʬ�������ѳ�һ.*��$",5)
	 if l==nil then
	    self:gem()
		return
	 end
	 if string.find(l,"��ӵ�Ĺ����ʬ�������ѳ�") then
	    world.Send("drop cloth")
       self:reward()
	   return
     end
    wait.time(5)
  end)
end


function shoumu:reward()
	 	local ts={
	           task_name="�һ�����Ĺ",
	           task_stepname="����",
	           task_step=3,
	           task_maxsteps=3,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
 local w
  w=walk.new()
  w.walkover=function()
	wait.make(function()
	  world.Send("give all to huang rong")
      local l,w=wait.regexp("^(> |)�������һ.*��$",5)--�������һ������
	  if l==nil then
	     self:reward()
		 return
	  end
	  if string.find(l,"�������") then
	     self:jobDone()
		 return
	  end

	end)
  end
  w:go(2803)

end

function shoumu:jobDone()  --�ص�����
end
