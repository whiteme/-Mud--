 --[[2:                    【星宿派抢劫任务介绍】
 3: ──────────────────────────────
 4:
 5:     星宿派掌门丁春秋一生精於炼毒，星宿派的功夫以毒见长，掌上
 6: 带毒、化功大法吸人内力化毒，江湖上人提起，无不谈丁色变。当然
 7: 也有武林肖小前去投靠老仙，为老仙卖命。
 8:
 9: ──────────────────────────────
10:                         【任务要求】
11: ──────────────────────────────
12:
13:     经验值大于200k，小于1m，负神大于10k。
14:
15: ──────────────────────────────
16:                         【任务过程】
17: ──────────────────────────────
18:
19:     拿了duandi后，到黯然子处，ask anran about 抢劫。然后黯然
20: 子会叫你去丝绸之路中的一个地方(随机)等他，你就马上去那里，过
21: 一会他就会来的；再和他多等一会，就会有一队骆驼商队经过，这时
22: 黯然子会叫你 qiang商队，你敲完指令后，就会有保护商队的保镖出
23: 现和你对杀，而商队也趁机逃跑了。系统会不断提示你商队逃去了哪
24: 里，而你杀完一开始的保镖后，就马上要赶去商队所在的地方 qiang
25: ，然后再继续杀保镖，保镖的数量是由你的经验决定的。商队的活动
26: 范围是在嘉裕关西门到伊梨，一但他逃出这个范围，就任务失败，所
27: 以杀保镖的速度一定要快。
28:     如果不能完成任务需要等待任务时间过去，才能再领新的任务
29:
30:
31:
黯然子阴阴一笑，说道：这两天会有一队骆驼商队经过，你够胆就和我一起去看看吧。
黯然子说道：「我还有些事要办，你先去伊犁河等我。」
 首先到星宿日月洞丁春秋那里，敲入 flatter 星宿老仙，德配天地，威震
寰宇，古今无比。100K-300K(狮吼子)，300K-500K(天狼子)，500K-800K(摘星子)
，ask XXX about 老仙，他们会给你一个短笛。
 ]]
require "wait"
require "map"
require "cond"
require "status_win"
qiangjie={
  new=function()
     local qj={}
	 setmetatable(qj,{__index=qiangjie})
	 return qj
  end,
  co=nil,
  neili_upper=1.5,
  biaoshi_num=2,
  id="hubiao biaoshi",
}

function qiangjie:combat()

end


function qiangjie:recover()
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
			      print("出发！")
				  world.SetVariable("qj_loc_refresh","true")--重新找商队
				  self:check(nil)
				  --self:shangdui()
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
			   world.SetVariable("qj_loc_refresh","true")--重新找商队
			   self:check(nil)
			end
			b:check()
		end
	end
	h:check()
end

function qiangjie:biaoshi_escape() --回调函数
end

function qiangjie:biaoshi_leave()
--跳出战圈，转身几个起落就不见了。
    --print("biaoshi_leave")
  wait.make(function()
     local l,w=wait.regexp("^(> |)护镖镖师跳出战圈，转身几个起落就不见了。$",10)

	 if l==nil then
	    self:biaoshi_leave()
	    return
	 end
	 if string.find(l,"转身几个起落就不见了") then
        print("leave")
	   self.biaoshi_num=self.biaoshi_num-1
	   -- print("镖师数量:"..self.biaoshi_num)
	   if self.biaoshi_num<=0 then
	        self:biaoshi_escape()
		else
		    self:biaoshi_leave()
	   end
	   return
	 end

  end)
