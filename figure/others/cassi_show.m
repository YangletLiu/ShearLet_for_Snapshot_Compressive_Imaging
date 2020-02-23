%% patch
LINEWIDTH = 3;
FONTSIZE = 16;
R = 20;
C = 20;
% %% toy
% % (330:350,160:180)
% % (180:200,360:380)
% % (400:420,360:380)
% % (450:470,360:380)
figure()
imagesc(orig_rgb);
axis off;
rectangle('Position',[160,330,20,20],'LineWidth',2,'EdgeColor','r');
rectangle('Position',[360,200,20,20],'LineWidth',2,'EdgeColor','r');
rectangle('Position',[360,400,20,20],'LineWidth',2,'EdgeColor','r');
rectangle('Position',[360,450,20,20],'LineWidth',2,'EdgeColor','r');
% x_ista_p1 = squeeze(sum(sum(x_ista(330:330+R,160:160+C,:))))/441/256;
x_ista_p2 = squeeze(sum(sum(x_ista(200:200+R,360:360+C,:))))/441/256;
% x_ista_p3 = squeeze(sum(sum(x_ista(400:400+R,360:360+C,:))))/441/256;
% x_ista_p4 = squeeze(sum(sum(x_ista(450:450+R,360:360+C,:))))/441/256;
% vgaptv_p1 = squeeze(sum(sum(vgaptv(330:330+R,160:160+C,:))))/441;
vgaptv_p2 = squeeze(sum(sum(vgaptv(200:200+R,360:360+C,:))))/441;
% vgaptv_p3 = squeeze(sum(sum(vgaptv(400:400+R,360:360+C,:))))/441;
% vgaptv_p4 = squeeze(sum(sum(vgaptv(450:450+R,360:360+C,:))))/441;
% vdesci_p1 = squeeze(sum(sum(vdesci(330:330+R,160:160+C,:))))/441;
vdesci_p2 = squeeze(sum(sum(vdesci(200:200+R,360:360+C,:))))/441;
% vdesci_p3 = squeeze(sum(sum(vdesci(400:400+R,360:360+C,:))))/441;
% vdesci_p4 = squeeze(sum(sum(vdesci(450:450+R,360:360+C,:))))/441;
% x_p1 = squeeze(sum(sum(x(330:330+R,160:160+C,:))))/441/256;
x_p2 = squeeze(sum(sum(x(200:200+R,360:360+C,:))))/441/256;
% x_p3 = squeeze(sum(sum(x(400:400+R,360:360+C,:))))/441/256;
% x_p4 = squeeze(sum(sum(x(450:450+R,360:360+C,:))))/441/256;
% ci1 = corrcoef(x_p1,x_ista_p1);
% cd1 = corrcoef(x_p1,vdesci_p1);
% ct1 = corrcoef(x_p1,vgaptv_p1);
% 
ci2 = corrcoef(x_p2,x_ista_p2);
cd2 = corrcoef(x_p2,vdesci_p2);
ct2 = corrcoef(x_p2,vgaptv_p2);
% 
% ci3 = corrcoef(x_p3,x_ista_p3);
% cd3 = corrcoef(x_p3,vdesci_p3);
% ct3 = corrcoef(x_p3,vgaptv_p3);
% 
% ci4 = corrcoef(x_p4,x_ista_p4);
% cd4 = corrcoef(x_p4,vdesci_p4);
% ct4 = corrcoef(x_p4,vgaptv_p4);
% 
% figure();
% plot(wavelength,x_p1,'-*k',wavelength,x_ista_p1,'-*r',wavelength,vgaptv_p1,'--*b',wavelength,vdesci_p1,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci1(1,2),4)],['GAP-TV:',num2str(ct1(1,2),4)],['DeSCI:',num2str(cd1(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% %title('brown','FontSize',FONTSIZE,'FontWeight','bold');
figure();
plot(wavelength,x_p2,'-*k',wavelength,x_ista_p2,'-*r',wavelength,vgaptv_p2,'--*b',wavelength,vdesci_p2,'--*c','LineWidth',LINEWIDTH);
h = legend('Ground truth',['SeSCI:' num2str(ci2(1,2),4)],['GAP-TV:' num2str(ct2(1,2),4)],['DeSCI:' num2str(cd2(1,2),4)],'Location','NorthWest');
set(h,'Box','off','FontSize',FONTSIZE);
xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
%title('orange','FontSize',FONTSIZE,'FontWeight','bold');
% figure();
% plot(wavelength,x_p3,'-*k',wavelength,x_ista_p3,'-*r',wavelength,vgaptv_p3,'--*b',wavelength,vdesci_p3,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci3(1,2),4)],['GAP-TV:' num2str(ct3(1,2),4)],['DeSCI:' num2str(cd3(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% % title('blue','FontSize',FONTSIZE,'FontWeight','bold');
% figure();
% plot(wavelength,x_p4,'-*k',wavelength,x_ista_p4,'-*r',wavelength,vgaptv_p4,'--*b',wavelength,vdesci_p4,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci4(1,2),4)],['GAP-TV:' num2str(ct4(1,2),4)],['DeSCI:' num2str(cd4(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% % title('red','FontSize',FONTSIZE,'FontWeight','bold');

%% bird
% (600:620,50:70)
% (600:620,380:400)
% (600:620,700:720)
% (600:620,980:1000)
figure()
imagesc(orig_rgb);
axis off;
rectangle('Position',[50,600,20,20],'LineWidth',2,'EdgeColor','r');
rectangle('Position',[380,600,20,20],'LineWidth',2,'EdgeColor','r');
rectangle('Position',[700,600,20,20],'LineWidth',2,'EdgeColor','r');
rectangle('Position',[980,600,20,20],'LineWidth',2,'EdgeColor','r');
% rectangle('Position',[100,400,50,50],'LineWidth',2,'EdgeColor','r');
% rectangle('Position',[300,400,50,50],'LineWidth',2,'EdgeColor','r');
% x_ista_p1 = squeeze(sum(sum(x_ista(600:600+R,50:50+C,:))))/(R*C)/256;
% x_ista_p2 = squeeze(sum(sum(x_ista(600:600+R,380:380+C,:))))/(R*C)/256;
% x_ista_p3 = squeeze(sum(sum(x_ista(600:600+R,700:700+C,:))))/(R*C)/256;
% x_ista_p4 = squeeze(sum(sum(x_ista(600:600+R,980:980+C,:))))/(R*C)/256;
% vgaptv_p1 = squeeze(sum(sum(vgaptv(600:600+R,50:50+C,:))))/(R*C);
% vgaptv_p2 = squeeze(sum(sum(vgaptv(600:600+R,380:380+C,:))))/(R*C);
% vgaptv_p3 = squeeze(sum(sum(vgaptv(600:600+R,700:700+C,:))))/(R*C);
% vgaptv_p4 = squeeze(sum(sum(vgaptv(600:600+R,980:980+C,:))))/(R*C);
% vdesci_p1 = squeeze(sum(sum(vdesci(600:600+R,50:50+C,:))))/(R*C);
% vdesci_p2 = squeeze(sum(sum(vdesci(600:600+R,380:380+C,:))))/(R*C);
% vdesci_p3 = squeeze(sum(sum(vdesci(600:600+R,700:700+C,:))))/(R*C);
% vdesci_p4 = squeeze(sum(sum(vdesci(600:600+R,980:980+C,:))))/(R*C);
% x_p1 = squeeze(sum(sum(x(600:600+R,50:50+C,:))))/(R*C)/256;
% x_p2 = squeeze(sum(sum(x(600:600+R,380:380+C,:))))/(R*C)/256;
% x_p3 = squeeze(sum(sum(x(600:600+R,700:700+C,:))))/(R*C)/256;
% x_p4 = squeeze(sum(sum(x(600:600+R,980:980+C,:))))/(R*C)/256;
% 
% x_ista_b1 = squeeze(sum(sum(x_ista(400:450,100:150,:))))/(50*50)/256;
% x_ista_b2 = squeeze(sum(sum(x_ista(400:450,300:350,:))))/(50*50)/256;
% vgaptv_b1 = squeeze(sum(sum(vgaptv(400:450,100:150,:))))/(50*50);
% vgaptv_b2 = squeeze(sum(sum(vgaptv(400:450,300:350,:))))/(50*50);
% vdesci_b1 = squeeze(sum(sum(vdesci(400:450,100:150,:))))/(50*50);
% vdesci_b2 = squeeze(sum(sum(vdesci(400:450,300:350,:))))/(50*50);
% x_b1 = squeeze(sum(sum(x(400:450,100:150,:))))/(50*50)/256;
% x_b2 = squeeze(sum(sum(x(400:450,300:350,:))))/(50*50)/256;
% 
% x_ista_p1p2 = x_ista_b1./x_ista_b2;
% vgaptv_p1p2 = vgaptv_b1./vgaptv_b2;
% vdesci_p1p2 = vdesci_b1./vdesci_b2;
% x_p1p2 = x_b1./x_b2;
% ci5 = corrcoef(x_p1p2,x_ista_p1p2);
% cd5 = corrcoef(x_p1p2,vgaptv_p1p2);
% ct5 = corrcoef(x_p1p2,vdesci_p1p2);
% 
% figure();
% plot(wavelength,x_p1p2,'-*k',wavelength,x_ista_p1p2,'-*r',wavelength,vgaptv_p1p2,'--*b',wavelength,vdesci_p1p2,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci5(1,2),4)],['GAP-TV:',num2str(ct5(1,2),4)],['DeSCI:',num2str(cd5(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');

% 
% ci1 = corrcoef(x_p1,x_ista_p1);
% cd1 = corrcoef(x_p1,vdesci_p1);
% ct1 = corrcoef(x_p1,vgaptv_p1);
% 
% ci2 = corrcoef(x_p2,x_ista_p2);
% cd2 = corrcoef(x_p2,vdesci_p2);
% ct2 = corrcoef(x_p2,vgaptv_p2);
% 
% ci3 = corrcoef(x_p3,x_ista_p3);
% cd3 = corrcoef(x_p3,vdesci_p3);
% ct3 = corrcoef(x_p3,vgaptv_p3);
% 
% ci4 = corrcoef(x_p4,x_ista_p4);
% cd4 = corrcoef(x_p4,vdesci_p4);
% ct4 = corrcoef(x_p4,vgaptv_p4);
% 
% 
% figure();
% plot(wavelength,x_p1,'-*k',wavelength,x_ista_p1,'-*r',wavelength,vgaptv_p1,'--*b',wavelength,vdesci_p1,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci1(1,2),4)],['GAP-TV:',num2str(ct1(1,2),4)],['DeSCI:',num2str(cd1(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% title('yellow','FontSize',FONTSIZE,'FontWeight','bold');
% figure();
% plot(wavelength,x_p2,'-*k',wavelength,x_ista_p2,'-*r',wavelength,vgaptv_p2,'--*b',wavelength,vdesci_p2,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci2(1,2),4)],['GAP-TV:' num2str(ct2(1,2),4)],['DeSCI:' num2str(cd2(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% title('green','FontSize',FONTSIZE,'FontWeight','bold');
% figure();
% plot(wavelength,x_p3,'-*k',wavelength,x_ista_p3,'-*r',wavelength,vgaptv_p3,'--*b',wavelength,vdesci_p3,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci3(1,2),4)],['GAP-TV:' num2str(ct3(1,2),4)],['DeSCI:' num2str(cd3(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% title('blue','FontSize',FONTSIZE,'FontWeight','bold');
% figure();
% plot(wavelength,x_p4,'-*k',wavelength,x_ista_p4,'-*r',wavelength,vgaptv_p4,'--*b',wavelength,vdesci_p4,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci4(1,2),4)],['GAP-TV:' num2str(ct4(1,2),4)],['DeSCI:' num2str(cd4(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% title('purple','FontSize',FONTSIZE,'FontWeight','bold');

%% object
% (140:160,25:45)
% (160:180,70:90)
% (140:160,150:170)
% (140:160,210:230)
% x_ista_p1 = squeeze(sum(sum(x_ista(140:140+R,25:25+C,:))))/(R*C)/256;
% x_ista_p2 = squeeze(sum(sum(x_ista(160:160+R,70:70+C,:))))/(R*C)/256;
% x_ista_p3 = squeeze(sum(sum(x_ista(140:140+R,150:150+C,:))))/(R*C)/256;
% x_ista_p4 = squeeze(sum(sum(x_ista(140:140+R,210:210+C,:))))/(R*C)/256;
% vadmmtv_p1 = squeeze(sum(sum(vadmmtv(140:140+R,25:25+C,:))))/(R*C);
% vadmmtv_p2 = squeeze(sum(sum(vadmmtv(160:160+R,70:70+C,:))))/(R*C);
% vadmmtv_p3 = squeeze(sum(sum(vadmmtv(140:140+R,150:150+C,:))))/(R*C);
% vadmmtv_p4 = squeeze(sum(sum(vadmmtv(140:140+R,210:210+C,:))))/(R*C);
% vdesci_p1 = squeeze(sum(sum(vdesci(140:140+R,25:25+C,:))))/(R*C);
% vdesci_p2 = squeeze(sum(sum(vdesci(160:160+R,70:70+C,:))))/(R*C);
% vdesci_p3 = squeeze(sum(sum(vdesci(140:140+R,150:150+C,:))))/(R*C);
% vdesci_p4 = squeeze(sum(sum(vdesci(140:140+R,210:210+C,:))))/(R*C);
% x_p1 = squeeze(sum(sum(x(140:140+R,25:25+C,:))))/(R*C)/256;
% x_p2 = squeeze(sum(sum(x(160:160+R,70:70+C,:))))/(R*C)/256;
% x_p3 = squeeze(sum(sum(x(140:140+R,150:150+C,:))))/(R*C)/256;
% x_p4 = squeeze(sum(sum(x(140:140+R,210:210+C,:))))/(R*C)/256;
% 
% ci1 = corrcoef(x_p1,x_ista_p1);
% cd1 = corrcoef(x_p1,vdesci_p1);
% ct1 = corrcoef(x_p1,vadmmtv_p1);
% 
% ci2 = corrcoef(x_p2,x_ista_p2);
% cd2 = corrcoef(x_p2,vdesci_p2);
% ct2 = corrcoef(x_p2,vadmmtv_p2);
% 
% ci3 = corrcoef(x_p3,x_ista_p3);
% cd3 = corrcoef(x_p3,vdesci_p3);
% ct3 = corrcoef(x_p3,vadmmtv_p3);
% 
% ci4 = corrcoef(x_p4,x_ista_p4);
% cd4 = corrcoef(x_p4,vdesci_p4);
% ct4 = corrcoef(x_p4,vadmmtv_p4);
% 
% 
% figure();
% plot(wavelength,x_p1,'-*k',wavelength,x_ista_p1,'-*r',wavelength,vadmmtv_p1,'--*b',wavelength,vdesci_p1,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci1(1,2),4)],['GAP-TV:',num2str(ct1(1,2),4)],['DeSCI:',num2str(cd1(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% title('yellow','FontSize',FONTSIZE,'FontWeight','bold');
% figure();
% plot(wavelength,x_p2,'-*k',wavelength,x_ista_p2,'-*r',wavelength,vadmmtv_p2,'--*b',wavelength,vdesci_p2,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci2(1,2),4)],['GAP-TV:' num2str(ct2(1,2),4)],['DeSCI:' num2str(cd2(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% title('red','FontSize',FONTSIZE,'FontWeight','bold');
% figure();
% plot(wavelength,x_p3,'-*k',wavelength,x_ista_p3,'-*r',wavelength,vadmmtv_p3,'--*b',wavelength,vdesci_p3,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci3(1,2),4)],['GAP-TV:' num2str(ct3(1,2),4)],['DeSCI:' num2str(cd3(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% title('blue','FontSize',FONTSIZE,'FontWeight','bold');
% figure();
% plot(wavelength,x_p4,'-*k',wavelength,x_ista_p4,'-*r',wavelength,vadmmtv_p4,'--*b',wavelength,vdesci_p4,'--*c','LineWidth',LINEWIDTH);
% h = legend('Ground truth',['SeSCI:' num2str(ci4(1,2),4)],['GAP-TV:' num2str(ct4(1,2),4)],['DeSCI:' num2str(cd4(1,2),4)],'Location','NorthWest');
% set(h,'Box','off','FontSize',FONTSIZE);
% xlabel("wavelength (nm)",'FontSize',FONTSIZE,'FontWeight','bold');
% ylabel('intensity (a.u.)','FontSize',FONTSIZE,'FontWeight','bold');
% title('green','FontSize',FONTSIZE,'FontWeight','bold');

%% image
% %% toy
% % orig
% % coded
% % wavelength 400
% % 490 
% % 590 
% % 700
% figure();
% imagesc(orig_rgb);
% axis off;
% 
% figure();
% imagesc(y)
% colormap gray
% axis off;
% 
% figure();
% imagesc(orig(:,:,1))
% mycolormap(wavelen2rgb(wavelength(1)))
% axis off;
% figure();
% imagesc(x_ista(:,:,1))
% mycolormap(wavelen2rgb(wavelength(1)))
% axis off;
% figure();
% imagesc(vgaptv(:,:,1))
% mycolormap(wavelen2rgb(wavelength(1)))
% axis off;
% figure();
% imagesc(vdesci(:,:,1))
% mycolormap(wavelen2rgb(wavelength(1)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,10))
% mycolormap(wavelen2rgb(wavelength(10)))
% axis off;
% figure();
% imagesc(x_ista(:,:,10))
% mycolormap(wavelen2rgb(wavelength(10)))
% axis off;
% figure();
% imagesc(vgaptv(:,:,10))
% mycolormap(wavelen2rgb(wavelength(10)))
% axis off;
% figure();
% imagesc(vdesci(:,:,10))
% mycolormap(wavelen2rgb(wavelength(10)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,20))
% mycolormap(wavelen2rgb(wavelength(20)))
% axis off;
% figure();
% imagesc(x_ista(:,:,20))
% mycolormap(wavelen2rgb(wavelength(20)))
% axis off;
% figure();
% imagesc(vgaptv(:,:,20))
% mycolormap(wavelen2rgb(wavelength(20)))
% axis off;
% figure();
% imagesc(vdesci(:,:,20))
% mycolormap(wavelen2rgb(wavelength(20)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,31))
% mycolormap(wavelen2rgb(wavelength(31)))
% axis off;
% figure();
% imagesc(x_ista(:,:,31))
% mycolormap(wavelen2rgb(wavelength(31)))
% axis off;
% figure();
% imagesc(vgaptv(:,:,31))
% mycolormap(wavelen2rgb(wavelength(31)))
% axis off;
% figure();
% imagesc(vdesci(:,:,31))
% mycolormap(wavelen2rgb(wavelength(31)))
% axis off;

% %% bird
% % orig
% % coded
% % 457
% % 478
% % 541
% % 630
% figure();
% imagesc(orig_rgb);
% axis off;
% figure();
% imagesc(y)
% colormap gray
% axis off;
% 
% figure();
% imagesc(orig(:,:,9))
% mycolormap(wavelen2rgb(wavelength(9)))
% axis off;
% figure();
% imagesc(x_ista(:,:,9))
% mycolormap(wavelen2rgb(wavelength(9)))
% axis off;
% figure();
% imagesc(vgaptv(:,:,9))
% mycolormap(wavelen2rgb(wavelength(9)))
% axis off;
% figure();
% imagesc(vdesci(:,:,9))
% mycolormap(wavelen2rgb(wavelength(9)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,11))
% mycolormap(wavelen2rgb(wavelength(11)))
% axis off;
% figure();
% imagesc(x_ista(:,:,11))
% mycolormap(wavelen2rgb(wavelength(11)))
% axis off;
% figure();
% imagesc(vgaptv(:,:,11))
% mycolormap(wavelen2rgb(wavelength(11)))
% axis off;
% figure();
% imagesc(vdesci(:,:,11))
% mycolormap(wavelen2rgb(wavelength(11)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,16))
% mycolormap(wavelen2rgb(wavelength(16)))
% axis off;
% figure();
% imagesc(x_ista(:,:,16))
% mycolormap(wavelen2rgb(wavelength(16)))
% axis off;
% figure();
% imagesc(vgaptv(:,:,16))
% mycolormap(wavelen2rgb(wavelength(16)))
% axis off;
% figure();
% imagesc(vdesci(:,:,16))
% mycolormap(wavelen2rgb(wavelength(16)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,21))
% mycolormap(wavelen2rgb(wavelength(21)))
% axis off;
% figure();
% imagesc(x_ista(:,:,21))
% mycolormap(wavelen2rgb(wavelength(21)))
% axis off;
% figure();
% imagesc(vgaptv(:,:,21))
% mycolormap(wavelen2rgb(wavelength(21)))
% axis off;
% figure();
% imagesc(vdesci(:,:,21))
% mycolormap(wavelen2rgb(wavelength(21)))
% axis off;
% 
% %% object
% % coded
% % 483
% % 549
% % 579
% % 626
% figure();
% imagesc(orig_rgb);
% axis off;
% figure();
% imagesc(meas)
% colormap gray
% axis off;
% 
% figure();
% imagesc(orig(:,:,9))
% mycolormap(wavelen2rgb(wavelength(9)))
% axis off;
% figure();
% imagesc(x_ista(:,:,9))
% mycolormap(wavelen2rgb(wavelength(9)))
% axis off;
% figure();
% imagesc(vadmmtv(:,:,9))
% mycolormap(wavelen2rgb(wavelength(9)))
% axis off;
% figure();
% imagesc(vdesci(:,:,9))
% mycolormap(wavelen2rgb(wavelength(9)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,22))
% mycolormap(wavelen2rgb(wavelength(22)))
% axis off;
% figure();
% imagesc(x_ista(:,:,22))
% mycolormap(wavelen2rgb(wavelength(22)))
% axis off;
% figure();
% imagesc(vadmmtv(:,:,22))
% mycolormap(wavelen2rgb(wavelength(22)))
% axis off;
% figure();
% imagesc(vdesci(:,:,22))
% mycolormap(wavelen2rgb(wavelength(22)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,26))
% mycolormap(wavelen2rgb(wavelength(26)))
% axis off;
% figure();
% imagesc(x_ista(:,:,26))
% mycolormap(wavelen2rgb(wavelength(26)))
% axis off;
% figure();
% imagesc(vadmmtv(:,:,26))
% mycolormap(wavelen2rgb(wavelength(26)))
% axis off;
% figure();
% imagesc(vdesci(:,:,26))
% mycolormap(wavelen2rgb(wavelength(26)))
% axis off;
% 
% figure();
% imagesc(orig(:,:,31))
% mycolormap(wavelen2rgb(wavelength(31)))
% axis off;
% figure();
% imagesc(x_ista(:,:,31))
% mycolormap(wavelen2rgb(wavelength(31)))
% axis off;
% figure();
% imagesc(vadmmtv(:,:,31))
% mycolormap(wavelen2rgb(wavelength(31)))
% axis off;
% figure();
% imagesc(vdesci(:,:,31))
% mycolormap(wavelen2rgb(wavelength(31)))
% axis off;