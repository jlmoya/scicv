// <-- CLI SHELL MODE -->
scicv_Init();

img=imread('data/images/lena.jpg');

// Create a structuring element (SE)
morph_size = 2;
element= getStructuringElement( MORPH_RECT, [2*morph_size + 1, 2*morph_size+1 ], [morph_size, morph_size ]);
assert_checkfalse(Mat_empty(element));
// Apply the specified morphology operation
out=morphologyEx( img, MORPH_TOPHAT, element);

rows_img = Mat_rows_get(img);
rows_out = Mat_rows_get(out);
assert_checkequal(rows_img, rows_out);
assert_checkfalse(Mat_empty(out));

Mat_release(element);
Mat_release(out);
Mat_release(img);

