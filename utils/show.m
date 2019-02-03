nor = 255;
load("kobe32_cacti.mat");
x = orig(:,:,1:8);
%%
% load("GMM-TP.mat")
% clear psnr;
% clear ssim;
% x_gmm1 = Xpre;
% for i=1:8
%     figure(3)
%     colormap('gray')
%     subplot(2,4,i)
%     psnr_i = psnr(x(:,:,i)/nor,x_gmm1(:,:,i)/nor);
%     ssim_i = ssim(x(:,:,i)/nor,x_gmm1(:,:,i)/nor);
%     imagesc(x_gmm1(:,:,i)); title({['PSNR : ' num2str(psnr_i, '%.4f')], ['SSIM : ' num2str(ssim_i, '%.4f')]});
% end
% 
% psnr_gmm1 = psnr(x/nor,x_gmm1/nor);
% ssim_gmm1 = ssim(x/nor,x_gmm1/nor);
% for i=1:8
%     figure(4)
%     colormap('gray')
%     imagesc(x_gmm1(:,:,i)); title({['PSNR : ' num2str(psnr_gmm1, '%.4f')], ['SSIM : ' num2str(ssim_gmm1, '%.4f')]});
%     %pause(0.5)
% end

%%
% load("MMLE-GMM.mat")
% clear psnr;
% clear ssim;
% x_gmm2 = Xpre(:,:,1:8);
% for i=1:8
%     figure(3)
%     colormap('gray')
%     subplot(2,4,i)
%     psnr_i = psnr(x(:,:,i)/nor,x_gmm2(:,:,i)/nor);
%     ssim_i = ssim(x(:,:,i)/nor,x_gmm2(:,:,i)/nor);
%     imagesc(x_gmm2(:,:,i)); title({['PSNR : ' num2str(psnr_i, '%.4f')], ['SSIM : ' num2str(ssim_i, '%.4f')]});
% end
% 
% psnr_gmm2 = psnr(x/nor,x_gmm2/nor);
% ssim_gmm2 = ssim(x/nor,x_gmm2/nor);
% for i=1:8
%     figure(4)
%     colormap('gray')
%     imagesc(x_gmm2(:,:,i)); title({['PSNR : ' num2str(psnr_gmm2, '%.4f')], ['SSIM : ' num2str(ssim_gmm2, '%.4f')]});
%     %pause(0.5)
% end

%%
% load("MMLE-MFA.mat")
% clear psnr;
% clear ssim;
% x_mfa = Xpre;
% for i=1:8
%     figure(3)
%     colormap('gray')
%     subplot(2,4,i)
%     psnr_i = psnr(x(:,:,i)/nor,x_mfa(:,:,i)/nor);
%     ssim_i = ssim(x(:,:,i)/nor,x_mfa(:,:,i)/nor);
%     imagesc(x_mfa(:,:,i)); title({['PSNR : ' num2str(psnr_i, '%.4f')], ['SSIM : ' num2str(ssim_i, '%.4f')]});
% end
% 
% psnr_mfa = psnr(x/nor,x_mfa/nor);
% ssim_mfa = ssim(x/nor,x_mfa/nor);
% for i=1:8
%     figure(4)
%     colormap('gray')
%     imagesc(x_mfa(:,:,i)); title({['PSNR : ' num2str(psnr_mfa, '%.4f')], ['SSIM : ' num2str(ssim_mfa, '%.4f')]});
%     %pause(0.5)
% end

%%
% load("GAP_TV.mat")
% 
% for i=1:8
%     figure(1)
%     colormap('gray')
%     subplot(2,4,i)
%     psnr_i = psnr(x(:,:,i)/nor,vgaptv(:,:,i));
%     ssim_i = ssim(x(:,:,i)/nor,vgaptv(:,:,i));
%     imagesc(vgaptv(:,:,i)); title({['PSNR : ' num2str(psnr_i, '%.4f')], ['SSIM : ' num2str(ssim_i, '%.4f')]});
% end
% 
% psnr_gaptv = psnr(x/nor,vgaptv);
% ssim_gaptv = ssim(x/nor,vgaptv);
% 
% for i=1:8
%     figure(2)
%     colormap('gray')
%     imagesc(vgaptv(:,:,i)); title({['PSNR : ' num2str(psnr_gaptv, '%.4f')], ['SSIM : ' num2str(ssim_gaptv, '%.4f')]});
%     pause(0.5)
% end

%%
load("ours.mat")
for i=1:8
    figure(3)
    colormap('gray')
    subplot(2,4,i)
    psnr_i = psnr(x(:,:,i)/nor,x_ista(:,:,i)/nor);
    ssim_i = ssim(x(:,:,i)/nor,x_ista(:,:,i)/nor);
    imagesc(x_ista(:,:,i)); title({['PSNR : ' num2str(psnr_i, '%.4f')], ['SSIM : ' num2str(ssim_i, '%.4f')]});
end

psnr_ista = psnr(x/nor,x_ista/nor);
ssim_ista = ssim(x/nor,x_ista/nor);
for i=1:8
    figure(4)
    colormap('gray')
    imagesc(x_ista(:,:,i)); title({['PSNR : ' num2str(psnr_ista, '%.4f')], ['SSIM : ' num2str(ssim_ista, '%.4f')]});
    %pause(0.5)
end
