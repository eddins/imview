classdef imview_showzoomlevel_test < imview_test_setup
    methods (Test)
        function disableZoomLevelDisplay(test_case)
            im = imview([0 .5 1], ShowZoomLevel = false, Parent = test_case.Axes);
            zoom_level_display = findobj(ancestor(im, "axes"), ...
                "type", "text", "Tag", "imview");

            test_case.verifyFalse(zoom_level_display.Visible);
        end
    end
end