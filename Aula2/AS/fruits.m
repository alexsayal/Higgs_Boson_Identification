%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 2 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load Directories
apples = dir('/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/APPLES/*.JPG');
peaches = dir('/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/PEACHES/*.JPG');
oranges = dir('/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/ORANGES/*.JPG');
main_dir = '/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS';

%% Apples
for i=1:length(apples)
   A=imread(strcat(main_dir,'/APPLES/',apples(i).name));
   
   [c,l,z] = size(A); %Comprimento, Largura, Channels
   window_c = floor(c/2-0.25*c):floor(c/2+0.25*c);
   window_l = floor(l/2-0.25*l):floor(l/2+0.25*l);
   
   red = A(window_c,window_l,1);
   green = A(window_c,window_l,2);
   blue = A(window_c,window_l,3);
   
   %Extreme values of each channel
   M_red = [min(min(red)) max(max(red))];
   M_green = [min(min(green)) max(max(green))];
   M_blue = [min(min(blue)) max(max(blue))];
   
   subplot(1,4,1); imhist(red); title('Red Channel');
   subplot(1,4,2); imhist(green); title('Green Channel');
   subplot(1,4,3); imhist(blue); title('Blue Channel');

   A_bw = rgb2gray(A);
   B = decorrstretch(A_bw);
   %A_bw = A;
   
   B = imsharpen(A_bw);
   B = imadjust(B);
   B = im2bw(B);
   subplot(1,4,4); imshow(B);
   
%    threshold = graythresh(A_bw);
%    A_bw2 = im2bw(A_bw,threshold);
%    se = strel('disk',2);
%    A_bw2 = imclose(A_bw2,se);
%    A_bw2 = imfill(A_bw2,'holes');
%    
%    [B,L] = bwboundaries(A_bw2,'noholes');
% 
%    subplot(1,4,4); imshow(label2rgb(L, @jet, [.5 .5 .5]))
%    hold on
%    for k = 1:length(B)
%        boundary = B{k};
%        subplot(1,4,4); plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
%    end
   
   %A_bw2 = im2bw(A_bw);
   %subplot(1,4,4); imshow(A_bw2); 
   %subplot(1,4,4); imcontour(A_bw,3); 
   
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