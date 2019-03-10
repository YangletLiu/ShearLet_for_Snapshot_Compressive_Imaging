% 利用SCI的mask生成投影矩阵和对应的y
function [Phi,y] = generate_without_optimization(L,N,frames,s,mask,captured,orig)
    % mask n×n×8 (对角化后为8N×8N)
    % captured n×n
    % Phi L×8N
    % captured_out L×1
    
    % 预处理，将mask中的0转化为1，这里因为mask中0和1个数大致相同，可以先对0/1个数不做考虑
    captured = captured(:);
    captured = 2*(captured-mean(captured));
    mask(mask==0) = -1;
    
    nonzero_num = ceil(N/s);
    % 生成Phi及其对应的y
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
    
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:)/sqrt(L);
    Phi = reshape(Phi,[L,N,frames]);
    
    expectation = mean(Phi(:)) % 期望 0
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % 方差 1
end