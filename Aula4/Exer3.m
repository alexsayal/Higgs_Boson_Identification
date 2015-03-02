%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 4 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load
[xls_data,col_names]=xlsread('BREAST_TISSUE.XLS','Data');

%% Structure
data.X = xls_data(1:106,:);
data.y = col_names(2:107,1);
data.dim = size(data.X,2);
data.num_data = size(data.X,1);

data.y(data.y~='car' || data.y~='fad' || data.y~='mas') = 1;

