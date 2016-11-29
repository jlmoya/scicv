scicv_Init();

img = imread(getSampleImage("shapes.png"));
nb_rows = Mat_rows_get(img);

img_gray = cvtColor(img, COLOR_BGR2GRAY);

thresh = 100;
img_canny = Canny(img_gray, thresh, thresh*2, 3);

[img_contours, contours] = findContours(img_canny, CV_RETR_LIST, CV_CHAIN_APPROX_NONE, [0, 0]);

subplot(2, 2, 1);
matplot(img);
title("image");

subplot(2, 2, 2);
matplot(img_canny);
title("canny");

subplot(2, 2, 3);
matplot(img_contours);
title("contour image");

subplot(2, 2, 4);
plot2d([], []);
a = gca();
a.axes_visible = "off";
for i=1:size(contours)
    contour = contours(i);
    xpoly(contour(1,:), nb_rows-contour(2,:), "lines");
    e = gce();
    set(e,"foreground", i);
    set(e,"closed", "off");
end
title("contours");

delete_Mat(img);
delete_Mat(img_gray);
delete_Mat(img_canny);
delete_Mat(img_contours);