end
--[[
骆驼商队好象逃往了石门一带。
突然从商队后窜出一个护镖镖师，二话不说就扑向了你！
看起来护镖镖师想杀死你！
护镖镖师
不在危险名单中: 护镖镖师
突然从商队后窜出一个护镖镖师，二话不说就扑向了你！
看起来护镖镖师想杀死你！
护镖镖师
不在危险名单中: 护镖镖师]]
function qiangjie:qiang()
	local ts={
	           task_name="星宿抢劫",
	           task_stepname="抢劫开始",
	           task_step=4,
	           task_maxsteps=5,
	           task_location=world.GetVariable("qj_loc") or "",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()


  world.Send("qiang")
  --
  wait.make(function()
     local l,w=wait.regexp("^(> |)突然从商队后窜出一个护镖镖师，二话不说就扑向了你！$|^(> |).*见已经无人保护，在你的威胁下，只得停了下来，将所带的财物乖乖地献上！$|^(> |)你这奸贼，竟敢光天化日之下拦截商队，不怕被打入天牢吗？$｜^(> |)护镖镖师看来武功不弱，你还是先打发了面前这个再说吧！$|^(> |)什么.*$")
   if string.find(l,"扑向了你") or string.find(l,"护镖镖师看来武功不弱") then
      self.biaoshi_num=2
	 -- print("___________________________________________________")
      self:biaoshi_leave()
	  self:combat()
      return
   end
   if string.find(l,"什么") then
      print("??")
	  world.SetVariable("qj_loc_refresh","true")--重新找商队
	  self:shangdui()
      return
   end
   if string.find(l,"不怕被打入天牢吗") then
       self:NextPoint()
	   return
   end
	if string.find(l,"将所带的财物乖乖地献上") then
	   self:reward()
	   return
	 end

  end)

end

function qiangjie:check(room)
  wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*骆驼商队.*$|^(> |)设定环境变量：look \\= 1$",15)
	  if l==nil then
	     self:check(room)
		 return
	  end
	  if string.find(l,"设定环境变量：look") then
	     if roomno==nil then
		    self:shangdui()
		    return
		 end
		  local f=function(r)
		     if r[1]==room then
			    self:NextPoint()
			 else
			    print("没有走到指定房间")
	            local w=walk.new()
		        w.walkover=function()
			      print("walk 事件")
		          self:check(room)
		        end
			    w:go(room)
			 end
		  end
		  WhereAmI(f,10000)
	     return
	  end
	  if string.find(l,"骆驼商队") then
	     self:qiang()
	     return
	  end
	  wait.time(15)
   end)
end

local shangdui_Place={}

shangdui_Place["嘉峪关西城门"]=1864
shangdui_Place["丝绸之路"]=1865
shangdui_Place["仙人崖"]=1866
shangdui_Place["伊犁河"]=1971
shangdui_Place["惠远"]=1970
shangdui_Place["天山脚下"]=1963
shangdui_Place["兴隆山"]=2091
shangdui_Place["鸣沙山"]=1879
shangdui_Place["吐谷浑伏俟城"]=1875
shangdui_Place["人头疙瘩"]=1876
shangdui_Place["沙洲"]=1874
shangdui_Place["胭脂山"]=1974
shangdui_Place["石门"]=1590

