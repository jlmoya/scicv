// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

function check_not_empty(img)
    assert_checkfalse(Mat_empty(img));
endfunction

function check_img_proc(img_name, img_proc_func, varargin)
    img_path = getSampleImage(img_name);

    load_mode = [];
    check_func = check_not_empty;

    func_args = list();
    for i=1:size(varargin)
        arg = varargin(i);
        if (typeof(arg) == "string") & (arg == "color" | arg == "gray") then
            load_mode = arg;
        elseif typeof(arg) == "function" then
            check_func = arg;
        else
            func_args($+1) = varargin(i);
        end
    end

    // load image, depending on load mode optional argument
    if load_mode == "color" then
        img_in = imread(img_path, CV_LOAD_IMAGE_COLOR);
    elseif load_mode == "gray" then
        img_in = imread(img_path, CV_LOAD_IMAGE_GRAYSCALE);
    else
        img_in = imread(img_path);
    end

    if ~Mat_empty(img_in)
        execstr(msprintf("img_out = %s(img_in, func_args(:));", img_proc_func));
        delete_Mat(img_in);
    else
        delete_Mat(img_in);
        error(msprintf("Error loading image %s", img_name));
    end

    check_func(img_out);
    delete_Mat(img_out);
endfunction

