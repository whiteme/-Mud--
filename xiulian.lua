require "hp"
 local dazuo_start_regexp="(> |)��������Ҫ\(.*\)�������������$|^(> |)�����ھ��������޷�������Ϣ��������$|^(> |)���ﲻ׼ս����Ҳ��׼������$|^(> |)���Ҳ��ܴ�������Ӱ�������Ϣ��$|^(> |)���޷���������������$|^(> |)����ɲ���������������ĵط���$|^(> |)���ʩ�ù��ڹ����������ϴ�����$|^(> |)ս���в������ڹ������߻���ħ��$|^(> |)�˵ز���������$"


		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�����󽣾���������������������������ת����$" --ss 1
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)������һվ��˫�ֻ���̧������һ������������ʼ��������ת��$" --mr 2
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�����˵�������ڶ��������Ƴ����������������㻺��Ʈ������о����ھ���ʼ������ǿ�ˡ�$" --xx 3
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)��������ϥ������˫�ְ�����ǰ������һ��ů���澭��������ת��$" --szj 4
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)���������£�˫Ŀ΢�գ�˫���������������̫�������˺�һ���������顣$" --thd 5 21 ͬ9y
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�����������Ŀ�������ִ����������Ⱥ������������֮���䣬��Ȼ֮�������������Ҿ��硣" --dls 6
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�����������ϥ��������������������һƬ�������������Ҿ��磬һ�����ȵ���Ϣ���ζ�����֮�����ߡ�$" --dls 6
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)��ϯ�ض������������죬���Ϻ��ʱ��ʱ�֣���Ϣ˳��������������$" --emei 7
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)���������£�˫��ƽ����˫ϥ��Ĭ��ھ�����ʼ��������ķ���$" --gb 8
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)���������һ�����������۾���������Ů�ľ�����Ϣ�������п�ʼ��ת��$" --gumu 9
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�������������ù���һ����Ϣ��ʼ������������$" --hama 10
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����Ϣ�������������������ִ�������֮�ϣ�����ǰ���˸�������������Ϣ���߸���������$" --huashan 11
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�����������޼��񹦣����۵��һ����������֫������������$" --kunlun 12
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ������˫�ִ�����ǰ�ɻ���״�������������þ����е���������һ����������ӿ�뵤�$" --mj 13
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ��������ʹ�����������³������������뼹�ǣ�ע�����䣬������������֮���硣$" --mj  14
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)���������죬�ų�һ�������Ϣ˳��������������$" --shaolin 15
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ���£�˫�ֺ�ʮ����ͷ����Ǳ��������һ�ź������������Χ��������˫��ð��һ˿�̹⡣$"  --shenlong 16
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ���£���Ŀ��ʲ��Ĭ�˿���������ֻ����������������ʼ�����ڻ����ζ���$" --tls 17
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ���£���Ŀ��ʲ������Ǭ��һ���񹦣�һ�ɴ���������ʼ��������ת��$" --dali1 18
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ���£�������������ͼ��ȡ���֮������ֻ�������ܰ�����������ضٺϣ����ܰ�ããһƬ��$" --tz 19
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ������˫Ŀ���գ�������һ�������뵤�������һ����Ϣ�������Ѩ��������������֮����$" --wd 20
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ������˫Ŀ���գ�������һ�������뵤�����ڤ�������������Ѩ������$" --bm 21
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����������������������һ���ڼ���������ȫ��$" --hs2 22
          dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ����������˻�����Ψ�Ҷ��𹦣������������ڶ��𣬿�ʼ������$"  --ljg
          dazuo_start_regexp=dazuo_start_regexp.."|^(> |)���������£�˫��ƽ����˫ϥ��Ĭ��ھ�����ʼ�������Ǵ󷨡�$" --xxdf
		  dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ�����������һ�����ˡ���Ȫ�񹦡�������Ȫ�ھ�����ȫ���硣$" --lq
		  dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�������廨�룬��ϥ���£�Ĭ�˿����񹦣�ֻ����������������ʼ�����ڻ����ζ���$" --khbd
		  dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����ϥ���£�Ĭ����ħ�󷨣���ʱ���Ϻ��ʱ��ʱ�֣���Ϣ˳��������������"--tmg
              dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�㻹����ϴ��ɡ�$"
        dazuo_start_regexp=dazuo_start_regexp.."|^(> |)����������ͨ����Ƭ��֮�䣬��������ȫ��˫�۾������䣬���ַ���ý����������٣���ƽʱ�������ˡ�$"
		dazuo_start_regexp=dazuo_start_regexp.."|^(> |)��������� enable ѡ����Ҫ�õ������ڹ���$"
		 dazuo_start_regexp=dazuo_start_regexp.."|^(> |)�������ֽŴ�����������������ȷ��������������$"
 local dazuo_end_regexp="^(> |)��е��Լ��������Ϊһ�壬ȫ����ˬ��ԡ���磬�̲�ס�泩��������һ���������������۾���$" --dls
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��ֻ����Ԫ��һ��ȫ�������������Ը��ӣ��̲�ס��Хһ��������վ��������$" --dls
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��Ϣ���˸�С���죬���ص���չ�վ��������$"  --emei
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�������뵤�������ת�����������չ���˫��̧��վ��������$" --gaibang
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)���������������뵤������۾������������һ������$" --gumu
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)���˹���ϣ�վ��������$" --hama
                 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��Ϣ����һ�����죬ֻ�е�ȫ��̩ͨ��������ů���ģ�˫��һ�֣�����վ��������$" --huashan
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��Ϣ������һ��С���죬�������뵤�˫��һ��վ��������$"  --jiuyin
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)����Ƭ�̣���о��Լ��Ѿ��������޼������۵����������վ��������$"   --kl
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫������Ϣ��ͨ���������������۾���վ��������$"   --mj1
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)������������һ��Ԫ����������˫�ۣ�ֻ����ȫ����������������������Ȼ����֮����$"   --mj2
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫����������������������һȦ���������뵤������֣�������һ������$"   --mr
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��Ϣ���˸�С���죬���ص���չ�վ��������$"   --shaolin
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��ֿ�˫�֣������������£����е��̹�Ҳ��������������$"   --shenlongdao
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��������������֮�ư�����һ�ܣ��о����������ˡ�$"   --ss
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��һ�������н������������ӵ�վ��������$"   --szj
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��Ϣ������һ��С���죬�������뵤�˫��һ��վ��������$"   --thd
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)������������������һ�����죬�����������ڵ������̧�����۾���$"   --tls
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)������������������һ�����죬���������ڵ�������������۾���$"   --tls2
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��˫��΢�գ���������ؾ���֮����������,����ػָ��������չ�վ��������$"   --tz
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��Ϣ����������ʮ�����죬���ص��ֻ����ȫ��ů����ġ�$"   --wd
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��о�����ԽתԽ�죬�Ϳ�Ҫ������Ŀ����ˣ�����æ�ջض��غ���Ϣ����Цһ��վ��������$" --xx
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)���������Ϊ�Ѿ��ﵽԲ��֮����$" --full
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)����������е�����ǿ��ѹ�ص��վ��������$" --thd halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��е��������ͣ�ֻ��и����Ϣ������������������͸�����亹��$" --xs male halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��üͷһ�壬�������������ַ���������$" --mr halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��˫��һ��������ѹ����Ϣվ��������$" --ss halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)����Ϣһת��Ѹ��������ֹͣ����Ϣ����ת��$" --gumu halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)������һ��������Ϣѹ�ص��˫��һ��վ��������$"--hs halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��Ҵҽ���Ϣ���˻�ȥ����һ��������վ��������$" --kl halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)������΢΢����������������վ��������$" --mj halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��˫��һ�����������һ�����⣬��������һЦ��վ��������$" --xx halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��˫�ۻ����պϣ�Ƭ���͵������������̹⼱�������$" --sld halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㳤��һ����������Ϣ�������˻�ȥ��վ��������$" --sl halt
                 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��΢һ��ü������Ϣѹ�ص������һ������վ��������$" --wd halt
				 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫������ͨ��������ϣ���ȴ�������֣�˫�۾������䣬����վ��������$"
				 	 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��ڤ��������������ʮ�����죬���ص��ֻ����ȫ��̩ͨ�ġ�$"
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��˫��΢�գ���������ؾ���֮����������,����ػָ��������չ�վ��������$" --tz
					 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��Ϣ���˸�һ�����죬�����������ȥ���չ�վ��������$"--tmg
                 	  dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㳤��һ����������Ϣ�������˻�ȥ��վ��������$" --tmg halt
					  dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫��Ϣ����ȫ������ȫ���泩�����������ޱȡ�$"
					  	  dazuo_end_regexp=dazuo_end_regexp.."|^(> |)���Ȼǿ��һ��������˫��һ��������վ��������$"
                     dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��ֻ��������ת˳���������������棬�������վ��������$"  --ljg
                     dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫�����������ڣ���ȫ��ۼ�����ɫ��Ϣɢȥ��վ��������$" --xxdf
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)����ɫһ����Ѹ��������վ��������$"
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)���Ȼ˫��һ����һ����Х������תȫ��ġ���Ȫ�ھ���ɢȥ���漴վ��������$" --lq halt
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)���ѽ�����Ȫ�ھ�������ȫ������Ѩ��ֻ��������棬�ھ������ޱȣ�$" --lq
                    dazuo_end_regexp=dazuo_end_regexp.."|^(> |)�㽫����������������һ�����죬�����������ڵ������̧�����۾���$" --khbd
					dazuo_end_regexp=dazuo_end_regexp.."|^(> |)���͵�����˫�ۣ�˫��Ѹ�ٻظ���࣬��ϸ�������ܡ�$" --ss neigong halt
		            dazuo_end_regexp=dazuo_end_regexp.."|^(> |)����������е�����ǿ��ѹ�ص��վ��������$" --thd neigong halt
		            dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��üͷһ�壬�������������ַ���������$" --mr neigong halt
		            dazuo_end_regexp=dazuo_end_regexp.."|^(> |)��˫��һ��������ѹ����Ϣվ��������$" --szj neigong halt
					 dazuo_end_regexp=dazuo_end_regexp.."|^(> |)������廨�룬��������Ѹ�ٽ������ڡ�$" --khbd neigong halt





