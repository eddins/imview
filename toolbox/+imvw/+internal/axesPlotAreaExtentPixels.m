%axesPlotAreaExtentPixels Axes plot area extent in pixels
%   extent = axesPlotAreaExtentPixels returns the extent of the axes
%   plotting area in pixels. extent is a two-element vector containing the
%   plot area width and height.
%
%   The function tightPosition is used to determine the plot area.
%
%   This is an internal function that is not intended as a public
%   interface.

function extent = axesPlotAreaExtentPixels(ax)
    pos = imvw.internal.getObjectPixelPosition(ax);
    extent = pos(3:4);
end

% Copyright (c) 2024-2025 Steven L. Eddins
