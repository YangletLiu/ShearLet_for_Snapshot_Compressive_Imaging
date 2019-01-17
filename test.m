clear
clc
addpath(genpath(pwd))
load("kobe32_cacti.mat") %orig,mean,mask

%% FISTA---------------------------------------------------------------------------------------
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
H = shearletSystem.shearlets; % n×n×I
I = shearletSystem.nShearlets;
H_r = zeros(size(H));

for i=1:I 
    H_r(:,:,i) = H(:,:,i)./G;
end
% L is the Lipschitz constant
L = max(H_r(:));
L = 2*L^2;
L = 1;

% X = sum(H_r.*S,3)     S = conj(H).*X
iteration = 300;
lambda = 1;
A = @(d) M.*SLshearrec2D(d,shearletSystem);
% AT = @(d) SLsheardec2D(M.*d,shearletSystem);
x_recover = NFISTA(iteration,I,M,y,L,lambda,shearletSystem,A,AT);
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

%% shrinkage directly, from shearlab 迭代选取重要程度不同的特征--------------------------------------------------------------
% % % for Lena
% % img = double(imread('dataset/lena.jpg'));
% % mask = rand(512,512)>0.5;
% % imgMasked = mask.*img;
% % shearletSystem = SLgetShearletSystem2D(0,512,512,scales);
% % stopFactor = 0.005;
% % iteration = 20;
% 
% % for Kobe
% img = orig(:,:,1);
% mask = M;
% imgMasked = mask.*img;
% stopFactor = 0.005; % 迭代到什么精细程度
% iteration = 100;
% 
% imgInpainted = 0;
% coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(imgMasked,shearletSystem),shearletSystem);
% delta = max(abs(coeffsNormalized(:)));
% lambda = (stopFactor)^(1/(iteration-1));
% for i=1:iteration
%     res = mask.*(imgMasked-imgInpainted);
%     coeffs = SLsheardec2D(imgInpainted+res,shearletSystem);
%     coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,shearletSystem))>delta);            
%     imgInpainted = SLshearrec2D(coeffs,shearletSystem);
%     figure(2);
%     colormap(gray);
%     imagesc(imgInpainted);
%     drawnow();
%     delta=delta*lambda;
%     disp(i);
% end  
% psnr_img = PSNR(img,imgInpainted);
% sprintf("the Psnr is %f",psnr_img)
% figure(3);
% subplot(1,3,1);
% imagesc(img);
% subplot(1,3,2);
% imagesc(imgMasked);
% subplot(1,3,3);
% imagesc(imgInpainted);
% colormap(gray);