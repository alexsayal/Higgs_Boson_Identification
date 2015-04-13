%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 8 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%


%% Load
[data,col_names]=xlsread('CORK_STOPPERS.XLS','Data');

datan = data(1:100,6:7);

%% 1
x=1:0.1:5;
[mu1,sigma1] = normfit(datan(1:50,1));
f1 = gaussmf( x , [sigma1 mu1]);
[mu2,sigma2] = normfit(datan(51:end,1));
f2 = gaussmf( x , [sigma2 mu2]);
histogram(datan(1:50,1),15,'Normalization','pdf'); xlim([1 5]);
hold on;
plot(x,f1);
hold on;
histogram(datan(51:end,1),15,'Normalization','pdf'); xlim([1 5]);
hold on;
plot(x,f2);
title('Histograms');
ylabel('Frequency');
legend('Class ARM','Class ARM','ClassPRM','ClassPRM');

%% 2
%----a)
m1 = mean(datan(1:50,:));
m2 = mean(datan(51:end,:));

w10 = -0.5*norm(m1)^2;
w20 = -0.5*norm(m2)^2;

g1 = m1*datan(1:50,:)' + w10;
g2 = m2*datan(51:end,:)' + w20;

%%
% $y = x(m1-m2) - 0.5[(m21+m22)^2 - (m11+m12)^2]$

%----b)
x = 1:0.1:6;
y = ((m2(1)-m1(1))/(m1(2)-m2(2)))*x - 0.5*(m2(1)^2 + m2(2)^2 - m1(1)^2 - m1(2)^2)/(m1(2)-m2(2));

plot(datan(1:50,1),datan(1:50,2),'o',datan(51:end,1),datan(51:end,2),'+');
hold on
plot(1:0.1:6,y,'LineWidth',4);
hold on
plot(m1(1),m1(2),'+','MarkerSize',10);
hold on
plot(m2(1),m2(2),'o','MarkerSize',10);
hold on
plot([m1(1) m2(1)],[m1(2) m2(2)],'k--','LineWidth',4);
legend('Class 1','Class 2','Hyperplane','Prototype 1','Prototype 2','Line means')
