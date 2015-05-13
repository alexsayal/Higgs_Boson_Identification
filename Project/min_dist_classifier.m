%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 3 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%
    
data=FRdata';
id=labels;
testdata = FRtestdata';
testid=testlabels;

[l,c]=size(testdata);

% --- Prototype - Training ---
m=zeros(2,2);
m(1,:)=mean(data(id==1,:));
m(2,:)=mean(data(id==2,:));

% --- simple classifier - Test ---
C=zeros(l,1);
for i=1:l
    if pdist([m(1,:);testdata(i,:)],'euclidean')<pdist([m(2,:);testdata(i,:)],'euclidean')
        C(i)=1;
    else
        C(i)=2;
    end
end

datashow.X = testdata';
datashow.y = C';

figure();
ppatterns(datashow);
hold on
plot([m(1,2) m(2,2)],[m(2,1) m(1,1)],'k--');
hold on
plot(m(:,1),m(:,2),'k*');

cerror(datashow.y,testid)

% Descobrir o que raio é o 1 e 2 --'

