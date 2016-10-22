scicv_Init();

img = imread(getSampleImage("puffin.png"), CV_LOAD_IMAGE_GRAYSCALE);
img_canny = Canny(img, 100, 150);

matplot(img_canny);
title('canny');

delete_Mat(img);
delete_Mat(img_canny);
