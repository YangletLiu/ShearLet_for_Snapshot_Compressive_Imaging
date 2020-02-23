clear;
load("kobe32_cacti.mat")
x = orig(:,:,1);
shearletSystem = SLgetShearletSystem2D(false,256,256,1);
coeffs = SLsheardec2D(x,shearletSystem);
coeffs(:,:,3) = imadjust(coeffs(:,:,3), [0,1], [1, 0]);
coeffs(:,:,7) = imadjust(coeffs(:,:,7), [0,1], [1, 0]);
figure(1)
colormap gray;
imagesc(coeffs(:,:,3))
set(gca,'xtick',[],'ytick',[]);

figure(2)
colormap gray;
imagesc(coeffs(:,:,7))
set(gca,'xtick',[],'ytick',[]);

