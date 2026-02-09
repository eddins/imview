classdef imview_gray_limits_test < imview_test_setup
    methods (Test)
        function basicNumericGrayLimits(test_case)
            imview(1, GrayLimits = [-2 2], Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim, [-2 2])
        end

        function uint8GrayLimits(test_case)
            imview(1, GrayLimits = uint8([5 10]), Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim, [5 10]);
        end

        function uint8TyperangeGrayLimits(test_case)
            imview(uint8(1), GrayLimits = "typerange", ...
                Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim, [0 255]);
        end

        function doubleTyperangeGrayLimits(test_case)
            imview(50, GrayLimits = "typerange", ...
                Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim, [0 1]);
        end

        function datarangeGrayLimits(test_case)
            imview(-3:10, GrayLimits = "datarange", Parent = test_case.Axes);

            test_case.verifyEqual(test_case.Axes.CLim, [-3 10]);
        end

        function equalGrayLimits(test_case)
            f = @() imview([1 1 1], GrayLimits = [1 1], Parent = test_case.Axes);

            % Just make sure it didn't error.
            test_case.verifyTrue(true);
        end

        function grayLimitsErrorCases(test_case)
            verifyError(test_case,@() imview(1, GrayLimits = [1 2 3]), ...
                "imview:InvalidGrayLimits")

            verifyError(test_case,@() imview(1, GrayLimits = [1 Inf]), ...
                "imview:InvalidGrayLimits")

            verifyError(test_case,@() imview(1, GrayLimits = [2 1]), ...
                "imview:InvalidGrayLimits");

            verifyError(test_case,@() imview(1, GrayLimits = "bogus"), ...
                "imview:InvalidGrayLimits");

            verifyError(test_case,@() imview(1, GrayLimits = {}), ...
                "imview:InvalidGrayLimits")
        end
    end
end