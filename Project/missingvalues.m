function [ MVdata , labels_new , rownum_new ] = missingvalues( data , labels , method )
%MISSING VALUES Removes missing values from data
%   Possible methods - 'mean' , 'mode' , 'remove'
%
%   [ MVdata , labels_new , rownum_new ] = missingvalues( data , labels , method )

MVdata = data;
nannum = sum(sum(isnan(data))); %Number of NaN
[rownum,colnum] = size(data);
labels_new = labels;
rownum_new = rownum;

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
        
    %----Option 3 - Remove entries with NaN----%
    case 'remove'
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
end

s = strcat(num2str(nannum),' missing values successfully replaced/removed.');
disp(s);

end