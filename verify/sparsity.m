function [xRec1,xRec2] = sparsity(x,epsilon,bFig)
    if nargin<3
        bFig = false;
    end
    %% shearlet
    shearletSystem = SLgetShearletSystem2D(0,512,512,4);
    coeffs1 = SLsheardec2D(x,shearletSystem);

    coeffsVec1 = abs(coeffs1(:));
    sortedCoeffs1 = sort(coeffsVec1,'descend');
    idx1 = floor(epsilon*size(sortedCoeffs1,1));
    delta1 = sortedCoeffs1(idx1);

    coeffs1 = coeffs1.*(abs(coeffs1)>delta1);
    xRec1 = SLshearrec2D(coeffs1,shearletSystem);
    if bFig
        figure(1)
        colormap('gray')
        imagesc(xRec1)
        set(gca,'xtick',[],'ytick',[]); 
    end

    %% frequency
    coeffs2 = fft2(x);

    coeffsVec2 = abs(coeffs2(:));
    sortedCoeffs2 = sort(coeffsVec2,'descend');
    idx2 = floor(epsilon*size(sortedCoeffs2,1));
    delta2 = sortedCoeffs2(idx2);

    coeffs2 = coeffs2.*(abs(coeffs2)>delta2);
    xRec2 = ifft2(coeffs2);
    if bFig
        figure(2)
        colormap('gray')
        imagesc(xRec2)
        set(gca,'xtick',[],'ytick',[]); 
    end
end
