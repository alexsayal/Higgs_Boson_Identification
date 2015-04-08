function [ labels , eventID , column_names , data ] = dataimport( file , columns )
%DATAIMPORT   Function to import data
%   Detailed explanation goes here

labels = file(:,32); %Classification
raw_labels = file(:,32); %Classification (Final)
eventID = file(:,1); %Event id
column_names = columns(2:end-1);
raw_data = file(:,2:31); %Actual Data (Final)
data = file(:,2:31); %Actual Data

clear higgs_data_for_optimization;

end

