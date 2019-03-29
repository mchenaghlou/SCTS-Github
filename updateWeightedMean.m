function [ curr_cluster ] = updateWeightedMean( curr_cluster, curr_ob, w )
%UPDATEWEIGHTEDMEAN Summary of this function goes here
%   Detailed explanation goes here
try
    curr_cluster.mean = (curr_cluster.mean) + (double(w)/ double(curr_cluster.beta + w)) * (curr_ob - curr_cluster.mean);
%     curr_cluster.mean = (curr_cluster.mean) + (double(w)/ double(curr_cluster.alpha + w)) * (curr_ob - curr_cluster.mean);
catch ME
   milad = 1; 
end
end

