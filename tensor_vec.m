function vec = tensor_vec(tensor)
% 把lateral slice转化为vector
% input:m*1*k
% output:mk*1
    [m,~,k] = size(tensor);
    vec = zeros(m*k,1);
    for i=1:m
        vec((i-1)*k+1:i*k) = squeeze(tensor(i,1,:));
    end
end