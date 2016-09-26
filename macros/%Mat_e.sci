function ret = %Mat_e(coords, mat)
    if size(coords) == [-1, -1]
        ret = cvMatExtract(mat);
    else
        ret = [];
    end
endfunction