--[[
mapping *dest = ({
([ "name":"yilihe",
           "context": ({
		"/d/xingxiu/yili/yili","/d/xingxiu/shanjiao","/d/xingxiu/silk9","/d/xingxiu/silk8","/d/xingxiu/silk7",
		"/d/xingxiu/silk6","/d/xingxiu/silk5","/d/xingxiu/silk4","/d/xingxiu/silk3","/d/xingxiu/silk2",
		"/d/xingxiu/silk1","/d/xingxiu/silk",
})]),

Start_Place["伊犁河"]=1971

([ "name":"jygw",
           "context": ({
		"/d/xingxiu/silk","/d/xingxiu/silk1","/d/xingxiu/silk2","/d/xingxiu/silk3","/d/xingxiu/silk4",
		"/d/xingxiu/silk5","/d/xingxiu/silk6","/d/xingxiu/silk7","/d/xingxiu/silk8","/d/xingxiu/silk9",
		"/d/xingxiu/shanjiao","/d/xingxiu/yili/yili",
})]),

Start_Place["嘉峪关西城门"]=1864
([ "name":"silk",
           "context": ({
		"/d/xingxiu/silk1","/d/xingxiu/silk2","/d/xingxiu/silk3","/d/xingxiu/silk4","/d/xingxiu/silk5a",
		"/d/xingxiu/silk7a","/d/xingxiu/silk7","/d/xingxiu/silk8","/d/xingxiu/silk9","/d/xingxiu/shanjiao",
		"/d/xingxiu/yili/yili",
})]),
([ "name":"silk1b",
           "context": ({
		"/d/xingxiu/silk1","/d/xingxiu/silk2","/d/xingxiu/silk3","/d/xingxiu/silk3a","/d/xingxiu/silk3b",
		"/d/xingxiu/silk3c","/d/xingxiu/silk7a","/d/xingxiu/silk7","/d/xingxiu/silk8","/d/xingxiu/silk10",
		"/d/xingxiu/yili/yili",
})]),

仙人崖=1866
([ "name":"yili",
           "context": ({
		"/d/xingxiu/silk10","/d/xingxiu/silk8","/d/xingxiu/silk7","/d/xingxiu/silk7a","/d/xingxiu/silk5a",
		"/d/xingxiu/silk4","/d/xingxiu/silk3","/d/xingxiu/silk2","/d/xingxiu/silk1","/d/xingxiu/silk1a",
		"/d/xingxiu/silk1b","/d/xingxiu/silk",
})]),
Start_Place["伊犁"]=1970

([ "name":"shanjiao",
           "context": ({
		"/d/xingxiu/silk9","/d/xingxiu/silk8","/d/xingxiu/silk7","/d/xingxiu/silk7a","/d/xingxiu/silk3c",
		"/d/xingxiu/silk3b","/d/xingxiu/silk3a","/d/xingxiu/silk3","/d/xingxiu/silk2","/d/xingxiu/silk1",
		"/d/xingxiu/silk",
})]),
Start_Place["天山脚下"]=1963

([ "name":"silk5b",
           "context": ({
		"/d/xingxiu/silk5","/d/xingxiu/silk5a","/d/xingxiu/silk7a","/d/xingxiu/silk3c","/d/xingxiu/silk3b",
		"/d/xingxiu/silk3a","/d/xingxiu/silk3","/d/xingxiu/silk2","/d/xingxiu/silk1","/d/xingxiu/silk1a",
		"/d/xingxiu/silk1b","/d/xingxiu/silk",
})]),
Start_Place["兴隆山"]=2091

([ "name":"silk3a",
           "context": ({
		"/d/xingxiu/silk3b","/d/xingxiu/silk3c","/d/xingxiu/silk7a","/d/xingxiu/silk5a","/d/xingxiu/silk5",
		"/d/xingxiu/silk6","/d/xingxiu/silk7","/d/xingxiu/silk8","/d/xingxiu/silk9","/d/xingxiu/shanjiao",
		"/d/xingxiu/yili/yili",
})]),
鸣沙山=1879
([ "name":"silk8",
           "context": ({
		"/d/xingxiu/silk7","/d/xingxiu/silk6","/d/xingxiu/silk5","/d/xingxiu/silk5a","/d/xingxiu/silk7a",
		"/d/xingxiu/silk3c","/d/xingxiu/silk3b","/d/xingxiu/silk3a","/d/xingxiu/silk3","/d/xingxiu/silk2",
		"/d/xingxiu/silk1","/d/xingxiu/silk",
})]),
Start_Place["吐谷浑伏俟城"]=1875
});]]

function qiangjie:shangdui()

   local location=world.GetVariable("qj_loc") or ""
   -- print(location," why")
   if location=="fail" then
      print("失败")
      self:Status_Check()
      return
	else
	  world.SetVariable("qj_loc_refresh","false")
   end
   local rooms={}
   if shangdui_Place[location]==nil then
     print("没有找对对应地点:",location)
     local n
	 n,rooms=Where(location)
   else
    local room=shangdui_Place[location]

	table.insert(rooms,room)
   end
	rooms=depth_search(rooms,1)  --范围查询
	   qiangjie.co=coroutine.create(function()
	    for _,r in ipairs(rooms) do
		    local refresh=world.GetVariable("qj_loc_refresh") or "false"
           if refresh=="true" then
		      print("地理位置刷新了!!")
		       self:shangdui()
		       return
		   end

          local w
		  w=walk.new()
		  w.walkover=function()
		    self:check(r)
		  end
		  w:go(r)
		  coroutine.yield()
	    end
         local f=function()
		    print("重新找商队")
			 world.SetVariable("qj_loc_refresh","true")--重新找商队
		    self:shangdui()
		 end
		 f_wait(f,1.5)
	   end)
	   self:NextPoint()
