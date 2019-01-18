function output = sampleH(M,x)
    output = zeros(size(M));
    for i =1:8
        output(:,:,i) = M(:,:,i).*x;
    end
end