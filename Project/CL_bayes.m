function [ performance , model ] = CL_bayes( train , trainlabels , test , testlabels , type )
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
        
        model = bayesdf(gauss_model);
        
        %-- Test
        ypred = quadclass(tst.X,model);
        %performance = (1-cerror(ypred,tst.y))*100;
        
        %if trn.dim==2, figure; ppatterns(trn); pboundary(quad_model); end;
        [~,cm,~,~] = confusion(ypred-ones(1,tst.num_data),tst.y-ones(1,tst.num_data));
        performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
        
    case 'cls'
        %-- Bayes Classifier
        inx1 = find(trn.y==1);
        inx2 = find(trn.y==2);
        
        model.Pclass{1} = mlcgmm(trn.X(:,inx1));
        model.Pclass{2} = mlcgmm(trn.X(:,inx2));
        model.Prior = [length(inx1) length(inx2)]/(length(inx1)+length(inx2));
        
        %-- Test
        ypred = bayescls(tst.X,model);
        
        [~,cm,~,~] = confusion(ypred-ones(1,tst.num_data),tst.y-ones(1,tst.num_data));
        performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;
end

end
