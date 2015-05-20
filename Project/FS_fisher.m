function [ FSdata , column_names_new , selected_features ] = FS_fisher( data , labels , column_names, threshold )
%FISHER SCORE for Feature Selection
%   data (events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)
%   threshold (desired number of features)
%
%   [ FSdata , column_names_new ] = FS_fisher( data , labels , column_names, threshold )

[~,colnum] = size(data);

F = zeros(colnum,1);

for i=1:colnum
    auxc1 = data(labels==1,i);
    auxc2 = data(labels==2,i);
    F(i) =  ( (mean(auxc1)-mean(auxc2))^2 ) / ( var(auxc1)+var(auxc2) );
end

[F_s,F_ord] = sort(F,'descend');

selected_features = F_ord(1:threshold);
FSdata = data(:,selected_features);
column_names_new = column_names(selected_features);

disp('Features selected:');
T = table(num2cell(selected_features),cellstr(column_names_new'),num2cell(F_s(1:threshold)),'VariableNames',{'Column_index' 'Feature' 'Score'});
disp(T);

end