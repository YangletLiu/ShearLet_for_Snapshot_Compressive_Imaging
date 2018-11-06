function X = initialize(P,r)
    [U,~,~] = ntsvd(P,true);
    X = U(1:r,1:r,:);
end