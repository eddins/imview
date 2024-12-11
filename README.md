[![View IMVIEW Image Display Function on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/placeholder) [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=eddins/imview&file=toolbox/gettingStarted.mlx)

# IMVIEW Image Display Function

The MATLAB function `imview` displays a binary, grayscale, or RGB image. It is intended to be used instead of `imshow` in most cases. It has several important differences in behavior:
 
- `imview` does not resize the figure containing the image display. Instead, the image is displayed in the current axes in the current figure without changing the figure or axes size.
- `imview` displays the image using bilinear interpolation and antialiasing, unless individual pixels are larger than about 0.2 inches. In that case, the interpolation switches automatically to nearest neighbor, and a pixel grid is shown. The function `imshow` uses nearest neighbor interpolation by default.
 - Unlike `imshow`, `imview` does not explicitly set the axes `XLim` and `YLim` properties. Instead, it sets the `XLimitMethod` and `YLimitMethod` properties to `"tight"`. With this choice, the axes limits will tightly enclose the data contained by the axes, including the image and anything else that might also be plotted in the same axes. Also unlike `imshow`, the axes limits will continue to automatically adjust to additional data being plotted there.
 - `imview` does not observe the MATLAB Image Display Preferences.
 
## Limitations
 
The function `imview` is under development. This version does not yet have some of the options supported by imshow, including:
 
- Overriding the default black-white range
- Overriding the default interpolation behavior
- Overriding the default `XData` and `YData`
- Setting the initial magnification level
- Specifying the parent axes
- Displaying an indexed image
- Using an image filename or URL
 
## Prerequisites
 
The function `imview` requires the following add-ons that are available from the MATLAB File Exchange:
 
- [Pixel Grid](https://www.mathworks.com/matlabcentral/fileexchange/71622-pixel-grid) 
- [Image Zoom Level and Pan Utilities](https://www.mathworks.com/matlabcentral/fileexchange/167316-image-zoom-level-and-pan-utilities)

## Installation

Download the `.mltbx` file from the [GitHub repository releases area](https://github.com/eddins/imview/releases/) or from the [File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/placeholder). Double-click on the downloaded file to automatically and run the MATLAB add-on installer. This will copy the files to your MATLAB add-ons area and add the appropriate folder to your MATLAB search path.

Later, you can use the [MATLAB Add-On Manager](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html) to uninstall.

## Getting Started

See the [Getting Started](https://placeholder) script for more information.

Copyright &copy; 2024 Steven L. Eddins