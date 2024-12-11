classdef imview_test < matlab.unittest.TestCase

    methods (Test)
        % Test methods

        function outputType(test_case)
            [im,~,~] = callImview(1,test_case);
            
            test_case.verifyClass(im,"matlab.graphics.primitive.Image");
        end


        function someAxesProperties(test_case)
            [~,ax,~] = callImview(magic(3),test_case);

            test_case.verifyEqual(ax.DataAspectRatio,[1 1 1]);
            test_case.verifyEqual(ax.YDir,'reverse');
            test_case.verifyEqual(ax.XLimitMethod,'tight');
            test_case.verifyEqual(ax.YLimitMethod,'tight');
            test_case.verifyEqual(ax.Visible,matlab.lang.OnOffSwitchState("off"));
        end

        function logicalImage(test_case)
            [~,ax,~] = callImview(logical([0 1 0; 1 0 1; 0 1 0]),test_case);

            test_case.verifyEqual(ax.CLim,[0 1]);
        end

        function uint8GrayImage(test_case)
            [~,ax,~] = callImview(uint8([0 1 0; 1 0 1; 0 1 0]),test_case);

            test_case.verifyEqual(ax.CLim,[0 255]);
        end

        function uint16GrayImage(test_case)
            [~,ax,~] = callImview(uint16(1),test_case);

            test_case.verifyEqual(ax.CLim,[0 65535]);
        end

        function singleGrayImage(test_case)
            [~,ax,~] = callImview(single(1),test_case);

            test_case.verifyEqual(ax.CLim,[0 1]);
        end

        function doubleGrayImage(test_case)
            [~,ax,~] = callImview(1,test_case);

            test_case.verifyEqual(ax.CLim,[0 1]);
        end

        function rgbImage(test_case)
            [im,~,~] = callImview(reshape([1 1 1],[1 1 3]),test_case);

            test_case.verifySize(im.CData,[1 1 3]);
        end     
    end

end

function [im,ax,fig] = callImview(A,test_case)
    im = imview(A);
    addTeardown(test_case,@() closeParentFigure(im));
    ax = ancestor(im,"axes");
    fig = ancestor(im,"figure");
end

function closeParentFigure(im)
    close(ancestor(im,"figure"));
end

function out = onePixelRGB
    out = reshape([1 1 1],[1 1 3]);
end