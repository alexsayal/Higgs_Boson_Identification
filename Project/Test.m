%Run preprocessing first

dados.X = FRdata(1:3,1:15000);
dados.y = labels(1:15000)';
dados.dim = 15;
dados.num_data = 15000;

figure();
    ppatterns(dados);
    title('ppatterns');
    grid on;
    xlabel('Component 1'); ylabel('Component 2'); zlabel('Component 3');
    view(3);