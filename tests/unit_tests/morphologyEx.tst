// <-- CLI SHELL MODE -->
scicv_Init();

img = imread('data/images/noise.png', CV_LOAD_IMAGE_GRAYSCALE);

// noise removal with opening
kernel_mat = ones(3, 3);
img_out = morphologyEx(img, MORPH_OPEN, kernel_mat);

Mat_release(img_out);
Mat_release(img);
