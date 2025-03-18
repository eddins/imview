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
%   IM = IMVIEW(___) returns the graphics Image object.
%
%   For more information and examples, see ImviewGettingStarted.mlx.
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
%   SpatialReference - 2-D spatial reference
%       2-D spatial reference of the input image, specified as an imref2d
%       object. Note that you must have Image Processing Toolbox to use
%       this argument.
%
%   ShowZoomLevel - Show the zoom level on the image
%       True or false.
%
%       Default: imview.ShowZoomLevel setting
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
%   AXES PROPERTIES
%
%   IMVIEW sets the following properties of axes:
%
%       CLim            - Set for grayscale and binary images
%       Colormap        - Set for grayscale, indexed, and binary images
%       DataAspectRatio - Set to [1 1 1]
%       YDir            - Set to "reverse"
%       XLimMode        - Set to "auto"
%       YLimMode        - Set to "auto"
%       XLimitMethod    - Set to "tight"
%       YLimitMethod    - Set to "tight"
%       Visible         - Set to "off"
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
%   - IMVIEW can display the zoom level (as a percentage) at the lower
%   right of the image. The zoom level can be changed directly by clicking
%   on the zoom level display and editing it. The zoom level is displayed
%   by default, but you can override that using the ShowZoomLevel argument.
%   You can also override it by changing a persistent setting:
%
%       s = settings;
%       s.imview.ShowZoomLevel.PersonalValue = true;
%
%   - Unlike imshow, IMVIEW does not explicitly set the axes XLim and YLim
%   properties. Instead, it sets the XLimitMethod and YLimitMethod
%   properties to "tight". With this choice, the axes limits will tightly
%   enclose the data contained by the axes, including the image and
%   anything else that might also be plotted in the same axes. Also unlike
%   imshow, the axes limits will continue to automatically adjust to
%   additional data being plotted there.
%
%   - When displaying an indexed image, IMVIEW sets the colormap of the
%   axes instead of the figure.
%
%   - IMVIEW supports AlphaData input.
%
%   - When reading image data from a PNG file, IMVIEW will read and use
%   pixel transparency data if it is in the file.
%
%   - IMVIEW does not have an input argument for controlling the initial
%   zoom level, as InitialMagnification does for imshow. Instead, call
%   setImageZoomLevel or zoomImage after calling IMVIEW.
%
%   - IMVIEW does not observe the MATLAB Image Display Preferences.
%
%   LIMITATIONS
%
%   When running inside a live script, the pixel grid visibility and the
%   image interpolation method will not automatically adjust when zooming
%   interactively using the axes toolbar. To update the pixel grid and
%   interpolation method after zooming using the axes toolbar, press the
%   "Update Code" button and then execute the script or code section again.
%
%   When using a PNG file's pixel transparency, IMVIEW does not read or use
%   the background color contained in the file, so the appearance may be
%   different from the PNG creator's intent.
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
        options.ShowZoomLevel (1,1) logical
        options.SpatialReference (1,1) imref2d
    end

    % Make sure that the needed add-on packages are present. Throw an error
    % if they are not.
    verifyDependencies();

    % If image data, A, has been passed in as a filename or URL, then get
    % the real image data, colormap, and alpha data from the file or URL.
    [A,map,options.AlphaData] = processImageData(A,map,options.AlphaData);

    % Infer the image type based on data type of A and whether a colormap
    % was passed in.
    type = imageType(A,map);

    % Fill in the option values that were not provided, or that still need
    % to be computed, which need to be refined based on the image data and
    % type.
    options_p = processOptions(options,A,type);

    ax = options_p.Parent;
    im = image(CData = A, Parent = ax, ...
        AlphaData = options_p.AlphaData);

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
            ax.CLim = [0 1];
    end

    % Additional axes property side effects.
    ax.DataAspectRatio = [1 1 1];
    ax.YDir = "reverse";
    ax.XLimMode = "auto";
    ax.YLimMode = "auto";
    ax.XLimitMethod = "tight";
    ax.YLimitMethod = "tight";
    ax.Visible = "off";

    pixelgrid(im);

    switch options_p.Interpolation
        case "nearest"
            im.Interpolation = "nearest";
        case "bilinear"
            im.Interpolation = "bilinear";
        case "adaptive"
            % Start as bilinear. The update function will change this to
            % nearest when the pixels get big enough.
            im.Interpolation = "bilinear";
    end

    update_fcn = @(~,~) updateImageDisplay(im, ...
        options_p.ShowZoomLevel, options_p.Interpolation);

    % See the article "Undocumented HG2 graphics events" for an explanation
    % of the following code.
    %
    % https://undocumentedmatlab.com/articles/undocumented-hg2-graphics-events
    % addlistener(im,"MarkedClean",@(~,~) ...
    %     updateImageDisplay(im, options_p.ShowZoomLevel, options_p.Interpolation));
    addlistener(ax,"MarkedClean", update_fcn);
    addlistener(im,"MarkedClean", update_fcn);
    addShowZoomLevelToolbarButton(ax, options_p.ShowZoomLevel);

    % Make sure the update function gets called at least once.
    update_fcn();

    % Standard practice in high-level graphics functions is to return an
    % output argument only if requested.
    if nargout > 0
        out = im;
    end
