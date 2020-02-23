x_ = (1:1:20)';
% fft
load("verify_larry1.mat")
y1_ = psnr_s;
load("verify_snoopy1.mat")
y2_ = psnr_s;
% shearlet
load("verify_larry2.mat")
y3_ = psnr_s;
load("verify_snoopy2.mat")
y4_ = psnr_s;
% wavelet
load("verify_larry5.mat")
y5_ = psnr_s;
load("verify_snoopy5.mat")
y6_ = psnr_s;
figure(1)
hold on
p = plot(x_,y3_,'-r',x_,y4_,'-k',x_,y5_,'--r',x_,y6_,'--k',x_,y1_,':r',x_,y2_,':k','LineWidth',3); %线性，颜色，标记
legend({'Larry shearlet','Snoopy shearlet','Larry wavelet','Snoopy wavelet','Larry fft','Snoopy fft'},'NumColumns',3)
set(gca,'XTick',0:2:20)
ax = gca;
ax.FontSize = 30;
box on
grid on
xlabel('Top-i (%)')  %x轴坐标描述
ylabel('PSNR (dB)') %y轴坐标描述