%% 主文件
clear ;
close all;
home;

bFig = true;
bTest = false;
%% DATASET
load("kobe32_cacti.mat") % orig,meas,mask（原始图像，压缩图像，压缩时用的mask
test_data = 1; % meas帧数

% 图像某块的位置，n为块的大小
x_1 = 1;
x_2 = 128;
y_1 = 1;
y_2 = 128;
n = 128;

x_1 = 65;
x_2 = 128;
y_1 = 65;
y_2 = 128;
n = 64;

x_1 = 81;
x_2 = 96;
y_1 = 97;
y_2 = 112;
n = 16;

x_1 = 65;
x_2 = 96;
y_1 = 97;
y_2 = 128;
n = 32;

codedNum = 1; % 多少帧压缩成一帧，对kobe正常是8
% 测试使用的投影结果y，是用投影矩阵直接对原始图像进行投影得到的
for k = test_data
%% DATA PROCESS
    if exist('orig','var')
        bOrig   = true;
        x       = orig(x_1:x_2,y_1:y_2,(k-1)*codedNum+1:(k-1)*codedNum+codedNum);
        if max(x(:))<=1
            x       = x * 255;
        end
    else
        bOrig   = false;
        x       = zeros(size(mask));
    end
    if ~bOrig
        bTest = false;
    end
    M = mask(x_1:x_2,y_1:y_2,1:codedNum);
    captured = meas(x_1:x_2,y_1:y_2,k);
    L       = 1e4; % 投影数越大，恢复效果越好
    s       = 2; % s越小，投影矩阵中的非零元素越多
    niter   = 10; % 投影次数（之后取期望
%% RUN
    tic
    % x_rp	= random_projection(L,s,n,niter,M,captured,x); % 优化了内存问题，都是计算得慢
    x_rp	= random_projection_without_optimization(L,s,n,niter,M,captured,x,bTest);
    time = toc;
    % x_rp = TV_denoising(x_rp/255,0.05,10)*255;
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

% 直接观测投影出的矩阵之间的差距
% [Phi,y] = generate_without_optimization(100,256,8,2,mask,captured,x);
% Phi = reshape(Phi,[100,256*8]);
% y_ = Phi*x(:)/sqrt(100); % y和y_不同
% Phi = reshape(Phi,[100,256,8]);
% [Phi,y__] = generate_test(100,256,8,2,x,false);