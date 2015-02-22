%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 2 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load Directories Alex
apples = dir('/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/APPLES/*.JPG');
peaches = dir('/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/PEACHES/*.JPG');
oranges = dir('/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/ORANGES/*.JPG');
main_dir = '/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS';

%% Load Directories Sara
% apples=dir('C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\APPLES\*.jpg');
% oranges=dir('C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\ORANGES\*.jpg');
% peaches=dir('C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\PEACHES\*.jpg');
% main_dir='C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS';

%% DataSet


%% Apples
for i=1:length(apples)
   A=imread(strcat(main_dir,'/APPLES/',apples(i).name));
   
   [c,l,z] = size(A); %Comprimento, Largura, Channels
   window_c = floor(c/2-0.25*c):floor(c/2+0.25*c);
   window_l = floor(l/2-0.25*l):floor(l/2+0.25*l);
   
   red = A(window_c,window_l,1);
   green = A(window_c,window_l,2);
   blue = A(window_c,window_l,3);
   
   % Histograms
   [C1,L1] = imhist(red);
   [C2,L2] = imhist(green);
   [C3,L3] = imhist(blue);
   
   % Extreme values of each channel
   M_red = [min(min(red)) max(max(red)) L1(C1==max(C1))];
   M_green = [min(min(green)) max(max(green)) L2(C2==max(C2))];
   M_blue = [min(min(blue)) max(max(blue)) L3(C3==max(C3))];
   
   % Ratios
   R1 = M_red(3)/M_green(3)
   R2 = M_red(3)/M_blue(3)
   
   
   subplot(1,4,1); imhist(red); title('Red Channel');
   subplot(1,4,2); imhist(green); title('Green Channel');
   subplot(1,4,3); imhist(blue); title('Blue Channel');

   A_bw = rgb2gray(A);
   
   B = imsharpen(A_bw);
   B = imadjust(B);
   B = im2bw(B);
   
   subplot(1,4,4); imshow(B);
   
   pause;
   hold off
end

%% Peaches
for i=1:length(peaches)
   A=imread(strcat(main_dir,'/PEACHES/',peaches(i).name));
   
   [c,l,z] = size(A);
   window_c = floor(c/2-0.25*c):floor(c/2+0.25*c);
   window_l = floor(l/2-0.25*l):floor(l/2+0.25*l);
   
   red = A(window_c,window_l,1);
   green = A(window_c,window_l,2);
   blue = A(window_c,window_l,3);
   
   subplot(1,3,1); imhist(red); title('Red Channel');
   subplot(1,3,2); imhist(green); title('Green Channel');
   subplot(1,3,3); imhist(blue); title('Blue Channel');

   pause;
end

%% Oranges
for i=1:length(oranges)
   A=imread(strcat(main_dir,'/PEACHES/',peaches(i).name));
   
   [c,l,z] = size(A);
   window_c = floor(c/2-0.25*c):floor(c/2+0.25*c);
   window_l = floor(l/2-0.25*l):floor(l/2+0.25*l);
   
   red = A(window_c,window_l,1);
   green = A(window_c,window_l,2);
   blue = A(window_c,window_l,3);
   
   subplot(1,3,1); imhist(red); title('Red Channel');
   subplot(1,3,2); imhist(green); title('Green Channel');
   subplot(1,3,3); imhist(blue); title('Blue Channel');

   pause;
end