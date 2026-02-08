function grp = findZoomLevelDisplay(im)
    imview_id = getappdata(im, "imview_id");
    ax = ancestor(im, "axes");
    gg = findobj(ax, "type", "text", "Tag", "imview");
    grp = [];
    for k = 1:length(gg)
        gg_k = gg(k);
        if (getappdata(gg_k, "imview_id") == imview_id)
            grp = gg_k;
            break
        end
    end
end

% Copyright 2025-2026 Steven L. Eddins