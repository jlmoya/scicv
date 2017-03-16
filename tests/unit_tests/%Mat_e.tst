 // <-- CLI SHELL MODE -->
scicv_Init();

img = new_Mat(2, 3, CV_8UC3, [1, 128, 255]);
o = uint8(ones(2, 3));
mat = img(:,:);
assert_checkequal(mat(:,:,1), 255*o);
assert_checkequal(mat(:,:,2), 128*o);
assert_checkequal(mat(:,:,3), 1*o);
mat = img(:);
assert_checkequal(mat, repmat(uint8([255, 128, 1]), 6, 1));
delete_Mat(img);

img = new_Mat(2, 3, CV_8UC1, 128);
mat = img(:,:);
assert_checkequal(mat(:,:), uint8(ones(2,3)*128));
mat = img(:);
assert_checkequal(mat, uint8(ones(6, 1)*128));
delete_Mat(img);
