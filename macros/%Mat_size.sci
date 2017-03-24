// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

function ret = %Mat_size(mat, varargin)
    select argn(2)
    case 1 then
        ret = [Mat_rows_get(mat), Mat_cols_get(mat)];
    case 2 then 
        arg = varargin(1);
        if arg == "*" then
            ret = Mat_rows_get(mat) * Mat_cols_get(mat);
        elseif arg == "r" then
            ret = Mat_rows_get(mat);
        elseif arg == "c" then
            ret = Mat_cols_get(mat);
        else
            error(msprintf(_("%s: Wrong value for input argument #d: ''r'', ''c'' or ''*'' expected."), 2, "size"));
        end
    else
        error(msprintf(_("%s: Wrong number of input argument(s): 1 to 2 expected."), "size"));
    end
endfunction
