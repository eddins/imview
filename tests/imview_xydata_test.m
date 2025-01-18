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
    end
end