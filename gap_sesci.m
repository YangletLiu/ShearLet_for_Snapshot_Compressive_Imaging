%%
%clear ;
close all;
home;

bGPU = false;
bReal = false;
%% DATASET
% load("traffic8_cacti.mat") % orig,meas,mask
% codedNum = 8;
% test_data = 1;
% 
load("kobe32_cacti.mat") % orig,meas,mask
codedNum = 8;
test_data = 1;

% 
% load("4park8_cacti.mat") % orig,meas,mask
% codedNum = 8;
% test_data = 1;

for k = test_data
%% DATA PROCESS
    if exist('orig','var')
        bOrig   = true;
        x       = orig(:,:,(k-1)*codedNum+1:(k-1)*codedNum+codedNum);
        if max(x(:))<=1
            x       = x * 255;
        end
    else
        bOrig   = false;
        x       = zeros(size(mask));
    end
    M = mask; 
    if bGPU 
        M = gpuArray(single(M));
    end
    acc = true;
    bShear = true;
    bFig = true;
    sigma = 10;
    LAMBDA  = 10;  
    niter   = 30; 
    L       = @(ite) 1;
    A       = @(x) sample(M,x,codedNum);
    AT      = @(y) sampleH(M,y,codedNum,bGPU);
    Phisum = sum(mask.^2,3);
    Phisum(Phisum==0) = 1;

    %% INITIALIZATION
    if bOrig
        y       = sample(M,x,codedNum);
    else
        y       = meas(:,:,1);
    end
    if bGPU 
        y = gpuArray(single(y));
        x0 = gpuArray(single(x0));
    end
    L1              = @(x) norm(x, 1);
    L2              = @(x) power(norm(x, 'fro'), 2);
    COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
    COST.function	= @(X) 1/2 * L2(A(ifft2(X)) - y) + LAMBDA * L1(X(:));
    x = x/255;
    y = y/255;
    x0 = AT(y); 
%% RUN
    tic
    x_ista	= GAP(A, AT, x0, y, LAMBDA, L, sigma, niter, COST, bFig, bGPU,bShear,bReal,acc,Phisum);
    time = toc;
    x_ista = real(x_ista);
    if bGPU
        x_ista = gather(x_ista);
    end
%     x_ista = TV_denoising(x_ista,0.05,10);
    nor         = max(x(:));
    psnr_x_ista = zeros(codedNum,1);
    ssim_x_ista = zeros(codedNum,1);
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
            imagesc(x_ista(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 

            psnr_x_ista(i) = psnr(x_ista(:,:,i), x(:,:,i)); % 应该算平均值，这里暂留，已经在show中修改了
            ssim_x_ista(i) = ssim(x_ista(:,:,i), x(:,:,i));
            title({['frame : ' num2str(i, '%d')], ['PSNR : ' num2str(psnr_x_ista(i), '%.4f')], ['SSIM : ' num2str(ssim_x_ista(i), '%.4f')]});
        else 
            colormap gray;
            imagesc(x_ista(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 
            title(['frame : ' num2str(i, '%d')]);
        end
        pause(1);
    end
    psnr_ista = mean(psnr_x_ista);
    ssim_ista = mean(ssim_x_ista);

    %save(sprintf("results/traffic/ours_traffic%d.mat",k))
end