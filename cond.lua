--[[�����ϰ�����������״̬��
����������������������������������������������������
��״̬���ƣ���������Լʣ��ʱ�䣠��������      ���
����������������������������������������������������
������æ״̬    ����ʮ��                  �� æ ��
����������������������������������������������������
������û�а����κ�����״̬��
��ǰ��û�б��ж�Ϊ�����ˡ�

������û�а����κ�����״̬
�㱻�ж�Ϊ�����ˣ��Ͽ���robot�����ٻ�һ�������ɡ�

]]
--״̬�б�
cond={
  new=function()
     local cd={}
	 cd.lists={}
	 setmetatable(cd,cond)
	 return cd
   end,
  lists={},
  version=1.8,
}
cond.__index=cond

function cond:start()
  wait.make(function()
     world.Send("cond")
     local l,w=wait.regexp("^(> |)������û�а����κ�����״̬��$|^(> |)�����ϰ�����������״̬��$",5)
	 if l==nil then
	    self:start()
	    return
	 end
	 if string.find(l,"�����ϰ�����������״̬") then
	    self:list()
	    return
	 end
	 if string.find(l,"������û�а����κ�����״̬") then
	    self:over()
		--print("end")
	    return
	 end
  end)
end
--������æ״̬    ���ŷ�                    �� æ ��
function cond:list()
--����  ʱ��  ���
  wait.make(function()
     local l,w=wait.regexp("^��(.*)��$|^(> |)��ǰ��û�б��ж�Ϊ�����ˡ�$|^(> |)�㱻�ж�Ϊ�����ˣ��Ͽ���robot�����ٻ�һ�������ɡ�$",5)
	 if l==nil then
	    self:list()
	   return
	 end
	 if string.find(l,"��") then

	   local n=w[1]
	   local j
	    j=string.gsub(w[1],"% ","")
		j=Split(j,"��")
		if table.getn(j)==3 then
		 local item={}
		 for _,k in ipairs(j) do
		   --print("����:",k)
		   if string.find(k,"��") then
		     local i=string.find(k,"��")
		     local num=string.sub(k,1,i)
			 k=ChineseNum(num)*60
		   elseif string.find(k,"��") then
		     local i=string.find(k,"��")
		     local num=string.sub(k,1,i)
			 k=ChineseNum(num)
		   end
		   print(k,"��")
		   table.insert(item,k)
		 end
		 table.insert(self.lists,item)
		end
	   --print(w[1]," ",w[2]," ",w[3])
	   self:list()
	   return
	 end
	  if string.find(l,"��ǰ��û�б��ж�Ϊ������") or string.find(l,"�㱻�ж�Ϊ������") then
		--self.lists=nil
	    self:over()
	    return
	 end
  end)
   --������æ״̬    ����ʮ��                  �� æ ��
   --^��{����ȭ����|����|���浶����|һָ���ھ�|�߶�|��Ϣ����|����|����|����|�������ƶ�|�����ܻ���|�򹷰�����}
end

function cond:over()
  print("end")
end
