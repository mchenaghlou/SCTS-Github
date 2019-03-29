clear all


% KDDCUP 99
fileName = './../Data/DataSets-Realworld-Subspace/kdd-cup-99/kddcup.data_10_percent-big/matlab.data_10_percent_corrected.csv';
dataset = csvread(fileName)';
D = size(dataset, 1);
% dataset = unique(dataset','rows','stable')';
% plot3(dataset(1, :), dataset(2, :), dataset(3, :), '.')
fileName = './../Data/DataSets-Realworld-Subspace/kdd-cup-99/labels.csv';
labels = csvread(fileName)';
unique(labels)

[basis, ClusterIndexes, newenergy, iter]=kmcl1sd(dataset',ones(1, length(unique(labels))).*randi(5, 1, length(unique(labels))),0.0001,100000,2,1);   
milad = 1;

ClusterIndexes = reconstruct_single_label_sequence(ClusterIndexes);
conf_mat = confusionmat(labels, ClusterIndexes);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)
FindNMI(ClusterIndexes', labels)

% confusion.getMatrix(labels, ClusterIndexes)
plot(1:length(dataset), ClusterIndexes, '.')
hold on
plot(1:length(dataset), labels, '*')