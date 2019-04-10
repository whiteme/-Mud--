local function chinese_char(h,l)
  c=string.char(h,l)
  print(c)
  return c
end
--2进制点阵
local function graphic(n,str)
     if (n % 2)==0 then
		str=" "..str
		--print(str)
		n=n/2
	 else
	    str="." .. str
		--print(str)
		n=(n-1)/2
	 end
	 if n==0 then
	    for i=string.len(str),7 do
	      str=" " .. str
	    end
	    return str
     else
       return graphic(n,str)
	 end
end

--图形点阵 转换成数字
local function num(str)
    --print(str)
    local n=0
    for i=0,7 do
	   if string.sub(str,i+1,i+1)=="." then --1
	      n=n+math.pow(2,7-i)
	   end
	end
	return n
end

local m={
  "^^^^^^^^^^^^^.^^",--1
  "...............^",--2
  "^^^^^^^.^^^^^^^^",--3
  "^^^^^^^.^^^.^^^^",--4
  "^^.^^^^......^^^",--5
  "^^.^^^^.^^^^^^^^",--6
  "^^.^^^^.^^^^^^^^",--7
  "^^.^^^^.^^^^^.^^",--8
  "^^.............^",--9
  "^^^^^^^^^^^^^.^^",--10
  "^^^^^^^^^^^^^.^^",--11
  "^^^^^^^^^^^^^.^^",--12
  "^^^^^^^^^^^^^.^^",--13
  "^^^^^^^^^.^^^.^^",--14
  "^^^^^^^^^^.^.^^^",--15
  "^^^^^^^^^^^.^^^^",--16
}

--to_char()
--还原汉字
--[[local function find(exps)
   local f = assert(io.open("c:\\word\\Hzk16", "rb"))
	 local data = f:read("*all")

     local s,e=string.find(data, exps)

	 print("结果",s,e)
	 f:close()
	 if s~=nil then
	   return  s-1
	 else
       return nil
	 end
end]]
local mem={}
local function init()
     mem={}
     local f = assert(io.open(GetInfo (66) .."Hzk16", "rb"))  --字库所在路径
	 local data = f:read("*all")
	 local d=""
	 --print(string.len(data))
	 for i=1,string.len(data),32 do
	    --print("地址:",i-1)
		local item={}
		item.offset=i-1
		item.string=string.sub(data,i,i+31)
		table.insert(mem,item)
	 end
end
init()

local function find(exps)
      --print("表达式:",exps)
     for _,m in ipairs(mem) do
	    --print("test:",m.string)
	    if m.string==exps then
		   return m.offset
		end
	 end
end

local function to_char(matrix)
   local serial=""
   local show=""
   for i=1,16 do
      local line=matrix[i]
	  local h,l
	  h=string.sub(line,1,8)
	  l=string.sub(line,9,16)
	  local gjh=tonumber(num(h),10)
	  local gjl=tonumber(num(l),10)
	  --print(string.format("%02X",gjh),string.format("%02X",gjl))
	  serial=serial ..string.char(gjh)..string.char(gjl)
	  show=show..string.format("%02X",gjh)..string.format("%02X",gjl).." "
   end
   --print(show)
   local offset=find(serial)

   if offset==nil then
     print("异常")
     return ""
   end
    -- 数字 换转成 ascii

	--1 先获得 offset
	--2 offset 还原成zone pos
	--local offset=165536
	local address=offset/32
	print(address)
	local zone,pos
	pos=address % 94
	zone=(address-pos)/94
	zone=zone+1
	pos=pos+1
	--print("zone:",zone)
	--print("pos",pos)
	--3 汉字内码 转换成机器码
	local gjh,gjl
	gjh=zone+0x20
	gjl=pos+0x20
	--4 h l 字符高低位
	local h,l
	h=gjh+128
	l=gjl+128
    --5 转化成字符
    local char=string.char(h)..string.char(l)
	print("获得汉字",char)
	return char
