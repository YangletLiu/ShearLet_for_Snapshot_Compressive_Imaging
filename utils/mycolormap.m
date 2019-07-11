function cmap = mycolormap(rgb,intensity)
    % Assign the specific rgb colormap for figures
    % rgb: An 1x3 array
    % intensity: The intensity of the figures (63 by default)
    if nargin<2
        intensity = 63;
    end
    if(max(rgb)>1)
        rgb = rgb/255;
    end
    cmap = 0:1/intensity:1; % generate map according to the intensity
    cmap = repmat(cmap',1,3); 
    cmap = bsxfun(@times, cmap, rgb); 
    colormap(cmap)
end

%% example
% I = imread('lena.jpg');
% imagesc(I);
% mycolormap([0,1,1]);