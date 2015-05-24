function [ best_performance , best_model ] = CL_fld(  train , trainlabels , test , testlabels , type , kfold)
%CL_FLD Summary of this function goes here
%   Detailed explanation goes here

disp('------ FLD Classifier ------');

%=====Cross validation and Training=====
cv = cvpartition(length(train),'kfold',kfold);

best_performance = 0;
for i=1:kfold
    %---Training set
    trn.X = train(cv.training(i),:)';
    trn.y = trainlabels(cv.training(i));
    trn.dim = size(trn.X,1);
    trn.num_data = size(trn.X,2);
    %---Test set
    tst.X = train(cv.test(i),:)';
    tst.y = trainlabels(cv.test(i));
    tst.dim = size(tst.X,1);
    tst.num_data = size(tst.X,2);
    
    %--- Classifier
    switch type
        case 'linear'
            fld_model = fld(trn);
            
        case 'quad'
            fld_model = fldqp(trn);
    end
    
    %--- Test
    ypred = linclass(tst.X,fld_model);
    
    [~,cm,~,~] = confusion(ypred-ones(1,tst.num_data),tst.y'-ones(1,tst.num_data));
    performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
    
    if performance>best_performance
        best_performance = performance;
        best_model = fld_model;
    end
end
fprintf('Cross Validation maximum Accuracy = %f%% \n',best_performance);

%=====Testing=====

ftest.X = test';
ftest.y = testlabels;
ftest.dim = size(ftest.X,1);
ftest.num_data = size(ftest.X,2);

ypred = linclass(ftest.X,best_model);
    
[~,cm,~,~] = confusion(ypred-ones(1,ftest.num_data),ftest.y'-ones(1,ftest.num_data));
best_performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;

fprintf('Test Accuracy = %f%% \n',best_performance);
disp('----------------------------');

end

