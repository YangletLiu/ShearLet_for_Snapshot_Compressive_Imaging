clear all;
load("kobe32_cacti.mat")

%% 分块构造mask，消除振动方向上的相关性       
% mask_ = zeros(512,256);
% order = randperm(512*256); 
% mask_(order(1:256*256)) = 1;
% frames = 8;
% mask = zeros(256,256,frames);
% for ite =1:frames
%     mask(:,:,ite) = mask_((ite-1)*32+1:ite*32+224,:); % 设定32行无重叠
% end

bDebias = true; % 是否消除帧间相关带来的误差

%% 采样
orig = orig(:,:,1:8);
meas = sum(orig.*mask,3);

%% 取出一小块初始化
f = 2; % 只对两帧做测试，多帧的偏差会更大
n = 16; % 下采样后图片的大小
step = 256/n;
x = orig(1:step:end,1:step:end,1:f);              
M = mask(1:n,1:n,1:f);
x = x(:);
M = M(:);
M(M==0)=-1; % 对采样矩阵操作，去直流分量

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
L2 = 10; 

if bDebias && f==2
    f1 = M(1:N); 
    f2 = M(N+1:NN);
    f12 = f1.*f2; % 根据第一帧和第二帧的mask计算相关系数
end

%% 计算随机投影矩阵和投影
% estimated_thetaz第一个系数是平均值，不准确也可以，恢复出的图像只是有一个比例的误差
estimated_theta = zeros(1,NN);
for ite =1:L2
    L1 = 1e4;
    Phi = zeros(L1,NN);
    
% 直接由mask构造投影矩阵
    for j=1:L1
        order = randperm(N); 
        % 这里取正负是考虑到由mask中的元素确定的正负是确定的，否则L行中某列上只要非零就都相同
        ps = order(1:N/2/s);
        ns = order(1+N/2/s:N/s);
        Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,f);
        Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,f);
    end
    Phi = Phi*sqrt(s);
    % Phi(i,N+1:2*N) = Phi(i,1:N).*f12';实际上有这个关系
    means = mean(Phi(:)) % 均值
    var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*f) % 方差
    
    u = Phi*x;
    v = Phi*dft; % 对称，行列一样
    
    estimated_theta = estimated_theta + (u'*v)/L1; 
    
    if bDebias && f==2
        bias = 0;
        for j=1:N
            bias = bias + f12(j)*x(j)*dft(j+N,:)+f12(j)*x(j+N)*dft(j,:);   % 由相关性造成的误差
        end
        estimated_theta = estimated_theta - bias;
    end
    
end
estimated_theta = estimated_theta/L2;

%% 后续观察
real_theta = fft(x);
estimated_theta = estimated_theta.';

estimated_x = real(ifft(estimated_theta));
my_display(reshape(x,[n,n,f]),reshape(estimated_x,[n,n,f]),f,true)

%% 提取mask中的对应位置
function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for ite =1:f
        vec(N*(ite-1)+idx) = M(N*(ite-1)+idx);
    end
end