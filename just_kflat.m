

tic
% [basis predicted_labels newenergy iter]=kmcl1sd(A',[dim(2), dependent_dims(1), dependent_dims(2), dim(1), dependent_dims(1), dependent_dims(2)],0.001,100,0,1);   
[basis predicted_labels newenergy iter]=kmcl1sd(A',dim,0.01,1000,2,1);   
elapsed_time = toc
[predicted_labels,  ~] = ReconstructLabels( predicted_labels,  labels)
the_nmi_value = FindNMI(labels', predicted_labels')
% the_ari_value = FindARI(labels', predicted_labels')
the_ari_value = 0;
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)


% save('results_kflat_multi_cluster.mat', 'labels', 'predicted_labels', 'the_nmi_value', 'the_ari_value', 'purity','elapsed_time');
% save('results_kflat_dependent_subspaces.mat', 'labels', 'predicted_labels', 'the_nmi_value', 'the_ari_value', 'purity','elapsed_time');
% rmpath(paths);
