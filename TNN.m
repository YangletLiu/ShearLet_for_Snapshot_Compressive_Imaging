%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_TNN }
%
function X  = TNN(A, sX, b, gamma, w, iteration, COST, bFig)

if bFig
    obj     = zeros(iteration, 1);
end
X = zeros(sX);
theta = fft(X);
eta = zeros(size(theta));
n = size(A,2);
one = ones(n,1);
one = diag(sparse(double(one)));   

for i = 1:iteration
    X = gamma*ifft(theta)-ifft(eta);
    X = X(:);
    X = (A'*A+gamma*one/2)\(2*A'*b+X);
    X = reshape(X,sX);
    X_hat = fft(X);
    for j = 1:sX(3)
        [U,S,V] = svd(X_hat(:,:,j));
        S = max(S-w,0);
        theta(:,:,j) = U*S*V;
    end
    eta = eta + gamma*(theta-fft(X));
    % X = projection(X);
    obj(i)  = COST.function(X(:));
    if (bFig)
        img_x = real(X);
        figure(1); 
        colormap gray;
        subplot(121); 
        imagesc(img_x(:,:,1));           
        title([num2str(i) ' / ' num2str(iteration)]);
        subplot(122); 
        semilogy(obj, '*-');  
        title(COST.equation);  xlabel('# of iteration'); ylabel('Objective'); 
        xlim([1, iteration]);   grid on; grid minor;
        % drawnow();
    else
        % sprintf(num2str(i))
    end
    
end
end

