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
        threshold = 2; %---Number of features desired
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

class = {'bayes','fld','svm','kNN','kmeans','mindist'};
selected = class{4};

for i=1:fold
    
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
    
    switch selected
        case 'bayes'
            %%---Bayes Classifier
            if i==1; bestperf_bayes = 0; end;
            [ performance_bayes , model_bayes ] = CL_bayes( Xtrain , Ytrain , Xtest , Ytest , 'df');
            if performance_bayes>bestperf_bayes
                bestperf_bayes = performance_bayes;
                bestmodel_bayes = model_bayes;
            end
            
        case 'fld'
            %%---FLD Classifier
            if i==1; bestperf_fld = 0; end;
            [ performance_fld , model_fld ] = CL_fld( Xtrain , Ytrain , Xtest , Ytest , 'linear' );
            if performance_fld>bestperf_fld
                bestperf_fld = performance_fld;
                bestmodel_fld = model_fld;
            end
            
        case 'svm'
            %%---SVM
            [ performance_svm , model_svm ] = CL_SVM( Xtrain , Ytrain , Xtest, Ytest);
            
        case 'kNN'
            %%---kNN
            K = 25;
            if i==1; bestperf_kNN = 0; end;
            [ performance_kNN , model_knn ] = CL_kNN( Xtrain , Ytrain , Xtest, Ytest , K);
             if performance_kNN>bestperf_kNN
                bestperf_kNN = performance_kNN;
                bestmodel_kNN = model_knn;
             end
            
        case 'kmeans'
            %%---K-means
            if i==1; bestperf_kmeans = 0; end;
            [ performance_kmeans , model_kmeans ] = C_kmeans( Xtrain , Ytrain  );
            if performance_kmeans>bestperf_kmeans
                bestperf_kmeans = performance_kmeans;
                bestmodel_kmeans = model_kmeans;
            end
            
        case 'mindist'
            %%---Minimum Distance
            if i==1; bestperf_mindist = 0; end;
            [ performance_mindist , model_mindist ] = CL_mindist( Xtrain , Ytrain , Xtest, Ytest );
            if performance_mindist>bestperf_mindist
                bestperf_mindist = performance_mindist;
                bestmodel_mindist = model_mindist;
            end
    end
end
