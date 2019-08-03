%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_TNN }
%
function X  = TNN(A, sX, b, gamma, w, iteration, COST, bFig,X0)
if bFig
    obj     = zeros(iteration, 1);
end
if nargin <= 8
    X0 = zeros(sX);
end
X = X0;
t1 = 1;
X_hat_old = zeros(sX);

for i = 1:iteration
%% Fista+TNN
    X_hat = myfft(X)-gamma*myfft(reshape(A'*(A*X(:)-b),sX)); % gamma should be 0.1
    if w(i,iteration)~=0
    % if w(ceil(i/(iteration/length(w)))) ~=0
        for j = 1:size(X_hat,3)
            X_hat(:,:,j) = wnnm(X_hat(:,:,j),sqrt(2),w(i,iteration)); % wnnm 插值
            % X_hat(:,:,j) = wnnm(X_hat(:,:,j),sqrt(2),w(ceil(i/(iteration/length(w))))); % wnnm 等间距设置w
        end
    end
    t2 = (1+sqrt(1+4*t1^2))/2;
    X = myifft(X_hat + (t1-1)/t2*(X_hat-X_hat_old));
    X = projection(X);
    X_hat_old = X_hat;
    t1=t2;
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

function output=mydct(input)
    output = zeros(size(input));
    for i =1:size(input,1)
        for j=1:size(input,2)
            output(i,j,:) = dct(input(i,j,:));
        end
    end 
end

function output=myidct(input)
    output = zeros(size(input));
    for i =1:size(input,1)
        for j=1:size(input,2)
            output(i,j,:) = idct(input(i,j,:));
        end
    end 
end




function Xrec = shealetShrinkage(Xnoisy,sigma,shearletSystem,bGPU,bReal)
    Xrec = zeros(size(Xnoisy));
    if bGPU
        Xrec = gpuArray(single(Xrec));
    end
    if bReal
        thresholdingFactor = [0 1 1 1 3.5];
    else
        thresholdingFactor = [0 4]; % 1 for lowpass, 2 for scale 1
    end
    codedFrame = size(Xnoisy,3);
    for i=1:codedFrame
        coeffs = SLsheardec2D(Xnoisy(:,:,i),shearletSystem);
        for j = 1:shearletSystem.nShearlets
            idx = shearletSystem.shearletIdxs(j,:);
            coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*shearletSystem.RMS(j)*sigma);
        end
        Xrec(:,:,i) = SLshearrec2D(coeffs,shearletSystem);
    end
end
