img=imread('Data/images/Puffin.png',CV_LOAD_IMAGE_GRAYSCALE);
[res,out]=threshold(img,50,255,THRESH_BINARY);
mat=cvMatExtract(out);
matplot(mat)
title('threshold_THRESH_BINARY')


