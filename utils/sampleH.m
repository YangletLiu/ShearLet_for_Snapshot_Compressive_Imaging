function output = sampleH(M,x,bGPU)
    output = zeros(size(M));
    if bGPU
        output = gpuArray(single(output));
    end
    for i =1:8
        output(:,:,i) = M(:,:,i).*x;
    end
end