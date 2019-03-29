% inpsubspaces provides inner products of each base of each subspaces
% 
% inp = inpsubspaces(SS, X)
%
%
%Output parameter:
% inp: the inner products, where size(inp,1) is the number of data, size(inp,2) is the dimension of the subspaces, and size(inp,3) is the number of the subspaces
%
%Input parameters:
% SS: subspaces, where size(SS,1) is the dimension of the subspaces, size(SS,2) is the dimension of the data and size(SS,3) is the number of the clusters
% X: data, where the number of data is size(X,1) and the dimension of the data is size(X,2)
%
%
%Version: 20120629

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ksubspaces                                               %
%                                                          %
% Copyright (C) 2012 Masayuki Tanaka. All rights reserved. %
%                    mtanaka@ctrl.titech.ac.jp             %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inp = inpsubspaces(SS, X)

inp = zeros(size(X,1),size(SS,1),size(SS,3));

for k=1:size(SS,3)
 inp(:,:,k) = X * SS(:,:,k)';
end
