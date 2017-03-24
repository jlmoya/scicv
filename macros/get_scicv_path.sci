// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

function scicv_path = get_scicv_path()
    [macros, toolbox_macros_path] = libraryinfo("scicvlib");
    scicv_path = fullpath(toolbox_macros_path + '/..');
endfunction
