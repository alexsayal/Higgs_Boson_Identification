%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 6 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

[xls_data,col_names]=xlsread('BREAST_TISSUE.XLS','Data');

%% Structure

data.X = xls_data(1:106,:)';
data.y = col_names(2:107,1)';
data.dim = size(data.X,2);
data.num_data = size(data.X,1);

data.y=strcmp('gla',col_names(2:107,1)) + strcmp('adi',col_names(2:107,1)) + strcmp('con',col_names(2:107,1));
data.y(data.y==0) = 2;

data.X = scalestd(data.X);

%% hist e hist_fit

figure()
hist(data.X);
histfit(data.X);

