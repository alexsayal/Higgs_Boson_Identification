%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 4 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load
clear, clc;
[xls_data,col_names]=xlsread('CORK_STOPPERS.XLS','Data');

%% Preprocessing and prep for STPR
data_raw = xls_data(:,3:end);

data.X = scalestd(data_raw)';
data.y=xls_data(:,2)';

%% Simpler problem
subset1 = data.X([1,3],1:50);

coeff1 = pca(subset1); %PCA

I = coeff1.W * coeff1.W' %Prove it is orthogonal

c = coeff1.eigval(1)*100/sum(coeff1.eigval) %Contribution of the 1st PC

% Graph 1
figure(1);
scatter(subset1(1,:),subset1(2,:)); title('Sem PCA'); xlabel('ART'); ylabel('PRT');

% Graph 2
subset2 = subset1'*coeff1.W;
figure(2);
scatter(subset2(:,2),subset2(:,2)); title('Com PCA'); xlabel('PC 1'); ylabel('PC 2');

%% For the complete dataset

coeff2 = pca(data.X); %PCA
s = coeff2.eigval

subset3.X = coeff2.W*data.X(:,1:100);
subset3.y = xls_data(1:100,2)';
subset3.dim = size(data.X(:,1:100),1);
subset3.num_data=size(data.X(:,1:100),2);

figure(3);
ppatterns(subset3); title('Com PCA'); xlabel('PC 1'); ylabel('PC 2');

figure(4);
plot(s,'--o'); title('Valores próprios');

PC_kaiser = length(s(s>1))
PC_scree = length(s(s>0.01))