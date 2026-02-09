classdef imview_interpolation_test < imview_test_setup
    methods (Test)
        function specifyNearest(test_case)
            im = imview(ones(1000,1500), Interpolation = "nearest", ...
                Parent = test_case.Axes);

            test_case.verifyEqual(im.Interpolation, 'nearest');
        end

        function specifyBilinear(test_case)
            im = imview(ones(1000,1500), [1 1 1], Interpolation = "bilinear", ...
                Parent = test_case.Axes);

            test_case.verifyEqual(im.Interpolation, 'bilinear');
        end        
    end
end

% Copyright 2026 Steven L. Eddins