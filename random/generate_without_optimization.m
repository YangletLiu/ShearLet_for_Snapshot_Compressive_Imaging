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
        selecteds = [];
        j = 0;
        while j < nonzero_num
            selected = unidrnd(N);
            if ismember(selected,selecteds)
                continue;
            else
                selecteds = [selecteds,selected];
            end
            if rand(1)>0.5
                Phi(i,:,:) = Phi(i,:,:) + map2vec(N,frames,selected,mask);
                y(i) = y(i) + captured(selected);
            else
                Phi(i,:,:) = Phi(i,:,:) - map2vec(N,frames,selected,mask);
                y(i) = y(i) - captured(selected);
            end
            j = j + 1;
        end
    end
    real_s = N/nonzero_num;
    
    Phi = sqrt(real_s)*Phi;
    
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:)/sqrt(L);
    Phi = reshape(Phi,[L,N,frames]);
    
    expectation = mean(Phi(:)) % 期望 0
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % 方差 1
end