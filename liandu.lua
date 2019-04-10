
liandu={
  new=function()
     local ld={}
	 setmetatable(ld,{__index=liandu})
	 return ld
   end,
   liandu_time=0,
}
function liandu:liandu_end()
end

function liandu:lianing()
  wait.make(function()
     local l,w=wait.regexp("^(> |)����ʱ��Ҫ˫�ֵ���ϣ���������û��ǲ�Ҫ��������$|^(> |)��ո�������ɲ��ã�Ƶ��������������Σ�յģ�$|^(> |)ƮȻ��˵�������ðɣ�����������ϰ.*һ�¶����ɡ���$|�͵أ���о���һ�������Ķ���˳�ֱ�Ϯ������Ȼ͸������ھ�ֱ�ֵ��$|^(> |)��һ˲�䣬�㷢���������Ķ������Լ�����ԭ���Ķ����໥�ںϣ�һͬ���ɽ���������$|^(> |)��ȫ����ɣ�����Ϣ�Ե���ѭ�����������Ѩ�������Ƕ�����������ȥ��$|^(> |)��˫��ƽ̧�������������ʼ��۸�ʬ���澭����֮������$|^(> |)�����ھ�������������ȥ���Σ�յģ�$|^(> |)�����ڵ��������㣬ǿ���������Σ�յġ�$",10)
	 if l==nil then
	    self:lianing()
	    return
	 end
	 if string.find(l,"��������û��ǲ�Ҫ������") then
	    local sp=special_item.new()
		sp.cooldown=function()
		   world.Send("liandu")
		   self:lianing()
		end
		sp:unwield_all()
	    return
	 end
	 if string.find(l,"��ո�������ɲ��ã�Ƶ��������������Σ�յ�") or string.find(l,"�����ھ�����") or string.find(l,"ǿ���������Σ�յ�") then
	    self:liandu_end()
	    return
	 end
	 if string.find(l,"����������ϰ") then
	    world.Send("say ϴ���ɾ���ʼ����ɮ��")
	    world.Send("liandu")
		self:lianing()
	    return
	 end
	 if string.find(l,"�����Ƕ�����������ȥ") or string.find(l,"��ʼ��۸�ʬ���澭����֮����") then
	    world.Send("say ������Ҫͣ����")
		self:lianing()
		return
	 end
	 if string.find(l,"��Ȼ͸������ھ�ֱ�ֵ���") or string.find(l,"һͬ���ɽ�������") then
		liandu.liandu_time=os.time()
	    self:liandu_end()
	    return
	 end

  end)
end

function liandu:liandu_corpse()
   world.Send("give zi corpse")
   wait.make(function()
     local l,w=wait.regexp("^(> |)���ƮȻ��һ��.*��ʬ�塣$|^(> |)�Է�����������������$|^(> |)������û������������$",3)
	 if l==nil then

	    return
	 end
	 if string.find(l,"�Է���������������") or string.find(l,"������û����������") then
	    world.Send("drop corpse")
		self:liandu_end()
	    return
	 end
	 if string.find(l,"���ƮȻ��") then
	    print("��ʼ����")

	    self:lianing()
	    return
	 end

   end)
end

function liandu:ask_liandu()
    world.Send("ask zi about ����")
    wait.make(function()
     local l,w=wait.regexp("^(> |)ƮȻ�Ӷ�����ٺ�һЦ�����������ǰɣ���ȥ�����Լ��Ҿ����õ�ʬ��������$|^(> |)ƮȻ��˵�������㻹��Ϊ����ʦ�ֵ��������أ������������������ɡ���$",3)
	 if l==nil then
	    local _R=Room.new()
         _R.CatchEnd=function()
           if _R.roomname=="ɽ��" then
		      world.Send("use fire")
			  wait.time(4)
		      world.Send("zuan")
			  wait.time(1)
			  self:ask_liandu()
		   else
			  self:go()
		   end
         end
		 _R:CatchStart()
	    return
	 end
	 if string.find(l,"��ȥ�����Լ��Ҿ����õ�ʬ����") then
	    local b=busy.new()
		b.Next=function()
	      self:liandu_corpse()
		end
		b:check()
	    return
	 end
	 if string.find(l,"�����������������ɡ���") then
		wait.time(3)
	    self:ask_liandu()
	    return
	 end

   end)
end

function liandu:go()
    local w=walk.new()
	 w.walkover=function()
		world.Send("enter cave")
		world.Send("use fire")
		wait.time(4)
		world.Send("zuan")
		wait.time(1)
		self:ask_liandu()

	 end
	 w:go(2234)
end

function liandu:liandu()
   local t1=os.time()
   local int1= os.difftime(t1,liandu.liandu_time)
   print("���ϴ�����ʱ����:",int1)
   if int1<=600 then --ʮ���� ����
       world.Send("drop corpse")
	   world.Send("drop skeleton")
	  self:liandu_end()
	  return
   end
   	   local sp=special_item.new()
       sp.cooldown=function()
	      print(table.getn(sp.equipment_items))
		  for _,i in ipairs(sp.equipment_items) do
	          --print(i.name,i.id,i.num)
			  if string.find(i.name,"ʬ��") then
			     self:go()
				 return
			  end
	      end
           self:liandu_end()
       end
       local equip={}
	   equip=Split("<��ȡ>����|<����>����|<����>���õ�ʬ��|<����>���õ�Ůʬ|<����>���õ���ʬ","|")
	   sp.recheck=function(item_name,item_id)
	      sp:check_items(equip)
	   end
       sp:check_items(equip)
end

