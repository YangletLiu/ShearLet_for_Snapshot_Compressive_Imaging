function x = NNFISTA(iteration,I,y,L,lambda,shearletSystem,A,AT)
    % the discarded f is the 2D-DFT block circulant matrix, we know that f^-1 = f^H = f', which means f^H can also be represented as ifft2 
    % I is the nShearlets of the number of shearlets
    % M is of size n×n, a mask matrix
    % y is the target n×n, we don't need do reduction so we can still use the square matrix instead of column of m×1
    % L is the Lipschitz constant fo f_2's gradient
    % lambda is a parameter to balance sparseness and approximation
    % A and AT are functions perform linear transforms which are hard to be taken directly in the matrix format
    
    t1 = 1;
    s = zeros(size(y,1),size(y,2),8*I);
%     x = repmat(y,1,1,8);
%     for i=1:8
%        s(:,:,(i-1)*I+1:(i-1)*I+I) = SLsheardec2D(x(:,:,i),shearletSystem); %换3D-shear？
%     end
    S = fft2withShift(s);
    S0 = S;
    cost = zeros(iteration);
    
    % 迭代求解s并重构x进行观测
    for k=1:iteration
        S1 = threshold(S-1/L*AT(A(s)-y),lambda/L);
        
        t2 = (1+sqrt(1+4*t1^2))/2;
        S = S1 + (t1-1)/t2*(S1-S0);
        S0 = S1;
        %t1=t2;
        t1=1;
        
        s = ifft2withShift(S);
        for i=1:8
            x(:,:,i) = SLshearrec2D(s(:,:,(i-1)*I+1:(i-1)*I+I),shearletSystem);
        end
        x = real(x);
        x = denoise2(x,shearletSystem);
        %x = TV_denoising(x,1,5);
        for i=1:8
            s(:,:,(i-1)*I+1:(i-1)*I+I) = SLsheardec2D(x(:,:,i),shearletSystem);
        end

        
        
    
        L1 = @(x) norm(x, 1);
        L2 = @(x) power(norm(x, 'fro'), 2);
        cost(k) = 1/2 * L2(A(s) - y) + lambda * L1(S(:)); 
        figure(1);
        colormap(gray);
        subplot(121);
        imagesc(x(:,:,1));title([num2str(k) ' / ' num2str(iteration)]);
        subplot(122);
        semilogy(cost, '*-'); 
        xlabel('# of iteration'); ylabel('Objective'); 
        xlim([1, iteration]); grid on; grid minor;
        drawnow();
    end
end

function Xrec = denoise2(Xnoisy,shearletSystem)
    Xrec = zeros(size(Xnoisy));
    thresholdingFactor = [0 2.5 2.5 2.5 3.8];
    for i=1:8
        sigma = 1;
        coeffs = SLsheardec2D(Xnoisy(:,:,i),shearletSystem);
        for j = 1:shearletSystem.nShearlets
            idx = shearletSystem.shearletIdxs(j,:);
            coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*shearletSystem.RMS(j)*sigma);
        end
        Xrec(:,:,i) = SLshearrec2D(coeffs,shearletSystem);
    end
end