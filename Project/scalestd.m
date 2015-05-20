function [ data_norm , av , sigma ] = scalestd( data , av , sigma)
%SCALESTD   Normalization function:
% N = scalestd(data) returns the matrix N with the normalized matrix data.
% The function performs mean subtraction and standard deviation division.

[L,~] = size(data);

if(nargin<2)
    av = mean(data);   
    sigma = std(data);
end

data_norm = data - repmat(av,L,1);

data_norm = data_norm ./ repmat(sigma,L,1);

disp('Data normalization executed.')
end