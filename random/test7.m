clear all;
load("kobe32_cacti.mat")

%% 采样
orig = orig(:,:,1:8);

%% 取出一小块初始化
f = 8; % 只对两帧做测试，多帧的偏差会更大
n = 16; % 下采样后图片的大小
x = orig(1:n,1:n,1:f);              
x = x(:);

N = n*n;
NN = N*f;
w = exp(-2*pi*(1i)/NN);
dft = ones(NN,NN);
for ite=1:NN
    for j=1:NN
        dft(ite,j) = w^((ite-1)*(j-1));
    end
end

%(dft*x-fft(x)) %验证dft做对了
s = 1;
L2 = 1e5; 

%% 计算随机投影矩阵和投影
% estimated_thetaz第一个系数是平均值，不准确也可以，恢复出的图像只是有一个比例的误差
estimated_theta = zeros(1,NN);
tic;
for ite =1:L2
    Phi = zeros(NN);
    order = randperm(NN);
    ps = order(1:NN/2/s);
    ns = order(1+NN/2/s:NN/s);
    Phi(ps) = 1;
    Phi(ns) = -1;
    Phi = Phi*sqrt(s);
    % means = mean(Phi(:)) % 均值
    % var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*f) % 方差
    
    u = Phi*x;
    v = Phi*dft; % 对称，行列一样
    
    estimated_theta = estimated_theta + (u'*v); 
end
estimated_theta = estimated_theta/L2;
time = toc;
%% 后续观察
real_theta = fft(x);
estimated_theta = estimated_theta.';

estimated_x = real(ifft(estimated_theta));
my_display(reshape(x,[n,n,f]),reshape(estimated_x,[n,n,f]),f,true)
