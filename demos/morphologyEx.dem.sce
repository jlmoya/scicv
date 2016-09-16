img=imread('../data/images/lena.jpg');

// Create a structuring element (SE)
morph_size = 2;
element= getStructuringElement( MORPH_RECT, [2*morph_size + 1, 2*morph_size+1 ], [morph_size, morph_size ]);

// Apply the specified morphology operation
out=morphologyEx( img, MORPH_TOPHAT, element);

mat=cvMatExtract(out);
mat_lena=cvMatExtract(img);
Mat_release(element);
Mat_release(out);
Mat_release(img);

subplot(121)
matplot(mat_lena)
title('initial image')

subplot(122)
matplot(mat)
title('morphologyEx tranformation')
