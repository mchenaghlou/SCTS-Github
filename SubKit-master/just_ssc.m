
paths = ['common:', genpath('libs'), 'ssc:'];
addpath(paths);


A = normalize(A')';
n_space = length(unique(labels));
corruption = 0;

N = randn(size(A)) * corruption;
X = A + N;
X = normalize(X);
tic
Z = ssc_relaxed(X, 0.01);
clusters = ncutW(abs(Z) + abs(Z'), n_space);
elapsed_time = toc
predicted_labels = condense_clusters(clusters, 1);
the_nmi_value = FindNMI(labels', predicted_labels')
% the_ari_value = FindARI(labels', predicted_labels')
the_ari_value = 0;
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)

% save('results_ssc_multi_cluster.mat', 'clusters', 'labels', 'predicted_labels', 'the_nmi_value', 'the_ari_value', 'purity','elapsed_time');
% save('results_ssc_dependent_subspaces.mat', 'clusters', 'labels', 'predicted_labels', 'the_nmi_value', 'the_ari_value', 'purity','elapsed_time');


rmpath(paths);
