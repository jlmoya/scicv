// <-- CLI SHELL MODE -->
scicv_Init();
img=imread('Data/images/Puffin.png',CV_LOAD_IMAGE_GRAYSCALE);
assert_checkequal(Mat_channels(img),1);

[res,out]=threshold(img,50,20,THRESH_BINARY);

rows_img=Mat_rows_get(img);
rows_out=Mat_rows_get(out);
assert_checkequal(rows_img,rows_out);
