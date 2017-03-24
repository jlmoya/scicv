// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

%inline %{
typedef std::vector<cv::Point> PtList;
typedef std::vector<PtList> PtLists;
%}


%inline %{

namespace cv {
   class KeyPoint;
}

typedef std::vector<cv::KeyPoint> KeyPoints;
%}
