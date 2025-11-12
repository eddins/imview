%axesPlotAreaExtentXY Axes plot area extent in data space (x-y) units
%   extent = axesPlotAreaExtentXY returns the extent of the axes plotting
%   area in data space (x-y) units. extent is a two-element vector
%   containing the box width and height.
%
%   This is an internal function that is not intended as a public
%   interface.

function extent = axesPlotAreaExtentXY(ax)
    arguments
        ax (1,1) matlab.graphics.axis.Axes = gca
    end

    xlim = ax.XLim;
    ylim = ax.YLim;

    extent = [(xlim(2) - xlim(1)) (ylim(2) - ylim(1))];
end

% Copyright (c) 2024-2025 Steven L. Eddins
