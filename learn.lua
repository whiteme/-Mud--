
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
      --print(math.floor(i*i*i/10), " 等级",i)
	  if tonumber(exps)<math.floor(i*i*i/10) then
	    print("等级:",i)
	    return i
	  end
   end
end
--顾炎武说道：「你现在的学费是每次五十文铜钱，请备好零钱。」
function learn:cost(cmd,callback)
  world.Execute(cmd)
  wait.make(function()
    local l,w=wait.regexp("^(> |)顾炎武说道：「你现在的学费是每次(.*)，请备好零钱。」",5)
	if l==nil then
	   self:cost(cmd,callback)
	   return
	end
	if string.find(l,"请备好零钱") then
	   --顾炎武说道：「你现在的学费是每次一锭黄金，请备好零钱。」
	   local costing=w[2]
	   local num=string.sub(costing,1,-7)
	   local n=ChineseNum(num)
	   local money=1
	   if string.find(costing,"黄金") then
	      money=1
	   else
	      money=0.01
	   end
	   local n=n*200*money
	   if n>800 then
	      n=800
	   end
       print(n,"数量")
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
--学就只能学的这里了，剩下的要靠你自己练毒了。
--
--空手时无法练玉箫剑法。你开始听取黄药师反复的指导，对「凤舞九天」这一招进行苦思。
function learn:ExecuteCmd(cmd)

  wait.make(function()
 local l,w=wait.regexp("^(> |)学就只能学的这里了.*$|^(> |)你不能再提高.*$|^(> |)也许是缺乏实战经验，你对.*的回答总是无法领会。$|^(> |)你开始听取.*，对.*进行苦思。|^(> |)你听了.*的指导，似乎有些心得。$|^(> |)你的潜能不足。$|^(> |)你没有这么多潜能来学习，没有办法再成长了。$|^(> |)你今天太累了，结果什么也没有学到。$|^(> |)你现在学习一次所需要的费用是.*，你身上带的零钱不够了。$|^(> |)私塾先生说道：您太客气了，这怎么敢当？$|^(> |)这项技能你的程度已经不输你师父了。$|^(> |)你使用的武器不对。$|^(> |).*必须空手.*$|^(> |)你要向谁求教？$|^(> |)你现在的学费是每次.*。你的钱不够！$|^(> |)这项技能你已经无法通过学习来提高了。$|^(> |)你听了丁典的指点，可是还是不能理解。$|^(> |)你听了丁典的指点，对神照经的奥妙似乎有些心得。$|^(> |)空手时无法练.*。$|^(> |)学.*时手里不能拿武器。$|^(> |)你身上没有这样东西。$|你对.*的理解不够，阻碍了你的.*的修炼。$|^(> |)这项技能你恐怕必须找别人学了。$|^(> |).*的脸色有点难堪，似乎是不想传授你这样功夫。$|^.*须空手。$|^(> |)你潜能不够，已经用完了。$|^(> |)由于实战经验不足，阻碍了你的.*|^(> |)你的.*不够，无法领会更高深的.*$|^(> |)你必须先找一.*$|^(> |)你的基本功火候未到，必须先打好基础才能继续提高。$|^(> |)你的潜能已经用完了，再怎么读也没用。$|^(> |)你没有使用的武器。$|^(> |)顾炎武对着你端详了一番道：“你因先天所制，已无法再进修更高深的学问了。”$|^(> |)这里没有这个人。$|^(> |)成高道长突然叹息道：「你真是一方顽石，顽石不可化也。我看你是很难开窍了……」$|^(> |)成高道长赶紧捂住腰包，对你哀求道：“.*您可千万别搞错了，贫道穷得响叮当呀！ 这腰包看起来鼓鼓的，其实里面可都是树叶子呀！”$|^(> |)成高道长漫不经心的“嗯”了一声，似乎根本没在听你说什么。$|^(> |)你的基本内功火候太浅。$|^(> |)你觉得对太极拳理还不够理解，无法继续练习太极拳。$|^(> |)你的邪气太少了。$|^(> |)你的侠义正气太低了，还好意思学习这华山气功。$|^(> |)你的破玉拳太弱，无法学习到华山剑法的精髓。$|^(> |)你手上的武器不能用来练.*。$|^(> |)空了手.*$|^(> |)你必须先找一条鞭子才能练鞭法。$|^(> |)空手方能练习美女拳法。$|^(> |)你必须先找一条鞭子才能练鞭法。$|^(> |)空手方能练习.*|^(> |)你不能再学习琴棋书画了。$|^(> |)练天山六阳掌必须空掌。$|^(> |)成高道长说道：「这个是这样的，那个是那样的，你的说法也是很有道理的\\.\\.\\.\\.\\.\\%\\^\\%\\$\\^\\%\\&\\^\\^」$",self.timeout)
     if l==nil then
		 self:start_success()
		return
     end
	 if string.find(l,"无法继续练习太极拳") then
	    world.Send("ask zhang about 太极拳理")
	    local f=function() self:ExecuteCmd() end
		f_wait(f,self.interval)
	    return
	 end
     if string.find(l,"必须先打好基础才能继续提高") or string.find(l,"你不能再学习琴棋书画了") or string.find(l,"无法领会") or string.find(l,"由于实战经验不足") or string.find(l,"也许是缺乏实战经验") or string.find(l,"你不能再提高") or string.find(l,"这项技能你已经无法通过学习来提高了") or string.find(l,"理解不够") or string.find(l,"似乎是不想传授你这样功夫") or string.find(l,"学就只能学的这里了") or string.find(l,"你的基本内功火候太浅") or string.find(l,"你的邪气太少了") or string.find(l,"你的侠义正气太低了") or string.find(l,"无法学习到华山剑法的精髓") then
		local f=function() self.start_failure(1) end
        print "也许是缺乏实战经验"
		f_wait(f,self.interval)
		return
     end
     if string.find(l,"似乎有些心得。") or string.find(l,"你开始听取") or string.find(l,"你听了丁典的指点，对神照经的奥妙似乎有些心得") or string.find(l,"你的说法也是很有道理的") then
	    local f=function() self:start_success() end
        print "成功"
		f_wait(f,self.interval)
		return
     end
      if string.find(l,"似乎根本没在听你说什么") or string.find(l,"你的潜能不足。") or string.find(l,"你潜能不够") or string.find(l,"你没有这么多潜能来学习，没有办法再成长了") or string.find(l,"你听了丁典的指点，可是还是不能理解") or string.find(l,"你的潜能已经用完") then
         --print("你捡起了一柄"..w[1])
		 print("你的潜能不足。")
		 local f=function() self.start_failure(102) end
		 f_wait(f,self.interval)
		 return
     end
	 if string.find(l,"你身上没有这样东西") then
	     self.wield_weapon=false
         self:ExecuteCmd(cmd)
		 return
	 end
	if string.find(l,"你今天太累了") then
         --print("你捡起了一柄"..w[1])
		 print("你今天太累了")
		 local f=function() self.start_failure(401) end
		 f_wait(f,self.interval)
		 return
     end
	 --你现在的学费是每次二十五两白银。你的钱不够！
	if string.find(l,"你身上带的零钱不够了") or string.find(l,"私塾先生说道：您太客气了，这怎么敢当？") or string.find(l,"你现在的学费是每次.*。你的钱不够！") or string.find(l,"成高道长赶紧捂住腰包") then
         --print("你捡起了一柄"..w[1])
		 print("你身上带的零钱不够了")
		 local f=function() self.start_failure(101) end
		 f_wait(f,self.interval)
		 return
     end

	if string.find(l,"这项技能你的程度已经不输你师父了") or string.find(l,"这项技能你恐怕必须找别人学了") or string.find(l,"你必须先找") then
         --print("你捡起了一柄"..w[1])
		 print("这项技能你的程度已经不输你师父了。")
		 local f=function() self.start_failure(201) end
		 f_wait(f,self.interval)
		 return
     end
	if string.find(l,"你必须先找一条鞭子") or string.find(l,"你使用的武器不对") or string.find(l,"空手时无法") or string.find(l,"你没有使用的武器") or string.find(l,"你手上的武器") or string.find(l,"才能练鞭法") then
         --print("你捡起了一柄"..w[1])
		 print("你使用的武器不对")
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
     end--学弹指神通必须空手或手持暗器。
	 if string.find(l,"须空手") or string.find(l,"手里不能拿武器") or string.find(l,"空了手") or string.find(l,"空手") or string.find(l,"空掌") then
	     print("空手")
		  local sp=special_item.new()
		  sp.cooldown=function()
             --local f=function() self.start_failure(203) end
		     -- f_wait(f,self.interval)
			 self:Execute(cmd)
          end
          sp:unwield_all()
	    return
	 end
if string.find(l,"你因先天所制，已无法再进修更高深的学问了") then
	 self.start_failure(920)
     return
end
	 if string.find(l,"你要向谁求教") or string.find(l,"这里没有这个人") then
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
	 if string.find(l,"你真是一方顽石，顽石不可化也。我看你是很难开窍了") then
	     local b=busy.new()
		 b.Next=function()
	        self:getyu()
		 end
		 b:check()
		 return
	 end
     --等待
    wait.time(self.timeout)
	print("继续")
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
  print("修炼内力")
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
			f=function() x:dazuo() end  --外壳
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
		  print("继续修炼")
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
--你听了丁典的指点，可是还是不能理解。
--973
function learn:go_ding() --教师地点

	if self.vip==true and self.run_vip==false then
	   self:vip_start()
	else
	  local place
	  place=self.master_place
	  local w
	  w=walk.new()
	  w.walkover=function()
	   print("学习开始")
	   --self.start()
       self:shenzhaojing()
	  end
	  w:go(973)
	end
end

function learn:shenzhaojing()
    local cmd
	cmd="ask ding about 神照经"

    --你听了丁典的指点，对神照经的奥妙似乎有些心得。
	--print(cmd)
	self:Execute(cmd)
	--learn.this=self
end

function learn:jyzj(skillname)
    local cmd
	cmd="read "..skillname
	self:Execute(cmd)
end

function learn:start() --开始学习

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

function learn:wuxing()  --特殊增加悟性
end

function learn:go() --教师地点
--"xiao":2748
	if self.vip==true and self.run_vip==false then
	   self:vip_start()
	else
	  local place
	  place=self.master_place
	  local w
	  w=walk.new()
	  w.walkover=function()
	   print("学习开始")
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


function learn:start_failure(error_id) --回调函数

end

function learn:rest() --回调函数

end


function learn:regenerate()
   -- regenerate_trigger()
    wait.make(function()
    world.Send("yun regenerate")
	local l,w=wait.regexp("^(> |)你的内力不够。$|^(> |)你深深吸了几口气，精神看起来好多了。$",5)
   if l==nil then
      --self.start_failure(-1)
	  self:regenerate()
	  return
   end
   if string.find(l,"内力不够") then
     print("learn",402)
     self.start_failure(402)
	 return
   end
   if string.find(l,"你深深吸了几口气，精神看起来好多了") then
     print("learn",403)
     self.start_failure(403)
	 return
   end
   wait.time(5)
   end)
end

function learn:start_success()  --回调函数
  --你听了.*的指导，似乎有些心得。
   self:start() --默认
end

function learn:Next() --下一个学习内容
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
瑛姑正盯着你看，不知道打些什么主意。
瑛姑说道：「现在是 二零一一年一月十九日十五时三十七分五十六秒。」
瑛姑说道：「你本周还可以使用鬼谷算术九小时五十七分四十二秒，现在开始计时了。」 --]]
function learn:vip_start()
   local w
   w=walk.new()
   w.walkover=function()
       wait.make(function()
          world.Send("ask ying gu about 鬼谷算术")
		  local l,w=wait.regexp("^(> |)瑛姑说道：「你本周还可以使用鬼谷算术(.*)，现在开始计时了。」$|(> |)对不起啊，目前鬼谷算术只对贵宾VIP用户开放强化学习功能。$|(> |)你不是正在研习修炼鬼谷算术中么？还不快点抓紧时间……$|^(> |)瑛姑说道：「你虽然天资聪慧，但是贪多嚼不烂，不能再冒进了，请下周再来询问吧。」$",10)
		  if l==nil then
            local f=function() self:vip_start() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"现在开始计时了") or string.find(l,"你不是正在研习修炼鬼谷算术中么") then
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
		  if string.find(l,"鬼谷算术只对贵宾VIP用户开放") or string.find(l,"你虽然天资聪慧，但是贪多嚼不烂")  then
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

