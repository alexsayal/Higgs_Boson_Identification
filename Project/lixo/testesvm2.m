parpool('local',4);
%# read some training data
sizedata = 150000;
dimdata = 10;
labels = Ytrain(1:sizedata);
data = sparse(Xtrain(1:sizedata,1:dimdata));

%# grid of parameters
folds = 10;
[C,gamma] = meshgrid(-5:2:15, -15:2:3);

tic
%# grid search, and cross-validation
cv_acc = zeros(numel(C),1);
parfor i=1:numel(C)
    cv_acc(i) = libsvmtrain(labels, data, ...
                    sprintf('-c %f -g %f -v %d', 2^C(i), 2^gamma(i), folds));
end
toc
%# pair (C,gamma) with best accuracy
[~,idx] = max(cv_acc);

%# contour plot of paramter selection
contour(C, gamma, reshape(cv_acc,size(C))), colorbar
hold on
plot(C(idx), gamma(idx), 'rx')
text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
    'HorizontalAlign','left', 'VerticalAlign','top')
hold off
xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')

%# now you can train you model using best_C and best_gamma
best_C = 2^C(idx);
best_gamma = 2^gamma(idx);

%
tic
best_model = libsvmtrain(labels, data, ...
                    sprintf('-c %f -g %f', best_C, best_gamma));


[predicted_label, accuracy, decision_values] = libsvmpredict(Ytest(1:sizedata), ...
    sparse(Xtest(1:sizedata,1:dimdata)), best_model, '');
toc