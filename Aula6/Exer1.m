%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 6 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Import
[raw_data,col_names]=xlsread('CORK_STOPPERS.XLS','Data');

data=raw_data(:,3:end)';
y = raw_data(:,2)';
dim=size(data,1);
num_data=size(data,2);
clear raw_data;
%% 
[p,tbl,stats] = kruskalwallis(data);

%% 
rank = zeros(3,dim);
chi2 = zeros(1,dim);
for i=1:dim
    [p,tbl,stats] = kruskalwallis(data(i,:),y);
    
    rank(:,i) = stats.meanranks;
    chi2(i) = tbl{2,5};
end

%%
[chi2_sort,ord] = sort(chi2,'descend');

colnames_ord = col_names(1,3:end);
colnames_ord = colnames_ord(ord);
table(:,1) = cellstr(colnames_ord);
table(:,2) = num2cell(chi2_sort);

disp('Features Rank:');
disp(table);

%% Correlation Matrix

R = corr(data(1:5,:)');

%% Skewness and Kurtosis
disp(strcat('Skewness for PRT = ',num2str(skewness(data(3,:))))); 
disp(strcat('Kurtosis for PRT = ',num2str(kurtosis(data(3,:))-3))); 

%% Cardiocenas


