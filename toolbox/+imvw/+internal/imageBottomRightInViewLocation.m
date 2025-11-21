function [right, bottom] = imageBottomRightInViewLocation(im)
    ax = imageAxes(im);
    ax_position = imvw.internal.getObjectPixelPosition(ax);
    [M,N] = size(im.CData,[1 2]);
    xdata = im.XData;
    if N == 1
        pixel_width = 1;
    else
        pixel_width = (xdata(end) - xdata(1)) / (N - 1);
    end
    image_x_bounds = [1 N] + [-pixel_width pixel_width]/2;
    xlim = ax.XLim;
    left = xlim(1);
    right = xlim(2);
    p = polyfit([left right], [ax_position(1) ax_position(1)+ax_position(3)], 1);
    right = polyval(p, image_x_bounds(2));
    right = min(right, ax_position(1) + ax_position(3));

    ydata = im.YData;
    if M == 1
        pixel_height = 1;
    else
        pixel_height = (ydata(end) - ydata(1)) / (M - 1);
    end
    image_y_bounds = [1 M] + [-pixel_height pixel_height]/2;
    ylim = ax.YLim;
    bottom = ylim(1);
    top = ylim(2);
    p = polyfit([bottom top], [ax_position(2)+ax_position(4), ax_position(2)], 1);
    bottom = polyval(p, image_y_bounds(2));  
    bottom = max(bottom, ax_position(2));
end

function ax = imageAxes(im)
    ax = ancestor(im, "axes");
    if isempty(ax)
        ax = ancestor(im, "uiaxes");
    end    
end