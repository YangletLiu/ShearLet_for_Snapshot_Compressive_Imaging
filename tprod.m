function C=tprod(A,B)
%tensor乘积（用的是t-product）
% Computes the tensor-product of two P dimensional tensors (A & B)
% All dimensions of the inputed tensor except for the 2nd must be the same.
% The algorithm follows from paper by ...
%
% INPUTS:
%
% A - n1 x n2 x n3 .... nP tensor
% B - n2 x n4 x n3 .... nP tensor
%
% OUTPUTS: 
%
% C - n1 x n4 x n3 .... nP tensor
%
% Original author :  Misha Kilmer, Ning Hao
% Edited by       :  G. Ely, S. Aeron, Z. Zhang, ECE, Tufts Univ. 03/16/2015


sa = size(A);
sb = size(B);

faces = length(sa);

nfaces = prod(sb(3:end));

for i = 3:faces                                                 %先从3到order维度抽取tube对其各列进行(#order-2)次傅里叶变换
    A = fft(A,[],i);
    B = fft(B,[],i);
end
sc = sa;
sc(2) = sb(2);
C = zeros(sc);
for i = 1:nfaces                                                %逐矩阵相乘，这里针对的都是一个前两维大小的矩阵
    C(:,:,i) = A(:,:,i)*B(:,:,i);                               %这也是合理的，因为这个m文件是用来做奇异值分解后的恢复的
end
for i = 3:faces                                                 %%(#order-2)次傅里叶逆变换获取t-tensor积
    C = ifft(C,[],i);
end



