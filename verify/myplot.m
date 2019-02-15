x_ = (0.01:0.01:0.1)';
y1_ = psnr_s;
figure(3)
hold on
plot(x_,y1_,'-*b'); %线性，颜色，标记
title('PSNR vs Coefficient Ratio')
set(gca,'XTick',0:0.01:0.1)
xlabel('Ratio')  %x轴坐标描述
ylabel('PSNR/dB') %y轴坐标描述