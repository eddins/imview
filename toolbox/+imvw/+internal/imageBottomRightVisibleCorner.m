function [x_out, y_out] = imageBottomRightVisibleCorner(im, ax)
    arguments
        im
        ax = ancestor(im, "axes");
    end

    ax_pos = imvw.internal.getObjectPixelPosition(ax);
    bottom_right_xy = imvw.internal.imageBottomRightVisibleCorner(im, ax);
    x_limits = ax.XLim;
    u1 = x_limits(1);
    u2 = x_limits(end);
    v1 = ax_pos(1);
    v2 = v1 + ax_pos(3);
    p = polyfit([u1 u2], [v1 v2], 1);
    x_out = polyval(p, bottom_right_xy(1));

    y_limits = ax.YLim;
    u1 = y_limits(1);
    u2 = y_limits(end);
    v1 = ax_pos(2);
    v2 = v1 + ax_pos(4);
    p = polyfit([u1 u2], [v1 v2], 1);
    y_out = polyval(p, bottom_right_xy(2)); 
end