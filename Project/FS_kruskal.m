function [ FSdata , column_names_new , selected_features, print ] = FS_kruskal( data , labels , column_names , threshold )
%KRUSKAL-WALLIS for Feature Selection
%   data(events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)
%   threshold (desired number of features)
%
%   [ FSdata , column_names_new , selected_features ] = FS_kruskal( data , labels , column_names , thresholdKW )

disp('|---Kruskal-Wallis Test---|');

[~,colnum] = size(data);
FSdata = data;

chi2 = zeros(colnum,1);
for i=1:colnum
    [~,tbl,~] = kruskalwallis(FSdata(:,i)',labels','off');
    chi2(i) = tbl{2,5};
end

[chi2_sort,chi2_ord] = sort(chi2,'descend');

selected_features = sort(chi2_ord(1:threshold));

FSdata = FSdata(:,chi2_ord(selected_features));
column_names_new = column_names(chi2_ord(selected_features));

KWcolumn_names = column_names(chi2_ord);

T = table(num2cell(chi2_ord),cellstr(KWcolumn_names'),num2cell(chi2_sort),'VariableNames',{'Column_index' 'Feature' 'chi2'});
disp(T);

figure();
    bar(chi2_sort); line([threshold threshold],[0 max(chi2_sort)]);
    title('\chi^2 Values'); 
    xlabel('Features'); xlim([0 colnum]);
    legend('\chi^2',strcat('Threshold=',num2str(threshold)));

disp('Kruskal-Wallis Test executed.');
print = sprintf('Kruskal-Wallis Test executed.\n%d Features selected.',length(selected_features));

end