%% 
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)
function X  = SeSCI(A, AT, x0, b, LAMBDA, L, sigma, iteration, COST, bFig, bGPU,bShear,bReal,bPer)
if (nargin < 14)
    bPer = false;
end

if (nargin < 13)
    bReal = false;
end

if (nargin < 12)
    bShear = false;
end

if (nargin < 11)
    bGPU = false;
end

if (nargin < 10)
    bFig = false;
end

if (nargin < 9 || isempty(COST))
    COST.function	= @(x) (0);
    COST.equation	= [];
end

if (nargin < 8)
    iteration   = 1e2;
end

if bFig
    obj     = zeros(iteration, 1);
end
t1 = 1;
x = x0;
[w,h,~] = size(x0);
X0 = fft2(x0);

if bShear
    if bReal
        shearletSystem = SLgetShearletSystem2D(bGPU,w,h,4);
    else
        shearletSystem = SLgetShearletSystem2D(bGPU,w,h,1);
    end
end

for i = 1:iteration
    x = x - 1/L*AT(A(x) - b);
    X = fft2(x);
    if bPer
        coeffsVec = abs(X(:));
        sortedCoeffs = sort(coeffsVec,'descend');
        index = floor(LAMBDA(i)*size(sortedCoeffs,1));
        lambda = sortedCoeffs(index);
        disp(lambda)
    else
        lambda = LAMBDA(i);
    end
    X1 = threshold(X, lambda);
    
    t2 = (1+sqrt(1+4*t1^2))/2;
    X = X1 + (t1-1)/t2*(X1-X0);
    X0 = X1;
    t1=t2;
    
    if bGPU && bFig
        obj(i)  = gather(COST.function(X,i));   
    elseif bFig
        obj(i)  = COST.function(X,i);
    end
    
    if (bFig)
        img_x = real(ifft2(X));
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
        sprintf(num2str(i))
    end
    
    
    x = ifft2(X);
    x = projection(x);
    if bShear
        x = shealetShrinkage(x,sigma(i),shearletSystem,bGPU);
    end
end
end

function Xrec = shealetShrinkage(Xnoisy,sigma,shearletSystem,bGPU)
    Xrec = zeros(size(Xnoisy));
    if bGPU
        Xrec = gpuArray(single(Xrec));
    end
    codedFrame = size(Xnoisy,3);
    for i=1:codedFrame
        coeffs = SLsheardec2D(Xnoisy(:,:,i),shearletSystem);
        coeffs = fftshift(fft2(ifftshift(coeffs)));
        coeffsVec = abs(coeffs(:));
        sortedCoeffs = sort(coeffsVec,'descend');
        index = floor(sigma*size(sortedCoeffs,1));
        delta = sortedCoeffs(index);
        coeffs = coeffs.*(abs(coeffs)>delta);
        % threshold(coeffs,delta);
        coeffs = fftshift(ifft2(ifftshift(coeffs)));
        Xrec(:,:,i) = SLshearrec2D(coeffs,shearletSystem);
    end
end

