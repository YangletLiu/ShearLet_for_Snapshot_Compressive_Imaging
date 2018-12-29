function matrix = ifft2withShift(matrix)
    matrix = fftshift(ifft2(ifftshift(matrix)));
end