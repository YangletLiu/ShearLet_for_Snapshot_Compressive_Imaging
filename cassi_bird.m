%% Reference
% https://people.rennes.inria.fr/Cedric.Herzet/Cedric.Herzet/Sparse_Seminar/Entrees/2012/11/12_A_Fast_Iterative_Shrinkage-Thresholding_Algorithmfor_Linear_Inverse_Problems_(A._Beck,_M._Teboulle)_files/Breck_2009.pdf

%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)

%%
%clear ;
close all;
home;

bGPU = true;
bReal = false;
% load("toy31_cassi.mat") % orig,meas,mask
% codedNum = 31;
load("bird24_cassi.mat") % orig,meas,mask
codedNum = 24;
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
    bFig = false;
    sigma = 0.3;
    LAMBDA  = 5;  
    L       = 25;
    niter   = 20; 
    A       = @(x) sample(M,ifft2(x),codedNum);
    AT      = @(y) fft2(sampleH(M,y,codedNum,bGPU));

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
    COST.function	= @(X) 1/2 * L2(A(X) - y) + LAMBDA * L1(X(:));

%% RUN
    tic
    
%     y = double(y(:));
%     [n1,n2,n3] = size(x);  
%     gamma = 1e-2;
%     niter = 30;
%     w0 = 800;
%     w1 = 10;
%     w = @(ite,iteration) w0*max(0,(1-3*ite/iteration)^w1);
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
    
    x_ista	= MFISTA(A, AT, x0, y, LAMBDA, L, sigma, niter, COST, bFig, bGPU,bShear,bReal);
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
%     figure(1); 
%     for i=1:codedNum
%         if bOrig
%             colormap gray;
%             subplot(121);   
%             imagesc(x(:,:,i));
%             set(gca,'xtick',[],'ytick',[]);
%             title('orig');
% 
%             subplot(122);   
%             imagesc(x_ista(:,:,i));  	
%             set(gca,'xtick',[],'ytick',[]); 
% 
%             psnr_x_ista(i) = psnr(x_ista(:,:,i)./nor, x(:,:,i)./nor, max(max(max(double(x(:,:,i)./nor))))); % 应该算平均值，这里暂留，已经在show中修改了
%             ssim_x_ista(i) = ssim(x_ista(:,:,i)./nor, x(:,:,i)./nor);
%             title({['frame : ' num2str(i, '%d')], ['PSNR : ' num2str(psnr_x_ista(i), '%.4f')], ['SSIM : ' num2str(ssim_x_ista(i), '%.4f')]});
%         else 
%             colormap gray;
%             imagesc(x_ista(:,:,i));  	
%             set(gca,'xtick',[],'ytick',[]); 
%             title(['frame : ' num2str(i, '%d')]);
%         end
%         pause(1);
%     end
%     psnr_ista = mean(psnr_x_ista);
%     ssim_ista = mean(ssim_x_ista);

    %save(sprintf("results/traffic/ours_traffic%d.mat",k))
end