%==========================================================================
% Author: Milad Chenaghlou
% Created: 2017-02-02
% Incremental clustering method
%
%==========================================================================

function [AllSubspaces, ClusterIndexes] = SubOnCAD_pca( dataset, D , principal_component_threshold, video, cluster_boundary, subspace_angle_threshold, labels)
%ONLINEANOMALYDETECTOR Summary of this function goes here
%   Detailed explanation goes here

ellipse_handles = {};
if video == true
    clf
    hold on
    myPathVid = './3.SubOnCAD/SubspaceClustering_test1.avi';
    vidObj = VideoWriter(myPathVid);
    vidObj.Quality = 25;
    ellipse_handle_counter = -1;
    ellipse_handles = {};
    open(vidObj);
end


% Size of dataset
dataset_size = size(dataset,2);

alpha = 0.05;
conf_region_radius = 0.05;
% % Number of observations for each cluster.
means_distance = chi2inv(conf_region_radius, 20);
buffer_length = MultiVariateNormalSampleSize(alpha, 20, means_distance);
buffer_length = 20;
sample_size = 20;
conf_subspace_size = 40;

getSampleSize(conf_region_radius, alpha, 10);


%-------------------------------------------
% Initialize indexes

ClusterIndexes = ones(1, dataset_size) * -1;
% Anomalous Indexes
A = ones(1,dataset_size) * (-1);

i = buffer_length; % Index of emerging cluster identification cell
j = 1; % Index of scoring cell

% init space tracker
aff_vec = dataset(1:D, 1);


space_tracker.basis_ = [];
% sub_space.weights = [];
% sub_space.variances = [];

AllSubspaces = [];

[cluster, basis_, coeff, score,latent, ex] = extractClusterWithData_pca(dataset(1:D, j:i) - aff_vec, i, principal_component_threshold);
space_tracker.basis_ = basis_;
space_tracker.full_basis = coeff';
space_tracker.size = i;
space_tracker.members = j:i;
space_tracker.captured = true;
space_tracker.subspace_idx = 1;

% sub_space.weights = ex;
% sub_space.variances = latent;
cluster.id = 1;
cluster.members = j:i;
space_tracker.clusters = (cluster);
space_tracker.aff_vec = aff_vec;
AllSubspaces = [AllSubspaces, space_tracker];

A(j:i) = 1;

% we track the number of clusters form labelling data points.
num_of_clusters = 1;

if video == true
    plot3(dataset(1, 1:i), dataset(2, 1:i), dataset(3, 1:i), '.');
    fig = Ellipse_Plot_subspace(space_tracker.clusters(1).chr_mat, ...
        space_tracker.clusters(1).mean, 1,'k', '-',2, 1, ...
        space_tracker.basis_, space_tracker.aff_vec);
    
    ellipse_handles{1}{1} = {fig{1}, fig{2}};
    
end

confident_cluster_confidence_region = 0.1;

ClusterIndexes(j:i) = 1;

