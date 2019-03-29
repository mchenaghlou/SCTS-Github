clearvars
paths = ['common:', genpath('libs'), 'osc:'];
addpath(paths);

rng('default');

% dim_data = 3;
% dim_space = 2;
% n_space = 3;
% cluster_size = 100;
% m = 0.1;
% v = 0.001;

% D = 100;
% d = 2;
% anomaly_rate = 0.05;
% dim_data = D;
% dim_space = 2;
% n_space = 15;
% fileName = sprintf('./../Data/DataSets-Synthetic-Subspace/dataset-Dim%s-dim%sAnomRate%s.mat', num2str(D), num2str(d), num2str(100*anomaly_rate));
% load(fileName);
% labels = dataset(D+1, :);
% A = dataset(1:D, 1:1000);

% A = gen_depmultivar_data(dim_data, dim_space, cluster_size, n_space, m, v);
% plot3(A(1, :), A(2, :), A(3, :), '.');
% A = normalize(A')';
% plot3(A(1, :), A(2, :), A(3, :), '.');


m = 0.1;
v = 0.001;
D = 3;
dim = 2;
dependent_dims = 1;
[A, labels]  = SubspaceDatasetGeneratorFunc_dependent(D,dim, dependent_dims, 0);
% fileName = sprintf('./../Data/DataSets-Synthetic-Subspace/dataset-Dim%s-AnomRate%s-dependent', num2str(1000), num2str(0));
% load(fileName);
% A = dataset;
n_space = length(unique(labels));
corruption = 0;

N = randn(size(A)) * corruption;

% A = A + N;

% A = normalize(A')';
% plot3(A(1, :), A(2, :), A(3, :), '.');
lambda_1 = 0.099;
lambda_2 = 0.001;
tic
Z = osc_relaxed(A, lambda_1, lambda_2);

clusters = ncutW(abs(Z) + abs(Z'), n_space);

elapsed_time = toc
predicted_labels = condense_clusters(clusters, 1);
the_nmi_value = FindNMI(labels', predicted_labels')
save('results_osc_dependent.mat', 'clusters', 'labels', 'predicted_labels', 'the_nmi_value', 'elapsed_time');
figure, imagesc(predicted_labels);

rmpath(paths);