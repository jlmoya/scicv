scicv_Init();

img = imread('data/images/Puffin.png');

templ = imread('data/images/puffineTemplate.png');
img_display = new_Mat();
img_display = Mat_clone(img);
result_cols = Mat_cols_get(img)+Mat_cols_get(templ)+1;
result_rows = Mat_rows_get(img)-Mat_rows_get(templ)+1;
result = new_Mat(result_rows, result_cols, CV_8UC3);

//match_method=[CV_TM_SQDIFF, CV_TM_SQDIFF_NORMED, CV_TM_CCOEFF, CV_TM_CCOEFF_NORMED, CV_TM_CCORR, CV_TM_CCORR_NORMED];
match_method = [4, 5, 1, 0, 2, 3];

s1 = [0, 255, 0];
s2 = [255, 0, 0];

for k=1:6
    result = matchTemplate(img_display, templ, match_method(k));
    result = normalize(result, 0, 1, NORM_MINMAX, -1);
    minLoc = new_Point();
    maxLoc = new_Point();

    minVal = new_double_array(1);
    maxVal = new_double_array(1);

    minMaxLoc(result, minVal, maxVal, minLoc, maxLoc, new_Mat());
    matchLoc = new_Point();
    if (match_method(k) == CV_TM_SQDIFF | match_method(k) == CV_TM_SQDIFF_NORMED)
        matchLoc = minLoc;
    else
        matchLoc = maxLoc;
    end

    p2 = new_Point(Point_x_get(matchLoc) + Mat_cols_get(templ), Point_y_get(matchLoc) + Mat_rows_get(templ));

    // conversion Point(x, y) <--> [x y])
    point = [ Point_x_get(p2), Point_y_get(p2)] ;
    Point_matchLoc = [Point_x_get(matchLoc),Point_y_get(matchLoc)];

    rectangle(img_display, Point_matchLoc, point, s1, 2, 8, 0);
    rectangle(result, Point_matchLoc, point, s2, 2, 8, 0);
end

matplot(img);
title('matching template');

