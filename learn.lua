
learn={
 new=function()
     local l={}
	 l.skills={}
	 setmetatable(l,{__index=learn})
	 return l
 end,
 masterid="",
 mastername="",
 master_place="",
 skills={},
 skillsIndex=1,
 interval=0.1,
 timeout=3,
 vip=false,
 run_vip=false,
 pot=1,
 weapon="",
 limit=nil,
 wield_weapon=true,
}

local function exps_skilllimit(exps)
   for i=1,300 do
      --print(math.floor(i*i*i/10), " �ȼ�",i)
	  if tonumber(exps)<math.floor(i*i*i/10) then
	    print("�ȼ�:",i)
	    return i
	  end
   end
end
--������˵�����������ڵ�ѧ����ÿ����ʮ��ͭǮ���뱸����Ǯ����
function learn:cost(cmd,callback)
  world.Execute(cmd)
  wait.make(function()
    local l,w=wait.regexp("^(> |)������˵�����������ڵ�ѧ����ÿ��(.*)���뱸����Ǯ����",5)
	if l==nil then
	   self:cost(cmd,callback)
	   return
	end
	if string.find(l,"�뱸����Ǯ") then
	   --������˵�����������ڵ�ѧ����ÿ��һ���ƽ��뱸����Ǯ����
	   local costing=w[2]
	   local num=string.sub(costing,1,-7)
	   local n=ChineseNum(num)
	   local money=1
	   if string.find(costing,"�ƽ�") then
	      money=1
	   else
	      money=0.01
	   end
	   local n=n*200*money
	   if n>800 then
	      n=800
	   end
       print(n,"����")
	   if n<1 then
	      n=1
	   end
	   local b=busy.new()
	   b.Next=function()
	     callback(n)
	   end
	   b:check()
	   return
	end

  end)


