%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 3 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load

raw_data = importdata('semeion.data');

data = raw_data(:,1:256);
[l,c]=size(data);
id = raw_data(:,257:end);

clear raw_data;

%% Visualize
% for i=1:length(data)
%     A = vec2mat(data(i,:),16);
%     imagesc(A);
%     pause;
% end

%% Matrix
M=zeros(l,5);
M(:,1)=1:l;
[~,b]=find(id==1);
M(:,2)=b-1;

% = Feature Extraction = %

%% ------ Percent pixels above & below horizontal -------
P_above = zeros(1,length(data));
P_below = zeros(1,length(data));
for i=1:length(data)
    A = vec2mat(data(i,:),16);
    
    p_above = sum(sum(A(1:8,:)));
    p_below = sum(sum(A(9:end,:)));
    
    P_above(i) = p_above/sum(sum(A));
    P_below(i) = p_below/sum(sum(A));
end
media_P_above = mean(P_above);
media_P_below = mean(P_below);

M(:,3)=P_above-P_below;
%M(:,3) = P_below;

figure();
plot(P_above,'o'); line([0 1593],[media_P_above media_P_above],'Color','g');
hold on;
plot(P_below,'*r'); line([0 1593],[media_P_below media_P_below],'Color','g');

%% ------ Percent pixels above & below vertical -------
P_left = zeros(1,length(data));
P_right = zeros(1,length(data));
for i=1:length(data)
    A = vec2mat(data(i,:),16);
    
    p_left = sum(sum(A(:,1:8)));
    p_right = sum(sum(A(:,9:end)));

    P_left(i) = p_left/sum(sum(A));
    P_right(i) = p_right/sum(sum(A));
end
media_P_left = mean(P_left);
media_P_right = mean(P_right);

M(:,4)=P_left-P_right;
%M(:,4)= P_right;

figure();
plot(P_left,'o'); line([0 1593],[media_P_left media_P_left],'Color','g');
hold on;
plot(P_right,'*r'); line([0 1593],[media_P_right media_P_right],'Color','g');

%% ------ Average distance to center ------
center=[8,8];
mean_dist=zeros(1,length(data));

for i=1:length(data)
    A = vec2mat(data(i,:),16);
    [j,k]=find(A==1);
    mean_dist(i)=euclidean_dist(center,[j,k]);
end

M(:,5)=mean_dist;

figure();
plot(mean_dist,'o');

%% ------ Regions ------ %%

% To be explored

%% ------ STPR Tool ------

dados.X=M(:,3:end)';
dados.y=M(:,2)';
dados.dim=size(dados.X,1);
dados.num_data=size(dados.X,2);

figure();
ppatterns(dados);
  