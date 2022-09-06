
clc;clear;close all;

addpath(genpath('utils'));

%% parameters setting
params.dicmethod = 'pca';
params.activation = 'tanh';
params.poolcode = 'sop';
params.offvalue = 0.001;
params.pyramid = [1,2,4,8];
params.rfSize = [5,9,13];
params.numFilter = [20,20,20];  

dataset = 'FERET';
DIM = [150,90];

%% load feret data
[fa,fb,fc,dup1,dup2,CDTrain] = processFERETData;
clear fa_150X90 fb_150X90 fc_150X90 dup1_150X90 dup2_150X90 CDTrain_150X90;
clear fa_label fb_label fc_label dup1_label dup2_label;
    
%%
fprintf('==================================================================\n');
fprintf('\t\t\t\tExperiment on Dataset: %s\n\n',dataset);  
disp(params);
fprintf('===================================================================\n');

fprintf('********************* Learning M,P,DICT *********************\n');    

%% zca and pca filter learning
% try 
%     load(getFilterSaveName(dataset,params));
% catch
    rfZCADIC = zcaDictLearn(params,dataset,CDTrain.data',DIM);
% end
figure(996);
subplot(1,3,1);display_network(rfZCADIC{1}.dictionary');
subplot(1,3,2);display_network(rfZCADIC{2}.dictionary');
subplot(1,3,3);display_network(rfZCADIC{3}.dictionary');
% pause(3);close 996;

%% Extract Training Features
fprintf('\n============= Extracting Feature for Training Set "FA"\n');
trainXfea = extractFeature(fa.data', rfZCADIC, DIM, params);
trainLabel = double(fa.label);
clear fa;

%% Learning WPCA projection
fprintf('\n============= Learning WPCA\n');
[trainXfea_wpca,WPCAProj,meanimage] = myWPCA(trainXfea,1000);

%% Testing 
TestMatName = {'FB','FC','DUP1','DUP2'};
acc = zeros(2,4);
for jj = 1:4
    fprintf('\n============= Compute acc and accwpca for "%s"\n',TestMatName{jj});
    fprintf('============= Extracting Feature for Testing Set "%s"\n',TestMatName{jj});
    switch jj
        case 1
            testData = fb.data; testLabel = double(fb.label);clear fb;
        case 2
            testData = fc.data; testLabel = double(fc.label);clear fc;
        case 3
            testData = dup1.data; testLabel = double(dup1.label);clear dup1;
        case 4
            testData = dup2.data; testLabel = double(dup2.label);clear dup2;
    end
    testXfea = extractFeature(testData', rfZCADIC, DIM, params);
    
    testXfea_wpca = WPCAProj*bsxfun(@minus,testXfea,meanimage); 

    fprintf('============= Start Classification for "%s"\n',TestMatName{jj});
    acc(1,jj) = nnClassifier(trainXfea,testXfea,trainLabel,testLabel,'cosine');
    acc(2,jj) = nnClassifier(trainXfea_wpca,testXfea_wpca,trainLabel,testLabel,'cosine');
    clear testData testLabel testXfea testXfea_wpca 
end
fprintf('\n\n\n============= Accuracy and Accuracy with WPCA\n');
disp(acc);


