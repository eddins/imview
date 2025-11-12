%getAxesCenterXY Axes center in data space (x-y) coordinates
%
%   center = getAxesCenterXY returns the center of the plotting area, in
%   data space (x-y) coordinates, of the current axes. The center is
%   returned as a two-element vector, [center_x center_y].
%
%   center = getAxesCenterXY(ax) returns the center of the specified axes.
%
%   See also setAxesCenterXY

function center = getAxesCenterXY(ax)
    arguments
        ax (1,1) matlab.graphics.axis.Axes = gca
    end

    xlim = ax.XLim([1 end]);
    ylim = ax.YLim([1 end]);
    center = [mean(xlim) mean(ylim)];
end

% Copyright (c) 2024-2025 Steven L. Eddins
