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

bfig = true;
bGPU = false;
%% DATA GENERATION
% for Kobe
load("kobe32_cacti.mat") % orig,mean,mask
x       = orig(:,:,1:8);
N       = 256;
M = mask; 
if bGPU 
    M = gpuArray(single(M));
end
LAMBDA  = 1000;
L       = 10;
niter   = 80; 
A       = @(x) sample(M,ifft2(x));
AT      = @(y) fft2(sampleH(M,y,bGPU));

%% NEWTON METHOD INITIALIZATION
y       = sample(M,x);
x0      = zeros(size(x));
if bGPU 
    y = gpuArray(single(y));
    x0 = gpuArray(single(x0));
end
L1              = @(x) norm(x, 1);
L2              = @(x) power(norm(x, 'fro'), 2);
COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
COST.function	= @(X) 1/2 * L2(A(X) - y) + LAMBDA * L1(X(:));

%% RUN NEWTON METHOD
tic
[x_ista, obj]	= MFISTA(A, AT, x0, y, LAMBDA, L, niter, COST, bfig, bGPU);
time = toc;
x_ista = real(ifft2(x_ista));
if bGPU
    x_ista = gather(x_ista);
end
%% CALCUATE QUANTIFICATION FACTOR 
nor             = max(x(:));
psnr_x_ista = zeros(8,1);
ssim_x_ista = zeros(8,1);
%% DISPLAY
figure(1); 
colormap gray;
suptitle('FISTA Method on DFT');
for i=1:8
    subplot(121);   
    imagesc(x(:,:,i));
    set(gca,'xtick',[],'ytick',[]);
    title('orig');
    
    psnr_x_ista(i) = psnr(x_ista(:,:,i)./nor, x(:,:,i)./nor); % 应该算平均值，这里暂留，已经在show中修改了
    ssim_x_ista(i) = ssim(x_ista(:,:,i)./nor, x(:,:,i)./nor);
    
    subplot(122);   
    imagesc(x_ista(:,:,i));  	
    
    set(gca,'xtick',[],'ytick',[]); 
    title({'recon_{ISTA}', ['PSNR : ' num2str(psnr_x_ista(i), '%.4f')], ['SSIM : ' num2str(ssim_x_ista(i), '%.4f')]});
    pause(1);
end
psnr_ista = mean(psnr_x_ista);
ssim_ista = mean(ssim_x_ista);