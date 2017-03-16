 // <-- CLI SHELL MODE -->
scicv_Init();

function check_img(img, expected_cols, expected_rows, expected_channels)
    assert_checkequal(typeof(img), "Mat");
    assert_checkfalse(Mat_empty(img));
    assert_checkequal(Mat_cols_get(img), expected_cols);
    assert_checkequal(Mat_rows_get(img), expected_rows);
    assert_checkequal(Mat_channels_get(img), expected_channels);
endfunction

img = new_Mat(2, 4);
check_img(img, 2, 4, 3);
delete_Mat(img);

img = new_Mat(2, 4, CV_8UC3);
check_img(img, 2, 4, 3);
delete_Mat(img);

img = new_Mat(2, 4, CV_8UC1);
check_img(img, 2, 4, 1);
delete_Mat(img);
