function [x_extent, y_extent] = pixelExtentDataSpace(im)
    x_extent = dataSpaceExtent(im.XData, size(im.CData, 2));
    y_extent = dataSpaceExtent(im.YData, size(im.CData, 1));
end

function extent = dataSpaceExtent(data, P)
    if (P == 1)
        extent = 1;
    else
        extent = (data(end) - data(1)) / (P - 1);
    end
end

% Copyright 2025-2026 Steven L. Eddins