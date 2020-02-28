ites = 20;
fname = "kobe32_cacti.mat";
% fname = "3park8_cacti.mat";
% fname = "traffic240_cacti";
% fname = "bird24_cassi";
% fname = "toy31_cassi";
% fname = "larry8_cacti";
% fname = "snoopy8_cacti";
load(fname)

type_fft = 1;
type_shearlet_spatial = 2;
type_curvelet = 3; % cannot apply to image which is not square
type_wavelet = 4; % cannot apply to image which is not square
type_wavelet_matlab = 5;
type_shearlet_frequency = 6;

x = orig(:,:,1:8);
psnr_s = zeros(ites,1);
ssim_s = zeros(ites,1);
for i = 1:ites
    sprintf("ite%i",i)
    ratio = 0.01*i;
    [~,psnr_s(i),ssim_s(i)] = sparsity(x,ratio,type_shearlet_frequency);
end
