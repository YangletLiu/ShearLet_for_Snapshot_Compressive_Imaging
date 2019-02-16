clear
clc
method_name = 'GAP-TV';
method_name = 'ours';
load(method_name+"_fan4.mat")
h = figure;
colormap('gray')
for i = 1:14
    imagesc(x_ista(:,:,i));
    set(gca,'xtick',[],'ytick',[]);
    print(h,'-deps','-r600',['real_results\fan14g\',method_name,sprintf('%02d',i)])
    pause(0.2);
end