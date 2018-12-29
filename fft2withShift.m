function matrix = fft2withShift(matrix)
    matrix = fftshift(fft2(ifftshift(matrix)));
end

% G = fft2(ifft2withShift(G));
% for i = 1:I
%     H(:,:,i) = fft2(ifft2withShift(H(:,:,i)));
% end