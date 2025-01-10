%% B_analysis 
% Perform lmeEEG on simulated EEG data 
clear all;clc
load('E:\Exp02\EEGCode\Exp02_chanloc_.mat');
load('E:\Exp02\EEGCode\Exp02_time_.mat');
load('E:\Exp02\EEGCode\Exp02_sEEG_1.mat');
DesignM = readtable('E:\Exp02\EEGCode\Exp02_DesignM.csv');
DesignM.Properties.VariableNames = {'SubjID', 'Markers'};
DesignM.Properties.VariableNames{'Markers'} = 'Marker3';
unique_SubjID = unique(DesignM.SubjID);
Table = readtable('SemCatEStork.csv');
Table.Properties.VariableNames{'x___Target'} = 'Target';
Table2 = readtable('FreqDistra.csv');
Table = innerjoin(Table, Table2,'Keys', {'Distractor'});

repeatedTable = repmat(Table, 36, 1);
SubjList = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,...
    27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, ...
    45, 46];
repeatedTable.SubjID = reshape(repelem(SubjList, 102),  3672, 1);

mergedTable = innerjoin(DesignM, repeatedTable,'Keys', {'SubjID', 'Marker3'});



Order = readtable('Exp02_SeqSI.csv');
repeatedOrder = innerjoin(mergedTable, Order, 'Keys', {'SubjID', 'Marker3'});


rowsToRemove = repeatedOrder.SubjID == 12 | repeatedOrder.SubjID == 44 |...
    repeatedOrder.ExpTrialList == 1 | repeatedOrder.ExpTrialList == 2 |...
    repeatedOrder.ExpTrialList == 3 | repeatedOrder.ExpTrialList == 4 |...
    repeatedOrder.ExpTrialList == 74 | repeatedOrder.ExpTrialList == 75 |...
    repeatedOrder.ExpTrialList == 76 | repeatedOrder.ExpTrialList == 77;

repeatedOrder(rowsToRemove, :) = [];
sEEG = sEEG(:, :, ~rowsToRemove);

channelinfo = EEG.chanlocs;

clear DesignM EEG mergedTable Order repeatedTable rowsToRemove ...
    SubjList Table unique_SubjID
save('well_preparedData.mat');
disp('Data is well-organized!!!!!!!!!!');
%% STEP 1
% Conduct mixed models on each channel/timepoint combination.
ID = nominal(repeatedOrder.SubjID); Item=nominal(repeatedOrder.Target); 
%CON = categorical(repeatedOrder.Condition);
JSD = categorical(repeatedOrder.JSD);
Classifier = categorical(repeatedOrder.ClassifierCongruency);
Freq = log(repeatedOrder.Frequency);
Stroke = (repeatedOrder.NumbersofStorks - mean(repeatedOrder.NumbersofStorks))/std(repeatedOrder.NumbersofStorks);
CongruencySemanticCategories = categorical(repeatedOrder.CongruencySemanticCategories);
mEEG = nan(size(sEEG));

for ch = 1:size(sEEG,1)
    for tpoint = 1:size(sEEG,2)
        EEG = double(squeeze(sEEG(ch,tpoint,:)));
        EEG = table(EEG, CongruencySemanticCategories,Stroke, Freq, JSD, Classifier, ID, Item);
        m = fitlme(EEG,'EEG~CongruencySemanticCategories + Stroke + Freq + JSD + Classifier + +(1|ID)+(1|Item)');
        
        mEEG(ch,tpoint,:) = fitted(m,'Conditional',0)+residuals(m);
        Coeff = fixedEffects(m);
        Coeff_1 = Coeff(2:4); X = designMatrix(m); X_1 = X(:, 2:4);
        coeff_CongruencySemanticCategories_1 = Coeff(strcmp(m.CoefficientNames, 'CongruencySemanticCategories_1'));
        Coeff_Stroke = Coeff(strcmp(m.CoefficientNames, 'Stroke'));
        coeff_Freq = Coeff(strcmp(m.CoefficientNames, 'Freq'));
        Coeff_Intercept = Coeff(strcmp(m.CoefficientNames, '(Intercept)'));

%         m = fitlme(EEG,'EEG~Freq+Stroke+Animacy+Classifier+Animacy:Classifier+(1|ID)+(1|Item)');
        mEEG(ch,tpoint,:) = fitted(m,'Conditional',0)+residuals(m) - X_1 * Coeff_1;
        
    end
end

% Extract design matrix X
EEG = double(squeeze(sEEG(1,1,:)));
% EEG = table(EEG,Freq,Stroke,Animacy,Classifier,ID,Item);
EEG = table(EEG,Classifier,ID,Item);
m = fitlme(EEG,'EEG~Classifier+(1|ID)+(1|Item)');
% m = fitlme(EEG,'EEG~Freq+Stroke+Animacy+Classifier+Animacy:Classifier+(1|ID)+(1|Item)');

