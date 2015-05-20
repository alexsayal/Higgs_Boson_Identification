% data.X = FRdata(:,1:2000);
% data.y = MVlabels(1:2000)';
% data.dim = 2;
% data.num_data = 2000;

data.X = FSdata';
data.y = MVlabels;
data.dim = 17;
data.num_data = 24428;


K=25;
model=knnrule(data,K);
figure; ppatterns(data); pboundary(model);

% tst.X = FRtestdata(:,1:2000);
% tst.y = MVtestlabels(1:2000)';
% tst.dim = 2;
% tst.num_data = 2000;

tst.X = FStestdata(:,1:17)';
tst.y = MVtestlabels;
tst.dim = 17;
tst.num_data = 24428;

y_new = knnclass(tst.X,model);

cerror(y_new,tst.y)

