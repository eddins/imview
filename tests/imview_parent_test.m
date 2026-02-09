classdef imview_parent_test < imview_test_setup
    methods (Test)
        function specifyParent_test(test_case)
            tl = tiledlayout("flow",Parent = test_case.Figure);
            ax1 = nexttile(tl);
            ax2 = nexttile(tl);

            im1 = imview(1, Parent = ax1);
            im2 = imview(1, Parent = ax2);

            test_case.verifyEqual(im1.Parent, ax1);
            test_case.verifyEqual(im2.Parent, ax2);
        end

        function notAnAxes(test_case)
            f = @() imview([0 .5 1], Parent = test_case.Figure);

            test_case.verifyError(f, "imview:InvalidParent");
        end
    end
end