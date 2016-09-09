img=imread('data/images/Puffin.png',CV_LOAD_IMAGE_GRAYSCALE);
out=Canny(img,150,100);
mat=cvMatExtract(out)
matplot(mat)
title('canny')

