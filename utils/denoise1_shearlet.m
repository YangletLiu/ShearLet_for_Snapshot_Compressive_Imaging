iteration = 2;
nor = max(x(:));
shearletSystem = SLgetShearletSystem2D(0,256,256,4);

l=0.004;
r=0.014;
step=0.001;
times = 1;
result = zeros(size(l:step:r));
for stopFactor = l:step:r % 迭代到什么精细程度
    lambda = (stopFactor)^(1/(iteration-1));
    imgDenoised = zeros(size(x));
    for k=1:8
        coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(x_ista(:,:,k),shearletSystem),shearletSystem);
        delta = max(abs(coeffsNormalized(:)));
        for i=1:iteration
            res = x_ista(:,:,k)-imgDenoised(:,:,k);
            coeffs = SLsheardec2D(imgDenoised(:,:,k)+res,shearletSystem);
            coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,shearletSystem))>delta);
            imgDenoised(:,:,k) = SLshearrec2D(coeffs,shearletSystem);
            delta=delta*lambda; 
            
%             figure(2);
%             colormap(gray);
%             imagesc(imgDenoised(:,:,k));title(['iteration : ' num2str(i, '%d'),'/',num2str(iteration,'%d')]);
%             drawnow();
        end
    end
    disp(stopFactor);
    result(times) = psnr(x/nor,imgDenoised/nor);
    times = times + 1;
end

figure(4)
plot(result)

[val,pos] = max(result);
stopFactor = (pos-1)*step+l; %0.009
lambda = (stopFactor)^(1/(iteration-1));
imgDenoised = zeros(size(x));
for k=1:8
    coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(x_ista(:,:,k),shearletSystem),shearletSystem);
    delta = max(abs(coeffsNormalized(:)));
    for i=1:iteration
        res = x_ista(:,:,k)-imgDenoised(:,:,k);
        coeffs = SLsheardec2D(imgDenoised(:,:,k)+res,shearletSystem);
        coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,shearletSystem))>delta);
        imgDenoised(:,:,k) = SLshearrec2D(coeffs,shearletSystem);
        delta=delta*lambda;
        
        figure(2);
        colormap(gray);
        imagesc(imgDenoised(:,:,k));title(['iteration : ' num2str(i, '%d'),'/',num2str(iteration,'%d')]);
        drawnow();
    end
end
psnr_img = val;
ssim_img = ssim(x/nor,imgDenoised/nor);

for i=1:8
    figure(3);
    colormap('gray')
    subplot(1,3,1);
    imagesc(x(:,:,i));title('orig');
    subplot(1,3,2);
    imagesc(x_ista(:,:,i));title({'ista',['PSNR : ' num2str(psnr_x_ista, '%.4f')], ['SSIM : ' num2str(ssim_x_ista, '%.4f')]});
    subplot(1,3,3);
    imagesc(imgDenoised(:,:,i)); title({'denoise',['PSNR : ' num2str(psnr_img, '%.4f')], ['SSIM : ' num2str(ssim_img, '%.4f')]});
    colormap(gray);
    pause(1);
end

use_filter(x,imgDenoised);