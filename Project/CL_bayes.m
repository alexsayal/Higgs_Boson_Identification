function [ best_performance , best_model ] = CL_bayes( train , trainlabels , test , testlabels , type , kfold )
%CL_BAYES Summary of this function goes here
%   Detailed explanation goes here

disp('------ Bayes Classifier ------');

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
    
    switch type
        case 'df'
            %-- Bayes Classifier
            gauss_model = mlcgmm(trn);
            
            model = bayesdf(gauss_model);
            
            %-- Test
            ypred = quadclass(tst.X,model);
            
            [~,cm,~,~] = confusion(ypred-ones(1,tst.num_data),tst.y'-ones(1,tst.num_data));
            performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
            
        case 'cls'
            %-- Bayes Classifier
            inx1 = find(trn.y==1);
            inx2 = find(trn.y==2);
            
            model.Pclass{1} = mlcgmm(trn.X(:,inx1));
            model.Pclass{2} = mlcgmm(trn.X(:,inx2));
            model.Prior = [length(inx1) length(inx2)]/(length(inx1)+length(inx2));
            
            %-- Test
            ypred = bayescls(tst.X,model);
            
            [~,cm,~,~] = confusion(ypred-ones(1,tst.num_data),tst.y'-ones(1,tst.num_data));
            performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
    end
    
    if performance>best_performance
        best_performance = performance;
        best_model = model;
    end
    
end
fprintf('Cross Validation maximum Accuracy = %f%% \n',best_performance);

%=====Testing=====

ftest.X = test';
ftest.y = testlabels;
ftest.dim = size(ftest.X,1);
ftest.num_data = size(ftest.X,2);

switch type
    case 'df'
        model = best_model;
        
        %-- Test
        ypred = quadclass(ftest.X,model);
        
        [~,cm,~,~] = confusion(ypred-ones(1,ftest.num_data),ftest.y'-ones(1,ftest.num_data));
        best_performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
        
    case 'cls'
        model = best_model;
        
        %-- Test
        ypred = bayescls(ftest.X,model);
        
        [~,cm,~,~] = confusion(ypred-ones(1,ftest.num_data),ftest.y'-ones(1,ftest.num_data));
        best_performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
end

fprintf('Test Accuracy = %f%% \n',best_performance);
disp('------------------------------');

end