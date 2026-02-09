classdef imview_xydata_test < imview_test_setup
    methods (Test)
        function xdata_test(test_class)
            im = imview([1 2; 3 4], Parent = test_class.Axes, ...
                XData = [10 11]);

            test_class.verifyEqual(im.XData, [10 11]);
        end

        function default_xdata_test(test_class)
            im = imview([1 2; 3 4], Parent = test_class.Axes);

            test_class.verifyEqual(im.XData, [1 2]);
        end

        function ydata_test(test_class)
            im = imview([1 2; 3 4], Parent = test_class.Axes, ...
                YData = [10 11]);

            test_class.verifyEqual(im.YData, [10 11]);
        end

        function default_ydata_test(test_class)
            im = imview([1 2; 3 4], Parent = test_class.Axes);

            test_class.verifyEqual(im.YData, [1 2]);
        end  

        function spatialReferenceInput(test_case)
            ref = imref2d([3 3], [4 10], [-4 -1]);
            expected_xdata = [5 9];
            expected_ydata = [-3.5 -1.5];

            im = imview([0 .5 1], SpatialReference = ref, ...
                Parent = test_case.Axes);
            actual_xdata = im.XData;
            actual_ydata = im.YData;

            test_case.verifyEqual(actual_xdata, expected_xdata);
            test_case.verifyEqual(actual_ydata, expected_ydata);
        end

        function xyDataValidity(test_case)
            f = @() imview(1, XData = [1 2 3], Parent = test_case.Axes);
            g = @() imview(1, YData = [1 2i], Parent = test_case.Axes);
            h = @() imview(1, XData = [1 nan], Parent = test_case.Axes);

            test_case.verifyError(f, "MATLAB:validation:IncompatibleSize");
            test_case.verifyError(g, "MATLAB:validators:mustBeReal");
            test_case.verifyError(h, "MATLAB:validators:mustBeFinite");
        end        
    end
end