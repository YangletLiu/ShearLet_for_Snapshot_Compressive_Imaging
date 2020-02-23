%% 
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)
function X  = SeSCI_new(A, AT, x0, b, LAMBDA, L, sigma, iteration, COST, bFig, bGPU,bShear,bReal)
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
[w,h,f] = size(x0);
X0 = fft2(x0);
X0 = X0(:);

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
    X1 = threshold_complex(X(:), LAMBDA(i)); % 这里因为我们知道A函数其实对应的是某个矩阵，都是线性变换，所以必然有AT(A(x)-b) = AT(A(x))-AT(b)

    t2 = (1+sqrt(1+4*t1^2))/2;
    X = X1 + (t1-1)/t2*(X1-X0);
    X0 = X1;
    t1=t2;
    X = reshape(X,[w,h,f]);
    if bGPU && bFig
        obj(i)  = gather(COST.function(X,i));   
    elseif bFig
        obj(i)  = COST.function(X,i);
    end
    if bFig
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
        x = shealetShrinkage(x,sigma(i),shearletSystem,bGPU,bReal,false);
    end
end
end

function Xrec = shealetShrinkage(Xnoisy,sigma,shearletSystem,bGPU,bReal,bPer)
    Xrec = zeros(size(Xnoisy));
    if bGPU
        Xrec = gpuArray(single(Xrec));
    end
    if ~bPer
        if bReal
            thresholdingFactor = [0 1 1 1 3.5];
        else
            thresholdingFactor = [0 4]; % 1 for lowpass, 2 for scale 1
        end
    end
    codedFrame = size(Xnoisy,3);
    for i=1:codedFrame
        coeffs = SLsheardec2D(Xnoisy(:,:,i),shearletSystem);
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

