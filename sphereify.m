function B=sphereify(B);
% Project the points in B to the unit sphere
% Input: B is a N*D matrix representing the dataset
% Output: B is a N8D matrix, where each row is a unit D-vector. 

    [N,dim]=size(B);    
    for k=1:N
        B(k,:)=B(k,:)/norm(B(k,:));
    end
