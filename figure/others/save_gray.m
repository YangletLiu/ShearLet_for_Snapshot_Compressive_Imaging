clear
clc
method_name = 'GAP-TV';
method_name = 'ours';
load(method_name+"_fan6.mat")
h = figure;
colormap('gray')
for i = 1:14
    imagesc(x_ista(:,:,15-i)/255);
    set(gca,'xtick',[],'ytick',[]);
    print(h,'-deps','-r600',['real_results\fan14g\',method_name,sprintf('%02d',15-i)])
    pause(0.2);
end