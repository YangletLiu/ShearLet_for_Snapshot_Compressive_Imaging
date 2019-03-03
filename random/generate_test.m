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
    Phi = sqrt(s)*Phi;
    % Éú³Éy=Phi*orig
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:);
    Phi = reshape(Phi,[L,N,frames]);
end
