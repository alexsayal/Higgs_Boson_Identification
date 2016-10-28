function [ data_norm , av , sigma , print ] = scalestd( data , av , sigma)
%SCALESTD   Normalization function
% The function performs mean subtraction and standard deviation division.
%Usage:
%   [data_norm,av,sigma,print] = scalestd(data)
%   [data_norm,av,sigma,print] = scalestd(data,av,sigma)
%Input:
%   data (events x features)
%   av (column mean vector) - optional
%   sigma (column std vector) - optional
%Output:
%   data_norm - normalized data matrix
%   av - column mean vector
%   sigma - column std vector
%   print (string for interface text feedback)

[L,~] = size(data);

if(nargin<2)
    sss = 'Train';
    av = mean(data);   
    sigma = std(data);
else
    sss = 'Test';
end

data_norm = data - repmat(av,L,1);

data_norm = data_norm ./ repmat(sigma,L,1);

fprintf('%s data normalization executed.\n',sss)
print = sprintf('%s data normalization executed.\n',sss);
end