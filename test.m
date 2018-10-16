clear;
clc;

addpath(genpath(pwd));
datasetdir = 'dataset'; % dataset

% [1] load dataset
para.type   = 'cacti'; % type of dataset, cassi or cacti
para.name   = 'kobe'; % name of dataset
para.number = 32; % number of frames in the dataset

datapath = sprintf('%s/%s%d_%s.mat',datasetdir,para.name,...
    para.number,para.type);

load(datapath); % mask, meas, orig (and para)

for i = 1:size(meas,3)
    imagesc(meas(:,:,i))
    colormap(gray)
    pause(0.5)
end
