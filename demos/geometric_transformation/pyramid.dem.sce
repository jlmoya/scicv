// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("pyramid.dem.sce");

img = imread(getSampleImage("lena.jpg"));

// Pyramid down
img_down = pyrDown(img, size(img) / 2);

// Pyramid up
img_up = pyrUp(img, size(img) * 2);

subplot(131);
matplot(img);
title("image");

subplot(132);
matplot(img_up);
title("pyramid up");

subplot(133);
matplot(img_down);
title("pyramid down");

delete_Mat(img);
delete_Mat(img_down);
delete_Mat(img_up);
