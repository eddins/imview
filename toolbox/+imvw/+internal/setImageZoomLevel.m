%setImageZoomLevel Set image zoom level
%
%   setImageZoomLevel(level) sets the zoom level of the image in the
%   current axes in the current figure. Most commonly, the zoom level is
%   set as a scalar, specified as a percentage, that applies in both the
%   horizontal and vertical directions. A zoom level of 100 means the image
%   pixel is the same size as a screen pixel. The level can also be a
%   two-element vector, [level_x level_y], that specifies the zoom level
%   independently for the horizontal and vertical directions.
%
%   Alternatively, level can be the string "fit". In this case, the axes
%   limits (XLim and YLim properties) are set to show the entire image.
%
%   setImageZoomLevel(level,im) sets the zoom level of the specified
%   graphics image object.
%
%   SIDE EFFECTS
%
%   The function setImageZoomLevel works by setting the axes XLim and
%   YLim properties, which has the side effect of setting the axes XLimMode
%   and YLimMode properties to "manual". 
%
%   Unless the zoom level is "fit", setImageZoomLevel sets the axes
%   DataAspectRatio to be consistent with the specified zoom level, and
%   this has the side effect of setting the DataAspectRatioMode to
%   "manual". 
%
%   See also getImageZoomLevel, zoomImage

function setImageZoomLevel(new_level,im)
    arguments
        new_level {mustBePlausibleZoomLevel}
        im    (1,1) matlab.graphics.primitive.Image
    end

    if isnumeric(new_level)
        new_level = checkNumericLevel(new_level);
    else
        new_level = checkTextLevel(new_level);
    end

    ax = ancestor(im,"axes");

    isfit = isa(new_level,"imvw.internal.ZoomLevelOptions") && ...
        (new_level == "fit");

    if isfit
        fitImage(ax,im);
        return
    end

    % The order of the operations below has been chosen to allow a
    % zoomed-in image to fill the entire plot box. To allow that to happen,
    % instead of constraining the image display to continue to fit within
    % the current tight position, we first set the data aspect ratio to
    % auto. Next, we compute the axes XLim and YLim properties to achieve
    % the specified zoom level while maintaining the current center
    % location. Finally, we set the data aspect ratio to be consistent
    % with the zoom level.
    
    ax.DataAspectRatioMode = "auto";

    current_level = imvw.internal.getImageZoomLevel(im);
    s = current_level ./ new_level;
    c = imvw.internal.getAxesCenterXY(ax);

    ax.XLim = s(1) * (ax.XLim - c(1)) + c(1);
    ax.YLim = s(2) * (ax.YLim - c(2)) + c(2);

    updateDataAspectRatio(new_level,im,ax);
end

function updateDataAspectRatio(new_level,im,ax)
    % Set the data aspect ratio to be consistent with the specified zoom
    % level.

    zx = new_level(1);
    zy = new_level(2);
    physical_aspect_ratio = zy / zx;

    im_extent_xy = imvw.internal.imageUnclippedExtentXY(im);
    pixel_width_x = im_extent_xy(1) / size(im.CData,2);
    pixel_width_y = im_extent_xy(2) / size(im.CData,1);
    data_units_ratio = pixel_width_y / pixel_width_x;

    data_aspect_xy_ratio = physical_aspect_ratio / data_units_ratio;

    dar = ax.DataAspectRatio;
    new_dar = dar;
    new_dar(1) = new_dar(2) * data_aspect_xy_ratio;
    ax.DataAspectRatio = new_dar;

    if ~isequal(dar,new_dar)
        drawnow
    end
end

function out = checkNumericLevel(in)
    arguments
        in (1,2) double {mustBeReal, mustBeFinite}
    end

    out = in;
end

function out = checkTextLevel(in)
    arguments
        in (1,1) imvw.internal.ZoomLevelOptions
    end
    out = in;
end

function mustBePlausibleZoomLevel(level)
    good_type = isnumeric(level) || isstring(level) || ischar(level);
    if ~good_type
        error("imzm:InvalidLevelType",...
            "Zoom level must be a number, a vector of two numbers, " + ...
            "or the string ""fit"".")
    end
end

function fitImage(ax,im)
    M = size(im.CData,1);
    N = size(im.CData,2);
    pixel_width = extent(N,im.XData);
    pixel_height = extent(M,im.YData);

    ax.XLim = [im.XData(1) - (pixel_width/2), im.XData(end) + (pixel_width/2)];
    ax.YLim = [im.YData(1) - (pixel_height/2), im.YData(end) + (pixel_height/2)];
end

function ext = extent(N,data)
    if (N == 1)
        ext = 1;
    else
        ext = (data(end) - data(1)) / (N - 1);
    end
end

% Copyright (c) 2024-2025 Steven L. Eddins