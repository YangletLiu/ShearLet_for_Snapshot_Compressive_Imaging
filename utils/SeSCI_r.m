%% 
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)
function x  = SeSCI_r(A, AT, x0, b, LAMBDA, L, sigma, iteration, COST, bFig, bGPU,bShear,bReal,bPer)
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
X0 = fftshift(fft2(ifftshift(x0)));

if bShear
    if bReal
        shearletSystem = SLgetShearletSystem2D(bGPU,w,h,4);
    else
        shearletSystem = SLgetShearletSystem2D(bGPU,w,h,1);
    end
end

for i = 1:iteration
    x = x - 1/L*AT(A(x) - b);
    X = fftshift(fft2(ifftshift(x)));
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
    
    if bShear
        x = shealetShrinkage(X,sigma(i),shearletSystem,bReal,bPer);
    end
    x = projection(x);
    
    if bFig
        obj(i)  = COST.function(x,i);
        img_x = real(x);
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
end
end

function Xrec = shealetShrinkage(Xnoisy,sigma,shearletSystem,bReal,bPer)
    Xrec = zeros(size(Xnoisy));
    if ~bPer
        if bReal
            thresholdingFactor = [0 1 1 1 3.5];
        else
            thresholdingFactor = [0 4]; % 1 for lowpass, 2 for scale 1
        end
    end
    codedFrame = size(Xnoisy,3);
    for i=1:codedFrame
        coeffs = zeros(size(shearletSystem.shearlets));
        for j = 1:shearletSystem.nShearlets
            coeffs(:,:,j) = fftshift(ifft2(ifftshift(Xnoisy(:,:,i).*conj(shearletSystem.shearlets(:,:,j)))));        
        end
        if bPer
            coeffsVec = abs(coeffs(:));
            sortedCoeffs = sort(coeffsVec,'descend');
            index = floor(sigma*size(sortedCoeffs,1));
            delta = sortedCoeffs(index);
            coeffs = coeffs.*(abs(coeffs)>delta);
            disp(delta)
            disp(shearletSystem.RMS)
        else
            for j = 1:shearletSystem.nShearlets
               idx = shearletSystem.shearletIdxs(j,:);
               coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*shearletSystem.RMS(j)*sigma);
%                coeffs(:,:,j) = threshold(coeffs(:,:,j), sigma);
            end
        end
        Xrec(:,:,i) = SLshearrec2D(coeffs,shearletSystem);
    end
end

