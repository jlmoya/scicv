// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("RGB_histograms.dem.sce");

img = imread(getSampleImage("lena.jpg"));

subplot(2, 2, 1);
matplot(img);
title("image");

// Histogram of the three RBG channels taken separately
// Note: OpenCV color channel order is reversed (BGR)
histB = calcHist(img, 0, [], 1, 32, [0 256]);
subplot(2, 2, 2);
bar(histB(:), 'blue');

histG = calcHist(img, 1, [], 1, 32, [0 256]);
subplot(2, 2, 3);
bar(histG(:), 'green');

histR = calcHist(img, 2, [], 1, 32, [0 256]);
subplot(2, 2, 4);
bar(histR(:), 'red');

delete_Mat(img);
delete_Mat(histB);
delete_Mat(histG);
delete_Mat(histR);
