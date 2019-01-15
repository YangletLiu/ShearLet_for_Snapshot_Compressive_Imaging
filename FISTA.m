function X = FISTA(iteration,I,H,H_r,G,M,y,L,lambda)
    % the discarded f is the 2D-DFT block circulant matrix, we know that f^-1 = f^H = f', which means f^H can also be represented as ifft2 
    % I is the nShearlets of the number of shearlets
    % H is the shearlets
    % H_r is the dual of shearlets, H_ri = H_i./G
    % G is the dualFrameWeights in the calculation of shearlets
    % M is of size n¡Án, a mask matrix
    % y is the target n¡Án, we don't need do reduction so we can still use the square matrix instead of column of m¡Á1
    % L is the Lipschitz constant fo f_2's gradient
    % lambda is a parameter to balance sparseness and approximation
    s = zeros(size(H));
    S = zeros(size(H));
    B = fft2withShift(y); % here we only need to transform matrix y to the Fourier domain to initalize the X, or B
    X1 = B; 
    t1 = 1;
    for k=1:iteration
        D = B.*(1-1/L*M./G)+1/L*M.*fft2withShift(y)./G;
        X2 = 0;
        for i = 1:I
            u = real(ifft2withShift(conj(H(:,:,i)).*D));
            s(:,:,i) = prox(u,L,lambda);
            S(:,:,i) = fft2withShift(s(:,:,i));
            X2 = X2 + H_r(:,:,i).*S(:,:,i);
        end
        x = ifft2withShift(X2);
        x = projection(x);
        X2 = fft2withShift(x);
        t2 = (1+sqrt(1+4*t1^2))/2;
        B = X2 + (t1-1)/t2*(X2-X1);
        t1 = t2;
        X1 = X2;
    end
    X = X2;
end