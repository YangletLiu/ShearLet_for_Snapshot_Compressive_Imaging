function snr = SNR(orig,rec)
    snr = 10 * log10(sum(sum(sum((orig).^2))) / sum(sum(sum((orig-rec).^2))));
end