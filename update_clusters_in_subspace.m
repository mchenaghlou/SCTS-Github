function [A, space_tracker,ClusterIndexes, ellipse_handles] = ...
    update_clusters_in_subspace( A, i, cur_ob,  space_tracker, cluster_boundary, ClusterIndexes,video, ellipse_handles)
%UPDATE_CLUSTERS_IN_SUBSPACE Summary of this function goes here
%   Detailed explanation goes here
translated_cur_ob = cur_ob - space_tracker.aff_vec;


%%% Here, Find the cluster in the current subspace and update it.
lowRepData = findLowDimRep(translated_cur_ob, space_tracker.basis_);
k = 1;
mahal_dists = [];
member_clusters = [];
while k <= length(space_tracker.clusters)
    clus = space_tracker.clusters(k);
    
    if length(lowRepData) > 1
        milad = 1;
    end
    mahal_dist = FindDistance(lowRepData', clus.chr_mat', clus.mean');
    if mahal_dist < 0
        milad = 1;
    end
    % Check if observation belongs to the active cluster.
    if mahal_dist <= chi2inv(cluster_boundary, rank(space_tracker.basis_))
        % Update the cluster. (Possible several clusters.)
        A(i) = 1;
        member_clusters = [member_clusters, k];
        mahal_dists = [mahal_dists, mahal_dist];
    end
    k = k + 1;
end

if isempty(mahal_dists)
    A(i) = 0;
    ClusterIndexes(i) = 0;
    %             space_tracker = [];

    % Here, the observation is in the same subspace as the active
    % cluster, but it is not in the boundary. There are two cases:
    % 1: It is an anomaly in the subspace
    % 2: It is a new cluster in the subspace
    
else
    [~, closest_cluster_idx] = min(mahal_dists);
    ClusterIndexes(i) = space_tracker.clusters(member_clusters(closest_cluster_idx)).id;
    mahal_dists = 1 ./ mahal_dists;
    
    sumOfWeights = sum(mahal_dists);
    weights = mahal_dists ./ sumOfWeights;
    [~, max_idx] = max(weights);
    
    % %               let's implement labelling later
    %                 subs_space.clusters(max_idx)
    %                 clus_ind = SubspaceClusterSet{activeSubspaceIndex}{member_clusters(max_idx)}.id;
    %                 ClusterIndexes(i) = clus_ind;
    
    k = 1;
    space_tracker.clusters(max_idx).members = [space_tracker.clusters(max_idx).members, i];
    while k <= length(member_clusters)
        
        try
            
            %                         SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)} = updateWeightedMean(  SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}, lowRepData, weights(k));
            %                         SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)} = updateWeightedChrMat(SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}, lowRepData', weights(k));
            space_tracker.clusters(member_clusters(k)) = updateWeightedMean(space_tracker.clusters(member_clusters(k)), lowRepData, weights(k));
            %                     means_temp(member_clusters(k), i) = cur_sub_space.clusters(member_clusters(k)).mean;
            space_tracker.clusters(member_clusters(k)) = updateWeightedChrMat_subspace(space_tracker.clusters(member_clusters(k)), lowRepData, weights(k));
            
            %                         SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}.alpha = int64(SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}.alpha) + int64(weights(k).^2);
            %                         SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}.beta =  int64(SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}.beta) + int64(weights(k));
            space_tracker.clusters(member_clusters(k)).alpha = int64(space_tracker.clusters(member_clusters(k)).alpha) + int64(weights(k));
            space_tracker.clusters(member_clusters(k)).beta =  int64(space_tracker.clusters(member_clusters(k)).beta) + int64(weights(k).^2);
            
            %                         SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}.last_update = i;
            %                         SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}.num_of_members = SubspaceClusterSet{activeSubspaceIndex}{member_clusters(k)}.num_of_members + 1;
            space_tracker.clusters(member_clusters(k)).last_update = i;
            space_tracker.clusters(member_clusters(k)).num_of_members = space_tracker.clusters(member_clusters(k)).num_of_members + 1;
            
        catch ME
            ME
        end
        
        
        if video == true && size(space_tracker.clusters(member_clusters(k)).chr_mat, 1) > 1
            delete(ellipse_handles{space_tracker.clusters(member_clusters(k)).id}{member_clusters(k)}{1});
            delete(ellipse_handles{space_tracker.clusters(member_clusters(k)).id}{member_clusters(k)}{2});
            
            fig = Ellipse_Plot_subspace(space_tracker.clusters(member_clusters(k)).chr_mat, ...
                space_tracker.clusters(member_clusters(k)).mean, 1,'k', '-',2, 1, ...
                space_tracker.basis_, space_tracker.aff_vec);
            drawnow
            ellipse_handles{space_tracker.clusters(member_clusters(k)).id}{member_clusters(k)} = {fig{1}, fig{2}};
            
        end
        k = k + 1;
    end
end

end

