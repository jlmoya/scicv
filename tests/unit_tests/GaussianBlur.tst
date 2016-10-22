// <-- CLI SHELL MODE -->
exec(fullfile(get_scicv_path(), "tests", "test_utils.sci"));

check_img_proc("puffin.png", "color", "GaussianBlur", [5 5], 1.0);
