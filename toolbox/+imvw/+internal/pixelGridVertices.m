function [xv,yv] = pixelGridVertices(sz,xdata,ydata)
    M = sz(1);
    N = sz(2);
    if M > 1
        pixel_height = diff(ydata) / (M-1);
    else
        % Special case. Assume unit height.
        pixel_height = 1;
    end

    if N > 1
        pixel_width = diff(xdata) / (N-1);
    else
        % Special case. Assume unit width.
        pixel_width = 1;
    end

    y_top = ydata(1) - (pixel_height/2);
    y_bottom = ydata(2) + (pixel_height/2);
    y = linspace(y_top, y_bottom, M+1);

    x_left = xdata(1) - (pixel_width/2);
    x_right = xdata(2) + (pixel_width/2);
    x = linspace(x_left, x_right, N+1);

    % Construct xv1 and yv1 to draw all the vertical line segments. Separate
    % the line segments by NaN to avoid drawing diagonal line segments from the
    % bottom of one line to the top of the next line over.
    xv1 = NaN(1,3*numel(x));
    xv1(1:3:end) = x;
    xv1(2:3:end) = x;
    yv1 = repmat([y(1) y(end) NaN], 1, numel(x));

    % Construct xv2 and yv2 to draw all the horizontal line segments.
    yv2 = NaN(1,3*numel(y));
    yv2(1:3:end) = y;
    yv2(2:3:end) = y;
    xv2 = repmat([x(1) x(end) NaN], 1, numel(y));

    % Put all the vertices together so that they can be drawn with a single
    % call to line().
    xv = [xv1(:) ; xv2(:)];
    yv = [yv1(:) ; yv2(:)];

end