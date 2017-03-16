function ret = %Mat_p(mat)
    if ~Mat_empty(mat)
        disp(sprintf("%s [%d, %d]", ..
            getImageType(mat), Mat_cols_get(mat), Mat_rows_get(mat)));
    else
        disp([]);
    end
endfunction
