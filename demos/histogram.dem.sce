scicv_Init();

img = imread(getSampleImage("lena.jpg"), CV_LOAD_IMAGE_GRAYSCALE);

A = img(:);

subplot(121);
matplot(img);
title('gray_image');

subplot(122);
histplot(255, A);
title('histogram');

delete_Mat(img);
