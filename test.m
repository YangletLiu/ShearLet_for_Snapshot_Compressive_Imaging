clear
clc
addpath(genpath(pwd))
load("kobe32_cacti.mat") %orig,mean,mask

%% FISTA---------------------------------------------------------------------------------------
temp = orig(:,:,1);
normalize = max(temp(:));
orig = orig/normalize;

maskFrames = size(mask,3);
[width, height, frames] = size(orig);
unavailableSampled = zeros(width*height,frames);  % calculate the the fai*x for each frame
for i=1:frames
    mask_i = mask(:,:,mod(i,maskFrames)+1);
    mask_i = diag(sparse(mask_i(:)));
    orig_i = orig(:,:,i);
    unavailableSampled(:,i) = mask_i * orig_i(:);
end

M = mask(:,:,1);
Fai = M; % here we don't reduce the dimension, so sampling is the same as M (Fai is the sampling matrix)
Fai = diag(sparse(square2col(Fai)));
x = orig(:,:,1); % n¡Án  no need to transform to N¡Á1
y = col2square(unavailableSampled(:,1)); 

% we don't need to build Psi_r in real other than here for the constant L, 
% we use math tricks to find another way to represent shearlet transform,
% so try to use back tracking version for L that can't easily compute

% each parallel sub matrix is moved to third dimension
% capital-frequency,lowercase-time
scales = 4;
shearletSystem = SLgetShearletSystem2D(0,size(x,1),size(x,2),scales);
s_real = SLsheardec2D(x,shearletSystem); % n¡Án¡ÁI, s is the coefficients in the shearlet domain
G = shearletSystem.dualFrameWeights; % n¡Án
H = shearletSystem.shearlets; % n¡Án¡ÁI
I = shearletSystem.nShearlets;
H_r = zeros(size(H));

for i=1:I 
    H_r(:,:,i) = H(:,:,i)./G;
end
% L is the Lipschitz constant
L = max(H_r(:));
L = 2*L^2;

% X = sum(H_r.*S,3)     S = conj(H).*X
iteration = 10;
lambda = 0.00075;
recover = FISTA(iteration,I,H,H_r,G,M,y,L,lambda);
x_recover = ifft2withShift(recover);

x = x*normalize;
y = y*normalize;
x_recover = x_recover*normalize;


psnr = PSNR(x,x_recover);
sprintf("the psnr is %f",psnr)

figure;
subplot(1,3,1);
imagesc(x);
subplot(1,3,2);
imagesc(y);
subplot(1,3,3)
imagesc(x_recover);
colormap(gray);

%% shrinkage directly, from shearlab--------------------------------------------------------------
% iteration = 100;
% img = orig(:,:,1);
% imgMasked = col2square(unavailableSampled(:,1));
% mask1 = M;
% imgInpainted = 0;
% coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(imgMasked,shearletSystem),shearletSystem);
% delta = max(abs(coeffsNormalized(:)));
% stopFactor = 0.005;
% lambda = (stopFactor)^(1/(iteration-1));
% for i=1:iteration
%     res = mask1.*(imgMasked-imgInpainted);
%     coeffs = SLsheardec2D(imgInpainted+res,shearletSystem);
%     coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,shearletSystem))>delta);            
%     imgInpainted = SLshearrec2D(coeffs,shearletSystem);
%     delta=delta*lambda;
%     disp(i);
% end  
% psnr = PSNR(img,imgInpainted);
% sprintf("the Psnr is %f",psnr)
% figure;
% subplot(1,3,1);
% imagesc(img);
% subplot(1,3,2);
% imagesc(imgMasked);
% subplot(1,3,3);
% imagesc(imgInpainted);
% colormap(gray);