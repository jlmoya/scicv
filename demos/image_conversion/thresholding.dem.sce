scicv_Init();

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
