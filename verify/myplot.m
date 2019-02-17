x_ = (1:1:20)';
load("verify_kobe1.mat")
y1_ = psnr_s;
load("verify_park1.mat")
y2_ = psnr_s;
load("verify_traffic1.mat")
y3_ = psnr_s;
load("verify_kobe2.mat")
y4_ = psnr_s;
load("verify_park2.mat")
y5_ = psnr_s;
load("verify_traffic2.mat")
y6_ = psnr_s;
figure(3)
hold on
plot(x_,y1_,'--r',x_,y2_,'--k',x_,y3_,'--b',x_,y4_,'-r',x_,y5_,'-k',x_,y6_,'-b','LineWidth',2); %线性，颜色，标记
legend('kobe fft','aerial fft','traffic fft','kobe shearlet','aerial shearlet','traffic shearlet')
set(gca,'XTick',0:2:20)
box on
grid on
xlabel('Top-i (%)')  %x轴坐标描述
ylabel('PSNR (dB)') %y轴坐标描述