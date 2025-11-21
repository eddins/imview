function grp = addPixelGridGroup(ax,im)
    [xv,yv] = imvw.internal.pixelGridVertices(size(im.CData),...
        im.XData,im.YData);
    grp = imvw.internal.pixelGridGroup(ax,xv,yv);
    setappdata(im,"imview_pixel_grid",grp);

    % Delete the pixel grid group when the image object gets deleted.
    addlistener(im, "ObjectBeingDestroyed", @(~,~) delete(grp));
end