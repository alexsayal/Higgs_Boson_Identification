data.X = FRdata;
data.y = labels';
data.dim = 2;
data.num_data = 150000;

[model,data2.y] = cmeans( data.X, 2 , [2.78 -0.68;0.581 0.2723]);
figure; ppatterns(data);
ppatterns(model.X,'sk',10); pboundary( model );

cerror( data2.y, data.y )