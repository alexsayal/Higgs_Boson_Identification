%Run preprocessing first

dados.X = normdata(:,[14])';
dados.y = MVlabels;
dados.dim = 1;
dados.num_data = 24428;

figure();
    ppatterns(dados);
    title('ppatterns');
    grid on;
%     xlabel('Component 1'); ylabel('Component 2'); zlabel('Component 3');
%     view(3);