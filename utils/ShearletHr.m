function x = ShearletHr(s,shearletSystem)
    x = zeros(size(s,1),size(s,2),8);
    I = shearletSystem.nShearlets;
    for i =1:8
        x(:,:,i) = SLshearrec2D(s(:,:,(i-1)*I+1:i*I),shearletSystem);
    end
end