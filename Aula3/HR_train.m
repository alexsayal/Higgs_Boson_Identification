%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 3 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load

raw_data = importdata('semeion.data');

data = raw_data(:,1:256);
id = raw_data(:,257:end);

clear raw_data;

%% Visualize
for i=1:length(data)
    A = vec2mat(data(i,:),16);
    imagesc(A);
    pause;
end

%% Feature Extraction

% ------ Percent pixels above & below horizontal -------
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
plot(P_left,'o'); line([0 1593],[media_P_left media_P_left],'Color','g');
hold on;
plot(P_right,'*r'); line([0 1593],[media_P_right media_P_right],'Color','g');