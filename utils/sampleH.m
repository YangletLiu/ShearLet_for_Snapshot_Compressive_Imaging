function output = sampleH(M,x,codedNum,bGPU)
    output = zeros(size(M));
    if bGPU
        output = gpuArray(single(output));
    end
    for i =1:codedNum
        output(:,:,i) = M(:,:,i).*x;
    end
end