end

function updateImageDisplay(im, show_zoom_level, interpolation_mode)
    if ~ishandle(im)
        return
    end
    
    if (interpolation_mode == "adaptive")
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

    updateZoomLevelDisplay(im,show_zoom_level)
end

function ax = imageAxes(im)
    ax = ancestor(im, "axes");
    if isempty(ax)
        ax = ancestor(im, "uiaxes");
    end    
end

%%%
%%% Utility functions for managing zoom level display
%%%
%%%     createZoomLevelDisplay
%%%     handleZoomLevelDisplayClick
%%%     handleZoomLevelDisplayChange
%%%     zoomLevelFromString
%%%     updateZoomLevelDisplay
%%%     zoomLevelText
%%%     findZoomLevelDisplay
%%%     updateZoomLevelDisplayPosition
%%%     showZoomLevelSetting
%%%     addShowZoomLevelToolbarButton
%%%     handleZoomLevelToolbarValueChange
%%%

function t = createZoomLevelDisplay(im,show_zoom_level)
    s = struct("Image", im, "PostSetListener", []);
    t = text(1,1,"", ...
         BackgroundColor = uint8([200 200 200 200]), ...
         Color = "black", ...
         FontSize = 10, ...
         HorizontalAlignment = "right", ...
         VerticalAlignment = "bottom", ...
         Margin = 1, ...
         ButtonDownFcn = @handleZoomLevelDisplayTextClick, ...
         Visible = show_zoom_level, ...
         Tag = "ZoomLevelDisplay", ...
         UserData = s, ...
         Parent = imageAxes(im));
end

function handleZoomLevelDisplayTextClick(t,~)
    t.UserData.PostSetListener = addlistener(t, "String", "PostSet", ...
        @handleZoomLevelDisplayChange);
    t.Editing = "on";
end

function handleZoomLevelDisplayChange(~,prop_event)
    t = prop_event.AffectedObject;
    delete(t.UserData.PostSetListener);
    t.UserData.PostSetListener = [];
    im = t.UserData.Image;
    if ~isgraphics(im)
        t.String = "";
    else
        mag = zoomLevelFromString(t.String);
        if isempty(mag)
            % Invalid text field entry from user.
            mag = getImageZoomLevel(im);
        else
            setImageZoomLevel(mag,im)
        end
        t.String = zoomLevelText(mag);
    end
end

function mag = zoomLevelFromString(s)
    s = replace(s, "%", "");
    mag = sscanf(s, "%f");
    valid_mag = (numel(mag) >= 1) && ...
        (numel(mag) <= 2) && ...
        isreal(mag) && ...
        all(isfinite(mag)) && ...
        all(mag > 0);

    if ~valid_mag
        mag = [];
    end
end

function updateZoomLevelDisplay(im,show_zoom_level)
    t = findZoomLevelDisplay(im);
    if isempty(t)
        t = createZoomLevelDisplay(im,show_zoom_level);
    end
    updateZoomLevelDisplayPosition(t,im);
    t.String = zoomLevelText(getImageZoomLevel(im));
end

function s = zoomLevelText(mag)
    if isscalar(mag)
        s = sprintf(" %d%% ", round(mag));
    else
        d = abs(diff(mag)) / max(mag);
        reltol = 5e-4;
        if (d < reltol)
            s = sprintf(" %d%% ", round(max(mag)));
        else
            s = " " + sprintf("%d%% ", round(mag));
        end
    end
end

function t = findZoomLevelDisplay(im)
    ax = imageAxes(im);
    t = findobj(ax,"Tag","ZoomLevelDisplay");
    if ~isempty(t)
        t = t(1);
    end
end

