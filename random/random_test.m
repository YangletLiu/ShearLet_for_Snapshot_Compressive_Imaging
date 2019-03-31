%% 主文件
clear ;
close all;
home;

bFig = true;
bTest = false;
%% Initialize
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

% x_1 = 65;
% x_2 = 96;
% y_1 = 97;
% y_2 = 128;
% n = 32;

from_which = 0;
codedNum = 2; % 多少帧压缩成一帧，对kobe正常是8
% 测试使用的投影结果y，是用投影矩阵直接对原始图像进行投影得到的
for k = test_data
%% DATA PROCESS
    if exist('orig','var')
        bOrig   = true;
        x       = orig(x_1:x_2,y_1:y_2,(k-1)*codedNum+1+from_which:(k-1)*codedNum+codedNum+from_which);
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
    L       = 1e3; % 投影数越大，恢复效果越好
    s       = 2; % s越小，投影矩阵中的非零元素越多
    niter   = 3; % 投影次数（之后取期望
%% RUN
    tic
    % x_rp	= random_projection(L,s,n,niter,M,captured,x); % 优化了内存问题，但是计算得慢
    x_rp	= random_projection_without_optimization(L,s,n,niter,M,captured,x,bTest);
    time = toc;
    % x_rp = TV_denoising(x_rp/255,0.05,10)*255;
%% Display
    my_display(x,x_rp,codedNum,bOrig);
end

% 直接观测投影出的矩阵之间的差距
% [Phi,y] = generate_without_optimization(100,256,8,2,mask,captured,x);
% Phi = reshape(Phi,[100,256*8]);
% y_ = Phi*x(:)/sqrt(100); % y和y_不同
% Phi = reshape(Phi,[100,256,8]);
% [Phi,y__] = generate_test(100,256,8,2,x,false);