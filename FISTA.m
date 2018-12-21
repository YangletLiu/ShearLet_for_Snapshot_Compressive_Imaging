function X = FISTA(iteration,s,I,H,H_r,G,M,Fai,y,L,lambda)
    % the discarded f is the 2D-DFT block circulant matrix, we know that f^-1 = f^H = f', which means f^H can also be represented as ifft2 
    % s is the coefficients in the shearlet domain
    % I is the nShearlets of the number of shearlets
    % H is the shearlets
    % H_r is the dual of shearlets, H_ri = H_i./G
    % G is the dualFrameWeights in the calculation of shearlets
    % M is of size n¡Án, a mask matrix
    % Fai is the sampling matrix, transform n¡Á1 to m¡Á1, together with fourier
    % y is the target m¡Á1
    % L is the Lipschitz constant fo f_2's gradient
    % lambda is a parameter to balance sparseness and approximation
    S = zeros(size(s));
    B = fft2(Fai'/(Fai*Fai')*y);
    X1 = B;
    t1 = 1;
    for k=1:iteration
        D = B.*(1-1/L*M./G)+1/L*fft(y)./G;
        X2 = 0;
        for i = 1:I
            u = real(ifft2(conj(H(:,:,i)).*D));
            s(:,:,i) = prox(u,L,lambda);
            S(:,:,i) = fft2(s(:,:,i));
            X2 = X2 + H_r(:,:,i).*S(:,:,i);
        end
        x = ifft2(X);
        x = projection(x);
        X2 = fft2(x);
        t2 = (1+sqrt(1+4*t1^2))/2;
        B = X2 + (t1-1/t2)*(X2-X1);
        X1 = X2;
    end
end