function out = verifyHrT(x,H_r)

    I = size(H_r,3);

    out = zeros(size(H_r));

    for i=1:I

        out(:,:,i) = ifft2withShift(conj(H_r(:,:,i)).*fft2withShift(x));

    end

end