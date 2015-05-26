%# read some training data
labels = Ytrain;
data = sparse(Xtrain);

%# grid of parameters
folds = 10;
C = -15:2:15;

tic
%# grid search, and cross-validation
cv_acc = zeros(length(C),1);
for i=1:numel(C)
    cv_acc(i) = liblineartrain(labels, data, ...
                    sprintf('-c %f -s %d -B %d -v %d', 2^C(i), 2, 1,  folds));
end
toc

%# pair (C,gamma) with best accuracy
[~,idx] = max(cv_acc);

% %# contour plot of paramter selection
% contour(C, gamma, reshape(cv_acc,size(C))), colorbar
% hold on
% plot(C(idx), gamma(idx), 'rx')
% text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
%     'HorizontalAlign','left', 'VerticalAlign','top')
% hold off
% xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')

%# now you can train you model using best_C and best_gamma
best_C = 2^C(idx);

%%
tic
best_model = liblineartrain(labels, data, ...
                    sprintf('-c %f -s %d -B %d', best_C , 2 , 1));


[predicted_label, accuracy, decision_values] = liblinearpredict(Ytest, ...
    sparse(Xtest), best_model, '');
toc