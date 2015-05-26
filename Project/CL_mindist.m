function [ performance , m ] = CL_mindist(  train , trainlabels , test , testlabels )
%CL_DMINDIST Summary of this function goes here
%   Detailed explanation goes here

%--- Structures
trn.X = train';
trn.y = trainlabels;
trn.dim = size(train,1);

tst.X = test';
tst.y = testlabels;

trn.A = trn.X(trn.y==1,:); %Train class 1
trn.B = trn.X(trn.y==2,:); %Train class 2


% %---Histograms
% x=-5:0.1:5;
% [mu1,sigma1] = normfit(trn.A(:,1));
% f1 = gaussmf( x , [sigma1 mu1]);
% 
% [mu2,sigma2] = normfit(trn.B(:,1));
% f2 = gaussmf( x , [sigma2 mu2]);
% 
% for i=1:trn.dim
%     figure();
%     histogram(trn.A(:,i),200,'Normalization','pdf'); xlim([-10 10]);
%     hold on;
%     plot(x,f1);
%     hold on;
%     histogram(trn.B(:,i),200,'Normalization','pdf'); xlim([-10 10]);
%     hold on;
%     plot(x,f2);
%     title(strcat('Histogram feature',{' '},num2str(i)));
%     ylabel('Frequency');
%     legend('Class 1','Class 1','Class 2','Class 2');
% end

%----Prototypes
m1 = mean(trn.A);
m2 = mean(trn.B);

g1 = m1*
g2 = 



% %----Separation
% x = -5:0.1:5;
% y = ((m2(1)-m1(1))/(m1(2)-m2(2)))*x - 0.5*(m2(1)^2 + m2(2)^2 - m1(1)^2 - m1(2)^2)/(m1(2)-m2(2));
% 
% figure();
%     plot(trn.A(:,1),trn.A(:,2),'o'); ylim([min(trn.A(:,2)) max(trn.A(:,2))]); xlim([min(trn.A(:,1)) max(trn.A(:,1))]);
%     hold on;
%     plot(trn.B(:,1),trn.B(:,2),'+'); ylim([min(trn.A(:,2)) max(trn.A(:,2))]); xlim([min(trn.A(:,1)) max(trn.A(:,1))]);
%     hold on
%     plot(x,y,'LineWidth',2); ylim([min(trn.A(:,2)) max(trn.A(:,2))]); xlim([min(trn.A(:,1)) max(trn.A(:,1))]);
%     hold on
%     plot(m1(1),m1(2),'o','MarkerSize',10); ylim([min(trn.A(:,2)) max(trn.A(:,2))]); xlim([min(trn.A(:,1)) max(trn.A(:,1))]);
%     hold on
%     plot(m2(1),m2(2),'o','MarkerSize',10); ylim([min(trn.A(:,2)) max(trn.A(:,2))]); xlim([min(trn.A(:,1)) max(trn.A(:,1))]);
%     legend('Class 1','Class 2','Hyperplane','Prototype 1','Prototype 2');
%     
% --- Classifier - Test ---
% C=zeros(length(tst.y),1);
% for i=1:length(tst.y)
%     if pdist([m1;tst.X(i,:)],'euclidean')<pdist([m2;tst.X(i,:)],'euclidean')
%         C(i)=1;
%     else
%         C(i)=2;
%     end
% end
% 
% performance = (1-cerror(C,tst.y))*100;
% m=1;

end
