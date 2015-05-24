function [ best_performance , best_model , best_C ] = CL_SVM( train , trainlabels , test , testlabels , C , folds)
%CL_SVM Summary of this function goes here
%   Detailed explanation goes here

disp('------ SVM Classifier ------');

labels = trainlabels;
data = sparse(train);

%=====Cross validation and training=====
cv_acc = zeros(length(C),1);
for i=1:length(C)
    fprintf('C %d: ',i);
    cv_acc(i) = liblineartrain(labels, data, sprintf('-c %f -s %d -B %d -v %d -q', 2^C(i), 2, 1,  folds));
end

%---C with best accuracy
[best_performance,idx] = max(cv_acc);
best_C = 2^C(idx);

fprintf('Cross Validation maximum Accuracy = %f%% \n',best_performance);
fprintf('Best C = %f \n',best_C);

%=====Test=====
best_model = liblineartrain(labels, data, ...
                    sprintf('-c %f -s %d -B %d -q', best_C , 2 , 1));


[~,best_performance,~] = liblinearpredict(testlabels, sparse(test), best_model, '-q');

fprintf('Test Accuracy = %f%% \n',best_performance(1));
disp('------------------------------');

end
