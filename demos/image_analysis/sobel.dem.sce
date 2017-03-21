scicv_Init();

img = imread(getSampleImage("sudoku.jpg"), CV_LOAD_IMAGE_GRAYSCALE);

img_laplacian = Laplacian(img, CV_16U, 3, 1, 0, BORDER_DEFAULT);
img_laplacian_abs = convertScaleAbs(img_laplacian);

img_sobel_x = Sobel(img, CV_16S, 1, 0, 3);
img_sobel_x_abs = convertScaleAbs(img_sobel_x);

img_sobel_y = Sobel(img, CV_16S, 0, 1, 3);
img_sobel_y_abs = convertScaleAbs(img_sobel_y);

subplot(2,2,1);
matplot(img);
title("image");

subplot(2,2,2);
matplot(img_laplacian_abs);
title("laplacian");

subplot(2,2,3);
matplot(img_sobel_x_abs);
title("sobel x");

subplot(2,2,4);
matplot(img_sobel_y_abs);
title("sobel y");
