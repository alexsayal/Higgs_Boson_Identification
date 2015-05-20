
dist = pdist(FRdata(:,1:4000)');

Z1 = linkage(dist,'single');
Z2 = linkage(dist,'complete');
Z3 = linkage(dist,'weighted');

figure(); dendrogram(Z1); title('Single');
figure(); dendrogram(Z2); title('Complete');
figure(); dendrogram(Z3); title('Weighted');