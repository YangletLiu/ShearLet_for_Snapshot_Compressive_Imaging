function nnorm = nuclear(X)
    nnorm = 0;
    for i = 1:size(X,3) % 无需按照tnn的定义去构造分块对角，直接这么算就相同
        s = svd(X(:,:,i));
        nnorm = nnorm + sum(s);
    end
end