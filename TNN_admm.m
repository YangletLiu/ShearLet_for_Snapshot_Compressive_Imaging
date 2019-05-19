%% Reference
% https://people.rennes.inria.fr/Cedric.Herzet/Cedric.Herzet/Sparse_Seminar/Entrees/2012/11/12_A_Fast_Iterative_Shrinkage-Thresholding_Algorithmfor_Linear_Inverse_Problems_(A._Beck,_M._Teboulle)_files/Breck_2009.pdf

%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)

%%
clear ;
close all;
home;

bReal = false;
%% DATASET
load("kobe32_cacti.mat") % orig,meas,mask
codedNum = 8;
test_data = 1;
% 

for k = test_data
%% DATA PROCESS
    x       = orig(:,:,(k-1)*codedNum+1:(k-1)*codedNum+codedNum);
    if max(x(:))<=1
        x       = x * 255;
    end
    gamma = 0.005;
    bFig = true;
    w = 1e2;
    niter   = 200; 
    [n1,n2,n3] = size(x);                    
    A = [];     
    for i=1:n3
       S=diag(sparse(double(mask(n1*n2*(i-1)+1:n1*n2*i))));
       A=[A,S];
    end

    %% INITIALIZATION
    y       = meas(:,:,k);
    y = y(:);
    L2              = @(x) power(norm(x, 'fro'), 2);
    COST.equation   = '1/2 * || A*X - Y ||_2^2 + lambda * || X ||_TNN';
    COST.function	= @(X) 1/2 * L2(A*X - y) + nuclear(X);

%% RUN
    tic
    x_ista	= TNN(A, [n1,n2,n3], y, gamma, w, niter, COST, bFig);
    time = toc;
    %x_ista = TV_denoising(x_ista/255,0.05,10)*255;
    nor         = max(x(:));
    psnr_x_ista = zeros(codedNum,1);
    ssim_x_ista = zeros(codedNum,1);
%% DISPLAY
    figure(1); 
    for i=1:codedNum
        colormap gray;
        subplot(121);   
        imagesc(x(:,:,i));
        set(gca,'xtick',[],'ytick',[]);
        title('orig');

        subplot(122);   
        imagesc(x_ista(:,:,i));  	
        set(gca,'xtick',[],'ytick',[]); 

        psnr_x_ista(i) = psnr(x_ista(:,:,i)./nor, x(:,:,i)./nor); % 应该算平均值，这里暂留，已经在show中修改了
        ssim_x_ista(i) = ssim(x_ista(:,:,i)./nor, x(:,:,i)./nor);
        title({['frame : ' num2str(i, '%d')], ['PSNR : ' num2str(psnr_x_ista(i), '%.4f')], ['SSIM : ' num2str(ssim_x_ista(i), '%.4f')]});
        pause(1);
    end
    psnr_ista = mean(psnr_x_ista);
    ssim_ista = mean(ssim_x_ista);

    %save(sprintf("results/traffic/ours_traffic%d.mat",k))
end