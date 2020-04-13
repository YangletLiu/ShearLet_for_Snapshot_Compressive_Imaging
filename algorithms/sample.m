function output = sample(M,x,codedNum)
    output = zeros(size(x,1),size(x,2));
    for i = 1:codedNum
        output = output + M(:,:,i).*x(:,:,i);
    end
end