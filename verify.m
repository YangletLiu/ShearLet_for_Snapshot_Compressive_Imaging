% this is to verify that we can seperate the frame we wanted
addpath('dataset');
load("kobe32_cacti.mat")

[width, height, frames] = size(orig);
maskFrames = size(mask,3);
sampled = zeros(width*height,frames/maskFrames);
unavailableSampled = zeros(width*height,frames);

for i=1:frames
    pos = mod(i,maskFrames);
    if pos == 0
        mask_i = mask(:,:,maskFrames);
    else
        mask_i = mask(:,:,pos);
    end
    mask_i = diag(sparse(mask_i(:)));
    orig_i = orig(:,:,i);
    unavailableSampled(:,i) = mask_i * orig_i(:);
    sampled(:,ceil(i/maskFrames)) = sampled(:,ceil(i/maskFrames)) + mask_i * orig_i(:);
end

% 有点问题
masked1 = mask(:,:,1).*orig(:,:,1);
masked2 = col2square(unavailableSampled(:,1));
display(sum(sum(masked1 - masked2)));
figure(1);
colormap(gray);
subplot(121);
imagesc(masked1);
subplot(122)
imagesc(masked2);

unavailableSampled = unavailableSampled(:); % 不能获取到的，单张图的sample
% sampled也即是meas(:)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maskSum = 0;
for i=1:maskFrames
    maskSum = maskSum + mask(:,:,i);
end

maskRadio = zeros(size(mask));                                % 占比
for i=1:maskFrames
    maskRadio(:,:,i) = mask(:,:,i)./maskSum(:,:);
end
maskRadio(isnan(maskRadio)) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sampledUnfold = zeros(size(sampled,1),frames);
for i=1:frames
    temp = maskRadio(:,:,mod(i,maskFrames)+1);
    sampledUnfold(:,i) = diag(sparse(temp(:)))*sampled(:,ceil(i/maskFrames));
end
sampledUnfold = sampledUnfold(:);
% 这个对采样的预处理很合理，非常接近真实的采样值，也就是说可以简单地从复合的采样中恢复出对每一帧的采样
sum(sampledUnfold-unavailableSampled)/sum(unavailableSampled) % =-7.7364e-17的相对误差