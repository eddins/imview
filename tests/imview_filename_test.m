classdef imview_filename_test < imview_test_setup
    methods (Test)
        function image_file_test(test_case)
            im = imview("bit.png", Parent = test_case.Axes);

            test_case.verifyEqual(im.CData,true)
        end

        function indexed_image_file_test(test_case)
            im = imview("indexed.png", Parent = test_case.Axes);

            test_case.verifyEqual(im.CDataMapping, 'direct');
            test_case.verifyEqual(test_case.Axes.Colormap,[0 0 0; 1 1 1]);
        end
    end
end