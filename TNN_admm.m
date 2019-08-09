clear all
close all
clc
% ====================== Load data ==============================
load('traffic8_cacti.mat');
% load('kobe32_cacti.mat');
% load('4park8_cacti.mat');
    Original               =        orig(:,:,1:8)                      ;
    [n1,n2,n3]             =        size(Original)                     ;
    A                      =     diag(sparse(double(mask(1:n1*n2))))   ;     
    for i=2:n3
       S=diag(sparse(double(mask(n1*n2*(i-1)+1:n1*n2*i))))             ;
       A=[A,S];
    end
    bb                     =        meas(:,:,1)                        ; 
    alpha                  =        1                                  ;
    maxItr                 =        500                                ; % maximum iteration
    rho                    =        0.1;%1;%100w/0.001rho;                             ;
    b                      =        bb(:)                              ; % available data
    w = @(ite,iteration) 120;%+100*(1-ite/iteration);
    sigma = 1;
    % ================ main process of completion =======================
    X                      =    tensor_cpl_admm( A , b , rho , alpha , ...
                                [n1,n2,n3], maxItr, w, sigma);
    X                      =        abs(reshape(X,[n1,n2,n3]))         ;
    X_dif                  =        X-Original                         ;
    RSE                    =        norm(X_dif(:))/norm(Original(:))   ;
% ======================== Result Plot =============================
for n=1:n3
    psnr_(n) = psnr(double(X(:,:,n)),double(Original(:,:,n)),max(max(max(double(Original(:,:,n))))));
end

figure(1);
for i = 1:n3  
    subplot(2,8,i);imagesc(X(:,:,i));
    axis off; colormap(gray);  
    subplot(2,8,i+8);imagesc(Original(:,:,i));
    axis off; colormap(gray); 
end


