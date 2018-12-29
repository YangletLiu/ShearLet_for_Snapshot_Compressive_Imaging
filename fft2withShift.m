function matrix = fft2withShift(matrix)
    matrix = fftshift(fft2(ifftshift(matrix)));
end