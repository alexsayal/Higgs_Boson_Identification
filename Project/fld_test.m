trn.X = FRdata(:,1:10000);
trn.y = Ytrain(1:10000)';
trn.dim = 2;
trn.num_data = 10000;

tst.X = FRtestdata(:,1:10000);
tst.y = Ytest(1:10000)';
tst.dim = 2;
tst.num_data = 10000;


model = fld(trn);
%model = fldqp(trn);
ypred = linclass(tst.X,model);
figure; ppatterns(trn); pline(model);
cerror(ypred,tst.y)