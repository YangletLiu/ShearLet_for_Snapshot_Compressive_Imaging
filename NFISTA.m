function x = NFISTA(iteration,I,H,H_r,G,M,y,L,lambda)
    % the discarded f is the 2D-DFT block circulant matrix, we know that f^-1 = f^H = f', which means f^H can also be represented as ifft2 
    % I is the nShearlets of the number of shearlets
    % H is the shearlets
    % H_r is the dual of shearlets, H_ri = H_i./G
    % G is the dualFrameWeights in the calculation of shearlets
    % M is of size n×n, a mask matrix
    % y is the target n×n, we don't need do reduction so we can still use the square matrix instead of column of m×1
    % L is the Lipschitz constant fo f_2's gradient
    % lambda is a parameter to balance sparseness and approximation
    s = zeros(size(H));
    S = zeros(size(H));
    X = fft2withShift(y); % here we only need to transform matrix y to the Fourier domain to initalize the X, or B 
    x = y;
    % t1 = 1; % no back-tracking
    cost = zeros(iteration);
    % 将FISTA与恢复合并
    for k=1:iteration
        D = X-1/L*fft2withShift(M.*x)./G+1/L*fft2withShift(M.*y)./G;
        X = 0;
        for i = 1:I
            u = real(ifft2withShift(conj(H(:,:,i)).*D));
            s(:,:,i) = prox(u,L,lambda);
            S(:,:,i) = fft2withShift(s(:,:,i));
            X = X + H_r(:,:,i).*S(:,:,i);
        end
        x = ifft2withShift(X);
        
        L1 = @(x) norm(x, 1);
        L2 = @(x) power(norm(x, 'fro'), 2);
        cost(k) = 1/2 * L2(M.*x - y) + lambda * L1(s(:)); % 实际为s
        figure(1);
        colormap(gray);
        subplot(121);
        imagesc(x);
        subplot(122);
        semilogy(cost, '*-'); 
        xlabel('# of iteration'); ylabel('Objective'); 
        xlim([1, iteration]); grid on; grid minor;
        drawnow();
        disp(k);
        
        % t2 = (1+sqrt(1+4*t1^2))/2;
        % t1 = t2;
    end
end