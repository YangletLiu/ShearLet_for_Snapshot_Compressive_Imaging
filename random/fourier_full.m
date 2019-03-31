% 生成二维傅里叶变换矩阵的基
function dft = fourier_full(n)    
    % 单位根
    n = n*n;
    w = exp(-2*pi*(1i)/n);
    % 对每个ite和k，psi都一样，都是fft2的矩阵，所以预先求解
    dft = ones(n,n);
    for j=2:n
        for k=2:n
            dft(j,k) = w^((j-1)*(k-1));
        end
    end
end