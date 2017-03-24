scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("canny.dem.sce");

img = imread(getSampleImage("puffin.png"), CV_LOAD_IMAGE_GRAYSCALE);
img_canny = Canny(img, 100, 160);

subplot(1,2,1);
matplot(img);
title("image");

subplot(1,2,2);
matplot(img_canny);
title("canny");

delete_Mat(img);
delete_Mat(img_canny);
