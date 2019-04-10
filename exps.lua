

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
  print("����ֵ��ʱ��ʼ!!")
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
   hubiao.master_ready=false --�رջ��ڵ��жϱ���
   hubiao.child_ready=false --�رջ����жϱ���
 end
  world.Send("exp")
   wait.make(function()
       local l,w=wait.regexp("^(> |)����������(.*)��$",10)
	   if l==nil then
	      self:check()
	      return
	   end
      if string.find(l,"����������") then
	      local connect_hour=w[2]
		  world.SetVariable("connect_hour",connect_hour)
		  self:get_exps_add()
		  self:get_per_exps_add()
	      --self:get_exps_end()
	      return
      end
  end)
end

--���������߶�Сʱ��ʮ�ķֶ�ʮ���롣
--����ֵ������4006�㡣
--ÿСʱ���ʣ�һǧ���ٶ�ʮ�㾭�顣
function exps:get_exps_add()
   wait.make(function()
    local l,w=wait.regexp("^(> |)����ֵ������(.*)�㡣|^(> |)����ֵ������(.*)�㡣",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"����ֵ������") then
	      local get_exp=w[4]
		  world.SetVariable("get_exp","-"..get_exp)
	      return
	  end
	  if string.find(l,"����ֵ������") then
	      local get_exp=w[2]
		  world.SetVariable("get_exp",get_exp)
	      return
	  end
   end)
end

--���������߶�Сʱ��ʮ����ʮ���롣
--����ֵ������46999�㡣
--ʵս��ȡ�ľ���ֵ������46999�㡣
--ÿСʱ����һ���ǧ���ٰ�ʮ�㾭�顣
function exps:get_per_exps_add()
   wait.make(function()
      local l,w=wait.regexp("^(> |)ÿСʱ���ʣ�(.*)�㾭�顣|^(> |)ÿСʱ����(.*)�㾭�顣",5)
	  if l==nil then

	     return
	  end
	  if string.find(l,"ÿСʱ����") then
	      local per_exps=ChineseNum(w[4])
		  world.SetVariable("per_exps","-"..per_exps)
		  local connect_hour=world.GetVariable("connect_hour") or ""
          --local per_exps=world.GetVariable("per_exps") or ""
		  local q_time=quest:group_time()
          world.SetStatus ("��ǰ EXPS = ", GetVariable("exps")," ÿСʱ�����ٶ�:-",per_exps," ����ʱ�� ",connect_hour," Ŀǰ����ܵľ���ֵ:",GetVariable("get_exp")," �ϴν���ʱ��:",q_time.quest_date)
	      return
	  end
	  if string.find(l,"ÿСʱ����") then
	      local per_exps=ChineseNum(w[2])
		  world.SetVariable("per_exps",per_exps)
		  local connect_hour=world.GetVariable("connect_hour") or ""
          --local per_exps=world.GetVariable("per_exps") or ""
		  local q_time=quest:group_time()
          world.SetStatus ("��ǰ EXPS = ", GetVariable("exps")," ÿСʱ�����ٶ�:",per_exps," ����ʱ�� ",connect_hour," Ŀǰ����ܵľ���ֵ:",GetVariable("get_exp")," �ϴν���ʱ��:",q_time.quest_date)
	      return
	  end
   end)
end