end


function qiangjie:NextPoint()
   print("进程恢复")
   coroutine.resume(qiangjie.co)
end



--> 骆驼商队好象逃往了胭脂山一带。

function qiangjie:wait()
    --黯然子对着你大声命令道：你快抢(qiang)商队，我来对付其他人！
	--黯然子对着你大声命令道：你快抢(qiang)商队，我来对付其他人！
	wait.make(function()
	    local l,w=wait.regexp("^(> |)猎物终于出现了！$|^(> |)黯然子对着你大声命令道：你快抢.*商队，我来对付其他人！$",10)
		if l==nil then
		   world.Send("look")
		   world.Send("flower")
           self:wait()
		   return
		end
		if string.find(l,"黯然子对着你大声命令") or string.find(l,"猎物终于出现了") then
		   world.Send("say 打劫！！男的左边，女的右边，人妖站当中！")
		   world.AddTriggerEx ("qj1", "^(> |)骆驼商队好象逃往了(.*)一带。$", "world.SetVariable(\"qj_loc_refresh\",\"true\")\nprint(\"%2\")\nworld.SetVariable(\'qj_loc\',\"%2\")", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)
           world.AddTriggerEx ("qj2", "^(> |)骆驼商队成功地逃进了城镇。$", "world.SetVariable(\"qj_loc_refresh\",\"true\")\nworld.SetVariable(\'qj_loc\','fail')", trigger_flag.RegularExpression  + trigger_flag.Replace+trigger_flag.Enabled, custom_colour.NoChange, 0, "", "", 12, 49)


		   self:qiang()
		   return
		end
	end)
end

