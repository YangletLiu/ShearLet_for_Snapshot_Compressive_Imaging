function y = threshold(x, lambda, type)
% argmin_{x}{ f_1(x) + L/2*||x-u||^2}
% f_1(x) = lambda*||x||_1
% f = lambda*norm(x,1)+L/2*norm(x-u,2)^2;
% it has a closed solution, represented by this script
if nargin < 3
    type = 'soft';
end
switch type
    case 'soft'
        y   = (max(abs(x) - lambda, 0)).*sign(x);
    case 'hard'
        y   = (abs(x) > lambda).*x;
end
end