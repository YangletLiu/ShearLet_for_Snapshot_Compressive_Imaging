clear ;
close all;
home;

bGPU = false;
%% DATASET
load("single.mat") % orig,meas,mask
meas = S;
mask = R;

bOrig   = false;
x       = zeros(108,192);

M = mask; 
bShear = true;
bFig = true;
sigma = @(ite) 1e-3;
LAMBDA  = @(ite) 0.01;
L       = 1e5;
niter   = 100; 
y = meas;
A       = @(x) A_xy(M,x);
AT      = @(y) AT_xy(M,y);

x0      = zeros(size(x));
L1              = @(x) norm(x, 1);
L2              = @(x) power(norm(x, 'fro'), 2);
COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
COST.function	= @(X,ite) 1/2 * L2(A(X) - y) + LAMBDA(ite) * L1(X(:));
%     COST.equation   = '1/2 * || A(X) - Y ||_2^2';
%     COST.function	= @(X) 1/2 * L2(A(X) - y);

%% RUN
tic
x	= SeSCI(A, AT, x0, y, LAMBDA, L, sigma, niter, COST, bFig, bGPU,bShear,false,false);
time = toc;
x = real(ifft2(x));
nor         = max(x(:));
%% DISPLAY
figure(2); 
colormap gray;
imagesc(x);
set(gca,'xtick',[],'ytick',[]);
 
function y=A_xy(mask,x)
    x = x(:);
    mask = reshape(mask,108*192,5000)';
    y = mask*x;
end

function x=AT_xy(mask,y)
    mask = reshape(mask,108*192,5000)';
    x = reshape(mask'*y,108,192);
end
    