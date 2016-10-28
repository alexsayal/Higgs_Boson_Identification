function [ FRdata , W ] = FeatureReduction( data_structure , method , threshold )
%FEATURE REDUCTION Function to perform PCA or LDA
%Usage:
%   [FRdata,W] = FeatureReduction(data_structure,method,threshold)
%Input:
%   data_structure:
%       data.X = data (features x events)
%       data.y = labels (1 x events)
%       data.dim = #features
%       data.num_data = #events
%   Method 'pca': Principal Component Analysis
%       threshold (percentage of eigvalues 0-1)
%   Method 'lda': Linear Discriminant Analysis
%       threshold (desired number of features) -> (Number of classes-1)
%Output:
%   FRdata (transformed data matrix)
%   W (eigenvector matrix)

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
            bar(PCAmodel.eigval); line([i-1 i-1],[0 max(PCAmodel.eigval)]);
            title('PCA Eigenvalues');
            xlabel('Components');
            legend('Eigenvalues',strcat('Threshold=',num2str(threshold*100),'%'));
            
        W = PCAmodel.W(:,1:length(eig));
        FRdata = PCAmodel.W(:,1:length(eig))'*data_structure.X;
        
%----LDA----%        
    case 'lda'
        LDAmodel = lda(data_structure,threshold);
        
        figure();
            bar(real(diag(LDAmodel.eigval)));
            title('LDA Eigenvalues');
            xlabel('Components');
        
        W = LDAmodel.W;
        FRdata = LDAmodel.W'*data_structure.X;
end

disp(strcat(method, ' executed.'));

end