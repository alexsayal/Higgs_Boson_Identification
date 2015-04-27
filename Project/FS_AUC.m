function [ FSdata , column_names_new ] = FS_AUC( data , labels , column_names , threshold )
%ROC_AUC for Feature Selection
%   data (events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)
%   threshold (value between 0-1)
%
%   [ FSdata , column_names_new ] = FS_AUC( data , labels , column_names , threshold )

[~,colnum] = size(data);

AUC = zeros(colnum,1);
parfor i=1:colnum
    [~,~,~,AUC(i)] = perfcurve(labels',data(:,i)',1);
end
[AUC_s,AUC_ord] = sort(AUC,'descend');

FSdata = data(:,AUC_ord(AUC_s>=threshold));
column_names_new = column_names(AUC_ord(AUC_s>=threshold));

delete(gcp);
disp('AUC method completed.')

end

