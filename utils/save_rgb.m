method_name = 'GAP-TV';
method_name = 'ours';

load(method_name+"_triball.mat")
h = figure;
for i = 1:22
    imagesc(X_recon_col(:,:,:,i));
    set(gca,'xtick',[],'ytick',[]);
    print(h,'-depsc','-r600',['real_results\triball\',method_name,sprintf('%02d',i)])
    pause(0.2);
end