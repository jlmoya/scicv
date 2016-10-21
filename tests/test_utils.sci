scicv_Init();

function img_out = img_proc(img_name, load_mode, img_proc_func, varargin)
    img_path = getSampleImage(img_name);
    if load_mode == "color"
        img_in = imread(img_path, CV_LOAD_IMAGE_COLOR);
    elseif load_mode == "gray"
        img_in = imread(img_path, CV_LOAD_IMAGE_GRAYSCALE);
    else
        img_in = imread(img_path);
    end

    if ~Mat_empty(img_in)
        execstr(msprintf("img_out = %s(img_in, varargin(:));", img_proc_func));
		Mat_release(img_in);
    else
        Mat_release(img_in);
		error(msprintf("Error loading image %s", img_name));
    end
endfunction

function check_img_proc(img_name, load_mode, img_proc_func, varargin)
    img_out = img_proc(img_name, load_mode, img_proc_func, varargin(:));
    assert_checkfalse(Mat_empty(img_out));	
endfunction
