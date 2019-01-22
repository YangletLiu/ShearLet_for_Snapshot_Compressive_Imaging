function x = verify_shearlet(iteration,M,y,L,lambda,shearletSystem,A,AT)

    % the discarded f is the 2D-DFT block circulant matrix, we know that f^-1 = f^H = f', which means f^H can also be represented as ifft2 

    % I is the nShearlets of the number of shearlets

    % M is of size n×n, a mask matrix

    % y is the target n×n, we don't need do reduction so we can still use the square matrix instead of column of m×1

    % L is the Lipschitz constant fo f_2's gradient

    % lambda is a parameter to balance sparseness and approximation

    % A and AT are functions perform linear transforms which are hard to be taken directly in the matrix format

    

    x = y;

    s = SLsheardec2D(x,shearletSystem);

    % s = zeros(size(M,1),size(M,2),I);

    S = fft2withShift(s);

    cost = zeros(iteration);

    

    % 迭代求解s并重构x进行观测

    for k=1:iteration

        U = S-1/L*AT(A(s)-y);
        S = threshold(U,lambda/L);

        s = ifft2withShift(S);

        x = SLshearrec2D(s,shearletSystem);

        x = real(x);

        

        L1 = @(x) norm(x, 1);

        L2 = @(x) power(norm(x, 'fro'), 2);

        cost(k) = 1/2 * L2(M.*x - y) + lambda * L1(S(:)); 

        figure(1);

        colormap(gray);

        subplot(121);

        imagesc(x);title([num2str(k) ' / ' num2str(iteration)]);

        subplot(122);

        semilogy(cost, '*-'); 

        xlabel('# of iteration'); ylabel('Objective'); 

        xlim([1, iteration]); grid on; grid minor;

        drawnow();

        disp(k);

    end

end