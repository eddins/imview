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
%   antialiasing, unless individual pixels are larger than about 0.25
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
%   When using a PNG file's pixel transparency, IMVIEW does not read or use
%   the background color contained in the file, so the appearance may be
%   different from the PNG creator's intent.
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

    prepareLiveEditorUse();

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
        AlphaData = options_p.AlphaData, ...
        Tag = "imview");
    setappdata(im, "imview_interpolation_method", options_p.Interpolation);

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

    setImviewID(im);

    % Additional axes property side effects.
    ax.DataAspectRatio = [1 1 1];
    ax.YDir = "reverse";
    ax.XLimMode = "auto";
    ax.YLimMode = "auto";
    ax.XLimitMethod = "tight";
    ax.YLimitMethod = "tight";
    ax.Visible = "off";

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

    addDynamicBehaviors(im, ax, options_p);

    % Standard practice in high-level graphics functions is to return an
    % output argument only if requested.
    if nargout > 0
        out = im;
    end
end

%%%
%%% UPDATE IMAGE DISPLAY
%%%
%%% Respond to image zoom by keeping the zoom level display, the
%%% interpolation method, and the pixel grid display in sync.
%%%

function updateImageDisplay(im, interpolation_mode)
    if ~ishandle(im)
        return
    end
    
    if (interpolation_mode == "adaptive")
        if ismatrix(im.CData) && strcmp(im.CDataMapping,'direct')
            if ~strcmp(im.Interpolation,'nearest')
                im.Interpolation = 'nearest';
            end
        else
            if any(imvw.internal.getImagePixelExtentInches(im) >= 0.25)
                if ~strcmp(im.Interpolation,'nearest')
                    im.Interpolation = 'nearest';
                end
                setPixelGridVisibility(im,"on");
            else
                if ~strcmp(im.Interpolation,'bilinear')
                    im.Interpolation = 'bilinear';
                end
                setPixelGridVisibility(im,"off");
            end
        end
    end

    ax = imageAxes(im);
    if (ax.XLimMode == "auto") || (ax.YLimMode == "auto")
        zoom_level = imvw.internal.getImageZoomLevel(im);
        axes_center = imvw.internal.getAxesCenterXY(ax);
        ax.XLimMode = "auto";
        ax.YLimMode = "auto";
        imvw.internal.setImageZoomLevel(zoom_level, im);
        imvw.internal.setAxesCenterXY(axes_center, ax);
    end

    updateZoomLevelDisplay(im)
end

function setPixelGridVisibility(im,visible_state)
    ax = imageAxes(im);
    gg = findobj(ax, "type", "hggroup", "Tag", "imview");
    pg_grp = [];
    for k = 1:length(gg)
        if getappdata(gg(k), "imview_id") == getappdata(im, "imview_id")
            pg_grp = gg(k);
            break
        end
    end
    if (~isempty(pg_grp) && isgraphics(pg_grp))
        pg_grp.Visible = visible_state;
    end
end

function ax = imageAxes(im)
    ax = ancestor(im, "axes");
    if isempty(ax)
        ax = ancestor(im, "uiaxes");
    end    
end

%%%
%%% DYNAMIC BEHAVIOR INITIALIZATION
%%%
%%% Dynamic behaviors include:
%%%
%%%   - Changing the image interpolation method depending on the physical
%%%     pixel size.
%%%   - Showing or hiding the pixel grid depending on the physical pixel
%%%     size.
%%%   - Showing the current zoom level as text at the lower right of the
%%%     image. 
%%%   - Changing the current zoom level by editing the zoom level text.
%%%   - Showing and hiding teh current zoom level display using a button in
%%%     the axes toolbar.
%%%
%%% Architecturally, the creation of the various graphics objects
%%% associated with dynamic behavior (pixel grid, text object, axes
%%% toolbar button) has been separated from wiring up those objects to
%%% respond to various events. The separate steps are represented by the
%%% two functions addDynamicHelpers and connectDynamicHelpers.
%%%
%%% The steps are separated this way to facilitate Live Editor support. In
%%% the live editor, the helper objects need to be created when IMVIEW is
%%% called so that they will get copied into Live Editor embedded clone
%%% figures later, asynchronously. The correct wiring up of objects and
%%% event listeners can't happen until the Live Editor embedded figure gets
%%% cloned, at which point connectHelpers can be called on the embedded
%%% figure.
%%%

function addDynamicBehaviors(im, ax, options)
    addDynamicHelpers(im, ax, options);
    connectDynamicHelpers(im);
