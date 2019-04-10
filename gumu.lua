
gumu={
   new=function()
     local gm={}
	 setmetatable(gm,gumu)
	 return gm
   end,
}
gumu.__index=gumu
--�뿪������Ĺ 115 �����ڹ�  500����
--��С��ŮҪ�� 120 ��Ů�ľ� 100 ��������

function gumu:get_pots(path,back_path,callback)
   world.Execute(path)
   world.Send("qn_qu 3000")
   wait.make(function()
      local l,w=wait.regexp("^(> |)���������ȡ��.*��Ǳ�ܡ�$",5)
	  if l==nil then
	     self:get_pots(path,back_path,callback)
	     return
	  end
	  if string.find(l,"���������ȡ") then
		 world.Execute(back_path)
		 callback()
	     return
	  end

   end)
end

function gumu:canwu_literate()  --5070
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 read qiang;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)���Ǳ��û�ˣ������ټ�����ϰ�ˡ�$|^(> |)���Ѿ���ȫ������ǽ�ϵ����֡�$",10)
	 if l==nil then
	    self:canwu_literate()
	    return
	 end
	 if string.find(l,"���Ǳ��û��") then
	    local f=function()
		   self:canwu_literate()
		end
	    self:get_pots("open door;w;w;w;w;out;up","d;enter;e;e;e;open door;e",f)
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:canwu_literate()
	    return
	 end
	 if string.find(l,"���Ѿ���ȫ������ǽ�ϵ�����") then
	    shutdown()
        self:lingwu_skills()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:canwu_literate()
		end
		local path="open door;w;w;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;e;open door;e",f)
	    return
	 end
   end)
end

function gumu:canwu_parry51() --5063 50 parry
    world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 yanxi ground;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)����ŵ�����ϰһ�ᣬֻ���������Ѿ������ء�$",10)
	 if l==nil then
	    self:canwu_parry51()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:canwu_parry51()
	    return
	 end
	 if string.find(l,"����ŵ�����ϰһ�ᣬֻ���������Ѿ�������") then
	    shutdown()
		wait.time(0.8)
		world.Send("yanxi top")
	    self:lingwu_skills()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:canwu_parry51()
		end
		local path="s;e;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;w;n",f)
	    return
	 end
   end)
end

function gumu:canwu_parry101() --5063 50 parry
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 yao tree;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)��ʹ����ҡ�δ��������ִ����챻��ҡ���ˡ�$",10)
	 if l==nil then
	    self:canwu_parry101()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:canwu_parry101()
	    return
	 end
	 if string.find(l,"��ʹ����ҡ�δ��������ִ����챻��ҡ����") then
	    shutdown()
		wait.time(0.8)
		--world.Send("yanxi top")
	    self:lingwu_skills()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:canwu_parry101()
		end
		local path="n;enter;e;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;w;out;s",f)
	    return
	 end
   end)
end

function gumu:canwu_force() --5063 50 force
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 yanxi wall;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)ʯ�������������ģ����޷������ʲô�¶�����$",10)
	 if l==nil then
	    self:canwu_force()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:canwu_force()
	    return
	 end
	 if string.find(l,"ʯ�������������ģ����޷������ʲô�¶���") then
	    shutdown()
		wait.time(0.8)
		world.Send("yanxi top")
	    self:lingwu_skills()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:canwu_force()
		end
		local path="s;e;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;w;n",f)
	    return
	 end
   end)
end
--yanxi top quanzhen-jianfa sword >10 yanxi top 5059  yunu-jianfa 5073
function gumu:canwu_sword51()  --��Ĺ������1 eastwall 51 ������2 westwall 100 5059
    world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 xiulian eastwall;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)���ʯ��������������ȫȻ����,�����ٷ�����. $",10)
	 if l==nil then
	    self:canwu_sword51()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:canwu_sword51()
	    return
	 end
	 if string.find(l,"���ʯ��������������ȫȻ����") then
	    shutdown()
		local gender=world.GetVariable("gender") or ""
		if gender=="����" then
		   world.Send("yanxi top")
		else
		   world.Execute("tui eastwall;enter;yanxi top")
		end
        self:lingwu_skills()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:canwu_sword51()
		end
		local path="s;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;n",f)
	    return
	 end
   end)
end

function gumu:canwu_sword101()  --��Ĺ������1 eastwall 51 ������2 westwall 100 5073
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 xiulian westwall;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)����ʵս���鲻�㣬�谭����ġ�.*��������$|^(> |)���ʯ��������������ȫȻ����,�����ٷ�����. $",10)
	 if l==nil then
	    self:canwu_sword101()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:canwu_sword101()
	    return
	 end
	 if string.find(l,"���ʯ��������������ȫȻ����") then
	    shutdown()
		self:lingwu_skills()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:canwu_sword101()
		end
		local path="tui westwall;out;s;e;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;n;tui eastwall;enter",f)
	    return
	 end
   end)
end

