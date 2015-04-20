%% Import
clear
clc
load higgs_data.mat
[labels,eventID,column_names,data] = dataimport( higgs_data_for_optimization , column_names);

%% Initial config
[rownum,colnum] = size(data);
data(data==-999) = NaN;

%% Balance
balance_decay = length(labels(labels==1))*100 / (length(labels(labels==2))+length(labels(labels==1)));
balance_background = 100-balance_decay;

%% Missing values
option = 1;

%----Option 1 - Replace for column mean----%
if option==1
    for i=1:colnum
        aux = data(:,i);
        aux(isnan(aux)) = nanmean(aux);
        data(:,i) = aux;
    end
    clear aux;
end

%----Option 2 - Replace for column mode----%
if option==2
    for i=1:colnum
        aux = data(:,i);
        aux(isnan(aux)) = mode(aux);
        data(:,i) = aux;
    end
    clear aux;
end

%----Option 3 - Remove entries with NaN----%
if option==3
    i=rownum;
    ind = [];
    while i>=1
       if sum(isnan(data(i,:)))==0
          ind = [ind  i];
       end
       i=i-1;
    end
    data = data(ind,:);
    labels = labels(ind);
    rownum = length(ind);
end


%----Option 3 - Linear Regression----%
% if option==3
%     missingColumns = find(sum(isnan(data))~=0);
%     nonmissingColumns = find(sum(isnan(data))==0);
%     max=zeros(length(missingColumns),1);
%     ind=zeros(length(missingColumns),1);
%     
%     for j=1:length(missingColumns)
%         for i=nonmissingColumns
%             aux = data(:,missingColumns(j));
%             [a,b] = corr(aux(~isnan(aux)),data(~isnan(aux),i));
%             if(b>max(j))
%                 max(j) = b;
%                 ind(j) = i;
%             end
%         end
%     end
    
    
% end

%% Normalization
normdata = scalestd(data);

%% Feature Selection (Dimension reduction)
option = 1;

switch option
    %----PCA----%
    case 1
        coeff = pca(normdata');
        
        max = 0.95*sum(coeff.eigval); % 95%
        eig = [];
        i = 1;
        while(sum(eig)<=max)
            eig = [eig ; coeff.eigval(i)];
            i=i+1;
        end
        
        PCAnormdata = normdata*coeff.W(:,1:length(eig));
        %PCAcolumn_names = column_names(ord(1:length(eig2)));
        
        %----Kruskal-Wallis----%
    case 2
        rank = zeros(2,colnum);
        chi2 = zeros(1,colnum);
        for i=1:colnum
            [p,tbl,stats] = kruskalwallis(normdata(:,i)',labels','off');
            
            rank(:,i) = stats.meanranks;
            chi2(i) = tbl{2,5};
        end
        
        [chi2_sort,ord] = sort(chi2,'descend');
        KWcolumn_names = column_names(ord);
        
        table(:,1) = cellstr(KWcolumn_names);
        table(:,2) = num2cell(chi2_sort);
        disp('Features Rank:');
        disp(table);
        
        chi22 = chi2(chi2>=0.05*sum(chi2)); % 95%
        normdata = normdata(:,ord(1:length(chi22)));
end
