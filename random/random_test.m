%%
clear ;
close all;
home;

bFig = true;
bParfor = false;
bRandom = false;
%% DATASET
load("kobe32_cacti.mat") % orig,meas,mask
codedNum = 8;
test_data = 1;

%% Verify Lemma 2
% test = orig(:,:,1:8);
% testf = fft2(test);
% testm = max(testf(:)); % L_inf
% tests = sum(sum(sum(test.*conj(test)))); % L2
% testr = testm/tests;
% lemmar = 11/(32*sqrt(2)); % log2048/(sqrt(2048))
% M =0.25;

for k = test_data
%% DATA PROCESS
    if exist('orig','var')
        bOrig   = true;
        x       = orig(81:96,97:112,(k-1)*codedNum+1:(k-1)*codedNum+codedNum);
        if max(x(:))<=1
            x       = x * 255;
        end
    else
        bOrig   = false;
        x       = zeros(size(mask));
    end
    if ~bOrig
        bRandom = false;
    end
    M = mask(81:96,97:112,:);
    captured = meas(81:96,97:112,k);
    n       = 16;
    L       = 2000;
    s       = 8; % s越大，随机投影矩阵中的0越多，为简便设为2的指数次
    niter   = 100; 
%% RUN
    if bParfor
      mycluster = parcluster('local');
      delete(gcp('nocreate')); % delete current parpool
      poolobj = parpool(mycluster,mycluster.NumWorkers);
    end
    tic
    x_rp	= random_projection(L,s,n,niter,M,captured,x,bParfor,bRandom);
    time = toc;
    if bParfor
        delete(poolobj);
    end
    % x_rp = TV_denoising(x_rp/255,0.05,10)*255;
    nor         = 255;
    ratio  = max(max(x))/nor;
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

            psnr_x_rp(i) = psnr(x_rp(:,:,i), x(:,:,i)./nor); % 应该算平均值，这里暂留，已经在show中修改了
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