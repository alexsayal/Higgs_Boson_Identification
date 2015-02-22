%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 2 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load Directories Alex
fruits = dir('/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/TRAIN/*.JPG');
main_dir = '/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/TRAIN/';

%% Load Directories Sara
% fruits = dir('C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\TRAIN\*.jpg');
% main_dir='C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\TRAIN\';

%% Feature Extraction

F = zeros(64,5); % #Im , Class , R colour , R1 Altura , R2 Largura %

for i=1:length(fruits)
    % ------ Image ------
    A=imread(strcat(main_dir,fruits(i).name));
    [c,l,z] = size(A); %Altura, Largura, Channels
    
    % ------ Classe ------
    F(i,1) = i;
    if fruits(i).name(1)=='A'
        F(i,2) = 1;
    elseif  fruits(i).name(1)=='O'
        F(i,2) = 2;
    elseif fruits(i).name(1)=='P'
        F(i,2) = 3;
    end
    
    % ------ Forma ------
    A_g = rgb2hsv(A);
    
    threshold = 0.40;
    A_BW = im2bw(A_g(:,:,2),threshold);
    
    aux = zeros(l,1);
    aux2 = zeros(c,1);
    
    % Altura
    for ii = 1:l
        aux(ii) = sum(A_BW(:,ii));
    end
    
    [M_altura,ind] = max(aux);
    M_altura2 = aux(ind-50);
    M_altura3 = aux(ind+50);
    
    % Largura
    for ii = 1:c
        aux2(ii) = sum(A_BW(ii,:));
    end
    
    [M_largura,ind2] = max(aux2);
    M_largura2 = aux(ind2-50);
    M_largura3 = aux(ind2+50);
    
    % Ratios
    F(i,4) = M_altura + M_altura2 + M_altura3;
    F(i,5) = M_largura + M_largura2 + M_largura3;
    
    % ------ Cor ------
    window_c = floor(c/2-0.25*c):floor(c/2+0.25*c);
    window_l = floor(l/2-0.25*l):floor(l/2+0.25*l);
    
    red = A(window_c,window_l,1);
    green = A(window_c,window_l,2);
    blue = A(window_c,window_l,3);
    
    % Histograms
    [C1,L1] = imhist(red);
    [C2,L2] = imhist(green);
    [C3,L3] = imhist(blue);
    
    % Maximum values of each channel
    M_red = L1(C1==max(C1));
    M_green = L2(C2==max(C2));
    M_blue = L3(C3==max(C3));
    
    % Ratio
    F(i,3) = M_red(1)/M_green(1);
end
