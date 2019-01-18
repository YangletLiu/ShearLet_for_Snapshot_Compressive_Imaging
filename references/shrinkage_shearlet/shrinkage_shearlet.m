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
img = orig(:,:,1:8);
mask = mask(:,:,1:8);
imgMasked=zeros(size(img,1),size(img,2));
for j = 1:8
    imgMasked = imgMasked + mask(:,:,j).*img(:,:,j);
end
imgMasked = imgMasked(:);

%% 仅拿到了imgMasked和mask
maskSum = 0;
for i=1:8
    maskSum = maskSum + mask(:,:,i);
end

maskRadio = zeros(size(mask));                                % 各mask在总体中的占比
for i=1:8
    maskRadio(:,:,i) = mask(:,:,i)./maskSum(:,:);
end
maskRadio(isnan(maskRadio)) = 0;

sampledUnfold = zeros(256*256,8);
for i=1:8
    temp = maskRadio(:,:,i);
    sampledUnfold(:,i) = diag(sparse(temp(:)))*imgMasked;
end
sampledUnfold = col2square(sampledUnfold(:),256*256,8);

%%
stopFactor = 0.005; % 迭代到什么精细程度
iteration = 100;
nor = max(img(:)) - min(img(:));

imgInpainted = zeros(size(img));
for j =1:8
    coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(sampledUnfold(:,:,j),shearletSystem),shearletSystem);
    delta = max(abs(coeffsNormalized(:)));
    lambda = (stopFactor)^(1/(iteration-1));
    for i=1:iteration
        res = mask(:,:,j).*(sampledUnfold(:,:,j)-imgInpainted(:,:,j));
        coeffs = SLsheardec2D(imgInpainted(:,:,j)+res,shearletSystem);
        coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,shearletSystem))>delta);            
        imgInpainted(:,:,j) = SLshearrec2D(coeffs,shearletSystem);
        figure(2);
        colormap(gray);
        imagesc(imgInpainted(:,:,j));title(['iteration : ' num2str(i, '%d'),'/',num2str(iteration,'%d')]);
        drawnow();
        delta=delta*lambda;
        disp(i);
    end
end


psnr_img = psnr(img/nor,imgInpainted/nor);
ssim_img = ssim(img/nor,imgInpainted/nor);
figure(3);
subplot(1,3,1);
imagesc(img);title('orig');
subplot(1,3,2);
imagesc(imgMasked);title('masked');
subplot(1,3,3);
imagesc(imgInpainted); title({'recon',['PSNR : ' num2str(psnr_img, '%.4f')], ['SSIM : ' num2str(ssim_img, '%.4f')]});
colormap(gray);