function A2 = lateral_mat_circ(P,j)
    [m,k] = size(P(:,j,:));
    A2 = zeros(k,k,m);
    for l=1:m
        A2(:,:,l) = vec_circ(P(l,j,:));
    end
end