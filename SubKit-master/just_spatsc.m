paths = ['common:', genpath('libs'), 'spatsc:'];
addpath(paths);

rng(1);


m = 0.1;
v = 0.001;

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
