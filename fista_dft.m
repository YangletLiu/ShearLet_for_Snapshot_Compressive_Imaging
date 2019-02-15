%% Reference
% https://people.rennes.inria.fr/Cedric.Herzet/Cedric.Herzet/Sparse_Seminar/Entrees/2012/11/12_A_Fast_Iterative_Shrinkage-Thresholding_Algorithmfor_Linear_Inverse_Problems_(A._Beck,_M._Teboulle)_files/Breck_2009.pdf

%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)

%%
clear ;
close all;
home;

bFig = true;
bGPU = false;
%% DATASET
load("4fan14_cacti.mat") % meas,mask
codedNum = 14;

% load("kobe32_cacti.mat") % orig,meas,mask
% codedNum = 8;
% clear orig
%% DATA PROCESS
if exist('orig','var')
    bOrig   = true;
    x       = orig(:,:,1:codedNum);
else
    bOrig   = false;
    x       = zeros(size(mask));
end
N       = 256;
M = mask; 
if bGPU 
    M = gpuArray(single(M));
end
bShear = true;
sigma = 1;
LAMBDA  = 1e5;
L       = 2e5;
niter   = 200; 
A       = @(x) sample(M,ifft2(x),codedNum);
AT      = @(y) fft2(sampleH(M,y,codedNum,bGPU));

%% INITIALIZATION
if bOrig
    y       = sample(M,x,codedNum);
else
    y       = meas(:,:,1);
end
x0      = zeros(size(x));
if bGPU 
    y = gpuArray(single(y));
    x0 = gpuArray(single(x0));
end
L1              = @(x) norm(x, 1);
L2              = @(x) power(norm(x, 'fro'), 2);
COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
COST.function	= @(X) 1/2 * L2(A(X) - y) + LAMBDA * L1(X(:));

%% RUN
tic
[x_ista, obj]	= MFISTA(A, AT, x0, y, LAMBDA, L, sigma, niter, COST, bFig, bGPU,bShear);
time = toc;
x_ista = real(ifft2(x_ista));
if bGPU
    x_ista = gather(x_ista);
end
nor         = max(x(:));
psnr_x_ista = zeros(codedNum,1);
ssim_x_ista = zeros(codedNum,1);
%% DISPLAY
figure(1); 
for i=1:codedNum
    if bOrig
        colormap gray;
        subplot(121);   
        imagesc(x(:,:,i));
        set(gca,'xtick',[],'ytick',[]);
        title('orig');

        subplot(122);   
        imagesc(x_ista(:,:,i));  	
        set(gca,'xtick',[],'ytick',[]); 
        
        psnr_x_ista(i) = psnr(x_ista(:,:,i)./nor, x(:,:,i)./nor); % 应该算平均值，这里暂留，已经在show中修改了
        ssim_x_ista(i) = ssim(x_ista(:,:,i)./nor, x(:,:,i)./nor);
        title({['frame : ' num2str(i, '%d')], ['PSNR : ' num2str(psnr_x_ista(i), '%.4f')], ['SSIM : ' num2str(ssim_x_ista(i), '%.4f')]});
    else 
        colormap gray;
        imagesc(x_ista(:,:,i));  	
        set(gca,'xtick',[],'ytick',[]); 
        title(['frame : ' num2str(i, '%d')]);
    end
    pause(1);
end
psnr_ista = mean(psnr_x_ista);
ssim_ista = mean(ssim_x_ista);