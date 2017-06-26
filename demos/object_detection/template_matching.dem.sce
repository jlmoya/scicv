// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("template_matching.dem.sce");

img = imread(getSampleImage("puffins.png"));
img_template = imread(getSampleImage("puffin_pattern.png"));

match_method = CV_TM_SQDIFF;
img_match = matchTemplate(img, img_template, match_method);
img_match = normalize(img_match, 0, 1, NORM_MINMAX, -1);

green = [0, 255, 0];
delta = 5;

while %t
    [min_match_value, max_match_value, min_match_pt, max_match_pt] = minMaxLoc(img_match);
    if (match_method == CV_TM_SQDIFF | match_method == CV_TM_SQDIFF_NORMED)
        match_ok = min_match_value < 0.20;
        match_pt = min_match_pt;
        erase_value = 1.0;
    else
        match_ok = max_match_value > 0.85;
        match_pt = max_match_pt;
        erase_value = 0.0;
    end

    if match_ok then
        match_pt = match_pt - delta;
        match_pt2 = match_pt + [size(img_template, "c"), size(img_template, "r")] + delta;
        rectangle(img, match_pt, match_pt2, green, 2, 8, 0);
        rectangle(img_match, match_pt - 10, match_pt2, erase_value, -1);
    else
        break
    end
end

matplot(img);
title("Template matching");

delete_Mat(img);
delete_Mat(img_match);
delete_Mat(img_template);
