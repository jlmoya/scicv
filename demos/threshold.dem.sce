scicv_Init();

img = imread("data/images/Puffin.png", CV_LOAD_IMAGE_GRAYSCALE);
[res, img_threshold] = threshold(img, 50, 255, THRESH_BINARY);

matplot(img_threshold);
title('binary thresholding');
