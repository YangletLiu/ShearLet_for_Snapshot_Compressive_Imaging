% shrinkage directly, from shearlab 迭代选取重要程度不同的特征--------------------------------------------------------------
% % for Lena
% img = double(imread('../../dataset/lena.jpg'));
% mask = rand(512,512)>0.5;
% imgMasked = mask.*img;
% shearletSystem = SLgetShearletSystem2D(0,512,512,scales);
% stopFactor = 0.005;
% iteration = 20;

% for Kobe
load("../../dataset/kobe32_cacti.mat")
img = orig(:,:,1);
mask = mask(:,:,1);
imgMasked = mask.*img;
stopFactor = 0.005; % 迭代到什么精细程度
iteration = 100;

imgInpainted = 0;
coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(imgMasked,shearletSystem),shearletSystem);
delta = max(abs(coeffsNormalized(:)));
lambda = (stopFactor)^(1/(iteration-1));
for i=1:iteration
    res = mask.*(imgMasked-imgInpainted);
    coeffs = SLsheardec2D(imgInpainted+res,shearletSystem);
    coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,shearletSystem))>delta);            
    imgInpainted = SLshearrec2D(coeffs,shearletSystem);
    figure(2);
    colormap(gray);
    imagesc(imgInpainted);
    drawnow();
    delta=delta*lambda;
    disp(i);
end  
psnr_img = PSNR(img,imgInpainted);
sprintf("the Psnr is %f",psnr_img)
figure(3);
subplot(1,3,1);
imagesc(img);
subplot(1,3,2);
imagesc(imgMasked);
subplot(1,3,3);
imagesc(imgInpainted);
colormap(gray);