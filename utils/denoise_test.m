de = zeros(256,256,8);
de_ite = 100;
l = 8;
r = 13;
step = 0.1;
result = zeros(size(l:step:r));
times = 1;

psnr_x_ista_     = psnr(x_ista./nor, x./nor);
ssim_x_ista_     = ssim(x_ista./nor, x./nor);

for de_lambda=l:step:r
    display(times);
    for i=1:8
        de(:,:,i) = TV_denoising(x_ista(:,:,i),de_lambda,de_ite);

        psnr_x_ista1     = psnr(x_ista(:,:,i)./nor, x(:,:,i)./nor);
        ssim_x_ista1     = ssim(x_ista(:,:,i)./nor, x(:,:,i)./nor);
        psnr_de1     = psnr(de(:,:,i)./nor, x(:,:,i)./nor);
        ssim_de1     = ssim(de(:,:,i)./nor, x(:,:,i)./nor);

%         figure(1)
%         colormap('gray')
%         subplot(121)
%         imagesc(x_ista(:,:,i));title({['PSNR : ' num2str(psnr_x_ista1, '%.4f')], ['SSIM : ' num2str(ssim_x_ista1, '%.4f')]});
%         subplot(122)
%         imagesc(de(:,:,i));title({['PSNR : ' num2str(psnr_de1, '%.4f')], ['SSIM : ' num2str(ssim_de1, '%.4f')]});
    end

    psnr_de     = psnr(de./nor, x./nor);
    ssim_de     = ssim(de./nor, x./nor);
    
    result(times) = psnr_de - psnr_x_ista_;
    times= times + 1;
end
figure(2)
plot(l:step:r,result)
[val,pos] = max(result);
de_lambda = step*(pos-1)+l; %11.7
