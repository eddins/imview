function s = findEmbeddedImageAndAncestors(im)
    s.im = matlab.graphics.GraphicsPlaceholder.empty;
    s.ax = matlab.graphics.GraphicsPlaceholder.empty;
    s.fig = matlab.graphics.GraphicsPlaceholder.empty;

    if ~imvw.internal.liveEditorRunning
        return
    end

    ax = ancestor(im,"axes");
    fig = ancestor(ax,"figure");
    editor_id = fig.EDITOR_APPDATA.EDITOR_ID;
    out = findall(groot, "type", "figure", ...
        "Tag", "EmbeddedFigure_Internal", ...
        "editorID", editor_id);

    % Speculative guess: if out has more than element, meaning that there
    % appears to be more than one matching embedded figure, the active one
    % is the first in the list.
    if numel(out) > 1
        out = out(1);
    end

    if ~isempty(out)
        s.fig = out;
    else
        return
    end

    s.ax = s.fig.Children(fig.Children == ax);
    s.im = s.ax.Children(ax.Children == im);
end