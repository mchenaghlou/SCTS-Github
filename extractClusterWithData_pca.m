function [ init_cluster , basis, coeff, score,latent, ex] = extractClusterWithData_pca( tdataset, sample_size, pc_threshold, basis)
%EXTRACTCLUSTERWITHDATA Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
% Calculate the row reduced form of the buffer
% what = rref(tdataset');
% what( ~any(what,2), : ) = [];  %rows

    [coeff, score, latent, ~, ex] = pca(tdataset');
    basis = coeff(:, getPCthatCoversThreshold(ex, pc_threshold))';
end
% This is the high-demensional representation of the basis of the
% subspace. It will be used to transform the high-dimensional data
% to low-dimensional representation.
% basis = what;


% Calculate the rank (dimension) of the subspace by calculating the
% rank of the high-dimensional representation of the basis.

tempDataset = tdataset(:, 2:end);
%         plot(tempDataset(:, 1), tempDataset (:, 2), '.');


% Find the low-dimensional representation of the data points with
% the help of the high-dimensional representation of the basis.
lowRepData = findLowDimRep(tempDataset, basis);
% lowRepData = score(:, ex>1)';

% plot(lowRepData(1, :), lowRepData(2, :), '.');
cov_mat = cov(lowRepData');
inv_cov = inv(cov_mat);

m = mean(lowRepData')';
init_cluster.mean =  m;
init_cluster.chr_mat = inv_cov;
init_cluster.num_of_members = sample_size - 1;
init_cluster.last_update = sample_size;
init_cluster.alpha = sample_size;
init_cluster.beta = sample_size;

% hold on
% % aff_vector = affineVector{activeClusterIdentifier.subspaceIndex, activeClusterIdentifier.clusterIndex};
% Ellipse_Plot_subspace(inv_cov, m, 1,'k', '-',2, 1, basis, aff_vector)


end

