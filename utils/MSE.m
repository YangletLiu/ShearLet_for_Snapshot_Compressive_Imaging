function mse = MSE(orig,rec)
    mse = sum(sum(sum((orig-rec).^2)))/numel(orig);
end