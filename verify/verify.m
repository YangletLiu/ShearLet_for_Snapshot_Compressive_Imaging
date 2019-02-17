epsilon = 0.04;
ites = 20;
% fname = "kobe32_cacti.mat";
% fname = "3park8_cacti.mat";
fname = "traffic240_cacti";
load(fname)

type_fft = 1;
type_shearlet = 2;
type_curvelet = 3;

x = orig(:,:,1:8);
psnr_s = zeros(ites,1);
ssim_s = zeros(ites,1);
for i = 1:ites
    sprintf("ite%i",i)
    ratio = 0.01*i;
    [~,psnr_s(i),ssim_s(i)] = sparsity(x,ratio,type_shearlet);
end
