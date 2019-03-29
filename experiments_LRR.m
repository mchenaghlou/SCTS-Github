% Experiments of LRR algorithm on small datasets

% 1: Multi-cluster subspaces
clearvars
fileName = sprintf('./dataset_small-Dim%s-multi-cluster', num2str(1000));
load(fileName);
A = dataset;

just_lrr


% 2: Overlapping clusters in dependent subspaces
clearvars
fileName = sprintf('./dataset_small-Dim%s-dependent', num2str(1000));
load(fileName);
A = dataset;

just_lrr



% Experiments of LRR algorithm on LARGE datasets

% 1: Multi-cluster subspaces
clearvars
fileName = sprintf('./dataset_large-Dim%s-multi-cluster', num2str(1000));
load(fileName);
A = dataset;

just_lrr


% 2: Overlapping clusters in dependent subspaces
clearvars
fileName = sprintf('./dataset_large-Dim%s-dependent', num2str(1000));
load(fileName);
A = dataset;

just_lrr