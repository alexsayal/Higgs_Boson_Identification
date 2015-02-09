%%% TECNICAS RECONHECIMENTO PADROES %%%
%%% AULA 1 %%%

%% Load
[xls_data,col_names]=xlsread('CORK_STOPPERS.XLS','Data');

%% Sets
data.X=xls_data(:,3:end)'; %Transpose for STPRTools % Data itself
data.y=xls_data(:,2)'; %Class
data.dim=size(data.X,1); %Data features = 12
data.num_data=size(data.X,2); data.name='Cork Stoppers dataset'; %Data dimension = 150

%% Scatter Plot
figure();
ppatterns(data); %Up to 3 dimensions (obviously)
xlabel(col_names(1))
ylabel(col_names(2))
zlabel(col_names(3))

%% Plot 2
data2.X=xls_data(:,[6,10])';
data2.y=xls_data(:,2)';
data2.dim=size(data2.X,1); %Data features = 2
data2.num_data=size(data2.X,2); data.name='Cork Stoppers dataset 2';

figure();
ppatterns(data2);
