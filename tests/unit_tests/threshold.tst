// <-- CLI SHELL MODE -->
scicv_Init();

img=imread('Data/images/Puffin.png', CV_LOAD_IMAGE_GRAYSCALE);
assert_checkequal(Mat_channels(img),1);

[res,out]=threshold(img,127, 255, THRESH_BINARY);

assert_checkfalse(Mat_empty(out));
