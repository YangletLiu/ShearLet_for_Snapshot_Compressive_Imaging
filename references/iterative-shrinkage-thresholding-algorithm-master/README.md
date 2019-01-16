# iterative-shrinkage-thresholding-algorithm

## Reference
Proximal Gradient Methods for learning
- https://en.wikipedia.org/wiki/Proximal_gradient_methods_for_learning

## Iterative Shrinkage-Thresholding Algorithm (ISTA)
The class of iterative shrinkage-thresholding algorithms (ISTA) for solving linear inverse problems arising in signal/image processing. This class of methods, which can be viewed as an extension of [the classical gradient algorithm](https://en.wikipedia.org/wiki/Gradient_descent), is attractive due to its simplicity and thus is adequate for solving large-scale problems even with dense matrix data.

## Cost function 
Cost function is fomulated by data fidelty term `1/2 * || A(x) - y ||_2^2` and l1 regularization term `L * || X ||_1` as follow,

        (P1) arg min_x [ 1/2 * || A(x) - y ||_2^2 + L * || x ||_1 ].

Equivalently,

        (P2) arg min_x [ 1/2 * || x - x_(k) ||_2^2 + L * || x ||_1 ],

where,

        x_(k) = x_(k-1) - t_(k) * AT(A(x) - y) and t_(k) is step size. 
        
(P2) is equal to `l1` [proximal operator](https://en.wikipedia.org/wiki/Proximal_operator),

        (P2) = prox_(L * l1)( x_(k) )
        
             = soft_threshold(x_(k), L)
        
where, 

        l1 is || x ||_1 and L is thresholding value.

`soft_threshold` is defined by,
        
        function y = soft_threshold(x, L)
            y = (max(abs(x) - L, 0)).*sign(x);
        end

## The basic iteration ISTA for solving problem (P1 = P2)
        for k = 1 : N
            x_(k+1) = prox_(L * l1)( x_(k) );
        end
        
where, 

        prox_(L * l1)( x ) = soft_threshold(x, L).

