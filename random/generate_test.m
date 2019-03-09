function [Phi,y] = generate_test(L,N,frames,s,orig,bRow)
    Phi = zeros(L,N,frames);  
    if bRow
        for k = 1:frames
            for i =1:L
                order = randperm(N);
                nonzero_num = N/s;
                positive = order(1:nonzero_num/2);
                negtive = order(nonzero_num/2+1:nonzero_num);
                Phi(i,positive,k) = 1;
                Phi(i,negtive,k) = -1;
            end
        end
    else
        order = randperm(N*frames*L);
        nonzero_num = N*frames*L/s;
        positive = order(1:nonzero_num/2);
        negtive = order(nonzero_num/2+1:nonzero_num);
        Phi(positive) = 1;
        Phi(negtive) = -1; 
    end
    
    % 仿照SCI
    otherFrames = rand([1,N,frames]);
    otherFrames(otherFrames<0.5) = -1;
    otherFrames(otherFrames>0.5) = 1;
    for i=1:L
        for k=2:frames
            Phi(i,:,k) = Phi(i,:,1).*otherFrames(:,:,k);
        end
    end
    
    Phi = sqrt(s)*Phi;
    % 生成y=Phi*orig
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:)/sqrt(L);
    Phi = reshape(Phi,[L,N,frames]);
    
    expectation = mean(Phi(:)) % 期望 0
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % 方差 1
end
