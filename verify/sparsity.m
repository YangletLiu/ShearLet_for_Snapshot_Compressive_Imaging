function [xRec,PSNR,SSIM] = sparsity(x,epsilon,type)
    if max(x(:))<=1
            x  = x * 255;
    end
    switch type
        case 1
            % frequency
            coeffs = fft2(x);
            coeffsVec = abs(coeffs(:));
            sortedCoeffs = sort(coeffsVec,'descend');
            idx = floor(epsilon*size(sortedCoeffs,1));
            delta = sortedCoeffs(idx);
            coeffs = coeffs.*(abs(coeffs)>delta);
            xRec = ifft2(coeffs);
            xRec = real(xRec);
        case 2 
            % shearlet
            shearletSystem = SLgetShearletSystem2D(0,size(x,1),size(x,2),4);
            coeffs = zeros(size(x,1),size(x,2),shearletSystem.nShearlets,8);
            xRec = zeros(size(x));
            for i=1:8
                coeffs(:,:,:,i) = SLsheardec2D(x(:,:,i),shearletSystem);
            end
            coeffsVec = abs(coeffs(:));
            sortedCoeffs = sort(coeffsVec,'descend');
            idx = floor(epsilon*size(sortedCoeffs,1));
            delta = sortedCoeffs(idx);
            coeffs = coeffs.*(abs(coeffs)>delta);
            for i =1:8
                xRec(:,:,i) = SLshearrec2D(coeffs(:,:,:,i),shearletSystem);
            end
        case 3
            % wavelet
            [coeffs,~]=wavedec2(x,2,'db1');
    end
    
    PSNR_i = zeros(8,1);
    SSIM_i = zeros(8,1);
    for i = 1:8
        PSNR_i(i) = psnr(x(:,:,i)/255,xRec(:,:,i)/255);
        SSIM_i(i) = ssim(x(:,:,i)/255,xRec(:,:,i)/255);
    end
    
    
    PSNR = mean(PSNR_i);
    SSIM = mean(SSIM_i);
end
