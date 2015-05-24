function [ best_performance , best_model , best_K , best_dist ] = CL_kNN(  train , trainlabels , test , testlabels , K , kfold )
%CL_kNN Summary of this function goes here
%   Detailed explanation goes here
parpool('local',4);
tic

type = {'cityblock','euclidean','hamming','jaccard'};

disp('------ k-NN Classifier ------');

%=====Cross validation and Training=====
cv = cvpartition(length(train),'kfold',kfold);

[k,dista] = meshgrid(K, 1:length(type));

meanperf = zeros(numel(k),1);

parfor j=1:numel(k)
    if mod(j,10)==0 || j==1, fprintf('>Run %d out of %d \n',j,numel(k)); end
    [ auxmeanperf ] = CL_kNN_main( cv, k ,dista, j, train, trainlabels, type, kfold);
    meanperf(j) = mean(auxmeanperf);

end

%--- Pair (K,distance) with best accuracy
[best_performance,idx] = max(meanperf);

best_K = k(idx);
best_dist = type{dista(idx)};
best_model=fitcknn(train,trainlabels,'NumNeighbors',best_K,'Distance',type{dista(idx)});

fprintf('Cross Validation Maximum Accuracy = %f%% \n',best_performance);
fprintf('Best K = %f \n',best_K);
fprintf('Best distance metric is %s \n',best_dist);

%--- Plot
imagesc(K, 1:length(type), reshape(meanperf,size(k))), colorbar, grid on;
ylim([0.5 length(type)+0.5]); xlim([K(1)-0.5 K(end)+0.5]);
set(gca, 'YTick', 1:length(type), 'YTickLabel', type);
hold on
plot(k(idx), dista(idx), 'rx')
text(k(idx), dista(idx), sprintf('Acc = %.2f %%',meanperf(idx)), ...
    'HorizontalAlign','left', 'VerticalAlign','top')
hold off
xlabel('K'), ylabel('Distance metric'), title('Cross-Validation Accuracy')

%=====Testing=====

ftest.X = test;
ftest.y = testlabels;
ftest.dim = size(ftest.X,2);
ftest.num_data = size(ftest.X,1);

%---Test
ypred = predict(best_model,ftest.X);
[~,cm,~,~] = confusion(ypred'-ones(1,ftest.num_data),ftest.y'-ones(1,ftest.num_data));
best_performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;

fprintf('Test Accuracy = %f%% \n',best_performance);
toc
delete(gcp)
disp('----------------------------');

end