end

function addDynamicHelpers(im, ax, options_p)
    imview_id = getImviewID(im);
    imvw.internal.addPixelGridGroup(ax, im, imview_id);
    createZoomLevelDisplay(im, imview_id, options_p.ShowZoomLevel);
    addShowZoomLevelToolbarButton(ax, options_p.ShowZoomLevel);    
end

function connectDynamicHelpers(im)
    % Delete the pixel grid group when the image object gets deleted.
    pixel_grid = imvw.internal.findPixelGrid(im);
    if isgraphics(pixel_grid)
        addlistener(im, "ObjectBeingDestroyed", @(~,~) delete(pixel_grid));
    end

    zdisp = imvw.internal.findZoomLevelDisplay(im);
    if isgraphics(zdisp)
        addlistener(im, "ObjectBeingDestroyed", @(~,~) delete(zdisp));
        addlistener(zdisp, "EditingChanged", @handleZoomLevelDisplayChange);
    end    

    interpolation_method = getappdata(im, "imview_interpolation_method");
    update_fcn = @(~,~) updateImageDisplay(im, interpolation_method);  
    addlistener(im, "MarkedClean", update_fcn);
    new_ax_listener = listener(ancestor(im, "axes"), "MarkedClean", update_fcn);
    % Delete the axes MarkedClean listener if the image gets deleted.
    addlistener(im, "ObjectBeingDestroyed", @(varargin) delete(new_ax_listener)); 

    update_fcn();
end

%%%
%%% Live Editor Embedded Figure Management
%%%
%%% This description is based on the results of my investigations in fall
%%% 2025 and winter 2026.
%%%
%%% When graphics code is executed within the Live Editor, the graphics
%%% objects get created in a normal figure that is invisible. After code in
%%% an editor section finished executing, that figure is cloned into an
%%% internal, embedded figure. That embedded figure is what you see in the
%%% Live Editor.
%%%
%%% There are several tricky things to be aware of. First, if your code
%%% gets object handles, such as a figure, axes, or image handle, the
%%% handle will be for the normal, invisible figure, not the embedded
%%% figure that you see in the Live Editor. As a consequence, if you use
%%% those handles to wire up event handlers, you will not receive event
%%% notifications resulting from interactions with the embedded figure.
%%%
%%% Second, the embedded figures get created asynchronously, sometime after
%%% your code has finished executing. Therefore, wiring up event handlers
%%% for the embedded figure cannot be done directly from your code while it
%%% is executing in the Live Editor script, because the embedded figure
%%% might not exist yet.
%%%
%%% Third, each normal figure might be cloned into multiple embedded
%%% figures in the live script. That can happen when graphics object
%%% properties are modified in a separate code section. This usually
%%% results in an additional embedded figure clone being created for the
%%% separate code section.
%%%
%%% Fourth, when the Live Editor starts up, it creates a pool of embedded
%%% figures to be used and reused as necessary. This complicates the
%%% possible implementation strategy of using event notifications from the
%%% graphics root object to detect when embedded figures get created. Such
%%% event notifications might not get fired because the embedded figures
%%% have already been created before any IMVIEW code is executed.
%%%
%%% All of this complexity makes Live Editor support for IMVIEW challenging
%%% to implement.
%%%
%%% Here are the most important implementation details:
%%%
%%% - Every image created by a call to IMVIEW has a unique identifier,
%%%   called imview_id, stored in its application data. When the Live
%%%   Editor clones a figure into an embedded figure, this identifier gets
%%%   copied along.
%%%
%%% - If the Live Editor is running when IMVIEW is called, then IMVIEW
%%%   looks for any pre-created embedded figures that are not yet being
%%%   used. It installs listeners for these figures to detect when they
%%%   become visible.
%%%
%%% - When any figure gets created, or when pre-created Live Editor figures
%%%   go into use, they are searched to see if they contain any images
%%%   created by IMVIEW. If they do contain such images, then the images
%%%   and their containing axes are wired up to respond to interactive
%%%   IMVIEW behaviors.
%%% 
function setImviewID(im)
    imview_id = imvw.internal.uuid;
    setappdata(im, "imview_id", imview_id);
end

function imview_id = getImviewID(im)
    imview_id = getappdata(im, "imview_id");
end