function updateZoomLevelDisplayPosition(t,im)
    ax = imageAxes(im);
    xdata = im.XData;
    ydata = im.YData;
    M = size(im.CData,1);
    N = size(im.CData,2);
    if (M == 1)
        pixel_width = 1;
    else
        pixel_width = (xdata(end) - xdata(1))/(N - 1);
    end
    if (N == 1)
        pixel_height = 1;
    else
        pixel_height = (ydata(end) - ydata(1))/(M - 1);
    end
    x = xdata(end) + pixel_width/2;
    x = min(x,ax.XLim(2));
    y = ydata(end) + pixel_height/2;
    y = min(y,ax.YLim(2));
    if ~isequal(t.Position(1:2), [x y])
        t.Position(1:2) = [x y];
    end
end

function tf = showZoomLevelSetting
    s = settings;
    if ~hasGroup(s,"imview")
        addGroup(s,"imview")
    end

    g = s.imview;

    if ~g.hasSetting("ShowZoomLevel")
        g.addSetting("ShowZoomLevel", PersonalValue = true);
    end

    zoom_setting = g.ShowZoomLevel;

    tf = zoom_setting.ActiveValue;
end

function addShowZoomLevelToolbarButton(ax, initial_value)
    tb_old = ax.Toolbar;
    if ~isempty(findobj(tb_old, "Tag", "ShowZoomLevelButton"))
        return
    end

    btns = tb_old.Children;
    if isempty(btns)
        tb = axtoolbar(ax, "default");
    else
        tb = axtoolbar(ax);
        btns(k).Parent = tb;
    end

    if initial_value
        tooltip = "Hide zoom-level display";
    else
        tooltip = "Show zoom-level display";
    end

    axtoolbarbtn(tb, "state", ...
        Icon = "imview_show_zoom_level_icon.png", ...
        Value = initial_value, ...
        Tooltip = tooltip, ...
        Tag = "ShowZoomLevelButton", ...
        ValueChangedFcn = @handleZoomLevelToolbarValueChange );
end

function handleZoomLevelToolbarValueChange(btn,event)
    tb = btn.Parent;
    ax = tb.Parent;
    txt = findobj(ax, "Tag", "ZoomLevelDisplay");
    if isempty(txt)
        return
    end

    if event.Value
        txt.Visible = "on";
        btn.Tooltip = "Hide zoom-level display";
    else
        txt.Visible = "off";
        btn.Tooltip = "Show zoom-level display";
    end
end

%%%
%%% Utility functions for checking and processing function inputs
%%%
%%%     imageType
%%%     processImageData
%%%     verifyDependencies
%%%     mFunctionExists
%%%     mustBeValidXYData
%%%     mustBeValidGrayLimits
%%%     mustBeValidParentAxes
%%%     processOptions
%%%     processShowZoomLevel
%%%     processAlphaData
%%%     processParent
%%%     processInterpolation
%%%     processXData
%%%     processYData
%%%     processGrayLimits
%%%     

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

function [A,map,alpha] = processImageData(A,map,alpha)
    if ischar(A) || isstring(A)
        A = string(A);
        if ~exist(A,"file")
            id = "imview:NoSuchFile";
            message = "Cannot find the specified file: ""%s"".";
            error(id, message, A)
        end
        try
            [A,map,alpha] = imread(A);
            if isa(alpha, "uint8")
                alpha = double(alpha)/255;
            elseif isa(alpha, "uint16")
                alpha = double(alpha)/65535;
            end
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
    options_p.AlphaData = processAlphaData(options);
    options_p.ShowZoomLevel = processShowZoomLevel(options);
end

function show = processShowZoomLevel(options)
    if isfield(options, "ShowZoomLevel")
        show = options.ShowZoomLevel;
    else
        show = showZoomLevelSetting();
    end
end

function alpha_data_p = processAlphaData(options)
    if isempty(options.AlphaData)
        alpha_data_p = 1;
    else
        alpha_data_p = options.AlphaData;
    end
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
    if isfield(options, "SpatialReference")
        % If SpatialReference and XData are both specified,
        % SpatialReference takes precedence.
        ref = options.SpatialReference;
        xdata = ref.XWorldLimits + ref.PixelExtentInWorldX * [0.5 -0.5];

    elseif isfield(options,"XData")
        xdata = options.XData;

    else
        xdata = [1 size(A,2)];
    end
end

function ydata = processYData(options,A)
    if isfield(options, "SpatialReference")
        % If SpatialReference and YData are both specified,
        % SpatialReference takes precedence.
        ref = options.SpatialReference;
        ydata = ref.YWorldLimits + ref.PixelExtentInWorldY * [0.5 -0.5]; 

    elseif isfield(options,"YData")
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
