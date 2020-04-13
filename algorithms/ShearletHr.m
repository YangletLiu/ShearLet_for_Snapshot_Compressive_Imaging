function x = ShearletHr(s,shearletSystem,frames)
    x = zeros(size(s,1),size(s,2),frames);
    I = shearletSystem.nShearlets;
    for i =1:frames
        x(:,:,i) = SLshearrec2D(s(:,:,(i-1)*I+1:i*I),shearletSystem);
    end
end