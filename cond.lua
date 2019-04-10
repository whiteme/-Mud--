--[[你身上包含下列特殊状态：
┌────────────────────────┐
│状态名称约剩余时间      类别│
├────────────────────────┤
│任务繁忙状态    二十秒                   忙 │
└────────────────────────┘
你身上没有包括任何特殊状态。
当前你没有被判断为机器人。

你身上没有包括任何特殊状态
你被判断为机器人，赶快用robot命令召唤一个出来吧。

]]
--状态判别
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
     local l,w=wait.regexp("^(> |)你身上没有包括任何特殊状态。$|^(> |)你身上包含下列特殊状态：$",5)
	 if l==nil then
	    self:start()
	    return
	 end
	 if string.find(l,"你身上包含下列特殊状态") then
	    self:list()
	    return
	 end
	 if string.find(l,"你身上没有包括任何特殊状态") then
	    self:over()
		--print("end")
	    return
	 end
  end)
end
--│任务繁忙状态    九分                     忙 │
function cond:list()
--名称  时间  类别
  wait.make(function()
     local l,w=wait.regexp("^│(.*)│$|^(> |)当前你没有被判断为机器人。$|^(> |)你被判断为机器人，赶快用robot命令召唤一个出来吧。$",5)
	 if l==nil then
	    self:list()
	   return
	 end
	 if string.find(l,"│") then

	   local n=w[1]
	   local j
	    j=string.gsub(w[1],"% ","")
		j=Split(j,"")
		if table.getn(j)==3 then
		 local item={}
		 for _,k in ipairs(j) do
		   --print("内容:",k)
		   if string.find(k,"分") then
		     local i=string.find(k,"分")
		     local num=string.sub(k,1,i)
			 k=ChineseNum(num)*60
		   elseif string.find(k,"秒") then
		     local i=string.find(k,"秒")
		     local num=string.sub(k,1,i)
			 k=ChineseNum(num)
		   end
		   print(k,"秒")
		   table.insert(item,k)
		 end
		 table.insert(self.lists,item)
		end
	   --print(w[1]," ",w[2]," ",w[3])
	   self:list()
	   return
	 end
	  if string.find(l,"当前你没有被判断为机器人") or string.find(l,"你被判断为机器人") then
		--self.lists=nil
	    self:over()
	    return
	 end
  end)
   --│任务繁忙状态    二十秒                   忙 │
   --^│{七伤拳内伤|内伤|火焰刀烧伤|一指禅内劲|蛇毒|气息不匀|封招|闭气|寒毒|寒冰绵掌毒|蔓陀萝花毒|打狗棒脚伤}
end

function cond:over()
  print("end")
end
