function [ FSdata ] = FS_kruskal( data , labels , column_names , thresholdKW )
%KRUSKAL-WALLIS for Feature Selection
%   data(events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)
%   thresholdKW (value between 0-1)
%
%   [ FSdata ] = FS_kruskal( data , labels , column_names , thresholdKW )

disp('|---Kruskal-Wallis Test---|');

[~,colnum] = size(data);
FSdata = data;

chi2 = zeros(colnum,1);
for i=1:colnum
    [~,tbl,~] = kruskalwallis(FSdata(:,i)',labels','off');
    chi2(i) = tbl{2,5};
end

[chi2_sort,ord] = sort(chi2,'descend');
KWcolumn_names = column_names(ord);

T = table(num2cell(ord),cellstr(KWcolumn_names'),num2cell(chi2_sort),'VariableNames',{'Column_index' 'Feature' 'chi2'});
disp(T);

maxchi = thresholdKW*sum(chi2);
chi22 = [];
i = 1;
while(sum(chi22)<=maxchi)
    chi22 = [chi22 ; chi2_sort(i)];
    i=i+1;
end

FSdata = FSdata(:,ord(1:length(chi22)));

disp('Kruskal-Wallis Test executed.');

end

