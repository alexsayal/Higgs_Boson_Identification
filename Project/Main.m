%%%%% ====== Pattern Recognition Techniques ===== %%%%%
%%%%% ===== Alexandre Sayal | Sara Oliveira ===== %%%%%
%%%%% =================== 2015 ================== %%%%%
%%%%% =========== Project Preprocessing ========= %%%%%

%% Import Data
clear, clc;

load higgs_data.mat;

[rawlabels,eventID,rawcolumn_names,rawdata] = dataimport( higgs_data_for_optimization , column_names);

clear higgs_data_for_optimization;

%% Balance between decay and background events
tbl = tabulate(rawlabels);

figure();
    h = pie(tbl(:,3));
    hp = findobj(h, 'Type', 'patch');
    set(hp(1), 'FaceColor', [0 0.4470 0.7410]); set(hp(2), 'FaceColor', [0.8500 0.3250 0.0980]);
    title('Class distribution of original data');
    legend('Decay','Background');

clear tbl h hp;

%% New datasets
data = rawdata;
labels = rawlabels;
column_names = rawcolumn_names;

%% Missing values
method = {'mean','mode','meanclass','removeevents','removefeatures'};

[ MVdata , MVlabels , rownum , colnum , MVcolumn_names ] = missingvalues( data , labels , column_names, method{5} );

clear method;

%% Normalization
[normdata , m , sigma ] = scalestd(MVdata);

%% Feature Selection
option = 1;

switch option
%----Kruskal-Wallis----%
    case 1
        threshold = 10; %---Number of features desired based on chi2 values
        [FSdata , FScolumn_names , FSfeatures] = FS_kruskal( normdata , MVlabels , MVcolumn_names , threshold );
        
%----Correlation between features----%   
    case 2
        threshold = 0.80; %---Correlation cut-off value
        [FSdata , FScolumn_names , FSfeatures] = FS_corr( normdata , MVlabels , MVcolumn_names , 'feat' , threshold);
        
%----Correlation between features and labels----% 
    case 3
        threshold = 0.10; %---Correlation cut-off value
        [FSdata , FScolumn_names , FSfeatures] = FS_corr( normdata , MVlabels , MVcolumn_names , 'featlabel' , threshold);
        
%----mRMR----% 
    case 4
        threshold = 15; %---Number of features desired
        [FSdata , FScolumn_names , FSfeatures] = FS_mRMR( normdata , MVlabels , MVcolumn_names , threshold );
        
%----Area under curve----% 
    case 5
        threshold = 0.5; %---AUC cut-off value
        [FSdata , FScolumn_names , FSfeatures] = FS_AUC( normdata , MVlabels , MVcolumn_names , threshold );

%----Fisher Score----% 
    case 6
        threshold = 14; %---Number of features desired
        [FSdata , FScolumn_names , FSfeatures] = FS_fisher(normdata , MVlabels , column_names, threshold ); 

end

clear option threshold;

%% Feature Reduction

%----Create Structure----%
FRdataTemp.X = FSdata';
FRdataTemp.y = MVlabels';
FRdataTemp.dim = size(FSdata,2);
FRdataTemp.num_data = size(FSdata,1);

option = 2;

switch option
%----PCA----%
    case 1
        threshold = 0.40; %---Percentage of Eigenvalues to keep
        [ FRdata , W ] = FeatureReduction( FRdataTemp , 'pca' , threshold );
        
%----LDA----%        
    case 2
        threshold = 2; %---Number of features desired
        [ FRdata , W ] = FeatureReduction( FRdataTemp , 'lda' , threshold );
end

FRdata = FRdata';

clear option FRdataTemp threshold;

%% Cross Validation
% Partition the data into training set and test set.
% The training set will be used to calibrate/train the model parameters.
% The trained model is then used to make a prediction on the test set.

data_to_use = FSdata;
%data_to_use = FRdata;

% Hold 25% of the data, selected randomly, for test phase.
cv = cvpartition(length(data_to_use),'holdout',0.25);

%---Training set
Xtrain = data_to_use(cv.training(1),:);
Ytrain = MVlabels(cv.training(1),:);
%---Test set
Xtest = data_to_use(cv.test(1),:);
Ytest = MVlabels(cv.test(1),:);

%---Display class distribuition
disp('Training Set:')
tabulate(Ytrain)
disp('Test Set:')
tabulate(Ytest)

%% Classification

class = {'bayes','fld','svm','kNN','kmeans','mindist'};
selected = class{5};

switch selected
    case 'bayes'
        %%---Bayes Classifier
        nfold = 10;
        type = {'df','cls'}; stype = 1;
        [ CL_bayes_performance , CL_bayes_model ] = CL_bayes( Xtrain , Ytrain , Xtest , Ytest , type{stype} , nfold);

    case 'fld'
        %%---FLD Classifier
        nfold = 10;
        type = {'linear','quad'}; stype = 1;
        [ CL_fld_performance , CL_fld_model ] = CL_fld( Xtrain , Ytrain , Xtest , Ytest , type{stype} , nfold );
        
    case 'svm'
        %%---SVM
        nfold = 10;
        C = -16:2:16;
        [ CL_svm_performance , CL_svm_model ] = CL_SVM( Xtrain , Ytrain , Xtest, Ytest , C , nfold);
        
    case 'kNN'
        %%---kNN
        nfold = 10;
        K = 15:30;
        [ CL_kNN_performance , CL_kNN_model ] = CL_kNN( Xtrain , Ytrain , Xtest, Ytest , K , nfold);
        
    case 'kmeans'
        %%---K-means
        nfold = 10;
        [ C_kmean_performance , C_kmeans_model ] = C_kmeans( Xtrain , Ytrain , nfold );
       
%     case 'mindist'
%         %%---Minimum Distance
%         if i==1; bestperf_mindist = 0; end;
%         [ performance_mindist , model_mindist ] = CL_mindist( Xtrain , Ytrain , Xtest, Ytest );
%         if performance_mindist>bestperf_mindist
%             bestperf_mindist = performance_mindist;
%             bestmodel_mindist = model_mindist;
%         end
end

