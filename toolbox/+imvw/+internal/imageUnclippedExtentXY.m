%imageUnclippedExtentXY Image unclipped extent in data space (x-y) units
%
%   extent = imageUnclippedExtentXY(im) returns the extent of the graphics
%   image object in data space (x-y coordinates). The output is a
%   two-element vector containing the width (extent in x) and height
%   (extent in y).
%
%   The extent includes the full size of the pixels as square regions. For
%   example, if an image has 10 columns, the horizontal extent (x
%   direction) is 10.5 - 0.5 = 10, not 10 - 1 = 9.
%
%   This is an internal function that is not intended as a public
%   interface.

function extent = imageUnclippedExtentXY(im)
    arguments
        im (1,1) matlab.graphics.primitive.Image
    end

    % The function extent1D is a local function that handles the degenerate
    % MATLAB graphics case when the image CData has only one row or one
    % column.
    pixel_width = extent1D(im.XData,size(im.CData,2));
    pixel_height = extent1D(im.YData,size(im.CData,1));

    x1 = im.XData(1) - (pixel_width / 2);
    x2 = im.XData(end) + (pixel_width / 2);

    y1 = im.YData(1) - (pixel_height / 2);
    y2 = im.YData(end) + (pixel_height / 2);

    extent = [(x2 - x1) (y2 - y1)];
end

function e = extent1D(data,num_pixels)
    if (num_pixels <= 1)
        % If a MATLAB graphics Image object has one column (or one row),
        % then its x-axis (or y-axis) extent cannot be determined
        % unambiguously from the XData (or YData). It is arbitrarily
        % assumed to be 1.
        e = 1;
    else
        e = (data(2) - data(1)) / (num_pixels - 1);
    end
end

% Copyright (c) 2024-2025 Steven L. Eddins