function [d c]=kmccpdist(V,sB,subspace,A)
%function [d c]=kmccpdist(V,sB,subspace,A)
%calculates the distance of the points in sB to the plane represented by V
% if subspace=0 then  V(1,:) is the center of mass,
% and V(2:end,:) is a o.n. basis
% if subspace=1 then V(1:end,:) is the basis and the plane pass through
% origin. 

if nargin<3
   subspace=0;%Default value for subspace is 0.
end
[N,dim]=size(sB);
[cc,vdim]=size(V);
   if subspace==1
       dt=sum(sB.^2,2);
       c=sB*V(1:cc,:)';
       dn=sum(c.^2,2);
       d=dt-dn;
   else
       tmcc=V(1,:);
       sB=sB-ones(N,1)*tmcc;% reduce the center of mall
       dt=sum(sB.^2,2);
       c=sB*V(2:cc,:)';
       dn=sum(c.^2,2);
       d=dt-dn;
   end


