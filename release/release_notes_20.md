# IMVIEW 2.0 Release Notes

## New Features

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

## Compatibility Considerations

The image's appearance has changed with the addition of the zoom-level display in the lower right corner. This display can be turned off as described above.

## Limitations

The zoom-level display does not work correctly when `imview` is used in a live script in the MATLAB Editor. The displayed zoom level may be incorrect, and the display may move around or disappear when the image is zoomed or panned.

