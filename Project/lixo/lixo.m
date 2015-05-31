%% LIXO


% %----Option 4 - Linear Regression----%
% if option==4
%     missingColumns = find(sum(isnan(data))~=0);
%     nonmissingColumns = find(sum(isnan(data))==0);
%     maxi=zeros(length(missingColumns),1);
%     ind=zeros(length(missingColumns),1);
%     
%     for j=1:length(missingColumns)
%         for i=nonmissingColumns
%             aux = data(:,missingColumns(j));
%             [a,b] = corr(aux(~isnan(aux)),data(~isnan(aux),i));
%             
%             if(a>maxi(j))
%                 maxi(j) = a;
%                 ind(j) = i;
%             end
%         end
%     end
%     
%     
%     
% end