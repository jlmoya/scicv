// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

img = new_Mat(200, 200, CV_8UC1, 0);
pts = [50 150 150 50; 50 50 150 150];
fillPoly(img, pts, 128);
imwrite("/tmp/test1.jpg", img);
delete_Mat(img);

scicv_Init();

img = new_Mat(200, 200, CV_8UC1, 0);
pts = list([50 100 100 50; 50 50 100 100], [100 150 150; 150 100 150]);
fillPoly(img, pts, 128);
imwrite("/tmp/test2.jpg", img);
delete_Mat(img);
