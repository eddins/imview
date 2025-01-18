%IMVIEW Display image.
%   IMVIEW(A) displays the input image, A, in the current axes. A can be a
%   matrix or array representing a binary, grayscale, or RGB image.
%
%   A binary image is represented as a logical matrix. A grayscale image is
%   represented as a numeric matrix. An RGB image is represented as an
%   MxNx3 array with type double, single, uint8, or uint16.
%
%   IMVIEW(A,map) displays the input image, A, and the specified colormap,
%   map, as an indexed image.
%
%   IMVIEW(filename) displays the image contained in the specified
%   file, for image file types supported by IMREAD.
%
%   IMVIEW(URL) displays the image contained in the file downloaded from
%   the specified URL, for image file types supported by IMREAD.
%
%   IMVIEW(___,Name=Value) uses name-value arguments to control aspects of
%   the image display.
%
%   IM = IMVIEW(___) returns the matlab.graphics.primitive.Image object.
%
%   NAME-VALUE ARGUMENTS
%
%   Specify optional pairs of arguments as Name1=Value1,...,NameN=ValueN,
%   where Name is the argument name and Value is the corresponding value.
%   Name-value arguments must appear after other arguments.
%
%   GrayLimits - Gray limits used for displaying the image
%       Default: "typerange"
%
%       Specified as a two-element vector of the form [LOW HIGH]. The
%       function displays the value LOW (and any value less than LOW) as
%       black, and it displays the value HIGH (and any value greater than
%       HIGH) as white. Values between LOW and HIGH are displayed as
%       intermediate shades of gray.
%
%       Alternatively, GrayLimits can be specified as "datarange", which
%       automatically sets LOW and HIGH to be the minimum and maximum
%       values of A, respectively. Or, GrayLimits can be specified as
%       "typerange", which sets LOW and HIGH based on the data type of A.
%       If A's type is double or single, then the limits are set to [0 1].
%       If A is an integer type, then LOW and HIGH are set to the minimum
%       and maximum representable values of that type.
%
%       The GrayLimits values are ignored if A is an RGB image (an MxNx3
%       array).
%
%   Parent - Parent axes of image object
%       Default: the axes used by the graphics system by default for the 
%       next plot, as returned by newplot
%
%       Parent axes of image object, specified as an Axes object or a
%       UIAxes object. 
%
%   XData - Placement along the x-axis
%       Two-element vector setting the XData property of the created image
%       object. See the documentation for image properties.
%
%       Default: [1 size(A,2)]
%
%   YData - Placement along the y-axis
%       Two-element vector setting the YData property of the created image
%       object. See the documentation for image properties.
%
%       Default: [1 size(A,1)]
%
%   COMPARISON WITH IMSHOW
%
%   The function IMVIEW is intended to be used instead of imshow for many
%   purposes, and it has several important differences in behavior:
%
%   - IMVIEW does not resize the figure containing the image display.
%   Instead, the image is displayed in the current axes in the current
%   figure (as returned by the function NEWPLOT). A figure and axes will be
%   created if they do not exist.
%
%   - IMVIEW displays the image using bilinear interpolation and
%   antialiasing, unless individual pixels are larger than about 0.2
%   inches. In that case, the interpolation switches automatically to
%   nearest neighbor, and a pixel grid is shown. The function imshow uses
%   nearest neighbor interpolation by default.
%
%   - Unlike imshow, IMVIEW does not explicitly set the axes XLim and YLim
%   properties. Instead, it sets the XLimitMethod and YLimitMethod
%   properties to "tight". With this choice, the axes limits will tightly
%   enclose the data contained by the axes, including the image and
%   anything else that might also be plotted in the same axes. Also unlike
%   imshow, the axes limits will continue to automatically adjust to
%   additional data being plotted there.
%
%   - IMVIEW does not observe the MATLAB Image Display Preferences.
%
%   LIMITATIONS
%
%   The function IMVIEW is under development. This version does not yet
%   have some of the options supported by imshow, including:
%
%   - Overriding the default interpolation behavior
%   - Overriding the default XData and YData
%   - Setting the initial magnification level (although you can use
%     setImageZoomLevel or zoomImage after calling imview)
%   - Using an image filename or URL
%
%   REQUIRED ADD-ONS
%
%   The function IMVIEW requires the following add-ons that are available
%   from the MATLAB File Exchange:
%
%   - Pixel Grid 
%     https://www.mathworks.com/matlabcentral/fileexchange/71622-pixel-grid
%
%   - Image Zoom Level and Pan Utilities
%     https://www.mathworks.com/matlabcentral/fileexchange/167316-image-zoom-level-and-pan-utilities
%
%   See also imshow, image, pixelgrid, setImageZoomLevel, zoomImage

