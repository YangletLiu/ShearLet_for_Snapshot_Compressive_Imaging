function output = nsampleH(M,y,codedNum,positive,negtive,d)
    output = zeros(size(M));
    for i =1:codedNum
        temp = zeros(256,256);
        Mtemp = M(:,:,i);
        for j=1:32768/d
            temp(positive(j,:)) = Mtemp(positive(j,:))*y(j);
            temp(negtive(j,:)) = -Mtemp(negtive(j,:))*y(j);
        end
        output(:,:,i) = temp;
    end
end