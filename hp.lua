--����Ѫ��    6 /   100 (100%)  ��������  100 /   100(196)
--����Ѫ��  100 /   100 (100%)  ��������    0 /     0(+0)
--�������� 0                ���������ޡ�   98 /   402
--��ʳ�  74.00%              ��Ǳ�ܡ�  122 /  128
--����ˮ��  95.50%              �����顤 2,156 (82.82%)

require "status_win"
hp={
   new=function()
     local h={}
	 setmetatable(h,hp)
	 return h
   end,
  qi=0,
  max_qi=0,
  qi_percent=100,
  jingxue=0,
  max_jingxue=0,
  jingxue_percent=100,
  jingli=0,
  max_jingli=0,
  jingli_limit=0,
  neili=0,
  max_neili=0,
  jiali=0,
  shen=0,
  neili_limit=0,
  special_neili_limit=0,
  food=0,
  drink=0,
  pot=0,
  max_pot=0,
  exps="",
  exps_percent=0,
}
hp.__index=hp

function hp:check5(reset)
  wait.make(function()
     local l,w=wait.regexp("^����ˮ��\\s*(.*)\\%\\s*�����顤\\s*(.*)\\s*\\((.*)\\%\\)$",5)
	 if l==nil then
	    reset()
	    return
	 end
	 if string.find(l,"��ˮ") then
	   --print("��ˮ")
	   self.drink=tonumber(w[1])
	   self.exps=tonumber(Trim(string.gsub(w[2],",","")))
	   world.SetVariable("exps",self.exps)
	   local _percent=world.GetVariable("exps_percent") or 0
	   _percent=tonumber(_percent)
	   self.exps_percent=tonumber(w[3])
       world.SetVariable("exps_percent",self.exps_percent)
	   if _percent>self.exps_percent then
	     print("���ܵȼ�������һ��")
		 world.SetVariable("levelup","true")
	   end
	    --print(self.jingxue,self.max_jingxue,self.jingli,self.max_jingli,self.jingli_limit)
		--Ƶ�����й㲥
		--[[local is_boardcast=false
		if is_boardcast==true then
		  local boardcast="\"jing\":"..self.jingxue..",\"max_jing\":"..self.max_jingxue..",\"jingli\":"..self.jingli..",\"max_jingli\":"..self.max_jingli..",\"jingli_limit\":"..self.jingli_limit
		  world.Send("irc {\"hp\":{"..boardcast.."}}")

		  boardcast="\"qi\":"..self.qi..",\"max_qi\":"..self.max_qi..",\"neili\":"..self.neili..",\"max_neili\":"..self.max_neili..",\"jingli_limit\":"..self.neili_limit
		  world.Send("irc {\"hp\":{"..boardcast.."}}")
		  boardcast="\"jiali\":"..self.jiali..",\"qi_per\":"..self.qi_percent..",\"jing_per\":"..self.jingxue_percent..",\"updated\":1"
		  world.Send("irc {\"hp\":{"..boardcast.."}}")
		end]]
	   self:checkover()
	   --���
	   	 local st=status_win.new()
         st:init(self,nil,nil)
         st:hp_draw_win()
	   return
	 end
	 --wait.time(5)
   end)
end

function hp:check4(reset)
  wait.make(function()
     local l,w=wait.regexp("^��ʳ�\\s*(.*)\\%\\s*��Ǳ�ܡ�\\s*(\\d*)\\s*\\/\\s*(\\d*)$",5)
	 if l==nil then
	    reset()
	    return
	 end
	 if string.find(l,"ʳ��") then
	  -- print("ʳ��")
	   self.food=tonumber(w[1])
	   self.pot=tonumber(w[2])
	   self.max_pot=tonumber(w[3])

	   self:check5(reset)
	  return
	 end
	 wait.time(5)
   end)
end

function hp:check3(reset)
  wait.make(function()
     local l,w=wait.regexp("^��(\\W*)��\\s*(.*)\\s*���������ޡ�\\s*(\\d*)\\s*\\/\\s*(\\d*)$",5)
	 if l==nil then
	    reset()
	    return
	 end
	 if string.find(l,"��������") then
	  -- print("��������")
	  --print(w[1])
	  if w[1]=="����" then
	     self.shen=tonumber(Trim(string.gsub(w[2],",","")))*-1
	  else
	     self.shen=tonumber(Trim(string.gsub(w[2],",","")))
	  end
      --print(self.shen)
      --print(self.shen)
	  self.neili_limit=tonumber(w[3])
	  self.special_neili_limit=tonumber(w[4])

	  self:check4(reset)
	  return
	 end
	 wait.time(5)
   end)
end

function hp:check2(reset)
  wait.make(function()
     local l,w=wait.regexp("^����Ѫ��\\s*(\\d*)\\s*\\/\\s*(\\d*)\\s*\\(\\s*(\\d*)\\%\\)\\s*��������\\s*(\\d*)\\s*\\/\\s*(\\d*)\\(\\+(\\d*)\\)$",5)
	 if l==nil then
	    reset()
	    return
	 end
	 if string.find(l,"��Ѫ") then
	-- print("��Ѫ")
	  self.qi=tonumber(w[1])
	  self.max_qi=tonumber(w[2])
	  self.qi_percent=tonumber(w[3])
	  self.neili=tonumber(w[4])
	  self.max_neili=tonumber(w[5])
	  self.jiali=tonumber(w[6])

	  self:check3(reset)
	  return
	 end
	 wait.time(5)
   end)
end

function hp:check()
  --[[ hp.hp_co=coroutine.create(function ()
     check_trigger()
     world.Send("hp")
	 coroutine.yield() --����
	 self:checkover()
   end)
   coroutine.resume(hp.hp_co)]]
   world.Send("hp")
   wait.make(function()
     local l,w=wait.regexp("^����Ѫ��\\s*(\\d*)\\s*\\/\\s*(\\d*)\\s*\\(\\s*(\\d*)\\%\\)\\s*��������\\s*(\\d*)\\s*\\/\\s*(\\d*)\\((\\d*)\\)$",5)
	 if l==nil then
	    self:check()
	    return
	 end
	 if string.find(l,"��Ѫ") then
	 -- print("��Ѫ")
	  self.jingxue=tonumber(w[1])
	  self.max_jingxue=tonumber(w[2])
	  self.jingxue_percent=tonumber(w[3])
	  self.jingli=tonumber(w[4])
	  self.max_jingli=tonumber(w[5])
	  self.jingli_limit=tonumber(w[6])
       local f=function() self:check() end
	  self:check2(f)
	  return
	 end
	 wait.time(5)
   end)
end

function hp:capture()
   wait.make(function()
     local l,w=wait.regexp("^����Ѫ��\\s*(\\d*)\\s*\\/\\s*(\\d*)\\s*\\(\\s*(\\d*)\\%\\)\\s*��������\\s*(\\d*)\\s*\\/\\s*(\\d*)\\((\\d*)\\)$",5)
	 if l==nil then
	    self:capture()
	    return
	 end
	 if string.find(l,"��Ѫ") then
	 -- print("��Ѫ")
	  self.jingxue=tonumber(w[1])
	  self.max_jingxue=tonumber(w[2])
	  self.jingxue_percent=tonumber(w[3])
	  self.jingli=tonumber(w[4])
	  self.max_jingli=tonumber(w[5])
	  self.jingli_limit=tonumber(w[6])
      local f=function() self:capture() end
	  self:check2(f)
	  return
	 end
   end)
end

function hp:checkover()

end
