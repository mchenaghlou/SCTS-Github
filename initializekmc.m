function  basis=initializekmc(B,initcent,planedimensions);
%Input :
% B: the N-by-D data matrix, whee N is the number of points and D is the
% ambient dimension
% initcent: parameter, 0 for random initialization and 2 for nearest
% subspace initialization
% % planedimensions: the K-vector represents the dimensions of the subspaces
% output:
% basis: a struct with K matrice, basis{i} be a matrix of
% planedimensions(i)-by-D, representing the orthogonal basis of the i-th
% subspace


[N D]=size(B);
K=length(planedimensions);
    if initcent==0
        %random initialization
        for j=1:length(planedimensions)
            basis{j}=randn(planedimensions(j),D);
            basis{j}=orth(basis{j}')';
        end
    elseif initcent==2
        id=ceil(N*rand);
        for k=1:K
            x=B(id,:);
            sB=B-ones(N,D)*diag(x);
            dt=sum(sB.^2,2);
            % sort the distances to the id-th point.
            [td tdi]=sort(dt);
            V=orth(B(tdi(1:planedimensions(k)),:)')';
            bdam=size(V,1);
            bcount=0;
            % find the nearest neighbour subspace
            while bdam<planedimensions(k)
                bcount=bcount+1;
                V=orth(B(tdi(1:planedimensions(k)+bcount),:)')';
                bdam=size(V,1);
                if bcount>60
                    planedimensions(k) = size(V,1);
                    break
                end
            end
            basis{k}(1:planedimensions(k),:)=V;
            % compute the distances from the k subspaces and the
            % N point set, stored in a N-by-k matrix
            for s=1:k
                d(:,s)=kmccpdist(basis{s},B,1);
            end
            d=min(d,[],2);
            % pick the farest point from the available subspaces
            [ju id]=max(d);
        end
    end



