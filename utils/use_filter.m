% 平滑处理
mean3Sample = filter2(fspecial('average',3),x_ista); % 3均值滤波
mean7Sample = filter2(fspecial('average',7),x_ista); % 7均值滤波
gaussianSample = filter2(fspecial('gaussian'),x_ista); % 高斯滤波
% figure(2);
% colormap gray;
% suptitle('平滑');
% 
% subplot(221); 
% imagesc(x_ista); title('ista');
% subplot(222);
% imagesc(mean3Sample); title('average 3');
% subplot(223);
% imagesc(mean7Sample); title('average 7');
% subplot(224);
% imagesc(gaussianSample); title('gaussian');
 
% 锐化处理
prewittSample = filter2(fspecial('prewitt'),x_ista)/(max(x_ista(:))-min(x_ista(:)));
sobelSample = filter2(fspecial('sobel'),x_ista)/(max(x_ista(:))-min(x_ista(:)));

% figure(3);
% suptitle('锐化');
% colormap gray;
% subplot(131); 
% imagesc(x_ista); title('ista');
% subplot(132);
% imagesc(prewittSample); title('prewitt');
% subplot(133);
% imagesc(sobelSample); title('sobel');

% 综合
subSample3 = x_ista*2 - mean3Sample;
subSample7 = x_ista*2 - mean7Sample;
subSampleG = x_ista*2 - gaussianSample;
addSampleP = x_ista + prewittSample;
addSampleS = x_ista + sobelSample;
psnr_x_P = psnr(addSampleP./nor, x./nor);
psnr_x_S = psnr(addSampleS./nor, x./nor);
psnr_x_3 = psnr(subSample3./nor, x./nor);
psnr_x_7 = psnr(subSample7./nor, x./nor);
psnr_x_G = psnr(subSampleG./nor, x./nor);
ssim_x_P     = ssim(addSampleP./nor, x./nor);
ssim_x_S      = ssim(addSampleS./nor, x./nor);
ssim_x_3     = ssim(subSample3./nor, x./nor);
ssim_x_7      = ssim(subSample7./nor, x./nor);
ssim_x_G     = ssim(subSampleG./nor, x./nor);
 
figure(4);
colormap gray;
suptitle('综合');
subplot(231); 
imagesc(x_ista); title({'ista',['PSNR : ' num2str(psnr_x_ista, '%.4f')], ['SSIM : ' num2str(ssim_x_ista, '%.4f')]});
subplot(232);
imagesc(addSampleP); title({'prewitt',['PSNR : ' num2str(psnr_x_P, '%.4f')], ['SSIM : ' num2str(ssim_x_P, '%.4f')]});
subplot(233);
imagesc(addSampleS); title({'sobel',['PSNR : ' num2str(psnr_x_S, '%.4f')], ['SSIM : ' num2str(ssim_x_S, '%.4f')]});
subplot(234); 
imagesc(subSample3); title({'average 3',['PSNR : ' num2str(psnr_x_3, '%.4f')], ['SSIM : ' num2str(ssim_x_3, '%.4f')]});
subplot(235);
imagesc(subSample7); title({'average 7',['PSNR : ' num2str(psnr_x_7, '%.4f')], ['SSIM : ' num2str(ssim_x_7, '%.4f')]});
subplot(236);
imagesc(subSampleG); title({'gaussian',['PSNR : ' num2str(psnr_x_G, '%.4f')], ['SSIM : ' num2str(ssim_x_G, '%.4f')]});