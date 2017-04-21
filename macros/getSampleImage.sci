// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

function img_path = getSampleImage(img_name)
    img_path = fullfile(get_scicv_path(), "data/images", img_name);
endfunction
