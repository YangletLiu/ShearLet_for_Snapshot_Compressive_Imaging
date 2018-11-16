function A1 = block_diagonal(X)
% 展开第三维，将tensor排列为对角矩阵
% input: m*n*k
% output: mk*nk
    [m,n,k] = size(X);
    A1 = zeros(m*k,n*k);
    for i=1:k
        A1(m*(i-1)+1:m*i,n*(i-1)+1:n*i)=X(:,:,i);
    end
end