%%
clear ;
close all;
home;

bFig = true;
bGPU = false;
%% DATASET
load("kobe32_cacti.mat") % orig,meas,mask
codedNum = 8;
test_data = 1;

%% Verify Lemma 2
test = orig(:,:,1:8);
testf = fft2(test);
testm = max(testf(:)); % L_inf
tests = sum(sum(sum(test.*conj(test)))); % L2
testr = testm/tests;
lemmar = 11/(32*sqrt(2)); % log2048/(sqrt(2048))

for k = test_data
%% DATA PROCESS
    if exist('orig','var')
        bOrig   = true;
        x       = orig(65:128,65:128,(k-1)*codedNum+1:(k-1)*codedNum+codedNum);
        if max(x(:))<=1
            x       = x * 255;
        end
    else
        bOrig   = false;
        x       = zeros(size(mask));
    end
    n       = 64;
    s       = 8; % sԽ�����ͶӰ�����е�0Խ�࣬Ϊ�����Ϊ2��ָ����
    niter   = 5; 
%% RUN
    tic
    x_rp	= random_projection(s,n,niter,x);
    time = toc;
    % x_rp = TV_denoising(x_rp/255,0.05,10)*255;
    nor         = max(x(:));
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

            psnr_x_rp(i) = psnr(x_rp(:,:,i)./nor, x(:,:,i)./nor); % Ӧ����ƽ��ֵ�������������Ѿ���show���޸���
            ssim_x_rp(i) = ssim(x_rp(:,:,i)./nor, x(:,:,i)./nor);
            title({['frame : ' num2str(i, '%d')], ['PSNR : ' num2str(psnr_x_rp(i), '%.4f')], ['SSIM : ' num2str(ssim_x_rp(i), '%.4f')]});
        else 
            colormap gray;
            imagesc(x_rp(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 
            title(['frame : ' num2str(i, '%d')]);
        end
        pause(1);
    end
    psnr_ista = mean(psnr_x_rp);
    ssim_ista = mean(ssim_x_rp);

    %save(sprintf("results/traffic/ours_traffic%d.mat",k))
end