function prepareLiveEditorUse()
    % If the Live Editor is running, find pre-created embedded internal
    % figures and instrument them with listeners to detect when they go
    % into use. Also, listen to figure creation notifications from the
    % graphics root.

    imvw.internal.log("Preparing for Live Editor Use.");
    if imvw.internal.liveEditorRunning()
        instrumentLiveEditorFigurePool();

        r = groot;
        appdata_listener_name = "imview_groot_child_added_listener";
        imvw.internal.log("Live Editor is running.");
        if isempty(getappdata(r, appdata_listener_name))
            imvw.internal.log("Creating ChildAdded listener for graphics root.");

            % When creating this listener, store it the figure's
            % application data using an imview-specific name. That way, the
            % listener will automatically be deactivated and destroyed when
            % the figure is destroyed, and it will be possible to detect
            % later that the listener has already been created.

            ell = listener(r, "ChildAdded", @respondToRootChildAdded);
            setappdata(r, appdata_listener_name, ell);
        else
            imvw.internal.log("Graphics Root already has imview ChildAdded listener.");
        end
    else
        imvw.internal.log("Live Editor is not running.");
    end
end

function respondToRootChildAdded(~, event_data)
    % A figure has been created. See if it is an embedded Live Editor
    % figure. If it is not, no action is needed.
    fig = event_data.Child;
    if (fig.Tag == "EmbeddedFigure_Internal")
        % If the figure is part of the Live Editor figure pool, then
        % instrument it so that it can be detected when the figures goes
        % into use.
        if (~fig.Visible && isempty(fig.editorID))
            % The embedded figure is part of the Live Editor figure pool.
            % Instrument it so that it can be detected when the figure goes
            % into use.
            instrumentLiveEditorFigurePool(fig);
        else
            % The embedded figure is in use. If it contains any IMVIEW
            % images, then wire up the interactive behaviors for those
            % images.
            ii = findobj(fig, "type", "image", "Tag", "imview");
            for k = 1:length(ii)
                connectDynamicHelpers(ii(k));
            end
        end
    end
end

function instrumentLiveEditorFigurePool(ff)
    if nargin < 1
        ff = imvw.internal.getLiveEditorFigurePool;
    end
    appdata_listener_name = "imview_figure_visibility_changed_listener";
    
    for k = 1:length(ff)
        if isempty(getappdata(ff(k), appdata_listener_name))
            % Sign up for notification of when this figure becomes visible.
            ell = listener(ff(k), "Visible", "PostSet", ...
                @respondToPoolFigureVisibilityChange);
            setappdata(ff(k), appdata_listener_name, ell);
        else
            % Pool figure already has visibility change listener. No
            % further action needed.
        end
    end
end

function respondToPoolFigureVisibilityChange(~, event_data)
    fig = event_data.AffectedObject;
    if fig.Visible
        if ~isempty(fig.editorID)
            % The figure has become visible and has been assigned an editor
            % ID, implying that it is now in use. Find any contained IMVIEW
            % images and wire up their interactive behaviors.
            imm = findobj(fig, "type", "image", "Tag", "imview");
            for k = 1:length(imm)
                connectDynamicHelpers(imm(k));
            end
        else
            % Although the figure has become visible, it has not been
            % assigned an editor ID. It is not known how to handle this
            % condition, so do nothing.
        end
    else
        % Pool figure has become invisible. No further action needed here.
    end
end

%%%
%%% ZOOM-LEVEL DISPLAY MANAGEMENT
%%%

function t = createZoomLevelDisplay(im, imview_id, show_zoom_level)
    t = text(50, 50, "hello", ...
         BackgroundColor = uint8([240 240 240]), ...
         Color = "black", ...
         EdgeColor = uint8([200 200 200]), ...
         FontSize = 8, ...
         HorizontalAlignment = "right", ...
         VerticalAlignment = "bottom", ...
         Margin = 1, ...
         Visible = show_zoom_level, ...
         Tag = "imview", ...
         Interactions = editInteraction, ...
         Parent = imageAxes(im));
    setappdata(t, "imview_id", imview_id);
    addlistener(t, "EditingChanged", @handleZoomLevelDisplayChange);
end

function handleZoomLevelDisplayChange(t,~)
    % A zoom-level display text object has been edited. First, find an
    % image object with a matching imview_id.
    imview_id = getappdata(t, "imview_id");
    ax = ancestor(t, "axes");
    ii = findobj(ax, "type", "image", "Tag", "imview");
    im = [];
    for k = 1:length(ii)
        if getappdata(ii(k), "imview_id") == imview_id
            im = ii(k);
            break
        end
    end

    if ~isgraphics(im)
        % The original image associated with this zoom-level display text
        % object has been deleted.
        t.String = "";
    else
        % Respond to the user's change. If they have entered a valid zoom
        % level, update the image display. Otherwise, reset the text field
        % based on the current zoom level of the image.
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

