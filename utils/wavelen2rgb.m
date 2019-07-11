function rgb = wavelen2rgb(nm,nor)
    % Converts a wavelength between 380 and 780 nm to an RGB color tuple.
    % nm: Wavelength in nanometers.
    % nor: normalized (default) or not
    % return a 1x3 array (red, green, blue) of integers.
    if nargin<2
        nor = true;
    end
    if nm < 380 || nm > 780
        error("wavelength should between 380 and 780")
    end
    red = 0.0;
    green = 0.0;
    blue = 0.0;
    % Calculate intensities in the different wavelength bands.
    if nm < 440
        red = -(nm - 440.0) / (440.0 - 380.0);
        blue = 1.0;
    elseif nm < 490
        green = (nm - 440.0) / (490.0 - 440.0);
        blue = 1.0;
    elseif nm < 510
        green = 1.0;
        blue = -(nm - 510.0) / (510.0 - 490.0);
    elseif nm < 580
        red = (nm - 510.0) / (580.0 - 510.0);
        green = 1.0;
    elseif nm < 645
        red = 1.0;
        green = -(nm - 645.0) / (645.0 - 580.0);
    else
        red = 1.0;
    end
    % Let the intensity fall off near the vision limits.
    if nm < 420
        factor = 0.3 + 0.7 * (nm - 380.0) / (420.0 - 380.0);
    elseif nm < 701
        factor = 1.0;
    else
        factor = 0.3 + 0.7 * (780.0 - nm) / (780.0 - 700.0);
    end
    % The calculated values in [R,G,B].
    rgb = [adjust(red, factor), adjust(green, factor), adjust(blue, factor)];
    if nor
        rgb = rgb/255;
    end
end
    
function output = adjust(color, factor)
    if color < 0.01
        output = 0;
        return;
    end
    max_intensity = 255;
    gamma = 0.80;
    rv = round(max_intensity * (color * factor)^gamma);
    if rv < 0
        output = 0;
        return;
    end
    if rv > max_intensity
        output = max_intensity;
        return;
    end
    output = rv;
end
