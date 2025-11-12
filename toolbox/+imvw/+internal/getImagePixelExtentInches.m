%getImagePixelExtentInches Get approximate image pixel extent in inches
%
%   extent = getImagePixelExtentInches returns the approximate extent of
%   pixels in the current image of the current axes of the current figure.
%   The extent is returned as a two-element vector containing the
%   horizontal and vertical extent.
%
%   extent = getImagePixelExtentInches(im) returns the approximate extent
%   of the specified graphics image object.
%
%   LIMITATION: The output is only a rough approximation of the actual size
%   of the image pixels on the display device.

function out = getImagePixelExtentInches(im)
    arguments
        im (1,1) matlab.graphics.primitive.Image
    end

    root = groot;
    out = (imvw.internal.getImageZoomLevel(im)/100) ./ ...
        root.ScreenPixelsPerInch;
end

% Copyright (c) 2024-2025 Steven L. Eddins