function mag = zoomLevelFromString(t)
    % Get a valid numeric zoom level from text. First, strip out any
    % percent characters.
    t = replace(t, "%", "");

    % Convert the text to one or more numbers using sscanf.
    mag = sscanf(t, "%f");
    valid_mag = (numel(mag) >= 1) && ...
        (numel(mag) <= 2) && ...
        isreal(mag) && ...
        all(isfinite(mag)) && ...
        all(mag > 0);

    if ~valid_mag
        % Not a valid zoom magnification level. Return empty instead.
        mag = [];
    end
end

function updateZoomLevelDisplay(im)
    % Update the text and the position of the zoom-level display based on
    % the current settings of the image object and its containers.
    t = findZoomLevelDisplay(im);
    if isempty(t) || ~isgraphics(t)
        return
    end
    updateZoomLevelDisplayPosition(t,im);
    t.String = zoomLevelText(imvw.internal.getImageZoomLevel(im));
end

function s = zoomLevelText(mag)
    % Convert a magnification level to text. If the two zoom values
    % (horizontal and vertical) are within 1.5 parts out of a hundred, just
    % use a single value.
    if ~isscalar(mag)
        e = abs(mag(2) - mag(1)) / max(mag(1), mag(2));
        if e < 1.5e-2
            mag = mean(mag);
        end
    end
    mag = round(round(mag,3,"significant"));
    s = sprintf(" %d%% ", mag);
end

function t = findZoomLevelDisplay(im)
    ax = imageAxes(im);
    imview_id = getappdata(im, "imview_id");
    tt = findobj(ax, "type", "text", "Tag", "imview");
    t = [];
    for k = 1:length(tt)
        if getappdata(tt(k), "imview_id") == imview_id
            t = tt(k);
            break
        end
    end
end

function updateZoomLevelDisplayPosition(t,im)
    % Place the zoom-level display at the bottom right of the image.
    ax = imageAxes(im);
    xdata = im.XData;
    xlim = ax.XLim;
    if ax.XDir == "normal"
        new_left = min(xdata(2), xlim(2));
    else
        new_left = max(xdata(1), xlim(1));
    end

    ydata = im.YData;
    ylim = ax.YLim;
    if ax.YDir == "reverse"
        new_bottom = min(ydata(2), ylim(2));
    else
        new_bottom = max(ydata(1), ylim(1));
    end
    t.Position(1:2) = [new_left new_bottom];
end

function tf = showZoomLevelSetting
    % Determine the current value of the imview.ShowZoomLevel setting.
    % Create the setting if it does not already exist.
    s = settings;
    if ~hasGroup(s,"imview")
        addGroup(s,"imview");
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
        % The axes toolbar already contains the show-zoom-level button.
        % Nothing to do here.
        return
    end

    if isempty(tb_old)
        % In an unfortunate quirk of the MATLAB graphics system, ax.Toolbar
        % equals [] could really mean that there is no axes toolbar, or it
        % could mean that the default axes toolbar is in place. Assume that
        % the default axes toolbar is present. In another unfortunate
        % quirk, additional buttons cannot be added to the default builtin
        % axes toolbar. To work around this limitation, recreate the
        % default axes toolbar using axtoolbar and the "default" option.
        % New buttons can then be added.
        tb = axtoolbar(ax, "default");
    else
        btns = tb_old.Children;
        if isempty(btns)
            % If the toolbar appears to have no children, that is another
            % indication that it might really be the default builtin axes
            % toolbar. As above, recreate the default axes toolbox using
            % axtoolbar and the "default" option.
            tb = axtoolbar(ax, "default");
        else
            % Create a new toolbar and add to it all the buttons from the
            % old toolbar.
            tb = axtoolbar(ax);
            for k = 1:length(btns)
                btns(k).Parent = tb;
            end
        end
    end

    % Create the show-zoom-level toolbar button. Set the appropriate
    % tooltip based on the initial state of the button.
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
    % Respond to a press of the show-zoom-level toolbar button. Set the
    % visibility of the zoom-level display, as well as the toolbar button
    % tooltip, appropriately.
    tb = btn.Parent;
    ax = tb.Parent;
    t = findobj(ax, "type", "text", "Tag", "imview");
    set(t, "Visible", event.Value);

    if event.Value
        btn.Tooltip = "Hide zoom-level display";
    else
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

% Copyright 2024-2026 Steven L. Eddins