function gumu:canwu_dodge51()  --��Ĺ������1 eastwall 51 ������2 westwall 100 5073
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 zhuo maque;yun jing;yun jingli")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)�㲻���������˷�ʱ�侫���ˡ�$|^(> |)����ʵս���鲻�㣬�谭����ġ�.*��������$",10)
	 if l==nil then
	    self:canwu_dodge51()
	    return
	 end
	 if string.find(l,"�㲻���������˷�ʱ�侫����") or string.find(l,"ʵս���鲻��") then
	     shutdown()
	     self:lingwu_skills()
	     return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:canwu_dodge51()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:canwu_dodge51()
		end
		local path="open door;n;e;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;open door;s",f)
	    return
	 end
   end)
end

function gumu:canwu_dodge101()  --��Ĺ������1 eastwall 51 ������2 westwall 100 5073
   world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 zhuo maque;yun jing;yun jingli")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)����ʵս���鲻�㣬�谭����ġ�.*��������$|^(> |)�㲻���������˷�ʱ�侫���ˡ�$",10)
	 if l==nil then
	    self:canwu_dodge101()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:canwu_dodge101()
	    return
	 end
	 if string.find(l,"�㲻���������˷�ʱ�侫����") then
	    shutdown()
		world.Execute("s;s;#5 zhuo maque")
		self:lingwu_skills()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:canwu_dodge101()
		end
		local path="out;open door;n;e;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;w;open door;s;enter",f)
	    return
	 end
   end)
end

function gumu:sleep(path,back_path,callback) --5050
   wait.make(function()
      local l,w=wait.regexp("^(> |)��һ�����������þ������棬�ûһ���ˡ�$|^(> |)��һ������������˯��̫Ƶ���������Ǻܺá�$",15)
	  if l==nil then
		 self:sleep(path,back_path,callback)
	     return
	  end
	  if string.find(l,"��һ������") then
	     world.Execute(back_path)
		 callback()
	     return
	  end
   end)
end

function gumu:zuobed() --5050 51
   world.Execute("#10 zuo bed;yun jing")
    wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)���Ǳ��û�ˣ������ټ�����ϰ��$|^(> |)�����Ů�ľ������൱���,���񴲲�����������ϰ�ڹ��ˡ�$",10)
	 if l==nil then
	    self:zuobed()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.8)
		self:zuobed()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:zuobed()
		end
		local path="sleep"
		world.Execute(path)
	    self:sleep(path,"ok",f)
	    return
	 end
	if string.find(l,"�����Ů�ľ������൱���") then
	    self:lingwu_skills()
	    return
	end
	   if string.find(l,"���Ǳ��û��") then
	    local f=function()
		   self:zuobed()
		end
		local b=busy.new()
		b.Next=function()
	       self:get_pots("n;w;w;out;up","d;enter;e;e;s",f)
		end
		b:check()
	    return
	 end
   end)
end

function gumu:yanxi_table() --5049 120
    world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 yanxi table;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|^(> |)���Ǳ��û�ˣ������ټ�����ϰ��$|^(> |)��������ϵĹ����о���һ������������ֵǮ��$|^(> |)����ʵս���鲻�㣬�谭����ġ�.*��������$",10)
	 if l==nil then
	    self:yanxi_table()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.5)
		self:yanxi_table()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:yanxi_table()
		end
		local path="w;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;e",f)
	    return
	 end
	 if string.find(l,"��������ϵĹ����о���һ��") then
	     world.Send("nuo qin")
		 self:yanxi_table()
	    return
	 end
	 if string.find(l,"����ʵս���鲻��") then
	    shutdown()
	    self:lingwu_skills()
	    return
	 end
	  if string.find(l,"���Ǳ��û��") then
	    local f=function()
		   self:yanxi_table()
		end
		local b=busy.new()
		b.Next=function()
	       self:get_pots("w;w;w;out;up","d;enter;e;e;e",f)
		end
		b:check()
	    return
	 end
   end)
end

function gumu:tanqin() --5049 51 force 120
    world.Execute("dazuo 100;dazuo 200;dazuo 300;dazuo 400")
   world.Execute("#10 tan qin;yun jing")
   wait.make(function()
     local l,w=wait.regexp("^(> |)�������������$|^(> |)���������˼����������������ö��ˡ�$|����ʵս���鲻�㣬�谭����ġ������ڹ���������",10)
	 if l==nil then
	    self:tanqin()
	    return
	 end
	 if string.find(l,"���������˼����������������ö���") then
	    wait.time(0.3)
		self:tanqin()
	    return
	 end
	 if string.find(l,"����ʵս���鲻��") then
	    shutdown()
		self:lingwu_skills()
	    return
	 end
	 if string.find(l,"�����������") then
	    local f=function()
		   self:tanqin()
		end
		local path="w;open door;s;sleep"
		world.Execute(path)
	    self:sleep(path,"open door;n;e",f)
	    return
	 end

   end)
end

