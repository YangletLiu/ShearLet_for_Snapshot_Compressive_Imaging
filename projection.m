function p = projection(z)
    if(real(z)>1) 
        p = 1;
    elseif(real(z)<0)
        p = 0;
    else
        p = real(z);
    end
end