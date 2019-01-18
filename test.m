clear
clc
addpath(genpath(pwd))
load("kobe32_cacti.mat") %orig,mean,mask

%% FISTA shearlet---------------------------------------------------------------------------------------
maskFrames = size(mask,3);
[height, width, frames] = size(orig);
N = height*width;
M = mask(:,:,1);
x = orig(:,:,1); % n×n  no need to transform to N×1
y = M.*x; 

% we don't need to build Psi_r in real other than here for the constant L, 
% we use math tricks to find another way to represent shearlet transform,
% so try to use back tracking version for L that can't easily compute

% each parallel sub matrix is moved to third dimension
% capital-frequency,lowercase-time
scales = 4;
shearletSystem = SLgetShearletSystem2D(0,size(x,1),size(x,2),scales);
s_real = SLsheardec2D(x,shearletSystem); % n×n×I, s is the coefficients in the shearlet domain
G = shearletSystem.dualFrameWeights; % n×n
H = shearletSystem.shearlets; % n×n×I, don't forget conj in dec
I = shearletSystem.nShearlets;
H_r = zeros(size(H));

for i=1:I 
    H_r(:,:,i) = H(:,:,i)./G;
end
% L is the Lipschitz constant
L = max(H_r(:));
L = 2*L^2;
L = 5;

iteration = 300;
lambda = 2;
A = @(d) M.*SLshearrec2D(d,shearletSystem);
% 不同于dft，dft的循环卷积矩阵共轭转置恰好是逆变换，这里还不是可以直接用逆变换
AT = @(d) ShearletHrT(M.*d,H_r); 
% x_recover = FISTA(iteration,I,H,H_r,G,M,y,L,lambda);
x_recover = NNFISTA(iteration,I,M,y,L,lambda,shearletSystem,A,AT);
psnr_x = PSNR(x,x_recover);
sprintf("the psnr is %f",psnr_x)

figure(1);
subplot(1,3,1);
imagesc(x);
subplot(1,3,2);
imagesc(y);
subplot(1,3,3)
imagesc(x_recover);
colormap(gray);