xiulian={
   new=function()
     local x={}
	 x.hp={}
	 setmetatable(x,xiulian)
	 return x
   end,
   min_amount=10,
   safe_qi=10,
   safe_jingxue=10,
   limit=false,
   co=nil,
   halt=false,
   xiulian_failure=function(id)
	   world.EnableGroup("xiulian",false)
       coroutine.resume(xiulian.co,false,id)
   end,
   xiulian_success=function()
       world.EnableGroup("xiulian",false)
       coroutine.resume(xiulian.co,true)
   end,
   hp={},--hp����
}
xiulian.__index=xiulian
function xiulian:fail(id)  --�ص�����

end

function xiulian:success() --�ص�����

end

function xiulian:danger()
   local f=function()
     self:dazuo()
   end
   f_wait(f,3)
end

function xiulian:clear()
  for k, v in pairs (GetTriggerList()) do
    --Note (v)
	local line=GetTriggerInfo(v, 1)
	if line==dazuo_end_regexp then
	   world.DeleteTrigger(v)
	   return
	end
  end
end

--> ս���в������ڹ������߻���ħ��
function xiulian:dazuo()
     if self.halt==true then
	    return
	 end
   local h
   h=hp.new()
   self.hp=h
   h.checkover=function()
     --print("����1")
	 if h.max_neili>=1000 and h.qi_percent>=100 and self.min_amount==10 then
	    self.min_amount=math.modf (h.max_qi/5)
	 end
     if h.qi>self.safe_qi+self.min_amount or h.max_qi<=self.safe_qi+self.min_amount then
	     local qi
		 qi=h.qi-self.safe_qi
		 --print(qi," qi1")
		 --dazuo_trigger()
		 --

		 if self.limit==true then --�������������
             world.Send("set ����")
			 if qi>(h.max_neili*2-h.neili-1) then
		       qi=h.max_neili*2-h.neili-1
			   --modified by 2011-9-13 ��ֹ����̫��
			   if qi>self.min_amount*2 then
			     qi=self.min_amount
			   end
			 else
			    qi=self.min_amount
		     end
			 if qi<self.min_amount then  --̫С
			    qi=self.min_amount
			 end
		 else
		    -- world.Send("unset ����")
			 if qi>(h.max_neili*2-h.neili) then
		       qi=h.max_neili*2-h.neili
			    --modified by 2011-9-13 ��ֹ����̫��
				--print(qi," ֵ")
			   if qi>self.min_amount*2 then
			     qi=self.min_amount
			   end
			 else
                 qi=self.min_amount
		     end
		     if qi<self.min_amount then
		         qi=self.min_amount
		     end
		 end
		 wait.make(function()
		       world.Send("dazuo "..qi)
			   --print("dazuo")
			   --print(dazuo_start_regexp)
			   local l,w=wait.regexp(dazuo_start_regexp,30)
			   if l==nil then
			      print("��ʱ3")
				  self:dazuo()
			      return
			   end
			   if string.find(l,"ս���в������ڹ������߻���ħ") then
			       local f=function()
				      self:dazuo()
				   end
			       safe_room(f)
				   return
			   end
			   if string.find(l,"�����ھ��������޷�������Ϣ������") then
			      self.fail(201)
				  return
			   end
			   if string.find(l,"�˵ز�������") or string.find(l,"���ﲻ׼ս����Ҳ��׼����")  or string.find(l,"���Ҳ��ܴ�������Ӱ�������Ϣ") or string.find(l,"���޷�������������") or string.find(l,"����ɲ���������������ĵط�") then
			      self.fail(202)
				  return
			   end
				if string.find(l,"Ĭ����ħ��") or string.find(l,"Ĭ�˿�����") or string.find(l,"��Ȫ��") or string.find(l,"�˻�����Ψ�Ҷ���") or string.find(l,"������һ�������뵤�������һ����Ϣ�������Ѩ����") or string.find(l,"������������ͼ��ȡ���֮����") or string.find(l,"����Ǭ��һ����") or string.find(l,"Ĭ�˿�������") or string.find(l,"˫�ֺ�ʮ����ͷ����Ǳ������") or string.find(l,"�������죬�ų�һ������") or string.find(l,"��ʹ�����������³������������뼹��") or string.find(l,"˫�ִ�����ǰ�ɻ���״����������") or string.find(l,"�����޼��񹦣����۵���") or string.find(l,"����ǰ���˸�����") or string.find(l,"�������������ù�") or string.find(l,"������Ů�ľ�����Ϣ�������п�ʼ��ת") or string.find(l,"���������£�˫��ƽ����˫ϥ") or string.find(l,"��ϯ�ض���") or string.find(l,"�����������ϥ����") or string.find(l,"�����������Ŀ����") or string.find(l,"˫�ְ�����ǰ������һ��ů���澭��������ת") or string.find(l,"�����󽣾�") or string.find(l,"������һվ��˫�ֻ���̧��") or string.find(l,"�����ڶ��������Ƴ����������������㻺��Ʈ��") or string.find(l,"���˺�һ����������") or string.find(l,"��Ȼ֮�������������Ҿ���") or string.find(l,"һ�����ȵ���Ϣ���ζ�����֮������") or string.find(l,"����ϥ����") or string.find(l,"��������") or string.find(l,"��������ͨ��") or string.find(l,"��ʼ�������Ǵ�") then

				wait.make(function()
				 print("��ʼ����")
				 --print(dazuo_end_regexp)

		         local l,w=wait.regexp(dazuo_end_regexp,60)
			     if l==nil then
					 print("��ʱ2")
					 self:dazuo()
					 return
			     end
			     if string.find(l,"�չ�վ������") or string.find(l,"�����������ȥ") or string.find(l,"�����������ڵ���") or string.find(l,"�ھ������ޱ�") or string.find(l,"ȫ����ˬ��ԡ����") or string.find(l,"վ������") or string.find(l,"�ﵽԲ��֮��") or string.find(l,"��Цһ��վ������") or string.find(l,"�����������۾�") or string.find(l,"����վ������") or string.find(l,"�չ�վ������") or string.find(l,"���������һ����") or string.find(l,"���˹���ϣ�վ������") or string.find(l,"����վ������") or string.find(l,"˫��һ��վ������") or string.find(l,"������������һ��Ԫ") or string.find(l,"����������������������һȦ") or string.find(l,"���ص���չ�վ������") or string.find(l,"���е��̹�Ҳ������������") or string.find(l,"��������������֮�ư�����һ��") or string.find(l,"�����ӵ�վ������") or string.find(l,"˫��һ��վ������") or string.find(l,"�����������ڵ������̧�����۾�") or string.find(l,"���������ڵ�������������۾�") or string.find(l,"����ػָ��������չ�վ������") or string.find(l,"��������ʮ�����죬���ص���") or string.find(l,"�������뵤��") or string.find(l,"��о��Լ��Ѿ��������޼������۵���") or string.find(l,"���������۾���վ������") or string.find(l,"ֻ����ȫ��̩ͨ��") or string.find(l,"�㽫��Ϣ����ȫ��") or string.find(l,"��ȫ��ۼ�����ɫ��Ϣɢȥ") then
                       --print("end")
				       local h1=hp.new()
			           h1.checkover=function()
			             self.success(h1)
			           end
			           h1:check()  --�ɹ�����
					   return
			     end
				 if string.find(l,"����Ϣ�������˻�ȥ") or string.find(l,"��������Ѹ�ٽ�������") or string.find(l,"�漴վ������") or string.find(l,"��Ȼǿ��һ������") or string.find(l,"��΢һ��ü������Ϣѹ�ص���") or string.find(l,"�㳤��һ����������Ϣ�������˻�ȥ") or string.find(l,"������΢΢��������������") or string.find(l,"������һ��������Ϣѹ�ص���") or string.find(l,"��Ҵҽ���Ϣ���˻�ȥ") or string.find(l,"����Ϣһת��Ѹ������") or string.find(l,"����������е�����ǿ��ѹ�ص��վ������") or string.find(l,"��е���������") or string.find(l,"��üͷһ��") or string.find(l,"��˫��һ��������ѹ����Ϣվ������") or string.find(l,"��˫��һ�����������һ������") or string.find(l,"��˫�ۻ����պϣ�Ƭ���͵�����") or string.find(l,"��˫��һ��������ѹ����Ϣվ������") or string.find(l,"���͵�����˫�ۣ�˫��Ѹ�ٻظ���࣬��ϸ��������") or string.find(l,"��üͷһ�壬�������������ַ�������") then
				    --halt
					print("����ǿ���ж�")
					local f=function() self:dazuo() end
					f_wait(f,20)
					return
				 end
	             end)
				  return
			   end
			   if string.find(l,"�������ֽŴ�����������������ȷ������������") then
			     print("��ˮ")
				 local ts=tiaoshui.new()
				 ts.jobDone=function()
				    self:dazuo()
				 end
				 ts:ask_job()
				 return
			   end
			   --if string.find(l,"��˫��һ��������ѹ����Ϣվ������") or string.find(l,"���͵�����˫�ۣ�˫��Ѹ�ٻظ���࣬��ϸ��������") or string.find(l,"��üͷһ�壬�������������ַ�������") then
			      --self.fail(205)
				--  return
			   --end
			   if string.find(l,"ѡ����Ҫ�õ������ڹ�")  then
			      local shield=world.GetVariable("shield") or ""
				  world.Execute(shield)
			      world.Send("jifa all")
			      self:dazuo()
			      return
			   end
				if string.find(l,"��������Ҫ") then
				  --print("t",w[2])
				  self.min_amount=ChineseNum(w[2])
				  --print(self.min_amount,"����")
			      self:dazuo()
			      return
			   end
			   if string.find(l,"���ʩ�ù��ڹ�") then
			     local f=function()
			      self:dazuo()
				 end
				 f_wait(f,0.8)
			   end
			  if string.find(l,"�㻹����ϴ���") then
			    world.Execute("e;w;wear all")
				  local f=function()
			      self:dazuo()
				 end
				 f_wait(f,0.8)
			    return
			  end
		  end)
	 else
	   if h.qi_percent<100 then
	      print("����ʱ������,�ָ�����")
		  self.fail(777)
	   else
          print("û���㹻��Ѫ")
		 --world.Send("yun qi")
          self.fail(1)  --û���㹻��Ѫ
	   end
	 end
   end
   h:check()
