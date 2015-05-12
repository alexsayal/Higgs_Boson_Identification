
clear,clc;

%% Ex 1
s = struct('Mean',1,'Cov',3);

x =-6:0.5:6;
y = pdfgauss(x,s);
figure; hold on;
    plot(x,y);
    [Y,X] = hist(gsamp(s,500),10);
    bar(X,Y/500);

%% Ex 2
s = struct('Mean',[1;1],'Cov',[1 0.5; 0.5 1]);

figure();
pgauss(s)

%% Ex 3
data = load('riply_trn');

model = mlcgmm( data );
figure; hold on; ppatterns(data); pgauss( model );
figure; hold on; ppatterns(data); pgmm( model );

%% Ex 4
trn = load('riply_trn');
tst = load('riply_trn');

gauss_model = mlcgmm(trn);
quad_model = bayesdf(gauss_model);

ypred = quadclass(tst.X,quad_model);
cerror(ypred,tst.y)

figure; ppatterns(trn); pboundary(quad_model); 

%% Ex 5
trn = load('riply_trn');
tst = load('riply_tst');
inx1 = find(trn.y==1);
inx2 = find(trn.y==2);

model.Pclass{1} = mlcgmm(trn.X(:,inx1));
model.Pclass{2} = mlcgmm(trn.X(:,inx2));
model.Prior = [length(inx1) length(inx2)]/(length(inx1)+length(inx2));

ypred = bayescls(tst.X,model);
cerror(ypred,tst.y)

%% 
