// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("blur.dem.sce");

img = imread(getSampleImage("lena.jpg"));

img_blur = blur(img, [5 5]);

img_median_blur = medianBlur(img, 3);

img_gaussian_blur = GaussianBlur(img, [5 5], 2.0);

subplot(221);
matplot(img);
title("image");

subplot(222);
matplot(img_blur);
title("blur");

subplot(223);
matplot(img_median_blur);
title("median blur");

subplot(224);
matplot(img_gaussian_blur);
title("gaussian blur");

delete_Mat(img);
delete_Mat(img_blur);
delete_Mat(img_median_blur);
delete_Mat(img_gaussian_blur);
