function [ best_performance2 , best_model , best_C, print ] = CL_linSVM( train , trainlabels , test , testlabels , C , folds)
%CL_linSVM SVM Classifier with LIBLINEAR
%Usage:
%   [best_performance,best_model,best_C,print] = CL_linSVM(train,trainlabels,test,testlabels,C,folds)
%Input:
%   train (events x features)
%   trainlabels (events x 1)
%   test (events x features)
%   testlabels (events x 1)
%   C (wanted log_2(C) values x 1)
%   folds (number of folds for cross-validation)
%Output:
%   best_performance (higher test accuracy value)
%   best_model (SVM model that resulted in best_performance)
%   best_C (C value of best_model)
%   print (string for interface text feedback)

disp('------ SVM Classifier ------');

labels = trainlabels;
data = sparse(train);

%=====Cross validation and training=====
cv_acc = zeros(length(C),1);
for i=1:length(C)
    fprintf('C %d/%d: ',i,length(C));
    cv_acc(i) = liblineartrain(labels, data, sprintf('-c %f -s %d -B %d -v %d -q', 2^C(i), 2, 1,  folds));
end

%---C with best accuracy
[best_performance,idx] = max(cv_acc);
best_C = 2^C(idx);

%---Plot C---
figure();
    plot(C,cv_acc,'--o',C(idx),best_performance,'rx');
    grid on;
    xlabel('log_2(C)'); ylabel('Cross-Validation Accuracy');
    xlim([min(C) max(C)]);
    title('Cross-Validation Accuracy');
    text(C(idx)+0.5, best_performance, sprintf('Acc = %.2f %%',best_performance), ...
        'HorizontalAlign','left', 'VerticalAlign','top')

fprintf('Cross Validation maximum Accuracy = %f%% \n',best_performance);
fprintf('Best C = %f \n',best_C);

%=====Test=====
best_model = liblineartrain(labels, data, ...
                    sprintf('-c %f -s %d -B %d -q', best_C , 2 , 1));


[~,best_performance2,~] = liblinearpredict(testlabels, sparse(test), best_model, '-q');

fprintf('Test Accuracy = %f%% \n',best_performance2(1));
disp('------------------------------');

print = sprintf('------ SVM Classifier ------ \nCross Validation maximum Accuracy = %f%% \nTest Accuracy = %f%% \n------------------------------',best_performance,best_performance2(1));
end