function square = col2square(col,N,I)
   % the inverse of the square2col
   if nargin==1
       N = size(col,1);
       square = reshape(col,[sqrt(N),sqrt(N)]);
   else
       square = reshape(col,[sqrt(N),sqrt(N),I]);
   end
   
end