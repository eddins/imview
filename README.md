[![View IMVIEW Image Display Function on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/177319-imview-image-display-function) [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=eddins/imview&file=toolbox/gettingStarted.mlx)

# IMVIEW Image Display Function

The MATLAB function `imview` displays a binary, grayscale, indexed, or RGB image. It is intended to be used instead of `imshow` in most cases. It behaves better with other MATLAB graphics functions, it uses a higher quality image interpolation, and it displays and makes it easy to change the zoom level.

## Comparing `imview` and `imshow`

The function `imview` is intended to be used instead of `imshow` for many
purposes. It differs from `imshow` in several important ways:

- `imview` does not resize the figure containing the image display.
Instead, the image is displayed in the current axes in the current
figure (as returned by the function `newplot`). A figure and axes will be
created if they do not exist.

- `imview` displays the image using bilinear interpolation and
antialiasing, unless individual pixels are larger than about 1/16 inch. In that case, the interpolation switches automatically to nearest neighbor. The function `imshow` uses nearest neighbor interpolation by default. When individual pixels get even larger, more than about 3/8 inch, a pixel grid is shown.

- `imview` displays the zoom level (as a percentage) at the lower
right of the image. The zoom level can be changed directly by clicking
on the zoom level display and editing it. The zoom level can be hidden and shown using an axes interaction toolbar button. The zoom level is displayed
by default, but you can override that using the `ShowZoomLevel` argument.
You can also override it by changing a persistent setting: `s = settings; s.imview.ShowZoomLevel.PersonalValue = true;`

- Unlike `imshow`, `imview` does not explicitly set the axes `XLim` and `YLim`
properties. Instead, it sets the `XLimitMethod` and `YLimitMethod`
properties to `"tight"`. With this choice, the axes limits will tightly
enclose the data contained by the axes, including the image and
anything else that might also be plotted in the same axes. Also unlike
`imshow`, the axes limits will continue to automatically adjust to
additional data being plotted there.

- When displaying a "skinny" wide or "skinny" tall image and zooming in, the zoomed-in image will expand to fill the entire plotting region. When using `imshow`, the zoomed-in region is unnecessarily constrained to lie within the original image extent.

- When displaying an indexed image, `imview` sets the colormap of the
axes instead of the figure.

- `imview` supports `AlphaData` input.

- When reading image data from a PNG file, `imview` will read and use
pixel transparency data if it is in the file.

- `imview` does not have an input argument for controlling the initial
zoom level, as `InitialMagnification` does for `imshow`. Instead, call
`setImageZoomLevel` or `zoomImage` after calling imview.

- `imview` does not observe the MATLAB Image Display Preferences.
 
## Prerequisites
 
The function `imview` requires MATLAB version R2022b or later.

## Installation

Download the `.mltbx` file from the [GitHub repository releases area](https://github.com/eddins/imview/releases/) or from the [File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/placeholder). Double-click on the downloaded file to automatically and run the MATLAB add-on installer. This will copy the files to your MATLAB add-ons area and add the appropriate folder to your MATLAB search path.

After installation, this imview version may be shadowed by a placeholder function in Image Processing Toolbox with the same name. That function only issues an error message. It is a remnant of a general image display tool that existed in the product about 20 years ago. To fix this installation issue:

1. Click "Set Path" in the MATLAB toolstrip. 
1. Find the path entry for the IMVIEW add-on; it may be near the bottom of the long list. 
1. Right-click on the path entry and select "Move to top." 
1. Check the box that says "Save path for future sessions."
1. Click "Apply."

Later, you can use the [MATLAB Add-On Manager](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html) to uninstall.

## Getting Started

See the [Getting Started](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2Fb2565ebf-4819-4e5a-8c49-f6a32f92a051%2F1733961676%2Ffiles%2FgettingStarted.mlx&embed=web) script for more information.

## Image Credits

### margaret-d-foster.jpg

Created / published October 4, 1919

Prints & Photographs Online Catalog (Library of Congress)

LCCN Permalink: https://lccn.loc.gov/2016827164

Rights: No known restrictions on publication. For more information, see National Photo Company Collection - Rights and Restrictions Information https://www.loc.gov/rr/print/res/275_npco.html

TIFF file downloaded from https://www.loc.gov/resource/npcc.00520/ on 20-Jan-2025 and converted to JPEG using Mac Preview app.

### capitol-building-stained-glass.jpg

Created / published February 21, 2021, Carol M. Highsmith, photographer

Prints & Photographs Online Catalog (Library of Congress), gift of photographer

LCCN Permalink: https://lccn.loc.gov/2021755860

Rights: No known restrictions on publication.

432.9 MB TIFF file downloaded from https://www.loc.gov/resource/highsm.67639/ on 20-Jan-2025, converted to JPEG and reduced to 3550x2662 by Mac Preview app.

### nasa-rainfall-05-degrees-dec-2024.mat

1-month rainfall for December 2024, 0.5 degree resolution, IMERG program, downloaded from https://neo.gsfc.nasa.gov/view.php?datasetId=GPM_3IMERGM on 25-Jan-2025.

Copyright &copy; 2024 Steven L. Eddins