function [ inds ] = getPCthatCoversThreshold( ex, thr )
%GETPCTHATCOVERSTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
s = 0;
for i = 1:length(ex)
    if s + ex(i) >= thr
        inds = 1:i;
        return;
    end
    s = s + ex(i);
end
inds = 1:length(ex);
end

