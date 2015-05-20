function [ performance , quad_model ] = CL_bayes( train , trainlabels , test , testlabels , type )
%CL_BAYES Summary of this function goes here
%   Detailed explanation goes here

%--- Structures
trn.X = train;
trn.y = trainlabels';
trn.dim = size(train,1);
trn.num_data = size(train,2);

tst.X = test;
tst.y = testlabels';
tst.dim = size(test,1);
tst.num_data = size(test,2);

switch type
    case 'df'
        %-- Bayes Classifier
        gauss_model = mlcgmm(trn);
        
        quad_model = bayesdf(gauss_model);
        
        %-- Test
        ypred = quadclass(tst.X,quad_model);
        performance = (1-cerror(ypred,tst.y))*100;
        
        if trn.dim==2, figure; ppatterns(trn); pboundary(quad_model); end;
        
    case 'cls'
        %-- Bayes Classifier
        inx1 = find(trn.y==1);
        inx2 = find(trn.y==2);
        
        model.Pclass{1} = mlcgmm(trn.X(:,inx1));
        model.Pclass{2} = mlcgmm(trn.X(:,inx2));
        model.Prior = [length(inx1) length(inx2)]/(length(inx1)+length(inx2));
        
        %-- Test
        ypred = bayescls(tst.X,model);
        
        performance = (1-cerror(ypred,tst.y))*100;
end

end
