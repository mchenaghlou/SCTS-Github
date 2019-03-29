clearvars
paths = ['common:', genpath('libs'), 'lsr:'];
addpath(paths);

rng(1);

% dim_data = 100;
% dim_space = 4;
% n_space = 5;
% cluster_size = 20;
% m = 0.1;
% v = 0.001;
% A = gen_depmultivar_data(dim_data, dim_space, cluster_size, n_space, m, v);


Dim = 1000;
dim = randi(14, 1, 10)+1;
dependent_dims = [];
for i = 1:length(dim)
    dependent_dims = [dependent_dims; randi(floor(0.5*dim(i)), 1, 1)]    
end
[A, labels]  = SubspaceDatasetGeneratorFunc_dependent(Dim,dim, dependent_dims, 0);
   


n_space = length(unique(labels));
A = normalize(A')';
plot3(A(1, :), A(2, :), A(3, :), '.')
corruption = 0;

N = randn(size(A)) * corruption;

X = A + N;

X = normalize(X')';

Z = lsr_relaxed(X, 0.01, false);

clusters = ncutW(abs(Z) + abs(Z'), n_space);

final_clusters = condense_clusters(clusters, 1);
FindNMI(labels', final_clusters')
figure, imagesc(final_clusters);

rmpath(paths);