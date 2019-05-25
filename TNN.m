%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_TNN }
%
function X  = TNN(A, sX, b, gamma, w, iteration, COST, bFig)

if bFig
    obj     = zeros(iteration, 1);
end
X = zeros(sX);
theta = myfft(X);
eta = zeros(size(theta));
n = size(A,2);
one = ones(n,1);
one = diag(sparse(double(one)));   

t1 = 1;
X_hat_old = zeros(sX);

for i = 1:iteration
%% Fista+TNN
    X_hat = myfft(X)-gamma*myfft(reshape(A'*(A*X(:)-b),sX)); % gamma should be 0.1
    for j = 1:sX(3)
        [U,S,V] = svd(X_hat(:,:,j));
        S = wnnm(S,sqrt(2),w(i,iteration)); % wnnm 插值
        % S = wnnm(S,sqrt(2),w(ceil(i/(iteration/length(w))))); % wnnm 等间距设置w
        % S = max(S-w(ceil(i/(iteration/length(w)))),0); % nnm
        X_hat(:,:,j) = U*S*V';
    end
    t2 = (1+sqrt(1+4*t1^2))/2;
    X = myifft(X_hat + (t1-1)/t2*(X_hat-X_hat_old));
    X = projection(X);
    X = tvdenoise(X,1,3); 
    X_hat_old = X_hat;
    t1=t2;
    
%% ADMM+TNN,something wrong?
%     X = gamma*myifft(theta)-gamma*myifft(eta);
%     X = X(:);
%     X = (A'*A+gamma*one/2)\(2*A'*b+X);
%     X = reshape(X,sX);
%     % X = projection(X);
%     X_hat = myfft(X);
%     for j = 1:sX(3)
%         [U,S,V] = svd(X_hat(:,:,j));
%         svd(X_hat(:,:,j))
%         S = max(S-w,0);
%         theta(:,:,j) = U*S*V';
%     end
%     eta = eta + (theta-X_hat);
%% Visualization
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

function output=myfft(input)
    output = zeros(size(input));
    for i =1:size(input,1)
        for j=1:size(input,2)
            output(i,j,:) = fft(input(i,j,:));
        end
    end 
end

function output=myifft(input)
    output = zeros(size(input));
    for i =1:size(input,1)
        for j=1:size(input,2)
            output(i,j,:) = ifft(input(i,j,:));
        end
    end 
end

