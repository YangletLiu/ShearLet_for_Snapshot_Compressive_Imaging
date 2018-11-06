function A3 = circtensor_mat(A2)
% 取每个tube，化为对角矩阵，铺成矩阵
% input: k*k*m
% output: mk*mk
    [k,~,m] = size(A2);
    A3 = zeros(k*m,k*m);
    for i=1:k
        for j = 1:k
            A3((i-1)*m+1:i*m,(j-1)*m+1:j*m) = diag(A2(i,j,:));
        end
    end
end