%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% 先对图像的局部进行测试
function rec  = random_projection(L,s,n,iteration,mask,captured,orig,bParfor,bRandom)
    [width, height, frames] = size(orig);
    N = n*n;

    % 单位根
    w = exp(-2*pi*(1i)/n);
    % 对每个ite和k，psi都一样，都是fft2的矩阵
    dft = ones(n,n);
    for i=2:n
        for j=2:n
            dft(i,j) = w^((i-1)*(j-1));
        end
    end
    psi = kron(dft,dft);
    
    if bParfor
        theta = cell(frames,1);
    else
        theta = zeros(N*frames,1);
    end
    % 做iteration次，求取期望
    for ite = 1:iteration
        disp(ite)
        % 随机初始化Phi（应该利用已知的mask生成，这里先测试随机的一个
        if bRandom
            [Phi,y] = generate_test(L,N,frames,s,orig,false);
        else
            [Phi,y] = generate(L,N,frames,s,mask,captured);
        end
              

        % 拆开对k个二维图片分别操作
        if bParfor
            parfor k = 1:frames
                theta_k = zeros(N,1);
                for i =1:N
                    x = Phi(:,:,k)*(psi(i,:)).';
                    theta_k =  y'*x/L;
                end
                theta(k) = {theta{k}+theta_k};
            end
        else
            for k = 1:frames
                 for i =1:N
                    x = Phi(:,:,k)*(psi(i,:)).';
                    theta((k-1)*N+i) = theta((k-1)*N+i) + y'*x/L;
                end
            end
        end
    end
    
    if bParfor
        theta = cell2mat(theta);
    end
    theta = theta/iteration;
    rec = reshape(theta,[width, height, frames]);
    rec = real(ifft2(rec));
end
