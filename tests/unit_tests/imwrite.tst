// <-- CLI SHELL MODE -->
scicv_Init();

img = imread("Data/images/lena.jpg");

res = imwrite(fullfile(TMPDIR, "lena_imwrite.jpg"), img);
assert_checktrue(res);
