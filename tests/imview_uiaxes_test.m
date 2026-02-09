classdef imview_uiaxes_test < matlab.unittest.TestCase
    methods (Test)
        function uiaxesParent(test_case)
            fig = figure;
            ax = uiaxes(Parent = fig);
            cleaner = onCleanup(@() delete(fig));

            im = imview(magic(3), Parent = ax);
            test_case.verifyTrue(isgraphics(im));
        end
    end
end