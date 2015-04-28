%%%%% ====== Pattern Recognition Techniques ===== %%%%%
%%%%% ===== Alexandre Sayal | Sara Oliveira ===== %%%%%
%%%%% =================== 2015 ================== %%%%%
%%%%% =========== Project Preprocessing ========= %%%%%

%% Import Data
clear, clc;

load higgs_data.mat;

[labels,eventID,column_names,data,testdata,testlabels] = dataimport( higgs_data_for_optimization , column_names);

clear higgs_data_for_optimization;

%% Balance between decay and background events
balance = zeros(2,1);
balance(1) = length(labels(labels==1))*100 / (length(labels(labels==2))+length(labels(labels==1)));
balance(2) = 100-balance(1);
figure();
    pie(balance);
    title('Class distribution of original data');
    legend('Decay','Background');

%% Missing values
method = {'mean','mode','remove'};

[ MVdata , MVlabels , rownum ] = missingvalues( data , labels , method{1} );

clear method;

%% Normalization
normdata = scalestd(MVdata);

%% Feature Selection
option = 1;

switch option
%----Kruskal-Wallis----%
    case 1
        threshold = 0.95; %---Percentage of chi2 values to keep
        FSdata = FS_kruskal( normdata , MVlabels , column_names , threshold );
        
%----Correlation between features----%   
    case 2
        threshold = 0.80; %---Correlation cut-off value
        [FSdata , FScolumn_names] = FS_corr( normdata , MVlabels , column_names , 'feat' , threshold);
        
%----Correlation between features and labels----% 
    case 3
        threshold = 13; %---Number of features desired
        [FSdata , FScolumn_names] = FS_corr( normdata , MVlabels , column_names , 'featlabel' , threshold);
        
%----mRMR----% 
    case 4
        threshold = 15; %---Number of features desired
        [FSdata , FScolumn_names] = FS_mRMR( normdata , MVlabels , column_names , threshold );
        
%----Area under curve----% 
    case 5
        threshold = 0.5; %---AUC cut-off value
        [FSdata , FS_column_names] = FS_AUC( normdata , MVlabels , column_names , threshold );

%----Fisher Score----% 
    case 6
        threshold = 14; %---Number of features desired
        [FSdata , FS_column_names] = FS_fisher(normdata , MVlabels , column_names, threshold ); 

end

clear option threshold;

%% Feature Reduction

%----Create Structure----%
FRdataTemp.X = FSdata';
FRdataTemp.y = MVlabels';
FRdataTemp.dim = size(FSdata,2);
FRdataTemp.num_data = size(FSdata,1);

option = 1;

switch option
%----PCA----%
    case 1
        threshold = 0.95; %---Percentage of Eigenvalues to keep
        [ FRdata ] = FeatureReduction( FRdataTemp , 'pca' , threshold );
        
%----LDA----%        
    case 2
        threshold = 2; %---Number of features desired
        [ FRdata ] = FeatureReduction( FRdataTemp , 'lda' , threshold );
end

clear option FRdataTemp threshold;