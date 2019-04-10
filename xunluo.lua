
xunluo={
  new=function()
     local xl={}
	 setmetatable(xl,{__index=xunluo})
	 return xl
   end,
  co=nil,
  playername="七月十",
  check_ling_count=0,
  attacker_name="",
  neili_upper=1.9,
  huayin_npc="",
  current_exps=0,
  current_pot=0,
  xiulian="false",

}

local nod=false
--[[

首先找到殷无禄ask wulu about 巡逻，得到工作后就可以开始了(由于殷无
禄是一个活动的NPC，所以看到他最好 follow，如不知道他的方位可找殷无寿，
ask yin about yin wulu)，
    第一步：从范遥处开始到达张中处画印。
    第二步：找到四个门主画印。
    第三步：到闻苍松处画印。
    第四步：到殷野王处画印。
    第五步：到殷无福处画印。
    第六步：最后找到殷无禄 ask yin wulu about，完成并 give wulu ling，
殷无禄会把巡逻令做个记号后还给你。
    第七步：到韦一笑处把 give wei ling 就大功造成了！

    在画印过程中如果说有可疑人，就到巨木旗{w;e;e;w;w;e;e;w} 多走几次就
会出来一个Attacker，打跑他后再去画印。


殷无禄对七月十哈哈一笑，说道：既然这样，你就在光明顶和小沙丘之间好好巡逻。
]]

function xunluo:ask_job(flag)
	 	 	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="询问工作",
	           task_step=1,
	           task_maxsteps=9,
	           task_location="",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
   local f=function()
      world.Send("ask wulu about 巡逻")--殷无禄说道：「你上次明教巡逻任务刚做完，还是先休息一下吧。」殷无禄说道：「嗯，你刚刚巡逻完毕，还是先去休息休息吧。」
	  wait.make(function()
	     local l,w=wait.regexp("^(> |)殷无禄说道：「你上次明教巡逻任务刚做完，还是先休息一下吧。」$|^(> |)殷无禄说道：「嗯，你刚刚巡逻完毕，还是先去休息休息吧。」$|^(> |)这里没有这个人。$|^(> |)殷无禄对"..self.playername.."哈哈一笑，说道：既然这样，你就在光明顶和小沙丘之间好好巡逻。$|^(> |)殷无禄说道：「大胆!你竟然敢同时做别的任务！」$|^(> |)殷无禄说道：「你不是在巡逻吗，怎么还呆在这里？」$|^(> |)殷无禄说道：在下是出来游山玩水的，不回答问题。$|^(> |)殷无禄说道：「你不是在巡逻吗，怎么还呆在这里？」$",5)
         if l==nil then
		    self:ask_job()
		    return
		 end
		 if string.find(l,"这里没有这个人") then
		    --print("test")
		    self:NextPoint()
		    return
		 end
		 if string.find(l,"你上次明教巡逻任务刚做完") then
		    --print("结束")
		    world.Send("follow none")
			local b=busy.new()
		    b.interval=0.5
		    b.Next=function()
		      self.fail(101)
		    end
		    b:check()
		    return
		 end
         if string.find(l,"你竟然敢同时做别的任务") then
			local b=busy.new()
		    b.interval=0.5
		    b.Next=function()
		      self.fail(102)
		    end
		    b:check()
             return
         end
		 if string.find(l,"你刚刚巡逻完毕，还是先去休息休息吧") then
		    --world.Send("follow none")
		    self:giveup(true)
		    return
		 end
		 if string.find(l,"不回答问题") then
		    self:ask_job(true)
		    return
		 end
		 if string.find(l,"你就在光明顶和小沙丘之间好好巡逻") or string.find(l,"你不是在巡逻吗") then
		    world.Send("follow none")
			local b=busy.new()
			b.interval=0.5
			b.Next=function()
		      self:step1()
			end
			b:check()
		    return
		 end
	  end)
   end
   if flag==true then
      f()
   else
      self:wulu(f)
	end
end

function xunluo:fail(id)
end

local function is_contain(r,rooms)
    if rooms==nil then
	  return false
	end
	for _,v in ipairs(rooms) do
	    if v==r then
		   return true
		end
	end
	return false
end

function xunluo:xunluo(roomno,flag)
   if roomno==2243 and flag~=true then
       self:xl1()
   elseif roomno==2179 then
      local b=busy.new()
	  b.interval=0.5
	  b.Next=function()
       self:xl2()
	  end
	  b:check()
   elseif roomno==2469 then
      local b=busy.new()
	  b.interval=0.5
      b.Next=function()
  	    self:xl3()
	  end
	  b:check()
   elseif roomno==2243 and flag==true then
        self:huayin("张中","zhang zhong")
   elseif roomno==2888 then
      --画印
	   local w=walk.new()
	   w.walkover=function()
	     self:here(2175)
	   end
       w:go(2175)
   elseif roomno==2175 then
      self:huayin("颜垣","yan tan")
   elseif roomno==2887 then
            --烈火旗的辛然画印
	   local w=walk.new()
	   w.walkover=function()
		  self:here(2178)
	   end
       w:go(2178)
   elseif roomno==2178 then
	    self:huayin("辛然","xin ran")
   elseif roomno==2890 then
    --洪水旗的唐洋
       local w=walk.new()
	   w.walkover=function()
		 self:here(2173)
	   end
       w:go(2173)
   elseif roomno==2173 then
		self:huayin("唐洋","tang yang")
   elseif roomno==2889 then
       local w=walk.new()
	   w.walkover=function()
	     self:here(2455)
	   end
       w:go(2455)
	elseif roomno==2455 then
		self:huayin("庄铮","zhuang zheng")
	elseif roomno==2168 and flag~=true then
	    self:xl4()
	elseif roomno==2168 and flag==true then
		self:huayin("闻苍松","wen cangsong")
	elseif roomno==2164 and flag~=true then
	  self:xl5()
	elseif roomno==2082 then
	  self:xl6()
	elseif roomno==2164 and flag==true then
	  self:huayin("殷野王","yin yewang")
    end
