// <-- CLI SHELL MODE -->
exec(fullfile(get_scicv_path(), "tests", "test_utils.sci"));

element = getStructuringElement(MORPH_RECT, [5 5]);
check_img_proc("puffin.png", "gray", "dilate", element);

delete_Mat(element);
