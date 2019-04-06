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

L2 = 10; 

otherFrames = rand([1,N,f]);
f1 = M(1:256);
f2 = M(257:512);
f12 = f1.*f2;

estimated_theta = zeros(1,cal_num);
for ite =1:L2
    L1 = 1e4;
    Phi = zeros(L1,NN);
    y = zeros(L1,1);
    for j=1:L1
        order = randperm(N); 
        % 这里取正负是考虑到由mask中的元素确定的正负是确定的，否则L行中某列上只要非零就都相同
        ps = order(1:N/2);
        ns = order(1+N/2:N);
        Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,f);
        Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,f);
    end
       
%     order = randperm(N*f*L1);
%     nonzero_num = N*f*L1;
%     positive = order(1:nonzero_num/40*21);
%     negtive = order(nonzero_num/40*21+1:nonzero_num);
%     Phi(positive) = 1;
%     Phi(negtive) = -1;
%     
%     otherFrames(otherFrames<0.5) = -1;
%     otherFrames(otherFrames>0.5) = 1;
%     for i=1:L1
%         for k=2:f
%             Phi(i,(k-1)*N+1:k*N) = Phi(i,1:N).*otherFrames(:,:,k);
%         end
%     end
    
    means = mean(Phi(:)) % 均值
    var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*f) % 方差
    
    u = Phi*x;
    v = Phi*dft; % 对称，行列一样
    
    bias = 0;
    for j=1:256
        bias = bias + f12(j)*u(j)*v(j+256,:)+f12(j)*u(j+256)*v(j,:);   
    end
    
    estimated_theta = estimated_theta + (u'*v-bias)/L1;
end

estimated_theta = estimated_theta/L2;

real_theta = fft(x);
estimated_theta = estimated_theta.';
error = norm(estimated_theta-real_theta);

estimated_x = real(ifft(estimated_theta));
estimated_x = reshape(estimated_x,[n,n,f]);
my_display(reshape(x,[n,n,f]),estimated_x,f,true)

function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for ite =1:f
        vec(N*(ite-1)+idx) = M(N*(ite-1)+idx);
    end
end