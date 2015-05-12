function [ data_norm ] = scalestd( data )

[L,~] = size(data);

data_norm = data - repmat(mean(data),L,1);

data_norm = data_norm ./ repmat(std(data),L,1);


end

