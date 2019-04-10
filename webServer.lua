local http = require("socket.http")
http.TIMEOUT=2
require("lc") -- asii ת unicode
--[[
 ��ҳ > ���� > web���� > HTML5 > lua urlencode urldecode URL����
lua urlencode urldecode URL����
0������

[ժҪ��URL����ʵ�ڱ��Ƕ�һЩ�ַ�ת��Ϊ%���ϸ��ַ���ӦASCII�����λʮ�����췽ʽ�� �磺 �ַ��Ƿ��ַ��ļ���URL���� #��ȥ����ض����ĵ���λ%23 %�ԷǷ��ַ����б���%25 �ֿ�����ı�����]

URL������ʵ���Ƕ�һЩ�ַ�ת��Ϊ%���ϸ��ַ���ӦASCII��Ķ�λʮ��������ʽ��

�磺

�ַ� �����ַ��ĺ��� URL����
# ������־�ض����ĵ�λ�� %23
% �������ַ����б��� %25
& �ָ���ͬ�ı���ֵ�� %26
+ �ڱ���ֵ�б�ʾ�ո� %2B
 ��ʾĿ¼·�� %2F
= �������Ӽ���ֵ %3D
? ��ʾ��ѯ�ַ����Ŀ�ʼ %3F

so��

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
	--[[print("-----------��ʼ-------------")
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
	if string.find(response,"null]}") then  --��β
	  local json=cjson.decode(response) --json���ݽ���
	   return json
	else
       return nil
	end--]]
end

function webServer:upload(playername,playerid,editwho,import_time,roomno,roomname)
--str = "Ҷ֪��"
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

--webServer:upload("Ҷ֪��","bugisme","bugisme","2014/1/1 13:00","1532","������")

function webServer:query(playerid)
--{"rs":[[27998,"��è","bugisme","Bugisme",0,"������","03/14/16 08:36:00:357"],null]}
    local _url="http://112.65.143.180:2016/Server.aspx?op=query&playerid="..playerid
   -- print("������",_url)
	local response,code = http.request(_url)
	local cjson = require("json")
	--print("rep ",response)
	if response==nil then
	   return nil
	end
	if string.find(response,"null]}") then  --��β
	  local json=cjson.decode(response) --json���ݽ���
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
     --print("������",_url)

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
   -- print("������",_url)
	--local response,code = http.request("http://www.163.com")
	local response,code = http.request(_url)
	--local cjson = require("json")
	--print("rep ",response)
	if response==nil then
	    -- print("û���")
	   return nil
	else
	   return lc.u2a(response)
	end
end

--���� http ����
function test_download()
   webServer:downloadFile("http://localhost:18529/SJ_Mush_Config/download/sjcentury.db","c:\\data\\sjcentury.db")
end

function webServer:downloadFile(url)
 local _url=url
   -- print("������",_url)
	--local response,code = http.request("http://www.163.com")
	local response,code = http.request(_url)
	--local cjson = require("json")
	--print("rep ",response)
	if response==nil then
	    -- print("û���")
	   return nil
	else
			--[[	local file1 = io.open(output,"wb")
             file1:write(response)
             file1:flush()
             file1:close()]]

	   return response
	end
end

