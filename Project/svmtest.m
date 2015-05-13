trn = load('riply_trn');
model = smo(trn,struct('ker','rbf','C',10,'arg',1));
figure; ppatterns(trn); psvm(model);
tst = load('riply_tst');
ypred = svmclass( tst.X, model );
cerror( ypred, tst.y )

%%
trn.X = FRdata(:,1:1000);
trn.y = labels(1:1000)';
trn.dim = 2;
trn.num_data = 1000;

model = smo(trn,struct('ker','linear','C',10,'arg',5));
figure; ppatterns(trn); psvm(model);

tst.X = FRtestdata(:,1:1000);
tst.y = testlabels(1:1000)';
tst.dim = 2;
tst.num_data = 1000;

ypred = svmclass( tst.X, model );
cerror( ypred, tst.y )

%%
X = FRdata(:,1:1000)';
y = labels(1:1000);
Xtest = FRtestdata(:,1:1000)';
Ytest = testlabels(1:1000);

SVMModel = fitcsvm(X,y);

sv = SVMModel.SupportVectors;
figure
gscatter(X(:,1),X(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('versicolor','virginica','Support Vector')
hold off


[label,Score] = predict(SVMModel,Xtest);

table(Ytest(1:10),label(1:10),Score(1:10,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Score'})