end

function xunluo:checkPlace(roomno,here,flag)

	if is_contain(roomno,here) then
	    print("到达正确位置")
        self:xunluo(roomno,flag)
	else
	  local w=walk.new()
      w.walkover=function()
        self:here(roomno,flag)
      end
      w:go(roomno)
	end
end

function xunluo:here(roomno,flag)
   local f=function(r)
	 self:checkPlace(roomno,r,flag)
   end
   WhereAmI(f)
end
--[[张中说道：「等等，我正在检查呢。」
张中对着幕友千竖起了右手大拇指，好样的。
张中说道：「好，这里你已经巡逻完毕了，我给你画印吧。」
张中说道：「咦，不是叫你去看看有没有可疑的人吗？怎么还没去？」

张中说道：「嗯，刚刚有弟子来报告说好象看见了不明身份的人，你最好再去看看。」
张中冲着你大喊：壮士，加油，加油！

张中对着你竖起了右手大拇指，好样的。
张中说道：「好，这里你已经巡逻完毕了，我给你画印吧。」
颜垣对着你竖起了右手大拇指，好样的。
颜垣说道：「好，这里你已经巡逻完毕了，我给你画印吧。」

结果探子的膻中穴被抓个正着，全身不由自主的一颤，顿时不可动弹。
> 雪山妹妹从巨木旗走了过来。
探子转身几个起落就不见了。

高富帅丁冲上前去，激动地紧紧握住殷无禄的双手，哽咽着说不出话来。
殷无禄说道：「好，你就拿这令牌去交给韦法王吧。」
你给殷无禄一片巡逻令。
> 高富帅丁向殷无禄打听有关『完成』的消息。
殷无禄对着高富帅丁点了点头。
殷无禄说道：「 好！高富帅丁你完成得很好，把令牌给我吧。」

殷无禄在巡逻令上写了写东西。
殷无禄给你一片巡逻令。
]]
--闻苍松说道：「好，这里你已经巡逻完毕了，我给你画印吧。」
--唐洋对着慕容鬼火竖起了右手大拇指，好样的。
--殷野王说道：「你还有些地方没有巡逻到吧？先不忙画印。」
function xunluo:wait_huayin(name,id)
  print("wait_huayin",name,id)
  wait.make(function()
     local l,w=wait.regexp("^(> |)"..name.."对着(.*)竖起了右手大拇指，好样的。$|^(> |)"..name.."说道：「这边(.*)已经巡逻完了，再去别的地方看看吧。」$|^(> |)"..name.."冲着(.*)大喊：.*加油，加油！$|^(> |)"..name.."说道：「咦，不是叫(.*)去看看有没有可疑的人吗？怎么还没去？」$|^(> |)"..name.."对着(.*)摇了摇头。$",20)
	 if l==nil then
	   shutdown() --终止所有触发器
	   local b=busy.new()
		b.interval=0.5
		b.Next=function()
	        self:huayin(name,id)
		end
		b:check()
	   return
	 end
	 if string.find(l,"竖起了右手大拇指") then
	    print("............OK1...........",w[2])

	    shutdown() --终止所有触发器
	    if w[2]=="你" then

		 nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	        self:huayin_ok(name)
	      end
	      b:check()
		else
		  if self.xiulian=="false" then
		   self:huayin(name,id)
		 else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	    return
	 end
	if string.find(l,"这边你已经巡逻完了") then
	    print("............OK2...........",w[4])
	    shutdown() --终止所有触发器
	    if w[4]=="你" then

		 nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	        self:huayin_ok(name)
	      end
	      b:check()
		else
		  if self.xiulian=="false" then
		   self:huayin(name,id)
		 else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	   return
	 end

	if string.find(l,"加油，加油") then
	    print("............OK3...........",w[6])
	    shutdown() --终止所有触发器
	    if w[6]=="你" then

		  nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	         self.huayin_npc=name
             self:recover()
	      end
	      b:check()
		else
		 if self.xiulian=="false" then
		   self:huayin(name,id)
		 else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	    return
	end
	if string.find(l,"怎么还没去")  then
	   print("............OK4...........",w[8])
	   shutdown() --终止所有触发器
	    if w[8]=="你" then

		 nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	         self.huayin_npc=name
             self:recover()
	      end
	      b:check()
		else
		  if self.xiulian=="false" then
		   self:huayin(name,id)
		 else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	   return
	end

	if string.find(l,"摇了摇头") then
	    print("............OK5...........",w[10])
	    shutdown() --终止所有触发器
	    if w[10]=="你" then

		  nod=false
		  local b=busy.new()
	      b.interval=0.5
	      b.Next=function()
	         self:xunluo_again(name)
	      end
	      b:check()
		else
		  if self.xiulian=="false" then
		   self:huayin(name,id)
		  else
		   local b=busy.new()
	       b.interval=0.5
	       b.Next=function()
	        self:huayin(name,id)
	       end
	       b:check()
		 end
		end
	   return
	end
  end)
