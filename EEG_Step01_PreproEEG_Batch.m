clear all; clc; close all
SavePath1 = 'E:\Exp02\DATA\EEG_clean01\';%place of the data
FilePath='E:\Exp02\DATA\EEG\';
mkdir(SavePath1);
sub_name = data_load(FilePath, 'bdf');
%% STEP01 PREPROCESSING: get the dataset into the memory and run ica
for sub = 1:length(sub_name)% a loop for all data\
    filename = [FilePath,sub_name{sub}];
    EEG = pop_biosig(filename);
    EEG = pop_chanedit(EEG, 'lookup','E:\\Exp02\\EEGCode\\standard_1020.elc');
%     EEG = pop_reref( EEG, [37 38] );
    EEG = pop_eegfiltnew(EEG, 0.1,30,333792,0,[],0);
    EEG = pop_eegfiltnew(EEG, 48,52,31690,1,[],0);
    EEG = pop_resample( EEG, 256);
    EEG = pop_epoch( EEG, {  '11'  '12'  '13'  '14'  '15'  '16'  '17'  '18'  '19'  '20'  '21'  '22'  '23'  '24'  '25'  '26'  '27'  '28'  '29'  '30'  '31'  '32'  '33'  '34'  '35'  '36'  '37'  '38'  '39'  '40'  '41'  '42'  '43'  '44'  '45'  '46'  '47'  '48'  '49'  '50'  '51'  '52'  '53'  '54'  '55'  '56'  '57'  '58'  '59'  '60'  '61'  '62'  '63'  '64'  '65'  '66'  '67'  '68'  '69'  '70'  '71'  '72'  '73'  '74'  '75'  '76'  '77'  '78'  '79'  '80'  '81'  '82'  '83'  '84'  '85'  '86'  '87'  '88'  '89'  '90'  '91'  '92'  '93'  '94'  '95'  '96'  '97'  '98'  '99'  '100'  '101'  '102'  '103'  '104'  '105'  '106'  '107'  '108'  '109'  '110'  '111'  '112'  }, [-0.2  0.7], 'newname', 'BDF file epochs', 'epochinfo', 'yes');

    EEG = pop_rmbase( EEG, [-200     0]);  
    EEG = pop_select( EEG,'nochannel',{'EXG1' 'EXG2' 'EXG3' 'EXG4' 'EXG7' 'EXG8' 'GSR1' 'GSR2' 'Erg1' 'Erg2' 'Resp' 'Plet' 'Temp'});
    
%     EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = pop_saveset( EEG, 'filename',sub_name{sub},'filepath',SavePath1);
    fprintf('*****the subject %d has been done',sub);
end
