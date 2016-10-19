// <-- CLI SHELL MODE -->
scicv_Init();

img = imread('data/images/Puffin.png', CV_LOAD_IMAGE_GRAYSCALE);
//morphological opening (remove small objects from the foreground)
out = erode(img,);

rows_img = Mat_rows_get(img);
rows_out = Mat_rows_get(out);
assert_checkequal(rows_img,rows_out);


