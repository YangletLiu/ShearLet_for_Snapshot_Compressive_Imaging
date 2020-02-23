%%
%clear ;
close all;
home;

bGPU = false;
bReal = false;
load("toy31_cassi.mat") % orig,meas,mask
codedNum = 31;
test_data = 1;

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
    bShear = false;
    bFig = false;
    sigma = @(ite) 0;
    LAMBDA  = @(ite) 5;  
    L       = 25;
    niter   = 800; 
    A       = @(x) sample(M,x,codedNum);
    AT      = @(y) sampleH(M,y,codedNum,bGPU);

    %% INITIALIZATION
    if bOrig
        y       = sample(M,x,codedNum);
        %y == meas
    else
        y       = meas(:,:,1);
    end
    x0      = zeros(size(x));
    if bGPU 
        y = gpuArray(single(y));
        x0 = gpuArray(single(x0));
    end
    L1              = @(x) norm(x, 1);
    L2              = @(x) power(norm(x, 'fro'), 2);
    COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
    COST.function	= @(X,ite) 1/2 * L2(A(X) - y) + LAMBDA(ite) * L1(X(:));

%% RUN
    tic
    x_ista	= SeSCI(A, AT, x0, y, LAMBDA, L, sigma, niter, COST, bFig, bGPU,bShear,bReal);
    x_ista = real(ifft2(x_ista));
    if bGPU
        x_ista = gather(x_ista);
    end

    time = toc;
    x_ista = TV_denoising(x_ista/255,0.05,10)*255; 
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

            psnr_x_ista(i) = psnr(x_ista(:,:,i)./nor, x(:,:,i)./nor, max(max(max(double(x(:,:,i)./nor))))); % 应该算平均值，这里暂留，已经在show中修改了
            ssim_x_ista(i) = ssim(x_ista(:,:,i)./nor, x(:,:,i)./nor);
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

    save(sprintf("results/fft_toy_%d.mat",k))
end