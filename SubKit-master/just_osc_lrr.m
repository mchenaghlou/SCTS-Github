paths = ['common:', genpath('libs'), 'osc:'];
addpath(paths);

m = 0.1;
v = 0.001;

n_space = length(unique(labels));

A = normalize(A);

corruption = 0;

N = randn(size(A)) * corruption;

X = A + N;

X = normalize(X);

tic
lambda_1 = 0.099;
lambda_2 = 0.001;
Z = osc_relaxed_lrr(X, lambda_1, lambda_2);

clusters = ncutW(abs(Z) + abs(Z'), n_space);

elapsed_time = toc
predicted_labels = condense_clusters(clusters, 1);
the_nmi_value = FindNMI(labels', predicted_labels')
save('results_osc_lrr_dependent.mat', 'clusters', 'labels', 'predicted_labels', 'the_nmi_value', 'elapsed_time');
figure, imagesc(predicted_labels);

figure, imagesc(final_clusters);

rmpath(paths);
