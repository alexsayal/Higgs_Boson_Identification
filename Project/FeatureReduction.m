function [ FRdata ] = FeatureReduction( data_structure , method , threshold )
%FEATURE REDUCTION 
%   data_structure:
%       data.X = data (features x events)
%       data.y = labels (1 x events)
%       data.dim = #features
%       data.num_data = #events
%   Method 'pca': Principal Component Analysis
%       threshold (percentage of eigvalues 0-1)
%   Method 'lda': Linear Discriminant Analysis
%       threshold (desired number of features)
%
%   [ FRdata ] = FeatureReduction( data_structure , method , threshold )

switch method
%----PCA----%
    case 'pca'
        PCAmodel = pca(data_structure.X);
        
        maxeig = threshold*sum(PCAmodel.eigval); 
        eig = [];
        i = 1;
        while(sum(eig)<=maxeig)
            eig = [eig ; PCAmodel.eigval(i)];
            i=i+1;
        end
        
        figure();
            bar(PCAmodel.eigval); line([i i],[0 max(PCAmodel.eigval)]);
            title('PCA Eigenvalues');
            xlabel('Features');
            legend('Eigenvalues',strcat('Threshold=',num2str(threshold*100),'%'));
            
        FRdata = PCAmodel.W(:,1:length(eig))'*data_structure.X;
        
%----LDA----%        
    case 'lda'
        LDAmaxdim = 2; 
        LDAmodel = lda(data_structure,LDAmaxdim);
        FRdata = LDAmodel.W'*data_structure.X;
end

end