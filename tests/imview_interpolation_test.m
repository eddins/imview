classdef imview_interpolation_test < imview_test_setup
    methods (Test)
        function specifyNearest(test_case)
            im = imview(ones(1000,1500), Interpolation = "nearest", ...
                Parent = test_case.Axes);

            test_case.verifyEqual(im.Interpolation, 'nearest');
        end

        function specifyBilinear(test_case)
            im = imview([0 .5 1], Interpolation = "bilinear", ...
                Parent = test_case.Axes);

            test_case.verifyEqual(im.Interpolation, 'bilinear');
        end

        function specifyAdaptive(test_case)
            im = imview(ones(1000,1500), Interpolation = "adaptive", ...
                Parent = test_case.Axes);

            test_case.verifyEqual(im.Interpolation, 'bilinear');

            % Zoom in and render, then verify the switch to nearest.
            axis(test_case.Axes, [10 12 50 52]);
            drawnow
            test_case.verifyEqual(im.Interpolation, 'nearest');
        end
    end
end

% Copyright 2026 Steven L. Eddins