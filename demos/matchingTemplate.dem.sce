scicv_Init();

img = imread(getSampleImage("puffins.png"));

img_template = imread(getSampleImage("puffin_pattern.png"));
img_display = Mat_clone(img);
result_cols = Mat_cols_get(img)-Mat_cols_get(img_template)+1;
result_rows = Mat_rows_get(img)-Mat_rows_get(img_template)+1;
result = new_Mat(result_rows, result_cols, CV_8UC3);

//match_method=[CV_TM_SQDIFF, CV_TM_SQDIFF_NORMED, CV_TM_CCOEFF, CV_TM_CCOEFF_NORMED, CV_TM_CCORR, CV_TM_CCORR_NORMED];
match_method = [4, 5, 1, 0, 2, 3];

s1 = [0, 255, 0];
s2 = [255, 0, 0];

for k=1:6
    result = matchTemplate(img_display, img_template, match_method(k));
    result = normalize(result, 0, 1, NORM_MINMAX, -1);
    pt_minLoc = new_Point();
    pt_maxLoc = new_Point();

    minVal = new_double_array(1);
    maxVal = new_double_array(1);

    minMaxLoc(result, minVal, maxVal, pt_minLoc, pt_maxLoc, new_Mat());
    pt_matchLoc = new_Point();
    if (match_method(k) == CV_TM_SQDIFF | match_method(k) == CV_TM_SQDIFF_NORMED)
        pt_matchLoc = pt_minLoc;
    else
        pt_matchLoc = pt_maxLoc;
    end

    point = [Point_x_get(pt_matchLoc) + Mat_cols_get(img_template), ..
      Point_y_get(pt_matchLoc) + Mat_rows_get(img_template)];

    // conversion to vector, needed for rectangle (does not accept Point* => TODO fix typemap)
    point_matchLoc = [Point_x_get(pt_matchLoc), Point_y_get(pt_matchLoc)];

    rectangle(img_display, point_matchLoc, point, s1, 2, 8, 0);
    rectangle(result, point_matchLoc, point, s2, 2, 8, 0);

    delete_Point(pt_minLoc);
    delete_Point(pt_maxLoc);
end

matplot(img_display);
title("Template matching");

delete_Mat(img);
delete_Mat(img_template);
delete_Mat(img_display);
delete_Mat(result);

