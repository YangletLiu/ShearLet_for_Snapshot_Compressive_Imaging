% 通过SCI的mask构造投影矩阵，对应地由captured获得y
function [Phi,y] = buildSCI(L,N,s,frames,mask,captured)
    nonzero_num = ceil(N/s);
    Phi = zeros(L,N,frames);
    y = zeros(L,1);
 
    for i=1:L
        order = randperm(N); 
        % 这里取正负是考虑到由mask中的元素确定的正负是确定的，否则L行中某列上只要非零就都相同
        positive = order(1:ceil(nonzero_num/2));
        negative = order(1+ceil(nonzero_num/2):nonzero_num);
        Phi(i,:,:) = Phi(i,:,:) + map2vec(N,frames,positive,mask); 
        y(i) = y(i) + sum(captured(positive));
        Phi(i,:,:) = Phi(i,:,:) - map2vec(N,frames,negative,mask);
        y(i) = y(i) - sum(captured(negative));
    end
    
    real_s = N/nonzero_num; % 因为每行都是相同的非零数目，与nonzero_num = ceil(N/s)对应
    Phi = sqrt(real_s)*Phi;
end