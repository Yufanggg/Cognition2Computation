function [ rest_eyes ] = data_load( filename,key_words )
%	�Զ���ȡfilename·���µ���key_words�йص��ļ�
% -- input --
%   filename - ��Ҫ��ȡ���ļ���·��
%   key_words - ��Ҫ��ȡ���ļ��ؼ���
% -- output --
%   �����Ҫ�õ����ļ�������

rest = dir(filename);
num = 1;
num1 = 1;
while num
    if(rest(num1).bytes == 0)
        rest(num1) = [];
    else
        num = 0;
    end
end
for i = 1:length(rest)
    rest_name{i} = rest(i).name;
end
if ~isempty(key_words)
    for i = 1:length(rest_name)
        ind = strfind(rest_name{i},key_words);
        if (ind ~= 0)
            kk(i) = i;
        end
    end
    kk = kk(find(kk~=0));
    rest_eyes = cell(1,length(kk));
    for i = 1:length(kk)
        rest_eyes{i} = rest_name{kk(i)};
    end
else
    rest_eyes = rest_name;
end


