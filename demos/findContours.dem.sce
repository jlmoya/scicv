img = imread("data/images/shapes.png");
nb_rows = Mat_rows_get(img);

img_gray = cvtColor(img, COLOR_BGR2GRAY);

thresh = 100;
canny_img = Canny(img_gray, thresh, thresh*2, 3);

[img_contours, contours] = findContours(canny_img, CV_RETR_LIST, CV_CHAIN_APPROX_NONE, [0, 0]);

scf(10001);

subplot(2, 2, 1);
xtitle("image");

matplot(cvMatExtract(img));

subplot(2, 2, 2);
xtitle("canny");

matplot(cvMatExtract(canny_img));

subplot(2, 2, 3);
xtitle("contour image");

matplot(cvMatExtract(img_contours));

subplot(2, 2, 4);
xtitle("contours");

plot2d([], []);
for i=1:size(contours)
  contour = contours(i);
  xpoly(contour(1,:), nb_rows-contour(2,:), "lines");
  e = gce();
  set(e,"foreground", i);
  set(e,"closed", "off");
end

