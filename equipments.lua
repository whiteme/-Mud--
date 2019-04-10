
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
--  一个锦盒(Jin he)

--[[你心领神会，轻手熟路的在按钮上一按，盒子的夹层打了开来。
一张发黄的纸条上写到模糊的几个字:
吾纵横江湖时曾在莆田少林达摩院留下些许物事，待有缘人前去挖掘(dig)。]]
--莆田少林 出品
--[[function equipments:putianshaolin()
  local w
  w=walk.new()
  w.walkover=function()
     world.Send("kill seng")
  end
  w:go(1903)

end
--雪豹皮
function equipments:xuebaopi()
end
--五彩神龙皮
function equipments:longpi()
  wait.make(function()
    world.Send("kan 山崖")
	--崖底笼罩在迷雾中，有一条山藤似乎挺光滑，看来常有人(climb)下去。
	local l,w=wait.regexp("^(> |)崖底笼罩在迷雾中，有一条山藤似乎挺光滑，看来常有人\\\(climb\\\)下去。",5)
	if l==nil then
	   self:longpi()
	   return
	end
	if string.find(l,"有一条山藤似乎挺光滑") then
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
  print(self.count,"剩余次数")
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
     local l,w=wait.regexp("你捡起一块熊皮。",5)
	 if l==nil then
	   self:look_here(num)
	   return
	 end
	 if string.find(l,"你捡起") then
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
		local l,w=wait.regexp("^(> |).*丑「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:jinbishou()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
		   local b=busy.new()
	        b.Next=function()
		     world.Send("get all from corpse")
		     self:wandao()
		   end
		   b:check()
		   return
		end
		if string.find(l,"这里没有这个人") then
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

   local l,w=wait.regexp("(大白熊|老虎|豹子)惨嚎一声，慢慢倒下死了！|(大白熊|老虎|豹子)「啪」的一声倒在地上，挣扎着抽动了几下就死了。",10)
	if l==nil then
	   self:look_here(num)
	   return
	end
	if string.find(l,"死了") then
	   self:look_here(num)
	   return
	end
	wait.time(10)
  end)
end

function equipments:look_here(num)
--大白熊惨嚎一声，慢慢倒下死了！
--你捡起一块熊皮。
   world.Send("look")
   world.Send("set look 1")
   wait.make(function()
     local l,w=wait.regexp(".*大白熊.*|.*老虎.*|.*豹子\\(Bao zi\\).*|.*熊皮.*|.*虎皮.*|^(> |)设定环境变量：look \\= 1",5)
	  if l==nil then
	     self:kill_Next_Point(num)
	     return
	  end
	  if string.find(l,"大白熊") or string.find(l,"老虎") or string.find(l,"豹子") then
	     print("活物")
	     self:bear(num)
	     return
	  end
	  if string.find(l,"熊皮") or string.find(l,"虎皮") then
	     print("死物")
	     self:get_pi(num)
	     return
	  end
	  if string.find(l,"设定环境变量：look") then
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
	   print("猎杀熊的数量:",num)
       if os.difftime(os.time(),bear_appear)<=60*15 then
         print("注意保护环境")
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
		world.Send("ask chen about 百草丹")
		wait.make(function()
		 local l,w=wait.regexp("^(> |)陈长老说道：「你好象没有中毒嘛，来找我做什么？」$|^(> |)陈长老给你一颗百草丹。$|^(> |)陈长老说道：「.*百草丹很珍贵，你身上还有，还是留一些给其他帮中兄弟吧，丐帮弟子最讲义气！」$",5)
		 if l==nil then
		   self:baicaodan()
		   return
		 end
		 if string.find(l,"陈长老给你一颗百草丹") or string.find(l,"丐帮弟子最讲义气") then
		     local b
		      b=busy.new()
		      b.interval=0.5
		      b.Next=function()
			     --print("why2")
		        self.finish("百草丹","bai caodan",true)
		      end
		      b:check()
		      return
		 end
		 if string.find(l,"你好象没有中毒嘛") then
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
		local l,w=wait.regexp("^(> |)陈达海「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:jinbishou()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
		   local b=busy.new()
	        b.Next=function()
		     world.Send("get bishou from corpse")
		     world.Send("get silver from corpse")
		     self:finish()
		   end
		   b:check()
		   return
		end
		if string.find(l,"这里没有这个人") then
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
    world.Send("ask dashi about 柴刀")
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
		local l,w=wait.regexp("^(> |)道尘禅师「啪」的一声倒在地上，挣扎着抽动了几下就死了.*$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:kill_chanshi()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
		   local b=busy.new()
		   b.Next=function()
		     self:finish()
		   end
		   b:check()
		   return
		end
		if string.find(l,"这里没有这个人") then
		   self:finish()
		   return
		end
   end)
end

function equipments:tiebeixin()
  local w=walk.new()
  w.walkover=function()

    world.Send("ask chanshi about 铁背心")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)道相给你一件铁背心。$|^(> |)这里没有这个人。$|^(> |)道相禅师说道：「抱歉，你来得不是时候，武器已经发完了。」$",5)
	  if l==nil then
	     self:tiebeixin()
	     return
	  end
	  if string.find(l,"武器已经发完了") then
	     world.Send("kill chanshi")
		 local f=function()
		    self:finish()
		 end
		 f_wait(f,5)
	     return
	  end
	  if string.find(l,"给你一件铁背心") or string.find(l,"这里没有这个人") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  world.Send("ask chanshi about 护腕")
		  wait.time(2)
		  world.Send("ask chanshi about 僧鞋")
		  wait.time(2)
		  world.Send("ask chanshi about 护腰")
		  wait.time(2)
		    world.Send("ask chanshi about 护指")
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
    world.Send("ask chanshi about 木刀")
	wait.make(function()
	  local l,w=wait.regexp("^(> |)道尘给你一件木刀。$|^(> |)道尘禅师说道：「抱歉，你来得不是时候，武器已经发完了。」$|^(> |)这里没有这个人。$",5)
	  if l==nil then
	     self:mudao()
	     return
	  end
	  if string.find(l,"道尘给你一件木刀") or string.find(l,"这里没有这个人") then
	    local b=busy.new()
		b.interval=0.5
		b.Next=function()
		  self:finish()
		end
		b:check()
	    return
	  end
	  if string.find(l,"武器已经发完了") then
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

	    world.Send("ask fawang about 武器")
		wait.time(2)
		self:finish()
   end

  w:go(2438)
end

function equipments:fenghuolun()
   local w
   w=walk.new()
   w.walkover=function()

	    world.Send("ask fawang about 风火轮")
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
		local l,w=wait.regexp("^(> |)你捡起一柄长剑。$",5)
		if l==nil then
           self:changjian()
		   return
		end
		if string.find(l,"捡起一柄长剑") then
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
		local l,w=wait.regexp("^(> |)你以.*的价格从木匠那里买下了一柄木剑。$|木匠说道：「你想买的东西我这里没有。」$|木匠说道：「穷光蛋，一边呆着去！",5)
		if l==nil then
		   self:mujian()
		   return
		end
		if string.find(l,"买下了一柄木剑") then
		   self:finish()
		   return
		end
		if string.find(l,"我这里没有") then
		   self:finish()
		   return
		end
		if string.find(l,"穷光蛋，一边呆着去") then
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
	 wait.make(function() --你以一两白银又三十九文铜钱的价格从木匠那里买下了一双新人护腕。
	    world.Send("buy huwan")
		local l,w=wait.regexp("^(> |)你以.*的价格从木匠那里买下了一双新人护腕。$|木匠说道：「你想买的东西我这里没有。」$|木匠说道：「穷光蛋，一边呆着去！",5)
		if l==nil then
		   self:huwan()
		   return
		end
		if string.find(l,"买下了一双新人护腕") then
		   world.Send("remove all")
		   world.Send("wear all")
		   self:finish()
		   return
		end
		if string.find(l,"我这里没有") then
		   self:finish()
		   return
		end
		if string.find(l,"穷光蛋，一边呆着去") then
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
	 wait.make(function() --你以一两白银又三十九文铜钱的价格从木匠那里买下了一双新人护腕。
	    world.Send("buy blade")
		local l,w=wait.regexp("^(> |)你以.*的价格从.*那里买下了一柄钢刀。$|.*说道：「你想买的东西我这里没有。」$|.*说道：「穷光蛋，一边呆着去！",5)
		if l==nil then
		   self:gangdao()
		   return
		end
		if string.find(l,"买下了一柄钢刀") then
		   self:finish()
		   return
		end
		if string.find(l,"我这里没有") then
		   self:finish()
		   return
		end
		if string.find(l,"穷光蛋，一边呆着去") then
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
		local l,w=wait.regexp("你以.*的价格从药店掌柜那里买下了一颗内息丸。|^(> |)你想买的东西我这里没有。$|^(> |)穷光蛋，一边呆着去！|^(> |).*您的零钱不够了，银票又没人找得开。$",5)
		if l==nil then
		   self:neixiwan()
		   return
		end
		if string.find(l,"你想买的东西我这里没有") then
	      self:finish()
	      return
	    end
	    if string.find(l,"一颗内息丸") then
          self:finish()
	      return
	    end
	    if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
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
		local l,w=wait.regexp("你以.*的价格从药店掌柜那里买下了一颗川贝内息丸。|^(> |)你想买的东西我这里没有。$|^(> |)穷光蛋，一边呆着去！|^(> |).*您的零钱不够了，银票又没人找得开。$",5)
		if l==nil then
		   self:chuanbeiwan()
		   return
		end
		if string.find(l,"你想买的东西我这里没有") then
	      self:finish()
	      return
	    end
	    if string.find(l,"一颗川贝内息丸") then
          self:finish()
	      return
	    end
	    if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
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
      world.Send("ask zhi about 十三龙象袈裟")
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
      world.Send("ask laozu about 血刀")
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
      world.Send("ask zhang about 下山")
	  local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
		  world.Send("ask zhang about 教诲")
		--[[  【武当派】张三丰对着真假仙挥了挥手。

张三丰给了你一把松纹剑。
张三丰说道：「你好自为之。」
您的资料已经自动保存好了。
ask zhang about 教诲
你向张三丰打听有关『教诲』的消息。
张三丰说道：「若为非做歹，我定不饶你！去吧。」]]
         local player_name=world.GetVariable("player_name")
          wait.make(function()
		     local l,w=wait.regexp("^(> |)张三丰给了你一把古意盎然的木剑。$|^(> |)张三丰说道：「.*给你的剑一定要收好。」",5)
		    if l==nil then
			    self:songwenjian()
			   return
			end
			if string.find(l,"古意盎然的木剑") then
			  wait.time(3)
			  --world.Send("drop sword 2")
			  --world.Send("get sword")
		      self:finish()
			  return
			end
			if string.find(l,"给你的剑一定要收好") then
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
   --> 甩箭对你而言太重了。
	world.Send(cmd)
	wait.make(function()
       local l,w=wait.regexp("^(> |)甩箭对你而言太重了。$|^(> |)你附近没有这样东西。$|^(> |)你捡起一袋甩箭。$",5)
	   if l==nil then
		  self:shuaijian()
		  return
	   end
	   if string.find(l,"甩箭对你而言太重了") then
	       self:get_shuaijian("get 1000 shuaijian")
	       return
	   end
    	if string.find(l,"你捡起一袋甩箭") then
            self:finish()
		    return
		end
	  if string.find(l,"你附近没有这样东西") then
		 local	_R=Room.new()
         _R.CatchEnd=function()
         local count,roomno=Locate(_R)
         --print("当前房间号",roomno[1])
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
		local l,w=wait.regexp("^(> |)宗赞王子「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:pifeng()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
		   local b=busy.new()
	        b.Next=function()
		     world.Send("get pifeng from corpse")
		     world.Send("wear pifeng")
		     self:finish()
		   end
		   b:check()
		   return
		end
		if string.find(l,"这里没有这个人") then
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
		local l,w=wait.regexp("^(> |)马青雄「啪」的一声倒在地上，挣扎着抽动了几下就死了.*$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:ruanxue()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
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
		if string.find(l,"这里没有这个人") then
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
		local l,w=wait.regexp("^(> |)武将「啪」的一声倒在地上，挣扎着抽动了几下就死了.*$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:ruanxue()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
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
		if string.find(l,"这里没有这个人") then
		   self:finish()
		   return
		end
		wait.time(10)
	 end)
   end
   w:go(75)
end
--守寺僧兵
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
		local l,w=wait.regexp("^(> |)(守寺僧兵|武僧)「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:huju1()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
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
		if string.find(l,"这里没有这个人") then
		   --print("没有这个人")
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
		local l,w=wait.regexp("^(> |)(守寺僧兵|武僧)「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:huju2()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
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
		if string.find(l,"这里没有这个人") then
		   --print("没有这个人")
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
		local l,w=wait.regexp("^(> |)武僧「啪」的一声倒在地上，挣扎着抽动了几下就死了。$|^(> |)这里没有这个人。$",10)
		if l==nil then
		   self:huju()
		   return
		end
		if string.find(l,"挣扎着抽动了几下就死了") then
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
		if string.find(l,"这里没有这个人") then
		   --print("没有这个人")
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
         world.Send("ask jie about 木棉袈裟")
		 local l,w2=wait.regexp("^(> |)渡劫说道：「我不是给过你木棉袈裟了嘛？」$",3)
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
		 if string.find(l,"我不是给过你木棉袈裟了嘛") then
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
	   print("当前房间号",roomno[1])
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
      world.Send("ask huang about 软猬甲")
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
        world.Send("ask huang about 教诲")
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
   print("默认的finish")
end

function equipments:huxi()
--神龙岛护膝
  local w=walk.new()
  w.walkover=function()
    world.Send("ask shou about 护膝")
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
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  货  物                          价  格                        库存/总量 ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃风回雪舞剑(Snowsword)         五锭黄金又九十四两白银              50/  50 ┃
┃游龙长鞭(Youlong bian)        五锭黄金又二十八两白银             100/ 100 ┃
┃三百六十五枚暴雨梨花针(Zhen)  三十五锭黄金又六十四两白银         100/ 100 ┃
┃仿制玉竹棒(Zhu bang)          七锭黄金又九十二两白银             100/ 100 ┃
┃玉箫(Yu xiao)                 五锭黄金又五十四两白银又四十文铜钱 100/ 100 ┃
┃百辟匕首(Bishou)              七锭黄金又九十二两白银             100/ 100 ┃
┃骷髅锤(Kulou chui)            九锭黄金又九十两白银               100/ 100 ┃
┃齐眉棍(Tiegun)                六锭黄金又六十两白银               100/ 100 ┃
┃宣花大斧(Dafu)                五锭黄金又九十四两白银             100/ 100 ┃
┃五只秘传法轮(Falun)           十锭黄金又五十六两白银             100/ 100 ┃
┃红缨白蜡大枪(Hongying qiang)  九锭黄金又二十四两白银             100/ 100 ┃
┃寒玉钩(Hanyu gou)             八锭黄金又五十八两白银             100/ 100 ┃
┃剑匣(Jian xia)                七十二锭黄金又六十两白银             2/   2 ┃
┃蓝玉毒针(Lanyu duzhen)        十锭黄金又五十六两白银              20/  20 ┃
┃碎雪刀(Xue sui)               五锭黄金又九十四两白银              20/  20 ┃
┃五百枚丧门钉(Sangmen ding)    二十九锭黄金又四两白银             100/ 100 ┃
┃判官笔(Panguan bi)            七锭黄金又九十二两白银             100/ 100 ┃
┃银蛇剑(Yinshe sword)          七锭黄金又二十六两白银             120/ 120 ┃
┃天蛇杖(Tianshe zhang)         九锭黄金又九十两白银                20/  20 ┃
┃一块阴阳九龙令(Jiulong ling)  四锭黄金又七十五两白银又二十文铜钱 200/ 200 ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛]]

function equipments:register()
   self.lists={}
      self.lists["dahuan dan"]=function(num)

   	     self:dahuandan(num)
	 end
	 self.lists["大还丹"]=function(num)

   	     self:dahuandan(num)
	 end
	 self.lists["longpao"]=function(num)

   	     self:longpao()
	 end
	 self.lists["龙袍"]=function(num)

   	     self:longpao()
	 end
     self.lists["snowsword"]=function(num)
	    local id="snowsword"
			 local name="风回雪舞剑"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["风回雪舞剑"]=function(num)
	    local id="snowsword"
			 local name="风回雪舞剑"
   	      self:bingqipu(name,id,num)
	 end

	self.lists["游龙长鞭"]=function(num)
	    local id="youlong bian"
			 local name="游龙长鞭"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["Youlong bian"]=function(num)
	    local id="youlong bian"
			 local name="游龙长鞭"
   	      self:bingqipu(name,id,num)
	 end

	 self.lists["暴雨梨花针"]=function(num)
	    local id="zhen"
			 local name="暴雨梨花针"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["zhen"]=function(num)
	    local id="zhen"
			 local name="暴雨梨花针"
   	      self:bingqipu(name,id,num)
	 end

	 self.lists["黄竹棒"]=function(num)
	    local id="zhu bang"
			 local name="黄竹棒"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["zhu bang"]=function(num)
	    local id="zhu bang"
				 local name="黄竹棒"
   	      self:bingqipu(name,id,num)
	 end

	 self.lists["玉箫"]=function(num)
	    local id="yu xiao"
				 local name="玉箫"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["Yu xiao"]=function(num)
	    local id="yu xiao"
			 local name="玉箫"
   	      self:bingqipu(name,id,num)
	 end


	 --┃百辟匕首(Bishou)              七锭黄金又九十二两白银             100/ 100 ?

	 self.lists["百辟匕首"]=function(num)
	    local id="bishou"
			 local name="百辟匕首"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["bishou"]=function(num)
	    local id="bishou"
		 local name="百辟匕首"
   	      self:bingqipu(name,id,num)
	 end

--	 ┃骷髅锤(Kulou chui)            九锭黄金又九十两白银               100/ 100 ┃
	 self.lists["骷髅锤"]=function(num)
	    local id="kulou chui"
		   local name="骷髅锤"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["kulou chui"]=function(num)
	    local id="kulou chui"
		 local name="骷髅锤"
   	      self:bingqipu(name,id,num)
	 end
--┃齐眉棍(Tiegun)                六锭黄金又六十两白银               100/ 100 ┃
	 self.lists["齐眉棍"]=function(num)
	    local id="tiegun"
		   local name="齐眉棍"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["tiegun"]=function(num)
	     local id="tiegun"
		   local name="齐眉棍"
   	      self:bingqipu(name,id,num)
	 end
--┃宣花大斧(Dafu)                五锭黄金又九十四两白银             100/ 100 ┃
	 self.lists["宣花大斧"]=function(num)
	    local id="dafu"
		  local name="宣花大斧"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["dafu"]=function(num)
	     local id="dafu"
		  local name="宣花大斧"
   	      self:bingqipu(name,id,num)
	 end
--┃五只秘传法轮(Falun)           十锭黄金又五十六两白银             100/ 100 ┃
	 self.lists["秘传法轮"]=function(num)
        print("秘传法轮")
        local f=_G["fight_Roomno"]
	    local id="falun"
		local name="秘传法轮"
		if f==nil or f=="" then
		   print("重新购买!")
		    self:bingqipu(name,id,num)
		else
		   print("尝试捡回武器!")
		   self:getback_lostweapon(name,id,num)
   	    end
	 end
	 self.lists["falun"]=function(num)
	    local f=_G["fight_Roomno"]
	     local id="falun"
		  local name="秘传法轮"
   	     if f==nil or f=="" then
		   print("重新购买!")
		    self:bingqipu(name,id,num)
		else
		   print("尝试捡回武器!")
		   self:getback_lostweapon(name,id,num)
   	    end
	 end
--┃红缨白蜡大枪(Hongying qiang)  九锭黄金又二十四两白银             100/ 100 ┃
	 self.lists["红缨白蜡大枪"]=function(num)
	    local id="hongying qiang"
		 local name="红缨白蜡大枪"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["hongying qiang"]=function(num)
	      local id="hongying qiang"
		     local name="红缨白蜡大枪"
   	      self:bingqipu(name,id,num)
	 end
--┃寒玉钩(Hanyu gou)             八锭黄金又五十八两白银             100/ 100 ┃
	 self.lists["寒玉钩"]=function(num)
	    local id="hanyu gou"
		   local name="寒玉钩"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["hanyu gou"]=function(num)
	      local id="hanyu gou"
		  	   local name="寒玉钩"
   	      self:bingqipu(name,id,num)
	 end
--┃剑匣(Jian xia)                七十二锭黄金又六十两白银             2/   2 ┃
	 self.lists["剑匣"]=function(num)
	    local id="jian xia"
		 local name="剑匣"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["jian xia"]=function(num)
	      local id="jian xia"
		   local name="剑匣"
   	      self:bingqipu(name,id,num)
	 end
--┃蓝玉毒针(Lanyu duzhen)        十锭黄金又五十六两白银              20/  20 ┃
	 self.lists["蓝玉毒针"]=function(num)
	    local id="lanyu duzhen"
		   local name="蓝玉毒针"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["lanyu duzhen"]=function(num)
	      local id="lanyu duzhen"
		   local name="蓝玉毒针"
   	      self:bingqipu(name,id,num)
	 end
--┃碎雪刀(Xue sui)               五锭黄金又九十四两白银              20/  20 ┃
	 self.lists["雪碎刀"]=function(num)
	    local id="xue sui"
		   local name="雪碎刀"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["xue sui"]=function(num)
	      local id="xue sui"
		   local name="雪碎刀"
   	      self:bingqipu(name,id,num)
	 end

--┃五百枚丧门钉(Sangmen ding)    二十九锭黄金又四两白银             100/ 100 ┃
	 self.lists["丧门钉"]=function(num)
	    local id="sangmen ding"
		 local name="丧门钉"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["sangmen ding"]=function(num)
	      local id="sangmen ding"
		    local name="丧门钉"
   	      self:bingqipu(name,id,num)
	 end
--┃判官笔(Panguan bi)            七锭黄金又九十二两白银             100/ 100 ┃
	 self.lists["判官笔"]=function(num)
	    local id="panguan bi"
		local name="判官笔"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["panguan bi"]=function(num)
	      local id="panguan bi"
		  local name="判官笔"
   	      self:bingqipu(name,id,num)
	 end
--┃银蛇剑(Yinshe sword)          七锭黄金又二十六两白银             120/ 120 ┃
	 self.lists["银蛇剑"]=function(num)
	    local id="yinshe sword"
		local name="银蛇剑"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["yinshe sword"]=function(num)
	      local id="yinshe sword"
		  local name="银蛇剑"
   	      self:bingqipu(name,id,num)

	 end

	 self.lists["jinshe zhui"]=function(num)
	      local id="jinshe zhui"
		  local name="金蛇锥"
   	      self:bingqipu(name,id,num)

	 end
	 self.lists["金蛇锥"]=function(num)
	      local id="jinshe zhui"
		  local name="金蛇锥"
   	      self:bingqipu(name,id,num)

	 end
--┃天蛇杖(Tianshe zhang)         九锭黄金又九十两白银                20/  20 ┃
	 self.lists["天蛇杖"]=function(num)
	    local id="tianshe zhang"
		  local name="天蛇杖"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["tianshe zhang"]=function(num)
	      local id="tianshe zhang"
		    local name="天蛇杖"
   	      self:bingqipu(name,id,num)
	 end
--┃一块阴阳九龙令(Jiulong ling)  四锭黄金又七十五两白银又二十文铜钱 200/ 200 ?
	 self.lists["阴阳九龙令"]=function(num)
	    local name="阴阳九龙令"
	    local id="jiulong ling"
   	      self:bingqipu(name,id,num)
	 end
	 self.lists["jiulong ling"]=function(num)
	      local id="jiulong ling"
		    local name="阴阳九龙令"
   	     self:bingqipu(name,id,num)
	 end

   self.lists["shuaijian"]=function(num) self:shuaijian() end
   self.lists["甩箭"]=function(num) self:shuaijian() end

   self.lists["jinhu pifeng"]=function() self:pifeng() end
   self.lists["锦虎披风"]=function() self:pifeng() end

   self.lists["ruan xue"]=function() self:ruanxue() end
   self.lists["软底快靴"]=function() self:ruanxue() end

   self.lists["shisan longxiang"]=function() self:longxiang() end
   self.lists["十三龙象袈裟"]=function() self:longxiang() end

   self.lists["hu wan"]=function() self:huju() end
   self.lists["护腕"]=function() self:huju() end

   self.lists["tie beixin"]=function() self:tiebeixin() end
   self.lists["铁背心"]=function() self:tiebeixin() end

   self.lists["木剑"]=function() self:mujian() end
   self.lists["mu jian"]=function() self:mujian() end

   self.lists["新人护腕"]=function() self:huwan() end
   self.lists["huwan"]=function() self:huwan() end

   self.lists["血刀"]=function() self:xuedao() end
   self.lists["xuedao"]=function() self:xuedao() end

   self.lists["ruanwei jia"]=function() self:ruanweijia() end
   self.lists["软猬甲"]=function() self:ruanweijia() end

   self.lists["jiaohui"]=function() self:jiaohui() end
   self.lists["教诲"]=function() self:jiaohui() end

   self.lists["songwen jian"]=function() self:songwenjian() end
   self.lists["松纹古剑"]=function() self:songwenjian() end

   self.lists["jiuhua wan"]=function() self:jiuhuawan() end
   self.lists["九花玉露丸"]=function() self:jiuhuawan() end

   self.lists["jin bishou"]=function() self:jinbishou() end
   self.lists["金匕首"]=function() self:jinbishou() end

   self.lists["neixi wan"]=function() self:neixiwan() end
   self.lists["内息丸"]=function() self:neixiwan() end

   self.lists["chuanbei wan"]=function() self:chuanbeiwan() end
   self.lists["川贝内息丸"]=function() self:chuanbeiwan() end

   self.lists["huxi"]=function() self:huxi() end
   self.lists["护膝"]=function() self:huxi() end

   self.lists["chai dao"]=function() self:chaidao() end
   self.lists["柴刀"]=function() self:chaidao() end

   self.lists["mu dao"]=function() self:mudao() end
   self.lists["木刀"]=function() self:mudao() end

   self.lists["mumian jiasha"]=function() self:mumianjiasha() end
   self.lists["木棉袈裟"]=function() self:mumianjiasha() end

   self.lists["xiong pi"]=function(num) self:xiongpi(num) end
   self.lists["熊皮"]=function(num) self:xiongpi(num) end

   self.lists["baicaodan"]=function() self:baicaodan() end
   self.lists["百草丹"]=function() self:baicaodan() end

   self.lists["zhen"]=function() self:xiuhuazhen() end
   self.lists["绣花针"]=function() self:xiuhuazhen() end

   self.lists["danfeng huyao"]=function() self:danfenghuyao() end
   self.lists["丹凤护腰"]=function() self:danfenghuyao() end

   self.lists["tanmu huxiong"]=function() self:tanmuhuxiong() end
   self.lists["檀木护胸"]=function() self:tanmuhuxiong() end

   self.lists["changjian"]=function() self:changjian() end
   self.lists["长剑"]=function() self:changjian() end

   self.lists["xiao shuzhi"]=function() self:xiaoshuzhi() end
   self.lists["小树枝"]=function() self:xiaoshuzhi() end

   self.lists["blade"]=function() self:gangdao() end
   self.lists["钢刀"]=function() self:gangdao() end

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
   self.lists["火折"]=function()
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
   self.lists["铜钱"]=function(num) self:coin(num) end

   self.lists["silver"]=function(num) self:silver(num) end
   self.lists["白银"]=function(num) self:silver(num) end
   self.lists["gold"]=function(num) self:gold(num) end
   self.lists["黄金"]=function(num) self:gold(num) end

   self.lists["liuhuang"]=function(num) self:liuhuang() end
   self.lists["硫磺"]=function(num) self:liuhuang() end

   self.lists["tanzi"]=function(num) self:tanzi() end
   self.lists["坛子"]=function(num) self:tanzi() end

   self.lists["duandi"]=function(num) self:duandi() end
   self.lists["紫玉短笛"]=function(num) self:duandi() end

   self.lists["Zhaohun fan"]=function(num) self:get_fan() end
   self.lists["招魂幡"]=function(num) self:get_fan() end

   self.lists["挠钩"]=function(num) self:naogou() end
   self.lists["nao gou"]=function(num) self:naogou() end

   self.lists["风火轮"]=function(num) self:fenghuolun() end
   self.lists["fenghuo lun"]=function(num) self:fenghuolun() end

     self.lists["法轮"]=function(num) self:falun() end
   self.lists["lun"]=function(num) self:falun() end

    self.lists["雪山新月刀"]=function(num) self:wandao() end
   self.lists["xinyue dao"]=function(num) self:wandao() end

	self.lists["碧玉剑"]=function(num) self:biyujian() end
   self.lists["biyu jian"]=function(num) self:biyujian() end

   	self.lists["幸运珍珠"]=function(num) self:pearl() end
   self.lists["pearl"]=function(num) self:pearl() end

   	self.lists["绳子"]=function(num) self:shengzi() end
   self.lists["sheng zi"]=function(num) self:shengzi() end

   self.lists["雄黄"]=function(num) self:xionghuang() end
   self.lists["xiong huang"]=function(num) self:xionghuang() end

	self.lists["竹哨"]=function(num) self:zhushao() end
   self.lists["zhushao"]=function(num) self:zhushao() end

   	self.lists["金蛇"]=function(num) self:jinshe() end
   self.lists["jinshe"]=function(num) self:jinshe() end

	self.lists["紫金刀"]=function(num) self:zijindao() end
   self.lists["zijin dao"]=function(num) self:zijindao() end

   self.lists["玉蜂针"]=function(num) self:yufengzhen() end
   self.lists["yufeng zhen"]=function(num) self:yufengzhen()  end

   self.lists["玄铁剑"]=function(num) self:xuantie() end
   self.lists["xuantie jian"]=function(num) self:xuantie() end

   self.lists["川贝内息丸"]=function(num) self:buy_neixiwan() end
    self.lists["chuanbei wan"]=function(num) self:buy_neixiwan() end

end

function equipments:auto_get(item_name,num)

   local f=self.lists[item_name]
   --print(f)
   if f~=nil then
      assert (type (f) == "function", "auto_get需要一个执行函数")
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
	  local l,w=wait.regexp("^(> |)你以.*的价格从杂货铺老板那里买下了一块雄黄。$|^(> |)你想买的东西我这里没有。$|^(> |)杂货铺老板说道：「穷光蛋，一边呆着去！」$|^(> |)*穷光蛋，一边呆着去！|^(> |)杂货铺老板说道：「您的零钱不够了，银票又没人找得开。」$",5)
	  if l==nil then
	      self:xionghuang()
		  return
	  end
	  if string.find(l,"你想买的东西我这里没有") then
	      self:finish()
	      return
	    end
	  if string.find(l,"买下了一块雄黄") then
	     --self.finish("绣花针","xiuhua zhen",true)
	     self:finish()
	     return
	  end
   if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
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
	  local l,w=wait.regexp("^(> |)你以.*的价格从陈阿婆那里买下了一根绣花针。$|^(> |)你想买的东西我这里没有。$|^(> |)陈阿婆说道：「穷光蛋，一边呆着去！」$|^(> |)*穷光蛋，一边呆着去！|^(> |)陈阿婆说道：「您的零钱不够了，银票又没人找得开。」$",5)
	  if l==nil then
	      self:xiuhuazhen()
		  return
	  end
	  if string.find(l,"你想买的东西我这里没有") then
	      self:finish()
	      return
	    end
	  if string.find(l,"从陈阿婆那里买下了一根绣花针") then
	     --self.finish("绣花针","xiuhua zhen",true)
	     self:finish()
	     return
	  end
   if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
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
	  local l,w=wait.regexp("^(> |)谷虚道长给你一件丹凤护腰。$|^(> |)谷虚道长说道：「.*你现在身上不是有这样防具吗，怎麽又来要了？ 真是贪得无餍！」$",5)
	  if l==nil then
	      self:danfenghuyao()
		  return
	  end
	  if string.find(l,"丹凤护腰") then
		  local b=busy.new()
		  b.Next=function()
	        world.Send("remove all")
		    world.Send("wear all")
	        self:finish()
		  end
		  b:check()
	      return
	  end
	  if string.find(l,"真是贪得无餍") then
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
	  local l,w=wait.regexp("^(> |)谷虚道长给你一件檀木护胸。$|^(> |)谷虚道长说道：「.*你现在身上不是有这样防具吗，怎麽又来要了？ 真是贪得无餍！」$",5)
	  if l==nil then
	      self:tanmuhuxiong()
		  return
	  end
	  if string.find(l,"谷虚道长给你一件檀木护胸") or string.find(l,"真是贪得无餍") then
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

--必须带火种 长江南
function equipments:fire3()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy fire")
	  local l,w=wait.regexp("^(> |)你以.*价格从小贩子那里买下了一支火折。$|^(> |)小贩子说道：「穷光蛋，一边呆着去！」$|^(> |)小贩子说道：「您的零钱不够了，银票又没人找得开。」$",5)
	  if l==nil then
	      self:fire3()
		  return
	  end
	  if string.find(l,"小贩子那里买下了一支火折") then
	     self:finish()
	     return
	  end
	  if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
		 local f=function()
			self:fire3()
		 end
		 qu_gold(f,1,1331)
		 return
	  end
   end
   w:go(1116)
end
--必须带火种 星宿
function equipments:fire2()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy fire")
	  local l,w=wait.regexp("^(> |)你以.*价格从买卖提那里买下了一支火折。$|^(> |)买卖提说道：「穷光蛋，一边呆着去！」$|^(> |)买卖提说道：「您的零钱不够了，银票又没人找得开。」$",5)
	  if l==nil then
	      self:fire2()
		  return
	  end
	  if string.find(l,"买卖提那里买下了一支火折") then
	     self:finish()
	     return
	  end
	  if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
		 local f=function()
			self:fire2()
		 end
		 qu_gold(f,1,1973)
		 return
	  end
   end
   w:go(2351)
end

--必须带火种
function equipments:fire()
   local w=walk.new()
   w.walkover=function()
      world.Send("buy fire")
	  local l,w=wait.regexp("^(> |)你以.*价格从小贩子那里买下了一支火折。$|^(> |)小贩子说道：「穷光蛋，一边呆着去！」$|^(> |)小贩子说道：「您的零钱不够了，银票又没人找得开。」$",5)
	  if l==nil then
	      self:fire()
		  return
	  end
	  if string.find(l,"小贩子那里买下了一支火折") then
	     self:finish()
	     return
	  end
	  if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
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
		local l,w=wait.regexp("^(> |)你从银号里取出.*铜钱。$",5)
		if l==nil then
		--duanzao_learn(CallBack)
		   self:coin(num)
		   return
		end
		if string.find(l,"你从银号里") then
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
		local l,w=wait.regexp("^(> |)你从银号里取出.*白银。$",5)
		if l==nil then
		--duanzao_learn(CallBack)
		   self:silver(num)
		   return
		end
		if string.find(l,"你从银号里") then
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
		local l,w=wait.regexp("^(> |)你从银号里取出.*黄金。$",5)
		if l==nil then
		--duanzao_learn(CallBack)
		   self:gold(num)
		   return
		end
		if string.find(l,"你从银号里") then
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
	  local l,w=wait.regexp("^(> |)你以.*价格从买卖提那里买下了一个坛子。$|^(> |)买卖提说道：「穷光蛋，一边呆着去！」$|^(> |)买卖提说道：「您的零钱不够了，银票又没人找得开。」$",5)
	  if l==nil then
	      self:tanzi()
		  return
	  end
	  if string.find(l,"从买卖提那里买下了一个坛子") then
	      self.finish("坛子","tan zi",true)
	     return
	  end
	  if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
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
	  local l,w=wait.regexp("^(> |)你以.*价格从买卖提那里买下了一块硫磺。$|^(> |)买卖提说道：「穷光蛋，一边呆着去！」$|^(> |)买卖提说道：「您的零钱不够了，银票又没人找得开。」$",5)
	  if l==nil then
	      self:liuhuang()
		  return
	  end
	  if string.find(l,"从买卖提那里买下了一块硫磺") then
	     self:finish()
	     return
	  end
	  if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了") then
		 local f=function()
			self:liuhuang()
		 end
		 qu_gold(f,1,1973)
		 return
	  end
   end
   w:go(2351)
end

-- 一只紫玉短笛(Duandi) 狮吼子拿出一只玉制短笛，交给你。
function equipments:duandi()
  local w=walk.new()
  w.walkover=function()
      world.Send("flatter 星宿老仙，德配天地，威震寰宇，古今无比。")
	  local exps=world.GetVariable("exps")
	  local roomno=2234
	  if tonumber(exps)>=350000 then
	     roomno=2235
	  end
	  local f=function()
        local w=walk.new()
         w.walkover=function()
             world.Send("ask zi about 老仙")
			 self.finish("紫玉短笛","duandi",true)
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
       world.Send("ask murong fu about 碧玉剑")
	   wait.time(3)
	   self:finish()
  end
  w:go(1989)
end
--> 你以五锭黄金又八十五两白银的价格从许老板那里买下了一把碎雪刀。
function equipments:bingqipu(name,id,num)
    if num==nil then
		num=1
	end
  local w=walk.new()
  w.walkover=function()

	   world.Send("buy "..id)
	   world.Send("set action 买买买")
	 local l,w=wait.regexp("^(> |)许老板说道：「穷光蛋，一边呆着去！」$|^(> |)设定环境变量：action \\= \\\"买买买\\\"$|^(> |)你以.*价格从许老板那里买下了.*。$|^(> |)许老板说道：「您的零钱不够了，银票又没人找得开。」$",20)
	  if l==nil then
	      self:bingqipu(name,id,num)
		  return
	  end
	  if string.find(l,"设定环境变量") then
			local sp=special_item.new()

			sp.check_items_over=function()
			   print("检查结束")
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
	         equip=Split("<存在>"..name,"|")
              sp:check_items(equip)
	     return
	  end
	  if string.find(l,"从许老板那里买下了") then

	      if id=="zhen" then
			  num=num-365
			 elseif id=="falun" then
			   num=num-5
			 elseif id=="sangmen ding" then
			   num=num-500
			else
		      num=num-1  --购买复数的兵器 有钱就任性
		 end
	    print("需求数量！！",num)
	     if num<=1 then
	        self:finish()
		 else

			self:bingqipu(name,id,num)
		 end
	     return
	  end
	  if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"您的零钱不够了")  then
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
       world.Send("ask murong bo about 龙袍") --绿波香露刀
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
       world.Send("ask dashi about 套索")
	   wait.time(3)
	   world.Send("ask dashi about 挠钩")
	   wait.time(3)
	   self:finish()
  end
  w:go(3160)
end

function equipments:safe_room()

 --跑城隍庙
   local w=walk.new()
   w.walkover=function()
      world.Send("look")
	  world.Send("set action leave")
      local l,w=wait.regexp(".*城隍庙.*|^(> |)设定环境变量：action \\= \\\"leave\\\".*",3)
	  if l==nil then
	     self:safe_room()
		 return
	  end
	  if string.find(l,"设定环境变量：action") then
	     self:safe_room()
	     return
	  end
	  if string.find(l,"城隍庙") then
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
	   local item="<获取>"..name.."&"..id
	   table.insert(equip,item)
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

function equipments:getback_lostweapon(name,id,num)
  --刚才是否死亡
  --是否是死亡导致武器丢失
   local newdie=world.GetVariable("newdie") or ""
   if newdie=="true" then
      world.DeleteVariable("newdie")
	  _G["fight_Roomno"]=nil
      self:bingqipu(name,id,num)
	  return
   end
   world.Send("alias pfm") --删除pfm
   local f=_G["fight_Roomno"] --在战斗中脱落的武器 保留的最后战斗房间
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
		   print("脱离方向!",g_dx)
		  break
	  end
	  w.walkover=function()

	     world.Send("get "..id)
		 world.Send("halt")
		 world.Send("alias pfm halt;get "..id..";"..g_dx..";set action 逃跑")
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
你反复看着盒子，想找出里面有什么秘密。
你心领神会，轻手熟路的在按钮上一按，盒子的夹层打了开来。
一张发黄的纸条上写到模糊的几个字:
吾纵横江湖时曾在天龙寺般若台留下些许物事，待有缘人前去挖掘(dig)。]]
function equipments:NextPoint()
   print("进程恢复:",coroutine.status(equipments.eq_co))
   if equipments.eq_co==nil or coroutine.status( equipments.eq_co)=="dead" then
      self:finish()
   else
      print("恢复")
      coroutine.resume(equipments.eq_co)
   end
end
--[[
> 你突然挖到一封信函，上面隐约有机密的字样。
你感觉到事情紧急，不可耽误军情，似乎应当将信件送出去。
【谣言】某人：有人看到叶知秋获得一份绝密军情！
【谣言】某人：叶知秋弄到了一封襄阳秘函！
>
dig
你蹲在地上，空手在地上一阵乱刨。
你挖了一阵，什么也没有找到。]]

function equipments:dig()

   world.Send("dig")
     wait.make(function()
      local l,w=wait.regexp("^(> |)你用.*挖，好像很难下手吧？$|^(> |)你打算拆屋呀？$|(> |)你蹲在地上.*在地上一阵乱刨。$|^(> |)地上多了一个古绣斑斑的铁盒子，你趁人不注意，迅速把铁盒喘入怀中。$|^(> |)你突然挖到一封信函，上面隐约有机密的字样。$",5)
	  if l==nil then
	     self:dig()
		 return
	  end
	  if string.find(l,"地上多了一个古绣斑斑的铁盒子") or string.find(l,"你突然挖到一封信函") then
		 local b=busy.new()
		 b.Next=function()
	       self:finish()
		 end
		 b:check()
	     return
	  end
	  if string.find(l,"好像很难下手吧") then
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
			self:dig()
		 end
		 sp:unwield_all()
	     return
	  end
	  if string.find(l,"打算拆屋") or string.find(l,"在地上一阵乱刨") then
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
		      self:finish() --结束
		  end

		  w.user_alias=al
		  w.noway=function()
		     self:NextPoint()
			 --self:giveup()
		  end
		  w.walkover=function()
			self:dig()
		  end
		  print("下一个房间号:",r)
		  w:go(r)
		  coroutine.yield()
	  end
	  print("没挖对地方！！")
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
  --print("执行哇局")
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
      print("大于3次没打开锦盒!")
	  self:finish()
	  return
   end
   wait.make(function()
      local l,w=wait.regexp("^(> |)吾纵横江湖时曾在(.*)留下些许物事，待有缘人前去挖掘.*$|^(> |)盒子的夹层已经打开.*$",5)
	  if l==nil then
         self:jinhe(cmd,count)
		 return
	  end
	  if string.find(l,"盒子的夹层已经打开") then
	     local c="look jinhe"
		 self:jinhe(c)
		 return
	  end
	  if string.find(l,"待有缘人前去挖掘") then
	     local Location=w[2]
		 print(Location," 挖掘地点")
	     local is_save=false
		 local exps=tonumber(world.GetVariable("exps")) or 0
		 if string.find(Location,"藏经阁二楼") and exps<800000 then  --几个危险房间
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
	   --> 你附近没有这样东西。
	   wait.make(function()
	      local l,w=wait.regexp("^(> |)你附近没有这样东西。$|^(> |)你捡起一捆绳子。$",10)
		  if l==nil then
		     self:shengzi()
		     return
		  end
		  if string.find(l,"你附近没有这样东西") then
		     local f=function()
  			   self:shengzi()
			 end
			 f_wait(f,10)
		     return
		  end
	      if string.find(l,"你捡起一捆绳子") then
		     self:finish()
		     return
		  end
	   end)

     end
     w:go(1526)
end
--sld 金蛇
function equipments:jinshe()
   local w=walk.new()
   w.walkover=function()
      --xunshe
	  --zhaoshe
	  world.Send("zhaoshe")
	  wait.make(function()
	    local l,w=wait.regexp("^(> |)什么？$|^(> |)你还没有蛇呢！$|^(> |)你已经拿到蛇了。$|^(> |)你在这里找不到蛇。|^(> |)你拿出竹哨，幽幽的吹了起来，不一会儿，一条金光闪闪的小蛇串到$N的身上。$",5)
	    if l==nil then
		   self:jinshe()
		   return
		end
	    if string.find(l,"一条金光闪闪的小蛇")then
		  self:finish()
		  return
		end
		if string.find(l,"你在这里找不到蛇") then
		  self:jinshe()
		  return
		end
		if string.find(l,"你还没有蛇呢") or string.find(l,"你已经拿到蛇了")  then
		   world.Send("xunshe")
		   wait.time(1)
		   world.Send("zhaoshe")
		   self:finish()
		   return
		end
		if string.find(l,"什么") then
		   --self:finish()
		   self:zhushao()
		   return
		end
	  end)
   end
   w:go(1775)
end

--竹哨(Zhushao)
function equipments:zhushao()
  local w=walk.new()
  w.walkover=function()
       local b=busy.new()
	   b.interval=0.8
	   world.Send("ask su about 竹哨")
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

--古墓 玉蜂针
function equipments:yufengzhen()
  local w=walk.new()
  w.walkover=function()
       local b=busy.new()
	   b.interval=0.8
	   world.Send("ask longnv about 玉蜂针")
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


		local l,w=wait.regexp("^(> |)平台 -.*$",5)
		if l==nil then
		   self:pingtai()
		   return
		end
		if string.find(l,"平台") then
		 local sp=special_item.new()
		 sp.cooldown=function()
		    print("卸载武器")
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
     local l,w=wait.regexp("^(> |)跪拜之际忽然发现山洞北面似乎有个出口，透过来一丝光亮。$",4)
	 if l==nil then
	    self:xuantie2()
	    return
	 end
	 if string.find(l,"透过来一丝光亮") then

	    wait.time(1)
		 world.Send("zuan dong")
		 wait.time(2)
		 self:pingtai()

		return
	 end
  end)
end

function equipments:shandong()
--  大山洞 -
   world.Send("enter")
   wait.make(function()
      local l,w=wait.regexp("^(> |)大山洞 -.*$",5)
	  if l==nil then
	     world.Send("out")
	     self:xuantie()
		 return
	  end
	  if string.find(l,"大山洞") then
	     world.Send("dian shuzhi")
		 self:xuantie2()
	     return
	  end
   end)
end

--古墓的玄铁剑 2000内力 35bl 以上
--玄铁剑无名宝剑:　携带火折,小书枝到襄阳山路史家五兄弟开始nw;n;n会进入一个树林,走到有nu的时候,nu;nu;nw;nu;看到神雕,kill diao;enter;dian shuzhi;l qingtai;mo qingtai;l zi;l mu;kneel mu;zuan dong;nw;nu;l shi bi;mo shi bi;cuan;up;l zi;move stone;enter;ti xuantie(玄铁剑);ti gangjian(无名宝剑),出洞:tui shi;out;tiao down; sd;se;s;out
function equipments:xuantie()
 --检查物品
      local equip={}
	  local item="<获取>火折|<获取>小树枝|<获取>玄铁剑"

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
       world.Send("ask laozu about 紫金刀")
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
		  local l,w=wait.regexp("^(> |)你附近没有这样东西。$|^(> |)你捡起一枝小树枝。$",5)
		  if l==nil then
		     self:xiaoshuzhi(roomno)
		     return
		  end
		  if string.find(l,"你附近没有这样东西") then
			 self:xiaoshuzhi(roomno)
		     return
		  end
		  if string.find(l,"你捡起一枝小树枝") then
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
	 local l,w=wait.regexp("^(> |)你以.*价格从药店掌柜那里买下了一颗川贝内息丸。$|^(> |)你想买的东西我这里没有。$|^(> |)穷光蛋，一边呆着去！|^(> |).*您的零钱不够了，银票又没人找得开。$",2)
	 if l==nil then
	   self:buy_neixiwan()
	   return
	 end
	 if string.find(l,"你想买的东西我这里没有") then
	   self:finish()
	   return
	 end
	 if string.find(l,"一颗川贝内息丸") then
	   self:finish()
	    return
	 end
	 if string.find(l,"穷光蛋，一边呆着去") or string.find(l,"银票又没人找得开") then
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