function gumu:lingwu_skills()

   local level_literate
   local level_force
   local level_yunu
   local level_sword

  local lw=lingwu.new()
  lw.exps=tonumber(world.GetVariable("exps")) or 0
   lw.get_skills_end=function()
      level_literate=lw:get_skill("literate")
	  level_force=lw:get_skill("force")
	  level_yunu=lw:get_skill("yunu-xinjing")
	  level_sword=lw:get_skill("sword")
	  level_dodge=lw:get_skill("dodge")
	  level_parry=lw:get_skill("parry")
	  print(level_literate)
	  print(level_force)
	  print(level_yunu)
	  print(level_parry)
	  print(level_sword," ����")
	  print(level_dodge," �Ṧ")
	   print(lw.max_level," max_level")

	local work={}
	local w=walk.new()
	w.walkover=function()
	   work()
	end
    --��Ů�ľ� 51 120

		  --force 51  120
   if level_force<51 and level_force<lw.max_level then
       work=function() self:canwu_force() end
	   w:go(5063)
	   return
   end

   if level_yunu<51 and level_yunu<lw.max_level then
      work=function() self:zuobed() end
	  w:go(5048)
      return
   end

     --literate 150
   if level_literate<150 then
	   work=function() self:canwu_literate() end
	   w:go(5070)
	   return
   end
   --print(level_yunu," yunu max ",lw.max_level)
   if level_yunu<120 and level_yunu<lw.max_level then
      work=function() self:yanxi_table() end
	  w:go(5069)
      return
   end

   if level_force<=115 and level_force<lw.max_level then
       work=function() self:tanqin() end
	   w:go(5069)
      return
   end

  --sword 51 100
  if level_sword<51 and level_sword<lw.max_level then
      work=function()
      self:canwu_sword51()
	  end
	  w:go(5059)
      return
  end
  if level_sword<100 and level_sword<lw.max_level then
     work=function()
     self:canwu_sword101()
	 end
	 w:go(5073)
     return
  end
    --sword 51 100
  if level_dodge<51 and level_dodge<lw.max_level then
      work=function()
      self:canwu_dodge51()
	  end
	  w:go(5060)
      return
  end
  if level_dodge<101 and level_dodge<lw.max_level then
     work=function()
     self:canwu_dodge101()
	 end
	 w:go(5061)
     return
  end
  if level_parry<51 and level_parry<lw.max_level then
     work=function()
       self:canwu_parry51()
	 end
	 w:go(5063)
     return
  end
  if level_parry<101 and level_parry<lw.max_level then
     work=function()
       self:canwu_parry101()
	 end
	 w:go(5094)
     return
  end
    world.Send("unset ����") --������500
    process.neigong3()

   end

   lw:get_exps()
end

function gumu:leave()
--tang bed
--[[ local w=walk.new()
 w.walkover=function()
   world.Execute("tang bed;ban shiban;out;e;e;e;e;e;e;w;w;w;w;w;w;n;n;n;n;n;n;s;s;s;s;s;s")


   enter
tui guangai
tang guan
use fire
search
search
search
search
search
search
search
search
search
turn ao left
ti up
l map

> l ceiling
> l zi

walk down
wd
w
wu
nu
out
nw
n
n
e
e
se
s
s
s
s
s
s
e
n
 end
 w:go(5050)
 ����д��0-101��{e;e} ʯ�� read qiang (����Ǳ��)
�����ڹ�0-51����{w;w;n} ������ yanxi wall
�����ڹ�50-101����{e} ���� tan qin
��Ů�ľ�0-51����{s} ���� zuo bed (����Ǳ��)
��Ů�ľ�51-101����{e} ���� nuo qin;yanxi table (����Ǳ��)
�����м�0-51����{w;w;n} ������ yanxi ground
�����м�51-101����{w;w;out;s} ���� yao tree
�����Ṧ0-51����{w;open door;s;} ʯ�� zhuo maque
�����Ṧ51-101����{w;open door;s;enter} ʯ�� zhuo maque
��������0-51����{w;n} ������ xiulian eastwall
��������51-101����{w;n;tui eastwall;enter} ������ xiulian westwall
����ȭ��0-51����{w;n} ������ xiulian backwall
����ȭ��51-101����{w;n;tui eastwall;enter} ������ xiulian frontwall
��Ůȭ����{w;w;out;n} ��԰ zhao quan (Ҫ�����ȭ��51��)
��Ů����{w;w;n} ������  yanxi top   (Ҫ�� dodge>20)
��Ů���Ľ�����{w;n;tui eastwall:enter} ������ yanxi top (Ҫ���������30��)
�����Ʒ�0-51����{w;n} ������ xiulian frontwall
�����Ʒ�51-101����{w;n;tui eastwall:enter} ������ xiulian backwall
ȫ�潣����{w;n} ������ yanxi top (Ҫ���������30��)
���޵���: {w;s;enter;s} ʯ�� zhuo maque *ֻ���е���

 ]]
end

