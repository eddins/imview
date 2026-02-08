function threshold = pixelGridThresholdSetting
    % Determine the current value of the imview.PixelGridThreshold setting.
    % Create the setting if it does not already exist.
    s = settings;
    if ~hasGroup(s,"imview")
        addGroup(s,"imview");
    end

    grp = s.imview;

    if ~grp.hasSetting("PixelGridThreshold")
        grp.addSetting("PixelGridThreshold", PersonalValue = 3/8);
    end

    threshold = grp.PixelGridThreshold.ActiveValue;
end

% Copyright 2026 Steven L. Eddins