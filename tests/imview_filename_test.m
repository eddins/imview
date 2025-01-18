classdef imview_filename_test < imview_test_setup
    methods (Test)
        function image_file_test(test_case)
            im = imview("bit.png");

            test_case.verifyEqual(im.CData,true)
        end
    end
end