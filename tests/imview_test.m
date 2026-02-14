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

            test_case.verifyEqual(ax.DataAspectRatio, [1 1 1], RelTol = 1e-3);
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

        function indexedImage(test_case)
            im = imview([1 2 3], gray(3), Parent = test_case.Axes);

            test_case.verifyEqual(im.CDataMapping,'direct');
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

        function rgbImageWithColormapWarns(test_case)
            A = reshape([1 1 1],[1 1 3]);
            map = [1 1 1];

            f = @() imview(A, map, Parent = test_case.Axes);
            test_case.verifyWarning(f, "imview:MapIgnoredForTruecolorImage");
        end

        function noSuchFile(test_case)
            f = @() imview("bogus_file.png", Parent = test_case.Axes);

            test_case.verifyError(f, "imview:NoSuchFile");
        end

        function imageFileUnreadable(test_case)
            f = @() imview("not_an_image_file.txt", Parent = test_case.Axes);

            test_case.verifyError(f, "imview:FileReadFailed");
        end
    end

end
