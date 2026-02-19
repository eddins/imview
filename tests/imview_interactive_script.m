%[text] %[text:anchor:T_D1086FBF] # IMVIEW Interactive Tests
%%
%[text] ## Display Truecolor Image
A = imread("capitol-building-stained-glass.jpg");
imview(A)
%%
%[text] ## Display Grayscale Image
B = imread("margaret-d-foster.jpg");
imview(B)
%%
%[text] ## Display Binary Image
C = imread("US2484408-drawings-page-1-cropped.png");
imview(C)
%%
%[text] ## Display Indexed Image
[X,map] = imread("trees.tif");
imview(X,map)
%%
%[text] ### Set the Zoom Level Directly Using the Zoom Level Display
imview(X,map)
%[text] Click on the zoom level display at the lower right and then change it to a different zoom level.
%[text] Then click on the zoom level display and enter "fit".
%%
%[text] ## Use Axes Toolbar Button to Show and Hide Zoom Level
%[text] Click on the button with the "%" icon to show or hide the zoom level.
imview(B)
%%
%[text] ## See Interpolation and Pixel Grid Changes at Extreme Zoom Levels
imview(A)
%%
%[text] ## Set the Gray Limits Manually
%[text] The dataset in this example is 1-month rainfall for December 2024, 0.5 degree resolution, IMERG program, downloaded from [https://neo.gsfc.nasa.gov/view.php?datasetId=GPM\_3IMERGM](https://neo.gsfc.nasa.gov/view.php?datasetId=GPM_3IMERGM) on 25-Jan-2025. The colormap is the same colormap used on that web page. The data is in millimeters, and the color scale is intended to from 1 to 2000 mm.
load nasa-rainfall-05-degrees-dec-2024 R map
imview(R,GrayLimits=[1 2000])
colormap(map)
axis on
box on
colorbar
%%
%[text] ## Set the Gray Limits to the Full Data Range
D = magic(25);
imview(D, GrayLimits="datarange", Interpolation="nearest")
colorbar
%%
%[text] ## Display Image Using a Spatial Reference
%[text] *This example requires Image Processing Toolbox. The task can also be accomplished without the Image Processing Toolbox by setting the* ***`XData`*** *and* ***`YData`*** *properties of the image.*
%[text] Display an image so that each pixel is 0.001 x 0.001 in the *x-y* domain. Zoom into the center of the image. Turn the axes display on so that the x and y tick labels are visible.
ref = imref2d(size(C),0.001,0.001);
imview(C, SpatialReference = ref)
setImageZoomLevel(50)
axis on
%[text] 
%%
%[text] %[text:anchor:H_3bbd] ## Display Image with Visible Axes
imview(C)
axis on
box on
%%
%[text] %[text:anchor:H_60b8] ## Display Image and Plot New Data
%[text] Unlike `imshow`, the function `imview` does not prevent the axes object from automatically readjusting its limits to respond to additional plotted data. The axes does, however, continue to maintain a data aspect ratio of `[1 1 1]`.
imview(C)
hold on
rectangle(Position = [1 1 2000 2000],...
    Curvature = [1 1],...
    EdgeColor = "red",...
    LineWidth = 3);
hold off
axis on
box on
%%
%[text] ## Display Skinny Image and Zoom to Fill Plot Box
imview(rand(1000,100))
%%
imview(rand(100,1000))
%%
%[text] ## Dynamic Behaviors Still Work After a Large Number of Images Have Been Displayed
imview(A)

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