end


function xunluo:huayin_reply(name,id)
  wait.make(function()
     local l,w=wait.regexp("^(> |)"..name.."对着你点了点头。$|^(> |)"..name.."说道：「这边你已经巡逻完了，再去别的地方看看吧。」$|^(> |)"..name.."冲着你大喊：.*，加油，加油！$|^(> |)"..name.."说道：「咦，不是叫你去看看有没有可疑的人吗？怎么还没去？」$|^(> |)"..name.."说道：「等等，我正在检查呢。」$|^(> |)"..name.."说道：「先去别的地方看看，等会儿再来巡逻这儿。」$|^(> |)"..name.."对着你摇了摇头。$|^(> |)"..name.."说道：「你又没在巡逻，要我画印干嘛？」$",5)
    if l==nil then
	   self:huayin(name,id)
	   return
	end
	if string.find(l,"冲着你大喊") or string.find(l,"怎么还没去") then
       --保存 name id
	   self.huayin_npc=name
       self:recover()
	   return
	end
    if string.find(l,"右手大拇指") or string.find(l,"这边你已经巡逻完了") then
       self:huayin_ok(name)
	   return
	end
	if string.find(l,"对着你点了点头") then
	   print("************",name,"打听","*****************")
	   --BigData:Auto_catchData()
	   nod=true
	   self:wait_huayin(name,id)
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
	     self:dazuo() --打坐恢复内力
	   end
	   b:check()
	   return
	end
	if string.find(l,"等等，我正在检查呢") then
	   self:wait_huayin(name,id)
	   local b=busy.new()
	   b.interval=0.5
	   b.Next=function()
	     self:dazuo() --打坐恢复内力
	   end
	   b:check()
       return
 	end
	if string.find(l,"先去别的地方看看") then
	   self:xunluo_back(name)
	   return
	end

	if string.find(l,"摇了摇头") then
	   self:xunluo_again(name)
	   return
	end
	if string.find(l,"要我画印干嘛") then
	   self:Status_Check()
	   return
	end
  end)
end

function xunluo:huayin(name,id)
  world.Send("ask "..id.." about 画印")
  world.Send("unset ask")
  wait.make(function()
     local l,w=wait.regexp("^(> |)你向"..name.."打听有关『画印』的消息。$",5)
	 if l==nil then
	    self:huayin(name,id)
	    return
	 end
	 if string.find(l,"打听有关『画印』的消息") then
	   self:huayin_reply(name,id)
	   return
	 end
  end)
end

function xunluo:back()
   self:auto_kill()
   if self.huayin_npc=="张中" then
       local w=walk.new()
       w.walkover=function()
          self:here(2243,true)
       end
       w:go(2243)
   elseif self.huayin_npc=="颜垣" then
      local w=walk.new()
       w.walkover=function()
          self:here(2175,true)
       end
       w:go(2175)
   elseif self.huayin_npc=="辛然" then
       local w=walk.new()
       w.walkover=function()
          self:here(2178,true)
       end
       w:go(2178)
   elseif self.huayin_npc=="唐洋" then
       local w=walk.new()
       w.walkover=function()
          self:here(2173,true)
       end
       w:go(2173)
   elseif self.huayin_npc=="庄铮" then
       local w=walk.new()
       w.walkover=function()
          self:here(2455,true)
       end
       w:go(2455)
   elseif self.huayin_npc=="闻苍松" then
      local w=walk.new()
       w.walkover=function()
          self:here(2168,true)
       end
       w:go(2168)
   elseif self.huayin_npc=="殷野王" then
      local w=walk.new()
       w.walkover=function()
          self:here(2164,true)
       end
       w:go(2164)
   end
end

function xunluo:huayin_ok(name)
   if name=="张中" then
      self:step2()
   elseif name=="颜垣" then
      self:step3()
   elseif name=="辛然" then
      self:step4()
   elseif name=="唐洋" then
      self:step5()
   elseif name=="庄铮" then
      self:step6()
	elseif name=="闻苍松" then
	  self:step7()
	elseif name=="殷野王" then
	  self:reward()
   end
end

function xunluo:xunluo_again(name)
   nod=false
   if name=="张中" then
      self:step1()
   elseif name=="颜垣" then
      self:step2()
   elseif name=="辛然" then
      self:step3()
   elseif name=="唐洋" then
      self:step4()
   elseif name=="庄铮" then
      self:step5()
	elseif name=="闻苍松" then
	  self:step6()
	elseif name=="殷野王" then
	  self:step7()
   end
end

