paths = ['common:', genpath('libs'), 'ssc:'];
addpath(paths);

% KDDCUP 99
fileName = './../Data/DataSets-Realworld-Subspace/kdd-cup-99/kddcup.data_10_percent-big/matlab.data_10_percent_corrected.csv';
dataset = csvread(fileName)';
D = size(dataset, 1);
% dataset = unique(dataset','rows','stable')';
% plot3(dataset(1, :), dataset(2, :), dataset(3, :), '.')
fileName = './../Data/DataSets-Realworld-Subspace/kdd-cup-99/labels.csv';
labels = csvread(fileName)';
[~,~,labels_names] = xlsread('./../Data/DataSets-Realworld-Subspace/kdd-cup-99/kddcup.data_10_percent-big/labels.xlsx');


Z = ssc_relaxed(dataset, 0.01);

clusters = ncutW(abs(Z) + abs(Z'), n_space);

final_clusters = condense_clusters(clusters, 1);

figure, imagesc(final_clusters);

rmpath(paths);