// <-- CLI SHELL MODE -->
scicv_Init();

img = imread('data/images/lena.jpg');

blur_kernel = ones(5,5) / 25;

img_out = filter2D(img, -1, blur_kernel);

assert_checkfalse(Mat_empty(img_out));

Mat_release(img_out);
Mat_release(img);
