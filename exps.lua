

exps={
  new=function()
    local e={}
    setmetatable(e,exps)

	return e
  end,
  --start_time=os.time(),
}
exps.__index=exps
function exps:reset()
  print("经验值计时开始!!")
  world.SetVariable("get_exp",0)
  --self.start_time=os.time()
end

function exps:check()
 --[[local sec=os.time()-self.start_time
 local per_exps=tonumber(GetVariable("get_exp"))*3600/tonumber(sec)
 per_exps=math.floor(per_exps)
 local connect_hour=math.floor(sec/3600)
 local connect_mins=math.floor((sec-connect_hour*3600)/60)
 local connect_sec=sec-connect_hour*3600-connect_mins*60]]
 if package.loaded["hubiao"]  ~= nil then
   hubiao.master_ready=false --关闭护镖的判断变量
   hubiao.child_ready=false --关闭护镖判断变量
 end
  world.Send("exp")
   wait.make(function()
       local l,w=wait.regexp("^(> |)您本次在线(.*)。$",10)
	   if l==nil then
	      self:check()
	      return
	   end
      if string.find(l,"您本次在线") then
	      local connect_hour=w[2]
		  world.SetVariable("connect_hour",connect_hour)
		  self:get_exps_add()
		  self:get_per_exps_add()
	      --self:get_exps_end()
	      return
      end
  end)
end

--您本次在线二小时五十四分二十九秒。
--经验值增加了4006点。
--每小时进帐：一千三百二十点经验。
function exps:get_exps_add()
   wait.make(function()
    local l,w=wait.regexp("^(> |)经验值增加了(.*)点。|^(> |)经验值减少了(.*)点。",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"经验值减少了") then
	      local get_exp=w[4]
		  world.SetVariable("get_exp","-"..get_exp)
	      return
	  end
	  if string.find(l,"经验值增加了") then
	      local get_exp=w[2]
		  world.SetVariable("get_exp",get_exp)
	      return
	  end
   end)
end

--您本次在线二小时二十三分十二秒。
--经验值减少了46999点。
--实战获取的经验值减少了46999点。
--每小时亏损：一万九千六百八十点经验。
function exps:get_per_exps_add()
   wait.make(function()
      local l,w=wait.regexp("^(> |)每小时进帐：(.*)点经验。|^(> |)每小时亏损：(.*)点经验。",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"每小时亏损") then
	      local per_exps=ChineseNum(w[4])
		  world.SetVariable("per_exps","-"..per_exps)
		  local connect_hour=world.GetVariable("connect_hour") or ""
          --local per_exps=world.GetVariable("per_exps") or ""
		  local q_time=quest:group_time()
          world.SetStatus ("当前 EXPS = ", GetVariable("exps")," 每小时亏损速度:-",per_exps," 连线时间 ",connect_hour," 目前获得总的经验值:",GetVariable("get_exp")," 上次解谜时间:",q_time.quest_date)
	      return
	  end
	  if string.find(l,"每小时进帐") then
	      local per_exps=ChineseNum(w[2])
		  world.SetVariable("per_exps",per_exps)
		  local connect_hour=world.GetVariable("connect_hour") or ""
          --local per_exps=world.GetVariable("per_exps") or ""
		  local q_time=quest:group_time()
          world.SetStatus ("当前 EXPS = ", GetVariable("exps")," 每小时增长速度:",per_exps," 连线时间 ",connect_hour," 目前获得总的经验值:",GetVariable("get_exp")," 上次解谜时间:",q_time.quest_date)
	      return
	  end
   end)
end