function qiangjie:equipments()
	   local sp=special_item.new()
       sp.cooldown=function()
           self:ask_job()
       end
       local equip={}
	   equip=Split("<获取>火折|<获取>紫玉短笛","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

function qiangjie:anran(room)
  wait.make(function()
      world.Execute("look;set look 1")
	  local l,w=wait.regexp("^(> |).*黯然子.*$|^(> |)设定环境变量：look \\= 1$",15)
	  if l==nil then
	     self:anran(room)
		 return
	  end
	  if string.find(l,"设定环境变量：look") then
		  local f=function(r)
		     if r[1]==room then
			    print("到达目的地！等待！")
			    self:wait()
			 else
			    print("没有走到指定房间")
	            local w=walk.new()
		        w.walkover=function()
			      print("walk 事件")
		          self:anran(room)
		        end
			    w:go(room)
			 end
		  end
		  WhereAmI(f,10000)
	     return
	  end
	  if string.find(l,"黯然子") then
	     self:wait()
	     return
	  end
	  wait.time(15)
   end)
end
--[[
mapping *quest = ({
  (["name":                "yilihe",
    "start" :              "/d/xingxiu/yili/yilihe",
    "place" :              "伊犁河", ]),
  (["name":                "jygw",
    "start" :              "/d/xingxiu/jygw",
    "place" :              "嘉峪关西城门",]),
  (["name":                "silk",
    "start" :              "/d/xingxiu/silk",
    "place" :              "嘉峪关以西的丝绸之路",]),
  (["name":                "silk1b",
    "start" :              "/d/xingxiu/silk1b",
    "place" :              "仙人崖",]),
  (["name":                "yili",
    "start" :              "/d/xingxiu/yili/yili",
    "place" :              "伊犁",]),
  (["name":                "shanjiao",
    "start" :              "/d/xingxiu/shanjiao",
    "place" :              "天山脚下",]),
  (["name":                "silk5b",
    "start" :              "/d/xingxiu/silk5b",
    "place" :              "兴隆山",]),
  (["name":                "silk3a",
    "start" :              "/d/xingxiu/silk3a",
    "place" :              "鸣沙山",]),
  (["name":                "silk8",
    "start" :              "/d/xingxiu/silk8",
    "place" :              "吐谷浑伏俟城",]),
});    ]]

local Start_Place={}
Start_Place["伊犁河"]=1971
Start_Place["嘉峪关西城门"]=1864
Start_Place["嘉峪关以西的丝绸之路"]=1865
Start_Place["仙人崖"]=1866
Start_Place["伊犁"]=1970
Start_Place["天山脚下"]=1963
Start_Place["兴隆山"]=2091
Start_Place["鸣沙山"]=1879
Start_Place["吐谷浑伏俟城"]=1875

--商队在这里呢，快抢(qiang)啊！


function qiangjie:find(location)
	local ts={
	           task_name="星宿抢劫",
	           task_stepname="等候商队",
	           task_step=3,
	           task_maxsteps=5,
	           task_location=location,
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()

	 local b
	 b=busy.new()
	 b.interval=0.5
	 b.Next=function()
	     local r=Start_Place[location]

          local w
		  w=walk.new()
		  w.walkover=function()
		    self:anran(r)
		  end
		  w:go(r)

	 end
	 b:check()

end

--[[function qiangjie:shangdui()
--黯然子说道：「我还有些事要办，你先去仙人崖等我。」
--黯然子说道：「我还有些事要办，你先去伊犁河等我。」
   wait.make(function()
      local l,w=wait.regexp("",5)
	  if l==nil then
	      self:ask_job()
	      return
	  end


   end)
end]]
--黯然子阴阴一笑，说道：这两天会有一队骆驼商队经过，你够胆就和我一起去看看吧。
--黯然子对着你点了点头。
--黯然子说道：「好，我们就在这里等着他们来吧。」
--只听一阵骆驼风铃声传来，一只骆驼商队出现在眼前！
--黯然子说道：「我还有些事要办，你先去仙人崖等我。」
--黯然子对着你大声命令道：你快抢(qiang)商队，我来对付其他人！
--骆驼商队好象逃往了鸣沙山一带。
--骆驼商队成功地逃进了城镇。
--护镖镖师跳出战圈，转身几个起落就不见了。
--黯然子阴阴一笑，说道：这两天会有一队骆驼商队经过，你够胆就和我一起去看看吧。
function qiangjie:fail(id)
end

function qiangjie:ask_job()
	local ts={
	           task_name="星宿抢劫",
	           task_stepname="询问地点",
	           task_step=2,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
    w.walkover=function()
        world.Send("ask anran about 抢劫")

		-- world.Send("set ask")
	     --world.Send("unset ask")
		wait.make(function()
		   local l,w=wait.regexp("^(> |)黯然子说道：「我还有些事要办，你先去(.*)等我。」$|^(> |)黯然子说道：「我现在还没有得到任何消息，你等会儿再来吧。」$|^(> |)这里没有这个人。$",5)
		   if l==nil then
		      self:ask_job()
		      return
		   end
		   if string.find(l,"我现在还没有得到任何消息") or string.find(l,"这里没有这个人") then
		       self.fail(102)
		      return
		   end
	       if string.find(l,"我还有些事要办") then
		     print(w[2],"地点")
	         local location=w[2]
	          self:find(location)
	          return
	       end
		end)
		--self:shangdui()
    end
    w:go(1968)
end

function qiangjie:get_reward()
  --黯然子对你说道：你这次做得极为出色，这是你该得的部分，拿去吧！
  wait.make(function()
    local l,w=wait.regexp("^(> |)黯然子对你说道：你这次做得极为出色，这是你该得的部分，拿去吧！$",10)
	 if l==nil then
	     self:get_reward()
	     return
	 end
	 if string.find(l,"这是你该得的部分") then
	     self:jobDone()
	     return
	 end
  end)
end

function qiangjie:reward()
	local ts={
	           task_name="星宿抢劫",
	           task_stepname="分赃",
	           task_step=5,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
   local w=walk.new()
    w.walkover=function()
        world.Send("give prize to anran")

		-- world.Send("set ask")
	     --world.Send("unset ask")
		wait.make(function()
		   local l,w=wait.regexp("^(> |)你给黯然子一包红货。$",5)
		   if l==nil then
		      self:reward()
		      return
		   end
	       if string.find(l,"你给黯然子一包") then
		       world.DeleteTrigger("qj1")
			   world.DeleteTrigger("qj2")
			   self:get_reward()
		     -- self:jobDone()
	          return
	       end
		end)
		--self:shangdui()
    end
    w:go(1968)
end

function qiangjie:jobDone()
end

function qiangjie:eat()
    local w=walk.new()
	w.walkover=function()
	      world.Execute("get cai yao")
		  world.Execute("eat cai yao;eat cai yao;eat cai yao;drop cai yao")
		 local f
		  f=function()
			self:full()
		  end
		  f_wait(f,1.5)
	end
	w:go(2367)
end

function qiangjie:drink()
     local w=walk.new()
	   w.walkover=function()
	        world.Send("ask chu about 水")

		 local f
		  f=function()
			 world.Execute("get hulu")
		     world.Execute("drink hulu;drink hulu;drink hulu;drop hulu")
			self:full()
		  end
		  f_wait(f,1.5)
		end
		w:go(2367) --春在楼 976
end

function qiangjie:full()
   local h
	h=hp.new()
	h.checkover=function()
	    print(h.food,h.drink)
	    if h.food<30 or h.drink<30 then
		     if h.food<30 then
			    self:eat()
			 elseif h.drink<30 then
			    self:drink()
			 end
		elseif h.qi_percent<=30 or h.jingxue_percent<=80 then
		    print("疗伤")
            local rc=heal.new()
			rc.teach_skill=teach_skill --config 全局变量
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:liaoshang()
   		elseif h.jingxue_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal(false,true)
		elseif h.qi_percent<100 then
			print("打通经脉")
            local rc=heal.new()
			rc.saferoom=505
			rc.heal_ok=function()
			   self:full()
			end
			rc:heal(true,false)

		elseif h.neili<math.floor(h.max_neili*self.neili_upper) then
		    local x
			x=xiulian.new()
			x.safe_qi=h.max_qi*0.5
			x.limit=true
			x.fail=function(id)
             --print(id)
				if id==201 or id==1 then
				  world.Send("yun regenerate")
				  world.Send("yun recover")
	              local f
		          f=function() x:dazuo() end  --外壳
				  f_wait(f,0.5)
			    end
				if id==777 then
				  self:full()
				end
			   if id==202 then
			   --最近房间
				  local _R
                  _R=Room.new()
                  _R.CatchEnd=function()
                    local count,roomno=Locate(_R)
					local target_roomno=nearest_room(roomno)
                    local w
		            w=walk.new()
		            w.walkover=function()
			          self:full()
		            end
		            w:go(1968)
                  end
                 _R:CatchStart()
			   end
			end
			x.success=function(h)
               print("内力:",h.max_neili*self.neili_upper)
			   --print(h.neili,h.max_neili*2-200)
			   if h.neili>=math.floor(h.max_neili*self.neili_upper) then
			     world.Send("yun recover")
			     self:equipments()
			   else
	             print("继续修炼")
				 world.Send("yun recover")
		         x:dazuo()
			   end
			end
			x:dazuo()
		else
			--print(h.neili,h.max_neili*2-200)
			local b
			b=busy.new()
			b.Next=function()
			  self:equipments()
			end
			b:check()
		end
	end
	h:check()
end

function qiangjie:Status_Check()
	local ts={
	           task_name="星宿抢劫",
	           task_stepname="打坐",
	           task_step=1,
	           task_maxsteps=5,
	           task_location="",
	           task_description="",
	}
	local st=status_win.new()
	st:init(nil,nil,ts)
	st:task_draw_win()
	local cd=cond.new()
	cd.over=function()
	          print("检查状态")
		     if table.getn(cd.lists)>0 then
		       local sec=0
		       for _,i in ipairs(cd.lists) do
			     if i[1]=="星宿掌毒" then
				   print("中毒了")
			       sec=i[2]
				    local rc=heal.new()
			        rc.saferoom=505
			        rc.heal_ok=function()
			          self:Status_Check()
			        end
			        rc:qudu()
				    return
			     end
				 if i[1]=="内伤" or i[1]=="七伤拳内伤" then
				    print("内伤")
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

function qiangjie:flee(i)
  world.Send("go away")
  local _R
   _R=Room.new()
   _R.CatchEnd=function()
    print("寻找出口")
     local dx=_R:get_all_exits(_R)
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
end
