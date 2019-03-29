clearvars

anomaly_rates = [0];
% Dim = [100];
% dim = [2,3,5,10,20,30,40, 50,60, 70, 80,100];

Dim = [1000];
dim = randi(14, 1, 3)+5;
% dependent_dims = [];
% sorted_dim = sort(dim);
% Dim = 3;
% dim = [2, 1];
% for i = 1:length(dim)
%     dependent_dims = [dependent_dims; randi(floor(0.6*dim(i)), 1, 1)];  
% end
% [A, labels]  = SubspaceDatasetGeneratorFunc_dependent(Dim,dim, dependent_dims, 0);
[A, labels]  = SubspaceDatasetGeneratorFunc_multi_cluster(Dim,dim, 0);
plot3(A(1, :), A(2, :), A(3, :), '.')
sorted_dim = sort(dim);
[basis label newenergy iter]=kmcl1sd(A',sorted_dim,0.001,10000,2,1);   
FindNMI(labels', label')



% for anomaly_rate = anomaly_rates
%     for i = 1:length(Dim)
%         D = Dim(i);
%         for j = 1:length(dim)
%             d = dim(j);
%             
%             %%%% For Generating Data
%             %             [dataset, labels]  = SubspaceDatasetGeneratorFunc(D,d, anomaly_rate);
%             %             plot3(dataset(1, :), dataset(2, :), dataset(3, :), '.')
%             
%             fileName = sprintf('./../Data/DataSets-Synthetic-Subspace/dataset-Dim%s-dim%sAnomRate%s-singlecluster', num2str(D), num2str(d), num2str(100*anomaly_rate));
%             load(fileName);
%             
%             labels = dataset(D+1, :);
%             dataset = dataset(1:D, :);
%             
%             X = dataset';
%             s = labels;
% 
%             [basis label newenergy iter]=kmcl1sd(X,[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],0.001,10000,2,1);   
%             milad = 1;
%         end
%     end
% end
% 
% 
