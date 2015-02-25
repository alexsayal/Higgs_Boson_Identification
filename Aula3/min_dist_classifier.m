%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 3 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%
    
raw_data=importdata('dataset_3.csv');
data=raw_data.data(:,1:2);
id=raw_data.data(:,3);
[l,c]=size(data);

% --- Prototype ---
m=zeros(2,2);
m(1,:)=mean(data(id==1,:));
m(2,:)=mean(data(id==0,:));

% --- simple classifier ---
C=zeros(l,1);
for i=1:l
    if pdist([m(1,:);data(i,:)],'euclidean')<pdist([m(2,:);data(i,:)],'euclidean')
        C(i)=1;
    else
        C(i)=0;
    end
end

declive=-(m(2,2)-m(1,2))/(m(2,1)-m(1,1));
b=(m(2,2)+m(1,2))/2-declive*(m(2,1)+m(1,1))/2;
x=0:12;
y=declive.*x+b;

figure();
plot(x,y);
hold on
plot(data(:,1),data(:,2),'o');
hold on
plot(m(:,1),m(:,2),'b*');

