function [ FSdata , column_names_new ] = FS_mRMR( data , labels , column_names, threshold )
%mRMR for Feature Selection
%   data(events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)
%   threshold (desired number of features)
%
%   [ FSdata , column_names_new ] = FS_mRMR( data , labels , column_names, threshold )

disp('|---mRMR---|');

[mrmr_result] = mrmr_mid_d(data,labels,threshold);
        
FSdata = data(:,mrmr_result);
column_names_new = column_names(mrmr_result);

T = table(num2cell(mrmr_result'),cellstr(column_names_new'),'VariableNames',{'Column_index' 'Feature'});
disp(T);
        
disp('mRMR completed.')
end