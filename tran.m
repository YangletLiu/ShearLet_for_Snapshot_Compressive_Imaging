%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR: Carla Dee Martin (carlam@math.jmu.edu)
% DATE: June 2, 2010
%
% PROGRAM: tran.m
% PURPOSE: Input a tensor, and output the tensor transpose. 
%
% VARIABLES:
% A = Input tensor
% T = Tensor transpose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tensor转置
function T = tran(A)

n=size(A);                                  %tensor各个维度大小
k=length(n);                                %维度数量,order
a=reshape(A,prod(n),1);                     %转化为列向量,prod返回数组元素之积

t = tensortransposerecur(a,n);              %转置

T = reshape(t,[n(2),n(1),n(3:end)]);        %整形恢复成tensor，所以上一步要做的是调整a中的顺序使此步直接交换两部分是正确的

end

%%%%%%%%%%%%%%%%%%%%%%
function t = tensortransposerecur(a,n)
  
k=length(n);

if k<=2                                     %二维直接转置，递归终止条件
  A=reshape(a,n(1),n(2))'; 
  a=reshape(A,prod(n),1);
  t=a;
 

elseif k>=3
  
  % flips order
  Acell=cell(n(k),1);
  Bcell=cell(n(k),1);

  % puts into cell array
  for j = 1:n(k)
     Acell{j} = a([(j-1)*prod(n(1:k-1))+1:j*prod(n(1:k-1))]);       %最高维固定，先把前面的各维度组成的放到一个cell中
  end

  %flip order of cells
  y = size(Acell);
  Bcell{1} = Acell{1};%A的被固定的维除了第一层，剩下的反过来存入B。见3-order-tensor论文def 3.14
  
  z = 2;
  for i = y(1):-1:2
    Bcell{z} = Acell{i};
    z = z+1;
  end

  % put back into long vector
  c=[];
  for m = 1:n(k)
     c = [c;Bcell{m}];
  end
  a=c;
  % end flip order
  
  for i=1:n(k)                                              %递归对下一维度各个分量进行转置处理
    v=a((i-1)*prod(n(1:k-1))+1:i*prod(n(1:k-1)));
    a((i-1)*prod(n(1:k-1))+1:i*prod(n(1:k-1))) = tensortransposerecur(v,n(1:k-1));
  end
  
end

t=a;

end