end
--ѧ��ֻ��ѧ�������ˣ�ʣ�µ�Ҫ�����Լ������ˡ�
--
--����ʱ�޷������｣�����㿪ʼ��ȡ��ҩʦ������ָ�����ԡ�������졹��һ�н��п�˼��
function learn:ExecuteCmd(cmd)

  wait.make(function()
 local l,w=wait.regexp("^(> |)ѧ��ֻ��ѧ��������.*$|^(> |)�㲻�������.*$|^(> |)Ҳ����ȱ��ʵս���飬���.*�Ļش������޷���ᡣ$|^(> |)�㿪ʼ��ȡ.*����.*���п�˼��|^(> |)������.*��ָ�����ƺ���Щ�ĵá�$|^(> |)���Ǳ�ܲ��㡣$|^(> |)��û����ô��Ǳ����ѧϰ��û�а취�ٳɳ��ˡ�$|^(> |)�����̫���ˣ����ʲôҲû��ѧ����$|^(> |)������ѧϰһ������Ҫ�ķ�����.*�������ϴ�����Ǯ�����ˡ�$|^(> |)˽������˵������̫�����ˣ�����ô�ҵ���$|^(> |)�������ĳ̶��Ѿ�������ʦ���ˡ�$|^(> |)��ʹ�õ��������ԡ�$|^(> |).*�������.*$|^(> |)��Ҫ��˭��̣�$|^(> |)�����ڵ�ѧ����ÿ��.*�����Ǯ������$|^(> |)��������Ѿ��޷�ͨ��ѧϰ������ˡ�$|^(> |)�����˶����ָ�㣬���ǻ��ǲ�����⡣$|^(> |)�����˶����ָ�㣬�����վ��İ����ƺ���Щ�ĵá�$|^(> |)����ʱ�޷���.*��$|^(> |)ѧ.*ʱ���ﲻ����������$|^(> |)������û������������$|���.*����ⲻ�����谭�����.*��������$|^(> |)���������±����ұ���ѧ�ˡ�$|^(> |).*����ɫ�е��ѿ����ƺ��ǲ��봫������������$|^.*����֡�$|^(> |)��Ǳ�ܲ������Ѿ������ˡ�$|^(> |)����ʵս���鲻�㣬�谭�����.*|^(> |)���.*�������޷����������.*$|^(> |)���������һ.*$|^(> |)��Ļ��������δ���������ȴ�û������ܼ�����ߡ�$|^(> |)���Ǳ���Ѿ������ˣ�����ô��Ҳû�á�$|^(> |)��û��ʹ�õ�������$|^(> |)����������������һ�������������������ƣ����޷��ٽ��޸������ѧ���ˡ���$|^(> |)����û������ˡ�$|^(> |)�ɸߵ���ͻȻ̾Ϣ������������һ����ʯ����ʯ���ɻ�Ҳ���ҿ����Ǻ��ѿ����ˡ�����$|^(> |)�ɸߵ����Ͻ���ס���������㰧�������.*����ǧ������ˣ�ƶ������춣��ѽ�� �������������Ĺĵģ���ʵ����ɶ�����Ҷ��ѽ����$|^(> |)�ɸߵ����������ĵġ��š���һ�����ƺ�����û������˵ʲô��$|^(> |)��Ļ����ڹ����̫ǳ��$|^(> |)����ö�̫��ȭ��������⣬�޷�������ϰ̫��ȭ��$|^(> |)���а��̫���ˡ�$|^(> |)�����������̫���ˣ�������˼ѧϰ�⻪ɽ������$|^(> |)�������ȭ̫�����޷�ѧϰ����ɽ�����ľ��衣$|^(> |)�����ϵ���������������.*��$|^(> |)������.*$|^(> |)���������һ�����Ӳ������޷���$|^(> |)���ַ�����ϰ��Ůȭ����$|^(> |)���������һ�����Ӳ������޷���$|^(> |)���ַ�����ϰ.*|^(> |)�㲻����ѧϰ�����黭�ˡ�$|^(> |)����ɽ�����Ʊ�����ơ�$|^(> |)�ɸߵ���˵����������������ģ��Ǹ��������ģ����˵��Ҳ�Ǻ��е����\\.\\.\\.\\.\\.\\%\\^\\%\\$\\^\\%\\&\\^\\^��$",self.timeout)
     if l==nil then
		 self:start_success()
		return
     end
	 if string.find(l,"�޷�������ϰ̫��ȭ") then
	    world.Send("ask zhang about ̫��ȭ��")
	    local f=function() self:ExecuteCmd() end
		f_wait(f,self.interval)
	    return
	 end
     if string.find(l,"�����ȴ�û������ܼ������") or string.find(l,"�㲻����ѧϰ�����黭��") or string.find(l,"�޷����") or string.find(l,"����ʵս���鲻��") or string.find(l,"Ҳ����ȱ��ʵս����") or string.find(l,"�㲻�������") or string.find(l,"��������Ѿ��޷�ͨ��ѧϰ�������") or string.find(l,"��ⲻ��") or string.find(l,"�ƺ��ǲ��봫������������") or string.find(l,"ѧ��ֻ��ѧ��������") or string.find(l,"��Ļ����ڹ����̫ǳ") or string.find(l,"���а��̫����") or string.find(l,"�����������̫����") or string.find(l,"�޷�ѧϰ����ɽ�����ľ���") then
		local f=function() self.start_failure(1) end
        print "Ҳ����ȱ��ʵս����"
		f_wait(f,self.interval)
		return
     end
     if string.find(l,"�ƺ���Щ�ĵá�") or string.find(l,"�㿪ʼ��ȡ") or string.find(l,"�����˶����ָ�㣬�����վ��İ����ƺ���Щ�ĵ�") or string.find(l,"���˵��Ҳ�Ǻ��е����") then
	    local f=function() self:start_success() end
        print "�ɹ�"
		f_wait(f,self.interval)
		return
     end
      if string.find(l,"�ƺ�����û������˵ʲô") or string.find(l,"���Ǳ�ܲ��㡣") or string.find(l,"��Ǳ�ܲ���") or string.find(l,"��û����ô��Ǳ����ѧϰ��û�а취�ٳɳ���") or string.find(l,"�����˶����ָ�㣬���ǻ��ǲ������") or string.find(l,"���Ǳ���Ѿ�����") then
         --print("�������һ��"..w[1])
		 print("���Ǳ�ܲ��㡣")
		 local f=function() self.start_failure(102) end
		 f_wait(f,self.interval)
		 return
     end
	 if string.find(l,"������û����������") then
	     self.wield_weapon=false
         self:ExecuteCmd(cmd)
		 return
	 end
	if string.find(l,"�����̫����") then
         --print("�������һ��"..w[1])
		 print("�����̫����")
		 local f=function() self.start_failure(401) end
		 f_wait(f,self.interval)
		 return
     end
	 --�����ڵ�ѧ����ÿ�ζ�ʮ�������������Ǯ������
	if string.find(l,"�����ϴ�����Ǯ������") or string.find(l,"˽������˵������̫�����ˣ�����ô�ҵ���") or string.find(l,"�����ڵ�ѧ����ÿ��.*�����Ǯ������") or string.find(l,"�ɸߵ����Ͻ���ס����") then
         --print("�������һ��"..w[1])
		 print("�����ϴ�����Ǯ������")
		 local f=function() self.start_failure(101) end
		 f_wait(f,self.interval)
		 return
     end

	if string.find(l,"�������ĳ̶��Ѿ�������ʦ����") or string.find(l,"���������±����ұ���ѧ��") or string.find(l,"���������") then
         --print("�������һ��"..w[1])
		 print("�������ĳ̶��Ѿ�������ʦ���ˡ�")
		 local f=function() self.start_failure(201) end
		 f_wait(f,self.interval)
		 return
     end
	if string.find(l,"���������һ������") or string.find(l,"��ʹ�õ���������") or string.find(l,"����ʱ�޷�") or string.find(l,"��û��ʹ�õ�����") or string.find(l,"�����ϵ�����") or string.find(l,"�������޷�") then
         --print("�������һ��"..w[1])
		 print("��ʹ�õ���������")
		 if self.wield_weapon==false then
		   local f=function() self.start_failure(301) end
		   f_wait(f,self.interval)
		   return
		 end
		  local sp=special_item.new()
		  sp.cooldown=function()
             local f=function() self.start_failure(202) end
		     f_wait(f,self.interval)
          end
          sp:unwield_all()
		 return
     end--ѧ��ָ��ͨ������ֻ��ְֳ�����
	 if string.find(l,"�����") or string.find(l,"���ﲻ��������") or string.find(l,"������") or string.find(l,"����") or string.find(l,"����") then
	     print("����")
		  local sp=special_item.new()
		  sp.cooldown=function()
             --local f=function() self.start_failure(203) end
		     -- f_wait(f,self.interval)
			 self:Execute(cmd)
          end
          sp:unwield_all()
	    return
	 end
if string.find(l,"�����������ƣ����޷��ٽ��޸������ѧ����") then
	 self.start_failure(920)
     return
end
	 if string.find(l,"��Ҫ��˭���") or string.find(l,"����û�������") then
	      local place
	     place=self.master_place
	    if place==2748 then
	         self.master_place=2457
			 self.masterid="yao"

	   elseif place==2457 then
		      self.master_place=2748
			 self.masterid="xiao"
	   elseif place==245 then
	          self.master_place=1929
	   elseif place==1929 then
			   self.master_place=2427
		 elseif place==2427 then
			   self.master_place=2428
	   elseif place==2428 then
				self.master_place=2390
	   elseif place==2390 then
			   self.master_place=2421
	   elseif place==2421 then
			   self.master_place=244
	   elseif place==244 then
	           self.master_place=245
	   end

	   self.start_failure(2)
	   --self:go()
	   return
	 end
	 if string.find(l,"������һ����ʯ����ʯ���ɻ�Ҳ���ҿ����Ǻ��ѿ�����") then
	     local b=busy.new()
		 b.Next=function()
	        self:getyu()
		 end
		 b:check()
		 return
	 end
     --�ȴ�
    wait.time(self.timeout)
	print("����")
   end)
