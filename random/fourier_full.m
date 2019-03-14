% 生成二维傅里叶变换矩阵的基
function psi = fourier_full(n)    
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
end