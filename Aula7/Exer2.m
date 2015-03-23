dist = xlsread('prob1dist.xls');

Z1 = linkage(dist,'single');
Z2 = linkage(dist,'complete');

figure(); dendrogram(Z1); title('Single');
figure(); dendrogram(Z2); title('Complete');
