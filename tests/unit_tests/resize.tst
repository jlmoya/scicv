// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// <-- CLI SHELL MODE -->

exec(fullfile(get_scicv_path(), "tests", "test_utils.sci"));

function check_size(img)
    assert_checkequal(size(img_out), [expected_w, expected_h]);
endfunction

expected_w = 100;
expected_h = 100;
check_img_proc("lena.jpg", "resize", [100, 100], check_size);

expected_w = 90;
expected_h = 90;
check_img_proc("lena.jpg", "resize", 0, 0.4 , 0.4, check_size);

