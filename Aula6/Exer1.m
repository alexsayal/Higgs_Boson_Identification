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

[card_raw, card_names]=xlsread('CTG.xls','Data');

card=card_raw(:,3:25)';
card_names=card_names(1,6:28)';
y=card_raw(:,36)';
clear raw_data
dim=size(card,1);


%% 
rank = zeros(10,dim);
chi2 = zeros(1,dim);
for i=1:dim
    [p,tbl,stats] = kruskalwallis(card(i,:),y,'off');
    
    rank(:,i) = stats.meanranks;
    chi2(i) = tbl{2,5};
end

%%
[chi2_sort, ind]=sort(chi2,'descend');
card_names_sort=card_names(ind);
chi2_sort=chi2_sort(2:end);
card_names_sort=card_names_sort(2:end);

plot(chi2_sort,'--o')
