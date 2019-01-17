function x = NNFISTA(iteration,I,M,y,L,lambda,shearletSystem,A,AT)
    % the discarded f is the 2D-DFT block circulant matrix, we know that f^-1 = f^H = f', which means f^H can also be represented as ifft2 
    % I is the nShearlets of the number of shearlets
    % H is the shearlets
    % H_r is the dual of shearlets, H_ri = H_i./G
    % G is the dualFrameWeights in the calculation of shearlets
    % M is of size n×n, a mask matrix
    % y is the target n×n, we don't need do reduction so we can still use the square matrix instead of column of m×1
    % L is the Lipschitz constant fo f_2's gradient
    % lambda is a parameter to balance sparseness and approximation
    x = y;
    % t1 = 1; % no back-tracking
    s = SLsheardec2D(x,shearletSystem);
    cost = zeros(iteration);
    
    for k=1:iteration
        D = s-1/L*AT(A(s)-y);
        % 迭代求解s并重构x进行观测
        for i = 1:I
            u = D(:,:,i);
            s(:,:,i) = prox(u,L,lambda);
        end
        x = SLshearrec2D(s,shearletSystem);
        
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