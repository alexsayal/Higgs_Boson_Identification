%% Import
clear
clc
load higgs_data.mat

labels = higgs_data_for_optimization(:,32); %Classification
eventID = higgs_data_for_optimization(:,1); %Event id
data = higgs_data_for_optimization(:,2:31); %Actual Data

clear higgs_data_for_optimization;

%% Initial config
[rownum,colnum] = size(data);
data(data==-999) = NaN;

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

%----Option 2 - Remove rows with NaN----%
if option==2
    
end


