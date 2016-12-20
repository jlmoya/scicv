// <-- CLI SHELL MODE -->
exec(fullfile(get_scicv_path(), "tests", "test_utils.sci"));

img_out = check_img_proc("lena.jpg", "color", "resize", [100, 100]);
assert_checkequal(size(img_out), [100, 100]);

img_out = check_img_proc("lena.jpg", "color", "resize", 0, 0.4 , 0.4);
assert_checkequal(size(img_out), [90, 90]);
