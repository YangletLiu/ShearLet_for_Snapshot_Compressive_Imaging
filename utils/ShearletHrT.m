function out = ShearletHrT(x,H_r)
    I = size(H_r,3);
    out = zeros(size(H_r,1),size(H_r,2),size(H_r,3)*8);
    for k=1:8
        for i=1:I
            out(:,:,(k-1)*I+i) = ifft2withShift(conj(H_r(:,:,i)).*fft2withShift(x(:,:,k)));
        end
    end
end