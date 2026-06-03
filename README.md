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
on the zoom level display and editing it. Set a new zoom level by entering it as a percentage, or by entering "fit" to make the entire image visible. The zoom level can be hidden and shown using an axes interaction toolbar button. The zoom level is displayed
by default, but you can override that using the `ShowZoomLevel` argument.
You can also override it by changing a persistent setting: `s = settings; s.imview.ShowZoomLevel.PersonalValue = true;`

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
 
The function `imview` requires MATLAB version R2026a or later.

**Note**: The minimum release is set to R2026a because that is the first release in which Image Processing Toolbox does not have a placeholder do-nothing function with the conflicting name `imview`.

If IMVIEW Image Display Function is installed in an earlier release, R2022b or later, it will likely work once the MATLAB search path is manually modified to place toolbox/imview above MathWorks product folders. See the [MATLAB search path documentation](https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html) for details on this procedure.

## Installation

Download the `.mltbx` file from the [GitHub repository releases area](https://github.com/eddins/imview/releases/) or from the [File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/placeholder). Double-click on the downloaded file to automatically and run the MATLAB add-on installer. This will copy the files to your MATLAB add-ons area and add the appropriate folder to your MATLAB search path.

Later, you can use the [MATLAB Add-On Manager](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html) to uninstall.

## Getting Started

See the Getting Started script (toolbox/ImviewGettingStarted.mlx) script for more information.

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

Copyright &copy; 2024-2026 Steven L. Eddins