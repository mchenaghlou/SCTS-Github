function v = nmi(x, y, par)
% Nomalized mutual information
%1 = joint
%2 = max
%3 = sum
%4 = sqrt
%5 = min
%6 = all

t=unique(y);
k=numel(t);
n = numel(x);

    UCrisp = zeros(k,n);
    ind=sub2ind([k n],y,[1:1:n]');
    UCrisp(ind)=ones(1,n);
    y=UCrisp;

t=unique(x);
k=numel(t);
k=numel(t);

    UCrisp = zeros(k,n);
    ind=sub2ind([k n],x,[1:1:n]');
    UCrisp(ind)=ones(1,n);
    x=UCrisp;

mContingency = x * y';

Pxy = mContingency./n; %joint distribution of x and y
Hxy = sum(-dot(Pxy,log2(Pxy+eps)));
if(Hxy<0)
    Hxy=-Hxy;
end
Px = sum(Pxy,2);
Py = sum(Pxy,1);

% entropy of Py and Px
Hx = -dot(Px,log2(Px+eps));
Hy = -dot(Py,log2(Py+eps));
if(Hx<0)
    Hx=-Hx;
end
if(Hy<0)
    Hy=-Hy;
end
% mutual information
MI = Hx + Hy - Hxy;

% normalized mutual information
%     v = sqrt((MI/Hx)*(MI/Hy)) ;

if par == 1 % joint
    v = MI/(Hxy);
elseif par == 2 % max 
    v = MI/max(Hx,Hy);
elseif par == 3 % sum
    v = MI/(Hx+Hy);
elseif par == 4 % sqrt
    v = MI/sqrt(Hx*Hy);
elseif par == 5 % min
    v = MI/min(Hx+Hy);
elseif par == 6 % all
    v1 = MI/(Hxy);
    v2 = MI/max(Hx,Hy);
    v3 = MI/(Hx+Hy);
    v4 = MI/sqrt(Hx*Hy);
    v5 = MI/min(Hx+Hy);
    v = [v1, v2, v3, v4, v5];
end
% v = MI/((Hx+Hy)/2);
end