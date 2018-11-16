function norm = Frobenius(tensor,squared)
    [~,~,t] = size(tensor);
    for i=1:t
      tensor(:,:,i) = tensor(:,:,i).*tensor(:,:,i);   
    end
    norm = sum(sum(tensor));
    if(~squared)
        norm = sqrt(norm);
    end
end