function [ v ] = FindNMI( Clusters,  S, nmi_type)
%FINDNMI Summary of this function goes here
%   Detailed explanation goes here
v = -1;
if nargin == 2
   nmi_type = 2; 
end
t = max(Clusters);
if ismember(0,Clusters)
    Clusters(:) = Clusters(:) + 1;
end
if ismember(0,S)
    S(:) = S(:) + 1;
end



if t > 1000
    v = 0;
else
    try        
        v = nmi_general(S',Clusters', nmi_type);
    catch ME
        error(ME.message)
    end    
end

end

