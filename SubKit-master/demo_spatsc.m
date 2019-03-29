paths = ['common:', genpath('libs'), 'spatsc:'];
addpath(paths);

rng(1);

dim_data = 100;
dim_space = 4;
n_space = 5;
cluster_size = 20;
m = 0.1;
v = 0.001;

% A = gen_depmultivar_data(dim_data, dim_space, cluster_size, n_space, m, v);
% D = 100;
% d = 2;
% anomaly_rate = 0.05;
% dim_data = D;
% dim_space = 2;
% n_space = 15;
% 
% fileName = sprintf('./../Data/DataSets-Synthetic-Subspace/dataset-Dim%s-dim%sAnomRate%s.mat', num2str(D), num2str(d), num2str(100*anomaly_rate));
% load(fileName);
% labels = dataset(D+1, :);
% A = dataset(1:D, 1:1000);



A = normalize(A);

corruption = 0;

N = randn(size(A)) * corruption;

X = A + N;

X = normalize(X);

lambda_1 = 0.099;
lambda_2 = 0.001;
Z = spatsc_relaxed(X, lambda_1, lambda_2);

clusters = ncutW(abs(Z) + abs(Z'), n_space);

final_clusters = condense_clusters(clusters, 1);

figure, imagesc(final_clusters);

rmpath(paths);