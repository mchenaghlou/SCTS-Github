function [ output_args ] = findLowDimRep( data, basis )
%FINDLOWDIMREP Summary of this function goes here
%   Detailed explanation goes here

output_args= basis * data;
% output_args= basis * inv(basis' * basis) * basis' * data;
%     output_args = linsolve(basis',data);
    
end