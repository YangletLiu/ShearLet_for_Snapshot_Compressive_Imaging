function x = GAP(A, AT, x0, y, LAMBDA, L, sigma, iteration, COST, bFig, bGPU,bShear,bReal,acc,Phisum)
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
x = x0;

if bShear
    if bReal
        shearletSystem = SLgetShearletSystem2D(bGPU,size(x0,1),size(x0,2),4);
    else
        shearletSystem = SLgetShearletSystem2D(bGPU,size(x0,1),size(x0,2),1);
    end
end

y1 = zeros(size(y),'like',y);

for i = 1:iteration
    yb = A(x);
    if acc
        y1 = y1+(y-yb);
        x = x+L(i)*(AT((y1-yb)./Phisum));
    else
        x = x+L(i)*(AT((y-yb)./Phisum));
    end
%     x = TV_denoising(x,0.07,3);
    X = fft2(x);
    X = threshold(X, LAMBDA); 
%     LAMBDA = LAMBDA-0.01*LAMBDA;
    x = ifft2(X);
    if bShear
        x = shealetShrinkage(x,sigma,shearletSystem,bGPU,bReal);
    end
    x = projection(x,1);
    
    if bGPU && bFig
        obj(i)  = gather(COST.function(X));   
    elseif bFig
        obj(i)  = COST.function(X);
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
        % sprintf(num2str(i))
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
