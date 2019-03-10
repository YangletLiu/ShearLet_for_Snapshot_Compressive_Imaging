%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% 内存占用高的版本，运行较快
% 先对图像的局部进行测试
function rec  = random_projection_without_optimization(L,s,n,iteration,mask,captured,orig,bTest)
    [width, height, frames] = size(orig);
    N = n*n;

    % 单位根
    w = exp(-2*pi*(1i)/n);
    % 对每个ite和k，psi都一样，都是fft2的矩阵，所以预先求解
    dft = ones(n,n);
    for i=2:n
        for j=2:n
            dft(i,j) = w^((i-1)*(j-1));
        end
    end
    psi = kron(dft,dft); % 2d-fft basis matrix
    
    theta = zeros(N*frames,1);
    % 做iteration次，求取期望
    for ite = 1:iteration
        disp(ite)
        % 随机初始化Phi（应该利用已知的mask生成，这里先测试随机的一个
        if bTest % 使用完全随机生成的测试投影矩阵
            [Phi,y] = generate_test(L,N,frames,s,orig,true);
        else % 使用利用SCI构造的投影矩阵
            [Phi,y] = generate_without_optimization(L,N,frames,s,mask,captured,orig);
        end
        % 拆开对k个二维图片分别操作
        % 投影后的向量做内积，求和求期望
        for k = 1:frames
            x = Phi(:,:,k)*(psi).';
            theta((k-1)*N+1:k*N) = theta((k-1)*N+1:k*N) + (y'*x).'/sqrt(L);
        end
    end
    theta = theta/iteration; 
    rec = reshape(theta,[width, height, frames]); % 频域系数
    rec = real(ifft2(rec));
end
