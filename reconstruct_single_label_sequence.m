function [ c ] = reconstruct_single_label_sequence( X )
%RECONSTRUCT_SINGLE_LABEL_SEQUENCE Summary of this function goes here
%   Detailed explanation goes here
ss = unique(X);
i = 0;
while i < length(ss)-1
    i = i+1;
    if ismember(i,X)
        continue
    else
        j = ss(i+1);
        t = find(X==j);
        X(t) = i;
        ss = unique(X);
        i = i -1;
    end
end
if(max(X) ~= length(unique(X)))
    X(find(X == max(X))) = length(unique(X));
end
c = X;
end

