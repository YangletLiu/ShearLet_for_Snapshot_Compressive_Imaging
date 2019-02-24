function [Img_recon_sensor,X_recon_col] = my_demosaic(Row,Col,CodeFrame,ColT,rotnum,img)
  
% Xin Yuan, Duke ECE
% xin.yuan@duke.edu
% initial date: 05/15/2013

   Img_recon_sensor = zeros(Row,Col,CodeFrame*ColT);
   
for nR = 1:(Row/2)
    for nC = 1:(Col/2)
        Img_recon_sensor((nR-1)*2+1,(nC-1)*2+1,:) = img(nR,nC,:,1);
        Img_recon_sensor((nR-1)*2+1,(nC-1)*2+2,:) = img(nR,nC,:,2);
        Img_recon_sensor((nR-1)*2+2,(nC-1)*2+1,:) = img(nR,nC,:,3);
        Img_recon_sensor((nR-1)*2+2,(nC-1)*2+2,:) = img(nR,nC,:,4);
    end
end

test = sort(Img_recon_sensor(:),'descend');
mymax = test(round(0.002*length(test)));

%hdemosaic = vision.DemosaicInterpolator;
for k=1:(CodeFrame*ColT)
    %temp = uint8(Img_recon_sensor(:,:,k)/max(max(Img_recon_sensor(:,:,k)))*255);
    temp = uint8(min(Img_recon_sensor(:,:,k)/mymax,1)*255);
    X_recon_col(:,:,:,k) = demosaic(temp,'rggb');
end


for k=1:(CodeFrame*ColT) 
    for rr=1:3 
        Temshow(:,:,rr,k) = rot90(X_recon_col(:,:,rr,k),rotnum); 
    end
end

X_recon_col = Temshow;

 figure;
 for k=1:(CodeFrame*ColT)
     imagesc(Temshow(:,:,:,k)); title(num2str(k)); pause(0.3);
 end

end