end

function xiulian:dazuo2(h)
     self.hp=h
     if h.max_neili>=1000 and h.qi_percent>=100 and self.min_amount==10 then
	    self.min_amount=math.modf (h.max_qi/5)
	 end
     if self.halt==true then
	    return
	 end
	 if h.qi>self.safe_qi+self.min_amount or h.max_qi<=self.safe_qi+self.min_amount then
		local qi
		qi=h.qi-self.safe_qi
		--dazuo_trigger()
		 --
		if self.limit==true then --�������������
		    world.Send("set ����")
		     if qi>(h.max_neili*2-h.neili-1) then
		       qi=h.max_neili*2-h.neili-1
			   if qi>self.min_amount*2 then
			     qi=self.min_amount
			   end
			 else
  			    qi=self.min_amount
		     end
			 if qi<self.min_amount then  --̫С

			   qi=self.min_amount
			 end
		else
		     --world.Send("unset ����")
			 if qi>(h.max_neili*2-h.neili) then
		       qi=h.max_neili*2-h.neili
			   --print(qi," ֵ")
			    if qi>self.min_amount*2 then
			     qi=self.min_amount
			   end
			 else
			    qi=self.min_amount
		     end
		     if qi<self.min_amount then

		        qi=self.min_amount
		     end
		end

		 wait.make(function()
		       world.Send("dazuo "..qi)
			    print("dazuo2")
			   local l,w=wait.regexp(dazuo_start_regexp,30)
			   if l==nil then
			      print("��ʱ2")
				  self:dazuo()
			      return
			   end
			   if string.find(l,"�����ھ��������޷�������Ϣ������") then
			      self.fail(201)
				  return
			   end
			   if string.find(l,"���ﲻ׼ս����Ҳ��׼����")  or string.find(l,"���Ҳ��ܴ�������Ӱ�������Ϣ") or string.find(l,"���޷�������������") then
			      self.fail(202)
				  return
			   end
			  if string.find(l,"�������ֽŴ�����������������ȷ������������") then
			     print("��ˮ")
				 local ts=tiaoshui.new()
				 ts.jobDone=function()
				    self:dazuo()
				 end
				 ts:ask_job()
				 return
			   end
               if string.find(l,"Ĭ����ħ��") or string.find(l,"Ĭ�˿�����") or string.find(l,"��Ȫ��") or string.find(l,"�˻�����Ψ�Ҷ���") or string.find(l,"������һ�������뵤�������һ����Ϣ�������Ѩ����") or string.find(l,"������������ͼ��ȡ���֮����") or string.find(l,"����Ǭ��һ����") or string.find(l,"Ĭ�˿�������") or string.find(l,"˫�ֺ�ʮ����ͷ����Ǳ������") or string.find(l,"�������죬�ų�һ������") or string.find(l,"��ʹ�����������³������������뼹��") or string.find(l,"˫�ִ�����ǰ�ɻ���״����������") or string.find(l,"�����޼��񹦣����۵���") or string.find(l,"����ǰ���˸�����") or string.find(l,"�������������ù�") or string.find(l,"������Ů�ľ�����Ϣ�������п�ʼ��ת") or string.find(l,"���������£�˫��ƽ����˫ϥ") or string.find(l,"��ϯ�ض���") or string.find(l,"�����������ϥ����") or string.find(l,"�����������Ŀ����") or string.find(l,"˫�ְ�����ǰ������һ��ů���澭��������ת") or string.find(l,"�����󽣾�") or string.find(l,"������һվ��˫�ֻ���̧��") or string.find(l,"�����ڶ��������Ƴ����������������㻺��Ʈ��") or string.find(l,"���˺�һ����������") or string.find(l,"��Ȼ֮�������������Ҿ���") or string.find(l,"һ�����ȵ���Ϣ���ζ�����֮������") or string.find(l,"����ϥ����") or string.find(l,"��������") or string.find(l,"��������ͨ��") or string.find(l,"��ʼ�������Ǵ�") then

				wait.make(function()
		         local l,w=wait.regexp(dazuo_end_regexp,60)

				 if l==nil then
					 print("��ʱ2")
					 self:dazuo()
					 return
			     end
				 if string.find(l,"�����������ȥ") or string.find(l,"�����������ڵ���") or string.find(l,"�ھ������ޱ�") or string.find(l,"ȫ����ˬ��ԡ����") or string.find(l,"վ������") or string.find(l,"�ﵽԲ��֮��") or string.find(l,"��Цһ��վ������") or string.find(l,"�����������۾�") or string.find(l,"����վ������") or string.find(l,"�չ�վ������") or string.find(l,"���������һ����") or string.find(l,"���˹���ϣ�վ������") or string.find(l,"����վ������") or string.find(l,"˫��һ��վ������") or string.find(l,"������������һ��Ԫ") or string.find(l,"����������������������һȦ") or string.find(l,"���ص���չ�վ������") or string.find(l,"���е��̹�Ҳ������������") or string.find(l,"��������������֮�ư�����һ��") or string.find(l,"�����ӵ�վ������") or string.find(l,"˫��һ��վ������") or string.find(l,"�����������ڵ������̧�����۾�") or string.find(l,"���������ڵ�������������۾�") or string.find(l,"����ػָ��������չ�վ������") or string.find(l,"��������ʮ�����죬���ص���") or string.find(l,"�������뵤��") or string.find(l,"��о��Լ��Ѿ��������޼������۵���") or string.find(l,"���������۾���վ������") or string.find(l,"ֻ����ȫ��̩ͨ��") or string.find(l,"�㽫��Ϣ����ȫ��") or string.find(l,"��ȫ��ۼ�����ɫ��Ϣɢȥ") then
                       --print("end")
				       local h1=hp.new()
			           h1.checkover=function()
			             self.success(h1)
			           end
			           h1:check()  --�ɹ�����
					   return
			     end
	             end)
				  return
			   end
			   --[[if string.find(l,"��˫��һ��������ѹ����Ϣվ������") or string.find(l,"���͵�����˫�ۣ�˫��Ѹ�ٻظ���࣬��ϸ��������") then
			      self.fail(205)
				  return
			   end]]
			    if string.find(l,"ѡ����Ҫ�õ������ڹ�") then
			      world.Send("jifa all")
			      self:dazuo()
			      return
			   end
				if string.find(l,"��������Ҫ") then
				  --print("t",w[2])
				  self.min_amount=ChineseNum(w[2])
			      self:dazuo()
			      return
			   end
			    if string.find(l,"���ʩ�ù��ڹ�") then
			     local f=function()
			      self:dazuo()
				 end
				 f_wait(f,0.8)
			   end
			   if string.find(l,"�㻹����ϴ���") then
			    world.Execute("e;w;wear all")
				  local f=function()
			      self:dazuo()
				 end
				 f_wait(f,0.8)
			    return
			  end

		  end)

	 else
        print("û���㹻��Ѫ")
        self.fail(1)  --û���㹻��Ѫ
	 end
