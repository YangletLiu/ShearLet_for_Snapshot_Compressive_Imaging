% 完全随机生成投影矩阵
function [Phi,y] = generate_test(L,N,frames,s,orig,bRow,otherFrames)
    Phi = zeros(L,N,frames);  
    if bRow % 按行生成，每行的1或-1数目相同
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
    else % 直接生成一个随机矩阵
        order = randperm(N*frames*L);
        nonzero_num = N*frames*L/s;
        positive = order(1:nonzero_num/2);
        negtive = order(nonzero_num/2+1:nonzero_num);
        Phi(positive) = 1;
        Phi(negtive) = -1; 
    end
    
    % 仿照SCI
    otherFrames(otherFrames<0.5) = -1;
    otherFrames(otherFrames>0.5) = 1;
    for i=1:L
        for k=2:frames
            Phi(i,:,k) = Phi(i,:,1).*otherFrames(:,:,k);
        end
    end
    
    Phi = sqrt(s)*Phi; % 乘期望的归一化系数
    % 生成y=Phi*orig
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:)/sqrt(L);
    Phi = reshape(Phi,[L,N,frames]);
    
%     Phi(:,:,1) = [1,2,3;4,5,6] % reshape用的没问题
%     Phi(:,:,2) = [7,8,9;10,11,12]
%     Phi_ = reshape(Phi,[2,6])
%     Phi__ = reshape(Phi_,[2,3,2])
    
    expectation = mean(Phi(:)) % 期望 0 
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % 方差 1

    % 会有一个问题，在计算投影后的内积theta的时候，
    % 因为fft变换的psi矩阵第一行/列全是1，而这里的投影矩阵每一行的期望都为0
    % 会导致theta的第一项恒定为0，那么逆变换后恢复出的图片会有系数问题。可以通过不让一行的期望为0
    % SCI中不会有这个问题，因为有一定误差，投影矩阵的期望不是完全为0
end
