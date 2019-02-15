epsilon = 0.04;
ites = 10;
x = double(imread('lena.jpg'));

psnr_s = zeros(ites,1);
ssim_s = zeros(ites,1);
psnr_f = zeros(ites,1);
ssim_f = zeros(ites,1);
for i = 1:ites
    sprintf("ite%i",i)
    ratio = 0.01*i;
    [shearRec, freqRec] = sparsity(x,ratio);
    psnr_s(i) = psnr(x/255,shearRec/255);
    ssim_s(i) = ssim(x/255,shearRec/255);
    psnr_f(i) = psnr(x/255,freqRec/255);
    ssim_f(i) = ssim(x/255,freqRec/255);
end
