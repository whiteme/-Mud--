--[[恭喜你！你成功的完成了华山任务！你被奖励了：
一百一十五点经验!
三十九点潜能!
六十三点正神！

恭喜你！你成功的完成了送信任务！你被奖励了：
一百三十二点经验!
四十点潜能!]]
reward={
  new=function()
    local rc={}
    setmetatable(rc,reward)
	return rc
  end,
  job_name="",
  exps_num="",
  pots_num="",
  shen_num="",
  gold_num="",
}
reward.__index=reward
---你被奖励了四百三十四点经验，九十四点潜能！你感觉邪恶之气更胜从前！
--你觉得脑中豁然开朗，增加了八十五点潜能和二百零一点经验！
--恭喜你！你成功的完成了雪山任务！你被奖励了：
--四千零十七点经验!
--一千三百三十九点潜能!
--二千四百九十二点负神！
--一个通宝！
--你获得了一百四十六点经验，三十二点潜能！你的侠义正气增加了！

function reward:get_reward()
   --world.Send("set reward")
   wait.make(function()
     local l,w=wait.regexp("^(> |)恭喜你！你成功的完成了(.*)任务！你被奖励了：$|^(> |)设定环境变量：reward \\= \\\"YES\\\"$|^(> |)你被奖励了(.*)点经验，(.*)点潜能，(.*)两黄金.*$|^(> |)你被奖励了(.*)点经验，(.*)点潜能.*|^(> |)你获得了(.*)点经验，(.*)点潜能.*$",15)
       if l==nil then
		  self:finish()
	      return
	   end
	   if string.find(l,"设定环境变量") then
		  world.Send("unset reward")
	      return
	   end

	   if string.find(l,"恭喜你") then
	      --print(w[2])
	      self.job_name=w[2]
	      self:exps()
	      return
	   end
	   if string.find(l,"你获得了") then
	      --string.find(l,"你被奖励") then
	      self.pots_num=ChineseNum(w[13])
		  self.exps_num=ChineseNum(w[12])
          self:finish()
	      return
	   end
	   if string.find(l,"两黄金") then

		   self.pots_num=ChineseNum(w[6])
		  self.exps_num=ChineseNum(w[5])
		  self.gold_num=ChineseNum(w[7])
          self:finish()
	      return
	   end
	   if string.find(l,"你被奖励") then
	      self.pots_num=ChineseNum(w[10])
		  self.exps_num=ChineseNum(w[9])
		  --self.gold_num=ChineseNum(w[13])

          self:finish()
	      return
	   end
   end)

end

function reward:exps()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)点经验!$|^(> |)设定环境变量：reward \\= \\\"YES\\\"$",5)
       if l==nil then
		  self:exps()
	      return
	   end
	   if string.find(l,"点经验") then

	      self.exps_num=ChineseNum(w[2])
		  print(self.exps_num)
	      self:pots()
	      return
	   end
	   if string.find(l,"设定环境变量") then
	      world.Send("unset reward")
	      self:finish()
	      return
	   end
   end)
end

function reward:pots()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)点潜能!$|^(> |)设定环境变量：reward \\= \\\"YES\\\"$",5)
       if l==nil then
		  self:pots()
	      return
	   end
	   if string.find(l,"点潜能") then
	      self.pots_num=ChineseNum(w[2])
		  print(self.pots_num)
	      --self:shen()
		  self:finish()
	      return
	   end
	    if string.find(l,"设定环境变量") then
		  world.Send("unset reward")
	      self:finish()
	      return
	   end
   end)
end

function reward:shen()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)点(.*)神！$|^(> |)设定环境变量：reward \\= \\\"YES\\\"$",5)
       if l==nil then
		  self:shen()
	      return
	   end
	    if string.find(l,"设定环境变量") then
		  world.Send("unset reward")
	      self:finish()
	      return
	   end
	   if string.find(l,"神") then
	     if w[3]=="正" then
	         self.shen_num=ChineseNum(w[2])
		 else
		     self.shen_num=-1*ChineseNum(w[2])
		 end
		 print(self.shen_num)
		 self:finish()
	      return
	   end
   end)
end

function reward:finish()
   --写入
   print("结束")
   --self:callback()
  -- world.AppendToNotepad (WorldName().."_奖励:",os.date()..": "..self.job_name.. " 经验:"..self.exps_num.." 潜能:"..self.pots_num.."\r\n")
end
