function [ res ] = MultiVariateNormalSampleSize(alpha, dim, d)
    n = dim+1;
    while true
        dis = FDistributionIntervalRegion(alpha, dim, n);
        if dis <= d
            res = n+dim;
            break;
        end
        n = n+1;
    end
end

function [ d1 ] = FDistributionIntervalRegion( alpha, dim, n)


     d1 = (dim/(n-dim)) * finv(1-alpha,dim,n-dim);
     
%      d2 = (dim/(n-dim)) * fpdf(1-alpha,dim,n-dim);

end

