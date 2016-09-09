img= imread("data/images/lena.jpg");
mat_img=cvMatExtract(img);
// Pyramid down
down=pyrDown(img,[(Mat_cols_get(img))/2  (Mat_rows_get(img))/2]);
mat_down=cvMatExtract(down);
//pyramid up
up=pyrUp(img, [(Mat_cols_get(img))*2  (Mat_rows_get(img))*2]);
mat_up=cvMatExtract(up);
subplot(131)
title('image originale')
matplot(mat_img)

subplot(132)
title('pyramid_Up')
matplot(mat_up)

subplot(133)
title('pyramid_Down')
matplot(mat_down)
