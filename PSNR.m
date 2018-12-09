function psnr = PSNR(orig,rec)
    psnr = 20 * log10(255/sqrt(MSE(orig,rec)));
end