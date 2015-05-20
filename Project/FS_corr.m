function [ FSdata , column_names_new , selected_features ] = FS_corr( data , labels , column_names , method , threshold)
%CORRELATION for Feature Selection
%   data(events x features)
%   labels (events x 1)
%   column_names (1 x colnum cell)

%   Method 'feat': Between features
%       threshold (value between 0-1)
%   Method 'featlabel': Between features and labels
%       threshold (value between 0-1)

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
        
        selected_features = 1:colnum;
        selected_features = selected_features';
        
        for i=indmax
            FSdata(:,i) = [];
            column_names_new(i) = [];
            selected_features(selected_features==i) = [];
        end
        disp('Features eliminated:');
        T = table(num2cell(indmax'),cellstr(column_names(indmax)'),'VariableNames',{'Column_index' 'Feature'});
        disp(T);
        
    %----Correlation between features and labels----%
    case 'featlabel'
        C = zeros(30,1);
        for i=1:colnum
            C(i) = abs(corr(data(:,i),labels));
        end
        [sortC,ordC] = sort(C,'descend');
        
        selected_features = ordC(sortC>=threshold);
        FSdata = data(:,selected_features);
        column_names_new = column_names(selected_features);
        
        disp('Features selected:');
        T = table(num2cell(ordC(sortC>=threshold)),cellstr(column_names_new'),num2cell(sortC(sortC>=threshold)),'VariableNames',{'Column_index' 'Feature' 'Correlation'});
        disp(T);
end

disp('Correlation method completed.');

end