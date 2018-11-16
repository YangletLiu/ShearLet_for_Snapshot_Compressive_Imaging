function [x,y]=tam(P,omiga,L,r)
% Problem state£ºmin|| b - <A,(X*Y)> ||_F^2, s.t.:tubal-rank of X * Y=r
    [m,n,k] = size(omiga);
    y = zeros(r,n,k);
    % x = initialize(P,r);
    x = randn(m,r,k);
    x = fft(x,[],3);
    y = fft(y,[],3);
    P = fft(P,[],3);
    omiga = fft(omiga,[],3);
    for i=1:L
        y = LS_Y(P,omiga,x,n);
        x = LS_X(P,omiga,y,m);
    end
    x = ifft(x,[],3);
    y = ifft(y,[],3);
end

function X = initialize(P,r)
    [U,~,~] = tsvd(P);
    X = U(:,1:r,:);
    X = orth(X);
end

function X = LS_X(P,omiga,Y,m)
    [r,~,k] = size(Y);
    X_t = zeros(r,m,k);
    P_t = tran(P);
    omiga_t = tran(omiga);
    Y_t = tran(Y);
    for j=1:m
        b = tensor_vec(P_t(:,j,:));
        A1 = block_diagonal(Y_t);
        A2 = lateral_circ(omiga_t,j);
        A3 = circtensor_mat(A2);
        A = A3*A1;
        x = A\b;
        for i = 1:r
            X_t(i,j,:) = x((i-1)*k+1:i*k);
        end
    end
    X = tran(X_t);
end

function Y = LS_Y(P,omiga,X,n)
    [~,r,k] = size(X);
    Y = zeros(r,n,k);
    for j=1:n
        b = tensor_vec(P(:,j,:));
        A1 = block_diagonal(X);
        A2 = lateral_circ(omiga,j);
        A3 = circtensor_mat(A2);
        A = A3*A1;
        x = A\b;
        for i = 1:r
            Y(i,j,:) = x((i-1)*k+1:i*k);
        end
    end
end