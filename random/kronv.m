function vec_out = kronv(vec1,vec2)
    % Kronecker积的某行的结果
    n = length(vec1);
    vec_out = zeros(n*n,1);
    for i = 1:n
            vec_out((i-1)*n+1:i*n) = vec1(i)*vec2;
    end
end