image=imread('Data/images/lena.jpg',CV_LOAD_IMAGE_GRAYSCALE);
mat=cvMatExtract(image);
A=zeros(Mat_rows_get(image),Mat_cols_get(image));

for i=1:225
    for j=1:225
        A(i,j)=mat(i,j);
    end
end

subplot(121)
title('gray_image')
matplot(mat)

subplot(122)
title('histogram')
histplot(255,A)
