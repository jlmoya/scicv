//http://docs.opencv.org/3.1.0/d3/db4/tutorial_py_watershed.html
//http://stackoverflow.com/questions/11435974/watershed-segmentation-opencv-xcode

scicv_Init();

img = imread(getSampleImage("water_coins.jpg"));

// convert to black&white
img_gray = imread(getSampleImage("water_coins.jpg"), CV_LOAD_IMAGE_GRAYSCALE);
[res, img_bw] = threshold(img_gray, 0, 255, THRESH_BINARY_INV+THRESH_OTSU);

// Remove noise and small objects with opening
img_open = morphologyEx(img_bw, MORPH_OPEN, ones(3, 3), [-1, -1], 2);

// sure background area
img_sure_bg = dilate(img_open, ones(3, 3), [-1,-1], 3);

// sure foreground area
[img_dist, labels] = distanceTransform(img_open, CV_DIST_L2, 5);
mat_dist = img_dist(:)
max_dist = max(mat_dist);
[res, img_sure_fg] = threshold(img_dist, 0.7*max_dist, 255, 0);

// finding unknown area
mat_sure_fg = uint8(img_sure_fg(:));
mat_sure_bg = uint8(img_sure_bg(:));
mat_unknown = mat_sure_bg - mat_sure_fg;

img_sure_fg_uint8 = Mat_convertTo(img_sure_fg, CV_8UC1);

// markers
[img_markers, marker_contours] = findContours(img_sure_fg_uint8, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE, [0, 0]);

mat_markers = cvMatExtract(img_markers);
mat_markers = mat_markers + 1;
mat_markers(find(mat_unknown == 255)) = 0;

img_markers_watershed = watershed(img, int32(mat_markers));

scf();

subplot(4,2,1);
title("original image");
matplot(img);

subplot(4,2,2);
title("image bw");
matplot(img_bw);

subplot(4,2,3);
title("opening");
matplot(img_open);

subplot(4,2,4); 
title("dilate");
matplot(img_sure_bg);

subplot(4,2,5); 
title("distance transform");
matplot(img_dist);

subplot(4,2,6);
title("distance transform threshold");
matplot(img_sure_fg);

subplot(4,2,7);
title("markers image after watershed");
matplot(img_markers_watershed);

delete_Mat(img);
delete_Mat(img_bw);
delete_Mat(img_open);
delete_Mat(img_sure_bg);
delete_Mat(img_sure_fg);
delete_Mat(img_dist);
delete_Mat(img_markers_watershed);

