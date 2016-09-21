//http://docs.opencv.org/3.1.0/d3/db4/tutorial_py_watershed.html
//http://stackoverflow.com/questions/11435974/watershed-segmentation-opencv-xcode

scicv_Init();

img = imread('data/images/water_coins.jpg');

// convert to black/white
img_gray = imread('data/images/water_coins.jpg', CV_LOAD_IMAGE_GRAYSCALE);
[res, img_bw] = threshold(img_gray, 0, 255, THRESH_BINARY_INV+THRESH_OTSU);

// Remove noise and small objects with opening
img_open = morphologyEx(img_bw, MORPH_OPEN, ones(3, 3), [-1, -1], 2);

// sure bacckground area
img_sure_bg = dilate(img_open, ones(3, 3), [-1,-1], 3);

// sure foreground area
[img_dist, labels] = distanceTransform(img_open, CV_DIST_L2, 5);
mat_dist = cvMatExtract(img_dist);
max_dist = max(mat_dist);
[res, img_sure_fg] = threshold(img_dist, 0.7*max_dist, 255, 0);

// finding unknown area
mat_sure_fg = uint8(cvMatExtract(img_sure_fg));
mat_sure_bg = uint8(cvMatExtract(img_sure_bg));
mat_unknown = mat_sure_bg - mat_sure_fg;

img_sure_fg_uint8 = Mat_convertTo(img_sure_fg, CV_8UC1);

// markers
[img_markers, marker_contours] = findContours(img_sure_fg_uint8, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE, [0, 0]);

mat_markers = cvMatExtract(img_markers);
mat_markers = mat_markers + 1;
mat_markers(find(mat_unknown == 255)) = 0;

img_markers = watershed(img, markers);

// display
mat_orig = cvMatExtract(image_Orig);

mat_gray = cvMatExtract(image);

mat_bw = cvMatExtract(img_bw);

markers = Mat_convertTo(markers, CV_32SC1, 1, 0);
markers = watershed(image_Orig);
markersMat_convertTo(markers, CV_32SC3, 1, 0);
mat_watershed = cvMatExtract(markers);

scf(1);
subplot(2,4,1);
title('original image');
matplot(mat_orig);

subplot(2,4,2);
title('gray image');
matplot(mat_Gray);

subplot(2,4,3);
title('thresholding OTSU');
matplot(mat_thresh);

subplot(2,4,4);
title('erode');
matplot(mat_erode);

subplot(2,4,5); // premiére colonne, deuxiémme ligne
title('dilate');
matplot(mat_dilate);

subplot(2,4,6); // premiére colonne, deuxiémme ligne, deuxiémme colonne
title('markers');
matplot(mat_markers);

subplot(2,4,7);
title('watershed');
matplot(mat_watershed);