function xunluo:xunluo_back(name)
   nod=false
   if name=="颜垣" then
      self:step1()
   elseif name=="辛然" then
      self:step2()
   elseif name=="唐洋" then
      self:step3()
   elseif name=="庄铮" then
      self:step4()
	elseif name=="闻苍松" then
	  self:step5()
	elseif name=="殷野王" then
	  self:step6()
   end
end
--张中说道：「嗯，刚刚有弟子来报告说好象看见了不明身份的人，你最好再去看看。」
--张中冲着你大喊：壮士，加油，加油！
function xunluo:xl1()
   world.Execute("w;e;e;w;n;w;e;e;w;n;nu;nu;enter;out;sd;sd;w;w;w;e;s;s;s;w;e;s")
   self:here(2179)
end

function xunluo:xl2()
   world.Execute("n;n;e;e;s;w;w;n;e;e;e;e;s;w;w;e;e;e;w;ed;ed;e")
   self:here(2469)
end
function xunluo:xl3()
   world.Execute("w;wu;wu;n;n;ne;nw;s;n;e;w;w;w;s;s")
   self:here(2243,true)
end

function xunluo:xl4()
   world.Execute("e;s;s;se;nw;e;e;w")
   self:here(2168,true)
end

function xunluo:xl5()
  world.Execute("sd;se;se;wd;nd;ed;nd;wd;se;se;s;sd;ed;nd;wd;s;e;e")
  self:here(2082)
end

function xunluo:xl6()
  world.Execute("w;w;n;eu;su;wu;nu;n;nw;nw;eu;su;wu;su;eu;nw;nw;nu;n;n;s;w;e;e")
  local delay=function()
     world.Execute("w;s")
	 self:here(2164,true)
  end
  f_wait(delay,0.5)
end

function xunluo:step1()

	 	 	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="寻找张中",
	           task_step=2,
	           task_maxsteps=9,
	           task_location="2243",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	self.huayin_npc="张中"
	nod=false
   self:protect()
 local w=walk.new()
  w.walkover=function()
     self:here(2243)
  end
  w:go(2243)
end

--2243
function xunluo:step2()
	 	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="寻找颜垣",
	           task_step=3,
	           task_maxsteps=9,
	           task_location="2888",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	 nod=false

	self.huayin_npc="颜垣"
   self:protect()
 local w=walk.new()
  local al=alias.new()
  al.zishanlin_tiandifenglei=function()
    al:zishanlin_tiandifenglei_quick()
  end
  w.user_alias=al
  w.walkover=function()
     self:here(2888)
  end
  w:go(2888)
end

function xunluo:step3()


	 	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="寻找辛然",
	           task_step=4,
	           task_maxsteps=9,
	           task_location="2887",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	 	self.huayin_npc="辛然"
		nod=false
   self:protect()
 local w=walk.new()
   local al=alias.new()
  al.zishanlin_tiandifenglei=function()
    al:zishanlin_tiandifenglei_quick()
  end
  w.user_alias=al
  w.walkover=function()
     self:here(2887)
  end
  w:go(2887)
end

function xunluo:step4()

	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="寻找唐洋",
	           task_step=5,
	           task_maxsteps=9,
	           task_location="2890",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	self.huayin_npc="唐洋"
	nod=false
   self:protect()
  local w=walk.new()
    local al=alias.new()
  al.zishanlin_tiandifenglei=function()
    al:zishanlin_tiandifenglei_quick()
  end
  w.user_alias=al
  w.walkover=function()
     self:here(2890)
  end
  w:go(2890)

end

function xunluo:step5()


	 	 	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="寻找庄铮",
	           task_step=6,
	           task_maxsteps=9,
	           task_location="2889",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	    self.huayin_npc="庄铮"
		nod=false
   self:protect()
  local w=walk.new()
    local al=alias.new()
  al.zishanlin_tiandifenglei=function()
    al:zishanlin_tiandifenglei_quick()
  end
  w.user_alias=al
  w.walkover=function()
     self:here(2889)
  end
  w:go(2889)
end

function xunluo:step6()
 	--[[local win=window.new() --监控窗体
     win.name="status_window"
	 win:addText("label1","目前工作:巡逻")
	 win:addText("label2","目前过程:闻苍松")
     win:refresh()]]

	 	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="寻找闻苍松",
	           task_step=7,
	           task_maxsteps=9,
	           task_location="2168",
	           task_description="",
	      }
	       local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
	self.huayin_npc="闻苍松"
	nod=false
   self:protect()
--巨木旗
  local w=walk.new()
  w.walkover=function()
     self:here(2168)
  end
  w:go(2168)
end


function xunluo:step7()
	 	 	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="寻找殷野王",
	           task_step=8,
	           task_maxsteps=9,
	           task_location="2164",
	           task_description="",
	      }
		   local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()
   self.huayin_npc="殷野王"
   nod=false
   self:protect()
  --野王
  local w=walk.new()
  w.walkover=function()
     self:here(2164)
  end
  w:go(2164)
end

function xunluo:NextPoint()
   print("恢复子进程")
   coroutine.resume(xunluo.co)
end

