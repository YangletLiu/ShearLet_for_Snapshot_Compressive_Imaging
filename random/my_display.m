function my_display(x,x_rp,codedNum,bOrig)
%% 将图片归一
    nor         = 255;
    ratio  = max(max(x))/nor; % 原图中该块相对255的系数
    min_rp = min(min(x_rp));
    max_rp = max(max(x_rp));
    nor_rp = max_rp-min_rp;
    for f=1:codedNum
        x_rp(:,:,f) = (x_rp(:,:,f)-min_rp(f))/nor_rp(f)*ratio(f);
    end
    psnr_x_rp = zeros(codedNum,1);
    ssim_x_rp = zeros(codedNum,1);
%% DISPLAY
    figure(1); 
    for i=1:codedNum
        if bOrig
            colormap gray;
            subplot(121);   
            imagesc(x(:,:,i));
            set(gca,'xtick',[],'ytick',[]);
            title('orig');

            subplot(122);   
            imagesc(x_rp(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 

            psnr_x_rp(i) = psnr(x_rp(:,:,i), x(:,:,i)./nor);
            ssim_x_rp(i) = ssim(x_rp(:,:,i), x(:,:,i)./nor);
            title({['frame : ' num2str(i, '%d')], ['PSNR : ' num2str(psnr_x_rp(i), '%.4f')], ['SSIM : ' num2str(ssim_x_rp(i), '%.4f')]});
        else 
            colormap gray;
            imagesc(x_rp(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 
            title(['frame : ' num2str(i, '%d')]);
        end
        pause(1);
    end
    psnr_rp = mean(psnr_x_rp);
    ssim_rp = mean(ssim_x_rp);
end