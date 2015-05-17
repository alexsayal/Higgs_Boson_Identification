function [ labels , eventID , column_names , data] = dataimport( file , columns )
%DATAIMPORT   Function to import data
%   [ labels , eventID , column_names , data] = dataimport( file , columns )

labels = file(1:end-50000,32); %Classification
eventID = file(:,1); %Event id
column_names = columns(2:end-1);
data = file(1:end-50000,2:31); %Actual Data

data(data==-999) = NaN; %Convert all -999 to NaN

clear higgs_data_for_optimization;

disp('Data Import Successful.')
end

