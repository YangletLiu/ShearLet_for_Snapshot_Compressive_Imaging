function output = diagInv(input)
    % the input and output are both vector of n¡Á1
    len = length(input);
    output = zeros(len,1);
    for i=1:len
        if input(i) ~= 0
            output(i) = 1/input(i);
        end
    end
end