// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("thresholding.dem.sce");

img = imread(getSampleImage("puffin.png"), CV_LOAD_IMAGE_GRAYSCALE);
[res, img_threshold] = threshold(img, 125, 255, THRESH_BINARY);

subplot(1,2,1);
matplot(img);
title("image");

subplot(1,2,2);
matplot(img_threshold);
title("binary image");

delete_Mat(img);
delete_Mat(img_threshold);
