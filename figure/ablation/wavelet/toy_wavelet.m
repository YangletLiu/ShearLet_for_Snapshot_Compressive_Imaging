%%
clear ;
close all;
home;

bGPU = false;
bReal = false;
bPer = false;
%% DATASET
load("toy31_cassi.mat") % orig,meas,mask
codedNum = 31;
test_data = 1;

for k = test_data
%% DATA PROCESS
    if exist('orig','var')
        bOrig   = true;
        x       = orig(:,:,(k-1)*codedNum+1:(k-1)*codedNum+codedNum);
        if max(x(:))<=1
            x       = x * 255;
        end
    else
        bOrig   = false;
        x       = zeros(size(mask));
    end
    N       = 256;
    M = mask; 
    if bGPU 
        M = gpuArray(single(M));
    end
    bShear = true;
    bFig = true;
    sigma = @(ite) 1;
    LAMBDA  = @(ite) 5;  
    L       = 6;
    niter   = 800; 
    A       = @(x) sample(M,x,codedNum);
    AT      = @(y) sampleH(M,y,codedNum,bGPU);

    %% INITIALIZATION
    if bOrig
        y       = sample(M,x,codedNum);
    else
        y       = meas(:,:,1);
    end
    x0      = zeros(size(x));
    if bGPU 
        y = gpuArray(single(y));
        x0 = gpuArray(single(x0));
    end
    L1              = @(x) norm(x, 1);
    L2              = @(x) power(norm(x, 'fro'), 2);
    COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
    COST.function	= @(X,ite) 1/2 * L2(A(X) - y) + LAMBDA(ite) * L1(X(:));
%     COST.equation   = '1/2 * || A(X) - Y ||_2^2';
%     COST.function	= @(X) 1/2 * L2(A(X) - y);

%% RUN
    tic
    x_ista	= abl_wave(A, AT, x0, y, LAMBDA, L, sigma, niter, COST, bFig,bPer);
    time = toc;
    x_ista = real(ifft2(x_ista));
    if bGPU
        x_ista = gather(x_ista);
    end
    x_ista = TV_denoising(x_ista/255,0.05,10)*255;
    nor         = max(x(:));
    psnr_x_ista = zeros(codedNum,1);
    ssim_x_ista = zeros(codedNum,1);
%% DISPLAY
    figure(1); 
    for i=1:codedNum
        if bOrig
            colormap gray;
            subplot(121);   
            imagesc(x(:,:,i));
            set(gca,'xtick',[],'ytick',[]);
            title('orig');

            subplot(122);   
            imagesc(x_ista(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 

            psnr_x_ista(i) = psnr(x_ista(:,:,i)./nor, x(:,:,i)./nor, max(max(max(double(x(:,:,i)./nor))))); 
            ssim_x_ista(i) = ssim(x_ista(:,:,i)./nor, x(:,:,i)./nor);
            title({['frame : ' num2str(i, '%d')], ['PSNR : ' num2str(psnr_x_ista(i), '%.4f')], ['SSIM : ' num2str(ssim_x_ista(i), '%.4f')]});
        else 
            colormap gray;
            imagesc(x_ista(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 
            title(['frame : ' num2str(i, '%d')]);
        end
        pause(1);
    end
    psnr_ista = mean(psnr_x_ista);
    ssim_ista = mean(ssim_x_ista);

    save(sprintf("results/wave_toy_%d.mat",k))
end
function X  = abl_wave(A, AT, x0, b, LAMBDA, L, sigma, iteration, COST, bFig, bPer)
if (nargin < 11)
    bPer = false;
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
    
    if bFig
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
    x = waveletShrinkage(x,sigma(i),bPer);
    
end
end

function xRec = waveletShrinkage(Xnoisy,sigma,bPer)
    xRec = zeros(size(Xnoisy));
    coeffs = [];
    pos = zeros(3,2,size(Xnoisy,3));
    for i = 1:8
        % Take wavelet transform
        [C, pos(:,:,i)] = wavedec2(Xnoisy(:,:,i),1,'haar');
        coeffs = [coeffs; C];
    end
    if bPer
        coeffsVec = abs(coeffs(:));
        sortedCoeffs = sort(coeffsVec,'descend');
        idx = floor(sigma*size(sortedCoeffs,1));
        delta = sortedCoeffs(idx);
    else
        delta = sigma;
	end
    for i=1:8     
        % Apply thresholding
        coeffs(i,:) = coeffs(i,:).* (coeffs(i,:)>delta);
        % Take inverse curvelet transform 
        xRec(:,:,i) = real(waverec2(coeffs(i,:),pos(:,:,i),'haar'));
    end
end

