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
balance = zeros(2,1);
balance(1) = length(labels(labels==1))*100 / (length(labels(labels==2))+length(labels(labels==1)));
balance(2) = 100-balance(1);
figure();
    h = pie(balance);
    hp = findobj(h, 'Type', 'patch');
    set(hp(1), 'FaceColor', [0 0.4470 0.7410]); set(hp(2), 'FaceColor', [0.8500 0.3250 0.0980]);
    title('Class distribution of original data');
    legend('Decay','Background');

clear h hp;

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
        threshold = 3; %---Number of features desired
        [ FRdata , W ] = FeatureReduction( FRdataTemp , 'lda' , threshold );
end

clear option FRdataTemp threshold;

%% Cross Validation
% Partition the data into training set and test set.
% The training set will be used to calibrate/train the model parameters.
% The trained model is then used to make a prediction on the test set.

% Hold 40% of the data, selected randomly, for test phase.
fold = 10;
cv = cvpartition(length(FRdata),'kfold',fold);

%% Classification - Train
i = 1;
%---Training set
Xtrain = FRdata(:,cv.training(i));
Ytrain = MVlabels(cv.training(i),:);
%---Test set
Xtest = FRdata(:,cv.test(i));
Ytest = MVlabels(cv.test(i),:);

%---Display class distribuition
disp('Training Set:')
tabulate(Ytrain)
disp('Test Set:')
tabulate(Ytest)

%% 
%%---Bayes Classifier
[ performance_bayes , model_bayes ] = CL_bayes( Xtrain , Ytrain , Xtest , Ytest , 'df');

%%
%%---FLD Classifier
[ performance_fld , model_fld ] = CL_fld( Xtrain , Ytrain , Xtest , Ytest , 'linear' );

%%
%%---SVM
[ performance_svm , model_svm ] = CL_SVM( Xtrain , Ytrain , Xtest, Ytest);

%%
%%---kNN
K = 25;
[ performance_kNN , model_knn ] = CL_kNN( Xtrain , Ytrain , Xtest, Ytest , K);

%%
%%---K-means
[ performance_kmeans , model_kmeans ] = C_kmeans( Xtrain , Ytrain  );


