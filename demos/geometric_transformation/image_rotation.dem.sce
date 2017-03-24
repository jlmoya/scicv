scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("image_rotation.dem.sce");

img = imread(getSampleImage("puffin.png"));

// Rotation 15 degrees to the left
center_pt = size(img) * 0.5;
angle = 15;
rot_mat = getRotationMatrix2D(center_pt, angle, 1.0);
img_rotated = warpAffine(img, rot_mat, size(img));

subplot(1,2,1);
matplot(img);
title("image");

subplot(1,2,2);
matplot(img_rotated);
title("rotated image");

delete_Mat(img);
delete_Mat(img_rotated);