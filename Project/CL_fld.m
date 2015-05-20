function [ performance , fld_model ] = CL_fld(  train , trainlabels , test , testlabels , type )
%CL_FLD Summary of this function goes here
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

%--- Classifier
switch type
    case 'linear'
        fld_model = fld(trn);
        
    case 'quad'
        fld_model = fldqp(trn);
        
end

%--- Test
ypred = linclass(tst.X,fld_model);

if trn.dim==2, figure; ppatterns(trn); pline(fld_model); end
performance = (1-cerror(ypred,tst.y))*100;

end

