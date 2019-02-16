function p = projection(z)
    % restrict the real part of z to be in the interval [0,255]
    p = real(z);
    p(real(z)>255) = 255;
    p(real(z)<0) = 0;
end