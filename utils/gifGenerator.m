h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
category = 'kobe';
filesimu = [category,'_sesci.gif'];

for k = 1:size(vdesci,3)
    image = uint8(vdesci(:,:,k)*255);
    if k==1
        imwrite(image,filesimu,'gif','LoopCount',Inf,'DelayTime',1);
    else
        imwrite(image,filesimu,'gif','WriteMode','append','DelayTime',1);
    end
end