function matrix = ifft2withShift(matrix,dim)
    if nargin==1
        dim = 2;
    end
    if dim==2
        matrix = fftshift(ifft2(ifftshift(matrix)));
    elseif dim==3
        for i = 1:size(matrix,3)
            matrix(:,:,i) = fftshift(ifft2(ifftshift(matrix(:,:,i))));
        end
    end
end