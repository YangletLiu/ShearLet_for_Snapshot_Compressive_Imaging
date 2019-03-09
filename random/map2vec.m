function vec = map2vec(N,frames,selecteds,mask)
    % 将选取的采样矩阵中的某一列取出来，并映射到Phi某一行的对应位置上
    n = sqrt(N);
    vec = zeros(1,N,frames);
    for i=1:length(selecteds)
        selected = selecteds(i);
        mask_i = mod(selected-1,n)+1;
        mask_j = ceil(selected/n);
        vec(1,selected,:) = mask(mask_i,mask_j,:);
    end
end