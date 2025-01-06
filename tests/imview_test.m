classdef imview_test < imview_test_setup  

    methods (Test)
        % Test methods

        function outputType(test_case)
            im = imview(1, Parent = test_case.Axes);
            
            test_case.verifyClass(im,"matlab.graphics.primitive.Image");
        end


        function someAxesProperties(test_case)
            imview(magic(3), Parent = test_case.Axes);
            ax = test_case.Axes;

            test_case.verifyEqual(ax.DataAspectRatio,[1 1 1]);
            test_case.verifyEqual(ax.YDir,'reverse');
            test_case.verifyEqual(ax.XLimitMethod,'tight');
            test_case.verifyEqual(ax.YLimitMethod,'tight');
            test_case.verifyEqual(ax.Visible,matlab.lang.OnOffSwitchState("off"));
        end

        function logicalImage(test_case)
            imview(logical([0 1 0; 1 0 1; 0 1 0]),...
                Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim,[0 1]);
        end

        function uint8GrayImage(test_case)
            imview(uint8([0 1 0; 1 0 1; 0 1 0]), ...
                Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim,[0 255]);
        end

        function uint16GrayImage(test_case)
            imview(uint16(1), ...
                Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim,[0 65535]);
        end

        function singleGrayImage(test_case)
            imview(single(1), ...
                Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim,[0 1]);
        end

        function doubleGrayImage(test_case)
            imview(1, ...
                Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim,[0 1]);
        end

        function rgbImage(test_case)
            im = imview(reshape([1 1 1],[1 1 3]), ...
                Parent = test_case.Axes);

            test_case.verifySize(im.CData,[1 1 3]);
        end     
    end

end
