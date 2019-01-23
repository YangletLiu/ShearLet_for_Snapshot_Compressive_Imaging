nor = max(x(:));
imgDenoised = zeros(size(x_ista));

for i=1:8
    imgDenoised(:,:,i) = denoise2(x_ista(:,:,i),nor,x(:,:,i));
end

psnr_img = psnr(x./nor,imgDenoised./nor);
ssim_img = ssim(x./nor,imgDenoised./nor);

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
    %pause(1);
end

function Xrec = denoise2(Xnoisy,nor,orig)
    thresholdingFactor = [0.05 0.05 0.15 0.25 0.8];
    shearletSystem = SLgetShearletSystem2D(0,256,256,4);
%     l=5;
%     r=15;
%     step=1;
%     sigmas = l:step:r;
%     result = zeros(size(sigmas));
%     for i_sigma = 1:length(sigmas)
%         sigma = sigmas(i_sigma);
%         coeffs = SLsheardec2D(Xnoisy,shearletSystem);
%         for j = 1:shearletSystem.nShearlets
%             idx = shearletSystem.shearletIdxs(j,:);
%             coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*shearletSystem.RMS(j)*sigma);
%         end
%         Xrec = SLshearrec2D(coeffs,shearletSystem);
%         result(i_sigma) = psnr(Xrec./nor,orig./nor);
%     end
%     
% %     figure(4)
% %     plot(result);
%     
%     [~,pos] = max(result);
    
    sigma = 1;% sigmas((pos-1)*step+l); %15
    coeffs = SLsheardec2D(Xnoisy,shearletSystem);
    for j = 1:shearletSystem.nShearlets
        idx = shearletSystem.shearletIdxs(j,:);
        coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*shearletSystem.RMS(j)*sigma);
    end
    Xrec = SLshearrec2D(coeffs,shearletSystem);
end
