// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("contour_extraction.dem.sce");

img = imread(getSampleImage("shapes.png"));

img_gray = cvtColor(img, COLOR_BGR2GRAY);
[ret, img_bw] = threshold(img_gray, 25, 255, 0);

thresh = 90;
img_canny = Canny(img_bw, thresh, thresh*2, 3);

contours = findContours(img_canny, CV_RETR_LIST, CV_CHAIN_APPROX_NONE, [0, 0]);

subplot(1, 3, 1);
matplot(img);
title("image");

subplot(1, 3, 2);
matplot(img_canny);
title("canny");

subplot(1, 3, 3);
img_contours = new_Mat(size(img, 'c'), size(img, 'r'), CV_8UC1, 0);
img_contours_out = drawContours(img_contours, contours, -1, [255, 0, 0], -1);
matplot(img_contours_out);
title("contours");

delete_Mat(img);
delete_Mat(img_gray);
delete_Mat(img_bw);
delete_Mat(img_canny);
//delete_Mat(img_contours_bmp);
delete_Mat(img_contours);
//delete_Mat(img_contours_out);
