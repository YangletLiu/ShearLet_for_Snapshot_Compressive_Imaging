figure(1)
title('orig')
for i=1:8
    colormap('gray')
    subplot(2,4,i)
    imagesc(x(:,:,i));  
    set(gca,'xtick',[],'ytick',[]); 
end

figure(2)
title('random projection')
for i=1:8
    colormap('gray')
    subplot(2,4,i)
    imagesc(x_rp(:,:,i));  
    set(gca,'xtick',[],'ytick',[]); 
end