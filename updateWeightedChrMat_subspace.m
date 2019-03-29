function [ curr_cluster ] = updateWeightedChrMat_subspace( curr_cluster, curr_ob, w)
%UPDATEWEIGHTEDCHRMAT Summary of this function goes here
%   Detailed explanation goes here
% weights parameter is to be implemented



sK_1 = curr_cluster.chr_mat;
mK = curr_cluster.mean;

betaK = int64(curr_cluster.beta);
betaKplus1 = betaK + w;
alphaK = int64(curr_cluster.alpha);
alphaKplus1 = alphaK + w^2;

beta_alpha_difference = (int64(betaKplus1.^2) - int64(alphaKplus1));
khi_enum = int64(betaK) .* int64(beta_alpha_difference);
khi_denom = int64(betaKplus1) * (int64(betaK.^2) - int64(alphaK));
khiK = double(khi_enum) / double(khi_denom);


delta_enum  = int64(betaKplus1) * int64(betaK .^2 - alphaK);
delta_denom = int64(betaK) * w * int64((betaKplus1 + w -2));
delta = double(delta_enum) / double(delta_denom);


enumerator = ((sK_1 * (curr_ob - mK)) * ((curr_ob - mK)' * sK_1));
denominator = (delta + ((curr_ob - mK)' * sK_1 * (curr_ob - mK)));
new_sn_1 = khiK * (sK_1  - enumerator/denominator);
curr_cluster.chr_mat = new_sn_1;
end

