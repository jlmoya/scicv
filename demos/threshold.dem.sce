scicv_Init();

img = imread("data/images/puffin.png", CV_LOAD_IMAGE_GRAYSCALE);
[res, img_threshold] = threshold(img, 100, 255, THRESH_BINARY);

matplot(img_threshold);
title('binary thresholding');

delete_Mat(img);
