clc
clear
close all

videoObj = VideoReader('central_park.mp4');
nFrames = videoObj.NumberOfFrames;
vHeight = videoObj.Height;
vWidth = videoObj.Width;

images = zeros(vHeight,vWidth,8);
j =0;
for k = 300 : 8 : 364
    j= j+1;
    images(:,:,j) = rgb2gray(read(videoObj, k));%读取第k帧，存入im中
end

orig = images(1:2:end,1:2:end,:);
orig = orig(1:256,1:256,:);

figure(1)
for i=1:8
    colormap('gray');
    imagesc(images(:,:,i));	
    axis image off;     
    title('downsample');
    pause(0.5)
end