zero_dim_subspaces = [];
cur_window_basis = space_tracker.basis_;
warning('off','stats:pca:ColRankDefX')
while i < dataset_size
    if rem(i,5000) == 0
        i
    end
    if j > 100 && sum(ClusterIndexes(j-10:j-1) == -1) > 0
        milad = 1;
    end
    i = i + 1;
    j = j + 1;
    
    if j == 149854
        milad = 1;
    end
    
    cur_ob = dataset(1:D, i);
    if isequal(cur_ob, dataset(1:D, i-1))
        %         A(i) = 2;
        %         ClusterIndexes(i) = ClusterIndexes(i-1);
        %         continue
        milad = 1;
    end
    if video == true
        plot3(cur_ob(1, :), cur_ob(2, :), cur_ob(3, :), '.')
    end
    
    %% Update cell operations.
    
    % we need the incremental pca over windows to identify subspaces within
    % subspaces.
    %     current_window_inds = [find(A(j:i-1) == 1)+j-1, i];
    current_window_inds = j:i;
    
    go_to_check_cell = false;
    
    if length(current_window_inds) < buffer_length/2
        A(i) = 2;
        %         ClusterIndexes(i) = 0
        %         continue;
    else
        [coeff, ~, ~, ~, ex] = pca((dataset(1:D, current_window_inds) - aff_vec)');
        
        
        if isnan(ex(1))
            been_seen = false;
            for i_temp = 1:length(zero_dim_subspaces)
                if sum(dataset(1:D, i) == AllSubspaces(zero_dim_subspaces(i_temp)).aff_vec) == length(dataset(1:D, i))
                    AllSubspaces(zero_dim_subspaces(i_temp)).size = AllSubspaces(zero_dim_subspaces(i_temp)).size + 1;
                    AllSubspaces(zero_dim_subspaces(i_temp)).members = [AllSubspaces(zero_dim_subspaces(i_temp)).members, i];
                    A(i) = 1;
                    ClusterIndexes(i) = ClusterIndexes(AllSubspaces(zero_dim_subspaces(i_temp)).members(1));
                    been_seen = true;
                    break;
                end
            end
            if been_seen
                go_to_check_cell = true;
                %                 continue;
            else
                milad = 1;
                zero_dim_space.basis_ = [];
                zero_dim_space.full_basis = coeff;
                zero_dim_space.size = length(current_window_inds);
                zero_dim_space.members = current_window_inds;
                zero_dim_space.captured = true;
                zero_dim_space.subspace_idx = length(AllSubspaces) + 1;
                zero_dim_space.clusters = [];
                zero_dim_space.aff_vec = dataset(1:D, j);
                zero_dim_subspaces = [zero_dim_subspaces, zero_dim_space.subspace_idx];
                AllSubspaces = [AllSubspaces, zero_dim_space];
                A(j:i) = 1;
                ClusterIndexes(i) = max(ClusterIndexes) + 1;
                go_to_check_cell = true;
            end
            
            
            %             continue;
        end
        cur_window_basis = coeff(:, getPCthatCoversThreshold(ex, principal_component_threshold))';
        
        
        % the rank (dimension) of the current window subspace
        current_window_rank = size(cur_window_basis, 1);
        if current_window_rank == 0
            milad = 1;
        end
        
        %   the angle between the basis of the space tracker and the current window
        %   subspace. The problem with the angles is that when the number of dimensions
        %   increases the angle also increases. why?
        cur_angle_dist = subspace(space_tracker.basis_', cur_window_basis');
        %     cur_angle_dist_from_obs = subspace(cur_ob, space_tracker.basis_');
        
        %         % the distance from observation to subspace
        %         %     cur_dist = getDistanceFromObservationToSubspace(cur_ob, space_tracker.basis_');
        %         cur_dist = norm(cur_ob) * sin(subspace(space_tracker.basis_', cur_ob));
        %         obs_from_subspace_dist_threshold = norm(cur_ob) * sin(subspace_angle_threshold);
        %         % this means that the observation is not in the current subspace
        %         if cur_dist > obs_from_subspace_dist_threshold
        %             milad = 1;
        %         end
        
        %         obs_from_subspace_dist_threshold = norm(cur_ob) * sin(subspace_angle_threshold);
        %         cur_angle_dist_from_obs = norm(cur_ob) * sin(subspace(cur_window_basis', cur_ob));
        %         if  cur_angle_dist_from_obs > obs_from_subspace_dist_threshold
        %             A(i) = 2;
        %             continue;
        %         end
        
        %         [coeff_temp, score_temp, latent_temp, ~, ex_temp] = pca(dataset(:, [all_subspaces(1).clusters(1).members])');
        %         basis_temp = coeff(:, getPCthatCoversThreshold(ex_temp, 99))';
        %         if(size(basis_temp, 1) > 2)
        %             milad = 1;
        %         end
        
        % the window subspace and the space_tracker subspace are definitely the
        % same.
        if go_to_check_cell == false
            if current_window_rank == size(space_tracker.basis_, 1) && ...
                    cur_angle_dist <= subspace_angle_threshold
                
                space_tracker.size = space_tracker.size + 1;
                space_tracker.members = [space_tracker.members, i];
                % capture the space_tracker if it has a large size and it has not
                % been captured yet.
                %         if space_tracker.size > getSampleSize(confident_cluster_confidence_region, alpha, size(space_tracker.basis_, 1)) && space_tracker.captured == false
                if space_tracker.size > conf_subspace_size && space_tracker.captured == false
                    AllSubspaces = [AllSubspaces, space_tracker];
                    space_tracker.captured = true;
                    %                 ClusterIndexes()
                end
                [A, space_tracker,ClusterIndexes, ellipse_handles] = update_clusters_in_subspace(A, i, cur_ob, space_tracker, cluster_boundary, ClusterIndexes, video, ellipse_handles);
                
                
                % the dimensions of subspaces are the same, but in different angles.
            elseif current_window_rank == size(space_tracker.basis_, 1) && ...
                    cur_angle_dist > subspace_angle_threshold
                
                A(i) = 2;
                %          A(j:i) = 2;
                % probably there is a suspace within another subspace,
            elseif current_window_rank ~= size(space_tracker.basis_, 1) && ...
                    cur_angle_dist <= subspace_angle_threshold
                
                milad = 1;
                A(i) = 2;
                %         A(j:i) = 2;
                % do we get here?! Yes, we are in a new subspace!
            elseif current_window_rank ~= size(space_tracker.basis_, 1) && ...
                    cur_angle_dist > subspace_angle_threshold
                A(i) = 2;
                %         A(j:i) = 2;
                milad = 1;
            end
            
        end
    end
    
    %     if cur_angle_dist_from_obs < subspace_angle_threshold
    % %     if cur_dist < 5
    %
    %             % Update the clusters in the space_tracker
    %             space_tracker.size = space_tracker.size + 1;
    %
    %             % capture the space_tracker if it has a large size and it has not
    %             % been captured yet.
    % %             if space_tracker.size > getSampleSize(confident_cluster_confidence_region, alpha, size(space_tracker.basis_, 1)) && space_tracker.captured == false
    %             if space_tracker.size > size(space_tracker.basis_, 1) + 300 && space_tracker.captured == false
    %                 all_subspaces = [all_subspaces, space_tracker];
    %                 space_tracker.captured = true;
    %             end
    %
    %             [A, space_tracker,ClusterIndexes, ellipse_handles] = update_clusters_in_subspace(A, i, cur_ob, space_tracker, cluster_boundary, ClusterIndexes, video, ellipse_handles);
    % %         end
    %     else
    %         % In the update cell operations, the new observation is in another
    %         % subspace.
    %         A(i) = 2;
    %     end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CheckCell Operations
    % If the observation is not assigned to any clusters, get the 0s
    % from the buffer and see if they are a cluster.
    
    if A(j) == 0
        the_zeros_inds = find(A(j+1:i-1) == 0);
        if ~isempty(the_zeros_inds) && min(the_zeros_inds) < 2
            
            % 1. Do clustering over observations not assigned to any state-tracker
            %         A(j:i-1)
            free_inds_same_subspace = find(A(j:i) == 0) + j - 1;
            %             if length(free_inds_same_subspace) >= getSampleSize(0.5, alpha, 50)
            if length(free_inds_same_subspace) >= sample_size
                space_tracker.size = space_tracker.size + 1;
                frees = dataset(1:D, free_inds_same_subspace);
                aff_vec = space_tracker.aff_vec;
                [cluster, ~]= extractClusterWithData_pca(frees - aff_vec, length(free_inds_same_subspace), principal_component_threshold, space_tracker.basis_);
                num_of_clusters = num_of_clusters + 1;
                cluster.id = num_of_clusters;
                cluster.members = free_inds_same_subspace;
                if video == true
                    fig = Ellipse_Plot_subspace(cluster.chr_mat, cluster.mean, 1,'k', '-',2, 1, ...
                        space_tracker.basis_, aff_vec);
                    ellipse_handles{space_tracker.subspace_idx}{length(space_tracker.clusters) + 1} = fig;
                end
                ClusterIndexes(free_inds_same_subspace) = cluster.id;
                space_tracker.clusters = [space_tracker.clusters, cluster];
                A(free_inds_same_subspace) = 1;
            else
                ClusterIndexes(j) = 0;
            end
        else
            ClusterIndexes(j) = 0;
        end
    end
    
    if A(j) == 2
        the_two_inds = find(A(j+1:i-1) == 2);
        if ~isempty(the_two_inds) && min(the_two_inds) < 2
            free_inds_other_subspace = find(A(j:i) == 2) + j - 1;
            frees = dataset(1:D, free_inds_other_subspace);
            aff_vec = frees(:, 1);
            [cluster, cur_window_basis, coeff]= extractClusterWithData_pca(frees - aff_vec, length(free_inds_other_subspace), principal_component_threshold);
            
            % search, maybe the cur_window space has been modelled in
            % all_subspaces.
            
            %             if length(free_inds_other_subspace) >= getSampleSize(0.5, alpha, 50)
            if length(free_inds_other_subspace) >= sample_size
                if length(AllSubspaces) == 6
                    milad = 1;
                end
                
                previously_captured = false;
                for i_temp2 = 1:length(AllSubspaces)
                    sub_space_i = AllSubspaces(i_temp2);
                    if isempty(sub_space_i.basis_)
                        continue;
                    end
                    % the window subspace and the space_tracker subspace are definitely the
                    % same.
                    cur_angle_dist = subspace(sub_space_i.basis_', cur_window_basis');
                    if current_window_rank == size(sub_space_i.basis_, 1) && ...
                            cur_angle_dist <= subspace_angle_threshold
                        previously_captured = true;
                        temp_size = length(free_inds_other_subspace) + sub_space_i.size;
                        space_tracker = sub_space_i;
                        space_tracker.size = temp_size;
                        space_tracker.members = [space_tracker.members, free_inds_other_subspace];
                        for i_temp = 1:length(current_window_inds)
                            i_ind = current_window_inds(i_temp);
                            cur_ob = dataset(:, i_ind);
                            [A, space_tracker,ClusterIndexes, ellipse_handles] = ...
                                update_clusters_in_subspace(A, i_ind, cur_ob, space_tracker, ...
                                cluster_boundary, ClusterIndexes, video, ellipse_handles);
                        end
                        break;
                    end
                end
                
                
                %             all_subspaces(space_tracker.subspace_idx) = space_tracker;
                if previously_captured == false
                    if space_tracker.captured == false
%                          num_of_clusters = num_of_clusters - 1;
%                         ClusterIndexes(space_tracker.members) = 0;
                    end
                    space_tracker = [];
                     
                    space_tracker.basis_ = cur_window_basis;
                    space_tracker.size = length(free_inds_other_subspace);
                    space_tracker.members = free_inds_other_subspace;
                    space_tracker.full_basis = coeff;
                    
                    space_tracker.captured = false;
                    space_tracker.subspace_idx = length(AllSubspaces) + 1;
                    
                    space_tracker.aff_vec = aff_vec;
                    cluster.members = free_inds_other_subspace;
                    num_of_clusters = num_of_clusters + 1;
                    cluster.id = num_of_clusters;
                    ClusterIndexes(free_inds_other_subspace) = cluster.id;
                    space_tracker.clusters = [cluster];
                    if video == true && size(cluster.chr_mat, 1) > 1
                        fig = Ellipse_Plot_subspace(cluster.chr_mat, cluster.mean, 1,'k', '-',2, 1, ...
                            basis, aff_vec);
                        ellipse_handles{space_tracker.clusters(1).id}{1} = fig;
                    end
                    
                    
                    
                    
                    %             all_subspaces = [all_subspaces, space_tracker];
                    
                    A(free_inds_other_subspace) = 1;
                end
                
            else
                ClusterIndexes(j) = 0;
            end
        else
            ClusterIndexes(j) = 0;
        end
    end
    
    if space_tracker.captured == true
        AllSubspaces(space_tracker.subspace_idx) = space_tracker;
    end
    
end
if video == true
    close(vidObj)
end

end

function [ sample_size ] = getSampleSize( conf_region_readius, alpha, D )
if D < 1
    sample_size = -1;
    return
end

means_distance = chi2inv(conf_region_readius, D);
sample_size = MultiVariateNormalSampleSize(alpha, D, means_distance);
end

function [dist_to_subspace] = getDistanceFromObservationToSubspace(cur_ob, basis_)
dist_to_subspace = norm(cur_ob) * sin(subspace(basis_, cur_ob));
end