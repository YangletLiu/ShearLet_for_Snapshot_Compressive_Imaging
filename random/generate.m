% 利用SCI的mask生成投影矩阵和对应的y。经过内存优化的版本，只求某一行
function [phi,y] = generate(N,frames,s,mask,captured)
    % mask n×n×8 (对角化后为8N×8N)
    % captured n×n
    % Phi L×8N
    % captured_out L×1
    % 生成Phi及其对应的y
    phi = zeros(1,N,frames);
    y = 0;
    nonzero_num = ceil(N/s);
    order = randperm(N);
    positive = order(1:ceil(nonzero_num/2));
    negative = order(1+ceil(nonzero_num/2):nonzero_num);
    phi = phi + map2vec(N,frames,positive,mask);
    y = y + sum(captured(positive));
    phi = phi - map2vec(N,frames,negative,mask);
    y = y - sum(captured(negative));
end