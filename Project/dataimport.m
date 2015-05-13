function [ labels , eventID , column_names , data , testdata , labelstest] = dataimport( file , columns )
%DATAIMPORT   Function to import data
%   [ labels , eventID , column_names , data , testdata , labelstest] = dataimport( file , columns )

labels = file(1:end-50000,32); %Classification
labelstest = file(end-49999:end,32); %Classification for testing
%raw_labels = file(:,32); %Classification (Final)
eventID = file(:,1); %Event id
column_names = columns(2:end-1);
%raw_data = file(:,2:31); %Actual Data (Final)
data = file(1:end-50000,2:31); %Actual Data
testdata = file(end-49999:end,2:31); %Data for testing

data(data==-999) = NaN; %Convert all -999 to NaN
testdata(testdata==-999) = NaN; %Convert all -999 to NaN
clear higgs_data_for_optimization;

disp('Data Import Successful.')
end

