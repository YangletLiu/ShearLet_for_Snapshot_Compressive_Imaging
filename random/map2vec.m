function vec = map2vec(N,frames,selected,mask)
    % 将选取的采样矩阵中的某一列取出来，并映射到Phi某一行的对应位置上
    n = sqrt(N);
    mask_i = mod(selected-1,n)+1;
    mask_j = ceil(selected/n);
    vec = zeros(1,N,frames);
    vec(1,selected,:) = mask(mask_i,mask_j,:);
end