function out = imview(A,map,options)
    arguments
        A
        map (:,3) double {mustBeReal, mustBeInRange(map,0,1)} = []
        options.XData {mustBeValidXYData}
        options.YData {mustBeValidXYData}
        options.GrayLimits {mustBeValidGrayLimits}
        options.Interpolation (1,1) imvw.internal.ImviewInterpolationChoice = "adaptive"
        options.AlphaData {mustBeNumericOrLogical, mustBeMatrix, ...
            mustBeInRange(options.AlphaData,0,1)} = 1
        options.Parent (1,1) {mustBeValidParentAxes}
    end

    verifyDependencies();
    [A,map] = processImageData(A,map);
    type = imageType(A,map);
    options_p = processOptions(options,A,type);

    ax = options_p.Parent;
    im = image(CData = A, Parent = ax, Interpolation = "bilinear", ...
        AlphaData = options.AlphaData);

    im.XData = options_p.XData;
    im.YData = options_p.YData;

    switch type
        case "grayscale"
            im.CDataMapping = "scaled";
            ax.CLim = options_p.GrayLimits;
            ax.Colormap = gray(256);
        case "indexed"
            im.CDataMapping = "direct";
            ax.Colormap = map;
        case "binary"
            im.CDataMapping = "scaled";
            ax.Colormap = [0 0 0; 1 1 1];
    end

    ax.DataAspectRatio = [1 1 1];
    ax.YDir = "reverse";
    ax.XLimMode = "auto";
    ax.YLimMode = "auto";
    ax.XLimitMethod = "tight";
    ax.YLimitMethod = "tight";
    ax.Visible = "off";

    pixelgrid(im)

    switch options_p.Interpolation
        case "nearest"
            im.Interpolation = "nearest";
        case "bilinear"
            im.Interpolation = "bilinear";
        case "adaptive"
            % See the article "Undocumented HG2 graphics events" for an explanation
            % of the following code.
            %
            % https://undocumentedmatlab.com/articles/undocumented-hg2-graphics-events
            addlistener(im,"MarkedClean",@(~,~) updateImageDisplayMethod(im));
            addlistener(ax,"MarkedClean",@(~,~) updateImageDisplayMethod(im));
    end

    if nargout > 0
        out = im;
    end
end

function updateImageDisplayMethod(im)
    if ~ishandle(im)
        return
    end
    
    if ismatrix(im.CData) && strcmp(im.CDataMapping,'direct')
        if ~strcmp(im.Interpolation,'nearest')
            im.Interpolation = 'nearest';
        end
    else
        if any(getImagePixelExtentInches(im) >= 0.2)
            if ~strcmp(im.Interpolation,'nearest')
                im.Interpolation = 'nearest';
            end
        else
            if ~strcmp(im.Interpolation,'bilinear')
                im.Interpolation = 'bilinear';
            end
        end
    end
end

function type = imageType(A,map)
    if ((ndims(A) == 3) && (size(A,3) == 3))
        type = "truecolor";
        if ~isempty(map)
            id = "imview:MapIgnoredForTruecolorImage";
            message = ...
                "Input colormap ignored for a truecolor image.";
            warning(id,message)
        end
    elseif ~isempty(map)
        type = "indexed";
    elseif islogical(A)
        type = "binary";
    else
        type = "grayscale";
    end
end

function [A,map] = processImageData(A,map)
    if ischar(A) || isstring(A)
        A = string(A);
        if ~exist(A,"file")
            id = "imview:NoSuchFile";
            message = "Cannot find the specified file: ""%s"".";
            error(id, message, A)
        end
        try
            [A,map] = imread(A);
        catch
            id = "imview:FileReadFailed";
            message = "Could not read image from the specified file: ""%s"".";
            error(id, message, A)
        end
    end
