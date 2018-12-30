function p = projection(z)
    % restrict the real part of z to be in the interval [0,1]
    p = real(z);
    p(real(z)>1) = 1;
    p(real(z)<0) = 0;
end