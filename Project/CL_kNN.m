function [ performance , model ] = CL_kNN(  train , trainlabels , test , testlabels , K )
%CL_kNN Summary of this function goes here
%   Detailed explanation goes here

%--- Structures
trn.X = train(:,1:20000);
trn.y = trainlabels(1:20000)';
trn.dim = size(train,1);
trn.num_data = size(train,2);

tst.X = test(:,1:20000);
tst.y = testlabels(1:20000)';
tst.dim = size(test,1);
tst.num_data = size(test,2);

model=knnrule(trn,K);
if trn.dim==2, figure; ppatterns(data); pboundary(model); end;

y_pred = knnclass(tst.X,model);

performance = (1-cerror(y_pred,tst.y))*100;

end