end

function learn:getyu()

   local w=walk.new()
   w.walkover=function()
      local i
	  i=self.skillsIndex
	  local skill_id=self.skills[i]
	   world.Send("qu qiqiaolinglong yu")
	   local f=function()
         world.Send("lingwu "..skill_id.." with yu")
	     self:go()
	   end
	   f_wait(f,3)
   end
   w:go(94)
end


function learn:xiulian()
  --
  print("��������")
   local x
	x=xiulian.new()
	x.safe_qi=300
	x.limit=true
	x.fail=function(id)
		--print(id)
		if id==201 or id==1 then
			world.Send("yun recover")
			world.Send("yun jing")
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
		print(h.qi,h.max_qi*0.9)
		print(h.neili,h.max_neili*2-200)
		if h.neili>h.max_neili*2-200 then
		  self:go()
		else
		  print("��������")
		  world.Send("yun recover")
		  x:dazuo()
		end
	end
	x:dazuo()
end

function learn:Execute(cmd)
     self.wield_weapon=true
	 self:ExecuteCmd(cmd)
	 self:wuxing()
	 world.Execute(cmd)
end
--�����˶����ָ�㣬���ǻ��ǲ�����⡣
--973
function learn:go_ding() --��ʦ�ص�

	if self.vip==true and self.run_vip==false then
	   self:vip_start()
	else
	  local place
	  place=self.master_place
	  local w
	  w=walk.new()
	  w.walkover=function()
	   print("ѧϰ��ʼ")
	   --self.start()
       self:shenzhaojing()
	  end
	  w:go(973)
	end
