clear, clc;
%% Load
[xls_data,col_names]=xlsread('CORK_STOPPERS.XLS','Data');

%% Sets
X=xls_data(:,[4,5]); 
labels=xls_data(1:100,2); %Class

%% Normalize
X(2,:) = X(2,:)/10;

%% Point 1

errors = [];

for i = 1:10
    CVO(i) = cvpartition(labels,'holdout',.5);
    
    trIdx = CVO(i).training(1);
    teIdx = CVO(i).test(1);
    
    Train.X = X(trIdx,:)';
    Train.y = labels(trIdx);
    
    Test.X = X(teIdx,:)';
    Test.y = labels(teIdx);
   
    aux = -20:2;
    C = 2.^aux;
    for c = C
        model = smo(Train,struct('ker','linear','C',c));

        ypred = svmclass( Test.X, model );
        errors = [errors; i c cerror( ypred, Test.y )];
        clear model ypred;
    end
end

plot3(errors(:,1),errors(:,2),errors(:,3));
a = find(errors(:,3)==min(errors(:,3)));
a = errors(a(1),:);

%% Point 2
errors = [];

for i = 1:10
    CVO(i) = cvpartition(labels,'holdout',.5);
    
    trIdx = CVO(i).training(1);
    teIdx = CVO(i).test(1);
    
    Train.X = X(trIdx,:)';
    Train.y = labels(trIdx);
    
    Test.X = X(teIdx,:)';
    Test.y = labels(teIdx);
   
    aux = -5:12;
    C = 2.^aux;
    aux = -30:5;
    gamma = 2.^aux;
    
    for c = C
        for g = gamma
            model = smo(Train,struct('ker','rbf','C',c,'arg',g));

            ypred = svmclass( Test.X, model );
            errors = [errors; i c g cerror( ypred, Test.y )];
            clear model ypred;
        end
    end
end

E1 = errors(1:648,:);
E2 = errors(649:1296,:);
E3 = errors(1297:1944,:);
E4 = errors(1945:2592,:);
E5 = errors(2592:3240,:);
E6 = errors(3241:3888,:);
E7 = errors(3889:4536,:);
E8 = errors(4537:5184,:);
E9 = errors(5185:5832,:);
E10 = errors(5833:6480,:);

ET = zeros(648,3);

for i=1:648
    ET(i,1) = E1(i,2);
    ET(i,2) = E1(i,3);
    ET(i,3)=mean([E1(i,4),E2(i,4),E3(i,4),E4(i,4),E5(i,4),E6(i,4),E7(i,4),E8(i,4),E9(i,4),E10(i,4)]);
end




