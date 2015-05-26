function [ MVdata , labels_new , MVtest , test_labels_new, column_names_new ] = missingvalues( data , labels , test , testlabels , column_names , method )
%MISSING VALUES Removes missing values from data
%   Possible methods - 'mean' , 'mode' , 'meanclass' , 'removeevents' ,
%   'removefeatures'
%
%   [ MVdata , labels_new , rownum_new , colnum_new ] = missingvalues( data , labels , method )

MVdata = data;
MVtest = test;
nannum = sum(sum(isnan(MVdata))); %Number of NaN in train
testnannum = sum(sum(isnan(MVtest))); %Number of NaN in test
[rownum,colnum] = size(MVdata);
[testrownum,~] = size(MVtest);
labels_new = labels;
test_labels_new = testlabels;

column_names_new = column_names;

if nargin < 5
    method = 'mean';
    disp('No method specified for MV handling, mean method selected.')
end

switch method
    %----Option 1 - Replace for column mean----%
    case 'mean'
        for i=1:colnum
            aux = MVdata(:,i);
            auxtest = MVtest(:,i);
            aux(isnan(aux)) = nanmean(aux);
            MVdata(:,i) = aux;
            MVtest(isnan(auxtest),:) = aux;
        end
        
    %----Option 2 - Replace for column mode----%
    case 'mode'
        for i=1:colnum
            aux = MVdata(:,i);
            auxtest = MVtest(:,i);
            aux(isnan(aux)) = mode(aux);
            MVdata(:,i) = aux;
            MVtest(isnan(auxtest),:) = aux;
        end
        
    %----Option 3 - Replace for class mean----%
%     case 'meanclass'
%         for i=1:colnum
%             aux1 = MVdata(labels==1,i);
%             aux2 = MVdata(labels==2,i);
%             aux1(isnan(aux1)) = nanmean(aux1);
%             aux2(isnan(aux2)) = nanmean(aux2);
%             MVdata(labels==1,i) = aux1;
%             MVdata(labels==2,i) = aux2;
%         end
        
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
        
        i=testrownum;
        ind = [];
        while i>=1
            if sum(isnan(MVtest(i,:)))==0
                ind = [ind  i];
            end
            i=i-1;
        end
        MVtest = MVtest(ind,:);
        test_labels_new = testlabels(ind);
        
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
        MVtest = MVtest(:,ind);
        labels_new = labels;
        test_labels_new = testlabels;
        column_names_new = column_names(ind);
end

fprintf('\n%d missing values successfully replaced/removed from train set.\n',nannum);
fprintf('%d missing values successfully replaced/removed from test set.\n',testnannum);

end