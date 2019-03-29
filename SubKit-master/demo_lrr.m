clearvars
paths = ['common:', genpath('libs'), 'lrr:'];
addpath(paths);

% rng(1);
% 
% dim_data = 100;
% dim_space = 4;
% n_space = 5;
% cluster_size = 20;
% m = 0.1;
% v = 0.001;
% A = gen_depmultivar_data(dim_data, dim_space, cluster_size, n_space, m, v);

% fileName = sprintf('./../Data/DataSets-Synthetic-Subspace/dataset-Dim%s-dim%sAnomRate%s.mat', num2str(D), num2str(d), num2str(100*anomaly_rate));
% load(fileName);
% labels = dataset(D+1, :);
% A = dataset(1:D, 1:20000);

% mu = [2 3 3];
% sigma = [5 2 2; 2 5 2 ; 2 2 5];
% % sigma = [1 1 1; 1 1 1; 1 1 1 ];
% R1 = mvnrnd(mu,sigma,1000);
% mu = [2 3 3];
% sigma = [1 1 1; 1 1 1; 1 1 1 ];
% R = mvnrnd(mu,sigma,1000);
% A = [R1; R];
% labels = [ones(1, 1000), ones(1,1000) .* 2]
% plot(A(:, 1), A(:, 2), '.')
% axis equal


Dim = [1000];
dim = randi(14, 1, 2)+5;
dependent_dims = [];
for i = 1:length(dim)
    dependent_dims = [dependent_dims; randi(floor(0.6*dim(i)), 1, 1)];  
end

[A, labels]  = SubspaceDatasetGeneratorFunc_dependent(Dim,dim, dependent_dims, 0);
% fileName = sprintf('./../Data/DataSets-Synthetic-Subspace/dataset-Dim%s-AnomRate%s-dependent', num2str(1000), num2str(0));
% load(fileName);
% A = dataset;

n_space = length(unique(labels));



% A = normalize(A);
corruption = 0;

N = randn(size(A)) * corruption;

A = A + N;

A = normalize(A')';

% plot3(A(1, :), A(2, :), A(3, :), '.')
% axis([0 1 0 1 0 1])
figure
tic
Z = lrr_relaxed(A, 0.1);
imagesc(Z);
clusters = ncutW(abs(Z) + abs(Z'), n_space);
elapsed_time = toc
predicted_labels = condense_clusters(clusters, 1);

figure, imagesc(predicted_labels);
the_nmi_value = FindNMI(labels', predicted_labels')
save('results_lrr_dependent.mat', 'clusters', 'labels', 'predicted_labels', 'the_nmi_value', 'elapsed_time');
rmpath(paths);