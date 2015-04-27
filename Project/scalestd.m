function [ data_norm ] = scalestd( data )
%SCALESTD   Normalization function:
% N = scalestd(data) returns the matrix N with the normalized matrix data.
% The function performs mean subtraction and standard deviation division.

[L,~] = size(data);

data_norm = data - repmat(mean(data),L,1);

data_norm = data_norm ./ repmat(std(data),L,1);

disp('Data normalization executed.')
end

