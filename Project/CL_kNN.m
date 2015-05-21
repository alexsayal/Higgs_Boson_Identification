function [ performance , model ] = CL_kNN(  train , trainlabels , test , testlabels , K )
%CL_kNN Summary of this function goes here
%   Detailed explanation goes here

%--- Structures
trn.X = train(:,1:8000);
trn.y = trainlabels(1:8000)';
trn.dim = size(trn.X,1);
trn.num_data = size(trn.X,2);

tst.X = test(:,1:8000);
tst.y = testlabels(1:8000)';
tst.dim = size(tst.X,1);
tst.num_data = size(tst.X,2);

model=knnrule(trn,K);
if trn.dim==2, figure; ppatterns(trn); pboundary(model); end;

ypred = knnclass(tst.X,model);

%performance = (1-cerror(ypred,tst.y))*100;

[~,cm,~,~] = confusion(ypred-ones(1,tst.num_data),tst.y-ones(1,tst.num_data));
performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;

end