function xunluo:follow_wulu(cmd)
  wait.make(function()
    world.Send("follow wulu")
	 local l,w=wait.regexp("^(> |)这里没有 wulu。$|^(> |)你决定跟随殷无禄一起行动。$|^(> |)你已经这样做了。",5)
	 if l==nil then
	    self:follow_wulu(cmd)
	    return
	 end
	 if string.find(l,"这里没有 wulu") then
		self:NextPoint()
		return
	 end
	 if string.find(l,"殷无禄") or string.find(l,"你已经这样做了") then
		cmd()
	    return
	 end
  end)
end

function xunluo:wulu(cmd)
  local w=walk.new()
  w.walkover=function()
     world.Send("ask yewang about yin wulu")
     --殷野王说道：「嗯，殷无禄好象在练武场一带巡逻。」
	  wait.make(function()
           local l,w=wait.regexp("^(> |)殷野王说道：「嗯，殷无禄好象在(.*)一带巡逻。」",5)
		   if l==nil then
		      self:wulu(cmd)
		      return
		   end
		   if string.find(l,"一带巡逻") then
			     local location=w[2]
		          print(location)
                 local n,rooms=Where("明教"..location)

				  local b
			       b=busy.new()
				   b.interval=0.5
	               b.Next=function()
				      print("创建进程")
				      xunluo.co=coroutine.create(function()
		                --self:Search(rooms,cmd)
						 for _,r in ipairs(rooms) do
						   print("查询房间号:",r)
	                       local w
	                        w=walk.new()
	                        w.walkover=function()
		                       self:follow_wulu(cmd)
	                        end
							--
	                        w:go(r)
	                        coroutine.yield()
						 end
                         self:wulu(cmd) --重新开始寻找
				      end)
					  self:NextPoint()
			       end
			       b:check()
			end
	  end)
  end
  w:go(2164)
end

function xunluo:full()

	 local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)

		local get_pot=h.pot-self.current_pot
		print(self.current_pot,"->",h.pot,":",get_pot)
		local get_exp=h.exps-self.current_exps
		print(self.current_exps,"->",h.exps,":",get_exp)
		if self.current_pot==0 or self.current_exps==0 then
		   get_pot=0
		   get_exp=0
		end
		 --[[world.AppendToNotepad (WorldName(),os.date()..": 巡逻经验:".. get_exp.." 潜能:"..get_pot.."\r\n")
		 local exps=nil
		  exps=world.GetVariable("get_exp")
		  if exps==nil then
		    exps=0
		  end
		  --exps=tonumber(exps)+get_exp
		  --world.SetVariable("get_exp",exps)
		  --world.AppendToNotepad (WorldName(),os.date().."目前获得总经验值"..exps.."\r\n")]]

	    if h.food<50 then
           print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
		       world.Send("ask xiao tong about 食物")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get zong zi;eat zong zi;eat zong zi;drop zong zi")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:full()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(2247) --299 ask xiao tong about 食物 ask xiao tong about 茶
		elseif h.drink<50  then
		   print("drink")
		   local w
		   w=walk.new()
		   w.walkover=function()
		       world.Send("ask xiao tong about 茶")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get tang;drink tang;drink tang;drink tang;drop tang")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:full()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(2247) --299 ask xiao tong about 食物 ask xiao tong about 茶
		else
		   self:jobDone()
		end
	  end
	h:check()
end

function xunluo:wei()
	  	local ts={
	           task_name="明教巡逻",
	           task_stepname="韦一笑交令",
	           task_step=9,
	           task_maxsteps=9,
	           task_location="",
	           task_description="",
	      }
	       local st=status_win.new()
        	st:init(nil,nil,ts)
	        st:task_draw_win()

  local w
  w=walk.new()
  w.walkover=function()
	 world.Send("give xunluo ling to wei yixiao")
	 wait.make(function()
	 --韦一笑在你的耳边悄声说道：你辛苦了，这些金子拿去好好快活一番吧。
	   local l,w=wait.regexp("^(> |)韦一笑在你的耳边悄声说道：你辛苦了，这些金子拿去好好快活一番吧。$|^(> |)韦一笑在你的耳边悄声说道：你辛苦了，这些银子拿去好好快活一番吧。$|^(> |)韦一笑在你的耳边悄声说道：你快去张教主那里一次，他好象有什么传闻要告诉你。$",10)
	   if l==nil then
	      self:wei()
		  return
	   end
	   if string.find(l,"你辛苦了") then
		   local b
		   b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		      self:full()
		   end
		   b:check()
	      return
	   end
	   if string.find(l,"他好象有什么传闻要告诉你") then
	      world.Send("set 九阳QUEST")
	      world.ColourNote("yellow","red","出九阳了yeah!")
		   world.AppendToNotepad (WorldName(),os.date()..":*****************************解出九阳***********************\r\n")
	      return
	   end
	 end)
  end
  w:go(2240)
end

function xunluo:check_ling()
    self.check_ling_count=self.check_ling_count+1 --加入计数器超过5次自动放弃
	if self.check_ling_count>5 then
	   self:giveup()
	   return
	end
   local sp=special_item.new()
  --[[ sp.check_weapon_finish=function()

   end
   sp.weapon_lost=function()

   end]]
       sp.check_items_over=function()
	      print("检查结束")
		for index,deal_function in pairs(sp.itemslist) do
		    --print("继续3",index)
            --print(sp.itemslistNum[index],"数量")
			if sp.itemslistNum[index]==nil then
			    local f=function()
	               self:get_ling()
	            end
	            self:wulu(f)
			else
			     self:wei()
			end
			break
        end
	   end
      local equip={}
	   equip=Split("<存在>巡逻令","|")
       sp:check_items(equip)
