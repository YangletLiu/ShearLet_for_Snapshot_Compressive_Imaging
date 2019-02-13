load("kobe32_cacti.mat");
nor = max(max(max(orig(:,:,1:8))));
x = orig(:,:,1:8);
psnr_i = zeros(8,1);
ssim_i = zeros(8,1);
%%
% load("GMM-TP.mat")
% clear psnr;
% clear ssim;
% x_gmm1 = Xpre;
% for i=1:8
%     figure(3)
%     colormap('gray')
%     subplot(2,4,i)
%     psnr_i(i) = psnr(x(:,:,i)/nor,x_gmm1(:,:,i)/nor);
%     ssim_i(i) = ssim(x(:,:,i)/nor,x_gmm1(:,:,i)/nor);
%     imagesc(x_gmm1(:,:,i)); title({['PSNR : ' num2str(psnr_i(i), '%.4f')], ['SSIM : ' num2str(ssim_i(i), '%.4f')]}); 
%     set(gca,'xtick',[],'ytick',[]); 
% end
% 
% psnr_gmm1 = mean(psnr_i);
% ssim_gmm1 = mean(ssim_i);
% for i=1:8
%     figure(4)
%     colormap('gray')
%     imagesc(x_gmm1(:,:,5)); title({['PSNR : ' num2str(psnr_gmm1, '%.4f')], ['SSIM : ' num2str(ssim_gmm1, '%.4f')]});
%     set(gca,'xtick',[],'ytick',[]); 
%     pause(0.5)
% end

%%
% load("MMLE-GMM_park3.mat")
% clear psnr;
% clear ssim;
% x_gmm2 = Xpre(:,:,1:8);
% for i=1:8
%     figure(3)
%     colormap('gray')
%     subplot(2,4,i)
%     psnr_i(i) = psnr(Xtst(:,:,i)/nor,x_gmm2(:,:,i)/nor);
%     ssim_i(i) = ssim(Xtst(:,:,i)/nor,x_gmm2(:,:,i)/nor);
%     imagesc(x_gmm2(:,:,i)); title({['PSNR : ' num2str(psnr_i(i), '%.4f')], ['SSIM : ' num2str(ssim_i(i), '%.4f')]});
% end
% 
% psnr_gmm2 = mean(psnr_i);
% ssim_gmm2 = mean(ssim_i);
% for i=1:8
%     figure(4)
%     colormap('gray')
%     imagesc(x_gmm2(:,:,4)); title({['PSNR : ' num2str(psnr_gmm2, '%.4f')], ['SSIM : ' num2str(ssim_gmm2, '%.4f')]});
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
%     psnr_i(i) = psnr(x(:,:,i)/nor,x_mfa(:,:,i)/nor);
%     ssim_i(i) = ssim(x(:,:,i)/nor,x_mfa(:,:,i)/nor);
%     imagesc(x_mfa(:,:,i)); title({['PSNR : ' num2str(psnr_i(i), '%.4f')], ['SSIM : ' num2str(ssim_i(i), '%.4f')]});
%     set(gca,'xtick',[],'ytick',[]);  
% end
% 
% psnr_mfa = mean(psnr_i);
% ssim_mfa = mean(ssim_i);
% for i=1:8
%     figure(4)
%     colormap('gray')
%     imagesc(x_mfa(:,:,4)); title({['PSNR : ' num2str(psnr_mfa, '%.4f')], ['SSIM : ' num2str(ssim_mfa, '%.4f')]});
%     set(gca,'xtick',[],'ytick',[]); 
%     pause(0.5)
% end

%%
% load("GAP_TV.mat")
% for i=1:8
%     figure(1)
%     colormap('gray')
%     subplot(2,4,i)
%     psnr_i(i) = psnr(x(:,:,i)/nor,vgaptv(:,:,i));
%     ssim_i(i) = ssim(x(:,:,i)/nor,vgaptv(:,:,i));
%     imagesc(vgaptv(:,:,i)); title({['PSNR : ' num2str(psnr_i(i), '%.4f')], ['SSIM : ' num2str(ssim_i(i), '%.4f')]}); 
%     set(gca,'xtick',[],'ytick',[]); 
% end
% 
% psnr_gaptv = mean(psnr_i);
% ssim_gaptv = mean(ssim_i);
% 
% for i=1:8
%     figure(2)
%     colormap('gray')
%     imagesc(vgaptv(:,:,4)); title({['PSNR : ' num2str(psnr_gaptv, '%.4f')], ['SSIM : ' num2str(ssim_gaptv, '%.4f')]});
%     set(gca,'xtick',[],'ytick',[]); 
%     %pause(0.5)
% end

%%
load("ours_1.mat")
for i=1:8
    figure(3)
    colormap('gray')
    subplot(2,4,i)
    psnr_i(i) = psnr(x(:,:,i)/nor,x_ista(:,:,i)/nor);
    ssim_i(i) = ssim(x(:,:,i)/nor,x_ista(:,:,i)/nor);
    imagesc(x_ista(:,:,i)); title({['PSNR : ' num2str(psnr_i(i), '%.4f')], ['SSIM : ' num2str(ssim_i(i), '%.4f')]});
    set(gca,'xtick',[],'ytick',[]); 
end

psnr_ista = mean(psnr_i);
ssim_ista = mean(ssim_i);
for i=1:8
    figure(4)
    colormap('gray')
    imagesc(x_ista(:,:,4)); 
    title({['PSNR : ' num2str(psnr_ista, '%.4f')], ['SSIM : ' num2str(ssim_ista, '%.4f')]});
    set(gca,'xtick',[],'ytick',[]); 
    %pause(0.5)
end
