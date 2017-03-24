// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("sobel.dem.sce");

img = imread(getSampleImage("sudoku.jpg"), CV_LOAD_IMAGE_GRAYSCALE);

img_sobel_x = Sobel(img, CV_16S, 1, 0, 3);
img_sobel_x_abs = convertScaleAbs(img_sobel_x);

img_sobel_y = Sobel(img, CV_16S, 0, 1, 3);
img_sobel_y_abs = convertScaleAbs(img_sobel_y);

img_sobel_total = addWeighted(img_sobel_x_abs, 0.5, img_sobel_y_abs, 0.5, 0);

subplot(2,2,1);
matplot(img);
title("image");

subplot(2,2,2);
matplot(img_sobel_x_abs);
title("sobel x");

subplot(2,2,3);
matplot(img_sobel_y_abs);
title("sobel y");

subplot(2,2,4);
matplot(img_sobel_total);
title("sobel total");

delete_Mat(img);
delete_Mat(img_sobel_x);
delete_Mat(img_sobel_y);
delete_Mat(img_sobel_x_abs);
delete_Mat(img_sobel_y_abs);
delete_Mat(img_sobel_total);
