%% 主文件
clear ;
close all;
home;

bFig = true;
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

x_1 = 65;
x_2 = 96;
y_1 = 97;
y_2 = 128;
n = 32;

x_1 = 81;
x_2 = 96;
y_1 = 97;
y_2 = 112;
n = 16;

from_which = 0;
codedNum = 1; % 多少帧压缩成一帧，对kobe正常是8
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
    L       = 30000; % 投影数越大，恢复效果越好
    s       = 2; % s越小，投影矩阵中的非零元素越多
    niter   = 1; % 投影次数（之后取期望
    bTest = false;
%% Debug
    % estimate
    N = n*n;
    psi = fourier_full(n);
    estimated_theta = zeros(N*codedNum,1);
    % 做iteration次，求取期望
    for ite = 1:niter
        disp(ite)
        % 随机初始化Phi（应该利用已知的mask生成，这里先测试随机的一个
        if bTest % 使用完全随机生成的测试投影矩阵
            [Phi,y] = generate_test(L,N,codedNum,s,x,true);
        else % 使用利用SCI构造的投影矩阵
            [Phi,y] = generate_without_optimization(L,N,codedNum,s,M,captured,x);
        end
        estimated_theta = estimate_product(L,N,codedNum,Phi,psi,estimated_theta,y); % 做内积求取期望累加上去
    end
    % real
    real_theta = fft2(x);
    real_x = ifft2(real_theta); % x
    % estimated
    estimated_theta = estimated_theta/niter; 
    estimated_theta = reshape(estimated_theta,size(x)); % 第一个位置(1,1)处严重偏离，其他接近；纠正后时域上接近了
    % estimated_theta(1,1,:) = real_theta(1,1,:); % 在random下需要矫正这个偏移
    estimated_x = real(ifft2(estimated_theta));
    % apply fft2 using psi
    x_ = reshape(x,n*n,codedNum);
    psi_theta = psi*x_;
    psi_theta = reshape(psi_theta,size(x)); % the same as real_theta√
    psi_x = real(ifft2(psi_theta)); % the same as real_x√
    
    my_display(x,estimated_x,codedNum,bOrig);
end