function [  ] = classifier_MD( data_train , m , method)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[l,~]=size(data_train);

C=zeros(l,1);

for i=1:l
    if pdist([m(1,:);data_train(i,:)],method)<pdist([m(2,:);data_train(i,:)],method)
        C(i)=1;
    else
        C(i)=0;
    end
end

declive=-(m(2,2)-m(1,2))/(m(2,1)-m(1,1));
b=(m(2,2)+m(1,2))/2-declive*(m(2,1)+m(1,1))/2;
x=min(data_train(:,1))-2:max(data_train(:,1))+2;
y=declive.*x+b;

figure('Name','Minimum Distance Classifier');
plot(x,y); ylim([min(y)-2,max(y)+2]); xlabel('f1'); ylabel('f2');
hold on
plot(data_train(:,1),data_train(:,2),'o');
hold on
plot(m(:,1),m(:,2),'b*');

end

