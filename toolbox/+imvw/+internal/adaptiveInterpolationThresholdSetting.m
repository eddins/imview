function threshold = adaptiveInterpolationThresholdSetting
    % Determine the current value of the imview.AdaptiveInterpolationThreshold setting.
    % Create the setting if it does not already exist.
    s = settings;
    if ~hasGroup(s,"imview")
        addGroup(s,"imview");
    end

    grp = s.imview;

    if ~grp.hasSetting("AdaptiveInterpolationThreshold")
        grp.addSetting("AdaptiveInterpolationThreshold", PersonalValue = 1/16);
    end

    threshold = grp.AdaptiveInterpolationThreshold.ActiveValue;
end

% Copyright 2026 Steven L. Eddins