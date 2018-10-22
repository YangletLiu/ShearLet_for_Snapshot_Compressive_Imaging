function [X, objV] = proxF_tSVD_1(Y,rho,opts)
% proximal function of tensor nuclear norm
% %计算核范数objV，奇异值之和，可以作为L0范数的凸近似，还有就是做t-svd分解
% Authors: G. Ely, S. Aeron, Z. Zhang, ECE, Tufts Univ. 03/16/2015
% opts - boolean, runs algorithm in parallel.
%% Input checking
parOP = false;
if ~exist('opts','var') && ~isempty(opts)               %在工作区内检查opts变量是否存在，'var'表示检查其值
    nARG = length(opts);
    if nARG > 0
        parOP=opts{1};
    end    
end

%%
sa = size(Y);                                           %各个维度的大小
la = length(sa);                                        %共有几个维度
[n1,n2,n3] = size(Y);                                   %取到前三个维度的大小，若维度大于三，n3为后续维度之积

% this returned this STILL FFT'd version
[U,S,V]=ntsvd(Y,1,parOP);                               %做傅里叶变换和奇异值分解，即t-svd        

sTrueV =zeros(min(n1,n2),n3);
for i = 1:n3
    s = S(:,:,i);  
    s = diag(s);
    sTrueV(:,i) = s;
end                                                      %将奇异值分解中的各frontal层的对角S提取出来放入各列，为了添一个收缩的过程
%%
[sTrueV] = proxF_l1(sTrueV,rho);                            %对S做特征缩减，此处使用了L1范数来做（见论文第六页method one）这个又是特征值
%[sTrueV,objV] = proxF_l1(sTrueV,rho);
%%实际上是淘汰了一些较小的奇异值，考虑PCA类似，忽略掉一些次要的因素完成近似
objV = sum(sTrueV(:));                                      %奇异值之和
%%
for i = 1:min(n1,n2)                                     %复原S
    for j = 1:n3
        S(i,i,j) = sTrueV(i,j);
    end
end
    
for i = la:-1:3                                             %为啥不是算法里的n3到3，事实上U/S/V的frontal也都是n3维的
    U = ifft(U,[],i);                                       %ifft(U(i)) 返回该矩阵U(i)每一列的快速傅里叶逆变换
    S = ifft(S,[],i);
    V = ifft(V,[],i);
end

% X = tprod( tprod(U,S), ttrans_HO(V));

X = tprod( tprod(U,S), tran(V));                            %再将分解后的USV'乘回去
