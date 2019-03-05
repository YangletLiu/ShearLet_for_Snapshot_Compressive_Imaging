function [phi,y,nonzeros] = generate(N,frames,s,mask,captured)
    % mask n×n×8 (对角化后为8N×8N)
    % captured n×n
    % Phi L×8N
    % captured_out L×1
    nonzero_num = frames*N/s;
    % 生成Phi及其对应的y
    phi = zeros(1,N,frames);
    y = 0;
    nonzeros = 0;
    selecteds = [];
    while nonzeros<nonzero_num
        selected = unidrnd(N);
        if ismember(selected,selecteds)
            continue;
        else
            selecteds = [selecteds,selected];
        end
        phi = phi + map2vec(N,frames,selected,mask);
        y = y + captured(selected);
        nonzeros = nonzeros + 8;
    end
    nonzeros = nonzeros - 8;
end