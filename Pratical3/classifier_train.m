function [ M ] = classifier_train( data_train , data_class)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

c = unique(data_class);
c_num = length(c);

% --- Prototype ---
M=zeros(c_num,c_num);
for ii=1:c_num
    M(ii,:)=mean(data_train(data_class==c(ii),:));
end

end

