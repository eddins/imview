classdef imview_helper_object_deletion_test < imview_test_setup
    methods (Test)
        function pixelGridDeletion(test_case)
            im = imview([0 0.5 1], Parent = test_case.Axes);
            grid = imvw.internal.findPixelGrid(im);

            delete(im);
            test_case.verifyFalse(isgraphics(grid));
        end

        function zoomLevelDisplayDeletion(test_case)
            im = imview([0 0.5 1], Parent = test_case.Axes);
            zoom_level_display = findobj(ancestor(im, "axes"), "type", "text", ...
                "Tag", "imview");

            delete(im);
            test_case.verifyFalse(isgraphics(zoom_level_display));            
        end
    end
end