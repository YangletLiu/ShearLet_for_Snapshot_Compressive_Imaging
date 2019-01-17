function u = prox(u,L,lambda)
    % argmin_{x}{ f_1(x) + L/2*||x-u||^2}
    % f_1(x) = lambda*||x||_1
    % f = lambda*norm(x,1)+L/2*norm(x-u,2)^2;
    % it has a closed solution, represented by this script
    beta = abs(lambda/L);
    u = (max(abs(u) - beta, 0)).*sign(u);
end