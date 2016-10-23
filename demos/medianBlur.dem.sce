scicv_Init();

img = imread(getSampleImage("lena.jpg"));
img_blur = medianBlur(img, 5);

matplot(img_blur);
title("median blur");

delete_Mat(img);
delete_Mat(img_blur);
