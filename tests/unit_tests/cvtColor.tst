scicv_Init();

img = imread('data/images/Puffin.png');

assert_checkfalse(Mat_empty(img));

img_gray = cvtColor(img, COLOR_BGR2GRAY);

assert_checkfalse(Mat_empty(img_gray));
