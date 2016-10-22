scicv_Init();

img = imread('data/images/puffin.png',CV_LOAD_IMAGE_GRAYSCALE);
img_canny = Canny(img, 100, 150);

matplot(img_canny);
title('canny');
