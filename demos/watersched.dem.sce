image=imread('Data/images/water_coins.jpg',CV_LOAD_IMAGE_GRAYSCALE);
mat_Gray=cvMatExtract(image);

image_Orig=imread('Data/images/water_coins.jpg');
mat_orig=cvMatExtract(image_Orig);

[res,image]=threshold(image,0,255,THRESH_BINARY_INV+THRESH_OTSU);
mat_thresh=cvMatExtract(image);

fg=new_Mat();
fg=erode(image , new_Mat(), [-1,-1], 2); // Eliminate noise and smaller objects
mat_erode=cvMatExtract(fg);

bg=new_Mat();
bg=dilate(image, new_Mat(), [-1,-1], 3);
[res2, bg]=threshold(bg,1, 128,THRESH_BINARY_INV);
mat_dilate=cvMatExtract(bg);

markers=new_Mat(Mat_rows_get(image), Mat_cols_get(image), CV_8U);
add(fg, bg,markers); // markers = bg + fg (Calculates the per-element sum of two arrays )
mat_markers=cvMatExtract(markers);

markers=Mat_convertTo(markers, CV_32SC1,1,0);
markers=watershed(image_Orig);
markersMat_convertTo(markers, CV_32SC3,1,0);
mat_watershed=cvMatExtract(markers);

figure (1)
subplot(2,4,1)
title('original image')
matplot(mat_orig)

subplot(2,4,2)
title('gray image')
matplot(mat_Gray)

subplot(2,4,3)
title('thresholding OTSU')
matplot(mat_thresh)

subplot(2,4,4)
title('erode')
matplot(mat_erode)

subplot(2,4,5) // premiére colonne, deuxiémme ligne
title('dilate')
matplot(mat_dilate)

subplot(2,4,6) // premiére colonne, deuxiémme ligne, deuxiémme colonne
title('markers')
matplot(mat_markers)
   
subplot(2,4,7)
title('watershed')
matplot(mat_watershed)


//http://docs.opencv.org/3.1.0/d3/db4/tutorial_py_watershed.html 
//http://stackoverflow.com/questions/11435974/watershed-segmentation-opencv-xcode
