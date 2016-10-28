function [ MVdata , labels_new , MVtest , test_labels_new, column_names_new, print,f_ind ] = missingvalues( data , labels , test , testlabels , column_names , method )
%MISSING VALUES Removes missing values from data
%Usage:
%   [MVdata,labels_new,MVtest,test_labels_new,column_names_new,print] = missingvalues(data,labels,test,testlabels,column_names,method)
%Input:
%   data (events x features)
%   labels (events x 1)
%   test (events x features)
%   testlabels (events x 1)
%   column_names (1 x colnum cell)
%   method:
%       'mean' - replace for column mean
%       'mode' - replace for column mode
%       'removeevents' - remove events with at least one MV
%       'removefeatures' - remove features with at least one MV
%Output:
%   MVdata (train data without MV)
%   labels_new (events x 1)
%   MVtest (validation data without MV)
%   test_labels_new (events x 1)
%   column_names_new (1 x colnum cell)
%   print (string for interface text feedback)

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
if(~strcmp(method,'removefeatures')), f_ind = 1:30; end

switch method
    %----Option 1 - Replace for column mean----%
    case 'mean'
        for i=1:colnum
            aux = MVdata(:,i);
            auxtest = MVtest(:,i);
            aux(isnan(aux)) = nanmean(aux);
            MVdata(:,i) = aux;
            auxtest(isnan(auxtest)) = nanmean(aux);
            MVtest(:,i) = auxtest;
        end
        
    %----Option 2 - Replace for column mode----%
    case 'mode'
        for i=1:colnum
            aux = MVdata(:,i);
            auxtest = MVtest(:,i);
            aux(isnan(aux)) = mode(aux);
            MVdata(:,i) = aux;
            auxtest(isnan(auxtest)) = mode(aux);
            MVtest(:,i) = auxtest;
        end
        
    %----Option 3 - Remove entries with NaN----%
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
        
    %----Option 4 - Remove features with NaN----%
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
        f_ind = ind;
end

fprintf('\n%d missing values successfully replaced/removed from train set.\n',nannum);
fprintf('%d missing values successfully replaced/removed from test set.\n',testnannum);

print = sprintf('%d missing values successfully replaced/removed from train set.\n%d missing values successfully replaced/removed from test set.\n',nannum,testnannum);
end