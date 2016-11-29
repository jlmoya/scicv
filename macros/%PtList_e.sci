function ret = %PtList_e(indexs, pts)
    if size(indexs) == [-1, -1]
        ret = cvGetPtList(pts);
    else
        ret = [];
    end
endfunction
