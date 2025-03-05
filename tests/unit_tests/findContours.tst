// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

// <-- CLI SHELL MODE -->

scicv_Init();

img_gray = imread(getSampleImage("shapes.png"), CV_LOAD_IMAGE_GRAYSCALE);

thresh = 100;
img_canny = Canny(img_gray, thresh, thresh*2, 3);

contours = findContours(img_canny, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, [0, 0]);
assert_checkequal(typeof(contours), "PtLists");

delete_Mat(img_gray);

