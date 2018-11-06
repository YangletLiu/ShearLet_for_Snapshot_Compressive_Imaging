function A2_l = vec_circ(vec)
% 从向量生成对应的循环矩阵
    k = size(vec); 
    A2_l = zeros(k,k);
    for i = 1:k
        A2_l(i,1:i-1)=vec(k-i+2:k);     %溢出时不进行赋值
        A2_l(i,i:k) = vec(1:k-i+1);
    end
end