X = designMatrix(m);
clear EEG EEGall
save('./Output/marginalResult_Classifier.mat');
clear EEG repeatedOrder tpoint;
disp('the marginalization stage is done!!!!!!!!!!');
%% Step 2
% Perform mass univariate linear regressions on ???marginal??? EEG data.
%f_obs = nan(size(mEEG,1),size(mEEG,2));

t_obs = nan(size(mEEG,1),size(mEEG,2),size(X,2));
beta_obs = nan(size(mEEG,1),size(mEEG,2),size(X,2));
se_obs = nan(size(mEEG,1),size(mEEG,2),size(X,2));
for ch = 1:size(mEEG,1)
    parfor tpoint = 1:size(mEEG,2)
        EEG = squeeze(mEEG(ch,tpoint,:));
        [t_obs(ch,tpoint,:), beta_obs(ch,tpoint,:), se_obs(ch,tpoint,:)]=lmeEEG_regress(EEG,X);
        mdl_summary = anova(fitlm(X, EEG), 'summary');
        f_obs(ch,tpoint, :)= mdl_summary.F(2);
    end
end
save('./Output/observed_stage_classifier.mat');
disp('the observation stage is done!!!!!!!!!!');
%% Step 3 permutations
% Perform permutation testing ...
nperms=999;
num_rows = size(X,1);
% rperms = randperm(num_rows);

% [rperms] = lmeEEG_permutations4(nperms, Animacy, Classifier, ID, Item);
f_perms = nan(nperms,size(mEEG,1),size(mEEG,2));
t_perms = nan(nperms,size(mEEG,1),size(mEEG,2),size(X,2));
beta_perms = nan(nperms,size(mEEG,1),size(mEEG,2),size(X,2));
se_perms = nan(nperms,size(mEEG,1),size(mEEG,2),size(X,2));
perm_t=nan(nperms,size(mEEG,1),size(mEEG,2));
for p =1:nperms
    XX = X(randperm(num_rows),:);
%     XX = X(rperms(:,p),:);
    for ch = 1:size(mEEG,1)
        parfor tpoint = 1:size(mEEG,2)
            EEG = squeeze(mEEG(ch,tpoint,:));
            tic
            [t_perms(p,ch,tpoint,:), beta_perms(p,ch,tpoint,:),se_perms(p,ch,tpoint,:)]=lmeEEG_regress(EEG,XX);
            perm_t(p,ch,tpoint)=toc;
            mdl2_summary = anova(fitlm(XX, EEG),'summary');
            f_perms(p,ch,tpoint) = mdl2_summary.F(2);
        end
    end
end

save('./Output/permutate_stage_classifier.mat');

disp('the permutation stage is done!!!!!!!!!!');
%% ... and apply TFCE.
X = designMatrix(m);
for i = 2:size(X,2)
    if ndims(t_obs) == 3
        Results.(matlab.lang.makeValidName(m.CoefficientNames{i})) = lmeEEG_TFCE(squeeze(t_obs(:,:,i)),squeeze(t_perms(:,:,:,i)),channelinfo,[0.66 2]);
    elseif ndims(t_obs) == 4
        Results.(matlab.lang.makeValidName(m.CoefficientNames{i})) = lmeEEG_TFCE(squeeze(t_obs(:,:,:,i)),squeeze(t_perms(:,:,:,:,i)),channelinfo,[0.66 2]);
    end
end

Results2 = lmeEEG_TFCE(squeeze(f_obs(:,:)),squeeze(f_perms(:,:,:)),channelinfo,[0.5 1]);
save('./Output/tfce_stage_classifierr.mat');
%%
mT = Results2.Obs;
mT2 = mT;
mT(not(Results2.Mask))=0;
tick_labels = reshape({channelinfo.labels}, 32, 1);


figure,
imagesc(mT)
xlim([0 230])
set(gca,'ytick',1:32,'FontSize',15,'FontName','Arial');
set(gca,'TickLength',[0 0]);
set(gca,'XTick',linspace(1,230,10),'XTickLabel',-200:100:700,'FontSize',15,'FontName','Arial');
yticklabels(tick_labels);
hc=colorbar;
xlabel("Time (ms)","FontWeight","bold","FontSize",30, "FontName","Arial");
ylabel(hc,'f-value','FontWeight','bold','FontSize',30,'FontName','Arial');

cmap2=cmap; cmap2(129,:)=[.8 .8 .8];
set(gca,'clim',[-20 20],'colormap',cmap2)

set(gca,'color','none')

a = get(hc,'YTickLabel')
set(hc, 'colormap', cmap,'YTickLabel',a,'FontSize',8,'FontName','Arial');