--[[瑛姑正盯着你看，不知道打些什么主意。
瑛姑说道：「你的鬼谷算术开始时间是：二零一一年一月十九日十五时三十七分五十六秒。」
瑛姑说道：「            结束时间是：二零一一年一月十九日十五时三十九分五十六秒。」
瑛姑说道：「这次你一共修炼了：二分。」
瑛姑说道：「你本周还可以使用鬼谷算术九小时五十五分四十二秒。」--]]
function learn:vip_end()
  local w
   w=walk.new()
   w.walkover=function()
	  world.Send("ask ying gu about 结束")

	   local l,w=wait.regexp("^(> |)你向瑛姑打听有关『结束』的消息。$",10)
		  if l==nil then
            local f=function() self:vip_end() end
			f_wait(f,3)
	        return
          end
		  if string.find(l,"你向瑛姑打听有关『结束』的消息") then
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

function learn:AfterFinish() --回调函数

end

function learn:finish()
    print("vip状态:",self.vip)
	print("vip run:",self.run_vip)
	local b=busy.new()
	b.interval=0.5
	b.Next=function()
	  print(self.weapon," 携带武器")
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
你目前设定的环境变量有：
ask                  "YES"
busy                 "YES"
send                 "YES"
walk                 "off"
wimpycmd             "ks\pfm\hp"
]]
    local exps=world.GetVariable("exps")
	if exps~=nil then
	  self.limit=exps_skilllimit(exps)
	  print(self.limit,": 学习上限")
	end
   world.Send("set")
   world.Send("set look 1")
   wait.make(function()
     local l,w=wait.regexp("^(> |)设定环境变量：look \\= 1$|^(> |)skilllimit(.*)$",5)
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
		  print("当前:",self.limit,"?>",old_limit)
		  if self.limit>old_limit then
		     self:go()
		  else
		  --直接结束
		     self:AfterFinish()
		  end
		end
	   return
	 end
	 if string.find(l,"设定环境变量：look") then
	    self:go()
	    return
	 end
	 wait.time(5)
   end)
end
