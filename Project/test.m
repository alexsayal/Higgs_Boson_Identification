%Run preprocessing first

dados.X = normdata(:,[1,3,6])';
dados.y = labels';
dados.dim = colnum;
dados.num_data = rownum;

ppatterns(dados);