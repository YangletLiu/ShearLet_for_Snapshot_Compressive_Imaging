clear
clc
addpath('dataset')
load("kobe32_cacti.mat") %orig,mean,mask

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
A = Fai;    % A = Fai*Psi_r in fact, only for test or initial for back tracking
singular = svds(A.'*A,1);
L = 2*singular; % wrong? too small, try to use artificial parameter
L = 8;
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
% X = sum(H_r.*S,3)     S = conj(H).*X
iteration = 200;
lambda = 0.0001;
recover = FISTA(iteration,I,H,H_r,G,M,y,L,lambda);
x_recover = ifft2withShift(recover);
psnr = SNR(x,x_recover);
sprintf("the snr is %f",psnr)

x = x*normalize;
y = y*normalize;
x_recover = x_recover*normalize;

figure;
subplot(1,3,1);
imagesc(x);
subplot(1,3,2);
imagesc(y);
subplot(1,3,3)
imagesc(x_recover);
colormap(gray);
