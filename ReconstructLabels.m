function [ c,s ] = ReconstructLabels( Clusters,  S, labelSinglesAsAnomalies)
%RECONSTRUCTLABELS Summary of this function goes here
%   Detailed explanation goes here

% X = Clusters;

% % This part seems to be labelling single labels as anomalies.
% if labelSinglesAsAnomalies == true
%     hi = histcounts(X, numel(unique(X)));
%     singles = find(hi==1);
%     inds = ismember(X,singles);
%     X(find(inds)) = 0;
% end

if ismember(0,Clusters)
    Clusters(:) = Clusters(:) + 1;
end

c = reconstruct_single_label_sequence(Clusters);

if ismember(0,S)
    S(:) = S(:) + 1;
end
s = reconstruct_single_label_sequence(S);



% c = Clusters;
% t=unique(c);
% 
% for i = 1:max(t)
%     if ismember(i, t) == false
%         c = sortClusterLabels(c, i, t);
%     end
% end
% 
% tc=unique(c);
% k=numel(tc);
% c(c==0) = k;
% % t=unique(c);
% 
% s = S;
% ts=unique(s);
% for i = 1:max(ts)
%     if ismember(i, ts) == false
%         s = sortClusterLabels(s, i, ts);
%     end
% end
% 
% ts=unique(s);
% k=numel(ts);
% s(s==0) = k;


end