end

local function to_matrix(char)
--print(string.format("%02X",string.byte(char,1)),string.format("%02X",string.byte(char,2)))
local hh=string.format("%02X",string.byte(char,1))
local lh=string.format("%02X",string.byte(char,2))
local h=string.format("%d",string.byte(char,1))
local l=string.format("%d",string.byte(char,2))
--print(h-128,l-128)
local gjh=tonumber(string.format("%x",h-128),16)
local gjl=tonumber(string.format("%x",l-128),16)
--print("国际码",gjh,gjl) -- 机器码
gjh=gjh-0x20
gjl=gjl-0x20
--print("区位码",gjh,gjl)  汉字内码
local zone=gjh
print(zone)
local pos=gjl
print(pos)
offset=(94*(zone-1)+(pos-1))*32
print("偏移量:",offset)
local f=assert(io.open("c:\\word\\Hzk16","rb"))
local block=1  --2个字节 一行 一共 16行
local j=0
--while true do
     local bytes
	 f:seek("set",offset)
     local s=""
	 local show=""
	 for i=0,15 do
	   H_bytes=f:read(block)
       --if not bytes then break end
	   --print(string.format("%02X",string.byte(bytes)))
       L_bytes=f:read(block)
	   s=s..H_bytes..L_bytes
	   show=show..string.format("%02X",string.byte(H_bytes))..string.format("%02X",string.byte(L_bytes)).." "

       --if not bytes then break end
	   --print(string.format("%02X",string.byte(bytes)))
	   --print(H_bytes,L_bytes)
	   --print("   "..i.."   ",string.format("%02X",string.byte(H_bytes)),string.format("%02X",string.byte(L_bytes)))
	   local _left=tonumber(string.format("%02X",string.byte(H_bytes)),16)
	   local _right=tonumber(string.format("%02X",string.byte(L_bytes)),16)
	   local left_str=""
	   local right_str=""
	   left_str=graphic(_left,"")
	   right_str=graphic(_right,"")
	   --print(left_str..right_str)
	 end
	 --j=j+1
	 --print("----------------    "..j.."    ----------------")
	--if not bytes then break end
--end
f:close()
--print(show)
--print(s)
end


--[[local c={
" ...........:.         `.            :    .    :       :      .        :  :     .   ",
"   .   :   .      :````````````:     :    :    :       :    .``      .` ..:..`````  ",
"   `.  :  .`     `  .......:. `    : : `. : `. :       :  .`        `  .  :      .  ",
"    `  :  `  .          :         .` :  ` :  ` :   ....:........:.    .```:`````:`` ",
"```````:```````     :   :..:.        :    :    :       :  :         .`: ..:..   :   ",
"       :            :   :            :    :    :       :   `.         :   :     :   ",
"       :           .`.  :     ..    :     :    :       :  .  `...     :...:```  :   ",
"       :         .`   `````````    `           :       :``     `      : `     `.`   ",
}
local c={
"       :    .           :                :         ....:. .......    .    `.   .`   ",
" ``````:``````          :                :          .  :   `. .`      `: ```:`````  ",
"  ````:``````     :     :     :   .......:.....:.   :  :    .`.           .:....:.  ",
"`````:```:`````   :     :     :         .`.         :  : ..` . `:`  ```:  :.....:   ",
"  ..:  :  :.      :     :     :         : `.        ````: ...:...      :  :     :   ",
"``   `.:.`  `:`   :     :     :        :   `.         ..:    :  .      :  :`````:   ",
"   .`` : ``.      :.....:.....:      .`      `...  ```  :````:````    .`. :.....:   ",
"     `.`          `           `    ``          `      `.`    :       `   `.......:` ",
}]]
--[[local word={
" .    `.   .`   ",
"  `: ```:`````  ",
"      .:....:.  ",
"```:  :.....:   ",
"   :  :     :   ",
"   :  :`````:   ",
"  .`. :.....:   ",
" `   `.......:` ",
}

local word={
  "       *     *   ",
  "***************  ",
  "                 ",
  "  ***** *****    ",
  "  *   * *   *    ",
  "  ***** *****    ",
  "     *   *       ",
  " *************   ",
  "     *   *       ",
  "  ***********    ",
  "     *   *       ",
  "***************  ",
  "    *  *   *     ",
  "   **   * *      ",
  " ** **   ***     ",
  "    *       ***  ",
}]]
--84 间隔1
local word={}
function get_bigword(line)
-- 开始到结束一共8行
  if line~=nil then
    if string.len(line)>0 then
      --print(line)
     print(string.len(line))

    if table.getn(word)<=8 then
     print(table.getn(word))
	  table.insert(word,line)
    end
   end
  end
