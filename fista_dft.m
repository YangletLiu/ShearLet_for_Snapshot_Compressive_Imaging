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

bfig    = true;

%% DATA GENERATION
% for Kobe
load("kobe32_cacti.mat") % orig,mean,mask
x       = orig(:,:,1:8);
N       = 256;
M = mask; 
LAMBDA  = 200;
L       = 10;
niter   = 200; 
A       = @(x) sample(M,ifft2(x));
AT      = @(y) fft2(sampleH(M,y));

%% NEWTON METHOD INITIALIZATION
y       = sample(M,x);
x0      = zeros(size(x));

L1              = @(x) norm(x, 1);
L2              = @(x) power(norm(x, 'fro'), 2);
COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
COST.function	= @(X) 1/2 * L2(A(X) - y) + LAMBDA * L1(X(:));

%% RUN NEWTON METHOD

[x_ista, obj]	= MFISTA(A, AT, x0, y, LAMBDA, L, niter, COST, bfig);
x_ista = real(ifft2(x_ista));
%% CALCUATE QUANTIFICATION FACTOR 
nor             = max(x(:));
mse_x_ista      = immse(x_ista./nor, x./nor);
psnr_x_ista     = psnr(x_ista./nor, x./nor);
ssim_x_ista     = ssim(x_ista./nor, x./nor);

%% DISPLAY
figure(1); 
colormap gray;
suptitle('FISTA Method on DFT');
for i=1:8
    subplot(121);   imagesc(x(:,:,i));	axis image off;     title('orig');
    subplot(122);   imagesc(x_ista(:,:,i));  	axis image off;     title({'recon_{ISTA}', ['MSE : ' num2str(mse_x_ista, '%.4e')], ['PSNR : ' num2str(psnr_x_ista, '%.4f')], ['SSIM : ' num2str(ssim_x_ista, '%.4f')]});
    pause(1);
end

load("GAP_TV.mat")
psnr_gaptv = psnr(x/nor,vgaptv);
ssim_gaptv = ssim(x/nor,vgaptv);
figure(2)
colormap('gray')
suptitle('GAP_TV Method');
for i=1:8
    imagesc(vgaptv(:,:,i)); title({['PSNR : ' num2str(psnr_gaptv, '%.4f')], ['SSIM : ' num2str(ssim_gaptv, '%.4f')]});
    pause(1)
end