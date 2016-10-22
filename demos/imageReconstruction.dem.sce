scicv_Init();

img = imread('data/images/OpenCV_Logo_B.png');

img_mask = imread('data/images/OpenCV_Logo_C.png',CV_LOAD_IMAGE_GRAYSCALE); // must be one channal image

img_TELEA = inpaint(img, img_mask, 3, INPAINT_TELEA); // image reconstruction  (first algorithm)

img_NS = inpaint(img, img_mask, 3, INPAINT_NS); // image reconstruction  (second algorithm)

img_mask_gray = cvtColor(img_mask, CV_GRAY2BGR);

merged_frame = new_Mat(504, 572, CV_8UC1);

rect_1 = [0,0,286,252]; // image with noise
rect_2 = [286,0,286,252]; //  mask
rect_3 = [0,252,286,252]; // INPAINT_TELEA reconstruction
rect_4 = [286,252,286,252]; // INPAINT_NS reconstruction

roi_1 = new_Mat(merged_frame, rect_1);
roi_1 = Mat_copyTo(img);

roi_2 = new_Mat(merged_frame, rect_2);
roi_2 = Mat_copyTo(img_mask);

roi_3 = new_Mat(merged_frame, rect_3);
roi_3 = Mat_copyTo(img_TELEA );

roi_4 = new_Mat(merged_frame, rect_4);
roi_4 = Mat_copyTo(img_NS );

subplot(221);
title('image with noise');
matplot(img);

subplot(222);
title('mask');
matplot(img_mask);

subplot(223);
title('TELEA reconstruction algorithm');
matplot(img_TELEA);

subplot(224);
title('NS reconstruction algorithm');
matplot(img_NS);

delete_Mat(img);
delete_Mat(img_mask);
delete_Mat(img_TELEA);
delete_Mat(img_NS);
delete_Mat(merged_frame);
delete_Mat(img_mask_gray);

