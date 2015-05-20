function [ MVdata , labels_new , rownum_new , colnum_new , column_names_new ] = missingvalues( data , labels , column_names , method )
%MISSING VALUES Removes missing values from data
%   Possible methods - 'mean' , 'mode' , 'meanclass' , 'removeevents' ,
%   'removefeatures'
%
%   [ MVdata , labels_new , rownum_new , colnum_new ] = missingvalues( data , labels , method )

MVdata = data;
nannum = sum(sum(isnan(data))); %Number of NaN
[rownum,colnum] = size(data);
labels_new = labels;
rownum_new = rownum;
colnum_new = colnum;
column_names_new = column_names;

if nargin < 3
    method = 'mean';
    disp('No method specified for MV handling, mean method selected.')
end

switch method
    %----Option 1 - Replace for column mean----%
    case 'mean'
        for i=1:colnum
            aux = MVdata(:,i);
            aux(isnan(aux)) = nanmean(aux);
            MVdata(:,i) = aux;
        end
        
    %----Option 2 - Replace for column mode----%
    case 'mode'
        for i=1:colnum
            aux = MVdata(:,i);
            aux(isnan(aux)) = mode(aux);
            MVdata(:,i) = aux;
        end
        
    %----Option 3 - Replace for class mean----%
    case 'meanclass'
        for i=1:colnum
            aux1 = MVdata(labels==1,i);
            aux2 = MVdata(labels==2,i);
            aux1(isnan(aux1)) = nanmean(aux1);
            aux2(isnan(aux2)) = nanmean(aux2);
            MVdata(labels==1,i) = aux1;
            MVdata(labels==2,i) = aux2;
        end
        
    %----Option 4 - Remove entries with NaN----%
    case 'removeevents'
        i=rownum;
        ind = [];
        while i>=1
            if sum(isnan(MVdata(i,:)))==0
                ind = [ind  i];
            end
            i=i-1;
        end
        MVdata = MVdata(ind,:);
        labels_new = labels(ind);
        rownum_new = length(ind);
        
    %----Option 5 - Remove features with NaN----%
    case 'removefeatures'
        i=colnum;
        ind = [];
        while i>=1
            if sum(isnan(MVdata(:,i)))==0
                ind = [ind  i];
            end
            i=i-1;
        end
        ind = sort(ind);
        MVdata = MVdata(:,ind);
        labels_new = labels;
        colnum_new = length(ind);
        column_names_new = column_names(ind);
end

s = strcat(num2str(nannum),' missing values successfully replaced/removed.');
disp(s);

end