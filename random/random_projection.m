%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% Phi N*8N （L*8N） (先默认L为N进行测试
% n设置为64，先对图像的局部进行测试
function rec  = random_projection(s,n,iteration,orig)
[width, height, frames] = size(orig);
N = n*n;
L = N; % 暂时如此

% 单位根
w = exp(2*pi/n);
% 生成basis vector psi_first，对每个ite和k，psi都一样，都是fft2的矩阵
psi_first = zeros(N,1);
psi_first(1) = 1;
for t = 2:N
    psi_first(t) = w*psi_first(t-1);
end

theta = zeros(N*frames,1);
% 做iteration次，求取期望
for ite = 1:iteration
    % 随机初始化Phi（应该利用已知的mask生成，这里先测试随机的一个
    Phi = zeros(width,height,frames);
    for k = 1:frames
        for i =1:n
            order = randperm(n);
            nonzero_num = n/s;
            positive = order(1:nonzero_num/2);
            negtive = order(nonzero_num/2+1:nonzero_num);
            Phi(i,positive,k) = 1;
            Phi(i,negtive,k) = -1;
        end
    end
    
    % 生成y=Phi*orig，这里因为拿得到orig为简便先这么写，实际数据时应该是根据Phi的生成方式，由meas仿照Phi生成y
    y = sample(Phi,orig,8);
    y = y(:);
    
    % 拆开对k个二维图片分别操作
    for k = 1:frames
        for i =1:N
            temp = Phi(:,:,k);
            x = temp(:).*((w^(i-1))*psi_first);
            theta((k-1)*N+i) = theta((k-1)*N+i) + y'*x;
        end
    end
    
end
    theta = theta/iteration;
    rec = reshape(theta,[width, height, frames]);
    rec = real(ifft2(rec));
end
