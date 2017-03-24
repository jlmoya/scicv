// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

function value = refcount(mat)
    value = intp_value(Mat_refcount_get(mat));
endfunction
