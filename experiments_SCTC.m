% Experiments of SSC algorithm on SMALL datasets

% 1: Multi-cluster subspaces
clearvars
fileName = sprintf('./dataset_small-Dim%s-multi-cluster', num2str(1000));
load(fileName);
A = dataset;


D = 1000;
subspace_angle_threshold = 0.2 ;
cluster_boundary = 0.99;
principal_component_threshold = 99;
tic
[ AllSubspaces, predicted_labels] = SCTC( A(1:D, :), D , ...
    principal_component_threshold, 0,  cluster_boundary, subspace_angle_threshold, labels);
elapsed_time = toc
predicted_labels = predicted_labels + 1;
the_nmi_value = FindNMI(labels', predicted_labels)

the_ari_value = 0;
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)





% 2: Overlapping clusters in dependent subspaces
clearvars
fileName = sprintf('./dataset_small-Dim%s-dependent', num2str(1000));
load(fileName);
A = dataset;

D = 1000;
subspace_angle_threshold = 0.2 ;
cluster_boundary = 0.99;
principal_component_threshold = 99;
tic
[ AllSubspaces, predicted_labels] = SCTC( A(1:D, :), D , ...
    principal_component_threshold, 0,  cluster_boundary, subspace_angle_threshold, labels);
elapsed_time = toc
predicted_labels = predicted_labels + 1;
the_nmi_value = FindNMI(labels', predicted_labels)

the_ari_value = 0;
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)



% Experiments of SSC algorithm on LARGE datasets

% 1: Multi-cluster subspaces
clearvars
fileName = sprintf('./dataset_large-Dim%s-multi-cluster', num2str(1000));
load(fileName);
A = dataset;

D = 1000;
subspace_angle_threshold = 0.2 ;
cluster_boundary = 0.99;
principal_component_threshold = 99;
tic
[ AllSubspaces, predicted_labels] = SCTC( A(1:D, :), D , ...
    principal_component_threshold, 0,  cluster_boundary, subspace_angle_threshold, labels);
elapsed_time = toc
predicted_labels = predicted_labels + 1;
the_nmi_value = FindNMI(labels', predicted_labels)

the_ari_value = 0;
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)



% 2: Overlapping clusters in dependent subspaces
clearvars
fileName = sprintf('./dataset_large-Dim%s-dependent', num2str(1000));
load(fileName);
A = dataset;

D = 1000;
subspace_angle_threshold = 0.2 ;
cluster_boundary = 0.99;
principal_component_threshold = 99;
tic
[ AllSubspaces, predicted_labels] = SCTC( A(1:D, :), D , ...
    principal_component_threshold, 0,  cluster_boundary, subspace_angle_threshold, labels);
elapsed_time = toc
predicted_labels = predicted_labels + 1;
the_nmi_value = FindNMI(labels', predicted_labels)

the_ari_value = 0;
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)