end

function xiulian:tuna()
    if self.halt==true then
	    return
	 end
   local h
   h=hp.new()
   self.hp=h
   h.checkover=function()
     if h.jingxue>self.safe_jingxue then
	     local jingxue

		 jingxue=h.jingxue-self.safe_jingxue
		 if jingxue>(h.max_jingli*2-h.jingli) then
		    jingxue=h.max_jingli*2-h.jingli
		 end
		 if jingxue<self.min_amount then
		    jingxue=self.min_amount
		 end
		 if jingxue>h.jingxue then
		    jingxue=h.jingxue-self.safe_jingxue
		 end
         --print(h.jingxue," jingxue:",jingxue)
		 wait.make(function()
		   world.Send("tuna "..jingxue)
		    local l,w=wait.regexp("(> |)������۾���ʼ���ɡ�$|^(> |)���������ڴ�����վ��������$|^(> |)����������״��̫���ˣ��޷����о���$|^(> |)���ﲻ׼ս����Ҳ��׼���ɡ�$|^(> |)���Ҳ������ɣ���Ӱ�������Ϣ��$|^(> |)���޷���������������$|^(> |)�������ֽŴ�����������������ȷ�����������ɡ�$",10)
			   if l==nil then
			      print("��ʱ")
				  self:tuna()
			      return
			   end
			   if string.find(l,"����������״��̫���ˣ��޷����о���") then
			      self.fail(301)
				  return
			   end
			   if string.find(l,"���ﲻ׼ս����Ҳ��׼����")  or string.find(l,"���Ҳ������ɣ���Ӱ�������Ϣ��")  or string.find(l,"���޷�������������") then
			      self.fail(202)
				  return
			   end
				if string.find(l,"������۾���ʼ���ɡ�") then
				wait.make(function()
		         local l,w=wait.regexp("^(> |)��������ϣ�����˫�ۣ�վ��������$",3000)
			     if l==nil then
					 print("��ʱ")
					 self:tuna()
					 return
			     end
			     if string.find(l,"��������ϣ�����˫�ۣ�վ��������") then
				       h1=hp.new()
			           h1.checkover=function()
			             self.success(h)
			           end
			           h1:check()  --�ɹ�����
					   return
			     end
	             end)
				  return
			   end
			   if string.find(l,"�������ֽŴ�����������������ȷ������������") then
				  print("��ˮ")
				  local ts=tiaoshui.new()
				  ts.jobDone=function()
				    self:tuna()
				  end
				  ts:ask_job()
			      return
			   end
			   if string.find(l,"���������ڴ�����վ��������") then
			      self.fail(305)
				  return
			   end
				if string.find(l,"��������Ҫ") then
				  --print("t",w[2])
				  self.min_amount=ChineseNum(w[2])
			      self:tuna()
			      return
			   end
			wait.time(10)
		 end)
	 else
        print("û���㹻��Ѫ")
        self.fail(1)  --û���㹻��Ѫ
	 end
   end
   h:check()
end


