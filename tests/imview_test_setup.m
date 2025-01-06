classdef imview_test_setup < matlab.unittest.TestCase
    properties
        Figure
        Axes
    end

    methods (TestMethodSetup)
        function methodSetup(test_case)
            test_case.Figure = figure();
            test_case.Axes = axes(Parent = test_case.Figure);
            addTeardown(test_case, @() test_case.Figure.delete())
        end
    end
end