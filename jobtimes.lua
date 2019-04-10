require "wait"

jobtimes={
   new=function()
     local jt={}
	 setmetatable(jt,jobtimes)
	 return jt
   end,
   lists={},
}
jobtimes.__index=jobtimes

function jobtimes:checkover(jobname)

end

function jobtimes:count()
   wait.make(function()
      local l,w=wait.regexp("^\\│(.*)任务.*\\│(.*)次.*\\│(.*)(次|无记录).*\\│$|^(> |)你最近刚完成了(.*)任务。",5)
	  if l==nil then
	     self:check()
	     return
	  end
	  if string.find(l,"你最近刚完成了") then
	    self.checkover(w[6])
	    return
	 end
	  if string.find(l,"任务") then
	    --
		 local jobname=Trim(w[1])
	    self.lists[jobname]=tonumber(Trim(w[2]))
	     --print(w[1]," ? ",Trim(w[2])," ? ",Trim(w[3]))
		 self:count()
	     return
	  end

   end)

end

function jobtimes:check()
   self.lists={}
   world.Send("jobtimes")
   self:count()

end

