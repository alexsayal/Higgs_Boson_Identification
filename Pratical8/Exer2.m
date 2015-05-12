%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 9 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Ex 6
clear, clc;
[xls_data,col_names]=xlsread('CORK_STOPPERS.XLS','Data');

data.X=xls_data(1:100,3:end)'; %Transpose for STPRTools % Data itself
data.y=xls_data(1:100,2)'; %Class
data.dim=size(data.X,1); %Data features = 12
data.num_data=size(data.X,2);

%% Ex 7

