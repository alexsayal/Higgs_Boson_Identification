function [ best_performance , m1 , m2 ] = CL_mindist(  train , trainlabels , test , testlabels )
%CL_DMINDIST Summary of this function goes here
%   Detailed explanation goes here

disp('------ Minimum Distance Classifier ------');

%--- Structures
trn.X = train;
trn.y = trainlabels;

tst.X = test;
tst.y = testlabels;
tst.num_data = size(test,1);

trn.A = trn.X(trn.y==1,:); %Train class 1
trn.B = trn.X(trn.y==2,:); %Train class 2

%----Prototypes / Training
m1 = mean(trn.A);
m2 = mean(trn.B);

%---Testing
g1 = m1*tst.X' - 0.5*norm(m1)^2;
g2 = m2*tst.X' - 0.5*norm(m2)^2;

c = zeros(1,tst.num_data);

parfor i=1:tst.num_data
    if g1(i)>=g2(i)
        c(i) = 1;
    else
        c(i) = 2;
    end
end

[~,cm,~,~] = confusion(c-ones(1,tst.num_data),tst.y'-ones(1,tst.num_data));
best_performance = 100*( cm(2,2)/(cm(2,2)+cm(1,2)) + cm(1,1)/(cm(1,1)+cm(2,1)) )/2;

fprintf('Test Accuracy = %f%% \n',best_performance);
disp('----------------------------');

end
