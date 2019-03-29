paths = ['common:', genpath('libs'), 'cass:'];
addpath(paths);
% A = A(:, 1:50)
% labels = labels(1:50)
rng(1);

m = 0.1;
v = 0.001;
corruption = 0;
N = randn(size(A)) * corruption;

X = A + N;

X = normalize(X);
tic
Z = cass_relaxed(X, 0.01);

imagesc(Z);

clusters = ncutW(abs(Z) + abs(Z'), n_space);

elapsed_time = toc
predicted_labels = condense_clusters(clusters, 1);
the_nmi_value = FindNMI(labels', predicted_labels')
save('results_cass_dependent.mat', 'clusters', 'labels', 'predicted_labels', 'the_nmi_value', 'elapsed_time');
figure, imagesc(predicted_labels);

rmpath(paths);
% clear 