--[[�㿪ʼ�����������������󷨹�������ȫ��
> �㽫�����������������΢΢��̧��˫��ƽ�찴�ڸ��õ�ʬ���ϡ�
�㼱�߻����󷨣������ڵĶ��غ͹���˳�ֱ�ֱ�������õ�ʬ���ϡ�
��ʬ�ڵĶ��ؿ�ʼ��������һ�㣬��˳�������������������
��ҥ�ԡ�ĳ�ˣ�����Ū����һ����ʯ����
��ȫ����ɣ�����Ϣ�Ե���ѭ�����������Ѩ�������Ƕ�����������ȥ��
�����ġ���̩(Kang tai)���������թ�ն񣬾�ȻͶ����͢�������ӵ��߹������С��...

��˫���ζ���ָ���ס��ʬ�ķ���̫��֮������������н�������󳦣���ѭθ�ڣ����Ҹ�£�
����������֮ǰ��ѭ�����Ϲ����������ڣ����㣬��ָ����ѭ��ʣ�����ָ֮�ˣ���ָ����ֱ
����ָ����������ˣ��������н���
��ҥ�ԡ�ĳ�ˣ�����Ū����һ�������裡

��ʬ�ڵĶ���Խ��Խ�ܡ���˫צ�ι�������ע����������֮������춴�ָ��ָ֮�ˣ�ѭָ������
���Ϲ�����֮�䣬��������֮�У�ѭ���������ϼ磬�ϳ������֮���ϣ�����ȱ����Σ���֧�ߣ�
���Ͼ���գ����³��У�����Ю�ڣ������У���֮�ң���֮����Ю�ǿף�����Ϣ������������
����

����ʦ���桿�������꿨����������������ʱ�� ��

����ʦ���桿�������ʱ�仹ʣ�� 1Сʱ15 ��25 �롣
��ҥ�ԡ�ĳ�ˣ����˴��ű��������ڼ���һ�����֣�

���ٽ�˫�ư��ڸ�ʬ����������֮������һ��һ�����������أ���أ��ϳ���ָ֮�䣬����������
֮�䣬�ϼ������������֮�ᣬ��ȱ�裬�����У�ɢ���İ����ִ������ϳ�ȱ�裬���ֱ�ϳ���
�Ͻǣ������¼������ִӶ�������У����߶�ǰ�����ա���·����һ����
��˫��ƽ̧�������������ʼ��۸�ʬ���澭����֮������
��ҥ�ԡ�ĳ�ˣ���˵���δ���Զ�Ŵ������һ����ͭ��
������������м�֮�£�����ë�ʣ�ѭ����Ϲ�Ԫ�����ʺ�����ѭ�棬��Ŀ���࣡
hp

����Ѫ�� 2003 /  2003 (100%)  �������� 2652 /  3163(3657)
����Ѫ�� 3318 /  3318 (100%)  ��������  485 /  3240(+1)
�������� 510,765          ���������ޡ� 3594 /  4742
��ʳ�  49.50%              ��Ǳ�ܡ�  265 /  316
����ˮ��  81.00%              �����顤 1,002,561 (62.62%)
> �������ߣ����ڸ��У�ѭ���ף��������أ�
l
ɽ�� -
    �����Ǻ������ɽ������ֲ�����ָ��ֻ��һ˿΢��Ӷ������ѷ�͸��
����������ǿ������������һ��ʯ�ף�ɢ����Ũ��ĸ�ʬ��ζ��΢���¸��Ե�
������ɭ���¡�һ����һ�����Ӱ����ʯ�ڱߣ���ֻ����������۾���������
����ɽ�������˹�����֮����
    ����û���κ����Եĳ�·��
  ��ľ����(Shenmu wangding)
  ʯ��(Shi guan)
  �����ɵڶ������ӡ���������ʦ�֡�ƮȻ��(Piaoran zi)
>
use fire
ʲô��
>> �����ڵ��������㣬ǿ���������Σ�յġ�
use fire
ʲô��
>
l
ɽ�� -
    �����Ǻ������ɽ������ֲ�����ָ��ֻ��һ˿΢��Ӷ������ѷ�͸��
����������ǿ������������һ��ʯ�ף�ɢ����Ũ��ĸ�ʬ��ζ��΢���¸��Ե�
������ɭ���¡�һ����һ�����Ӱ����ʯ�ڱߣ���ֻ����������۾���������
����ɽ�������˹�����֮����
    ����û���κ����Եĳ�·��
  �����ɵڶ������ӡ���������ʦ�֡�ƮȻ��(Piaoran zi)
  ʯ��(Shi guan)
  ��ľ����(Shenmu wangding)
>
i
�����ϴ���ʮ�˼�����(���� 34.29%)��
  �Ķ��ƽ�(Gold)
  ���Ŵ󻹵�(Dahuan dan)
  ��ʮ��������(Silver)
  ��ʮ����ͭǮ(Coin)
����������(Jinhu pifeng)
����׿�ѥ(Ruan xue)
���Ƹ���(Cloth)
  ���Ž�������ܿ�(Wkcard)
  һ˫����(Shoes)
  һ������������(Good staff)
  һ���ֵ�(Blade)
  һ��������(Miegod zhang)
  һ֧����(Fire)
  һ������(Cloth)
  һ��ľ��(Mu jian)
  һ�Ŵ�����Ϣ��(Chuanbei wan)
  һ�������ϻ�ɢ(Hehuan san)
>
use fire
ʲô��
>
�͵أ���о���һ�������Ķ���˳�ֱ�Ϯ������Ȼ͸������ھ�ֱ�ֵ��
��һ˲�䣬�㷢���������Ķ������Լ�����ԭ���Ķ����໥�ںϣ�һͬ���ɽ���������]]
