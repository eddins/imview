function tf = liveEditorRunning
    % This function relies on internal, undocumented architecture of the
    % MATLAB Editor. Its behavior may change, or stop working completely,
    % in a future release.
    
    tf = feature("LiveEditorRunning");
end

% Copyright 2025 Steven L. Eddins