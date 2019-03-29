function [IDX, SS, inpnorm] = seqksubspaces(X,dim,th,iter)

if( nargin < 3 )
 th = 0.75;
end

if( nargin < 4 )
 iter = 3;
end


th = th * th;

IDX = zeros(size(X,1),1);

Xn = sqrt(sum(X .* X,2));
Xn = X ./ kron(ones(1,size(X,2)),Xn);
SS = [];
k = 1;
while(sum(IDX==0)>0)
    sum(IDX==0)
 pos = (IDX==0);
 tIDX = IDX(pos);
 XX = Xn(pos,:);
 XXX = X(pos,:);
 if( size(XX,1) <= dim )
  ipn = inpnormsubspaces(SS, XX);
  [ipn ind] = max(ipn,[],2);
  IDX(pos) = ind;
  inpnorm(pos) = ipn;
  return
 end
 
 ss = orth(XX(1:dim,:)')';
 
 for i=1:iter
  PXX = XX * ss' * ss;
  inl = ( sum(PXX .* XX, 2) >= th );
  V = XXX(inl,:);
  [V,D] = eig(V'*V);
  V = V';
  V = flipud(V);
  ss = V(1:dim,:);
 end
 tIDX(inl) = k;
 IDX(pos) = tIDX;
 
 SS = cat(3,SS,ss);
 k = k + 1;
end

