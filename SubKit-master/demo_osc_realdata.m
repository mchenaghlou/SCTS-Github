paths = ['common:', genpath('libs'), 'osc:'];
addpath(paths);

% KDDCUP 99
fileName = './../Data/DataSets-Realworld-Subspace/kdd-cup-99/kddcup.data_10_percent-big/matlab.data_10_percent_corrected.csv';
dataset = csvread(fileName)';
D = size(dataset, 1);
% dataset = unique(dataset','rows','stable')';
% plot3(dataset(1, :), dataset(2, :), dataset(3, :), '.')
fileName = './../Data/DataSets-Realworld-Subspace/kdd-cup-99/labels.csv';
labels = csvread(fileName)';

[dataset,duplicate_indices] = unique(dataset','rows','stable');
dataset = dataset';
labels = labels(duplicate_indices);

dataset = normalize(dataset')';


m = 0.1;
v = 0.001;


lambda_1 = 0.099;
lambda_2 = 0.001;
Z = osc_relaxed(dataset(:, 1:10000), lambda_1, lambda_2);

clusters = ncutW(abs(Z) + abs(Z'), D);

final_clusters = condense_clusters(clusters, 1);

figure, imagesc(final_clusters);

rmpath(paths);