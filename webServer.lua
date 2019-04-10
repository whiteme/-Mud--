local http = require("socket.http")
http.TIMEOUT=2
require("lc") -- asii 转 unicode
--[[
 首页 > 技术 > web开发 > HTML5 > lua urlencode urldecode URL编码
lua urlencode urldecode URL编码
0条评论

[摘要：URL编码实在便是对一些字符转义为%减上该字符对应ASCII码的两位十六进造方式。 如： 字符非凡字符的寄义URL编码 #用去标记特定的文档地位%23 %对非凡字符举行编码%25 分开分歧的变量对]

URL编码其实就是对一些字符转义为%加上该字符对应ASCII码的二位十六进制形式。

如：

字符 特殊字符的含义 URL编码
# 用来标志特定的文档位置 %23
% 对特殊字符进行编码 %25
& 分隔不同的变量值对 %26
+ 在变量值中表示空格 %2B
 表示目录路径 %2F
= 用来连接键和值 %3D
? 表示查询字符串的开始 %3F

so：

]]

--print(lc.help())
webServer={
  new=function()
	 local _ws={}
	 setmetatable(_ws,webServer)
	 return _ws
  end,
}
webServer.__index=webServer

local function decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

local function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

function webServer:post(reqbody)
    local _url="http://112.65.143.180:2016/Server.aspx?op=post"
    --print(_url)
	local respbody = {} -- for the response body
	local result, respcode, respheaders, respstatus = http.request{
	  method = "POST",
	  url = _url,
	  headers =
      {
        ["Content-Type"] = "application/x-www-form-urlencoded",
        ["Content-Length"] = #reqbody,
      },
	  source = ltn12.source.string(reqbody),
	  sink = ltn12.sink.table(respbody)

	}
	--[[print("-----------开始-------------")
	print(result)
	print(respcode)
	print(respheaders)
	print(respstatus)
	print(respbody)
	for i,k in ipairs(respbody) do
	   print(i, " = ",k)
	end
	print("------------------------")]]
	--[[print(response)
	local cjson = require("json")

	if response==nil then
	   return nil
	end
	if string.find(response,"null]}") then  --结尾
	  local json=cjson.decode(response) --json数据解析
	   return json
	else
       return nil
	end--]]
end

function webServer:upload(playername,playerid,editwho,import_time,roomno,roomname)
--str = "叶知秋"
--str = lc.a2u(str)
--print(str)
    playername=lc.a2u(playername)
    roomname=lc.a2u(roomname)
    playername=encodeURI(playername)
    roomname=encodeURI(roomname)
	playername=string.sub(playername,1,-4)
	roomname=string.sub(roomname,1,-4)
    local _url="http://112.65.143.180:2016/Server.aspx?op=insert&playername="..playername.."&playerid="..playerid.."&editwho="..editwho.."&roomno="..roomno.."&roomname="..roomname
    local response,code = http.request(_url)
end

--webServer:upload("叶知秋","bugisme","bugisme","2014/1/1 13:00","1532","正气堂")

function webServer:query(playerid)
--{"rs":[[27998,"秋猫","bugisme","Bugisme",0,"正气堂","03/14/16 08:36:00:357"],null]}
    local _url="http://112.65.143.180:2016/Server.aspx?op=query&playerid="..playerid
   -- print("搜索：",_url)
	local response,code = http.request(_url)
	local cjson = require("json")
	--print("rep ",response)
	if response==nil then
	   return nil
	end
	if string.find(response,"null]}") then  --结尾
	  local json=cjson.decode(response) --json数据解析
	   return json
	else
       return nil
	end
end

function webServer:Config_Save(playerid,config_txt)
     config_txt=string.gsub(config_txt,"<","&lt;")
    config_txt=string.gsub(config_txt,">","&gt;")
	config_txt=lc.a2u(config_txt)
   config_txt="config_txt="..encodeURI(config_txt)


	--print(config_txt)
   --local _url="http://localhost:34533/SjCloudy/Server.aspx?op=config_save&playerid="..playerid
   local _url="http://112.65.143.180:2016/Server.aspx?op=config_save&playerid="..playerid
     --print("搜索：",_url)

	 local respbody = {} -- for the response body
	local result, respcode, respheaders, respstatus = http.request{
	  method = "POST",
	  url = _url,
	  headers =
      {
        ["Content-Type"] = "application/x-www-form-urlencoded",
        ["Content-Length"] = #config_txt,
      },
	  source = ltn12.source.string(config_txt),
	  sink = ltn12.sink.table(respbody)

	}
end

function webServer:Config_Get(playerid)
 local _url="http://112.65.143.180:2016/Server.aspx?op=config_get&playerid="..playerid
   -- print("搜索：",_url)
	--local response,code = http.request("http://www.163.com")
	local response,code = http.request(_url)
	--local cjson = require("json")
	--print("rep ",response)
	if response==nil then
	    -- print("没结果")
	   return nil
	else
	   return lc.u2a(response)
	end
end

--测试 http 下载
function test_download()
   webServer:downloadFile("http://localhost:18529/SJ_Mush_Config/download/sjcentury.db","c:\\data\\sjcentury.db")
end

function webServer:downloadFile(url)
 local _url=url
   -- print("搜索：",_url)
	--local response,code = http.request("http://www.163.com")
	local response,code = http.request(_url)
	--local cjson = require("json")
	--print("rep ",response)
	if response==nil then
	    -- print("没结果")
	   return nil
	else
			--[[	local file1 = io.open(output,"wb")
             file1:write(response)
             file1:flush()
             file1:close()]]

	   return response
	end
end

