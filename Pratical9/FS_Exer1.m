clear , clc;

%% Import
[data , column_names] = xlsread('FIRMS.XLS','Data');

train_set = data(1:500,3:end);
test_set = data(501:end,3:end);
labels = data(1:500,2);
labels_2 = data(501:end,2);
column_names = column_names(3:end);

%% Dualize
labels(labels==2) = 1;
labels(labels==3) = 2;
labels(labels==4) = 2;

%% Missing Values and Normalize
[ MVtraindata , labels , rownum ] = missingvalues( train_set , labels , 'mean' );
[ MVtestdata , labels_2 , rownum_2 ] = missingvalues( test_set , labels_2 , 'mean' );

[MVtraindata, av , sigma] = scalestd(MVtraindata);
[MVtestdata] = scalestd(MVtestdata,av,sigma);

%% Feature Selection
option = 2;

switch option
    case 1
        %---AUC
        threshold = 0.5;
        [ FSdata , FScolumn ] = FS_AUC( MVtraindata , labels , column_names , threshold );
        
    case 2
        %---Kruskal-Wallis
        threshold = 2;
        [ FStraindata , FScolumn ] = FS_kruskal( MVtraindata , labels , column_names , threshold );
        FStestdata  = FS_kruskal( MVtestdata , labels_2 , column_names , threshold );
        
    case 3
        %---mRMR
        threshold = 8;
        [ FSdata , FScolumn ] = FS_mRMR( MVtraindata , labels , column_names, threshold );
        
end

%% k-NN Classifier
K = 10;
modeldata.X = FStraindata';
modeldata.y = labels';
modeldata.K = 10;
modeldata.dim = 2;
%modeldata.numdata = 500;

model=knnrule(modeldata,K);

modeltestdata.X = FStestdata';
% modeltestdata.y = labels_2';
% modeltestdata.K = K;
% modeltestdata.dim = 8;
% modeltestdata.numdata = 338;

y = knnclass(modeltestdata.X,model);

