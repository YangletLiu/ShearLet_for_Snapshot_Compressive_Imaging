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

%% GPU Processing
% If there is GPU device on your board, 
% then isgpu is true. Otherwise, it is false.
bgpu    = false;
bfig    = true;

%%  SYSTEM SETTING
N       = 512;
M = rand(512,512)>0.4; % maskæÿ’Û

A       = @(x) M.*ifft2(x);
AT      = @(y) fft2(M.*y);

%% DATA GENERATION
load('XCAT512.mat');
x       = imresize(double(XCAT512), [N, N]);
x_full  = x;

%%  ©º”∏…»≈
pn = M.*x;
x_low   = pn;

%% NEWTON METHOD INITIALIZATION
LAMBDA  = 0.8;
L       = 10;

y       = pn;
x0      = zeros(size(x));
niter   = 100;

L1              = @(x) norm(x, 1);
L2              = @(x) power(norm(x, 'fro'), 2);
COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
COST.function	= @(x) 1/2 * L2(A(x) - y) + LAMBDA * L1(x);

%% RUN NEWTON METHOD
if bgpu
    y  = gpuArray(y);
    x0 = gpuArray(x0);
end

[x_ista, obj]	= MISTA(A, AT, x0, y, LAMBDA, L, niter, COST, bfig);
x_ista = ifft2(x_ista);
%% CALCUATE QUANTIFICATION FACTOR 
x_low           = max(x_low, 0);
nor             = max(x(:));

mse_x_low       = immse(x_low./nor, x./nor);
mse_x_ista      = immse(x_ista./nor, x./nor);

psnr_x_low      = psnr(x_low./nor, x./nor);
psnr_x_ista     = psnr(x_ista./nor, x./nor);

ssim_x_low      = ssim(x_low./nor, x./nor);
ssim_x_ista     = ssim(x_ista./nor, x./nor);

%% DISPLAY
figure(1); 
colormap gray;

suptitle('ISTA Method');
subplot(231);   imagesc(x);	axis image off;     title('ground truth');
subplot(232);   imagesc(x_full);  	axis image off;     title(['full-dose']);
subplot(234);   imagesc(x_low);  	axis image off;     title({['low-dose'], ['MSE : ' num2str(mse_x_low, '%.4e')], ['PSNR : ' num2str(psnr_x_low, '%.4f')], ['SSIM : ' num2str(ssim_x_low, '%.4f')]});
subplot(235);   imagesc(x_ista);  	axis image off;     title({['recon_{ISTA}'], ['MSE : ' num2str(mse_x_ista, '%.4e')], ['PSNR : ' num2str(psnr_x_ista, '%.4f')], ['SSIM : ' num2str(ssim_x_ista, '%.4f')]});

subplot(2,3,[3,6]); semilogy(obj, '*-');    title(COST.equation);  xlabel('# of iteration');   ylabel('Cost function'); 
                                            xlim([1, niter]);   grid on; grid minor;
