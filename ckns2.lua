nongsang={
  new=function()
     ns={}
	  setmetatable(ns,{__index=nongsang})
	 return ns
  end,
}

local sign_txt=""
local number=1
    if not IsPluginInstalled("4e38a3aade8c0892c5f19e86") then
		LoadPlugin(GetInfo(60) .. "escape.xml")
	end
	--print("�����")
	EnablePlugin("4e38a3aade8c0892c5f19e86", false)

function nongsang:lookSign()

	EnablePlugin("4e38a3aade8c0892c5f19e86", true)
    --world.AddTriggerEx ("sign0", "(.*)", "sign_add(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 151)
	world.AddTriggerEx ("sign1", "(.*)\\^\\>", "nongsang:sign_end(\"%1\")", trigger_flag.RegularExpression + trigger_flag.Replace, custom_colour.NoChange, 0, "", "", 12, 150)

	sign_txt=""

	--world.EnableTrigger("sign0",true)
    world.EnableTrigger("sign1",true)
    Send("l sign")
end

local working=nil
function nongsang:caikuangrukou()
   local w=walk.new()
   w.walkover=function()
      world.Send("wu")
	   local seed=math.random(3)
	   local dx={"northup","southup","westup"}
	   world.Send(dx[seed])
	   nongsang:lookSign()
	   working=function()
	      local sp=special_item.new()
		  sp.cooldown=function()
	         nongsang:caikuang_dig()
          end
		  sp:unwield_all()
	   end
	   local f=function()
		 world.Send("look")
	   end
	   f_wait(f,1)
   end
   w:go(724)
end

--[[
function test_nongsang(dx)
     world.Send(dx)
	working=function() nongsang(s,reward) end
	lookSign()
	local f=function()
		world.Send("look")
	end
	f_wait(f,1)
end]]

function nongsang:nongsangrukou(s,location,reward,dir)
   --print(location)
     local w=walk.new()
   w.walkover=function()
     if location=="nongtian" then
      world.Send("s")
	 else
      world.Send("n")
	 end
	  --world.Send("ne")
	  --world.Send("sw")
	  if dir==nil then
	     dir="se"
	  end
	  world.Send(dir)
	  --[[ local seed=math.random(4)
	   local dx={"east","west","north","south"}
	   world.Send(dx[seed])]]
	    working=function() nongsang:nongsang(s,location,reward,dir) end
	   nongsang:lookSign()
	   local f=function()
		 world.Send("look")
		 local f2=function()
		   world.Send("look")
		 end
		 f_wait(f2,3)
	   end
	   f_wait(f,1)
   end
   w:go(1091)
end

--1091
function nongsang:buy_fromxiaofan()
   wait.make(function()
      world.Send("list")
		world.Send("buy tieqiao")
		local l,w=wait.regexp("^(> |)����.*�ļ۸��.*����������һ(��|��)(.*)��$|^(> |)�ɿ�ʦ��˵��������⵰��һ�ߴ���ȥ����$",5)
		if l==nil then
		   nongsang:follow_xiaofan()
		   return --> ������ʮ���������ļ۸�Ӳɿ�ʦ������������һ�����¡�
		end
		if string.find(l,"��������") then
		   world.Send("follow none")
		   local b=busy.new()
		   b.Next=function()
		     nongsang:caikuangrukou()
		   end
		   b:check()
		   return
		end
		if string.find(l,"��⵰") then
		   local f=function()
		      nongsang:follow_xiaofan()
		   end
		   qu_gold(f,10,50)
		   return
		end

   end)
end

function nongsang:follow_xiaofan()
  world.Send("follow dali xiaofan")
  world.Send("follow shifu")
  world.Send("set follow")
  wait.make(function()
     local l,w=wait.regexp("^(> |)���������(.*)һ���ж���$|^(> |)���Ѿ��������ˡ�$|^(> |)�趨����������follow = \\\"YES\\\"$",5)
	 if l==nil then
	    nongsang:follow_xiaofan()
	    return
	 end
	 if string.find(l,"���������") or string.find(l,"���Ѿ���������") then
	    world.Send("say �����齣�ǹ�����������Ϊ����̯���ʹ���")
		nongsang:buy_fromxiaofan()
		return
	 end
	 if string.find(l,"�趨��������") then
		coroutine.resume(equipments.co)
	    return
	 end
  end)
end

function nongsang:buy_qiao()

   local sp=special_item.new()

	sp.check_items_over=function()
	   print("������")
	   local nums={}
		for index,item in pairs(sp.itemslistNum) do
            --print(index," index ",item," item")
	        if string.find(index,"����") then
			   nongsang:caikuangrukou()
			   return
			end
		end
		local rooms={}
        table.insert(rooms,76)
        table.insert(rooms,74)
        table.insert(rooms,97)
        table.insert(rooms,75)
        table.insert(rooms,87)
        table.insert(rooms,88)
        table.insert(rooms,73)
        table.insert(rooms,96)
		table.insert(rooms,100)
		table.insert(rooms,71)
		table.insert(rooms,94)
		table.insert(rooms,80)
	   table.insert(rooms,83)
	    table.insert(rooms,81)
		 table.insert(rooms,82)
		  table.insert(rooms,68)
		   table.insert(rooms,70)
		    table.insert(rooms,73)

   equipments.co=coroutine.create(function()
    for _,r in ipairs(rooms) do
      local w=walk.new()
	  w.walkover=function()
	    nongsang:follow_xiaofan()
	  end
	  w:go(r)
	  coroutine.yield()
    end
	nongsang:buy_qiao()
  end)
  coroutine.resume(equipments.co)
	end
	--print("1 tieiqiao 2 liandao 3 ���� ")
	local equip={}
	equip=Split("<����>����","|")
	sp:check_items(equip)

end

--[[
  �˵س������
        ��ͭ(Qingtong)
        ����(Shengtie)
        ����(Ruantie)
        ��ʯ(Lushi)
        ����ʯ(Liuhuashi)
        ����(Ruanyin)
        ����(Jintie)
        ��������(Shentie)
        ����(Xuantie)]]
function nongsang:caikuang_dig(index)
  if index==nil then
    index=1
  end
  local mine={"xuantie","shentie","jintie","ruanyin","liuhuashi","lushi","ruantie","shengtie","qingtong"}
  local id=mine[index]
  world.Send("wield tieqiao")
  world.Send("caikuang "..id)
  wait.make(function()
    local l,w=wait.regexp("^(> |)���Ѿ�������������Է��ֵĿ�ʯ�������ˣ�$|^(> |)�����װ�����²��ܲɿ�$|^(> |)��Ĳɿ��ܲ�����$|^(> |)�����˺ó�һ��ʱ�䣬�����ҵ�һ��(.*)��$|^(> |)�����˺ó�һ��ʱ�䣬����ʲô��û�еõ���$|^(> |)��ողɿ�������о��������ۣ�|^(> |)ʲô��$",10)
	if l==nil then
	   nongsang:caikuang_dig(index)
	   return
	end
	if string.find(l,"���Ѿ�������������Է��ֵĿ�ʯ��������") then
	   world.Execute("out;ed")
	   local seed=math.random(3)
	   local dx={"northup","southup","westup"}
	   world.Send(dx[seed])
	   return
	end
	if string.find(l,"��Ĳɿ��ܲ���") then
	     index=index+1
		 nongsang:caikuang_dig(index)
	    return
	end
	if string.find(l,"�����˺ó�һ��ʱ�䣬�����ҵ�һ��") then
	   if index>=4 then
	      wait.time(1)
		  world.Send("drop "..id)

	   end
	    nongsang:caikuang_dig(index)
	   return
	end
	if string.find(l,"��ողɿ����") then
	   wait.time(1)
	   nongsang:caikuang_dig(index)
	   return
	end
    if string.find(l,"�����װ�����²��ܲɿ�") then
	    world.Execute("out;ed;ed")
        nongsang:buy_qiao()
		return
	end
	if string.find(l,"�����˺ó�һ��ʱ��") then
	   nongsang:caikuang_dig(index)
	   return
	end
	if string.find(l,"ʲô") then

	  local _R=Room.new()
      _R.CatchEnd=function()
	     if _R.roomname=="�ɿ�" then
		     wait.time(1)
		    nongsang:caikuang_dig(index)
		 else
		    nongsang:buy_qiao()
		 end
      end
       _R:CatchStart()
	   return
	end

  end)
end

function nongsang:leave_nongtian(seed,location,reward,dx)
  --[[> �㿪ʼ����������......
   �������ֺ��ˣ�
   > �������Ե�ˮ��������Щˮ����ʼ����......
   > ���۵���ͷ�󺹣����㽽���˵ء�
   �������Եķ��Ͽ������Щ���ϣ���ʼʩ��......
   > ���۵���ͷ�󺹣����������ʩ�ʵĹ�����
   ���˸߲��ҵĿ�ʼ�ո�......]]
		world.Send("out")
		print(dx," dx")
        if dx=="se" then
		  world.Send("nw")
		  nongsang:nongsangrukou(s,location,reward,"sw")
		elseif dx=="ne" then
		  world.Send("sw")
		  nongsang:nongsangrukou(s,location,reward,"se")
		elseif dx=="sw" then
		  world.Send("ne")
		  nongsang:nongsangrukou(s,location,reward,"ne")
		end
end

function nongsang:leave_sanglin(seed,location,reward,dx)

		world.Send("out")
		print(dx," dx")
        if dx=="se" then
		  world.Send("nw")
		  nongsang:nongsangrukou(s,location,reward,"sw")
		elseif dx=="sw" then
		  world.Send("ne")
		  nongsang:nongsangrukou(s,location,reward,"nw")
		elseif dx=="nw" then
		  world.Send("se")
		  nongsang:nongsangrukou(s,location,reward,"se")
		end
end
--|^(> |)�����װ�����������ո$
function nongsang:zhongdi_work(seed,location,reward,dx)
   wait.make(function()
     local l,w=wait.regexp("^(> |)�㿪ʼ����������\\.\\.\\.\\.\\.\\.$$|^(> |)�������Ե�ˮ��������Щˮ����ʼ����\\.\\.\\.\\.\\.\\.$|^(> |)�������Եķ��Ͽ������Щ���ϣ���ʼʩ��\\.\\.\\.\\.\\.\\.$|^(> |)���˸߲��ҵĿ�ʼ�ո�\\.\\.\\.\\.\\.\\.$|^(> |)���ڻ�û�е��ո���ء�$|^(> |)�㻹û�п�ʼ��ֲ���ո�ʲô��$|^(> |)�趨����������action = \\\"ũɣ\\\"$",5)
	  if l==nil then
	     nongsang:zhongdi(seed,location,reward,dx)
	     return
	  end
	  if string.find(l,"�㿪ʼ����������") or string.find(l,"��ʼ����.") or string.find(l,"��ʼʩ��")  then
		 local b=busy.new()
		 b.interval=0.8
		 b.Next=function()
		     nongsang:leave_nongtian(seed,location,reward,dx)
		 end
		 b:check()
		 return
	  end
	  if string.find(l,"���ڻ�û�е��ո����") then
	     local f=function()
		    nongsang:leave_nongtian(seed,location,reward,dx)
		 end
		 f_wait(f,2)
	     return
	  end

	  if string.find(l,"�㻹û�п�ʼ��ֲ") then
	     world.Send("out")
	     nongsang:getNongsang()
	     return
	  end
	  if string.find(l,"�趨����������action") then
	     --nongsangrukou(seed,location,reward,dx)
		 nongsang:getNongsang()
	     return
	  end
	  if string.find(l,"��ʼ�ո�") then
         wait.time(8)
	     local b=busy.new()
		 b.interval=0.8
		 b.Next=function()

		    world.Execute("#12 drop "..reward)
		    nongsang:nongsang(seed,location,reward,dx)
		 end
		 b:check()
		 return
	  end
   end)
end

function nongsang:yangcan_work(seed,location,reward,dx)
   wait.make(function()
     local l,w=wait.regexp("^(> |)�㿪ʼ�ò��ѷ�����\\.\\.\\.\\.\\.\\.$$|^(> |)�㿪ʼ��ϸ����ɨ�����õ���¨\\.\\.\\.\\.\\.\\.$|^(> |)�㿪ʼ��ɣҶ����ιʳ\\.\\.\\.\\.\\.\\.$|^(> |)�㿪ʼС������ĴӲϼ��г�ȡ��˿\\.\\.\\.\\.\\.\\.$|^(> |)���ڲϻ�û�п�ʼ����ء�$|^(> |)�㻹û�п�ʼ���ϣ���ʲô˿����$|^(> |)�趨����������action = \\\"ũɣ\\\"$",5)
	  if l==nil then
	     nongsang:zhongdi(seed,location,reward,dx)
	     return
	  end
	  if string.find(l,"�㿪ʼ�ò��ѷ���") or string.find(l,"��ɨ����") or string.find(l,"ɣҶ����ιʳ")  then
		 local b=busy.new()
		 b.interval=0.8
		 b.Next=function()
		     nongsang:leave_sanglin(seed,location,reward,dx)
		 end
		 b:check()
		 return
	  end
	  if string.find(l,"���ڲϻ�û�п�ʼ�����") then
	     local f=function()
		    nongsang:leave_sanglin(seed,location,reward,dx)
		 end
		 f_wait(f,2)
	     return
	  end
	  if string.find(l,"�㻹û�п�ʼ���ϣ���ʲô˿��") then
	     world.Send("out")
	     nongsang:getNongsang()
	     return
	  end
	  if string.find(l,"�趨����������action") then
	     --nongsangrukou(seed,location,reward,dx)
		 nongsang:getNongsang()
	     return
	  end
	  if string.find(l,"�ϼ��г�ȡ��˿") then
         wait.time(8)
	     local b=busy.new()
		 b.interval=0.8
		 b.Next=function()

		    world.Execute("#12 drop "..reward)
		    nongsang:nongsang(seed,location,reward,dx)
		 end
		 b:check()
		 return
	  end
   end)
end

function nongsang:nongsang(seed,location,reward,dx)
   print("��ʼũɣ")
   --nongsang:zhongzhi()
   --�����װ�����²�����ֲ��
   --��ø�������ֲ������ʩ���ˡ�
   --�������Ե�ˮ��������Щˮ����ʼ����......
   --> ��ø�������ֲ�����ｽˮ�ˡ�
   --�����װ�����²���ʩ�ʡ�
   --������ֲ��ֲ���Ѿ����죬����Կ�ʼ�ո��ˡ�
   --�����װ�����������ո
   --���ܹ��ջ���ʮ�����顣
	local sp=special_item.new()
	sp.cooldown=function()
	  if location=="nongtian" then
        world.Execute("wield tieqiao;zhongzhi zhongzi")
	    world.Execute("unwield tieqiao;jiaoshui")
	    world.Execute("wield tieqiao;shifei")
	    world.Execute("unwield tieqiao;wield lian dao;shouge")
	    world.Send("set action ũɣ")
		nongsang:zhongdi_work(seed,location,reward,dx)
	  else
	      world.Execute("yangcan "..seed)
		  world.Execute("weishi")
		  world.Execute("wield saoba;qingsao")
		  world.Execute("unwield saoba;wield jiandao;chousi")
		  world.Send("set action ũɣ")
		  nongsang:yangcan_work(seed,location,reward,dx)
	  end



   end
   sp:unwield_all()
end

function nongsang:signResult(dx)
   world.Send(dx)
   working()
end

function nongsang:sign_end(line)
   --world.EnableTrigger("sign0",false)
   world.EnableTrigger("sign1",false)
   print("����")
   sign_txt=line
    EnablePlugin("4e38a3aade8c0892c5f19e86", false)
    --print(sign_txt,"����!!!")
	nongsang:escapeSign(sign_txt)
end
local look_count=0
--start middle  end
function nongsang:escapeSign(txt)
	local arrow=1
    if string.find(txt,"��ע����ĸ���ͷ��") then
	   arrow=4
	elseif string.find(txt,"��ע���������ͷ��") then
	   arrow=3
	elseif string.find(txt,"��ע��ڶ�����ͷ��") then
	   arrow=2
	elseif string.find(txt,"��ע���һ����ͷ��") then
	   arrow=1
	elseif string.find(txt,"��ע�����м�ͷ��") then
	   arrow=1
	end
  --local txt="^^^^^^  [[[[[[[[[[[[[[      ]]]]]]]]]]]]]]]]]]]]          **  [[[[[[ [[[[[[[[[[[[[[[[[[  ]]]]]]]]]]]]]]]]]]]]      |           [[  [[[[[[[[[[[         ]]]]]]]]]]]]]]]]]]]]*   *     \[[[[[[[[[ [[[[[[[[--------    ]]]]]]]]]]]]]]]]]]]]  ****--[[[[[[[[[[[["
  --local txt="��ע����ĸ���ͷ��^^^^^^   [[[[[[    **        ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[ [[[[[[[[[[[[[[[[    ]]]]]]]]]]]]]]]]]]]]      |         [[[[ [[[[[[[[[[[[[[[[[[[ ]]]]]]]]]]]]]]]]]]]]          |        [  [[[[[[[[[[[[[[[--   ]]]]]]]]]]]]]]]]]]]]   \---    ----[[[[[^^^   [[[[[[[[[[[[[[      ]]]]]]]]]]]]]]]]]]]]              [[[[[[ [[[[[[[[[[[[[[      ]]]]]]]]]]]]]]]]]]]]      /\      [[[[[[ [[[[[[[[[[[[[[[     ]]]]]]]]]]]]]]]]]]]]               [[[[[  [[[[[[[[[[[         ]]]]]]]]]]]]]]]]]]]]      \    [[[[[[[[[^^^^^^^^^   [[[[[[      *       ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[ [[[[[[[|            ]]]]]]]]]]]]]]]]]]]]       [[[[[[[[[[[[[ [[[[[[    \/     |  ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[  [[[[[[[[[[[[[[[[[   ]]]]]]]]]]]]]]]]]]]]                 [[[^^^^^^^^   [[[[[[[[[[[[[[[[    ]]]]]]]]]]]]]]]]]]]]                [[[[ [[[[[[[[[[          ]]]]]]]]]]]]]]]]]]]]          [[[[[[[[[[ [[[[[[[[            ]]]]]]]]]]]]]]]]]]]]        [[[[[[[[[[[[  [[[[[[[[[[[[        ]]]]]]]]]]]]]]]]]]]]            [[[[[[[[^^^^^^^^   [[[[     *******    ]]]]]]]]]]]]]]]]]]]]    [[[[[[[[[[[[[[[[ [[[[[[[[[[[[[[[[    ]]]]]]]]]]]]]]]]]]]]       |        [[[[ [[[[[[[[[[[[ \\     ]]]]]]]]]]]]]]]]]]]]      //   |[[[[[[[[  [[[   *             ]]]]]]]]]]]]]]]]]]]]   [[[[[[[[[[[[[[[[[^^^   [[[[[[              ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[ [[[[[[[[[[[[[[[[[   ]]]]]]]]]]]]]]]]]]]]    \ |  //      [[[ [[--      |     --  ]]]]]]]]]]]]]]]]]]]]  [[[[[[[[[[[[[[[[[[  [[[[\  ----         ]]]]]]]]]]]]]]]]]]]]    [[[[[[[[[[[[[[[[^   [[[[[[              ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[ [[[[[\\//           ]]]]]]]]]]]]]]]]]]]]     [[[[[[[[[[[[[[[ [[[[[[[   |         ]]]]]]]]]]]]]]]]]]]]       [[[[[[[[[[[[[  [[[[[[              ]]]]]]]]]]]]]]]]]]]]     \[[[[[[[[[[[[[[^^^^^^^   [[[[[[[[[[[[[**     ]]]]]]]]]]]]]]]]]]]]  *******    [[[[[[[ [[[[[  |            ]]]]]]]]]]]]]]]]]]]]     [[[[[[[[[[[[[[[ [[[[[   // \\    |  ]]]]]]]]]]]]]]]]]]]]  ---[[[[[[[[[[[[[[[         **           ]]]]]]]]]]]]]]]]]]]][[[[[[[[[[[[[[[[[[[[^^^^   [[                  ]]]]]]]]]]]]]]]]]]]]  [[[[[[[[[[[[[[[[[[ [[[[[[[[[[[[[       ]]]]]]]]]]]]]]]]]]]]       |     [[[[[[[ [[[[[[              ]]]]]]]]]]]]]]]]]]]]      [[[[[[[[[[[[[[  [[[[[[[[[[[[[[[[    ]]]]]]]]]]]]]]]]]]]]                [[[[^^^^   [[[[[       **      ]]]]]]]]]]]]]]]]]]]]     [[[[[[[[[[[[[[[ [[[[   |            ]]]]]]]]]]]]]]]]]]]]    [[[[[[[[[[[[[[[[ [[[[[[[[[ |    \    ]]]]]]]]]]]]]]]]]]]]     /   [[[[[[[[[[[  [   **              ]]]]]]]]]]]]]]]]]]]] [[[[[[[[[[[[[[[[[[[^^^^^^"
  --local txt="^^^^ [[[[[[[[[[[[[[[[[   ]]]]]]]]]]]]]]]]]]]]                 [[[^ [[[[[[[[[[[[        ]]]]]]]]]]]]]]]]]]]]      **    [[[[[[[[^ [[[[[[[[[[[         ]]]]]]]]]]]]]]]]]]]]    **     [[[[[[[[[^^^^^ [[[[[[[[[           ]]]]]]]]]]]]]]]]]]]]         [[[[[[[[[[[^^^^^ [[[[[[[[[[[[[[[     ]]]]]]]]]]]]]]]]]]]]   \\\\        [[[[[^ [[[[[[[[[[[[[[[[[[[ ]]]]]]]]]]]]]]]]]]]]     \\\           [^ [[[[[[[[[[[[[[[[[[  ]]]]]]]]]]]]]]]]]]]]       \          [[^^^^^^^^^^^ [[[[[[[[[[[[[[[[[[[ ]]]]]]]]]]]]]]]]]]]]                   [^ [[[[                ]]]]]]]]]]]]]]]]]]]]    [[[[[[[[[[[[[[[[^^^^^ [[[[[[[[[[[[****    ]]]]]]]]]]]]]]]]]]]]  \\\*******[[[[[[[[^^^^"
    local signs = {
		east={"******--*****..*", "-----------/", "*******    **", "**********###*", "***********/", "------     **"},
		south={"*## *  *#", "***  **", "\\  |     --", "\\ |  //", "\\   * //", "* | *"},
		west={"%%%%%%%%%%%%%%%%", "\\\\**************", "\\---    ------", "****----------", "\\\\\\***********", "** //   ------"},
		north={"*#*#*#**", "---   // \\\\    |", "**  ** *\\\\", "#/  *#    #\\", "/*** \\\\**      **", "***  *        \\"},
	}
  local i
  local row=0
  local col=0
  local lower=false
  local hight=false
  local L_value=""
  local H_value=""
  local s_count=0
  local tb={}
  for i=1,4 do
    tb[i]={}
	for j=1,10 do
	  tb[i][j]=nil
	end
  end
   for i=1,string.len(txt) do
      local w=string.sub(txt,i,i)
      if w=="^" then
	      row=row+1
		 col=0
		 s_count=0
	  elseif w=="U" then
	     row=row-1
	  elseif w=="[" then
	      if lower==false and hight==false then
		     lower=true
			  s_count=1
		   elseif lower==true then
		      s_count=s_count+1
		   elseif hight==true then --��β
		       s_count=s_count+1
              if s_count>=20 then
		         hight=false
			     lower=false
		         local value=H_value..L_value
				 H_value=""
				 L_value=""
				 col=col+1
                --[[ value = string.gsub(value, "%*", "%%*")
				  value = string.gsub(value, "%-", "%%-")
				  value = string.gsub(value, "%.", "%%.")]]
                   --value = string.gsub(value, "\\", "\\\\")
				 value=Trim(value)
				 tb[col][row]=value
				 if col==arrow then -- Ŀ����
                   for _,v in ipairs(signs.east) do
				    --print(v)
					if v==value then
					  print("���    east")
					  nongsang:signResult("east")
					  return
					end
				   end
				   for _,v in ipairs(signs.west) do
				    --print("west:",v)
					if v==value then
					  print("���    west����������")
					  nongsang:signResult("west")
					  return
					end
				   end

				  for _,v in ipairs(signs.south) do
				    --print(v)
					if v==value then
					  print("���    south")
					  nongsang:signResult("south")
					  return
					end
				   end

				  for _,v in ipairs(signs.north) do
				    --print(v)
					if v==value then
					  print("���    north")
					  nongsang:signResult("north")
					  return
					end
				  end

				end
			  end
		  end
	  elseif w=="]" then
		   lower=false
		   hight=true
	  else

	      if lower==true then
		     L_value=L_value..w
		  end
		  if hight==true then
		    H_value=H_value..w
		  end
	  end
	  --print(w)
   end
   if look_count<6 then
      look_count=look_count+1
   print("����!!!�ٿ�һ�Σ���")
   nongsang:lookSign()
	local f=function()
		 world.Send("look")
		 local f2=function() world.Send("look") end
		 f_wait(f2,3)
	end
	f_wait(f,1)
   else
      look_count=0
       --getNongsang()
	   working()

   end
end

function nongsang:nongsang_checkItem(seed,location,reward)
   local sp=special_item.new()

	sp.check_items_over=function()
	   print("������")
	   local nums={}
		for index,item in pairs(sp.itemslistNum) do
            --print(index," index ",item," item")
			if string.find(index,"����") then
			    nums[3]=item
			elseif string.find(index,"����") then
			    nums[2]=item
			elseif string.find(index,"����") then
                nums[1]=item
			elseif string.find(index,"����") then
			    nums[4]=item
			elseif string.find(index,"ɨ��") then
			    nums[5]=item
			elseif string.find(index,"����") then
				nums[6]=item
			end
		end
		nongsang:start_Nongsang(seed,location,reward,nums)
	end
	--print("1 tieiqiao 2 liandao 3 ���� ")
	local equip={}
	equip=Split("<����>����&6|<����>����|<����>����|<����>����&6|<����>ɨ��|<����>����","|")
	sp:check_items(equip)
end

--���Զ���������ʮ����ͭǮ�ļ۸��������������������һ���������ӡ�
local buy_count=0
function nongsang:buy_frompopo(seed,location,reward,tools_num)
    buy_count=buy_count+1
    local seed_num=tools_num[1] or 0
   local tieqiao_num=tools_num[2] or 0
   local liandao_num=tools_num[3] or 0
   local canzi_num=tools_num[4] or 0
   local saoba_num=tools_num[5] or 0
   local jiandao_num=tools_num[6] or 0
     print("seed:",seed_num," tieqiao:",tieqiao_num," liandao:",liandao_num)

	  print("canzi:",canzi_num," saobaqiao:",saoba_num," jiandao:",jiandao_num)
   wait.make(function()
      world.Send("list")
		local tool=""
		if tieqiao_num==0 then
		   tool="tieqiao"
		elseif liandao_num==0 then
		    tool="liandao"
		elseif seed_num<=6 then
		    tool=seed
		end
		world.Send("buy "..tool)
		local l,w=wait.regexp("^(> |)����.*�ļ۸��.*����������һ(��|��|��)(.*)��$|^(> |)��������˵��������⵰��һ�ߴ���ȥ����$|^(> |)ʲô��$",5)
		if l==nil then
		   if buy_count>6 then
		      buy_count=0
			  nongsang:getNongsang()
		   else
		     nongsang:buy_frompopo(seed,location,reward,tools_num)
		   end
		   return --> ������ʮ���������ļ۸�Ӳɿ�ʦ������������һ�����¡�
		end
		if string.find(l,"ʲô") then
		    nongsang:follow_popo(seed,location,reward,tools_num)
		    return
		end
		if string.find(l,"��������") then
		   buy_count=0
		   print(w[2],w[3])
		   local new_num={}

		   if tool=="tieqiao" then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num+1
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num
		   elseif tool=="liandao" then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num+1
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num
		    elseif tool=="jiandao" then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num+1
		    elseif tool=="saoba" then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num+1
			  new_num[6]=jiandao_num
		   elseif tool==seed and string.find(seed,"zhongzi") then
		      new_num[1]=seed_num+1
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num
			  if new_num[1]>6 then
			     local b=busy.new()
				 b.Next=function()
				 nongsang:nongsangrukou(seed,location,reward)
				 end
				 b:check()
			     return
			  end
		   elseif tool==seed and string.find(seed,"can zi") then
		      new_num[1]=seed_num
			  new_num[2]=tieqiao_num
		      new_num[3]=liandao_num
			  new_num[4]=canzi_num+1
			  new_num[5]=saoba_num
			  new_num[6]=jiandao_num
			  if new_num[4]>6 then
			   local b=busy.new()
			    b.Next=function()
				 nongsang:nongsangrukou(seed,location,reward)
				 end
				 b:check()
			     return
			  end
		   end
		   nongsang:buy_frompopo(seed,location,reward,new_num)
		   return
		end
		if string.find(l,"��⵰") then
		   world.Send("follow none")
		   local f=function()
		      follow_popo(seed,location,reward,tools_num)
		   end
		   qu_gold(f,10,50)
		   return
		end

   end)
end

function nongsang:follow_popo(seed,location,reward,tools_num)
   world.Send("follow popo")
   world.Send("set follow")
     wait.make(function()
     local l,w=wait.regexp("^(> |)���������(.*)һ���ж���$|^(> |)���Ѿ��������ˡ�$|^(> |)�趨����������follow = \\\"YES\\\"$",5)
	 if l==nil then
	    nongsang:follow_popo(seed,location,reward,tools_num)
	    return
	 end
	 if string.find(l,"���������") or string.find(l,"���Ѿ���������") then
	    world.Send("say �����齣�ǹ�����������Ϊ����̯���ʹ���")
        nongsang:buy_frompopo(seed,location,reward,tools_num)
		return
	 end
	 if string.find(l,"�趨��������") then
		coroutine.resume(equipments.co)
	    return
	 end
   end)
end

function nongsang:start_Nongsang(seed,location,reward,tools_num)
 local seed_num=tools_num[1] or 0
   local tieqiao_num=tools_num[2] or 0
   local liandao_num=tools_num[3] or 0
    print("seed:",seed_num," tieqiao:",tieqiao_num," liandao:",liandao_num)
   if  seed_num>=6 and tieqiao_num>=1 and liandao_num>=1 then
       nongsang:nongsangrukou(seed,location,reward)
       return
   end

       local rooms={}
   table.insert(rooms,920)
   table.insert(rooms,918)
   table.insert(rooms,919)
   table.insert(rooms,912)
   table.insert(rooms,1087)
   table.insert(rooms,913)
   table.insert(rooms,914)
   table.insert(rooms,915)
   table.insert(rooms,911)
    table.insert(rooms,921)
	 table.insert(rooms,922)
	  table.insert(rooms,924)
	   table.insert(rooms,890)
	    table.insert(rooms,891)
		table.insert(rooms,927)
		 table.insert(rooms,901)
		  table.insert(rooms,1541)
		  table.insert(rooms,911)

   equipments.co=coroutine.create(function()
    for _,r in ipairs(rooms) do
      local w=walk.new()
	  w.walkover=function()
	    nongsang:follow_popo(seed,location,reward,tools_num)
	  end
	  w:go(r)
	  coroutine.yield()
    end
    print("�ߵ���")
	local f=function()
	 nongsang:start_Nongsang(seed,location,reward,tools_num)
	end
	f_wait(f,3)
  end)
  coroutine.resume(equipments.co)
end

function nongsang:getNongsang()
    local lw=lingwu:new()
      lw.get_skills_end=function()
	      local level = lw:get_skill("nongsang")
	  if level < 40 then
		nongsang:nongsang_checkItem("mianhua zhongzi", "nongtian", "mian hua")
	   elseif level < 80 then
		nongsang:nongsang_checkItem("yama zhongzi", "nongtian", "ya ma")
	   elseif level < 120 then
		nongsang:nongsang_checkItem("dama zhongzi", "nongtian", "da ma")
	   elseif level < 170 then
		nongsang:nongsang_checkItem("zhuma zhongzi", "nongtian", "zhu ma")
	   elseif level < 220 then
	     nongsang:nongsang_checkItem("zhuma zhongzi", "nongtian", "zhu ma")
		--nongsang_checkItem("can zi", "sanglin", "cansi")
	  elseif level < 270 then
	 	nongsang:nongsang_checkItem("mumian zhongzi", "nongtian", "mumianhua")
	  elseif level < 330 then
		nongsang:nongsang_checkItem("yucan zi", "sanglin", "yucansi")
	  elseif level < 390 then
		nongsang:nongsang_checkItem("bingcan zi", "sanglin", "bingcansi")
	  else
		nongsang:nongsang_checkItem("tiancan zi", "sanglin", "tiancansi")
	  end
	end
	lw:get_skills()
end
