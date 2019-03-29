% Demo of TSC (Temporal Subspace Clustering) on Keck dataset
%
% Author: Sheng Li (shengli@ece.neu.edu)
%
% Sheng Li, Kang Li, Yun Fu: Temporal Subspace Clustering for Human Motion 
% Segmentation. ICCV 2015: 4453-4461. 


% clear all;
% rand('state',123);

%%%---Load the data set---%%%
% load('Data/P1_HIS.mat');

% paths = genpath('Codes/');
% addpath(paths);

%%%---Normalize the data---%%%
% X = normalize(feature);



% fileName = sprintf('./../Data/DataSets-Synthetic-Subspace/dataset-Dim%s-dim%sAnomRate%s-singlecluster', num2str(100), num2str(2), num2str(100*0));
% load(fileName);
% X = dataset(1:100, :);
% label = dataset(101, :);

%%%---Parameter settings---%%%
paras = [];
paras.lambda1 = 0.01;
paras.lambda2 = 15;
paras.n_d = 80;
paras.ksize = length(unique(labels));
paras.tol = 1e-4;
paras.maxIter = 12;
paras.stepsize = 0.1;

%%%---Learn representations Z---%%%
tic
[D, Z, err] = TSC_ADMM(A,paras);

disp('Segmentation...');
%%%---Graph construction and segmentation---%%%
nbCluster = length(unique(labels));
vecNorm = sum(Z.^2);
W2 = (Z'*Z) ./ (vecNorm'*vecNorm + 1e-6);
[oscclusters,~,~] = ncutW(W2,nbCluster);
predicted_labels = denseSeg(oscclusters, 1);
elapsed_time = toc

% accuracy = compacc(clusters, label);
the_nmi_value = FindNMI(labels', predicted_labels')
% the_ari_value = FindARI(labels', predicted_labels')
the_ari_value = 0
conf_mat = confusionmat(labels, predicted_labels);
nc = sum(conf_mat,1);
mc = max(conf_mat,[],1);
purity = sum(mc(nc>0))/sum(nc)

