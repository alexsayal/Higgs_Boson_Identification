%% datasets
trn.X = FRdata;
trn.y = labels';
trn.dim = 2;
trn.num_data = 150000;

tst.X = FRtestdata;
tst.y = testlabels';
tst.dim = 2;
tst.num_data = 150000;

%% 1
model = mlcgmm( trn );
figure; hold on; ppatterns(trn); pgauss( model );
figure; hold on; ppatterns(trn); pgmm( model );

%% 2
gauss_model = mlcgmm(trn);
quad_model = bayesdf(gauss_model);

ypred = quadclass(tst.X,quad_model);
cerror(ypred,tst.y)

figure; ppatterns(trn); pboundary(quad_model); 

%% Ex 5
inx1 = find(trn.y==1);
inx2 = find(trn.y==2);

model.Pclass{1} = mlcgmm(trn.X(:,inx1));
model.Pclass{2} = mlcgmm(trn.X(:,inx2));
model.Prior = [length(inx1) length(inx2)]/(length(inx1)+length(inx2));

ypred = bayescls(tst.X,model);

cerror(ypred,tst.y)



