function [ distances ] = FindDistance( InputData ,matA, centers )
%======================================================
count=size(matA,1);
dim = size(matA,2);

% if length(centers == 1)
%     distances = (InputData - centers) * matA * (InputData - centers);
%     return;
% end

for i=1:1:1
    matB = squeeze(matA);
    center = centers(i,:);
    mahaldist=(InputData(:,1:dim)-repmat(center,size(InputData,1),1))*matB.*(InputData(:,1:dim)-repmat(center,size(InputData,1),1));
    mahaldist = sum(mahaldist,2);
end
distances = mahaldist;
for i = 1:size(centers, 1)
    d2 = (InputData-centers(i, :))*(matA)*(InputData-centers(i, :))';
end
end