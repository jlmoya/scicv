img=imread('Data/images/lena.jpg');
blur_lena=medianBlur(img,5);
mat=cvMatExtract(blur_lena)
matplot(mat)
title('median blur')   

