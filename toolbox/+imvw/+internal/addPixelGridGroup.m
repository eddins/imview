function grp = addPixelGridGroup(ax, im, imview_id)
    [xv,yv] = imvw.internal.pixelGridVertices(size(im.CData),...
        im.XData, im.YData);
    grp = imvw.internal.pixelGridGroup(ax, xv, yv);
    grp.Tag = "imview";
    setappdata(grp, "imview_id", imview_id);
end

% Copyright 2025-2026 Steven L. Eddins