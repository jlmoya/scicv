// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// <-- CLI SHELL MODE -->
scicv_Init();

img = imread(getSampleImage("puffin.png"));

// Translation (20,20)
translate_mat = [1 0 20; ..
        0 1 20];
img_translate = warpAffine(img, translate_mat, size(img));

assert_checkfalse(Mat_empty(img));

delete_Mat(img);
delete_Mat(img_translate);