%getImageZoomLevel Get image zoom level
%
%   level = getImageZoomLevel returns the zoom level of the image in the
%   current axes in the current figure. The zoom level is returned as a
%   two-element vector containing the horizontal and vertical zoom level. A
%   zoom level of 100 means the image pixel is the same size as a screen
%   pixel.
%
%   level = getImageZoomLevel(im) returns the zoom level of the specified
%   graphics image object.
%
%   See also setImageZoomLevel, zoomImage

function out = getImageZoomLevel(im)
    arguments
        im (1,1) matlab.graphics.primitive.Image
    end

    out = imvw.internal.imageUnclippedExtentPixels(im) ./ ...
        size(im.CData,[2 1]);

    out = out * 100;
end

% Copyright (c) 2024-2025 Steven L. Eddins