end

function learn:shenzhaojing()
    local cmd
	cmd="ask ding about ���վ�"

    --�����˶����ָ�㣬�����վ��İ����ƺ���Щ�ĵá�
	--print(cmd)
	self:Execute(cmd)
	--learn.this=self
end

function learn:jyzj(skillname)
    local cmd
	cmd="read "..skillname
	self:Execute(cmd)
end

function learn:start() --��ʼѧϰ

	--start_trigger()
	local cmd
	local skill_id
	local pot
	local i
	i=self.skillsIndex
	--print(i)
	skill_id=self.skills[i]
	local master
	master=self.masterid
	pot=self.pot
	print(master)
	if pot==1 then
	  cmd="learn "..skill_id .. " from " ..master
	else
	  cmd="xue " ..master .." " ..skill_id .." ".. pot
	end
	--print(cmd)
	self:Execute(cmd)
end

function learn:wuxing()  --������������
end

function learn:go() --��ʦ�ص�
--"xiao":2748
	if self.vip==true and self.run_vip==false then
	   self:vip_start()
	else
	  local place
	  place=self.master_place
	  local w
	  w=walk.new()
	  w.walkover=function()
	   print("ѧϰ��ʼ")
	   --self.start()
	   if place==2748 or place==2457 or place==2358 then
	       world.Send("bai "..self.masterid)
	   end

	   self:wuxing()
       self:start()
	  end
	  w:go(place)
	end
end


function learn:start_failure(error_id) --�ص�����

end

function learn:rest() --�ص�����

end


function learn:regenerate()
   -- regenerate_trigger()
    wait.make(function()
    world.Send("yun regenerate")
	local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$",5)
   if l==nil then
      --self.start_failure(-1)
	  self:regenerate()
	  return
   end
   if string.find(l,"��������") then
     print("learn",402)
     self.start_failure(402)
	 return
   end
   if string.find(l,"���������˼����������������ö���") then
     print("learn",403)
     self.start_failure(403)
	 return
   end
   wait.time(5)
   end)
end

function learn:start_success()  --�ص�����
  --������.*��ָ�����ƺ���Щ�ĵá�
   self:start() --Ĭ��
end

function learn:Next() --��һ��ѧϰ����
  self.skillsIndex=self.skillsIndex+1
  if self.skillsIndex>table.getn(self.skills) then
     return false
  else
     return true
  end
end

function learn:addskill(skillname)
   print(table.getn(self.skills),skillname)
   table.insert(self.skills,skillname)
end

