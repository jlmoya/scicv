scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("morphological_filtering.dem.sce");

img = imread(getSampleImage("noise.png"));
[res, img_bw] = threshold(img, 127, 255, THRESH_BINARY_INV);

morph_size = 2;
element = getStructuringElement(MORPH_RECT, [2*morph_size + 1, 2*morph_size+1], [morph_size, morph_size]);

img_dilate = dilate(img_bw, element);

img_erode = erode(img_bw, element);

img_open = morphologyEx(img_bw, MORPH_OPEN, element);

subplot(221);
matplot(img);
title("image");

subplot(222);
img_dilate_reverse = bitwise_not(img_dilate);
matplot(img_dilate_reverse);
title("dilate");

subplot(223);
img_erode_reverse = bitwise_not(img_erode);
matplot(img_erode_reverse);
title("erode");

subplot(224);
img_open_reverse = bitwise_not(img_open);
matplot(img_open_reverse);
title("open");

delete_Mat(img);
delete_Mat(img_bw);
delete_Mat(element);
delete_Mat(img_dilate);
delete_Mat(img_dilate_reverse);
delete_Mat(img_erode);
delete_Mat(img_erode_reverse);
delete_Mat(img_open);
delete_Mat(img_open_reverse);

