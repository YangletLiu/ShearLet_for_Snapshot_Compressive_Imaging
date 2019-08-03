clear
clc

fname = '3fruit22_cacti.mat';
load(fname);
Row = 512;
Col = 512;
rotnum = 2;
y = meas; % 归一化过，最大是22
Phi = mask;
codedNum = 22;  % How many frames collapsed to 1 measurement

bFig = true;
bShear = true;
sigma = 0.03; 
LAMBDA  = 40;
L       = 10;
niter   = 40; 

x0      = zeros(Row/2, Col/2,codedNum);
L1              = @(x) norm(x, 1);
L2              = @(x) power(norm(x, 'fro'), 2);
COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
    
% measured
y_R = zeros(Row/2, Col/2);
y_B = zeros(Row/2, Col/2);
y_G1 = zeros(Row/2, Col/2);
y_G2 = zeros(Row/2, Col/2);

% masks
Phi_R = zeros(Row/2, Col/2,codedNum);
Phi_B = zeros(Row/2, Col/2,codedNum);
Phi_G1 = zeros(Row/2, Col/2,codedNum);
Phi_G2 = zeros(Row/2, Col/2,codedNum);

% bayer format analysis
for nR = 1:(Row/2)
    for nC = 1:(Col/2)
        y_R(nR,nC) = y((nR-1)*2+1,(nC-1)*2+1);
        y_B(nR,nC) = y((nR-1)*2+2,(nC-1)*2+2);
        y_G1(nR,nC) = y((nR-1)*2+1,(nC-1)*2+2);
        y_G2(nR,nC) = y((nR-1)*2+2,(nC-1)*2+1);
        Phi_R(nR,nC,:) = Phi((nR-1)*2+1,(nC-1)*2+1,:);
        Phi_B(nR,nC,:) = Phi((nR-1)*2+2,(nC-1)*2+2,:);
        Phi_G1(nR,nC,:) = Phi((nR-1)*2+1,(nC-1)*2+2,:);
        Phi_G2(nR,nC,:) = Phi((nR-1)*2+2,(nC-1)*2+1,:);
    end
end
% reconstruct for each color
x_ista = zeros(Row/2, Col/2,codedNum,4);
for rr=1:4
    sprintf("handle %d channel",rr)
    switch rr
        case 1
        	yuse = y_R;
            Phi_use = Phi_R;
        case 2
            yuse = y_G1;
            Phi_use = Phi_G1;
        case 3                      
            yuse = y_G2;          
            Phi_use = Phi_G2;                
        case 4
            yuse = y_B;
            Phi_use = Phi_B;
    end
    
    A       = @(x) sample(Phi_use,ifft2(x),codedNum);
    AT      = @(y) fft2(sampleH(Phi_use,y,codedNum,0));
    COST.function	= @(X) 1/2 * L2(A(X) - yuse) + LAMBDA * L1(X(:));
    
    theta = SeSCI(A, AT, x0, yuse, LAMBDA, L, sigma, niter, COST, bFig, 0,bShear,1);
    theta = real(ifft2(theta));
    x_ista(:,:,(codedNum:-1:1),rr) = theta/255;
end

[Img_recon_sensor X_recon_col] = my_demosaic(Row,Col,1,codedNum,rotnum,x_ista);