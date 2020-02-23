img = orig(:,:,1);
img_noised = meas(:,:,1);
img_f = fft2(img_noised);
img_f = img_f.*(abs(img_f)>120000);
img_denoised = ifft2(img_f);
img_shearlet = denoise2(img_denoised);
% figure(1)
% colormap('gray');
% subplot(141)
% imagesc(img)
% subplot(142)
% imagesc(img_noised)
% subplot(143)
% imagesc(img_denoised)
% subplot(144)
% imagesc(img_shearlet)

figure(2)
colormap('gray');
imagesc(img)
set(gca,'xtick',[],'ytick',[]); 
figure(3)
colormap('gray');
imagesc(img_noised)
set(gca,'xtick',[],'ytick',[]); 
figure(4)
colormap('gray');
imagesc(img_denoised)
set(gca,'xtick',[],'ytick',[]); 
figure(5)
colormap('gray');
imagesc(img_shearlet)
set(gca,'xtick',[],'ytick',[]); 


function Xrec = denoise2(Xnoisy,nor,orig)
    thresholdingFactor = [0 1 1 1 3.8];
    shearletSystem = SLgetShearletSystem2D(0,256,256,4);    
    sigma = 1000;
    coeffs = SLsheardec2D(Xnoisy,shearletSystem);
    for j = 1:shearletSystem.nShearlets
        idx = shearletSystem.shearletIdxs(j,:);
        coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*shearletSystem.RMS(j)*sigma);
    end
    Xrec = SLshearrec2D(coeffs,shearletSystem);
end