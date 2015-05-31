% %--- Structures
% trn.X = train(:,1:1000);
% trn.y = trainlabels(1:1000)';
% trn.dim = size(train,1);
% trn.num_data = size(train,2);
% 
% tst.X = test(:,1:1000);
% tst.y = testlabels(1:1000)';
% tst.dim = size(test,1);
% tst.num_data = size(test,2);

% options.ker = 'rbf';
% options.arg = [0.1 0.5 1 5];
% options.C = [1 10 100];
% options.solver = 'smo';
% options.num_folds = 1;
% options.verb = 1;
%
% [model,Errors] = evalsvm(trn,options);
%
% figure; mesh(options.arg,options.C,Errors);
% hold on; xlabel('arg'); ylabel('C');

% aux = -3:3;
% C = 2.^aux;
% aux = -3:3;
% gamma = 2.^aux;
% errors = [];
% 
% for c = C
%     c
%     for g = gamma
%         g
%         model = smo(trn,struct('ker','rbf','C',c,'arg',g));
%         
%         ypred = svmclass( tst.X, model );
%         errors = [errors; c g cerror( ypred, tst.y )];
%         clear model ypred;
%     end
% end
% 
% [~,bestind] = min(errors(:,4));
% model = smo(trn.X,struct('ker','rbf','C',errors(bestind,1),'arg',errors(bestind,2)));
% 
% ypred = svmclass(tst.X,model);
% 
% performance = (1-cerror(ypred,tst.y))*100;