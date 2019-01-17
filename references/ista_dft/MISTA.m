%% Reference
% https://people.rennes.inria.fr/Cedric.Herzet/Cedric.Herzet/Sparse_Seminar/Entrees/2012/11/12_A_Fast_Iterative_Shrinkage-Thresholding_Algorithmfor_Linear_Inverse_Problems_(A._Beck,_M._Teboulle)_files/Breck_2009.pdf

%% COST FUNCTION
% x^* = argmin_x { 1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1 }
%
% x^k+1 = threshold(x^k - 1/L*AT(A(x^k)) - Y), lambda/L)

%%
function [X, obj]  = MISTA(A, AT, X, b, LAMBDA, L, n, COST, bfig)

if (nargin < 9)
    bfig = false;
end

if (nargin < 8 || isempty(COST))
    COST.function	= @(x) (0);
    COST.equation	= [];
end

if (nargin < 7)
    n   = 1e2;
end

obj     = zeros(n, 1);

for i = 1:n
    X       = threshold(X - 1/L*AT(A(X) - b), LAMBDA/L); % 这里因为我们知道A函数其实对应的是某个矩阵，都是线性变换，所以必然有AT(A(x)-b) = AT(A(x))-AT(b)
    
    obj(i)  = COST.function(X);
    
    if (bfig)
        img_x = ifft2(X);
        figure(1); colormap gray;
        subplot(121); imagesc(img_x);           title([num2str(i) ' / ' num2str(n)]);
        subplot(122); semilogy(obj, '*-');  title(COST.equation);  xlabel('# of iteration');   ylabel('Objective'); 
                                            xlim([1, n]);   grid on; grid minor;
        drawnow();
    end
end

X   = gather(X);
obj = gather(obj);

%% add back tracking?

end
