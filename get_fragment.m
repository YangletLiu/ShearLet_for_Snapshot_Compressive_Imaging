function fragment = get_fragment(orig,mask,opt)
    if nargin<3
        opt = [];
    end
    % init
    iframe   = 1; % start frame number
    nframe = 1; % wanted frame number
    maskdirection = 'plain';
    % check options
    if isfield(opt,'iframe'); iframe = opt.iframe; end
    if isfield(opt,'nframe'); nframe = opt.nframe; end
    if isfield(opt,'maskdirection'); maskdirection = opt.maskdirection; end
    nmask = size(mask,3);
    for kf = 1:nframe
        switch lower(maskdirection)
            case 'plain'
                fragment = orig(:,:,(kf-1)*nmask+(1:nmask));
            case 'updown'
                if mod(kf+iframe-1,2) == 0 % even frame (falling of triangular wave)
                    fragment = orig(:,:,(kf-1)*nmask+(1:nmask));
                else % odd frame (rising of triangular wave)
                    fragment = orig(:,:,(kf-1)*nmask+(nmask:-1:1));
                end
            case 'downup'
                if mod(kf+iframe-1,2) == 1 % odd frame (rising of triangular wave)
                    fragment = orig(:,:,(kf-1)*nmask+(1:nmask));
                else % even frame (falling of triangular wave)
                    fragment = orig(:,:,(kf-1)*nmask+(nmask:-1:1));
                end
            otherwise
                error('Unsupported mask direction %s!',lower(maskdirection));
        end
    end
end