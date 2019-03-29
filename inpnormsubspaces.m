% inpnormsubspaces provides the norm of inner products in each subspaces
% 
% inpnorm = inpnormsubspaces(SS,X)
%
%
%Output parameter:
% inpnorm: the norm in projected subspacess
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
function inpnorm = inpnormsubspaces(SS,X)

inp = inpsubspaces(SS,X);

for k=1:size(SS,3)
 nrm = inp(:,:,k) .* inp(:,:,k);
 inpnorm(:,k) = sqrt(sum(nrm,2));
end
