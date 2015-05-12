%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 4-5 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Import
clear, clc;
load('epilepsy_powers.mat');

%% Data Struc
data.X = scalestd(caract)';
data.y = class';
data.dim = size(data.X,2);
data.num_data = size(data.X,1);

data.y(data.y==1) = 2;
data.y(data.y==0) = 1;

%% PCA
model = pca(data.X, 3);
out_data = linproj(data,model);
figure; ppatterns(out_data);

%%
PC_kaiser = length(model.eigval(model.eigval>1))
PC_scree = length(model.eigval(model.eigval>0.01))

infopercent5 = sum(model.eigval(1:5)) / sum(model.eigval(:)) * 100
infopercent6 = sum(model.eigval(1:6)) / sum(model.eigval(:)) * 100
