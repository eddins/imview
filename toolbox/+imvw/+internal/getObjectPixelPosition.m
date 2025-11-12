function pos = getObjectPixelPosition(obj)
    root = groot;

    if (obj == root)
        pos = obj.ScreenSize;
        return
    end

    if (isa(obj, "matlab.graphics.axis.Axes") || ...
            isa(obj, "matlab.ui.control.UIAxes"))
        pos = tightPosition(obj);
    else
        pos = obj.Position;
    end

    switch obj.Units
        case "normalized"
            parent_pixel_position = imvw.internal.getObjectPixelPosition(obj.Parent);
            pos([1 3]) = pos([1 3]) * parent_pixel_position(3);
            pos([2 4]) = pos([2 4]) * parent_pixel_position(4);

        case "inches"
            pos = pos * root.ScreenPixelsPerInch;

        case "centimeters"
            pos = pos * root.ScreenPixelsPerInch / 2.54;
            
        case "characters"
            error("imzm:CharacterUnitsNotSupported",...
                "Character units not supported.")

        case "points"
            pos = pos * root.ScreenPixelsPerInch / 72;

        case "pixels"
            % Nothing to do here.

        otherwise
            error("imzm:UnknownUnits", ...
                "Unknown object units: ""%s""", obj.Units)
    end
end