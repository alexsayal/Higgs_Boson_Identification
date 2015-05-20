function [ performance , model ] = C_kmeans( train , trainlabels  )
%K-MEANS Summary of this function goes here
%   Detailed explanation goes here

%--- Structures
trn.X = train;
trn.y = trainlabels';
trn.dim = size(train,1);
trn.num_data = size(train,2);

%[2.78 -0.68;0.581 0.2723]
[model,data2.y] = cmeans( trn.X, 2);

if trn.dim==2
figure; ppatterns(data); ppatterns(model.X,'sk',10); pboundary( model );
end

performance = (1-cerror( data2.y, trn.y ))*100;

end

