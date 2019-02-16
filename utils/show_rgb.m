load("GAP-TV_triball.mat")
% load("ours_triball.mat")%0.5
% load("ours_triball2.mat")%0.1
% load("ours_triball3.mat")%1
% load("ours_triball4.mat")%0.01
load("ours_triball5.mat")%0.3

load("GAP-TV_fruits.mat")
load("ours_fruits1.mat")%0.3
load("ours_fruits1.mat")%0.05
figure(1);
 for k=1:codedNum
     subplot(121)
     imagesc(X_recon_gap(:,:,:,k)); title({"GAP-TV",num2str(k)}); pause(0.5);
     subplot(122)
     imagesc(X_recon_col(:,:,:,k)); title({"SeSCI",num2str(k)}); pause(0.5);
 end
 