// <-- CLI SHELL MODE -->
exec(get_absolute_file_path("img_proc.tst") + "/../test_utils.sci");

img_name = "Puffin.png";

check_img_proc(img_name, "color", "cvtColor", COLOR_BGR2GRAY);

structuring_element = getStructuringElement(MORPH_RECT, [5 5]);
check_img_proc(img_name, "gray", "dilate", structuring_element);
check_img_proc(img_name, "gray", "erode", structuring_element);

blur_kernel = ones(5,5) / 25;
check_img_proc(img_name, "", "filter2D", -1, blur_kernel);
kernel = ones(3, 3);
check_img_proc(img_name, "", "morphologyEx", MORPH_OPEN, ones(3, 3));

check_img_proc(img_name, "", "blur", [3, 3]);
check_img_proc(img_name, "", "medianBlur", 3);

check_img_proc(img_name, "gray", "Canny", 50, 100);


