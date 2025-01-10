clear all; clc; close all;
FilePath = 'E:\Exp02\DATA\EEG_clean04\';%place of the data
SavePath1='E:\Exp02\DATA\EEG_clean05\';
mkdir(SavePath1);
AllDATA = [];
DesignM = [];
sub_name = data_load(FilePath, 'set');
n = 1;
for sub = 1:length(sub_name)% a loop for all data\
    filename = [FilePath,sub_name{sub}];
    EEG = pop_loadset(filename);
    EEG = pop_rmbase( EEG, [-200     0]); 
    EEG = pop_eegthresh(EEG,1,[1:32] ,-100,100,-0.19922,0.7,0,1);
    EEG = pop_epoch( EEG, {  '11'  '12'  '13'  '14'  '15'  '16'  '17'  '18'  '19'  '20'  '21'  '22'  '23'  '24'  '25'  '26'  '27'  '28'  '29'  '30'  '31'  '32'  '33'  '34'  '35'  '36'  '37'  '38'  '39'  '40'  '41'  '42'  '43'  '44'  '45'  '46'  '47'  '48'  '49'  '50'  '51'  '52'  '53'  '54'  '55'  '56'  '57'  '58'  '59'  '60'  '61'  '62'  '63'  '64'  '65'  '66'  '67'  '68'  '69'  '70'  '71'  '72'  '73'  '74'  '75'  '76'  '77'  '78'  '79'  '80'  '81'  '82'  '83'  '84'  '85'  '86'  '87'  '88'  '89'  '90'  '91'  '92'  '93'  '94'  '95'  '96'  '97'  '98'  '99'  '100'  '101'  '102'  '103'  '104'  '105'  '106'  '107'  '108'  '109'  '110'  '111'  '112'  }, [-0.2  0.7], 'newname', 'BDF file epochs', 'epochinfo', 'yes');
    EEG = pop_saveset( EEG, 'filename',sub_name{sub},'filepath',SavePath1);
    Markers = [];
    for i = 1:length(EEG.event)
        mar = EEG.event(i).type;
        Markers = [Markers; mar]; 
    end
    Markers(find(Markers>178)) = [];
    Markers = unique(Markers);
    
    ElecName =[];
    for i = 1:length(EEG.chanlocs)
        ele = EEG.chanlocs(i).labels;
        ElecName = [ElecName; string(ele)]; 
    end
    splitedCell = strsplit(sub_name{sub}, '.');
    splitedCell2 = strsplit(splitedCell{1}, '_');
    subjID = str2num(splitedCell2{2});
    Design = [repmat(subjID, length(Markers), 1), Markers];
    DesignM = [DesignM; Design];
    j = n + length(Markers)-1;
    sEEG(:, :, n:j) = EEG.data;
    n = j+1;
    for trl = 1:size(EEG.data, 3)
        Frame = [repmat(subjID, length(ElecName), 1), repmat(Markers(trl),length(ElecName), 1), ElecName,  EEG.data(:, :, trl)];
        AllDATA =[AllDATA; Frame];
    end
    

    fprintf('*****the subject %d has been done/n',subjID);
end
cell2csv('Exp02_EEG.csv', AllDATA, ',');
save('Exp02_EEG.mat', 'AllDATA', '-v7.3');
time = EEG.times;
csvwrite('Exp02_EEGtime.csv', time)

csvwrite('Exp02_DesignM.csv', DesignM)

save('Exp_02DesignM_.mat', 'DesignM')
save('Exp_02sEEG_1.mat', 'sEEG')
save('Exp02_time_.mat', 'time')
save('Exp02_chanloc_.mat', 'EEG')
