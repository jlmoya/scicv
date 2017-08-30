// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// <-- CLI SHELL MODE -->

scicv_Init();

img_gray = imread(getSampleImage("shapes.png"), CV_LOAD_IMAGE_GRAYSCALE);

thresh = 100;
img_canny = Canny(img_gray, thresh, thresh*2, 3);

lines = HoughLinesP(img_canny, 1, %pi/180, 30, 10);

assert_checkequal(size(lines), [4, 41]);

delete_Mat(img_gray);
delete_Mat(img_canny);

