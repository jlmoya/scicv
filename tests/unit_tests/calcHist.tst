// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// <-- CLI SHELL MODE -->

scicv_Init();

img = imread(getSampleImage("lena.jpg"));

mask = [];
hist_size = 32;
ranges = [0 255];

histB = calcHist(img, 0, mask, 1, hist_size, ranges);

assert_checkfalse(Mat_empty(histB));
assert_checkequal(size(histB), [hist_size, 1]);

histG = calcHist(img, 1, mask, 1, hist_size, ranges);

assert_checkfalse(Mat_empty(histG));
assert_checkequal(size(histG), [hist_size, 1]);

histR = calcHist(img, 2, mask, 1, hist_size, ranges);

assert_checkfalse(Mat_empty(histR));
assert_checkequal(size(histR), [hist_size, 1]);

delete_Mat(img);
delete_Mat(histB);
delete_Mat(histG);
delete_Mat(histR);
