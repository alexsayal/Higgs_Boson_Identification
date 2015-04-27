function [ FSdata , column_names_new ] = FS_corr( data , labels , column_names , method , threshold)
%CORRELATION for Feature Selection
%   data(events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)

%   Method 'feat': Between features
%       threshold (value between 0-1)
%   Method 'featlabel': Between features and labels
%       threshold (desired number of features)

FSdata = data;
[~,colnum] = size(data);
column_names_new = column_names;

switch method
    %----Correlation between features----%
    case 'feat'
        RHO = corr(data);
        RHO = triu(abs(RHO)); %triu - upper part of matrix
        RHO(RHO==1) = -10;
        
        [maxcor,indmax] = max(RHO);
        indmax = sort(unique(indmax(maxcor>=threshold)),'descend');
        for i=indmax
            FSdata(:,i) = [];
            column_names_new(i) = [];
        end
        
    %----Correlation between features and labels----%
    case 'featlabel'
        C = zeros(30,1);
        for i=1:colnum
            C(i) = abs(corr(data(:,i),labels));
        end
        [~,ordC] = sort(C,'descend');
        
        FSdata = data(:,ordC(1:threshold));
        column_names_new = column_names(ordC(1:threshold));
        
end

disp('Correlation method completed.');

end