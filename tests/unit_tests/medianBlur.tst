// <-- CLI SHELL MODE -->
scicv_Init();

img = imread("data/images/lena.jpg");

img_out = medianBlur(img, 3);

assert_checkfalse(Mat_empty(img_out));

Mat_release(img_out);
Mat_release(img);

