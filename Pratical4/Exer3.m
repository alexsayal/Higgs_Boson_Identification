%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 4-5 ================ %%%%%
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

%% PCA
model = pca(data.X, 3);
out_data = linproj(data,model);
figure; ppatterns(out_data);

%%
PC_kaiser = length(model.eigval(model.eigval>1))
PC_scree = length(model.eigval(model.eigval>0.01))

infopercent2 = sum(model.eigval(1:2)) / sum(model.eigval(:)) * 100
infopercent3 = sum(model.eigval(1:3)) / sum(model.eigval(:)) * 100
