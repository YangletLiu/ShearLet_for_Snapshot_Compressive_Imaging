%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% 内存占用高的版本，运行较快
% 先对图像的局部进行测试
function rec  = random_projection_without_optimization(L,s,n,iteration,mask,captured,orig,bTest)
    [width, height, frames] = size(orig);
    N = n*n;
    psi = fourier_full(n);
    theta = zeros(N*frames,1);
    % 做iteration次，求取期望
    otherFrames = rand([1,N,frames]);
    for ite = 1:iteration
        disp(ite)
        % 随机初始化Phi（应该利用已知的mask生成，这里先测试随机的一个
        if bTest % 使用完全随机生成的测试投影矩阵
            [Phi,y] = generate_test(L,N,frames,s,orig,true,otherFrames);
        else % 使用利用SCI构造的投影矩阵
            [Phi,y] = generate_without_optimization(L,N,frames,s,mask,captured,orig);
        end
        theta = estimate_product(L,N,frames,Phi,psi,theta,y); % 做内积求取期望累加上去
    end
    theta = theta/iteration; 
    for f = 1:frames
        theta((f-1)*N+1:f*N) = real(ifft(theta((f-1)*N+1:f*N)));
    end
    rec = reshape(theta,[width, height, frames]); % 频域系数
end
