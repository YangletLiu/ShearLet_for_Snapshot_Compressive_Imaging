%% Reference
% https://people.rennes.inria.fr/Cedric.Herzet/Cedric.Herzet/Sparse_Seminar/Entrees/2012/11/12_A_Fast_Iterative_Shrinkage-Thresholding_Algorithmfor_Linear_Inverse_Problems_(A._Beck,_M._Teboulle)_files/Breck_2009.pdf

%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)

%%
function [X, obj]  = MFISTA(A, AT, X0, b, LAMBDA, L, iteration, COST, bfig)

if (nargin < 9)
    bfig = false;
end

if (nargin < 8 || isempty(COST))
    COST.function	= @(x) (0);
    COST.equation	= [];
end

if (nargin < 7)
    iteration   = 1e2;
end

obj     = zeros(iteration, 1);

t1 = 1;
X = X0;

for i = 1:iteration
    X1 = threshold(X - 1/L*AT(A(X) - b), LAMBDA/L); % 这里因为我们知道A函数其实对应的是某个矩阵，都是线性变换，所以必然有AT(A(x)-b) = AT(A(x))-AT(b)
    
    t2 = (1+sqrt(1+4*t1^2))/2;
    X = X1 + (t1-1)/t2*(X1-X0);
    X0 = X1;
    t1=t2;
    
    obj(i)  = COST.function(X);
    
    if (bfig)
        img_x = real(ifft2(X));
        figure(1); colormap gray;
        subplot(121); imagesc(img_x(:,:,1));           title([num2str(i) ' / ' num2str(iteration)]);
        subplot(122); semilogy(obj, '*-');  title(COST.equation);  xlabel('# of iteration');   ylabel('Objective'); 
                                            xlim([1, iteration]);   grid on; grid minor;
        drawnow();
    end
    sprintf("%d",i)
    % denoise
    x = ifft2(X);
    x = denoise2(x);
    % x = TV_denoising(x,0.5,5);
    X = fft2(x);
    
    %X = fft2(denoise1(ifft2(X)));
    %X = fft2(denoise2(ifft2(X)));
    %X = fft2(denoise3(ifft2(X)));
    %X = fft2(TV_denoising(ifft2(X),1,5));
    
    % filter
%     if iteration - i < 5
%         x =ifft2(X);
%         sobelSample = zeros(size(x));
%         for j = 1:8
%             sobelSample(:,:,j) = filter2(fspecial('sobel'),x(:,:,j))/(max(x(:))-min(x(:)));
%         end  
%         x = x + sobelSample;
%         X = fft2(x);
%     end
    
    
end

end

function Xrec = denoise1(Xnoisy)
    shearletSystem = SLgetShearletSystem2D(0,256,256,4);
    stopFactor = 0.009;
    iteration = 3;
    lambda = (stopFactor)^(1/(iteration-1));
    imgDenoised = zeros(size(Xnoisy));
    for k=1:8
        coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(Xnoisy(:,:,k),shearletSystem),shearletSystem);
        delta = max(abs(coeffsNormalized(:)));
        for i=1:iteration
            res = Xnoisy(:,:,k)-imgDenoised(:,:,k);
            coeffs = SLsheardec2D(imgDenoised(:,:,k)+res,shearletSystem);
            coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,shearletSystem))>delta);
            imgDenoised(:,:,k) = SLshearrec2D(coeffs,shearletSystem);
            delta=delta*lambda;
        end
    end
    Xrec = imgDenoised;
end

function Xrec = denoise2(Xnoisy)
    Xrec = zeros(size(Xnoisy));
    thresholdingFactor = [0 2 2 2 3.8];
    for i=1:8
        shearletSystem = SLgetShearletSystem2D(0,256,256,4);
        sigma = 1;
        coeffs = SLsheardec2D(Xnoisy(:,:,i),shearletSystem);
        for j = 1:shearletSystem.nShearlets
            idx = shearletSystem.shearletIdxs(j,:);
            coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*shearletSystem.RMS(j)*sigma);
        end
        Xrec(:,:,i) = SLshearrec2D(coeffs,shearletSystem);
    end
end

function Xout = denoise3(Xnoisy)
    Xt = zeros(128,128,128,4);
    Xt(:,:,1:8,1) = Xnoisy(1:128,1:128,:);
    Xt(:,:,1:8,2) = Xnoisy(1:128,129:256,:);
    Xt(:,:,1:8,3) = Xnoisy(129:256,1:128,:);
    Xt(:,:,1:8,4) = Xnoisy(129:256,129:256,:);
    Xrec = zeros(128,128,128,4);
    sigma = 1;
    thresholdingFactor = [3 3 3 4];
    scales = 3;
    shearLevels = [1, 1, 2];
    for i=1:4
        [Xfreq, Xrec(:,:,:,i), preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(0,Xt(:,:,:,i),scales,shearLevels);
        for j = 1:size(shearletIdxs,1)
            shearletIdx = shearletIdxs(j,:);
            [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
            coeffs = coeffs.*(abs(coeffs) > thresholdingFactor(shearletIdxs(2))*RMS*sigma);
            Xrec(:,:,:,i) = SLshearrecSerial3D(coeffs,shearlet,Xrec(:,:,:,i));      
        end
    end
    Xout(1:128,1:128,:) = Xrec(:,:,1:8,1);
    Xout(1:128,129:256,:) = Xrec(:,:,1:8,2);
    Xout(129:256,1:128,:) = Xrec(:,:,1:8,3);
    Xout(129:256,129:256,:) = Xrec(:,:,1:8,4);
end
