% Experiments of SSC algorithm on SMALL datasets

% 1: Multi-cluster subspaces
clearvars
fileName = sprintf('./dataset_small-Dim%s-multi-cluster', num2str(1000));
load(fileName);
A = dataset;

just_ssc


% 2: Overlapping clusters in dependent subspaces
clearvars
fileName = sprintf('./dataset_small-Dim%s-dependent', num2str(1000));
load(fileName);
A = dataset;

just_ssc


% Experiments of SSC algorithm on LARGE datasets

% 1: Multi-cluster subspaces
clearvars
fileName = sprintf('./dataset_large-Dim%s-multi-cluster', num2str(1000));
load(fileName);
A = dataset;

just_ssc


% 2: Overlapping clusters in dependent subspaces
clearvars
fileName = sprintf('./dataset_large-Dim%s-dependent', num2str(1000));
load(fileName);
A = dataset;

just_ssc