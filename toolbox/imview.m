%IMVIEW Display image.
%   IMVIEW(A) displays the input image, A, in the current axes. A can be a
%   matrix or array representing a binary, grayscale, or RGB image.
%
%   A binary image is represented as a logical matrix. A grayscale image is
%   represented as a numeric matrix. An RGB image is represented as an
%   MxNx3 array with type double, single, uint8, or uint16.
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
%   - Overriding the default black-white range
%   - Overriding the default interpolation behavior
%   - Overriding the default XData and YData
%   - Setting the initial magnification level (although you can use
%     setImageZoomLevel or zoomImage after calling imview)
%   - Specifying the parent axes
%   - Displaying an indexed image
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

function out = imview(A)
    arguments
        A
    end

    verifyDependencies();

    ax = newplot;
    im = image(CData = A, Parent = ax, Interpolation = "bilinear");

    M = size(A,1);
    N = size(A,2);
    P = size(A,3);

    im.XData = [1 N];
    im.YData = [1 M];

    treat_as_rgb = (P == 3);
    if ~treat_as_rgb
        im.CDataMapping = "scaled";
        ax.CLim = getrangefromclass(A);
        ax.Colormap = gray(256);
    end

    ax.DataAspectRatio = [1 1 1];
    ax.YDir = "reverse";
    ax.XLimMode = "auto";
    ax.YLimMode = "auto";
    ax.XLimitMethod = "tight";
    ax.YLimitMethod = "tight";
    ax.Visible = "off";

    pixelgrid(im)

    % See the article "Undocumented HG2 graphics events" for an explanation
    % of the following code.
    %
    % https://undocumentedmatlab.com/articles/undocumented-hg2-graphics-events
    addlistener(im,"MarkedClean",@(~,~) updateImageDisplayMethod(im));
    addlistener(ax,"MarkedClean",@(~,~) updateImageDisplayMethod(im));

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

% Copyright 2024 Steven L. Eddins
