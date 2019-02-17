clear
clc
addpath(genpath(pwd))
load("kobe32_cacti.mat") %orig,mean,mask
bDe = false;
bFig = false;

%% FISTA shearlet---------------------------------------------------------------------------------------
maskFrames = size(mask,3);
[height, width, frames] = size(orig);
N = height*width;
M = mask;
x = orig(:,:,1:8); % n×n  no need to transform to N×1
nor = max(x(:));
y = sample(M,x,8); 

% we don't need to build Psi_r in real other than here for the constant L, 
% we use math tricks to find another way to represent shearlet transform,
% so try to use back tracking version for L that can't easily compute

% each parallel sub matrix is moved to third dimension
% capital-frequency,lowercase-time
scales = 1;
shearletSystem = SLgetShearletSystem2D(0,size(x,1),size(x,2),scales); % 对同一个参数shearletSystem是固定的，所以公用一个system
G = shearletSystem.dualFrameWeights; % n×n
H = shearletSystem.shearlets; % n×n×I, don't forget conj in dec
I = shearletSystem.nShearlets;
H_r = zeros(size(H));

for i=1:I 
    H_r(:,:,i) = H(:,:,i)./G;
end
L = 20;
iteration = 400;
lambda = 2e4;
A = @(d) sample(M,ShearletHr(d,shearletSystem),8);
% 不同于dft，dft的循环卷积矩阵共轭转置恰好是逆变换，这里还不是可以直接用逆变换
AT = @(d) fft2withShift(ShearletHrT(sampleH(M,d,8,false),H_r)); 
tic;
x_ista = NNFISTA(iteration,I,y,L,lambda,shearletSystem,A,AT,bDe,bFig);
time = toc;
mse_x_ista = immse(x_ista./nor, x./nor);
psnr_x_ista = psnr(x/nor,x_ista/nor);
ssim_x_ista = ssim(x/nor,x_ista/nor);

figure(1); 
colormap gray;
suptitle('ISTA Method on Shearlet');
for i=1:8
    subplot(121);   imagesc(x(:,:,i));	axis image off;     title('orig');
    subplot(122);   imagesc(x_ista(:,:,i));  	axis image off;     title({'recon_{ISTA}', ['MSE : ' num2str(mse_x_ista, '%.4e')], ['PSNR : ' num2str(psnr_x_ista, '%.4f')], ['SSIM : ' num2str(ssim_x_ista, '%.4f')]});
    pause(1);
end

