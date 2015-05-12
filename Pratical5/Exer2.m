%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 6 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load
clear, clc;
[xls_data,col_names]=xlsread('BREAST_TISSUE.XLS','Data');

%% Structure
data.X = xls_data(1:106,:)';
data.y = col_names(2:107,1)';
data.dim = size(data.X,2);
data.num_data = size(data.X,1);

data.y=strcmp('gla',col_names(2:107,1)) + strcmp('adi',col_names(2:107,1)) + strcmp('con',col_names(2:107,1));
data.y(data.y==0) = 2;

data.X = scalestd(data.X);

%% Histograms
figure();
for i=1:data.num_data
    subplot(3,3,i); histfit(data.X(i,:)); title(strcat('Histogram feature',{' '},num2str(i)));
end

%% KS Test
figure();
K = zeros(1,data.num_data);
for i=1:data.num_data
    x = (data.X(i,:)-mean(data.X(i,:)))/std(data.X(i,:));
    
    K(i) = kstest(x); %Zero se normal, Um se não normal
    
    [f,x_values] = ecdf(x);
    subplot(3,3,i);
    F = plot(x_values,f);
    title(strcat('Feature',{' '},num2str(i)));
    hold on;
    G = plot(x_values,normcdf(x_values,0,1),'r-');
    legend([F G],'Empirical CDF','Standard Normal CDF','Location','SE');
end