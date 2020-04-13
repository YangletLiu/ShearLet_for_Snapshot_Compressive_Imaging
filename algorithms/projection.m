function p = projection(z,nor)
    % restrict the real part of z to be in the interval [0,nor]
    if nargin==1
        nor = 255;
    end
    p = real(z);
    p(real(z)>nor) = nor;
    p(real(z)<0) = 0;
end