classdef imview_alphadata_test < imview_test_setup
    methods (Test)
        function alphadata_test(test_case)
            im = imview([0 0.5 1], Parent = test_case.Axes, ...
                AlphaData = [1 0.5 0]);

            test_case.verifyEqual(im.AlphaData, [1 0.5 0]);
        end
    end
end