end

function xunluo:get_ling()
   -- 殷无禄在巡逻令上写了写东西。
   -- 殷无禄给你一片巡逻令。
   wait.make(function()
      local l,w= wait.regexp("^(> |)殷无禄给你一片巡逻令。$",5)
	  if l==nil then
	     self:check_ling()
	     return
	  end
	  if string.find(l,"殷无禄给你一片巡逻令") then
	     world.Send("follow none")
	     self:wei()
	     return
	  end
   end)
end

function xunluo:give_ling()

   world.Send("give xunluo ling to wulu")
   wait.make(function()
     local l,w=wait.regexp("^(> |)你给殷无禄一片巡逻令。$|^(> |)这里没有这个人。$",5)
	 if l==nil then
	    self:give_ling()
	    return
	 end
	 if string.find(l,"一片巡逻令") then
		self.check_ling_count=0
	    self:get_ling()
	    return
	 end
	 if string.find(l,"这里没有这个人") then
	   local f=function()
	      self:give_ling()
	   end
	   self:wulu(f)
	   return
	 end
   end)
end
--殷无禄说道：「唉，你怎么久才巡逻完，真是没用！」
function xunluo:reward(flag)
  f=function()
    wait.make(function()
      world.Send("ask wulu about 完成")
	   local l,w=wait.regexp("^(> |)殷无禄说道：「 好！"..self.playername.."你完成得很好，把令牌给我吧。」$|^(> |)殷无禄说道.*你怎么久才巡逻完.*$|^(> |)这里没有这个人。$|^(> |)殷无禄说道：在下是出来游山玩水的，不回答问题。$",5)
	   if l==nil then
	      self:reward()
		  return
	   end
	   if string.find(l,"这里没有这个人") then
	      self:reward()
		  return
	   end
	   if string.find(l,"把令牌给我吧") then
	       local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
	         self:give_ling()
		   end
		   b:check()
		  return
	   end
	   if string.find(l,"你怎么久才巡逻完") then
	      self:jobDone()
	      return
	   end
	   if string.find(l,"殷无禄说道：在下是出来游山玩水的，不回答问题") then
	      local f=function()
       		  self:reward(false)
		  end
		  f_wait(f,0.5)
		  return
	   end
	end)
  end
  if flag==false then
     f()
  else
     self:wulu(f)
  end

  --world.Send("ask wulu about 完成")
end

function xunluo:jobDone() --回调函数
  print("默认jobdone")

end

--[[你向殷无禄打听有关『放弃』的消息。
殷无禄对你失望极了：“你没救了。”
殷无禄说道：「你就先休息一会，待会再来试试巡逻吧。」
]]
function xunluo:giveup(flag)
  f=function()
     wait.make(function()
	    world.Send("ask wulu about 放弃")
		-- self:after_giveup()
	    local l,w=wait.regexp("^(> |)殷无禄对你失望极了：“你没救了。$|^(> |)殷无禄说道：「放弃？你根本就没有做，放弃什么啊？」$|^(> |)殷无禄说道：「你刚刚放弃，现在又要放弃什么啊？」$",5)
		if l==nil then
		  self:giveup()
		  return
		end
		if string.find(l,"你没救了") then
		   world.Send("follow none")
           local b=busy.new()
		   b.interval=0.5
		   b.Next=function()
		     self:jobDone()
		   end
		   b:check()
		  return
		end
		if string.find(l,"放弃什么啊") then
		   self:Status_Check()
		   return
		end
     end)
  end
  if flag==true then
     f()
  else
     self:wulu(f)
  end

end

