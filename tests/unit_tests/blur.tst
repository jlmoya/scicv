// <-- CLI SHELL MODE -->
scicv_Init();

img = imread("data/images/Puffin.png");

img_out = blur(img, [3, 3]);
assert_checkfalse(Mat_empty(img_out));

Mat_release(img_out);
Mat_release(img);