end

function get_bigword2(line)
-- 开始到结束一共16行
  if line~=nil then
    if string.len(line)>0 then
      --print(line)
     print(string.len(line))

    if table.getn(word)<=16 then
     print(table.getn(word))
	  table.insert(word,line)
    end
   end
  end
end

local function convert_matrix(matrix)
   local _m={}  --8*16 行矩阵 转换成 16*16
   local row,col
   for row=1,8 do
     local line= matrix[row]
	 --print(line)
	 local l1=""
	 local l2=""
	 for col=1,string.len(line) do
	     local line1,line2

		 local char=string.sub(line,col,col)
	     if char==" " then
		    --00
			line1=" "
			line2=" "
		 elseif char=="." then
		    line1=" "
			line2="."
		 elseif char=="`" then
		    line1="."
			line2=" "
		 elseif char==":" then
		    line1="."
			line2="."
		 end
		 l1=l1..line1
		 l2=l2..line2
	 end
	 --print(l1)
	 --print(l2)
     table.insert(_m,l1)
	 table.insert(_m,l2)
   end
   return _m
end

local function convert_matrix2(matrix)
   local _m={}  -- 16*16
   local row,col
   for row=1,16 do
     local line= matrix[row]
	 --print(line)
	 local l1=""
	 for col=1,string.len(line) do
	     local line1

		 local char=string.sub(line,col,col)
	     if char==" " then
		    --00
			line1=" "
		 elseif char=="*" then
			line1="."
		 end
		 l1=l1..line1
	 end
	 --print(l1)
	 --print(l2)
     table.insert(_m,l1)
   end
   return _m
end

function deal_bigword()
   --word=c 测试
   local n=(string.len(word[1])+1)/17
   print("长度",n,string.len(word[1]))
   local chars={}
   for col=1,n do
      local matrix={}
	  for row=1,8 do
		 local line =string.sub(word[row],1+(col-1)*16+(col-1),16+(col-1)*16+(col-1))
		 --print(line)
		 table.insert(matrix,line)
	  end
	  table.insert(chars,matrix)
   end
   local str=""
   for _,A_char in ipairs(chars) do
     local m=convert_matrix(A_char)
     str=str .. to_char(m)
   end
   print(str)
   return str
end

--or char=="*"
function deal_bigword2()
   --word=c 测试
   local n=(string.len(word[1])+1)/17
   print("长度",n,string.len(word[1]))
   local chars={}
   for col=1,n do
      local matrix={}
	  for row=1,16 do
		 local line =string.sub(word[row],1+(col-1)*16+(col-1),16+(col-1)*16+(col-1))
		 --print(line)
		 table.insert(matrix,line)
	  end
	  table.insert(chars,matrix)
   end
   local str=""
   for _,A_char in ipairs(chars) do
     local m=convert_matrix2(A_char)
     str=str .. to_char(m)
   end
   print(str)
   return str
end

function new_bigword()
   word={}
end
--to_matrix("襄")
--deal_bigword()
--deal_bigword2()
--to_matrix("帮")
