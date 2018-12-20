clear
clc
addpath('dataset')
load("kobe32_cacti.mat") %orig,mean,mask

maskFrames = size(mask,3);
[width, height, frames] = size(orig);
unavailableSampled = zeros(width*height,frames);  % calculate the the fai*x for each frame
for i=1:frames
    mask_i = mask(:,:,mod(i,maskFrames)+1);
    mask_i = diag(sparse(mask_i(:)));
    orig_i = orig(:,:,i);
    unavailableSampled(:,i) = mask_i * orig_i(:);
end
fai = mask(:,:,1);
x1 = orig(:,:,1);

% build the Fourier matrix and calculate the kron multiplification of it
if width ~=height
    sprintf("the height and width of image are not coordinate")
else % haven't dealt with the matrix not of 2^k size
    N = width;
    w = exp(-2*pi*1i/N);
    F = zeros(width,height); % here it is 256*256 for kobe32-cacti
    for i =1:N
        for j = 1:N
            F(i,j) = w^((i-1)*(j-1));
        end
    end
    F = F/sqrt(width);
    f = kron(F,F); % may OOM
end

% capital-frequency,lowercase-time
scales = 4;
shearletSystem = SLgetShearletSystem2D(0,size(x1,1),size(x1,2),scales);
s = SLsheardec2D(x1,shearletSystem);
G = shearletSystem.dualFrameWeights; 
H = shearletSystem.shearlets; 
A = Fai*Psi_r;
% X = H_r*S    H_r = H./G   S = H'.*X
recover = FISTA();

