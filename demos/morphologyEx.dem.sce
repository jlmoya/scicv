scicv_Init();

img = imread(getSampleImage("lena.jpg"));

// Create a structuring element (SE)
morph_size = 2;
element = getStructuringElement( MORPH_RECT, [2*morph_size + 1, 2*morph_size+1 ], [morph_size, morph_size ]);

// Apply the specified morphology operation
img_tophat = morphologyEx( img, MORPH_TOPHAT, element);

subplot(121);
matplot(img);
title('image');

subplot(122);
matplot(img_tophat);
title("top hat filter");

Mat_release(element);
Mat_release(img);
Mat_release(img_tophat);
