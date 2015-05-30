function [ auxmeanperf ] = CL_kNN_main( cv, k ,dista, j, train, trainlabels, type, kfold)
%CL_kNN_MAIN Core function of k-NN Classifier

auxmeanperf = zeros(kfold,1);
for i=1:kfold
    %---Training set
    trnX = train(cv.training(i),:);
    trny = trainlabels(cv.training(i));
    %---Test set
    tstX = train(cv.test(i),:);
    tsty = trainlabels(cv.test(i));
    tstnum_data = size(tstX,1);
    
    %---Classifier
    model=fitcknn(trnX,trny,'NumNeighbors',k(j),'Distance',type{dista(j)});
    
    %---Test
    ypred = predict(model,tstX);
    [~,cm,~,~] = confusion(ypred'-ones(1,tstnum_data),tsty'-ones(1,tstnum_data));
    auxmeanperf(i) = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
end

end

