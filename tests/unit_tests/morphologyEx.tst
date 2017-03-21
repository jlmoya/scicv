// <-- CLI SHELL MODE -->
exec(fullfile(get_scicv_path(), "tests", "test_utils.sci"));

check_img_proc("puffin.png", "morphologyEx", MORPH_OPEN, ones(3, 3));
