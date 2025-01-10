function [ rest_eyes ] = data_load( filename,key_words )
%	自动读取filename路径下的与key_words有关的文件
% -- input --
%   filename - 想要读取的文件的路径
%   key_words - 想要读取的文件关键字
% -- output --
%   输出所要得到的文件的名字

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