function xunluo:Status_Check()

     --初始化
     local liao_percent=world.GetVariable("liao_percent") or 80
	 liao_percent=tonumber(liao_percent)
	local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
		self.current_exps=h.exps
		self.current_pot=h.pot
	    if h.food<70 then
           print("eat")
		   local w
		   w=walk.new()
		   w.walkover=function()
		       world.Send("ask xiao tong about 食物")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get zong zi;eat zong zi;eat zong zi;drop zong zi")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:Status_Check()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(2247) --299 ask xiao tong about 食物 ask xiao tong about 茶
		elseif h.drink<70  then
		   print("drink")
		   local w
		   w=walk.new()
		   w.walkover=function()
		       world.Send("ask xiao tong about 茶")
			   local b
			   b=busy.new()
			   b.interval=0.3
			   b.Next=function()
			      world.Execute("get tang;drink tang;drink tang;drink tang;drop tang")
				 local b2
				 b2=busy.new()
				 b2.interval=0.3
				 b2.Next=function()
				    self:Status_Check()
				 end
				 b2:check()
			  end
			  b:check()
		   end
		   w:go(2247) --299 ask xiao tong about 食物 ask xiao tong about 茶
		elseif  h.qi_percent<=liao_percent or h.jingxue_percent<=80 then
		    print("疗伤")
            local rc=heal.new()
			rc.saferoom=505
			--rc.teach_skill=teach_skill
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:liaoshang()
		elseif h.jingxue_percent<100 then
		    print("打通经脉")
            local rc=heal.new()
			--world.Send("set heal jing")
			rc.saferoom=505
			--rc.teach_skill=teach_skill --config 全局变量
			rc.heal_ok=function()
			    --world.Send("unset heal")
			   --heal_ok=true
			   self:Status_Check()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			-- rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   self:Status_Check()
			end
			rc:heal()
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		   --print(h.neili,h.max_neili*self.neili_upper," +++ ",self.neili_upper)
		    local x
			x=xiulian.new()
			x.halt=false
			x.min_amount=100
			x.safe_qi=h.max_qi*0.6
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun qi")
				  world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,3)
			    end
				if id==777 then
				   self:Status_Check()
				end
	           if id==202 then
	             local w
		         w=walk.new()
		         w.walkover=function()
			       x:dazuo()
		         end
		         w:go(2457)
			   end
			end
			x.success=function(h)
               --print(h.qi,h.max_qi*0.9)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
				  world.Send("drop xunluo ling")
			      world.Send("drop xunluo ling")
			      world.Send("drop xunluo ling")
			     self:ask_job()
			   else
	             print("继续修炼")
				 world.Send("yun qi")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  world.Send("drop xunluo ling")
			  world.Send("drop xunluo ling")
			  world.Send("drop xunluo ling")
			  self:ask_job()
			end
			b:check()
		end
	  end
	h:check()
end

--打坐部分 画印时候等待
function xunluo:dazuo()
  print("nod:",nod)
  print("xiulian:",self.xiulian)
  if nod==false then
   if self.xiulian=="false" then
      print("不打坐")
      return
   end
 end
   world.Send("unset 积蓄")
   local x
   x=xiulian.new()
   x.safe_qi=400
   x.min_amount=100
   x.fail=function(id)
      print(id)
	  if id==1 or id==777 then
	     --正循环打坐
		 print("正循环打坐")
		 Send("yun recover")
		 x:dazuo()
	  end
	  if id==201 then
	      world.Send("yun regenerate")
		  x:dazuo()
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
	  if (h.qi<=x.safe_qi+h.max_neili/2) and (h.neili<h.max_neili+10) then
		  print("正循环打坐")
		 Send("yun recover")
		 x:dazuo()
	  else
	     print("继续修炼")
		 x:dazuo()
	  end
   end
   x:dazuo()
end

-----战斗模块
--[[
一个人影突然从旁跳了出来，拦住你的去路！

探子恶狠狠地盯着你：臭贼，我看你这次往哪儿跑。
看起来探子想杀死你！

结果探子的大横穴被抓个正着，全身不由自主的一颤，顿时不可动弹。
> 探子转身几个起落就不见了。
--> 神秘人一言不发，闪身拦在你面前！
--]]

function xunluo:get_name()

end

function xunluo:auto_kill()
   world.ColourNote("salmon", "", "启动auto_kill")
   wait.make(function()
   --|^(> |)一个人影突然从旁跳了出来，拦住你的去路！$
      local l,w=wait.regexp("^(> |)(.*)恶狠狠地盯着你：.*我看你这次往哪儿跑。$",10)--一个人影突然从旁跳了出来，拦住你的去路！
	  --神秘人恶狠狠地盯着你：臭贼，我看你这次往哪儿跑。
      if l==nil then
	    self:auto_kill()
		return
	  end
	  if string.find(l,"我看你这次往哪儿跑") then
         world.ColourNote("salmon", "", w[2].."叫我看你这次往哪儿跑")
	     shutdown()
	     self.attacker_name=w[2]
	     self:wait_attacker_escape(w[2])
		 print("战斗开始")
		 self:combat()
	  end
	  wait.time(10)
   end)
end


function xunluo:protect()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)一言不发，闪身拦在你面前！$",5)
	 if l==nil then
	     self:protect()
	     return
	 end
	 if string.find(l,"闪身拦在你面前") then
	      print("保护函数触发！！")
		   shutdown()
	       self.attacker_name=w[2]
	       self:wait_attacker_escape(w[2])
		   self:combat()
		   return
	  end
   end)
end

function xunluo:find_attacker()

  local w=walk.new()
  w.walkover=function()
     --world.Execute("e;s;s;se;nw;e;e;w;set walk")
	 world.Execute("w;e;e;w;w;e;e;w;set walk")
	 wait.make(function()
	    local l,w=wait.regexp("^(> |)(.*)一言不发，闪身拦在你面前！$|^(> |)设定环境变量：walk \\= \\\"YES\\\"$",5)
	    if l==nil then
 		    self:find_attacker()
		   return
		end
		if string.find(l,"闪身拦在你面前") then
		   shutdown()
	       self.attacker_name=w[2]
	       self:wait_attacker_escape(w[2])
		   self:combat()
		   return
		end
		if string.find(l,"设定环境变量：walk") then
		   local f=function()
		     self:find_attacker()
		   end
		   f_wait(f,0.8)
		   return
		end
	 end)
  end
  w:go(2168)
end

function xunluo:combat()
    print("默认战斗开始")
