function col = square2col(square)
    % our calculation is on each column, 
    % so can use reshape function directly
    n = size(square,1);
    col = reshape(square,[n^2,1]);
end
