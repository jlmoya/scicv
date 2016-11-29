function matplot(img, varargin)
    // convert Mat type
    if typeof(img) == 'Mat' then
        I = uint8(img(:));
    else
        I = uint8(img);
    end
    // get handle argument
    h = [];
    if size(varargin) > 0 then
        if type(varargin(1)) == 9
            h = varargin(1);
        end
    end
    // Only update matplot data if handle provided, otherwise new Matplot
    if h <> [] then
        h.data = I;
    else
        Matplot(I, frameflag=4);
        a = gca();
        a.axes_visible = "off";
    end
endfunction
