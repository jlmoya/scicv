scicv_Init();

img = imread('data/images/lena.jpg',CV_LOAD_IMAGE_GRAYSCALE);

mat = img(:);
A = zeros(Mat_rows_get(img), Mat_cols_get(img));
for i=1:225
    for j=1:225
        A(i,j) = mat(i,j);
    end
end

subplot(121);
matplot(img);
title('gray_image');

subplot(122);
histplot(255, A);
title('histogram');

delete_Mat(img);
