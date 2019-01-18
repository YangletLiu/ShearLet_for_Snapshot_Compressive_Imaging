function output = sample(M,x)
    output = zeros(size(x,1),size(x,2));
    for i = 1:8
        output = output + M(:,:,i).*x(:,:,i);
    end
end