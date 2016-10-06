function ret = %Points_e(indexs, pts)
    if size(indexs) == [-1, -1]
        ret = cvGetPoints(pts);
    else
        ret = [];
    end
endfunction
