
%% Import
glob_data = xlsread('CLUSTERS.xls','Glob');
filam_data = xlsread('CLUSTERS.xls','Filam');
maiscross_data = xlsread('CLUSTERS.xls','+Cross');
xiscross_data = xlsread('CLUSTERS.xls','xCross');

%% Scatter
figure();
labels = cellstr( num2str([1:length(glob_data)]') );

subplot(2,2,1); scatter(glob_data(:,1),glob_data(:,2),'filled'); title('Glob');
text(glob_data(:,1), glob_data(:,2), labels, 'horizontal','left', 'vertical','bottom');

subplot(2,2,2); scatter(filam_data(:,1),filam_data(:,2),'filled'); title('Filam');
text(filam_data(:,1), filam_data(:,2), labels, 'horizontal','left', 'vertical','bottom');

subplot(2,2,3); scatter(maiscross_data(:,1),maiscross_data(:,2),'filled'); title('+Cross');

subplot(2,2,4); scatter(xiscross_data(:,1),xiscross_data(:,2),'filled'); title('xCross');

%% Clustering
dist_g = pdist(glob_data,'euclidean');
dist_f = pdist(filam_data,'euclidean');

Z_g = linkage(dist_g,'complete');
Z_f = linkage(dist_f,'single');

figure();  
subplot(1,2,1); scatter(glob_data(:,1),glob_data(:,2),'filled'); title('Glob Scatter');
text(glob_data(:,1), glob_data(:,2), labels, 'horizontal','left', 'vertical','bottom');
subplot(1,2,2); dendrogram(Z_g); title('Glob Dendrogram');

figure(); 
subplot(1,2,1); scatter(filam_data(:,1),filam_data(:,2),'filled'); title('Filam Scatter');
text(filam_data(:,1), filam_data(:,2), labels, 'horizontal','left', 'vertical','bottom');
subplot(1,2,2); dendrogram(Z_f); title('Filam Dendrogram');

%% Plus Cross WPGMA
dist_mais1 = pdist(maiscross_data,'euclidean');
dist_mais2 = pdist(maiscross_data,'cityblock');
dist_mais3 = pdist(maiscross_data,'chebychev');

Z_mais1 = linkage(dist_mais1,'weighted');
Z_mais2 = linkage(dist_mais2,'weighted');
Z_mais3 = linkage(dist_mais3,'weighted');

figure();  
subplot(2,2,1); scatter(maiscross_data(:,1),maiscross_data(:,2),'filled'); title('+Cross Scatter');
subplot(2,2,2); dendrogram(Z_mais1); title('+Cross Dendrogram with euclidean');
subplot(2,2,3); dendrogram(Z_mais2); title('+Cross Dendrogram with cityblock');
subplot(2,2,4); dendrogram(Z_mais3); title('+Cross Dendrogram with chebychev');

%% X Cross WPGMA
dist_cross1 = pdist(xiscross_data,'cityblock');
dist_cross2 = pdist(xiscross_data,'chebychev');

Z_cross1 = linkage(dist_cross1,'weighted');
Z_cross2 = linkage(dist_cross2,'weighted');

figure(); 
subplot(1,3,1); scatter(xiscross_data(:,1),xiscross_data(:,2),'filled'); title('xCross Scatter');
subplot(1,3,2); dendrogram(Z_cross1); title('xCross Dendrogram wth CityBlock');
subplot(1,3,3); dendrogram(Z_cross2); title('xCross Dendrogram with Chebychev');

%% Globular WPGMA & UPGMA

Z_glob1 = linkage(dist_g,'average'); %UPGMA
Z_glob2 = linkage(dist_g,'weighted'); %WPGMA

figure();
subplot(1,2,1); dendrogram(Z_glob1); title('Globular Dendrogram with UPGMA');
subplot(1,2,2); dendrogram(Z_glob2); title('Globular Dendrogram with WPGMA');

%% Filam ward cityblock

dist_filam = squareform(pdist(filam_data,'cityblock'));

Z_filam = linkage(dist_filam,'ward');

figure(); dendrogram(Z_filam); title('Filam Dendrogram with Ward');

%% Crimes

[xls_data_crimes , cities] = xlsread('CRIMES.XLS');
cities = cities(4:21,2);

figure();
subplot(1,2,1);
scatter(xls_data_crimes(:,1),xls_data_crimes(:,2),'filled');
text(xls_data_crimes(:,1),xls_data_crimes(:,2),cities, 'horizontal','left', 'vertical','bottom');


dist_crimes = pdist(xls_data_crimes,'euclidean');

Z_crimes = linkage(dist_crimes,'complete');

subplot(1,2,2); dendrogram(Z_crimes,'labels',cities,'orientation','right');






