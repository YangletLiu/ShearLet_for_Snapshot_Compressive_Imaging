function [xRec,PSNR,SSIM] = sparsity(x,epsilon)
    %% shearlet
    shearletSystem = SLgetShearletSystem2D(0,256,256,4);
    coeffs1 = zeros(256,256,49,8);
    xRec = zeros(size(x));
    for i=1:8
        coeffs1(:,:,:,i) = SLsheardec2D(x(:,:,i),shearletSystem);
    end

    coeffsVec1 = abs(coeffs1(:));
    sortedCoeffs1 = sort(coeffsVec1,'descend');
    idx1 = floor(epsilon*size(sortedCoeffs1,1));
    delta1 = sortedCoeffs1(idx1);

    coeffs1 = coeffs1.*(abs(coeffs1)>delta1);
    PSNR_i = zeros(8,1);
    SSIM_i = zeros(8,1);
    for i = 1:8
        xRec(:,:,i) = SLshearrec2D(coeffs1(:,:,:,i),shearletSystem);
%         PSNR_i(i) = psnr(x(:,:,i)/255,xRec(:,:,i)/255);
%         SSIM_i(i) = ssim(x(:,:,i)/255,xRec(:,:,i)/255);
        PSNR_i(i) = psnr(x(:,:,i),xRec(:,:,i));
        SSIM_i(i) = ssim(x(:,:,i),xRec(:,:,i));
    end
    
    
    PSNR = mean(PSNR_i);
    SSIM = mean(SSIM_i);
end
