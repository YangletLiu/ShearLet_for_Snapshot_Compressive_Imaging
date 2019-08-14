function y = threshold_complex(x, lambda, type)
% argmin_{x}{ f_1(x) + L/2*||x-u||^2}
% f_1(x) = lambda*||x||_1
% f = lambda*norm(x,1)+L/2*norm(x-u,2)^2;
% it has a closed solution, represented by this script
if nargin < 3
    type = 'soft';
end
xnorm = conj(x).*x;
switch type
    case 'soft'
        y   = (xnorm > lambda).*x.*sqrt((1-lambda./xnorm));
    case 'hard'
        y   = (xnorm > lambda).*x;
end
end

%% test
% x = [3+i,2+i,-3+2i,-1+i,2-i,5i]';
% lambda = 9;
% x1 = threshold_complex(x,lambda);
% x2 = threshold_complex(x,lambda,'hard');