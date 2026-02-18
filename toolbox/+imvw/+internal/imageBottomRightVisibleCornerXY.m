function [x, y] = imageBottomRightVisibleCornerXY(im, ax)
    arguments
        im
        ax = ancestor(im, "axes")
    end

    % Place the zoom-level display at the bottom right of the image.
    [pixel_extent_x, pixel_extent_y] = imvw.internal.pixelExtentDataSpace(im);
    xdata = im.XData;
    xlim = ax.XLim;
    if ax.XDir == "normal"
        x = min(xdata(2) + (pixel_extent_x / 2), xlim(2));
    else
        x = max(xdata(1) - (pixel_extent_x / 2), xlim(1));
    end

    ydata = im.YData;
    ylim = ax.YLim;
    if ax.YDir == "reverse"
        y = min(ydata(2) + (pixel_extent_y / 2), ylim(2));
    else
        y = max(ydata(1) - (pixel_extent_y / 2), ylim(1));
    end
end
