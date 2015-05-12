%%%%% = Técnicas de Reconhecimento de Padrões = %%%%%
%%%%% ================= Aula 2 ================ %%%%%
%%%%% ================== 2015 ================= %%%%%

%% Load Directories Alex
fruits = dir('/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/TEST/*.JPG');
main_dir = '/Users/alexandresayal/Desktop/MATLAB_TRP/Aula2/FRUITS/TEST/';

%% Load Directories Sara
% fruits = dir('C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\TEST\*.jpg');
% main_dir='C:\Users\sara\Documents\MATLAB\TRP\Aula2\FRUITS\TEST\';

%% STPR

data.X = F(:,3:end)';
data.y = F(:,2)';
data.dim = size(data.X,1);
data.num_data = size(data.X,2);

figure(); ppatterns(data)
