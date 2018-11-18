%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [U,S,V] = ntsvd(A,fftOP,parOP)
% Nth order tension SVD
% Purpose:  Factors any higher order tensors into its component
%
% Inputs:   A - 3+ order tensor MxNx...
%
%           fftOP (optional) - boolean that determines if outputs have fft
%           Applied along each dimensions
%
%           1 ---- apply fft
%           0 ---- not apply fft
%
%           parOP (optional) - boolean, runs algorithm in parallel.
%
% Output:   U,S,V - (if fftOp true) where U*S*Vt = A.
%
%           or
%
%           U,S,V - (if fftOp false) ifft_T(U)*ifft_T(S)*ifft_T(V)^T = A
%           
% Original author :  Misha Kilmer, Ning Hao
% Edited by       :  G. Ely, S. Aeron, Z. Zhang, ECE, Tufts Univ. 03/16/2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [U,S,V] = ntsvd(A,fftOP,parOP)

% determine size of tensor
sa = size(A);                               %各个维度的大小
la = length(sa);                            %共有几个维度
[n1,n2,n3]=size(A);                         %取到前三个维度的大小，若维度大于三，n3为后续维度之积
fl=0;


if ~exist('parOP','var')
    parOP = false;
end

if ~exist('fftOP','var')
   fftOP = false; 
end

%% Perform FFT along 3 to P axeses of Tensor


% conjugate symetric trick.
if la == 3
    if n2 > n1
        transflag=1;                                %之后检查这个变量看是否应用了三维时的trick
        A=tran(A);                                  %转置
        nn1=n1;                                     %交换n1,n2
        n1=n2;
        n2=nn1;
    end
    U = zeros(n1,n1,n3);
    S = zeros(n1,n2,n3);
    V = zeros(n2,n2,n3);
    % for P orders
else
    sU =sa;         %determines proper size
    sU(2) = sU(1);  %U is n1×n1
    sV = sa;        %determines proper size
    sV(1) = sV(2);  %V is n2×n2
    U = zeros(sU);  %pre allocated
    S = zeros(sa);
    V = zeros(sV);
end

for i = 3:la
    A = fft(A,[],i);
end

faces = prod(sa(3:la));     %determine # of faces将除1维和2维之外的都乘起来

if la == 3
    % Do the conjugate symetric trick here.求取共轭
    if isinteger(n3/2)
        endValue = int16(n3/2 + 1);
        [U, S, V] = takeSVDs(U,S,V,A,endValue,parOP);
        
        for j =n3:-1:endValue+1
            U(:,:,j) = conj(U(:,:,n3-j+2));
            V(:,:,j) = conj(V(:,:,n3-j+2));
            S(:,:,j) = S(:,:,n3-j+2);
        end

    else % if isinteger(n3/2)
        endValue = int16(n3/2 + 1);        
        [U,S,V] = takeSVDs(U,S,V,A,endValue,parOP);
        
        for j =n3:-1:endValue+1
            U(:,:,j) = conj(U(:,:,n3-j+2));
            V(:,:,j) = conj(V(:,:,n3-j+2));
            S(:,:,j) = S(:,:,n3-j+2);
        end
    end %if isinteger(n3/2)
%% for 4+ dimensional tensors do not perform the
% the conjugate trick.
else % if la != 3  
    [U, S, V] = takeSVDs(U,S,V,A,faces,parOP);
end

%%

if ~fftOP
    [U S V] = ifft_T(U,S,V);
end

if exist('transflag','var')
    Uold =U; U=V; S=tran(S); V=Uold;  
end

end
%% BEGIN SUBFUNCTIONS
%
%%
function [U, S, V] = takeSVDs(U,S,V,A,endI,runPar)

if ~exist('runPar','var')
    runPar = false;
end

if ~runPar || parpool('size') == 0                  %matlabpool('size')

    for i=1:endI
        [U1,S1,V1]=svd(A(:,:,i));
        U(:,:,i)=U1; S(:,:,i)=S1; V(:,:,i)=V1;
    end
else
    
    parfor i=1:endI                                 %cpu并行处理
        [U1,S1,V1]=svd(A(:,:,i));
        U(:,:,i)=U1; S(:,:,i)=S1; V(:,:,i)=V1;
    end
end

end

