function [basis label newenergy iter]=kmcl1sd(B,planedimensions,dt,maxiter,initcent,online)
% Median K-flats
% [basis d newenergy iter]=kmcl1sd(B,planedimensions,dt,maxiter,initcent)
% partitions the points in the N-by-D matrix B into clusters with dimensions planedimensions.
% Rows of B correspond to points, columns correspond to variables.
% Input:
% B: N-by-D matrix, represents N points on the unit D-1 dimensional sphere of D-dimensional ambient space,
% planedimensions: a vector represents the dimensions of the subspaces. 
% dt: The "step size" for the gradient boosting
% maxiter: the maximal allowed iterations.
% initcent is choice of initialization: if a structure array of matrices,
% is used as the initial subspaces.  if 2, nearest neighbor initialization. Default value is 2.
% is used.  if 0, orthogonalized random normal subspace is used.
% online: if it is 1 then this algorithm is online: stopping rule is obtained from
% checking the subspaces, if it is 0 then it is not online: stopping rule
% is obtained from checking the energy. Default value is 1
% Output:
% basis: a structure with length length(planedimensions), basis{i} is a D by
% planedimensions(i) matrix represents the orthogonal basis of the i-th subspace.
% label: a N-vector represents the classes of each points.
% newenergy: the l1-energy we obtained from this algorithm.
% iter: the number of iterations performed in this algorithm.
% by default we use online=0 and initcent=2;
if nargin<6
    online=0;
end
if nargin<5
    initcent=2;
end
B=sphereify(B);
%Get the number of subspaces K.
K=length(planedimensions);
% Get the number of points N and the ambient dimension D.
[N D]=size(B);
%initialize the basis for each subspace.
basis=initializekmc(B,initcent,planedimensions);
% distances: a N-by-length(planedimensions) matrix represents the distance from N points and K
% subspaces.
distances=zeros(N,K);
oldenergy=1;newenergy=2;iter=1;dddd=1;
for i1=1:K
    newbasis{i1}=orth(rand(D,planedimensions(i1)))';
end
% stopping rule is different for online version and not online version
while dddd>0.001 && iter<maxiter
mit=mod(iter-1,N)+1;
    %build a random permutation of the points, if we used up the previous
    %permutation
    if mit==1
        rr=randperm(N);
    end
    id=rr(mit);
    %x is the next point in the random order
    x=B(id,:);
    %update the "distances"
    %from each center(subspace) to x
    for k=1:K
        distances(id,k)=sum((basis{k}*x').^2);
        %B is assumed normalized on the sphere!
    end
    %which center does x belong to?
    [ju juu]=max(distances(id,:));
    %update the basis by their interaction with x;
    %x belongs to the juu-th subspace
    A=basis{juu};
    Ax=A*x';
    AxxA=Ax*Ax';
    dA=Ax*x-AxxA*A;
    %B is assumed normalized on the sphere!
    %note the update of A as below is only valid if
    %A is orthonormal.
    A=A+dt*dA/sqrt((1-ju)+.0001);
    A=orth(A')';
    basis{juu}=A;
    % check the nergy after every 1000 iteration.
    % stopping rule (dddd>0.001) is different for online version and not online version
    if mod(iter,1000)==1
        if online==1
            oldbasis=newbasis;
            newbasis=basis;
            for i1=1:K
                for i2=1:K
                    [ss,vv,dd]=svd(oldbasis{i1}*newbasis{i2}');
                    ddd(i1,i2)=K-sum(sum(vv.^2));%the distance between oldbasis{i1} and newbasis{i2}
                end
            end
            dddd=max(min(ddd));% this is the change between oldbasis and newbasis in a interation
        else
            oldenergy=newenergy;
            [ju mincent]=max(distances,[],2);
			% note here the Euclidean distance from a point to a subspace is actually \sqrt{1-distance}
            newenergy=sum(sqrt(1-ju));% find the sum of distances
            dddd=max([oldenergy/newenergy,newenergy/oldenergy])-1;% find the change rate of the energy
        end
    end
    iter=iter+1;
end
[ju label]=max(distances,[],2);%find guessed label
