x_ = (1:1:20)';
% fft
load("verify_bird1.mat")
y1_ = psnr_s;
load("verify_toy1.mat")
y2_ = psnr_s;
% shearlet
load("verify_bird2.mat")
y3_ = psnr_s;
load("verify_toy2.mat")
y4_ = psnr_s;
% wavelet
load("verify_bird5.mat")
y5_ = psnr_s;
load("verify_toy5.mat")
y6_ = psnr_s;
figure(1)
hold on
p = plot(x_,y3_,'-r',x_,y4_,'-k',x_,y5_,'--r',x_,y6_,'--k',x_,y1_,':r',x_,y2_,':k','LineWidth',3); %线性，颜色，标记
legend({'Bird shearlet','Toy shearlet','Bird wavelet','Toy wavelet','Bird fft','Toy fft'},'NumColumns',3)
set(gca,'XTick',0:2:20)
ax = gca;
ax.FontSize = 30;
box on
grid on
xlabel('Top-p (%)')  %x轴坐标描述
ylabel('PSNR (dB)') %y轴坐标描述