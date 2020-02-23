%%
%clear ;
close all;
home;
% 数据中的orig是TwIST的计算结果
bGPU = false;
bReal = false;
load("object33_cassi.mat") % orig,meas,mask
codedNum = 33;
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
    bShear = true;
    bFig = true;
    sigma = @(ite) 0.5;
    LAMBDA  = @(ite) 0.3;  
    L       = 25;
    niter   = 600; 
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
%% SeSCI
    COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
    COST.function	= @(X,ite) 1/2 * L2(A(X) - y) + LAMBDA(ite) * L1(X(:));
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
    
%% TNN + to do refinement
%     tic
%     
%     y = double(y(:));
%     [n1,n2,n3] = size(x);  
%     gamma = 1e-2;
%     niter = 30;
%     w0 = 100;
%     w1 = 10;
%     w = @(ite,iteration) w0*max(0,(1-ite/iteration)^w1);
%     A = [];     
%     for i=1:n3
%        S=diag(sparse(double(mask(n1*n2*(i-1)+1:n1*n2*i))));
%        A=[A,S];
%     end
%     COST.equation   = '1/2 * || A*X - Y ||_2^2 + lambda * || X ||_TNN';
%     COST.function	= @(X) 1/2 * L2(A*X - y) + nuclear(X);
%     COST.equation   = '1/2 * || A*X - Y ||_2^2';
%     COST.function	= @(X) 1/2 * L2(A*X - y);
%     x_ista	= TNN(A, [n1,n2,n3], y, gamma, w, niter, COST, bFig);

   
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

    save("results/ours_object.mat")
end