end

function verifyDependencies
    if ~mFunctionExists("pixelgrid")
        error("imview:NeedPixelGrid", ...
            "Pixel Grid add-on package is not installed. " + ...
            "Download it from: https://www.mathworks.com/matlabcentral/fileexchange/71622-pixel-grid")
    end

    if ~mFunctionExists("getImagePixelExtentInches")
        error("imview:NeedIMZM", ...
            "Image Zoom Level and Pan Utilities add-on package is not installed. " + ...
            "Download it from: https://www.mathworks.com/matlabcentral/fileexchange/167316-image-zoom-level-and-pan-utilities")
    end
end

function tf = mFunctionExists(function_name)
    w = which(function_name);
    [~,name,ext] = fileparts(w);
    tf = (string(name) == function_name) && (ext == ".m");
end

function mustBeValidXYData(data)
    arguments
        data (1,2) double {mustBeReal mustBeFinite} %#ok<INUSA>
    end
end

function mustBeValidGrayLimits(gray_limits)
    if isnumeric(gray_limits)
        valid = (numel(gray_limits) == 2) && ...
            allfinite(gray_limits)        && ...
            isreal(gray_limits)           && ...
            gray_limits(2) > gray_limits(1);

    elseif (isstring(gray_limits) || ischar(gray_limits))
        gray_limits = lower(string(gray_limits));
        valid = ismember(gray_limits,["datarange" "typerange"]);

    else
        valid = false;
    end

    if ~valid
        message = ...
            "Specify either: a 2-element, real, " + ...
            "finite vector, with the second element greater than " + ...
            "the first; or one of the strings " + ...
            """datarange"" or ""typerange"".";
        id = "imview:InvalidGrayLimits";
        error(id,message)
    end
end

function mustBeValidParentAxes(ax)
    if ~(isa(ax, "matlab.graphics.axis.Axes") || ...
            isa(ax, "matlab.ui.control.UIAxes"))
        id = "imview:InvalidParent";
        message = "Parent must be an Axes or UIAxes object.";
        error(id,message)
    end
end

function options_p = processOptions(options,A,type)
    options_p = options;
    options_p.GrayLimits = processGrayLimits(options,A);
    options_p.XData = processXData(options,A);
    options_p.YData = processYData(options,A);
    options_p.Interpolation = processInterpolation(options,type);
    options_p.Parent = processParent(options);
    options_p.AlphaData = options.AlphaData;
end

function parent = processParent(options)
    if isfield(options, "Parent")
        parent = options.Parent;
    else
        parent = newplot;
    end
end

function interp = processInterpolation(options,type)
    if isfield(options,"Interpolation")
        interp = options.Interpolation;
    elseif type == "indexed"
        interp = "nearest";
    else
        interp = "adaptive";
    end
end

function xdata = processXData(options,A)
    if isfield(options,"XData")
        xdata = options.XData;
    else
        xdata = [1 size(A,2)];
    end
end

function ydata = processYData(options,A)
    if isfield(options,"YData")
        ydata = options.YData;
    else
        ydata = [1 size(A,1)];
    end
end

function gray_limits_p = processGrayLimits(options,A)
    if isfield(options,"GrayLimits")
        if isnumeric(options.GrayLimits)
            gray_limits_p = double(reshape(options.GrayLimits,1,2));
        else
            switch options.GrayLimits
                case "datarange"
                    [gray_limits_p(1), gray_limits_p(2)] = bounds(A,"all");
                    if (gray_limits_p(2) == gray_limits_p(1))
                        % Degenerate case of constant-valued image. The
                        % axes object will throw an error if you try to set
                        % CLim with two values that are the same. Make an
                        % arbitrary choice here that causes image to be
                        % displayed as an intermediate shade of gray.
                        delta = max(0.5,2*eps(gray_limits_p(1)));
                        gray_limits_p = gray_limits_p + [-delta delta];
                    end
                case "typerange"
                    gray_limits_p = getrangefromclass(A);
                otherwise
            end
        end
    else
        % Default to "typerange"
        gray_limits_p = getrangefromclass(A);
    end
end

% Copyright 2024-2025 Steven L. Eddins
