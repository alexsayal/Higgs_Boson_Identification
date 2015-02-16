apples=dir('C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\APPLES\*.jpg');
oranges=dir('C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\ORANGES\*.jpg');
peaches=dir('C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\PEACHES\*.jpg');
dirmain='C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS';

for i=1:length(apples)
A=imread(strcat(dirmain,'\APPLES\',apples(i).name));
[x,y,z]=size(A);
window_x=floor(x/2-0.25*x):floor(x/2+0.25*x);
window_y=floor(y/2-0.25*y):floor(y/2+0.25*y);
RED=A(window_x,window_y,1);
GREEN=A(window_x,window_y,2);
BLUE=A(window_x,window_y,3);
subplot(1,3,1),imhist(RED),title('RED CHANNEL');
subplot(1,3,2),imhist(GREEN),title('GREEN CHANNEL');
subplot(1,3,3),imhist(BLUE),title('BLUE CHANNEL');
pause
end


%%
for i=1:length(oranges)
O=imread(strcat(dirmain,'\ORANGES\',orange(i).name));
end

for i=1:length(peaches)
P=imread(strcat(dirmain,'\PEACHES\',peaches(i).name));
end
