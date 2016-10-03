// <-- CLI SHELL MODE -->
scicv_Init();

img = imread("data/images/lena.jpg");

assert_checkequal(typeof(img), "Mat");

assert_checkfalse(Mat_empty(img));
assert_checkequal(Mat_rows_get(img), 225);
assert_checkequal(Mat_cols_get(img), 225);
