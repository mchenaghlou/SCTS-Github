

tic
[predicted_labels ~] = seqksubspaces(A' ,floor(mean(dim)), 0.95, 20);
elapsed_time = toc
[predicted_labels,  ~] = ReconstructLabels( predicted_labels,  labels)
the_nmi_value = FindNMI(labels', predicted_labels')
% the_ari_value = FindARI(labels', predicted_labels')
the_ari_value = 0;
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)

