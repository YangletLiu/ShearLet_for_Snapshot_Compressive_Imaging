
function [x,history] = tensor_cpl_admm(A,y,rho,alpha,sX,maxItr,w,sigma,varargin)

%set Default
ABSTOL        =    1e-5                                ;
RELTOL        =    1e-5                                ;
t_start       =    tic                                 ;

%% ADMM solver
[~,n]         =    size(A)                             ;
x             =    zeros(n,1)                          ;
z             =    zeros(n,1)                          ;
u             =    zeros(n,1)                          ;
zhat          =    zeros(n,1)                          ;
uhat          =    zeros(n,1)                          ;
q             =    sparse(y)                           ;

shearletSystem = SLgetShearletSystem2D(false,sX(1),sX(2),1);

for k         =     1 : maxItr   
    zold      =     z                                  ;
    uold      =     u                                  ;
    one       =     ones(n,1)                          ;
    one       =     diag(sparse(double(one)))          ;   
    x         =     (A'*A+rho*one)\(rho*zhat - uhat + A'*q)          ;    
    z         =     reshape((x + 1/rho*uhat),sX);
%     z         =     tvdenoise(z,rho,3)                 ; 
%     z         =     tvdenoise(z,0.003,3)               ;
%     z         =     tvdenoise(z,0.001,3)               ;
%     z         =     tvdenoise(z,0.0007,3)              ;

%     z_hat = myfft(z);
%     for j = 1:size(z_hat,3)
%         z_hat(:,:,j) = wnnm(z_hat(:,:,j),sqrt(2),w(k,maxItr)); % wnnm ²åÖµ
%     end
%     z = myifft(z_hat);
    
    Z = fft2(z);
    Z = threshold(Z, w(k,maxItr)); 
    z = ifft2(Z);
    z = shealetShrinkage(z,sigma,shearletSystem,false,false);
    z = projection(z,1);

    figure(1); 
    colormap gray;
    subplot(121); 
    imagesc(z(:,:,1));           
    subplot(122); 
    imagesc(z(:,:,8));

        
    z         =     z(:)                               ;
    u         =     uhat + rho*(x - z)                 ;
    r_norm    =     norm(x-z)                          ;
    s_norm    =     norm(-rho*(z - zold))              ;
    %% apply acceleration.
    Ek = -1;
    if k > 1
       Ek = max(history.r_norm(k-1),...
               history.s_norm(k-1))-max(r_norm,s_norm) ; 
    end
   
    if Ek > 0
        alpha_old = alpha                              ;
        alpha =  (1+sqrt(1+4*alpha^2))/2               ;
        zhat  =  z + (alpha_old-1)/alpha*(z - zold)    ;
        uhat  =  u + (alpha_old-1)/alpha*(u - uold)    ;
        
    else
        alpha =  1                                     ;
        uhat  =  u                                     ;
        zhat  =  z                                     ; 
    end   
    %% diagnostics, reporting, termination checks
    history.r_norm(k)   =  r_norm                      ;
    history.s_norm(k)   =  s_norm                      ; 
    history.eps_pri(k)  = sqrt(n)*ABSTOL + ...
                          RELTOL*max(norm(x), norm(-z));
    history.eps_dual(k) = sqrt(n)*ABSTOL + ...
                          RELTOL*norm(rho*u)           ;
    fprintf('%3d\t%10.4f\t%10.4f\t%10.6f\t%10.6f\t\n', k, ...
           history.r_norm(k), history.eps_pri(k), ...
           history.s_norm(k), history.eps_dual(k))      ;

    if (history.r_norm(k) < history.eps_pri(k) && ...
        history.s_norm(k) < history.eps_dual(k))
        break;
    end
end
toc(t_start);
end

function output=myfft(input)
    output = zeros(size(input));
    for i =1:size(input,1)
        for j=1:size(input,2)
            output(i,j,:) = fft(input(i,j,:));
        end
    end 
end


function output=myifft(input)
    output = zeros(size(input));
    for i =1:size(input,1)
        for j=1:size(input,2)
            output(i,j,:) = ifft(input(i,j,:));
        end
    end 
end

function Xrec = shealetShrinkage(Xnoisy,sigma,shearletSystem,bGPU,bReal)
    Xrec = zeros(size(Xnoisy));
    if bGPU
        Xrec = gpuArray(single(Xrec));
    end
    if bReal
        thresholdingFactor = [0 1 1 1 3.5];
    else
        thresholdingFactor = [0 4]; % 1 for lowpass, 2 for scale 1
    end
    codedFrame = size(Xnoisy,3);
    for i=1:codedFrame
        coeffs = SLsheardec2D(Xnoisy(:,:,i),shearletSystem);
        for j = 1:shearletSystem.nShearlets
            idx = shearletSystem.shearletIdxs(j,:);
            coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*shearletSystem.RMS(j)*sigma);
        end
        Xrec(:,:,i) = SLshearrec2D(coeffs,shearletSystem);
    end
end