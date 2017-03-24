// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

// <-- CLI SHELL MODE -->

exec(fullfile(get_scicv_path(), "tests", "test_utils.sci"));

check_img_proc("puffin.png", "cvtColor", "color", COLOR_BGR2GRAY);
