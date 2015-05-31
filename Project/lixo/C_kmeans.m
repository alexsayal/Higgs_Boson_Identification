function [ best_performance , best_model , print] = C_kmeans( train , trainlabels , test , testlabels, kfold )
%K-MEANS k-Means Clustering
%Usage:
%   [best_performance,best_model,print] = C_kmeans(train,trainlabels,kfold)
%Input:
%   train (events x features)
%   trainlabels (events x 1)
%   kfold (number of folds for cross-validation)
%Output:
%   best_performance (higher accuracy value)
%   best_model (kmeans model that resulted in best_performance)
%   print (string for interface text feedback)


disp('------ k-Means Clustering ------');

%=====Cross validation and Training=====
cv = cvpartition(length(train),'kfold',kfold);

best_performance = 0;
for i=1:kfold
    fprintf('Run %d/%d \n',i,kfold);
    %---Training set
    trn.X = train(cv.training(i),:)';
    trn.y = trainlabels(cv.training(i));
    trn.dim = size(trn.X,1);
    trn.num_data = size(trn.X,2);
    
    [model,ypred] = cmeans( trn.X, 2);
    
    [~,cm,~,~] = confusion(ypred-ones(1,trn.num_data),trn.y'-ones(1,trn.num_data));
    performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
    
    if performance>best_performance
        best_performance = performance;
        best_model = model;
    end
end
fprintf('Cross Validation maximum Accuracy = %f%% \n',best_performance);

disp('------------------------------');

print = sprintf('------ k-Means Clustering ------\nCross Validation maximum Accuracy = %f%%\n------------------------------',best_performance);
end