end

function xunluo:attacker_escape()
end

function xunluo:wait_attacker_escape(attacker_name)
  wait.make(function()
   local l,w=wait.regexp("^(> |)(.*)转身几个起落就不见了。$",5)
	 if l==nil then
	    self:wait_attacker_escape(attacker_name)
	    return
	 end
	 if string.find(l,"转身几个起落就不见了") then
	    --print(murder_name,w[2])
	    if string.find(attacker_name,w[2]) then
		   self:attacker_escape()
		else
           self:wait_attacker_escape(attacker_name)
		end
	    return
	 end
	 wait.time(5)
  end)
end

--[[function xunluo:run(i)
     wait.make(function()
	   local l,w=wait.regexp("^(> |)你的动作还没有完成，不能移动。$|^(> |)你逃跑失败。$|^(> |)你的修为不够！$|^(> |)设定环境变量：action \\= \\\"逃跑\\\"$",1.5)
	   if l==nil then
	      self:run(i)
	      return
	   end
	   if string.find(l,"你的修为不够") then
	     i=i+1
		 self:flee(i)
	     return
	   end
	   if string.find(l,"你的动作还没有完成，不能移动") or string.find(l,"你逃跑失败") then
		  self:run(i)
	      return
	   end
	   if string.find(l,"设定环境变量：action") then
		 world.DoAfter(1.5,"set action 结束")
		 wait.make(function()
		    local l,w=wait.regexp("^(> |)设定环境变量：action \\= \\\"逃跑\\\"$|^(> |)设定环境变量：action \\= \\\"结束\\\"$",5)
			if l==nil then
			   self:run(i)
			  return
			end
			if string.find(l,"逃跑") then
			    i=i+1
		        self:flee(i)
			   return
			end
			if string.find(l,"结束") then
			   world.Send("unset wimpy")
			   shutdown()
			   self:giveup()
			   return
			end
			wait.time(5)
		 end)
	     return
	   end
	   wait.time(1.5)
  end)
end

function xunluo:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("寻找出口")
     local dx=_R.get_all_exits()
	 for _,d in ipairs(dx) do
	   print("exit:",d)
	 end
	 if i==nil or i>table.getn(dx) then
	    --获得随机方向
	     local n=table.getn(dx)
	     i=math.random(n)
		 print("随机:",i)
	 end
	 local run_dx=dx[i]
	 print(run_dx, " 方向")
	 local halt
	 if _R.roomname=="洗象池边" then
	    world.Send("alias pfm "..run_dx..";set action 逃跑")
	 else
	    world.Send("alias pfm halt;"..run_dx..";set action 逃跑")
	 end
	 world.Send("set wimpy 100")
	 world.Send("set wimpycmd pfm\\hp")
	 self:run(run_dx,i)
   end
   _R:CatchStart()
end]]

function xunluo:recover()
	local h
	h=hp.new()
	h.checkover=function()
        if h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover()
			end
			rc:heal(false)
		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.8
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				   world.Send("yun qi")
				   world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,4)
			    end
				if id==777 then
				   self:recover()
				end
	           if id==202 then
	             local w
				  w=walk.new()
				  w.walkover=function()
					 x:dazuo()
				  end
				  local _R
				  _R=Room.new()
				  R.CatchEnd=function()
					local count,roomno=Locate()
					local r=nearest_room(roomno)
					 w:go(r)
				  end
				  _R:CatchStart()
			   end
			end
			x.success=function(h)
			   world.Send("yun recover")
			   if h.neili>math.floor(h.max_neili*self.neili_upper) and h.qi>=h.max_qi*0.8  then
				   self:auto_kill()
			       self:find_attacker()
			   else
	             print("继续修炼")
		         x:dazuo()
			   end
			end
			x:dazuo()
		elseif h.qi<=h.max_qi*0.8  then
		     world.Send("yun recover")
			 self:recover()
		else
			local b
			b=busy.new()
			b.Next=function()
			  self:auto_kill()
              self:find_attacker()
			end
			b:check()
		end
	end
	h:check()
end

function xunluo:recover2()
	--[[local win=window.new() --监控窗体
     win.name="status_window"
	 win:addText("label1","目前工作:巡逻")
	 win:addText("label2","目前过程:疗伤回程")
     win:refresh()]]

	local h
	h=hp.new()
	h.checkover=function()
        if h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			    self:recover2()
			end
			rc:heal(false)
		elseif h.neili<math.floor(h.max_neili*1.2)  then
		    local x
			x=xiulian.new()
			x.min_amount=100
			x.safe_qi=h.max_qi*0.8
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				   world.Send("yun qi")
				   world.Send("yun jing")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,4)
			    end
				if id==777 then
				   self:recover2()
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
					local r=nearest_room(roomno)
					 w:go(r)
				  end
				  _R:CatchStart()
			   end
			end
			x.success=function(h)
			   world.Send("yun recover")
			   if h.neili>math.floor(h.max_neili*1.2) then
				   self:auto_kill()
			       self:back()
			   else
	             print("继续修炼")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			local b
			b=busy.new()
			b.Next=function()
			  self:auto_kill()
              self:back()
			end
			b:check()
		end
	end
	h:check()
end
