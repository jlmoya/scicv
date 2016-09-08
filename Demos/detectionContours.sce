img=imread('../Data/images/sudoku.jpg',CV_LOAD_IMAGE_GRAYSCALE);
mat_img=cvMatExtract(img);

out=Laplacian(img,CV_16U, 3, 1, 0, BORDER_DEFAULT);
out=convertScaleAbs(out)
mat=cvMatExtract(out);

sobelx = Sobel(img,CV_16S,1,0,ksize=3);
sobelx=convertScaleAbs(sobelx)
mat_sobelx=cvMatExtract(sobelx);

sobely = Sobel(img,CV_16S,0,1,ksize=3);
sobely=convertScaleAbs(sobely)
mat_sobely=cvMatExtract(sobely);

subplot(2,2,1)
title('image originale')
matplot(mat_img)


subplot(2,2,2)
title('Laplacien')
matplot(mat)

subplot(2,2,3)
title('sobel_x')
matplot(mat_sobelx)

subplot(2,2,4)
title('sobel_y')
matplot(mat_sobely)
