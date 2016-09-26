function ret = %Points_e(indexs, mat)
    if size(indexs) == [-1, -1]
        ret = cvGetPoints(mat);
    else
        ret = [];
    end
endfunction
