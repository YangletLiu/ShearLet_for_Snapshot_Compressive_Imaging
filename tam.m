function [X,Y]=tam(T,P,omiga,L,r,epsilon,mu)
% Problem state£ºmin|| b - <A,(U*V)> ||_F^2, s.t.:tubal-rank of X * Y=r
    [n,m,k] = size(omiga);
    x = zeros(m,r,k,L);
    y = zeros(r,n,k,L);
    x(1) = initialize(P,r);
    for i=2:L+1
        y(i) = LS_X(P,omiga,x(i-1),r);
        x(i) = LS_Y(P,omiga,y(i),r);
    end
end

function X = initialize(P,r)
    [U,~,~] = tsvd(P);
    X = U(:,1:r,:);
    X = orth(X);
end

function X = LS_X(P,omiga,Y,r)

end

function Y = LS_Y(P,omiga,X,r)

end