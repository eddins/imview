# IMVIEW Release Notes

## Version 3.0.0

- Supports use within the Live Editor.
- Required version of MATLAB is R2022b.
- Zooming in on "skinny" tall or wide images will now use all of the available space in the plotting region.
- For the auto image interpolation method, interpolation switches to nearest when pixels are about 1/16 inch wide, instead of 1/4 inch.
- Pixel grid is shown when pixels are about 3/8 inch wide, instead of 1/4 inch.
- New settings are available:
    - `AdaptiveInterpolationThreshold`
    - `PixelGridThreshold`
- The zoom-level display percentage is now rounded appropriately to avoid presenting a misleading precision.
- The [Pixel Grid](https://www.mathworks.com/matlabcentral/fileexchange/71622-pixel-grid) and [Image Zoom Level and Pan Utilities](https://www.mathworks.com/matlabcentral/fileexchange/167316-image-zoom-level-and-pan-utilities) packages are no longer required.
- MATLAB version R2022b or later is now required.

## Version 2.0.5

There are no code or functional changes in this release. It is only for resolving an issue with the File Exchange connection.

## Version 2.0.4

Various implementation changes to improve robustness.

Changed the pixel size threshold for adaptive interpolation to 0.25 inches.

Now depends on version 2.0.2 or later of [Image Zoom Level and Pan Utilities](https://www.mathworks.com/matlabcentral/fileexchange/167316-image-zoom-level-and-pan-utilities).

Now depends on version 2.0.2 or later of [Pixel Grid](https://www.mathworks.com/matlabcentral/fileexchange/71622-pixel-grid).

## Version 2.0.3

Fixed bug in initial creation of imview settings group.

## Version 2.0.0

- Supports indexed images
- Supports getting image data from a file or URL
- New optional inputs:
    - AlphaData
    - GrayLimits
    - Interpolation
    - Parent
    - ShowZoomLevel
    - SpatialReference
    - XData
    - YData
- New zoom-level display in the lower right corner. The zoom level may be changed by editing this value directly. The zoom level display can be disabled using the ShowZoomLevel input argument, using the "%" button on the axes toolbar, or by modifying the `settings().imview.ShowZoomLevel` setting.

### Version 2.0 Compatibility Considerations

The image's appearance has changed with the addition of the zoom-level display in the lower right corner. This display can be turned off as described above.

### Version 2.0 Limitations

The zoom-level display does not work correctly when `imview` is used in a live script in the MATLAB Editor. The displayed zoom level may be incorrect, and the display may move around or disappear when the image is zoomed or panned.

