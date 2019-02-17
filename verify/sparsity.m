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
            shearletSystem = SLgetShearletSystem2D(0,size(x,1),size(x,2),2);
            coeffs = zeros(size(x,1),size(x,2),shearletSystem.nShearlets,size(x,3));
            xRec = zeros(size(x));
            for i=1:size(x,3)
                coeffs(:,:,:,i) = SLsheardec2D(x(:,:,i),shearletSystem);
            end
            coeffsVec = abs(coeffs(:));
            sortedCoeffs = sort(coeffsVec,'descend');
            idx = floor(epsilon*size(sortedCoeffs,1));
            delta = sortedCoeffs(idx);
            coeffs = coeffs.*(abs(coeffs)>delta);
            for i =1:size(x,3)
                xRec(:,:,i) = SLshearrec2D(coeffs(:,:,:,i),shearletSystem);
            end
        case 3
            % curvelet
            xRec = zeros(size(x));
            coeffs = cell(1,5,8);
            for i = 1:8
                % Take curvelet transform
                coeffs(:,:,i) = fdct_wrapping(x(:,:,i),1,2);
                C = coeffs(:,:,i);
                for s = 2:length(C)
                    for w = 1:length(C{s})
                        arr = C{s}{w};
                        if ~exist('coeffsVec','var')
                            coeffsVec = arr(:);
                        else
                            coeffsVec = [coeffsVec;arr(:)];
                        end
                    end
                end
            end
            coeffsVec = abs(coeffsVec(:));
            sortedCoeffs = sort(coeffsVec,'descend');
            idx = floor(epsilon*size(sortedCoeffs,1));
            delta = sortedCoeffs(idx);
            for i=1:8     
                % Apply thresholding
                C = coeffs(:,:,i);
                Ct = C;
                for s = 2:length(C)
                  for w = 1:length(C{s})
                    Ct{s}{w} = C{s}{w}.* (abs(C{s}{w}) > delta);
                  end
                end

                % Take inverse curvelet transform 
                xRec(:,:,i) = real(ifdct_wrapping(Ct,1,size(x,1),size(x,2)));
            end
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
