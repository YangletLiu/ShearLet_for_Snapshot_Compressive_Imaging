x_ = (1:1:20)';
% fft
load("verify_kobe1.mat")
y1_ = psnr_s;
load("verify_park1.mat")
y2_ = psnr_s;
load("verify_traffic1.mat")
y3_ = psnr_s;
% shearlet
load("verify_kobe2.mat")
y4_ = psnr_s;
load("verify_park2.mat")
y5_ = psnr_s;
load("verify_traffic2.mat")
y6_ = psnr_s;
% wavelet
load("verify_kobe5.mat")
y7_ = psnr_s;
load("verify_park5.mat")
y8_ = psnr_s;
load("verify_traffic5.mat")
y9_ = psnr_s;
figure(3)
hold on
p = plot(x_,y4_,'-r',x_,y5_,'-k',x_,y6_,'-b',x_,y7_,'--r',x_,y8_,'--k',x_,y9_,'--b',x_,y1_,':r',x_,y2_,':k',x_,y3_,':b','LineWidth',3); %线性，颜色，标记
legend({'Kobe shearlet','Aerial shearlet','Traffic shearlet','Kobe wavelet','Aerial wavelet','Traffic wavelet','Kobe fft','Aerial fft','Traffic fft'},'NumColumns',3)
set(gca,'XTick',0:2:20)
ax = gca;
ax.FontSize = 30;
box on
grid on
xlabel('Top-$p$ (\%)','Interpreter','latex','Color','k')  %x轴坐标描述
ylabel('PSNR (dB)') %y轴坐标描述