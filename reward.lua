--[[��ϲ�㣡��ɹ�������˻�ɽ�����㱻�����ˣ�
һ��һʮ��㾭��!
��ʮ�ŵ�Ǳ��!
��ʮ��������

��ϲ�㣡��ɹ�����������������㱻�����ˣ�
һ����ʮ���㾭��!
��ʮ��Ǳ��!]]
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
---�㱻�������İ���ʮ�ĵ㾭�飬��ʮ�ĵ�Ǳ�ܣ���о�а��֮����ʤ��ǰ��
--��������л�Ȼ���ʣ������˰�ʮ���Ǳ�ܺͶ�����һ�㾭�飡
--��ϲ�㣡��ɹ��������ѩɽ�����㱻�����ˣ�
--��ǧ��ʮ�ߵ㾭��!
--һǧ������ʮ�ŵ�Ǳ��!
--��ǧ�İپ�ʮ���㸺��
--һ��ͨ����
--������һ����ʮ���㾭�飬��ʮ����Ǳ�ܣ�����������������ˣ�

function reward:get_reward()
   --world.Send("set reward")
   wait.make(function()
     local l,w=wait.regexp("^(> |)��ϲ�㣡��ɹ��������(.*)�����㱻�����ˣ�$|^(> |)�趨����������reward \\= \\\"YES\\\"$|^(> |)�㱻������(.*)�㾭�飬(.*)��Ǳ�ܣ�(.*)���ƽ�.*$|^(> |)�㱻������(.*)�㾭�飬(.*)��Ǳ��.*|^(> |)������(.*)�㾭�飬(.*)��Ǳ��.*$",15)
       if l==nil then
		  self:finish()
	      return
	   end
	   if string.find(l,"�趨��������") then
		  world.Send("unset reward")
	      return
	   end

	   if string.find(l,"��ϲ��") then
	      --print(w[2])
	      self.job_name=w[2]
	      self:exps()
	      return
	   end
	   if string.find(l,"������") then
	      --string.find(l,"�㱻����") then
	      self.pots_num=ChineseNum(w[13])
		  self.exps_num=ChineseNum(w[12])
          self:finish()
	      return
	   end
	   if string.find(l,"���ƽ�") then

		   self.pots_num=ChineseNum(w[6])
		  self.exps_num=ChineseNum(w[5])
		  self.gold_num=ChineseNum(w[7])
          self:finish()
	      return
	   end
	   if string.find(l,"�㱻����") then
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
     local l,w=wait.regexp("^(> |)(.*)�㾭��!$|^(> |)�趨����������reward \\= \\\"YES\\\"$",5)
       if l==nil then
		  self:exps()
	      return
	   end
	   if string.find(l,"�㾭��") then

	      self.exps_num=ChineseNum(w[2])
		  print(self.exps_num)
	      self:pots()
	      return
	   end
	   if string.find(l,"�趨��������") then
	      world.Send("unset reward")
	      self:finish()
	      return
	   end
   end)
end

function reward:pots()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)��Ǳ��!$|^(> |)�趨����������reward \\= \\\"YES\\\"$",5)
       if l==nil then
		  self:pots()
	      return
	   end
	   if string.find(l,"��Ǳ��") then
	      self.pots_num=ChineseNum(w[2])
		  print(self.pots_num)
	      --self:shen()
		  self:finish()
	      return
	   end
	    if string.find(l,"�趨��������") then
		  world.Send("unset reward")
	      self:finish()
	      return
	   end
   end)
end

function reward:shen()
   wait.make(function()
     local l,w=wait.regexp("^(> |)(.*)��(.*)��$|^(> |)�趨����������reward \\= \\\"YES\\\"$",5)
       if l==nil then
		  self:shen()
	      return
	   end
	    if string.find(l,"�趨��������") then
		  world.Send("unset reward")
	      self:finish()
	      return
	   end
	   if string.find(l,"��") then
	     if w[3]=="��" then
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
   --д��
   print("����")
   --self:callback()
  -- world.AppendToNotepad (WorldName().."_����:",os.date()..": "..self.job_name.. " ����:"..self.exps_num.." Ǳ��:"..self.pots_num.."\r\n")
end
