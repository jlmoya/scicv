// Scilab Computer Vision Module
// Copyright (C) 2020 - Scilab Enterprises

// <-- CLI SHELL MODE -->

scicv_Init();

function check_img(img, expected_rows, expected_cols, expected_channels, varargin)
    assert_checkequal(typeof(img), "Mat");
    assert_checkfalse(Mat_empty(img));
    assert_checkequal(Mat_cols_get(img), expected_cols);
    assert_checkequal(Mat_rows_get(img), expected_rows);
    assert_checkequal(Mat_channels(img), expected_channels);
    if size(varargin) > 0 then
        expected_value = varargin(1);
        expected_data = ones(1,expected_rows*expected_cols*expected_channels)*expected_value;
        assert_checkequal(double(img(:,:)), matrix(expected_data, [expected_rows, expected_cols, expected_channels]));
        delete_Mat(img);
    end
endfunction

rows = 10;
cols = 15;
imageType = CV_8UC3;
channels = 3;
val = 100;
s = [val, val, val];

check_img(new_Mat(rows, cols, imageType), rows, cols, channels);

check_img(new_Mat([rows, cols], imageType), rows, cols, channels);

check_img(new_Mat(rows, cols, imageType, s), rows, cols, channels, val);

// TODO fix
//check_img(new_Mat([rows, cols], imageType, s), rows, cols, channels, val);
