% load("GAP-TV_fruits.mat")
load("ours_triBall.mat")
figure(1);
 for k=1:codedNum
%      subplot(121)
%      imagesc(X_recon_gap(:,:,:,k)); title({"GAP-TV",num2str(k)}); pause(0.5);
%      subplot(122)
     imagesc(X_recon_col(:,:,:,k)); title({"SeSCI",num2str(k)}); pause(0.5);
 end
 