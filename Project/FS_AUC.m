function [ FSdata , column_names_new , selected_features, print] = FS_AUC( data , labels , column_names , threshold )
%ROC_AUC for Feature Selection
%Usage:
%   [FSdata,column_names_new,selected_features,print] = FS_AUC(data,labels,column_names,threshold)
%Input:
%   data (events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)
%   threshold (value between 0-1)
%Output:
%   FSdata (data matrix with selected features)
%   column_names_new (cell with selected features' names)
%   selected_features (vector with selected features' index)
%   print (string for interface text feedback)

[~,colnum] = size(data);

AUC = zeros(colnum,1);

parfor i=1:colnum
    [~,~,~,AUC(i)] = perfcurve(labels',data(:,i)',1);
end
[AUC_s,AUC_ord] = sort(AUC,'descend');

selected_features = AUC_ord(AUC_s>=threshold);
FSdata = data(:,sort(selected_features));
column_names_new = column_names(selected_features);

disp('Features selected:');
T = table(num2cell(selected_features),cellstr(column_names_new'),num2cell(AUC_s(AUC_s>=threshold)),'VariableNames',{'Column_index' 'Feature' 'Area'});
disp(T);

selected_features = sort(selected_features);
column_names_new = column_names(selected_features);

disp('AUC method completed.')

print = sprintf('AUC method completed.\n%d Features selected.',length(selected_features));
end