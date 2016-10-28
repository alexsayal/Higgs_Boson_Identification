function [ labels , eventID , column_names , data] = dataimport( file , columns )
%DATAIMPORT   Function to import data
%Usage:
%   [labels,eventID,column_names,data] = dataimport(file,columns)
%Input:
%   file (raw data matrix)
%   columns (raw column names cell)
%Output:
%   labels (classification vector)
%   eventID (event ID vector)
%   column_names (column names cell array)
%   data (data matrix)

labels = file(:,32); %Classification
eventID = file(:,1); %Event id
column_names = columns(2:end-1);
data = file(:,2:31); %Actual Data

data(data==-999) = NaN; %Convert all -999 to NaN

clear higgs_data_for_optimization;

disp('Data Import Successful.')
end