--[[vip
�����������㿴����֪����Щʲô���⡣
����˵������������ ����һһ��һ��ʮ����ʮ��ʱ��ʮ�߷���ʮ���롣��
����˵�������㱾�ܻ�����ʹ�ù��������Сʱ��ʮ�߷���ʮ���룬���ڿ�ʼ��ʱ�ˡ��� --]]
function learn:vip_start()
   local w
   w=walk.new()
   w.walkover=function()
       wait.make(function()
          world.Send("ask ying gu about �������")
		  local l,w=wait.regexp("^(> |)����˵�������㱾�ܻ�����ʹ�ù������(.*)�����ڿ�ʼ��ʱ�ˡ���$|(> |)�Բ��𰡣�Ŀǰ�������ֻ�Թ��VIP�û�����ǿ��ѧϰ���ܡ�$|(> |)�㲻��������ϰ�������������ô���������ץ��ʱ�䡭��$|^(> |)����˵����������Ȼ���ʴϻۣ�����̰������ã�������ð���ˣ�����������ѯ�ʰɡ���$",10)
		  if l==nil then
            local f=function() self:vip_start() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"���ڿ�ʼ��ʱ��") or string.find(l,"�㲻��������ϰ�������������ô") then
		     self.run_vip=true
			 local b
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:go()
			 end
			 b:check()
			 return
		  end
		  if string.find(l,"�������ֻ�Թ��VIP�û�����") or string.find(l,"����Ȼ���ʴϻۣ�����̰�������")  then
		     self.vip=false
		     self.run_vip=false
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:go()
			 end
			 b:check()
		     return
		  end
		  wait.time(10)
	   end)

   end
   w:go(435)
end

--[[�����������㿴����֪����Щʲô���⡣
����˵��������Ĺ��������ʼʱ���ǣ�����һһ��һ��ʮ����ʮ��ʱ��ʮ�߷���ʮ���롣��
����˵������            ����ʱ���ǣ�����һһ��һ��ʮ����ʮ��ʱ��ʮ�ŷ���ʮ���롣��
����˵�����������һ�������ˣ����֡���
����˵�������㱾�ܻ�����ʹ�ù��������Сʱ��ʮ�����ʮ���롣��--]]
function learn:vip_end()
  local w
   w=walk.new()
   w.walkover=function()
	  world.Send("ask ying gu about ����")

	   local l,w=wait.regexp("^(> |)�������ô����йء�����������Ϣ��$",10)
		  if l==nil then
            local f=function() self:vip_end() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"�������ô����йء�����������Ϣ") then
		     self.run_vip=false
			 local b
			 b=busy.new()
			 b.interval=0.3
			 b.Next=function()
			   self:AfterFinish()
			 end
			 b:check()
			 return
		  end
		  wait.time(10)
   end
   w:go(435)
end

function learn:AfterFinish() --�ص�����

end

function learn:finish()
    print("vip״̬:",self.vip)
	print("vip run:",self.run_vip)
	local b=busy.new()
	b.interval=0.5
	b.Next=function()
	  print(self.weapon," Я������")
	  if self.weapon~="" then

	    world.Send("unwield "..self.weapon)
  	  end
     if self.vip==true then
        self:vip_end()
     else
       self:AfterFinish()
     end
   end
   b:check()
end

function learn:catch_limit()
--[[
��Ŀǰ�趨�Ļ��������У�
ask                  "YES"
busy                 "YES"
send                 "YES"
walk                 "off"
wimpycmd             "ks\pfm\hp"
]]
    local exps=world.GetVariable("exps")
	if exps~=nil then
	  self.limit=exps_skilllimit(exps)
	  print(self.limit,": ѧϰ����")
	end
   world.Send("set")
   world.Send("set look 1")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�趨����������look \\= 1$|^(> |)skilllimit(.*)$",5)
	 if l==nil then
	   self:catch_limit()
	   return
	 end
	 if string.find(l,"skilllimit") then
	    print("w2",w[3])

	    local old_limit=Trim(w[3])
		old_limit=assert (tonumber(old_limit))


		if old_limit==nil then
		  self:start()
		else
		  print("��ǰ:",self.limit,"?>",old_limit)
		  if self.limit>old_limit then
		     self:go()
		  else
		  --ֱ�ӽ���
		     self:AfterFinish()
		  end
		end
	   return
	 end
	 if string.find(l,"�趨����������look") then
	    self:go()
	    return
	 end
	 wait.time(5)
   end)
end
