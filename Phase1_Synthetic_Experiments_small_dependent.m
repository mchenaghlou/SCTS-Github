clearvars
addpath('./3.SubOnCAD/SubKit-master');



Dim = [1000];
% dim = randi(15, 1, 2);
dim = [6, 9];
dependent_dims = [3, 1; 5, 0];

%  [dataset, labels]  = SubspaceDatasetGeneratorFunc_dependent_small(Dim,dim, dependent_dims, 0);
% csv_filename = './../Data/DataSets-Synthetic-Subspace/dataset-Dim1000-AnomRate0-dependent.csv'
% csvwrite(csv_filename, dataset')
% csv_label_filename = './../Data/DataSets-Synthetic-Subspace/labels-Dim1000-AnomRate0-dependent.csv'
% csvwrite(csv_label_filename, labels)
% 

% 
fileName = sprintf('./dataset_small-Dim%s-AnomRate%s-dependent', num2str(1000), num2str(0));
load(fileName);
A = dataset;
% n_space = length(unique(labels));




%     
%  
% 
% 
% varsbefore = who; %// get names of current variables (note 1)   
%     just_lsr
% varsafter = []; %// initiallize so that this variable is seen by next 'who'
% varsnew = []; %// initiallize too.
% varsafter = who; %// get names of all variables in 'varsbefore' plus variables 
% varsnew = setdiff(varsafter, varsbefore); %// variables  defined in the script
% clear(varsnew{:}) %// (note 2)
%     
% 
% 
% 
%  varsbefore = who; %// get names of current variables (note 1)   
%     just_osc
% varsafter = []; %// initiallize so that this variable is seen by next 'who'
% varsnew = []; %// initiallize too.
% varsafter = who; %// get names of all variables in 'varsbefore' plus variables 
% varsnew = setdiff(varsafter, varsbefore); %// variables  defined in the script
% clear(varsnew{:}) %// (note 2)
%     
%  
% 
% varsbefore = who; %// get names of current variables (note 1)   
%     just_ssc
% varsafter = []; %// initiallize so that this variable is seen by next 'who'
% varsnew = []; %// initiallize too.
% varsafter = who; %// get names of all variables in 'varsbefore' plus variables 
% varsnew = setdiff(varsafter, varsbefore); %// variables  defined in the script
% clear(varsnew{:}) %// (note 2)
%  
% addpath('./3.SubOnCAD/MKFlat');
% varsbefore = who; %// get names of current variables (note 1)   
%     just_kflat
% varsafter = []; %// initiallize so that this variable is seen by next 'who'
% varsnew = []; %// initiallize too.
% varsafter = who; %// get names of all variables in 'varsbefore' plus variables 
% varsnew = setdiff(varsafter, varsbefore); %// variables  defined in the script
% clear(varsnew{:}) %// (note 2)
% rmpath('./3.SubOnCAD/MKFlat');
% % 
% addpath('./3.SubOnCAD/KSubspaces');
% varsbefore = who; %// get names of current variables (note 1)   
%     just_ksubspaces
% varsafter = []; %// initiallize so that this variable is seen by next 'who'
% varsnew = []; %// initiallize too.
% varsafter = who; %// get names of all variables in 'varsbefore' plus variables 
% varsnew = setdiff(varsafter, varsbefore); %// variables  defined in the script
% clear(varsnew{:}) %// (note 2)
% rmpath('./3.SubOnCAD/KSubspaces');
% % 
% 
% 
% addpath('./3.SubOnCAD/SubKit-master/TSC');
% varsbefore = who; %// get names of current variables (note 1)   
%     Demo_Keck_milad
% varsafter = []; %// initiallize so that this variable is seen by next 'who'
% varsnew = []; %// initiallize too.
% varsafter = who; %// get names of all variables in 'varsbefore' plus variables 
% varsnew = setdiff(varsafter, varsbefore); %// variables  defined in the script
% clear(varsnew{:}) %// (note 2)



D = 1000;
video = 0;
subspace_angle_threshold = 0.2 ;
cluster_boundary = 0.99;
principal_component_threshold = 99;
tic
[ AllSubspaces, predicted_labels] = SubOnCAD_pca( A(1:D, :), D , ...
    principal_component_threshold, video,  cluster_boundary, subspace_angle_threshold, labels);
elapsed_time = toc
predicted_labels = predicted_labels + 1;
the_nmi_value = FindNMI(labels', predicted_labels)

the_ari_value = 0;
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)

plotClusters(predicted_labels);
plotClusters(labels);

% save('results_proposed_method_multi_cluster.mat', 'labels', 'predicted_labels', 'the_nmi_value', 'the_ari_value', 'purity','elapsed_time');
% save('results_proposed_method_dependent_subspaces.mat', 'labels', 'predicted_labels', 'the_nmi_value', 'the_ari_value', 'purity','elapsed_time');
