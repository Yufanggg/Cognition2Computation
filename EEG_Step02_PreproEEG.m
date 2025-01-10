clear all; clc; close all;
FilePath = 'E:\Exp02\DATA\EEG_clean02\';%place of the data
SavePath1='E:\Exp02\DATA\EEG_clean03\';
mkdir(SavePath1);
sub_name = data_load(FilePath, 'set');
for sub = 1:length(sub_name)% a loop for all data\
    filename = [FilePath,sub_name{sub}];
    EEG = pop_loadset(filename);
    EEG = pop_reref( EEG, [33 34] );
    EEG = pop_select( EEG,'nochannel',{'EXG5' 'EXG6'});
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = pop_saveset( EEG, 'filename',sub_name{sub},'filepath',SavePath1);
    fprintf('*****the subject %d has been done',sub);
end
