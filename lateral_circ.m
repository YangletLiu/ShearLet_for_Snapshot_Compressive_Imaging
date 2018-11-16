function A2 = lateral_circ(P,j)
% 将侧面某个slice抽出生成循环的矩阵
% input: m*1*k
% output: k*k*m
    [m,~,k] = size(P(:,j,:));
    A2 = zeros(k,k,m);
    for i=1:m
        A2(:,:,i) = vec_circ(squeeze(P(i,j,:)));    %squeeze之后确保成为列向量
    end
end