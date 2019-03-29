
% paths = ['SubKit-master\common:', genpath('libs'), 'lrr:'];
% addpath(paths);



n_space = length(unique(labels));
corruption = 0;
N = randn(size(A)) * corruption;
A = A + N;
A = normalize(A')';

lambda = 0.01;
tic
Z = lrr_relaxed(A,lambda);
imagesc(Z);
clusters = ncutW(abs(Z) + abs(Z'), n_space);
elapsed_time = toc
predicted_labels = condense_clusters(clusters, 1);

the_nmi_value = FindNMI(labels', predicted_labels')

conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)


