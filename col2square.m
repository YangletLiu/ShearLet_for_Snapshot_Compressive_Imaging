function square = col2square(col)
   % the inverse of the square2col
   N = size(col,1);
   square = reshape(col,[sqrt(N),sqrt(N)]);
end