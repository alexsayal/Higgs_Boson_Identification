function [ FSdata , column_names_new , selected_features ] = FS_mRMR( data , labels , column_names, threshold )
%mRMR for Feature Selection
%   data(events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)
%   threshold (desired number of features)
%
%   [ FSdata , column_names_new ] = FS_mRMR( data , labels , column_names, threshold )

disp('|---mRMR---|');

[selected_features] = mrmr_mid_d(data,labels,threshold);
        
FSdata = data(:,selected_features);
column_names_new = column_names(selected_features);

T = table(num2cell(selected_features'),cellstr(column_names_new'),'VariableNames',{'Column_index' 'Feature'});
disp(T);
selected_features = selected_features';        
disp('mRMR completed.')
end