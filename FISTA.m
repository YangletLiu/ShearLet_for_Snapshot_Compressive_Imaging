function s = FISTA(s0,iteration,A,y,L,lambda)
    % FISTA for y = f_1(s)+f_2(s)
    % f_1(s) = lambda*||s||_1
    % f_2(s) = 1/2||y-A*s||^2
    % A is m×n
    [~,n] = size(A);
    sk = s0;
    r = s0;
    u = zeros(n);
    tk = 1;
    for k = 1:iteration
        u = r-1/L*(A'*A)*r+1/L*A'*y; %展开二次项求导取共轭转置
        skk = prox(u,L,lambda);
        tkk = (1+sqrt(1+4*tk^2))/2;
        r = skk+(tk-1)/tkk*(skk-sk);
        sk = skk;
    end
    s = skk;
end