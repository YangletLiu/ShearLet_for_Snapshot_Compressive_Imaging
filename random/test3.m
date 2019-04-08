clear all;
load("kobe32_cacti.mat")

%% 造mask       
mask_ = zeros(512,256);
order = randperm(512*256); 
mask_(order(1:256*256)) = 1;
frames = 8;
mask = zeros(256,256,frames);
for ite =1:frames
    mask(:,:,ite) = mask_((ite-1)*32+1:ite*32+224,:); % 设定32行无重叠
end
% 采样
orig = orig(:,:,1:8);
meas = sum(orig.*mask,3);

%% 取出一小块初始化
f = 2;
n = 16;
x = orig(1:n,1:n,1:f);              % 可以取32×256的
M = mask(1:n,1:n,1:f);
captured = meas(1:n,1:n,1);
x = x(:);
M = M(:);
captured = captured(:);
M(M==0)=-1;

N = n*n;
NN = N*f;
w = exp(-2*pi*(1i)/NN);
cal_num=NN; % 估计前几个系数
dft = ones(NN,cal_num);
for ite=1:NN
    for j=1:cal_num
        dft(ite,j) = w^((ite-1)*(j-1));
    end
end

%(dft*x-fft(x)) %验证dft做对了

L2 = 30; 

if f==2
    f1 = M(1:256); 
    f2 = M(257:512);
    f12 = f1.*f2; % 根据第一帧和第二帧的mask计算相关系数
end
% estimated_thetaz第一个系数是平均值，不准确也可以，恢复出的图像只是有一个比例的误差
estimated_theta = zeros(1,cal_num);
for ite =1:L2
    L1 = 1e4;
    Phi = zeros(L1,NN);
    
%     for j=1:L1
%         order = randperm(N); 
%         % 这里取正负是考虑到由mask中的元素确定的正负是确定的，否则L行中某列上只要非零就都相同
%         ps = order(1:N/2);
%         ns = order(1+N/2:N);
%         Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,f);
%         Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,f);
%     end
       
    % 另一个写法
    order = randperm(NN*L1);
    positive = order(1:NN*L1/40*21);
    negtive = order(NN*L1/40*21+1:NN*L1);
    Phi(positive) = 1;
    Phi(negtive) = -1;
    for i=1:L1
        Phi(i,N+1:2*N) = Phi(i,1:N).*f12';
    end
    
    means = mean(Phi(:)) % 均值
    var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*f) % 方差
    
    u = Phi*x;
    v = Phi*dft; % 对称，行列一样
    
    estimated_theta = estimated_theta + (u'*v)/L1;
    
    if f==2
        bias = 0;
        for j=1:256
            bias = bias + f12(j)*x(j)*dft(j+256,:)+f12(j)*x(j+256)*dft(j,:);   % 由相关性造成的误差
        end
        estimated_theta = estimated_theta - bias;
    end
    
end
estimated_theta = estimated_theta/L2;

real_theta = fft(x);
estimated_theta = estimated_theta.';
error = norm(estimated_theta-real_theta);

estimated_x = real(ifft(estimated_theta));
my_display(reshape(x,[n,n,f]),reshape(estimated_x,[n,n,f]),f,true)

function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for ite =1:f
        vec(N*(ite-1)+idx) = M(N*(ite-1)+idx);
    end
end